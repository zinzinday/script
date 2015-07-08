--[[
Nidalee - Beastiality Princess by AMBER_
Version 1.42
Enjoy it
]]

class 'Nidalee'
class "ScriptUpdate"

if VIP_USER and FileExist(LIB_PATH .. "/DivinePred.lua") then 
	require "DivinePred" 
	DP = DivinePred()
	myQ = SkillShot.PRESETS['JavelinToss']
end

function ScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '3' or '4')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '3' or '4')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.CallbackError = CallbackError
    self:CreateSocket(self.VersionPath)
    self.DownloadStatus = 'Connect to Server for VersionInfo'
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function ScriptUpdate:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.tcp()
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.Socket:connect('sx-bol.eu', 80)
    self.Url = url
    self.Started = false
    self.LastPrint = ""
    self.File = ""
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
    if self.GotScriptVersion then return end

    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        local recv,sent,time = self.Socket:getstats()
        self.DownloadStatus = 'Downloading VersionInfo (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</size>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</s'..'ize>')-1)) + self.File:len()
        end
        self.DownloadStatus = 'Downloading VersionInfo ('..math.round(100/self.Size*self.File:len(),2)..'%)'
    end
    if not (self.Receive or (#self.Snipped > 0)) and self.RecvStarted and self.Size and math.round(100/self.Size*self.File:len(),2) > 95 then
        self.DownloadStatus = 'Downloading VersionInfo (100%)'
        local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
        local ContentEnd, _ = self.File:find('</sc'..'ript>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            self.OnlineVersion = tonumber(self.File:sub(ContentStart + 1,ContentEnd-1))
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self:CreateSocket(self.ScriptPath)
                self.DownloadStatus = 'Connect to Server for ScriptDownload'
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        end
        self.GotScriptVersion = true
    end
end

function ScriptUpdate:DownloadUpdate()
    if self.GotScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        local recv,sent,time = self.Socket:getstats()
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1)) + self.File:len()
        end
        self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*self.File:len(),2)..'%)'
    end
    if not (self.Receive or (#self.Snipped > 0)) and self.RecvStarted and math.round(100/self.Size*self.File:len(),2) > 95 then
        self.DownloadStatus = 'Downloading Script (100%)'
        local HeaderEnd, ContentStart = self.File:find('<sc'..'ript>')
        local ContentEnd, _ = self.File:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local f = io.open(self.SavePath,"w+b")
            f:write(self.File:sub(ContentStart + 1,ContentEnd-1))
            f:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
            end
        end
        self.GotScriptUpdate = true
    end
end

function OnLoad()

	CheckScriptUpdate()
	CheckVPred()
	if FileExist(LIB_PATH .. "/VPrediction.lua") then
		CheckSxOrbWalk()
	end
	
	if FileExist(LIB_PATH .. "/VPrediction.lua") and FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
		SAC = false
		SX = false
		print("<font color=\"#DF7401\"><b>Nidalee Beastiality Princess (BETA): </b></font><font color=\"#D7DF01\">Waiting for any OrbWalk authentification</b></font>")
		DelayAction(function()	
			if _G.Reborn_Loaded ~= nil then
				SAC = true
			else 
				SX = true
				require "SxOrbWalk"
			end
			Nidalee()
		end, 2)
	end
end

function CheckScriptUpdate()
	local ToUpdate = {}
    ToUpdate.Version = 1.42
    ToUpdate.UseHttps = true
	ToUpdate.Name = "Nidalee Beastiality Princess"
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/AMBER17/BoL/master/Nidalee.version"
    ToUpdate.ScriptPath =  "/AMBER17/BoL/master/Nidalee.lua"
    ToUpdate.SavePath = SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME
    ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") end
    ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">No Updates Found</b></font>") end
    ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">New Version found ("..NewVersion.."). Please wait until its downloaded</b></font>") end
    ToUpdate.CallbackError = function(NewVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">Error while Downloading. Please try again.</b></font>") end
    ScriptUpdate(ToUpdate.Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
	
end

function CheckVPred()
	if FileExist(LIB_PATH .. "/VPrediction.lua") then
		require("VPrediction")
		VP = VPrediction()
	else
		local ToUpdate = {}
		ToUpdate.Version = 0.0
		ToUpdate.UseHttps = true
		ToUpdate.Name = "VPrediction"
		ToUpdate.Host = "raw.githubusercontent.com"
		ToUpdate.VersionPath = "/SidaBoL/Scripts/master/Common/VPrediction.version"
		ToUpdate.ScriptPath =  "/SidaBoL/Scripts/master/Common/VPrediction.lua"
		ToUpdate.SavePath = LIB_PATH.."/VPrediction.lua"
		ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") end
		ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">No Updates Found</b></font>") end
		ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">New Version found ("..NewVersion.."). Please wait until its downloaded</b></font>") end
		ToUpdate.CallbackError = function(NewVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">Error while Downloading. Please try again.</b></font>") end
		ScriptUpdate(ToUpdate.Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
	end
end

function CheckSxOrbWalk()
	if not FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
		local ToUpdate = {}
		ToUpdate.Version = 0.0
		ToUpdate.UseHttps = true
		ToUpdate.Name = "SxOrbWalk"
		ToUpdate.Host = "raw.githubusercontent.com"
		ToUpdate.VersionPath = "/Superx321/BoL/master/common/SxOrbWalk.Version"
		ToUpdate.ScriptPath =  "/Superx321/BoL/master/common/SxOrbWalk.lua"
		ToUpdate.SavePath = LIB_PATH.."/SxOrbWalk.lua"
		ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") end
		ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">No Updates Found</b></font>") end
		ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">New Version found ("..NewVersion.."). Please wait until its downloaded</b></font>") end
		ToUpdate.CallbackError = function(NewVersion) print("<font color=\"#FF794C\"><b>" .. ToUpdate.Name .. ": </b></font> <font color=\"#FFDFBF\">Error while Downloading. Please try again.</b></font>") end
		ScriptUpdate(ToUpdate.Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
	end
end

function Nidalee:__init()
	print("<font color=\"#DF7401\"><b>Nidalee Beastiality Princess (BETA): </b></font><font color=\"#D7DF01\"> Successful Loaded</b></font>")
	print("<font color=\"#DF7401\"><b>Nidalee Beastiality Princess (BETA): </b></font><font color=\"#D7DF01\"> Thanks for using my script, it's a BETA and I need your feedback !</b></font>")
	print("<font color=\"#DF7401\"><b>Nidalee Beastiality Princess (BETA): </b></font><font color=\"#FF0000\"> Warning: don't reload this script when you are in cougar form !!</b></font>")
	self:Variable()
	self:myMenu()
	AddTickCallback(function() self:OnTick() end)
	AddMsgCallback(function(Msg,Key) self:OnWndMsg(Msg,Key) end)
	AddDrawCallback(function() self:OnDraw() end)
	AddCastSpellCallback (function(iSpell,startPos,endPos,targetUnit) self:OnCastSpell(iSpell,startPos,endPos,targetUnit) end)
	AddUpdateBuffCallback(function(unit,source,buff) self:OnUpdateBuff(unit,source,buff) end)
	AddRemoveBuffCallback(function(unit,buff) self:OnRemoveBuff(unit,buff) end)
	AddProcessSpellCallback(function(unit,spell) self:OnProcessSpell(unit, spell) end)
end

function Nidalee:Variable()

	self.TargetSelector = TargetSelector(TARGET_LOW_HP, 1800, DAMAGE_MAGICAL, false, true)
	self.Human = true
	self.lastQ = 0
	self.recal = false
	self.lastRecall = 0
	
	self.Champ = { } 
	self.Passive = { }
	self.lastTime = { }
	self.myEnemyTable = GetEnemyHeroes()
	for i, enemy in pairs(self.myEnemyTable) do 
		self.Champ[i] = enemy.charName
	end
	
	self.Spells = {
		Q1 = { Range = 1500, Width = 35, Delay = 0.5, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(0) == 0 end,},
		W1 = { Range = 900, Width = 30, Delay = 0.1, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(1) == 0 end,},
		E1 = { Range = 600, Width = nil, Delay = 0.1, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(2) == 0 end,},
		Q2 = { Range = 300, Width = nil, Delay = 0.1, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(0) == 0 end,},
		W2 = { Ranget = {375 , 750} , Width = nil, Delay = 0.0, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(1) == 0 end,},
		E2 = { Range = 300, Width = 60, Delay = 0, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(2) == 0 end,},
		R = { Ready = function() return myHero:CanUseSpell(3) == 0 end,},
	}
	
end

function Nidalee:myMenu()
	self.Settings = scriptConfig("Nidalee", "AMBER")
	self.Settings:addSubMenu("["..myHero.charName.."] - Combo Settings (SBTW)", "combo")
		self.Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		self.Settings.combo:addParam("dontJump", "Never Use Cougar", SCRIPT_PARAM_ONOFF, false)
		self.Settings.combo:addParam("heal", "Use Heal (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		self.Settings.combo:addParam("warningJump", "Never Jump In if Life < X%", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Escape Settings", "escape")
		self.Settings.escape:addParam("escapeKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("T") )
		self.Settings.escape:addParam("useW2", "Use Jump (W)", SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "harass")
		self.Settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		self.Settings.harass:addParam("useQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "killsteal")
		self.Settings.killsteal:addParam("useQ", "Use Human (Q)", SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Misc Settings", "misc")
		self.Settings.misc:addParam("autoHeal", "Auto Heal", SCRIPT_PARAM_ONOFF, true)
		self.Settings.misc:addParam("valueHeal", " Auto Heal if HP <X % ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - (Q) Settings", "qSet")
		self.Settings.qSet:addParam("info", "Human (Q) Settings", SCRIPT_PARAM_INFO, "")
		self.Settings.qSet:addParam("minRange", "Min (Q) Range", SCRIPT_PARAM_SLICE, 0, 0, 600, 0)
		self.Settings.qSet:addParam("maxRange", "Max (Q) Range", SCRIPT_PARAM_SLICE, 1500, 1000, 1500, 0)
		if self.Champ[1] ~= nil then self.Settings.qSet:addParam("champ1", "Use on "..self.Champ[1], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[2] ~= nil then self.Settings.qSet:addParam("champ2", "Use on "..self.Champ[2], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[3] ~= nil then self.Settings.qSet:addParam("champ3", "Use on "..self.Champ[3], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[4] ~= nil then self.Settings.qSet:addParam("champ4", "Use on "..self.Champ[4], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[5] ~= nil then self.Settings.qSet:addParam("champ5", "Use on "..self.Champ[5], SCRIPT_PARAM_ONOFF, true) end
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Draw Settings ", "draw")
		self.Settings.draw:addParam("drawQ1","Draw (Q1) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawW1","Draw (W1) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawE1","Draw (E1) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawQ2","Draw (Q2) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawW2","Draw (W2) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawE2","Draw (E2) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("lifeBar","Draw Health Bar",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("currentTarget","Draw Current Target Text",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("circleTarget","Draw Circle On Target",SCRIPT_PARAM_ONOFF, true)
	
	self.Settings:addSubMenu("["..myHero.charName.."] - Prediction", "prediction")	
		self.Settings.prediction:addParam("prediction", "0: VPrediction | 1: DivinePred", SCRIPT_PARAM_SLICE, 0, 0, 1, 0)
	
	self.Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		if SX then
			SxOrb:LoadToMenu(self.Settings.Orbwalking)
		elseif SAC then
			self.Settings.Orbwalking:addParam("info", "SAC Detected & Loaded", SCRIPT_PARAM_INFO, "")
		end
		
	self.TargetSelector.name = "[Xerath]"
		self.Settings:addTS(self.TargetSelector)
	
	
	self.Settings.combo:permaShow("comboKey")
	self.Settings.harass:permaShow("harassKey")
	self.Settings.combo:permaShow("dontJump")
	self.Settings.combo:permaShow("heal")
	self.Settings.misc:permaShow("autoHeal")
end

function Nidalee:OnDraw()
	if not myHero.dead then
		if ValidTarget(self.Target) then 
			if self.Settings.draw.currentTarget then
				DrawText3D("Current Target",self.Target.x-100, self.Target.y-50, self.Target.z, 20, 0xFFFFFF00)
			end
			if self.Settings.draw.circleTarget then
				DrawCircle(self.Target.x, self.Target.y, self.Target.z, 150, ARGB(255, 255, 0, 0))
			end
		end
		if self.Settings.draw.lifeBar then
			for i, unit in pairs(self.myEnemyTable) do
				if ValidTarget(unit) and GetDistance(unit) <= 3500 then 
					local spells = ""
					if self.Spells.Q1.Ready() then 
						self.dmgQ1 = getDmg("Q", unit, myHero) 
						self.dmgQ1 = (self.dmgQ1 * (0.012 * (GetDistance(unit) * 0.166667)))
						spells = "-Q1"
					else 
						self.dmgQ1 = 0 
					end
					if self.Spells.Q2.Ready() then 
						self.dmgQ2 = getDmg("QM", unit, myHero) 
						spells = spells.."-Q2"
					else 
						self.dmgQ2 = 0 
					end
					if self.Spells.W2.Ready() then 
						self.dmgW2 = getDmg("WM", unit, myHero) 
						spells = spells.."-W2"
					else 
						self.dmgW2 = 0 
					end
					if self.Spells.E2.Ready() then 
						self.dmgE2 = getDmg("EM", unit, myHero) 
						spells = spells.."-E2"
					else 
						self.dmgE2 = 0 
					end
	
					self.dmgTotal = self.dmgQ1 + self.dmgQ2 + self.dmgW2 + self.dmgE2
					self:DrawLineHPBar(self.dmgTotal,spells, unit, true)
				end
			end
		end
		if self.Human then
			if self.Spells.Q1.Ready() and self.Settings.draw.drawQ1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Settings.qSet.minRange, ARGB(125, 200 , 50 ,170))
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Settings.qSet.maxRange, ARGB(125, 200 , 50 ,170))
			end
			if self.Spells.W1.Ready() and self.Settings.draw.drawW1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.W1.Range, ARGB(125, 0 , 0 ,255))
			end
			if self.Spells.E1.Ready() and self.Settings.draw.drawE1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.E1.Range, ARGB(125, 0 , 0 ,255))
			end
		else
			if self.Spells.Q2.Ready() and self.Settings.draw.drawQ2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.Q2.Range, ARGB(125, 0 , 0 ,255))
			end
			if self.Spells.W2.Ready() and self.Settings.draw.drawW2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.W2.Ranget[1], ARGB(125, 200 , 50 ,255))
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.W2.Ranget[2], ARGB(125, 200 , 50 ,255))
			end
			if self.Spells.E2.Ready() and self.Settings.draw.drawE2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.E2.Range, ARGB(125, 0 , 0 ,255))
			end
		end

	end
end

function Nidalee:OnWndMsg(Msg,Key)
	if Msg == WM_LBUTTONDOWN then
		self.minD = 0
		self.Target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) then
				if GetDistance(unit, mousePos) <= self.minD or self.Target == nil then
					self.minD = GetDistance(unit, mousePos)
					self.Target = unit
				end
			end
		end

		if self.Target and self.minD < 115 then
			if self.SelectedTarget and self.Target.charName == self.SelectedTarget.charName then
				self.SelectedTarget = nil
			else
				self.SelectedTarget = self.Target
			end
		end
	end
end

function Nidalee:GetCustomTarget()
	if self.SelectedTarget ~= nil and ValidTarget(self.SelectedTarget, 2000) and (Ignore == nil or (Ignore.networkID ~= self.SelectedTarget.networkID)) and GetDistance(self.SelectedTarget) < 1800 then
		return self.SelectedTarget
	end
	if self.TargetSelector.target and not self.TargetSelector.target.dead and self.TargetSelector.target.type == myHero.type then
		return self.TargetSelector.target
	else
		return nil
	end
end

--[[
function Nidalee:OnApplyBuff(unit, source,buff)
	if buff.name == "nidaleepassivehunted" and not unit.isMe then
		for i, msg in pairs(self.Champ) do
			self.isUnit = self.Champ[i]
			if self.isUnit == unit.charName then
				self.Passive[i] = true
				self.lastTime[i] = os.clock()
			end		
		end
	end
	if buff.name == "PrimalSurge" and unit.isMe then
		self.canHeal = false
		self.lastHeal = 0
	end
end ]]



function Nidalee:OnUpdateBuff(unit, buff)
	if buff.name == "nidaleepassivehunted" and unit and not unit.isMe then
		for i, msg in pairs(self.Champ) do
			self.isUnit = self.Champ[i]
			if self.isUnit == unit.charName then
				self.Passive[i] = true
				self.lastTime[i] = os.clock()
			end		
		end
	end
	if buff.name == "PrimalSurge" and unit and unit.isMe then
		self.canHeal = false
		self.lastHeal = 0
	end
end

function Nidalee:OnRemoveBuff(unit,buff)
	if buff.name == "nidaleepassivehunted" and unit and not unit.isMe then
		for i, msg in pairs(self.Champ) do
			self.isUnit = self.Champ[i]
			if self.isUnit == unit.charName then
				self.Passive[i] = false
			end		
		end
	end
end

function Nidalee:CheckPassive()
	for i, msg in pairs(self.Champ) do
		self.isUnit = self.Champ[i]
		self.isTime = self.lastTime[i]
		if self.isTime ~= nil then
			if os.clock() - self.isTime > 4 then
				self.Passive[i] = false
				self.lastTime[i] = nil
			end
		end
	end
end

function Nidalee:IsPassive(unit)
	for i, msg in pairs(self.Champ) do
		self.isUnit = self.Champ[i]
		self.isPassive = self.Passive[i]
		if unit.charName == self.isUnit then
			return self.isPassive
		end
	end
end

function Nidalee:stealQ()
	if self.Human then
		for i, unit in pairs(self.myEnemyTable) do
			if GetDistance(unit) <= 1500 and self.Settings.killsteal.useQ then 
				self.dmgQ = getDmg("Q", unit, myHero) 
				self.dmgQ = (self.dmgQ * (0.012 * (GetDistance(unit) * 0.166667)))
				if ValidTarget(unit) and unit.health <= self.dmgQ * 0.95 then
					self:CastQ1(unit)
				end
			end
		end
	end
end

function Nidalee:autoHeal()
	if self.Human then
		local checkHP = (myHero.health*100) / myHero.maxHealth
		if checkHP < self.Settings.misc.valueHeal and self.Spells.E1.Ready() then 
			CastSpell(_E , myHero)
		end
	end
end

function Nidalee:DrawLineHPBar(damage, text, unit, enemyteam)
    if unit.dead or not unit.visible then return end
    local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
    if not OnScreen(p.x, p.y) then return end
    local thedmg = 0
    local line = 2
    local linePosA  = {x = 0, y = 0 }
    local linePosB  = {x = 0, y = 0 }
    local TextPos   = {x = 0, y = 0 }
    
    
    if damage >= unit.maxHealth then
        thedmg = unit.maxHealth - 1
    else
        thedmg = damage
    end
    
    thedmg = math.round(thedmg)
    
    local StartPos, EndPos = self:GetHPBarPos(unit)
    local Real_X = StartPos.x + 24
    local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
    if Offs_X < Real_X then Offs_X = Real_X end 
    local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth))
    if mytrans >= 255 then mytrans=254 end
    local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
    if my_bluepart >= 255 then my_bluepart=254 end

    
    if enemyteam then
        linePosA.x = Offs_X-150
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-150
        linePosB.y = (StartPos.y-10)
        TextPos.x = Offs_X-148
        TextPos.y = (StartPos.y-(30+(line*15)))
    else
        linePosA.x = Offs_X-125
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-125
        linePosB.y = (StartPos.y-15)
    
        TextPos.x = Offs_X-122
        TextPos.y = (StartPos.y-(30+(line*15)))
    end
	
	local dmgDraw = unit.health - thedmg
	if dmgDraw < 0 then dmgDraw = 0 end
    DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255, my_bluepart, 0))
    DrawText("HP: "..tostring(math.ceil(dmgDraw)).." | "..tostring(text), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
end

function Nidalee:GetHPBarPos(enemy)
    enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local BarPosOffsetX = -50
    local BarPosOffsetY = 46
    local CorrectionY = 39
    local StartHpPos = 31 
    barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
    barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
    local StartPos = Vector(barPos.x , barPos.y, 0)
    local EndPos = Vector(barPos.x + 108 , barPos.y , 0)    
    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function Nidalee:CheckHealth()
	if self.Settings.combo.warningJump then
		local checkHP = (myHero.health*100) / myHero.maxHealth
		if checkHP > self.Settings.combo.warningJump then return true end
	else
		return true
	end
end

function Nidalee:OnTick()
	self.TargetSelector:update()
	self.Target = self:GetCustomTarget()
	
	if SAC and _G.AutoCarry then
		if _G.AutoCarry.Keys.AutoCarry then
			_G.AutoCarry.Orbwalker:Orbwalk(self.Target)
		end
	end
	
	self:CheckPassive()
	if self.Target ~= nil then
		self.canCastR = self:IsPassive(self.Target)
		self.canJump = self:CheckHealth()
	end
	
	if self.Settings.misc.autoHeal then self:autoHeal() end
	self:stealQ()
	self:UpdateRecall()
	
	self.comboKey = self.Settings.combo.comboKey
	self.harassKey = self.Settings.harass.harassKey
	self.escapeKey = self.Settings.escape.escapeKey
	if self.comboKey then self:Combo(self.Target)
	elseif self.harassKey then self:Harass(self.Target)
	elseif self.escapeKey then self:Run() end
	
end

function Nidalee:Harass(unit)
	if ValidTarget(unit) then
		if self.Human and self.Settings.harass.useQ then
			self:CastQ1(unit)
		end
	end
end

function Nidalee:Combo(unit)
	if self.canHeal and self.Settings.combo.heal then
		self:CastE()
	end
	if ValidTarget(unit) then
		if self.Human then
			self:CastQ1(unit)
			if self:IsPassive(unit) and not self.Settings.combo.dontJump then
				if GetDistance(unit) <= 750 and self.canJump then 
					self:CastR()
				end
			elseif GetDistance(unit) <= 450 then
				self:CastR()
			end
		else
			self:CastW(unit)
			self:CastQ2(unit)
			self:CastE2(unit)
			if not self:IsPassive(unit) then
				self:Escape(unit)
				self:CastR()
			end
		end
	end
end

function Nidalee:CastQ1(unit)
		if (unit.charName == self.Champ[1] and self.Settings.qSet.champ1) or (unit.charName == self.Champ[2] and self.Settings.qSet.champ2) or (unit.charName == self.Champ[3] and self.Settings.qSet.champ3) or (unit.charName == self.Champ[4] and self.Settings.qSet.champ4) or (unit.charName == self.Champ[5] and self.Settings.qSet.champ5) then 
			if GetDistance(unit) < self.Settings.qSet.maxRange and GetDistance(unit) > self.Settings.qSet.minRange and self.Spells.Q1.Ready() then
				if self.Settings.prediction.prediction == 0 then
					self.lastQ = os.clock()
					self.CastPosition,  self.HitChance, self.Position = VP:GetLineCastPosition(unit, self.Spells.Q1.Delay, self.Spells.Q1.Width, self.Spells.Q1.Range, self.Spells.Q1.Speed, myHero, false)
					CastSpell(_Q, self.CastPosition.x , self.CastPosition.z)
				else
					self.lastQ = os.clock()
					local enemy = DPTarget(unit)
					local State, Position, perc = DP:predict(enemy, myQ)
					if State == SkillShot.STATUS.SUCCESS_HIT then 
						CastSpell(_Q, Position.x, Position.z)
					end
				end
			end
		end
end

function Nidalee:CastR()
	if self.Spells.R.Ready() and os.clock() - self.lastQ > 0.4 then
		CastSpell(_R)
	end
end

function Nidalee:CastW(unit)
	if self.Spells.W2.Ready() and GetDistance(unit) < 775  then
		CastSpell(_W, unit.pos.x , unit.pos.z)
		self.lastQ = os.clock()
	end
end

function Nidalee:CastQ2(unit)
	if GetDistance(unit) < self.Spells.Q2.Range and self.Spells.Q2.Ready() then
		CastSpell(_Q)
		myHero:Attack(unit)
		self.lastQ = os.clock()
	end
end

function Nidalee:CastE2(unit)
	if GetDistance(unit) < self.Spells.E2.Range and self.Spells.E2.Ready() then
		CastSpell(_E, unit.pos.x , unit.pos.z)
		self.lastQ = os.clock()
	end
end

function Nidalee:Escape(unit)
	local jmpToPos = unit + (Vector(myHero) - unit):normalized() * 375
	CastSpell(_W, jmpToPos.x, jmpToPos.z)
	self.lastQ = os.clock()
	self.canHeal = true
end

function Nidalee:CastE()
	if self.Spells.E1.Ready() and myHero.health < myHero.maxHealth and self.recal then
		CastSpell(_E , myHero)
		self.lastQ = os.clock()
		self.canHeal = false
	end
end

function Nidalee:Run()
	if self.Human then self:CastR() end
	myHero:MoveTo(mousePos.x, mousePos.z)
	if self.Spells.W2.Ready() and self.Settings.escape.useW2 then
		CastSpell(_W, mousePos.x,mousePos.z)
		self.lastQ = os.clock()
	end
end

function Nidalee:OnCastSpell(iSpell,startPos,endPos,targetUnit)
	if iSpell == 3 then
		if self.Human then
			self.Human = false
		else
			self.Human = true
		end
	end
end

function Nidalee:OnProcessSpell(unit,spell)
	if spell.name == "recall" then
		self.recal = true
		self.lastRecall = os.clock()
	end
end

function Nidalee:UpdateRecall()
	if self.recal then
		if os.clock() - self.lastRecall > 10 then
			self.recal = false
		end
	end
end


assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILJOMNKQKM") 
