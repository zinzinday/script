-- The Early Bird Guts The Worm - Swain
-- by Runeterra
--
-- > Changelog:
-- > v1.00 - First release.
-- > v1.01 - Forgot to enable some menu options D:
-- > v1.02 - :x

if myHero.charName ~= "Swain" then return end

require "VPrediction"

function OnLoad()
	Vars()
	Menu()
	PrintChat("The Early Bird Guts The Worm - Swain "..ver.." Loaded.")
end

function OnUnload()
	PrintChat("The Early Bird Guts The Worm - Swain "..ver.." Unloaded.")
end

function OnTick()
	Checks()
	Consumables()
	UltManager()

	if Menu.settings.misc.miscLVL then autoLevelSetSequence(levelSequence) end
end

function Vars()
	ver = "v1.02"

	QRange, WRange, ERange, RRange		= 625, 900, 625, 700
	QSpeed, WSpeed, ESpeed, RSpeed		= 0, math.huge, 0, 0
	QDelay, WDelay, EDelay, RDelay		= 0, .85, 0, 0
	QWidth, WWidth, EWidth, RWidth 		= 0, 250, 0, 0
	QRadius, WRadius, ERadius, RRadius	= 0, 125, 0, 0
	QSName, WSName, ESName, RSName		= "Decrepify", "Nevermove", "Torment", "Ravenous Flock"
	QReady, WReady, EReady, RReady		= false, false, false, false
	XRange								= 900

	VP = VPrediction()

	levelSequence = {2,1,3,3,3,4,3,1,3,1,4,1,1,2,2,4,2,2}

	UltActive = false

	enemyMinions = minionManager(MINION_ENEMY, ERange, player, MINION_SORT_HEALTH_ASC)
end

function Menu()
	Menu = scriptConfig("The Early Bird Guts The Worm - Swain", "Swain")

	Menu:addSubMenu("Hotkeys", "hotkeys")
		Menu.hotkeys:addParam("cKey", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Menu.hotkeys:addParam("hKey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		Menu.hotkeys:permaShow("cKey")
		Menu.hotkeys:permaShow("hKey")

	Menu:addSubMenu("Settings", "settings")

	Menu.settings:addSubMenu("Combo", "combo")
		Menu.settings.combo:addParam("comboQ", "Use [Q] "..QSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.combo:addParam("comboW", "Use [W] "..WSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.combo:addParam("comboE", "Use [E] "..ESName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.combo:addParam("comboR", "Use [R] "..RSName.."", SCRIPT_PARAM_ONOFF, true)

	Menu.settings:addSubMenu("Harass", "harass")
		Menu.settings.harass:addParam("harassQ", "Use [Q] "..QSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.harass:addParam("harassW", "Use [W] "..WSName.."", SCRIPT_PARAM_ONOFF, false)
		Menu.settings.harass:addParam("harassE", "Use [E] "..ESName.."", SCRIPT_PARAM_ONOFF, true)

	Menu.settings:addSubMenu("Killsteal", "killsteal")
		Menu.settings.killsteal:addParam("killstealQ", "Use [Q] "..QSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.killsteal:addParam("killstealW", "Use [W] "..WSName.."", SCRIPT_PARAM_ONOFF, false)
		Menu.settings.killsteal:addParam("killstealE", "Use [E] "..ESName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.killsteal:addParam("killstealR", "Use [R] "..RSName.."", SCRIPT_PARAM_ONOFF, true)

	Menu.settings:addSubMenu("Ultimate", "ultimate")
		Menu.settings.ultimate:addParam("ultimateHeal", "Heal with [R] "..RSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.ultimate:addParam("ultimateMinHealth", "Min % Health to Heal", SCRIPT_PARAM_SLICE, 70, 0, 100, -1)
		Menu.settings.ultimate:addParam("ultimateMinMana", "Min % Mana to Heal", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)

	Menu.settings:addSubMenu("Draw", "draw")
		Menu.settings.draw:addParam("drawDisable", "Disable Drawing", SCRIPT_PARAM_ONOFF, false)
		Menu.settings.draw:addParam("drawLF", "Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.draw:addParam("drawQ", "Draw [Q] "..QSName.."", SCRIPT_PARAM_ONOFF, false)
		Menu.settings.draw:addParam("drawQC", "[Q] "..QSName.." Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
		Menu.settings.draw:addParam("drawW", "Draw [W] "..WSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.draw:addParam("drawWC", "[W] "..WSName.." Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
		Menu.settings.draw:addParam("drawE", "Draw [E] "..ESName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.draw:addParam("drawEC", "[E] "..ESName.." Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})
		Menu.settings.draw:addParam("drawR", "Draw [R] "..RSName.."", SCRIPT_PARAM_ONOFF, true)
		Menu.settings.draw:addParam("drawRC", "[R] "..RSName.." Color", SCRIPT_PARAM_COLOR, {255, 0, 255, 0})

	Menu.settings:addSubMenu("Miscellaneous", "misc")
		Menu.settings.misc:addParam("miscZW", "Use Zhonya's/Wooglet's", SCRIPT_PARAM_ONOFF, false)
		Menu.settings.misc:addParam("miscZWH", "Min % for Zhonya's/Wooglet's", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
		Menu.settings.misc:addParam("miscLVL", "Automatically Level Skills", SCRIPT_PARAM_ONOFF, true)

	Menu:addParam("Version", "Version", SCRIPT_PARAM_INFO, ver)

	TargetSelector = TargetSelector(TARGET_LESS_CAST, 900, DAMAGE_MAGIC)
	TargetSelector.name = "Swain"
	Menu:addTS(TargetSelector)
end

function Combo()
	if Menu.hotkeys.cKey then
		if Target ~= nil then
			if Menu.settings.combo.comboE and EReady and GetDistance(Target) <= ERange then CastSpell(_E, Target) end
			if Menu.settings.combo.comboQ and QReady and GetDistance(Target) <= QRange then CastSpell(_Q, Target) end
			if Menu.settings.combo.comboW and WReady and GetDistance(Target) <= WRange then CastW(Target) end
			if Menu.settings.combo.comboR and RReady and GetDistance(Target) <= RRange and not UltActive then
				CastSpell(_R)
			end
		else
			if UltActive then CastSpell(_R) end
		end
	end
end

function Harass()
	if Target ~= nil and Menu.hotkeys.hKey then
		if Menu.settings.harass.harassE and EReady and GetDistance(Target) <= ERange then CastSpell(_E, Target) end
		if Menu.settings.harass.harassQ and QReady and GetDistance(Target) <= QRange then CastSpell(_Q, Target) end
		if Menu.settings.harass.harassW and WReady and GetDistance(Target) <= WRange then CastW(Target) end
	end
end

function CastW(Target)
    if Target and WReady then
        CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, WDelay, WRadius, WRange, WSpeed, myHero)
        if HitChance >=2 and GetDistance(CastPosition) < WRange then
        CastSpell(_W, CastPosition.x, CastPosition.z)
        end
    end
end

function Killsteal()
	if Target ~= nil then
		if 
			Menu.settings.killsteal.killstealQ and QReady and Target.health <= QDmg and GetDistance(Target) <= QRange then
			CastSpell(_Q, Target)
		elseif
			Menu.settings.killsteal.killstealE and EReady and Target.health <= EDmg and GetDistance(Target) <= ERange then
			CastSpell(_E, Target)
		elseif
			Menu.settings.killsteal.killstealW and WReady and Target.health <= WDmg and GetDistance(Target) <= WRange then
			CastW(Target)
		elseif
			Menu.settings.killsteal.killstealQ and Menu.settings.killsteal.killstealE and QReady and EReady and Target.health <= (QDmg + EDmg) and GetDistance(Target) <= ERange then
			CastSpell(_E, Target)
			CastSpell(_Q, Target)
		elseif
			Menu.settings.killsteal.killstealQ and Menu.settings.killsteal.killstealW and QReady and WReady and Target.health <= (QDmg + WDmg) and GetDistance(Target) <= QRange then
			CastW(Target)
			CastSpell(_Q, Target)
		elseif
			Menu.settings.killsteal.killstealE and Menu.settings.killsteal.killstealW and EReady and WReady and Target.health <= (EDmg + WDmg) and GetDistance(Target) <= ERange then
			CastW(Target)
			CastSpell(_E, Target)
		elseif
			Menu.settings.killsteal.killstealQ and Menu.settings.killsteal.killstealE and Menu.settings.killsteal.killstealW and QReady and EReady and WReady and Target.health <= (QDmg + EDmg + WDmg) and GetDistance(Target) <= WRange then
			CastW(Target)
			CastSpell(_E, Target)
			CastSpell(_Q, Target)
		end
	end
end

function UltManager()
	if not RReady then return end
	if Menu.settings.ultimate.ultimateHeal then
		Minions = GetUltMinions()
		if not UltActive then
			if myHero.mana > (myHero.maxMana * (Menu.settings.ultimate.ultimateMinMana / 100))
			and
				myHero.health < (myHero.maxHealth * (Menu.settings.ultimate.ultimateMinHealth / 100))
			and
				(Minions ~= nil or Target ~= nil) then
				CastSpell(_R)
			end
		elseif UltActive then
			if myHero.mana < (myHero.maxMana * (Menu.settings.ultimate.ultimateMinMana / 100)) then
				if not Menu.hotkeys.cKey then
					CastSpell(_R)
				end
			end
			if myHero.health >= (myHero.maxHealth * (Menu.settings.ultimate.ultimateMinHealth / 100)) then
				if not Menu.hotkeys.cKey then
					CastSpell(_R)
				end
			end
		end
	end
end

function GetUltMinions()
	for _, ultMinion in pairs(enemyMinions.objects) do
		if ValidTarget(ultMinion, RRange) then return ultMinion end
	end
end

function Consumables()
	if Menu.settings.misc.ZW and isLow('Zhonya') and Target and (ZNAReady or WGTReady) then
		CastSpell((WGTSlot or ZNASlot))
	end
end

function OnCreateObj(obj)
	if obj ~= nil then
		if obj.name:find("swain_demonForm") then
			if GetDistance(obj) <= 70 then
				UltActive = true
			end
		end
	end
end

function OnDeleteObj(obj)
	if obj ~= nil then
		if obj.name:find("swain_demonForm") then
			if GetDistance(obj) <= 70 then
				UltActive = false
			end
		end
	end
end

--[[Credits to barasia, vadash and viseversa for anti-lag circles]]
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if not Menu.settings.draw.drawLF then
		return DrawCircle(x, y, z, radius, color)
	end
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 75)	
	end
end

function OnDraw()
	if not Menu.settings.draw.drawDisable then
		if QReady and Menu.settings.draw.drawQ then
			DrawCircle2(myHero.x, myHero.y, myHero.z, QRange, ARGB(Menu.settings.draw.drawQC[1], Menu.settings.draw.drawQC[2], Menu.settings.draw.drawQC[3], Menu.settings.draw.drawQC[4]))
		end
		if WReady and Menu.settings.draw.drawW then
			DrawCircle2(myHero.x, myHero.y, myHero.z, WRange, ARGB(Menu.settings.draw.drawWC[1], Menu.settings.draw.drawWC[2], Menu.settings.draw.drawWC[3], Menu.settings.draw.drawWC[4]))
		end
		if EReady and Menu.settings.draw.drawE then
			DrawCircle2(myHero.x, myHero.y, myHero.z, ERange, ARGB(Menu.settings.draw.drawEC[1], Menu.settings.draw.drawEC[2], Menu.settings.draw.drawEC[3], Menu.settings.draw.drawEC[4]))
		end
		if RReady and Menu.settings.draw.drawR then
			DrawCircle2(myHero.x, myHero.y, myHero.z, RRange, ARGB(Menu.settings.draw.drawRC[1], Menu.settings.draw.drawRC[2], Menu.settings.draw.drawRC[3], Menu.settings.draw.drawRC[4]))
		end
	end
end

function Checks()
	Harass()
	Combo()

	TargetSelector:update()
	Target = TargetSelector.target

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)

	ZNASlot = GetInventorySlotItem(3157)
	WGTSlot = GetInventorySlotItem(3090)

	ZNAReady = (ZNASlot ~= nil and myHero:CanUseSpell(ZNASlot) == READY)
	WGTReady = (WGTSlot ~= nil and myHero:CanUseSpell(WGTSlot) == READY)
end

function isLow(Name)
	if Name == 'Zhonya' or Name == 'Wooglets' then
		if (myHero.health / myHero.maxHealth) <= (Menu.settings.misc.miscZW / 100) then
			return true
		else
			return false
		end
	end
	if Name == 'Health' then
		if (myHero.health / myHero.maxHealth) <= (Menu.settings.misc.miscZWH / 100) then
			return true
		else
			return false
		end
	end
end