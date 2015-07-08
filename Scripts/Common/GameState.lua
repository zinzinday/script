--[[
        Class: GameState
		
		Handle map, gameOver and start libs
		
		API :
		---- Call ----
		GameState()					-- return gameState instance
		
		---- GameState Members ----

		gameState.map.index 		-- 1-4 (0 mean not found)
		gameState.map.name 			-- return you the full map name
		gameState.map.shortName 	-- return you the shorted map name (usefull for using it in table)
		gameState.map.min {x, y} 	-- return min map x, y
		gameState.map.max{x, y} 	-- return max map x, y
		gameState.map{x, y} 		-- return map size x, y
		
		gameState.looser			-- return the looser team if gameOver
		gameState.winner			-- return the winner team if gameOver
		
		gameState.start.tick		-- saved game start tick
		gameState.start.osTime		-- saved game start osTime
		gameState.start.teamEnnemy	-- saved game start teamEnnemy
		gameState.start.window.W	-- saved game start window W
		gameState.start.window.H	-- saved game start window H
		
		---- GameState Functions ----
		gameState:gameOver()		-- return if game is over
]]

-- need to be moved some day in common lib
if file_exists == nil then
	function file_exists(path)
		local file = io.open(path, "rb")
		if file then file:close() end
		return file ~= nil
	end
end

--Globals
_map = {index = 0, name = "unknown", shortName = "unknown", min = {x = 0, y = 0}, max = {x = 0, y = 0}, x = 0, y = 0}
_gameOver = {objects = {}, isOver = false, looser = 0, winner = 0, nextUpdate = 0, tickUpdate = 500}
_start = {}

class 'GameState'

function GameState:__init()
	GameState:_map_init()
	self.map = _map
	GameState:_gameOver_init()
	GameState:_start_init()
	self.start = _start
end

function GameState:_map_init()
	if _map.index ~= 0 then return end
	for i = 1, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil then
			if object.type == "obj_Shop" and object.team == TEAM_BLUE then
				if math.floor(object.x) == -175 and math.floor(object.y) == 163 and math.floor(object.z) == 1056 then
					_map = {index = 1, name = "Summoner's Rift", shortName = "summonerRift", min = {x = -538, y = -165}, max = {x = 14279, y = 14527}, x = 14817, y = 14692}
					break
				elseif math.floor(object.x) == -217 and math.floor(object.y) == 276 and math.floor(object.z) == 7039 then		--ok
					_map = {index = 2, name = "The Twisted Treeline", shortName = "twistedTreeline", min = {x = -996, y = -1239}, max = {x = 14120, y = 13877}, x = 15116, y = 15116}
					break
				elseif math.floor(object.x) == 556 and math.floor(object.y) == 191 and math.floor(object.z) == 1887 then		--ok
					_map = {index = 3, name = "The Proving Grounds", shortName = "provingGrounds", min = {x = -56, y = -38}, max = {x = 12820, y = 12839}, x = 12876, y = 12877}
					break
				elseif math.floor(object.x) == 16 and math.floor(object.y) == 168 and math.floor(object.z) == 4452 then
					_map = {index = 4, name = "The Crystal Scar", shortName = "crystalScar", min = {x = -15, y = 0}, max = {x = 13911, y = 13703}, x = 13926, y = 13703}
					break
				end
			end
		end
	end

end

function GameState:_gameOver_init()
	if (# _gameOver.objects == 0) then
		if (_map.index == 1 or _map.index == 2 or _map.index == 3) then
			local objectName = "obj_HQ"
			for i = 1, objManager.maxObjects, 1 do
				local object = objManager:getObject(i)
				if object ~= nil and object.type == objectName then
					table.insert(_gameOver.objects, { object = object, team = object.team })
				end
			end
			-- to check
			_gameOver.needCheck = (# _gameOver.objects > 0)
		end
	end
end

function GameState:_start_init()
	if _start.tick ~= nil then return end
	-- init values
	local configFile = debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2).."GameState.cfg"
	local gameStarted = false
	_start.window = {W=tonumber((WINDOW_W ~= nil and WINDOW_W or 0)),H=tonumber((WINDOW_H ~= nil and WINDOW_H or 0))}
	_start.tick = tonumber(GetTickCount())
	_start.osTime = os.time(t)
	_start.teamEnnemy = tonumber((TEAM_ENEMY ~= nil and TEAM_ENEMY or 0))
	_start.saved = {}
	if file_exists(configFile) then dofile(configFile) end

	for i = 1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Minion" and (string.find(object.name,"Minion_T") or string.find(object.name,"Blue")) then 
			gameStarted = true
			break
		end
	end

	if _start.saved.osTime ~= nil and (_start.saved.osTime > (_start.osTime - 120) or gameStarted) then
		_start.window.W = _start.saved.window.W
		_start.window.H = _start.saved.window.H
		_start.tick = _start.saved.tick
		_start.teamEnnemy = _start.saved.teamEnnemy
		_start.osTime = _start.saved.osTime
	else
		local file = io.open(configFile, "w")
		if file then
			file:write("_start.saved.osTime = ".._start.osTime.."\n")
			file:write("_start.saved.window = { W=".._start.window.W..", H=".._start.window.H.." }\n")
			file:write("_start.saved.tick = ".._start.tick.."\n")
			file:write("_start.saved.teamEnnemy = ".._start.teamEnnemy.."\n")
			file:close()
		end
		file = nil
	end
	_start.saved = nil
end

function GameState:gameOver()
	if _gameOver.needCheck then
		local tick = GetTickCount()
		if _gameOver.nextUpdate > tick then return end
		_gameOver.nextUpdate = tick + _gameOver.tickUpdate
		for i, objectCheck in pairs(_gameOver.objects) do
			if objectCheck.object == nil or objectCheck.object.dead or objectCheck.object.health == 0 then
				_gameOver.isOver = true
				_gameOver.looser = objectCheck.team
				_gameOver.winner = (objectCheck.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
				_gameOver.needCheck = false
				break
			end
		end
	end
	if _gameOver.isOver and self.looser == 0 then
		self.looser = _gameOver.looser
		self.winner = _gameOver.winner
	end
	return _gameOver.isOver
end



--UPDATEURL=
--HASH=57F4C4E86874D304716A29E286DBBDF8
