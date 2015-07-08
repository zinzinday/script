--[[
	Library: championLane Lib v0.1
	Author: SurfaceS
	Goal : return the lanes for champion
	
	Required libs : 		start, map, GetDistance2D
	Exposed variables : 	championLane

	v0.1		initial release
	v0.2		BoL Studio Version
	
	USAGE :
	Load the libray from your script
	Add championLane.OnLoad() to your script OnLoad() function
	Add championLane.OnTick() to your script OnTick() function
	exemple of use :
		championLane.myLane return your lane (top, mid, bot, jungle, unknow)
		championLane.ennemy.champions return the array of ennemy champions
		championLane.ennemy.champions[x].hero return the hero object of ennemy x
		championLane.ennemy.bot return the array of ennemy hero on bot lane
		championLane.ennemy.bot[x] return the hero object of ennemy x on bot lane
		championLane.ennemy.carryAD return the hero object of ennemy carry AD
]]

require "common"
require "start"
require "map"

championLane = {
	heros = {},
	ennemy = { champions = {}, top = {}, mid = {}, bot = {}, jungle = {}, unknow = {} },
	ally = { champions = {}, top = {}, mid = {}, bot = {}, jungle = {}, unknow = {} },
	myLane = "unknow",
	nextUpdate = 0,
	tickUpdate = 250,		-- update each 0.25 sec
}

-- init values
function championLane.OnLoad()
	if championLane.startTime ~= nil then return end
	map.OnLoad()
	start.OnLoad()
	for i = 1, heroManager.iCount, 1 do
		local hero = heroManager:getHero(i) 
		if hero ~= nil then
			table.insert(championLane.heros, hero)
			local isJungler = (string.find(hero:GetSpellData(SUMMONER_1).name..hero:GetSpellData(SUMMONER_2).name, "Smite") and true or false)
			table.insert(championLane[(hero.team == player.team and "ally" or "ennemy")].champions, {hero = hero, top = 0, mid = 0, bot = 0, jungle = 0, isJungler = isJungler})
		end
	end
	if map.index == 1 or map.index == 2 then
		championLane.startTime = start.tick + 120000 --2 min from start
		championLane.stopTime = start.tick + 600000 --10 min from start
		if map.index == 1 then
			championLane.top = {point = {x = 1900, y = 0, z = 12600} }
			championLane.mid = {point = {x = 7100, y = 0, z = 7100} }
			championLane.bot = {point = {x = 12100, y = 0, z = 2100} }
		elseif map.index == 2 then
			championLane.top = {point = {x = 6700, y = 0, z = 7100} }
			championLane.bot = {point = {x = 6700, y = 0, z = 3100} }
		end
		function championLane.findChampionLane(champion)
			local lane
			if champion.top > champion.mid and champion.top > champion.bot and champion.top > champion.jungle then
				lane = "top"
			elseif champion.mid > champion.bot and champion.mid > champion.jungle then
				lane = "mid"
			elseif champion.bot > champion.jungle then
				lane = "bot"
			elseif champion.jungle > 0 then
				lane = "jungle"
			else
				lane = "unknow"
			end
			return lane
		end
		function championLane.heroUpdatePos(champion)
			if champion.hero.dead == false then
				if champion.hero.visible then
					if GetDistance2D(championLane.top.point, champion.hero) < 2000 then champion.top = champion.top + 10 end
					if championLane.mid ~= nil and GetDistance2D(championLane.mid.point, champion.hero) < 2000 then champion.mid = champion.mid + 10 end
					if GetDistance2D(championLane.bot.point, champion.hero) < 2000 then champion.bot = champion.bot + 10 end
				else
					champion.jungle = champion.jungle + 1
				end
				if champion.isJungler then champion.jungle = champion.jungle + 5 end
			end
		end
		function championLane.teamUpdate(team)
			local update = {top = {}, mid = {}, bot = {}, jungle = {}, unknow = {} }
			for i, champion in pairs(championLane[team].champions) do
				championLane.heroUpdatePos(champion)
				local lane = championLane.findChampionLane(champion)
				table.insert(update[lane], champion.hero)
				if champion.hero.networkID == player.networkID then
					championLane.myLane = lane
				end
			end
			championLane[team].top = update.top
			championLane[team].mid = update.mid
			championLane[team].bot = update.bot
			championLane[team].jungle = update.jungle
			if map.index == 1 then
				-- update carry / support
				local carryAD = nil
				local support = nil
				for i, hero in pairs(championLane[team].bot) do
					if carryAD == nil or hero.totalDamage > carryAD.totalDamage then carryAD = hero end
					if support == nil or hero.totalDamage < support.totalDamage then support = hero end
				end
				championLane[team].carryAD = carryAD
				championLane[team].support = support
			end
		end
		function championLane.OnTick()
			local tick = GetTickCount()
			if tick < championLane.startTime or tick > championLane.stopTime or tick < championLane.nextUpdate then return end
			championLane.nextUpdate = tick + championLane.tickUpdate
			championLane.teamUpdate("ennemy")
			championLane.teamUpdate("ally")
		end
	end
end
-- do not remove
function championLane.OnTick() end

--UPDATEURL=
--HASH=F235EBAB0182BC34BB0F042A65B6C8B6
