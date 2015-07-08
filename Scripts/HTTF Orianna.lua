local Version = "1.261"

if myHero.charName ~= "Orianna" then
  return
end

class "HTTF_Orianna"

require 'HPrediction'

function HTTF_Orianna:ScriptMsg(msg)
  print("<font color=\"#daa520\"><b>HTTF Orianna:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>")
end

---------------------------------------------------------------------------------

local Host = "raw.github.com"

local ScriptFilePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME

local ScriptPath = "/BolHTTF/BoL/master/HTTF/HTTF Orianna.lua".."?rand="..math.random(1,10000)
local UpdateURL = "https://"..Host..ScriptPath

local VersionPath = "/BolHTTF/BoL/master/HTTF/Version/HTTF Orianna.version".."?rand="..math.random(1,10000)
local VersionData = tonumber(GetWebResult(Host, VersionPath))

if VersionData then

  local ServerVersion = type(VersionData) == "number" and VersionData or nil
  
  if ServerVersion then
  
    if tonumber(Version) < ServerVersion then
      HTTF_Orianna:ScriptMsg("New version available: v"..VersionData)
      HTTF_Orianna:ScriptMsg("Updating, please don't press F9.")
      DelayAction(function() DownloadFile(UpdateURL, ScriptFilePath, function () HTTF_Orianna:ScriptMsg("Successfully updated.: v"..Version.." => v"..VersionData..", Press F9 twice to load the updated version.") end) end, 3)
    else
      HTTF_Orianna:ScriptMsg("You've got the latest version: v"..Version)
    end
    
  else
    HTTF_Orianna:ScriptMsg("Error downloading server version.")
  end
  
else
  HTTF_Orianna:ScriptMsg("Error downloading version.")
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function OnLoad()

  HTTF_Orianna = HTTF_Orianna()
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:__init()

  self:Variables()
  self:OriannaMenu()
  
  DelayAction(function() self:Orbwalk() end, 1)
  AddTickCallback(function() self:Tick() end)
  AddDrawCallback(function() self:Draw() end)
  AddAnimationCallback(function(unit, animation) self:Animation(unit, animation) end)
  AddCreateObjCallback(function(object) self:CreateObj(object) end)
  AddProcessSpellCallback(function(unit, spell) self:ProcessSpell(unit, spell) end)
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:Variables()

  self.HPred = HPrediction()
	
  self.Ball = myHero
  self.IsRecall = false
  self.RebornLoaded, self.RevampedLoaded, self.MMALoaded, self.SxOrbLoaded, self.SOWLoaded = false, false, false, false, false
  
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
    self.Ignite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    self.Ignite = SUMMONER_2
  end
  
  if myHero:GetSpellData(SUMMONER_1).name:find("smite") then
    self.Smite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then
    self.Smite = SUMMONER_2
  end
  
  self.Q = {range = 825, radius = 175, speed = 1200, ready}
  self.W = {range = 1250, radius = 225, ready}
  self.E = {range = 1250, speed = 1800, width = 80, ready}
  self.R = {range = 1250, radius = 410, ready}
  self.I = {range = 600, ready}
  self.S = {range = 760, ready}
  
  self.TrueRange = myHero.range+myHero.boundingRadius
  
  self.QTargetRange = self.Q.range+self.Q.radius
  self.ETargetRange = self.E.range
  
  self.QMinionRange = self.Q.range+self.Q.radius
  self.QJunglemobRange = self.Q.range+self.Q.radius
  
  self.Items =
  {
  ["BC"] = {id=3144, range = 450, slot = nil, ready},
  ["BRK"] = {id=3153, range = 450, slot = nil, ready},
  ["Stalker"] = {id=3706, slot = nil, ready},
  ["StalkerW"] = {id=3707, slot = nil},
  ["StalkerM"] = {id=3708, slot = nil},
  ["StalkerJ"] = {id=3709, slot = nil},
  ["StalkerD"] = {id=3710, slot = nil}
  }
  
  local S5SR = false
  local TT = false
  
  if GetGame().map.index == 15 then
    S5SR = true
  elseif GetGame().map.index == 4 then
    TT = true
  end
  
  if S5SR then
    self.FocusJungleNames =
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
    self.JungleMobNames =
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
    self.FocusJungleNames =
    {
    "TT_NWraith1.1.1",
    "TT_NGolem2.1.1",
    "TT_NWolf3.1.1",
    "TT_NWraith4.1.1",
    "TT_NGolem5.1.1",
    "TT_NWolf6.1.1",
    "TT_Spiderboss8.1.1"
    }   
    self.JungleMobNames =
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
    self.FocusJungleNames =
    {
    }   
    self.JungleMobNames =
    {
    }
  end
  
  self.QTS = TargetSelector(TARGET_LESS_CAST, self.QTargetRange, DAMAGE_MAGIC, false)
  self.ETS = TargetSelector(TARGET_LESS_CAST, self.ETargetRange, DAMAGE_MAGIC, false)
  self.STS = TargetSelector(TARGET_LOW_HP, self.S.range)
  
  self.EnemyHeroes = GetEnemyHeroes()
  self.AllyHeroes = GetAllyHeroes()
  table.insert(self.AllyHeroes, myHero)
  self.EnemyMinions = minionManager(MINION_ENEMY, self.QMinionRange, myHero, MINION_SORT_MAXHEALTH_DEC)
  self.JungleMobs = minionManager(MINION_JUNGLE, self.QJunglemobRange, myHero, MINION_SORT_MAXHEALTH_DEC)
  
end

---------------------------------------------------------------------------------

--[[function HTTF_Orianna:BlockR(unit)

  if VIP_USER and self.Menu.Misc.BlockR and Packet(unit):get('spellId') == _R and not RHit() then
    unit:Block()
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:RHit()

  if self.Ball ~= nil then
  
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy == nil then
        return
      end
      
      local RPos, RHitChance, RNoH = self.HPred:GetPredict("R", enemy, self.Ball, true)
      
      if RNoH > 0 then
        return true
      end
      
    end
    
  end
  
  return false
end]]

---------------------------------------------------------------------------------

function HTTF_Orianna:OriannaMenu()

  self.Menu = scriptConfig("HTTF Orianna", "HTTF Orianna")
  
  self.Menu:addSubMenu("HitChance Settings", "HitChance")
  
    self.Menu.HitChance:addSubMenu("Combo", "Combo")
      self.Menu.HitChance.Combo:addParam("Q", "Q HitChacne (Default value = 1.2)", SCRIPT_PARAM_SLICE, 1.2, 1, 3, 2)
      self.Menu.HitChance.Combo:addParam("W", "W HitChacne (Default value = 3)", SCRIPT_PARAM_SLICE, 3, 2, 3, 2)
      self.Menu.HitChance.Combo:addParam("R", "R HitChacne (Default value = 3)", SCRIPT_PARAM_SLICE, 3, 2, 3, 2)
      
    self.Menu.HitChance:addSubMenu("Harass", "Harass")
      self.Menu.HitChance.Harass:addParam("Q", "Q HitChacne (Default value = 2.6)", SCRIPT_PARAM_SLICE, 2.6, 2, 3, 2)
      self.Menu.HitChance.Harass:addParam("W", "W HitChacne (Default value = 3)", SCRIPT_PARAM_SLICE, 3, 2, 3, 2)
      
  self.Menu:addSubMenu("Combo Settings", "Combo")
    self.Menu.Combo:addParam("On", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
      self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("Q2", "Use Q if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
      self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("W2", "Use W if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
      self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("E2", "Use E if Mana Percent > x% (10)", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
    self.Menu.Combo:addParam("E3", "and Use E if Enemy is near my Hero (true)", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("R", "Use Smart R (Single Target)", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("R2", "Use R (Multiple Target)", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("R3", "and Use R if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
    self.Menu.Combo:addParam("R4", "and Use R Min Count (3)", SCRIPT_PARAM_SLICE, 3, 2, 5, 0)
      self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("Item", "Use Items", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Combo:addParam("BRK", "Use BRK if my own HP < x% (30)", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
      
  self.Menu:addSubMenu("Clear Settings", "Clear")
  
    self.Menu.Clear:addSubMenu("Lane Clear Settings", "Farm")
      self.Menu.Clear.Farm:addParam("On", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
        self.Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.Farm:addParam("Q2", "Use Q if Mana Percent > x% (30)", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
        self.Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.Farm:addParam("W2", "Use W if Mana Percent > x% (40)", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
        self.Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.Farm:addParam("E2", "Use E if Mana Percent > x% (50)", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
        
    self.Menu.Clear:addSubMenu("Jungle Clear Settings", "JFarm")
      self.Menu.Clear.JFarm:addParam("On", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
        self.Menu.Clear.JFarm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.JFarm:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.JFarm:addParam("Q2", "Use Q if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
        self.Menu.Clear.JFarm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.JFarm:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.JFarm:addParam("W2", "Use W if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
        self.Menu.Clear.JFarm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.JFarm:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.JFarm:addParam("E2", "Use E if Mana Percent > x% (10)", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
      
    self.Menu.Clear:addSubMenu("All Clear Settings", "All")
      self.Menu.Clear.All:addParam("On", "All Clear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('T'))
      
  self.Menu:addSubMenu("Harass Settings", "Harass")
    self.Menu.Harass:addParam("On", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('C'))
    self.Menu.Harass:addParam("On2", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('H'))
      self.Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Harass:addParam("Q2", "Use Q if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
      self.Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Harass:addParam("W2", "Use W if Mana Percent > x% (50)", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
      self.Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Harass:addParam("E2", "Use E if Mana Percent > x% (60)", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
    self.Menu.Harass:addParam("E3", "and Use E if Enemy is near my Hero (true)", SCRIPT_PARAM_ONOFF, true)
    
  self.Menu:addSubMenu("LastHit Settings", "LastHit")
    self.Menu.LastHit:addParam("On", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
      self.Menu.LastHit:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.LastHit:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    self.Menu.LastHit:addParam("Q2", "Use Q if Mana Percent > x% (90)", SCRIPT_PARAM_SLICE, 90, 0, 100, 0)
    self.Menu.LastHit:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    self.Menu.LastHit:addParam("W2", "Use W if Mana Percent > x% (90)", SCRIPT_PARAM_SLICE, 90, 0, 100, 0)
    self.Menu.LastHit:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
    self.Menu.LastHit:addParam("E2", "Use E if Mana Percent > x% (90)", SCRIPT_PARAM_SLICE, 90, 0, 100, 0)
    
  self.Menu:addSubMenu("Jungle Steal Settings", "JSteal")
    self.Menu.JSteal:addParam("On", "Jungle Steal", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
    self.Menu.JSteal:addParam("On2", "Jungle Steal Toggle", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey('N'))
      self.Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.JSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
    self.Menu.JSteal:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
    self.Menu.JSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
    if self.Smite ~= nil then
      self.Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.JSteal:addParam("S", "Use Smite", SCRIPT_PARAM_ONOFF, true)
    end
      self.Menu.JSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.JSteal:addParam("Always", "Always Use Q, W, E and Smite\n(Baron & Dragon)", SCRIPT_PARAM_ONOFF, true)
    
  self.Menu:addSubMenu("KillSteal Settings", "KillSteal")
    self.Menu.KillSteal:addParam("On", "KillSteal", SCRIPT_PARAM_ONOFF, true)
      self.Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
      self.Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
      self.Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
      self.Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
    if self.Ignite ~= nil then
      self.Menu.KillSteal:addParam("Blank3", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("I", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
    end
    if self.Smite ~= nil then
      self.Menu.KillSteal:addParam("Blank4", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("S", "Use Stalker's Blade", SCRIPT_PARAM_ONOFF, true)
    end
    
  self.Menu:addSubMenu("Auto Settings", "Auto")
    self.Menu.Auto:addParam("On", "Auto", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Auto:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Auto:addParam("W", "Use W (Multiple Target)", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Auto:addParam("W2", "Use W if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
    self.Menu.Auto:addParam("W3", "and Use W Min Count (2)", SCRIPT_PARAM_SLICE, 2, 2, 5, 0)
      self.Menu.Auto:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    --self.Menu.Auto:addParam("E", "Use E to defend from targeted spells", SCRIPT_PARAM_ONOFF, true)
    --self.Menu.Auto:addParam("E2", "Use E if Mana Percent > x% (80)", SCRIPT_PARAM_SLICE, 80, 0, 100, 0)
    --self.Menu.Auto:addParam("E3", "or Use E if Health Percent < x% (40)", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
      --self.Menu.Auto:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Auto:addParam("R", "Use R (Multiple Target)", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Auto:addParam("R2", "and Use R if Mana Percent > x% (0)", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
    self.Menu.Auto:addParam("R3", "and Use R Min Count (4)", SCRIPT_PARAM_SLICE, 4, 2, 5, 0)
    
  self.Menu:addSubMenu("Flee Settings", "Flee")
    self.Menu.Flee:addParam("On", "Flee", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('G'))
    
  if VIP_USER then
  self.Menu:addSubMenu("Misc Settings", "Misc")
    self.Menu.Misc:addParam("UsePacket", "Use Packet", SCRIPT_PARAM_ONOFF, true)
    --self.Menu.Misc:addParam("BlockR", "Block R if hitCount is 0", SCRIPT_PARAM_ONOFF, true)
  end
  
  self.Menu:addSubMenu("Draw Settings", "Draw")
  
    self.Menu.Draw:addSubMenu("Draw Target", "Target")
      self.Menu.Draw.Target:addParam("Q", "Draw Q Target", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Draw.Target:addParam("E", "Draw E Target", SCRIPT_PARAM_ONOFF, false)
      
    self.Menu.Draw:addSubMenu("Draw Predicted Position & Line", "PP")
      self.Menu.Draw.PP:addParam("Q", "Draw Q Pos", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Draw.PP:addParam("E", "Draw E Line", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Draw.PP:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Draw.PP:addParam("Line", "Draw Line to Pos", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
        
    self.Menu.Draw:addParam("On", "Draw", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Lfc", "Draw Lag free circles", SCRIPT_PARAM_ONOFF, false)
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Ball", "Draw Ball", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Draw:addParam("AA", "Draw Attack range", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Draw:addParam("Q", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Draw:addParam("W", "Draw W radius", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Draw:addParam("R", "Draw R radius", SCRIPT_PARAM_ONOFF, true)
    if self.Ignite ~= nil then
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("I", "Draw Ignite range", SCRIPT_PARAM_ONOFF, false)
    end
    if self.Smite ~= nil then
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("S", "Draw Smite range", SCRIPT_PARAM_ONOFF, true)
    end
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Path", "Draw Move Path", SCRIPT_PARAM_ONOFF, false)
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Hitchance", "Draw Hitchance", SCRIPT_PARAM_ONOFF, true)
    
  self.Menu.Combo.On = false
  self.Menu.Clear.Farm.On = false
  self.Menu.Clear.JFarm.On = false
  self.Menu.Clear.All.On = false
  self.Menu.Harass.On = false
  self.Menu.Harass.On2 = false
  self.Menu.LastHit.On = false
  self.Menu.JSteal.On = false
  self.Menu.JSteal.On2 = false
  self.Menu.Flee.On = false
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Orbwalk()

  if _G.AutoCarry then
  
    if _G.Reborn_Initialised then
      self.RebornLoaded = true
      self:ScriptMsg("Found SAC: Reborn.")
    else
      self.RevampedLoaded = true
      self:ScriptMsg("Found SAC: Revamped.")
    end
    
  elseif _G.Reborn_Loaded then
    DelayAction(function() self:Orbwalk() end, 1)
  elseif _G.MMA_Loaded then
    self.MMALoaded = true
    self:ScriptMsg("Found MMA.")
  elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
  
    require 'SxOrbWalk'
    
    self.SxOrbMenu = scriptConfig("SxOrb Settings", "SxOrb")
    
    self.SxOrb = SxOrbWalk()
    self.SxOrb:LoadToMenu(self.SxOrbMenu)
    
    self.SxOrbLoaded = true
    self:ScriptMsg("Found SxOrb.")
  elseif FileExist(LIB_PATH .. "SOW.lua") then
  
    require 'SOW'
    require 'VPrediction'
    
    self.VP = VPrediction()
    self.SOWVP = SOW(self.VP)
    
    self.Menu:addSubMenu("Orbwalk Settings (SOW)", "Orbwalk")
      self.Menu.Orbwalk:addParam("Info", "SOW settings", SCRIPT_PARAM_INFO, "")
      self.Menu.Orbwalk:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.SOWVP:LoadToMenu(self.Menu.Orbwalk)
      
    self.SOWLoaded = true
    self:ScriptMsg("Found SOW.")
  else
    self:ScriptMsg("Orbwalk not founded.")
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:Tick()

  if myHero.dead then
    return
  end
  
  self:Checks()
  self:Targets()
  
  if self.Menu.Combo.On then
    self:Combo()
  end
  
  if self.Menu.Clear.Farm.On then
    self:Farm()
  end
  
  if self.Menu.Clear.JFarm.On then
    self:JFarm()
  end
  
  if self.Menu.Clear.All.On then
    self:All()
  end
  
  if self.Menu.Harass.On or (self.Menu.Harass.On2 and not self.IsRecall) then
    self:Harass()
  end
  
  if self.Menu.LastHit.On then
    self:LastHit()
  end
  
  if self.Menu.JSteal.On or self.Menu.JSteal.On2 then
    self:JSteal()
  end
  
  if self.Menu.JSteal.Always then
    self:JstealAlways()
  end
  
  if self.Menu.KillSteal.On then
    self:KillSteal()
  end
  
  if self.Menu.Auto.On then
    self:Auto()
  end
  
  if self.Menu.Flee.On then
    self:Flee()
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Checks()

  self.Q.ready = myHero:CanUseSpell(_Q) == READY
  self.W.ready = myHero:CanUseSpell(_W) == READY
  self.E.ready = myHero:CanUseSpell(_E) == READY
  self.R.ready = myHero:CanUseSpell(_R) == READY
  self.I.ready = self.Ignite ~= nil and myHero:CanUseSpell(self.Ignite) == READY
  self.S.ready = self.Smite ~= nil and myHero:CanUseSpell(self.Smite) == READY
  
  for _, item in pairs(self.Items) do
    item.slot = GetInventorySlotItem(item.id)
  end
  
  self.Items["BC"].ready = self.Items["BC"].slot and myHero:CanUseSpell(self.Items["BC"].slot) == READY
  self.Items["BRK"].ready = self.Items["BRK"].slot and myHero:CanUseSpell(self.Items["BRK"].slot) == READY
  self.Items["Stalker"].ready = self.Smite ~= nil and (self.Items["Stalker"].slot or self.Items["StalkerW"].slot or self.Items["StalkerM"].slot or self.Items["StalkerJ"].slot or self.Items["StalkerD"].slot) and myHero:CanUseSpell(self.Smite) == READY
  
  self.Q.level = myHero:GetSpellData(_Q).level
  self.W.level = myHero:GetSpellData(_W).level
  self.E.level = myHero:GetSpellData(_E).level
  self.R.level = myHero:GetSpellData(_R).level
  
  self.EnemyMinions:update()
  self.JungleMobs:update()
  
  self.TrueRange = myHero.range+myHero.boundingRadius
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Targets()

  self.QTS:update()
  self.ETS:update()
  self.STS:update()
  
  self.QTarget = self.QTS.target
  self.ETarget = self.ETS.target
  self.STarget = self.STS.target
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Combo()

  if self.Ball == nil then
    return
  end
  
  local ComboQ = self.Menu.Combo.Q
  local ComboQ2 = self.Menu.Combo.Q2
  local ComboW = self.Menu.Combo.W
  local ComboW2 = self.Menu.Combo.W2
  local ComboE = self.Menu.Combo.E
  local ComboE2 = self.Menu.Combo.E2
  local ComboR = self.Menu.Combo.R
  local ComboR2 = self.Menu.Combo.R2
  local ComboR3 = self.Menu.Combo.R3
  local ComboItem = self.Menu.Combo.Item
  
  if self.QTarget ~= nil and self.Q.ready and ComboQ and ComboQ2 <= self:ManaPercent() then
  
    if ValidTarget(self.QTarget, self.Q.range+self.Q.radius) then
      self:CastQ(self.QTarget, "Combo")
    end
    
    local QPos, QHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["Q"], self.QTarget, myHero)
    
    if QHitChance == 0 then
    
      for i, enemy in ipairs(self.EnemyHeroes) do
      
        if enemy ~= nil and ValidTarget(enemy, self.Q.range+self.Q.radius) then
          self:CastQ(enemy, "Combo")
        end
        
      end
      
    elseif self.Ball ~= myHero and QHitChance >= self.Menu.HitChance.Combo.Q and self.E.ready and ComboE and ComboQ2+ComboE2 <= self:ManaPercent() then
    
      local Time_QE = math.huge
      local Target_E = nil
      
      for i, ally in ipairs(self.AllyHeroes) do
      
        if ally == nil then
          return
        end
        
        if Time_QE > GetDistance(ally, self.Ball)/1800+GetDistance(self.QTarget, ally)/1200 then
          Time_QE = GetDistance(ally, self.Ball)/1800+GetDistance(self.QTarget, ally)/1200
          Target_E = ally
        end
        
      end
      
      if Target_E and GetDistance(self.QTarget, self.Ball)/1200 > .125+Time_QE then
        self:GiveE(Target_E)
      end
      
    end
    
  end
  
  if self.W.ready and ComboW and ComboW2 <= self:ManaPercent() then
  
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy ~= nil and ValidTarget(enemy, self.W.range+self.W.radius) then
        self:CastW(enemy, "Combo")
      end
      
    end
    
  end
  
  if self.QTarget ~= nil and self.ETarget ~= nil and self.E.ready and ComboE and ComboE2 <= self:ManaPercent() then
  
    local ComboE3 = self.Menu.Combo.E3
    
    if not ComboE3 and ValidTarget(self.ETarget, self.E.range) or ComboE3 and ValidTarget(self.ETarget, self.Q.range) then
      self:CastE(self.ETarget)
    end
    
    if ComboE3 and self:EnemyHeroesCount(350) > 0 then
    
      for i, enemy in ipairs(self.EnemyHeroes) do
      
        if enemy ~= nil and ValidTarget(enemy, self.E.range) then
          self:CastE(enemy)
        end
        
      end
      
    end
    
  end
  
  if self.E.ready and self.R.ready and ComboE and (ComboR or ComboR2) and ComboE2+ComboR3 <= self:ManaPercent() then
  
    local breakfor = false
    
    for i, ally in ipairs(self.AllyHeroes) do
    
      if ally == nil then
        return
      end
      
      for j, enemy in ipairs(self.EnemyHeroes) do
      
        if enemy ~= nil and ValidTarget(enemy, self.R.range+self.R.radius) then
        
          local RPos, RHitChance, RNoH = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["R"], enemy, ally, true)
          
          if ComboR then
          
            local QenemyDmg = ComboQ and GetDistance(enemy, myHero) < self.Q.range+self.Q.radius and (self.Q.ready and 2*self:GetDmg("Q", enemy) or self:GetDmg("Q", enemy)) or 0
            local WenemyDmg = ComboW and self.W.ready and self:GetDmg("W", enemy) or 0
            local RenemyDmg = self:GetDmg("R", enemy)
            --consider mana
            if RHitChance >= self.Menu.HitChance.Combo.R and QenemyDmg+WenemyDmg+RenemyDmg >= enemy.health then
              self:GiveE(ally)
              breakfor = true
              break
            end
            
          end
          
          if ComboR2 and RNoH >= self.Menu.Combo.R4 then
            self:GiveE(ally)
            breakfor = true
            break
          end
          
        end
        
      end
      
      if breakfor then
        break
      end
      
    end
    
  end
  
  if self.R.ready and (ComboR or ComboR2) and ComboR3 <= self:ManaPercent() then
  
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy ~= nil and ValidTarget(enemy, self.R.range+self.R.radius) then
      
        if ComboR then
        
          local QenemyDmg = ComboQ and GetDistance(enemy, myHero) < self.Q.range+self.Q.radius and (self.Q.ready and 2*self:GetDmg("Q", enemy) or self:GetDmg("Q", enemy)) or 0
          local WenemyDmg = ComboW and self.W.ready and self:GetDmg("W", enemy) or 0
          local RenemyDmg = self:GetDmg("R", enemy)
          --consider mana
          if QenemyDmg+WenemyDmg+RenemyDmg >= enemy.health then
            self:CastR(enemy, "ComboS")
          end
          
        end
        
        if ComboR2 then
          self:CastR(enemy, "ComboM")
        end
        
      end
      
    end
    
  end
  
  if STarget ~= nil and ComboItem then
  
    local ComboBRK = self.Menu.Combo.BRK
    local BCSTargetDmg = self:GetDmg("BC", STarget)
    local BRKSTargetDmg = self:GetDmg("BRK", STarget)
    local SBSTargetDmg = self:GetDmg("STALKER", STarget)
    
    if self.Items["Stalker"].ready and ValidTarget(STarget, self.S.range) then
      self:CastS(STarget)
    end
    
    if ComboBRK >= self:HealthPercent(myHero) then
    
      if self.Items["BC"].ready and ValidTarget(STarget, self.Items["BC"].range) then
        self:CastBC(STarget)
      elseif self.Items["BRK"].ready and ValidTarget(STarget, self.Items["BRK"].range) then
        self:CastBRK(STarget)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Farm()

  local FarmQ = self.Menu.Clear.Farm.Q
  local FarmQ2 = self.Menu.Clear.Farm.Q2
  local FarmW = self.Menu.Clear.Farm.W
  local FarmW2 = self.Menu.Clear.Farm.W2
  local FarmE = self.Menu.Clear.Farm.E
  local FarmE2 = self.Menu.Clear.Farm.E2
  
  if self.Q.ready and FarmQ and FarmQ2 <= self:ManaPercent() then
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local QMinionDmg = .7*self:GetDmg("Q", minion)
      
      if QMinionDmg >= minion.health and ValidTarget(minion, self.Q.range+self.Q.radius) then
        self:CastQ(minion)
      end
      
    end
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local AAMinionDmg = self:GetDmg("AA", minion)
      local QMinionDmg = self:GetDmg("Q", minion)
      
      if QMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, self.Q.range+self.Q.radius) then
        self:CastQ(minion)
      end
      
    end
    
  end
  
  if self.W.ready and FarmW and FarmW2 <= self:ManaPercent() then
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local WMinionDmg = self:GetDmg("W", minion)
      
      if WMinionDmg >= minion.health and ValidTarget(minion, self.W.range+self.W.radius) then
        self:CastW(minion)
      end
      
    end
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local AAMinionDmg = self:GetDmg("AA", minion)
      local WMinionDmg = self:GetDmg("W", minion)
      
      if WMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, self.W.range+self.W.radius) then
        self:CastW(minion)
      end
      
    end
    
  end
  
  if self.E.ready and FarmE and FarmE2 <= self:ManaPercent() then
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local EMinionDmg = self:GetDmg("E", minion)
      
      if EMinionDmg >= minion.health and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
      end
      
    end
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local AAMinionDmg = self:GetDmg("AA", minion)
      local EMinionDmg = self:GetDmg("E", minion)
      
      if EMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:JFarm()

  local JFarmQ = self.Menu.Clear.JFarm.Q
  local JFarmQ2 = self.Menu.Clear.JFarm.Q2
  local JFarmW = self.Menu.Clear.JFarm.W
  local JFarmW2 = self.Menu.Clear.JFarm.W2
  local JFarmE = self.Menu.Clear.JFarm.E
  local JFarmE2 = self.Menu.Clear.JFarm.E2
  
  if self.Q.ready and JFarmQ and JFarmQ2 <= self:ManaPercent() then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and self.Ball ~= nil and self.Ball ~= myHero and self.E.ready and JFarmE and JFarmQ2+JFarmE2 <= self:ManaPercent() then
      
        local QPos, QHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["Q"], LargeJunglemob, self.Ball)
        local Time_QE = math.huge
        local Target_E = nil
        
        if QHitChance < 1 then
        
          for i, ally in ipairs(self.AllyHeroes) do
          
            if ally == nil then
              return
            end
            
            if ally ~= nil and Time_QE > GetDistance(ally, self.Ball)/1800+GetDistance(LargeJunglemob, ally)/1200 then
              Time_QE = GetDistance(ally, self.Ball)/1800+GetDistance(LargeJunglemob, ally)/1200
              Target_E = ally
            end
            
          end
          
          if Target_E then
            self:GiveE(Target_E)
          end
          
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= self.Q.range+self.Q.radius and ValidTarget(LargeJunglemob, self.Q.range+self.Q.radius) then
        self:CastQ(LargeJunglemob)
        return
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      if ValidTarget(junglemob, self.Q.range+self.Q.radius) then
        self:CastQ(junglemob)
      end
      
      if junglemob ~= nil and self.Ball ~= nil and self.Ball ~= myHero and self.E.ready and JFarmE and JFarmQ2+JFarmE2 <= self:ManaPercent() then
      
        local QPos, QHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["Q"], junglemob, self.Ball)
        local Time_QE = math.huge
        local Target_E = nil
        
        if QHitChance < 1 then
        
          for i, ally in ipairs(self.AllyHeroes) do
          
            if ally == nil then
              return
            end
            
            if Time_QE > GetDistance(ally, self.Ball)/1800+GetDistance(LargeJunglemob, ally)/1200 then
              Time_QE = GetDistance(ally, self.Ball)/1800+GetDistance(LargeJunglemob, ally)/1200
              Target_E = ally
            end
            
          end
          
          if Target_E then
            self:GiveE(Target_E)
          end
          
        end
        
      end
      
    end
    
  end
  
  if self.W.ready and JFarmW and JFarmW2 <= self:ManaPercent() then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= self.W.range+self.W.radius and ValidTarget(LargeJunglemob, self.W.range+self.W.radius) then
        self:CastW(LargeJunglemob)
        return
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      if ValidTarget(junglemob, self.W.range+self.W.radius) then
        self:CastW(junglemob)
      end
      
    end
    
  end
  
  if self.E.ready and JFarmE and JFarmE2 <= self:ManaPercent() then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= self.E.range and ValidTarget(LargeJunglemob, 400) then
        self:CastE(LargeJunglemob)
        return
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      if ValidTarget(junglemob, 400) then
        self:CastE(junglemob)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:All()

  self:MoveToMouse()
  
  if self.Q.ready then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local QMinionDmg = .7*self:GetDmg("Q", minion)
      
      if QMinionDmg >= minion.health and ValidTarget(minion, self.Q.range+self.Q.radius) then
        self:CastQ(minion)
      end
      
    end
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local AAMinionDmg = self:GetDmg("AA", minion)
      local QMinionDmg = self:GetDmg("Q", minion)
      
      if QMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, self.Q.range+self.Q.radius) then
        self:CastQ(minion)
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= self.Q.range+self.Q.radius and ValidTarget(LargeJunglemob, self.Q.range+self.Q.radius) then
        self:CastQ(LargeJunglemob)
        return
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      if ValidTarget(junglemob, self.Q.range+self.Q.radius) then
        self:CastQ(junglemob)
      end
      
    end
    
  end
  
  if self.W.ready then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local WMinionDmg = self:GetDmg("W", minion)
      
      if WMinionDmg >= minion.health and ValidTarget(minion, self.W.range+self.W.radius) then
        self:CastW(minion)
      end
      
    end
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local AAMinionDmg = self:GetDmg("AA", minion)
      local WMinionDmg = self:GetDmg("W", minion)
      
      if WMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, self.W.range+self.W.radius) then
        self:CastW(minion)
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= self.W.range+self.W.radius and ValidTarget(LargeJunglemob, self.W.range+self.W.radius) then
        self:CastW(LargeJunglemob)
        return
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      if ValidTarget(junglemob, self.W.range+self.W.radius) then
        self:CastW(junglemob)
      end
      
    end
    
  end
  
  if self.E.ready then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local EMinionDmg = self:GetDmg("E", minion)
      
      if EMinionDmg >= minion.health and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
      end
      
    end
    
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local AAMinionDmg = self:GetDmg("AA", minion)
      local EMinionDmg = self:GetDmg("E", minion)
      
      if EMinionDmg+2.5*AAMinionDmg <= minion.health and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local LargeJunglemob = nil
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] then
          LargeJunglemob = junglemob
          break
        end
        
      end
      
      if LargeJunglemob ~= nil and GetDistance(LargeJunglemob, mousePos) <= self.E.range and ValidTarget(LargeJunglemob, 400) then
        self:CastE(LargeJunglemob)
        return
      end
      
    end
    
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      if ValidTarget(junglemob, 400) then
        self:CastE(junglemob)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Harass()

  if self.Ball == nil then
    return
  end

  local HarassQ = self.Menu.Harass.Q
  local HarassQ2 = self.Menu.Harass.Q2
  local HarassW = self.Menu.Harass.W
  local HarassW2 = self.Menu.Harass.W2
  local HarassE = self.Menu.Harass.E
  local HarassE2 = self.Menu.Harass.E2
  
  if self.QTarget ~= nil and self.Q.ready and HarassQ and HarassQ2 <= self:ManaPercent() then
  
    if ValidTarget(self.QTarget, self.Q.range+self.Q.radius) then
      self:CastQ(self.QTarget, "Harass")
    end
    
    local QPos, QHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["Q"], self.QTarget, myHero)
    
    if QHitChance == 0 then
    
      for i, enemy in ipairs(self.EnemyHeroes) do
      
        if enemy ~= nil and ValidTarget(enemy, self.Q.range+self.Q.radius) then
          self:CastQ(enemy, "Harass")
        end
        
      end
      
    elseif self.Ball ~= myHero and QHitChance >= self.Menu.HitChance.Harass.Q and self.E.ready and HarassE and HarassQ2+HarassE2 <= self:ManaPercent() then
    
      local Time_QE = math.huge
      local Target_E = nil
      
      for i, ally in ipairs(self.AllyHeroes) do
      
        if ally == nil then
          return
        end
        
        if Time_QE > GetDistance(ally, self.Ball)/1800+GetDistance(self.QTarget, ally)/1200 then
          Time_QE = GetDistance(ally, self.Ball)/1800+GetDistance(self.QTarget, ally)/1200
          Target_E = ally
        end
        
      end
      
      if Target_E and GetDistance(self.QTarget, self.Ball)/1200 > .125+Time_QE then
        self:GiveE(Target_E)
      end
      
    end
    
  end
  
  if self.W.ready and HarassW and HarassW2 <= self:ManaPercent() then
  
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy ~= nil and ValidTarget(enemy, self.W.range+self.W.radius) then
        self:CastW(enemy, "Harass")
      end
      
    end
    
  end
  
  if self.QTarget ~= nil and self.ETarget ~= nil and self.E.ready and HarassE and HarassE2 <= self:ManaPercent() then
  
    local HarassE3 = self.Menu.Harass.E3
    
    if not HarassE3 and ValidTarget(self.ETarget, self.E.range) or HarassE3 and ValidTarget(self.ETarget, self.Q.range) then
      self:CastE(self.ETarget)
    end
    
    if HarassE3 and self:EnemyHeroesCount(350) > 0 then
    
      for i, enemy in ipairs(self.EnemyHeroes) do
      
        if enemy ~= nil and ValidTarget(enemy, self.E.range) then
          self:CastE(enemy)
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:LastHit()

  local LastHitQ = self.Menu.LastHit.Q
  local LastHitQ2 = self.Menu.LastHit.Q2
  local LastHitW = self.Menu.LastHit.W
  local LastHitW2 = self.Menu.LastHit.W2
  local LastHitE = self.Menu.LastHit.E
  local LastHitE2 = self.Menu.LastHit.E2
  
  if self.Q.ready and LastHitQ and LastHitQ2 <= self:ManaPercent() then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local QMinionDmg = .7*self:GetDmg("Q", minion)
      
      if QMinionDmg >= minion.health and ValidTarget(minion, self.Q.range+self.Q.radius) then
        self:CastQ(minion)
      end
      
    end
    
  end
  
  if self.W.ready and LastHitW and LastHitW2 <= self:ManaPercent() then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local WMinionDmg = self:GetDmg("W", minion)
      
      if WMinionDmg >= minion.health and ValidTarget(minion, self.W.range+self.W.radius) then
        self:CastW(minion)
      end
      
    end
    
  end
  
  if self.E.ready and LastHitE and LastHitE2 <= self:ManaPercent() then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local EMinionDmg = self:GetDmg("E", minion)
      
      if EMinionDmg >= minion.health and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:JSteal()

  local JStealQ = self.Menu.JSteal.Q
  local JStealW = self.Menu.JSteal.W
  local JStealE = self.Menu.JSteal.E
  local JStealS = self.Menu.JSteal.S
  
  if self.S.ready and JStealS then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
          
      local SJunglemobDmg = self:GetDmg("SMITE", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] and SJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.S.range) then
          self:CastS(junglemob)
          return
        end
        
      end
      
    end
    
  end
  
  if self.Q.ready and JStealQ then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local QJunglemobDmg = .8*self:GetDmg("Q", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] and QJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.Q.range+self.Q.radius) then
          self:CastQ(junglemob)
        end
        
      end
      
    end
    
  end
  
  if self.W.ready and JStealW then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local WJunglemobDmg = self:GetDmg("W", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] and WJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.W.range+self.W.radius) then
          self:CastW(junglemob)
        end
        
      end
      
    end
    
  end
  
  if self.E.ready and JStealE then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local EJunglemobDmg = self:GetDmg("E", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if junglemob.name == self.FocusJungleNames[j] and EJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.E.range) then
          self:CastE(junglemob)
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:JstealAlways()

  if self.S.ready then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local SJunglemobDmg = self:GetDmg("SMITE", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if (junglemob.name == "SRU_Baron12.1.1" or junglemob.name == "SRU_Dragon6.1.1") and SJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.S.range) then
          self:CastS(junglemob)
          return
        end
        
      end
      
    end
    
  end
  
  if self.Q.ready then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local QJunglemobDmg = .8*self:GetDmg("Q", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if (junglemob.name == "SRU_Baron12.1.1" or junglemob.name == "SRU_Dragon6.1.1") and QJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.Q.range+self.Q.radius) then
          self:CastQ(junglemob)
        end
        
      end
      
    end
    
  end
  
  if self.W.ready then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local WJunglemobDmg = self:GetDmg("W", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if (junglemob.name == "SRU_Baron12.1.1" or junglemob.name == "SRU_Dragon6.1.1") and WJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.W.range+self.W.radius) then
          self:CastW(junglemob)
        end
        
      end
      
    end
    
  end
  
  if self.E.ready then
  
    for i, junglemob in pairs(self.JungleMobs.objects) do
    
      local EJunglemobDmg = self:GetDmg("E", junglemob)
      
      for j = 1, #self.FocusJungleNames do
      
        if (junglemob.name == "SRU_Baron12.1.1" or junglemob.name == "SRU_Dragon6.1.1") and EJunglemobDmg >= junglemob.health and ValidTarget(junglemob, self.E.range) then
          self:CastE(junglemob)
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:KillSteal()

  local KillStealQ = self.Menu.KillSteal.Q
  local KillStealW = self.Menu.KillSteal.W
  local KillStealE = self.Menu.KillSteal.E
  local KillStealR = self.Menu.KillSteal.R
  local KillStealI = self.Menu.KillSteal.I
  local KillStealS = self.Menu.KillSteal.S
  
  for i, enemy in ipairs(self.EnemyHeroes) do
  
    if enemy == nil then
      return
    end
    
    local QenemyDmg = KillStealQ and GetDistance(enemy, myHero) < self.Q.range+self.Q.radius and self.Q.ready and .8*self:GetDmg("Q", enemy) or 0
    local WenemyDmg = KillStealW and self.W.ready and self:GetDmg("W", enemy) or 0
    local EenemyDmg = self.E.ready and self:GetDmg("E", enemy) or 0
    local RenemyDmg = KillStealR and self.R.ready and self:GetDmg("R", enemy) or 0
    local IenemyDmg = self.I.ready and self:GetDmg("IGNITE", enemy) or 0
    local SBenemyDmg = self.Items["Stalker"].ready and self:GetDmg("STALKER", enemy) or 0
    
    if KillStealI and IenemyDmg >= enemy.health and ValidTarget(enemy, self.I.range) then
      self:CastI(enemy)
    end
    
    if KillStealS and SBenemyDmg >= enemy.health and ValidTarget(enemy, self.S.range) then
      self:CastS(enemy)
    end
    
    if KillStealQ and QenemyDmg+WenemyDmg+RenemyDmg >= enemy.health and ValidTarget(enemy, self.Q.range+self.Q.radius) then
      self:CastQ(enemy)
    end
    
    if KillStealW and QenemyDmg+WenemyDmg+RenemyDmg >= enemy.health and ValidTarget(enemy, self.W.range+self.W.radius) then
      self:CastW(enemy)
    end
    
    if KillStealE and EenemyDmg >= enemy.health and ValidTarget(enemy, self.E.range) then
      self:CastE(enemy)
    end
    
    if KillStealR and QenemyDmg+WenemyDmg+RenemyDmg >= enemy.health and ValidTarget(enemy, self.R.range+self.R.radius) then
      self:CastR(enemy)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:Auto()

  if self.Ball == nil then
    return
  end
  
  local AutoW = self.Menu.Auto.W
  local AutoW2 = self.Menu.Auto.W2
  local AutoW3 = self.Menu.Auto.W3
  local AutoR = self.Menu.Auto.R
  local AutoR2 = self.Menu.Auto.R2
  local AutoR3 = self.Menu.Auto.R3
  
  if self.W.ready and AutoW and AutoW2 <= self:ManaPercent() then
  
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy ~= nil and ValidTarget(enemy, self.W.range+self.W.radius) then
      
        local WPos, WHitChance, WNoH = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["W"], enemy, self.Ball, true)
        
        if WNoH >= AutoW3 then
          self:CastW_Stat()
          break
        end
        
      end
      
    end
    
  end
  
  if self.R.ready and AutoR and AutoR2 <= self:ManaPercent() then
  
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy ~= nil and ValidTarget(enemy, self.R.range+self.R.radius) then
      
        local RPos, RHitChance, RNoH = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["R"], enemy, self.Ball, true)
        
        if RNoH >= AutoR3 then
          self:CastR_Stat()
          break
        end
        
      end
      
    end
    
  end
  
end
---------------------------------------------------------------------------------

function HTTF_Orianna:Flee()

  self:MoveToMouse()
  
  if self.W.ready and self.Ball == myHero then
    CastSpell(_W)
  end
  
  if self.E.ready and self.Ball ~= nil and self.Ball ~= myHero then
    self:GiveE(myHero)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:EnemyHeroesCount(range)

  local count = 0
  
  for i, enemy in ipairs(self.EnemyHeroes) do
  
    if enemy ~= nil and ValidTarget(enemy, range) then
      count = count + 1
    end
    
  end
  
  return count
end

---------------------------------------------------------------------------------

function HTTF_Orianna:HealthPercent(unit)
  return (unit.health/unit.maxHealth)*100
end

function HTTF_Orianna:ManaPercent()
  return (myHero.mana/myHero.maxMana)*100
end

---------------------------------------------------------------------------------

function HTTF_Orianna:GetDmg(spell, enemy)

  if enemy == nil then
    return
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
    APDmg = 30*self.Q.level+30+.5*AP
  elseif spell == "W" then
    APDmg = 45*self.W.level+25+.7*AP
  elseif spell == "E" then
    ADDmg = 30*self.E.level+30+.3*AP
  elseif spell == "R" then
    APDmg = 75*self.R.level+75+.7*AP
  end
  
  local TrueDmg = ADDmg*(1-ArmorPercent)+APDmg*(1-MagicArmorPercent)
  
  return TrueDmg
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:CastQ(unit, mode)

  if unit.dead or self.Ball == nil then
    return
  end
  
  self.QPos, self.QHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["Q"], unit, self.Ball)
	
  if mode == "Combo" and self.QHitChance >= self.Menu.HitChance.Combo.Q or mode == "Harass" and self.QHitChance >= self.Menu.HitChance.Harass.Q or mode == nil and self.QHitChance >= 1 then
  
    if VIP_USER and self.Menu.Misc.UsePacket then
      Packet("S_CAST", {spellId = _Q, toX = self.QPos.x, toY = self.QPos.z, fromX = self.QPos.x, fromY = self.QPos.z}):send()
    else
      CastSpell(_Q, self.QPos.x, self.QPos.z)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastW(unit, mode)

  if unit.dead or self.Ball == nil then
    return
  end
  
  self.WPos, self.WHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["W"], unit, self.Ball)
  
  if mode == "Combo" and self.WHitChance >= self.Menu.HitChance.Combo.W or mode == "Harass" and self.WHitChance >= self.Menu.HitChance.Harass.W or mode == nil and self.WHitChance >= 3 then
    self:CastW_Stat()
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastW_Stat()

  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _W}):send()
  else
    CastSpell(_W)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastE(unit)

  if unit.dead or self.Ball == nil or self.Ball == myHero then
    return
  end
  
  self.EHit = self.HPred:SpellCollision(self.HPred.Presets["Orianna"]["E"], unit, self.Ball, myHero)
  
  if self.EHit then
  
    if VIP_USER and self.Menu.Misc.UsePacket then
      Packet("S_CAST", {spellId = _E, targetNetworkId = myHero.networkID}):send()
    else
      CastSpell(_E, myHero)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:GiveE(unit)

  if unit.dead or self.Ball == nil or self.Ball == unit then
    return
  end
  
  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
  else
    CastSpell(_E, unit)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:ProtectE(unit)

  if self.Ball == nil then
    return
  end
  
  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
  else
    CastSpell(_E, unit)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastR(unit, mode)

  if unit.dead or self.Ball == nil then
    return
  end
  
  if mode == "ComboS" then
    self.RPos, self.RHitChance = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["R"], unit, self.Ball)
    
    if self.RHitChance >= self.Menu.HitChance.Combo.R then
      self:CastR_Stat()
      return
    end
    
  else
    self.RPos, self.RHitChance, self.RNoH = self.HPred:GetPredict(self.HPred.Presets["Orianna"]["R"], unit, self.Ball, true)
  end
  
  if mode == "ComboM" and self.RNoH >= self.Menu.Combo.R4 or mode == nil and self.RHitChance >= 3 then
    self:CastR_Stat()
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastR_Stat()

  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = _R}):send()
  else
    CastSpell(_R)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastI(enemy)

  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = self.Ignite, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(self.Ignite, enemy)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastS(enemy)

  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = self.Smite, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(self.Smite, enemy)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastBC(enemy)

  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = self.Items["BC"].slot, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(self.Items["BC"].slot, enemy)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CastBRK(enemy)

  if VIP_USER and self.Menu.Misc.UsePacket then
    Packet("S_CAST", {spellId = self.Items["BRK"].slot, targetNetworkId = enemy.networkID}):send()
  else
    CastSpell(self.Items["BRK"].slot, enemy)
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:MoveToMouse()

  if mousePos and GetDistance(mousePos) <= 100 then
    self.MousePos = myHero+(Vector(mousePos)-myHero):normalized()*300
  else
    self.MousePos = mousePos
  end
  
  myHero:MoveTo(self.MousePos.x, self.MousePos.z)
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:Draw()

  if not self.Menu.Draw.On or myHero.dead then
    return
  end
  
  if self.Menu.Harass.On or self.Menu.Harass.On2 then
    DrawText("Harass: On", 20, 1600, 150, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  else
    DrawText("Harass: Off", 20, 1600, 150, ARGB(0xFF, 0xFF, 0x80, 0x80))
  end
  
  if self.Menu.JSteal.On or self.Menu.JSteal.On2 then
    DrawText("Jungle Steal: On", 20, 1600, 200, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  else
    DrawText("Jungle Steal: Off", 20, 1600, 200, ARGB(0xFF, 0x80, 0x80, 0xFF))
  end
  
  if self.Menu.Draw.Target.Q and self.QTarget ~= nil then
    self:DrawCircles(self.QTarget.x, self.QTarget.y, self.QTarget.z, self.Q.radius, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if self.Menu.Draw.Target.E and self.ETarget ~= nil then
    self:DrawCircles(self.ETarget.x, self.ETarget.y, self.ETarget.z, self.E.width/2, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if self.QHitChance ~= nil then
  
    if self.QHitChance < 1 then
      self.Qcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    elseif self.QHitChance == 3 then
      self.Qcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    elseif self.QHitChance >= 2 then
      self.Qcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
    elseif self.QHitChance >= 1 then
      self.Qcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
    end
  
  end
  
  if self.WHitChance ~= nil then
  
    if self.WHitChance < 1 then
      self.Wcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    elseif self.WHitChance == 3 then
      self.Wcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    elseif self.WHitChance >= 2 then
      self.Wcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
    elseif self.WHitChance >= 1 then
      self.Wcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
    end
  
  end
  
  if self.EHit ~= nil then
  
    if self.EHit then
      self.Ecolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    else
      self.Ecolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    end
    
  end
  
  if self.RHitChance ~= nil then
  
    if self.RHitChance < 1 then
      self.Rcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
    elseif self.RHitChance == 3 then
      self.Rcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
    elseif self.RHitChance >= 2 then
      self.Rcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
    elseif self.RHitChance >= 1 then
      self.Rcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
    end
    
  end
  
  if self.Ball ~= nil then
  
    if self.Menu.Draw.PP.Q and self.QPos ~= nil then
    
      self:DrawCircles(self.QPos.x, self.QPos.y, self.QPos.z, self.Q.radius, self.Qcolor)
      
      if self.Menu.Draw.PP.Line then
        DrawLine3D(self.Ball.x, self.Ball.y, self.Ball.z, self.QPos.x, self.QPos.y, self.QPos.z, 2, self.Qcolor)
      end
      
      self.QPos = nil
    end
    
    if self.Menu.Draw.PP.E and self.EHit ~= nil then
      DrawLine3D(self.Ball.x, self.Ball.y, self.Ball.z, myHero.x, myHero.y, myHero.z, 2, self.Ecolor)
    end
    
  end
  
  if self.Menu.Draw.Hitchance then
  
    if self.QHitChance ~= nil then
      DrawText("Q HitChance: "..self.QHitChance, 20, 1250, 550, self.Qcolor)
      self.QHitChance = nil
    end
  
    if self.WHitChance ~= nil then
      DrawText("W HitChance: "..self.WHitChance, 20, 1250, 600, self.Wcolor)
      self.WHitChance = nil
    end
  
    if self.EHit ~= nil then
      DrawText("E Hit: "..tostring(self.EHit), 20, 1250, 650, self.Ecolor)
    end
    
    if self.RHitChance ~= nil then
      DrawText("R HitChance: "..self.RHitChance, 20, 1250, 700, self.Rcolor)
      self.RHitChance = nil
      
      if self.RNoH ~= nil then
        DrawText("R NoH: "..self.RNoH, 20, 1050, 550, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
        self.RNoH = nil
      end
      
    end
    
  end
  
  self.EHit = nil
  
  if self.Menu.Draw.AA then
    self:DrawCircles(myHero.x, myHero.y, myHero.z, self.TrueRange, ARGB(0xFF, 0, 0xFF, 0))
  end
  
  if self.Menu.Draw.Q then
    self:DrawCircles(myHero.x, myHero.y, myHero.z, self.Q.range, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if self.Ball ~= nil then
  
    if self.Menu.Draw.Ball then
      self:DrawCircles(self.Ball.x, self.Ball.y, self.Ball.z, self.Q.radius, ARGB(0xFF, 0xFF, 0x5E, 0x00))
    end
    
    if self.Menu.Draw.W and self.W.ready then
      self:DrawCircles(self.Ball.x, self.Ball.y, self.Ball.z, self.W.radius, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
    end
    
    if self.Menu.Draw.R and self.R.ready then
      self:DrawCircles(self.Ball.x, self.Ball.y, self.Ball.z, self.R.radius, ARGB(0xFF, 0x00, 0x00, 0xFF))
    end
    
  end
  
  if self.Menu.Draw.I and self.I.ready then
    self:DrawCircles(myHero.x, myHero.y, myHero.z, self.I.range, ARGB(0xFF, 0xFF, 0x24, 0x24))
  end
  
  if self.Menu.Draw.S and self.S.ready and (self.Menu.JSteal.On or self.Menu.JSteal.On2) and self.Menu.JSteal.S then
    self:DrawCircles(myHero.x, myHero.y, myHero.z, self.S.range, ARGB(0xFF, 0xFF, 0x14, 0x93))
  end
  
  if self.Menu.Draw.Path then
  
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
    
    for i, enemy in ipairs(self.EnemyHeroes) do
    
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

function HTTF_Orianna:DrawCircles(x, y, z, radius, color)

  if self.Menu.Draw.Lfc then
  
    local v1 = Vector(x, y, z)
    local v2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = v1-(v1-v2):normalized()*radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    
    if OnScreen({x = sPos.x, y = sPos.y}, {x = sPos.x, y = sPos.y}) then
      self:DrawCircles2(x, y, z, radius, color) 
    end
    
  else
    DrawCircle(x, y, z, radius, color)
  end
  
end

function HTTF_Orianna:DrawCircles2(x, y, z, radius, color)

  local length = 75
  local radius = radius*.92
  local quality = math.max(8,round(180/math.deg((math.asin((length/(2*radius)))))))
  local quality = 2*math.pi/quality
  local points = {}
  
  for theta = 0, 2*math.pi+quality, quality do
  
    local c = WorldToScreen(D3DXVECTOR3(x+radius*math.cos(theta), y, z-radius*math.sin(theta)))
    points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  
  DrawLines2(points, 1, color or 4294967295)
end

function round(num)

  if num >= 0 then
    return math.floor(num+.5)
  else
    return math.ceil(num-.5)
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Orianna:Animation(unit, animation)

  if not unit.isMe then
    return
  end
  
  if animation == "Prop" then
    self.Ball = unit
  end
  
  if animation == "recall" then
    self.IsRecall = true
  elseif animation == "recall_winddown" or animation == "Run" or animation == "Spell1" or animation == "Spell2" or animation == "Spell3" or animation == "Spell4" then
    self.IsRecall = false
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:CreateObj(object)

  if object.team ~= myHero.team then
    return
  end
  
  if object.name == "TheDoomBall" then
    self.Ball = object
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Orianna:ProcessSpell(unit, spell)

  --[[if unit.team ~= myHero.team then
  
    if not spell.name:find("Attack") and spell.target == myHero then
      self:CastE(myHero)
    end
    
  else
  
  end]]
  
  if not unit.isMe then
    return
  end
  
  if spell.name == "OrianaIzunaCommand" then
    self.Ball = nil
  end
  
  if spell.name == "OrianaRedactCommand" then
    self.Ball = spell.target
  end
  
end
