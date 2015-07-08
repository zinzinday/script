--[[
	Library: predictMovement v0.1
	Author: SurfaceS
	
	required libs : 		-
	exposed variables : 	predictMovement
	
	UPDATES :
	v0.1				initial release
	v0.2				BoL Studio Version
	
	USAGE :
	Load the libray from your script
	Add predictMovement.OnLoad() to your script OnLoad() function
	Add predictMovement.OnTick() to your script OnTick() function
		predictMovement.heroPosition(iHero, ms) will return the iHero pos in x ms
]]

predictMovement = {
	champions = {},
	tick = 0,
	tickDelay = 1,
	nextUpdate = 0,
	tickUpdate = 200,		-- update each 0.2 sec
}

function predictMovement.OnLoad()
	for i = 1, heroManager.iCount do
		local hero = heroManager:getHero(i)
		if hero ~= nil then
			predictMovement.champions[i] = {
				last = { x = hero.x, y = hero.y, z = hero.z },
				velocity = { x = 0, y = 0, z = 0 },
				hero = hero,
			}
		end
	end
end

function predictMovement.updatePositions()
	for index,champion in pairs(predictMovement.champions) do
		if champion.hero ~= nil and champion.hero.dead == false and champion.hero.visible then
			champion.velocity = { x = champion.hero.x - champion.last.x, y = champion.hero.y - champion.last.y, z = champion.hero.z - champion.last.z }
			champion.last = { x = champion.hero.x, y = champion.hero.y, z = champion.hero.z }
		end
	end
end

function predictMovement.heroPosition(iHero, ms)
	if predictMovement.champions[iHero] then
		local heroPosition = {}
		heroPosition.x = predictMovement.champions[iHero].last.x + (predictMovement.champions[iHero].velocity.x * ((1/predictMovement.tickDelay) * ms))
		heroPosition.y = predictMovement.champions[iHero].last.y + (predictMovement.champions[iHero].velocity.y * ((1/predictMovement.tickDelay) * ms))
		heroPosition.z = predictMovement.champions[iHero].last.z + (predictMovement.champions[iHero].velocity.z * ((1/predictMovement.tickDelay) * ms))
		return heroPosition
	end
end

function predictMovement.OnTick()
	local tick = GetTickCount()
	if tick < predictMovement.nextUpdate then return end
	predictMovement.nextUpdate = tick + predictMovement.tickUpdate
	predictMovement.tickDelay = tick - predictMovement.tick
	predictMovement.tick = tick
	predictMovement.updatePositions()
end

--UPDATEURL=
--HASH=5981D7D968153AEE0640999318972903
