--[[
	exhaust library v0.2c
	Script by SurfaceS
]]

-- for those who not use loader.lua
if myHero == nil then myHero = GetMyHero() end

--[[		Config		]]
exhaust = {}
exhaust.range = 550

--[[ 		Globals		]]
exhaust.slot = nil
exhaust.lastUse = 0

--[[ 		Code		]]
function exhaust.autoExhaust()
	if exhaust.ready() then
		local maxDPShero = nil
		local maxDPS = 0
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.team ~= myHero.team and not hero.dead and hero.visible and myHero:GetDistance(hero) <= exhaust.range then
				local dps = hero.totalDamage * hero.attackSpeed
				if maxDPShero == nil or maxDPS < dps then
					maxDPS = dps
					maxDPShero = hero
				end
			end
		end
		if maxDPShero ~= nil then
			return exhaust.exhaustTarget( maxDPShero )
		end
	end
	return nil
end

function exhaust.ready()
	if exhaust.slot ~= nil and exhaust.lastUse < GetTickCount() and myHero:CanUseSpell(exhaust.slot) == READY then return true end
	return false
end

function exhaust.exhaustTarget(target)
	if exhaust.ready() then
		CastSpell(exhaust.slot, target)
		PrintChat("> exhaust on "..target.name)
		exhaust.lastUse = GetTickCount() + 500
		return target
	end
	return nil
end

if string.find(myHero:GetSpellData(SUMMONER_1).name, "SummonerExhaust") then
	exhaust.slot = SUMMONER_1
elseif string.find(myHero:GetSpellData(SUMMONER_2).name, "SummonerExhaust") then
	exhaust.slot = SUMMONER_2
else
	exhaust = nil
end

--UPDATEURL=
--HASH=1E83824E18F059E4B9630901F74BFAE4
