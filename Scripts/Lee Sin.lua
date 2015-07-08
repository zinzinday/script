--[[
    
    AUTHOR iCreative
    Credits to:
    lag free circles writers
    Aroc for ScriptUpdate :)
    Extragoz for getspelltype function
]]
local AUTOUPDATES = true --CHANGE THIS TO FALSE IF YOU DON'T WANT AUTOUPDATES
local FixItems = false -- CHANGE THIS TRUE OR FALSE IF BOL IS SUPPORTING ITEMS OR NOT
local scriptname = "DJ Lee Sean"
local author = "iCreative"
local version = 0.308
local champion = "LeeSin"
if myHero.charName:lower() ~= champion:lower() then return end
--tracker
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("XKNLNOQJPQR") 

local igniteslot = nil
local flashslot = nil
local smiteslot = nil
local P = { Damage = function(target) return getDmg("P", target, myHero) end , Stacks = 0}
local AA = { Range = function(target) 
local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end
return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 + 100 end, Damage = function(target) return getDmg("AD", target, myHero) end }
local Q = { Range = function() if myHero:GetSpellData(_Q).name:lower():find("one") then return 1100 else return 1300 end end, Width = 58, Delay = 0.25, Speed = 1800, LastCastTime1 = 0, LastCastTime2 = 0, Collision = true, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero, 3) end, State = function() if myHero:GetSpellData(_Q).name:lower():find("one") then return 1 else return 2 end end , Obj = nil, IsFlying = false, Target = nil}
local W = { Range = function() return 700 end , ExtraRange = 50, Width = 0, Delay = 0.25, Speed = 2000, LastCastTime1 = 0, LastCastTime2 = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end, State = function() if myHero:GetSpellData(_W).name:lower():find("one") then return 1 else return 2 end end }
local E = { Range = function() if myHero:GetSpellData(_E).name:lower():find("one") then return 380 else return 560 end end , Width = 430, Delay = 0.5, Speed = math.huge, LastCastTime1 = 0, LastCastTime2 = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, State = function() if myHero:GetSpellData(_E).name:lower():find("one") then return 1 else return 2 end end }
local R = { Range = function() return 375 end , KickRange = 800, Width = 0, Delay = 0.5, Speed = 1500, LastCastTime = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end }
local Ignite = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero) end}
local Flash   = { Range = 400, IsReady = function() return (flashslot ~= nil and myHero:CanUseSpell(flashslot) == READY) end, LastCastTime = 0}
local Smite   = { Range = 780, IsReady = function() return (smiteslot ~= nil and myHero:CanUseSpell(smiteslot) == READY) end}
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local CastableItems = {
Tiamat      = { Range = 400, Slot   = function() return GetInventorySlotItem(3077) end,  reqTarget = false, IsReady     = function() return (GetSlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end},
Hydra       = { Range = 400, Slot   = function() return GetInventorySlotItem(3074) end,  reqTarget = false, IsReady     = function() return (GetSlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end, Damage = function(target) return getDmg("HYDRA", target, myHero) end},
Bork        = { Range = 450, Slot   = function() return GetInventorySlotItem(3153) end,  reqTarget = true, IsReady      = function() return (GetSlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
Bwc         = { Range = 400, Slot   = function() return GetInventorySlotItem(3144) end,  reqTarget = true, IsReady      = function() return (GetSlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
Hextech     = { Range = 400, Slot   = function() return GetInventorySlotItem(3146) end,  reqTarget = true, IsReady      = function() return (GetSlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
Blackfire   = { Range = 750, Slot   = function() return GetInventorySlotItem(3188) end,  reqTarget = true, IsReady      = function() return (GetSlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
Youmuu      = { Range = 350, Slot   = function() return GetInventorySlotItem(3142) end,  reqTarget = false, IsReady     = function() return (GetSlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot   = function() return GetInventorySlotItem(3143) end,  reqTarget = false, IsReady     = function() return (GetSlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
TwinShadows = { Range = 1000, Slot  = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady      = function() return (GetSlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}

local JungleText = ""

local scriptLoaded = false

local Colors = { 
    -- O R G B
    Green =  ARGB(255, 0, 140, 0), 
    Yellow =  ARGB(255, 255, 255, 0),
    Red =  ARGB(255,255,0,0),
    White =  ARGB(255, 255, 255, 255),
    Blue =  ARGB(255,0,0,255),
}

local PredictionTable = {}

function PrintMessage(message) 
    print("<font color=\"#6699ff\"><b>" .. scriptname .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") 
end

function CheckUpdate()
    local scriptName = "DJ%20Lee%20Sean%20-%20Rework"
    if AUTOUPDATES then
        local ToUpdate = {}
        ToUpdate.ScriptName = scriptname
        ToUpdate.Version = version
        ToUpdate.UseHttps = true
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.Host2 = "raw.github.com"
        ToUpdate.VersionPath = "/jachicao/BoL/master/version/"..scriptName..".version"
        ToUpdate.ScriptPath = "/jachicao/BoL/master/"..scriptName..".lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion, OldVersion) PrintMessage("Updated to "..NewVersion..". Please reload with 2x F9.") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) PrintMessage("No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) PrintMessage("New Version found ("..NewVersion..").") end
        ToUpdate.CallbackError = function(NewVersion) PrintMessage("Error while downloading.") end
        _ScriptUpdate(ToUpdate.Version, ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
    end
end

function OnLoad()

    local r = _Required()
    r:Add("VPrediction", "lua", "raw.githubusercontent.com/SidaBoL/Scripts/master/Common/VPrediction.lua", true)
    --if VIP_USER then r:Add("Prodiction", "lua", "bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/master/Test/Prodiction/Prodiction.lua", true) end
    --if VIP_USER then r:Add("DivinePred", "luac", "divinetek.rocks/divineprediction/DivinePred.luac", false) end
    --if VIP_USER then r:Add("DivinePred", "lua", "divinetek.rocks/divineprediction/DivinePred.lua", false) end
    r:Check()
    if r:IsDownloading() then return end
    DelayAction(function() CheckUpdate() end, 5)

    if FixItems then
    
        ItemNames               = {
        [3303]              = "ArchAngelsDummySpell",
        [3007]              = "ArchAngelsDummySpell",
        [3144]              = "BilgewaterCutlass",
        [3188]              = "ItemBlackfireTorch",
        [3153]              = "ItemSwordOfFeastAndFamine",
        [3405]              = "TrinketSweeperLvl1",
        [3411]              = "TrinketOrbLvl1",
        [3166]              = "TrinketTotemLvl1",
        [3450]              = "OdinTrinketRevive",
        [2041]              = "ItemCrystalFlask",
        [2054]              = "ItemKingPoroSnack",
        [2138]              = "ElixirOfIron",
        [2137]              = "ElixirOfRuin",
        [2139]              = "ElixirOfSorcery",
        [2140]              = "ElixirOfWrath",
        [3184]              = "OdinEntropicClaymore",
        [2050]              = "ItemMiniWard",
        [3401]              = "HealthBomb",
        [3363]              = "TrinketOrbLvl3",
        [3092]              = "ItemGlacialSpikeCast",
        [3460]              = "AscWarp",
        [3361]              = "TrinketTotemLvl3",
        [3362]              = "TrinketTotemLvl4",
        [3159]              = "HextechSweeper",
        [2051]              = "ItemHorn",
        --[2003]            = "RegenerationPotion",
        [3146]              = "HextechGunblade",
        [3187]              = "HextechSweeper",
        [3190]              = "IronStylus",
        [2004]              = "FlaskOfCrystalWater",
        [3139]              = "ItemMercurial",
        [3222]              = "ItemMorellosBane",
        [3042]              = "Muramana",
        [3043]              = "Muramana",
        [3180]              = "OdynsVeil",
        [3056]              = "ItemFaithShaker",
        [2047]              = "OracleExtractSight",
        [3364]              = "TrinketSweeperLvl3",
        [2052]              = "ItemPoroSnack",
        [3140]              = "QuicksilverSash",
        [3143]              = "RanduinsOmen",
        [3074]              = "ItemTiamatCleave",
        [3800]              = "ItemRighteousGlory",
        [2045]              = "ItemGhostWard",
        [3342]              = "TrinketOrbLvl1",
        [3040]              = "ItemSeraphsEmbrace",
        [3048]              = "ItemSeraphsEmbrace",
        [2049]              = "ItemGhostWard",
        [3345]              = "OdinTrinketRevive",
        [2044]              = "SightWard",
        [3341]              = "TrinketSweeperLvl1",
        [3069]              = "shurelyascrest",
        [3599]              = "KalistaPSpellCast",
        [3185]              = "HextechSweeper",
        [3077]              = "ItemTiamatCleave",
        [2009]              = "ItemMiniRegenPotion",
        [2010]              = "ItemMiniRegenPotion",
        [3023]              = "ItemWraithCollar",
        [3290]              = "ItemWraithCollar",
        [2043]              = "VisionWard",
        [3340]              = "TrinketTotemLvl1",
        [3090]              = "ZhonyasHourglass",
        [3154]              = "wrigglelantern",
        [3142]              = "YoumusBlade",
        [3157]              = "ZhonyasHourglass",
        [3512]              = "ItemVoidGate",
        [3131]              = "ItemSoTD",
        [3137]              = "ItemDervishBlade",
        [3352]              = "RelicSpotter",
        [3350]              = "TrinketTotemLvl2",
        }
        
        _G.ITEM_1               = 06
        _G.ITEM_2               = 07
        _G.ITEM_3               = 08
        _G.ITEM_4               = 09
        _G.ITEM_5               = 10
        _G.ITEM_6               = 11
        _G.ITEM_7               = 12
        
        ___GetInventorySlotItem = rawget(_G, "GetInventorySlotItem")
        _G.GetInventorySlotItem = GetSlotItem
    end

    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then igniteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then igniteslot = SUMMONER_2
    end
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerflash") then flashslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerflash") then flashslot = SUMMONER_2
    end
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("smite") then smiteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("smite") then smiteslot = SUMMONER_2
    end
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100 ,DAMAGE_PHYSICAL)
    
    DelayAction(arrangePrioritys, 5)
    prediction = Prediction()
    damage = Damage()
    ward = Ward()
    insec = Insec()
    ally = Ally()
    minion = Minion()
    autoR = AutoR()
    Config = scriptConfig(scriptname, scriptname..author.."1.10")
    EnemyMinions = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    LoadMenu()
    DelayAction(function() OrbLoad() end, 2)
end


function LoadMenu()

    
    Config:addTS(ts)

    Config:addSubMenu(scriptname.." - Combo Settings", "Combo")
        Config.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useR","Use R", SCRIPT_PARAM_ONOFF, true)
        --Config.Combo:addParam("useIgnite","Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable", "Always"})
        Config.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useWard","Use Ward", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useStack","Use x Passive", SCRIPT_PARAM_SLICE, 1, 0, 2)
        Config.Combo:addParam("StarMode","Star Combo Mode", SCRIPT_PARAM_LIST, 1, {"Q1 R Q2", "R Q1 Q2 "})
        Config.Combo:addParam("Mode","Combo Mode", SCRIPT_PARAM_LIST, 1, {"Without R", "Star", "Gank"})
        Config.Combo:permaShow("Mode")

    Config:addSubMenu(scriptname.." - Insec Settings", "Insec")
        insec:LoadMenu(Config.Insec)

    Config:addSubMenu(scriptname.." - Harass Settings", "Harass")
        Config.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - LaneClear Settings", "LaneClear")
        Config.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - JungleClear Settings", "JungleClear")
        Config.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("useSmite", "Use Smite on Dragon/Baron", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - KillSteal Settings", "KillSteal")
        Config.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        --Config.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        Config.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        Config.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - Auto Settings", "Auto")
        Config.Auto:addParam("useSmite", "Use Smite on Dragon/Baron", SCRIPT_PARAM_ONOFF, true)
        autoR:LoadMenu(Config.Auto)

    Config:addSubMenu(scriptname.." - Misc Settings", "Misc")
        Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then Config.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 1) end
        Config.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        Config.Misc:addParam("SmiteQ","Use Smite Q", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - Drawing Settings", "Draw")
        draw = Draw()
        draw:LoadMenu(Config.Draw)
        insec:LoadDraw(Config.Draw)

    Config:addSubMenu(scriptname.." - Key Settings", "Keys")
        Config.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.Keys:addParam("ComboMode", "Switcher Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("L"))
        Config.Keys:addParam("Insec", "Insec", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("T"))
        Config.Keys:addParam("InsecMode", "Switcher Insec Mode", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("J"))
        Config.Keys:addParam("Run", "Run / Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("Z"))
        Config.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("C"))
        Config.Keys:addParam("Clear", "Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        

        Config.Keys.Combo = false
        Config.Keys.Harass = false
        Config.Keys.Clear = false
        Config.Keys.Run = false

    PrintMessage("Script by "..author..", Have Fun!")
    PrintMessage("If you feel like the ward is too close to Target on Insec, you should modify the value of % Distance on Insec Settings.")
    scriptLoaded = true
end

function OnWndMsg(msg, key)
    if Config == nil then return end
    if msg == KEY_UP then
       if key == Config.Keys._param[2].key then
            Config.Combo.Mode = Config.Combo.Mode + 1
            if Config.Combo.Mode == 4 then Config.Combo.Mode = 1 end
       end
   end
end

function IsKeyPressed()
    return Config.Keys.Combo or Config.Keys.Harass or Config.Keys.Clear or Config.Keys.Insec
end

function Checks()
    if IsKeyPressed() then 
        EnemyMinions:update()
        JungleMinions:update()
    elseif Config.Auto.useSmite then
        JungleMinions:update()
    end
    if Q.IsReady() then ts.range = Q.Range()
    else ts.range = W.Range() + E.Range()/2 end
end


function OnTick()
    if myHero.dead or not scriptLoaded or Config == nil then return end
    ts.target = GetCustomTarget()
    local targetObj = GetTarget()
    if targetObj ~= nil then
        if targetObj.type:lower():find("hero") and targetObj.team ~= myHero.team and GetDistanceSqr(myHero, targetObj) < ts.range * ts.range then
            ts.target = targetObj
        end
    end
    Checks()
    Auto()
    --KillSteal
        KillSteal()

    if Config.Keys.Insec then 
        if insec:IsReady() then
            insec:Cast()
        else
            Combo()
        end 
    end

    if Config.Keys.Run then Run() end
    if Config.Keys.Combo then 
        if Config.Combo.Mode == 1 then
            Combo()
        elseif Config.Combo.Mode == 2 then
            StarCombo()
        elseif Config.Combo.Mode == 3 then
            GankCombo()
        end
    elseif Config.Keys.Harass then Harass()
    elseif Config.Keys.Clear then Clear() 
    end
end

function KillSteal()
    if Config.KillSteal.useQ or Config.KillSteal.useE or Config.KillSteal.useR or Config.KillSteal.useIgnite then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) and enemy.visible and enemy.health/enemy.maxHealth < 0.5 and GetDistanceSqr(myHero, enemy) < ts.range * ts.range then
                local q,w,e,r, dmg  = damage:getBestCombo(enemy)
                if dmg >= enemy.health then
                    if Config.KillSteal.useQ and (Q.Damage(enemy) > enemy.health or q) and myHero.health/myHero.maxHealth >= enemy.health/enemy.maxHealth and not enemy.dead then CastQ(enemy) end
                    if Config.KillSteal.useE and (E.Damage(enemy) > enemy.health or e) and not enemy.dead then CastE(enemy) end
                    if Config.KillSteal.useR and (R.Damage(enemy) > enemy.health) and not enemy.dead then CastR(enemy) end
                end
                if Config.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead  and GetDistanceSqr(myHero, enemy) < Ignite.Range * Ignite.Range then CastSpell(igniteslot, enemy) end
            end
        end
    end
end

function Run()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if W.IsReady and W.State() == 1 then
        local obj = GetBestNearTo(mousePos)
        if obj ~= nil then
            CastW1(obj)
        elseif ward:IsReady() then
            ward:Cast(mousePos)
            local pos = Vector(mousePos)
            DelayAction(function(pos) ward:Jump(pos) end, 0.1, {pos})
        end
    end
end

function Auto()
    JungleText = ""
    if Config.Auto.useSmite and (Smite.IsReady() or Q.IsReady() ) then
        local target = nil
        for i, minion in pairs(JungleMinions.objects) do
            if ValidTarget(minion, Q.Range()) and minion.health > 0 and (minion.charName:lower():find("dragon") or minion.charName:lower():find("worm")) then
                local smiteDmg = damage:Smite()
                local qDmg = Q.IsReady() and Q.Damage(minion) or 0
                if Smite.IsReady() and smiteDmg >= minion.health and smiteDmg > 0 and ValidTarget(minion, Smite.Range) then CastSpell(smiteslot, minion) end
                if (qDmg + smiteDmg) * 1.3 >= minion.health then
                    JungleText = "JUNGLESTEAL READY"
                else
                    JungleText = "JUNGLESTEAL NOT READY"
                end
            end
        end
    end
end

function ForceW(pos)
    if W.IsReady and W.State() == 1 then
        local obj = GetBestNearTo(pos)
        if obj ~= nil then
            CastW1(obj)
        else
            DelayAction(function(pos) ForceW(pos) end, 0.1, {pos})
        end
    end
end

function DragonSteal()
    local target = nil
    for i, minion in pairs(JungleMinions.objects) do
        if ValidTarget(minion, Q.Range()) and minion.visible and minion.health > 0 and minion.charName:lower():find("dragon") then
            target = minion
        elseif ValidTarget(minion, Q.Range()) and minion.visible and minion.health > 0 and minion.charName:lower():find("worm") then
            target = minion
        end
    end
    if target~= nil and ValidTarget(target, Q.Range()) then
        local qDmg = 0
        local smiteDmg = 0
        if Q.IsReady() then qDmg = Q.Damage(target) end
        if Smite.IsReady() then smiteDmg = damage:Smite() end
        local dmg = qDmg + smiteDmg
        if dmg >= target.health then
            if smiteDmg >= target.health and smiteDmg > 0 and ValidTarget(target, Smite.Range) then CastSpell(smiteslot, target)
            elseif Q.IsReady() then
                if W.IsReady() and W.State() == 1 then
                    local obj = GetBestFarTo(target)
                    if obj == nil and ward:IsReady() then
                        ward:Cast(myHero)
                    end
                end
                if Q.State() == 1 and ValidTarget(target, Q.Range()) then
                    CastSpell(_Q, target.x, target.z)
                else
                    CastSpell(_Q)
                end
            end
        end
    elseif target == nil then
        if W.IsReady() and W.State() == 1 and ValidTarget(ts.target) then
            local obj = GetBestFarTo(myHero)
            if obj ~= nil then
                CastW1(obj)
            elseif ward:IsReady() and CountEnemiesNear(myHero, W.Range()) > 0 then
                local allies = getChampionsNear(target, GetAllyHeroes(), R.KickRange + 500)
                if #allies > 0 then
                    local ally = allies[1]
                    local pos, d, e = prediction:GetPredictedPos(ally, W.Delay, W.Speed, myHero, false)
                    ward:Cast(pos)
                else
                    ward:Cast(mousePos)
                end
            end
        end
    end
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local Position = prediction:GetPredictedPos(object, GetDistance(myHero, object)/Q.Speed)
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
        local w = width --+ VP:GetHitBox(object) / 3
        if isOnSegment and GetDistanceSqr(pointSegment, Position) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, Position) then
            n = n + 1
        end
    end
    return n
end



function SmiteQ(target, Position)
    local delay = Q.Delay
    local speed = Q.Speed
    local radius = Q.Width
    local from = Vector(myHero)
    local range = Q.Range()
    local draw = false
    local dmg = 0

    local counter = 0
    local smiteMinion = nil
    for i, minion in pairs(EnemyMinions.objects) do
        local col = VP:CheckCol(target, minion, Position, delay, radius, range, speed, from, draw, dmg)
        if col then smiteMinion = minion counter = counter + 1 end
    end
    for i, minion in pairs(JungleMinions.objects) do
        local col = VP:CheckCol(target, minion, Position, delay, radius, range, speed, from, draw, dmg)
        if col then smiteMinion = minion counter = counter + 1 end
    end
    
    --[[
    if Position then
        counter = CountObjectsOnLineSegment(Vector(myHero), Vector(Position), Q.Width, EnemyMinions.objects) + CountObjectsOnLineSegment(Vector(myHero), Vector(Position), Q.Width, JungleMinions.objects)
    end]]
    if counter == 1 and GetDistanceSqr(myHero, Position) < Q.Range() * Q.Range() then
        if ValidTarget(smiteMinion, Smite.Range) and Smite.IsReady() and damage:Smite() >= smiteMinion.health then CastSpell(smiteslot, smiteMinion) end
    end
end

function MinionInRange(objects)
    for i, minion in pairs(objects) do
        if ValidTarget(minion, AA.Range(minion)) then
            return minion
        end
    end
end

function GapCloseTo(target)
    if W.IsReady() and W.State() == 1 then
        local obj = GetBestNearTo(target)
        if obj ~= nil and GetDistanceSqr(obj, target) < GetDistanceSqr(myHero, target) then
            CastW1(obj)
        elseif ward:IsReady() then
            local pos, d, e = prediction:GetPredictedPos(target, W.Delay)
            ward:Cast(pos)
            DelayAction(function(pos) ward:Jump(pos) end, 0.1, {pos})
        end
    end
end

function Clear()
    local minionInRange = MinionInRange(EnemyMinions.objects)
    if ValidTarget(minionInRange, AA.Range(minionInRange)) and P.Stacks > 0 then return end
    if Config.LaneClear.useQ or Config.LaneClear.useW or Config.LaneClear.useE then
        for i, minion in pairs(EnemyMinions.objects) do
            if ValidTarget(minion, AA.Range(minion)) and P.Stacks > 0 then return end
            if Config.LaneClear.useQ and ValidTarget(minion, Q.Range()) and Q.IsReady() and Q.State() == 2 and not minion.dead then
                CastQ(minion)
                return
            end
            if Config.LaneClear.useE and ValidTarget(minion, E.Range()) and E.IsReady() and E.State() == 2 and not minion.dead then
                CastSpell(_E)
                return
            end
            if Config.LaneClear.useW and W.IsReady() and W.State() == 2 and ValidTarget(minion, AA.Range(minion) + 200) and not minion.dead then
                CastW(myHero)
                return
            end
            
            if Config.LaneClear.useQ and ValidTarget(minion, Q.Range()) and Q.IsReady() and Q.State() == 1 and not minion.dead then
                CastSpell(_Q, minion.x, minion.z)
                return
            end
            if Config.LaneClear.useE and ValidTarget(minion, E.Range()) and E.IsReady() and E.State() == 1 and not minion.dead then
                CastSpell(_E)
                return
            end
            if Config.LaneClear.useW and W.IsReady() and W.State() == 1 and ValidTarget(minion, AA.Range(minion) + 200) and not minion.dead then
                CastW(myHero)
                return
            end
            
        end
    end
    if Config.JungleClear.useQ or Config.JungleClear.useW or Config.JungleClear.useE or Config.JungleClear.useSmite then
        for i, minion in pairs(JungleMinions.objects) do
            if ValidTarget(minion, Q.Range()) and minion.health > 0 and (minion.charName:lower():find("dragon") or minion.charName:lower():find("worm")) then
                if Smite.IsReady() then 
                    if damage:Smite() >= minion.health and ValidTarget(minion, Smite.Range) and Config.JungleClear.useSmite then
                        CastSpell(smiteslot, minion)
                    elseif Config.JungleClear.useW and W.IsReady() and W.State() == 1 and damage:Smite() * 1.3 >= minion.health and not ValidTarget(minion, Smite.Range) and not Q.IsReady() and os.clock() - Q.LastCastTime > 2 then
                        GapCloseTo(minion)
                    end
                end
            end
            if ValidTarget(minion, AA.Range(minion)) and P.Stacks > 0 or os.clock() - Q.LastCastTime1 < 0.2 or Q.Obj or os.clock() - E.LastCastTime1 < 0.2 then return end
            if Config.JungleClear.useQ and ValidTarget(minion, Q.Range()) and Q.IsReady()  and Q.State() == 2  and not minion.dead then
                CastSpell(_Q)
                return
            end
            if Config.JungleClear.useE and ValidTarget(minion, E.Range()) and E.IsReady()  and E.State() == 2  and not minion.dead then
                CastSpell(_E)
                return
            end
            if Config.JungleClear.useW and W.IsReady() and W.State() == 2 and not Q.IsReady() and not E.IsReady() and ValidTarget(minion, AA.Range(minion)) and not minion.dead then
                CastW(myHero)
                return
            end 
            if Config.JungleClear.useQ and ValidTarget(minion, Q.Range()) and Q.IsReady() and Q.State() == 1  and not minion.dead then
                if ValidTarget(minion, Q.Range()) and minion.health > 0 and (minion.charName:lower():find("dragon") or minion.charName:lower():find("worm")) then
                    if Q.IsReady() and 2 * Q.Damage(minion) + damage:Smite() >= minion.health and 1 * Q.Damage(minion) + damage:Smite() <= minion.health then
                        return
                    end
                end
                CastSpell(_Q, minion.x, minion.z)
                return
            end
            if Config.JungleClear.useE and ValidTarget(minion, E.Range()) and E.IsReady() and E.State() == 1  and not minion.dead then
                CastSpell(_E)
                return
            end
            if Config.JungleClear.useW and W.IsReady() and W.State() == 1 and ValidTarget(minion, AA.Range(minion) + 200) and not minion.dead then
                CastW(myHero)
                return
            end
        end
    end
end


function GankCombo()
    local target = ts.target
    if ValidTarget(target) then
        if Config.Combo.useItems then UseItems(target) end
        --if Config.Combo.useQ and insec:TargetHaveQ(target) and Q.State() == 2 and not R.IsReady() and GetDistance(myHero, target) > R.KickRange - 100 then CastQ2(target) end
        if ValidTarget(target, AA.Range(target)) and P.Stacks > 2 - Config.Combo.useStack and not R.IsReady() then return end
        if Config.Combo.useW and ValidTarget(target, 600 + E.Range()) then
            if Config.Combo.useWard and ward:IsReady() then
                if insec:IsReady() and Config.Combo.useR then
                    insec:Cast()
                else
                    if GetDistanceSqr(myHero, target) > E.Range() * E.Range() and Config.Combo.useW and W.IsReady() and W.State() == 1 then 
                        GapCloseTo(target)
                    end
                end
            else
                local obj = GetBestNearTo(target)
                if obj ~= nil and GetDistanceSqr(obj, target) < GetDistanceSqr(myHero, target) then
                    CastW1(obj)
                end
            end
        end
        if W.IsReady() and W.State() == 1 and not ValidTarget(target, 600) then return end
        if Config.Combo.useE and ValidTarget(target, E.Range()) and not Q.IsReady() then CastE(target) end
        if Config.Combo.useQ and Q.State() == 1 and ValidTarget(target, Q.Range()) then CastQ1(target) end
        if Config.Combo.useQ and Q.State() == 2 and ValidTarget(target, Q.Range()) then CastQ2(target) end

    end
end

function StarCombo()
    local target = ts.target
    if ValidTarget(target) then
        if Config.Combo.useItems then UseItems(target) end
        if ValidTarget(target, 600) then
            if ValidTarget(target, AA.Range(target)) and P.Stacks > 2 - Config.Combo.useStack and not R.IsReady() then return end
            if Config.Combo.StarMode == 1 and Config.Combo.useW and W.IsReady() and Config.Combo.useWard and ward:IsReady() and insec:IsReady() then
                insec:Cast()
            end
            if insec:RecentInsec() then return end
            if Config.Combo.useQ and Q.State() == 1 then
                if Config.Combo.StarMode == 1 then
                    CastQ1(target) 
                elseif Config.Combo.StarMode == 2 then
                    if not R.IsReady() then
                        CastQ1(target)
                    end
                end
            end
            if Config.Combo.useE and (not R.IsReady()) and ValidTarget(target, E.Range()) then CastE(target) end
            if Config.Combo.useQ and Q.State() == 2 and not R.IsReady() and os.clock() - R.LastCastTime > 10 then CastQ2(target) end
            if Config.Combo.useR and R.IsReady() then
                if Config.Combo.StarMode == 1 and insec:TargetHaveQ(target) then
                    CastR(target)
                elseif Config.Combo.StarMode == 2 and Q.IsReady() and Q.State() == 1 then
                    CastR(target)
                    DelayAction(function() if Q.IsReady() and Q.State() == 1 then CastSpell(_Q, target.x, target.z) end end, R.Delay)
                end
            end
        end
    end
end

function Combo()
    local target = ts.target
    if ValidTarget(target) then
        if Config.Combo.useItems then UseItems(target) end
        if ValidTarget(target, AA.Range(target)) and P.Stacks > 2 - Config.Combo.useStack then return end
        if Config.Combo.useE then CastE(target) end
        if Config.Combo.useQ then CastQ(target) end
        if Config.Combo.useW and W.State() == 2 and W.IsReady() then CastW2() end
        if Q.IsFlying or os.clock() - Q.LastCastTime2 < 0.2 or (Q.Target and Q.Target.valid) then return end
        if GetDistanceSqr(myHero, target) > E.Range() * E.Range() and Config.Combo.useW and W.IsReady() and W.State() == 1 and ((not Q.IsReady() and Q.Obj == nil and GetDistanceSqr(myHero, target) < Q.Range() * Q.Range() and not insec:TargetHaveQ(target)) or (Q.IsReady() and GetDistanceSqr(myHero, target) > Q.Range() * Q.Range())) then 
            if Config.Combo.useWard then
                GapCloseTo(target)
            else
                local obj = GetBestNearTo(target)
                if obj ~= nil and GetDistanceSqr(obj, target) < GetDistanceSqr(myHero, target) then
                    CastW1(obj)
                end
            end
        end
    end
end


function getAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius - 10 or 0
end


function Harass()
    local target = ts.target
    if ValidTarget(target) then
        if ValidTarget(target, AA.Range(target)) and P.Stacks > 0 then return end
        if Config.Harass.useQ then 
            if Q.State() == 1 then CastQ1(target)
            elseif Q.State() == 2 then CastQ2(target) end
        end
        if Config.Harass.useE and E.State() == 1 then CastE1(target) end
        if Q.IsFlying or os.clock() - Q.LastCastTime2 < 0.2 or Q.Obj ~= nil or (Q.IsReady() and Config.Harass.useQ) then return end
        if Config.Harass.useW then
            local q,w,e,r, dmg  = damage:getBestCombo(target)
            if GetDistanceSqr(myHero, target) < getAARange(target) * getAARange(target) and dmg < target.health then
                local obj = GetBestFarTo(myHero)
                if obj ~= nil and Config.Keys.Harass and W.IsReady() and W.State() == 1 and GetDistanceSqr(myHero, target) < GetDistanceSqr(obj, target) then
                    CastW1(obj)
                end
            end
        end
    end
end

--CastX

function CastQ(target)
    if Q.IsReady() then
        if Q.State() == 1 then
            CastQ1(target)
        else 
            CastQ2(target)
        end
    end 
end

function CastQ1(target)
    if Q.IsReady() and Q.State() == 1 and ValidTarget(target, Q.Range()) then
        local CastPosition, HitChance, HeroPosition = prediction:GetPrediction(target, Q.Delay, Q.Width, Q.Range(), Q.Speed, myHero, "linear", Q.Collision, false)
        if CastPosition~=nil and HitChance >= 2 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        else
            if CastPosition~=nil and (Config.Keys.Combo or Config.Keys.Insec) and Smite.IsReady() and target.type == myHero.type and Config.Misc.SmiteQ then
                SmiteQ(target, CastPosition)
            end
        end
    end
end

function ForceQ2()
    if Q.IsReady() and Q.State() == 2 and IsKeyPressed() then
       CastSpell(_Q)
    end
    if Q.State() == 2 then
       DelayAction(function() ForceQ2() end, 0.05)
    end
end

function CastQ2(target)
    if Q.IsReady() and Q.State() == 2 and ValidTarget(target, Q.Range()) then
        CastSpell(_Q)
    end
end


function CastW(obj)
    if W.IsReady() then
        if W.State() == 1 then
            CastW1(obj)
        else
            CastW2()
        end
    end
end

function CastW1(obj)
    if W.IsReady() and W.State() == 1 then
        CastSpell(_W, obj)
    end
end


function CastW2()
    if W.IsReady() and W.State() == 2 then
        CastSpell(_W)
    end
end

function CastE(target)
    if E.IsReady() then
        if E.State() == 1 then
            CastE1(target)
        else
            CastE2(target)
        end
    end
end

function CastE1(target)
    if E.IsReady() and E.State() == 1 then
        if ValidTarget(target, E.Range()) then
            CastSpell(_E)
        end
    end
end
function CastE2(target)
    if E.IsReady() and E.State() == 2 then
        if ValidTarget(target, E.Range()) then
            CastSpell(_E)
        end
    end
end


function CastR(target)
    if R.IsReady() then
        CastSpell(_R, target)
    end
end

function getChampionPriority(i, team, range)
    for idx, champion in ipairs(team) do
        if i == 1 and priorityTable.p1[champion.charName] ~= nil then return champion
        elseif i == 2 and priorityTable.p2[champion.charName] ~= nil then return champion
        elseif i == 3 and priorityTable.p3[champion.charName] ~= nil then return champion
        elseif i == 4 and priorityTable.p4[champion.charName] ~= nil then return champion
        elseif i == 5 and priorityTable.p5[champion.charName] ~= nil then return champion
        end
    end
end

function getPriorityChampion(champion)
    if priorityTable.p1[champion.charName] ~= nil then
        return 1
    elseif priorityTable.p2[champion.charName] ~= nil then
        return 2
    elseif priorityTable.p3[champion.charName] ~= nil then
        return 3
    elseif priorityTable.p4[champion.charName] ~= nil then
        return 4
    elseif priorityTable.p5[champion.charName] ~= nil then
        return 5
    end
    return 5
end

function getBestPriorityChampion(source, team, range)
    local bestPriority = nil
    local bestChampion = nil
    if #team > 0 then
        for idx, champion in ipairs(team) do
            if champion.valid and champion.visible then
                if GetDistanceSqr(source, champion) <= range * range then
                    local priority = getPriorityChampion(champion)
                    if bestPriority == nil then
                        bestPriority = priority
                        bestChampion = champion
                    elseif priority < bestPriority then
                        bestPriority = priority
                        bestChampion = champion
                    end
                end
            end
        end
    end
    return bestChampion
end

function getNearestChampion(source, team, range)
    local nearest = nil
    if #team > 0 then
        for idx, champion in ipairs(team) do
            if champion.valid and champion.visible then
                if GetDistanceSqr(source, champion) <= range * range then
                    if nearest == nil then
                        nearest = champion
                    elseif GetDistanceSqr(source, champion) < GetDistanceSqr(source, nearest) then
                        nearest = champion
                    end
                end
            end
        end
    end
    return nearest
end

function getPercentageTeam(source, team, range) -- GetAllyHeroes() or GetEnemyHeroes()
    local count = 0
    
    if team == GetAllyHeroes() then count = 1 end
    if #team > 0 then
        for idx, champion in ipairs(team) do
            if champion.valid and champion.visible then
                if GetDistanceSqr(source, champion) <= range * range then
                    count = count + champion.health/champion.maxHealth
                end
            end
        end
    end
    return count
end



function getChampionsNear(source, team, range)
    local tab = {}
    if #team > 0 then
        for idx, champion in ipairs(team) do
            if champion.valid and champion.visible then
                if GetDistanceSqr(source, champion) <= range * range then
                    if #tab == 0 then table.insert(tab, 1, champion)
                    else
                        local temp = tab[#tab]
                        if getPriorityChampion(temp) < getPriorityChampion(champion) then
                            table.insert(tab, #tab + 1, champion)
                        else
                            table.insert(tab, #tab, champion)
                        end
                    end
                end
            end
        end
    end
    return tab
end
local baseWindUpTime = 3
function OnProcessSpell(unit, spell)
    if myHero.dead or unit == nil or not scriptLoaded then return end
    if not unit.isMe then
    end
    if not unit.isMe then return end
    --print(spell.name)
    if spell.name:lower():find("basicattack") then
        baseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
        DelayAction(
                function() 
                    if P.Stacks > 0 then P.Stacks = P.Stacks - 1 end
                end
            , WindUpTime())
    elseif spell.name:lower() == "blindmonkqone" then Q.LastCastTime1 = os.clock() P.Stacks = 2
    elseif spell.name:lower() == "blindmonkqtwo" then Q.LastCastTime2 = os.clock() P.Stacks = 2 Q.IsFlying = true
    elseif spell.name:lower() == "blindmonkwone" then W.LastCastTime1 = os.clock() P.Stacks = 2
    elseif spell.name:lower() == "blindmonkwtwo" then W.LastCastTime2 = os.clock() P.Stacks = 2
    elseif spell.name:lower() == "blindmonkeone" then E.LastCastTime1 = os.clock() P.Stacks = 2
    elseif spell.name:lower() == "blindmonketwo" then E.LastCastTime2 = os.clock() P.Stacks = 2
    elseif spell.name:lower() == "blindmonkrkick" then 
        R.LastCastTime = os.clock() P.Stacks = 2
        if Config.Keys.Insec and insec.Menu.UseFlash and Flash.IsReady() then
            local pos = insec:BestPos()
            if pos ~= nil then DelayAction(function() CastSpell(flashslot, pos.x, pos.z) end, 0.5) end
        end
    elseif spell.name:lower():find("flash") then Flash.LastCastTime = os.clock()
    end
end

function WindUpTime()
    return (1 / (myHero.attackSpeed * baseWindUpTime))
end

function RecvPacket(p)
    -- body
end

function OnCreateObj(obj)
    if obj == nil then return end
    --if obj.name:lower():find("blindmonk") or obj.name:lower():find("blind_monk") then print("Created: "..obj.name) end
    if obj.name:lower():find("linemissile") and GetDistanceSqr(myHero, obj) < 80 * 80 and os.clock() -  Q.LastCastTime1 < 1 then
        Q.Obj = obj
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("_q") and obj.name:lower():find("tar") and obj.name:lower():find("_indicator") then
        Q.Target = obj
        DelayAction(function() if IsKeyPressed() then ForceQ2() end end, 2.8)
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("resonatingstrike_tar_sound") then
        Q.IsFlying = true
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("resonatingstrike_02") then
        Q.IsFlying = true
    end
    -- body
end

function OnDeleteObj(obj)
    if obj == nil then return end
    --if obj.name:lower():find("blindmonk") or obj.name:lower():find("blind_monk") then print("Deleted: "..obj.name) end
    if GetDistanceSqr(myHero, obj) < 1300 * 1300 and obj.name:lower():find("linemissile") and Q.Obj ~= nil then 
        if GetDistanceSqr(obj, Q.Obj) < 80 * 80 then Q.Obj = nil end
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("_q") and obj.name:lower():find("tar") and obj.name:lower():find("_indicator")then
        Q.Target = nil
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("resonatingstrike_tar_sound") then
        Q.IsFlying = false
        --PrintMessage("Is not Flying")
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("passive") and obj.name:lower():find("buf") then
        P.Stacks = 0
    elseif obj.name:lower():find("blind_monk") and obj.name:lower():find("ult") and obj.name:lower():find("impact") then
        if IsKeyPressed() then 
            ForceQ2()
        end
    elseif obj.name:lower():find("blindmonk") and obj.name:lower():find("_r") and obj.name:lower():find("_self") then
        if IsKeyPressed() then 
            ForceQ2()
        end
    end
    -- body
end


function UseItems(unit)
    if unit ~= nil then
        for _, item in pairs(CastableItems) do
            if item.IsReady() and GetDistanceSqr(myHero, unit) < item.Range * item.Range then
                if item.reqTarget then
                    CastSpell(item.Slot(), unit)
                else
                    CastSpell(item.Slot())
                end
            end
        end
    end
end

function GetCustomTarget()
    ts:update()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return ts.target
end

function GetBestFarTo(pos)
    local minion = minion:FarTo(pos)
    local ally = ally:FarTo(pos)
    local ward = ward:FarTo(pos)
    local distance1 = ally ~= nil and GetDistance(pos, ally) or 0
    local distance2 = minion ~= nil and GetDistance(pos, minion) or 0
    local distance3 = ward ~= nil and GetDistance(pos, ward) or 0
    local best = math.max(distance1, distance2, distance3)
    if best > 0 then
        if best == distance1 then
            return ally
        elseif best == distance2 then
            return minion
        elseif best == distance3 then
            return ward
        end
    end
    return nil
end

function GetBestNearTo(pos)
    local minion = minion:NearTo(pos)
    local ally = ally:NearTo(pos)
    local ward = ward:NearTo(pos)
    local distance1 = ally ~= nil and GetDistance(pos, ally) or 10000
    local distance2 = minion ~= nil and GetDistance(pos, minion) or 10000
    local distance3 = ward ~= nil and GetDistance(pos, ward) or 10000
    local best = math.min(distance1, distance2, distance3)
    if best < 10000 then
        if best == distance1 then
            return ally
        elseif best == distance2 then
            return minion
        elseif best == distance3 then
            return ward
        end
    end
    return nil
end

function OrbLoad()
    if _G.Reborn_Initialised then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Insec", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
        require 'SxOrbWalk'
        --SxOrb = SxOrbWalk()
        Config:addSubMenu(scriptname.." - Orbwalking", "Orbwalking")
        SxOrb:LoadToMenu(Config.Orbwalking)
        SxOrb:RegisterHotKey("harass",  Config.Keys, "Harass")
        SxOrb:RegisterHotKey("fight",  Config.Keys, "Combo")
        SxOrb:RegisterHotKey("fight",  Config.Keys, "Insec")
        SxOrb:RegisterHotKey("laneclear",  Config.Keys, "Clear")
        --SxOrb:RegisterHotKey("harass",  Config.Keys, "fullHarass")
        --SxOrb:RegisterHotKey("fight",  Config.Keys, "Combo2")
        SxOrb:EnableAttacks()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
        require 'SOW'
        SOWi = SOW(VP)
        Config:addSubMenu(scriptname.." - Orbwalking", "Orbwalking")
        SOWi:LoadToMenu(Config.Orbwalking)
    else
        print("You will need an orbwalker")
    end
end


function CountEnemiesNear(source, range)
    local Count = 0
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
            if GetDistanceSqr(enemy, source) <= range * range then
                Count = Count + 1
            end
        end
    end
    return Count
end
 

function GetSlotItem(id, unit)
    if FixItems then
        unit        = unit or myHero
    
        if (not ItemNames[id]) then
            return ___GetInventorySlotItem(id, unit)
        end
    
        local name  = ItemNames[id]
        
        for slot = ITEM_1, ITEM_7 do
            local item = unit:GetSpellData(slot).name
            if ((#item > 0) and (item:lower() == name:lower())) then
                return slot
            end
        end
    end
end

function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end
function arrangePrioritys()
     local priorityOrder = {
                [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,2,3},
        [4] = {1,1,2,3,4},
        [5] = {1,2,3,4,5},
    }
    local enemies = #GetEnemyHeroes()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.p1, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.p2, enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.p3,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.p4,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.p5,  enemy, priorityOrder[enemies][5])
    end
end

function FindSlot(name)
    for slot = ITEM_1, ITEM_7 do
        if myHero:GetSpellData(slot).name:lower():find(name:lower()) then
            return slot
        end
    end
    return nil
end

function GetSlot(id)
    ItemNames               = {
        [3303]              = "ArchAngelsDummySpell",
        [3007]              = "ArchAngelsDummySpell",
        [3144]              = "BilgewaterCutlass",
        [3188]              = "ItemBlackfireTorch",
        [3153]              = "ItemSwordOfFeastAndFamine",
        [3405]              = "TrinketSweeperLvl1",
        [3411]              = "TrinketOrbLvl1",
        [3166]              = "TrinketTotemLvl1",
        [3450]              = "OdinTrinketRevive",
        [2041]              = "ItemCrystalFlask",
        [2054]              = "ItemKingPoroSnack",
        [2138]              = "ElixirOfIron",
        [2137]              = "ElixirOfRuin",
        [2139]              = "ElixirOfSorcery",
        [2140]              = "ElixirOfWrath",
        [3184]              = "OdinEntropicClaymore",
        [2050]              = "ItemMiniWard",
        [3401]              = "HealthBomb",
        [3363]              = "TrinketOrbLvl3",
        [3092]              = "ItemGlacialSpikeCast",
        [3460]              = "AscWarp",
        [3361]              = "TrinketTotemLvl3",
        [3362]              = "TrinketTotemLvl4",
        [3159]              = "HextechSweeper",
        [2051]              = "ItemHorn",
        --[2003]            = "RegenerationPotion",
        [3146]              = "HextechGunblade",
        [3187]              = "HextechSweeper",
        [3190]              = "IronStylus",
        [2004]              = "FlaskOfCrystalWater",
        [3139]              = "ItemMercurial",
        [3222]              = "ItemMorellosBane",
        [3042]              = "Muramana",
        [3043]              = "Muramana",
        [3180]              = "OdynsVeil",
        [3056]              = "ItemFaithShaker",
        [2047]              = "OracleExtractSight",
        [3364]              = "TrinketSweeperLvl3",
        [2052]              = "ItemPoroSnack",
        [3140]              = "QuicksilverSash",
        [3143]              = "RanduinsOmen",
        [3074]              = "ItemTiamatCleave",
        [3800]              = "ItemRighteousGlory",
        [2045]              = "ItemGhostWard",
        [3342]              = "TrinketOrbLvl1",
        [3040]              = "ItemSeraphsEmbrace",
        [3048]              = "ItemSeraphsEmbrace",
        [2049]              = "ItemGhostWard",
        [3345]              = "OdinTrinketRevive",
        [2044]              = "SightWard",
        [3341]              = "TrinketSweeperLvl1",
        [3069]              = "shurelyascrest",
        [3599]              = "KalistaPSpellCast",
        [3185]              = "HextechSweeper",
        [3077]              = "ItemTiamatCleave",
        [2009]              = "ItemMiniRegenPotion",
        [2010]              = "ItemMiniRegenPotion",
        [3023]              = "ItemWraithCollar",
        [3290]              = "ItemWraithCollar",
        [2043]              = "VisionWard",
        [3340]              = "TrinketTotemLvl1",
        [3090]              = "ZhonyasHourglass",
        [3154]              = "wrigglelantern",
        [3142]              = "YoumusBlade",
        [3157]              = "ZhonyasHourglass",
        [3512]              = "ItemVoidGate",
        [3131]              = "ItemSoTD",
        [3137]              = "ItemDervishBlade",
        [3352]              = "RelicSpotter",
        [3350]              = "TrinketTotemLvl2",
    }
    for slot = ITEM_1, ITEM_7 do
        if myHero:GetSpellData(slot).name:lower() == ItemNames[id]:lower() then
            return slot
        end
    end
    return nil
end



class "Insec"
function Insec:__init()
    self.TS = TargetSelector(TARGET_PRIORITY, 1100, DAMAGE_PHYSICAL)
    self.Menu = nil
    self.Draw = nil
    self.insecPos = nil
    self.insecTime = 0
    self.targetQ = nil
    AddTickCallback(function() self:OnTick() end)
end


function Insec:OnWndMsg(msg, key)

    if msg == WM_LBUTTONDOWN then
        if self.Menu.Position == 4 and R.IsReady() then
            local ally = ally:NearTo(mousePos)
            if ally ~= nil and ValidTarget(self.TS.target) then 
                local target = self.TS.target
                self:Set(ally)
                DelayAction(function() self:Set(nil) end, 10)
            else
                local pos = Vector(mousePos)
                self:Set(pos)
                DelayAction(function() self:Set(nil) end, 10)
            end
        end
    elseif msg == KEY_UP then
        if key == Config.Keys._param[4].key then
            self.Menu.Position = self.Menu.Position + 1
            if self.Menu.Position == 5 then self.Menu.Position = 1 end

       end
    end
end


function Insec:OnTick()
    if myHero.dead then return end
    self.TS:update()
    if not R.IsReady() then self.insecPos = nil end
end


function Insec:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        self.Menu:addParam("Priority","Priority", SCRIPT_PARAM_LIST, 1, {"Ward > Flash", "Flash > Ward"})
        self.Menu:addParam("Position","Insec Position", SCRIPT_PARAM_LIST, 3, {"Turrets and Allies", "Mouse Position", "Current Position", "Clicked Position"})
        self.Menu:addParam("info", "+ % Distance between ward and target", SCRIPT_PARAM_INFO, "")
        self.Menu:addParam("DistanceBetween","+ % Distance ..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        self.Menu:addParam("UseFlash","Use Flash To Return", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Position = 1
        self.Menu:permaShow("Position")
        AddMsgCallback(function(msg, key) self:OnWndMsg(msg, key) end)
    end
end

function Insec:LoadDraw(m)
    self.Draw = m
    if self.Draw ~= nil then
        self.Draw:addParam("Target","Blue Circle on Insec Target", SCRIPT_PARAM_ONOFF, true)
        self.Draw:addParam("Line","Line Insec", SCRIPT_PARAM_ONOFF, true)
        AddDrawCallback(function() self:OnDraw() end)
    end
end

function Insec:OnDraw()
    if myHero.dead then return end
    if self.Draw ~= nil and R.IsReady() then
        local target = self.TS.target
        if self.Draw.Target and ValidTarget(target) then
            draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target)*1.8, Colors.Blue, 1)
        end
        if self.Draw.Line and ValidTarget(target) then
            local pos = self:BestPos()
            if pos ~= nil then
                local finalPos = Vector(target) + Vector(pos.x - target.x, 0, pos.z - target.z):normalized() * R.KickRange
                local p1 = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
                local p2 = WorldToScreen(D3DXVECTOR3(finalPos.x, finalPos.y, finalPos.z))
                DrawLine(p1.x, p1.y, p2.x, p2.y, 2, Colors.Blue)
            end
        end
    end
end

function Insec:TargetHaveQ(target)
    if ValidTarget(target) and Q.Target and Q.Target.valid and GetDistanceSqr(Q.Target, target) <= VP:GetHitBox(target) * VP:GetHitBox(target)   then
        return true
    else return false end
    --return ValidTarget(target) and (TargetHaveBuff("blindmonkqone", target) or TargetHaveBuff("blindmonkqonechaos", target))
end

function Insec:TurretNear()
    for name, turret in pairs(GetTurrets()) do
       if turret ~= nil and turret.valid and GetDistanceSqr(myHero, turret) < 3000 * 3000 then
           if turret.team == myHero.team then
               return turret
           end
       end
    end
    return nil
end

function Insec:Set(pos)
    self.insecPos = pos
end


function Insec:IsReady(tar)
    return ( ((W.IsReady() and ward:IsReady()) or Flash.IsReady()) or self:RecentInsec(4) ) and R.IsReady() and self:BestPos(tar)~=nil
end


function Insec:BestPos(tar)
    local bestPos = nil
    if self.Menu ~= nil then
        local target = ValidTarget(tar) and tar or self.TS.target
        if ValidTarget(target) then
            if self.Menu.Position == 2 then
                bestPos = Vector(mousePos)
            elseif self.Menu.Position == 3 then
                bestPos = Vector(myHero)
            else 
                local allies = getChampionsNear(target, GetAllyHeroes(), R.KickRange + 500)
                local turret = self:TurretNear()
                if bestPos == nil then
                    if turret ~= nil  and turret.valid then
                        if GetDistanceSqr(turret, target) - R.KickRange < (turret.range + 200) * (turret.range + 200) then
                            bestPos = turret 
                        end
                    end
                end
                if bestPos == nil then
                    if #allies > 0 then
                        local ally = allies[1]
                        local pos = ally + Vector(target.x - ally.x, 0,  target.z - ally.z):normalized():perpendicular() * getAARange(ally) / 2
                        bestPos = pos
                    end
                end
                if bestPos == nil then
                    bestPos = Vector(myHero)
                end
            end
        end
    end

    if self.insecPos == nil then
        return bestPos
    else 
        return self.insecPos
    end

end

function Insec:DistanceBetween(from, target)
    return ValidTarget(target) and (VP:GetHitBox(myHero) + VP:GetHitBox(target) + 80) * (self.Menu.DistanceBetween + 100)/100 or 0
end

function Insec:Cast(tar)
    local target = self.TS.target
    local pos = self:BestPos(tar)
    if ValidTarget(target, self.TS.range) and pos ~= nil then
        local to = Vector(target) + Vector(pos.x - target.x, 0, pos.z - target.z):normalized() * R.KickRange
        local distanceBetween = self:DistanceBetween(myHero, target)  
        if not R.IsReady() and ValidTarget(target, E.Range()) and not insec:TargetHaveQ(target) then CastE(target) end
        if Q.IsReady() and Q.State() == 2 and R.IsReady() and GetDistanceSqr(myHero, target) > (600 - distanceBetween) * (600 - distanceBetween) and Q.Target and Q.Target.valid and GetDistanceSqr(Q.Target, target) < (600 - distanceBetween) * (600 - distanceBetween) then CastSpell(_Q) end
        CastQ1(target)
        --if TargetHaveBuff("blindmonkrkick", target) and Q.IsReady() then CastQ(target) end
        if R.IsReady() and GetDistanceSqr(myHero, target) < (600 - distanceBetween) * (600 - distanceBetween) and GetDistanceSqr(myHero, to) < GetDistanceSqr(target, to) and not self:RecentInsec() then
            if self.Menu.Priority == 2 then
                if Flash.IsReady() then
                    self:GapClose(myHero, target, to, "Flash")
                elseif ward:IsReady() and W.IsReady() then
                    self:GapClose(myHero, target, to, "WardJump")
                end
            else
                if ward:IsReady() and W.IsReady() then
                    self:GapClose(myHero, target, to, "WardJump")
                elseif Flash.IsReady() then
                    self:GapClose(myHero, target, to, "Flash")
                end
            end
        end
        self:CastR(myHero, target, to)
    end
end

function Insec:RecentInsec(t)
    local time = t~=nil and t or 1
    return os.clock() - ward.lastTimeWard < time or os.clock() - Flash.LastCastTime < time
end

function Insec:GapClose(from, target, to, mode)
    local distanceBetween = self:DistanceBetween(myHero, target)
    local Position, HitChance, _ = prediction:GetPredictedPos(target, W.Delay + (distanceBetween + GetDistance(from, target))/W.Speed)
    --local Position = Vector(target)
    if Position ~= nil then
        local GapClosePos = Vector(Position) + Vector(Position.x - to.x, 0,  Position.z - to.z):normalized() * 600
        if mode == "Flash" then
            local GapClosePos = Position + Vector(Position.x - to.x, 0,  Position.z - to.z):normalized() * (distanceBetween)
            if GetDistanceSqr(GapClosePos, to) > GetDistanceSqr(target, to) and GetDistanceSqr(GapClosePos, Position) >= 80 * 80 and GetDistanceSqr(from, GapClosePos) < Flash.Range * Flash.Range and GetDistanceSqr(from, GapClosePos) > Flash.Range/2 * Flash.Range/2 then
                self:Set(to)
                DelayAction(function() self:Set(nil) end, 5)
                CastSpell(flashslot, GapClosePos.x, GapClosePos.z)
    
            end
        elseif mode == "WardJump" then
    
            GapClosePos = Position + Vector(Position.x - to.x, 0,  Position.z - to.z):normalized() * (distanceBetween)
            if ward:IsReady() and GetDistanceSqr(GapClosePos, to) > GetDistanceSqr(target, to) and GetDistanceSqr(GapClosePos, Position) >= 80 * 80 and GetDistanceSqr(GapClosePos, Position) < (R.Range() - 75) * (R.Range() - 75) and GetDistanceSqr(from, GapClosePos) < 600 * 600 then 
                self:Set(to)
                DelayAction(function() self:Set(nil) end, 5)
                ward:Cast(GapClosePos)
                ward:Jump(GapClosePos)
            end
            
            
        end
    end
end

function Insec:CastR(from, target, to)
    if Config.Keys.Insec or (Config.Keys.Combo and Config.Combo.Mode == 3) then
        if R.IsReady() and from.valid and ValidTarget(target) and to~=nil and GetDistanceSqr(from, target) < R.Range() * R.Range() and GetDistanceSqr(from, to) > GetDistanceSqr(target, to) then
            local finalPos = Vector(from) + Vector(target.x - from.x, 0,  target.z - from.z):normalized() * R.KickRange
            local closestAllyToInsec = VectorPointProjectionOnLine(from, finalPos, to)
            if GetDistanceSqr(closestAllyToInsec, to) < R.KickRange * R.KickRange * 0.5 * 0.5 then
                if Q.State() == 1 and Q.IsReady() then CastQ1(target) end
                CastR(target)
            end
        end
    end
end

class "AutoR"
function AutoR:__init()
    self.Menu = nil
end

function AutoR:LoadMenu(m)
    self.Menu = m 
    if self.Menu ~= nil then
        self.Menu:addSubMenu("Auto R", "AutoR")
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            local champion = enemy.charName
            self.Menu.AutoR:addParam(champion.."Q", champion.." (Q)", SCRIPT_PARAM_ONOFF, false)
            self.Menu.AutoR:addParam(champion.."W", champion.." (W)", SCRIPT_PARAM_ONOFF, false)
            self.Menu.AutoR:addParam(champion.."E", champion.." (E)", SCRIPT_PARAM_ONOFF, false)
            self.Menu.AutoR:addParam(champion.."R", champion.." (R)", SCRIPT_PARAM_ONOFF, false)
        end
        self.Menu:addParam("Time",  "Time Limit to Try", SCRIPT_PARAM_SLICE, 2, 0, 8)
        AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    end
end

function AutoR:ForceInsec(unit, time)
    if not ValidTarget(unit) or os.clock() - time > self.Menu.Time then return end
    if R.IsReady() and ValidTarget(unit, Q.Range()) then
        if insec:IsReady(unit) then
            insec:Cast(unit)
        end 
        if ValidTarget(unit, R.Range()) then
            CastR(unit)
        end
    end

    if R.IsReady() and ValidTarget(unit, Q.Range()) then
        DelayAction(function(unit, time) self:ForceInsec(unit, time) end, 0.1)
    end
end

function AutoR:OnProcessSpell(unit, spell)
    if self.Menu == nil or spell == nil or unit == nil or myHero.dead then return end
    if not unit.isMe then
        if unit.type == myHero.type and unit.team ~= myHero.team and GetDistanceSqr(myHero, unit) < Q.Range() * Q.Range() then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if self.Menu.AutoR[unit.charName..spelltype] then 
                    self:ForceInsec(unit, os.clock())
                end
            end
        end
    end
end

class "Ally"
function Ally:__init()

end

function Ally:NearTo(pos, rad)
    local radius = rad~= nil and rad or 200
    local bestAlly = nil
    for idx, champion in ipairs(GetAllyHeroes()) do
        if champion.valid and champion.visible and GetDistanceSqr(myHero, champion) < (W.Range() + W.ExtraRange) * (W.Range() + W.ExtraRange) then
            if bestAlly == nil then bestAlly = champion
            elseif GetDistanceSqr(pos, bestAlly) > GetDistanceSqr(pos, champion) then bestAlly = champion end
        end
    end
    if GetDistanceSqr(pos, bestAlly) < radius * radius then
        return bestAlly
    else return nil end
end

function Ally:FarTo(pos)
    local bestAlly = nil
    for idx, champion in ipairs(GetAllyHeroes()) do
        if champion.valid and champion.visible and GetDistanceSqr(myHero, champion) < (W.Range() + W.ExtraRange) * (W.Range() + W.ExtraRange) then
            if bestAlly == nil then bestAlly = champion
            elseif GetDistanceSqr(pos, bestAlly) < GetDistanceSqr(pos, champion) then bestAlly = champion end
        end
    end
    return bestAlly
end

class "Minion"
function Minion:__init()
    self.AllyMinions = minionManager(MINION_ALLY, W.Range() + W.ExtraRange, myHero, MINION_SORT_HEALTH_ASC)
end

function Minion:NearTo(pos, rad)
    local radius = rad~= nil and rad or 200
    self.AllyMinions:update()
    local bestMinion = nil
    for i, minion in pairs(self.AllyMinions.objects) do
        if bestMinion == nil then bestMinion = minion
        elseif GetDistanceSqr(pos, bestMinion) > GetDistanceSqr(pos, minion) then bestMinion = minion end
    end
    if GetDistanceSqr(pos, bestMinion) < radius * radius then
        return bestMinion
    else return nil end
end

function Minion:FarTo(pos)
    self.AllyMinions:update()
    local bestMinion = nil
    for i, minion in pairs(self.AllyMinions.objects) do
        if bestMinion == nil then bestMinion = minion
        elseif GetDistanceSqr(pos, bestMinion) < GetDistanceSqr(pos, minion) then bestMinion = minion end
    end
    return bestMinion
end


class "Ward"

function Ward:__init()
    self.Wards = {
        Wriggle         = { Range = 600, Slot = function() return GetSlot(3154) end, IsReady = function() return (GetSlot(3154) ~= nil and myHero:CanUseSpell(GetSlot(3154)) == READY) end },
        TrinketTotem1   = { Range = 600, Slot = function() return GetSlot(3340) end, IsReady = function() return (GetSlot(3340) ~= nil and myHero:CanUseSpell(GetSlot(3340)) == READY) end },
        TrinketTotem2   = { Range = 600, Slot = function() return GetSlot(3350) end, IsReady = function() return (GetSlot(3350) ~= nil and myHero:CanUseSpell(GetSlot(3350)) == READY) end },
        Ruby_SightStone = { Range = 600, Slot = function() return GetSlot(2045) end, IsReady = function() return (GetSlot(2045) ~= nil and myHero:CanUseSpell(GetSlot(2045)) == READY) end },
        SightStone      = { Range = 600, Slot = function() return GetSlot(2049) end, IsReady = function() return (GetSlot(2049) ~= nil and myHero:CanUseSpell(GetSlot(2049)) == READY) end },
        TrinketTotem3   = { Range = 600, Slot = function() return GetSlot(3361) end, IsReady = function() return (GetSlot(3361) ~= nil and myHero:CanUseSpell(GetSlot(3361)) == READY) end },
        TrinketTotem4   = { Range = 600, Slot = function() return GetSlot(3362) end, IsReady = function() return (GetSlot(3362) ~= nil and myHero:CanUseSpell(GetSlot(3362)) == READY) end },
        TrinketTotem5   = { Range = 600, Slot = function() return GetSlot(3166) end, IsReady = function() return (GetSlot(3166) ~= nil and myHero:CanUseSpell(GetSlot(3166)) == READY) end },
        Stealth         = { Range = 600, Slot = function() return GetSlot(2044) end, IsReady = function() return (GetSlot(2044) ~= nil and myHero:CanUseSpell(GetSlot(2044)) == READY) end },
        Vision          = { Range = 600, Slot = function() return GetSlot(2043) end, IsReady = function() return (GetSlot(2043) ~= nil and myHero:CanUseSpell(GetSlot(2043)) == READY) end },
    }
    self.WardsAvailable = {}
    for i = 1, objManager.maxObjects, 1 do
        local obj = objManager:GetObject(i)
        if obj ~= nil and obj.valid and obj.team == myHero.team and (obj.name:lower():find("sightward") or obj.name:lower():find("visionward")) then 
            table.insert(self.WardsAvailable, 1, obj) 
        end
    end
    self.lastTimeWard = 0
    AddCreateObjCallback(function(obj) self:OnCreateObj(obj) end)
    AddDeleteObjCallback(function(obj) self:OnDeleteObj(obj) end)
end

function Ward:GetWardAvailable()
    for name, ward in pairs(self.Wards) do
        if ward.IsReady() then
            return ward
        end
    end
    return nil
end

function Ward:IsReady()
    return self:GetWardAvailable()~=nil
end

function Ward:Cast(pos)
    local wardPlaced = self:NearTo(pos)
    if W.IsReady() and W.State() == 1 and wardPlaced == nil and os.clock() - self.lastTimeWard > 1 then
        local finalPos = myHero + Vector(pos.x - myHero.x, 0,  pos.z - myHero.z):normalized() * math.min(600, GetDistance(myHero, pos))
        local item = self:GetWardAvailable()
        --self.lastTimeWard = os.clock()
        if item~=nil and item.IsReady() then
            CastSpell(item.Slot(), finalPos.x, finalPos.z)
        end
    end
end

function Ward:NearTo(pos, rad)
    local radius = rad~= nil and rad or 200
    local bestWard = nil
    if #self.WardsAvailable > 0 then
        for i = 1, #self.WardsAvailable, 1 do
            local ward = self.WardsAvailable[i]
            if ward ~= nil and ward.valid and GetDistanceSqr(myHero, ward) < (W.Range() + W.ExtraRange) * (W.Range() + W.ExtraRange) then 
                if bestWard == nil then bestWard = ward 
                elseif GetDistanceSqr(pos, bestWard) > GetDistanceSqr(pos, ward) then bestWard = ward
                end
            end
        end
    end
    if GetDistanceSqr(pos, bestWard) < radius * radius then
        return bestWard
    else return nil end
end

function Ward:FarTo(pos)
    local bestWard = nil
    if #self.WardsAvailable > 0 then
        for i = 1, #self.WardsAvailable, 1 do
            local ward = self.WardsAvailable[i]
            if ward ~= nil and ward.valid and GetDistanceSqr(myHero, ward) < (W.Range() + W.ExtraRange) * (W.Range() + W.ExtraRange) then 
                if bestWard == nil then bestWard = ward 
                elseif GetDistanceSqr(pos, bestWard) < GetDistanceSqr(pos, ward) then bestWard = ward end
            end
        end
    end
    return bestWard
end


function Ward:Jump(pos)
    if W.IsReady() and W.State() == 1 then
        local finalPos = myHero + Vector(pos.x - myHero.x, 0,  pos.z - myHero.z):normalized() * math.min(600, GetDistance(myHero, pos))
        local ward = self:NearTo(finalPos)
        if ward ~= nil and ward.valid  then
            CastW1(ward)
        end
    end
    if W.IsReady() and W.State() == 1 then
        DelayAction(function(pos) self:Jump(pos) end, 0.1, {pos})
    end
end

function Ward:OnCreateObj(obj)
    if obj == nil then return end
    if obj.type:lower():find("obj_ai_minion") and obj.team == myHero.team then
        if obj.name:lower():find("sightward") or obj.name:lower():find("visionward") then
            self.lastTimeWard = os.clock()
            table.insert(self.WardsAvailable, 1, obj)
        end
    end
end

function Ward:OnDeleteObj(obj)
    if obj == nil then return end
    if obj.type:lower():find("obj_ai_minion") and obj.team == myHero.team then
        if obj.name:lower():find("sightward") or obj.name:lower():find("visionward") then
            if #self.WardsAvailable > 0 then
                for i = 1, #self.WardsAvailable, 1 do
                    local ward = self.WardsAvailable[i]
                    if ward ~= nil and ward.valid and GetDistanceSqr(ward, obj) < 10 * 10 then 
                        table.remove(self.WardsAvailable, i) 
                        break 
                    end
                end
            end
        end
    end
end


class "Prediction"
function Prediction:__init()
    if FileExist(LIB_PATH.."VPrediction.lua") then VP = VPrediction() table.insert(PredictionTable, "VPrediction") end
    --if VIP_USER and FileExist(LIB_PATH.."Prodiction.lua") then require "Prodiction" table.insert(PredictionTable, "Prodiction") end 
    if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then require "DivinePred" DP = DivinePred() table.insert(PredictionTable, "DivinePred") end
    if FileExist(LIB_PATH.."HPrediction.lua") then require "HPrediction" HP = HPrediction() table.insert(PredictionTable, "HPrediction") end
    self.delay = 0.07
    self.LastRequest = 0
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
end

function Prediction:ValidRequest()
    if os.clock() - self.LastRequest < self:TimeRequest() then
        return false
    else
        self.LastRequest = os.clock()
        return true
    end
end

function Prediction:GetPredictionType()
    local int = Config.Misc.predictionType or 1
    return PredictionTable[int] ~= nil and tostring(PredictionTable[int]) or "VPrediction"
end


function Prediction:TimeRequest()
    if self:GetPredictionType() == "VPrediction" then
        return 0.001
    elseif self:GetPredictionType() == "Prodiction" then
        return 0.001
    elseif self:GetPredictionType() == "DivinePred" then
        return Config.Misc.ExtraTime or 0.2
    elseif self:GetPredictionType() == "HPrediction" then
        return 0.001
    end
end

function Prediction:GetPrediction(target, delay, width, range, speed, source, skillshotType, collision, aoe)
    if ValidTarget(target) and self:ValidRequest() then
        local skillshotType = skillshotType or "circular"
        local aoe = aoe or false
        local collision = collision or false
        local source = source~=nil and source or myHero
        -- VPrediction
        if self:GetPredictionType() == "VPrediction" or not target.type:lower():find("hero") then
            if skillshotType == "linear" then
                if aoe then
                    return VP:GetLineAOECastPosition(target, delay, width, range, speed, source)
                else
                    return VP:GetLineCastPosition(target, delay, width, range, speed, source, collision)
                end
            elseif skillshotType == "circular" then
                if aoe then
                    return VP:GetCircularAOECastPosition(target, delay, width, range, speed, source)
                else
                    return VP:GetCircularCastPosition(target, delay, width, range, speed, source, collision)
                end
             elseif skillshotType == "cone" then
                if aoe then
                    return VP:GetConeAOECastPosition(target, delay, width, range, speed, source)
                else
                    return VP:GetLineCastPosition(target, delay, width, range, speed, source, collision)
                end
            end
        -- Prodiction
        elseif self:GetPredictionType() == "Prodiction" then
            local aoe = false -- temp fix for prodiction
            if aoe then
                if skillshotType == "linear" then
                    local pos, info, objects = Prodiction.GetLineAOEPrediction(target, range, speed, delay, width, source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                elseif skillshotType == "circular" then
                    local pos, info, objects = Prodiction.GetCircularAOEPrediction(target, range, speed, delay, width, source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                 elseif skillshotType == "cone" then
                    local pos, info, objects = Prodiction.GetConeAOEPrediction(target, range, speed, delay, width, source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                end
            else
                local pos, info = Prodiction.GetPrediction(target, range, speed, delay, width, source)
                local hitChance = collision and info.mCollision() and -1 or info.hitchance
                return pos, hitChance, info.pos
            end
        elseif self:GetPredictionType() == "DivinePred" then
            local asd = nil
            local col = collision and 0 or math.huge
            if skillshotType == "linear" then
                asd = LineSS(speed, range, width, delay * 1000, col)
            elseif skillshotType == "circular" then
                asd = CircleSS(speed, range, width, delay * 1000, col)
            elseif skillshotType == "cone" then
                asd = ConeSS(speed, range, width, delay * 1000, col)
            end
            local state, pos, perc = nil, Vector(target), nil
            if asd~=nil then
                local unit = DPTarget(target)
                local i = 0
                --for i = 0, 1, 1 do
                    local hitchance = 2 - i
                    state, pos, perc = DP:predict(unit, asd, 1.2)
                    if state == SkillShot.STATUS.SUCCESS_HIT then 
                        return pos, hitchance, perc
                    end
                --end
            end

            return pos, -1, aoe and 1 or pos
        elseif self:GetPredictionType() == "HPrediction" then
            local tipo = ""
            if skillshotType == "linear" then
                width = 2*width
                if speed ~= math.huge then 
                    tipo = "DelayLine"
                else
                    tipo = "PromptLine"
                end
            elseif skillshotType == "circular" then
                if speed ~= math.huge then 
                    tipo = "DelayCircle"
                else
                    tipo = "PromptCircle"
                end
            elseif skillshotType == "cone" then
                tipo = "DelayLine"
            end
            HP:AddSpell("Q", myHero.charName, {collisionM = collision, collisionH = collision, delay = delay, range = range, speed = speed, type = tipo, radius = width})
            local pos, hitchance = HP:GetPredict("Q", target, myHero)
            return pos, hitchance, pos
        end
    end
    return Vector(target), -1, Vector(target)
end

function Prediction:GetPredictedPos(unit, delay, speed, from, collision)
    if self:GetPredictionType() == "Prodiction" then 
        return Prodiction.GetPredictionTime(unit, delay)
    else
        return VP:GetPredictedPos(unit, delay, speed, from, collision)

    end
end

class "Damage"
function Damage:__init()
    --q, w, e , r, dmg, clock
    self.PredictedDamage = {}
    self.RefreshTime = 0.3
end

function Damage:Smite()
    if not Smite.IsReady() then return 0 end
    return math.max(20 * myHero.level + 370, 30 * myHero.level + 330, 40 * myHero.level + 240, 50 * myHero.level + 100)
end

function Damage:getBestCombo(target)
    if not ValidTarget(target) then return false, false, false, false, 0 end
    local q = {false}
    local w = {false}
    local e = {false}
    local r = {false}
    local damagetable = self.PredictedDamage[target.networkID]
    if damagetable ~= nil then
        local time = damagetable[6]
        if os.clock() - time <= self.RefreshTime  then 
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5] 
        else
            if Q.IsReady() then q = {false, true} end
            if W.IsReady() then w = {false, true} end
            if E.IsReady() then e = {false, true} end
            if R.IsReady() then r = {false, true} end
            local bestdmg = 0
            local best = {false, false, false, false}
            local dmg, mana = self:getComboDamage(target, Q.IsReady(), W.IsReady(), E.IsReady(), R.IsReady())
            if dmg > target.health then
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = self:getComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d > target.health and myHero.mana > m then 
                                    if bestdmg == 0 then bestdmg = d best = {q[qCount], w[wCount], e[eCount], r[rCount]}
                                    elseif d < bestdmg then bestdmg = d best = {q[qCount], w[wCount], e[eCount], r[rCount]} end
                                end
                            end
                        end
                    end
                end
                --return best[1], best[2], best[3], best[4], bestdmg
                damagetable[1] = best[1]
                damagetable[2] = best[2]
                damagetable[3] = best[3]
                damagetable[4] = best[4]
                damagetable[5] = bestdmg
                damagetable[6] = os.clock()
            else
                local table2 = {false,false,false,false}
                local bestdmg, mana = self:getComboDamage(target, false, false, false, false)
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = self:getComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d > bestdmg and myHero.mana > m then 
                                    table2 = {q[qCount],w[wCount],e[eCount],r[rCount]}
                                    bestdmg = d
                                end
                            end
                        end
                    end
                end
                --return table2[1],table2[2],table2[3],table2[4], bestdmg
                damagetable[1] = table2[1]
                damagetable[2] = table2[2]
                damagetable[3] = table2[3]
                damagetable[4] = table2[4]
                damagetable[5] = bestdmg
                damagetable[6] = os.clock()
            end
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5]
        end
    else
        self.PredictedDamage[target.networkID] = {false, false, false, false, 0, os.clock() - self.RefreshTime * 2}
        return self:getBestCombo(target)
    end
end

function Damage:getComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if target ~= nil and target.valid then
        if q then
            comboDamage = comboDamage + Q.Damage(target)
            currentManaWasted = currentManaWasted + Q.Mana()
        end
        --if w then
            --comboDamage = comboDamage + W.Damage(target)
            --currentManaWasted = currentManaWasted + W.Mana()
        --end
        if e then
            if E.State() == 1 then comboDamage = comboDamage + E.Damage(target) end
            currentManaWasted = currentManaWasted + E.Mana()
        end
        if r then
            comboDamage = comboDamage + R.Damage(target)
            currentManaWasted = currentManaWasted + R.Mana()
        end
        comboDamage = comboDamage + AA.Damage(target) * 2
        if Ignite.IsReady() then comboDamage = comboDamage + Ignite.Damage(target) end
    end
    comboDamage = comboDamage * self:getOverkill()
    return comboDamage, currentManaWasted
end

function Damage:getDamageToMinion(minion)
    return VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0)
end

function Damage:getOverkill()
    return (100 + Config.Misc.overkill)/100
end



class("Draw")
function Draw:__init()
    self.Menu = nil
end
function Draw:LoadMenu(menu)
    self.Menu = menu
    self.Menu:addSubMenu("Q", "Q")
    self.Menu.Q:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Q:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.Q:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("W", "W")
    self.Menu.W:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.W:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.W:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("E", "E")
    self.Menu.E:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.E:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.E:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("R", "R")
    self.Menu.R:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.R:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.R:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addParam("dmgCalc","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Target","Red Circle on Target", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Quality", "Quality of Circles", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
    AddDrawCallback(function() self:OnDraw() end)
end

function Draw:OnDraw()
    if myHero.dead or self.Menu == nil or not scriptLoaded then return end
    if self.Menu.dmgCalc then self:DrawPredictedDamage() end
    if self.Menu.Target and ts.target ~= nil and ValidTarget(ts.target) then
        self:DrawCircle2(ts.target.x, ts.target.y, ts.target.z, VP:GetHitBox(ts.target)*1.5, Colors.Red, 3)
    end

    if self.Menu.Q.Range and Q.IsReady() then
        local color = self.Menu.Q.Color
        local width = self.Menu.Q.Width
        local range =           Q.Range()
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.W.Range and W.IsReady() then
        local color = self.Menu.W.Color
        local width = self.Menu.W.Width
        local range =           W.Range()
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.E.Range and E.IsReady() then
        local color = self.Menu.E.Color
        local width = self.Menu.E.Width
        local range =           E.Range()
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.R.Range and R.IsReady() then
        local color = self.Menu.R.Color
        local width = self.Menu.R.Width
        local range =           R.Range()
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if JungleText ~= "" then
        local string = JungleText
        local color = JungleText:lower():find("not") and Colors.Red or Colors.Green
        DrawText(JungleText, 35, 100, 50, color)
    end
end

function Draw:DrawPredictedDamage() 
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
        if ValidTarget(enemy) and enemy.visible and OnScreen(p.x, p.y) then
           local q,w,e,r, dmg = damage:getBestCombo(enemy)
            if dmg >= enemy.health then
                self:DrawLineHPBar(dmg, "KILLABLE", enemy, true)
            else
                local spells = ""
                if q then spells = "Q" end
                if w then spells = spells .. "W" end
                if e then spells = spells .. "E" end
                if r then spells = spells .. "R" end
                self:DrawLineHPBar(dmg, spells, enemy, true)
            end
        end
    end
end


function Draw:GetHPBarPos(enemy)
    enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local BarPosOffsetX = -50
    local BarPosOffsetY = 46
    local CorrectionY = 39
    local StartHpPos = 31 
    barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
    barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
    local StartPos = Vector(barPos.x , barPos.y, 0)
    local EndPos = Vector(barPos.x + 108 , barPos.y , 0)    
    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function Draw:DrawLineHPBar(damage, text, unit, enemyteam)
    if unit.dead or not unit.visible then return end
    local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
    if not OnScreen(p.x, p.y) then return end
    local thedmg = 0
    local line = 2
    local linePosA  = {x = 0, y = 0 }
    local linePosB  = {x = 0, y = 0 }
    local TextPos   = {x = 0, y = 0 }
    
    
    if damage >= unit.maxHealth then
        thedmg = unit.maxHealth - 1
    else
        thedmg = damage
    end
    
    thedmg = math.round(thedmg)
    
    local StartPos, EndPos = self:GetHPBarPos(unit)
    local Real_X = StartPos.x + 24
    local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
    if Offs_X < Real_X then Offs_X = Real_X end 
    local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth))
    if mytrans >= 255 then mytrans=254 end
    local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
    if my_bluepart >= 255 then my_bluepart=254 end

    
    if enemyteam then
        linePosA.x = Offs_X-150
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-150
        linePosB.y = (StartPos.y-10)
        TextPos.x = Offs_X-148
        TextPos.y = (StartPos.y-(30+(line*15)))
    else
        linePosA.x = Offs_X-125
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-125
        linePosB.y = (StartPos.y-15)
    
        TextPos.x = Offs_X-122
        TextPos.y = (StartPos.y-(30+(line*15)))
    end

    DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255, my_bluepart, 0))
    DrawText(tostring(thedmg).." "..tostring(text), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
end

-- Barasia, vadash, viceversa
function Draw:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
  quality = math.max(8,self:round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end
function Draw:round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function Draw:DrawCircle2(x, y, z, radius, color, width)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        self:DrawCircleNextLvl(x, y, z, radius, width, color, 75 + 2000 * (100 - self.Menu.Quality)/100) 
    end
end


class "_Required"
function _Required:__init()
    self.requirements = {}
    self.downloading = {}
    return self
end

function _Required:Add(name, ext, url, UseHttps)
    --self.requirements[name] = url
    table.insert(self.requirements, {name, ext, url, UseHttps})
end

function _Required:Check()
    for i, tab in pairs(self.requirements) do
        local name, ext, url, UseHttps = tab[1], tab[2], tab[3], tab[4]
        if FileExist(LIB_PATH..name.."."..ext) then
            --require(name)
        else
            PrintMessage("Downloading ".. name.. ". Please wait...")
            local d = _Downloader(LIB_PATH..name.."."..ext, url, UseHttps)
            table.insert(self.downloading, d)
        end
    end
    
    if #self.downloading > 0 then
        for i = 1, #self.downloading, 1 do 
            local d = self.downloading[i]
            AddTickCallback(function() d:Download() end)
        end
        self:CheckDownloads()
    else
        for i, tab in pairs(self.requirements) do
            local name, ext, url, UseHttps = tab[1], tab[2], tab[3], tab[4]
            if FileExist(LIB_PATH..name.."."..ext) and ext == "lua" then
                require(name)
            end
        end
    end
end

function _Required:CheckDownloads()
    if #self.downloading == 0 then 
        PrintMessage("Required libraries downloaded. Please reload with 2x F9.")
    else
        for i = 1, #self.downloading, 1 do
            local d = self.downloading[i]
            if d.GotScriptUpdate then
                table.remove(self.downloading, i)
                break
            end
        end
        DelayAction(function() self:CheckDownloads() end, 2) 
    end 
end

function _Required:IsDownloading()
    return self.downloading ~= nil and #self.downloading > 0 or false
end

class "_Downloader"
function _Downloader:__init(path, url, UseHttps)
    self.SavePath = path
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(url)..'&rand='..math.random(99999999)
    self:CreateSocket(self.ScriptPath)
    self.DownloadStatus = 'Connect to Server'
end

function _Downloader:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.Socket = self.LuaSocket.tcp()
    if not self.Socket then
        print('Socket Error')
    else
        self.Socket:settimeout(0, 'b')
        self.Socket:settimeout(99999999, 't')
        self.Socket:connect('sx-bol.eu', 80)
        self.Url = url
        self.Started = false
        self.LastPrint = ""
        self.File = ""
    end
end

function _Downloader:Download()
    if self.GotScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                end
            end
        end
        self.GotScriptUpdate = true
    end
end

function _Downloader:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

class "_ScriptUpdate"
function _ScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.CallbackError = CallbackError
    --AddDrawCallback(function() self:OnDraw() end)
    self:CreateSocket(self.VersionPath)
    self.DownloadStatus = 'Connect to Server for VersionInfo'
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function _ScriptUpdate:print(str)
    print('<font color="#FFFFFF">'..os.clock()..': '..str)
end

function _ScriptUpdate:OnDraw()
    if self.DownloadStatus ~= 'Downloading Script (100%)' then
    end
end

function _ScriptUpdate:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.Socket = self.LuaSocket.tcp()
    if not self.Socket then
        print('Socket Error')
    else
        self.Socket:settimeout(0, 'b')
        self.Socket:settimeout(99999999, 't')
        self.Socket:connect('sx-bol.eu', 80)
        self.Url = url
        self.Started = false
        self.LastPrint = ""
        self.File = ""
    end
end

function _ScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function _ScriptUpdate:GetOnlineVersion()
    if self.GotScriptVersion then return end

    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading VersionInfo (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</s'..'ize>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading VersionInfo ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading VersionInfo (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
        local ContentEnd, _ = self.File:find('</sc'..'ript>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            self.OnlineVersion = (Base64Decode(self.File:sub(ContentStart + 1,ContentEnd-1)))
            self.OnlineVersion = tonumber(self.OnlineVersion)
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self:CreateSocket(self.ScriptPath)
                self.DownloadStatus = 'Connect to Server for ScriptDownload'
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        end
        self.GotScriptVersion = true
    end
end

function _ScriptUpdate:DownloadUpdate()
    if self.GotScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                end
            end
        end
        self.GotScriptUpdate = true
    end
end
--CREDIT TO EXTRAGOZ
local spellsFile = LIB_PATH.."missedspells.txt"
local spellslist = {}
local textlist = ""
local spellexists = false
local spelltype = "Unknown"
 
function writeConfigsspells()
        local file = io.open(spellsFile, "w")
        if file then
                textlist = "return {"
                for i=1,#spellslist do
                        textlist = textlist.."'"..spellslist[i].."', "
                end
                textlist = textlist.."}"
                if spellslist[1] ~=nil then
                        file:write(textlist)
                        file:close()
                end
        end
end
if FileExist(spellsFile) then spellslist = dofile(spellsFile) end
 
local Others = {"Recall","recall","OdinCaptureChannel","LanternWAlly","varusemissiledummy","khazixqevo","khazixwevo","khazixeevo","khazixrevo","braumedummyvoezreal","braumedummyvonami","braumedummyvocaitlyn","braumedummyvoriven","braumedummyvodraven","braumedummyvoashe","azirdummyspell"}
local Items = {"RegenerationPotion","FlaskOfCrystalWater","ItemCrystalFlask","ItemMiniRegenPotion","PotionOfBrilliance","PotionOfElusiveness","PotionOfGiantStrength","OracleElixirSight","OracleExtractSight","VisionWard","SightWard","sightward","ItemGhostWard","ItemMiniWard","ElixirOfRage","ElixirOfIllumination","wrigglelantern","DeathfireGrasp","HextechGunblade","shurelyascrest","IronStylus","ZhonyasHourglass","YoumusBlade","randuinsomen","RanduinsOmen","Mourning","OdinEntropicClaymore","BilgewaterCutlass","QuicksilverSash","HextechSweeper","ItemGlacialSpike","ItemMercurial","ItemWraithCollar","ItemSoTD","ItemMorellosBane","ItemPromote","ItemTiamatCleave","Muramana","ItemSeraphsEmbrace","ItemSwordOfFeastAndFamine","ItemFaithShaker","OdynsVeil","ItemHorn","ItemPoroSnack","ItemBlackfireTorch","HealthBomb","ItemDervishBlade","TrinketTotemLvl1","TrinketTotemLvl2","TrinketTotemLvl3","TrinketTotemLvl3B","TrinketSweeperLvl1","TrinketSweeperLvl2","TrinketSweeperLvl3","TrinketOrbLvl1","TrinketOrbLvl2","TrinketOrbLvl3","OdinTrinketRevive","RelicMinorSpotter","RelicSpotter","RelicGreaterLantern","RelicLantern","RelicSmallLantern","ItemFeralFlare","trinketorblvl2","trinketsweeperlvl2","trinkettotemlvl2","SpiritLantern","RelicGreaterSpotter"}
local MSpells = {"JayceStaticField","JayceToTheSkies","JayceThunderingBlow","Takedown","Pounce","Swipe","EliseSpiderQCast","EliseSpiderW","EliseSpiderEInitial","elisespidere","elisespideredescent","gnarbigq","gnarbigw","gnarbige","GnarBigQMissile"}
local PSpells = {"CaitlynHeadshotMissile","RumbleOverheatAttack","JarvanIVMartialCadenceAttack","ShenKiAttack","MasterYiDoubleStrike","sonaqattackupgrade","sonawattackupgrade","sonaeattackupgrade","NocturneUmbraBladesAttack","NautilusRavageStrikeAttack","ZiggsPassiveAttack","QuinnWEnhanced","LucianPassiveAttack","SkarnerPassiveAttack","KarthusDeathDefiedBuff","AzirTowerClick","azirtowerclick","azirtowerclickchannel"}
 
local QSpells = {"TrundleQ","LeonaShieldOfDaybreakAttack","XenZhaoThrust","NautilusAnchorDragMissile","RocketGrabMissile","VayneTumbleAttack","VayneTumbleUltAttack","NidaleeTakedownAttack","ShyvanaDoubleAttackHit","ShyvanaDoubleAttackHitDragon","frostarrow","FrostArrow","MonkeyKingQAttack","MaokaiTrunkLineMissile","FlashFrostSpell","xeratharcanopulsedamage","xeratharcanopulsedamageextended","xeratharcanopulsedarkiron","xeratharcanopulsediextended","SpiralBladeMissile","EzrealMysticShotMissile","EzrealMysticShotPulseMissile","jayceshockblast","BrandBlazeMissile","UdyrTigerAttack","TalonNoxianDiplomacyAttack","LuluQMissile","GarenSlash2","VolibearQAttack","dravenspinningattack","karmaheavenlywavec","ZiggsQSpell","UrgotHeatseekingHomeMissile","UrgotHeatseekingLineMissile","JavelinToss","RivenTriCleave","namiqmissile","NasusQAttack","BlindMonkQOne","ThreshQInternal","threshqinternal","QuinnQMissile","LissandraQMissile","EliseHumanQ","GarenQAttack","JinxQAttack","JinxQAttack2","yasuoq","xeratharcanopulse2","VelkozQMissile","KogMawQMis","BraumQMissile","KarthusLayWasteA1","KarthusLayWasteA2","KarthusLayWasteA3","karthuslaywastea3","karthuslaywastea2","karthuslaywastedeada1","MaokaiSapling2Boom","gnarqmissile","GnarBigQMissile","viktorqbuff"}
local WSpells = {"KogMawBioArcaneBarrageAttack","SivirWAttack","TwitchVenomCaskMissile","gravessmokegrenadeboom","mordekaisercreepingdeath","DrainChannel","jaycehypercharge","redcardpreattack","goldcardpreattack","bluecardpreattack","RenektonExecute","RenektonSuperExecute","EzrealEssenceFluxMissile","DariusNoxianTacticsONHAttack","UdyrTurtleAttack","talonrakemissileone","LuluWTwo","ObduracyAttack","KennenMegaProc","NautilusWideswingAttack","NautilusBackswingAttack","XerathLocusOfPower","yoricksummondecayed","Bushwhack","karmaspiritbondc","SejuaniBasicAttackW","AatroxWONHAttackLife","AatroxWONHAttackPower","JinxWMissile","GragasWAttack","braumwdummyspell","syndrawcast","SorakaWParticleMissile"}
local ESpells = {"KogMawVoidOozeMissile","ToxicShotAttack","LeonaZenithBladeMissile","PowerFistAttack","VayneCondemnMissile","ShyvanaFireballMissile","maokaisapling2boom","VarusEMissile","CaitlynEntrapmentMissile","jayceaccelerationgate","syndrae5","JudicatorRighteousFuryAttack","UdyrBearAttack","RumbleGrenadeMissile","Slash","hecarimrampattack","ziggse2","UrgotPlasmaGrenadeBoom","SkarnerFractureMissile","YorickSummonRavenous","BlindMonkEOne","EliseHumanE","PrimalSurge","Swipe","ViEAttack","LissandraEMissile","yasuodummyspell","XerathMageSpearMissile","RengarEFinal","RengarEFinalMAX","KarthusDefileSoundDummy2"}
local RSpells = {"Pantheon_GrandSkyfall_Fall","LuxMaliceCannonMis","infiniteduresschannel","JarvanIVCataclysmAttack","jarvanivcataclysmattack","VayneUltAttack","RumbleCarpetBombDummy","ShyvanaTransformLeap","jaycepassiverangedattack", "jaycepassivemeleeattack","jaycestancegth","MissileBarrageMissile","SprayandPrayAttack","jaxrelentlessattack","syndrarcasttime","InfernalGuardian","UdyrPhoenixAttack","FioraDanceStrike","xeratharcanebarragedi","NamiRMissile","HallucinateFull","QuinnRFinale","lissandrarenemy","SejuaniGlacialPrisonCast","yasuordummyspell","xerathlocuspulse","tempyasuormissile","PantheonRFall"}
 
local casttype2 = {"blindmonkqtwo","blindmonkwtwo","blindmonketwo","infernalguardianguide","KennenMegaProc","sonawattackupgrade","redcardpreattack","fizzjumptwo","fizzjumpbuffer","gragasbarrelrolltoggle","LeblancSlideM","luxlightstriketoggle","UrgotHeatseekingHomeMissile","xeratharcanopulseextended","xeratharcanopulsedamageextended","XenZhaoThrust3","ziggswtoggle","khazixwlong","khazixelong","renektondice","SejuaniNorthernWinds","shyvanafireballdragon2","shyvanaimmolatedragon","ShyvanaDoubleAttackHitDragon","talonshadowassaulttoggle","viktorchaosstormguide","zedw2","ZedR2","khazixqlong","AatroxWONHAttackLife","viktorqbuff"}
local casttype3 = {"sonaeattackupgrade","bluecardpreattack","LeblancSoulShackleM","UdyrPhoenixStance","RenektonSuperExecute"}
local casttype4 = {"FrostShot","PowerFist","DariusNoxianTacticsONH","EliseR","JaxEmpowerTwo","JaxRelentlessAssault","JayceStanceHtG","jaycestancegth","jaycehypercharge","JudicatorRighteousFury","kennenlrcancel","KogMawBioArcaneBarrage","LissandraE","MordekaiserMaceOfSpades","mordekaisercotgguide","NasusQ","Takedown","NocturneParanoia","QuinnR","RengarQ","HallucinateFull","DeathsCaressFull","SivirW","ThreshQInternal","threshqinternal","PickACard","goldcardlock","redcardlock","bluecardlock","FullAutomatic","VayneTumble","MonkeyKingDoubleAttack","YorickSpectral","ViE","VorpalSpikes","FizzSeastonePassive","GarenSlash3","HecarimRamp","leblancslidereturn","leblancslidereturnm","Obduracy","UdyrTigerStance","UdyrTurtleStance","UdyrBearStance","UrgotHeatseekingMissile","XenZhaoComboTarget","dravenspinning","dravenrdoublecast","FioraDance","LeonaShieldOfDaybreak","MaokaiDrain3","NautilusPiercingGaze","RenektonPreExecute","RivenFengShuiEngine","ShyvanaDoubleAttack","shyvanadoubleattackdragon","SyndraW","TalonNoxianDiplomacy","TalonCutthroat","talonrakemissileone","TrundleTrollSmash","VolibearQ","AatroxW","aatroxw2","AatroxWONHAttackLife","JinxQ","GarenQ","yasuoq","XerathArcanopulseChargeUp","XerathLocusOfPower2","xerathlocuspulse","velkozqsplitactivate","NetherBlade","GragasQToggle","GragasW","SionW","sionpassivespeed"}
local casttype5 = {"VarusQ","ZacE","ViQ","SionQ"}
local casttype6 = {"VelkozQMissile","KogMawQMis","RengarEFinal","RengarEFinalMAX","BraumQMissile","KarthusDefileSoundDummy2","gnarqmissile","GnarBigQMissile","SorakaWParticleMissile"}
--,"PoppyDevastatingBlow"--,"Deceive" -- ,"EliseRSpider"
function getSpellType(unit, spellName)
        spelltype = "Unknown"
        casttype = 1
        if unit ~= nil and unit.type == "AIHeroClient" then
                if spellName == nil or unit:GetSpellData(_Q).name == nil or unit:GetSpellData(_W).name == nil or unit:GetSpellData(_E).name == nil or unit:GetSpellData(_R).name == nil then
                        return "Error name nil", casttype
                end
                if spellName:find("SionBasicAttackPassive") or spellName:find("zyrapassive") then
                        spelltype = "P"
                elseif (spellName:find("BasicAttack") and spellName ~= "SejuaniBasicAttackW") or spellName:find("basicattack") or spellName:find("JayceRangedAttack") or spellName == "SonaQAttack" or spellName == "SonaWAttack" or spellName == "SonaEAttack" or spellName == "ObduracyAttack" or spellName == "GnarBigAttackTower" then
                        spelltype = "BAttack"
                elseif spellName:find("CritAttack") or spellName:find("critattack") then
                        spelltype = "CAttack"
                elseif unit:GetSpellData(_Q).name:find(spellName) then
                        spelltype = "Q"
                elseif unit:GetSpellData(_W).name:find(spellName) then
                        spelltype = "W"
                elseif unit:GetSpellData(_E).name:find(spellName) then
                        spelltype = "E"
                elseif unit:GetSpellData(_R).name:find(spellName) then
                        spelltype = "R"
                elseif spellName:find("Summoner") or spellName:find("summoner") or spellName == "teleportcancel" then
                        spelltype = "Summoner"
                else
                        if spelltype == "Unknown" then
                                for i=1,#Others do
                                        if spellName:find(Others[i]) then
                                                spelltype = "Other"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#Items do
                                        if spellName:find(Items[i]) then
                                                spelltype = "Item"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#PSpells do
                                        if spellName:find(PSpells[i]) then
                                                spelltype = "P"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#QSpells do
                                        if spellName:find(QSpells[i]) then
                                                spelltype = "Q"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#WSpells do
                                        if spellName:find(WSpells[i]) then
                                                spelltype = "W"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#ESpells do
                                        if spellName:find(ESpells[i]) then
                                                spelltype = "E"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#RSpells do
                                        if spellName:find(RSpells[i]) then
                                                spelltype = "R"
                                        end
                                end
                        end
                end
                for i=1,#MSpells do
                        if spellName == MSpells[i] then
                                spelltype = spelltype.."M"
                        end
                end
                local spellexists = spelltype ~= "Unknown"
                if #spellslist > 0 and not spellexists then
                        for i=1,#spellslist do
                                if spellName == spellslist[i] then
                                        spellexists = true
                                end
                        end
                end
                if not spellexists then
                        table.insert(spellslist, spellName)
                        --writeConfigsspells()
                       -- PrintChat("Skill Detector - Unknown spell: "..spellName)
                end
        end
        for i=1,#casttype2 do
                if spellName == casttype2[i] then casttype = 2 end
        end
        for i=1,#casttype3 do
                if spellName == casttype3[i] then casttype = 3 end
        end
        for i=1,#casttype4 do
                if spellName == casttype4[i] then casttype = 4 end
        end
        for i=1,#casttype5 do
                if spellName == casttype5[i] then casttype = 5 end
        end
        for i=1,#casttype6 do
                if spellName == casttype6[i] then casttype = 6 end
        end
 
        return spelltype, casttype
end