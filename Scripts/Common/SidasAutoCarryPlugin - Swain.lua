require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Swain" then return end 

	local SkillQ = Caster(_Q, 625, SPELL_TARGETED)
	local SkillW = Caster(_W, 900, SPELL_CIRCLE, math.huge, 0.700, 270, true)
	local SkillE = Caster(_E, 625, SPELL_TARGETED) 
	local SkillR = Caster(_R, 700, SPELL_SELF)

	local combo = ComboLibrary()

	local rActive = false 
	local lastMana = 0

	local Menu = nil 
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(900)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) 
				return not rActive and ValidTarget(Target, SkillR.range) and ((Menu.rKillable and ComboLibrary.KillableCast(Target, "R")) or not Menu.rKillable)
			end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if rActive and Menu.rMonitor then
			MonitorUltimate()
		end 

		if rActive and Menu.rMonitor and not ValidTarget(Target, SkillR.range) then
			DisableUltimate()
		end 

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	function Plugin:OnCreateObj(obj) 
		if obj and obj.name:find("swain_demonForm") then
			rActive = true 
			lastMana = myHero.mana 
		end 
	end 

	function Plugin:OnDeleteObj(obj) 
		if obj and obj.name:find("swain_demonForm") then
			rActive = false 
		end 
	end 

	function MonitorUltimate() 
		local maxMana = myHero.maxMana * (Menu.rMana / 100)
		if (lastMana - myHero.mana) > maxMana then 
			DisableUltimate()
		end
	end

	function DisableUltimate()
		if SkillR:Ready() and rActive then
			CastSpell(_R)
		end
	end

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Swain") 
	Menu:addParam("rMonitor", "Monitor R mana", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("rKillable", "Only use R when enemy can be killed", SCRIPT_PARAM_ONOFF, false)
	Menu:addParam("rMana", "Maximum R Percentage",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
-- }


--UPDATEURL=
--HASH=F29728AC86C134D0CA57596F7C856925
