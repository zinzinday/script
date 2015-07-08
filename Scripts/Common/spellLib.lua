spellList = {
    ["Aatrox"] = {
	Q = { range = 650, width = 150, speed = 450, delay = .27, collision=false },
	E = { range = 1000, width = 150, speed = 1200, delay = .27, collision=false }
 	},
	["Ahri"] = {
	Q = { range = 880, width = 100, speed = 1100, delay = .24, collision=false },
 	E = { range = 975,  width = 60, speed = 1200, delay = .24, collision=true }
  	},
 	["Amumu"] = {
	Q = { range = 1100, width = 80, speed = 2000, delay = .25, collision=true }
 	},
 	["Anivia"] = {
	Q = { range = 1200, width = 110, speed = 850, delay = .25, collision=false }
 	},
 	["Annie"] = {
    W = { range = 625, width = 200, speed = math.huge, delay = .25, collision=false },
    R = { range = 600, width = 250, speed = math.huge, delay = .2, collision=false }
 	},
	["Ashe"] = {
	W = { range = 1200, width = 500, speed = 902, delay = .12, collision=false },
	R = { range = 50000, width = 130, speed = 1600, delay = .5, collision=false }
 	},
 	["Blitzcrank"] = {
	Q = { range = 925, width = 70, speed = 1800, delay = 0.25, collision=true }
 	},
 	["Brand"] = {
	Q = { range = 1050, width = 80, speed = 1200, delay = 0.5, collision=true },
	W = { range = 1050, width = 275, speed = 900, delay = 0.25, collision=false }
 	},
 	["Caitlyn"] = {
	Q = { range = 1250, width = 90, speed = 1600, delay = 0.6, collision=false },
	W = { range = 800, width = 30, speed = 500, delay = 0.6, collision=false },
	E = { range = 950, width = 80, speed = 2000, delay = 0.4, collision=true }
 	},
 	["Cassiopeia"] = {
	Q = { range = 875, width = 130, speed = math.huge, delay = 0.5, collision=false },
	W = { range = 875, width = 212, speed = math.huge, delay = 0.4, collision=false },
	E = { range = 875, width = 210, speed = math.huge, delay = 0.5, collision=false }
 	},
 	["Cho'Gath"] = {
	Q = { range = 950, width = 300, speed = 950, delay = 0.5, collision=false },
	W = { range = 650, width = 275, speed = math.huge, delay = 0.5, collision=false }
 	},
 	["Corki"] = {
	Q = { range = 825, speed = 700, width = 250, delay = 0.4, collision=false },
	R = { range = 1225, width = 80, speed = 2000, delay = 0.2, collision=true },
	R2 = {  range = 1225, width = 100, speed = 2000, delay = 0.2, collision=true }
 	},
 	["Darius"] = {
	E = { range = 530, width = 300, speed = 1500, delay = 0.5, collision=false }
 	},
 	["DrMundo"] = {
	Q = { range = 1000, width = 80, speed = 1500, delay = 0.5, collision=true }
 	},
 	["Dianna"] = {
	Q = { range = 830, width = 80, speed = 2000, delay = 0.5, collision=false }
 	},
 	["Draven"] = {
	E = { range = 1050, speed = 1400, width = 125, delay = 0.25, collision=false },
	R = { range = 20000, speed = 2000, width = 100, delay = 0.5, collision=false }
 	},
 	["Elise"] = {
	E = { range = 975, width = 70, speed = 1300, delay = .25, collision=true }
 	},
 	["Evelynn"] = {
	R = { range = 650, width = 650, speed = 1200, delay = .25, collision=false }
 	},
 	["Ezreal"] = {
	Q = { range = 1200, width = 50, delay = .25, speed = 1975, collision=true },
	W = { range = 900, width = 100, speed = 1600, delay = 0.25, collision=false },
	R = { range = 50000, width = 150, speed = 2000, delay = 1, collision=false }
 	},
 	["Fizz"] = {
	R = { range = 1150, speed = 1350, width = 100, delay = 0.25, collision=false }
 	},
 	["Galio"] = {
	Q = { range = 900, width = 250, speed = 1300, delay = 0.25, collision=false },
	E = { range = 1000, width = 200, speed = 1200, delay = 0.25, collision=false }
 	},
 	["GangPlank"] = {
	R = { range = 20000, speed = 1800, width = 525, delay = 0.5, collision=false }
 	},
 	["Gragas"] = {
	Q = { range = 1000, width = 300, speed = 1000, delay = 0.25, collision=false },
	R = { range = 1050, width = 400, delay = 0.25, speed = 200, collision=false },
	E = { range = 600, speed = math.huge, width = 50, delay = 0.25, collision=true }
 	},
 	["Graves"] = {
	Q = { range = 950, speed = 1950, width = 50, delay = 0.25, collision=false },
	W = { range = 950, speed = 1650, width = 250, delay = 0.3, collision=false },
	R = { range = 1000, speed = 2100, width = 100, delay = 0.25, collision=false }
 	},
 	["Hecarim"] = {
    R = { range = 1100, speed = 1200, width = 600, delay = 0.25, collision=false }
 	},
 	["Heimerdinger"] = {
	W = { range = 1500, speed = 1000, width = 50, delay = 0.25, collision=true },
	E = { range = 925, speed = 1000, width = 120, delay = 0.1, collision=false }
 	},
 	["Irelia"] = {
	R = { range = 1200, speed = 900, width = 80, delay = 0.25, collision=false }
 	},
 	["Janna"] = {
	Q = { range = 1700, speed = math.huge, width = 200, delay = 0.5, collision=false }
 	},
 	["JarvanIV"] = {
	Q = { range = 770, speed = 1400, width = 70, delay = 0.25, collision=false },
	E = { range = 860, speed = 200, width = 175, delay = 0.25, collision=false }
 	},
 	["Jayce"] = {
	Q1 = { range = 1150, speed = 1300, width = 70, delay = 0.15, collision=true },
	Q2 = { range = 1750, speed = 2350, width = 70, delay = 0.15, collision=true }
 	},
 	["Jinx"] = {
	W = { range = 1450, speed = 3000, width = 60, delay = 0.6, collision=true },
	E = { range = 950, speed = 900,  width = 70, delay = 0.5, collision=false },
	R = { range = 25000, speed = 2500, width = 120, delay = 0.5, collision=false }
 	},
 	["Karma"] = {
	Q = { range = 950,  speed = 1700, width = 90, delay = 0.25, collision=true }
 	},
 	["Karthus"] = {
	Q = { range = 875, speed = 1700, width = 160, delay = 0.25, collision=false }
 	},
 	["Kassadin"] = {
	R = { range = 700, width = 270, speed = 0, delay = 0.8, collision=false },
	E = { range = 400, speed = 300,  width = 350, delay = 0.25, collision=false }
 	},
 	["Kennen"] = {
	Q = { range = 1050,  width = 75, speed = 1700, delay = 0.2, collision=true }
 	},
 	["Kha'Zix"] = {
	W = { range = 1000, speed = 828.5, width = 60, delay = 0.25, collision=true },
	E = { range = 600, speed = 500, width = 300, delay = 0.5, collision=false }
 	},
 	["KogMaw"] = {
	E = { range = 1200, speed = 1200, width = 120, delay = 0.5, collision=false },
	R = { range = 1200, speed = 1050, width = 225, delay = 0.25, collision=false }
 	},
 	["Leblanc"] = {
	E = { range = 950, speed = 1600, width = 70, delay = 0.25, collision=true }
 	},
 	["LeeSin"] = {
	Q = { range = 1100,  width = 60, speed = 1500, delay = 0.25, collision=true }
 	},
 	["Leona"] = {
    E = { range = 875, width = 80, speed = 2000, delay = 0.25, collision=false },
    R = { range = 1200, width = 300, speed = 2000, delay = 0.25, collision=false }
 	},
	["Lissandra"] = {
	Q = { range = 725, width = 75, speed = 1200, delay = 0.25, collision=false }
 	},
 	["Lucian"] = {
	W = { range = 1000, width = 80, speed = 800, delay = 0.3, collision=true }
 	},
 	["Lulu"] = {
	Q = { range = 925, speed = 1400, width = 80, delay = 0.25, collision=false }
 	},
 	["Lux"] = {
	Q = { range = 1175,  width = 80, speed = 1200, delay = 0.25, collision=true },
	E = { range = 1100,  width = 275, speed = 1300, delay = 0.25, collision=false },
	R = { range = 3340,  width = 190, speed = math.huge, delay = 0.25, collision=false }
 	},
 	["Malphite"] = {
	R = { range = 1000, speed = 700,  width = 270, delay = 0.6, collision=false }
 	},
 	["Malzahar"] = {
	Q = { range = 900, speed = 1600, delay = 0.6,  width = 200, collision=false },
	W = { range = 800, speed = 20, delay = 0.25,  width = 240, collision=false }
 	},
 	["Maokai"] = {
	Q = { range = 600, speed = 1100, delay = 0.25, width = 110, collision=false },
	E = { range = 1100, speed = 1750,  width = 325, delay = 0.25, collision=false }
 	},
 	["MissFortune"] = {
    E = { range = 800, width = 400, speed = 500, delay = 0.25, collision=false },
    R = { range = 1400, width = 100, speed = 779, delay = 0.25, collision=false }
 	},
 	["Mordekaiser"] = {
    E = { range = 700, width = 225, speed = math.huge, delay = 0.25, collision=false }
 	},
 	["Morgana"] = {
    Q = { range = 1300, width = 70, speed = 1200, delay = .25, collision=true },
    W = { range = 900, width = 350, speed = 20, delay = .25, collision=false }
 	},
 	["Nami"] = {
    Q = { range = 850, width = 325, speed = math.huge, delay = 0.8, collision=false },
    R = { range = 2550, width = 600, speed = math.huge, delay = 0.5, collision=false }
 	},
 	["Nasus"] = {
    E = { range = 650, width = 380, speed = math.huge, delay = .5, collision=false }
 	},
 	["Nautilus"] = {
	Q = { range = 950, speed = 1200, delay = 0.25, width = 80, collision=true }
 	},
 	["Nidalee"] = {
    Q = { range = 1500, width = 60, speed = 1300, delay = 0.15, collision=true }
 	},
 	["Nocturne"] = {
	Q = { range = 1200, speed = 1600,  width = 60, delay = 0.25, collision=false }
 	},
 	["Olaf"] = {
    Q = { range = 1000, width = 90, speed = 1600, delay = .25, collision=false }
 	},
 	["Orianna"] = {
	Q = { range = 825, speed = 1200, delay = 0.25, width = 80, collision=false }
 	},
 	["Pantehon"] = {
    R = { range = 5500, width = 1000, speed = 3000, delay = 1.0, collision=false }
 	},
 	["Quinn"] = }
	Q = { range = 1025, width = 80, speed = 1200, delay = .25, collision=true }
 	},
 	["Riven"] = {
    R = { range = 900, width = 200, speed = 1450, delay = .25, collision=false }
 	},
 	["Rumble"] = {
	Q = { range = 600, width = 500, speed = 5000, delay = .25, collision=false },
	E = { range = 850, width = 90, speed = 1200, delay = .25, collision=true },
	R = { range = 1700, width = 90, speed = 1200, delay = .25, collision=false }
 	},
 	["Sejuani"] = {
	Q = { range = 650, width = 75, speed = 1450, delay = .25, collision=true },
    R = { range = 1175, width = 110, speed = 1400, delay = .2, collision=false }
 	},
 	["Shen"] = {
    E = { range = 600, width = 50, speed = 1000, delay = .25, collision=false }
 	},
 	["Shyvana"] = {
    E = { range = 925, width = 60, speed = 1200, delay = .25, collision=false },
    R = { range = 1000, width = 160, speed = 700, delay = .25, collision=false }
 	},
 	["Sivir"] = {
	Q = { range = 1075, width = 90, speed = 1350, delay = .25, collision=false }
 	},
 	["Skarner"] = {
	E = { range = 980, width = 60, speed = 1200, delay = .25, collision=false }
 	},
 	["Sona"] = {
    R = { range = 900, width = 600, speed = 2400, delay = .25, collision=false }
 	},
 	["Swain"] = {
    W = { range = 900, width = 240, speed = math.huge, delay = .25, collision=false }
 	},
 	["Syndra"] = {
	Q = { range = 800, width = 180, speed = math.huge, delay = .4, collision=false }
 	},
 	["Talon"] = {
	W = { range = 650, width = 250, speed = 902, delay = .25, collision=false }
 	},
 	["Thresh"] = {
	Q = { range = 1075, width = 60, speed = 1200, delay = 0.5, collision=true },
    E = { range = 500, width = 160, speed = 1100, delay = 0.3, collision=false }
 	},
 	["Trundle"] = {
    E = { range = 1000, width = 188, speed = 1600, delay = .3, collision=false }
 	},
 	["Tryndamere"] = {
    E = { range = 650, width = 160, speed = 700, delay = .25, collision=false }
 	},
 	["TwistedFate"] = {
    Q = { range = 1450, width = 80, speed = 1450, delay = .2, collision=false }
 	},
 	["Twitch"] = {
	W = { range = 900, width = 275, speed = 1750, delay = .25, collision=false }
 	},
 	["Urgot"] = {
    Q = {range = 1000, width = 80, speed = 1600, delay = .2, collision=true },
    E = { range = 900, width = 250, speed = 1750, delay = .25, collision=false }
 	},
 	["Varus"] = {
	Q = { range = 1475, width = 100, speed = 1500, delay = .5, collision=false },
	E = { range = 925, width = 235, speed = 1750, delay = .25, collision=false },
	R = { range = 800, width = 100, speed = 1200, delay = .5, collision=false }
 	},
 	["Veigar"] = {
    W = { range = 900, width = 225, speed = 1500, delay = 25, collision=false }
 	},
 	["Vel'Koz"] = {
	Q = { range = 1050, width = 60, speed = 1300, delay = 0.06, collision=true },
    W = { range = 1050, width = 90, speed = 1700, delay = 0.06, collision=false },
    E = { range = 1100, width = 225, speed = 1500, delay = 0.3, collision=false }
 	},
 	["Viktor"] = {
    W = { range = 625, width = 300, speed = 1750, delay = .25, collision=false },
    E = { range = 550, width = 90, speed = 1200, delay = .25, collision=false },
    R = { range = 700, width = 250.3, speed = 1210, delay = .25, collision=false }
 	},
 	["Vladimir"] = {
    R = { range = 875, width = 375, speed = 1200, delay = .25, collision=false }
 	},
 	["Xerath"] = {
    Q = { range = 750, width = 100, speed = 500, delay = 1.75, collision=false },
    W = { range = 1100, width = 100, speed = 20, delay = .25, collision=false },
    E = { range = 1050, width = 70, speed = 1600, delay = .25, collision=true },
    R = { range = 3200, width = 245, speed = 500, delay = .75, collision=false }
 	},
 	["Yasuo"] = {
	Q1 = { range = 475, width = 55, speed = 1500, delay = .75, collision=false },
    Q2 = { range = 475, width = 55, speed = 1500, delay = .75, collision=false },
    Q3 = { range = 1000, width = 90, speed = 1500, delay = .75, collision=false }
 	},
 	["Yorick"] = {
    W = { range = 550, width = 200, speed = math.huge, delay = .25, collision=false }
 	},
 	["Zac"] = {
    Q = { range = 550, width = 120, speed = 902, delay = .5, collision=true },
	R = { range = 500, width = 210, speed = 1800, delay = .5, collision=false }
 	},
 	["Zed"] = {
	Q = { range = 900, width = 45, speed = 902, delay = .5, collision=false }
 	},
 	["Ziggs"] = {
	Q = { range = 850, width = 155, speed = 1750, delay = .25, collision=true },
	E = { range = 900, width = 350, speed = 1750, delay = .12, collision=false },
	R = { range = 5300, width = 600, speed = 1750, delay = .15, collision=false }
 	},
 	["Zyra"] = {
	Q = { range = 800, width = 220, speed = 1400, delay = .7, collision=false },
	E = { range = 1100, width = 70, speed = 1400, delay = .2, collision=false },
	R = { range = 1100, width = 500, speed = 20, delay = 1, collision=false }
 	},
}
