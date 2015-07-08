--[[
	Class: Map v0.1
	Author: SurfaceS
	
	USAGE :
	Add map() to your OnLoad() script or __init class
	
	map.index = 1-4 (0 mean not found)
	map.name -> return you the full map name
	map.shortName -> return you the shorted map name (usefull for using it in table)
	map.min {x, y} -> return min map x, y
	map.max{x, y} -> return max map x, y
	map{x, y} -> return map size x, y
]]

class 'map'
map.index = 0
map.name = "unknown"
map.shortName = "unknown"
map.min = {x = 0, y = 0}
map.max = {x = 0, y = 0}
map.x = 0
map.y = 0
function map:__init()
	if map.index ~= 0 then return end
	for i = 1, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil then
			if object.type == "obj_Shop" and object.team == TEAM_BLUE then
				if math.floor(object.x) == -175 and math.floor(object.y) == 163 and math.floor(object.z) == 1056 then
					map.index = 1
					map.name = "Summoner's Rift"
					map.shortName = "summonerRift"
					map.min = {x = -538, y = -165}
					map.max = {x = 14279, y = 14527}
					map.x, map.y = 14817, 14692
					break
				elseif math.floor(object.x) == -217 and math.floor(object.y) == 276 and math.floor(object.z) == 7039 then		--ok
					map.index = 2
					map.name = "The Twisted Treeline"
					map.shortName = "twistedTreeline"
					map.min = {x = -996, y = -1239}
					map.max = {x = 14120, y = 13877}
					map.x, map.y = 15116, 15116
					break
				elseif math.floor(object.x) == 556 and math.floor(object.y) == 191 and math.floor(object.z) == 1887 then		--ok
					map.index = 3
					map.name = "The Proving Grounds"
					map.shortName = "provingGrounds"
					map.min = {x = -56, y = -38}
					map.max = {x = 12820, y = 12839}
					map.x, map.y = 12876, 12877
					break
				elseif math.floor(object.x) == 16 and math.floor(object.y) == 168 and math.floor(object.z) == 4452 then
					map.index = 4
					map.name = "The Crystal Scar"
					map.shortName = "crystalScar"
					map.min = {x = -15, y = 0}
					map.max = {x = 13911, y = 13703}
					map.x, map.y = 13926, 13703
					break
				end
			end
		end
	end	
end

--UPDATEURL=
--HASH=E87EC0F95B077899A094715436AD6BB7
