if myHero.charName ~= "Karma"  or not VIP_USER then return end
local version = 0.3
local AUTOUPDATE = true
local SCRIPT_NAME = "SXKarma"
require 'VPrediction'
--require 'SOW'
require 'Collision'
--require 'Prodiction'
require "SxOrbwalk"
--require 'Prodiction' 0

require 'DivinePred'
require 'HPrediction'


-- Constants --
local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {1,3,2,1,1,4,1,3,1,3,4,3,2,2,2,4,2,3}
local Ranges = { AA = 525 }

-- Insert the good valeu plss
local skills = {
	SkillQ = { ready = true, name = "Inner Flame", range = 1000, delay = 0.5, speed = math.huge, width = 50.0 },
	SkillW = { ready = true, name = "Focused Resolve", range = 675, delay = 0.5, speed = 2000, width = 60 },
	SkillE = { ready = true, name = "Inspire", range = 800, delay = 0.5, speed = math.huge, width = 0 },
	SkillR = { ready = true, name = "Mantra", range = 0, delay = 0.5, speed = 1300, width = 0 },
}



			
      
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
function CheckUpdate()
        local scriptName = "SXKarma"
        local version = 1.3
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXKarma"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXKarma"..scriptName..".lua"
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

function GetCustomTarget()
	ts:update()
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
  if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	return ts.target
end

local typeshield
local spellslot
local range = 0
local shealrange = 300
local lisrange = 600
local FotMrange = 700

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

function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
  -- Update
	initComponents()
  Spell_Q.collisionM['Karma'] = true
  Spell_Q.collisionH['Karma'] = true -- or false (sometimes, it's better to not consider it)
  Spell_Q.delay['Karma'] = 0.5
  Spell_Q.range['Karma'] = 1175
  Spell_Q.speed['Karma'] = math.huge
  Spell_Q.type['Karma'] = "DelayLine" -- (it has tail like comet)
  Spell_Q.width['Karma'] = 180

  
  end

function initComponents()

    -- VPrediction Start
 VP = VPrediction()
 
 DP = DivinePred()
    HPred = HPrediction()
   -- SOW Declare
  -- Orbwalker = SOW(VP)
  -- Target Selector
   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1400)
  
 Menu = scriptConfig("SXKarma", "KarmaMA")

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
  
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "KarmaCombo")
    Menu.KarmaCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.KarmaCombo:addSubMenu("Q Settings", "qSet")
  Menu.KarmaCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.KarmaCombo:addSubMenu("W Settings", "wSet")
  Menu.KarmaCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 Menu.KarmaCombo:addSubMenu("E Settings", "eSet")
  Menu.KarmaCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.KarmaCombo:addSubMenu("R Settings", "rSet")
  Menu.KarmaCombo.rSet:addParam("useR", "Use Smart Ultimate", SCRIPT_PARAM_ONOFF, true)
 
 Menu:addSubMenu("["..myHero.charName.." - Harass]", "Harass")
  Menu.Harass:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
  Menu.Harass:addParam("useQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
    Menu.Harass:addParam("useW", "Use W in Harass", SCRIPT_PARAM_ONOFF, false)
   Menu.Harass:addParam("useE", "Use E in Harass", SCRIPT_PARAM_ONOFF, true)
   Menu.Harass:addParam("useR", "Use R in Harass", SCRIPT_PARAM_ONOFF, true)
    
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
	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 1, {"Devine", "VPrediction", "HP"})
 -- Menu.ProdSettings:addParam("OD", "OnDash", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("AD", "AfterDash", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings:addParam("AI", "AfterImmobile", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("OI", "OnImmobile ", SCRIPT_PARAM_ONOFF, false)
  
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
    
 -- Menu.ProdSettings.OD
 
 

 
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
 Menu.Ads:addParam("Escp", "Escape Key Use whit spacebar", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("KSQ", "Use Q to KS", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("KSRQ", "Use R + Q Combo", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("AUTOQ","OnGapclose Q", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
  Menu.Ads:addSubMenu("VIP", "VIP")
    Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 4)
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
       GenModelPacket("Karma", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end
       for i = 1, heroManager.iCount do
    local hero = heroManager:GetHero(i)
      if hero.team ~= myHero.team then
        
       -- ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
        
      
        
      end
    end
	
  
  
  PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">Karma/font> <font color = \"#FFFFFF\">by</font><font color = \"#FF0066\"> SyraX</font><font color = \"#00FF00\"> V"..version.."</font>")
end

local Mantra = false
local time = math.huge

function OnTick()
	target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  DamageCalculation()
  --print(Mantra)  
  
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
  if time + 8 < GetGameTimer() then
      Mantraa = false
  end
  
	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("Karma", Menu.Ads.VIP.skin1)
		lastSkin = Menu.Ads.VIP.skin1
	end
  
  -- Make a callback which continuesly keeps track of the predicted pos from the callback to see what it does.
  if ValidTarget(target) then
    --ProdQ:GetPredictionCallBack(target, GetQPos)
    
  else
   -- qPos = nil
    
  end
    
    -- Cast our "combo"
   -- if Menu.AhriCombo.eSet.useE or Menu.Harass.useE then
     -- if Menu.ProdSettings.SelectProdiction == 1 then
      --  if ValidTarget(target) then
                  --  ProdQ:GetPredictionCallBack(target, Cast)
                --    ProdE:GetPredictionCallBack(target, Cast)
        --end
    --end
    --end
  -- Enable/Disable certain callbacks when turned on/off by the menu.
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
           
            
          
            
            

        end
    end
    OnDashPos = nil
    AfterDashPos = nil
    AfterImmobilePos = nil
    OnImmobilePos = nil
    
	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
	if Menu.KarmaCombo.combo then
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
  
  if Menu.KarmaCombo.combo and Menu.ProdSettings.SelectProdiction == 3 then
		ComboP()
	end
  if Menu.Harass.harass and Menu.ProdSettings.SelectProdiction == 3 then
		HarrasP()
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



end

	-- Harass --

function Harass()	
	if target ~= nil and ValidTarget(target)  then
    if skills.SkillR.ready and Menu.Harass.useR then
			CastSpell(_R)
      
		end
    if  Menu.ProdSettings.SelectProdiction == 2 then
      if Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
           if HitChance >= 2 and GetDistance(CastPosition) < 1175 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
       -- print("301")
            end
    elseif Menu.ProdSettings.SelectProdiction == 1 and Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
          DevineQ()
  
  end
end
		if Menu.Harass.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready then
			CastSpell(_W, target)
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

function OnGapclose(target)
  if target ~= nil then
    
    local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
          if skills.SkillQ.ready and  HitChance >= 2 and GetDistance(CastPosition) < 350 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
            if skills.SkillW.ready and not Mantra then
              CastSpell(_W, target)
            end
          end
         
            
		
	end
end


-- Dynamic combo

--[[
 function Minion()
   for i, minion in pairs(targetMinions.objects) do
		if minion ~= nil and minion.valid then
      if target ~= nil and target.valid then
         WardPoss = Vector(myHero) + (Vector(minion) - target):normalized() * 350
--]]
function AllInCombo(target, typeCombo)
	if target ~= nil and typeCombo == 0 then
		ItemUsage(target)
		if skills.SkillR.ready and Menu.KarmaCombo.rSet.useR and not Mantra then
			CastSpell(_R)
      
		end
  
		 if Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
	    if  Menu.ProdSettings.SelectProdiction == 2 then
     -- if Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
           if HitChance >= 2 and GetDistance(CastPosition) < 1175 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
       -- print("301")
            end
    elseif Menu.ProdSettings.SelectProdiction == 1 and Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
          DevineQ()

  end
end

        
		
    

		if Menu.KarmaCombo.wSet.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and not Mantra then
		    CastSpell(_W, target)
		end

		
	end
end
  

-- All In Combo --


function LaneClear()
	for i, minion in pairs(targetMinions.objects) do
		if minion ~= nil then
			if Menu.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(minion, skills.SkillQ.range) then
       -- print("kip")
				CastSpell(_Q, minion.x, minion.z)
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
			
			end
		end
	end


-- autoLVL follow by best build i will change every time there somting change

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


-- shortcut to some functions
function KillSteal()
	if Menu.Ads.KS.ignite then
		IgniteKS()
	end
  if Menu.Ads.KS.KSQ then
    GekkeKSQ()
  end
  if Menu.Ads.KS.KSRQ then
    GekkeKSRQ()
  end
  if Menu.Ads.KS.AUTOQ then
    OnGapclose(target)
  end
  if Menu.Ads.Escp then
    ChaceMode()
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

-- heavy ignite standaard shit
-- health check 
function HealthCheck(unit, HealthValue)
	if unit.health > (unit.maxHealth * (HealthValue/100)) then 
		return true
	else
		return false
	end
end


-- Cast items
function ItemUsage(target)

	if dfgReady then CastSpell(dfgSlot, target) end
	if youmuuReady then CastSpell(youmuuSlot, target) end
	if bilgeReady then CastSpell(bilgeSlot, target) end
	if bladeReady then CastSpell(bladeSlot, target) end
	if divineReady then CastSpell(divineSlot, target) end

end

-- Change skin function, made by Shalzuth thx to this guy
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
-- still skin changer
function skinChanged()
	return Menu.Ads.VIP.skin1 ~= lastSkin
end
-- draw my ass
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
-- maybe later i fix kill text its most useless thing in bol i cuz
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
--draw it
function OnDraw()    if not myHero.dead then
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 1, 223, 165)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 , 1, 223, 165)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 , 1, 223, 165)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 1, 223, 165)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 1, 223, 165)) end
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
	end--[[
  for i, minion in pairs(targetMinions.objects) do
		if minion ~= nil and minion.valid and GetDistance(minion, myHero) <= 1175 then
      if target ~= nil and target.valid and GetDistance(target, myHero) <= 1375 then
        if GetDistance(minion, target) <= 200 then

         Vodafone = Vector(minion) + (Vector(target) - Vector(myHero)):normalized() * 200
                --print("wow")
          --DrawCircle(Vodafone.x, Vodafone.y, Vodafone.z, 100, 0x99990f)
          CastSpell(_Q, Vodafone.x, Vodafone.z)
        end
        end
      end
      end--]]
end
if not myHero.dead and target ~= nil and	target.team ~= myHero.team and target.type == myHero.type then 
		--	if Settings.drawing.text then 
				DrawText3D("Focus This Bitch!",target.x-100, target.y-50, target.z, 20, 0xFFFF9900) --0xFF9900
			end
end
-- dynamic ks q


function GekkeKSQ()
  for i, target in ipairs(GetEnemyHeroes()) do
  qDmg = getDmg("Q", target, myHero)
  if ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready and target.health < qDmg then
    if Menu.ProdSettings.SelectProdiction == 2 then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
        if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
				 CastSpell(_Q, CastPosition.x, CastPosition.z)
       end
    elseif Menu.ProdSettings.SelectProdiction == 1 then
      DevineQ()
    elseif Menu.ProdSettings.SelectPordiction == 3 then
    CastQ()
    end
		end
  end
end

--  for a good ks combo


--reowrk it pls
function GekkeKSRQ()
  for i, target in ipairs(GetEnemyHeroes()) do
    
    local ECAST = false
    local RCAST = false
  if ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready and skills.SkillR.ready and skills.SkillE.ready then
    qDmg = getDmg("Q", target, myHero)
    rDmg = getDmg("R", target, myHero)
    gekkeDmg = GetMantraDMG()
    if target.health < rDmg + qDmg + gekkeDmg and not Mantra then 
      CastSpell(_E)
      ECAST = true
      if ECAST then
        CastSpell(_R)
        if Mantraa then
          if Menu.ProdSettings.SelectProdiction == 2 then
         
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
          if HitChance >= 2 and GetDistance(CastPosition) < 1100 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
          end
        elseif Menu.ProdSettings.SelectProdiction == 1 then
        DevineQ()
      elseif Menu.ProdSettings.SelectProdiction == 3 then
        CastQ()
      end
    end
  end
end
end
end
 end    
          

-- need it thaaaa karmaaaa ultiii
function OnApplyBuff(unit, buff)
  if unit == nil or buff == nil or buff.name == nil then return end
    if unit.isMe ~= myHero.team and buff.name == "KarmaMantra" then
      Mantraa = true
    
      local time = GetGameTimer()
    end
  end
  --- just for joke if i don't let it here it will not work
  function OnRemoveBuff(unit, buff)
  if unit == nil or buff == nil or buff.name == nil then return end
    if unit.isMe ~= myHero.team and buff.name == "KarmaMantra"then
       Mantraa = false
    end
end
  
  function DevineQ()
 -- print("johhny")
  if target ~= nil and target.type == myHero.type then
  if Menu.ProdSettings.SelectProdiction == 1 then
			local target = DPTarget(target)
			local KarmaQ = LineSS(skills.SkillQ.speed, skills.SkillQ.range, skills.SkillQ.width, skills.SkillQ.delay, 0)
			local State, Position, perc = DP:predict(target, KarmaQ)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				
      Packet("S_CAST", {spellId = _Q, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end




-- Dahm karma lvl'ulti 4 x

function GetMantraDMG()
        if myHero:GetSpellData(_R).level == 1 then
                return 75
        elseif myHero:GetSpellData(_R).level == 2 then
                return 225
        elseif myHero:GetSpellData(_R).level == 3 then
                return 375
        elseif myHero:GetSpellData(_R).level == 4 then
                return 525
        end
end         
      
      
 -- just simple escape function     
function ChaceMode()
  if skills.SkillE.ready then
    
    CastSpell(_E)
    
  end
end



function ComboP()
  if target ~= nil and typeCombo == 0 then
		ItemUsage(target)
  end
  if Menu.ProdSettings.SelectProdiction == 3 then 
    if skills.SkillR.ready and Menu.KarmaCombo.rSet.useR then
			CastSpell(_R)
      
		end
    if Menu.KarmaCombo.qSet.useQ and skills.SkillQ.ready and ValidTarget(target) then 
         CastQ()
    end
    if Menu.KarmaCombo.wSet.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and not Mantra then
		    CastSpell(_W, target)
    end	
  end
end

function HarrasP()
  if target ~= nil and typeCombo == 0 then
		ItemUsage(target)
  end
  if Menu.ProdSettings.SelectProdiction == 3 then 
    if skills.SkillR.ready and Menu.Harass.useR then
			CastSpell(_R)
      
		end
    if Menu.Harass.useQ and skills.SkillQ.ready and ValidTarget(target) then 
        CastQ()
    end
    
    if Menu.Harass.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and not Mantra then
		    CastSpell(_W, target)
    end	
  end
end

--[[ thx to bol autoshield!--]]


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
			Shield = true
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
    --[[   
    Menu.maxhppercent
    Menu.mindmgpercent
    Menu.mindmg
    Menu.skillshots
    Menu.shieldcc
    Menu.shieldslow--]]
    if hitchampion then
      --print("dwaas")
					if skills.SkillE.ready and Menu.Shield["teammateshield"..i] and ((typeshield<=4 and Shield) or (typeshield==5 and BShield) or (typeshield==6 and SShield)) then
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
    
    

-- for later if the users Cancel RQ
function ShieldMantra()
  if shieldtarget ~= nil and shieldtarget.charName == myHero.charname then
    if myHero.health <= myHero.maxhealth / 100 * 0.2 then 
      return true
    else
      return false
    end
  end
  end
      
    
 function DoubleClick()
 
 end


kijk = 0
tijd = math.huge
click = 0
time = math.huge
function OnWndMsg(Msg, Key)
	
	
	if Msg == WM_LBUTTONUP then
        
      
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
        pis = true
        kut = GetGameTimer()
   
             
          end
			end
		end
  end
  end
      
      end
        
	end

function CastQ()
  --print("castQ")
  if target ~= nil then
  QPos, QHitChance = HPred:GetPredict("Q", target, myHero)
  
  --print("CAstQ@")
  if QHitChance >= 1 then
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
