--[[
	Auto Carry Plugin - Warwick
		Author: IdylKarthus
		Version: 1.1.2
		Dependency: Sida's Auto Carry
 
	How to install:
		- Make sure you already have AutoCarry installed.
		- Name the script EXACTLY "SidasAutoCarryPlugin - Warwick.lua" without the quotes.
		- Place the plugin in BoL/Scripts/Common folder.
				
	Version History:
		1.1.2 - Current Release
--]]

if myHero.charName ~= "Warwick" then return end
enemyTable = GetEnemyHeroes()



local JungleMobs = {}
local JungleFocusMobs = {}






local JungleMobNames = { 
        ["wolf8.1.1"] = true,
        ["wolf8.1.2"] = true,
        ["YoungLizard7.1.2"] = true,
        ["YoungLizard7.1.3"] = true,
        ["LesserWraith9.1.1"] = true,
        ["LesserWraith9.1.2"] = true,
        ["LesserWraith9.1.4"] = true,
        ["YoungLizard10.1.2"] = true,
        ["YoungLizard10.1.3"] = true,
        ["SmallGolem11.1.1"] = true,
        ["wolf2.1.1"] = true,
        ["wolf2.1.2"] = true,
        ["YoungLizard1.1.2"] = true,
        ["YoungLizard1.1.3"] = true,
        ["LesserWraith3.1.1"] = true,
        ["LesserWraith3.1.2"] = true,
        ["LesserWraith3.1.4"] = true,
        ["YoungLizard4.1.2"] = true,
        ["YoungLizard4.1.3"] = true,
        ["SmallGolem5.1.1"] = true,
}

local FocusJungleNames = {
        ["Dragon6.1.1"] = true,
        ["Worm12.1.1"] = true,
        ["GiantWolf8.1.1"] = true,
        ["AncientGolem7.1.1"] = true,
        ["Wraith9.1.1"] = true,
        ["LizardElder10.1.1"] = true,
        ["Golem11.1.2"] = true,
        ["GiantWolf2.1.1"] = true,
        ["AncientGolem1.1.1"] = true,
        ["Wraith3.1.1"] = true,
        ["LizardElder4.1.1"] = true,
        ["Golem5.1.2"] = true,
		["GreatWraith13.1.1"] = true,
		["GreatWraith14.1.1"] = true,
}



function GetJungleMob()
	if JungleFocusMobs ~= nil and #JungleFocusMobs > 0 then
        for i, Mob in ipairs(JungleFocusMobs) do
                if ValidTarget(Mob, 650) and Mob.name ~= nil then return Mob end
        end
    elseif JungleMobs ~= nil and #JungleMobs > 0 then
        for i, Mob in ipairs(JungleMobs) do
                if ValidTarget(Mob, 650) and Mob.name ~= nil then return Mob end
        end
    else
    	return nil
    end
end

function PluginOnCreateObj(obj)
	if obj ~= nil then
		if FocusJungleNames[obj.name] then
			table.insert(JungleFocusMobs, obj)
		elseif JungleMobNames[obj.name] then
            table.insert(JungleMobs, obj)
		end
	end
	if obj ~= nil and obj.type == "obj_AI_Minion" and obj.name ~= nil then
		if obj.name == "TT_Spiderboss7.1.1" then Vilemaw = obj
		elseif obj.name == "Worm12.1.1" then Nashor = obj
		elseif obj.name == "Dragon6.1.1" then Dragon = obj
		elseif obj.name == "AncientGolem1.1.1" then Golem1 = obj
		elseif obj.name == "AncientGolem7.1.1" then Golem2 = obj
		elseif obj.name == "LizardElder4.1.1" then Lizard1 = obj
		elseif obj.name == "LizardElder10.1.1" then Lizard2 = obj end
	end
end
function PluginOnDeleteObj(obj)
	if obj ~= nil then
		for i, Mob in ipairs(JungleMobs) do
			if obj.name == Mob.name then
				table.remove(JungleMobs, i)
			end
		end
		for i, Mob in ipairs(JungleFocusMobs) do
			if obj.name == Mob.name then
				table.remove(JungleFocusMobs, i)
			end
		end
	end
	if obj ~= nil and obj.name ~= nil then
		if obj.name == "TT_Spiderboss7.1.1" then Vilemaw = nil
		elseif obj.name == "Worm12.1.1" then Nashor = nil
		elseif obj.name == "Dragon6.1.1" then Dragon = nil
		elseif obj.name == "AncientGolem1.1.1" then Golem1 = nil
		elseif obj.name == "AncientGolem7.1.1" then Golem2 = nil
		elseif obj.name == "LizardElder4.1.1" then Lizard1 = nil
		elseif obj.name == "LizardElder10.1.1" then Lizard2 = nil end
	end
end
function checkDeadMonsters()
	if Vilemaw ~= nil then if not Vilemaw.valid or Vilemaw.dead or Vilemaw.health <= 0 then Vilemaw = nil end end
	if Nashor ~= nil then if not Nashor.valid or Nashor.dead or Nashor.health <= 0 then Nashor = nil end end
	if Dragon ~= nil then if not Dragon.valid or Dragon.dead or Dragon.health <= 0 then Dragon = nil end end
	if Golem1 ~= nil then if not Golem1.valid or Golem1.dead or Golem1.health <= 0 then Golem1 = nil end end
	if Golem2 ~= nil then if not Golem2.valid or Golem2.dead or Golem2.health <= 0 then Golem2 = nil end end
	if Lizard1 ~= nil then if not Lizard1.valid or Lizard1.dead or Lizard1.health <= 0 then Lizard1 = nil end end
	if Lizard2 ~= nil then if not Lizard2.valid or Lizard2.dead or Lizard2.health <= 0 then Lizard2 = nil end end
end














function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Checks()
	if Carry.AutoCarry then Combo() end
	if Carry.MixedMode then Haras() end
	if Plugin.junglemode.JungleFarm then JungleClear() end
	if Plugin.ksmode.KSt then KS() end
	if Plugin.autocarry.useRForce then ForceR() end		
end


function ForceR()
	if Target then
		if RREADY and GetDistance(Target) <= rRange then
			CastSpell(_R, Target)
		end
	end
end

function PluginOnDraw()
	text = GetRDamage(myHero)
    	if not myHero.dead then
		DrawText3D(tostring(text), myHero.x, myHero.y, myHero.z, 25,  ARGB(255,255,0,0), true)
		DrawText3D(tostring(turretshots), myHero.x, myHero.y+50, myHero.z, 25,  ARGB(255,255,0,0), true)
		if Plugin.drawings.drawR and RREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, 0x111111)
		end
		if Plugin.drawings.drawQ and QREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x111111)
		end
	end
end

function Combo()
	if Target then
		if QREADY and Plugin.autocarry.useQ and GetDistance(Target) <= qRange then
			CastSpell(_Q, Target)
		end

		if WREADY and Plugin.autocarry.useW and GetDistance(Target) <= aaRange then
			CastSpell(_W)
		end
		if RREADY and Plugin.ultimate.alwaysR and GetDistance(Target) <= rRange then
			for i, enemy in ipairs(enemyTable) do
        			if enemy.charName == Target.charName and Plugin.ultimate["rTar"..i] then
					CastR()
				end
			end
		end
	end
end

function Combo2()
	if Target then
		if QREADY and Plugin.autocarry.useQ and GetDistance(Target) <= qRange then
			CastSpell(_Q, Target)
		end

		if WREADY and Plugin.autocarry.useW and GetDistance(Target) <= aaRange then
			CastSpell(_W)
		end
	end
end

function Haras()
	if Target then

		if QREADY and GetDistance(Target) <= qRange and Plugin.mixedmode.mixedQ then
			CastSpell(_Q, Target)
		end
	end
end


function CastR()
	if Plugin.ultimate.Rmode == 1 and RREADY then
		CastSpell(_R, Target)
	end
	if Plugin.ultimate.Rmode == 2 and RREADY then
		Rdamage = GetRDamage(Target)
		if Target.health <= Rdamage then
			CastSpell(_R, Target)
		end
	end
	if Plugin.ultimate.Rmode == 3 and RREADY then
		Rdamage2 = GetRDamage(Target)
		if Target.health <= Rdamage2 then
			CastSpell(_R, Target)
		end
		Rdamage = GetRDamage(Target) + getDmg("Q",Target,myHero)
		if Target.health <= Rdamage and QREADY then
			CastSpell(_R, Target)
		end
	end

end




function GetRDamage(Targety)
	Rdamage = getDmg("R",Targety,myHero) * 5
	Idamage = 0
	if GetInventoryHaveItem(WitsID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, 210)		
	end
	if GetInventoryHaveItem(BOTRKID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, (Targety.hpPool - (Targety.hpPool*0.77)))		
	end
	if GetInventoryHaveItem(triforceID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, myHero.damage*2)		
	end
	if GetInventoryHaveItem(SheenID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, myHero.damage)		
	end
	if GetInventoryHaveItem(lichID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, 50+(myHero.ap*0.75))		
	end
	if GetInventoryHaveItem(iceID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, myHero.damage*1.25)		
	end
	if GetInventoryHaveItem(statikkid) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, 100)		
	end
	if GetInventoryHaveItem(nashersID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, (15+(myHero.ap*0.15))*5)		
	end
	if GetInventoryHaveItem(feralID) then
		Rdamage = Rdamage + myHero:CalcMagicDamage(Targety, 33*5)		
	end
	TotalDamage = Rdamage + Idamage
	return TotalDamage
end

--[[ menu, checks and other stuff ]]--
function Checks()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
end

function mainLoad()
	qRange = 400
	turretshots = 0
	rRange = 700
	aaRange = 200	
	WitsID = 3091
	BOTRKID = 3153
	SheenID = 3057
	triforceID = 3078
	feralID = 3160
	lichID = 3100
	iceID = 3025
	nashersID = 3115
	statikkid = 3087
	AutoCarry.SkillsCrosshair.range = 1000
	Carry = AutoCarry.MainMenu
	Plugin = AutoCarry.PluginMenu
end

function mainMenu()
	Plugin:addSubMenu("Auto Carry: Settings", "autocarry")
	Plugin.autocarry:addParam("useQ", "Use (Q) in Auto Carry", SCRIPT_PARAM_ONOFF, true)
	Plugin.autocarry:addParam("useW", "Use (W) in Auto Carry", SCRIPT_PARAM_ONOFF, true)
	Plugin.autocarry:addParam("useC2", "Use Combo(without ult)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("x"))
	Plugin.autocarry:addParam("useRForce", "Use (R) Forced on Target", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("T"))


	Plugin:addSubMenu("Mixed Mode: Settings", "mixedmode")
	Plugin.mixedmode:addParam("mixedQ", "Use (Q) in Mixed Mode", SCRIPT_PARAM_ONOFF, true)
	Plugin:addSubMenu("Jungle Mode: Settings", "junglemode")
	Plugin.junglemode:addParam("JungleFarm", "Farm Jungle", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("z"))
	Plugin.junglemode:addParam("JungleQ", "Use (Q) in Jungle Mode", SCRIPT_PARAM_ONOFF, true)
	Plugin.junglemode:addParam("JungleW", "Use (W) in Jungle Mode", SCRIPT_PARAM_ONOFF, true)
	
	Plugin:addSubMenu("Ultimate: Settings", "ultimate")
	Plugin.ultimate:addParam("alwaysR", "Let script use (R) in Combo", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("9"))
	Plugin.ultimate:addParam("TurretR", "R Under Turrets", SCRIPT_PARAM_ONOFF, true)
	Plugin.ultimate:addParam("Rmode", "Select R mode", SCRIPT_PARAM_SLICE, 0, 1, 3, 0)
	Plugin.ultimate:addParam("Rmode1", "Ultimate Modes (1) - always ult when in range", SCRIPT_PARAM_INFO, "")
	Plugin.ultimate:addParam("Rmode2", "Ultimate Modes (2) - always ult When R kills", SCRIPT_PARAM_INFO, "")
	Plugin.ultimate:addParam("Rmode3", "Ultimate Modes (3) - always ult when R+Q Kills", SCRIPT_PARAM_INFO, "")

	Plugin:addSubMenu("KS: Settings", "ksmode")
	Plugin.ksmode:addParam("KSt", "KS Toggle ON/OFF", SCRIPT_PARAM_ONOFF, true)
	Plugin.ksmode:addParam("KSq", "Use (Q) to KS", SCRIPT_PARAM_ONOFF, true)
	Plugin.ksmode:addParam("KSr", "Use (R) in to KS", SCRIPT_PARAM_ONOFF, true)

	Plugin.ultimate:addParam("Rmode3", "", SCRIPT_PARAM_INFO, "")

	
	Plugin:addSubMenu("Draw: Settings", "drawings")
	Plugin.drawings:addParam("disableAll", "Disable all drawings", SCRIPT_PARAM_ONOFF, false)
	Plugin.drawings:addParam("drawQ", "Draw (Q)", SCRIPT_PARAM_ONOFF, true)
	Plugin.drawings:addParam("drawR", "Draw (R)", SCRIPT_PARAM_ONOFF, true)
	Plugin.ultimate:addParam("rTarText", "Select Champions to ult", SCRIPT_PARAM_INFO, "")
        for i, enemy in ipairs(enemyTable) do
               	Plugin.ultimate:addParam("rTar"..i, "   "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
        end
end

function JungleClear()
	TargetJungleMob = GetJungleMob()
	if TargetJungleMob ~= nil and ValidTarget(TargetJungleMob, 800) and GetDistance(TargetJungleMob, myHero) < 450 then
			BlockSac()
			if QREADY and GetDistance(TargetJungleMob, myHero) < qRange then
				CastSpell(_Q, TargetJungleMob)
			end
			if WREADY then
				CastSpell(_W)
			end
	else
		UnblockSac()
	end
end

function KS()
        for i=1, heroManager.iCount do
        local enemy = heroManager:GetHero(i)
                if ValidTarget(enemy) then
			Rdamage = GetRDamage(enemy)
			if enemy.health < getDmg("Q",enemy,myHero) - 30 and QREADY and Plugin.ksmode.KSq and GetDistance(enemy) < qRange then
				CastSpell(_Q, enemy)			
			end
			if enemy.health < Rdamage and READY and Plugin.ksmode.KSr and GetDistance(enemy) < rRange then
				CastSpell(_R, enemy)
			end
			if enemy.health < (Rdamage + getDmg("Q",enemy,myHero)) and READY and QREADY and Plugin.ksmode.KSr and Plugin.ksmode.KSq and GetDistance(enemy) < rRange then
				CastSpell(_R, enemy)
			end
		end
	end	
end

function BlockSac()
	if AutoCarry.MainMenu ~= nil then
		if AutoCarry.CanAttack ~= nil then
			_G.AutoCarry.CanMove = false
		end
	elseif AutoCarry.Keys ~= nil then
		if AutoCarry.MyHero ~= nil then
			_G.AutoCarry.MyHero:MovementEnabled(false)
		end
	end
end

function UnblockSac()
	if AutoCarry.MainMenu ~= nil then
		if AutoCarry.CanAttack ~= nil then
			_G.AutoCarry.CanMove = true
			_G.AutoCarry.CanAttack = true
		end
	elseif AutoCarry.Keys ~= nil then
		if AutoCarry.MyHero ~= nil then
			_G.AutoCarry.MyHero:MovementEnabled(true)
			_G.AutoCarry.MyHero:AttacksEnabled(true)
		end
	end
end
		
		
function ASLoadMinions()
	for i = 1, objManager.maxObjects do
		local obj = objManager:getObject(i)
		if obj ~= nil and obj.type == "obj_AI_Minion" and obj.name ~= nil then
			if obj.name == "TT_Spiderboss7.1.1" then Vilemaw = obj
			elseif obj.name == "Worm12.1.1" then Nashor = obj
			elseif obj.name == "Dragon6.1.1" then Dragon = obj
			elseif obj.name == "AncientGolem1.1.1" then Golem1 = obj
			elseif obj.name == "AncientGolem7.1.1" then Golem2 = obj
			elseif obj.name == "LizardElder4.1.1" then Lizard1 = obj
			elseif obj.name == "LizardElder10.1.1" then Lizard2 = obj end
		end
	end
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
			if FocusJungleNames[object.name] then
				table.insert(JungleFocusMobs, object)
			elseif JungleMobNames[object.name] then
				table.insert(JungleMobs, object)
			end
		end
	end
end