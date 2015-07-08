Version = "1.241"
AutoUpdate = true

if myHero.charName ~= "Vladimir" then
  return
end

require 'SourceLib'
require 'VPrediction'

function ScriptMsg(msg)
  print("<font color=\"#00fa9a\"><b>HTTF Vladimir:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>")
end

----------------------------------------------------------------------------------------------------

Host = "raw.github.com"

ScriptFilePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME

ScriptPath = "/BolHTTF/BoL/master/HTTF/HttfVladimir.lua".."?rand="..math.random(1,10000)
UpdateURL = "https://"..Host..ScriptPath

VersionPath = "/BolHTTF/BoL/master/HTTF/Version/HttfVladimir.version".."?rand="..math.random(1,10000)
VersionData = GetWebResult(Host, VersionPath)
Versiondata = tonumber(VersionData)

if AutoUpdate then

  if VersionData then
    ServerVersion = type(Versiondata) == "number" and Versiondata or nil
    
    if ServerVersion then
    
      if tonumber(Version) < ServerVersion then
        ScriptMsg("New version available: v"..VersionData)
        ScriptMsg("Updating, please don't press F9.")
        DelayAction(function() DownloadFile(UpdateURL, ScriptFilePath, function () ScriptMsg("Successfully updated.: v"..Version.." => v"..VersionData..", Press F9 twice to load the updated version.") end) end, 3)
      else
        ScriptMsg("You've got the latest version: v"..VersionData)
      end
      
    end
    
  else
    ScriptMsg("Error downloading version info.")
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function OnLoad()

  Variables()
  VladimirMenu()
  DelayAction(Orbwalk, 1)
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function Variables()

  RebornLoaded, RevampedLoaded, MMALoaded, SOWLoaded = false, false, false, false
  Target = nil
  Player = GetMyHero()
  EnemyHeroes = GetEnemyHeroes()
  
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
  
  BlockComboR = false
  DebugClock = os.clock()
  LastE = os.clock()
  LastSkin = 0
  Recall = false
  
  Q = {delay = 0, range = 600, speed = 1400, ready, level = 0}
  W = {delay = 0, radius = 350, speed = 1600, ready, level = 0}
  E = {delay = 0, radius = 0, range = 610, speed = 1100, ready, level = 0, stack = 0}
  R = {delay = 0, radius = 375, range = 625, speed = math.huge, ready, level = 0}
  I = {range = 600, ready}
  S = {range = 760, ready}
  Z = {range = 1000, ready}
  
  Items =
  {
  ["Stalker"] = {id=3706, slot = nil, ready},
  ["StalkerW"] = {id=3707, slot = nil},
  ["StalkerM"] = {id=3708, slot = nil},
  ["StalkerJ"] = {id=3709, slot = nil},
  ["StalkerD"] = {id=3710, slot = nil}
  }
  
  MyminBBox = 56.92
  TrueRange = myHero.range + MyminBBox
  
  MaxRrange = R.range + R.radius
  
  QrangeSqr = Q.range*Q.range
  ErangeSqr = E.range*E.range
  RradiusSqr = R.radius*R.radius
  RrangeSqr = R.range*R.range
  MaxRrangeSqr = (R.range+R.radius)*(R.range+R.radius)
  IrangeSqr = I.range*I.range
  
  AutoQEWQ = {1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2}
  AutoQWEQ = {1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2}
  
  S5SR = false
  TT = false
  
  if GetGame().map.index == 15 then -- S5 Summoner's Rift, summonerRift
    S5SR = true
  elseif GetGame().map.index == 4 then -- A, B 
    TT = true
  end
  
  if S5SR then
    FocusJungleNames =
    {
    ["Dragon6.1.1"] = true,
    ["Worm12.1.1"] = true,
    ["GiantWolf8.1.1"] = true,
    ["AncientGolem7.1.1"] = true,
    ["Wraith9.1.1"] = true,
    ["LizardElder10.1.1"] = true,
    ["Golem11.1.2"] = true,
    ["GiantWolf2.1.1"] = true,
    ["AncientGolem1.1.1"] = true,
    ["Wraith3.1.1"] = true,
    ["LizardElder4.1.1"] = true,
    ["Golem5.1.2"] = true,
    ["GreatWraith13.1.1"] = true,
    ["GreatWraith14.1.1"] = true
    }
  JungleMobNames =
    {
    ["Wolf8.1.2"] = true,
    ["Wolf8.1.3"] = true,
    ["YoungLizard7.1.2"] = true,
    ["YoungLizard7.1.3"] = true,
    ["LesserWraith9.1.3"] = true,
    ["LesserWraith9.1.2"] = true,
    ["LesserWraith9.1.4"] = true,
    ["YoungLizard10.1.2"] = true,
    ["YoungLizard10.1.3"] = true,
    ["SmallGolem11.1.1"] = true,
    ["Wolf2.1.2"] = true,
    ["Wolf2.1.3"] = true,
    ["YoungLizard1.1.2"] = true,
    ["YoungLizard1.1.3"] = true,
    ["LesserWraith3.1.3"] = true,
    ["LesserWraith3.1.2"] = true,
    ["LesserWraith3.1.4"] = true,
    ["YoungLizard4.1.2"] = true,
    ["YoungLizard4.1.3"] = true,
    ["SmallGolem5.1.1"] = true
    }
  elseif TT then
    FocusJungleNames =
    {
    ["TT_NWraith1.1.1"] = true,
    ["TT_NGolem2.1.1"] = true,
    ["TT_NWolf3.1.1"] = true,
    ["TT_NWraith4.1.1"] = true,
    ["TT_NGolem5.1.1"] = true,
    ["TT_NWolf6.1.1"] = true,
    ["TT_Spiderboss8.1.1"] = true
    }   
    JungleMobNames =
    {
    ["TT_NWraith21.1.2"] = true,
    ["TT_NWraith21.1.3"] = true,
    ["TT_NGolem22.1.2"] = true,
    ["TT_NWolf23.1.2"] = true,
    ["TT_NWolf23.1.3"] = true,
    ["TT_NWraith24.1.2"] = true,
    ["TT_NWraith24.1.3"] = true,
    ["TT_NGolem25.1.1"] = true,
    ["TT_NWolf26.1.2"] = true,
    ["TT_NWolf26.1.3"] = true
    }
  end
  
  VP = VPrediction()
  QWETS = TargetSelector(TARGET_LESS_CAST, E.range, DAMAGE_MAGIC, false)
  RTS = TargetSelector(TARGET_LESS_CAST, MaxRrange, DAMAGE_MAGIC, false)
  
  EnemyMinions = minionManager(MINION_ENEMY, E.range, player, MINION_SORT_MAXHEALTH_DEC)
  JungleMobs = minionManager(MINION_JUNGLE, E.range, player, MINION_SORT_MAXHEALTH_DEC)
  
  if VIP_USER then
    PacketHandler:HookOutgoingPacket(Packet.headers.S_CAST, BlockR)
  end
  
end

function BlockR(unit)

  if Menu.Misc.BlockR and Packet(unit):get('spellId') == _R and HitRCount() == 0 then
    unit:Block()
  end
  
end

function HitRCount()

  local enemies = {}
  
  for _, enemy in ipairs(EnemyHeroes) do
  
    local Position = VP:GetPredictedPos(enemy, R.delay, R.speed, myHero, false)
    
    if ValidTarget(enemy) and _GetDistanceSqr(Position, mousePos) < RradiusSqr then
      table.insert(enemies, enemy)
    end
    
  end
  
  return #enemies, enemies
  
end

----------------------------------------------------------------------------------------------------

function VladimirMenu()

  Menu = scriptConfig("HTTF Vladimir", "HTTF Vladimir")
  
  --Menu:addSubMenu("Predict Settings", "Predict")
  
    --Menu.Predict:addParam("PdOpt", "Predict Settings (Reload Required)", SCRIPT_PARAM_LIST, 1, { "HPrediction", "VPrediction"})
    
  Menu:addSubMenu("Combo Settings", "Combo")
  
    Menu.Combo:addParam("On", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
      Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Info", "Use W if W damage > loss health * x%", SCRIPT_PARAM_INFO, "")
      Menu.Combo:addParam("W2", "Default value = 100", SCRIPT_PARAM_SLICE, 100, 0, 200, 0)
      Menu.Combo:addParam("Blank3", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Emin", "Use E Min Count", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
      Menu.Combo:addParam("Info", "Use E if Current Health > Max Health * x%", SCRIPT_PARAM_INFO, "")
      Menu.Combo:addParam("E2", "Default value = 10", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
      Menu.Combo:addParam("Blank4", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("R", "Use R Combo", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Info2", "Use R if Full Combo Damage * x% > Target Health", SCRIPT_PARAM_INFO, "")
      Menu.Combo:addParam("R2", "Default value = 90", SCRIPT_PARAM_SLICE, 90, 60, 120, 0)
      Menu.Combo:addParam("Rearly", "Use R early", SCRIPT_PARAM_ONOFF, false)
      Menu.Combo:addParam("DontR", "Do not use R if Killable with Q", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Blank5", "", SCRIPT_PARAM_INFO, "")
    Menu.Combo:addParam("AutoR", "Auto R on Combo", SCRIPT_PARAM_ONOFF, true)
      Menu.Combo:addParam("Rmin", "Auto R Min Count", SCRIPT_PARAM_SLICE, 3, 2, 5, 0)
      
  Menu:addSubMenu("Clear Settings", "Clear")  
  
    Menu.Clear:addSubMenu("Lane Clear Settings", "Farm")
    
      Menu.Clear.Farm:addParam("On", "Lane Claer", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
        Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      Menu.Clear.Farm:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.Clear.Farm:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
      Menu.Clear.Farm:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.Clear.Farm:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
        Menu.Clear.Farm:addParam("E2", "Default value = 30", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
        Menu.Clear.Farm:addParam("Emin", "Use E Min Count", SCRIPT_PARAM_SLICE, 4, 1, 15, 0)
        
    Menu.Clear:addSubMenu("Jungle Clear Settings", "JFarm")
    
      Menu.Clear.JFarm:addParam("On", "Jungle Claer", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
        Menu.Clear.JFarm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      Menu.Clear.JFarm:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Menu.Clear.JFarm:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
      Menu.Clear.JFarm:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
        Menu.Clear.JFarm:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
        Menu.Clear.JFarm:addParam("E2", "Default value = 20", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        Menu.Clear.JFarm:addParam("Emin", "Use E Min Count", SCRIPT_PARAM_SLICE, 1, 1, 4, 0)
        
  Menu:addSubMenu("Harass Settings", "Harass")
  
    Menu.Harass:addParam("On", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('C'))
      Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.Harass:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
    Menu.Harass:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
      Menu.Harass:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.Harass:addParam("E2", "Default value = 10", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
      Menu.Harass:addParam("Emin", "Use E Min Count", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
      
  Menu:addSubMenu("LastHit Settings", "LastHit")
  
    Menu.LastHit:addParam("On", "LastHit Key 1", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
    Menu.LastHit:addParam("On2", "LastHit Key 2", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
    Menu.LastHit:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.LastHit:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.LastHit:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
    Menu.LastHit:addParam("EQ", "Use EQ", SCRIPT_PARAM_ONOFF, false)
      Menu.LastHit:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.LastHit:addParam("E2", "Default value = 70", SCRIPT_PARAM_SLICE, 70, 0, 100, 0)
      
  Menu:addSubMenu("Jungle Steal Settings", "JSteal")
  
    Menu.JSteal:addParam("On", "Jungle Steal", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
      Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.JSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.JSteal:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
    Menu.JSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, false)
    Menu.JSteal:addParam("EQ", "Use EQ", SCRIPT_PARAM_ONOFF, false)
      Menu.JSteal:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.JSteal:addParam("E2", "Default value = 5", SCRIPT_PARAM_SLICE, 5, 0, 100, 0)
      
  Menu:addSubMenu("KillSteal Settings", "KillSteal")
  
    Menu.KillSteal:addParam("On", "KillSteal", SCRIPT_PARAM_ONOFF, true)
      Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      Menu.KillSteal:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
      Menu.KillSteal:addParam("Blank3", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
      Menu.KillSteal:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.KillSteal:addParam("E2", "Default value = 5", SCRIPT_PARAM_SLICE, 5, 0, 100, 0)
      Menu.KillSteal:addParam("Blank4", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, false)
      Menu.KillSteal:addParam("Blank5", "", SCRIPT_PARAM_INFO, "")
    Menu.KillSteal:addParam("I", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
    
  Menu:addSubMenu("AutoCast Settings", "Auto")
  
    Menu.Auto:addParam("On", "AutoCast", SCRIPT_PARAM_ONOFF, true)
      Menu.Auto:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Auto:addParam("AutoE", "Auto E", SCRIPT_PARAM_ONOFF, true)
      Menu.Auto:addParam("Info", "Auto E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.Auto:addParam("E2", "Default value = 30", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
      Menu.Auto:addParam("Emin", "Auto E Min Count", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
      Menu.Auto:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
    Menu.Auto:addParam("StackE", "Stack E (When not Combo, Harass)", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('T'))
      Menu.Auto:addParam("Info", "Use E if Current Health > Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.Auto:addParam("SE2", "Default value = 40", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
      Menu.Auto:addParam("Blank3", "", SCRIPT_PARAM_INFO, "")
    Menu.Auto:addParam("AutoR", "Auto R", SCRIPT_PARAM_ONOFF, true)
      Menu.Auto:addParam("Rmin", "Auto R Min Count", SCRIPT_PARAM_SLICE, 4, 2, 5, 0)
      Menu.Auto:addParam("Blank4", "", SCRIPT_PARAM_INFO, "")
    Menu.Auto:addParam("AutoZ", "Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
      Menu.Auto:addParam("Info", "Auto Zhonya if Current Health < Max health * x%", SCRIPT_PARAM_INFO, "")
      Menu.Auto:addParam("Z", "Default value = 20", SCRIPT_PARAM_SLICE, 20  , 0, 100, 0)
      Menu.Auto:addParam("Zmin", "Auto Zhonya Min Enemy Count", SCRIPT_PARAM_SLICE, 0, 0, 5, 0)
      if Smite ~= nil then
        Menu.Auto:addParam("Blank5", "", SCRIPT_PARAM_INFO, "")
      Menu.Auto:addParam("AutoS", "Auto Smite", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey('N'))
      end
      
  Menu:addSubMenu("Flee Settings", "Flee")
  
    Menu.Flee:addParam("On", "Flee (Only Use KillSteal & Auto R)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('G'))
      Menu.Flee:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Flee:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    
  Menu:addSubMenu("Misc Settings", "Misc")
  
    if VIP_USER then
    Menu.Misc:addParam("UsePacket", "Use Packet", SCRIPT_PARAM_ONOFF, true)
      Menu.Misc:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    --[[Menu.Misc:addParam("Skin", "Use Skin hack", SCRIPT_PARAM_ONOFF, false)
    Menu.Misc:addParam("SkinOpt", "Skin list : ", SCRIPT_PARAM_LIST, 7, { "Count Vladimir", "Marquis Vladimir", "Nosferatu Vladimir", "Vandal Vladimir", "Blood Lord Vladimir", "Soulstealer Vladmir", "Classic"})
      Menu.Misc:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")]]
    end
    --[[Menu.Misc:addParam("AutoLevel", "Auto Level Spells", SCRIPT_PARAM_ONOFF, true)
    Menu.Misc:addParam("ALOpt", "Skill order : ", SCRIPT_PARAM_LIST, 1, { "R>Q>E>W (QEWQ)", "R>Q>E>W (QWEQ)"})
      Menu.Misc:addParam("Blank3", "", SCRIPT_PARAM_INFO, "")]]
    if VIP_USER then
    Menu.Misc:addParam("BlockR", "Block R if hitcount = 0", SCRIPT_PARAM_ONOFF, true)
    end
      
  Menu:addSubMenu("Draw Settings", "Draw")
  
    Menu.Draw:addParam("On", "Draw", SCRIPT_PARAM_ONOFF, true)
      Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("AA", "Draw Attack range", SCRIPT_PARAM_ONOFF, false)
    Menu.Draw:addParam("Q", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
    Menu.Draw:addParam("W", "Draw W range", SCRIPT_PARAM_ONOFF, false)
    Menu.Draw:addParam("E", "Draw E range", SCRIPT_PARAM_ONOFF, false)
    Menu.Draw:addParam("R", "Draw R range", SCRIPT_PARAM_ONOFF, false)
    Menu.Draw:addParam("S", "Draw Smite range", SCRIPT_PARAM_ONOFF, true)
      Menu.Draw:addParam("Blank2", "", SCRIPT_PARAM_INFO, "")
    Menu.Draw:addParam("On2", "Use PermaShow (Require reload)", SCRIPT_PARAM_ONOFF, false)
    
    if Menu.Draw.On2 then
    
      Menu.Combo:permaShow("On")
      Menu.Clear.Farm:permaShow("On")
      Menu.Clear.JFarm:permaShow("On")
      Menu.Harass:permaShow("On")
      Menu.LastHit:permaShow("On")
      Menu.LastHit:permaShow("On2")
      Menu.JSteal:permaShow("On")
      Menu.Flee:permaShow("On")
      
    end
    
  Menu:addTS(QWETS)
  
end

----------------------------------------------------------------------------------------------------

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
  elseif FileExist(LIB_PATH .. "SOW.lua") then
  
    require 'SOW'
    
    SOWVP = SOW(VP)
    Menu:addSubMenu("Orbwalk Settings (SOW)", "Orbwalk")
      Menu.Orbwalk:addParam("Info", "SOW settings", SCRIPT_PARAM_INFO, "")
      Menu.Orbwalk:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      SOWVP:LoadToMenu(Menu.Orbwalk)
    SOWLoaded = true
    ScriptMsg("Found SOW.")
  else
    ScriptMsg("Orbwalk not founded. Using AllClass TS.")
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function OnTick()

  if myHero.dead then
    return
  end
  
  Check()
  Target = OrbTarget()
  --Debug()
  
  if Menu.Clear.Farm.On then
    Farm()
  end
  
  if Menu.Clear.JFarm.On then
    JFarm()
  end
  
  if Menu.JSteal.On then
    JSteal()
  end
  
  if Menu.Auto.On then
    Auto()
  end
  
  if Menu.LastHit.On or Menu.LastHit.On2 then
    LastHit()
  end
  
  if Menu.Auto.On and Menu.Auto.StackE then
    AutoStackE()
  end
  
  if Menu.Flee.On then
    Flee()
  end
  
  if Pool and Menu.Combo.On then --Will block orb packet later
    BlockAA(p)
    MoveToMouse()
  end
  
  --[[if VIP_USER and Menu.Misc.Skin then
    Skin()
  end
  
  if Menu.Misc.AutoLevel then
    AutoLevel()
  end]]
  
  if Target == nil then
    return
  end
  
  if Menu.KillSteal.On then
    KillSteal()
  end
  
  if Menu.Combo.On then
    Combo()
  end
  
  if Menu.Harass.On then
    Harass()
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function Check()

  Q.ready = myHero:CanUseSpell(_Q) == READY
  W.ready = myHero:CanUseSpell(_W) == READY
  E.ready = myHero:CanUseSpell(_E) == READY
  R.ready = myHero:CanUseSpell(_R) == READY
  I.ready = Ignite ~= nil and myHero:CanUseSpell(Ignite) == READY
  S.ready = Smite ~= nil and myHero:CanUseSpell(Smite) == READY
  
  ZSlot = GetInventorySlotItem(3157)
  Z.ready = ZSlot ~= nil and myHero:CanUseSpell(ZSlot) == READY
  
  for _, item in pairs(Items) do
    item.slot = GetInventorySlotItem(item.id)
  end
  
  Items["Stalker"].ready = Smite ~= nil and (Items["Stalker"].slot or Items["StalkerW"].slot or Items["StalkerM"].slot or Items["StalkerJ"].slot or Items["StalkerD"].slot) and myHero:CanUseSpell(Smite) == READY
  
  EnemyMinions:update()
  JungleMobs:update()
  
  if E.stack ~= 0 and os.clock() - LastE > 10.1 then
    E.stack = 0
  end
  
  HealthPercent = (myHero.health/myHero.maxHealth)*100
  
  Q.level = myHero:GetSpellData(_Q).level
  W.level = myHero:GetSpellData(_W).level
  E.level = myHero:GetSpellData(_E).level
  R.level = myHero:GetSpellData(_R).level
  
end

----------------------------------------------------------------------------------------------------

function OrbTarget()

  local T
  
  if RebornLoaded then
    T = _G.AutoCarry.Crosshair.Attack_Crosshair.target
  elseif RevampedLoaded then
    T = _G.AutoCarry.Orbwalker.target
  elseif MMALoaded then
    T = _G.MMA_Target
  elseif SOWLoaded then
    T = SOWVP:GetTarget()
  end
  
  if T and T.tpye == Player.type and ValidTarget(T, MaxRrange) then
    return T
  end
  
  QWETS:update()
  RTS:update()
  
  if QWETS.target then
    return QWETS.target
  end
  
  if RTS.target then
    return RTS.target
  end
  
end

----------------------------------------------------------------------------------------------------

function Debug()

  if os.clock() - DebugClock > 10 then
    print("Debugging...")
    DebugClock = os.clock()
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function Combo()
  
  if GetDistanceSqr(Target) > MaxRrangeSqr then
    return
  end
  
  local ComboQ = Menu.Combo.Q
  local ComboW = Menu.Combo.W
  local ComboW2 = Menu.Combo.W2
  local ComboE = Menu.Combo.E
  local ComboE2 = Menu.Combo.E2
  local ComboR = Menu.Combo.R
  local ComboR2 = Menu.Combo.R2
  local ComboRearly = Menu.Combo.Rearly
  local DontR = Menu.Combo.DontR
  local ComboAutoR = Menu.Combo.AutoR
  
  local QTargetDmg = getDmg("Q", Target, myHero)
  local WTargetDmg = getDmg("W", Target, myHero)
  local ETargetDmg = (getDmg("E", Target, myHero) + E.stack*getDmg("E", Target, myHero, 2))
  local RTargetDmg = getDmg("R", Target, myHero)
  
  if R.ready and ComboAutoR and ValidTarget(Target, MaxRrange) then
    CastR2(Target, Combo)
  end
  
  if R.ready and ComboR then
    
    if ValidTarget(Target, Q.range) then
      
      if ComboRearly and (QTargetDmg+ETargetDmg+RTargetDmg)*ComboR2 >= Target.health*100 then
        CastR(Target)
        return
      end
    
      if Q.ready and ComboQ and DontR and QTargetDmg >= Target.health then
        CastQ(Target)
        return
      end
      
      if Q.ready and ComboQ and E.ready and ComboE and (QTargetDmg+ETargetDmg+RTargetDmg)*ComboR2 >= Target.health*100 then
        CastE()
        CastQ(Target)
        CastR(Target)
        return
      elseif Q.ready and ComboQ and (QTargetDmg+RTargetDmg)*ComboR2 >= Target.health*100 then
        CastQ(Target)
        CastR(Target)
        return
      elseif E.ready and ComboE and (ETargetDmg+RTargetDmg)*ComboR2 >= Target.health*100 then
        CastE()
        CastR(Target)
        return
      end
      
    end
  
    if ValidTarget(Target, R.range) and RTargetDmg*ComboR2 >= Target.health*100 then
      CastR(Target)
    end
    
  end
  
  if E.ready and ComboE and ComboE2 <= HealthPercent and ValidTarget(Target, E.range) then
    CastE2(Target, Combo)
  end
  
  if Q.ready and ComboQ and ValidTarget(Target, Q.range) then
    CastQ(Target)
  end
  
  if W.ready and ComboW and not (Q.ready and ComboQ) and not (E.ready and ComboE) and WTargetDmg*1000 >= myHero.health*2*ComboW2 and ValidTarget(Target, W.radius) then
    CastW()
  end
  
end

----------------------------------------------------------------------------------------------------

function Farm()

  if not Q.ready and not E.ready then
    return
  end
  
  for i, minion in pairs(EnemyMinions.objects) do
  
    if minion == nil or GetDistanceSqr(minion) > QrangeSqr then
      return
    end
    
    local FarmQ = Menu.Clear.Farm.Q
    local FarmE = Menu.Clear.Farm.E
    local FarmE2 = Menu.Clear.Farm.E2
    local FarmEmin = Menu.Clear.Farm.Emin
    
    local AAMinionDmg = getDmg("AD", minion, myHero)
    local QMinionDmg = getDmg("Q", minion, myHero)
    local EMinionDmg = getDmg("E", minion, myHero) + E.stack*getDmg("E", minion, myHero, 2)
    
    if E.ready and FarmE and FarmE2 <= HealthPercent and FarmEmin <= MinionCount(minion, E.range) and EMinionDmg >= minion.health and ValidTarget(minion, E.range) then
      CastE()
    end
    
    if Q.ready and FarmQ and QMinionDmg >= minion.health and ValidTarget(minion, Q.range) then
      CastQ(minion)
    end
    
  end
  
  for i, minion in pairs(EnemyMinions.objects) do
  
    if minion == nil or GetDistanceSqr(minion) > QrangeSqr then
      return
    end
    
    local FarmQ = Menu.Clear.Farm.Q
    local FarmE = Menu.Clear.Farm.E
    local FarmE2 = Menu.Clear.Farm.E2
    local FarmEmin = Menu.Clear.Farm.Emin
    
    local AAMinionDmg = getDmg("AD", minion, myHero)
    local QMinionDmg = getDmg("Q", minion, myHero)
    local EMinionDmg = getDmg("E", minion, myHero) + E.stack*getDmg("E", minion, myHero, 2)
    
    if E.ready and FarmE and FarmE2 <= HealthPercent and FarmEmin <= MinionCount(minion, E.range) and EMinionDmg + 2*AAMinionDmg <= minion.health and ValidTarget(minion, E.range) then
      CastE()
    end
    
    if Q.ready and FarmQ and QMinionDmg + 2*AAMinionDmg <= minion.health and ValidTarget(minion, Q.range) then
      CastQ(minion)
    end
    
  end
  
end

function MinionCount(Point, Range)

  local count = 0
  
  for i, minion in pairs(EnemyMinions.objects) do
  
    if minion ~= nil and GetDistance(Point, minion) <= Range then
      count = count + 1
    end
    
  end
  
  return count
  
end

----------------------------------------------------------------------------------------------------

function JFarm()

  if not Q.ready and not E.ready then
    return
  end
  
  for i, junglemob in pairs(JungleMobs.objects) do
  
    if junglemob == nil or GetDistanceSqr(junglemob) > QrangeSqr then
      return
    end
  
    local JFarmQ = Menu.Clear.JFarm.Q
    local JFarmE = Menu.Clear.JFarm.E
    local JFarmE2 = Menu.Clear.JFarm.E2
    local JFarmEmin = Menu.Clear.JFarm.Emin
  
    if E.ready and JFarmE and JFarmE2 <= HealthPercent and JFarmEmin <= JungleMobCount(junglemob, E.range) and ValidTarget(junglemob, E.range) then
      CastE()
    end
    
    if Q.ready and JFarmQ and ValidTarget(junglemob, Q.range) then
      CastQ(junglemob)
    end
    
  end
  
end

function JungleMobCount(Point, Range)

  local count = 0
  
  for i, junglemob in pairs(JungleMobs.objects) do
  
    if junglemob ~= nil and GetDistance(Point, junglemob) <= Range then
      count = count + 1
    end
    
  end
  
  return count
  
end

----------------------------------------------------------------------------------------------------

function JSteal()

  if not Q.ready and not E.ready then
    return
  end
  
  for i, junglemob in pairs(JungleMobs.objects) do
  
    if junglemob == nil or GetDistanceSqr(junglemob) > ErangeSqr then
      return
    end
    
    local JStealQ = Menu.JSteal.Q
    local JStealE = Menu.JSteal.E
    local JStealEQ = Menu.JSteal.EQ
    local JStealE2 = Menu.JSteal.E2
    
    local QjunglemobDmg = getDmg("Q", junglemob, myHero)
    local EjunglemobDmg = getDmg("E", junglemob, myHero) + E.stack*getDmg("E", junglemob, myHero, 2)
    
    if Q.ready and JStealQ and E.ready and JStealE and JStealEQ then
    
      if QjunglemobDmg + EjunglemobDmg >= junglemob.health and EjunglemobDmg < junglemob.health and JStealE2 <= HealthPercent and ValidTarget(junglemob, Q.range) then
        CastE()
        CastQ(junglemob)
      end
      
    elseif Q.ready and JStealQ then
    
      if QjunglemobDmg >= junglemob.health and ValidTarget(junglemob, Q.range) then
        CastQ(junglemob)
      end
      
    elseif E.ready and JStealE then
    
      if EjunglemobDmg >= junglemob.health and JStealE2 <= HealthPercent and ValidTarget(junglemob, E.range) then
        CastE()
      end
      
    end
    
  end
  
end

----------------------------------------------------------------------------------------------------

function Harass()

  if GetDistanceSqr(Target) > ErangeSqr then
    return
  end
  
  local HarassQ = Menu.Harass.Q
  local HarassE = Menu.Harass.E
  local HarassE2 = Menu.Harass.E2
  
  if E.ready and HarassE and HarassE2 <= HealthPercent and ValidTarget(Target, E.range) then
    CastE2(Target, Harass)
  end
  
  if Q.ready and HarassQ and ValidTarget(Target, Q.range) then
    CastQ(Target)
  end
  
end

----------------------------------------------------------------------------------------------------

function LastHit()

  if not Q.ready and not E.ready then
    return
  end
  
  for i, minion in pairs(EnemyMinions.objects) do
  
    if minion == nil or GetDistanceSqr(minion) > ErangeSqr then
      return
    end
    
    local LastHitQ = Menu.LastHit.Q
    local LastHitE = Menu.LastHit.E
    local LastHitEQ = Menu.LastHit.EQ
    local LastHitE2 = Menu.LastHit.E2
    
    local QminionDmg = getDmg("Q", minion, myHero)
    local EminionDmg = getDmg("E", minion, myHero) + E.stack*getDmg("E", minion, myHero, 2)
    
    if Q.ready and LastHitQ and E.ready and LastHitE and LastHitEQ then
    
      if QminionDmg + EminionDmg >= minion.health and EminionDmg < minion.health and LastHitE2 <= HealthPercent and ValidTarget(minion, Q.range) then
        CastE()
        CastQ(minion)
      end
      
    end
    
    if Q.ready and LastHitQ then
    
      if QminionDmg >= minion.health and ValidTarget(minion, Q.range) then
        CastQ(minion)
      end
      
    elseif E.ready and LastHitE then
    
      if EminionDmg >= minion.health and LastHitE2 <= HealthPercent and ValidTarget(minion, E.range) then
        CastE()
      end
      
    end
    
  end
  
end

----------------------------------------------------------------------------------------------------

function KillSteal()

  if GetDistanceSqr(Target) > RrangeSqr then
    return
  end
  
  local KillStealQ = Menu.KillSteal.Q
  local KillStealW = Menu.KillSteal.W
  local KillStealE = Menu.KillSteal.E
  local KillStealE2 = Menu.KillSteal.E2
  local KillStealR = Menu.KillSteal.R
  local KillStealI = Menu.KillSteal.I
  
  local QTargetDmg = getDmg("Q", Target, myHero)
  local WTargetDmg = getDmg("W", Target, myHero)
  local ETargetDmg = (getDmg("E", Target, myHero) + E.stack*getDmg("E", Target, myHero, 2))
  local RTargetDmg = getDmg("R", Target, myHero)
  local ITargetDmg = getDmg("IGNITE", Target, myHero)
  
  if I.ready and KillStealI and ITargetDmg >= Target.health and ValidTarget(Target, I.range) then
    CastI(Target)
  end
  
  if E.ready and KillStealE and KillStealE2 <= HealthPercent and ETargetDmg >= Target.health and ValidTarget(Target, E.range) then
    CastE1(Target, KillSteal)
  end
  
  if Q.ready and KillStealQ and QTargetDmg >= Target.health and ValidTarget(Target, Q.range) then
    CastQ(Target)
  end
  
  if W.ready and KillStealW and not (Q.ready and KillStealQ) and not (E.ready and KillStealE) and WTargetDmg >= Target.health and ValidTarget(Target, W.radius) then
    CastW()    
  end
  
  if R.ready and KillStealR and RTargetDmg >= Target.health and ValidTarget(Target, R.range) then
    CastR(Target)
  end
  
end

----------------------------------------------------------------------------------------------------

function Auto()
  
  local AutoAutoE = Menu.Auto.AutoE
  local AutoE2 = Menu.Auto.E2
  local AutoAutoZ = Menu.Auto.AutoZ
  local AutoAutoR = Menu.Auto.AutoR
  local AutoZ = Menu.Auto.Z
  local AutoZmin = Menu.Auto.Zmin
  local AutoAutoS = Menu.Auto.AutoS
  
  local FleeOn = Menu.Flee.On
  
  if Z.ready and AutoAutoZ and AutoZ > HealthPercent and AutoZmin <= EnemyCount(Z.range) then
    CastZ()
  end
  
  if Recall then
    return
  end
  
  for i, junglemob in pairs(JungleMobs.objects) do
  
    if junglemob == nil or not S.ready then
      return
    end
    
    local SjunglemobDmg = GetDmg("SMITE", junglemob)
    
    if S.ready and AutoAutoS and SjunglemobDmg >= junglemob.health and ValidTarget(junglemob, S.range) then
      CastS(junglemob)
    end
    
  end
  
  if Target == nil then
    return
  end
  
  if E.ready and AutoAutoE and not FleeOn and AutoE2 <= HealthPercent and ValidTarget(Target, E.range) then
    CastE2(Target, Auto)
  end
  
  if R.ready and AutoAutoR then
    CastR2(Target, Auto)
  end
  
end

function EnemyCount(Range)

  local enemies = {}
  
  for _, enemy in ipairs(EnemyHeroes) do
    
    if ValidTarget(enemy, Range) then
      table.insert(enemies, enemy)
    end
    
  end
  
  return #enemies, enemies
  
end

function CastZ()

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = ZSlot}):send()
  else
    CastSpell(ZSlot)
  end
  
end

----------------------------------------------------------------------------------------------------

function AutoStackE()

  if E.ready and not (Menu.Combo.On or Menu.Harass.On or Menu.Flee.On) and Menu.Auto.SE2 <= HealthPercent then
    StackE()
  end
  
end

function StackE()

  if os.clock() - LastE > 9.9 and Recall == false then
    CastE()
  end
  
end

----------------------------------------------------------------------------------------------------

function Flee()

  MoveToMouse()
  
  if W.ready and Menu.Flee.W then
    CastW()
  end
  
end

----------------------------------------------------------------------------------------------------

function Skin()

  local SkinOpt = Menu.Misc.SkinOpt 
  
  if SkinOpt ~= LastSkin then
    GenModelPacket("Vladimir", SkinOpt)
    LastSkin = Menu.Misc.SkinOpt
  end
  
end

function GenModelPacket(Champion, SkinId)

  p = CLoLPacket(0x97)
  p:EncodeF(myHero.networkID)
  p.pos = 1
  t1 = p:Decode1()
  t2 = p:Decode1()
  t3 = p:Decode1()
  t4 = p:Decode1()
  p:Encode1(t1)
  p:Encode1(t2)
  p:Encode1(t3)
  p:Encode1(bit32.band(t4,0xB))
  p:Encode1(1)
  p:Encode4(SkinId)
  
  for i = 1, #Champion do
    p:Encode1(string.byte(Champion:sub(i,i)))
  end
  
  for i = #Champion + 1, 64 do
    p:Encode1(0)
  end
  
  p:Hide()
  RecvPacket(p)
  
end

----------------------------------------------------------------------------------------------------

function AutoLevel()

  if Menu.Misc.ALOpt == 1 then
  
    if Q.level+W.level+E.level+R.level < myHero.level then
    
      local spell = {SPELL_1, SPELL_2, SPELL_3, SPELL_4}
      local level = {0, 0, 0, 0}
      
      for i = 1, myHero.level do
        level[AutoQEWQ[i]] = level[AutoQEWQ[i]]+1
      end
      
      for i, v in ipairs({Q.level, W.level, E.level, R.level}) do
      
        if v < level[i] then
          LevelSpell(spell[i])
        end
        
      end
      
    end
    
  elseif Menu.Misc.ALOpt == 2 then
  
    if Q.level+W.level+E.level+R.level < myHero.level then
    
      local spell = {SPELL_1, SPELL_2, SPELL_3, SPELL_4}
      local level = {0, 0, 0, 0}
      
      for i = 1, myHero.level do
        level[AutoQWEQ[i]] = level[AutoQWEQ[i]]+1
      end
      
      for i, v in ipairs({Q.level, W.level, E.level, R.level}) do
      
        if v < level[i] then
          LevelSpell(spell[i])
        end
        
      end
      
    end
    
  end
  
end

----------------------------------------------------------------------------------------------------

function GetDmg(spell, enemy)

  if enemy == nil then
    return
  end
  
  local Level = myHero.level
  
  if spell == "SMITE" then
  
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
    
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function OnDraw()

  if Menu.Draw.On then
  
    if Menu.Draw.AA then
      DrawCircle(Player.x, Player.y, Player.z, TrueRange, ARGB(0xFF,0,0xFF,0))
    end
    
    if Menu.Draw.Q and Q.ready then
      DrawCircle(Player.x, Player.y, Player.z, Q.range, ARGB(0xFF,0xFF,0xFF,0xFF))
    end
    
    if Menu.Draw.W then
      DrawCircle(Player.x, Player.y, Player.z, W.radius, ARGB(0xFF,0xFF,0xFF,0xFF))
    end
    
    if Menu.Draw.E and E.ready then
      DrawCircle(Player.x, Player.y, Player.z, E.range, ARGB(0xFF,0xFF,0xFF,0xFF))
    end
    
    if Menu.Draw.R and R.ready then
      DrawCircle(Player.x, Player.y, Player.z, R.range, ARGB(0xFF,0xFF,0,0))
    end
  
    if Menu.Draw.S and S.ready and Menu.Auto.On and Menu.Auto.AutoS then
      DrawCircle(myHero.x, myHero.y, myHero.z, S.range, ARGB(0xFF, 0xFF, 0x14, 0x93))
    end
    
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function CastQ(enemy)

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(_Q, enemy)
  end
  
end

----------------------------------------------------------------------------------------------------

function CastW()

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _W}):send()
  else
    CastSpell(_W)
  end
  
end

----------------------------------------------------------------------------------------------------

function CastE()

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _E}):send()
  else
    CastSpell(_E)
  end
  
  LastE = os.clock()
  
end

function CastE1(enemy, State)

  local AoECastPosition, MainTargetHitChance, NT = VP:GetCircularAOECastPosition(enemy, E.delay, E.radius, E.range, E.speed, myHero, false)
  
  if NT >= 1 and MainTargetHitChance >= 2 then
    CastE()
  end
  
end

function CastE2(enemy, State)

  local AoECastPosition, MainTargetHitChance, NT = VP:GetCircularAOECastPosition(enemy, E.delay, E.radius, E.range, E.speed, myHero, false)
  
  if State == Combo then
  
    if NT >= Menu.Combo.Emin and MainTargetHitChance >= 2 then
      CastE()
    end
    
  elseif State == Harass then
  
    if NT >= Menu.Harass.Emin and MainTargetHitChance >= 2 then
      CastE()
    end
    
  elseif State == Auto then
  
    if NT >= Menu.Auto.Emin and MainTargetHitChance >= 2 then
      CastE()
    end
    
  end
  
end

----------------------------------------------------------------------------------------------------

function CastR(enemy)

  if VIP_USER and Menu.Misc.UsePacket then
    Packet('S_CAST', {spellId = _R, toX = enemy.x, toY = enemy.z, fromX = enemy.x, fromY = enemy.z}):send(true)
  else
    CastSpell(_R, enemy.x, enemy.z)
  end
  
end

function CastR2(enemy, State)

  local AoECastPosition, MainTargetHitChance, NT = VP:GetCircularAOECastPosition(enemy, R.delay, R.radius, R.range, R.speed, myHero, false)
  
  if State == Combo and not BlockComboR then
  
    if NT >= Menu.Combo.Rmin then
    
      if MainTargetHitChance >= 2 then
        CastR(AoECastPosition)
      end
      
    end
    
  elseif State == Auto then
  
    if NT >= Menu.Auto.Rmin then
    
      BlockComboR = true
      
      if MainTargetHitChance >= 2 then
        CastR(AoECastPosition)
      end
      
      BlockComboR = false
      
    end
    
  end
  
end

----------------------------------------------------------------------------------------------------

function CastI(enemy)

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = Ignite, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(Ignite, enemy)
  end
  
end

----------------------------------------------------------------------------------------------------

function CastS(enemy)

  if VIP_USER and Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = Smite, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(Smite, enemy)
  end
  
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function MoveToPos(x, z)

  myHero:MoveTo(x, z)
  
end

function MoveToMouse()

  if GetDistance(mousePos) then
    MousePos = myHero + (Vector(mousePos) - myHero):normalized()*300
  end
  
  myHero:MoveTo(MousePos.x, MousePos.z)
  
end

---------------------------------------------------------------------------------

--[[function OnGainBuff(unit, buff)

  if unit.isMe then
  
    if buff.name == "recall" then
      Recall = true
      LastE = os.clock()
    end
    
    if buff.name == "vladimirsanguinepool" then
      Pool = true
    end
    
  end
  
end

---------------------------------------------------------------------------------

function OnLoseBuff(unit, buff)

  if unit.isMe then
  
    if buff.name == "recall" then
      Recall = false
    end
    
    if buff.name == "vladimirsanguinepool" then
      Pool = false
    end
    
  end
  
end]]

---------------------------------------------------------------------------------

function OnProcessSpell(unit,spell)

  if unit.isMe and spell.name == "VladimirTidesofBlood" then
  
    LastE = os.clock()
    
    if E.stack < 4 then
      E.stack = E.stack + 1
    end
    
  end
  
end

---------------------------------------------------------------------------------

function OnSendPacket(p)

  if Target == nil then
    return
  end
  
  if Menu.Combo.On and E.ready and Menu.Combo.E2 <= HealthPercent then
    BlockAA(p)
  elseif Menu.Harass.On and E.ready and Menu.Harass.E2 <= HealthPercent then
    BlockAA(p)
  end
  
end

function BlockAA(p)

  local info = {header, NetworkID, type, x, y}
  
  info.header = p.header
  p.pos = 1
  info.networkID = p:DecodeF()
  info.type = p:Decode1()
  
  if info.header == Packet.headers.S_MOVE and info.type == 3 then
    p:Block()
  end
  
end
