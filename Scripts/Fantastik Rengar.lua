if myHero.charName ~= "Rengar" then return end

--[[


 /$$$$$$$$                   /$$                           /$$     /$$ /$$             /$$$$$$$                                                   
| $$_____/                  | $$                          | $$    |__/| $$            | $$__  $$                                                  
| $$    /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$   /$$| $$   /$$      | $$  \ $$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$ 
| $$$$$|____  $$| $$__  $$|_  $$_/   |____  $$ /$$_____/|_  $$_/  | $$| $$  /$$/      | $$$$$$$/ /$$__  $$| $$__  $$ /$$__  $$ |____  $$ /$$__  $$
| $$__/ /$$$$$$$| $$  \ $$  | $$      /$$$$$$$|  $$$$$$   | $$    | $$| $$$$$$/       | $$__  $$| $$$$$$$$| $$  \ $$| $$  \ $$  /$$$$$$$| $$  \__/
| $$   /$$__  $$| $$  | $$  | $$ /$$ /$$__  $$ \____  $$  | $$ /$$| $$| $$_  $$       | $$  \ $$| $$_____/| $$  | $$| $$  | $$ /$$__  $$| $$      
| $$  |  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$ \  $$      | $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$| $$      
|__/   \_______/|__/  |__/   \___/   \_______/|_______/    \___/  |__/|__/  \__/      |__/  |__/ \_______/|__/  |__/ \____  $$ \_______/|__/      
                                                                                                                     /$$  \ $$                    
                                                                                                                    |  $$$$$$/                    
                                                                                                                     \______/                     


*Features:
	-Combo w/ logic!
	-Harras w/ logic!
	-Lane clear!
	-Jungle clear!
	-Item usage w/ logic!
	-Drawings!
	-Each skill has it's own cool settings!
	-Q after AA!
	-W if empowered and heal below 40%(can be changed through the menu)!
	-Anti-Gapcloser with E empowered!
	-R only if empowered option(up to quad-Q)!
	-KS with logic!
	-SxOrb/SAC support!
	-More minor stuff!
	
*Changelog:
 *v 0.25
	-Faster combo
	-Better logic
	-Choose to use empowered skills or not(Menu > Misc > Skill Settings)
	-More minor tweaks

 *v 0.2
	-Combo is way better now
	-Tweaked Q after AA to a perfect one.

 *v 0.15:
	-Fixed issue with targeting.

 *v 0.1:
	-Initial release.
	
--]]

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("UHKILHKNIHK") 

local sversion = "0.25"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BoLFantastik/BoL/master/Fantastik Rengar.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color = \"#FFFFFF\">[Fantastik Rengar] </font><font color=\"#FF0000\">"..msg.."</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/BoLFantastik/BoL/master/version/Fantastik Rengar.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(sversion) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..sversion.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

local REQUIRED_LIBS = 
	{
		["VPrediction"] = "https://raw.github.com/Ralphlol/BoLGit/master/VPrediction.lua",
		["SxOrbwalk"] = "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
	}
local DOWNLOADING_LIBS = false
local DOWNLOAD_COUNT = 0
local SELF_NAME = GetCurrentEnv() and GetCurrentEnv().FILE_NAME or ""

for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		print("<font color = \"#FFFFFF\">[Fantastik Rengar] </font><font color=\"#FF0000\"> Not all required libraries are installed. Downloading: <b><u><font color=\"#73B9FF\">"..DOWNLOAD_LIB_NAME.."</font></u></b> now! Please don't press [F9]!</font>")
		print("Download started")
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
		print("Download finished")
	end
end

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<font color = \"#FFFFFF\">[Fantastik Rengar] </font><font color=\"#FF0000\">Required libraries downloaded successfully, please reload (double [F9]).</font>")
	end
end
if DOWNLOADING_LIBS then return end

local _GAPCLOSER_SPELLS = {
    ["AatroxQ"]              = "Aatrox",
    ["AkaliShadowDance"]     = "Akali",
    ["Headbutt"]             = "Alistar",
    ["FioraQ"]               = "Fiora",
    ["DianaTeleport"]        = "Diana",
    ["EliseSpiderQCast"]     = "Elise",
    ["FizzPiercingStrike"]   = "Fizz",
    ["GragasE"]              = "Gragas",
    ["HecarimUlt"]           = "Hecarim",
    ["JarvanIVDragonStrike"] = "JarvanIV",
    ["IreliaGatotsu"]        = "Irelia",
    ["JaxLeapStrike"]        = "Jax",
    ["KhazixE"]              = "Khazix",
    ["khazixelong"]          = "Khazix",
    ["LeblancSlide"]         = "LeBlanc",
    ["LeblancSlideM"]        = "LeBlanc",
    ["BlindMonkQTwo"]        = "LeeSin",
    ["LeonaZenithBlade"]     = "Leona",
    ["UFSlash"]              = "Malphite",
    ["Pantheon_LeapBash"]    = "Pantheon",
    ["PoppyHeroicCharge"]    = "Poppy",
    ["RenektonSliceAndDice"] = "Renekton",
    ["RivenTriCleave"]       = "Riven",
    ["SejuaniArcticAssault"] = "Sejuani",
    ["slashCast"]            = "Tryndamere",
    ["ViQ"]                  = "Vi",
    ["MonkeyKingNimbus"]     = "MonkeyKing",
    ["XenZhaoSweep"]         = "XinZhao",
    ["YasuoDashWrapper"]     = "Yasuo"
}

local Items = {
	Tiamat      = {Slot = function() return GetInventorySlotItem(3077) end, IsReady = function() return (GetInventorySlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end},
	Hydra       = {Slot = function() return GetInventorySlotItem(3074) end, IsReady = function() return (GetInventorySlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end},
	Botrk       = {Slot = function() return GetInventorySlotItem(3153) end, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end},
	Youmuu      = {Slot = function() return GetInventorySlotItem(3142) end, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end},
	BilgeWater  = {Slot = function() return GetInventorySlotItem(3144) end, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end},
}

local AA = {range = 125, PassiveRange = 0}
local Q = {IsReady = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {range = 500, IsReady = function() return myHero:CanUseSpell(_W) == READY end}
local E = {range = 1000, delay = 0.5, speed = 1500, width = 80, IsReady = function() return myHero:CanUseSpell(_E) == READY end}
local R = {Invisible = false, IsReady = function() return myHero:CanUseSpell(_R) == READY end}
local I = {set = nil, damage = 0, IsReady = function() return (ignite ~= nil and myHero:CanUseSpell(ignite) == READY) end}

local isSX = false
local isSAC = false
local isVisible = true

local maxY = 0

function OnLoad()
	RengarMenu()
	print("<font color = \"#FF0000\">Fantastik Rengar</font> <font color = \"#fff8e7\">by Fantastik v. "..sversion.." loaded!</font>")
	IgniteCheck()
	Minions = minionManager(MINION_ENEMY, E.range, myHero, MINION_SORT_MAXHEALTH_ASC)
    JMinions = minionManager(MINION_JUNGLE, E.range, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
	return ts.target
end

function OnTick()
	ts:update()
	target = GetCustomTarget()
	if isSX then
		SxOrb:ForceTarget(target)
	end
	
	local lTarget = GetTarget()
	if lTarget and ValidTarget(lTarget) and GetDistance(myHero, lTarget) < ts.range then
		ts.target = lTarget
	end
	
	if myHero.y > maxY then
		maxY = myHero.y
	end
	
	Minions:update()
	JMinions:update()
	
	if myHero.dead then
		R.Invisible = false
	end
	
	QREADY = (myHero:CanUseSpell(_Q) == READY)
  	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
 	RREADY = (myHero:CanUseSpell(_R) == READY)
	IREADY = (I.set ~= nil and myHero:CanUseSpell(I.set) == READY)
	CheckItems()
	HealW()
	GetVisible()
	GetMidLeap()
	
	if ValidTarget(target) then
		if Config.Misc.KS.KSI then
			AutoIgnite(target)
		end
		if Config.Misc.KS.KSQ then
			KS(target, Q)
		end
		if Config.Misc.KS.KSW then
			KS(target, W)
		end
		if Config.Misc.KS.KSE then
			KS(target, E)
		end
	end
	
	if Config.KeyBindings.ComboActive then
		Combo()
		if ValidTarget(target) and isSX then
			UseItems(target)
		end
   	end
	if Config.KeyBindings.HarrasActive then
		Harras()
	end

	if Config.KeyBindings.ClearActive then
		Laneclear()
		Jungleclear()
	end
end

function OnApplyBuff(source, unit, buff)
	if unit.isMe and unit and buff.name == "RengarR" then
		R.Invisible = true
	end
end

function OnRemoveBuff(unit, buff)
	if unit.isMe and unit and buff.name == "RengarR" then
		R.Invisible = false
	end
	if unit.isMe then
		print(buff.name)
	end
end

function RengarMenu()
	Config = scriptConfig("Fantastik Rengar", "Rengar")
	
	VP = VPrediction(true)
	
	Config:addSubMenu("Combo Settings", "CSet")
		Config.CSet:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.CSet:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.CSet:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Config.CSet:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, false)
		
	Config:addSubMenu("Item Settings", "ISet")
		Config.ISet:addSubMenu("BotRK Settings", "Botrk")
		    Config.ISet.Botrk:addParam("UseBotrk", "Use Botrk", SCRIPT_PARAM_ONOFF, true)
		    Config.ISet.Botrk:addParam("MaxOwnHealth", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		    Config.ISet.Botrk:addParam("MinEnemyHealth", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
	    Config.ISet:addSubMenu("Bilgewater Settings", "Bilgewater")
		    Config.ISet.Bilgewater:addParam("UseBilgewater", "Use Bilgewater", SCRIPT_PARAM_ONOFF, true)
		    Config.ISet.Bilgewater:addParam("MaxOwnHealth", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 80, 1, 100, 0)
		    Config.ISet.Bilgewater:addParam("MinEnemyHealth", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
	    Config.ISet:addSubMenu("Youmuu Settings", "Youmuu")
	    	Config.ISet.Youmuu:addParam("UseYoumuu", "Use Youmuu", SCRIPT_PARAM_ONOFF, true)
			
	Config:addSubMenu("Harras Settings", "HSet")
		Config.HSet:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.HSet:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Laneclear Settings", "LSet")
		Config.LSet:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.LSet:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
--		Config.LSet:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
		
	Config:addSubMenu("Jungleclear Settings", "JSet")
		Config.JSet:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.JSet:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
--		Config.JSet:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
	
	Config:addSubMenu("Draw Settings", "DSet")
		Config.DSet:addParam("DrawW", "Draw W range", SCRIPT_PARAM_ONOFF, true)
		Config.DSet:addParam("DrawE", "Draw E range", SCRIPT_PARAM_ONOFF, true)
		Config.DSet:addParam("DrawR", "Draw R on minimap", SCRIPT_PARAM_ONOFF, true)
--		Config.DSet:addParam("DrawF", "Draw Fury Stacking points", SCRIPT_PARAM_ONOFF, true)
		Config.DSet:addParam("LFD", "Lag-Free Drawings", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Misc Settings", "Misc")
		Config.Misc:addSubMenu("Q Settings", "QSet")
			Config.Misc.QSet:addParam("QReset", "Use Q when AA not ready", SCRIPT_PARAM_ONOFF, true)
			Config.Misc.QSet:addParam("UseQemp", "Use Q Empowered", SCRIPT_PARAM_ONOFF, true)
		Config.Misc:addSubMenu("W Settings", "WSet")
			Config.Misc.WSet:addParam("HealW", "Use W to heal when low", SCRIPT_PARAM_ONOFF, true)
			Config.Misc.WSet:addParam("HealWs", "Min. % health to heal", SCRIPT_PARAM_SLICE, 40, 1, 100, 0)
			Config.Misc.WSet:addParam("UseWemp", "Use W Empowered", SCRIPT_PARAM_ONOFF, true)
		Config.Misc:addSubMenu("E Settings", "ESet")
			AntiGapcloser(Config.Misc.ESet, OnGapclose)
			Config.Misc.ESet:addParam("UseQemp", "Use E Empowered", SCRIPT_PARAM_ONOFF, true)
		Config.Misc:addSubMenu("R Settings", "RSet")
			Config.Misc.RSet:addParam("UseREmp", "Use R only when empowered", SCRIPT_PARAM_ONOFF, true)
		Config.Misc:addSubMenu("Kill Steal Settings", "KS")
			Config.Misc.KS:addParam("KSQ", "Use Q to KS", SCRIPT_PARAM_ONOFF, true)
			Config.Misc.KS:addParam("KSW", "Use W to KS", SCRIPT_PARAM_ONOFF, true)
			Config.Misc.KS:addParam("KSE", "Use E to KS", SCRIPT_PARAM_ONOFF, true)
			Config.Misc.KS:addParam("KSI", "Use Ignite to KS", SCRIPT_PARAM_ONOFF, true)
--		Config.Misc:addParam("StackJungle", "Stack at jungle points", SCRIPT_PARAM_ONOFF, true)
		Config.Misc:addParam("comboE", "Start invisible combo with E", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Z"))
		Config.Misc:addParam("Debug", "Draw Debug", SCRIPT_PARAM_ONOFF, false)
		
	Config:addSubMenu("Key Settings", "KeyBindings")
		Config.KeyBindings:addParam("ComboActive", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.KeyBindings:addParam("ClearActive", "Laneclear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
		Config.KeyBindings:addParam("HarrasActive", "Harras", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		
		
	Config:addSubMenu("Target Selector", "TSet")
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL, true)
		ts.name = "Focus"
		Config.TSet:addTS(ts)
		
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Fantastik Rengar] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		Config:addParam("SACON","[Rengar] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Rengar] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		Config:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(Config.SxOrb)
		isSX = true
	end
		
	Config.KeyBindings:permaShow("ComboActive")
	Config.KeyBindings:permaShow("ClearActive")
	Config.KeyBindings:permaShow("HarrasActive")
	
end

function OnDraw()
	if myHero.dead then return end
	
	if Config.DSet.DrawE and EREADY then
		if Config.DSet.LFD then
			DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
		else
			DrawCircle(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
		end
	end
	if Config.DSet.DrawW and WREADY then
		if Config.DSet.LFD then
			DrawCircle2(myHero.x, myHero.y, myHero.z, W.range, 0xFF008000)
		else
			DrawCircle(myHero.x, myHero.y, myHero.z, W.range, 0xFF008000)
		end
	end
	if Config.DSet.DrawR and RREADY then
		DrawCircleMinimap(myHero.x, myHero.y, myHero.z, GetRrange())
	end
	if Config.Misc.Debug then
		if isVisible then
			DrawText("Visible", 18, 100, 100, 0xFFFFFF00)
		end
		if IsEmpowered() then
			DrawText("Empowered", 18, 100, 140, 0xFFFFFF00)
		end
	end
	if ValidTarget(target) then
		DrawText("Target: "..target.charName, 18, 100, 120, 0xFFFFFF00)
	end
	if ValidTarget(target) and isSX then
		DrawCircle2(target.x, target.y, target.z, 100, 0xFF008000)
	end
	DrawText("Pos: "..maxY, 18, 100, 160, 0xFFFFFF00)
end

function GetRrange()
  if myHero:GetSpellData(_R).level == 0 then
    return 0
  end
  if myHero:GetSpellData(_R).level == 1 then
    return 2000
  end
  if myHero:GetSpellData(_R).level == 2 then
    return 3000
  end
  if myHero:GetSpellData(_R).level == 3 then
    return 4000
  end
end

function GetVisible()
	if myHero.range < 700 and myHero.range > 150 then PassiveRange = myHero.range + 175 end
	if myHero.range >= 700 then PassiveRange = myHero.range + 75 end
	if myHero.range < 150 then PassiveRange = 125 end
	
	if PassiveRange > 150 then 
		isVisible = false
		LastVisible = os.clock()
	else
		isVisible = true
	end
end

function GetMidLeap()
	if myHero.y > 150 then
		if isSX then
			SxOrb:ResetAA()
			SxOrb:DisableAttacks()
		elseif isSAC then
			_G.AutoCarry.Orbwalker:ResetAttackTimer()
		end
	else
		if isSX then
		DelayAction(function() 
			SxOrb:EnableAttacks()
		end, 0.5)
		elseif isSAC then
			DelayAction(function() 
			SxOrb:EnableAttacks()
		end, 0.5)
		end
	end
end

function Combo()
	if ValidTarget(target) then
	
		if Config.Misc.RSet.UseREmp and Config.CSet.UseR then
			CastR(true)
		elseif not Config.Misc.RSet.UseREmp and Config.CSet.UseR then
			CastR(false)
		end
		
		if Config.CSet.UseQ and not Config.Misc.QSet.UseQemp then
			CastQ(false)
		elseif Config.CSet.UseQ and Config.Misc.QSet.UseQemp then
			CastQ(true)
		end
		
		if Config.CSet.UseE and not Config.Misc.ESet.UseEemp then
			CastE(target, false)
		elseif Config.CSet.UseE and Config.Misc.ESet.UseEemp then
			CastE(target, true)
		end
		
		if Config.CSet.UseW and not Config.Misc.WSet.UseWemp then
			CastW(false)
		elseif Config.CSet.UseW and Config.Misc.WSet.UseWemp then
			CastW(true)
		end
		
	end
end

function Harras()
	if ValidTarget(target) then
		if Config.HSet.UseE and GetDistance(target) <= E.range and EREADY then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero, true)
			if HitChance >= 2 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
		if Config.HSet.UseW and GetDistance(target) <= W.range - 50 and WREADY then
			CastSpell(_W)
		end
	end
end

function Laneclear()
	for i, Minion in pairs(Minions.objects) do
		if Config.LSet.UseQ and GetDistance(Minion) <= AA.range and QREADY then
			if Config.Misc.QSet.QReset then
				if isSX and not SxOrb:CanAttack() then
					CastSpell(_Q)
				elseif isSAC and not _G.AutoCarry.Orbwalker:CanShoot() then
					CastSpell(_Q)
				end
			elseif not Config.Misc.QSet.QReset then
				CastSpell(_Q)
			end
		end
		if Config.LSet.UseW and GetDistance(Minion) <= W.range and WREADY then
			CastSpell(_W)
		end
	end
end

function OnProcessSpell(unit, spell)
	if unit == myHero and spell.name:lower():find("attack") then
		if Config.KeyBindings.ComboActive and QREADY and Config.CSet.UseQ and GetDistance(target) <= 200 and not R.Invisible and Config.Misc.QSet.QReset then
			DelayAction(function() CastSpell(_Q) end, spell.windUpTime + GetLatency() / 2000)
		end
	end
end

function Jungleclear()
	for i, JMinion in pairs(JMinions.objects) do
		if Config.JSet.UseQ and GetDistance(JMinion) <= AA.range and QREADY then
			if Config.Misc.QSet.QReset then
				if isSX and not SxOrb:CanAttack() then
					CastSpell(_Q)
				elseif isSAC and not _G.AutoCarry.Orbwalker:CanShoot() then
					CastSpell(_Q)
				end
			elseif not Config.Misc.QSet.QReset then
				CastSpell(_Q)
			end
		end
		if Config.JSet.UseW and GetDistance(JMinion) <= W.range and WREADY then
			CastSpell(_W)
		end
	end
end

function OnGapclose(unit, data)
	if GetDistance(unit.visionPos, myHero.visionPos) < E.range and EREADY and IsEmpowered() then
		CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
	end
end

function HealW()
	if IsEmpowered() and Config.Misc.WSet.HealW and Config.Misc.WSet.UseWemp then
		if HealthManager() then
			CastSpell(_W)
		end
	end
end

function HealthManager()
	if myHero.health <= myHero.maxHealth * (Config.Misc.WSet.HealWs / 100) then
		return true
	else
		return false
	end	
end

function IsEmpowered()
	if myHero.mana == myHero.maxMana then
		return true
	else
		return false
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0)
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and I.set ~= nil then
		if IREADY then CastSpell(I.set, enemy) end
	end
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		I.set = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		I.set = SUMMONER_2
	end
end

function KS(unit, spell)
	if spell == Q then
		if QREADY and getDmg("Q", unit, myHero) > unit.health and not R.Invisible then
			if GetDistance(target) <= AA.range then
				CastSpell(_Q)
			end
		end
	elseif spell == W then
		if WREADY and getDmg("W", unit, myHero) > unit.health and not R.Invisible then
			if GetDistance(target) <= W.range then
				CastSpell(_W)
			end
		end
	elseif spell == E then
		if EREADY and getDmg("E", unit, myHero) > unit.health and not R.Invisible then
			if GetDistance(target) <= E.range then
				CastSpell(_E, target.x, target.z)
			end
		end
	end
end

function CheckItems()
    ItemBotRK = GetInventorySlotItem(3153)
    ItemBilgeWater = GetInventorySlotItem(3144)
    ItemYoumuus = GetInventorySlotItem(3142)
	ItemHydra = GetInventorySlotItem(3074)
	ItemTiamat = GetInventorySlotItem(3077)
end

function OnCreateObj(obj)
	if obj.name == "Rengar_Base_R_Cas.troy" or obj.name == "Rengar_Skin01_R_Cas.troy" or obj.name == "Rengar_Skin02_R_Cas.troy" then
		R.Invisible = true
	end
end

function OnDeleteObj(obj)
	if obj.name == "Rengar_Base_R_Buf.troy" or obj.name == "Rengar_Skin01_R_Buf.troy" or obj.name == "Rengar_Skin02_R_Buf.troy" then
		DelayAction(function() R.Invisible = false end, 1)
	end
end

function UseItems(unit)
	if Items.Botrk and Config.ISet.Botrk.UseBotrk and math.floor(myHero.health / myHero.maxHealth * 100) <= Config.ISet.Botrk.MaxOwnHealth and unit and ValidTarget(unit, 500) and math.floor(unit.health / unit.maxHealth * 100) >= Config.ISet.Botrk.MinEnemyHealth and Items.Botrk.IsReady() then
		CastSpell(Items.Botrk.Slot(), unit)
	end
	if Items.BilgeWater and Config.ISet.Bilgewater.UseBilgewater and math.floor(myHero.health / myHero.maxHealth * 100) <= Config.ISet.Bilgewater.MaxOwnHealth and unit and ValidTarget(unit, 500) and math.floor(unit.health / unit.maxHealth * 100) >= Config.ISet.Bilgewater.MinEnemyHealth and Items.BilgeWater.IsReady() then
		CastSpell(Items.BilgeWater.Slot(), unit)
	end
	if Items.Youmuus and Config.ISet.Youmuu.UseYoumuu and unit and ValidTarget(unit, 500) and Items.Youmuus.IsReady() then
		CastSpell(Items.Youmuus.Slot())
	elseif Items.Youmuus and Config.ISet.Youmuu.UseYoumuu and unit and R.Invisible and Items.Youmuus.IsReady() then
		CastSpell(Items.Youmuus.Slot())
	end
	if Items.Tiamat and unit and GetDistance(unit) <= AA.range and Items.Tiamat.IsReady() then
		CastSpell(Items.Tiamat.Slot())
	end
	if Items.Hydra and unit and GetDistance(unit) <= AA.range and Items.Hydra.IsReady() then
		CastSpell(Items.Hydra.Slot())
	end
end

function CastQ(emp)
	if not Config.Misc.QSet.QReset and not R.Invisible and QREADY and emp == false and not IsEmpowered() then
		CastSpell(_Q)
	end
	if not Config.Misc.QSet.QReset and not R.Invisible and QREADY and emp == true then
		CastSpell(_Q)
	end
end

function CastW(emp)
	if GetDistance(target) <= 400 and WREADY and not R.Invisible and emp == false and not IsEmpowered() then
		CastSpell(_W)
	end
	if GetDistance(target) <= 400 and WREADY and not R.Invisible and emp == true then
		CastSpell(_W)
	end
end

function CastE(unit, emp)
	if GetDistance(unit) <= E.range and EREADY and not R.Invisible and unit and emp == false and not IsEmpowered() then
		local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(unit, E.delay, E.width, E.range, E.speed, myHero, true)
		if HitChance >= 2 then
			CastSpell(_E, CastPosition.x, CastPosition.z)
		end
	end
	if GetDistance(unit) <= E.range and EREADY and not R.Invisible and unit and emp == true then
		local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(unit, E.delay, E.width, E.range, E.speed, myHero, true)
		if HitChance >= 2 then
			CastSpell(_E, CastPosition.x, CastPosition.z)
		end
	end
end

function CastR(emp)
	if GetDistance(target) > E.range and RREADY and not R.Invisible then
		if emp == true and IsEmpowered() then
			CastSpell(_R)
		elseif emp == false then
			CastSpell(_R)
		end
	end
end

class 'AntiGapcloser'

local _GAPCLOSER_TARGETED, _GAPCLOSER_SKILLSHOT = 1, 2

function AntiGapcloser:__init(menu, cb)

    self.callbacks = {}
    self.activespells = {}
    AddTickCallback(function() self:OnTick() end)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    if menu then
        self:AddToMenu(menu)
    end
    if cb then
        self:AddCallback(cb)
    end

end

function AntiGapcloser:AddToMenu(menu)

    assert(menu, "AntiGapcloser: menu can't be nil!")
    local SpellAdded = false
    local EnemyChampioncharNames = {}
    for i, enemy in ipairs(GetEnemyHeroes()) do
        table.insert(EnemyChampioncharNames, enemy.charName)
    end
    menu:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
    for spellName, charName in pairs(_GAPCLOSER_SPELLS) do
        if table.contains(EnemyChampioncharNames, charName) then
            menu:addParam(string.gsub(spellName, "_", ""), charName.." - "..spellName, SCRIPT_PARAM_ONOFF, true)
            SpellAdded = true
        end
    end
    if not SpellAdded then
        menu:addParam("Info", "Info", SCRIPT_PARAM_INFO, "No spell available to interrupt")
    end
    self.Menu = menu

end

function AntiGapcloser:AddCallback(cb)

    assert(cb and type(cb) == "function", "AntiGapcloser: callback is invalid!")
    table.insert(self.callbacks, cb)

end

function AntiGapcloser:TriggerCallbacks(unit, spell)

    for i, callback in ipairs(self.callbacks) do
        callback(unit, spell)
    end

end

function AntiGapcloser:OnProcessSpell(unit, spell)
    if not self.Menu.Enabled then return end
    if unit.team ~= myHero.team then
        if _GAPCLOSER_SPELLS[spell.name] then
            local Gapcloser = _GAPCLOSER_SPELLS[spell.name]
            if (self.Menu and self.Menu[string.gsub(spell.name, "_", "")]) or not self.Menu then
                local add = false
                if spell.target and spell.target.isMe then
                    add = true
                    startPos = Vector(unit.visionPos)
                    endPos = myHero
                elseif not spell.target then
                    local endPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                    local endPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                    --TODO check angles etc
                    if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
                        add = true
                    end
                end

                if add then
                    local data = {unit = unit, spell = spell.name, startT = os.clock(), endT = os.clock() + 1, startPos = startPos, endPos = endPos}
                    table.insert(self.activespells, data)
                    self:TriggerCallbacks(data.unit, data)
                end
            end
        end
    end

end

function AntiGapcloser:OnTick()

    for i = #self.activespells, 1, -1 do
        if self.activespells[i].endT - os.clock() > 0 then
            self:TriggerCallbacks(self.activespells[i].unit, self.activespells[i])
        else
            table.remove(self.activespells, i)
        end
    end

end

-- Barasia, vadash, viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 80)
	end
end
