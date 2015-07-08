--[[

	Changelog
			1.0: Released Script
		

			1.1
			​	Added Farm
				Added DFG and Zhonyas
				Added auto downloading script (Not Libs)
				Added another option in Combo to use R if the R stuns

			1.2
				​Added Auto Kill when Killable (Toggle)
				Added Auto Q when Q will Stun (Inside Harass menu, but will still Cast even when Harass is Off)
				Added Ignite
				Added E cast until Stun is UP
				Fixed a bug with AutoDownloading 

			1.3
				Added auto-downloading libraries
				Rewrote combo (Combo where you use R only if it stuns)
				Added auto E if being attacked
				Added Harass option to Q > W if W will stun (so @ 3 stacks)

			1.4
				Fixed bol.boost link

			1.5
				Disabled usage of E when hero is recalling
				Disabled BoL tracker for faster runtime

			1.6
				Fixed ManaManger
				Added not to ult on certain targets
				Fixed Ignite
					Added "Use Ignite On"
				Added barrier and heal
				Added Auto Ult (if ult will hit x targets)
				Better AutoKill (AutoKill and KillSteal are basically the same, so they are now the same menu)
				Added DFG support
				Now Draws Killable (with which spells) on ALL enemies

			1.7
				Added more Combo Ways
					QWR
					WQR
					RQW
					RWQ
				Added Zhonyas support for
					Karthus Ult
					Zed Ult if the mark will kill you
					Will add more if requested
				Improved Drawing Killable with which spells text
				Made the AutoUlt a little bit smoother/faster
				Cleaned up Code

			1.8
				Little Tweaks to improve performance
				Few bug fixes / mistypes
				Hopefully fixed random bugsplats

			1.85
				Disabled AutoLeveling
--------------------------------------------------------------------------------------------

			2.0
				Added Ignite in AutoKill
				Added Ignite in Draw KillAble
				Added Flash in AutoR
					Adjustable settings:
						Enemies nearby
						Range between you and enemies
						Allies nearby
						Range between you and allies
				Added Gapcloser/Interrupter
					Will cast Q/W if it'll stun
				No longers farms while recalling
				There is now a possibility to cast EW in fountain to stack Stun
				Jungle Steal
					There is no prediction added into this, so it'll just use abilites when the damage is higher than the health of the jungle creep.
					Only works with big minions
					Blue&Red: Cast Q
					Dragon&Baron: Cast Q or Cast Q/R - Not adjustable, so be careful

			2.05
				Fixed damn ignite mistype

			2.06 
				Temp fix for SxOrbwalk

			2.10
				Fixed spam bug with "Qmg"
				Fixed Jungle Names (Jungle steal should now work 'perfectly')
					Perfectly as in it'll cast abilities.
					It'll steal even if no enemies are near, so be careful with this.

					I'll adjust this later, so you can adjust this to your own settings.
				Added more options to Draw Killable
				Re-enabled normal SxOrbWalk 
				Changed Ignite settings
					Normal killsteal Ignite is now included in AutoKill
					Ignite kill with Combo is now included in Misc > Ignite

			2.20
				Jungle Steal now has optional settings
				Rewrote AutoKill to look more accurately for all possibilities
				Now gets a target through OrbWalker
					Supports SAC Reborn / MMA and SxOrbWalk
				Edited menu of Auto Kill
					Added more optios
				Option to disable AA in combo
				The Kill Text should now have DFG
				Few performance tweaks (Script should max give a 20fps drop)

			2.25
				R in Combo mode now:
					Normal
					Stun
					Killable

			2.27
				Performance tweaks

			2.28 
				Minor bug fixes

			2.30
				Realised something didn't work, so took it out

			2.33
				Deleted Spell Damage Library requirement

			2.5
				Completely removed DFG
				Made a workaround for the buff stacking
					It should now detect the buffs, BUT you have to make sure you have 0 stacks when you start the script

			2.7
				Using buffs to check stun again
				SAC Integration





		Script Coded by Totally Legt.
		If you have any questions, please post in the thread of send me an PM. You are always free to send me a PM regarding this script or regarding another.
		If you use this script, please give me feedback on how it works and how to improve. If something doesn't work, don't just go to another script. Tell me 
			what went wrong and I'll try my best to fix it as soon as possible.
	]]


if myHero.charName ~= "Annie" then return end


--[[		Auto Update		]]
local version = "2.7"
local author = "Totally Legit"
local SCRIPT_NAME = "Totally Annie"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Nickieboy/BoL/master/NAnnie.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Totally Annie:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Nickieboy/BoL/master/version/NAnnie.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

-- Declaring variables
local lastLevel = myHero.level - 1
local Qdmg, Wdmg, Rdmg, DFGdmg, iDmg, totalDamage, health, mana, maxHealth, maxMana = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
local canStun = false
local EnemyMinions = minionManager(MINION_ENEMY, 600, myHero, MINION_SORT_HEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_HEALTH_ASC)
local minionsSteal = {"SRU_Blue", "SRU_Red", "SRU_Dragon", "SRU_Baron"}
local ignite, heal, barrier, flash = nil, nil, nil, nil
local passiveStacks = 0
local hasTibbers = false
local isRecalling = false
local target, Rtarget = nil, nil
local Qready, Wready, Eready, Rready, Hready, Bready, Iready, Fready = false, false, false, false, false, false, false, false, false
local useFlash = false
local enemyJunglers = {}
local allyJunglers = {}
local AAdisabled = false
local healthPot, manaPot = false, false
local TextList = {"Ignite = kill", "Q = kill", "Q + ignite = kill", "QW = kill", "QW + ignite = kill", "QWR = kill", "QWR + ignite = kill", "Not Killable"}
local KillText = {}
local spells = {
					["Disintegrate"] = true,
					["Incinerate"] = true,
					["MoltenShield"] = true,
					["InfernalGuardian"] = true
				}
local SACLoaded, SxOrbLoaded, orbWalkLoaded = false
local tempPassiveStacks = 0



assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQINAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBBkBAAB2AgAAIAACCHwCAAAUAAAAEBgAAAGNsYXNzAAQIAAAAVHJhY2tlcgAEBwAAAF9faW5pdAAECgAAAFVwZGF0ZVdlYgAEGgAAAGNvdW50aW5nSG93TXVjaFVzZXJzSWhhdmUAAgAAAAEAAAADAAAAAQAFCAAAAEwAQADDAIAAAUEAAF1AAAJGgEAApQAAAF1AAAEfAIAAAwAAAAQKAAAAVXBkYXRlV2ViAAMAAAAAAAAAQAQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAAAgAAAAMAAAAAAAQGAAAABQAAAAwAQACDAAAAwUAAAB1AAAIfAIAAAgAAAAQKAAAAVXBkYXRlV2ViAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAYAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAAAAAAAAQAAAAUAAABzZWxmAAEAAAAAABAAAABAb2JmdXNjYXRlZC5sdWEACAAAAAEAAAABAAAAAQAAAAEAAAACAAAAAwAAAAIAAAADAAAAAQAAAAUAAABzZWxmAAAAAAAIAAAAAQAAAAUAAABfRU5WAAQAAAALAAAAAwAKIwAAAMYAQAABQQAA3YAAAQaBQABHwcABXQGAAB2BAABMAUECwUEBAAGCAQBdQQACWwAAABeAAYBMwUECwQECAAACAAFBQgIA1kGCA11BgAEXQAGATMFBAsGBAgAAAgABQUICANZBggNdQYABTIFDAsHBAwBdAYEBCMCBhgiAAYYIQIGFTAFEAl1BAAEfAIAAEQAAAAQIAAAAcmVxdWlyZQAEBwAAAHNvY2tldAAEBwAAAGFzc2VydAAEBAAAAHRjcAAECAAAAGNvbm5lY3QABBQAAABtYWlraWU2MS5zaW5uZXJzLmJlAAMAAAAAAABUQAQFAAAAc2VuZAAEKwAAAEdFVCAvdHJhY2tlci9pbmRleC5waHAvdXBkYXRlL2luY3JlYXNlP2lkPQAEKQAAACBIVFRQLzEuMA0KSG9zdDogbWFpa2llNjEuc2lubmVycy5iZQ0KDQoABCsAAABHRVQgL3RyYWNrZXIvaW5kZXgucGhwL3VwZGF0ZS9kZWNyZWFzZT9pZD0ABAIAAABzAAQHAAAAc3RhdHVzAAQIAAAAcGFydGlhbAAECAAAAHJlY2VpdmUABAMAAAAqYQAEBgAAAGNsb3NlAAAAAAABAAAAAAAQAAAAQG9iZnVzY2F0ZWQubHVhACMAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAcAAAAHAAAACAAAAAgAAAAJAAAACQAAAAkAAAAIAAAACQAAAAoAAAAKAAAACwAAAAsAAAALAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAUAAAAFAAAAc2VsZgAAAAAAIwAAAAIAAABhAAAAAAAjAAAAAgAAAGIAAAAAACMAAAACAAAAYwADAAAAIwAAAAIAAABkAAcAAAAjAAAAAQAAAAUAAABfRU5WAAEAAAABABAAAABAb2JmdXNjYXRlZC5sdWEADQAAAAEAAAABAAAAAQAAAAEAAAADAAAAAQAAAAQAAAALAAAABAAAAAsAAAALAAAACwAAAAsAAAAAAAAAAQAAAAUAAABfRU5WAA=="), nil, "bt", _ENV))()



--Perform on load
function OnLoad()

	FindSummoners() 

	FindJunglers()

	levelSequences = {
			[1] = { _Q, _W, _Q, _E, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E },
			[2] = { _W, _Q, _W, _E, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E },
	}

	DelayAction(function() CheckOrbWalker() end, 10)

 	-- TargetSelector
 	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 625)

 	DrawMenu()
end 

function Say(text)
	print("<font color=\"#FF0000\"><b>Totally Annie:</b></font> <font color=\"#FFFFFF\">" .. text .. "</font>")
end

function CheckOrbWalker() 
	if _G.Reborn_Initialised then
		SACLoaded = true 
		Menu.orbwalker:addParam("info", "Detected SAC", SCRIPT_PARAM_INFO, "")
		_G.AutoCarry.Skills:DisableAll()
		Say("SAC Detected.")
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		require("SxOrbWalk")
		SxOrbLoaded = true 
		_G.SxOrb:LoadToMenu(Menu.orbwalker)
		Say("SxOrb Detected.")
		Menu.combo:addParam("disableAA", "Disable AA", SCRIPT_PARAM_LIST, 1, {"Not in skill range", "Always", "Never"})
	end

	if SACLoaded or SxOrbLoaded then
		orbWalkLoaded = true
	end

	if not orbWalkLoaded then 
		Say("You need either SAC or SxOrbWalk for this script. Please download one of them.") 
	else
		Say("Succesfully Loaded. Enjoy the script! Report bugs on the thread.")
	end
end

-- Perform every time
function OnTick()
	target = GetOrbTarget()

	SpellChecks()

	if Menu.misc.autolevel.autoLevel then
		AutoLevel()
	end

	if Menu.harass.harass or Menu.harass.harassT then
		Harass()
	end 

	if Menu.combo.combo then
		Combo()
	end 

	if Menu.combo.disableAA and Menu.combo.combo then
		if SxOrbLoaded and not AAdisabled then
			_G.SxOrb:DisableAttacks()
			AAdisabled = true
		end 
	end 
		
	if Menu.combo.disableAA and not Menu.combo.combo then
		if SxOrbLoaded and AAdisabled then
			_G.SxOrb:EnableAttacks()
			AAdisabled = false
		end 
	end

	AutoHarass()

	if Menu.autoR.autoUlt then
		AutoUlt()
	end 

	if Menu.autokill.autokill and not Menu.combo.combo then
		KillStealPrecise() 
	end 

	if Menu.misc.autopotions.usePotions then
		DrinkPotions()
	end 

	if Menu.farm.farm and not Menu.combo.combo and isRecalling ~= true then
		Farm()
	end 

	if Menu.jungle.useJungle then
		JungleSteal()
	end 

	if Menu.misc.zhonyas.zhonyas then
		Zhonyas()
	end 

	if Menu.misc.Esettings.procE and canStun ~= true and isRecalling ~= true then
		CastE()
	end 

	if Menu.misc.Esettings.procEW and InFountain() and Eready and Wready and canStun ~= true and passiveStacks <= 2 then
		CastE()
		DelayAction(function() 
			if canStun ~= true and passiveStacks <= 3 then
				CastSpell(_W, mousePos.x, mousePos.z)
			end 
		end, 0.5)
		
	end 

	if heal ~= nil and Menu.misc.autoheal.useHeal and not InFountain() then
		UseHeal()
	end 

	if ignite ~= nil and Menu.misc.autoignite.useIgnite and Menu.combo.combo then
		UseIgnite() 
	end 
	if barrier ~= nil and Menu.misc.autobarrier.useBarrier then
		UseBarrier()
	end 

	MenuCheck()


	DrawKillable()
 

end

function OnDraw()
 -- Draw Skill range
	if Menu.drawings.draw then
	 	if Menu.drawings.drawQ or Menu.drawings.drawW then
			DrawCircle(myHero.x, myHero.y, myHero.z, 625, 0x111111)
	 	end
	 	if Menu.drawings.drawR then
	 		DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0x111111)
	 	end 

	 	if Menu.drawings.drawKillable then
	 		for i = 1, heroManager.iCount do
	 			local enemy = heroManager:getHero(i)
	 			if ValidTarget(enemy) then
	 				local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
					local PosX = barPos.x - 35
					local PosY = barPos.y - 50  
					DrawText(TextList[KillText[i]], 15, PosX, PosY, ARGB(255,255,204,0))
				end 
			end 
	 	end 
	 	---[[
	 	if Menu.drawings["drawDamage"] then 
    		for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
           			DrawIndicator(enemy)
        		end
			end
 		end

 		--]]
 	end 
 end 


function GetOrbTarget()
	ts:update()
	if SACLoaded then return _G.AutoCarry.Crosshair:GetTarget() end
	if SxOrbLoaded then return _G.SxOrb:GetTarget() end 
	return ts.target
end 


function Harass()

 	if ManaManager() then
 		if target ~= nil and ValidTarget(target) then
	 		if (Menu.harass.harassQ) then
	 			CastQ(target)
	 		end 
	 		if (Menu.harass.harassW) then
	 			CastW(target)
	 		end 
 		end
 	end  
end

function AutoHarass()
	if Menu.harass.autoQ and canStun and not Menu.combo.combo and ManaManager() then 
 		if target ~= nil and ValidTarget(target, 575) then
 			CastQ(target)
 		end 
	end 
end 

function Combo()
	if target ~= nil and ValidTarget(target, 590) then

		if Menu.combo.RUsage.howR == 3 and Rready then	
			ComboRStun()
		else
			if Menu.combo.comboWay == 1 then
				ComboQ()
			elseif Menu.combo.comboWay == 2 then
				ComboW()
			elseif Menu.combo.comboWay == 3 then
				ComboRQ()
			elseif Menu.combo.comboWay == 4 then
				ComboRW()
			end  
		end
 
	end  
end 

function ComboQ()
	if Menu.combo.comboQ then
		CastQ(target)
	end 

	if Menu.combo.comboW then
		CastW(target)
	end 

	if Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 1 then
		CastR(target)  
	elseif Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 2 then
		if target.health < getDmg("R", target, myHero, 1) then
			CastR(target)  
		end 
	end 
end

function ComboW()

	if Menu.combo.comboW then
		CastW(target)
	end 

	if Menu.combo.comboQ then
		CastQ(target)
	end 

	if Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 1 then
		CastR(target)  
	elseif Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 2 then
		if target.health < getDmg("R", target, myHero, 1) then
			CastR(target)  
		end 
	end 
end 

function ComboRQ()
	if Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 1 then
		CastR(target)  
	elseif Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 2 then
		if target.health < getDmg("R", target, myHero, 1) then
			CastR(target)  
		end 
	end 
	
	if Menu.combo.comboQ then
		CastQ(target)
	end 

	if Menu.combo.comboW then
		CastW(target)
	end 
end 

function ComboRW()
	if Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 1 then
		CastR(target)  
	elseif Menu.combo.comboR and Menu.combo.RUsage[target.charName] and Menu.combo.RUsage.howR == 2 then
		if target.health < getDmg("R", target, myHero, 1) then
			CastR(target)  
		end 
	end 
	
	if Menu.combo.comboW then
		CastW(target)
	end 

	if Menu.combo.comboQ then
		CastQ(target)
	end 

end 

function ComboRStun()
	if canStun and Menu.combo.comboR then
		CastR(target)
	end 

	if Menu.combo.comboWay == 1 then
		if Menu.combo.comboQ then
			CastQ(target)
		end 
	else
		if Menu.combo.comboW then
			CastW(target)
		end 
	end 

	if canStun and Menu.combo.comboR then
		CastR(target)
	end 

	if Menu.combo.comboWay == 1 then
		if Menu.combo.comboW then
			CastW(target)
		end  
	else
		if Menu.combo.comboQ then
			CastQ(target)
		end
	end 

	CastE()

	if canStun and Menu.combo.comboR then
		CastR(target)
	end 

	if Menu.combo.comboR and canStun then
		CastR(target)
	end

end 

function AutoUlt()
	if flash ~= nil then
		useFlash = FlashSettings()
	end

	Rtarget = ReturnBestUltTarget(Menu.autoR.hitX, useFlash)
	if Rtarget ~= nil then
		if GetDistance(Rtarget) < 600 then
			CastR(Rtarget)
		elseif GetDistance(Rtarget) > 600 and GetDistance(Rtarget) < 1000 and Fready and Rready then
			local flashPos = Vector(myHero.visionPos) + (Vector(Rtarget) - myHero.visionPos):normalized() * 400
			if not IsWall(D3DXVECTOR3(flashPos.x, flashPos.y, flashPos.z)) then
				CastSpell(flash, flashPos.x, flashPos.z)
				DelayAction(function() CastR(Rtarget) end, 0.3)
			end 
		end 
	end  
end

function FlashSettings()
	if Menu.flash.useFlash and CountEnemyHeroInRange(Menu.flash.enemiesrange) >= Menu.flash.enemies and CountAllyHeroInRange(Menu.flash.alliesrange) >= Menu.flash.allies and Fready then
		return true
	end
	return false
end

function CastQ(target) 
	if Qready and myHero.canAttack and not myHero.dead then
   	 	CastSpell(_Q, target)
   	end
end


function CastW(target) 
	if Wready and myHero.canAttack and not myHero.dead then
    	CastSpell(_W, target)
  	end
end

function CastE()
	if Eready and myHero.canAttack and not myHero.dead then
		CastSpell(_E)
    end
end

function CastR(target)
	if Rready and myHero.canAttack and not myHero.dead and not hasTibbers then
		CastSpell(_R, target)
    end
end

function Farm()
	EnemyMinions:update()

	if Menu.farm.farmStun and canStun then return end 

	if Menu.farm.farmQ then
		FarmQ()
	end 
	if Menu.farm.farmW then
		FarmW()
	end 

end 

function FarmW()
	for i, minion in pairs(EnemyMinions.objects) do
		if Menu.farm.farmW then
			local Qdmg, Wmg = CalcSpellDamage(minion)
			if minion ~= nil and not minion.dead and minion.visible and minion.health < Wdmg and ValidTarget(minion, 625) then
				CastW(minion, minion.x, minion.y)
			end 
		end 
	end 
end 

function FarmQ()
	for i, minion in pairs(EnemyMinions.objects) do
		if Menu.farm.farmQ then
			local Qdmg, Wmg = CalcSpellDamage(minion)
			if minion ~= nil and not minion.dead and minion.visible and minion.health < Qdmg and ValidTarget(minion, 625) then
				CastQ(minion)
			end 
		end 
	end 
end 


function JungleStealCheckRequirements(localMinion)
	if Menu.jungle.optional.useOptional then
		local enemyRequirement = false
		local allyRequirement = false

		if Menu.jungle.optional.enemyjungler then
			if #enemyJunglers >= 1 then
				for i = 1, #enemyJunglers do
					local jungler = enemyJunglers[i]
					if GetDistance(localMinion, jungler) < Menu.jungle.optional.rangeenemyjungler then
						enemyRequirement = true
						break
					end
				end
			end
		end

		if Menu.jungle.optional.allyjungler then
			if #allyJunglers >= 1 then
				for i = 1, #allyJunglers do
					local jungler = allyJunglers[i]
					if GetDistance(localMinion, jungler) < Menu.jungle.optional.rangeallyjungler then
						allyRequirement = true
						break
					end
				end
			end
		end

		if Menu.jungle.optional.enemyjungler and Menu.jungle.optional.allyjungler and enemyRequirement and allyRequirement then
			return true 
		elseif Menu.jungle.optional.enemyjungler and not Menu.jungle.optional.allyjungler and enemyRequirement then
			return true 
		elseif not Menu.jungle.optional.enemyjungler and Menu.jungle.optional.allyjungler and allyRequirement then
			return true 
		end 

		return false 
	end

	return true
end 

function JungleSteal()
	JungleMinions:update()

 	for i, minion in ipairs(JungleMinions.objects) do
	 	if GetDistance(minion) < 600 and JungleStealCheckRequirements(minion) then
	 		local Qdmg, Wdmg, Rdmg = CalcSpellDamage(minion)

		 	if minion.charName == minionsSteal[1] and Menu.jungle.stealBlue and minion.health < Qdmg and not minion.dead and minion.visible then
		 		CastQ(minion)
		 	elseif minion.charName == minionsSteal[2] and Menu.jungle.stealRed and minion.health < Qdmg and not minion.dead and minion.visible then
		 		CastQ(minion) 
		 	elseif minion.charName == minionsSteal[4] and Menu.jungle.stealBaron then
		 		if minion.health < Qdmg and not minion.dead and minion.visible then
		 			CastQ(minion)
		 		elseif minion.health < Qdmg + Rdmg and not minion.dead and minion.visible then
		 			CastQ(minion)
		 			CastR(minion)
		 		end
		 	elseif minion.charName == minionsSteal[3] and Menu.jungle.stealDragon then
		 		if minion.health < Qdmg and not minion.dead and minion.visible then
		 			CastQ(minion)
		 		elseif minion.health < Qdmg + Rdmg and not minion.dead and minion.visible then
		 			CastQ(minion)
		 			CastR(minion)
		 		end 
		 	end 
	 	end 
 	end 
end 

function Zhonyas()
	local zSlot = GetInventorySlotItem(3157)
	if zSlot ~= nil and myHero:CanUseSpell(zSlot) == READY then
		local health = myHero.health
		local mana = myHero.mana
		local maxHealth = myHero.maxHealth
		if (health / maxHealth) <= Menu.misc.zhonyas.zhonyasunder then
			CastSpell(zSlot)
		end 
	end 
end


function SpellChecks()
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)

	Hready = (heal ~= nil and myHero:CanUseSpell(heal) == READY)

	Bready = (barrier ~= nil and myHero:CanUseSpell(barrier) == READY)
	
	Iready = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)

	Fready = (flash ~= nil and myHero:CanUseSpell(flash) == READY)
end 

function FindSummoners() 
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then 
		heal = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerheal") then 
    	heal = SUMMONER_2
    end 

    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then 
		ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
    	ignite = SUMMONER_2
    end 

    if myHero:GetSpellData(SUMMONER_1).name:find("summonerbarrier") then 
		barrier = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerbarrier") then 
    	barrier = SUMMONER_2
    end

    if myHero:GetSpellData(SUMMONER_1).name:find("summonerflash") then 
		flash = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerflash") then 
    	flash = SUMMONER_2
    end

end


function KillStealPrecise()
	SpellChecks()

	local useQ = Menu.autokill.spells.autokillQ
	local useW = Menu.autokill.spells.autokillW
	local useR = Menu.autokill.spells.autokillR
	local useIgnite = Menu.autokill.spells.autokillIgnite
	local Qmana = myHero:GetSpellData(_Q).mana
	local Wmana = myHero:GetSpellData(_W).mana
	local Rmana = myHero:GetSpellData(_R).mana

	optionalRange = ((Menu.autokill.optional.useOptional and CountEnemyHeroInRange(Menu.autokill.optional.range) <= Menu.autokill.optional.enemiesnearby and Menu.autokill.optional.range) or 575)

	for i, enemy in ipairs(GetEnemyHeroes()) do
		if Menu.autokill.enemies[enemy.charName] and ValidTarget(enemy, optionalRange) then
			
			local Qdmg, Wdmg, Rdmg = CalcSpellDamage(enemy)

			Qdmg = ((useQ and Qready and Qdmg) or 0)
			Wdmg = ((useW and Wready and Wdmg) or 0)
			Rdmg = ((useR and Rready and not HaveBuff(myHero, "infernalguardiantimer") and Rdmg) or 0)
			iDmg = ((useIgnite and Iready and getDmg("IGNITE", enemy, myHero)) or 0)


			if iDmg > enemy.health then
				CastSpell(ignite, enemy)
			elseif Wdmg > Qdmg and Qdmg > enemy.health and myHero.mana > Qmana then
				CastQ(enemy)
			elseif Wdmg > enemy.health and myHero.mana > Wmana then
				CastW(enemy)
			elseif Qdmg + Rdmg > enemy.health and myHero.mana > Qmana + Rmana then
				CastQ(enemy)
				CastR(enemy)
			elseif Wdmg + Rdmg > enemy.health and myHero.mana > Wmana + Rmana then
				CastW(enemy)
				CastR(enemy)
			elseif Qdmg + Rdmg + iDmg > enemy.health and myHero.mana > Qmana + Rmana then
				CastQ(enemy)
				CastR(enemy)
				CastSpell(ignite, enemy)
			elseif Wdmg + Rdmg + iDmg > enemy.health and myHero.mana > Wmana + Rmana then
				CastW(enemy)
				CastR(enemy)
				CastSpell(ignite, enemy)
			elseif Qdmg + Wdmg + Rdmg > enemy.health and myHero.mana > Qmana + Rmana + Wmana then
				CastQ(enemy)
				CastW(enemy)
				CastR(enemy)
			end 
		end 
	end 
end  

function ReturnBestUltTarget(amountOfTargets, flashTrue)
	local targ = nil
	local range = ((flashTrue and 1000) or 575)

	for i, enemy in ipairs(GetEnemyHeroes()) do
		if GetDistance(enemy, myHero) <= range then
			local count = 1
			for i, Tenemy in ipairs(GetEnemyHeroes()) do
				if enemy ~= Tenemy then
					if GetDistance(Tenemy, enemy) < 150 then
						count = count + 1
					end 
				end 
			end

			if count >= amountOfTargets and Menu.autoR.useR[enemy.charName] then
				targ = enemy
				break
			end
		end 
	end 
	return targ
end 

function DrawKillable()
	for i = 1, heroManager.iCount, 1 do
		local enemy = heroManager:getHero(i)
		if ValidTarget(enemy) then
			if enemy.team ~= myHero.team then 
				
				iDmg = ((ignite ~= nil and Iready and getDmg("IGNITE", enemy, myHero)) or 0)

				local Qdmg, Wdmg, Rdmg = CalcSpellDamage(enemy)
				Qdmg = ((Qready and Qdmg) or 0)
				Wdmg = ((Wready and Wdmg) or 0)
				Rdmg = ((Rready and not HaveBuff(myHero, "infernalguardiantimer") and Rdmg) or 0)

                if iDmg > enemy.health then
                	KillText[i] = 1
				elseif Qdmg > enemy.health then
					KillText[i] = 2
				elseif Qdmg + iDmg > enemy.health then
					KillText[i] = 3
				elseif Qdmg + Wdmg > enemy.health then
					KillText[i] = 4
				elseif Qdmg + Wdmg + iDmg > enemy.health then
					KillText[i] = 5
				elseif Qdmg + Wdmg + Rdmg > enemy.health then
					KillText[i] = 6
				elseif Qdmg + Wdmg + Rdmg + iDmg > enemy.health then
					KillText[i] = 7
				else
					KillText[i] = 8
				end 
			end 
		end 
	end 
end

function HaveBuff(unit,buffname)
	local result = false
	for i = 1, unit.buffCount, 1 do 
		if unit:getBuff(i) ~= nil and unit:getBuff(i).name == buffname and unit:getBuff(i).valid and BuffIsValid(unit:getBuff(i)) then 
			result = true 
			break 
		end 
	end 
	return result
end 

function OnCreateObj(object)
    if object.name == "TeleportHome.troy" and GetDistance(object, myHero) < 50 then
    	isRecalling = true
    end 
end 


function OnDeleteObj(object)
    if object.name == "TeleportHome.troy" and GetDistance(object, myHero) < 50 then
    	isRecalling = false
    end 
end
 

function OnApplyBuff(unit, target, buff)
	if unit.isMe and (buff and buff.name and buff.name == "pyromania_particle") then
		canStun = true 
	end

	if unit.isMe and (buff.name == "infernalguardiantimer") then
		hasTibbers = true
	end 

	if unit.isme and (buff.name == "RegenerationPotion") then
		healthPot = true
	end

	if unit.isMe and (buff.name == "FlaskOfCrystalWater") then
		manaPot = true
	end

end

function OnUpdateBuff(unit, buff, stacks)
	if unit and unit.isMe and buff and (buff.name == "pyromania") then
		passiveStacks = stacks
	end 
end

function OnRemoveBuff(unit, buff)
	if unit and unit.isMe and buff and (buff.name == "pyromania") then
		passiveStacks = 0
	end 

	if unit.isMe and (buff and buff.name and buff.name == "pyromania_particle") then
		canStun = true 
	end

	if unit.isMe and (buff.name == "infernalguardiantimer") then
		hasTibbers = false
	end 
	if unit.isme and (buff.name == "RegenerationPotion") then
		healthPot = false
	end
	if unit.isMe and (buff.name == "FlaskOfCrystalWater") then
		manaPot = false
	end

end


function OnProcessSpell(object, spell)
  	if (spell.target == myHero and string.find(spell.name, "BasicAttack")) and object.type == "Obj_AI_Hero" and Menu.misc.Esettings.useEonAttack then
   	 	CastSpell(_E)
  	end


  	if spell.name == "KarthusFallenOne" and object.team ~= myHero.team and Menu.misc.zhonyas.zhonyas then
  		local karthusRdmg = getDmg("R", myHero, object)
  		if karthusRdmg > myHero.health and not myHero.dead then
  			local zSlot = GetInventorySlotItem(3157)
  			if zSlot ~= nil and myHero:CanUseSpell(zSlot) == READY then
				DelayAction(function() if zSlot ~= nil and myHero:CanUseSpell(zSlot) == READY then CastSpell(zSlot) end end, 2) 
			end 
  		end 
  	end 
end


function DrinkPotions()
	health = myHero.health
	mana = myHero.mana
	maxHealth = myHero.maxHealth
	maxMana = myHero.maxMana
	
	DrinkHealth(health, maxHealth)
	DrinkMana(mana, maxMana)
end 

function DrinkHealth(h, mH) 
	if healthPot == true then return end
	local hSlot = GetInventorySlotItem(2003)
	if hSlot ~= nil then
		if (h / mH <= Menu.misc.autopotions.health) then
			CastSpell(hSlot)
		end 
	end 
end 

function DrinkMana(m, mM) 
	if healthPot == true then return end
	local mSlot = GetInventorySlotItem(2004)
	if mSlot ~= nil then
		if (m / mM <= Menu.misc.autopotions.mana) then
			CastSpell(mSlot)
		end 
	end  
end 

function UseHeal()
	health = myHero.health
	maxHealth = myHero.maxHealth

	if Hready then
		if ((health / maxHealth) <= Menu.misc.autoheal.amountOfHealth) then
			CastSpell(heal)
		end 
	end 

	if Menu.misc.autoheal.helpHeal then
		for i, teammate in ipairs(GetAllyHeroes()) do
			if GetDistance(teammate, myHero) <= 700 then
				health = teammate.health
				maxHealth = teammate.maxHealth

				if ((health / maxHealth) <= Menu.misc.autoheal.amountOfHealth) then
					if Hready then
						CastSpell(heal)
					end 
				end 
			end 
		end 
	end 
end 

function UseIgnite()
	local iDmg = (50 + (20 * myHero.level))
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and Menu.misc.autoignite[enemy.charName] then
			if Iready then
				if enemy.health < iDmg then
					CastSpell(ignite, enemy)
				end 
			end 
		end  
	end 
end 


function UseBarrier()
	health = myHero.health
	maxHealth = myHero.maxHealth

	if Bready then
		if ((health / maxHealth) <= Menu.misc.autobarrier.amountOfHealth) then
			CastSpell(barrier)
		end 
	end 
end 


function ManaManager()
	mana = myHero.mana
	if (mana / myHero.maxMana <= Menu.harass.harassMana) then
		return false
	end
	return true 
end 

function AutoLevel()

	if Menu.misc.autolevel.levelAuto == 1 or myHero.level <= lastLevel then return end

	LevelSpell(levelSequences[Menu.misc.autolevel.levelAuto - 1][myHero.level])
	lastLevel = myHero.level

end


function DrawMenu()
	-- Menu
 Menu = scriptConfig("Totally Annie - Totally Legit", "NAnnie")

 -- Combo
 Menu:addSubMenu("Combo", "combo")
 Menu.combo:addParam("comboWay", "Cast Combo", SCRIPT_PARAM_LIST, 1, {"QWR", "WQR", "RQW", "RWQ"})
 Menu.combo:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
 Menu.combo:addParam("disableAA", "Disable AA in Combo", SCRIPT_PARAM_ONOFF, false)
 Menu.combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
 Menu.combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
 Menu.combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
 Menu.combo:addSubMenu("R Usage", "RUsage")
 Menu.combo.RUsage:addParam("howR", "Use R", SCRIPT_PARAM_LIST, 1, {"Normal", "Killable", "Stun"})
 for i, enemy in ipairs(GetEnemyHeroes()) do
	Menu.combo.RUsage:addParam(enemy.charName, "Use R on " .. enemy.charName, SCRIPT_PARAM_ONOFF, true)
 end 

 
 -- Flash Settings --[[ IN PROGRESS ]]
 if flash ~= nil then
 	Menu:addSubMenu("Flash", "flash")
 	Menu.flash:addParam("useFlash", "Use Flash in AutoR", SCRIPT_PARAM_ONOFF, false)
 	Menu.flash:addParam("allies", "Min allies nearby to flash", SCRIPT_PARAM_SLICE, 0, 0, #GetAllyHeroes(), 0)
 	Menu.flash:addParam("alliesrange", "Distance between you and allies", SCRIPT_PARAM_SLICE, 300, 0, 2000, 0)
 	Menu.flash:addParam("enemies", "Max enemies nearby to flash", SCRIPT_PARAM_SLICE, 0, 0, #GetEnemyHeroes(), 0)
 	Menu.flash:addParam("enemiesrange", "Distance target & other enemies", SCRIPT_PARAM_SLICE, 300, 0, 500, 0)
 end 

 -- Auto Ult
 Menu:addSubMenu("Auto R", "autoR")
 Menu.autoR:addParam("autoUlt", "Use Auto Ult", SCRIPT_PARAM_ONOFF, false)
 Menu.autoR:addParam("hitX", "Auto R if hit x enemies", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
 Menu.autoR:addSubMenu("Use R on", "useR")
 for i, enemy in ipairs(GetEnemyHeroes()) do
	Menu.autoR.useR:addParam(enemy.charName, "Auto R on " .. enemy.charName, SCRIPT_PARAM_ONOFF, true)
 end 

 -- Autokill
 Menu:addSubMenu("Auto Kill", "autokill")
 Menu.autokill:addParam("autokill", "Auto Kill - KillSteal", SCRIPT_PARAM_ONOFF, false)
 Menu.autokill:addSubMenu("Use Spells", "spells")
 if ignite ~= nil then
 	Menu.autokill.spells:addParam("autokillIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
 end
 Menu.autokill.spells:addParam("autokillQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
 Menu.autokill.spells:addParam("autokillW", "Use W", SCRIPT_PARAM_ONOFF, true)
 Menu.autokill.spells:addParam("autokillR", "Use R", SCRIPT_PARAM_ONOFF, true)
 Menu.autokill:addSubMenu("Enemies", "enemies")
 for i, enemy in ipairs(GetEnemyHeroes()) do
	Menu.autokill.enemies:addParam(enemy.charName, "Kill " .. enemy.charName, SCRIPT_PARAM_ONOFF, true)
 end 

Menu.autokill:addSubMenu("Optional Settings", "optional")
Menu.autokill.optional:addParam("useOptional", "Use Optional Settings", SCRIPT_PARAM_ONOFF, true)
Menu.autokill.optional:addParam("range", "Range to enemy", SCRIPT_PARAM_SLICE, 575, 0, 600, 0)
Menu.autokill.optional:addParam("enemiesnearby", "Max enemies in that range", SCRIPT_PARAM_SLICE, #GetEnemyHeroes(), 0, #GetEnemyHeroes(), 0)

 -- Harass
 Menu:addSubMenu("Harass", "harass")
 Menu.harass:addParam("harass", "Harass (T)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
 Menu.harass:addParam("harassT", "Harass Toggle (Y)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
 Menu.harass:addParam("harassQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
 Menu.harass:addParam("harassW", "Use W", SCRIPT_PARAM_ONOFF, true)
 Menu.harass:addParam("autoQ", "Auto Q when stuns enemy", SCRIPT_PARAM_ONOFF, false)
 --if VIP_USER then
 --	Menu.harass:addParam("autoQW", "Auto Q/W when W will stun enemy", SCRIPT_PARAM_ONOFF, false)
 --end 
 Menu.harass:addParam("harassMana", "Mana Manager %", SCRIPT_PARAM_SLICE, 0.25, 0, 1, 2)

 -- Farming
 Menu:addSubMenu("Farming", "farm")
 Menu.farm:addParam("farm", "Farming (K)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("K"))
 Menu.farm:addParam("farmQ", "Farm using Q", SCRIPT_PARAM_ONOFF, false)
 Menu.farm:addParam("farmW", "Farm using W", SCRIPT_PARAM_ONOFF, false)
 Menu.farm:addParam("farmStun", "Farm until Stun is up", SCRIPT_PARAM_ONOFF, false)

 -- Jungle Steal
 Menu:addSubMenu("Jungle Steal", "jungle")
 Menu.jungle:addParam("useJungle", "Jungle Steal", SCRIPT_PARAM_ONOFF, false)
 Menu.jungle:addParam("stealBlue", "Steal Blue Buff", SCRIPT_PARAM_ONOFF, false)
 Menu.jungle:addParam("stealRed", "Steal Red Buff", SCRIPT_PARAM_ONOFF, false)
 Menu.jungle:addParam("stealDragon", "Steal Dragon Buff", SCRIPT_PARAM_ONOFF, false)
 Menu.jungle:addParam("stealBaron", "Steal Baron Buff", SCRIPT_PARAM_ONOFF, false)
 Menu.jungle:addSubMenu("Optional Settings", "optional")
 Menu.jungle.optional:addParam("useOptional", "Use Optional Settings", SCRIPT_PARAM_ONOFF, true)
 Menu.jungle.optional:addParam("enemyjungler", "Enemy Jungle Near", SCRIPT_PARAM_ONOFF, true)
 Menu.jungle.optional:addParam("rangeenemyjungler", "Range Enemy Jungler - Monster", SCRIPT_PARAM_SLICE, 200, 0, 1000, 0)
 Menu.jungle.optional:addParam("allyjungler", "Ally Jungle Near", SCRIPT_PARAM_ONOFF, false)
 Menu.jungle.optional:addParam("rangeallyjungler", "Range Ally Jungler - Monster", SCRIPT_PARAM_SLICE, 200, 0, 1000, 0)


 --Drawings
 Menu:addSubMenu("Drawings", "drawings")
 Menu.drawings:addParam("draw", "Drawings", SCRIPT_PARAM_ONOFF, true)
 Menu.drawings:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
 Menu.drawings:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
 Menu.drawings:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
 Menu.drawings:addParam("drawKillable", "Draw Killable Text", SCRIPT_PARAM_ONOFF, true)
 Menu.drawings:addParam("drawDamage", "Draw Damage", SCRIPT_PARAM_ONOFF, true)

 -- Misc
 Menu:addSubMenu("Misc", "misc")
 Menu.misc:addSubMenu("E Settings", "Esettings")
 Menu.misc.Esettings:addParam("procEW", "Use E and W in fountain", SCRIPT_PARAM_ONOFF, false)
 Menu.misc.Esettings:addParam("procE", "Use E to get stacks", SCRIPT_PARAM_ONOFF, false)
 Menu.misc.Esettings:addParam("useEonAttack", "Auto E when attacked", SCRIPT_PARAM_ONOFF, false)
 Menu.misc.Esettings:addParam("info", "CAN NOT BE BOTH ON", SCRIPT_PARAM_INFO, "CAREFUL")

---[[ Temporary disabled
  -- Auto Level
 Menu.misc:addSubMenu("Auto Level", "autolevel")
 Menu.misc.autolevel:addParam("autoLevel", "Auto Level Spells", SCRIPT_PARAM_ONOFF, false)
 Menu.misc.autolevel:addParam("levelAuto", "Auto Level Spells", SCRIPT_PARAM_LIST, 1, { "QWER", "WQER"})
 --]]

 -- Auto Potions
 Menu.misc:addSubMenu("Auto Potions", "autopotions")
 Menu.misc.autopotions:addParam("usePotions", "Drink Potions", SCRIPT_PARAM_ONOFF, true)
 Menu.misc.autopotions:addParam("health", "Health under %", SCRIPT_PARAM_SLICE, 0.25, 0, 1, 2)
 Menu.misc.autopotions:addParam("mana", "Mana under %", SCRIPT_PARAM_SLICE, 0.25, 0, 1, 2)

 Menu.misc:addSubMenu("Zhonyas", "zhonyas")
 Menu.misc.zhonyas:addParam("zhonyas", "Auto Zhonyas", SCRIPT_PARAM_ONOFF, true)
 Menu.misc.zhonyas:addParam("zhonyasunder", "Use Zhonyas under % health", SCRIPT_PARAM_SLICE, 0.20, 0, 1 ,2)

if heal ~= nil then
	Menu.misc:addSubMenu("Auto Heal", "autoheal")
	Menu.misc.autoheal:addParam("useHeal", "Use Summoner Heal", SCRIPT_PARAM_ONOFF, false)
	Menu.misc.autoheal:addParam("amountOfHealth", "Under % of health", SCRIPT_PARAM_SLICE, 0, 0, 1, 2)
	Menu.misc.autoheal:addParam("helpHeal", "Use Heal to save teammates", SCRIPT_PARAM_ONOFF, false)
end 
if ignite ~= nil then
	Menu.misc:addSubMenu("Auto Ignite", "autoignite")
	Menu.misc.autoignite:addParam("useIgnite", "Use Summoner Ignite", SCRIPT_PARAM_ONOFF, true)
 	for i, enemy in ipairs(GetEnemyHeroes()) do
		Menu.misc.autoignite:addParam(enemy.charName, "Use Ignite On " .. enemy.charName, SCRIPT_PARAM_ONOFF, true)
 	end 
end 

if barrier ~= nil then
	Menu.misc:addSubMenu("Auto Barrier", "autobarrier")
	Menu.misc.autobarrier:addParam("useBarrier", "Use Summoner Barrier", SCRIPT_PARAM_ONOFF, false)
	Menu.misc.autobarrier:addParam("amountOfHealth", "Under % of health", SCRIPT_PARAM_SLICE, 0, 0, 1, 2)
end 


  -- Target Selector
  Menu:addTS(ts)
  ts.name = "TargetSelector"

 Menu.misc:addSubMenu("Gapcloser", "gc")
 AntiGapcloser(Menu.misc.gc, castStunGapClosing)
 Menu.misc:addSubMenu("Interrupter", "ai")
 Interrupter(Menu.misc.ai, castStunInterruptable)

 -- Orbwalker to menu
 Menu:addSubMenu("Orbwalker", "orbwalker")

  -- Default Information
 Menu:addParam("Version", "Version", SCRIPT_PARAM_INFO, version)
 Menu:addParam("Author", "Author",  SCRIPT_PARAM_INFO, author)
 
 -- Always show
 Menu.combo:permaShow("combo")
 Menu.harass:permaShow("harass")
 Menu.harass:permaShow("harassT")
 Menu.autokill:permaShow("autokill")
 Menu.farm:permaShow("farm")
 Menu.jungle:permaShow("useJungle")
 Menu.drawings:permaShow("draw")

end

function MenuCheck()
	if Menu.misc.Esettings.procE then
 		Menu.misc.Esettings.useEonAttack = false
 	end
 	if Menu.misc.Esettings.useEonAttack then
 		Menu.misc.Esettings.procE = false
 	end 
end 

-- Gapcloser (SourceLib TriggerCallbacks)
function castStunGapClosing(unit, spell)
	if GetDistance(unit) < 600 and canStun then
		if Qready and Wready then
			CastQ(unit)
		elseif Qready then
			CastQ(unit)
		elseif Wready then
			CastW(unit)
		end
	end 
end 

--Interuptable (SourceLib TriggerCallbacks)
function castStunInterruptable(unit, spell) 
	if GetDistance(unit) < 600 and canStun then
		if Qready and Wready then
			CastQ(unit)
		elseif Qready then
			CastQ(unit)
		elseif Wready then
			CastW(unit)
		end
	end 
end 

-- Return number of Ally in range
function CountAllyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if hero.team == object.team and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function CalcSpellDamage(enemy)

	if not enemy then return end 


	-- Credits to ExtraGoz for Spell Damage Library
	-- I put this in this script myself, so I can modify it myself and so it's not dependant
	-- of the state of the library.
	local damageQ = 35 * myHero:GetSpellData(_Q).level + 45 + .8 * myHero.ap
	local damageW = 45 * myHero:GetSpellData(_W).level + 25 + .85 * myHero.ap
	local damageR = math.max(125 * myHero:GetSpellData(_R).level + 50 + .8 * myHero.ap)
 
	return ((myHero:GetSpellData(_Q).level >= 1 and myHero:CalcMagicDamage(enemy, damageQ)) or 0), ((myHero:GetSpellData(_W).level >= 1 and myHero:CalcMagicDamage(enemy, damageW)) or 0), ((myHero:GetSpellData(_Q).level >= 1 and myHero:CalcMagicDamage(enemy, damageR)) or 0)
end 

-- Thanks BilGod for reducing my code to only 7 lines 
function FindJunglers()
	for i = 1, heroManager.iCount do
		if (heroManager:getHero(i):GetSpellData(SUMMONER_1).name:find("smite") or heroManager:getHero(i):GetSpellData(SUMMONER_2).name:find("smite")) then
			table.insert((heroManager:getHero(i).team == myHero.team and allyJunglers) or enemyJunglers, heroManager:getHero(i))
    	end
	end 
end 

--[[

----- Functions transferred from SourceLib, thanks to Hellsing for his hard work. ----
		I take absolute no credits for the code below
		I do not want to require SourceLib for my script, since it isn't fully needed, as Annie doesn't require skillshots.
		I simply ported useful information to my own script.

		All credits goes to Hellsing and the other people who have worked on SourceLib

--]]
---[[
-- Set enemy bar data
for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }--GetEnemyBarData()--spadge pls
end

function GetEnemyHPBarPos(enemy)

    -- Prevent error spamming
    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end

function DrawIndicator(enemy)
	local Qdmg, Wdmg, Rdmg = CalcSpellDamage(enemy)

	Qdmg = ((Qready and Qdmg) or 0)
	Wdmg = ((Wready and Wdmg) or 0)
	Rdmg = ((Rready and Rdmg) or 0)

    local damage = Qdmg + Wdmg + Rdmg

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    -- Validate data
    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

    DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end 
--]]

--[[

'||'            .                                               .                   
 ||  .. ...   .||.    ....  ... ..  ... ..  ... ...  ... ...  .||.    ....  ... ..  
 ||   ||  ||   ||   .|...||  ||' ''  ||' ''  ||  ||   ||'  ||  ||   .|...||  ||' '' 
 ||   ||  ||   ||   ||       ||      ||      ||  ||   ||    |  ||   ||       ||     
.||. .||. ||.  '|.'  '|...' .||.    .||.     '|..'|.  ||...'   '|.'  '|...' .||.    
                                                      ||                            
                                                     ''''                           

    Interrupter - They will never cast!

    Like alwasy undocumented by honda...
]]
class 'Interrupter'

local _INTERRUPTIBLE_SPELLS = {
    ["KatarinaR"]                          = { charName = "Katarina",     DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["Meditate"]                           = { charName = "MasterYi",     DangerLevel = 1, MaxDuration = 2.5, CanMove = false },
    ["Drain"]                              = { charName = "FiddleSticks", DangerLevel = 3, MaxDuration = 2.5, CanMove = false },
    ["Crowstorm"]                          = { charName = "FiddleSticks", DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["GalioIdolOfDurand"]                  = { charName = "Galio",        DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["MissFortuneBulletTime"]              = { charName = "MissFortune",  DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["VelkozR"]                            = { charName = "Velkoz",       DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["InfiniteDuress"]                     = { charName = "Warwick",      DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["AbsoluteZero"]                       = { charName = "Nunu",         DangerLevel = 4, MaxDuration = 2.5, CanMove = false },
    ["ShenStandUnited"]                    = { charName = "Shen",         DangerLevel = 3, MaxDuration = 2.5, CanMove = false },
    ["FallenOne"]                          = { charName = "Karthus",      DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["AlZaharNetherGrasp"]                 = { charName = "Malzahar",     DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    ["Pantheon_GrandSkyfall_Jump"]         = { charName = "Pantheon",     DangerLevel = 5, MaxDuration = 2.5, CanMove = false },

}

function Interrupter:__init(menu, cb)

    self.callbacks = {}
    self.activespells = {}
    AddTickCallback(function() self:OnTick() end)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    if menu then
        self:AddToMenu(menu)
    end
    if cb then
        self:AddCallback(cb)
    end

end

function Interrupter:AddToMenu(menu)

    assert(menu, "Interrupter: menu can't be nil!")
    local SpellAdded = false
    local EnemyChampioncharNames = {}
    for i, enemy in ipairs(GetEnemyHeroes()) do
        table.insert(EnemyChampioncharNames, enemy.charName)
    end
    menu:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
    for spellName, data in pairs(_INTERRUPTIBLE_SPELLS) do
        if table.contains(EnemyChampioncharNames, data.charName) then
            menu:addParam(string.gsub(spellName, "_", ""), data.charName.." - "..spellName, SCRIPT_PARAM_ONOFF, true)
            SpellAdded = true
        end
    end
    if not SpellAdded then
        menu:addParam("Info", "Info", SCRIPT_PARAM_INFO, "No spell available to interrupt")
    end
    self.Menu = menu

end

function Interrupter:AddCallback(cb)

    assert(cb and type(cb) == "function", "Interrupter: callback is invalid!")
    table.insert(self.callbacks, cb)

end

function Interrupter:TriggerCallbacks(unit, spell)

    for i, callback in ipairs(self.callbacks) do
        callback(unit, spell)
    end

end

function Interrupter:OnProcessSpell(unit, spell)

    if not self.Menu.Enabled then return end
    if unit.team ~= myHero.team then
        if _INTERRUPTIBLE_SPELLS[spell.name] then
            local SpellToInterrupt = _INTERRUPTIBLE_SPELLS[spell.name]
            if (self.Menu and self.Menu[string.gsub(spell.name, "_", "")]) or not self.Menu then
                local data = {unit = unit, DangerLevel = SpellToInterrupt.DangerLevel, endT = os.clock() + SpellToInterrupt.MaxDuration, CanMove = SpellToInterrupt.CanMove}
                table.insert(self.activespells, data)
                self:TriggerCallbacks(data.unit, data)
            end
        end
    end

end

function Interrupter:OnTick()

    for i = #self.activespells, 1, -1 do
        if self.activespells[i].endT - os.clock() > 0 then
            self:TriggerCallbacks(self.activespells[i].unit, self.activespells[i])
        else
            table.remove(self.activespells, i)
        end
    end

end


--[[

    |                .    ||   ..|'''.|                           '||                                 
   |||    .. ...   .||.  ...  .|'     '   ....   ... ...    ....   ||    ...    ....    ....  ... ..  
  |  ||    ||  ||   ||    ||  ||    .... '' .||   ||'  || .|   ''  ||  .|  '|. ||. '  .|...||  ||' '' 
 .''''|.   ||  ||   ||    ||  '|.    ||  .|' ||   ||    | ||       ||  ||   || . '|.. ||       ||     
.|.  .||. .||. ||.  '|.' .||.  ''|...'|  '|..'|'  ||...'   '|...' .||.  '|..|' |'..|'  '|...' .||.    
                                                  ||                                                  
                                                 ''''                                                 

    AntiGapcloser - Stay away please, thanks.

    And again undocumented by honda -.-
]]
class 'AntiGapcloser'

local _GAPCLOSER_TARGETED, _GAPCLOSER_SKILLSHOT = 1, 2
--Add only very fast skillshots/targeted spells since vPrediction will handle the slow dashes that will trigger OnDash
local _GAPCLOSER_SPELLS = {
    ["AatroxQ"]              = "Aatrox",
    ["AkaliShadowDance"]     = "Akali",
    ["Headbutt"]             = "Alistar",
    ["FioraQ"]               = "Fiora",
    ["DianaTeleport"]        = "Diana",
    ["EliseSpiderQCast"]     = "Elise",
    ["FizzPiercingStrike"]   = "Fizz",
    ["GragasE"]              = "Gragas",
    ["HecarimUlt"]           = "Hecarim",
    ["JarvanIVDragonStrike"] = "JarvanIV",
    ["IreliaGatotsu"]        = "Irelia",
    ["JaxLeapStrike"]        = "Jax",
    ["KhazixE"]              = "Khazix",
    ["khazixelong"]          = "Khazix",
    ["LeblancSlide"]         = "LeBlanc",
    ["LeblancSlideM"]        = "LeBlanc",
    ["BlindMonkQTwo"]        = "LeeSin",
    ["LeonaZenithBlade"]     = "Leona",
    ["UFSlash"]              = "Malphite",
    ["Pantheon_LeapBash"]    = "Pantheon",
    ["PoppyHeroicCharge"]    = "Poppy",
    ["RenektonSliceAndDice"] = "Renekton",
    ["RivenTriCleave"]       = "Riven",
    ["SejuaniArcticAssault"] = "Sejuani",
    ["slashCast"]            = "Tryndamere",
    ["ViQ"]                  = "Vi",
    ["MonkeyKingNimbus"]     = "MonkeyKing",
    ["XenZhaoSweep"]         = "XinZhao",
    ["YasuoDashWrapper"]     = "Yasuo"
}

function AntiGapcloser:__init(menu, cb)

    self.callbacks = {}
    self.activespells = {}
    AddTickCallback(function() self:OnTick() end)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    if menu then
        self:AddToMenu(menu)
    end
    if cb then
        self:AddCallback(cb)
    end

end

function AntiGapcloser:AddToMenu(menu)

    assert(menu, "AntiGapcloser: menu can't be nil!")
    local SpellAdded = false
    local EnemyChampioncharNames = {}
    for i, enemy in ipairs(GetEnemyHeroes()) do
        table.insert(EnemyChampioncharNames, enemy.charName)
    end
    menu:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
    for spellName, charName in pairs(_GAPCLOSER_SPELLS) do
        if table.contains(EnemyChampioncharNames, charName) then
            menu:addParam(string.gsub(spellName, "_", ""), charName.." - "..spellName, SCRIPT_PARAM_ONOFF, true)
            SpellAdded = true
        end
    end
    if not SpellAdded then
        menu:addParam("Info", "Info", SCRIPT_PARAM_INFO, "No spell available to interrupt")
    end
    self.Menu = menu

end

function AntiGapcloser:AddCallback(cb)

    assert(cb and type(cb) == "function", "AntiGapcloser: callback is invalid!")
    table.insert(self.callbacks, cb)

end

function AntiGapcloser:TriggerCallbacks(unit, spell)

    for i, callback in ipairs(self.callbacks) do
        callback(unit, spell)
    end

end

function AntiGapcloser:OnProcessSpell(unit, spell)

    if not self.Menu.Enabled then return end
    if unit.team ~= myHero.team then
        if _GAPCLOSER_SPELLS[spell.name] then
            local Gapcloser = _GAPCLOSER_SPELLS[spell.name]
            if (self.Menu and self.Menu[string.gsub(spell.name, "_", "")]) or not self.Menu then
                local add = false
                if spell.target and spell.target.isMe then
                    add = true
                    startPos = Vector(unit.visionPos)
                    endPos = myHero
                elseif not spell.target then
                    local endPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                    local endPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
                    --TODO check angles etc
                    if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
                        add = true
                    end
                end

                if add then
                    local data = {unit = unit, spell = spell.name, startT = os.clock(), endT = os.clock() + 1, startPos = startPos, endPos = endPos}
                    table.insert(self.activespells, data)
                    self:TriggerCallbacks(data.unit, data)
                end
            end
        end
    end

end

function AntiGapcloser:OnTick()

    for i = #self.activespells, 1, -1 do
        if self.activespells[i].endT - os.clock() > 0 then
            self:TriggerCallbacks(self.activespells[i].unit, self.activespells[i])
        else
            table.remove(self.activespells, i)
        end
    end

end

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("UHKIINIOMHJ") 