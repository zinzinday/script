local version = "1.09"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Rengar.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Rengar:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Rengar.version")
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

if myHero.charName ~= "Rengar" then return end   

--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("QDGFDLIEEFF")

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
		epred = LineSS(1500, 1000, 75, 0.25, 0)
		
	else
		useDP = false
		PrintChat("For better prediction please download DPrediction. The script WILL work without it though.")
	end
end

----------------------
--     Variables    --
----------------------
loaded = false

local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Bard", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
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

items = {
	['ItemTiamatCleave']          = {true, target = false },
	['YoumusBlade']               = {true, target = false },
	['BilgewaterCutlass']         = {true, target = true  },
	['ItemSwordOfFeastAndFamine'] = {true, target = true  },
}

MyTrueRange = myHero.range + GetDistance(myHero.minBBox)
lastECheck = 0
hasQ = false

comboSpell = "Smart"
comboLastUpdated = 0

spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false}
spells.w = {name = myHero:GetSpellData(_W).name, ready = false, range = 450} -- Range decreased so that it hits running enemies
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 1000, speed = 1500, delay = 0.25, width = 75}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false}

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
	if ValidTarget(SelectedTarget) and SelectedTarget.type == myHero.type then return SelectedTarget end
	if MMALoaded and ValidTarget(_G.MMA_Target) then return _G.MMA_Target end
	return ts.target
end

function getHealthPercent(unit)
    local obj = unit or myHero
    return (obj.health / obj.maxHealth) * 100
end

function getChampionPriority(i, team, range)
    for idx, champion in ipairs(team) do
        if i == 1 and priorityTable.p1[champion.charName] ~= nil then return champion
        elseif i == 2 and priorityTable.p2[champion.charName] ~= nil then return champion
        elseif i == 3 and priorityTable.p3[champion.charName] ~= nil then return champion
        elseif i == 4 and priorityTable.p4[champion.charName] ~= nil then return champion
        elseif i == 5 and priorityTable.p5[champion.charName] ~= nil then return champion
        end
    end
end

function getPriorityChampion(champion)
    if priorityTable.p1[champion.charName] ~= nil then
        return 1
    elseif priorityTable.p2[champion.charName] ~= nil then
        return 2
    elseif priorityTable.p3[champion.charName] ~= nil then
        return 3
    elseif priorityTable.p4[champion.charName] ~= nil then
        return 4
    elseif priorityTable.p5[champion.charName] ~= nil then
        return 5
    end
    return 5
end

function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end
function arrangePriority()
     local priorityOrder = {
        [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,2,3},
        [4] = {1,1,2,3,4},
        [5] = {1,2,3,4,5},
    }
    local enemies = #GetEnemyHeroes()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.p1, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.p2, enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.p3,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.p4,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.p5,  enemy, priorityOrder[enemies][5])
    end
end

function emp()
	if settings.emp.use then
		if IsKeyDown(string.byte("A")) then
			settings.emp.q = true
			settings.emp.e = false
			comboSpell = "Q"
			
			comboLastUpdated = os.clock()
		end
		
		if IsKeyDown(string.byte("S")) then
			settings.emp.e = true
			settings.emp.q = false
			comboSpell = "E"
			
			comboLastUpdated  = os.clock()
		end
	else
		settings.emp.q = false
		settings.emp.e = false
		comboSpell = "Smart"
	end
end

----------------------
--      Hooks       --
----------------------

-- Init hook
function OnLoad()
	if not loaded then
		loaded = true
		print("<font color='#009DFF'>[Rengar]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

		if autoupdate then
			update()
		end

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_PHYSICAL, true)
		pred = VPrediction()
		
		if useHP then
			HPred = HPrediction()
			HPred:AddSpell("E", 'Rengar', {collisionM = true, collisionH = true, delay = spells.e.delay, range = spells.e.range, speed = spells.e.speed, type = "DelayLine", width = spells.e.width})
		end
		
		Menu()
		
		arrangePriority()
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

function OnApplyBuff(source, unit, buff)
	if unit == myHero and (buff.name == "rengarqbase" or buff.name == "rengarqemp") then
		hasQ = true
	end
end

function OnRemoveBuff(unit, buff)
	if (buff.name == "rengarqbase" or buff.name == "rengarqemp") and unit == myHero then
		hasQ = false
	end
end

function OnProcessSpell(unit, spell)	
	if unit == myHero and myHero.mana == 5 then
		if settings.emp.smart then
			if spell.name == "RengarQ" and comboSpell == "Q" then
				comboSpell = "Smart"
			elseif spell.name == "RengarE" and comboSpell == "E" then
				comboSpell = "Smart"
			end
		end
	end

	if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then			
		if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) and settings.gapClose[unit.charName] then
			if spell.target ~= nil and spell.target.name == myHero.name or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' and myHero.mana == 5 then
				CastE(unit)
			end
		end
	end
end

-- Tick hook
function OnTick()
	readyCheck()
	Target = getTarg()
	emp()
	
	MyTrueRange = myHero.range + GetDistance(myHero.minBBox) + 50
		
	if settings.combo.comboKey and SxOrb ~= nil and settings.combo.stop then
		if  GetDistance(myHero, mousePos) < settings.combo.stopRange then
			SxOrb:DisableMove()
		else
			SxOrb:EnableMove()
		end
	end
	
	if settings.combo.comboKey and ValidTarget(Target) and GetDistance(Target) < MyTrueRange and SxOrb ~= nil then
		SxOrb:ForceTarget(Target)
	end

	if hasQ and ValidTarget(Target) and GetDistance(Target) < MyTrueRange then
		myHero:Attack(Target)
	end
	
	if os.clock() - comboLastUpdated > settings.emp.smartReset and settings.emp.smartReset > 0 then
		comboSpell = "Smart"
		settings.emp.q = false
		settings.emp.e = false
	end
	
	if settings.combo.comboKey and settings.combo.items and ValidTarget(Target) and GetDistance(Target) < MyTrueRange and MyTrueRange < 500 then
		for slot = ITEM_1, ITEM_7 do
			if items[myHero:GetSpellData(slot).name] then
				if items[myHero:GetSpellData(slot).name].target then
					CastSpell(slot, Target)
				else
					CastSpell(slot)
				end
			end
		end
	end
	
	if comboSpell == "Smart" then
		AutoHeal()
	end
	
	if settings.combo.comboKey and ValidTarget(Target) then	
		if GetDistance(Target) < settings.combo.eMaxRange then
			if myHero.mana < 5 then
				if MyTrueRange < 700 then
					CastE(Target)
				end
			elseif myHero.mana == 5 and settings.combo.empE and (comboSpell == "Smart" or comboSpell == "E") then
				if MyTrueRange < 700 and GetDistance(Target) > settings.combo.empERange then
					CastE(Target)
				end
			end
		end
		
		if myHero.mana < 5 then
			CastW(Target)
		end
		
		if (comboSpell == "Smart" or comboSpell == "Q") and myHero.mana == 5 then
			CastQ(Target)
		elseif myHero.mana < 5 then
			CastQ(Target)
		end
	end
end

-- Drawing hook
function OnDraw()
	if myHero.dead then return end
	
	Target = getTarg()
			
	if settings.draw.combo then
		UpdateWindow()
		DrawText3D("Next Emp: " .. comboSpell, myHero.x-100, myHero.y-100, myHero.z, settings.draw.comboSize, 0xFFFFFF00)
	end
	
	if settings.draw.target and Target ~= nil then
		DrawCircle(Target.x, Target.y, Target.z, 150, 0xffffff00)
	end

	if settings.draw.range then
		DrawCircle(myHero.x, myHero.y, myHero.z, MyTrueRange, 0xFFFF0000)
	end
	
	if settings.draw.empERange then
		DrawCircle(myHero.x, myHero.y, myHero.z, settings.combo.empERange, 0xFFFF0000)
	end
	
	if settings.draw.e and spells.e.ready then
		DrawCircle(myHero.x, myHero.y, myHero.z, settings.combo.eMaxRange, 0xFFFF0000)
	end
end

-- Menu creation
function Menu()	
	settings = scriptConfig("Rengar", "Zopper")
	TargetSelector.name = "Rengar"
	settings:addTS(ts)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Combo", "combo")
		settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		settings.combo:addParam("stop", "Stop if mouse above hero", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("items", "Use items in combo", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("stopRange", "Stop range", SCRIPT_PARAM_SLICE, 200,0,500,0)
		settings.combo:addParam("empE", "Use Empowered E if enemy is far", SCRIPT_PARAM_ONOFF, true)
		settings.combo:addParam("empERange", "Use if enemy is further than", SCRIPT_PARAM_SLICE, 500,0,1000,0)
		settings.combo:addParam("eMaxRange", "Maximum range to use E", SCRIPT_PARAM_SLICE, 950,0,1000,0)
		settings.combo:permaShow("comboKey")
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Empowered Spell Combo Manager", "emp")
		settings.emp:addParam("use", "Use Combo Manager", SCRIPT_PARAM_ONOFF, true)
		settings.emp:addParam("smart", "Switch back to Smart after using spell", SCRIPT_PARAM_ONOFF, true)
		settings.emp:addParam("smartReset", "Reset spell after seconds (0=never)  ", SCRIPT_PARAM_SLICE, 10,0,60,0)
		settings.emp:addParam("q", "Press A - Cast Q next", 0, 0)
		settings.emp:addParam("e", "Press S - Cast E next", 0, 0)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Auto Heal", "heal")
		settings.heal:addParam("heal", "Use Auto Heal", SCRIPT_PARAM_ONOFF, true)
		settings.heal:addParam("maxHP", "Auto Heal if below %", SCRIPT_PARAM_SLICE, 25,0,100,0)
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Drawing", "draw")
		settings.draw:addParam("combo", "Draw Combo Manager Spell", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("comboSize", "Combo Manager text size", SCRIPT_PARAM_SLICE, 25,0,100,0)
		settings.draw:addParam("e", "Draw e", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("empERange", "Draw Empowered E min range", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("range", "Draw my range", SCRIPT_PARAM_ONOFF, true)
		settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)
		
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
	if ValidTarget(unit) and GetDistance(unit) <= MyTrueRange and spells.q.ready then
		CastSpell(_Q)
	end
end

function CastE(unit)
	if ValidTarget(unit) and GetDistance(unit) <= spells.e.range and spells.e.ready then
		if settings.pred == 1 then
			local castPos, chance, pos = pred:GetLineCastPosition(unit, spells.e.delay, spells.e.width, spells.e.range, spells.e.speed, myHero, true)
			if chance >= 2 then
				CastSpell(_E, castPos.x, castPos.z)
			end
		elseif settings.pred == 2 and VIP_USER and (os.clock() * 1000 - lastECheck) > 200 and useDP then	
			local targ = DPTarget(unit)
			local state,hitPos,perc = dp:predict(targ, epred)
			
			lastECheck = os.clock() * 1000
			
			if state == SkillShot.STATUS.SUCCESS_HIT then
				CastSpell(_E, hitPos.x, hitPos.z)
			end
		elseif settings.pred == 3 and useHP then
			local EPos, EHitChance = HPred:GetPredict("E", unit, myHero)
  
			if EHitChance > 0 then
				CastSpell(_E, EPos.x, EPos.z)
			end
		end
	end
end

function CastW(unit)
	if ValidTarget(unit) and GetDistance(unit) <= spells.w.range and spells.w.ready then
		CastSpell(_W)
	end
end

function AutoHeal()
	if settings.heal.heal and getHealthPercent(myHero) < settings.heal.maxHP and myHero.mana == 5 and spells.w.ready then 
		CastSpell(_W) 
	end
end
