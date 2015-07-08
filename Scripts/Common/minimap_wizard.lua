--[[
        Libray: MiniMap Lib
		Author: Weee
		Porter: Kilua
		
		required libs : 		map, minimap
		exposed variables : 	none, use minimap var
		
		UPDATES :
		v1.1					initial release / port by Kilua
		v1.2					added support for all maps / reworked
		v1.2b					reworked clean
]]

if miniMap == nil then return end

--[[      Code      ]]
miniMap.wizard = {}
miniMap.wizard.shiftKeyPressed = false
miniMap.wizard.botLeft = {move = false, moveUnder = false}
miniMap.wizard.topRight = {move = false, moveUnder = false}
miniMap.wizard.saveUnder = false
miniMap.wizard.pingTick = 0

function miniMap.wizard.mouseIsUnder(x, y, sizeX, sizeY)
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

function miniMap.wizard.writeConfig()
    local file = io.open(miniMap.configFile, "w")
    if file then
        file:write("miniMap.offsets = {x1 = "..miniMap.offsets.x1..", y1 = "..miniMap.offsets.y1..", x2 = "..miniMap.offsets.x2..", y2 = "..miniMap.offsets.y2.." }")
        file:close()
        
    end
	if miniMap.load() == 1 then
		PrintChat(" >> MiniMap Marks Wizard Setup: Config saved. Bye-bye! Thanks for using!")
	end
end

function miniMap.wizard.tickHandler()
	if miniMap.state ~= 2 then return end
	local tick = GetTickCount()
	if miniMap.wizard.pingTick < tick then
		miniMap.wizard.pingTick = tick + 3000
		PingSignal(PING_FALLBACK,map.max.x-300,0,map.max.y-300,2)  -- top right corner
		PingSignal(PING_FALLBACK,map.min.x+300,0,map.min.y+300,2)  -- bottom left corner
	end
	if miniMap.wizard.topRight.move then
		miniMap.offsets.x1 = GetCursorPos().x
		miniMap.offsets.y1 = GetCursorPos().y
	elseif miniMap.wizard.botLeft.move then
		miniMap.offsets.x2 = GetCursorPos().x
		miniMap.offsets.y2 = GetCursorPos().y
	else
		miniMap.wizard.topRight.moveUnder = (miniMap.wizard.shiftKeyPressed and miniMap.wizard.mouseIsUnder(miniMap.offsets.x1 - 5, miniMap.offsets.y1 - 5, 10, 10))
		miniMap.wizard.botLeft.moveUnder = (miniMap.wizard.shiftKeyPressed and miniMap.wizard.mouseIsUnder(miniMap.offsets.x2 - 5, miniMap.offsets.y2 - 5, 10, 10))
		miniMap.wizard.saveUnder = (miniMap.wizard.shiftKeyPressed and miniMap.wizard.mouseIsUnder(550, 310, 45, 15))
	end
end

function miniMap.wizard.drawHandler()
	if miniMap.state ~= 2 then return end
	DrawText("Top Right:",14,300 - 60,200,0xFF80FF00)
	DrawText("Bottom Left:",14,300 - 85,225,0xFF80FF00)
	DrawText("Minimap Wizard Setup v1.2",17,350,170,0xFF80FF00)
	DrawText("by Weee and port by Kilua",13,500,185,0xFF80FF00)
	DrawText("Instructions:",17,350,200,0xFF80FF00)
	DrawText("These colored marks (t) and (b) are movable. Hold shift and left click to move it.",17,350,215,0xFF80FF00)
	DrawText("Right now two corners on your minimap are pinged with yellow circles.",17,350,230,0xFF80FF00)
	DrawText("You have to move each (t) and (b) to it's own corner:",17,350,245,0xFF80FF00)
	DrawText("Try to be as accurate as you can! Each mark must be in the center of the corner!",17,350,275,0xFF80FF00)
	DrawText("More accurate you are - more accurate marks in other scripts you'll get.",17,350,290,0xFF80FF00)
	DrawText("Hold shift and left click  >> ",17,350,310,0xFF80FF00)
	DrawText(" HERE ",17,550,310,0xFFFF0000)
	DrawText(" << when you're done!",17,600,310,0xFF80FF00)
	DrawText("o",31,miniMap.offsets.x1-7,miniMap.offsets.y1-13,0xFF000000)
	DrawText("t",14,miniMap.offsets.x1-1,miniMap.offsets.y1-4,0xFFFFFF00)
	DrawText("o",31,miniMap.offsets.x2-7,miniMap.offsets.y2-13,0xFF000000)
	DrawText("b",14,miniMap.offsets.x2-2,miniMap.offsets.y2-4,0xFFFF0000)
end

function miniMap.wizard.msgHandler(msg, key)
	if miniMap.state ~= 2 then return end
	if key == 16 then
		miniMap.wizard.shiftKeyPressed = (msg == KEY_DOWN)
	elseif msg == WM_LBUTTONDOWN then
		if miniMap.wizard.botLeft.moveUnder then miniMap.wizard.botLeft.move = true
		elseif miniMap.wizard.topRight.moveUnder then miniMap.wizard.topRight.move = true
		elseif miniMap.wizard.saveUnder then miniMap.wizard.writeConfig()
		end
	elseif msg == WM_LBUTTONUP then
		if miniMap.wizard.botLeft.move then miniMap.wizard.botLeft.move = false
		elseif miniMap.wizard.topRight.move then miniMap.wizard.topRight.move = false
		end
	end
end

BoL:addTickHandler(miniMap.wizard.tickHandler,125)
BoL:addDrawHandler(miniMap.wizard.drawHandler)
BoL:addMsgHandler(miniMap.wizard.msgHandler)
PrintChat(" >> MiniMap Wizard Setup: Hai! Follow the steps printed on your screen.")

--UPDATEURL=
--HASH=C099E04CA083F27B80B89583D3EAC153
