  if myHero.charName ~= "Sona" or not VIP_USER then return end
  require 'HPrediction'  
  assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("PCFDDKCCKFC") 
  
  --A basic BoL template for the Eclipse Lua Development Kit module's execution environment written by Nader Sl.
  player = GetMyHero()
  
  -- called once when the script is loaded
  function OnLoad()
  require "VPrediction"
  print("<b><font color=\"#FF001E\"> Baguette </font></b><font color=\"#FF980F\"> Sona </font><font color=\"#FF001E\"></font><b><font color=\"#FF001E\"> loaded </font><font color=\"#FF001E\"><font color=\"#FF980F\"> GL </font><font color=\"#FF001E\"></font><b><font color=\"#FF001E\"> & </font><font color=\"#FF001E\"><font color=\"#FF980F\"><font color=\"#FF001E\"><font color=\"#FF980F\"> HF </font><font color=\"#FF001E\"></font>")
  TargetSelector = TargetSelector(TARGET_LOW_HP_PRIORITY, 900)
  Variables() 
  Menu()
  Checkorbwalk()
  HPred = HPrediction()
  HPred:AddSpell("R", 'Sona', {type = "DelayLine", range = 900, delay = 0.25, speed = 2400, width = 280 })

  end
  
  -- handles script logic, a pure high speed loop
  function OnTick()
  
  Checks()
  TargetSelector:update()
  Target = GetCustomTarget()
  if SxOrbLoaded then
  SxOrb:ForceTarget(Target)
  end
  CastAutoR()
  
  
    if Target ~= nil then
    if Settings.Key.comboKey then
        Combo(Target)
      end
    end
    if Target ~= nil then
    if Settings.Key.harass then
      Harass(Target)
      end
      end
  end

  --handles overlay drawing (processing is not recommended here,use onTick() for that)
  function OnDraw()
    if not myHero.dead then 
      if ValidTarget(Target) then 
        DrawText3D("Current Target",Target.x-100, Target.y-50, Target.z, 20, 0xFFFFFF00)
        DrawCircle(Target.x, Target.y, Target.z, 150, ARGB(200,100 ,100,0 ))
      end
      
      if SkillQ.ready and Settings.Draw.DrawQ then 
        DrawCircle(myHero.x, myHero.y, myHero.z, Settings.combo.Qrange, ARGB(200,50 ,100,0 ))
      end
      if SkillE.ready and Settings.Draw.DrawE then 
        DrawCircle(myHero.x, myHero.y, myHero.z, Settings.combo.Erange, ARGB(200,50 ,100,0 ))
      end
      if SkillR.ready and Settings.Draw.DrawR then 
        DrawCircle(myHero.x, myHero.y, myHero.z, Settings.combo.Rrange, ARGB(200,50 ,100,0 ))
      end
    end
  end
  
  --handles input
  function OnWndMsg(msg,key)
  
  end
  
  -- listens to chat input
  function OnSendChat(txt)
  
  end
  
  -- listens to spell
  function OnProcessSpell(owner,spell)
  
  end
  
  -- Check
  function Checks()
    SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
    SkillW.ready = (myHero:CanUseSpell(_W) == READY)
    SkillE.ready = (myHero:CanUseSpell(_E) == READY)
    SkillR.ready = (myHero:CanUseSpell(_R) == READY)
     _G.DrawCircle = _G.oldDrawCircle
  end
  
  -- custom target
  function GetCustomTarget()
    if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
      return SelectedTarget
    end
    TargetSelector:update() 
    if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
      return TargetSelector.target
    else
      return nil
    end
  end
  
  -- Menu
  function Menu()
  Settings = scriptConfig("Baguette SONA", "sona")    
   
  Settings:addSubMenu("["..myHero.charName.."] - Combo", "combo")
  Settings.combo:addParam("UseR", "Use (R)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("N"))
  Settings.combo:addParam("Rrange", "Max range for (R)", SCRIPT_PARAM_SLICE, 900, 0, 1000, 0)
  Settings.combo:addParam("UseRP", "Use R if Target HP < x%", SCRIPT_PARAM_SLICE, 65, 0, 100, 0)
  Settings.combo:addParam("UseQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
  Settings.combo:addParam("Qrange", "Max range for (Q)", SCRIPT_PARAM_SLICE, 835, 0, 850, 0)
  Settings.combo:addParam("UseE", "Use (E)", SCRIPT_PARAM_ONOFF, true)
  Settings.combo:addParam("Erange", "Max range for (E)", SCRIPT_PARAM_SLICE, 600, 0, 1000, 0)
  
  Settings:addSubMenu("["..myHero.charName.."] - Harass", "harass")
  Settings.harass:addParam("HarassR", "Use (R)", SCRIPT_PARAM_ONOFF, false)
  Settings.harass:addParam("Rrange", "Max range for (R)", SCRIPT_PARAM_SLICE, 900, 0, 1000, 0)
  Settings.harass:addParam("UseRP", "Use R if Target HP < x%", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
  Settings.harass:addParam("HarassQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
  Settings.harass:addParam("Qrange", "Max range for (Q)", SCRIPT_PARAM_SLICE, 835, 0, 850, 0)
  Settings.harass:addParam("HarassE", "Use (E)", SCRIPT_PARAM_ONOFF, true)
  Settings.harass:addParam("manah", "Min. Mana To Harass", SCRIPT_PARAM_SLICE, 60, 0, 1000, 0)
  Settings.harass:addParam("Erange", "Max range for (E)", SCRIPT_PARAM_SLICE, 600, 0, 1000, 0)
  
  Settings:addSubMenu("["..myHero.charName.."] - Auto Ult ", "AutoUlt")
  Settings.AutoUlt:addParam("UseAutoR", "Auto R if X enemie", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("C"))
  Settings.AutoUlt:addParam("ARX", "X = ", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
  Settings.AutoUlt:addSubMenu("Use auto ult on : ", "BlackListA")
  if #GetEnemyHeroes() > 0 then
  for idx, enemy in ipairs(GetEnemyHeroes()) do
  Settings.AutoUlt.BlackListA:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, true)
  end
  end 
  
    
  Settings:addSubMenu("["..myHero.charName.."] - Draw", "Draw")
  Settings.Draw:addParam("DrawQ", "Draw (Q)", SCRIPT_PARAM_ONOFF, true)
  Settings.Draw:addParam("DrawE", "Draw (E)", SCRIPT_PARAM_ONOFF, true)
  Settings.Draw:addParam("DrawR", "Draw (R)", SCRIPT_PARAM_ONOFF, true)
  
  Settings:addSubMenu("["..myHero.charName.."] - Key ", "Key")
  Settings.Key:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("32"))
  Settings.Key:addParam("comboKey", "Combo Key (toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("32"))
  Settings.Key:addParam("harass", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
  Settings.Key:addParam("harass", "Harass key (2)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
  Settings.Key:addParam("harass", "Harass (toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("J"))
  


  
  
  
  Settings:addSubMenu("["..myHero.charName.."] - Misc", "Misc")
  Settings.Misc:addParam("KSQ", "Auto KS with Q", SCRIPT_PARAM_ONOFF, true)
  Settings.Misc:addParam("Prediction","Choose Prediction : ", SCRIPT_PARAM_LIST, 2, {"Vpred", "Hpred"})
  Settings.Misc:addParam("R", "HPred hitchance (Default = 1.25)", SCRIPT_PARAM_SLICE, 1.25, 1, 3, 2)
  
  if #GetEnemyHeroes() > 0 then
  Settings:addSubMenu("["..myHero.charName.."] - Use R on : ", "BlackList")
  for idx, enemy in ipairs(GetEnemyHeroes()) do
  Settings.BlackList:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, true)
  end
  end


    
  
  Settings.Key:permaShow("comboKey")
  Settings.Key:permaShow("harass")
  Settings.combo:permaShow("UseR")
  Settings.AutoUlt:permaShow("UseAutoR")
  Settings.AutoUlt:permaShow("ARX")
  
      
  TargetSelector.name = "Sona"
  Settings:addTS(TargetSelector)    
  end
  
  -- Spell function
  function CastQ(unit)
  if Settings.combo.UseQ then
    if unit.team ~= myHero.team and unit.visible and unit.dead == false and myHero:GetDistance(unit) <= Settings.combo.Qrange then
    if _G.AutoCarry.Orbwalker:CanMove() and not _G.AutoCarry.Orbwalker:IsShooting() then
    CastSpell(_Q)
      end
     end
    end
end
  
  function CastE(unit)
  if Settings.combo.UseE then
    if unit.team ~= myHero.team and unit.visible and unit.dead == false and myHero:GetDistance(unit) <= Settings.combo.Erange then
    if _G.AutoCarry.Orbwalker:CanMove() and not _G.AutoCarry.Orbwalker:IsShooting() then
    CastSpell(_E)
        end
      end
    end
end  
  
  function CastR(unit)    
    if unit ~= nil and GetDistance(unit) <= Settings.combo.Rrange and SkillR.ready then
      local TargetHealthPercent = (Target.health/Target.maxHealth)*100
      if Settings.combo.UseR and Settings.combo.UseRP >= TargetHealthPercent then
      if Settings.BlackList[unit.charName] then
      if not Immune(unit) then
      if _G.AutoCarry.Orbwalker:CanMove() and not _G.AutoCarry.Orbwalker:IsShooting() then
      if Settings.Misc.Prediction == 1 then
        CastPosition,  HitChance,  Position = VP:GetLineAOECastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero, false) 
        if HitChance >= 2 then
          Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
          end
          else 
           if Settings.Misc.Prediction == 2 then
           local RPos, RHitChance = HPred:GetPredict("R", unit, myHero)
           if RHitChance >= Settings.Misc.R then
               if VIP_USER then
               Packet("S_CAST", {spellId = _R, toX = RPos.x, toY = RPos.z, fromX = RPos.x, fromY = RPos.z}):send()
                else
               CastSpell(_R, RPos.x, RPos.z)
               end
                   end
                end
               end
            end
          end
        end
      end
   end
end

 

  
  -- Spell function harass
  function HarassQ(unit)
  if Settings.harass.HarassQ and myHero.mana >= Settings.harass.manah then
    if unit.team ~= myHero.team and unit.visible and unit.dead == false and myHero:GetDistance(unit) <= Settings.harass.Qrange then
    if _G.AutoCarry.Orbwalker:CanMove() and not _G.AutoCarry.Orbwalker:IsShooting() then
    CastSpell(_Q)
      end
    end
  end
end  
  
  function HarassE(unit)
  if Settings.harass.HarassE and myHero.mana >= Settings.harass.manah then
    if unit.team ~= myHero.team and unit.visible and unit.dead == false and myHero:GetDistance(unit) <= Settings.harass.Erange then
    if _G.AutoCarry.Orbwalker:CanMove() and not _G.AutoCarry.Orbwalker:IsShooting() then
    CastSpell(_E)
     end
   end
  end
end
  
  function HarassR(unit)
  local TargetHealthPercent = (Target.health/Target.maxHealth)*100
  if Settings.harass.HarassR and myHero.mana >= Settings.harass.manah then
    if unit ~= nil and GetDistance(unit) <= Settings.harass.Rrange and SkillR.ready then
    if Settings.BlackList[unit.charName] and Settings.harass.UseRP >= TargetHealthPercent then
    if _G.AutoCarry.Orbwalker:CanMove() and not _G.AutoCarry.Orbwalker:IsShooting() then
    if not Immune(unit) then
    if Settings.Misc.Prediction == 1 then
      CastPosition,  HitChance,  Position = VP:GetLineAOECastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero, false) 
      if HitChance >= 2 then
        Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
        end
          else 
           if Settings.Misc.Prediction == 2 then
           local RPos, RHitChance = HPred:GetPredict("R", unit, myHero)
           if RHitChance >= Settings.Misc.R then
               if VIP_USER then
               Packet("S_CAST", {spellId = _R, toX = RPos.x, toY = RPos.z, fromX = RPos.x, fromY = RPos.z}):send()
                else
               CastSpell(_R, RPos.x, RPos.z)
               end
               end
            end
          end
       end
      end
    end
   end
  end
end  
  
  -- combo
  function Combo(unit)
      CastQ(unit)
      CastR(unit)
      CastE(unit)
  end
  -- harass
  function Harass(unit)
      HarassQ(unit)
      HarassR(unit)
      HarassE(unit)
  end
  
  
  --variables
  function Variables()
  SkillQ = { range = 835, width = 700, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false, ready = false }
  SkillW = { range = 1000, width = 1000, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _W, ready = false }
  SkillE = { range = 600, width = 1000, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, ready = false }
  SkillR = { range = 1000, width = 140, speed = 2400, delay = .25, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true, timer = 0, ready = false }
  RebornLoaded, SxOrbLoaded = false, false
  VP = VPrediction()
  _G.oldDrawCircle = rawget(_G, 'DrawCircle')
  _G.DrawCircle = DrawCircle2
  
  end
  
  -- selector
  function OnWndMsg(Msg, Key) 
    
    if Msg == WM_LBUTTONDOWN then
      local minD = 0
      local Target = nil
      for i, unit in ipairs(GetEnemyHeroes()) do
        if ValidTarget(unit) then
          if GetDistance(unit, mousePos) <= minD or Target == nil then
            minD = GetDistance(unit, mousePos)
            Target = unit
          end
        end
      end
  
      if Target and minD < 115 then
        if SelectedTarget and Target.charName == SelectedTarget.charName then
          SelectedTarget = nil
        else
          SelectedTarget = Target
        end
      end
    end
  end
  
  -- Cercle selector
  function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  end
  
  --auto R
  function CastAutoR()
  if ValidTarget(unit, SkillR.range) and rPos ~= nil and maxHit >= Settings.AutoUlt.ARX then
  if SkillR.ready then
  if Settings.AutoUlt.BlackListA[unit.charName] then
  if Settings.AutoUlt.UseAutoR then
    for _, unit in pairs(GetEnemyHeroes()) do
        if Settings.Misc.Prediction == 1 then
        local rPos, HitChance, maxHit, Positions = VP:GetLineAOECastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero)
        if HitChance >= 2 then   
        Packet("S_CAST", {spellId = _R, fromX = rPos.x, fromY = rPos.z, toX = rPos.x, toY = rPos.z}):send()
        end
         else 
           if Settings.Misc.Prediction == 2 then
           local RPos, RHitChance = HPred:GetPredict("R", unit, myHero)
           if RHitChance >= Settings.Misc.R then
               if VIP_USER then
               Packet("S_CAST", {spellId = _R, toX = RPos.x, toY = RPos.z, fromX = RPos.x, fromY = RPos.z}):send()
                else
               CastSpell(_R, RPos.x, RPos.z)
                end
               end
             end
          end
         end
       end
      end
     end
   end
 end
  
  function Checkorbwalk()
  if _G.Reborn_Loaded then  
     RebornLoaded = true
     print("<font color=\"#0f76ff\"> SAC LOADED </font><font color=\"#0f76ff\">")
     Settings:addSubMenu("["..myHero.charName.."] - SAC DETECTED", "")
     elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
      require 'SxOrbWalk'
      SxOrbMenu = Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")    
      SxOrb:LoadToMenu(Settings.Orbwalking)
      SxOrbLoaded = true
       
    else
       print("<font color=\"#0f76ff\"> Please download SxOrbwalk or SAC </font><font color=\"#0f76ff\">")
    end  
  if  not _G.Activator then
      print("<font color=\"#c20e00\"> Please download activator for (W) spell support </font><font color=\"#c20e00\">")
   end
  end  

function Immune(unit)
    if TargetHaveBuff("JudicatorIntervention", unit) then return true
    elseif TargetHaveBuff("UndyingRage", unit) then return true
    elseif TargetHaveBuff("ZacRebirthReady", unit) then return true
    elseif TargetHaveBuff("aatroxpassivedeath", unit) then return true
    elseif TargetHaveBuff("FerociousHowl", unit) then return true
    elseif TargetHaveBuff("VladimirSanguinePool", unit) then return true
    elseif TargetHaveBuff("chronorevive", unit) then return true
    elseif TargetHaveBuff("chronoshift", unit) then return true
    elseif TargetHaveBuff("KarthusDeathDefiedBuff", unit) then return true
    elseif TargetHaveBuff("kogmawicathiansurprise", unit) then return true
    elseif TargetHaveBuff("sionpassivezombie", unit) then return true
    elseif TargetHaveBuff("zhonyasringshield", unit) then return true
    elseif TargetHaveBuff("zyrapqueenofthorns", unit) then return true end
    return false
end
