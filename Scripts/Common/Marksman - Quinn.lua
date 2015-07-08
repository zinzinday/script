-----------------------------
-- QuinnMadness by Kqmii --
-----------------------------
if myHero.charName ~= "Quinn" then return end 
local currentVersion = 1.1
local AutoUpdate = true
function OnLoad()
	updateScript()
	CleanOnLoad()
end
function OnTick()
	CleanOnTick()
end
function OnDraw()
	CleanOnDraw()
end
------------------------
function CleanOnLoad()
	Vars()
	GetOrbwalkers()
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then Ignite.slot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then Ignite.slot = SUMMONER_2 end
	Menu()
	LoadDmg()
	if heroManager.iCount == 10 then
		arrangeTarget()
	else
		PrintChat("Not enought champion to arrange priority")
	end
end
function CleanOnTick(target)
	QSPELL.ready = myHero:CanUseSpell(QSPELL.key) == READY
	WSPELL.ready = myHero:CanUseSpell(WSPELL.key) == READY
	ESPELL.ready = myHero:CanUseSpell(ESPELL.key) == READY
	RSPELL.ready = myHero:CanUseSpell(RSPELL.key) == READY
	Ignite.ready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	TickDmg()
	ComboKey = quinnCFG.combo.comboKey
	HarassKey = quinnCFG.harass.harassKey
	KStoggle = quinnCFG.ks.ksToggle
	DefToggle = quinnCFG.defensive.defToggle
	ts:update()
	target = CustomTarget()
	SpellExpired()
	if ComboKey and target ~= nil then
		Combo(target)
	end
	if HarassKey and target ~= nil then
		Harass(target)
	end
	if KStoggle then
		KS()
	end
	if DefToggle then
		DefE()
	end
	if quinnCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
function CleanOnDraw()
	if not myHero.dead then
		if quinnCFG.draw.qDraw and QSPELL.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, QSPELL._HUMAN_RANGE, ARGB(255,0,255,0))
		end
		if quinnCFG.draw.wDraw and WSPELL.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, WSPELL.range, ARGB(255,0,255,0))
		end
		if quinnCFG.draw.eDraw and ESPELL.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, ESPELL.range, ARGB(255,0,255,0))
		end
		if quinnCFG.draw.rDraw and GetState() == _BIRD then
			DrawCircle(myHero.x, myHero.y, myHero.z, RSPELL.range, ARGB(255,0,255,0))
		end
		if quinnCFG.draw.drawDamage then
			for i, target in pairs(GetEnemyHeroes()) do
				if ValidTarget(target) and not target.dead then
					local dmg = 0
					for _, spell in pairs(Spells) do
						if spell.dmg ~= nil and spell.dmg[target.networkID] ~= nil and spell.text ~= nil and spell.ready then
							dmg = dmg + spell.dmg[target.networkID]
							if dmg >= target.health then
								dmg = target.health
								break
							end
							if spell.text ~= "P" then
								DrawLineHPBar(dmg,1,spell.text,target)
							end
						end
					end
					local fullcombo = ComboDmg(target, dmg)
					DrawLineHPBar(fullcombo,1,"C",target)
				end
			end			
		end	
		if quinnCFG.draw.cDraw then
			if ValidTarget(target) and not target.dead then
				DrawCircle(target.x, target.y, target.z, 90, ARGB(255,255,0,0))
				DrawCircle(target.x, target.y, target.z, 100, ARGB(255,255,0,0))
				DrawCircle(target.x, target.y, target.z, 110, ARGB(255,255,0,0))
			end
		end
	end
end
-----------------------
function Vars()
	PrintChat ("<font color=\"#33CC99\"><b>QuinnMadness by Kqmii</b></font>"..currentVersion.."<font color=\"#33CC99\"><b>Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	require 'VPrediction'
	VP = VPrediction()
	require 'SxOrbwalk'
	SxOrb = SxOrbWalk(VP)
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_PHYSICAL)
	target = nil
	quinnCFG = scriptConfig("QuinnMadness", "QKQ")
	SACLoaded = false
	_QDATBICH = nil
	_HUMAN, _BIRD = 0, 1
	PASSIVE = { name = "Harrier", text = "P", dmg ={} }
	ATTACK = { name = "Auto Attack", range = 525, meleeRange = 125, Cancel = false, text = "AD", dmg = {}}
	QSPELL = { name = "Blinding Assault", _HUMAN_RANGE = 1025, _BIRD_RANGE = 275, delay = 0.40, width = 80, speed = 1200, ready = false, key = _Q, text = "Q", dmg ={}}
	WSPELL = { name = "Heightened Senses", range = 2000, delay = nil, width = nil, speed = nil, ready = false, key = _W, dmg = {}}
	ESPELL = { name = "Vault", range = 725, delay = 0.5, width = nil, speed = 1000, ready = false, key = _E, text = "E", dmg = {}}
	RSPELL = { _HUMAN_NAME = "Tag Team", _BIRD_NAME = "Skystrike", range = 700, delay = 0.01, width = nil, speed = math.huge, ready = false, key = _R, text = "R", dmg = {}}
	Ignite = { name = "summonerdot", range = 600, slot = nil, ready = false }
	Spells = {}
	Items = {
	BWC = { id = 3144, range = 400, reqTarget = true, slot = nil },
	DFG = { id = 3128, range = 750, reqTarget = true, slot = nil },
	HGB = { id = 3146, range = 400, reqTarget = true, slot = nil },
	BFT = { id = 3188, range = 750, reqTarget = true, slot = nil },
	BRK = { id = 3153, range = 450, reqTarget = true, slot = nil },
	RSH = { id = 3074, range = 300, reqTarget = false, slot = nil },
	STD = { id = 3131, range = 350, reqTarget = false, slot = nil },
	TMT = { id = 3077, range = 300, reqTarget = false, slot = nil },
	YGB = { id = 3142, range = 350, reqTarget = false, slot = nil },
	RND = { id = 3143, range = 275, reqTarget = false, slot = nil },
	}
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	Spells.PASSIVE, Spells.ATTACK, Spells.QSPELL, Spells.WSPELL, Spells.ESPELL, Spells.RSPELL = PASSIVE,ATTACK,QSPELL,WSPELL,ESPELL,RSPELL
	informationTable = {}
	spellExpired = true
end
function Menu()
	quinnCFG:addSubMenu("Quinn - Combo", "combo")
		quinnCFG.combo:addSubMenu("Q Config", "qConfig")
			quinnCFG.combo.qConfig:addParam("qUse", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
			quinnCFG.combo.qConfig:addParam("qOnAttack", "Auto Q Champ attacking me", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.combo:addSubMenu("E Config", "eConfig")
			quinnCFG.combo.eConfig:addParam("eUse", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
			quinnCFG.combo.eConfig:addParam("smartE", "Smart use of E", SCRIPT_PARAM_ONOFF, true)
			quinnCFG.combo.eConfig:addParam("autoE", "Auto E Gapclosing spells", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.combo:addSubMenu("R Config", "rConfig")
			quinnCFG.combo.rConfig:addParam("rUse", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
			quinnCFG.combo.rConfig:addParam("rHp", "Human form when target hp < %",SCRIPT_PARAM_SLICE, 40,0,100,0)
		quinnCFG.combo:addParam("useItem", "Use item in combo", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
	quinnCFG:addSubMenu("Quinn - Harass", "harass")
		quinnCFG.harass:addParam("qHarass", "Use Q to harass", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.harass:addParam("eHarass", "Use E to harass", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.harass:addParam("harassKey", "Harass key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	quinnCFG:addSubMenu("Quinn - Ks", "ks")
		quinnCFG.ks:addParam("qKs", "Use Q to ks", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.ks:addParam("eKs", "Use E to ks", SCRIPT_PARAM_ONOFF, true)
		if Ignite.slot ~= nil then
		quinnCFG.ks:addParam("iKs", "Use ignite to ks", SCRIPT_PARAM_ONOFF, true)
		end
		quinnCFG.ks:addParam("rKs", "Use R if in Bird form", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.ks:addParam("ksToggle", "Ks toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
	quinnCFG:addSubMenu("Quinn - Defensive E", "defensive")
		quinnCFG.defensive:addParam("minD", "Target min. distance to me", SCRIPT_PARAM_SLICE, 125, 10, 300, 0)
		quinnCFG.defensive:addParam("defToggle", "Defensive E key Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("G"))
	quinnCFG:addSubMenu("Quinn - Drawings", "draw")
		quinnCFG.draw:addParam("qDraw", "Draw Q range", SCRIPT_PARAM_ONOFF, false)
		quinnCFG.draw:addParam("wDraw", "Draw W range", SCRIPT_PARAM_ONOFF, false)
		quinnCFG.draw:addParam("eDraw", "Draw E range", SCRIPT_PARAM_ONOFF, false)
		quinnCFG.draw:addParam("rDraw", "Draw R range in Bird form", SCRIPT_PARAM_ONOFF, false)
		quinnCFG.draw:addParam("drawDamage", "Draw Damage", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.draw:addParam("cDraw", "Draw current target", SCRIPT_PARAM_ONOFF, true)
		quinnCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
		quinnCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
		quinnCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
	if SACLoaded then
		quinnCFG:addParam("qqq", "-- SAC Detected --", SCRIPT_PARAM_INFO, "")
	else
		quinnCFG:addSubMenu("Quinn - Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(quinnCFG.SxOrb)
	end
	quinnCFG:addTS(ts)
		ts.name = "Quinn -"
		
	quinnCFG.combo:permaShow("comboKey")
	quinnCFG.harass:permaShow("harassKey")
	quinnCFG.ks:permaShow("ksToggle")
	quinnCFG.defensive:permaShow("defToggle")
end
-----------------------
function GetOrbwalkers()
	if _G.Reborn_Loaded then
		PrintChat("QuinnMadness : SAC Detected #TheChristelleIsComing")
		SACLoaded = true
	else
		PrintChat("QuinnMadness : SxOrb Loaded #TheJosetteIsOnFire")
	end
end
function EnemyNearRangeLimit(obj, range)
	if GetDistance(obj) >= (range * 0.98) then return true end
	return false
end
function EnemyFleeing(target, pos)
	if GetDistance(pos) > GetDistance(target) then return true end
	return false
end
function GetState()
	if myHero.range <= (ATTACK.meleeRange + 30) then
		return _BIRD
	else
		return _HUMAN
	end
end
function DoGapClose(unit)
	if ValidTarget(unit, ESPELL.range) then
		if GetState() == _HUMAN then
			local Position, HitChance = VP:GetPredictedPos(unit, ESPELL.delay, ESPELL.speed, myHero)
			if Position and HitChance >= 1 then
				if EnemyFleeing(unit, Position) and EnemyNearRangeLimit(Position, ESPELL.range) then return true end
			end
		elseif GetDistance(unit) > myHero.range then return true end
		return false
	end
end
function HpCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
		then return true
	else
		return false
	end
end
function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
		then return true
	else
		return false
	end
end
function OnProcessSpell(unit, spell)
	if quinnCFG.combo.eConfig.autoE then
		local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and _R or _Q
		local	GapCloseSpells = {
						['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
						['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, }, 
						['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, }, 
						['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, }, 
						['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
						['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
						['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, }, 
						['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, }, 
						['Jax']         = {true, spell = _Q,                  range = 700,   projSpeed = 2000, }, 
						['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, }, 
						['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
						['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
						['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
						['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
						['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500 + unit.ms},
						['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, }, 
						['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, }, 
						['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, }, 
						['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, }, 
						['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
						['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
						['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
						['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
						['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
						['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, }, 
					}
		if GetState() == _HUMAN then
			if unit.type == myHero.type and unit.team ~= myHero.team and GapCloseSpells[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then
				if spell.name == (type(GapCloseSpells[unit.charName].spell) == "number" and unit:GetSpellData(GapCloseSpells[unit.charName].spell).name or GapCloseSpells[unit.charName].spell) then
					if spell.target ~= nil and spell.target.isMe or GapCloseSpells[unit.charName].spell == "blindmonkqtwo" then
						if ESPELL.ready then
							CastSpell(ESPELL.key, unit)
						end
					else
						spellExpired = false
						informationTable = {
							spellSource = unit,
							spellCastedTick = GetTickCount(),
							spellStartPos = Point(spell.startPos.x, spell.startPos.z),
							spellEndPos = Point(spell.endPos.x, spell.endPos.z),
							spellRange = GapCloseSpells[unit.charName].range,
							spellSpeed = GapCloseSpells[unit.charName].projSpeed
						}
					end
				end
			end
		end
	end
	if quinnCFG.combo.qConfig.qOnAttack then
		if unit.type == myHero.type and unit.team ~= myHero.team and spell.target and spell.target == myHero then
			if spell.name:lower():find("attack") or spell.name:lower():find("monkeykingdoubleattack") then
				if GetDistance(unit) < QSPELL._HUMAN_RANGE and GetState() == _HUMAN and ValidTarget(unit) then
					local Position, HitChance = VP:GetLineCastPosition(unit, QSPELL.delay, QSPELL.width, QSPELL._HUMAN_RANGE, QSPELL.speed, myHero, true)
					if Position and HitChance >= 2 and GetDistance(Position) < QSPELL._HUMAN_RANGE then
						CastSpell(QSPELL.key, Position.x, Position.z)
					end
				elseif GetState() == _BIRD and GetDistance(unit) < QSPELL._BIRD_RANGE and ValidTarget(unit) then
					CastSpell(QSPELL.key)
				end
			end
		end
	end
	if quinnCFG.combo.eConfig.smartE then
		if unit.isMe and spell.name == "QuinnWEnhanced" and GetState() == _HUMAN then
			local windUpTime = spell.windUpTime
			ATTACK.Cancel = false
			if ValidTarget(spell.target) and spell.target.networkID == unit.networkID then
				DelayAction(function(target)
					if not ATTACK.Cancel and ValidTarget(unit) then
						if ComboKey then
							CastSpell(ESPELL.key, unit)
						end
					end
				end, windUpTime + GetLatency() / 6000, {spell.target})
			end
		end
	end
end
function SpellExpired()
	if quinnCFG.combo.eConfig.autoE and GetState() == _HUMAN and not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange / informationTable.spellSpeed) * 1000 then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
		if lineSegment:distance(heroPosition) <= 200 and ESPELL.ready then
			CastSpell(ESPELL.key, unit)
		end
	else
		spellExpired = true
		informationTable = {}
	end
end
-----------------------
function Combo(target)
	if quinnCFG.combo.useItem then
		UseItems(target)
	end
	if quinnCFG.combo.qConfig.qUse then
		Qcombo(target)
	end
	if quinnCFG.combo.eConfig.eUse then
		Ecombo(target)
	end
	if quinnCFG.combo.rConfig.rUse then
		Rcombo(target)
	end
end
function Harass(target)	
		if quinnCFG.harass.qHarass then
			Qcombo(target)
		end
		if quinnCFG.harass.eHarass then
			Ecombo(target)
		end
end
function KS()
	for i, target in ipairs(GetEnemyHeroes()) do
		local qDmg = getDmg("Q", target, myHero)
		local eDmg = getDmg("E", target, myHero)
		local rDmg = getDmg("R", target, myHero)
		local iDmg = 50 +(20*myHero.level)
		if GetState() == _HUMAN then
			if quinnCFG.ks.qKs then
				if ValidTarget(target, QSPELL._HUMAN_RANGE) and not target.dead then
					if target.health < qDmg and QSPELL.ready then
						local Position, HitChance = VP:GetLineCastPosition(target, QSPELL.delay, QSPELL.width, QSPELL._HUMAN_RANGE, QSPELL.speed, myHero, true)
						if Position and HitChance >= 2 and GetDistance(Position) < QSPELL._HUMAN_RANGE then
							CastSpell(QSPELL.key, Position.x, Position.z)
						end 
					end
				end
			end
			if quinnCFG.ks.eKs then
				if ValidTarget(target, ESPELL.range) and not target.dead then
					if target.health < eDmg and ESPELL.ready then
						CastSpell(ESPELL.key, target)
					end
				end
			end
		else
			if GetState() == _BIRD then
				if quinnCFG.ks.rKs then
					if ValidTarget(target, RSPELL.range) and not target.dead then
						if target.health < rDmg and RSPELL.ready then
							CastSpell(RSPELL.key)
						end
					end
				end
			end
		end
		if quinnCFG.ks.iKs then
			if Ignite.slot ~= nil and Ignite.ready then
				if ValidTarget(target, Ignite.range) and not target.dead then
					if target.health < iDmg then
						CastSpell(Ignite.slot, target)
						
					end
				end
			end
		end
	end
end
-----------------------
function Qcombo(target)
	if GetState() == _BIRD then
		if ValidTarget(target, QSPELL._BIRD_RANGE) and not target.dead then
			if GetDistance(target) < QSPELL._BIRD_RANGE then
				CastSpell(QSPELL.key)
			end
		end
	else 
		if ValidTarget(target, QSPELL._HUMAN_RANGE) and not target.dead then
			local Position, HitChance = VP:GetLineCastPosition(target, QSPELL.delay, QSPELL.width, QSPELL._HUMAN_RANGE, QSPELL.speed, myHero, true)
			if Position and HitChance >= 2 and GetDistance(Position) < QSPELL._HUMAN_RANGE then
				CastSpell(QSPELL.key, Position.x, Position.z)
			end
		end
	end
end
function Ecombo(target)
	if ValidTarget(target) and not target.dead then
		if DoGapClose(target) then
			CastSpell(ESPELL.key, target)
		else 
			CastSpell(ESPELL.key, target)
		end
	end
end
function Rcombo(target)
	local rDmg = getDmg("R", target, myHero)
	local aaDmg = getDmg("AD", target, myHero)
	if ValidTarget(target) and not target.dead and target ~= nil then
		if GetState() == _HUMAN then
			if GetDistance(target) > 700 and RSPELL.ready and not ESPELL.ready then
				CastSpell(RSPELL.key)
			end	
		end
		if GetState() == _BIRD then
			if GetDistance(target) < 400 and HpCheck(target, quinnCFG.combo.rConfig.rHp) then
				CastSpell(RSPELL.key)
			end
		end
	end
end
function DefE()
	for i, target in ipairs(GetEnemyHeroes()) do
		if ValidTarget(target, ESPELL.range) and not target.dead then
			if myHero.health <= (myHero.maxHealth * 0.25) or GetDistance(target) <= quinnCFG.defensive.minD then
				CastSpell(ESPELL.key, target)
			end
		end
	end
end
-----------------------
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
	return Vector(barPos.x , barPos.y, 0), Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end
function DrawLineHPBar(damage, line, text, unit)
	local thedmg = 0
	if damage >= unit.maxHealth then
		thedmg = unit.maxHealth - 1
	else
		thedmg = damage
	end
	local barPos, StartPos, EndPos = GetHPBarPos(unit)
	if (OnScreen(barPos.x, barPos.y)) then
		local Real_X = StartPos.x + 24
		local Offs_X = (Real_X + ((unit.health-thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
		if Offs_X < Real_X then Offs_X = Real_X end	
		local mytrans = 350 - math.round(255 * ((unit.health - thedmg) / unit.maxHealth)) --- 255 * 0.5
		if mytrans >= 255 then 
			mytrans = 254 
		end
		local my_bluepart = math.round(400 * ((unit.health-thedmg) / unit.maxHealth))
		if my_bluepart >= 255 then 
			my_bluepart = 254
		end

		DrawLine(Offs_X - 150, StartPos.y - (30 + (line * 25)), Offs_X - 150, StartPos.y - 2, 1, ARGB(mytrans, 255, my_bluepart, 0))
		DrawText(tostring(text), 15, Offs_X - 145, StartPos.y - (30 + (line * 25)), ARGB(mytrans, 255, my_bluepart, 0))
	end
end
function ComboDmg(target, dmg)
	return (dmg + (PASSIVE.dmg[target.networkID]*2)+(QSPELL.dmg[target.networkID]))
end
function LoadDmg()
	for i, a in pairs(GetEnemyHeroes()) do
		if a ~= nil and a.valid then
			for _, spell in pairs(Spells) do
				if spell.dmg ~= nil and spell.text ~= nil then
					spell.dmg[a.networkID] = 01
				end
			end
		end			
	end	
end
function TickDmg()
	for i, a in ipairs(GetEnemyHeroes()) do
		if a ~= nil and a.valid then
			for _, spell in pairs(Spells) do
				if spell.dmg ~= nil and spell.text ~= nil then
					spell.dmg[a.networkID] = getDmg(spell.text, a, myHero)
				end
			end
		end
	end
end
-----------------------
function CustomTarget()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 900) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	if ts.target and not ts.target.dead and ts.target.type == myHero.type then
		return ts.target
	else
		return nil
	end
end
function OnWndMsg(msg, key)
	if msg == WM_LBUTTONDOWN then
		local minD = 200
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and not unit.dead then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
				end
			end
		end
		if target and minD < 200 then
			if SelectedTarget and target.charName == SelectedTarget.charName then
				SelectedTarget = nil
				print("Target unselected")
			else
				SelectedTarget = target
				print("Target Selected: "..SelectedTarget.charName)
			end
		end
	end
end
-----------------------
function UseItems(target)
	if target ~= nil and not UltON then
		for _, item in pairs(Items) do
			item.slot = GetInventorySlotItem(item.id)
			if item.slot ~= nil then
				if item.reqTarget and GetDistance(target) < item.range then
					CastSpell(item.slot, target)
				elseif not item.reqTarget then
					if GetDistance(target) < item.range then
						CastSpell(item.slot)
					end
				end
			end
		end
	end
end
-----------------------
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
  radius = radius or 300
  quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
  
  local points = {}
  for theta = 0, 2 * math.pi + quality, quality do
    local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
    points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  
  DrawLines2(points, width or 1, color or 4294967295)
end
function round(num) 
  if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  
  if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
    DrawCircleNextLvl(x, y, z, radius, quinnCFG.draw.Width, color, quinnCFG.draw.CL) 
  end
end
-----------------------
TargetTable ={
				AP = {"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus", "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"},
				Support = {"Alistar", "Blitzcrank","Bard", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"},
				Tank = {"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear", "Warwick", "Yorick", "Zac", "Renekton"},
				AD_Carry = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Kalista", "Lucian", "MasterYi", "MissFortune", "Quinn", "Shaco", "Sivir", "Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"},
				Bruiser = {"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy", "Pantheon", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"}
			 }	
function arrangeTarget()
		for i, enemy in ipairs(GetEnemyHeroes()) do
			SetPriority(TargetTable.AD_Carry, enemy, 1)
			SetPriority(TargetTable.AP, enemy, 1)
			SetPriority(TargetTable.Support, enemy, 2)
			SetPriority(TargetTable.Bruiser, enemy, 3)
			SetPriority(TargetTable.Tank, enemy, 4)
		end
end
function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
-----------------------
if AutoUpdate == true then
function updateScript()
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/QuinnMadness.version", "/kqmii/BolScripts/master/QuinnMadness.lua", SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>QuinnMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>QuinnMadness: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
			end 
		end)
end
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
    DelayAction(function() self.UpdateDone = true end, 2)
end
function SxUpdate:GetOnlineVersion()
    if self.UpdateDone then return end
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
            if not self.OnlineVersion then print(self.VersionReceive) end
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

    self.UpdateDone = true
end
end
-------------------
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLQORRMOO") 
