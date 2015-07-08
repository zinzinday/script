if myHero.charName ~= "Fiora" then return end

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	
	--[[	Auto Q	]]--
	if Menu.autoks and QREADY then
		for i = 1, heroManager.iCount, 1 do
			local qTarget = heroManager:getHero(i)
			if ValidTarget(qTarget, qRange) then
				if Menu.doubleLunge then dmgQ = getDmg("Q", qTarget, myHero)*2
					else dmgQ = getDmg("Q", qTarget, myHero)
				end
				if qTarget.health <= dmgQ then
					CastSpell(_Q, qTarget)
				end
			end
		end
	end
	
	--[[	Basic Combo	]]--
	if Target and Menu2.AutoCarry then
		if QREADY and GetDistance(Target) <= qRange then
			QDMG = getDmg("Q", Target, myHero)
			if (GetDistance(Target) >= Menu.qBuffer and os.clock() - LastQ > Menu.waitDelay/100) or os.clock() - LastQ > 3.5 then
				CastSpell(_E)
				CastSpell(_Q, Target)
			elseif Target.health < QDMG then
				CastSpell(_Q, Target)
			end
		end
		if RREADY and Menu.useR then
			if CountEnemyHeroInRange(600, Target) > 1 then RDMG = getDmg("R", Target, 
myHero, 3) 
				else RDMG = getDmg("R", Target, myHero, 1) 
			end
			if RDMG >= Target.health and GetDistance(Target) <= rRange then
				if (QREADY and Target.health > getDmg("Q", Target, myHero)*2) or not QREADY then
					CastSpell(_R, Target)
				end
			end
		end
	end
end

function OnAttacked()
	if Target and Menu2.AutoCarry then
		if EREADY and GetDistance(Target) <= eBuffer then
			CastSpell(_E)
		end
	end
end

function PluginOnDraw()	
	if Menu.drawcirclesSelf and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x00FF00)
	end
end

--[[	Parry	]]--
function PluginOnProcessSpell(unit, spell)
	if unit.isMe and spell.name == ("FioraQ")  then
		LastQ = os.clock()
	end
	
	if Menu.autoParry and WREADY then
		if unit and unit.type == myHero.type and spell.target == myHero then
			for i=1, #Abilities do
				if (spell.name == Abilities[i] or spell.name:find(Abilities[i]) ~= 
nil) then
					if getDmg("AD", myHero, unit) >= (myHero.maxHealth*0.06) or 
getDmg("AD", myHero, unit) >= (myHero.health*0.04) then 
						CastSpell(_W)
					elseif Menu.alwaysParry then
						CastSpell(_W)
					end
				end
			end
		end
	end
end

Abilities = {
"GarenSlash2", "SiphoningStrikeAttack", "LeonaShieldOfDaybreakAttack", "RenektonExecute", 
"ShyvanaDoubleAttackHit", "DariusNoxianTacticsONHAttack", "TalonNoxianDiplomacyAttack", "Parley", "MissFortuneRicochetShot", "RicochetAttack", "jaxrelentlessattack", "Attack"
}

function mainLoad()
	AutoCarry.SkillsCrosshair.range = 700
	Menu = AutoCarry.PluginMenu
	Menu2 = AutoCarry.MainMenu
	--[[	Ranges	]]--
	qRange, rRange, eBuffer = 600, 400, 300
	--[[	Other	]]--
	LastQ = 0
	QREADY, WREADY, EREADY, RREADY  = false, false, false, false
end

function mainMenu()
	Menu:addParam("sep", "-- Cast Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("autoParry", "Auto Parry", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("autoks", "Auto Kill with Lunge", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("doubleLunge", "Use Double Lunge to Kill", SCRIPT_PARAM_ONOFF, false)
	Menu:addParam("useR", "Use - Blade Waltz", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("alwaysParry", "Parry All Attacks", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("sep1", "-- Abilty Settings --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("qBuffer", "Min Q distance",SCRIPT_PARAM_SLICE, 350, 0, 600, 0)
	Menu:addParam("waitDelay", "Delay before 2nd Q(ms)",SCRIPT_PARAM_SLICE, 500, 0, 800, 0)
	Menu:addParam("sep2", "-- Draw Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("drawcirclesSelf", "Draw - Lunge", SCRIPT_PARAM_ONOFF, false)
end

--UPDATEURL=
--HASH=4544A0D3C32F09B8F052D1D8258CD967
