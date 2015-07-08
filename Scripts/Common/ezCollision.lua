class 'ezCollision'

function ezCollision:__init()
	self.enemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	self.version = 1.0
	
	--AddTickCallback(function() self:OnTick() end)
	--AddDrawCallback(function() self:OnDraw() end)	
end

function ezCollision:GetVersion()
	return self.version
end

function ezCollision:OnTick()
	self.enemyMinions:update()
	self:UpdateMinionDirection()	
end

function ezCollision:OnDraw()

	for index, minion in pairs(self.enemyMinions.objects) do
        if minion ~= nil and minion.valid and not minion.dead then

		local unit = minion
		local projSpeed = 2000
		local delay = 250
		
if unit.directionVec then

--local timeElapsed = GetSpellTimeWhenHit(projSpeed, delay, startPos, unit) - GetTickCount()
local predictUnitPos = Vector(unit) + unit.directionVec * (unit.ms * 1000/1000)

DrawCircle(predictUnitPos.x, predictUnitPos.y,predictUnitPos.z, 50, 0x19A712)
end

		end
	end

end

function ezCollision:UpdateMinionDirection()
	for index, minion in pairs(self.enemyMinions.objects) do
        if minion ~= nil and minion.valid and not minion.dead then
		
		local currentVec = Vector(minion)
		
		if minion.lastPosVec then
			minion.directionVec = (currentVec - minion.lastPosVec):normalized()
			
			if (currentVec - minion.lastPosVec) == Vector(0,0,0) then
				minion.directionVec = Vector(0,0,0)
			end
		end
		
		minion.lastPosVec = currentVec		
		end
	end
end


function ezCollision:GetMinionCollision(pStart, pEnd, projSpeed, sDelay, sWidth)
	self.enemyMinions:update()
	--self:UpdateMinionDirection()

	for index, minion in pairs(self.enemyMinions.objects) do
        if minion ~= nil and minion.valid and not minion.dead then		
			if isUnitInSkillshot(minion, Vector(pStart), Vector(pEnd), sWidth, projSpeed, sDelay) then
				return minion
			end		
		end
	end
	
	return nil
end

function GetSpellTimeWhenHit (speed, delay, startpoint, endpoint)
	
	if speed == 0 or speed == nil then
		return GetTickCount() + (delay or 0) + GetLatency()/2
	else
		return GetTickCount() + (GetDistance(startpoint, endpoint))/(speed/1000) + (delay or 0) + GetLatency()/2
	end
end

function isUnitInSkillshot ( unit, startPos, endPos, width, projSpeed, delay )

if GetDistance(startPos,endPos) < GetDistance(startPos,unit) then
	return false
end

local predictUnitPos = Vector(unit)

if unit.directionVec then

local timeElapsed = GetSpellTimeWhenHit(projSpeed, delay, startPos, unit) - GetTickCount()
predictUnitPos = Vector(unit) + unit.directionVec * (unit.ms * timeElapsed/1000)

DrawCircle(predictUnitPos.x, predictUnitPos.y,predictUnitPos.z, 50, 0x19A712)
end

local dir = (endPos - startPos):normalized()
local center = startPos + dir * GetDistance(endPos,startPos)/2

--local center2D = WorldToScreen(D3DXVECTOR3(center.x, center.y, center.z))
--print(WorldToScreen(D3DXVECTOR3(startPos.x, startPos.y, startPos.z)).y)
--print(startPos.z)

local rect = {width = GetDistance(startPos,endPos), height = width}

local rectx = startPos.x
local recty = startPos.z

rect.x = rectx
rect.y = recty

rect.centerX = center.x
rect.centerY = center.z

local deltaY = endPos.z - startPos.z
local deltaX = endPos.x - startPos.x

rect.angle = -math.atan2(deltaY, deltaX)
--rect.angle = math.atan2(GetDistance(startPos,endPos),(endPos.x-startPos.x)) -- AngleBetweenTwoVectors( startPos, endPos )


--Rotate rect's point back
rect.x = (math.cos(rect.angle) * (rectx - rect.centerX) - 
        math.sin(rect.angle) * (recty - rect.centerY)) + rect.centerX
rect.y  = (math.sin(rect.angle) * (rectx - rect.centerX) + 
        math.cos(rect.angle) * (recty - rect.centerY)) + rect.centerY
rect.y = rect.y + rect.height

local circle = {x = predictUnitPos.x, y = predictUnitPos.z, radius = GetDistance(unit, unit.minBBox)/2 + 10}

--Rotate circle's center point back
local unrotatedCircleX = math.cos(rect.angle) * (circle.x - rect.centerX) - 
        math.sin(rect.angle) * (circle.y - rect.centerY) + rect.centerX
local unrotatedCircleY  = math.sin(rect.angle) * (circle.x - rect.centerX) + 
        math.cos(rect.angle) * (circle.y - rect.centerY) + rect.centerY
 
--Closest point in the rectangle to the center of circle rotated backwards(unrotated)
local closestX
local closestY
 
--Find the unrotated closest x point from center of unrotated circle
if unrotatedCircleX  < rect.x then
    closestX = rect.x
elseif unrotatedCircleX  > rect.x + rect.width then
    closestX = rect.x + rect.width
else
    closestX = unrotatedCircleX
end
 
--Find the unrotated closest y point from center of unrotated circle
if unrotatedCircleY < rect.y - rect.height*2 then
    closestY = rect.y - rect.height*2
elseif unrotatedCircleY > rect.y then
    closestY = rect.y
else
    closestY = unrotatedCircleY
end

--DrawCircle(closestX, endPos.y,closestY, 50, 0x19A712)

local distance = findDistance(unrotatedCircleX , unrotatedCircleY, closestX, closestY)
if distance < circle.radius then
    return true
else
    return false
end

end

function findDistance(fromX, fromY, toX, toY)
    local a = math.abs(fromX - toX);
    local b = math.abs(fromY - toY);
 
    return math.sqrt((a * a) + (b * b))
end

function RotatePoint (angle, anchorVec, pointVec)

	local rotatedX = math.cos(angle) * (pointVec.x - anchorVec.x) - 
        math.sin(angle) * (pointVec.z - anchorVec.z) + anchorVec.x
	local rotatedY  = math.sin(angle) * (pointVec.x - anchorVec.x) + 
        math.cos(angle) * (pointVec.z - anchorVec.z) + anchorVec.z

	return Vector(rotatedX, pointVec.y, rotatedY)	
end