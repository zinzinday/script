--[[

---//==================================================\\---
--|| > About Script										||--
---\===================================================//---

	Script:			Pantheon - The God of War
	Version:		1.00
	Script Date:	2015-02-04
	Author:			Devn

---//==================================================\\---
--|| > Changelog										||--
---\===================================================//---

	Version 1.00:
		- Initial script release.

--]]

---//==================================================\\---
--|| > User Variables									||--
---\===================================================//---

_G.PantehonGod_AutoUpdate		= true
_G.PantheonGod_EnableDebugMode	= true

---//==================================================\\---
--|| > Initialization									||--
---\===================================================//---

-- Champion check.
if (myHero.charName ~= "Pantheon") then return end

-- Load GodLib.
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQcLAAAABgBAAEFAAAAWQAAAQYAAAKUAAADlQAAAJYEAAGXBAACAAYACnUGAAB8AgAADAAAABAkAAABMSUJfUEFUSAAECwAAAEdvZExpYi5sdWEABEsAAABodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vRGV2bkJvTC9TY3JpcHRzL21hc3Rlci9Hb2RMaWIvR29kTGliLmx1YQAEAAAAAwAAAAMAAAABAAUMAAAARgBAAEdAwACAAAAAwYAAAF2AgAGMwMAAAQEBAJ2AgAHMQMEA3UAAAZ8AAAEfAIAABgAAAAQDAAAAaW8ABAUAAABvcGVuAAQCAAAAcgAEBQAAAHJlYWQABAUAAAAqYWxsAAQGAAAAY2xvc2UAAAAAAAEAAAAAABAAAABAb2JmdXNjYXRlZC5sdWEADAAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAY2IAAAAAAAwAAAADAAAAZGIABQAAAAwAAAADAAAAX2MACAAAAAwAAAABAAAABQAAAF9FTlYAAwAAAAQAAAABAAYKAAAAQAAAAIEAAADGQEAAx4DAAQHBAABBAQEA3YCAAVbAgABfAAABHwCAAAUAAAAEBwAAAD9yYW5kPQAEBQAAAG1hdGgABAcAAAByYW5kb20AAwAAAAAAAPA/AwAAAAAAiMNAAAAAAAEAAAAAABAAAABAb2JmdXNjYXRlZC5sdWEACgAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAABAAAAAwAAAGNiAAAAAAAKAAAAAQAAAAUAAABfRU5WAAQAAAAGAAAAAQAFBwAAAEYAQACBQAAAwAAAAAGBAACWAAEBXUAAAR8AgAADAAAABAoAAABQcmludENoYXQABDwAAAA8Zm9udCBjb2xvcj0iI2Y3ODFiZSI+R29kTGliOjwvZm9udD4gPGZvbnQgY29sb3I9IiNiZWY3ODEiPgAECAAAADwvZm9udD4AAAAAAAEAAAAAABAAAABAb2JmdXNjYXRlZC5sdWEABwAAAAUAAAAFAAAABQAAAAYAAAAFAAAABQAAAAYAAAABAAAAAwAAAGNiAAAAAAAHAAAAAQAAAAUAAABfRU5WAAcAAAAMAAAAAAAGHAAAAAYAQABFAIAAHYAAARsAAAAXwAKABkBAAEaAQACFAAABxQCAAJ2AAAHEAAAAAcEAAEUBAABdAIACHYAAAB1AgAAXQAKABQCAAUEAAQAdQAABBkBBAEUAAAKFAIACXYAAAYUAgADlAAAAHUAAAh8AgAAGAAAABAoAAABGaWxlRXhpc3QABAcAAABhc3NlcnQABAUAAABsb2FkAAQCAAAAdAAEHAAAAERvd25sb2FkaW5nLCBwbGVhc2Ugd2FpdC4uLgAEDQAAAERvd25sb2FkRmlsZQABAAAACwAAAAwAAAAAAAIEAAAABQAAAEEAAAAdQAABHwCAAAEAAAAEOwAAAERvd25sb2FkZWQgc3VjY2Vzc2Z1bGx5ISBQbGVhc2UgcmVsb2FkIHNjcmlwdCAoZG91YmxlIEY5KS4AAAAAAAEAAAAAAxAAAABAb2JmdXNjYXRlZC5sdWEABAAAAAwAAAAMAAAADAAAAAwAAAAAAAAAAQAAAAMAAABhYgAGAAAAAAABAAECAQQBAwEBEAAAAEBvYmZ1c2NhdGVkLmx1YQAcAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAkAAAAJAAAACQAAAAgAAAAIAAAACAAAAAkAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAACwAAAAwAAAALAAAADAAAAAAAAAAGAAAABQAAAF9FTlYAAwAAAGJhAAMAAABkYQADAAAAYWIAAwAAAF9iAAMAAABjYQABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAsAAAABAAAAAQAAAAEAAAACAAAAAwAAAAQAAAAGAAAADAAAAAwAAAAMAAAADAAAAAYAAAADAAAAYmEAAwAAAAsAAAADAAAAY2EABAAAAAsAAAADAAAAZGEABQAAAAsAAAADAAAAX2IABgAAAAsAAAADAAAAYWIABwAAAAsAAAADAAAAYmIACAAAAAsAAAABAAAABQAAAF9FTlYA"), nil, "bt", _ENV))()
if (not GodLib) then return end

-- Update variables.
GodLib.Update.Host				= "raw.github.com"
GodLib.Update.Path				= "DevnBoL/Scripts/master/Pantheon"
GodLib.Update.Version			= "Current.version"
GodLib.Update.Script			= "Pantheon - The God of War.lua"

-- Script variables.
GodLib.Script.Variables			= "PantheonGod"
GodLib.Script.Name 				= "Pantheon - The God of War"
GodLib.Script.Version			= "1.00"
GodLib.Script.Date				= "2015-02-04"

-- Required libraries.
GodLib.RequiredLibraries		= {
	["SxOrbWalk"]				= "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
}

---//==================================================\\---
--|| > Callback Handlers								||--
---\===================================================//---

Callbacks:Bind("Initialize", function()

	SetupVariables()
	SetupDebugger()
	SetupConfig()
	
	PrintLocal(Format("Script v{1} loaded successfully!", ScriptVersion))

	ScriptManager:GetAsyncWebResult(GodLib.Update.Host, Format("/{1}/{2}", GodLib.Update.Path, "Message.txt"), function(message)
		PrintLocal(message)
	end)

end)

Callbacks:Bind("Draw", function()

	if (not myHero.dead) then
		OnDrawRanges(Config.Drawing)
	end

end)

Callbacks:Bind("InterruptableSpell", function(unit, data)

	if (ValidTarget(unit) and Spells[_W]:IsReady() and Config.Interrupter.UseW and Spells[_W]:InRange(unit) and (data.DangerLevel >= Config.Interrupter.MinDangerLevelW)) then
		Spells[_W]:Cast()
	end

end)

Callbacks:Bind("Animation", function(unit, name)

	if (unit.isMe) then
		if (table.contains(Animations, name)) then
			IsBusy = true
			Player:DisableAttacks()
			Player:DisableMovement()
		else
			IsBusy = false
			Player:EnableAttacks()
			Player:EnableMovement()
		end
	end

end)

---//==================================================\\---
--|| > Script Setup										||--
---\===================================================//---

function SetupVariables()
	
	Spells			= {
		[_Q]		= SpellData(_Q, 600, "Spear Range"),
		[_W]		= SpellData(_W, 600, "Aegis of Zeonia"),
		[_E]		= SpellData(_E, 600, "Heartseeker Strike"),
		[_R]		= SpellData(_R, 5500, "Grand Skyfall"),
	}
	
	Animations		= { "Spell3", "Ult_A", "Ult_B", "Ult_C", "Ult_D", "Ult_E" }
	
	CurrentTarget	= nil
	IsBusy			= false
	
	Config			= MenuConfig(GodLib.Script.Variables, ScriptName)
	Selector		= SimpleTS(STS_LESS_CAST_PHYSICAL)
	Interrupter		= Interrupter()
	
	TickManager:Add("Combo", "Combo Mode", 500, function() OnComboMode(Config.Combo) end)
	TickManager:Add("Harass", "Harass Mode", 500, function() OnHarassMode(Config.Harass) end)
	TickManager:Add("Killsteal", "Killsteal", 500, function() OnKillsteal(Config.Killstealing) end)
	TickManager:Add("UpdateTarget", "Update Current Target", 500, OnUpdateTarget)
	
end

function SetupDebugger()

	if (not EnableDebugMode) then
		return
	end
	
	Debugger = VisualDebugger()

	Debugger:Group("Spells", "Hero Spells")
	Debugger:Variable("Spells", Format("{1} (Q)", Spells[_Q].Name), function() return Spells[_Q]:IsReady() end)
	Debugger:Variable("Spells", Format("{1} (W)", Spells[_W].Name), function() return Spells[_W]:IsReady() end)
	Debugger:Variable("Spells", Format("{1} (E)", Spells[_E].Name), function() return Spells[_E]:IsReady() end)
	Debugger:Variable("Spells", Format("{1} (R)", Spells[_R].Name), function() return Spells[_R]:IsReady() end)

	Debugger:Group("Misc", "Misc Variables")
	Debugger:Variable("Misc", "Current Target", function() return (CurrentTarget and CurrentTarget.charName or "No target") end)
	Debugger:Variable("Misc", "Is Attacking", function() return Player.IsAttacking end)
	Debugger:Variable("Misc", "Is Evading", function() return IsEvading() end)
	Debugger:Variable("Misc", "Is Busy", function() return IsBusy end)
	
end

function SetupConfig()

	Config:Menu("Orbwalker", "Settings: Orbwalker")
	Config:Menu("Selector", "Settings: Target Selector")
	Config:Menu("Combo", "Settings: Combo Mode")
	Config:Menu("Harass", "Settings: Harass Mode")
	Config:Menu("Killstealing", "Settings: Killstealing")
	Config:Menu("Interrupter", "Settings: Auto-Interrupter")
	Config:Menu("Drawing", "Settings: Drawing")
	Config:Menu("TickManager", "Settings: Tick Manager")
	Config:Separator()
	Config:Info("Version", ScriptVersion)
	Config:Info("Build Date", ScriptDate)
	Config:Info("Author", "Devn")
	
	SxOrb:LoadToMenu(Config.Orbwalker)
	Selector:LoadToMenu(Config.Selector)
	SetupConfig_Combo(Config.Combo)
	SetupConfig_Harass(Config.Harass)
	SetupConfig_Killstealing(Config.Killstealing)
	SetupConfig_Interrupter(Config.Interrupter)
	SetupConfig_Drawing(Config.Drawing)
	TickManager:LoadToMenu(Config.TickManager)
	
	if (EnableDebugMode) then
		Config:Menu("Debugger", "Settings: Visual Debugger")
		Debugger:LoadToMenu(Config.Debugger)
	end

end

---//==================================================\\---
--|| > Config Setup										||--
---\===================================================//---

function SetupConfig_Combo(config)

	config:Menu("Q", Format("Spell: {1} (Q)", Spells[_Q].Name))
	config:Menu("W", Format("Spell: {1} (W)", Spells[_W].Name))
	config:Menu("E", Format("Spell: {1} (E)", Spells[_E].Name))
	
	config.Q:Toggle("Use", "Use Spell", true)
	config.Q:Separator()
	config.Q:Slider("MinMana", "Minimum Mana Percent", 0, 0, 100)
	
	config.W:Toggle("Use", "Use Spell", true)
	config.W:Separator()
	config.W:Slider("MinMana", "Minimum Mana Percent", 15, 0, 100)
	config.W:Separator()
	config.W:Slider("MinRange", "Minimum Range", 0, 0, Spells[_W].Range)
	config.W:Slider("MaxRange", "Maximum Range", Spells[_W].Range, 0, Spells[_W].Range)
	
	config.E:Toggle("Use", "Use Spell", true)
	config.E:Separator()
	config.E:Slider("MinMana", "Minimum Mana Percent", 15, 0, 100)
	config.E:Separator()
	config.E:Slider("MinRange", "Minimum Range", 0, 0, 100)
	config.E:Slider("MaxRange", "Maximum Range", Spells[_E].Range, 0, Spells[_E].Range)
	
	config:KeyBinding("Active", "Combo Mode Active", false, 32)
	
end

function SetupConfig_Harass(config)

	config:Menu("Q", Format("Spell: {1} (Q)", Spells[_Q].Name))
	config:Menu("W", Format("Spell: {1} (W)", Spells[_W].Name))
	config:Menu("E", Format("Spell: {1} (E)", Spells[_E].Name))
	
	config.Q:Toggle("Use", "Use Spell", true)
	config.Q:Separator()
	config.Q:Slider("MinMana", "Minimum Mana Percent", 35, 0, 100)
	
	config.W:Toggle("Use", "Use Spell", false)
	config.W:Separator()
	config.W:Slider("MinMana", "Minimum Mana Percent", 50, 0, 100)
	config.W:Separator()
	config.W:Slider("MinRange", "Minimum Range", 0, 0, Spells[_W].Range)
	config.W:Slider("MaxRange", "Maximum Range", Spells[_W].Range, 0, Spells[_W].Range)
	
	config.E:Toggle("Use", "Use Spell", false)
	config.E:Separator()
	config.E:Slider("MinMana", "Minimum Mana Percent", 1505, 0, 100)
	config.E:Separator()
	config.E:Slider("MinRange", "Minimum Range", 0, 0, 100)
	config.E:Slider("MaxRange", "Maximum Range", 500, 0, Spells[_E].Range)
		
	config:KeyBinding("Active", "Harass Mode Active", false, "T")

end

function SetupConfig_Killstealing(config)

	config:Toggle("Enable", "Enable Killstealing", true)
	config:Separator()
	config:Toggle("UseQ", Format("Use {1} (Q)", Spells[_Q].Name), true)
	config:Toggle("UseW", Format("Use {1} (W)", Spells[_W].Name), true)

end

function SetupConfig_Interrupter(config)

	Interrupter:LoadToMenu(config)
	config:Separator()
	config:Toggle("UseW", Format("Use {1} (W)", Spells[_W].Name), true)
	config:Slider("MinDangerLevelW", "Minimum Danger Level", 1, 1, 5)

end

function SetupConfig_Drawing(config)

	DrawManager:LoadToMenu(config)
	config:Separator()
	config:Toggle("AA", "Draw Auto-Attack Range", true)
	config:DropDown("AAColor", "Range Color", 1, DrawManager.Colors)
	config:Separator()
	config:Toggle("Q", Format("Draw {1} (Q) Range", Spells[_Q].Name), true)
	config:DropDown("QColor", "Range Color", 1, DrawManager.Colors)
	config:Separator()
	config:Toggle("R", Format("Draw {1} (R) Range", Spells[_R].Name), true)
	config:DropDown("RColor", "Range Color", 1, DrawManager.Colors)
	config:Separator()
	config:Toggle("RMinimap", Format("Draw {1} (R) Range (Minimap)", Spells[_R].Name), true)
	config:DropDown("RColorMinimap", "Range Color", 1, DrawManager.Colors)
	
end

---//==================================================\\---
--|| > Main Callback Handlers							||--
---\===================================================//---

function OnComboMode(config)

	if (myHero.dead or IsBusy or not config.Active or not IsValid(CurrentTarget)) then
		return
	end

	if (Spells[_Q]:IsReady() and config.Q.Use and HaveEnoughMana(config.Q.MinMana)) then
		Spells[_Q]:Cast(CurrentTarget)
	end
	
	if (Spells[_W]:IsReady()) then
		if (config.W.Use and HaveEnoughMana(config.W.MinMana) and not InRange(CurrentTarget, config.W.MinRange) and InRange(CurrentTarget, config.W.MaxRange)) then
			Spells[_W]:Cast(CurrentTarget)
		end
	elseif (Spells[_E]:IsReady()) then
		if (config.E.Use and HaveEnoughMana(config.E.MinMana) and not InRange(CurrentTarget, config.E.MinRange) and InRange(CurrentTarget, config.E.MaxRange)) then
			Spells[_E]:CastAt(CurrentTarget)
		end
	end
	
end

function OnHarassMode(config)

	if (myHero.dead or IsBusy or not config.Active or not IsValid(CurrentTarget)) then
		return
	end

	if (Spells[_Q]:IsReady() and config.Q.Use and HaveEnoughMana(config.Q.MinMana)) then
		Spells[_Q]:Cast(CurrentTarget)
	end
	
	if (Spells[_W]:IsReady()) then
		if (config.W.Use and HaveEnoughMana(config.W.MinMana) and not InRange(CurrentTarget, config.W.MinRange) and InRange(CurrentTarget, config.W.MaxRange)) then
			Spells[_W]:Cast(CurrentTarget)
		end
	elseif (Spells[_E]:IsReady()) then
		if (config.E.Use and HaveEnoughMana(config.E.MinMana) and not InRange(CurrentTarget, config.E.MinRange) and InRange(CurrentTarget, config.E.MaxRange)) then
			Spells[_E]:CastAt(CurrentTarget)
		end
	end
	
end

function OnKillsteal(config)

	if (not config.Enable) then
		return
	end
	
	for _, enemy in ipairs(GetEnemiesInRange(Spells[_Q]:GetRange())) do
		if (IsValid(enemy)) then
			if (Spells[_Q]:WillKill(enemy)) then
				Spells[_Q]:Cast(enemy)
			elseif (Spells[_W]:WillKill(enemy)) then
				Spells[_W]:Cast(enemy)
			end
		end
	end

end

function OnDrawRanges(config)

	if (config.AA) then
		DrawManager:DrawCircleAt(myHero, SxOrb:GetMyRange(), config.AAColor)
	end

	if (config.Q) then
		DrawManager:DrawCircleAt(myHero, Spells[_Q].Range, config.QColor)
	end

	if (Spells[_R]:IsReady()) then
		if (config.R) then
			DrawManager:DrawCircleAt(myHero, Spells[_R].Range, config.RColor)
		end
		if (config.RMinimap) then
			DrawManager:DrawCircleMinimapAt(myHero, Spells[_R].Range, config.RColorMinimap)
		end
	end
	
end

---//==================================================\\---
--|| > Misc Callback Handlers							||--
---\===================================================//---

function OnUpdateTarget()

	CurrentTarget = Selector:GetTarget(Spells[_Q].Range)

end
