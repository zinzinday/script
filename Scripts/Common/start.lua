--[[
    Script: Start Lib v0.2
    Author: SurfaceS
	Goal : save the start values
	
	Required libs : 		none
	Exposed variables : 	start, file_exists
	
	USAGE :
	Load the libray from your script
	Add start.OnLoad() to your script/library OnLoad() function
	
	v0.1			initial release
	v0.1b			added system clock (lol is based on day)
	v0.2			BoL Studio Version
]]

if start ~= nil then return end
-- need to be moved some day in a lib
if file_exists == nil then
	function file_exists(path)
		local file = io.open(path, "rb")
		if file then file:close() end
		return file ~= nil
	end
end

start = {
	save = {},
	gameStarted = false,
}

function start.OnLoad()
	if start.tick ~= nil then return end
	-- init values
	start.window = {W=tonumber((WINDOW_W ~= nil and WINDOW_W or 0)),H=tonumber((WINDOW_H ~= nil and WINDOW_H or 0))}
	start.tick = tonumber(GetTickCount())
	start.osTime = os.time(t)
	start.teamEnnemy = tonumber((TEAM_ENEMY ~= nil and TEAM_ENEMY or 0))
	if file_exists(start.configFile) then dofile(start.configFile) end

	for i = 1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Minion" and string.find(object.name,"Minion_T") then 
			start.gameStarted = true
			break
		end
	end

	if start.save.osTime ~= nil and (start.save.osTime > (start.osTime - 120) or start.gameStarted) then
		start.window.W = start.save.window.W
		start.window.H = start.save.window.H
		start.tick = start.save.tick
		start.teamEnnemy = start.save.teamEnnemy
	else
		start.file = io.open(start.configFile, "w")
		if start.file then
			start.file:write("start.save.osTime = "..start.osTime.."\n")
			start.file:write("start.save.window = { W="..start.window.W..", H="..start.window.H.." }\n")
			start.file:write("start.save.tick = "..start.tick.."\n")
			start.file:write("start.save.teamEnnemy = "..start.teamEnnemy.."\n")
			
			start.file:close()
		end
		start.file = nil
	end
	start.save = nil
	start.gameStarted = nil
	start.configFile = nil
end

--UPDATEURL=
--HASH=912308A71D88C3EE78DCBAA1009BCAC8
