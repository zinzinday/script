if myHero.charName ~= "Nunu"  or not VIP_USER then return end
local version = 0.4
local AUTOUPDATE = true
local SCRIPT_NAME = "SXNunu"
require 'VPrediction'
--require 'SOW'
require "SxOrbwalk"
-- Constants --
local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {1,3,2,1,3,4,3,3,3,1,4,1,1,2,2,4,2,2}
local Ranges = { AA = 125 }
local skills = {
	SkillQ = { ready = true, name = "Consume", range = 125, delay = 0.25, speed = 1800.0, width = 70.0 },
	SkillW = { ready = true, name = "Blood Boil", range = 700, delay = 0.0, speed = 0.0, width = 0.0 },
	SkillE = { ready = true, name = "Ice Blast", range = 550, delay = 0.25, speed = 1800.0, width = 70.0 },
	SkillR = { ready = true, name = "Absolute Zero", range = 600, delay = 0.1, speed = 7777.0, width = 1300.0 },
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

function CheckUpdate()
        local scriptName = "SXNunu"
        local version = 1.1
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXNunu"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXNunu"..scriptName..".lua"
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
function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
	initComponents()
  HookPackets()
end
function initComponents()
    -- VPrediction Start
 VP = VPrediction()
   -- SOW Declare
   --Orbwalker = SOW(VP)
  -- Target Selector
   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1400)
  
 Menu = scriptConfig("SXNunu", "NunuMA")

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

    end
  
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "NunuCombo")
    Menu.NunuCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.NunuCombo:addSubMenu("Q Settings", "qSet")
  Menu.NunuCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.NunuCombo:addSubMenu("W Settings", "wSet")
  Menu.NunuCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 Menu.NunuCombo:addSubMenu("E Settings", "eSet")
  Menu.NunuCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.NunuCombo.eSet:addParam("Passive", "Only E when passive! and if can kill target", SCRIPT_PARAM_ONOFF, true)

 Menu.NunuCombo:addSubMenu("R Settings", "rSet")
  Menu.NunuCombo.rSet:addParam("useR", "Use Smart Ultimate", SCRIPT_PARAM_ONOFF, true)
  Menu.NunuCombo.rSet:addParam("RMode", "Use Ultimate enemy count:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
  Menu.NunuCombo:addParam("ADC", "Support mode! Pref focus ADC", SCRIPT_PARAM_ONOFF, false)
  
  
 
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
    Menu.Jungleclear:addParam("Smite", "Smite Q", SCRIPT_PARAM_ONOFF, true)
 
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
    Menu.Ads:addParam("safe", " Eat minion if under 80% health", SCRIPT_PARAM_ONOFF, false)
  
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads.KS:addParam("Q", "KS Q", SCRIPT_PARAM_ONOFF, false)
  -- Menu.Ads.KS.Q
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
  Menu.Ads:addSubMenu("VIP", "VIP")
    Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 6)
    
--[[ Menu:addSubMenu("["..myHero.charName.." - Target Selector]", "targetSelector")
 Menu.targetSelector:addTS(ts)
    ts.name = "Focus" --]]
  
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
       GenModelPacket("Nunu", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end
  
 PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">VoliBear</font> <font color = \"#FFFFFF\">by</font><font color = \"#FF0066\"> SyraX</font><font color = \"#00FF00\"> V"..version.."</font>")
end

click = 0
 time = math.huge
 klik = 0
tijd = math.huge
ulti = false
ultitime = math.huge
function OnTick()
	target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  SxOrb:ForceTarget(Target)
  findadc()
 -- print(Passive)
  
 --rint(AreaEnemyCount())
   
  
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
  
   --print()
    
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
    
    if ulti and ultitime + 4 <= GetGameTimer() then
      ulti = false
      ultitime = math.huge
      end

	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("Nunu", Menu.Ads.VIP.skin1)
		lastSkin = Menu.Ads.VIP.skin1
	end

	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
	if Menu.NunuCombo.combo then
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
		
		if Menu.Harass.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready then
			CastSpell(_W, myHero)
		end
		if Menu.Harass.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
			CastSpell(_E, target)
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
     if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
       print("Papi")
        if skills.SkillR.ready and Menu.NunuCombo.rSet.useR and ValidTarget(target, 300) and AreaEnemyCount() >= Menu.NunuCombo.rSet.RMode  then
        CastSpell(_R) 
        end

     
      if Menu.NunuCombo.wSet.useW and not ulti and ValidTarget(target, 300) and skills.SkillW.ready and not ADC then
		    CastSpell(_W)
      end
     if Menu.NunuCombo.eSet.Passive then 
       if Passive then
        if Menu.NunuCombo.eSet.useE and not ulti and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready and not ADC then
		    CastSpell(_E, target)
      end
    end
  elseif not Menu.NunuCombo.eSet.Passive then
       if Menu.NunuCombo.eSet.useE and not ulti and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready and not ADC then
		    CastSpell(_E, target)
      end
      end
   if ADC then
        prefadc()
      end
end
end

end

-- All In Combo --
function safeme()
  for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
  if ValidTarget(targetMinion, skills.SkillQ.range) and skills.SkillQ.ready then
   if myHero.health <= myHero.maxHealth * 0.80 then 
     CastSpell(_Q, targetMinion)
    end
  end
end
end
end
    

function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
			if Menu.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(targetMinion, skills.SkillQ.range) then
				CastSpell(_Q, targetMinion)
			end
			if Menu.Laneclear.useClearW and skills.SkillW.ready and ValidTarget(targetMinion, skills.SkillW.range) then
				CastSpell(_W)
			end
			if Menu.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(targetMinion, skills.SkillE.range) then
				CastSpell(_E, targetMinion)
			end
		end
		
	end
end

function Qdamage()
  if myHero:GetSpellData(_Q).level == 1 then
                return 400
        elseif myHero:GetSpellData(_Q).level == 2 then
                return 550
        elseif myHero:GetSpellData(_Q).level == 3 then
                return 700
        elseif myHero:GetSpellData(_Q).level == 4 then
                return  850
        elseif myHero:GetSpellData(_Q).level == 5 then
                return 1000
        end
      end
      
function SmiteQ()
  ---print(" shiiiiiittt") 
	for p, jungleMinion in pairs(jungleMinions.objects) do
   if jungleMinion ~= nil then
    -- print(" hij vind een minion")
   
    if Menu.Jungleclear.Smite and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) and jungleMinion.health <= Qdamage() then
        CastSpell(_Q, jungleMinion)
      end
    end
  end

end

    
function JungleClear()

	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
      --print(" wel bij jungle clear")
			if Menu.Jungleclear.useClearQ and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) then
				CastSpell(_Q, jungleMinion)
			elseif Menu.Jungleclear.Smite and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) and jungleMinion.health <= qDmg then
        CastSpell(_Q, jungleMinion)
      end
			if Menu.Jungleclear.useClearW and skills.SkillW.ready and ValidTarget(jungleMinion, skills.SkillW.range) then
				CastSpell(_W)
			end
			if Menu.Jungleclear.useClearE and skills.SkillE.ready and ValidTarget(jungleMinion, skills.SkillE.range) then
				CastSpell(_E, jungleMinion)
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
	if Menu.Ads.KS.ignite then
		IgniteKS()
	end
  if Menu.Jungleclear.Smite then 
    SmiteQ()
  end
  if Menu.Ads.KS.Q then
    KS()
  end
  if Menu.Ads.safe then
    safeme()
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
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 125, 125, 125)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 , 125, 125, 125)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 , 125, 125, 125)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 125, 125, 125)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 125, 125, 125)) end
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


-- Block move 


function EHP()
  if target ~= nil and target.team ~= myHero.team then
    local health = target.health
    if target ~= nil then
    return health * (1+Armor()/100)

  end
end

end

  function Armor()
    if target ~= nil and target.team ~= myHero.team then
      return target.armor
    end
  end
    
    function AreaEnemyCount()
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(myHero, enemy) < skills.SkillE.range then
				count = count + 1
			end
		end              
	return count
end

function OnWndMsg(Msg, Key)	
	
	if Msg == WM_LBUTTONUP then
    klik = klik + 1
    tijd = GetGameTimer()
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
function DoubleClick()

 end
 
 function DoubleClick2()
   
    end

function KS()
  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
    for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
    
      
     
      if skills.SkillE.ready and ValidTarget(target, skills.SkillE.range) and target.health < eDmg and Menu.Ads.KS.KS then
          CastSpell(_E, target)
      end
     
      
      end
    end
    end
  end
  

--[[
function OnProcessSpell(unit, spell)
 if unit.name == myHero.name then
   if spell then
     print(spell.name)
    end
  end
  end
--]]
function OnProcessSpell(unit, spell)
 if unit.name == myHero.name then
   if spell.name:find("AbsoluteZero") then
   ulti = true
   ultitime = GetGameTimer()
   
 end
end
end

function OnSendPacket(p)
  if ulti then
  if p.header == 0x00114 or p.header == 0x0114 then p:Block() end
  --print("done")
  -- patch 5.7 p.header == 0x00D2 
end
end



ADC = nil
function findadc()
  if target ~= nil and target.team ~= myHero.team then 
    if ValidTarget(target, 900) and target.type == myHero.type then
      if target.charName == "Ashe" or target.charName == "Corki" or target.charName == "Kalista" or target.charName == "Vayne" or target.charName == "Caitlyn" or target.charName == "Draven" or target.charName == "Lucian" or target.charName == "Ezreal" or target.charName == "MissFortune" or target.charName == "Tristana" or target.charName == "Graves" or target.charName == "Quinn" or target.charName == "Jinx" or target.charName == "Varus" or target.charName == "Twitch" or target.charName == "Sivir" or target.charName == "Twitch" then
        ADC = target
      else
        ADC = nil
  end
end
end
end

function prefadc()
  if Menu.NunuCombo.ADC then
  if ADC ~= nil and ValitTarget(ADC, skills.SkillE.range) and skills.SkillE.ready and not ulti then
    CastSpell(_E, ADC)
  end
  if ADC ~= nil and ValitTarget(ADC, skills.SkillW.range) and skills.SkillE.ready and not ulti then
   CastSpell(_W)
  end
  end
end
Passive = false
function OnApplyBuff(source, unit, buff)
 if unit.team == myHero.team then
 if buff and buff.name == "visionary" then
   Passive = true
 end
 
end
end
function OnRemoveBuff(unit, buff)
  if unit.team == myHero.team then
    if buff and buff.name == "visionary" then
      Passive = false
    end
  end
  end
--[[
function OnUpdateBuff(unit, buff)
if buff then print(buff.name) end
end
--]]
--[[
function OnSendPacket(p)
  if p.header == 0x0114 or p.header == 0x0029 or p.header == 0x0054 then return end
  
  print(string.format('%02X', p.header))
end
--]]
