--[[
    AdvancedCallback - OnReady 1.0 by Husky
    ========================================================================

    This is a plugin for the AdvancedCallback library.

    It adds a callback named OnReady, that gets triggered when you are able
    to move, buy and cast stuff the first time.

    Hint: It only gets triggered once every game so it can be used for
    building scripts that make you move and buy stuff at the beginning
    automatically, to give yourself a headstart (for invading the enemy
    jungle for example).


    Registered Callbacks
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- gets triggered once every game when you are able to move/buy/cast stuff
    OnReady()


    Changelog
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1.0     - initial release with the most important features
]]

_ENV = AdvancedCallback:register('OnReady')

function OnTick()
    if myHero:CanUseSpell(SUMMONER_1) == READY then
        if AdvancedCallback:getSetting('OnReady:lastGameStartTime') ~= tonumber(string.format("%.0f", os.time() - GetGameTimer())) then
            AdvancedCallback:OnReady()
        end

        AdvancedCallback:setSetting('OnReady:lastGameStartTime', tonumber(string.format("%.0f", os.time() - GetGameTimer())))
        AdvancedCallback:unregister('OnReady')
    end
end
