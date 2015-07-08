local version = 0.23
local scriptname = "iLib"
local VP = nil
local Loaded = false
local AUTOUPDATES = true
Classes = {
    KeyManager = nil,
    ItemManager = nil,
    Utils = nil,
    Damage = nil,
    SpellManager = nil,
    Drawing = nil,
    Orbwalker = nil,
    Minions = nil,
    Prediction = nil,
}

class "iLib"
function iLib:__init()
    Classes.Utils = _Utils()

    self.r = _Required()
    self.r:Add("VPrediction", "raw.githubusercontent.com/Ralphlol/BoLGit/master/VPrediction.lua")
    if VIP_USER then self.r:Add("Prodiction", "bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/master/Test/Prodiction/Prodiction.lua") end
    self.r:Check()
    if self.r:IsDownloading() then return end

    DelayAction(function() self:CheckUpdate() end, 5) 

    VP = VPrediction()

    Classes.KeyManager = _KeyManager()
    Classes.ItemManager = _ItemManager()
    Classes.Damage = _Damage()
    Classes.SpellManager = _SpellManager()
    Classes.Drawing = _Drawing()
    Classes.Orbwalker = _Orbwalker()
    Classes.Minions = _Minions()
    Classes.Prediction = _Prediction()
    Loaded = true
    return self
end

function iLib:CheckUpdate()
    if AUTOUPDATES then
        local scriptName = scriptname
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/jachicao/BoL/master/version/iLib.version"
        ToUpdate.ScriptPath = "/jachicao/BoL/master/iLib.lua"
        ScriptUpdate(scriptname, LIB_PATH.."iLib.lua" , ToUpdate.Version, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath)
    end
end

function iLib:GetClasses()
    return Classes
end

class "_Prediction"
function _Prediction:__init()

end

function _Prediction:GetPrediction(target, delay, width, range, speed, source, skillshotType, collision, aoe)
    if ValidTarget(target) then
        local skillshotType = skillshotType or "linear"
        local aoe = aoe or false
        local collision = collision or false
        local source = source~=nil and source or myHero
        -- VPrediction
        if Classes.SpellManager.Menu.predictionType == 1 then
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
        elseif Classes.SpellManager.Menu.predictionType == 2 then
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
        end
    else
        print("Target doesn't exist.")
    end
end

class "_DrawManager"
function _DrawManager:__init()
    self.objects = {}
end

class "_Orbwalker"
function _Orbwalker:__init()
    --self.isAttacking = false
    self.bufferAA = false 
    --self.nextAA = 0
    self.baseWindUpTime = 3
    self.baseAnimationTime = 0.665
    self.dataUpdated = false
    self.Menu = nil
    self.target = nil
    self.AfterAttackCallbacks = {}
    self.ResetAttackTimer = {}
    self.AA = {LastTime = 0, LastTarget = nil, isAttacking = false}
    --self.Move = {LastTime = 0, LastVector = nil, Delay = 0}
    self.Attacks = { "caitlynheadshotmissile", "frostarrow", "garenslash2", "kennenmegaproc", "lucianpassiveattack", "masteryidoublestrike", "quinnwenhanced", "renektonexecute", "renektonsuperexecute", "rengarnewpassivebuffdash", "trundleq", "xenzhaothrust", "xenzhaothrust2", "xenzhaothrust3"}
    self.noAttacks = {"jarvanivcataclysmattack", "monkeykingdoubleattack", "shyvanadoubleattack", "shyvanadoubleattackdragon", "zyragraspingplantattack", "zyragraspingplantattack2", "zyragraspingplantattackfire", "zyragraspingplantattack2fire"}
    self.AttackResetTable = 
        {
            ["vayne"] = _Q,
            ["darius"] = _W,
            ["fiora"] = _E,
            ["gangplank"] = _Q,
            ["jax"] = _W,
            ["leona"] = _Q,
            ["mordekaiser"] = _Q,
            ["nasus"] = _Q,
            ["nautilus"] = _W,
            ["nidalee"] = _Q,
            ["poppy"] = _Q,
            ["riven"] = _Q,
            ["renekton"] = _W,
            ["rengar"] = _Q,
            ["shyvana"] = _Q,
            ["sivir"] = _W,
            ["talon"] = _Q,
            ["trundle"] = _Q,
            ["vi"] = _E,
            ["volibear"] = _Q,
            ["xinzhao"] = _Q,
            ["monkeyking"] = _Q,
            ["yorick"] = _Q,
            ["cassiopeia"] = _E,
            ["garen"] = _Q,
            ["khazix"] = _Q,
            ["gnar"] = _E
    }


    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, myHero.range + myHero.boundingRadius + 100, DAMAGE_PHYSICAL)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end

function _Orbwalker:OnProcessSpell(unit, spell)
    if unit.isMe then
        if self:IsAutoAttack(spell.name:lower()) then
            if not self.dataUpdated then
                self.baseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
                self.baseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
                self.dataUpdated = true
            end
            self.AA.isAttacking = true
            self.AA.LastTime = os.clock() - self:Latency()
            self.AA.LastTarget = spell.target
            DelayAction(
                function() 
                    self:TriggerAfterAttackCallback(spell)
                    self.AA.isAttacking = false 
                end
            , self:WindUpTime() - self:Latency() * 2)
        elseif self:IsResetSpell(spell.name) or spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            DelayAction(function()
                self:ResetAA()
                self:TriggerResetAttackTimer(spell)
                end, spell.windUpTime - self:Latency() * 2)

            if _G.AutoCarry then
                _G.AutoCarry.Orbwalker:ResetAttackTimer()
            end
        end
    end
end

function _Orbwalker:LoadMenu(m)
    if m then self.Menu = m
    else self.Menu = scriptConfig("Orbwalker", scriptname.." Orbwalker"..version)
    end
    if self.Menu ~= nil then
        self.mode = nil
        self.Menu:addSubMenu("General Settings", "General")
            self.Menu.General:addParam("Move", "Enable Move", SCRIPT_PARAM_ONOFF, true)
            self.Menu.General:addParam("Attack", "Enable Attack", SCRIPT_PARAM_ONOFF, true)
            self.Menu.General:addParam("HoldRadius", "Hold position radius", SCRIPT_PARAM_SLICE, 80, 60, 250)
            self.Menu.General:addParam("Stick", "Stick to Target", SCRIPT_PARAM_ONOFF, false)
            self.Menu.General:addParam("StickRange", "Stick to Target Range", SCRIPT_PARAM_SLICE, 250, 0, 500)
            self.Menu.General:permaShow("Stick")
        self.Menu:addSubMenu("Key Settings", "Keys")
            self.Menu.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
            self.Menu.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
            self.Menu.Keys:addParam("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
            self.Menu.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        self.Menu:addSubMenu("Farm Settings", "Farm")
            self.Menu.Farm:addParam("FarmDelay", "Delay on Farm", SCRIPT_PARAM_SLICE, 0, -20, 20)
            self.Menu.Farm:addParam("Priorize","Priorize Farm over Harass", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Farm:addParam("OffsetRange", "Offset Range to Analize Minions", SCRIPT_PARAM_SLICE, 150, 0, 500)
            self.Menu.Farm:permaShow("FarmDelay")
        self.Menu:addSubMenu("Misc Settings", "Misc")
            self.Menu.Misc:addParam("ExtraWindUp","Extra WindUpTime", SCRIPT_PARAM_SLICE, 80, -40, 400)
        self.Menu:addSubMenu("Draw Settings", "Draw")
            self.Menu.Draw:addParam("myAARange","My AA Range", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("enemyAARange","Enemy AA Range", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("HoldRadius","Hold position radius", SCRIPT_PARAM_ONOFF, false)
            self.Menu.Draw:addParam("Minions","Circle on Target Minion", SCRIPT_PARAM_ONOFF, true)

        Classes.KeyManager:RegisterKey(self.Menu.Keys,  "Combo"      , "Combo")
        Classes.KeyManager:RegisterKey(self.Menu.Keys,  "Harass"     , "Harass")
        Classes.KeyManager:RegisterKey(self.Menu.Keys,  "Clear"      , "Clear")
        Classes.KeyManager:RegisterKey(self.Menu.Keys,  "LastHit"    , "LastHit")

        self.Menu:addTS(self.ts)

        AddTickCallback(function() self:OnTick() end)
        AddDrawCallback(function() self:OnDraw() end)
    end
end


function _Orbwalker:OnTick()
    self.mode = Classes.KeyManager:ModePressed()
    self.ts:update()
    if self.mode ~= nil then
        Classes.Minions:Update()
        if self.mode == "combo" then
            self.target = self.ts.target
        elseif self.mode == "harass" then
            self.target = Classes.Minions:Harass()
        elseif self.mode == "clear" then
            self.target = Classes.Minions:Clear()
        elseif self.mode == "lasthit" then
            self.target = Classes.Minions:LastHit()
        end
    end
    if self.mode ~= nil then
        self:Orbwalk(self.target)
    end
end

function _Orbwalker:OnDraw()
    if self.Menu.Draw.HoldRadius then
        Classes.Drawing:Circle(myHero.x, myHero.y, myHero.z, self.Menu.General.HoldRadius, Classes.Utils.Colors.Blue, 1)
    end
    if self.Menu.Draw.myAARange then
        local target = self.ts.target or self.target
        Classes.Drawing:Circle(myHero.x, myHero.y, myHero.z, self:MyRange(target), Classes.Utils.Colors.White, 1)
    end

    if self.Menu.Draw.enemyAARange then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
            if ValidTarget(enemy) and OnScreen(p.x, p.y) then
                Classes.Drawing:Circle(enemy.x, enemy.y, enemy.z, self:GetAARange(enemy), Classes.Utils.Colors.White, 1)
            end
        end
    end
end

function _Orbwalker:IsAutoAttack(name)
    local name = name:lower()
    return (name:find("attack") and self.Attacks[name] == nil) or self.Attacks[name]~=nil
end

function _Orbwalker:GetAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius / 2 or 0
end

function _Orbwalker:SetMovement(var)
    if self.Menu~=nil then
        self.Menu.General.Move = var
    end
end

function _Orbwalker:SetAttack(var)
    if self.Menu~=nil then
        self.Menu.General.Attack = var
    end
end

function _Orbwalker:Latency()
    return GetLatency() / 2000
end

function _Orbwalker:ExtraWindUp()
    return self.Menu ~= nil and self.Menu.Misc.ExtraWindUp / 1000 or 90/1000
end

function _Orbwalker:WindUpTime()
    return (1 / (myHero.attackSpeed * self.baseWindUpTime)) + self:ExtraWindUp()
end

function _Orbwalker:AnimationTime()
    return 1 / (myHero.attackSpeed * self.baseAnimationTime)
end

function _Orbwalker:CanAttack()
    if os.clock() >= self.AA.LastTime then
        return os.clock() - self.AA.LastTime >= self:AnimationTime() - self:Latency() and (self.Menu~=nil and self.Menu.General.Attack or true)
    end
    return false
end

function _Orbwalker:CanMove()
    if os.clock() >= self.AA.LastTime then
        return os.clock() - self.AA.LastTime >= self:WindUpTime() - self.Latency() and (self.Menu~=nil and self.Menu.General.Move or true) and not self.bufferAA and not self.AA.isAttacking and not _G.evade
    end
   return false
end

function _Orbwalker:ResetAA()
    self.AA.isAttacking = false
    self.AA.LastTime = 0
    --self.nextAA = 0
end

function _Orbwalker:CanCast()
    if self.Menu~=nil and self.Menu.PriorizeFarm and self.mode~=nil and self.mode == "harass" then
        local minion = Classes.Minions:GetKillable()
        if minion ~= nil then
            if ValidTarget(minion, self:MyRange(minion)) then 
                return false
            else 
                return true
            end
        end
    end
    return self:CanMove()
    --return self:CanMove()
end

function _Orbwalker:Orbwalk(target)
    if self:InRange(target) and self:CanAttack() then
        myHero:Attack(target)
        --if self.AA.LastTarget~=nil and ValidTarget(self.AA.LastTarget) and GetDistanceSqr(self.AA.LastTarget, target) > 50 * 50 then
            --self.AA.LastTime = os.clock() + self:Latency()
        --end
        --self.AA.LastTarget = target
        self.bufferAA = true
        DelayAction(function()
            self.bufferAA = false
        end, self:Latency() * 2)
        return
    elseif self:CanMove() then
        if ValidTarget(target, self.Menu.General.StickRange) and self.Menu.General.Stick and Classes.Orbwalker.mode~=nil and Classes.Orbwalker.mode:lower():find("combo") then
            myHero:MoveTo(target.x, target.z)
        elseif GetDistanceSqr(myHero, mousePos) > self.Menu.General.HoldRadius * self.Menu.General.HoldRadius then
            myHero:MoveTo(mousePos.x, mousePos.z)
        else
            myHero:HoldPosition()
        end
    end
end

function _Orbwalker:MyRange(target)
    local int1 = 50
    if ValidTarget(target) then 
        int1 = GetDistance(target.minBBox, target)/2 
    end
    return myHero.range + GetDistance(myHero, myHero.minBBox) + int1
end

function _Orbwalker:InRange(target)
    return ValidTarget(target) and ValidTarget(target, self:MyRange(target))
end

function _Orbwalker:IsResetSpell(SpellName)
    local SpellID
    if SpellName:lower() == myHero:GetSpellData(_Q).name:lower() then
        SpellID = _Q
    elseif SpellName:lower() == myHero:GetSpellData(_W).name:lower() then
        SpellID = _W
    elseif SpellName:lower() == myHero:GetSpellData(_E).name:lower() then
        SpellID = _E
    elseif SpellName:lower() == myHero:GetSpellData(_R).name:lower() then
        SpellID = _R
    end

    if SpellID then
        return self.AttackResetTable[myHero.charName:lower()] == SpellID 
    end
    return false
end

function _Orbwalker:GetTarget()
    return self.target --
end

--callbacks
function _Orbwalker:RegisterResetAttackTimer(func)
    table.insert(self.ResetAttackTimer, func)
end

function _Orbwalker:TriggerResetAttackTimer(spell)
    for i, func in ipairs(self.ResetAttackTimer) do
        func(spell)
    end
end


function _Orbwalker:RegisterAfterAttackCallback(func)
    table.insert(self.AfterAttackCallbacks, func)
end

function _Orbwalker:TriggerAfterAttackCallback(spell)
    for i, func in ipairs(self.AfterAttackCallbacks) do
        func(spell)
    end
end


class "_Minions"
function _Minions:__init()
    --self.AllyMinions = minionManager(MINION_ALLY, 1000, myHero, MINION_SORT_HEALTH_ASC)
    self.EnemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC)
    --self.OtherMinions = minionManager(MINION_OTHER, 1000, myHero, MINION_SORT_HEALTH_ASC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
    self.Killable = nil
    self.almostKillable = nil
    self.meanwhile = nil
    self.jungleMinion = nil
    self.predHealthLimit = -40
    self.delay = 0.07
    self.lastWait = 0
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
    AddDrawCallback(function() self:OnDraw() end)
    --AddTickCallback(function() self:OnTick() end)
    --AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end

function _Minions:OnDraw()
    if Classes.Orbwalker.Menu~=nil then
        if Classes.Orbwalker.Menu.Draw.Minions and Classes.Orbwalker.mode ~= nil then
            self:Update()
            local obj = self:Meanwhile(Classes.Orbwalker.Menu.Farm.OffsetRange)
            if ValidTarget(obj) and Classes.Orbwalker.mode:lower():find("clear") then
                Classes.Drawing:Circle(obj.x, obj.y, obj.z, VP:GetHitBox(obj), Classes.Utils.Colors.Green, 1, 0)
            end
            local obj = self:Wait(Classes.Orbwalker.Menu.Farm.OffsetRange)
            if ValidTarget(obj) then
                Classes.Drawing:Circle(obj.x, obj.y, obj.z, VP:GetHitBox(obj), Classes.Utils.Colors.Yellow, 2, 0)
            end
            local obj = self:GetKillable(Classes.Orbwalker.Menu.Farm.OffsetRange)
            if ValidTarget(obj) then
                Classes.Drawing:Circle(obj.x, obj.y, obj.z, VP:GetHitBox(obj), Classes.Utils.Colors.Red, 3, 0)
            end
            
        end
    end
end

function _Minions:OnTick()
    if Classes.Orbwalker.mode ~= nil then
        --if Classes.KeyManager:ModePressed:lower():find("harass") or Classes.KeyManager:ModePressed:lower():find("clear") or Classes.KeyManager:ModePressed:lower():find("lasthit") then
            --self:Update()
        --end
    end
end

function _Minions:OnProcessSpell(unit, spell)
    
end

function _Minions:Update()
    --self.AllyMinions:update()
    self.EnemyMinions:update()
    --self.OtherMinions:update()
    self.JungleMinions:update()
    self.Killable = self:GetKillable()
    self.almostKillable = self:Wait()
    self.meanwhile = self:Meanwhile()
    self.jungleMinion = self:JungleClear()
end

function _Minions:Clear()

    if ValidTarget(self.Killable, Classes.Orbwalker:MyRange(self.Killable)) then
        return self.Killable
    end

    if ValidTarget(self.almostKillable, Classes.Orbwalker:MyRange(self.almostKillable)) then
        return nil
    end
    if ValidTarget(self.meanwhile, Classes.Orbwalker:MyRange(self.meanwhile)) then
        return self.meanwhile
    end

    if ValidTarget(self.jungleMinion, Classes.Orbwalker:MyRange(self.jungleMinion)) then
        return self.jungleMinion
    end

    
end

function _Minions:LastHit()
    if ValidTarget(self.Killable, Classes.Orbwalker:MyRange(self.Killable)) then
        return self.Killable
    end
end


function _Minions:Harass()
    local offsetRange = 100
    if not Classes.Orbwalker.Menu.Farm.Priorize and ValidTarget(Classes.Orbwalker.ts.target, Classes.Orbwalker:MyRange(Orbwalker.ts.target) + offsetRange) then
        return Classes.Orbwalker.ts.target
    end

    if ValidTarget(self.Killable, Classes.Orbwalker:MyRange(self.Killable)) then
        return self.Killable
    end

    if ValidTarget(self.almostKillable, Classes.Orbwalker:MyRange(self.almostKillable)) then
        return nil
    end
    if ValidTarget(Classes.Orbwalker.ts.target, Classes.Orbwalker:MyRange(Classes.Orbwalker.ts.target) + offsetRange) then
        return Classes.Orbwalker.ts.target
    end
end

function _Minions:GetKillable(offs)
    local offset = offs ~= nil and offs or 0
    local cannonMinions = {}
    if #self.EnemyMinions.objects then
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ValidTarget(minion, Classes.Orbwalker:MyRange(minion) + offset) and not minion.dead and minion.charName:lower():find("cannon") then
                if self:Damage(minion) > self:GetPredictedHealth(minion, 2) then
                    table.insert(cannonMinions, minion)
                end
            end
        end
    end
    if #cannonMinions > 0 then
        for i, minion in pairs(cannonMinions) do
            if ValidTarget(minion, Classes.Orbwalker:MyRange(minion) + offset) and not minion.dead then
                local predHealth = self:GetPredictedHealth(minion, 1)
                if self:Damage(minion) > predHealth and predHealth > self.predHealthLimit then
                    return minion
                end
            end
        end
    else
        for i, minion in pairs(self.EnemyMinions.objects) do
            if ValidTarget(minion, Classes.Orbwalker:MyRange(minion) + offset) and not minion.dead then
                local predHealth = self:GetPredictedHealth(minion, 1)
                if self:Damage(minion) > predHealth and predHealth > self.predHealthLimit then
                    return minion
                end
            end
        end
    end
    return nil
end


function _Minions:Wait(offs)
    local offset = offs ~= nil and offs or 0
    for i, minion in pairs(self.EnemyMinions.objects) do
        if ValidTarget(minion, Classes.Orbwalker:MyRange(minion) + offset) then
            if self:Damage(minion) > self:GetPredictedHealth(minion, 2) then
                self.lastWait = os.clock()
                return minion
            end
        end
    end
    return nil
end

function _Minions:Meanwhile(offs)
    local offset = offs ~= nil and offs or 0
    for i, minion in pairs(self.EnemyMinions.objects) do
        if ValidTarget(minion, Classes.Orbwalker:MyRange(minion) + offset) then
            if ValidTarget(minion, Classes.Orbwalker:MyRange(minion)) then
                local predHealth1 = self:GetPredictedHealth(minion, 1)
                local predHealth2 = self:GetPredictedHealth(minion, 2)
                if predHealth2 > 2 * self:Damage(minion) or minion.health == predHealth1 then
                    return minion
                end
            end
        end
    end
end

function _Minions:JungleClear(offs)
    local offset = offs ~= nil and offs or 0
    if #self.JungleMinions.objects then
        for i, minion in pairs(self.JungleMinions.objects) do
            if ValidTarget(minion, Classes.Orbwalker:MyRange(minion) + offset) then
                return minion
            end
        end
    end
    return nil
end

function _Minions:Damage(minion)
    return VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0)
end

function _Minions:GetTimeMinion(minion, mode)
    local time = 0
    --lasthit
    if mode == 1 then
        --time = Classes.Orbwalker:WindUpTime() - Classes.Orbwalker:ExtraWindUp() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - self.delay
        time = Classes.Orbwalker:WindUpTime() - Classes.Orbwalker:ExtraWindUp() + Classes.Orbwalker:Latency() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - 100/1000
    --laneclear
    elseif mode == 2 then
        time = Classes.Orbwalker:AnimationTime() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - self.delay
        --time = Classes.Orbwalker:AnimationTime()
        time = time * 2
    end
    return math.max(time, 0)
end

function _Minions:GetPredictedHealth(minion, mode, t)
    local health = minion.health
    local time = t ~=nil and t or self:GetTimeMinion(minion, mode)
    if mode == 1 then
        local predHealth, maxdamage, count = VP:GetPredictedHealth(minion, time, self:GetFarmDelay())
        health = predHealth
    elseif mode == 2 then
        local predHealth, maxdamage, count = VP:GetPredictedHealth2(minion, time)
        health = predHealth
    end
    return health
    -- body
end

function _Minions:GetFarmDelay()
    local Extra = 0--self.ProjectileSpeed  == math.huge and 10/100 or 0
    return Classes.Orbwalker.Menu.Farm.FarmDelay / 100 + Extra
end

function _Minions:BestLine(range, width, objects)
    return Classes.Utils:GetBestLine(range, width, objects)
end

function _Minions:BestCircular(range, width, objects)
    return Classes.Utils:GetBestCircular(range, width, objects)
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
    if self.Combo then return "combo"
    elseif self.Harass then return "harass"
    elseif self.Clear then return "clear" 
    elseif self.LastHit then return "lasthit"
    else return nil end
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
    if mode:lower()     == "combo" then
        table.insert(self.ComboKeys, {menu, param})
    elseif mode:lower() == "harass" then
        table.insert(self.HarassKeys, {menu, param})
    elseif mode:lower() == "clear" then
        table.insert(self.ClearKeys, {menu, param})
    elseif mode:lower() == "lasthit" then
        table.insert(self.LastHitKeys, {menu, param})
    end
end


class "_SpellManager"
function _SpellManager:__init()
    self.Menu = nil
    self.spells = {}
end

function _SpellManager:AddSpell(spell)
    table.insert(self.spells, spell)
end

function _SpellManager:LoadDraw(m)
    if m~=nil then
        if #self.spells > 0 then
            for i = 1, #self.spells do
                local spell = self.spells[i]
                spell:LoadDraw(m)
            end
        end
    end
end

function _SpellManager:LoadMenu(m)
    self.Menu = m
    if self.Menu == nil then self.Menu = scriptConfig("Spell Manager", "SpellManager"..version) end
    if VIP_USER then self.Menu:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, { "vPrediction", "Prodiction"})
    else self.Menu:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, { "vPrediction"}) end
    if #self.spells > 0 then
        for i = 1, #self.spells do
            local spell = self.spells[i]
            spell:LoadMenu(self.Menu)
        end
    end
end

function _SpellManager:GetPredictionType()
    if self.Menu~=nil then return self.Menu.predictionType else return 1 end
end

class "Spell"
function Spell:__init(id, name, range)
    self.id = id
    self.name = name
    self.range = range
    self.sourcePosition = myHero
    self.lastCastTime = 0
    self.skillshotType = nil
    self.Menu = nil
    self.Drawing= nil
end

function Spell:SetSkillShot(speed, delay, width, collision, skillshotType, aoe)
    self.skillshotType = skillshotType
    self.delay = delay or 0
    self.width = width or 0
    self.speed = speed or 0
    self.collision = collision
    self.hitchance = 2
    self.aoe = aoe or false
    self.isChargeSpell = false
end

function Spell:Track(spellName)
    AddProcessSpellCallback(
    function(unit, spell)
        if unit.valid then
            if unit.isMe then
                if spellName:lower() == spell.name:lower() then
                    self.lastCastTime = os.clock()
                end
            end
        end
    end)
end

function Spell:GetLastCastTime()
    return self.lastCastTime
end

function Spell:LoadDraw(m)
    if m~=nil and self.name~=nil then
        local menu =  self.name.."Menu"
        m:addSubMenu("Draw", menu)
        m[menu]:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
        m[menu]:addParam("Color", "Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
        m[menu]:addParam("Width", "Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
        m[menu]:addParam("Quality", "Quality", SCRIPT_PARAM_SLICE, 100, 0, 100)
        self.Drawing = m[menu]
        AddDrawCallback(function() self:OnDraw() end)
    end
end

function Spell:LoadMenu(m)
    m:addSubMenu(self.name.." Settings", self.name.."Menu")
    self.Menu = m[self.name.."Menu"]
    if self.Menu~=nil then
        self:LoadDraw(self.Menu)
        if not self.isChargeSpell then
            local range = self.range
            local max = range * 1.1
            local min = range * 0.5
            local actual = range
            self.Menu:addParam("Range","Range", SCRIPT_PARAM_SLICE, actual, min, max)
        else
            local range = self.minRange
            local max = range * 1.1
            local min = range * 0.5
            local actual = range
            self.Menu:addParam("MinRange","Min Range", SCRIPT_PARAM_SLICE, actual, min, max)
            local range = self.maxRange
            local max = range * 1.1
            local min = range * 0.5
            local actual = range
            self.Menu:addParam("MaxRange","Max Range", SCRIPT_PARAM_SLICE, actual, min, max)
        end
        if self.skillshotType~=nil then
            local range = self.width
            local max = range * 1.1
            local min = range * 0.5
            local actual = range
            self.Menu:addParam("Width","Width", SCRIPT_PARAM_SLICE, actual, min, max)
            self.Menu:addParam("HitChance", "HitChance", SCRIPT_PARAM_SLICE, 2, 0, 5)
        end
        AddTickCallback(
        function()
            if not self.isChargeSpell then
                self.range = self.Menu.Range
            else
                self.minRange = self.Menu.MinRange
                self.maxRange = self.Menu.MaxRange
            end
            if self.skillshotType~=nil then
                self.width = self.Menu.Width
                self.hitchance = self.Menu.HitChance
            end
        end)
    end
end

function Spell:OnDraw()
    if self.Drawing~=nil and self.name~=nil then
        if self.Drawing.Enable and self:IsReady() then
            Classes.Drawing:Circle(self.sourcePosition.x, self.sourcePosition.y, self.sourcePosition.z, self.range, ARGB(self.Drawing.Color[1], self.Drawing.Color[2], self.Drawing.Color[3], self.Drawing.Color[4]), self.Drawing.Width, self.Drawing.Quality)
        end
    end
end

function Spell:SetHitChance(hitChance)
    self.hitChance = hitChance or 2
end

function Spell:SetSource(vec)
    self.sourcePosition = vec
end

function Spell:IsReady()
    return myHero:CanUseSpell(self.id) == READY
end

function Spell:Mana()
    return myHero:GetSpellData(self.id).mana
end

function Spell:Cooldown()
    return myHero:GetSpellData(self.id).currentCd
end

function Spell:Level()
    return myHero:GetSpellData(self.id).level
end

function Spell:Name()
    return myHero:GetSpellData(self.id).name
end

function Spell:Cast(target)
    if self:IsReady() then
        if target~= nil and ValidTarget(target, self.range) then
            if self.skillshotType ~= nil then
                if not self.isChargeSpell then
                    local CastPosition, HitChance, Something = self:GetPrediction(target)
                    if HitChance >= self.hitchance then
                        CastSpell(self.id, CastPosition.x, CastPosition.z)
                    end
                elseif not self.isCharging then
                    self:StartCharging(target)
                elseif self.isCharging then
                    self:FinishCharging(target)
                end
            else
                CastSpell(self.id, target)
            end
        else
            CastSpell(self.id)
        end
    end
end

function Spell:GetPrediction(target, sourcePosition)
    if self.skillshotType ~= nil and ValidTarget(target) then
        local source = sourcePosition~=nil and sourcePosition or self.sourcePosition
        return Classes.Prediction:GetPrediction(target, self.delay, self.width, self.range, self.speed, source, self.skillshotType, self.collision, self.aoe)
    end
end


--CHARGED SPELLS
function Spell:Charged(chargeSpellName, abortSpellName, minRange, maxRange, delta, duration, packet)
    self.chargeSpellName = chargeSpellName
    self.abortSpellName = abortSpellName
    self.minRange = minRange
    self.maxRange = maxRange
    self.delta = delta
    self.duration = duration
    self.isCharging = false
    self.packet = packet
    self.packetSent = false
    self.isChargeSpell = true
    AddTickCallback(
    function() 
        if self.isCharging then
            self.range = math.min((self.maxRange - self.minRange) / self.delta * (os.clock() - self.lastCastTime), self.maxRange - self.minRange) + self.minRange
        else
            if VIP_USER then self.range = self.maxRange else self.range = self.minRange end
        end
    end)
    AddProcessSpellCallback(
    function(unit, spell)
        if unit.valid then
            if unit.isMe then
                if chargeSpellName:lower() == spell.name:lower() then
                    self.lastCastTime = os.clock()
                    self:SetCharge()
                    DelayAction(function() self:AbortCharge() end, self.duration)
                elseif abortSpellName:lower() == spell.name:lower() then
                    self:AbortCharge()
                elseif spell.name:lower():find("basicattack") then
                    self:AbortCharge()
                end
            end
        end
    end)

    if self.packet~=nil and VIP_USER then
        HookPackets()
        AddSendPacketCallback(
        function(p)
            if p.header == self.packet and os.clock() - self.lastCastTime < 0.5 then
                p.pos = 2
                if myHero.networkID == p:DecodeF() and not self.packetSent then
                  --p.pos = 2
                  Packet(p):block()
                end
            end
        end)
    end
end

function Spell:IsCharging()
    return self.isCharging
end

function Spell:StartCharging(target)
    self:Cast(target)
end

function Spell:FinishCharging(target)
    if self:IsReady() then
        if target~= nil and ValidTarget(target, self.range) then
            if self.skillshotType ~= nil then
                local CastPosition, HitChance, Something = self:GetPrediction(target)
                if HitChance >= self.hitchance then
                    local d3vector = D3DXVECTOR3(CastPosition.x, CastPosition.y, CastPosition.z)
                    self.packetSent = true
                    CastSpell2(self.id, d3vector)
                    self.packetSent = false
                end
            end
        end
    end
end

function Spell:SetCharge()
    self.isCharging = true
end

function Spell:AbortCharge()
    self.isCharging = false
end

class "_Drawing"
function _Drawing:__init()
    -- body
end

function _Drawing:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
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

function _Drawing:round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function _Drawing:Circle(x, y, z, radius, color, width, quality)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    local quality = quality  ~= nil and quality or 100
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        self:DrawCircleNextLvl(x, y, z, radius, width, color, 75 + 2000 * (100 - quality)/100) 
    end
end


function _Drawing:GetHPBarPos(enemy)
    enemy.barData = {PercentageOffset = {x = 0, y = 0}}
    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 19
    local CorrectionY = 26
    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY
    local StartPos = Vector(barPos.x , barPos.y, 0)
    local EndPos = Vector(barPos.x + 104 , barPos.y , 0)    
    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function _Drawing:FillHPBar(damage, text, unit)
    if unit.dead or not unit.visible then return end
    local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
    if not OnScreen(p.x, p.y) then return end
    self:DrawLineHPBar(damage, text, unit, true)
    --[[local StartPos, EndPos = self:GetHPBarPos(unit)
    local damagePercentage = math.max(unit.health - damage, 0) / unit.maxHealth;
    local currentHealthPercentage = unit.health / unit.maxHealth;
    local BarOffset = {x = 0, y = 0}
    local BAR_WIDTH = 104
    local LINE_THICKNESS = 10
    local FinalStart = Vector(StartPos.x + BAR_WIDTH * math.max(unit.health - damage, 0) / unit.maxHealth, StartPos.y, 0)
    local FinalEnd = Vector(StartPos.x + BAR_WIDTH * unit.health / unit.maxHealth, StartPos.y, 0)
    --DrawLine(startPoint.x, startPoint.y, endPoint.x, endPoint.y, LINE_THICKNESS, ARGB(255, 255, 255, 255))
    local FinalText = Vector(StartPos.x, StartPos.y - 20, 0)
    DrawLine(FinalStart.x, FinalStart.y, FinalEnd.x, FinalEnd.y, LINE_THICKNESS, ARGB(100, 255, 255, 0))
    DrawText(tostring(math.round(damage)).." "..tostring(text), 15, FinalText.x, FinalText.y , ARGB(100, 255, 255, 0))
    ]]
    
end

function _Drawing:GetHPBarPos2(enemy)
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

function _Drawing:DrawLineHPBar(damage, text, unit, enemyteam)
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
    
    local StartPos, EndPos = self:GetHPBarPos2(unit)
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



class "_Damage"
function _Damage:__init()
    -- body
end

class "_ItemManager"
function _ItemManager:__init()
    self.items = {}
    self:AddKnownItems()
end

function _ItemManager:AddKnownItems()
    self:AddItem(3077, 400, false, "TIAMAT")
    self:AddItem(3074, 400, false, "HYDRA")
    self:AddItem(3153, 450, true, "RUINEDKING")
    self:AddItem(3144, 400, true, "BWC")
    self:AddItem(3146, 400, true, "HXG")
    self:AddItem(3188, 750, true, "BLACKFIRE")
    self:AddItem(3142, 350, false)
    self:AddItem(3143, 500, false)
    self:AddItem(3023, 1000, false)
end

function _ItemManager:AddItem(id, range, reqTarget, dmgName)
    local item = Item(id, range, reqTarget, dmgName)
    local add = true
    if #self.items > 0 then
        for i = 1, #self.items do
            if item.id == self.items[i].id then add = false end
        end
    end

    if add then
        table.insert(self.items, item)
    end
end

function _ItemManager:RemoveItem(id)
    if #self.items > 0 then
        for i = 1, #self.items do
            local item = self.items[i]
            if item.id == id then 
                table.remove(self.items, i)
                break
            end
        end
    end
end

function _ItemManager:CastAll(target)
    if #self.items > 0 then
        for i = 1, #self.items do
            local item = self.items[i]
            if item:IsReady() then
                item:Cast(target)
            end
        end
    end
end

function _ItemManager:GetDamage(target)
    local damage = 0
    if #self.items > 0 then
        for i = 1, #self.items do
            local item = self.items[i]
            if item:IsReady() then
                damage = damage + item:GetDamage(target)
            end
        end
    end
    return damage
end

function _ItemManager:CastItem(id, target)
    if #self.items > 0 then
        for i = 1, #self.items do
            local item = self.items[i]
            if item:IsReady() and item:GetId() == id then
                item:Cast(target)
            end
        end
    end
end

class "Item"
function Item:__init(id, range, reqTarget, dmgName)
    assert(id and type(id) == "number", "_Item: id is invalid!")
    assert(not range or range and type(range) == "number", "_Item: range is invalid!")
    self.id = id
    self.range = range
    self.reqTarget = reqTarget or false
    self.dmgName = dmgName or nil
end

function Item:GetRange()
    return self.range
end

function Item:GetDamage(target)
    if self.dmgName ~= nil and ValidTarget(target) then
        return getDmg(dmgName, target, myHero)
    end
    return 0
end

function Item:GetId()
    return self.id
end

function Item:InRange(target)
    return ValidTarget(target, self.range)
end

function Item:GetSlot()
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
        if myHero:GetSpellData(slot).name:lower() == ItemNames[self.id]:lower() then
            return slot
        end
    end
    return nil
end

function Item:IsReady()
    local slot = self:GetSlot()
    return slot ~= nil and myHero:CanUseSpell(slot) == READY
end

function Item:Cast(target)
    if self:InRange(target) and self:IsReady() then
        if self.reqTarget and target ~= nil then
            CastSpell(self:GetSlot(), target)
        else
            CastSpell(self:GetSlot())
        end
    end
end



class "_Utils"
function _Utils:__init()
    self.Colors = { 
        -- O R G B
        Green =  ARGB(255, 0, 255, 0), 
        Yellow =  ARGB(255, 255, 255, 0),
        Red =  ARGB(255,255,0,0),
        White =  ARGB(255, 255, 255, 255),
        Blue =  ARGB(255,0,0,255),
    }
end

function Print(message)
    print("<font color=\"#6699ff\"><b>" .. scriptname .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") 
end

function _Utils:CountObjectsOnCircle(pos, range, width, objects)

    local n = 0
    for i, object in ipairs(objects) do
        if GetDistanceSqr(pos, object) <= width * width then
            n = n + 1
        end
    end
    return n

end

function _Utils:GetBestCircular(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        if GetDistanceSqr(myHero, object) <= range * range then
            local hit = self:CountObjectsOnCircle(object.visionPos or object, range, width, objects)
            if hit > BestHit then
                BestHit = hit
                BestPos = Vector(object)
                if BestHit == #objects then
                   break
                end
            end
        end
    end

    return BestPos, BestHit

end

function _Utils:CountObjectsOnLineSegment(startPos, endPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(startPos, endPos, object)
        if isOnSegment and GetDistanceSqr(pointSegment, object) <= width * width then
            n = n + 1
        end
    end

    return n
end

function _Utils:GetBestLine(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local endPos = Vector(myHero.visionPos) + range * (Vector(object) - Vector(myHero.visionPos)):normalized()
        local hit = self:CountObjectsOnLineSegment(myHero.visionPos, endPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function _Utils:GetEnemyHPBarPos(enemy)

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y}
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y}

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Vector(barPos.x, barPos.y, 0)
    local EndPos = Vector(barPos.x + 103, barPos.y, 0)

    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function _Utils:IsUntargetable(target)
    if not ValidTarget(target) then return false end
    if TargetHaveBuff("JudicatorIntervention", target) then return true
    elseif TargetHaveBuff("UndyingRage", target) then return true
    elseif TargetHaveBuff("ZacRebirthReady", target) then return true
    elseif TargetHaveBuff("aatroxpassivedeath", target) then return true
    elseif TargetHaveBuff("FerociousHowl", target) then return true
    elseif TargetHaveBuff("VladimirSanguinePool", target) then return true
    elseif TargetHaveBuff("chronorevive", target)then return true
    elseif TargetHaveBuff("chronoshift", target)then return true
    elseif TargetHaveBuff("elisespidere", target)then return true
    elseif TargetHaveBuff("KarthusDeathDefiedBuff", target)then return true
    elseif TargetHaveBuff("kogmawicathiansurprise", target)then return true
    elseif TargetHaveBuff("sionpassivezombie", target)then return true
    elseif TargetHaveBuff("zhonyasringshield", target)then return true
    elseif TargetHaveBuff("zyrapqueenofthorns", target)then return true
    else return false end
end

function _Utils:IsValidTarget(target)
    return ValidTarget(target) and not IsUntargetable(target)
end

class "_PredictionHealth"
function _PredictionHealth:__init()
    self.ActiveAttacks = {}
    self.lastCheck = 0
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    AddTickCallback(function() self:OnTick() end)
end

function _PredictionHealth:OnTick()
    if os.clock() - self.lastCheck < 60 then return end
    --[[
    for i = 1, #self.ActiveAttacks, 1 do
        local attack = self.ActiveAttacks[i]
        if attack.startTime + 60 < os.clock() then
            self.ActiveAttacks[id] = nil
            self.lastCheck = os.clock()
        end
    end
]]
end
--[[
function _PredictionHealth:OnProcessSpell(unit, spell)
    if unit and unit.valid and unit.team == myHero.team and spell and spell.name and Classes.Orbwalker:IsAutoAttack(spell.name:lower()) and spell.target.type:lower():find("minion") and GetDistanceSqr(unit, spell.target) < 2000 * 2000 and ( unit.type:lower():find("minion") or unit.type:lower():find("turret") ) then
        local time = os.clock() + spell.windUpTime + GetDistance(spell.target, unit) / VP:GetProjectileSpeed(unit) - GetLatency()/2000
        local i = 1
        while i <= #self.ActiveAttacks do
            if (self.ActiveAttacks[i].source and self.ActiveAttacks[i].source.valid and self.ActiveAttacks[i].source.networkID == unit.networkID) or ((time + 3) < os.clock()) then
                table.remove(self.ActiveAttacks, i)
            else
                i = i + 1
            end
        end
        local windUp = spell.windUpTime - (unit.name:lower():find("turret") and 70/1000 or 0)
        local speed = VP:GetProjectileSpeed(unit)
        table.insert(self.ActiveAttacks,  {source = unit, pos = Vector(unit), target = spell.target, animationTime = spell.animationTime, damage = VP:CalcDamageOfAttack(unit, spell.target, spell, 0), startTime = os.clock() - GetLatency()/2000, windUpTime = WindUp, projectilespeed = speed})
    end   
end
]]
function _PredictionHealth:GetLastHitHealth(minion, time, delay)
    local totaldmg = 0
    for i = 1, #self.ActiveAttacks, 1 do
        local attack = self.ActiveAttacks[i]
        if attack.source and attack.source.valid and attack.target and attack.target.valid and attack.target.networkID == minion.networkID and not attack.target.dead and not attack.source.dead then
            local endTime = attack.startTime + attack.windUpTime + GetDistance(attack.source, attack.target) / attack.projectilespeed
            if endTime - os.clock() > 0 and endTime - os.clock() < time - delay then
                totaldmg = totaldmg + attack.damage
            end
        end
    end
    return minion.health - totaldmg
end

function _PredictionHealth:GetLaneClearHealth(minion, time, delay)
    local totaldmg = 0
    for i = 1, #self.ActiveAttacks, 1 do
        local attack = self.ActiveAttacks[i]
        local n = 0
        if os.clock() - 100/1000 <= attack.startTime + attack.animationTime and attack.source and attack.source.valid and attack.target and attack.target.valid and attack.target.networkID == minion.networkID and not attack.target.dead and not attack.source.dead then
            local from = attack.startTime
            local to = os.clock() + time
            while from < to do
                local endTime = from + attack.windUpTime + GetDistance(attack.source, attack.target) / attack.projectilespeed
                if from >= os.clock() and endTime < to then
                    n = n + 1
                end
               from = from + attack.animationTime
            end
        end
        totaldmg = totaldmg + n * attack.damage
    end
    return minion.health - totaldmg
end

function _PredictionHealth:GetPredictedHealth(unit, time, delay)
    local IncDamage = 0
    local i = 1
    local MaxDamage = 0
    local count = 0
    delay = delay and delay or 0.07
    while i <= #self.ActiveAttacks do
        if self.ActiveAttacks[i].Attacker and not self.ActiveAttacks[i].Attacker.dead and self.ActiveAttacks[i].Target and self.ActiveAttacks[i].Target.networkID == unit.networkID then
            local hittime = self.ActiveAttacks[i].starttime + self.ActiveAttacks[i].windUpTime + (GetDistance(self.ActiveAttacks[i].pos, unit)) / self.ActiveAttacks[i].projectilespeed + delay
            if self:GetTime() < hittime - delay and hittime < self:GetTime() + time  then
                IncDamage = IncDamage + self.ActiveAttacks[i].damage
                count = count + 1
                if self.ActiveAttacks[i].damage > MaxDamage then
                    MaxDamage = self.ActiveAttacks[i].damage
                end
            end
        end
        i = i + 1
    end

    return unit.health - IncDamage, MaxDamage, count
end

function _PredictionHealth:GetPredictedHealth2(unit, t)
    local damage = 0
    local i = 1

    while i <= #self.ActiveAttacks do
        local n = 0
        if (self:GetTime() - 0.1) <= self.ActiveAttacks[i].starttime + self.ActiveAttacks[i].animationTime and self.ActiveAttacks[i].Target and self.ActiveAttacks[i].Target.valid and self.ActiveAttacks[i].Target.networkID == unit.networkID and self.ActiveAttacks[i].Attacker and self.ActiveAttacks[i].Attacker.valid and not self.ActiveAttacks[i].Attacker.dead then
            local FromT = self.ActiveAttacks[i].starttime
            local ToT = t + self:GetTime()

            while FromT < ToT do
                if FromT >= self:GetTime() and (FromT + (self.ActiveAttacks[i].windUpTime + GetDistance(unit, self.ActiveAttacks[i].pos) / self.ActiveAttacks[i].projectilespeed)) < ToT then
                    n = n + 1
                end
                FromT = FromT + self.ActiveAttacks[i].animationTime
            end
        end
        damage = damage + n * self.ActiveAttacks[i].damage
        i = i + 1
    end

    return unit.health - damage
end

function _PredictionHealth:OnProcessSpell(unit, spell)
    if unit and unit.valid and spell.target and unit.type ~= myHero.type and spell.target.type == 'obj_AI_Minion' and unit.team == myHero.team and spell and spell.name and (spell.name:lower():find('attack') or (spell.name == 'frostarrow')) and spell.windUpTime and spell.target then
        if GetDistanceSqr(unit) < 4000000 then

            local time = self:GetTime() + spell.windUpTime + GetDistance(spell.target, unit) / self:GetProjectileSpeed(unit) - GetLatency()/2000
            local i = 1
            while i <= #self.ActiveAttacks do
                if (self.ActiveAttacks[i].Attacker and self.ActiveAttacks[i].Attacker.valid and self.ActiveAttacks[i].Attacker.networkID == unit.networkID) or ((self.ActiveAttacks[i].hittime + 3) < self:GetTime()) then
                    table.remove(self.ActiveAttacks, i)
                else
                    i = i + 1
                end
            end
            local windUp = spell.windUpTime - (unit.name:lower():find("turret") and 70/1000 or 0)
            local speed = self:GetProjectileSpeed(unit)
            table.insert(self.ActiveAttacks, {Attacker = unit, pos = Vector(unit), Target = spell.target, animationTime = spell.animationTime, damage = self:CalcDamageOfAttack(unit, spell.target, spell, 0), hittime=time, starttime = self:GetTime() - GetLatency()/2000, windUpTime = windUp, projectilespeed = speed})
        end
    end
end

function _PredictionHealth:GetTime()
    return os.clock()
end

function _PredictionHealth:CalcDamageOfAttack(unit, target, spell, bonus)
    return VP:CalcDamageOfAttack(unit, target, spell, bonus)
end

function _PredictionHealth:GetProjectileSpeed(unit)
    return VP:GetProjectileSpeed(unit)
end

class "_Required"
function _Required:__init()
    self.requirements = {}
    self.downloading = {}
end

function _Required:Add(name, url)
    self.requirements[name] = url
end

function _Required:Check()
    for name, url in pairs(self.requirements) do
        if FileExist(LIB_PATH..name..".lua") then
            require(name)
        else
            table.insert(self.downloading, url)
            if #self.downloading == 1 then Print("Downloading required libraries. Please wait..") end
            self:Download(LIB_PATH..name..".lua", url)
        end
    end
    
    if #self.downloading > 0 then
        DelayAction(
        function() 
            if #self.downloading == 0 then 
                Print("Required libraries downloaded. Please reload with 2x F9.")
            end 
        end, 5)
    end
end

function _Required:IsDownloading()
    return self~= nil and #self.downloading > 0 or false
end

function _Required:Download(path, url)
    self.downloader = _Downloader(url)
    AddTickCallback(function()
        if not FileExist(path) then
            self.downloader:Save(path)
        else
            if #self.downloading > 0 then
                for i = 1, #self.downloading do
                    local url2 = self.downloading[i]
                    if url == url2 then
                        table.remove(self.downloading, i)
                        break
                    end
                end
            end
        end
    end)
end

class "_Downloader"
function _Downloader:__init(url)
    self.LuaSocket = require("socket")
    self.DownloadSocket = self.LuaSocket.connect('sx-bol.eu', 80)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(url)..'&rand='..math.random(99999999)
    self.DownloadSocket:send("GET "..self.ScriptPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
    self.DownloadSocket:settimeout(0, 'b')
    self.DownloadSocket:settimeout(99999999, 't')
    self.LastPrint = ""
    self.File = ""
end

function _Downloader:Save(path)
    if self.DownloadStatus == 'closed' then return end
    self.DownloadReceive, self.DownloadStatus, self.DownloadSnipped = self.DownloadSocket:receive(1024)
    self.SavePath = path
    if self.DownloadReceive then
        if self.LastPrint ~= self.DownloadReceive then
            self.LastPrint = self.DownloadReceive
            self.File = self.File .. self.DownloadReceive
        end
    end

    if self.DownloadSnipped ~= "" and self.DownloadSnipped then
        self.File = self.File .. self.DownloadSnipped
    end

    if self.DownloadStatus == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            local ScriptFileOpen = io.open(self.SavePath, "w+")
            ScriptFileOpen:write(self.File:sub(ContentStart + 1))
            ScriptFileOpen:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
            end
        end
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

class "ScriptUpdate"
function ScriptUpdate:__init(scriptName, path ,LocalVersion, Host, VersionPath, ScriptPath)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = path
    local function Print(message)
        print("<font color=\"#6699ff\"><b>" .. scriptName .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") 
    end
    self.CallbackUpdate = function(NewVersion, OldVersion) Print("Updated to "..NewVersion..". Please reload with 2x F9.") end
    self.CallbackNoUpdate = function(OldVersion) Print("No Updates Found.") end
    self.CallbackNewVersion = function(NewVersion) Print("New Version found ("..NewVersion.."). Please wait..") end
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.connect('sx-bol.eu', 80)
    self.Socket:send("GET "..self.VersionPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.LastPrint = ""
    self.File = ""
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function ScriptUpdate:Base64Encode(data)
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

function ScriptUpdate:GetOnlineVersion()
    if self.Status == 'closed' then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)

    if self.Receive then
        if self.LastPrint ~= self.Receive then
            self.LastPrint = self.Receive
            self.File = self.File .. self.Receive
        end
    end

    if self.Snipped ~= "" and self.Snipped then
        self.File = self.File .. self.Snipped
    end
    if self.Status == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            self.OnlineVersion = tonumber(self.File:sub(ContentStart + 1))
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self.DownloadSocket = self.LuaSocket.connect('sx-bol.eu', 80)
                self.DownloadSocket:send("GET "..self.ScriptPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
                self.DownloadSocket:settimeout(0, 'b')
                self.DownloadSocket:settimeout(99999999, 't')
                self.LastPrint = ""
                self.File = ""
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        else
            print('Error: Could not get end of Header')
        end
    end
end

function ScriptUpdate:DownloadUpdate()
    if self.DownloadStatus == 'closed' then return end
    self.DownloadReceive, self.DownloadStatus, self.DownloadSnipped = self.DownloadSocket:receive(1024)

    if self.DownloadReceive then
        if self.LastPrint ~= self.DownloadReceive then
            self.LastPrint = self.DownloadReceive
            self.File = self.File .. self.DownloadReceive
        end
    end

    if self.DownloadSnipped ~= "" and self.DownloadSnipped then
        self.File = self.File .. self.DownloadSnipped
    end

    if self.DownloadStatus == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            local ScriptFileOpen = io.open(self.SavePath, "w+")
            ScriptFileOpen:write(self.File:sub(ContentStart + 1))
            ScriptFileOpen:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
            end
        end
    end
end




