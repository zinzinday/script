if myHero.charName ~= "Sivir" then return end
--[[
	
/$$$$$$$$                   /$$                           /$$     /$$ /$$              /$$$$$$  /$$            /$$          
| $$_____/                  | $$                          | $$    |__/| $$             /$$__  $$|__/           |__/          
| $$    /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$   /$$| $$   /$$      | $$  \__/ /$$ /$$    /$$ /$$  /$$$$$$ 
| $$$$$|____  $$| $$__  $$|_  $$_/   |____  $$ /$$_____/|_  $$_/  | $$| $$  /$$/      |  $$$$$$ | $$|  $$  /$$/| $$ /$$__  $$
| $$__/ /$$$$$$$| $$  \ $$  | $$      /$$$$$$$|  $$$$$$   | $$    | $$| $$$$$$/        \____  $$| $$ \  $$/$$/ | $$| $$  \__/
| $$   /$$__  $$| $$  | $$  | $$ /$$ /$$__  $$ \____  $$  | $$ /$$| $$| $$_  $$        /$$  \ $$| $$  \  $$$/  | $$| $$      
| $$  |  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$ \  $$      |  $$$$$$/| $$   \  $/   | $$| $$      
|__/   \_______/|__/  |__/   \___/   \_______/|_______/    \___/  |__/|__/  \__/       \______/ |__/    \_/    |__/|__/      



Credits: Fantastik - Scripting the most parts, original creator 
         CrazyDud - Ideas, helping me to create
         QQQ - Also helping, fixing problems and teaching me stuff
		 Honda7 - Common Honda7 stuff
		 Anyone else that I might have forgotten

How to install: Go to Custom Scripts tab and press New Script. Paste the script inside there and click Save Script.
!ATTENTION!: Name it exactly "Fantastik Sivir".

Features:

   Key   |                  What it does
------------------------------------------------------------------------------------
Spacebar | Combo key - Uses Q, W and R. Spell usage can be disabled.
------------------------------------------------------------------------------------
    C    | Poke key - Uses Q to poke the enemy. Can be disabled.
------------------------------------------------------------------------------------
    X    | Last Hit - Last hits the minions with AA.
------------------------------------------------------------------------------------
    C	 | Mixed Mode - Both last hit and poke.
------------------------------------------------------------------------------------
    V    | Lane Clear - Lane clear with AA, Q and W.
------------------------------------------------------------------------------------

Other features:

*	Free users & VIP users support!
*	Slice for minimum amount of enemies for R!
*	Slice for Q range!
*	Slice for mana manager for combo!
*	Smart lane clear using Q!
*	Slice for mana manager for farm!
*	Evadeee integration for E!
*	Auto Ignite in combo and if killable(KS)!
*	Auto Q kill if killable!
*	In-Game skin changer(Sadly VIP only)!
*	Auto level spells!
*	Text Drawing for targets
*	More to come soon!


Changelog:	
* v 2.2
 Removed Skin Hack
 Added tracker

* v 2
 Added Auto-E shield

* v 1.1
 Removed BoL Tracker
 Added HitChance for Q Poke
 Added choose Q target

* v 1
 Added Packet casting for VIP users
 Improved hitchance, it shall be working better

* v 0.97
 Fixed Auto Ignite for 4.15
 Now can name the script file however you like

* v 0.96
 Added Mana slider for Poke
 Changed Poke key to C

* v 0.95
 Added SAC and MMA support!
 Fixed Q not casting through minions!

* v 0.94
 Added In-Game announcer!

* v 0.93
 Added BoL Tracker, will check script runs.

* v 0.9
 Added text drawing for targets

* v 0.82 
 Fixed a mistype error.

* v 0.81
 Remade Auto Level Spell function to a better one.

* v 0.8
 Added Manual HitChance settings
 Added use W on Lane Clear
 Fixed a little mistype on Poke

* v 0.65
 Fixed the range of Q which would change instead of only Combo
 Minor improvements

* v 0.6
 Added In-Game skin changer, thanks to shalzuth
 Added Auto spell leveler

* v 0.5
 Added Q for farm, will check for best pos to Q
 Added Q farm mana manager

* v 0.4
 Added AA reset with W

* v 0.3
 Added reqiured Libs download.
 Combo Q fix for free users.

* v 0.2:
 Added Auto Update
 Minor fixes
 Improvements

* v 0.1:
 Release
]]

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("WJMKLIOPPQL") 

--[[		Auto Update		]]
local sversion = "2.2"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BoLFantastik/BoL/master/Fantastik Sivir.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Fantastik Sivir:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/BoLFantastik/BoL/master/version/Fantastik Sivir.version")
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
		["VPrediction"] = "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua",
		["SOW"] = "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua",
--		if VIP_USER then ["Prodiction"] = "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/7f8427d943e993667acd4a51a39cf9aa2b71f222/Test/Prodiction/Prodiction.lua" end,
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

		print("<font color=\"#00FF00\">Fantastik Sivir:</font><font color=\"#FFDFBF\"> Not all required libraries are installed. Downloading: <b><u><font color=\"#73B9FF\">"..DOWNLOAD_LIB_NAME.."</font></u></b> now! Please don't press [F9]!</font>")
		print("Download started")
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
		print("Download finished")
	end
end

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<font color=\"#00FF00\">Fantastik Sivir:</font><font color=\"#FFDFBF\"> Required libraries downloaded successfully, please reload (double [F9]).</font>")
	end
end
if DOWNLOADING_LIBS then return end

--[[		Code		]]
local sauthor = "Fantastik"
local QREADY, WREADY, EREADY, RREADY = false
local Qrange, Qwidth, Qspeed, Qdelay = 1075, 85, 1350, 0.250
local Rrange = 1000
local ignite = nil
local iDmg = 0
local target = nil
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, Qrange, DAMAGE_PHYSICAL, true)
local Announcer = ""
local isSOW = false
local isSAC = false
local isMMA = false
local Spells = {_Q,_W,_E,_R}
local Spells2 = {"Q","W","E","R"}

--[[	Drawings	]]
TextList = {"Poke", "1 AA kill!", "2 AA kill!", "3 AA kill!", "Q kill!", "Q + 1 AA kill!", "Q + 2 AA kill!", "Q + 3 AA kill!", "Q + 4 AA kill!"}
KillText = {}
colorText = ARGB(255,255,204,0)

Champions = {
    ["Lux"] = {charName = "Lux", skillshots = {
        ["LuxLightBinding"] =  {name = "Light Binding", spellName = "LuxLightBinding", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line",  SpellType = "skillshot"},
        ["LuxLightStrikeKugel"] = {name = "LuxLightStrikeKugel", spellName = "LuxLightStrikeKugel", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "circular",  SpellType = "skillshot"},
        ["LuxMaliceCannon"] =  {name = "Lux Malice Cannon", spellName = "LuxMaliceCannon", castDelay = 1375, projectileName = "Enrageweapon_buf_02.troy", projectileSpeed = math.huge, range = 3500, radius = 190, type = "line",  SpellType = "skillshot"},
    }},
    ["Nidalee"] = {charName = "Nidalee", skillshots = {
        ["JavelinToss"] = {name = "Javelin Toss", spellName = "JavelinToss", castDelay = 125, projectileName = "nidalee_javelinToss_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line",  SpellType = "skillshot"}
    }},
    
    ["Akali"] = {charName = "Akali", skillshots = {
        ["AkaliMota"] = {name = "AkaliMota", spellName = "AkaliMota", castDelay = 125, projectileName = "AkaliMota_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line",  SpellType = "castcel"},
		["AkaliShadowDance"] = {name = "AkaliShadowSwipe", spellName = "AkaliShadowSwipe", SpellType == "castcel"},
    }},
	["Alistar"] = {charName = "Alistar", skillshots = {
		['Pulverize'] = {name = "Pulverize", spellName = "Pulverize", SpellType = "castcel"}
	}},
    ["Kennen"] = {charName = "Kennen", skillshots = {
        ["KennenShurikenHurlMissile1"] = {name = "Thundering Shuriken", spellName = "KennenShurikenHurlMissile1", castDelay = 180, projectileName = "kennen_ts_mis.troy", projectileSpeed = 1700, range = 1050, radius = 50, type = "line",  SpellType = "skillshot"}--could be 4 if you have 2 marks
    }},
    ["Amumu"] = {charName = "Amumu", skillshots = {
        ["BandageToss"] = {name = "Bandage Toss", spellName = "BandageToss", castDelay = 250, projectileName = "Bandage_beam.troy", projectileSpeed = 2000, range = 1100, radius = 80, type = "line", evasiondanger = true,  SpellType = "skillshot"}
    }},
    ["LeeSin"] = {charName = "LeeSin", skillshots = {
        ["BlindMonkQOne"] = {name = "Sonic Wave", spellName = "BlindMonkQOne", castDelay = 250, projectileName = "blindMonk_Q_mis_01.troy", projectileSpeed = 1800, range = 1100, radius = 60+10, type = "line",  SpellType = "skillshot"} --if he hit this he will slow you
    }},
    ["Morgana"] = {charName = "Morgana", skillshots = {
        ["DarkBindingMissile"] = {name = "Dark Binding", spellName = "DarkBindingMissile", castDelay = 250, projectileName = "DarkBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line",  SpellType = "skillshot"},
        ["TormentedSoil"] = {name = "Tormented Soil", spellName = "TormentedSoil", castDelay = 250, projectileName = "", projectileSpeed = 1200, range = 900, radius = 300, type = "circular", blockable = false, SpellType = "skillshot"},
    }},
    ["Ezreal"] = {charName = "Ezreal", skillshots = {
        ["EzrealMysticShot"]             = {name = "Mystic Shot",      spellName = "EzrealMysticShot",      castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 2000, range = 1200,  radius = 80,  type = "line",  SpellType = "skillshot"},
        ["EzrealEssenceFlux"]            = {name = "Essence Flux",     spellName = "EzrealEssenceFlux",     castDelay = 250, projectileName = "Ezreal_essenceflux_mis.troy", projectileSpeed = 1500, range = 1050,  radius = 80,  type = "line",  SpellType = "skillshot"},
        ["EzrealMysticShotPulse"] = {name = "Mystic Shot",      spellName = "EzrealMysticShotPulse", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy",  projectileSpeed = 2000, range = 1200,  radius = 80,  type = "line",  SpellType = "skillshot"},
        ["EzrealTrueshotBarrage"]        = {name = "Trueshot Barrage", spellName = "EzrealTrueshotBarrage", castDelay = 1000, projectileName = "Ezreal_TrueShot_mis.troy",    projectileSpeed = 2000, range = 20000, radius = 160, type = "line", fuckedUp = true, blockable = true, SpellType = "skillshot"},
    }},
    ["Ahri"] = {charName = "Ahri", skillshots = {
        ["AhriOrbofDeception"] = {name = "Orb of Deception", spellName = "AhriOrbofDeception", castDelay = 250, projectileName = "Ahri_Orb_mis.troy", projectileSpeed = 1750, range = 900, radius = 100, type = "line",  SpellType = "skillshot"},
        ["AhriSeduce"] = {name = "Charm", spellName = "AhriSeduce", castDelay = 250, projectileName = "Ahri_Charm_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line",  SpellType = "skillshot"}
    }},
    ["Olaf"] = {charName = "Olaf", skillshots = {
        ["OlafAxeThrow"] = {name = "Undertow", spellName = "OlafAxeThrow", castDelay = 250, projectileName = "olaf_axe_mis.troy", projectileSpeed = 1600, range = 1000, radius = 90, type = "line",  SpellType = "skillshot"}
    }},
    ["Leona"] = {charName = "Leona", skillshots = { -- Q+ R+
        ["LeonaZenithBlade"] = {name = "Zenith Blade", spellName = "LeonaZenithBlade", castDelay = 250, projectileName = "Leona_ZenithBlade_mis.troy", projectileSpeed = 2000, range = 900, radius = 100, type = "line",  SpellType = "skillshot"},
        ["LeonaSolarFlare"] = {name = "Leona Solar Flare", spellName = "LeonaSolarFlare", castDelay = 250, projectileName = "Leona_SolarFlare_cas.troy", projectileSpeed = 650+350, range = 1200, radius = 300, type = "circular",  SpellType = "skillshot"}
    }},
    ["Karthus"] = {charName = "Karthus", skillshots = {
        ["LayWaste"] = {name = "Lay Waste", spellName = "LayWaste", castDelay = 250, projectileName = "LayWaste_point.troy", projectileSpeed = 1750, range = 875, radius = 140, type = "circular", blockable = false, SpellType = "skillshot"}
    }},
    ["Chogath"] = {charName = "Chogath", skillshots = {
        ["Rupture"] = {name = "Rupture", spellName = "Rupture", castDelay = 0, projectileName = "rupture_cas_01_red_team.troy", projectileSpeed = 950, range = 950, radius = 250, type = "circular", blockable = false, SpellType = "skillshot"}
    }},
    ["Blitzcrank"] = {charName = "Blitzcrank", skillshots = {
       ["RocketGrabMissile"] = {name = "Rocket Grab", spellName = "RocketGrabMissile", castDelay = 250, projectileName = "FistGrab_mis.troy", projectileSpeed = 1800, range = 1050, radius = 70, type = "line",  SpellType = "skillshot"}
    }},
    ["Anivia"] = {charName = "Anivia", skillshots = {
        ["FlashFrostSpell"] = {name = "Flash Frost", spellName = "FlashFrostSpell", castDelay = 250, projectileName = "cryo_FlashFrost_mis.troy", projectileSpeed = 850, range = 1100, radius = 110, type = "line",  SpellType = "skillshot"},
        ["FrostBite"] = {name = "FrostBite", spellName = "FrostBite", castDelay = 250, projectileName = "cryo_FrostBite_mis.troy", projectileSpeed = 1200, range = 1100, radius = 110, type = "line",  SpellType = "castcel"},
    }},
    ["Annie"] = {charName = "Annie", skillshots = {
        ["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140,  SpellType = "castcel"}
    }},
    ["Katarina"] = {charName = "Katarina", skillshots = {
        ["KatarinaR"] = {name = "Death Lotus", spellName = "KatarinaR", range = 550, fuckedUp = true, blockable = true, SpellType = "skillshot"},
        ["KatarinaQ"] = {name = "Bouncing Blades", spellName = "KatarinaQ", range = 675,  SpellType = "skillshot"},
    }},    
    ["Zyra"] = {charName = "Zyra", skillshots = {
      --  ["Deadly Bloom"]   = {name = "Deadly Bloom", spellName = "ZyraQFissure", castDelay = 250, projectileName = "zyra_Q_cas.troy", projectileSpeed = 1400, range = 825, radius = 220, type = "circular",  SpellType = "skillshot"},
        ["ZyraGraspingRoots"] = {name = "Grasping Roots", spellName = "ZyraGraspingRoots", castDelay = 250, projectileName = "Zyra_E_sequence_impact.troy", projectileSpeed = 1150, range = 1150, radius = 70,  type = "line",  SpellType = "skillshot"},
        ["zyrapassivedeathmanager"] = {name = "Zyra Passive", spellName = "zyrapassivedeathmanager", castDelay = 500, projectileName = "zyra_passive_plant_mis.troy", projectileSpeed = 2000, range = 1474, radius = 60,  type = "line",  SpellType = "skillshot"},
    }},
    --[[["Gragas"] = {charName = "Gragas", skillshots = {
        ["Barrel Roll"] = {name = "Barrel Roll", spellName = "GragasBarrelRoll", castDelay = 250, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular",  SpellType = "skillshot"},
        ["Barrel Roll Missile"] = {name = "Barrel Roll Missile", spellName = "GragasBarrelRollMissile", castDelay = 0, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular",  SpellType = "skillshot"},
    }},]]--
    ["Gragas"] = {charName = "Gragas", skillshots = {
        ["GragasExplosiveCask"] = {name = "Gragas Ult", spellName="GragasExplosiveCask", blockable=true, SpellType = "skillshot", range=1050},
        ["GragasBarrelRoll"] = {name = "GragasBarrelRoll", spellName="GragasBarrelRoll", blockable=true, SpellType = "skillshot", range=950}
    }},
    ["Nautilus"] = {charName = "Nautilus", skillshots = {
        ["NautilusAnchorDrag"] = {name = "Dredge Line", spellName = "NautilusAnchorDrag", castDelay = 250, projectileName = "Nautilus_Q_mis.troy", projectileSpeed = 2000, range = 1080, radius = 80, type = "line",  SpellType = "skillshot"},
    }},
    --[[["Urgot"] = {charName = "Urgot", skillshots = {
        ["Acid Hunter"] = {name = "Acid Hunter", spellName = "UrgotHeatseekingLineMissile", castDelay = 175, projectileName = "UrgotLineMissile_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line",  SpellType = "skillshot"},
        ["Plasma Grenade"] = {name = "Plasma Grenade", spellName = "UrgotPlasmaGrenade", castDelay = 250, projectileName = "UrgotPlasmaGrenade_mis.troy", projectileSpeed = 1750, range = 900, radius = 250, type = "circular",  SpellType = "skillshot"},
    }},]]--
    ["Caitlyn"] = {charName = "Caitlyn", skillshots = {
        ["CaitlynPiltoverPeacemaker"] = {name = "Piltover Peacemaker", spellName = "CaitlynPiltoverPeacemaker", castDelay = 625, projectileName = "caitlyn_Q_mis.troy", projectileSpeed = 2200, range = 1300, radius = 90, type = "line",  SpellType = "skillshot"},
        ["CaitlynEntrapment"] = {name = "Caitlyn Entrapment", spellName = "CaitlynEntrapment", castDelay = 150, projectileName = "caitlyn_entrapment_mis.troy", projectileSpeed = 2000, range = 950, radius = 80, type = "line",  SpellType = "skillshot"},
        ["CaitlynHeadshotMissile"] = {name = "Ace in the Hole", spellName = "CaitlynHeadshotMissile", range = 3000, fuckedUp = true, blockable = true, SpellType = "skillshot", projectileName = "caitlyn_ult_mis.troy"},
    }},
    ["Mundo"] = {charName = "DrMundo", skillshots = {
        ["InfectedCleaverMissile"] = {name = "Infected Cleaver", spellName = "InfectedCleaverMissile", castDelay = 250, projectileName = "dr_mundo_infected_cleaver_mis.troy", projectileSpeed = 2000, range = 1050, radius = 75, type = "line",  SpellType = "skillshot"},
    }},
    ["Brand"] = {charName = "Brand", skillshots = { -- Q+ W+
        ["BrandBlaze"] = {name = "BrandBlaze", spellName = "BrandBlaze", castDelay = 250, projectileName = "BrandBlaze_mis.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line",  SpellType = "skillshot"},
        ["BrandWildfire"] = {name = "BrandWildfire", spellName = "BrandWildfire", castDelay = 250, projectileName = "BrandWildfire_mis.troy", projectileSpeed = 1000, range = 1100, radius = 250, type = "circular",  SpellType = "castcel"},
		["BrandConflagration"] = {name = "BrandConflagration", spellName = "BrandConflagration", SpellType = "castcel"},
    }},
    ["Corki"] = {charName = "Corki", skillshots = {
        ["MissileBarrage"] = {name = "Missile Barrage", spellName = "MissileBarrage", castDelay = 250, projectileName = "corki_MissleBarrage_mis.troy", projectileSpeed = 2000, range = 1300, radius = 40, type = "line",  SpellType = "skillshot"},
    }},
    ["TwistedFate"] = {charName = "TwistedFate", skillshots = {
        ["WildCards"] = {name = "Loaded Dice", spellName = "WildCards", castDelay = 250, projectileName = "Roulette_mis.troy", projectileSpeed = 1000, range = 1450, radius = 40, type = "line",  SpellType = "skillshot"},
    }},
    ["Swain"] = {charName = "Swain", skillshots = {
        ["SwainShadowGrasp"] = {name = "Nevermove", spellName = "SwainShadowGrasp", castDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular",  SpellType = "skillshot"},
        ["SwainTorment"] = {name = "SwainTorment", spellName = "SwainTorment", castDelay = 250, projectileName = "swain_torment_mis.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular",  SpellType = "skillshot"}
    }},
    ["Cassiopeia"] = {charName = "Cassiopeia", skillshots = {
        ["CassiopeiaNoxiousBlast"] = {name = "Noxious Blast", spellName = "CassiopeiaNoxiousBlast", castDelay = 250, projectileName = "CassNoxiousSnakePlane_green.troy", projectileSpeed = 500, range = 850, radius = 130, type = "circular", blockable = false, SpellType = "skillshot"},
    }},
    ["Sivir"] = {charName = "Sivir", skillshots = { --hard to measure speed
        ["SivirQ"] = {name = "Boomerang Blade", spellName = "SivirQ", castDelay = 250, projectileName = "Sivir_Base_Q_mis.troy", projectileSpeed = 1350, range = 1175, radius = 101, type = "line",  SpellType = "skillshot"},
    }},
    ["Ashe"] = {charName = "Ashe", skillshots = {
        ["EnchantedCrystalArrow"] = {name = "Enchanted Arrow", spellName = "EnchantedCrystalArrow", castDelay = 250, projectileName = "EnchantedCrystalArrow_mis.troy", projectileSpeed = 1600, range = 25000, radius = 130, type = "line", fuckedUp = true, blockable = true, SpellType = "skillshot"},
        ["Volley"] = {name = "Volley", spellName = "Volley", range = 1200,  SpellType = "skillshot"},
    }},
    ["KogMaw"] = {charName = "KogMaw", skillshots = {
        ["KogMawLivingArtillery"] = {name = "Living Artillery", spellName = "KogMawLivingArtillery", castDelay = 250, projectileName = "KogMawLivingArtillery_mis.troy", projectileSpeed = 1050, range = 2200, radius = 225, type = "circular", blockable = false, SpellType = "skillshot"}
    }},
    ["Khazix"] = {charName = "Khazix", skillshots = {
        ["KhazixW"] = {name = "KhazixW", spellName = "KhazixW", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line",  SpellType = "skillshot"},
        --["khazixwlong"] = {name = "khazixwlong", spellName = "khazixwlong", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line",  SpellType = "skillshot"},
    }},
    ["Zed"] = {charName = "Zed", skillshots = {
        ["ZedShuriken"] = {name = "ZedShuriken", spellName = "ZedShuriken", castDelay = 250, projectileName = "Zed_Q_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line",  SpellType = "skillshot"},
        --["ZedShuriken2"] = {name = "ZedShuriken2", spellName = "ZedShuriken!", castDelay = 250, projectileName = "Zed_Q2_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line",  SpellType = "skillshot"},
    }},
    ["Leblanc"] = {charName = "Leblanc", skillshots = {
        ["LeblancChaosOrb"] = {name = "Ethereal LeblancChaosOrb", spellName = "LeblancChaosOrb", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, fuckedUp = false,  blockable = true, SpellType = "skillshot"},
        ["LeblancChaosOrbM"] = {name = "Ethereal LeblancChaosOrbM", spellName = "LeblancChaosOrbM", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, fuckedUp = false,  blockable = true, SpellType = "skillshot"},
        ["LeblancSoulShackle"] = {name = "Ethereal Chains", spellName = "LeblancSoulShackle", castDelay = 250, projectileName = "leBlanc_shackle_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line", fuckedUp = false,  blockable = true, SpellType = "skillshot"},
        ["LeblancSoulShackleM"] = {name = "Ethereal Chains R", spellName = "LeblancSoulShackleM", castDelay = 250, projectileName = "leBlanc_shackle_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line", fuckedUp = false,  blockable = true, SpellType = "skillshot"},
        ["LeblancMimic"] = {name = "LeblancMimic", spellName="LeblancMimic", blockable="true", SpellType = "skillshot", range=650}
    }},
    ["Draven"] = {charName = "Draven", skillshots = {
        ["DravenDoubleShot"] = {name = "Stand Aside", spellName = "DravenDoubleShot", castDelay = 250, projectileName = "Draven_E_mis.troy", projectileSpeed = 1400, range = 1100, radius = 130, type = "line",  SpellType = "skillshot"},
        ["DravenRCast"] = {name = "DravenR", spellName = "DravenRCast", castDelay = 500, projectileName = "Draven_R_mis!.troy", projectileSpeed = 2000, range = 25000, radius = 160, type = "line",  SpellType = "skillshot"},
    }},
    ["Elise"] = {charName = "Elise", skillshots = {
        ["EliseHumanE"] = {name = "Cocoon", spellName = "EliseHumanE", castDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 1100, radius = 70, type = "line",  SpellType = "skillshot"}
    }},
    ["Lulu"] = {charName = "Lulu", skillshots = {
        ["LuluQ"] = {name = "LuluQ", spellName = "LuluQ", castDelay = 250, projectileName = "Lulu_Q_Mis.troy", projectileSpeed = 1450, range = 1000, radius = 50, type = "line",  SpellType = "skillshot"}
    }},
    ["Thresh"] = {charName = "Thresh", skillshots = {
        ["ThreshQ"] = {name = "ThreshQ", spellName = "ThreshQ", castDelay = 500, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1900, range = 1100, radius = 65, type = "line",  SpellType = "skillshot"} -- 60 real radius
    }},
    ["Shen"] = {charName = "Shen", skillshots = {
        ["ShenShadowDash"] = {name = "ShadowDash", spellName = "ShenShadowDash", castDelay = 0, projectileName = "shen_shadowDash_mis.troy", projectileSpeed = 3000, range = 575, radius = 50, type = "line", blockable = false, SpellType = "skillshot"}
    }},
    ["Quinn"] = {charName = "Quinn", skillshots = {
        ["QuinnQ"] = {name = "QuinnQ", spellName = "QuinnQ", castDelay = 250, projectileName = "Quinn_Q_missile.troy", projectileSpeed = 1550, range = 1050, radius = 80, type = "line",  SpellType = "skillshot"}
    }},
    ["Veigar"] = {charName = "Veigar", skillshots = {
        ["VeigarPrimordialBurst"] = {name = "VeigarPrimordialBurst", spellName="VeigarPrimordialBurst", projectileName = "permission_Shadowbolt_mis.troy", fuckedUp = false, blockable= true, SpellType = "skillshot", range = 650},
        ["VeigarBalefulStrike"] = {name = "VeigarBalefulStrike", spellName="VeigarBalefulStrike", projectileName = "permission__mana_flare_mis.troy.troy", fuckedUp = false, blockable= true, SpellType = "skillshot", range=650}
    }},
    --[[["Veigar"] = {charName = "Veigar", skillshots = {
        ["VeigarDarkMatter"] = {name = "VeigarDarkMatter", spellName = "VeigarDarkMatter", castDelay = 250, projectileName = "!", projectileSpeed = 900, range = 900, radius = 225, type = "circular",  SpellType = "skillshot"}
    }},
    ]]--
    --[[["Diana"] = {charName = "Diana", skillshots = {
        ["Diana Arc"] = {name = "DianaArc", spellName = "DianaArc", castDelay = 250, projectileName = "Diana_Q_trail.troy", projectileSpeed = 1600, range = 1000, radius = 195, type="circular",  SpellType = "skillshot"},
    }},]]--
    --[[["Jayce"] = {charName = "Jayce", skillshots = {
        ["Q1"] = {name = "Q1", spellName = "jayceshockblast!", castDelay = 250, projectileName = "JayceOrbLightning.troy", projectileSpeed = 1450, range = 1050, radius = 70, type = "line",  SpellType = "skillshot"},
        ["Q2"] = {name = "Q2", spellName = "JayceShockBlast", castDelay = 250, projectileName = "JayceOrbLightningCharged.troy", projectileSpeed = 2350, range = 1600, radius = 70, type = "line",  SpellType = "skillshot"},
    }},]]--
    ["Nami"] = {charName = "Nami", skillshots = {
        ["NamiQ"] = {name = "NamiQ", spellName = "NamiQ", castDelay = 250, projectileName = "Nami_Q_mis.troy", projectileSpeed = 1500, range = 1625, radius = 225, type="circular",  SpellType = "skillshot"}
    }},
    ["Fizz"] = {charName = "Fizz", skillshots = {
        ["FizzMarinerDoom"] = {name = "Fizz ULT", spellName = "FizzMarinerDoom", castDelay = 250, projectileName = "Fizz_UltimateMissile.troy", projectileSpeed = 1350, range = 1275, radius = 80, type = "line",  SpellType = "skillshot"},
    }},
    ["Varus"] = {charName = "Varus", skillshots = {
        ["VarusQ"] = {name = "Varus Q Missile", spellName = "VarusQ", castDelay = 0, projectileName = "VarusQ_mis.troy", projectileSpeed = 1900, range = 1600, radius = 70, type = "line",  SpellType = "skillshot"},
        ["VarusE"] = {name = "Varus E", spellName = "VarusE", castDelay = 250, projectileName = "VarusEMissileLong.troy", projectileSpeed = 1500, range = 925, radius = 275, type = "circular",  SpellType = "skillshot"},
        ["VarusR"] = {name = "VarusR", spellName = "VarusR", castDelay = 250, projectileName = "VarusRMissile.troy", projectileSpeed = 1950, range = 1250, radius = 100, type = "line",  SpellType = "skillshot"},
    }},
    ["Karma"] = {charName = "Karma", skillshots = {
        ["KarmaQ"] = {name = "KarmaQ", spellName = "KarmaQ", castDelay = 250, projectileName = "TEMP_KarmaQMis.troy", projectileSpeed = 1700, range = 1050, radius = 90, type = "line",  SpellType = "skillshot"},
    }},
    ["Aatrox"] = {charName = "Aatrox", skillshots = {--Radius starts from 150 and scales down, so I recommend putting half of it, because you won't dodge pointblank skillshots.
        ["AatroxE"] = {name = "Blade of Torment", spellName = "AatroxE", castDelay = 250, projectileName = "AatroxBladeofTorment_mis.troy", projectileSpeed = 1200, range = 1075, radius = 75, type = "line",  SpellType = "skillshot"},
        ["AatroxQ"] = {name = "AatroxQ", spellName = "AatroxQ", castDelay = 250, projectileName = "AatroxQ.troy", projectileSpeed = 450, range = 650, radius = 145, type = "circular",  SpellType = "skillshot"},
   }},
    ["Xerath"] = {charName = "Xerath", skillshots = {
        ["XerathArcanopulse"] =  {name = "Xerath Arcanopulse", spellName = "XerathArcanopulse", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1025, radius = 100, type = "line",  SpellType = "skillshot"},
        ["xeratharcanopulseextended"] =  {name = "Xerath Arcanopulse Extended", spellName = "xeratharcanopulseextended", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1625, radius = 100, type = "line",  SpellType = "skillshot"},
        ["xeratharcanebarragewrapper"] = {name = "xeratharcanebarragewrapper", spellName = "xeratharcanebarragewrapper", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1100, radius = 265, type = "circular",  SpellType = "skillshot"},
        ["xeratharcanebarragewrapperext"] = {name = "xeratharcanebarragewrapperext", spellName = "xeratharcanebarragewrapperext", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1600, radius = 265, type = "circular",  SpellType = "skillshot"}
    }},
    ["Lucian"] = {charName = "Lucian", skillshots = {
        ["LucianQ"] =  {name = "LucianQ", spellName = "LucianQ", castDelay = 350, projectileName = "Lucian_Q_laser.troy", projectileSpeed = math.huge, range = 570*2, radius = 65, type = "line",  SpellType = "skillshot"},
        ["LucianW"] =  {name = "LucianW", spellName = "LucianW", castDelay = 300, projectileName = "Lucian_W_mis.troy", projectileSpeed = 1600, range = 1000, radius = 80, type = "line",  SpellType = "skillshot"},
    }},
    ["Rumble"] = {charName = "Rumble", skillshots = {
        ["RumbleGrenade"] =  {name = "RumbleGrenade", spellName = "RumbleGrenade", castDelay = 250, projectileName = "rumble_taze_mis.troy", projectileSpeed = 2000, range = 950, radius = 90, type = "line",  SpellType = "skillshot"},
    }},
    ["Nocturne"] = {charName = "Nocturne", skillshots = {
        ["NocturneDuskbringer"] =  {name = "NocturneDuskbringer", spellName = "NocturneDuskbringer", castDelay = 250, projectileName = "NocturneDuskbringer_mis.troy", projectileSpeed = 1400, range = 1125, radius = 60, type = "line",  SpellType = "skillshot"},
    }},
    ["MissFortune"] = {charName = "MissFortune", skillshots = {
        ["MissFortuneScattershot"] =  {name = "Scattershot", spellName = "MissFortuneScattershot", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 800, radius = 200, type = "circular", blockable = false, SpellType = "skillshot"},
        ["MissFortuneBulletTime"] =  {name = "Bullettime", spellName = "MissFortuneBulletTime", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 1400, radius = 200, type = "line",  SpellType = "skillshot"}
    }},
    ["Orianna"] = {charName = "Orianna", skillshots = {
        --["OrianaIzunaCommand"] =  {name = "OrianaIzunaCommand", spellName = "OrianaIzunaCommand!", castDelay = 250, projectileName = "Oriana_Ghost_mis.troy", projectileSpeed = 1200, range = 2000, radius = 80, type = "line",  SpellType = "skillshot"},
    }},
    ["Ziggs"] = {charName = "Ziggs", skillshots = { -- Q changed to line in 1.10
        ["ZiggsQ"] =  {name = "ZiggsQ", spellName = "ZiggsQ", castDelay = 1500, projectileName = "ZiggsQ.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line",  SpellType = "skillshot"},
        ["ZiggsW"] =  {name = "ZiggsW", spellName = "ZiggsW", castDelay = 250, projectileName = "ZiggsW_mis.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line",  SpellType = "skillshot"},
        ["ZiggsE"] =  {name = "ZiggsE", spellName = "ZiggsE", castDelay = 250, projectileName = "ZiggsEMine.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line",  SpellType = "skillshot"},
        ["ZiggsR"] =  {name = "ZiggsR", spellName = "ZiggsR", projectileName = "ZiggsR_Mis_Nuke.troy", range = 1500, fuckedUp = true, blockable = true, SpellType = "skillshot"}
    }},
    ["Galio"] = {charName = "Galio", skillshots = {
        ["GalioResoluteSmite"] =  {name = "GalioResoluteSmite", spellName = "GalioResoluteSmite", castDelay = 250, projectileName = "galio_concussiveBlast_mis.troy", projectileSpeed = 850, range = 2000, radius = 200, type = "circular",  SpellType = "skillshot"},
    }},
    ["Yasuo"] = {charName = "Yasuo", skillshots = {
        ["yasuoq3w"] =  {name = "Steel Tempest", spellName = "yasuoq3w", castDelay = 300, projectileName = "Yasuo_Q_wind_mis.troy", projectileSpeed = 1200, range = 900, radius = 375, type = "line",  SpellType = "skillshot"},
    }},
    ["Kassadin"] = {charName = "Kassadin", skillshots = {
        ["NullLance"] =  {name = "Null Sphere", spellName = "NullLance", castDelay = 300, projectileName = "Null_Lance_mis.troy", projectileSpeed = 1400, range = 650, radius = 1, type = "line",  SpellType = "skillshot"},
    }},
    ["Jinx"] = {charName = "Jinx", skillshots = { -- R speed and delay increased
        ["JinxWMissile"] =  {name = "Zap", spellName = "JinxWMissile", castDelay = 600, projectileName = "Jinx_W_mis.troy", projectileSpeed = 3300, range = 1450, radius = 70, type = "line",  SpellType = "skillshot"},
        ["JinxRWrapper"] =  {name = "Super Mega Death Rocket", spellName = "JinxRWrapper", castDelay = 600+900, projectileName = "Jinx_R_Mis.troy", projectileSpeed = 2500, range = 20000, radius = 120, type = "line",  SpellType = "skillshot"}
    }},
    ["Taric"] = {charName = "Taric", skillshots = {
        ["Dazzle"] = {name = "Dazzle", spellName="Dazzle", blockable=true, SpellType = "skillshot", range=625},
        }},
    ["FiddleSticks"] = {charName = "FiddleSticks", skillshots = {
        ["FiddlesticksDarkWind"] = {name = "DarkWind", spellName="FiddlesticksDarkWind", blockable=true, SpellType = "skillshot", range=750},
    }},           
    ["Syndra"] = {charName = "Syndra", skillshots = { -- Q added in 1.10
        ["SyndraQ"] = {name = "Q", spellName = "SyndraQ", castDelay = 250, projectileName = "Syndra_Q_cas.troy", projectileSpeed = 500, range = 800, radius = 175, type = "circular", blockable = false, SpellType = "skillshot"},
        ["SyndraR"] = {name = "SyndraR", spellName="SyndraR", blockable=true, SpellType = "skillshot", range=675}
    }},
    ["Kayle"] = {charName = "Kayle", skillshots = {
        ["JudicatorReckoning"] = {name = "JudicatorReckoning", spellName="JudicatorReckoning", castDelay = 100, projectileName = "Reckoning_mis.troy", projectileSpeed = 1500, range = 875, fuckedUp = false, blockable=true, SpellType = "skillshot", range=650},
    }},
    ["Heimerdinger"] = {charName = "Heimerdinger", skillshots = {
        ["HeimerdingerW"] =  {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 100, projectileName = "heimerdinger_hexTech_mis.troy", projectileSpeed = 1200, range = 2000, radius = 80, type = "line", blockable = true, SpellType = "skillshot"},
        ["HeimerdingerE"] = {name = "HeimerdingerE", spellName="HeimerdingerE", blockable=true, SpellType = "skillshot", range=750}
    }},    
    ["Annie"] = {charName = "Annie", skillshots = {
        ["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140,  SpellType = "skillshot"}
    }},
    ["Janna"] = {charName = "Janna", skillshots = {
        ["HowlingGale"] = {name = "HowlingGale", spellName = "HowlingGale", castDelay = 250, projectileName = "HowlingGale_mis.troy", projectileSpeed = 1200, range = 1500, radius = 140,  SpellType = "skillshot"}
    }},
    ["Lissandra"] = {charName = "Lissandra", skillshots = {
        ["LissandraQ"] = {name = "LissandraQ", spellName = "LissandraQ", castDelay = 250, projectileName = "Lissandra_Q_mis.troy", projectileSpeed = 1200, range = 1500, radius = 140,  SpellType = "skillshot"},
        ["LissandraE"] = {name = "LissandraE", spellName = "LissandraE", castDelay = 250, projectileName = "Lissandra_E_Missle.troy", projectileSpeed = 850, range = 1500, radius = 140,  SpellType = "skillshot"}
    }},
    --[[["Pantheon"] = {charName = "Pantheon", skillshots = {
        ["Pantheon_Throw"] = {name = "Pantheon_Throw", spellName = "Pantheon_Throw", castDelay = 250, projectileName = "pantheon_spear_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  SpellType = "skillshot"}
    }},
    ]]--
    ["Sejuani"] = {charName = "Sejuani", skillshots = {
        ["SejuaniR"] = {name = "SejuaniR", spellName = "SejuaniR", castDelay = 250, projectileName = "Sejuani_R_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  SpellType = "skillshot"}
    }},
    ["Ryze"] = {charName = "Ryze", skillshots = {
        ["Overload"] = {name = "Overload", spellName = "Overload", castDelay = 250, projectileName = "Overload_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  SpellType = "skillshot"},
        ["SpellFlux"] = {name = "SpellFlux", spellName = "SpellFlux", castDelay = 250, projectileName = "SpellFlux_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  SpellType = "skillshot"}
    }},
    ["Malphite"] = {charName = "Malphite", skillshots = {
        ["SeismicShard"] = {name = "SeismicShard", spellName = "SeismicShard", castDelay = 250, projectileName = "SeismicShard_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  SpellType = "skillshot"}
    }},
    ["Sona"] = {charName = "Sona", skillshots = {
        ["SonaHymnofValor"] = {name = "SonaHymnofValor", spellName = "SonaHymnofValor", castDelay = 250, projectileName = "SonaHymnofValor_beam.troy", projectileSpeed = 1500, range = 1500, radius = 140,  SpellType = "skillshot"},
        ["SonaCrescendo"] = {name = "SonaCrescendo", spellName = "SonaCrescendo", castDelay = 250, projectileName = "SonaCrescendo_mis.troy", projectileSpeed = 1500, range = 1500, radius = 500,  SpellType = "skillshot"}
    }},
    ["Teemo"] = {charName = "Teemo", skillshots = {
        ["BlindingDart"] = {name = "BlindingDart", spellName = "BlindingDart", castDelay = 250, projectileName = "BlindShot_mis.troy", projectileSpeed = 1500, range = 680, radius = 450,  SpellType = "skillshot"}
    }},
    ["Vayne"] = {charName = "Vayne", skillshots = {
        ["VayneCondemn"] = {name = "VayneCondemn", spellName = "VayneCondemn", castDelay = 250, projectileName = "vayne_E_mis.troy", projectileSpeed = 1200, range = 550, radius = 450,  SpellType = "skillshot"}
    }},
}

----------------------------------------------

function GetCustomTarget()
	ts:update()
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return ts.target
end

function OnLoad()
	PrintChat("<font color=\"#00FF00\">Fantastik Sivir version ["..sversion.."] by Fantastik loaded.</font>")
	if _G.MMA_Loaded ~= nil then
		PrintChat("<font color = \"#00FF00\">Fantastik Sivir MMA Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
		isMMA = true
	elseif _G.AutoCarry ~= nil then
		PrintChat("<font color = \"#00FF00\">Fantastik Sivir SAC Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
		isSAC = true
	else
		isSOW = true
	end
	if _G.Evadeee_Loaded then
	PrintChat("<font color=\"##58D3F7\"><b>Evadeee</b> found! You can use Evadeee integration!")
	_G.Evadeee_Enabled = true
	end
  	IgniteCheck()
	SLoadLib()
	Announcer()
end


function OnTick()
  	ts:update()
  	target = GetCustomTarget()
  	Checks()
	
	if ValidTarget(target) then
		if SivMenu.Extra.KS then KS(target) end
		if SivMenu.Extra.Ignite then AutoIgnite(target) end
	end
	
   if SivMenu.combokey then
		Combo()
   end
   if SivMenu.pokekey then
		Poke()
   end
   if SivMenu.farmkey then
		FarmQ()
		FarmW()
   end
   if SivMenu.Extra.Evade then
       EvadeeeHelper()
   end
end

function Checks()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
  	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	
	Qrangec = SivMenu.Combo.Qrangemin
	
	if SivMenu.Extra.autolev.enabled then
		AutoLevel()
	end
	calcDmg()
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
			ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
			ignite = SUMMONER_2
	end
end

function OnDraw()
	if SivMenu.Drawing.DrawAA and isSOW then
	 SOWi:DrawAARange()
	end
   
   if SivMenu.Drawing.DrawQ then
	 if QREADY then
	 DrawCircle(myHero.x, myHero.y, myHero.z, Qrangec, 0xF7FE2E)
	 end
   end
   
	if SivMenu.Drawing.DrawT then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if ValidTarget(target) and target ~= nil then
				local barPos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 10
				
				DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
			end
		end
	end
end

function SLoadLib()
	EnemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
	VP = VPrediction(true)
	if isSOW then
		SOWi = SOW(VP)
	end
	SMenu()
	CurSkin = 0
end

function SMenu()

	SivMenu = scriptConfig("Fantastik Sivir", "Sivir")
	SivMenu:addParam("combokey", "Combo key(Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	SivMenu:addParam("pokekey", "Poke key(C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	SivMenu:addParam("farmkey", "Farm key(V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	SivMenu:addParam("Version", "Version", SCRIPT_PARAM_INFO, sversion)
	SivMenu:addParam("Author", "Author", SCRIPT_PARAM_INFO, sauthor)
	
	SivMenu:addTS(ts)
	
	SivMenu:addSubMenu("Combo", "Combo")
	SivMenu.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Combo:addSubMenu("Use Q on:", "targets")
	for _, enemy in ipairs(GetEnemyHeroes()) do
        SivMenu.Combo.targets:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, true)
    end
	SivMenu.Combo:addParam("Qrangemin", "Min. range for Q ", SCRIPT_PARAM_SLICE, 950, 600, 1075, 0)
	SivMenu.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Combo:addParam("minEnemiesR", "Min. no. of enemies for R ", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
	SivMenu.Combo:addParam("manapls", "Min. % mana for spells ", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	
	SivMenu:addSubMenu("Poke", "Poke")
	SivMenu.Poke:addParam("pokeQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Poke:addParam("manapls", "Min. % mana for spells ", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)

	SivMenu:addSubMenu("Farm", "Farm")
	SivMenu.Farm:addParam("farmQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Farm:addParam("farmW", "Use W", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Farm:addParam("manafarm", "Min. % mana to farm", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	
	SivMenu:addSubMenu("Drawing", "Drawing")
	if isSOW then
	SivMenu.Drawing:addParam("DrawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	end
	SivMenu.Drawing:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Drawing:addParam("DrawT", "Draw Text", SCRIPT_PARAM_ONOFF, true)
	if isSOW then
		SivMenu:addSubMenu("Orbwalker", "Orbwalker")
		SOWi:LoadToMenu(SivMenu.Orbwalker)
	end
	
	SivMenu:addSubMenu("Extra", "Extra")
	SivMenu.Extra:addParam("KS", "Auto Killsteal", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Extra:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Extra:addParam("Hitchance", "Hitchance Combo", SCRIPT_PARAM_LIST, 2, {"LOW", "MEDIUM"})
	SivMenu.Extra:addParam("HitchanceP", "Hitchance Poke", SCRIPT_PARAM_LIST, 2, {"LOW", "MEDIUM"})
	SivMenu.Extra:addSubMenu("Auto level spells", "autolev")
	SivMenu.Extra.autolev:addParam("enabled", "Enable auto level spells", SCRIPT_PARAM_ONOFF, false)
	SivMenu.Extra.autolev:addParam("lvlseq", "Select your auto level sequence: ", SCRIPT_PARAM_LIST, 1, {"R>Q>W>E", "R>W>Q>E", "R>E>Q>W"})
	SivMenu.Extra:addSubMenu("Skin Hack - VIP ONLY/Not Working", "skinhax")
	SivMenu.Extra.skinhax:addParam("enabled", "Enable Skin Hack", SCRIPT_PARAM_ONOFF, false)
	SivMenu.Extra.skinhax:addParam("skinid", "Choose skin: ", SCRIPT_PARAM_LIST, 1, {"No Skin", "Warrior Princess", "Spectacular", "Huntress", "Bandit", "PAX", "Snowstorm"})
	if _G.Evadeee_Loaded then
		SivMenu.Extra:addParam("Evade", "Use Evadeee Integration", SCRIPT_PARAM_ONOFF, true)
	end
	if VIP_USER then
		SivMenu.Extra:addParam("packetcast", "Use Packet Cast", SCRIPT_PARAM_ONOFF, false)
	end
	SivMenu.Extra:addSubMenu("Auto E settings", "ESet")
	SivMenu.Extra.ESet:addParam("enabled", "Use Auto E", SCRIPT_PARAM_ONOFF, true)
	for i = 1, heroManager.iCount,1 do
        local hero = heroManager:getHero(i)
        if hero.team ~= player.team then
            if Champions[hero.charName] ~= nil then
                for index, skillshot in pairs(Champions[hero.charName].skillshots) do
--                    if skillshot.blockable == true then
                        SivMenu.Extra.ESet:addParam(skillshot.spellName, hero.charName .. " - " .. skillshot.name, SCRIPT_PARAM_ONOFF, true)
--                   end
                end
            end
        end
    end
	
	SivMenu:permaShow("combokey")
	SivMenu:permaShow("pokekey")
	SivMenu:permaShow("farmkey")
end

function KS(Target)
	if QREADY and getDmg("Q", Target, myHero) > Target.health then
		local CastPos = VP:GetLineCastPosition(Target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
		if GetDistance(Target) <= Qrange and QREADY then
			if not VIP_USER or not SivMenu.Extra.packetcast then
				CastSpell(_Q, CastPos.x, CastPos.z)
			elseif VIP_USER and SivMenu.Extra.packetcast then
				PacketCast(_Q, CastPos)
			end
		end
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

function EvadeeeHelper()
	if _G.Evadeee_impossibleToEvade then
		CastSpell(_E)
	end
end

function Combo()
	if ValidTarget(target) and ManaManager() then
		if QREADY and SivMenu.Combo.comboQ and SivMenu.Combo.targets[target.charName] then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Qdelay, Qwidth, Qrangec, Qspeed, myHero, false)
			if HitChance >= SivMenu.Extra.Hitchance and GetDistance(CastPosition) <= Qrangec and QREADY then
				if not VIP_USER or not SivMenu.Extra.packetcast then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				elseif VIP_USER and SivMenu.Extra.packetcast then
					PacketCast(_Q, CastPosition)
				end
			end
		end
		if RREADY and SivMenu.Combo.comboR and GetDistance(target) <= 600 then
			CastR()
		end
	end
end

function Poke()
  if ValidTarget(target) and ManaManagerPoke() then
		if SivMenu.Poke.pokeQ and QREADY and SivMenu.Combo.targets[target.charName] then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
			if HitChance >= SivMenu.Extra.HitchanceP and GetDistance(CastPosition) <= Qrange and QREADY then
				if not VIP_USER or not SivMenu.Extra.packetcast then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				elseif VIP_USER and SivMenu.Extra.packetcast then
					PacketCast(_Q, CastPosition)
				end
			end
		end
	end
end

function GetBestQPositionFarm()
  local MaxQPos
  local MaxQ = 0
  for i, minion in pairs(EnemyMinions.objects) do
    local hitQ = CountMinionsHit(minion)
    if hitQ > MaxQ or MaxQPos == nil then
      MaxQPos = minion
      MaxQ = hitQ
    end
  end

  if MaxQPos then
    return MaxQPos
  else
    return nil
  end
end

function CastQFarm(to)
	if not VIP_USER or not SivMenu.Extra.packetcast then
		CastSpell(_Q, to.x, to.z)
	elseif VIP_USER and SivMenu.Extra.packetcast then
		PacketCast(_Q, to)
	end
end

function FarmQ()
	if ManaManagerFarm() then
	EnemyMinions:update()
	if SivMenu.Farm.farmQ then
		if QREADY and #EnemyMinions.objects > 3 then
			for i, minion in pairs(EnemyMinions.objects) do
		    if GetDistance(minion) < Qrange then
				local QPos = GetBestQPositionFarm()
				if QPos then
					CastQFarm(QPos)
				end
			end
		end
	end
	end
end
end

function FarmW()
	if ManaManagerFarm() then
	EnemyMinions:update()
	if SivMenu.Farm.farmW then
		if WREADY and #EnemyMinions.objects > 3 then
			for i, minion in pairs(EnemyMinions.objects) do
			if GetDistance(minion) < 500 then
				CastSpell(_W)
			end
		end
	end
	end
end
end

function OnProcessSpell(unit, spell)
	if unit == myHero and spell.name:lower():find("attack") then
		if SivMenu.combokey and WREADY and SivMenu.Combo.comboW and GetDistance(target) <= 600 then
			if not VIP_USER or not SivMenu.Extra.packetcast then
				DelayAction(function() CastSpell(_W) end, spell.windUpTime + GetLatency() / 2000)
			elseif VIP_USER and SivMenu.Extra.packetcast then
				DelayAction(function() PacketCast(_W, myHero) end, spell.windUpTime + GetLatency() / 2000)
			end
		end
	end
	
	if SivMenu.Extra.ESet.enabled then
		if unit.team ~= player.team and string.find(spell.name, "Basic") == nil then
			if Champions[unit.charName] ~= nil then
                skillshot = Champions[unit.charName].skillshots[spell.name]
                if skillshot ~= nil then
					range = skillshot.range
					if not spell.startPos then
                        spell.startPos.x = unit.x
                        spell.startPos.z = unit.z                        
                    end            
                    if GetDistance(spell.startPos) <= range and skillshot.SpellType == "skillshot" then
						if GetDistance(spell.endPos) <= 100 then
							if EREADY and SivMenu.Extra.ESet[spell.name] and not _G.Evadeee_Loaded then
								CastSpell(_E)
							end
						end
					end
                end
			end
		end	
	end
	
end

function ManaManagerFarm()
	if myHero.mana >= myHero.maxMana * (SivMenu.Farm.manafarm / 100) then
	return true
	else
	return false
	end	 
end

function ManaManager()
	if myHero.mana >= myHero.maxMana * (SivMenu.Combo.manapls / 100) then
	return true
	else
	return false
	end	 
end

function ManaManagerPoke()
	if myHero.mana >= myHero.maxMana * (SivMenu.Poke.manapls / 100) then
	return true
	else
	return false
	end	 
end

function CastR()
	if SivMenu.Combo.minEnemiesR <= CountEnemyHeroInRange(600) then
		if not VIP_USER or not SivMenu.Extra.packetcast then
			CastSpell(_R)
		elseif VIP_USER and SivMenu.Extra.packetcast then
			PacketCast(_R, myHero)
		end
	end
end

function CountMinionsHit(QPos)
  local LineEnd = Vector(myHero) + Qrange * (Vector(QPos) - Vector(myHero)):normalized()
  local n = 0
  for i, minion in pairs(EnemyMinions.objects) do
    local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(myHero), LineEnd, minion)
    if isOnSegment and GetDistance(minion, pointSegment) <= 85*1.25 then
      n = n + 1
    end
  end
  return n
end

function AutoLevel()
		if SivMenu.Extra.autolev.lvlseq == 1 then seq = {1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3}
		elseif SivMenu.Extra.autolev.lvlseq == 2 then seq = {2, 1, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3}
		elseif SivMenu.Extra.autolev.lvlseq == 3 then seq = {3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2,}
		end
		autoLevelSetSequence(seq)
end

function SkinHack()
	if SivMenu.Extra.skinhax.enabled and CurSkin ~= SivMenu.Extra.skinhax.skinid then
		local SkinIdSwap = { [1] = 7, [2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5, [7] = 6 }
		CurSkin = SivMenu.Extra.skinhax.skinid
		SkinChanger(myHero.charName, SkinIdSwap[CurSkin])
	end
end

function SkinChanger(champ, skinId) -- Credits to shalzuth
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
    p:Encode1(1)
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

function calcDmg()
	for i=1, heroManager.iCount do
		local target = heroManager:GetHero(i)
		if ValidTarget(target) and target ~= nil then
			qDmg = ((QREADY and getDmg("Q", target, myHero)) or 0)
			aDmg = ((getDmg("AD", target, myHero)) or 0)
			aDmg2 = (aDmg * 2)
			aDmg3 = (aDmg * 3)
			aDmg4 = (aDmg * 4)
			
			if target.health > (qDmg + aDmg4) then
				KillText[i] = 1
			elseif target.health <= aDmg then
				KillText[i] = 2
			elseif target.health <= aDmg2 then
				KillText[i] = 3
			elseif target.health <= aDmg3 then
				KillText[i] = 4	
			elseif target.health <= qDmg then
				KillText[i] = 5
			elseif target.health <= (qDmg + aDmg) then
				KillText[i] = 6
			elseif target.health <= (qDmg + aDmg2) then
				KillText[i] = 7
			elseif target.health <= (qDmg + aDmg3) then
				KillText[i] = 8
			elseif target.health <= (qDmg + aDmg4) then
				KillText[i] = 9	
			end
		end
	end	
end

--[[	Announcer	]]
function AnnouncerMsg(msg) print("<font color=\"#6699ff\"><b>Fantastik Sivir Announce:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>") end
function Announcer()
	local Announce
	local AnnouncerData = GetWebResult(UPDATE_HOST, "/BoLFantastik/BoL/master/Announcer/Fantastik Sivir")
	if AnnouncerData then
		Announcer = AnnouncerData or nil
		if Announcer then
			AnnouncerMsg(""..Announcer.."")
		end
	end
end

function PacketCast(spell, position)
	Packet("S_CAST", {spellId = spell, fromX =  position.x, fromY =  position.z, toX =  position.x, toY =  position.z}):send()
end
