if myHero.charName ~= "Rengar"then return end
local version = 0.5
local AUTOUPDATE = true
local SCRIPT_NAME = "SXRengar"
require 'VPrediction'
require "SxOrbwalk"
--require 'Prodiction' 
require 'Collision'
require 'DivinePred'
require 'HPrediction'

function CheckUpdate()
        local scriptName = "SXRengar"
        local version = 1.2
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXRengar"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXRengar"..scriptName..".lua"
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
local Ranges = { AA = 125 }
local skills = {
	SkillQ = { ready = true, name = "Savagery	", range = 300, delay = 0, speed = 0, width = 0 },
	SkillW = { ready = true, name = "Battle Roar", range = 500, delay = 0, speed = 0, width = 0 },
	SkillE = { ready = true, name = "Bola Strike", range = 1000, delay = 0.250, speed = 1300, width = 0 },
	SkillR = { ready = true, name = "Thrill of the Hunt", range = 2000, delay = 0, speed = 0, width = 0 },
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
  Rengar_E  = HPSkillshot({type = "PromptCircle", delay = 0.25, range = 1000, speed = 1300, width = 40, radius = 28})
end
function initComponents()

    -- VPrediction Start
 VP = VPrediction()
 -- DP = DivinePred()
    HPred = HPrediction()
   -- SOW Declare
  -- Orbwalker = SOW(VP)
  -- Target Selector
   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 4000)
  
 Menu = scriptConfig("SXRengar by SyraX", "RengarMA")

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
  
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "RengarCombo")
    Menu.RengarCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.RengarCombo:addSubMenu("Q Settings", "qSet")
    
  Menu.RengarCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.RengarCombo.qSet:addParam("Bush", " if you are in bush use Q when target close", SCRIPT_PARAM_ONOFF, true)
 
 Menu.RengarCombo:addSubMenu("W Settings", "wSet")
  Menu.RengarCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 Menu.RengarCombo:addSubMenu("E Settings", "eSet")
  Menu.RengarCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.RengarCombo:addSubMenu("R Settings", "rSet")
  Menu.RengarCombo.rSet:addParam("useR", "On Double click target", SCRIPT_PARAM_ONOFF, true)
  
 
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
	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 1, {"HProdiction", "VPrediction"})
 -- Menu.ProdSettings:addParam("OD", "OnDash", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("AD", "AfterDash", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings:addParam("AI", "AfterImmobile", SCRIPT_PARAM_ONOFF, false)
  --Menu.ProdSettings:addParam("OI", "OnImmobile ", SCRIPT_PARAM_ONOFF, false)
 -- Menu.ProdSettings.OD
 
 Menu:addSubMenu("[" .. myHero.charName.." - Passive Priority]", "Passive") 
 Menu.Passive:addParam("SelectPassive", "Choose your passive priority", SCRIPT_PARAM_LIST, 1, {"Q Priority", "W Priority", "E Priotity"})--Menu.Passive.SelectPassive == 1
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
  Menu.Ads.KS:addParam("KSE", "Killsteal with E", SCRIPT_PARAM_ONOFF, false) --Menu.Ads.KS.KSE
  Menu.Ads.KS:addParam("autoQ", "OnGapClose", SCRIPT_PARAM_ONOFF, false) -- Menu.Ads.KS.autoQ
  Menu.Ads.KS:addParam("KSWE", "Killsteal with W and Q", SCRIPT_PARAM_ONOFF, false)--Menu.Ads.KS.KSWE
  Menu.Ads:addSubMenu("VIP", "VIP")
    Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 5)
 
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
       GenModelPacket("Rengar", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end
  
 PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">Rengar</font> <font color = \"#FFA319\">by SyraX V"..version.."</font>")
end

function OnTick()
	target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
 --print(Qbush)
  if  Menu.RengarCombo.qSet.Bush and Qbush then
   
    if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
       --print("OLA")
      if ValidTarget(target, 725) and skills.SkillQ.ready then
        CastSpell(_Q, myHero)
      end
    end
    end
  --print(ult)
 -- print(click)
--print(ult)
  --print(Passive)
  
 
  
  if Menu.Ads.KS.KSWE then
    KSWQ()
    end
  if Menu.Ads.VIP.skin and VIP_USER then
       GenModelPacket("lux", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end

 

	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("Rengar", Menu.Ads.VIP.skin1)
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
	
	if Menu.RengarCombo.combo then
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

function Harass()	
	if target ~= nil and ValidTarget(target) then
		


		if Menu.Harass.useE and Menu.ProdSettings.SelectProdiction == 1 then
        if ValidTarget(target, skills.SkillE.range) then
                    CastE()
                  --  print("295")
        end
    elseif  Menu.ProdSettings.SelectProdiction == 2 then
      if Menu.Harass.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.range then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, true)
            if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
       -- 
       ("301")
            end
    end
    end
	
  
  if Menu.Harass.useQ  and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
			CastSpell(_Q, myHero)
		end

		if Menu.Harass.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready then
		    CastSpell(_W, myHero)
		end
end  
	
end
-- End Harass --


-- Combo Selector --

function Combo()
	local typeCombo = 0
  if Passive and target ~= nil and not ult  then
    PassivePriority()
  end
	if target ~= nil and not Passive and not ult then
		AllInCombo(target, 0)
	end
  if ult and Passive and target ~= nil then
    UltiMateCombo()
  end
  if ult and not Passive then
    if target ~= nil and target.type == myHero.type and target.team == myHero.team then
      if Menu.Passive.SelectPassive == 1 then 
        if ValidTarget(target, 1100) then
            CastSpell(_Q, myHero)
        end
      end
    end
  end
  
  
end
  
	
-- Combo Selector --

-- All In Combo -- 

function UltiMateCombo()
  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
    --print("Ulti Passive Combo")
    if Passive and ult then
      if ValidTarget(target, 1100) then
        CastSpell(_Q, myHero)
      --  Combo()
      end
    end
  end
  end
          
      

function AllInCombo(target, typeCombo)
	if target ~= nil and typeCombo == 0 and not Passive and target.type == myHero.type and target.team ~= myHero.team then
		ItemUsage(target)
		

		if Menu.RengarCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
			CastSpell(_Q, myHero)
		end

		if Menu.RengarCombo.wSet.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and not ult then
		    CastSpell(_W, myHero)
		end

		if  Menu.RengarCombo.eSet.useE and Menu.ProdSettings.SelectProdiction == 1 and not ult then
        if ValidTarget(target, skills.SkillE.range) then
                    CastE()
                    --print("fail ulti")
        end
    elseif  Menu.ProdSettings.SelectProdiction == 2 and not ult then
      if Menu.RengarCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.range and not ult then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, true)
            if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
       -- print("356")
            end
    end
    end
	end
end

-- All In Combo --


function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
			if Menu.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(targetMinion, skills.SkillQ.range) then
				CastSpell(_Q, myHero)
			end
			if Menu.Laneclear.useClearW and skills.SkillW.ready and ValidTarget(targetMinion, skills.SkillW.range) then
				CastSpell(_W, myHero)
			end
			if Menu.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(targetMinion, skills.SkillE.range) then
				CastSpell(_E, targetMinion.x, targetMinion.z)
			end
		end
		
	end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil and not passive then
			if Menu.Jungleclear.useClearQ and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) then
				CastSpell(_Q, myHero)
			end
			if Menu.Jungleclear.useClearW and skills.SkillW.ready and ValidTarget(jungleMinion, skills.SkillW.range) then
				CastSpell(_W, myHero)
			end
			if Menu.Jungleclear.useClearE and skills.SkillE.ready and ValidTarget(jungleMinion, skills.SkillE.range) then
				CastSpell(_E, jungleMinion.x, jungleMinion.z)
       -- print("391")
			end
		elseif jungleMinion ~= nil and passive then
      local Penis = myHero.maxHealth / 100
      local kutje = Penis * 45
      if myHero.health <= kutje then
        if skills.SkillW.ready then
          CastSpell(_W, myHero)
        end
      end
      if myHero.health > kutje then 
        CastSpell(_Q, myHero)
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
  
  if Menu.Ads.KS.KSE and not Passive then
    hardeKSE()
  elseif Menu.Ads.KS.KSE and Passive then
    hardeKSEPassive()
  end
  if Menu.Ads.KS.autoQ then
    OnGapclose(target)
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

function KSWQ()
for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      wDmg = getDmg("W", enemy,myHero)
      if skills.SkillQ.ready and target.health <= qDmg and ValidTarget(target, 150) then
          CastSpell(_Q, myHero)
          CastSpell(_Q, myHero)
        end
      if skills.SkillW.ready and target.health <= wDmg and ValidTarget(target, skills.SkillW.range) then
        CastSpell(_W, myHero)
        CastSpell(_W, myHero)
      end
      if skills.SkillQ.ready and skills.SkillW.ready and ValidTarget(target, skills.SkillW.range) and target.health <= qDmg + wDmg then
        CastSpell(_W, myHero)
        CastSpell(_Q, myHero)
      end
    end
  end
end

  
    
     
      
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
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 125, 125, 125)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 , 225, 00, 00)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 , 225, 00, 00)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 225, 00, 00)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 225, 00, 00)) end
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
    --DamageQ() DamageE() target.health Armor()
function DamageQ()
  if level() == 1 then
    return 30
  elseif level() == 2 then
    return 45
     elseif level() == 3 then
    return 60
     elseif level() == 4 then
    return 75
    elseif level() == 5 then
    return 90
     elseif level() == 6 then
    return 105
     elseif level() == 7 then
    return 120
     elseif level() == 8 then
    return 135
     elseif level() == 9 then
    return 150
     elseif level() == 10 then
    return 160
     elseif level() == 11 then
    return 170
     elseif level() == 12 then
    return 180
     elseif level() == 13 then
    return 190
     elseif level() == 14 then
    return 200
     elseif level() == 15 then
    return 210
     elseif level() == 16 then
    return 220
     elseif level() == 17 then
    return 240
     elseif level() == 18 then
    return 250
    
  end
end

function DamageE()
  if level() == 1 then
    return 50
  elseif level() == 2 then
    return 75
     elseif level() == 3 then
    return 100
     elseif level() == 4 then
    return 125
    elseif level() == 5 then
    return 150
     elseif level() == 6 then
    return 175
     elseif level() == 7 then
    return 200
     elseif level() == 8 then
    return 225
     elseif level() == 9 then
    return 250
     elseif level() == 10 then
    return 260
     elseif level() == 11 then
    return 270
     elseif level() == 12 then
    return 280
     elseif level() == 13 then
    return 290
     elseif level() == 14 then
    return 300
     elseif level() == 15 then
    return 310
     elseif level() == 16 then
    return 320
     elseif level() == 17 then
    return 330
     elseif level() == 18 then
    return 340
    
  end
end--[[
  function Armor()
    if target ~= nil and target.team ~= myHero.team then
      return target.armor
    end
  end
  
    
function target.health
  if target ~= nil and target.team ~= myHero.team then
    local health = target.health
    if target ~= nil then
    return health * (1+Armor()/100)

  end
end

  end
    
  --]]
  
  
 function hardeKSE()
  if not passive and target ~= nil and target.type == myHero.type then
  for i, target in ipairs(GetEnemyHeroes()) do
    eDmg = getDmg("E", target, myHero)
    if skills.SkillE.ready and target ~= nil and ValidTarget(target, skills.SkillE.range) and target.health < eDmg then
      if Menu.ProdSettings.SelectProdiction == 2 then
        --print("niet") 
        if Menu.RengarCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
        local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, true)
          if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
              CastSpell(_E, CastPosition.x, CastPosition.z)
             -- print("726")
          end
        end
      elseif Menu.ProdSettings.SelectProdiction == 1 then
        --print("ewl") 
        CastE()
       -- print("734")
      end
      
end
end
end 
end


function hardeKSEPassive()
  if Passive and target ~= nil and target.type == myHero.type then
    
    if skills.SkillE.ready and target ~= nil and ValidTarget(target, skills.SkillE.range) and target.health < DamageE() then
      if Menu.ProdSettings.SelectProdiction == 2 then
        --print("niet") 
        if Menu.RengarCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillQ.ready then
        local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, true)
          if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
              CastSpell(_E, CastPosition.x, CastPosition.z)
              --print("750")
          end
        end
      elseif Menu.ProdSettings.SelectProdiction == 1 then
        --print("ewl") 
        CastE()
       -- print("759")
      end
      
end
end
end 

function Damage()
  if unit.isMe then
    return myHero.totalDamage
  end
  end
function CastE(unit,pos)
    if target ~= nil and not ult then 
      if GetDistance(pos) < skills.SkillE.range and skills.SkillE.ready then
         local coll = Collision(1000, 1175, 0.25, 60)
            if not coll:GetMinionCollision(pos, myHero) then
   
                CastSpell(_E, pos.x, pos.z)
              --  print("774")
            end
    end
  end
  end
function GetEPos(unit, pos)
        ePos = pos
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
function DoubleClick()
  print("Ulti Activated! gl!")
    if Menu.RengarCombo.rSet.useR and not ult then
      CastSpell(_R, myHero)
      end
    
end
    

--[[function RealDamage()

damagereceived = (damage)*100/(100+armor()) 
end --]]
ult = false
Passive = false
function OnCreateObj(object)
  if object ~= nil then  
  if object.name:find("Rengar_Base_R_Cas.troy") then
    ult = true
  end
  if object.name:find("Rengar_Base_P_Buf_Max.troy") then
  Passive = true
  end
end

end
--Rengar_Base_P_Buf_Max.troy passive delete ook create

--Rengar_Base_R_Buf.troy ulti delete

--Rengar_Base_R_Cas.troy
function OnDeleteObj(object)
  if object ~= nil then
  --print(object.name)
  if object.name:find("Rengar_Base_R_Buf.troy") then
    ult = false
  end
  if object.name:find("Rengar_Base_P_Buf_Max.troy") then
  Passive = false
  end
end
end
function PassivePriority()
  if target ~= nil and Passive then
    
    if Menu.Passive.SelectPassive == 3 then
        if Menu.ProdSettings.SelectProdiction == 1 then
          if Menu.RengarCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
            CastE()
            CastE()
            CastE()
            CastE()
          --  print("862")
          end
        elseif Menu.ProdSettings.SelectProdiction == 2 then
        if Menu.RengarCombo.eSet.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillE.delay, skills.SkillE.width, skills.SkillE.range, skills.SkillE.speed, myHero, true)
          if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
        CastSpell(_E, CastPosition.x, CastPosition.z)
        
      --  print("865")
          end
        end
      end
    elseif Menu.Passive.SelectPassive == 2 then
        if Menu.RengarCombo.wSet.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready then
         CastSpell(_W, myHero)
         CastSpell(_W, myhero)
      
        end
    elseif Menu.Passive.SelectPassive == 1 then
       if Menu.RengarCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
         CastSpell(_Q, myHero)
         CastSpell(_Q, myHero)
         CastSpell(_Q, myHero)
         CastSpell(_Q, myHero)
        end
    end
    
      
       
      
      
end

end

function OnGapClose(target)
  if target ~= nil then
    
    local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
          if skills.SkillQ.ready and  Menu.Ads.KS.autoQ and  HitChance >= 2 and GetDistance(CastPosition) < 300 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
          end
         
            
		
	end
end

function CastE()
  --print("castQ")
  
  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
 -- QPos, QHitChance = HPred:GetPredict("Q", target, myHero)
  local EPos, EHitchance = HPred:GetPredict(Rengar_E, target, myHero)
  --print(QHitchance)
  --print("CAstQ@")
 -- print(QHitchance)
  if EHitchance >= 1 then
    --print("short")
  --print("laastecheck")
    if VIP_USER then
      Packet("S_CAST", {spellId = _E, toX = EPos.x, toY = EPos.z, fromX = EPos.x, fromY = EPos.z}):send()
    --  print("castQ3")
    else
      CastSpell(_E, EPos.x, EPos.z)
    end
  end
end
end
Qbush = false
function OnApplyBuff(source, unit, buff)
  if unit.isMe and buff then 
    if buff.name == "rengarbushspeedbonus" then
      Qbush = true
        end
    
  end
  
  
end

function OnRemoveBuff(unit, buff)
  if unit.isMe and buff then
    if buff.name == "rengarbushspeedbonus" then
      Qbush = false
    end
  end
end



