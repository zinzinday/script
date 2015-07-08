require "Button"

function OnLoad()
	PrintChat("Button Tester")
	TestButton = Button(GetSprite("buttonUp.dds"), GetSprite("buttonDown.dds"), 100, 100, 200, 100)
	TestButton:SetAlpha(220)
	TestButton2 = Button(GetSprite("circleUp.dds"), GetSprite("circleDown.dds"), 200, 200, 20, 20)
	TestButton2:Make3D(3046.87, -188.57, 4297.29) -- Give it coords on the map
	TestButton2:RemoveToggle(0.100) -- Remove the On/Off portion
	TestButton2:SetAlpha(200) -- Set an alpha layer
	TestButton2:AddFunction(MessageMe) -- Add a function to be called on push.
	
	shiftDown = false
end

function OnDraw()
	local cursorPos = GetCursorPos()
	DrawText("X = " .. string.format("%.2f", mousePos.x),16, cursorPos.x, cursorPos.y + 50, 0xFF00FF00)
	DrawText("Y = " .. string.format("%.2f", mousePos.y),16, cursorPos.x, cursorPos.y + 65, 0xFF00FF00)
	DrawText("Z = " .. string.format("%.2f", mousePos.z),16, cursorPos.x, cursorPos.y + 80, 0xFF00FF00)
	--TestButton:Draw()
	--TestButton2:Draw()
end

function MessageMe()
	PrintChat("Button has been pressed")
end



function OnWndMsg(msg, key)
	if msg == 256 then -- ShiftDown
		shiftDown = true
	end
	if msg == 257 then -- ShiftUp
		shiftDown = false
	end
	if msg == WM_LBUTTONDOWN and shiftDown == true then
		--PrintChat(""..os.clock())
		TestButton:WndMsg()
		TestButton2:WndMsg()
	end
end
