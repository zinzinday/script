local Version = "1.24"
local AutoUpdate = true

if myHero.charName ~= "Ezreal" then
  return
end

require 'HPrediction'

function ScriptMsg(msg)
  print("<font color=\"#daa520\"><b>HTTF Ezreal:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>")
end

---------------------------------------------------------------------------------

local Host = "raw.github.com"

local ScriptFilePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME

local ScriptPath = "/BolHTTF/BoL/master/HTTF/HTTF Ezreal.lua".."?rand="..math.random(1,10000)
local UpdateURL = "https://"..Host..ScriptPath

local VersionPath = "/BolHTTF/BoL/master/HTTF/Version/HTTF Ezreal.version".."?rand="..math.random(1,10000)
local VersionData = tonumber(GetWebResult(Host, VersionPath))

if AutoUpdate then

  if VersionData then
  
    ServerVersion = type(VersionData) == "number" and VersionData or nil
    
    if ServerVersion then
    
      if tonumber(Version) < ServerVersion then
        ScriptMsg("New version available: v"..VersionData)
        ScriptMsg("Updating, please don't press F9.")
        DelayAction(function() DownloadFile(UpdateURL, ScriptFilePath, function () ScriptMsg("Successfully updated.: v"..Version.." => v"..VersionData..", Press F9 twice to load the updated version.") end) end, 3)
      else
        ScriptMsg("You've got the latest version: v"..Version)
      end
      
    end
    
  else
    ScriptMsg("Error downloading version info.")
  end
  
else
  ScriptMsg("AutoUpdate: false")
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function OnLoad()

  Variables()
  EzrealMenu()
  DelayAction(Orbwalk, 1)
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function Variables()

  HPred = HPrediction()
  
  IsRecall = false
  RebornLoaded, RevampedLoaded, MMALoaded, SxOrbLoaded, SOWLoaded = false, false, false, false, false
  
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
    Ignite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    Ignite = SUMMONER_2
  end
  
  if myHero:GetSpellData(SUMMONER_1).name:find("smite") then
    Smite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then
    Smite = SUMMONER_2
  end
  
  Q = {range = 1200, width = 160, ready}
  W = {range = 1050, width = 160, ready}
  E = {range = 475, ready}
  R = {range = 1500, width = 320, ready}
  I = {range = 600, ready}
  S = {range = 760, ready}
  
  AutoQEWQ = {1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3}
  
  QTargetRange = Q.range+100
  WTargetRange = W.range+100
  RTargetRange = R.range+100
  
  QMinionRange = Q.range+100
  QJunglemobRange = Q.range+100
  
  Items =
  {
  ["BC"] = {id=3144, range = 450, slot = nil, ready},
  ["BRK"] = {id=3153, range = 450, slot = nil, ready},
  ["Stalker"] = {id=3706, slot = nil, ready},
  ["StalkerW"] = {id=3707, slot = nil},
  ["StalkerM"] = {id=3708, slot = nil},
  ["StalkerJ"] = {id=3709, slot = nil},
  ["StalkerD"] = {id=3710, slot = nil}
  }
  
  S5SR = false
  TT = false
  
  if GetGame().map.index == 15 then
    S5SR = true
  elseif GetGame().map.index == 4 then
    TT = true
  end
  
  if S5SR then
    FocusJungleNames =
    {
    "SRU_Baron12.1.1",
    "SRU_Blue1.1.1",
    "SRU_Blue7.1.1",
    "Sru_Crab15.1.1",
    "Sru_Crab16.1.1",
    "SRU_Dragon6.1.1",
    "SRU_Gromp13.1.1",
    "SRU_Gromp14.1.1",
    "SRU_Krug5.1.2",
    "SRU_Krug11.1.2",
    "SRU_Murkwolf2.1.1",
    "SRU_Murkwolf8.1.1",
    "SRU_Razorbeak3.1.1",
    "SRU_Razorbeak9.1.1",
    "SRU_Red4.1.1",
    "SRU_Red10.1.1"
    }
  JungleMobNames =
    {
    "SRU_BlueMini1.1.2",
    "SRU_BlueMini7.1.2",
    "SRU_BlueMini21.1.3",
    "SRU_BlueMini27.1.3",
    "SRU_KrugMini5.1.1",
    "SRU_KrugMini11.1.1",
    "SRU_MurkwolfMini2.1.2",
    "SRU_MurkwolfMini2.1.3",
    "SRU_MurkwolfMini8.1.2",
    "SRU_MurkwolfMini8.1.3",
    "SRU_RazorbeakMini3.1.2",
    "SRU_RazorbeakMini3.1.3",
    "SRU_RazorbeakMini3.1.4",
    "SRU_RazorbeakMini9.1.2",
    "SRU_RazorbeakMini9.1.3",
    "SRU_RazorbeakMini9.1.4",
    "SRU_RedMini4.1.2",
    "SRU_RedMini4.1.3",
    "SRU_RedMini10.1.2",
    "SRU_RedMini10.1.3"
    }
  elseif TT then
    FocusJungleNames =
    {
    "TT_NWraith1.1.1",
    "TT_NGolem2.1.1",
    "TT_NWolf3.1.1",
    "TT_NWraith4.1.1",
    "TT_NGolem5.1.1",
    "TT_NWolf6.1.1",
    "TT_Spiderboss8.1.1"
    }   
    JungleMobNames =
    {
    "TT_NWraith21.1.2",
    "TT_NWraith21.1.3",
    "TT_NGolem22.1.2",
    "TT_NWolf23.1.2",
    "TT_NWolf23.1.3",
    "TT_NWraith24.1.2",
    "TT_NWraith24.1.3",
    "TT_NGolem25.1.1",
    "TT_NWolf26.1.2",
    "TT_NWolf26.1.3"
    }
  else
    FocusJungleNames =
    {
    }   
    JungleMobNames =
    {
    }
  end
  
  QTS = TargetSelector(TARGET_LESS_CAST, QTargetRange, DAMAGE_PHYSICAL, false)
  WTS = TargetSelector(TARGET_LESS_CAST, WTargetRange, DAMAGE_MAGIC, false)
  RTS = TargetSelector(TARGET_LESS_CAST, RTargetRange, DAMAGE_MAGIC, false)
  STS = TargetSelector(TARGET_LOW_HP, S.range)
  
  EnemyHeroes = GetEnemyHeroes()
  EnemyMinions = minionManager(MINION_ENEMY, QMinionRange, myHero, MINION_SORT_MAXHEALTH_DEC)
  JungleMobs = minionManager(MINION_JUNGLE, QJunglemobRange, myHero, MINION_SORT_MAXHEALTH_DEC)
  
end

---------------------------------------------------------------------------------

function EzrealMenu()

  Menu = scriptConfig("HTTF Ezreal", "HTTF Ezreal")
  
  Menu:addSubMenu("HitChance Settings", "HitChance")
  
    Menu.HitChance:addSubMenu("Combo", "Combo")
      Menu.HitChance.Combo:addParam("Q", "Q HitChacne (Default value = 1.02)", SCRIPT_PARAM_SLICE, 1.02, 1, 3, 2)
      Menu.HitChance.Combo:addParam("W", "W HitChacne (Default value = 1.2)", SCRIPT_PARAM_SLICE, 1.2, 1, 3, 2)
      Menu.HitChance.Combo:addParam("R", "R HitChacne (Default value = 0.01)", SCRIPT_PARAM_SLICE, .01, .01, 3, 2)
      
    Menu.HitChance:addSubMenu("Harass", "Harass")
      Menu.HitChance.Harass:addParam("Q", "Q HitChacne (Default value = 1.4)", SCRIPT_PARAM_SLICE, 1.4, 1, 3, 2)
      Menu.HitChance.Harass:addParam("W", "W HitChacne (Default value = 1.4)", SCRIPT_PARAM_SLICE, 1.4, 1, 3, 2)
      
  Menu:addSubMenu("Combo Settings", "Combo")
    Menu.Combo:addParam("On", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
      Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Menu.Combo:addParam("Info", "Use Q if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("Q2", "Default value = 0", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
      Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    Menu.Combo:addParam("Info", "Use W if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("W2", "Default value = 30", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
      Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("R", "Use R (single target)", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("R2", "Use R (multiple target)", SCRIPT_PARAM_ONOFF, true)
    Menu.Combo:addParam("R3", "Use R min count", SCRIPT_PARAM_SLICE, 3, 2, 5, 0)
      Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("Item", "Use Items", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("BRK", "Use BRK if my own HP < x%", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
      
  Menu:addSubMenu("Clear Settings", "Clear")
  
    Menu.Clear:addSubMenu("Lane Clear Settings", "Farm")
      Menu.Clear.Farm:addParam("On", "Lane Claer", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
        Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      Menu.Clear.Farm:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.Clear.Farm:addParam("Info", "Use Q if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
      Menu.Clear.Farm:addParam("Q2", "Default value = 70", SCRIPT_PARAM_SLICE, 70, 0, 100, 0)
      
    Menu.Clear:addSubMenu("Jungle Clear Settings", "JFarm")
      Menu.Clear.JFarm:addParam("On", "Jungle Claer", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
        Menu.Clear.JFarm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      Menu.Clear.JFarm:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.Clear.JFarm:addParam("Info", "Use Q if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
      Menu.Clear.JFarm:addParam("Q2", "Default value = 0", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
      
  Menu:addSubMenu("Harass Settings", "Harass")
    Menu.Harass:addParam("On", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('C'))
    Menu.Harass:addParam("On2", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('H'))
      Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Menu.Harass:addParam("Info", "Use Q if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    Menu.Harass:addParam("Q2", "Default value = 0", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
      Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Harass:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    Menu.Harass:addParam("Info", "Use W if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    Menu.Harass:addParam("W2", "Default value = 40", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
    
  Menu:addSubMenu("LastHit Settings", "LastHit")
    Menu.LastHit:addParam("On", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
      Menu.LastHit:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.LastHit:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, false)
    Menu.LastHit:addParam("Info", "Use Q if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    Menu.LastHit:addParam("Q2", "Default value = 75", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
    
  Menu:addSubMenu("Jungle Steal Settings", "JSteal")
    Menu.JSteal:addParam("On", "Jungle Steal", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
    Menu.JSteal:addParam("On2", "Jungle Steal Toggle", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey('N'))
      Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.JSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    if Smite ~= nil then
      Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.JSteal:addParam("S", "Use Smite", SCRIPT_PARAM_ONOFF, true)
      Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.JSteal:addParam("Always", "Always Use Auto Q and Smite\n(Baron & Dragon)", SCRIPT_PARAM_ONOFF, true)
    else
      Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.JSteal:addParam("Always", "Always Use Auto Q\n(Baron & Dragon)", SCRIPT_PARAM_ONOFF, true)
    end
    
  Menu:addSubMenu("KillSteal Settings", "KillSteal")
    Menu.KillSteal:addParam("On", "KillSteal", SCRIPT_PARAM_ONOFF, true)
      Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    if Ignite ~= nil then
      Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("I", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
    end
    if Smite ~= nil then
      Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("S", "Use Stalker's Blade", SCRIPT_PARAM_ONOFF, true)
    end
    
  Menu:addSubMenu("Flee Settings", "Flee")
    Menu.Flee:addParam("On", "Flee (Only Use KillSteal)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('G'))
    
  Menu:addSubMenu("Misc Settings", "Misc")
    if VIP_USER then
    Menu.Misc:addParam("UsePacket", "Use Packet", SCRIPT_PARAM_ONOFF, true)
    end
    --Menu.Misc:addParam("AutoLevel", "Auto Level Spells", SCRIPT_PARAM_ONOFF, false)
    --Menu.Misc:addParam("ALOpt", "Skill order : ", SCRIPT_PARAM_LIST, 1, {"R>Q>W>E (QEWQ)"})
    
  Menu:addSubMenu("Draw Settings", "Draw")
  
    Menu.Draw:addSubMenu("Draw Target", "Target")
      Menu.Draw.Target:addParam("Q", "Draw Q Target", SCRIPT_PARAM_ONOFF, true)
      Menu.Draw.Target:addParam("W", "Draw W Target", SCRIPT_PARAM_ONOFF, false)
      Menu.Draw.Target:addParam("R", "Draw R Target", SCRIPT_PARAM_ONOFF, false)
      
    Menu.Draw:addSubMenu("Draw Predicted Position", "PP")
      Menu.Draw.PP:addParam("Q", "Draw Q Pos", SCRIPT_PARAM_ONOFF, true)
      Menu.Draw.PP:addParam("W", "Draw W Pos", SCRIPT_PARAM_ONOFF, false)
      Menu.Draw.PP:addParam("R", "Draw R Pos", SCRIPT_PARAM_ONOFF, false)
      Menu.Draw.PP:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      Menu.Draw.PP:addParam("Line", "Draw Line to Pos", SCRIPT_PARAM_ONOFF, true)
      
    Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    
    Menu.Draw:addParam("On", "Draw", SCRIPT_PARAM_ONOFF, true)
      Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("AA", "Draw Attack range", SCRIPT_PARAM_ONOFF, true)
    Menu.Draw:addParam("Q", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
    Menu.Draw:addParam("W", "Draw W range", SCRIPT_PARAM_ONOFF, false)
    Menu.Draw:addParam("E", "Draw E range", SCRIPT_PARAM_ONOFF, false)
    if Ignite ~= nil then
      Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("I", "Draw Ignite range", SCRIPT_PARAM_ONOFF, false)
    end
    if Smite ~= nil then
      Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("S", "Draw Smite range", SCRIPT_PARAM_ONOFF, true)
    end
      Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("Path", "Draw Move Path", SCRIPT_PARAM_ONOFF, false)
      Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("Hitchance", "Draw Hitchance", SCRIPT_PARAM_ONOFF, true)
    
  Menu.Combo.On = false
  Menu.Clear.Farm.On = false
  Menu.Clear.JFarm.On = false
  Menu.Harass.On = false
  Menu.Harass.On2 = false
  Menu.LastHit.On = false
  Menu.JSteal.On = false
  Menu.JSteal.On2 = false
  Menu.Flee.On = false
  
end

---------------------------------------------------------------------------------

function Orbwalk()

  if _G.AutoCarry then
  
    if _G.Reborn_Initialised then
      RebornLoaded = true
      ScriptMsg("Found SAC: Reborn.")
    else
      RevampedLoaded = true
      ScriptMsg("Found SAC: Revamped.")
    end
    
  elseif _G.Reborn_Loaded then
    DelayAction(Orbwalk, 1)
  elseif _G.MMA_Loaded then
    MMALoaded = true
    ScriptMsg("Found MMA.")
  elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
  
    require 'SxOrbWalk'
    
    SxOrbMenu = scriptConfig("SxOrb Settings", "SxOrb")
    
    SxOrb = SxOrbWalk()
    SxOrb:LoadToMenu(SxOrbMenu)
    
    SxOrbLoaded = true
    ScriptMsg("Found SxOrb.")
  elseif FileExist(LIB_PATH .. "SOW.lua") then
  
    require 'SOW'
    require 'VPrediction'
    
    VP = VPrediction()
    SOWVP = SOW(VP)
    
    Menu:addSubMenu("Orbwalk Settings (SOW)", "Orbwalk")
      Menu.Orbwalk:addParam("Info", "SOW settings", SCRIPT_PARAM_INFO, "")
      Menu.Orbwalk:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      SOWVP:LoadToMenu(Menu.Orbwalk)
      
    SOWLoaded = true
    ScriptMsg("Found SOW.")
  else
    ScriptMsg("Orbwalk not founded.")
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function OnTick()

  if myHero.dead then
    return
  end
  
  Checks()
  Targets()
  
  if Menu.Combo.On then
    Combo()
  end
  
  if Menu.Clear.Farm.On then
    Farm()
  end
  
  if Menu.Clear.JFarm.On then
    JFarm()
  end
  
  if Menu.Harass.On or (Menu.Harass.On2 and not IsRecall) then
    Harass()
  end
  
  if Menu.LastHit.On then
    LastHit()
  end
  
  if Menu.JSteal.On or Menu.JSteal.On2 then
    JSteal()
  end
  
  if Menu.JSteal.Always then
    JstealAlways()
  end
  
  if Menu.KillSteal.On then
    KillSteal()
  end
  
  if Menu.Flee.On then
    Flee()
  end
  
  if Menu.Misc.AutoLevel then
    AutoLevel()
  end
  
end

---------------------------------------------------------------------------------

function Checks()

  Q.ready = myHero:CanUseSpell(_Q) == READY
  W.ready = myHero:CanUseSpell(_W) == READY
  E.ready = myHero:CanUseSpell(_E) == READY
  R.ready = myHero:CanUseSpell(_R) == READY
  I.ready = Ignite ~= nil and myHero:CanUseSpell(Ignite) == READY
  S.ready = Smite ~= nil and myHero:CanUseSpell(Smite) == READY
  
  for _, item in pairs(Items) do
    item.slot = GetInventorySlotItem(item.id)
  end
  
  Items["BC"].ready = Items["BC"].slot and myHero:CanUseSpell(Items["BC"].slot) == READY
  Items["BRK"].ready = Items["BRK"].slot and myHero:CanUseSpell(Items["BRK"].slot) == READY
  Items["Stalker"].ready = Smite ~= nil and (Items["Stalker"].slot or Items["StalkerW"].slot or Items["StalkerM"].slot or Items["StalkerJ"].slot or Items["StalkerD"].slot) and myHero:CanUseSpell(Smite) == READY
  
  Q.level = myHero:GetSpellData(_Q).level
  W.level = myHero:GetSpellData(_W).level
  E.level = myHero:GetSpellData(_E).level
  R.level = myHero:GetSpellData(_R).level
  
  EnemyMinions:update()
  JungleMobs:update()
  
end

---------------------------------------------------------------------------------

function Targets()

  local Target = nil
  
  if RebornLoaded then
    Target = _G.AutoCarry.Crosshair:GetTarget()
  elseif RevampedLoaded then
    Target = _G.AutoCarry.Orbwalker.target
  elseif MMALoaded then
    Target = _G.MMA_Target
  elseif SxOrbLoaded then
    Target = SxOrb:GetTarget()
  elseif SOWLoaded then
    Target = SOWVP:GetTarget()
  end
  
  if Target and Target.type == myHero.type and ValidTarget(Target, TrueRange(Target)) then
    QTarget = Target
    WTarget = Target
  else
    QTS:update()
    WTS:update()
    QTarget = QTS.target
    WTarget = WTS.target
  end
  
  RTS:update()
  STS:update()
  RTarget = RTS.target
  STarget = STS.target
end

---------------------------------------------------------------------------------

function OrbwalkCanMove()

  if RebornLoaded then
    return _G.AutoCarry.Orbwalker:CanMove()
  elseif MMALoaded then
    return _G.MMA_AbleToMove
  elseif SxOrbLoaded then
    return SxOrb:CanMove()
  elseif SOWLoaded then
    return SOWVP:CanMove()
    --return SOW:CanMove()
  end
  
end

---------------------------------------------------------------------------------

function OrbReset()

  if RebornLoaded then
    --_G.AutoCarry.Orbwalker:ResetAttackTimer
    _G.AutoCarry.MyHero:AttacksEnabled(true)
  elseif RevampedLoaded then
  elseif MMALoaded then
    _G.MMA_ResetAutoAttack()
  elseif SxOrbLoaded then
    SxOrb:ResetAA()
  elseif SOWLoaded then
    SOWVP:resetAA()
    --SOW:resetAA()
  end
  
end

---------------------------------------------------------------------------------

function Combo()

  if QTarget ~= nil then
  
  local ComboQ = Menu.Combo.Q
  local ComboQ2 = Menu.Combo.Q2
  
    if Q.ready and ComboQ and ComboQ2 <= ManaPercent() then
      QHitChance = -1
      
      if ValidTarget(QTarget, Q.range+100) then
        CastQ(QTarget, "Combo")
      end
      
      if QHitChance == nil or QHitChance == 0 then
      
        for i, enemy in ipairs(EnemyHeroes) do
        
          if ValidTarget(enemy, Q.range+100) then
            CastQ(enemy, "Combo")
          end
          
        end
        
      end
      
    end
    
  end
  
  if WTarget ~= nil then
  
    local ComboW = Menu.Combo.W
    local ComboW2 = Menu.Combo.W2
    
    if W.ready and ComboW and ComboW2 <= ManaPercent() and ValidTarget(WTarget, W.range+100) then
      CastW(WTarget, "Combo")
    end
    
  end
  
  if RTarget ~= nil then
  
    local ComboR = Menu.Combo.R
    local ComboR2 = Menu.Combo.R2
    local QTargetDmg = Q.ready and ValidTarget(RTarget, Q.range+100) and GetDmg("Q", RTarget) or 0
    local WTargetDmg = W.ready and ValidTarget(RTarget, W.range+100) and GetDmg("W", RTarget) or 0
    local RTargetDmg = GetDmg("R", RTarget)
    
    if R.ready and ValidTarget(RTarget, R.range+100) then
    
      if ComboR and QTargetDmg+WTargetDmg+RTargetDmg >= RTarget.health then
        CastR(RTarget, "Combo")
      end
      
      if ComboR2 then
        CastR(RTarget, "Combo2")
      end
      
    end
    
  end
  
  if STarget ~= nil then
  
    local ComboItem = Menu.Combo.Item
    
    if ComboItem then
    
      local ComboBRK = Menu.Combo.BRK
      local BCSTargetDmg = GetDmg("BC", STarget)
      local BRKSTargetDmg = GetDmg("BRK", STarget)
      
      if Items["Stalker"].ready and ValidTarget(STarget, S.range) then
        CastS(STarget)
      end
      
      if ComboBRK >= HealthPercent() then
      
        if Items["BC"].ready and ValidTarget(STarget, Items["BC"].range) then
          CastBC(STarget)
        elseif Items["BRK"].ready and ValidTarget(STarget, Items["BRK"].range) then
          CastBRK(STarget)
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function Farm()

  local FarmQ = Menu.Clear.Farm.Q
  local FarmQ2 = Menu.Clear.Farm.Q2
  
  if Q.ready and FarmQ and FarmQ2 <= ManaPercent() then
    
    for i, minion in pairs(EnemyMinions.objects) do
    
      local QMinionDmg = GetDmg("Q", minion)
      
      if QMinionDmg >= minion.health and ValidTarget(minion, Q.range+100) then
        CastQ(minion, "LastHit")
      end
      
    end
    
    for i, minion in pairs(EnemyMinions.objects) do
    
      local AAMinionDmg = GetDmg("AA", minion)
      local QMinionDmg = GetDmg("Q", minion)
      
      if QMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, Q.range+100) then
        CastQ(minion)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function JFarm()

  local JFarmQ = Menu.Clear.JFarm.Q
  local JFarmQ2 = Menu.Clear.JFarm.Q2
  
  if Q.ready and JFarmQ and JFarmQ2 <= ManaPercent() then
  
    for i, junglemob in pairs(JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #FocusJungleNames do
        if junglemob.name == FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= Q.range and ValidTarget(LargeJunglemob, Q.range+100) then
        CastQ(LargeJunglemob)
      end
      
    end
    
    for i, junglemob in pairs(JungleMobs.objects) do
    
      if ValidTarget(junglemob, Q.range+100) then
        CastQ(junglemob)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function Harass()

  if QTarget ~= nil then
  
    local HarassQ = Menu.Harass.Q
    local HarassQ2 = Menu.Harass.Q2
    
    if Q.ready and HarassQ and HarassQ2 <= ManaPercent() then
      QHitChance = -1
      
      if ValidTarget(QTarget, Q.range+100) then
        CastQ(QTarget, "Harass")
      end
      
      if QHitChance == nil or QHitChance == 0 then
      
        for i, enemy in ipairs(EnemyHeroes) do
        
          if ValidTarget(enemy, Q.range+100) then
            CastQ(enemy, "Harass")
          end
          
        end
        
      end
      
    end
    
  end
  
  if WTarget ~= nil then
  
    local HarassW = Menu.Harass.W
    local HarassW2 = Menu.Harass.W2
    
    if W.ready and HarassW and HarassW2 <= ManaPercent() and ValidTarget(WTarget, W.range+100) then
      CastW(WTarget, "Harass")
    end
    
  end
  
end

---------------------------------------------------------------------------------

function LastHit()

  local LastHitQ = Menu.LastHit.Q
  local LastHitQ2 = Menu.LastHit.Q2
  
  if Q.ready and LastHitQ and LastHitQ2 <= ManaPercent() then
  
    for i, minion in pairs(EnemyMinions.objects) do
    
      local QMinionDmg = GetDmg("Q", minion)
      
      if QMinionDmg >= minion.health and ValidTarget(minion, Q.range+100) then
        CastQ(minion, "LastHit")
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function JSteal()

  local JStealQ = Menu.JSteal.Q
  local JStealS = Menu.JSteal.S
  
  if S.ready and JStealS then
  
    for i, junglemob in pairs(JungleMobs.objects) do
    
      local SJunglemobDmg = GetDmg("SMITE", junglemob)
      
      for j = 1, #FocusJungleNames do
      
        if junglemob.name == FocusJungleNames[j] and SJunglemobDmg >= junglemob.health and ValidTarget(junglemob, S.range) then
          CastS(junglemob)
          return
        end
        
      end
      
    end
    
  end
  
  if Q.ready and JStealQ then
  
    for i, junglemob in pairs(JungleMobs.objects) do
    
      local QJunglemobDmg = GetDmg("Q", junglemob)
      
      for j = 1, #FocusJungleNames do
      
        if junglemob.name == FocusJungleNames[j] and QJunglemobDmg >= junglemob.health and ValidTarget(junglemob, Q.range+100) then
          CastQ(junglemob, "JSteal")
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function JstealAlways()
  
  if S.ready then
  
    for i, junglemob in pairs(JungleMobs.objects) do
    
      local SJunglemobDmg = GetDmg("SMITE", junglemob)
      
      for j = 1, #FocusJungleNames do
      
        if (junglemob.name == "SRU_Baron12.1.1" or junglemob.name == "SRU_Dragon6.1.1") and SJunglemobDmg >= junglemob.health and ValidTarget(junglemob, S.range) then
          CastS(junglemob)
          return
        end
        
      end
      
    end
    
  end
  
  if Q.ready then
  
    for i, junglemob in pairs(JungleMobs.objects) do
    
      local QJunglemobDmg = GetDmg("Q", junglemob)
      
      for j = 1, #FocusJungleNames do
      
        if (junglemob.name == "SRU_Baron12.1.1" or junglemob.name == "SRU_Dragon6.1.1") and QJunglemobDmg >= junglemob.health and ValidTarget(junglemob, Q.range+100) then
          CastQ(junglemob, "JSteal")
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function KillSteal()

  local KillStealQ = Menu.KillSteal.Q
  local KillStealW = Menu.KillSteal.W
  local KillStealI = Menu.KillSteal.I
  local KillStealS = Menu.KillSteal.S
  
  for i, enemy in ipairs(EnemyHeroes) do
  
    local QTargetDmg = GetDmg("Q", enemy)
    local WTargetDmg = GetDmg("W", enemy)
    local ITargetDmg = GetDmg("IGNITE", enemy)
    local SBTargetDmg = GetDmg("STALKER", enemy)
    
    if I.ready and KillStealI and ITargetDmg >= enemy.health and ValidTarget(enemy, I.range) then
      CastI(enemy)
    end
    
    if Items["Stalker"].ready and KillStealS and SBTargetDmg >= enemy.health and ValidTarget(enemy, S.range) then
      CastS(enemy)
      return
    end
    
    if Q.ready and KillStealQ and QTargetDmg >= enemy.health and ValidTarget(enemy, Q.range+100) then
      CastQ(enemy, "KillSteal")
    end
    
    if W.ready and KillStealW and WTargetDmg >= enemy.health and ValidTarget(enemy, W.range+100) then
      CastW(enemy, "KillSteal")
    end
    
  end
  
end

---------------------------------------------------------------------------------

function Flee()

  FleePos = myHero+(Vector(mousePos)-myHero):normalized()*300
  
  CastE(FleePos)
  MoveToMouse()
  
end

---------------------------------------------------------------------------------

function AutoLevel()

  if Menu.Misc.ALOpt == 1 then
  
    if Q.level+W.level+E.level+R.level < myHero.level then
    
      local spell = {SPELL_1, SPELL_2, SPELL_3, SPELL_4}
      local level = {0, 0, 0, 0}
      
      for i = 1, myHero.level do
        level[AutoQEWQ[i]] = level[AutoQEWQ[i]]+1
      end
      
      for i, j in ipairs({Q.level, W.level, E.level, R.level}) do
      
        if j < level[i] then
          LevelSpell(spell[i])
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HealthPercent()
  return (myHero.health/myHero.maxHealth)*100
end

function ManaPercent()
  return (myHero.mana/myHero.maxMana)*100
end

---------------------------------------------------------------------------------

function AddRange(unit)
  return unit.boundingRadius
end

function TrueRange(enemy)
  return myHero.range+AddRange(myHero)+AddRange(enemy)
end

---------------------------------------------------------------------------------

function GetDmg(spell, enemy)

  if enemy.health == 0 then
    return 0
  end
  
  local ADDmg = 0
  local APDmg = 0
  
  local Level = myHero.level
  local TotalDmg = myHero.totalDamage
  local AddDmg = myHero.addDamage
  local AP = myHero.ap
  local ArmorPen = myHero.armorPen
  local ArmorPenPercent = myHero.armorPenPercent
  local MagicPen = myHero.magicPen
  local MagicPenPercent = myHero.magicPenPercent
  
  local Armor = math.max(0, enemy.armor*ArmorPenPercent-ArmorPen)
  local ArmorPercent = Armor/(100+Armor)
  local MagicArmor = math.max(0, enemy.magicArmor*MagicPenPercent-MagicPen)
  local MagicArmorPercent = MagicArmor/(100+MagicArmor)
  
  if spell == "IGNITE" then
  
    local TrueDmg = 50+20*Level
    
    return TrueDmg
  elseif spell == "SMITE" then
  
    if Level <= 4 then
    
      local TrueDmg = 370+20*Level
      
      return TrueDmg
    elseif Level <= 9 then
    
      local TrueDmg = 330+30*Level
      
      return TrueDmg
    elseif Level <= 14 then
    
      local TrueDmg = 240+40*Level
      
      return TrueDmg
    else
    
      local TrueDmg = 100+50*Level
      
      return TrueDmg
    end
    
  elseif spell == "STALKER" then
  
    local TrueDmg = 20+8*Level
    
    return TrueDmg
  elseif spell == "BC" then
    APDmg = 100
  elseif spell == "BRK" then
    ADDmg = math.max(100, .1*enemy.maxHealth)
  elseif spell == "AA" then
    ADDmg = TotalDmg
  elseif spell == "Q" then
    ADDmg = 20*Q.level+15+1.1*TotalDmg+.4*AP    
  elseif spell == "W" then
    APDmg = 45*W.level+25+.8*AP
  elseif spell == "E" then
    APDmg = 50*E.level+25+.75*AP
  elseif spell == "R" then
    APDmg = 200*R.level+150+AddDmg+.9*AP
  end
  
  local TrueDmg = ADDmg*(1-ArmorPercent)+APDmg*(1-MagicArmorPercent)
  
  return TrueDmg
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function CastQ(unit, mode)

  if unit.dead or mode ~= "LastHit" and mode ~= "JSteal" and mode ~= "KillSteal" and not OrbwalkCanMove() then
    return
  end
  
  QPos, QHitChance = HPred:GetPredict(HPred.Presets["Ezreal"]["Q"], unit, myHero)
  
  if mode == "Combo" and QHitChance >= Menu.HitChance.Combo.Q or mode == "Harass" and QHitChance >= Menu.HitChance.Harass.Q or (mode == "LastHit" or mode == "JSteal" or mode == "KillSteal" or mode == nil) and QHitChance >= 1 then
  
    if VIP_USER and Menu.Misc.UsePacket then
      Packet("S_CAST", {spellId = _Q, toX = QPos.x, toY = QPos.z, fromX = QPos.x, fromY = QPos.z}):send()
    else
      CastSpell(_Q, QPos.x, QPos.z)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function CastW(unit, mode)

  if unit.dead or mode ~= "KillSteal" and not OrbwalkCanMove() then
    return
  end
  
  WPos, WHitChance = HPred:GetPredict(HPred.Presets["Ezreal"]["W"], unit, myHero)
  
  if mode == "Combo" and WHitChance >= Menu.HitChance.Combo.W or mode == "Harass" and WHitChance >= Menu.HitChance.Harass.W or (mode == "KillSteal" or mode == nil) and WHitChance >= 1 then
  
    if VIP_USER and Menu.Misc.UsePacket then
      Packet("S_CAST", {spellId = _W, toX = WPos.x, toY = WPos.z, fromX = WPos.x, fromY = WPos.z}):send()
    else
      CastSpell(_W, WPos.x, WPos.z)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function CastE(pos)

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _E, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send()
  else
    CastSpell(_E, pos.x, pos.z)
  end
  
end

---------------------------------------------------------------------------------

function CastR(unit, mode)

  if unit.dead then
    return
  end
  
  local ComboR3 = Menu.Combo.R3
  
  if mode == "Combo2" then
    RPos, RHitChance, RNoH = HPred:GetPredict(HPred.Presets["Ezreal"]["R"], unit, myHero, true)
  else
    RPos, RHitChance = HPred:GetPredict(HPred.Presets["Ezreal"]["R"], unit, myHero)
  end
  
  if mode == "Combo" and RHitChance >= Menu.HitChance.Combo.R or mode == "Combo2" and RNoH >= ComboR3 or mode == nil and RHitChance >= 0.01 then
  
    if VIP_USER and Menu.Misc.UsePacket then
      Packet("S_CAST", {spellId = _R, toX = RPos.x, toY = RPos.z, fromX = RPos.x, fromY = RPos.z}):send()
    else
      CastSpell(_R, RPos.x, RPos.z)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function CastI(enemy)

  if enemy.dead then
    return
  end
  
  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = Ignite, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(Ignite, enemy)
  end
  
end

---------------------------------------------------------------------------------

function CastS(enemy)

  if enemy.dead then
    return
  end
  
  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = Smite, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(Smite, enemy)
  end
  
end

---------------------------------------------------------------------------------

function CastBC(enemy)

  if enemy.dead then
    return
  end
  
  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = Items["BC"].slot, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(Items["BC"].slot, enemy)
  end
  
end

---------------------------------------------------------------------------------

function CastBRK(enemy)

  if enemy.dead then
    return
  end
  
  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = Items["BRK"].slot, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(Items["BRK"].slot, enemy)
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function MoveToMouse()

  if mousePos and GetDistance(mousePos) <= 100 then
    MousePos = myHero+(Vector(mousePos)-myHero):normalized()*300
  else
    MousePos = mousePos
  end
  
  myHero:MoveTo(MousePos.x, MousePos.z)
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function OnDraw()

  if not Menu.Draw.On or myHero.dead then
    return
  end
  
  if Menu.Harass.On or Menu.Harass.On2 then
    DrawText("Harass: On", 20, 1600, 150, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  else
    DrawText("Harass: Off", 20, 1600, 150, ARGB(0xFF, 0xFF, 0x80, 0x80))
  end
  
  if Menu.JSteal.On or Menu.JSteal.On2 then
    DrawText("Jungle Steal: On", 20, 1600, 200, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  else
    DrawText("Jungle Steal: Off", 20, 1600, 200, ARGB(0xFF, 0x80, 0x80, 0xFF))
  end
  
  if Menu.Draw.Target.Q and QTarget ~= nil then
    DrawCircle(QTarget.x, QTarget.y, QTarget.z, Q.width/2, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if Menu.Draw.Target.W and WTarget ~= nil then
    DrawCircle(WTarget.x, WTarget.y, WTarget.z, W.width/2, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if Menu.Draw.Target.R and RTarget ~= nil then
    DrawCircle(RTarget.x, RTarget.y, RTarget.z, R.width/2, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if QHitChance ~= nil then
  
    if QHitChance == -1 then
      Qcolor = ARGB(0xFF, 0x00, 0x00, 0x00)
    elseif QHitChance < 1 then
      Qcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    elseif QHitChance == 3 then
      Qcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    elseif QHitChance >= 2 then
      Qcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
    elseif QHitChance >= 1 then
      Qcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
    end
  
  end
  
  if WHitChance ~= nil then
  
    if WHitChance < 1 then
      Wcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    elseif WHitChance == 3 then
      Wcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    elseif WHitChance >= 2 then
      Wcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
    elseif WHitChance >= 1 then
      Wcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
    end
    
  end
  
  if RHitChance ~= nil then
  
    if RHitChance < 1 then
      Rcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    elseif RHitChance == 3 then
      Rcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    elseif RHitChance >= 2 then
      Rcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
    elseif RHitChance >= 1 then
      Rcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
    end
    
  end
  
  if Menu.Draw.PP.Q and QPos ~= nil then
  
    DrawCircle(QPos.x, QPos.y, QPos.z, Q.width/2, Qcolor)
    
    if Menu.Draw.PP.Line then
      DrawLine3D(myHero.x, myHero.y, myHero.z, QPos.x, QPos.y, QPos.z, 2, Qcolor)
    end
    
    QPos = nil
  end
  
  if Menu.Draw.PP.W and WPos ~= nil then
  
    DrawCircle(WPos.x, WPos.y, WPos.z, W.width/2, Wcolor)
    
    if Menu.Draw.PP.Line then
      DrawLine3D(myHero.x, myHero.y, myHero.z, WPos.x, WPos.y, WPos.z, 2, Wcolor)
    end
    
    WPos = nil
  end
  
  if Menu.Draw.PP.R and RPos ~= nil then
  
    DrawCircle(RPos.x, RPos.y, RPos.z, R.width/2, Rcolor)
    
    if Menu.Draw.PP.Line then
      DrawLine3D(myHero.x, myHero.y, myHero.z, RPos.x, RPos.y, RPos.z, 2, Rcolor)
    end
    
    RPos = nil
  end
  
  if Menu.Draw.Hitchance then
  
    if QHitChance ~= nil then
      DrawText("Q HitChance: "..QHitChance, 20, 1250, 550, Qcolor)
      QHitChance = nil
    end
    
    if WHitChance ~= nil then
      DrawText("W HitChance: "..WHitChance, 20, 1250, 600, Wcolor)
      WHitChance = nil
    end
    
    if RHitChance ~= nil then
      DrawText("R HitChance: "..RHitChance, 20, 1250, 650, Rcolor)
      RHitChance = nil
    end
    
  end
  
  if Menu.Draw.AA then
    DrawCircle(myHero.x, myHero.y, myHero.z, myHero.range+myHero.boundingRadius, ARGB(0xFF, 0, 0xFF, 0))
  end
  
  if Menu.Draw.Q then
    DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if Menu.Draw.W then
    DrawCircle(myHero.x, myHero.y, myHero.z, W.range, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if Menu.Draw.E and E.ready then
    DrawCircle(myHero.x, myHero.y, myHero.z, E.range, ARGB(0xFF, 0x00, 0x00, 0xFF))
  end
  
  if Menu.Draw.I and I.ready then
    DrawCircle(myHero.x, myHero.y, myHero.z, I.range, ARGB(0xFF, 0xFF, 0x24, 0x24))
  end
  
  if Menu.Draw.S and S.ready and (Menu.JSteal.On or Menu.JSteal.On2) and Menu.JSteal.S then
    DrawCircle(myHero.x, myHero.y, myHero.z, S.range, ARGB(0xFF, 0xFF, 0x14, 0x93))
  end
  
  if Menu.Draw.Path then
  
    if myHero.hasMovePath and myHero.pathCount >= 2 then
    
      local IndexPath = myHero:GetPath(myHero.pathIndex)
      
      if IndexPath then
        DrawLine3D(myHero.x, myHero.y, myHero.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 255, 255, 255))
      end
      
      for i=myHero.pathIndex, myHero.pathCount-1 do
      
        local Path = myHero:GetPath(i)
        local Path2 = myHero:GetPath(i+1)
        
        DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 255))
      end
      
    end
    
    for i, enemy in ipairs(EnemyHeroes) do
    
      if enemy == nil then
        return
      end
      
      if enemy.hasMovePath and enemy.pathCount >= 2 then
      
        local IndexPath = enemy:GetPath(enemy.pathIndex)
        
        if IndexPath then
          DrawLine3D(enemy.x, enemy.y, enemy.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 255, 255, 255))
        end
        
        for i=enemy.pathIndex, enemy.pathCount-1 do
        
          local Path = enemy:GetPath(i)
          local Path2 = enemy:GetPath(i+1)
          
          DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 255))
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function OnAnimation(unit, animation)

  if not unit.isMe then
    return
  end
  
  if animation == "recall" then
    IsRecall = true
  elseif animation == "recall_winddown" or animation == "Run" or animation == "Spell1" or animation == "Spell2" or animation == "Spell3" or animation == "Spell4" then
    IsRecall = false
  end
  
end

---------------------------------------------------------------------------------

function OnProcessSpell(object, spell)

  if spell.target and spell.target.isMe and spell.name == "SummonerExhaust" then
    --1.5
  elseif spell.target and spell.target.isMe and spell.name == "Wither" then
    --1.35
  end
  
  if not object.isMe then
    return
  end
  
  if spell.name == "EzrealMysticShot" then
    QWindUpTime = spell.windUpTime
    DelayAction(OrbReset, QWindUpTime+GetLatency()/2000)
  elseif spell.name == "EzrealEssenceFlux" then
    WWindUpTime = spell.windUpTime
    DelayAction(OrbReset, WWindUpTime+GetLatency()/2000)
  end
  
end
