local version = "1.25"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Anivia.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Anivia:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Anivia.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				_AutoupdaterMsg("New version available "..ServerVersion)
				_AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				_AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		_AutoupdaterMsg("Error downloading version info")
	end
end

if myHero.charName ~= "Anivia" then return end   

--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("REHGEMJEMHL")assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNMKSPKSNR") 

require("HPrediction")

if VIP_USER and FileExist(LIB_PATH .. "/DivinePred.lua") then 
	require "DivinePred" 
	dp = DivinePred()
	qpred = LineSS(850,1100, 150, 0.25, math.huge)
end

function OnLoad()
	CheckVPred()
   
	if FileExist(LIB_PATH .. "/VPrediction.lua") and FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
		DelayAction(function() 
			CustomOnLoad()
			AddMsgCallback(CustomOnWndMsg)
			AddDrawCallback(CustomOnDraw)          
			AddProcessSpellCallback(CustomOnProcessSpell)
			AddTickCallback(CustomOnTick)
			AddApplyBuffCallback(CustomApplyBuff)          
		end, 6)
	end
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
 
function CustomOnLoad()
	if _G.AutoCarry ~= nil then
		PrintChat("<font color=\"#DF7401\"><b>SAC: </b></font> <font color=\"#D7DF01\">Loaded</font>")
		SAC = true
		SOWp = false
	else
		SOWp = true
		SAC = false
		require "SOW"
		
		SOWi = SOW(VP)
		SOWi:RegisterAfterAttackCallback(AutoAttackReset)
	end
	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_MAGICAL, false, true)
	Variables()
	Menu()
	
	HPred = HPrediction()
	hpload = true
	
	if hpload then
		HPred:AddSpell("Q", 'Anivia', {type = "DelayLine", delay = 0.25, range = 1100, width = 150, speed=850})
  	end
end
 
function CustomOnDraw()
	if not myHero.dead and not Settings.drawing.mDraw then 
		if SkillQ.ready and Settings.drawing.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
		end
		if SkillW.ready and Settings.drawing.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, RGB(Settings.drawing.wColor[2], Settings.drawing.wColor[3], Settings.drawing.wColor[4]))
		end
		if SkillE.ready and Settings.drawing.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, RGB(Settings.drawing.eColor[2], Settings.drawing.eColor[3], Settings.drawing.eColor[4]))
		end
		if SkillR.ready and Settings.drawing.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, RGB(Settings.drawing.rColor[2], Settings.drawing.rColor[3], Settings.drawing.rColor[4]))
		end
		if Settings.drawing.myHero then
			DrawCircle(myHero.x, myHero.y, myHero.z, 600, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
		end
	end
end
 
function GetCustomTarget()
	TargetSelector:update()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1100) and SelectedTarget.type == myHero.type then
		return SelectedTarget
	end
	if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
		return TargetSelector.target
	else
		return nil
	end
end

function CustomOnTick()
	TargetSelector:update()
	Target = GetCustomTarget()
	if SAC then
		if _G.AutoCarry.Keys.AutoCarry then
			_G.AutoCarry.Orbwalker:Orbwalk(Target)
		end
	end
	
	ComboKey = Settings.combo.comboKey
	autoR = Settings.SSettings.Rset.autoR
	autoE = Settings.SSettings.Eset.autoE
	Checks()
	
	CancelR()
	KS()
	DetQ()
	
	if autoE then
		CastE()
	end
	
	if Target ~= nil then
		if ComboKey then
			Combo(Target)
		end
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Settings.combo.useQ then
			CastQ(unit)
		end
		
		if Settings.combo.useE then
			CastE()
		end
		
		if Settings.combo.useR then
			CastR(unit)
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
 
function Menu()
	Settings = scriptConfig("MyAnivia", "Zopper")
   
	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings (SBTW)", "combo")
		Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useR", "Use (R) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:permaShow("comboKey")

	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")      
		Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("qDraw", "Draw "..SkillQ.name.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("qColor", "Draw "..SkillQ.name.." (Q) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("wDraw", "Draw "..SkillW.name.." (W) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("wColor", "Draw "..SkillW.name.." (W) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("eColor", "Draw "..SkillE.name.." (E) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("rColor", "Draw "..SkillR.name.." (R) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)
   
	Settings:addSubMenu("["..myHero.charName.."] - Skill Settings", "SSettings")

		Settings.SSettings:addSubMenu("["..myHero.charName.."] - Q Settings", "Qset")
			Settings.SSettings.Qset:addParam("Qdet", "Detonate Q on 1st contact", SCRIPT_PARAM_ONOFF, true)
			Settings.SSettings.Qset:addParam("rand1", "if ^ is false, will detonate on target only", SCRIPT_PARAM_INFO, "")
			
		Settings.SSettings:addSubMenu("["..myHero.charName.."] - E Settings", "Eset")	
			Settings.SSettings.Eset:addParam("autoE", "Auto E", SCRIPT_PARAM_ONOFF, true)
			Settings.SSettings.Eset:addParam("Echilled", "Only E chilled targets", SCRIPT_PARAM_ONOFF, true)
			
		Settings.SSettings:addSubMenu("["..myHero.charName.."] - R Settings", "Rset")	
			Settings.SSettings.Rset:addParam("cancelR", "Cancel ULT", SCRIPT_PARAM_ONOFF, true)
			Settings.SSettings.Rset:addParam("autoR", "Cast ULT automatically on stunned", SCRIPT_PARAM_ONOFF, true)
		
	Settings:addSubMenu("["..myHero.charName.."] - KS", "KS")
		Settings.KS:addParam("ksQ", "KS with Q", SCRIPT_PARAM_ONOFF, true)
		Settings.KS:addParam("ksE", "KS with E", SCRIPT_PARAM_ONOFF, true)
		Settings.KS:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
		Settings.KS:addParam("ksIgnite", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)
   
	TargetSelector.name = "Anivia"
		Settings:addTS(TargetSelector)

	if SOWp then
		Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SOWi:LoadToMenu(Settings.Orbwalking)
	end   
	
	Settings:addParam("pred", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "DivinePred", "HPred"})
end
 
function Variables()
	SkillQ = { name = "Flash Frost", range = 1100, delay = 0.25, speed = 850, width = 150, ready = false }
	SkillW = { name = "Crystallize", range = 1000, delay = 0.5, speed = math.huge, width = nil, ready = false }
	SkillE = { name = "Frostbite", range = 650, delay = nil, speed = math.huge, width = nil, ready = false }
	SkillR = { name = "Glacial Storm", range = 625, delay = 0.25, speed = math.huge, width = 210, ready = false }
	
	Qobject = nil
	Robject = nil
	Rscript = false
	
	myEnemyTable = GetEnemyHeroes()
	Champ = { }
	for i, enemy in pairs(myEnemyTable) do
			Champ[i] = enemy.charName
	end
   
	local ts
	local Target

	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
end

function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
end

function OnProcessSpell(object, spell)
	if spell.name == myHero:GetSpellData(_Q).name then
		Qobject = object
	end
end

function OnCreateObj(object)
	if object.name == "cryo_FlashFrost_Player_mis.troy" then
		Qobject = object
	end
	
	if object.name == "cryo_storm_green_team.troy" then
		Robject = object
	end
end

function OnApplyBuff(source, unit, buff)
	if buff.name == "Stun" then
		for i, enemy in pairs(myEnemyTable) do
            if unit.name == enemy.name then
				if autoR then
					Rscript = true
					CastSpell(_R, unit.x, unit.z)
				end
			end
        end
	end
end

function OnDeleteObj(object)
	if object.name == "cryo_FlashFrost_mis.troy" then
		Qobject = nil
	end
	
	if object.name == "cryo_storm_green_team.troy" then
		Robject = nil
		Rscript = false
	end
end

function DetQ()
	if Settings.SSettings.Qset.Qdet then
		for i=1, heroManager.iCount, 1 do
			local champ = heroManager:GetHero(i)
			if champ.team ~= myHero.team and ValidTarget(champ) then
				if champ.dead then return end
			
				if GetDistance(champ, Qobject) < 150 then
					CastSpell(_Q)
				end
			end
		end
	end
end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= SkillQ.range and SkillQ.ready and Qobject == nil and ValidTarget(unit) and not unit.dead then
		if Settings.pred == 1 then
			local castPos, chance, pos = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.width, SkillQ.range, SkillQ.speed, myHero)
			if chance >= 2 then
				CastSpell(_Q, castPos.x, castPos.z)
			end
		elseif Settings.pred == 2 and VIP_USER then
			local targ = DPTarget(unit)
			local state,hitPos,perc = dp:predict(targ, qpred)
			if state == SkillShot.STATUS.SUCCESS_HIT then
				CastSpell(_Q, hitPos.x, hitPos.z)
			end
		elseif Settings.pred == 3 then
			local pos, chance = HPred:GetPredict("Q", unit, myHero) 
			if chance > 0 then
				CastSpell(_Q, pos.x, pos.z)
			end
		end
	end
end    

function CastE()
	for i, enemy in pairs(myEnemyTable) do
        if GetDistance(enemy) <= SkillE.range and ValidTarget(enemy) then
			if SkillE.ready then
				if Settings.SSettings.Eset.Echilled then
					if TargetHaveBuff("chilled", enemy) then
						CastSpell(_E, enemy)
					end
				else
					CastSpell(_E, enemy)
				end
			end
		end
    end
end

function CastR(unit)
	if Robject == nil and SkillR.ready and GetDistance(unit) < SkillR.range then
		Rscript = true
		CastSpell(_R, unit)
	end
end

function CancelR()
	if Robject ~= nil and Rscript == true then
		local rcount = 0
		for i, enemy in pairs(myEnemyTable) do
			if GetDistance(enemy, Robject) < SkillR.range and ValidTarget(enemy) and not enemy.dead then
				rcount = rcount + 1
			end
		end
		
		if rcount == 0 then
			Rscript = false
			CastSpell(_R) 
		end
	end
end

function KS()
	for _, champ in pairs(GetEnemyHeroes()) do
		if ValidTarget(champ) and GetDistance(champ, myHero) < 1100 then
			local Qdmg = getDmg("Q", champ, myHero)
			local Edmg = getDmg("E", champ, myHero)
			local Rdmg = getDmg("R", champ, myHero)
			local Idmg = getDmg("IGNITE", champ, myHero)
			
			if TargetHaveBuff("chilled", champ) then
				Edmg = Edmg * 2
			end
			
			if Settings.KS.ksQ and champ.health < Qdmg * 0.95 and ValidTarget(champ) and GetDistance(champ)<= SkillQ.range then
				CastQ(champ)
			end
			
			if Settings.KS.ksE and GetDistance(champ) <= SkillE.range and champ.health < Edmg * 0.95 and ValidTarget(champ) then
				CastSpell(_E, champ)
			end
			
			if Settings.KS.ksR and GetDistance(champ) < SkillR.range and champ.health < Rdmg and ValidTarget(champ) then
				CastR(champ)
			end
			
			if Settings.KS.ksI and GetDistance(champ) < 500 and champ.health < Idmg and ValidTarget(champ) then
				CastSpell(ignite, champ)
			end
		end
	end
end