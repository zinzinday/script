local version = "1.19"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Soraka.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Soraka:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Soraka.version")
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

if myHero.charName ~= "Soraka" then return end   

--Script Status Updates
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("UHKJHPMIIPL")  

require("VPrediction") --vpred
require("HPrediction") -- hpred

if VIP_USER and FileExist(LIB_PATH .. "/DivinePred.lua") then 
	require "DivinePred" 
	dp = DivinePred()
	qpred = CircleSS(1300, 970, 150, .25, math.huge)
end

local pred = nil

----------------------
--     Variables    --
----------------------
loaded = false

spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false, range = 970, width = 250}
spells.w = {name = myHero:GetSpellData(_W).name, ready = false, range = 550, width = nil}
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 925, width = 250}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false, range = nil, width = nil}

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
		if false then
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
function CastQ(minEnemies)
	local closestdistance = 975 + 250
	local enemycount = 0
	local unit = nil

	for i, enemy in ipairs(GetEnemyHeroes()) do
        if GetEnemyCountInPos(enemy, 250) > enemycount and GetDistance(enemy) <= spells.q.range + 250 then
			unit = enemy
			enemycount = GetEnemyCountInPos(enemy, 250)
			closestdistance = GetDistance(enemy)
		elseif GetEnemyCountInPos(enemy, 250) == enemycount and GetDistance(enemy) <= closestdistance then
			unit = enemy
			enemycount = GetEnemyCountInPos(enemy, 250)
			closestdistance = GetDistance(enemy)
		end
    end

    if ValidTarget(unit) and enemycount >= minEnemies then
        if settings.pred == 1 then
            local castPos, chance, pos = pred:GetCircularCastPosition(unit, .25, 250, 975, 1300, myHero, false)
            if  spells.q.ready and chance >= 2 then
                CastSpell(_Q, castPos.x, castPos.z)
            end
        elseif settings.pred == 2 and  VIP_USER then
            local targ = DPTarget(unit)
            local state,hitPos,perc = dp:predict(targ, qpred)
            if spells.q.ready and state == SkillShot.STATUS.SUCCESS_HIT then
                CastSpell(_Q, hitPos.x, hitPos.z)
            end
        elseif settings.pred == 3 then
            local pos, chance = HPred:GetPredict("Q", unit, myHero) 
            if spells.q.ready and chance >= 2 then
                CastSpell(_Q, pos.x, pos.z)
            end
        end
    end
end

function AutoUltimate()
	for i, ally in ipairs(GetAllyHeroes()) do

		------------------------------
		if ally.dead then return end
		if myHero.dead then return end
		------------------------------

		if spells.r.ready and settings.ult.UseUlt and GetEnemyCountInPos(ally, 700) > 1 and not isRecall(ally) then
			if settings.ult.UltCast == 2 then
				if (ally.health / ally.maxHealth < settings.ult.UltManager /100) then
					if settings.ult.UltMode == 1 then
						CastSpell(_R)
					elseif settings.ult.UltMode == 2 then
						if GetDistance(ally, myHero) <= 1500 then
							CastSpell(_R)
						end
					end
				end
			elseif settings.ult.UltCast == 1 then
				if (myHero.health / myHero.maxHealth < settings.ult.UltManager2 /100) then
					CastSpell(_R)
				end
			elseif settings.ult.UltCast == 3 then
				if (ally.health / ally.maxHealth < settings.ult.UltManager /100) or (myHero.health / myHero.maxHealth < settings.ult.UltManager2 /100) then
					if settings.ult.UltMode == 1 then
						CastSpell(_R)
					elseif settings.ult.UltMode == 2 then
						if GetDistance(ally, myHero) <= 1500 then
							CastSpell(_R)
						end
					end
				end
			end
		end
    end
end

function AutoHeal()
	local ally = GetBestHealTarget()

	if spells.w.ready and settings.heal.UseHeal and not isRecall(myHero) then
		if (ally.health / ally.maxHealth < settings.heal.HealManager /100) and (myHero.health / myHero.maxHealth > settings.heal.HPManager /100) then
			if GetDistance(ally, myHero) <= spells.w.range and not isRecall(ally) then
				CastSpell(_W, ally)
			end
		end
	end
end

function autoE() 
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if not enemy.canMove and GetDistance(enemy) < spells.e.range and not enemy.dead then
			CastSpell(_E, enemy)
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
	if ValidTarget(SelectedTarget) then return SelectedTarget end
	if MMALoaded and ValidTarget(_G.MMA_Target) then return _G.MMA_Target end
	return ts.target
end

function GetEnemyCountInPos(pos, radius)
    local n = 0
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if GetDistanceSqr(pos, enemy) <= radius * radius then n = n + 1 end 
    end
    return n
end

function GetBestHealTarget()
    local leastHp = getHealthPercent(myHero) / GetEnemyCountInPos(myHero, 550)
    local leastHpAlly = myHero

    for _, ally in ipairs(GetAllyHeroes()) do
        local allyHpPct = getHealthPercent(ally) / (GetEnemyCountInPos(ally, 550) + 1)
        if allyHpPct <= leastHp and not ally.dead and GetDistance(ally) < spells.w.range then
            leastHp = allyHpPct
            leastHpAlly = ally
        end
    end

    return leastHpAlly
end

function getHealthPercent(unit)
    local obj = unit or myHero
    return (obj.health / obj.maxHealth) * 100
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
		print("<font color='#009DFF'>[Soraka]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

		if autoupdate then
			update()
		end

		ts = TargetSelector(TARGET_LOW_HP, 600, DAMAGE_PHYSICAL, false, true)
		pred = VPrediction()
		HPred = HPrediction()
		hpload = true

		Menu()
	
		if hpload then
			HPred:AddSpell("Q", 'Soraka', {type = "DelayCircle", delay = 0.25, range = 1050, radius = 250, speed=1300})
			HPred:AddSpell("E", 'Soraka', {type = "PromptCircle", delay = 0.25, range = 925, radius = 250})
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

	local hp = myHero.health / myHero.maxHealth * 100
	local mana = myHero.mana / myHero.maxMana * 100

	if settings.ult.UseUlt then
        AutoUltimate()
    end
	
	if settings.heal.UseHeal then
        AutoHeal()
    end
	
	if settings.q.autoQ and hp <= settings.q.autoQhp and mana >= settings.q.autoQmana then
		CastQ(settings.q.autoQenemy)
	end
	
	if settings.combo.comboKey then
		CastQ(1)
	end
	
	if settings.e.autoE then
		autoE()
	end
end

-- Drawing hook
function OnDraw()
	if myHero.dead then return end
	
	if settings.draw.q and spells.q.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.q.range, ARGB(255,0,255,0))
	end

	if settings.draw.w and spells.w.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.w.range, ARGB(255,255,255,0))
	end

	if settings.draw.e and spells.e.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, spells.e.range, ARGB(255,255,0,0))
	end
end

function OnProcessSpell(object, spellProc)
	if myHero.dead then return end
	if object.team ~= myHero.team then
		if Interrupt[object.charName] ~= nil then
			spell = Interrupt[object.charName].stop[spellProc.name]
			if spell ~= nil then
				if GetDistance(object) < spells.e.range then
					if settings.interrupt[spellProc.name] then
						CastSpell(_E, object.x, object.z)	
					end
				end
			end
		end
	end
end

-- Menu creation
function Menu()
	settings = scriptConfig("Soraka", "Zopper")
	TargetSelector.name = "Soraka"
	settings:addTS(ts)

	settings:addSubMenu("[" .. myHero.charName.. "] - Combo", "combo")
		settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		settings.combo:addParam("q", "Q", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("[" .. myHero.charName.. "] - Auto Q", "q")
		settings.q:addParam("autoQ", "Auto Q", SCRIPT_PARAM_ONOFF, true)
		settings.q:addParam("autoQmana", "My Minimum Mana", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		settings.q:addParam("autoQhp", "My Maximum HP", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
        settings.q:addParam("autoQenemy", "Min enemies: ", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto Heal", "heal")        
        settings.heal:addParam("UseHeal", "Auto Heal Allies", SCRIPT_PARAM_ONOFF, true)
        settings.heal:addParam("HealManager", "Heal allies under", SCRIPT_PARAM_SLICE, 65, 0, 100, 0)
        settings.heal:addParam("HPManager", "Don't heal under (my hp)", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

	settings:addSubMenu("[" .. myHero.charName.. "] - Auto E", "e")        
        settings.e:addParam("autoE", "Auto E on Immobile", SCRIPT_PARAM_ONOFF, true)
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto R", "ult")
		settings.ult:addParam("UseUlt", "Use ult", SCRIPT_PARAM_ONOFF, true)
        settings.ult:addParam("UltCast", "Auto Ultimate On: ", SCRIPT_PARAM_LIST, 3, {"Only Me", "Allies", "Both"})
        settings.ult:addParam("UltMode", "Auto Ultimate Mode: ", SCRIPT_PARAM_LIST, 1, {"Global",  "In Range"})
        settings.ult:addParam("UltManager", "Ultimate allies under", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
        settings.ult:addParam("UltManager2", "Ultimate me under", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Drawing", "draw")
		settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("[" .. myHero.charName.. "] - Auto-Interrupt", "interrupt")
		for i, a in pairs(GetEnemyHeroes()) do
			if Interrupt[a.charName] ~= nil then
				for i, spell in pairs(Interrupt[a.charName].stop) do
					if spell.ult == true then
						settings.interrupt:addParam(spell.spellName, a.charName.." - "..spell.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
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