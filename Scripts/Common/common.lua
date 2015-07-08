--[[
	Regroup all common functions I use
	Library by SurfaceS
	Version 0.1
]]--

if player == nil then player = GetMyHero() end
if SPRITE_PATH == nil then SPRITE_PATH = SCRIPT_PATH:gsub("\\", "/"):gsub("/Scripts", "").."Sprites/" end

-- GetDistance2D return distance between 2 points, or from player
function GetDistance2D( p1, p2 )
	if p2 == nil then p2 = player end
    if p1.z == nil or p2.z == nil then
		return math.sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
	else
		return math.sqrt((p1.x-p2.x)^2+(p1.z-p2.z)^2)
	end
end
function GetDistanceFromMouse(target)
	if target ~= nil then return GetDistance2D(target, mousePos) end
	return 100000
end
-- Round a number
if round == nil then
	function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
end

-- return true if file exist
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- return if cursor is under a rectangle
function cursorIsUnder(x, y, sizeX, sizeY)
	local posX, posY = GetCursorPos().x, GetCursorPos().y
	if sizeY == nil then sizeY = sizeX end
	if sizeX < 0 then
		x = x + sizeX
		sizeX = - sizeX
	end
	if sizeY < 0 then
		y = y + sizeY
		sizeY = - sizeY
	end
	return (posX >= x and posX <= x + sizeX and posY >= y and posY <= y + sizeY)
end

--return texted version of a timer
function timerText(seconds, len)
	local secondsNumber = tonumber(seconds)
	if secondsNumber == nil or secondsNumber > 100000 or secondsNumber < 0 then return " ? " end
	local minutes = secondsNumber / 60
	local returnText
	if minutes >= 60 then
		returnText = string.format("%i:%02i:%02i", minutes / 60, minutes, secondsNumber % 60)
	elseif minutes >= 1 then
		returnText = string.format("%i:%02i", minutes, secondsNumber % 60)
	else
		returnText = string.format(":%02i", secondsNumber % 60)
	end
	if len ~= nil then
		while string.len(returnText) < len do
			returnText = " "..returnText.." "
		end
	end
	return returnText
end

-- return sprite
function returnSprite(file, altFile)
	if file_exists(SPRITE_PATH..file) == true then
		return createSprite(file)
	else
		if altFile ~= nil and file_exists(SPRITE_PATH..altFile) == true then
			return createSprite(altFile)
		else
			PrintChat(file.." not found (sprites installed ?)")
			return createSprite("empty.dds")
		end
	end
end


--UPDATEURL=
--HASH=68438E465F34572F7A6E0A9D3932E152
