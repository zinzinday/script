--[[
	Spell Damage Library 1.48
		by eXtragoZ
		
		Is designed to calculate the damage of the skills to champions, although most of the calculations
		work for creeps
			
-------------------------------------------------------	
	Usage:

		local target = heroManager:getHero(2)
		local damage, TypeDmg = getDmg("R",target,myHero,3)	
-------------------------------------------------------
	Full function:
		getDmg("SKILL",target,owner,stagedmg,spelllvl)
		
	Returns:
		damage, TypeDmg
		
		TypeDmg:
			1	Normal damage
			2	Attack damage and on hit passives needs to be added to the damage
		
		Skill:			(in capitals!)
			"P"				-Passive
			"Q"
			"W"
			"E"
			"R"
			"QM"			-Q in melee form (Jayce, Nidalee and Elise only)
			"WM"			-W in melee form (Jayce, Nidalee and Elise only)
			"EM"			-E in melee form (Jayce, Nidalee and Elise only)
			"AD"			-Attack damage
			"IGNITE"		-Ignite
			"DFG"			-Deathfire Grasp
			"HXG"			-Hextech Gunblade
			"BWC"			-Bilgewater Cutlass
			"KITAES"		-Kitae's Bloodrazor
			"WITSEND"		-Wit's End
			"SHEEN"			-Sheen
			"TRINITY"		-Trinity Force 
			"LICHBANE"		-Lich Bane
			"LIANDRYS"		-Liandry's Torment
			"BLACKFIRE"		-Blackfire Torch
			"STATIKK"		-Statikk Shiv
			"ICEBORN"		-Iceborn Gauntlet
			"TIAMAT"		-Tiamat
			"HYDRA"			-Ravenous Hydra
			"RUINEDKING"	-Blade of the Ruined King
			"MURAMANA"		-Muramana
			"HURRICANE"		-Runaan's Hurricane
			"SPIRITLIZARD"	-Spirit of the Elder Lizard
			"SUNFIRE"		-Sunfire Cape
			"LIGHTBRINGER"	-Lightbringer
			"NTOOTH"		-Nashor's Tooth
			"MOUNTAIN"		-Face of the Mountain
			
		Removed (returns 0):
			"MADREDS"		-Madred's Bloodrazor
			"ISPARK"		-Ionic Spark
			"EXECUTIONERS"	-Executioner's Calling
			"MALADY"		-Malady
			
		Stagedmg:
			nil	Active or first instance of dmg
			1	Active or first instance of dmg
			2	Passive or second instance of dmg
			3	Max damage or third instance of dmg
			
		-Returns the damage they will do "owner" to "target" with the "skill"
		-With some skills returns a percentage of increased damage
		-Many skills are shown per second, hit and other
		-Use spelllvl only if you want to specify the level of skill
		
]]--

function getDmg(spellname,target,owner,stagedmg,spelllvl)
	local name = owner.charName
	local lvl = owner.level
	local ap = owner.ap
	local ad = owner.totalDamage
	local bad = owner.addDamage
	local ar = owner.armor
	local mmana = owner.maxMana
	local mana = owner.mana
	local mhp = owner.maxHealth
	local tap = target.ap
	local thp = target.health
	local tmhp = target.maxHealth
	local Qlvl = spelllvl and spelllvl or owner:GetSpellData(_Q).level
	local Wlvl = spelllvl and spelllvl or owner:GetSpellData(_W).level
	local Elvl = spelllvl and spelllvl or owner:GetSpellData(_E).level
	local Rlvl = spelllvl and spelllvl or owner:GetSpellData(_R).level
	local stagedmg1,stagedmg2,stagedmg3 = 1,0,0
	if stagedmg == 2 then stagedmg1,stagedmg2,stagedmg3 = 0,1,0
	elseif stagedmg == 3 then stagedmg1,stagedmg2,stagedmg3 = 0,0,1 end
	local TrueDmg = 0
	local TypeDmg = 1 --1 ability/normal--2 bonus to attack
	if ((spellname == "Q" or spellname == "QM") and Qlvl == 0) or ((spellname == "W" or spellname == "WM") and Wlvl == 0) or ((spellname == "E" or spellname == "EM") and Elvl == 0) or (spellname == "R" and Rlvl == 0) then
		TrueDmg = 0
	elseif spellname == "Q" or spellname == "W" or spellname == "E" or spellname == "R" or spellname == "P" or spellname == "QM" or spellname == "WM" or spellname == "EM" then
		local DmgM = 0
		local DmgP = 0
		local DmgT = 0
		if name == "Aatrox" then
			if spellname == "Q" then DmgP = 45*Qlvl+25+.6*bad
			elseif spellname == "W" then DmgP = (35*Wlvl+25+bad)*(stagedmg1+stagedmg3) TypeDmg = 2
			elseif spellname == "E" then DmgM = 35*Elvl+40+.6*ap+.6*bad
			elseif spellname == "R" then DmgM = 100*Rlvl+100+ap
			end
		elseif name == "Ahri" then
			if spellname == "Q" then DmgM = (25*Qlvl+15+.35*ap)*(stagedmg1+stagedmg3) DmgT = (25*Qlvl+15+.35*ap)*(stagedmg2+stagedmg3) -- stage1:Initial. stage2:way back. stage3:total.
			elseif spellname == "W" then DmgM = math.max(25*Wlvl+15+.4*ap,(25*Wlvl+15+.4*ap)*1.6*stagedmg3) -- xfox-fires ,  30% damage from each additional fox-fire beyond the first. stage3: Max damage
			elseif spellname == "E" then DmgM = 30*Elvl+30+.35*ap --Enemies hit by Charm take 20% increased damage from Ahri for 6 seconds
			elseif spellname == "R" then DmgM = 40*Rlvl+30+.3*ap -- xbolt (3 bolts)
			end
		elseif name == "Akali" then
			if spellname == "P" then DmgM = (6+.1666667*ap)*ad/100
			elseif spellname == "Q" then DmgM = math.max((20*Qlvl+15+.4*ap)*stagedmg1,(25*Qlvl+20+.5*ap)*stagedmg2,(45*Qlvl+35+.9*ap)*stagedmg3) --stage1:Initial. stage2:Detonation. stage3:Max damage
			elseif spellname == "E" then DmgP = 25*Elvl+5+.3*ap+.6*ad
			elseif spellname == "R" then DmgM = 75*Rlvl+25+.5*ap
			end
		elseif name == "Alistar" then
			if spellname == "P" then DmgM = math.max(6+lvl+.1*ap,(6+lvl+.1*ap)*3*stagedmg3)
			elseif spellname == "Q" then DmgM = 45*Qlvl+15+.5*ap
			elseif spellname == "W" then DmgM = 55*Wlvl+.7*ap
			end
		elseif name == "Amumu" then
			if spellname == "Q" then DmgM = 50*Qlvl+30+.7*ap
			elseif spellname == "W" then DmgM = ((.5*Wlvl+.5+.01*ap)*tmhp/100)+4*Wlvl+4 --xsec
			elseif spellname == "E" then DmgM = 25*Elvl+50+.5*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.8*ap
			end
		elseif name == "Anivia" then
			if spellname == "Q" then DmgM = math.max(30*Qlvl+30+.5*ap,(30*Qlvl+30+.5*ap)*2*stagedmg3) -- x2 if it detonates. stage3: Max damage
			elseif spellname == "E" then DmgM = math.max(30*Elvl+25+.5*ap,(30*Elvl+25+.5*ap)*2*stagedmg3) -- x2  If the target has been chilled. stage3: Max damage
			elseif spellname == "R" then DmgM = 40*Rlvl+40+.25*ap --xsec
			end
		elseif name == "Annie" then
			if spellname == "Q" then DmgM = 35*Qlvl+45+.8*ap
			elseif spellname == "W" then DmgM = 45*Wlvl+25+.85*ap
			elseif spellname == "E" then DmgM = 10*Elvl+10+.2*ap --x each attack suffered
			elseif spellname == "R" then DmgM = math.max((125*Rlvl+50+.8*ap)*stagedmg1,(35+.2*ap)*stagedmg2,(125*Rlvl+50+.8*ap)*stagedmg3) DmgP = (25*Rlvl+55)*stagedmg2 --stage1:Summon Tibbers . stage2:Aura AoE xsec + 1 Tibbers Attack. stage3:Summon Tibbers
			end
		elseif name == "Ashe" then
			if spellname == "Q" then TypeDmg = 2
			elseif spellname == "W" then DmgP = 10*Wlvl+30+ad
			elseif spellname == "R" then DmgM = 175*Rlvl+75+ap
			end
		elseif name == "Azir" then
			if spellname == "Q" then DmgM = 30*Qlvl+45+.5*ap --beyond the first will deal only 25% damage
			elseif spellname == "W" then DmgM = math.max(5*lvl+45,10*lvl-10)+.6*ap--after the first deals 25% damage
			elseif spellname == "E" then DmgM = 30*Qlvl+30+.4*ap
			elseif spellname == "R" then DmgM = 75*Rlvl+75+.6*ap
			end
		elseif name == "Blitzcrank" then
			if spellname == "Q" then DmgM = 55*Qlvl+25+ap
			elseif spellname == "E" then DmgP = ad TypeDmg = 2
			elseif spellname == "R" then DmgM = math.max((125*Rlvl+125+ap)*stagedmg1,(100*Rlvl+.2*ap)*stagedmg2,(125*Rlvl+125+ap)*stagedmg3) --stage1:the active. stage2:the passive. stage3:the active
			end
		elseif name == "Brand" then
			if spellname == "P" then DmgM = math.max(2*tmhp/100,(2*tmhp/100)*4*stagedmg3) --xsec (4sec). stage3: Max damage
			elseif spellname == "Q" then DmgM = 40*Qlvl+40+.65*ap
			elseif spellname == "W" then DmgM = math.max(45*Wlvl+30+.6*ap,(45*Wlvl+30+.6*ap)*1.25*stagedmg3) --125% for units that are ablaze. stage3: Max damage
			elseif spellname == "E" then DmgM = 35*Elvl+35+.55*ap
			elseif spellname == "R" then DmgM = math.max(100*Rlvl+50+.5*ap,(100*Rlvl+50+.5*ap)*3*stagedmg3) --xbounce (can hit the same enemy up to three times). stage3: Max damage
			end
		elseif name == "Braum" then
			if spellname == "P" then DmgM = math.max((8*lvl+32)*(stagedmg1+stagedmg3),(2*lvl+12)*stagedmg2) --stage1-stage3:Stun. stage2:bonus damage.
			elseif spellname == "Q" then DmgM = 45*Qlvl+15+.025*mhp
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.6*ap
			end
		elseif name == "Caitlyn" then
			if spellname == "P" then DmgP = .5*ad TypeDmg = 2 --xheadshot (bonus)
			elseif spellname == "Q" then DmgP = 40*Qlvl-20+1.3*ad --deal 10% less damage for each subsequent target hit, down to a minimum of 50%
			elseif spellname == "W" then DmgM = 50*Wlvl+30+.6*ap
			elseif spellname == "E" then DmgM = 50*Elvl+30+.8*ap
			elseif spellname == "R" then DmgP = 225*Rlvl+25+2*bad
			end
		elseif name == "Cassiopeia" then
			if spellname == "Q" then DmgM = 40*Qlvl+35+.45*ap
			elseif spellname == "W" then DmgM = 5*Wlvl+5+.1*ap --xsec
			elseif spellname == "E" then DmgM = 25*Elvl+30+.55*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.5*ap
			end
		elseif name == "Chogath" then
			if spellname == "Q" then DmgM = 56.25*Qlvl+23.75+ap
			elseif spellname == "W" then DmgM = 50*Wlvl+25+.7*ap
			elseif spellname == "E" then DmgM = 15*Elvl+5+.3*ap TypeDmg = 2 --xhit (bonus)
			elseif spellname == "R" then DmgT = 175*Rlvl+125+.7*ap
			end
		elseif name == "Corki" then
			if spellname == "P" then DmgT = .1*ad TypeDmg = 2 --xhit (bonus)
			elseif spellname == "Q" then DmgM = 50*Qlvl+30+.5*bad+.5*ap
			elseif spellname == "W" then DmgM = 30*Wlvl+30+.4*ap --xsec (2.5 sec)
			elseif spellname == "E" then DmgP = 12*Elvl+8+.4*bad --xsec (4 sec)
			elseif spellname == "R" then DmgM = math.max(70*Rlvl+50+.3*ap+(.1*Rlvl+.1)*ad,(70*Rlvl+50+.3*ap+(.1*Rlvl+.1)*ad)*1.5*stagedmg3) --150% the big one. stage3: Max damage
			end
		elseif name == "Darius" then
			if spellname == "P" then DmgM = (-.75)*((-1)^lvl-2*lvl-13)+.3*bad --xstack over 5 sec
			elseif spellname == "Q" then DmgP = math.max(35*Qlvl+35+.7*bad,(35*Qlvl+35+.7*bad)*1.5*stagedmg3) --150% Champions in the outer half. stage3: Max damage
			elseif spellname == "W" then DmgP = .2*Wlvl*ad TypeDmg = 2 --(bonus)
			elseif spellname == "R" then DmgT = math.max(90*Rlvl+70+.75*bad,(90*Rlvl+70+.75*bad)*2*stagedmg3) --xstack of Hemorrhage deals an additional 20% damage. stage3: Max damage
			end
		elseif name == "Diana" then
			if spellname == "P" then DmgM = math.max(5*lvl+15,10*lvl-10,15*lvl-60,20*lvl-125,25*lvl-200)+.8*ap TypeDmg = 2 -- (bonus)
			elseif spellname == "Q" then DmgM = 35*Qlvl+25+.7*ap
			elseif spellname == "W" then DmgM = math.max(12*Wlvl+10+.2*ap,(12*Wlvl+10+.2*ap)*3*stagedmg3) --xOrb (3 orbs). stage3: Max damage
			elseif spellname == "R" then DmgM = 60*Rlvl+40+.6*ap
			end
		elseif name == "DrMundo" then
			if spellname == "Q" then DmgM = math.max((2.5*Qlvl+12.5)*thp/100,50*Qlvl+30)
			elseif spellname == "W" then DmgM = 15*Wlvl+20+.2*ap --xsec
			end
		elseif name == "Draven" then
			if spellname == "P" then DmgP = (.1*Qlvl+.35)*ad TypeDmg = 2 --xhit (bonus)
			elseif spellname == "E" then DmgP = 35*Elvl+35+.5*bad
			elseif spellname == "R" then DmgP = 100*Rlvl+75+1.1*bad --xhit (max 2 hits), deals 8% less damage for each unit hit, down to a minimum of 40%
			end
		elseif name == "Elise" then
			if spellname == "P" then DmgM = 10*Rlvl+.1*ap --xhit Spiderling Damage
			elseif spellname == "Q" then DmgM = 35*Qlvl+5+(8+.03*ap)*thp/100
			elseif spellname == "QM" then DmgM = 40*Qlvl+20+(8+.03*ap)*(tmhp-thp)/100
			elseif spellname == "W" then DmgM = 50*Wlvl+25+.8*ap
			elseif spellname == "R" then DmgM = 10*Rlvl+.3*ap TypeDmg = 2 --xhit (bonus)
			end
		elseif name == "Evelynn" then
			if spellname == "Q" then DmgM = 15*Qlvl+15+(.05*Qlvl+.3)*ap+(.05*Qlvl+.45)*bad
			elseif spellname == "E" then DmgP = 40*Elvl+30+ap+bad --total
			elseif spellname == "R" then DmgM = (5*Rlvl+10+.01*ap)*thp/100
			end
		elseif name == "Ezreal" then
			if spellname == "Q" then DmgP = 20*Qlvl+15+.4*ap+.1*ad TypeDmg = 2 -- (bonus)
			elseif spellname == "W" then DmgM = 45*Wlvl+25+.7*ap
			elseif spellname == "E" then DmgM = 50*Elvl+25+.75*ap
			elseif spellname == "R" then DmgM = 150*Rlvl+200+.9*ap+bad --deal 10% less damage for each subsequent target hit, down to a minimum of 30%
			end
		elseif name == "FiddleSticks" then
			if spellname == "W" then DmgM = math.max(30*Wlvl+30+.45*ap,(30*Wlvl+30+.45*ap)*5*stagedmg3) --xsec (5 sec). stage3: Max damage
			elseif spellname == "E" then DmgM = math.max(20*Elvl+45+.45*ap,(20*Elvl+45+.45*ap)*3*stagedmg3) --xbounce. stage3: Max damage
			elseif spellname == "R" then DmgM = math.max(100*Rlvl+25+.45*ap,(100*Rlvl+25+.45*ap)*5*stagedmg3) --xsec (5 sec). stage3: Max damage
			end
		elseif name == "Fiora" then
			if spellname == "Q" then DmgP = 25*Qlvl+15+.6*bad --xstrike
			elseif spellname == "W" then DmgM = 50*Wlvl+10+ap
			elseif spellname == "R" then DmgP = math.max(130*Rlvl-5+.9*bad,(170*Rlvl-10+.9*bad)*2.6*stagedmg3) --xstrike , without counting on-hit effects, Successive hits against the same target deal 40% damage. stage3: Max damage
			end
		elseif name == "Fizz" then
			if spellname == "Q" then DmgM = 30*Qlvl-20+.6*ap TypeDmg = 2 -- (bonus)
			elseif spellname == "W" then DmgM = math.max(((15*Wlvl+25+.6*ap)+(Wlvl+3)*(tmhp-thp)/100)*(stagedmg1+stagedmg3),((10*Wlvl+20+.35*ap)+(Wlvl+3)*(tmhp-thp)/100)*stagedmg2) TypeDmg = 2 --stage1:when its active. stage2:Passive. stage3:when its active
			elseif spellname == "E" then DmgM = 50*Elvl+20+.75*ap
			elseif spellname == "R" then DmgM = 125*Rlvl+75+ap
			end
		elseif name == "Galio" then
			if spellname == "Q" then DmgM = 55*Qlvl+25+.6*ap
			elseif spellname == "E" then DmgM = 45*Elvl+15+.5*ap
			elseif spellname == "R" then DmgM = math.max(110*Rlvl+110+.6*ap,(110*Rlvl+110+.6*ap)*1.4*stagedmg3) --additional 5% damage for each attack suffered while channeling and capping at 40%. stage3: Max damage
			end
		elseif name == "Gangplank" then
			if spellname == "P" then DmgM = 3+lvl TypeDmg = 2 --xstack
			elseif spellname == "Q" then DmgP = 25*Qlvl-5 TypeDmg = 2 --without counting on-hit effects
			elseif spellname == "R" then DmgM = 45*Rlvl+30+.2*ap --xSec (7 sec)
			end
		elseif name == "Garen" then
			if spellname == "Q" then DmgP = 25*Qlvl+5+.4*ad TypeDmg = 2 -- (bonus)
			elseif spellname == "E" then DmgP = math.max(25*Elvl-5+(.1*Elvl+.6)*ad,(25*Elvl-5+(.1*Elvl+.6)*ad)*2.5*stagedmg3) --xsec (2.5 sec). stage3: Max damage
			elseif spellname == "R" then DmgM = 175*Rlvl+(tmhp-thp)/((8-Rlvl)/2)
			end
		elseif name == "Gnar" then
			if spellname == "Q" then DmgP = 30*Qlvl-25+1.15*ad -- 50% damage beyond the first
			elseif spellname == "QM" then DmgP = 40*Qlvl-35+1.2*ad
			elseif spellname == "W" then DmgM = 10*Wlvl+ap+(2*Wlvl+4)*tmhp/100
			elseif spellname == "WM" then DmgP = 20*Wlvl+5+ad
			elseif spellname == "E" then DmgP = 40*Elvl-20+6*mhp/100
			elseif spellname == "EM" then DmgP = 40*Elvl-20+6*mhp/100
			elseif spellname == "R" then DmgP = math.max(100*Rlvl+100+.2*bad+.5*ap,(100*Rlvl+100+.2*bad+.5*ap)*1.5*stagedmg3) --x1.5 If collide with terrain. stage3: Max damage
			end
		elseif name == "Gragas" then
			if spellname == "Q" then DmgM = math.max(40*Qlvl+40+.6*ap,(40*Qlvl+40+.6*ap)*1.5*stagedmg3) --Damage increase by up to 50% over 2 seconds. stage3: Max damage
			elseif spellname == "W" then DmgM = 30*Wlvl-10+.3*ap+(.01*Wlvl+.07)*tmhp TypeDmg = 2 -- (bonus)
			elseif spellname == "E" then DmgM = 50*Elvl+30+.6*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+100+.7*ap
			end
		elseif name == "Graves" then
			if spellname == "Q" then DmgP = math.max(35*Qlvl+25+.8*bad,(35*Qlvl+25+.8*bad)*1.8*stagedmg3) --xbullet , 40% damage xeach bullet beyond the first. stage3: Max damage
			elseif spellname == "W" then DmgM = 50*Wlvl+10+.6*ap
			elseif spellname == "R" then DmgP = math.max((150*Rlvl+100+1.5*bad)*(stagedmg1+stagedmg3),(120*Rlvl+80+1.2*bad)*stagedmg2) --stage1-3:Initial. stage2:Explosion.
			end
		elseif name == "Hecarim" then
			if spellname == "Q" then DmgP = 35*Qlvl+25+.6*bad
			elseif spellname == "W" then DmgM = math.max(11.25*Wlvl+8.75+.2*ap,(11.25*Wlvl+8.75+.2*ap)*4*stagedmg3) --xsec (4 sec). stage3: Max damage
			elseif spellname == "E" then DmgP = math.max(35*Elvl+5+.5*bad,(35*Elvl+5+.5*bad)*2*stagedmg3) --Minimum , 200% Maximum (bonus). stage3: Max damage
			elseif spellname == "R" then DmgM = 100*Rlvl+50+ap
			end
		elseif name == "Heimerdinger" then
			if spellname == "P" then
			elseif spellname == "Q" then DmgM = math.max((5.5*Qlvl+6.5+.15*ap)*stagedmg1,(math.max(20*Qlvl+20,25*Qlvl+5)+.55*ap)*stagedmg2,(60*Rlvl+120+.7*ap)*stagedmg3) --stage1:x Turrets attack. stage2:Beam. stage3:UPGRADE Beam
			elseif spellname == "W" then DmgM = 30*Wlvl+30+.45*ap --x Rocket, 20% magic damage for each rocket beyond the first
			elseif spellname == "E" then DmgM = 40*Elvl+20+.6*ap
			elseif spellname == "R" then DmgM = math.max((20*Rlvl+50+.3*ap)*stagedmg1,(45*Rlvl+90+.45*ap)*stagedmg2,(50*Rlvl+100+.6*ap)*stagedmg3) --stage1:x Turrets attack. stage2:x Rocket, 20% magic damage for each rocket beyond the first. stage3:x Bounce
			end
		elseif name == "Irelia" then
			if spellname == "Q" then DmgP = 30*Qlvl-10 TypeDmg = 2 -- (bonus)
			elseif spellname == "W" then DmgT = 15*Wlvl TypeDmg = 2 --xhit (bonus)
			elseif spellname == "E" then DmgM = 50*Elvl+30+.5*ap
			elseif spellname == "R" then DmgP = 40*Rlvl+40+.5*ap+.6*bad --xblade
			end
		elseif name == "Janna" then
			if spellname == "Q" then DmgM = math.max((25*Qlvl+35+.35*ap)*stagedmg1,(5*Qlvl+10+.1*ap)*stagedmg2,(25*Qlvl+35+.35*ap+(5*Qlvl+10+.1*ap)*3)*stagedmg3) --stage1:Initial. stage2:Additional Damage xsec (3 sec). stage3:Max damage
			elseif spellname == "W" then DmgM = 55*Wlvl+5+.5*ap
			end
		elseif name == "JarvanIV" then
			if spellname == "P" then DmgP = math.min(.01*tmhp,400) TypeDmg = 2
			elseif spellname == "Q" then DmgP = 45*Qlvl+25+1.2*bad
			elseif spellname == "E" then DmgM = 45*Elvl+15+.8*ap
			elseif spellname == "R" then DmgP = 125*Rlvl+75+1.5*bad
			end
		elseif name == "Jax" then
			if spellname == "Q" then DmgP = 40*Qlvl+30+.6*ap+bad
			elseif spellname == "W" then DmgM = 35*Wlvl+5+.6*ap TypeDmg = 2
			elseif spellname == "E" then DmgP = math.max(25*Elvl+25+.5*bad,(25*Elvl+25+.5*bad)*2*stagedmg3) --deals 20% additional damage for each attack dodged to a maximum of 100%. stage3: Max damage
			elseif spellname == "R" then DmgM = 60*Rlvl+40+.7*ap TypeDmg = 2 --every third basic attack (bonus)
			end
		elseif name == "Jayce" then
			if spellname == "Q" then DmgP = math.max(55*Qlvl+5+1.2*bad,(55*Qlvl+5+1.2*bad)*1.4*stagedmg3) --If its fired through an Acceleration Gate damage will increase by 40%. stage3: Max damage
			elseif spellname == "QM" then DmgP = 45*Qlvl-25+bad
			elseif spellname == "W" then DmgT = 15*Wlvl+55 --% damage
			elseif spellname == "WM" then DmgM = math.max(17.5*Wlvl+7.5+.25*ap,(17.5*Wlvl+7.5+.25*ap)*4*stagedmg3) --xsec (4 sec). stage3: Max damage
			elseif spellname == "EM" then DmgM = bad+((3*Elvl+5)*tmhp/100)
			elseif spellname == "R" then DmgM = 40*Rlvl-20 TypeDmg = 2
			end
		elseif name == "Jinx" then
			if spellname == "Q" then DmgP = .1*ad TypeDmg = 2
			elseif spellname == "W" then DmgP = 50*Wlvl-40+1.4*ad
			elseif spellname == "E" then DmgM = 55*Elvl+25+ap -- per Chomper
			elseif spellname == "R" then DmgP = math.max(((50*Rlvl+75+.5*bad)*2+(0.05*Rlvl+0.2)*(tmhp-thp))*stagedmg1,(50*Rlvl+75+.5*bad)*stagedmg2,(0.05*Rlvl+0.2)*(tmhp-thp)*stagedmg3) --stage1:Maximum (after 1500 units)+Additional Damage. stage2:Minimum Base (Maximum = x2). stage3: Additional Damage
			end
		elseif name == "Kalista" then
			if spellname == "Q" then DmgP = 60*Qlvl-50+ad
			elseif spellname == "W" then DmgM = (2*Wlvl+10)*thp/100
			elseif spellname == "E" then DmgP = math.max((10*Elvl+10+.6*ad)*(stagedmg1+stagedmg3),((10*Elvl+10+.6*ad)*(5*Elvl+20)/100)*stagedmg2) --stage1,3:Base. stage2:xSpear.
			end
		elseif name == "Karma" then
			if spellname == "Q" then DmgM = math.max((45*Qlvl+35+.6*ap)*stagedmg1,(50*Rlvl-25+.3*ap)*stagedmg2,(100*Rlvl-50+.6*ap)*stagedmg3) --stage1:Initial. stage2:Bonus (R). stage3: Detonation (R)
			elseif spellname == "W" then DmgM = math.max((50*Wlvl+10+.6*ap)*(stagedmg1+stagedmg3),(75*Rlvl+.6*ap)*stagedmg2) --stage1:Initial. stage2:Bonus (R).
			elseif spellname == "E" then DmgM = 80*Rlvl-20+.6*ap --(R)
			end
		elseif name == "Karthus" then
			if spellname == "Q" then DmgM = 40*Qlvl+40+.6*ap --50% damage if it hits multiple units
			elseif spellname == "E" then DmgM = 20*Elvl+10+.2*ap --xsec
			elseif spellname == "R" then DmgM = 150*Rlvl+100+.6*ap
			end
		elseif name == "Kassadin" then
			if spellname == "Q" then DmgM = 25*Qlvl+55+.7*ap
			elseif spellname == "W" then DmgM = math.max((25*Wlvl+15+.6*ap)*(stagedmg1+stagedmg3),(20+.1*ap)*stagedmg2) TypeDmg = 2 -- stage1-3:Active. stage2: Pasive.
			elseif spellname == "E" then DmgM = 25*Elvl+55+.7*ap
			elseif spellname == "R" then DmgM = math.max((20*Rlvl+60+.02*mmana)*(stagedmg1+stagedmg3),(10*Rlvl+30+.01*mmana)*stagedmg2) --stage1-3:Initial. stage2:additional xstack (4 stack).
			end
		elseif name == "Katarina" then
			if spellname == "Q" then DmgM = math.max((25*Qlvl+35+.45*ap)*stagedmg1,(15*Qlvl+.15*ap)*stagedmg2,(40*Qlvl+35+.6*ap)*stagedmg3) --stage1:Dagger, Each subsequent hit deals 10% less damage. stage2:On-hit. stage3: Max damage
			elseif spellname == "W" then DmgM = 35*Wlvl+5+.25*ap+.6*bad
			elseif spellname == "E" then DmgM = 25*Elvl+35+.4*ap
			elseif spellname == "R" then DmgM = math.max(20*Rlvl+15+.25*ap+.375*bad,(20*Rlvl+15+.25*ap+.375*bad)*10*stagedmg3) --xdagger (champion can be hit by a maximum of 10 daggers (2 sec)). stage3: Max damage
			end
		elseif name == "Kayle" then
			if spellname == "Q" then DmgM = 50*Qlvl+10+.6*ap+bad
			elseif spellname == "E" then DmgM = 10*Elvl+10+.25*ap TypeDmg = 2 --xhit (bonus)
			end
		elseif name == "Kennen" then
			if spellname == "Q" then DmgM = 40*Qlvl+35+.75*ap
			elseif spellname == "W" then DmgM = math.max((30*Wlvl+35+.55*ap)*(stagedmg1+stagedmg3),(.1*Wlvl+.3)*ad*stagedmg2) TypeDmg = 1+stagedmg2 --stage1:Active. stage2:On-hit. stage3: stage1
			elseif spellname == "E" then DmgM = 40*Elvl+45+.6*ap
			elseif spellname == "R" then DmgM = math.max(65*Rlvl+15+.4*ap,(65*Rlvl+15+.4*ap)*3*stagedmg3) --xbolt (max 3 bolts). stage3: Max damage
			end
		elseif name == "Khazix" then
			if spellname == "P" then DmgM = math.max(5*lvl+10,10*lvl-5,15*lvl-55)-math.max(0,5*(lvl-13))+.5*ap TypeDmg = 2 -- (bonus)
			elseif spellname == "Q" then DmgP = math.max((25*Qlvl+45+1.2*bad)*stagedmg1,(25*Qlvl+45+1.2*bad)*1.3*stagedmg2,((25*Qlvl+45+1.2*bad)*1.3+10*lvl+1.04*bad)*stagedmg3) --stage1:Normal. stage2:to Isolated. stage3:Evolved to Isolated.
			elseif spellname == "W" then DmgP = 30*Wlvl+50+bad
			elseif spellname == "E" then DmgP = 35*Elvl+30+.2*bad
			end
		elseif name == "KogMaw" then
			if spellname == "P" then DmgT = 100+25*lvl
			elseif spellname == "Q" then DmgM = 50*Qlvl+30+.5*ap
			elseif spellname == "W" then DmgM = (Wlvl+1+.01*ap)*tmhp/100 TypeDmg = 2 --xhit (bonus)
			elseif spellname == "E" then DmgM = 50*Elvl+10+.7*ap
			elseif spellname == "R" then DmgM = 80*Rlvl+80+.3*ap+.5*bad
			end
		elseif name == "Leblanc" then
			if spellname == "Q" then DmgM = math.max(25*Qlvl+30+.4*ap,(25*Qlvl+30+.4*ap)*2*stagedmg3) --Initial or mark. stage3: Max damage
			elseif spellname == "W" then DmgM = 40*Wlvl+45+.6*ap
			elseif spellname == "E" then DmgM = math.max(25*Qlvl+15+.5*ap,(25*Qlvl+15+.5*ap)*2*stagedmg3) --Initial or Delayed. stage3: Max damage
			elseif spellname == "R" then DmgM = math.max((100*Rlvl+.65*ap)*stagedmg1,(150*Rlvl+.975*ap)*stagedmg2,(100*Rlvl+.65*ap)*stagedmg3) --stage1:Q Initial or mark. stage2:W. stage3:E Initial or Delayed
			end
		elseif name == "LeeSin" then
			if spellname == "Q" then DmgP = math.max((30*Qlvl+20+.9*bad)*stagedmg1,(30*Qlvl+20+.9*bad+8*(tmhp-thp)/100)*stagedmg2,(60*Qlvl+40+1.8*bad+8*(tmhp-thp)/100)*stagedmg3) --stage1:Sonic Wave. stage2:Resonating Strike. stage3: Max damage
			elseif spellname == "E" then DmgM = 35*Qlvl+25+bad
			elseif spellname == "R" then DmgP = 200*Rlvl+2*bad
			end
		elseif name == "Leona" then
			if spellname == "P" then DmgM = (-1.25)*(3*(-1)^lvl-6*lvl-7)
			elseif spellname == "Q" then DmgM = 30*Qlvl+10+.3*ap TypeDmg = 2 -- (bonus)
			elseif spellname == "W" then DmgM = 50*Wlvl+10+.4*ap
			elseif spellname == "E" then DmgM = 40*Elvl+20+.4*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.8*ap
			end
		elseif name == "Lissandra" then
			if spellname == "Q" then DmgM = 35*Qlvl+40+.65*ap
			elseif spellname == "W" then DmgM = 40*Wlvl+30+.4*ap
			elseif spellname == "E" then DmgM = 45*Elvl+25+.6*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.7*ap
			end
		elseif name == "Lucian" then
			if spellname == "P" then DmgP = (.3+.1*math.floor((lvl-1)/6))*ad TypeDmg = 2
			elseif spellname == "Q" then DmgP = 30*Qlvl+50+(15*Qlvl+45)*bad/100
			elseif spellname == "W" then DmgM = 40*Wlvl+20+.9*ap
			elseif spellname == "R" then DmgP = 10*Rlvl+30+.1*ap+.3*bad --per shot
			end
		elseif name == "Lulu" then
			if spellname == "P" then DmgM = math.max(4*math.floor(lvl/2+.5)-1+.15*ap,(4*math.floor(lvl/2+.5)-1+.15*ap)*3*stagedmg3) --xbolt (3 bolts). stage: Max damage
			elseif spellname == "Q" then DmgM = 45*Qlvl+35+.5*ap
			elseif spellname == "E" then DmgM = 30*Elvl+50+.4*ap
			end
		elseif name == "Lux" then
			if spellname == "P" then DmgM = 8*lvl+10+.2*ap
			elseif spellname == "Q" then DmgM = 50*Qlvl+10+.7*ap
			elseif spellname == "E" then DmgM = 45*Elvl+15+.6*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+200+.75*ap
			end
		elseif name == "Malphite" then
			if spellname == "Q" then DmgM = 50*Qlvl+20+.6*ap
			elseif spellname == "E" then DmgM = 40*Elvl+20+.2*ap+.3*ar
			elseif spellname == "R" then DmgM = 100*Rlvl+100+ap
			end
		elseif name == "Malzahar" then
			if spellname == "P" then DmgP = 20+5*lvl+bad --Voidling xhit
			elseif spellname == "Q" then DmgM = 55*Qlvl+25+.8*ap
			elseif spellname == "W" then DmgM = (Wlvl+3+.01*ap)*tmhp/100 --xsec (5 sec)
			elseif spellname == "E" then DmgM = 60*Elvl+20+.8*ap --over 4 sec
			elseif spellname == "R" then DmgM = 150*Rlvl+100+1.3*ap --over 2.5 sec
			end
		elseif name == "Maokai" then
			if spellname == "Q" then DmgM = 45*Qlvl+25+.4*ap
			elseif spellname == "W" then DmgM = (1*Wlvl+8+.03*ap)*tmhp/100
			elseif spellname == "E" then DmgM = math.max((20*Elvl+20+.4*ap)*stagedmg1,(40*Elvl+40+.6*ap)*stagedmg2,(60*Elvl+60+ap)*stagedmg3) --stage1:Impact. stage2:Explosion. stage3: Max damage
			elseif spellname == "R" then DmgM = 50*Rlvl+50+.5*ap+(50*Rlvl+150)*stagedmg3 -- +2 per point of damage absorbed (max 100/150/200). stage3: Max damage
			end
		elseif name == "MasterYi" then
			if spellname == "P" then DmgP = .5*ad TypeDmg = 2
			elseif spellname == "Q" then DmgP = math.max((35*Qlvl-10+ad)*stagedmg1,(.6*ad)*stagedmg2,(35*Qlvl-10+1.6*ad)*stagedmg3) --stage1:normal. stage2:critically strike (bonus). stage3: critically strike
			elseif spellname == "E" then DmgT = 5*Elvl+5+((5/2)*Elvl+15/2)*ad/100
			end
		elseif name == "MissFortune" then
			if spellname == "Q" then DmgP = math.max((15*Qlvl+5+.85*ad+.35*ap)*(stagedmg1+stagedmg3),(30*Qlvl+10+ad+.5*ap)*stagedmg2) --stage1-stage3:1st target. stage2:2nd target.
			elseif spellname == "W" then DmgM = .06*ad --xstack (max 5+Rlvl stacks) (bonus)
			elseif spellname == "E" then DmgM = 55*Elvl+35+.8*ap --over 3 seconds
			elseif spellname == "R" then DmgP = math.max(25*Rlvl+25,50*Rlvl-25)+.2*ap --xwave (8 waves) applies a stack of Impure Shots
			end
		elseif name == "Mordekaiser" then
			if spellname == "Q" then DmgM = math.max(30*Qlvl+50+.4*ap+bad,(30*Qlvl+50+.4*ap+bad)*1.65*stagedmg3) --If the target is alone, the ability deals 65% more damage. stage3: Max damage
			elseif spellname == "W" then DmgM = math.max(14*Wlvl+10+.2*ap,(14*Wlvl+10+.2*ap)*6*stagedmg3) --xsec (6 sec). stage3: Max damage
			elseif spellname == "E" then DmgM = 45*Elvl+25+.6*ap
			elseif spellname == "R" then DmgM = (5*Rlvl+19+.04*ap)*tmhp/100 --half Initial and half over 10 sec
			end
		elseif name == "Morgana" then
			if spellname == "Q" then DmgM = 55*Qlvl+25+.6*ap
			elseif spellname == "W" then DmgM = (7*Wlvl+5+.11*ap)*(1+.5*(1-thp/tmhp)) --x 1/2 sec (5 sec)
			elseif spellname == "R" then DmgM = math.max(75*Rlvl+75+.7*ap,(75*Rlvl+75+.7*ap)*2*stagedmg3) --x2 If the target stay in range for the full duration. stage3: Max damage
			end
		elseif name == "Nami" then
			if spellname == "Q" then DmgM = 55*Qlvl+20+.5*ap
			elseif spellname == "W" then DmgM = 40*Wlvl+30+.5*ap --The percentage power of later bounces now scales. Each bounce gains 0.75% more power per 10 AP
			elseif spellname == "E" then DmgM = 15*Elvl+10+.2*ap TypeDmg = 2 --xhit (max 3 hits)
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.6*ap
			end
		elseif name == "Nasus" then
			if spellname == "Q" then DmgP = 20*Qlvl+10 TypeDmg = 2 --+3 per enemy killed by Siphoning Strike (bonus)
			elseif spellname == "E" then DmgM = math.max((80*Elvl+30+1.2*ap)/5,(80*Elvl+30+1.2*ap)*stagedmg3) --xsec (5 sec). stage3: Max damage
			elseif spellname == "R" then DmgM = (Rlvl+2+.01*ap)*tmhp/100 --xsec (15 sec)
			end
		elseif name == "Nautilus" then
			if spellname == "P" then DmgP = 2+6*lvl TypeDmg = 2
			elseif spellname == "Q" then DmgM = 45*Qlvl+15+.75*ap
			elseif spellname == "W" then DmgM = 15*Wlvl+25+.4*ap TypeDmg = 2 --xhit (bonus)
			elseif spellname == "E" then DmgM = math.max(40*Elvl+20+.5*ap,(40*Elvl+20+.5*ap)*2*stagedmg3) --xexplosions , 50% less damage from additional explosions. stage3: Max damage
			elseif spellname == "R" then DmgM = 125*Rlvl+75+.8*ap
			end
		elseif name == "Nidalee" then
			if spellname == "Q" then DmgM = 25*Qlvl+25+.4*ap --deals 300% damage the further away the target is, gains damage from 525 units until 1300 units
			elseif spellname == "QM" then DmgM = (math.max(4,30*Rlvl-40,40*Rlvl-70)+.75*ad+.36*ap)*(1+1.5*(tmhp-thp)/tmhp) --Deals 33% increased damage against Hunted
			elseif spellname == "W" then DmgM = 20*Wlvl+(2*Wlvl+8+.02*ap)*thp/100 -- over 4 sec
			elseif spellname == "WM" then DmgM = 50*Rlvl+.3*ap
			elseif spellname == "EM" then DmgM = 60*Rlvl+10+.45*ap
			end
		elseif name == "Nocturne" then
			if spellname == "P" then DmgP = .2*ad TypeDmg = 2 --(bonus)
			elseif spellname == "Q" then DmgP = 45*Qlvl+15+.75*bad
			elseif spellname == "E" then DmgM = 50*Elvl+ap
			elseif spellname == "R" then DmgP = 100*Rlvl+50+1.2*bad
			end
		elseif name == "Nunu" then
			if spellname == "Q" then DmgM = .01*mhp --xhit Ornery Monster Tails passive
			elseif spellname == "E" then DmgM = 37.5*Elvl+47.5+ap
			elseif spellname == "R" then DmgM = 250*Rlvl+375+2.5*ap --After 3 sec
			end
		elseif name == "Olaf" then
			if spellname == "Q" then DmgP = 45*Qlvl+25+bad
			elseif spellname == "E" then DmgT = 45*Elvl+25+.4*ad
			end
		elseif name == "Orianna" then
			if spellname == "P" then DmgM = 8*math.floor((lvl+2)/3)+2+0.15*ap --xhit subsequent attack deals 20% more dmg up to 40%
			elseif spellname == "Q" then DmgM = 30*Qlvl+30+.5*ap --10% less damage for each subsequent target hit down to a minimum of 40%
			elseif spellname == "W" then DmgM = 45*Wlvl+25+.7*ap
			elseif spellname == "E" then DmgM = 30*Elvl+30+.3*ap
			elseif spellname == "R" then DmgM = 75*Rlvl+75+.7*ap
			end
		elseif name == "Pantheon" then
			if spellname == "Q" then DmgP = (40*Qlvl+25+1.4*bad)*(1+math.floor((tmhp-thp)/(tmhp*0.85)))
			elseif spellname == "W" then DmgM = 25*Wlvl+25+ap
			elseif spellname == "E" then DmgP = math.max(20*Elvl+6+1.2*bad,(20*Elvl+6+1.2*bad)*3*stagedmg3) --xStrike (3 strikes). stage3: Max damage
			elseif spellname == "R" then DmgM = 300*Rlvl+100+ap
			end
		elseif name == "Poppy" then
			if spellname == "Q" then DmgM = 25*Qlvl+.6*ap+ad+math.min(0.08*tmhp,75*Qlvl) --(applies on hit?) TypeDmg = 3
			elseif spellname == "E" then DmgM = math.max((25*Elvl+25+.4*ap)*stagedmg1,(50*Elvl+25+.4*ap)*stagedmg2,(75*Elvl+50+.8*ap)*stagedmg3) --stage1:initial. stage2:Collision. stage3: Max damage
			elseif spellname == "R" then DmgT = 10*Rlvl+10 --% Increased Damage
			end
		elseif name == "Quinn" then
			if spellname == "P" then DmgP = math.max(10*lvl+15,15*lvl-55)+.5*bad TypeDmg = 2 --(bonus)
			elseif spellname == "Q" then DmgP = 40*Qlvl+30+.65*bad+.5*ap
			elseif spellname == "E" then DmgP = 30*Elvl+10+.2*bad
			elseif spellname == "R" then DmgP = (50*Rlvl+70+.5*bad)*(2-thp/tmhp)
			end
		elseif name == "Rammus" then
			if spellname == "Q" then DmgM = 50*Qlvl+50+ap
			elseif spellname == "W" then DmgM = 10*Wlvl+5+.1*ar --x each attack suffered
			elseif spellname == "R" then DmgM = 65*Rlvl+.3*ap --xsec (8 sec)
			end
		elseif name == "RekSai" then
			if spellname == "Q" then DmgP = 20*Qlvl-5+.4*bad TypeDmg = 2 --(bonus)
			elseif spellname == "QM" then DmgM = 30*Qlvl+30+ap
			elseif spellname == "WM" then DmgP = 50*Wlvl+10+.5*bad
			elseif spellname == "E" then DmgP = (.1*Elvl+.7)*ad*(1+mana/mmana)*(1-math.floor(mana/mmana)) DmgT = (.1*Elvl+.7)*ad*2*math.floor(mana/mmana)
			end
		elseif name == "Renekton" then
			if spellname == "Q" then DmgP = math.max(30*Qlvl+30+.8*bad,(30*Qlvl+30+.8*bad)*1.5*stagedmg3) --stage1:with 50 fury deals 50% additional damage. stage3: Max damage
			elseif spellname == "W" then DmgP = math.max(20*Wlvl-10+1.5*ad,(20*Wlvl-10+1.5*ad)*1.5*stagedmg3) --stage1:with 50 fury deals 50% additional damage. stage3: Max damage -- on hit x2 or x3
			elseif spellname == "E" then DmgP = math.max(30*Elvl+.9*bad,(30*Elvl+.9*bad)*1.5*stagedmg3) --stage1:Slice or Dice , with 50 fury Dice deals 50% additional damage. stage3: Max damage of Dice
			elseif spellname == "R" then DmgM = math.max(30*Rlvl,60*Rlvl-60)+.1*ap --xsec (15 sec)
			end
		elseif name == "Rengar" then
			if spellname == "Q" then DmgP = math.max((30*Qlvl+(.05*Qlvl-.05)*ad)*stagedmg1,(math.min(15*lvl+15,10*lvl+60)+.5*ad)*(stagedmg2+stagedmg3)) TypeDmg = 2 --stage1:Savagery. stage2-stage3:Empowered Savagery.
			elseif spellname == "W" then DmgM = math.max((30*Wlvl+20+.8*ap)*stagedmg1,(math.min(15*lvl+25,math.max(145,10*lvl+60))+.8*ap)*(stagedmg2+stagedmg3)) --stage1:Battle Roar. stage2-stage3:Empowered Battle Roar.
			elseif spellname == "E" then DmgP = math.max((50*Elvl+.7*bad)*stagedmg1,(math.min(25*lvl+25,10*lvl+160)+.7*bad)*(stagedmg2+stagedmg3))
			end
		elseif name == "Riven" then
			if spellname == "P" then DmgP = 5+math.max(5*math.floor((lvl+2)/3)+10,10*math.floor((lvl+2)/3)-15)*ad/100 --xcharge
			elseif spellname == "Q" then DmgP = 20*Qlvl-10+(.05*Qlvl+.35)*ad --xstrike (3 strikes)
			elseif spellname == "W" then DmgP = 30*Wlvl+20+bad
			elseif spellname == "R" then DmgP = math.min((40*Rlvl+40+.6*bad)*(1+(100-25)/100*8/3),120*Rlvl+120+1.8*bad)
			end
		elseif name == "Rumble" then
			if spellname == "P" then DmgM = 20+5*lvl+.25*ap TypeDmg = 2 --xhit
			elseif spellname == "Q" then DmgM = math.max(20*Qlvl+5+.33*ap,(20*Qlvl+5+.33*ap)*3*stagedmg3) --xsec (3 sec) , with 50 heat deals 150% damage. stage3: Max damage , with 50 heat deals 150% damage
			elseif spellname == "E" then DmgM = 25*Elvl+20+.4*ap --xshoot (2 shoots) , with 50 heat deals 150% damage
			elseif spellname == "R" then DmgM = math.max(55*Rlvl+75+.3*ap,(55*Rlvl+75+.3*ap)*5*stagedmg3) --stage1: xsec (5 sec). stage3: Max damage
			end
		elseif name == "Ryze" then
			if spellname == "Q" then DmgM = 20*Qlvl+20+.4*ap+.065*mmana
			elseif spellname == "W" then DmgM = 35*Wlvl+25+.6*ap+.045*mmana
			elseif spellname == "E" then DmgM = math.max(20*Elvl+30+.35*ap+.01*mmana,(20*Elvl+30+.35*ap+.01*mmana)*3*stagedmg3) --xbounce. stage3: Max damage
			end
		elseif name == "Sejuani" then
			if spellname == "Q" then DmgM = 45*Qlvl+35+.4*ap
			elseif spellname == "W" then DmgM = math.max(((2*Wlvl+2+.03*ap)*tmhp/100)*stagedmg1,(30*Wlvl+10+.6*ap+(2*Wlvl+2)*mhp/100)/4*(stagedmg2+stagedmg3)) TypeDmg = 1+stagedmg1 --stage1: bonus. stage2-3: xsec (4 sec)
			elseif spellname == "E" then DmgM = 30*Elvl+30+.5*ap
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.8*ap
			end
		elseif name == "Shaco" then
			if spellname == "Q" then DmgP = (.2*Qlvl+.2)*ad --(bonus)
			elseif spellname == "W" then DmgM = 15*Wlvl+20+.2*ap --xhit
			elseif spellname == "E" then DmgM = 40*Elvl+10+ap+bad
			elseif spellname == "R" then DmgM = 150*Rlvl+150+ap --The clone deals 75% of Shaco's damage
			end
		elseif name == "Shen" then
			if spellname == "P" then DmgM = 4+4*lvl+(mhp-(428+85*lvl))*.1 TypeDmg = 2 --(bonus)
			elseif spellname == "Q" then DmgM = 40*Qlvl+20+.6*ap
			elseif spellname == "E" then DmgM = 35*Elvl+15+.5*ap
			end
		elseif name == "Shyvana" then
			if spellname == "Q" then DmgP = (.05*Qlvl+.75)*ad TypeDmg = 2 --Second Strike
			elseif spellname == "W" then DmgM = 15*Wlvl+5+.2*bad --xsec (3 sec + 4 extra sec)
			elseif spellname == "E" then DmgM = math.max((40*Elvl+20+.6*ap)*(stagedmg1+stagedmg3),(2*tmhp/100)*stagedmg2) --stage1-3:Active. stage2:Each autoattack that hits debuffed targets
			elseif spellname == "R" then DmgM = 125*Rlvl+50+.7*ap
			end
		elseif name == "Singed" then
			if spellname == "Q" then DmgM = 12*Qlvl+10+.3*ap --xsec
			elseif spellname == "E" then DmgM = 45*Elvl+35+.75*ap
			end
		elseif name == "Sion" then
			if spellname == "P" then DmgP = 10*tmhp/100 TypeDmg = 2
			elseif spellname == "Q" then DmgP = 20*Qlvl+.6*ad --Minimum, x3 over 2 sec
			elseif spellname == "W" then DmgM = 25*Wlvl+15+.4*ap+(Wlvl+9)*tmhp/100
			elseif spellname == "E" then DmgM = math.max(35*Wlvl+35+.4*ap,(35*Wlvl+35+.4*ap)*1.5*stagedmg3) --Minimum. stage3: x1.5 if hits a minion
			elseif spellname == "R" then DmgP = 150*Qlvl+.4*bad --Minimum, x2 over 1.75 sec
			end
		elseif name == "Sivir" then
			if spellname == "Q" then DmgP = 20*Qlvl+5+.5*ap+(.1*Qlvl+.6)*ad --x2 , 15% reduced damage to each subsequent target
			elseif spellname == "W" then DmgP = (.05*Wlvl+.45)*ad*stagedmg2 TypeDmg = 2 --stage1:bonus to attack target. stage2: Bounce Damage
			end
		elseif name == "Skarner" then
			if spellname == "P" then DmgM = 5*lvl+15 TypeDmg = 2
			elseif spellname == "Q" then DmgP = (10*Qlvl+8+.4*bad)*(stagedmg1+stagedmg3) QDmgM = (10*Qlvl+8+.2*ap)*(stagedmg2+stagedmg3) --stage1:basic. stage2: charge bonus. stage2: total
			elseif spellname == "E" then DmgM = 20*Elvl+20+.4*ap
			elseif spellname == "R" then DmgM = math.max((100*Rlvl+100+ap)*(stagedmg1+stagedmg3),(25*Rlvl+25)*stagedmg2)--stage1-3:basic. stage2: per stacks of Crystal Venom.
			end
		elseif name == "Sona" then
			if spellname == "P" then DmgM = (math.max(7*lvl+6,8*lvl+3,9*lvl-2,10*lvl-8,15*lvl-78)+.2*ap)*(1+stagedmg1) TypeDmg = 2 --stage1: Staccato. stage2:Diminuendo or Tempo
			elseif spellname == "Q" then DmgM = math.max((40*Qlvl+.5*ap)*(stagedmg1+stagedmg3),(10*Qlvl+30+.2*ap+10*Rlvl)*stagedmg2) TypeDmg = 1+stagedmg2 --stage1-3: Active. stage2:On-hit
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.5*ap
			end
		elseif name == "Soraka" then
			if spellname == "Q" then DmgM = math.max(40*Qlvl+30+.35*ap,(40*Qlvl+30+.35*ap)*1.5*stagedmg3) --stage1: border. stage3: center
			elseif spellname == "E" then DmgM = 40*Elvl+30+.4*ap --Initial or Secondary
			end
		elseif name == "Swain" then
			if spellname == "Q" then DmgM = math.max(15*Qlvl+10+.3*ap,(15*Qlvl+10+.3*ap)*3*stagedmg3) --xsec (3 sec). stage3: Max damage
			elseif spellname == "W" then DmgM = 40*Wlvl+40+.7*ap
			elseif spellname == "E" then DmgM = (40*Elvl+35+.8*ap)*(stagedmg1+stagedmg3) DmgT = (3*Elvl+5)*stagedmg2 --stage1-3:Active.  stage2:% Extra Damage.
			elseif spellname == "R" then DmgM = 20*Rlvl+30+.2*ap --xstrike (1 strike x sec)
			end
		elseif name == "Syndra" then
			if spellname == "Q" then DmgM = math.max(40*Qlvl+30+.6*ap,(40*Qlvl+30+.6*ap)*1.15*(Qlvl-4))
			elseif spellname == "W" then DmgM = 40*Wlvl+40+.7*ap
			elseif spellname == "E" then DmgM = 45*Elvl+25+.4*ap
			elseif spellname == "R" then DmgM = math.max(45*Rlvl+45+.2*ap,(45*Rlvl+45+.2*ap)*7*stagedmg3) --stage1:xSphere (Minimum 3). stage3:7 Spheres
			end
		elseif name == "Talon" then
			if spellname == "Q" then DmgP = 40*Qlvl+1.3*bad TypeDmg = 2 --(bonus)
			elseif spellname == "W" then DmgP = math.max(25*Wlvl+5+.6*bad,(25*Wlvl+5+.6*bad)*2*stagedmg3) --x2 if the target is hit twice. stage3: Max damage
			elseif spellname == "E" then DmgT = 3*Elvl --% Damage Amplification
			elseif spellname == "R" then DmgP = math.max(50*Rlvl+70+.75*bad,(50*Rlvl+70+.75*bad)*2*stagedmg3) --x2 if the target is hit twice. stage3: Max damage
			end
		elseif name == "Taric" then
			if spellname == "P" then DmgM = .2*ar TypeDmg = 2 --(bonus)
			elseif spellname == "W" then DmgM = 40*Wlvl+.2*ar
			elseif spellname == "E" then DmgM = math.max(30*Elvl+10+.2*ap,(30*Elvl+10+.2*ap)*2*stagedmg3) --min (lower damage the farther the target is) up to 200%. stage3: Max damage
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.5*ap
			end
		elseif name == "Teemo" then
			if spellname == "Q" then DmgM = 45*Qlvl+35+.8*ap
			elseif spellname == "E" then DmgM = math.max((10*Elvl+.3*ap)*stagedmg1,(6*Elvl+.1*ap)*stagedmg2,(34*Elvl+.7*ap)*stagedmg3) --stage1:Hit (bonus). stage2:poison xsec (4 sec). stage3:Hit+poison for 4 sec
			elseif spellname == "R" then DmgM = 125*Rlvl+75+.5*ap
			end
		elseif name == "Thresh" then
			if spellname == "Q" then DmgM = 40*Qlvl+40+.5*ap
			elseif spellname == "E" then DmgM = math.max((40*Elvl+25+.4*ap)*(stagedmg1+stagedmg3),((.3*Qlvl+.5)*ad)*stagedmg2) --stage1:Active. stage2:Passive (+ Souls). stage3:stage1
			elseif spellname == "R" then DmgM = 150*Rlvl+100+ap
			end
		elseif name == "Tristana" then
			if spellname == "W" then DmgM = 45*Wlvl+25+.8*ap
			elseif spellname == "E" then DmgM = math.max((45*Elvl+35+ap)*(stagedmg1+stagedmg3),(25*Elvl+25+.25*ap)*stagedmg2) --stage1-3:Active. stage2:Passive.
			elseif spellname == "R" then DmgM = 100*Rlvl+200+1.5*ap
			end
		elseif name == "Trundle" then
			if spellname == "Q" then DmgP = 20*Qlvl+(5*Qlvl+95)*ad/100 TypeDmg = 2 --(bonus)
			elseif spellname == "R" then DmgM = (2*Rlvl+18+.02*ap)*tmhp/100 --over 4 sec
			end
		elseif name == "Tryndamere" then
			if spellname == "E" then DmgP = 30*Elvl+40+ap+1.2*bad
			end
		elseif name == "TwistedFate" then
			if spellname == "Q" then DmgM = 50*Qlvl+10+.65*ap
			elseif spellname == "W" then DmgM = math.max((7.5*Wlvl+7.5+.5*ap+ad)*stagedmg1,(15*Wlvl+15+.5*ap+ad)*stagedmg2,(20*Wlvl+20+.5*ap+ad)*stagedmg3) --stage1:Gold Card.  stage2:Red Card.  stage3:Blue Card
			elseif spellname == "E" then DmgM = 25*Elvl+30+.5*ap
			end
		elseif name == "Twitch" then
			if spellname == "P" then DmgT = math.floor((lvl+2)/3) --xstack xsec (6 stack 6 sec)
			elseif spellname == "E" then DmgP = math.max((5*Elvl+10+.2*ap+.25*bad)*stagedmg1,(15*Elvl+5)*stagedmg2,((5*Elvl+10+.2*ap+.25*bad)*6+15*Elvl+5)*stagedmg3) --stage1:xstack (6 stack). stage2:Base. stage3: Max damage
			end
		elseif name == "Udyr" then
			if spellname == "Q" then DmgP = math.max((50*Qlvl-20+(.1*Qlvl+1.1)*ad)*(stagedmg2+stagedmg3),(.15*ad)*stagedmg1) TypeDmg = 2 --stage1:persistent effect. stage2:(bonus). stage3:stage2
			elseif spellname == "W" then TypeDmg = 2
			elseif spellname == "E" then TypeDmg = 2
			elseif spellname == "R" then DmgM = math.max((40*Rlvl+.45*ap)*stagedmg2,(10*Rlvl+5+.25*ap)*stagedmg3) TypeDmg = 2 --stage1:0. stage2:xThird Attack. stage3:x wave (5 waves)
			end
		elseif name == "Urgot" then
			if spellname == "Q" then DmgP = 30*Qlvl-20+.85*ad
			elseif spellname == "E" then DmgP = 55*Elvl+20+.6*bad
			end
		elseif name == "Varus" then
			if spellname == "Q" then DmgP = math.max(.625*(55*Qlvl-40+1.6*ad),(55*Qlvl-40+1.6*ad)*stagedmg3) --stage1:min. stage3:max. reduced by 15% per enemy hit (minimum 33%)
			elseif spellname == "W" then DmgM = math.max((4*Wlvl+6+.25*ap)*stagedmg1,((.0075*Wlvl+.0125+.02*ap)*tmhp/100)*stagedmg2,((.0075*Wlvl+.0125+.02*ap)*tmhp/100)*3*stagedmg3) --stage1:xhit. stage2:xstack (3 stacks). stage3: 3 stacks
			elseif spellname == "E" then DmgP = 35*Elvl+30+.6*ad
			elseif spellname == "R" then DmgM = 100*Rlvl+50+ap
			end
		elseif name == "Vayne" then
			if spellname == "Q" then DmgP = (.05*Qlvl+.25)*ad TypeDmg = 2 --(bonus)
			elseif spellname == "W" then DmgT = 10*Wlvl+10+((1*Wlvl+3)*tmhp/100)
			elseif spellname == "E" then DmgP = math.max(35*Elvl+10+.5*bad,(35*Elvl+10+.5*bad)*2*stagedmg3) --x2 If they collide with terrain. stage3: Max damage
			elseif spellname == "R" then TypeDmg = 2
			end
		elseif name == "Veigar" then
			if spellname == "Q" then DmgM = 45*Qlvl+35+.6*ap
			elseif spellname == "W" then DmgM = 50*Wlvl+70+ap
			elseif spellname == "R" then DmgM = 125*Rlvl+125+1.2*ap+.8*tap
			end
		elseif name == "Velkoz" then
			if spellname == "P" then DmgT = 10*lvl+25
			elseif spellname == "Q" then DmgM = 40*Qlvl+40+.6*ap
			elseif spellname == "W" then DmgM = math.max(20*Wlvl+10+.25*ap,(20*Wlvl+10+.25*ap)*1.5*stagedmg2) --stage1-3:Initial. stage2:Detonation.
			elseif spellname == "E" then DmgM = 30*Elvl+40+.5*ap
			elseif spellname == "R" then DmgM = 20*Rlvl+30+.6*ap --every 0.25 sec (2.5 sec), Organic Deconstruction every 0.5 sec
			end
		elseif name == "Vi" then
			if spellname == "Q" then DmgP = math.max(25*Qlvl+25+.8*bad,(25*Qlvl+25+.8*bad)*2*stagedmg3) --x2 If charging up to 1.5 seconds. stage3: Max damage
			elseif spellname == "W" then DmgP = ((3/2)*Wlvl+5/2+(1/35)*bad)*thp/100
			elseif spellname == "E" then DmgP = 15*Elvl-10+.15*ad+.7*ap TypeDmg = 2 --(Bonus)
			elseif spellname == "R" then DmgP = 150*Rlvl+50+1.4*bad --deals 75% damage to enemies in her way
			end
		elseif name == "Viktor" then
			if spellname == "Q" then DmgM = math.max((20*Qlvl+20+.2*ap)*(stagedmg1+stagedmg3),(math.max(5*lvl+15,10*lvl-30,20*lvl-150)+.5*ap+ad)*stagedmg2) --stage1-3:Initial. stage2:basic attack.
			elseif spellname == "E" then DmgM = math.max(45*Elvl+25+.7*ap,(45*Elvl+25+.7*ap)*1.4*stagedmg3) --Initial or Aftershock. stage3: Max damage
			elseif spellname == "R" then DmgM = math.max((100*Rlvl+50+.55*ap)*stagedmg1,(15*Rlvl+.1*ap)*stagedmg2,(100*Rlvl+50+.55*ap+(15*Rlvl+.1*ap)*7)*stagedmg3) --stage1:initial. stage2: xsec (7 sec). stage3: Max damage
			end
		elseif name == "Vladimir" then
			if spellname == "Q" then DmgM = 35*Qlvl+55+.6*ap
			elseif spellname == "W" then DmgM = 55*Wlvl+25+(mhp-(400+85*lvl))*.15 --(2 sec)
			elseif spellname == "E" then DmgM = math.max((25*Elvl+35+.45*ap)*stagedmg1,((25*Elvl+35)*0.25)*stagedmg2,((25*Elvl+35)*2+.45*ap)*stagedmg3) --stage1:25% more base damage x stack. stage2:+x stack. stage3: Max damage
			elseif spellname == "R" then DmgM = 100*Rlvl+50+.7*ap
			end
		elseif name == "Volibear" then
			if spellname == "Q" then DmgP = 30*Qlvl TypeDmg = 2 --(bonus)
			elseif spellname == "W" then DmgP = ((Wlvl-1)*45+80+(mhp-(440+lvl*86))*.15)*(1+(tmhp-thp)/tmhp)
			elseif spellname == "E" then DmgM = 45*Elvl+15+.6*ap
			elseif spellname == "R" then DmgM = 80*Rlvl-5+.3*ap TypeDmg = 2 --xhit
			end
		elseif name == "Warwick" then
			if spellname == "P" then DmgM = math.max(.5*lvl+2.5,(.5*lvl+2.5)*3*stagedmg3) --xstack (3 stacks). stage3: Max damage
			elseif spellname == "Q" then DmgM = 50*Qlvl+25+ap+((2*Qlvl+6)*tmhp/100)
			elseif spellname == "R" then DmgM = math.max((100*Rlvl+50+2*bad)/5,(100*Rlvl+50+2*bad)*stagedmg3) --xstrike (5 strikes) , without counting on-hit effects. stage3: Max damage
			end
		elseif name == "MonkeyKing" then
			if spellname == "Q" then DmgP = 30*Qlvl+.1*ad TypeDmg = 2 --(bonus)
			elseif spellname == "W" then DmgM = 45*Wlvl+25+.6*ap
			elseif spellname == "E" then DmgP = 45*Elvl+15+.8*bad
			elseif spellname == "R" then DmgP = math.max(90*Rlvl-70+1.1*ad,(90*Rlvl-70+1.1*ad)*4*stagedmg3) --xsec (4 sec). stage3: Max damage
			end
		elseif name == "Xerath" then
			if spellname == "Q" then DmgM = 40*Qlvl+40+.75*ap
			elseif spellname == "W" then DmgM = math.max((30*Qlvl+30+.6*ap)*1.5*(stagedmg1+stagedmg3),(30*Qlvl+30+.6*ap)*stagedmg2) --stage1,3: Center. stage2: Border
			elseif spellname == "E" then DmgM = 30*Elvl+50+.45*ap
			elseif spellname == "R" then DmgM = 55*Rlvl+135+.43*ap --xcast (3 cast)
			end
		elseif name == "XinZhao" then
			if spellname == "Q" then DmgP = 15*Qlvl+.2*ad TypeDmg = 2 --(bonus x hit)
			elseif spellname == "E" then DmgM = 35*Elvl+35+.6*ap
			elseif spellname == "R" then DmgP = 100*Rlvl-25+bad+15*thp/100
			end
		elseif name == "Yasuo" then
			if spellname == "Q" then DmgP = 20*Qlvl TypeDmg = 2 -- can critically strike, dealing X% AD
			elseif spellname == "E" then DmgM = 20*Elvl+50+.6*ap --Each cast increases the next dash's base damage by 25%, up to 50% bonus damage
			elseif spellname == "R" then DmgP = 100*Rlvl+100+1.5*bad
			end
		elseif name == "Yorick" then
			if spellname == "P" then DmgP = .35*ad --xhit of ghouls
			elseif spellname == "Q" then DmgP = 30*Qlvl+.2*ad TypeDmg = 2 --(bonus)
			elseif spellname == "W" then DmgM = 35*Wlvl+25+ap
			elseif spellname == "E" then DmgM = 30*Elvl+25+bad
			end
		elseif name == "Zac" then
			if spellname == "Q" then DmgM = 40*Qlvl+30+.5*ap
			elseif spellname == "W" then DmgM = 15*Wlvl+25+((1*Wlvl+3+.02*ap)*tmhp/100)
			elseif spellname == "E" then DmgM = 50*Elvl+30+.7*ap
			elseif spellname == "R" then DmgM = math.max(70*Rlvl+70+.4*ap,(70*Rlvl+70+.4*ap)*2.5*stagedmg3) -- stage1:Enemies hit more than once take half damage. stage3: Max damage
			end
		elseif name == "Zed" then
			if spellname == "P" then DmgM = (6+2*(math.floor((lvl-1)/6)))*tmhp/100 TypeDmg = 2
			elseif spellname == "Q" then DmgP = math.max((40*Qlvl+35+bad)*stagedmg1,(40*Qlvl+35+bad)*.6*stagedmg2,(40*Qlvl+35+bad)*1.5*stagedmg3)  --stage1:multiple shurikens deal 50% damage. stage2:Secondary Targets. stage3: Max damage
			elseif spellname == "E" then DmgP = 30*Elvl+30+.8*bad
			elseif spellname == "R" then DmgP = ad*(stagedmg1+stagedmg3) DmgT = (15*Rlvl+5)*stagedmg2 --stage1-3:100% of Zed attack damage. stage2:% of damage dealt.
			end
		elseif name == "Ziggs" then
			if spellname == "P" then DmgM = math.max(4*lvl+16,8*lvl-8,12*lvl-56)+(.2+.05*math.floor((lvl+5)/6))*ap TypeDmg = 2
			elseif spellname == "Q" then DmgM = 45*Qlvl+30+.65*ap
			elseif spellname == "W" then DmgM = 35*Wlvl+35+.35*ap
			elseif spellname == "E" then DmgM = 25*Elvl+15+.3*ap --xmine , 40% damage from additional mines
			elseif spellname == "R" then DmgM = 125*Rlvl+125+.9*ap --enemies away from the primary blast zone will take 80% damage
			end
		elseif name == "Zilean" then
			if spellname == "Q" then DmgM = 57.5*Qlvl+32.5+.9*ap
			end
		elseif name == "Zyra" then
			if spellname == "P" then DmgT = 80+20*lvl
			elseif spellname == "Q" then DmgM = 35*Qlvl+35+.65*ap
			elseif spellname == "W" then DmgM = 23+6.5*lvl+.2*ap --xstrike Extra plants striking the same target deal 50% less damage
			elseif spellname == "E" then DmgM = 35*Elvl+25+.5*ap
			elseif spellname == "R" then DmgM = 85*Rlvl+95+.7*ap
			end
		end
		if DmgM > 0 then DmgM = owner:CalcMagicDamage(target,DmgM) end
		if DmgP > 0 then DmgP = owner:CalcDamage(target,DmgP) end
		TrueDmg = DmgM+DmgP+DmgT
	elseif (spellname == "AD") then
		TrueDmg = owner:CalcDamage(target,ad)
	elseif (spellname == "IGNITE") then
		TrueDmg = 50+20*lvl
	elseif (spellname == "SMITESS") then
		TrueDmg = 54+6*lvl --60-162 over 3 seconds
	elseif (spellname == "SMITESB") then
		TrueDmg = 20+8*lvl --28-164
	elseif (spellname == "DFG") then
		TrueDmg = owner:CalcMagicDamage(target,.15*tmhp)
	elseif (spellname == "HXG") then
		TrueDmg = owner:CalcMagicDamage(target,150+.4*ap)
	elseif (spellname == "BWC") then
		TrueDmg = owner:CalcMagicDamage(target,100)
	elseif (spellname == "KITAES") then
		TrueDmg = owner:CalcMagicDamage(target,.025*tmhp)
	elseif (spellname == "NTOOTH") then
		TrueDmg = owner:CalcMagicDamage(target,15+.15*ap)
	elseif (spellname == "WITSEND") then
		TrueDmg = owner:CalcMagicDamage(target,42)
	elseif (spellname == "SHEEN") then
		TrueDmg = owner:CalcDamage(target,ad-bad) --(bonus)
	elseif (spellname == "TRINITY") then
		TrueDmg = owner:CalcDamage(target,2*(ad-bad)) --(bonus)
	elseif (spellname == "LICHBANE") then
		TrueDmg = owner:CalcMagicDamage(target,.75*(ad-bad)+.5*ap) --(bonus)
	elseif (spellname == "LIANDRYS") then
		TrueDmg = owner:CalcMagicDamage(target,.06*thp) --over 3 sec, If their movement is impaired, they take double damage from this effect
	elseif (spellname == "BLACKFIRE") then
		TrueDmg = owner:CalcMagicDamage(target,.035*tmhp) --over 2 sec
	elseif (spellname == "STATIKK") then
		TrueDmg = owner:CalcMagicDamage(target,100)
	elseif (spellname == "ICEBORN") then
		TrueDmg = owner:CalcDamage(target,1.25*(ad-bad)) --(bonus)
	elseif (spellname == "TIAMAT") then
		TrueDmg = owner:CalcDamage(target,.6*ad) --decaying down to 33.33% near the edge (20% of ad)
	elseif (spellname == "HYDRA") then
		TrueDmg = owner:CalcDamage(target,.6*ad) --decaying down to 33.33% near the edge (20% of ad)
	elseif (spellname == "RUINEDKING") then
		TrueDmg = math.max(owner:CalcDamage(target,.08*thp)*(stagedmg1+stagedmg3),owner:CalcDamage(target,math.max(.1*tmhp,100))*stagedmg2) --stage1-3:Passive. stage2:Active.
	elseif (spellname == "MURAMANA") then
		TrueDmg = owner:CalcDamage(target,.06*mana)
	elseif (spellname == "HURRICANE") then
		TrueDmg = owner:CalcDamage(target,10+.5*ad) --apply on-hit effects
	elseif (spellname == "SUNFIRE") then
		TrueDmg = owner:CalcMagicDamage(target,25+lvl) --x sec
	elseif (spellname == "LIGHTBRINGER") then
		TrueDmg = owner:CalcMagicDamage(target,100) -- 20% chance
	elseif (spellname == "MOUNTAIN") then
		TrueDmg = owner:CalcMagicDamage(target,.3*ap+ad)
	elseif (spellname == "SPIRITLIZARD" or spellname == "ISPARK" or spellname == "MADREDS" or spellname == "ECALLING" or spellname == "EXECUTIONERS" or spellname == "MALADY") then
		TrueDmg = 0
	else
		PrintChat("Error spellDmg "..name.." "..spellname)
		TrueDmg = 0
	end
	return TrueDmg, TypeDmg
end