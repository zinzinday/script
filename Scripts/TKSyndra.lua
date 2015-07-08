--[[

  _______            _  __    _       _____                 _           
 |__   __|          | |/ /   | |     / ____|               | |          
    | | ___  _ __   | ' / ___| | __ | (___  _   _ _ __   __| |_ __ __ _ 
    | |/ _ \| '_ \  |  < / _ \ |/ /  \___ \| | | | '_ \ / _` | '__/ _` |
    | | (_) | |_) | | . \  __/   <   ____) | |_| | | | | (_| | | | (_| |
    |_|\___/| .__/  |_|\_\___|_|\_\ |_____/ \__, |_| |_|\__,_|_|  \__,_|
            | |                              __/ |                      
            |_|                             |___/                       
]]--

--[[ Auto updater start ]]--
local version = 0.02
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/nebelwolfi/BoL/master/TKSyndra.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."TKSyndra.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>[Top Kek Series]: Syndra - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/nebelwolfi/BoL/master/TKSyndra.version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(version) < ServerVersion then
        AutoupdaterMsg("New version available v"..ServerVersion)
        AutoupdaterMsg("Updating, please don't press F9")
        DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
      else
        AutoupdaterMsg("Loaded the latest version (v"..ServerVersion..")")
      end
    end
  else
    AutoupdaterMsg("Error downloading version info")
  end
end
--[[ Auto updater end ]]--

--[[ Libraries start ]]--
local predToUse = {}
VP = nil
DP = nil
HP = nil
if FileExist(LIB_PATH .. "/VPrediction.lua") then
  require("VPrediction")
  VP = VPrediction()
  table.insert(predToUse, "VPrediction")
end

if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then
  require "DivinePred"
  DP = DivinePred() 
  table.insert(predToUse, "DivinePred")
end

if FileExist(LIB_PATH .. "/HPrediction.lua") then
  require("HPrediction")
  HP = HPrediction()
  table.insert(predToUse, "HPrediction")
end

require("SourceLib")
--[[ Libraries end ]]--

--[[ Skill list start ]]--
local Q = {range = 790, rangeSqr = math.pow(790, 2), width = 125, delay = 0.6, speed = math.huge, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, type = "circular"}
local W = {range = 925, rangeSqr = math.pow(925, 2), width = 190, delay = 0.8, speed = math.huge, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_W) == READY end, status = 0, type = "cone"}
local E = {range = 730, rangeSqr = math.pow(730, 2), width = 45 * 0.5, delay = 0.25, speed = 2500, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_E) == READY end, type = "circular"}
local R = {range = 725, rangeSqr = math.pow(725, 2), delay = 0.25, IsReady = function() return myHero:CanUseSpell(_R) == READY end, type = "targeted"}
local QE = {range = 1280, rangeSqr = math.pow(1280, 2), width = 60, delay = 0, speed = 1600}
--[[ Skill list end ]]--

local debugMode = false
local Balls = {}
local BallDuration = 6.9
EnemyMinions = minionManager(MINION_ENEMY, W.range, myHero, MINION_SORT_MAXHEALTH_DEC)
JungleMinions = minionManager(MINION_JUNGLE, QE.range, myHero, MINION_SORT_MAXHEALTH_DEC)
PosiblePets = minionManager(MINION_OTHER, W.range, myHero, MINION_SORT_MAXHEALTH_DEC)

function OnLoad()
  Config = scriptConfig("Top Kek Syndra", "TKSyndra")
  Config:addSubMenu("Settings", "misc")
  Config.misc:addParam("pc", "Use Packets To Cast Spells", SCRIPT_PARAM_ONOFF, false)
  Config.misc:addParam("qqq", " ", SCRIPT_PARAM_INFO,"")
 
  if predToUse == {} then PrintChat("PLEASE DOWNLOAD A PREDICTION!") return end
  Config.misc:addParam("qqq", "RELOAD AFTER CHANGING PREDICTIONS! (2x F9)", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("pro",  "Type of prediction", SCRIPT_PARAM_LIST, 1, predToUse)

  Config:addSubMenu("Misc", "casual")
  Config.casual:addSubMenu("Anti-Gapclosers", "AG")
  AntiGapcloser(Config.casual.AG, OnGapclose)
  Config.casual:addSubMenu("Zhonya's settings", "zhg")
  Config.casual.zhg:addParam("enabled", "Use Auto Zhonya's", SCRIPT_PARAM_ONOFF, true)
  Config.casual.zhg:addParam("zhonyapls", "Min. % health for Zhonya's", SCRIPT_PARAM_SLICE, 15, 1, 50, 0)

  if ActivePred() == "HPrediction" then SetupHPred() end

  Config:addSubMenu("Keys", "key")
  Config.key:addParam("combo", "Combo (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Config.key:addParam("stun", "Stun target", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
  Config.key:addParam("har", "Harrass (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  Config.key:addParam("harr", "Harrass (TOGGLE)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))

  Config.key:permaShow("combo")
  Config.key:permaShow("stun")
  Config.key:permaShow("har")
  Config.key:permaShow("harr")

  sts = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
  Config:addSubMenu("Set Target Selector Priority", "sts")
  sts:AddToMenu(Config.sts)
end

function OnTick()
  Target = sts:GetTarget(1500)--GetCustomTarget()
  BTOnTick()
  zhg()
  if myHero.dead or recall then return end
  if Config.key.combo then 
    myHero:MoveTo(mousePos.x, mousePos.z)
    Combo()
  elseif Config.key.har or Config.key.harr then 
    --Harrass()
  elseif Config.key.stun then
    if Target and ValidTarget(Target, QE.range) and E.IsReady() and Q.IsReady() then
      if debugMode then PrintChat("Attempting to QE Target") end
      DoEQCombo(Target)
    end
  end
end

function Combo()
  if myHero.dead then return end
  if Target == nil then return end
  local Qtarget
  local QEtarget
  local Rtarget
  Qtarget = sts:GetTarget(W.range)
  QEtarget = sts:GetTarget(QE.range)
  Rtarget = sts:GetTarget(R.range)

  local DFGUsed = false

  if W.IsReady() and Qtarget and W.status == 1 and (os.clock() - Q.LastCastTime > 0.25) and (os.clock() - E.LastCastTime > (QE.range / QE.speed) +  (0.6 - (QE.range / QE.speed))) then
    if ActivePred() == "VPrediction" then
      local CastPosition, HitChance, Position = VPredict(Qtarget, E)
      if HitChance >= 2 then
        CastSpell(_W, CastPosition.x, CastPosition.z)
      end
    elseif ActivePred() == "DivinePred" then
      local State, Position, perc = DPredict(Qtarget, E)
      if State == SkillShot.STATUS.SUCCESS_HIT then 
        CastSpell(_W, Position.x, Position.z)
      end
    elseif ActivePred() == "HPrediction" then
      local Position, HitChance = HPredict(Qtarget, "W")
      if HitChance >= Config.misc.hitchance then 
        CastSpell(_W, Position.x, Position.z)
      end
    end
    if debugMode then PrintChat("Casted W on target") end
  end
  if (Qtarget or QEtarget) and E.IsReady() and Q.IsReady() then
    if Qtarget then
      DoEQCombo(Qtarget)
    else
      DoEQCombo(QEtarget)
    end   
  end
  if Q.IsReady() then
    if Qtarget and os.clock() - W.LastCastTime > 0.25 and os.clock() - E.LastCastTime > 0.25 then
      if ActivePred() == "VPrediction" then
        local CastPosition, HitChance, Position = VPredict(Qtarget, E)
        if HitChance >= 2 then
          CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
      elseif ActivePred() == "DivinePred" then
        local State, Position, perc = DPredict(Qtarget, E)
        if State == SkillShot.STATUS.SUCCESS_HIT then 
          CastSpell(_Q, Position.x, Position.z)
        end
      elseif ActivePred() == "HPrediction" then
        local Position, HitChance = HPredict(Qtarget, "W")
        if HitChance >= 2 then 
          CastSpell(_Q, Position.x, Position.z)
        end
      end
      if debugMode then PrintChat("Casted Q on target") end
    end
  end
  if E.IsReady() then
    if Qtarget and GetDistanceSqr(Qtarget, myHero.visionPos) < E.rangeSqr then
      CastSpell(_E, Qtarget.x, Qtarget.z)
      if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on target") end
    end
    local validballs = GetValidBalls(true)
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) then
        for i, ball in ipairs(validballs) do
          if GetDistanceSqr(ball.object, myHero.visionPos) < E.rangeSqr then
            local enemyPos, hitchance
            if ActivePred() == "VPrediction" then
              local enemyPos, hitchance, Position = VPredict(Qtarget, E)
            elseif ActivePred() == "DivinePred" then
              local State, Position, perc = DPredict(Qtarget, E)
              hitchance = perc*3/100
            elseif ActivePred() == "HPrediction" then
              local enemyPos, hitchance = HPredict(Qtarget, "W")
            end
            if hitchance >= 2 and enemyPos and enemyPos.z then       
              local EP = Vector(ball.object) +  (100+(-0.6 * GetDistance(ball.object, myHero.visionPos) + 966)) * (Vector(ball.object) - Vector(myHero.visionPos)):normalized()
              local SP = Vector(ball.object) - 100 * (Vector(ball.object) - Vector(myHero.visionPos)):normalized()
              local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(SP, EP, enemyPos)
              if isOnSegment and GetDistanceSqr(pointLine, enemyPos) <= (QE.width + VP:GetHitBox(enemy))^2 then
                CastSpell(_E, ball.object.x, ball.object.z)
                if debugMode then PrintChat("Casted E on ball") end
              end
            end
          end
        end
      end
    end
  end
  if W.IsReady() then
    if Qtarget and W.status == 0 and (os.clock() - E.LastCastTime > 0.7) and (os.clock() - Q.LastCastTime > 0.7) then
      local validball = GetWValidBall()
      if validball then
        DelayAction(function() CastSpell(_W, validball.object.x, validball.object.z) end, 0.2)
        W.status = 1
        if debugMode then PrintChat("Picked up ball with W") end
      end
    end
  end
  if not Q.IsReady() and not W.IsReady() then
    if Qtarget or Rtarget then
      if Qtarget and GetDistanceSqr(Qtarget.visionPos, myHero.visionPos) < R.rangeSqr then
        ItemManager:CastOffensiveItems(Qtarget)
        if _SpellIGNITE and GetDistanceSqr(Qtarget.visionPos, myHero.visionPos) < 600 * 600 then
          CastSpell(_SpellIGNITE, Qtarget)
        end
        CastSpell(_R, Qtarget)
        if debugMode then PrintChat("Casted R on target") end
      elseif Rtarget and GetDistanceSqr(Rtarget.visionPos, myHero.visionPos) < R.rangeSqr then
        ItemManager:CastOffensiveItems(Rtarget)
        if _SpellIGNITE and GetDistanceSqr(Rtarget.visionPos, myHero.visionPos) < 600 * 600 then
          CastSpell(_SpellIGNITE, Rtarget)
        end
        CastSpell(_R, Rtarget)
        if debugMode then PrintChat("Casted R on target") end
      end
    end
  end
end

function DoEQCombo(Target) 
  if ValidTarget(Target, Q.range) then
      if ActivePred() == "VPrediction" then
        local CastPosition, HitChance, Position = VPredict(Target, Q)
        if HitChance >= 2 then
          CCastSpell(_Q, CastPosition.x, CastPosition.z)     
          DelayAction(function() CCastSpell(_E, CastPosition.x, CastPosition.z) end, 0.25)
        end
      elseif ActivePred() == "DivinePred" then
        local State, Position, perc = DPredict(unit, Q)
        if State == SkillShot.STATUS.SUCCESS_HIT then 
          CCastSpell(_Q, Position.x, Position.z)     
          DelayAction(function() CCastSpell(_E, Position.x, Position.z) end, 0.25)
        end
      elseif ActivePred() == "HPrediction" then
        local Position, HitChance = HPredict(Target, "Q")
        if HitChance >= Config.misc.hitchance then 
          CCastSpell(_Q, Position.x, Position.z)     
          DelayAction(function() CCastSpell(_E, Position.x, Position.z) end, 0.25)
        end
      end
    else
      QPos = myHero+(Vector(Target)-myHero):normalized()*700
      CCastSpell(_Q, QPos.x, QPos.z)
      if ActivePred() == "VPrediction" then
        local CastPosition, HitChance, Position = VPredict(Target, W)
        DelayAction(function() CCastSpell(_E, CastPosition.x, CastPosition.z) end, 0.25)
      elseif ActivePred() == "DivinePred" and ValidRequest() then
        local State, Position, perc = DPredict(unit, E)
        DelayAction(function() CCastSpell(_E, Position.x, Position.z) end, 0.25)
      elseif ActivePred() == "HPrediction" then
        local Position, HitChance = HPredict(Target, "E")
        DelayAction(function() CCastSpell(_E, Position.x, Position.z) end, 0.25)
      end
  end
end

function CastQE2(BallInfo)
  for i, enemy in ipairs(GetEnemyHeroes()) do
    if ValidTarget(enemy) then
      if GetDistanceSqr(BallInfo.object, myHero.visionPos) < E.rangeSqr then
        local enemyPos, hitchance
        if ActivePred() == "VPrediction" then
          local enemyPos, hitchance, Position = VPredict(Qtarget, E)
        elseif ActivePred() == "DivinePred" then
          local State, Position, perc = DPredict(Qtarget, E)
          hitchance = perc*3/100
        elseif ActivePred() == "HPrediction" then
          local enemyPos, hitchance = HPredict(Qtarget, "W")
        end
        if hitchance >= 2 and enemyPos and enemyPos.z then   
          local EP = Vector(BallInfo.object) +  (100+(-0.6 * GetDistance(BallInfo.object, myHero.visionPos) + 966)) * (Vector(BallInfo.object) - Vector(myHero.visionPos)):normalized()
          local SP = Vector(BallInfo.object) - 100 * (Vector(BallInfo.object) - Vector(myHero.visionPos)):normalized()
          local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(SP, EP, enemyPos)
          if isOnSegment and GetDistanceSqr(pointLine, enemyPos) <= (QE.width + VP:GetHitBox(enemy))^2 then
            if (E.delay + GetDistance(myHero.visionPos, BallInfo.object) / E.speed) >= (BallInfo.startT - os.clock()) then
              CCastSpell(_E, BallInfo.object.x, BallInfo.object.z)
              if debugMode then PrintChat("Casted E on ball") end
            else
              DelayAction(function(t) CastQE3(t) end, BallInfo.startT - os.clock() - (E.delay + GetDistance(myHero.visionPos, BallInfo.object) / E.speed), {BallInfo})  
            end       
          end
        end
      end
    end
  end
end

function zhg()
  if Config.casual.zhg.enabled then
    if GetInventoryHaveItem(3157) and GetInventoryItemIsCastable(3157) then
      if myHero.health <=  myHero.maxHealth * (Config.casual.zhg.zhonyapls / 100) then
        CastItem(3157)
      end 
    end 
  end 
end

function GetValidBalls(ForE)
  if (ForE == nil) or (ForE == false) then
    local result = {}
    for i, ball in ipairs(Balls) do
      if (ball.added or ball.startT <= os.clock()) and Balls[i].endT >= os.clock() and ball.object.valid then
        if not WObject or ball.object.networkID ~= WObject.networkID then
          table.insert(result, ball)
        end
      end
    end
    return result
  else
    local result = {}
    for i, ball in ipairs(Balls) do
      if (ball.added or ball.startT <= os.clock() + (E.delay + GetDistance(myHero.visionPos, ball.object) / E.speed)) and Balls[i].endT >= os.clock() + (E.delay + GetDistance(myHero.visionPos, ball.object) / E.speed) and ball.object.valid then
        if not WObject or ball.object.networkID ~= WObject.networkID then
          table.insert(result, ball)
        end
      end
    end
    return result
  end
end

function GetWValidBall(OnlyBalls)
  local all = GetValidBalls()
  local inrange = {}

  local Pet = GetPet(true)
  if Pet then
    return {object = Pet}
  end

  --Get the balls in W range
  for i, ball in ipairs(all) do
    if GetDistanceSqr(ball.object, myHero.visionPos) <= W.rangeSqr then
      table.insert(inrange, ball)
    end
  end

  local minEnd = math.huge
  local minBall

  --Get the ball that will expire earlier
  for i, ball in ipairs(inrange) do
    if ball.endT < minEnd then
      minBall = ball
      minEnd = ball.endT
    end
  end

  if minBall then
    return minBall
  end
  if OnlyBalls then 
    return 
  end

  Pet = GetPet()
  if Pet then
    return {object = Pet}
  end

  EnemyMinions:update()
  JungleMinions:update()
  PosiblePets:update()
  local t = MergeTables(MergeTables(EnemyMinions.objects, JungleMinions.objects), PosiblePets.objects)
  SelectUnits(t, function(t) return ValidTarget(t) and GetDistanceSqr(myHero.visionPos, t) < W.rangeSqr end)
  if t[1] then
    return {object = t[1]}
  end
end

function AddBall(obj)
  for i = #Balls, 1, -1 do
    if not Balls[i].added and GetDistanceSqr(Balls[i].object, obj) < 50*50 then
      Balls[i].added = true
      Balls[i].object = obj
      do return end
    end
  end
  local BallInfo = {
               added = true, 
               object = obj,
               startT = os.clock(),
               endT = os.clock() + BallDuration - GetLatency()/2000
          }
  table.insert(Balls, BallInfo)           
end

function OnCreateObj(obj)
  if obj and obj.valid then
    if GetDistanceSqr(obj) < Q.rangeSqr * 2 then
      if obj.name:find("Seed") then
        DelayAction(AddBall, 0, {obj})
      end
    end
  end
end

function AutoGrabPets()
  if W.IsReady() and W.status == 0 then
    local pet = GetPet(true)
    if pet then
      CastSpell(_W, pet.x, pet.z)
      if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked up pet with W") end
    end
  end
end

function GetPet(dangerous)
  PosiblePets:update()
  --Priorize Enemy Pet's
  for i, object in ipairs(PosiblePets.objects) do
    if object and object.valid and object.team ~= myHero.team and IsPet(object.charName) and (not dangerous or IsPetDangerous(object.charName)) then
      return object
    end
  end
end

function OnDeleteObj(obj)
  if obj.name:find("Syndra_") and (obj.name:find("_Q_idle.troy") or obj.name:find("_Q_Lv5_idle.troy")) then
    for i = #Balls, 1, -1 do
      if Balls[i].object and Balls[i].object.valid and GetDistanceSqr(Balls[i].object, obj) < 50 * 50 then
        table.remove(Balls, i)
        break
      end
    end
  end
end

function OnCastQ(spell)
  local BallInfo = {
            added = false, 
            object = {valid = true, x = spell.endPos.x, y = myHero.y, z = spell.endPos.z},
            startT = os.clock() + Q.delay - GetLatency()/2000,
            endT = os.clock() + BallDuration + Q.delay - GetLatency()/2000
           }
  if Config.key.combo or (Config.key.har or Config.key.harr) then
    local Delay = Q.delay - (E.delay + GetDistance(myHero.visionPos, BallInfo.object) / E.speed)
    DelayAction(function(t) CastQE2(t) end, Delay, {BallInfo})
  else
    Qdistance = nil
    EQtarget = nil
    EQCombo = 0
  end
  table.insert(Balls, BallInfo)
end

function BTOnTick()
  for i = #Balls, 1, -1 do
    if Balls[i].endT <= os.clock() then
      table.remove(Balls, i)
    end
  end
end

function BTOnDraw()--For testings
  local activeballs = GetValidBalls()
  for i, ball in ipairs(activeballs) do
    DrawCircle(ball.object.x, myHero.y, ball.object.z, 100, ARGB(255,255,255,255))
  end
end

function OnInterruptSpell(unit, spell)
  if GetDistanceSqr(unit.visionPos, myHero.visionPos) < E.rangeSqr and E.IsReady() then
    if Q.IsReady() then
      DoEQCombo(unit)
      --CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
    if debugMode then PrintChat("Casted QE on Gapcloser") end
    else
      CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
      if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E to Interrupt") end
    end
  elseif GetDistanceSqr(unit.visionPos,  myHero.visionPos) < QE.rangeSqr and Q.IsReady() and E.IsReady() then
      DoEQCombo(unit)
      --CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
    if debugMode then PrintChat("Casted QE on Gapcloser") end
  end 
end

function OnGapclose(unit, data)
  if GetDistanceSqr(unit.visionPos, myHero.visionPos) < E.rangeSqr and E.IsReady() then
    if Q.IsReady() then
      Qdistance = 300
      DoEQCombo(unit)
      --CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
    if debugMode then PrintChat("Casted QE on Gapcloser") end
    else
      CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
      if debugMode then PrintChat("Casted E on Gapcloser") end
    end
  elseif GetDistanceSqr(unit.visionPos,  myHero.visionPos) < QE.rangeSqr and Q.IsReady() and E.IsReady() then
      DoEQCombo(unit)
      --CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
    if debugMode then PrintChat("Casted QE on Gapcloser") end
  end 
end


function OnProcessSpell(unit, spell)
  if unit.isMe then
    if spell.name == "SyndraQ" then
      Q.LastCastTime = os.clock()
      OnCastQ(spell)
    elseif spell.name == "SyndraE" then 
      E.LastCastTime = os.clock()
    elseif spell.name == "SyndraW" then
      W.LastCastTime = os.clock()
            Recieved = 0
      RecvCounter = 0
    elseif spell.name == "syndrawcast" then
      Recieved = 1
    elseif spell.name == "syndrae5" then
      E.LastCastTime = os.clock()
    end
  end
end

function GetCustomTarget()
    --sts:update()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return sts.GetTarget(1500)
end

--[[ Packet Cast Helper ]]--
function CCastSpell(Spell, xPos, zPos)
  if VIP_USER and Config.misc.pc then
    Packet("S_CAST", {spellId = Spell, fromX = xPos, fromY = zPos, toX = xPos, toY = zPos}):send()
  else
    CastSpell(Spell, xPos, zPos)
  end
end

-- [[ After here only prediction stuff ]]--
function ActivePred()
    local int = Config.misc.pro
    return tostring(predToUse[int])
end

function SetupHPred()
  MakeHPred("Q", 0) 
  MakeHPred("W", 1) 
  MakeHPred("E", 2) 
end

function MakeHPred(hspell, i)
 if data[i].type == "linear" or data[i].type == "cone" or data[i].type == "circular" then 
    if data[i].type == "linear" then
        if data[i].speed ~= math.huge then 
            HP:AddSpell(hspell, myHero.charName, {type = "DelayLine", range = data[i].range, speed = data[i].speed, width = 2*data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        else
            HP:AddSpell(hspell, myHero.charName, {type = "PromptLine", range = data[i].range, width = 2*data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        end
    elseif data[i].type == "circular" then
        if data[i].speed ~= math.huge then 
            HP:AddSpell(hspell, myHero.charName, {type = "DelayCircle", range = data[i].range, speed = data[i].speed, width = data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        else
            HP:AddSpell(hspell, myHero.charName, {type = "PromptCircle", range = data[i].range, width = data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        end
    else --Cone!
        HP:AddSpell(hspell, myHero.charName, {type = "DelayLine", range = data[i].range, speed = data[i].speed, width = data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
    end
 end
end

local LastRequest = 0
function ValidRequest()
    if os.clock() - LastRequest < TimeRequest() then
        return false
    else
        LastRequest = os.clock()
        return true
    end
end

function TimeRequest()
    if ActivePred() == "VPrediction" or ActivePred() == "HPrediction" then
        return 0.001
    elseif ActivePred() == "DivinePred" then
        return Config.misc~=nil and Config.misc.time or 0.2
    end
end

function HPredict(Target, spell)
  return HP:GetPredict(spell, Target, myHero)
end

function DPredict(Target, spell)
  local unit = DPTarget(Target)
  local col = (spell.aoe and spell.collision) and 0 or math.huge
  if spell.type == "linear" then
  Spell = LineSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  elseif spell.type == "circular" then
  Spell = CircleSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  elseif spell.type == "cone" then
  Spell = ConeSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  end
  return DP:predict(unit, Spell)
end

function VPredict(Target, spell)
  if spell.type == "linear" then
  if spell.aoe then
    return VP:GetLineAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
  else
    return VP:GetLineCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
  end
  elseif spell.type == "circular" then
  if spell.aoe then
    return VP:GetCircularAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
  else
    return VP:GetCircularCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
  end
  elseif spell.type == "cone" then
  if spell.aoe then
    return VP:GetConeAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
  else
    return VP:GetLineCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
  end
  end
end