--[[
	uiElementClass.lua, a la FruityBatmanSlippers

	Because I saw eXtragoZ's Diana combo script and the menu configuration is just too cool,
	but I'm too lazy to replicate it in every script I have so I take the easy way out and make
	a class/library for it.
	
	This has good synergy with the comboClass.lua library I released earlier, because I said so.
]]--

--[[
	myUiElement = uiElement:new( UI_BUTTON, UI_TYPE_TEXT, "Click here for 1000 RP!", CreateColorInfo(0xFF, 0xFF00FF33), ConvertCoordinates(5, 300, 200, 16), myUiCallback)
	                             UI_LABEL   UI_TYPE_SPRITE                                          alpha, ARGB value                      x  y    w    h    array of callback
								 
	myUiCallback =
	{
		callback = function()
			PrintChat("LOL!")
		end
	}
]]--

if uiElement == nil then
	-- Some quality-of-life global constants
	UI_LABEL  = 0x01
	UI_BUTTON = 0x02
	
	UI_TYPE_TEXT   = 0x01
	UI_TYPE_SPRITE = 0x02
	
	__MOUSE_DOWN = 0x01
	
	function ConvertCoordinates(arg_x,arg_y,arg_w,arg_h,arg_size)
		local tObj = 
		{
			x = arg_x,
			y = arg_y,
			w = arg_w,
			h = arg_h,
			size = arg_size or 20
		}
		
		return tObj
	end
	
	function CreateColorInfo(arg_a,arg_argb)
		local tObj =
		{
			a = arg_a or 0xFF,
			argb = arg_argb or 0xFF00FF33
		}
		
		return tObj
	end

	uiElement = {}
	
	function uiElement:new( arg_type, arg_graphicType, arg_data, arg_colorInfo, arg_pos, arg_callback, arg_visible )
		local tElement = 
		{
			_type = arg_type,
			_graphicType = arg_graphicType,
			_data = arg_data,
			_colorInfo = arg_colorInfo,
			_pos = arg_pos,
			_callback = arg_callback,
			_visible = arg_visible or true
		}
		
		do -- tElement methods
			tElement.SetData = function(pData)
				if tElement._graphicType == UI_TYPE_SPRITE then
					tElement._data.release()
				end
				tElement._data = pData
			end
			
			tElement.SetPos = function(arg_x,arg_y,arg_w,arg_h)
				tElement._pos.x = arg_x
				tElement._pos.y = arg_y
				tElement._pos.w = arg_w or tElement._pos.w
				tElement._pos.h = arg_h or tElement._pos.h
			end
			
			tElement.SetVisible = function(bVisible)
				tElement._visible = bVisible
			end
			
			tElement.__MouseHandler = function(msg, wParam)
				-- It seems like BoL will randomly make it so I have to use 0x01 (__MOUSE_DOWN) rather than WM_LBUTTONDOWN
				if (msg == WM_LBUTTONDOWN or msg == __MOUSE_DOWN) and tElement._type == UI_BUTTON then
					local tPos = GetCursorPos()
					
					local bOnX = ( tPos.x >= tElement._pos.x and tPos.x <= tElement._pos.x+tElement._pos.w )
					local bOnY = ( tPos.y >= tElement._pos.y and tPos.y <= tElement._pos.y+tElement._pos.h )
					
					if bOnX and bOnY then
						local bDebug, err = pcall(tElement._callback.callback, tElement)
						if not bDebug then
							PrintChat(err)
						end
					end
					
				end
			end
			
			tElement.__DisplayElement = function()
				if tElement._visible then
					if tElement._graphicType == UI_TYPE_TEXT then
						DrawText( tElement._data, tElement._pos.size, tElement._pos.x, tElement._pos.y, tElement._colorInfo.argb )
					else -- UI_TYPE_SPRITE
						tElement._data.Draw( tElement._pos.x, tElement._pos.y, tElement._colorInfo.a )
					end
				end
			end
		end
		
		BoL:addMsgHandler(tElement.__MouseHandler)
		BoL:addDrawHandler(tElement.__DisplayElement)
		
		return tElement
	end
	
end

--UPDATEURL=
--HASH=1939D70F7F49135531126C4369D8A42E
