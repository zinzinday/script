--[[
 _   _  _      _           _____    _   _        _                    
| \ | |(_)    | |         |  _  |  | | | |      | |                   
|  \| | _   __| |  __ _   | | | |  | |_| |  ___ | | _ __    ___  _ __ 
| . ` || | / _` | / _` |  | | | |  |  _  | / _ \| || '_ \  / _ \| '__|
| |\  || || (_| || (_| |  \ \/' /  | | | ||  __/| || |_) ||  __/| |   
\_| \_/|_| \__,_| \__,_|   \_/\_\  \_| |_/ \___||_|| .__/  \___||_|   
                                                   | |                
                                                   |_|                
]]--
if myHero.charName ~= "Nidalee" then return end


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
if VIP_USER and FileExist(LIB_PATH .. "/Prodiction.lua") then
  require("Prodiction")
  prodstatus = true
  table.insert(predToUse, "Prodiction")
end

if predToUse == {} then 
  PrintChat("Please download a Prediction") 
  return 
end

local Q = {name = "Javelin Toss", range = 1500, speed = 1300, delay = 0.125, width = 40, Ready = function() return myHero:CanUseSpell(_Q) == READY end}
local QTargetSelector = TargetSelector(TARGET_NEAR_MOUSE, Q.range, DAMAGE_MAGIC)

function OnLoad()
  Config = scriptConfig("Nida Q Helper ", " Nida Q Helper ")
  if predToUse == {} then PrintChat("PLEASE DOWNLOAD A PREDICTION!") return end
  Config:addSubMenu("[Misc]: Settings", "misc")
  Config.misc:addParam("pc", "Use Packets To Cast Spells(VIP)", SCRIPT_PARAM_ONOFF, false)
  Config.misc:addParam("qqq", "--------------------------------------------------------", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("pro", "Prediction To Use:", SCRIPT_PARAM_LIST, 1, predToUse) 
  if ActivePred() == "VPrediction" or ActivePred() == "HPrediction" then 
   Config.misc:addParam("hc", "Accuracy (Default: 2)", SCRIPT_PARAM_SLICE, 2, 0, 3, 1)
  elseif ActivePred() == "DivinePred" then
   Config.misc:addParam("hc", "Accuracy (Default: 1.2)", SCRIPT_PARAM_SLICE, 1.2, 0, 1.5, 1)
   if Config.misc.hc > 1.5 then Config.misc.hitchance = 1.2 end
   Config.misc:addParam("time","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1)
  end
  Config.misc:addParam("qqq", "--------------------------------------------------------", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("mana", "Min mana for harass:", SCRIPT_PARAM_SLICE, 30, 0, 101, 0)
  Config:addParam("throwQh", "Harass with Q (toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
  Config:addParam("throwQ", "Throw Q", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
  Config:permaShow("throwQh")
  Config:addTS(QTargetSelector)
  if ActivePred() == "HPrediction" then
    HP:AddSpell("Q", 'Nidalee', {type = "DelayLine", range = Q.range, speed = Q.speed, width = 2*Q.width, delay = Q.delay, collisionM = true, collisionH = true})
  end
  print("Nida Q Helper loaded!")
end

function ActivePred()
    return tostring(predToUse[Config.misc.pro])
end

function Check()
  QTargetSelector:update()
  if SelectedTarget ~= nil and ValidTarget(SelectedTarget, Q.range) then
    QCel = SelectedTarget
  else
    QCel = QTargetSelector.target
  end
end

function OnTick()
  Check()
  if Config.throwQh and myHero.mana >= Config.misc.mana and not recall and not myHero.dead then
    if QCel ~= nil then
      ThrowQ(QCel)
    end
  end
  if Config.throwQ and not recall then
    if QCel ~= nil then
      ThrowQ(QCel)
    end
  end
end

function ThrowQ(unit)
  if unit and Q.Ready() and ValidTarget(unit) then
    if ActivePred() == "VPrediction" then
      local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Q.delay, Q.width, Q.range, Q.speed, myHero, true)
      if HitChance >= Config.misc.hc then
        if VIP_USER and Config.misc.pc then
          Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
        else
          CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
      end
    end
    if ActivePred() == "HPrediction" then
      local CastPosition, HitChance = HP:GetPredict("Q", unit, myHero)
      if HitChance >= Config.misc.hc then
        if VIP_USER and Config.misc.pc then
          Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
        else
          CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
      end
    end
    if ActivePred() == "Prodiction" and VIP_USER and prodstatus then
      local Position, info = Prodiction.GetPrediction(unit, Q.range, Q.speed, Q.delay, Q.width, myHero)
      if Position ~= nil and not info.mCollision() then
        if VIP_USER and Config.misc.pc then
          Packet("S_CAST", {spellId = _Q, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()
        else
          CastSpell(_Q, Position.x, Position.z)
        end 
      end
    end
    if ActivePred() == "DivinePred" and VIP_USER then
      local unit = DPTarget(unit)
      local NidaQ = LineSS(Q.speed, Q.range, Q.width, Q.delay*1000, 0)
      if ValidRequest() then
        State, Position, perc = DPredict(unit, NidaQ)
      else
        State, Position, perc = DelayAction(DPredict, TimeRequest(), {unit, NidaQ})
      end
      if State == SkillShot.STATUS.SUCCESS_HIT then 
        if VIP_USER and Config.misc.pc then
          Packet("S_CAST", {spellId = _Q, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()
        else
          CastSpell(_Q, Position.x, Position.z)
        end
      end
    end
  end
end

function DPredict(Target, spell)
  return DP:predict(unit, Spell, Config.misc.hc)
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
    if ActivePred() == "VPrediction" or ActivePred() == "HPrediction" or ActivePred() == "Prodiction" then
        return 0.001
    elseif ActivePred() == "DivinePred" then
        return Config.misc~=nil and Config.misc.time or 0.2
    end
end
