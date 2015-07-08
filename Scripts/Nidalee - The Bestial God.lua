--[[

---//=================================================================================================\\---
--|| > Nidalee - The Bestial God																	   ||--
---\\=================================================================================================//---
	 __   __  __  _____   ______  __      ______  ______  ______  ______  _____
	/\ "-.\ \/\ \/\  __-./\  __ \/\ \    /\  ___\/\  ___\/\  ___\/\  __ \/\  __-.
	\ \ \-.  \ \ \ \ \/\ \ \  __ \ \ \___\ \  __\\ \  __\\ \ \__ \ \ \/\ \ \ \/\ \
	 \ \_\\"\_\ \_\ \____-\ \_\ \_\ \_____\ \_____\ \_____\ \_____\ \_____\ \____-
	  \/_/ \/_/\/_/\/____/ \/_/\/_/\/_____/\/_____/\/_____/\/_____/\/_____/\/____/
	  
---//=================================================================================================\\---
--|| > About Script																					   ||--
---\\=================================================================================================//---

	Script:			Nidalee - The Bestial God
	Version:		1.06
	Script Date:	2015-02-22
	Author:			Devn

---//=================================================================================================\\---
--|| > Changelog																					   ||--
---\\=================================================================================================//---

	Version 1.00:
		- Initial script release.
		
	Version 1.01:
		- Changed around pounce logic for combo mode.
		- Changed form swapping logic for combo mode.
		- Fixed killstealing during cougar mode.
		- Add key for ScriptStatus.net.
		
	Version 1.02:
		- Updated to use new GodLib.
		
	Version 1.03:
		- Added auto-attack check (won't cancel AA to cast spells).
		- Added evading check (won't attempt to cast spells while using Evadee or FGE).
		- Fixed pounce range checking.
		- Added lane clear mode.
		- Added jungle clear mode.
		- Added auto-heal.
		- Added PermaShow menu.
		
	Version 1.04:
		- Added AutoLevelManager support.
		- Added target searching for harass mode.
		- Added swapping to human to throw spear for harass mode.
		- Added spear collision drawing.
		
	Version 1.05:
		- Fixed pounce casting.
		
	Version 1.06:
		- Changed SxOrb:MyAttack(unit) to SxOrb:Attack(unit).

--]]

---//=================================================================================================\\---
--|| > User Variables																				   ||--
---\\=================================================================================================//---

-- Main Script
_G.NidaleeGod_AutoUpdate		= true
_G.NidaleeGod_DisableSxOrbWalk	= false
_G.NidaleeGod_EnableDebugMode	= false

---//=================================================================================================\\---
--|| > Initialization																				   ||--
---\\=================================================================================================//---

-- Champion check.
if (myHero.charName ~= "Nidalee") then return end

-- Load GodLib.
assert(load(Base64Decode("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"), nil, "bt", _ENV))()
if (not GodLib) then return end

-- Update variables.
GodLib.Update.Host			= "raw.github.com"
GodLib.Update.Path			= "DevnBoL/Scripts/master/Nidalee"
GodLib.Update.Version		= "Current.version"
GodLib.Update.Script		= "Nidalee - The Bestial God.lua"

-- Script variables.
GodLib.Script.Variables		= "NidaleeGod"
GodLib.Script.Name 			= "Nidalee - The Bestial God"
GodLib.Script.Version		= "1.06"
GodLib.Script.Date			= "2015-02-22"
GodLib.Script.SafeVersion	= "5.3"
GodLib.Script.Key			= "VILJJPJJIPN"

-- Required libraries.
GodLib.RequiredLibraries	= {
	["SxOrbWalk"]			= "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
	["CustomPermaShow"]		= "https://raw.githubusercontent.com/Superx321/BoL/master/common/CustomPermaShow.lua",
}

-- Check for Prodiction.
if (VIP_USER and FileExist(Format("{1}Prodiction.lua", LIB_PATH))) then
	GodLib.RequiredLibraries["Prodiction"] = ""
end

-- Disable script status key if debug mode.
if (_G.NidaleeGod_EnableDebugMode) then
	GodLib.Script.Key = nil
end

---//=================================================================================================\\---
--|| > Callback Handlers																			   ||--
---\\=================================================================================================//---

Callbacks:Bind("Initialize", function()
	
	SetupVariables()
	SetupDebugger()
	SetupConfig()
	
	ScriptManager:GetAsyncWebResult(GodLib.Update.Host, Format("/{1}/{2}", GodLib.Update.Path, "Message.txt"), function(message)
		PrintLocal(message)
	end)

	PrintLocal(Format("Script v{1} loaded successfully!", ScriptVersion))

end)

Callbacks:Bind("ProcessSpell", function(unit, spell)

	if (unit.isMe) then
		OnUpdateCooldowns(spell)
	end

end)

Callbacks:Bind("Draw", function()

	OnDrawPermaShow(Config.Drawing)

	if (not myHero.dead) then
		OnDrawRanges(Config.Drawing)
	end

end)

Callbacks:Bind("AfterAttack", function(target)

	if (CougarForm and Config.Combo.Active and Config.Combo.Cougar.UseQ and Spells.Cougar[_Q]:IsReady() and Spells.Cougar[_Q]:IsValid(target)) then
		CastTakedown(target)
	end

end)

Callbacks:Bind("Tick", function()

	if (not CougarForm and not HumanRange) then
		DelayAction(function()
			HumanRange = Player:GetRange()
		end)
	elseif (CougarForm and not CougarRange) then
		DelayAction(function()
			CougarRange = Player:GetRange()
		end)
	end

end)

Callbacks:Bind("FinishRecall", function(unit)

	if (unit.isMe and Config.Misc.RecallCougar and not CougarForm and (#GetEnemiesInRange(Config.Misc.RecallEnemies) == 0)) then
		Spells[_R]:Cast()
	end

end)

---//=================================================================================================\\---
--|| > Script Setup																					   ||--
---\\=================================================================================================//---

function SetupVariables()

	Spells			= {
		["Human"]	= {
			[_Q]	= SpellData(_Q, 1450, "Javelin Toss"),
			[_W]	= SpellData(_W, 900, "Bushwhack"),
			[_E]	= SpellData(_E, 650, "Primal Surge"),
		},
		["Cougar"]	= {
			[_Q]	= SpellData(_Q, 350, "Takedown", "QM"),
			[_W]	= SpellData(_W, 400, "Pounce", "WM"),
			[_E]	= SpellData(_E, 375, "Swipe", "EM"),
		},
		[_R]		= SpellData(_R, nil, "Aspect of the Cougar"),
	}

	Cooldowns		= {
		["Human"]	= {
			[_Q]	= 0,
			[_W]	= 0,
			[_E]	= 0,
		},
		["Cougar"]	= {
			[_Q]	= 0,
			[_W]	= 0,
			[_E]	= 0,
		},
	}
	
	SpellReady		= {
		["Human"]	= {
			[_Q]	= false,
			[_W]	= false,
			[_E]	= false,
		},
		["Cougar"]	= {
			[_Q]	= false,
			[_W]	= false,
			[_E]	= false,
		}
	}
	
	Minions			= {
		Enemy		= minionManager(MINION_ENEMY, Spells.Human[_Q].Range, myHero, MINION_SORT_HEALTH_ASC),
		Jungle		= minionManager(MINION_JUNGLE, Spells.Human[_Q].Range, myHero, MINION_SORT_MAXHEALTH_DEC),
	}
	
	CurrentTarget	= nil
	HumanRange		= nil
	CougarRange		= nil
	
	ExtendedPounce	= 765
	
	Config			= MenuConfig(Format("{1}_Main", VariableName), ScriptName)
	AutoLeveler		= AutoLevelManager(true)
	Selector		= SimpleTS(STS_LESS_CAST_MAGIC)
	
	Spells.Human[_Q]:SetSkillshot(SKILLSHOT_LINEAR, 37, 0.125, 1300, true)
	Spells.Human[_W]:SetSkillshot(SKILLSHOT_CIRCULAR, 100, 0.5, 1500, false)
	
	Spells.Cougar[_W]:SetSkillshot(SKILLSHOT_CIRCULAR, 95, 0.5, 1500, false)
	
	AutoLeveler:AddStartSequence("Q > E > W", { _Q, _E, _W }, true)
	AutoLeveler:AddStartSequence("W > E > Q", { _W, _E, _Q })
	AutoLeveler:AddStartSequence("E > Q > W", { _E, _Q, _W })
	
	AutoLeveler:AddEndSequence("Q > E > W", { _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W }, true)
	AutoLeveler:AddEndSequence("E > Q > W", { _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W })
	
	TickManager:Add("Combo", "Combo Mode", 500, function() OnComboMode(Config.Combo) end)
	TickManager:Add("Harass", "Harass Mode", 500, function() OnHarassMode(Config.Harass) end)
	TickManager:Add("LaneClear", "Lane Clear Mode", 500, function() OnLaneClear(Config.LaneClear) end)
	TickManager:Add("JungleClear", "Jungle Clear Mode", 500, function() OnJungleClear(Config.JungleClear) end)
	TickManager:Add("AutoHeal", "Auto-Heal", 500, function() OnAutoHeal(Config.AutoHeal) end)
	TickManager:Add("Killsteal", "Killsteal", 500, function() OnKillsteal(Config.Killstealing) end)
	TickManager:Add("UpdateTarget", "Update Current Target", 500, OnUpdateTarget)
	TickManager:Add("ProcessCooldowns", "Process Cooldowns", 500, OnProcessCooldowns)
	
	OnUpdateCougarForm()
	
end

function SetupDebugger()

	if (not EnableDebugMode) then
		return
	end
	
	Debugger = VisualDebugger()
	
	Debugger:Group("SpellsHuman", "Hero Spells (Human)")
	Debugger:Variable("SpellsHuman", Format("{1} (Q)", Spells.Human[_Q].Name), function() return (SpellReady.Human[_Q]) end)
	Debugger:Variable("SpellsHuman", Format("{1} (W)", Spells.Human[_W].Name), function() return (SpellReady.Human[_W]) end)
	Debugger:Variable("SpellsHuman", Format("{1} (E)", Spells.Human[_E].Name), function() return (SpellReady.Human[_E]) end)
	Debugger:Variable("SpellsHuman", Format("{1} (R)", Spells[_R].Name), function() return Spells[_R]:IsReady() end)

	Debugger:Group("SpellsCougar", "Hero Spells (Cougar)")
	Debugger:Variable("SpellsCougar", Format("{1} (Q)", Spells.Cougar[_Q].Name), function() return (SpellReady.Cougar[_Q]) end)
	Debugger:Variable("SpellsCougar", Format("{1} (W)", Spells.Cougar[_W].Name), function() return (SpellReady.Cougar[_W]) end)
	Debugger:Variable("SpellsCougar", Format("{1} (E)", Spells.Cougar[_E].Name), function() return (SpellReady.Cougar[_E]) end)

	Debugger:Group("Misc", "Misc Variables")
	Debugger:Variable("Misc", "Current Target", function() return (CurrentTarget and CurrentTarget.charName) or "No Target" end)
	Debugger:Variable("Misc", "Cougar Form", function() return CougarForm end)
	Debugger:Variable("Misc", "Is Attacking", function() return Player.IsAttacking end)
	Debugger:Variable("Misc", "Is Evading", function() return IsEvading() end)
	Debugger:Variable("Misc", "Is Recalling", function() return Player.IsRecalling end)
	
end

function SetupConfig()
	
	if (SxOrb) then
		Config:Menu("OrbWalker", "Settings: Orb-Walker")
		SxOrb:LoadToMenu(Config.OrbWalker)
	end
	
	Config:Menu("Selector", "Settings: Target Selector")
	Config:Menu("Combo", "Settings: Combo (All-In) Mode")
	Config:Menu("Harass", "Settings: Harass (Poke) Mode")
	Config:Menu("LaneClear", "Settings: Lane-Clear Mode")
	Config:Menu("JungleClear", "Settings: Jungle-Clear Mode")
	Config:Menu("Killstealing", "Settings: Killstealing")
	Config:Menu("AutoHeal", "Settings: Auto-Healing")
	Config:Menu("AutoLevel", "Settings: Skill Level Manager")
	Config:Menu("Misc", "Settings: Miscellaneous")
	Config:Menu("Drawing", "Settings: Drawing")
	Config:Separator()
	Config:Info("Version", ScriptVersion)
	Config:Info("Build Date", ScriptDate)
	Config:Info("Tested With", Format("LoL {1}", SafeVersion))
	Config:Info("Author", "Devn")
	
	Selector:LoadToMenu(Config.Selector)
	SetupConfig_Combo(Config.Combo)
	SetupConfig_Harass(Config.Harass)
	SetupConfig_LaneClear(Config.LaneClear)
	SetupConfig_JungleClear(Config.JungleClear)
	SetupConfig_Killstealing(Config.Killstealing)
	SetupConfig_AutoHeal(Config.AutoHeal)
	AutoLeveler:LoadToMenu(Config.AutoLevel)
	SetupConfig_Misc(Config.Misc)
	SetupConfig_Drawing(Config.Drawing)
	
end

---//=================================================================================================\\---
--|| > Config Setup																					   ||--
---\\=================================================================================================//---

function SetupConfig_Combo(config)
	
	config:Menu("Human", "Spells: Human")
	config:Menu("Cougar", "Spells: Cougar")
	
	config.Human:Toggle("UseQ", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config.Human:Slider("MinManaQ", "Minimum Mana Percent", 0, 0, 100)
	config.Human:Separator()
	config.Human:DropDown("UseW", Format("Use {1} (W)", Spells.Human[_W].Name), 2, { "Always", "On Inmobile", "Disabled" })
	config.Human:Slider("MinManaW", "Minimum Mana Percent", 50, 0, 100)
	
	config.Cougar:Toggle("UseQ", Format("Use {1} (Q)", Spells.Cougar[_Q].Name), true)
	config.Cougar:DropDown("UseW", Format("Use {1} (W)", Spells.Cougar[_W].Name), 2, { "Always", "If out of AA Range", "Disabled" })
	config.Cougar:Toggle("UseE", Format("Use {1} (E)", Spells.Cougar[_E].Name), true)
	
	config:Separator()
	config:KeyBinding("Active", "Combo (All-In) Mode Active", false, 32)
	config:Separator()
	config:Toggle("UseR", Format("Use {1} (R)", Spells[_R].Name), true)
	
end

function SetupConfig_Harass(config)
	
	config:KeyBinding("Active", "Harass (Poke) Mode Active", false, "T")
	config:Separator()
	config:Toggle("UseQ", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config:Slider("MinManaQ", "Minimum Mana Percent", 50, 0, 100)
	config:Slider("SearchQ", "Targets to Search For", 2, 1, 5)
	config:Separator()
	config:Toggle("UseR", Format("Use {1} (R)", Spells[_R].Name), true)
	
end

function SetupConfig_LaneClear(config)
	
	config:KeyBinding("Active", "Lane Clear Mode Active", false, "C")
	config:Separator()
	config:Toggle("UseQ", Format("Use {1} (Q)", Spells.Cougar[_Q].Name), true)
	config:Toggle("UseW", Format("Use {1} (W)", Spells.Cougar[_W].Name), true)
	config:Toggle("UseE", Format("Use {1} (E)", Spells.Cougar[_E].Name), true)
	config:Separator()
	config:Toggle("UseR", Format("Use {1} (R)", Spells[_R].Name), false)

end

function SetupConfig_JungleClear(config)

	config:Menu("Human", "Spells: Human Form")
	config:Menu("Cougar", "Spells: Cougar Form")
	
	config.Human:Toggle("UseQ", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config.Human:Slider("MinManaQ", "Minimum Mana Percent", 0, 0, 100)
	config.Human:Separator()
	config.Human:Toggle("UseW", Format("Use {1} (W)", Spells.Human[_W].Name), true)
	config.Human:Slider("MinManaW", "Minimum Mana Percent", 0, 0, 100)
	config.Human:Separator()
	config.Human:DropDown("UseE", Format("Use {1} (E)", Spells.Human[_E].Name), 1, { "If Have Blue Buff", "Always", "Disabled" })
	config.Human:Slider("MinManaE", "Minimum Mana Percent", 0, 0, 100)
	config.Human:Note("Only if doesn't have blue buff.")
	
	config.Cougar:Toggle("UseQ", Format("Use {1} (Q)", Spells.Cougar[_Q].Name), true)
	config.Cougar:Toggle("UseW", Format("Use {1} (W)", Spells.Cougar[_W].Name), true)
	config.Cougar:Toggle("UseE", Format("Use {1} (E)", Spells.Cougar[_E].Name), true)
	
	config:Separator()
	config:KeyBinding("Active", "Jungle Clear Mode Active", false, "X")
	config:Separator()
	config:Toggle("UseR", Format("Use {1} (R)", Spells[_R].Name), true)

end

function SetupConfig_Killstealing(config)

	config:Menu("Human", "Spells: Human Form")
	config:Menu("Cougar", "Spells: Cougar Form")
	
	config.Human:Toggle("UseQ", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config.Human:Slider("MinManaQ", "Minimum Mana Percent", 0, 0, 100)
	
	config.Cougar:Toggle("UseQ", Format("Use {1} (Q)", Spells.Cougar[_Q].Name), true)
	config.Cougar:Toggle("UseW", Format("Use {1} (W)", Spells.Cougar[_W].Name), true)
	config.Cougar:Toggle("UseE", Format("Use {1} (E)", Spells.Cougar[_E].Name), true)
	
	config:Separator()
	config:Toggle("Enable", "Enable Killstealing", true)
	config:Separator()
	config:Toggle("UseR", Format("Use {1} (R)", Spells[_R].Name), true)

end

function SetupConfig_AutoHeal(config)

	config:Menu("Allies", "Settings: Ally Heroes")
	
	local foundAlly = false
	local allies	= GetAllyHeroes()
	
	for i = 1, #allies do
		foundAlly	= true
		local ally	= allies[i]
		config.Allies:Toggle(Format("{1}Enabled", ally.charName), Format("Heal {1}", ally.charName), true)
		config.Allies:Slider(Format("{1}MinHealth", ally.charName), "Minimum Health Percent", 40, 0, 100)
		config.Allies:Slider(Format("{1}MinMana", ally.charName), "Minimum Mana Percent", 35, 0, 100)
		if (i < #allies) then
			config.Allies:Separator()
		end
	end
	
	if (not foundAlly) then
		config.Allies:Note("No ally heroes found.")
	end
	
	config:Separator()
	config:Toggle("Enabled", "Enable Auto-Healing", true)
	config:Toggle("DisableRecalling", "Disable While Recalling", true)
	config:Separator()
	config:Toggle("Self", "Heal Self", true)
	config:Slider("MinHealth", "Minimum Health Percent", 50, 0, 100)
	config:Slider("MinMana", "Minimum Mana Percent", 30, 0, 100)

end

function SetupConfig_Misc(config)

	config:Menu("TickManager", "Settings: Tick Manager")
	config:Separator()
	config:Toggle("RecallCougar", "Transform to Cougar After Recall", true)
	config:Slider("RecallEnemies", "Range to Search for Enemies", 1500, 0, 2000)
	config:Note("Won't transform if enemy found in range.")
	
	TickManager:LoadToMenu(config.TickManager)

	if (EnableDebugMode) then
		config:Menu("Debugger", "Settings: Visual Debugger")
		Debugger:LoadToMenu(config.Debugger)
	end
	
end

function SetupConfig_Drawing(config)
	
	config:Menu("Human", "Spells: Human")
	
	local function SetupConfig_Drawing_Human(config)
	
		config:Toggle("QRange", Format("{1} (Q) Range", Spells.Human[_Q].Name), true)
		config:DropDown("QRangeColor", "Range Color", 1, DrawManager.Colors)
		config:Separator()
		config:Toggle("QCollision", Format("{1} (Q) Collision", Spells.Human[_Q].Name), true)
	
	end
	
	SetupConfig_Drawing_Human(config.Human)
	
	config:Separator()
	DrawManager:LoadToMenu(config)
	config:Separator()
	config:Toggle("PermaShow", "Show Perma Show Menu", true)
	config:DropDown("PermaShowColor", "Perma Show Color", DrawManager:GetColorIndex("Dark Green"), DrawManager.Colors)
	config:Separator()
	config:Toggle("AA", "Draw Auto-Attack Range", true)
	config:DropDown("AAColor", "Range Color", 1, DrawManager.Colors)
	config:Separator()
	config:Toggle("Cooldowns", "Draw Opposite Form Cooldowns", true)
	config:DropDown("CooldownsColor", "Text Color", 1, DrawManager.Colors)
	
end

---//==================================================\\---
--|| > Main Callback Handlers							||--
---\===================================================//---

function OnComboMode(config)

	if (myHero.dead or not config.Active or IsEvading() or Player.IsAttacking or not Spells.Human[_Q]:IsValid(CurrentTarget)) then
		return
	end
	
	if (CougarForm) then
		if (Spells.Cougar[_Q]:IsReady() and config.Cougar.UseQ and Spells.Cougar[_Q]:InRange(CurrentTarget)) then
			CastTakedown(CurrentTarget)
		end
		if (Spells.Cougar[_W]:IsReady() and (config.Cougar.UseW < 3)) then
			if ((config.Cougar.UseW == 1) or ((config.Cougar.UseW == 2) and not InRange(CurrentTarget, Player:GetRange()))) then
				if (InPounceRange(CurrentTarget)) then
					Spells.Cougar[_W]:CastAt(CurrentTarget)
				elseif (TargetHunted(CurrentTarget) and InRange(CurrentTarget, ExtendedPounce)) then
					Spells.Cougar[_W]:CastAt(CurrentTarget)
				end
			end
		end
		if (Spells.Cougar[_E]:IsReady() and config.Cougar.UseE and Spells.Cougar[_E]:IsValid(CurrentTarget)) then
			Spells.Cougar[_E]:CastAt(CurrentTarget)
		end
		if (Spells[_R]:IsReady() and config.UseR) then
			if (SpellReady.Human[_Q] and config.Human.UseQ) then
				if (CurrentTarget.health <= CougarDamage(CurrentTarget) and InRange(CurrentTarget, Spells.Cougar[_W].Range)) then
					return
				end
				if (Spells.Human[_Q]:WillHit(CurrentTarget)) then
					Spells[_R]:Cast()
					return
				end
			end
			if (not Spells.Cougar[_Q]:IsReady() and not Spells.Cougar[_W]:IsReady() and not Spells.Cougar[_E]:IsReady() and not InPounceRange(CurrentTarget)) then
				Spells[_R]:Cast()
				return
			end
		end
	else
		if (Spells.Human[_Q]:IsReady() and config.Human.UseQ and Spells.Human[_Q]:IsValid(CurrentTarget)) then
			Spells.Human[_Q]:Cast(CurrentTarget)
		end
		if (Spells.Human[_W]:IsReady() and (config.Human.UseW < 3) and Spells.Human[_W]:InRange(CurrentTarget)) then
			if (config.Human.UseW == 1) then
				Spells.Human[_W]:Cast(CurrentTarget)
			elseif (config.Human.UseW == 2) then
				Spells.Human[_W]:CastIfImmobile(CurrentTarget)
			end
		end
		if (Spells[_R]:IsReady() and config.UseR) then
			local first = false
			local swap = false
			if (Spells.Human[_Q]:IsReady() and Spells.Human[_Q]:WillHit(CurrentTarget)) then
				first = true
			else
				first = true
			end
			if (first) then
				if (config.Cougar.UseW and SpellReady.Cougar[_W]) then
					if (InPounceRange(CurrentTarget)) then
						swap = true
					elseif (TargetHunted(CurrentTarget) and InRange(CurrentTarget, ExtendedPounce)) then
						swap = true
					end
				end
				if (config.Cougar.UseQ and SpellReady.Cougar[_Q] and Spells.Cougar[_Q]:InRange(CurrentTarget)) then
					swap = true
				elseif (config.Cougar.UseE and SpellReady.Cougar[_E] and Spells.Cougar[_E]:InRange(CurrentTarget)) then
					swap = true
				end
				if (swap) then
					Spells[_R]:Cast()
				end
			end
		end
	end

end

function OnHarassMode(config)

	if (myHero.dead or not config.Active or IsEvading() or Player.IsAttacking) then
		return
	end
	
	local targets = { CurrentTarget }
	
	for i = 2, config.SearchQ do
		table.insert(targets, Selector:GetTarget(Spells.Human[_Q].Range, i))
	end
	
	for _, enemy in ipairs(targets) do
		if (config.UseQ and SpellReady.Human[_Q] and IsValid(enemy) and HaveEnoughMana(config.MinManaQ) and Spells.Human[_Q]:WillHit(enemy)) then
			if (not CougarForm) then
				Spells.Human[_Q]:Cast(enemy)
			elseif (config.UseR and Spells[_R]:IsReady()) then
				Spells[_R]:Cast()
				return
			end
		end
	end

end

function OnLaneClear(config)

	if (myHero.dead or not config.Active or IsEvading() or Player.IsAttacking) then
		return
	end
	
	Minions.Enemy:update()
	
	if (#Minions.Enemy.objects == 0) then
		return
	end
	
	local function CheckMinion(minion)
		if (not CougarForm) then
			if (config.UseR and Spells[_R]:IsReady()) then
				if (config.UseW and SpellReady.Cougar[_W] and InPounceRange(minion)) then
					Spells[_R]:Cast()
					return
				end
				if (config.UseE and SpellReady.Cougar[_E] and Spells.Cougar[_E]:InRange(minion)) then
					Spells[_R]:Cast()
					return
				end
				if (config.UseQ and SpellReady.Cougar[_Q] and Spells.Cougar[_Q]:InRange(minion) and Spells.Cougar[_Q]:WillKill(minion)) then
					Spells[_R]:Cast()
					return
				end
			end
		else
			if (config.UseW and Spells.Cougar[_W]:IsReady() and Spells.Cougar[_W]:WillKill(minion) and InPounceRange(minion)) then
				Spells.Cougar[_W]:CastAt(minion)
				return
			end
			if (config.UseE and Spells.Cougar[_E]:IsReady() and Spells.Cougar[_E]:WillKill(minion) and Spells.Cougar[_E]:InRange(minion)) then
				Spells.Cougar[_E]:CastAt(minion)
				return
			end
			if (config.UseQ and Spells.Cougar[_Q]:IsReady() and Spells.Cougar[_Q]:WillKill(minion) and Spells.Cougar[_Q]:InRange(minion)) then
				CastTakedown(minion)
				return
			end
			if (Player:CanAttack() and WillKill(minion, "AD") and config.UseR and Spells[_R]:IsReady() and not InRange(minion, Player:GetRange()) and InRange(minion, HumanRange)) then
				Spells[_R]:Cast()
				return
			end
		end
	end
	
	for i = 1, #Minions.Enemy.objects do
		CheckMinion(Minions.Enemy.objects[i])
	end
	
	if (CougarForm) then
		for i = 1, #Minions.Enemy.objects do
			local minion = Minions.Enemy.objects[i]
			if (config.UseW and Spells.Cougar[_W]:IsReady() and InPounceRange(minion)) then
				Spells.Cougar[_W]:CastAt(minion)
			end
			if (config.UseE and Spells.Cougar[_E]:IsReady() and Spells.Cougar[_E]:InRange(minion)) then
				Spells.Cougar[_E]:CastAt(minion)
			end
		end
	end

end

function OnJungleClear(config)

	if (myHero.dead or not config.Active or IsEvading() or Player.IsAttacking) then
		return
	end

	Minions.Jungle:update()
	
	if (#Minions.Jungle.objects == 0) then
		return
	end
	
	local function CheckMinion(minion)
		if (not CougarForm) then
			if (config.UseR and Spells[_R]:IsReady() and (config.Cougar.UseQ or config.Cougar.UseW or config.Cougar.UseE)) then
				if (config.Cougar.UseQ and SpellReady.Cougar[_Q] and Spells.Cougar[_Q]:WillKill(minion) and Spells.Cougar[_Q]:InRange(minion)) then
					Spells[_R]:Cast()
					return
				end
				if (config.Cougar.UseE and SpellReady.Cougar[_E] and Spells.Cougar[_E]:WillKill(minion) and Spells.Cougar[_E]:InRange(minion)) then
					Spells[_R]:Cast()
					return
				end
				if (config.Cougar.UseW and SpellReady.Cougar[_W] and Spells.Cougar[_W]:WillKill(minion)) then
					if (InPounceRange(minion)) then
						Spells[_R]:Cast()
						return
					elseif (TargetHunted(minion) and InRange(minion, ExtendedPounce)) then
						Spells[_R]:Cast()
						return
					end
				end
			end
		else
			if (config.Cougar.UseQ and Spells.Cougar[_Q]:IsReady() and Spells.Cougar[_Q]:WillKill(minion) and Spells.Cougar[_Q]:InRange(minion)) then
				CastTakedown(minion)
				return
			end
			if (config.Cougar.UseE and Spells.Cougar[_E]:IsReady() and Spells.Cougar[_E]:WillKill(minion) and Spells.Cougar[_E]:InRange(minion)) then
				Spells.Cougar[_E]:CastAt(minion)
				return
			end
			if (config.Cougar.UseW and Spells.Cougar[_W]:IsReady() and Spells.Cougar[_W]:WillKill(minion)) then
				if (InPounceRange(minion)) then
					Spells.Cougar[_W]:CastAt(minion)
					return
				elseif (TargetHunted(minion) and InRange(minion, ExtendedPounce)) then
					Spells.Cougar[_W]:CastAt(minion)
					return
				end
			end
		end
	end
	
	for i = 1, #Minions.Jungle.objects do
		if (CheckMinion(Minions.Jungle.objects[i])) then
			return
		end
	end
	
	local minion = Minions.Jungle.objects[1]
	
	if (not CougarForm) then
		OnAutoHeal(Config.AutoHeal)
		if (config.Human.UseQ and Spells.Human[_Q]:IsReady() and Spells.Human[_Q]:InRange(minion) and HaveEnoughMana(config.Human.MinManaQ) and Spells.Human[_Q]:WillHit(minion)) then
			Spells.Human[_Q]:Cast(minion)
		end
		if (config.Human.UseW and Spells.Human[_W]:IsReady() and Spells.Human[_W]:InRange(minion) and HaveEnoughMana(config.Human.MinManaW)) then
			Spells.Human[_W]:Cast(minion)
		end
		if ((config.Human.UseE < 3) and Spells.Human[_E]:IsReady()) then
			if (config.Human.UseE == 2) then
				if (HasBlueBuff(minion) or HaveEnoughMana(config.Human.MinManaE)) then
					Spells.Human[_E]:CastAt(myHero)
				end
			elseif ((config.Human.UseE == 1) and HasBlueBuff()) then
				Spells.Human[_E]:CastAt(myHero)
			end
		end
		if (config.UseR and Spells[_R]:IsReady() and (config.Cougar.UseQ or config.Cougar.UseW or config.Cougar.UseE)) then
			if (config.Cougar.UseE and SpellReady.Cougar[_E] and Spells.Cougar[_E]:InRange(minion)) then
				Spells[_R]:Cast()
				return
			end
			if (config.Cougar.UseW and SpellReady.Cougar[_W]) then
				if (InPounceRange(minion)) then
					Spells[_R]:Cast()
					return
				elseif (TargetHunted(minion) and InRange(minion, ExtendedPounce)) then
					Spells[_R]:Cast()
					return
				end
			end
			if (config.Cougar.UseQ and SpellReady.Cougar[_Q] and Spells.Cougar[_Q]:InRange(minion)) then
				Spells[_R]:Cast()
				return
			end
		end
	else
		if (config.Cougar.UseE and Spells.Cougar[_E]:IsReady() and Spells.Cougar[_E]:InRange(minion)) then
			Spells.Cougar[_E]:CastAt(minion)
		end
		if (config.Cougar.UseW and Spells.Cougar[_W]:IsReady()) then
			if (InPounceRange(minion)) then
				Spells.Cougar[_W]:CastAt(minion)
			elseif (TargetHunted(minion) and InRange(minion, ExtendedPounce)) then
				Spells.Cougar[_W]:CastAt(minion)
			end
		end
		if (config.Cougar.UseQ and Spells.Cougar[_Q]:IsReady() and Spells.Cougar[_Q]:InRange(minion)) then
			CastTakedown(minion)
		end
		if (config.UseR and Spells[_R]:IsReady() and (config.Human.UseQ or config.Human.UseW or config.Human.UseE)) then
			if (config.Human.UseQ and SpellReady.Human[_Q] and Spells.Human[_Q]:InRange(minion) and HaveEnoughMana(config.Human.MinManaQ) and Spells.Human[_Q]:WillHit(minion)) then
				Spells[_R]:Cast()
				return
			end
			if (config.Human.UseW and SpellReady.Human[_W] and Spells.Human[_W]:InRange(minion) and HaveEnoughMana(config.Human.MinManaW)) then
				Spells[_R]:Cast()
				return
			end
			if ((config.Human.UseE < 3) and Spells.Human[_E]:IsReady()) then
				if (config.Human.UseE == 2) then
					if (HasBlueBuff(minion) or HaveEnoughMana(config.Human.MinManaE)) then
						Spells[_R]:Cast()
						return
					end
				elseif ((config.Human.UseE == 1) and HasBlueBuff()) then
					Spells[_R]:Cast()
					return
				end
			end
		end
	end
	
end

function OnAutoHeal(config)

	if (myHero.dead or not config.Enabled or CougarForm or not Spells.Human[_E]:IsReady()) then
		return
	end
	
	if (config.DisableRecalling and Player.IsRecalling) then
		return
	end
	
	if (config.Self and HealthLowerThenPercent(config.MinHealth) and (HaveEnoughMana(config.MinMana) or HasBlueBuff())) then
		Spells.Human[_E]:Cast(myHero)
		return
	end
	
	for _, ally in ipairs(GetAllyHeroes()) do
		if (config.Allies[Format("{1}Enabled", ally.charName)] and (HaveEnoughMana(config.Allies[Format("{1}MinMana", ally.charName)]) or HasBlueBuff()) and HealthLowerThenPercent(config.Allies[Format("{1}MinHealth", ally.charName)])) then
			Spells.Human[_E]:Cast(ally)
			return
		end
	end

end

function OnKillsteal(config)

	if (not config.Enable) then
		return
	end
	
	for _, enemy in ipairs(GetEnemyHeroes()) do
		if (enemy and Spells.Human[_Q]:IsValid(enemy)) then
			local damage = getDmg("AD", enemy, myHero)
			if (CougarForm) then
				if (config.Cougar.UseE and Spells.Cougar[_E]:WillKill(enemy) and Spells.Cougar[_E]:IsReady() and Spells.Cougar[_E]:IsValid(enemy)) then
					Spells.Cougar[_E]:CastAt(enemy)
					return
				elseif (config.Cougar.UseQ and Spells.Cougar[_Q]:WillKill(enemy) and Spells.Cougar[_Q]:IsReady() and Spells.Cougar[_Q]:IsValid(enemy)) then
					CastTakedown(enemy)
					return
				elseif (config.Cougar.UseW and Spells.Cougar[_W]:WillKill(enemy) and Spells.Cougar[_W]:IsReady() and Spells.Cougar[_W]:IsValid(enemy)) then
					Spells.Cougar[_W]:CastAt(enemy)
					return
				elseif ((enemy.health <= damage) and not InRange(enemy, Player:GetRange()) and InRange(enemy, HumanRange)) then
					Spells[_R]:Cast()
					return
				end
			else
				if ((enemy.health <= damage) and InRange(enemy, Player:GetRange())) then
					myHero:Attack(enemy)
				end
			end
			if (config.Human.UseQ and Spells.Human[_Q]:IsReady() and Spells.Human[_Q]:WillHit(enemy) and Spells.Human[_Q]:WillKill(enemy)) then
				if (not CougarForm) then
					Spells.Human[_Q]:Cast(enemy)
					return
				elseif (Spells[_R]:IsReady()) then
					Spells[_R]:Cast()
					return
				end
			end
		end
	end

end

---//==================================================\\---
--|| > Draw Callback Handlers							||--
---\===================================================//---

function OnDrawPermaShow(config)

	local color = DrawManager:GetColor(config.PermaShowColor)

	if (config.PermaShow) then
		CustomPermaShow(ScriptName, "", true)
		CustomPermaShow("______________________________", "", true)
		CustomPermaShow("No Mode Active", "", (not Config.Combo.Active and not Config.Harass.Active and not Config.LaneClear.Active and not Config.JungleClear.Active))
		CustomPermaShow("Combo Mode:", "Active", Config.Combo.Active, color, color, nil)
		CustomPermaShow("Harass Mode:", "Active", Config.Harass.Active, color, color, nil)
		CustomPermaShow("Lane Clear Mode:", "Active", Config.LaneClear.Active, color, color, nil)
		CustomPermaShow("Jungle Clear Mode:", "Active", Config.JungleClear.Active, color, color, nil)
		if (Config.Killstealing.Enable or Config.AutoHeal.Enabled) then
			CustomPermaShow("______________________________ ", "", true)
			CustomPermaShow("Killstealing:", "Active", Config.Killstealing.Enable, color, color, nil)
			CustomPermaShow("Auto-Heal:", "Active", Config.AutoHeal.Enabled, color, color, nil)
		else
			CustomPermaShow("______________________________ ", "", false)
			CustomPermaShow("Killstealing:", "Active", false, color, color, nil)
			CustomPermaShow("Auto-Heal:", "Active", false, color, color, nil)
		end
	else
		CustomPermaShow(ScriptName, "", false)
		CustomPermaShow("______________________________", "", false)
		CustomPermaShow("No Mode Active", "", false)
		CustomPermaShow("Combo Mode:", "Active", false, color, color, nil)
		CustomPermaShow("Harass Mode:", "Active", false, color, color, nil)
		CustomPermaShow("Lane Clear Mode:", "Active", false, color, color, nil)
		CustomPermaShow("Jungle Clear Mode:", "Active",false, color, color, nil)
		CustomPermaShow("______________________________ ", "", false)
		CustomPermaShow("Killstealing:", "Active", false, color, color, nil)
		CustomPermaShow("Auto-Heal:", "Active", false, color, color, nil)
	end
	
end

function OnDrawRanges(config)

	if (config.AA) then
		DrawManager:DrawCircleAt(myHero, Player:GetRange(), config.AAColor)
	end
	
	if (config.Human.QRange) then
		DrawManager:DrawCircleAt(myHero, Spells.Human[_Q].Range, config.Human.QRangeColor)
	end

	if (config.Human.QCollision and CurrentTarget and SpellReady.Human[_Q]) then
		local color					= DrawManager:GetColor("Red")
		local castPos, hitchance, _	= Spells.Human[_Q]:GetPrediction(CurrentTarget)
		if (hitchance >= Spells.Human[_Q]:GetHitChance()) then
			color = DrawManager:GetColor("Light Green")
		end
		local position = myHero + (Vector(castPos) - myHero):normalized() * Spells.Human[_Q].Range
		DrawManager:DrawLineBorder3DAt(myHero, position, Spells.Human[_Q].Width, color, 1)
	end
	
	if (config.Cooldowns) then
		local size = 14
		local position = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
		if (CougarForm) then
			if (Spells.Human[_Q]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("Q: Null", size, position.x - 80, position.y, config.CooldownsColor)
			elseif (SpellReady.Human[_Q]) then
				DrawManager:DrawTextWithBorder("Q: Ready", size, position.x - 80, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("Q: {1}", tostring(math.floor(1 + (Cooldowns.Human[_Q] - GetGameTimer())))), size, position.x - 80, position.y, config.CooldownsColor)
			end
			if (Spells.Human[_W]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("W: Null", size, position.x - 30, position.y + 30, config.CooldownsColor)
			elseif (SpellReady.Human[_W]) then
				DrawManager:DrawTextWithBorder("W: Ready", size, position.x - 30, position.y + 30, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("W: {1}", tostring(math.floor(1 + (Cooldowns.Human[_W] - GetGameTimer())))), size, position.x - 30, position.y + 30, config.CooldownsColor)
			end
			if (Spells.Human[_E]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("E: Null", size, position.x, position.y, config.CooldownsColor)
			elseif (SpellReady.Human[_E]) then
				DrawManager:DrawTextWithBorder("E: Ready", size, position.x, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("E: {1}", tostring(math.floor(1 + (Cooldowns.Human[_E] - GetGameTimer())))), size, position.x, position.y, config.CooldownsColor)
			end
		else
			if (Spells.Cougar[_Q]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("Q: Null", size, position.x - 80, position.y, config.CooldownsColor)
			elseif (SpellReady.Cougar[_Q]) then
				DrawManager:DrawTextWithBorder("Q: Ready", size, position.x - 80, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("Q: {1}", tostring(math.floor(1 + (Cooldowns.Cougar[_Q] - GetGameTimer())))), size, position.x - 80, position.y, config.CooldownsColor)
			end
			if (Spells.Cougar[_W]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("W: Null", size, position.x - 30, position.y + 30, config.CooldownsColor)
			elseif (SpellReady.Cougar[_W]) then
				DrawManager:DrawTextWithBorder("W: Ready", size, position.x - 30, position.y + 30, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("W: {1}", tostring(math.floor(1 + (Cooldowns.Cougar[_W] - GetGameTimer())))), size, position.x - 30, position.y + 30, config.CooldownsColor)
			end
			if (Spells.Cougar[_E]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("E: Null", size, position.x, position.y, config.CooldownsColor)
			elseif (SpellReady.Cougar[_E]) then
				DrawManager:DrawTextWithBorder("E: Ready", size, position.x, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("E: {1}", tostring(math.floor(1 + (Cooldowns.Cougar[_E] - GetGameTimer())))), size, position.x, position.y, config.CooldownsColor)
			end
		end
	end
	
end

---//==================================================\\---
--|| > Misc Callback Handlers							||--
---\===================================================//---

function OnUpdateTarget()

	CurrentTarget = Selector:GetTarget(Spells.Human[_Q].Range)
	
	if (SxOrb) then
		SxOrb:ForceTarget(CurrentTarget)
	end

end

function OnProcessCooldowns()

	if (myHero.dead) then
		SpellReady.Human[_Q]	= false
		SpellReady.Human[_W]	= false
		SpellReady.Human[_E]	= false
		SpellReady.Cougar[_Q]	= false
		SpellReady.Cougar[_W]	= false
		SpellReady.Cougar[_E]	= false
		return
	end
	
	if (not CougarForm) then
		SpellReady.Human[_Q]	= Spells.Human[_Q]:IsReady()
		SpellReady.Human[_W]	= Spells.Human[_W]:IsReady()
		SpellReady.Human[_E]	= Spells.Human[_E]:IsReady()
		SpellReady.Cougar[_Q]	= ((Spells.Cougar[_Q]:GetLevel() >= 1) and (Cooldowns.Cougar[_Q] - GetGameTimer() <= 0)) or false
		SpellReady.Cougar[_W]	= ((Spells.Cougar[_W]:GetLevel() >= 1) and (Cooldowns.Cougar[_W] - GetGameTimer() <= 0)) or false
		SpellReady.Cougar[_E]	= ((Spells.Cougar[_E]:GetLevel() >= 1) and (Cooldowns.Cougar[_E] - GetGameTimer() <= 0)) or false
	else
		SpellReady.Cougar[_Q]	= Spells.Cougar[_Q]:IsReady()
		SpellReady.Cougar[_W]	= Spells.Cougar[_W]:IsReady()
		SpellReady.Cougar[_E]	= Spells.Cougar[_E]:IsReady()
		SpellReady.Human[_Q]	= ((Spells.Human[_Q]:GetLevel() >= 1) and (Cooldowns.Human[_Q] - GetGameTimer() <= 0)) or false
		SpellReady.Human[_W]	= ((Spells.Human[_W]:GetLevel() >= 1) and (Cooldowns.Human[_W] - GetGameTimer() <= 0)) or false
		SpellReady.Human[_E]	= ((Spells.Human[_E]:GetLevel() >= 1) and (Cooldowns.Human[_E] - GetGameTimer() <= 0)) or false
	end

end

function OnUpdateCougarForm()

	CougarForm = (Spells.Cougar[_Q]:GetName():Equals("Takedown"))
	
end

function OnUpdateCooldowns(spell)

	if (CougarForm) then
		if (spell.name:Equals("Takedown")) then
			Cooldowns.Cougar[_Q] = GetGameTimer() + GetSpellCooldown(5)
		elseif (spell.name:Equals("Pounce")) then
			Cooldowns.Cougar[_W] = GetGameTimer() + GetSpellCooldown(5)
		elseif (spell.name:Equals("Swipe")) then
			Cooldowns.Cougar[_E] = GetGameTimer() + GetSpellCooldown(5)
		end
	else
		if (spell.name:Equals("JavelinToss")) then
			Cooldowns.Human[_Q] = GetGameTimer() + GetSpellCooldown(6)
		elseif (spell.name:Equals("Bushwhack")) then
			Cooldowns.Human[_W] = GetGameTimer() + GetSpellCooldown(14 - (1 * Player:GetLevel()))
		elseif (spell.name:Equals("PrimalSurge")) then
			Cooldowns.Human[_E] = GetGameTimer() + GetSpellCooldown(12)
		end
	end
	
	if (spell.name:Equals(Spells[_R]:GetName())) then
		DelayAction(function()
			OnUpdateCougarForm()
			OnProcessCooldowns()
		end)
	end
	
end

---//==================================================\\---
--|| > Misc Functions									||--
---\===================================================//---

function CougarDamage(target)

	local damage = 0
	
	if (Cooldowns.Cougar[_Q] < 1) then
		damage = damage + (getDmg("QM", target, myHero) or 0)
	end
	
	if (Cooldowns.Cougar[_W] < 1) then
		damage = damage + (getDmg("WM", target, myHero) or 0)
	end
	
	if (Cooldowns.Cougar[_E] < 1) then
		damage = damage + (getDmg("EM", target, myHero) or 0)
	end
	
	return damage

end

function GetSpellCooldown(cooldown)

	local cdr = Player:GetCooldownReduction()
	return (cooldown - (cooldown * cdr))

end

function CastTakedown(unit)

	Spells.Cougar[_Q]:Cast()
	
	if (SxOrb) then
		SxOrb:ResetAA()
		SxOrb:Attack(unit)
	else
		myHero:Attack(unit)
	end

end

function InPounceRange(unit)

	return (not InRange(unit, Spells.Cougar[_W].Range - Spells.Cougar[_W].Width) and InRange(unit, Spells.Cougar[_W].Range + Spells.Cougar[_W].Width))

end

function InExtendedPounceRange(unit)

	return (TargetHunted(unit) and InRange(unit, ExtendedPounce))

end

function TargetHunted(unit)

	return (UnitHasBuff(unit, "nidaleepassivehunted", true))

end
