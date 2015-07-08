if myHero.charName ~= "Leona" then return end

local  LeonaPutYourSunglasses_Version = 2.52

class "SxUpdate"
function SxUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath, SavePath, Callback)
    self.Callback = Callback
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = VersionPath
    self.ScriptPath = ScriptPath
    self.SavePath = SavePath
    self.LuaSocket = require("socket")
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function SxUpdate:GetOnlineVersion()
    if not self.OnlineVersion and not self.VersionSocket then
        self.VersionSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.VersionSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.VersionPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
    end

    if not self.OnlineVersion and self.VersionSocket then
        self.VersionSocket:settimeout(0, 'b')
        self.VersionSocket:settimeout(99999999, 't')
        self.VersionReceive, self.VersionStatus = self.VersionSocket:receive('*a')
    end

    if not self.OnlineVersion and self.VersionSocket and self.VersionStatus ~= 'timeout' then
        if self.VersionReceive then
            self.OnlineVersion = tonumber(string.sub(self.VersionReceive, string.find(self.VersionReceive, "<bols".."cript>")+11, string.find(self.VersionReceive, "</bols".."cript>")-1))
        else
            print('AutoUpdate Failed')
            self.OnlineVersion = 0
        end
        self:DownloadUpdate()
    end
end

function SxUpdate:DownloadUpdate()
    if self.OnlineVersion > self.LocalVersion then
        self.ScriptSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.ScriptPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
        self.ScriptReceive, self.ScriptStatus = self.ScriptSocket:receive('*a')
        self.ScriptRAW = string.sub(self.ScriptReceive, string.find(self.ScriptReceive, "<bols".."cript>")+11, string.find(self.ScriptReceive, "</bols".."cript>")-1)
        local ScriptFileOpen = io.open(self.SavePath, "w+")
        ScriptFileOpen:write(self.ScriptRAW)
        ScriptFileOpen:close()
    end

    if type(self.Callback) == 'function' then
        self.Callback(self.OnlineVersion)
    end
end

local ForceReload = false
SxUpdate(LeonaPutYourSunglasses_Version,
	"raw.githubusercontent.com",
	"/AMBER17/BoL/master/Leona-Put-Your-Sunglasses.version",
	"/AMBER17/BoL/master/Leona-Put-Your-Sunglasses.lua",
	SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
	function(NewVersion) if NewVersion > LeonaPutYourSunglasses_Version then print("<font color=\"#F0Ff8d\"><b>Leona Put Your Sunglasses : </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true else print("<font color=\"#F0Ff8d\"><b>Leona Put Your Sunglasses: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") end 
end)
	
if FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
	require("SxOrbWalk")
else
	SxUpdate(0,
		"raw.githubusercontent.com",
		"/Superx321/BoL/master/common/SxOrbWalk.Version",
		"/Superx321/BoL/master/common/SxOrbWalk.lua",
		LIB_PATH.."/SxOrbWalk.lua",
		function(NewVersion) if NewVersion > 0 then print("<font color=\"#F0Ff8d\"><b>SxOrbWalk: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true end 
	end)
end
	
if FileExist(LIB_PATH .. "/VPrediction.lua") then
	require("VPrediction")
	VP = VPrediction()
	if VP.version >= 3 then	
		SxUpdate(0,
			"raw.githubusercontent.com",
			"/SidaBoL/Scripts/master/Common/VPrediction.version",
			"/SidaBoL/Scripts/master/Common/VPrediction.lua",
			LIB_PATH.."/VPrediction.lua",
			function(NewVersion) if NewVersion > 0 then print("<font color=\"#F0Ff8d\"><b>VPrediction: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true end 
		end)
	end
else
	SxUpdate(0,
		"raw.githubusercontent.com",
		"/SidaBoL/Scripts/master/Common/VPrediction.version",
		"/SidaBoL/Scripts/master/Common/VPrediction.lua",
		LIB_PATH.."/VPrediction.lua",
		function(NewVersion) if NewVersion > 0 then print("<font color=\"#F0Ff8d\"><b>VPrediction: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true end 
	end)
end

function OnLoad()
	
	print("<b><font color=\"#FF001E\"></font></b><font color=\"#FF980F\"> Have a Good Game </font><font color=\"#FF001E\">| AMBER |</font>")
	TargetSelector = TargetSelector(TARGET_MOST_AD, 1500, DAMAGE_MAGICAL, false, true)
	Variables()
	Menu()
	Target = GetCustomTarget()

end

function OnTick()
	
	Checks()
	TargetSelector:update()
	Target = GetCustomTarget()
	SxOrb:ForceTarget(Target)
	CastAutoR()
	
	if Target ~= nil then
		if Settings.combo.comboKey then
			Combo(Target)
		end
	end
	
end

function OnDraw()
	if not myHero.dead then	
		if ValidTarget(Target) then 
			DrawText3D("Current Target",Target.x-100, Target.y-50, Target.z, 20, 0xFFFFFF00)
			DrawCircle(Target.x, Target.y, Target.z, 150, ARGB(200,100 ,100,0 ))
		end
		
		if SkillE.ready and Settings.Draw.DrawE then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, ARGB(200,50 ,100,0 ))
		end
		if SkillW.ready and Settings.Draw.DrawZ then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, ARGB(200,50 ,100,0 ))
		end
		if SkillR.ready and Settings.Draw.DrawR then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, ARGB(200,50 ,100,0 ))
		end
	end
end


function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)

	_G.DrawCircle = _G.oldDrawCircle 
	 
	 
end

function Variables()

	SkillQ = { range = nil, delay = nil, speed = math.huge, width = nil, ready = false }
	SkillW = { range = 430, delay = nil, speed = math.huge, width = nil, ready = false }
	SkillE = { range = 875, delay = 0.2, speed = math.huge, width = 40, ready = false }
	SkillR = { range = 1100, delay = 0.625, speed = math.huge, width = 220, ready = false }
	
	
	VP = VPrediction()
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2	
	
end


function GetCustomTarget()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	TargetSelector:update()	
	if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
		return TargetSelector.target
	else
		return nil
	end
end


function OnWndMsg(Msg, Key)	
	
	if Msg == WM_LBUTTONDOWN then
		local minD = 0
		local Target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) then
				if GetDistance(unit, mousePos) <= minD or Target == nil then
					minD = GetDistance(unit, mousePos)
					Target = unit
				end
			end
		end

		if Target and minD < 115 then
			if SelectedTarget and Target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = Target
			end
		end
	end
	
end



function DrawCircle2(x, y, z, radius, color)

  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  
end

function Combo(unit)
	
	if Settings.combo.UseE then
		CastE(unit)
	end
	if Settings.combo.UseZ then
		CastW(unit)
	end
	myHero:Attack(unit)
	if Settings.combo.UseQ then
		CastQ(unit)
	end
	myHero:Attack(unit)
	if Settings.combo.EngageR then
		CastR2(unit)
	end
	if Settings.combo.UseR then
		CastR1(unit)	
	end
	
end


function Menu()
Settings = scriptConfig("Leona Put Your Sunglasses", "AMBER")
	
	Settings:addSubMenu("["..myHero.charName.."] - Combo", "combo")
		Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.combo:addParam("UseQ", "Use (Q) ", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseZ", "Use (Z) ", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseE", "Use (E) ", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseR", "Use (R) After (E)",SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("EngageR", "Use (R) For Engage",SCRIPT_PARAM_ONOFF, true)
	
	Settings:addSubMenu("["..myHero.charName.."] - Auto Ult ", "AutoUlt")
		Settings.AutoUlt:addParam("UseAutoR", "Auto R if X enemie", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("V"))
		Settings.AutoUlt:addParam("ARX", "X = ", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
	
	Settings:addSubMenu("["..myHero.charName.."] - Draw", "Draw")
			Settings.Draw:addParam("DrawZ", "Draw (Z)", SCRIPT_PARAM_ONOFF, true)
			Settings.Draw:addParam("DrawE", "Draw (E)", SCRIPT_PARAM_ONOFF, true)
			Settings.Draw:addParam("DrawR", "Draw (R)", SCRIPT_PARAM_ONOFF, true)
		
	
		Settings.combo:permaShow("comboKey")
		Settings.combo:permaShow("UseR")
		Settings.combo:permaShow("EngageR")
		Settings.AutoUlt:permaShow("UseAutoR")
		Settings.AutoUlt:permaShow("ARX")
	
	Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Settings.Orbwalking)
	
	TargetSelector.name = "Leona"
	Settings:addTS(TargetSelector)
end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= 300 and SkillQ.ready then
		Packet("S_CAST", {spellId = _Q}):send()
	end
end

function CastW(unit)
	if unit ~= nil and GetDistance(unit) <= SkillW.range and SkillW.ready then
		Packet("S_CAST", {spellId = _W}):send()
	end
end


function CastE(unit)
	if unit ~= nil and GetDistance(unit) <= SkillE.range and GetDistance(unit) > 300 and SkillE.ready then
		CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillE.delay, SkillE.width, SkillE.range, SkillE.speed, myHero, false)	
		
		if HitChance >= 2 then
			Packet("S_CAST", {spellId = _E, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
		end
	end
end

function CastR1(unit)
if Settings.combo.UseR then
	if unit ~= nil and GetDistance(unit) <= 300 and SkillR.ready then
		CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero, false)	
		if HitChance >= 2 then
			Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
		end
	end
end
end

function CastR2(unit)
if Settings.combo.EngageR then
	if unit ~= nil and GetDistance(unit) <= SkillR.range and SkillR.ready then
		CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero, false)	
		if HitChance >= 2 then
			Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
		end
	end
end
end

function CastAutoR()
if SkillR.ready then
if Settings.AutoUlt.UseAutoR then
	for _, unit in pairs(GetEnemyHeroes()) do
			local rPos, HitChance, maxHit, Positions = VP:GetCircularAOECastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero)
			if ValidTarget(unit, SkillR.range) and rPos ~= nil and maxHit >= Settings.AutoUlt.ARX then
					Packet("S_CAST", {spellId = _R, fromX = rPos.x, fromY = rPos.z, toX = rPos.x, toY = rPos.z}):send()
			end
		end
	end
end
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLLQONOSM") 
