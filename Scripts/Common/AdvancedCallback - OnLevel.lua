_ENV =  AdvancedCallback:register('OnLevelUp', 'OnLevelUpSpell')

function OnRecvPacket(p)

	if p.header == 0x3E then 
		local unit = objManager:GetObjectByNetworkId(p:DecodeF())
		if unit == nil then return end
		local level = p:Decode1()
		local remainingLevelPoints = p:Decode1()
		AdvancedCallback:OnLevelUp( unit, level, remainingLevelPoints )
		return
	end
	
	if p.header == 0x15 then
		p.pos = 1
		local unit = objManager:GetObjectByNetworkId(p:DecodeF())
		if unit == nil then return end
		local spellId = p:Decode1()
        local level = p:Decode1()
		local remainingLevelPoints = p:Decode1()
		AdvancedCallback:OnLevelUpSpell( unit, spellId, level, remainingLevelPoints)
		return
	end
end
	
