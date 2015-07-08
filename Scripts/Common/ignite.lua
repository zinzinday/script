--[[
	ignite library v0.2c
	Script by SurfaceS
]]

-- for those who not use loader.lua
if myHero == nil then myHero = GetMyHero() end

ignite = {}

--[[		Config		]]
ignite.baseDamage = 50
ignite.damagePerLevel = 20
ignite.range = 600

--[[ 		Globals		]]
ignite.slot = nil
ignite.damage = 70
ignite.lastUse = 0

--[[ 		Code		]]
function ignite.ready()
	if ignite.slot ~= nil and ignite.lastUse < GetTickCount() and myHero:CanUseSpell(ignite.slot) == READY then return true end
	return false
end

function ignite.autoIgniteIfKill()
	if ignite.ready() then
		ignite.damage = ignite.baseDamage + ignite.damagePerLevel * myHero.level
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.team ~= myHero.team and not hero.dead and hero.visible and myHero:GetDistance(hero) < ignite.range and hero.health <= ignite.damage then
				return ignite.igniteTarget( hero )
			end
		end
	end
	return nil
end

function ignite.autoIgniteLowestHealth()
	if ignite.ready() then
		ignite.damage = ignite.baseDamage + ignite.damagePerLevel * myHero.level
		local minLifeHero = nil
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.team ~= myHero.team and not hero.dead and hero.visible and myHero:GetDistance(hero) <= ignite.range then
				if minLifeHero == nil or hero.health < minLifeHero.health then
					minLifeHero = hero
				end
			end
		end
		if minLifeHero ~= nil then
			return ignite.igniteTarget( minLifeHero )
		end
	end
	return nil
end

function ignite.igniteTarget(target)
	if ignite.ready() then
		CastSpell(ignite.slot, target)
		ignite.lastUse = GetTickCount() + 500
		return target
	end
	return nil
end

if string.find(myHero:GetSpellData(SUMMONER_1).name, "SummonerDot") ~= nil then
	ignite.slot = SUMMONER_1
elseif string.find(myHero:GetSpellData(SUMMONER_2).name, "SummonerDot") ~= nil then
	ignite.slot = SUMMONER_2
else
	ignite = nil
end

--UPDATEURL=
--HASH=C296EDACD8D641689917E4E804688C86
