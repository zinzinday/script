--[[
	
	Script: spellAvoider library v0.1
    Author: barasia283
	
]]

-- for those who not use loader.lua
if myHero == nil then myHero = GetMyHero() end

--[[         Config        ]]
spellAvoider = {}
spellAvoider.globalspacing = 50
spellAvoider.colors = {0x0000FFFF, 0x0000FFFF, 0xFFFFFF00, 0x0000FFFF, 0xFF00FF00}
spellAvoider.dodgeSkillShot = false
spellAvoider.drawSkillShot = true

--[[     GLOBALS     ]]--
spellAvoider.spellFound = false
spellAvoider.spellArray = {}
spellAvoider.moveTo = {}

--[[   Code   ]]


-- ===========================
-- Copy the array portion of the table.
-- ===========================
if CopyArray == nil then
	function CopyArray(t)
		local ret = {}
		for i,v in pairs(t) do
			ret[i] = v
		end
		return ret
	end
end

-- ===========================
-- Round a number
-- ===========================
if round == nil then
	function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult
	end
end

-- ===========================
-- Get Distance on 2D plan
-- ===========================
if GetDistance2D == nil then
	function GetDistance2D( p1, p2 )
		if p1.z == nil or p2.z == nil then
			return math.sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
		else
			return math.sqrt((p1.x-p2.x)^2+(p1.z-p2.z)^2)
		end
	end
end

function spellAvoider.calculateLinepass(pos1, pos2, spacing, maxDist)
    local calc = (math.floor(math.sqrt((pos2.x-pos1.x)^2 + (pos2.z-pos1.z)^2)))
	local line = {}
	local steps = round((maxDist/spacing),0) -1
    for i = 0, steps, 1 do
        local point = {}
        point.x = pos1.x + (maxDist - (i*spacing))/calc*(pos2.x-pos1.x)
        point.y = pos2.y
        point.z = pos1.z + (maxDist - (i*spacing))/calc*(pos2.z-pos1.z)
		table.insert(line, point)
    end
    return line
end

function spellAvoider.calculateLinepoint(pos1, pos2, spacing, maxDist)
    local calc = (math.floor(math.sqrt((pos2.x-pos1.x)^2 + (pos2.z-pos1.z)^2)))
    local line = {}
    local steps
    local averagesteps
    if calc > maxDist then
    	averagesteps = maxDist/spacing
    elseif calc < maxDist then
    	averagesteps = calc/spacing
    end
    steps = round(averagesteps,0) -1
    for i = 0, steps, 1 do
        local point = {}
        if calc > maxDist then
        	point.x = pos1.x + (maxDist - (i*spacing))/calc*(pos2.x-pos1.x)
        	point.y = pos2.y
        	point.z = pos1.z + (maxDist - (i*spacing))/calc*(pos2.z-pos1.z)
        elseif calc <= maxDist then
        	point.x = pos1.x + (calc - (i*spacing))/calc*(pos2.x-pos1.x)
        	point.y = pos2.y
        	point.z = pos1.z + (calc - (i*spacing))/calc*(pos2.z-pos1.z)
        end
        table.insert(line, point)
    end
    return line
end

function spellAvoider.calculateLineaoe(pos1, pos2, maxDist)
    local line = {}
    local point = {}
    point.x = pos2.x
    point.y = pos2.y
    point.z = pos2.z
    table.insert(line, point)
    return line
end

function spellAvoider.calculateLineaoe2(pos1, pos2, maxDist)
	local calc = (math.floor(math.sqrt((pos2.x-pos1.x)^2 + (pos2.z-pos1.z)^2)))
    local line = {}
    local point = {}
    if calc < maxDist then
		point.x = pos2.x
		point.y = pos2.y
		point.z = pos2.z
    else
		point.x = pos1.x + maxDist/calc*(pos2.x-pos1.x)
		point.z = pos1.z + maxDist/calc*(pos2.z-pos1.z)
		point.y = pos2.y
	end
	table.insert(line, point)
    return line
end

function spellAvoider.dodgeAOE(pos1, pos2, radius)
	local distancePos2 = GetDistance2D(myHero, pos2) 
    if distancePos2 < radius then
		spellAvoider.moveTo.x = pos2.x + ((radius+50)/distancePos2)*(myHero.x-pos2.x)
		spellAvoider.moveTo.z = pos2.z + ((radius+50)/distancePos2)*(myHero.z-pos2.z)
		if spellAvoider.dodgeSkillShot then
			myHero:MoveTo(spellAvoider.moveTo.x,spellAvoider.moveTo.z)
		end
    end
end

function spellAvoider.dodgeLinePoint(pos1, pos2, radius)
    local distancePos1 = GetDistance2D(myHero, pos1)
 	local distancePos2 = GetDistance2D(myHero, pos2)
	local distancePos1Pos2 = GetDistance2D(pos1, pos2)
    local perpendicular = (math.floor((math.abs((pos2.x-pos1.x)*(pos1.z-myHero.z)-(pos1.x-myHero.x)*(pos2.z-pos1.z)))/distancePos1Pos2))
    if perpendicular < radius and distancePos2 < distancePos1Pos2 and distancePos1 < distancePos1Pos2 then
		local k = ((pos2.z-pos1.z)*(myHero.x-pos1.x) - (pos2.x-pos1.x)*(myHero.z-pos1.z)) / distancePos1Pos2
		local pos3 = {}
		pos3.x = myHero.x - k * (pos2.z-pos1.z)
		pos3.z = myHero.z + k * (pos2.x-pos1.x)
		local distancePos3 = GetDistance2D(myHero, pos3)
		spellAvoider.moveTo.x = pos3.x + ((radius+50)/distancePos3)*(myHero.x-pos3.x)
		spellAvoider.moveTo.z = pos3.z + ((radius+50)/distancePos3)*(myHero.z-pos3.z)
		if spellAvoider.dodgeSkillShot then
			myHero:MoveTo(spellAvoider.moveTo.x,spellAvoider.moveTo.z)
		end
    end
end

function spellAvoider.dodgeLinePass(pos1, pos2, radius, maxDist)
	local distancePos1 = GetDistance2D(myHero, pos1)
	local distancePos1Pos2 = GetDistance2D(pos1, pos2)
	local pos3 = {}
	pos3.x = pos1.x + (maxDist)/distancePos1Pos2*(pos2.x-pos1.x)
	pos3.z = pos1.z + (maxDist)/distancePos1Pos2*(pos2.z-pos1.z)
    local distancePos3 = GetDistance2D(myHero, pos3)
	local distancePos1Pos3 = GetDistance2D(pos1, pos3)
    local perpendicular = (math.floor((math.abs((pos3.x-pos1.x)*(pos1.z-myHero.z)-(pos1.x-myHero.x)*(pos3.z-pos1.z)))/distancePos1Pos3))
    if perpendicular < radius and distancePos3 < distancePos1Pos3 and distancePos1 < distancePos1Pos3 then
	    local k = ((pos3.z-pos1.z)*(myHero.x-pos1.x) - (pos3.x-pos1.x)*(myHero.z-pos1.z)) / ((pos3.z-pos1.z)^2 + (pos3.x-pos1.x)^2)
		local pos4 = {}
		pos4.x = myHero.x - k * (pos3.z-pos1.z)
		pos4.z = myHero.z + k * (pos3.x-pos1.x)
		local distancePos4 = GetDistance2D(myHero, pos4)
		spellAvoider.moveTo.x = pos4.x + ((radius+50)/distancePos4)*(myHero.x-pos4.x)
		spellAvoider.moveTo.z = pos4.z + ((radius+50)/distancePos4)*(myHero.z-pos4.z)
		if spellAvoider.dodgeSkillShot then
			myHero:MoveTo(spellAvoider.moveTo.x,spellAvoider.moveTo.z)
		end
    end
end

function spellAvoider.addProcessSpell(object,spellName,spellLevel, posStart, posEnd)
	if myHero.dead == true then return end
	if object~=nil and object.team~=myHero.team and spellAvoider.spellArray[spellName] ~= nil and GetDistance2D(myHero, object) < spellAvoider.spellArray[spellName].range + spellAvoider.spellArray[spellName].size + 200 then
		spellAvoider.spellArray[spellName].shot = true
		spellAvoider.spellArray[spellName].lastshot = GetTickCount()
       	if spellAvoider.spellArray[spellName].spellType == 1 then
			spellAvoider.spellArray[spellName].skillshotpoint = spellAvoider.calculateLinepass(posStart, posEnd, spellAvoider.globalspacing, spellAvoider.spellArray[spellName].range)
        	spellAvoider.dodgeLinePass(posStart, posEnd, spellAvoider.spellArray[spellName].size, spellAvoider.spellArray[spellName].range)
        elseif spellAvoider.spellArray[spellName].spellType == 2 then
        	spellAvoider.spellArray[spellName].skillshotpoint = spellAvoider.calculateLinepoint(posStart, posEnd, spellAvoider.globalspacing, spellAvoider.spellArray[spellName].range)
        	spellAvoider.dodgeLinePoint(posStart, posEnd, spellAvoider.spellArray[spellName].size)
        elseif spellAvoider.spellArray[spellName].spellType == 3 then
        	spellAvoider.spellArray[spellName].skillshotpoint = spellAvoider.calculateLineaoe(posStart, posEnd, spellAvoider.spellArray[spellName].range)
			if spellName ~= "SummonerClairvoyance" then
				spellAvoider.dodgeAOE(posStart, posEnd, spellAvoider.spellArray[spellName].size)
			end
        elseif spellAvoider.spellArray[spellName].spellType == 4 then
        	spellAvoider.spellArray[spellName].skillshotpoint = spellAvoider.calculateLinepass(posStart, posEnd, 1000, spellAvoider.spellArray[spellName].range)
        	spellAvoider.dodgeLinePass(posStart, posEnd, spellAvoider.spellArray[spellName].size, spellAvoider.spellArray[spellName].range)
        elseif spellAvoider.spellArray[spellName].spellType == 5 then
        	spellAvoider.spellArray[spellName].skillshotpoint = spellAvoider.calculateLineaoe2(posStart, posEnd, spellAvoider.spellArray[spellName].range)
        	spellAvoider.dodgeAOE(posStart, posEnd, spellAvoider.spellArray[spellName].size)
        end
	end
end

function spellAvoider.drawHandler()
	local tick = os.clock()
	for i, spell in pairs(spellAvoider.spellArray) do
		if spell.shot then
			for j, point in pairs(spell.skillshotpoint) do
				DrawCircle(point.x, point.y, point.z, spell.size, spell.color)
        	end
		end
	end
end

function spellAvoider.tickHandler()
	for i, spell in pairs(spellAvoider.spellArray) do
		if spell.shot and spell.lastshot < GetTickCount() - spell.duration then
			spell.shot = false
			spell.skillshotpoint = {}
			spellAvoider.moveTo = {}
		end
	end
end

for i = 1, heroManager.iCount, 1 do 
	local hero = heroManager:getHero(i)
	if hero ~= nil and hero.team ~= myHero.team then
		for i, spell in pairs(spellList) do
			if spell.charName == hero.charName or (spell.charName == "" and (string.find(hero:GetSpellData(SUMMONER_1).name..hero:GetSpellData(SUMMONER_2).name, i))) then
				spellAvoider.spellFound = true
				spellAvoider.spellArray[i] = CopyArray(spellList[i])
				spellAvoider.spellArray[i].color = spellAvoider.colors[spellAvoider.spellArray[i].spellType]
				spellAvoider.spellArray[i].shot = false
				spellAvoider.spellArray[i].lastshot = 0
				spellAvoider.spellArray[i].skillshotpoint = {}
			end
		end
	end
end
-- unload spellList
spellList = nil
-- unload spellAvoider if no spell founded
if not spellAvoider.spellFound then
	spellAvoider = nil
end


--UPDATEURL=
--HASH=FA7CBE8834C9E2E419C09B7671FFFE71
