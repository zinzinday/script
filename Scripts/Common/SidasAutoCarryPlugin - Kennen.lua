------------------------########################################-------------------------------
------------------------##								Kennen	  					##-------------------------------
------------------------##					   Lightning Ninja  			##-------------------------------
------------------------########################################-------------------------------
if myHero.charName ~= "Kennen" then return end

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 1150
	--> Main Load
	mainLoad()
	--> Main Menu
	mainMenu()
end

function PluginOnTick()
	Checks()
	if Target then
		if (AutoCarry.MainMenu.AutoCarry or AutoCarry.MainMenu.MixedMode) then
			if QREADY and Menu.useQ and not Col(SkillQ, myHero, Target) then Cast(SkillQ, Target) end
			if WREADY and Menu.useW and GetDistance(Target) < wRange and (enemyhaveMOS1 or enemyhaveMOS2) then 
				CastSpell(_W) 
			end
			if RREADY and Menu.useR and CountEnemyHeroInRange(rRange) >= Menu.rCount then 
				CastSpell(_R) 
			end
		end
		if WREADY and Menu.autoW and GetDistance(Target) < wRange and enemyhaveMOS2 then
			CastSpell(_W) 
		end
	end 
end

function PluginOnDraw()
	--> Ranges
	if not Menu.drawMaster and not myHero.dead then
		if QREADY and Menu.drawQ then 
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x00FFFF)
		end
		if RREADY and Menu.drawR then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, 0x00FF00)
		end
	end
end

--> Main Load
function mainLoad()
	MOS1Time, MOS2Time = 0, 0
	enemyhaveMOS1, enemyhaveMOS2 = false, false
	qRange, wRange, rRange = 1050, 900, 550
	QREADY, WREADY, RREADY = false, false, false
	SkillQ = {spellKey = _Q, range = qRange, speed = 1.65, delay = 190, width = 75}
	Cast = AutoCarry.CastSkillshot
	Menu = AutoCarry.PluginMenu
	Col = AutoCarry.GetCollision
end

--> Main Menu
function mainMenu()
	Menu:addParam("sep", "-- Cast Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("autoW", "Electrical Surge - Auto Stun", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("rCount", "Slicing Maelstrom - Min Enemies: ", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
	Menu:addParam("sep1", "-- Full Combo Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("useQ", "Use Thundering Shuriken", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("useW", "Use Electrical Surge", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("useR", "Use Slicing Maelstrom", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("sep3", "-- Draw Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("drawMaster", "Disable Draw", SCRIPT_PARAM_ONOFF, false)
	Menu:addParam("drawQ", "Draw - Thundering Shuriken", SCRIPT_PARAM_ONOFF, false)
	Menu:addParam("drawR", "Draw - Slicing Maelstrom", SCRIPT_PARAM_ONOFF, false)
end


function PluginOnCreateObj(object)
	if object and object.name == "kennen_mos1.troy" and Target and GetDistance(Target, object) <= 70 then 
		enemyhaveMOS1 = true 
		MOS1Time = GetTickCount() 
	end
	if object and object.name == "kennen_mos2.troy" and Target and GetDistance(Target, object) <= 70 then 
		enemyhaveMOS2 = true 
		MOS2Time = GetTickCount() 
	end
end

function PluginOnDeleteObj(object)
	if object and object.name == "kennen_mos1.troy" then enemyhaveMOS1 = false end
	if object and object.name == "kennen_mos2.troy" then enemyhaveMOS2 = false end
end

--> Checks
function Checks()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	if GetTickCount() - MOS1Time > 8000 then
		enemyhaveMOS1 = false
	end
	if GetTickCount() - MOS2Time > 8000 then
		enemyhaveMOS2 = false
	end
end
