
--[[
    
    AUTHOR iCreative
    COLLABORATIONS from
        Da Vinci
    Credits to:
    BuffManager writer
    lag free circles writers
    Sourcelib writer
]]

local AUTOUPDATE = true -- TURN THIS OFF IF YOU DON'T WANT AUTOUPDATES
local scriptname = "Mighty Riven"
local author = "iCreative"
local version = "2.004"
local champion = "Riven"

if myHero.charName:lower() ~= champion:lower() then return end
--Tracker from www.scriptstatus.net
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("VILJKNJQNPI") 

local igniteslot = nil
local flashslot = nil
local P = { Damage = function(target) return getDmg("P", target, myHero) end, Stacks = 0, LastCastTime = 0}
local R       = { Range = 1100, Radius = 200, Delay = 0.5, Speed = 2200, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Damage = function(target) return getDmg("R", target, myHero) end, State = false}
local AA      = { Range = function(target) 
local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end
return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end  , Damage = function(target) return getDmg("AD", target, myHero) end, LastCastTime = 0}
local Q       = { Range = 300, Radius = 250, Delay = 0.5, Speed = 0, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Damage = function(target) return getDmg("Q", target, myHero) end, State = 0}
local W       = { Range = 260, Radius = 250, Delay = 0.25, Speed = 1500, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Damage = function(target) return getDmg("W", target, myHero) end}
local E       = { Range = 325, Delay = 0, Speed = 1450, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Damage = function(target) return getDmg("E", target, myHero) end}
local Ignite  = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero) end}
local Flash   = { Range = 400, IsReady = function() return (flashslot ~= nil and myHero:CanUseSpell(flashslot) == READY) end}
local Tiamat      = { Range = 380, Slot = function() return GetInventorySlotItem(3077) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end}
local Hydra       = { Range = 380, Slot = function() return GetInventorySlotItem(3074) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end, Damage = function(target) return getDmg("HYDRA", target, myHero) end}
local Items = { 
Bork        = { Range = 450, Slot = function() return GetInventorySlotItem(3153) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
Bwc         = { Range = 400, Slot = function() return GetInventorySlotItem(3144) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
Hextech     = { Range = 400, Slot = function() return GetInventorySlotItem(3146) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
Blackfire   = { Range = 750, Slot = function() return GetInventorySlotItem(3188) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
Youmuu      = { Range = 350, Slot = function() return GetInventorySlotItem(3142) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
}
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}

local visionRange = 1800

local ScriptLoaded = false

local minionRange = 800

local autoQW = false

local Colors = { 
    -- O R G B
    Green =  ARGB(255, 0, 255, 0), 
    Yellow =  ARGB(255, 255, 255, 0),
    Red =  ARGB(255,255,0,0),
    White =  ARGB(255, 255, 255, 255),
    Blue =  ARGB(255,0,0,255),
}



require("VPrediction")
if VIP_USER then require("Prodiction") end


function CheckUpdate()
    local scriptName = "Mighty%20Riven"
    if AUTOUPDATE then
        SourceUpdater("Mighty Riven", version, "raw.github.com", "/jachicao/BoL/master/"..scriptName..".lua", SCRIPT_PATH .. _ENV.FILE_NAME, "/jachicao/BoL/master/version/"..scriptName..".version"):CheckUpdate()
    end
end

function PrintMessage(script, message) 
    print("<font color=\"#6699ff\"><b>" .. script .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") 
end
function OnLoad()
    CheckUpdate()
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then igniteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then igniteslot = SUMMONER_2
    end
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerflash") then flashslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerflash") then flashslot = SUMMONER_2
    end
    ts              = TargetSelector(TARGET_LESS_CAST_PRIORITY, R.Range ,DAMAGE_PHYSICAL)
    DelayAction(arrangePrioritys,5)
    VP              = VPrediction()
    damage          = Damage()
    BuffM           = BuffManager()
    iOrb            = iOrbwalker()
    DelayAction(OrbLoad, 2)
    prediction      = Prediction()
    Config          = scriptConfig(scriptname, scriptname.."1.3")
    AllyMinions     = minionManager(MINION_ALLY, minionRange, myHero, MINION_SORT_HEALTH_ASC)
    EnemyMinions    = minionManager(MINION_ENEMY, minionRange, myHero, MINION_SORT_HEALTH_ASC)
    JungleMinions   = minionManager(MINION_JUNGLE, minionRange, myHero, MINION_SORT_HEALTH_ASC)
    LoadMenu()
    modes           = Modes()
end



function OrbLoad()
    if _G.Reborn_Initialised then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "LastHit", AutoCarry.MODE_LASTHIT)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
        PrintMessage(scriptname, "To have a better experience turn off SAC:R")
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    else
        Config:addSubMenu(scriptname.." - Orbwalking Settings", "Orbwalking")
        iOrb:LoadMenu(Config.Orbwalking)
    end
end


function LoadMenu()

    
    Config:addTS(ts)

    Config:addSubMenu(scriptname.." - Combo Settings", "Combo")
        Config.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useR1","Use R1: ", SCRIPT_PARAM_LIST, 2, {"Never", "If Needed", "Always"})
        Config.Combo:addParam("useR2","Use R2: ", SCRIPT_PARAM_LIST, 2, {"Never", "If Killable", "Between Q2 - Q3'", "At Max Damage"})
        Config.Combo:addParam("useIgnite","Use Ignite: ", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable", "Always"})
        Config.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useTiamat", "Use Tiamat", SCRIPT_PARAM_LIST, 1, {"To Cancel Animation", "To Make Damage"})
        Config.Combo:addParam("Range", "Max Range to Combo", SCRIPT_PARAM_SLICE, 600, 150, 900, 0)


    Config:addSubMenu(scriptname.." - Harass Settings", "Harass")
        Config.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("harassMode","Harass Mode", SCRIPT_PARAM_LIST, 1, {"Typical", "Q1 Q2 W Q3 E"}) --, "E W Q1 Q2 Q3", "E Q1 W Q2 Q3"
        Config.Harass:addParam("useTiamat","Use Tiamat or Hydra", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("Range", "Max Range to Harass", SCRIPT_PARAM_SLICE, 350, 150, 600, 0)

    Config:addSubMenu(scriptname.." - LastHit Settings", "LastHit")
        Config.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - Clear Settings", "Clear")
        Config.Clear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.Clear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.Clear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        Config.Clear:addParam("useTiamat","Use Tiamat or Hydra", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - KillSteal Settings", "KillSteal")
        Config.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useR2","Use R2", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - Auto Settings", "Auto")
        Config.Auto:addParam("AutoW", "Auto W if Enemies >=", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
        Config.Auto:addParam("AutoEW", "Auto EW if Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        Config.Auto:addParam("AutoE", "Auto E to run if Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        Config.Auto:addParam("AutoERange", "Auto E Range", SCRIPT_PARAM_SLICE, 300, 120, 900, 0)


    Config:addSubMenu(scriptname.." - Misc Settings", "Misc")
        if VIP_USER then Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, { "vPrediction", "Prodiction"})
        else Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, { "vPrediction"}) end
        Config.Misc:addParam("useCancelAnimation","Use Cancel Animation", SCRIPT_PARAM_LIST, 2, {"Never", "mousePos", "Joke", "Taunt", "Dance", "Laugh"})
        Config.Misc:addParam("cancelR","Cancel R Animation", SCRIPT_PARAM_ONOFF, true)
        Config.Misc:addParam("humanizer", "Humanizer Delay (in seconds)", SCRIPT_PARAM_SLICE, 0, 0, 0.7, 1)
        Config.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        Config.Misc:addParam("bufferAA", "Delay for AA", SCRIPT_PARAM_SLICE, 0, -15, 20)
        Config.Misc:addParam("bufferQ", "Delay for Q Reset", SCRIPT_PARAM_LIST, 1, {"Normal Way","Test Way"})
        --Config.Misc:addParam("delayResetAA", "Delay Reset AA", SCRIPT_PARAM_SLICE, 0, -20, 30)
        Config.Misc:addParam("developer","Developer mode", SCRIPT_PARAM_ONOFF, false)
        Config.Misc:addParam("enemyTurret","Don't cast on enemy turret", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - Draw Settings", "Draw")
        draw = Draw()
        draw:LoadMenu(Config.Draw)

    Config:addSubMenu(scriptname.." - Key Settings", "Keys")
        Config.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("C")) 
        Config.Keys:addParam("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V")) 
        Config.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X")) 
        Config.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("T"))

    

        Config.Keys.Combo   = false
        Config.Keys.Harass  = false
        Config.Keys.Run     = false 
        Config.Keys.Clear   = false
        Config.Keys.LastHit = false

    PrintMessage(scriptname, "Script by "..author..".")
    PrintMessage(scriptname, "I've made iOrbwalker for this script, so i suggest not use any other orbwalker (Like SAC:R).")
    PrintMessage(scriptname, "If you are having troubles with QAA, go to Misc Settings and modify the value of Delay for AA.")
    ScriptLoaded = true
end


function setRange()
    local range = 0
    if Q.IsReady() then range = Q.Range*(3-Q.State) end
    --if R.IsReady() then range = R.Range end
    if E.IsReady() then range = range + E.Range end
    if range == 0 then range = range + 100 end
    range = range + AA.Range(ts.target)
    ts.range = range
end

function Checks()
    if os.clock() - R.LastCastTime < 15 and not R.LastCastTime == 0 then
        Q.Radius    = 400
        Q.Range     = 325
        W.Radius    = 270
        W.Range    = 270
    else
        Q.Radius    = 300
        Q.Range     = 225
        W.Radius    = 250
        W.Range    = 250
    end

    setRange()

    local aa = os.clock() - AA.LastCastTime
    local q = os.clock() - Q.LastCastTime
    local w = os.clock() - W.LastCastTime
    local e = os.clock() - E.LastCastTime
    local r = os.clock() - R.LastCastTime
    local min = math.min(q,w,e,r)
  
    if min > 5 then
        P.Stacks = 0
    end
    if ValidTarget(ts.target) and haveBuff(ts.target) then
        local nextTarget = nil
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if GetDistance(myHero, enemy) < ts.range and not haveBuff(enemy) then 
                if nextTarget == nil then nextTarget = enemy
                elseif getPriorityChampion(enemy) < getPriorityChampion(nextTarget) then nextTarget = enemy end
            end
        end
        ts.target = nextTarget
    end

end

function OnTick()
    if myHero.dead or not ScriptLoaded then return end
    ts.target = GetCustomTarget()
    local targetObj = GetTarget()
    if targetObj ~= nil then
        if targetObj.type:lower():find("hero") and targetObj.team ~= myHero.team and GetDistance(myHero, targetObj) < ts.range then
            ts.target = targetObj
        end
    end
    Checks()
    --if Config.Keys.Combo then iOrb:Orbwalk(ts.target) end
    --KillSteal
    if Config.KillSteal.useQ or Config.KillSteal.useW or Config.KillSteal.useIgnite or Config.KillSteal.useR2 or Config.Combo.useR2 == 2 or Config.Combo.useR2 == 4 then
        KillSteal()
    end

    if Config.Keys.Run then Run() end

    local aa = os.clock() - AA.LastCastTime
    local q = os.clock() - Q.LastCastTime
    local w = os.clock() - W.LastCastTime
    local e = os.clock() - E.LastCastTime
    local r = os.clock() - R.LastCastTime
    local min = math.min(aa,q,w,e,r)

    if min < Config.Misc.humanizer then return end 

    if not iOrb:CanCast() then return end

    if Config.Misc.enemyTurret and UnitAtTurret(ts.target, 0) and UnitAtTurret(myHero, Q.Range) then return end
    local target = iOrb:getTarget()
    if P.Stacks > 2 and ValidTarget(target) and ValidTarget(target, AA.Range(target)) then
        local boolean, count, highestPriority = modes:Contains("AA") 
        if not boolean then
            if damage:requiresAA(target) and (Config.Keys.Combo or Config.Keys.Harass) then
                modes:Insert("AA", target, 3)
            elseif not (Config.Keys.Combo or Config.Keys.Harass) then
                modes:Insert("AA", target, 3)
            end
        end
    end

    CheckAuto()

    --Fight
    if Config.Keys.Combo then Combo() end
    --harass
    if Config.Keys.Harass then Harass() end
    --clear
    if Config.Keys.Clear then Clear() end
    --lasthit
    if Config.Keys.LastHit then LastHit() end
    
end

function UnitAtTurret(unit, offset)
    if unit ~= nil and unit.valid then
        for name, turret in pairs(GetTurrets()) do
            if turret ~= nil and GetDistance(myHero, turret) < 2000 then
                if turret.team ~= myHero.team and GetDistance(unit, turret) < turret.range + offset then
                    return true
                end
            end
        end
    end
    return false
end

function CheckAuto()
    if CountEnemies(myHero, W.Range) >= Config.Auto.AutoW and Config.Auto.AutoW > 0 and W.IsReady() then
        CastSpell(_W)
    end

    if W.IsReady() and Config.Auto.AutoEW > 0 and E.IsReady() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if GetDistance(myHero, enemy) < E.Range + W.Radius/2 and E.IsReady() and W.IsReady() and Config.Auto.AutoEW > 0 and ValidTarget(enemy)  then
                local CastPosition,  HitChance, Count,  Position = prediction:getPrediction(enemy, E.Range, E.Speed, W.Delay, W.Radius, myHero, false, "circularaoe")
                if Count >= Config.Auto.AutoEW then
                    CastSpell(_E, CastPosition.x, CastPosition.z)
                    DelayAction(function() CastSpell(_W) end, 0.2)
                    break
                end
            end
        end
    end

    if E.IsReady() and Config.Auto.AutoE > 0 and not Config.Keys.Combo then
        if CountEnemies(myHero, Config.Auto.AutoERange) >= Config.Auto.AutoE  then
            local safePlace = modes:getSafePlace(ts.target)
            if safePlace ~= nil and safePlace.valid then
                local pos = myHero + Vector(safePlace.x - myHero.x, 0,  safePlace.z - myHero.z):normalized() * E.Range
                CastSpell(_E, pos.x, pos.z)
            end
        end
    end
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and enemy.visible and enemy.health/enemy.maxHealth < 0.5 and GetDistance(myHero, enemy) < R.Range and not haveBuff(enemy) then
            if Config.KillSteal.useQ and Q.Damage(enemy) > enemy.health and not enemy.dead then CastQ(enemy) end
            if Config.KillSteal.useW and W.Damage(enemy) > enemy.health and not enemy.dead then CastW(enemy) end
            if Config.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead  and GetDistance(myHero, enemy) < Ignite.Range then CastSpell(igniteslot, enemy) end
            if (Config.KillSteal.useR2 or Config.Combo.useR2 == 2 or Config.Combo.useR2 == 4) and R.Damage(enemy) > enemy.health and not enemy.dead then CastR2(enemy) end
        end
    end
end


function GetBestPositionFarm(from, width, range)
    local MaxQ = 0 
    local MaxQPos = nil
    for i, minion in pairs(EnemyMinions.objects) do
        if not minion.dead then
            if GetDistance(from, minion) < range then
                local hitQ = CountMinionsHit(minion, from, width,range)
                if MaxQPos == nil then
                    MaxQPos = minion
                    MaxQ = hitQ
                elseif MaxQPos ~= nil and hitQ > MaxQ then
                    MaxQPos = minion
                    MaxQ = hitQ
                end
            end
        end
    end
    return MaxQPos
end

function getRange(cast)
    if Config.Combo.comboMode == 1 then

    elseif Config.comboMode == 2 then

    else

    end
end

function CountMinionsHit(pos, from, width, range)
    local n = 0
    local ExtendedVector = Vector(from) + Vector(Vector(pos) - Vector(from)):normalized()*range
    for i, minion in ipairs(EnemyMinions.objects) do
        if not minion.dead then
            local MinionPointSegment, MinionPointLine, MinionIsOnSegment =  VectorPointProjectionOnLineSegment(Vector(from), Vector(ExtendedVector), Vector(minion)) 
            local MinionPointSegment3D = {x=MinionPointSegment.x, y=pos.y, z=MinionPointSegment.y}
            if MinionIsOnSegment and GetDistance(MinionPointSegment3D, pos) < width + 30 then
                n = n + 1
            end
        end
    end
    return n
end

function LastHit()
    if modes:Size() > 0 then
        modes:UseList()
    else
        if Config.LastHit.useQ or Config.LastHit.useW or Config.LastHit.useE then
            for i, minion in pairs(EnemyMinions.objects) do 
                if Config.LastHit.useQ and GetDistance(myHero, minion) < Q.Range and Q.IsReady() and not minion.dead and Q.Damage(minion) - 5 >= prediction:getPredictedHealth(minion, 1) then
                    CastSpell(_Q, minion.x, minion.z)
                end
                if Config.LastHit.useW and GetDistance(myHero, minion) < W.Range and W.IsReady() and not minion.dead and W.Damage(minion) - 5 >= prediction:getPredictedHealth(minion, 1) then
                    CastSpell(_W)
                end
                if Config.LastHit.useE and GetDistance(myHero, minion) < E.Range + AA.Range(minion) and E.IsReady() and not minion.dead and AA.Damage(minion) + P.Damage(minion) - 5 >= prediction:getPredictedHealth(minion, 1) then
                    CastSpell(_E, minion.x, minion.z)
                end
                if Config.LastHit.useTiamat then CastTiamat(target) end
            end
        end
    end
end

function Clear()
    if modes:Size() > 0 then
        modes:UseList()
    else
        local minion2 = nil
        if Config.Clear.useQ and Q.IsReady() then
            local BestPos = GetBestPositionFarm(myHero, Q.Radius, Q.Range)
            minion2 = BestPos
            if BestPos ~= nil and not BestPos.dead then
                CastSpell(_Q, BestPos.x, BestPos.z)
            end
        end
        
        if Config.Clear.useE and E.IsReady() then
            local BestPos = GetBestPositionFarm(myHero, W.Radius, E.Range)
            minion2 = BestPos
            if BestPos ~= nil and not BestPos.dead  then
                CastSpell(_E, BestPos.x, BestPos.z)
            end
        end
        if Config.Clear.useW or Config.Clear.useE then
            for i, minion in pairs(EnemyMinions.objects) do  
                if Config.Clear.useW and GetDistance(myHero, minion) < W.Range and W.IsReady() and not minion.dead  then
                    CastSpell(_W)
                end
                if Config.Clear.useE and GetDistance(myHero, minion) < E.Range and E.IsReady() and not minion.dead  then
                    CastSpell(_E, minion.x, minion.z)
                end       
            end
        end
        if Config.Clear.useTiamat then CastTiamat(minion2) end
        if Config.Clear.useQ or Config.Clear.useW or Config.Clear.useE or Config.Clear.useTiamat then
            local minion = bestJungle
            if minion ~= nil and not minion.dead and Config.Clear.useQ and GetDistance(myHero, minion) < Q.Range and Q.IsReady() then
                CastSpell(_Q, minion.x, minion.z)
            end
            if minion ~= nil and not minion.dead and Config.Clear.useW and GetDistance(myHero, minion) < W.Range and W.IsReady() then
                CastSpell(_W)
            end
            if minion ~= nil and not minion.dead and Config.Clear.useE and GetDistance(myHero, minion) < E.Range and E.IsReady() then
                CastSpell(_E, minion.x, minion.z)
            end
            if Config.Clear.useTiamat then CastTiamat(minion) end
        end
    end 
end

function Run()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if E.IsReady() then
        CastSpell(_E, mousePos.x, mousePos.z)
    end
    if Q.IsReady() then
        CastSpell(_Q, mousePos.x, mousePos.z)
    end
end



function Combo()
    local target = ts.target
    local range = Config.Combo.Range
    if not ValidTarget(target, range) then return end
    if Config.Combo.useItems then UseItems(target) end
    if modes:Size() > 0 then
        modes:UseList()
    else
        if Config.Combo.useR1 > 1 or Config.Combo.useR2 > 1 then CastR(target) end
        if Config.Combo.useTiamat > 1 then CastTiamat(target) end
        if Config.Combo.useW then CastW(target) end
        if Config.Combo.useQ then CastQ(target) end
        if Config.Combo.useE then CastE(target) end
    end
end


function Harass()
    local target = ts.target
    local range = Config.Harass.Range
    if not ValidTarget(target, range)  then return end
    modes:setHarass()
    if modes:Size() > 0 then
        if Config.Harass.useTiamat then CastTiamat(target) end
        modes:UseList()
    elseif Config.Harass.harassMode == 1 then
        if Config.Harass.useQ then CastQ(target) end
        if Config.Harass.useW then CastW(target) end
        if Config.Harass.useE then CastE(target) end
        if Config.Harass.useTiamat then CastTiamat(target) end
    end
    
end




--CastX

function CastIgnite(target)
    if not ValidTarget(target) then return end
    if Ignite.IsReady() and GetDistance(myHero, target) < Ignite.Range  and not haveBuff(target) then
        CastSpell(igniteslot, target)
    end
end

function CastQFast(target)
   if Q.IsReady() and ValidTarget(target, ts.range) and not haveBuff(target) then
        if ValidTarget(target, Q.Range +  Q.Radius/2) then
            local CastPosition, HitChance, Count, Position = prediction:getPrediction(target, Q.Range, Q.Speed, Q.Delay, Q.Radius, myHero, false, "circularaoe")
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        else
            CastSpell(_Q, target.x, target.z)
        end
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("RQ"):lower() then
            modes:RemoveAt(1)
        end
    end
end

function CastQ(target)
    if Q.IsReady() and ValidTarget(target, ts.range) and not haveBuff(target) then
        if ValidTarget(target, Q.Range +  Q.Radius/2) then
            local CastPosition, HitChance, Count, Position = prediction:getPrediction(target, Q.Range, Q.Speed, Q.Delay, Q.Radius, myHero, false, "circularaoe")
            --and R.IsReady() and R.State 
            if Config.Combo.useR2 == 3 and R.State and Q.State == 2 then
                local CastPosition2,  HitChance2,  Position2 = prediction:getPrediction(target, R.Range, R.Speed, R.Delay, R.Radius, myHero, false, "line")
                if HitChance2 >= 0 then
                    if E.IsReady() and Config.Misc.cancelR then 
                        CastSpell(_E, target.x, target.z)
                    end
                    CastSpell(_R, CastPosition2.x, CastPosition2.z)
                end
            end
            CastSpell(_Q, CastPosition.x, CastPosition.z)
            
        else
            if Config.Combo.useR2 == 3 and R.State and Q.State == 2  then
                local CastPosition2,  HitChance2,  Position2 = prediction:getPrediction(target, R.Range, R.Speed, R.Delay, R.Radius, myHero, false, "line")
                if HitChance2 >= 0 then
                    if E.IsReady() and Config.Misc.cancelR then 
                        CastSpell(_E, target.x, target.z)
                    end
                    CastSpell(_R, CastPosition2.x, CastPosition2.z)
                end
            end
            CastSpell(_Q, target.x, target.z)
        end
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("Q"):lower() then
            modes:RemoveAt(1)
        end
    end
end

function CastW(target)
    if W.IsReady() and ValidTarget(target, W.Range) and not haveBuff(target) then
        CastSpell(_W)
        --W.LastCastTime = os.clock()elseif modes:Size() > 0 then
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("W"):lower() then
            modes:RemoveAt(1)
        end
    end
end

function CastE(target)
    --local bool = (Config.Keys.Combo  and target.type == myHero.type) or (Config.Keys.Harass and target.type == myHero.type)
    if E.IsReady() and ValidTarget(target, ts.range) and (GetDistance(myHero, target) > E.Range or (not Q.IsReady()) ) and not haveBuff(target) then
        local CastPosition,  HitChance, Count,  Position = prediction:getPrediction(target, E.Range, E.Speed, W.Delay, W.Radius, myHero, false, "circularaoe")
        CastSpell(_E, CastPosition.x, CastPosition.z)
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("E"):lower() then
            modes:RemoveAt(1)
        end
    end
end

function CastR(target)
    if not ValidTarget(target) then return end
    if R.IsReady() then
        if not R.State then 
            if Config.Combo.useR1 == 3 then
                CastR1(target)
            elseif Config.Combo.useR1 == 2 then
                
                if damage:requiresR(target) then
                    CastR1(target)
                end
            end    
        else 
            if (Config.Combo.useR2 == 2 or Config.Combo.useR2 == 4) and R.Damage(target) > target.health and not target.dead then
                CastR2(target)
            end
        end
    
    end
end

function CastR1(target)
    if R.IsReady() and not R.State and not haveBuff(target) and ValidTarget(target, ts.range) then
        if E.IsReady() and Config.Misc.cancelR then 
            CastSpell(_E, target.x, target.z)
        end
        CastSpell(_R)
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("R1"):lower() then
            modes:RemoveAt(1)
        end
    end
end



function CastR2Fast(target)
    if R.IsReady() and not haveBuff(target) and R.State and ValidTarget(target, R.Range) then
        local CastPosition,  HitChance,  Position = prediction:getPrediction(target, R.Range, R.Speed, R.Delay, R.Radius, myHero, false, "line")
        if HitChance >= 0 then
            if E.IsReady() and Config.Misc.cancelR then 
                CastSpell(_E, target.x, target.z)
            end
            CastSpell(_R, CastPosition.x, CastPosition.z)
        end
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("R2FAST"):lower() then
            modes:RemoveAt(1)
        end
    end
end

function CastR2(target)
    if R.IsReady() and not haveBuff(target) and R.State and ValidTarget(target, ts.range) then
        local CastPosition,  HitChance,  Position = prediction:getPrediction(target, R.Range, R.Speed, R.Delay, R.Radius, myHero, false, "line")
        if HitChance >= 2 and GetDistance(myHero, CastPosition) < R.Range then
            if E.IsReady() and Config.Misc.cancelR then 
                CastSpell(_E, target.x, target.z)
            end
            CastSpell(_R, CastPosition.x, CastPosition.z)
        end
    elseif modes:Size() > 0 then
        local cast, target, priorityLevel = modes:Get(1)
        if cast:lower() == tostring("R2"):lower() then
            modes:RemoveAt(1)
        end
    end
end




function CastTiamat(target)
    if Config.Keys.Combo and Config.Combo.useTiamat == 1 then
        if ValidTarget(target) and Tiamat.IsReady() and not haveBuff(target) then 
        CastSpell(Tiamat.Slot())
        elseif ValidTarget(target) and Hydra.IsReady() and not haveBuff(target) then 
        CastSpell(Hydra.Slot())
        end
    else
        if ValidTarget(target, Tiamat.Range) and Tiamat.IsReady() and not haveBuff(target) then 
            CastSpell(Tiamat.Slot())
        elseif ValidTarget(target, Hydra.Range) and Hydra.IsReady() and not haveBuff(target) then 
            CastSpell(Hydra.Slot())
        elseif modes:Size() > 0 then
            local cast, target, priorityLevel = modes:Get(1)
            if cast:lower() == tostring("TIAMAT"):lower() then
                modes:RemoveAt(1)
            end
        end
    end
end



function OnProcessSpell(unit, spell)
    if unit == nil or not ScriptLoaded then return end
    if not unit.isMe then return end
    if unit.isMe then

        if spell.name:lower():find("rivenbasicattack") then
            AA.LastCastTime = os.clock()
            local target = iOrb:getTarget()
            if ValidTarget(target) then
                DelayAction(function() modes:Insert("Q", target, 2) end,  iOrb:Latency() * 2 - iOrb:WindUpTime())
            end
        elseif spell.name:lower():find("riventricleave") then
            if P.Stacks < 3 then P.Stacks = P.Stacks + 1 end

            Q.LastCastTime = os.clock()
            cancelAnimation(Config.Misc.useCancelAnimation)
        elseif spell.name:lower():find("rivenmartyr") then
            if P.Stacks < 3 then P.Stacks = P.Stacks + 1 end
            autoQW = false
            W.LastCastTime = os.clock()
            local target = iOrb:getTarget()
            if ValidTarget(target) then
                modes:Insert("TIAMAT", target, 1) 
                modes:Insert("Q", target, 1) 
            end
            cancelAnimation(Config.Misc.useCancelAnimation)
        elseif spell.name:lower():find("rivenfeint") then
            if P.Stacks < 3 then P.Stacks = P.Stacks + 1 end
            E.LastCastTime = os.clock()
            local target = iOrb:getTarget()
            if ValidTarget(target) then
                modes:Insert("TIAMAT", target, 1) 
                modes:Insert("Q", target, 1)
                modes:Insert("W", target, 1)
            end
            cancelAnimation(Config.Misc.useCancelAnimation)
        elseif spell.name:lower():find("rivenfengshuiengine") then
            if P.Stacks < 3 then P.Stacks = P.Stacks + 1 end
            if Config.Misc.cancelR then
                local target = iOrb:getTarget()
                if ValidTarget(target) then
                    modes:Insert("RQ", target, 3) -- poner en prioridad  2 al cast E
                end

            end
            if Config.Combo.useR2 > 1 then 
                DelayAction(function()
                local target = iOrb:getTarget()
                if ValidTarget(target) then
                    modes:Insert("R2", target, 4) 
                end
                end, 14.5) 
            end
            
            cancelAnimation(Config.Misc.useCancelAnimation)
        elseif spell.name:lower():find("rivenizunablade") then
            if P.Stacks < 3 then P.Stacks = P.Stacks + 1 end
            if Config.Misc.cancelR then
                local target = iOrb:getTarget()
                if ValidTarget(target) then
                    modes:Insert("RQ", target, 3) -- poner en prioridad + 2 al cast E
                end
            end
            cancelAnimation(Config.Misc.useCancelAnimation)
        elseif spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            local target = iOrb:getTarget()
            if ValidTarget(target) then
                modes:Insert("W", target, 2) 
            end
            cancelAnimation(Config.Misc.useCancelAnimation)
        end
    end
end

function RecvPacket(p)
    -- body
end

function redondear(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


function OnDraw()
    if myHero.dead or not ScriptLoaded then return end
    

    if Config.Misc.developer then
        local pos = WorldToScreen(D3DXVECTOR3(myHero.x , myHero.y, myHero.z))
        local string = "P: ".." ".. P.Stacks
        DrawText(string, 25, pos.x, pos.y,  ARGB(255,255,255,255))
        if modes:Size() > 0 then
            for i = 1, modes:Size(), 1 do
                local X = myHero.x + 600
                local CountY = myHero.y + 400 - i*50 
                local CountZ = myHero.z + 400 - i*50 
                local pos = WorldToScreen(D3DXVECTOR3(X , CountY, CountZ))

                local cast, target, priorityLevel = modes:Get(i)
                if ValidTarget(target) then
                    local string = cast.." "..(target.charName or " ").." "..priorityLevel
                   --print(string)
                    DrawText(string, 25, pos.x, pos.y,  ARGB(255,255,255,255))
                end
            end
            --print("----------")
        end
    end
end




function OnAnimation(unit, animationName)
    if unit.isMe then
        if animationName:lower():find("idle") then
        elseif animationName:lower():find("attack") then
        elseif animationName:lower():find("idle1") then
        elseif animationName:lower():find("spell1a") then
        elseif animationName:lower():find("spell1b") then
        elseif animationName:lower():find("spell1c") then            
        end
    end
end

function cancelAnimation(mode)
    local time = 1*(iOrb:WindUpTime() - iOrb:Latency())/100
    if mode == 1 then
    elseif mode == 2 then

        local target = ts.target
        if ValidTarget(target) then
            local MovePos = myHero + Vector(myHero.x - target.x, 0,  myHero.z - target.z):normalized() * VP:GetHitBox(myHero)
            --Packet("S_MOVE", {x = MovePos.x, y = MovePos.z}):send()
            --myHero:MoveTo(MovePos.x, MovePos.z)
            if not VIP_USER then 
                myHero:MoveTo(mousePos.x, mousePos.z)
            else
                Packet("S_MOVE", {x = MovePos.x, y = MovePos.z}):send()
                myHero:MoveTo(mousePos.x, mousePos.z)
            end

        end
    elseif mode == 3 then SendChat("/j") --DelayAction(function() SendChat("/j") end, time)
    elseif mode == 4 then SendChat("/t") --DelayAction(function() SendChat("/t") end, time)
    elseif mode == 5 then SendChat("/d") --DelayAction(function() SendChat("/d") end, time)
    elseif mode == 6 then SendChat("/l") --DelayAction(function() SendChat("/l") end, time)
    end
end

--ADDONS


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



function UseItems(unit)
    if ValidTarget(unit) then
        for _, item in pairs(Items) do
            if item.IsReady() and GetDistance(myHero, unit) < item.Range  then
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
        [3] = {1,1,2,3,3},
        [4] = {1,2,3,4,4},
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

function findBestCast(range, radius)
    local bestTarget = nil
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if GetDistance(myHero, enemy) < range + radius then
            if bestTarget == nil then bestTarget = enemy
            elseif CountEnemies(enemy, radius) > CountEnemies(bestTarget, radius) then bestTarget = enemy end
        end
    end
    return bestTarget
end

function CountEnemies(point, range)
    local ChampCount = 0
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
            if GetDistanceSqr(enemy, point) <= range*range then
                ChampCount = ChampCount + 1
            end
        end
    end
    return ChampCount
end

function haveBuff(target) 
    if not ValidTarget(target) then return false end

    if TargetHaveBuff("JudicatorIntervention", target) then return true
    elseif TargetHaveBuff("zhonyasringshield", target) then return true
    elseif TargetHaveBuff("UndyingRage", target) then return true
    elseif TargetHaveBuff("ZacRebirthReady", target) then return true
    elseif TargetHaveBuff("AatroxPassiveReady", target) then return true
    elseif TargetHaveBuff("Ferocious Howl", target) then return true
    elseif TargetHaveBuff("FerociousHowl", target) then return true
    elseif TargetHaveBuff("VladimirSanguinePool", target) then return true
    elseif TargetHaveBuff("chronorevive", target)then return true
    else return false end
end

class("Prediction")
function Prediction:__init()
    self.delay = 0.07
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
end

function Prediction:getPrediction(unit, range, speed, delay, width, source, collision, skillshot)
    if skillshot == "circularaoe" then
        return VP:GetCircularAOECastPosition(unit, delay, width, range, speed, source, collision)
    end
    if Config.Misc.predictionType == 1 then
        if skillshot == "line" or skillshot == "circular" then
            return VP:GetBestCastPosition(unit, delay, width, range, speed, source, collision, skillshot)
        elseif skillshot == "circularaoe" then
            return VP:GetCircularAOECastPosition(unit, delay, width, range, speed, source, collision)
        else
            VP:GetBestCastPosition(unit, delay, width, range, speed, source, collision, "circular")
        end
    else 
        local pos, info = Prodiction.GetPrediction(unit, range, speed, delay, width, source)
        if collision and skillshot == "line" then
            if not info.mCollision() then 
                return pos, info.hitchance, info.pos
            else return pos, -1, info.pos end
        else
            return pos, info.hitchance, info.pos
        end
    end
end

--farm and more
function Prediction:getTimeMinion(minion, mode)
    local time = 0
    --lasthit
    if mode == 1 then
        time = iOrb:WindUpTime() + GetDistance(myHero, minion) / self.ProjectileSpeed - self.delay
    --laneclear
    elseif mode == 2 then
        time = iOrb:AnimationTime() + GetDistance(myHero, minion) / self.ProjectileSpeed - self.delay
        time = time * 2
    end
    return time
end



function Prediction:getPredictedHealth(minion, mode)
    local output = 0
    --lasthit
    if mode == 1 then
        local time = self:getTimeMinion(minion, mode)
        local predHealth, maxdamage, count = VP:GetPredictedHealth(minion, time, iOrb:getFarmDelay())
        output = predHealth
    --laneclear
    elseif mode == 2 then
        local time = self:getTimeMinion(minion, mode)
        local predHealth, maxdamage, count = VP:GetPredictedHealth2(minion, time)
        output = predHealth
    end
    return output
end


class("iOrbwalker")
function iOrbwalker:__init()
    self.isAttacking = false
    self.bufferAA = false 
    self.nextAA = 0
    self.baseWindUpTime = 3
    self.baseAnimationTime = 0.665
    self.windUpTime = 3
    self.animationTime = 0.665
    self.predHealthLimit = -20
    self.delay = 0.07
    self.lastWait = 0
    self.dataUpdated = false
    self.Menu = nil
    self.target = nil
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end



function iOrbwalker:LoadMenu(Menu)

    self.Menu = Menu
    self.Menu:addSubMenu("Drawing Settings", "Draw")
            self.Menu.Draw:addParam("myAARange","My AA Range", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("enemyAARange","Enemy AA Range", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("HoldDraw","Hold position radius", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("Target","Draw circle target", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addSubMenu("Adjustment Settings", "Adjustment")
            self.Menu.Adjustment:addParam("farmDelay", "Delay on Farm (Req. type of delay)", SCRIPT_PARAM_SLICE, 70, 0, 150, 0)
            self.Menu.Adjustment:addParam("typeOfDelay", "Farm Adjustment", SCRIPT_PARAM_LIST, 1, {"None", "Earlier Hit", "Later Hit"})
            self.Menu.Adjustment:addParam("keyDelay", "Switcher for Farm Adjustment", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("L"))
        self.Menu:addParam("HoldRadius", "Hold position radius", SCRIPT_PARAM_SLICE, 80, 60, 250)
        self.Menu:addParam("minionRange", "Range to analyze minions", SCRIPT_PARAM_SLICE, 550, 300, 900)
        self.Menu:addParam("PriorizeFarm","Priorize Farm over Harass", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Adjustment:permaShow("typeOfDelay")

    AddDrawCallback(function() self:OnDraw() end)
    AddTickCallback(function() self:OnTick() end)
    AddMsgCallback(function(msg, key) self:OnWndMsg(msg, key) end)
    AddCreateObjCallback(function(obj) self:OnCreateObj(obj) end)
end

function iOrbwalker:OnWndMsg(msg, key)

    if msg == KEY_UP then
       if key == self.Menu.Adjustment._param[3].key then
            self.Menu.Adjustment.typeOfDelay = self.Menu.Adjustment.typeOfDelay + 1
            if self.Menu.Adjustment.typeOfDelay == 4 then self.Menu.Adjustment.typeOfDelay = 1 end
       end
    end
end

function iOrbwalker:OnCreateObj(obj)
    if obj == nil then return end
end

function iOrbwalker:OnProcessSpell(unit, spell)
    if unit== nil or spell == nil then return end 
    if unit.isMe then
        if spell.name:lower():find("basicattack") then
            if not self.dataUpdated then
                self.baseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
                self.baseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
                self.dataUpdated = true
            end
            self.animationTime = 1 / (spell.animationTime * myHero.attackSpeed)
            self.windUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
            self.isAttacking = true
            self.nextAA = os.clock() + (self:AnimationTime() - self:Latency()) - 0.2
            local time = math.max(spell.windUpTime - self:Latency() + Config.Misc.bufferAA * 0.01, 0)
            DelayAction(function() self:CheckAA() end, time * 2)
            DelayAction(function() self.isAttacking = false end,  time)
        elseif spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            self:ResetAA()
        elseif spell.name:lower():find("riventricleave") then
            --print(math.abs(self:WindUpTime() + Config.Misc.delayResetAA * 0.01 - self:Latency() * 2).." vs "..self:WindUpTime() - self:Latency() * 2)
            --local int = 0 --Config.Misc.delayResetAA
            --print(self:WindUpTime() + Config.Misc.bufferQ * 0.01 - self:Latency() * 2)
            -- DelayAction(function() self:ResetAA() end, math.abs(self:WindUpTime() + Config.Misc.bufferQ * 0.01 - self:Latency() * 2))
            local int = 0
            if Config.Misc.bufferQ == 1 then int = self:WindUpTime() - self:Latency() * 2 else int = 8/1000 end
            DelayAction(function() self:ResetAA() end, int)
        end
    end
end


function iOrbwalker:CheckAA()
    if self:CanCast() then if P.Stacks > 0 then P.Stacks = P.Stacks - 1 end modes:Remove("AA", 1) 
    else DelayAction(function() self:CheckAA() end, (self:WindUpTime() - self:Latency())) end
end



function iOrbwalker:OnTick() 
    if self.Menu == nil then return end
    minionRange = self.Menu.minionRange
    if Config.Keys.Harass or Config.Keys.Clear or Config.Keys.LastHit then
        EnemyMinions:update()
        JungleMinions:update()
    end
    
    if Config.Keys.Combo then
        local target = self:Combo()
        if ValidTarget(target) then self:Orbwalk(target) else self:Orbwalk(nil) end
    elseif Config.Keys.Harass then
        local target, boolean = self:Harass()
        if ValidTarget(target) and boolean then self:Orbwalk(target) else self:Orbwalk(nil) end
    elseif Config.Keys.LastHit then
        local target, boolean = self:LastHit()
        if ValidTarget(target) and boolean then self:Orbwalk(target) else self:Orbwalk(nil) end
    elseif Config.Keys.Clear then
        local killableMinion, farKillableMinion, almostKillableMinion, whileWaitingMinion, bestJungle  = self:LaneClear()
        if ValidTarget(killableMinion) then self:Orbwalk(killableMinion)
        elseif ValidTarget(whileWaitingMinion) then self:Orbwalk(whileWaitingMinion)
        elseif ValidTarget(bestJungle) then self:Orbwalk(bestJungle)
        else self:Orbwalk(nil) end
        
    end
end

function iOrbwalker:CanAttack()
    return self.nextAA <= os.clock() and not self.bufferAA and not self.isAttacking
end

function iOrbwalker:Latency()
    return GetLatency() / 2000
end

function iOrbwalker:WindUpTime()
    return 1 / (myHero.attackSpeed * self.baseWindUpTime)
end
function iOrbwalker:AnimationTime()
    return 1 / (myHero.attackSpeed * self.baseAnimationTime)
end

function iOrbwalker:ResetAA()
    local target = self:getTarget()
    if ValidTarget(target) then
        if damage:requiresAA(target) and (Config.Keys.Combo or Config.Keys.Harass) then
            modes:Insert("AA", target, 3)
        elseif not (Config.Keys.Combo or Config.Keys.Harass) then
            modes:Insert("AA", target, 3)
        end
    end
    if self.Menu == nil and _G.AutoCarry then 
        _G.AutoCarry.Orbwalker:ResetAttackTimer()
    end
    self.isAttacking = false
    self.nextAA = 0
    
end

function iOrbwalker:CanCast()
    if self.Menu == nil then return not self.isAttacking and not self.bufferAA end
    if self.Menu.PriorizeFarm and Config.Keys.Harass then
        local minions = self:getKillableMinions()
        if minions ~= nil then
            if #minions > 0 then 
                 for i, minion in pairs(minions) do
                    if ValidTarget(minion, AA.Range(minion)) then 
                        return false
                    end
                end
            else return true end
        end
    end
    return not self.isAttacking and not self.bufferAA
end

function iOrbwalker:InRange(target)
    return ValidTarget(target) and ValidTarget(target, AA.Range(target))
end

function iOrbwalker:Orbwalk(target)
    if ValidTarget(target, ts.range) then self.target = target else self.target = nil end
    if ValidTarget(target) and self:CanAttack() and self:InRange(target) then
        myHero:Attack(target)
        self.bufferAA = true
        DelayAction(function()
            self.bufferAA = false
        end, self:Latency() * 2)
    else 
        if GetDistance(myHero, mousePos) > Config.Orbwalking.HoldRadius and not self.isAttacking and not self.bufferAA then
            myHero:MoveTo(mousePos.x, mousePos.z)
        end
    end
end

function iOrbwalker:getTarget()
    if self.Menu == nil and _G.AutoCarry then
       return _G.AutoCarry.Crosshair:GetTarget()
    else
        return self.target
    end
end

function iOrbwalker:OnDraw()

    if self.Menu == nil then return end
    if self.Menu.Draw.HoldDraw then
        draw:DrawCircle2(myHero.x, myHero.y, myHero.z, self.Menu.HoldRadius, Colors.Blue, 1)
    end

    if self.Menu.Draw.myAARange then
        draw:DrawCircle2(myHero.x, myHero.y, myHero.z, AA.Range(self:getTarget()), Colors.White, 1)
    end

    if self.Menu.Draw.enemyAARange then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) and GetDistance(enemy, mousePos) < visionRange then
                draw:DrawCircle2(enemy.x, enemy.y, enemy.z, self:getAARange(enemy), Colors.White, 1)
            end
        end
    end

    if (Config.Keys.Combo or Config.Keys.Harass or Config.Keys.Clear or Config.Keys.LastHit) and self.Menu.Draw.Target then
        if Config.Keys.Combo then
        elseif Config.Keys.Harass then
            local target, boolean = self:Harass()
            if ValidTarget(target) then
                if boolean and target.name:lower():find("minion") then draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Red, 5)
                else draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 1) end
            end
        elseif Config.Keys.LastHit then
            local target, boolean = self:LastHit()
            if ValidTarget(target) then
                if boolean then draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Red, 5)
                else draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 1) end
            end
        elseif Config.Keys.Clear then
            local killableMinion, farKillableMinion, almostKillableMinion, whileWaitingMinion, bestJungle = self:LaneClear()
            if ValidTarget(killableMinion) then local target = killableMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Red, 5) end
            if ValidTarget(farKillableMinion) then local target = farKillableMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 5) end
            if ValidTarget(almostKillableMinion) then local target = almostKillableMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Yellow, 1) end
            if ValidTarget(whileWaitingMinion) then local target = whileWaitingMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Green, 1) end
            if ValidTarget(bestJungle) then local target = bestJungle draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 1) end
            
        end
    end

end

function iOrbwalker:getAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius - 10 or 0
end

function iOrbwalker:Combo()
   return ts.target
end

function iOrbwalker:LaneClear()
    local bestMinions = {}
    local killables = self:getKillableMinions()
    local killableMinion = nil
    local almostKillableMinion = nil
    local whileWaitingMinion = nil
    local farKillableMinion = nil
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, AA.Range(minion)) then 
                --table.insert(bestMinions, #bestMinions + 1, minion)
                --return {minion}
                killableMinion = minion
                break
            end
        end
    end
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, minionRange) and GetDistance(myHero, minion) > AA.Range(minion) then 
                if farKillableMinion == nil then
                    farKillableMinion = minion
                elseif GetDistance(myHero, farKillableMinion) > GetDistance(myHero, minion) then
                    farKillableMinion = minion
                end
            end
        end
    end
    --if #bestMinions > 0 then return bestMinions, true, false end

    bestMinions = {}
    local waitMinion = self:ShouldWait() 
    local bestMinion = nil
    if not waitMinion and os.clock() - self.lastWait > 0.5 then
        for i, minion in pairs(EnemyMinions.objects) do
            if ValidTarget(minion, minionRange) then
                local predHealth = prediction:getPredictedHealth(minion, 2)
                if predHealth > 2 * damage:getDamageToMinion(minion) then
                    
                    if bestMinion == nil then bestMinion = minion
                    elseif GetDistance(myHero, bestMinion) > GetDistance(myHero, minion) then bestMinion = minion end
                end
            end
        end
        if bestMinion ~= nil then whileWaitingMinion = bestMinion end
    end
    if waitMinion and not killableMinion then
        almostKillableMinion = waitMinion
    elseif os.clock() - self.lastWait > 0.5 or not ValidTarget(waitMinion) then
        almostKillableMinion = nil
    end
    --if #bestMinions > 0 then return bestMinions, false, true end



    bestMinions = {}
    bestJungle = nil
    for i, minion in pairs(JungleMinions.objects) do
        if ValidTarget(minion, AA.Range(minion)) then
            --[[
            if #bestMinions > 0 then
                local minion2 = bestMinions[#bestMinions]
                 if minion2.maxHealth > minion.maxHealth then
                     table.insert(bestMinions, #bestMinions + 1, minion)
                 else
                     table.insert(bestMinions, #bestMinions, minion)
                 end
            else
                table.insert(bestMinions, 1, minion)
            end]]
            if bestJungle == nil then
                bestJungle = minion
            elseif bestJungle.maxHealth < minion.maxHealth then
                bestJungle = minion
            end
        end
    end

    return killableMinion, farKillableMinion, almostKillableMinion, whileWaitingMinion, bestJungle
    --if #bestMinions > 0 then return bestMinions, false, true end
    --bestMinions = {}
    --return bestMinions, false, false
end

function iOrbwalker:LastHit()
    local killables = self:getKillableMinions()
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, AA.Range(minion)) then 
                return minion, true
            elseif ValidTarget(minion) and GetDistance(myHero, minion) > AA.Range(minion) then 
                return minion, false
            end
        end
    end
    local almostKillables = self:getAlmostKillableMinions()
    for i, minion in pairs(almostKillables) do
        if ValidTarget(minion, minionRange) then 
            return minion, false
        end
    end
    
end

function iOrbwalker:Harass()
    if not self.Menu.PriorizeFarm and ValidTarget(ts.target, AA.Range(ts.target)) then 
        return ts.target, true
    end
    local killables = self:getKillableMinions()
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, AA.Range(minion)) then 
                return minion, true
            end
        end
    end
    if self.Menu.PriorizeFarm and ValidTarget(ts.target, AA.Range(ts.target) + 50) then 
        return ts.target, true
    end
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion) and GetDistance(myHero, minion) > AA.Range(minion) then
                return minion, false
            end
        end
    end
    local almostKillables = self:getAlmostKillableMinions()
    for i, minion in pairs(almostKillables) do
        if ValidTarget(minion, minionRange) then 
            return minion, false
        end
    end
    

end

function iOrbwalker:getKillableMinions()
    local bestMinions = {}
    local bestBigMinions = {}
    --big minion first
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) and not minion.dead and minion.charName:lower():find("cannon") then
            local predHealth = prediction:getPredictedHealth(minion, 1)
            if damage:getDamageToMinion(minion) > predHealth and predHealth > self.predHealthLimit then
                table.insert(bestBigMinions, #bestBigMinions + 1, minion)
            end
        end
    end
    --small minions after
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) and not minion.dead and not minion.charName:lower():find("cannon") then
            local predHealth = prediction:getPredictedHealth(minion, 1)
            if damage:getDamageToMinion(minion) > predHealth and predHealth > self.predHealthLimit then
                
                if #bestMinions > 0 then
                    local minion2 = bestMinions[#bestMinions]
                    local predHealth2 = prediction:getPredictedHealth(minion2, 1)
                    if predHealth2/minion2.maxHealth < predHealth/minion.maxHealth then
                        table.insert(bestMinions, #bestMinions + 1, minion)
                    else
                        table.insert(bestMinions, #bestMinions, minion)
                    end
                else
                    table.insert(bestMinions, 1, minion)
                end
                
                --table.insert(bestMinions, #bestMinions + 1, minion)
            end
        end
    end
    if #bestBigMinions > 0 then
        for i, bigMinion in pairs(bigMinions) do
            table.insert(bestMinions, i, bigMinion)
        end
    end
    return bestMinions
end

function iOrbwalker:getAlmostKillableMinions()
    bestMinions = {}
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) and not minion.dead then
            local predHealth = prediction:getPredictedHealth(minion, 1)
            if predHealth > self.predHealthLimit then
                if #bestMinions > 0 then
                    local minion2 = bestMinions[#bestMinions]
                    local predHealth2 = prediction:getPredictedHealth(minion2, 1)
                    if predHealth2/minion2.maxHealth < predHealth/minion.maxHealth then
                        table.insert(bestMinions, #bestMinions + 1, minion)
                    else
                        table.insert(bestMinions, #bestMinions, minion)
                    end
                else
                    table.insert(bestMinions, 1, minion)
                end
            end
        end
    end
    return bestMinions
end



function iOrbwalker:ShouldWait()
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) then
            if ValidTarget(minion, AA.Range(minion)) then
                if damage:getDamageToMinion(minion) > prediction:getPredictedHealth(minion, 2) then
                    self.lastWait = os.clock()
                    return minion
                end
            end
        end
    end
end

--farm adjustment
function iOrbwalker:OnWndMsg(msg, key)
    if self.Menu == nil then return end
    if msg == KEY_UP then
       if key == self.Menu.Adjustment._param[3].key then
            self.Menu.Adjustment.typeOfDelay = self.Menu.Adjustment.typeOfDelay + 1
            if self.Menu.Adjustment.typeOfDelay == 4 then self.Menu.Adjustment.typeOfDelay = 1 end
       end
   end
end

function iOrbwalker:getFarmDelay()
    local output = 0
    if self.Menu.Adjustment.typeOfDelay == 3 then
        output = self.Menu.Adjustment.farmDelay/1000
    elseif self.Menu.Adjustment.typeOfDelay == 2 then
        output = (-1) * self.Menu.Adjustment.farmDelay/1000
    end
    return output
end


class("Damage")
function Damage:__init()

end

function Damage:requiresAA(target)
    if ValidTarget(target) then
        local q = 0
        if Q.IsReady() then q = (3 - Q.State) end
        local d, m = self:getComboDamage(target, 0, 0, q, W.IsReady(), E.IsReady(), false, false, false)
        if d > target.health then return false end 
        local d, m = self:getComboDamage(target, 0, 0, q, W.IsReady(), E.IsReady(), R.IsReady() or R.State, R.IsReady(), false)
        if d > target.health then return false end
    end
    return true
end

function Damage:requiresR(target)
    local q = 0
    if Q.IsReady() then q = (3 - Q.State) end
    local p = 0
    if q > 0 then p = p + q end
    if W.IsReady() then p = p + 1 end
    if E.IsReady() then p = p + 1 end
    if R.IsReady() then p = p + 1 end
    p = math.min(p, 3)
    if ValidTarget(target) then
        local d, m = self:getComboDamage(target, p, p + 1, q, W.IsReady(), E.IsReady(), false, false, false)
        if d > target.health then return false end
    end
    return true
end

function Damage:getBestCombo(target)
    if not ValidTarget(target) then return 0, 0, 0, false, false, false, false, false end
    local q = 0
    if Q.IsReady() then q = (3 - Q.State) end
    local p = 0
    if q > 0 then p = p + q end
    if W.IsReady() then p = p + 1 end
    if E.IsReady() then p = p + 1 end
    if R.IsReady() then p = p + 1 end
    p = math.min(p, 3)
    local d, m = self:getComboDamage(target, 0, 0, q, W.IsReady(), E.IsReady(), false, false, false)
    if d > target.health then 
        return 0, 0, q, W.IsReady(), E.IsReady(), false, false, false
    end
    local d, m = self:getComboDamage(target, 0, 0, q, W.IsReady(), E.IsReady(), R.IsReady() or R.State, R.IsReady(), false)
    if d > target.health then 
        return 0, 0, q, W.IsReady(), E.IsReady(), R.IsReady() or R.State, R.IsReady(), false
    else
        local p = 0
        if q > 0 then p = p + q end
        if W.IsReady() then p = p + 1 end
        if E.IsReady() then p = p + 1 end
        if R.IsReady() then p = p + 1 end
        p = math.min(p, 3)
        local item = Tiamat.IsReady() or Hydra.IsReady()
        local dmg = self:getComboDamage(target, p, p, q, W.IsReady(), E.IsReady(), R.IsReady() or R.State, R.IsReady(), item)
        return p, p + 1, q, W.IsReady(), E.IsReady(), R.IsReady() or R.State, R.IsReady(), item
    end

    --[[
    local p = {0}
    local aa = {0}
    local q = {0}
    local w = {false}
    local e = {false}
    local r1 = {false}
    local r2 = {false}
    local items = {false}

    if Q.IsReady() then 
        for i = 1, 3 - Q.State, 1 do
             table.insert(q, i)
        end 
    end
    if W.IsReady() then w = {false, true} end
    if E.IsReady() then e = {false, true} end
    if R.IsReady() then r1 = {false, true} end
    if R.IsReady() then r2 = {false, true} end
    if Tiamat.IsReady() or Hydra.IsReady() then items = {false, true} end
    for i = 1, math.min(#q - 1 + #w - 1 + #e - 1 + #r1 - 1 + #r2 - 1 , 3), 1 do
        table.insert(p, i)
    end 
    for i = 1, 3, 1 do
        table.insert(aa, i)
    end 
    local bestdmg = 0
    local bestTable = {0, 0, 0, false, false, false, false, false}
    for qCount = 1, #q do
        for wCount = 1, #w do
            for eCount = 1, #e do
                for r1Count = 1, #r1 do
                    for r2Count = 1, #r2 do
                        for iCount = 1, #items do
                            for pCount = 1, #p do
                                for aaCount = 1, #aa do
                                    local d, m = self:getComboDamage(target, p[pCount], aa[aaCount], q[qCount], w[wCount], e[eCount], r1[r1Count], r2[r2Count], items[iCount])
                                    if d > target.health then 
                                        if bestdmg == 0 then bestdmg = d bestTable = {p[pCount], aa[aaCount], q[qCount], w[wCount], e[eCount], r1[r1Count], r2[r2Count], items[iCount]}
                                        elseif d < bestdmg then bestdmg = d bestTable = {p[pCount], aa[aaCount], q[qCount], w[wCount], e[eCount], r1[r1Count], r2[r2Count], items[iCount]} end
                                    end
                                end
                            end 
                        end
                    end
                end
            end
        end
    end
    if bestdmg == 0 then
        return p[#p], aa[#aa], q[#q], w[#w], e[#e], r1[#r1], r2[#r2], items[#items]
    else return bestTable[1], bestTable[2], bestTable[3], bestTable[4], bestTable[5], bestTable[6], bestTable[7], bestTable[8]
    end
    ]]
end

function Damage:getComboDamage(target, p, aa, q, w, e, r1, r2, items)
    local comboDamage = 0
    local currentManaWasted = 0
    if target ~= nil and target.valid then
        comboDamage = comboDamage + P.Damage(target) * p
        comboDamage = comboDamage + AA.Damage(target) * aa
        if q > 0 then
            comboDamage = comboDamage +  Q.Damage(target) * q
            comboDamage = comboDamage + P.Damage(target) * 1
            comboDamage = comboDamage + AA.Damage(target) * 1
        end
        if w then
            comboDamage = comboDamage + W.Damage(target)
            comboDamage = comboDamage + P.Damage(target) * 1
            comboDamage = comboDamage + AA.Damage(target) * 1
        end
        if e then
        end
        if r1 then
            comboDamage = comboDamage + AA.Damage(target) * aa * 0.2
            comboDamage = comboDamage + P.Damage(target) * p * 0.2
        end
        if r2 then
            comboDamage = comboDamage + R.Damage(target)
        end
        for _, item in pairs(Items) do
            if item.IsReady() then
                comboDamage = comboDamage + item.Damage(target)
            end
        end
        if items then
            if Tiamat.IsReady() then
                comboDamage = comboDamage + Tiamat.Damage(target)
            elseif Hydra.IsReady() then 
                comboDamage = comboDamage + Hydra.Damage(target)
            end
        end
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
    self.Menu:addParam("Q","Q Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("W","W Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("E","E Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("R","R Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("dmgCalc","Draw Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Target","Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Quality", "Quality of Circles", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
    AddDrawCallback(function() self:OnDraw() end)
end

function Draw:OnDraw()
    if myHero.dead or self.Menu == nil then return end
    if self.Menu.dmgCalc then self:DrawPredictedDamage() end
    if self.Menu.Target and ts.target ~= nil and ValidTarget(ts.target) then
        self:DrawCircle2(ts.target.x, ts.target.y, ts.target.z, VP:GetHitBox(ts.target)*1.5, Colors.Red, 3)
    end

    if self.Menu.Q and (Q.IsReady() or Q.State < 3) then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, Q.Range, Colors.White, 1)
    end
    if self.Menu.W and W.IsReady() then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, W.Range, Colors.White, 1)
    end

    if self.Menu.E and E.IsReady() then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, E.Range, Colors.White, 1)
    end

    if self.Menu.R and R.IsReady() then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, R.Range, Colors.White, 1)
    end
end

function Draw:DrawPredictedDamage() 
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and enemy.visible and GetDistance(enemy, mousePos) < visionRange then
            local p, aa, q, w, e, r1, r2, items = damage:getBestCombo(enemy)
            local dmg, mana = damage:getComboDamage(enemy, p, aa, q, w, e, r1, r2, items)
            local spells = ""
            if p > 0 then spells = spells .." P" end
            if q > 0 then spells = spells .." Q" end
            if w then spells = spells .. " W" end
            if e then spells = spells .. " E" end
            if r1 or r2 then spells = spells .. " R" end
            self:DrawLineHPBar(dmg, spells, enemy, true)
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

class("Modes")
function Modes:__init()
    self.lastCombo = 0
    self.lastHarass = 0
    self.lastClear = 0
    self.lastLastHit = 0
    self.resetTime = 5
    self.listCombo = List()
    self.listHarass = List()
    self.listClear = List()
    self.listLastHit = List()
    AddTickCallback(function() self:OnTick() end)
    AddMsgCallback(function(msg, key) self:OnWndMsg(msg, key) end)
end

function Modes:OnWndMsg(msg, key)
    if msg == KEY_UP then
       if key == Config.Keys._param[1].key then
            self.lastCombo = os.clock()
       elseif key == Config.Keys._param[2].key then
            self.lastHarass = os.clock()
       elseif key == Config.Keys._param[3].key then
            self.lastClear = os.clock()
       elseif key == Config.Keys._param[4].key then
            self.lastLastHit = os.clock()
       end
    end
end

function Modes:OnTick()
    if os.clock() - self.lastCombo > self.resetTime and self.lastCombo > 0 and self.listCombo:Size() > 0 then
        self.listCombo:RemoveAll()
    elseif os.clock() - self.lastHarass > self.resetTime and self.lastHarass > 0 and self.listHarass:Size() > 0  then
        self.listHarass:RemoveAll()
    elseif os.clock() - self.lastClear > self.resetTime and self.lastClear > 0 and self.listClear:Size() > 0  then
        self.listClear:RemoveAll()
    elseif os.clock() - self.lastLastHit > self.resetTime and self.lastLastHit > 0 and self.listLastHit:Size() > 0  then
        self.listLastHit:RemoveAll()
    end
end

function Modes:UseList()
    if Config.Keys.Combo then
        local q, w, e, r1, r2, items = Config.Combo.useQ, Config.Combo.useW, Config.Combo.useE, Config.Combo.useR1 > 1, Config.Combo.useR2 > 1, Config.Combo.useTiamat 
        self.listCombo:UseList(q, w, e, r1, r2, items)
    elseif Config.Keys.Harass then
        local q, w, e, r1, r2, items = Config.Harass.useQ, Config.Harass.useW, Config.Harass.useE, false, false, Config.Harass.useTiamat
        self.listHarass:UseList(q, w, e, r1, r2, items)
    elseif Config.Keys.Clear then
        local q, w, e, r1, r2, items = Config.Clear.useQ, Config.Clear.useQ, Config.Clear.useE, false, false, Config.Clear.useTiamat
        self.listClear:UseList(q, w, e, r1, r2, items)
    elseif Config.Keys.LastHit then
        local q, w, e, r1, r2, items = Config.LastHit.useQ, Config.LastHit.useQ, Config.LastHit.useE, false, false, Config.LastHit.useTiamat
        self.listLastHit:UseList(q, w, e, r1, r2, items)
    end
end

function Modes:Insert(cast, target, priorityLevel)
    if Config.Keys.Combo then
        self.listCombo:Insert(cast, target, priorityLevel)
    elseif Config.Keys.Harass then
        if cast:lower() == tostring("AA"):lower() or cast:lower() == tostring("TIAMAT"):lower() then 
            self.listHarass:Insert(cast, target, priorityLevel)
        elseif Config.Harass.harassMode == 1 then
            self.listHarass:Insert(cast, target, priorityLevel)
        end
    elseif Config.Keys.Clear then
        self.listClear:Insert(cast, target, priorityLevel)
    elseif Config.Keys.LastHit then
        self.listLastHit:Insert(cast, target, priorityLevel)
    end
end

function Modes:Contains(cast)
    if Config.Keys.Combo then
        self.listCombo:Contains(cast)
    elseif Config.Keys.Harass then
        self.listHarass:Contains(cast)
    elseif Config.Keys.Clear then
        self.listClear:Contains(cast)
    elseif Config.Keys.LastHit then
        self.listLastHit:Contains(cast)
    end
end

function Modes:getHighestPriorityLevel()
    if Config.Keys.Combo then
        return self.listCombo:getHighestPriorityLevel()
    elseif Config.Keys.Harass then
        return self.listHarass:getHighestPriorityLevel()
    elseif Config.Keys.Clear then
        return self.listClear:getHighestPriorityLevel()
    elseif Config.Keys.LastHit then
        return self.listLastHit:getHighestPriorityLevel()
    end
    return 0
end

function Modes:Remove(cast, quantity)
    if Config.Keys.Combo then
        self.listCombo:Remove(cast, quantity)
    elseif Config.Keys.Harass then
        self.listHarass:Remove(cast, quantity)
    elseif Config.Keys.Clear then
        self.listClear:Remove(cast, quantity)
    elseif Config.Keys.LastHit then
        self.listLastHit:Remove(cast, quantity)
    else
        self.listCombo:Remove(cast, quantity)
        self.listHarass:Remove(cast, quantity)
        self.listClear:Remove(cast, quantity)
        self.listLastHit:Remove(cast, quantity)
    end
end



function Modes:Size()
    if Config.Keys.Combo then
        return self.listCombo:Size()
    elseif Config.Keys.Harass then
        return self.listHarass:Size()
    elseif Config.Keys.Clear then
        return self.listClear:Size()
    elseif Config.Keys.LastHit then
        return self.listLastHit:Size()
    end
    return 0
end

function Modes:GetList()
    if Config.Keys.Combo then
        return self.listCombo
    elseif Config.Keys.Harass then
        return self.listHarass
    elseif Config.Keys.Clear then
        return self.listClear
    elseif Config.Keys.LastHit then
        return self.listLastHit
    else 
        return nil
    end
end

function Modes:Get(i)
    if Config.Keys.Combo then
        return self.listCombo:Get(i)
    elseif Config.Keys.Harass then
        return self.listHarass:Get(i)
    elseif Config.Keys.Clear then
        return self.listClear:Get(i)
    elseif Config.Keys.LastHit then
        return self.listLastHit:Get(i)
    end
end

function Modes:RemoveAt(i)
    if Config.Keys.Combo then
        return self.listCombo:RemoveAt(i)
    elseif Config.Keys.Harass then
        return self.listHarass:RemoveAt(i)
    elseif Config.Keys.Clear then
        return self.listClear:RemoveAt(i)
    elseif Config.Keys.LastHit then
        return self.listLastHit:RemoveAt(i)
    end
end

function Modes:getSafePlace(target)
    AllyMinions:update()
    local bestPlace = nil
    if bestPlace == nil then
        for idx, champion in ipairs(GetAllyHeroes()) do
            if champion.valid and champion.visible then
                if GetDistance(myHero, champion) <= 800 and GetDistance(champion, target) > GetDistance(myHero, target) then
                    if bestPlace == nil then bestPlace = champion
                    elseif GetDistance(myHero, bestPlace) < GetDistance(myHero, champion) then bestPlace = champion end
                end
            end
        end
    end
    if bestPlace == nil then
        for i, turret in pairs(GetTurrets()) do
            if turret ~= nil then
                if turret.team == myHero.team and GetDistance(turret, target) > GetDistance(myHero, target) then
                    if bestPlace == nil then bestPlace = turret
                    elseif GetDistance(myHero, bestPlace) < GetDistance(myHero, turret) then bestPlace = turret end
                end
            end
        end
    end
    if bestPlace == nil then
        for i, minion in pairs(AllyMinions.objects) do
            if GetDistance(minion, target) > GetDistance(myHero, target) then
                if bestPlace == nil then bestPlace = minion
                elseif GetDistance(myHero, bestPlace) < GetDistance(myHero, minion) then bestPlace = minion end
            end
        end
    end
    return bestPlace
end

function Modes:setHarass()
    if Config.Harass.harassMode == 1 then
    elseif Config.Harass.harassMode == 2 then
        --self.listHarass:RemoveAll()
        local target = iOrb:getTarget()
        if ValidTarget(target) then
            if Q.State == 0 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif Q.State == 1 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif Q.State == 2 and W.IsReady() then self.listHarass:Insert("W", target, 1)
            elseif Q.State == 2 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif (Q.State == 0 or Q.State == 3) and not Q.IsReady() and E.IsReady() and GetDistance(myHero, target) < 500 and ValidTarget(target, Q.Range * 3) then 
                local safePlace = self:getSafePlace(target)
                if safePlace ~= nil and safePlace.valid and Config.Keys.Harass then
                    local pos = myHero + Vector(safePlace.x - myHero.x, 0,  safePlace.z - myHero.z):normalized() * E.Range
                    CastSpell(_E, pos.x, pos.z)
                end
            end
        end
    elseif Config.Harass.harassMode == 3 then
        --self.listHarass:RemoveAll()
        local target = iOrb:getTarget()
        if ValidTarget(target) then
            if Q.State == 0 and E.IsReady() then self.listHarass:Insert("E", target, 1)
            elseif Q.State == 0 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif Q.State == 1 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif Q.State == 1 and W.IsReady() then self.listHarass:Insert("W", target, 1)
            elseif Q.State == 2 and Q.IsReady() then 
                local safePlace = self:getSafePlace(target)
                if safePlace ~= nil and safePlace.valid then
                    local pos = myHero + Vector(safePlace.x - myHero.x, 0,  safePlace.z - myHero.z):normalized() * Q.Range
                    CastSpell(_W, pos.x, pos.z)
                end
            end
        end
    elseif Config.Harass.harassMode == 4 then
        --self.listHarass:RemoveAll()
        local target = iOrb:getTarget()
        if ValidTarget(target) then
            if Q.State == 0 and E.IsReady() then self.listHarass:Insert("E", target, 1)
            elseif Q.State == 0 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif Q.State == 1 and W.IsReady() then self.listHarass:Insert("W", target, 1)
            elseif Q.State == 1 and Q.IsReady() then self.listHarass:Insert("Q", target, 1)
            elseif Q.State == 2 and Q.IsReady() then 
                local safePlace = self:getSafePlace(target)
                if safePlace ~= nil and safePlace.valid then
                    local pos = myHero + Vector(safePlace.x - myHero.x, 0,  safePlace.z - myHero.z):normalized() * Q.Range
                    CastSpell(_E, pos.x, pos.z)
                end
            end
        end
    end
end


class("List")
-- list: CAST TARGET PRIORITY_LEVEL 
function List:__init()
    self.list = {}
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    AddTickCallback(function() self:OnTick() end)
end

function List:OnTick()
    --if not Q.IsReady() and (os.clock() - Q.LastCastTime > 5 or Q.State == 0) and (cast:lower() == tostring("Q"):lower() or cast:lower() == tostring("RQ"):lower()) then  return end
    --if not W.IsReady() and cast:lower() == tostring("W"):lower() then return end
    --if not E.IsReady() and cast:lower() == tostring("E"):lower() then return end
    --if not R.IsReady() and os.clock() - R.LastCastTime > 15 and (cast:lower() == tostring("R1"):lower() or cast:lower() == tostring("R2"):lower()) then return end
   -- if not Tiamat.IsReady() and Tiamat.Slot() ~= nil and cast:lower() == tostring("TIAMAT"):lower() then  return end
    --if not Hydra.IsReady() and Hydra.Slot() ~= nil and cast:lower() == tostring("TIAMAT"):lower() then return end
end

function List:Size()
    return #self.list
end

function List:getHighestPriorityLevel()
    if #self.list > 0 then
        return self.list[1][3]
    else 
        return 0
    end
end

function List:Get(i)
    if #self.list == 0 then return nil end
    return self.list[i][1], self.list[i][2], self.list[i][3]
end

function List:Insert(cast, target, priorityLevel)


    if ValidTarget(target) then

        --print("Inserting"..cast)
        if #self.list > 0 then
            local boolean, count, highestPriority = self:Contains(cast)
            if (cast:lower() == tostring("AA"):lower() or cast:lower() == tostring("Q"):lower()) and count > 2 then return
            elseif not (cast:lower() == tostring("AA"):lower() or cast:lower() == tostring("Q"):lower()) and count > 0 then 
            else
                local count2 = 1
                for i = 1, #self.list, 1 do
                    local cast1, target1, priorityLevel1 = self.list[i][1], self.list[i][2], self.list[i][3]
                    if priorityLevel <= priorityLevel1 then
                        count2 = count2 + 1
                    elseif priorityLevel > priorityLevel1 then
                        break
                    end
                end
                table.insert(self.list, count2 , {cast, target, priorityLevel})
            end
            
        else
            table.insert(self.list, #self.list + 1 , {cast, target, priorityLevel})
        end
        --[[
        if #self.list > 0 then
        print("AFTER")
        
            for i = 1, #self.list, 1 do
            local cast1, target1, priorityLevel1 = self.list[i][1], self.list[i][2], self.list[i][3]
                if ValidTarget(target1) then
                    print(cast1.." "..target1.name.." "..priorityLevel1)
                end
            end
        end
        print("--------")
        ]]
        
    end

end


function List:Contains(cast)
    local boolean, count, highestPriority = false, 0, 0
    if #self.list > 0 then
        for i = 1, #self.list, 1 do
            local cast1, target1, priorityLevel1 = self.list[i][1], self.list[i][2], self.list[i][3]
            if cast1:lower() == cast:lower() then 
                boolean = true 
                count = count + 1 
                if highestPriority == 0 then highestPriority = priorityLevel1 end
            end
        end
    end
    return boolean, count, highestPriority
end

function List:Remove(cast, quantity)
    local counter = 0
    if #self.list > 0 then
        for i = 1, #self.list, 1 do
            if not self.list[i] == nil then
                local cast1, target1, priorityLevel1 = self.list[i][1], self.list[i][2], self.list[i][3]
                if cast:lower() == cast1:lower() and counter < quantity then 
                    self:RemoveAt(i) 
                    counter = counter + 1 end
                if counter >= quantity then break end
            end
        end
    end
end

function List:RemoveAt(i)
    if #self.list > 0 then
        table.remove(self.list, 1)
    end
end

function List:RemoveAll()
    self.list = {}
end



function List:UseList(q,w,e,r1,r2,items)
    if self:Size() > 0 then

        local i = 1
        local cast, target, priorityLevel = self:Get(i)
        if not ValidTarget(target) then self:RemoveAt(i)
        else
            if Config.Misc.developer then  print("Using "..cast) end
            if cast:lower() == tostring("AA"):lower() then
               if GetDistance(myHero, target) > AA.Range(target) then self:RemoveAt(i) end
            elseif cast:lower() == tostring("Q"):lower() then
                if q then CastQ(target) else self:RemoveAt(i) end
            elseif cast:lower() == tostring("W"):lower() then
                if w then CastW(target) else self:RemoveAt(i) end
            elseif cast:lower() == tostring("E"):lower() then
                if e then CastE(target) else self:RemoveAt(i) end
            elseif cast:lower() == tostring("R1"):lower() then
                if r1 then CastR1(target) else self:RemoveAt(i) end
            elseif cast:lower() == tostring("R2"):lower() then
                if r2 then CastR2(target) else self:RemoveAt(i) end
            elseif cast:lower() == tostring("R2FAST"):lower() then
                if r2 then CastR2Fast(target) else self:RemoveAt(i) end
            elseif cast:lower() == tostring("RQ"):lower() then
                if (r1 or r2) then CastQFast(target) else self:RemoveAt(i) end 
            elseif cast:lower() == tostring("TIAMAT"):lower() then
                if items then CastTiamat(target) else self:RemoveAt(i) end
            end
        end
    end
end

function List:OnProcessSpell(unit, spell)
    if unit == nil or self.list == nil then return end
    if not unit.isMe then return end
    if unit.isMe then
        if spell.name:lower():find("rivenbasicattack") then
        elseif spell.name:lower():find("riventricleave") then
           if Config.Combo.useR2 == 3 and R.State and Q.State == 2 then 
                local target = iOrb:getTarget()
                if ValidTarget(target) then
                    self:Insert("R2FAST", target, 5) 
                end
            end
            self:Remove("Q", 1)
            --and R.IsReady() and R.State 
            
        elseif spell.name:lower():find("rivenmartyr") then
            self:Remove("W", 1)
        elseif spell.name:lower():find("rivenfeint") then
            self:Remove("E", 1)
        elseif spell.name:lower():find("rivenfengshuiengine") then
            self:Remove("R1", 1)
        elseif spell.name:lower():find("rivenizunablade") then
            self:Remove("R2", 1)
            self:Remove("R2FAST", 1)
        elseif spell.name:lower():find("tiamat") then
            self:Remove("TIAMAT", 1)
        elseif spell.name:lower():find("hydra") then
            self:Remove("TIAMAT", 1)
        end
    end
end


class("BuffManager")
function BuffManager:__init()
  self.heroes = {}
  self.buffs = {}
  for i = 1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    table.insert(self.heroes, enemy)
    self.buffs[enemy.networkID] = {}
  end
  AddTickCallback(function() self:Tick() end)
end
function BuffManager:Tick()
  for _, enemy in ipairs(self.heroes) do
    for i = 1, enemy.buffCount do
      local buf = enemy:getBuff(i)
      if self:Valid(buf) then
        local tab = {
          unit = enemy,
          buff = buf,
          slot = i,
          sent = false,
          sent2 = false
        }
        if not self.buffs[enemy.networkID][buf.name] then
          self.buffs[enemy.networkID][buf.name] = tab
        end
      end
    end
  end
  for _, tab in pairs(self.buffs) do
    for __, info in pairs(tab) do
      local buf = info.buff
      if self:Valid(buf) and not info.sent then
        local tab2 = {
          name = buf.name:lower(),
          slot = buf.slot,
          duration = buf.endT - buf.startT,
          startT = buf.startT,
          endT = buf.endT,
          stacks = buf.stacks
        }
        info.sent = true
        self:MyGainBuff(info.unit, tab2)
      elseif not self:Valid(buf) and not info.sent2 then
        local tab2 = {
          name = buf.name:lower(),
          slot = buf.slot,
          duration = buf.endT - buf.startT,
          startT = buf.startT,
          endT = buf.endT,
          stacks = buf.stacks
        }
        info.sent2 = true
        self.buffs[info.unit.networkID][buf.name] = nil
        self:MyLoseBuff(info.unit, tab2)
      end
    end
  end
end
function BuffManager:Valid(buff)
  return buff and buff.name and buff.startT <= GetGameTimer() and buff.endT >= GetGameTimer()
end
function BuffManager:MyGainBuff(unit, buff)
    if unit.isMe then
        --print("Gain: "..buff.name)
        if not buff.stacks == nil then print(buff.name) end

        --if buff.name:find("rivenpassiveaaboost") then
            --P.Stacks = 1
        --end
        if buff.name:find("riventricleavesoundone") then
            Q.State = 1
        end
        if buff.name:find("riventricleavesoundtwo") then
            Q.State = 2
        end
        if buff.name:find("riventricleavesoundthree") then
            Q.State = 3
            
        end
        if buff.name:find("rivenfengshuiengine") then
            R.State = true
        end
    end
end
function BuffManager:MyLoseBuff(unit, buff)
    if unit.isMe then
        --print("Loose: "..buff.name)
        if buff.name:find("rivenpassiveaaboost") then
            P.Stacks = 0
        end
        if buff.name:find("riventricleave") then
            Q.State = 0
        end
        if buff.name:find("rivenfengshuiengine") then
            R.State = false
        end
    end
end

--Credits to sourcelib
class("SourceUpdater")
function SourceUpdater:__init(scriptName, version, host, updatePath, filePath, versionPath)

    self.printMessage = function(message) if not self.silent then print("<font color=\"#6699ff\"><b>" .. self.UPDATE_SCRIPT_NAME .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") end end
    self.getVersion = function(version) return tonumber(string.match(version or "", "%d+%.?%d*")) end

    self.UPDATE_SCRIPT_NAME = scriptName
    self.UPDATE_HOST = host
    self.UPDATE_PATH = updatePath .. "?rand="..math.random(1,10000)
    self.UPDATE_URL = "https://"..self.UPDATE_HOST..self.UPDATE_PATH

    -- Used for version files
    self.VERSION_PATH = versionPath and versionPath .. "?rand="..math.random(1,10000)
    self.VERSION_URL = versionPath and "https://"..self.UPDATE_HOST..self.VERSION_PATH

    self.UPDATE_FILE_PATH = filePath

    self.FILE_VERSION = self.getVersion(version)
    self.SERVER_VERSION = nil

    self.silent = false

end
function SourceUpdater:SetSilent(silent)

    self.silent = silent
    return self

end
function SourceUpdater:CheckUpdate()

    local webResult = GetWebResult(self.UPDATE_HOST, self.VERSION_PATH or self.UPDATE_PATH)
    if webResult then
        if self.VERSION_PATH then
            self.SERVER_VERSION = webResult
        else
            self.SERVER_VERSION = string.match(webResult, "%s*local%s+version%s+=%s+.*%d+%.%d+")
        end
        if self.SERVER_VERSION then
            self.SERVER_VERSION = self.getVersion(self.SERVER_VERSION)
            if not self.SERVER_VERSION then
                print("SourceLib: Please contact the developer of the script \"" .. (GetCurrentEnv().FILE_NAME or "DerpScript") .. "\", since the auto updater returned an invalid version.")
                return
            end
            if self.FILE_VERSION < self.SERVER_VERSION then
                self.printMessage("New version available: v" .. self.SERVER_VERSION)
                self.printMessage("Updating, please don't press F9")
                DelayAction(function () DownloadFile(self.UPDATE_URL, self.UPDATE_FILE_PATH, function () self.printMessage("Successfully updated, please reload!") end) end, 2)
            else
                self.printMessage("You've got the latest version: v" .. self.SERVER_VERSION)
            end
        else
            self.printMessage("Something went wrong! Please manually update the script!")
        end
    else
        self.printMessage("Error downloading version info!")
    end

end
