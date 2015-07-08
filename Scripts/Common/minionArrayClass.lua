--[[
	Library: minionArray Class v0.1
	Author: SurfaceS

	required classes : 		map
	exposed variables : 	minionArray, GetDistance, player, MINION_ALLY, MINION_ENNEMY, MINION_OTHER
	
	USAGE :
	Add variable = minionArray(mode, range, fromPos) to your script/library OnLoad() function
	Add variable:update() when you want to update
	Add minionArray:OnCreateObj(object) tou your OnCreateObj script
	Add minionArray:OnDeleteObj(object) tou your OnDeleteObj script
]]


--SHOULD BE ON ANOTHER PLACE (COMMON)
player = GetMyHero()
function GetDistance( p1, p2 )
	if p2 == nil then p2 = player end
    if p1.z == nil or p2.z == nil then return math.sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
	else return math.sqrt((p1.x-p2.x)^2+(p1.z-p2.z)^2) end
end

require "mapClass" -- required class -> to remove when class added in BoL

-- Class related constants
MINION_ALLY = 1
MINION_ENNEMY = 2
MINION_OTHER = 3
MINION_SORT_HEALTH_ASC = 1
MINION_SORT_HEALTH_DEC = 2
MINION_SORT_MAXHEALTH_ASC = 3
MINION_SORT_MAXHEALTH_DEC = 4

class 'minionArray'
minionArray.loaded = false
minionArray.team_ally ="##"
minionArray.team_ennemy ="##"
minionArray[MINION_ALLY] = {}
minionArray[MINION_ENNEMY] = {}
minionArray[MINION_OTHER] = {}

function minionArray:OnCreateObj(object)
	if object ~= nil and object.type == "obj_AI_Minion" and not object.dead then
		if minionArray[MINION_ALLY][object.name] ~= nil or minionArray[MINION_ENNEMY][object.name] ~= nil or minionArray[MINION_OTHER][object.name] ~= nil then return end
		if string.find(object.name,minionArray.team_ally) then minionArray[MINION_ALLY][object.name] = object
		elseif string.find(object.name,minionArray.team_ennemy) then minionArray[MINION_ENNEMY][object.name] = object
		else minionArray[MINION_OTHER][object.name] = object
		end
	end
end

function minionArray:OnDeleteObj(object)
	if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
		if minionArray[MINION_ALLY][object.name] ~= nil then minionArray[MINION_ALLY][object.name] = nil end
		
	end
end

function minionArray:__init(mode, range, fromPos, sortMode)
	if minionArray.loaded == false then
		map()
		if map.index ~= 4 then
			minionArray.team_ally = "Minion_T"..player.team
			minionArray.team_ennemy = "Minion_T"..(player.team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
		else
			minionArray.team_ally = (player.team == TEAM_BLUE and "Blue" or "Red")
			minionArray.team_ennemy = (player.team == TEAM_BLUE and "Red" or "Blue")
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			minionArray:OnCreateObj(object)
		end
		minionArray.loaded = true
	end
	self.objects = {}
	self.mode = mode
	self.range = range
	self.fromPos = fromPos or player
	self.sortMode = sortMode
	self.objectCount = 0
	self:update()
end

function minionArray:update()
	self.objects = {}
	for name,object in pairs(minionArray[self.mode]) do
		if object ~= nil and object.dead == false and object.visible and GetDistance(self.fromPos,object) <= self.range then
			table.insert(self.objects, object)
		end
	end
	if self.sortMode ~= nil then
		if self.sortMode == MINION_SORT_HEALTH_ASC then
			table.sort(self.objects, function(a,b) return a.health<b.health end)
		elseif self.sortMode == MINION_SORT_HEALTH_DEC then
			table.sort(self.objects, function(a,b) return a.health>b.health end)
		elseif self.sortMode == MINION_SORT_MAXHEALTH_ASC then
			table.sort(self.objects, function(a,b) return a.maxHealth<b.maxHealth end)
		elseif self.sortMode == MINION_SORT_MAXHEALTH_DEC then
			table.sort(self.objects, function(a,b) return a.maxHealth>b.maxHealth end)
		end
	end
	self.objectCount = # self.objects
end

--UPDATEURL=
--HASH=CD4F50CAA5FC662A71C882E466EEF976
