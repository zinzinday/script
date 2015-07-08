if myHero.charName ~= "Irelia" then return end 

local  IreliaMasterBlades_Version = 1.71

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
SxUpdate(IreliaMasterBlades_Version,
	"raw.githubusercontent.com",
	"/AMBER17/BoL/master/Irelia-Master-Blades.version",
	"/AMBER17/BoL/master/Irelia-Master-Blades.lua",
	SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
	function(NewVersion) if NewVersion > IreliaMasterBlades_Version then print("<font color=\"#F0Ff8d\"><b>Irelia - Master Blades : </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true else print("<font color=\"#F0Ff8d\"><b>Irelia - Master Blades : </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") end 
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
	print("<b><font color=\"#FF001E\">| Irelia |</font></b><font color=\"#FF980F\"> Have a Good Game </font><font color=\"#FF001E\">| AMBER |</font>")
	TargetSelector = TargetSelector(TARGET_LOW_HP , 1400, DAMAGE_PHYSICAL, false, true)
	Variables()
	Menu()
end

function OnTick()
	if os.clock() - LastTick < 0.01 then return end
	Checks()
	
	KillSteal()
	ComboKey = Settings.combo.comboKey	
	LaneClear = Settings.LaneClear.LaneClear
	Harass = Settings.Harass.Harass
	TargetSelector:update()
	Target = GetCustomTarget()
	SxOrb:ForceTarget(Target)
	
	if LaneClear then
		LaneClearMode()
	end
	
	if Harass then
		HarassMode(Target)
	end
	
	if Target ~= nil then
		if ComboKey then
			Combo(Target)
		end
	end
	LastTick = os.clock()
end

function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)

	 _G.DrawCircle = _G.oldDrawCircle 
	 
end

function Variables()
	SkillQ = { range = 650, delay = 0.1, speed = math.huge, width = nil, ready = false }
	SkillW = { range = 125, delay = 0.1, speed = math.huge, width = nil, ready = false }
	SkillE = { range = 340 , delay = 0.1, speed = math.huge, width = nil, ready = false }
	SkillR = { range = 1000, delay = 0.1, speed = math.huge, width = 40, ready = false }
	LastTick = 0
	DariusP = 0
	enemyMinions = minionManager(MINION_ENEMY, SkillQ.range, myHero, MINION_SORT_HEALTH_ASC)

	VP = VPrediction()
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	
end


function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
end

function OnDraw()

	if not myHero.dead and not Settings.drawing.mDraw then	
		if ValidTarget(Target) then 
			if Settings.drawing.text then 
				DrawText3D("Current Target",Target.x-100, Target.y-50, Target.z, 20, 0xFFFFFF00)
			end
			if Settings.drawing.targetcircle then 
				DrawCircle(Target.x, Target.y, Target.z, 150, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
			end
		end
	
	
		if SkillQ.ready and Settings.drawing.qDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
		end
		
		if SkillE.ready and Settings.drawing.eDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, RGB(Settings.drawing.eColor[2], Settings.drawing.eColor[3], Settings.drawing.eColor[4]))
		end
		
		if SkillR.ready and Settings.drawing.rDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, RGB(Settings.drawing.rColor[2], Settings.drawing.rColor[3], Settings.drawing.rColor[4]))
		end
		
		if Settings.drawing.myHero then
			DrawCircle(myHero.x, myHero.y, myHero.z, myHero.range, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
		end
	end
end

function GetCustomTarget()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1400) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
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


function Combo(unit)
	TargetSelector:update()
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		
		if Settings.combo.UseQ then
			CastQ(unit)
		end
		if Settings.combo.UseW then
			CastW(unit)
		end
		if Settings.combo.UseE and not Settings.combo.Estunt then
			CastE(unit)
		end
		if  Settings.combo.Estunt then
			CastEstunt(unit)
		end
		if Settings.combo.UseR and not Settings.combo.UseRAfter then
			CastR(unit)
		end
		
		if Settings.combo.UseRAfter then
			CastR2(unit)
		end
	end
end

function LaneClearMode()
	enemyMinions:update()
	if Settings.LaneClear.UseQ and SkillQ.ready and ManaManagementLaneClear()then
		for i, minion in pairs(enemyMinions.objects) do
			if ValidTarget(minion) and minion ~= nil then
				qDmg = getDmg("Q", minion, myHero) + getDmg("AD", minion, myHero)
				if GetDistance(minion) <= SkillQ.range and minion.health <= qDmg then 
					Packet("S_CAST", {spellId = _Q, targetNetworkId = minion.networkID}):send()
				end		 
			end
		end
	end
end

function CheckJump()
end

function CastQ(unit)
	if GetDistance(unit) <= SkillQ.range and SkillQ.ready then
		Packet("S_CAST", {spellId = _Q, targetNetworkId = unit.networkID}):send()
	elseif Settings.combo.UseQminion then 
		enemyMinions:update()
		local bestMinion = nil
		for i, minion in pairs(enemyMinions.objects) do
			if ValidTarget(minion) and minion.health < getDmg("Q", unit, myHero) +(myHero.addDamage+myHero.damage) and GetDistance(myHero, minion) < SkillQ.range then
				if GetDistance(unit, minion) < SkillQ.range then
					bestMinion = minion
				end		
			end			
		end
		if bestMinion then
			CastSpell(_Q, bestMinion)
			DelayAction(function(u)
				CastSpell(_Q, unit)
			end,0, {unit})
		
		end
	end
end

function CastQharass(unit)
	if GetDistance(unit) <= 320 and SkillQ.ready then
		Packet("S_CAST", {spellId = _Q, targetNetworkId = unit.networkID}):send()
	end
end


	
function CastW(unit)
	if GetDistance(unit) <= SkillW.range and SkillW.ready then
			Packet("S_CAST", {spellId = _W}):send()
			myHero:Attack(unit)
	end	
end

function CastE(unit)
	if GetDistance(unit) <= SkillE.range and SkillE.ready then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
	end	
end

function CastEstunt(unit)
	if unit.health > myHero.health then
		if GetDistance(unit) <= SkillE.range and SkillE.ready then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
		end	
	end
end


function CastR(unit)
	if unit ~= nil and GetDistance(unit) <= SkillR.range and SkillR.ready then
		CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero, false)	
		
		if HitChance >= 2 then
			Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
		end
	end
end

function CastR2(unit)
	if unit ~= nil and GetDistance(unit) <= 650 and SkillR.ready then
		CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillR.delay, SkillR.width, SkillR.range, SkillR.speed, myHero, false)	
		
		if HitChance >= 2 then
			Packet("S_CAST", {spellId = _R, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
		end
	end
end

function KillSteal()
	for _, unit in pairs(GetEnemyHeroes()) do
		if not unit.dead then
			local dmgQ = getDmg("Q", unit, myHero) + (myHero.addDamage+myHero.damage)
			local dmgE = getDmg("E", unit, myHero) + (myHero.ap/2)
			local dmgR = getDmg("R", unit, myHero) + (myHero.ap/2)+(myHero.addDamage*0.6)
			if Settings.KillSteal.UseQ then
				if unit.health <= dmgQ*0.95 then
					CastQ(unit)
				end
			end
			if Settings.KillSteal.UseR then
				if unit.health <= (dmgR*0.95)*Settings.KillSteal.numberR then
					CastR(unit)
				end
			end
		end
	end
end

function HarassMode(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type and ManaManagementHarass() then
		if Settings.Harass.UseQ then
			CastQharass(unit)
		end
		if Settings.Harass.UseE then
			CastE(unit)
		end
		if Settings.Harass.UseZ then
			CastW(unit)
		end
	end		
end

function ManaManagementLaneClear()
	if myHero.mana > Settings.LaneClear.Mana then
		return true
	else
		return false
	end
end

function ManaManagementHarass()
	if myHero.mana > Settings.Harass.Mana then
		return true
	else
		return false
	end
end

function Menu()
	Settings = scriptConfig("Irelia", "AMBER")
	
	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "combo")
		Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.combo:addParam("UseQ", "Use (Q) in combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseQminion", "Use (Q) on Minion if Target Out Of Range", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseW", "Use (W) in combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseE", "Use (E) in combo", SCRIPT_PARAM_ONOFF, false)
		Settings.combo:addParam("Estunt", "Use only (E) If Stunt enemy", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("UseR", "Use (R) in combo", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("N"))
		Settings.combo:addParam("UseRAfter", "Use (R) only after Q", SCRIPT_PARAM_ONOFF, true)
		
	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
		Settings.Harass:addParam("Harass", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		Settings.Harass:addParam("UseQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("UseE", "Use (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("UseW", "Use (Z) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("Mana", "Harass if Mana > X", SCRIPT_PARAM_SLICE, 300, 1, 600, 0)
		
		
	Settings:addSubMenu("["..myHero.charName.."] - LaneClear Settings", "LaneClear")
		Settings.LaneClear:addParam("LaneClear", "LaneClear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))
		Settings.LaneClear:addParam("UseQ", "Use (Q) in LaneClear", SCRIPT_PARAM_ONOFF, true)
		Settings.LaneClear:addParam("Mana", "Use (Q) if Mana > X", SCRIPT_PARAM_SLICE, 300, 1, 600, 0)
		
		
	Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "KillSteal")
		Settings.KillSteal:addParam("UseQ", "Use (Q) for KS", SCRIPT_PARAM_ONOFF, true)
		Settings.KillSteal:addParam("UseR", "Use (R) for KS", SCRIPT_PARAM_ONOFF, true)
		Settings.KillSteal:addParam("numberR", "KillSteal with X (R) ", SCRIPT_PARAM_SLICE, 4, 1, 4, 0)
		
		
	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")	
		Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("qDraw", "Draw (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("qColor", "Draw (Q) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("eDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("eColor", "Draw (E) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("rDraw", "Draw (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("rColor", "Draw (R) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("text", "Draw Current Target", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)
		
		
	Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Settings.Orbwalking)
	
		Settings.combo:permaShow("comboKey")
		Settings.Harass:permaShow("Harass")
		Settings.LaneClear:permaShow("LaneClear")
		Settings.combo:permaShow("UseR")
		Settings.combo:permaShow("UseRAfter")
		Settings.combo:permaShow("Estunt")
		Settings.KillSteal:permaShow("UseQ")
		Settings.KillSteal:permaShow("UseR")
		Settings.KillSteal:permaShow("numberR")
	
	TargetSelector.name = "Irelia"
	Settings:addTS(TargetSelector)
	
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLLSKKOMJ") 
