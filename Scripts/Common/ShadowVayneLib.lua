--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
------------------------
------ MainScript ------
------------------------
class "ShadowVayne"
function ShadowVayne:__init()
	self.ShadowTable = {}
	self.ShadowTable.version = 3.41
	self.ShadowTable.LastLevelCheck = 0
	self.ShadowTable.LastHeroLevel = 0
	self.LastTumble = 0
	self.CurSkin = 0
	self.ForceAA = false
	self.hitboxmode = true
	self.WaitForR84 = false
	self.wayPointManager = WayPointManager()
	CondemnLastE = 0
	SUMMONERS_RIFT   = { 1, 2 }
	PROVING_GROUNDS  = 3
	TWISTED_TREELINE = { 4, 10 }
	CRYSTAL_SCAR     = 8
	HOWLING_ABYSS    = 12
	print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Version "..self.ShadowTable.version.." loaded</font>")

	self:LoadMap()
	self:GetOrbWalkers()
	self:GenerateTables()

	self:LoadMainMenu()
	self:FillMenu_KeySetting()
	self:FillMenu_Autolevel()
	self:FillMenu_GapCloser()
	self:FillMenu_StunTarget()
	self:FillMenu_Interrupt()
	self:FillMenu_StunSettings()
	self:FillMenu_Draw()
	self:FillMenu_PermaShow()
	self:FillMenu_BotRK()
	self:FillMenu_BilgeWater()
	self:FillMenu_Yomuus()
	self:FillMenu_Tumble()
	self:FillMenu_WallTumble()
	self:FillMenu_SkinHack()
	self:FillMenu_Selector()
	self:FillMenu_Debug()

	self:LoadTS()
	self:LoadSOW()
	self:ArrangeEnemies()
	self:LoadRengar()
	self:LoadCustomPermaShow()

	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.activatemodes then self:ActivateModes() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.checklevelchange then self:CheckLevelChange() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.permashows then self:PermaShows() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.botrk then self:BotRK() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.bilgewater then self:BilgeWater() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.gapcloseraftercast then self:GapCloserAfterCast() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.gapcloserrengar then self:GapCloserRengar() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.switchtogglemode then self:SwitchToggleMode() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.threshlantern then self:TreshLantern() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.condemnstun then self:CondemnStun() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.twalltumble then self:WallTumble() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.updateherodirection then self:UpdateHeroDirection() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.generatetarget then self:GenerateTarget() end end)
	AddTickCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.tick.skinhack then self:SkinHack() end end)
	AddTickCallback(function() self:ForceScriptReset() end)
	AddTickCallback(function() self:UpdateLastPos() end)

	AddCreateObjCallback(function(Obj) if not self.WaitForR84 and not SVMainMenu.debugsettings.createobj.rengarobject then self:RengarObject(Obj) end end)
	AddCreateObjCallback(function(Obj) if not self.WaitForR84 and not SVMainMenu.debugsettings.createobj.threshobject then self:ThreshObject(Obj) end end)

	AddProcessSpellCallback(function(unit, spell) if not self.WaitForR84 and not SVMainMenu.debugsettings.processspell.gapcloser then self:ProcessSpell_GapCloser(unit, spell) end end)
	AddProcessSpellCallback(function(unit, spell) if not self.WaitForR84 and not SVMainMenu.debugsettings.processspell.interrupt then self:ProcessSpell_Interrupt(unit, spell) end end)
	AddProcessSpellCallback(function(unit, spell) if not self.WaitForR84 and not SVMainMenu.debugsettings.processspell.basicattack then self:ProcessSpell_BasicAttack(unit, spell) end end)
	AddProcessSpellCallback(function(unit, spell) if not self.WaitForR84 and not SVMainMenu.debugsettings.processspell.recall then self:ProcessSpell_Recall(unit, spell) end end)

	AddDrawCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.draw.dwalltumble then self:Draw_WallTumble() end end)
	AddDrawCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.draw.condemnrange then self:Draw_CondemnRange() end end)
	AddDrawCallback(function() if not self.WaitForR84 and not SVMainMenu.debugsettings.draw.aarange then self:Draw_AARange() end end)
	AddDrawCallback(function() if not self.WaitForR84 then self:DebugDraw() end end)

	AddSendPacketCallback(function(p) if not self.WaitForR84 and not SVMainMenu.debugsettings.sendpacket.pwalltumble then self:SendPacket_WallTumble(p) end end)

	AddMsgCallback(function(msg,key) if not self.WaitForR84 and not SVMainMenu.debugsettings.msg.doublemodeprotection then self:DoubleModeProtection(msg, key) end end)

end

function ShadowVayne:IsMap(map)
    assert(map and (type(map) == "number" or type(map) == "table"), "IsMap(): map is invalid!")
    if type(map) == "number" then
        return GetGame().map.index == map
    else
        for _, id in ipairs(map) do
            if GetGame().map.index == id then return true end
        end
    end
end

function ShadowVayne:GetMapName()
    if self:IsMap(SUMMONERS_RIFT) then
        return "Summoners Rift"
    elseif self:IsMap(CRYSTAL_SCAR) then
        return "Crystal Scar"
    elseif self:IsMap(HOWLING_ABYSS) then
        return "Howling Abyss"
    elseif self:IsMap(TWISTED_TREELINE) then
        return "Twisted Treeline"
    elseif self:IsMap(PROVING_GROUNDS) then
        return "Proving Grounds"
    else
        return "Unknown map"
    end
end

function ShadowVayne:LoadMap()
	if not FileExist(LIB_PATH.."\\Saves\\WorldGrid\\" .. self:GetMapName() .. "_Walls.SAVE") then
		RunCmdCommand('mkdir "' .. string.gsub(LIB_PATH.."/Saves/WorldGrid", [[/]], [[\]]) .. '"')
		self:TCPDownload("sx-bol.eu", "/BoL/WorldGrid/" .. self:GetMapName() .."_Brushes.SAVE", LIB_PATH.."\\Saves\\WorldGrid\\" .. self:GetMapName() .. "_Brushes.SAVE")
		self:TCPDownload("sx-bol.eu", "/BoL/WorldGrid/" .. self:GetMapName() .."_Vision.SAVE", LIB_PATH.."\\Saves\\WorldGrid\\" .. self:GetMapName() .. "_Vision.SAVE")
		self:TCPDownload("sx-bol.eu", "/BoL/WorldGrid/" .. self:GetMapName() .."_Walls.SAVE", LIB_PATH.."\\Saves\\WorldGrid\\" .. self:GetMapName() .. "_Walls.SAVE")
		self:TCPDownload("sx-bol.eu", "/BoL/WorldGrid/" .. self:GetMapName() .."_Info.SAVE", LIB_PATH.."\\Saves\\WorldGrid\\" .. self:GetMapName() .. "_Info.SAVE")
	end
	worldGridWalls = GetSave("WorldGrid\\" .. self:GetMapName() .. "_Walls")
	worldGridBrushes = GetSave("WorldGrid\\" .. self:GetMapName() .. "_Brushes")
end

function ShadowVayne:GetWorldType(x,z)
	local GridX = math.round(x/50)
	local GridZ = math.round(z/50)
	if worldGridWalls[GridX] and worldGridWalls[GridX][GridZ] then
		return 1
	elseif worldGridBrushes[GridX] and worldGridBrushes[GridX][GridZ] then
		return 2
	else
		return 0
	end
end

function ShadowVayne:TCPDownload(Host, Link, Save)
	LuaSocket = require("socket")
	ScriptSocket = LuaSocket.connect(Host, 80)
	ScriptSocket:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
	ScriptReceive, ScriptStatus = ScriptSocket:receive('*a')

	ScriptFileOpen = io.open(Save, "w+")
	ScriptStart = string.find(ScriptReceive, "return")
	if ScriptStart then
		ScriptFileOpen:write(string.sub(ScriptReceive, ScriptStart))
	else
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Error in downloading WallSaves. Download them from the Thread by yourself!</font>")
	end
	ScriptFileOpen:close()
end

function ShadowVayne:GetOrbWalkers()
	self.ShadowTable.OrbWalkers = {}
	table.insert(self.ShadowTable.OrbWalkers, "SOW")

	if _G.Reborn_Loaded then
		table.insert(self.ShadowTable.OrbWalkers, "Reborn R84")
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Waiting for SAC:R84 Auth</font>")
		DelayAction(function() self:GetR84Keys() end)
		self.WaitForR84 = true
	end

	if _G.MMA_Loaded then
		table.insert(self.ShadowTable.OrbWalkers, "MMA")
	end

	if _G.AutoCarry ~= nil and not _G.Reborn_Loaded then
		if _G.AutoCarry.Helper ~= nil then
			Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
			table.insert(self.ShadowTable.OrbWalkers, "Reborn R83")
		else
			if _G.AutoCarry.AutoCarry ~= nil then
				table.insert(self.ShadowTable.OrbWalkers, "Revamped")
			end
		end
	end
end

function ShadowVayne:GetR84Keys()
	if _G.AutoCarry then
		Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACAutoCarry", AutoCarry.MODE_AUTOCARRY)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACMixedMode", AutoCarry.MODE_MIXEDMODE)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLaneClear", AutoCarry.MODE_LANECLEAR)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLastHit", AutoCarry.MODE_LASTHIT)
		self.WaitForR84 = false
	else
		DelayAction(function() self:GetR84Keys() end)
	end
end

function ShadowVayne:GenerateTables()
	isAGapcloserUnitTarget = {
        ['Akali']       = {true, spell = "AkaliShadowDance", 	spellKey = "R"},
        ['Alistar']     = {true, spell = "Headbutt", 			spellKey = "W"},
        ['Diana']       = {true, spell = "DianaTeleport", 		spellKey = "R"},
        ['Irelia']      = {true, spell = "IreliaGatotsu",		spellKey = "Q"},
        ['Jax']         = {true, spell = "JaxLeapStrike", 		spellKey = "Q"},
        ['Jayce']       = {true, spell = "JayceToTheSkies",		spellKey = "Q"},
        ['Maokai']      = {true, spell = "MaokaiUnstableGrowth",spellKey = "W"},
        ['MonkeyKing']  = {true, spell = "MonkeyKingNimbus",	spellKey = "E"},
        ['Pantheon']    = {true, spell = "Pantheon_LeapBash",	spellKey = "W"},
        ['Poppy']       = {true, spell = "PoppyHeroicCharge",	spellKey = "E"},
		['Quinn']       = {true, spell = "QuinnE",				spellKey = "E"},
        ['XinZhao']     = {true, spell = "XenZhaoSweep",		spellKey = "E"},
        ['LeeSin']	    = {true, spell = "blindmonkqtwo",		spellKey = "Q"},
        ['Fizz']	    = {true, spell = "FizzPiercingStrike",	spellKey = "Q"},
        ['Rengar']	    = {true, spell = "RengarLeap",			spellKey = "Q/R"},
    }

	isAGapcloserUnitNoTarget = {
		["AatroxQ"]					= {true, champ = "Aatrox", 		range = 1000,  	projSpeed = 1200, spellKey = "Q"},
		["GragasE"]					= {true, champ = "Gragas", 		range = 600,   	projSpeed = 2000, spellKey = "E"},
		["GravesMove"]				= {true, champ = "Graves", 		range = 425,   	projSpeed = 2000, spellKey = "E"},
		["HecarimUlt"]				= {true, champ = "Hecarim", 	range = 1000,   projSpeed = 1200, spellKey = "R"},
		["JarvanIVDragonStrike"]	= {true, champ = "JarvanIV",	range = 770,   	projSpeed = 2000, spellKey = "Q"},
		["JarvanIVCataclysm"]		= {true, champ = "JarvanIV", 	range = 650,   	projSpeed = 2000, spellKey = "R"},
		["KhazixE"]					= {true, champ = "Khazix", 		range = 900,   	projSpeed = 2000, spellKey = "E"},
		["khazixelong"]				= {true, champ = "Khazix", 		range = 900,   	projSpeed = 2000, spellKey = "E"},
		["LeblancSlide"]			= {true, champ = "Leblanc", 	range = 600,   	projSpeed = 2000, spellKey = "W"},
		["LeblancSlideM"]			= {true, champ = "Leblanc", 	range = 600,   	projSpeed = 2000, spellKey = "WMimic"},
		["LeonaZenithBlade"]		= {true, champ = "Leona", 		range = 900,  	projSpeed = 2000, spellKey = "E"},
		["UFSlash"]					= {true, champ = "Malphite", 	range = 1000,  	projSpeed = 1800, spellKey = "R"},
		["RenektonSliceAndDice"]	= {true, champ = "Renekton", 	range = 450,  	projSpeed = 2000, spellKey = "E"},
		["SejuaniArcticAssault"]	= {true, champ = "Sejuani", 	range = 650,  	projSpeed = 2000, spellKey = "Q"},
		["ShenShadowDash"]			= {true, champ = "Shen", 		range = 575,  	projSpeed = 2000, spellKey = "E"},
		["RocketJump"]				= {true, champ = "Tristana", 	range = 900,  	projSpeed = 2000, spellKey = "W"},
		["slashCast"]				= {true, champ = "Tryndamere", 	range = 650,  	projSpeed = 1450, spellKey = "E"},
	}

	isAChampToInterrupt = {
                ["KatarinaR"]					= {true, champ = "Katarina",	spellKey = "R"},
                ["GalioIdolOfDurand"]			= {true, champ = "Galio",		spellKey = "R"},
                ["Crowstorm"]					= {true, champ = "FiddleSticks",spellKey = "R"},
                ["Drain"]						= {true, champ = "FiddleSticks",spellKey = "W"},
                ["AbsoluteZero"]				= {true, champ = "Nunu",		spellKey = "R"},
                ["ShenStandUnited"]				= {true, champ = "Shen",		spellKey = "R"},
                ["UrgotSwap2"]					= {true, champ = "Urgot",		spellKey = "R"},
                ["AlZaharNetherGrasp"]			= {true, champ = "Malzahar",	spellKey = "R"},
                ["FallenOne"]					= {true, champ = "Karthus",		spellKey = "R"},
                ["Pantheon_GrandSkyfall_Jump"]	= {true, champ = "Pantheon",	spellKey = "R"},
                ["VarusQ"]						= {true, champ = "Varus",		spellKey = "Q"},
                ["CaitlynAceintheHole"]			= {true, champ = "Caitlyn",		spellKey = "R"},
                ["MissFortuneBulletTime"]		= {true, champ = "MissFortune",	spellKey = "R"},
                ["InfiniteDuress"]				= {true, champ = "Warwick",		spellKey = "R"},
                ["LucianR"]						= {true, champ = "Lucian",		spellKey = "R"}

	}

	AutoLevelSpellTable = {
                ["SpellOrder"]	= {"QWE", "QEW", "WQE", "WEQ", "EQW", "EWQ"},
                ["QWE"]	= {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E},
                ["QEW"]	= {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W},
                ["WQE"]	= {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E},
                ["WEQ"]	= {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q},
                ["EQW"]	= {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W},
                ["EWQ"]	= {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q}
	}

	priorityTable = {

    AP = {
        "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
        "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
        "Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi", "Velkoz"
    },
    Support = {
        "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Sona", "Soraka", "Thresh", "Zilean"
    },

    Tank = {
        "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
        "Warwick", "Yorick", "Zac", "Nunu", "Taric", "Alistar", "Braum",
    },

    AD_Carry = {
        "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
        "Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed", "Jinx" , "Lucian", "Yasuo",

    },

    Bruiser = {
        "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nautilus", "Nocturne", "Olaf", "Poppy",
        "Renekton", "Rengar", "Riven", "Shyvana", "Trundle", "Tryndamere", "Udyr", "Vi", "MonkeyKing", "XinZhao", "Aatrox",
    },

}


	heroDirDB = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
			heroDirDB[enemy.name] = {lastVec = Vector(0,0,0), dir = Vector(0,0,0), lastAngle = 0, index = i, hero = enemy}
	end

	LastPosTable = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
			table.insert(LastPosTable, {["posX"] = enemy.pos.x,["posY"] = enemy.pos.y,["posZ"] = enemy.pos.z, ["unit"] = enemy, ["dir"] = Vector(0,0,0)})
	end

	ProdictionCircle = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
		ProdictionCircle[enemy.charName] = {x=0,y=0,z=0}
	end

	TumbleSpots = {
		["VisionPos_1"] = { ["x"] = 11590.95, ["y"] = 52, ["z"] = 4656.26 },
		["VisionPos_2"] = { ["x"] = 6623, ["y"] = 56, ["z"] = 8649 },
		["StandPos_1"] = { ["x"] = 11590.95, ["y"] = 4656.26},
		["StandPos_2"] = { ["x"] = 6623.00, ["y"] = 8649.00 },
		["CastPos_1"] = { ["x"] = 11334.74, ["y"] = 4517.47 },
		["CastPos_2"] = { ["x"] = 6010.5869140625, ["y"] = 8508.8740234375 }
	}


end

function ShadowVayne:LoadMainMenu()
	SVMainMenu = scriptConfig("[ShadowVayne] MainScript", "SV_MAIN")
	SVMainMenu:addSubMenu("[Condemn]: AntiGapCloser Settings", "anticapcloser")
	SVMainMenu:addSubMenu("[Condemn]: AutoStun Settings", "autostunn")
	SVMainMenu:addSubMenu("[Condemn]: AutoStun Targets", "targets")
	SVMainMenu:addSubMenu("[Condemn]: Interrupt Settings", "interrupt")
	SVMainMenu:addSubMenu("[Tumble]: Settings", "tumble")
	SVMainMenu:addSubMenu("[Misc]: Key Settings", "keysetting")
	SVMainMenu:addSubMenu("[Misc]: AutoLevelSpells Settings", "autolevel")
	SVMainMenu:addSubMenu("[Misc]: PermaShow Settings", "permashowsettings")
	SVMainMenu:addSubMenu("[Misc]: Draw Settings", "draw")
	SVMainMenu:addSubMenu("[Misc]: WallTumble Settings", "walltumble")
	SVMainMenu:addSubMenu("[Misc]: SkinHack", "skinhack")
	SVMainMenu:addSubMenu("[Misc]: Selector", "selector")
	SVMainMenu:addSubMenu("[BotRK]: Settings", "botrksettings")
	SVMainMenu:addSubMenu("[Bilgewater]: Settings", "bilgesettings")
	SVMainMenu:addSubMenu("[Youmuu's]: Settings", "youmuus")
	SVMainMenu:addSubMenu("[Debug]: Settings", "debugsettings")
end

function ShadowVayne:FillMenu_KeySetting()
	SVMainMenu.keysetting:addParam("nil","Basic Key Settings", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	SVMainMenu.keysetting:addParam("threshlantern","Grab the Thresh lantern: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "T" ))
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("nil","General Key Settings", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("togglemode","ToggleMode:", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
	SVMainMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
	SVMainMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
	SVMainMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("AutoCarryOrb", "Orbwalker in AutoCarry: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	SVMainMenu.keysetting:addParam("MixedModeOrb", "Orbwalker in MixedMode: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	SVMainMenu.keysetting:addParam("LaneClearOrb", "Orbwalker in LaneClear: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	SVMainMenu.keysetting:addParam("LastHitOrb", "Orbwalker in LastHit: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	--~ SAC R84 FIX
	SVMainMenu.keysetting:addParam("SACAutoCarry","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACMixedMode","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACLaneClear","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACLastHit","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)

	if SVMainMenu.keysetting._param[12].listTable[SVMainMenu.keysetting.AutoCarryOrb] == nil then SVMainMenu.keysetting.AutoCarryOrb = 1 end
	if SVMainMenu.keysetting._param[13].listTable[SVMainMenu.keysetting.MixedModeOrb] == nil then SVMainMenu.keysetting.MixedModeOrb = 1 end
	if SVMainMenu.keysetting._param[14].listTable[SVMainMenu.keysetting.LaneClearOrb] == nil then SVMainMenu.keysetting.LaneClearOrb = 1 end
	if SVMainMenu.keysetting._param[15].listTable[SVMainMenu.keysetting.LastHitOrb] == nil then SVMainMenu.keysetting.LastHitOrb = 1 end
end

function ShadowVayne:FillMenu_GapCloser()
	local FoundAGapCloser = false
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if isAGapcloserUnitTarget[enemy.charName] then
			SVMainMenu.anticapcloser:addSubMenu((enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey), (enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey))
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey)..":", SCRIPT_PARAM_INFO, "")
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
			FoundAGapCloser = true
		end

		for _, TableInfo in pairs(isAGapcloserUnitNoTarget) do
			if TableInfo.champ == enemy.charName then
				SVMainMenu.anticapcloser:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey)..":", SCRIPT_PARAM_INFO, "")
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
				FoundAGapCloser = true
			end
		end
	end

	if not FoundAGapCloser then SVMainMenu.anticapcloser:addParam("nil","No Enemy Gapclosers found", SCRIPT_PARAM_INFO, "") end
end

function ShadowVayne:FillMenu_StunTarget()
	local FoundStunTarget = false
	for i, enemy in ipairs(GetEnemyHeroes()) do
		SVMainMenu.targets:addSubMenu(enemy.charName, enemy.charName)
		SVMainMenu.targets[enemy.charName]:addParam("sep", "Stun "..(enemy.charName), SCRIPT_PARAM_INFO, "")
		SVMainMenu.targets[enemy.charName]:addParam("autocarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.targets[enemy.charName]:addParam("mixedmode", "in MixedMode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam("laneclear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam("lasthit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam("always", "Always", SCRIPT_PARAM_ONOFF, false)
		FoundStunTarget = true
	end

	if not FoundStunTarget then SVMainMenu.targets:addParam("nil","No Enemies to Stun found", SCRIPT_PARAM_INFO, "") end
end

function ShadowVayne:FillMenu_Interrupt()
	local Foundinterrupt = false
	for i, enemy in ipairs(GetEnemyHeroes()) do
		for _, TableInfo in pairs(isAChampToInterrupt) do
			if TableInfo.champ == enemy.charName then
				SVMainMenu.interrupt:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey), SCRIPT_PARAM_INFO, "")
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, true)
				Foundinterrupt = true
			end
		end
	end

	if not Foundinterrupt then SVMainMenu.interrupt:addParam("nil","No Enemies to Interrupt found", SCRIPT_PARAM_INFO, "") end
end

function ShadowVayne:FillMenu_StunSettings()
	SVMainMenu.autostunn:addParam("pushDistance", "Push Distance", SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
	SVMainMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.autostunn:addParam("target", "Stunn only Current Target", SCRIPT_PARAM_ONOFF, true)
end

function ShadowVayne:FillMenu_Draw()
	SVMainMenu.draw:addParam("DrawAARange", "Draw Basicattack Range", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.draw:addParam("DrawERange", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.draw:addParam("drawecolor", "E Range Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
	SVMainMenu.draw:addParam("drawaacolor", "Basicattack Range Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
	SVMainMenu.draw:addParam("LagFree", "Use LagFreeCircles", SCRIPT_PARAM_ONOFF, false)
end

function ShadowVayne:FillMenu_Autolevel()
		SVMainMenu.autolevel:addParam("UseAutoLevelfirst", "Use AutoLevelSpells Level 1-3", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autolevel:addParam("UseAutoLevelrest", "Use AutoLevelSpells Level 4-18", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autolevel:addParam("first3level", "Level 1-3:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		SVMainMenu.autolevel:addParam("restlevel", "Level 4-18:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		SVMainMenu.autolevel:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.autolevel:addParam("fap", "You can Click on the \"Q-W-E\"", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.autolevel:addParam("fap", "to change the Autospellorder", SCRIPT_PARAM_INFO, "","" )
end

function ShadowVayne:FillMenu_PermaShow()
	SVMainMenu.permashowsettings:addParam("epermashow", "PermaShow \"E on Next BasicAttack\"", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("carrypermashow", "PermaShow: AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("mixedpermashow", "PermaShow: Mixed Mode", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("laneclearpermashow", "PermaShow: Laneclear", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("lasthitpermashow", "PermaShow: Last hit", SCRIPT_PARAM_ONOFF, true)
end

function ShadowVayne:FillMenu_BotRK()
	SVMainMenu.botrksettings:addParam("botrkautocarry", "Use BotRK in AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.botrksettings:addParam("botrkmixedmode", "Use BotRK in MixedMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrklaneclear", "Use BotRK in LaneClear", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrklasthit", "Use BotRK in LastHit", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrkalways", "Use BotRK always", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrkmaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	SVMainMenu.botrksettings:addParam("botrkminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
end

function ShadowVayne:FillMenu_BilgeWater()
	SVMainMenu.bilgesettings:addParam("bilgeautocarry", "Use BilgeWater in AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.bilgesettings:addParam("bilgemixedmode", "Use BilgeWater in MixedMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgelaneclear", "Use BilgeWater in LaneClear", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgelasthit", "Use BilgeWater in LastHit", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgealways", "Use BilgeWater always", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgemaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	SVMainMenu.bilgesettings:addParam("bilgeminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
end

function ShadowVayne:FillMenu_Yomuus()
	SVMainMenu.youmuus:addParam("autocarry", "Use Youmuu's Ghostblade in AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.youmuus:addParam("mixedmode", "Use Youmuu's Ghostblade in MixedMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.youmuus:addParam("laneclear", "Use Youmuu's Ghostblade in LaneClear", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.youmuus:addParam("lasthit", "Use Youmuu's Ghostblade in LastHit", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.youmuus:addParam("always", "Use Youmuu's Ghostblade always", SCRIPT_PARAM_ONOFF, false)
end

function ShadowVayne:FillMenu_Tumble()
	SVMainMenu.tumble:addParam("Qautocarry", "Use Tumble in AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.tumble:addParam("Qmixedmode", "Use Tumble in MixedMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam("Qlaneclear", "Use Tumble in LaneClear", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam("Qlasthit", "Use Tumble in LastHit", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam("Qalways", "Use Tumble always", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
	SVMainMenu.tumble:addParam("QManaAutoCarry", "Min Mana to use Q in AutoCarry", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	SVMainMenu.tumble:addParam("QManaMixedMode", "Min Mana to use Q in MixedMode", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	SVMainMenu.tumble:addParam("QManaLaneClear", "Min Mana to use Q in LaneClear", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	SVMainMenu.tumble:addParam("QManaLastHit", "Min Mana to use Q in LastHit", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
end

function ShadowVayne:FillMenu_WallTumble()
	SVMainMenu.walltumble:addParam("spot1", "Draw & Use Spot 1 (Drake-Spot)", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.walltumble:addParam("spot2", "Draw & Use Spot 2 (Min-Spot)", SCRIPT_PARAM_ONOFF, true)
end

function ShadowVayne:FillMenu_SkinHack()
	SVMainMenu.skinhack:addParam("enabled", "Enable Skinhack", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.skinhack:addParam("skinid", "Choose the Skin: ", SCRIPT_PARAM_LIST, 1, { "No Skin", "Vindicator", "Aristocrat", "Dragonslayer", "Hearthseeker", "SKT T1" })
end

function ShadowVayne:FillMenu_Selector()
	SVMainMenu.selector:addParam("enabled", "Use VIP Selector", SCRIPT_PARAM_ONOFF, false)
end

function ShadowVayne:FillMenu_Debug()
	SVMainMenu.debugsettings:addSubMenu("Disable Callbacks: OnTick()", "tick")
	SVMainMenu.debugsettings.tick:addParam("activatemodes", "Disable Tick Callback: ActivateModes", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("checklevelchange", "Disable Tick Callback: CheckLevelChange", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("permashows", "Disable Tick Callback: PermaShows", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("botrk", "Disable Tick Callback: BotRK", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("bilgewater", "Disable Tick Callback: Bilgewater", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("gapcloseraftercast", "Disable Tick Callback: GapCloserAfterCast", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("gapcloserrengar", "Disable Tick Callback: GapCloserRengar", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("switchtogglemode", "Disable Tick Callback: SwitchToggleMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("threshlantern", "Disable Tick Callback: TreshLantern", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("condemnstun", "Disable Tick Callback: CondemnStun", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("twalltumble", "Disable Tick Callback: WallTumble", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("updateherodirection", "Disable Tick Callback: UpdateHeroDirection", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.tick:addParam("generatetarget", "Disable Tick Callback: GenerateTarget", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addSubMenu("Disable Callbacks: OnCreateObj()", "createobj")
	SVMainMenu.debugsettings.createobj:addParam("rengarobject", "Disable CreateObj Callback: RengarObject", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.createobj:addParam("threshobject", "Disable CreateObj Callback: ThreshObject", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addSubMenu("Disable Callbacks: OnProcessSpell()", "processspell")
	SVMainMenu.debugsettings.processspell:addParam("gapcloser", "Disable ProcessSpell Callback: GapCloser", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.processspell:addParam("interrupt", "Disable ProcessSpell Callback: Interrupt", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.processspell:addParam("basicattack", "Disable ProcessSpell Callback: BasicAttack", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.processspell:addParam("recall", "Disable ProcessSpell Callback: Recall", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addSubMenu("Disable Callbacks: OnDraw()", "draw")
	SVMainMenu.debugsettings.draw:addParam("dwalltumble", "Disable Draw Callback: WallTumble", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.draw:addParam("condemnrange", "Disable Draw Callback: CondemnRange", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.draw:addParam("aarange", "Disable Draw Callback: AARange", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addSubMenu("Disable Callbacks: OnSendPacket()", "sendpacket")
	SVMainMenu.debugsettings.sendpacket:addParam("pwalltumble", "Disable SendPacket Callback: WallTumble", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addSubMenu("Disable Callbacks: OnWndMsg()", "msg")
	SVMainMenu.debugsettings.msg:addParam("doublemodeprotection", "Disable Msg Callback: DoubleModeProtection", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addSubMenu("TargetDraw", "targetdraw")
	SVMainMenu.debugsettings.targetdraw:addParam("lefttop", "Draw the actual Target in the Top left corner", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.debugsettings.targetdraw:addParam("myhero", "Draw the actual Target on myHero", SCRIPT_PARAM_ONOFF, false)

	SVMainMenu.debugsettings:addParam("forcereset","Force AA/Taget/Script-Reset:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "G" ))
end

function ShadowVayne:ForceScriptReset()
	if SVMainMenu.debugsettings.forcereset then
		SOW:resetAA()
	end
end

function ShadowVayne:LoadSOW()
	SVSOWMenu = scriptConfig("[ShadowVayne] SimpleOrbWalker Settings", "SV_SOW")
	self.VP = VPrediction()
	SOWi = SOW(self.VP)
	SOWi:LoadToMenu(SVSOWMenu, self)
end

function ShadowVayne:LoadTS()
	SVTSMenu = scriptConfig("[ShadowVayne] TargetSelector", "SV_TS")
	for i, enemy in pairs(GetEnemyHeroes()) do
		SVTSMenu:addParam(enemy.charName,enemy.charName, SCRIPT_PARAM_SLICE, 1, 1, #GetEnemyHeroes(), 0)
	end
	SVTSMenu:addParam("fap","", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","Higher Number = Higher Focus", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","Means:", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","EnemyAdc = 5", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","EnemyTank = 1", SCRIPT_PARAM_INFO, "")
end

function ShadowVayne:ArrangeEnemies()
	local EnemiesFound = 0
	for z=1,#priorityTable.AD_Carry do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.AD_Carry[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.AP do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.AP[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Bruiser do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Bruiser[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Support do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Support[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Tank do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Tank[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end
end

function ShadowVayne:DoubleModeProtection(msg, key)
		if key == SVMainMenu.keysetting._param[7].key then -- AutoCarry
			  SVMainMenu.keysetting.mixedmode,SVMainMenu.keysetting.laneclear,SVMainMenu.keysetting.lasthit = false,false,false
		end

		if key == SVMainMenu.keysetting._param[8].key then -- MixedMode
			  SVMainMenu.keysetting.autocarry,SVMainMenu.keysetting.laneclear,SVMainMenu.keysetting.lasthit = false,false,false
		end

		if key == SVMainMenu.keysetting._param[9].key then -- LaneClear
			  SVMainMenu.keysetting.autocarry,SVMainMenu.keysetting.mixedmode,SVMainMenu.keysetting.lasthit = false,false,false
		end

		if key == SVMainMenu.keysetting._param[10].key then -- LastHit
			  SVMainMenu.keysetting.autocarry,SVMainMenu.keysetting.mixedmode,SVMainMenu.keysetting.laneclear = false,false,false
		end
end

function ShadowVayne:LoadRengar()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy.charName == "Rengar" then
			RengarHero = enemy
		end
	end
end

function ShadowVayne:LoadCustomPermaShow()
	_G.HidePermaShow["LaneClear OnHold:"] = true
	_G.HidePermaShow["Orbwalk OnHold:"] = true
	_G.HidePermaShow["LastHit OnHold:"] = true
	_G.HidePermaShow["HybridMode OnHold:"] = true
	_G.HidePermaShow["Condemn on next BasicAttack:"] = true
	_G.HidePermaShow["              Sida's Auto Carry: Reborn"] = true
	_G.HidePermaShow["Auto Carry"] = true
	_G.HidePermaShow["Last Hit"] = true
	_G.HidePermaShow["Mixed Mode"] = true
	_G.HidePermaShow["Lane Clear"] = true
	_G.HidePermaShow["Auto-Condemn"] = true
	_G.HidePermaShow["No mode active"] = true
	_G.HidePermaShow["ShadowVayne found. Set the Keysettings there!"] = true
end

function ShadowVayne:ActivateModes()
	--~ Get the Keysettings from SVMainMenu
	ShadowVayneAutoCarry = SVMainMenu.keysetting.autocarry
	ShadowVayneMixedMode = SVMainMenu.keysetting.mixedmode
	ShadowVayneLaneClear = SVMainMenu.keysetting.laneclear
	ShadowVayneLastHit = SVMainMenu.keysetting.lasthit

	--~ Recall-Check when ToggleMode is on
	if (Recalling or RecallCast) and SVMainMenu.keysetting.togglemode then
		ShadowVayneAutoCarry = false
		ShadowVayneMixedMode = false
		ShadowVayneLaneClear = false
		ShadowVayneLastHit = false
	end

	--~ Get The Selected Orbwalker
	AutoCarryOrbText = SVMainMenu.keysetting._param[12].listTable[SVMainMenu.keysetting.AutoCarryOrb]
	MixedModeOrbText = SVMainMenu.keysetting._param[13].listTable[SVMainMenu.keysetting.MixedModeOrb]
	LaneClearOrbText = SVMainMenu.keysetting._param[14].listTable[SVMainMenu.keysetting.LaneClearOrb]
	LastHitOrbText = SVMainMenu.keysetting._param[15].listTable[SVMainMenu.keysetting.LastHitOrb]

	--~ Activate MMA
	if AutoCarryOrbText == "MMA" then _G.MMA_Orbwalker = ShadowVayneAutoCarry end
	if MixedModeOrbText == "MMA" then _G.MMA_HybridMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "MMA" then _G.MMA_LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == "MMA" then _G.MMA_LastHit = ShadowVayneLastHit end

	--~ Activate SAC:Reborn R83
	if AutoCarryOrbText == "Reborn R83" then Keys.AutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Reborn R83" then Keys.MixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Reborn R83" then Keys.LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText   == "Reborn R83" then Keys.LastHit = ShadowVayneLastHit end

	--~ Activate SAC:Reborn R84
	if AutoCarryOrbText == "Reborn R84" then SVMainMenu.keysetting.SACAutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Reborn R84" then SVMainMenu.keysetting.SACMixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Reborn R84" then SVMainMenu.keysetting.SACLaneClear = ShadowVayneLaneClear end
	if LastHitOrbText   == "Reborn R84" then SVMainMenu.keysetting.SACLastHit = ShadowVayneLastHit end

	--~ Activate SAC:Revamped
--~ 	if AutoCarryOrbText == "Revamped" then REVMenu.AutoCarry = ShadowVayneAutoCarry end
--~ 	if MixedModeOrbText == "Revamped" then REVMenu.MixedMode = ShadowVayneMixedMode end
--~ 	if LaneClearOrbText == "Revamped" then REVMenu.LaneClear = ShadowVayneLaneClear end
--~ 	if LastHitOrbText == "Revamped" then REVMenu.LastHit = ShadowVayneLastHit end

	--~ Activate SOW
	if AutoCarryOrbText == "SOW" then SVSOWMenu.Mode0 = ShadowVayneAutoCarry end
	if MixedModeOrbText == "SOW" then SVSOWMenu.Mode1 = ShadowVayneMixedMode end
	if LaneClearOrbText == "SOW" then SVSOWMenu.Mode2 = ShadowVayneLaneClear end
	if LastHitOrbText == "SOW" then SVSOWMenu.Mode3 = ShadowVayneLastHit end
end

function ShadowVayne:CheckLevelChange()
	if GetGame().map.index == 8 and myHero.level < 4 and SVMainMenu.autolevel.UseAutoLevelfirst then
		LevelSpell(_Q)
		LevelSpell(_W)
		LevelSpell(_E)
	end
	if self.ShadowTable.LastLevelCheck + 100 < GetTickCount() then
		self.ShadowTable.LastLevelCheck = GetTickCount()
		if myHero.level ~= self.ShadowTable.LastHeroLevel then
			DelayAction(function() self:LevelUpSpell() end, 0.25)
			self.ShadowTable.LastHeroLevel = myHero.level
		end
	end
end

function ShadowVayne:LevelUpSpell()
	if SVMainMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
		LevelSpell(AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][SVMainMenu.autolevel.first3level]][myHero.level])
	end

	if SVMainMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
		LevelSpell(AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][SVMainMenu.autolevel.restlevel]][myHero.level])
	end
end

function ShadowVayne:SkinHack()
	if SVMainMenu.skinhack.enabled and self.CurSkin ~= SVMainMenu.skinhack.skinid then
		local SkinIdSwap = { [1] = 6, [2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5 }
		self.CurSkin = SVMainMenu.skinhack.skinid
		ShadowVayne:SkinChanger(myHero.charName, SkinIdSwap[self.CurSkin])
	end
end

function ShadowVayne:PermaShows()
	CustomPermaShow("AutoCarry (Using "..AutoCarryOrbText..")", SVMainMenu.keysetting.autocarry, SVMainMenu.permashowsettings.carrypermashow, nil, 1426521024, nil, 1)
	CustomPermaShow("MixedMode (Using "..MixedModeOrbText..")", SVMainMenu.keysetting.mixedmode, SVMainMenu.permashowsettings.mixedpermashow, nil, 1426521024, nil, 2)
	CustomPermaShow("LaneClear (Using "..LaneClearOrbText..")", SVMainMenu.keysetting.laneclear, SVMainMenu.permashowsettings.laneclearpermashow, nil, 1426521024, nil, 3)
	CustomPermaShow("LastHit (Using "..LastHitOrbText..")", SVMainMenu.keysetting.lasthit, SVMainMenu.permashowsettings.lasthitpermashow, nil, 1426521024, nil, 4)
	CustomPermaShow("Auto-E after next BasicAttack", SVMainMenu.keysetting.basiccondemn, SVMainMenu.permashowsettings.epermashow, nil, 1426521024, nil,  5)
end

function ShadowVayne:GenerateTarget()
	local TargetTable = { ["Hero"] = nil, ["AA"] = math.huge }
	for i, enemy in pairs(GetEnemyHeroes()) do
		if self:IsValid(enemy, 550.5) then
			NeededAA = self:GetAACount(enemy)
			if NeededAA < TargetTable.AA then
				TargetTable.AA = NeededAA
				TargetTable.Hero = enemy
			end
		end
	end
	if self.CurTarget ~= TargetTable["Hero"] then
		self.CurTarget = TargetTable["Hero"]
	end
end

function ShadowVayne:GetTarget(OnlyChamps)
	local SelectedTarget = GetTarget()
	if SelectedTarget and self:IsValid(SelectedTarget, 550.5) then
		if OnlyChamps then
			if SelectedTarget.type == myHero.type then
				return SelectedTarget
			end
		else
			return SelectedTarget
		end
	else
		if SVMainMenu.selector.enabled and FileExist(LIB_PATH.."Selector.lua") then
			if not SelectorInit then
				require("Selector")
				Selector.Instance()
				SelectorInit = true
			end
			SelectorTarget = Selector.GetTarget(SelectorMenu.Get().mode, nil, {distance = 800})
			if SelectorTarget and self:IsValid(SelectorTarget, 550.5) then
				return SelectorTarget
			else
				return self.CurTarget
			end
		else
			return self.CurTarget
		end
	end
end

function ShadowVayne:IsValid(target, range)
    if ValidTarget(target) and GetDistance(target) <= range + self.VP:GetHitBox(myHero) + self.VP:GetHitBox(target) then
		return true
    end
end

function ShadowVayne:GetDistanceSqr(p1, p2)
    p2 = p2 or player
    if p1 and p1.networkID and (p1.networkID ~= 0) and p1.visionPos then p1 = p1.visionPos end
    if p2 and p2.networkID and (p2.networkID ~= 0) and p2.visionPos then p2 = p2.visionPos end
    return GetDistanceSqr(p1, p2)
end

function ShadowVayne:HasBuff(unit, buffname)
    for i = 1, unit.buffCount do
        local tBuff = unit:getBuff(i)
        if tBuff.valid and BuffIsValid(tBuff) and tBuff.name == buffname then
            return true
        end
    end
    return false
end

function ShadowVayne:GetAACount(enemy)
		EnemyHP = math.ceil(enemy.health)
		if myHero:GetSpellData(_W).level > 0 then TargetTrueDmg = math.floor((((enemy.maxHealth/100)*(3+(myHero:GetSpellData(_W).level)))+(10+(myHero:GetSpellData(_W).level)*10))/3) else	TargetTrueDmg = 0 end
		AADMG = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor)) + TargetTrueDmg
		DMGThisAA = AADMG + TargetTrueDmg
		NeededAA = math.ceil(EnemyHP / DMGThisAA)
		NeededAARoundDown = (math.floor(NeededAA/3))*3
		DMGWithAA = NeededAARoundDown * DMGThisAA
		PredictHP = EnemyHP - DMGWithAA
		RestAA = math.ceil(PredictHP / AADMG)

		if RestAA > 2 then
			return NeededAA
		else
			return NeededAARoundDown + RestAA
		end
end

function ShadowVayne:BotRK()
	local Target = self:GetTarget()
	if Target ~= nil and GetDistance(Target) < 510 and not Target.dead and Target.visible then
		if (SVMainMenu.botrksettings.botrkautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.botrksettings.botrkmixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.botrksettings.botrklaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.botrksettings.botrklasthit and ShadowVayneLastHit) or
		 (SVMainMenu.botrksettings.botrkalways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.botrksettings.botrkmaxheal then
				if (math.floor(Target.health / Target.maxHealth * 100)) >= SVMainMenu.botrksettings.botrkminheal then
					local BladeSlot = GetInventorySlotItem(3153)
					if BladeSlot ~= nil and myHero:CanUseSpell(BladeSlot) == 0 then
						CastSpell(BladeSlot, Target)
					end
				end
			end
		end
	end
end

function ShadowVayne:BilgeWater()
	local Target = self:GetTarget()
	if Target ~= nil and GetDistance(Target) < 510 and not Target.dead and Target.visible then
		if (SVMainMenu.bilgesettings.bilgeautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.bilgesettings.bilgemixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.bilgesettings.bilgelaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.bilgesettings.bilgelasthit and ShadowVayneLastHit) or
		 (SVMainMenu.bilgesettings.bilgealways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.bilgesettings.bilgemaxheal then
				if (math.floor(Target.health / Target.maxHealth * 100)) >= SVMainMenu.bilgesettings.bilgeminheal then
					local BilgeSlot = GetInventorySlotItem(3144)
					if BilgeSlot ~= nil and myHero:CanUseSpell(BilgeSlot) == 0 then
						CastSpell(BilgeSlot, Target)
					end
				end
			end
		end
	end
end

function ShadowVayne:Youmuus()
	if (SVMainMenu.youmuus.autocarry and ShadowVayneAutoCarry) or
	 (SVMainMenu.youmuus.mixedmode and ShadowVayneMixedMode) or
	 (SVMainMenu.youmuus.laneclear and ShadowVayneLaneClear) or
	 (SVMainMenu.youmuus.lasthit and ShadowVayneLastHit) or
	 (SVMainMenu.youmuus.always) then
		local YoumuusSlot = GetInventorySlotItem(3142)
		if YoumuusSlot and myHero:CanUseSpell(YoumuusSlot) == 0 then
			CastSpell(YoumuusSlot)
		end
	end
end

function ShadowVayne:GapCloserAfterCast()
	if spellExpired == false and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 and myHero:CanUseSpell(_E) == READY then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local SkillShot = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
		if heroPosition:distance(SkillShot) <= 350 then
			CastSpell(_E, informationTable.spellSource)
		end
	else
		spellExpired = true
		informationTable = {}
	end
end

function ShadowVayne:GapCloserRengar()
	if ShootRengar and not RengarHero.dead and RengarHero.health > 0 and GetDistanceSqr(RengarHero) < 1000*1000 and myHero:CanUseSpell(_E) == READY then
		CastSpell(_E, RengarHero)
	else
		ShootRengar = false
	end
end

function ShadowVayne:RengarObject(Obj)
	if RengarHero ~= nil and Obj.name == "Rengar_LeapSound.troy" and GetDistanceSqr(RengarHero) < 1000*1000 then
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."AutoCarry"] and ShadowVayneAutoCarry then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."LastHit"] and ShadowVayneMixedMode then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."MixedMode"] and ShadowVayneLaneClear then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."LaneClear"] and ShadowVayneLastHit then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."Always"] then ShootRengar = true end
	end
end

function ShadowVayne:ThreshObject(Obj)
	if Obj.name == "ThreshLantern" then
		LanternObj = Obj
	end
end

function ShadowVayne:SwitchToggleMode()
	if OldToggleStatus ~= SVMainMenu.keysetting.togglemode then
		OldToggleStatus = SVMainMenu.keysetting.togglemode
		if SVMainMenu.keysetting.togglemode then
			SVMainMenu.keysetting._param[7].pType = SCRIPT_PARAM_ONKEYTOGGLE
			SVMainMenu.keysetting._param[8].pType = SCRIPT_PARAM_ONKEYTOGGLE
			SVMainMenu.keysetting._param[9].pType = SCRIPT_PARAM_ONKEYTOGGLE
			SVMainMenu.keysetting._param[10].pType = SCRIPT_PARAM_ONKEYTOGGLE
		else
			SVMainMenu.keysetting._param[7].pType = SCRIPT_PARAM_ONKEYDOWN
			SVMainMenu.keysetting._param[8].pType = SCRIPT_PARAM_ONKEYDOWN
			SVMainMenu.keysetting._param[9].pType = SCRIPT_PARAM_ONKEYDOWN
			SVMainMenu.keysetting._param[10].pType = SCRIPT_PARAM_ONKEYDOWN
		end
	end
end

function ShadowVayne:TreshLantern()
	if VIP_USER and SVMainMenu.keysetting.threshlantern and LanternObj then
		LanternPacket = CLoLPacket(0x3A)
		LanternPacket:EncodeF(myHero.networkID)
		LanternPacket:EncodeF(LanternObj.networkID)
		LanternPacket.dwArg1 = 1
		LanternPacket.dwArg2 = 0
		SendPacket(LanternPacket)
	end
end

function ShadowVayne:ProcessSpell_GapCloser(unit, spell)
	if unit.team ~= myHero.team then
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then CastSpell(_E, unit) end
			end
		end

		if isAGapcloserUnitNoTarget[spell.name] and GetDistanceSqr(unit) <= 2000*2000 and (spell.target == nil or spell.target.isMe) then
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."Always"] then spellExpired = false end
			informationTable = {
				spellSource = unit,
				spellCastedTick = GetTickCount(),
				spellStartPos = Point(spell.startPos.x, spell.startPos.z),
				spellEndPos = Point(spell.endPos.x, spell.endPos.z),
				spellRange = isAGapcloserUnitNoTarget[spell.name].range,
				spellSpeed = isAGapcloserUnitNoTarget[spell.name].projSpeed,
				spellName = spell.name
			}
		end
	end
end

function ShadowVayne:ProcessSpell_Interrupt(unit, spell)
	if unit.team ~= myHero.team then
		if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistanceSqr(unit) <= 715*715 then
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then CastSpell(_E, unit) end
		end
	end
end

function ShadowVayne:ProcessSpell_BasicAttack(unit, spell)
	if unit.isMe then
		if spell.name:lower():find("attack") then
			self.LastAATarget = spell.target
			self.LastAATime = GetTickCount()
			self.EndTumbleTime = GetTickCount() + ((spell.animationTime - (spell.windUpTime * 2) - (GetLatency()/2))*1000)
			if SVMainMenu.keysetting.basiccondemn then
				DelayAction(function() self:CondemnAfterAA() end, spell.windUpTime - (GetLatency()/2000))
			else
				DelayAction(function() self:Tumble() end, spell.windUpTime - (GetLatency()/2000))
			end
			self:Youmuus()
		elseif spell.name:lower():find("condemn") then
			self.LastAATarget = spell.target
			self.LastAATime = GetTickCount()
			self.EndTumbleTime = GetTickCount() + ((spell.animationTime - (spell.windUpTime * 2) - (GetLatency()/2))*1000)
			DelayAction(function() self:Tumble() end, spell.windUpTime - (GetLatency()/2000))
		else
			DelayAction(function() SOW:resetAA() end, spell.animationTime)
		end
	end
end

function ShadowVayne:CondemnAfterAA()
	if SVMainMenu.keysetting.basiccondemn and self.LastAATarget.type == myHero.type then
		CastSpell(_E, self.LastAATarget)
	end
	SVMainMenu.keysetting.basiccondemn = false
end

function ShadowVayne:Tumble()
	if  (SVMainMenu.tumble.Qautocarry and ShadowVayneAutoCarry and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaAutoCarry)) or
		(SVMainMenu.tumble.Qmixedmode and ShadowVayneMixedMode and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaMixedMode)) or
		(SVMainMenu.tumble.Qlaneclear and ShadowVayneLaneClear and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLaneClear)) or
		(SVMainMenu.tumble.Qlasthit and  ShadowVayneLastHit and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLastHit)) or
		(SVMainMenu.tumble.Qalways) then
		local AfterTumblePos = myHero + (Vector(mousePos) - myHero):normalized() * 300
		if GetDistance(AfterTumblePos, self.LastAATarget) < 650 and GetDistance(AfterTumblePos, self.LastAATarget) > 100 then
			CastSpell(_Q, mousePos.x, mousePos.z)
		end
		if GetDistance(self.LastAATarget) > 650 and GetDistance(AfterTumblePos, self.LastAATarget) < 650 then
			CastSpell(_Q, mousePos.x, mousePos.z)
		end
	end
	if GetTickCount() < self.EndTumbleTime then DelayAction(function() self:Tumble() end, 0) end
end

function ShadowVayne:ProcessSpell_Recall(unit, spell)
	if unit.isMe then
		if spell.name == "Recall" then
			RecallCast = true
			DelayAction(function() RecallCast = false end, 0.75)
		end
	end
end

function ShadowVayne:Draw_WallTumble()
	if VIP_USER then
		if SVMainMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.VisionPos_1) < 125 or GetDistance(TumbleSpots.VisionPos_1, mousePos) < 125 then
				DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x107458)
			else
				DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x80FFFF)
			end
		end
		if SVMainMenu.walltumble.spot2 then
			if GetDistance(TumbleSpots.VisionPos_2) < 125 or GetDistance(TumbleSpots.VisionPos_2, mousePos) < 125 then
				DrawCircle(TumbleSpots.VisionPos_2.x, TumbleSpots.VisionPos_2.y, TumbleSpots.VisionPos_2.z, 100, 0x107458)
			else
				DrawCircle(TumbleSpots.VisionPos_2.x, TumbleSpots.VisionPos_2.y, TumbleSpots.VisionPos_2.z, 100, 0x80FFFF)
			end
		end
	end
end

function ShadowVayne:Draw_CondemnRange()
	if SVMainMenu.draw.DrawERange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, 710, ARGB(SVMainMenu.draw.drawecolor[1], SVMainMenu.draw.drawecolor[2],SVMainMenu.draw.drawecolor[3],SVMainMenu.draw.drawecolor[4]))
	end
end

function ShadowVayne:Draw_AARange()
	if SVMainMenu.draw.DrawAARange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, 655, ARGB(SVMainMenu.draw.drawaacolor[1], SVMainMenu.draw.drawaacolor[2],SVMainMenu.draw.drawaacolor[3],SVMainMenu.draw.drawaacolor[4]))
	end

--~ 	for i = 1, #LastPosTable do
--~ 		if ValidTarget(LastPosTable[i].unit) and #self.wayPointManager:GetWayPoints(LastPosTable[i].unit) > 1 then
--~ 			local DirDraw = Vector(LastPosTable[i].unit) + (LastPosTable[i].dir):normalized()*(100)
--~ 			self:CircleDraw(DirDraw.x, DirDraw.y, DirDraw.z, 50, 0x00FFFFFF)
--~ 		end
--~ 	end


--~ 	for i= 1,#ProdictionCircle do
--~ 		for z, enemy in ipairs(GetEnemyHeroes()) do
--~ 			self:CircleDraw(ProdictionCircle[enemy.charName].x, ProdictionCircle[enemy.charName].y, ProdictionCircle[enemy.charName].z, 50, 0x00FFFFFF)
--~ 			self:CircleDraw(ProdictionCircle[enemy.charName].x, ProdictionCircle[enemy.charName].y, ProdictionCircle[enemy.charName].z, 55, 0x00FFFFFF)
--~ 			self:CircleDraw(ProdictionCircle[enemy.charName].x, ProdictionCircle[enemy.charName].y, ProdictionCircle[enemy.charName].z, 60, 0x00FFFFFF)
--~ 			self:CircleDraw(ProdictionCircle[enemy.charName].x, ProdictionCircle[enemy.charName].y, ProdictionCircle[enemy.charName].z, 65, 0x00FFFFFF)
--~ 			print(ProdictionCircle[enemy.charName])
--~ 		end
--~ 	end
end

function ShadowVayne:UpdateLastPos()
	for i = 1, #LastPosTable do
		local NewPos = LastPosTable[i].unit.pos
		local LastPosX = LastPosTable[i].posX
		if NewPos.x ~= LastPosX then
			LastPosTable[i].dir = (Vector(NewPos) - Vector(LastPosTable[i].posX,LastPosTable[i].posY,LastPosTable[i].posZ))
			LastPosTable[i].posX = NewPos.x
			LastPosTable[i].posY = NewPos.y
			LastPosTable[i].posZ = NewPos.z
		end
	end

end

function ShadowVayne:CheckWallStun(PredictPos, Source, Hitchance)
	local BushFound, Bushpos = false, nil
	if CondemnLastE + 1000 < GetTickCount() then
		for i = 1, SVMainMenu.autostunn.pushDistance, 20  do
			local CheckWallPos = Vector(PredictPos) + (Vector(PredictPos) - myHero):normalized()*(i)
			local WorldType = self:GetWorldType(CheckWallPos.x, CheckWallPos.z)
			if not BushFound and WorldType == 2 then
				BushFound = true
				BushPos = CheckWallPos
			end
			if WorldType == 1 then
				if UnderTurret(CheckWallPos, true) then
					if SVMainMenu.autostunn.towerstunn then
						AllowTumble = false
						CastSpell(_E, Source)
						print("Stunned: "..Source.charName..". HitChance: "..Hitchance ..". Tower: true")
						ProdictionCircle[Source.charName].x = CheckWallPos.x
						ProdictionCircle[Source.charName].y = CheckWallPos.y
						ProdictionCircle[Source.charName].z = CheckWallPos.z
						CondemnLastE = GetTickCount()
						break
					end
				else
					AllowTumble = false
					print("Stunned: "..Source.charName..". HitChance: "..Hitchance)
					CastSpell(_E, Source)
					ProdictionCircle[Source.charName].x = CheckWallPos.x
					ProdictionCircle[Source.charName].y = CheckWallPos.y
					ProdictionCircle[Source.charName].z = CheckWallPos.z
					CondemnLastE = GetTickCount()
					if BushFound and SVMainMenu.autostunn.trinket and myHero:CanUseSpell(ITEM_7) == 0 then
						CastSpell(ITEM_7, BushPos.x, BushPos.z)
					end
					break
				end
			end
		end
	end
end

function ShadowVayne:CondemnStun()
	local Target = self:GetTarget(true)
	if myHero:CanUseSpell(_E) == READY and GetTickCount() > (CondemnLastE + 1000) then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if SVMainMenu.autostunn.target then enemy = Target end
			if enemy == nil then return end
			if (SVMainMenu.targets[enemy.charName]["autocarry"] and ShadowVayneAutoCarry) or
			(SVMainMenu.targets[enemy.charName]["mixedmode"] and ShadowVayneMixedMode) or
			(SVMainMenu.targets[enemy.charName]["laneclear"] and ShadowVayneLaneClear) or
			(SVMainMenu.targets[enemy.charName]["lasthit"] and ShadowVayneLastHit) or
			(SVMainMenu.targets[enemy.charName]["always"]) then
				if GetDistance(enemy) <= 1000 and not enemy.dead and enemy.visible then
					if not VIP_USER then -- FREEUSER
						StunPos = self:GetCondemCollisionTime(enemy)
						if StunPos ~= nil and GetDistance(StunPos) < 710 then
							self:CheckWallStun(StunPos, enemy, 0)
						end
					end

					if VIP_USER then -- PR0D
						StunPos, StunnInfo = Prodiction.GetPrediction(enemy, 710, 1600, 0.25, 10, myHero)
						if StunPos and GetDistanceSqr(StunPos) < 710*710 and StunnInfo and StunnInfo.hitchance > 1 then
							for i=1,#LastPosTable do
								if LastPosTable[i].unit.charName == enemy.charName then
									if #self.wayPointManager:GetWayPoints(LastPosTable[i].unit) > 1 then
										StunPos = Vector(StunPos) + (LastPosTable[i].dir):normalized()*(enemy.ms * 0.15)
									end
									self:CheckWallStun(StunPos, enemy, StunnInfo.hitchance)
								end
							end
						end
					end
				end
			end
		end
	end
end

function ShadowVayne:WallTumble()
	if VIP_USER then
		if myHero:CanUseSpell(_Q) ~= READY then TumbleOverWall_1, TumbleOverWall_2 = false,false end
		if TumbleOverWall_1 and SVMainMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.StandPos_1) <= 25 then
				TumbleOverWall_1 = false
				CastSpell(_Q, TumbleSpots.CastPos_1.x,  TumbleSpots.CastPos_1.y)
				myHero:HoldPosition()
			else
				if GetDistance(TumbleSpots.StandPos_1) > 25 then myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y) end
			end
		end
		if TumbleOverWall_2 and SVMainMenu.walltumble.spot2 then
			if GetDistance(TumbleSpots.StandPos_2) <= 25 then
				TumbleOverWall_2 = false
				CastSpell(_Q, TumbleSpots.CastPos_2.x,  TumbleSpots.CastPos_2.y)
				myHero:HoldPosition()
			else
				if GetDistance(TumbleSpots.StandPos_2) > 25 then myHero:MoveTo(TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y) end
			end
		end
	end
end

function ShadowVayne:SendPacket_WallTumble(p)
	if p.header == _G.Packet.headers.S_CAST then
		if SVMainMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.VisionPos_1) < 125 or GetDistance(TumbleSpots.VisionPos_1, mousePos) < 125 then
				p.pos = 1
				P_NetworkID = p:DecodeF()
				P_SpellID = p:Decode1()
				if P_NetworkID == myHero.networkID and P_SpellID == _Q then
					if DontBlockNext then
						DontBlockNext = false
					else
						p:Block()
						DontBlockNext = true
						TumbleOverWall_1 = true
					end
				end
			end
		end

		if SVMainMenu.walltumble.spot2 then
			if GetDistance(TumbleSpots.VisionPos_2) < 125 or GetDistance(TumbleSpots.VisionPos_2, mousePos) < 125 then
				p.pos = 1
				P_NetworkID = p:DecodeF()
				P_SpellID = p:Decode1()
				if P_NetworkID == myHero.networkID and P_SpellID == _Q then
					if DontBlockNext then
						DontBlockNext = false
					else
						p:Block()
						DontBlockNext = true
						TumbleOverWall_2 = true
					end
				end
			end
		end
	end

	if p.header == _G.Packet.headers.S_MOVE then
		p.pos = 1
		P_NetworkID = p:DecodeF()
		p:Decode1()
		P_X = p:DecodeF()
		P_X2 = tonumber(string.format("%." .. (2) .. "f", P_X))

		P_Y = p:DecodeF()
		P_Y2 = tonumber(string.format("%." .. (2) .. "f", P_Y))
		if TumbleOverWall_1 == true and SVMainMenu.walltumble.spot1 then
			RunToX, RunToY = TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y
			if not (P_X2 == RunToX and P_Y2 == RunToY) then
				p:Block()
				myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y)
			end
		end
		if TumbleOverWall_2 == true and SVMainMenu.walltumble.spot2 then
			RunToX, RunToY = TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y
			if not (P_X2 == RunToX and P_Y2 == RunToY) then
				p:Block()
				myHero:MoveTo(TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y)
			end
		end
	end
end

function ShadowVayne:UpdateHeroDirection() --Function done by Yomie from EzCondemn
	for heroName, heroObj in pairs(heroDirDB) do
		local hero = heroManager:GetHero(heroObj.index)
		local currentVec = Vector(hero)
		local dir = (currentVec - heroObj.lastVec)

		if dir ~= Vector(0,0,0) then
			dir = dir:normalized()
		end

		heroObj.lastAngle = heroObj.dir:dotP( dir )
		heroObj.dir = dir
		heroObj.lastVec = currentVec
	end
end

function ShadowVayne:GetCondemCollisionTime(target) --Function done by Yomie from EzCondemn
	local heroObj = heroDirDB[target.name]

	if heroObj.dir ~= Vector(0,0,0) then

	if heroObj.lastAngle and heroObj.lastAngle < .8 then
		return nil
	end


	local windupPos = Vector(target) + heroObj.dir * (target.ms * 250/1000)
	local timeElapsed = self:GetCollisionTime(windupPos, heroObj.dir, target.ms, myHero, 2000 )

	if timeElapsed == nil then
		return nil
	end

	return Vector(target) + heroObj.dir * target.ms * (timeElapsed + .25)/2

	end

	return Vector(target)
end

function ShadowVayne:GetCollisionTime (targetPos, targetDir, targetSpeed, sourcePos, projSpeed ) --Function done by Yomie from EzCondemn
	local velocity = targetDir * targetSpeed

	local velocityX = velocity.x
	local velocityY = velocity.z

	local relStart = targetPos - sourcePos

	local relStartX = relStart.x
	local relStartY = relStart.z

	local a = velocityX * velocityX + velocityY * velocityY - projSpeed * projSpeed
	local b = 2 * velocityX * relStartX + 2 * velocityY * relStartY
	local c = relStartX * relStartX + relStartY * relStartY

	local disc = b * b - 4 * a * c

	if disc >= 0 then
		local t1 = -( b + math.sqrt( disc )) / (2 * a )
		local t2 = -( b - math.sqrt( disc )) / (2 * a )


		if t1 and t2 and t1 > 0 and t2 > 0 then
			if t1 > t2 then
				return t2
			else
				return t1
			end
		elseif t1 and t1 > 0 then
			return t1
		elseif t2 and t2 > 0 then
			return t2
		end
	end

	return nil
end

function ShadowVayne:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
 radius = radius or 300
 quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
 quality = 2 * math.pi / quality
 radius = radius*.92
 local points = {}
 for theta = 0, 2 * math.pi + quality, quality do
  local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
  points[#points + 1] = D3DXVECTOR2(c.x, c.y)
 end
 DrawLines2(points, width or 1, color or 4294967295)
end

function ShadowVayne:DrawCircle2(x, y, z, radius, color)
 local vPos1 = Vector(x, y, z)
 local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
 local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
 local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
 if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
  self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
 end
end

function ShadowVayne:CircleDraw(x,y,z,radius, color)
	if SVMainMenu.draw.LagFree then
		self:DrawCircle2(x, y, z, radius, color)
	else
		DrawCircle(x, y, z, radius, color)
	end
end

function ShadowVayne:DebugDraw()
	local DebugTarget = self:GetTarget()
	if DebugTarget then
	PrintTarget = DebugTarget.charName
	PrintDistance = math.floor(GetDistance(DebugTarget))
	else
	PrintTarget = "nil"
	PrintDistance = "nil"
	end
	if SVMainMenu.debugsettings.targetdraw.lefttop then
		DrawText("Current Target: "..PrintTarget, 15, 10, 10, 4294967280) -- ivory
		DrawText("Current Distance: "..PrintDistance, 15, 10, 25, 4294967280) -- ivory
	end
	if SVMainMenu.debugsettings.targetdraw.myhero then
	    local p = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
		DrawText("Current Target: "..PrintTarget, 15, p.x - GetTextArea("Current Target: "..PrintTarget, 15).x / 2, p.y, color or 4294967295)
		DrawText("Current Distance: "..PrintDistance, 15, p.x - GetTextArea("Current Distance: "..PrintDistance, 15).x / 2, p.y + 15, color or 4294967295)
	end
end

function ShadowVayne:SkinChanger(champ, skinId) -- Credits to shalzuth
    p = CLoLPacket(0x97)
    p:EncodeF(myHero.networkID)
    p.pos = 1
    t1 = p:Decode1()
    t2 = p:Decode1()
    t3 = p:Decode1()
    t4 = p:Decode1()
    p:Encode1(t1)
    p:Encode1(t2)
    p:Encode1(t3)
    p:Encode1(bit32.band(t4,0xB))
    p:Encode1(1)--hardcode 1 bitfield
    p:Encode4(skinId)
    for i = 1, #champ do
        p:Encode1(string.byte(champ:sub(i,i)))
    end
    for i = #champ + 1, 64 do
        p:Encode1(0)
    end
    p:Hide()
    RecvPacket(p)
end