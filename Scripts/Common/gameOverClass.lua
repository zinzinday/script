--[[
	Class: Game Over v0.1
	Author: SurfaceS
	Goal : return the GameOver state
	
	Todo : find a way for the map "The Crystal Scar"

	USAGE :
	Add gameOver() to your OnLoad() script or __init class

	gameOver:gameIsOver() will return true/false and update if needed
	gameOver.looser will return the TEAM_ that loose if gameIsOver
	gameOver.winner will return the TEAM_ that win if gameIsOver
	
	v0.1				BoL Studio Version Class
]]

require "mapClass" -- required class -> to remove when class added in BoL
class 'gameOver'
gameOver.objects = {}
gameOver.isOver = false
gameOver.looser = 0
gameOver.winner = 0
gameOver.needCheck = false
gameOver.nextUpdate = 0
gameOver.tickUpdate = 500	-- update each 0.5 sec

function gameOver:gameIsOver()
	if gameOver.needCheck then
		local tick = GetTickCount()
		if gameOver.nextUpdate > tick then return end
		gameOver.nextUpdate = tick + gameOver.tickUpdate
		for i, objectCheck in pairs(gameOver.objects) do
			if objectCheck.object == nil or objectCheck.object.dead or objectCheck.object.health == 0 then
				gameOver.isOver = true
				gameOver.looser = objectCheck.team
				gameOver.winner = (objectCheck.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
				gameOver.needCheck = false
				break
			end
		end
	end
	return gameOver.isOver
end

function gameOver:__init()
	if (# gameOver.objects == 0) then
		map()
		if (map.index == 1 or map.index == 2 or map.index == 3) then
			gameOver.objectName = "obj_HQ"
			for i = 1, objManager.maxObjects, 1 do
				local object = objManager:getObject(i)
				if object ~= nil and object.type == gameOver.objectName then 
					table.insert(gameOver.objects, { object = object, team = object.team })
				end
			end
			gameOver.needCheck = (# gameOver.objects > 0)
		end
	end
end


--UPDATEURL=
--HASH=2430D27E4F5E3800AC32A90073DFB3B9
