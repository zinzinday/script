--[[
	Library: Game Over Lib v0.2
	Author: SurfaceS
	Goal : return the game over state
	
	Todo : find a way for the map "The Crystal Scar"
	
	Required libs : 		map
	Exposed variables : 	gameOver

	USAGE :
	Load the libray from your script
	Add gameOver.OnLoad() to your script OnLoad() function
	Add gameOver.OnTick() to your script OnTick() function OR use the direct function gameOver.gameIsOver()
	
	v0.1				initial release
	v0.2				BoL Studio Version
]]

if gameOver ~= nil then return end
require "map"

gameOver = {
	objects = {},
	isOver = false,
	looser = 0,
	winner = 0,
	objectFounded = 0,
	nextUpdate = 0,
	tickUpdate = 500,		-- update each 0.5 sec
}

function gameOver.OnLoad()
	map.OnLoad()
	if map.index == 1 or map.index == 2 or map.index == 3 then
		gameOver.objectName = "obj_HQ"
		for i = 1, objManager.maxObjects, 1 do
			local object = objManager:getObject(i)
			if object ~= nil and object.type == gameOver.objectName then 
				gameOver.objectFounded = gameOver.objectFounded + 1
				gameOver.objects[gameOver.objectFounded] = { object = object, team = object.team }
			end
		end
	end
end

function gameOver.OnTick()
	if gameOver.objectFounded ~= 0 then
		local tick = GetTickCount()
		if gameOver.nextUpdate > tick then return end
		gameOver.nextUpdate = tick + gameOver.tickUpdate
		for i, objectCheck in pairs(gameOver.objects) do
			if objectCheck.object == nil or objectCheck.object.dead or objectCheck.object.health == 0 then
				gameOver.isOver = true
				gameOver.looser = objectCheck.team
				gameOver.winner = (objectCheck.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
				gameOver.tickHandler = nil
				break
			end
		end
	end
end

function gameOver.gameIsOver()
	gameOver.OnTick()
	return gameOver.isOver
end

--UPDATEURL=
--HASH=D48792925B4346A7505ACD51BCC4C972
