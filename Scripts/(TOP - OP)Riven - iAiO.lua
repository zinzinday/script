local AUTOUPDATES = true
local SCRIPTSTATUS = true
local ScriptName = "iCreative's AIO"
local version = 1.083
local champions = {
    ["Riven"]           = true,
    ["Xerath"]          = true,
    ["Orianna"]         = true,
    ["Draven"]          = true,
    ["Lissandra"]       = true,
    ["Irelia"]          = true,
    ["Heimerdinger"]    = true,
    ["Kennen"]          = true,
    ["Fiora"]           = true,
    ["Yasuo"]           = true
}
if champions[myHero.charName] == nil then return end

local igniteslot, flashslot, smiteslot = nil
local Ignite    = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero)*0.95 end}
local Flash     = { Range = 400, IsReady = function() return (flashslot ~= nil and myHero:CanUseSpell(flashslot) == READY) end, LastCastTime = 0}
local Smite     = { Range = 780, IsReady = function() return (smiteslot ~= nil and myHero:CanUseSpell(smiteslot) == READY) end}

local CastableItems = {
    Tiamat      = { Range = 400 , Slot   = function() return FindItemSlot("TiamatCleave") end,  reqTarget = false,  IsReady                             = function() return (FindItemSlot("TiamatCleave") ~= nil and myHero:CanUseSpell(FindItemSlot("TiamatCleave")) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end},
    Bork        = { Range = 450 , Slot   = function() return FindItemSlot("SwordOfFeastAndFamine") end,  reqTarget = true,  IsReady                     = function() return (FindItemSlot("SwordOfFeastAndFamine") ~= nil and myHero:CanUseSpell(FindItemSlot("SwordOfFeastAndFamine")) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
    Bwc         = { Range = 400 , Slot   = function() return FindItemSlot("BilgewaterCutlass") end,  reqTarget = true,  IsReady                         = function() return (FindItemSlot("BilgewaterCutlass") ~= nil and myHero:CanUseSpell(FindItemSlot("BilgewaterCutlass")) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
    Hextech     = { Range = 400 , Slot   = function() return FindItemSlot("HextechGunblade") end,  reqTarget = true,    IsReady                         = function() return (FindItemSlot("HextechGunblade") ~= nil and myHero:CanUseSpell(FindItemSlot("HextechGunblade")) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
    Blackfire   = { Range = 750 , Slot   = function() return FindItemSlot("BlackfireTorch") end,  reqTarget = true,   IsReady                           = function() return (FindItemSlot("BlackfireTorch") ~= nil and myHero:CanUseSpell(FindItemSlot("BlackfireTorch")) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
    Youmuu      = { Range = myHero.range + myHero.boundingRadius + 350 , Slot   = function() return FindItemSlot("YoumusBlade") end,  reqTarget = false,  IsReady                              = function() return (FindItemSlot("YoumusBlade") ~= nil and myHero:CanUseSpell(FindItemSlot("YoumusBlade")) == READY) end, Damage = function(target) return 0 end},
    Randuin     = { Range = 500 , Slot   = function() return FindItemSlot("RanduinsOmen") end,  reqTarget = false,  IsReady                             = function() return (FindItemSlot("RanduinsOmen") ~= nil and myHero:CanUseSpell(FindItemSlot("RanduinsOmen")) == READY) end, Damage = function(target) return 0 end},
    TwinShadows = { Range = 1000, Slot   = function() return FindItemSlot("ItemWraithCollar") end,  reqTarget = false,  IsReady                         = function() return (FindItemSlot("ItemWraithCollar") ~= nil and myHero:CanUseSpell(FindItemSlot("ItemWraithCollar")) == READY) end, Damage = function(target) return 0 end},
}

local DefensiveItems = {
    Zhonyas = { Slot = function() return FindItemSlot("ZhonyasHourglass") end, IsReady = function() return (FindItemSlot("ZhonyasHourglass") ~= nil and myHero:CanUseSpell(FindItemSlot("ZhonyasHourglass")) == READY) end}
}


local Colors = { 
    -- O R G B
    Green   =  ARGB(255, 0, 180, 0), 
    Yellow  =  ARGB(255, 255, 215, 00),
    Red     =  ARGB(255, 255, 0, 0),
    White   =  ARGB(255, 255, 255, 255),
    Blue    =  ARGB(255, 0, 0, 255),
}


function CheckUpdate()
    if AUTOUPDATES then
        local ToUpdate = {}
        ToUpdate.LocalVersion = version
        ToUpdate.VersionPath = "raw.githubusercontent.com/jachicao/BoL/master/version/iAIO.version"
        ToUpdate.ScriptPath = "raw.githubusercontent.com/jachicao/BoL/master/iAIO.lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) PrintMessage(ScriptName, "Updated to "..NewVersion..". Please reload with 2x F9.") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) PrintMessage(ScriptName, "No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) PrintMessage(ScriptName, "New Version found ("..NewVersion.."). Please wait...") end
        ToUpdate.CallbackError = function(NewVersion) PrintMessage(ScriptName, "Error while trying to check update.") end
        _ScriptUpdate(ToUpdate)
    end
end


function TargetHaveBuffType(buffType, target)
  local target = target or myHero
  for i = 1, target.buffCount do
    local tBuff = target:getBuff(i)
    if BuffIsValid(tBuff) then
        if tBuff.type == buffType then return true end
    end
  end
  return false
end

function EnemiesWithBuffType(buffType, range) --29
  local enemies = {}
  if #GetEnemyHeroes() > 0 then
    for idx, enemy in ipairs(GetEnemyHeroes()) do
      if ValidTarget(enemy, range) and TargetHaveBuffType(buffType, enemy) then
        table.insert(enemies, enemy)
      end
    end
  end
  return enemies
end


function OnLoad()
    local r = _Required()
    r:Add({Name = "SimpleLib", Url = "raw.githubusercontent.com/jachicao/BoL/master/SimpleLib.lua"})
    r:Check()
    if r:IsDownloading() then return end
    if OrbwalkManager == nil then print("Check your SimpleLib file, isn't working... The script can't load without SimpleLib. Try to copy-paste the entire SimpleLib.lua on your common folder.") return end

    DelayAction(function() _arrangePriorities() end, 10)
    DelayAction(function() CheckUpdate() end, 5)

    igniteslot = FindSummonerSlot("summonerdot")
    smiteslot = FindSummonerSlot("smite")
    flashslot = FindSummonerSlot("flash")

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
    elseif myHero.charName == "Irelia" then
        champ = _Irelia()
    elseif myHero.charName == "Heimerdinger" then
        champ = _Heimerdinger()
    elseif myHero.charName == "Kennen" then
        champ = _Kennen()
    elseif myHero.charName == "Fiora" then
        champ = _Fiora()
    elseif myHero.charName == "Yasuo" then
        champ = _Yasuo()
    end

    if champ~=nil then
        PrintMessage(ScriptName, champ.ScriptName.." by "..champ.Author.." loaded, Have Fun!.")
    end
end

class "_Yasuo"
function _Yasuo:__init()
    self.ScriptName = "Master of the Wind"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self:LoadVariables()
    self:LoadMenu()
end

function _Yasuo:LoadVariables()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_PHYSICAL)
    self.EnemyMinions = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."30062015")
    self.IsDashing = false
    self.QState = 1
    self.QSpell = _Spell({Slot = _Q, DamageName = "Q", Range = 475, Width = 55, Delay = 0, Speed = 1500, Aoe = true, Type = SPELL_TYPE.LINEAR}):AddDraw():SetAccuracy(55)
    --EQ RANGE = 270, Delay = 0.36, Range2 = 400
    --Q1 Range = 475, Delay = 0 or 0.37, Speed = 1500 
    --Q3 Delay 0.35, Speed = 1200, Width = 90, Range = 1100
    --EQ3 Delay = 0.147
    self.WSpell = _Spell({Slot = _W, DamageName = "W", Range = 400, Delay = 0, Type = SPELL_TYPE.SELF})
    self.ESpell = _Spell({Slot = _E, DamageName = "E", Range = 475, Delay = 0, Speed = 1300, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    self.RSpell = _Spell({Slot = _R, DamageName = "R", Range = 2500, Type = SPELL_TYPE.SELF}):AddDraw()
    self.Q = { IsReady = function() return self.QSpell:IsReady() end}
    self.W = { IsReady = function() return self.WSpell:IsReady() end}
    self.E = { IsReady = function() return self.ESpell:IsReady() end}
    self.R = { IsReady = function() return self.RSpell:IsReady() end}
    self.DashedUnits = {}
end

function _Yasuo:LoadMenu()

    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Combo", "Range for Combo", SCRIPT_PARAM_SLICE, 1200, 150, 1200, 0)
        self.Menu.TS:addParam("Harass", "Range for Harass", SCRIPT_PARAM_SLICE, 1000, 150, 1200, 0)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = true})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("MinERange", "Min E Range", SCRIPT_PARAM_SLICE, 275, 150, 475, 0)
        self.Menu.Combo:addParam("R1", "Use R If Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("R2", "Use R If Knocked >= ", SCRIPT_PARAM_SLICE, 2, 0, 5)
        self.Menu.Combo:addParam("Items","Use Items", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("MinERange", "Min E Range", SCRIPT_PARAM_SLICE, 150, 0, 475, 0)
        
    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("Q", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 2, 0, 10)
        self.Menu.LaneClear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("Q", "Use Q", SCRIPT_PARAM_LIST, 3, {"Never", "Smart", "Always"})
        self.Menu.LastHit:addParam("E", "Use E", SCRIPT_PARAM_LIST, 2, {"Never", "Smart", "Always"})

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addParam("R", "Auto R If Knocked >= ", SCRIPT_PARAM_SLICE, 3, 0, 5)
        self.Menu.Auto:addSubMenu("Use W To Evade", "W")
            _Evader(self.Menu.Auto.W):CheckCC():AddCallback(
                function(target) 
                    if self.WSpell:IsReady() then
                        local FixedPos = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized() * self.WSpell.Range
                        CastSpell(self.WSpell.Slot, FixedPos.x, FixedPos.z)
                    end
                end
                )
        self.Menu.Auto:addSubMenu("Use Q3 To Interrupt", "Q3")
            _Interrupter(self.Menu.Auto.Q3):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(
                function(target, spell)
                    if self.QState == 3 then
                        self.QSpell:Cast(target)
                        --[[local spelltype, casttype = getSpellType(target, spell.name)
                        if IsChanelling(target, spelltype) then
                            local object = self:SearchEObject(target)
                            if IsValidTarget(object) and GetDistanceSqr(target, self:EEndPos(object)) < GetDistanceSqr(target, myHero) then
                                self.ESpell:Cast(object)
                            end
                        end]]
                    end
                end
            )

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        self.Menu.Misc:addParam("Avoid", "Avoid dive turret", SCRIPT_PARAM_LIST, 2, {"Never", "If not Killable", "Always"})

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("Damage", "Draw Damage Calculation Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("StackQ", "Stack Q With Minions (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("L"))
        self.Menu.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Keys:permaShow("StackQ")
        self.Menu.Keys.Run = false

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.TS.range = self:GetRange()
            self.TS:update()
            if self.IsDashing then
                self.QSpell.Type = SPELL_TYPE.SELF
                self.QSpell.Range = 270
                self.QSpell.Width = 270
                self.QSpell.Delay = 0.147
                self.QSpell.Speed = math.huge
            elseif self.QState == 3 then
                self.QSpell.Type = SPELL_TYPE.LINEAR
                self.QSpell.Range = 1100
                self.QSpell.Width = 90
                self.QSpell.Delay = 0.25
                self.QSpell.Speed = 1200
            else
                self.QSpell.Type = SPELL_TYPE.LINEAR
                self.QSpell.Range = 475
                self.QSpell.Width = 20
                self.QSpell.Delay = 0.35
                self.QSpell.Speed = 8700
            end

            if self.Menu.Auto.R > 0 and #EnemiesWithBuffType(29, self.RSpell.Range) >= self.Menu.Auto.R then
                self.RSpell:Cast(self.TS.target)
            end

            if not OrbwalkManager:IsCombo() and self.QSpell:IsReady() and self.Menu.Keys.StackQ and OrbwalkManager:CanMove() and self.QState < 3 and not self.Menu.Keys.Run then
                self.EnemyMinions:update()
                for i, object in ipairs(self.EnemyMinions.objects) do
                    if self.QSpell:IsReady() and self.QSpell:ValidTarget(object) then
                        self.QSpell:Cast(object)
                    end
                end
                self.JungleMinions:update()
                for i, object in ipairs(self.JungleMinions.objects) do
                    if self.QSpell:IsReady() and self.QSpell:ValidTarget(object) then
                        self.QSpell:Cast(object)
                    end
                end
            end
            if self.Menu.KillSteal.Q or self.Menu.KillSteal.E or self.Menu.KillSteal.R or self.Menu.KillSteal.Ignite then self:KillSteal() end
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end
            if self.Menu.Keys.Run then
                self:Run()
            end
        end
    )

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.Damage then DrawPredictedDamage() end
        end
    )
    AddProcessSpellCallback(
        function(unit, spell) 
            if myHero.dead or not self.MenuLoaded then return end
            if unit and spell and spell.name and unit.isMe then
                if spell.name:lower() == "yasuoqw" then
                elseif spell.name:lower() == "yasuoq2" then
                elseif spell.name:lower() == "yasuoq3" then
                elseif spell.name:lower() == "yasuodashwrapper" then
                    if spell.target ~= nil and spell.target.networkID ~= nil and self.DashedUnits[spell.target.networkID] == nil then
                        self.IsDashing = true
                        self.DashedUnits[spell.target.networkID] = true
                        DelayAction(function(target) if target ~= nil and self.DashedUnits[target.networkID] ~= nil then self.DashedUnits[target.networkID] = nil end end, 11 - self.ESpell:GetSpellData().level, {spell.target})
                    end
                elseif spell.name:lower():find("recall") then
                end
            end
        end
    )
    AddCreateObjCallback(
        function(obj)
            if obj and obj.name and obj.valid then
                if obj.name:lower():find("q_wind_ready_buff") and GetDistanceSqr(myHero, obj) < 80 * 80 then
                    self.QState = 3
                elseif obj.name:lower():find("yasuo_base_e_dash_hit") and self.IsDashing then
                    self.IsDashing = true
                end
            end
        end
    )
    AddDeleteObjCallback(
        function(obj)
            if obj and obj.name and obj.valid then
                if obj.name:lower():find("q_wind_ready_buff") and GetDistanceSqr(myHero, obj) < 80 * 80 then
                    self.QState = 1
                elseif obj.name:lower():find("yasuo_base_e_dash_hit") and self.IsDashing then
                    self.IsDashing = false
                end
            end
        end
    )
    self.MenuLoaded = true
end

function _Yasuo:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.4 and ValidTarget(enemy, self.TS.range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if self.Menu.KillSteal.Q and ( q or self.QSpell:Damage(enemy) > enemy.health) then 
                    self.QSpell:Cast(enemy)
                    local object = self:SearchEObject(enemy)
                    if IsValidTarget(object) and GetDistanceSqr(enemy, self:EEndPos(object)) < GetDistanceSqr(enemy, myHero) then
                        self:CastE(object)
                    end
                end
                if self.Menu.KillSteal.E and ( e or self.ESpell:Damage(enemy) > enemy.health) then 
                    self:CastE(enemy)
                    local object = self:SearchEObject(enemy)
                    if IsValidTarget(object) and GetDistanceSqr(enemy, self:EEndPos(object)) < GetDistanceSqr(enemy, myHero) then
                        self:CastE(object)
                    end
                end
                if self.Menu.KillSteal.R and ( r or self.RSpell:Damage(enemy) > enemy.health) then 
                    self:CastR(enemy)
                end
            end
            if self.Menu.KillSteal.Ignite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health then CastIgnite(enemy) end
        end
    end
end

function _Yasuo:Harass()
    local target = self.TS.target
    if IsValidTarget(target) then
        if self.Menu.Harass.E and GetDistanceSqr(myHero, target) > math.pow(myHero.range + myHero.boundingRadius + 50, 2) then
            local object = self:SearchEObject(target)
            if IsValidTarget(object) and GetDistanceSqr(target, self:EEndPos(object)) < GetDistanceSqr(target, myHero) then
                if object.networkID ~= target.networkID then
                    self:CastE(object)
                elseif GetDistanceSqr(myHero, target) > math.pow(self.Menu.Harass.MinERange, 2) then
                    self:CastE(object)
                end
            end
        end
        if self.Menu.Harass.Q then self.QSpell:Cast(target) end
    end
end

function _Yasuo:Clear()
    self.QSpell:LaneClear({ NumberOfHits = self.Menu.LaneClear.Q})
    if self.Menu.LaneClear.E then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do
            if self.ESpell:IsReady() then
                self:CastE(minion)
            end
        end
    end
    if self.Menu.JungleClear.Q then
        self.QSpell:JungleClear()
    end
    if self.Menu.JungleClear.E then
        self.JungleMinions:update()
        for i, minion in pairs(self.JungleMinions.objects) do
            if self.ESpell:IsReady() then
                self:CastE(minion)
            end
        end
    end
    local minion = self.ESpell:LastHit({ Mode = self.Menu.LastHit.E, UseCast = false})
    self:CastE(minion)
    self.QSpell:LastHit({ Mode = self.Menu.LastHit.Q})
end

function _Yasuo:LastHit()
    self.ESpell:LastHit({ Mode = self.Menu.LastHit.E})
    self.QSpell:LastHit({ Mode = self.Menu.LastHit.Q})
end

function _Yasuo:Combo()
    local target = self.TS.target
    if IsValidTarget(target) then
        local q, w, e, r, dmg = GetBestCombo(target)
        if self.Menu.Combo.Items then UseItems(target) end
        if self.Menu.Combo.Ignite > 1 and Ignite.IsReady() then 
            if self.Menu.Combo.useIgnite == 2 then
                if dmg / self:GetOverkill() > target.health then CastIgnite(target) end
            else
                CastIgnite(target)
            end
        end
        if self.Menu.Combo.R2 > 0 and #EnemiesWithBuffType(29, self.RSpell.Range) >= self.Menu.Combo.R2 then
            self.RSpell:Cast(self.TS.target)
        end
        if self.Menu.Combo.R1 and dmg >= target.health and r then
            self:CastR(target)
        end
        if self.Menu.Combo.E and GetDistanceSqr(myHero, target) > math.pow(myHero.range + myHero.boundingRadius + 50, 2) then
            local object = self:SearchEObject(target)
            if IsValidTarget(object) then
                if object.networkID ~= target.networkID then
                    self:CastE(object)
                elseif GetDistanceSqr(myHero, target) > math.pow(self.Menu.Combo.MinERange, 2) then
                    self:CastE(object)
                end
            end
        end
        if self.Menu.Combo.Q then self.QSpell:Cast(target) end
    end
end

function _Yasuo:CastE(target)
    if self.ESpell:IsReady() and IsValidTarget(target) and not self:HaveEBuff(target) then
        if self.Menu.Misc.Avoid > 1 and not self.Menu.Keys.Run then
            local endPos = self:EEndPos(target)
            for name, turret in pairs(GetTurrets()) do
                if turret ~= nil and GetDistance(myHero, turret) < 2000 then
                    if turret.team ~= myHero.team and GetDistanceSqr(endPos, turret) < math.pow(turret.range, 2) and GetDistanceSqr(myHero, turret) > math.pow(turret.range, 2)  then
                        if IsValidTarget(self.TS.target) then
                            if self.Menu.Misc.Avoid == 2 then
                                local q, w, e, r, dmg = GetBestCombo(self.TS.target)
                                if dmg < self.TS.target.health then
                                    return
                                end
                            elseif self.Menu.Misc.Avoid == 3 then
                                return
                            end
                        else
                            local counter = 0
                            self.EnemyMinions:update()
                            for i, object in ipairs(self.EnemyMinions.objects) do
                                if IsValidTarget(object) and GetDistanceSqr(object, turret) < math.pow(turret.range, 2) then
                                    counter = counter + 1
                                    break
                                end
                            end
                            if counter == 0 then return end
                        end
                    end
                end
            end
            
        end
        self.ESpell:Cast(target)
    end
end

function _Yasuo:CastR(target)
    if self.RSpell:IsReady() and IsValidTarget(target) and TargetHaveBuffType(29, target) then
        self.RSpell:Cast(target)
    end
end

function _Yasuo:Run()
    local object = self:SearchEObject(mousePos)
    if IsValidTarget(object) then
        self:CastE(object)
    else
        myHero:MoveTo(mousePos.x, mousePos.z)
    end
end

function _Yasuo:SearchEObject(vector)
    if vector ~= nil and self.ESpell:IsReady() then
        local best = nil
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if self.ESpell:ValidTarget(object) and not self:HaveEBuff(object) and GetDistanceSqr(vector, self:EEndPos(object)) < GetDistanceSqr(vector, myHero) then
                if best == nil then best = object
                elseif GetDistanceSqr(vector, self:EEndPos(best)) > GetDistanceSqr(vector, self:EEndPos(object)) then best = object end
            end
        end
        if IsValidTarget(best) then
            return best
        end
        self.JungleMinions:update()
        for i, object in ipairs(self.JungleMinions.objects) do
            if self.ESpell:ValidTarget(object) and not self:HaveEBuff(object) and GetDistanceSqr(vector, self:EEndPos(object)) < GetDistanceSqr(vector, myHero) then
                if best == nil then best = object
                elseif GetDistanceSqr(vector, self:EEndPos(best)) > GetDistanceSqr(vector, self:EEndPos(object)) then best = object end
            end
        end
        if IsValidTarget(best) then
            return best
        end
        for i, object in ipairs(GetEnemyHeroes()) do
            if self.ESpell:ValidTarget(object) and not self:HaveEBuff(object) and GetDistanceSqr(vector, self:EEndPos(object)) < GetDistanceSqr(vector, myHero) then
                if best == nil then best = object
                elseif GetDistanceSqr(vector, self:EEndPos(best)) > GetDistanceSqr(vector, self:EEndPos(object)) then best = object end
            end
        end
        if IsValidTarget(best) then
            return best
        end
    end
    return nil
end

function _Yasuo:EEndPos(target)
    return Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized() * self.ESpell.Range
end

function _Yasuo:HaveEBuff(target)
    return self.DashedUnits[target.networkID] ~= nil
end

function _Yasuo:GetRange()
    if OrbwalkManager:IsCombo() then return self.Menu.TS.Combo
    elseif OrbwalkManager:IsHarass() then return self.Menu.TS.Harass
    else return self.Menu.TS.Combo
    end
end

function _Yasuo:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.QSpell:Damage(target) * (4 - self.QState)
        end
        if w then
        end
        if e then
            comboDamage = comboDamage + self.ESpell:Damage(target)
        end
        if r then
            comboDamage = comboDamage + self.RSpell:Damage(target)
        end
        comboDamage = comboDamage + getDmg("AD", target, myHero) * 3
        comboDamage = comboDamage + DamageItems(target)
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Yasuo:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Fiora"
function _Fiora:__init()
    self.ScriptName = "Headmistress Fiora"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self:LoadVariables()
    self:LoadMenu()
end

function _Fiora:LoadVariables()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 950, DAMAGE_PHYSICAL)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."19062015")
    self.QSpell = _Spell({Slot = _Q, DamageName = "Q", Range = 600, Delay = 0, Speed = 2200, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    self.WSpell = _Spell({Slot = _W, DamageName = "W", Range = 900, Type = SPELL_TYPE.SELF})
    self.ESpell = _Spell({Slot = _E, DamageName = "E", Range = myHero.range + myHero.boundingRadius + 150, Type = SPELL_TYPE.SELF})
    self.RSpell = _Spell({Slot = _R, DamageName = "R", Range = 400, Type = SPELL_TYPE.TARGETTED}):AddDraw()
    self.Q = { IsReady = function() return self.QSpell:IsReady() end, LastCastTime = 0}
    self.W = { IsReady = function() return self.WSpell:IsReady() end}
    self.E = { IsReady = function() return self.ESpell:IsReady() end}
    self.R = { IsReady = function() return self.RSpell:IsReady() end}
    self.Attacks = {}
end

function _Fiora:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Combo", "Range for Combo", SCRIPT_PARAM_SLICE, 900, 150, 1100, 0)
        self.Menu.TS:addParam("Harass", "Range for Harass", SCRIPT_PARAM_SLICE, 350, 150, 900, 0)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = true})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useQ1", "Min. Q1 Range", SCRIPT_PARAM_SLICE, 350, 0, 600)
        self.Menu.Combo:addParam("useQ2", "Min. Q2 Range", SCRIPT_PARAM_SLICE, 350, 0, 600)
        self.Menu.Combo:addParam("useQObject", "Use Q On Object To GapClose", SCRIPT_PARAM_LIST, 2, {"Never", "If Killable" , "Always"})
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR","Use R", SCRIPT_PARAM_LIST, 2, {"Never", "If Killable" , "Always"})
        self.Menu.Combo:addParam("useR2","Use R if HP % <", SCRIPT_PARAM_SLICE, 15, 0, 100)
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useQ1", "Min. Q1 Range", SCRIPT_PARAM_SLICE, 0, 0, 600)
        self.Menu.Harass:addParam("useQ2", "Min. Q2 Range", SCRIPT_PARAM_SLICE, 350, 0, 600)
        self.Menu.Harass:addParam("useQObject","Use Q On Object To GapClose", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)
    
    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 2, {"Never", "Smart", "Always"})
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addParam("useW", "Use W on AA", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Auto:addSubMenu("Use R To Evade", "useR")
            _Evader(self.Menu.Auto.useR):CheckCC():AddCallback(function(target) self.RSpell:Cast(target) end)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.TS.range = self:GetRange()
            self.TS:update()
            if self.Menu.KillSteal.useQ or self.Menu.KillSteal.useE or self.Menu.KillSteal.useR or self.Menu.KillSteal.useIgnite then self:KillSteal() end
            if self.Menu.Auto.useW then self:CheckAA("hero") end
            if not OrbwalkManager:IsNone() and not self:IsQ1() and os.clock() - self.Q.LastCastTime > 3.8 and os.clock() - self.Q.LastCastTime < 4.5  then
                local target = OrbwalkManager:ObjectInRange(self.QSpell.Range)
                self.QSpell:Cast(target)
            end
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end
        end
    )
    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
        end
    )
    AddProcessSpellCallback(
        function(unit, spell)
            if unit and spell and spell.target and ValidTarget(unit) then
                if spell.name:lower():find("attack") and spell.target.isMe then
                    table.insert(self.Attacks, {Unit = unit, WindUpTime = spell.windUpTime, Time = os.clock() - GetLatency()/2000, VectorUnit = Vector(unit), Spell = spell})
                    if self.Menu.Auto.useW then self:CheckAA("hero") end
                end
            end
        end
    )
    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit) 
            if iSpell == self.QSpell.Slot then
                self.Q.LastCastTime = os.clock()
            end
        end
    )
    self.MenuLoaded = true
end

function _Fiora:GetRange()
    if OrbwalkManager:IsCombo() then return self.Menu.TS.Combo
    elseif OrbwalkManager:IsHarass() then return self.Menu.TS.Harass
    else return self.Menu.TS.Combo
    end
end

function _Fiora:CheckAA(type)
    if #self.Attacks > 0 then
        for i = #self.Attacks, 1, -1 do
            local spell = self.Attacks[i]
            if os.clock() + GetLatency()/2000 - spell.Time <= spell.WindUpTime + GetDistance(myHero, spell.VectorUnit)/Prediction.VP:GetProjectileSpeed(spell.Unit) then
                if os.clock() + GetLatency()/2000 - spell.Time >= (spell.WindUpTime + GetDistance(myHero, spell.VectorUnit)/Prediction.VP:GetProjectileSpeed(spell.Unit)) * 0.3 then
                    if spell.Unit and spell.Unit.type:lower():find(type) then
                        self.WSpell:Cast(spell.Unit)
                    end
                end
            else
                table.remove(self.Attacks, i)
            end
        end
    end
end

function _Fiora:IsQ1()
    return os.clock() - self.Q.LastCastTime > 5
end

function _Fiora:SearchQObject(target)
    local best = nil
    if ValidTarget(target) and GetDistanceSqr(myHero, target) > math.pow(self.QSpell.Range, 2) then
        for i, object in ipairs(GetEnemyHeroes()) do
            if self.QSpell:ValidTarget(object) and target.networkID ~= object.networkID then
                if best == nil then best = object
                elseif GetDistanceSqr(target, best) > GetDistanceSqr(target, object) then best = object end
            end
        end
        if ValidTarget(best) and GetDistanceSqr(myHero, target) > GetDistanceSqr(best, target) then
            self.QSpell:Cast(best)
        end
        self.EnemyMinions:update()
        for i, object in ipairs(self.EnemyMinions.objects) do
            if self.QSpell:ValidTarget(object) and target.networkID ~= object.networkID then
                if best == nil then best = object
                elseif GetDistanceSqr(target, best) > GetDistanceSqr(target, object) then best = object end
            end
        end
        if ValidTarget(best) and GetDistanceSqr(myHero, target) > GetDistanceSqr(best, target) then
            self.QSpell:Cast(best)
        end
    end
end

function _Fiora:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.4 and ValidTarget(enemy, self.TS.range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if self.Menu.KillSteal.useQ and ( q or self.QSpell:Damage(enemy) * 2 > enemy.health) and not enemy.dead then self.QSpell:Cast(enemy) end
                if self.Menu.KillSteal.useE and ( e or self.ESpell:Damage(enemy) > enemy.health) and not enemy.dead then self.ESpell:Cast(enemy) end
                if self.Menu.KillSteal.useR and ( r or self.RSpell:Damage(enemy, 3) > enemy.health) and not enemy.dead then self.RSpell:Cast(enemy) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead then CastIgnite(enemy) end
        end
    end
end

function _Fiora:Combo()
    local target = self.TS.target
    if ValidTarget(target) then
        local q, w, e, r, dmg = GetBestCombo(target)
        if self.Menu.Combo.useItems then UseItems(target) end
        if self.Menu.Combo.useIgnite > 1 and Ignite.IsReady() then 
            if self.Menu.Combo.useIgnite == 2 then
                if dmg / self:GetOverkill() > target.health then CastIgnite(target) end
            else
                CastIgnite(target)
            end
        end
        if self.Menu.Combo.useR > 1 then
            if self.Menu.Combo.useR == 2 then
                if dmg > target.health and r then
                    self.RSpell:Cast(target)
                end
            elseif self.Menu.Combo.useR == 3 then
                self.RSpell:Cast(target)
            end
        end
        if self.Menu.Combo.useR2 >= myHero.health / myHero.maxHealth * 100 then
            local best = nil
            for i, object in ipairs(GetEnemyHeroes()) do
                if self.RSpell:ValidTarget(object) then
                    if best == nil then best = object
                    elseif GetPriority(best) > GetPriority(object) then best = object end
                end
            end
            if ValidTarget(best) then
                self.RSpell:Cast(best)
            end
        end
        if self.Menu.Combo.useW then
            self:CheckAA("hero")
        end
        if self.Menu.Combo.useE then
            self.ESpell:Cast(target)
        end
        if self.Menu.Combo.useQ then
            if self:IsQ1() then
                if GetDistanceSqr(myHero, target) > math.pow(self.Menu.Combo.useQ1, 2) then
                    self.QSpell:Cast(target)
                end
            else
                if GetDistanceSqr(myHero, target) > math.pow(self.Menu.Combo.useQ2, 2) then
                    self.QSpell:Cast(target)
                end
            end
            if self.Menu.Combo.useQObject > 1 then
                if self.Menu.Combo.useQObject == 2 then
                    if dmg > target.health then
                        self:SearchQObject(target)
                    end
                elseif self.Menu.Combo.useQObject == 3 then
                    self:SearchQObject(target)
                end
            end
        end
    end
end

function _Fiora:Harass()
    local target = self.TS.target
    if ValidTarget(target) then
        if myHero.mana / myHero.maxMana * 100 >= self.Menu.Harass.Mana then
            if self.Menu.Harass.useW then
                self:CheckAA("hero")
            end
            if self.Menu.Harass.useQ then
                if self:IsQ1() then
                    if GetDistanceSqr(myHero, target) > math.pow(self.Menu.Harass.useQ1, 2) then
                        self.QSpell:Cast(target)
                    end
                else
                    if GetDistanceSqr(myHero, target) > math.pow(self.Menu.Harass.useQ2, 2) then
                        self.QSpell:Cast(target)
                    end
                end
                if self.Menu.Harass.useQObject then
                    self:SearchQObject(target)
                end
            end
            if self.Menu.Harass.useE then
                self.ESpell:Cast(target)
            end
        end
    end
end
function _Fiora:Clear()
    if myHero.mana / myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        if self.Menu.LaneClear.useQ then
            self.QSpell:LaneClear()
        end
        self.QSpell:LastHit({ Mode = self.Menu.LastHit.useQ})
        if self.Menu.LaneClear.useE then
            self.ESpell:LaneClear()
        end
        if self.Menu.LaneClear.useW then
            if OrbwalkManager:GetClearMode() ~= nil and OrbwalkManager:GetClearMode():lower():find("lane") then
                self:CheckAA("minion")
            end
        end
    end
    if self.Menu.JungleClear.useQ then
            self.QSpell:JungleClear()
    end
    if self.Menu.JungleClear.useE then
        self.ESpell:JungleClear()
    end
    if self.Menu.JungleClear.useW then
        if OrbwalkManager:GetClearMode() ~= nil and OrbwalkManager:GetClearMode():lower():find("jungle") then
            self:CheckAA("minion")
        end
    end
end

function _Fiora:LastHit()
    if myHero.mana / myHero.maxMana * 100 >= self.Menu.LastHit.Mana then
        self.QSpell:LastHit({ Mode = self.Menu.LastHit.useQ})
    end
end


function _Fiora:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.QSpell:Damage(target) * 2
            currentManaWasted = currentManaWasted + self.QSpell:Mana()
        end
        if w then
            comboDamage = comboDamage + self.WSpell:Damage(target)
            currentManaWasted = currentManaWasted + self.WSpell:Mana()
        end
        if e then
            comboDamage = comboDamage + self.ESpell:Damage(target)
            currentManaWasted = currentManaWasted + self.ESpell:Mana()
            comboDamage = comboDamage + getDmg("AD", target, myHero) * 3
        end
        if r then
            comboDamage = comboDamage + self.RSpell:Damage(target, 3)
            currentManaWasted = currentManaWasted + self.RSpell:Mana()
        end
        comboDamage = comboDamage + getDmg("AD", target, myHero)
        comboDamage = comboDamage + DamageItems(target)
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Fiora:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Kennen"
function _Kennen:__init()
    self.ScriptName = "iKennen"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.AA = {            Range = function(target) local int1 = 50 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self:LoadVariables()
    self:LoadMenu()
end

function _Kennen:LoadVariables()
    self.LastMarkRequest = 0
    self.EnemiesMarked = {}
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        self.EnemiesMarked[enemy.charName] = false
    end
    self.EnemySoonStunned = {}
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        self.EnemySoonStunned[enemy.charName] = false
    end
    self.AutoAttackMarkObject = nil
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 950, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."20052015")
    self.QSpell = _Spell({Slot = _Q, DamageName = "Q", Range = 950, Width = 50, Delay = 0.175, Speed = 1700, Collision = true, Aoe = false, Type = SPELL_TYPE.LINEAR}):AddDraw()
    self.WSpell = _Spell({Slot = _W, DamageName = "W", Range = 900, Type = SPELL_TYPE.SELF}):AddDraw()
    self.ESpell = _Spell({Slot = _E, DamageName = "E", Range = 950, Type = SPELL_TYPE.SELF})
    self.RSpell = _Spell({Slot = _R, DamageName = "R", Range = 500, Type = SPELL_TYPE.SELF}):AddDraw()
    self.Q = { IsReady = function() return self.QSpell:IsReady() end}
    self.W = { IsReady = function() return self.WSpell:IsReady() end}
    self.E = { IsReady = function() return self.ESpell:IsReady() end}
    self.R = { IsReady = function() return self.RSpell:IsReady() end}
end

function _Kennen:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_LIST, 2, {"Never", "Only On Target", "On Any Enemy"})
        --self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_LIST, 2, {"Never", "If Target Have Mark", "On Any Enemy"})
        self.Menu.Combo:addParam("useW2","Wait until % markeds >=", SCRIPT_PARAM_SLICE, 60, 0, 100)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Combo:addParam("useR2","Use R If Target Is Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("Zhonyas","Use Zhonyas if %hp <= ", SCRIPT_PARAM_SLICE, 15, 0, 100)
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_LIST, 2, {"Never", "Only On Target", "On Any Enemy"})
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_LIST, 2, {"Never", "If Target Have Mark", "On Any Enemy"})
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("Mana", "Min. Energy Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    
    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addParam("useQ", "Auto Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Auto:addParam("useW", "Auto W If Marked Enemies >=", SCRIPT_PARAM_SLICE, 2, 0, 5)
        self.Menu.Auto:addParam("useW2", "Auto W If Range >=", SCRIPT_PARAM_SLICE, 600, 600, 800)
        self.Menu.Auto:addParam("useQStun", "Auto Q If Will Stun", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Auto:addParam("useWStun", "Auto W If Will Stun", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Auto:addParam("Zhonyas", "Auto Zhonyas If R Casted", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("Mark","Circle on Enemies with Mark", SCRIPT_PARAM_ONOFF, true) 
        self.Menu.Draw:addParam("MarkReady","Text if Mark is Ready", SCRIPT_PARAM_ONOFF, true)
        --self.Menu.Draw:addParam("Stunnable","Text if is Stunnable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L")) 
        self.Menu.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Keys:permaShow("HarassToggle")
        self.Menu.Keys.HarassToggle = false
        self.Menu.Keys.Run = false

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.TS:update()
            self:Auto()
            self:KillSteal()
            
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end
            if self.Menu.Keys.Run then self:Run() end
            if self.Menu.Keys.HarassToggle then self:Harass() end
        end
    )
    --[[
    AddProcessSpellCallback(
        function(unit, spell) 
            if myHero.dead or not self.MenuLoaded then return end
            if unit and spell and spell.name and unit.isMe then
                if spell.name:lower():find("kennenshurikenstorm") then 
                    if self.Menu.Auto.Zhonyas and DefensiveItems.Zhonyas.IsReady() then DelayAction(function() CastSpell(DefensiveItems.Zhonyas.Slot()) end, 0.3) end
                end
            end
        end
    )]]
    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit)
            if myHero.dead or not self.MenuLoaded then return end
            if iSpell == self.RSpell.Slot then
                if self.Menu.Auto.Zhonyas and DefensiveItems.Zhonyas.IsReady() then DelayAction(function() CastSpell(DefensiveItems.Zhonyas.Slot()) end, 0.3) end
            end
        end
    )

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
            if self.Menu.Draw.MarkReady then
                if self:HaveAutoAttackMark() then
                    local pos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
                    DrawText("Mark Ready", 20, pos.x, pos.y,  Colors.White)
                end
            end
            if self.Menu.Draw.Stunnable then
                for idx, enemy in ipairs(GetEnemyHeroes()) do
                    if ValidTarget(enemy) then 
                        if self.EnemySoonStunned[enemy.charName] == true then
                            local pos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
                            DrawText("STUNNABLE", 20, pos.x, pos.y,  Colors.Blue)
                        end
                    end
                end
            end
            if self.Menu.Draw.Mark then
                for idx, enemy in ipairs(GetEnemyHeroes()) do
                    if ValidTarget(enemy) then 
                        if self:EnemyIsMarked(enemy) then
                             DrawCircle3D(enemy.x, enemy.y, enemy.z, 80, 2, Colors.Blue, 20)
                        end
                    end
                end
            end
        end
    )

    AddCreateObjCallback(
        function(obj)
            if obj and obj.name and obj.valid then
                if obj.name:lower():find("kennen_ds_proc.troy") and GetDistanceSqr(myHero, obj) < 100 * 100 then
                    self.AutoAttackMarkObject = obj
                elseif obj.name:lower() == "kennen_mos1.troy" or obj.name:lower() == "kennen_mos2.troy" then
                    for idx, enemy in ipairs(GetEnemyHeroes()) do
                        if ValidTarget(enemy, 1200) then 
                            if GetDistanceSqr(Vector(enemy.x, 0, enemy.z), Vector(obj.x, 0, obj.z)) < Prediction.VP:GetHitBox(enemy) * Prediction.VP:GetHitBox(enemy) then
                                self.EnemiesMarked[enemy.charName] = true
                                if obj.name:lower() == "kennen_mos2.troy" then
                                    self.EnemySoonStunned[enemy.charName] = true
                                else
                                    self.EnemySoonStunned[enemy.charName] = false
                                end
                                DelayAction(function() self.EnemiesMarked[enemy.charName] = false end, 6.3)
                                break
                            end
                        end
                    end
                end
            end
        end
    )
    AddDeleteObjCallback(
        function(obj)
            if obj and obj.name and obj.valid then
                if obj.name:lower():find("kennen_ds_proc.troy") and self.AutoAttackMarkObject~=nil and GetDistanceSqr(myHero, obj) < 100 * 100 then
                    self.AutoAttackMarkObject = nil
                elseif obj.name:lower() == "kennen_mos1.troy" or obj.name:lower() == "kennen_mos2.troy" then
                    for idx, enemy in ipairs(GetEnemyHeroes()) do
                        if ValidTarget(enemy, 1200) then 
                            if GetDistanceSqr(Vector(enemy.x, 0, enemy.z), Vector(obj.x, 0, obj.z)) < Prediction.VP:GetHitBox(enemy) * Prediction.VP:GetHitBox(enemy) then
                                self.EnemiesMarked[enemy.charName] = false
                                break
                            end
                        end
                    end
                end
            end
        end
    )
    self.MenuLoaded = true
end

function _Kennen:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.4 and ValidTarget(enemy, self.TS.range) then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health then
                if self.Menu.KillSteal.useQ and ( q or self.QSpell:Damage(enemy) > enemy.health) and not enemy.dead then self:CastQ(enemy) end
                if self.Menu.KillSteal.useW and ( w or self.WSpell:Damage(enemy) > enemy.health) and not enemy.dead then self:CastW(enemy) end
                if self.Menu.KillSteal.useE and ( e or self.ESpell:Damage(enemy) > enemy.health) and not enemy.dead then self:CastE(enemy) end
                if self.Menu.KillSteal.useR and ( r or self.RSpell:Damage(enemy) > enemy.health) and not enemy.dead then self:CastR(enemy) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead then CastIgnite(enemy) end
        end
    end
end

function _Kennen:Auto()
    if self.WSpell:IsReady() and self.Menu.Auto.useW <= #self:EnemyMarkeds() and self.Menu.Auto.useW > 0 then CastSpell(self.WSpell.Slot) end
    if self.WSpell:IsReady() and self.WSpell:ValidTarget(self.TS.target) and GetDistanceSqr(myHero, self.TS.target) >= self.Menu.Auto.useW2 * self.Menu.Auto.useW2 then CastSpell(self.WSpell.Slot) end
    if self.WSpell:IsReady() and self.Menu.Auto.useWStun then 
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self.WSpell:ValidTarget(enemy) then
                if self.EnemySoonStunned[enemy.charName] == true then
                    CastSpell(self.WSpell.Slot)
                end
            end
        end
    end
    if self.QSpell:IsReady() and self.Menu.Auto.useQ then self:CastQ(ts.target, 3) end
    if self.QSpell:IsReady() and self.Menu.Auto.useQStun then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if self.QSpell:ValidTarget(enemy) then
                if self.EnemySoonStunned[enemy.charName] == true then
                    self:CastQ(enemy)
                end
            end
        end
    end
end

function _Kennen:Combo()
    local target = self.TS.target
    if not ValidTarget(target) then return end
    if myHero.health / myHero.maxHealth * 100 < self.Menu.Combo.Zhonyas and DefensiveItems.Zhonyas.IsReady() then CastSpell(DefensiveItems.Zhonyas.Slot()) end
    if self.Menu.Combo.useItems then UseItems(target) end
    if self.RSpell:IsReady() and self.Menu.Combo.useR2 then
        local q, w, e, r, dmg = GetBestCombo(target)
        if r and dmg >= target.health then self:CastR(target) end
    end
    if self.RSpell:IsReady() and self.Menu.Combo.useR <= #self.RSpell:ObjectsInArea(GetEnemyHeroes()) and self.Menu.Combo.useR > 0 then CastSpell(self.RSpell.Slot) end
    if self.Menu.Combo.useE then self:CastE(target) end
    if self.Menu.Combo.useQ > 1 then self:CastQ(target, self.Menu.Combo.useQ) end
    if self.WSpell:IsReady() and self.Menu.Combo.useW2 <= 100 * #self:EnemyMarkeds()/#self.WSpell:ObjectsInArea(GetEnemyHeroes()) then CastSpell(self.WSpell.Slot) end 
end

function _Kennen:Harass()
    local target = self.TS.target
    if not ValidTarget(target) or myHero.mana/myHero.maxMana * 100 < self.Menu.Harass.Mana then return end
    if self.Menu.Harass.useE then self:CastE(target) end
    if self.Menu.Harass.useQ > 1 then self:CastQ(target, self.Menu.Harass.useQ) end
    if self.Menu.Harass.useW > 1 then self:CastW(target, self.Menu.Harass.useW) end
end


function _Kennen:Clear()
    self.EnemyMinions:update()
    self.JungleMinions:update()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        for i, minion in pairs(self.EnemyMinions.objects) do
            if self.Menu.LaneClear.useQ and self.QSpell:ValidTarget(minion) and self.QSpell:IsReady() and not minion.dead then
                self:CastQ(minion)
            end
            if self.Menu.LaneClear.useE and self.ESpell:ValidTarget(minion) and self.ESpell:IsReady() and not minion.dead then
                self:CastE(minion)
            end
            if self.Menu.LaneClear.useW and self.WSpell:ValidTarget(minion) and self.WSpell:IsReady() and not minion.dead then
                if not self:IsE1() then return end
                CastSpell(self.WSpell.Slot)
            end
        end
    end

    for i, minion in pairs(self.JungleMinions.objects) do
        if self.Menu.JungleClear.useQ and self.QSpell:ValidTarget(minion) and self.QSpell:IsReady() and not minion.dead then
            self:CastQ(minion)
        end
        if self.Menu.JungleClear.useE and self.ESpell:ValidTarget(minion) and self.ESpell:IsReady() and not minion.dead then
            self:CastE(minion)
        end
        if self.Menu.JungleClear.useW and self.WSpell:ValidTarget(minion) and self.WSpell:IsReady() and not minion.dead then
            if not self:IsE1() then return end
            CastSpell(self.WSpell.Slot)
        end
    end
end

function _Kennen:LastHit()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LastHit.Mana then
        if self.Menu.LastHit.useQ then
            self.QSpell:LastHit()
        end
    end
end

function _Kennen:CastQ(target, mod)
    local mode = mod or 2
    if self.QSpell:IsReady() then
        if mode == 2 then
            self.QSpell:Cast(target)
        elseif mode == 3 then
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                if self.QSpell:ValidTarget(enemy) then 
                    self.QSpell:Cast(enemy)
                    return
                end
            end
        end
    end
end

function _Kennen:CastW(target, mod)
    local mode = mod or 2
    if self.WSpell:IsReady() then
        if mode == 2 then
            if self:EnemyIsMarked(target) and self.WSpell:ValidTarget(target) then 
                CastSpell(self.WSpell.Slot)
            end
        elseif mode == 3 then
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                if self:EnemyIsMarked(enemy) and self.WSpell:ValidTarget(enemy) then 
                    CastSpell(self.WSpell.Slot)
                    return
                end
            end
        end
    end
end

function _Kennen:CastE(target)
    if self.ESpell:IsReady() then
        if self.ESpell:ValidTarget(target) then
            if self:IsE1() then
                self.ESpell:Cast(target)
            end
        end
    end
end

function _Kennen:CastR(target)
    self.RSpell:Cast(target)
end

function _Kennen:Run()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if self.ESpell:IsReady() then
        if self:IsE1() then
            CastSpell(self.ESpell.Slot)
        else
        end
    end
end

function _Kennen:HaveAutoAttackMark()
    return self.AutoAttackMarkObject ~= nil and self.AutoAttackMarkObject.valid
end

function _Kennen:EnemyIsMarked(enemy)
    if self.EnemiesMarked[enemy.charName] ~= nil then
        return self.EnemiesMarked[enemy.charName]
    end
    return false
end

function _Kennen:IsE1()
    return self.ESpell:GetSpellData().name:lower():find("kennenlightningrush")
end


function _Kennen:EnemyMarkeds()
    local asd = {}
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if self.WSpell:ValidTarget(enemy) then
            if self.EnemiesMarked[enemy.charName] == true then
                table.insert(asd, enemy)
            end
        end
    end
    return asd
end

function _Kennen:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.QSpell:Damage(target)
            currentManaWasted = currentManaWasted + self.QSpell:Mana()
        end
        if w then
            comboDamage = comboDamage + self.WSpell:Damage(target)
            currentManaWasted = currentManaWasted + self.WSpell:Mana()
        end
        if e then
            comboDamage = comboDamage + self.ESpell:Damage(target)
            currentManaWasted = currentManaWasted + self.ESpell:Mana()
            comboDamage = comboDamage + self.AA.Damage(target)
        end
        if r then
            comboDamage = comboDamage + self.RSpell:Damage(target)
            currentManaWasted = currentManaWasted + self.RSpell:Mana()
            comboDamage = comboDamage + self.WSpell:Damage(target)
            comboDamage = comboDamage + self.AA.Damage(target) * 2
        end
        comboDamage = comboDamage + self.AA.Damage(target) * 2
        comboDamage = comboDamage + DamageItems(target)
        local iDmg = Ignite.IsReady() and Ignite.Damage(target) or 0
        comboDamage = comboDamage + iDmg
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Kennen:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Heimerdinger"
function _Heimerdinger:__init()
    self.ScriptName = "Heisendinger"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.Passive = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.Turret = { Range = 525, Width = 525}
    self.AA = {            Range = function(target) local int1 = 50 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q  = { Slot = _Q, DamageName = "Q", Range = 450, Width = self.Turret.Range, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.CIRCULAR, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target, stage) return getDmg("Q", target, myHero, stage) end}
    self.W  = { Slot = _W, DamageName = "W", Range = 1150, Width = 40, Delay = 0, Speed = 3000, LastCastTime = 0, Collision = true, Aoe = true, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target, stage) return getDmg("W", target, myHero, stage) end}
    self.E  = { Slot = _E, DamageName = "E", Range = 925, Width = 120, Delay = 0.25, Speed = 2500, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.CIRCULAR, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target, stage) return getDmg("E", target, myHero, stage) end}
    self.R =  { Slot = _R, DamageName = "R", Range = 0, Width = 420, Delay = 0.3, Speed = math.huge, LastCastTime = 0, Collision = false, NextSpell = "", HaveBuff = false, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target, stage) return getDmg("R", target, myHero, stage) end}
    self:LoadVariables()
    self:LoadMenu()
end

function _Heimerdinger:LoadVariables()
    self.LastFarmRequest = 0
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."28042015")
    self.QSpell = _Spell(self.Q):AddDraw()
    self.WSpell = _Spell(self.W):AddDraw()
    self.ESpell = _Spell(self.E):AddDraw()
    self.RSpell = _Spell(self.R)
end

function _Heimerdinger:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE",  "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useRQ", "Use RQ If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Combo:addParam("useRW", "Use RW If Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useRE", "Use RE If Killable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("Zhonyas", "Use Zhonyas if %hp <", SCRIPT_PARAM_SLICE, 15, 0, 100)
        self.Menu.Combo:addParam("Zhonyas2", "Use Zhonyas After RQ", SCRIPT_PARAM_SLICE, 15, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Harass:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100)
    
    self.Menu:addSubMenu(myHero.charName.." - LaneClear Settings", "LaneClear")
        self.Menu.LaneClear:addParam("useQ", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 3, 0, 10)
        self.Menu.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - JungleClear Settings", "JungleClear")
        self.Menu.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - LastHit Settings", "LastHit")
        self.Menu.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useRQ", "Use RQ", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useRW", "Use RW", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useRE", "Use RE", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use E To Interrupt", "useE")
            _Interrupter(self.Menu.Auto.useE):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(function(target) self:CastE(target) end)

        self.Menu.Auto:addSubMenu("Use Q To Evade", "useQ")
            _Evader(self.Menu.Auto.useQ):CheckCC():AddCallback(function(target) self:EvadeQ(target) end)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        self.Menu.Keys:permaShow("HarassToggle")
        self.Menu.Keys.HarassToggle = false

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.TS:update()
            
            self:KillSteal()
            
                if self.R.HaveBuff and self.R.NextSpell  ~= "" and ValidTarget(self.TS.target) then
                    if self.R.NextSpell == "Q" and self.Q.IsReady() then
                        self:CastQ(self.TS.target)
                        return
                    elseif self.R.NextSpell == "W" and self.W.IsReady() then
                        self:CastW(self.TS.target)
                        return
                    elseif self.R.NextSpell == "E" and self.E.IsReady() then
                        self:CastE(self.TS.target)
                        return
                    else

                    end
                end 


            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end
            
            if self.Menu.Keys.HarassToggle then self:Harass() end
        end
    )
    --[[
    AddProcessSpellCallback(
        function(unit, spell) 
            if myHero.dead or not self.MenuLoaded then return end
            if unit and spell and spell.name and unit.isMe then
                if spell.name:lower() == "" then 
                elseif spell.name:lower() == "heimerdingerq" then 
                    self.Q.LastCastTime = os.clock()
                    DelayAction(
                        function()
                            if self.R.HaveBuff and DefensiveItems.Zhonyas.IsReady() and ValidTarget(self.TS.target) and self.Menu.Combo.Zhonyas2 and not OrbwalkManager:IsNone() then
                                CastSpell(DefensiveItems.Zhonyas.Slot())
                            end
                        end
                    , self.Q.Delay)
                    
                elseif spell.name:lower() == "heimerdingerw" then 
                    self.W.LastCastTime = os.clock()
                elseif spell.name:lower() == "heimerdingere" then 
                    self.E.LastCastTime = os.clock()
                elseif spell.name:lower() == "Heimerdingerr" then 
                    self.R.LastCastTime = os.clock()
                end
            end
        end
    )]]
    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit)
            if iSpell == self.QSpell.Slot then
                self.Q.LastCastTime = os.clock()
                DelayAction(
                        function()
                            if self.R.HaveBuff and DefensiveItems.Zhonyas.IsReady() and ValidTarget(self.TS.target) and self.Menu.Combo.Zhonyas2 and not OrbwalkManager:IsNone() then
                                CastSpell(DefensiveItems.Zhonyas.Slot())
                            end
                        end
                , self.Q.Delay)
            elseif iSpell == self.WSpell.Slot then
                self.W.LastCastTime = os.clock()
            elseif iSpell == self.ESpell.Slot then
                self.E.LastCastTime = os.clock()
            elseif iSpell == self.RSpell.Slot then
                self.R.LastCastTime = os.clock()
            end
        end
    )
    

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
        end
    )

    AddCreateObjCallback(
        function(obj)
            --if obj and obj.name and obj.name:lower():find("heimer") then print("Created "..obj.name) end
            if obj and obj.name and obj.name:lower():find("heimerdinger")  and obj.name:lower():find("_r_beam") then self.R.HaveBuff = true end
        end
    )

    AddDeleteObjCallback(
        function(obj)
            --if obj and obj.name and obj.name:lower():find("heimer") then print("Deleted "..obj.name) end
            if obj and obj.name and obj.name:lower():find("heimerdinger")  and obj.name:lower():find("_r_beam") then 
                self.R.NextSpell = ""
                self.R.HaveBuff = false 
            end
        end
    )

    self.MenuLoaded = true
end

function _Heimerdinger:KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.health/enemy.maxHealth < 0.4 and ValidTarget(enemy, self.TS.range) and enemy.visible then
            local q, w, e, r, dmg = GetBestCombo(enemy)
            if dmg >= enemy.health and enemy.health > 0 then
                if self.Q.IsReady() and self.Menu.KillSteal.useQ and (q or self.Q.Damage(enemy) > enemy.health) and not enemy.dead then self:CastQ(enemy) end
                if self.W.IsReady() and self.Menu.KillSteal.useW and (w or self.W.Damage(enemy) > enemy.health) and not enemy.dead then self:CastW(enemy) end
                if self.E.IsReady() and self.Menu.KillSteal.useE and (e or self.E.Damage(enemy) > enemy.health) and not enemy.dead then self:CastE(enemy) end
                if self.Menu.KillSteal.useRQ and self.R.Damage(enemy, 1) > enemy.health and not enemy.dead then self:CastRQ(enemy) end
                if self.Menu.KillSteal.useRW and self.R.Damage(enemy, 2) * 4 > enemy.health and not enemy.dead then self:CastRW(enemy) end
                if self.Menu.KillSteal.useRE and self.R.Damage(enemy, 3) * 3 > enemy.health and not enemy.dead then self:CastRE(enemy) end
            end
            if self.Menu.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead and ValidTarget(enemy, Ignite.Range) then CastSpell(igniteslot, enemy) end
        end
    end
end

function _Heimerdinger:Combo()
    local target = self.TS.target
    if not ValidTarget(target) then return end
    if myHero.health/myHero.maxHealth*100 < self.Menu.Combo.Zhonyas and DefensiveItems.Zhonyas.IsReady() then CastSpell(DefensiveItems.Zhonyas.Slot()) end
    if self.Menu.Combo.useRQ > 0 and self.Q.IsReady() and self.R.IsReady() and self.Menu.Combo.useRQ <= CountEnemies(myHero, self.Q.Range + self.Turret.Range) then self:CastRQ(target) end
    if self.Menu.Combo.useRE and self.E.IsReady() and self.R.IsReady() and self.R.Damage(target, 3) * 3 > target.health then self:CastRE(target) end
    if self.Menu.Combo.useRW and self.W.IsReady() and self.R.IsReady() and self.R.Damage(target, 2) * 4 > target.health then self:CastRW(target) end
    if self.Menu.Combo.useItems then UseItems(target) end
    if self.Menu.Combo.useE then self:CastE(target) end
    if self.Menu.Combo.useW then self:CastW(target) end
    if self.Menu.Combo.useQ then self:CastQ(target) end
end

function _Heimerdinger:Harass()
    local target = self.TS.target
    if not ValidTarget(target) or myHero.mana/myHero.maxMana * 100 < self.Menu.Harass.Mana then return end
    if self.Menu.Harass.useE then self:CastE(target) end
    if self.Menu.Harass.useW then self:CastW(target) end
    if self.Menu.Harass.useQ then self:CastQ(target) end
end

function _Heimerdinger:Clear()
    self.EnemyMinions:update()
    self.JungleMinions:update()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LaneClear.Mana then
        for i, minion in pairs(self.EnemyMinions.objects) do
            if self.Menu.LaneClear.useQ > 0 and os.clock() - self.LastFarmRequest > 0.2 and ValidTarget(minion, self.Q.Range + self.Turret.Range*2/3) and self.Q.IsReady() and not minion.dead then
                local BestPos, Count = GetBestCircularFarmPosition(self.Q.Range, self.Turret.Range, self.EnemyMinions.objects)
                if Count >= self.Menu.LaneClear.useQ then
                    self:CastQ(BestPos)
                end
                self.LastFarmRequest = os.clock()
            end
            if self.Menu.LaneClear.useE and ValidTarget(minion, self.E.Range) and self.E.IsReady() and not minion.dead then
                self:CastE(minion)
            end
            if self.Menu.LaneClear.useW and ValidTarget(minion, self.W.Range) and self.W.IsReady() and not minion.dead  then
                self:CastW(minion)
            end
        end
    end

    for i, minion in pairs(self.JungleMinions.objects) do
        if self.Menu.JungleClear.useQ and ValidTarget(minion, self.Q.Range + self.Turret.Range*2/3) and self.Q.IsReady() and not minion.dead  then
            self:CastQ(minion)
        end
        if self.Menu.JungleClear.useE and ValidTarget(minion, self.E.Range) and self.E.IsReady() and not minion.dead then
            self:CastE(minion)
        end
        if self.Menu.JungleClear.useW and ValidTarget(minion, self.W.Range) and self.W.IsReady() and not minion.dead  then
            self:CastW(minion)
        end
    end
end

function _Heimerdinger:LastHit()
    if myHero.mana/myHero.maxMana * 100 >= self.Menu.LastHit.Mana and os.clock() - self.LastFarmRequest > 0.05 then
        if self.Menu.LastHit.useW then
            self.WSpell:LastHit()
        end
        if self.Menu.LastHit.useE then
            self.ESpell:LastHit()
        end
        self.LastFarmRequest = os.clock()
    end
end

function _Heimerdinger:CastQ(target)
    if ValidTarget(target) then
        self.QSpell:Cast(target)
    end
end

function _Heimerdinger:CastW(target)
    if ValidTarget(target) then
        self.WSpell:Cast(target)
    end
end

function _Heimerdinger:CastE(target)
    if ValidTarget(target) then
        self.ESpell:Cast(target)
    end
end

function _Heimerdinger:CastRQ(target)
    if self.R.IsReady() and ValidTarget(target, self.TS.range) then
        CastSpell(self.R.Slot)
        self.R.NextSpell = "Q"
    end
    if self.Q.IsReady() then DelayAction(function() self:CastQ(target) end, self.R.Delay) end
end

function _Heimerdinger:CastRW(target)
    if self.R.IsReady() and ValidTarget(target, self.TS.range) then
        CastSpell(self.R.Slot)
        self.R.NextSpell = "W"
    end
    if self.W.IsReady() then DelayAction(function() self:CastW(target) end, self.R.Delay) end
end

function _Heimerdinger:CastRE(target)
    if self.R.IsReady() and ValidTarget(target, self.TS.range) then
        CastSpell(self.R.Slot)
        self.R.NextSpell = "E"
    end
    if self.E.IsReady() then DelayAction(function() self:CastE(target) end, self.R.Delay) end
end

function _Heimerdinger:EvadeQ(target)
    if self.Q.IsReady() and ValidTarget(target, 800) then
        local linear = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized():perpendicular() * 100
        CastSpell(self.Q.Slot, linear.x, linear.z)
    end
end

function _Heimerdinger:GetComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if ValidTarget(target) then
        if q then
            comboDamage = comboDamage + self.Q.Damage(target)
            currentManaWasted = currentManaWasted + self.Q.Mana()
        end
        if w then
            comboDamage = comboDamage + self.W.Damage(target) * 4
            currentManaWasted = currentManaWasted + self.W.Mana()
        end
        if e then
            comboDamage = comboDamage + self.E.Damage(target)
            currentManaWasted = currentManaWasted + self.E.Mana()
            comboDamage = comboDamage + self.AA.Damage(target)
        end
        if r then
            comboDamage = comboDamage + self.R.Damage(target, 2) * 4
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

function _Heimerdinger:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Irelia"
function _Irelia:__init()
    self.ScriptName = "Dat Butt Irelia"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.Passive = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.AA = {            Range = function(target) local int1 = 50 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q  = { Slot = _Q, DamageName = "Q", Range = 650, Width = 0, Delay = 0, Speed = 2200, LastCastTime = 0, Collision = true, Type = SPELL_TYPE.TARGETTED, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) + getDmg("AD", target, myHero) end}
    self.W  = { Slot = _W, DamageName = "W", Range = myHero.range + GetDistance(myHero, myHero.minBBox) + 50, Width = 315, Delay = 0, Speed = math.huge, LastCastTime = 0, Collision = false, Type = SPELL_TYPE.SELF, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E  = { Slot = _E, DamageName = "E", Range = 350, Width = 160, Delay = 0.25, Speed = math.huge, LastCastTime = 0, Collision = false, Type = SPELL_TYPE.TARGETTED, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end}
    self.R  = { Slot = _R, DamageName = "R", Range = 1000, Width = 120, Delay = 0, Speed = 1600, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
    self:LoadVariables()
    self:LoadMenu()
end

function _Irelia:LoadVariables()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."20062015")
    self.QSpell = _Spell(self.Q):AddDraw()
    self.WSpell = _Spell(self.W)
    self.ESpell = _Spell(self.E):AddDraw()
    self.RSpell = _Spell(self.R):AddDraw()
end

function _Irelia:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Combo", "Range for Combo", SCRIPT_PARAM_SLICE, 900, 150, 1100, 0)
        self.Menu.TS:addParam("Harass", "Range for Harass", SCRIPT_PARAM_SLICE, 350, 150, 900, 0)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = true})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("minQRange", "Min. Q Range", SCRIPT_PARAM_SLICE, 250, 0, 650)
        self.Menu.Combo:addParam("useQMinion","Use Q On Minion To GapClose", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_LIST, 3, { "Never", "To Stun", "Smart", "Always"})
        self.Menu.Combo:addParam("useR","Use R", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useRMinion","Use R On Minion To GapClose", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})

    self.Menu:addSubMenu(myHero.charName.." - Harass Settings", "Harass")
        self.Menu.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("minQRange", "Min. Q Range", SCRIPT_PARAM_SLICE, 250, 0, 650)
        self.Menu.Harass:addParam("useQMinion","Use Q on Minion To GapClose", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Harass:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - Clear Settings", "Clear")
        self.Menu.Clear:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 2, { "Never", "Smart", "Always"})
        self.Menu.Clear:addParam("minQRange", "Min. Q Range", SCRIPT_PARAM_SLICE, 0, 0, 650)
        self.Menu.Clear:addParam("maxQRange", "Max. Q Range", SCRIPT_PARAM_SLICE, 450, 0, 650)
        self.Menu.Clear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Clear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Clear:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - Last Hit Settings", "LastHit")
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 3, { "Never", "Smart", "Always"})
        self.Menu.LastHit:addParam("minQRange", "Min. Q Range", SCRIPT_PARAM_SLICE, 0, 0, 650)
        self.Menu.LastHit:addParam("maxQRange", "Max. Q Range", SCRIPT_PARAM_SLICE, 450, 0, 650)
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use QE To Interrupt", "useQE")
            _Interrupter(self.Menu.Auto.useQE):CheckChannelingSpells():AddCallback(function(target) self:ForceQE(target) end)
        self.Menu.Auto:addSubMenu("Use E To Interrupt", "useE")
            _Interrupter(self.Menu.Auto.useE):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(function(target) self:CastE(target, 2) end)
        --self.Menu.Auto:addSubMenu("Use Q To Evade", "useQ")
            --_Evader(self.Menu.Auto.useQ):CheckCC():AddCallback(function(target) self:EvadeQ(target) end)
        self.Menu.Auto:addParam("AutoE",  "Auto E to Stun", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.TS.range = self:GetRange()
            self.TS:update()

            if not OrbwalkManager:IsNone() or self.Menu.Keys.Run then self.EnemyMinions:update() self.JungleMinions:update() end

            if self.Menu.Auto.AutoE and self.E.IsReady() then
                for idx, enemy in ipairs(GetEnemyHeroes()) do
                    if ValidTarget(enemy) and self:CanStun(enemy) and ValidTarget(enemy, self.E.Range) then
                        self:CastE(enemy, 2)
                    end
                end
            end

            if self.Menu.KillSteal.useQ or self.Menu.KillSteal.useE or self.Menu.KillSteal.useR or self.Menu.KillSteal.useIgnite then self:KillSteal() end
            
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end

            if self.Menu.Keys.Run then self:Run() end
        end
    )
    --[[
    AddProcessSpellCallback(
        function(unit, spell) 
            if myHero.dead or not self.MenuLoaded then return end
            if unit and spell and spell.name and unit.isMe then
                if spell.name:lower() == "ireliagatotsu" then self.Q.LastCastTime = os.clock()
                elseif spell.name:lower() == "ireliahitenstyle" then self.E.LastCastTime = os.clock()
                elseif spell.name:lower() == "ireliaequilibriumstrike" then self.W.LastCastTime = os.clock()
                elseif spell.name:lower() == "ireliatranscendentblades" then self.R.LastCastTime = os.clock()
                end
            end
        end
    )]]
    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit)
            if myHero.dead or not self.MenuLoaded then return end
            if iSpell == self.QSpell.Slot then
                self.Q.LastCastTime = os.clock()
            elseif iSpell == self.WSpell.Slot then
                self.W.LastCastTime = os.clock()
            elseif iSpell == self.ESpell.Slot then
                self.E.LastCastTime = os.clock()
            elseif iSpell == self.RSpell.Slot then
                self.R.LastCastTime = os.clock()
            end
        end
    )

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
        end
    )

    self.MenuLoaded = true
end

function _Irelia:GetRange()
    if OrbwalkManager:IsCombo() then return self.Menu.TS.Combo
    elseif OrbwalkManager:IsHarass() then return self.Menu.TS.Harass
    else return self.Menu.TS.Combo
    end
end

function _Irelia:KillSteal()
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

function _Irelia:Run()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if self.E.IsReady() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) and enemy.visible and self:CanStun(enemy) and ValidTarget(enemy, self.E.Range) then
                self:CastE(enemy, 2)
            end
        end
    end
    if ValidTarget(self.TS.target) and self.Q.IsReady() then
        for i, minion in pairs(self.EnemyMinions.objects) do
            if GetDistanceSqr(self.TS.target, minion) > GetDistanceSqr(self.TS.target, myHero) then self:CastQ(minion) end
        end
    end
end

function _Irelia:Combo()
    local target = self.TS.target
    if ValidTarget(target, self.TS.range) then

        if self.Menu.Combo.useIgnite > 1 and Ignite.IsReady() then 
            if self.Menu.Combo.useIgnite == 2 then
                local q, w, e, r, dmg = GetBestCombo(target)
                if dmg > target.health then CastIgnite(target) end
            else
                CastIgnite(target)
            end
        end
        if self.Menu.Combo.useItems then UseItems(target) end
        --if TargetHaveBuff("sheen", myHero) then return end

        if ValidTarget(target, self.Q.Range) and self.Menu.Combo.useQ and GetDistanceSqr(myHero, target) > self.Menu.Combo.minQRange * self.Menu.Combo.minQRange then
            self:CastQ(target)
        elseif self.Q.IsReady() and (self.Menu.Combo.useQMinion or self.Menu.Combo.useRMinion) and not ValidTarget(target, self.Q.Range) and self.Menu.Combo.useQ and GetDistanceSqr(myHero, target) > self.Menu.Combo.minQRange * self.Menu.Combo.minQRange then
            local QMinion = self:CastQMinion()
            local RMinion = self:CastRMinion()
            if QMinion ~= nil and ValidTarget(QMinion) and GetDistanceSqr(QMinion, target) < GetDistanceSqr(myHero, target)  and self.Menu.Combo.useQMinion then CastSpell(_Q, QMinion)
            elseif RMinion ~= nil and ValidTarget(RMinion) and self.Menu.Combo.useRMinion and GetDistanceSqr(RMinion, target) < GetDistanceSqr(myHero, target) then
                local CastPosition, HitChance, Position = self.RSpell:GetPrediction(RMinion)
                CastSpell(self.R.Slot, CastPosition.x, CastPosition.z)
                DelayAction(function() CastSpell(self.Q.Slot, RMinion) end, GetDistance(myHero, RMinion)/self.R.Speed + 0.1) 
            end
        end
        if self.Menu.Combo.useE > 0 then self:CastE(target, self.Menu.Combo.useE) end
        if self.Menu.Combo.useW then self:CastW(target) end
        if self.Menu.Combo.useR and myHero.health/myHero.maxHealth < 0.95 then self:CastR(target) end
    end
end

function _Irelia:Harass()
    local target = self.TS.target
    if ValidTarget(target, self.TS.range) and 100 * myHero.mana / myHero.maxMana >= self.Menu.Harass.Mana then
        if ValidTarget(target, self.Q.Range) and self.Menu.Harass.useQ and GetDistanceSqr(myHero, target) > self.Menu.Harass.minQRange * self.Menu.Harass.minQRange then
            self:CastQ(target)
        elseif self.Menu.Harass.useQMinion and self.Menu.Harass.useQ and GetDistanceSqr(myHero, target) > self.Menu.Harass.minQRange *  self.Menu.Harass.minQRange then
            local QMinion = self:CastQMinion()
            if QMinion ~= nil and ValidTarget(QMinion) and GetDistanceSqr(QMinion, target) < GetDistanceSqr(myHero, target) then CastSpell(self.Q.Slot, QMinion) end
        end
        if self.Menu.Harass.useE then self:CastE(target) end
        if self.Menu.Harass.useW then self:CastW(target) end
    end
end


function _Irelia:Clear()
    if 100 * myHero.mana / myHero.maxMana >= self.Menu.Clear.Mana  then
        if self.Menu.Clear.useQ then
            local minion = self.QSpell:LastHit({ Mode = self.Menu.Clear.useQ, UseCast = false})
            if ValidTarget(minion) and GetDistanceSqr(myHero, minion) > self.Menu.Clear.minQRange * self.Menu.Clear.minQRange and GetDistanceSqr(myHero, minion) < self.Menu.Clear.maxQRange * self.Menu.Clear.maxQRange then
                self:CastQ(minion)
            end
        end
        if self.Menu.Clear.useQ or self.Menu.LastHit.useW or self.Menu.LastHit.useE then
            for i, minion in pairs(self.EnemyMinions.objects) do
                if self.Menu.Clear.useW then self:CastW(minion) end
                if self.Menu.Clear.useE then self:CastE(minion) end
            end
    
            for i, minion in pairs(self.JungleMinions.objects) do
                if self.Menu.Clear.useW then self:CastW(minion) end
                if self.Menu.Clear.useQ and GetDistanceSqr(myHero, minion) < self.Menu.Clear.maxQRange * self.Menu.Clear.maxQRange then self:CastQ(minion) end
                if self.Menu.Clear.useE then self:CastE(minion) end
            end
        end
    end
end

function _Irelia:LastHit()
    if 100 * myHero.mana / myHero.maxMana >= self.Menu.LastHit.Mana then
        if self.Menu.LastHit.useQ then
            local minion = self.QSpell:LastHit({ Mode = self.Menu.LastHit.useQ, UseCast = false})
            if ValidTarget(minion) and GetDistanceSqr(myHero, minion) > self.Menu.LastHit.minQRange * self.Menu.LastHit.minQRange and GetDistanceSqr(myHero, minion) < self.Menu.LastHit.maxQRange * self.Menu.LastHit.maxQRange then
                self:CastQ(minion)
            end
        end
        if self.Menu.LastHit.useE then 
            self.ESpell:LastHit({ Mode = LASTHIT_MODE.ALWAYS})
        end
    end
end

function _Irelia:CastQ(target)
    if self.Q.IsReady() and ValidTarget(target, self.Q.Range) then
        CastSpell(self.Q.Slot, target)
    end 
end

function _Irelia:CastW(target)
    if self.W.IsReady() and ValidTarget(target, self.AA.Range(target) + 100) then
        CastSpell(self.W.Slot)
    end
end


function _Irelia:CastE(target, mod)
    local mode = mod or 4
    if self.E.IsReady() and ValidTarget(target, self.E.Range) then
        if mode == 2 then
            if self:CanStun(target) then CastSpell(self.E.Slot, target) end
        elseif mode == 3 then
            if self:CanStun(target) then 
                CastSpell(self.E.Slot, target)
            elseif GetDistanceSqr(myHero, target) > (self.AA.Range(target) + (self.E.Range - self.AA.Range(target))/3) * (self.AA.Range(target) + (self.E.Range - self.AA.Range(target))/3) and GetDistanceSqr(myHero, target) <= self.E.Range * self.E.Range then
                CastSpell(self.E.Slot, target)
            else
                local q, w, e, r, dmg = GetBestCombo(target)
                if e and dmg > target.health then CastSpell(self.E.Slot, target) end
            end
        elseif mode == 4 then
            CastSpell(self.E.Slot, target)
        end
    end
end

function _Irelia:CastR(target)
    if ValidTarget(target) then
        self.RSpell:Cast(target)
    end
end

function _Irelia:CastQMinion()
    if self.Q.IsReady() then
        local minion = self.QSpell:LastHit({ Mode = LASTHIT_MODE.ALWAYS, UseCast = false})
        return minion
    end
    return nil
end

function _Irelia:CastRMinion()
    if self.R.IsReady() then
        for i, minion in pairs(self.EnemyMinions.objects) do
            if not minion.dead and ValidTarget(minion, self.Q.Range) and minion.valid and minion.health > self.R.Damage(minion) and minion.health < self.Q.Damage(minion) + self.R.Damage(minion) then
                return minion
            end
        end
    end
    return nil
end


function _Irelia:EvadeQ(target)
    if ValidTarget(target, self.Q.Range + 500) and self.Q.IsReady() then
        for i, minion in pairs(self.EnemyMinions.objects) do
            if GetDistanceSqr(target, minion) > GetDistanceSqr(target, myHero) and self.Q.IsReady() then self:CastQ(minion) end
        end
    end
end

function _Irelia:CanStun(target)
    return ValidTarget(target) and target.health/target.maxHealth * 100 >= myHero.health/myHero.maxHealth*100
end

function _Irelia:ForceQE(target)
    if self.E.IsReady() and ValidTarget(target, self.E.Range) then
        self:CastE(target, 2)
    elseif self.Q.IsReady() and ValidTarget(target, self.Q.Range) and self:CanStun(target) then
        self:CastQ(target)
    end
end

function _Irelia:GetComboDamage(target, q, w, e, r)
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
            comboDamage = comboDamage + self.AA.Damage(target)
        end
        if e then
            comboDamage = comboDamage + self.E.Damage(target)
            currentManaWasted = currentManaWasted + self.E.Mana()
             if self:CanStun(target) then comboDamage = comboDamage + self.AA.Damage(target) * 2 end
        end
        if r and os.clock() - self.R.LastCastTime > 15 then
            comboDamage = comboDamage + self.R.Damage(target) * 4
            currentManaWasted = currentManaWasted + self.R.Mana()
        end
        comboDamage = comboDamage + self.AA.Damage(target)
        comboDamage = comboDamage + DamageItems(target)
    end
    comboDamage = comboDamage * self:GetOverkill()
    return comboDamage, currentManaWasted
end

function _Irelia:GetOverkill()
    return (100 + self.Menu.Misc.overkill)/100
end

class "_Lissandra"
function _Lissandra:__init()
    self.ScriptName = "The Ice Witch"
    self.Author = "iCreative"
    self.MenuLoaded = false
    self.Menu = nil
    self.Passive = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
    self.AA = {            Range = function(target) local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
    self.Q  = { Slot = _Q, DamageName = "Q", Range = 715, MinRange = 725, MaxRange = 825, Width = 75, MinWidth = 75, MaxWidth = 100, Delay = 0.25, Speed = 2250, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR, LastRequest2 = 0, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end, LastRange = 0}
    self.W  = { Slot = _W, DamageName = "W", Range = 450, Width = 440, Delay = 0.25, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.SELF, IsReady = function() return (myHero:CanUseSpell(_W) == 3 or myHero:CanUseSpell(_W) == READY) end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E  = { Slot = _E, DamageName = "E", Range = 1050, Width = 110, Delay = 0.25, Speed = 850, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, CastObj = nil, EndObj = nil, MissileObj = nil}
    self.R  = { Slot = _R, DamageName = "R", Range = 550, Width = 550, Delay = 0.25, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.SELF, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
    self:LoadVariables()
    self:LoadMenu()
end

function _Lissandra:LoadVariables()
    self.LastFarmRequest = 0
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.E.Range, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."25042015")
    self.QSpell = _Spell(self.Q):AddDraw():AddRangeFunction(function() return self.Q.Range end)
    self.WSpell = _Spell(self.W):AddDraw()
    self.ESpell = _Spell(self.E):AddDraw():SetAccuracy(35)
    self.RSpell = _Spell(self.R):AddDraw()
end

function _Lissandra:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

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
        self.Menu.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
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
            _Interrupter(self.Menu.Auto.useR):CheckChannelingSpells():AddCallback(function(target) self:CastR(target) end)

        self.Menu.Auto:addSubMenu("Use W To Interrupt", "useW")
            _Interrupter(self.Menu.Auto.useW):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(function(target) self:CastW(target) end)

        self.Menu.Auto:addParam("useW","Use W If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        self.Menu.Auto:addParam("useWTurret","Use W In Turret", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Auto:addParam("useRTurret","Use R In Turret", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        if #GetEnemyHeroes() > 0 then
        self.Menu.Misc:addSubMenu("Don't Use R On: ", "DontR")
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                self.Menu.Misc.DontR:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, false)
            end
        end
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("Passive", "Text if Passive Ready", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        self.Menu.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Keys:permaShow("HarassToggle")
        self.Menu.Keys.Flee = false
        self.Menu.Keys.HarassToggle = false


    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.Q.Range = self:QRange(self.TS.target)
            self.TS.range = self.E.IsReady() and self.E.Range or self.Q.Range
            self.TS:update()
            
            self:CheckAuto()
            
            self:KillSteal()
            
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end
            
            if self.Menu.Keys.HarassToggle then self:Harass() end

            if self.Menu.Keys.Flee then self:Flee() end
        end
    )

    --[[
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
    )]]
    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit)
            if myHero.dead or not self.MenuLoaded then return end
            if iSpell == self.QSpell.Slot then
                self.Q.LastCastTime = os.clock()
            elseif iSpell == self.WSpell.Slot then
                self.W.LastCastTime = os.clock()
            elseif iSpell == self.ESpell.Slot then
                self.E.LastCastTime = os.clock()
                self.E.MissileObj = nil
            elseif iSpell == self.RSpell.Slot then
                self.R.LastCastTime = os.clock()
            end
        end
    )

    AddCreateObjCallback(
        function(obj)
            if obj == nil then return end
            if obj.name:lower():find("lissandra") and obj.name:lower():find("passive_ready") then
                self.Passive.IsReady = true
            elseif obj.name:lower():find("missile") and self.E.MissileObj == nil and (obj.spellOwner and obj.spellOwner.isMe or GetDistanceSqr(myHero, obj) < 50 * 50) and os.clock() - self.E.LastCastTime < 0.35 then
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
            elseif self.E.MissileObj ~= nil and obj.name:lower():find("missile") and (obj.spellOwner and obj.spellOwner.isMe or GetDistanceSqr(self.E.MissileObj, obj) < 80 * 80)  then 
                self.E.MissileObj = nil
            elseif self.E.CastObj ~= nil and obj.name:lower():find("lissandra") and obj.name:lower():find("e_cast.troy") and GetDistanceSqr(obj, self.E.CastObj) < 80 * 80 then 
                self.E.CastObj = nil
            elseif self.E.EndObj ~= nil and obj.name:lower():find("lissandra") and obj.name:lower():find("e_end.troy") and GetDistanceSqr(obj, self.E.EndObj) < 80 * 80 then 
                self.E.EndObj = nil
            end
        end
    )

    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end

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
    if self.W.IsReady() and self.Menu.Auto.useW > 0 and self.Menu.Auto.useW <= #self.WSpell:ObjectsInArea(GetEnemyHeroes()) then CastSpell(self.W.Slot) end
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
    if self.R.IsReady() and self.Menu.Combo.useR > 0 and self.Menu.Combo.useR <= #self.RSpell:ObjectsInArea(GetEnemyHeroes()) then self:CastR(myHero) end
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

                if self.Menu.LaneClear.useW > 0 and self.W.IsReady() and #self.WSpell:ObjectsInArea(self.EnemyMinions.objects) >= self.Menu.LaneClear.useW then
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
        if self.Menu.LastHit.useQ then
            self.QSpell:LastHit()
        end
        if self.Menu.LastHit.useW then
            self.WSpell:LastHit()
        end
        if self.Menu.LastHit.useE then
            self.ESpell:LastHit()
        end
        self.LastFarmRequest = os.clock()
    end
end

function _Lissandra:CastQ(target)
    if self.Q.IsReady() and ValidTarget(target, self.Q.Range) then
        self.QSpell:Cast(target)
    end
end

function _Lissandra:CastW(target)
    if self.W.IsReady() and ValidTarget(target) then
        self.WSpell:Cast(target)
    end
end

function _Lissandra:CastE(target, m)
    local mode = m ~= nil and m or 3
    if self.E.IsReady() then
        if self:IsE1() then 
            self:CastE1(target, mode)
        else 
            local pos = Prediction:GetPredictedPos(target, {Delay = GetDistance(myHero, target)/self.E.Speed})
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
                local pos = Prediction:GetPredictedPos(target, {Delay = self.E.Delay})
                if GetDistanceSqr(myHero, pos) > (self.E.Range * 2/3) * (self.E.Range * 2/3) then
                    local CastPosition, HitChance, Position = self.ESpell:GetPrediction(target)
                    if CastPosition~=nil then 
                        CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
                    end
                end
            end
        elseif mode == 3 then
            self.ESpell:Cast(target)
        end
    end
end

function _Lissandra:CastE2(Position)
    if self.E.EndObj ~= nil and self.E.CastObj ~= nil and self.E.MissileObj ~=nil and Position ~= nil then
        local vectorNearToPos = VectorPointProjectionOnLine(self.E.CastObj, self.E.EndObj, Position)
        if GetDistanceSqr(self.E.EndObj, self.E.MissileObj) < 80 * 80 then
            CastSpell(self.E.Slot)
        elseif GetDistanceSqr(vectorNearToPos, self.E.MissileObj) < 80 * 80 then
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


function _Lissandra:QRange(target)
    local range = self.Q.MinRange
    if ValidTarget(target, self.Q.MaxRange + 50) and os.clock() - self.Q.LastRequest2 > 0.1 then
        local CastPosition, HitChance, Position = Prediction.VP:GetLineCastPosition(target, self.Q.Delay, self.Q.Width, self.Q.Range, self.Q.Speed, myHero, self.Q.Collision)
        if CastPosition~=nil then
            local function CountObjectsOnLineSegment(StartPos, EndPos, range, width, objects)
                local n = 0
                for i, object in ipairs(objects) do
                    if ValidTarget(object, range) and target.networkID ~= object.networkID then
                        local Position, WillHit = Prediction:GetPredictedPos(object, {Delay = self.Q.Delay + GetDistance(StartPos, object)/self.Q.Speed})
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
                        local w = width --+ Prediction.VP:GetHitBox(object) / 3
                        if isOnSegment and WillHit and GetDistanceSqr(pointSegment, Position) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, Position) then
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
        if self.Q.LastRange == self.Q.MinRange then
            self.QSpell.Range = self.Q.MinRange
            self.QSpell.Width = self.Q.MinWidth
        else
            self.QSpell.Range = self.Q.MaxRange
            self.QSpell.Width = self.Q.MaxWidth
        end
        return self.Q.LastRange > 0 and self.Q.LastRange or range
    end
    if range == self.Q.MinRange then
        self.QSpell.Range = self.Q.MinRange
        self.QSpell.Width = self.Q.MinWidth
    else
        self.QSpell.Range = self.Q.MaxRange
        self.QSpell.Width = self.Q.MaxWidth
    end
    return range
end

function _Lissandra:IsE1()
    return self.E.MissileObj == nil
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
    self.Q  = { Slot = _Q, DamageName = "Q", Range = 815, Width = 130, Delay = 0, Speed = 1200, Type = SPELL_TYPE.CIRCULAR, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end}
    self.W  = { Slot = _W, DamageName = "W", Range = 255, Width = 255, Delay = 0.25, Speed = math.huge, Type = SPELL_TYPE.SELF, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E  = { Slot = _E, DamageName = "E", Range = 1095, Width = 85, Delay = 0, Speed = 1800, Type = SPELL_TYPE.TARGETTED_ALLY, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, Missile = nil}
    self.R  = { Slot = _R, DamageName = "R", Range = 410, Width = 410, Delay = 0.5, Speed = math.huge, Type = SPELL_TYPE.SELF, LastCastTime = 0, Collision = false, Aoe = true, ControlPressed = false, Sent = 0, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
    self:LoadVariables()
    self:LoadMenu()
end

function _Orianna:LoadVariables()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.Q.Range + self.Q.Width, DAMAGE_MAGIC)
    self.EnemyMinions = minionManager(MINION_ENEMY, self.Q.Range + self.Q.Width, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."17052015")
    self.LastFarmRequest = 0
    self.Position = myHero
    self.TimeLimit = 0.1
    self.ValidDistance = 2000
    for i = 1, objManager.maxObjects do
        local object = objManager:getObject(i)
        if object and object.name and object.valid and object.name:lower():find("doomball") then
            self.Position = object
        end
    end
    self.QSpell = _Spell(self.Q):AddDraw()
    self.WSpell = _Spell(self.W):AddDraw():AddSourceFunction(function() return self.Position end)
    self.ESpell = _Spell(self.E):AddDraw()
    self.RSpell = _Spell(self.R):AddDraw():AddSourceFunction(function() return self.Position end)
end

function _Orianna:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW", "Use W If Enemies >= ", SCRIPT_PARAM_SLICE, 1, 0, 5)
        self.Menu.Combo:addParam("useE","Use E If Hit >=", SCRIPT_PARAM_SLICE, 1, 0, 5)
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
        self.Menu.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        self.Menu.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu(myHero.charName.." - KillSteal Settings", "KillSteal")
        self.Menu.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        self.Menu.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Auto Settings", "Auto")
        self.Menu.Auto:addSubMenu("Use R To Interrupt", "useR")
            _Interrupter(self.Menu.Auto.useR):CheckChannelingSpells():AddCallback(function(target) self:ForceR(target) end)

        self.Menu.Auto:addSubMenu("Use E To Initiate", "useE")
            _Initiator(self.Menu.Auto.useE):CheckGapcloserSpells():AddCallback(function(unit) if ValidTarget(self.TS.target) then self:CastE(unit) end end)

        self.Menu.Auto:addParam("useW", "Use W If Enemies >= ", SCRIPT_PARAM_SLICE, 3, 0, 5)
        self.Menu.Auto:addParam("useR", "Use R If Enemies >= ", SCRIPT_PARAM_SLICE, 4, 0, 5)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        if VIP_USER then self.Menu.Misc:addParam("BlockR", "Block R If Will Not Hit", SCRIPT_PARAM_ONOFF, false) end
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        _Circle({Menu = self.Menu.Draw, Name = "BallPosition", Text = "Ball Position", Source = function() return self.Position end, Range = 130, Color = { 255, 0, 0, 255 }, Width = 4})

        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
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
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end

            if self.Menu.KillSteal.useQ or self.Menu.KillSteal.useW or self.Menu.KillSteal.useE or self.Menu.KillSteal.useR or self.Menu.KillSteal.useIgnite then self:KillSteal() end

            if ValidTarget(self.TS.target) and (self.Menu.Auto.useW > 0 or self.Menu.Auto.useR > 0) then self:Auto() end

            if self.Menu.Keys.HarassToggle then self:Harass() end
            if self.Menu.Keys.Run then self:Run() end
        end
    )
    --[[
    AddProcessSpellCallback(
        function(unit, spell)
            if myHero.dead or unit == nil or not self.MenuLoaded then return end
            if not unit.isMe then return end
            if spell.name:lower():find("oriana") and spell.name:lower():find("izuna") and spell.name:lower():find("command") then self.Q.LastCastTime = os.clock()
            elseif spell.name:lower():find("oriana") and spell.name:lower():find("dissonance") and spell.name:lower():find("command") then self.W.LastCastTime = os.clock()
            elseif spell.name:lower():find("oriana") and spell.name:lower():find("redact") and spell.name:lower():find("command") then self.E.LastCastTime = os.clock()
            elseif spell.name:lower():find("oriana") and spell.name:lower():find("detonate") and spell.name:lower():find("command") then self.R.LastCastTime = os.clock()
            end
            if unit and spell and unit.isMe and spell.name:lower():find("oriana") and spell.name:lower():find("redact") and spell.name:lower():find("command") then
                DelayAction(function(pos) self.Position = pos end, self.E.Delay + GetDistance(spell.endPos, self.Position) / self.E.Speed, {spell.target})
            end
        end
    )]]
    --BALL MANAGER

    AddAnimationCallback(
        function(unit, animation)
            if unit.isMe and animation == 'Prop' then
                self.Position = myHero
            end
        end
    )

    AddCreateObjCallback(
        function(obj)
            if not obj then return end
            if obj.name:lower():find("orianna") and obj.name:lower():find("yomu") and obj.name:lower():find("ring") and obj.name:lower():find("green") then
                self.Position = obj
            elseif obj.name:lower():find("orianna") and obj.name:lower():find("ball") and obj.name:lower():find("flash") then
                self.Position = myHero
            elseif obj.name:lower() == "missile" and (obj.spellOwner and obj.spellOwner.isMe or GetDistanceSqr(self.Position, obj) < 50 * 50) and (os.clock() - self.Q.LastCastTime < 0.1 or os.clock() - self.E.LastCastTime < 0.1) then
                self.Position = obj
            end
        end
    )
    AddDeleteObjCallback(
        function(obj)
            if not obj then return end
            if obj and obj.name:lower():find("orianna") and obj.name:lower():find("yomu") and obj.name:lower():find("ring") and obj.name:lower():find("green") and GetDistanceSqr(myHero, obj) < 150 * 150 then
                self.Position = myHero
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
    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
        end
    )
    if VIP_USER then
        HookPackets() 
    end
    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit) 
            if iSpell == self.R.Slot and #self.RSpell:ObjectsInArea(GetEnemyHeroes()) == 0  then
                    self.R.Sent = os.clock() - GetLatency()/2000
            end
            if iSpell == self.QSpell.Slot then
                self.Q.LastCastTime = os.clock()
            elseif iSpell == self.WSpell.Slot then
                self.W.LastCastTime = os.clock()
            elseif iSpell == self.ESpell.Slot then
                self.E.LastCastTime = os.clock()
                if targetUnit then
                    DelayAction(function(pos) self.Position = pos end, self.E.Delay + GetDistance(endPos, self.Position) / self.E.Speed, {targetUnit})
                end
            elseif iSpell == self.RSpell.Slot then
                self.R.LastCastTime = os.clock()
            end
        end
    )
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
                local Position, WillHit = Prediction:GetPredictedPos(object, {Delay = delay})
                if GetDistanceSqr(self.Position, Position) <= range * range and WillHit then
                    table.insert(objects2, object)
                end
            end
        end
    end
    return objects2
end

function _Orianna:CastQ(target)
    if ValidTarget(target, self.Q.Range) and self.Q.IsReady() then
        self.QSpell:Cast(target, {Source = self.Position})
    end
end

function _Orianna:CastW(target)
    if self.W.IsReady() and ValidTarget(target, self.Q.Range + self.W.Width/2) then
        if self.Position and self.Position.name and self.Position.name:lower():find("missile") then return end
        self.WSpell:Cast(target)
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
        if self.Position and self.Position.name and self.Position.name:lower():find("missile") then return end
        self.RSpell:Cast(target)
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

        if self.Menu.Combo.useQ then 
            self:CastQ(target) 
        end
        if self.W.IsReady() and self.Menu.Combo.useW > 0 and #self.WSpell:ObjectsInArea(GetEnemyHeroes()) >= self.Menu.Combo.useW then
            CastSpell(self.W.Slot)
        end
        if self.Menu.Combo.useR and self.R.IsReady() and #self:ObjectsInArea(self.Q.Range, self.R.Delay, GetEnemyHeroes()) <= 3 then
            local q, w, e, r, dmg = GetBestCombo(target)
            if dmg >= target.health and r then
                self:CastR(target)
            end
        end
        if self.R.IsReady() and self.Menu.Combo.useR2 > 0 and self.Menu.Combo.useR2 <= #self.RSpell:ObjectsInArea(GetEnemyHeroes()) then
            CastSpell(self.R.Slot)
        end

        if self.Menu.Combo.useE > 0 then
            local BestPos, Count = self:BestHitE(GetEnemyHeroes())
            if BestHit~=nil and BestHit >= self.Menu.Combo.useE and BestPos~=nil and BestPos.team == myHero.team then
                self:CastE(BestPos)
            end
        end

        if self.Menu.Combo.useE2 > 0 and myHero.health/myHero.maxHealth * 100 <= self.Menu.Combo.useE2 then
            self:CastE(myHero)
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
                if self.Menu.LaneClear.useQ > 0 and self.Q.IsReady() then
                    local BestPos, Count = self:BestHitQ(self.EnemyMinions.objects)
                    if BestPos~=nil and self.Menu.LaneClear.useQ <= Count then
                        self:CastQ(BestPos)
                    end
                end

                if self.Menu.LaneClear.useW > 0 and self.W.IsReady() then
                    local Count = #self.WSpell:ObjectsInArea(self.EnemyMinions.objects)
                    if self.Menu.LaneClear.useW <= Count then 
                        CastSpell(self.W.Slot)
                    end
                end
                if self.Menu.LaneClear.useE > 0 and self.E.IsReady() then
                    local BestPos, Count = self:BestHitE(self.EnemyMinions.objects)
                    if BestPos~=nil and self.Menu.LaneClear.useE <= Count then
                        self:CastE(BestPos)
                    end
                end
                self.LastFarmRequest = os.clock()
            end
        end
    end

    self.JungleMinions:update()
    for i, minion in pairs(self.JungleMinions.objects) do
        if ValidTarget(minion, self.Q.Range + self.Q.Width) then 
            if self.Menu.JungleClear.useQ and self.Q.IsReady() then
                CastSpell(self.Q.Slot, minion.x, minion.z)
            end

            if self.Menu.JungleClear.useW and self.W.IsReady() then
                self:CastW(minion)
            end
            if self.Menu.JungleClear.useE and self.E.IsReady() then
                self:CastE(minion)
            end
        end
    end
end


function _Orianna:ThrowBallTo(target, width)
    local EAlly = nil
    if self.E.IsReady() and GetDistanceSqr(self.Position, target) > width * width then
        
        local Position = Prediction:GetPredictedPos(target, {Delay = self.E.Delay + GetDistance(self.Position, target)/self.E.Speed})
        for i = 1, heroManager.iCount do
            local ally = heroManager:GetHero(i)
            if ally.team == player.team and GetDistanceSqr(myHero, ally) < self.E.Range * self.E.Range and GetDistanceSqr(self.Position, ally) > 50 * 50  then
                local Position3 = Prediction:GetPredictedPos(ally, {Delay = self.E.Delay + GetDistance(self.Position, ally)/self.E.Speed})
                if GetDistanceSqr(Position3, Position) <= width * width then
                    if EAlly == nil then 
                        EAlly = ally
                    else
                        local Position2 = Prediction:GetPredictedPos(EAlly, {Delay = self.E.Delay + GetDistance(self.Position, EAlly)/self.E.Speed})
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
            local Position = Prediction:GetPredictedPos(object, {Delay = self.Q.Delay + GetDistance(StartPos, object)/self.Q.Speed})
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
            local w = width --+ Prediction.VP:GetHitBox(object) / 3
            if isOnSegment and GetDistanceSqr(pointSegment, Position) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, Position) then
                n = n + 1
            end
        end
        return n
    end
    for i, object in ipairs(objects) do
        if ValidTarget(object, self.Q.Range) then
            local Position = Prediction:GetPredictedPos(object, {Delay = self.Q.Delay + GetDistance(self.Position, object)/self.Q.Speed})
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
            local Position = Prediction:GetPredictedPos(object, {Delay = self.E.Delay + GetDistance(StartPos, object)/self.E.Speed})
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
            local w = width --+ Prediction.VP:GetHitBox(object) / 3
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
                local Position = Prediction:GetPredictedPos(hero, {Delay = self.E.Delay + GetDistance(self.Position, hero)/self.E.Speed})
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
        if self.Menu.LastHit.useW then
            self.WSpell:LastHit()
        end
        if self.Menu.LastHit.useQ then
            self.QSpell:LastHit()
        end
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ((not ValidTarget(minion, self.AA.Range(minion))) or (ValidTarget(minion, self.AA.Range(minion)) and GetDistanceSqr(minion, OrbwalkManager.LastTarget) > 80 * 80 and not OrbwalkManager:CanAttack() and OrbwalkManager:CanMove())) and not minion.dead then
                if self.Menu.LastHit.useE and self.E.IsReady() and GetDistanceSqr(myHero, self.Position) > 50 * 50 and GetDistanceSqr(myHero, self.Position) > GetDistanceSqr(myHero, minion) and not minion.dead then
                    local dmg = self.E.Damage(minion)
                    local time = self.E.Delay + GetDistance(minion, self.Position) / self.E.Speed + GetLatency() / 2000 - 100/1000
                    local predHealth, a, b = Prediction.VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        local Position = Prediction:GetPredictedPos(minion, {Delay = self.E.Delay + GetDistance(minion, self.Position) / self.E.Speed})
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(self.Position, myHero, Position)
                        if isOnSegment and GetDistanceSqr(pointSegment, object) < self.E.Width * self.E.Width then
                            self:CastE(myHero)
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
    if self.W.IsReady() and self.Menu.Auto.useW > 0 and #self.WSpell:ObjectsInArea(GetEnemyHeroes()) >= self.Menu.Auto.useW then
        CastSpell(self.W.Slot)
    end
    if self.R.IsReady() and self.Menu.Auto.useR > 0 and #self.RSpell:ObjectsInArea(GetEnemyHeroes()) >= self.Menu.Auto.useR then
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


function _Orianna:ForceR(target)
    if self.R.IsReady() and GetDistanceSqr(target, self.Position) < self.R.Range * self.R.Range then
        self:CastR(target)
    elseif self.Q.IsReady() and GetDistanceSqr(target, self.Position) < (self.Q.Range + self.R.Width) * (self.Q.Range + self.R.Width) then
        self:ThrowBallTo(target, self.R.Width)
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
    self.Q       = { Slot = _Q, DamageName = "Q", Range = 1400, MinRange = 750, MaxRange = 1400, Offset = 0, Width = 100, Delay = 0.55, Speed = math.huge, LastCastTime = 0, LastCastTime2 = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end, IsCharging = false, TimeToStopIncrease = 1.5 , End = 3, SentTime = 0, LastFarmCheck = 0, Sent = false}
    self.W       = { Slot = _W, DamageName = "W", Range = 1100, Width = 125, Delay = 0.675, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.CIRCULAR, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end, LastFarmCheck = 0}
    self.E       = { Slot = _E, DamageName = "E", Range = 1050, Width = 60, Delay = 0.25, Speed = 1400, LastCastTime = 0, Collision = true, Aoe = false, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, Missile = nil}
    self.R       = { Slot = _R, DamageName = "R", Range = 3200, Width = 120, Delay = 0.675, Speed = math.huge, LastCastTime = 0, LastCastTime2 = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.CIRCULAR, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end, IsCasting = false, Stacks = 3, ResetTime = 10, MaxStacks = 3, Target = nil, SentTime = 0, Sent = false}
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
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."19052015")
    self.QSpell = _Spell(self.Q):AddDraw():AddRangeFunction(function() return self.Q.Range end)
    self.WSpell = _Spell(self.W):AddDraw()
    self.ESpell = _Spell(self.E):AddDraw()
    self.RSpell = _Spell(self.R):AddDraw():AddRangeFunction(function() return 2000 + 1200 * myHero:GetSpellData(self.R.Slot).level end)
end

function _Xerath:LoadMenu()

    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

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
            _Interrupter(self.Menu.Auto.useE):CheckGapcloserSpells():CheckChannelingSpells():AddCallback(function(target) self:CastE(target) end)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill", "Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        self.Menu.Misc:addParam("SmartCast", "Using Smart Cast", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Misc:addParam("Bugsplat", "Q is Crashing?", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        OrbwalkManager:AddKey({Name = "UseE", Text = "Cast E", Type = SCRIPT_PARAM_ONKEYDOWN, Key = string.byte("E"), Mode = ORBWALK_MODE.COMBO})
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
        
            if OrbwalkManager:IsCombo() then 
                if OrbwalkManager.KeysMenu.UseE then
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
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then
            end
        end
    )
    AddProcessSpellCallback(
        function(unit, spell)
            if myHero.dead or self.Menu == nil or not self.MenuLoaded or unit == nil or not unit.isMe then return end
            if spell.name:lower():find("xeratharcanopulsechargeup") then 
                self.Q.LastCastTime = os.clock()
                self.Q.IsCharging = true
                OrbwalkManager:DisableAttacks()
            elseif spell.name:lower():find("xeratharcanopulse2") then 
                self.Q.LastCastTime2 = os.clock()
                self.Q.IsCharging = false
                OrbwalkManager:EnableAttacks()
            elseif spell.name:lower():find("xeratharcanebarrage2") then 
                self.W.LastCastTime = os.clock()
            elseif spell.name:lower():find("xerathmagespear") then 
                self.E.LastCastTime = os.clock()
                self.E.Missile = nil
            elseif spell.name:lower():find("xerathlocusofpower2") then 
                self.R.LastCastTime = os.clock()
                self.R.IsCasting = true
                self.R.LastCastTime2 = os.clock()
                OrbwalkManager:DisableMovement()
                OrbwalkManager:DisableAttacks()
                DelayAction(function() self.R.Stacks = self.R.MaxStacks self.R.Target = nil self.R.IsCasting = false end, self.R.ResetTime)
            elseif spell.name:lower():find("xerathrmissilewrapper") then 
            elseif spell.name:lower():find("xerathlocuspulse") then
                self.R.LastCastTime2 = os.clock()
                self.R.Stacks = self.R.Stacks - 1
                OrbwalkManager:DisableAttacks()
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
            if obj and os.clock() - self.E.LastCastTime < 0.35 and self.E.Missile == nil and obj.name:lower():find("missile") and ( obj.spellOwner and obj.spellOwner.isMe or GetDistanceSqr(myHero, obj) < 50 * 50)  then 
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
            if obj and self.E.Missile ~= nil and obj == self.E.Missile then 
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
                    DelayAction(function() self.R.Sent = false end, self.TimeLimit + GetLatency()/2000)
                end 
            end
        )
    end

    AddDrawCallback(
        function() 
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
            if self.Menu.Ultimate.NearMouse.Enable and self.Menu.Ultimate.NearMouse.DrawRadius then
                if self.R.IsCasting then
                    DrawCircle3D(mousePos.x, mousePos.y, mousePos.z, self.Menu.Ultimate.NearMouse.MouseRadius, width, Colors.Blue, 30)
                end
            end
            if self.Menu.Ultimate.KillableR and (self.R.IsReady() or self.R.IsCasting) then
                local count = 0
                for idx, enemy in ipairs(GetEnemyHeroes()) do
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

    if self:CanMove() then OrbwalkManager:EnableMovement() else OrbwalkManager:DisableMovement() end
    if self:CanAttack() then OrbwalkManager:EnableAttacks() else OrbwalkManager:DisableAttacks() end
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
        if self.Menu.Keys.WaitE and self.E.IsReady() then return end
        if os.clock() - self.E.LastCastTime < 0.35 or (self.E.Missile ~= nil and GetDistanceSqr(myHero, self.E.Missile) <= GetDistanceSqr(myHero, target)) then return end
        if self.Menu.Combo.useW then self:CastW(target) end
        if self.Menu.Combo.useQ then self:CastQ(target) end
    end
end

function _Xerath:Harass()
    local target = self.TS.target
    if ValidTarget(target) and myHero.mana/myHero.maxMana * 100 >= self.Menu.Harass.Mana then
        if self.Menu.Harass.useE then self:CastE(target) end
        if self.Menu.Keys.WaitE and self.E.IsReady() then return end
        if os.clock() - self.E.LastCastTime < 0.35 or (self.E.Missile ~= nil and GetDistanceSqr(myHero, self.E.Missile) <= GetDistanceSqr(myHero, target)) then return end
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
            local Position, WillHit = Prediction:GetPredictedPos(target, {Delay = delay})
            if Position~=nil and WillHit and GetDistanceSqr(myHero, Position) < self.Q.MaxRange * self.Q.MaxRange then
                self:CastQ1(Position)
            end
        elseif self.Q.IsCharging and ValidTarget(target, self.Q.Range) then
            local CastPosition,  WillHit,  Position = self.QSpell:GetPrediction(target)
            if CastPosition~=nil and WillHit then
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
    if self.Q.IsReady() and Position and self.Q.IsCharging and not self.Menu.Misc.Bugsplat and not OrbwalkManager:Evade() then
        local d3vector = D3DXVECTOR3(Position.x, Position.y, Position.z)
        self.Q.Sent = true
        CastSpell2(self.Q.Slot, d3vector)
        self.Q.Sent = false
    end
end


function _Xerath:CastW(target)
    if self.W.IsReady() and ValidTarget(target, self.W.Range) then
        self.WSpell:Cast(target)
    end
end

function _Xerath:CastE(target)
    if self.E.IsReady() and ValidTarget(target, self.E.Range) then
        self.ESpell:Cast(target)
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
        if ValidTarget(target) then
            self.RSpell:Cast(target)
        end
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
    self.R       = { TS = nil, Slot = _R, DamageName = "R", Range = 1100, Width = 200, Delay = 0.25, Speed = 1600, LastCastTime = 0, Type = SPELL_TYPE.CONE, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Damage = function(target) return getDmg("R", target, myHero) end, State = false}
    self.AA      = { Range = function(target) local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 + 50 end, Reset = false, OffsetRange = 120 ,Damage = function(target) return getDmg("AD", target, myHero) end, LastCastTime = 0}
    self.Q       = { TS = nil, Slot = _Q, DamageName = "Q", Range = 250, Width = 100, Delay = 0.25, Speed = 1400, LastCastTime = 0, Type = SPELL_TYPE.CIRCULAR, Collision = false, Aoe = true, TimeReset = 4, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Damage = function(target) return getDmg("Q", target, myHero) end, State = 0}
    self.W       = { TS = nil, Slot = _W, DamageName = "W", Range = 260, Width = 250, Delay = 0.25, Speed = 1500, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.SELF, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Damage = function(target) return getDmg("W", target, myHero) end}
    self.E       = { TS = nil, Slot = _E, DamageName = "E", Range = 325, Width = 250, Delay = 0, Speed = 1450, LastCastTime = 0, Type = SPELL_TYPE.LINEAR, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Damage = function(target) return getDmg("E", target, myHero) end}
    self:LoadVariables()
    self.queue = _Queue()
    self:LoadMenu()
    self.wallJump        = WallJump()
end

function _Riven:LoadVariables()
    OrbwalkManager:RegisterAfterAttackCallback(function() self:AfterAttack() end)
    OrbwalkManager:TakeControl()
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.R.Range, DAMAGE_PHYSICAL)
    self.R.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.R.Range, DAMAGE_PHYSICAL)
    self.W.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.W.Range, DAMAGE_PHYSICAL)
    self.AllyMinions     = minionManager(MINION_ALLY, 600, myHero, MINION_SORT_HEALTH_ASC)
    self.EnemyMinions    = minionManager(MINION_ENEMY, 600, myHero, MINION_SORT_HEALTH_ASC)
    self.JungleMinions   = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."1.001")
    self.QSpell = _Spell(self.Q):AddDraw():SetAccuracy(50)
    self.WSpell = _Spell(self.W):AddDraw({Enable = false})
    self.ESpell = _Spell(self.E):AddDraw({Enable = false}):SetAccuracy(35)
    self.RSpell = _Spell(self.R):AddDraw():SetAccuracy(35)
end

function _Riven:LoadMenu()
    if self.Menu == nil then return end

    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        self.Menu.TS:addParam("Combo", "Range for Combo", SCRIPT_PARAM_SLICE, 900, 150, 1100, 0)
        self.Menu.TS:addParam("Harass", "Range for Harass", SCRIPT_PARAM_SLICE, 350, 150, 900, 0)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

    self.Menu:addSubMenu(myHero.charName.." - Combo Settings", "Combo")
        self.Menu.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useR1","Use R1: ", SCRIPT_PARAM_LIST, 2, {"Never", "If Needed", "Always"})
        self.Menu.Combo:addParam("useR2","Use R2: ", SCRIPT_PARAM_LIST, 2, {"Never", "If Killable", "Between Q2 - Q3"})
        self.Menu.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Combo:addParam("useTiamat", "Use Tiamat", SCRIPT_PARAM_LIST, 1, {"To Cancel Animation", "To Make Damage"})
        self.Menu.Combo:addParam("useIgnite","Use Ignite If Killable", SCRIPT_PARAM_ONOFF, false)

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

        self.Menu.Auto:addSubMenu("Use Q3 To Interrupt", "useQ")
            _Interrupter(self.Menu.Auto.useQ):CheckChannelingSpells():AddCallback(function(target) self:ForceQ3(target) end)

        self.Menu.Auto:addSubMenu("Use W To Interrupt", "useW")
            _Interrupter(self.Menu.Auto.useW):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(function(target) self:CastW(target) end)

        self.Menu.Auto:addSubMenu("Use EW To Interrupt", "useEW")
            _Interrupter(self.Menu.Auto.useEW):CheckChannelingSpells():AddCallback(function(target) self:ForceEW(target) end)

        self.Menu.Auto:addSubMenu("Use E To Evade", "useE")
            _Evader(self.Menu.Auto.useE):CheckCC():AddCallback(function(target) self:EvadeE(target) end)


    self.Menu:addSubMenu(myHero.charName.." - WallJump Settings", "WallJump")
        self.Menu.WallJump:addParam("MinRange", "Min. Width of Wall", SCRIPT_PARAM_SLICE, 120, 50, 380)
        self.Menu.WallJump:addParam("MaxRange", "Max. Width of Wall", SCRIPT_PARAM_SLICE, 380, 50, 380)


    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("useCancelAnimation","Use Cancel Animation", SCRIPT_PARAM_LIST, 2, {"Never", "Mouse", "Joke", "Taunt", "Dance", "Laugh"})
        self.Menu.Misc:addParam("cancelR","Cancel R Animation", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        self.Menu.Misc:addParam("enemyTurret","Don't cast on enemy turret", SCRIPT_PARAM_ONOFF, false)
        self.Menu.Misc:addParam("developer","Developer mode", SCRIPT_PARAM_ONOFF, false)



    self.Menu:addSubMenu(myHero.charName.." - Draw Settings", "Draw")
        self.Menu.Draw:addParam("TimeQ", "Show Time Left for Q", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("dmgCalc", "Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("FlashCombo","Use R Flash (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        self.Menu.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.Menu.Keys:addParam("WallJump", "Wall Jump (Beta)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))
        --self.Menu.Keys:permaShow("FlashCombo")

        self.Menu.Keys.FlashCombo = false
        self.Menu.Keys.Run     = false
        self.Menu.Keys.WallJump     = false

    PrintMessage(self.ScriptName, "If the Orbwalker cancel your AA, go to Orbwalk Manager and modify the value of Extra WindUpTime")
    AddDrawCallback(function() self:OnDraw() end)
    AddTickCallback(function() self:OnTick() end)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    self.LastStack = 0

    AddApplyBuffCallback(
        function(source, unit, buff)
            if unit and source and buff and unit.isMe and buff.name:lower():find("rivenpassiveaaboost") then
                self.LastStack = 1
            end
        end
    )
    AddUpdateBuffCallback(
        function(unit, buff, stacks)
            if unit and buff and stacks and unit.isMe and buff.name:lower():find("rivenpassiveaaboost") then
                if self.LastStack == stacks + 1 then
                    if not OrbwalkManager:CanMove() then
                        OrbwalkManager:ResetMove()
                    end
                end
                self.LastStack = stacks
            end
        end
    )
    AddRemoveBuffCallback(
        function(unit, buff)
            if unit and buff and unit.isMe and buff.name:lower():find("rivenpassiveaaboost") then
                if self.LastStack == 1 then
                    if not OrbwalkManager:CanMove() then
                        OrbwalkManager:ResetMove()
                    end
                end
                self.LastStack = 0
            end
        end
    )
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

function _Riven:ForceQ3(target)
    if self.Q.IsReady() and self.Q.State == 2 and ValidTarget(target, self.Q.Range + self.Q.Width / 2) then
        self:CastQ(target)
    end
end

function _Riven:ForceEW(target)
    if self.E.IsReady() and ValidTarget(target, self.E.Range + self.W.Width / 2) and GetDistanceSqr(myHero, target) > self.W.Width * self.W.Width then
        self:CastE(target)
    elseif self.W.IsReady() and ValidTarget(target, self.W.Range) then
        self:CastW(target)
    end
end

function _Riven:EvadeE(target)
    if self.E.IsReady() and ValidTarget(target, self.E.Range + 800) then
        local perpendicular = Vector(myHero) + Vector(Vector(target) - Vector(myHero)):normalized():perpendicular() * self.E.Range
        CastSpell(self.E.Slot, perpendicular.x, perpendicular.z)
    end
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
    self.QSpell.Width = self.Q.Width
    self.QSpell.Range = self.Q.Range
    self.WSpell.Width = self.W.Width
    self.WSpell.Range = self.W.Range
end

function _Riven:ShouldUseAA()
    if (OrbwalkManager.GotReset or self.P.Stacks > 2) and not OrbwalkManager:IsNone() then
        local target = OrbwalkManager:ObjectInRange(self.AA.OffsetRange)
        if ValidTarget(target) then
            if self:RequiresAA(target) and (OrbwalkManager:IsCombo() or OrbwalkManager:IsHarass()) then
                return true
            elseif (OrbwalkManager:IsLastHit() or OrbwalkManager:IsClear()) then
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

    if self.Menu.KillSteal.useQ or self.Menu.KillSteal.useW or self.Menu.KillSteal.useIgnite or self.Menu.KillSteal.useR2 or self.Menu.Combo.useR2 == 2 then
        self:KillSteal()
    end
    if not OrbwalkManager:CanCast() then return end
    if self.Menu.Misc.enemyTurret and UnitAtTurret(self.TS.target, 0) and UnitAtTurret(myHero, self.Q.Range) then return end
    if self:ShouldUseAA() then return end

    self:CheckAuto()
    if OrbwalkManager:IsCombo() then self:Combo()
    elseif OrbwalkManager:IsHarass() then self:Harass()
    elseif OrbwalkManager:IsClear() then self:Clear()
    elseif OrbwalkManager:IsLastHit() then self:LastHit() end

    if self.Q.IsReady() and self.Q.State > 0 and os.clock() - self.Q.LastCastTime >= self.Q.TimeReset * 0.9 and os.clock() - self.Q.LastCastTime < self.Q.TimeReset and self.Q.LastCastTime > 0 and not OrbwalkManager:IsNone() then
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
                local CastPosition, HitChance, Count = Prediction.VP:GetCircularAOECastPosition(enemy, self.W.Delay, self.W.Width, self.E.Range, self.E.Speed, myHero)
                if Count ~= nil and Count >= self.Menu.Auto.AutoEW then
                    CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
                    DelayAction(function() CastSpell(self.W.Slot) end, 0.2)
                    break
                end
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
        if self.Menu.Combo.useR1 > 1 or self.Menu.Combo.useR2 > 1 then self:CastR() end
        if self.queue:Size() > 0 then
            if self.Menu.Combo.useW then self:CastW() end
            self.queue:Execute()
        else
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
    if (self.Menu.LastHit.useQ or self.Menu.LastHit.useW or self.Menu.LastHit.useE) and not OrbwalkManager:CanAttack() then
        self.EnemyMinions:update()
        for i, minion in pairs(self.EnemyMinions.objects) do 
            if self.Menu.LastHit.useQ and ValidTarget(minion, self.Q.Range) and self.Q.IsReady() and not minion.dead and self.Q.Damage(minion) > minion.health then
                CastSpell(self.Q.Slot, minion.x, minion.z)
            end
            if self.Menu.LastHit.useW and ValidTarget(minion, self.W.Range) and self.W.IsReady() and not minion.dead and self.W.Damage(minion) > minion.health then
                CastSpell(self.W.Slot)
            end
            if self.Menu.LastHit.useE and OrbwalkManager:InRange(minion, self.E.Range) and self.E.IsReady() and not minion.dead and self.AA.Damage(minion) + self.P.Damage(minion) > minion.health then
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
            local CastPosition, WillHit = self.QSpell:GetPrediction(target)
            if CastPosition~=nil then
                CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
            end
        else
            CastSpell(self.Q.Slot, mousePos.x, mousePos.z)
        end
    elseif self.queue:Size() > 0 then
        local func, key, priority = self.queue:Get(1)
        if key:lower() == tostring("Q"):lower() then
            self.queue:RemoveAt(1)
        end
    end
end

function _Riven:CastQ(targ)
    local target = ValidTarget(targ, self.Q.Range) and targ or self.TS.target
    if self.Q.IsReady() and ValidTarget(target) then
        local CastPosition, WillHit = self.QSpell:GetPrediction(target)
        if ValidTarget(target, self.Q.Range) then
            if OrbwalkManager:InRange(target, self.AA.OffsetRange) and self.Q.State == 0 and OrbwalkManager:CanAttack() and self:RequiresAA(target) then return end
            if self:ShouldUseAA() then return end
            if CastPosition~=nil then
                CastSpell(self.Q.Slot, CastPosition.x, CastPosition.z)
                return
            end
        elseif CastPosition~=nil then
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
        self.WSpell:Cast(target)
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
    if self.E.IsReady() and ValidTarget(target, self.TS.range) then -- and (GetDistanceSqr(myHero, target) > self.E.Range * self.E.Range or (not self.Q.IsReady()) ) 
        CastSpell(self.E.Slot, target.x, target.z)
        return
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
        if self.E.IsReady() and self.Menu.Misc.cancelR then
            CastSpell(self.E.Slot, target.x, target.z)
            local boolean, count, highestPriority = self.queue:Contains("R1")
            if not boolean then
                self.queue:Insert(function() self:CastR1(target) end, "R1", 4)
            end
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
        local CastPosition, WillHit = self.RSpell:GetPrediction(target)
        if CastPosition~=nil and WillHit then
            if self.E.IsReady() and self.Menu.Misc.cancelR then
                CastSpell(self.E.Slot, CastPosition.x, CastPosition.z)
                local boolean, count, highestPriority = self.queue:Contains("R2")
                if not boolean then
                    self.queue:Insert(function() self:CastR2(target) end, "R2", 4)
                end
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
    if OrbwalkManager:IsCombo() and self.Menu.Combo.useTiamat == 1 then
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
        elseif spell.name:lower():find("engine") then
            self:AddStack()
            self:CancelAnimation()
            self.R.LastCastTime = os.clock()
            DelayAction(
                function() 
                    if ValidTarget(self.R.TS.target) and OrbwalkManager:IsCombo() and self.Menu.Keys.FlashCombo then 
                        CastFlash(self.R.TS.target)
                    end 
                end, 0.2)
            DelayAction(
                function() 
                    if ValidTarget(self.R.TS.target) and OrbwalkManager:IsCombo() and self.Menu.Keys.FlashCombo then 
                        CastFlash(self.R.TS.target)
                    end 
                end, 0.4)
        elseif spell.name:lower():find("izunablade") then
            self:AddStack()
            self:CancelAnimation()
            DelayAction(
                function() 
                    if ValidTarget(self.R.TS.target) and OrbwalkManager:IsCombo() and self.Menu.Keys.FlashCombo then 
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
    if OrbwalkManager:IsCombo() then return self.Menu.TS.Combo
    elseif OrbwalkManager:IsHarass() then return self.Menu.TS.Harass
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

    if self.Menu.Misc.developer then
        local pos = WorldToScreen(D3DXVECTOR3(myHero.x , myHero.y, myHero.z))
        --local string = "P: ".." ".. self.P.Stacks
        local string = "CanMove "..tostring(OrbwalkManager:CanMove()).." CanAttack "..tostring(OrbwalkManager:CanAttack())
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
end

function _Riven:CancelAnimation()
    local mode = self.Menu.Misc~=nil and self.Menu.Misc.useCancelAnimation or 1
    local target = OrbwalkManager:ObjectInRange( self.AA.OffsetRange * 2)
    if ValidTarget(target) and mode > 1 then
        if mode == 1 then
        elseif mode == 2 then
            local MovePos = myHero + Vector(Vector(myHero) - Vector(target)):normalized() * Prediction.VP:GetHitBox(myHero) * 1.5
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
    if not OrbwalkManager:IsAttacking() then myHero:MoveTo(mousePos.x, mousePos.z) end
    if self.E.IsReady() and os.clock() - self.Q.LastCastTime > 0.25 + GetLatency()/2000 then
        CastSpell(self.E.Slot, mousePos.x, mousePos.z)
        self.E.LastCastTime = os.clock()
        return
    end
    if self.Q.IsReady() and os.clock() - self.E.LastCastTime > 0.25 + GetLatency()/2000 then
        CastSpell(self.Q.Slot, mousePos.x, mousePos.z)
        self.Q.LastCastTime = os.clock()
        return
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
                return
            end
            if self.Q.IsReady() then
                if self.Q.State < 2 then
                    if GetDistanceSqr(myHero, wall) > (self.Q.Range + 50) * (self.Q.Range + 50) then
                        CastSpell(self.Q.Slot, wall.x, wall.z)
                        return
                    else
                        local pos = wall - Vector(wall.x - myHero.x, 0, wall.z - myHero.z):normalized() * self.Q.Range
                        CastSpell(self.Q.Slot, pos.x, pos.z)
                        return
                    end
                elseif GetDistanceSqr(myHero, wall) <= stop * stop then
                    if GetDistanceSqr(myHero, wall) < GetDistanceSqr(myHero, wall2) and os.clock() - self.Q.LastCastTime > 0.8 and os.clock() - self.E.LastCastTime > 0.3 then
                        CastSpell(self.Q.Slot, wall2.x, wall2.z)
                        return
                    end
                end
            end
        end
    else
        myHero:MoveTo(mousePos.x, mousePos.z)
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
    self.Q       = { Slot = _Q, DamageName = "Q", Range = 1075, Width = 60, Delay = 0.5, Speed = 1200, LastCastTime = 0, Collision = true, Aoe = false, Type = SPELL_TYPE.SELF, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("P", target, myHero) end, IsCatching = false, Stacks  = 0}
    self.W       = { Slot = _W, DamageName = "W", Range = 950, Width = 315, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = false, Type = SPELL_TYPE.SELF, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return 0 end, HaveMoveSpeed = false, HaveAttackSpeed = false}
    self.E       = { Slot = _E, DamageName = "E", Range = 1050, Width = 130, Delay = 0.25, Speed = 1600, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end}
    self.R       = { Slot = _R, DamageName = "R", Range = 20000, Width = 155, Delay = 0.5, Speed = 2000, LastCastTime = 0, Collision = false, Aoe = true, Type = SPELL_TYPE.LINEAR, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end, Obj = nil}
    self:LoadVariables()
    self:LoadMenu()
end

function _Draven:LoadVariables()
    self.ProjectileSpeed = myHero.range > 300 and Prediction.VP:GetProjectileSpeed(myHero) or math.huge
    self.TS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
    self.EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Menu = scriptConfig(self.ScriptName.." by "..self.Author, self.ScriptName.."1.000")
    self.AxesCatcher = _AxesCatcher()
    self.QSpell = _Spell(self.Q)
    self.WSpell = _Spell(self.W)
    self.ESpell = _Spell(self.E):AddDraw()
    self.RSpell = _Spell(self.R):AddDraw()
    --OrbwalkManager:TakeControl()
end

function _Draven:LoadMenu()
    self.Menu:addSubMenu(myHero.charName.." - Target Selector Settings", "TS")
        self.Menu.TS:addTS(self.TS)
        _Circle({Menu = self.Menu.TS, Name = "Draw", Text = "Draw circle on Target", Source = function() return self.TS.target end, Range = 120, Condition = function() return ValidTarget(self.TS.target, self.TS.range) end, Color = {255, 255, 0, 0}, Width = 4})
        _Circle({Menu = self.Menu.TS, Name = "Range", Text = "Draw circle for Range", Range = function() return self.TS.range end, Color = {255, 255, 0, 0}, Enable = false})

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
            _Interrupter(self.Menu.Auto.useE):CheckGapcloserSpells():CheckChannelingSpells():AddCallback(function(target) self:CastE(target) end)

    self.Menu:addSubMenu(myHero.charName.." - Axe Settings", "Axe")
        self.AxesCatcher:LoadMenu(self.Menu.Axe)

    self.Menu:addSubMenu(myHero.charName.." - Misc Settings", "Misc")
        self.Menu.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
        self.Menu.Misc:addParam("rRange","R Range", SCRIPT_PARAM_SLICE, 1800, 300, 6000, 0)
        self.Menu.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    self.Menu:addSubMenu(myHero.charName.." - Drawing Settings", "Draw")
        self.Menu.Draw:addParam("dmgCalc","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu(myHero.charName.." - Key Settings", "Keys")
        OrbwalkManager:LoadCommonKeys(self.Menu.Keys)
        self.Menu.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

    AddTickCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            self.R.Range = self.Menu.Misc.rRange
            self.TS:update()
        
            self.AxesCatcher:CheckCatch()
        
            self:KillSteal()
        
            if OrbwalkManager:IsCombo() then self:Combo()
            elseif OrbwalkManager:IsHarass() then self:Harass()
            elseif OrbwalkManager:IsClear() then self:Clear() 
            elseif OrbwalkManager:IsLastHit() then self:LastHit()
            end
        
            if self.Menu.Keys.Flee then self:Flee() end
        end
    )


    AddCastSpellCallback(
        function(iSpell, startPos, endPos, targetUnit)
            if myHero.dead or not self.MenuLoaded then return end
            if iSpell == self.QSpell.Slot then
                self.Q.LastCastTime = os.clock()
            elseif iSpell == self.WSpell.Slot then
                self.W.LastCastTime = os.clock()
                self.W.HaveMoveSpeed = true
                self.W.HaveAttackSpeed = true
            elseif iSpell == self.ESpell.Slot then
                self.E.LastCastTime = os.clock()
            elseif iSpell == self.RSpell.Slot then
                self.R.LastCastTime = os.clock()
            end
        end
    )
    --[[
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
    )]]


    AddDrawCallback(
        function()
            if myHero.dead or self.Menu == nil or not self.MenuLoaded then return end
            if self.Menu.Draw.dmgCalc then DrawPredictedDamage() end
        end
    )
    AddCreateObjCallback(
        function(obj)
            if obj and os.clock() - self.R.LastCastTime < 0.5 and obj.name:lower():find("missile") and ( obj.spellOwner and obj.spellOwner.isMe or GetDistanceSqr(myHero, obj) < 100 * 100) then
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
    if not OrbwalkManager:IsAttacking() then myHero:MoveTo(mousePos.x, mousePos.z) end
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
                    local CastPosition,  HitChance,  Count = Prediction.VP:GetLineAOECastPosition(enemy, self.R.Delay, self.R.Width, GetDistance(myHero, self:GetLastRTarget()) + 200, self.R.Speed, myHero)
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
            local time = OrbwalkManager:WindUpTime() - OrbwalkManager:ExtraWindUp() + GetLatency()/2000 + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - 100/1000
            local predHealth = Prediction.VP:GetPredictedHealth(minion, time, 0)
            local axedmg = self.AxesCatcher:GetCountAxes() > 0 and self.Q.Damage(minion) or 0
            if Prediction.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + axedmg > predHealth and predHealth > -40 then
                if self.AxesCatcher:GetCountAxes() == 0 then
                    self:CastQ(minion, 2)
                end
            end
        end
        if self.Menu.LastHit.useE then
            self.ESpell:LastHit()
        end
    end
end

function _Draven:CastQ(target, m)
    local mode = m ~= nil and m or 3
    if self.Q.IsReady() and ValidTarget(target, self.TS.range) and self.AxesCatcher:GetCountAxes() < 2 and OrbwalkManager:CanAttack() then
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
        self.ESpell:Cast(target)
    end
end

function _Draven:CastR(target)
    if self.R.IsReady() and ValidTarget(target, self.R.Range) then
        if self.R.Obj == nil then
            self.RSpell:Cast(target)
        elseif self.R.Obj ~= nil then
            if GetDistanceSqr(myHero, self.R.Obj) > GetDistanceSqr(myHero, self:GetLastRTarget()) then
                CastSpell(self.R.Slot)
            end
        end
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
    self.ProjectileSpeed = myHero.range > 300 and Prediction.VP:GetProjectileSpeed(myHero) or math.huge
end

function _AxesCatcher:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        self.Menu:addParam("Catch", "Catch Axes (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("Z"))
        self.Menu.Catch = true
        self.Menu:addParam("CatchMode", "Catch Condition", SCRIPT_PARAM_LIST, 1, { "When Orbwalking", "AutoCatch"})
        self.Menu:addParam("OrbwalkMode",  "Catch Mode", SCRIPT_PARAM_LIST, 2, { "Mouse In Radius", "MyHero In Radius"})
        self.Menu:addParam("UseW", "Use W to Catch (Smart)", SCRIPT_PARAM_ONOFF, false)
        self.Menu:addParam("Turret", "Dont Catch Under Turret", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addParam("DelayCatch", "% of Delay to Catch", SCRIPT_PARAM_SLICE, 100, 0, 100)
        self.Menu:addSubMenu("Catch Radius", "CatchRadius")
            self.Menu.CatchRadius:addParam("Combo", "Combo Radius", SCRIPT_PARAM_SLICE, 250, 150, 600, 0)
            self.Menu.CatchRadius:addParam("Harass", "Harass Radius", SCRIPT_PARAM_SLICE, 350, 150, 600, 0)
            self.Menu.CatchRadius:addParam("Clear", "Clear Radius", SCRIPT_PARAM_SLICE, 400, 150, 800, 0)
            self.Menu.CatchRadius:addParam("LastHit", "LastHit Radius", SCRIPT_PARAM_SLICE, 400, 150, 800, 0)
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
                    table.insert(self.AxesAvailables, {obj, os.clock() - GetLatency() / 2000})
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
    if OrbwalkManager:IsCombo() then
        return self.Menu.CatchRadius.Combo
    elseif OrbwalkManager:IsHarass() then
        return self.Menu.CatchRadius.Harass
    elseif OrbwalkManager:IsClear() then
        return self.Menu.CatchRadius.Clear
    elseif OrbwalkManager:IsLastHit() then
        return self.Menu.CatchRadius.LastHit
    elseif self.Menu~=nil then
        return self.Menu.CatchRadius.Clear
    end
end

function _AxesCatcher:InTurret(obj)
    local offset = Prediction.VP:GetHitBox(myHero) / 2
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

function _AxesCatcher:CheckAxe(axe, time)
    local CanMove = false
    local CanAttack = false
    if axe ~= nil and axe.valid and os.clock() + GetLatency()/2000 - time <= self.LimitTime and self:InRadius(axe) and not self:InTurret(axe) then
        local timeLeft = self.LimitTime - (os.clock() + GetLatency()/2000 - time)
        local AxeRadius = 1 / 1 * self.AxeRadius
        local AxeCatchPositionFromHero  = Vector(axe) + Vector(Vector(myHero) - Vector(axe)):normalized() * math.min(AxeRadius, GetDistance(myHero, axe))
        local AxeCatchPositionFromMouse = Vector(axe) + Vector(Vector(mousePos) - Vector(axe)):normalized() * math.min(AxeRadius, GetDistance(mousePos, axe))
        local OrbwalkPosition = Vector(myHero) + Vector(Vector(mousePos) - Vector(axe)):normalized() * AxeRadius
        local time = timeLeft - ((GetDistance(myHero, AxeCatchPositionFromHero)) / myHero.ms) - (OrbwalkManager:WindUpTime() + GetLatency()/2000 
            --+ champ.AA.Range(champ.TS.target) / self.ProjectileSpeed 
            - 100/1000)
        --Is in AxeRange
        if self:InAxeRadius(axe) then
            CanAttack = true
        --Can Attack Meanwhile
        elseif time >= 0 and OrbwalkManager:CanAttack() then --+ orbwalker:WindUpTime() -
            CanAttack = true
            if champ.Menu.Misc.developer then print("Can Attack Meanwhile") end
        else
            CanAttack = false
        end
        if GetDistance(myHero, AxeCatchPositionFromHero) + 100 > myHero.ms * timeLeft * self:GetDelayCatch() then
            CanMove = false
            --can catch without W and self:GetCountAxes() > 1
            if not self:InAxeRadius(axe) and GetDistanceSqr(myHero, AxeCatchPositionFromHero) > (myHero.ms * timeLeft * 1.5) * (myHero.ms * timeLeft * 1.5) and GetDistanceSqr(myHero, AxeCatchPositionFromHero) < (myHero.ms * timeLeft * self:GetBonusSpeed()) * (myHero.ms * timeLeft * self:GetBonusSpeed()) then
                if self.Menu.UseW and champ.W.IsReady() then
                    CastSpell(champ.W.Slot)
                end
            end
        --can orbwalk
        else
            CanMove = true
        end
    else
        CanAttack = true
        CanMove = true
    end
    if os.clock() - time > self.LimitTime + 0.2 then
        self:RemoveAxe(axe)
    end
    return CanMove, CanAttack
end

function _AxesCatcher:CheckCatch()
    local List = self.AxesAvailables--self:GetSortedList()
    if #List > 0 then
        if self.Menu~=nil and self.Menu.Catch and (( self.Menu.CatchMode == 1 and not OrbwalkManager:IsNone()) or self.Menu.CatchMode == 2 ) then
            local CanMove, CanAttack = true, true
            for i = 1, #List, 1 do
                if List[i] and List[i][1] then
                    local axe, time = List[i][1], List[i][2]
                    if axe and time then
                        local CanMove1, CanAttack1 = self:CheckAxe(axe, time)
                        if not CanMove1 then
                            CanMove = false
                        end
                        if not CanAttack1 then
                            CanAttack = false
                        end
                    end
                end
            end
            if List[1] and List[1][1] then
                if CanAttack then
                    OrbwalkManager:EnableAttacks()
                else
                    OrbwalkManager:DisableAttacks()
                end
                if CanMove then
                    OrbwalkManager:EnableMovement()
                else
                    OrbwalkManager:DisableMovement()
                    if not self:InAxeRadius(List[1][1]) and OrbwalkManager:CanMove(0.2) and not OrbwalkManager:IsAttacking() then
                        if champ.Menu.Misc.developer then PrintMessage("Moving to Axe") end
                        myHero:MoveTo(List[1][1].x, List[1][1].z) 
                    end
                end
            end
        else
            OrbwalkManager:EnableAttacks()
            OrbwalkManager:EnableMovement()
        end
    else
        OrbwalkManager:EnableAttacks()
        OrbwalkManager:EnableMovement()
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
    if not OrbwalkManager:IsNone() then
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
                    local target = OrbwalkManager:ObjectInRange(champ.AA.OffsetRange)
                    if ValidTarget(target) and champ.Q.IsReady() then
                        self:Insert(function() champ:CastQ() end, "Q", 2)
                    end
                end
            ,spell.windUpTime - GetLatency()/2000 * 2)
        elseif spell.name:lower():find("riventricleave") then
            self:Remove("Q", 1)
        elseif spell.name:lower():find("rivenmartyr") then
            self:Remove("W", 1)
            local target = OrbwalkManager:ObjectInRange(champ.TS.range)
            if ValidTarget(target) then
                self:Insert(function() champ:CastTiamat(target) end, "TIAMAT", 1)
            end
            self:Insert(function() champ:CastQ() end, "Q", 1) 
        elseif spell.name:lower():find("rivenfeint") then
            self:Remove("E", 1)
            local target = OrbwalkManager:ObjectInRange(champ.TS.range)
            if ValidTarget(target) then
                self:Insert(function() champ:CastTiamat(target) end, "TIAMAT", 1)
            end
            self:Insert(function() champ:CastQ() end, "Q", 1)
            self:Insert(function() champ:CastW() end, "W", 1)
        elseif spell.name:lower():find("engine") then
            self:Remove("R1", 1)
            if champ.Menu.Misc.cancelR then
                self:Insert(function() champ:CastQFast() end, "Q", 3)
            end
            if champ.Menu.Combo.useR2 > 1 then 
                DelayAction(function()
                    self:Insert(function() champ:CastR2() end, "R2", 4) 
                end, 14) 
            end
        elseif spell.name:lower():find("izunablade") then
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
    if OrbwalkManager:IsCombo() then
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
            return champ.Menu.Combo.useTiamat == 1
        end
    elseif OrbwalkManager:IsHarass() then
        if key:lower() == tostring("Q"):lower() then
            return champ.Menu.Harass.useQ
        elseif key:lower() == tostring("W"):lower() then
            return champ.Menu.Harass.useW
        elseif key:lower() == tostring("E"):lower() then
            return champ.Menu.Harass.useE
        elseif key:lower() == tostring("TIAMAT"):lower() then
            return champ.Menu.Harass.useTiamat
        end
    elseif OrbwalkManager:IsClear() then
        local tipo = OrbwalkManager:GetClearMode()
        if tipo ~= nil then
            if key:lower() == tostring("Q"):lower() then
                if tipo:lower() == tostring("lane"):lower() then
                    return champ.Menu.LaneClear.useQ
                else
                    return champ.Menu.JungleClear.useQ
                end
            elseif key:lower() == tostring("W"):lower() then
                if tipo:lower() == tostring("lane"):lower() then
                    return champ.Menu.LaneClear.useW
                else
                    return champ.Menu.JungleClear.useW
                end
            elseif key:lower() == tostring("E"):lower() then
                if tipo:lower() == tostring("lane"):lower() then
                    return champ.Menu.LaneClear.useE
                else
                    return champ.Menu.JungleClear.usee
                end
            elseif key:lower() == tostring("TIAMAT"):lower() then
                if tipo:lower() == tostring("lane"):lower() then
                    return champ.Menu.LaneClear.useTiamat
                else
                    return champ.Menu.JungleClear.useTiamat
                end
            end
        end
    elseif OrbwalkManager:IsLastHit() then
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
        if OrbwalkManager:CanCast() and not OrbwalkManager:IsNone() then
            if champ:ShouldUseAA() then return end
            local i = 1
            local func, key, priority = self:Get(i)
            if self:IsValidCast(key) and not OrbwalkManager:IsNone() then
                --if champ.Menu.Misc.developer then print("ValidCast "..key.." Priority: "..priority) end
                func()
            else
                --if champ.Menu.Misc.developer then print("NOT ValidCast " ..key.." Priority: "..priority) end
                self:RemoveAt(i)
            end
        end
    end
end

local Jumps = {
    
}
function WriteJumps()
    local string = "local Jumps = {\n\t"
    for i, jump in pairs(Jumps) do
        local temp = ""
        local from = jump.p1
        local to = jump.p2
        string = string .. " { " .. "p1 = { x = " .. from.x..", y = "..from.y..", z = "..from.z.."}, p2 = { x = " .. to.x..", y = "..to.y..", z = "..to.z .."} }, \n\t"
    end
    string = string .."\n}"
    print(string)

    local file = io.open(LIB_PATH.."jumps.txt", "w")
    if file then
        file:write(string)
        file:close()
    end
end

function AddJump(p1, p2)
    local minDistanceSqr1 = 0
    if #Jumps > 0 then
        for i, jump in pairs(Jumps) do
            if minDistanceSqr1 == 0 then
                minDistanceSqr1 = GetDistanceSqr(p1, jump.p1)
            elseif minDistanceSqr1 > GetDistanceSqr(p1, jump.p1) then
                minDistanceSqr1 = GetDistanceSqr(p1, jump.p1)
            end
        end
    end
    local minDistanceSqr2 = 0
    if #Jumps > 0 then
        for i, jump in pairs(Jumps) do
            if minDistanceSqr2 == 0 then
                minDistanceSqr2 = GetDistanceSqr(p2, jump.p2)
            elseif minDistanceSqr2 > GetDistanceSqr(p2, jump.p2) then
                minDistanceSqr2 = GetDistanceSqr(p2, jump.p2)
            end
        end
    end

    if (minDistanceSqr2 > 100 * 100 or minDistanceSqr1 > 100 * 100) or (#Jumps == 0) then
        table.insert(Jumps, {p1 = p1, p2 = p2})
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
        DrawCircle3D(p1.x, p1.y, p1.z, Prediction.VP:GetHitBox(myHero), 1, Colors.Blue, 10)
        DrawCircle3D(p2.x, p2.y, p2.z, Prediction.VP:GetHitBox(myHero), 1, Colors.Blue, 10)
    end
end

function WallJump:GetStartEnd()
    local distance = 1000
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
            local vec = start + Vector(finish.x - start.x, 0, finish.z - start.z):normalized() * (self.range + Prediction.VP:GetHitBox(myHero) / 2)
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
            local best = {champ.Q.IsReady(), champ.W.IsReady(), champ.E.IsReady(), champ.R.IsReady()}
            local dmg, mana = champ:GetComboDamage(target, champ.Q.IsReady(), champ.W.IsReady(), champ.E.IsReady(), champ.R.IsReady())
            bestdmg = dmg
            if dmg > target.health then
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = champ:GetComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d >= target.health and myHero.mana >= m then
                                    if d < bestdmg then 
                                        bestdmg = d 
                                        best = {q[qCount], w[wCount], e[eCount], r[rCount]} 
                                    end
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
                                if d > bestdmg and myHero.mana >= m then 
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

function Cast_Item(item, target)
    if item.IsReady() and ValidTarget(target, item.Range) then
        if item.reqTarget then
            CastSpell(item.Slot(), target)
        else
            CastSpell(item.Slot())
        end
    end
end

function UseItems(unit)
    if ValidTarget(unit) then
        for _, item in pairs(CastableItems) do
            Cast_Item(item, unit)
        end
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

class "_Required"
function _Required:__init()
    self.requirements = {}
    self.downloading = {}
    return self
end

function _Required:Add(t)
    assert(t and type(t) == "table", "_Required: table is invalid!")
    local name = t.Name
    assert(name and type(name) == "string", "_Required: name is invalid!")
    local url = t.Url
    assert(url and type(url) == "string", "_Required: url is invalid!")
    local extension = t.Extension~=nil and t.Extension or "lua"
    local usehttps = t.UseHttps~=nil and t.UseHttps or true
    table.insert(self.requirements, {Name = name, Url = url, Extension = extension, UseHttps = usehttps})
end

function _Required:Check()
    for i, tab in pairs(self.requirements) do
        local name = tab.Name
        local url = tab.Url
        local extension = tab.Extension
        local usehttps = tab.UseHttps
        if not FileExist(LIB_PATH..name.."."..extension) then
            print("Downloading a required library called "..name.. ". Please wait...")
            local d = _Downloader(tab)
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
            local name = tab.Name
            local url = tab.Url
            local extension = tab.Extension
            local usehttps = tab.UseHttps
            if FileExist(LIB_PATH..name.."."..extension) and extension == "lua" then
                require(name)
            end
        end
    end
end

function _Required:CheckDownloads()
    if #self.downloading == 0 then 
        print("Required libraries downloaded. Please reload with 2x F9.")
    else
        for i = 1, #self.downloading, 1 do
            local d = self.downloading[i]
            if d.GotScript then
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
function _Downloader:__init(t)
    local name = t.Name
    local url = t.Url
    local extension = t.Extension~=nil and t.Extension or "lua"
    local usehttps = t.UseHttps~=nil and t.UseHttps or true
    self.SavePath = LIB_PATH..name.."."..extension
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(usehttps and '5' or '6')..'.php?script='..self:Base64Encode(url)..'&rand='..math.random(99999999)
    self:CreateSocket(self.ScriptPath)
    self.DownloadStatus = 'Connect to Server'
    self.GotScript = false
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
    if self.GotScript then return end
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
                    self.CallbackUpdate(self.OnlineVersion, self.LocalVersion)
                end
            end
        end
        self.GotScript = true
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



if SCRIPTSTATUS then
    assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("SFIHILGNMMF") 
end