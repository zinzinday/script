--[[
	AutoCarry Plugin - Shaco The Demon Jester 1.2 by Jaikor 
	With Code from Pain ( This is his work I just added new stuff with his permission and Updated it)
	All credit goes Basicly to Pain.
	Credit to HeX for some Epic features
	Credit to Skeem for his codes too xD
	Codes from Kain and Trololz
	I'm Still learning so don't be hard.
	Copyright 2013
	Changelog :
	1.2 - The R (ulti) has 3 modes it detects it Automaticly
	      1st killing enemy if, 2nd fighting/teamfight/distraction, 3rd low distraction/avoid damage (escaping) if your HP drops below a certain %
	1.1 - Added R to Combo with a Slide Bar to Toggle R in Combo Mode
    1.0 - Initial Release
    TO DO:
    I'll be working on Using the Shaco Ulti to dodge ulti from champs like Caits, ashe and so on
 ]] --

 --[[TargetPos = Vector(Target.x, Target.y, Target.z)
MyPos = Vector(myHero.x, myHero.y, myHero.z)
BackPos = TargetPos + (TargetPos-MyPos)*((50/GetDistance(Target)))]]

if myHero.charName ~= "Shaco" then return end
local SkillW = {spellKey = _W, range = 420, speed = 1.6, delay = 325}
--[Function When Plugin Loads]--
function PluginOnLoad()
	mainLoad() -- Loads our Variable Function
	mainMenu() -- Loads our Menu function
	PrintChat("<font color='#CCCCCC'> >> Thanks to Pain & HeX <<</font>")
end

--[OnTick]--
function PluginOnTick()
	if Recall then return end
	if IsSACReborn then
		AutoCarry.Crosshair:SetSkillCrosshairRange(725)
	else
		AutoCarry.SkillsCrosshair.range = 725
	end
	Checks()
	SmartKS()

	if Carry.AutoCarry then FullCombo() end
	if Carry.MixedMode and Target then 
		if Menu.eHarass and not IsMyManaLow() and GetDistance(Target) <= eRange then CastSpell(_E, Target) end
	end
	if Carry.LaneClear then JungleClear() end
	
	if Extras.ZWItems and IsMyHealthLow() and Target and (ZNAREADY or WGTREADY) then CastSpell((wgtSlot or znaSlot)) end
	if Extras.aHP and NeedHP() and not (UsingHPot or UsingFlask) and (HPREADY or FSKREADY) then CastSpell((hpSlot or fskSlot)) end
	if Extras.aMP and IsMyManaLow() and not (UsingMPot or UsingFlask) and(MPREADY or FSKREADY) then CastSpell((mpSlot or fskSlot)) end
	if Extras.AutoLevelSkills then autoLevelSetSequence(levelSequence) end
	if shacoClone ~= nil then
    if GetDistance(shacoClone) < 2418 and GetDistance(shacoClone) > 1725 then
    TestColour = 0xFF0000
    end
    if GetDistance(shacoClone) < 1724 and GetDistance(shacoClone) > 1250 then
    TestColour = 0xE88A0E
    end
    if GetDistance(shacoClone) < 1249 and GetDistance(shacoClone) > 0 then
    TestColour = 0x00CE00
    end
end
end

--[Drawing our Range/Killable Enemies]--
function PluginOnDraw()
if Menu.DrawR then
    if not myHero.dead then
        if shacoClone ~= nil then
			DrawCircle(myHero.x, myHero.y, myHero.z, 250, TestColour)
            DrawCircle(myHero.x, myHero.y, myHero.z, 2418, TestColour)
        end
    end
end
end

--[Casting our W into Enemies]--
function CastW(Target)
    if WREADY then 
   		AutoCarry.CastSkillshot(SkillW, Target)
    end
end

--[Object Detection]--
function PluginOnCreateObj(obj)
	if obj.name:find("TeleportHome.troy") then
		if GetDistance(obj, myHero) <= 70 then
			Recall = true
		end
	end
	if obj.name:find("Regenerationpotion_itm.troy") then
		if GetDistance(obj, myHero) <= 70 then
			UsingHPot = true
		end
	end
	if obj.name:find("Global_Item_HealthPotion.troy") then
		if GetDistance(obj, myHero) <= 70 then
			UsingHPot = true
			UsingFlask = true
		end
	end
	if obj.name:find("Global_Item_ManaPotion.troy") then
		if GetDistance(obj, myHero) <= 70 then
			UsingFlask = true
			UsingMPot = true
		end
	end
	if object ~= nil and object.name:find("Jester_Copy") then
		shacoClone = object
    end
end

function PluginOnDeleteObj(obj)
	if obj.name:find("TeleportHome.troy") then
		Recall = false
	end
	if obj.name:find("Regenerationpotion_itm.troy") then
		UsingHPot = false
	end
	if obj.name:find("Global_Item_HealthPotion.troy") then
		UsingHPot = false
		UsingFlask = false
	end
	if obj.name:find("Global_Item_ManaPotion.troy") then
		UsingMPot = false
		UsingFlask = false
	end
	if object ~= nil and object.name:find("Jester_Copy") then
        shacoClone = nil
    end
end

--[Low Mana Function by Kain]--
function IsMyManaLow()
    if myHero.mana < (myHero.maxMana * ( Extras.MinMana / 100)) then
        return true
    else
        return false
    end
end

--[/Low Mana Function by Kain]--

--[Low Health Function Trololz]--
function IsMyHealthLow()
	if myHero.health < (myHero.maxHealth * ( Extras.ZWHealth / 100)) then
		return true
	else
		return false
	end
end
--[/Low Health Function Trololz]--

--[Health Pots Function]--
function NeedHP()
	if myHero.health < (myHero.maxHealth * ( Extras.HPHealth / 100)) then
		return true
	else
		return false
	end
end

--[Smart KS Function]--
function SmartKS()
	for i=1, heroManager.iCount do
	 local enemy = heroManager:GetHero(i)
	    if ValidTarget(enemy) then
			dfgDmg, hxgDmg, bwcDmg, iDmg  = 0, 0, 0, 0
			qDmg = getDmg("Q",enemy,myHero)
            eDmg = getDmg("E",enemy,myHero)
			wDmg = getDmg("W",enemy,myHero)
			if DFGREADY then dfgDmg = (dfgSlot and getDmg("DFG",enemy,myHero) or 0)	end
            if HXGREADY then hxgDmg = (hxgSlot and getDmg("HXG",enemy,myHero) or 0) end
            if BWCREADY then bwcDmg = (bwcSlot and getDmg("BWC",enemy,myHero) or 0) end
            if IREADY then iDmg = (ignite and getDmg("IGNITE",enemy,myHero) or 0) end
            onspellDmg = (liandrysSlot and getDmg("LIANDRYS",enemy,myHero) or 0)+(blackfireSlot and getDmg("BLACKFIRE",enemy,myHero) or 0)
            itemsDmg = dfgDmg + hxgDmg + bwcDmg + iDmg + onspellDmg
			if Menu.sKS then
				if enemy.health <= (eDmg) and GetDistance(enemy) <= eRange and EREADY then
					if EREADY then CastSpell(_E, enemy) end
				
				elseif enemy.health <= (wDmg) and GetDistance(enemy) <= wRange and WREADY then
					if WREADY then CastW(enemy) end
				
				elseif enemy.health <= (qDmg + eDmg) and GetDistance(enemy) <= eRange and EREADY and QREADY then
					if QREADY then CastSpell(_Q, Target.x, Target.z)
					if EREADY then CastSpell(_E, enemy) end
									
				elseif enemy.health <= (qDmg + itemsDmg) and GetDistance(enemy) <= qRange and QREADY then
					if DFGREADY then CastSpell(dfgSlot, enemy) end
					if HXGREADY then CastSpell(hxgSlot, enemy) end
					if BWCREADY then CastSpell(bwcSlot, enemy) end
					if BRKREADY then CastSpell(brkSlot, enemy) end
					if QREADY then CastSpell(_Q, Target.x, Target.z) end
				
				elseif enemy.health <= (eDmg + itemsDmg) and GetDistance(enemy) <= eRange and EREADY then
					if DFGREADY then CastSpell(dfgSlot, enemy) end
					if HXGREADY then CastSpell(hxgSlot, enemy) end
					if BWCREADY then CastSpell(bwcSlot, enemy) end
					if BRKREADY then CastSpell(brkSlot, enemy) end
					if EREADY then CastSpell(_E, enemy) end
				
				elseif enemy.health <= (qDmg + eDmg + itemsDmg) and GetDistance(enemy) <= eRange
					and EREADY and QREADY then
						if DFGREADY then CastSpell(dfgSlot, enemy) end
						if HXGREADY then CastSpell(hxgSlot, enemy) end
						if BWCREADY then CastSpell(bwcSlot, enemy) end
						if BRKREADY then CastSpell(brkSlot, enemy) end
						if EREADY then CastSpell(_E, enemy) end
						if QREADY then CastSpell(_Q, Target.x, Target.z) end
						
				
				end
								
				if enemy.health <= iDmg and GetDistance(enemy) <= 600 then
					if IREADY then CastSpell(ignite, enemy) end
				end
			end
			KillText[i] = 1 
			if enemy.health <= (qDmg + eDmg + itemsDmg) and QREADY and EREADY then
			KillText[i] = 2
			end
		end
	end
end
end

--[Full Combo with Items]--
function FullCombo()
	if Target then
		if AutoCarry.MainMenu.AutoCarry then
		    if Menu.useQ and GetDistance(Target) <= qRange then CastSpell(_Q, Target.x, Target.z) end
			if Menu.useW and GetDistance(Target) <= wRange then CastW(Target) end
			if Menu.useE and GetDistance(Target) <= eRange then CastSpell(_E, Target) end 
			if Menu.useR and GetDistance(Target) <= rRange and (Target.health < Target.maxHealth*(Menu.PercentofHealth/100) or CountEnemyHeroInRange(500) > 2 or myHero.health < myHero.maxHealth*0.25) then CastSpell(_R) end
		end
	end
end

function JungleClear()
	if IsSACReborn then
		JungleMob = AutoCarry.Jungle:GetAttackableMonster()
	else
		JungleMob = AutoCarry.GetMinionTarget()
	end
	if JungleMob ~= nil and not IsMyManaLow() then
		if Extras.JungleE and GetDistance(JungleMob) <= eRange then CastSpell(_E, JungleMob) end
		if Extras.JungleW and GetDistance(JungleMob) <= wRange then CastSpell(_W, JungleMob.x, JungleMob.z) end
	end
end

--[Variables Load]--
function mainLoad()
	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end
	if IsSACReborn then AutoCarry.Skills:DisableAll() end
	Carry = AutoCarry.MainMenu
	qRange,wRange,eRange,rRange = 400, 425, 625, 1000
	QREADY, WREADY, EREADY, RREADY = false, false, false, false
	qName, wName, eName, rName = "Deceive", "Jack In The Box", "Two-Shiv Poison", "Hallucinate"
	HK1, HK2, HK3 = string.byte("Z"), string.byte("K"), string.byte("G")
	Menu = AutoCarry.PluginMenu
	UsingHPot, UsingMPot, UsingFlask = false, false, false
	Recall = false, false, false
	TextList = {"Harass him!!", "FULL COMBO KILL!"}
	KillText = {}
	waittxt = {} -- prevents UI lags, all credits to Dekaron
	for i=1, heroManager.iCount do waittxt[i] = i*3 end -- All credits to Dekaron
	if IsSACReborn then
	end	
end

--[Main Menu & Extras Menu]--
function mainMenu()
	Menu:addParam("sep1", "-- Full Combo Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("useQ", "Use "..qName.." (Q)", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("useW", "Use "..wName.." (W)", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("useE", "Use "..eName.." (E)", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("sep2", "-- Mixed Mode Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("eHarass", "Use "..eName.." (E)", SCRIPT_PARAM_ONOFF, true)
    Menu:addParam("sep3", "-- KS Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("sKS", "Use Smart Combo KS", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("sep4", "-- Draw Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("wDraw", "Draw "..wName.." (W)", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("DrawR", "Draw Circles for Clone", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("cDraw", "Draw Enemy Text", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("sep5", "-- Ulti Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("useR", "Use "..rName.." (R)", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("PercentofHealth", "Minimum Health %", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
	Extras = scriptConfig("Sida's Auto Carry Plugin: "..myHero.charName..": Extras", myHero.charName)
	Extras:addParam("sep6", "-- Misc --", SCRIPT_PARAM_INFO, "")
	Extras:addParam("JungleE", "Jungle with "..eName.." (E)", SCRIPT_PARAM_ONOFF, true)
	Extras:addParam("JungleW", "Jungle with "..wName.." (W)", SCRIPT_PARAM_ONOFF, true)
	Extras:addParam("MinMana", "Minimum Mana for Jungle/Harass %", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
	Extras:addParam("ZWItems", "Auto Zhonyas/Wooglets", SCRIPT_PARAM_ONOFF, true)
	Extras:addParam("ZWHealth", "Min Health % for Zhonyas/Wooglets", SCRIPT_PARAM_SLICE, 15, 0, 100, -1)
	Extras:addParam("aHP", "Auto Health Pots", SCRIPT_PARAM_ONOFF, true)
	Extras:addParam("aMP", "Auto Auto Mana Pots", SCRIPT_PARAM_ONOFF, true)
	Extras:addParam("HPHealth", "Min % for Health Pots", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
end

--[Certain Checks]--
function Checks()
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2 end
	if IsSACReborn then Target = AutoCarry.Crosshair:GetTarget() else Target = AutoCarry.GetAttackTarget() end
	dfgSlot, hxgSlot, bwcSlot = GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144)
	brkSlot = GetInventorySlotItem(3092),GetInventorySlotItem(3143),GetInventorySlotItem(3153)
	znaSlot, wgtSlot = GetInventorySlotItem(3157),GetInventorySlotItem(3090)
	hpSlot, mpSlot, fskSlot = GetInventorySlotItem(2003),GetInventorySlotItem(2004),GetInventorySlotItem(2041)
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	DFGREADY = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
	HXGREADY = (hxgSlot ~= nil and myHero:CanUseSpell(hxgSlot) == READY)
	BWCREADY = (bwcSlot ~= nil and myHero:CanUseSpell(bwcSlot) == READY)
	BRKREADY = (brkSlot ~= nil and myHero:CanUseSpell(brkSlot) == READY)
	ZNAREADY = (znaSlot ~= nil and myHero:CanUseSpell(znaSlot) == READY)
	WGTREADY = (wgtSlot ~= nil and myHero:CanUseSpell(wgtSlot) == READY)
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	HPREADY = (hpSlot ~= nil and myHero:CanUseSpell(hpSlot) == READY)
	MPREADY =(mpSlot ~= nil and myHero:CanUseSpell(mpSlot) == READY)
	FSKREADY = (fskSlot ~= nil and myHero:CanUseSpell(fskSlot) == READY)
end
