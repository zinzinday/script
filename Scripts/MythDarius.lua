local version = "1.29"

if myHero.charName ~= "Darius" then return end

----------------------
--   Auto Updater   --
----------------------

local mythdunk = {}
local autoupdate = true
local UPDATE_NAME = "MythDunk"
local UPDATE_FILE_PATH = SCRIPT_PATH..UPDATE_NAME..".lua"
local UPDATE_URL = "http://raw.github.com/iMythik/BoL/master/MythDunk.lua"

function printChat(msg) print("<font color='#009DFF'>[MythDunk]</font><font color='#FFFFFF'> "..msg.."</font>") end

function update()
    local netdata = GetWebResult("raw.github.com", "/iMythik/BoL/master/MythDunk.lua")
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

----------------------
--     Variables    --
----------------------

local spells = {}
spells.q = {name = myHero:GetSpellData(_Q).name, ready = false, range = 420, width = 410}
spells.w = {name = myHero:GetSpellData(_E).name, ready = false, range = 145, width = 145}
spells.e = {name = myHero:GetSpellData(_E).name, ready = false, range = 540, width = 540}
spells.r = {name = myHero:GetSpellData(_R).name, ready = false, range = 480, width = 480}
   
local stacktbl = {
	[1] = "darius_Base_hemo_counter_01.troy",
	[2] = "darius_Base_hemo_counter_02.troy",
	[3] = "darius_Base_hemo_counter_03.troy",
	[4] = "darius_Base_hemo_counter_04.troy",
	[5] = "darius_Base_hemo_counter_05.troy",
}

-- Spell cooldown check
function mythdunk:readyCheck()
	spells.q.ready, spells.w.ready, spells.e.ready, spells.r.ready = (myHero:CanUseSpell(_Q) == READY), (myHero:CanUseSpell(_W) == READY), (myHero:CanUseSpell(_E) == READY), (myHero:CanUseSpell(_R) == READY)
end

-- Orbwalker check
function orbwalkCheck()
	if _G.AutoCarry then
		printChat("SA:C detected, support enabled.")
		AutoCarry.Plugins:RegisterOnAttacked(ResetW)
		SACLoaded = true
	else
		printChat("SA:C not running, loading SxOrbWalk.")
		require("SxOrbWalk")
		SxOrb:RegisterAfterAttackCallback(ResetW)
		SxOrb:LoadToMenu(Menu)
		SACLoaded = false
	end
end

----------------------
--  Cast functions  --
----------------------

-- Cast Q
function mythdunk:CastQ(unit)
	if ValidTarget(unit, spells.q.range) and spells.q.ready then
		if settings.combo.packets then
			Packet("S_CAST", {spellId = _Q}):send()
		else
			CastSpell(_Q, unit.x, unit.z)
		end
	end
	if settings.combo.qmax then
		if ValidTarget(unit,425) and myHero:GetDistance(unit) > 290 then
			if settings.combo.packets then
				Packet("S_CAST", {spellId = _Q}):send()
			else
				CastSpell(_Q, unit.x, unit.z)
			end
		end
	end
end	

-- Cast W
function CastW()
	if spells.w.ready then
		if settings.combo.packets then
			Packet("S_CAST", {spellId = _W}):send()
		else
			CastSpell(_W)
		end
	end	
end	

--W Reset
function ResetW()
	if SACLoaded then
		local e = AutoCarry.Orbwalker.LastEnemyAttacked

		if e and (settings.combo.comboKey and settings.combo.autow) or settings.harass.harassKey and settings.harass.w then
			CastW()
		end
	else
		if (settings.combo.comboKey and settings.combo.autow) or (settings.harass.harassKey and settings.harass.w) then
			CastW()
		end
	end
end

-- Cast E
function mythdunk:CastE(unit)
	if ValidTarget(unit, spells.e.range-8) and spells.e.ready then
		if ValidTarget(unit, settings.combo.donte) then return end
		if settings.combo.packets then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
		else
			CastSpell(_E, unit.x, unit.z)
		end
	end	
end	

-- Cast ult
function mythdunk:CastR(unit)
	if ValidTarget(unit, spells.r.range) and getRdmg(unit) >= unit.health and spells.r.ready then
		if settings.combo.packets then
			Packet("S_CAST", {spellId = _R, targetNetworkId = unit.networkID}):send()
		else
			CastSpell(_R, unit)
		end
	end	
end	

-- Cast ult without finisher check
function mythdunk:subUlt(unit)
	if ValidTarget(unit, spells.r.range) and spells.r.ready then
		if settings.combo.packets then
			Packet("S_CAST", {spellId = _R, targetNetworkId = unit.networkID}):send()
		else
			CastSpell(_R, unit)
		end
	end	
end	

-- Full Combo
function mythdunk:shoot(unit)
	if SACLoaded then
		AutoCarry.Orbwalker:Orbwalk(unit)
	else
		SxOrb:ForceTarget(unit)
	end
	if settings.ult.autoR then
		mythdunk:CastR(unit)
	end
	if settings.combo.autoe then
		mythdunk:CastE(unit)
	end
	if settings.combo.autoq then
		mythdunk:CastQ(unit)
	end
end

function mythdunk:Harass(unit)

	if settings.harass.autoq and ValidTarget(unit,425) and myHero:GetDistance(unit) > 290 then
		mythdunk:CastQ(unit)
	end

	if not settings.harass.harassKey then return end

	if settings.harass.q and ValidTarget(unit, spells.q.range) then
		mythdunk:CastQ(unit)
	end
end

-- Minion farm
function mythdunk:Farm()
	creep:update()
		
	for i, minion in pairs(creep.objects) do

		if not settings.farm.farmkey then return end

		if settings.farm.farmq and getDmg("Q", minion, myHero) >= minion.health then
			mythdunk:CastQ(minion)
		end

		if settings.farm.farmw then
			CastW()
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
function mythdunk:getTarg()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then _G.AutoCarry.Crosshair:SetSkillCrosshairRange(1200) return _G.AutoCarry.Crosshair:GetTarget() end		
	if ValidTarget(SelectedTarget) then return SelectedTarget end
	return ts.target
end

-- Hemmorage stack calculation
function OnCreateObj(object)
	if GetDistance(myHero, object) >= 500 then return end
	for k, v in pairs(stacktbl) do
		if object.name == v then
			for i, e in pairs(GetEnemyHeroes()) do
				if mythdunk:getTarg() == e then
	           	 	e.stack = k
	           	end
	        end
	    end
	end
end

-- R damage calculation
function getRdmg(unit)
	for i, e in pairs(GetEnemyHeroes()) do
		if e == unit then
			if e.stack == nil then e.stack = 0 end
			local dmg = getDmg("R", unit, myHero)
	        local totaldmg = dmg + e.stack * dmg * 20 / 100

	        --print(totaldmg)
	        return totaldmg
		end
	end
end

-- Invulnerable check
function ultcalc(unit)
	if not TargetHaveBuff("JudicatorIntervention", unit) or TargetHaveBuff("Undying Rage", unit) then
		return true
	end
end

----------------------
--      Hooks       --
----------------------

-- Init hook
function OnLoad()
	print("<font color='#009DFF'>[MythDunk]</font><font color='#FFFFFF'> has loaded!</font> <font color='#2BFF00'>[v"..version.."]</font>")

	if autoupdate then
		update()
	end

	ts = TargetSelector(TARGET_LOW_HP, 600, DAMAGE_PHYSICAL, false, true)
	creep = minionManager(MINION_ENEMY, 200, myHero, MINION_SORT_HEALTH_ASC)

	mythdunk:Menu()

	DelayAction(orbwalkCheck,7)
end

-- Tick hook
function OnTick()
	mythdunk:readyCheck()

	ts:update()

	local hp = myHero.health / myHero.maxHealth * 100

	if settings.farm.farmkey then
		mythdunk:Farm()
	end

	if settings.ks.r or settings.ks.q then
		for k, v in pairs(GetEnemyHeroes()) do
			if settings.ks.r then
				if ValidTarget(v, spells.r.range) then
					mythdunk:CastR(v)
				end
			elseif settings.ks.q then
				if ValidTarget(v, spells.q.range) and getDmg("Q", v, myHero) >= v.health then
					mythdunk:CastQ(v)
				end
			end
		end
	end

	if not ValidTarget(mythdunk:getTarg()) then return end

	local targ = mythdunk:getTarg()

	if settings.harass.harassKey or settings.harass.autoq then
		mythdunk:Harass(targ)
	end

	if settings.combo.comboKey then
		mythdunk:shoot(targ)
	end

	if settings.ult.ultHP and hp <= settings.ult.ultpct and settings.ult.ultpct ~= 0 then
		mythdunk:subUlt(targ)
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
		mythdunk:DrawCircle(myHero.x, myHero.y, myHero.z, spells.q.range, ARGB(255,0,255,0))
		if settings.combo.qmax then
			mythdunk:DrawCircle(myHero.x, myHero.y, myHero.z, 290, ARGB(255,0,255,0))
		end
	end

	if settings.draw.w and spells.w.ready then
		mythdunk:DrawCircle(myHero.x, myHero.y, myHero.z, spells.w.range, ARGB(255,255,255,0))
	end

	if settings.draw.e and spells.e.ready then
		mythdunk:DrawCircle(myHero.x, myHero.y, myHero.z, spells.e.range, ARGB(255,255,110,0))
	end

	if settings.draw.r and spells.r.ready then
		mythdunk:DrawCircle(myHero.x, myHero.y, myHero.z, spells.r.range, ARGB(255,255,0,0))
	end

	if settings.draw.target and ValidTarget(mythdunk:getTarg()) then
		local targ = mythdunk:getTarg()
		mythdunk:DrawCircle(targ.x, targ.y, targ.z, 100, ARGB(255,255,120,0))
	end

	if ValidTarget(mythdunk:getTarg()) and settings.draw.rdmg then
		local targ = mythdunk:getTarg()
		DrawLineHPBar(getRdmg(targ), 1, " R Damage: "..math.round(getRdmg(targ)), targ, true)
	end
end

-- Menu creation
function mythdunk:Menu()
	settings = scriptConfig("MythDunk", "mythik")
	TargetSelector.name = "MythDunk"
	settings:addTS(ts)

	settings:addSubMenu("Combo", "combo")
	settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	settings.combo:addParam("autoq", "Auto Q", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("autow", "Auto W", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("autoe", "Auto E", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("focus", "Focus selected target", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("qmax", "Only Q in max range", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("packets", "Use packet casting", SCRIPT_PARAM_ONOFF, true)
	settings.combo:addParam("donte", "Only pull if range >", SCRIPT_PARAM_SLICE, 200, 0, 300, 0)

	settings:addSubMenu("Harass", "harass")
	settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
	settings.harass:addParam("autoq", "Auto Q at max range", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
	settings.harass:addParam("q", "Harass with Q", SCRIPT_PARAM_ONOFF, true)
	settings.harass:addParam("w", "Harass with W", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("Farm", "farm")
	settings.farm:addParam("farmkey", "Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, 86)
	settings.farm:addParam("farmq", "Farm with Q", SCRIPT_PARAM_ONOFF, true)
	settings.farm:addParam("farmw", "Farm with W", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("Ultimate", "ult")
	settings.ult:addParam("autoR", "Use ult in combo", SCRIPT_PARAM_ONOFF, true)
	settings.ult:addParam("ultHP", "Ult on Low HP (You)", SCRIPT_PARAM_ONOFF, true)
	settings.ult:addParam("ultpct", "Use ult below health %", SCRIPT_PARAM_SLICE, 25, 0, 35, 0)

	settings:addSubMenu("Kill Steal", "ks")
	settings.ks:addParam("r", "Use R", SCRIPT_PARAM_ONOFF, true)
	settings.ks:addParam("q", "Use Q", SCRIPT_PARAM_ONOFF, true)

	settings:addSubMenu("Drawing", "draw")
	settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, false)
	settings.draw:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("r", "Draw R", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("rdmg", "Draw R Damage", SCRIPT_PARAM_ONOFF, true)
	settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)
end


--Lag Free Circles
function mythdunk:DrawCircle(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		self:DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end

function mythdunk:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
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

function mythdunk:Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("TGJIGGIGKNO") 