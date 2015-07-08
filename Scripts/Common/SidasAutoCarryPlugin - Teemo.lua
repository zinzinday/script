--[[
 
        Auto Carry Plugin - Teemo Edition
		Author: Kain
		Version: See version number below.
		Copyright 2013

		Dependency: Sida's Auto Carry: Revamped
 
		How to install:
			Make sure you already have AutoCarry installed.
			Name the script EXACTLY "SidasAutoCarryPlugin - Teemo.lua" without the quotes.
			Place the plugin in BoL/Scripts/Common folder.

		Features:
			Shroom Bomb
			Escape Wizard
			Shroom Placement Helper for Summoner's Rift
			Range Circle

		Download: https://bitbucket.org/KainBoL/bol/raw/master/Common/SidasAutoCarryPlugin%20-%20Teemo.lua

		History:
			Version: 1.4:
				Fixed Revamped compatibility.
				Removed combo and harass keys. Simply using SAC ones now. Less confusing.
				Fixed a few random bugs.
			Version: 1.3: Moved to Bitbucket.
				Disabled Shroom Hack. Riot patched it.
				Reborn spell fix.
				Minion last-hit damage adjusted.
				Added "BoL Studio Script Updater" url and hash.
			Version: 1.2b: http://pastebin.com/gYGpNTeN
				Updated to Kilua's Teemo Hack v1.5.
			Version: 1.1m: http://pastebin.com/YFFsVUDK
			Version: 1.1k: http://pastebin.com/GbBiCDYY
				Added Shroom Hack.
				Code cleanup.
				Changed method for displaying text on screen.
				Shroom settings changes now auto refresh without an F9.
			Version: 1.05e: http://pastebin.com/nFXpw9tX
				Fixed "Blinding Dart" range to 680.
				Fixed "Shroom Bomb" not firing.
				Added on screen text to indicate when "Shroom Bomb" occurs.
				Made improvements to target detection. Will not shoot at Kog'maw passive, Karthus, etc.
				Fixed issue with Q not working sometimes.
			Version: 1.04: http://pastebin.com/EjLX4Vrq
				Added support for more items.
			Version: 1.03: http://pastebin.com/GGWEjni1
				Fixed shrooms snapping/magnetism. Added toggle for this.
				Added more ranges; changed colors.
				Added experimental flash during escape toggle option. Off by default.

			Version: 1.02: http://pastebin.com/uJ2p7aaQ
				Random Fixes
--]]

if myHero.charName ~= "Teemo" then return end

local version = "1.4"

local Target
local EscapeHotkey = string.byte("T")

-- Prediction
local QRange = 680
local RRange = 230

local SkillQ = {spellKey = _Q, range = QRange, speed = 2, delay = 35, width = 200, configName = "blindingDart", displayName = "Q (Blinding Dart)", enabled = true, skillShot = false, minions = false, reset = false, reqTarget = true }
local SkillW = {spellKey = _W, range = 0, speed = 2, delay = 35}
local SkillR = {spellKey = _R, range = RRange, speed = 2, delay = 35}

local DFGSlot, HXGSlot, BWCSlot, BRKSlot, FlashSlot = nil, nil, nil, nil, nil
local QReady, WReady, EReady, RReady, DFGReady, HXGReady, BWCReady, BRKReady, FlashReady = false, false, false, false, false, false, false, false, false

local debugMode = false

-- Shrooms Config
local highEnabled 	  = nil -- Enable High Priority Mushrooms
local medEnabled 	  = nil -- Enable Medium Priority Mushrooms
local lowEnabled 	  = nil -- Enable Low Priority Mushrooms
local blueEnabled 	  = nil -- Enable Blue Team Mushrooms (in and around blue jungle)
local purpEnabled 	  = nil -- Enable Purple Team Mushrooms (in and around purple jungle)

local shroomSpots     = nil

local showLocationsInRange = 3000 -- When you press R, locations in this range will be shown
local showClose = true -- Show shroom locations that are close to you
local showCloseRange = 800

local FlashSlot = nil

-- Keep track of settings changes
local snapShrooms = nil
local autoShroomsHigh = nil
local autoShroomsMedium = nil

-- Shroom Hack
local lastShroomAnnounce = nil
local nbStack = nil
local NextShroomTime = nil
local BaseTime
local CDTime
local recall = false

if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end

-- Disable SAC Reborn's skills. Ours are better.
if IsSACReborn then
	AutoCarry.Skills:DisableAll()
end

-- Main

function Menu()
	AutoCarry.PluginMenu:addParam("sep", "----- Teemo by Kain: v"..version.." -----", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("Escape", "Escape Artist", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	AutoCarry.PluginMenu:addParam("EscapeFlash", "Escape: Flash to Mouse", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu:addParam("Ultimate", "Use Shroom Bomb with combo", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("DrawShrooms", "Shroom Placement Helper", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("SnapShrooms", "Snap Shrooms into place", SCRIPT_PARAM_ONOFF, true)
	-- if VIP_USER then
	-- 	AutoCarry.PluginMenu:addParam("ShroomHack", "Extra Shrooms Hack", SCRIPT_PARAM_ONOFF, false)
	-- end
	AutoCarry.PluginMenu:addParam("AutoShroomsHigh", "Auto-shroom high priority locations", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("AutoShroomsMedium", "Auto-shroom medium priority locations", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu:addParam("Draw", "Draw range circles", SCRIPT_PARAM_ONOFF, true)
end

function ShroomConfig()
	highEnabled = AutoCarry.PluginMenu.DrawShrooms
	medEnabled 	= AutoCarry.PluginMenu.DrawShrooms
	lowEnabled 	= AutoCarry.PluginMenu.DrawShrooms
	blueEnabled = AutoCarry.PluginMenu.DrawShrooms
	purpEnabled = AutoCarry.PluginMenu.DrawShrooms
end

function PluginOnLoad()
	if VIP_USER then
		-- AddRecvPacketCallback(OnRecvPacket)
	end

	Menu()
	ShroomConfig()
	InitializeShrooms()
end

function PluginOnTick()
	Target = GetTarget()

	CheckSettingsChange()

	-- if VIP_USER then ShroomHackOnTick() end

	SpellCheck()

	if AutoCarry.MainMenu.AutoCarry then
		Combo()
	end

	if AutoCarry.MainMenu.MixedMode then
		Harass()
	end

	if AutoCarry.PluginMenu.Escape then
		EscapeCombo()
	end

	-- Shrooms
	PlaceAutoShrooms()
end

function GetTarget()
	if IsSACReborn then
		return AutoCarry.Crosshair:GetTarget()
	else
		return AutoCarry.GetAttackTarget()
	end
end

function CheckSettingsChange()
	-- Re-Initalize Shrooms settings if user changes them.
	if snapShrooms == nil or snapShrooms ~= AutoCarry.PluginMenu.SnapShrooms 
		or autoShroomsHigh == nil or autoShroomsHigh ~= AutoCarry.PluginMenu.AutoShroomsHigh
		or autoShroomsMedium == nil or autoShroomsMedium ~= AutoCarry.PluginMenu.AutoShroomsMedium then
		snapShrooms = AutoCarry.PluginMenu.SnapShrooms
		autoShroomsHigh = AutoCarry.PluginMenu.AutoShroomsHigh
		autoShroomsMedium = AutoCarry.PluginMenu.AutoShroomsMedium
		InitializeShrooms()
	end
end

function PluginOnProcessSpell(unit, spell)
	-- if VIP_USER then ShroomHackOnProcessSpell(unit, spell) end
end

function PluginBonusLastHitDamage(minion)
	return getDmg("E", minion, myHero)
end

function Combo()
	if Target ~= nil and not Target.dead then
		CastSlots()

		if QReady and GetDistance(Target) < QRange then
			if not AutoCarry.GetCollision(SkillQ, myHero, Target) then
				CastSpell(_Q, Target)
			end
		end

		-- Shroom under enemy
		ShroomUnderEnemy()
	end
end

function EscapeCombo()
	if WReady then
		CastSpell(_W)
	end

	if RReady then
		CastSpell(_R, myHero.x, myHero.z)
	end

	if AutoCarry.PluginMenu.EscapeFlash and FlashSlot ~= nil and FlashReady and GetDistance(mousePos) > 300 then
		CastSpell(FlashSlot, mousePos.x, mousePos.z)
	end

	if AutoCarry.PluginMenu.EscapeFlash then
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end

function Harass()
	if Target ~= nil and not Target.dead then 
		if QReady and GetDistance(Target) < QRange then
			CastSpell(_Q, Target)
			myHero:Attack(Target)
		end
	end
end

function SpellCheck()
	DFGSlot, HXGSlot, BWCSlot, BRKSlot = GetInventorySlotItem(3128),
	GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventorySlotItem(3153)

	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerFlash") then
		FlashSlot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerFlash") then
		FlashSlot = SUMMONER_2
	end

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)

	DFGReady   = (DFGSlot   ~= nil and myHero:CanUseSpell(DFGSlot)   == READY)
	HXGReady   = (HXGSlot   ~= nil and myHero:CanUseSpell(HXGSlot)   == READY)
	BWCReady   = (BWCSlot   ~= nil and myHero:CanUseSpell(BWCSlot)   == READY)
	BRKReady   = (BRKSlot   ~= nil and myHero:CanUseSpell(BRKSlot)   == READY)
	FlashReady = (FlashSlot ~= nil and myHero:CanUseSpell(FlashSlot) == READY)
end

function CastSlots()
	if Target ~= nil and not Target.dead then
		if GetDistance(Target) <= QRange then
			if DFGReady then CastSpell(DFGSlot, Target) end
			if HXGReady then CastSpell(HXGSlot, Target) end
			if BWCReady then CastSpell(BWCSlot, Target) end
			if BRKReady then CastSpell(BRKSlot, Target) end
		end
	end
end

function ShroomUnderEnemy()
	if AutoCarry.PluginMenu.Ultimate and RReady and Target ~= nil and GetDistance(Target) < RRange then
		if not shroomExists(shroomSpot) then
			-- Message.AddMessage("Shroom Bomb!", ColorARGB.Green, myHero)
			PrintFloatText(myHero, 10, "Shroom Bomb!")
			AutoCarry.CastSkillshot(SkillR, Target)
			return true
		end
	end

	return false
end

function PlaceAutoShrooms()
	if not shroomSpots then return end

	for i,group in pairs(shroomSpots) do
		for x, shroomSpot in pairs(group.Locations) do
			if group.Enabled and group.Auto and GetDistance(shroomSpot) <= 250 and not shroomExists(shroomSpot) then
				CastSpell(_R, shroomSpot.x, shroomSpot.z)
			end
		end
	end
end

function PluginOnDraw()
	-- Draw Ranges
	if AutoCarry.PluginMenu.Draw then
		DrawCircle(myHero.x, myHero.y, myHero.z, AutoCarry.SkillsCrosshair.range, 0x808080) -- Gray

		if QReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x0099CC) -- Blue
		end

		if RReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFF0000) -- Red
		end
	end

	-- Draw Shrooms
	if AutoCarry.PluginMenu.DrawShrooms and shroomSpots then
		for i,group in pairs(shroomSpots) do
			if group.Enabled == true then
				if drawShroomSpots then
					for x, shroomSpot in pairs(group.Locations) do
						if GetDistance(shroomSpot) < showLocationsInRange then
							if GetDistance(shroomSpot, mousePos) <= 250 then
								shroomColour = 0xFFFFFF
							else
								shroomColour = group.Colour
							end
							drawShroomCircles(shroomSpot.x, shroomSpot.y, shroomSpot.z,shroomColour)
						end
					end
				elseif showClose then
					for x, shroomSpot in pairs(group.Locations) do
						if GetDistance(shroomSpot) <= showCloseRange then
							if GetDistance(shroomSpot, mousePos) <= 250 then
								shroomColour = 0xFFFFFF
							else
								shroomColour = group.Colour
							end
							drawShroomCircles(shroomSpot.x, shroomSpot.y, shroomSpot.z,shroomColour)
						end
					end
				end
			end
		end
	end
end

-- Shrooms Main
function InitializeShrooms()
	red, yellow, green, blue, purple = 0x990000, 0x993300, 0x00FF00, 0x000099, 0x660066

	shroomSpots = {
		-- High priority for both sides
		HighPriority = 	{ 
							Locations = {
											{ x = 3316.20, 	y = -74.06, z = 9334.85},
											{ x = 4288.76, 	y = -71.71, z = 9902.76},
											{ x = 3981.86, 	y = 39.54, 	z = 11603.55},
											{ x = 6435.51, 	y = 47.51, 	z = 9076.02},
											{ x = 9577.91, 	y = 45.97, 	z = 6634.53},
											{ x = 7635.25, 	y = 45.09, 	z = 5126.81},
											{ x = 10731.51, y = -30.77, z = 5287.01},
											{ x = 9662.24, 	y = -70.79, z = 4536.15},
											{ x = 10080.45, y = 44.48, 	z = 2829.56}  
										},
							Colour = red,
							Enabled = highEnabled,
							Auto = AutoCarry.PluginMenu.AutoShroomsHigh,
							Snap = false
						},
	-- Medium priority for both sides
		MediumPriority ={
							Locations = {
											{ x = 3283.18, 	y = -69.64, z = 10975.15},
											{ x = 2595.85, 	y = -74.00, z = 11044.66},
											{ x = 2524.10, 	y = 23.36, 	z = 11912.28},
											{ x = 4347.64, 	y = 43.34, 	z = 7796.28},
											{ x = 6093.20, 	y = -67.90, z = 8067.45},
											{ x = 7960.99, 	y = -73.41, z = 6233.09},
											{ x = 10652.57, y = -58.96, z = 3507.64},
											{ x = 11460.14, y = -63.94, z = 3544.83},
											{ x = 11401.81, y = -11.72, z = 2626.61}  
										},
							Colour = yellow,
							Enabled = medEnabled,
							Auto = AutoCarry.PluginMenu.AutoShroomsMedium,
							Snap = false
						},
	-- Low priority/situational for both sides
		LowPriority =	{
							Locations = {
											{ x = 1346.10, 	y = 26.56, 	z = 11064.81},
											{ x = 705.87,  	y = 26.93, 	z = 11359.88},
											{ x = 762.80,  	y = 26.15, 	z = 12210.61},
											{ x = 1355.53, 	y = 24.13, 	z = 12936.99},
											{ x = 1926.92, 	y = 25.14, 	z = 11567.44},
											{ x = 1752.22, 	y = 24.02, 	z = 13176.95},
											{ x = 2512.96, 	y = 21.74, 	z = 13524.44},
											{ x = 3577.42, 	y = 25.27, 	z = 12429.88},
											{ x = 5246.01, 	y = 30.91, 	z = 12508.33},
											{ x = 5549.60, 	y = 42.94, 	z = 10917.27},
											{ x = 6552.56, 	y = 47.09, 	z = 9688.99},
											{ x = 5806.41, 	y = 46.01, 	z = 9918.99},
											{ x = 7112.27, 	y = 46.86, 	z = 8443.55},
											{ x = 4896.10, 	y = -72.08, z = 8964.81},
											{ x = 3096.10, 	y = 45.41, 	z = 8164.81},
											{ x = 2390.53, 	y = 46.57, 	z = 5232.34},
											{ x = 4358.81, 	y = 45.83, 	z = 5834.64},
											{ x = 5746.10, 	y = 42.52, 	z = 4864.81},
											{ x = 6307.66, 	y = 46.07, 	z = 7165.92},
											{ x = 5443.82, 	y = 45.64, 	z = 7110.85},
											{ x = 5153.75, 	y = 45.41, 	z = 3358.76},
											{ x = 6876.07, 	y = 46.44, 	z = 5897.48},
											{ x = 6881.30, 	y = 46.08, 	z = 6555.85},
											{ x = 8555.10, 	y = 46.36, 	z = 7267.04},
											{ x = 7946.10, 	y = 44.19, 	z = 7214.81},
											{ x = 9088.99, 	y = -73.12, z = 5441.11},
											{ x = 7687.96, 	y = 46.12, 	z = 5203.08},
											{ x = 8559.97, 	y = 47.97, 	z = 3477.87},
											{ x = 8841.04, 	y = 52.28, 	z = 1944.09},
											{ x = 10582.93, y = 43.25, 	z = 1707.35},
											{ x = 11046.10, y = 43.26, 	z = 964.81},
											{ x = 11682.20, y = 43.40, 	z = 1061.03},
											{ x = 12420.51, y = 46.87, 	z = 1532.34},
											{ x = 12819.32, y = 45.74, 	z = 1931.32},
											{ x = 13275.52, y = 45.38, 	z = 2873.69},
											{ x = 11978.71, y = 45.49, 	z = 2914.69},
											{ x = 13379.36, y = 45.37, 	z = 3499.62},
											{ x = 12818.08, y = 45.38, 	z = 3625.44},
											{ x = 10985.17, y = 45.69, 	z = 6305.81},
											{ x = 11580.80, y = 41.26, 	z = 9214.09},
											{ x = 9574.88, 	y = 44.40, 	z = 8679.65},
											{ x = 8359.96, 	y = 44.37, 	z = 9595.58},
											{ x = 8927.12, 	y = 48.17, 	z = 11175.70}  
										},
							Colour = green,
							Enabled = lowEnabled,
							Auto = false,
							Snap = false
						},
	-- blue team areas
		BlueOnly = {
						Locations = {
										{ x = 2112.87, y = 43.81, z = 7047.48},
										{ x = 2646.25, y = 45.84, z = 7545.78},
										{ x = 1926.95, y = 44.83, z = 9515.71},
										{ x = 4239.97, y = 44.40, z = 7132.02},
										{ x = 6149.34, y = 42.51, z = 4481.88},
										{ x = 6630.28, y = 46.56, z = 2836.88},
										{ x = 7687.62, y = 45.54, z = 3210.98},
										{ x = 7050.22, y = 46.46, z = 2351.33}   
									},
						Colour = blue,
						Enabled = blueEnabled,
						Auto = false,
						Snap = false
					},
	-- purple team areas
		PurpleOnly = 	{
						Locations = {
										{ x = 7466.52, y = 41.54, z = 11720.22},
										{ x = 6945.85, y = 43.53, z = 11901.30},
										{ x = 6636.28, y = 45.03, z = 11079.65},
										{ x = 7878.53, y = 43.83, z = 10042.65},
										{ x = 9701.57, y = 45.72, z = 7298.22},
										{ x = 11358.86, y = 45.71, z = 6872.10},
										{ x = 11946.10, y = 45.80, z = 7414.81},
										{ x = 12169.52, y = 44.03, z = 4858.85}  
									},
						Colour = purple,
						Enabled = purpEnabled,
						Auto = false,
						Snap = false
					}
	}
end

drawShroomSpots = false

function shroomExists(shroomSpot)
	for i=1, objManager.maxObjects do
	local obj = objManager:getObject(i)
		if obj ~= nil and obj.name ~= nil and obj.name:find("Noxious Trap") then
			if GetDistance(obj) <= 260 then
				return true
			end
		end
	end	
	return false
end

function PluginOnWndMsg(msg,key)
	if msg == KEY_DOWN and key == string.byte("R") then
		if player:CanUseSpell(_R) == READY then
			drawShroomSpots = true
		end
	elseif msg == WM_LBUTTONDOWN and drawShroomSpots and shroomSpots then
		for i,group in pairs(shroomSpots) do
			for x, shroomSpot in pairs(group.Locations) do
				if group.Snap or AutoCarry.PluginMenu.SnapShrooms then
					if GetDistance(shroomSpot, mousePos) <= 250 then
						CastSpell(_R, shroomSpot.x, shroomSpot.z)
					end
				end
			end
		end
	elseif msg == WM_RBUTTONDOWN and drawShroomSpots then
		drawShroomSpots = false
	end
end

function drawShroomCircles(x,y,z,colour)
	DrawCircle(x, y, z, 28, colour)
	DrawCircle(x, y, z, 29, colour)
	DrawCircle(x, y, z, 30, colour)
	DrawCircle(x, y, z, 31, colour)
	DrawCircle(x, y, z, 32, colour)
	DrawCircle(x, y, z, 250, colour)
	if colour == red or colour == blue
		or colour == purple or colour == yellow then
		DrawCircle(x, y, z, 251, colour)
		DrawCircle(x, y, z, 252, colour)
		DrawCircle(x, y, z, 253, colour)
		DrawCircle(x, y, z, 254, colour)
	end
end

-- Shroom Hack
--[[
function ShroomHackCount(hack)
	if nbStack then
		if debugMode then PrintChat(""..nbStack.." Shrooms") end
		if AutoCarry.PluginMenu.ShroomHack then
			local plural = ""
			if nbStack > 1 then
				plural = "s"
			end
			
			if not lastShroomAnnounce or GetTickCount() > (lastShroomAnnounce + 1000) then
				if hack then
					PrintFloatText(myHero, 20, "Shroom Hack + 3 Shrooms")
					PrintChat("Shroom Hack + 3 Shrooms")
				elseif nbStack < 3 and nbStack >= 0 then
					PrintFloatText(myHero, 20, ""..nbStack.." Shroom"..plural)
					PrintChat(""..nbStack.." Shroom"..plural)
				end

				lastShroomAnnounce = GetTickCount()
			end
		end
	end
end

function HexNetworkID(networkID,reverse)
	if not VIP_USER then return false end
	local po = CLoLPacket(0xDD)
	po:EncodeF(networkID)
	po.pos = 1
	if reverse == true then
		local s = string.format("%02X",po:Decode1())
		s = s..string.format(" %02X",po:Decode1())
		s = s..string.format(" %02X",po:Decode1())
		s = s..string.format(" %02X",po:Decode1())
		return s
	else
		local s = po:Decode4()
		return string.format("%01X",s)
	end
end

local myHeroHexNetworkID = HexNetworkID(myHero.networkID, true)

function ShroomHackOnTick()
	if not VIP_USER then return end
	resyncPacket() 	-- fake recv packet to avoid desync (update shroom stack and CD timer)
	if NextShroomTime ~= nil and GetGameTimer() >= NextShroomTime - GetLatency()/1000 and nbStack == 2 and FreeShroom == true and recall == false then
		FreeShroom = false

		-- Start of custom Teemo Shroom Hack code
		if AutoCarry.PluginMenu.ShroomHack then
			-- PrintFloatText(myHero, 10, "Shroom Hack!")
			ShroomHackCount(true)
			if not ShroomUnderEnemy() then
				CastSpell(_R, myHero.x, myHero.z)
			end
		end
		-- End of custom Teemo Shroom Hack code

		NextShroomTime = nil
	end
end

function resyncPacket()	-- fake recv packet to avoid desync (update shroom stack and CD timer)
	if nbStack then
		local pResync = CLoLPacket(0xFE)
		pResync:EncodeF(myHero.networkID)
		pResync:Encode2(0x0107)
		pResync:Encode1(0x00)
		pResync:Encode4(_R)
		pResync:Encode4(nbStack) -- nb stack
		pResync:Encode1(0xFF)
		pResync:Encode1(0xFF)
		pResync:Encode1(0xFF)
		pResync:Encode1(0xFF)
		if  NextShroomTime == nil or nbStack == 3 then
			pResync:EncodeF(0)	--For Tecktonik mod try instead: pResync:EncodeF(math.random(0,CDTime))  
		else
			pResync:EncodeF(NextShroomTime-GetGameTimer())
		end
		pResync:EncodeF(CDTime)
		RecvPacket(pResync)
	end
end

function OnRecvPacket(packet)
	if not VIP_USER then return end
	if packet.header == 0xFE and packet.size == 28 then -- Shroom stack(++)
		packet.pos = 1
		packet_networkID = packet:DecodeF() -- 4 Bytes myHero networkID 
		packet_type = packet:Decode2() 	-- 2 bytes packet type
		a1 = packet:Decode4()	-- 00 03 00 00
		a2 = packet:Decode1()	-- 00
		a3 = packet:Decode1()	-- nb shroom
		a4 = packet:Decode1()	-- 00
		a5 = packet:Decode1()	-- 00
		a6 = packet:Decode1()	-- 00
		a7 = packet:Decode4()	-- FF FF FF FF
		a8 = packet:DecodeF()	-- 4 bytes shroom timer watch (actual countdown), range: from CDTime to 0 (decrease over time)	 
		a9 = packet:DecodeF()	-- 4 bytes shroom Total Cooldown Time (like CDTime) (used by Pie timer)
		if packet_networkID == myHero.networkID and packet_type == 0x0107 and a1 == 0x00000300 and a2 == 0x00 and a4 == 0x00 and a5 == 0x00 and a6 == 0x00 and a7 == 0xFFFFFFFF then
			CDTimeServer = a9
			nbStack = a3
			if debugMode then PrintChat("++nbStack: "..nbStack) end
			ShroomHackCount()

			if myHero:GetSpellData(_R).level == 0 then
				CDTime = 35	-- when you take your ulti (1st time), it dont take cdr for 1st shroom cooldown 
			else
				BaseTime = (35 - (myHero:GetSpellData(_R).level - 1) * 4)
				CDTime = BaseTime * (1 + myHero.cdr)
			end

			NextShroomTime = GetGameTimer() + CDTime - 0.2

			if nbStack == 2 then
				FreeShroom = true
			end
		end	
	elseif packet.header == 0xB5 then -- Shroom stack(--)
		packet.pos = 0	-- reset pos for other script which use packet
		stringPacket=dumpPacket(packet)	-- i'm lazy so i will use string XD (big packets 105 and 122 bytes)
		if string.find(stringPacket, myHeroHexNetworkID) == 5 and string.find(stringPacket, "00 00 80 3F "..myHeroHexNetworkID) and string.find(stringPacket, "00 00 00 80 3E 00 00 00 00 00 00 80 3F") and string.find(stringPacket, "3F 00 00 00 00 00 03 00 00") then -- shroom on object (packet size vary often 122,139,156,173 depend object and how many object)
			if nbStack then
				nbStack = nbStack - 1
				--PrintChat("--nbStack: "..nbStack)
				ShroomHackCount()
				if nbStack == 2 then
					BaseTime = (35 - (myHero:GetSpellData(_R).level - 1) * 4)
					CDTime = BaseTime * (1 + myHero.cdr)
					NextShroomTime = GetGameTimer() + CDTime 

					FreeShroom = true
				end
			end
		end
	end

	packet.pos = 0 -- reset pos for other script which use packet
end

function dumpPacket(p)
	local sPacket = ""
	for i=1,p.size,1 do
		sPacket = sPacket .. string.format(" %02X",p:Decode1())
	end
	return sPacket
end

function OnRecall(hero, channelTimeInMs)    -- gets triggered when somebody starts to recall
	if hero.isMe then
		recall = true 
	end
end

function OnAbortRecall(hero)                -- gets triggered when somebody aborts a recall
	if hero.isMe then
		recall = false
	end
end

function OnFinishRecall(hero)
	if hero.isMe then
		recall = false
	end
end

function ShroomHackOnProcessSpell(unit, spell)
	if not VIP_USER then return end
	if unit.isMe and spell.name == "BantamTrap" then
		if not freeShroom then
			-- if nbStack then nbStack = nbStack - 1 end
			ShroomHackCount()
		end
	end
end
--]]

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

--UPDATEURL=https://bitbucket.org/KainBoL/bol/raw/master/Common/SidasAutoCarryPlugin%20-%20Teemo.lua
--HASH=339EE09D9219E5F6B73030C83329785B

