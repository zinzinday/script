local AUTOUPDATES = true
local SCRIPTSTATUS = true
local ScriptName = "iCreative's AIO"
local version = 1.011
local champions = {["Riven"] = true, ["Xerath"] = true, ["Orianna"] = true, ["Draven"] = true, ["Lissandra"] = true}
if not champions[myHero.charName] then return end

function Immune(target)
    if TargetHaveBuff("JudicatorIntervention", target) then return true
    elseif TargetHaveBuff("UndyingRage", target) then return true
    elseif TargetHaveBuff("ZacRebirthReady", target) then return true
    elseif TargetHaveBuff("aatroxpassivedeath", target) then return true
    elseif TargetHaveBuff("FerociousHowl", target) then return true
    elseif TargetHaveBuff("VladimirSanguinePool", target) then return true
    elseif TargetHaveBuff("chronorevive", target) then return true
    elseif TargetHaveBuff("chronoshift", target) then return true
    elseif TargetHaveBuff("KarthusDeathDefiedBuff", target) then return true
    elseif TargetHaveBuff("kogmawicathiansurprise", target) then return true
    elseif TargetHaveBuff("sionpassivezombie", target) then return true
    elseif TargetHaveBuff("zhonyasringshield", target) then return true
    elseif TargetHaveBuff("zyrapqueenofthorns", target) then return true end
    return false
end
--[[
_G.ValidTarget = function(object, distance, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    return object ~= nil and object.valid and (object.team ~= player.team) == enemyTeam and object.visible and not object.dead and object.bTargetable and (enemyTeam == false or object.bInvulnerable == 0) 
    and (distance == nil or GetDistanceSqr(object) <= distance * distance)
    and (object.type == myHero.type and not Immune(object) or true)
end]]
local igniteslot, flashslot, smiteslot = nil
local Ignite    = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero) end}
local Flash     = { Range = 400, IsReady = function() return (flashslot ~= nil and myHero:CanUseSpell(flashslot) == READY) end, LastCastTime = 0}
local Smite     = { Range = 780, IsReady = function() return (smiteslot ~= nil and myHero:CanUseSpell(smiteslot) == READY) end}

local CastableItems = {
    Tiamat      = { Range = 400 , Slot   = function() return FindItemSlot("TiamatCleave") end,  reqTarget = false,  IsReady                             = function() return (FindItemSlot("TiamatCleave") ~= nil and myHero:CanUseSpell(FindItemSlot("TiamatCleave")) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end},
    Bork        = { Range = 450 , Slot   = function() return FindItemSlot("SwordOfFeastAndFamine") end,  reqTarget = true,  IsReady                     = function() return (FindItemSlot("SwordOfFeastAndFamine") ~= nil and myHero:CanUseSpell(FindItemSlot("SwordOfFeastAndFamine")) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
    Bwc         = { Range = 400 , Slot   = function() return FindItemSlot("BilgewaterCutlass") end,  reqTarget = true,  IsReady                         = function() return (FindItemSlot("BilgewaterCutlass") ~= nil and myHero:CanUseSpell(FindItemSlot("BilgewaterCutlass")) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
    Hextech     = { Range = 400 , Slot   = function() return FindItemSlot("HextechGunblade") end,  reqTarget = true,    IsReady                         = function() return (FindItemSlot("HextechGunblade") ~= nil and myHero:CanUseSpell(FindItemSlot("HextechGunblade")) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
    Blackfire   = { Range = 750 , Slot   = function() return FindItemSlot("BlackfireTorch") end,  reqTarget = true,   IsReady                           = function() return (FindItemSlot("BlackfireTorch") ~= nil and myHero:CanUseSpell(FindItemSlot("BlackfireTorch")) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
    Youmuu      = { Range = 350 , Slot   = function() return FindItemSlot("YoumusBlade") end,  reqTarget = false,  IsReady                              = function() return (FindItemSlot("YoumusBlade") ~= nil and myHero:CanUseSpell(FindItemSlot("YoumusBlade")) == READY) end, Damage = function(target) return 0 end},
    Randuin     = { Range = 500 , Slot   = function() return FindItemSlot("RanduinsOmen") end,  reqTarget = false,  IsReady                             = function() return (FindItemSlot("RanduinsOmen") ~= nil and myHero:CanUseSpell(FindItemSlot("RanduinsOmen")) == READY) end, Damage = function(target) return 0 end},
    TwinShadows = { Range = 1000, Slot   = function() return FindItemSlot("ItemWraithCollar") end,  reqTarget = false,  IsReady                         = function() return (FindItemSlot("ItemWraithCollar") ~= nil and myHero:CanUseSpell(FindItemSlot("ItemWraithCollar")) == READY) end, Damage = function(target) return 0 end},
}

local DefensiveItems = {
    Zhonyas = { Slot = function() return FindItemSlot("ZhonyasHourglass") end, IsReady = function() return (FindItemSlot("ZhonyasHourglass") ~= nil and myHero:CanUseSpell(FindItemSlot("ZhonyasHourglass")) == READY) end}
}


local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}

local Colors = { 
    -- O R G B
    Green   =  ARGB(255, 0, 180, 0), 
    Yellow  =  ARGB(255, 255, 215, 00),
    Red     =  ARGB(255, 255, 0, 0),
    White   =  ARGB(255, 255, 255, 255),
    Blue    =  ARGB(255, 0, 0, 255),
}

local ORBWALKER_MODE = {Combo = 0, Harass = 1, Clear = 3, LastHit = 4, None = -1}


function CheckUpdate()
    if AUTOUPDATES then
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.UseHttps = true
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/jachicao/BoL/master/version/".."iAIO"..".version"
        ToUpdate.ScriptPath = "/jachicao/BoL/master/".."iAIO"..".lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) PrintMessage("Updated to "..NewVersion..". Please reload with 2x F9.") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) PrintMessage("No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) PrintMessage("New Version found ("..NewVersion.."). Please wait...") end
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

    igniteslot = FindSummonerSlot("summonerdot")
    smiteslot = FindSummonerSlot("smite")
    flashslot = FindSummonerSlot("flash")

    PredictionTable = {}
    if FileExist(LIB_PATH.."VPrediction.lua") then VP = VPrediction() table.insert(PredictionTable, "VPrediction") end
    --if VIP_USER and FileExist(LIB_PATH.."Prodiction.lua") then require "Prodiction" table.insert(PredictionTable, "Prodiction") end 
    if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then require "DivinePred" DP = DivinePred() table.insert(PredictionTable, "DivinePred") end

    DelayAction(function() arrangePrioritys() end, 5)

    prediction = _Prediction()
    OM = _OrbwalkManager()

    if myHero.charName == "Riven" then
        champ = _Riven()
    elseif myHero.charName == "Xerath" then
        champ = _Xerath()
    elseif myHero.charName == "Orianna" then
        champ = _Orianna()
    elseif myHero.charName == "Draven" then
        champ = _Draven()
    elseif myHero.charName == "Lissandra" then
        champ = _Lissandra()
    end

    if champ~=nil then
        PrintMessage(champ.ScriptName.." by "..champ.Author.." loaded, Have Fun!.")
    end
end

class "_Lissandra"
function _Lissandra:__init()
    self.ScriptName = "The Ice Witch"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.Passive = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.AA = {            Range = function(target) local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q  = { Slot = _Q, Range = 715, MinRange = 715, MaxRange = 815, Width = 100, Delay = 0.25, Speed = 2250, LastCastTime = 0, Collision = false, Aoe = true, Type = "linear", LastRequest2 = 0, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end, LastRange = 0}
    self.W  = { Slot = _W, Range = 440, Width = 440, Delay = 0.25, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = "circular", IsReady = function() return (myHero:CanUseSpell(_W) == 3 or myHero:CanUseSpell(_W) == READY) end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E  = { Slot = _E, Range = 1050, Width = 110, Delay = 0.25, Speed = 850, LastCastTime = 0, Collision = false, Aoe = true, Type = "linear", IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, CastObj = nil, EndObj = nil, MissileObj = nil}
    self.R  = { Slot = _R, Range = 690, Width = 690, Delay = 0.25, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = "circular", IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
    self:LoadVariables()
    self:LoadMenu()
end

function _Lissandra:LoadVariables()
    self.LastFarmRequest = 0
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.E.Range, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."25042015")
end

function _Lissandra:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Draw","Draw circle on Target", SCRIPT_PARAM_ONOFF, true)
        self.Menu.TS:addParam("Range","Draw circle for Range", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_LIST, 2, { "Never", "If Needed" ,"Always"})
        self.Menu.Combo:addParam("useR","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Combo:addParam("useR2","Use R In Target If Is Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("Zhonyas","Use Zhonyas if %hp <", SCRIPT_PARAM_SLICE, 15, 0, 100)
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100)
    
    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useW", "Use W If Hit >=", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useE", "Use E If Hit >=", SCRIPT_PARAM_SLICE, 8, 0, 10)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use R To Interrupt", "useR")
            self.Int = _Interrupter(self.Menu.Auto.useR, self.R.Range + 500)
            self.Int:CheckChannelingSpells()
            self.Int:RegisterCallback(function(target, time, timeLimit) self:ForceR(target, time, timeLimit) end)

        self.Menu.Auto:addSubMenu("Use W To Interrupt", "useW")
            self.Int2 = _Interrupter(self.Menu.Auto.useW, self.W.Range + 500)
            self.Int2:CheckChannelingSpells()
            self.Int2:CheckGapcloserSpells()
            self.Int2:RegisterCallback(function(target, time, timeLimit) self:ForceW(target, time, timeLimit) end)

        self.Menu.Auto:addParam("useW","Use W If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Auto:addParam("useWTurret","Use W In Turret", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Auto:addParam("useRTurret","Use R In Turret", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then self.Menu.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1) end
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        if #GetEnemyHeroes() > 0 then
        self.Menu.Misc:addSubMenu("Don't Use R On: ", "DontR")
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                self.Menu.Misc.DontR:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, false)
            end
        end
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addSubMenu("Q", "Q")
            self.Menu.Draw.Q:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.Q:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.Q:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.Q:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.Q.Range/5 + 10)/2), 40), 10, math.round(self.Q.Range/5))
        self.Menu.Draw:addSubMenu("W", "W")
            self.Menu.Draw.W:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.W:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.W:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.W:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.W.Range/5 + 10)/2), 40), 10, math.round(self.W.Range/5))
        self.Menu.Draw:addSubMenu("E", "E")
            self.Menu.Draw.E:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.E:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.E:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.E:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.E.Range/5 + 10)/2), 40), 10, math.round(self.E.Range/5))
        self.Menu.Draw:addSubMenu("R", "R")
            self.Menu.Draw.R:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.R:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.R:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.R:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.R.Range/5 + 10)/2), 40), 10, math.round(self.R.Range/5))
        self.Menu.Draw:addParam("Passive", "Text if Passive Ready", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OM:LoadKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("HarassToggle", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        self.Menu.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Keys:permaShow("HarassToggle")
        self.Menu.Keys.Flee = false
        self.Menu.Keys.HarassToggle = false


    AddTickCallback(
        function()
            self.Q.Range = self:QRange(self.TS.target)
            self.TS.range = self.E.IsReady() and self.E.Range or self.Q.Range
            self.TS:update()
            
            self:CheckAuto()
            
            self:KillSteal()
            
            if OM.Mode == ORBWALKER_MODE.Combo then self:Combo()
            elseif OM.Mode == ORBWALKER_MODE.Harass then self:Harass()
            elseif OM.Mode == ORBWALKER_MODE.Clear then self:Clear() 
            elseif OM.Mode == ORBWALKER_MODE.LastHit then self:LastHit()
            end
            
            if self.Menu.Keys.HarassToggle then self:Harass() end

            if self.Menu.Keys.Flee then self:Flee() end
        end
    )

    AddProcessSpellCallback(
        function(unit, spell) 
            if myHero.dead or not self.MenuLoaded then return end
            if unit and spell and spell.name and unit.isMe then
                if spell.name:lower():find("lissandraq") then self.Q.LastCastTime = os.clock()
                elseif spell.name:lower():find("lissandraw") then self.W.LastCastTime = os.clock()
                elseif spell.name:lower():find("lissandraemissile") then self.E.LastCastTime = os.clock()
                elseif spell.name:lower():find("lissandrar") then self.R.LastCastTime = os.clock() end
            end
        end
    )

    AddCreateObjCallback(
        function(obj)
            if obj == nil then return end
            if obj.name:lower():find("lissandra") and obj.name:lower():find("passive_ready") then
                self.Passive.IsReady = true
            elseif obj.name:lower():find("linemissile") and obj.spellOwner.isMe and os.clock() - self.E.LastCastTime < 0.5 then
                self.E.MissileObj = obj
            elseif obj.name:lower():find("lissandra") and obj.name:lower():find("e_cast.troy") and os.clock() - self.E.LastCastTime < 0.5 then
                self.E.CastObj = obj
            elseif obj.name:lower():find("lissandra") and obj.name:lower():find("e_end.troy") and os.clock() - self.E.LastCastTime < 0.5 then
                self.E.EndObj = obj
            end
        end
    )
    AddDeleteObjCallback(
        function(obj)
            if obj.name:lower():find("lissandra") and obj.name:lower():find("passive_ready") then
                self.Passive.IsReady = false
            elseif self.E.MissileObj ~= nil and obj.name:lower():find("linemissile") and obj.spellOwner.isMe and GetDistanceSqr(obj, self.E.MissileObj) < 80 * 80 then 
                self.E.MissileObj = nil
            elseif self.E.CastObj ~= nil and obj.name:lower():find("lissandra") and obj.name:lower():find("e_cast.troy") and GetDistanceSqr(obj, self.E.CastObj) < 80 * 80 then 
                self.E.CastObj = nil
            elseif self.E.EndObj ~= nil and obj.name:lower():find("lissandra") and obj.name:lower():find("e_end.troy") and GetDistanceSqr(myHero, self.E.EndObj) < 80 * 80 then 
                self.E.EndObj = nil
            end
        end
    )

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
            if self.Menu.TS.Draw and ValidTarget(self.TS.target) then
                local source = self.TS.target
                DrawCircle3D(source.x, source.y, source.z, 120, 2, Colors.Red, 10)
            end
        
            if self.Menu.TS.Range then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, self.TS.range, 1, Colors.Red, 40)
            end
        
            if self.Menu.Draw.Q.Enable and self.Q.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.Q.Color
                local width     = self.Menu.Draw.Q.Width
                local range     =           self.Q.Range
                local quality   = self.Menu.Draw.Q.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.W.Enable and self.W.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.W.Color
                local width     = self.Menu.Draw.W.Width
                local range     =           self.W.Range
                local quality   = self.Menu.Draw.W.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.E.Enable and self.E.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.E.Color
                local width     = self.Menu.Draw.E.Width
                local range     =           self.E.Range
                local quality   = self.Menu.Draw.E.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.R.Enable and self.R.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.R.Color
                local width     = self.Menu.Draw.R.Width
                local range     =           self.R.Range
                local quality   = self.Menu.Draw.R.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end

            if self.Menu.Draw.Passive and self.Passive.IsReady then
                local target = self.TS.target
                if ValidTarget(target, self.TS.range) then
                    local pos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
                    DrawText("Harass Him!", 16, pos.x, pos.y, Colors.White)
                end
            end
        end
    )
    self.MenuLoaded = true
end

function _Lissandra:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth <= 0.4 and ValidTarget(enemy, self.TS.range) and enemy.visible and enemy.health > 0  then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health and enemy.health > 0 then
                if self.Q.IsReady() and self.Menu.KillSteal.useQ and (q or self.Q.Damage(enemy) > enemy.health) and not enemy.dead then self:CastQ(enemy) end
                if self.W.IsReady() and self.Menu.KillSteal.useW and (w or self.W.Damage(enemy) > enemy.health) and not enemy.dead then self:CastW(enemy) end
                if self.E.IsReady() and self.Menu.KillSteal.useE and (e or self.E.Damage(enemy) > enemy.health) and not enemy.dead then self:CastE(enemy) end
                if self.R.IsReady() and self.Menu.KillSteal.useR and (r or self.R.Damage(enemy) > enemy.health) and not enemy.dead then self:CastR(enemy) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite.Damage(enemy) > enemy.health and enemy.health > 0 then CastIgnite(enemy) end
        end
    end
end

function _Lissandra:Flee()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if self.E.IsReady() and self:IsE1() then 
        CastSpell(self.E.Slot, mousePos.x, mousePos.z)
    elseif self.E.IsReady() and not self:IsE1() then
        if self.E.EndObj~= nil then
            self:CastE2(self.E.EndObj)
        end
    end
end

function _Lissandra:CheckAuto()
    if self.W.IsReady() and self.Menu.Auto.useW > 0 and self.Menu.Auto.useW <= #self:ObjectsInArea(self.W.Range, self.W.Delay, GetEnemyHeroes()) then CastSpell(self.W.Slot) end
    if self.Menu.Auto.useWTurret and self.W.IsReady() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, self.W.Range) then
                if EnemyInMyTurret(enemy, self.W.Range) then
                    self:CastW(enemy)
                end
            end
        end
    end
    if self.Menu.Auto.useRTurret and self.R.IsReady() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, self.R.Range) then
                if EnemyInMyTurret(enemy, self.R.Range) then
                    self:CastR(enemy)
                end
            end
        end
    end
end

function _Lissandra:Combo()
    local target = self.TS.target
    if not ValidTarget(target) then return end
    if myHero.health/myHero.maxHealth *100 < self.Menu.Combo.Zhonyas and DefensiveItems.Zhonyas.IsReady() then CastSpell(DefensiveItems.Zhonyas.Slot()) end
    if self.Menu.Combo.useItems then UseItems(target) end
    if self.Menu.Combo.useR2 then
        local q, w, e, r, dmg = GetBestCombo(target)
        if r and dmg >= target.health then self:CastR(target) end
    end
    if self.R.IsReady() and self.Menu.Combo.useR > 0 and self.Menu.Combo.useR <= #self:ObjectsInArea(self.R.Range, self.R.Delay, GetEnemyHeroes()) then self:CastR(myHero) end
    if self.Menu.Combo.useE > 1 then self:CastE(target, self.Menu.Combo.useE) end
    if self.Menu.Combo.useW then self:CastW(target) end
    if self.Menu.Combo.useQ then self:CastQ(target) end
end

function _Lissandra:Harass()
    local target = self.TS.target
    if ValidTarget(target, self.TS.range) and 100 * myHero.mana / myHero.maxMana >= self.Menu.Harass.Mana then
        if self.Menu.Harass.useE then self:CastE(target) end
        if self.Menu.Harass.useQ then self:CastQ(target) end
        if self.Menu.Harass.useW then self:CastW(target) end
    end
end

function _Lissandra:Clear()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ValidTarget(minion, 900) and os.clock() - self.LastFarmRequest > 0.2 then 
                if self.Menu.LaneClear.useE > 0 and self.E.IsReady() then
                    local BestPos, Count = GetBestLineFarmPosition(self.E.Range, self.E.Width, self.EnemyMinions.objects)
                    if BestPos~=nil and Count >= self.Menu.LaneClear.useE then self:CastE(BestPos) end
                end

                if self.Menu.LaneClear.useQ > 0 and self.Q.IsReady() then
                    local BestPos, Count = GetBestLineFarmPosition(self.Q.Range, self.Q.Width, self.EnemyMinions.objects)
                    if BestPos~=nil and Count >= self.Menu.LaneClear.useQ then self:CastQ(BestPos) end
                end

                if self.Menu.LaneClear.useW > 0 and self.W.IsReady() and #self:ObjectsInArea(self.W.Range, self.W.Delay, self.EnemyMinions.objects) >= self.Menu.LaneClear.useW then
                    CastSpell(self.W.Slot)
                end
                self.LastFarmRequest = os.clock()
            end
        end
    end
    self.JungleMinions:update()
    for i, minion in pairs(self.JungleMinions.objects) do
        if ValidTarget(minion, 900) then 
            if self.Menu.JungleClear.useE and self.E.IsReady() then
                self:CastE(minion)
            end

            if self.Menu.JungleClear.useQ and self.Q.IsReady() then
                self:CastQ(minion)
            end

            if self.Menu.JungleClear.useW and self.W.IsReady() then
                self:CastW(minion)
            end
        end
    end
end

function _Lissandra:LastHit()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LastHit.Mana and os.clock() - self.LastFarmRequest > 0.05 then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ((not ValidTarget(minion, self.AA.Range(minion))) or (ValidTarget(minion, self.AA.Range(minion)) and GetDistanceSqr(minion, OM.LastTarget) > 80 * 80 and not OM:CanAttack() and OM:CanMove())) and not minion.dead then
                if self.Menu.LastHit.useW and self.W.IsReady() and not minion.dead then
                    local dmg = self.W.Damage(minion)
                    local time = self.W.Delay
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth then
                        self:CastW(minion)
                    end
                end
                if self.Menu.LastHit.useQ and self.Q.IsReady() and ValidTarget(minion, self.Q.Range + self.Q.Width/2) and not minion.dead then
                    local dmg = self.Q.Damage(minion)
                    local time = self.Q.Delay + GetDistance(minion, myHero) / self.Q.Speed + OM:Latency() - 100/1000
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        CastSpell(self.Q.Slot, minion.x, minion.z)
                    end
                end
                if self.Menu.LastHit.useE and self.E.IsReady() and ValidTarget(minion, self.E.Range) and not minion.dead then
                    local dmg = self.E.Damage(minion)
                    local time = self.E.Delay + GetDistance(minion, myHero) / self.E.Speed + OM:Latency() - 100/1000
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        self:CastE(minion)
                    end
                end
            end
        end
        self.LastFarmRequest = os.clock()
    end
end

function _Lissandra:CastQ(target)
    if self.Q.IsReady() and ValidTarget(target, self.Q.Range) then
        local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, self.Q)
        if HitChance >= 2 then 
            CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
        end
    end
end

function _Lissandra:CastW(target)
    local pos = prediction:GetPredictedPos(target, self.W.Delay)
    if self.W.IsReady() and ValidTarget(target) and GetDistanceSqr(myHero, pos) < self.W.Range * self.W.Range then
        CastSpell(self.W.Slot)
    end
end

function _Lissandra:CastE(target, m)
    local mode = m ~= nil and m or 3
    if self.E.IsReady() then
        if self:IsE1() then 
            self:CastE1(target, mode)
        else 
            local pos = prediction:GetPredictedPos(target, GetDistance(myHero, target)/self.E.Speed)
            self:CastE2(pos) 
        end
    end
end

function _Lissandra:CastE1(target, m)
    local mode = m ~= nil and m or 3
    if self.E.IsReady() and self:IsE1() then
        if mode == 2 then
            local q, w, e, r, dmg = GetBestCombo(target)
            local CastPosition,  HitChance,  Position = nil, nil, nil
            if dmg >= target.health and e then
                self:CastE1(target, 3)
            else
                local pos = prediction:GetPredictedPos(target, self.E.Delay)
                if GetDistanceSqr(myHero, pos) > (self.E.Range * 2/3) * (self.E.Range * 2/3) then
                    local CastPosition, HitChance, Position = prediction:GetPrediction(target, self.E)
                    if CastPosition~=nil then 
                        CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
                    end
                end
            end
        elseif mode == 3 then
            local CastPosition, HitChance, Position = prediction:GetPrediction(target, self.E)
            if HitChance >= 2 then 
                CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
            end
        end
    end
end

function _Lissandra:CastE2(Position)
    if self.E.EndObj ~= nil and self.E.CastObj ~= nil and self.E.MissileObj ~=nil and Position ~= nil then
        local vectorNearToPos = VectorPointProjectionOnLine(self.E.CastObj, self.E.EndObj, Position)
        if GetDistanceSqr(self.E.EndObj, self.E.MissileObj) < 80 * 80 then
            CastSpell(self.E.Slot)
        elseif GetDistanceSqr(vectorNearToPos, self.E.MissileObj) < 60 * 60 and GetDistanceSqr(myHero, Position) < GetDistanceSqr(myHero, self.E.MissileObj) then
            CastSpell(self.E.Slot)
        end
    end
end

function _Lissandra:CastR(champion)
    if self.R.IsReady() then
        if champion.team == myHero.team then
            CastSpell(self.R.Slot, champion)
        elseif ValidTarget(champion, self.R.Range) and not self.Menu.Misc.DontR[champion.charName] then
            CastSpell(self.R.Slot, champion)
        end
    end
end

function _Lissandra:ForceW(target, time, timeLimit)
    if not ValidTarget(target) or os.clock() - time > timeLimit then return end
    if self.W.IsReady() and ValidTarget(target, self.W.Range + 500) then
        self:CastW(target)
    end
    if ValidTarget(target, self.W.Range + 500) then
        DelayAction(function(target, time, timeLimit) self:ForceW(target, time, timeLimit) end, 0.1, {target, time, timeLimit})
    end
end

function _Lissandra:ForceR(target, time, timeLimit)
    if not ValidTarget(target) or os.clock() - time > timeLimit then return end
    if self.R.IsReady() and ValidTarget(target, self.R.Range + 500) then
        self:CastR(target)
    end
    if ValidTarget(target, self.R.Range + 500) then
        DelayAction(function(target, time, timeLimit) self:ForceR(target, time, timeLimit) end, 0.1, {target, time, timeLimit})
    end
end

function _Lissandra:QRange(target)
    local range = self.Q.MinRange
    if ValidTarget(target, self.Q.MaxRange + 50) and os.clock() - self.Q.LastRequest2 > 0.1 then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, self.Q.Delay, self.Q.Width, self.Q.Range, self.Q.Speed, myHero, self.Q.Collision)
        if CastPosition~=nil then
            local function CountObjectsOnLineSegment(StartPos, EndPos, range, width, objects)
                local n = 0
                for i, object in ipairs(objects) do
                    if ValidTarget(object, range) then
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
                        local w = width --+ VP:GetHitBox(object) / 3
                        if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
                            n = n + 1
                            if n > 0 then return n end
                        end
                    end
                end
                return n
            end
            local EndPos = Vector(myHero) + range * (Vector(CastPosition) - Vector(myHero)):normalized()
            self.EnemyMinions:update()
            local n = CountObjectsOnLineSegment(myHero, EndPos, range, self.Q.Width, self.EnemyMinions.objects)
            if n > 0 then
                range = self.Q.MaxRange 
            else
                local n2 = CountObjectsOnLineSegment(myHero, EndPos, range, self.Q.Width, GetEnemyHeroes())
                if n2 > 0 then 
                    range = self.Q.MaxRange
                end
            end
        end
        self.Q.LastRequest2 = os.clock()
        self.Q.LastRange = range
    elseif os.clock() - self.Q.LastRequest2 <= 0.1 then
        return self.Q.LastRange > 0 and self.Q.LastRange or range
    end
    return range
end

function _Lissandra:IsE1()
    return self.E.MissileObj == nil
end

function _Lissandra:ObjectsInArea(range, delay, array)
    local objects2 = {}
    local delay = delay or 0
    if array ~= nil then
        for i, object in ipairs(array) do
            if ValidTarget(object, range * 2) then
                local Position = prediction:GetPredictedPos(object, delay)
                if GetDistanceSqr(myHero, Position) <= range * range then
                    table.insert(objects2, object)
                end
            end
        end
    end
    return objects2
end

function _Lissandra:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q.Damage(target)
            currentManaWasted = currentManaWasted + self.Q.Mana()
        end
        if w then
            comboDamage = comboDamage + self.W.Damage(target)
            currentManaWasted = currentManaWasted + self.W.Mana()
        end
        if e then
            comboDamage = comboDamage + self.E.Damage(target)
            currentManaWasted = currentManaWasted + self.E.Mana()
        end
        if r then
            comboDamage = comboDamage + self.R.Damage(target)
            comboDamage = comboDamage + self.Q.Damage(target)
            currentManaWasted = currentManaWasted + self.R.Mana()
        end
        comboDamage = comboDamage + self.AA.Damage(target) * 2
        comboDamage = comboDamage + DamageItems(target)
        local iDmg = Ignite.IsReady() and Ignite.Damage(target) or 0
        comboDamage = comboDamage + iDmg
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Lissandra:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Orianna"
function _Orianna:__init()
    self.ScriptName = "The Ball Is Angry"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.Passive = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.AA = {            Range = function(target) return 620 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q  = { Slot = _Q, Range = 825, Width = 130, Delay = 0, Speed = 1200, Type = "linear", LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end}
    self.W  = { Slot = _W, Range = 225, Width = 225, Delay = 0.15, Speed = math.huge, Type = "circular", LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E  = { Slot = _E, Range = 1095, Width = 85, Delay = 0.15, Speed = 1700, Type = "linear", LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, Missile = nil}
    self.R  = { Slot = _R, Range = 370, Width = 370, Delay = 0.3, Speed = math.huge, Type = "circular", LastCastTime = 0, Collision = false, Aoe = true, ControlPressed = false, Sent = 0, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
    self:LoadVariables()
    self:LoadMenu()
end

function _Orianna:LoadVariables()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.Q.Range + self.Q.Width, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, self.Q.Range + self.Q.Width, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."24042015")
    self.LastFarmRequest = 0
end

function _Orianna:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Draw","Draw circle on Target", SCRIPT_PARAM_ONOFF, true)
        self.Menu.TS:addParam("Range","Draw circle for Range", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW", "Use W If Enemies >= ", SCRIPT_PARAM_SLICE, 1, 0, 5)
        self.Menu.Combo:addParam("useE","Use E For Damage", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE2","Use E If % Health <=", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
        self.Menu.Combo:addParam("useR","Use R If Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR2","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5)
        self.Menu.Combo:addParam("useIgnite","Use Ignite If Killable", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useE","Use E For Damage", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE2","Use E If % Health <=", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useW", "Use W If Hit >=", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useE", "Use E If Hit >=", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use R To Interrupt", "useR")
            self.Int = _Interrupter(self.Menu.Auto.useR, self.Q.Range + self.R.Range)
            self.Int:CheckChannelingSpells()
            self.Int:RegisterCallback(function(target, time, timeLimit) self:ForceR(target, time, timeLimit) end)

        self.Menu.Auto:addSubMenu("Use E To Initiate", "useE")
            self.Ini = _Initiator(self.Menu.Auto.useE, self.E.Range + 500)
            self.Ini:CheckGapcloserSpells()
            self.Ini:RegisterCallback(function(target, time, timeLimit) self:ForceE(target, time, timeLimit) end)

        self.Menu.Auto:addParam("useW", "Use W If Enemies >= ", SCRIPT_PARAM_SLICE, 3, 0, 5)
        self.Menu.Auto:addParam("useR", "Use R If Enemies >= ", SCRIPT_PARAM_SLICE, 4, 0, 5)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then self.Menu.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1) end
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        if VIP_USER then self.Menu.Misc:addParam("BlockR", "Block R If Will Not Hit", SCRIPT_PARAM_ONOFF, false) end
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addSubMenu("Q", "Q")
            self.Menu.Draw.Q:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.Q:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.Q:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.Q:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.Q.Range/5 + 10)/2), 40), 10, math.round(self.Q.Range/5))
        self.Menu.Draw:addSubMenu("W", "W")
            self.Menu.Draw.W:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.W:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.W:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.W:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.W.Range/5 + 10)/2), 40), 10, math.round(self.W.Range/5))
        self.Menu.Draw:addSubMenu("E", "E")
            self.Menu.Draw.E:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.E:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.E:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.E:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.E.Range/5 + 10)/2), 40), 10, math.round(self.E.Range/5))
        self.Menu.Draw:addSubMenu("R", "R")
            self.Menu.Draw.R:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.R:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.R:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.R:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.R.Range/5 + 10)/2), 40), 10, math.round(self.R.Range/5))
        self.Menu.Draw:addSubMenu("Ball Position", "BallPosition")
            self.Menu.Draw.BallPosition:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.BallPosition:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.BallPosition:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.BallPosition:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, 10, 10, math.round(self.Q.Width/5))
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OM:LoadKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        self.Menu.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

        self.Menu.Keys:permaShow("HarassToggle")
        self.Menu.Keys.HarassToggle = false
        self.Menu.Keys.Run = false

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.TS.range = self.Q.Range + self.Q.Width
            self.TS.target = _GetTarget()
            self.TS:update()
            if OM.Mode == ORBWALKER_MODE.Combo then self:Combo()
            elseif OM.Mode == ORBWALKER_MODE.Harass then self:Harass()
            elseif OM.Mode == ORBWALKER_MODE.Clear then self:Clear() 
            elseif OM.Mode == ORBWALKER_MODE.LastHit then self:LastHit()
            end

            if self.Menu.KillSteal.useQ or self.Menu.KillSteal.useW or self.Menu.KillSteal.useE or self.Menu.KillSteal.useR or self.Menu.KillSteal.useIgnite then self:KillSteal() end

            if ValidTarget(self.TS.target) and (self.Menu.Auto.useW > 0 or self.Menu.Auto.useR > 0) then self:Auto() end

            if self.Menu.Keys.HarassToggle then self:Harass() end
            if self.Menu.Keys.Run then self:Run() end
        end
    )

    AddProcessSpellCallback(
        function(unit, spell)
            if myHero.dead or unit == nil or not self.MenuLoaded then return end
            if not unit.isMe then return end
            if spell.name:lower():find("oriana") and spell.name:lower():find("izuna") and spell.name:lower():find("command") then self.Q.LastCastTime = os.clock()
            elseif spell.name:lower():find("oriana") and spell.name:lower():find("dissonance") and spell.name:lower():find("command") then self.W.LastCastTime = os.clock()
            elseif spell.name:lower():find("oriana") and spell.name:lower():find("redact") and spell.name:lower():find("command") then self.E.LastCastTime = os.clock()
            elseif spell.name:lower():find("oriana") and spell.name:lower():find("detonate") and spell.name:lower():find("command") then self.R.LastCastTime = os.clock()
            end
        end
    )

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
            if self.Menu.TS.Draw and ValidTarget(self.TS.target) then
                local source = self.TS.target
                DrawCircle3D(source.x, source.y, source.z, 120, 2, Colors.Red, 10)
            end
        
            if self.Menu.TS.Range then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, self.TS.range, 1, Colors.Red, 40)
            end
        
            if self.Menu.Draw.Q.Enable and self.Q.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.Q.Color
                local width     = self.Menu.Draw.Q.Width
                local range     =           self.Q.Range
                local quality   = self.Menu.Draw.Q.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.W.Enable and self.W.IsReady() then
                local source    = self.Position
                local color     = self.Menu.Draw.W.Color
                local width     = self.Menu.Draw.W.Width
                local range     =           self.W.Range
                local quality   = self.Menu.Draw.W.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.E.Enable and self.E.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.E.Color
                local width     = self.Menu.Draw.E.Width
                local range     =           self.E.Range
                local quality   = self.Menu.Draw.E.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.R.Enable and self.R.IsReady() then
                local source    = self.Position
                local color     = self.Menu.Draw.R.Color
                local width     = self.Menu.Draw.R.Width
                local range     =           self.R.Range
                local quality   = self.Menu.Draw.R.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end

            if self.Menu.Draw.BallPosition.Enable then
                local source    = self.Position
                local color     = self.Menu.Draw.BallPosition.Color
                local width     = self.Menu.Draw.BallPosition.Width
                local range     =           self.Q.Width
                local quality   = self.Menu.Draw.BallPosition.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        end
    )


    --BALL MANAGER
    self.Position = myHero
    self.TimeLimit = 0.1
    self.ValidDistance = 2000
    for i = 1, objManager.maxObjects do
        local object = objManager:getObject(i)
        if object and object.name and object.valid and object.name:lower():find("doomball") then
            self.Position = object
        end
    end

    AddAnimationCallback(
        function(unit, animation)
            if unit.isMe and animation == 'Prop' then
                self.Position = myHero
            end
        end
    )

    AddCreateObjCallback(
        function(obj)
            if obj.name:lower():find("orianna") and obj.name:lower():find("yomu") and obj.name:lower():find("ring") and obj.name:lower():find("green") then
                self.Position = obj
            elseif obj.name:lower():find("orianna") and obj.name:lower():find("ball") and obj.name:lower():find("flash") then
                self.Position = myHero
            elseif obj.name:lower():find("linemissile") and obj.spellOwner.isMe and (os.clock() - self.Q.LastCastTime < 0.5 or os.clock() - self.E.LastCastTime < 0.5) then
                self.Position = obj
            end
        end
    )
    AddDeleteObjCallback(
        function(obj) 
            if obj.name:lower():find("orianna") and obj.name:lower():find("yomu") and obj.name:lower():find("ring") and obj.name:lower():find("green") and GetDistanceSqr(myHero, obj) < 150 * 150 then
                self.Position = myHero
            end
        end
     )
    AddProcessSpellCallback(
        function(unit, spell)
            if unit and spell and unit.isMe and spell.name:lower():find("oriana") and spell.name:lower():find("redact") and spell.name:lower():find("command") then
                DelayAction(function(pos) self.Position = pos end, self.E.Delay + GetDistance(spell.endPos, self.Position) / self.E.Speed, {spell.target})
            end
        end
    )
    AddTickCallback(
        function() 
            if not self.Position.valid or GetDistanceSqr(myHero, self.Position) > self.ValidDistance * self.ValidDistance then 
                self.Position = myHero 
            end 
        end
    )
    if VIP_USER then 
        HookPackets() 
    end
    if VIP_USER then
        AddCastSpellCallback(
            function(iSpell, startPos, endPos, targetUnit) 
                if iSpell == self.R.Slot and #self:ObjectsInArea(self.R.Range, self.R.Delay, GetEnemyHeroes()) == 0  then
                    self.R.Sent = os.clock() - OM:Latency()
                end
            end
        )
    end
    if VIP_USER then 
        AddSendPacketCallback(
            function(p)
                p.pos = 2
                if myHero.networkID == p:DecodeF() then
                    if self.Menu.Misc.BlockR and os.clock() - self.R.Sent < self.TimeLimit and self.R.Sent > 0 and self.R.IsReady() then
                            Packet(p):block()
                    end
                end
            end
        ) 
    end
    self.MenuLoaded = true
end

function _Orianna:ObjectsInArea(range, delay, array)
    local objects2 = {}
    local delay = delay or 0
    if array ~= nil then
        for i, object in ipairs(array) do
            if ValidTarget(object, self.Q.Range * 2.5) then
                local Position = prediction:GetPredictedPos(object, delay)
                if GetDistanceSqr(self.Position, Position) <= range * range then
                    table.insert(objects2, object)
                end
            end
        end
    end
    return objects2
end

function _Orianna:CastQ(target)
    if ValidTarget(target, self.Q.Range + self.W.Width / 2) and self.Q.IsReady() then
        local delay = self.Q.Delay --+ (GetDistance(p1, p2)/Q.Speed - 1)
        local range = GetDistance(self.Position, target) --+ W.Width / 2 --Q.Range
        prediction:SetSource(self.Position)
        local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, self.Q)
        if CastPosition~=nil and HitChance >= 2 then
            CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
        end
    end
end

function _Orianna:CastW(target)
    if self.W.IsReady() and ValidTarget(target, self.Q.Range + self.W.Width/2) then
        local Position = prediction:GetPredictedPos(target, self.W.Delay)
        if GetDistanceSqr(self.Position, Position) < self.W.Range * self.W.Range then 
            CastSpell(self.W.Slot)
        end
    end
end

function _Orianna:CastE(unit)
    if unit ~= nil then
        if self.E.IsReady() and unit.valid and unit.team == myHero.team and GetDistanceSqr(myHero, unit) < self.E.Range * self.E.Range then
            CastSpell(self.E.Slot, unit)
        elseif self.E.IsReady() and unit.valid and unit.team ~= myHero.team then
            local table = nil
            if unit.type:lower():find("hero") then 
                table = GetEnemyHeroes()
            else 
                self.EnemyMinions:update()
                if #self.EnemyMinions.objects > 0 then
                    table = self.EnemyMinions.objects 
                else
                    self.JungleMinions:update()
                    if #self.JungleMinions.objects > 0 then
                        table = self.JungleMinions.objects
                    end
                end
            end
            if table~= nil then
                local BestPos, BestHit = self:BestHitE(table)
                if BestHit~=nil and BestHit > 0 and BestPos~=nil and BestPos.team == myHero.team then
                    self:CastE(BestPos)
                end
            end
        end
    end
end

function _Orianna:CastR(target)
    if self.R.IsReady() and ValidTarget(target, self.Q.Range + self.R.Range) then
        local Position = prediction:GetPredictedPos(target, self.R.Delay)
        if GetDistanceSqr(Position, self.Position) < self.R.Range * self.R.Range then
            CastSpell(self.R.Slot)
        end
    end
end



function _Orianna:Combo()
    local target = self.TS.target
    if ValidTarget(target) then
        if self.Menu.Combo.useIgnite and Ignite.IsReady() and ValidTarget(target, Ignite.Range) then 
            local q, w, e, r, dmg = GetBestCombo(target)
            if dmg >= target.health and target.health > 0 then
                CastIgnite(target)
            end
        end
        if self.Menu.Combo.useE then
            self:CastE(target)
        end

        if self.Menu.Combo.useE2 > 0 and myHero.health/myHero.maxHealth * 100 <= self.Menu.Combo.useE2 then
            self:CastE(myHero)
        end

        if self.Menu.Combo.useQ then 
            self:CastQ(target) 
        end
        if self.W.IsReady() and self.Menu.Combo.useW > 0 and #self:ObjectsInArea(self.W.Range, self.W.Delay, GetEnemyHeroes()) >= self.Menu.Combo.useW then
            CastSpell(self.W.Slot)
        end
        if self.Menu.Combo.useR and self.R.IsReady() and #self:ObjectsInArea(self.R.Range, self.R.Delay, GetEnemyHeroes()) <= 2 then
            local q, w, e, r, dmg = GetBestCombo(target)
            if dmg >= target.health and r then
                self:CastR(target)
            end
        end
        if self.R.IsReady() and self.Menu.Combo.useR2 > 0 and self.Menu.Combo.useR2 <= #self:ObjectsInArea(self.R.Range, self.R.Delay, GetEnemyHeroes()) then
            CastSpell(self.R.Slot)
        end
    end
end

function _Orianna:Harass()
    local target = self.TS.target
    if ValidTarget(target) and myHero.mana/myHero.maxMana * 100 >= self.Menu.Harass.Mana then
        if self.Menu.Harass.useE then self:CastE(target) end
        if self.Menu.Harass.useE2 > 0 and myHero.health/myHero.maxHealth * 100 <= self.Menu.Harass.useE2 and ValidTarget(target, GetAARange(target)) then self:CastE(myHero) end
        if self.Menu.Harass.useW then self:CastW(target) end
        if self.Menu.Harass.useQ then self:CastQ(target) end
    end
end

function _Orianna:Clear()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ValidTarget(minion, self.Q.Range + self.Q.Width) and os.clock() - self.LastFarmRequest > 0.2 then 
                if self.Menu.LaneClear.useE > 0 and self.E.IsReady() then
                    local BestPos, Count = self:BestHitE(self.EnemyMinions.objects)
                    if BestPos~=nil and self.Menu.LaneClear.useE <= Count then
                        self:CastE(BestPos)
                    end
                end

                if self.Menu.LaneClear.useQ > 0 and self.Q.IsReady() then
                    local BestPos, Count = self:BestHitQ(self.EnemyMinions.objects)
                    if BestPos~=nil and self.Menu.LaneClear.useQ <= Count then
                        self:CastQ(BestPos)
                    end
                end

                if self.Menu.LaneClear.useW > 0 and self.W.IsReady() then
                    local Count = #self:ObjectsInArea(self.W.Range, self.W.Delay, self.EnemyMinions.objects)
                    if self.Menu.LaneClear.useW <= Count then 
                        CastSpell(self.W.Slot)
                    end
                end
                self.LastFarmRequest = os.clock()
            end
        end
    end

    self.JungleMinions:update()
    for i, minion in pairs(self.JungleMinions.objects) do
        if ValidTarget(minion, self.Q.Range + self.Q.Width) then 
            if self.Menu.JungleClear.useE and self.E.IsReady() then
                self:CastE(minion)
            end

            if self.Menu.JungleClear.useQ and self.Q.IsReady() then
                CastSpell(self.Q.Slot, minion.x, minion.z)
            end

            if self.Menu.JungleClear.useW and self.W.IsReady() then
                self:CastW(minion)
            end
        end
    end
end


function _Orianna:ThrowBallTo(target, width)
    local EAlly = nil
    if self.E.IsReady() and GetDistanceSqr(self.Position, target) > width * width then
        
        local Position = prediction:GetPredictedPos(target, self.E.Delay + GetDistance(self.Position, target)/self.E.Speed)
        for i = 1, heroManager.iCount do
            local ally = heroManager:GetHero(i)
            if ally.team == player.team and GetDistanceSqr(myHero, ally) < self.E.Range * self.E.Range and GetDistanceSqr(self.Position, ally) > 50 * 50  then
                local Position3 = prediction:GetPredictedPos(ally, self.E.Delay + GetDistance(self.Position, ally)/self.E.Speed)
                if GetDistanceSqr(Position3, Position) <= width * width then
                    if EAlly == nil then 
                        EAlly = ally
                    else
                        local Position2 = prediction:GetPredictedPos(EAlly, self.E.Delay + GetDistance(self.Position, EAlly)/self.E.Speed)
                        if GetDistanceSqr(Position, Position2) > GetDistanceSqr(Position, Position3) then 
                            EAlly = ally
                        end
                    end
                end
            end
        end
    end

    if EAlly~=nil and GetDistanceSqr(EAlly, target) <= width * width then
        self:CastE(EAlly)
    elseif self.Q.IsReady() then
        self:CastQ(target)
    end
end

function _Orianna:BestHitQ(objects)
    local BestPos 
    local BestHit = 0

    local function CountObjectsOnLineSegment(StartPos, EndPos, width, objects2)
        local n = 0
        for i, object in ipairs(objects2) do
            local Position = prediction:GetPredictedPos(object, self.Q.Delay + GetDistance(StartPos, object)/self.Q.Speed)
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
            local w = width --+ VP:GetHitBox(object) / 3
            if isOnSegment and GetDistanceSqr(pointSegment, Position) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, Position) then
                n = n + 1
            end
        end
        return n
    end
    for i, object in ipairs(objects) do
        if ValidTarget(object, self.Q.Range) then
            local Position = prediction:GetPredictedPos(object, self.Q.Delay + GetDistance(self.Position, object)/self.Q.Speed)
            local hit = CountObjectsOnLineSegment(self.Position, Position, self.Q.Width, objects) + 1
            if hit > BestHit then
                BestHit = hit
                BestPos = object--Vector(object)
                if BestHit == #objects then
                   break
                end
            end
        end
    end
    return BestPos, BestHit
end

function _Orianna:BestHitE(objects)

    local function HitE(StartPos, EndPos, width, objects)
        local n = 0
        --StartPos = Vector(StartPos.x, 0, StartPos.z)
        for i, object in ipairs(objects) do
            local Position = prediction:GetPredictedPos(object, self.E.Delay + GetDistance(StartPos, object)/self.E.Speed)
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
            local w = width --+ VP:GetHitBox(object) / 3
            if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
                n = n + 1
            end
        end
        return n
    end

    local tab = {}
    local BestAlly = nil 
    local BestHit = 0
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team == player.team and hero.health > 0 then
            --print(GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(hero.x, 0 , hero.z)))
            if GetDistanceSqr(myHero, hero) < self.E.Range * self.E.Range and GetDistanceSqr(self.Position, hero) > 50 * 50 then
                local Position = prediction:GetPredictedPos(hero, self.E.Delay + GetDistance(self.Position, hero)/self.E.Speed)
                local hit = HitE(self.Position, Position, self.E.Width, objects)
                if hit > BestHit then
                    BestHit = hit
                    BestAlly = hero--Vector(hero)
                    if BestHit == #objects then
                       break
                    end
                end
            end
        end
    end
    return BestAlly, BestHit
    -- body
end

function _Orianna:LastHit()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LastHit.Mana and os.clock() - self.LastFarmRequest > 0.05 then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ((not ValidTarget(minion, self.AA.Range(minion))) or (ValidTarget(minion, self.AA.Range(minion)) and GetDistanceSqr(minion, OM.LastTarget) > 80 * 80 and not OM:CanAttack() and OM:CanMove())) and not minion.dead then
                if self.Menu.LastHit.useW and self.W.IsReady() and not minion.dead then
                    local dmg = self.W.Damage(minion)
                    local time = self.W.Delay
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth then
                        self:CastW(minion)
                    end
                end
                if self.Menu.LastHit.useQ and self.Q.IsReady() and ValidTarget(minion, self.Q.Range + self.Q.Width/2) and not minion.dead then
                    local dmg = self.Q.Damage(minion)
                    local time = self.Q.Delay + GetDistance(minion, self.Position) / self.Q.Speed + OM:Latency() - 100/1000
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        CastSpell(self.Q.Slot, minion.x, minion.z)
                    end
                end
                if self.Menu.LastHit.useE and self.E.IsReady() and GetDistanceSqr(myHero, self.Position) > 50 * 50 and GetDistanceSqr(myHero, self.Position) > GetDistanceSqr(myHero, minion) and not minion.dead then
                    local dmg = self.E.Damage(minion)
                    local time = self.E.Delay + GetDistance(minion, self.Position) / self.E.Speed + OM:Latency() - 100/1000
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        local Position = prediction:GetPredictedPos(minion, self.E.Delay + GetDistance(minion, self.Position) / self.E.Speed)
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(self.Position, myHero, Position)
                        if isOnSegment and GetDistanceSqr(pointSegment, object) < self.E.Width * self.E.Width then
                            CastE(myHero)
                        end
                    end
                end
            end
        end
        self.LastFarmRequest = os.clock()
    end
end
function _Orianna:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth <= 0.4 and ValidTarget(enemy, self.TS.range) and enemy.visible and enemy.health > 0  then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health and enemy.health > 0 then
                if self.Q.IsReady() and self.Menu.KillSteal.useQ and (q or self.Q.Damage(enemy) > enemy.health) and not enemy.dead then self:CastQ(enemy) end
                if self.W.IsReady() and self.Menu.KillSteal.useW and (w or self.W.Damage(enemy) > enemy.health) and not enemy.dead then self:CastW(enemy) end
                if self.E.IsReady() and self.Menu.KillSteal.useE and (e or self.E.Damage(enemy) > enemy.health) and not enemy.dead then self:CastE(enemy) end
                if self.R.IsReady() and self.Menu.KillSteal.useR and (r or self.R.Damage(enemy) > enemy.health) and not enemy.dead then self:CastR(enemy) end
                if (((w or self.W.Damage(enemy) > enemy.health) and self.Menu.KillSteal.useW) or ((r or self.R.Damage(enemy) > enemy.health) and self.Menu.KillSteal.useR)) and (self.Menu.KillSteal.useQ or self.Menu.KillSteal.useE) and not enemy.dead then self:ThrowBallTo(enemy, self.R.Width) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite.Damage(enemy) > enemy.health and enemy.health > 0 then CastIgnite(enemy) end
        end
    end
end
function _Orianna:Auto()
    if self.W.IsReady() and self.Menu.Auto.useW > 0 and #self:ObjectsInArea(self.W.Range, self.W.Delay, GetEnemyHeroes()) >= self.Menu.Auto.useW then
        CastSpell(self.W.Slot)
    end
    if self.R.IsReady() and self.Menu.Auto.useR > 0 and #self:ObjectsInArea(self.R.Range, self.R.Delay, GetEnemyHeroes()) >= self.Menu.Auto.useR then
        CastSpell(self.R.Slot)
    end
end

function _Orianna:Run()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if self.E.IsReady() and GetDistanceSqr(self.Position, myHero) > self.W.Width * self.W.Width then
        self:CastE(myHero)
    elseif self.Q.IsReady() and GetDistanceSqr(self.Position, myHero) > self.W.Width * self.W.Width then
        CastSpell(self.Q.Slot, myHero.x, myHero.z)
    end

    if self.W.IsReady() and GetDistanceSqr(self.Position, myHero) < self.W.Width * self.W.Width then
        CastSpell(self.W.Slot)
    end
end


function _Orianna:ForceE(target, time, timeLimit)
    if os.clock() - time > timeLimit then return end
    if self.E.IsReady() and GetDistanceSqr(target, myHero) < self.E.Range * self.E.Range and ValidTarget(self.TS.target) then
        self:CastE(target)
    end
    if GetDistanceSqr(target, myHero) < (self.E.Range + 500) * (self.E.Range + 500) then
        DelayAction(function(target, time, timeLimit) self:ForceE(target, time, timeLimit) end, 0.1, {target, time, timeLimit})
    end
end

function _Orianna:ForceR(target, time, timeLimit)
   if not ValidTarget(target) or os.clock() - time > timeLimit then return end
    if self.R.IsReady() and GetDistanceSqr(target, self.Position) < self.R.Range * self.R.Range then
        self:CastR(target)
    elseif self.Q.IsReady() and GetDistanceSqr(target, self.Position) < (self.Q.Range + self.R.Width) * (self.Q.Range + self.R.Width) then
        self:ThrowBallTo(target, self.R.Width)
    end
    if ValidTarget(target, self.Q.Range + self.R.Width) then
        DelayAction(function(target, time, timeLimit) self:ForceR(target, time, timeLimit) end, 0.1, {target, time, timeLimit})
    end
end

function _Orianna:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q.Damage(target)
            currentManaWasted = currentManaWasted + self.Q.Mana()
        end
        if w then
            comboDamage = comboDamage + self.W.Damage(target)
            currentManaWasted = currentManaWasted + self.W.Mana()
        end
        if e then
            comboDamage = comboDamage + self.E.Damage(target)
            currentManaWasted = currentManaWasted + self.E.Mana()
        end
        if r then
            comboDamage = comboDamage + self.R.Damage(target)
            currentManaWasted = currentManaWasted + self.R.Mana()
        end
        comboDamage = comboDamage + self.AA.Damage(target)
        comboDamage = comboDamage + DamageItems(target)
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Orianna:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Xerath"
function _Xerath:__init()
    self.ScriptName = "Lightning Does Strike Twice"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.P = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.AA      = {            Range = 580 , Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q       = { Slot = _Q, Range = 1400, MinRange = 750, MaxRange = 1400, Offset = 0, Width = 100, Delay = 0.6, Speed = math.huge, LastCastTime = 0, LastCastTime2 = 0, Collision = false, Aoe = true, Type = "linear", IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end, IsCharging = false, TimeToStopIncrease = 1.5 , End = 3, SentTime = 0, LastFarmCheck = 0, Sent = false}
    self.W       = { Slot = _W, Range = 1100, Width = 150, Delay = 0.7, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = "circular", IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end, LastFarmCheck = 0}
    self.E       = { Slot = _E, Range = 1050, Width = 60, Delay = 0.25, Speed = 1600, LastCastTime = 0, Collision = true, Aoe = false, Type = "linear", IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, Missile = nil}
    self.R       = { Slot = _R, Range = 3200, Width = 120, Delay = 0.7, Speed = math.huge, LastCastTime = 0, LastCastTime2 = 0, Collision = false, Aoe = true, Type = "circular", IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end, IsCasting = false, Stacks = 3, ResetTime = 10, MaxStacks = 3, Target = nil, SentTime = 0, Sent = false}
    self:LoadVariables()
    self:LoadMenu()
end

function _Xerath:LoadVariables()
    self.TimeLimit = 0.1
    self.QPacket = 49
    self.DataUpdated = false
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.Q.MaxRange + self.Q.Offset, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, self.Q.MaxRange + self.Q.Offset, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 750, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."3.000")
end

function _Xerath:LoadMenu()

    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Draw","Draw circle on Target", SCRIPT_PARAM_ONOFF, true)
        self.Menu.TS:addParam("Range","Draw circle for Range", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR","Use R If Killable", SCRIPT_PARAM_LIST, 1, { "Never", "If Necessary", "Always"})

    self.Menu:addSubMenu(myHero.charName.." - Ultimate Settings", "Ultimate")
        self.Menu.Ultimate:addParam("rMode","R Mode", SCRIPT_PARAM_LIST, 1, {"AutoShoot", "Using Key"})
        self.Menu.Ultimate:addParam("Delay", "Delay between shoots", SCRIPT_PARAM_SLICE, 0, 0, 1.5, 1)
        self.Menu.Ultimate:addParam("TapKey", "R Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Ultimate:addSubMenu("Near Mouse Settings", "NearMouse")
            self.Menu.Ultimate.NearMouse:addParam("Enable","Only Near Mouse", SCRIPT_PARAM_ONOFF, false)
            self.Menu.Ultimate.NearMouse:addParam("MouseRadius", "Near Mouse Radius", SCRIPT_PARAM_SLICE, 500, 100, 1500)
            self.Menu.Ultimate.NearMouse:addParam("DrawRadius", "Draw Near Mouse Radius", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Ultimate:addParam("KillableR","Draw Text If Killable with R", SCRIPT_PARAM_ONOFF, true)
        if VIP_USER then self.Menu.Ultimate:addParam("BlockMove", "Block Movement When Casting R", SCRIPT_PARAM_ONOFF, true) end

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useW", "Use W If Hit >=", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use E To Interrupt", "useE")
            self.Int = _Interrupter(self.Menu.Auto.useE, self.E.Range + 500)
            self.Int:CheckGapcloserSpells()
            self.Int:CheckChannelingSpells()
            self.Int:RegisterCallback(function(target, time, timeLimit) self:ForceE(target, time, timeLimit) end)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then self.Menu.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1) end
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        self.Menu.Misc:addParam("SmartCast", "Using Smart Cast", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Misc:addParam("Bugsplat", "Q is Crashing?", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addSubMenu("Q", "Q")
            self.Menu.Draw.Q:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.Q:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.Q:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.Q:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.Q.Range/5 + 10)/2), 40), 10, math.round(self.Q.Range/5))
        self.Menu.Draw:addSubMenu("W", "W")
            self.Menu.Draw.W:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.W:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.W:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.W:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.W.Range/5 + 10)/2), 40), 10, math.round(self.W.Range/5))
        self.Menu.Draw:addSubMenu("E", "E")
            self.Menu.Draw.E:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.E:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.E:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.E:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.E.Range/5 + 10)/2), 40), 10, math.round(self.E.Range/5))
        self.Menu.Draw:addSubMenu("R", "R")
            self.Menu.Draw.R:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.R:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.R:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.R:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.R.Range/5 + 10)/2), 40), 10, math.round(self.R.Range/5))
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OM:LoadKeys(self.Menu.Keys)
        OM:LoadKey("UseE", "Cast E", SCRIPT_PARAM_ONKEYDOWN, string.byte("E"), ORBWALKER_MODE.Combo)
        self.Menu.Keys:addParam("WaitE", "Start with E (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Z"))
        self.Menu.Keys:permaShow("WaitE")

    if not VIP_USER then
        PrintMessage(self.ScriptName, "Hi! This script for free users doesn't start the Q correctly, but you can charge the Q by yourself and the script will shoot the Q.")
    end

    AddTickCallback(
        function() 
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self:UpdateValues()
        
            if self.R.IsCasting then self:CheckCastingR() return end
            if not self.R.IsCasting and self.Menu.Ultimate.TapKey then self:CastR() end
            self:KillSteal()
        
            if OM.Mode == ORBWALKER_MODE.Combo then 
                if OM.KeysMenu.UseE then
                    local target = nil
                    for idx, enemy in ipairs(GetEnemyHeroes()) do
                        if ValidTarget(enemy, self.E.Range) then
                            if target == nil then target = enemy
                            elseif GetDistanceSqr(myHero, target) > GetDistanceSqr(myHero, enemy) then target = enemy
                            end
                        end
                    end
                    if ValidTarget(target, self.E.Range) then
                        self:CastE(target)
                    end
                else
                    self:Combo()
                end
            elseif OM.Mode == ORBWALKER_MODE.Harass then self:Harass()
            elseif OM.Mode == ORBWALKER_MODE.Clear then self:Clear() 
            elseif OM.Mode == ORBWALKER_MODE.LastHit then
            end
        end
    )
    AddProcessSpellCallback(
        function(unit, spell)
            if myHero.dead or self.Menu == nil or not self.MenuLoaded or unit == nil or not unit.isMe then return end
            if spell.name:lower():find("xeratharcanopulsechargeup") then 
                self.Q.LastCastTime = os.clock()
                self.Q.IsCharging = true
                OM:DisableAttacks()
            elseif spell.name:lower():find("xeratharcanopulse2") then 
                self.Q.LastCastTime2 = os.clock()
                self.Q.IsCharging = false
                OM:EnableAttacks()
            elseif spell.name:lower():find("xeratharcanebarrage2") then 
                self.W.LastCastTime = os.clock()
            elseif spell.name:lower():find("xerathmagespear") then 
                self.E.LastCastTime = os.clock()
            elseif spell.name:lower():find("xerathlocusofpower2") then 
                self.R.LastCastTime = os.clock()
                self.R.IsCasting = true
                self.R.LastCastTime2 = os.clock()
                OM:DisableMovement()
                OM:DisableAttacks()
                DelayAction(function() self.R.Stacks = self.R.MaxStacks self.R.Target = nil self.R.IsCasting = false end, self.R.ResetTime)
            elseif spell.name:lower():find("xerathrmissilewrapper") then 
            elseif spell.name:lower():find("xerathlocuspulse") then
                self.R.LastCastTime2 = os.clock()
                self.R.Stacks = self.R.Stacks - 1
                OM:DisableAttacks()
            end
        end
    )
    AddMsgCallback( 
        function(msg, key)
            if self.Menu == nil or not self.MenuLoaded then return end
            if msg == KEY_UP then
                if self.Q.IsReady() and self.Q.IsCharging and key == string.byte("Q") and self.Menu.Misc.SmartCast and not IsKeyDown(17) then
                    self:CastQ2(mousePos)
                end
            elseif msg == KEY_DOWN then
                if self.Q.IsReady() and not self.Q.IsCharging and key == string.byte("Q") and not IsKeyDown(17) then
                    self:CastQ1(mousePos)
                end
            elseif msg == WM_LBUTTONUP then
                if self.Q.IsReady() and self.Q.IsCharging and not IsKeyDown(17) then
                    self:CastQ2(mousePos)
                end
        
            elseif msg == WM_RBUTTONUP then
                if self.R.IsReady() and self.R.IsCasting and self.R.Stacks > 0 and not ValidTarget(self:FindBestKillableTarget()) then
                    self.R.IsCasting = false
                end
            end
        end
    )
    AddCreateObjCallback(
        function(obj)
            if obj and os.clock() - self.E.LastCastTime < 0.5 and obj.name:lower():find("linemissile") and obj.spellOwner.isMe then 
                self.E.Missile = obj
                DelayAction(function() self.E.Missile = nil end, self.E.Delay + (self.E.Range / self.E.Speed) * 1.5)
            elseif obj and obj.name:lower():find("xerath") and obj.name:lower():find("_q") and obj.name:lower():find("_cas") and obj.name:lower():find("_charge") then
                self.Q.IsCharging = true
            elseif obj and obj.name:lower():find("xerath") and obj.name:lower():find("_r") and obj.name:lower():find("_buf") then
                self.R.IsCasting = true
            end
        end
    )
    AddDeleteObjCallback(
        function(obj)
            if obj and self.E.Missile ~= nil and GetDistanceSqr(obj, self.E.Missile) < 100 * 100 then 
                self.E.Missile = nil
            elseif obj and obj.name:lower():find("xerath") and obj.name:lower():find("_q") and obj.name:lower():find("_cas") and obj.name:lower():find("_charge") then
                self.Q.IsCharging = false
            elseif obj and obj.name:lower():find("xerath") and obj.name:lower():find("_r") and obj.name:lower():find("_buf") then
                self.R.IsCasting = false
            end
        end
    )
    if VIP_USER then HookPackets() end
    if VIP_USER then 
        AddSendPacketCallback(
            function(p) 
                p.pos = 2
                if myHero.networkID == p:DecodeF() then
                    if not self.DataUpdated and self.Q.IsCharging and self.Q.Sent then
                        --if self.QPacket ~= p.header then PrintMessage("qPacket is "..p.header..", you can change this value manually on the top of this script. To prevent bad Q's.") end
                        self.QPacket = p.header
                        self.DataUpdated = true
                    end
                    if self.Q.IsCharging and not self.Q.Sent and (p.header == self.QPacket or not self.DataUpdated) and not self.Menu.Misc.Bugsplat then
                        --if self.Menu.Misc.developer then PrintMessage("Blocking Q") end
                        Packet(p):block()
                    end
                    if self.R.IsCasting and not self.R.Sent and self.Menu.Ultimate.BlockMove and ValidTarget(self:FindBestTarget(myHero, self.R.Range)) then
                        Packet(p):block()
                    end
                end
            end
        ) 
    end
    if VIP_USER then 
        AddCastSpellCallback(
            function(iSpell, startPos, endPos, targetUnit) 
                if iSpell == self.R.Slot then
                    self.R.Sent = true
                    DelayAction(function() self.R.Sent = false end, self.TimeLimit + OM:Latency())
                end 
            end
        )
    end

    AddDrawCallback(
        function() 
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
            if self.Menu.TS.Draw and ValidTarget(self.TS.target) then
                local source = self.TS.target
                DrawCircle3D(source.x, source.y, source.z, 120, 2, Colors.Red, 10)
            end
        
            if self.Menu.TS.Range then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, self:GetRange(), 1, Colors.Red, 40)
            end
        
            if self.Menu.Draw.Q.Enable and self.Q.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.Q.Color
                local width     = self.Menu.Draw.Q.Width
                local range     =           self.Q.Range
                local quality   = self.Menu.Draw.Q.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.W.Enable and self.W.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.W.Color
                local width     = self.Menu.Draw.W.Width
                local range     =           self.W.Range
                local quality   = self.Menu.Draw.W.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.E.Enable and self.E.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.E.Color
                local width     = self.Menu.Draw.E.Width
                local range     =           self.E.Range
                local quality   = self.Menu.Draw.E.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.R.Enable and self.R.IsReady() then
                local source    = myHero
                local color     = self.Menu.Draw.R.Color
                local width     = self.Menu.Draw.R.Width
                local range     =           self.R.Range
                local quality   = self.Menu.Draw.R.Quality
                DrawCircleMinimap(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Ultimate.KillableR and (self.R.IsReady() or self.R.IsCasting) then
                for idx, enemy in ipairs(GetEnemyHeroes()) do
                    local count = 0
                    if ValidTarget(enemy, self.R.Range) then
                        if self.R.Damage(enemy) * self.R.Stacks >= enemy.health then
                            local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
                            if OnScreen(p.x, p.y) then
                                DrawText("R KILL", 25, p.x, p.y,  Colors.Red)
                            end
                            DrawText(enemy.charName:upper().." KILLABLE", 35, 100, 50 + 50 * count,  Colors.Red)
                            count = count + 1
                        end
                    end
                end
            end
        end
    )
    self.MenuLoaded = true
end


function _Xerath:UpdateValues()
    if self.Q.IsCharging then
        self.Q.Range = math.min((self.Q.MaxRange - self.Q.MinRange) / self.Q.TimeToStopIncrease * (os.clock() - self.Q.LastCastTime), self.Q.MaxRange - self.Q.MinRange) + self.Q.MinRange + math.min(self.Q.Offset * (os.clock() - self.Q.LastCastTime)/self.Q.TimeToStopIncrease, self.Q.Offset)
    else 
        self.Q.Range = self.Q.MaxRange + self.Q.Offset
    end
    self.R.Range = 2000 + 1200 * myHero:GetSpellData(self.R.Slot).level
    self.TS.range = self:GetRange()
    self.TS.target = _GetTarget()
    self.TS:update()
    if self.R.IsReady() or self.R.IsCasting then
        self.R.Target = self:FindBestKillableTarget()
    end

    if self:CanMove() then OM:EnableMovement() else OM:DisableMovement() end
    if self:CanAttack() then OM:EnableAttacks() else OM:DisableAttacks() end
end


function _Xerath:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health > 0 and enemy.health/enemy.maxHealth < 0.3 and GetDistanceSqr(myHero, enemy) < self.R.Range * self.R.Range then
            if ValidTarget(enemy) then
                local q, w, e, r, dmg = GetBestCombo(enemy) 
                if dmg >= enemy.health then
                    if self.Menu.KillSteal.useQ and (q or self.Q.Damage(enemy) > enemy.health) and not enemy.dead then self:CastQ(enemy) end
                    if self.Menu.KillSteal.useW and (w or self.W.Damage(enemy) > enemy.health) and not enemy.dead then self:CastW(enemy) end
                    if self.Menu.KillSteal.useE and (e or self.E.Damage(enemy) > enemy.health) and not enemy.dead then self:CastE(enemy) end
                    if self.Menu.KillSteal.useR and (r or self.R.Damage(enemy) * self.R.Stacks > enemy.health) and not enemy.dead then self:CastR() end
                end
                if self.Menu.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead then CastIgnite(enemy) end
            elseif not enemy.visible and not enemy.dead and not self.Q.IsCharging and not self.R.IsCasting then
                if myHero:GetSpellData(ITEM_7).name:lower():find("trinketorblvl") and myHero:CanUseSpell(ITEM_7) == READY then
                    CastSpell(ITEM_7, enemy.x, enemy.z)
                elseif myHero:GetSpellData(SUMMONER_1).name:lower():find("clairvoyance") and myHero:CanUseSpell(SUMMONER_1) == READY then
                    CastSpell(SUMMONER_1, enemy.x, enemy.z)
                elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("clairvoyance") and myHero:CanUseSpell(SUMMONER_2) == READY then
                    CastSpell(SUMMONER_2, enemy.x, enemy.z)
                end
            end
        end
    end
end

function _Xerath:Combo()
    local target = self.TS.target
    if ValidTarget(target) then
        if self.Menu.Combo.useR > 1 then
            if self.Menu.Combo.useR == 2 then
                local q, w, e, r, dmg = GetBestCombo(target)
                if self.R.Damage(target) * self.R.Stacks >= target.health and (r or GetDistanceSqr(myHero, target) > self.W.Range * self.W.Range) then
                    self:CastR()
                end
            elseif self.Menu.Combo.useR == 3 then
                if self.R.Damage(target) * self.R.Stacks >= target.health then
                    self:CastR()
                end
            end
        end
        if self.Menu.Combo.useE then self:CastE(target) end
        if self.Menu.Keys.WaitE and ( self.E.IsReady() or (self.E.Missile ~= nil and GetDistanceSqr(myHero, self.E.Missile) <= GetDistanceSqr(myHero, target) ) ) then return end
        if self.Menu.Combo.useW then self:CastW(target) end
        if self.Menu.Combo.useQ then self:CastQ(target) end
    end
end

function _Xerath:Harass()
    local target = self.TS.target
    if ValidTarget(target) and myHero.mana/myHero.maxMana * 100 >= self.Menu.Harass.Mana then
        if self.Menu.Harass.useE then self:CastE(target) end
        if self.Menu.Keys.WaitE and ( self.E.IsReady() or (self.E.Missile ~= nil and GetDistanceSqr(myHero, self.E.Missile) <= GetDistanceSqr(myHero, target) ) ) then return end
        if self.Menu.Harass.useW then self:CastW(target) end
        if self.Menu.Harass.useQ then self:CastQ(target) end
    end
    if ValidTarget(target) and self.Q.IsCharging then self:CastQ(target) end
end

function _Xerath:Clear()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ValidTarget(minion, self.Q.MaxRange + self.Q.Offset) then 
                if self.Menu.LaneClear.useE and self.E.IsReady() then
                    self:CastE(minion)
                end

                if self.Menu.LaneClear.useQ > 0 and self.Q.IsReady() and os.clock() - self.Q.LastFarmCheck > 0.1 then
                    local BestPos, Count = GetBestLineFarmPosition(self.Q.Range, self.Q.Width, self.EnemyMinions.objects)
                    self.Q.LastFarmCheck = os.clock()
                    if not self.Q.IsCharging then
                        if self.Menu.LaneClear.useQ <= Count then
                            self:CastQ(BestPos)
                        end
                    elseif self.Q.IsCharging then
                        if self.Menu.LaneClear.useQ <= Count then
                            self:CastQ(BestPos)
                        elseif os.clock() - self.Q.LastCastTime > 0.9 * self.Q.End then
                            self:CastQ(BestPos)
                        end
                    end
                end

                if self.Menu.LaneClear.useW > 0 and self.W.IsReady()  and os.clock() - self.W.LastFarmCheck > 0.1  then
                    local BestPos, Count = GetBestCircularFarmPosition(self.W.Range, self.W.Width + 50, self.EnemyMinions.objects)
                    self.W.LastFarmCheck = os.clock()
                    if BestPos ~= nil and self.Menu.LaneClear.useW <= Count then self:CastW(BestPos) end
                end
            end
        end
    end
    self.JungleMinions:update()
    for i, minion in pairs(self.JungleMinions.objects) do
        if ValidTarget(minion, self.Q.MaxRange  + self.Q.Offset) then 
            if self.Menu.JungleClear.useE and self.E.IsReady() then
                self:CastE(minion)
            end

            if self.Menu.JungleClear.useQ and self.Q.IsReady() then
                self:CastQ(minion)
            end

            if self.Menu.JungleClear.useW and self.W.IsReady() then
                self:CastW(minion)
            end
        end
    end
end

function _Xerath:CheckCastingR()
    if os.clock() - self.R.LastCastTime2 > self.Menu.Ultimate.Delay then
        if self.Menu.Ultimate.rMode == 1 then
            self:CastR()
        elseif self.Menu.Ultimate.rMode == 2 then
            if self.Menu.Ultimate.TapKey then
                self:CastR()
            end
        end
    end
end

function _Xerath:CastQ(target)
    if self.Q.IsReady() and ValidTarget(target) then
        if not self.Q.IsCharging then
            local delay = math.max(GetDistance(myHero, target) - self.Q.MinRange, 0) / ((self.Q.MaxRange - self.Q.MinRange) / self.Q.TimeToStopIncrease) + self.Q.Delay
            local Position = prediction:GetPredictedPos(target, delay)
            if GetDistanceSqr(myHero, Position) < self.Q.MaxRange * self.Q.MaxRange then
                self:CastQ1(Position)
            end
        elseif self.Q.IsCharging and ValidTarget(target, self.Q.Range) then
            local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, self.Q)
            if CastPosition~=nil and HitChance >= 2 then
                self:CastQ2(CastPosition)
            elseif os.clock() - self.Q.LastCastTime >= 0.9 * self.Q.End and GetDistanceSqr(myHero, target) <= self.Q.Range * self.Q.Range then
                self:CastQ2(CastPosition)
            end
        end
    end
end

function _Xerath:CastQ1(Position)
    if self.Q.IsReady() and Position and not self.Q.IsCharging and VIP_USER then --
        CastSpell(self.Q.Slot, Position.x, Position.z)
    end
end

function _Xerath:CastQ2(Position)
    if self.Q.IsReady() and Position and self.Q.IsCharging and not self.Menu.Misc.Bugsplat then
        local d3vector = D3DXVECTOR3(Position.x, Position.y, Position.z)
        self.Q.Sent = true
        CastSpell2(self.Q.Slot, d3vector)
        self.Q.Sent = false
    end
end


function _Xerath:CastW(target)
    if self.W.IsReady() and ValidTarget(target, self.W.Range) then
        local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, self.W)
        if CastPosition~=nil and HitChance >= 2 then 
            CastSpell(self.W.Slot, CastPosition.x, CastPosition.z)
        end
    end
end

function _Xerath:CastE(target)
    if self.E.IsReady() and ValidTarget(target, self.E.Range) then
        local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, self.E)
        if CastPosition~=nil and HitChance >= 2 then 
            CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
        end
    end
end

function _Xerath:CastR()
    if self.R.IsReady() and ValidTarget(self.R.Target, self.R.Range) then
        if not self.R.IsCasting then 
            self:CastR1()
        else
            self:CastR2()
        end
    end
end

function _Xerath:CastR1()
    if not self.R.IsCasting and self.R.IsReady() then CastSpell(self.R.Slot) end
end

function _Xerath:CastR2()
    if self.R.IsCasting and self.R.IsReady() then
        local target = nil
        if self.Menu.Ultimate.NearMouse.Enable then 
            target = self:FindBestTarget(mousePos, self.Menu.Ultimate.NearMouse.MouseRadius)
        else
            target = self.R.Target
        end
        if ValidTarget(target, self.R.Range) then
            local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, self.R)
            if CastPosition~=nil and HitChance >= 2 then
                CastSpell(self.R.Slot, CastPosition.x, CastPosition.z)
            end
        end
    end
end

function _Xerath:ForceE(target, time, timeLimit)
    if not ValidTarget(target) or os.clock() - time > timeLimit then return end
    if self.E.IsReady() and ValidTarget(target, self.E.Range + 500) then
        self:CastE(target)
    end
    if ValidTarget(target, self.E.Range + 500) then
        DelayAction(function(target, time, timeLimit) self:ForceE(target, time, timeLimit) end, 0.1, {target, time, timeLimit})
    end
end

function _Xerath:GetRange()
    local r = 0
    if self.Q.IsReady() then r = self.Q.Range end
    if self.Q.IsReady() and self.Q.IsCharging then r = self.Q.MaxRange end
    local range = math.max(r, self.W.IsReady() and self.W.Range or 0, self.E.IsReady() and self.E.Range or 0, self.AA.Range)
    return range
end

function _Xerath:FindBestKillableTarget()
    local bestTarget = nil
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if self.R.Damage(enemy) * self.R.Stacks * self:GetOverkill() >= enemy.health and ValidTarget(enemy, self.R.Range) then
            if bestTarget == nil then
                bestTarget = enemy
            elseif (enemy.health - self.R.Damage(enemy) * self.R.Stacks) / enemy.maxHealth < (bestTarget.health - self.R.Damage(bestTarget) * self.R.Stacks) / bestTarget.maxHealth  then
                bestTarget = enemy
            end
        end
    end
    return bestTarget
end

function _Xerath:FindBestTarget(from, range)
    local bestTarget = nil
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, self.R.Range) and GetDistanceSqr(from, enemy) <= range * range then
            if bestTarget == nil then
                bestTarget = enemy
            elseif (enemy.health -  self.R.Damage(enemy) * self.R.Stacks) / enemy.maxHealth < (bestTarget.health - self.R.Damage(bestTarget) * self.R.Stacks) / bestTarget.maxHealth  then
                bestTarget = enemy
            end
        end
    end
    return bestTarget
end

function _Xerath:CanMove()
    if self.R.IsCasting then return false end
    return true
end

function _Xerath:CanAttack()
    if self.R.IsCasting then return false
    elseif self.Q.IsCharging then return false
    end
    return true
end

function _Xerath:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q.Damage(target)
            currentManaWasted = currentManaWasted + self.Q.Mana()
        end
        if w then
            comboDamage = comboDamage + self.W.Damage(target)
            currentManaWasted = currentManaWasted + self.W.Mana()
        end
        if e then
            comboDamage = comboDamage + self.E.Damage(target)
            currentManaWasted = currentManaWasted + self.E.Mana()
        end
        if r then
            comboDamage = comboDamage + self.R.Damage(target) * self.R.Stacks
            currentManaWasted = currentManaWasted + self.R.Mana()
        end
        comboDamage = comboDamage + self.AA.Damage(target)
        comboDamage = comboDamage + DamageItems(target)
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Xerath:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Riven"
function _Riven:__init()
    self.ScriptName = "Mighty Riven"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.P = { Damage = function(target) return getDmg("P", target, myHero) end, Stacks = 0, LastCastTime = 0}
    self.R       = { TS = nil, Slot = _R, Range = 1100, Width = 300, Delay = 0.25, Speed = 2200, LastCastTime = 0, Type = "cone", Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Damage = function(target) return getDmg("R", target, myHero) end, State = false}
    self.AA      = { Range = function(target) local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 + 50 end, Reset = false, OffsetRange = 150 ,Damage = function(target) return getDmg("AD", target, myHero) end, LastCastTime = 0}
    self.Q       = { TS = nil, Slot = _Q, Range = 250, Width = 100, Delay = 0.25, Speed = 1400, LastCastTime = 0, Type = "circular", Collision = false, Aoe = true, TimeReset = 4, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Damage = function(target) return getDmg("Q", target, myHero) end, State = 0}
    self.W       = { TS = nil, Slot = _W, Range = 260, Width = 250, Delay = 0.25, Speed = 1500, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E       = { TS = nil, Slot = _E, Range = 325, Width = 250, Delay = 0.3, Speed = 1450, LastCastTime = 0, Type = "circular", Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Damage = function(target) return getDmg("E", target, myHero) end}
    self:LoadVariables()
    self.wallJump        = WallJump()
    self.queue = _Queue()
    self:LoadMenu()
end

function _Riven:LoadVariables()
    OM:RegisterAfterAttackCallback(function() self:AfterAttack() end)
    OM:TakeControl()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.R.Range, DAMAGE_PHYSICAL)
    self.R.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.R.Range, DAMAGE_PHYSICAL)
    self.W.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.W.Range, DAMAGE_PHYSICAL)
    self.AllyMinions     = minionManager(MINION_ALLY, 600, myHero, MINION_SORT_HEALTH_ASC)
    self.EnemyMinions    = minionManager(MINION_ENEMY, 600, myHero, MINION_SORT_HEALTH_ASC)
    self.JungleMinions   = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."1.001")
end

function _Riven:LoadMenu()
    if self.Menu == nil then return end

    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Combo", "Range for Combo", SCRIPT_PARAM_SLICE, 900, 150, 1100, 0)
        self.Menu.TS:addParam("Harass", "Range for Harass", SCRIPT_PARAM_SLICE, 350, 150, 900, 0)
        self.Menu.TS:addParam("Draw","Draw circle on Target", SCRIPT_PARAM_ONOFF, true)
        self.Menu.TS:addParam("Range","Draw circle for Range", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR1","Use R1: ", SCRIPT_PARAM_LIST, 2, {"Never", "If Needed", "Always"})
        self.Menu.Combo:addParam("useR2","Use R2: ", SCRIPT_PARAM_LIST, 2, {"Never", "If Killable", "Between Q2 - Q3"})
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useTiamat", "Use Tiamat", SCRIPT_PARAM_LIST, 1, {"To Cancel Animation", "To Make Damage"})
        self.Menu.Combo:addParam("useIgnite","Use Ignite If Killable", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        --self.Menu.Harass:addParam("harassMode","Harass Mode", SCRIPT_PARAM_LIST, 1, {"Typical", "Q1 Q2 W Q3 E"}) --, "E W Q1 Q2 Q3", "E Q1 W Q2 Q3"
        self.Menu.Harass:addParam("useTiamat","Use Tiamat or Hydra", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)

     self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useTiamat","Use Tiamat or Hydra", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useTiamat","Use Tiamat or Hydra", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR2","Use R2", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addParam("AutoStackQ", "Don't lose Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Auto:addParam("AutoW", "Use W if Enemies >=", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
        self.Menu.Auto:addParam("AutoEW", "Use EW if Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Auto:addParam("AutoE", "Use E to run if Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Auto:addParam("AutoERange", "Use E to run Vision", SCRIPT_PARAM_SLICE, 300, 120, 900)

    self.Menu:addSubMenu(myHero.charName.." - WallJump Settings", "WallJump")
        self.Menu.WallJump:addParam("MinRange", "Min. Width of Wall", SCRIPT_PARAM_SLICE, 50, 50, 380)
        self.Menu.WallJump:addParam("MaxRange", "Max. Width of Wall", SCRIPT_PARAM_SLICE, 380, 50, 380)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then self.Menu.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1) end
        self.Menu.Misc:addParam("useCancelAnimation","Use Cancel Animation", SCRIPT_PARAM_LIST, 2, {"Never", "mousePos", "Joke", "Taunt", "Dance", "Laugh"})
        self.Menu.Misc:addParam("cancelR","Cancel R Animation", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Misc:addParam("humanizer", "Humanizer Delay (in seconds)", SCRIPT_PARAM_SLICE, 0, 0, 0.7, 1)
        self.Menu.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        self.Menu.Misc:addParam("enemyTurret","Don't cast on enemy turret", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Misc:addParam("developer","Developer mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Draw Settings", "Draw")
        self.Menu.Draw:addSubMenu("Q", "Q")
        self.Menu.Draw.Q:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw.Q:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
        self.Menu.Draw.Q:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
        self.Menu.Draw.Q:addParam("Quality","Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.Q.Range/5 + 10)/2), 40), 10, math.round(self.Q.Range/5))
        self.Menu.Draw:addSubMenu("W", "W")
        self.Menu.Draw.W:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw.W:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
        self.Menu.Draw.W:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
        self.Menu.Draw.W:addParam("Quality","Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.W.Range/5 + 10)/2), 40), 10, math.round(self.W.Range/5))
        self.Menu.Draw:addSubMenu("E", "E")
        self.Menu.Draw.E:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw.E:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
        self.Menu.Draw.E:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
        self.Menu.Draw.E:addParam("Quality","Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.E.Range/5 + 10)/2), 40), 10, math.round(self.E.Range/5))
        self.Menu.Draw:addSubMenu("R", "R")
        self.Menu.Draw.R:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw.R:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
        self.Menu.Draw.R:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
        self.Menu.Draw.R:addParam("Quality","Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.R.Range/5 + 10)/2), 40), 10, math.round(self.R.Range/5))
        self.Menu.Draw:addParam("TimeQ", "Show Time Left for Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

        self.Menu.Draw:addParam("dmgCalc","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OM:LoadKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("FlashCombo","Use R Flash (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        self.Menu.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Keys:addParam("WallJump", "Wall Jump (Beta)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))
        self.Menu.Keys:permaShow("FlashCombo")

        self.Menu.Keys.FlashCombo = false
        self.Menu.Keys.Run     = false
        self.Menu.Keys.WallJump     = false

    PrintMessage(self.ScriptName, "If the Orbwalker cancel your AA, go to Orbwalk Manager and modify the value of Extra WindUpTime, between 80 - 180 should be OK.")
    AddDrawCallback(function() self:OnDraw() end)
    AddTickCallback(function() self:OnTick() end)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    AddAnimationCallback(
        function(unit, animationName)
            if unit.isMe then
                if animationName:lower():find("idle") then
                elseif animationName:lower():find("attack") then
                elseif animationName:lower():find("idle1") then
                elseif animationName:lower():find("spell1a") then
                    self.Q.State = 1
                elseif animationName:lower():find("spell1b") then
                    self.Q.State = 2
                elseif animationName:lower():find("spell1c") then
                    self.Q.State = 3
                    DelayAction(function() self.Q.State = 0 end, 1)
                end
            end
        end
    )
    AddCreateObjCallback(
        function(obj)
            --if obj and GetDistance(obj, myHero) < 1000 then print("Created: "..obj.name) end
            if obj and obj.name and obj.name:lower():find("_q") and obj.name:lower():find("_trail") then
                if obj.name:lower():find("01") then
                    self.Q.State = 1
                elseif obj.name:lower():find("02") then
                    self.Q.State = 2
                elseif obj.name:lower():find("03") then
                    self.Q.State = 3
                end
            elseif obj and obj.name and obj.name:lower():find("riven") and obj.name:lower():find("_r") and obj.name:lower():find("_buff.troy") then
                self.R.State = true
                DelayAction(function() self.R.State = false end, 15)
            end 
        end
    )
    AddDeleteObjCallback(
        function(obj)
            --if obj and GetDistance(obj, myHero) < 1000 then print("Deleted: "..obj.name) end
            if obj and obj.name and obj.name:lower():find("_p") and obj.name:lower():find("_buff") then
                self.P.Stacks = 0
            elseif obj and obj.name and obj.name:lower():find("_q") and obj.name:lower():find("_detonate") and obj.name:lower():find("03") then
                self.Q.State = 0
            elseif obj and obj.name and obj.name:lower():find("riven") and obj.name:lower():find("_r") and obj.name:lower():find("_buff.troy") then
                self.R.State = false
            end
        end
    )
    self.MenuLoaded = true
end

function _Riven:UpdateValues()
    self.TS.range = self:GetRange()
    self.TS:update()
    if self.W.IsReady() then self.W.TS:update() end
    if self.R.IsReady() then self.R.TS:update() end
    if os.clock() - self.R.LastCastTime < 15 and not self.R.LastCastTime == 0 then
        if self.Q.State == 2 then
            self.Q.Width = 180
        else
            self.Q.Width = 150
        end
        self.W.Width    = 270
        self.W.Range    = 270
    else
        if self.Q.State == 2 then
            self.Q.Width = 150
        else
            self.Q.Width = 100
        end
        self.W.Width    = 250
        self.W.Range    = 250
    end
end

function _Riven:ShouldUseAA()
    if (OM.GotReset or self.P.Stacks > 2) and OM.Mode ~= ORBWALKER_MODE.None then
        local target = OM:ObjectInRange(self.AA.OffsetRange)
        if ValidTarget(target) then
            if self:RequiresAA(target) and (OM.Mode == ORBWALKER_MODE.Combo or OM.Mode == ORBWALKER_MODE.Harass) then
                return true
            elseif (OM.Mode == ORBWALKER_MODE.LastHit or OM.Mode == ORBWALKER_MODE.Clear) then
                return true
            end
        end
    end
    return false
end

function _Riven:OnTick()
    if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
    self:UpdateValues()

    if self.Menu.Keys.Run then self:Run()
    elseif self.Menu.Keys.WallJump then self:Jump() end

    local aa = os.clock() - self.AA.LastCastTime
    local q = os.clock() - self.Q.LastCastTime
    local w = os.clock() - self.W.LastCastTime
    local e = os.clock() - self.E.LastCastTime
    local r = os.clock() - self.R.LastCastTime
    local min = math.min(aa, q, w, e, r)
    if min < self.Menu.Misc.humanizer then return end
    if not OM:CanCast() then return end
    if self.Menu.KillSteal.useQ or self.Menu.KillSteal.useW or self.Menu.KillSteal.useIgnite or self.Menu.KillSteal.useR2 or self.Menu.Combo.useR2 == 2 then
        self:KillSteal()
    end

    if self.Menu.Misc.enemyTurret and UnitAtTurret(self.TS.target, 0) and UnitAtTurret(myHero, self.Q.Range) then return end
    if self:ShouldUseAA() then return end

    self:CheckAuto()
    if OM.Mode == ORBWALKER_MODE.Combo then self:Combo()
    elseif OM.Mode == ORBWALKER_MODE.Harass then self:Harass()
    elseif OM.Mode == ORBWALKER_MODE.Clear then self:Clear()
    elseif OM.Mode == ORBWALKER_MODE.LastHit then self:LastHit() end

    if self.Q.IsReady() and self.Q.State > 0 and os.clock() - self.Q.LastCastTime >= self.Q.TimeReset * 0.9 and os.clock() - self.Q.LastCastTime < self.Q.TimeReset and self.Q.LastCastTime > 0 and OM.Mode ~= ORBWALKER_MODE.None then
        CastSpell(self.Q.Slot, mousePos.x, mousePos.z)
    end
end

function _Riven:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.4 and ValidTarget(enemy, self.R.Range) and enemy.visible then
            if self.Menu.KillSteal.useQ and self.Q.Damage(enemy) > enemy.health and not enemy.dead then self:CastQ(enemy) end
            if self.Menu.KillSteal.useW and self.W.Damage(enemy) > enemy.health and not enemy.dead then self:CastW(enemy) end
            if self.Menu.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead then CastIgnite(enemy) end
            if (self.Menu.KillSteal.useR2 or self.Menu.Combo.useR2 == 2 or self.Menu.Combo.useR2 == 4) and self.R.Damage(enemy) > enemy.health and not enemy.dead then self:CastR2(enemy) end
        end
    end
end

function _Riven:CheckAuto()
    if self.Menu.Auto.AutoW > 0 and self.W.IsReady() and CountEnemies(myHero, self.W.Range) >= self.Menu.Auto.AutoW then
        CastSpell(self.W.Slot)
    end

    if self.W.IsReady() and self.Menu.Auto.AutoEW > 0 and self.E.IsReady() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, self.E.Range + self.W.Width/2) and self.E.IsReady() and self.W.IsReady() and self.Menu.Auto.AutoEW > 0 then
                local CastPosition, HitChance, Count = VP:GetCircularAOECastPosition(enemy, self.W.Delay, self.W.Width, self.E.Range, self.E.Speed, myHero)
                if Count ~= nil and Count >= self.Menu.Auto.AutoEW then
                    CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
                    DelayAction(function() CastSpell(self.W.Slot) end, 0.2)
                    break
                end
            end
        end
    end

    if self.E.IsReady() and self.Menu.Auto.AutoE > 0 and not OM.Mode ~= ORBWALKER_MODE.Combo then
        if CountEnemies(myHero, self.Menu.Auto.AutoERange) >= self.Menu.Auto.AutoE  then
            local safePlace = self:GetSafePlace(self.TS.target)
            if safePlace ~= nil and safePlace.valid then
                local pos = myHero + Vector(Vector(safePlace) - Vector(myHero)):normalized() * self.E.Range
                CastSpell(self.E.Slot, pos.x, pos.z)
            end
        end
    end
end


function _Riven:Combo()
    local target = self.TS.target
    if ValidTarget(target, self.TS.range) then
        if self.Menu.Combo.useItems then UseItems(self.TS.target) end
        if self.Menu.Combo.useIgnite and Ignite.IsReady() then
            local p, aa, q, w, e, r1, r2, items = self:GetBestCombo(target)
            local dmg, mana = self:GetComboDamage(target, p, aa, q, w, e, r1, r2, items)
            if dmg > target.health then CastIgnite(target) end
        end
        if self.queue:Size() > 0 then
            if self.Menu.Combo.useW then self:CastW() end
            self.queue:Execute()
        else
            if self.Menu.Combo.useR1 > 1 or self.Menu.Combo.useR2 > 1 then self:CastR() end
            if self.Menu.Combo.useTiamat > 1 then self:CastTiamat(target) end
            if self.Menu.Combo.useW then self:CastW() end
            if self.Menu.Combo.useE then self:CastE() end
            if self.Menu.Combo.useQ then self:CastQ() end
        end
    end
end


function _Riven:Harass()
    local target = self.TS.target
    if ValidTarget(target, self.TS.range) then
        if self.queue:Size() > 0 then
            if self.Menu.Harass.useTiamat then self:CastTiamat(target) end
            self.queue:Execute()
        else
            if self.Menu.Harass.useW then self:CastW() end
            if self.Menu.Harass.useE then self:CastE() end
            if self.Menu.Harass.useQ then self:CastQ() end
            if self.Menu.Harass.useTiamat then self:CastTiamat(target) end
        end
    end
end

function _Riven:Clear()
    if self.queue:Size() > 0 then
        self.queue:Execute()
    else
        self.EnemyMinions:update()
        if self.Menu.LaneClear.useQ and self.Q.IsReady() then
            local minion, count = GetBestCircularFarmPosition(self.Q.Range, self.Q.Width, self.EnemyMinions.objects)
            if ValidTarget(minion, self.Q.Range) and not minion.dead then
                self:CastQ(minion)
            end
        end
        
        if self.Menu.LaneClear.useE and self.E.IsReady() then
            local minion, count = GetBestCircularFarmPosition(self.E.Range, self.W.Width, self.EnemyMinions.objects)
            if ValidTarget(minion, self.E.Range) and not minion.dead then
                CastSpell(self.E.Slot, minion.x, minion.z)
            end
        end
        if self.Menu.LaneClear.useW or self.Menu.LaneClear.useTiamat then
            local count = 0
            for i, minion in pairs(self.EnemyMinions.objects) do
                if self.Menu.LaneClear.useW and ValidTarget(minion, self.W.Range) and self.W.IsReady() and not minion.dead  then
                    count = count +1
                end
                if self.Menu.LaneClear.useTiamat then self:CastTiamat(minion) end
            end
            if count > 0 then CastSpell(self.W.Slot) end
        end
        if self.Menu.JungleClear.useQ or self.Menu.JungleClear.useW or self.Menu.JungleClear.useE or self.Menu.JungleClear.useTiamat then
            self.JungleMinions:update()
            for i, minion in pairs(self.JungleMinions.objects) do  
                if minion ~= nil and not minion.dead and self.Menu.JungleClear.useQ and ValidTarget(minion, self.Q.Range) and self.Q.IsReady() then
                    self:CastQ(minion)
                end
                if minion ~= nil and not minion.dead and self.Menu.JungleClear.useW and ValidTarget(minion, self.W.Range) and self.W.IsReady() then
                    CastSpell(self.W.Slot)
                end
                if minion ~= nil and not minion.dead and self.Menu.JungleClear.useE and ValidTarget(minion, self.E.Range) and self.E.IsReady() then
                    CastSpell(self.E.Slot, minion.x, minion.z)
                end
                if self.Menu.JungleClear.useTiamat then self:CastTiamat(minion) end
            end
        end
    end 
end

function _Riven:LastHit()
    if (self.Menu.LastHit.useQ or self.Menu.LastHit.useW or self.Menu.LastHit.useE) and not OM:CanAttack() then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do 
            if self.Menu.LastHit.useQ and ValidTarget(minion, self.Q.Range) and self.Q.IsReady() and not minion.dead and self.Q.Damage(minion) > minion.health then
                CastSpell(self.Q.Slot, minion.x, minion.z)
            end
            if self.Menu.LastHit.useW and ValidTarget(minion, self.W.Range) and self.W.IsReady() and not minion.dead and self.W.Damage(minion) > minion.health then
                CastSpell(self.W.Slot)
            end
            if self.Menu.LastHit.useE and OM:InRange(minion, self.E.Range) and self.E.IsReady() and not minion.dead and self.AA.Damage(minion) + self.P.Damage(minion) > minion.health then
                CastSpell(self.E.Slot, minion.x, minion.z)
            end
            if self.Menu.LastHit.useTiamat and CastableItems.Tiamat.Damage(minion) > minion.health and not minion.dead then self:CastTiamat(minion) end
        end
    end
end

function _Riven:CastQFast(targ)
    local target = ValidTarget(targ, self.Q.Range) and targ or self.TS.target
    if self.Q.IsReady() then
        if ValidTarget(target, self.Q.Range) then
            local CastPosition, HitChance = prediction:GetPrediction(target, self.Q)
            if CastPosition then
                CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
            end
        else
            CastSpell(self.Q.Slot, mousePos.x, mousePos.z)
        end
    end
end

function _Riven:CastQ(targ)
    local target = ValidTarget(targ, self.Q.Range) and targ or self.TS.target
    if self.Q.IsReady() and ValidTarget(target) then
        if self.Menu.Combo.useR2 == 3 and self.R.State and self.Q.State == 2 and not target.dead and self.R.IsReady() then
            local boolean, count, highestPriority = self.queue:Contains("R2")
            if not boolean then
                self.queue:Insert(function() self:CastE(target) end, "R2", 4)
                self.queue:Insert(function() self:CastR2(target) end, "Q", 3)
                return
            end
        end
        local CastPosition, HitChance = prediction:GetPrediction(target, self.Q)
        if ValidTarget(target, self.Q.Range) then
            if CastPosition and HitChance >= 2 then
                if OM:InRange(target, self.AA.OffsetRange) and self.Q.State == 0 and OM:CanAttack() and self:RequiresAA(target) then return end
                CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
                return
            end
        elseif CastPosition then
            CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
            return
        end
    elseif self.queue:Size() > 0 then
        local func, key, priority = self.queue:Get(1)
        if key:lower() == tostring("Q"):lower() then
            self.queue:RemoveAt(1)
        end
    end
end

function _Riven:CastW(targ)
    local target = ValidTarget(targ, self.W.Range) and targ or self.W.TS.target
    if self.W.IsReady() and ValidTarget(target, self.W.Range) then
        CastSpell(self.W.Slot)
        return
    elseif self.queue:Size() > 0 then
        local func, key, priority = self.queue:Get(1)
        if key:lower() == tostring("W"):lower() then
            self.queue:RemoveAt(1)
        end
    end
end

function _Riven:CastE(targ)
    local target = ValidTarget(targ, self.E.Range) and targ or self.TS.target
    if self.E.IsReady() and ValidTarget(target, self.E.Range) then -- and (GetDistanceSqr(myHero, target) > self.E.Range * self.E.Range or (not self.Q.IsReady()) ) 
        local CastPosition, HitChance = prediction:GetPrediction(target, self.E)
        if CastPosition then --and GetDistanceSqr(myHero, target) > GetDistanceSqr(CastPosition, target) 
            CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
            return
        end
    elseif self.queue:Size() > 0 then
        local func, key, priority = self.queue:Get(1)
        if key:lower() == tostring("E"):lower() then
            self.queue:RemoveAt(1)
        end
    end
end

function _Riven:CastR(targ)
    local target = ValidTarget(targ, self.R.Range) and targ or self.R.TS.target
    if self.R.IsReady() and ValidTarget(target, self.R.Range) then
        if not self.R.State then 
            if self.Menu.Combo.useR1 == 3 then
                self:CastR1(target)
            elseif self.Menu.Combo.useR1 == 2 then
                if self:RequiresR(target) then
                    self:CastR1(target)
                end
            end    
        else 
            if self.Menu.Combo.useR2 == 2 and self.R.Damage(target) > target.health and not target.dead then
                self:CastR2(target)
            elseif self.Menu.Combo.useR2 == 3 and self.Q.State == 2 and self.Q.IsReady() and not target.dead then
                self:CastR2(target)
            end
        end
    end
end

function _Riven:CastR1(targ)
    local target = ValidTarget(targ, self.R.Range) and targ or self.R.TS.target
    if self.R.IsReady() and not self.R.State and ValidTarget(target, self.R.Range) then
        local CastPosition, HitChance = prediction:GetPrediction(target, self.R)
        if self.E.IsReady() and self.Menu.Misc.cancelR and CastPosition then
            CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
            return
        end
        CastSpell(self.R.Slot)
        return
    elseif self.queue:Size() > 0 then
        local func, key, priority = self.queue:Get(1)
        if key:lower() == tostring("R1"):lower() then
            self.queue:RemoveAt(1)
        end
    end
end

function _Riven:CastR2(targ)
    local target = ValidTarget(targ, self.R.Range) and targ or self.R.TS.target
    if self.R.IsReady() and self.R.State and ValidTarget(target, self.R.Range) then
        local CastPosition, HitChance = prediction:GetPrediction(target, self.R)
        if CastPosition and HitChance >= 1 then
            if self.E.IsReady() and self.Menu.Misc.cancelR then
                CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
                return
            end
            CastSpell(self.R.Slot, CastPosition.x, CastPosition.z)
            return
        end
    elseif self.queue:Size() > 0 then
        local func, key, priority = self.queue:Get(1)
        if key:lower() == tostring("R2"):lower() then
            self.queue:RemoveAt(1)
        end
    end
end

function _Riven:CastTiamat(targ)
    local target = ValidTarget(targ) and targ or self.TS.target
    if OM.Mode == ORBWALKER_MODE.Combo and self.Menu.Combo.useTiamat == 1 then
        if CastableItems.Tiamat.IsReady() and ValidTarget(target) then
            CastSpell(CastableItems.Tiamat.Slot())
            return
        elseif self.queue:Size() > 0 then
            local func, key, priority = self.queue:Get(1)
            if key:lower() == tostring("TIAMAT"):lower() then
                self.queue:RemoveAt(1)
            end
        end
    else
        if CastableItems.Tiamat.IsReady() and ValidTarget(target, CastableItems.Tiamat.Range) then
            CastSpell(CastableItems.Tiamat.Slot())
            return
        elseif self.queue:Size() > 0 then
            local func, key, priority = self.queue:Get(1)
            if key:lower() == tostring("TIAMAT"):lower() then
                self.queue:RemoveAt(1)
            end
        end
    end
end

function _Riven:AfterAttack()
    self:RemoveStack()
end

function _Riven:AddStack()
    if self.P.Stacks < 3 then self.P.Stacks = self.P.Stacks + 1 end
end

function _Riven:RemoveStack()
    if self.P.Stacks > 0 then self.P.Stacks = self.P.Stacks - 1 end 
end

function _Riven:OnProcessSpell(unit, spell)
    if unit and spell and unit.isMe and spell.name then
        if spell.name:lower():find("attack") then
            self.AA.LastCastTime = os.clock()
        elseif spell.name:lower():find("riventricleave") then
            self:AddStack()
            self:CancelAnimation()
            self.Q.LastCastTime = os.clock()
        elseif spell.name:lower():find("rivenmartyr") then
            self:AddStack()
            self:CancelAnimation()
            self.W.LastCastTime = os.clock()
        elseif spell.name:lower():find("rivenfeint") then
            self:AddStack()
            self:CancelAnimation()
            self.E.LastCastTime = os.clock()
        elseif spell.name:lower():find("rivenfengshuiengine") then
            self:AddStack()
            self:CancelAnimation()
            self.R.LastCastTime = os.clock()
            DelayAction(
                function() 
                    if ValidTarget(self.R.TS.target) and OM.Mode == ORBWALKER_MODE.Combo and self.Menu.Keys.FlashCombo then 
                        CastFlash(self.R.TS.target)
                    end 
                end, 0.2)
        elseif spell.name:lower():find("rivenizunablade") then
            self:AddStack()
            self:CancelAnimation()
            DelayAction(
                function() 
                    if ValidTarget(self.R.TS.target) and OM.Mode == ORBWALKER_MODE.Combo and self.Menu.Keys.FlashCombo then 
                        --CastFlash(self.R.TS.target)
                    end 
                end, 0.2)
        elseif spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            self:CancelAnimation()
        elseif spell.name:lower():find("flash") then
        end
    end
end

function _Riven:GetRange()
    if OM.Mode == ORBWALKER_MODE.Combo then return self.Menu.TS.Combo
    elseif OM.Mode == ORBWALKER_MODE.Harass then return self.Menu.TS.Harass
    else return self.Menu.TS.Combo
    end
end

function _Riven:GetSafePlace(target)
    self.AllyMinions:update()
    local bestPlace = nil
    if bestPlace == nil then
        for idx, champion in ipairs(GetAllyHeroes()) do
            if champion.valid and champion.visible then
                if GetDistanceSqr(myHero, champion) <= 800 * 800 and GetDistanceSqr(champion, target) > GetDistanceSqr(myHero, target) then
                    if bestPlace == nil then bestPlace = champion
                    elseif GetDistanceSqr(myHero, bestPlace) < GetDistanceSqr(myHero, champion) then bestPlace = champion end
                end
            end
        end
    end
    if bestPlace == nil then
        for i, turret in pairs(GetTurrets()) do
            if turret ~= nil then
                if turret.team == myHero.team and GetDistanceSqr(turret, target) > GetDistanceSqr(myHero, target) then
                    if bestPlace == nil then bestPlace = turret
                    elseif GetDistanceSqr(myHero, bestPlace) < GetDistanceSqr(myHero, turret) then bestPlace = turret end
                end
            end
        end
    end
    if bestPlace == nil then
        for i, minion in pairs(self.AllyMinions.objects) do
            if GetDistanceSqr(minion, target) > GetDistanceSqr(myHero, target) then
                if bestPlace == nil then bestPlace = minion
                elseif GetDistanceSqr(myHero, bestPlace) < GetDistanceSqr(myHero, minion) then bestPlace = minion end
            end
        end
    end
    return bestPlace
end

function _Riven:RequiresAA(target)
    if ValidTarget(target) then
        local q = 0
        if self.Q.IsReady() then q = (3 - self.Q.State) end
        local d, m = self:GetComboDamage(target, 0, 0, q, self.W.IsReady(), self.E.IsReady(), false, false, false)
        if d > target.health then return false end 
        local d, m = self:GetComboDamage(target, 0, 0, q, self.W.IsReady(), self.E.IsReady(), self.R.IsReady() or self.R.State, self.R.IsReady(), false)
        if d > target.health then return false end
    end
    return true
end

function _Riven:RequiresR(target)
    local q = 0
    if self.Q.IsReady() then q = (3 - self.Q.State) end
    local p = 0
    if q > 0 then p = p + q end
    if self.W.IsReady() then p = p + 1 end
    if self.E.IsReady() then p = p + 1 end
    if self.R.IsReady() then p = p + 1 end
    p = math.min(p, 3)
    if ValidTarget(target) then
        local d, m = self:GetComboDamage(target, p, p + 1, q, self.W.IsReady(), self.E.IsReady(), false, false, false)
        if d > target.health then return false end
    end
    return true
end

function _Riven:GetBestCombo(target)
    if not ValidTarget(target) then return 0, 0, 0, false, false, false, false, false end
    local q = 0
    if self.Q.IsReady() then q = (3 - self.Q.State) end
    local p = 0
    if q > 0 then p = p + q end
    if self.W.IsReady() then p = p + 1 end
    if self.E.IsReady() then p = p + 1 end
    if self.R.IsReady() then p = p + 1 end
    p = math.min(p, 3)
    local d, m = self:GetComboDamage(target, 0, 0, q, self.W.IsReady(), self.E.IsReady(), false, false, false)
    if d > target.health then 
        return 0, 0, q, self.W.IsReady(), self.E.IsReady(), false, false, false
    end
    local d, m = self:GetComboDamage(target, 0, 0, q, self.W.IsReady(), self.E.IsReady(), self.R.IsReady() or self.R.State, self.R.IsReady(), false)
    if d > target.health then 
        return 0, 0, q, self.W.IsReady(), self.E.IsReady(), self.R.IsReady() or self.R.State, self.R.IsReady(), false
    else
        local p = 0
        if q > 0 then p = p + q end
        if self.W.IsReady() then p = p + 1 end
        if self.E.IsReady() then p = p + 1 end
        if self.R.IsReady() then p = p + 1 end
        p = math.min(p, 3)
        local item = CastableItems.Tiamat.IsReady()
        local dmg = self:GetComboDamage(target, p, p, q, self.W.IsReady(), self.E.IsReady(), self.R.IsReady() or self.R.State, self.R.IsReady(), item)
        return p, p + 1, q, self.W.IsReady(), self.E.IsReady(), self.R.IsReady() or self.R.State, self.R.IsReady(), item
    end
end

function _Riven:GetComboDamage(target, p, aa, q, w, e, r1, r2, items)
    local comboDamage = 0
    local currentManaWasted = 0
    if target ~= nil and target.valid then
        comboDamage = comboDamage + self.P.Damage(target) * p
        comboDamage = comboDamage + self.AA.Damage(target) * aa
        if q > 0 then
            comboDamage = comboDamage +  self.Q.Damage(target) * q
            comboDamage = comboDamage + self.P.Damage(target) * 1
            comboDamage = comboDamage + self.AA.Damage(target) * 1
        end
        if w then
            comboDamage = comboDamage + self.W.Damage(target)
            comboDamage = comboDamage + self.P.Damage(target) * 1
            comboDamage = comboDamage + self.AA.Damage(target) * 1
        end
        if e then
        end
        if r1 then
            comboDamage = comboDamage + self.AA.Damage(target) * aa * 0.2
            comboDamage = comboDamage + self.P.Damage(target) * p * 0.2
        end
        if r2 then
            comboDamage = comboDamage + self.R.Damage(target)
        end
        if items then
            comboDamage = comboDamage + DamageItems(target)
        end
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Riven:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

function _Riven:DrawPredictedDamage()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        local point = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
        if ValidTarget(enemy) and enemy.visible and OnScreen(point.x, point.y) then
            local p, aa, q, w, e, r1, r2, items = self:GetBestCombo(enemy)
            local dmg, mana = self:GetComboDamage(enemy, p, aa, q, w, e, r1, r2, items)
            local spells = ""
            if p > 0 then spells = spells .." P" end
            if q > 0 then spells = spells .." Q" end
            if w then spells = spells .. " W" end
            if e then spells = spells .. " E" end
            if r1 or r2 then spells = spells .. " R" end
            DrawLineHPBar(dmg, spells, enemy, true)
        end
    end
end

function _Riven:OnDraw()
    -- body
    if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
    if self.Menu.Draw.dmgCalc then self:DrawPredictedDamage() end
    if self.Menu.TS.Draw and ValidTarget(self.TS.target) then
        local source = self.TS.target
        DrawCircle3D(source.x, source.y, source.z, 120, 2, Colors.Red, 10)
    end

    if self.Menu.TS.Range then
        DrawCircle3D(myHero.x, myHero.y, myHero.z, self:GetRange(), 1, Colors.Red, 40)
    end

    if self.Menu.Misc.developer then
        local pos = WorldToScreen(D3DXVECTOR3(myHero.x , myHero.y, myHero.z))
        local string = "P: ".." ".. self.P.Stacks
        DrawText(string, 25, pos.x, pos.y + 50,  ARGB(255,255,255,255))

        if self.queue:Size() > 0 then
            for i = 1, self.queue:Size(), 1 do
                local X = myHero.x + 600
                local CountY = myHero.y + 400 - i*50 
                local CountZ = myHero.z + 400 - i*50 
                local pos = WorldToScreen(D3DXVECTOR3(X , CountY, CountZ))

                local func, key, priority = self.queue:Get(i)
                local string = key .." "..priority
                DrawText(string, 25, pos.x, pos.y,  ARGB(255,255,255,255))
            end
        end
    end

    if self.Q.State > 0 and self.Menu.Draw.TimeQ then
        local pos = WorldToScreen(D3DXVECTOR3(myHero.x , myHero.y, myHero.z))
        local function round(num, idp)
          local mult = 10^(idp or 0)
          return math.floor(num * mult + 0.5) / mult
        end
        local color = Colors.Green
        local timeLeft = self.Q.TimeReset - (os.clock() - self.Q.LastCastTime)
        if timeLeft > 0 then
            if timeLeft > 2/3 * self.Q.TimeReset then
                color = Colors.Green
            elseif timeLeft > 1/3 * self.Q.TimeReset and timeLeft <= 2/3 * self.Q.TimeReset then
                color = Colors.Yellow
            else
                color = Colors.Red
            end
            local string = "Q Time Left".." "..tostring(round(timeLeft, 1))
            DrawText(string, 20, pos.x - 50, pos.y,  color)
        end
    end

    if self.Menu.Draw.Q.Enable and self.Q.IsReady() then
        local source    = myHero
        local color     = self.Menu.Draw.Q.Color
        local width     = self.Menu.Draw.Q.Width
        local range     =           self.Q.Range
        local quality   = self.Menu.Draw.Q.Quality
        DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
    end

    if self.Menu.Draw.W.Enable and self.W.IsReady() then
        local source    = myHero
        local color     = self.Menu.Draw.W.Color
        local width     = self.Menu.Draw.W.Width
        local range     =           self.W.Range
        local quality   = self.Menu.Draw.W.Quality
        DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
    end

    if self.Menu.Draw.E.Enable and self.E.IsReady() then
        local source    = myHero
        local color     = self.Menu.Draw.E.Color
        local width     = self.Menu.Draw.E.Width
        local range     =           self.E.Range
        local quality   = self.Menu.Draw.E.Quality
        DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
    end

    if self.Menu.Draw.R.Enable and self.R.IsReady() then
        local source    = myHero
        local color     = self.Menu.Draw.R.Color
        local width     = self.Menu.Draw.R.Width
        local range     =           self.R.Range
        local quality   = self.Menu.Draw.R.Quality
        DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
    end
end

function _Riven:CancelAnimation()
    local mode = self.Menu.Misc~=nil and self.Menu.Misc.useCancelAnimation or 1
    local target = OM:ObjectInRange( self.AA.OffsetRange * 2)
    if ValidTarget(target) and mode > 1 then
        if mode == 1 then
        elseif mode == 2 then
            local MovePos = myHero + Vector(Vector(myHero) - Vector(target)):normalized() * VP:GetHitBox(myHero) * 1.5
            myHero:MoveTo(MovePos.x, MovePos.z)
        elseif mode == 3 then
            SendChat("/j")
        elseif mode == 4 then
            SendChat("/t")
        elseif mode == 5 then
            SendChat("/d")
        elseif mode == 6 then
            SendChat("/l")
        end
    end
end

function _Riven:Run()
    if OM:CanMove() then myHero:MoveTo(mousePos.x, mousePos.z) end
    if self.E.IsReady() then
        CastSpell(self.E.Slot, mousePos.x, mousePos.z)
    end
    if self.Q.IsReady() then
        CastSpell(self.Q.Slot, mousePos.x, mousePos.z)
    end
end

function _Riven:Jump()
    local wall, wall2 = self.wallJump:GetWallNear()
    local stop = 60
    if wall ~= nil and wall2 ~= nil then
        if GetDistanceSqr(myHero, wall) > stop * stop then
            myHero:MoveTo(wall.x, wall.z)
        end
        if GetDistanceSqr(wall, myHero) < ((3 - self.Q.State) * self.Q.Range + self.E.Range) * ((3 - self.Q.State) * self.Q.Range + self.E.Range) then
            if self.E.IsReady() and self.Q.State >= 2 and os.clock() - self.Q.LastCastTime > 0.4 then
                CastSpell(self.E.Slot, wall2.x, wall2.z)
            end
            if self.Q.IsReady() then
                if self.Q.State < 2 then
                    if GetDistanceSqr(myHero, wall) > (self.Q.Range + 50) * (self.Q.Range + 50) then
                        CastSpell(self.Q.Slot, wall.x, wall.z)
                    else
                        local pos = wall - Vector(wall.x - myHero.x, 0, wall.z - myHero.z):normalized() * self.Q.Range
                        CastSpell(self.Q.Slot, pos.x, pos.z)
                    end
                elseif GetDistanceSqr(myHero, wall) <= stop * stop then
                    if GetDistanceSqr(myHero, wall) < GetDistanceSqr(myHero, wall2) and os.clock() - self.Q.LastCastTime > 0.8 then
                        CastSpell(self.Q.Slot, wall2.x, wall2.z)
                    end
                end
            end
        end
    else
        local wall3 = self.wallJump:GetWallNearWithoutChecks()
        if wall3 ~= nil then
           myHero:MoveTo(wall3.x, wall3.z)
        else
            myHero:MoveTo(mousePos.x, mousePos.z)
        end
    end
end

class "_Draven"
function _Draven:__init()
    self.ScriptName = "Draven Me Crazy"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.P = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.AA      = {            Range = function(target) local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 + 50 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q       = { Slot = _Q, Range = 1075, Width = 60, Delay = 0.5, Speed = 1200, LastCastTime = 0, Collision = true, Aoe = false, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("P", target, myHero) end, IsCatching = false, Stacks  = 0}
    self.W       = { Slot = _W, Range = 950, Width = 315, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = false, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return 0 end, HaveMoveSpeed = false, HaveAttackSpeed = false}
    self.E       = { Slot = _E, Range = 1050, Width = 130, Delay = 0.25, Speed = 1400, LastCastTime = 0, Collision = false, Aoe = true, Type = "linear", IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end}
    self.R       = { Slot = _R, Range = 20000, Width = 150, Delay = 0.4, Speed = 2000, LastCastTime = 0, Collision = false, Aoe = true, Type = "linear", IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end, Obj = nil}
    self:LoadVariables()
    self:LoadMenu()
end

function _Draven:LoadVariables()
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."1.000")
    self.AxesCatcher = _AxesCatcher()
end

function _Draven:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Draw","Draw circle on Target", SCRIPT_PARAM_ONOFF, true)
        self.Menu.TS:addParam("Range","Draw circle for Range", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_LIST, 3, { "Zero Spins", "One Spin", "Two Spins"})
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_LIST, 2, { "Never", "If is not in range", "Always"})
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR1","Use R if Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR2","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_LIST, 2, { "Zero Spins", "One Spin", "Two Spins"})
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        
    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 2, { "Zero Spins", "One Spin", "Two Spins"})
        self.Menu.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 2, { "Zero Spins", "One Spin", "Two Spins"})
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use E To Interrupt", "useE")
            self.Int = _Interrupter(self.Menu.Auto.useE, self.E.Range + 500)
            self.Int:CheckGapcloserSpells()
            self.Int:CheckChannelingSpells()
            self.Int:RegisterCallback(function(target, time, timeLimit) self:ForceE(target, time, timeLimit) end)

    self.Menu:addSubMenu(myHero.charName.." - Axe Settings", "Axe")
        self.AxesCatcher:LoadMenu(self.Menu.Axe)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then self.Menu.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 1) end
        self.Menu.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        self.Menu.Misc:addParam("rRange","R Range", SCRIPT_PARAM_SLICE, 1800, 300, 6000, 0)
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addSubMenu("E", "E")
            self.Menu.Draw.E:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.E:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.E:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.E:addParam("Quality","Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.E.Range/5 + 10)/2), 40), 10, math.round(self.E.Range/5))
        self.Menu.Draw:addSubMenu("R", "R")
            self.Menu.Draw.R:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw.R:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
            self.Menu.Draw.R:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw.R:addParam("Quality","Quality", SCRIPT_PARAM_SLICE, math.min(math.round((self.R.Range/5 + 10)/2), 40), 10, math.round(self.R.Range/5))
        self.Menu.Draw:addParam("dmgCalc","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OM:LoadKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

    AddTickCallback(
        function()
            self.R.Range = self.Menu.Misc.rRange
            self.TS:update()
        
            self.AxesCatcher:CheckCatch()
        
            self:KillSteal()
        
            if OM.Mode == ORBWALKER_MODE.Combo then self:Combo()
            elseif OM.Mode == ORBWALKER_MODE.Harass then self:Harass()
            elseif OM.Mode == ORBWALKER_MODE.Clear then self:Clear() 
            elseif OM.Mode == ORBWALKER_MODE.LastHit then self:LastHit()
            end
        
            if self.Menu.Keys.Flee then self:Flee() end
        end
    )
    AddProcessSpellCallback(
        function(unit, spell) 
            if myHero.dead or not self.MenuLoaded then return end
            if unit and spell and spell.name and unit.isMe then
                if spell.name:lower() == "dravenspinning" then self.Q.LastCastTime = os.clock()
                elseif spell.name:lower() == "dravendoubleshot" then self.E.LastCastTime = os.clock()
                elseif spell.name:lower():find("fury") then 
                    self.W.LastCastTime = os.clock()
                    self.W.HaveMoveSpeed = true
                    self.W.HaveAttackSpeed = true
                elseif spell.name:lower() == "dravenrcast" then self.R.LastCastTime = os.clock()
                end
            end
        end
    )
    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
            if self.Menu.TS.Draw and ValidTarget(self.TS.target) then
                local source = self.TS.target
                DrawCircle3D(source.x, source.y, source.z, 120, 2, Colors.Red, 10)
            end
        
            if self.Menu.TS.Range then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, self.TS.range, 1, Colors.Red, 40)
            end
        
            if self.Menu.Draw.E.Enable and self.E.IsReady() then
                local source    = Vector(myHero)
                local color     = self.Menu.Draw.E.Color
                local width     = self.Menu.Draw.E.Radius
                local range     =           self.E.Range
                local quality   = self.Menu.Draw.E.Quality
                DrawCircle3D(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        
            if self.Menu.Draw.R.Enable and self.R.IsReady() then
                local source    = Vector(myHero)
                local color     = self.Menu.Draw.R.Color
                local width     = self.Menu.Draw.R.Radius
                local range     =           self.R.Range
                local quality   = self.Menu.Draw.R.Quality
                DrawCircleMinimap(source.x, source.y, source.z, range, width, ARGB(color[1], color[2], color[3], color[4]), quality)
            end
        end
    )
    AddCreateObjCallback(
        function(obj)
            if obj and os.clock() - self.R.LastCastTime < 0.5 and obj.name:lower():find("linemissile") and obj.spellOwner.isMe then
                self.R.Obj = obj
            end
        end
    )
    AddDeleteObjCallback(
        function(obj)
            if obj and obj.valid and obj.name and self.R.Obj ~= nil and GetDistanceSqr(self.R.Obj, obj) < 100 * 100 and obj.name == self.R.Obj.name then
                self.R.Obj = nil
            elseif obj and obj.valid and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("_w")and obj.name:lower():find("_buf") then
                if obj.name:lower():find("move") then
                    self.W.HaveMoveSpeed = false
                elseif obj.name:lower():find("attack") then
                    self.W.HaveAttackSpeed = false
                end
            end
        end
    )
    self.MenuLoaded = true
end

function _Draven:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.4 and ValidTarget(enemy, self.R.Range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if self.Menu.KillSteal.useQ and ( q or self.Q.Damage(enemy) > enemy.health) and not enemy.dead then self:CastQ(enemy) end
                if self.Menu.KillSteal.useE and ( e or self.E.Damage(enemy) > enemy.health) and not enemy.dead then self:CastE(enemy) end
                if self.Menu.KillSteal.useR and ( r or self.R.Damage(enemy) > enemy.health) and not enemy.dead then self:CastR(enemy) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead then CastIgnite(enemy) end
        end
    end
end

function _Draven:Flee()
    if OM:CanMove() then myHero:MoveTo(mousePos.x, mousePos.z) end
    if self.W.IsReady() then CastSpell(self.W.Slot) end
    if self.E.IsReady() then 
        local target = nil
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, self.E.Range) then
                if target == nil then target = enemy
                elseif GetDistanceSqr(myHero, target) > GetDistanceSqr(myHero, enemy) then target = enemy
                end
            end
        end
        if ValidTarget(target, self.E.Range) then
            self:CastE(target)
        end
     end
end


function _Draven:GetLastRTarget()
    local last = nil
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, self.R.Range) and enemy.visible then
            if last == nil then last = enemy
            elseif GetDistanceSqr(myHero, last) < GetDistanceSqr(myHero, enemy) then last = enemy end
        end
    end
    return last
end

function _Draven:Combo()
    local target = self.TS.target
    if ValidTarget(target, self.TS.range) then
        if self.Menu.Combo.useItems then UseItems(target) end
        if self.Menu.Combo.useE then self:CastE(target) end
        if self.Menu.Combo.useQ then self:CastQ(target, self.Menu.Combo.useQ) end
        if self.Menu.Combo.useW > 1 then self:CastW(target, self.Menu.Combo.useW) end
        if self.Menu.Combo.useR1 then
            local q, w, e, r, dmg = GetBestCombo(target)
            if r and dmg >= target.health then self:CastR(target) end
        end
        if self.Menu.Combo.useR2 > 0 and self.R.IsReady() then
            local BestCastPosition, BestHitChance, BestCount = nil, nil, 0
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                if self.R.IsReady() and ValidTarget(enemy, self.R.Range) then
                    local CastPosition,  HitChance,  Count = VP:GetLineAOECastPosition(enemy, self.R.Delay, self.R.Width, GetDistance(myHero, self:GetLastRTarget()) + 200, self.R.Speed, myHero)
                    if BestCount == 0 then BestCastPosition = CastPosition BestHitChance = HitChance BestCount = Count
                    elseif BestCount < Count then BestCastPosition = CastPosition BestHitChance = HitChance BestCount = Count end
                end
            end
            if BestCount >= self.Menu.Combo.useR2 and BestCastPosition ~= nil and BestHitChance ~=nil and BestHitChance >= 2 then
                CastSpell(self.R.Slot, BestCastPosition.x, BestCastPosition.z)
            end
        end
    end
end

function _Draven:Harass()
    if myHero.mana / myHero.maxMana * 100 >= self.Menu.Harass.Mana then
        if self.Menu.Harass.useQ and self.Q.IsReady() then 
            self.EnemyMinions:update() 
            for i, minion in pairs(self.EnemyMinions.objects) do
                if ValidTarget(minion, self.AA.Range(minion)) then
                    self:CastQ(minion, self.Menu.Harass.useQ) 
                end
            end
        end
        local target = self.TS.target
        if ValidTarget(target) then
            if self.Menu.Harass.useE then self:CastE(target) end
            if self.Menu.Harass.useQ and self.Q.IsReady() then self:CastQ(target, self.Menu.Harass.useQ) end
            if self.Menu.Harass.useW then self:CastW(target) end
        end
    end
end

function _Draven:Clear()
    if myHero.mana / myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        self.EnemyMinions:update() 
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ValidTarget(minion) and myHero.mana / myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then 
                if self.Menu.LaneClear.useE and self.E.IsReady() then
                    local BestPos = GetBestLineFarmPosition(self.E.Range, self.E.Width, self.EnemyMinions.objects)
                    if BestPos ~= nil then CastSpell(self.E.Slot, BestPos.x, BestPos.z) end
                end
    
                if self.Menu.LaneClear.useQ and self.Q.IsReady() then
                    self:CastQ(minion, self.Menu.LaneClear.useQ)
                end
    
                if self.Menu.LaneClear.useW and self.W.IsReady() then
                    self:CastW(minion)
                end
            end
        end
    end


    if myHero.mana / myHero.maxMana * 100 >= self.Menu.JungleClear.Mana then
        self.JungleMinions:update()
        for i, minion in pairs(self.JungleMinions.objects) do
            if ValidTarget(minion)  and myHero.mana / myHero.maxMana * 100 >= self.Menu.JungleClear.Mana then 
                if self.Menu.JungleClear.useE and self.E.IsReady() then
                    CastSpell(self.E.Slot, minion.x, minion.z)
                end
                if self.Menu.JungleClear.useQ and self.Q.IsReady() then
                    self:CastQ(minion, self.Menu.JungleClear.useQ)
                end
    
                if self.Menu.JungleClear.useW and self.W.IsReady() then
                    self:CastW(minion)
                end
            end
        end
    end
end

function _Draven:LastHit()
    self.EnemyMinions:update() 
    for i, minion in pairs(self.EnemyMinions.objects) do
       if ValidTarget(minion, self.AA.Range(minion)) and self.Menu.LastHit.useQ and self.Q.IsReady() then
            local time = OM:WindUpTime() - OM:ExtraWindUp() + OM:Latency() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - 100/1000
            local predHealth = VP:GetPredictedHealth(minion, time, 0)
            local axedmg = self.AxesCatcher:GetCountAxes() > 0 and self.Q.Damage(minion) or 0
            if VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + axedmg > predHealth and predHealth > -40 then
                if self.AxesCatcher:GetCountAxes() == 0 then
                    self:CastQ(minion, 2)
                end
            end
        end
        if ValidTarget(minion, self.E.Range) and self.Menu.LastHit.useE and self.E.IsReady() then
            local time = self.E.Delay + GetDistance(minion.pos, myHero.pos) / self.E.Speed - 0.07
            local predHealth = VP:GetPredictedHealth(minion, time, 0)
            if self.E.Damage(minion) > predHealth and predHealth > -40 then
                CastSpell(self.E.Slot, minion.x, minion.z)
            end
        end
    end
end

function _Draven:CastQ(target, m)
    local mode = m ~= nil and m or 3
    if self.Q.IsReady() and ValidTarget(target, self.TS.range) and self.AxesCatcher:GetCountAxes() < 2 and OM:CanAttack() then
        -- 2 spins
        if mode == 3 then
            CastSpell(self.Q.Slot)
        -- 1 spins
        elseif mode == 2 then
            if self.AxesCatcher:GetCountAxes() < 1 then CastSpell(self.Q.Slot) end
        -- 0 spins
        elseif mode == 1 then

        end
    end
end

function _Draven:CastW(target, m)
    local mode = m ~= nil and m or 3
    if self.W.IsReady() and ValidTarget(target, self.TS.range) and not self.W.HaveAttackSpeed then
        if mode == 2 then
            if not ValidTarget(target, self.AA.Range(target)) then
                CastSpell(self.W.Slot)
            end
        elseif mode == 3 then
            CastSpell(self.W.Slot)
        end
    end
end


function _Draven:CastE(target)
    if self.E.IsReady() and ValidTarget(target, self.E.Range) then
        local CastPosition,  HitChance,  Count = prediction:GetPrediction(target, self.E)
        if CastPosition~=nil and HitChance >= 2 then
            CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
        end
    end
end

function _Draven:CastR(target)
    if self.R.IsReady() and ValidTarget(target, self.R.Range) then
        local spell = { Delay = self.R.Delay, Width = self.R.Width, Range = GetDistance(myHero, target) + 200, Speed = self.R.Speed, Type = self.R.Type, Collision = self.R.Collision, Aoe = self.R.Aoe}
        local CastPosition,  HitChance,  Count = prediction:GetPrediction(target, spell)
        if HitChance >= 2 and self.R.Obj == nil then
            CastSpell(self.R.Slot, CastPosition.x, CastPosition.z)
        elseif self.R.Obj ~= nil then
            if GetDistanceSqr(myHero, self.R.Obj) > GetDistanceSqr(myHero, self:GetLastRTarget()) then
                CastSpell(self.R.Slot)
            end
        end
    end
end


function _Draven:ForceE(target, time, timeLimit)
    if not ValidTarget(target) or os.clock() - time > timeLimit then return end
    if self.E.IsReady() and ValidTarget(target, self.E.Range + 500) then
        self:CastE(target)
    end
    if ValidTarget(target, self.E.Range + 500) then
        DelayAction(function(target, time, timeLimit) self:ForceE(target, time, timeLimit) end, 0.1, {target, time, timeLimit})
    end
end

function _Draven:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q.Damage(target)
            currentManaWasted = currentManaWasted + self.Q.Mana()
        end
        if w then
            currentManaWasted = currentManaWasted + self.W.Mana()
            comboDamage = comboDamage + self.AA.Damage(target) * 2
        end
        if e then
            comboDamage = comboDamage + self.E.Damage(target)
            currentManaWasted = currentManaWasted + self.E.Mana()
        end
        if r then
            comboDamage = comboDamage + self.R.Damage(target)
            currentManaWasted = currentManaWasted + self.R.Mana()
        end
        comboDamage = comboDamage + self.AA.Damage(target) * 2
        comboDamage = comboDamage + DamageItems(target)
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Draven:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end


class "_AxesCatcher"
function _AxesCatcher:__init()
    self.AxesAvailables = {}
    self.CurrentAxes = 0
    self.Stack = 0
    self.AxeRadius = 100
    self.LimitTime = 1.2
    self.Menu = nil
    self.lastCheck = 0
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
end

function _AxesCatcher:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        self.Menu:addParam("Catch", "Catch Axes (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("Z"))
        self.Menu:addParam("CatchMode", "Catch Condition", SCRIPT_PARAM_LIST, 1, { "When Orbwalking", "AutoCatch"})
        self.Menu:addParam("OrbwalkMode",  "Catch Mode", SCRIPT_PARAM_LIST, 2, { "Mouse In Radius", "MyHero In Radius"})
        self.Menu:addParam("AABetween", "Use AA between Catching", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addParam("UseW", "Use W to Catch (Smart)", SCRIPT_PARAM_ONOFF, false)
        self.Menu:addParam("Turret", "Dont Catch Under Turret", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addParam("DelayCatch", "% of Delay to Catch", SCRIPT_PARAM_SLICE, 100, 0, 100)
        self.Menu:addSubMenu("Catch Radius", "CatchRadius")
            self.Menu.CatchRadius:addParam("Combo", "Combo Radius", SCRIPT_PARAM_SLICE, 250, 150, 600, 0)
            self.Menu.CatchRadius:addParam("Harass", "Harass Radius", SCRIPT_PARAM_SLICE, 350, 150, 600, 0)
            self.Menu.CatchRadius:addParam("Clear", "Clear Radius", SCRIPT_PARAM_SLICE, 400, 150, 800, 0)
            self.Menu.CatchRadius:addParam("LastHit", "LastHit Radius", SCRIPT_PARAM_SLICE, 400, 150, 800, 0)
        self.Menu:addParam("DrawRadius", "Draw Catch Radius", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addSubMenu("Draw Catch Radius", "Draw")
            self.Menu.Draw:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 0, 0, 255 })
            self.Menu.Draw:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
            self.Menu.Draw:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, 25, 10, 100)
        self.Menu:permaShow("Catch")
        self.Menu:permaShow("CatchMode")
        self.Menu:permaShow("OrbwalkMode")
        --self.Menu:permaShow("DelayCatch")
        AddDrawCallback(
            function()
                if self.Menu ~= nil and not myHero.dead then
                    if self.Menu.Draw.Enable then
                        if #self.AxesAvailables > 0 then
                            for i = 1, #self.AxesAvailables, 1 do
                                local axe, time = self.AxesAvailables[i][1], self.AxesAvailables[i][2]
                                if axe~= nil and axe.valid then
                                    local color = self.Menu.Draw.Color
                                    local width = self.Menu.Draw.Width
                                    local quality = self.Menu.Draw.Quality
                                    DrawCircle3D(axe.x, axe.y, axe.z, self:GetRadius(), width, ARGB(color[1], color[2], color[3], color[4]), quality)
                                end
                            end
                        end
                    end
                end
            end
        )
        AddCreateObjCallback(
            function(obj)
                if self.Menu == nil then return end
                if obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle_self.troy") and GetDistanceSqr(myHero, obj) <= (self.LimitTime * myHero.ms) * (self.LimitTime * myHero.ms) then
                    table.insert(self.AxesAvailables, {obj, os.clock()})
                    --DelayAction(function(i) table.remove(self.AxesAvailables, i) end, self.LimitTime + 0.05, {#self.AxesAvailable + 1} )
                    DelayAction(function() self:RemoveAxe(obj) end, self.LimitTime + 0.2)
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_buf.troy") then
                    self.CurrentAxes = self.CurrentAxes + 1
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_tar.troy") then
                    --self.CurrentAxes = self.CurrentAxes + 1
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("reticlecatchsuccess.troy") then
                    --print(GetDistance(myHero, obj))
                    self:RemoveAxe(obj)
                end
            end
        )
        AddDeleteObjCallback(
            function(obj)
                if self.Menu == nil then return end
                --if obj and obj.name and obj.name:lower():find("draven") then print("Deleted: "..obj.name) end
                --if obj and obj.team and obj.team ~= myHero.team then return end
                if obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle.troy") then
                    self:RemoveAxe(obj)
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle_self.troy") then
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_buf.troy") then  
                    if self.CurrentAxes > 0 then self.CurrentAxes = self.CurrentAxes - 1 end
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_tar.troy") then  
                    --if self.CurrentAxes > 0 then self.CurrentAxes = self.CurrentAxes - 1 end
                elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("reticlecatchsuccess.troy") then
                end
            end
        )
    end
end

function _AxesCatcher:GetCountAxes()
    return #self.AxesAvailables + self.CurrentAxes
end

function _AxesCatcher:GetDelayCatch()
    return (self.Menu~=nil and (self.Menu.DelayCatch / 100)) or 1
end

function _AxesCatcher:GetRadius()
    if OM.Mode == ORBWALKER_MODE.Combo then
        return self.Menu.CatchRadius.Combo
    elseif OM.Mode == ORBWALKER_MODE.Harass then
        return self.Menu.CatchRadius.Harass
    elseif OM.Mode == ORBWALKER_MODE.Clear then
        return self.Menu.CatchRadius.Clear
    elseif OM.Mode == ORBWALKER_MODE.LastHit then
        return self.Menu.CatchRadius.LastHit
    elseif self.Menu~=nil then
        return self.Menu.CatchRadius.Clear
    end
end

function _AxesCatcher:InTurret(obj)
    local offset = VP:GetHitBox(myHero) / 2
    if obj ~= nil and obj.valid and self.Menu ~= nil and self.Menu.Turret then
        if GetTurrets() ~= nil then
            for name, turret in pairs(GetTurrets()) do
                if turret ~= nil and turret.valid and GetDistanceSqr(obj, turret) <= (turret.range + offset) * (turret.range + offset) then
                    if turret.team ~= myHero.team then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function _AxesCatcher:GetBonusSpeed()
    return myHero:GetSpellData(champ.W.Slot).level > 0 and (100 + 35 + myHero:GetSpellData(champ.W.Slot).level * 5)/100 or 1
end

function _AxesCatcher:GetSource()
    return self.Menu.OrbwalkMode == 1 and Vector(mousePos) or Vector(myHero)
end

function _AxesCatcher:InRadius(axe)
    return axe ~= nil and axe.valid and GetDistanceSqr(self:GetSource(), axe) < self:GetRadius() * self:GetRadius()
end

function _AxesCatcher:InAxeRadius(axe)
    local AxeRadius = 1 / 1 * self.AxeRadius
    return axe ~= nil and axe.valid and GetDistanceSqr(myHero.pos, axe) < AxeRadius * AxeRadius
end

--MEJORAR SELECCION I = 1

function _AxesCatcher:GetBestAxe()
    local List = self.AxesAvailables
    local BestAxe, BestTime = nil, 0
    if #List > 0 then
        for i = 1, #List, 1 do
            if List[i] then
                local axe, time = List[i][1], List[i][2]
                if axe~=nil and axe.valid then
                    local timeLeft = self.LimitTime - (os.clock() - time)
                    local AxeRadius = 1 / 1 * self.AxeRadius
                    if timeLeft >= 0 and GetDistance(myHero, axe) - math.min(AxeRadius, GetDistance(myHero, axe)) + AxeRadius <= myHero.ms * timeLeft * self:GetDelayCatch() then
                        if BestAxe == nil then BestAxe = axe BestTime = time
                        else
                            if (GetDistance(myHero, axe) - math.min(AxeRadius, GetDistance(myHero, axe)) )/time > (GetDistance(myHero, BestAxe) - math.min(AxeRadius, GetDistance(myHero, BestAxe)) )/BestTime then
                                BestAxe = axe BestTime = time
                            end
                        end
                    end

                    if timeLeft <= 0 then
                        self:RemoveAxe(axe)
                    end
                end
            end
        end
    end
    return BestAxe, BestTime
end

function _AxesCatcher:CheckCatch()
    local List = self.AxesAvailables--self:GetSortedList()
    if #List > 0 then
        if self.Menu~=nil and self.Menu.Catch and (( self.Menu.CatchMode == 1 and OM.Mode ~= ORBWALKER_MODE.None) or self.Menu.CatchMode == 2 ) then
            --for i = 1, #List, 1 do
            local i = 1
                local axe, time = List[i][1], List[i][2] --self:GetBestAxe()
                if axe ~= nil and axe.valid and os.clock() - time <= self.LimitTime and self:InRadius(axe) and not self:InTurret(axe) then
                    local timeLeft = self.LimitTime - (os.clock() - time)
                    local AxeRadius = 1 / 1 * self.AxeRadius
                    local AxeCatchPositionFromHero  = Vector(axe) + Vector(Vector(myHero) - Vector(axe)):normalized() * math.min(AxeRadius, GetDistance(myHero, axe))
                    local AxeCatchPositionFromMouse = Vector(axe) + Vector(Vector(mousePos) - Vector(axe)):normalized() * math.min(AxeRadius, GetDistance(mousePos, axe))
                    local OrbwalkPosition = Vector(myHero) + Vector(Vector(mousePos) - Vector(axe)):normalized() * AxeRadius
                    local CanMove = false
                    local CanAttack = false
                    local time = timeLeft - ((GetDistance(myHero, AxeCatchPositionFromHero)) / myHero.ms) - (OM:WindUpTime() + 250/1000 + OM:Latency() + champ.AA.Range(champ.TS.target) / self.ProjectileSpeed)
                    --Is in AxeRange
                    if self:InAxeRadius(axe) then
                        CanAttack = true
                    --Can Attack Meanwhile
                    elseif self.Menu.AABetween and time >= 0 and OM:CanAttack(0) and OM:CanAttack(time) then --+ orbwalker:WindUpTime() -
                        CanAttack = true
                        if champ.Menu.Misc.developer then print("Can Attack Meanwhile") end
                    elseif OM:AnimationTime() * 1 + (GetDistance(myHero, AxeCatchPositionFromHero)) / myHero.ms < timeLeft then --+ orbwalker:WindUpTime()
                        CanAttack = true
                        if champ.Menu.Misc.developer then print("Can Attack Meanwhile2") end
                    else
                        CanAttack = false
                    end
                    if GetDistance(myHero, AxeCatchPositionFromHero) + 100 > myHero.ms * timeLeft * self:GetDelayCatch() then
                        CanMove = false
                        --can catch without W and self:GetCountAxes() > 1
                        if not self:InAxeRadius(axe) and GetDistanceSqr(myHero, AxeCatchPositionFromHero) > (myHero.ms * timeLeft * 1.5) * (myHero.ms * timeLeft * 1.5) and GetDistanceSqr(myHero, AxeCatchPositionFromHero) < (myHero.ms * timeLeft * self:GetBonusSpeed()) * (myHero.ms * timeLeft * self:GetBonusSpeed()) then
                            if self.Menu.UseW and self.W.IsReady() then
                                CastSpell(self.W.Slot)
                            end
                        end
                    --can orbwalk
                    else
                        CanMove = true
                    end
                    if CanAttack then
                        OM:EnableAttacks()
                    else
                        OM:DisableAttacks()
                    end
                    if CanMove then
                        OM:EnableMovement()
                    else
                        OM:DisableMovement()
                        if not self:InAxeRadius(axe) and OM:CanMove() then
                            if champ.Menu.Misc.developer then PrintMessage("Moving to Axe") end
                            myHero:MoveTo(axe.x, axe.z) 
                        end
                    end
                    self.lastCheck = os.clock()
                end
                if os.clock() - time > self.LimitTime + 0.2 then
                    self:RemoveAxe(axe)
                end
            --end
        else
            OM:EnableAttacks()
            OM:EnableMovement()
        end
    else
        OM:EnableAttacks()
        OM:EnableMovement()
    end
end

function _AxesCatcher:RemoveAxe(obj)
    if #self.AxesAvailables > 0 and obj ~= nil then
        for i = 1, #self.AxesAvailables, 1 do
            local axe, time = self.AxesAvailables[i][1], self.AxesAvailables[i][2]
            if axe ~= nil and GetDistanceSqr(axe, obj) < 30 * 30 and axe.name == obj.name then
                table.remove(self.AxesAvailables, i)
                break
            end
        end
    end
end

local CHANELLING_SPELLS = {
    ["Katarina"]                    = "R",
    ["MasterYi"]                    = "W",
    ["Fiddlesticks"]                = "R",
    ["Galio"]                       = "R",
    ["MissFortune"]                 = "R",
    ["VelKoz"]                      = "R",
    ["Warwick"]                     = "R",
    ["Nunu"]                        = "R",
    ["Shen"]                        = "R",
    ["Karthus"]                     = "R",
    ["Malzahar"]                    = "R",
    ["Pantheon"]                    = "R",
}

local GAPCLOSER_SPELLS = {
    ["Aatrox"]          = "Q",
    ["Akali"]           = "R",
    ["Alistar"]         = "W",
    ["Amumu"]           = "Q",
    ["Corki"]           = "W",
    ["Diana"]           = "R",
    ["Elise"]           = "Q",
    ["Elise"]           = "E",
    ["Fiddlesticks"]    = "R",
    ["Fiora"]           = "Q",
    ["Fizz"]            = "Q",
    ["Gnar"]            = "E",
    ["Gragas"]          = "E",
    ["Graves"]          = "E",
    ["Hecarim"]         = "R",
    ["Irelia"]          = "Q",
    ["JarvanIV"]        = "Q",
    ["JarvanIV"]        = "R",
    ["Jax"]             = "Q",
    ["Jayce"]           = "Q",
    ["Katarina"]        = "E",
    ["Kassadin"]        = "R",
    ["Kennen"]          = "E",
    ["KhaZix"]          = "E",
    ["Lissandra"]       = "E",
    ["LeBlanc"]         = "W",
    ["LeBlanc"]         = "R",
    ["LeeSin"]          = "Q",
    ["Leona"]           = "E",
    ["Lucian"]          = "E",
    ["Malphite"]        = "R",
    ["MasterYi"]        = "Q",
    ["MonkeyKing"]      = "E",
    ["Nocturne"]        = "R",
    ["Olaf"]            = "R",
    ["Pantheon"]        = "W",
    ["Pantheon"]        = "R",
    ["Poppy"]           = "E",
    ["RekSai"]          = "E",
    ["Renekton"]        = "E",
    ["Riven"]           = "Q",
    ["Riven"]           = "E",
    ["Rengar"]          = "R",
    ["Sejuani"]         = "Q",
    ["Sion"]            = "R",
    ["Shen"]            = "E",
    ["Shyvana"]         = "R",
    ["Talon"]           = "E",
    ["Thresh"]          = "Q",
    ["Tristana"]        = "W",
    ["Tryndamere"]      = "E",
    ["Udyr"]            = "E",
    ["Volibear"]        = "Q",
    ["Vi"]              = "Q",
    ["Vi"]              = "R",
    ["XinZhao"]         = "E",
    ["Yasuo"]           = "E",
    ["Zac"]             = "E",
    ["Ziggs"]           = "W",
}


class "_Initiator"
function _Initiator:__init(menu, range)
    self.Callbacks = {}
    self.Menu = menu
    self.Range = range
    if #GetAllyHeroes() > 0 and self.Menu~=nil then
        for idx, ally in ipairs(GetAllyHeroes()) do
            self.Menu:addParam(ally.charName.."Q", ally.charName.." (Q)", SCRIPT_PARAM_ONOFF, false)
            self.Menu:addParam(ally.charName.."W", ally.charName.." (W)", SCRIPT_PARAM_ONOFF, false)
            self.Menu:addParam(ally.charName.."E", ally.charName.." (E)", SCRIPT_PARAM_ONOFF, false)
            self.Menu:addParam(ally.charName.."R", ally.charName.." (R)", SCRIPT_PARAM_ONOFF, false)
        end
        self.Menu:addParam("Time",  "Time Limit to Initiate", SCRIPT_PARAM_SLICE, 3, 0, 8, 0)
        AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    end
end

function _Initiator:CheckChannelingSpells()
    if #GetAllyHeroes() > 0 then
        for idx, ally in ipairs(GetAllyHeroes()) do
            for champ, spell in pairs(CHANELLING_SPELLS) do
                if ally.charName == champ then
                    self.Menu[ally.charName..spell] = true
                end
            end
        end
    end
end

function _Initiator:CheckGapcloserSpells()
    if #GetAllyHeroes() > 0 then
        for idx, ally in ipairs(GetAllyHeroes()) do
            for champ, spell in pairs(GAPCLOSER_SPELLS) do
                if ally.charName == champ then
                    self.Menu[ally.charName..spell] = true
                end
            end
        end
    end
end

function _Initiator:RegisterCallback(cb)
    table.insert(self.Callbacks, cb)
end

function _Initiator:OnProcessSpell(unit, spell)
    if not myHero.dead and unit and spell and spell.name and not unit.isMe and unit.type and unit.team and GetDistanceSqr(myHero, unit) < self.Range * self.Range then
        if unit.type == myHero.type and unit.team == myHero.team then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if self.Menu[unit.charName..spelltype] then 
                    self:TriggerCallbacks(unit, os.clock())
                end
            end
        end
    end
end

function _Initiator:TriggerCallbacks(unit, time)
    for i, callback in ipairs(self.Callbacks) do
        callback(unit, time, self.Menu.Time)
    end
end

class "_Interrupter"
function _Interrupter:__init(menu, range)
    self.Callbacks = {}
    self.Menu = menu
    self.Range = range
    if #GetEnemyHeroes() > 0 and self.Menu~=nil then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            self.Menu:addParam(enemy.charName.."Q", enemy.charName.." (Q)", SCRIPT_PARAM_ONOFF, false)
            self.Menu:addParam(enemy.charName.."W", enemy.charName.." (W)", SCRIPT_PARAM_ONOFF, false)
            self.Menu:addParam(enemy.charName.."E", enemy.charName.." (E)", SCRIPT_PARAM_ONOFF, false)
            self.Menu:addParam(enemy.charName.."R", enemy.charName.." (R)", SCRIPT_PARAM_ONOFF, false)
        end
        self.Menu:addParam("Time",  "Time Limit to Interrupt", SCRIPT_PARAM_SLICE, 3, 0, 8, 1)
        AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    end
end

function _Interrupter:CheckChannelingSpells()
    if #GetEnemyHeroes() > 0 then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            for champ, spell in pairs(CHANELLING_SPELLS) do
                if enemy.charName == champ then
                    self.Menu[enemy.charName..spell] = true
                end
            end
        end
    end
end

function _Interrupter:CheckGapcloserSpells()
    if #GetEnemyHeroes() > 0 then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            for champ, spell in pairs(GAPCLOSER_SPELLS) do
                if enemy.charName == champ then
                    self.Menu[enemy.charName..spell] = true
                end
            end
        end
    end
end

function _Interrupter:RegisterCallback(cb)
    table.insert(self.Callbacks, cb)
end

function _Interrupter:OnProcessSpell(unit, spell)
    if not myHero.dead and unit and spell and spell.name and not unit.isMe and unit.type and unit.team and ValidTarget(unit, self.Range) then
        if unit.type == myHero.type and unit.team ~= myHero.team then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if self.Menu[unit.charName..spelltype] then 
                    self:TriggerCallbacks(unit, os.clock())
                end
            end
        end
    end
end

function _Interrupter:TriggerCallbacks(unit, time)
    for i, callback in ipairs(self.Callbacks) do
        callback(unit, time, self.Menu.Time)
    end
end

class "_OrbwalkManager"
function _OrbwalkManager:__init()
    self.OrbLoaded = ""
    self.Attack = true
    self.Move = true
    self.KeysMenu = nil
    self.Menu = nil
    self.GotReset = false
    self.DataUpdated = false
    self.BaseWindUpTime = 3
    self.BaseAnimationTime = 0.665
    self.Mode = ORBWALKER_MODE.None
    self.KeyMan = _KeyManager()
    self.AfterAttackCallbacks = {}
    self.AA = {LastTime = 0, LastTarget = nil, isAttacking = false}
    DelayAction(function() self:OrbLoad() end, 5)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    AddTickCallback(
        function()
            self.Mode = self.KeyMan:ModePressed()
        end
    )
    self.EnemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function _OrbwalkManager:LoadKeys(m)
    -- body
    self.KeysMenu = m
    if self.KeysMenu ~= nil then
        self:LoadKey("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, 32, ORBWALKER_MODE.Combo)
        self:LoadKey("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, string.byte("C"), ORBWALKER_MODE.Harass)
        self:LoadKey("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, string.byte("V"), ORBWALKER_MODE.Clear)
        self:LoadKey("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, string.byte("X"), ORBWALKER_MODE.LastHit)
    end
end

function _OrbwalkManager:OnProcessSpell(unit, spell)
    if unit and unit.isMe and spell and spell.name then
        if spell.name:lower():find("attack") then
            if not self.DataUpdated then
                self.BaseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
                self.BaseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
                self.DataUpdated = true
            end
            self.AA.LastTarget = spell.target
            self.AA.isAttacking = true
            self.AA.LastTime = self:GetTime() - self:Latency()
            DelayAction(
                function() 
                    self:TriggerAfterAttackCallback(spell)
                    self.AA.isAttacking = false
                    if self.GotReset then self.GotReset = false end
                end
            ,spell.windUpTime - self:Latency())
        elseif spell.name:lower():find("riventricleave") or spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            self.GotReset = true
            DelayAction(
                function()
                    self:ResetAA()
                end
                ,spell.windUpTime - self:Latency() * 2)
        end
    end
end

--TODO
function _OrbwalkManager:ObjectInRange(off)
    local offset = off~=nil and off or 0
    if self.Mode == ORBWALKER_MODE.Combo then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self:InRange(enemy, offset) then return enemy end
        end
    elseif self.Mode == ORBWALKER_MODE.Harass then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self:InRange(enemy, offset) then return enemy end
        end
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if self:InRange(object, offset) then return object end
        end
    elseif self.Mode == ORBWALKER_MODE.Clear then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self:InRange(enemy, offset) then return enemy end
        end
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if self:InRange(object, offset) then return object end
        end
        self.JungleMinions:update()
        for i, object in ipairs(self.JungleMinions.objects) do
            if self:InRange(object, offset) then return object end
        end
    elseif self.Mode == ORBWALKER_MODE.LastHit then
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if self:InRange(object, offset) then return object end
        end
    end
    return nil
end

function _OrbwalkManager:GetTarget(range)
    if self.Mode == ORBWALKER_MODE.Combo then
        return champ.TS.target
    elseif self.Mode == ORBWALKER_MODE.Harass then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, range) then return enemy end
        end
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if ValidTarget(object, range) then return object end
        end
    elseif self.Mode == ORBWALKER_MODE.Clear then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, range) then return enemy end
        end
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if ValidTarget(object, range) then return object end
        end
        self.JungleMinions:update()
        for i, object in ipairs(self.JungleMinions.objects) do
            if ValidTarget(object, range) then return object end
        end
    elseif self.Mode == ORBWALKER_MODE.LastHit then
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if ValidTarget(object, range) then return object end
        end
    end
    return nil
end

function _OrbwalkManager:GetTime()
    return os.clock()
end

function _OrbwalkManager:Latency()
    return GetLatency() / 2000
end

function _OrbwalkManager:ExtraWindUp()
    return self.Menu ~= nil and self.Menu.ExtraWindUp / 1000 or 90/1000
end

function _OrbwalkManager:WindUpTime()
    return (1 / (myHero.attackSpeed * self.BaseWindUpTime)) + self:ExtraWindUp()
end

function _OrbwalkManager:AnimationTime()
    return 1 / (myHero.attackSpeed * self.BaseAnimationTime)
end

function _OrbwalkManager:CanAttack(ExtraTime)
    local int = ExtraTime~=nil and ExtraTime or 0
    return self:GetTime() - self.AA.LastTime + self:Latency() >= self:AnimationTime() - 25 / 1000 + int and not self:Evade()
end

function _OrbwalkManager:CanMove(ExtraTime)
    local int = ExtraTime~=nil and ExtraTime or 0
    return self:GetTime() - self.AA.LastTime + self:Latency() >= self:WindUpTime() + int and not self.AA.isAttacking and not self:Evade()
end

function _OrbwalkManager:CanCast()
    return self:CanMove()
end

function _OrbwalkManager:Evade()
    return _G.evade or _G.Evade
end

function _OrbwalkManager:MyRange(target)
    local int1 = 50
    if ValidTarget(target) then 
        int1 = GetDistance(target.minBBox, target)/2 
    end
    return myHero.range + GetDistance(myHero, myHero.minBBox) + int1
end

function _OrbwalkManager:InRange(target, off)
    local offset = off~=nil and off or 0
    return ValidTarget(target, self:MyRange(target) + offset)
end

function _OrbwalkManager:TakeControl()
    if self.Menu == nil then
        self.Menu = scriptConfig("Orbwalk Manager", "OrbwalkManager".."1.0")
    end
    self.Menu:addParam("ExtraWindUp","Extra WindUpTime", SCRIPT_PARAM_SLICE, 0, -40, 200, 1)
    AddTickCallback(function()
        if self:CanMove() then self:EnableMovement() else self:DisableMovement() end
        if self:CanAttack() then self:EnableAttacks() else self:DisableAttacks() end
    end)
    if VIP_USER then HookPackets() end
    if VIP_USER then 
        AddSendPacketCallback(
            function(p)
                p.pos = 2
                if myHero.networkID == p:DecodeF() then
                    if not self:CanAttack() and not self:CanMove() and not self:Evade() then
                        --Packet(p):block()
                    end
                end
            end
        ) 
    end
end

--boring part

function _OrbwalkManager:GetClearMode()
    local bestMinion = nil
    for i, minion in pairs(self.EnemyMinions.objects) do
        if ValidTarget(minion, 800) then
            return "laneclear"
        end
    end
    for i, minion in pairs(self.JungleMinions.objects) do
        if ValidTarget(minion, 800) then
            return "jungleclear"
        end
    end
    return nil
end

function _OrbwalkManager:RegisterAfterAttackCallback(func)
    table.insert(self.AfterAttackCallbacks, func)
end

function _OrbwalkManager:TriggerAfterAttackCallback(spell)
    for i, func in ipairs(self.AfterAttackCallbacks) do
        func(spell)
    end
end

function _OrbwalkManager:OrbLoad()
    if _G.Reborn_Initialised then
        self.OrbLoaded = "SAC"
        self.KeyMan:RegisterKeys()
        _G.AutoCarry.MyHero:AttacksEnabled(true)
        _G.AutoCarry.MyHero:MovementEnabled(true)
        return
    elseif _G.Reborn_Loaded then
        DelayAction(function() self:OrbLoad() end, 1)
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
        require 'SxOrbWalk'
        self.OrbLoaded = "Sx"
        Sx = SxOrbWalk()
        Sx:LoadToMenu()
        self.KeyMan:RegisterKeys()
        Sx:EnableAttacks()
        Sx:EnableMove()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
        require 'SOW'
        self.OrbLoaded = "SOW"
        SOWi = SOW(VP)
        SOWi:LoadToMenu()
        SOWi.Move = true
        SOWi.Attacks = true
    else
        print("You will need an orbwalker")
    end
end

function _OrbwalkManager:LoadKey(name1, name2, type, byte, mode)
    if self.KeysMenu ~= nil then
        self.KeysMenu:addParam(name1, name2, type, false, byte)
        self.KeysMenu[name1] = false
        self.KeyMan:RegisterKey(self.KeysMenu, name1, mode)
    end
end

function _OrbwalkManager:ResetAA()
    --if champ.Menu.Misc.developer then PrintMessage("Resetting AA") end
    --self.AA.isAttacking = false
    self.AA.LastTime = self:GetTime() + self:Latency() - self:AnimationTime() + 25 / 1000
    self.GotReset = true
    if self.OrbLoaded == "SAC" then
        _G.AutoCarry.Orbwalker:ResetAttackTimer()
    elseif self.OrbLoaded == "Sx" then
        Sx:ResetAA()
    elseif self.OrbLoaded == "SOW" then
        SOWi:resetAA()
    end
end

function _OrbwalkManager:DisableMovement()
    if self.Move then
        --if champ.Menu.Misc.developer then PrintMessage("Disabling Movement") end
        if self.OrbLoaded == "SAC" then
            _G.AutoCarry.MyHero:MovementEnabled(false)
            self.Move = false
        elseif self.OrbLoaded == "Sx" then
            Sx:DisableMove()
            self.Move = false
        elseif self.OrbLoaded == "SOW" then
            SOWi.Move = false
            self.Move = false
        end
    end
end

function _OrbwalkManager:EnableMovement()
    if not self.Move then
        --if champ.Menu.Misc.developer then PrintMessage("Enabling Movement") end
        if self.OrbLoaded == "SAC" then
            _G.AutoCarry.MyHero:MovementEnabled(true)
            self.Move = true
        elseif self.OrbLoaded == "Sx" then
            Sx:EnableMove()
            self.Move = true
        elseif self.OrbLoaded == "SOW" then
            SOWi.Move = true
            self.Move = true
        end
    end
end

function _OrbwalkManager:DisableAttacks()
    if self.Attack then
        --if champ.Menu.Misc.developer then PrintMessage("Disabling Attacks") end
        if self.OrbLoaded == "SAC" then
            _G.AutoCarry.MyHero:AttacksEnabled(false)
            self.Attack = false
        elseif self.OrbLoaded == "Sx" then
            Sx:DisableAttacks()
            self.Attack = false
        elseif self.OrbLoaded == "SOW" then
            SOWi.Attacks = false
            self.Attack = false
        end
    end
end

function _OrbwalkManager:EnableAttacks()
    if not self.Attack then
        --if champ.Menu.Misc.developer then PrintMessage("Enabling Attacks") end
        if self.OrbLoaded == "SAC" then
            _G.AutoCarry.MyHero:AttacksEnabled(true)
            self.Attack = true
        elseif self.OrbLoaded == "Sx" then
            Sx:EnableAttacks()
            self.Attack = true
        elseif self.OrbLoaded == "SOW" then
            SOWi.Attacks = true
            self.Attack = true
        end
    end
end

class "_KeyManager"
function _KeyManager:__init()
    self.ComboKeys = {}
    self.Combo = false
    self.HarassKeys = {}
    self.Harass = false
    self.LastHitKeys = {}
    self.LastHit = false
    self.ClearKeys = {}
    self.Clear = false
    AddTickCallback(function() self:OnTick() end)
end

function _KeyManager:ModePressed()
    if self.Combo then return ORBWALKER_MODE.Combo
    elseif self.Harass then return ORBWALKER_MODE.Harass
    elseif self.Clear then return ORBWALKER_MODE.Clear
    elseif self.LastHit then return ORBWALKER_MODE.LastHit
    else return ORBWALKER_MODE.None end
end

function _KeyManager:IsKeyPressed(list)
    if #list > 0 then
        for i = 1, #list do
            if list[i] then
                local key = list[i]

                if #key > 0 then
                    local menu = key[1]
                    local param = key[2]
                    if menu[param] then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function _KeyManager:OnTick()
    self.Combo      = self:IsKeyPressed(self.ComboKeys)
    self.Harass     = self:IsKeyPressed(self.HarassKeys)
    self.LastHit    = self:IsKeyPressed(self.LastHitKeys)
    self.Clear      = self:IsKeyPressed(self.ClearKeys)
end

function _KeyManager:RegisterKey(menu, param, mode)
    if mode == ORBWALKER_MODE.Combo then
        table.insert(self.ComboKeys, {menu, param})
    elseif mode == ORBWALKER_MODE.Harass then
        table.insert(self.HarassKeys, {menu, param})
    elseif mode == ORBWALKER_MODE.Clear then
        table.insert(self.ClearKeys, {menu, param})
    elseif mode == ORBWALKER_MODE.LastHit then
        table.insert(self.LastHitKeys, {menu, param})
    end
end

function _KeyManager:RegisterKeys()
    local list = self.ComboKeys
    if #list > 0 then
        for i = 1, #list do
            if list[i] then
                local key = list[i]
                if #key > 0 then
                    local menu = key[1]
                    local param = key[2]
                    if OM.OrbLoaded == "SAC" then
                        _G.AutoCarry.Keys:RegisterMenuKey(menu, param, AutoCarry.MODE_AUTOCARRY)
                    elseif OM.OrbLoaded == "Sx" then
                        Sx:RegisterHotKey("fight",  menu, param)
                    end
                end
            end
        end
    end
    local list = self.HarassKeys
    if #list > 0 then
        for i = 1, #list do
            if list[i] then
                local key = list[i]
                if #key > 0 then
                    local menu = key[1]
                    local param = key[2]
                    if OM.OrbLoaded == "SAC" then
                        _G.AutoCarry.Keys:RegisterMenuKey(menu, param, AutoCarry.MODE_MIXEDMODE)
                    elseif OM.OrbLoaded == "Sx" then
                        Sx:RegisterHotKey("harass", menu, param)
                    end
                end
            end
        end
    end
    local list = self.ClearKeys
    if #list > 0 then
        for i = 1, #list do
            if list[i] then
                local key = list[i]
                if #key > 0 then
                    local menu = key[1]
                    local param = key[2]
                    if OM.OrbLoaded == "SAC" then
                        _G.AutoCarry.Keys:RegisterMenuKey(menu, param, AutoCarry.MODE_LANECLEAR)
                    elseif OM.OrbLoaded == "Sx" then
                        Sx:RegisterHotKey("laneclear", menu, param)
                    end
                end
            end
        end
    end
    local list = self.LastHitKeys
    if #list > 0 then
        for i = 1, #list do
            if list[i] then
                local key = list[i]
                if #key > 0 then
                    local menu = key[1]
                    local param = key[2]
                    if OM.OrbLoaded == "SAC" then
                        _G.AutoCarry.Keys:RegisterMenuKey(menu, param, AutoCarry.MODE_LASTHIT)
                    elseif OM.OrbLoaded == "Sx" then
                        Sx:RegisterHotKey("lasthit", menu, param)
                    end
                end
            end
        end
    end
end


class "_Queue"
function _Queue:__init()
    self.list = {}
    self.LastKeyPressed = 0
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    AddTickCallback(function() self:OnTick() end)
end

function _Queue:Size()
    return #self.list
end

function _Queue:Get(i)
    if self:Size() > 0 then
        return self.list[i][1], self.list[i][2], self.list[i][3]
    end
    return nil, nil, nil
    -- body
end

function _Queue:Insert(func, key, priority)
    if type(func) == "function" then
        if self:Size() > 0 then
            local boolean, count, highestPriority = self:Contains(key)
            if (key:find(tostring("AA"):lower()) or key:find(tostring("Q"):lower())) and count > 2 then return
            elseif not (key:find(tostring("AA"):lower()) or key:find(tostring("Q"):lower())) and count > 0 then 
            else
                local count2 = 1
                for i = 1, self:Size(), 1 do
                    if self.list[i] then
                        local func1, key1, priority1 = self.list[i][1], self.list[i][2], self.list[i][3]
                        if priority <= priority1 then
                            count2 = count2 + 1
                        elseif priority > priority1 then
                            break
                        end
                    end
                end
                table.insert(self.list, count2, {func, key, priority})
            end
        else
            table.insert(self.list, 1, {func, key, priority})
        end
    end
end

function _Queue:OnTick()
    if OM.Mode~=ORBWALKER_MODE.None then
        self.LastKeyPressed = os.clock()
    else
        if os.clock() - self.LastKeyPressed > 5 then
            self:RemoveAll()
        end
    end
end


function _Queue:RemoveAt(i)
    if self:Size() and i~=nil then
        table.remove(self.list, i)
    end
end

function _Queue:RemoveAll()
   self.list = {}
end

function _Queue:Remove(key, quantity)
    local counter = 0
    local quantity = quantity or 1
    if self:Size() > 0 then
        for i = 1, self:Size(), 1 do
            if self.list[i] then
                local func1, key1, priority1 = self.list[i][1], self.list[i][2], self.list[i][3]
                if key:lower() == key1:lower() and counter < quantity then 
                    self:RemoveAt(i)
                    counter = counter + 1 end
                if counter >= quantity then break end
            end
        end
    end
end

function _Queue:Contains(key)
    local boolean, count, highestPriority = false, 0, 0
    if self:Size() > 0 then
        for i = 1, self:Size(), 1 do
            if self.list[i] then
                local func1, key1, priority1 = self.list[i][1], self.list[i][2], self.list[i][3]
                if key:lower() == key1:lower() then 
                    boolean = true 
                    count = count + 1 
                    if highestPriority == 0 then highestPriority = priority1 end
                end
            end
        end
    end
    return boolean, count, highestPriority
end

function _Queue:OnProcessSpell(unit, spell)
    if unit and spell and spell.name and unit.isMe then
        local range = 600
        if spell.name:lower():find("attack") then
            DelayAction(
                function()
                    local target = OM:ObjectInRange(champ.AA.OffsetRange)
                    if ValidTarget(target) and champ.Q.IsReady() then
                        self:Insert(function() champ:CastQ() end, "Q", 2)
                    end
                end
            ,spell.windUpTime - OM:Latency() * 2)
        elseif spell.name:lower():find("riventricleave") then
            self:Remove("Q", 1)
        elseif spell.name:lower():find("rivenmartyr") then
            self:Remove("W", 1)
            local target = OM:ObjectInRange(champ.TS.range)
            if ValidTarget(target) then
                self:Insert(function() champ:CastTiamat(target) end, "TIAMAT", 1)
            end
            self:Insert(function() champ:CastQ() end, "Q", 1) 
        elseif spell.name:lower():find("rivenfeint") then
            self:Remove("E", 1)
            local target = OM:ObjectInRange(champ.TS.range)
            if ValidTarget(target) then
                self:Insert(function() champ:CastTiamat(target) end, "TIAMAT", 1)
            end
            self:Insert(function() champ:CastQ() end, "Q", 1)
            self:Insert(function() champ:CastW() end, "W", 1)
        elseif spell.name:lower():find("rivenfengshuiengine") then
            self:Remove("R1", 1)
            if champ.Menu.Misc.cancelR then
                self:Insert(function() champ:CastQFast() end, "Q", 3)
            end
            if champ.Menu.Combo.useR2 > 1 then 
                DelayAction(function()
                    self:Insert(function() champ:CastR2() end, "R2", 4) 
                end, 14) 
            end
        elseif spell.name:lower():find("rivenizunablade") then
            self:Remove("R2", 1)
            if champ.Menu.Misc.cancelR then
                self:Insert(function() champ:CastQFast() end, "Q", 3)
            end
        elseif spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            self:Remove("TIAMAT", 1)
            self:Insert(function() champ:CastW() end, "W", 2)
        elseif spell.name:lower():find("flash") then
        end
    end
end

function _Queue:IsValidCast(key)
    if OM.Mode == ORBWALKER_MODE.Combo then
        if key:lower() == tostring("Q"):lower() then
            return champ.Menu.Combo.useQ
        elseif key:lower() == tostring("W"):lower() then
            return champ.Menu.Combo.useW
        elseif key:lower() == tostring("E"):lower() then
            return champ.Menu.Combo.useE
        elseif key:lower() == tostring("R1"):lower() then
            return champ.Menu.Combo.useR1 > 1
        elseif key:lower() == tostring("R2"):lower() then
            return champ.Menu.Combo.useR2 > 1
        elseif key:lower() == tostring("TIAMAT"):lower() then
            return champ.Menu.Combo.useItems
        end
    elseif OM.Mode == ORBWALKER_MODE.Harass then
        if key:lower() == tostring("Q"):lower() then
            return champ.Menu.Harass.useQ
        elseif key:lower() == tostring("W"):lower() then
            return champ.Menu.Harass.useW
        elseif key:lower() == tostring("E"):lower() then
            return champ.Menu.Harass.useE
        elseif key:lower() == tostring("TIAMAT"):lower() then
            return champ.Menu.Harass.useTiamat
        end
    elseif OM.Mode == ORBWALKER_MODE.Clear then
        local tipo = OM:GetClearMode()
        if tipo ~= nil then
            if key:lower() == tostring("Q"):lower() then
                return tipo:lower() == tostring("laneclear"):lower() and champ.Menu.LaneClear.useQ or champ.Menu.JungleClear.useQ
            elseif key:lower() == tostring("W"):lower() then
                return tipo:lower() == tostring("laneclear"):lower() and champ.Menu.LaneClear.useW or champ.Menu.JungleClear.useW
            elseif key:lower() == tostring("E"):lower() then
                return tipo:lower() == tostring("laneclear"):lower() and champ.Menu.LaneClear.useE or champ.Menu.JungleClear.useE
            elseif key:lower() == tostring("TIAMAT"):lower() then
                return tipo:lower() == tostring("laneclear"):lower() and champ.Menu.LaneClear.useTiamat or champ.Menu.JungleClear.useTiamat
            end
        end
    elseif OM.Mode == ORBWALKER_MODE.LastHit then
        if key:lower() == tostring("Q"):lower() then
            return champ.Menu.LastHit.useQ
        elseif key:lower() == tostring("W"):lower() then
            return champ.Menu.LastHit.useW
        elseif cast:lower() == tostring("E"):lower() then
            return champ.Menu.LastHit.useE
        end
    end
    return false
end

function _Queue:Execute()
    if self:Size() > 0 then
        if OM:CanCast() and OM.Mode ~= ORBWALKER_MODE.None then
            --if champ:ShouldUseAA() then return end
            local i = 1
            local func, key, priority = self:Get(i)
            if self:IsValidCast(key) and OM.Mode ~= ORBWALKER_MODE.None then
                --if champ.Menu.Misc.developer then print("ValidCast "..key.." Priority: "..priority) end
                func()
            else
                --if champ.Menu.Misc.developer then print("NOT ValidCast " ..key.." Priority: "..priority) end
                self:RemoveAt(i)
            end
        end
    end
end

class "_Prediction"
function _Prediction:__init()
    self.delay = 0.07
    self.LastRequest = 0
    self.source = myHero
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
end

function _Prediction:ValidRequest()
    if os.clock() - self.LastRequest < self:TimeRequest() then
        return false
    else
        self.LastRequest = os.clock()
        return true
    end
end

function _Prediction:GetPredictionType()
    local int = champ.Menu.Misc and champ.Menu.Misc.predictionType or 1
    return PredictionTable[int] ~= nil and tostring(PredictionTable[int]) or "VPrediction"
end

function _Prediction:TimeRequest()
    if self:GetPredictionType() == "VPrediction" then
        return 0.001
    elseif self:GetPredictionType() == "Prodiction" then
        return 0.001
    elseif self:GetPredictionType() == "DivinePred" then
        return champ.Menu~=nil and champ.Menu.Misc.ExtraTime or 0.2
    end
end

function _Prediction:SetSource(src)
    self.source = src
end

function _Prediction:GetPrediction(target, spell)
    if ValidTarget(target) and self:ValidRequest() then
        local delay, width, range, speed, skillshotType, collision, aoe = spell.Delay, spell.Width, spell.Range, spell.Speed, spell.Type, spell.Collision, spell.Aoe
        local skillshotType = skillshotType or "circular"
        local aoe = aoe or false
        local collision = collision or false
        -- VPrediction
        if self:GetPredictionType() == "VPrediction" or not target.type:lower():find("hero") then
            if skillshotType == "linear" then
                if aoe then
                    return VP:GetLineAOECastPosition(target, delay, width, range, speed, self.source)
                else
                    return VP:GetLineCastPosition(target, delay, width, range, speed, self.source, collision)
                end
            elseif skillshotType == "circular" then
                if aoe then
                    return VP:GetCircularAOECastPosition(target, delay, width, range, speed, self.source)
                else
                    return VP:GetCircularCastPosition(target, delay, width, range, speed, self.source, collision)
                end
             elseif skillshotType == "cone" then
                if aoe then
                    return VP:GetConeAOECastPosition(target, delay, width, range, speed, self.source)
                else
                    return VP:GetLineCastPosition(target, delay, width, range, speed, self.source, collision)
                end
            end
        -- Prodiction
        elseif self:GetPredictionType() == "Prodiction" then
            local aoe = false -- temp fix for prodiction
            if aoe then
                if skillshotType == "linear" then
                    local pos, info, objects = Prodiction.GetLineAOEPrediction(target, range, speed, delay, width, self.source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                elseif skillshotType == "circular" then
                    local pos, info, objects = Prodiction.GetCircularAOEPrediction(target, range, speed, delay, width, self.source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                 elseif skillshotType == "cone" then
                    local pos, info, objects = Prodiction.GetConeAOEPrediction(target, range, speed, delay, width, self.source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                end
            else
                local pos, info = Prodiction.GetPrediction(target, range, speed, delay, width, self.source)
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
                    state, pos, perc = DP:predict(unit, asd, 1.2, Vector(self.source))
                    if state == SkillShot.STATUS.SUCCESS_HIT then 
                        return pos, hitchance, perc
                    end
                --end
            end

            return pos, -1, aoe and 1 or pos
        end
    end
    return Vector(target), -1, Vector(target)
end

function _Prediction:GetPredictedPos(unit, delay, speed, from, collision)
    if self:GetPredictionType() == "Prodiction" then 
        return Prodiction.GetPredictionTime(unit, delay)
    else
        return VP:GetPredictedPos(unit, delay, speed, from, collision)

    end
end


class "WallJump"
function WallJump:__init()
    self.range = 380
    self.p1 = nil
    self.p2 = nil
    self.step = 10
    self.lastWall = 0
    AddDrawCallback(function() self:OnDraw() end)
end

function WallJump:OnDraw()
    if self.p1 ~= nil and self.p2 ~= nil and champ.Menu.Keys.WallJump then
        local vec = Vector(self.p1) --myHero + Vector(mousePos.x - myHero.x, 0, mousePos.z - myHero.z):normalized() * self.range
        local p1 = WorldToScreen(D3DXVECTOR3(vec.x, vec.y, vec.z))
        local p2 = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
        DrawLine(p1.x, p1.y, p2.x, p2.y, 4, Colors.Blue)
        local p1 = self.p1
        local p2 = self.p2
        DrawCircle3D(p1.x, p1.y, p1.z, VP:GetHitBox(myHero), 1, Colors.Blue, 10)
        DrawCircle3D(p2.x, p2.y, p2.z, VP:GetHitBox(myHero), 1, Colors.Blue, 10)
    end
end

function WallJump:GetStartEnd()
    local distance = GetDistance(myHero, mousePos)
    local increase = self.step
    local start = nil
    local final = nil
    for i = 0, distance, increase do
        local vec = myHero + Vector(mousePos.x - myHero.x, 0, mousePos.z - myHero.z):normalized() * i 
        if IsWall(D3DXVECTOR3(vec.x, vec.y, vec.z)) then
            if start == nil then 
                start = vec 
            end
        else
            if start ~= nil then 
                final = vec 
                break 
            end
        end
    end
    return start, final
end

function WallJump:GetWallNear()
    local distance = GetDistance(myHero, mousePos)
    local increase = self.step
    local start, finish = self:GetStartEnd()
    self.p1 = nil
    self.p2 = nil
    if start ~= nil and finish ~= nil then
        if GetDistanceSqr(start, finish) <= champ.Menu.WallJump.MaxRange * champ.Menu.WallJump.MaxRange and GetDistanceSqr(start, finish) >= champ.Menu.WallJump.MinRange * champ.Menu.WallJump.MinRange then
            output = start
            local vec = start + Vector(finish.x - start.x, 0, finish.z - start.z):normalized() * (self.range + VP:GetHitBox(myHero) / 2)
            if not IsWall(D3DXVECTOR3(vec.x, vec.y, vec.z)) then
                self.p1 = start
                self.p2 = vec
            end
        end
    end
    return self.p1, self.p2
end

function WallJump:GetWallNearWithoutChecks()
    local distance = GetDistance(myHero, mousePos)
    local increase = self.step
    local output = nil
    for i = 0, distance, increase do
        local vec = myHero + Vector(mousePos.x - myHero.x, 0, mousePos.z - myHero.z):normalized() * i 
        if IsWall(D3DXVECTOR3(vec.x, vec.y, vec.z)) then
            output = vec
            break
        end
    end
    return output
end


function GetAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius / 2 or 0
end

function _GetTarget()
    local bestTarget = nil
    local range = champ.TS.range
    if ValidTarget(GetTarget(), range) then
        if GetTarget().type:lower():find("hero") or GetTarget().type:lower():find("minion") then
            return GetTarget() 
        end
    end
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, range) then
            if bestTarget == nil then 
                bestTarget = enemy
            else
                local q, w, e, r, dmgEnemy = GetBestCombo(enemy)
                local q, w, e, r, dmgBest = GetBestCombo(bestTarget)
                local percentageEnemy = (enemy.health - dmgEnemy) / enemy.maxHealth
                local percentageBest = (bestTarget.health - dmgBest) / bestTarget.maxHealth

                if percentageEnemy * GetPriority(enemy) < percentageBest * GetPriority(bestTarget) then
                    bestTarget = enemy
                end
            end
        end
    end
    return bestTarget
end

function GetHPBarPos(enemy)
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

function DrawLineHPBar(damage, text, unit, enemyteam)
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
    
    local StartPos, EndPos = GetHPBarPos(unit)
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

function DrawPredictedDamage() 
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
        if ValidTarget(enemy) and enemy.visible and OnScreen(p.x, p.y) then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                DrawLineHPBar(dmg, "KILLABLE", enemy, true)
            else
                local spells = ""
                if q then spells = "Q" end
                if w then spells = spells .. "W" end
                if e then spells = spells .. "E" end
                if r then spells = spells .. "R" end
                DrawLineHPBar(dmg, spells, enemy, true)
            end
        end
    end
end

local PredictedDamage = {}
local RefreshTime = 0.4

function GetBestCombo(target)
    if not ValidTarget(target) or champ == nil then return false, false, false, false, 0 end
    local q = {false}
    local w = {false}
    local e = {false}
    local r = {false}
    local damagetable = PredictedDamage[target.networkID]
    if damagetable ~= nil then
        local time = damagetable[6]
        if os.clock() - time <= RefreshTime  then 
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5] 
        else
            if champ.Q.IsReady() then q = {false, true} end
            if champ.W.IsReady() then w = {false, true} end
            if champ.E.IsReady() then e = {false, true} end
            if champ.R.IsReady() then r = {false, true} end
            local bestdmg = 0
            local best = {false, false, false, false}
            local dmg, mana = champ:GetComboDamage(target, champ.Q.IsReady(), champ.W.IsReady(), champ.E.IsReady(), champ.R.IsReady())
            if dmg > target.health then
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = champ:GetComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
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
                local bestdmg, mana = champ:GetComboDamage(target, false, false, false, false)
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = champ:GetComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
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
        PredictedDamage[target.networkID] = {false, false, false, false, 0, os.clock() - RefreshTime * 2}
        return GetBestCombo(target)
    end
end

function EnemyInMyTurret(enemy, range)
    if ValidTarget(enemy, range) then
        for name, turret in pairs(GetTurrets()) do
            if turret ~= nil then
                if turret.team == myHero.team and GetDistanceSqr(enemy, turret) < turret.range * turret.range then
                    return true
                end
            end
        end
    end
    return false
end

function UnitAtTurret(unit, offset)
    if unit ~= nil and unit.valid then
        for name, turret in pairs(GetTurrets()) do
            if turret ~= nil and GetDistanceSqr(myHero, turret) < 2000 * 2000 then
                if turret.team ~= myHero.team and GetDistanceSqr(unit, turret) < (turret.range + offset) * (turret.range + offset) then
                    return true
                end
            end
        end
    end
    return false
end

function PrintMessage(arg1, arg2)
    local a, b = "", ""
    if arg2~=nil then
        a = arg1
        b = arg2
    else
        a = ScriptName
        b = arg1
    end
    print("<font color=\"#6699ff\"><b>" .. a .. ":</b></font> <font color=\"#FFFFFF\">" .. b .. "</font>") 
end

function FindItemSlot(name)
    for slot = ITEM_1, ITEM_7 do
        if myHero:GetSpellData(slot).name:lower():find(name:lower()) then
            return slot
        end
    end
    return nil
end

function FindSummonerSlot(name)
    for slot = SUMMONER_1,SUMMONER_2 do
        if myHero:GetSpellData(slot).name:lower():find(name:lower()) then
            return slot
        end
    end
    return nil
end

function Cast_Item(item, target)
    if item.IsReady() and ValidTarget(target, item.Range) then
        if item.reqTarget then
            CastSpell(item.Slot(), target)
        else
            CastSpell(item.Slot())
        end
    end
end

function CastFlash(vector)
    if Flash.IsReady() then
        CastSpell(flashslot, vector.x, vector.z)
    end
end

function CastIgnite(target)
    if Ignite.IsReady() and ValidTarget(target, Ignite.Range) then
        CastSpell(igniteslot, target)
    end
end

function CastSmite(target)
    if Smite.IsReady() and ValidTarget(target, Smite.Range) then
        CastSpell(smiteslot, target)
    end
end

function _GetDistanceSqr(p1, p2)
    p2 = p2 or player
    if p1 and p1.networkID and (p1.networkID ~= 0) and p1.visionPos then p1 = p1.visionPos end
    if p2 and p2.networkID and (p2.networkID ~= 0) and p2.visionPos then p2 = p2.visionPos end
    return GetDistanceSqr(p1, p2)
    
end

function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local r = radius --+ VP:GetHitBox(object) / 3
        if _GetDistanceSqr(pos, object) <= r * r then
            n = n + 1
        end
    end

    return n
end

function GetBestCircularFarmPosition(range, radius, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local hit = CountObjectsNearPos(object.visionPos or object, range, radius, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object--Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
        local w = width --+ VP:GetHitBox(object) / 3
        if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
            n = n + 1
        end
    end
    return n
end
    

function GetBestLineFarmPosition(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local EndPos = Vector(myHero) + range * (Vector(object) - Vector(myHero)):normalized()
        local hit = CountObjectsOnLineSegment(myHero, EndPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object--Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function GetPriority(enemy)
    local int = TS_GetPriority(enemy)
    if int == 2 then
        return 1.5
    elseif int == 3 then
        return 1.75
    elseif int == 4 then
        return 2
    elseif int == 5 then
        return 2.5
    else
        return 1
    end
end

function DamageItems(unit)
    local dmg = 0
    if ValidTarget(unit) then
        for _, item in pairs(CastableItems) do
            if item.IsReady() then
                dmg = dmg + item.Damage(unit)
            end
        end
    end
    return dmg
end

function UseItems(unit)
    if ValidTarget(unit) then
        for _, item in pairs(CastableItems) do
            Cast_Item(item, unit)
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
            if self.OnlineVersion and self.OnlineVersion > self.LocalVersion then
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

if SCRIPTSTATUS then
    if myHero.charName == "Riven" then
        assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("VILJKNJQNPI") 
    elseif myHero.charName == "Xerath" then
        assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("OBECIDHCEEA") 
    elseif myHero.charName == "Orianna" then
        assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("XKNLQOKQQLP") 
    elseif myHero.charName == "Draven" then
        assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("TGJHLHHIOHJ") 
    elseif myHero.charName == "Lissandra" then
        assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("UHKIKPOJIII")
    end
end