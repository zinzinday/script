return {
    ["Aatrox"] = {
        [_Q] = { name = "AatroxQ", speed = 450, delay = 0.25, range = 650, width = 150, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "AatroxE", speed = 1200, delay = 0.25, range = 1000, width = 150, collision = false, aoe = false, type = "linear"}
    },
    ["Ahri"] = {
        [_Q] = { name = "AhriOrbofDeception", speed = 1600, delay = 0.25, range = 880, width = 120, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "AhriSeduce", speed = 1550, delay = 0.25, range = 900, width = 65, collision = true, aoe = false, type = "linear"}
    },
    ["Akali"] = {
        [_E] = { name = "", speed = math.huge, delay = 0.125, range = 0, width = 325, collision = false, aoe = true, type = "circular"}
    },
    ["Alistar"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 365, collision = false, aoe = true, type = "circular"}
    },
    ["Amumu"] = {
        [_Q] = { name = "BandageToss", speed = 725, delay = 0.25, range = 1000, width = 100, collision = true, aoe = false, type = "linear"}
    },
    ["Anivia"] = {
        [_Q] = { name = "FlashFrostSpell", speed = 850, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "", speed = math.huge, delay = 0.100, range = 615, width = 350, collision = false, aoe = true, type = "circular"}
    },
    ["Annie"] = {
        [_W] = { name = "", speed = math.huge, delay = 0.25, range = 625, width = 250, collision = false, aoe = true, type = "cone"},
        [_R] = { name = "InfernalGuardian", speed = math.huge, delay = 0.25, range = 600, width = 300, collision = false, aoe = true, type = "circular"}
    },
    ["Ashe"] = {
        [_W] = { name = "Volley", speed = 902, delay = 0.5, range = 1200, width = 100, collision = true, aoe = false, type = "cone"},
        [_R] = { name = "EnchantedCrystalArrow", speed = 1600, delay = 0.5, range = 25000, width = 100, collision = true, aoe = false, type = "linear"}
    },
    ["Azir"] = {
        [_Q] = { name = "AzirQ", speed = 500, delay = 0.250, range = 800, width = 100, collision = false, aoe = false, type = "linear"},
        [_W] = { name = "AzirW", speed = math.huge, delay = 0, range = 450, width = 100, collision = false, aoe = false, type = "circular"},
        [_R] = { name = "AzirR", speed = 1300, delay = 0.2, range = 250, width = 600, collision = false, aoe = true, type = "linear"}
    },
    ["Bard"] = {
        [_Q] = { name = "", speed = 1100, delay = 0.25, range = 850, width = 108, collision = true, aoe = false, type = "linear"}
    },
    ["Blitzcrank"] = {
        [_Q] = { name = "RocketGrabMissile", speed = 1800, delay = 0.250, range = 900, width = 70, collision = true, type = "linear"},
        [_R] = { name = "StaticField", speed = math.huge, delay = 0.25, range = 0, width = 500, collision = false, aoe = false, type = "circular"}
    },
    ["Brand"] = {
        [_Q] = { name = "BrandBlaze", speed = 1200, delay = 0.5, range = 1050, width = 80, collision = false, aoe = false, type = "linear"},
        [_W] = { name = "BrandFissure", speed = 900, delay = 0.25, range = 1050, width = 275, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "BrandWildfire" }
    },
    ["Braum"] = {
        [_Q] = { name = "BraumQ", speed = 1600, delay = 225, range = 1000, width = 100, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "BraumR", speed = 1250, delay = 500, range = 1250, width = 0, collision = false, aoe = false, type = "linear"}
    },
    ["Caitlyn"] = {
        [_Q] = { name = "CaitlynPiltoverPeacemaker", speed = 2200, delay = 0.625, range = 1300, width = 0, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "CaitlynEntrapment", speed = 2000, delay = 0.400, range = 1000, width = 80, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "CaitlynAceintheHole" }
    },
    ["Cassiopeia"] = {
        [_Q] = { name = "CassiopeiaNoxiousBlast", speed = math.huge, delay = 0.25, range = 850, width = 100, collision = false, aoe = true, type = "circular"},
        [_W] = { name = "CassiopeiaMiasma", speed = math.huge, delay = 0.5, range = 925, width = 90, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "CassiopeiaTwinFang" },
        [_R] = { name = "CassiopeiaPetrifyingGaze", speed = math.huge, delay = 0.5, range = 825, width = 410, collision = false, aoe = true, type = "cone"}
    },
    ["Chogath"] = {
        [_Q] = { name = "Rupture", speed = math.huge, delay = 0.25, range = 950, width = 300, collision = false, aoe = true, type = "circular"},
        [_W] = { name = "", speed = math.huge, delay = 0.5, range = 650, width = 275, collision = false, aoe = false, type = "linear"},
    },
    ["Corki"] = {
        [_Q] = { name = "", speed = 700, delay = 0.4, range = 825, width = 250, collision = false, aoe = false, type = "circular"},
        [_R] = { name = "MissileBarrage", speed = 2000, delay = 0.200, range = 1225, width = 60, collision = false, aoe = false, type = "linear"},
    },
    ["Darius"] = {
        [_E] = { name = "", speed = 1500, delay = 0.550, range = 530, width = 0, collision = false, aoe = true, type = "cone"}
    },
    ["Diana"] = {
        [_Q] = { name = "DianaArc", speed = 2000, delay = 0.250, range = 830, width = 130, collision = false, aoe = false, type = "circular"},
        [_W] = { name = "DianaOrbs", range = 250 },
        [_E] = { name = "DianaVortex", range = 395 },
        [_R] = { name = "DianaTeleport" }
    },
    ["DrMundo"] = {
        [_Q] = { name = "InfectedCleaverMissile", speed = 2000, delay = 0.250, range = 1050, width = 75, collision = true, aoe = false, type = "linear"}
    },
    ["Draven"] = {
        [_E] = { name = "DravenDoubleShot", speed = 1400, delay = 0.250, range = 1100, width = 130, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "DravenRCast", speed = 2000, delay = 0.5, range = 25000, width = 160, collision = false, aoe = false, type = "linear"}
    },
    ["Ekko"] = {
        [_Q] = { name = "", speed = 1050, delay = 0.25, range = 925, width = 140, collision = false, aoe = false, type = "linear"},
        [_W] = { name = "", speed = math.huge, delay = 3, range = 1050, width = 450, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "", speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular"}
    },
    ["Elise"] = {
        [_E] = { name = "EliseHumanE", speed = 1450, delay = 0.250, range = 975, width = 70, collision = true, aoe = false, type = "linear"}
    },
    ["Evelynn"] = {
        [_Q] = { name = "", speed = 1300, delay = 0.250, range = 650, width = 350, collision = false, aoe = true, type = "circular" }
    },
    ["Ezreal"] = {
        [_Q] = { name = "EzrealMysticShot", speed = 2000, delay = 0.25, range = 1200, width = 65, collision = true, aoe = false, type = "linear"},
        [_W] = { name = "EzrealEssenceFlux", speed = 1200, delay = 0.25, range = 900, width = 90, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "EzrealTrueshotBarrage", speed = 2000, delay = 1, range = 25000, width = 180, collision = false, aoe = false, type = "linear"}
    },
    ["Fiddlesticks"] = {
    },
    ["Fiora"] = {
    },
    ["Fizz"] = {
        [_R] = { name = "FizzMarinerDoom", speed = 1350, delay = 0.250, range = 1150, width = 100, collision = false, aoe = false, type = "linear"}
    },
    ["Galio"] = {
        [_Q] = { name = "GalioResoluteSmite", speed = 1300, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "", speed = 1200, delay = 0.25, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
    },
    ["Gangplank"] = {
        [_R] = { name = "", speed = math.huge, delay = 0.25, range = 25000, width = 575, collision = false, aoe = true, type = "circular"}
    },
    ["Garen"] = {
    },
    ["Gnar"] = {
        [_Q] = { name = "", speed = 1225, delay = 0.125, range = 1200, width = 80, collision = true, aoe = false, type = "linear"}
    },
    ["Gragas"] = {
        [_Q] = { name = "GragasQ", speed = 1000, delay = 0.250, range = 1000, width = 300, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "GragasE", speed = math.huge, delay = 0.250, range = 600, width = 50, collision = true, aoe = true, type = "circular"},
        [_R] = { name = "GragasR", speed = 1000, delay = 0.250, range = 1050, width = 400, collision = false, aoe = true, type = "circular"}
    },
    ["Graves"] = {
        [_Q] = { name = "", speed = 1950, delay = 0.265, range = 750, width = 85, collision = false, aoe = false, type = "cone"},
        [_W] = { name = "", speed = 1650, delay = 0.300, range = 700, width = 250, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "", speed = 2100, delay = 0.219, range = 1000, width = 100, collision = false, aoe = false, type = "linear"}
    },
    ["Hecarim"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.250, range = 0, width = 350, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "", speed = 1900, delay = 0.219, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
    },
    ["Heimerdinger"] = {
        [_W] = { name = "", speed = 900, delay = 0.500, range = 1325, width = 100, collision = true, aoe = false, type = "linear"},
        [_E] = { name = "", speed = 2500, delay = 0.250, range = 970, width = 180, collision = false, aoe = true, type = "circular"}
    },
    ["Irelia"] = {
        [_R] = { name = "", speed = 1700, delay = 0.250, range = 1200, width = 25, collision = false, aoe = false, type = "linear"}
    },
    ["Janna"] = {
        [_Q] = { name = "HowlingGale", speed = 1500, delay = 0.250, range = 1700, width = 150, collision = false, aoe = false, type = "linear"}
    },
    ["JarvanIV"] = {
        [_Q] = { name = "", speed = 1400, delay = 0.2, range = 770, width = 0, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "", speed = 200, delay = 0.2, range = 850, width = 0, collision = false, aoe = false, type = "linear"}
    },
    ["Jax"] = {
        [_E] = { name = "", speed = math.huge, delay = 0.250, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
    },
    ["Jayce"] = {
        [_Q] = { name = "jayceshockblast", speed = 2350, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear"}
    },
    ["Jinx"] = {
        [_W] = { name = "JinxWMissile", speed = 3000, delay = 0.600, range = 1400, width = 60, collision = true, aoe = false, type = "linear"},
        [_E] = { name = "JinxE", speed = 887, delay = 0.500, range = 830, width = 0, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "JinxR", speed = 1700, delay = 0.600, range = 20000, width = 120, collision = false, aoe = true, type = "circular"}
    },
    ["Kalista"] = {
        [_Q] = { name = "KalistaMysticShot", speed = 1750, delay = 0.25, range = 1375, width = 70, collision = true, aoe = false, type = "linear"},
    },
    ["Karma"] = {
        [_Q] = { name = "KarmaQ", speed = 1700, delay = 0.250, range = 950, width = 90, collision = true, aoe = false, type = "linear"}
    },
    ["Karthus"] = {
        [_Q] = { name = "KarthusLayWaste", speed = math.huge, delay = 0.75, range = 825, width = 120, collision = false, aoe = true, type = "circular"}
    },
    ["Kassadin"] = {
        [_E] = { name = "", speed = 2200, delay = 0, range = 650, width = 80, collision = false, aoe = false, type = "cone"},
        [_R] = { name = "", speed = math.huge, delay = 0.5, range = 500, width = 150, collision = false, aoe = true, type = "circular"}
    },
    ["Katarina"] = {
    },
    ["Kayle"] = {
    },
    ["Kennen"] = {
        [_Q] = { name = "KennenShurikenHurlMissile1", speed = 1700, delay = 0.180, range = 1050, width = 70, collision = true, aoe = false, type = "linear"}
    },
    ["KhaZix"] = {
        [_W] = { name = "KhazixW", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear"},
        [_E] = { name = "", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular"}
    },
    ["KogMaw"] = {
        [_Q] = { name = "", speed = 1725, delay = 0.125, range = 975, width = 80, collision = true, aoe = false, type = "linear"},
        [_E] = { name = "", speed = 1200, delay = 0.25, range = 1200, width = 120, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "KogMawLivingArtillery", speed = math.huge, delay = 0.65, range = 2200, width = 250, collision = false, aoe = true, type = "circular"}
    },
    ["LeBlanc"] = {
        [_E] = { name = "LeblancSoulShackle", speed = 1600, delay = 0.250, range = 960, width = 70, collision = true, aoe = false, type = "linear"}
    },
    ["LeeSin"] = {
        [_Q] = { name = "BlindMonkQOne", speed = 1750, delay = 0.25, range = 1000, width = 70, collision = true, aoe = false, type = "linear"},
        [_E] = { name = "BlindMonkEOne", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = false, type = "circular"},
        [_R] = { name = "BlindMonkR", speed = 2000, delay = 0.25, range = 2000, width = 150, collision = false, aoe = false, type = "linear"}
    },
    ["Leona"] = {
        [_E] = { name = "LeonaZenithBlade", speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "LeonaSolarFlare", speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular"}
    },
    ["Lissandra"] = {
        [_Q] = { name = "", speed = 1800, delay = 0.250, range = 725, width = 20, collision = true, aoe = false, type = "linear"}
    },
    ["Lucian"] = {
        [_Q] = { name = "LucianQ" },
        [_W] = { name = "LucianW", speed = 800, delay = 0.300, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
        [_R] = { name = "LucianR" }
    },
    ["Lulu"] = {
        [_Q] = { name = "LuluQ", speed = 1400, delay = 0.250, range = 925, width = 80, collision = false, aoe = false, type = "linear"}
    },
    ["Lux"] = {
        [_Q] = { name = "LuxLightBinding", speed = 1350, delay = 0.25, range = 1300, width = 130, collision = true, type = "linear" },
        [_W] = { name = "LuxPrismaticWave", speed = 1630, delay = 0.25, range = 1250, width = 210, collision = false, type = "linear" },
        [_E] = { name = "LuxLightStrikeKugel", speed = 1275, delay = 0.25, range = 1100, width = 325, collision = false, type = "circular" },
        [_R] = { name = "LuxMaliceCannon", speed = math.huge, delay = 1, range = 3340, width = 250, collision = false, type = "linear" }
    },
    ["Malphite"] = {
        [_R] = { name = "", speed = 1600, delay = 0.5, range = 900, width = 500, collision = false, aoe = true, type = "circular"}
    },
    ["Malzahar"] = {
        [_Q] = { name = "AlZaharCalloftheVoid1", speed = math.huge, delay = 0.5, range = 900, width = 100, collision = false, aoe = false, type = "linear"},
        [_W] = { name = "", speed = math.huge, delay = 0.5, range = 800, width = 250, collision = false, aoe = false, type = "circular"}
    },
    ["Maokai"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 100, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "", speed = 1500, delay = 0.25, range = 1100, width = 175, collision = false, aoe = false, type = "circular"}
    },
    ["MasterYi"] = {
    },
    ["MissFortune"] = {
        [_E] = { name = "", speed = math.huge, delay = 0.25, range = 800, width = 200, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "", speed = math.huge, delay = 0.25, range = 1400, width = 700, collision = false, aoe = true, type = "cone"}
    },
    ["Mordekaiser"] = {
        [_E] = { name = "", speed = math.huge, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "cone"}
    },
    ["Morgana"] = {
        [_Q] = { name = "DarkBindingMissile", speed = 1200, delay = 0.250, range = 1300, width = 80, collision = true, aoe = false, type = "linear"}
    },
    ["Nami"] = {
        [_Q] = { name = "NamiQ", speed = math.huge, delay = 0.8, range = 850, width = 0, collision = false, aoe = true, type = "circular"}
    },
    ["Nasus"] = {
        [_E] = { name = "", speed = math.huge, delay = 0.25, range = 450, width = 250, collision = false, aoe = true, type = "circular"}
    },
    ["Nautilus"] = {
        [_Q] = { name = "NautilusAnchorDrag", speed = 2000, delay = 0.250, range = 1080, width = 80, collision = true, aoe = false, type = "linear"}
    },
    ["Nidalee"] = {
        [_Q] = { name = "JavelinToss", speed = 1325, delay = 0.125, range = 1625, width = 37.5, collision = true, type = "linear"}
    },
    ["Nocturne"] = {
        [_Q] = { name = "NocturneDuskbringer", speed = 1400, delay = 0.250, range = 1125, width = 60, collision = false, aoe = false, type = "linear"}
    },
    ["Nunu"] = {
    },
    ["Olaf"] = {
        [_Q] = { name = "OlafAxeThrow", speed = 1600, delay = 0.25, range = 1000, width = 90, collision = false, aoe = false, type = "linear"}
    },
    ["Orianna"] = {
        [_Q] = { name = "OrianaIzunaCommand", speed = 1200, delay = 0.250, range = 825, width = 175, collision = false, aoe = false, type = "linear"},
        [_W] = { name = "OrianaDissonanceCommand", speed = math.huge, delay = 0.250, range = 0, width = 225, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "OrianaRedactCommand", speed = 1800, delay = 0.250, range = 825, width = 80, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "OrianaDetonateCommand", speed = math.huge, delay = 0.250, range = 0, width = 410, collision = false, aoe = true, type = "circular"}
    },
    ["Pantheon"] = {
        [_E] = { name = "", speed = math.huge, delay = 0.250, range = 400, width = 100, collision = false, aoe = true, type = "cone"},
        [_R] = { name = "", speed = 3000, delay = 1, range = 5500, width = 1000, collision = false, aoe = true, type = "circular"}
    },
    ["Poppy"] = {
    },
    ["Quinn"] = {
        [_Q] = { name = "QuinnQ", speed = 1550, delay = 0.25, range = 1050, width = 80, collision = true, aoe = false, type = "linear"}
    },
    ["Rammus"] = {
    },
    ["RekSai"] = {
        [_Q] = { name = "", speed = 1550, delay = 0.25, range = 1050, width = 180, collision = true, aoe = false, type = "linear"}
    },
    ["Renekton"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "", speed = 1225, delay = 0.25, range = 450, width = 150, collision = false, aoe = false, type = "linear"}
    },
    ["Rengar"] = {
        [_W] = { name = "RengarW", speed = math.huge, delay = 0.5, range = 0, width = 490, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "RengarE", speed = 825, delay = 0.50, range = 1000, width = 80, collision = true, aoe = false, type = "linear"}
    },
    ["Riven"] = {
        [_Q] = { name = "RivenTriCleave", speed = math.huge, delay = 0.250, range = 0, width = 225, collision = false, aoe = true, type = "circular"},
        [_W] = { name = "RivenMartyr", speed = math.huge, delay = 0.250, range = 0, width = 250, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "rivenizunablade", speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone"}
    },
    ["Rumble"] = {
        [_Q] = { name = "RumbleFlameThrower", speed = math.huge, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone"},
        [_E] = { name = "RumbleGrenadeMissile", speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear"},
        [_R] = { name = "RumbleCarpetBomb", speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear"}
    },
    ["Ryze"] = {
        [_Q] = { name = "RyzeQ", speed = 1875, delay = 0.25, range = 880, width = 55, collision = true, aoe = false, type = "linear"},
    },
    ["Sejuani"] = {
        [_R] = { name = "SejuaniGlacialPrisonCast", speed = 1600, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear"}
    },
    ["Shaco"] = {
    },
    ["Shen"] = {
        [_E] = { name = "ShenShadowDash", speed = 1200, delay = 0.25, range = 600, width = 40, collision = false, aoe = false, type = "linear"}
    },
    ["Shyvana"] = {
        [_E] = { name = "", speed = 1500, delay = 0.250, range = 925, width = 60, collision = false, aoe = false, type = "linear"}
    },
    ["Singed"] = {
    },
    ["Sion"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.125, range = 925, width = 250, collision = false, aoe = false, type = "cone"}
    },
    ["Sivir"] = {
        [_Q] = { name = "SivirQ", speed = 1330, delay = 0.250, range = 1075, width = 0, collision = false, aoe = false, type = "linear"}
    },
    ["Skarner"] = {
        [_E] = { name = "", speed = 1200, delay = 0.600, range = 350, width = 60, collision = false, aoe = false, type = "linear"}
    },
    ["Sona"] = {
        [_R] = { name = "SonaCrescendo", speed = 2400, delay = 0.5, range = 900, width = 160, collision = false, aoe = false, type = "linear"}
    },
    ["Soraka"] = {
        [_Q] = { name = "SorakaQ", speed = 2400, delay = 0.25, range = 900, width = 160, collision = false, aoe = true, type = "circular"}
    },
    ["Swain"] = {
        [_W] = { name = "SwainShadowGrasp", speed = math.huge, delay = 0.850, range = 900, width = 125, collision = false, aoe = true, type = "circular"}
    },
    ["Syndra"] = {
        [_Q] = { name = "SyndraQ", speed = math.huge, delay = 0.5, range = 790, width = 125, collision = false, aoe = true, type = "circular"},
        [_W] = { name = "syndrawcast", speed = 1500, delay = 0.25, range = 825, width = 125, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "", speed = 2500, delay = 0.25, range = 700, width = 45, collision = false, aoe = true, type = "cone"}
    },
    ["Talon"] = {
        [_W] = { name = "", speed = 900, delay = 0.7, range = 600, width = 200, collision = false, aoe = false, type = "cone"}
    },
    ["Taric"] = {
        [_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 175, collision = false, aoe = false, type = "circular"}
    },
    ["Teemo"] = {
    },
    ["Thresh"] = {
        [_Q] = { name = "ThreshQ", speed = 1825, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear"}
    },
    ["Tristana"] = {
        [_Q] = { name = "", speed = 2100, delay = 0.25, range = 900, width = 125, collision = false, aoe = false, type = "circular"}
    },
    ["Trundle"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.25, range = 1000, width = 125, collision = false, aoe = false, type = "circular"}
    },
    ["Tryndamere"] = {
        [_E] = { name = "", speed = 700, delay = 0.250, range = 650, width = 160, collision = false, aoe = false, type = "linear"}
    },
    ["TwistedFate"] = {
        [_Q] = { name = "WildCards", speed = 1500, delay = 0.250, range = 1200, width = 80, collision = false, aoe = false, type = "cone"}
    },
    ["Twitch"] = {
        [_W] = {speed = 1750, delay = 0.250, range = 950, width = 275, collision = false, aoe = true, type = "circular"}
    },
    ["Udyr"] = {
    },
    ["Urgot"] = {
        [_Q] = { name = "UrgotHeatseekingLineMissile", speed = 1575, delay = 0.175, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
        [_E] = { name = "UrgotPlasmaGrenade", speed = 1750, delay = 0.25, range = 890, width = 200, collision = false, aoe = true, type = "circular"}
    },
    ["Varus"] = {
        [_Q] = { name = "VarusQ", speed = 1500, delay = 0.5, range = 1475, width = 100, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "VarusEMissile", speed = 1750, delay = 0.25, range = 925, width = 235, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "VarusR", speed = 1200, delay = 0.5, range = 800, width = 100, collision = false, aoe = false, type = "linear"}
    },
    ["Vayne"] = {
        [_E] = { name = "", speed = 2000, delay = 0.25, range = 1000, width = 0, collision = false, aoe = false, type = "linear"}
    },
    ["Veigar"] = {
        [_Q] = { name = "", speed = 1200, delay = 0.25, range = 875, width = 75, collision = true, aoe = false, type = "linear"},
        [_W] = { name = "VeigarDarkMatter", speed = 900, delay = 1.25, range = 900, width = 110, collision = false, aoe = true, type = "circular"}
    },
    ["VelKoz"] = {
        [_Q] = { name = "VelKozQ", speed = 1300, delay = 0.066, range = 1050, width = 50, collision = true, aoe = false, type = "linear"},
        [_W] = { name = "VelKozW", speed = 1700, delay = 0.064, range = 1050, width = 80, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "VelKozE", speed = 1500, delay = 0.333, range = 850, width = 225, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "VelKozR", speed = math.huge, delay = 0.333, range = 1550, width = 50, collision = false, aoe = false, type = "linear"}
    },
    ["Vi"] = {
        [_Q] = { name = "", speed = 1500, delay = 0.25, range = 715, width = 55, collision = false, aoe = false, type = "linear"}
    },
    ["Viktor"] = {
        [_W] = { name = "", speed = 750, delay = 0.6, range = 700, width = 125, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "ViktorDeathRay", speed = 1200, delay = 0.25, range = 1200, width = 0, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "", speed = 1000, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "circular"}
    },
    ["Vladimir"] = {
    },
    ["Volibear"] = {
    },
    ["Warwick"] = {
    },
    ["Wukong"] = {
    },
    ["Xerath"] = {
        [_Q] = { name = "", speed = math.huge, delay = 1.75, range = 750, width = 100, collision = false, aoe = false, type = "linear"},
        [_W] = { name = "", speed = math.huge, delay = 0.25, range = 1100, width = 100, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "", speed = 1600, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear"},
        [_R] = { name = "", speed = math.huge, delay = 0.75, range = 3200, width = 245, collision = false, aoe = true, type = "circular"}
    },
    ["XinZhao"] = {
        [_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
    },
    ["Yasuo"] = {
        [_Q] =  { name = "YasuoQ", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear"}
    },
    ["Yorick"] = {
        [_W] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 175, collision = false, aoe = true, type = "circular"}
    },
    ["Zac"] = {
        [_Q] = { name = "", speed = 2500, delay = 0.110, range = 500, width = 110, collision = false, aoe = false, type = "linear"}
    },
    ["Zed"] = {
        [_Q] = { name = "ZedShuriken", speed = 1700, delay = 0.25, range = 900, width = 48, collision = false, aoe = false, type = "linear"},
        [_E] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 300, collision = false, aoe = true, type = "circular"}
    },
    ["Ziggs"] = {
        [_Q] = { name = "ZiggsQ", speed = 1750, delay = 0.25, range = 1400, width = 155, collision = true, aoe = false, type = "linear"},
        [_W] = { name = "ZiggsW", speed = 1800, delay = 0.25, range = 970, width = 275, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "ZiggsE", speed = 1750, delay = 0.12, range = 900, width = 350, collision = false, aoe = true, type = "circular"},
        [_R] = { name = "ZiggsR", speed = 1750, delay = 0.14, range = 5300, width = 525, collision = false, aoe = true, type = "circular"}
    },
    ["Zilean"] = {
        [_Q] = { name = "", speed = math.huge, delay = 0.5, range = 900, width = 150, collision = false, aoe = true, type = "circular"}
    },
    ["Zyra"] = {
        [-1] = { name = "zyrapassivedeathmanager" },
        [_Q] = { name = "ZyraQFissure", speed = math.huge, delay = 0.7, range = 800, width = 85, collision = false, aoe = true, type = "circular"},
        [_E] = { name = "ZyraGraspingRoots", speed = 1150, delay = 0.25, range = 1100, width = 70, collision = false, aoe = false, type = "linear"},
        [_R] = { name = "ZyraBrambleZone", speed = math.huge, delay = 1, range = 1100, width = 500, collision=false, aoe = true, type = "circular"}
    }
}