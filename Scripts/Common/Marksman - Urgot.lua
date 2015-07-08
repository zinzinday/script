if myHero.charName ~= "Urgot" then return end

local version = "0.7"
local SCRIPT_NAME = "Urgot"

----- 			Urrrrrrrgot The Underappreciated by Scarem.
----- 						Only the stronk survive.
-----		If you like this script don't donate, buy a beer instead.

-- New features with 0.7 --
-- Fixed a dumbass error with harass (pretend that never happened) --
-- Improved targetting logic for Auto Q --

-- New features with 0.6 --
-- Fixed shit broken with 5.5 --
-- Added SxOrbWalk --

-- New features with 0.5 --
-- E range updated/fixed, delays tweaked to improve prediction accuracy --
-- Prediction values tweaked to suit VPrediction 3 --
-- Tear stacking/farm --
-- Minor combo improvements --
-- Panic feature (if HP drops below 15% in combo and R is available, will ult attacker)

-- New features with 0.4 --
-- Dynamic Q collision fixes, lot better now in harass and combo --
-- W combo improvements --

-- New features with 0.3 --
-- Logic improvements --

-- New features with 0.2 --
-- Autotracker for Q, smarter Q combo, Q prediction improved --
-- Basically improved the logic a little -- 

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("PCFDFHDFJCF") 

	require("SourceLib")
	require("vPrediction")
	require("SxOrbWalk")

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
local MainCombo = {ItemManager:GetItem("DFG"):GetId(), _AA, _R, _Q, _E, _W, _R, _PASIVE, _IGNITE}

--Spell data E delay was 0.6 Q was 0.17
local Ranges = {[_Q] = 1400, [_E] = 920, [_R] = 550}
local Delays = {[_Q] = 0.17, [_E] = 0.6}
local Widths = {[_Q] = 80, [_E] = 100}
local Speeds = {[_Q] = 1600, [_E] = 1600}
local AARange = 150

-- Shield settings, change number for %
local ShieldPer = 35

-- Panic settings, change number for %
local PanicHP = 15

-- Noreturn
local NoReturn = true

-- Orbwalker thingy
local OrbLoad = false

local LastQTime = 0
function OnLoad()

	VP = VPrediction()
	SOWi = SxOrbWalk()
	STS = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 1500)
	DLib = DamageLib()
	DManager = DrawManager()
	print("Urgot by Scarem Loaded!")
	print("Only the stronk survive....")
	
	Orbwalker()

	Q = Spell(_Q, Ranges[_Q])
	E = Spell(_E, Ranges[_E])
	W = Spell(_W, 2000)
	R = Spell(_R, Ranges[_R])
	E.VP = VP
	Q:SetSkillshot(VP, SKILLSHOT_LINEAR, Widths[_Q], Delays[_Q], Speeds[_Q], true)
	E:SetSkillshot(VP, SKILLSHOT_CIRCULAR, Widths[_E], Delays[_E], Speeds[_E], false)

	DLib:RegisterDamageSource(_Q, _MAGIC, 40, 40, _MAGIC, _AP, 0.65, function() return (player:CanUseSpell(_Q) == READY) end)
	DLib:RegisterDamageSource(_W, _MAGIC, 30, 45, _MAGIC, _AP, 0.60, function() return (player:CanUseSpell(_W) == READY) end, function(target) return (player.ap * 0.15 + myHero:GetSpellData(_W).level * 15) or 0 end)
	DLib:RegisterDamageSource(_E, _MAGIC, 35, 35, _MAGIC, _AP, 0.55, function() return (player:CanUseSpell(_E) == READY) end)
	DLib:RegisterDamageSource(_R, _MAGIC, 50, 100, _MAGIC, _AP, 0.5, function() return (player:CanUseSpell(_R) == READY) end)
	DLib:RegisterDamageSource(_PASIVE, _MAGIC, 0, 0, _MAGIC, _AP, 0, nil, function(target) return 0.08 * target.maxHealth end)

	Menu = scriptConfig("Urgot", "Urgot")

	if OrbLoad then
		Menu:addSubMenu("Orbwalking", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)
	end

	Menu:addSubMenu("Target selector", "STS")
		STS:AddToMenu(Menu.STS)

	Menu:addSubMenu("Combo", "Combo")
		Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, false)
		Menu.Combo:addParam("Enabled", "Use Combo!", SCRIPT_PARAM_ONKEYDOWN, false, 32)

	Menu:addSubMenu("Harass", "Harass")
		Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("ManaCheck", "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
		Menu.Harass:addParam("Enabled", "Harass!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

	Menu:addSubMenu("Farm", "Farm")
		Menu.Farm:addParam("ManaCheck", "Minimum mana to tear stack - %", SCRIPT_PARAM_SLICE, 60, 0, 100)
		Menu.Farm:addParam("Enabled", "Farm!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("D"))

	Menu:addSubMenu("Auto", "Auto")
		Menu.Auto:addParam("AutoQ", "Auto Q on Corroded enemies", SCRIPT_PARAM_ONOFF, true)

	Menu:addSubMenu("Drawings", "Drawings")
	--[[Spell ranges]]
	for spell, range in pairs(Ranges) do
		DManager:CreateCircle(myHero, range, 1, {255, 255, 255, 255}):AddToMenu(Menu.Drawings, SpellToString(spell).." Range", true, true, true)
	end
	--[[Predicted damage on healthbars]]
	DLib:AddToMenu(Menu.Drawings, MainCombo)

	EnemyMinions = minionManager(MINION_ENEMY, Ranges[_Q], myHero, MINION_SORT_MAXHEALTH_DEC)
	JungleMinions = minionManager(MINION_JUNGLE, Ranges[_Q], myHero, MINION_SORT_MAXHEALTH_DEC)

end

function Orbwalker()
    if _G.Reborn_Loaded and not _G.Reborn_Initialised then
        DelayAction(Orbwalker, 1)
    elseif _G.Reborn_Initialised then
        print("Urgot detected SAC!")
    else
        print("Urgot no find SAC :(")
				OrbLoad = true
    end
end

function IsCorroded(target)
	return HasBuff(target, "urgotcorrosivedebuff")
end

function Combo()
	ts:update()
	if ts.target ~= nil then
	
		if myHero:CanUseSpell(_E) then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, Delays[_E], Widths[_E], Ranges[_E])
			if HitChance >= 2 and GetDistance(CastPosition) < Ranges[_E] then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
		
		if IsCorroded(ts.target) then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Delays[_Q], Widths[_Q], Ranges[_Q], Speeds[_Q], myHero, false)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Ranges[_Q] and ts.target.dead == false then
						CastSpell(_W)
						CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
		else
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Delays[_Q], Widths[_Q], Ranges[_Q], Speeds[_Q], myHero, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
	
		if ShieldPer > (myHero.health / myHero.maxHealth) * 100 then
			if myHero:CanUseSpell(_W) then
				CastSpell(_W)
			end
		end
	
		if PanicHP > (myHero.health / myHero.maxHealth) * 100 and myHero:CanUseSpell(_R) then
			CastSpell(_R, ts.target)
		end
	end
end

function Harass()
if Menu.Harass.ManaCheck > (myHero.mana / myHero.maxMana) * 100 then return end
	
	if ts.target ~= nil then
	
	if myHero:CanUseSpell(_E) then
		local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, Delays[_E], Widths[_E], Ranges[_E])
		if HitChance >= 2 and GetDistance(CastPosition) < Ranges[_E] then
			CastSpell(_E, CastPosition.x, CastPosition.z)
		end
	end
	
	if ShieldPer > (myHero.health / myHero.maxHealth) * 100 then
			if myHero:CanUseSpell(_W) then
				CastSpell(_W)
			end
	end

end
end

function autotrackE()
	ts:update()
	if ts.target ~= nil then
		if IsCorroded(ts.target) then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Delays[_Q], Widths[_Q], Ranges[_Q], Speeds[_Q], myHero, false)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 and ts.target.dead == false then
						CastSpell(_W)
						CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
		end
	end
end

function Farm()
	if Menu.Farm.ManaCheck > (myHero.mana / myHero.maxMana) * 100 then return end
	EnemyMinions:update()
	
	local minion = EnemyMinions.objects[1]
	if minion and Menu.Farm.ManaCheck < (myHero.mana / myHero.maxMana) * 100 then
			Q:Cast(minion)
	end
end

function JediCrab()
	if NoReturn then
		local minutes = 1
		local seconds = 30
		seconds = seconds + (minutes * 60)
			if GetInGameTimer() >= 90 then
			NoReturn = false
			print("May the crab be with you....")
			end
	end
end

function OnTick()
	SOWi:EnableAttacks()
	
	JediCrab()
	
	if Menu.Auto.AutoQ then
		autotrackE()
	end

	if Menu.Combo.Enabled then
		Combo()
	elseif Menu.Harass.Enabled then
		Harass()
	end
		
	if Menu.Farm.Enabled then
		Farm()
	end
		
end