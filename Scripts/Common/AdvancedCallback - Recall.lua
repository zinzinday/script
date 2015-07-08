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
]]

_ENV = AdvancedCallback:register('OnRecall', 'OnAbortRecall', 'OnFinishRecall')

local recallTimes = {
    Recall = { Time = 8000, Start = 208, Finish = 216 },
    RecallImproved = { Time = 7000, Start = 213, Finish = 220 },
    OdinRecall = { Time = 4500, Start = 210, Finish = 218 }, 
    OdinRecallImproved = { Time = 4000, Start = 212, Finish = 219 }
}

function OnRecvPacket(p)
    if p.header == 34 then
	    p.pos = 55
        local sourceNetworkId = PacketDecryptF(p:DecodeF(), _baa)
		p.pos = 80
		local number = p:Decode1()
		--PrintChat(tostring(number))
        local hero = objManager:GetObjectByNetworkId(sourceNetworkId)

		
        if hero and hero.valid and (hero.visible or IsDDev()) then
			local name = hero:GetSpellData(RECALL).name
            local callbackResult
			
			if number == recallTimes[name]['Start'] then
				callbackResult = AdvancedCallback:OnRecall(hero, recallTimes[name]['Time'])
			elseif number == recallTimes[name]['Finish'] then
				callbackResult = AdvancedCallback:OnFinishRecall(hero)
			else
				callbackResult = AdvancedCallback:OnAbortRecall(hero)
			end
			
			if callbackResult == false then p:Block() end
		
		end
	end
end
 
