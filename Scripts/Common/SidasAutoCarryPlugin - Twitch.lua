--[[
 
        Auto Carry Plugin - Twitch Edition
		Author: Kain
		Copyright 2013

		Dependency: Sida's Auto Carry
 
		How to install:
			Make sure you already have AutoCarry installed.
			Name the script EXACTLY "SidasAutoCarryPlugin - Twitch.lua" without the quotes.
			Place the plugin in BoL/Scripts/Common folder.

		Download: https://bitbucket.org/KainBoL/bol/raw/master/Common/SidasAutoCarryPlugin%20-%20Twitch.lua

		Version History:
			Version: 1.0j
				Added extra option to Venom Cask in Menu.
			Version: 1.0h
				Won't try to cast spells while in ambush invisibility.
				Venom Cask will only fire while in auto carry or mixed mode.
				Ultimate will only fire while in auto carry mode.
				Added checks for missing or old collision lib.
				Added "BoL Studio Script Updater" url and hash.
			Version: 1.0e: http://pastebin.com/rnB5tVTF
				Combo
				Spray and Pray Multi-shot 
				AoE MEC Venom Cask
				Expunge Runner
				Expunge at Max Damage
				Expunge Killsteal
--]]

if myHero.charName ~= "Twitch" then return end

-- Check to see if user failed to read the forum...
if VIP_USER then
	if FileExist(SCRIPT_PATH..'Common/Collision.lua') then
		require "Collision"

		if type(Collision) ~= "userdata" then
			PrintChat("Your version of Collision.lua is incorrect. Please install v1.1.1 or later in Common folder.")
			return
		else
			assert(type(Collision.GetHeroCollision) == "function")
		end
	else
		PrintChat("Please install Collision.lua v1.1.1 or later in Common folder.")
		return
	end

	if FileExist(SCRIPT_PATH..'Common/2DGeometry.lua') then
		PrintChat("Please delete 2DGeometry.lua from your Common folder.")
	end
end

local version = "1.0j"

AutoCarry.PluginMenu:addParam("sep", "----- Twitch by Kain: v"..version.." -----", SCRIPT_PARAM_INFO, "")
AutoCarry.PluginMenu:addParam("sep", "----- [ Expunge ] -----", SCRIPT_PARAM_INFO, "")
AutoCarry.PluginMenu:addParam("UseE", "Auto Expunge", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("ExpungeAt6", "Expunge at 6 Stacks", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("ExpungeMaxDamage", "Expunge at Max Damage", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("ExpungeRunner", "Expunge Runner", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("KillSteal", "Expunge for Kills", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("sep", "----- [ Misc ] -----", SCRIPT_PARAM_INFO, "")
AutoCarry.PluginMenu:addParam("UseW", "Auto Venom Cask", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("UseWOnlyLowOrMulti", "Cask only Low HP or Multi-Targets", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("UseWMEC", "Auto MEC for Venom Cask", SCRIPT_PARAM_ONOFF, true)
if VIP_USER then
	AutoCarry.PluginMenu:addParam("AutoUlt", "Auto Ultimate in good situations", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("MinUltEnemies", "Min. R Enemies",SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
end
AutoCarry.PluginMenu:addParam("sep", "----- [ Draw ] -----", SCRIPT_PARAM_INFO, "")
AutoCarry.PluginMenu:addParam("Draw", "Draw Poison Circles", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("DisableDraw", "Disable Draw", SCRIPT_PARAM_ONOFF, false)
AutoCarry.PluginMenu:addParam("DrawFurthest", "Draw Furthest Spell Available", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("DrawW", "Draw Venom Cask", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("DrawE", "Draw Expunge", SCRIPT_PARAM_ONOFF, true)
AutoCarry.PluginMenu:addParam("DrawR", "Draw Spray and Pray", SCRIPT_PARAM_ONOFF, true)

local WRange, WSpeed, WDelay, WWidth = 950, 1.4, 250, 275
local WRadius = WWidth / 2
local ERange = 1200
local RRange, RSpeed, RDelay, RWidth = 850, 1.0, 200, 250

local SkillW = { spellKey = _W, range = WRange, speed = WSpeed, delay = WDelay, width = WWidth, configName = "venomCask", displayName = "W (Venom Cask)", enabled = false, skillShot = true, minions = false, reset = false, reqTarget = true }
local SkillR = { spellKey = _R, range = RRange, speed = RSpeed, delay = RDelay, width = RWidth, configName = "sprayandpray", displayName = "R (Spray and Pray)", enabled = true, skillShot = false, minions = false, reset = false, reqTarget = true }

local QReady, WReady, EReady, RReady = false, false, false, false

local buffAmbush = "HideInShadows"
local isVisible = true

local Target = nil

-- Direction
local enemyLastDistance = {}
local direction_towards = 1
local direction_away = 2

local debugMode = false

function PluginOnLoad()
	for _, enemy in pairs(AutoCarry.EnemyTable) do
		enemy.PoisonStacks = 0
		enemy.LastPoison = 0
		enemyLastDistance[enemy.networkID] = 0
	end
end

function SpellCheck()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
end

function PluginOnTick()
	-- Disable SAC Reborn's auto W. AoE MEC W is much better!
	if AutoCarry.Skills then
		AutoCarry.Skills:GetSkill(_W).Enabled = false
	end

	Target = AutoCarry.GetAttackTarget(true)

	SpellCheck()

	-- Do not cast spells while invisible due to ambush, except when user is holding Auto Carry Combo key.
	if IsVisible() or AutoCarry.MainMenu.AutoCarry then
		if AutoCarry.PluginMenu.UseW and (AutoCarry.MainMenu.AutoCarry or AutoCarry.MainMenu.MixedMode) then
			VenomCask()
		end

		if AutoCarry.PluginMenu.UseE then
			Expunge()
		end

		if VIP_USER and AutoCarry.PluginMenu.AutoUlt and AutoCarry.MainMenu.AutoCarry then
			CastR()
		end
	end
end

function OnGainBuff(unit, buff)
	if buff and buff.type ~= nil and unit.name == myHero.name and unit.team == myHero.team and buff.name:lower() == buffAmbush:lower() then
		isVisible = false
	end 
end

function OnLoseBuff(unit, buff)
	if buff and buff.type ~= nil and unit.name == myHero.name and unit.team == myHero.team and buff.name:lower() == buffAmbush:lower() then
		isVisible = true
	end 
end

function IsVisible()
	return isVisible
end

function VenomCask()
	if not WReady or not Target or Target.dead then return false end
	-- for _, enemy in pairs(AutoCarry.EnemyTable) do
	-- 	if enemy and not enemy.dead and ValidTarget(enemy, WRange) then
	-- 		enemyCount = enemyCount + 1
	-- 	end
	-- end

	if AutoCarry.PluginMenu.UseWMEC and EnemyCount(myHero, WRange) >= 2 then
		local spellPos = GetAoESpellPosition(WRadius, Target, WDelay)
		if spellPos and GetDistance(spellPos) <= WRange then
			if EnemyCount(spellPos, WRadius) >= 2 then
				if debugMode then PrintChat("venomcask mec") end
				CastSpell(SkillW.spellKey, spellPos.x, spellPos.z)
				return true
			end
		end
	elseif (not AutoCarry.PluginMenu.UseWOnlyLowOrMulti or IsEnemyHealthLow(Target)) and GetDistance(Target) <= WRange then
		if debugMode then PrintChat("venomcask normal") end
		AutoCarry.CastSkillshot(SkillW, Target)
		return true
	end

	return false
end

function Expunge()
	local expungeTarget = nil
	local maxPoisonStacks = 0
	local enemyCount = 0

	for _, enemy in pairs(AutoCarry.EnemyTable) do
		if enemy and enemy.PoisonStacks and enemy.PoisonStacks > 0 and ValidTarget(enemy, ERange) then
			enemyCount = enemyCount + 1
			if enemy.PoisonStacks > maxPoisonStacks then
				expungeTarget = enemy.charName
				maxPoisonStacks = enemy.PoisonStacks
			end
		end
	end

	for _, enemy in pairs(AutoCarry.EnemyTable) do
		if not enemy.PoisonStacks or (enemy.PoisonStacks > 0 and GetTickCount() > enemy.LastPoison + 6500) then
			enemy.PoisonStacks = 0
		elseif enemy.PoisonStacks > 0 and ValidTarget(enemy, ERange) then
			local isMaxDamage, trueDamage = GetExpungeDamage(enemy)
			local enemyDirection = EnemyDirection(enemy)

			if (AutoCarry.PluginMenu.ExpungeAt6 and enemy.PoisonStacks == 6)
				or (AutoCarry.PluginMenu.KillSteal and enemy.health < trueDamage)
				or (AutoCarry.PluginMenu.ExpungeMaxDamage and isMaxDamage)
				or (AutoCarry.PluginMenu.ExpungeRunner and enemyDirection and enemyDirection == direction_away and enemyCount <= 3
					and maxPoisonStacks >= 3 and enemy.charName == expungeTarget and GetDistance(enemy) > WRange) then
				CastSpell(_E)
				break
			end
		end
	end
end

function EnemyCount(point, range)
	local count = 0

	for _, enemy in pairs(AutoCarry.EnemyTable) do
		if enemy and not enemy.dead and GetDistance(point, enemy) <= range then
			count = count + 1
		end
	end            

	return count
end

-- Enemy Direction

function GetEnemyLastDistance(enemy)
	if enemy and not enemy.dead then
		return enemyLastDistance[enemy.networkID]
	end

	return false
end

function UpdateEnemyDistance(enemy)
	if enemy and not enemy.dead then
		enemyLastDistance[enemy.networkID] = GetDistance(enemy)
	end
end

function EnemyDirection(enemy)
	if enemy and not enemy.dead then
		local lastDistance = GetEnemyLastDistance(enemy)
		local currentDistance = GetDistance(enemy)

		if currentDistance then
			UpdateEnemyDistance(enemy)
		end

		if currentDistance < lastDistance then
			return direction_towards
		elseif currentDistance > lastDistance then
			return direction_away
		end
	end

	return false
end

function PluginOnCreateObj(obj)
	if obj and obj.valid and obj.name:lower():find("twitch_poison_counter") then
		for _, enemy in pairs(AutoCarry.EnemyTable) do
			if GetDistance(enemy, obj) <= 80 then
				enemy.PoisonStacks = GetStacks(obj.name)
				enemy.LastPoison = GetTickCount()
			end
		end
	end
end

-- Draw

function PluginOnDraw()
	if AutoCarry.PluginMenu.Draw then
		for i, enemy in pairs(AutoCarry.EnemyTable) do
			if ValidTarget(enemy, ERange) then
				if enemy.PoisonStacks > 0 then DrawCircle(enemy.x, enemy.y, enemy.z, (60+(20 * enemy.PoisonStacks)), 0xFFFFFF) end
			end
		end
	end

	if not AutoCarry.PluginMenu.DisableDraw and not myHero.dead then
		local farSpell = FindFurthestReadySpell()

		if AutoCarry.PluginMenu.DrawW and WReady and ((AutoCarry.PluginMenu.DrawFurthest and farSpell and farSpell == WRange) or not AutoCarry.PluginMenu.DrawFurthest) then
			DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0xFFFF00) -- Yellow
		end
		
		if AutoCarry.PluginMenu.DrawE and EReady and ((AutoCarry.PluginMenu.DrawFurthest and farSpell and farSpell == ERange) or not AutoCarry.PluginMenu.DrawFurthest) then
			DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x00FF00) -- Green
		end

		if AutoCarry.PluginMenu.DrawR and RReady and ((AutoCarry.PluginMenu.DrawFurthest and farSpell and farSpell == RRange) or not AutoCarry.PluginMenu.DrawFurthest) then
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

	if AutoCarry.PluginMenu.DrawW and WReady then farSpell = WRange end
	if AutoCarry.PluginMenu.DrawE and EReady and (not farSpell or ERange > farSpell) then farSpell = ERange end
	if AutoCarry.PluginMenu.DrawR and RReady and (not farSpell or RRange > farSpell) then farSpell = RRange end

	return farSpell
end

function GetExpungeDamage(enemy)
    local baseDamage = GetSpellData(_E).level > 0 and (GetSpellData(_E).level * 15) + 5 or 0
    local stackDamage = enemy.PoisonStacks > 0 and (enemy.PoisonStacks * 5) + 10 + (myHero.ap * (0.2 * enemy.PoisonStacks)) + (myHero.addDamage * (0.25 * enemy.PoisonStacks)) or 0
    local totalDamage = baseDamage+stackDamage
	local maxDamage = GetExpungeMaxDamage()

	local isMaxDamage = false

	if totalDamage > maxDamage then
		totalDamage = maxDamage
		isMaxDamage = true
	end

	local trueDamage = totalDamage * (100 / (100 + enemy.armor))

    return isMaxDamage, trueDamage
end

function GetExpungeMaxDamage()
	return 65 + (GetSpellData(_E).level * 45) + (myHero.ap * 0.2) + (myHero.addDamage * 0.25)
end

function GetStacks(str)
	-- Format: twitch_poison_counter_0[1-6].troy
	for i = 1, 6 do
		if str:lower():find("twitch_poison_counter_0"..i..".troy") then return i end
	end

	return 0
end

function CastR(enemy)
	if not enemy then enemy = Target end

	if not AutoCarry.PluginMenu.AutoUlt or not VIP_USER or not enemy or enemy.dead or not RReady or enemy.type ~= myHero.type or not ValidTarget(enemy, RRange) then return false end

	local distance = GetDistance(enemy)

	local enemyCount = 0
	
	for _, enemy in pairs(AutoCarry.EnemyTable) do
		if ValidTarget(enemy, RRange) then
			enemyCount = enemyCount + 1
		end
	end

	if enemyCount < 2 then return false end

	local tpR = VIP_USER and TargetPredictionVIP(range, SkillR.speed*1000, 0, SkillR.width) or TargetPrediction(range, SkillR.speed, 0, SkillR.width)

	local hitCount, hitEnemy = 0, nil
	local predPos = nil

	if tpR then
		predPos = tpR:GetPrediction(enemy)
	end

	-- Find multishot possibilities.
	hitCount, hitEnemy = FindRMultishot(enemy, predPos)

	local lowHealthHitCount = 0
	if hitEnemy and hitCount > 0 then
		for _, enemy in pairs(hitEnemy) do
			if IsEnemyHealthLow(enemy) then
				lowHealthHitCount = lowHealthHitCount + 1
			end
		end

		-- Fire if we can hit at least three enemies in a line or at least two where one is almost dead already.
		if (AutoCarry.PluginMenu.MinUltEnemies and hitCount >= AutoCarry.PluginMenu.MinUltEnemies) or (hitCount >= 2 and lowHealthHitCount >= 1) then
			if debugMode then PrintChat("Ultimate") end
			CastSpell(_R)
			return true
		end
	end

	return false
end

function FindRMultishot(enemy, predPos)
	local hitCount = 0
	local hitEnemy = {}

	if not RReady or not enemy or enemy.dead or not predPos then return hitCount, hitEnemy end

	local h, heroes = false, nil

	if VIP_USER then
		h, heroes = GetHeroCollision(SkillR, myHero, predPos)
	end

	if not h then return hitCount, hitEnemy end

	if h then
		for index, hero in pairs(heroes) do
			hitCount = hitCount + 1
			if GetDistance(hero) < SkillR.range then
				table.insert(hitEnemy, hero)
			end
		end
	end

	return hitCount, hitEnemy
end

function GetHeroCollision(skill, source, destination)
	if VIP_USER then
		local col = Collision(skill.range, skill.speed*1000, skill.delay/1000, skill.width)

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

function IsEnemyHealthLow(enemy)
	local enemyLowHealth = .40

	if enemy and not enemy.dead and enemy.health < (enemy.maxHealth * enemyLowHealth) then
		return true
	else
		return false
	end
end

-- End of Twitch script

--[[ 
	AoE_Skillshot_Position 2.0 by monogato
	
	GetAoESpellPosition(radius, main_target, [delay]) returns best position in order to catch as many enemies as possible with your AoE skillshot, making sure you get the main target.
	Note: You can optionally add delay in ms for prediction (VIP if avaliable, normal else).
]]

function GetCenter(points)
	local sum_x = 0
	local sum_z = 0
	
	for i = 1, #points do
		sum_x = sum_x + points[i].x
		sum_z = sum_z + points[i].z
	end
	
	local center = {x = sum_x / #points, y = 0, z = sum_z / #points}
	
	return center
end

function ContainsThemAll(circle, points)
	local radius_sqr = circle.radius*circle.radius
	local contains_them_all = true
	local i = 1
	
	while contains_them_all and i <= #points do
		contains_them_all = GetDistanceSqr(points[i], circle.center) <= radius_sqr
		i = i + 1
	end
	
	return contains_them_all
end

-- The first element (which is gonna be main_target) is untouchable.
function FarthestFromPositionIndex(points, position)
	local index = 2
	local actual_dist_sqr
	local max_dist_sqr = GetDistanceSqr(points[index], position)
	
	for i = 3, #points do
		actual_dist_sqr = GetDistanceSqr(points[i], position)
		if actual_dist_sqr > max_dist_sqr then
			index = i
			max_dist_sqr = actual_dist_sqr
		end
	end
	
	return index
end

function RemoveWorst(targets, position)
	local worst_target = FarthestFromPositionIndex(targets, position)
	
	table.remove(targets, worst_target)
	
	return targets
end

function GetInitialTargets(radius, main_target)
	local targets = {main_target}
	local diameter_sqr = 4 * radius * radius
	
	for i=1, heroManager.iCount do
		target = heroManager:GetHero(i)
		if target.networkID ~= main_target.networkID and ValidTarget(target) and GetDistanceSqr(main_target, target) < diameter_sqr then table.insert(targets, target) end
	end
	
	return targets
end

function GetPredictedInitialTargets(radius, main_target, delay)
	if VIP_USER and not vip_target_predictor then vip_target_predictor = TargetPredictionVIP(nil, nil, delay/1000) end
	local predicted_main_target = VIP_USER and vip_target_predictor:GetPrediction(main_target) or GetPredictionPos(main_target, delay)
	local predicted_targets = {predicted_main_target}
	local diameter_sqr = 4 * radius * radius
	
	for i=1, heroManager.iCount do
		target = heroManager:GetHero(i)
		if ValidTarget(target) then
			predicted_target = VIP_USER and vip_target_predictor:GetPrediction(target) or GetPredictionPos(target, delay)
			if target.networkID ~= main_target.networkID and GetDistanceSqr(predicted_main_target, predicted_target) < diameter_sqr then table.insert(predicted_targets, predicted_target) end
		end
	end
	
	return predicted_targets
end

-- I don´t need range since main_target is gonna be close enough. You can add it if you do.
function GetAoESpellPosition(radius, main_target, delay)
	local targets = delay and GetPredictedInitialTargets(radius, main_target, delay) or GetInitialTargets(radius, main_target)
	local position = GetCenter(targets)
	local best_pos_found = true
	local circle = Circle(position, radius)
	circle.center = position
	
	if #targets > 2 then best_pos_found = ContainsThemAll(circle, targets) end
	
	while not best_pos_found do
		targets = RemoveWorst(targets, position)
		position = GetCenter(targets)
		circle.center = position
		best_pos_found = ContainsThemAll(circle, targets)
	end
	
	return position
end

--UPDATEURL=https://bitbucket.org/KainBoL/bol/raw/master/Common/SidasAutoCarryPlugin%20-%20Twitch.lua
--HASH=379F29798FA3E60EDFAFCF342CAC8992