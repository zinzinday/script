local version = "1.21"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Thresh.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Thresh:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Thresh.version")
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

if myHero.charName ~= "Thresh" then return end   

--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("WJMLJROKLOJ") 

require("VPrediction")
require("HPrediction")

if VIP_USER and FileExist(LIB_PATH .. "/DivinePred.lua") then 
	require "DivinePred" 
	dp = DivinePred()
	qpred = LineSS(1900,1100, 100, 0.5, 0)
end

----------------------
--     Variables    --
----------------------

informationTable = {}
loaded = false
pred = nil
qLast = 0

spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false, range = 1100, width = 100}
spells.w = {name = myHero:GetSpellData(_W).name, ready = false, range = 950, width = nil}
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 500, width = nil}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false, range = 450, width = nil}

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
		if true then
			PrintChat("SA:C/MMA not running, loading SxOrbWalk.")
			require("SxOrbWalk")
			SxMenu = scriptConfig("SxOrbWalk", "SxOrbb")
			SxOrb:LoadToMenu(SxMenu)
			SACLoaded = false
		else
			SOWp = true
			SACLoaded = false
			require "SOW"
			
			SOWi = SOW(pred)
			SOWi:RegisterAfterAttackCallback(AutoAttackReset)
			
			settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
			SOWi:LoadToMenu(settings.Orbwalking)
		end
	end
end

----------------------
--  Cast functions  --
----------------------

function CastQ(unit)
	if ValidTarget(unit) and GetDistance(unit) <= settings.combo.qRange and myHero:GetSpellData(_Q).name ~= "threshqleap" then
		if (unit.charName == Champ[1] and settings.q.champ1) or (unit.charName == Champ[2] and settings.q.champ2) or (unit.charName == Champ[3] and settings.q.champ3) or (unit.charName == Champ[4] and settings.q.champ4) or (unit.charName == Champ[5] and settings.q.champ5) then
			if settings.pred == 1 then
				local castPos, chance, pos = pred:GetLineCastPosition(unit, .5, 100, 1100, 1900, myHero, true)
				if  spells.q.ready and chance >= 2 then
					CastSpell(_Q, castPos.x, castPos.z)
				end
			elseif settings.pred == 2 and VIP_USER and os.clock() - qLast > 0.2 then
				qLast = os.clock()
				local targ = DPTarget(unit)
				local state,hitPos,perc = dp:predict(targ, qpred)
				if spells.q.ready and state == SkillShot.STATUS.SUCCESS_HIT then
					CastSpell(_Q, hitPos.x, hitPos.z)
				end
			elseif settings.pred == 3 then
				local pos, chance = HPred:GetPredict("Q", unit, myHero) 
				if chance > 0 and spells.q.ready then
					CastSpell(_Q, pos.x, pos.z)
				end
			end
		end
	end
end

function CastQ2()
	if settings.combo.autoJump and myHero:GetSpellData(_Q).name == "threshqleap" and settings.combo.comboKey then
		DelayAction(function() CastSpell(_Q, myHero) end, ((15 / 1000) * settings.combo.holdQ))
	end
end

function CastWEngage(Target)
	if settings.combo.w and ValidTarget(Target) and GetDistance(Target) <= 200 then	
		local bestAlly = nil
		
		for i = 1, heroManager.iCount, 1 do
            local ally = heroManager:getHero(i)
			
            if ally.team == myHero.team and ally.name ~= myHero.name and not ally.dead then		
				if GetDistance(Target, ally) >= 700 and GetDistance(ally) <= spells.w.range then 
					if ValidTarget(bestAlly) then
						if GetDistance(ally) >= GetDistance(bestAlly) then
							bestAlly = ally
						end
					else
						bestAlly = ally
					end
				end
			end
		end
		
		if bestAlly ~= nil then
			local x, z = wPosition(myHero, bestAlly, 200)
			CastSpell(_W, x, z)
		end
	end
end

function CastWCombo(Target)
	if ValidTarget(Target) and myHero:GetSpellData(_Q).name == "threshqleap" and settings.combo.w then	
		local bestAlly = nil
		
		for i = 1, heroManager.iCount, 1 do
            local ally = heroManager:getHero(i)
			
            if ally.team == myHero.team and ally.name ~= myHero.name  and not ally.dead then		
				if GetDistance(Target, ally) >= 600 and GetDistance(ally) <= spells.w.range then 
					if ValidTarget(bestAlly) then
						if GetDistance(ally) >= GetDistance(bestAlly) then
							bestAlly = ally
						end
					else
						bestAlly = ally
					end
				end
			end
		end
		
		if bestAlly ~= nil then
			local x, z = wPosition(myHero, bestAlly, 200)
			CastSpell(_W, x, z)
		end
	end
end

function CastWLowHP()
	if settings.auto.w then
		for i = 1, heroManager.iCount, 1 do
            local ally = heroManager:getHero(i)
			
            if ally.team == myHero.team  and not ally.dead then
				if ally.health < (ally.maxHealth / 100) * settings.auto.hpW and GetEnemyCountInPos(ally, 600) > 0 then
					if spells.w.ready and GetDistance(ally) < spells.w.range then
						if GetDistance(ally) < 300 then
							local CastPosition,  HitChance,  Position = pred:GetCircularCastPosition(ally, 0.5, 150, 950)
							CastSpell(_W, CastPosition.x, CastPosition.z) 
						else
							local x, z = wPosition(myHero, ally, 200)
							CastSpell(_W, x, z)
						end
					end
				end
			end
		end
	end
end

function CastWOnApproaching()
	if settings.auto.approachingW then
		for i = 1, heroManager.iCount, 1 do
			local ally = heroManager:getHero(i)
				
			if ally.team == myHero.team  and not ally.dead and ally.charName ~= myHero.charName then
				if allies[i] and spells.w.ready and GetDistance(ally) < spells.w.range + 300 and GetDistance(ally) > spells.w.range then
					local allyZ = ally.z - allies[i].z
					local allyX = ally.x - allies[i].x
					local allyAngle = math.atan2(allyZ,allyX) * 180 / math.pi
					
					local playerZ = myHero.z - ally.z
					local playerX = myHero.x - ally.x
					local playerAngle = math.atan2(playerZ,playerX) * 180 / math.pi
					
					if (allyAngle - playerAngle) ^ 2 < 900 then
						local x, z = wPosition(myHero, ally, 300)
						CastSpell(_W, x, z)
					end
				end
			end
		end
	end
end

function CastEPull(Target)
    if settings.combo.e then
		if ValidTarget(Target) and spells.e.ready and GetDistance(Target) <= spells.e.range then
			xPos = myHero.x + (myHero.x - Target.x)
			zPos = myHero.z + (myHero.z - Target.z)
			CastSpell(_E, xPos, zPos)
		end
    end    
end

function CastEPush(Target)
	if ValidTarget(Target) and spells.e.ready and GetDistance(Target) <= spells.e.range then
		CastSpell(_E, Target.x, Target.z)
	end   
end

function CastR()
	if settings.auto.auto and spells.r.ready then
		if GetEnemyCountInPos(myHero, spells.r.range) >= settings.auto.ultMinimum then
			CastSpell(_R)
		end
	end    
end

function CastEGap()
	if spells.e.ready and informationTable.spellCastedTick ~= nil then
		if not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange / informationTable.spellSpeed) * 1000 then
			local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
			local spellStartPosition = informationTable.spellStartPos + spellDirection
			local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
			local heroPosition = Point(myHero.x, myHero.z)

			local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))

			if lineSegment:distance(heroPosition) < spells.e.range then
				CastEPush(informationTable.spellSource)
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end
end

----------------------
--   Calculations   --
----------------------
-- Target Calculation
function getTarg()
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

function wPosition(player, target, dist)
	local xVector = player.x - target.x
	local zVector = player.z - target.z
	local distance = math.sqrt(xVector * xVector + zVector * zVector)
	
	return target.x + dist * xVector / distance, target.z + dist * zVector / distance
end

function updatePositions()
	for i = 1, heroManager.iCount, 1 do
		local ally = heroManager:getHero(i)
			
        if ally.team == myHero.team  and not ally.dead and ally.charName ~= myHero.charName then
			if allies[i] then
				if allies[i].x ~= ally.x and allies[i].z ~= ally.z and math.sqrt((allies[i].x - ally.x) ^ 2 + (allies[i].z - ally.z) ^ 2) > 150 then
					allies[i] = {x = ally.x, z = ally.z}
				end
			else
				allies[i] = {x = ally.x, z = ally.z}
			end
		end
	end
	
	DelayAction(function() updatePositions() end, 0.5)
end

function isRecall(hero)
	if hero ~= nil and ValidTarget(hero) then 
		for i = 1, hero.buffCount, 1 do
			local buff = hero:getBuff(i)
			if buff == "Recall" or buff == "SummonerTeleport" or buff == "RecallImproved" then return true end
		end
    end
	return false
end
----------------------
--      Hooks       --
----------------------

-- Init hook
function OnLoad()
	if not loaded then
		loaded = true
		print("<font color='#009DFF'>[Thresh]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

		if autoupdate then
			update()
		end

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_MAGIC, true)
		pred = VPrediction()
		HPred = HPrediction()
		hpload = true
		
		allies = { }
		Champ = { } 
		for i, enemy in pairs(GetEnemyHeroes()) do 
			Champ[i] = enemy.charName
		end
		
		updatePositions()
		Menu()
		
		AddUpdateBuffCallback(CustomUpdateBuff)		

		if hpload then
			HPred:AddSpell("Q", 'Thresh', {collisionM = true, collisionH = true, type = "DelayLine", delay = 0.5, range = 1100, width = 150, speed=1900})
		end
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
	readyCheck()
	
	ts:update()
	Target = getTarg()
	
	if settings.combo.comboKey then
		if settings.combo.q then
			CastQ(Target)
		end
		
		if settings.combo.w then
			CastWCombo(Target)
		end
			
		if settings.combo.e then
			CastEPull(Target)
		end
	end
	
	if not isRecall(myHero) then
		CastR()
		CastWEngage(Target)
		CastWLowHP()
		CastWOnApproaching()
		CastEGap()
	end
end

-- Drawing hook
function OnDraw()
	if myHero.dead then return end
	
	Target = getTarg()
	
	if ValidTarget(Target) and settings.draw.line then 
		local IsCollision = pred:CheckMinionCollision(Target, Target.pos, 0.5, 100, 1100, 1900, myHero.pos,nil, true)
		DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 5, IsCollision and ARGB(125, 255, 0,0) or ARGB(125, 0, 255,0))
	end
	
	if ValidTarget(Target) then
		DrawCircle(Target.x, Target.y, Target.z, 150, 0xffffff00)
	end
	
	if settings.draw.q and spells.q.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, settings.combo.qRange, 0xFFFF0000)
	end

	if settings.draw.w and spells.w.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.w.range, 0xFFFF0000)
	end

	if settings.draw.e and spells.e.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.e.range, 0xFFFF0000)
	end
end

function OnProcessSpell(object, spellProc)
	if myHero.dead then return end
	if object.team == myHero.team then return end
	
	if Interrupt[object.charName] ~= nil then
		spell = Interrupt[object.charName].stop[spellProc.name]
		if spell ~= nil then
			if settings.interrupt[spellProc.name] then
				if GetDistance(object) < spells.e.range and spells.e.ready then
					CastSpell(_E, object.x, object.z)
				elseif GetDistance(object) < spells.q.range and spells.q.ready then
					CastQ(object)
				end
			end
		end
	end
		
	local unit = object
	local spell = spellProc
	
	if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then			
		if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and settings.gapClose[unit.charName] then
			if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
				CastEPush(unit)
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

function CustomUpdateBuff(unit,buff)
	if unit then
		if unit.type == myHero.type then
			if unit.team ~= myHero.team and buff.name == "ThreshQ" then
				CastQ2()
			end
		end
	end
	
	if unit and not unit.isMe and buff.name == "rocketgrab2" and unit.type == myHero.type and settings.auto.blitzcrank then
		if unit.team == myHero.team then
			for _, enemy in ipairs(GetEnemyHeroes()) do
				if enemy.charName == "Blitzcrank" then
					local x, z = wPosition(myHero, enemy, 150)
					CastSpell(_W, x, z)
				end 
			end
		end
	end
end

-- Menu creation
function Menu()
	settings = scriptConfig("Thresh", "Zopper")
	TargetSelector.name = "Thresh"
	settings:addTS(ts)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Combo", "combo")
		settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		settings.combo:addParam("q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("qRange", "Cast Q on range", SCRIPT_PARAM_SLICE, 1100, 0, 1050, 0)
		settings.combo:addParam("autoJump", "Auto second cast Q", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("holdQ", "Hold Q before Jump", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
		settings.combo:addParam("w", "Use W after Q", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("e", "Use E to Pull", SCRIPT_PARAM_ONOFF, true)
		
	settings:addSubMenu("["..myHero.charName.."] - (Q) Settings", "q")	
		if Champ[1] ~= nil then settings.q:addParam("champ1", "Use on "..Champ[1], SCRIPT_PARAM_ONOFF, true) end
		if Champ[2] ~= nil then settings.q:addParam("champ2", "Use on "..Champ[2], SCRIPT_PARAM_ONOFF, true) end
		if Champ[3] ~= nil then settings.q:addParam("champ3", "Use on "..Champ[3], SCRIPT_PARAM_ONOFF, true) end
		if Champ[4] ~= nil then settings.q:addParam("champ4", "Use on "..Champ[4], SCRIPT_PARAM_ONOFF, true) end
		if Champ[5] ~= nil then settings.q:addParam("champ5", "Use on "..Champ[5], SCRIPT_PARAM_ONOFF, true) end
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto", "auto")
		settings.auto:addParam("auto", "Use ULT automatically", SCRIPT_PARAM_ONOFF, true)
		settings.auto:addParam("ultMinimum", "ULT if hits x enemies", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
		settings.auto:addParam("w", "Use W to save low HP", SCRIPT_PARAM_ONOFF, true)
		settings.auto:addParam("hpW", "Use W at what % health", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
		settings.auto:addParam("blitzcrank", "Save when hooked by Blitzcrank", SCRIPT_PARAM_ONOFF, true)
		settings.auto:addParam("approachingW", "Beta: Use W on allies comming to you", SCRIPT_PARAM_ONOFF, true)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto-Interrupt", "interrupt")
		for i, a in pairs(GetEnemyHeroes()) do
			if Interrupt[a.charName] ~= nil then
				for i, spell in pairs(Interrupt[a.charName].stop) do
					settings.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
				end
			end
		end
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Drawing", "draw")
		settings.draw:addParam("line", "Draw Line", SCRIPT_PARAM_ONOFF, true)
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
	
    settings:addParam("pred", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "DivinePred", "HPred"})
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