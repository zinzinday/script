-- ComboBase
-- Some constants for ease of use
TICK_HANDLER 		  = 0xFF
DRAW_HANDLER 		  = 0xFE -- If you have a clear key on your keyboard (does that even exist?) you'd have to change this.
MSG_HANDLER  		  = 0xFD
PROCESS_SPELL_HANDLER = 0xFC

ComboBase = {}

function ComboBase:new( tsMode, tsRange, tsType, oKeyList, iTickRate, bDrawRange, iDrawColor )
	ts = TargetSelector(tsMode, tsRange, tsType)
	iTickRate = iTickRate or 100
	bDrawRange = bDrawRange or true
	iDrawColor = iDrawColor or 0x19A712
	
	local tComboBase = 
	{
		_drawRange = tsRange,
		_bDrawRange = bDrawRange,
		_iDrawColor = iDrawColor,
		_keyCallbackList = oKeyList,
		_keysActive = {},
		Selector = ts,
		
		enum_InventorySlots =
		{
			ITEM_1,
			ITEM_2,
			ITEM_3,
			ITEM_4,
			ITEM_5,
			ITEM_6
		},
		
		OnUseItems =
		{
			{name = "Deathfire Grasp", id = 3128, onHeal = 0, percHpReq = 0.60},
			{name = "Hextech Gunblade", id = 3146, onHeal = 0, percHpReq = 0.00},
			{name = "Bilgewater Cutlass", id = 3144, onHeal = 0, percHpReq = 0.00},
			{name = "Morello's Evil Tome", id = 3165, onHeal = 1, percHpReq = 0.00},
			{name = "Executioner's Calling", id = 3123, onHeal = 1, percHpReq = 0.00},
			
			count = 5
		},
		
		HealingChampions = -- Champions to use Morello's Evil Tome on to negate healing
		[[
			Swain
			Fiddlesticks
			DrMundo
			Nunu
			Irelia
			Kayle
			MasterYi
			Olaf
			Renekton
			Ryze
			Sion
			Warwick
		]]
	}
	
	do -- tComboBase methods
		function OnWndMsg(msg, wParam)
			if msg == KEY_DOWN or KEY_UP then
				tComboBase._keysActive[wParam] = msg
			end
			
			for i=1,# tComboBase._keyCallbackList do
				if tComboBase._keyCallbackList[i].hotkey == MSG_HANDLER then
					local bDebug, err = pcall(tComboBase._keyCallbackList[i].callback, tComboBase, msg, wParam)
					if not bDebug then PrintChat(err) end
				end
			end
		end
		
		function OnTick()
			tComboBase.Selector:update()
			
			for i=1,# tComboBase._keyCallbackList do
				if tComboBase._keysActive[tComboBase._keyCallbackList[i].hotkey] == KEY_DOWN or tComboBase._keyCallbackList[i].hotkey == TICK_HANDLER then
					local bDebug, err = pcall(tComboBase._keyCallbackList[i].callback, tComboBase)
					if not bDebug then PrintChat(err) end
				end
			end
		end
		
		function OnDraw()
			if not player.dead and tComboBase._bDrawRange then
				DrawCircle(player.x, player.y, player.z, tComboBase._drawRange, tComboBase._iDrawColor)
			end
			
			for i=1,# tComboBase._keyCallbackList do
				if tComboBase._keyCallbackList[i].hotkey == DRAW_HANDLER then
					local bDebug, err = pcall(tComboBase._keyCallbackList[i].callback, tComboBase)
					if not bDebug then PrintChat(err) end
				end
			end
		end
		
		function OnProcessSpell( from, name )
			for i=1,# tComboBase._keyCallbackList do
				if tComboBase._keysActive[tComboBase._keyCallbackList[i].hotkey] == KEY_DOWN or tComboBase._keyCallbackList[i].hotkey == TICK_HANDLER then
					local bDebug, err = pcall(tComboBase._keyCallbackList[i].callback, tComboBase, from, name, level, start, _end)
					if not bDebug then PrintChat(err) end
				end
			end
		end
		
		tComboBase.GetTarget = function()
			return tComboBase.Selector.target
		end
		
		tComboBase.UseActives = function()
			for i=1,6,1 do
				for c=1,tComboBase.OnUseItems.count,1 do
					-- I hate this block of code solely because there's a billion if statements, it rooks so ugreh
					if player:getInventorySlot(tComboBase.enum_InventorySlots[i]) == tComboBase.OnUseItems[c].id then
						if tComboBase.Selector.target ~= nil and player:CanUseSpell(tComboBase.enum_InventorySlots[i]) then
							if (tComboBase.Selector.target.health / tComboBase.Selector.target.maxHealth) >= tComboBase.OnUseItems[c].percHpReq then
								if tComboBase.OnUseItems[c].onHeal == 0 or tComboBase.HealingChampions:find(tComboBase.Selector.target.charName) then
									CastSpell(tComboBase.enum_InventorySlots[i], tComboBase.Selector.target)
								end
							end
						end
					end
				end
			end
		end
		
		tComboBase.IsKeyDown = function(key)
			return (tComboBase._keysActive[key] == KEY_DOWN)
		end
	end
	return tComboBase
end
