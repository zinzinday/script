--[[
 
        Auto Carry Plugin - Lucian Edition
		Author: Kain
		Version: 1.1f
		Copyright 2013

		Dependency: Sida's Auto Carry: Revamped
 
		How to install:
			Make sure you already have AutoCarry installed.
			Name the script EXACTLY "SidasAutoCarryPlugin - Lucian.lua" without the quotes.
			Place the plugin in BoL/Scripts/Common folder.
		
		Version History:
			Version: 1.1f: http://pastebin.com/Z3ipPQDE
				Fixed hero multishot bugs.
			Version: 1.1e: http://pastebin.com/Z3ipPQDE
				Added Multi-shot.
				Added Smart Farm with Q.
				Added Mana Manager checks.
				Split menu into two menus.
				Fixed non-vip smart farming bug.
			Version: 1.08c: http://pastebin.com/D5NwQUae
				Fixed Combo weaving.
				Added spell initiation if AA unavailable.
				Fixed auto attack before Q.
				Fixed Killsteal.
				Added Smart Cast angles to Q. Won't fire if probability of missing is too high.
				Added minimum range to shoot Ultimate to avoid complete misses.
				Fixed stand still and shoot range.
				Fixed a bug with R.
				Using SAC with "Enabled Jungle Clearing" enabled doesn't use R now.
			Version: 1.07e: http://pastebin.com/kgFKdwuS
				Sword of the Divine supported.
				Improved dynamic draw ranges.
				Harass fixed. Fires Q.
				Hack fixed killsteal until BoL finally gets updated properly.
				Killsteal fix resolved firing spells without key pressed.
			Version: 1.07c: http://pastebin.com/tK2WNXsy
				Relentless Pursuit Out of Enemy slows.
				Tweaked prediction variables.
				Killsteal enabled.
			Version: 1.06c: http://pastebin.com/sdvmmNyR
				Spell weaving.
				Draw range logic improvement.
				Menu updates.
			Version: 1.05d Beta: http://pastebin.com/rE5X8puE
				Improvements to mechanics of Culling Lockon. (Still more to do here.)
				Fix issue with Ultimate ending early.
				Miscellaneous bug fixes.
			Version: 1.04 Beta Pre-Release: http://pastebin.com/ayEX5Bfq
				Culling Lockon added. Considered experimental, but seems to be working pretty well.
			Version: 1.02 Beta Pre-Release: http://pastebin.com/tXxr95g9
			Version: 1.0 Alpha: http://pastebin.com/xWbRz89K
--]]

if myHero.charName ~= "Lucian" then return end

-- VIP_USER = false -- For testing only.

function PluginOnLoad()
	Vars()
	Menu()

	AutoCarry.SkillsCrosshair.range = QMaxRange
end

function Vars()
	tick = nil
	Target = nil

	version = "1.1e"

	-- Confirm ranges on release.
	QRange = 550
	QMaxRange = 1100
	WRange = 1000
	ERange = 425
	RRange = 1400

	QSpeed = 19.346
	WSpeed = 1.47 -- Old: 1.009
	ESpeed = 3.867
	RSpeed = 2.9 -- Old: 1.3

	QWidth = 250
	WWidth = 250
	EWidth = 250
	RWidth = 250

	QDelay = 405
	WDelay = 288 -- Old: 256
	EDelay = 1070
	RDelay = 200

	RRefresh = 0.1
	RDuration = 3.2 -- Old: 3.0 2.871 - 3.167

	ParticleRProjectileName = "Lucian_R_mis.troy"
	ParticleRProjectileNameOld = "bowMaster_volley_mis.troy"
	ParticleR = "Lucian_R_tar.troy"
	ParticleRFiring = "Lucian_R_self.troy"

	-- Start New
	BuffPassive = "lucianpassivebuff" -- Old: "Lightslinger"
	BuffW = "lucianwcastingbuff"
	BuffR = "LucianR"

	-- End New
--[[
	Raw data dump:

	spellName = LucianBasicAttack
	projectileName = ???
	castDelay = 4001.50 (827.00-7176.00)
	projectileSpeed = 6321.08 (724.19-11917.96)
	range = 2594.85 (541.70-4648.01)

	spellName = LucianW
	projectileName = Lucian_W_mis.troy
	castDelay = 288.67 (265.00-297.00)
	projectileSpeed = 1484.95 (1391.22-1640.62)
	range = 661.85 (304.68-1000.83)

	spellName = LucianE
	projectileName = Lucian_W_mis.troy
	castDelay = 8189.75 (0.00-32245.00)
	projectileSpeed = 25590.51 (703.58-79656.61)
	range = 3772.70 (372.90-8054.26)

	spellName = LucianR
	projectileName = Lucian_R_mis.troy
	castDelay = 210.50 (187.00-234.00)
	projectileSpeed = 2850.25 (2342.64-3357.86)
	range = 405.05 (261.91-548.18)

	Raw data dump #2:

	spellName = LucianW
	projectileName = Lucian_W_mis.troy
	castDelay = 313.81 (265.00-453.00)
	projectileSpeed = 1459.60 (558.14-1797.76)
	range = 648.24 (17.30-1007.14)

	spellName = LucianE
	projectileName = Lucian_W_mis.troy
	castDelay = 2147.83 (0.00-10530.00)
	projectileSpeed = 4680.15 (632.65-14746.30)
	range = 3349.24 (809.79-8272.67)

	spellName = LucianR
	projectileName = Lucian_R_mis.troy
	castDelay = 199.80 (172.00-218.00)
	projectileSpeed = 3023.31 (2816.79-3321.66)
	range = 757.80 (205.94-1063.38)

--]]

	SkillQ = {spellKey = _Q, range = QRange, speed = QSpeed, delay = QDelay, width = QWidth, configName = "piercinglight", displayName = "Q (Piercing Light)", enabled = true, skillShot = true, minions = false, reset = false, reqTarget = true }
	SkillW = {spellKey = _W, range = WRange, speed = WSpeed, delay = WDelay, width = WWidth, configName = "ardentblaze", displayName = "W (Ardent Blaze)", enabled = true, skillShot = true, minions = false, reset = false, reqTarget = false }
	SkillE = {spellKey = _E, range = ERange, speed = ESpeed, delay = EDelay, width = EWidth, configName = "relentlesspursuit", displayName = "E (Relentless Pursuit)", enabled = true, skillShot = true, minions = false, reset = false, reqTarget = false }
	SkillR = {spellKey = _R, range = RRange, speed = RSpeed, delay = RDelay, width = RWidth, configName = "theculling", displayName = "R (The Culling)", enabled = true, skillShot = true, minions = false, reset = false, reqTarget = true }

	KeyQ = string.byte("Q")
	KeyW = string.byte("W")
	KeyE = string.byte("E")
	KeyR = string.byte("R")

	KeyTest = string.byte("U")

	DFGSlot, HXGSlot, BWCSlot, STDSlot, SheenSlot, TrinitySlot, LichBaneSlot = nil, nil, nil, nil, nil, nil, nil
	QReady, WReady, EReady, RReady, DFGReady, HXGReady, BWCReady, STDReady, IReady = false, false, false, false, false, false, false, false

	ultCastTick = 0
	ultCastTarget = nil
	ultVectorX = nil
	ultVectorZ = nil

	isSlowed = false

	healthLastTick = 0
	healthLastHealth = 0

	isUltFiring = false
	lastUltMessage = 0

	comboActive = false
	nextAttack = 0
	lastSpell = 0

	-- Angles
	angle_towards = 180
	angle_away = 0
	angle_parallel_towards = 90
	angle_parallel_away = 270
	angle_unknown = -1

	-- Collision
    TYPE_ALL = 1
    TYPE_HERO = 2
	TYPE_MINION = 3

	lastText = 0

	debugMode = false
	debugModeDisableNonR = false
end

function Menu()
	AutoCarry.PluginMenu:addParam("sep", "----- Lucian by Kain: v"..version.." -----", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("sep", "----- [ Combo ] -----", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("Combo", "Combo - Default Spacebar", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("FullCombo", "Insta Blast Combo (No AA)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	AutoCarry.PluginMenu:addParam("ComboQ", "Use Piercing Light", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("ComboW", "Use Ardent Blaze", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("ComboE", "Use Relentless Pursuit", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("ComboR", "Use The Culling", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("SmartE", "Smart Relentless Pursuit", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("UltLockOn", "Use Ultimate Lock On (Beta)", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("sep", "----- [ Misc ] -----", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("PursuitSlow", "Pursuit Out of Slows", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("AutoHarass", "Auto Harass", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu:addParam("sep", "----- [ Killsteal ] -----", SCRIPT_PARAM_INFO, "")
	AutoCarry.PluginMenu:addParam("Killsteal", "Killsteal", SCRIPT_PARAM_ONOFF, true)
--	AutoCarry.PluginMenu:addParam("KillstealUlt", "Killsteal with Ult", SCRIPT_PARAM_ONOFF, false)

	LucianExtraConfig = scriptConfig("Sida's Auto Carry: Lucian Extra", "Lucian")
	LucianExtraConfig:addParam("sep", "----- [ Advanced ] -----", SCRIPT_PARAM_INFO, "")
	LucianExtraConfig:addParam("EMinMouseDiff", "Pursuit Min. Mouse Diff.", SCRIPT_PARAM_SLICE, 600, 100, 1000, 0)
	LucianExtraConfig:addParam("ProMode", "Use Auto QWER Keys", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("MaxSpellAngle", "Max Spell Angle", SCRIPT_PARAM_SLICE, 35, 5, 90, 0)
	LucianExtraConfig:addParam("UltClose", "Don't Ult Closer Than", SCRIPT_PARAM_SLICE, 150, 50, 800, 0)
	LucianExtraConfig:addParam("ManaManager", "Mana Manager %", SCRIPT_PARAM_SLICE, 40, 0, 100, 2)
	LucianExtraConfig:addParam("HealthPercentage", "Health Drop %", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	LucianExtraConfig:addParam("HealthTime", "Health Tracking Time", SCRIPT_PARAM_SLICE, 2, 2, 5, 0)
	LucianExtraConfig:addParam("sep", "----- [ Performance ] -----", SCRIPT_PARAM_INFO, "")
--	LucianExtraConfig:addParam("PerformanceRatio", "<-- Performance vs FPS -->", SCRIPT_PARAM_SLICE, 5, 1, 10, 0)
	LucianExtraConfig:addParam("UseGoodAngles", "Use Good Shot Angles", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("UseMultishot", "Use Multishot", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("SmartFarmWithQ", "Smart Farm With Q", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("sep", "----- [ Draw ] -----", SCRIPT_PARAM_INFO, "")
	LucianExtraConfig:addParam("DisableDraw", "Disable Draw", SCRIPT_PARAM_ONOFF, false)
	LucianExtraConfig:addParam("DrawFurthest", "Draw Furthest Spell Available", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("DrawQ", "Draw Piercing Light", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("DrawW", "Draw Ardent Blaze", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("DrawE", "Draw Relentless Pursuit", SCRIPT_PARAM_ONOFF, true)
	LucianExtraConfig:addParam("DrawR", "Draw The Culling", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	tick = GetTickCount()
	Target = AutoCarry.GetAttackTarget(true)

	SpellCheck()

	-- tick % 5 == 0) and 
	if IsTickReady(25) and IsFiringUlt() then
		CheckRPosition()
	else
		if AutoCarry.MainMenu.AutoCarry then
			comboActive = true
			Combo()
		else
			comboActive = false
		end

		if AutoCarry.PluginMenu.FullCombo then
			FullCombo()
		end

		if AutoCarry.MainMenu.MixedMode or AutoCarry.PluginMenu.AutoHarass then
			Harass()
		end

		if AutoCarry.PluginMenu.Killsteal then
			KillSteal()
		end

		if (AutoCarry.MainMenu.LaneClear or AutoCarry.MainMenu.MixedMode) and LucianExtraConfig.SmartFarmWithQ and IsTickReady(70) and not IsMyManaLow()  then
			SmartQFarm()
		end	
	end
end

function PluginOnCreateObj(obj)
	-- Nothing to do here.
	if obj.name == ParticleRFiring then
		if debugMode then PrintChat("Ult Particle Started") end
		isUltFiring = true
		if debugMode then PrintChat("start: "..(tick / 1000)) end
	end
end

function PluginOnDeleteObj(obj)
	if obj.name == ParticleRFiring then
		if debugMode then PrintChat("Ult Particle Stopped") end
		isUltFiring = false
		UltFireStop()
		if debugMode then PrintChat("stop: "..(tick / 1000)) end
	end
end

function OnAttacked()
	-- AA > Q > AA
	ComboWeave(true)
end

--[[
function CustomAttackEnemy(enemy)
		if enemy.dead or not enemy.valid then return end
		-- myHero:Attack(enemy)
		-- AutoCarry.shotFired = true
end
--]]

function OnGainBuff(unit, buff)
	if buff and buff.type ~= nil and unit.name == myHero.name and unit.team == myHero.team and (buff.type == 5 or buff.type == 10 or buff.type == 11) then
		-- BUFF_STUN = 5 BUFF_SLOW = 10 BUFF_ROOT = 11
		if AutoCarry.PluginMenu.PursuitSlow then
			isSlowed = true
			CastE()
		end
	end 
end

function SpellCheck()
	DFGSlot, HXGSlot, BWCSlot, BRKSlot, STDSlot, SheenSlot, TrinitySlot, LichBaneSlot = GetInventorySlotItem(3128),
	GetInventorySlotItem(3146), GetInventorySlotItem(3144), GetInventorySlotItem(3153), GetInventorySlotItem(3131),
	GetInventorySlotItem(3057), GetInventorySlotItem(3078), GetInventorySlotItem(3100)

	QReady = (myHero:CanUseSpell(SkillQ.spellKey) == READY)
	WReady = (myHero:CanUseSpell(SkillW.spellKey) == READY)
	EReady = (myHero:CanUseSpell(SkillE.spellKey) == READY)
	RReady = (myHero:CanUseSpell(SkillR.spellKey) == READY)

	DFGReady = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
	HXGReady = (HXGSlot ~= nil and myHero:CanUseSpell(HXGSlot) == READY)
	BWCReady = (BWCSlot ~= nil and myHero:CanUseSpell(BWCSlot) == READY)
	BRKReady = (BRKSlot ~= nil and myHero:CanUseSpell(BRKSlot) == READY)
	STDReady = (STDSlot ~= nil and myHero:CanUseSpell(BRKSlot) == READY)

	IReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end

-- Handle SBTW Skill Shots

function Combo()
	if not Target then return end
	ComboWeave()
end

function ComboWeave(attacked)
	if (AutoCarry.MainMenu.MixedMode or AutoCarry.PluginMenu.AutoHarass) and IsTickReady(60) then CastQ() end

	if AutoCarry.MainMenu.AutoCarry then
		CastSlots()

		if not attacked and tick > (lastSpell + 3000) then
			if not AutoCarry.PluginMenu.ComboW or (AutoCarry.PluginMenu.ComboW and not CastW()) then
				if AutoCarry.PluginMenu.ComboQ then CastQ() end
			end
		elseif comboActive then -- and tick > nextAttack then
			nextAttack = AutoCarry.GetNextAttackTime()

			if AutoCarry.PluginMenu.ComboW then
				if CastW() then return end
			end

			if AutoCarry.PluginMenu.ComboE then
				if CastE() then return end
			end

			if AutoCarry.PluginMenu.ComboQ then
				if CastQ() then return end
			end

			if AutoCarry.PluginMenu.ComboR and IsTickReady(50) then
				if CastR() then return end
			end

			comboActive = false
		end
	end
end

function FullCombo()
	CastSlots()
	CastW()
	CastE()
	CastQ()
	CastR()
end

function CastSlots()
	if Target ~= nil then
		if GetDistance(Target) <= QRange then
			if DFGReady then CastSpell(DFGSlot, Target) end
			if HXGReady then CastSpell(HXGSlot, Target) end
			if BWCReady then CastSpell(BWCSlot, Target) end
			if BRKReady then CastSpell(BRKSlot, Target) end
			if STDReady then CastSpell(STDSlot, Target) end
		end
	end
end

function Harass()
	if IsTickReady(20) then CastQ() end
end

function IsTickReady(tickFrequency)
	-- Improves FPS
	-- Disabled for now.
--	local frequency = tickFrequency
--	if LucianExtraConfig.PerformanceRatio > 0 then
--		frequency = (LucianExtraConfig.PerformanceRatio + 1) * tickFrequency
--	elseif LucianExtraConfig.PerformanceRatio < 0 then
--		frequency = tickFrequency / (abs(LucianExtraConfig.PerformanceRatio) + 1)
--	end
	
	-- if tick ~= nil and math.fmod(tick, (tickFrequency * LucianExtraConfig.PerformanceRatio)) == 0 then
	if tick ~= nil and math.fmod(tick, tickFrequency) == 0 then
		return true
	else
		return false
	end
end

function UpdateLastSpellTime()
	lastSpell = tick
end

function CastQ(enemy)
	-- Q (Piercing Light)
	if not enemy then enemy = Target end

	if enemy and not enemy.dead and QReady and ValidTarget(enemy, QMaxRange) then
		local distance = GetDistance(enemy)
		local range = QRange
		if distance > QRange and LucianExtraConfig.UseMultishot then
			range = QMaxRange
		end

		local tpQ = VIP_USER and TargetPredictionVIP(range, SkillQ.speed*1000, 0, SkillQ.width) or TargetPrediction(range, SkillQ.speed, 0, SkillQ.width)

		local hitCount, hitEnemy = 0, nil
		local angleDiff = nil
		local predPos = nil

		if enemy.type == myHero.type then
			if LucianExtraConfig.UseGoodAngles or LucianExtraConfig.UseMultishot then
				if tpQ then
					predPos = tpQ:GetPrediction(enemy)
				end
			end

			-- Check angle of prediction.
			if LucianExtraConfig.UseGoodAngles then
				local goodAngle = false
				if predPos then
					angleDiff = GetAngle(enemy, predPos)
					if angleDiff then
						goodAngle = IsGoodAngle(angleDiff, LucianExtraConfig.MaxSpellAngle)
					end
				end
				
				if not angleDiff or not goodAngle then return false end
			end
		

			-- Find multishot possibilities.
			if distance > QRange and LucianExtraConfig.UseMultishot then
				hitCount, hitEnemy = FindQMultishot(enemy, predPos, false)

				if hitEnemy and hitCount > 0 then
					-- We have a winner.
				end
			end
		end

		-- if not angleDiff or (IsGoodAngle(angleDiff, LucianExtraConfig.MaxSpellAngle)) then
		if hitCount > 0 and hitEnemy then
			if debugMode then PrintChat("Q Mode: Multishot") end
			
			if lastText == 0 or (tick > lastText + 2000) then
				lastText = tick
				PrintFloatText(myHero, 20, "Multishot!")
			end

			CastSpell(SkillQ.spellKey, hitEnemy)
			UpdateLastSpellTime()
			return true
		else
			if debugMode then PrintChat("Q Mode: normal") end
			CastSpell(SkillQ.spellKey, enemy)
			UpdateLastSpellTime()
			return true
		end
	end

	return false
end

function SmartQFarm()
	if not QReady then return false end

	local minions = {}
	for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
		if ValidTarget(minion) and GetDistance(minion) <= QRange then
			if minion.health < getDmg("Q", minion, myHero) then 
				table.insert(minions, minion)
			end
		end
	end

	local hitCount, hitEnemy
	for _, minion in pairs(minions) do
		hitCount, hitEnemy = FindQMultishot(minion, minion, true)
		if hitCount >= 2 then
			local count = 0
			for _, enemy in pairs(hitEnemy) do
				if enemy.health < getDmg("Q", enemy, myHero) then
					count = count + 1
				end
			end

			if count >= 2 then
				CastQ(minion)
				break
			end
		end
	end
end

function FindQMultishot(enemy, predPos, multiple)
	local hitCount = 0
	local hitEnemy = nil

	if multiple then
		hitEnemy = {}
	end

	if not QReady or not enemy or enemy.dead or not predPos then return hitCount, hitEnemy end

	local m, minions = GetMinionCollision(SkillQ, QMaxRange, myHero, predPos)

	local h, heroes = false, nil

	if VIP_USER then
		h, heroes = GetHeroCollision(SkillQ, QMaxRange, myHero, predPos)
	end

	if not m and not h then return hitCount, hitEnemy end

	if m then
		for index, minion in pairs(minions) do
			hitCount = hitCount + 1
			if GetDistance(minion) < SkillQ.range and (multiple or GetDistance(minion) > 150) then
				if multiple then
					table.insert(hitEnemy, minion)
				else
					hitEnemy = minion
				end
			end
		end 
	end

	if h then
		for index, hero in pairs(heroes) do
			hitCount = hitCount + 1
			if GetDistance(hero) < SkillQ.range then
				if multiple then
					table.insert(hitEnemy, hero)
				else
					hitEnemy = hero
				end
			end
		end
	end

	return hitCount, hitEnemy
end

function GetHeroCollision(skill, altRange, source, destination)
	if not altRange then altRange = skill.range end

	if VIP_USER then
		local col = Collision(altRange, skill.speed*1000, skill.delay/1000, skill.width)

		if col then
			local ret, heroes = col:GetHeroCollision(source, destination, 2) -- 2 = HERO_ENEMY
			return ret, heroes
		else
			return false, nil
		end
	else
		return false, nil
	end
end

function GetMinionCollision(skill, altRange, source, destination)
	if not altRange then altRange = skill.range end

	if VIP_USER then
		local col = Collision(altRange, skill.speed*1000, skill.delay/1000, skill.width)

		if col then
			local ret, minions = col:GetMinionCollision(source, destination)
			return ret, minions
		else
			return false, nil
		end
	else
		local minion = GetNonVIPMinionCollision(destination, skill.width)
		if minion then
			return true, minion
		else
			return false, nil
		end
	end
end

function GetNonVIPMinionCollision(predic, width)
	local minions = {}
	for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
		if minion ~= nil and minion.valid and string.find(minion.name,"Minion_") == 1 and minion.team ~= player.team and minion.dead == false then
			if predic ~= nil and predic.x ~= nil and predic.z ~= nil then
				ex = player.x
				ez = player.z
				tx = predic.x
				tz = predic.z

				if ex ~= nil and ez ~= nil and tx ~= nil and tz ~= nil then
					dx = ex - tx
					dz = ez - tz
					if dx ~= 0 then
						m = dz/dx
						c = ez - m*ex
					end
					mx = minion.x
					mz = minion.z
					distanc = (math.abs(mz - m*mx - c))/(math.sqrt(m*m+1))
					if distanc < width and math.sqrt((tx - ex)*(tx - ex) + (tz - ez)*(tz - ez)) > math.sqrt((tx - mx)*(tx - mx) + (tz - mz)*(tz - mz)) then
						table.insert(minions, minion)
					end
				end
			end
		end
	end

	return minions
end

function CastW(enemy)
	-- W (Ardent Blaze)
	if not enemy then enemy = Target end

	if enemy and not enemy.dead and WReady and ValidTarget(enemy, WRange) then
		if debugMode then PrintChat("Cast W") end
		AutoCarry.CastSkillshot(SkillW, enemy)
		UpdateLastSpellTime()
		return true
	end

	return false
end

--[[
function CastEOld()
	-- E (Relentless Pursuit)
	if debugMode then
		-- PrintChat("Mouse Distance: "..GetDistance(mousePos))
	end

	if EReady then
		-- if ( math.abs(mousePos.x - myHero.x) > PursuitMinMouseDiff or math.abs(mousePos.z - myHero.z) > PursuitMinMouseDiff) then
		if ((GetDistance(mousePos) > PursuitMinMouseDiff) and isEnemyInRange(SkillE.range + SkillR.range)) then
			if debugMode then PrintChat("Cast E") end
			CastSpell(SkillE.spellKey, mousePos.x, mousePos.z)
		end
	end
end
--]]

function CastE()
	if EReady then
		if AutoCarry.PluginMenu.SmartE then
			if ((GetDistance(mousePos) > LucianExtraConfig.EMinMouseDiff or isSlowed) and isEnemyInRange(SkillE.range + SkillR.range)) then
				local dashSqr = math.sqrt((mousePos.x - myHero.x)^2+(mousePos.z - myHero.z)^2)
				local dashX = myHero.x + ERange*((mousePos.x - myHero.x)/dashSqr)
				local dashZ = myHero.z + ERange*((mousePos.z - myHero.z)/dashSqr)
				CastSpell(SkillE.spellKey, dashX, dashZ)
				UpdateLastSpellTime()
				isSlowed = false
				return true
			end
		else
			CastSpell(SkillE.spellKey, mousePos.x, mousePos.z)
			UpdateLastSpellTime()
			isSlowed = false
			return true
		end
	end

	return false
end

function CastR(enemy)
	if not enemy then enemy = Target end

	-- R (The Culling)
	if enemy and not enemy.dead and RReady and ValidTarget(enemy, RRange) and enemy.type == myHero.type then
		if GetDistance(enemy) < LucianExtraConfig.UltClose then return false end

		if not IsFiringUlt() then
			if debugMode then PrintChat("Cast R") end
			if not isUltFiring then
				AutoCarry.CastSkillshot(SkillR, enemy)
				UpdateLastSpellTime()
				if AutoCarry.PluginMenu.UltLockOn and tick > (lastUltMessage + 2000) then
					lastUltMessage = tick
					PrintFloatText(myHero, 10, "Ultimate Locked On!")
				end
			end

			ultCastTarget = enemy
			ultCastTick = tick

			-- Vector from target -> myHero
			if ultVectorX == nil and ultVectorZ == nil then
				if debugMode and false then PrintChat("update x,z") end
				ultVectorX,y,ultVectorZ = (Vector(myHero) - Vector(ultCastTarget)):normalized():unpack()
			end
		end

		CheckRPosition()
	end
end

function CheckRPosition()
	if (ultCastTick > 0) then
		if debugMode and IsFiringUlt() then burp = "true" else burp = "false" end
		if debugMode and false then PrintChat("Tick: "..tick..", ultCastTick: "..ultCastTick..", RDuration: "..(ultCastTick + (RDuration * 1000))..", IsFiringUlt: "..burp) end
	end

	if AutoCarry.PluginMenu.UltLockOn and IsFiringUlt() then
		MoveMyHeroToRPosition()
	end
end

function MoveMyHeroToRPosition()
	-- Please don't steal this function!
	local tpR = VIP_USER and TargetPredictionVIP(SkillR.range, SkillR.speed*1000, RRefresh, SkillR.width) or TargetPrediction(SkillR.range, SkillR.speed, RRefresh*1000, SkillR.width)

	local target = nil
	if ultCastTarget ~= nil then
		target = ultCastTarget
	else
		target = Target
	end

	local predR = tpR:GetPrediction(target)

	if not predR then return end

	local RRangeBuffered = RRange * .98 -- Allow a bit of slippage for targets running away.
	local posX = predR.x + (ultVectorX * RRangeBuffered)
	local posZ = predR.z + (ultVectorZ * RRangeBuffered)

	-- Thank you, Pythagoras
	-- local distanceBetweenPoints = math.sqrt((predR.x - posX)^2 + (predR.z - posZ)^2)
	-- local distanceBetweenPoints = GetDistance(Point(posX, posZ), predR)
	-- local posXRanged = (posX + (posX - predR.x)) / distanceBetweenPoints * RRangeBuffered
	-- local posZRanged = (posZ + (posZ - predR.z)) / distanceBetweenPoints * RRangeBuffered

	local predRPath = LineSegment(Point(predR.x, predR.z), Point(posX, posZ))

	local closePoint = nil
	if predRPath ~= nil then
		closePoint = Point(myHero.x, myHero.z):closestPoint(predRPath)
	else
		if debugMode then PrintChat("predRPath is nil") end
	end

	if debugMode and closePoint ~= nil then
		--	PrintChat("moveto: "..posX..", "..posZ.."... targetat: "..ultCastTarget.x..", "..ultCastTarget.z..", ultVectorX: "..ultVectorX..", ultVectorZ: "..ultVectorZ..", RDuration: "..RDuration)
		--	PrintChat("posXRanged: "..posXRanged..", posZRanged: "..posZRanged..", closePoint: "..closePoint.x..", "..closePoint.y)
		PrintChat("moveto: "..closePoint.x..", "..closePoint.y.."; targetat: "..predR.x..", "..predR.z..", ultVectorX: "..ultVectorX..", ultVectorZ: "..ultVectorZ)
	end

	if debugMode then
		PrintChat("distance: method 1: "..GetDistance(closePoint, predR)..", method 2: "..GetDistance(Point(posX, posZ), predR))
	end

	if predRPath ~= nil and closePoint ~= nil and not IsWall(D3DXVECTOR3(closePoint.x, myHero.y, closePoint.y)) and GetDistance(closePoint, predR) > ERange then
		-- Closest Point Method
		if debugMode then PrintChat("Move: Method 1") end
		myHero:MoveTo(closePoint.x, closePoint.y)
	elseif predR ~= nil and posX ~= nil and posZ ~= nil and not IsWall(D3DXVECTOR3(posX, myHero.y, posZ))
		-- and GetDistance(Point(posX, posZ), predR) > 500
		and GetDistance(Point(posX, posZ), predR) < RRange and GetDistance(Point(posX, posZ), predR) > 100 then
		-- Full Vector Method
		if debugMode then PrintChat("Move: Method 2") end
		if (tick > (lastUltMessage + 2000)) then
			-- lastUltMessage = tick
			-- PrintFloatText(myHero, 10, "Ultimate Manual Mode!")
		end
		myHero:MoveTo(posX, posZ)
--	elseif not IsWall(D3DXVECTOR3(posXRanged, myHero.y, posZRanged)) then
--		-- Last Ditch Method
--		if debugMode then PrintChat("Move: Method 3") end
--		myHero:MoveTo(posXRanged, posZRanged)
	else
		-- Fallback to User Aiming
		if debugMode then PrintChat("Move: Wall") end
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
	-- myHero:MoveTo(posXRanged, posZRanged)
end

function getDistanceBetweenPoints(pointA, pointB)
	-- Thank you, Pythagoras
	local distanceBetweenPoints = math.sqrt((predR.x - posX)^2 + (predR.z - posZ)^2)
end

function IsFiringUlt()
	local tickCount = tick

	-- if (ultCastTick > 0) and (tickCount >= ultCastTick) and (tickCount <= (ultCastTick + (RDuration * 1000))) and not RReady and ultCastTarget ~= nil and not ultCastTarget.dead then
	if (ultCastTick > 0) and (tickCount >= ultCastTick) and isUltFiring and ultCastTarget ~= nil and not ultCastTarget.dead then
		AutoCarry.CanMove = false
		return true
	else
		-- UltFireStop()
		return false
	end
end

function UltFireStop()
	ultCastTick = 0
	ultVectorX = nil
	ultVectorZ = nil
	AutoCarry.CanMove = true
end

function isEnemyInRange(range)
	for _, enemy in pairs(AutoCarry.EnemyTable) do
		if ValidTarget(enemy, range) and not enemy.dead then
			return true
		end
	end

	return false
end

--[[
function TakingRapidDamage()
	if (tick - healthLastTick) > (LucianExtraConfig.HealthTime * 1000) then
		-- Check amount of health lost
		-- PrintChat((myHero.health - healthLastHealth)..", "..(myHero.maxHealth * (LucianExtraConfig.HealthPercentage / 100))..", "..((tick - healthLastTick) / 1000))
		if healthLastTick ~= 0 and (myHero.health - healthLastHealth) > (myHero.maxHealth * (LucianExtraConfig.HealthPercentage / 100)) then
			-- PrintChat("true")
			return true
		else
			-- Reset counters
			healthLastTick = tick
			healthLastHealth = myHero.health
		end
	end

	return false
end
--]]

function KillSteal()
	-- Will try to perform a killsteam using any spell.
	if not AutoCarry.PluginMenu.Killsteal then return end

	-- Killsteal disabled until Bol update for Lucian

	for _, enemy in pairs(AutoCarry.EnemyTable) do
		if enemy and not enemy.dead then
			-- getDmg broken in BoL for Lucian right now.
			local qDmg = GetDamage(enemy, _Q) -- getDmg("Q", enemy, myHero)
			local wDmg = GetDamage(enemy, _W) -- getDmg("W", enemy, myHero)
			-- local rDmg = 50 -- getDmg("R", enemy, myHero)

			if QReady and ValidTarget(enemy, QRange) and enemy.health < qDmg then
				if debugMode then PrintChat("Cast Q KS") end
				CastQ(enemy)
			elseif WReady and ValidTarget(enemy, WRange) and enemy.health < wDmg then
				if debugMode then PrintChat("Cast W KS") end
				CastW(enemy)
			elseif QReady and WReady and ValidTarget(enemy, QRange) and ValidTarget(enemy, WRange) and enemy.health < (qDmg + wDmg) then
				if debugMode then PrintChat("Cast Q + W KS") end
				CastW(enemy)
				if not enemy.dead then
					CastQ(enemy)
				end
			-- Ultimate is not a viable killsteal since the number of individual shots to hit can not be pre-determined.
			-- elseif AutoCarry.PluginMenu.KillstealUlt and RReady and ValidTarget(enemy, RRange) and (enemy.health + 20) < rDmg then
			-- 	if debugMode then PrintChat("Cast R KS") end
			--	CastR(enemy)
			end

		end
	end
end

function GetDamage(enemy, spell)
	if spell == _Q then
		return myHero:CalcDamage(enemy, ((40*(myHero:GetSpellData(_Q).level-1) + 80) + (((.15 * (myHero:GetSpellData(_Q).level-1)) + .60) * myHero.addDamage)))
	elseif spell == _W then
		return myHero:CalcMagicDamage(enemy, ((40*(myHero:GetSpellData(_Q).level-1) + 60) + (.90 * myHero.ap) + (.60 * myHero.addDamage)))
	end
end

function PluginOnWndMsg(msg,key)
	Target = AutoCarry.GetAttackTarget()
	if Target ~= nil and LucianExtraConfig.ProMode then
		-- if msg == KEY_DOWN and key == KeyQ then CastQ() end
		if msg == KEY_DOWN and key == KeyW then CastW() end
		if msg == KEY_DOWN and key == KeyE then CastE() end
		if msg == KEY_DOWN and key == KeyR then CastR() end
		if msg == KEY_DOWN and key == KeyTest and debugMode then
			if ultVectorX == nil and ultVectorZ == nil then
				ultCastTarget = Target
				ultVectorX,y,ultVectorZ = (Vector(myHero) - Vector(ultCastTarget)):normalized():unpack()
			end
			MoveMyHeroToRPosition()
		end
		
		if msg == KEY_UP and key == KeyTest and debugMode then
			ultVectorX = nil
			ultVectorZ = nil
		end
	end
end

-- Draw
function PluginOnDraw()
	-- if Target ~= nil and not Target.dead and QReady and ValidTarget(Target, QMaxRange) then
	if Target ~= nil and not Target.dead and (AutoCarry.MainMenu.AutoCarry or AutoCarry.MainMenu.MixedMode) then
		DrawArrowsToPos(myHero, Target)
	end

	if not LucianExtraConfig.DisableDraw and not myHero.dead then
		local farSpell = FindFurthestReadySpell()
		-- if debugMode and farSpell then PrintChat("far: "..farSpell.configName) end

		-- Not needed as SAC has the same range draw.
		-- DrawCircle(myHero.x, myHero.y, myHero.z, getTrueRange(), 0x808080) -- Gray

		if LucianExtraConfig.DrawQ and QReady and ((LucianExtraConfig.DrawFurthest and farSpell and farSpell == SkillQ) or not LucianExtraConfig.DrawFurthest) then
			DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x0099CC) -- Blue
		end

		if LucianExtraConfig.DrawW and WReady and ((LucianExtraConfig.DrawFurthest and farSpell and farSpell == SkillW) or not LucianExtraConfig.DrawFurthest) then
			DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xFFFF00) -- Yellow
		end
		
		if LucianExtraConfig.DrawE and EReady and ((LucianExtraConfig.DrawFurthest and farSpell and farSpell == SkillE) or not LucianExtraConfig.DrawFurthest) then
			DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x00FF00) -- Green
		end

		if LucianExtraConfig.DrawR and RReady and ((LucianExtraConfig.DrawFurthest and farSpell and farSpell == SkillR) or not LucianExtraConfig.DrawFurthest) then
			DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFF0000) -- Red
		end

		Target = AutoCarry.GetAttackTarget()
		if Target ~= nil then
			for j=0, 10 do
				DrawCircle(Target.x, Target.y, Target.z, 40 + j*1.5, 0x00FF00) -- Green
			end
		end
	end
end

function FindFurthestReadySpell()
	local farSpell = nil

	if LucianExtraConfig.DrawQ and QReady then farSpell = SkillQ end
	if LucianExtraConfig.DrawW and WReady and (not farSpell or WRange > farSpell.range) then farSpell = SkillW end
	if LucianExtraConfig.DrawE and EReady and (not farSpell or ERange > farSpell.range) then farSpell = SkillE end
	if LucianExtraConfig.DrawR and RReady and (not farSpell or RRange > farSpell.range) then farSpell = SkillR end

	return farSpell
end

function getTrueRange()
    return myHero.range + GetDistance(myHero.minBBox)
end

function DrawArrowsToPos(pos1, pos2)
	if pos1 and pos2 then
		startVector = D3DXVECTOR3(pos1.x, pos1.y, pos1.z)
		endVector = D3DXVECTOR3(pos2.x, pos2.y, pos2.z)
		-- directionVector = (endVector-startVector):normalized()
		DrawArrows(startVector, endVector, 60, 0xE97FA5, 100)
	end
end

--[[
function test1(skill, enemy)
	local tp = VIP_USER and TargetPredictionVIP(8000, skill.speed*1000, 0, SkillR.width) or TargetPrediction(skill.range, skill.speed, 0, skill.width)
	-- local tp = TargetPredictionVIP(8000, math.huge, skill.delay, SkillR.width)
	--local tp = TargetPredictionVIP(8000, math.huge, 0.535, 75)
	GetEnemyPrediction(enemy, tp)
end
--]]

function GetEnemyPrediction(enemy, tp)
	-- local tpQ = VIP_USER and TargetPredictionVIP(SkillQ.range, SkillQ.speed*1000, SkillQ.delay, SkillR.width) or TargetPrediction(SkillQ.range, SkillQ.speed, SkillQ.delay*1000, SkillQ.width)

	if not enemy or enemy.dead or not tp or not QReady then return nil end

	-- local predPos, p2, p3 = tp:GetPrediction(enemy)
	local predPos = tp:GetPrediction(enemy)
	
	if not predPos then return nil end

	GetAngle(enemy, predPos)
end

-- Angle Functions
function IsGoodAngle(angleDiff, variance)
    local direction = Directionality(angleDiff, variance)
    
    if direction == angle_towards or direction == angle_away then
        return true
    else
        return false
    end
end

function GetAngle(enemy, predPos)
	-- ultVectorX,y,ultVectorZ = (Vector(myHero) - Vector(ultCastTarget)):normalized():unpack()

		-- v1 = Vector(predPos.x - myHero.x, predPos.z - myHero.z):normalized()
	-- v2 = Vector((Vector(predPos) - Vector(enemy)):normalized())
		-- v2 = Vector(predPos.x - enemy.x, predPos.z - enemy.z):normalized()
	-- v2 = Vector(coneTargetsTable[j].x-player.x , coneTargetsTable[j].z-player.z)

	v1 = (Vector(predPos) - Vector(myHero)):normalized()

	if predPos.x == enemy.x and predPos.z == enemy.z then
		-- Enemy is standing still.
		return false
	end
	

	v2 = (Vector(predPos) - Vector(enemy)):normalized()
-- PrintChat("a"..predPos.x.."!"..enemy.x.."!"..v2.x.."!"..v2.z)
--	if not v2 or v2 == -1 then
--		return false
--	end
	-- shootTheta = sign(v1.z)*90-math.deg(math.atan2(v1.z, v1.x))
	-- enemyTheta = sign(v2.z)*90-math.deg(math.atan2(v2.z, v2.x))
	-- angle = enemyTheta-shootTheta

	shootTheta = math.deg(math.atan2(v1.z, v1.x))
	enemyTheta = math.deg(math.atan2(v2.z, v2.x))

	if shootTheta < 0 then
		shootTheta = shootTheta + 360  
	end

	if enemyTheta < 0 then
		enemyTheta = enemyTheta + 360
	end

	angleDiff = math.abs(enemyTheta - shootTheta)

	local angleView = ""
	local angleVariance = 30

	angleView = Directionality(angleDiff, LucianExtraConfig.MaxSpellAngle)
	
	if angleView ~= nil then
		-- PrintChat("v1: "..shootTheta..", v2: "..enemyTheta..", angle: "..angle..", angleView: "..angleView..", predx: "..predPos.x..", predz: "..predPos.z..", hittime: "..p2..", posx: "..p3.x..", posz: "..p3.z)
		-- PrintChat("v1: "..shootTheta..", v2: "..enemyTheta..", angleDiff: "..angleDiff..", angleView: "..angleView..", predx: "..predPos.x..", predz: "..predPos.z)
	end

	return angleDiff
end

function Directionality(angleDiff, variance)
    if betweenRounded(angleDiff, variance, angle_away) then
        return angle_away
    elseif betweenRounded(angleDiff, variance, angle_towards) then
        return angle_towards
    elseif betweenRounded(angleDiff, variance, angle_parallel_towards) then
        return angle_parallel_towards
    elseif betweenRounded(angleDiff, variance, angle_parallel_away) then
        return angle_parallel_away
    else
        return angle_unknown
    end
end

function betweenRounded(angleDiff, variance, angle) -- diff = known angle between two people, variance is allowed slippage, angle = goal you want if true
    low = angle - variance
    high = angle + variance

    if low <= 0 then
        return (low + 360 <= angleDiff or angleDiff <= high)
    else
        return (low <= angleDiff and angleDiff <= high)
    end
end

function sign(x)
    if x > 0 then return 1
    elseif x < 0 then return -1
    end
end

function IsMyManaLow()
	if myHero.mana < (myHero.maxMana * ( LucianExtraConfig.ManaManager / 100)) then
		return true
	else
		return false
	end
end

--[[
class 'ColorARGB' -- {

    function ColorARGB:__init(red, green, blue, alpha)
        self.R = red or 255
        self.G = green or 255
        self.B = blue or 255
        self.A = alpha or 255
    end

    function ColorARGB.FromArgb(red, green, blue, alpha)
        return Color(red,green,blue, alpha)
    end

    function ColorARGB:ToARGB()
        return ARGB(self.A, self.R, self.G, self.B)
    end

    ColorARGB.Red = ColorARGB(255, 0, 0, 255)
    ColorARGB.Yellow = ColorARGB(255, 255, 0, 255)
    ColorARGB.Green = ColorARGB(0, 255, 0, 255)
    ColorARGB.Aqua = ColorARGB(0, 255, 255, 255)
    ColorARGB.Blue = ColorARGB(0, 0, 255, 255)
    ColorARGB.Fuchsia = ColorARGB(255, 0, 255, 255)
    ColorARGB.Black = ColorARGB(0, 0, 0, 255)
    ColorARGB.White = ColorARGB(255, 255, 255, 255)
-- }

--Notification class
class 'Message' -- {

    Message.instance = ""

    function Message:__init()
        self.notifys = {} 

        AddDrawCallback(function(obj) self:OnDraw() end)
    end

    function Message.Instance()
        if Message.instance == "" then Message.instance = Message() end return Message.instance 
    end

    function Message.AddMessage(text, color, target)
        return Message.Instance():PAddMessage(text, color, target)
    end

    function Message:PAddMessage(text, color, target)
        local x = 0
        local y = 200 
        local tempName = "Screen" 
        local tempcolor = color or ColorARGB.Red

        if target then  
            tempName = target.networkID
        end

        self.notifys[tempName] = { text = text, color = tempcolor, duration = GetGameTimer() + 2, object = target}
    end

    function Message:OnDraw()
        for i, notify in pairs(self.notifys) do
            if notify.duration < GetGameTimer() then notify = nil 
            else
                notify.color.A = math.floor((255/2)*(notify.duration - GetGameTimer()))

                if i == "Screen" then  
                    local x = 0
                    local y = 200
                    local gameSettings = GetGameSettings()
                    if gameSettings and gameSettings.General then 
                        if gameSettings.General.Width then x = gameSettings.General.Width/2 end 
                        if gameSettings.General.Height then y = gameSettings.General.Height/4 - 100 end
                    end  
                    --PrintChat(tostring(notify.color))
                    local p = GetTextArea(notify.text, 40).x 
                    self:DrawTextWithBorder(notify.text, 40, x - p/2, y, notify.color:ToARGB(), ARGB(notify.color.A, 0, 0, 0))
                else    
                    local pos = WorldToScreen(D3DXVECTOR3(notify.object.x, notify.object.y, notify.object.z))
                    local x = pos.x
                    local y = pos.y - 25
					local p = GetTextArea(notify.text, 40).x 

					self:DrawTextWithBorder(notify.text, 30, x- p/2, y, notify.color:ToARGB(), ARGB(notify.color.A, 0, 0, 0))
                end
            end
        end
    end 

    function Message:DrawTextWithBorder(textToDraw, textSize, x, y, textColor, backgroundColor)
        DrawText(textToDraw, textSize, x + 1, y, backgroundColor)
        DrawText(textToDraw, textSize, x - 1, y, backgroundColor)
        DrawText(textToDraw, textSize, x, y - 1, backgroundColor)
        DrawText(textToDraw, textSize, x, y + 1, backgroundColor)
        DrawText(textToDraw, textSize, x , y, textColor)
    end
-- }
--]]