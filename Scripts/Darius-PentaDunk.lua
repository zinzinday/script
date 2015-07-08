if myHero.charName ~= "Darius" then return end 
class 'Darius'

class "ScriptUpdate"
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
		print("<font color=\"#DF7401\"><b>Darius PentaDunk: </b></font><font color=\"#D7DF01\">Waiting for any OrbWalk authentification</b></font>")
		DelayAction(function()	
			CustomOnLoad()
		end, 10)
	end
end

function CheckScriptUpdate()
	local ToUpdate = {}
    ToUpdate.Version = 2.1
    ToUpdate.UseHttps = true
	ToUpdate.Name = "Darius - PentaDunk"
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/AMBER17/BoL/master/Darius-PentaDunk.version"
    ToUpdate.ScriptPath =  "/AMBER17/BoL/master/Darius-PentaDunk.lua"
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

function CustomOnLoad()
	if _G.AutoCarry ~= nil then
		SAC = true
		print("<font color=\"#DF7401\"><b>Darius PentaDunk: </b></font><font color=\"#D7DF01\">SAC Detected & Loaded</b></font>")
	else 
		SX = true
		require "SxOrbWalk"
	end
	Darius()
end

function Darius:__init()
	print("<font color=\"#DF7401\"><b>Darius PentaDunk: </b></font><font color=\"#D7DF01\"> Successful Loaded</b></font>")
	print("<font color=\"#DF7401\"><b>Darius PentaDunk: </b></font><font color=\"#D7DF01\"> Thanks for use my Script ! Have a Good Game ! Amber_ </b></font>")
	
	self:Variable()
	self:myMenu()
	
	AddTickCallback(function() self:OnTick() end)
	AddMsgCallback(function(Msg,Key) self:OnWndMsg(Msg,Key) end)
	AddDrawCallback(function() self:OnDraw() end)
	if AddUpdateBuffCallback(function(unit, buff, stacks) self:OnUpdateBuff(unit, buff, stacks) end) ~= nil then AddUpdateBuffCallback(function(unit, buff, stacks) self:OnUpdateBuff(unit, buff, stacks) end) end
	AddRemoveBuffCallback(function(unit,buff) self:OnRemoveBuff(unit,buff) end)
	
end

function Darius:Variable()

	
	self.TargetSelector = TargetSelector(TARGET_LOW_HP, 1000, DAMAGE_PHYSICAL, false, true)
	self.Spells = {
		Q = { Range = 420, Width = 410, Delay = 0.2, Speed = math.huge+150, TS = 0, Ready = function() return myHero:CanUseSpell(0) == 0 end,},
		W = { Range = 145, Width = nil, Delay = 0.2, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(1) == 0 end,},
		E = { Range = 540, Width = 60, Delay = 0.2, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(2) == 0 end,},
		R = { Range = 480, Width = nil, Delay = 0, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(3) == 0 end,},
	}
	self.myEnemyTable = GetEnemyHeroes()
	self.Champ = { } 
	self.Hemoragie = {0,0,0,0,0}
	for i, enemy in pairs(self.myEnemyTable) do 
		self.Champ[i] = enemy.charName
	end
	
end

function Darius:myMenu()
	self.Settings = scriptConfig("Darius PentaDunk", "AMBER")
	
	self.Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "combo")
		self.Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		self.Settings.combo:addParam("UseQ", "Use (Q) in combo", SCRIPT_PARAM_ONOFF, true)
		self.Settings.combo:addParam("UseW", "Use (W) in combo", SCRIPT_PARAM_ONOFF, true)
		self.Settings.combo:addParam("UseE", "Use (E) in combo", SCRIPT_PARAM_ONOFF, true)
		self.Settings.combo:addParam("UseR", "Use (R) in combo", SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "harass")
		self.Settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		self.Settings.harass:addParam("UseQ", "Use (Q) in harass", SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Killsteal Settings", "killsteal")
		self.Settings.killsteal:addParam("UseQ", "Use (Q) in Killsteal", SCRIPT_PARAM_ONOFF, true)
		self.Settings.killsteal:addParam("UseR", "Use (R) in Killsteal", SCRIPT_PARAM_ONOFF, true)

	self.Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")	
		self.Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		self.Settings.drawing:addParam("qDraw", "Draw (Q) Range", SCRIPT_PARAM_ONOFF, true)
		self.Settings.drawing:addParam("eDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)
		self.Settings.drawing:addParam("rDraw", "Draw (R) Range", SCRIPT_PARAM_ONOFF, true)
		self.Settings.drawing:addParam("text", "Draw Current Target", SCRIPT_PARAM_ONOFF, true)
		self.Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)
		self.Settings.drawing:addParam("lifeBar", "Draw Health Bar", SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		if SX then
			SxOrb:LoadToMenu(self.Settings.Orbwalking)
		elseif SAC then
			self.Settings.Orbwalking:addParam("info", "SAC Detected & Loaded", SCRIPT_PARAM_INFO, "")
		end
		
		self.Settings.combo:permaShow("comboKey")
		self.Settings.harass:permaShow("harassKey")
	
	self.TargetSelector.name = "[Darius]"
	self.Settings:addTS(self.TargetSelector)
	
end 

function Darius:OnDraw()
	if not myHero.dead and not self.Settings.drawing.mDraw then	
		if self.Settings.drawing.lifeBar then
			for i, unit in pairs(self.myEnemyTable) do
				if ValidTarget(unit) and GetDistance(unit) <= 3000 then 
					local spells = ""
					if self.Spells.Q.Ready() then 
						self.qDmg = getDmg("Q", unit, myHero) 
						spells = "Q "
					else 
						self.qDmg = 0 
					end
					if self.Spells.W.Ready() then 
						self.wDmg = getDmg("W", unit, myHero) 
						spells = spells .. "- W "
					else 
						self.wDmg = 0 
					end
					if self.Spells.R.Ready() then 
						for i, msg in pairs(self.Champ) do
							self.isUnit = self.Champ[i]
							if self.isUnit == unit.charName then
								self.rDmg = getDmg("R", unit, myHero)
								self.rDmg = self.rDmg + (self.rDmg*(0.2*self.Hemoragie[i]))
								spells = spells .. "- R "
							end
						end
					else 
						self.rDmg = 0 
					end
					self.dmgTotal = math.ceil(self.qDmg + self.wDmg + self.rDmg)
					self:DrawLineHPBar(self.dmgTotal,spells, unit, true)
				end
			end
		end
		if ValidTarget(self.Target) then 
			if self.Settings.drawing.text then 
				DrawText3D("Current Target",self.Target.x-100, self.Target.y-50, self.Target.z, 20, 0xFFFFFF00)
			end
			if self.Settings.drawing.targetcircle then 
				DrawCircle(self.Target.x, self.Target.y, self.Target.z, 150, ARGB(125, 0 , 0 ,255))
			end
		end
		if self.Spells.Q.Ready() and self.Settings.drawing.qDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.Q.Range, ARGB(125, 0 , 0 ,255))
		end
		
		if self.Spells.E.Ready() and self.Settings.drawing.eDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.E.Range, ARGB(125, 0 , 0 ,255))
		end
		
		if self.Spells.R.Ready() and self.Settings.drawing.rDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z,self.Spells.R.Range, ARGB(125, 0 , 0 ,255))
		end
	end
end

function Darius:OnTick()
	self.TargetSelector:update()
	self.Target = self:GetCustomTarget()
	
	if SAC then
		if _G.AutoCarry.Keys.AutoCarry then
			_G.AutoCarry.Orbwalker:Orbwalk(self.Target)
		end
	elseif SX then
		SxOrb:ForceTarget(self.Target) 
	end
	
	self.comboKey = self.Settings.combo.comboKey
	self.harassKey = self.Settings.harass.harassKey
	if self.comboKey then self:Combo(self.Target)
	elseif self.harassKey then self:Harass(self.Target) end
	if self.Settings.killsteal.UseQ then self:qKillSteal() end
	if self.Settings.killsteal.UseR then self:KillSteal() end
	
end

function Darius:GetCustomTarget()

	if self.SelectedTarget ~= nil and ValidTarget(self.SelectedTarget, 1800) and (Ignore == nil or (Ignore.networkID ~= self.SelectedTarget.networkID)) and GetDistance(self.SelectedTarget) < 1800 then
		return self.SelectedTarget
	end
	
	if self.TargetSelector.target and not self.TargetSelector.target.dead and self.TargetSelector.target.type == myHero.type then
		return self.TargetSelector.target
	else
		return nil
	end
	
end

function Darius:OnWndMsg(Msg, Key)

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

function Darius:OnUpdateBuff(unit, buff, stacks)
	if buff.name == "dariushemo" then 
		for i, msg in pairs(self.Champ) do
			self.isUnit = self.Champ[i]
			if self.isUnit == unit.charName then
				if self.Hemoragie[i] < 5 then 
					self.Hemoragie[i] = self.Hemoragie[i] + 1
				end
			end		
		end
	end
end

function Darius:OnRemoveBuff(unit,buff)
	if buff.name == "dariushemo" then 
		for i, msg in pairs(self.Champ) do
			self.isUnit = self.Champ[i]
			if self.isUnit == unit.charName then
				self.Hemoragie[i] = 0
			end		
		end
	end
end

function Darius:Combo(unit)
	if ValidTarget(unit) then
		if self.Settings.combo.UseQ then
			self:CastQ(unit)
		end
		if self.Settings.combo.UseW then
			self:CastW(unit)
		end
		if self.Settings.combo.UseE then
			self:CastE(unit)
		end
		if self.Settings.combo.UseR then
			self:CastR(unit)
		end
	end
end

function Darius:CastQ(unit)
	if GetDistance(unit) <= self.Spells.Q.Range and self.Spells.Q.Ready() then
		CastSpell(_Q)
	end	
end	

function Darius:CastW(unit)
	if GetDistance(unit) <= 200 and self.Spells.W.Ready() then
		CastSpell(_W)
	end
end

function Darius:CastE(unit)
	if GetDistance(unit) <= self.Spells.E.Range and GetDistance(unit) >= 200 and self.Spells.E.Ready() then
		local CastPosition,  HitChance,  Position = VP:GetConeAOECastPosition(unit, self.Spells.E.Delay, 40, self.Spells.E.Range, self.Spells.E.Speed, myHero, false)	
		if HitChance >= 2 then
			CastSpell(_E, CastPosition.x , CastPosition.z)
		end
	end
end

function Darius:CastR(unit) 
	for i, msg in pairs(self.Champ) do
		self.isUnit = self.Champ[i]
		if self.isUnit == unit.charName then
			local dmgR = getDmg("R", unit, myHero)
			dmgR = dmgR + (dmgR*(0.2*self.Hemoragie[i]))
			if unit.health < dmgR * 0.95 then
				CastSpell(_R, unit)
			end
		end
	end
end

function Darius:KillSteal()
	for _, unit in pairs(GetEnemyHeroes()) do
		if ValidTarget(unit) then
			if GetDistance(unit) <= self.Spells.R.Range and self.Spells.R.Ready() then
				for i, msg in pairs(self.Champ) do
					self.isUnit = self.Champ[i]
					if self.isUnit == unit.charName then
						local dmgR = getDmg("R", unit, myHero)
						dmgR = dmgR + (dmgR*(0.2*self.Hemoragie[i]))
						if unit.health < dmgR * 0.95 then
							CastSpell(_R, unit)
						end
					end
				end	
			end
		end
	end
end

function Darius:qKillSteal()
	for _, unit in pairs(GetEnemyHeroes()) do
		if ValidTarget(unit) then
			if GetDistance(unit) <= self.Spells.Q.Range and self.Spells.Q.Ready() then
				local dmgQ = getDmg("Q", unit, myHero)
				if unit.health < dmgQ*0.95 then
					CastSpell(_Q)
				end
			end
		end
	end
end

function Darius:Harass(unit)
	self:CastQ(unit)
end

function Darius:DrawLineHPBar(damage, text, unit, enemyteam)
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

    DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255, my_bluepart, 0))
    DrawText(tostring(thedmg).." "..tostring(text), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
end

function Darius:GetHPBarPos(enemy)
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

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("SFIGGMEKMHL") 
