if myHero.charName ~= "LeeSin"  or not VIP_USER then return end
local version = 0.4
local AUTOUPDATE = true
local SCRIPT_NAME = "SXLeeSin by SyraX"
require 'VPrediction'
--require 'SOW'
require 'Collision'
--require 'Prodiction'
require "SxOrbwalk"
require 'DivinePred'
require 'HPrediction'
-- Constants --
local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3}
local turrets = GetTurrets()
local Ranges = { AA = 125 }
local LaatsteKeerQ, bonusDmg = 0, 0
local LaatsteKeer, LaatsteKeer1, Laatstekeer2 = 0,0,0
local SightG, lastWard, targetObj, friendlyObj = nil, nil, nil, nil
function CheckUpdate()
        local scriptName = "SXLeeSin"
        local version = 1.1
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXLeeSin"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXLeeSin"..scriptName..".lua"
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
    AddTickCallback(function  () self:GetOnlineVersion() end)
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

local skills = {
	SkillQ = { ready = true, name = "Sonic Wave", range = 1100, delay = 0.5, speed = 1800, width = 60 },
	SkillW = { ready = true, name = "Safeguard	", range = 700, delay = 0, speed = 1500, width = 0 },
	SkillE = { ready = true, name = "Tempest", range = 350, delay = 0.5, speed = math.huge, width = 425 },
	SkillR = { ready = true, name = "Dragon's Rage", range = 375, delay = 0.5, speed = 1500, width = 0 },
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
  if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 3340) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	return ts.target
end
function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
	initComponents()
  
  
   Spell_Q.collisionM['LeeSin'] = true
  Spell_Q.collisionH['LeeSin'] = true -- or false (sometimes, it's better to not consider it)
  Spell_Q.delay['LeeSin'] = 0.5
  Spell_Q.range['LeeSin'] = 1100
  Spell_Q.speed['LeeSin'] = 1800
  Spell_Q.type['LeeSin'] = "DelayLine" -- (it has tail like comet)
  Spell_Q.width['LeeSin'] = 120
  
end
function initComponents()
  --Prod = ProdictManager.GetInstance()
 -- ProdQ = Prod:AddProdictionObject(_Q, 1100, 1175, 0.250, 80)    
  qPos = nil
    -- VPrediction Start
 VP = VPrediction()
DP = DivinePred()
HPred = HPrediction()
   -- SOW Declare
   --Orbwalker = SOW(VP)
  -- Target Selector
   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1700)
  
 Menu = scriptConfig("SXLeeSin by SyraX", "LeeSinMA")

   if _G.MMA_Loaded ~= nil then
     PrintChat("<font color = \"#33CCCC\">MMA Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isMMA = true
 elseif _G.AutoCarry ~= nil then
      PrintChat("<font color = \"#33CCCC\">SAC Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isSAC = true
 else
     PrintChat("<font color = \"#40FF00\">OrbWalker found:</font> <font color = \"#fff8e7\"> Loading SX</font>")
       --Menu:addSubMenu("["..myHero.charName.." - Orbwalker]", "SOWorb")
      -- Orbwalker:LoadToMenu(Menu.SOWorb)
       
       	Menu:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)

    Menu:addTS(ts)
    end
  
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "LeeSinCombo")
    Menu.LeeSinCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.LeeSinCombo:addSubMenu("Q Settings", "qSet")
  Menu.LeeSinCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.LeeSinCombo:addSubMenu("W Settings", "wSet")
  Menu.LeeSinCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 Menu.LeeSinCombo:addSubMenu("E Settings", "eSet")
  Menu.LeeSinCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.LeeSinCombo:addSubMenu("R Settings", "rSet")
  Menu.LeeSinCombo.rSet:addParam("useR", "Use Smart Ultimate", SCRIPT_PARAM_ONOFF, true)
  Menu.LeeSinCombo:addParam("AA", "Force AA", SCRIPT_PARAM_ONOFF, true)
  
 
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
    
       Menu:addSubMenu("["..myHero.charName.." - Prodiction Settings]", "ProdSettings") -- Menu.ProdSettings.SelectProdiction
 -- Menu.selectProdSettings == 1 or 2
	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 2, {"Prodiction do not use this one", "VPrediction"," Divine Pred", "HPrediction"})
--  Menu.ProdSettings:addParam("OD", "OnDash", SCRIPT_PARAM_ONOFF, false)
--  Menu.ProdSettings:addParam("AD", "AfterDash", SCRIPT_PARAM_ONOFF, false)
-- Menu.ProdSettings:addParam("AI", "AfterImmobile", SCRIPT_PARAM_ONOFF, false)

 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
    Menu.Ads:addParam("wardJump", "Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false, 67)
    Menu.Ads:addParam("ESC", "Escape", SCRIPT_PARAM_ONKEYDOWN, false, 83)
   -- Menu.Ads:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)
    Menu.Ads:addParam("insecMake", "Insec", SCRIPT_PARAM_ONKEYDOWN, false, 84)
    Menu.Ads:addParam("Toren", "Insec undertower", SCRIPT_PARAM_ONOFF, false) 
  --  Menu.Ads:addParam("Choose", "Insec Direction", SCRIPT_PARAM_LIST, 1, {"Normal", "Tower", "Ally"})
 --Menu.Ads.Toren
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
    Menu.Ads.KS:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false) -- Menu.Ads.KS.useR
   Menu.Ads.KS:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("ADV", "Ward + Q Beta", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("Toren2", "i wanna dive for a kill!! pref if you are fed", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("AKSR", "BETA test KS R advanced", SCRIPT_PARAM_ONOFF, false)
   
 
  
   
  -- Menu.Ads.KS.ADV
  Menu.Ads:addSubMenu("VIP", "VIP")
    Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 7)
    
  
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
       GenModelPacket("LeeSin", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end
    
     for i = 1, heroManager.iCount do
    local hero = heroManager:GetHero(i)
      if hero.team ~= myHero.team then
        
        --ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
       -- ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
       -- ProdQ:GetPredictionOnDash(hero, OnDashfunc)
        
        
      end
    end
    
    ItemNames				= {
		[3303]				= "ArchAngelsDummySpell",
		[3007]				= "ArchAngelsDummySpell",
		[3144]				= "BilgewaterCutlass",
		[3188]				= "ItemBlackfireTorch",
		[3153]				= "ItemSwordOfFeastAndFamine",
		[3405]				= "TrinketSweeperLvl1",
		[3411]				= "TrinketOrbLvl1",
		[3166]				= "TrinketTotemLvl1",
		[3450]				= "OdinTrinketRevive",
		[2041]				= "ItemCrystalFlask",
		[2054]				= "ItemKingPoroSnack",
		[2138]				= "ElixirOfIron",
		[2137]				= "ElixirOfRuin",
		[2139]				= "ElixirOfSorcery",
		[2140]				= "ElixirOfWrath",
		[3184]				= "OdinEntropicClaymore",
		[2050]				= "ItemMiniWard",
		[3401]				= "HealthBomb",
		[3363]				= "TrinketOrbLvl3",
		[3092]				= "ItemGlacialSpikeCast",
		[3460]				= "AscWarp",
		[3361]				= "TrinketTotemLvl3",
		[3362]				= "TrinketTotemLvl4",
		[3159]				= "HextechSweeper",
		[2051]				= "ItemHorn",
		[2003]				= "RegenerationPotion",
		[3146]				= "HextechGunblade",
		[3187]				= "HextechSweeper",
		[3190]				= "IronStylus",
		[2004]				= "FlaskOfCrystalWater",
		[3139]				= "ItemMercurial",
		[3222]				= "ItemMorellosBane",
		[3042]				= "Muramana",
		[3043]				= "Muramana",
		[3180]				= "OdynsVeil",
		[3056]				= "ItemFaithShaker",
		[2047]				= "OracleExtractSight",
		[3364]				= "TrinketSweeperLvl3",
		[2052]				= "ItemPoroSnack",
		[3140]				= "QuicksilverSash",
		[3143]				= "RanduinsOmen",
		[3074]				= "ItemTiamatCleave",
		[3800]				= "ItemRighteousGlory",
		[2045]				= "ItemGhostWard",
		[3342]				= "TrinketOrbLvl1",
		[3040]				= "ItemSeraphsEmbrace",
		[3048]				= "ItemSeraphsEmbrace",
		[2049]				= "ItemGhostWard",
		[3345]				= "OdinTrinketRevive",
		[2044]				= "SightWard",
		[3341]				= "TrinketSweeperLvl1",
		[3069]				= "shurelyascrest",
		[3599]				= "KalistaPSpellCast",
		[3185]				= "HextechSweeper",
		[3077]				= "ItemTiamatCleave",
		[2009]				= "ItemMiniRegenPotion",
		[2010]				= "ItemMiniRegenPotion",
		[3023]				= "ItemWraithCollar",
		[3290]				= "ItemWraithCollar",
		[2043]				= "VisionWard",
		[3340]				= "TrinketTotemLvl1",
		[3090]				= "ZhonyasHourglass",
		[3154]				= "wrigglelantern",
		[3142]				= "YoumusBlade",
		[3157]				= "ZhonyasHourglass",
		[3512]				= "ItemVoidGate",
		[3131]				= "ItemSoTD",
		[3137]				= "ItemDervishBlade",
		[3352]				= "RelicSpotter",
		[3350]				= "TrinketTotemLvl2",
	}
	
	_G.ITEM_1				= 06
	_G.ITEM_2				= 07
	_G.ITEM_3				= 08
	_G.ITEM_4				= 09
	_G.ITEM_5				= 10
	_G.ITEM_6				= 11
	_G.ITEM_7				= 12
	
	___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
	_G.GetInventorySlotItem	= GetSlotItem
  
 PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">SXLeeSin</font> <font color = \"#FFA319\">by SyraX V"..version.."</font>")
end
cow = nil
Q = false
Qtime = math.huge
W = false
Wtime = math.huge
E = false
Etime = math.huge
P = false
Ptime = math.huge
local lastWard1 = nil

local lastWardInsec = 0

wardgebruikt = false
wardtimer = math.huge
check = false
checktimer = math.huge
check2 = false
check2timer = math.huge
ADVW = false
ADVWtimer = math.huge
click = 0
 time = math.huge
 indebuurt = false
 Razer = false
Rtimer = math.huge
   SightGDone = false
     SightGTimer = math.huge
     LastWardTimer = math.huge
     Nick = false
   InsecQ = false
      IQCheck= math.huge
       insecW = false
      wTimer = math.huge
  
function OnTick()
	target = GetCustomTarget()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  
  --[[if insecW then
    if wTimer + 1 <= GetGameTimer() then
      insecW = false
      wTimer = math.huge
    end
  end
  --]]
  
  --print(insecW)
 -- print(InsecQ)
   ally = getRandomAlly(2500)
   if papi then 
     if gino + 5 <= GetGameTimer() then
       papi = false 
       gino =math.huge
     end
     end
   --print(Nick)
   --print(lastWard1)
   --print(SightG)
  if InsecQ then
    if IQCheck + 0.5 <= GetGameTimer() then
      InsecQ = false
      IQCheck= math.huge
    end
    end
   --checkForInsec()
   
 -- print(check)
  -- print(target)
   --print(Q)
   --print(Razer)
   
   if Razer then
     insec()
     end
  -- print(ally)
  
  --print(SearchALly())

  --print(turrets)
 -- GetTower()
  --GetGoodTower()
  --Tower()
--  print(SearchTower())
  --print(Tower)
  --toren()
 

 -- print(DiveOrNot())
 --print(lastWard2)
 --print(ADVW)
 --print(check2)
 
 --print(DiveOrNot())

if click == 2 then
      
       if click == 2 then
         Razer = true
         Rtimer = GetGameTimer()
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
    
 if lastWard2 then
   if  konijn2 + 2 <= GetGameTimer() then
     lastWard2 = nil
   end
 end
 
 
 if lastWard1 then 
   if konijn1 + 3 <= GetGameTimer() then
     lastWard1 = nil 
     Nick = false
     LastWardTimer = math.huge
     
     
    end
  end

     
     if SightGDone then 
       if SightGTimer + 2 <= GetGameTimer() then
            SightGDone = false
            SightGTimer = math.huge
          end
          end
         




  if lastWard1 and lastWard1.valid and GetDistance(lastWard1, myHero) <= 600 then
   --  print("1")
  if skills.SkillW.ready and myHero:GetSpellData(_W).name == "BlindMonkWOne"  then
    --print("2")
  if Menu.Ads.insecMake or Razer then
    	if LaatsteKeer1 > (GetTickCount() - 1000) then
			if (GetTickCount() - LaatsteKeer1) >= 10 then
     --  print("3")
	
				CastSpell(_W, lastWard1)
        LastWardTimer = math.huge
        check = true
        checktimer = GetGameTimer()
         wardgebruikt = true
      wardtimer = GetGameTimer()
      end
  end
			end
  
end
end
  if lastWard2 then
  if skills.SkillW.ready and myHero:GetSpellData(_W).name == "BlindMonkWOne" and lastWard2.valid  and Menu.LeeSinCombo.combo then
  if Menu.Ads.KS.ADV then
    	if LaatsteKeer2 > (GetTickCount() - 1000) then
			if (GetTickCount() - LaatsteKeer2) >= 10 then
      
    CastSpell(_W, lastWard2)
      check2 = true
      check2timer = GetGameTimer()
     -- print("464")
     -- print("part2")
  end
end

end
end 
end
  
  
  
    if check then
      if checktimer + 2 <= GetGameTimer() then
        check = false
        checktimer = math.huge
      --  print("part3")
      end
    end
    
     if check2 then
      if check2timer + 2 <= GetGameTimer() then
        check2 = false
        check2timer = math.huge
        --print("part3")
      end
    end
    
  if ADVW then
  if ADVWtimer + 10 <= GetGameTimer() then
    ADVW = false
    ADVWtimer = math.huge
   -- print("part4")
  end
end
  if wardgebruikt then
    if wardtimer + 3 <= GetGameTimer() then
      wardgebruikt = false
      wardtimer = math.huge
    end
  end
    
    
	if target ~= nil then
		if string.find(target.type, "Hero") and target.team ~= myHero.team then
			targetObj = target
		elseif target.team == myHero.team then
			friendlyObj = target
		end
	end
  
  if P then 
    if Ptime + 2.5 <= GetGameTimer() then
      P = false 
      Ptime = math.huge
    end
  end
  
      if Razer then
        
        if Rtimer + 3 <= GetGameTimer() then
          Razer = false
         Rtimer = math.huge
       end
       end
  if Q then
    if Qtime + 1 <= GetGameTimer() then
      Q = false
      Qtime = math.huge
    end
  end
  if W then
    if Wtime + 2 <= GetGameTimer() then
      W = false
      Wtime = math.huge
    end
  end
  if E then
    if Etime + 2 <= GetGameTimer() then
      E = false
      Etime = math.huge
    end
  end
  
  
 
  
  local WardSlot = GetInventorySlotItem(2049)
	local WReady = (WardSlot ~= nil and myHero:CanUseSpell(WardSlot) == READY)
	local WardSlot2 = GetInventorySlotItem(2045)
	local WReady2 = (WardSlot2 ~= nil and myHero:CanUseSpell(WardSlot2) == READY)
	local WardSlot3 = GetInventorySlotItem(3340)
	local WReady3 = (WardSlot3 ~= nil and myHero:CanUseSpell(WardSlot3) == READY)
	local WardSlot4 = GetInventorySlotItem(2044)
	local WReady4 = (WardSlot4 ~= nil and myHero:CanUseSpell(WardSlot4) == READY)
	local WardSlot5 = GetInventorySlotItem(3361)
	local WReady5 = (WardSlot5 ~= nil and myHero:CanUseSpell(WardSlot5) == READY)
	local WardSlot6 = GetInventorySlotItem(3362)
	local WReady6 = (WardSlot6 ~= nil and myHero:CanUseSpell(WardSlot6) == READY)
	local WardSlot7 = GetInventorySlotItem(3154)
	local WReady7 = (WardSlot7 ~= nil and myHero:CanUseSpell(WardSlot7) == READY)
	local WardSlot8 = GetInventorySlotItem(3160)
	local WReady8 = (WardSlot8 ~= nil and myHero:CanUseSpell(WardSlot8) == READY)
	
	SightG = nil
	if WReady then
		SightG = WardSlot
	elseif WReady2 then
		SightG = WardSlot2
	elseif WReady7 then
		SightG = WardSlot7
	elseif WReady8 then
		SightG = WardSlot8
	elseif WReady3 then
		SightG = WardSlot3
	elseif WReady5 then
		SightG = WardSlot5
	elseif WReady6 then
		SightG = WardSlot6
	elseif WReady4 then
		SightG = WardSlot4
	end
  --print(SightG)
  if Menu.Ads.wardJump then
		wardJump()
		return
	end
	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("LeeSin", Menu.Ads.VIP.skin1)
		lastSkin = Menu.Ads.VIP.skin1
	end
  if ValidTarget(target) then
   -- ProdQ:GetPredictionCallBack(target, GetQPos)
  else
    qPos = nil
  end
  
   -- Enable/Disable certain callbacks when turned on/off by the menu.
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
         
            
            if Menu.ProdSettings.AD then
              --  ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
            
            else
               -- ProdQ:GetPredictionAfterDash(hero, AfterDashFunc, false)
               
            end
            
            if Menu.ProdSettings.AI then
               -- ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
               
            else
                
               -- ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
            end
                        

            
            if Menu.ProdSettings.OI then
               -- ProdQ:GetPredictionOnDash(hero, OnDashfunc)
            else
             --   ProdQ:GetPredictionOnDash(hero, OnDashFunc, false)
            end

        end
    end
    OnDashPos = nil
    AfterDashPos = nil
    AfterImmobilePos = nil
    OnImmobilePos = nil
 

	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
  
	if Menu.LeeSinCombo.combo then
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

function AutoLevel()
    local qL, wL, eL, rL = player:GetSpellData(_Q).level + qOff, player:GetSpellData(_W).level + wOff, player:GetSpellData(_E).level + eOff, player:GetSpellData(_R).level + rOff
    if qL + wL + eL + rL < player.level then
        local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4, }
        local level = { 0, 0, 0, 0 }
        for i = 1, player.level, 1 do
            level[abilitySequence[i]] = level[abilitySequence[i]] + 1
        end
        for i, v in ipairs({ qL, wL, eL, rL }) do
        if v < level[i] then LevelSpell(spellSlot[i]) end
        end
    end
end
function CDHandler()
	-- Spells
	skills.SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	skills.SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	skills.SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	skills.SkillR.ready = (myHero:CanUseSpell(_R) == READY)

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






function wardJump()
  --print(SightG)
  --print(" fout heb je")
	if skills.SkillW.ready and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
   -- print("hij begint war")
		if LaatsteKeer > (GetTickCount() - 1000) then
			if (GetTickCount() - LaatsteKeer) >= 10 then
      
				CastSpell(_W, lastWard)
       -- print("702")
			end
     -- print(" hij is in wardJump")
		elseif SightG ~= nil then
			local wardX = mousePos.x
			local wardZ = mousePos.z
			
				local distanceMouse = GetDistance(myHero, mousePos)
				if distanceMouse > 600 then
					wardX = myHero.x + (600 / distanceMouse) * (mousePos.x - myHero.x)
					wardZ = myHero.z + (600 / distanceMouse) * (mousePos.z - myHero.z)
				end
			end
      if SightG == 12 then 
        Cow = SightG
        CastSpell(Cow, mousePos.x, mousePos.z)
      elseif SightG ~= nil and SightG ~= 12 then
          CastSpell(SightG, mousePos.x, mousePos.z)
        end
			
    
      end
      
		end
roken = false

 
function OnCreateObj(object)
	if myHero.dead then return end
  
  
	
	if Menu.Ads.wardJump then
		if object ~= nil and object.valid and (object.name == "VisionWard" or object.name == "SightWard") then
			lastWard = object 
       
			LaatsteKeer = GetTickCount()
      konijn = GetGameTimer()
    --  Nick = true
		end
	end
  if Menu.Ads.insecMake or Razer then
    	if object ~= nil and object.valid and (object.name == "VisionWard" or object.name == "SightWard") then
			lastWard1 = object
			LaatsteKeer1 = GetTickCount()
      konijn1 = GetGameTimer()
      Nick = true
     -- roken = true
     -- print("wardplaced")
      
		end
	end
  if Menu.Ads.KS.ADV and not Menu.Ads.insecake and not Menu.Ads.wardJump then
   -- print("papi")
    	if object ~= nil and object.valid and (object.name == "VisionWard" or object.name == "SightWard") then
        if GetDistance(object, myHero) <= 600 then
      --print("kip")
			lastWard2 = object
			LaatsteKeer2 = GetTickCount()
      konijn2 = GetGameTimer()
      end
      --print("part5")
    end
  end
    
   
  if obj ~= nil and obj.type == "obj_AI_Minion" and obj.name ~= nil then

		if JungleNames[obj.name] then
            table.insert(JungleMobs, obj)
		end
	

 
    

end
end

function GetSlotItem(id, unit)
	
	unit = unit or myHero

	if (not ItemNames[id]) then
		return ___GetInventorySlotItem(id, unit)
	end

	local name	= ItemNames[id]
	
	for slot = ITEM_1, ITEM_7 do
		local item = unit:GetSpellData(slot).name
		if ((#item > 0) and (item:lower() == name:lower())) then
			return slot
		end
	end

end
--[[ if not Q and Menu.LeeSinCombo.qSet.useQ  then
      if Menu.ProdSettings.SelectProdiction == 2 then
          if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          QVP()          
          end
      elseif Menu.ProdSettings.SelectProdiction == 3 then 
        if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          DevineQ()
        end
      elseif Menu.ProdSettings.SelectProdiction == 1 then 
        if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          ProdQ:GetPredictionCallBack(target, CastQ)
        end
         end
    end


		if not W and not P and Menu.LeeSinCombo.wSet.useW and skills.SkillW.ready and ValidTarget(target, 200) then
     -- print("papi")
		    CastSpell(_W, myHero)
		end

		if not E and not P and Menu.LeeSinCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
		    CastSpell(_E)
		end
	end
end
end
--]]
function Harass()	
	if target ~= nil and ValidTarget(target) then
		if Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
			if Menu.ProdSettings.SelectProdiction == 2 then
          QVP()          
          end
		elseif Menu.ProdSettings.SelectProdiction == 3 then 
        if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          DevineQ()
        end
        end
		if Menu.Harass.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready then
			CastSpell(_W, myHero)
		end
		if Menu.Harass.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
			CastSpell(_E)
		end
	end
	
end

-- End Harass --


-- Combo Selector --

function Combo()
	local typeCombo = 0
	if target ~= nil then
		AllInCombo(target, 0)
	end
	
end

-- Combo Selector --

-- All In Combo -- 

function AllInCombo(target, typeCombo)
	if target ~= nil and typeCombo == 0 then
		ItemUsage(target)
    if target ~= nil and target.type == myHero.type and not target.dead then
    if E or W and Menu.LeeSinCombo.AA then
      AA()
    end
    if not Q and Menu.LeeSinCombo.qSet.useQ  then
      if Menu.ProdSettings.SelectProdiction == 2 then
          if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          QVP()          
          end
      elseif Menu.ProdSettings.SelectProdiction == 3 then 
        if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          DevineQ()
        end
      elseif Menu.ProdSettings.SelectProdiction == 1 then 
        if ValidTarget(target, skills.SkillQ. range) and skills.SkillQ.ready then
          ProdQ:GetPredictionCallBack(target, CastQ)
        end
      elseif Menu.ProdSettings.SelectProdiction == 4 then
        if ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
          CastQ()
        end
        end
    end


		if not W and not P and Menu.LeeSinCombo.wSet.useW and skills.SkillW.ready and ValidTarget(target, 200) then
     -- print("papi")
		    CastSpell(_W, myHero)
		end

		if not E and not P and Menu.LeeSinCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
		    CastSpell(_E)
		end
	end
end
end


-- All In Combo --


function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
			if Menu.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(targetMinion, skills.SkillQ.range) then
				CastSpell(_Q, targetMinion.x, targetMinion.z)
			end
			if Menu.Laneclear.useClearW and skills.SkillW.ready and ValidTarget(targetMinion, skills.SkillW.range) then
				CastSpell(_W, targetMinion)
			end
			if Menu.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(targetMinion, skills.SkillE.range) then
				CastSpell(_E, targetMinion)
			end
		end
		
	end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
			if Menu.Jungleclear.useClearQ and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) then
				CastSpell(_Q, jungleMinion.x, jungleMinion.z)
			end
			if Menu.Jungleclear.useClearW and skills.SkillW.ready and ValidTarget(jungleMinion, skills.SkillW.range) then
				CastSpell(_W, myHero)
			end
			if Menu.Jungleclear.useClearE and skills.SkillE.ready and ValidTarget(jungleMinion, skills.SkillE.range) then
				CastSpell(_E)
			end
		end
	end
end

--[[

_G.LevelSpell = function(id)
	local offsets = {[_Q] = 0x66, [_W] = 0x65, [_E] = 0x64, [_R] = 0x63,}
	local p = CLoLPacket(0x0017)
	p.vTable = 0xE90950
	p:EncodeF(myHero.networkID)
	p:Encode4(0xC7C7C7C7)
	p:Encode1(offsets[id])
	p:Encode1(0x02)
	p:Encode4(0xA9A9A9A9)
	p:Encode4(0xD3D3D3D3)
	p:Encode4(0x00000000)
	p:Encode1(0x00)
	SendPacket(p)
end
--]]
function KillSteal()
	if Menu.Ads.KS.ignite then
		IgniteKS()
	end
  if Menu.Ads.KS.useE or Menu.Ads.KS.useR or Menu.Ads.KS.useQ then
    KS()
  end
  if Menu.Ads.ESC then
   -- Escape()
    Monster()
  end
  
  if Menu.Ads.insecMake then
    insec()
  end

  
  
  if Menu.Ads.insecMake and not Menu.Ads.Toren and skills.SkillW.ready and skills.SkillQ.ready and skills.SkillW.ready then
 insec()
-- SearchALly()
elseif Menu.Ads.insecMake and Menu.Ads.Toren and DiveOrNot() and skills.SkillW.ready and skills.SkillQ.ready and SightG ~= nil and skills.SkillW.ready then
  insec()
--  SearchALly()
end
   
  

if Menu.Ads.KS.ADV and not Menu.Ads.KS.Toren2 then
    AdvancedKS()
elseif Menu.Ads.KS.ADV and Menu.Ads.KS.Toren2 and DiveOrNot() then
  AdvancedKS()
end


  if Menu.Ads.KS.AKSR then
  AdvancedR()
  end
end


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

function OnDraw()    
  if not myHero.dead then
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 255, 255, 28)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 , 255, 0, 102)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 , 255, 0, 0)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 255, 51, 153)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 247, 190, 129)) end
    end
    InsectDirection = Vector(myHero.pos)
    --kippp = InsectDirection + (Vector(target) - InsectDirection):normalized() * 350
    kippp = Vector(target)+ (Vector(target) - InsectDirection):normalized() * 300
    if Menu.Ads.insecMake and kippp and not ally then
      -- kippp = InsectDirection + (Vector(target) - InsectDirection):normalized() * 350
      DrawCircle(kippp.x, kippp.y, kippp.z, 100, 0x99990f)
      end
    --kippp = InsectDirection + (Vector(target) - InsectDirection):normalized() * 350
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
   
  
if not myHero.dead and target ~= nil and	target.team ~= myHero.team and target.type == myHero.type then 
		--	if Settings.drawing.text then 
				DrawText3D("Focus This Bitch!",target.x-100, target.y-50, target.z, 20, 0x9966FFFF) --0xFF9900
			
end
end

local InsectDirection = Vector(myHero.pos)
   if Menu.Ads.insecMake and target ~= nil then
       -- WardPos = InsectDirection + (Vector(target) - InsectDirection):normalized() * 400
     -- DrawCircle(WardPos.x, WardPos.y, WardPos.z, 100, 0xffffff)
    end
    
    if target ~= nil then
    if ValidTarget(target, 1700) and GetDistance(myHero, target) >= 1000 then
     
      local t = 600 / GetDistance(target)
      local ADV = Vector(myHero) + t * (Vector(target) - Vector(myHero))
      
     -- DrawCircle(ADV.x, ADV.y, ADV.z, 100, 0xffffff)
    end
  end

    if target ~= nil and Menu.Ads.insecMake and ally then
     
 
    WardPos2 = Vector(target) + (Vector(target) - ally):normalized() * 300
   
    
     DrawCircle(WardPos2.x, WardPos2.y, WardPos2.z, 100, 0x99990f)
     end
   if WardPos1 and not ally then
     DrawCircle(WardPos1.x, WardPos1.y, WardPos1.z, 100, 0x99990f)
    -- print ("hij doet het")
     --print("gekte")
     end
	end
end



-- prediction
function GetQPos(unit, pos)
        qPos = pos
end


function OnWndMsg(Msg, Key)	
	
	if Msg == WM_LBUTTONUP then
  --  klik = klik + 1
   -- tijd = GetGameTimer() --tijd = 16:30
		local minD = 0
		local target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and unit.type == myHero.type then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
     
          
          
				
		
    
    if target and minD < 115 then
      click = click + 1
      time = GetGameTimer()
			if SelectedTarget and target.charName == SelectedTarget.charName and target.type == myHero.type then
				SelectedTarget = nil
			else
				SelectedTarget = target
           --if target and Menu.RengarCombo.rSet.useR and not ult then
           -- CastSpell(_R, myHero)
          --end
			end
		end
    
	end
  
    
   end 
   
end
end
end

-- afther dash 3 x
--local dPredict = GetDistance(targetObj, myHero)
function AfterDashFunc(unit, pos, spell)

 if GetDistance(pos) < skills.SkillQ.range and skills.SkillQ.ready then
        local collition = Collision(1150, 1175, 0.25, 80)
        if not collition:GetMinionCollision(pos, myHero) then
            CastSpell(_Q, pos.x, pos.z)
        end
 end


end


function OnDashfunc(unit, pos, spell)
  if GetDistance(pos) < skills.SkillQ.range and skills.SkillQ.ready then
            local collition = Collision(1100, 1175, 0.25, 80)
        if not collition:GetMinionCollision(pos, myHero) then
            CastSpell(_Q, pos.x, pos.z)
        end
 end


end
    



------------------- 3 x maar gewoon
function AfterImmobileFunc(unit, pos, spell)

 if GetDistance(pos) < skills.SkillQ.range and skills.SkillQ.ready then
        local collition = Collision(1150, 1175, 0.25, 80)
        if not collition:GetMinionCollision(pos, myHero) then
            CastSpell(_Q, pos.x, pos.z)
        
        end
 end
end


------ ook maar 3 x dan


function OnImmobileFunc(unit, pos, spell)

 if GetDistance(pos) < skills.SkillR.range and skills.SkillR.ready then
        local collition = Collision(3340, math.huge, 0.70, 190)
        if not collition:GetMinionCollision(pos, myHero) then
            CastSpell(_R, pos.x, pos.z)
     
  
        end
 end
end

function QVP()
   if target ~= nil and target.type == myHero.type then
      if Menu.ProdSettings.SelectProdiction == 2 then
      if Menu.LeeSinCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready and not target.dead then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
            if HitChance >= 2 and GetDistance(CastPosition) < 1100 then
				--CastSpell(_Q, CastPosition.x, CastPosition.z)
        Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
            end
    end
  end
end
end
--local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(unit, E.delay, E.width, E.range, E.speed, myHero

function DevineQ()
  if target ~= nil and target.type == myHero.type then
  if Menu.ProdSettings.SelectProdiction == 3 then
			local target = DPTarget(target)
			local LeeSinQ = LineSS(skills.SkillQ.speed, skills.SkillQ.range, skills.SkillQ.width, skills.SkillQ.delay, 0)
			local State, Position, perc = DP:predict(target, MalzaharQ)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				
      Packet("S_CAST", {spellId = _Q, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end

function AA()
  if target ~= nil and ValidTarget(target, 125) then
    myHero:Attack(target)
  end
end


insecW = false
 function OnRemoveBuff(unit, buff)
    if buff and buff.name:find("blindmonkqtwodash")  then
      InsecQ = false
    end
    if buff and buff.name:find("blindmonkwoneshield") then
      insecW = false
     -- wTimer = GetGameTimer()
    end
    --if buff then print(buff.name) end
    
    
    end
function OnApplyBuff(source, unit, buff)
   if buff and buff.name:find("blindmonkwonedash")  then
      insecW = true
      --wTimer = GetGameTimer()
    end
    
      if buff and buff.name:find("blindmonkqtwodash")  then
      InsecQ = true
    end
   -- if buff then print(buff.name) end
  if buff and buff.name:find("BlindMonkQOne") then
    Q = true
    Qtime = GetGameTimer()
  end
  if buff and buff.name:find("blindmonkwoneshield") then
    W = true
    Wtime = GetGameTimer()
  end
  if buff and buff.name:find("BlindMonkEOne") then
    E = true
    Etime = GetGameTimer()
  end
 if buff and buff.name:find("blindmonkpassive_cosmetic") then
    P = true
    Ptime = GetGameTimer()
   
 --print(buff.name)
 end
end

function KS()
  if target ~= nil and target.type == myHero.type and target.visible and ValidTarget(target) and not target.dead then
       if ValidTarget(target) and target ~= nil then
          qDmg = getDmg("Q", target,myHero)
          eDmg = getDmg("E", target,myHero)
          rDmg = getDmg("R", target, myHero)
          if Menu.ProdSettings.SelectProdiction == 2 then
              if target.health <= qDmg and skills.SkillQ.ready and Menu.Ads.KS.useQ and not Q and ValidTarget(target) then
                QVP()
              end
            elseif Menu.ProdSettings.SelectProdiction == 3 then
               if target.health <= qDmg and skills.SkillQ.ready and Menu.Ads.KS.useQ and not Q and ValidTarget(target) then
                DevineQ()
                end
            elseif Menu.ProdSettings.SelectProdiction == 1 then 
              if target.health <= qDmg and skills.SkillQ.ready and Menu.Ads.KS.useQ and not Q and ValidTarget(target) then
            ProdQ:GetPredictionCallBack(target, CastQ)
          elseif Menu.ProdSettings.SelectProdiction == 4 then 
            if target.health <= qDmg and skills.SkillQ.ready and Menu.Ads.KS.useQ and not Q and ValidTarget(target) then
              CastQ()
            end
            
            end
         end
            if ValidTarget(target, skills.SkillR.range) then
              if target.health <= rDmg and skills.SkillR.ready and Menu.Ads.KS.useR then
                CastSpell(_R, target)
              end
            end
            if ValidTarget(target, skills.SkillE.range) and not E then 
              if target.health <= eDmg and skills.SkillE.ready and Menu.Ads.KS.useE then
                CastSpell(_E)
              end
            end
          end
        end
      end
      
      --- new part
      
      local JungleMobs = {}
       JungleNames = { 


["SRU_BlueMini21.1.3"]        = true,
["SRU_BlueMini1.1.2"]         = true,
["SRU_RedMini4.1.2"]          = true,
["SRU_RedMini4.1.3"]          = true,
["SRU_MurkwolfMini2.1.3"]     = true,
["SRU_MurkwolfMini2.1.2"]     = true, 
["SRU_RazorbeakMini3.1.2"]    = true,
["SRU_RazorbeakMini3.1.3"]    = true,
["SRU_RazorbeakMini3.1.4"]    = true,
["SRU_KrugMini5.1.1"]         = true,
["SRU_BlueMini27.1.3"]        = true,
["SRU_BlueMini7.1.2"]         = true,
["SRU_RedMini10.1.3"]         = true,
["SRU_RedMini10.1.2"]         = true,
["SRU_MurkwolfMini8.1.3"]     = true,
["SRU_MurkwolfMini8.1.2"]     = true,
["SRU_RazorbeakMini9.1.2"]    = true,
["SRU_RazorbeakMini9.1.3"]    = true,
["SRU_RazorbeakMini9.1.4"]    = true,    
["SRU_KrugMini11.1.1"]        = true,
["SRU_Blue1.1.1"]             = true,
["SRU_Red4.1.1"]              = true,
["SRU_Murkwolf2.1.1"]         = true,
["SRU_Razorbeak3.1.1"]        = true,
["SRU_Krug5.1.2"]             = true,
["SRU_Gromp13.1.1"]           = true,
["Sru_Crab15.1.1"]            = true,
["SRU_Blue7.1.1"]             = true,
["SRU_Red10.1.1"]             = true,
["SRU_Murkwolf8.1.1"]         = true,
["SRU_Razorbeak9.1.1"]        = true,
["SRU_Krug11.1.2"]            = true,
["SRU_Gromp14.1.1"]           = true,
["Sru_Crab16.1.1"]            = true,
["SRU_Dragon6.1.1"]           = true,        
["SRU_Baron12.1.1"]           = true,
}



function GetJungleMob()
 -- print("1")
	if JungleMobs ~= nil and #JungleMobs > 0 then
   --  print("2")
        for i, Mob in ipairs(JungleMobs) do
                if ValidTarget(Mob, 1100) and Mob.name ~= nil then return Mob end
        end
    else
    	return nil
    end
end



function OnDeleteObj(obj)

	if obj ~= nil then
		for i, Mob in ipairs(JungleNames) do
			if obj.name == Mob.name then
				table.remove(JungleMobs, i)
			end
		end
	
	
end
end


    camp1 = {x = 8400, y = 50.904, z = 2692}
    camp2 = {x = 7772, y = 53.937, z = 4008}
    camp3 = {x = 6902, y = 54.194, z = 5468}
    camp4 = {x = 3856, y = 52.463, z = 6510}
    camp5 = {x = 3874, y = 51.890, z = 7806}
    camp6 = {x = 2046, y = 51.777, z = 8458}
    camp7 = {x = 5030, y = -71.240, z = 10456}
    camp8 = {x = 6492, y = 56.476, z = 12128}
    camp9 = {x = 6894, y = 55.999, z = 10744}
    camp10 = {x = 7902, y = 5.359, z = 9448}
    camp11 = {x = 10910, y = 62.664, z = 8282}
    camp12 = {x = 10870, y = 51.722, z = 7056}
    camp13 = {x = 12762, y = 51.667, z = 6506}
    camp14 = {x = 9760, y = -71.240, z = 4364}
  

function Monster()
  --print(" hij komt hier")
  if skills.SkillQ.ready  then
  
  if GetDistance(camp1, myHero) <= 1100 then
 --   print(" hier ook")
    CastSpell(_Q, camp1.x, camp1.z)
 elseif GetDistance(camp2, myHero) <= 1100 then
    CastSpell(_Q, camp2.x, camp2.z)
    elseif GetDistance(camp3, myHero) <= 1100 then
    CastSpell(_Q, camp3.x, camp3.z)
    elseif GetDistance(camp4, myHero) <= 1100 then
    CastSpell(_Q, camp4.x, camp4.z)
    elseif GetDistance(camp5, myHero) <= 1100 then
    CastSpell(_Q, camp5.x, camp5.z)
    elseif GetDistance(camp6, myHero) <= 1100 then
    CastSpell(_Q, camp6.x, camp6.z)
    elseif GetDistance(camp7, myHero) <= 1100 then
    CastSpell(_Q, camp7.x, camp7.z)
    elseif GetDistance(camp8, myHero) <= 1100 then
    CastSpell(_Q, camp8.x, camp8.z)
    elseif GetDistance(camp9, myHero) <= 1100 then
    CastSpell(_Q, camp9.x, camp9.z)
    elseif GetDistance(camp10, myHero) <= 1100 then
    CastSpell(_Q, camp10.x, camp10.z)
    elseif GetDistance(camp11, myHero) <= 1100 then
    CastSpell(_Q, camp11.x, camp11.z)
    elseif GetDistance(camp12, myHero) <= 1100 then
    CastSpell(_Q, camp12.x, camp12.z)
    elseif GetDistance(camp2, myHero) <= 1100 then
    CastSpell(_Q, camp13.x, camp13.z)
    elseif GetDistance(camp2, myHero) <= 1100 then
    CastSpell(_Q, camp14.x, camp14.z)
    end
  
  end
  end

function Escape()
  --print(TargetJungleMob)
	TargetJungleMob = GetJungleMob()
	if TargetJungleMob ~= nil and ValidTarget(TargetJungleMob, 1100) and GetDistance(TargetJungleMob, myHero) < 1100 then
			if skills.SkillQ.ready and not TargetJungleMob.dead then
     --   print("stap2")
				CastSpell(_Q, TargetJungleMob.x, TargetJungleMob.z)
       
			end
			
	end
end

function ASLoadMinions()    
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then  
			if JungleNames[object.name] then
				table.insert(JungleMobs, object)
			end

end
end
end

function targetHasQ(target)
  if target ~= nil and target.team ~= myHero.team and target.type == myHero.type then
	local dd = false
	for b=1, target.buffCount do
		local buff = target:getBuff(b)
		if buff.valid and (buff.name == "BlindMonkQOne" or buff.name == "blindmonkqonechaos") and (buff.endT - GetGameTimer()) >= 0.3 then
			dd = true
			break
		end
	end
	
	return dd
end
end


function AdvancedKS()
 --[[
  local tipje = 775
  local jonko = false
   for i, turret in ipairs(GetTurrets()) do
    if turret ~= nil and turret.team ~= myHero.team and target ~= nil and GetDistance(turret, myHero) < 2000  then
       if ValidTarget(target) and GetDistance(target, turret) < tipje then 
         local jonko = true
       elseif ValidTarget(target) and GetDistance(target, turret) > tipje then
         local jonko = false
       end
    end
  end
  
      
  print(jonko)--]]
  if Menu.LeeSinCombo.combo then
   for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
    
  local maxrange = 600 + skills.SkillQ.range
  if target and skills.SkillW.ready and skills.SkillQ.ready and target.health <= eDmg + qDmg + eDmg then
    if myHero.health > target.health and AreaEnemyCount() <= 1 then
    if ValidTarget(target, maxrange) then --target.health <= target.maxHealth * 0.1 then
      if SightG ~= nil and target ~= nil then
    if ValidTarget(target, 1700) and GetDistance(myHero, target) >= 1000 and not ADVW  then
     
      local t = 600 / GetDistance(target)
      local ADV = Vector(myHero) + t * (Vector(target) - Vector(myHero))
      if skills.SkillW.ready and not ADVW then
     CastSpell(SightG, ADV.x, ADV.z)
     
     ADVW = true
     ADVWtimer = GetGameTimer()
   end
   end
      if ADVW and ADVWtimer + 0.5 <= GetGameTimer() then
        --print("kom")
                 if skills.SkillQ.ready and ValidTarget(target) then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
            if HitChance >= 2 then
				--CastSpell(_Q, CastPosition.x, CastPosition.z)
        Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
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


  end 

--[[
function checkForInsec()
 -- if Razer then
  if not Razer then
    check = false
        checktimer = math.huge
         wardgebruikt = false
      wardtimer = math.huge
       Razer = false
         Rtimer = math.huge
       end
       end
if Menu.Ads.insecMake then
 if not Menu.Ads.insecMake then
check = false
        checktimer = math.huge
         wardgebruikt = false
      wardtimer = math.huge
       Razer = false
         Rtimer = math.huge
       end
       end
--]]
naam = nil
insecTimer = math.huge
function einde()
   WardPoss = nil
  WardPosss = nil
  Penis = nil
  Vagina = nil
  end
gino = math.huge
papi = false
function insec()
 -- print(WardPosss)
  --if not papi then
 -- print(gino)
  --print(SightGDone)
--print("kip")
if ValidTarget(target) and target and target.type == myHero.type and target.team ~= myHero.team then
    naam = target.charName
    Mongool = target
    insecTimer = GetGameTimer()
  
  end

  if target ~= nil and target.valid then
if Menu.ProdSettings.SelectProdiction == 2 then
    if skills.SkillQ.ready and skills.SkillW.ready and skills.SkillR.ready and ValidTarget(target, 1100) then   
    local CastPosition, HitChance = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
      if HitChance >= 2 then  
     -- Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
     CastSpell(_Q, CastPosition.x, CastPosition.z)
      end
    end
  elseif Menu.ProdSettings.SelectProdiction == 4  then
    if skills.SkillQ.ready and skills.SkillW.ready and skills.SkillR.ready and ValidTarget(target, 1100) then   
      CastQ()
    end
    end
    

    if target ~= nil and ValidTarget(target) then
      if ally then
      WardPoss = Vector(target) + (Vector(target) - ally):normalized() * 350
     -- print("1")
    end
    end
    if target ~= nil and not ally and ValidTarget(target) then
      --print("1")
      local InsectDirection = Vector(myHero.pos)
      
      WardPosss = Vector(target) + (Vector(target) - InsectDirection):normalized() * 350
      
    end
end
 -- print("1")
      --if not wardgebruikt and not SightGDone then
      if WardPoss and SightG ~= nil and GetDistance(myHero, WardPoss) <= skills.SkillW.range and ally and skills.SkillW.ready and InsecQ then
        -- print("2")
         if SightG == 12 then 
          Penis = SightG
          CastSpell(Penis, WardPoss.x, WardPoss.z)
          SightGDone = true
          SightGTimer = GetGameTimer()
          end
        if SightG ~= nil and SightG ~= 12 then
          CastSpell(SightG, WardPoss.x, WardPoss.z)
          SightGDone = true
          SightGTimer = GetGameTimer()
    end
   end
    -- print("UO") --GetDistance(myHero, WardPosss) <= skills.SkillW.range
     if WardPosss and SightG ~= nil and not ally  and GetDistance(myHero, WardPosss) <= skills.SkillW.range and skills.SkillW.ready and  InsecQ then
        --print("CANCER")
        if SightG == 12 then
          Vagina = SightG 
          CastSpell(Vagina, WardPosss.x, WardPosss.z)
          SightGDone = true
          SightGTimer = GetGameTimer()
          end
        if SightG ~= nil and SightG ~= 12 and GetDistance(myHero, WardPosss) <= skills.SkillW.range then
          --print("q")
          CastSpell(SightG, WardPosss.x, WardPosss.z)
          SightGDone = true
          SightGTimer = GetGameTimer()
     end
     
     end
   
   
 
     if ValidTarget(target, skills.SkillR.range) and skills.SkillR.ready and insecW then
      -- print(" hij probeert")
      CastSpell(_R, target)
    --   einde()
 --gino = GetGameTimer()
 --papi = true

  end
  end

--end

	--	end
	--end--, (GetLatency() * 1.5), {WardPos, target})
Toren = nil
Ally = nil
 

function AreaEnemyCount()
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(myHero, enemy) < skills.SkillE.range then
				count = count + 1
			end
		end              
	return count
end

function DiveOrNot()
	return ValidTarget(target) and not UnderTurret(target.pos, true)
end

 function AdvancedR()
    if target ~= nil and ValidTarget(target, skills.SkillR.range) then
    local KnockDistance = 800
    local KSult = Vector(target) +  (Vector(target)-Vector(myHero)):normalized()*KnockDistance
    DrawCircle(KSult.x, KSult.y, KSult.z, 100, 0xffffff)
	for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    eDmg = getDmg("E", enemy,myHero)
      
    if enemy.valid and enemy.team ~= myHero.team and enemy.type == myHero.type and enemy.health <= rDmg and not enemy.dead then
      if GetDistance(enemy, KSult) <= 100 then
        if skills.SkillR.ready then
          CastSpell(_R, target)
        end
      end
    end
  end
  
end
end


  function endlane()
  end
  --[[
local Tower = nil

function SearchTower()

for i=0, objManager.iCount, 1 do

  obj = objManager:GetObject(i)

  if obj and obj.type == "obj_AI_Turret" and obj.team == myHero.team then

      turretPos = Point(obj.x, obj.z)
      if Tower == nil or GetDistance(turretPos) < Tower then
          Tower = turretPos
      end
  end

end
    print(Tower) --this will spam a bit
end--]]
--[[
function OnDeleteObj(obj, name)
  if obj and obj.team == myHero.team then
    --print(obj)
  end
  end
function toren()
  if turrets ~= nil then 
  print(turrets.valid)
 end
end--]]
--[[
function SearchALly()
  for i = 1, heroManager.iCount do
        local obj = heroManager:GetHero(i)
        if hero.team == myHero.team and hero.type == myHero.type and hero.charName ~= myHero.charName then
          if GetDistanceSqr(myHero, hero) < 1500 * 1500 then
          Ally = hero
        else
          Ally = nil
        end
      end
    end
    
        end
        --]]
    local allies = GetAllyHeroes()

function getRandomAlly(range)
    for i, ally in pairs(allies) do
        if GetDistance(ally) < range then
            return ally
        end
    end
    return nil
end


function CastQ()
  if target ~= nil then
  local QPos, QHitChance = HPred:GetPredict("Q", target, myHero)
  
  if QHitChance >= 2 then
  
  
      
      Packet("S_CAST", {spellId = _Q, toX = QPos.x, toY = QPos.z, fromX = QPos.x, fromY = QPos.z}):send()
    
  end
  
end
end


