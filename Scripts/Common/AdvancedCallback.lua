--[[
    AdvancedCallback 1.3 by Husky
    ========================================================================

    This library povides a framework for adding custom callbacks.

    Bot of Legends itself only provides callbacks for the very basic events
    of the executable. It does not focus on actual ingame events which makes
    it pretty hard to write certain scripts that try to react on these kind
    of events. You usually have to monitor a lot of objects and packets to
    know what is actually happening in the game.

    The problem with that approach is not only the scripts getting huge and
    complicated but also the fact that every script is doing the same
    analyses over and over again, which consumes a lot of computing power and
    noticeably reduces frames per second on low end computers.

    This library fixes this problem by allowing the definition of actual
    ingame event callbacks like OnAttack, OnLevelUp, OnKill, OnLasthit,
    OnAssist, OnRespawn, OnDie and so on.

    This library does not provide any additional callbacks itself but offers a
    way to define them.

    New callbacks are added as additional libraries (like plugins) that only
    get executed if a script uses one of their callbacks.


    Methods
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- registers new callbacks; it returns an environment that can be assigned
    -- to _ENV and used for defining the script
    AdvancedCallback:register('<callbackName>' [, <callbackName> ...])

    -- removes previously registered callbacks
    AdvancedCallback:unregister('<callbackName>' [, <callbackName> ...])

    -- dynamically binds a function to a callback
    AdvancedCallback:bind(callbackName, callable)

    -- globally triggers the callback in any script that defined a function with
    -- that name
    AdvancedCallback:<callbackName>()

    -- stores a setting, that persists even after closing the game
    AdvancedCallback:setSetting('<settingName>' <value>)

    -- retrieves a stored setting (including an optional default value)
    AdvancedCallback:getSetting('<settingName>' [, <defaultValue>])


    Changelog
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1.0     - initial release with the most important features

    1.1     - fixed a problem with custom callbacks not working after reload

    1.2     - added the ability to add callbacks dynamically (see bind)

    1.3     - added support for event blocking by collecting callback results
]]

class 'AdvancedCallback' -- {

    local availableMetaCallbacks = {
        ['AddLoadCallback'] = 'OnLoad',
        ['AddUnloadCallback'] = 'OnUnload',
        ['AddTickCallback'] = 'OnTick',
        ['AddDrawCallback'] = 'OnDraw',
        ['AddChatCallback'] = 'OnSendChat',
        ['AddMsgCallback']  = 'OnWndMsg',
        ['AddCreateObjCallback'] = 'OnCreateObj',
        ['AddDeleteObjCallback'] = 'OnDeleteObj',
        ['AddBugsplatCallback'] = 'OnBugsplat',
        ['AddResetCallback'] = 'OnReset',
        ['AddProcessSpellCallback'] = 'OnProcessSpell',
        ['AddSendPacketCallback'] = 'OnSendPacket',
        ['AddRecvPacketCallback'] = 'OnRecvPacket',
        ['AddAnimationCallback'] = 'OnAnimation'
    }

    function AdvancedCallback:__init()
        self.registeredCallbacks = {}
        self.activeCallbacks = {}
        self.metaCallbacks = {}

        AddTickCallback(
            function()
                if _G.AdvancedCallback.loaded == false then _G.AdvancedCallback:load() end
            end
        )

        local loadedTable, error = Serialization.loadTable(SCRIPT_PATH .. 'Common/AdvancedCallback.settings.lua')

        self.settings = error and {} or loadedTable
    end

    function AdvancedCallback:register(...)
        callbackDefinition = setmetatable({}, {__index = _G})

        for k, callbackName in pairs({...}) do
            self.registeredCallbacks[callbackName] = callbackDefinition
            if not self.activeCallbacks[callbackName] then
                self.activeCallbacks[callbackName] = {}
            end

            self[callbackName] = function(self, ...)
                local callbackResult = true

                for i, callback in ipairs(self.activeCallbacks[callbackName]) do
                    if callback(...) == false then
                        callbackResult = false
                    end
                end

                return callbackResult
            end

            if _G.AdvancedCallback.loaded == true then
                self:loadCallback(callbackName, callbackDefinition)
            end
        end

        return callbackDefinition
    end

    function AdvancedCallback:unregister(...)
        for k, callbackName in pairs({...}) do
            for callbackAddFunction, availableMetaCallback in pairs(availableMetaCallbacks) do
                if self.registeredCallbacks[callbackName][availableMetaCallback] then
                    for i, metaCallback in ipairs(self.metaCallbacks[availableMetaCallback]) do
                        if metaCallback == self.registeredCallbacks[callbackName][availableMetaCallback] then
                            table.remove(self.metaCallbacks[availableMetaCallback], i)

                            i = i - 1
                        end
                    end
                end
            end

            self[callbackName] = nil
            self.activeCallbacks[callbackName] = nil
            self.registeredCallbacks[callbackName] = nil
        end
    end

    function AdvancedCallback:bind(callbackName, callable)
        if not self.activeCallbacks[callbackName] then
            self.activeCallbacks[callbackName] = {callable}
        else
            table.insert(self.activeCallbacks[callbackName], callable)
        end
    end

    function AdvancedCallback:setSetting(settingName, value)
        self.settings[settingName] = value

        Serialization.saveTable(self.settings, SCRIPT_PATH .. 'Common/AdvancedCallback.settings.lua')
    end

    function AdvancedCallback:getSetting(settingName, defaultValue)
        return self.settings[settingName] or defaultValue
    end

    function AdvancedCallback:load()
        for callbackAddFunction, availableMetaCallback in pairs(availableMetaCallbacks) do
            self.metaCallbacks[availableMetaCallback] = {}

            if _G[callbackAddFunction] then
                _G[callbackAddFunction](
                    function(...)
                        for i, callback in ipairs(_G.AdvancedCallback.metaCallbacks[availableMetaCallback]) do
                            callback(...)
                        end
                    end
                )
            end
        end

        for callbackName, callbackDefinition in pairs(self.registeredCallbacks) do
            self:loadCallback(callbackName, callbackDefinition)
        end

        _G.AdvancedCallback.loaded = true
    end

    function AdvancedCallback:loadCallback(callbackName, callbackDefinition)
        for scriptName, environment in pairs(_G.environment) do
            if environment[callbackName] and type(environment[callbackName]) == 'function' then
                table.insert(self.activeCallbacks[callbackName], environment[callbackName])
            end

            if not callbackDefinition.processed and #self.activeCallbacks[callbackName] >= 1 then
                for callbackAddFunction, metaCallback in pairs(availableMetaCallbacks) do
                    if callbackDefinition[metaCallback] then
                        table.insert(self.metaCallbacks[metaCallback], callbackDefinition[metaCallback])
                    end
                end

                if callbackDefinition.OnLoad then
                    callbackDefinition.OnLoad()
                end

                callbackDefinition.processed = true
            end
        end
    end
-- }

_G.AdvancedCallback = AdvancedCallback()

AddLoadCallback(function()
    _G.AdvancedCallback.loaded = false
end)
