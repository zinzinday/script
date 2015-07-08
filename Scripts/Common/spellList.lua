--[[
	Script: spellList library v0.1c
	Author: SurfaceS
	
	V0.1	initial release
	v0.1b	added new champs
	v0.1c	modified according to barasia283 script
]]

spellList = {
	-- All
	SummonerClairvoyance = {charName = "", range = 50000, spellType = 3, size = 1300, duration = 6000},

	-- Ahri
	AhriOrbofDeception = {charName = "Ahri", range = 880, spellType = 1, size = 80, duration = 1000, speed = 1.17, delay = 300, spellKey = _Q, spammable = true},
	AhriSeduce = {charName = "Ahri", range = 975, spellType = 1, size = 80, duration = 1000, speed = 1.2, delay = 300, spellKey = _E, spammable = true},

	-- Amumu
	-- Bandage Toss
	BandageToss = {charName = "Amumu", range = 1100, spellType = 1, size = 80, duration = 1000, speed = 2, delay = 300, spellKey = _Q, spammable = true},

	-- Anivia
	-- Flash Frost
	-- check wich one is working
	FlashFrostSpell = {charName = "Anivia", range = 1100, spellType = 1, size = 90, duration = 2000, speed = 0.845, delay = 300, spellKey = _Q, spammable = true},
	-- Glacial Storm 
	GlacialStorm = {charName = "Anivia", range = 625, spellType = 3, size = 300, duration = 4000},

	-- Ashe
	-- Enchanted Crystal Arrow
	EnchantedCrystalArrow = {charName = "Ashe", range = 50000, spellType = 1, size = 120, duration = 4000},

	-- Blitzcrank
	-- Rocket Grab
	RocketGrabMissile = {charName = "Blitzcrank", range = 925, spellType = 1, size = 80, duration = 1000, speed = 1.7, delay = 300, spellKey = _Q, spammable = true},
				
	-- Brand
	-- Sear
	BrandBlazeMissile = {charName = "Brand", range = 1050, spellType = 1, size = 50, duration = 1000},
	-- Pillar of Flame
	BrandFissure = {charName = "Brand", range = 900, spellType = 3, size = 250, duration = 1000},

	-- Caitlyn
	-- Piltover Peacemaker 
	CaitlynPiltoverPeacemaker = {charName = "Caitlyn", range = 1300, spellType = 1, size = 80, duration = 1000},
	-- 90 Caliber Net
	CaitlynEntrapmentMissile = {charName = "Caitlyn", range = 1000, spellType = 1, size = 50, duration = 1000},

	-- Cassiopeia
	-- Noxious Blast
	CassiopeiaNoxiousBlast = {charName = "Cassiopeia", range = 850, spellType = 3, size = 75, duration = 1000},
	-- Miasma
	CassiopeiaMiasma = {charName = "Cassiopeia", range = 850, spellType = 3, size = 175, duration = 1000},
	-- Petrifying Gaze
	CassiopeiaPetrifyingGaze = {charName = "Cassiopeia", range = 850, spellType = 6, size = 300, duration = 1000},

	-- Cho'Gath
	-- Rupture
	Rupture = {charName = "Chogath", range = 950, spellType = 3, size = 275, duration = 1500},

	-- Corki
	-- Phosphorus Bomb
	-- to check
	PhosphorusBomb = {charName = "Corki", range = 650, spellType = 3, size = 150, duration = 1000},
	-- Missile Barrage
	MissileBarrageMissile = {charName = "Corki", range = 1225, spellType = 1, size = 80, duration = 1000, speed = 2.0, delay = 300, spellKey = _R, spammable = true},
	MissileBarrageMissile2 = {charName = "Corki", range = 1225, spellType = 1, size = 100, duration = 1000, speed = 2.0, delay = 300, spellKey = _R, spammable = true},
	CarpetBomb = {charName = "Corki", range = 800, spellType = 2, size = 150, duration = 1000},

	-- Diana
	DianaArc = {charName = "Diana", range = 900, spellType = 3, size = 205, duration = 1000},

	-- Draven
	DravenDoubleShot = {charName = "Draven", range = 1050, spellType = 1, size = 125, duration = 1000},
	DravenRCast = {charName = "Draven", range = 20000, spellType = 1, size = 100, duration = 6000},

	-- DrMundo
	-- Infected Cleaver
	InfectedCleaver = {charName = "DrMundo", range = 1000, spellType = 1, size = 80, duration = 1000, speed = 2, delay = 300, spellKey = _Q, spammable = true},
	InfectedCleaverMissile = {charName = "DrMundo", range = 1000, spellType = 1, size = 80, duration = 1000, speed = 2, delay = 300, spellKey = _Q, spammable = true},

	-- Ezreal
	-- Mystic Shot
	EzrealMysticShotMissile = {charName = "Ezreal", range = 1200, spellType = 1, size = 50, delay = 250, speed = 1975, duration = 1000, spellKey = _Q, spammable = true},
	-- Essence Flux
	EzrealEssenceFluxMissile = {charName = "Ezreal", range = 900, spellType = 1, size = 100, duration = 1000, speed = 1.5, delay = 300, spellKey = _W, spammable = true},
	-- Trueshot Barrage 
	EzrealTrueshotBarrage = {charName = "Ezreal", range = 50000, spellType = 4, size = 150, duration = 4000, speed = 0, delay = 1000, spellKey = _R},
	-- Arcane Shift
	EzrealArcaneShift = {charName = "Ezreal", range = 475, spellType = 5, size = 100, duration = 1000, spellKey = _E, spammable = true},

	--Fizz
	FizzMarinerDoom = {charName = "Fizz", range = 1275, spellType = 2, size = 100, duration = 1500},

	--FiddleSticks
	Crowstorm = {charName = "FiddleSticks", range = 800, spellType = 3, size = 600, duration = 1500},

	-- Galio
	-- Resolute Smite
	GalioResoluteSmite = {charName = "Galio", range = 900, spellType = 3, size = 200, duration = 1500},
	-- Righteous Gust
	GalioRighteousGust = {charName = "Galio", range = 1000, spellType = 1, size = 200, duration = 1500},

	-- Gragas
	-- Barrel Roll
	GragasBarrelRoll = {charName = "Gragas", range = 1100, spellType = 3, size = 320, duration = 2500, speed = 1, delay = 300, spellKey = _Q, spammable = true},
	-- Explosive Cask 
	GragasExplosiveCask = {charName = "Gragas", range = 1050, spellType = 3, size = 400, duration = 1500},
	-- Body Slam
	GragasBodySlam = {charName = "Gragas", range = 650, spellType = 2, size = 60, duration = 1500},


	-- Graves
	GravesChargeShot = {charName = "Graves", range = 1000, spellType = 1, size = 110, duration = 1000},
	GravesClusterShot = {charName = "Graves", range = 750, spellType = 1, size = 50, duration = 1000},
	GravesSmokeGrenade = {charName = "Graves", range = 700, spellType = 3, size = 275, duration = 1500},

	-- Heimerdinger
	-- CH-1 Concussion Grenade 
	CH1ConcussionGrenade = {charName = "Heimerdinger", range = 950, spellType = 3, size = 225, duration = 1500},

	-- Irelia
	IreliaTranscendentBlades = {charName = "Irelia", range = 1200, spellType = 1, size = 80, duration = 800},

	-- Janna
	HowlingGale = {charName = "Janna", range = 1700, spellType = 1, size = 100, duration = 2000},

	-- JarvanIV
	JarvanIVDemacianStandard = {charName = "JarvanIV", range = 830, spellType = 3, size = 150, duration = 2000},
	JarvanIVDragonStrike = {charName = "JarvanIV", range = 770, spellType = 1, size = 70, duration = 1000},
	JarvanIVCataclysm = {charName = "JarvanIV", range = 650, spellType = 3, size = 300, duration = 1500},

	-- Kartus
	LayWaste = {charName = "Karthus", range = 875, spellType = 3, size = 150, duration = 1000},

	--Kassadin
	RiftWalk = {charName = "Kassadin", range = 700, spellType = 5, size = 150, duration = 1000},

	-- Katarina
	ShadowStep = {charName = "Katarina", range = 700, spellType = 3, size = 75, duration = 1000},

	-- Kennen
	-- Thundering Shuriken 
	KennenShurikenThrow = {charName = "Kennen", range = 1050, spellType = 1, size = 75, duration = 1000, speed = 1.7, delay = 300, spellKey = _Q, spammable = true},
	KennenShurikenHurlMissile1 = {charName = "Kennen", range = 1050, spellType = 1, size = 75, duration = 1000, speed = 1.7, delay = 300, spellKey = _Q, spammable = true},

	-- KogMaw
	-- Void Ooze
	KogMawVoidOoze = {charName = "KogMaw", range = 1115, spellType = 1, size = 100, duration = 1000},
	KogMawVoidOozeMissile = {charName = "KogMaw", range = 1115, spellType = 1, size = 100, duration = 1000},
	-- Living Artillery 
	KogMawLivingArtillery = {charName = "KogMaw", range = 2200, spellType = 3, size = 200, duration = 1500},

	-- Leblanc
	-- Sigil of Silence
	--spellArray["LeblancChaosOrb"] = {range = 700, spellType = 6, callBack = "Move", callBackDelay = 850}
	LeblancSoulShackle = {charName = "Leblanc", range = 1000, spellType = 1, size = 80, duration = 1000},
	LeblancSoulShackleM = {charName = "Leblanc", range = 1000, spellType = 1, size = 80, duration = 1000},
	LeblancSlide = {charName = "Leblanc", range = 600, spellType = 3, size = 250, duration = 1000},
	LeblancSlideM = {charName = "Leblanc", range = 600, spellType = 3, size = 250, duration = 1000},
	leblancslidereturn = {charName = "Leblanc", range = 1000, spellType = 3, size = 50, duration = 1000},
	leblancslidereturnm = {charName = "Leblanc", range = 1000, spellType = 3, size = 50, duration = 1000},

	-- LeeSin
	-- Sonic Wave
	BlindMonkQOne = {charName = "LeeSin", range = 975, spellType = 1, size = 80, duration = 1000, speed = 1.8, delay = 300, spellKey = _Q, spammable = true},
	BlindMonkRKick = {charName = "LeeSin", range = 1200, spellType = 1, size = 100, duration = 1000, spellKey = _R},

	-- Leona
	LeonaZenithBladeMissile = {charName = "Leona", range = 700, spellType = 1, size = 80, duration = 1000},

	-- Lulu
	LuluQ = {charName = "Lulu", range = 975, spellType = 1, size = 50, duration = 1000},

	-- Lux
	--LuxMaliceCannon
	LuxLightBinding = {charName = "Lux", range = 1300, spellType = 1, size = 80, duration = 1000, speed = 1.17, delay = 300, spellKey = _Q, spammable = true},
	LucentSingularity = {charName = "Lux", range = 1100, spellType = 3, size = 300, duration = 2500, speed = 1.24, delay = 300, spellKey = _E, spammable = true},
	LuxLightStrikeKugel = {charName = "Lux", range = 1100, spellType = 3, size = 300, duration = 2500, speed = 1.24, delay = 300, spellKey = _E, spammable = true},
	FinalesFunkeln = {charName = "Lux", range = 3000, spellType = 1, size = 80, duration = 1500, speed = 0, delay = 500, spellKey = _R},
	LuxMaliceCannon = {charName = "Lux", range = 3000, spellType = 1, size = 80, duration = 1500, speed = 0, delay = 500, spellKey = _R},
		
	-- Malphite
	UFSlash = {charName = "Malphite", range = 1000, spellType = 3, size = 325, duration = 1000},

	-- Malzahar
	AlZaharCalloftheVoid = {charName = "Malzahar", range = 900, spellType = 3, size = 100, duration = 1000},
	AlZaharNullZone = {charName = "Malzahar", range = 800, spellType = 3, size = 250, duration = 1000},
		
	-- Maokai
	MaokaiTrunkLineMissile = {charName = "Maokai", range = 600, spellType = 1, size = 100, duration = 1000},
	MaokaiSapling2 = {charName = "Maokai", range = 1100, spellType = 3, size = 350, duration = 1000},

	-- MissFortune
	MissFortuneScattershot = {charName = "MissFortune", range = 800, spellType = 3, size = 400, duration = 1000},
		
	-- Morgana
	-- Dark Binding
	DarkBinding = {charName = "Morgana", range = 1300, spellType = 1, size = 100, duration = 1500, speed = 1.2, delay = 300, spellKey = _Q, spammable = true},
	DarkBindingMissile = {charName = "Morgana", range = 1300, spellType = 1, size = 100, duration = 1500, speed = 1.2, delay = 300, spellKey = _Q, spammable = true},
	-- Tormented Soil
	TormentedSoil = {charName = "Morgana", range = 900, spellType = 3, size = 350, duration = 1500},

	-- Nautilus
	NautilusAnchorDrag = {charName = "Nautilus", range = 950, spellType = 1, size = 80, duration = 1500},

	-- Nidalee
	-- Javelin Toss
	JavelinToss = {charName = "Nidalee", range = 1500, spellType = 1, size = 80, duration = 1500, speed = 1.3, delay = 300, spellKey = _Q, spammable = true},

	-- Nocturne
	NocturneDuskbringer = {charName = "Nocturne", range = 1200, spellType = 1, size = 80, duration = 1500},

	-- Olaf
	-- Undertow
	OlafAxeThrow = {charName = "Olaf", range = 1000, spellType = 2, size = 100, duration = 1500, speed = 1.6, delay = 300, spellKey = _Q, spammable = true},

	-- Orianna
	OrianaIzunaCommand = {charName = "Orianna", range = 825, spellType = 3, size = 150, duration = 1500},

	-- Renekton
	RenektonSliceAndDice = {charName = "Renekton", range = 450, spellType = 1, size = 80, duration = 1000},
	renektondice = {charName = "Renekton", range = 450, spellType = 1, size = 80, duration = 1000},

	-- Rumble
	RumbleGrenadeMissile = {charName = "Rumble", range = 1000, spellType = 1, size = 100, duration = 1500},
	--RumbleCarpetBomb = {charName = "Rumble", range = 1700, spellType = 1, size = 100, duration = 1500},

	-- Sejuani
	SejuaniGlacialPrison = {charName = "Sejuani", range = 1150, spellType = 1, size = 80, duration = 1000},

	-- Sivir
	-- Boomerang Blade 
	SpiralBlade = {charName = "Sivir", range = 1000, spellType = 1, size = 100, duration = 1000, speed = 1.33, delay = 300, spellKey = _Q, spammable = true},

	-- Singed
	MegaAdhesive = {charName = "Singed", range = 1000, spellType = 3, size = 350, duration = 1500},

	-- Shaco
	Deceive = {charName = "Shaco", range = 500, spellType = 5, size = 100, duration = 3500},

	-- Shen
	ShenShadowDash = {charName = "Shen", range = 600, spellType = 2, size = 80, duration = 1000},

	-- Shyvana
	ShyvanaTransformLeap = {charName = "Shyvana", range = 925, spellType = 1, size = 80, duration = 1500},
	ShyvanaFireballMissile = {charName = "Shyvana", range = 1000, spellType = 1, size = 80, duration = 1000},

	-- Skarner
	SkarnerFracture = {charName = "Skarner", range = 600, spellType = 1, size = 100, duration = 1000},

	-- Sona
	SonaCrescendo = {charName = "Sona", range = 1000, spellType = 1, size = 150, duration = 1000},

	-- Swain
	--Nevermove
	SwainShadowGrasp = {charName = "Swain", range = 900, spellType = 3, size = 265, duration = 1500},

	-- Tristana
	RocketJump = {charName = "Tristana", range = 900, spellType = 3, size = 200, duration = 1000},

	-- Tryndamere
	MockingShout = {charName = "Tryndamere", range = 850, spellType = 6, size = 100, duration = 1000},
	Slash = {charName = "Tryndamere", range = 600, spellType = 2, size = 100, duration = 1000},

	-- TwistedFate
	WildCards = {charName = "TwistedFate", range = 1450, spellType = 1, size = 80, duration = 1000},

	-- Urgot
	UrgotHeatseekingLineMissile = {charName = "Urgot", range = 1000, spellType = 1, size = 80, duration = 800},
	UrgotPlasmaGrenade = {charName = "Urgot", range = 950, spellType = 3, size = 300, duration = 1000},

	-- Varus
	VarusR = {charName = "Varus", range = 1075, spellType = 1, size = 80, duration = 1500, spellKey = _R},
	--VarusQ = {charName = "Varus", range = 1475, spellType = 1, size = 50, duration = 1000},

	-- Vayne
	VayneTumble = {charName = "Vayne", range = 250, spellType = 5, size = 100, duration = 1000},

	-- Veigar
	VeigarDarkMatter = {charName = "Veigar", range = 900, spellType = 3, size = 225, duration = 2000},

	-- Viktor
	--ViktorDeathRay = {charName = "Viktor", range = 700, spellType = 1, size = 80, duration = 2000},

	-- Xerath
	xeratharcanopulsedamage = {charName = "Xerath", range = 900, spellType = 1, size = 80, duration = 1000},
	xeratharcanopulsedamageextended = {charName = "Xerath", range = 1300, spellType = 1, size = 80, duration = 1000},
	xeratharcanebarragewrapper = {charName = "Xerath", range = 900, spellType = 3, size = 250, duration = 1000},
	xeratharcanebarragewrapperext = {charName = "Xerath", range = 1300, spellType = 3, size = 250, duration = 1000},

	-- Ziggs
	ZiggsQ = {charName = "Ziggs", range = 850, spellType = 3, size = 160, duration = 1000, spellKey = _Q},
	ZiggsW = {charName = "Ziggs", range = 1000, spellType = 3, size = 225, duration = 1000, spellKey = _W},
	ZiggsE = {charName = "Ziggs", range = 900, spellType = 3, size = 250, duration = 1000, spellKey = _E},
	ZiggsR = {charName = "Ziggs", range = 5300, spellType = 3, size = 550, duration = 3000, spellKey = _R},
	
	-- Zyra
	ZyraQFissure = {charName = "Zyra", range = 825, spellType = 3, size = 275, duration = 1500, spellKey = _Q},
	ZyraGraspingRoots = {charName = "Zyra", range = 1100, spellType = 1, size = 90, duration = 1500, spellKey = _E},
}
