--[[
	
	SAC Viktor plugin

	Features
		- Smart combo Q > E > W > R (if killable)
		- KS with E 
		- LastHit with E

	Version 1.0
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]
require "iFoundation_v2"
local SkillQ = Caster(_Q, 600, SPELL_TARGETED) 
local SkillW = Caster(_W, 700, SPELL_CIRCLE)
local SkillE = Caster(_E, 525, SPELL_TARGETED) 
local SkillR = Caster(_R, 700, SPELL_CIRCLE) 

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("ks", "KillSteal with E", SCRIPT_PARAM_ONOFF, true)
end 

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if PluginMenu.ks then
		Combat.KillSteal(SkillE) 
	end 

	-- AutoCarry
	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end
		if SkillE:Ready() then SkillE:Cast(Target) end
		if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() and DamageCalculation.CalculateRealDamage(true, Target) >= Target.health then SkillR:Cast(Target) end 
	end  

	-- LastHit
	if MainMenu.LastHit then
		Combat.LastHit(SkillE)
	end
end 
