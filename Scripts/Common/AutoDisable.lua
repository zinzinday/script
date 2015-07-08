--[[
Auto Disable (Advanced) v1.0 by Barasia283
]]
KEY_DOWN = 0x100
KEY_UP = 0x101
player = GetMyHero()
disablekey = 56 -- 8
DisablescriptActive = false
disablecharexist = false

function DisableSpell(from,name,level,posStart,posEnd)
--[[ Channel spell names "CaitlynAceintheHole" "Crowstorm" "Drain" "ReapTheWhirlwind" "FallenOne" "DeathLotus" "AlZaharNetherGrasp" "GalioIdolOfDurand"
"Meditate" "MissFortuneBulletTime" "AbsoluteZero" "Pantheon_Heartseeker" "Pantheon_GrandSkyfall_Jump" "ShenStandUnited" "gate" "UrgotSwap2"
"InfiniteDuress" "VarusQ]]
			if disablecharexist == true and DisablescriptActive == true and from.team ~= player.team and from.dead == false and player:GetDistance(from) <= disablerange and player:CanUseSpell(disablespellslot) == READY 
			and (string.find(name, "CaitlynAceintheHole")~= nil or string.find(name, "Crowstorm")~= nil or string.find(name, "Drain")~= nil or
			string.find(name, "ReapTheWhirlwind")~= nil or string.find(name, "FallenOne")~= nil or string.find(name, "DeathLotus")~= nil or
			 string.find(name, "DeathLotus")~= nil or string.find(name, "AlZaharNetherGrasp")~= nil or string.find(name, "GalioIdolOfDurand")~= nil or
			  string.find(name, "Meditate")~= nil or string.find(name, "MissFortuneBulletTime")~= nil or string.find(name, "AbsoluteZero")~= nil or
			   string.find(name, "Pantheon_Heartseeker")~= nil or string.find(name, "Pantheon_GrandSkyfall_Jump")~= nil or string.find(name, "ShenStandUnited")~= nil or
			    string.find(name, "gate")~= nil or string.find(name, "UrgotSwap2")~= nil or string.find(name, "InfiniteDuress")~= nil or string.find(name, "VarusQ")~= nil) then
    				   		if disabletype == 1 then
								CastSpell(disablespellslot, from)
							elseif disabletype == 2 then
								CastSpell(disablespellslot)
							elseif disabletype == 3 then
								CastSpell(disablespellslot, from.x, from.z)
							elseif disabletype == 4 then
								CastSpell(disablespellslot)
								player:Attack(from)
							elseif disabletype == 5 then
								CastSpell(disablespellslot, from.x, from.z)
								CastSpell(disablespellslot, from.x, from.z)	
							elseif disabletype == 6 then
								if player:CanUseSpell(jarvanspellslot) == READY then
								CastSpell(jarvanspellslot, from.x, from.z)
								CastSpell(disablespellslot, from.x, from.z)
								end
							elseif disabletype == 7 then
								if player:CanUseSpell(maokaispellslot) == READY then
								CastSpell(disablespellslot, from)
								CastSpell(maokaispellslot, from.x, from.z)
								end
							end
				
    		end
end

function DisableHotkey(msg,key)
if disablecharexist == true then
    	if msg == KEY_UP and key == disablekey then
        	if DisablescriptActive == false then
           	 	DisablescriptActive = true
           	 	PrintChat("<font color='#7CFC00'> >>Auto Disable On!</font>")
       		 else
           		 PrintChat("<font color='#FF4500'> >>Auto Disable Off!</font>")
           		 DisablescriptActive=false
       		 end
   		end
end
end

function loadautodisable()
		if player.charName == "Alistar" then
		disablerange = 650
		disablespellslot = _W
		disabletype = 1
		PrintChat(" >> Auto Disable Alistar!") 
		disablecharexist = true
		elseif player.charName == "Blitzcrank" then
    	disablerange = 600
		disablespellslot = _R
		disabletype = 2
		PrintChat(" >> Auto Disable Blitzcrank!") 
		disablecharexist = true
		elseif player.charName == "ChoGath" then
    	disablerange = 600
		disablespellslot = _W
		disabletype = 3
		PrintChat(" >> Auto Disable ChoGath!") 
		disablecharexist = true
		elseif player.charName == "Darius" then
    	disablerange = 450
		disablespellslot = _E
		disabletype = 3
		PrintChat(" >> Auto Disable Darius!") 
		disablecharexist = true
		elseif player.charName == "Draven" then
    	disablerange = 900
		disablespellslot = _E
		disabletype = 3
		PrintChat(" >> Auto Disable Draven!") 
		disablecharexist = true
		elseif player.charName == "FiddleSticks" then
    	disablerange = 750
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable FiddleSticks!") 
		disablecharexist = true
		elseif player.charName == "Galio" then
    	disablerange = 600
		disablespellslot = _R
		disabletype = 2
		PrintChat(" >> Auto Disable Galio!") 
		disablecharexist = true
		elseif player.charName == "Garen" then
    	disablerange = 500
		disablespellslot = _Q
		disabletype = 4
		PrintChat(" >> Auto Disable Garen!") 
		disablecharexist = true
		elseif player.charName == "Hecarim" then
    	disablerange = 500
		disablespellslot = _E
		disabletype = 4
		PrintChat(" >> Auto Disable Hecarim!") 
		disablecharexist = true
		elseif player.charName == "Janna" then
    	disablerange = 1100
		disablespellslot = _Q
		disabletype = 5
		PrintChat(" >> Auto Disable Janna!") 
		disablecharexist = true
		elseif player.charName == "JarvanIV" then
    	disablerange = 770
		disablespellslot = _Q
		jarvanspellslot = _E
		disabletype = 6
		PrintChat(" >> Auto Disable JarvanIV!") 
		disablecharexist = true
		elseif player.charName == "Kassadin" then
    	disablerange = 650
		disablespellslot = _Q
		disabletype = 1
		PrintChat(" >> Auto Disable Kassadin!") 
		disablecharexist = true
		elseif player.charName == "LeeSin" then
    	disablerange = 375
		disablespellslot = _R
		disabletype = 1
		PrintChat(" >> Auto Disable LeeSin!")
		disablecharexist = true
		elseif player.charName == "Leona" then
    	disablerange = 400
		disablespellslot = _Q
		disabletype = 4
		PrintChat(" >> Auto Disable Leona!")
		disablecharexist = true
		elseif player.charName == "Lulu" then
    	disablerange = 650
		disablespellslot = _W
		disabletype = 1
		PrintChat(" >> Auto Disable Lulu!")
		disablecharexist = true
		elseif player.charName == "Malphite" then
    	disablerange = 1000
		disablespellslot = _R
		disabletype = 3
		PrintChat(" >> Auto Disable Malphite!")
		disablecharexist = true
		elseif player.charName == "Malzahar" then
    	disablerange = 900
		disablespellslot = _Q
		disabletype = 3
		PrintChat(" >> Auto Disable Malzahar!")
		disablecharexist = true
		elseif player.charName == "Maokai" then
    	disablerange = 650
		disablespellslot = _W
		maokaispellslot = _Q
		disabletype = 7
		PrintChat(" >> Auto Disable Maokai!")
		disablecharexist = true
		elseif player.charName == "Nautilus" then
    	disablerange = 950
		disablespellslot = _Q
		disabletype = 3
		PrintChat(" >> Auto Disable Nautilus!")
		disablecharexist = true
		elseif player.charName == "Pantheon" then
    	disablerange = 600
		disablespellslot = _W
		disabletype = 1
		PrintChat(" >> Auto Disable Pantheon!")
		disablecharexist = true
		elseif player.charName == "Poppy" then
    	disablerange = 525
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Poppy!")
		disablecharexist = true
		elseif player.charName == "Rammus" then
    	disablerange = 325
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Rammus!")
		disablecharexist = true
		elseif player.charName == "Riven" then
    	disablerange = 250
		disablespellslot = _W
		disabletype = 2
		PrintChat(" >> Auto Disable Riven!")
		disablecharexist = true
		elseif player.charName == "Shen" then
    	disablerange = 600
		disablespellslot = _E
		disabletype = 3
		PrintChat(" >> Auto Disable Shen!")
		disablecharexist = true
		elseif player.charName == "Shyvana" then
    	disablerange = 1000
		disablespellslot = _R
		disabletype = 3
		PrintChat(" >> Auto Disable Shyvana!")
		disablecharexist = true
		elseif player.charName == "Singed" then
    	disablerange = 500
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Singed!") 
		disablecharexist = true
		elseif player.charName == "Sion" then
    	disablerange = 600
		disablespellslot = _Q
		disabletype = 1
		PrintChat(" >> Auto Disable Sion!") 
		disablecharexist = true
		elseif player.charName == "Sona" then
    	disablerange = 600
		disablespellslot = _R
		disabletype = 3
		PrintChat(" >> Auto Disable Sona!") 
		disablecharexist = true
		elseif player.charName == "Soraka" then
    	disablerange = 725
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Soraka!") 
		disablecharexist = true
		elseif player.charName == "Talon" then
    	disablerange = 700
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Talon!") 
		disablecharexist = true
		elseif player.charName == "Taric" then
    	disablerange = 625
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Taric!")
		disablecharexist = true
		elseif player.charName == "Tristana" then
    	disablerange = 700
		disablespellslot = _R
		disabletype = 1
		PrintChat(" >> Auto Disable Tristana!")
		disablecharexist = true 
		elseif player.charName == "Udyr" then
    	disablerange = 500
		disablespellslot = _E
		disabletype = 4
		PrintChat(" >> Auto Disable Udyr!") 
		disablecharexist = true
		elseif player.charName == "Vayne" then
    	disablerange = 450
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Vayne!") 
		disablecharexist = true
		elseif player.charName == "Viktor" then
    	disablerange = 700
		disablespellslot = _W
		disabletype = 3
		PrintChat(" >> Auto Disable Viktor!")
		disablecharexist = true
		elseif player.charName == "Volibear" then
    	disablerange = 500
		disablespellslot = _Q
		disabletype = 4
		PrintChat(" >> Auto Disable Volibear!") 
		disablecharexist = true
		elseif player.charName == "Warwick" then
    	disablerange = 700
		disablespellslot = _R
		disabletype = 1
		PrintChat(" >> Auto Disable Warwick!")
		disablecharexist = true
		elseif player.charName == "MonkeyKing" then
    	disablerange = 325
		disablespellslot = _R
		disabletype = 2
		PrintChat(" >> Auto Disable MonkeyKing!")
		disablecharexist = true
		elseif player.charName == "Xerath" then
    	disablerange = 1000
		disablespellslot = _E
		disabletype = 1
		PrintChat(" >> Auto Disable Xerath!")
		disablecharexist = true
    	else
    	PrintChat(" >> No Disable character!")
		end
		if disablecharexist == true then
		PrintChat(" >> Press '8' toggle Auto disable (its OFF by default!).")
		end
end
loadautodisable()
BoL:addMsgHandler(DisableHotkey); --msgHandler(msg,wParam)
BoL:addProcessSpellHandler(DisableSpell); --processSpellHandler(from,name,level,posStart,posEnd)


--UPDATEURL=
--HASH=29793B5A9ADCF3A782D0C03D7C50335B
