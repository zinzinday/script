if myHero.charName ~= "Vi"  then return end
local version = 0.1
local AUTOUPDATE = true
local SCRIPT_NAME = "SXVi"
require 'VPrediction'
require "SxOrbwalk"
--require 'Prodiction' 
--require 'Collision'
require 'DivinePred'
require 'HPrediction'

function CheckUpdate()
        local scriptName = "SXVi"
        local version = 1.0
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXVi"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXVi"..scriptName..".lua"
        ScriptUpdate(ToUpdate.Version, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath)
end
class "ScriptUpdate"
function ScriptUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
    self.CallbackUpdate = function(NewVersion, OldVersion) print("Updated to "..NewVersion..". Please Reload with 2x F9.") end
    self.CallbackNoUpdate = function(OldVersion) print("No Updates Found") end
    self.CallbackNewVersion = function(NewVersion) print("New Version found ("..NewVersion.."). Please wait..") end
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
--Credit Trees

-- Constants --

local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {1,2,3,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2}
local Ranges = { AA = 175 }
local skills = {
	SkillQ = { ready = true, name = "Vault Breaker" , range = 1000, delay = 0.25, speed = 1500, width = 55 },
	SkillW = { ready = true, name = "Denting Blows  ", range = 1, delay = 025, speed = 1200, width = 100 },
	SkillE = { ready = true, name = "Excessive Force", range = 600 , delay = 0.25, speed = 1200, width = 100 },
	SkillR = { ready = true, name = "Assault and Battery ", range = 800, delay = 0, speed = 0, width = 0 },
}
--[[ Slots Itens ]]--
local tiamatSlot, hydraSlot, youmuuSlot, bilgeSlot, bladeSlot, dfgSlot, divineSlot = nil, nil, nil, nil, nil, nil, nil
local tiamatReady, hydraReady, youmuuReady, bilgeReady, bladeReady, dfgReady, divineReady = nil, nil, nil, nil, nil, nil, nil

--[[Auto Attacks]]--
local lastBasicAttack = 0
local swingDelay = 0.25
local swing = false

--[[Misc]]--
local lastSkin = 0
local isSAC = false
local isMMA = false
local target = nil
--Credit Trees
function GetCustomTarget()
	ts:update()
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
  if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	return ts.target
end
function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
	initComponents()
   Vi_Q  = HPSkillshot({type = "DelayLine", delay = 0.25, range = Vi_Q_Range(), speed = 1500,  width = 110,  IsVeryLowAccuracy = true})

--HPSkillshot({type = "DelayLine", delay = 0.25, range = 1525, speed = 1200, collisionM = true, collisionH = true, width = 90, IsVeryLowAccuracy = true})
  
end
function initComponents()
VP = VPrediction()
  DP = DivinePred()
    HPred = HPrediction()

   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 4000)
  
 Menu = scriptConfig("SXVi by SyraX", "ViMA")

   if _G.MMA_Loaded ~= nil then
     PrintChat("<font color = \"#33CCCC\">MMA Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isMMA = true
 elseif _G.AutoCarry ~= nil then
      PrintChat("<font color = \"#33CCCC\">SAC Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isSAC = true
 else
  PrintChat("<font color = \"#33CCCC\">OrbWalker not found:</font> <font color = \"#fff8e7\"> Loading SX</font>")
    Menu:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)

   -- Menu:addTS(ts)
    end
  
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "ViCombo")
    Menu.ViCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.ViCombo:addSubMenu("Q Settings", "qSet")
    
  Menu.ViCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)

  --Menu.ViCombo.qSet:addParam("Bush", " if you are in bush use Q when target close", SCRIPT_PARAM_ONOFF, true)
 
 Menu.ViCombo:addSubMenu("W Settings", "wSet")
  Menu.ViCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 --  Menu.ViCombo.wSet:addParam("WMode", "Use Ultimate enemy count:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
  
 Menu.ViCombo:addSubMenu("E Settings", "eSet")
  Menu.ViCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.ViCombo:addSubMenu("R Settings", "rSet")
  Menu.ViCombo.rSet:addParam("useR", "use R in combo ", SCRIPT_PARAM_ONOFF, true)
   Menu.ViCombo.rSet:addParam("RMode", "Use Ultimate enemy count:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
   Menu.ViCombo.rSet:addParam("RH", " max %Health til use R:", SCRIPT_PARAM_SLICE, 25, 0, 100, 0) 
   Menu.ViCombo.rSet:addParam("RL", " min %Health til use R:", SCRIPT_PARAM_SLICE, 25, 0, 100, 0) 
   Menu.ViCombo.rSet:addParam("Click", "Ult target on double click target", SCRIPT_PARAM_ONOFF, false)
  -- Menu.ViCombo.rSet:addParam("Tower", " Use R to div under tower", SCRIPT_PARAM_ONOFF, false)
   
   
   Menu:addSubMenu("[" ..myHero.charName.."- Ult Blacklist]", "ultb")
    for i, enemy in pairs(GetEnemyHeroes()) do
    Menu.ultb:addParam(enemy.charName, "Use ult on: "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
  end
  
  Menu:addSubMenu("["..myHero.charName.." - Prodiction Settings]", "ProdSettings") -- Menu.ProdSettings.SelectProdiction
 -- Menu.selectProdSettings == 1 or 2
	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 2, {"Devine", "VPrediction", "HPrediction"})

 Menu:addSubMenu("["..myHero.charName.." - Harass]", "Harass")
  Menu.Harass:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
  Menu.Harass:addParam("useQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
    Menu.Harass:addParam("useW", "Use W in Harass", SCRIPT_PARAM_ONOFF, false)
   Menu.Harass:addParam("useE", "Use E in Harass", SCRIPT_PARAM_ONOFF, true)
    
 Menu:addSubMenu("["..myHero.charName.." - Laneclear]", "Laneclear")
    Menu.Laneclear:addParam("lclr", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  Menu.Laneclear:addParam("useClearQ", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
 Menu.Laneclear:addParam("useClearW", "Use W in Laneclear", SCRIPT_PARAM_ONOFF, false)
    Menu.Laneclear:addParam("useClearE", "Use E in Laneclear", SCRIPT_PARAM_ONOFF, true)
 
 Menu:addSubMenu("["..myHero.charName.." - Jungleclear]", "Jungleclear")
    Menu.Jungleclear:addParam("jclr", "Jungleclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  Menu.Jungleclear:addParam("useClearQ", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)
 Menu.Jungleclear:addParam("useClearW", "Use W in Jungleclear", SCRIPT_PARAM_ONOFF, false)
    Menu.Jungleclear:addParam("useClearE", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)
    
       
   --  Menu:addSubMenu("["..myHero.charName.." - Prodiction Settings]", "ProdSettings") -- Menu.ProdSettings.SelectProdiction
 -- Menu.selectProdSettings == 1 or 2
--	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 1, {"HProdiction", "VPrediction", "Devine"})
 -- Menu.ProdSettings:addParam("OD", "OnDash", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("AD", "AfterDash", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings:addParam("AI", "AfterImmobile", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("OI", "OnImmobile ", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings.OD
 
--[[ Menu:addSubMenu("[" .. myHero.charName.." - Passive Priority]", "Passive") 
 Menu.Passive:addParam("SelectPassive", "Choose your passive priority", SCRIPT_PARAM_LIST, 1, {"Q Priority", "W Priority", "E Priotity"})--Menu.Passive.SelectPassive == 1--]]
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads:addParam("Prod", "Use VP in Second cast Q", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
  Menu.Ads.KS:addParam("KS", "Killsteal", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("R", " KSCombo Use r count", SCRIPT_PARAM_ONOFF, false)
  

  Menu.Ads.KS:addParam("autoQ", "OnGapClose", SCRIPT_PARAM_ONOFF, false) -- Menu.Ads.KS.autoQ
  --Menu.Ads.KS:addParam("KSWE", "Killsteal with W and Q", SCRIPT_PARAM_ONOFF, false)--Menu.Ads.KS.KSWE
  Menu.Ads:addSubMenu("VIP", "VIP")
   -- Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
 -- Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 5)
 
    --[[
 Menu:addSubMenu("["..myHero.charName.." - Target Selector]", "targetSelector")
 Menu.targetSelector:addTS(ts)
    ts.name = "Focus"--]]
  
 Menu:addSubMenu("["..myHero.charName.." - Drawings]", "drawings")
  Menu.drawings:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
    
 targetMinions = minionManager(MINION_ENEMY, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
  allyMinions = minionManager(MINION_ALLY, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
 jungleMinions = minionManager(MINION_JUNGLE, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
 
 if Menu.Ads.VIP.skin and VIP_USER then
       GenModelPacket("Vi", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end
  
 PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">Vi</font> <font color = \"#FFA319\">by SyraX V"..version.."</font>")
end
local Vi_OnQ = false
local Vi_LastQ = os.clock()
local LastPrint = 0

function OnTick()
	target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  KS()
  calculationRange()
  OnTowerFocus()
  if os.clock()-LastPrint > 0.1 then
    --print(Vi_Q_Range())
    LastPrint = os.clock()
  end
  if Boss ~= nil then
    if BossTimer + 2 <= GetGameTimer() then
    Boss = false
    BossTimer = math.huge
    king = nil
  end
  end
  --print(ChargeStart)
 -- print(Underground)
  --print(CDQstarted)

  --print(skills.SkillQ.ready)


  if CDQstarted then
    if CDQTimer + 4 <= GetGameTimer() then
      CDQTimer = math.huge
      CDQstarted = false
    end
    end

  if Menu.Ads.VIP.skin and VIP_USER then
       GenModelPacket("lux", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end

 

	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("Vi", Menu.Ads.VIP.skin1)
		lastSkin = Menu.Ads.VIP.skin1
	end
    if click == 2 then
       DoubleClick()
       if click == 2 then
         click = 0
        end
   end
   if click >= 3 then
   click = 0
   end
   if click == 1 then
      if time + 0.4 <= GetGameTimer() then
         click = 0
         time  = math.huge
      end
    end 
  --[[if click == 2 then
       DoubleClick()
       
       
      
   end
   if click > 3 then
   click = 0
   end
   if click == 1 or click == 2 then
      if time + 0.4 <= GetGameTimer() then
         click = 0
         time  = math.huge
      elseif click == 2 and time + 0.4 <= GetGameTimer() then
        click = 0 
        time = math.huge
      end
--]]
    
  -- Enable/Disable certain callbacks when turned on/off by the menu.

 
	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
	if Menu.ViCombo.combo then
		Combo()
	end
	
	if Menu.Harass.harass then
		Harass()
	end
	
	if Menu.Laneclear.lclr then
		LaneClear()
	end
	
	if Menu.Jungleclear.jclr then
		JungleClear()
	end

end

function CDHandler()
	-- Spells
  papi = myHero:GetSpellData(_Q).name == "Prey Seeker"
if not papi then
	skills.SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	skills.SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	skills.SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	skills.SkillR.ready = (myHero:CanUseSpell(_R) == READY)
elseif papi then
  skills.SkillQU.ready = (myHero:CanUseSpell(_Q) == READY)
	skills.SkillWU.ready = (myHero:CanUseSpell(_W) == READY)
	skills.SkillEU.ready = (myHero:CanUseSpell(_E) == READY)
	skills.SkillRU.ready = (myHero:CanUseSpell(_R) == READY)
  end
  

   

	-- Items
	tiamatSlot = GetInventorySlotItem(3077)
	hydraSlot = GetInventorySlotItem(3074)
	youmuuSlot = GetInventorySlotItem(3142) 
	bilgeSlot = GetInventorySlotItem(3144)
	bladeSlot = GetInventorySlotItem(3153)
	dfgSlot = GetInventorySlotItem(3128)
	divineSlot = GetInventorySlotItem(3131)
	
	tiamatReady = (tiamatSlot ~= nil and myHero:CanUseSpell(tiamatSlot) == READY)
	hydraReady = (hydraSlot ~= nil and myHero:CanUseSpell(hydraSlot) == READY)
	youmuuReady = (youmuuSlot ~= nil and myHero:CanUseSpell(youmuuSlot) == READY)
	bilgeReady = (bilgeSlot ~= nil and myHero:CanUseSpell(bilgeSlot) == READY)
	bladeReady = (bladeSlot ~= nil and myHero:CanUseSpell(bladeSlot) == READY)
	dfgReady = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
	divineReady = (divineSlot ~= nil and myHero:CanUseSpell(divineSlot) == READY)

	-- Summoners
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		ignite = SUMMONER_2
	end
	igniteReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
DamageCalculation()
end-- Harass --

function Harass()	
if target ~= nil and target.team ~= myHero.team and target.type == myHero.type then
  if skills.SkillQ.ready and ValidTarget(target, 800) then
    CastSpell(_Q, mousePos.x, mousePos.z)
            if Vi_OnQ and ValidTarget(target, Vi_Q_Range()) then
            if Menu.ProdSettings.SelectProdiction == 2 then 
            QVP()
          --  print("VP")
            elseif  Menu.ProdSettings.SelectProdiction == 1 then
              DevineQ()
             -- print("DP")
            elseif  Menu.ProdSettings.SelectProdiction == 3 then
              CastQ()
            --  print("HP")
            end
  end
end
if skills.SkillE.ready and ValidTarget(target, skills.SkillE.range) then 
  CastSpell(_E, myHero)
  end
end

end
	   ChargeStart = false
      ChargeTimer = math.huge
  function OnApplyBuff(source, unit, buff)
    if buff.name:find("ViQ") then 
      ChargeStart = true
      ChargeTimer = GetGameTimer()
      CastTime = os.clock()
    end
    
    
  end
  
  
function Qrange()
 if CastTime > 0 and os.clock() <= CastTime then
  local T1 = CastTime - os.clock()
  local T2 = LoadSpeed * T1
  local R1 = 725 - T2
  Q.range = R1 - 50
 elseif CastTime > 0 and os.clock() > CastTime then
  Q.range = 725
 elseif not skills.SkillQ.ready then
  Q.range = 725
 end
end
  function OnRemoveBuff(unit, buff)
    if buff.name:find("ViQ") then 
      ChargeStart = false
      ChargeTimer = math.huge
      CastTime = math.huge
    end
    end
    Boss = false
    BossTimer = math.huge
    King = nil
  function calculationRange()
    if target ~= nil and target.team ~= myHero.team and target.type == myHero.type then
      if ChargeStart then
         startRange = 250
         endRange = 900
       
        -- print(targetD)
      if ChargeTimer + 0.05 <= GetGameTimer() then
        realRange = 276
      end
         if ChargeTimer + 0.1 <= GetGameTimer() then
        realRange = 302
      end
      if ChargeTimer + 0.15 <= GetGameTimer() then
        realRange = 328
        end
      if ChargeTimer + 0.2 <= GetGameTimer() then
        realRange = 354
        end
      if ChargeTimer + 0.25 <= GetGameTimer() then
        realRange = 380
        end
      if ChargeTimer + 0.3 <= GetGameTimer() then
        realRange = 406
        end
        
      if ChargeTimer + 0.35 <= GetGameTimer() then
        realRange = 432
        end
      if ChargeTimer + 0.4 <= GetGameTimer() then
        realRange = 458
        end
      if ChargeTimer + 0.45 <= GetGameTimer() then
        realRange = 484
        end
      if ChargeTimer + 0.5 <= GetGameTimer() then
        realRange = 510
        end
      if ChargeTimer + 0.55 <= GetGameTimer() then
        realRange = 536 
        end
      if ChargeTimer + 0.6 <= GetGameTimer() then
        realRange = 562
        end
      if ChargeTimer + 0.65 <= GetGameTimer() then
        realRange = 588
        end
      if ChargeTimer + 0.7 <= GetGameTimer() then
        realRange = 614
      end
       if ChargeTimer + 0.75 <= GetGameTimer() then
        realRange = 640
        end
      if ChargeTimer + 0.8 <= GetGameTimer() then
        realRange = 666
        end
      if ChargeTimer + 0.85 <= GetGameTimer() then
        realRange = 692
        end
      if ChargeTimer + 0.9 <= GetGameTimer() then
        realRange = 718
      end
       if ChargeTimer + 0.95 <= GetGameTimer() then
        realRange = 744
        end
      if ChargeTimer + 1 <= GetGameTimer() then
        realRange = 770
        end
      if ChargeTimer + 1.05 <= GetGameTimer() then
        realRange = 796
        end
      if ChargeTimer + 1.1 <= GetGameTimer() then
        realRange = 822
      end
        if ChargeTimer + 1.15 <= GetGameTimer() then
        realRange = 848
      end
        if ChargeTimer + 1.2 <= GetGameTimer() then
        realRange = 874
      end
        if ChargeTimer + 1.25 <= GetGameTimer() then
        realRange = 900
        end
      
       targetD = GetDistance(target)
       -- print(realRange)
        if targetD ~= nil and realRange ~= nil then
          if targetD <= realRange then
          Boss = true
          BossTimer = GetGameTimer()
          King = D3DXVECTOR3(target.x,target.y,target.z)
        
       else 
         Boss = false
         BossTimer = math.huge
         king = nil
       end
      end
      end
end
end



-- Combo Selector --

function Combo()
	local typeCombo = 0
	if target ~= nil and not Underground then
		AllInCombo(target, 0)
   -- print("allincombo")
	end


end
  
	function AllInCombo(target, typeCombo)
    if target ~= nil and target.team ~= myHero.team and target.type == myHero.type and not target.dead then
      local Health = target.maxHealth / 100
      local HealthCheck = Health * Menu.ViCombo.rSet.RH
      local HealthCheck2 = Health * Menu.ViCombo.rSet.RS
      if skills.SkillR.ready and ValidTarget(target, skills.SkillR.range) and Menu.ViCombo.rSet.useR and not ChargeStart then
        if AreaEnemyCount() <= Menu.ViCombo.rSet.RMode and blCheck(target) and target.health <= HealthCheck and target.health >= HealthCheck2 then 
        CastSpell(_R, target)
        end
end
      if skills.SkillQ.ready and ValidTarget(target, 1000) and  Menu.ViCombo.qSet.useQ then 
        CastSpell(_Q, mousePos.x, mousePos.z)
          if Vi_OnQ and ValidTarget(target, Vi_Q_Range()) then
            if Menu.ProdSettings.SelectProdiction == 2 then 
            QVP()
          --  print("VP")
            elseif  Menu.ProdSettings.SelectProdiction == 1 then
              DevineQ()
             -- print("DP")
            elseif  Menu.ProdSettings.SelectProdiction == 3 then
              CastQ()
            --  print("HP")
            end
         
      end
      end
     if skills.SkillE.ready and ValidTarget(target, skills.SkillE.range) and Menu.ViCombo.eSet.useE and not ChargeStart then
        CastSpell(_E)
     end

   -- print("ja Hij doet het")
  end
  end


  
  
-- All In Combo -- 



-- All In Combo --

op = math.huge
function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then

			if Menu.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(targetMinion, 600) then
				CastSpell(_Q, mousePos.z, mousePos.z)
      end
 if Vi_OnQ and ValidTarget(targetMinion, Vi_Q_Range()) then
            CastSpell2(_Q, D3DXVECTOR3(targetMinion.x,targetMinion.y,targetMinion.z))
			end
    
    

    if Menu.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(targetMinion, skills.SkillE.range)then
      CastSpell(_E, myHero)
    end
    
        
        
			
	end
		
	end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
  
    
			if Menu.Jungleclear.useClearQ and skills.SkillQ.ready and ValidTarget(jungleMinion, 600) then
				CastSpell(_Q, mousePos.z, mousePos.z)
      end
        if Vi_OnQ and ValidTarget(jungleMinion, Vi_Q_Range()) then
    CastSpell2(_Q, D3DXVECTOR3(jungleMinion.x,jungleMinion.y,jungleMinion.z))
            end
    
    

    if Menu.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(jungleMinion, skills.SkillE.range)then
      CastSpell(_E, myHero)
    end
			
      end                                                               
	end
end

function AutoLevel()
	local qL, wL, eL, rL = player:GetSpellData(_Q).level + qOff, player:GetSpellData(_W).level + wOff, player:GetSpellData(_E).level + eOff, player:GetSpellData(_R).level + rOff
	if qL + wL + eL + rL < player.level then
		local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4 }
		local level = { 0, 0, 0, 0 }
		for i = 1, player.level, 1 do
			level[abilitySequence[i]] = level[abilitySequence[i]] + 1
		end
		for i, v in ipairs({ qL, wL, eL, rL }) do
			if v < level[i] then LevelSpell(spellSlot[i]) end
		end
	end
end

function KillSteal()
	if Menu.Ads.KS.ignite then
		IgniteKS()
	end
  

  if Menu.Ads.KS.autoQ then
  --  OnGapclose(target)
    end
  
  
end

-- Auto Ignite get the maximum range to avoid over kill --

function IgniteKS()
	if igniteReady then
		local Enemies = GetEnemyHeroes()
		for i, val in ipairs(Enemies) do
			if ValidTarget(val, 600) then
				if getDmg("IGNITE", val, myHero) > val.health and GetDistance(val) >= Menu.Ads.KS.igniteRange then
					CastSpell(ignite, val)
				end
			end
		end
	end
end

-- Auto Ignite --

function HealthCheck(unit, HealthValue)
	if unit.health > (unit.maxHealth * (HealthValue/100)) then 
		return true
	else
		return false
	end
end

function ItemUsage(target)

	if dfgReady then CastSpell(dfgSlot, target) end
	if youmuuReady then CastSpell(youmuuSlot, target) end
	if bilgeReady then CastSpell(bilgeSlot, target) end
	if bladeReady then CastSpell(bladeSlot, target) end
	if divineReady then CastSpell(divineSlot, target) end

end

-- Change skin function, made by Shalzuth
function GenModelPacket(champ, skinId)
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

function skinChanged()
	return Menu.Ads.VIP.skin1 ~= lastSkin
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
 radius = radius or 300
 quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
 quality = 2 * math.pi / quality
 radius = radius*.92
 local points = {}
 for theta = 0, 2 * math.pi + quality, quality do
  local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
  points[#points + 1] = D3DXVECTOR2(c.x, c.y)
 end
 DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
 local vPos1 = Vector(x, y, z)
 local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
 local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
 local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
 if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
  self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
 end
end

function CircleDraw(x,y,z,radius, color)
	self:DrawCircle2(x, y, z, radius, color)
end--[[ Kill Text ]]--
TextList = {"Harass him", "Q", "W", "E", "ULT HIM !", "Items", "All In", "Skills Not Ready"}
KillText = {}
colorText = ARGB(229,229,229,0)
_G.ShowTextDraw = true


  
    
     
      
-- Damage Calculation Thanks Skeem for the base --

function DamageCalculation()
  for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      wDmg = getDmg("W", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
      rDmg = getDmg("R", enemy,myHero)
      dfgDmg = getDmg("DFG", enemy, myHero)


      if not skills.SkillQ.ready and not skills.SkillW.ready and not skills.SkillE.ready and not skills.SkillR.ready then
        KillText[i] = TextList[8]
        return
      end

      if enemy.health <= qDmg then
        KillText[i] = TextList[2]
      elseif enemy.health <= wDmg then
        KillText[i] = TextList[3]
      elseif enemy.health <= eDmg then
        KillText[i] = TextList[4]
      elseif enemy.health <= rDmg then
        KillText[i] = TextList[5]
      elseif enemy.health <= qDmg + wDmg then
        KillText[i] = TextList[2] .."+".. TextList[3]
      elseif enemy.health <= qDmg + eDmg then
        KillText[i] = TextList[2] .."+".. TextList[4]
      elseif enemy.health <= qDmg + rDmg then
        KillText[i] = TextList[2] .."+".. TextList[5]
      elseif enemy.health <= wDmg + eDmg then
        KillText[i] = TextList[3] .."+".. TextList[4]
      elseif enemy.health <= wDmg + rDmg then
        KillText[i] = TextList[3] .."+".. TextList[5]
      elseif enemy.health <= eDmg + rDmg then
        KillText[i] = TextList[4] .."+".. TextList[5]
      elseif enemy.health <= qDmg + wDmg + eDmg then
        KillText[i] = TextList[2] .."+".. TextList[3] .."+".. TextList[4]
      elseif enemy.health <= qDmg + wDmg + eDmg + rDmg then
        KillText[i] = TextList[2] .."+".. TextList[3] .."+".. TextList[4] .."+".. TextList[5]
      elseif enemy.health <= dfgDmg + ((qDmg + wDmg + eDmg + rDmg) + (0.2 * (qDmg + wDmg + eDmg + rDmg))) then
        KillText[i] = TextList[7]
      else
        KillText[i] = TextList[1]
      end
    end
  end
end

function OnDraw()    if not myHero.dead then
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 255, 51, 153)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 ,255, 51, 153)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 ,255, 51, 153)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 255, 51, 153)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 255, 51, 153)) end
    end
if _G.ShowTextDraw then
    for i = 1, heroManager.iCount do
	    local enemy = heroManager:GetHero(i)
	    if ValidTarget(enemy) and enemy ~= nil then
	      local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z)) --(Credit to Zikkah)
	      local PosX = barPos.x - 35
	      local PosY = barPos.y - 10
	      if KillText[i] ~= 10 then
	        DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
	      else
	        DrawText(TextList[KillText[i]] .. string.format("%4.1f", ((enemy.health - (qDmg + pDmg + eDmg + itemsDmg)) * (1/rDmg)) * 2.5) .. "s = Kill", 16, PosX, PosY, colorText)
	      end
	    end
	end
end
if not myHero.dead and target ~= nil then	
		if ValidTarget(target) then 
		--	if Settings.drawing.text then 
				DrawText3D("Focus This Bitch!",target.x-100, target.y-50, target.z, 20, 0xFFFF9900) --0xFF9900
			end
			--[[if target ~= nil then 
				DrawCircle(target.x, target.y, target.z, 150, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
			end--]]
		end
end

function level()
  return myHero.level

end

  
    


  



lastLeftClick = 0 
--- thxx too klokje!

lastLeftClick = 0 
--- thxx too klokje!
kijk = 0
tijd = math.huge
click = 0
time = math.huge
function OnWndMsg(Msg, Key)
	
	
	if Msg == WM_LBUTTONUP then
        click = click + 1
        time = GetGameTimer()
      
		local minD = 0
		local target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and unit.type == myHero.type then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
         
    
    
    if target and minD < 115 then
        
			if SelectedTarget and target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = target
        pis = true
        kut = GetGameTimer()
   
             
          end
			end
		end
  end
  end
      
      end
        
	end
function DoubleClick()
if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
  if skills.SkillR.ready and ValidTarget(target, skills.SkillR.range) and Menu.ViCombo.rSet.Click then
    CastSpell(_R, target)
  end
  end
end









function KS()

  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team and Menu.Ads.KS.KS then
  for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      qmDmg = getDmg("QM", enemy,myHero)
      wDmg = getDmg("W", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
      rDmg = getDmg("R", enemy,myHero)
      dfgDmg = getDmg("DFG", enemy, myHero)
      
      --print(qmDmg)
      if skills.SkillQ.ready and ValidTarget(target, 600) and target.health <= qDmg + eDmg and not Vi_OnQthen
        CastSpell(Q, mousePos.x, mousePos.z)
       if Vi_OnQ and ValidTarget(target, Vi_Q_Range()) then
            if Menu.ProdSettings.SelectProdiction == 2 then 
            QVP()
            elseif  Menu.ProdSettings.SelectProdiction == 1 then
              DivineQ()
            elseif  Menu.ProdSettings.SelectProdiction == 3 then
              CastQ()
            end
      end
      end
      if skills.SkillE.ready and ValidTarget(target, 250) and target.health <= eDmg then
        CastSpell(_E, target)
      end
      if skills.SkillE.ready and skills.SkillR.ready and Menu.Ads.KS.R then
        if target.health <= rDmg + eDmg then
          CastSpell(_R, target)
          if not target.dead then 
            CastSpell(_E, myHero)
          end
        end
      end
      
    end
  end
end
end
function AreaEnemyCount()
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(myHero, enemy) < 550 then
				count = count + 1
			end
		end              
	return count
end
function OnTowerFocus(tower, target) 
 
  if target ~= nil and tower ~= nil then
       if tower.team ~= myHero.team then
         if unit.team ~= myHero.team then
          return true
       end
     end
  end
 

end


-- thx HTTF<3
function blCheck(target)
  if target ~= nil and Menu.ultb[target.charName] then
    return true
  else
    return false
  end
end

function QVP()
   if target ~= nil and target.type == myHero.type and Vi_OnQ  then
--print("Stap1")
      if Menu.ViCombo.qSet.useQ and ValidTarget(target, Vi_Q_Range()) and not target.dead then
       -- print("Stap2")
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, Vi_Q_Range(), skills.SkillQ.speed, myHero, false)
        if HitChance >= 1 then
          --print("stap3")
           --   print("try")
				--CastSpell(_Q, CastPosition.x, CastPosition.z)i
        CastSpell2(_Q, D3DXVECTOR3(CastPosition.x,CastPosition.y,CastPosition.z))
 end
    end
  end
end


function Vi_Q_Range()
  if Vi_OnQ then
    local Time = os.clock()-Vi_LastQ
    if Time >= 4.5 then
      CurrentRange = 250
      Vi_OnQ = false
    else
      CurrentRange = math.min(900, 250+520*Time)
    end
  else
    CurrentRange = 250
  end
  return CurrentRange
end

function OnAnimation(unit, animation)
  if not unit.isMe then return end
  if animation == "Spell1" then
    Vi_OnQ = false
  end
end

function OnProcessSpell(unit, spell)
  if not unit.isMe then return end
  if spell.name == "ViQ" then
    Vi_OnQ = true
    Vi_LastQ = os.clock()
  end
end
 function CastQ()
  --print("castQ")
  
  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
 -- QPos, QHitChance = HPred:GetPredict("Q", target, myHero)
  local QPos, QHitchance = HPred:GetPredict(Vi_Q, target, myHero)

  if QHitchance >= 1 then
    --print("short")
  --print("laastecheck")
CastSpell2(_Q, D3DXVECTOR3(QPos.x,QPos.y,QPos.z))
    end
  end
end


function DevineQ()
 -- print("johhny")
  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
  if Menu.ProdSettings.SelectProdiction == 1 then
			local target = DPTarget(target)
			local ViQ = LineSS(skills.SkillQ.speed, Vi_Q_Range, skills.SkillQ.width, skills.SkillQ.delay, 0)
			local State, Position, perc = DP:predict(target, ViQ)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				CastSpell2(_Q, D3DXVECTOR3(Position.x,Position.y,Position.z))
      


				end
			end
end
end

