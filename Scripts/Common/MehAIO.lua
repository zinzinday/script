-- Change autoUpdate to false if you wish to not receive auto updates.
-- Change silentUpdate to true if you wish not to receive any message regarding updates
local autoUpdate   = true
local silentUpdate = false

local version = 0.014

local scriptName = "MehAIO"

--[[

     ▄▄▄       ██▓     ██▓        ██▓ ███▄    █     ▒█████   ███▄    █ ▓█████ 
    ▒████▄    ▓██▒    ▓██▒       ▓██▒ ██ ▀█   █    ▒██▒  ██▒ ██ ▀█   █ ▓█   ▀ 
    ▒██  ▀█▄  ▒██░    ▒██░       ▒██▒▓██  ▀█ ██▒   ▒██░  ██▒▓██  ▀█ ██▒▒███   
    ░██▄▄▄▄██ ▒██░    ▒██░       ░██░▓██▒  ▐▌██▒   ▒██   ██░▓██▒  ▐▌██▒▒▓█  ▄ 
     ▓█   ▓██▒░██████▒░██████▒   ░██░▒██░   ▓██░   ░ ████▓▒░▒██░   ▓██░░▒████▒
     ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░   ░▓  ░ ▒░   ▒ ▒    ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ ░░ ▒░ ░
      ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░    ▒ ░░ ░░   ░ ▒░     ░ ▒ ▒░ ░ ░░   ░ ▒░ ░ ░  ░
      ░   ▒     ░ ░     ░ ░       ▒ ░   ░   ░ ░    ░ ░ ░ ▒     ░   ░ ░    ░   

    All In One - Well, at least some champs in one script :D

    People who helped me:
        Apple  - Multi champ framework setup
        Zikkah - Packet help (Blitzcrank Q)

]]

local champions = {
    ["Blitzcrank"]   = true,
    ["Brand"]        = true,
    ["Orianna"]      = true,
    ["Xerath"]       = true,
    --["Yasuo"]        = true
}

if not champions[player.charName] then autoUpdate = nil silentUpdate = nil version = nil scriptName = nil champions = nil collectgarbage() return end

--[[ Updater and library downloader ]]

local sourceLibFound = true
    require "SourceLib"
else
    sourceLibFound = false
end

if not sourceLibFound then return end

if autoUpdate then
    SourceUpdater(scriptName, version, "raw.github.com", "/Hellsing/public/master/" .. scriptName .. ".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/Hellsing/public/master/version/" .. scriptName .. ".version"):SetSilent(silentUpdate):CheckUpdate()
end

local libDownloader = Require(scriptName)
libDownloader:Add("Prodiction",  "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/master/Test/Prodiction/Prodiction.lua")
libDownloader:Add("VPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
libDownloader:Add("SOW",         "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
libDownloader:Check()

if libDownloader.downloadNeeded then return end

--[[ Class initializing ]]

for k, _ in pairs(champions) do
    local className = k:gsub("%s+", "")
    class(className)
    champions[k] = _G[className]
end

--[[ Static Variables ]]--


--[[ Script Variables ]]--

local champ = champions[player.charName]
local menu  = nil
local VP    = nil
local OW    = nil
local STS   = nil
local DM    = nil
local DLib  = nil

local spellData = {}

local spells   = {}
local circles  = {}
local AAcircle = nil

local champLoaded = false
local skip        = false

local skinNumber = nil

local __colors = {
    { current = 255, step = 1, min = 0, max = 255, mode = -1 },
    { current = 255, step = 2, min = 0, max = 255, mode = -1 },
    { current = 255, step = 3, min = 0, max = 255, mode = -1 },
}

--[[ General Callbacks ]]--

function OnLoad()

    -- Load dependencies
    VP   = VPrediction()
    OW   = SOW(VP)
    STS  = SimpleTS()
    DM   = DrawManager()
    DLib = DamageLib()

    -- Load champion
    champ = champ()

    -- Prevent errors
    if not champ then print("There was an error while loading " .. player.charName .. ", please report the shown error to Hellsing, thanks!") return else champLoaded = true end

    -- Auto attack range circle
    AAcircle = DM:CreateCircle(player, OW:MyRange(), 3)

    -- Load menu
    loadMenu()

    --if true then champLoaded = false return end

    -- Regular callbacks registering
    if champ.OnUnload       then AddUnloadCallback(function()                     champ:OnUnload()                  end) end
    if champ.OnExit         then AddExitCallback(function()                       champ:OnExit()                    end) end
    if champ.OnDraw         then AddDrawCallback(function()                       champ:OnDraw()                    end) end
    if champ.OnReset        then AddResetCallback(function()                      champ:OnReset()                   end) end
    if champ.OnSendChat     then AddChatCallback(function(text)                   champ:OnSendChat(text)            end) end
    if champ.OnRecvChat     then AddRecvChatCallback(function(text)               champ:OnRecvChat(text)            end) end
    if champ.OnWndMsg       then AddMsgCallback(function(msg, wParam)             champ:OnWndMsg(msg, wParam)       end) end
    --if champ.OnCreateObj    then AddCreateObjCallback(function(obj)               champ:OnCreateObj(object)         end) end
    if champ.OnDeleteObj    then AddDeleteObjCallback(function(obj)               champ:OnDeleteObj(object)         end) end
    if champ.OnProcessSpell then AddProcessSpellCallback(function(unit, spell)    champ:OnProcessSpell(unit, spell) end) end
    if champ.OnSendPacket   then AddSendPacketCallback(function(p)                champ:OnSendPacket(p)             end) end
    if champ.OnRecvPacket   then AddRecvPacketCallback(function(p)                champ:OnRecvPacket(p)             end) end
    if champ.OnBugsplat     then AddBugsplatCallback(function()                   champ:OnBugsplat()                end) end
    if champ.OnAnimation    then AddAnimationCallback(function(object, animation) champ:OnAnimation()               end) end
    if champ.OnNotifyEvent  then AddNotifyEventCallback(function(event, unit)     champ:OnNotify(event, unit)       end) end
    if champ.OnParticle     then AddParticleCallback(function(unit, particle)     champ:OnParticle(unit, particle)  end) end

    -- Advanced callbacks registering
    if champ.OnGainBuff     then AdvancedCallback:bind('OnGainBuff',   function(unit, buff) champ:OnGainBuff(unit, buff)   end) end
    if champ.OnUpdateBuff   then AdvancedCallback:bind('OnUpdateBuff', function(unit, buff) champ:OnUpdateBuff(unit, buff) end) end
    if champ.OnLoseBuff     then AdvancedCallback:bind('OnLoseBuff',   function(unit, buff) champ:OnLoseBuff(unit, buff)   end) end

end

function OnTick()

    -- Prevent error spamming
    if not champLoaded then return end

    if champ.OnTick then
        champ:OnTick()
    end

    -- Skip combo once
    if skip then
        skip = false
        return
    end

    if champ.OnCombo and menu.combo and menu.combo.active then
        champ:OnCombo()
    elseif champ.OnHarass and menu.harass and menu.harass.active then
        champ:OnHarass()
    end

end

function OnDraw()

    -- Prevent error spamming
    if not champLoaded then return end

    __mixColors()
    AAcircle.color[2] = __colors[1].current
    AAcircle.color[3] = __colors[2].current
    AAcircle.color[4] = __colors[3].current
    AAcircle.range    = OW:MyRange() 

    -- Skin changer
    if menu.skin then
        for i = 1, skinNumber do
            if menu.skin["skin"..i] then
                menu.skin["skin"..i] = false
                GenModelPacket(player.charName, i - 1)
            end
        end
    end

end

-- Spudgy please...
function OnCreateObj(object) if champLoaded and champ.OnCreateObj then champ:OnCreateObj(object) end end

--[[ Other Functions ]]--

function loadMenu()
    menu = MenuWrapper("[" .. scriptName .. "] " .. player.charName, "unique" .. player.charName:gsub("%s+", ""))

    -- Skin changer
    if champ.GetSkins then
        menu:GetHandle():addSubMenu("Skin Changer", "skin")
        for i, name in ipairs(champ:GetSkins()) do
            menu:GetHandle().skin:addParam("skin"..i, name, SCRIPT_PARAM_ONOFF, false)
        end
        skinNumber = #champ:GetSkins()
    end

    menu:SetTargetSelector(STS)
    menu:SetOrbwalker(OW)

    -- Apply menu as normal script config
    menu = menu:GetHandle()

    -- Prediction
    menu:addSubMenu("Prediction", "prediction")
        menu.prediction:addParam("predictionType", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "Prodiction" })
        _G.srcLib.spellMenu =  menu.prediction

    -- Combo
    if champ.OnCombo then
    menu:addSubMenu("Combo", "combo")
        menu.combo:addParam("active", "Combo active", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    end

    -- Harass
    if champ.OnHarass then
    menu:addSubMenu("Harass", "harass")
        menu.harass:addParam("active", "Harass active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    end

    -- Apply champ menu values
    if champ.ApplyMenu then champ:ApplyMenu() end
end

function initializeSpells()
    -- Create spells and circles
    for id, data in pairs(spellData) do
        -- Range
        local range = type(data.range) == "number" and data.range or data.range[1]
        -- Spell
        local spell = Spell(id, range)
        if data.skillshotType then
            spell:SetSkillshot(VP, data.skillshotType, data.width, data.delay, data.speed, data.collision)
        end
        table.insert(spells, id, spell)
        -- Circle
        local circle = DM:CreateCircle(player, range):LinkWithSpell(spell)
        circle:SetDrawCondition(function() return spell:GetLevel() > 0 end)
        table.insert(circles, id, circle)
    end
end

function getBestTarget(range, condition)
    condition = condition or function() return true end
    local target = STS:GetTarget(range)
    if not target or not condition(target) then
        target = nil
        for _, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, range) and condition(enemy) then
                if not target or enemy.health < target.health then
                    target = enemy
                end
            end
        end
    end
    return target
end

function skipCombo()
    skip = true
end

function __mixColors()
    for i = 1, #__colors do
        local color = __colors[i]
        color.current = color.current + color.mode * color.step
        if color.current < color.min then
            color.current = color.min
            color.mode = 1
        elseif color.current > color.max then
            color.current = color.max
            color.mode = -1
        end
    end
end

-- Credits to shalzuth for this!
function GenModelPacket(champ, skinId)
    p = CLoLPacket(0x97)
    p:EncodeF(player.networkID)
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

function GetPredictedPos(unit, delay, speed, source)
    if menu.prediction.predictionType == 1 then
        return VP:GetPredictedPos(unit, delay, speed, source)
    elseif menu.prediction.predictionType == 2 then
        return Prodiction.GetPrediction(unit, math.huge, speed, delay, 1, source)
    end
end

function CountAllyHeroInRange(range, point)
    local n = 0
    for i, ally in ipairs(GetAllyHeroes()) do
        if ValidTarget(ally, math.huge, false) and GetDistanceSqr(point, ally) <= range * range then
            n = n + 1
        end
    end
    return n
end

function GetDistanceToClosestAlly(p)
    local d = GetDistance(p, myHero)
    for i, ally in ipairs(GetAllyHeroes()) do
        if ValidTarget(ally, math.huge, false) then
            local dist = GetDistance(p, ally)
            if dist < d then
                d = dist
            end
        end
    end
    return d
end  
 
--[[
    ██████╗ ██╗     ██╗████████╗███████╗ ██████╗██████╗  █████╗ ███╗   ██╗██╗  ██╗
    ██╔══██╗██║     ██║╚══██╔══╝╚══███╔╝██╔════╝██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝
    ██████╔╝██║     ██║   ██║     ███╔╝ ██║     ██████╔╝███████║██╔██╗ ██║█████╔╝ 
    ██╔══██╗██║     ██║   ██║    ███╔╝  ██║     ██╔══██╗██╔══██║██║╚██╗██║██╔═██╗ 
    ██████╔╝███████╗██║   ██║   ███████╗╚██████╗██║  ██║██║  ██║██║ ╚████║██║  ██╗
    ╚═════╝ ╚══════╝╚═╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
]]

function Blitzcrank:__init()

    spellData = {
        [_Q] = { range = 1000, skillshotType = SKILLSHOT_LINEAR, width = 70, delay = 0.25, speed = 1800, collision = true },
        [_W] = { range = -1 },
        [_E] = { range = -1 },
        [_R] = { range = 600 },
    }
    initializeSpells()

    self.stats = { numCasted = 0, numLanded = 0, numLandedChamps = 0, numLandedMinions = 0, landedOnChamps = {} }
    self.projectileId = 0
    self.projectileTime = 0

    self.combo = { _AA, _Q, _R }

    --Register damage sources
    DLib:RegisterDamageSource(_Q, _MAGIC, 80,  55,  _MAGIC, _AP, 1, function() return spells[_Q]:IsReady() end)
    DLib:RegisterDamageSource(_R, _MAGIC, 250, 125, _MAGIC, _AP, 1, function() return spells[_R]:IsReady() end)

end

function Blitzcrank:GetSkins()
    return {
        "Classic",
        "Rusty",
        "Goalkeeper",
        "Boom Boom",
        "Piltover Customs",
        "Definitely Not Blitzcrank",
        "iBlitzcrank",
        "Riot"
    }
end

function Blitzcrank:CheckHeroCollision(pos)

    for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and _GetDistanceSqr(enemy) < math.pow(spells[_Q].range * 1.5, 2) and menu.targets[enemy.charName] == 1 then
            local proj1, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(player), pos, Vector(enemy))
            if (_GetDistanceSqr(enemy, proj1) <= math.pow(VP:GetHitBox(enemy) * 2 + spells[_Q].width, 2)) then
                return true
            end
        end
    end
    return false

end

function Blitzcrank:GetLeastHealthAround()

    local leastHealthAround = player.health / player.maxHealth * 100
    for i, ally in ipairs(GetAllyHeroes()) do
        local mp = ally.health / ally.maxHealth * 100
        if mp <= leastHealthAround and not ally.dead and _GetDistanceSqr(ally) < 700 * 700 then
            leastHealthAround = mp
        end
    end
    return leastHealthAround

end

function Blitzcrank:OnCombo()

    local target = getBestTarget(spells[_Q].range, function(enemy) return menu.targets[enemy.charName] > 1 end)
    if target then
        spells[_Q]:Cast(target)
    end

end

function Blitzcrank:OnTick()

    -- Killsteal
    if menu.killsteal and spells[_R]:IsReady() then
        local target = getBestTarget(spells[_R].range, function(enemy) return enemy.health <= DLib:CalcSpellDamage(enemy, _R) end)
        if target then
            spells[_R]:Cast()
            return
        end
    end

    -- Don't grab on low health
    if Blitzcrank:GetLeastHealthAround() < menu.autoGrab.lowHealth then return end

    -- AutoGrab
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, 1500) and menu.targets[enemy.charName] == 3 then
            local castPosition, hitChance = spells[_Q]:GetPrediction(enemy)
            
            if hitChance == 5 and menu.autoGrab.dashing and _GetDistanceSqr(castPosition) < spells[_Q].rangeSqr then
                if not self:CheckHeroCollision(castPosition) then
                    spells[_Q]:Cast(castPosition.x, castPosition.z)
                    return
                end
            elseif hitChance == 4 and menu.autoGrab.immobile and _GetDistanceSqr(castPosition) < spells[_Q].rangeSqr then
                if _GetDistanceSqr(castPosition) > 300 * 300 and not self:CheckHeroCollision(castPosition) then
                    spells[_Q]:Cast(castPosition.x, castPosition.z)
                    return
                end
            end
        end
    end

end

function Blitzcrank:OnTargetInterruptable(unit, spell)
    -- Don't grab on low health
    if Blitzcrank:GetLeastHealthAround() < menu.autoGrab.lowHealth then return end

    if spells[_R]:IsReady() and spells[_R]:IsInRange(unit) then
        spells[_R]:Cast(unit)
    end
end

function Blitzcrank:OnTargetGapclosing(unit, spell)
    -- Don't grab on low health
    if Blitzcrank:GetLeastHealthAround() < menu.autoGrab.lowHealth then return end

    if spells[_Q]:IsReady() then
        spells[_Q]:Cast(unit)
    end
end

function Blitzcrank:OnRecvPacket(p)

    -- Casted Q
    if p.header == 0xB5 then
        p.pos = 1
        local nwid = p:DecodeF()
        if nwid == player.networkID then
            p.pos = 65
            local n = p:Decode1()
            local spellid = -1
            if n == 1 then
                p.pos = 104
                spellid=p:Decode1()
            else
                p.pos = 87
                spellid=p:Decode1()
            end
            if spellid == 44 then
                self.stats.numCasted = self.stats.numCasted + 1
                p.pos = 37
                self.projectileId = p:DecodeF()
                self.projectileTime = os.clock()
            end
        end
    -- Landed Q
    elseif p.header == 0x26 then
        p.pos = 1
        local pr = p:DecodeF()
        if pr == self.projectileId and (os.clock() - self.projectileTime) < 2 then
            p.pos = p.pos + 2
            local h = objManager:GetObjectByNetworkId(p:DecodeF())
            if h and h.valid then
                self.stats.numLanded = self.stats.numLanded + 1
                if h.type == player.type then
                    if menu.autoE and spells[_E]:IsReady() then
                        spells[_E]:Cast()
                    end
                    self.stats.numLandedChamps = self.stats.numLandedChamps + 1
                    self.stats.landedOnChamps[h.charName] = (self.stats.landedOnChamps[h.charName] and self.stats.landedOnChamps[h.charName] or 0 ) + 1
                else
                    self.stats.numLandedMinions = self.stats.numLandedMinions + 1
                end
            end
        end
    end

end

function Blitzcrank:OnDraw()

    if menu.drawing.stats and self.stats.numCasted > 0 then
        DrawText("Stats", 17, 10, 10, ARGB(255,225,255,255))
        local Ratio = self.stats.numLandedChamps / self.stats.numCasted

        DrawText("Landed Q's (Total): "     .. self.stats.numLanded        .. "/" .. self.stats.numCasted .. " " .. math.floor(self.stats.numLanded / self.stats.numCasted * 100)        .. "%", 13, 10, 30, ARGB(255,255,255,255))
        DrawText("Landed Q's (Champions): " .. self.stats.numLandedChamps  .. "/" .. self.stats.numCasted .. " " .. math.floor(self.stats.numLandedChamps / self.stats.numCasted * 100)  .. "%", 13, 10, 45, ARGB(255,255,255,255))
        DrawText("Landed Q's (Minions): "   .. self.stats.numLandedMinions .. "/" .. self.stats.numCasted .. " " .. math.floor(self.stats.numLandedMinions / self.stats.numCasted * 100) .. "%", 13, 10, 60, ARGB(255,255,255,255))

        local i = 1
        for name, times in pairs(self.stats.landedOnChamps) do
            DrawText("Landed Q's (" .. name .. "): " .. times, 13, 10, 60 + i * 15, ARGB(255,255,255,255))
            i = i + 1
        end
    end

end

function Blitzcrank:ApplyMenu()

    menu:addSubMenu("Auto-Interrupt", "interrupt")
        Interrupter(menu.interrupt, self.OnTargetInterruptable)

    menu:addSubMenu("Auto-Grab", "autoGrab")
        menu.autoGrab:addSubMenu("Anti-Gapclosers", "antiGapcloser")
            AntiGapcloser(menu.autoGrab.antiGapcloser, self.OnTargetGapclosing)
        menu.autoGrab:addParam("dashing",   "Auto-Grab dashing enemies",        SCRIPT_PARAM_ONOFF, true)
        menu.autoGrab:addParam("immobile",  "Auto-Grab immobile enemies",       SCRIPT_PARAM_ONOFF, true)
        menu.autoGrab:addParam("sep",       "",                                 SCRIPT_PARAM_INFO, "")
        menu.autoGrab:addParam("lowHealth", "Don't auto grab if my health < %", SCRIPT_PARAM_SLICE, 0, 0, 100)

    menu:addSubMenu("Targets", "targets")
        for i, enemy in ipairs(GetEnemyHeroes()) do
            menu.targets:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_LIST, 3, {"Don't grab", "Normal grab", "Normal + Auto-grab"})
        end

    menu:addSubMenu("Drawing", "drawing")
        AAcircle:SetEnabled(false)
        circles[_Q]:AddToMenu(menu.drawing, "Q Range", true, true, true)
        circles[_R]:AddToMenu(menu.drawing, "R Range", true, true, true)
        menu.drawing:addParam("sep",   "",                       SCRIPT_PARAM_INFO, "")
        menu.drawing:addParam("stats", "Draw stats on the side", SCRIPT_PARAM_ONOFF, true)
        DLib:AddToMenu(menu.drawing, self.combo)

    menu:addParam("sep",       "",                  SCRIPT_PARAM_INFO, "")
    menu:addParam("autoE",     "Auto-E after grab", SCRIPT_PARAM_ONOFF, true)
    menu:addParam("killsteal", "Killsteal with R",  SCRIPT_PARAM_ONOFF, false)

end  
 
--[[
    ██████╗ ██████╗  █████╗ ███╗   ██╗██████╗ 
    ██╔══██╗██╔══██╗██╔══██╗████╗  ██║██╔══██╗
    ██████╔╝██████╔╝███████║██╔██╗ ██║██║  ██║
    ██╔══██╗██╔══██╗██╔══██║██║╚██╗██║██║  ██║
    ██████╔╝██║  ██║██║  ██║██║ ╚████║██████╔╝
    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
]]

function Brand:__init()

    spellData = {
        [_Q] = { range = 1100, skillshotType = SKILLSHOT_LINEAR,   width = 60,  delay = 0.25, speed = 1600,      collision = true },
        [_W] = { range = 900,  skillshotType = SKILLSHOT_CIRCULAR, width = 240, delay = 1,    speed = math.huge, collision = false },
        [_E] = { range = 625 },
        [_R] = { range = 750 },
    }
    initializeSpells()

    -- Finetune spells
    spells[_W]:SetAOE(true)
    spells[_E].VP = VP

    -- Minions
    self.enemyMinions  = minionManager(MINION_ENEMY,  spells[_Q].range, player, MINION_SORT_MAXHEALTH_DEC)
    self.jungleMinions = minionManager(MINION_JUNGLE, spells[_Q].range, player, MINION_SORT_MAXHEALTH_DEC)

    self.mainCombo   = { ItemManager:GetItem("DFG"):GetId(), _AA, _Q, _W, _E, _R, _PASIVE, _IGNITE }
    self.bounceCombo = { ItemManager:GetItem("DFG"):GetId(), _AA, _Q, _W, _E, _R, _R, _R, _PASIVE, _IGNITE }

    -- Register damage sources
    DLib:RegisterDamageSource(_Q, _MAGIC, 40, 40,  _MAGIC, _AP, 0.65, function() return spells[_Q]:IsReady() end)
    DLib:RegisterDamageSource(_W, _MAGIC, 30, 45,  _MAGIC, _AP, 0.60, function() return spells[_W]:IsReady() end, function(target) return self:IsAblazed(target) and (player.ap * 0.15 + spells[_W]:GetLevel() * 15) or 0 end)
    DLib:RegisterDamageSource(_E, _MAGIC, 35, 35,  _MAGIC, _AP, 0.55, function() return spells[_E]:IsReady() end)
    DLib:RegisterDamageSource(_R, _MAGIC, 50, 100, _MAGIC, _AP, 0.5,  function() return spells[_R]:IsReady() end)
    DLib:RegisterDamageSource(_PASIVE, _MAGIC, 0, 0, _MAGIC, _AP, 0, nil, function(target) return 0.08 * target.maxHealth end)

end

function Brand:GetSkins()
    return {
        "Classic",
        "Apocalyptic",
        "Vandal",
        "Cryocore",
        "Zombie"
    }
end

function Brand:IsAblazed(target)
    return HasBuff(target, "brandablaze")
end

function Brand:OnTick()

    OW:EnableAttacks()

    -- Forced ult cast
    if menu.ult.castR and spells[_R]:IsReady() then
        local target = STS:GetTarget(spells[_R].range)
        spells[_R]:Cast(target)
    end

    -- Farming
    if menu.farm.freeze or menu.farm.lane then
        self:OnFarm()
    end

    -- Jungle farming
    if menu.jfarm.active then
        self:OnJungleFarm()
    end

    -- Misc stuff
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and _GetDistanceSqr(enemy) < spells[_Q].rangeSqr then

            if menu.misc.autoStunQ and spells[_Q]:IsReady() then
                local status = spells[_E]:CastIfImmobile(enemy)
                if status ~= SPELLSTATE_TRIGGERED then
                    spells[_Q]:CastIfImmobile(enemy)
                end
            end

            if menu.misc.autoGapQ and spells[_Q]:IsReady() then
                local status = spells[_E]:CastIfDashing(enemy)
                if status ~= SPELLSTATE_TRIGGERED then
                    spells[_Q]:CastIfDashing(enemy)
                end
            end

            if menu.misc.autoStunW and spells[_W]:IsReady() and _GetDistanceSqr(enemy) < (spells[_W].range + spells[_W].width)^2 then
                spells[_W]:CastIfImmobile(enemy)
            end
        end
    end

    -- Auto cast ult
    if menu.ult.autoR ~= 1 then
        for _, enemy in ipairs(GetEnemyHeroes()) do
            if not menu.ult.targets[enemy.charName] and ValidTarget(enemy) and _GetDistanceSqr(enemy) < spells[_R].rangeSqr then
                local targets = SelectUnits(GetEnemyHeroes(), function(t) return ValidTarget(t) and _GetDistanceSqr(t, enemy) < 202500 end)
                if #targets > (menu.ult.autoR -1) then
                    spells[_R]:Cast(enemy)
                end
            end
        end
    end

end

function Brand:OnCombo()

    if not spells[_Q]:IsReady() and not spells[_W]:IsReady() and not spells[_E]:IsReady() and not spells[_R]:IsReady() then
        OW:EnableAttacks()
        return
    end
    
    local targets = {
        [_Q] = STS:GetTarget(spells[_Q].range),
        [_W] = STS:GetTarget(spells[_W].range),
        [_E] = STS:GetTarget(spells[_E].range),
        [_R] = STS:GetTarget(spells[_R].range),
    }
    local status = nil
    local spellTriggered = nil

    OW:DisableAttacks()

    if targets[_W] and DLib:IsKillable(targets[_W], self.mainCombo) then
        ItemManager:CastOffensiveItems(targets[_W])
    end

    if menu.combo.useQ and targets[_Q] and spells[_Q]:IsReady() then
        if self:IsAblazed(targets[_Q]) or not menu.misc.ablazed or DLib:IsKillable(targets[_Q], {_Q, _PASIVE}) then
            if not menu.combo.useE or not targets[_E] or not spells[_E]:IsReady() then
                if not menu.combo.useW or not targets[_W] or not spells[_W]:IsReady() then
                    status = spells[_Q]:Cast(targets[_Q])
                end
            end
        end
    end

    if menu.combo.useW and targets[_W] and spells[_W]:IsReady() then
        if not menu.combo.useE or not targets[_E] or not spells[_E]:IsReady() then
            if not status or status == SPELLSTATE_COLLISION then
                spellTriggered = spellTriggered or spells[_W]:Cast(targets[_W]) == SPELLSTATE_TRIGGERED
            end
        end
    end

    if menu.combo.useE and targets[_E] and spells[_E]:IsReady() and (DLib:IsKillable(targets[_E], self.mainCombo) or (spells[_Q]:IsReady() or spells[_W]:IsReady())) then
        spellTriggered = spellTriggered or spells[_E]:Cast(targets[_E]) == SPELLSTATE_TRIGGERED
    end

    if menu.combo.ignite and _IGNITE then
        local igniteTarget = STS:GetTarget(600)
        if igniteTarget and DLib:IsKillable(igniteTarget, self.mainCombo) then
            CastSpell(_IGNITE, igniteTarget)
        end
    end

    if menu.combo.useR and targets[_R] and spells[_R]:IsReady() then
        if not menu.ult.targets[targets[_R].charName] then
            -- Regular kill
            if (not spells[_Q]:IsReady() or not status or status == SPELLSTATE_COLLISION) and DLib:IsKillable(targets[_R], self.mainCombo) then
                if spells[_E]:IsReady() and _GetDistanceSqr(targets[_R]) <= spells[_E].rangeSqr then
                    spellTriggered = spellTriggered or spells[_E]:Cast(targets[_R]) == SPELLSTATE_TRIGGERED
                end
                spellTriggered = spellTriggered or spells[_R]:Cast(targets[_R]) == SPELLSTATE_TRIGGERED
            end
            -- Bounce kill
            self.enemyMinions:update()
            local enemies = SelectUnits(MergeTables(self.enemyMinions.objects, GetEnemyHeroes()), function(t) return ValidTarget(t) and _GetDistanceSqr(t, targets[_R]) < 202500 end)
            if #enemies > 1 and DLib:IsKillable(targets[_R], self.bounceCombo) then
                if not self:IsAblazed(targets[_R]) and spells[_E]:IsReady() and _GetDistanceSqr(targets[_R]) < spells[_E].rangeSqr then
                    if spells[_E]:Cast(targets[_R]) ~= SPELLSTATE_TRIGGERED then OW:EnableAttacks() return end
                end
                spellTriggered = spellTriggered or spells[_R]:Cast(targets[_R]) == SPELLSTATE_TRIGGERED
            end
        end
    end

    if not spellTriggered or status ~= SPELLSTATE_TRIGGERED then
        OW:EnableAttacks()
    end

end

function Brand:OnHarass()

    if menu.harass.mana > (player.mana / player.maxMana) * 100 then return end

    local targets = {
        [_Q] = STS:GetTarget(spells[_Q].range),
        [_W] = STS:GetTarget(spells[_W].range),
        [_E] = STS:GetTarget(spells[_E].range)
    }

    if menu.harass.useQ and targets[_Q] and spells[_Q]:IsReady() then
        spells[_Q]:Cast(targets[_Q])
    end

    if menu.harass.useW and targets[_W] and spells[_W]:IsReady() then
        spells[_W]:Cast(targets[_W])
    end

    if menu.harass.useE and targets[_E] and spells[_E]:IsReady() then
        spells[_E]:Cast(targets[_E])
    end

end

function Brand:OnFarm()

    if menu.farm.mana > (player.mana / player.maxMana) * 100 then return end

    self.enemyMinions:update()

    local minion = self.enemyMinions.objects[1]

    if minion then
        local useQ = spells[_Q]:IsReady() and (menu.farm.lane and (menu.farm.useQ >= 3) or (menu.farm.useQ == 2))
        local useW = spells[_W]:IsReady() and (menu.farm.lane and (menu.farm.useW >= 3) or (menu.farm.useW == 2))
        local useE = spells[_E]:IsReady() and (menu.farm.lane and (menu.farm.useE >= 3) or (menu.farm.useE == 2))

        if useQ then
            spells[_Q]:Cast(minion)
        end

        if useE then
            if menu.farm.lane then
                for _, minion in ipairs(self.enemyMinions.objects) do
                    if _GetDistanceSqr(minion) < spells[_E].rangeSqr and self:IsAblazed(minion) then
                        spells[_E]:Cast(minion)
                    end
                end
                if DLib:IsKillable(minion, {_E}) then
                    spells[_E]:Cast(minion)
                end
            else
                if not OW:InRange(minion) and DLib:IsKillable(minion, {_E}) then
                    spells[_E]:Cast(minion)
                end
            end 
        end

        if useW then
            local casterMinions = SelectUnits(self.enemyMinions.objects, function(t) return (t.charName:lower():find("wizard") or t.charName:lower():find("caster")) and ValidTarget(t) end)
            casterMinions = GetPredictedPositionsTable(VP, casterMinions, spells[_W].delay, spells[_W].width, spells[_W].range, math.huge, player, false)

            local castPosition, hitNumber = GetBestCircularFarmPosition(spells[_W].range, spells[_W].width, casterMinions)
            if hitNumber > 2 then
                spells[_W]:Cast(castPosition.x, castPosition.z)
                return
            end

            local allMinions = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) end)
            allMinions = GetPredictedPositionsTable(VP, allMinions, spells[_W].delay, spells[_W].width, spells[_W].range, math.huge, player, false)

            local castPosition, hitNumber = GetBestCircularFarmPosition(spells[_W].range, spells[_W].width, allMinions)
            if hitNumber > 2 then
                spells[_W]:Cast(castPosition.x, castPosition.z)
                return
            end
        end
    end

end

function Brand:OnJungleFarm()

    self.jungleMinions:update()

    local minion = self.jungleMinions.objects[1]

    if minion then
        local useQ = menu.jfarm.useQ and spells[_Q]:IsReady()
        local useW = menu.jfarm.useW and spells[_W]:IsReady()
        local useE = menu.jfarm.useE and spells[_E]:IsReady()


        if useQ and (not useW and not useE or self:IsAblazed(minion)) then
            spells[_Q]:Cast(minion)
        end
        if useW then
            local castPosition = GetBestCircularFarmPosition(spells[_W].range, spells[_W].width, self.jungleMinions.objects)
            spells[_W]:Cast(castPosition.x, castPosition.z)
        end
        if useE and (not useW or self:IsAblazed(minion)) then
            spells[_E]:Cast(minion)
        end
    end

end

function Brand:ApplyMenu()

    menu.combo:addParam("sep",    "",           SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("useQ",   "Use Q",      SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useW",   "Use W",      SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useE",   "Use E",      SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useR",   "Use R",      SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("sep",    "",           SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("ignite", "Use ignite", SCRIPT_PARAM_ONOFF, true)

    menu.harass:addParam("sep",  "",                         SCRIPT_PARAM_INFO, "")
    menu.harass:addParam("useQ", "Use Q",                    SCRIPT_PARAM_ONOFF, true)
    menu.harass:addParam("useW", "Use W",                    SCRIPT_PARAM_ONOFF, true)
    menu.harass:addParam("useE", "Use E",                    SCRIPT_PARAM_ONOFF, true)
    menu.harass:addParam("sep",  "",                         SCRIPT_PARAM_INFO, "")
    menu.harass:addParam("mana", "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)

    menu:addSubMenu("Farm", "farm")
        menu.farm:addParam("freeze", "Farm Freezing",          SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        menu.farm:addParam("lane",   "Farm Lane-Clear",        SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("useQ",   "Use Q",                  SCRIPT_PARAM_LIST, 1, { "No", "Freeze", "LaneClear", "Both" }) 
        menu.farm:addParam("useW",   "Use W",                  SCRIPT_PARAM_LIST, 3, { "No", "Freeze", "LaneClear", "Both" })
        menu.farm:addParam("useE",   "Use E",                  SCRIPT_PARAM_LIST, 4, { "No", "Freeze", "LaneClear", "Both" })
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("mana",   "Don't farm if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)

    menu:addSubMenu("JungleFarm", "jfarm")
        menu.jfarm:addParam("active", "Farm!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.jfarm:addParam("sep",    "",      SCRIPT_PARAM_INFO, "")
        menu.jfarm:addParam("useQ",   "Use Q", SCRIPT_PARAM_ONOFF, false)
        menu.jfarm:addParam("useW",   "Use W", SCRIPT_PARAM_ONOFF, true)
        menu.jfarm:addParam("useE",   "Use E", SCRIPT_PARAM_ONOFF, true)

    menu:addSubMenu("Ultimate", "ult")
        menu.ult:addSubMenu("Don't use R on", "targets")
        for _, enemy in ipairs(GetEnemyHeroes()) do
            menu.ult.targets:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, false)
        end
        menu.ult:addParam("ablazed", "Only R if target ablazed/killable", SCRIPT_PARAM_ONOFF, true)
        menu.ult:addParam("autoR",   "Auto R if it will hit: ",           SCRIPT_PARAM_LIST, 1, { "No", ">0 targets", ">1 targets", ">2 targets", ">3 targets", ">4 targets" })
        menu.ult:addParam("castR",   "Force ultimate cast",               SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))

    menu:addSubMenu("Misc", "misc")
        menu.misc:addParam("ablazed",    "Respect ablazed for comboing",  SCRIPT_PARAM_ONOFF, true)
        menu.misc:addParam("autoGapQ",   "Auto EQ on gapclosing targets", SCRIPT_PARAM_ONOFF, true)
        menu.misc:addParam("autoStunQ",  "Auto EQ on stunned targets",    SCRIPT_PARAM_ONOFF, true)
        menu.misc:addParam("autoStunW",  "Auto W on stunned targets",     SCRIPT_PARAM_ONOFF, true)

    menu:addSubMenu("Drawing", "drawing")
    AAcircle:AddToMenu(menu.drawing, "AA Range", false, true, true)
    for spell, circle in pairs(circles) do
        circle:AddToMenu(menu.drawing, SpellToString(spell).." range", true, true, true)
    end
    DLib:AddToMenu(menu.drawing, self.mainCombo)

end  
 
--[[
     ██████╗ ██████╗ ██╗ █████╗ ███╗   ██╗███╗   ██╗ █████╗ 
    ██╔═══██╗██╔══██╗██║██╔══██╗████╗  ██║████╗  ██║██╔══██╗
    ██║   ██║██████╔╝██║███████║██╔██╗ ██║██╔██╗ ██║███████║
    ██║   ██║██╔══██╗██║██╔══██║██║╚██╗██║██║╚██╗██║██╔══██║
    ╚██████╔╝██║  ██║██║██║  ██║██║ ╚████║██║ ╚████║██║  ██║
     ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝  ╚═╝
]]

function Orianna:__init()

    spellData = {
        [_Q] = { range = 825, skillshotType = SKILLSHOT_LINEAR, width = 80,  delay = 0,    speed = 1200, radius = 145, collision = false },
        [_W] = { range = -1,                                    width = 235, delay = 0.25 },
        [_E] = { range = 1095,                                  width = 80,  delay = 0.25, speed = 1700 },
        [_R] = { range = -1,                                    width = 380, delay = 0.6  },
    }
    initializeSpells()

    -- Finetune spells
    spells[_E]:SetSkillshot(VP, SKILLSHOT_LINEAR, spellData[_E].width, spellData[_E].delay, spellData[_E].speed, false)
    spells[_E].skillshotType = nil
    spells[_W].packetCast = true
    spells[_R].packetCast = true

    -- Circle customization
    circles[_Q].color = { 255, 255, 100, 0 }
    circles[_Q].width = 2
    circles[_W].enabled = false
    circles[_E].enabled = false
    circles[_R].enabled = false

    -- Minions
    self.enemyMinions  = minionManager(MINION_ENEMY,  spells[_Q].range, player, MINION_SORT_MAXHEALTH_DEC)
    self.jungleMinions = minionManager(MINION_JUNGLE, spells[_Q].range, player, MINION_SORT_MAXHEALTH_DEC)

    self.mainCombo = { _AA, _AA, _Q, _W, _R, _Q, _IGNITE }

    -- Register damage sources
    DLib:RegisterDamageSource(_Q, _MAGIC, 60,  30, _MAGIC, _AP, 0.5, function() return spells[_Q]:IsReady() end)
    DLib:RegisterDamageSource(_W, _MAGIC, 70,  45, _MAGIC, _AP, 0.7, function() return spells[_W]:IsReady() end)
    DLib:RegisterDamageSource(_E, _MAGIC, 60,  30, _MAGIC, _AP, 0.3, function() return spells[_E]:IsReady() end)
    DLib:RegisterDamageSource(_R, _MAGIC, 150, 75, _MAGIC, _AP, 0.7, function() return spells[_R]:IsReady() end)
    DLib:RegisterDamageSource(_PASIVE, _MAGIC, 0, 0, _MAGIC, _AP, 0.15, nil, function(target) return 10 + (player.level > 3 and (math.floor((player.level - 1) / 3) * 8) or 0) end)

    self.ballPos = player
    self.ballMoving = false

    self.ballCircles = {
        DM:CreateCircle(self.ballPos, 50, 5, { 255, 200, 0, 0 }):SetDrawCondition(function() return not self.ballMoving and (not self.ballPos.networkID or self.ballPos.networkID ~= player.networkID) end),
        DM:CreateCircle(self.ballPos, spellData[_W].width, 1, { 200, 200, 0, 255 }):SetDrawCondition(function() return not self.ballMoving and spells[_W]:IsReady() end),
        DM:CreateCircle(self.ballPos, spellData[_R].width, 1, { 255, 200, 0, 255 }):SetDrawCondition(function() return not self.ballMoving and spells[_R]:IsReady() end)
    }

    -- Auto update ball circles
    TickLimiter(function()
        for i = 1, #self.ballCircles do
            self.ballCircles[i].position = self.ballPos
        end
    end, 10)

    -- Used for initiator shielding
    self.lastSpellUsed = {}

    self.initiatorList = {
        ["Vi"]         = { { spellName = "ViQ",                  displayName = "Vi - Vault Breaker (Q)"           },
                           { spellName = "ViR",                  displayName = "Vi - Assault and Battery (R)"     } },
        ["Malphite"]   = { { spellName = "Landslide",            displayName = "Malphite - Unstoppable Force (R)" } },
        ["Nocturne"]   = { { spellName = "NocturneParanoia",     displayName = "Nocturne - Paranoia (R)"          } },
        ["Zac"]        = { { spellName = "ZacE",                 displayName = "Zac - Elastic Slingshot (E)"      } },
        ["MonkeyKing"] = { { spellName = "MonkeyKingNimbus",     displayName = "Wukong - Nimbus Strike (E)"       },
                           { spellName = "MonkeyKingSpinToWin",  displayName = "Wukong - Cyclone (R)"             },
                           { spellName = "SummonerFlash",        displayName = "Wukong - Flash"                   } },
        ["Shyvana"]    = { { spellName = "ShyvanaTransformCast", displayName = "Shyvana - Dragon\'s Descent (R)"  } },
        ["Thresh"]     = { { spellName = "threshqleap",          displayName = "Thresh - Death Leap (Q2)"         } },
        ["Aatrox"]     = { { spellName = "AatroxQ",              displayName = "Aatrox - Dark Flight (Q)"         } },
        ["Renekton"]   = { { spellName = "RenektonSliceAndDice", displayName = "Renekton - Slice & Dice (E)"      } },
        ["Kennen"]     = { { spellName = "KennenLightningRush",  displayName = "Kennen - Lightning Rush (E)"      },
                           { spellName = "SummonerFlash",        displayName = "Kennen - Flash"                   } },
        ["Olaf"]       = { { spellName = "OlafRagnarok",         displayName = "Olaf - Ragnarok (R)"              } },
        ["Udyr"]       = { { spellName = "UdyrBearStance",       displayName = "Udyr - Bear Stance (E)"           } },
        ["Volibear"]   = { { spellName = "VolibearQ",            displayName = "Volibear - Rolling Thunder (Q)"   } },
        ["Talon"]      = { { spellName = "TalonCutthroat",       displayName = "Talon - Cutthroat (E)"            } },
        ["JarvanIV"]   = { { spellName = "JarvanIVDragonStrike", displayName = "Jarvan IV - Dragon Strike (Q)"    } },
        ["Warwick"]    = { { spellName = "InfiniteDuress",       displayName = "Warwick - Infinite Duress (R)"    } },
        ["Jax"]        = { { spellName = "JaxLeapStrike",        displayName = "Jax - Leap Strike (Q)"            } },
        ["Yasuo"]      = { { spellName = "YasuoRKnockUpComboW",  displayName = "Yasuo - Last Breath (R)"          } },
        ["Diana"]      = { { spellName = "DianaTeleport",        displayName = "Diana - Lunar Rush (R)"           } },
        ["LeeSin"]     = { { spellName = "BlindMonkQTwo",        displayName = "Lee Sin - Resonating Strike (Q2)" } },
        ["Shen"]       = { { spellName = "ShenShadowDash",       displayName = "Shen - Shadow Dash (E)"           } },
        ["Alistar"]    = { { spellName = "Headbutt",             displayName = "Alistar - Headbutt (W)"           } },
        ["Amumu"]      = { { spellName = "BandageToss",          displayName = "Amumu - Bandage Toss (Q)"         } },
        ["Urgot"]      = { { spellName = "UrgotSwap2",           displayName = "Urgot - HK Position Reverser (R)" } },
        ["Rengar"]     = { { spellName = "RengarR",              displayName = "Rengar - Thrill of the Hunt (R)"  } },
        ["Katarina"]   = { { spellName = "KatarinaE",            displayName = "Katarina - Shunpo (E)"            } },
        ["Leona"]      = { { spellName = "LeonaZenithBlade",     displayName = "Leona - Zenith Blade (E)"         } },
        ["Maokai"]     = { { spellName = "MaokaiUnstableGrowth", displayName = "Maokai - Twisted Advance (W)"     } },
        ["XinZhao"]    = { { spellName = "XenZhaoSweep",         displayName = "Xin Zhao - Audacious Charge (E)"  } }
    }

    self.interruptList = {
        ["Katarina"] = "KatarinaR",
        ["Malzahar"] = "AlZaharNetherGrasp",
        ["Warwick"]  = "InfiniteDuress",
        ["Velkoz"]   = "VelkozR"
    }

    -- Precise packet hooks
    PacketHandler:HookOutgoingPacket(Packet.headers.S_CAST, function(p) self:OnCastSpell(p) end)

    -- Other helper values
    self.nearEnemyHeroes = false
    self.farRange = 1.3

end

-- Not working with Orianna, sorry guys :/
--[[function Orianna:GetSkins()
    return {
        "Classic",
        "Gothic",
        "Swen Chaos",
        "Bladecraft",
        "TPA"
    }
end]]

function Orianna:OnTick()

    -- Enemy check
    self.nearEnemyHeroes = CountEnemyHeroInRange(spells[_Q].range + spellData[_R].width)

    OW:EnableAttacks()
    OW:ForceTarget()

    -- Disable spellcasting attempts while ball is moving
    if self.ballMoving then skipCombo() return end

    -- Lane farm
    if menu.farm.freeze or menu.farm.lane then
        self:OnFarm()
    end
    
    -- Jungle farm
    if menu.jfarm.active then
        self:OnJungleFarm()
    end

    -- Auto E initiators
    if menu.misc.autoE.active and spells[_E]:IsReady() then
        for _, ally in ipairs(GetAllyHeroes()) do
            if _GetDistanceSqr(ally) < spells[_E].rangeSqr then
                local data = self.initiatorList[ally.charName]
                if data then
                    for _, spell in ipairs(data) do
                        if self.lastSpellUsed[ally.networkID] and menu.misc.autoE[spell.spellName .. self.lastSpellUsed[ally.networkID].spellName] and (os.clock() - self.lastSpellUsed[ally.networkID].time < 1.5) then
                            spells[_E]:Cast(ally)
                        end
                    end
                end
            end
        end
    end

    -- No checks when no enemies around
    if self.nearEnemyHeroes == 0 then return end

    -- Auto W
    if menu.misc.autoW > 1 and spells[_W]:IsReady() then
        local hitNum = self:GetEnemiesHitByW()
        if hitNum >= menu.misc.autoW - 1 then
            spells[_W]:Cast()
        end
    end
    
    -- Auto R
    if menu.misc.autoR > 1 and spells[_R]:IsReady() then
        local hitNum = self:GetEnemiesHitByR()
        if hitNum >= menu.misc.autoR - 1 and self:GetDistanceToClosestAlly(self.ballPos) < spells[_Q].rangeSqr * self.farRange then
            spells[_R]:Cast()
        end     
    end

    -- Auto R interrupt
    if menu.misc.interrupt then
        for _, enemy in ipairs(GetEnemyHeroes()) do
            for champion, spell in pairs(self.interruptList) do
                if _GetDistanceSqr(enemy) < spells[_Q].rangeSqr and self.lastSpellUsed[enemy.networkID] and spell == self.lastSpellUsed[enemy.networkID].spellName and (os.clock() - self.lastSpellUsed[enemy.networkID].time < 1) then
                    spells[_Q]:Cast(enemy.x, enemy.z)
                    if _GetDistanceSqr(self.ballPos, enemy) < spellData[_R].width ^ 2 then
                        spells[_R]:Cast()
                    end
                end
            end
        end
    end

    -- Harass toggle
    if not skip and not menu.harass.active and not menu.combo.active and menu.harass.toggle then
        self:OnHarass()
    end

end

function Orianna:OnCombo()

    -- Fighting a single target
    if self.nearEnemyHeroes == 1 then

        local target = STS:GetTarget(spells[_Q].range + spells[_Q].width)

        -- No target found, return
        if not target then return end

        -- Disable autoattacks due to danger or target being too close
        if ((_GetDistanceSqr(target) < 300 * 300) or ((player.health / player.maxHealth < 0.25) and (player.health / player.maxHealth < target.health / target.maxHealth))) then
            OW:DisableAttacks()
        end

        -- Cast Q
        if menu.combo.useQ and spells[_Q]:IsReady() then
            self:PredictCastQ(target)
        end

        -- Cast ult if target is killable
        if menu.combo.useR and spells[_R]:IsReady() and CountEnemyHeroInRange(1000, target) >= CountAllyHeroInRange(1000, target)  then
            if DLib:IsKillable(target, self.mainCombo) and GetDistanceToClosestAlly(self.ballPos) < spells[_Q].range * self.farRange then
                if self:GetEnemiesHitByR() >= menu.combo.numR then
                    spells[_R]:Cast()
                end
            end
        end

        -- Cast W if it will hit
        if menu.combo.useW and spells[_W]:IsReady() then
            if self:GetEnemiesHitByW() > 0 then
                spells[_W]:Cast()
            end
        end
        
        -- Cast E
        if menu.combo.useE and spells[_E]:IsReady() then
            -- Cast E on ally for gap closing
            for _, ally in ipairs(GetAllyHeroes()) do
                if ValidTarget(ally, spells[_E].range, false) and CountEnemyHeroInRange(400, ally) > 0 and _GetDistanceSqr(ally, target) < 400 * 400 then
                    spells[_E]:Cast(ally)
                    return
                end
            end
            -- Cast E on self for damaging target
            if self:GetEnemiesHitByE(player) > 0 then
                spells[_E]:Cast(player)
            end
        end

        if menu.combo.ignite and _IGNITE then
            local igniteTarget = STS:GetTarget(600)
            if igniteTarget and DLib:IsKillable(igniteTarget, self.mainCombo) then
                CastSpell(_IGNITE, igniteTarget)
            end
        end

    -- Fighting multiple targets
    elseif self.nearEnemyHeroes > 1 then

        local target = STS:GetTarget(spells[_Q].range + spells[_Q].width)

        -- No target found, return
        if not target then return end

        -- Disable attacks due to danger mode or target too close
        for _, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, 300) and (player.health / player.maxHealth < 0.25) then
                OW:DisableAttacks()
            end
        end

        -- Cast Q on best location
        if menu.combo.useQ and spells[_Q]:IsReady() then
            local castPosition, hitNum = self:GetBestPositionQ(target)
            
            if castPosition and hitNum > 1 then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
            else
                self:PredictCastQ(target)
            end
        end

        -- Cast R on best location
        if menu.combo.useR and spells[_R]:IsReady() then
            if CountEnemyHeroInRange(800, self.ballPos) > 1 then
                local hitNum, enemiesHit = self:GetEnemiesHitByR()
                local potentialKills, kills = 0, 0
                if hitNum >= 2 then
                    for _, enemy in ipairs(enemiesHit) do
                        if enemy.health - DLib:CalcComboDamage(enemy, self.mainCombo) < 0.4 * enemy.maxHealth or (DLib:CalcComboDamage(enemy, self.mainCombo) >= 0.4 * enemy.maxHealth) then
                            potentialKills = potentialKills + 1
                        end
                        if DLib:IsKillable(enemy, self.mainCombo) then
                            kills = kills + 1
                        end
                    end
                end
                if ((GetDistanceToClosestAlly(self.ballPos) < spells[_Q].range * self.farRange and hitNum >= CountEnemyHeroInRange(800, self.ballPos) or potentialKills > 1) or kills > 0) and hitNum >= menu.combo.numR then
                    spells[_R]:Cast()
                end
            elseif menu.combo.numR == 1 then
                if self:GetEnemiesHitByR() > 0 and DLib:IsKillable(target, {_Q, _W, _R}) and GetDistanceToClosestAlly(self.ballPos) < spells[_Q].range * self.farRange then
                    spells[_R]:Cast()
                end
            end
        end
        
        -- Cast W if it will hit
        if menu.combo.useW and spells[_W]:IsReady() then
            if self:GetEnemiesHitByW() > 0 then
                spells[_W]:Cast()
            end
        end

        -- Force the new target
        if OW:InRange(target) then
            OW:ForceTarget(target)
        end
        
        -- Cast E
        if menu.combo.useE and spells[_E]:IsReady() then
            -- Cast on self for damaging enemies
            if CountEnemyHeroInRange(800, self.ballPos) < 3 then
                if self:GetEnemiesHitByE(player) > 0 then
                    spells[_E]:Cast(player)
                    return
                end
            else
                if self:GetEnemiesHitByE(player) > 1 then
                    spells[_E]:Cast(player)
                    return
                end
            end
            -- Cast on allies for gap closing
            for _, ally in ipairs(GetAllyHeroes()) do
                if ValidTarget(ally, spells[_E].range, false) and CountEnemyHeroInRange(300, ally) > 2 and _GetDistanceSqr(ally, target) < 300 * 300 then
                    spells[_E]:Cast(ally)
                    return
                end
            end
        end

        if menu.combo.ignite and _IGNITE then
            local igniteTarget = STS:GetTarget(600)
            if igniteTarget and DLib:IsKillable(igniteTarget, self.mainCombo) then
                CastSpell(_IGNITE, igniteTarget)
            end
        end
    end

end

function Orianna:OnHarass()

    if menu.harass.mana > (player.mana / player.maxMana) * 100 then return end

    if menu.harass.useQ and spells[_Q]:IsReady() then
        self:PredictCastQ(STS:GetTarget(spells[_Q].range + spells[_Q].width))
    end

    if menu.harass.useW and spells[_W]:IsReady() then
        if self:GetEnemiesHitByW() > 0 then
            spells[_W]:Cast()
        end
    end

end

function Orianna:OnFarm()

    if menu.farm.mana > (player.mana / player.maxMana) * 100 then return end

    self.enemyMinions:update()

    local useQ = spells[_Q]:IsReady() and (menu.farm.lane and (menu.farm.useQ >= 3) or (menu.farm.useQ == 2))
    local useW = spells[_W]:IsReady() and (menu.farm.lane and (menu.farm.useW >= 3) or (menu.farm.useW == 2))
    local useE = spells[_E]:IsReady() and (menu.farm.lane and (menu.farm.useE >= 3) or (menu.farm.useE == 2))
    
    if useQ then
        if useW then
            local hitNum = 0
            local castPosition = 0
            for _, minion in ipairs(self.enemyMinions.objects) do
                if _GetDistanceSqr(minion) < spells[_Q].rangeSqr then
                    local minionPosition = GetPredictedPos(minion, spells[_Q].delay, spells[_Q].speed, self.ballPos)
                    local minionHits = CountObjectsNearPos(minion, nil, spellData[_W].width, self.enemyMinions.objects)
                    if minionHits >= hitNum then
                        hitNum = minionHits
                        castPosition = minionPosition
                    end
                end
            end
            if hitNum > 0 and castPosition then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
            end
        else
            for _, minion in ipairs(self.enemyMinions.objects) do
                if DLib:IsKillable(minion, {_Q}) and not OW:InRange(minion) then
                    local minionPosition = GetPredictedPos(minion, spells[_Q].delay, spells[_Q].speed, self.ballPos)
                    spells[_Q]:Cast(minionPosition.x, minionPosition.z)
                    break
                end
            end
        end
    end

    if useW then
        local minionHits = CountObjectsNearPos(self.ballPos, nil, spellData[_W].width, self.enemyMinions.objects)
        if minionHits >= 3 then
            spells[_W]:Cast()
        end
    end

    if useE and not useW then
        local minionHits = self:GetMinionsHitE()
        if minionHits >= 3 then
            spells[_E]:Cast(player)
        end
    end

end

function Orianna:OnJungleFarm()

    self.jungleMinions:update()

    local useQ = menu.jfarm.useQ and spells[_Q]:IsReady()
    local useW = menu.jfarm.useW and spells[_W]:IsReady()
    local useE = menu.jfarm.useE and spells[_E]:IsReady()
    
    local minion = self.jungleMinions.objects[1]
    
    if minion then
        if useQ then
            local position = GetPredictedPos(minion, spells[_Q].delay, spells[_Q].speed, self.ballPos)
            CastSpell(_Q, position.x, position.z)
        end
        
        if useW and _GetDistanceSqr(self.ballPos, minion) < spellData[_W].width ^ 2 then
            spells[_W]:Cast()
        end
        
        if useE and not useW and _GetDistanceSqr(minion) < 700 ^ 2 then
            local target = player
            local distance = _GetDistanceSqr(minion)
            for _, ally in ipairs(GetAllyHeroes()) do
                local dist = _GetDistanceSqr(ally, minion)
                if ValidTarget(ally, spells[_E].range, false) and dist < distance then
                    distance = dist
                    target = ally
                end
            end
            spells[_E]:Cast(target)
        end
    end

end

function Orianna:PredictCastQ(target)

    -- No target found, return
    if not target then return end

    -- Helpers
    local castPoint = nil

    spells[_Q]:SetSourcePosition(self.ballPos)
    spells[_Q]:SetRange(math.huge)
    local castPosition, hitChance, position = spells[_Q]:GetPrediction(target)
    spells[_Q]:SetRange(spellData[_Q].range)

    -- Update castPoint
    castPoint = castPosition

    -- Hitchance too low, return
    if hitChance < 2 then return end

    -- Main target out of range, getting new target
    if _GetDistanceSqr(position) > spells[_Q].rangeSqr + (spellData[_W].width + VP:GetHitBox(target)) ^ 2 then
        target2 = STS:GetTarget(spells[_Q].range + spellData[_W].width + 250, 2)
        if target2 then
            spells[_Q]:SetRange(math.huge)
            castPoint = spells[_Q]:GetPrediction(target2)
            spells[_Q]:SetRange(spellData[_Q].range)
        else return end
    end

    -- Second target out of range aswell, return
    if _GetDistanceSqr(position) > spells[_Q].rangeSqr + (spellData[_W].width + VP:GetHitBox(target)) ^ 2 then
        do return end
    end

    -- EQ calculation for faster Q on target, only if enabled in menu
    if spells[_E]:IsReady() and menu.misc.EQ ~= 0 then
        local travelTime = _GetDistanceSqr(self.ballPos, castPoint) / (spells[_Q].speed ^ 2)
        local minTravelTime = _GetDistanceSqr(castPoint) / (spells[_Q].speed ^ 2) + _GetDistanceSqr(self.ballPos) / (spells[_E].speed ^ 2)
        local target = player

        for _, ally in ipairs(GetAllyHeroes()) do
            if ally.networkID ~= player.networkID and ValidTarget(ally, spells[_E].range, false) then
                local time = _GetDistanceSqr(ally, castPoint) / (spells[_Q].speed ^ 2) + _GetDistanceSqr(ally, self.ballPos) / (spells[_E].speed ^ 2)
                if time < minTravelTime then
                    minTravelTime = time
                    target = ally
                end
            end
        end

        if minTravelTime < (menu.misc.EQ / 100) * travelTime and (not target.isMe or _GetDistanceSqr(self.ballPos) > 100 * 100) and _GetDistanceSqr(target) < _GetDistanceSqr(castPoint) then
            spells[_E]:Cast(target)
            return
        end
    end

    -- Cast point adjusting if it's slightly out of range
    if _GetDistanceSqr(castPoint) > spells[_Q].rangeSqr then
        castPoint = Vector(player.visionPos) + spells[_Q].range * (Vector(castPoint) - Vector(player.visionPos)):normalized()
    end

    -- Cast Q
    spells[_Q]:Cast(castPoint.x, castPoint.z)

end

function Orianna:GetBestPositionQ(target)

    local points = {}
    local targets = {}
    
    spells[_Q]:SetSourcePosition(self.ballPos)
    local castPosition, hitChance, position = spells[_Q]:GetPrediction(target)

    table.insert(points, position)
    table.insert(targets, target)
    
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, spells[_Q].range + spellData[_R].width) and enemy.networkID ~= target.networkID then
            castPosition, hitChance, position = spells[_Q]:GetPrediction(enemy)
            table.insert(points, position)
            table.insert(targets, enemy)
        end
    end
    
    for o = 1, 5 do
        local circle = MEC(points):Compute()
        
        if circle.radius <= spellData[_R].width and #points >= 3 and spells[_R]:IsReady() then
            return circle.center, 3
        end
    
        if circle.radius <= spellData[_W].width and #points >= 2 and spells[_W]:IsReady() then
            return circle.center, 2
        end
        
        if #points == 1 then
            return circle.center, 1
        elseif circle.radius <= spellData[_Q].radius and #points >= 1 then
            return circle.center, 2
        end
        
        local distance = -1
        local mainPoint = points[1]
        local index = 0
        
        for i = 2, #points do
            if _GetDistanceSqr(points[i], mainPoint) > distance then
                distance = _GetDistanceSqr(points[i], mainPoint)
                index = i
            end
        end
        if index > 0 then
            table.remove(points, index)
        end
    end

end

function Orianna:GetEnemiesHitByW()

    local enemies = {}
    for _, enemy in ipairs(GetEnemyHeroes()) do
        local position = GetPredictedPos(enemy, spellData[_W].delay)
        if ValidTarget(enemy) and _GetDistanceSqr(position, self.ballPos) < spellData[_W].width ^ 2 and _GetDistanceSqr(enemy, self.ballPos) < spellData[_W].width ^ 2 then
            table.insert(enemies, enemy)
        end
    end
    return #enemies, enemies

end

function Orianna:GetEnemiesHitByE(destination)

    local enemies = {}
    local sourcePoint = Vector(self.ballPos.x, 0, self.ballPos.z)
    local destPoint = Vector(destination.x, 0, destination.z)
    spells[_E].range = math.huge
    spells[_E].skillshotType = SKILLSHOT_LINEAR
    spells[_E]:SetSourcePosition(sourcePoint)
    for _, enemy in ipairs(GetEnemyHeroes()) do
        local _, _, position = spells[_E]:GetPrediction(enemy)
        if position then
            local pointInLine, _, isOnSegment = VectorPointProjectionOnLineSegment(sourcePoint, destPoint, position)
            if ValidTarget(enemy) and isOnSegment and _GetDistanceSqr(pointInLine, position) < (spells[_E].width + VP:GetHitBox(enemy)) ^ 2 and _GetDistanceSqr(pointInLine, enemy) < (spells[_E].width * 2 + 30) ^ 2 then
                table.insert(enemies, enemy)
            end
        end
    end
    spells[_E].skillshotType = nil
    spells[_E].range = spellData[_E].range
    return #enemies, enemies

end

function Orianna:GetEnemiesHitByR()

    local enemies = {}
    for _, enemy in ipairs(GetEnemyHeroes()) do
        local position = GetPredictedPos(enemy, spellData[_R].delay)
        if ValidTarget(enemy) and _GetDistanceSqr(position, self.ballPos) < spellData[_R].width ^ 2 and _GetDistanceSqr(enemy, self.ballPos) < (1.25 * spellData[_R].width) ^ 2  then
            table.insert(enemies, enemy)
        end
    end
    return #enemies, enemies

end

function Orianna:GetMinionsHitE()

    local minions = {}
    local sourcePoint = Vector(self.ballPos.x, 0, self.ballPos.z)
    local destPoint = Vector(player.x, 0, player.z)
    for _, minion in ipairs(self.enemyMinions.objects) do
        local position = Vector(minion.x, 0, minion.z)
        local pointInLine = VectorPointProjectionOnLineSegment(sourcePoint, destPoint, position)
        if _GetDistanceSqr(pointInLine, position) < spells[_E].width ^ 2 then
            table.insert(minions, minion)
        end
    end
    return #minions, minions

end

function Orianna:GetDistanceToClosestAlly(point)

    local distance = _GetDistanceSqr(point)
    for _, ally in ipairs(GetAllyHeroes()) do
        if ValidTarget(ally, math.huge, false) then
            local dist = _GetDistanceSqr(point, ally)
            if dist < distance then
                distance = dist
            end
        end
    end
    return distance

end

function Orianna:OnCreateObj(object)

    -- Validating
    if not object or not object.name then return end

    -- Ball to pos
    if object.name:lower():find("yomu_ring_green") then
        self.ballPos = Vector(object)
        self.ballMoving = false
    -- Ball to hero
    elseif object.name:lower():find("orianna_ball_flash_reverse") then
        self.ballPos = player
        self.ballMoving = false
    end

end

function Orianna:OnProcessSpell(unit, spell)

    -- Validating
    if not unit or not spell or not spell.name then return end

    if unit.isMe then
        -- Orianna Q
        if spell.name:lower():find("orianaizunacommand") then
            self.ballMoving = true
            DelayAction(function(p) self.ballPos = Vector(p) end, GetDistance(spell.endPos, self.ballPos) / spells[_Q].speed - GetLatency()/1000 - 0.35, { Vector(spell.endPos) })
        -- Orianna E
        elseif spell.name:lower():find("orianaredactcommand") and (not self.ballPos.networkID or self.ballPos.networkID ~= spell.target.networkID) then
            self.ballPos = spell.target
            self.ballMoving = true
        end
    end

    -- Initiator helper
    if unit.type == player.type and unit.team == player.team then
        self.lastSpellUsed[unit.networkID] = { spellName = spell.name, time = os.clock() }
        -- Instant shield
        if _GetDistanceSqr(unit) < spells[_E].rangeSqr then
            local data = self.initiatorList[unit.charName]
            if data then
                for _, spell in ipairs(data) do
                    if spell.spellName == spell.name then
                        spells[_E]:Cast(unit)
                    end
                end
            end
        end
    end

end

function Orianna:OnGainBuff(unit, buff)

    -- Validating
    if not unit or not unit.team or not buff or not buff.name then return end

    -- Ball applying to unit
    if unit.team == player.team and (buff.name:lower():find("orianaghostself") or buff.name:lower():find("orianaghost")) then
        self.ballPos = unit
        self.ballMoving = false
    end

end

function Orianna:OnCastSpell(p)

    if menu.misc.blockR then
        if Packet(p):get('spellId') == _R then
            if self:GetEnemiesHitByR() == 0 then
                p:Block()
            end
        end
    end

end

function Orianna:ApplyMenu()

    menu.combo:addParam("sep",    "",                        SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("useQ",   "Use Q",                   SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useW",   "Use W",                   SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useE",   "Use E",                   SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useR",   "Use R",                   SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("sep",    "",                        SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("numR",   "Use R on",                SCRIPT_PARAM_LIST, 1, { "1+ target", "2+ targets", "3+ targets", "4+ targets" , "5+ targets" })
    menu.combo:addParam("sep",    "",                        SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("ignite", "Use ignite",              SCRIPT_PARAM_ONOFF, true)

    menu.harass:addParam("toggle", "Harass toggle",            SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
    menu.harass:addParam("sep",    "",                         SCRIPT_PARAM_INFO, "")
    menu.harass:addParam("useQ",   "Use Q",                    SCRIPT_PARAM_ONOFF, true)
    menu.harass:addParam("useW",   "Use W",                    SCRIPT_PARAM_ONOFF, false)
    menu.harass:addParam("sep",    "",                         SCRIPT_PARAM_INFO, "")
    menu.harass:addParam("mana",   "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)

    menu:addSubMenu("Misc", "misc")
        menu.misc:addSubMenu("Auto E on initiators", "autoE")
        local added = false
        for _, ally in ipairs(GetAllyHeroes()) do
            local data = self.initiatorList[ally.charName]
            if data then
                for _, spell in ipairs(data) do
                    added = true
                    menu.misc.autoE:addParam(ally.charName..spell.spellName, spell.displayName, SCRIPT_PARAM_ONOFF, true)
                end
            end
        end
        if not added then
            menu.misc.autoE:addParam("info", "No supported initiators found!", SCRIPT_PARAM_INFO, "")
        else
            menu.misc.autoE:addParam("sep",    "",       SCRIPT_PARAM_INFO, "")
            menu.misc.autoE:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
        end
        menu.misc:addParam("autoW",     "Auto W on",                         SCRIPT_PARAM_LIST, 1, { "Nope", "1+ target", "2+ targets", "3+ targets", "4+ targets", "5+ targets" })
        menu.misc:addParam("autoR",     "Auto R on",                         SCRIPT_PARAM_LIST, 1, { "Nope", "1+ target", "2+ targets", "3+ targets", "4+ targets", "5+ targets" })
        menu.misc:addParam("EQ",        "Use E + Q if tEQ < %x * tQ",        SCRIPT_PARAM_SLICE, 100, 0, 200)
        menu.misc:addParam("interrupt", "Auto interrupt important spells",   SCRIPT_PARAM_ONOFF, true)
        menu.misc:addParam("blockR",    "Block R if it is not going to hit", SCRIPT_PARAM_ONOFF, true)

    menu:addSubMenu("Farm", "farm")
        menu.farm:addParam("freeze", "Farm Freezing",          SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        menu.farm:addParam("lane",   "Farm LaneClear",         SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("useQ",   "Use Q",                  SCRIPT_PARAM_LIST, 4, { "No", "Freeze", "LaneClear", "Both" })
        menu.farm:addParam("useW",   "Use W",                  SCRIPT_PARAM_LIST, 3, { "No", "Freeze", "LaneClear", "Both" })
        menu.farm:addParam("useE",   "Use E",                  SCRIPT_PARAM_LIST, 3, { "No", "Freeze", "LaneClear", "Both" })
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("mana",   "Don't farm if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)

    menu:addSubMenu("JungleFarm", "jfarm")
        menu.jfarm:addParam("active", "Farm!",                 SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.jfarm:addParam("sep",    "",                      SCRIPT_PARAM_INFO, "")
        menu.jfarm:addParam("useQ",   "Use Q",                 SCRIPT_PARAM_ONOFF, true)
        menu.jfarm:addParam("useW",   "Use W",                 SCRIPT_PARAM_ONOFF, true)
        menu.jfarm:addParam("useE",   "Use E",                 SCRIPT_PARAM_ONOFF, true)

    menu:addSubMenu("Drawing", "drawing")
        AAcircle:AddToMenu(menu.drawing,            "AA Range", false, true, true)
        circles[_Q]:AddToMenu(menu.drawing,         "Q range", true, true, true)
        self.ballCircles[2]:AddToMenu(menu.drawing, "W width", true, true, true)
        self.ballCircles[3]:AddToMenu(menu.drawing, "R width", true, true, true)
        self.ballCircles[1]:AddToMenu(menu.drawing, "Ball position", true, true, true)
        DLib:AddToMenu(menu.drawing, self.mainCombo)

end  
 
--[[
    ██╗  ██╗███████╗██████╗  █████╗ ████████╗██╗  ██╗
    ╚██╗██╔╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║  ██║
     ╚███╔╝ █████╗  ██████╔╝███████║   ██║   ███████║
     ██╔██╗ ██╔══╝  ██╔══██╗██╔══██║   ██║   ██╔══██║
    ██╔╝ ██╗███████╗██║  ██║██║  ██║   ██║   ██║  ██║
    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
]]

function Xerath:__init()

    spellData = {
        [_Q] = { range = 750, rangeMax = 1550, skillshotType = SKILLSHOT_LINEAR,   width = 100, delay = 0.7,  speed = math.huge, collision = false },
        [_W] = { range = 1100,                 skillshotType = SKILLSHOT_CIRCULAR, width = 200, delay = 0.7,  speed = math.huge, collision = false },
        [_E] = { range = 1050,                 skillshotType = SKILLSHOT_LINEAR,   width = 60,  delay = 0.25, speed = 1400,      collision = true  },
        [_R] = { range = {3200, 4400, 5600},   skillshotType = SKILLSHOT_CIRCULAR, width = 200, delay = 0.9,  speed = math.huge, collision = false },
    }
    initializeSpells()

    -- Finetune spells
    spells[_Q]:SetCharged("xeratharcanopulsechargeup", 3, spellData[_Q].rangeMax, 1.5, function() return spells[_Q]:GetCooldown(true) > 0 end)
    spells[_Q]:SetAOE(true)
    spells[_W]:SetAOE(true)
    spells[_R]:TrackCasting({"XerathLocusOfPower2", "xerathlocuspulse"})
    spells[_R]:RegisterCastCallback(function(spell) self:OnCastUlt(spell) end)

    -- Circle customization
    circles[_Q].color = { 255, 0x0F, 0x37, 0xFF }
    circles[_Q].width = 2
    circles[_W].color = { 255, 0x65, 0x05, 0xFF }
    circles[_W].width = 2
    circles[_E]:SetEnabled(false)
    circles[_R]:SetEnabled(false)

    -- Minions
    self.enemyMinions  = minionManager(MINION_ENEMY,  spellData[_Q].rangeMax, player, MINION_SORT_MAXHEALTH_DEC)
    self.jungleMinions = minionManager(MINION_JUNGLE, spellData[_Q].rangeMax, player, MINION_SORT_MAXHEALTH_DEC)

    self.ultData = {
        mode           = 0,
        castTime       = 0,
        lastChargeTime = 0,
        chargesUsed    = 0,
        waitTime       = 0,
        currentTarget  = nil,
        allPressTime   = 0,
        tapPressTime   = 0,
    }

    self.lastPing = 0

    self.passiveUp = HasBuff(player, "xerathascended2onhit")

    self.ultCombo = { _R, _R, _R }
    self.mainCombo = { _IGNITE, _Q, _W, _E, _R, _R, _R }

    --Register damage sources
    DLib:RegisterDamageSource(_Q, _MAGIC, 40,  40, _MAGIC, _AP, 0.75, function() return spells[_Q]:IsReady() end)
    DLib:RegisterDamageSource(_W, _MAGIC, 30,  30, _MAGIC, _AP, 0.6,  function() return spells[_W]:IsReady() end)
    DLib:RegisterDamageSource(_E, _MAGIC, 50,  30, _MAGIC, _AP, 0.45, function() return spells[_E]:IsReady() end)
    DLib:RegisterDamageSource(_R, _MAGIC, 135, 55, _MAGIC, _AP, 0.43, function() return spells[_R]:IsReady() end)

    TickLimiter(function()
        -- Update R range
        spells[_R]:SetRange(spellData[_R].range[math.max(spells[_R]:GetLevel(), 1)])
        -- Reset ult values
        if not self:IsCastingUlt() then
            self.ultData.mode           = 0
            self.ultData.castTime       = 0
            self.ultData.lastChargeTime = 0
            self.ultData.chargesUsed    = 0
            self.ultData.waitTime       = 0
            self.ultData.currentTarget  = nil
        end
    end, 1)

    PacketHandler:HookOutgoingPacket(Packet.headers.S_MOVE, function(p) self:OnSendMove(p) end)

end

function Xerath:GetSkins()
    return {
        "Classic",
        "Runeborn",
        "Battlecast",
        "Scorched Earth"
    }
end

function Xerath:OnCombo()

    local targets = {
        [_Q] = STS:GetTarget(spellData[_Q].rangeMax),
        [_W] = STS:GetTarget(spells[_W].range + spells[_W].width),
        [_E] = STS:GetTarget(menu.combo.rangeE)
    }

    local AAtarget = OW:GetTarget()
    OW:DisableAttacks()

    -- AA only when passive up or enemy health below 200
    if (AAtarget and AAtarget.health < menu.aa) or self.passiveUp then
        OW:EnableAttacks()
    end

    if spells[_Q]:IsReady() and targets[_Q] and menu.combo.useQ then
        if spells[_Q]:IsCharging() then
            local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(targets[_Q])
            if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
            end
        else
            spells[_Q]:Charge()
        end
    end

    if spells[_W]:IsReady() and targets[_W] and menu.combo.useW then
        if menu.misc.centerW then
            spells[_W].width = 50
        else
            spells[_W].width = spellData[_W].width
        end
        local property = VP.ShotAtMaxRange
        VP.ShotAtMaxRange = menu.misc.maxRangeW
        spells[_W]:Cast(targets[_W])
        VP.ShotAtMaxRange = property
    end

    if spells[_E]:IsReady() and targets[_E] and menu.combo.useE then
        spells[_E]:Cast(targets[_E])
    end

end

function Xerath:OnHarass()

    -- Don't harass when Q not ready
    if not spells[_Q]:IsReady() or not menu.harass.useQ then return end

    -- Don't harass on not enough mana
    if (player.mana / player.maxMana * 100) < menu.harass.mana then return end

    local target = STS:GetTarget(spellData[_Q].rangeMax)

    if target then
        if spells[_Q]:IsCharging() then
            local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(target)
            if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
            end
        else
            spells[_Q]:Charge()
        end
    end

end

function Xerath:OnFarm()

    local minionsUpdated = false

    if menu.farm.useQ and spells[_Q]:IsReady() then

        -- Save performance, update minions within here
        self.enemyMinions:update()
        minionsUpdated = true

        if not spells[_Q]:IsCharging() then
            if #self.enemyMinions.objects > 1 then
                spells[_Q]:Charge()
            end
        else
            local maxRange = spells[_Q].range == spellData[_Q].rangeMax
            local continue = maxRange
            local minions  = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) and _GetDistanceSqr(t) < spells[_Q].rangeSqr end)
            if not maxRange then
                local maxRangeMinions = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) and _GetDistanceSqr(t) < math.pow(spellData[_Q].rangeMax, 2) end)
                continue = #maxRangeMinions == #minions
            end
            if continue then
                minions = GetPredictedPositionsTable(VP, minions, spells[_Q].delay, spells[_Q].width, spells[_Q].range, math.huge, player, false)
                local castPosition = GetBestLineFarmPosition(spells[_Q].range, spells[_Q].width, minions)
                if castPosition then
                    spells[_Q]:Cast(castPosition.x, castPosition.z)
                end
            end
        end
    end

    if menu.farm.useW and spells[_W]:IsReady() then

        -- Update minions
        if not minionsUpdated then self.enemyMinions:update() end

        local casted = false
        local casterMinions = SelectUnits(self.enemyMinions.objects, function(t) return (t.charName:lower():find("wizard") or t.charName:lower():find("caster")) and ValidTarget(t) and _GetDistanceSqr(t) < spells[_W].rangeSqr end)
        
        -- Caster minions
        if #casterMinions > 1 then
            casterMinions = GetPredictedPositionsTable(VP, casterMinions, spells[_W].delay, spells[_W].width, spells[_W].range + spells[_W].width, math.huge, player, false)
            local castPosition, hitNumber = GetBestCircularFarmPosition(spells[_W].range + spells[_W].width, spells[_W].width, casterMinions)
            if castPosition and hitNumber > 1 then
                spells[_W]:Cast(castPosition.x, castPosition.z)
                casted = true
            end
        end

        -- ALl minions
        if not casted then
            local minions = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) and _GetDistanceSqr(t) < spells[_E].rangeSqr end)
            -- Don't waste W on 1 minion
            if #minions > 1 then
                minions = GetPredictedPositionsTable(VP, minions, spells[_W].delay, spells[_W].width, spells[_W].range + spells[_W].width, math.huge, player, false)
                castPosition, hitNumber = GetBestCircularFarmPosition(spells[_W].range + spells[_W].width, spells[_W].width, minions)
                if castPosition and hitNumber > 1 then
                    spells[_W]:Cast(castPosition.x, castPosition.z)
                end
            end
        end
    end

end

function Xerath:OnJungleFarm()

    self.jungleMinions:update()

    if #self.jungleMinions.objects > 0 then
        if menu.jfarm.useQ and spells[_Q]:IsReady() then
            if not spells[_Q]:IsCharging() then
                spells[_Q]:Charge()
            end
            if _GetDistanceSqr(self.jungleMinions.objects[1]) <= spells[_Q].rangeSqr then
                spells[_Q]:Cast(self.jungleMinions.objects[1].x, self.jungleMinions.objects[1].z)
            end
        end

        if menu.jfarm.useW and spells[_W]:IsReady() then
            spells[_W]:Cast(self.jungleMinions.objects[1].x, self.jungleMinions.objects[1].z)
        end
    end

end

function Xerath:OnTargetGapclosing(unit, spell)
    if spells[_E]:IsReady() then
        spells[_E]:Cast(unit)
    end
end

function Xerath:OnTick()

    -- Ping alert snipeable
    if menu.snipe.alerter.ping and spells[_R]:IsReady() and (os.clock() - self.lastPing > 30) then
        for _, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, spells[_R].range) and DLib:IsKillable(enemy, self.ultCombo) then
                for i = 1, 3 do
                    DelayAction(PingClient,  1000 * 0.3 * i/1000, { enemy.x, enemy.z })
                end
                self.lastPing = os.clock()
                break
            end
        end
    end

    OW:EnableAttacks()

    -- Handle ult casting
    if self:IsCastingUlt() then
        OW:DisableAttacks()
        skipCombo()
        self:HandleUlt()
        return
    end

    -- Single cast E
    if menu.combo.castE and spells[_E]:IsReady() then
        local target = STS:GetTarget(spells[_E].range)
        if target then
            spells[_E]:Cast(target)
        end
    end

    if not menu.combo.active then
        -- Farming
        if menu.farm.active and ((player.mana / player.maxMana * 100) >= menu.farm.mana or spells[_Q]:IsCharging()) then
            self:OnFarm()
        end
        -- Jungle farming
        if menu.jfarm.active then
            self:OnJungleFarm()
        end
    end

    if menu.misc.autoEDashing then
        for _, target in ipairs(SelectUnits(GetEnemyHeroes(), function(t) return ValidTarget(t, spells[_E].range * 1.5) end)) do
            spells[_E]:CastIfDashing(target)
        end
    end

    if menu.misc.autoEImmobile then
        for _, target in ipairs(SelectUnits(GetEnemyHeroes(), function(t) return ValidTarget(t, spells[_E].range * 1.5) end)) do
            spells[_E]:CastIfDashing(target)
        end
    end

end

function Xerath:GetBestUltTarget()

    local target = nil
    -- Near mouse (1000)
    if menu.snipe.targetMode == 1 then
        target = STS:GetTarget(1000, 1, STS_NEARMOUSE)
        if target and _GetDistanceSqr(target) > spells[_R].rangeSqr then target = nil end
        if target == nil then
            -- Forced best target
            target = getBestTarget(spells[_R].range)
        end
    -- Most killable
    else
        target = getBestTarget(spells[_R].range)
    end
    return target

end

function Xerath:HandleUlt()

    -- Decide mode
    if self.ultData.mode == 0 then
        if os.clock() - self.ultData.allPressTime < 0.5 then
            -- Use all charges
            self.ultData.mode = 1
        elseif os.clock() - self.ultData.tapPressTime < 0.5 then
            -- Use one charge
            self.ultData.mode = 2
        end
        -- Still no mode (maybe tap?), returning
        if self.ultData.mode == 0 then return end
    end

    -- Check if target is about to die
    if self.ultData.mode == 1 then
        if self.ultData.waitTime ~= 0 then
            if os.clock() - self.ultData.waitTime > 0 then
                self.ultData.waitTime = 0
            else
                return -- Wait, target might die
            end
        end
    -- Check if tap key was pressed on tap mode
    elseif self.ultData.mode == 2 then
        if os.clock() - self.ultData.tapPressTime < 0.5 then
            self.ultData.tapPressTime = 0
        else
            return
        end
    end

    -- Get best target available
    if self.ultData.currentTarget == nil then self.ultData.currentTarget = self:GetBestUltTarget() end

    -- No target found
    if self.ultData.currentTarget == nil then return end

    -- Target changing
    if not ValidTarget(self.ultData.currentTarget) then
        -- Switch target
        local newTarget = self:GetBestUltTarget()
        if newTarget and (not menu.snipe.advanced.delay or (os.clock() - self.ultData.lastChargeTime) > GetDistance(newTarget, self.ultData.currentTarget) / 5000) then
            self.ultData.currentTarget = newTarget
            -- Still no target, wait longer...
            if self.ultData.currentTarget == nil then return end
        -- Wait, target might appear
        else
            -- TODO: FoW shooting to last known location
            return
        end
    end

    -- Cast the charge
    spells[_R].packetCast = menu.snipe.advanced.packets
    spells[_R]:Cast(self.ultData.currentTarget)

end

function Xerath:OnCastUlt(spell)

    -- Initializing
    if spell.name == "XerathLocusOfPower2" then
        self.ultData.castTime    = os.clock()
        self.ultData.chargesUsed = 0
    end
    -- Using charge
    if spell.name == "xerathlocuspulse" then
        self.ultData.chargesUsed    = self.ultData.chargesUsed + 1
        self.ultData.lastChargeTime = os.clock()

        -- Predicted death on mode 1
        if self.ultData.waitTime == 0 and self.ultData.mode == 1 and self.ultData.currentTarget then
            if DLib:IsKillable(self.ultData.currentTarget, { _R }) then
                self.ultData.waitTime = os.clock() + spells[_R].delay
            end
        end

        -- Ult finished
        if self.ultData.chargesUsed == 3 then
            self.ultData.castTime    = 0
            self.ultData.chargesUsed = 0
        end
    end

end

function Xerath:IsCastingUlt()
    return ((os.clock() - self.ultData.castTime) < 10 and (spells[_R]:GetCooldown(true) < 10))
end

function Xerath:OnSendMove(p)
    
    -- Block auto-attack while charging
    if spells[_Q]:IsCharging() then
        local packet = Packet(p)
        if packet:get("type") ~= 2 then
            Packet('S_MOVE', { x = mousePos.x, y = mousePos.z }):send()
            p:Block()
        end
    -- Block moving while casting R
    elseif self:IsCastingUlt() then
        p:Block()
    end

end

function Xerath:OnWndMsg(msg, key)
    if msg == 256 then
        if key == menu.snipe._param[self.tapMenu].key then
            self.ultData.tapPressTime = os.clock()
        elseif key == menu.snipe._param[self.allMenu].key then
            self.ultData.allPressTime = os.clock()
        end
    end
end

function Xerath:OnGainBuff(unit, buff) 
    if unit and unit.isMe and buff and buff.name == "xerathascended2onhit" then
        self.passiveUp = true
    end
end

function Xerath:OnLoseBuff(unit, buff)
    if unit and unit.isMe and buff and buff.name then
        if buff.name == "xerathascended2onhit" then
            self.passiveUp = false
        end
        if buff.name == "xerathrshots" then
            self.ultData.castTime = 0
        end
    end
end

function Xerath:OnDraw()

    -- Snipe text
    if menu.snipe.alerter.print and spells[_R]:GetLevel() > 0 then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, spells[_R].range) and DLib:IsKillable(enemy, self.ultCombo) then
                local pos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
                DrawText("Snipe!", 17, pos.x, pos.y, ARGB(255,0,255,0))
            end
        end
    end

end

function Xerath:ApplyMenu()

    -- Combo
    menu.combo:addParam("sep",    "",        SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("useQ",   "Use Q",   SCRIPT_PARAM_ONOFF , true)
    menu.combo:addParam("useW",   "Use W",   SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useE",   "Use E",   SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("sep",    "",        SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("rangeE", "E range", SCRIPT_PARAM_SLICE, spells[_E].range, 50, spells[_E].range, 1)
    menu.combo:addParam("castE",  "Use E!",  SCRIPT_PARAM_ONKEYDOWN, false, string.byte("O"))
    
    -- Harass
    menu.harass:addParam("sep",  "",                         SCRIPT_PARAM_INFO, "")
    menu.harass:addParam("useQ", "Use Q",                    SCRIPT_PARAM_ONOFF , true)
    menu.harass:addParam("mana", "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 10, 0, 100)
    
    -- R-Snipe
    menu:addSubMenu("R-Snipe", "snipe")
        menu.snipe:addSubMenu("Alerter", "alerter")
            menu.snipe.alerter:addParam("print", "Draw \"Snipe\" on killable enemies", SCRIPT_PARAM_ONOFF , true)
            menu.snipe.alerter:addParam("ping",  "Ping if an enemy is killable",       SCRIPT_PARAM_ONOFF , true)
        menu.snipe:addSubMenu("Advanced", "advanced")
            menu.snipe.advanced:addParam("delay",   "Wait before changing target",     SCRIPT_PARAM_ONOFF, true)
            menu.snipe.advanced:addParam("packets", "Use packet casting",              SCRIPT_PARAM_ONOFF, false)
        menu.snipe:addParam("sep",        "",                   SCRIPT_PARAM_INFO, "")
        menu.snipe:addParam("auto",       "Use all charges",    SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
        self.allMenu = #menu.snipe._param
        menu.snipe:addParam("tap",        "Use 1 charge (tap)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        self.tapMenu = #menu.snipe._param
        menu.snipe:addParam("jsteal",     "Jungle Steal",       SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))
        menu.snipe:addParam("sep",        "",                   SCRIPT_PARAM_INFO, "")
        menu.snipe:addParam("targetMode", "Targetting mode: ",  SCRIPT_PARAM_LIST, 2, { "Near mouse (1000)", "Most killable" })

    -- Farming
    menu:addSubMenu("Farming", "farm")
        menu.farm:addParam("active", "Farming active",         SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("useQ",   "Use Q",                  SCRIPT_PARAM_ONOFF, true)
        menu.farm:addParam("useW",   "Use W",                  SCRIPT_PARAM_ONOFF, false)
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("mana",   "Don't farm if mana < %", SCRIPT_PARAM_SLICE, 10, 0, 100)
    
    -- Jungle farming
    menu:addSubMenu("Jungle-Farming", "jfarm")
        menu.jfarm:addParam("active", "Jungle-Farming active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.jfarm:addParam("sep",    "",                      SCRIPT_PARAM_INFO, "")
        menu.jfarm:addParam("useQ",   "Use Q",                 SCRIPT_PARAM_ONOFF, true)
        menu.jfarm:addParam("useW",   "Use W",                 SCRIPT_PARAM_ONOFF, true)

    -- Misc
    menu:addSubMenu("Misc", "misc")
        menu.misc:addSubMenu("Anti-Gapclosers", "AG")
            AntiGapcloser(menu.misc.AG, self.OnTargetGapclosing)
        menu.misc:addParam("centerW",       "Cast W centered",            SCRIPT_PARAM_ONOFF, false)
        menu.misc:addParam("maxRangeW",     "Cast W at max range",        SCRIPT_PARAM_ONOFF, false)
        menu.misc:addParam("autoEDashing",  "Auto E on dashing enemies",  SCRIPT_PARAM_ONOFF, true)
        menu.misc:addParam("autoEImmobile", "Auto E on immobile enemies", SCRIPT_PARAM_ONOFF, true)

    -- Drawing
    menu:addSubMenu("Drawing", "drawing")
        AAcircle:AddToMenu(menu.drawing, "AA Range", false, true, true)
        DM:CreateCircle(player, spellData[_Q].rangeMax, 2, { 150, 0x0F, 0x37, 0xFF }):AddToMenu(menu.drawing, "Q Range (max)", true, true, true)
        for spell, circle in pairs(circles) do
            circle:AddToMenu(menu.drawing, SpellToString(spell).." Range", true, true, true)
        end
        DM:CreateCircle(player, 1337):LinkWithSpell(spells[_R]):SetMinimap():AddToMenu(menu.drawing, "R Range (minimap)", true, true, true)
        DLib:AddToMenu(menu.drawing, self.mainCombo)

    -- General
    menu:addParam("sep", "",                          SCRIPT_PARAM_INFO, "")
    menu:addParam("aa",  "Don't AA when enemy above", SCRIPT_PARAM_SLICE, 200, 100, 1000, 1)

end  
 
-- Copyright (c) 2014 - Hellsing


--UPDATEURL=
--HASH=1A7478DA5019E80B5DA3BEF6DE61804B
