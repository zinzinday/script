--[[
 
			Auto Carry Plugin - Soraka: The Starchild
				Author: KRU3L420
				Version: See version variables below.
				Copyright 2014

			Dependency: Sida's Auto Carry
 
			How to install:
				Make sure you already have AutoCarry installed.
				Name the script EXACTLY "SidasAutoCarryPlugin - Soraka.lua" without the quotes.
				Place the Plugin in BoL/Scripts/Common folder.

			Features:
				Harass with Q
					- Option to toggle Harass with Q
				Auto-Carry / Combo
					- Will Auto-Exhaust Enemy within range
				Auto-Ignite
					- Will Ignite on Killable Enemy
				Auto-E Team
					- Option to Auto-E Allies
				Priority / Smart Priority
					- Option to change Attack Priority
					- Built-In Priority Sequencer
					- Will cast W+E on Allies with Lowest Health or Mana
				Auto-Silence with E
					- Option to Auto-E enemies to Silence / Interrupt
				CD Handler
					- Cooldown Handler for better skill casting
				Toggleable Options
					- Many options are able to be turned on or off
				Plus+
					- More Features not mentioned above
					- More to come as well!
				    
                
			Download: 
				Version History:
					Version: 1.04
						Completely rewritten for major release!
					Version: 1.03
						Added: Auto-Ignite and Auto-Exhaust
						Added: CD Handler
						Added: Priority Sequencer
						Added: Auto-E Team Option
						Added: Auto Silence / Interrupt 
						+Plus More!
					Version: 1.02
						Added: Auto-Q Enemy in Auto Carry, and Mixed modes.
						Added: HotKey to Harass with Q, also moves to cursor.
						Added: Kill Steal with Q+E
					Version: 1.01
						Removed: Damage Check for Astral Blessing(W)
					Version: 1.00
                        Release         
--]]

if myHero.charName ~= "Soraka" then return end

local QReady, WReady, EReady, RReady, IGNITEReady, EXHAUSTReady = nil, nil, nil, nil, nil, nil
local RangeQ, RangeW, RangeE = 530, 750, 725
local IGNITESlot, EXHAUSTSlot = nil, nil
local ts
local allyTable
local enemyTable
local ToInterrupt = {}
local InterruptList = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "FiddleSticks", spellName = "DrainChannel"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Shen", spellName = "ShenStandUnited"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Varus", spellName = "VarusQ"},
    { charName = "Warwick", spellName = "InfiniteDuress"}
}
local priorityTable = {
	AP = {
		"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
		"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
		"Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi", "Yasuo",
	},
	Support = {
		"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean",
	},
 
	Tank = {
		"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
		"Warwick", "Yorick", "Zac",
	},
 
	AD_Carry = {
		"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "Lucian", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
		"Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed", "Lucian", "Jinx",
	},
 
	Bruiser = {
		"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nautilus", "Nocturne", "Olaf", "Poppy",
		"Renekton", "Rengar", "Riven", "Shyvana", "Trundle", "Tryndamere", "Udyr", "Vi", "MonkeyKing", "XinZhao",
	},
}

function PluginOnLoad()
	AutoCarry.PluginMenu:addParam("combo", "Silence/Exhaust/Attack", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	AutoCarry.PluginMenu:addParam("interrupt", "Interrupt with E", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("printInterrupt", "Print Interrupts", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("autoIGN", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useQ", "Use Q to harass", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useE", "Use E on ally", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("minEmana", "Min. E ally mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	AutoCarry.PluginMenu:addParam("autoR", "Use R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("minRhealth", "Min. R health limit", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
	AutoCarry.PluginMenu:addParam("autoLvl", "Auto Level Skills (Requires Reload)", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:permaShow("combo")

	ts = TargetSelector(TARGET_PRIORITY, RangeE, DAMAGE_MAGIC)
	ts.name = "Soraka"
	AutoCarry.PluginMenu:addTS(ts)

	IGNITESlot = ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") and SUMMONER_2) or nil)
	EXHAUSTSlot = ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerExhaust") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerExhaust") and SUMMONER_2) or nil)
	
	levelSequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	
	allyTable = GetAllyHeroes()
	table.insert(allyTable, myHero)

	enemyTable = GetEnemyHeroes()

	for _, enemy in pairs(enemyTable) do
		for _, champ in pairs(InterruptList) do
			if enemy.charName == champ.charName then
				table.insert(ToInterrupt, champ.spellName)
			end
		end
	end

	if heroManager.iCount < 10 then -- borrowed from Sidas Auto Carry
		PrintChat(" >> Too few champions to arrange priority")
	else
		arrangePrioritys()
	end
end

function PluginOnTick()
	CDHandler()
	if AutoCarry.PluginMenu.autoIGN then AutoIgnite() end
	if AutoCarry.PluginMenu.autoR then CastR() end
	if AutoCarry.PluginMenu.useW then CastW() end
	if AutoCarry.PluginMenu.useQ then CastQ() end
	if AutoCarry.PluginMenu.useE and not AutoCarry.PluginMenu.combo then CastE() end
	if AutoCarry.PluginMenu.combo then Combo() end
	
	if AutoCarry.PluginMenu.autoLvl then autoLevelSetSequence(levelSequence) end
end

function CastR()
	if not RReady then return end

	for i=1, #allyTable do
		local Ally = allyTable[i]

		if Ally.health/Ally.maxHealth <= AutoCarry.PluginMenu.minRhealth/100 then
			CastSpell(_R)
		end
	end
end

function CastW()
	if not WReady then return end

	local HealAmount = myHero:GetSpellData(_W).level*70 + myHero.ap*0.45
	local LowestHealth = nil

	for i=1, #allyTable do
		local Ally = allyTable[i]

		if LowestHealth and LowestHealth.valid and Ally and Ally.valid then
			if Ally.health < LowestHealth.health and RangeW >= myHero:GetDistance(Ally) and (Ally.health + HealAmount) <= Ally.maxHealth then
				LowestHealth = Ally
			end
		else
			LowestHealth = Ally
		end
	end

	if LowestHealth and LowestHealth.valid and RangeW >= myHero:GetDistance(LowestHealth) and (LowestHealth.health + HealAmount) <= LowestHealth.maxHealth then
		CastSpell(_W, LowestHealth)
	end
end

function CastQ()
	if not QReady then return end

	for i=1, #enemyTable do
		local Enemy = enemyTable[i]

		if ValidTarget(Enemy, RangeQ) then
			CastSpell(_Q)
		end
	end
end

function CastE()
	if not EReady then return end

	local LowestMana = nil

	for i=1, #allyTable do
		local Ally = allyTable[i]

		if LowestMana and LowestMana.valid and Ally and Ally.valid then
			if Ally.mana < LowestMana.mana and RangeE >= myHero:GetDistance(Ally) and myHero.networkID ~= Ally.networkID then
				LowestMana = Ally
			end
		else
			LowestMana = Ally
		end
	end

	if LowestMana and LowestMana.valid and RangeE >= myHero:GetDistance(LowestMana) and LowestMana.mana/LowestMana.maxMana <= AutoCarry.PluginMenu.minEmana/100 then CastSpell(_E, LowestMana) end
end

function Combo()
	ts:update()
	if not ts.target then return end

	if ValidTarget(ts.target, RangeE) then
		if QReady then CastSpell(_Q) end
		if EReady then CastSpell(_E, ts.target) end
		if EXHAUSTReady and myHero:GetDistance(ts.target) <= 550 then CastSpell(EXHAUSTSlot, ts.target) end
		if (myHero.range + myHero:GetDistance(myHero.minBBox)) >= myHero:GetDistance(ts.target) then myHero:Attack(ts.target) end
	end
end

function OnProcessSpell(unit, spell)
	if #ToInterrupt > 0 and AutoCarry.PluginMenu.interrupt and EReady then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team then
				if RangeE >= myHero:GetDistance(unit) then
					CastSpell(_E, unit)
					if AutoCarry.PluginMenu.printInterrupt then print("Tried to interrupt " .. spell.name) end
				end
			end
		end
	end
end

function CDHandler()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	IGNITEReady = (IGNITESlot ~= nil and myHero:CanUseSpell(IGNITESlot) == READY)
	EXHAUSTReady = (EXHAUSTSlot ~= nil and myHero:CanUseSpell(EXHAUSTSlot) == READY)
end

function AutoIgnite()
	if not IGNITEReady then return end

	for i=1, #enemyTable do
		local Enemy = enemyTable[i]

		if ValidTarget(Enemy, 600) then
			if getDmg("IGNITE", Enemy, myHero) >= Enemy.health then
				CastSpell(IGNITESlot, Enemy)
			end
		end
	end
end

function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
 
function arrangePrioritys()
	for i, enemy in ipairs(enemyTable) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP, enemy, 2)
		SetPriority(priorityTable.Support, enemy, 3)
		SetPriority(priorityTable.Bruiser, enemy, 4)
		SetPriority(priorityTable.Tank, enemy, 5)
	end
end


--UPDATEURL=
--HASH=E3ADC1ABD791F8E7943A5BA19CAF3ED4
