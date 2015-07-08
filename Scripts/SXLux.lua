if myHero.charName ~= "Lux"  or not VIP_USER then return end
local version = 1.6
local AUTOUPDATE = true
local SCRIPT_NAME = "SXLux"

-- thx to klokje and dekaron2
require 'VPrediction'
--require 'SOW'
--require 'SourceLib'
require "SxOrbwalk"
--require 'Collision'
require 'HPrediction'
--require 'Prodiction'
require 'DivinePred'


local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local ADC, lowGuy
local eRange
local qRange
local rRange
local zhonyaslot = nil


function CheckUpdate()
        local scriptName = "SXLux"
        local version = 1.6
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXLux"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXLux"..scriptName..".lua"
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


local enemyHeros = {}
local enemyHerosCount = 0
local useIgnite = true
local tick = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {3,1,2,3,3,4,3,2,3,2,4,2,2,1,1,4,1,1}
local Ranges = { AA = 500 }
local skills = {
	SkillQ = { ready = true, name = "LuxLightBinding", range = 1175, delay = 0.5, speed = 1800.0, width = 60.0 },
	SkillW = { ready = true, name = "", range = 1100, delay = null, speed = null, width = null },
	SkillE = { ready = true, name = "LuxLightStrikeKugel", range = 1100, delay = 0.5, speed = 1300.0, width = 275.0 },
	SkillR = { ready = true, name = "LuxMaliceCannon", range = 3340, delay = 0.7, speed = math.huge, width = 190.0 },
}
--[[ Slots Itens ]]--
local tiamatSlot, hydraSlot, youmuuSlot, bilgeSlot, bladeSlot, dfgSlot, divineSlot = nil, nil, nil, nil, nil, nil, nil
local tiamatReady, hydraReady, youmuuReady, bilgeReady, bladeReady, dfgReady, divineReady = nil, nil, nil, nil, nil, nil, nil



-- champs
Champions = {
    ["Katarina"] = {
    	spells = {
    		["KatarinaR"] = {name = "Death Lotus"}
    	}
    },
    ["Nunu"] = {
    	spells = {
    		["AbsoluteZero"] = {name = "Absolute Zero"}
    	}
    },
    ["Karthus"] = {
    	spells = {
    		["KarthusFallenOne"] = {name = "Requiem"}
    	}
    },
    ["FiddleSticks"] = {
    	spells = {
    		["Crowstorm"] = {name = "Crowstorm"}
    	}
    },
    ["Malzahar"] = {
    	spells = {
    		["AlZaharNetherGrasp"] = {name = "NetherGrasp"}
    	}
    },
    ["Galio"] = {
    	spells = {
    		["GalioIdolOfDurand"] = {name = "Idol of Durand"}
    	}
    },
}

--[[Auto Attacks]]--
local lastBasicAttack = 0
local swingDelay = 0.25
local swing = false

--[[Misc]]--
local lastSkin = 0
local isSAC = false
local isMMA = false
local target = nil
--local enemyChamps{}
--local predict = true
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


if myHero.charName == "Karma" then
	typeshield = 1
	spellslot = _E
	range = 800
elseif myHero.charName == "LeeSin" then
	typeshield = 1
	spellslot = _W
	range = 700
elseif myHero.charName == "Lux" then
	typeshield = 2
	spellslot = _W
	range = 1075
  elseif myHero.charName == "Morgana" then
	typeshield = 5
	spellslot = _E
	range = 750
  end
  
  local sbarrier = nil
local sheal = nil
local useitems = true
local spelltype = nil
local casttype = nil
local BShield,SShield,Shield,CC = false,false,false,false
local shottype,radius,maxdistance = 0,0,0
local hitchampion = false

        _SAC = false
  
function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
	initComponents()

    
   
 
Lux_Q  = HPSkillshot({type = "DelayLine", delay = 0.25, range = 1300, speed = 1200, collisionM = true, collisionH = true, width = 160})
Lux_E = HPSkillshot({type = "DelayCircle", delay = 0.25, range = 1100, speed = 1300, radius = 350})
--Lux E2 =  ["E2"] = HPSkillshot({type = "PromptCircle", delay = 0, range = 0, radius = 350})
Lux_R  = HPSkillshot({type = "PromptLine", delay = 1.012, range = 3300, speed = 1800, width = 380})


end
function initComponents()
 -- homo = GetGameTimer()
HPred = HPrediction()
  --DP = DivinePred()
    -- VPrediction Start
 VP = VPrediction()

   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 3400)
  
 Menu = scriptConfig("SXLux by SyraX", "luxMA")

   if _G.MMA_Loaded then
     PrintChat("<font color = \"#33CCCC\">MMA Search:</font> <font color = \"#fff8e7\"> Got it! MMA loaded Gino </font>")
     isMMA = true
     
 elseif _SAC then
    
      PrintChat("<font color = \"#33CCCC\">SAC Search:</font> <font color = \"#fff8e7\"> Got it! SAC Loaded Gino </font>")
     isSAC = true
     else

  
      PrintChat("<font color = \"#33CCCC\">OrbWalker found:</font> <font color = \"#fff8e7\"> Loading SX</font>")
       --Menu:addSubMenu("["..myHero.charName.." - Orbwalker]", "SOWorb")
      -- Orbwalker:LoadToMenu(Menu.SOWorb)
       
       	Menu:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)

    Menu:addTS(ts)
    end

 Menu:addSubMenu("["..myHero.charName.." - Combo]", "luxCombo")
    Menu.luxCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.luxCombo:addSubMenu("Q Settings", "qSet")
  Menu.luxCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.luxCombo:addSubMenu("W Settings", "wSet")
  Menu.luxCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 Menu.luxCombo:addSubMenu("E Settings", "eSet")
  Menu.luxCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.luxCombo:addSubMenu("R Settings", "rSet")
  Menu.luxCombo.rSet:addParam("useR", "Use Smart Ultimate", SCRIPT_PARAM_ONOFF, true)
 
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
	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 1, {"HProdiction", "VPrediction", "Not Working!"})
 -- Menu.ProdSettings:addParam("OD", "OnDash", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("AD", "AfterDash", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings:addParam("AI", "AfterImmobile", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("OI", "OnImmobile ", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings.OD
  Menu:addSubMenu("["..myHero.charName.." - Shield Settings]", "Shield")
 --print("boss2")
   if typeshield ~= nil then
   --  print("boss")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then Menu.Shield:addParam("teammateshield"..i, "Shield "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		Menu.Shield:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		Menu.Shield:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		Menu.Shield:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		Menu.Shield:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
		Menu.Shield:addParam("shieldcc", "Auto Shield Hard CC", SCRIPT_PARAM_ONOFF, true)
		Menu.Shield:addParam("shieldslow", "Auto Shield Slows", SCRIPT_PARAM_ONOFF, true)
	--	ASConfig:addParam("drawcircles", "Draw Range", SCRIPT_PARAM_ONOFF, true)
		Menu.Shield:permaShow("mindmg")
  end
    
 
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
  --  Menu.Ads:addParam("Shield", "Shield Ally", SCRIPT_PARAM_ONOFF, false)
  -- Menu.Ads:addParam("Shieldd", "Shiel your self", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addParam("AZ", "Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
	Menu.Ads:addParam("AZHP", "Min HP To Zhonya", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
	Menu.Ads:addParam("AZMR", "Enemy In Range:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
  Menu.Ads:addParam("OC", " On Cap Close", SCRIPT_PARAM_ONOFF, false)

    Menu.Ads:addParam("NOVA", "Cast second E", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false) -- Menu.Ads.KS.useR
   Menu.Ads.KS:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
   
   Menu.Ads.KS:addParam("autoQ", "Auto Q", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("KSB", "Steal Buffs", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
  Menu.Ads:addSubMenu("VIP", "VIP")
  --  Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
  --Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 5)
    
 --[[Menu:addSubMenu("["..myHero.charName.." - Target Selector]", "targetSelector")
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
 
 --if Menu.Ads.VIP.skin and VIP_USER then
      -- GenModelPacket("lux", Menu.Ads.VIP.skin1)
     --lastSkin = Menu.Ads.VIP.skin1
   -- end
    

  
 PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">SXLux</font> <font color = \"#FFA319\">by SyraX V"..version.."</font>")
-- print(myHero.ap / 100)
--print(percentage)
end

local objE = nil
local Damage = false
click = 0
 time = math.huge
 klik = 0
tijd = math.huge
--tering = GetRDamage()
 -- pewpew = PassiveDamage() + tering
 -- paarprocent = (myHero.ap / 100)
 -- percentage = paarprocent * 75
 
  zhonyaslot = GetInventorySlotItem(3157)
  zhonyaready = (zhonyaslot ~= nil and myHero:CanUseSpell(zhonyaslot) == READY)
  rpower = 0
  EHP = nil
  Passive = false
  Stun = false
  local divineQSkill = SkillShot.PRESETS['LuxLightBinding']
  local divineESkill = SkillShot.PRESETS['LuxLightStrikeKugel']
  local divineRSkill = SkillShot.PRESETS['LuxMaliceCannon']
local DP = DivinePred()

Passivetime = math.huge
 -- bono = nil
 -- pewpew = nil
  --pewpew = PassiveDamage() + GeRDamage()
function OnTick()
      if _SAC == false and _G.AutoCarry then
        print("Found SAC! Plss disable SX orbwalk !")
        _SAC = true
        
    end



  target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  DamageCalculation()
  if Menu.Ads.OC then
  OnGapclose(target)
  
end
 -- print(classicQ)
 -- paarprocent = myHero.ap / 100
  --percentage = paarprocent * 75
  stap1 = 10 + (8 * myHero.level)
  stap2 = myHero.ap/100
  stap3 = stap2 * 20
 paardebek = stap2 + stap3
 --print(iphone)
 ipad = myHero.ap * 0.75
 --ipod = myHero.ap * 0.56
-- iphone = ipad + rpower
 --if target ~= nil then
 --bono = target.magicArmor
 --end


        
  

 if Passivetime + 6 <= GetGameTimer() then 
  Passive = false
  end
  if myHero.level < 6 then
    rpower = 0
  elseif myHero.level >= 6 and myHero.level < 11 then
    rpower = 300
  elseif myHero.level >= 11 and myHero.level < 16 then
    rpower = 400
  elseif myHero.level >= 16 then
    rpower = 500
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
  
   
    
     -- sec
      if klik == 2 then
       DoubleClick2()
       if klik == 2 then
         klik = 0
        end
   end
   if klik >= 3 then
   klik = 0
   end
   if klik == 1 then
      if tijd + 0.4 <= GetGameTimer() then
         klik = 0
         tijd  = math.huge
      end
    end 
  
	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("lux", Menu.Ads.VIP.skin1)
		lastSkin = Menu.Ads.VIP.skin1
	end

  if Menu.Ads.NOVA then
		for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			local radius = skills.SkillE.range + VP:GetHitBox(hero)
			if hero.team ~= myHero.team and objE ~= nil and ValidTarget(hero) and GetDistanceSqr(objE,hero) <= radius * radius then
				CastSpell(_E)
       -- print("E2")
			end
		end
	end
  
    
	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
  	if Menu.luxCombo.combo and Menu.ProdSettings.SelectProdiction == 2 then
		Combo()
  elseif Menu.luxCombo.combo and Menu.ProdSettings.SelectProdiction == 1 then
    ProdictionCombo()
  elseif Menu.luxCombo.combo and Menu.ProdSettings.SelectProdiction == 3 then
    AllInCombooo()
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




function ProdictionCombo()
  
  if target ~= nil and target.type == myHero.type  and target.team ~= myHero.team then
    for i, target in ipairs(GetEnemyHeroes()) do
		rDmg = getDmg("R", target, myHero)
    if  Menu.luxCombo.qSet.useQ and Menu.ProdSettings.SelectProdiction == 1 then
        if ValidTarget(target, skills.SkillQ.range)  then
                    CastQ()
        end
    end
    if  Menu.luxCombo.eSet.useE and Menu.ProdSettings.SelectProdiction == 1 then
        if ValidTarget(target, skills.SkillE.range) then
                   CastE()
        end
    end

end
end
end
function CDHandler()
	-- Spells
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)

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
end

-- Harass functie--

function Harass()	
	if target ~= nil and ValidTarget(target) and target.team ~= myHero.team and target.type == myHero.type then
    if Menu.ProdSettings.SelectProdiction == 2 then
  		if Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and Qready then
       QVP()
      end
      if  Menu.Harass.useE and ValidTarget(target, skills.SkillE.range) and Eready then
        EVP()
      end
    elseif Menu.ProdSettings.SelectProdiction == 1 then
      if ValidTarget(target, skills.SkillQ.range) and Qready and Menu.Harass.useQ then
        CastQ()
      end
      if  ValidTarget(target, skills.SkillE.range) and Eready and Menu.Harass.useE then
      CastE()
    end
  elseif Menu.ProdSettings.SelectProdiction == 3 then
      if ValidTarget(target, skills.SkillQ.range) and Qready then
        DevineQ()
      end
      if  ValidTarget(target, skills.SkillE.range) and Eready then
      DevineE()
    end
    
    end
    
      
      
      
      
	end
end

function autozh()
	local count = EnemyCount(myHero, Menu.Ads.AZMR)
	if zhonyaready and ((myHero.health/myHero.maxHealth)*100) < Menu.Ads.AZHP and count == 0 then
		CastSpell(zhonyaslot)
	end
end

function EnemyCount(point, range)
	local count = 0
	for _, enemy in pairs(GetEnemyHeroes()) do
		if enemy and not enemy.dead and GetDistance(point, enemy) <= range then
			count = count + 1
		end
	end            
	return count
end
-- auto Q
function OnGapclose(target)
  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
    
    local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
          if Qready and  HitChance >= 2 and GetDistance(CastPosition) <= 175then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
          end
         
            
		
	end
end

-- Combo herkenbaar--

function Combo()
	local typeCombo = 0
	if target ~= nil and Menu.ProdSettings.SelectProdiction == 2 then
		AllInCombo(target, 0)
  end
 
end

      

function AllInCombo(target, typeCombo)
	if target ~= nil and typeCombo == 0 and target.type == myHero.type and target.team then
		ItemUsage(target)
    if Menu.ProdSettings.SelectProdiction == 2 then
      if Menu.luxCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and Qready then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
            if HitChance >= 1 and GetDistance(CastPosition) <= 1175 then
			--	CastSpell(_Q, CastPosition.x, CastPosition.z)
      Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
    else
      
            end
    end
    end
      	
        if Menu.ProdSettings.SelectProdiction == 2 then
		   if Menu.luxCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and Eready then
local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, false)
            if HitChance >= 1 and GetDistance(CastPosition) < 1050 then
            --  CastSpell(_E, CastPosition.x, CastPosition.z)
            Packet("S_CAST", {spellId = _E, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
            end
        end
   end
end

end

function AllInCombooo()
 --print("hij komt er wel")
	if target ~= nil and target.type == myHero.type then
		ItemUsage(target)
    if Menu.ProdSettings.SelectProdiction == 3 then
      if Menu.luxCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and Qready then
        -- print("hij komt er wel")
        DevineQ()
        end  
		   if Menu.luxCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and Eready then
        DevineE()
            end
        end
   end
   end
-- All In Combo --




function LaneClear()
	for i, minion in pairs(targetMinions.objects) do
		if minion ~= nil then
			if Menu.Laneclear.useClearQ and Qready and ValidTarget(minion, skills.SkillQ.range)then
				local qPosition, qChance = VP:GetCircularCastPosition(minion, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, false)
			    if qPosition ~= nil and qChance >= 2 then
			      --CastSpell(_Q, qPosition.x, qPosition.z)
            Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
			    end
      end
      if Menu.Laneclear.useClearE and Eready and ValidTarget(minion, skills.SkillE.range)then
				local ePosition, eChance = VP:GetCircularCastPosition(minion, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, false)
			    if ePosition ~= nil and eChance >= 2 then
			     -- CastSpell(_E, ePosition.x, ePosition.z)
           Packet("S_CAST", {spellId = _E, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
          end
      end
    end
  end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
			if Menu.Jungleclear.useClearQ and Qready and ValidTarget(jungleMinion, skills.SkillQ.range) then
				CastSpell(_Q, jungleMinion.x, jungleMinion.z)
			end
			if Menu.Jungleclear.useClearE and Eready and ValidTarget(jungleMinion, skills.SkillE.range) then
				CastSpell(_W, jungleMinion.x, jungleMinion.z)
			end
		end
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

function KillSteal()
  --[[if Menu.Ads.KS.useR then
		hardeultiKS()
	end
  if Menu.Ads.KS.useE then
    hardeKSE()
end--]]

if Menu.Ads.AZ then
		autozh()
	end

if not Passive then
  KSNoPassive()
end
if Passive and Menu.Ads.KS.useR and target ~= nil then
  if target.type == myHero.type and target.team ~= myHero.team and ValidTarget(target, skills.SkillR.range) and GetDistance(target, myHero) > 1300 then
     KSWhitPassive()
  end
  end
	if Menu.Ads.KS.ignite then
		IgniteKS()
  end
  if Menu.Ads.KS.KSB then
    KSBUFF()
  end
 
  --[[if Menu.Ads.KS.useQ then
     hardeKSQ()
  end--]]
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


      if not Qready and not Wready and not Eready and not Rready then
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
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 0, 0, 102)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 , 255, 0, 127)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 , 255, 0, 127)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 255, 0, 127)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 255, 0, 127)) end
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
if not myHero.dead and target ~= nil and	target.team ~= myHero.team and target.type == myHero.type then 
		--	if Settings.drawing.text then 
				DrawText3D("Focus This Bitch!",target.x-100, target.y-50, target.z, 20, 0xFFFF9900) --0xFF9900
			end
			--[[if target ~= nil then 
				DrawCircle(target.x, target.y, target.z, 150, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
			end--]]
		end





-- Steal the jungle mobs whit R Copyright!
local JungleMobs = {}
local JungleFocusMobs = {}





--Moet 
local JungleMobNames = { 
        ["SRU_Blue7.1.1"] = true,
        ["SRU_Red10.1.1"] = true,
         ["SRU_Dragon6.1.1"] = true,
        ["SRU_Baron12.1.1"] = true,
      --  ["wolf8.1.1"] = true,
       -- ["wolf8.1.2"] = true,
        --["YoungLizard7.1.2"] = true,
       -- ["YoungLizard7.1.3"] = true,
       -- ["LesserWraith9.1.1"] = true,
     --   ["LesserWraith9.1.2"] = true,
       -- ["LesserWraith9.1.4"] = true,
       -- ["YoungLizard10.1.2"] = true,
     --   ["YoungLizard10.1.3"] = true,
     --   ["SmallGolem11.1.1"] = true,
     --   ["wolf2.1.1"] = true,
    --    ["wolf2.1.2"] = true,
   ---     ["YoungLizard1.1.2"] = true,
    --  -  ["YoungLizard1.1.3"] = true,
     --   ["LesserWraith3.1.1"] = true,
     --   ["LesserWraith3.1.2"] = true,
   --    ["LesserWraith3.1.4"] = true,
   --     ["YoungLizard4.1.2"] = true,
    --   ["YoungLizard4.1.3"] = true,
      --  ["SmallGolem5.1.1"] = true,
}

local FocusJungleNames = {
        ["SRU_Dragon6.1.1"] = true,
        ["SRU_Baron12.1.1"] = true,
      --  ["GiantWolf8.1.1"] = true,
       -- ["AncientGolem7.1.1"] = true,
      --  ["Wraith9.1.1"] = true,
      --  ["LizardElder10.1.1"] = true,
      --  ["Golem11.1.2"] = true,
     --   ["GiantWolf2.1.1"] = true,
        ["SRU_Blue1.1.1"] = true,
     --   ["Wraith3.1.1"] = true,
        ["SRU_Red4.1.1"] = true,
     --   ["Golem5.1.2"] = true,
		--["GreatWraith13.1.1"] = true,
	--	["GreatWraith14.1.1"] = true,
}



function GetJungleMob()
	if JungleFocusMobs ~= nil and #JungleFocusMobs > 0 and player.team == TEAM_RED then
        for i, Mob in ipairs(JungleFocusMobs) do
                if ValidTarget(Mob, 3300) and Mob.name ~= nil then return Mob end
        end
    elseif JungleMobs ~= nil and #JungleMobs > 0 and player.team == TEAM_BLUE then
        for i, Mob in ipairs(JungleMobs) do
           if ValidTarget(Mob, 3300) and Mob.name ~= nil then return Mob end
        end
    else
    	return nil
    end
end

function OnCreateObj(obj)
  --if obj then print(obj.name) end
--  print("kip")
   if GetDistance(obj, myHero, 1000) then 
  -- print(obj.name)
 end
 if obj and obj.team == myHero.team then
  if obj.name:find("LuxLightstrike_tar_green") or obj.name:find("Lux_Base_E_mis.troy") then
		objE = obj
	end
  end
	if obj ~= nil then
		if FocusJungleNames[obj.name] and player.team == TEAM_RED then
      --print(obj.name)
			table.insert(JungleFocusMobs, obj)
		elseif JungleMobNames[obj.name] and player.team == TEAM_BLUE  then
            table.insert(JungleMobs, obj)
		end
	end
	if obj ~= nil and obj.type == "obj_AI_Minion" and obj.name ~= nil then
    if player.team == TEAM_RED then
 
		if obj.name == "SRU_Baron12.1.1" then Nashor = obj
		elseif obj.name == "SRU_Dragon6.1.1" then Dragon = obj
		elseif obj.name == "SRU_Blue1.1.1" then Golem1 = obj
    elseif obj.name == "SRU_Red4.1.1" then Lizard1 = obj end
  elseif player.team == TEAM_BLUE then
    if obj.name == "SRU_Baron12.1.1" then Nashor = obj
  elseif obj.name == "SRU_Blue7.1.1" then Golem2 = obj
    elseif obj.name == "SRU_Dragon6.1.1" then Dragon = obj
    elseif obj.name == "SRU_Red10.1.1" then Lizard2 = obj end
  
	end
end
end

function OnDeleteObj(obj)
  if obj.name:find("LuxLightstrike_tar_green") or (objE ~= nil and obj.name == objE.name) then
		objE = nil
	end
  --if GetDistance(obj, 400) then
  if obj ~= nil and obj.team == myHero.team then
 -- print(obj.name)
 end
	if obj ~= nil then
		for i, Mob in ipairs(JungleMobs) do
			if obj.name == Mob.name then
				table.remove(JungleMobs, i)
			end
		end
		for i, Mob in ipairs(JungleFocusMobs) do
			if obj.name == Mob.name then
				table.remove(JungleFocusMobs, i)
			end
		end
	end
	if obj ~= nil and obj.name ~= nil then
		if obj.name == "TT_Spiderboss7.1.1" then Vilemaw = nil
		elseif obj.name == "SRU_Baron12.1.1" then Nashor = nil
		elseif obj.name == "SRU_Dragon6.1.1" then Dragon = nil
		elseif obj.name == "SRU_Blue1.1.1" then Golem1 = nil
		elseif obj.name == "SRU_Blue7.1.1" then Golem2 = nil
		elseif obj.name == "SRU_Red4.1.1" then Lizard1 = nil
		elseif obj.name == "SRU_Red10.1.1" then Lizard2 = nil end
	end
end

function checkDeadMonsters()
	if Vilemaw ~= nil then if not Vilemaw.valid or Vilemaw.dead or Vilemaw.health <= 0 then Vilemaw = nil end end
	if Nashor ~= nil then if not Nashor.valid or Nashor.dead or Nashor.health <= 0 then Nashor = nil end end
	if Dragon ~= nil then if not Dragon.valid or Dragon.dead or Dragon.health <= 0 then Dragon = nil end end
	if Golem1 ~= nil then if not Golem1.valid or Golem1.dead or Golem1.health <= 0 then Golem1 = nil end end
	if Golem2 ~= nil then if not Golem2.valid or Golem2.dead or Golem2.health <= 0 then Golem2 = nil end end
	if Lizard1 ~= nil then if not Lizard1.valid or Lizard1.dead or Lizard1.health <= 0 then Lizard1 = nil end end
	if Lizard2 ~= nil then if not Lizard2.valid or Lizard2.dead or Lizard2.health <= 0 then Lizard2 = nil end end
end

--- wauw


function KSBUFF()
  --print(TargetJungleMob)
	TargetJungleMob = GetJungleMob()
	if TargetJungleMob ~= nil and ValidTarget(TargetJungleMob, 3300) and GetDistance(TargetJungleMob, myHero) < 3300 then
			if Rready and TargetJungleMob.health < rDmg and not TargetJungleMob.dead then
     --   print("stap2")
				CastSpell(_R, TargetJungleMob.x, TargetJungleMob.z)
       
			end
			
	end
end

function ASLoadMinions()
	for i = 1, objManager.maxObjects do
		local obj = objManager:getObject(i)
		if obj ~= nil and obj.type == "obj_AI_Minion" and obj.name ~= nil then
			if obj.name == "TT_Spiderboss7.1.1" then Vilemaw = obj
			elseif obj.name == "Worm12.1.1" then Nashor = obj
			elseif obj.name == "Dragon6.1.1" then Dragon = obj
			elseif obj.name == "AncientGolem1.1.1" then Golem1 = obj
			elseif obj.name == "AncientGolem7.1.1" then Golem2 = obj
			elseif obj.name == "LizardElder4.1.1" then Lizard1 = obj
			elseif obj.name == "LizardElder10.1.1" then Lizard2 = obj end
		end
	end
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
			if FocusJungleNames[object.name] and player.team == TEAM_RED then
				table.insert(JungleFocusMobs, object)
			elseif JungleMobNames[object.name] and player.team == TEAM_BLUE then
				table.insert(JungleMobs, object)
			end
		end
	end
end
local injectedd = false
local mostDamage = 0
local lowestHealth = math.huge

 
 
 function DoubleClick()
 
 end
 
 function DoubleClick2()
 
    end
  

      
        function LevelR()
        if myHero:GetSpellData(_R).level == 0 then
          return 0
        elseif myHero:GetSpellData(_R).level == 1 then
          return 0

        elseif myHero:GetSpellData(_R).level == 2 then
                return 100
        elseif myHero:GetSpellData(_R).level == 3 then
                return 200
        end
end

        
        
        
        
   
function QVP()
   if target ~= nil and target.type == myHero.type then
      if Menu.ProdSettings.SelectProdiction == 2 then
      if Menu.luxCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and Qready and not target.dead then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
            if HitChance >= 1 and GetDistance(CastPosition) <= 1175 then
				--CastSpell(_Q, CastPosition.x, CastPosition.z)
        Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
            end
    end
  end
end
end
--local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(unit, E.delay, E.width, E.range, E.speed, myHero
function EVP()
   if target ~= nil and target.type == myHero.type and not target.dead then
  if Menu.ProdSettings.SelectProdiction == 2 then
  if Menu.luxCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and Eready then
  local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, false)
    if HitChance >= 2 and GetDistance(CastPosition) < 1100 then
      --CastSpell(_E, CastPosition.x, CastPosition.z)
      Packet("S_CAST", {spellId = _E, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
    end
  end
end
end
end





function DevineQ()
 -- print("johhny")
  if target ~= nil and target.type == myHero.type then
  if Menu.ProdSettings.SelectProdiction == 3 then
			local target = DPTarget(target)
		--	local NidaleeQ = LineSS(target, divineQSkill)
			local State, Position, perc = DP:predict(target, divineQSkill)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				
      Packet("S_CAST", {spellId = _Q, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end
function DevineE()
 -- print("johhny")
  if target ~= nil and target.type == myHero.type then
  if Menu.ProdSettings.SelectProdiction == 3 then
			local target = DPTarget(target)
		--	local NidaleeQ = LineSS(target, divineQSkill)
			local State, Position, perc = DP:predict(target, divineESkill)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				
      Packet("S_CAST", {spellId = _E, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end
function DevineR()
  --print("johhny")
  if target ~= nil and target.type == myHero.type then
  if Menu.ProdSettings.SelectProdiction == 3 then
			local target = DPTarget(target)
		--	local NidaleeQ = LineSS(target, divineQSkill)
			local State, Position, perc = DP:predict(target, divineRSkill)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				
      Packet("S_CAST", {spellId = _R, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end
function RVP()
  if target ~= nil and target.type == myHero.type and not target.dead then
   if Menu.ProdSettings.SelectProdiction == 2 then
		   if Menu.luxCombo.eSet.useE and ValidTarget(target, skills.SkillR.range) and Rready then
local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, skills.SkillR.delay, skills.SkillR.width, skills.SkillR.range, skills.SkillR.speed, myHero, false)
            if HitChance >= 3 and GetDistance(CastPosition) < 3300 then
             -- CastSpell(_R, CastPosition.x, CastPosition.z)
             Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
            end
        end
   end
end
end

function KSAA()
  if target ~= nil and Passive and ValidTarget(target, 550) then
    myHero:Attack(target)
  end
end





  function level()
  return myHero.level

end 

function KSNoPassive()
 --print("DP")
  if not Passive then
    if target ~= nil and target.type == myHero.type and target.team ~= myHero.team and target.valid and not target.dead then
    --  if paardebek ~= nil then
        for i=1, heroManager.iCount do
        local target = heroManager:GetHero(i)
          if ValidTarget(target) and target ~= nil then
          qDmg = getDmg("Q", target,myHero)
          eDmg = getDmg("E", target,myHero)
          rDmg = getDmg("R", target, myHero)
          pDmg = getDmg("P", target, myHero)
         --  rDmg = rDmg + LevelR()
        --  print(rDmg)
            if Menu.ProdSettings.SelectProdiction == 2 and ValidTarget(target)then
              if target.health <= qDmg and Qready and Menu.Ads.KS.useQ and ValidTarget(target, skills.SkillQ.range) then
              QVP()
             -- print("KSQ")
              end
              if target.health <= eDmg and Eready and Menu.Ads.KS.useE and ValidTarget(target, skills.SkillE.range) then
              EVP()
            --  print("KSE")
              end
              if target.health <= rDmg and Rready and Menu.Ads.KS.useR  and ValidTarget(target, skills.SkillR.range)then
              RVP()
           -- print(rDmg)
            end
            
             --[[ if target.health <=  qDmg + eDmg + pDmg and Menu.Ads.KS.useQ and Menu.Ads.KS.useE and Vathen
              QVP()
              EVP()
              KSAA()
             -- print("low combo")
              end--]]
          if Stun and target.health <= eDmg + rDmg and Rready and Eready and ValidTarget(target, skills.SkillE.range) and Menu.Ads.KS.useE and Menu.Ads.KS.useR then
            EVP() 
            RVP()
        --    print("big combo")
            KSAA()
           end
          elseif Menu.ProdSettings.SelectProdiction == 1 then
            --print("HP")
            if target.health <= qDmg and Qready and Menu.Ads.KS.useQ then
            CastQ()
            elseif target.health <= eDmg and Eready and Menu.Ads.KS.useE then
            CastE()
            elseif target.health <= rDmg and Rready and Menu.Ads.KS.useR  and ValidTarget(target, skills.SkillR.range)then
            CastR()
            end
          elseif Menu.ProdSettings.SelectProdiction == 3 then
           -- print("DP2")
            if target.health <= qDmg and Qready and Menu.Ads.KS.useQ then
            DevineQ()
            elseif target.health <= eDmg and Eready and Menu.Ads.KS.useE then
            DevineE()
            elseif target.health <= rDmg and Rready and Menu.Ads.KS.useR  and ValidTarget(target, skills.SkillR.range)then
            DevineR()
          --  print("tepper je bent eccht opgeschoten vandaag")
        
          end
            end
         end
        end
      end
    end
  end


function KSWhitPassive()
--print("DP")
  
  if Passive then
      if target ~= nil and target.type == myHero.type and target.team ~= myHero.team and target.visible and target.valid and not target.dead then
      
        for i=1, heroManager.iCount do
        local target = heroManager:GetHero(i)
          if ValidTarget(target) and target ~= nil and LevelR() ~= nil then
          qDmg = getDmg("Q", target,myHero)
          eDmg = getDmg("E", target,myHero)
          rDmg = getDmg("R", target, myHero)
          pDmg = getDmg("P", target, myHero)
          local rDmgP, TypeDmg = getDmg("R",target,myHero,2)
          local eDmgP = getDmg("E",target,myHero,2)
          local qDmgP = GetDmg("Q",target,myHero,2)
          rDmg = rDmg + LevelR()
          if rDmgP ~= nil then
            --print(rDmgP)
            end
       
            if target.health <= rDmgP and Rready and Menu.Ads.KS.useR and ValidTarget(target, skills.SkillR.range)  then
              if Menu.ProdSettings.SelectProdiction == 2 then 
            RVP()
              elseif Menu.ProdSettings.SelectProdiction == 1 then
                CastR()
                elseif Menu.ProdSettings.SelectProdiction == 3 then
                DevineR()
              
           -- print(rDmgP)
              end
            end
            if target.health <= eDmgP and Eready and Menu.Ads.KS.useE and ValidTarget(target, skills.SkillE.range) then
              if Menu.ProdSettings.SelectProdiction == 2 then
                EVP()
              elseif Menu.ProdSettings.SelectProdiction == 1 then
                CastE()
                elseif Menu.ProdSettings.SelectProdiction == 3 then
                DevineE()
              
              end
            end
            if target.health <= QDmgP and Qready and Menu.Ads.KS.useQ and ValidTarget(target, skills.SkillQ.range) then
              if Menu.ProdSettings.SelectProdiction == 2 then
                QVP()
              elseif Menu.ProdSettings.SelectProdiction == 1 then
                CastQ()
              elseif Menu.ProdSettings.SelectProdiction == 3 then
                DevineQ()
              end
            end
            
            if target.health <= pDmg then
            KSAA()
            end
           
   

          end

end
end
end
end



  

 








function OnWndMsg(Msg, Key)	
	
	if Msg == WM_LBUTTONUP then
    klik = klik + 1
    tijd = GetGameTimer() --tijd = 16:30
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
			if SelectedTarget and target.charName == SelectedTarget.charName then
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


function OnApplyBuff(source, unit, buff)
  if buff and buff.name:find("luxilluminatingfraulein") then
    if unit.type == myHero.type and unit.team ~= myHero.team then
      if unit.charName == myHero.charName then
    Passive = true
    Passivetime = GetGameTimer()
  end
end
end
   if buff and buff.name:find("LuxLightBindingMis") and target ~= nil then
     if unit.type == myHero.type and unit.team ~= myHero.team then
       if unit.charName == target.CharName then
         
    Stun = true
  end
  end
  end
end

function OnRemoveBuff(unit,buff)
  if unit.team ~= myHero.team and unit.type == myHero.type then
  if buff and buff.name:find("luxilluminatingfraulein") then
    Passive = false
    Passivetime = math.huge
  end
  if buff and buff.name:find("LuxLightBindingMis") then
    
    Stun = false
    end
end
end
     
     

  
   function OnProcessSpell(object,spell)
	if object.team ~= myHero.team and not myHero.dead and object.type == myHero.type then -- not (object.name:find("Minion_") or object.name:find("Odin")) then

		local shieldREADY = typeshield ~= nil and myHero:CanUseSpell(spellslot) == READY and leesinW
		--local healREADY = typeheal ~= nil and myHero:CanUseSpell(healslot) == READY and nidaleeE
		--local ultREADY = typeult ~= nil and myHero:CanUseSpell(ultslot) == READY
		--local wallREADY = wallslot ~= nil and myHero:CanUseSpell(wallslot) == READY
		--local sbarrierREADY = sbarrier ~= nil and myHero:CanUseSpell(sbarrier) == READY
	--	local shealREADY = sheal ~= nil and myHero:CanUseSpell(sheal) == READY
	--	local lisslot = GetInventorySlotItem(3190)
	--	local seslot = GetInventorySlotItem(3040)
	--	local FotMslot = GetInventorySlotItem(3401)
		--local lisREADY = lisslot ~= nil and myHero:CanUseSpell(lisslot) == READY
		--local seREADY = seslot ~= nil and myHero:CanUseSpell(seslot) == READY
		--local FotMREADY = FotMslot ~= nil and myHero:CanUseSpell(FotMslot) == READY
		local HitFirst = false
		local shieldtarget,SLastDistance,SLastDmgPercent = nil,nil,nil
    YWall,BShield,SShield,Shield,CC = false,false,false,false,false
		shottype,radius,maxdistance = 0,0,0
		if object.type == "AIHeroClient" then
			spelltype, casttype = getSpellType(object, spell.name)
			if casttype == 4 or casttype == 5 or casttype == 6 then return end
			if spelltype == "BAttack" or spelltype == "CAttack" then
				Shield = true
        --print("dwaas222")
        elseif spell.name:find("SummonerDot") then
				Shield = true
			elseif spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" or spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM" then
				HitFirst = skillShield[object.charName][spelltype]["HitFirst"]
				YWall = skillShield[object.charName][spelltype]["YWall"]
				BShield = skillShield[object.charName][spelltype]["BShield"]
				SShield = skillShield[object.charName][spelltype]["SShield"]
				Shield = skillShield[object.charName][spelltype]["Shield"]
				CC = skillShield[object.charName][spelltype]["CC"]
				shottype = skillData[object.charName][spelltype]["type"]
				radius = skillData[object.charName][spelltype]["radius"]
				maxdistance = skillData[object.charName][spelltype]["maxdistance"]
			end
		else
			Shield = false
		end
		for i=1, heroManager.iCount do
			local allytarget = heroManager:GetHero(i)
			if allytarget.team == myHero.team and not allytarget.dead and allytarget.health > 0 then
				hitchampion = false
				local allyHitBox = allytarget.boundingRadius
				if shottype == 0 then hitchampion = spell.target and spell.target.networkID == allytarget.networkID
				elseif shottype == 1 then hitchampion = checkhitlinepass(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 2 then hitchampion = checkhitlinepoint(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 3 then hitchampion = checkhitaoe(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 4 then hitchampion = checkhitcone(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 5 then hitchampion = checkhitwall(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 6 then hitchampion = checkhitlinepass(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox) or checkhitlinepass(object, Vector(object)*2-spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 7 then hitchampion = checkhitcone(spell.endPos, object, radius, maxdistance, allytarget, allyHitBox)
				end

    if hitchampion then
      --print("dwaas")
					if Wready and Menu.Shield["teammateshield"..i] and ((typeshield<=4 and Shield) or (typeshield==5 and BShield) or (typeshield==6 and SShield)) then
						if (((typeshield==1 or typeshield==2 or typeshield==5) and GetDistance(allytarget)<=range) or allytarget.isMe) then
							local shieldflag, dmgpercent = shieldCheck(object,spell,allytarget,"shields")
							if shieldflag then
								if HitFirst and (SLastDistance == nil or GetDistance(allytarget,object) <= SLastDistance) then
									shieldtarget,SLastDistance = allytarget,GetDistance(allytarget,object)
								elseif not HitFirst and (SLastDmgPercent == nil or dmgpercent >= SLastDmgPercent) then
									shieldtarget,SLastDmgPercent = allytarget,dmgpercent
								end
							end
						end
					end    
		if shieldtarget ~= nil then
			if typeshield==1 or typeshield==5 then CastSpell(spellslot,shieldtarget)
			elseif typeshield==2 or typeshield==4 then CastSpell(spellslot,shieldtarget.x,shieldtarget.z)
			elseif typeshield==3 or typeshield==6 then CastSpell(spellslot) end
		end
	
end
end
end
end
end

function shieldCheck(object,spell,target,typeused)
	local Kiesma
	if typeused == "shields" then Kiesma = Menu -- dit moet gewoon nagekekekn worden puntje.
	local shieldflag = false
	if (not Menu.Shield.skillshots and shottype ~= 0) then return false, 0 end  --- ook dit is een aandacht puntje
	local adamage = object:CalcDamage(target,object.totalDamage)
	local InfinityEdge,onhitdmg,onhittdmg,onhitspelldmg,onhitspelltdmg,muramanadmg,skilldamage,skillTypeDmg = 0,0,0,0,0,0,0,0

	if object.type ~= "AIHeroClient" then
		if spell.name:find("BasicAttack") then skilldamage = adamage
		elseif spell.name:find("CritAttack") then skilldamage = adamage*2 end
	else
		if GetInventoryHaveItem(3186,object) then onhitdmg = getDmg("KITAES",target,object) end
		if GetInventoryHaveItem(3114,object) then onhitdmg = onhitdmg+getDmg("MALADY",target,object) end
		if GetInventoryHaveItem(3091,object) then onhitdmg = onhitdmg+getDmg("WITSEND",target,object) end
		if GetInventoryHaveItem(3057,object) then onhitdmg = onhitdmg+getDmg("SHEEN",target,object) end
		if GetInventoryHaveItem(3078,object) then onhitdmg = onhitdmg+getDmg("TRINITY",target,object) end
		if GetInventoryHaveItem(3100,object) then onhitdmg = onhitdmg+getDmg("LICHBANE",target,object) end
		if GetInventoryHaveItem(3025,object) then onhitdmg = onhitdmg+getDmg("ICEBORN",target,object) end
		if GetInventoryHaveItem(3087,object) then onhitdmg = onhitdmg+getDmg("STATIKK",target,object) end
		if GetInventoryHaveItem(3153,object) then onhitdmg = onhitdmg+getDmg("RUINEDKING",target,object) end
		if GetInventoryHaveItem(3209,object) then onhittdmg = getDmg("SPIRITLIZARD",target,object) end
		if GetInventoryHaveItem(3184,object) then onhittdmg = onhittdmg+80 end
		if GetInventoryHaveItem(3042,object) then muramanadmg = getDmg("MURAMANA",target,object) end
		if spelltype == "BAttack" then
			skilldamage = (adamage+onhitdmg+muramanadmg)*1.07+onhittdmg
		elseif spelltype == "CAttack" then
     -- print("baas")
			if GetInventoryHaveItem(3031,object) then InfinityEdge = .5 end
			skilldamage = (adamage*(2.1+InfinityEdge)+onhitdmg+muramanadmg)*1.07+onhittdmg --fix Lethality
		elseif spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" or spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM" then
			if GetInventoryHaveItem(3151,object) then onhitspelldmg = getDmg("LIANDRYS",target,object) end
			if GetInventoryHaveItem(3188,object) then onhitspelldmg = getDmg("BLACKFIRE",target,object) end
			if GetInventoryHaveItem(3209,object) then onhitspelltdmg = getDmg("SPIRITLIZARD",target,object) end
			muramanadmg = skillShield[object.charName][spelltype]["Muramana"] and muramanadmg or 0
			if casttype == 1 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object,1,spell.level)
			elseif casttype == 2 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object,2,spell.level)
			elseif casttype == 3 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object,3,spell.level)
			end
			if skillTypeDmg == 2 then
				skilldamage = (skilldamage+adamage+onhitspelldmg+onhitdmg+muramanadmg)*1.07+onhittdmg+onhitspelltdmg
			else
				if skilldamage > 0 then skilldamage = (skilldamage+onhitspelldmg+muramanadmg)*1.07+onhitspelltdmg end
			end
     -- print("dwaas")
		elseif spell.name:find("SummonerDot") then
			skilldamage = getDmg("IGNITE",target,object)
		end
	end
	local dmgpercent = skilldamage*100/target.health -- tjaa puntje
	local dmgneeded = dmgpercent >= Menu.Shield.mindmgpercent
	local hpneeded = Menu.Shield.maxhppercent >= (target.health-skilldamage)*100/target.maxHealth
	
	if dmgneeded and hpneeded then
		shieldflag = true
	elseif (typeused == "shields" or typeused == "wall") and ((CC == 2 and Menu.Shield.shieldcc) or (CC == 1 and Menu.Shield.shieldslow)) then
		shieldflag = true
	end
	return shieldflag, dmgpercent
end
end
-- HP
function CastQ()
  --print("castQ")
  
  if target ~= nil then
 -- QPos, QHitChance = HPred:GetPredict("Q", target, myHero)
  local QPos, QHitchance = HPred:GetPredict(Lux_Q, target, myHero)
  --print("CAstQ@")
  if QHitchance >= 1 then
  --print("laastecheck")
    if VIP_USER then
      Packet("S_CAST", {spellId = _Q, toX = QPos.x, toY = QPos.z, fromX = QPos.x, fromY = QPos.z}):send()
    --  print("castQ3")
    else
      CastSpell(_Q, QPos.x, QPos.z)
    end
    
  end
  
end
end
    
    
    function CastE()
  --print("castE")
  if target ~= nil then
    
local EPos, EHitchance = HPred:GetPredict(Lux_E, target, myHero)
 -- EPos, EHitChance = HPred:GetPredict("E", target, myHero)
  
  --print("CAstE@")
  if EHitchance >= 1 then
  --print("laastecheck")
    if VIP_USER then
      Packet("S_CAST", {spellId = _E, toX = EPos.x, toY = EPos.z, fromX = EPos.x, fromY = EPos.z}):send()
    --  print("castE3")
    else
      CastSpell(_E, EPos.x, EPos.z)
    end
    
  end
  
end
end

-- HP
function CastR()

  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
local RPos, RHitchance = HPred:GetPredict(Lux_R, target, myHero)
--print(RHitchance)
  if RHitchance > 0 then
--print("stap1")
    if VIP_USER then
      Packet("S_CAST", {spellId = _R, toX = RPos.x, toY = RPos.z, fromX = RPos.x, fromY = RPos.z}):send()
    --  print("castQ3")
    else
      CastSpell(_R, RPos.x, RPos.z)
  
end
end
    
  end  
  end

  
function caa()
	if MenuZed.orb == 1 then
		if MenuZed.comboConfig.uaa then
			SxOrb:EnableAttacks()
		elseif not MenuZed.comboConfig.uaa then
			SxOrb:DisableAttacks()
		end
	end
end
  
  -- kip
