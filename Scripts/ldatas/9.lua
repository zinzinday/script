--[[
    AdvancedCallback - Recall 1.0 by Husky
    ========================================================================

    This is a plugin for the AdvancedCallback library.

    It adds callbacks related to heros recalling that get triggered whenever
    a champion starts, aborts or finishes a recall.


    Registered Callbacks
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- gets triggered when somebody starts to recall (returning false will
    -- prevent the event from being processed by the client)
    OnRecall(hero, channelTimeInMs)

    -- get triggered when somebody aborts a recall (returning false will
    -- prevent the event from being processed by the client)
    OnAbortRecall(hero)

    -- gets triggered when somebody finishes a recall (returning false will
    -- prevent the event from being processed by the client)
    OnFinishRecall(hero)


    Changelog
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1.0     - initial release with the most important features
    1.1     - fix nil value errors and fix finished teleport trigger
]]

_ENV = AdvancedCallback:register('OnRecall', 'OnAbortRecall', 'OnFinishRecall')

local recallTimes = {
    Recall = 8000,
    RecallImproved = 7000,
    OdinRecall = 4500,
    OdinRecallImproved = 4000
}


local recallTable = {} -- this check is done because finished teleport gives the same finish values

function OnRecvPacket(p)
    if p.header == 0xD7 then
        p.pos = 5
        local sourceNetworkId = p:DecodeF()
        p.pos = 112
        local number = p:Decode1()
        local hero = objManager:GetObjectByNetworkId(sourceNetworkId)
        
        if hero and hero.valid and (hero.visible or IsDDev()) then
            local callbackResult        
            if number == 6  then
                recallTable[hero.networkID] = (os.clock() + recallTimes[hero:GetSpellData(RECALL).name]/1000)
                callbackResult = AdvancedCallback:OnRecall(hero, recallTimes[hero:GetSpellData(RECALL).name])
            elseif number == 4 and recallTable[hero.networkID] ~= nil then
                local time = os.clock() - recallTable[hero.networkID]
                if math.abs(os.clock() - recallTable[hero.networkID]) <= 10^-1 then 
                    callbackResult = AdvancedCallback:OnFinishRecall(hero)
                    recallTable[hero.networkID] = nil
                else
                    callbackResult = AdvancedCallback:OnAbortRecall(hero)
                    recallTable[hero.networkID] = nil
                end
            end
            
            if callbackResult == false then p:Block() end
        end
    end
end
 