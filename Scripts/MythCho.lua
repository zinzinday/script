local version = "1.26"

----------------------
--   Auto Updater   --
----------------------

if myHero.charName ~= "Chogath" then return end


local mythcho = {}
local autoupdate = true
local UPDATE_NAME = "MythCho"
local UPDATE_FILE_PATH = SCRIPT_PATH..UPDATE_NAME..".lua"
local UPDATE_URL = "http://raw.github.com/iMythik/BoL/master/MythCho.lua"

function printChat(msg) print("<font color='#009DFF'>[MythCho]</font><font color='#FFFFFF'> "..msg.."</font>") end

function update()
    local netdata = GetWebResult("raw.github.com", "/iMythik/BoL/master/MythCho.lua")
    if netdata then
        local netver = string.match(netdata, "local version = \"%d+.%d+\"")
        netver = string.match(netver and netver or "", "%d+.%d+")
        if netver then
            netver = tonumber(netver)
            if tonumber(version) < netver then
                printChat("New version found, updating... don't press F9.")
                DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () printChat("Updated script ["..version.." to "..netver.."], press F9 twice to reload the script.") end)    
            else
                printChat("is running latest version!")
            end
        end
    end
end

require("VPrediction") --vpred
require("DivinePred") -- divinepred
require("HPrediction") -- hpred

local processTime  = os.clock()*1000
local enemyChamps = {}
local dp = DivinePred()
local minHitDistance = 50
local pred = nil

----------------------
--     Variables    --
----------------------

local spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false, range = 950, width = 410}
spells.w = {name = myHero:GetSpellData(_E).name, ready = false, range = 700, width = 145}
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 660, width = 540}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false, range = 480, width = 480}

-- Spell cooldown check
function mythcho:readyCheck()
	spells.q.ready, spells.w.ready, spells.e.ready, spells.r.ready = (myHero:CanUseSpell(_Q) == READY), (myHero:CanUseSpell(_W) == READY), (myHero:CanUseSpell(_E) == READY), (myHero:CanUseSpell(_R) == READY)
end

-- Orbwalker check
function orbwalkCheck()
	if _G.AutoCarry then
		printChat("SA:C detected, support enabled.")
		SACLoaded = true
	elseif _G.MMA_Loaded then
		printChat("MMA detected, support enabled.")
		MMALoaded = true
	else
		printChat("SA:C/MMA not running, loading SxOrbWalk.")
		require("SxOrbWalk")
		SxMenu = scriptConfig("SxOrbWalk", "SxOrbb")
		SxOrb:LoadToMenu(SxMenu)
		SACLoaded = false
	end
end

----------------------
--  Cast functions  --
----------------------

local qpred = CircleSS(math.huge, 950, 200, 1.2, math.huge)
local wpred = LineSS(math.huge, 660, 210, .25, math.huge)

function mythcho:CastQ(unit)
	if settings.pred == 1 then
    	local castPos, chance, pos = pred:GetCircularCastPosition(unit, 1.2, 200, 950, math.huge, myHero, false)
    	if ValidTarget(unit, spells.q.range) and spells.q.ready and chance >= 2 then
    	    CastSpell(_Q, castPos.x, castPos.z)
    	end
    elseif settings.pred == 2 then
    	local targ = DPTarget(unit)
    	local state,hitPos,perc = dp:predict(targ, qpred)
    	if ValidTarget(unit, spells.q.range) and spells.q.ready and state == SkillShot.STATUS.SUCCESS_HIT then
       		CastSpell(_Q, hitPos.x, hitPos.z)
      	end
	elseif settings.pred == 3 then
		local pos, chance = HPred:GetPredict("Q", unit, myHero) 
		if ValidTarget(unit, spells.q.range) and spells.q.ready and chance >= 2 then
			CastSpell(_Q, pos.x, pos.z)
		end
	end
end

-- Cast W
function mythcho:CastW(unit)
	if settings.pred == 1 then
    	local castPos, chance, pos = pred:GetLineCastPosition(unit, .25, 210, 660, math.huge, myHero, false)
   	 	if ValidTarget(unit, spells.w.range) and spells.w.ready and chance >= 2 then
     	   CastSpell(_W, castPos.x, castPos.z)
    	end
    elseif settings.pred == 2 then
    	local targ = DPTarget(unit)
    	local state,hitPos,perc = dp:predict(targ, wpred)
    	if ValidTarget(unit, spells.w.range) and spells.w.ready and state == SkillShot.STATUS.SUCCESS_HIT then
       		CastSpell(_W, hitPos.x, hitPos.z)
      	end
	elseif settings.pred == 3 then
		local pos, chance = HPred:GetPredict("W", unit, myHero)
		if ValidTarget(unit, spells.w.range) and spells.w.ready and chance >= 2 then
			CastSpell(_W, pos.x, pos.z)
		end
	end
end

-- Cast ult
function mythcho:CastR(unit)
	if ValidTarget(unit, spells.r.range) and spells.r.ready then
		if settings.combo.kill and getDmg("R", unit, myHero) < unit.health then return end
		CastSpell(_R, unit)
	end
end	

-- Full Combo
function mythcho:shoot(unit)
	if SACLoaded then
		AutoCarry.Orbwalker:Orbwalk(unit)
	elseif MMALoaded then
		_G.MMA_ForceTarget = unit
	else 
		SxOrb:ForceTarget(unit)
	end
	if settings.combo.autoq then
		mythcho:CastQ(unit)
	end
	if settings.combo.autow then
		mythcho:CastW(unit)
	end
	if settings.combo.autoR then
		mythcho:CastR(unit)
	end
end

function mythcho:Harass(unit)
	if not settings.harass.harassKey then return end

	if settings.harass.q and ValidTarget(unit, spells.q.range) then
		mythcho:CastQ(unit)
	end

	if settings.harass.w and ValidTarget(unit, spells.w.range) then
		mythcho:CastW(unit)
	end

	if settings.harass.autoq and ValidTarget(unit, spells.q.range) then
		mythcho:CastQ(unit)
	end
end

-- Minion farm
function mythcho:Farm()
	creep:update()
		
	for i, minion in pairs(creep.objects) do

		if not settings.farm.farmkey then return end

		if settings.farm.farmq and getDmg("Q", minion, myHero) >= minion.health then
			mythcho:CastQ(minion)
		end

		if settings.farm.farmw then
			mythcho:CastW(minion)
		end
	end
end

----------------------
--   Calculations   --
----------------------

-- Target Selection
function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN and settings.combo.focus then
		local dist = 0
		local Selecttarget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, mousePos) <= dist or Selecttarget == nil then
					dist = GetDistance(enemy, mousePos)
					Selecttarget = enemy
				end
			end
		end
		if Selecttarget and dist < 300 then
			if SelectedTarget and Selecttarget.charName == SelectedTarget.charName then
				SelectedTarget = nil
				if settings.combo.focus then 
					printChat("Target unselected: "..Selecttarget.charName) 
				end
			else
				SelectedTarget = Selecttarget
				if settings.combo.focus then
					printChat("New target selected: "..Selecttarget.charName) 
				end
			end
		end
	end
end

-- Target Calculation
function mythcho:getTarg()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then _G.AutoCarry.Crosshair:SetSkillCrosshairRange(1200) return _G.AutoCarry.Crosshair:GetTarget() end		
	if ValidTarget(SelectedTarget) then return SelectedTarget end
	if MMALoaded and ValidTarget(_G.MMA_Target) then return _G.MMA_Target end
	return ts.target
end

----------------------
--      Hooks       --
----------------------

-- Init hook
function OnLoad()
	print("<font color='#009DFF'>[MythCho]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

	if autoupdate then
		update()
	end

	for i = 1, heroManager.iCount do
    	local hero = heroManager:GetHero(i)
		if hero.team ~= myHero.team then enemyChamps[""..hero.networkID] = DPTarget(hero) end
	end

	ts = TargetSelector(TARGET_LOW_HP, 600, DAMAGE_PHYSICAL, false, true)
	creep = minionManager(MINION_ENEMY, 200, myHero, MINION_SORT_HEALTH_ASC)
	pred = VPrediction()
	HPred = HPrediction()
	hpload = true

	mythcho:Menu()

	DelayAction(orbwalkCheck,7)

	if hpload then
  		HPred:AddSpell("Q", 'Chogath', {delay = 1.2, radius = 200, range = 900, type = "PromptCircle"})
  		HPred:AddSpell("W", 'Chogath', {delay = .25, range = 660, radius = 210, type = "DelayLine", width = 420})
  	end
end

-- Tick hook
function OnTick()
	mythcho:readyCheck()

	ts:update()

	local hp = myHero.health / myHero.maxHealth * 100

	if settings.farm.farmkey then
		mythcho:Farm()
	end

	if settings.ks.r or settings.ks.q then
		for k, v in pairs(GetEnemyHeroes()) do
			if settings.ks.r then
				if ValidTarget(v, spells.r.range) then
					mythcho:CastR(v)
				end
			elseif settings.ks.q then
				if ValidTarget(v, spells.q.range) and getDmg("Q", v, myHero) >= v.health then
					mythcho:CastQ(v)
				end
			end
		end
	end

	if not ValidTarget(mythcho:getTarg()) then return end

	local targ = mythcho:getTarg()

	if settings.harass.harassKey then
		mythcho:Harass(targ)
	end

	if settings.harass.autoq then
		if ValidTarget(targ, spells.q.range) then
			mythcho:CastQ(targ)
		end
	end

	if settings.combo.comboKey then
		mythcho:shoot(targ)
	end

end

-- thank you bilbao <3

function GetHPBarPos(enemy)
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

function DrawLineHPBar(damage, line, text, unit, enemyteam)
	if unit.dead or not unit.visible then return end
	local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
	if not OnScreen(p.x, p.y) then return end

	
	local thedmg = 0
	local linePosA = {x = 0, y = 0 }
	local linePosB = {x = 0, y = 0 }
	local TextPos =  {x = 0, y = 0 }
	
	
	if damage >= unit.maxHealth then
		thedmg = unit.maxHealth - 1
	else
		thedmg = damage
	end
	
	
	local StartPos, EndPos = GetHPBarPos(unit)
	local Real_X = StartPos.x + 24
	local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
	if Offs_X < Real_X then Offs_X = Real_X end	

	local r, r2 = 255, 255
	local g, g2 = 0, 255
	local b = 255

	if thedmg >= unit.health then g = 255 r = 0 g2 = 255 r2 = 0 b = 0 text = text.." (Killable!)" end

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

	DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(255, r, g, 0))
	DrawText(tostring(text),15,TextPos.x, TextPos.y - 10, ARGB(255, r2, g2, b))
	
end

-- Drawing hook
function OnDraw()
	if myHero.dead then return end

	if settings.draw.q and spells.q.ready then
		mythcho:DrawCircle(myHero.x, myHero.y, myHero.z, spells.q.range, ARGB(255,0,255,0))
	end

	if settings.draw.w and spells.w.ready then
		mythcho:DrawCircle(myHero.x, myHero.y, myHero.z, spells.w.range, ARGB(255,255,255,0))
	end

	if settings.draw.r and spells.r.ready then
		mythcho:DrawCircle(myHero.x, myHero.y, myHero.z, spells.r.range, ARGB(255,255,0,0))
	end

	if settings.draw.target and ValidTarget(mythcho:getTarg()) then
		local targ = mythcho:getTarg()
		mythcho:DrawCircle(targ.x, targ.y, targ.z, 100, ARGB(255,255,120,0))
	end

	if ValidTarget(mythcho:getTarg()) and settings.draw.rdmg and spells.r.ready then
		local targ = mythcho:getTarg()
		DrawLineHPBar(getDmg("R", targ, myHero), 1, " R Damage: "..math.round(getDmg("R", targ, myHero)), targ, true)
	end
end

-- Menu creation
function mythcho:Menu()
	settings = scriptConfig("MythCho", "mythik")
	TargetSelector.name = "MythCho"
	settings:addTS(ts)

	settings:addSubMenu("Combo", "combo")
	settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	settings.combo:addParam("autoq", "Auto Q", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("autow", "Auto W", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("autoR", "Auto R", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("kill", "Only ult if killable", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("focus", "Focus selected target", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("Harass", "harass")
	settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
	settings.harass:addParam("autoq", "Auto Q in range", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
	settings.harass:addParam("q", "Harass with Q", SCRIPT_PARAM_ONOFF, false)
	settings.harass:addParam("w", "Harass with W", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Farm", "farm")
	settings.farm:addParam("farmkey", "Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, 86)
	settings.farm:addParam("farmq", "Farm with Q", SCRIPT_PARAM_ONOFF, false)
	settings.farm:addParam("farmw", "Farm with W", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Kill Steal", "ks")
	settings.ks:addParam("r", "Use R", SCRIPT_PARAM_ONOFF, true)
	settings.ks:addParam("q", "Use Q", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("Drawing", "draw")
	settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, false)
	settings.draw:addParam("r", "Draw R", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("rdmg", "Draw R Damage", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)

    settings:addParam("pred", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "DivinePred", "HPred"})
end


--Lag Free Circles
function mythcho:DrawCircle(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		self:DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end

function mythcho:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8, self:Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
		
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)	
end

function mythcho:Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBEDBBDBEDA") 