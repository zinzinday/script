--[[ 
Version 2.42
Xerath - High Voltage by AMBER_
ENJOY IT
]]
if myHero.charName ~= "Xerath" then return end	

class "ScriptUpdate"
class 'Xerath'

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
		print("<font color=\"#DF7401\"><b>Xerath High Voltage: </b></font><font color=\"#D7DF01\">Waiting for any OrbWalk authentification</b></font>")
		DelayAction(function()	
			if _G.Reborn_Loaded ~= nil then
				SAC = true
				print("<font color=\"#DF7401\"><b>Xerath High Voltage: </b></font><font color=\"#D7DF01\">SAC Detected & Loaded</b></font>")
			else 
				SX = true
				require "SxOrbWalk"
			end
			Xerath()
		end, 2)
	end
end

function CheckScriptUpdate()
	local ToUpdate = {}
    ToUpdate.Version = 2.42
    ToUpdate.UseHttps = true
	ToUpdate.Name = "Xerath - High Voltage"
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/AMBER17/BoL/master/Xerath.version"
    ToUpdate.ScriptPath =  "/AMBER17/BoL/master/Xerath.lua"
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

function Xerath:__init()
	print("<font color=\"#DF7401\"><b>Xerath High Voltage: </b></font><font color=\"#D7DF01\"> Successful Loaded</b></font>")
	print("<font color=\"#DF7401\"><b>Xerath High Voltage: </b></font><font color=\"#D7DF01\">Version 2.14: Add Combo Humanizer | Perma Draw (Q) Max Range | Have a Good Game |</b></font>")
	
	self:Variable()
	self:myMenu()
	
	AddTickCallback(function() self:OnTick() end)
	AddMsgCallback(function(Msg,Key) self:OnWndMsg(Msg,Key) end)
	AddDrawCallback(function() self:OnDraw() end)
	AddProcessSpellCallback(function(unit,spell) self:OnProcessSpell(unit, spell) end)
	AddApplyBuffCallback(function(unit,source,buff) self:OnApplyBuff(unit,source,buff) end)
	AddCreateObjCallback(function(minion) self:OnCreateObj(minion) end)
	AddDeleteObjCallback(function(minion) self:OnDeleteObj(minion) end)
	AddSendPacketCallback(function(p) self:OnSendPacket(p) end)
	
	
end

function Xerath:OnTick()
	
	if self.CanMove == false then
		self.TargetSelector = TargetSelector(TARGET_LOW_HP, self.Spells.R.Range , DAMAGE_MAGICAL, false, true)
	else
       	self.TargetSelector = TargetSelector(TARGET_LOW_HP, 1800, DAMAGE_MAGICAL, false, true)
	end
	self.TargetSelector:update()
	self.Target = self:GetCustomTarget()
	
	if SAC and _G.AutoCarry then
		if _G.AutoCarry.Keys.AutoCarry then
			_G.AutoCarry.Orbwalker:Orbwalk(self.Target)
		end
	end
	
	if myHero:GetSpellData(3).level ~= 0 then 
		self.Spells.R.Range = self.Spells.R.Ranget[myHero.level >= 6 and myHero:GetSpellData(3).level or 1]
	end
	
	if self.CanMove then 
		if SX then 
			_G.SxOrb:EnableAttacks()
		elseif SAC and _G.AutoCarry then
			_G.AutoCarry.MyHero:AttacksEnabled(true)
		end
	end	
	
	self:calcQ()
	self:calcR()
	self.comboKey = self.Settings.combo.comboKey
	self.harasKey = self.Settings.haras.harasKey
	self.laneclearKey = self.Settings.laneclear.laneclear2
	self.autoultKey = self.Settings.ulti.autoult
	
	if self.comboKey or self.harasKey or self.laneclearKey then
		self.manualkey = false
	else
		self.manualkey = true
	end
	
	if self.Settings.killsteal.useQ then self:stealQ() end
	if self.Settings.killsteal.useW then self:stealW() end
	if self.Settings.killsteal.useE then self:stealE() end
	
	if self.comboKey then self:Combo(self.Target) 
	elseif self.harasKey then self:Haras(self.Target) 
	elseif self.laneclearKey then self:LaneClear()
	elseif self.autoultKey then self:CastR() end

	
end

function Xerath:OnDraw()
	if not myHero.dead then
	
		if self.Settings.draw.lifeBar then
			for i, unit in pairs(self.myEnemyTable) do
				if ValidTarget(unit) and GetDistance(unit) <= self.Spells.R.Range then 
					local spells = ""
					if self.Spells.Q.Ready() then 
						self.qDmg = getDmg("Q", unit, myHero) 
						spells = "Q"
					else 
						self.qDmg = 0 
					end
					if self.Spells.W.Ready() then 
						self.wDmg = getDmg("W", unit, myHero) 
						spells = spells .. "-W "
					else 
						self.wDmg = 0 
					end
					if self.Spells.E.Ready() then 
						self.eDmg = getDmg("E", unit, myHero) 
						spells = spells .. "-E"
					else 
						self.eDmg = 0 
					end
					if self.Spells.R.Ready() then 
						self.tempDmg = getDmg("R", unit, myHero)
						self.rDmg = (self.tempDmg) * (self.Settings.ulti.numberR - self.rTime[4])
						spells = spells .. "-R(" ..tostring(self.Settings.ulti.numberR - self.rTime[4]) .. ")"
					else 
						self.rDmg = 0 
					end
					self.dmgTotal = self.qDmg + self.wDmg + self.eDmg + self.rDmg
					self:DrawLineHPBar(self.dmgTotal,spells, unit, true)
				end
			end
		end
		
		self.stealTarget = self:GetKillableHero(self.Spells.R.Range - 100)
		if self.stealTarget and self.Spells.R.Ready() and self.Settings.draw.rKillable then
			DrawText("Hold Your AutoUlt Key to Kill: " ..tostring(self.stealTarget.charName),28, WINDOW_H * 0.7, WINDOW_W * 0.09, 0xff00ff00)
		end		
		if ValidTarget(self.Target) then 
			if self.Settings.draw.currentTarget then
				DrawText3D("Current Target",self.Target.x-100, self.Target.y-50, self.Target.z, 20, 0xFFFFFF00)
			end
			if self.Settings.draw.circleTarget then
				DrawCircle(self.Target.x, self.Target.y, self.Target.z, 150, ARGB(255, 255, 0, 0))
			end
		end
		
		if self.Spells.Q.Ready() and self.Settings.combo.useQ and self.Settings.draw.drawQ then
			DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.Q.Range, ARGB(125, 200 , 50 ,170))
			DrawCircle(myHero.x, myHero.y, myHero.z, 1400, ARGB(125, 200 , 50 ,170))
		end
		if self.Settings.combo.rangeW == self.Settings.combo.rangeE and self.Spells.W.Ready() and self.Settings.combo.useW and self.Spells.W.Ready() and self.Settings.combo.useW then
			if self.Settings.draw.drawW and self.Settings.draw.drawE then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Settings.combo.rangeW, ARGB(125, 0 , 0 ,255))
			end
		else
			if self.Spells.W.Ready() and self.Settings.combo.useW and self.Settings.draw.drawW then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Settings.combo.rangeW, ARGB(125, 0 , 0 ,255))
			end
			if self.Spells.E.Ready() and self.Settings.combo.useW and self.Settings.draw.drawE then
				DrawCircle(myHero.x, myHero.y, myHero.z, self.Settings.combo.rangeE, ARGB(125, 255 , 0 ,0))
			end
		end

		if self.Spells.R.Ready() and self.Settings.draw.drawR then
			DrawCircle(myHero.x, myHero.y, myHero.z, self.Spells.R.Range, ARGB(125, 255 , 0 ,0))
		end
	end
end

function Xerath:OnApplyBuff(unit,source,buff)
	if unit.isMe and not self.CanMove and table.contains(self.BuffType, buff.type) then self.CanMove = true end	
end

function Xerath:OnProcessSpell(unit, spell)
	--[[ CALCUL Q RANGE ]] --
	if unit.isMe and spell.name == "XerathArcanopulseChargeUp" then
		self.qTime[3] = true
		self.qTime[1] = os.clock()
		self.qTime[2] = self.qTime[1] + 3
		self.Spells.Q.Range = 740
	end
	
	if unit.isMe and spell.name == "xeratharcanopulse2" then 
		self.qTime[3] = false
		self.qTime[1] = 0
		self.qTime[2] = 0
		self.Spells.Q.Range = 740
		self.canQ = false
	end
	-------------------------------------------
	-------------------------------------------
	
	if unit.isMe and spell.name == "XerathLocusOfPower2" then
		self.rTime[4] = 0
		self.rTime[3] = true
		self.rTime[1] = os.clock()
		self.rTime[2] = self.rTime[1] + 10
		self.realTimer = self.rTime[1] + 2
	end
	
	if unit.isMe and spell.name == "xerathlocuspulse" then
		self.rTime[4] = self.rTime[4] + 1
		if self.rTime[4] == 3 then
			self.rTime[3] = false
		end
	end
	
	if self.Settings.gabcloser.gabcloserEtat then
		if table.contains(self.GapCloserList, spell.name) then
			local vec = D3DXVECTOR3(0,0,0)
			if (spell and spell.target and spell.target.isMe or GetDistance(spell.endPos or vec <= myHero.boundingRadius + 10)) then 
				self:AutoE(unit)
			end
		end
	end
end

function Xerath:calcQ()
	
	if (self.qTime[3] == nil and self.qTime[2] == nil) then return end
	if self.qTime[3] == false then return end
	local osc = os.clock()
	self.qTime[3] = (osc - self.qTime[2]) < 3
	
	if self.qTime[3] then 
		self.Spells.Q.Range = math.ceil(self.Spells.Q.Ranget[1] + (self.Spells.Q.Ranget[2] - self.Spells.Q.Ranget[1]) * ((osc - self.qTime[1]) / 1.5), self.Spells.Q.Ranget[2])
		if self.Spells.Q.Range > 1400 then
			self.Spells.Q.Range = 1400
		end
	elseif not self.qTime[3] or not self.Spells.Q.Ready() then
		self.Spells.Q.Range = 740
		self.canQ = false
	end	
end

function Xerath:calcR()
	if self.rTime[2] == nil then return end
	local osc = os.clock()
	self.rTime[1] = (osc - self.rTime[2]) < 0
	self.time = osc - self.rTime[2]
	if self.rTime[3] and self.rTime[1] then
		self.CanMove = false
	else
		self.rTime[3] = false
		self.CanMove = true
		self.rTime[4] = 0
		self.rTime[2] = nil
	end		
end

function Xerath:Combo(unit)
	if self.CanMove and ValidTarget(unit) then
		if self.Settings.combo.comboMode == 0 then
			if self.Settings.combo.useW then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastW(unit)
					end
				else
					self:CastW(unit)
				end
			end
			if not self.Spells.W.Ready() or not self.Settings.combo.useW then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastE(unit)
					end
				else
					self:CastE(unit)
				end
			end
			if not self.Spells.W.Ready() and not self.Spells.E.Ready() or not self.Settings.combo.useE and not self.Settings.combo.useW then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastQ(unit)
					end
				else
					self:CastQ(unit)
				end
			end
		elseif self.Settings.combo.comboMode == 1 then
			if self.Settings.combo.useE then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastE(unit)
					end
				else
					self:CastE(unit)
				end
			end
			if not self.Spells.E.Ready() or not self.Settings.combo.useE then
				if self.Settings.humanizer.humanizerStatu2 then
					if self.Settings.humanizer.humanizerStatu2 then
						if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
							self:CastW(unit)
						end
					end
				else
					self:CastW(unit)
				end
			end
			if not self.Spells.W.Ready() and not self.Spells.E.Ready() or not self.Settings.combo.useW and not self.Settings.combo.useE then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastQ(unit)
					end
				else
					self:CastQ(unit)
				end
			end
		elseif self.Settings.combo.comboMode == 2 then
			if self.Settings.combo.useE then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastE(unit)
					end
				else
					self:CastE(unit)
				end
			end
			if self.Settings.combo.useW then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastW(unit)
					end
				else
					self:CastW(unit)
				end
			end
			if self.Settings.combo.useQ then
				if self.Settings.humanizer.humanizerStatu2 then
					if os.clock() - self.lastSpell > self.Settings.humanizer.time2 then
						self:CastQ(unit)
					end
				else
					self:CastQ(unit)
				end
			end
		end
	end
end

function Xerath:CastQ(unit)
	self:CastQ1(unit)
	self:CastQ2(unit)
end

function Xerath:CastQ1(unit)
	if self.qTime[3] then return end
    if GetDistance(unit) <= 1300 and self.Spells.Q.Ready() then
        CastSpell(_Q, myHero.x ,myHero.y , myHero.z)
    end
end

function Xerath:CastQ2(unit)
	if not self.qTime[3] then return end
	if GetDistance(unit) < (self.Spells.Q.Range - 130) and self.Spells.Q.Ready() then
		self.canQ = true
		self.CastPosition1,  self.HitChance,  self.Position = VP:GetLineCastPosition(unit, self.Spells.Q.Delay, self.Spells.Q.Width, self.Spells.Q.Range, self.Spells.Q.Speed, myHero, false)
		local vec2 = D3DXVECTOR3(self.CastPosition1.x, self.CastPosition1.y, self.CastPosition1.z)
		CastSpell2(_Q, vec2)
		self.lastSpell = os.clock()
	end
end

function Xerath:CastW(unit)
	self.CastPosition2, self.HitChance2 = VP:GetCircularCastPosition(unit, self.Spells.W.Delay, self.Spells.W.Width, self.Spells.W.Range, self.Spells.W.Speed, myHero, false)
	if GetDistance(unit) <= self.Settings.combo.rangeW and self.Spells.W.Ready() then
		CastSpell(_W, self.CastPosition2.x, self.CastPosition2.z)
		self.lastSpell = os.clock()
	end
end

function Xerath:CastE(unit)
	if GetDistance(unit) <= self.Settings.combo.rangeE and self.Spells.E.Ready() and ValidTarget(unit) then
		self.CastPosition3, self.HitChance = VP:GetLineCastPosition(unit, self.Spells.E.Delay, self.Spells.E.Width, self.Spells.E.Range, self.Spells.E.Speed, myHero, true)
		if self.HitChance >= 2 then 
			CastSpell(_E, self.CastPosition3.x, self.CastPosition3.z)
			self.lastSpell = os.clock()
		end
	end
end

function Xerath:AutoE(unit)
	self.CastPosition4, self.HitChance = VP:GetLineCastPosition(unit, self.Spells.E.Delay, self.Spells.E.Width, self.Spells.E.Range, self.Spells.E.Speed, myHero, true)
	if self.HitChance >= 1 then 
		CastSpell(_E, self.CastPosition4.x, self.CastPosition4.z)
		self.lastSpell = os.clock()
	end
end

function Xerath:CastR()
	if self.Spells.R.Ready() then
		self.rTarget = self:GetKillableHero(self.Spells.R.Range)
		if self.rTarget ~= nil then
			self.CastPosition, self.HitChance = VP:GetCircularCastPosition(self.rTarget, self.Spells.R.Delay, self.Spells.R.Width, self.Spells.R.Range, self.Spells.R.Speed, myHero, false)
			if GetDistance(self.rTarget) <= self.Spells.R.Range and self.Spells.R.Ready() and self:TimeToCastR() then
				CastSpell(_R, self.CastPosition.x, self.CastPosition.z)
			end	
		elseif self.rTime[3] == true then
			self.newTarget = self:GetLowestHero()
			if self.newTarget ~= nil then
				self.CastPosition, self.HitChance = VP:GetCircularCastPosition(self.newTarget, self.Spells.R.Delay, self.Spells.R.Width, self.Spells.R.Range, self.Spells.R.Speed, myHero, false)
				if self.Spells.R.Ready() and self:TimeToCastR() then
					CastSpell(_R, self.CastPosition.x, self.CastPosition.z)
				end
			end
		end
	end
end

function Xerath:GetKillableHero(range)
	local KillableHero = nil
	for i, unit in pairs(self.myEnemyTable) do
		if GetDistance(unit) <= range then 
			if ValidTarget(unit) and not unit.dead and unit.visible then
				if (unit.charName == self.Champ[1] and self.Settings.ulti.champ1) or (unit.charName == self.Champ[2] and self.Settings.ulti.champ2) or (unit.charName == self.Champ[3] and self.Settings.ulti.champ3) or (unit.charName == self.Champ[4] and self.Settings.ulti.champ4) or (unit.charName == self.Champ[5] and self.Settings.ulti.champ5) then 
					self.tempDmg = getDmg("R", unit, myHero) 
					self.rDmg = (self.tempDmg) * (self.Settings.ulti.numberR - self.rTime[4])
					if unit.health < self.rDmg then
						KillableHero = unit
					end
				end
			end
		end
	end
	return KillableHero
end

function Xerath:GetLowestHero()
	local LowestHero, LowestHP = nil, 1000000
	for _, unit in pairs(GetEnemyHeroes()) do
		if GetDistance(unit) <= self.Spells.R.Range then 
			if ValidTarget(unit) and not unit.dead and unit.visible then
				if unit.health < LowestHP then
					LowestHero = unit
					LowestHP = unit.health
				end
			end
		end
	end
	return LowestHero
end

function Xerath:stealQ()
	for i, unit in pairs(self.myEnemyTable) do
		if GetDistance(unit) <= self.Spells.Q.Range then 
		self.dmgQ = getDmg("Q", unit, myHero) 
			if ValidTarget(unit) and unit.health <= self.dmgQ * 0.95 then
				self.manualkey = false
				self:CastQ(unit)
			end
		end
	end
end

function Xerath:stealW()
	for i, unit in pairs(self.myEnemyTable) do
		if GetDistance(unit) <= self.Spells.W.Range then 
		self.dmgW = getDmg("W", unit, myHero) 
			if ValidTarget(unit) and unit.health <= self.dmgW * 0.95 then
				self:CastW(unit)
			end
		end
	end
end

function Xerath:stealE()
	for i, unit in pairs(self.myEnemyTable) do
		if GetDistance(unit) <= self.Spells.E.Range then 
		self.dmgE = getDmg("E", unit, myHero) 
			if ValidTarget(unit) and unit.health <= self.dmgE * 0.95 then
				self:CastE(unit)
			end
		end
	end
end

function Xerath:myMenu()
	self.Settings = scriptConfig("Xerath", "AMBER")
	self.Settings:addSubMenu("["..myHero.charName.."] - Combo Settings (SBTW)", "combo")
		self.Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		self.Settings.combo:addParam("comboMode","0: W-E | 1: E-W | 2: No Order", SCRIPT_PARAM_SLICE, 1, 0, 2, 0)
		self.Settings.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		self.Settings.combo:addParam("useW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)		
		self.Settings.combo:addParam("rangeW", "(W) - Choose Max Range", SCRIPT_PARAM_SLICE, 1100, 800, 1100, 0)
		self.Settings.combo:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		self.Settings.combo:addParam("rangeE", "(E) - Choose Max Range", SCRIPT_PARAM_SLICE, 1000, 800, 1100, 0)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "haras")
		self.Settings.haras:addParam("harasKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		self.Settings.haras:addParam("useQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		self.Settings.haras:addParam("useW", "Use (W) in Harass", SCRIPT_PARAM_ONOFF, true)
		self.Settings.haras:addParam("mana","Use Spell if mana >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - LaneClear Settings ( Broken )", "laneclear")
		self.Settings.laneclear:addParam("info", "Broken - I'm Working on It", SCRIPT_PARAM_INFO, "")
		
	self.Settings:addSubMenu("["..myHero.charName.."] - (R) Settings", "ulti")
		self.Settings.ulti:addParam("autoult", "AutoUlt Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("T"))
		self.Settings.ulti:addParam("numberR", "How Many Shoot for take Kill", SCRIPT_PARAM_SLICE, 3, 1, 3, 0)
		if self.Champ[1] ~= nil then self.Settings.ulti:addParam("champ1", "Use on "..self.Champ[1], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[2] ~= nil then self.Settings.ulti:addParam("champ2", "Use on "..self.Champ[2], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[3] ~= nil then self.Settings.ulti:addParam("champ3", "Use on "..self.Champ[3], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[4] ~= nil then self.Settings.ulti:addParam("champ4", "Use on "..self.Champ[4], SCRIPT_PARAM_ONOFF, true) end
		if self.Champ[5] ~= nil then self.Settings.ulti:addParam("champ5", "Use on "..self.Champ[5], SCRIPT_PARAM_ONOFF, true) end
		
	self.Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "killsteal")
		self.Settings.killsteal:addParam("useQ", "Use (Q) in KillSteal", SCRIPT_PARAM_ONOFF, true)
		self.Settings.killsteal:addParam("useW", "Use (W) in KillSteal", SCRIPT_PARAM_ONOFF, true)
		self.Settings.killsteal:addParam("useE", "Use (E) in KillSteal", SCRIPT_PARAM_ONOFF, true)

	self.Settings:addSubMenu("["..myHero.charName.."] - Anti GapCloser Settings", "gabcloser")
		self.Settings.gabcloser:addParam("gabcloserEtat", "Use Anti GapCloser", SCRIPT_PARAM_ONOFF, true)
	
	self.Settings:addSubMenu("["..myHero.charName.."] - Draw Settings ", "draw")
		self.Settings.draw:addParam("drawQ","Draw (Q) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawW","Draw (W) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawE","Draw (E) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("drawR","Draw (R) Range",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("lifeBar","Draw Health Bar",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("rKillable","Draw enemi killable with (R)",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("currentTarget","Draw Current Target Text",SCRIPT_PARAM_ONOFF, true)
		self.Settings.draw:addParam("circleTarget","Draw Circle On Target",SCRIPT_PARAM_ONOFF, true)
		
	self.Settings:addSubMenu("["..myHero.charName.."] - Humanizer Settings ", "humanizer")
		self.Settings.humanizer:addParam("humanizerStatu","Humanizer - Ulti",SCRIPT_PARAM_ONOFF, false)	
		self.Settings.humanizer:addParam("time", "time between each Shoot ", SCRIPT_PARAM_SLICE, 1.5, 1, 2.5, 1)
		self.Settings.humanizer:addParam("humanizerStatu2","Humanizer - Combo",SCRIPT_PARAM_ONOFF, false)	
		self.Settings.humanizer:addParam("time2", "time between each Spell ", SCRIPT_PARAM_SLICE, 0.6, 0, 2, 1)

	self.Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		if SX then
			SxOrb:LoadToMenu(self.Settings.Orbwalking)
		elseif SAC then
			self.Settings.Orbwalking:addParam("info", "SAC Detected & Loaded", SCRIPT_PARAM_INFO, "")
		end
		
	self.TargetSelector.name = "[Xerath]"
	
		self.Settings:addTS(self.TargetSelector)
		self.Settings.combo:permaShow("comboKey")
		self.Settings.haras:permaShow("harasKey")
		self.Settings.ulti:permaShow("numberR")
		self.Settings.humanizer:permaShow("humanizerStatu")
		self.Settings.humanizer:permaShow("humanizerStatu2")
		self.Settings.ulti:permaShow("autoult")
end

function Xerath:GetCustomTarget()

	if self.SelectedTarget ~= nil and ValidTarget(self.SelectedTarget, 1800) and (Ignore == nil or (Ignore.networkID ~= self.SelectedTarget.networkID)) and GetDistance(self.SelectedTarget) < 1800 then
		return self.SelectedTarget
	end
	
	if self.TargetSelector.target and not self.TargetSelector.target.dead and self.TargetSelector.target.type == myHero.type then
		return self.TargetSelector.target
	else
		return nil
	end
	
end

function Xerath:OnWndMsg(Msg, Key)
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

function Xerath:ValidMinion(m)
	return (m and m ~= nil and m.type and not m.dead and m.name ~= "hiu" and m.name and m.type:lower():find("min") and not m.name:lower():find("camp") and not m.name:lower():find("odin") and m.team ~= myHero.team and m.charName and m.type == "obj_AI_Minion")
end

function Xerath:OnCreateObj(minion)
	if self:ValidMinion(minion) then 
    	self.MyMinionTable[#self.MyMinionTable + 1] = minion 
	end
end

function Xerath:OnDeleteObj(minion)
  	if self.MyMinionTable ~= nil then
      for i, msg in pairs(self.MyMinionTable)  do 
          if msg.networkID == minion.networkID then
              table.remove(self.MyMinionTable, i)
          end
      end
    end
end

function Xerath:GetLowestMinion(range)
	local LowestMinion, LowestHP = nil, 1000000
	for i, minion in pairs(self.MyMinionTable) do
		self.isMinion = self.MyMinionTable[i]
		if GetDistance(self.isMinion) <= range then 
			if self:ValidMinion(self.isMinion) then
				if self.isMinion.health < LowestHP then
					LowestMinion = self.isMinion
					LowestHP = self.isMinion.health
				end
			end
		end
	end
	self.oldTime = os.clock()
	return LowestMinion
end

function Xerath:Haras(unit)
	if ValidTarget(unit) then
		if self:ManaManager(1) or self.qTime[3] then
			if self.Settings.haras.useQ then
				self:CastQ(unit)
			end
			if self.Settings.haras.useW then
				self:CastW(unit)
			end
		end
	end
end

function Xerath:TimeToCastR()
	if self.Settings.humanizer.humanizerStatu then
		if os.clock() - self.LastR > self.Settings.humanizer.time then
			self.LastR = os.clock()
			return true
		end
	else
		if os.clock() - self.LastR > 0.75 then
			self.LastR = os.clock()
			return true
		end
	end
end

function Xerath:ManaManager(mode)

	local checkMana = (myHero.mana*100) / myHero.maxMana
	if mode == 1 and checkMana > self.Settings.haras.mana then return true end
	if mode == 2 and checkMana > self.Settings.laneclear.mana then return true end
	
end

function Xerath:Variable()

	self.canQ = false
	VP = VPrediction()
	self.castqLane = false
	self.timeLaneclear = 0
	self.manualkey = false
	self.lastSpell = 0
	
	self.TargetSelector = TargetSelector(TARGET_LOW_HP, 1800, DAMAGE_MAGICAL, false, true)
	self.MyMinionTable = { }
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if self:ValidMinion(object) then
			self.MyMinionTable[#self.MyMinionTable + 1] = object
		end
	end
		
	self.Champ = { } 
	self.LastR = 0
	self.lastQ = 0
	self.lastLaneSpell1 = 0
	self.lastLaneSpell2 = 0

	self.GapCloserList = {
			"LeonaZenithBlade",
			"AatroxQ",
			"AkaliShadowDance",
			"Headbutt",
			"FioraQ",
			"DianaTeleport",
			"EliseSpiderQCast",
			"FizzPiercingStrike",
			"GragasE",
			"HecarimUlt",
			"JarvanIVDragonStrike",
			"IreliaGatotsu",
			"JaxLeapStrike",
			"KhazixE",
			"khazixelong",
			"LeblancSlide",
			"LeblancSlideM",
			"BlindMonkQTwo",
			"LeonaZenithBlade",
			"UFSlash",
			"Pantheon_LeapBash",
			"PoppyHeroicCharge",
			"RenektonSliceAndDice",
			"RivenTriCleave",
			"SejuaniArcticAssault",
			"slashCast",
			"ViQ",
			"MonkeyKingNimbus",
			"XenZhaoSweep",
			"YasuoDashWrapper",}

	self.myEnemyTable = GetEnemyHeroes()
	
	for i, enemy in pairs(self.myEnemyTable) do 
		self.Champ[i] = enemy.charName
	end
	
	
	self.Spells = {
		Q = { Range = 740,	Ranget = {740, 1400}, Width = 100, Delay = 0.6, Speed = math.huge+150, TS = 0, Ready = function() return myHero:CanUseSpell(0) == 0 end,},
		W = { Range = 1100, Width = 150, Delay = 0.6, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(1) == 0 end,},
		E = { Range = 1100, Width = 60, Delay = 0, Speed = 1000, TS = 0, Ready = function() return myHero:CanUseSpell(2) == 0 end,},
		R = { Range = 3000, Ranget = {3000, 4200, 5400}, Width = 170, Delay = 0.45, Speed = math.huge, TS = 0, Ready = function() return myHero:CanUseSpell(3) == 0 end,},
	}
	
	self.BuffType ={5, 8 , 10 , 11 , 22 , 24 , 29 , 19}
	
	self.rTime = {
		startT = 0,
		endT = 0,
		process = false,
		nbR = 0,
		startCharge = false
		
	}
	
	self.rTime[5] = false
	self.rTime[4] = 0
	self.CanMove = true
	
	self.qTime = {
		startT = 0,
		endT = 0,
		charging = false
	}
	self.qTime[3] = false
	self.qTime[2] = 0
	self.qTime[1] = 0
	

end

function Xerath:LaneClear()
	if self:ManaManager(2) then
	end
end

function Xerath:OnSendPacket(p)
--[[
	if p then print("SEND: 0x" .. string.format("%04X ", p.header) .. " Size: " .. p.size) end
	if p.header == 0x00B6 and not self.manualkey then
		if not self.canQ then
			p:Block()
		elseif self.laneclearKey then
			if not self.castqLane then
				p:Block()
			else
				self.castqLane = false
			end
		end
	end	
	]]
end

function Xerath:DrawLineHPBar(damage, text, unit, enemyteam)
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

function Xerath:GetHPBarPos(enemy)
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

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBECGEDEACH") 
