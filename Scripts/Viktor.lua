local version = "1.04"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Viktor.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Viktor:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Viktor.version")
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
if myHero.charName ~= "Viktor" then return end   
--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("QDGFEFKHEJE") 

require("VPrediction")

if VIP_USER and FileExist(LIB_PATH .. "/DivinePred.lua") then 
	require "DivinePred" 
	dp = DivinePred()
	wpred = CircleSS(math.huge,700, 250, 0.75, math.huge)
	epred = LineSS(700 / 0.9,700, 75, 0.1, math.huge)
else
	PrintChat("This script requires Divine Prediction to work")
end

pred = nil
ATTS = 0
----------------------
--     Variables    --
----------------------
orderedEnemies = {}
informationTable = {}

spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false, range = 700, width = nil}
spells.w = {name = myHero:GetSpellData(_W).name, ready = false, range = 700, radius = 250}
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 700, width = 75, speed = 700 / 0.9}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false, range = 700, radius = 325}

Interrupt = {
	["Katarina"] = {charName = "Katarina", stop = {["KatarinaR"] = {name = "Death lotus", spellName = "KatarinaR", ult = true }}},
	["Nunu"] = {charName = "Nunu", stop = {["AbsoluteZero"] = {name = "Absolute Zero", spellName = "AbsoluteZero", ult = true }}},
	["Malzahar"] = {charName = "Malzahar", stop = {["AlZaharNetherGrasp"] = {name = "Nether Grasp", spellName = "AlZaharNetherGrasp", ult = true}}},
	["Caitlyn"] = {charName = "Caitlyn", stop = {["CaitlynAceintheHole"] = {name = "Ace in the hole", spellName = "CaitlynAceintheHole", ult = true, projectileName = "caitlyn_ult_mis.troy"}}},
	["FiddleSticks"] = {charName = "FiddleSticks", stop = {["Crowstorm"] = {name = "Crowstorm", spellName = "Crowstorm", ult = true}}},
	["Galio"] = {charName = "Galio", stop = {["GalioIdolOfDurand"] = {name = "Idole of Durand", spellName = "GalioIdolOfDurand", ult = true}}},
	["Janna"] = {charName = "Janna", stop = {["ReapTheWhirlwind"] = {name = "Monsoon", spellName = "ReapTheWhirlwind", ult = true}}},
	["MissFortune"] = {charName = "MissFortune", stop = {["MissFortune"] = {name = "Bullet time", spellName = "MissFortuneBulletTime", ult = true}}},
	["MasterYi"] = {charName = "MasterYi", stop = {["MasterYi"] = {name = "Meditate", spellName = "Meditate", ult = false}}},
	["Pantheon"] = {charName = "Pantheon", stop = {["PantheonRJump"] = {name = "Skyfall", spellName = "PantheonRJump", ult = true}}},
	["Shen"] = {charName = "Shen", stop = {["ShenStandUnited"] = {name = "Stand united", spellName = "ShenStandUnited", ult = true}}},
	["Urgot"] = {charName = "Urgot", stop = {["UrgotSwap2"] = {name = "Position Reverser", spellName = "UrgotSwap2", ult = true}}},
	["Varus"] = {charName = "Varus", stop = {["VarusQ"] = {name = "Piercing Arrow", spellName = "Varus", ult = false}}},
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
-- Target Calculation
function getTarg(t)
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then _G.AutoCarry.Crosshair:SetSkillCrosshairRange(1200) return _G.AutoCarry.Crosshair:GetTarget() end		
	if ValidTarget(SelectedTarget) and SelectedTarget.type == myHero.type then return SelectedTarget end
	if MMALoaded and ValidTarget(_G.MMA_Target) then return _G.MMA_Target end
	return ts.target
end

function GetEnemyCountInPos(pos, radius)
    local n = 0
    for _, enemy in ipairs(GetEnemyHeroes()) do
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

function FindBestCircle(target, range, radius)
	local points = {}
	
	local rgDsqr = (range + radius) * (range + radius)
	local diaDsqr = (radius * 2) * (radius * 2)

	local Position
	Position = pPredict(target, ATTS + 0.02)

	table.insert(points,Position)
	
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy.networkID ~= target.networkID and not enemy.dead and GetDistanceSqr(enemy) <= rgDsqr and GetDistanceSqr(target,enemy) < diaDsqr then
			Position = pPredict(enemy, ATTS + 0.02)
			table.insert(points, Position)
		end
	end
	
	while true do
		local MECObject = MEC(points)
		local OurCircle = MECObject:Compute()
		
		if OurCircle.radius <= radius then
			return OurCircle.center, #points
		end
		
		local Dist = -1
		local MyPoint = points[1]
		local index = 0
		
		for i=2, #points, 1 do
			local DistToTest = GetDistanceSqr(points[i], MyPoint)
			if DistToTest >= Dist then
				Dist = DistToTest
				index = i
			end
		end
		if index > 0 then
			table.remove(points, index)
		else
			return points[1], 1
		end
	end
end

function pPredict(Target, Delay)
	local Position, HitChance
	
	Position, HitChance = pred:GetPredictedPos(Target, Delay)
	if HitChance == 0 then
		HitChance = 25
	elseif HitChance == 1 then
		HitChance = 50
	elseif HitChance == 2 then
		HitChance = 75
	else
		HitChance = 100
	end
	
	return Position, HitChance
end
----------------------
--      Hooks       --
----------------------

-- Init hook
function OnLoad()
	print("<font color='#009DFF'>[Viktor]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

	if autoupdate then
		update()
	end

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1250, DAMAGE_MAGIC, true)
	pred = VPrediction()
	Menu()

	DelayAction(orbwalkCheck,7)
	AddUpdateBuffCallback(CustomUpdateBuff)		
	
	ATTS = GetLatency() / 2
end

-- Tick hook
function OnTick()
	readyCheck()
	Target = getTarg()
	ATTS = (ATTS + GetLatency() / 2) / 2
	
	if settings.combo.comboKey then
		if settings.combo.w then
			CastW(Target)
		end
		
		if settings.combo.r then
			CastR(Target)
		end
		
		if settings.combo.q then
			CastQ(Target)
		end
		
		if settings.combo.e then
			CastE1(Target)
		end
	end
	
	if settings.harass.harassKey or settings.harass.harassToggle then
		if getManaPercent(myHero) > settings.harass.minMana then
			if settings.harass.q then
				CastQ(Target)
			end
			
			if settings.harass.e then
				CastE1(Target)
			end
		end
	end
	
	CastWGap()
	
	if myHero:GetSpellData(_R).name == "viktorchaosstormguide" and settings.ult.move then
		MoveUlt()
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
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.e.range + 550, 0xFFFF0000)
		DrawCircle(myHero.x, myHero.y, myHero.z, 550, 0xFFFF0000)
	end
end

function OnProcessSpell(object, spellProc)
	if myHero.dead then return end
	if object.team == myHero.team then return end
	
	if Interrupt[object.charName] ~= nil then
		spell = Interrupt[object.charName].stop[spellProc.name]
		if spell ~= nil then
			if settings.interrupt[spellProc.name] then
				if GetDistance(object) < spells.r.range and spells.r.ready and settings.interrupt.r then
					CastSpell(_R, object.x, object.z)
				end
			end
		end
	end
		
	local unit = object
	local spell = spellProc
	
	if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then			
		if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and settings.gapClose[unit.charName] then
			if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
				CastSpell(_W, myHero)
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

-- Menu creation
function Menu()
	settings = scriptConfig("Viktor", "Zopper")
	TargetSelector.name = "Viktor"
	settings:addTS(ts)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Combo", "combo")
		settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		settings.combo:addParam("q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("w", "Use W", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("e", "Use E", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("r", "Use R", SCRIPT_PARAM_ONOFF, true)
		settings.combo:permaShow("comboKey")
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Harass", "harass")
		settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		settings.harass:addParam("harassToggle", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
		settings.harass:addParam("minMana","Min. Mana To Harass", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
		settings.harass:addParam("q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		settings.harass:addParam("e", "Use E", SCRIPT_PARAM_ONOFF, true)
		settings.harass:permaShow("harassKey")
		settings.harass:permaShow("harassToggle") 
	
	settings:addSubMenu("[" .. myHero.charName.. "] - ULT", "ult")
		settings.ult:addParam("range","Move ULT to best target within x units", SCRIPT_PARAM_SLICE, 1000, 0, 1000, 0)
		settings.ult:addParam("move", "Move ULT automatically", SCRIPT_PARAM_ONOFF, true)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto-Interrupt", "interrupt")
		settings.interrupt:addParam("r", "Interrupt with R", SCRIPT_PARAM_ONOFF, true)
		for i, a in pairs(GetEnemyHeroes()) do
			if Interrupt[a.charName] ~= nil then
				for i, spell in pairs(Interrupt[a.charName].stop) do
					settings.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
				end
			end
		end
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Drawing", "draw")
		settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Anti Gap-Close", "gapClose")
		for _, enemy in pairs(GetEnemyHeroes()) do
			if isAGapcloserUnit[enemy.charName] ~= nil then
				settings.gapClose:addParam(enemy.charName, enemy.charName .. " - " .. enemy:GetSpellData(isAGapcloserUnit[enemy.charName].spell).name, SCRIPT_PARAM_ONOFF, true)
			end
		end
	
	--DLib = DamageLib()
	--DLib:RegisterDamageSource(_Q, _MAGIC, 40, 20, _MAGIC, _AP, 0.20, function() return (myHero:CanUseSpell(_Q) == READY) end)
	--DLib:RegisterDamageSource(_E, _MAGIC, 70, 45, _MAGIC, _AP, 0.70, function() return (myHero:CanUseSpell(_E) == READY) end)
	--DLib:RegisterDamageSource(_R, _MAGIC, 150, 100, _MAGIC, _AP, 0.55, function() return (myHero:CanUseSpell(_R) == READY) end)
	--DLib:AddToMenu(settings.draw,{_Q,_E,_R,})
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
	if ValidTarget(unit) and GetDistance(unit) <= spells.q.range and spells.q.ready then
		CastSpell(_Q, unit)
	end
end

function CastW(unit)
	if ValidTarget(unit) and GetDistance(unit) <= spells.w.range then
		local targ = DPTarget(unit)
		local state,hitPos,perc = dp:predict(targ, wpred)
		if spells.w.ready and state == SkillShot.STATUS.SUCCESS_HIT then
			CastSpell(_W, hitPos.x, hitPos.z)
		end
	
	end
end

function CastWGap()
	if spells.w.ready and informationTable.spellCastedTick then
		if not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 then
			local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
			local spellStartPosition = informationTable.spellStartPos + spellDirection
			local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
			local heroPosition = Point(myHero.x, myHero.z)

			local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))

			if lineSegment:distance(heroPosition) <= (not informationTable.spellIsAnExpetion and 65 or 200) then
				CastSpell(_W, myHero)
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end
end

function CastE1(firstTarget)
	if ValidTarget(firstTarget) and spells.e.ready then
		local dist = GetDistance(firstTarget)
			
		local xVector = (540 * firstTarget.x + (dist - 540) * myHero.x) / dist
		local zVector = (540 * firstTarget.z + (dist - 540) * myHero.z) / dist
		
		EndPosition = getEndPosition(Vector(math.floor(xVector),0,math.floor(zVector)), firstTarget)
		
		if EndPosition ~= nil then
			if GetDistance(EndPosition) >= 540 then
				local dist2 = GetDistance(EndPosition)
				local hitPosX = (540 * EndPosition.x + (dist2 - 540) * myHero.x)/dist2
				local hitPosZ = (540 * EndPosition.z + (dist2 - 540) * myHero.z)/dist2

				CastSpell(_E, hitPosX, hitPosZ)
			else
				CastSpell(_E, EndPosition.x, EndPosition.z)
			end
		end
	end
end

function getEndPosition(from, to)
	if from ~= nil and to ~= nil then
		local targ = DPTarget(to)
		local state,hitPos,perc = dp:predict(targ, epred, 1.2, from)
		if state == SkillShot.STATUS.SUCCESS_HIT then
			return hitPos
		end
	end
		
	return nil
end

function CastR(unit)
	if ValidTarget(unit) and GetDistance(unit) <= spells.r.range then
		CastSpell(_R, unit)
	end
end

function MoveUlt()
	local CurrentPos, CurrentNum = nil, 0
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if not enemy.dead and ValidTarget(enemy) then
			local TestPos, TestNum = FindBestCircle(enemy, settings.ult.range, 325)
			local TestDistance = GetDistance(TestPos)
			
			if TestDistance < settings.ult.range then
				TestNum = TestNum + TestDistance / settings.ult.range
			end
			
			if TestNum > CurrentNum then
				CurrentPos = TestPos
				CurrentNum = TestNum
			end
		end
	end
	
	if CurrentPos == nil then
		CastSpell(_R, myHero.x, myHero.z)
	end
	
	if ValidTarget(CurrentPos) then
		CastSpell(_R, CurrentPos)
	end
end