local version = "1.04"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Nautilus.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Nautilus:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Nautilus.version")
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

if myHero.charName ~= "Nautilus" then return end       
 
--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("QDGFDLIEDKG") 
 
 Interrupt = {
	["Katarina"] = {charName = "Katarina", stop = {["KatarinaR"] = {name = "Death lotus", spellName = "KatarinaR", ult = true }}},
	["Nunu"] = {charName = "Nunu", stop = {["AbsoluteZero"] = {name = "Absolute Zero", spellName = "AbsoluteZero", ult = true }}},
	["Malzahar"] = {charName = "Malzahar", stop = {["AlZaharNetherGrasp"] = {name = "Nether Grasp", spellName = "AlZaharNetherGrasp", ult = true}}},
	["Caitlyn"] = {charName = "Caitlyn", stop = {["CaitlynAceintheHole"] = {name = "Ace in the hole", spellName = "CaitlynAceintheHole", ult = true, projectileName = "caitlyn_ult_mis.troy"}}},
	["FiddleSticks"] = {charName = "FiddleSticks", stop = {["Crowstorm"] = {name = "Crowstorm", spellName = "Crowstorm", ult = true}}},
	["Galio"] = {charName = "Galio", stop = {["GalioIdolOfDurand"] = {name = "Idole of Durand", spellName = "GalioIdolOfDurand", ult = true}}},
	["MissFortune"] = {charName = "MissFortune", stop = {["MissFortune"] = {name = "Bullet time", spellName = "MissFortuneBulletTime", ult = true}}},
	["Pantheon"] = {charName = "Pantheon", stop = {["PantheonRJump"] = {name = "Skyfall", spellName = "PantheonRJump", ult = true}}},
	["Shen"] = {charName = "Shen", stop = {["ShenStandUnited"] = {name = "Stand united", spellName = "ShenStandUnited", ult = true}}},
	["Urgot"] = {charName = "Urgot", stop = {["UrgotSwap2"] = {name = "Position Reverser", spellName = "UrgotSwap2", ult = true}}},
	["Warwick"] = {charName = "Warwick", stop = {["InfiniteDuress"] = {name = "Infinite Duress", spellName = "InfiniteDuress", ult = true}}},
}
 
function OnLoad()
        CheckVPred()
       
        if FileExist(LIB_PATH .. "/VPrediction.lua") and FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
			DelayAction(function() 
				CustomOnLoad()
				AddMsgCallback(CustomOnWndMsg)
				AddDrawCallback(CustomOnDraw)          
				AddProcessSpellCallback(CustomOnProcessSpell)
				AddTickCallback(CustomOnTick)
				AddUpdateBuffCallback(CustomUpdateBuff)	
				AddRemoveBuffCallback(CustomRemoveBuff) 					
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
                Sx = false
        else
                Sx = true
                SAC = false
                require "SxOrbWalk"
        end
        TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_MAGICAL, false, true)
        Variables()
        Menu()
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
	Checks()
	if Target ~= nil then
			if ComboKey then
					Combo(Target)
					applyPassive()
			end
	end
end
 
function CustomOnDraw()
        if not myHero.dead and not Settings.drawing.mDraw then 
                if SkillQ.ready then
                        DrawCircle(myHero.x, myHero.y, myHero.z, Settings.combo.rangeQ, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
                end
                if SkillE.ready and Settings.drawing.eDraw then
                        DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, RGB(Settings.drawing.eColor[2], Settings.drawing.eColor[3], Settings.drawing.eColor[4]))
                end
               
                if Settings.drawing.myHero then
                        DrawCircle(myHero.x, myHero.y, myHero.z, MyTrueRange, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
                end
        end
end
 
function GetCustomTarget()
        TargetSelector:update()
        if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1000) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
                return SelectedTarget
        end
        if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
                return TargetSelector.target
        else
                return nil
        end
end
 
function Combo(unit)
        if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
                if Settings.combo.useQ then
                        CastQ(unit)
                end
               
                if Settings.combo.useW then
                        CastW(unit)
                end
               
                if Settings.combo.useE then
                        CastE(unit)
                end
        end
end
 
function CastQ(unit)
        if (unit.charName == Champ[1] and Settings.qSettings.champ1) or (unit.charName == Champ[2] and Settings.qSettings.champ2) or (unit.charName == Champ[3] and Settings.qSettings.champ3) or (unit.charName == Champ[4] and Settings.qSettings.champ4) or (unit.charName == Champ[5] and Settings.qSettings.champ5) then
                if unit ~= nil and GetDistance(unit) <= Settings.combo.rangeQ and SkillQ.ready then                    
                        if Settings.prediction.prediction == 1 and VIP_USER then
                                local enemy = DPTarget(unit)
                                local State, Position, perc = DP:predict(enemy, myQ)
                                if State == SkillShot.STATUS.SUCCESS_HIT then
                                        CastSpell(_Q, Position.x, Position.z)
                                end
                        else
                                CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.width,Settings.combo.rangeQ, SkillQ.speed, myHero, true)       
                                if HitChance >= 2 then
                                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                                end
                        end
                end
        end
end    
 
function CastE(unit)
        if SkillE.ready and GetDistance(unit) <= SkillE.range then
                CastSpell(_E)
        end
end
       
function CastW(unit)
        if SkillW.ready and GetDistance(unit) <= SkillW.range then
                CastSpell(_W)
        end    
end

function applyPassive()
	for i, enemy in pairs(myEnemyTable) do
		if ValidTarget(enemy) and GetDistance(enemy) < MyTrueRange and passiveBuff[enemy.name] == false then
			myHero:Attack(enemy)
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
        Settings = scriptConfig("Nautilus", "Zopper")
       
        Settings:addSubMenu("["..myHero.charName.."] - Combo Settings (SBTW)", "combo")
                Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
                Settings.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
                Settings.combo:addParam("rangeQ","Max Q Range for Grab", SCRIPT_PARAM_SLICE, 950, 600, 950, 0)
                Settings.combo:addParam("useW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
                Settings.combo:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
                Settings.combo:permaShow("comboKey")
               
        Settings:addSubMenu("["..myHero.charName.."] - (Q) Settings", "qSettings")     
                if Champ[1] ~= nil then Settings.qSettings:addParam("champ1", "Use on "..Champ[1], SCRIPT_PARAM_ONOFF, true) end
                if Champ[2] ~= nil then Settings.qSettings:addParam("champ2", "Use on "..Champ[2], SCRIPT_PARAM_ONOFF, true) end
                if Champ[3] ~= nil then Settings.qSettings:addParam("champ3", "Use on "..Champ[3], SCRIPT_PARAM_ONOFF, true) end
                if Champ[4] ~= nil then Settings.qSettings:addParam("champ4", "Use on "..Champ[4], SCRIPT_PARAM_ONOFF, true) end
                if Champ[5] ~= nil then Settings.qSettings:addParam("champ5", "Use on "..Champ[5], SCRIPT_PARAM_ONOFF, true) end
       
		Settings:addSubMenu("["..myHero.charName.."] - Auto-Interrupt", "interrupt")
		Settings.interrupt:addParam("qqq", "------ Spells to interrupt ------", SCRIPT_PARAM_INFO, "")
		for i, a in pairs(myEnemyTable) do
			if Interrupt[a.charName] ~= nil then
				for i, spell in pairs(Interrupt[a.charName].stop) do
					if spell.ult == true then
						Settings.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
			end
		end
	   
        Settings:addSubMenu("["..myHero.charName.."] - Prediction", "prediction")      
                Settings.prediction:addParam("prediction", "0: VPrediction | 1: DivinePred", SCRIPT_PARAM_SLICE, 0, 0, 1, 0)
 
        Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")      
                Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
                Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
                Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
                Settings.drawing:addParam("qDraw", "Draw "..SkillQ.name.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
                Settings.drawing:addParam("qColor", "Draw "..SkillQ.name.." (Q) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
                Settings.drawing:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
                Settings.drawing:addParam("eColor", "Draw "..SkillE.name.." (E) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
                Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)
       
        TargetSelector.name = "Nautilus"
                Settings:addTS(TargetSelector)
 
        if Sx then
                Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
                SxOrb:LoadToMenu(Settings.Orbwalking)
        end
       
end
 
function Variables()
        SkillQ = { name = "Dredge Line", range = 950, delay = 0.5, speed = 2000, width = 150, ready = false }
        SkillW = { name = "Titan's Wrath", range = 600, delay = nil, speed = math.huge, width = nil, ready = false }
        SkillE = { name = "Riptide", range = 500, delay = 0.5, speed = math.huge, width = nil, ready = false }
        SkillR = { name = "Depth Charge", range = 850, delay = 0.5, speed = math.huge, width = nil, ready = false }
       
	    myEnemyTable = GetEnemyHeroes()
        Champ = {}
		passiveBuff = {}
		MyTrueRange = myHero.range + GetDistance(myHero.minBBox)
		
        for i, enemy in pairs(myEnemyTable) do
                Champ[i] = enemy.charName
				passiveBuff[enemy.name] = false
        end
       
        local ts
        local Target
 
        _G.oldDrawCircle = rawget(_G, 'DrawCircle')
        _G.DrawCircle = DrawCircle2
end
 
function OnProcessSpell(object, spellProc)
	if myHero.dead then return end
	if object.team ~= myHero.team then
		if Interrupt[object.charName] ~= nil then
			spell = Interrupt[object.charName].stop[spellProc.name]
			if spell ~= nil and spell.ult == true then
				if GetDistance(object) < SkillR.range and SkillR.ready then
					CastSpell(_R, object.x, object.z)	
				end
			end
		end
	end
end

function CustomUpdateBuff(unit, buff)
	if unit and buff then
		if buff.name == "nautiluspassiveroot" and unit.type == myHero.type then
			passiveBuff[unit.name] = true
		end
	end
end

function CustomRemoveBuff(unit, buff)
	if unit and buff then
		if buff.name == "nautiluspassivecheck" and unit.type == myHero.type then
			passiveBuff[unit.name] = false
		end
	end
end
 
function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
end