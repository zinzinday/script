--[[
	Spell Damage Library 1.37
		by eXtragoZ
		
		If there is a mistake, error, value has changed, bug, or you have an idea 
		for improvement, please let me know ;D
		
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

spellDmg = {
	Aatrox = {
		QDmgP = "45*Qlvl+25+.6*bad",
		WDmgP = "(35*Wlvl+25+bad)*(stagedmg1+stagedmg3)",
		WType = 2,
		EDmgM = "35*Elvl+40+.6*ap+.6*bad",
		RDmgM = "100*Rlvl+100+ap",
	},
	Ahri = {
		QDmgM = "(25*Qlvl+15+.33*ap)*(stagedmg1+stagedmg3)", --stage1:Initial. stage3:total.
		QDmgT = "(25*Qlvl+15+.33*ap)*(stagedmg2+stagedmg3)", --stage2:way back
		WDmgM = "math.max(25*Wlvl+15+.4*ap,(25*Wlvl+15+.4*ap)*1.6*stagedmg3)", -- xfox-fires ,  30% damage from each additional fox-fire beyond the first. stage3: Max damage
		EDmgM = "30*Elvl+30+.35*ap",--Enemies hit by Charm take 20% increased damage from Ahri for 6 seconds
		RDmgM = "40*Rlvl+30+.3*ap", -- xbolt (3 bolts)
	},
	Akali = {
		PDmgM = "(6+.1666667*ap)*ad/100",
		QDmgM = "math.max((20*Qlvl+15+.4*ap)*stagedmg1,(25*Qlvl+20+.5*ap)*stagedmg2,(45*Qlvl+35+.9*ap)*stagedmg3)", --stage1:Initial. stage2:Detonation. stage3:Max damage
		EDmgP = "25*Elvl+5+.3*ap+.6*ad",
		RDmgM = "75*Rlvl+25+.5*ap",
	},
	Alistar = {
		PDmgM = "math.max(6+lvl+.1*ap,(6+lvl+.1*ap)*3*stagedmg3)",  -- xsec (3sec). stage3: Max damage
		QDmgM = "45*Qlvl+15+.5*ap",
		WDmgM = "55*Wlvl+.7*ap",
	},
	Amumu = {
		QDmgM = "50*Qlvl+30+.7*ap",
		WDmgM = "((.3*Wlvl+1.2+.01*ap)*tmhp/100)+4*Wlvl+4", --xsec
		EDmgM = "25*Elvl+50+.5*ap",
		RDmgM = "100*Rlvl+50+.8*ap",
	},
	Anivia = {
		QDmgM = "math.max(30*Qlvl+30+.5*ap,(30*Qlvl+30+.5*ap)*2*stagedmg3)", -- x2 if it detonates. stage3: Max damage
		EDmgM = "math.max(30*Elvl+25+.5*ap,(30*Elvl+25+.5*ap)*2*stagedmg3)", -- x2  If the target has been chilled. stage3: Max damage
		RDmgM = "40*Rlvl+40+.25*ap", --xsec
	},
	Annie = {
		QDmgM = "35*Qlvl+45+.8*ap",
		WDmgM = "45*Wlvl+25+.85*ap",
		EDmgM = "10*Elvl+10+.2*ap", --x each attack suffered
		RDmgM = "math.max((125*Rlvl+50+.8*ap)*stagedmg1,(35+.2*ap)*stagedmg2,(125*Rlvl+50+.8*ap)*stagedmg3)", --stage1:Summon Tibbers . stage2:Aura AoE xsec + 1 Tibbers Attack. stage3:Summon Tibbers
		RDmgP = "(25*Rlvl+55)*stagedmg2",
	},
	Ashe = {
		QType = 2,
		WDmgP = "10*Wlvl+30+ad",
		RDmgM = "175*Rlvl+75+ap",
	},
	Blitzcrank = {
		QDmgM = "55*Qlvl+25+ap",
		EDmgP = "ad",
		EType = 2,
		RDmgM = "math.max((125*Rlvl+125+ap)*stagedmg1,(100*Rlvl+.2*ap)*stagedmg2,(125*Rlvl+125+ap)*stagedmg3)", --stage1:the active. stage2:the passive. stage3:the active
	},
	Brand = {
		PDmgM = "math.max(2*tmhp/100,(2*tmhp/100)*4*stagedmg3)", --xsec (4sec). stage3: Max damage
		QDmgM = "40*Qlvl+40+.65*ap",
		WDmgM = "math.max(45*Wlvl+30+.6*ap,(45*Wlvl+30+.6*ap)*1.25*stagedmg3)", --125% for units that are ablaze. stage3: Max damage
		EDmgM = "35*Elvl+35+.55*ap",
		RDmgM = "math.max(100*Rlvl+50+.5*ap,(100*Rlvl+50+.5*ap)*3*stagedmg3)", --xbounce (can hit the same enemy up to three times). stage3: Max damage
	},
	Caitlyn = {
		PDmgP = ".5*ad", --xheadshot (bonus)
		PType = 2,
		QDmgP = "40*Qlvl-20+1.3*ad", --deal 10% less damage for each subsequent target hit, down to a minimum of 50%
		WDmgM = "50*Wlvl+30+.6*ap",
		EDmgM = "50*Elvl+30+.8*ap",
		RDmgP = "225*Rlvl+25+2*ad",
	},
	Cassiopeia = {
		QDmgM = "40*Qlvl+35+.8*ap",
		WDmgM = "10*Wlvl+15+.15*ap", --xsec
		EDmgM = "35*Elvl+15+.55*ap",
		RDmgM = "125*Rlvl+75+.6*ap",
	},
	Chogath = {
		QDmgM = "56.25*Qlvl+23.75+ap",
		WDmgM = "50*Wlvl+25+.7*ap",
		EDmgM = "15*Elvl+5+.3*ap", --xhit (bonus)
		EType = 2,
		RDmgT = "175*Rlvl+125+.7*ap"
	},
	Corki = {
		PDmgT = ".1*ad", --xhit (bonus)
		PType = 2,
		QDmgM = "50*Qlvl+30+.5*bad+.5*ap",
		WDmgM = "30*Wlvl+30+.4*ap", --xsec (2.5 sec)
		EDmgP = "12*Elvl+8+.4*bad", --xsec (4 sec)
		RDmgM = "math.max(70*Rlvl+50+.3*ap+(.1*Rlvl+.1)*ad,(70*Rlvl+50+.3*ap+(.1*Rlvl+.1)*ad)*1.5*stagedmg3)", --150% the big one. stage3: Max damage
	},
	Darius = {
		PDmgM = "(-.75)*((-1)^lvl-2*lvl-13)+.3*bad", --xstack
		QDmgP = "math.max(35*Qlvl+35+.7*bad,(35*Qlvl+35+.7*bad)*1.5*stagedmg3)", --150% Champions in the outer half. stage3: Max damage
		WDmgP = ".2*Wlvl*ad", --(bonus)
		WType = 2,
		RDmgT = "math.max(90*Rlvl+70+.75*bad,(90*Rlvl+70+.75*bad)*2*stagedmg3)" --xstack of Hemorrhage deals an additional 20% damage. stage3: Max damage
	},
	Diana = {
		PDmgM = "math.max(5*lvl+15,10*lvl-10,15*lvl-60,20*lvl-125,25*lvl-200)+.8*ap", -- (bonus)
		PType = 2,
		QDmgM = "35*Qlvl+25+.7*ap",
		WDmgM = "math.max(12*Wlvl+10+.2*ap,(12*Wlvl+10+.2*ap)*3*stagedmg3)", --xOrb (3 orbs). stage3: Max damage
		RDmgM = "60*Rlvl+40+.6*ap",
	},
	DrMundo = {
		QDmgM = "math.max((2.5*Qlvl+12.5)*thp/100,50*Qlvl+30)",
		WDmgM = "15*Wlvl+20+.2*ap", --xsec
	},
	Draven = {
		QDmgP = "(.1*Qlvl+.35)*ad", --xhit (bonus)
		QType = 2,
		EDmgP = "35*Elvl+35+.5*bad",
		RDmgP = "100*Rlvl+75+1.1*bad", --xhit (max 2 hits), deals 8% less damage for each unit hit, down to a minimum of 40%
	},
	Elise = {
		PDmgM = "10*Rlvl+.1*ap", --xhit Spiderling Damage
		QDmgM = "35*Qlvl+5+(8+.03*ap)*thp/100",
		QMDmgM = "40*Qlvl+20+(8+.03*ap)*(tmhp-thp)/100",
		WDmgM = "50*Wlvl+25+.8*ap",
		RDmgM = "10*Rlvl+.3*ap", --xhit (bonus)
		RType = 2,
	},
	Evelynn = {
		QDmgM = "20*Qlvl+20+.45*ap+.5*bad",
		EDmgP = "40*Elvl+30+ap+bad", --total
		RDmgM = "(5*Rlvl+10+.01*ap)*thp/100",
	},
	Ezreal = {
		QDmgP = "20*Qlvl+15+.4*ap", -- (bonus)
		QType = 2,
		WDmgM = "45*Wlvl+25+.7*ap",
		EDmgM = "50*Elvl+25+.75*ap",
		RDmgM = "150*Rlvl+200+.9*ap+bad", --deal 10% less damage for each subsequent target hit, down to a minimum of 30%
	},
	FiddleSticks = {
		WDmgM = "math.max(30*Wlvl+30+.45*ap,(30*Wlvl+30+.45*ap)*5*stagedmg3)", --xsec (5 sec). stage3: Max damage
		EDmgM = "math.max(20*Elvl+45+.45*ap,(20*Elvl+45+.45*ap)*3*stagedmg3)", --xbounce. stage3: Max damage
		RDmgM = "math.max(100*Rlvl+25+.45*ap,(100*Rlvl+25+.45*ap)*5*stagedmg3)", --xsec (5 sec). stage3: Max damage
	},
	Fiora = {
		QDmgP = "25*Qlvl+15+.6*bad", --xstrike
		WDmgM = "50*Wlvl+10+ap",
		RDmgP = "math.max(170*Rlvl-10+1.2*bad,(170*Rlvl-10+1.2*bad)*2*stagedmg3)", --xstrike , without counting on-hit effects, Successive hits against the same target deal 25% damage. stage3: Max damage
	},
	Fizz = {
		QDmgM = "30*Qlvl-20+.6*ap", -- (bonus)
		QType = 2,
		WDmgM = "math.max(((15*Wlvl+25+.6*ap)+(Wlvl+3)*(tmhp-thp)/100)*(stagedmg1+stagedmg3),((10*Wlvl+20+.35*ap)+(Wlvl+3)*(tmhp-thp)/100)*stagedmg2)", --stage1:when its active. stage2:Passive. stage3:when its active
		WType = 2,
		EDmgM = "50*Elvl+20+.75*ap",
		RDmgM = "125*Rlvl+75+ap",
	},
	Galio = {
		QDmgM = "55*Qlvl+25+.6*ap",
		EDmgM = "45*Elvl+15+.5*ap",
		RDmgM = "math.max(110*Rlvl+110+.6*ap,(110*Rlvl+110+.6*ap)*1.4*stagedmg3)", --additional 5% damage for each attack suffered while channeling and capping at 40%. stage3: Max damage
	},
	Gangplank = {
		PDmgM = "3+lvl", --xstack
		PType = 2,
		QDmgP = "25*Qlvl-5", --without counting on-hit effects
		QType = 2,
		RDmgM = "45*Rlvl+30+.2*ap", --xCannonball (25 cannonballs)
	},
	Garen = {
		QDmgP = "25*Qlvl+5+.4*ad", -- (bonus)
		QType = 2,
		EDmgP = "math.max(25*Elvl-5+(.1*Elvl+.6)*ad,(25*Elvl-5+(.1*Elvl+.6)*ad)*2.5*stagedmg3)", --xsec (2.5 sec). stage3: Max damage
		RDmgM = "175*Rlvl+(tmhp-thp)/((8-Rlvl)/2)",
	},
	Gragas = {
		QDmgM = "math.max(40*Qlvl+40+.6*ap,(40*Qlvl+40+.6*ap)*1.5*stagedmg3)", --Damage increase by up to 50% over 2 seconds. stage3: Max damage
		WDmgM = "30*Wlvl-10+.3*ap+(.01*Wlvl+.07)*tmhp", -- (bonus)
		WType = 2,
		EDmgM = "50*Elvl+30+.6*ap",
		RDmgM = "100*Rlvl+100+.7*ap",
	},
	Graves = {
		QDmgP = "math.max(35*Qlvl+25+.8*bad,(35*Qlvl+25+.8*bad)*1.7*stagedmg3)", --xbullet , each bullet beyond the first will deal only 35% damage. stage3: Max damage
		WDmgM = "50*Wlvl+10+.6*ap",
		RDmgP = "math.max((100*Rlvl+150+1.5*bad)*(stagedmg1+stagedmg3),(80*Rlvl+120+1.2*bad)*stagedmg2)", --stage1-stage3:Initial. stage2:Explosion.
	},
	Hecarim = {
		QDmgP = "35*Qlvl+25+.6*bad",
		WDmgM = "math.max(11.25*Wlvl+8.75+.2*ap,(11.25*Wlvl+8.75+.2*ap)*4*stagedmg3)", --xsec (4 sec). stage3: Max damage
		EDmgP = "math.max(35*Elvl+5+.5*bad,(35*Elvl+5+.5*bad)*2*stagedmg3)", --Minimum , 200% Maximum (bonus). stage3: Max damage
		RDmgM = "100*Rlvl+50+ap",
	},
	Heimerdinger = {
		QDmgM = "math.max((5.5*Qlvl+6.5+.15*ap)*stagedmg1,(math.max(20*Qlvl+20,25*Qlvl+5)+.55*ap)*stagedmg2,(60*Rlvl+120+.7*ap)*stagedmg3)",--stage1:x Turrets attack. stage2:Beam. stage3:UPGRADE Beam
		WDmgM = "30*Wlvl+30+.45*ap",--x Rocket, 20% magic damage for each rocket beyond the first
		EDmgM = "40*Elvl+20+.6*ap",
		RDmgM = "math.max((20*Rlvl+50+.3*ap)*stagedmg1,(45*Rlvl+90+.45*ap)*stagedmg2,(50*Rlvl+100+.6*ap)*stagedmg3)",--stage1:x Turrets attack. stage2:x Rocket, 20% magic damage for each rocket beyond the first. stage3:x Bounce
	},
	Irelia = {
		QDmgP = "30*Qlvl-10",-- (bonus)
		QType = 2,
		WDmgT = "15*Wlvl", --xhit (bonus)
		WType = 2,
		EDmgM = "50*Elvl+30+.5*ap",
		RDmgP = "40*Rlvl+40+.5*ap+.6*bad", --xblade
	},
	Janna = {
		QDmgM = "math.max((25*Qlvl+35+.35*ap)*stagedmg1,(5*Qlvl+10+.1*ap)*stagedmg2,(25*Qlvl+35+.35*ap+(5*Qlvl+10+.1*ap)*3)*stagedmg3)", --stage1:Initial. stage2:Additional Damage xsec (3 sec). stage3:Max damage
		WDmgM = "55*Wlvl+5+.5*ap",
	},
	JarvanIV = {
		PDmgP = "math.min((6+2*(math.floor((lvl-1)/6)))*tmhp/100,400)",
		PType = 2,
		QDmgP = "45*Qlvl+25+1.2*bad",
		EDmgM = "45*Elvl+15+.8*ap",
		RDmgP = "125*Rlvl+75+1.5*bad",
	},
	Jax = {
		QDmgP = "40*Qlvl+30+.6*ap+bad",
		WDmgM = "35*Wlvl+5+.6*ap",
		WType = 2,
		EDmgP = "math.max(25*Elvl+25+.5*bad,(25*Elvl+25+.5*bad)*2*stagedmg3)", --deals 20% additional damage for each attack dodged to a maximum of 100%. stage3: Max damage
		RDmgM = "60*Rlvl+40+.7*ap", --every third basic attack (bonus)
		RType = 2,
	},
	Jayce = {
		QDmgP = "math.max(55*Qlvl+5+1.2*bad,(55*Qlvl+5+1.2*bad)*1.4*stagedmg3)", --If its fired through an Acceleration Gate damage will increase by 40%. stage3: Max damage
		WDmgT = "15*Wlvl+55", --% damage
		QMDmgP = "45*Qlvl-25+bad",
		WMDmgM = "math.max(17.5*Wlvl+7.5+.25*ap,(17.5*Wlvl+7.5+.25*ap)*4*stagedmg3)", --xsec (4 sec). stage3: Max damage
		EMDmgM = "bad+((3*Elvl+5)*tmhp/100)",
		RDmgM = "40*Rlvl-20",
		RType = 2,
	},
	Jinx = {
		QDmgP = ".1*ad",
		QType = 2,
		WDmgP = "50*Wlvl-40+1.4*ad",
		EDmgM = "55*Elvl+25+ap",-- per Chomper
		RDmgP = "math.max(((50*Rlvl+75+.5*bad)*2+(0.05*Rlvl+0.2)*(tmhp-thp))*stagedmg1,(50*Rlvl+75+.5*bad)*stagedmg2,(0.05*Rlvl+0.2)*(tmhp-thp)*stagedmg3)", --stage1:Maximum (after 1500 units)+Additional Damage. stage2:Minimum Base (Maximum = x2). stage3: Additional Damage
	},
	Karma = {
		QDmgM = "math.max((45*Qlvl+35+.6*ap)*stagedmg1,(50*Rlvl-25+.3*ap)*stagedmg2,(100*Rlvl-50+.6*ap)*stagedmg3)", --stage1:Initial. stage2:Bonus (R). stage3: Detonation (R)
		WDmgM = "math.max((50*Wlvl+10+.6*ap)*(stagedmg1+stagedmg3),(75*Rlvl+.6*ap)*stagedmg2)", --stage1:Initial. stage2:Bonus (R).
		EDmgM = "80*Rlvl-20+.6*ap", --(R)
	},
	Karthus = {
		QDmgM = "40*Qlvl+40+.6*ap", --50% damage if it hits multiple units
		EDmgM = "20*Elvl+10+.2*ap", --xsec
		RDmgM = "150*Rlvl+100+.6*ap",
	},
	Kassadin = {
		QDmgM = "25*Qlvl+55+.7*ap",
		WDmgM = "math.max((25*Wlvl+15+.6*ap)*(stagedmg1+stagedmg3),(20+.1*ap)*stagedmg2)", -- stage1-3:Active. stage2: Pasive.
		WType = 2,
		EDmgM = "25*Elvl+55+.7*ap",
		RDmgM = "math.max((20*Rlvl+60+.02*mmana)*(stagedmg1+stagedmg3),(10*Rlvl+30+.01*mmana)*stagedmg2)", --stage1-3:Initial. stage2:additional xstack (4 stack).
	},
	Katarina = {
		QDmgM = "math.max((25*Qlvl+35+.45*ap)*stagedmg1,(15*Qlvl+.15*ap)*stagedmg2,(40*Qlvl+35+.6*ap)*stagedmg3)", --stage1:Dagger, Each subsequent hit deals 10% less damage. stage2:On-hit. stage3: Max damage
		WDmgM = "35*Wlvl+5+.25*ap+.6*bad",
		EDmgM = "25*Elvl+35+.4*ap",
		RDmgM = "math.max(17.5*Rlvl+22.5+.25*ap+.375*bad,(17.5*Rlvl+22.5+.25*ap+.375*bad)*10*stagedmg3)", --xdagger (champion can be hit by a maximum of 10 daggers (2 sec)). stage3: Max damage
	},
	Kayle = {
		QDmgM = "50*Qlvl+10+.6*ap+bad",
		EDmgM = "10*Elvl+10+.4*ap", --xhit (bonus)
		EType = 2,
	},
	Kennen = {
		QDmgM = "40*Qlvl+35+.75*ap",
		WDmgM = "math.max((30*Wlvl+35+.55*ap)*(stagedmg1+stagedmg3),(.1*Wlvl+.3)*ad*stagedmg2)",--stage1:Active. stage2:On-hit. stage3: stage1
		--WType = 2,
		EDmgM = "40*Elvl+45+.6*ap",
		RDmgM = "math.max(65*Rlvl+15+.4*ap,(65*Rlvl+15+.4*ap)*3*stagedmg3)", --xbolt (max 3 bolts). stage3: Max damage
	},
	Khazix = {
		PDmgM = "math.max(5*lvl+10,10*lvl-5,15*lvl-55)-math.max(0,5*(lvl-13))+.5*ap", -- (bonus)
		PType = 2,
		QDmgP = "math.max((30*Qlvl+40+1.5*bad)*stagedmg1,(30*Qlvl+40+1.5*bad+.06*(tmhp-thp))*(stagedmg2+stagedmg3))", --stage1:Normal. stage2-stage3:Evolved Enlarged Claws. (isolated increases the damage by 45%) 
		WDmgP = "40*Wlvl+35+bad",
		EDmgP = "35*Elvl+30+.2*bad",
	},
	KogMaw = {
		PDmgT = "100+25*lvl",
		QDmgM = "50*Qlvl+30+.5*ap",
		WDmgM = "(Wlvl+1+.01*ap)*tmhp/100", --xhit (bonus)
		WType = 2,
		EDmgM = "50*Elvl+10+.7*ap",
		RDmgM = "90*Rlvl+90+.3*ap+.5*bad",
	},
	Leblanc = {
		QDmgM = "math.max(25*Qlvl+30+.4*ap,(25*Qlvl+30+.4*ap)*2*stagedmg3)", --Initial or mark. stage3: Max damage
		WDmgM = "40*Wlvl+45+.6*ap",
		EDmgM = "math.max(25*Qlvl+15+.5*ap,(25*Qlvl+15+.5*ap)*2*stagedmg3)", --Initial or Delayed. stage3: Max damage
		RDmgM = "math.max((100*Rlvl+.65*ap)*stagedmg1,(150*Rlvl+.975*ap)*stagedmg2,(100*Rlvl+.65*ap)*stagedmg3)" --stage1:Q Initial or mark. stage2:W. stage3:E Initial or Delayed
	},
	LeeSin = {
		QDmgP = "math.max((30*Qlvl+20+.9*bad)*stagedmg1,(30*Qlvl+20+.9*bad+8*(tmhp-thp)/100)*stagedmg2,(60*Qlvl+40+1.8*bad+8*(tmhp-thp)/100)*stagedmg3)", --stage1:Sonic Wave. stage2:Resonating Strike. stage3: Max damage
		EDmgM = "35*Qlvl+25+bad",
		RDmgP = "200*Rlvl+2*bad",
	},
	Leona = {
		PDmgM = "(-1.25)*(3*(-1)^lvl-6*lvl-7)",
		QDmgM = "30*Qlvl+10+.3*ap", -- (bonus)
		QType = 2,
		WDmgM = "50*Wlvl+10+.4*ap",
		EDmgM = "40*Elvl+20+.4*ap",
		RDmgM = "100*Rlvl+50+.8*ap",
	},
	Lissandra = {
		QDmgM = "35*Qlvl+40+.65*ap",
		WDmgM = "40*Wlvl+30+.6*ap",
		EDmgM = "45*Elvl+25+.6*ap",
		RDmgM = "100*Rlvl+50+.7*ap",
	},
	Lucian = {
		PDmgP = "(.5+.25*math.floor(lvl/13))*ad", -- 50-75% of Lucian's AD based on level 13
		PType = 2,
		QDmgP = "30*Qlvl+50+(15*Qlvl+45)*bad/100",
		WDmgM = "40*Wlvl+20+.9*ap+.6*bad",
		RDmgP = "10*Rlvl+30+.1*ap+.3*bad",--per shot
	},
	Lulu = {
		PDmgM = "math.max(4*math.floor(lvl/2+.5)-1+.15*ap,(4*math.floor(lvl/2+.5)-1+.15*ap)*3*stagedmg3)", --xbolt (3 bolts). stage: Max damage
		--PType = 2,
		QDmgM = "45*Qlvl+35+.5*ap",
		EDmgM = "30*Elvl+50+.4*ap",
	},
	Lux = {
		PDmgM = "10+10*lvl",
		--PType = 2,
		QDmgM = "50*Qlvl+10+.7*ap",
		EDmgM = "45*Elvl+15+.6*ap",
		RDmgM = "100*Rlvl+200+.75*ap",
	},
	Malphite = {
		QDmgM = "50*Qlvl+20+.6*ap",
		EDmgM = "40*Elvl+20+.2*ap+.3*ar",
		RDmgM = "100*Rlvl+100+ap",
	},
	Malzahar = {
		PDmgP = "20+5*lvl+bad", --xhit
		QDmgM = "55*Qlvl+25+.8*ap",
		WDmgM = "(Wlvl+3+.01*ap)*tmhp/100",
		EDmgM = "60*Elvl+20+.8*ap",
		RDmgM = "150*Rlvl+100+1.3*ap",
	},
	Maokai = {
		QDmgM = "45*Qlvl+25+.4*ap",
		WDmgM = "35*Wlvl+45+.8*ap",
		EDmgM = "math.max((35*Elvl+5+.4*ap)*stagedmg1,(50*Elvl+30+.6*ap)*stagedmg2,(85*Elvl+35+ap)*stagedmg3)", --stage1:Impact. stage2:Explosion. stage3: Max damage
		RDmgM = "50*Rlvl+50+.5*ap+(50*Rlvl+150)*stagedmg3", -- +2 per point of damage absorbed (max 200/250/300). stage3: Max damage
	},
	MasterYi = {
		PDmgP = ".5*ad",
		PType = 2,
		QDmgP = "math.max((35*Qlvl-10+ad)*stagedmg1,(.6*ad)*stagedmg2,(35*Qlvl-10+1.6*ad)*stagedmg3)", --stage1:normal. stage2:critically strike (bonus). stage3: critically strike
		EDmgT = "5*Elvl+5+((5/2)*Elvl+15/2)*ad/100"
	},
	MissFortune = {
		QDmgP = "math.max((15*Qlvl+5+.85*ad)*(stagedmg1+stagedmg3),(30*Qlvl+10+ad)*stagedmg2)", --stage1-stage3:1st target. stage2:2nd target.
		WDmgM = ".06*ad", --xstack (max 5+Rlvl stacks) (bonus)
		EDmgM = "55*Elvl+35+.8*ap", --over 3 seconds
		RDmgP = "math.max(25*Rlvl+25,50*Rlvl-25)+.2*ap", --xwave (8 waves) applies a stack of Impure Shots
	},
	Mordekaiser = {
		QDmgM = "math.max(30*Qlvl+50+.4*ap+bad,(30*Qlvl+50+.4*ap+bad)*1.65*stagedmg3)", --If the target is alone, the ability deals 65% more damage. stage3: Max damage
		WDmgM = "math.max(14*Wlvl+10+.2*ap,(14*Wlvl+10+.2*ap)*6*stagedmg3)", --xsec (6 sec). stage3: Max damage
		EDmgM = "45*Elvl+25+.6*ap",
		RDmgM = "(5*Rlvl+19+.04*ap)*tmhp/100",
	},
	Morgana = {
		QDmgM = "55*Qlvl+25+.6*ap",
		WDmgM = "(7*Wlvl+5+.11*ap)*(1+.5*(1-thp/tmhp))", --x 1/2 sec (5 sec)
		RDmgM = "math.max(75*Rlvl+100+.7*ap,(75*Rlvl+100+.7*ap)*2*stagedmg3)", --x2 If the target stay in range for the full duration. stage3: Max damage
	},
	Nami = {
		QDmgM = "55*Qlvl+20+.5*ap",
		WDmgM = "40*Wlvl+30+.5*ap",--The percentage power of later bounces now scales. Each bounce gains 0.75% more power per 10 AP
		EDmgM = "15*Elvl+10+.2*ap",--xhit (max 3 hits)
		EType = 2,
		RDmgM = "100*Rlvl+50+.6*ap",
	},
	Nasus = {
		QDmgP = "20*Qlvl+10", --+3 per enemy killed by Siphoning Strike (bonus)
		QType = 2,
		EDmgM = "math.max((80*Elvl+30+1.2*ap)/5,(80*Elvl+30+1.2*ap)*stagedmg3)", --xsec (5 sec). stage3: Max damage
		RDmgM = "(Rlvl+2+.01*ap)*tmhp/100", --xsec (15 sec)
	},
	Nautilus = {
		PDmgP = "2+6*lvl",
		PType = 2,
		QDmgM = "45*Qlvl+15+.75*ap",
		WDmgM = "15*Wlvl+25+.4*ap", --xhit (bonus)
		WType = 2,
		EDmgM = "math.max(40*Elvl+20+.5*ap,(40*Elvl+20+.5*ap)*2*stagedmg3)", --xexplosions , 50% less damage from additional explosions. stage3: Max damage
		RDmgM = "125*Rlvl+75+.8*ap",
	},
	Nidalee = {
		QDmgM = "math.max(40*Qlvl+15,45*Qlvl+5)+.65*ap", --deals up to 250% damage the further away the target is, gains damage from distance traveled until it exceeds Nidalee's human auto attack range
		WDmgM = "45*Wlvl+35+.4*ap",
		QMDmgP = "(30*Rlvl+10+ad)*(1+2*(tmhp-thp)/tmhp)", --(total attack damage + 40/70/100) * (1 + ( 2 * %missing health / 100 ))
		--Q onhit
		WMDmgM = "50*Rlvl+75+.4*ap",
		EMDmgM = "75*Rlvl+75+.6*ap",
	},
	Nocturne = {
		PDmgP = ".2*ad", --(bonus)
		PType = 2,
		QDmgP = "45*Qlvl+15+.75*bad",
		EDmgM = "50*Elvl+ap",
		RDmgP = "100*Rlvl+50+1.2*bad",
	},
	Nunu = {
		QDmgM = ".01*mhp", --xhit Ornery Monster Tails passive
		EDmgM = "37.5*Elvl+47.5+ap",
		RDmgM = "250*Rlvl+375+2.5*ap",
	},
	Olaf  = {
		QDmgP = "45*Qlvl+25+bad",
		EDmgT = "45*Elvl+25+.4*ad",
	},
	Orianna = {
		PDmgM = "8*(math.floor((lvl-1)/3)+1)+2+0.15*ap", --xhit
		QDmgM = "30*Qlvl+30+.5*ap", --10% less damage for each subsequent target hit down to a minimum of 40%
		WDmgM = "45*Wlvl+25+.7*ap",
		EDmgM = "30*Elvl+30+.3*ap",
		RDmgM = "75*Rlvl+75+.7*ap",
	},
	Pantheon = {
		QDmgP = "(40*Qlvl+25+1.4*bad)+(40*Qlvl+25+1.4*bad)*0.5*math.floor((tmhp-thp)/85)",
		WDmgM = "25*Wlvl+25+ap",
		EDmgP = "math.max(20*Elvl+6+1.2*bad,(20*Elvl+6+1.2*bad)*3*stagedmg3)", --xStrike (3 strikes). stage3: Max damage
		RDmgM = "300*Rlvl+100+ap",
	},
	Poppy = {
		QDmgM = "25*Qlvl+.6*ap+math.min(0.08*tmhp,75*Qlvl)", --(bonus?)
		EDmgM = "math.max((25*Elvl+25+.4*ap)*stagedmg1,(50*Elvl+25+.4*ap)*stagedmg2,(75*Elvl+50+.8*ap)*stagedmg3)", --stage1:initial. stage2:Collision. stage3: Max damage
		RDmgT = "10*Rlvl+10" --% Increased Damage
	},
	Quinn = {
		PDmgP = "math.max(10*lvl+15,15*lvl-55)+.5*bad", --(bonus)
		PType = 2,
		QDmgP = "40*Qlvl+30+.65*bad+.5*ap",
		EDmgP = "30*Elvl+10+.2*bad",
		RDmgP = "(50*Rlvl+70+.5*bad)*(2-thp/tmhp)",
	},
	Rammus = {
		QDmgM = "50*Qlvl+50+ap",
		WDmgM = "10*Wlvl+5+.1*ar", --x each attack suffered
		RDmgM = "65*Rlvl+.3*ap", --xsec (8 sec)
	},
	Renekton = {
		QDmgP = "math.max(30*Qlvl+30+.8*bad,(30*Qlvl+30+.8*bad)*1.5*stagedmg3)", --stage1:with 50 fury deals 50% additional damage. stage3: Max damage
		WDmgP = "math.max(20*Wlvl-10+1.5*ad,(20*Wlvl-10+1.5*ad)*1.5*stagedmg3)", --stage1:with 50 fury deals 50% additional damage. stage3: Max damage
		-- on hit x2 or x3
		EDmgP = "math.max(30*Elvl+.9*bad,(30*Elvl+.9*bad)*1.5*stagedmg3)", --stage1:Slice or Dice , with 50 fury Dice deals 50% additional damage. stage3: Max damage of Dice
		RDmgM = "math.max(30*Rlvl,60*Rlvl-60)+.1*ap", --xsec (15 sec)
	},
	Rengar = {
		PType = 2,
		QDmgP = "math.max((20*Qlvl+(.05*Qlvl-.05)*ad)*stagedmg1,(math.max(10*lvl+10,15*lvl-35)+.5*ad)*(stagedmg2+stagedmg3))", --stage1:Savagery. stage2-stage3:Empowered Savagery.
		QType = 2,
		WDmgM = "math.max((30*Wlvl+20+.8*ap)*stagedmg1,(math.min(15*lvl+25,math.max(145,10*lvl+60))+.8*ap)*(stagedmg2+stagedmg3))", --stage1:Battle Roar. stage2-stage3:Empowered Battle Roar.
		EDmgP = "math.max((50*Elvl+.7*bad)*stagedmg1,(math.min(25*lvl+25,10*lvl+160)+.7*bad)*(stagedmg2+stagedmg3))",
	},
	Riven = {
		PDmgP = "5+math.max(5*(math.floor((lvl-1)/3)+1)+10,10*(math.floor((lvl-1)/3)+1)-15)*ad/100", --xcharge.
		QDmgP = "20*Qlvl-10+(.05*Qlvl+.35)*ad", --xstrike (3 strikes)
		WDmgP = "30*Wlvl+20+bad",
		RDmgP = "math.min((40*Rlvl+40+.6*bad)*(1+(100-25)/100*8/3),120*Rlvl+120+1.8*bad)",
	},
	Rumble = {
		PDmgM = "20+5*lvl+.25*ap", --xhit
		PType = 2,
		QDmgM = "math.max(20*Qlvl+5+.33*ap,(20*Qlvl+5+.33*ap)*3*stagedmg3)", --xsec (3 sec) , with 50 heat deals 50% additional damage. stage3: Max damage , with 50 heat deals 50% additional damage
		EDmgM = "25*Elvl+20+.4*ap", --xshoot (2 shoots) , with 50 heat deals 25% additional damage
		RDmgM = "math.max(55*Rlvl+75+.3*ap,(55*Rlvl+75+.3*ap)*5*stagedmg3)", --stage1: xsec (5 sec). stage3: Max damage
	},
	Ryze = {
		QDmgM = "25*Qlvl+35+.4*ap+.065*mmana",
		WDmgM = "35*Wlvl+25+.6*ap+.045*mmana",
		EDmgM = "math.max(20*Elvl+30+.35*ap+.01*mmana,(20*Elvl+30+.35*ap+.01*mmana)*3*stagedmg3)", --xbounce. stage3: Max damage
	},
	Sejuani = {
		QDmgM = "30*Qlvl+10+.4*ap+(2*Qlvl+2)*tmhp/100",
		WDmgM = "math.max((20*Wlvl+20+.3*ap)*stagedmg1,(10*Wlvl+10+.15*ap+2.5*(mhp-440-lvl*95)/100)*stagedmg2,(10*Wlvl+10+.15*ap+2.5*(mhp-440-lvl*95)/100)*4*stagedmg3)", --stage1: bonus. stage2: xsec (4 sec). stage3: stage2*4 sec
		WType = 2,--only stagedmg1
		EDmgM = "50*Elvl+10+.5*ap",
		RDmgM = "100*Rlvl+50+.8*ap",
	},
	Shaco = {
		QDmgP = "(.2*Qlvl+.2)*ad", --(bonus)
		WDmgM = "15*Wlvl+20+.2*ap", --xhit
		EDmgM = "40*Elvl+10+ap+bad",
		RDmgM = "150*Rlvl+150+ap", --The clone deals 75% of Shaco's damage
	},
	Shen = {
		PDmgM = "4+4*lvl+(mhp-(428+85*lvl))*.1", --(bonus)
		PType = 2,
		QDmgM = "40*Qlvl+20+.6*ap",
		EDmgM = "35*Elvl+15+.5*ap",
	},
	Shyvana = {
		QDmgP = "(.05*Qlvl+.75)*ad", --Second Strike
		QType = 2,
		WDmgM = "15*Wlvl+5+.2*bad", --xsec (3 sec + 4 extra sec)
		EDmgM = "math.max((40*Elvl+20+.6*ap)*(stagedmg1+stagedmg3),(2*tmhp/100)*stagedmg2)", --stage1:Active. stage2:Each autoattack that hits debuffed targets. stage3:Active
		RDmgM = "125*Rlvl+50+.7*ap",
	},
	Singed = {
		QDmgM = "12*Qlvl+10+.3*ap", --xsec
		EDmgM = "45*Elvl+35+.75*ap",
	},
	Sion = {
		QDmgM = "57.5*Qlvl+12.5+.9*ap",
		WDmgM = "50*Wlvl+50+.9*ap",
	},
	Sivir = {
		QDmgP = "20*Qlvl+5+.5*ap+(.1*Qlvl+.6)*ad", --x2 , 15% reduced damage to each subsequent target
		WDmgP = "(.05*Wlvl+.45)*ad*stagedmg2", --stage1:bonus to attack target. stage2: Bounce Damage
		WType = 2,
	},
	Skarner = {
		QDmgM = "12*Qlvl+12+.4*ap",
		QDmgP = "15*Qlvl+10+.8*bad",
		EDmgM = "40*Elvl+40+.7*ap",
		RDmgM = "100*Rlvl+100+ap",
	},
	Sona = {
		PDmgM = "math.max((math.max(7*lvl+6,8*lvl+3,9*lvl-2,10*lvl-8,15*lvl-78)+.2*ap)*2*stagedmg1,(math.max(7*lvl+6,8*lvl+3,9*lvl-2,10*lvl-8,15*lvl-78)+.2*ap)*(stagedmg2+stagedmg3))", --stage1: Staccato , stage2:Diminuendo or Tempo
		PType = 2,
		QDmgM = "50*Qlvl+.5*ap",
		RDmgM = "100*Rlvl+50+.5*ap",
	},
	Soraka = {
		QDmgM = "25*Qlvl+35+.4*ap",
		EDmgM = "30*Elvl+10+.4*ap+.05*mmana",
	},
	Swain = {
		QDmgM = "math.max(15*Qlvl+10+.3*ap,(15*Qlvl+10+.3*ap)*3*stagedmg3)", --xsec (3 sec). stage3: Max damage
		WDmgM = "40*Wlvl+40+.7*ap",
		EDmgM = "math.max((40*Elvl+35+.8*ap)*stagedmg1,(40*Elvl+35+.8*ap)*stagedmg3)", --stage1:Active.  stage2:% Extra Damage.  stage3:Active
		EDmgT = "(3*Elvl+5)*stagedmg2",
		RDmgM = "20*Rlvl+30+.2*ap", --xstrike (1 strike x sec)
	},
	Syndra = {
		QDmgM = "math.max(40*Qlvl+30+.6*ap,(40*Qlvl+30+.6*ap)*1.15*(Qlvl-4))",
		WDmgM = "40*Wlvl+40+.7*ap",
		EDmgM = "45*Elvl+25+.4*ap",
		RDmgM = "math.max(45*Rlvl+45+.2*ap,(45*Rlvl+45+.2*ap)*6*stagedmg3)", --stage1:xSphere (Minimum 3). stage3:6 Spheres
	},
	Talon = {
		QDmgP = "40*Qlvl+1.3*bad", --(bonus)
		QType = 2,
		WDmgP = "math.max(25*Wlvl+5+.6*bad,(25*Wlvl+5+.6*bad)*2*stagedmg3)", --x2 if the target is hit twice. stage3: Max damage
		EDmgT = "3*Elvl", --% Damage Amplification
		RDmgP = "math.max(50*Rlvl+70+.75*bad,(50*Rlvl+70+.75*bad)*2*stagedmg3)", --x2 if the target is hit twice. stage3: Max damage
	},
	Taric = {
		PDmgM = ".2*ar", --(bonus)
		PType = 2,
		WDmgM = "40*Wlvl+.2*ar",
		EDmgM = "math.max(30*Elvl+10+.2*ap,(30*Elvl+10+.2*ap)*2*stagedmg3)", --min (lower damage the farther the target is)  up to 200%
		RDmgM = "100*Rlvl+50+.5*ap",
	},
	Teemo = {
		QDmgM = "45*Qlvl+35+.8*ap",
		EDmgM = "math.max((10*Elvl+.3*ap)*stagedmg1,(6*Elvl+.1*ap)*stagedmg2,(34*Elvl+.7*ap)*stagedmg3)", --stage1:Hit (bonus). stage2:poison xsec (4 sec). stage3:Hit+poison for 4 sec
		--
		RDmgM = "125*Rlvl+75+.5*ap",
	},
	Thresh = {
		QDmgM = "40*Qlvl+40+.5*ap",
		EDmgM = "math.max((40*Elvl+25+.4*ap)*(stagedmg1+stagedmg3),((.3*Qlvl+.5)*ad)*stagedmg2)", --stage1:Active. stage2:Passive (+ Souls). stage3:stage1
		--
		RDmgM = "150*Rlvl+100+ap",
	},
	Tristana = {
		WDmgM = "45*Wlvl+25+.8*ap",
		EDmgM = "math.max((40*Elvl+70+ap)*stagedmg1,(25*Elvl+25+.25*ap)*stagedmg2,(40*Elvl+70+ap)*stagedmg3)", --stage1:Active.  stage2:Passive.  stage3:Active
		RDmgM = "100*Rlvl+200+1.5*ap",
	},
	Trundle = {
		QDmgP = "20*Qlvl+(5*Qlvl+95)*ad/100", --(bonus)
		QType = 2,
		RDmgM = "(2*Rlvl+18+.02*ap)*tmhp/100", --over 4 sec
	},
	Tryndamere = {
		EDmgP = "30*Elvl+40+ap+1.2*bad",
	},
	TwistedFate = {
		QDmgM = "50*Qlvl+10+.65*ap",
		WDmgM = "math.max((7.5*Wlvl+7.5+.5*ap+ad)*stagedmg1,(15*Wlvl+15+.5*ap+ad)*stagedmg2,(20*Wlvl+20+.5*ap+ad)*stagedmg3)", --stage1:Gold Card.  stage2:Red Card.  stage3:Blue Card
		EDmgM = "25*Elvl+30+.5*ap",
	},
	Twitch = {
		PDmgT = "2*math.floor(1+lvl/4.75)", --xstack xsec (6 stack 6 sec)
		EDmgP = "math.max((5*Elvl+10+.2*ap+.25*bad)*stagedmg1,(15*Elvl+5)*stagedmg2,((5*Elvl+10+.2*ap+.25*bad)*6+15*Elvl+5)*stagedmg3)", --stage1:xstack (6 stack). stage2:Base. stage3: Max damage
	},
	Udyr = {
		QDmgP = "math.max((50*Qlvl-20+(.1*Qlvl+1.1)*ad)*(stagedmg2+stagedmg3),(.15*ad)*stagedmg1)",  --stage1:persistent effect. stage2:(bonus). stage3:stage2
		QType = 2,--
		WType = 2,--
		EType = 2,--
		RDmgM = "math.max((40*Rlvl+.45*ap)*stagedmg2,(10*Rlvl+5+.25*ap)*stagedmg3)", --stage1:0. stage2:xThird Attack. stage3:x wave (5 waves)
		RType = 2,--
	},
	Urgot = {
		QDmgP = "30*Qlvl-20+.85*ad",
		EDmgP = "55*Elvl+20+.6*bad",
	},
	Varus = {
		QDmgP = "math.max(.625*(55*Qlvl-40+1.6*ad),(55*Qlvl-40+1.6*ad)*stagedmg3)", --stage1:min. stage3:max. reduced by 15% per enemy hit (minimum 33%)
		WDmgM = "math.max((4*Wlvl+6+.25*ap)*stagedmg1,((.0075*Wlvl+.0125+.02*ap)*tmhp/100)*stagedmg2,((.0075*Wlvl+.0125+.02*ap)*tmhp/100)*3*stagedmg3)", --stage1:xhit. stage2:xstack (3 stacks). stage3: 3 stacks
		EDmgP = "35*Elvl+30+.6*ad",
		RDmgM = "100*Rlvl+50+ap",
	},
	Vayne = {
		QDmgP = "(.05*Qlvl+.25)*ad", --(bonus)
		QType = 2,
		WDmgT = "10*Wlvl+10+((1*Wlvl+3)*tmhp/100)",
		EDmgP = "math.max(35*Elvl+10+.5*bad,(35*Elvl+10+.5*bad)*2*stagedmg3)", --x2 If they collide with terrain. stage3: Max damage
		RType = 2,
	},
	Veigar = {
		QDmgM = "45*Qlvl+35+.6*ap",
		WDmgM = "50*Wlvl+70+ap",
		RDmgM = "125*Rlvl+125+1.2*ap+.8*tap",
	},
	Velkoz = {
		PDmgT = "10*lvl+25",
		QDmgM = "40*Qlvl+40+.6*ap",
		WDmgM = "math.max(20*Wlvl+10+.25*ap,(20*Wlvl+10+.25*ap)*1.5*stagedmg2)",--stage1:Initial. stage2:Detonation. stage3:Initial.
		EDmgM = "30*Elvl+40+.5*ap",
		RDmgM = "20*Rlvl+30+.6*ap", --every 0.25 sec (2.5 sec), Organic Deconstruction every 0.5 sec
	},
	Vi = {
		QDmgP = "math.max(25*Qlvl+25+.8*bad,(25*Qlvl+25+.8*bad)*2*stagedmg3)", --x2 If charging up to 1.5 seconds. stage3: Max damage
		WDmgP = "((3/2)*Wlvl+5/2+(1/35)*bad)*thp/100",
		EDmgP = "15*Elvl-10+.15*ad+.7*ap", --(Bonus)
		EType = 2,
		RDmgP = "150*Rlvl+50+1.4*bad", --deals 75% damage to enemies in her way
	},
	Viktor = {
		QDmgM = "45*Qlvl+35+.65*ap",
		EDmgM = "math.max(45*Elvl+25+.7*ap,(45*Elvl+25+.7*ap)*1.3*stagedmg3)", --Augment Death deal 30% additional damage. stage3: Max damage
		RDmgM = "math.max((100*Rlvl+50+.55*ap)*stagedmg1,(20*Rlvl+20+.25*ap)*stagedmg2,(100*Rlvl+50+.55*ap+(20*Rlvl+20+.25*ap)*7)*stagedmg3)", --stage1:initial. stage2: xsec (7 sec). stage3: Max damage
	},
	Vladimir = {
		QDmgM = "35*Qlvl+55+.6*ap",
		WDmgM = "55*Wlvl+25+(mhp-(400+85*lvl))*.15", --(2 sec)
		EDmgM = "math.max((25*Elvl+35+.45*ap)*stagedmg1,((25*Elvl+35)*0.25)*stagedmg2,((25*Elvl+35)*2+.45*ap)*stagedmg3)", --stage1:25% more base damage x stack. stage2:+x stack. stage3: Max damage
		RDmgM = "100*Rlvl+50+.7*ap",
	},
	Volibear = {
		QDmgP = "30*Qlvl", --(bonus)
		QType = 2,
		WDmgP = "((Wlvl-1)*45+80+(mhp-(440+lvl*86))*.15)*(1+(tmhp-thp)/tmhp)",
		EDmgM = "45*Elvl+15+.6*ap",
		RDmgM = "80*Rlvl-5+.3*ap", --xhit
		RType = 2,
	},
	Warwick = {
		PDmgM = "math.max(.5*lvl+2.5,(.5*lvl+2.5)*3*stagedmg3)", --xstack (3 stacks). stage3: Max damage
		QDmgM = "50*Qlvl+25+ap+((2*Qlvl+6)*tmhp/100)",
		RDmgM = "math.max(17*Rlvl+33+.4*bad,(17*Rlvl+33+.4*bad)*5*stagedmg3)", --xstrike (5 strikes) , without counting on-hit effects. stage3: Max damage
	},
	MonkeyKing = {
		QDmgP = "30*Qlvl+.1*ad", --(bonus)
		QType = 2,
		WDmgM = "45*Wlvl+25+.6*ap",
		EDmgP = "45*Elvl+15+.8*bad",
		RDmgP = "math.max(90*Rlvl-70+1.1*ad,(90*Rlvl-70+1.1*ad)*4*stagedmg3)", --xsec (4 sec). stage3: Max damage
	},
	Xerath = {
		QDmgM = "40*Qlvl+40+.75*ap",
		WDmgM = "math.max((30*Qlvl+30+.6*ap)*1.5*(stagedmg1+stagedmg3),(30*Qlvl+30+.6*ap)*stagedmg2)", --stage1,3: Center. stage2: Border
		EDmgM = "30*Elvl+50+.45*ap",
		RDmgM = "55*Rlvl+135+.43*ap", --xcast (3 cast)
	},
	XinZhao = {
		QDmgP = "15*Qlvl+.2*ad", --(bonus x hit)
		QType = 2,
		EDmgM = "35*Elvl+35+.6*ap",
		RDmgP = "100*Rlvl-25+bad+15*thp/100",
	},
	Yasuo = {
		QDmgP = "20*Qlvl", -- can critically strike, dealing X% AD
		QType = 2,-- applies 100% AD and hit effects to the first target
		EDmgM = "20*Elvl+50+.6*ap",--Each cast increases the next dash's base damage by 25%, up to 100% bonus damage
		RDmgP = "100*Rlvl+100+1.5*bad",
	},
	Yorick = {
		PDmgP = ".35*ad", --xhit of ghouls
		QDmgP = "30*Qlvl+.2*ad", --(bonus)
		QType = 2,
		WDmgM = "35*Wlvl+25+ap",
		EDmgM = "30*Elvl+25+bad",
	},
	Zac = {
		QDmgM = "40*Qlvl+30+.5*ap",
		WDmgM = "15*Wlvl+25+((1*Wlvl+3+.02*ap)*tmhp/100)",
		EDmgM = "40*Elvl+40+.7*ap",
		RDmgM = "math.max(70*Rlvl+70+.4*ap,(70*Rlvl+70+.4*ap)*2.5*stagedmg3)", -- stage1:Enemies hit more than once take half damage. stage3: Max damage
	},
	Zed = {
		PDmgM = "(6+2*(math.floor((lvl-1)/6)))*tmhp/100",
		PType = 2,
		QDmgP = "math.max((40*Qlvl+35+bad)*stagedmg1,(40*Qlvl+35+bad)*.6*stagedmg2,(40*Qlvl+35+bad)*1.5*stagedmg3)",  --stage1:multiple shurikens deal 50% damage. stage2:Secondary Targets. stage3: Max damage
		EDmgP = "30*Elvl+30+.8*bad",
		RDmgP = "math.max(ad*stagedmg1,ad*stagedmg3)", --stage1:100% of Zed attack damage. stage3: stage1
		RDmgT = "(15*Rlvl+5)*stagedmg2", --stage2:% of damage dealt.
	},
	Ziggs = {
		PDmgM = "math.max(4*lvl+16,8*lvl-8,12*lvl-56)+(.2+.05*math.floor((lvl+5)/6))*ap",
		PType = 2,
		QDmgM = "45*Qlvl+30+.65*ap",
		WDmgM = "35*Wlvl+35+.35*ap",
		EDmgM = "25*Elvl+15+.3*ap", --xmine , 40% damage from additional mines
		RDmgM = "125*Rlvl+125+.9*ap", --enemies away from the primary blast zone will take 80% damage
	},
	Zilean = {
		QDmgM = "57.5*Qlvl+32.5+.9*ap",
	},
	Zyra = {
		PDmgT = "80+20*lvl",
		QDmgM = "35*Qlvl+35+.65*ap",
		WDmgM = "23+6.5*lvl+.2*ap", --xstrike Extra plants striking the same target deal 50% less damage
		EDmgM = "35*Elvl+25+.5*ap",
		RDmgM = "85*Rlvl+95+.7*ap",
	},
}

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
	local Qlvl = owner:GetSpellData(_Q).level
	local Wlvl = owner:GetSpellData(_W).level
	local Elvl = owner:GetSpellData(_E).level
	local Rlvl = owner:GetSpellData(_R).level
	local stagedmg1,stagedmg2,stagedmg3 = 1,0,0
	if spelllvl ~= nil then Qlvl,Wlvl,Elvl,Rlvl = spelllvl,spelllvl,spelllvl,spelllvl end
	if stagedmg ~= nil and stagedmg == 2 then stagedmg1,stagedmg2,stagedmg3 = 0,1,0
	elseif stagedmg ~= nil and stagedmg == 3 then stagedmg1,stagedmg2,stagedmg3 = 0,0,1 end
	local TrueDmg = 0
	local TypeDmg = 1 --1 ability/normal--2 bonus to attack
	local XM = false
	if name == "Jayce" or name == "Nidalee" or name == "Elise" then XM = true end
	if (spellname == "Q" and Qlvl == 0) or (spellname == "W" and Wlvl == 0) or (spellname == "E" and Elvl == 0) or (Rlvl == 0 and (spellname == "R" or spellname == "QM" or spellname == "WM" or spellname == "EM")) then
		TrueDmg = 0
	elseif spellname == "Q" or spellname == "W" or spellname == "E" or spellname == "R" or spellname == "P" or (XM and (spellname == "QM" or spellname == "WM" or spellname == "EM")) then
		local dmgtxtm = spellDmg[name][spellname.."DmgM"]
		local dmgtxtp = spellDmg[name][spellname.."DmgP"]
		local dmgtxtt = spellDmg[name][spellname.."DmgT"]
		local replacetext = {"stagedmg1", "stagedmg2", "stagedmg3", "tap", "thp", "tmhp", "ap", "bad", "ad", "ar", "mmana", "mana", "mhp", "Qlvl", "Wlvl", "Elvl", "Rlvl", "lvl"}
		local replaceto = {stagedmg1, stagedmg2, stagedmg3, tap, thp, tmhp, ap, bad, ad, ar, mmana, mana, mhp, Qlvl, Wlvl, Elvl, Rlvl, lvl}
		for i=1, #replacetext do
			dmgtxtm = dmgtxtm and dmgtxtm:gsub(replacetext[i], replaceto[i]) or dmgtxtm
			dmgtxtp = dmgtxtp and dmgtxtp:gsub(replacetext[i], replaceto[i]) or dmgtxtp
			dmgtxtt = dmgtxtt and dmgtxtt:gsub(replacetext[i], replaceto[i]) or dmgtxtt
		end
		local dmgm = dmgtxtm and load("return "..dmgtxtm)() or 0
		local dmgp = dmgtxtp and load("return "..dmgtxtp)() or 0
		local dmgt = dmgtxtt and load("return "..dmgtxtt)() or 0
		if dmgm > 0 then dmgm = owner:CalcMagicDamage(target,dmgm) end
		if dmgp > 0 then dmgp = owner:CalcDamage(target,dmgp) end
		TrueDmg = dmgm+dmgp+dmgt
		local TypeDmg2 = spellDmg[name][spellname.."Type"]
		TypeDmg = TypeDmg2 and TypeDmg2 or 1
	elseif (spellname == "AD") then
		TrueDmg = owner:CalcDamage(target,ad)
	elseif (spellname == "IGNITE") then
		TrueDmg = 50+20*lvl
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
		TrueDmg = math.max(owner:CalcDamage(target,.05*thp)*(stagedmg1+stagedmg3),owner:CalcDamage(target,math.max(.15*tmhp,100))*stagedmg2) --stage1:Passive. stage2:Active. stage3: stage1
	elseif (spellname == "MURAMANA") then
		TrueDmg = owner:CalcDamage(target,.06*mana)
	elseif (spellname == "HURRICANE") then
		TrueDmg = owner:CalcDamage(target,10+.5*ad) --apply on-hit effects
	elseif (spellname == "SPIRITLIZARD") then
		TrueDmg = 14+2*lvl --over 3 sec
	elseif (spellname == "SUNFIRE") then
		TrueDmg = owner:CalcMagicDamage(target,25+lvl) --x sec
	elseif (spellname == "LIGHTBRINGER") then
		TrueDmg = owner:CalcMagicDamage(target,100) -- 20% chance
	elseif (spellname == "MOUNTAIN") then
		TrueDmg = owner:CalcMagicDamage(target,.3*ap+ad)
	elseif (spellname == "ISPARK" or spellname == "MADREDS" or spellname == "ECALLING" or spellname == "EXECUTIONERS" or spellname == "MALADY") then
		TrueDmg = 0
	else
		PrintChat("Error spellDmg "..name.." "..spellname)
		TrueDmg = 0
	end
	return TrueDmg, TypeDmg
end