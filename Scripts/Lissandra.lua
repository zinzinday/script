local version = "1.04"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Lissandra.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Lissandra:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Lissandra.version")
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

if myHero.charName ~= "Lissandra" then return end   

--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNMLPLLRRR") 

if FileExist(LIB_PATH .. "/VPrediction.lua") then
	require "VPrediction"
else
	PrintChat("This script wont work without VPrediction. Please download it.")
	return
end

if FileExist(LIB_PATH .. "/HPrediction.lua") then
	require "HPrediction"
	useHP = true
else
	useHP = false
	PrintChat("For better prediction please download HPrediction. The script WILL work without it though.")
end

if VIP_USER then
	if FileExist(LIB_PATH .. "/DivinePred.lua") then
		require "DivinePred" 
		useDP = true
		dp = DivinePred()
		qpred = LineSS(2250, 725, 100, 0.25, math.huge)
		epred = LineSS(850, 1050, 110, 0.25, math.huge)
		
	else
		useDP = false
		PrintChat("For better prediction please download DPrediction. The script WILL work without it though.")
	end
end

----------------------
--     Variables    --
----------------------
loaded = false
pred = nil
informationTable = {}
Champ = {} 
LastFarmRequest = 0

passive = false
eClaw = nil
eEnd = nil
eStart = nil
eTime = 0

MyTrueRange = (550 + GetDistance(myHero.minBBox))

spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false, range = 725,  width = 100, speed = 2250, delay = 0.25, rangeMax = 925}
spells.w = {name = myHero:GetSpellData(_W).name, ready = false, range = 450 - 25} --So that we have a bit of extra space
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 1050,  width = 110, speed = 850, delay = 0.25}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false, range = 550}

Interrupt = {
	["Katarina"] = {charName = "Katarina", stop = {["KatarinaR"] = {name = "Death lotus", spellName = "KatarinaR", ult = true }}},
	["Nunu"] = {charName = "Nunu", stop = {["AbsoluteZero"] = {name = "Absolute Zero", spellName = "AbsoluteZero", ult = true }}},
	["Malzahar"] = {charName = "Malzahar", stop = {["AlZaharNetherGrasp"] = {name = "Nether Grasp", spellName = "AlZaharNetherGrasp", ult = true}}},
	["Caitlyn"] = {charName = "Caitlyn", stop = {["CaitlynAceintheHole"] = {name = "Ace in the hole", spellName = "CaitlynAceintheHole", ult = true, projectileName = "caitlyn_ult_mis.troy"}}},
	["FiddleSticks"] = {charName = "FiddleSticks", stop = {["Crowstorm"] = {name = "Crowstorm", spellName = "Crowstorm", ult = true}}},
	["Galio"] = {charName = "Galio", stop = {["GalioIdolOfDurand"] = {name = "Idole of Durand", spellName = "GalioIdolOfDurand", ult = true}}},
	["Janna"] = {charName = "Janna", stop = {["ReapTheWhirlwind"] = {name = "Monsoon", spellName = "ReapTheWhirlwind", ult = true}}},
	["MissFortune"] = {charName = "MissFortune", stop = {["MissFortune"] = {name = "Bullet time", spellName = "MissFortuneBulletTime", ult = true}}},
	["Pantheon"] = {charName = "Pantheon", stop = {["PantheonRJump"] = {name = "Skyfall", spellName = "PantheonRJump", ult = true}}},
	["Shen"] = {charName = "Shen", stop = {["ShenStandUnited"] = {name = "Stand united", spellName = "ShenStandUnited", ult = true}}},
	["Urgot"] = {charName = "Urgot", stop = {["UrgotSwap2"] = {name = "Position Reverser", spellName = "UrgotSwap2", ult = true}}},
	["Warwick"] = {charName = "Warwick", stop = {["InfiniteDuress"] = {name = "Infinite Duress", spellName = "InfiniteDuress", ult = true}}},
}

isAGapcloserUnit = {
	['Ahri']        = {true, spell = _R, 				  range = 450,   projSpeed = 2200, },
	['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
	['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, },
	['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, },
	['Amumu']       = {true, spell = _Q,                  range = 1100,  projSpeed = 1800, },
	['Corki']       = {true, spell = _W,                  range = 800,   projSpeed = 650,  },
	['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, },
	['Darius']      = {true, spell = _R,                  range = 460,   projSpeed = math.huge, },
	['Fiora']       = {true, spell = _Q,                  range = 600,   projSpeed = 2000, },
	['Fizz']        = {true, spell = _Q,                  range = 550,   projSpeed = 2000, },
	['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
	['Graves']      = {true, spell = _E,                  range = 425,   projSpeed = 2000, exeption = true },
	['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
	['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, },
	['JarvanIV']    = {true, spell = _Q,                  range = 770,   projSpeed = 2000, },
	['Jax']         = {true, spell = _Q,                  range = 700,   projSpeed = 2000, },
	['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, },
	['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
	['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
	--['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
	['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
	['Lucian']      = {true, spell = _E,                  range = 425,   projSpeed = 2000, },
	['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500, },
	['Maokai']      = {true, spell = _W,                  range = 525,   projSpeed = 2000, },
	['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, },
	['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
	['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, },
	['Riven']       = {true, spell = _E,                  range = 150,   projSpeed = 2000, },
	['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
	['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
	['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
	['Shyvana']     = {true, spell = _R,                  range = 1000,  projSpeed = 2000, },
	['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
	['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
	['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, },
	['Yasuo']       = {true, spell = _E,                  range = 475,   projSpeed = 1000, },
	['Vayne']       = {true, spell = _Q,                  range = 300,   projSpeed = 1000, },
}

-- Spell cooldown check
function readyCheck()
	spells.q.ready, spells.w.ready, spells.e.ready, spells.r.ready = (myHero:CanUseSpell(_Q) == READY), (myHero:CanUseSpell(_W) == READY), (myHero:CanUseSpell(_E) == READY), (myHero:CanUseSpell(_R) == READY)
end

-- Orbwalker check
function orbwalkCheck()
	if _G.AutoCarry then
		PrintChat("SA:C detected, support enabled.")
		SACLoaded = true
	elseif _G.MMA_Loaded then
		PrintChat("MMA detected, support enabled.")
		MMALoaded = true
	else
		PrintChat("SA:C/MMA not running, loading SxOrbWalk.")
		require("SxOrbWalk")
		SxMenu = scriptConfig("SxOrbWalk", "SxOrb")
		SxOrb:LoadToMenu(SxMenu)
		SACLoaded = false
	end
end

----------------------
--   Calculations   --
----------------------

function getTarg()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then _G.AutoCarry.Crosshair:SetSkillCrosshairRange(1200) return _G.AutoCarry.Crosshair:GetTarget() end		
	if ValidTarget(SelectedTarget) then return SelectedTarget end
	if MMALoaded and ValidTarget(_G.MMA_Target) then return _G.MMA_Target end
	return ts.target
end

function GetCountInPos(pos, radius, arrray)
    local n = 0
    for _, enemy in pairs(EnemyMinions.objects) do
        if GetDistanceSqr(pos, enemy) <= radius * radius and ValidTarget(enemy) then n = n + 1 end 
    end
    return n
end

function getHealthPercent(unit)
    local obj = unit or myHero
    return (obj.health / obj.maxHealth) * 100
end

function getManaPercent(unit)
    local obj = unit or myHero
    return (obj.mana / obj.maxMana) * 100
end

function pointOnLine(eEnd, eStart, unit, extra)
		local toUnit = {x = unit.x - eStart.x, z = unit.z - eStart.z}
		local toEnd = {x = eEnd.x - eStart.x, z = eEnd.z - eStart.z}

		local magitudeToEnd = toEnd.x ^ 2 + toEnd.z ^ 2
		local dotP = toUnit.x * toEnd.x + toUnit.z * toEnd.z

		local distance = dotP / magitudeToEnd

		return eStart.x + toEnd.x * (distance + extra), eStart.z + toEnd.z * (distance + extra)
end

function GetBestLineFarmPosition(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local EndPos = Vector(myHero) + range * (Vector(object) - Vector(myHero)):normalized()
        local hit = CountObjectsOnLineSegment(myHero, EndPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object--Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
        local w = width --+ Prediction.VP:GetHitBox(object) / 3
        if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
            n = n + 1
        end
    end
    return n
end

function Normalize(pos, start, range)
	local castX = start.x + range * ((pos.x - start.x) / GetDistance(pos))
	local castZ = start.z + range * ((pos.z - start.z) / GetDistance(pos))
	
	return {x = castX, z = castZ}
end

----------------------
--      Hooks       --
----------------------

-- Init hook
function OnLoad()
	if not loaded then
		loaded = true
		print("<font color='#009DFF'>[Lissandra]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

		if autoupdate then
			update()
		end

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, spells.w.range + spells.e.range, DAMAGE_PHYSICAL, true)
		EnemyMinions = minionManager(MINION_ENEMY, spells.q.rangeMax, myHero, MINION_SORT_MAXHEALTH_DEC)
		pred = VPrediction()
		
		if useHP then
			HPred = HPrediction()
			HPred:AddSpell("Q", 'Lissandra', {delay = spells.q.delay, range = spells.q.range, speed = spells.q.speed, type = "DelayLine", width = spells.q.width})
			HPred:AddSpell("E", 'Lissandra', {delay = spells.e.delay, range = spells.e.range, speed = spells.e.speed, type = "DelayLine", width = spells.e.width})
		end
		
		for i, enemy in pairs(GetEnemyHeroes()) do 
			Champ[i] = enemy.charName
		end
		
		Menu()
	end
	
	if _G.Reborn_Initialised then
        orbwalkCheck()
    elseif _G.Reborn_Loaded then
        DelayAction(OnLoad, 1)
        return
    else
        orbwalkCheck()
    end
end

-- Tick hook
function OnTick()
	if spells.e.ready and spells.w.ready then
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, spells.w.range + spells.e.range, DAMAGE_PHYSICAL, true)
	elseif not spells.w.ready and spells.e.ready then
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, spells.e.range, DAMAGE_PHYSICAL, true)
	elseif not spells.e.ready then
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, spells.q.rangeMax, DAMAGE_PHYSICAL, true)
	end

	readyCheck()
	Target = getTarg()
	
	Killsteal()
	CastWGap()
	Zhonya()
	
	if settings.combo.wAuto then		
		CastW(Target)
	end
	
	if settings.clear.clearKey then
		Clear()
	end
	
	if settings.combo.comboKey then
		if settings.combo.e then
			CastE(Target, "E")
			CastE2(Target)
		end
		
		if settings.combo.ew then
			CastE(Target, "EW")
			CastE2(Target)
		end
		
		if settings.combo.r then
			CastR(Target, true)
		end
		
		if settings.combo.q then
			CastQ(Target)
			
			for i, enemy in pairs(GetEnemyHeroes()) do
				CastQ(enemy)
			end
		end
	end
		
	if (settings.q.autoQ or settings.q.autoQKeyPress) and (getManaPercent(myHero) > settings.q.autoQmana or passive) then
		CastQ(Target)
	end
end

-- Drawing hook
function OnDraw()
	if myHero.dead then return end

	Target = getTarg()
	
	if ValidTarget(Target) then
		DrawCircle(Target.x, Target.y, Target.z, 150, 0xffffff00)
	end
	
	if settings.draw.q and spells.q.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.q.range, 0xFFFF0000)
	end

	if settings.draw.w and spells.w.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.w.range, 0xFFFF0000)
	end

	if settings.draw.e and spells.e.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.e.range, 0xFFFF0000)
	end
	
	if settings.draw.r and spells.r.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.r.range, 0xFFFF0000)
	end
	
	if settings.draw.ew and spells.e.ready and spells.w.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.e.range + spells.w.range - 50, 0xFFFF0000)
	end
end

function OnProcessSpell(object, spellProc)
	if myHero.dead then return end
	if object.team == myHero.team then return end
	
	if Interrupt[object.charName] ~= nil then
		spell = Interrupt[object.charName].stop[spellProc.name]
		if spell ~= nil then
			if settings.interrupt[spellProc.name] then
				if GetDistance(object) < settings.interrupt.interruptRange and spells.r.ready and settings.interrupt.r then
					CastSpell(_R, object)
				end
			end
		end
	end
	
	unit = object
	spell = spellProc
	
	if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then			
		if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and settings.gapClose[unit.charName] then
			if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
				CastW(unit)
			else
				spellExpired = false
				informationTable = {
					spellSource = unit,
					spellCastedTick = GetTickCount(),
					spellStartPos = Point(spell.startPos.x, spell.startPos.z),
					spellEndPos = Point(spell.endPos.x, spell.endPos.z),
					spellRange = isAGapcloserUnit[unit.charName].range,
					spellSpeed = isAGapcloserUnit[unit.charName].projSpeed,
					spellIsAnExpetion = isAGapcloserUnit[unit.charName].exeption or false,
				}
			end
		end
	end
end

function OnCreateObj(object)
	if object.name == "Lissandra_Base_E_End.troy" then
		eEnd = object
		eTime = os.clock() * 1000
	end
	
	if object.name == "Lissandra_Base_E_Cast.troy" then
		eStart = object
	end
	
	if object.name == "LineMissile" and os.clock() * 1000 - eTime < 500 then
		eClaw = object
	end
	
	if object.name == "Lissandra_Base_Passive_Ready.troy" then
		passive = true
	end
end

function OnDeleteObj(object)
	if object.name == "Lissandra_Base_E_End.troy" and eEnd then
		eEnd = nil
	end
	
	if object.name == "Lissandra_Base_E_Cast.troy" then
		eStart = nil
	end
	
	if object.name == "LineMissile" and eClaw and GetDistance(eClaw, eEnd) < 50 then
		eClaw = nil
	end
	
	if object.name == "Lissandra_Base_Passive_Ready.troy" then
		passive = false
	end
end

-- Menu creation
function Menu()
	settings = scriptConfig("Lissandra", "Zopper")
	TargetSelector.name = "Lissandra"
	settings:addTS(ts)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Combo", "combo")
		settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		settings.combo:addParam("q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("w", "Use W", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("e", "Use E", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("ew", "Use E + W combo", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("r", "Use R", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("wAuto", "Use W Automatically if Target in range", SCRIPT_PARAM_ONOFF, true)
		settings.combo:permaShow("comboKey")
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto Q", "q")
		settings.q:addParam("autoQ", "Auto Q Toggle", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
		settings.q:addParam("autoQKeyPress", "Auto Q Key Press", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		settings.q:addParam("autoQmana", "Minimum Mana", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
		settings.q:permaShow("autoQ")
		settings.q:permaShow("autoQKeyPress")
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Dont die", "die")
		settings.die:addParam("zhonya", "Use Zhonyas", SCRIPT_PARAM_ONOFF, true)
		settings.die:addParam("zhonyaHP", "Max HP when using Zhonya", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Lane Clear", "clear")
		settings.clear:addParam("clearKey", "Lane Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		settings.clear:addParam("mana", "Minimum Mana", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
		settings.clear:addParam("useQ", "Use Q if x minions", SCRIPT_PARAM_SLICE, 3, 0, 10, 0)
		settings.clear:addParam("useW", "Use W if x minions", SCRIPT_PARAM_SLICE, 3, 0, 10, 0)
		settings.clear:addParam("useE", "Use E if x minions", SCRIPT_PARAM_SLICE, 3, 0, 10, 0)
		settings.clear:permaShow("clearKey")
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Killsteal Settings", "ks")
		settings.ks:addParam("q", "KS with Q", SCRIPT_PARAM_ONOFF, true)
		settings.ks:addParam("w", "KS with W", SCRIPT_PARAM_ONOFF, true)
		settings.ks:addParam("e", "KS with E", SCRIPT_PARAM_ONOFF, true)
		settings.ks:addParam("r", "KS with R", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("["..myHero.charName.."] - (R) Settings (in combo)", "r")	
		if Champ[1] ~= nil then settings.r:addParam("champ1", "Use on "..Champ[1], SCRIPT_PARAM_ONOFF, true) end
		if Champ[2] ~= nil then settings.r:addParam("champ2", "Use on "..Champ[2], SCRIPT_PARAM_ONOFF, true) end
		if Champ[3] ~= nil then settings.r:addParam("champ3", "Use on "..Champ[3], SCRIPT_PARAM_ONOFF, true) end
		if Champ[4] ~= nil then settings.r:addParam("champ4", "Use on "..Champ[4], SCRIPT_PARAM_ONOFF, true) end
		if Champ[5] ~= nil then settings.r:addParam("champ5", "Use on "..Champ[5], SCRIPT_PARAM_ONOFF, true) end
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Drawing", "draw")
		settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("r", "Draw R", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("ew", "Draw EW", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto-Interrupt", "interrupt")
		settings.interrupt:addParam("r", "Interrupt with R", SCRIPT_PARAM_ONOFF, true)
		for i, a in pairs(GetEnemyHeroes()) do
			if Interrupt[a.charName] ~= nil then
				for i, spell in pairs(Interrupt[a.charName].stop) do
					settings.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
				end
			end
		end
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Anti Gap-Close", "gapClose")
		for _, enemy in pairs(GetEnemyHeroes()) do
			if isAGapcloserUnit[enemy.charName] ~= nil then
				settings.gapClose:addParam(enemy.charName, enemy.charName .. " - " .. enemy:GetSpellData(isAGapcloserUnit[enemy.charName].spell).name, SCRIPT_PARAM_ONOFF, true)
			end
		end
	
    settings:addParam("pred", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "DivinePred", "HPrediction"})
end


--Lag Free Circles
function DrawCircle(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(40, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
		
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)	
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

----------------------
--  Cast functions  --
----------------------

function CastQ(unit)
	if ValidTarget(unit) and spells.q.ready then
		if GetDistance(unit) < spells.q.range then
			CastQ2(unit)
		elseif GetDistance(unit) < spells.q.rangeMax then
			local collision = false
			local x, z = 0, 0
		
			EnemyMinions:update()
			for i, minion in pairs(EnemyMinions.objects) do
				if minion ~= nil and not minion.dead and GetDistance(minion) <= spells.q.range then
					x, z = pointOnLine(myHero, unit, minion, 0)
					
					if math.sqrt((minion.x - x) ^ 2 + (minion.z - z) ^ 2) < spells.q.width / 2 then
						collision = true
					end
				end
			end
			
			if collision == true and GetDistance(unit) < spells.q.rangeMax then
				Position = pred:GetPredictedPos(unit, spells.q.delay + (GetDistance(unit) / spells.q.speed))
			
				local castX = myHero.x + spells.q.range * ((Position.x - myHero.x) / GetDistance(Position))
				local castZ = myHero.z + spells.q.range * ((Position.z - myHero.z) / GetDistance(Position))
				
				CastSpell(_Q, castX, castZ)
			end
		end
	end
end

function CastQ2(unit)
	if ValidTarget(unit) and GetDistance(unit) <= spells.q.rangeMax and spells.q.ready then
			if settings.pred == 1 then
				local castPos, chance, pos = pred:GetLineCastPosition(unit, spells.q.delay, spells.q.width, spells.q.range, spells.q.speed, myHero, false)
				if chance >= 2 then
					CastSpell(_Q, castPos.x, castPos.z)
				end
			elseif settings.pred == 2 and VIP_USER and useDP then
				local targ = DPTarget(unit)
				local state,hitPos,perc = dp:predict(targ, qpred)
				if  state == SkillShot.STATUS.SUCCESS_HIT then
					CastSpell(_Q, hitPos.x, hitPos.z)
				end
			elseif settings.pred == 3 and useHP then
				local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
  
				if QHitChance > 0 then
					CastSpell(_Q, QPos.x, QPos.z)
				end
			end
		end
end

function CastW(unit)
	if ValidTarget(unit) and GetDistance(unit) <= spells.w.range and spells.w.ready then
		CastSpell(_W)
	end
end

function CastWGap()
	if spells.e.ready and informationTable.spellCastedTick ~= nil then
		if not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 then
			local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
			local spellStartPosition = informationTable.spellStartPos + spellDirection
			local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
			local heroPosition = Point(myHero.x, myHero.z)

			local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))

			if lineSegment:distance(heroPosition) <= (not informationTable.spellIsAnExpetion and 65 or 200) then
				CastW(informationTable.spellSource)
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end
end

function CastE(unit, combo)
	if combo == "E" then
		if ValidTarget(unit) and GetDistance(unit) <= spells.e.range and eEnd == nil and spells.e.ready then
			if settings.pred == 1 then
				local castPos, chance, pos = pred:GetLineCastPosition(unit, spells.e.delay, spells.e.width, spells.e.range, spells.e.speed, myHero, false)
				if chance >= 2 then
					CastSpell(_E, castPos.x, castPos.z)
				end
			elseif settings.pred == 2 and VIP_USER and useDP then
				local targ = DPTarget(unit)
				local state,hitPos,perc = dp:predict(targ, epred)
				if  state == SkillShot.STATUS.SUCCESS_HIT then
					CastSpell(_E, hitPos.x, hitPos.z)
				end
			elseif settings.pred == 3 and useHP then
				local EPos, EHitChance = HPred:GetPredict("E", unit, myHero)
  
				if EHitChance > 0 then
					CastSpell(_E, EPos.x, EPos.z)
				end
			end
		end
	elseif combo == "EW" then
		if ValidTarget(unit) and eEnd == nil and spells.e.ready then
			if GetDistance(unit) < spells.e.range then
				CastE(unit, "E")
			else
				local Position = pred:GetPredictedPos(unit, spells.e.delay + (spells.e.range / spells.e.speed))
				
				if GetDistance(Position) < spells.e.range + spells.w.range then
					CastSpell(_E, Position.x, Position.z)
				end
			end
		end
	end
end

function CastE2(unit)
	if ValidTarget(unit) and eClaw ~= nil and eStart ~= nil and eEnd ~= nil then
		local x, z = pointOnLine(eStart, eEnd, unit, 50)
		
		if math.sqrt((eStart.x - x) ^ 2 + (eStart.z - z) ^ 2) > spells.e.range  then
			x = eEnd.x
			z = eEnd.z
		end
		
		if math.sqrt((eClaw.x - x) ^ 2 + (eClaw.z - z) ^ 2) < 50 then
			CastSpell(_E)
		end
	end
	
	if eClaw ~= nil and eStart ~= nil and eEnd ~= nil then
	if math.sqrt((eClaw.x - eEnd.x) ^ 2 + (eClaw.z - eEnd.z) ^ 2) < 50 then
		CastSpell(_E)
	end
	end
end

function CastR(unit, enemy)
	if enemy and ValidTarget(unit) then
		if (unit.charName == Champ[1] and settings.r.champ1) or (unit.charName == Champ[2] and settings.r.champ2) or (unit.charName == Champ[3] and settings.r.champ3) or (unit.charName == Champ[4] and settings.r.champ4) or (unit.charName == Champ[5] and settings.r.champ5) then
			if ValidTarget(unit) and GetDistance(unit) <= spells.r.range and spells.r.ready then
				CastSpell(_R, unit)
			end
		end
	elseif unit == false then
		if spells.r.ready then
			CastSpell(_R, unit)
		end
	end
end

function Killsteal()
	for i, enemy in pairs(GetEnemyHeroes()) do
		if settings.ks.q and getDmg("Q", enemy, myHero) * 0.95 > enemy.health then CastQ(enemy) end
		if settings.ks.w and getDmg("W", enemy, myHero) * 0.95 > enemy.health then CastW(enemy) end
		if settings.ks.e and getDmg("E", enemy, myHero) * 0.95 > enemy.health then CastE(enemy, "E") end
		if settings.ks.r and getDmg("R", enemy, myHero) * 0.95 > enemy.health then CastR(enemy, true) end
	end
end

function Zhonya()
	if settings.die.zhonya and getHealthPercent(myHero) < settings.die.zhonyaHP then 
		for slot = ITEM_1, ITEM_7 do
			if myHero:GetSpellData(slot).name == "ZhonyasHourglass" then
				CastSpell(slot)
			end
		end
	end
end

function Clear()
	if getManaPercent(myHero) >= settings.clear.mana then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if ValidTarget(minion, spells.q.rangeMax) and os.clock() - LastFarmRequest > 0.2 then 
                if settings.clear.useE > 0 and spells.e.ready and eStart == nil then
                    local BestPos, Count = GetBestLineFarmPosition(spells.e.range, spells.e.width, EnemyMinions.objects)
                    if BestPos ~= nil and Count >= settings.clear.useE then CastSpell(_E, Normalize(BestPos, myHero, spells.e.range).x, Normalize(BestPos, myHero, spells.e.range).z) end
                end

                if settings.clear.useQ > 0 and spells.q.ready then
                    local BestPos, Count = GetBestLineFarmPosition(spells.q.range, spells.q.width, EnemyMinions.objects)
                    if BestPos ~= nil and Count >= settings.clear.useQ then CastSpell(_Q, Normalize(BestPos, myHero, spells.q.range).x, Normalize(BestPos, myHero, spells.q.range).z) end
                end

                if settings.clear.useW > 0 and spells.w.ready and GetCountInPos(myHero, spells.w.range, EnemyMinions.objects) >= settings.clear.useW then
                    CastSpell(_W)
                end
				
                LastFarmRequest = os.clock()
            end
        end
    end
end