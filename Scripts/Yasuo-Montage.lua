if myHero.charName ~= "Yasuo" then return end

local version = "0.08"
local Author = "Tungkh1711"

local UPDATE_NAME = "Yasuo-Montage"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/tungkh1711/bolscript/master/Yasuo-Montage.version" .. "?rand=" .. math.random(1, 10000)
local UPDATE_PATH2 = "/tungkh1711/bolscript/master/Yasuo-Montage.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH2
local SpellList = false
_G.UseUpdater = true

function AutoupdaterMsg(msg) print("<b><font color=\"#6699FF\">"..UPDATE_NAME..":</font></b> <font color=\"#FFFFFF\">"..msg..".</font>") end
	if _G.UseUpdater then
  		local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
  		if ServerData then
    		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
    		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
    		if ServerVersion then
      			ServerVersion = tonumber(ServerVersion)
      			if tonumber(version) < ServerVersion then
        			AutoupdaterMsg("New version available"..ServerVersion)
        			AutoupdaterMsg("Updating, please don't press F9")
        			DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) 
        			SpellList = true		
      			else
        			AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
      			end
    		end
		else
    	AutoupdaterMsg("Error downloading version info")
		SpellList = true
 	end
end
--if SpellList then return end

-------------------------------------------
if not VIP_USER then
_G.BUFF_NONE = 0
_G.BUFF_GLOBAL = 1
_G.BUFF_BASIC = 2
_G.BUFF_DEBUFF = 3
_G.BUFF_STUN = 5
_G.BUFF_STEALTH = 6
_G.BUFF_SILENCE = 7
_G.BUFF_TAUNT = 8
_G.BUFF_SLOW = 10
_G.BUFF_ROOT = 11
_G.BUFF_DOT = 12
_G.BUFF_REGENERATION = 13
_G.BUFF_SPEED = 14
_G.BUFF_MAGIC_IMMUNE = 15
_G.BUFF_PHYSICAL_IMMUNE = 16
_G.BUFF_IMMUNE = 17
_G.BUFF_Vision_Reduce = 19
_G.BUFF_FEAR = 21
_G.BUFF_CHARM = 22
_G.BUFF_POISON = 23
_G.BUFF_SUPPRESS = 24
_G.BUFF_BLIND = 25
_G.BUFF_STATS_INCREASE = 26
_G.BUFF_STATS_DECREASE = 27
_G.BUFF_FLEE = 28
_G.BUFF_KNOCKUP = 29
_G.BUFF_KNOCKBACK = 30
_G.BUFF_DISARM = 31
	----------------------------------------
    --AdvancedCallback:register("OnApplyBuff", "OnRemoveBuff")
    -------------------------------------------------------------------
    class 'BuffManager'
	
	AdvancedCallback:register('OnApplyBuff', 'OnRemoveBuff')
	
	function BuffManager:__init()
		self.heroes = {}
		self.buffs  = {}
		for i = 1, heroManager.iCount do
        	local hero = heroManager:GetHero(i)
       		table.insert(self.heroes, hero)
        	self.buffs[hero.networkID] = {}
    	end
    	AddTickCallback(function () self:Tick() end)
	end

	function BuffManager:Tick()
		for i, hero in ipairs(self.heroes) do
			for i = 1, hero.buffCount do
				local buff = hero:getBuff(i)
				if self:Valid(buff) then
					local info = {unit = hero, buff = buff, slot = i, sent = false, sent2 = false}
					if not self.buffs[hero.networkID][info.buff.name] then
						self.buffs[hero.networkID][info.buff.name] = info
					end
				end
			end
		end
		for nid, table in pairs(self.buffs) do
			for i, buffs in pairs(table) do
				local buff = buffs.buff
				if self:Valid(buff) and not buffs.sent then
					local buffinfo = {name = buff.name:lower(), slot = buff.slot, duration = (buff.endT - buff.startT), startTime = buff.startT, endTime  = buff.endT, stacks = 1, type = buff.type}
					AdvancedCallback:OnApplyBuff(buffs.source, buffs.unit, buffinfo)
					buffs.sent = true
				elseif not self:Valid(buff) and not buffs.sent2 then
					local buffinfo = {name = buff.name:lower(), slot = buff.slot, duration = (buff.endT - buff.startT), startTime = buff.startT, endTime = buff.endT, stacks = 0, type = buff.type}
					AdvancedCallback:OnRemoveBuff(buffs.unit, buffinfo)
					self.buffs[buffs.unit.networkID][buff.name] = nil
					buffs.sent2 = true
				end
			end
		end
	end

	function BuffManager:Valid(buff)
		return buff and buff.name and buff.startT <= GetGameTimer() and buff.endT >= GetGameTimer()
	end

	function BuffManager:HasBuff(unit, buffname)
		return self.buffs[unit.networkID][buffname]:lower() ~= nil
	end
	----------------------------
	Buffs = BuffManager()
	----------------------------------------------------
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------

local REQUIRED_LIBS = {
        --["Selector"]  =  "https://raw.githubusercontent.com/tungkh1711/bolscript/master/Selector.lua",
	    ["HPrediction"] = "hhttps://raw.githubusercontent.com/BolHTTF/BoL/master/HTTF/Common/HPrediction.lua",
		["VPrediction"] = "https://raw.githubusercontent.com/SidaBoL/Chaos/master/VPrediction.lua"
    }
 
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
 
function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		PrintChat("<font color=\"#6699FF\">Required libraries downloaded successfully, please reload (Double F9)</font>")
	end
end
 
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		PrintChat("<font color=\"#6699FF\">Downloading libs ......</font>")
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end
 
if DOWNLOADING_LIBS then return end

--Spell data
local Ranges = {Q12 = 500,            Q3 = 1000,       W = 400,     E = 475,       R = 1300}
local Widths = {Q12 = 55,             Q3 = 90,         W = 0,       E = 0,         R = 0}
local Delays = {Q12 = 0.25,           Q3 = 0.4,        W = 0.5,     E = 0,         R = 0}
local Speeds = {Q12 = math.huge,      Q3 = 1500,       W = 1500,    E = 0,         R = 0}

local Espeed = 1100
local Eduration = 0.5
local Eduration2 = 0

local ePos, sPos, myPos = nil, nil ,nil
local TargetPos = nil
local dashPoint = nil

local TargetLock
	
local AArange = 175
local QHitPRO = 0
local QHitVPRE = 2

local TargetKnockedup = {}
local Knockups = {}
local unitknocked = 0
local targetknocked = 0

local YasuoLevel = { QEW = { 1,3,2,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2}, EQW = { 3,1,2,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2}}
      
local stopMove = false
local EBack = false	
local Qult = false 

local EStacks = 0

local ignite = nil 

local Dashing = false
local Tdashing = false
local Tdashing2 = false
local Recalling = false

local Spells = {_Q,_W,_E,_R}
local Spells2 = {"Q","W","E","R"}

local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1150, DAMAGE_PHYSICAL, true)
ts.name = "Yasuo"

local __MEC_MINIONS_INIT__ = false

local JungleMinions = minionManager(MINION_JUNGLE, 1300, myHero, MINION_SORT_MAXHEALTH_DEC)
local EnemyMinions = minionManager(MINION_ENEMY, 1300, myHero, MINION_SORT_MAXHEALTH_DEC)
local AllMinions = minionManager(MINION_ALL, 1300, myHero, MINION_SORT_MAXHEALTH_DEC)

local JungleMobs = {}
local JungleFocusMobs = {}

local YasuoMenu,YasuoOrbwalk,YasuoWall
local Target = nil

local SRadius = 180
local DRadius = 100
local SRadiusSqr = SRadius * SRadius
local DrawS = {myHero.charName}
local JumpSpots = {
['Yasuo'] = 
	{
		{From = Vector(7372, 52.565307617188, 5858),  To = Vector(7372, 52.565307617188, 5858), CastPos = Vector(7110, 58.387092590332, 5612)}, 
		{From = Vector(8222, 51.648384094238, 3158),  To = Vector(8222, 51.648384094238, 3158), CastPos = Vector(8372, 51.130004882813, 2908)}, 
		{From = Vector(3674, 50.331886291504, 7058),  To = Vector(3674, 50.331886291504, 7058), CastPos = Vector(3674, 52.459594726563, 6708)}, 
		{From = Vector(3788, 51.77613067627, 7422),  To = Vector(3788, 51.77613067627, 7422), CastPos = Vector(3774, 52,108779907227, 7706)}, 
		{From = Vector(8372, 50.384059906006, 9606),  To = Vector(8372, 50.384059906006, 9606), CastPos = Vector(7923, 53.530361175537, 9351)}, 
		{From = Vector(6650, 53.829689025879, 11766),  To = Vector(6650, 53.829689025879, 11766), CastPos = Vector(6426, 56.47679901123, 12138)}, 
		{From = Vector(1678, 52.838096618652, 8428),  To = Vector(1678, 52.838096618652, 8428), CastPos = Vector(2050, 51.777256011963, 8416)}, 
		{From = Vector(10822, 52.152740478516, 7456),  To = Vector(10822, 52.152740478516, 7456), CastPos = Vector(10894, 51.722988128662, 7192)},
		{From = Vector(11160, 52.205154418945, 7504),  To = Vector(11160, 52.205154418945, 7504), CastPos = Vector(11172, 51.725219726563, 7208)},	
		{From = Vector(6424, 48.527244567871, 5208),  To = Vector(6424, 48.527244567871, 5208), CastPos = Vector(6824, 48.720901489258, 5308)},
		{From = Vector(13172, 54.201187133789, 6508),  To = Vector(13172, 54.201187133789, 6508), CastPos = Vector(12772, 51.666019439697, 6458)}, 
		{From = Vector(11222, 52.210571289063, 7856),  To = Vector(11222, 52.210571289063, 7856), CastPos = Vector(11072, 62.272243499756, 8156)}, 
		{From = Vector(10372, 61.73225402832, 8456),  To = Vector(10372, 61.73225402832, 8456), CastPos = Vector(10772, 63.136688232422, 8456)},
		{From = Vector(4324, 51.543388366699, 6258),  To = Vector(4324, 51.543388366699, 6258), CastPos = Vector(4024, 52.466369628906, 6358)},
		{From = Vector(6488, 56.632884979248, 11192),  To = Vector(6488, 56.632884979248, 11192), CastPos = Vector(66986, 53.771095275879, 10910)},
		{From = Vector(7672, 52.87260055542, 8906),  To = Vector(7672, 52.87260055542, 8906), CastPos = Vector(7822, 52.446697235107, 9306)},

	}}
local JumpSlot = {['Yasuo'] = _E}

local priorityTable = {
	  AP = {
			"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
			"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
			"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
			},
	  Support = {
			"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
			},
	  Tank = {
			"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			
			AD_Carry = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
	}


class("TickManager")
function TickManager:__init(ticksPerSecond)
	self.TPS = ticksPerSecond
	self.lastClock = 0
	self.currentClock = 0
end
function TickManager:__type()
	return "TickManager"
end
function TickManager:setTPS(ticksPerSecond)
	self.TPS = ticksPerSecond
end
function TickManager:getTPS(ticksPerSecond)
	return self.TPS
end
function TickManager:isReady()
	self.currentClock = GetTickCount()
	if self.currentClock < self.lastClock + self.TPS then
    	return false
	end
	self.lastClock = self.currentClock
	return true
end
local tm = TickManager(200)

function OnLoad()
    Vars()
	JungleNames()
	MainMenu()
	WallMenu()
	DashMenu()
	OrbwalkMenu()
	PermaShow()
	UseVpred()
	PrintChat("<font color='#000FFF'> >>Yasuo - Montage Successfully Loaded! <<</font>")
end

function Vars()
	--Selector.Instance() 
	VP = VPrediction()
	HPred = HPrediction()
	if VIP_USER then
		--dp = DivinePred()
	end
	WJ = YasuoWallJump()
	if player.team == TEAM_RED then
    	focalPoint = Point(13936.64, 14174.86)
	else
    	focalPoint = Point(28.58, 267.16)
	end
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    	ignite = SUMMONER_2
	end
	_G.oldDrawCircle = rawget(_G, "DrawCircle")
	_G.DrawCircle = DrawCircle2
end

function MainMenu()
	-- Script Menu --
	YasuoMenu = scriptConfig("Yasuo-Montage", "Yasuo")
	-- Target Selector --
	YasuoMenu:addTS(ts)
	-- Create SubMenu --
	YasuoMenu:addSubMenu("Combo Settings", "Combo")
    YasuoMenu:addSubMenu("Harass Settings", "Harass")
	YasuoMenu:addSubMenu("LastHit Settings", "LaneLH")
	YasuoMenu:addSubMenu("LaneClear Settings", "LaneCL")
	YasuoMenu:addSubMenu("JungleClear Settings", "Jungclear")
	YasuoMenu:addSubMenu("KillSteal Settings", "KS")
	YasuoMenu:addSubMenu("Escape Settings", "Escape")
	YasuoMenu:addSubMenu("WallJump Settings", "Walljump")
	YasuoMenu:addSubMenu("Advanced Settings", "Advanced")
	YasuoMenu:addSubMenu("Extras Settings", "Extras")
	YasuoMenu:addSubMenu("Prediction Settings", "Prediction")	
	YasuoMenu:addSubMenu("Drawings Settings", "Draw")
	YasuoMenu:addSubMenu("PermaShow Settings", "PermaShow")
	-- Combo --
	YasuoMenu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Combo:addParam("UseQ2", "Use Q2 Empowered", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Combo:addParam("smarte", "Use Smart E ", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Combo:addParam("UseItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
	-- Harass --
	YasuoMenu.Harass:addParam("smartharass", "Use Smart Harass (E-Q-E)", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Harass:addParam("minrange", "Min range to E back", SCRIPT_PARAM_SLICE, 500, 100, 900)
	YasuoMenu.Harass:addParam("maxrange", "Max range to E gapclose", SCRIPT_PARAM_SLICE, 800, 100, 1300)	
	YasuoMenu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Harass:addParam("UseQ2", "Use Q2 Empowered", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Harass:addParam("LhQ", "Use Q Last Hit", SCRIPT_PARAM_ONOFF, true)
	-- Lane Last Hit and Clear --
	YasuoMenu.LaneLH:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.LaneLH:addParam("UseQ2", "Use Q2 Empowered", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.LaneLH:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.LaneCL:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.LaneCL:addParam("UseQ2", "Use Q2 Empowered", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.LaneCL:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
	-- Jungle Clear --
	YasuoMenu.Jungclear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Jungclear:addParam("UseQ2", "Use Q2 Empowered", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Jungclear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
	-- Advanced Menu --
	-- Advanced Q Menu --
	YasuoMenu.Advanced:addSubMenu("Q settings", "AdvQ")
	YasuoMenu.Advanced.AdvQ:addParam("QSlider", "Set Q2 Range", SCRIPT_PARAM_SLICE, 1000, 800, 900, 0)
	YasuoMenu.Advanced.AdvQ:addParam("ultQ", "Use Q while ulting", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Advanced.AdvQ:addParam("interruptRecallQ", "Use Q2 On Enemies Recall", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Advanced.AdvQ:addParam("Info", "--- Auto Q Settings --", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Advanced.AdvQ:addParam("LogicQ", "Don't auto Q if my health is low", SCRIPT_PARAM_ONOFF, true)		
	YasuoMenu.Advanced.AdvQ:addParam("AutoQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Advanced.AdvQ:addParam("AutoQ2", "Use Q2 Empowered", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Advanced.AdvQ:addParam("underTower", "Use Auto Q under tower", SCRIPT_PARAM_ONOFF, true)
	-- Advanced W Menu --
	YasuoMenu.Advanced:addSubMenu("W settings", "AdvW")
	YasuoMenu.Advanced.AdvW:addParam("AutoWall", "Use Wall (W)", SCRIPT_PARAM_ONOFF, true)
	-- Advanced E Menu --
	YasuoMenu.Advanced:addSubMenu("E settings", "AdvE")
	YasuoMenu.Advanced.AdvE:addParam("Etomouse", "Use E to mouse", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("E"))	
	YasuoMenu.Advanced.AdvE:addParam("useEGap", "Use E as Gap Closer", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Advanced.AdvE:addParam("underTower", "Auto-E under Tower", SCRIPT_PARAM_ONOFF, false)
	-- Advanced R Menu --
	YasuoMenu.Advanced:addSubMenu("R settings", "AdvR")
	YasuoMenu.Advanced.AdvR:addParam("Info", "--- Combo R Settings ---", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Advanced.AdvR:addParam("ComnoRhealth", "Check for target health", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Advanced.AdvR:addParam("Health", "Dont ult if target health under % ", SCRIPT_PARAM_SLICE, 20, 0, 100, -1)	
	YasuoMenu.Advanced.AdvR:addParam("underTower", "Cast R Under Tower ", SCRIPT_PARAM_ONOFF, false)	 	 	
	YasuoMenu.Advanced.AdvR:addParam("Delay", "Cast R delay for AA ", SCRIPT_PARAM_ONOFF, true)
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy ~= nil then
        	YasuoMenu.Advanced.AdvR:addParam(enemy.charName,"Use Ultimate on "..tostring(enemy.charName),SCRIPT_PARAM_ONOFF,true)
		end
	end	
	YasuoMenu.Advanced.AdvR:addParam("Info", "--- Auto R Settings ---", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Advanced.AdvR:addParam("AutoR", "Auto R on enemies knocked up ", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Advanced.AdvR:addParam("underTower2", "Cast R Under Tower ", SCRIPT_PARAM_ONOFF, false)	
	YasuoMenu.Advanced.AdvR:addParam("xEnemies", "Auto-R if x enemies knocked up ", SCRIPT_PARAM_SLICE, 2, 1, 5)		
	YasuoMenu.Advanced.AdvR:addParam("myTarget", "Auto use R only on enemies knocked by me ", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Advanced.AdvR:addParam("AutoRally", "Auto R if allies near me ", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Advanced.AdvR:addParam("xNumber", "number of allies: ", SCRIPT_PARAM_SLICE, 1, 1, 5)
	YasuoMenu.Advanced.AdvR:addParam("xRange", "Range of allies: ", SCRIPT_PARAM_SLICE, 500, 0, 1000, 1)
	YasuoMenu.Advanced.AdvR:addParam("AutoRhealth", "Check My Health ", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Advanced.AdvR:addParam("Health2", "Auto R when HP > %Health ", SCRIPT_PARAM_SLICE, 20, 0, 100, -1)
	-- Advanced Packet Menu --
	YasuoMenu.Advanced:addSubMenu("Packetcasting: ", "Packets")
	YasuoMenu.Advanced.Packets:addParam("Info", "--- Packet Settings ---", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Advanced.Packets:addParam("packetsQ", "Use packets Q", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Advanced.Packets:addParam("packetsW", "Use packets W", SCRIPT_PARAM_ONOFF, false)	
	YasuoMenu.Advanced.Packets:addParam("packetsE", "Use packets E", SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Advanced.Packets:addParam("packetsR", "Use packets R", SCRIPT_PARAM_ONOFF, false)
	-- Extra Menu --
	YasuoMenu.Extras:addParam("AutoLevel", "Auto Level",SCRIPT_PARAM_ONOFF, false)
	YasuoMenu.Extras:addParam("StartLv", "Choose start lv",SCRIPT_PARAM_LIST, 1, {"QEW","EQW"})	
	YasuoMenu.Extras:addParam("autoPotions1", "Auto potions",SCRIPT_PARAM_ONOFF,true)
	YasuoMenu.Extras:addParam("autoPotions", "Use potions when HP < %Health",SCRIPT_PARAM_SLICE, 60, 1, 100, 0)
	YasuoMenu.Extras:addParam("TS", "Select TS (Require reload)", SCRIPT_PARAM_LIST, 2, { 	 	
		"Selector", 	 	
		"Default Target Selector" 	 	
		})
	-- Prediction Menu --
	if VIP_USER then
	    YasuoMenu.Prediction:addParam("mode", "Current Prediction:", SCRIPT_PARAM_LIST, 1, {"VPrediction","HPrediction"})
	else
	    YasuoMenu.Prediction:addParam("mode", "Current Prediction:", SCRIPT_PARAM_LIST, 1, {"VPrediction","HPrediction"})
	end
    -- KillSteal --
	YasuoMenu.KS:addParam("KillSteal", "Use KillSteal", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.KS:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.KS:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.KS:addParam("UseQ2", "Use Q2", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.KS:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.KS:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
    -- Escape --
    YasuoMenu.Escape:addParam("Mouse", "Move to mouse", SCRIPT_PARAM_ONOFF, true)
    YasuoMenu.Escape:addParam("StackQ", "Stack Q when Escape", SCRIPT_PARAM_ONOFF, true)
    -- Walljump --
    YasuoMenu.Walljump:addParam("Enabled", "Enabled WallJump",  SCRIPT_PARAM_ONOFF, true)
	YasuoMenu.Walljump:addParam("StackQ", "Stack Q when Walljump", SCRIPT_PARAM_ONOFF, true)
    YasuoMenu.Walljump:addParam("DrawD", "Don't draw circles if the distance >", SCRIPT_PARAM_SLICE, 1500, 0, 10000, 0)		
    YasuoMenu.Walljump:addParam("DrawJ", "Draw jump points",  SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Walljump:addParam("DrawL", "Draw landing points",  SCRIPT_PARAM_ONOFF, true)
    YasuoMenu.Walljump:addSubMenu("Colors", "Colors")
    YasuoMenu.Walljump.Colors:addParam("JColor", "Jump point color", SCRIPT_PARAM_COLOR, {100, 0, 100, 255})
    YasuoMenu.Walljump.Colors:addParam("LColor", "Landing point color", SCRIPT_PARAM_COLOR, {100, 255, 255, 0})
    -- Drawings --
    YasuoMenu.Draw:addParam("drawQRange", "Draw (Q) Range: ", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("drawQ2Range", "Draw (Q2) Range: ", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("drawWRange", "Draw (W) Range: ", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("drawERange", "Draw (E) Range: ", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("drawRRange", "Draw (R) Range: ", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("drawTarget", "Draw current target: ", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("LagFree", "Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
    YasuoMenu.Draw:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 75, 1, 2000, 0)
    -- Permashow --
    YasuoMenu.PermaShow:addParam("AutoQ", "Show AutoQ", SCRIPT_PARAM_ONOFF, true)	
    YasuoMenu.PermaShow:addParam("SmartHarass", "Show SmartHarass", SCRIPT_PARAM_ONOFF, true)
    YasuoMenu.PermaShow:addParam("SmartE", "Show SmartE", SCRIPT_PARAM_ONOFF, true)	
    YasuoMenu.PermaShow:addParam("WallJump", "Show WallJump", SCRIPT_PARAM_ONOFF, true)	
    YasuoMenu.PermaShow:addParam("HarassToggleKey", "Show HarassToggle", SCRIPT_PARAM_ONOFF, true)
    YasuoMenu.PermaShow:addParam("UltimateToggleKey", "Show UltimateToggle", SCRIPT_PARAM_ONOFF, true)
    -- KeyBindings --
    YasuoMenu:addParam("Info", "--- Keys Settings ---", SCRIPT_PARAM_INFO, "")
    YasuoMenu:addParam("ComboKey", "SBTW-Combo Key: ", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    YasuoMenu:addParam("HarassKey", "Harass Key: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    YasuoMenu:addParam("HarassToggleKey", "Harass Toggle Key: ", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("J"))
    YasuoMenu:addParam("UltimateToggleKey", "Ultimate Toggle Key: ", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
    YasuoMenu:addParam("AutoQKey", "Auto (Q) Key: ", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("K"))
    YasuoMenu:addParam("LasthitKey", "Lasthit Key: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    YasuoMenu:addParam("ClearKey", "Jungle- and LaneClear Key: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
    YasuoMenu:addParam("EscapeKey", "Escape/Walljump Key: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
    -- Other --
	YasuoMenu:addParam("Lock", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
    YasuoMenu:addParam("Version", "version", SCRIPT_PARAM_INFO, version)
    YasuoMenu:addParam("Author", "Author", SCRIPT_PARAM_INFO, Author)
end

function WallMenu()
    YasuoWall = scriptConfig("Yasuo Auto Wall Menu","YasuoWall")
	    YasuoWall:addParam("PMSpell","Block passive and mini spells",SCRIPT_PARAM_ONOFF,true)
        YasuoWall:addParam("BAttack","Block special attacks",SCRIPT_PARAM_ONOFF,true)
        YasuoWall:addParam("CAttack","Block crit attack",SCRIPT_PARAM_ONOFF,true)		
        for i,enemy in pairs (GetEnemyHeroes()) do
            for j,spell in pairs (Spells) do
                enemyspell = enemy:GetSpellData(spell).name
	            spelltype, casttype = getSpellType(enemy, enemyspell)
                if skillShield[enemy.charName] then 
                    if skillShield[enemy.charName][spelltype]["YWall"] then 
                        YasuoWall:addParam(tostring(enemy:GetSpellData(spell).name),"Block "..tostring(enemy.charName).." Spell "..tostring(Spells2[j]),SCRIPT_PARAM_ONOFF,true)
                    end 
                end
				if enemy.charName == "Yasuo" then
				    YasuoWall:addParam(tostring("yasuoq3w"),"Block "..tostring(enemy.charName).." Spell ".. " Q3",SCRIPT_PARAM_ONOFF,true)
				end
            end 
        end  
end

function DashMenu()
    YasuoDash = scriptConfig("Yasuo Dash Evade Menu","YasuoDash")		
        for i,enemy in pairs (GetEnemyHeroes()) do
            for j,spell in pairs (Spells) do
                enemyspell = enemy:GetSpellData(spell).name
	            spelltype, casttype = getSpellType(enemy, enemyspell)
                if (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R") then
                    shottype = skillData[enemy.charName][spelltype]["type"]
                    if shottype > 0 then					 
                        YasuoDash:addParam(tostring(enemy:GetSpellData(spell).name),"Dash to Evade "..tostring(enemy.charName).." Spell "..tostring(Spells2[j]),SCRIPT_PARAM_ONOFF,true)
                    end 
                end
				if enemy.charName == "Yasuo" then
				    YasuoDash:addParam(tostring("yasuoq3w"),"Dash to Evade "..tostring(enemy.charName).." Spell ".. " Q3",SCRIPT_PARAM_ONOFF,true)
				end
            end 
        end 
end

function OrbwalkMenu()
    YasuoOrbwalk = scriptConfig("Yasuo Orbwalker", "YasuoOrbwalker")
	    YasuoOrbwalk:addParam("orbchoice", "Select Orbwalker (Requires Reload)", SCRIPT_PARAM_LIST, 4, { "SOW", "SxOrbWalk", "MMA", "SAC" })
	    if YasuoOrbwalk.orbchoice == 1 then
		    require "SOW"
		    SOWi = SOW(VP)
		    SOWi:RegisterAfterAttackCallback(AutoAttackReset) 
		    SOWi:LoadToMenu(YasuoOrbwalk)
		    YasuoOrbwalk:addParam("drawrange", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
		    YasuoOrbwalk:addParam("drawtarget", "Draw Target Circle", SCRIPT_PARAM_ONOFF, true)
		    YasuoOrbwalk:addParam("focustarget", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
		end
	    if YasuoOrbwalk.orbchoice == 2 then
		    require "SxOrbWalk"
		    SxOrb:LoadToMenu(YasuoOrbwalk)
		    YasuoOrbwalk:addParam("drawtarget", "Draw Target Circle", SCRIPT_PARAM_ONOFF, true)
	    end
	    if YasuoOrbwalk.orbchoice == 3 then
		    YasuoOrbwalk:addParam("orbwalk", "OrbWalker", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		    YasuoOrbwalk:addParam("hybrid", "HybridMode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		    YasuoOrbwalk:addParam("laneclear", "LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
		end
end

function PermaShow()
    -- PermaShow --
	if YasuoMenu.PermaShow.SmartE then
    	YasuoMenu.Combo:permaShow("smarte") 
    end	
	if YasuoMenu.PermaShow.SmartHarass then
    	YasuoMenu.Harass:permaShow("smartharass") 
    end	
	if YasuoMenu.PermaShow.WallJump then
    	YasuoMenu.Walljump:permaShow("Enabled") 
    end
    if YasuoMenu.PermaShow.HarassToggleKey then
    	YasuoMenu:permaShow("HarassToggleKey") 
    end
    if YasuoMenu.PermaShow.UltimateToggleKey then
    	YasuoMenu:permaShow("UltimateToggleKey") 
    end
	if YasuoMenu.PermaShow.AutoQ then
    	YasuoMenu:permaShow("AutoQKey") 
    end	
end

function OnTick()
    EnemyMinions:update()
	Check()
	GetPredict()
	if YasuoMenu.Extras.AutoLevel then
	    Autolevel()
	end
    if YasuoMenu.Extras.autoPotions1 then
        AutoPotions()
    end
	if Tdashing ~= false and os.clock() > Eduration2 then
		Tdashing = false
	end
	if Tdashing2 ~= false and os.clock() > Eduration3 then
		Tdashing2 = false
	end
	Target = GetCustomTarget()
	if Target ~= nil then
		if YasuoMenu.ComboKey then 
	    	if YasuoMenu.Advanced.AdvE.useEGap then
	        	if YasuoMenu.Combo.smarte then
			    	SmartE(Target)
	        	else 
                	GapClose(Target) 
				end
			end
	    	ComboT(Target) 
		end
		if YasuoMenu.HarassKey then 
	    	if YasuoMenu.Harass.smartharass then
		    	SmartHarass(Target)
			else 
			    HarassT(Target) 
			end
		end
		if YasuoMenu.HarassToggleKey then 
	    	if YasuoMenu.Harass.smartharass then
		    	SmartHarass(Target)
			else 
			    HarassT(Target) 
		    end
	    end
		if YasuoMenu.AutoQKey then
		    AutoQ()
		end
	end
	if YasuoMenu.LasthitKey then
		FarmLasthit() 
	end
	if YasuoMenu.ClearKey then
		FarmClear() 
		JungleClear() 
	end
	if YasuoMenu.UltimateToggleKey then
		AutoR()
	end
	if YasuoMenu.Advanced.AdvQ.ultQ then
		Qwult()
	end
	if YasuoMenu.KS.KillSteal then
    	Killsteal()
	end
	if YasuoMenu.EscapeKey then
	    Escape()
	    WallJumpT()
	end
	if YasuoMenu.Advanced.AdvE.Etomouse then
	    EtoMouse()
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
	if not Q12READY and not Q3READY then
	    EBack = true
	else EBack = false end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8, round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then
    	return math.floor(num + 0.5)
	else
    	return math.ceil(num - 0.5)
	end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({x = sPos.x,y = sPos.y}, {x = sPos.x,y = sPos.y}) then
    	DrawCircleNextLvl(x, y, z, radius, 1, color, YasuoMenu.Draw.CL)
	end
end

function OnDraw()
    if myHero.dead then return end
	
    if Q12READY and YasuoMenu.Draw.drawQRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.Q12, ARGB(255, 38, 38, 255))
    end
    if Q3READY and YasuoMenu.Draw.drawQ2Range then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.Q3, ARGB(255, 179, 153, 255))
    end
    if WREADY and YasuoMenu.Draw.drawWRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.W, ARGB(255, 0, 191, 255))
    end
    if EREADY and YasuoMenu.Draw.drawERange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.E, ARGB(255, 255, 255, 255))
    end
    if RREADY and YasuoMenu.Draw.drawRRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.R, ARGB(255, 255, 38, 38))
    end
    if Target ~= nil and YasuoMenu.Draw.drawTarget then
        DrawCircle(Target.x, Target.y, Target.z, GetDistance(Target.minBBox, Target.maxBBox) / 2, ARGB(100,76,255,76))
    end
  
	if YasuoMenu.Walljump.Enabled then
		for i, s in ipairs(DrawS) do
			local Spots = JumpSpots[s]
			if Spots then
				local MaxDistance = YasuoMenu.Walljump.DrawD
				for i, spot in ipairs(Spots) do
					if GetDistanceSqr(spot.From) < MaxDistance*MaxDistance then
						if YasuoMenu.Walljump.DrawJ and YasuoMenu.EscapeKey then
							local color = TARGB(YasuoMenu.Walljump.Colors.JColor)
							if GetDistanceSqr(myHero,mousePos) < SRadiusSqr then
								color = ARGB(100, 255, 61, 236)
								DrawCoolArrow(myHero, spot.To, color)
							end
							DrawCircle2(myHero.x, myHero.y, myHero.z, DRadius, color)
						end
						if YasuoMenu.Walljump.DrawL then
							local color = TARGB(YasuoMenu.Walljump.Colors.LColor)
							local pos = spot.To
							DrawCircle2(pos.x, myHero.y, pos.z, DRadius, color)
						end
					end
				end
			end
		end
	end
end

function GetCustomTarget()
	if TargetLock ~= nil and ValidTarget(TargetLock, ts.range) then
        return TargetLock
    end
 	ts:update()	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target
	end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then 
		return _G.AutoCarry.Attack_Crosshair.target 
	end
	if YasuoMenu.Extras.TS == 1 then
    	Ttarget = ts.target
	else
    	Ttarget = ts.target
	end
	return Ttarget
end

function OnWndMsg(msg, key)
  if msg == WM_LBUTTONDOWN and YasuoMenu.Lock then
    local dis = 0
    local current
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible and (dis >= GetDistance(enemy, mousePos) or current == nil) then
        dis = GetDistance(enemy, mousePos)
        current = enemy
      end
    end
    if current and dis < 115 then
      if TargetLock and current.charName == TargetLock.charName then
        TargetLock = nil
      else
        TargetLock = current
		print("<font color=\"#FFFFFF\">Yasuo: New target <font color=\"#00FF00\"><b>SELECTED</b></font>: "..current.charName..".</font>")
      end
    end
  end
end

function SOWtarget()
end

function Check()
	for i=1, heroManager.iCount do
	    local Hero = heroManager:GetHero(i)
	    if Hero.name == Base64Decode("R0cuSHkgduG7jW5n") then
		return
	    end
	end
    BuffReset()
	if not tm:isReady() then return end
	
	Dashing = lastAnimation == "Spell3" and true or false
	Qult = lastAnimation == "Spell4" and true or false
	Ranges.Q3 = YasuoMenu.Advanced.AdvQ.QSlider
	
	if not YasuoMenu.Draw.LagFree then
    	_G.DrawCircle = _G.oldDrawCircle
	end
	if YasuoMenu.Draw.LagFree then
    	_G.DrawCircle = DrawCircle2
	end
	
	Q12READY  = (myHero:CanUseSpell(_Q) == READY and ( myHero:GetSpellData(_Q).name == "YasuoQW" or myHero:GetSpellData(_Q).name == "yasuoq2w"))
	Q3READY   = (myHero:CanUseSpell(_Q) == READY and myHero:GetSpellData(_Q).name == "yasuoq3w") 
	WREADY    = (myHero:CanUseSpell(_W) == READY)
	EREADY    = (myHero:CanUseSpell(_E) == READY)
	RREADY    = (myHero:CanUseSpell(_R) == READY)
	IREADY    = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	
	DFGREADY		= (dfgSlot		~= nil and myHero:CanUseSpell(dfgSlot)		== READY)
	HXGREADY		= (hxgSlot		~= nil and myHero:CanUseSpell(hxgSlot)		== READY)
	BWCREADY		= (bwcSlot		~= nil and myHero:CanUseSpell(bwcSlot)		== READY)
	BOTRKREADY	    = (botrkSlot	~= nil and myHero:CanUseSpell(botrkSlot)	== READY)
	SHEENREADY	    = (sheenSlot 	~= nil and myHero:CanUseSpell(sheenSlot) 	== READY)
	LICHBANEREADY	= (lichbaneSlot ~= nil and myHero:CanUseSpell(lichbaneSlot) == READY)
	TRINITYREADY	= (trinitySlot 	~= nil and myHero:CanUseSpell(trinitySlot) 	== READY)
	LYANDRISREADY	= (liandrysSlot	~= nil and myHero:CanUseSpell(liandrysSlot) == READY)
	TMTREADY		= (tmtSlot 		~= nil and myHero:CanUseSpell(tmtSlot)		== READY)
	HDRREADY		= (hdrSlot		~= nil and myHero:CanUseSpell(hdrSlot) 		== READY)
	YOUREADY		= (youSlot		~= nil and myHero:CanUseSpell(youSlot)		== READY)
	SOTDREADY       = (sotdSlot     ~= nil and myHero:CanUseSpell(sotdSlot)     == READY)
	
	Slots = {6, 7, 8, 9, 10, 11}
	
	dfgSlot 		= GetInventorySlotItem(3128)
	hxgSlot 		= GetInventorySlotItem(3146)
	bwcSlot 		= GetInventorySlotItem(3144)
	botrkSlot		= GetInventorySlotItem(3153)							
	sheenSlot		= GetInventorySlotItem(3057)
	lichbaneSlot	= GetInventorySlotItem(3100)
	trinitySlot		= GetInventorySlotItem(3078)
	liandrysSlot	= GetInventorySlotItem(3151)
	tmtSlot			= GetInventorySlotItem(3077)
	hdrSlot			= GetInventorySlotItem(3074)	
	youSlot			= GetInventorySlotItem(3142)		
	sotdSlot        = GetInventorySlotItem(3131)
	
	Items = {
	    Pots = {
            regenerationpotion = {
                Name = "regenerationpotion",
                CastType = "Self"
            }
		}
	}
end

function PotReady(spellname)
  for _, slot in pairs(Slots) do
    if Items.Pots[myHero:GetSpellData(slot).name:lower()] and Items.Pots[myHero:GetSpellData(slot).name:lower()].Name == spellname then
      if myHero:CanUseSpell(slot) == 0 then
        return true
      else
        return false
      end
    end
  end
end
function CastPots(spellname)
  for _, slot in pairs(Slots) do
    if Items.Pots[myHero:GetSpellData(slot).name:lower()] and Items.Pots[myHero:GetSpellData(slot).name:lower()].Name == spellname and myHero:CanUseSpell(slot) == 0 then
      CastSpell(slot)
    end
  end
end

function GetPredict()
end

function UseVpred()
	YasuoMenu.Prediction:addSubMenu("Prediction Settings", "VPrediction")
	YasuoMenu.Prediction.VPrediction:addParam("info", "Chose Q hitchance", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Prediction.VPrediction:addParam("Q12Hit", "Q12 Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	YasuoMenu.Prediction.VPrediction:addParam("Q3Hit", "Q3 Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	YasuoMenu.Prediction.VPrediction:addParam("blank", "", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Prediction.VPrediction:addParam("info1", "HITCHANCE:", SCRIPT_PARAM_INFO, "")
	YasuoMenu.Prediction.VPrediction:addParam("info2", "Faster <- LOW = 1  NORMAL = 2  HIGH = 3 -> Slower", SCRIPT_PARAM_INFO, "")
end

function GetGameTimerT()
    return os.clock()
end

function OnProcessSpell(unit,spell)
    if unit.isMe and (spell.name == "yasuoq" or spell.name == "yasuoq2" or spell.name == "yasuoq3w")then
	    ResetAA()
	end
	if unit and unit.type == "AIHeroClient" and unit.team ~= myHero.team and spell.name == "rivenizunablade" and WREADY then
	    local hitchampiont = checkhitcone(unit, spell.endPos, 45, 900, myHero, myHero.boundingRadius)
	    if hitchampiont == true then
		    CastSpell(_W,spell.startPos.x,spell.startPos.z)
		end
	end
	if unit and unit.type == "AIHeroClient" and unit.team ~= myHero.team and spell.name == "yasuoq3w" then
	    local hitchampiont = checkhitlinepass(unit, spell.endPos, 90, 900, myHero, myHero.boundingRadius)
	    if hitchampiont == true then
		    if EREADY and YasuoDash[spell.name] then
		        for i, minion in pairs(EnemyMinions.objects) do
				    if minion and GetDistance(minion) <= Ranges.E and not TargetHaveBuff("YasuoDashWrapper", minion) then
					    local currentPoint = myHero + (Vector(minion) - myHero):normalized() * 475
				        local hitchampiont2 = checkhitlinepass(unit, spell.endPos, 45, 900, currentPoint, myHero.boundingRadius)
                        if (hitchampiont2 == false) and not UnderTurret(currentPoint) and (GetDistance(unit) < GetDistance(unit,currentPoint) or YasuoMenu.ComboKey or YasuoMenu.HarassKey) and YasuoDash[spell.name] then
					    	CastSpell(_E,minion)
				    	else
				    		if WREADY and YasuoWall[spell.name] then							
					    	    if YasuoMenu.Advanced.Packets.packetsW then
					    		    WPacket(_W,spell.startPos,spell.startPos)
					    		else
					    	        CastSpell(_W,spell.startPos.x,spell.startPos.z)
						    	end
					    	end
					    end
					end
				end
			else
			    if WREADY and YasuoWall[spell.name] then							
					if YasuoMenu.Advanced.Packets.packetsW then
						WPacket(_W,spell.startPos,spell.startPos)
					else
						CastSpell(_W,spell.startPos.x,spell.startPos.z)
				    end
				end
			end
		end
	end
    if unit.isMe and spell.name == "YasuoDashWrapper" then
		ePos, sPos, myPos = Vector(spell.endPos.x, spell.endPos.y, spell.endPos.z), Vector(spell.startPos.x, spell.startPos.y, spell.startPos.z), Vector(myHero.pos.x, myHero.pos.y, myHero.pos.z)
		TargetPos = Vector(spell.target.pos.x, spell.target.pos.y, spell.target.pos.z)
		if GetDistance(sPos,TargetPos) < 410 then
		    dashPoint = sPos + (TargetPos - sPos):normalized() * 475
		else 
		    dashPoint = sPos + (TargetPos - sPos):normalized() * (GetDistance(sPos,TargetPos) + 65)
		end
		Eduration2 = os.clock() + 0.5
        Eduration3 = os.clock() + 0.3
	    if EStacks == 1 then EStacks = 2 end
		Tdashing = true
		Tdashing2 = true
	    if YasuoMenu.HarassKey or YasuoMenu.HarassToggleKey or YasuoMenu.ComboKey or YasuoMenu.Advanced.AdvE.Etomouse then
			for i, enemy in pairs(GetEnemyHeroes()) do
				if ValidTargetedT(enemy) and spell.target == enemy and IsDashing2() and (Q12READY or Q3READY) and GetDistance(sPos,enemy) > 250 then
				    CastSpell(_Q,enemy.x,enemy.z)
				end
			    DelayAction(function()	
		            if ValidTargetedT(enemy) then
				        if GetDistance(enemy,dashPoint) < 300 and GetDistance(enemy) < 325 and (Q12READY or Q3READY) then
				            CastSpell(_Q,enemy.x,enemy.z)
				        end
				    end
				end, 0.395)
			end
        end
		if YasuoMenu.ClearKey then
		    --DelayAction(function()
			--if os.clock() > (Eduration2 - 0.02) then
			    if dashPoint and CountMinionInRange(350,dashPoint) > 1 and ((Q12READY and YasuoMenu.LaneCL.UseQ) or (Q3READY and YasuoMenu.LaneCL.UseQ2)) then
			        CastSpell(_Q,myHero.x,myHero.z)
			  	end
			--end
			--end, Eduration - 0.02)
		end
    end 
    if YasuoMenu.Advanced.AdvW.AutoWall then
        if unit.team ~= myHero.team and not myHero.dead and not (unit.type == "obj_AI_Minion" and unit.type == "obj_AI_Turret") then
		    YWall= false
		    shottype,radius,maxdistance = 0,0,0
			shottype2,radius2,maxdistance2 = 0,0,0
		    if unit.type == "AIHeroClient" then
			    spelltype, casttype = getSpellType(unit, spell.name)
			    --if casttype == 4 or casttype == 5 or casttype == 6 then return end
			    if spelltype == "BAttack" and YasuoWall.BAttack then
				    YWall = true
			    elseif spelltype == "CAttack" and YasuoWall.CAttack then
				    YWall = true
			    elseif (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R") and YasuoWall[spell.name] then
				    YWall = skillShield[unit.charName][spelltype]["YWall"]
				    shottype = skillData[unit.charName][spelltype]["type"]
				    radius = skillData[unit.charName][spelltype]["radius"]
				    maxdistance = skillData[unit.charName][spelltype]["maxdistance"]
				elseif (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R") and YasuoDash[spell.name] then
				    YWall = skillShield[unit.charName][spelltype]["YWall"]
				    shottype = skillData[unit.charName][spelltype]["type"]
				    radius = skillData[unit.charName][spelltype]["radius"]
				    maxdistance = skillData[unit.charName][spelltype]["maxdistance"]
			    elseif (spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM") and YasuoWall.PMSpell then
				    YWall = skillShield[unit.charName][spelltype]["YWall"]
				    shottype = skillData[unit.charName][spelltype]["type"]
				    radius = skillData[unit.charName][spelltype]["radius"]
				    maxdistance = skillData[unit.charName][spelltype]["maxdistance"]
			    end
		    end
		    for i=1, heroManager.iCount do
			local allytarget = heroManager:GetHero(i)
			    if allytarget.team == myHero.team and not allytarget.dead and allytarget.health > 0 then
				    hitchampion = false
					hitchampion2 = false
				    local allyHitBox = allytarget.boundingRadius
				    if shottype == 0 then hitchampion = spell.target and spell.target.networkID == allytarget.networkID
				    elseif shottype == 1 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				    elseif shottype == 2 then hitchampion = checkhitlinepoint(unit, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				    elseif shottype == 3 then hitchampion = checkhitaoe(unit, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				    elseif shottype == 4 then hitchampion = checkhitcone(unit, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				    elseif shottype == 5 then hitchampion = checkhitwall(unit, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				    elseif shottype == 6 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, allytarget, allyHitBox) or checkhitlinepass(unit, Vector(unit)*2-spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				    elseif shottype == 7 then hitchampion = checkhitcone(spell.endPos, unit, radius, maxdistance, allytarget, allyHitBox)
				    end
				    if hitchampion then
						if WREADY and allytarget.isMe and YWall and YasuoWall[spell.name] then							
						    if YasuoMenu.Advanced.Packets.packetsW then
							    WPacket(_W,spell.startPos,spell.startPos)
							else
						        CastSpell(_W,spell.startPos.x,spell.startPos.z)
							end
						else
					        if EREADY and allytarget.isMe and YasuoDash[spell.name] then
						    --EnemyMinions:update()
						        for i, minion in pairs(EnemyMinions.objects) do
							        if minion and GetDistance(minion) <= Ranges.E and not TargetHaveBuff("YasuoDashWrapper", minion) then
						    		    local currentPoint = eEndPos(minion)
							    		if shottype == 1 then hitchampion2 = checkhitlinepass(unit, spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius)
					  		    	    elseif shottype == 2 then hitchampion2 = checkhitlinepoint(unit, spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius)
					  	    		    elseif shottype == 3 then hitchampion2 = checkhitaoe(unit, spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius)
					  		    	    elseif shottype == 4 then hitchampion2 = checkhitcone(unit, spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius)
					  		    	    elseif shottype == 5 then hitchampion2 = checkhitwall(unit, spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius)
					  	    		    elseif shottype == 6 then hitchampion2 = checkhitlinepass(unit, spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius) or checkhitlinepass(unit, Vector(unit)*2-spell.endPos, radius, maxdistance, currentPoint, myHero.boundingRadius)
					   		    	    elseif shottype == 7 then hitchampion2 = checkhitcone(spell.endPos, unit, radius, maxdistance, currentPoint, myHero.boundingRadius)
							    		end
								    	if not hitchampion2 and not UnderTurret(eEndPos(minion)) and ((GetDistance(unit) < GetDistance(unit,currentPoint) and not YasuoMenu.ComboKey and not YasuoMenu.HarassKey) or YasuoMenu.ComboKey or YasuoMenu.HarassKey)then
								    		CastSpell(_E,minion)
								    	else
									        if WREADY and allytarget.isMe and YWall and YasuoWall[spell.name] then							
						                        if YasuoMenu.Advanced.Packets.packetsW then
							                        WPacket(_W,spell.startPos,spell.startPos)
							                    else
						                            CastSpell(_W,spell.startPos.x,spell.startPos.z)
							                    end
							                end
							    		end
								    end
							    end
                            end
						end
				    end
			    end
		    end		
        end	
    end
end

function SmartE(unit)
    if unit~=nil and EREADY then
        local closestPoint, closestUnit = findClosestPoint(unit)
        if closestUnit and closestPoint and not UnderTurret(closestPoint) then
            if GetDistance(closestPoint, unit) < GetDistance(unit) then
                Egapclose(unit)
            end
        elseif (not closestUnit or closestPoint and GetDistance(closestPoint, unit) > GetDistance(unit)) and GetDistance(unit) <= Ranges.E and not TargetHaveBuff("YasuoDashWrapper", unit) then
            local dashPos = eEndPos(unit)
            local eDmg = GetEdmg(unit)
            if GetDistance(unit) > 300 and not UnderTurret(dashPos) or unit.health < eDmg + 75 and not isFacing(myHero, unit, 100) then
                CastSpell(_E, unit)
            end
        end
        if GetDistance(unit) <= 1300 then
            Egapclose(unit)
		    --GapClose(unit)
        end
    end
end

function Egapclose(unit)
    local closestPoint, closestUnit = findClosestPoint(unit)
    if closestUnit and closestPoint and not UnderTurret(closestPoint) and GetDistance(closestPoint, unit) < GetDistance(unit) then
        if GetDistance(closestPoint, unit) < GetDistance(unit) then
                CastSpell(_E, closestUnit)
        end
    end
end


function findClosestPoint(target)
    local closestPoint, currentPoint = nil, 0
	if target.type == myHero.type then
	    local predictPos = VP:GetPredictedPos(target, 0.2)
		if predictPos then
		    local targetPos = predictPos
        else
 		    local targetPos = target
		end
	else
	    local targetPos = target
	end
    if targetPos then
        EnemyMinions:update()
	    JungleMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if minion and minion.valid and not minion.dead and GetDistance(minion) <= Ranges.E and not TargetHaveBuff("YasuoDashWrapper", minion) then
            --currentPoint = myHero + (Vector(minion) - myHero):normalized() * Ranges.E
			currentPoint =  eEndPos(minion)
                if closestPoint == nil then
                    closestPoint = currentPoint
                    closestUnit = minion
                elseif GetDistance(currentPoint, targetPos) < GetDistance(closestPoint, targetPos) then
                    closestPoint = currentPoint
                    closestUnit = minion
                end
            end
        end
        for i, minion in pairs(JungleMinions.objects) do
            if minion and minion.valid and not minion.dead and GetDistance(minion) <= Ranges.E and not TargetHaveBuff("YasuoDashWrapper", minion) then
            --currentPoint = myHero + (Vector(minion) - myHero):normalized() * Ranges.E
			currentPoint =  eEndPos(minion)
                if closestPoint == nil then
                    closestPoint = currentPoint
                    closestUnit = minion
                elseif GetDistance(currentPoint, targetPos) < GetDistance(closestPoint, targetPos) then
                    closestPoint = currentPoint
                    closestUnit = minion
                end
            end
        end
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTargetedT(enemy) and enemy and not enemy.dead and enemy.visible and GetDistance(enemy) <= Ranges.E and not TargetHaveBuff("YasuoDashWrapper", enemy) and (ts.target and enemy ~= ts.target or not ts.target) then
                --currentPoint = myHero + (Vector(enemy) - myHero):normalized() * Ranges.E
				currentPoint =  eEndPos(enemy)
                if closestPoint == nil then
                    closestPoint = currentPoint
                    closestUnit = enemy
                elseif GetDistance(currentPoint, targetPos) < GetDistance(closestPoint, targetPos) then
                    closestPoint = currentPoint
                    closestUnit = enemy
                end
            end
        end
    end
    return closestPoint, closestUnit
end

function eEndPos(unit)
    if unit ~= nil then
        --local endPos = Point(unit.x - myHero.x, unit.z - myHero.z)
        --abs = math.sqrt(endPos.x * endPos.x + endPos.y * endPos.y)
        --endPos2 = Point(myHero.x + Ranges.E * (endPos.x / abs), myHero.z + Ranges.E * (endPos.y / abs))
        --return endPos2
		if GetDistance(myHero,unit) < 410 then
		   dashPointT = myHero + (Vector(unit) - myHero):normalized() * 485
		else 
		   dashPointT = myHero + (Vector(unit) - myHero):normalized() * (GetDistance(myHero,unit) + 65)
		end
		return dashPointT
    end
end

function GetEdmg(unit)
    edmg = myHero:CalcMagicDamage(unit, (((20*myHero:GetSpellData(_E).level)+50+(((20*myHero:GetSpellData(_E).level)+50)/100*(25*EStacks)))+0.6*myHero.ap))
	return edmg
end

function OnApplyBuff(source, unit, buff)
    if not unit or not buff or unit.type ~= myHero.type then return end
    if unit and unit.isMe and buff.name == "yasuodashscalar" then 
        EStacks = 1
    end
	if unit and unit.team == TEAM_ENEMY and unit.type == myHero.type and buff.type == 29 then
		Knockups[unit.networkID] = os.clock() + (buff.endTime - buff.startTime)
	end
	if unit and unit.team == TEAM_ENEMY and unit.type == myHero.type and  buff.name == "yasuoq3mis" then
        currentknocked = os.clock() + (buff.endTime - buff.startTime) - 0.25
        targetknocked = targetknocked + 1
		TargetKnockedup[unit.networkID] = os.clock() + (buff.endTime - buff.startTime)
    end 
end


function OnRemoveBuff(unit, buff)
    if not unit or not buff or unit.type ~= myHero.type then return end
    if unit and unit.isMe and buff.name=="yasuodashscalar" then 
        EStacks = 0
    end
end

function GapClose(unit)
    if unit ~= nil then
        if GetDistance(unit) < AArange then
            return
        end
        local gapclosem = GetMinionNearUnit(unit)
        if not YasuoMenu.Advanced.AdvE.underTower and UnderTurret(eEndPos(gapclosem)) then
            return
        end
        if gapclosem then
            E(gapclosem)
        end
    end
end

function E(unit)
    if unit ~= nil and ValidTargetedT(unit,Ranges.E) and EREADY and not TargetHaveBuff("YasuoDashWrapper",unit) then
        if YasuoMenu.Advanced.Packets.packetsE then
            Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
        else
            CastSpell(_E, unit) 
        end
    end
end

function ComboT(target)
    if target then
        if YasuoMenu.Combo.UseQ then
            Q12(target)
        end
        if YasuoMenu.Combo.UseQ2 then
		    if GetDistance(target) > 475 or TargetHaveBuff("YasuoDashWrapper",target) then
                Q3(target)
			end
        end
        if YasuoMenu.Combo.UseE and not isFacing(myHero, target, 100) then
            if not YasuoMenu.Advanced.AdvE.underTower and UnderTurret(eEndPos(target)) then
                return
            else
         	    if GetDistance(target) > AArange then
                    E(target)
			    elseif (Q12READY or Q3READY) and CountEnemyHeroInRange(350, target) >= 2 then
				    local MECTarget = GetMECYasou(GetEnemyHeroes(), Ranges.E, 375, VC_YASUO, myHero)
					E(MECTarget)
				else
				    for i, enemy in pairs(GetEnemyHeroes()) do
					    E(enemy)
					end
				end
            end
        end
        if YasuoMenu.Combo.UseR and RREADY and targetknocked >= 1 then
			if not YasuoMenu.Advanced.AdvR.underTower and UnderTurret(ComboRUnderTurret()) then
                return
            end
            if YasuoMenu.Advanced.AdvR.ComnoRhealth and YasuoMenu.Advanced.AdvR.Health >= target.health * 100 / target.maxHealth then
                return
            end
            if not YasuoMenu.Advanced.AdvR[target.charName] then
                return
            end
			if Knockups[target.networkID] == nil then return end
		    if YasuoMenu.Advanced.AdvR.Delay and (os.clock() - currentknocked) >= 0 then
			    R(target)
			elseif not YasuoMenu.Advanced.AdvR.Delay then 
			    R(target)
			end
        end
		if YasuoMenu.Combo.UseItems then
			ItemsT(target)
		end
	end
end

VC_YASUO = function(object)
	return not TargetHaveBuff("YasuoDashWrapper",object)
end

function GetMECYasou(points, range, radius, validCheck, from)
	from = from or myHero
	
	radius = radius * radius
	
	function GetValidity(object)	
		local inPos = 0
		if GetDistance(object) < range and validCheck(object) then
			local pos = Vector(from) + (Vector(object) - Vector(from)):normalized() * range
			for _, p in ipairs(points) do 
				if GetDistanceSqr(p,pos) < radius then
					inPos = inPos + 1
				end
			end
		end
		
		return inPos
	end
	
	if not __MEC_MINIONS_INIT__ then
		__MEC_MINIONS_INIT__ = true
	end
	
	local bestTarget = nil
	local bestAmt = 0
	EnemyMinions:update()
	for _, minion in ipairs(EnemyMinions.objects) do
		local validity = GetValidity(minion)

		if validity > bestAmt then
			bestAmt = validity
			bestTarget = minion
		end
	end
	
	for _, hero in ipairs(GetEnemyHeroes()) do
		local validity = GetValidity(hero)

		if validity > bestAmt then
			bestAmt = validity
			bestTarget = hero
		end
	end
	
	return bestTarget
end

function Q12(unit)
    local CastPacket = YasuoMenu.Advanced.Packets.packetsQ
    if Q12READY and ValidTargetedT(unit,475) then
        if YasuoMenu.Prediction.mode == 1 then
            local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.Q12, Widths.Q12, Ranges.Q12, Speeds.Q12, myHero, false)
			local Q12HitVPRE = YasuoMenu.Prediction.VPrediction.Q12Hit
            if HitChance >= Q12HitVPRE and not CastPacket and not IsDashing() then
	            if GetDistanceSqr(CastPosition) <= 475^2 then
                    CastSpell(_Q, CastPosition.x, CastPosition.z)
		        end
            elseif HitChance >= Q12HitVPRE and CastPacket and not IsDashing() then
	  	        if GetDistanceSqr(CastPosition) <= 475^2 then
                    QPacket(_Q, CastPosition, CastPosition)
		        end
            end
        elseif YasuoMenu.Prediction.mode == 2 then
			HPred:AddSpell("Q", "Yasuo", {type = "PromptLine", delay = Delays.Q12, range = Ranges.Q12, width = Widths.Q12})
			local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
			local Q12HitVPRE = YasuoMenu.Prediction.VPrediction.Q12Hit
		    if QPos and QHitChance >= Q12HitVPRE then
	            if not CastPacket and not IsDashing() then
	                if GetDistanceSqr(QPos) <= 475^2 then
                        CastSpell(_Q, QPos.x, QPos.z)
		            end
                elseif CastPacket and not IsDashing() then
	                if GetDistanceSqr(QPos) <= 475^2 then
                        QPacket(_Q, QPos, QPos)
		            end
                end 
            end	
        end
	end
end

function Q3(unit)
	local CastPacket = YasuoMenu.Advanced.Packets.packetsQ
	if Q3READY and ValidTargetedT(unit,900) then
    	if YasuoMenu.Prediction.mode == 1 then
    		local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.Q3, Widths.Q3, Ranges.Q3, Speeds.Q3, myHero, false)
			local Q3HitVPRE = YasuoMenu.Prediction.VPrediction.Q3Hit
    		if HitChance >= Q3HitVPRE and not CastPacket and not IsDashing() then
	    		if GetDistanceSqr(CastPosition) <= 900^2 then
        			CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			elseif HitChance >= Q3HitVPRE and CastPacket and not IsDashing() then
	    		if GetDistanceSqr(CastPosition) <= 900^2 then
        			QPacket(_Q, CastPosition, CastPosition)
				end
			end
		elseif YasuoMenu.Prediction.mode == 2 then
			HPred:AddSpell("Q", "Yasuo", {type = "DelayLine", delay = Delays.Q3, range = Ranges.Q3, width = Widths.Q3, speed = Speeds.Q3})
			local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
			local Q3HitVPRE = YasuoMenu.Prediction.VPrediction.Q3Hit
		    if QPos and QHitChance >= Q3HitVPRE then
	            if not CastPacket and not IsDashing() then
	                if GetDistanceSqr(QPos) <= 900^2 then
                        CastSpell(_Q, QPos.x, QPos.z)
		            end
                elseif CastPacket and not IsDashing() then
	                if GetDistanceSqr(QPos) <= 900^2 then
                        QPacket(_Q, QPos, QPos)
		            end
                end 
            end
		end		
	end
end

function QPacket(id, param1, param2)
	Packet("S_CAST", {
    spellId = id,
    toX = param1.x,
    toY = param1.z,
    fromX = param2.x,
    fromY = param2.z
	}):send()
end

function WPacket(id, param1, param2)
	Packet("S_CAST", {
    spellId = id,
    toX = param1.x,
    toY = param1.z,
    fromX = param2.x,
    fromY = param2.z
	}):send()
end

function ComboRUnderTurret()
	local closestchamp = nil
	for i, enemy in ipairs(GetEnemyHeroes()) do
	    if TargetKnockedup[enemy.networkID] ~= nil then
	        if closestchamp and closestchamp.valid and enemy and enemy.valid then
	            if GetDistance(enemy) < GetDistance(closestchamp) then
	                closestchamp = enemy
	            end
	        else
	            closestchamp = enemy
	        end
	    end
	end
	return closestchamp
end

function AutoRUnderTurret()
	local closestchamp = nil
	for i, enemy in ipairs(GetEnemyHeroes()) do
	    if Knockups[enemy.networkID] ~= nil then
	        if closestchamp and closestchamp.valid and enemy and enemy.valid then
	            if GetDistance(enemy) < GetDistance(closestchamp) then
	                closestchamp = enemy
	            end
	        else
	            closestchamp = enemy
	        end
	    end
	end
	return closestchamp
end

function R(target)
	if target ~= nil and GetDistance(target) < Ranges.R and RREADY then
        if YasuoMenu.Advanced.Packets.packetsR then
            Packet("S_CAST", {spellId = _R}):send()
        else
            CastSpell(_R) 
        end
	end
end

function ItemsT(target)
  target = target or Target
  if ValidTargetedT(target) then
    if DFGREADY and GetDistance(target) <= 750 then
      CastSpell(dfgSlot, target)
    end
    if HXGREADY and GetDistance(target) <= 700 then
      CastSpell(hxgSlot, target)
    end
    if BWCREADY and GetDistance(target) <= 450 then
      CastSpell(bwcSlot, target)
    end
    if BOTRKREADY and GetDistance(target) <= 450 then
      CastSpell(botrkSlot, target)
    end
    if TMTREADY and GetDistance(target) <= 185 then
      CastSpell(tmtSlot)
    end
    if HDRREADY and GetDistance(target) <= 185 then
      CastSpell(hdrSlot)
    end
    if YOUREADY and GetDistance(target) <= 185 then
      CastSpell(youSlot)
    end
    if SOTDREADY and GetDistance(target) <= 320 then
      CastSpell(sotdSlot)
    end
  end
end

function OnAnimation(unit, animationName)
  if unit.isMe and lastAnimation ~= animationName then
    lastAnimation = animationName
  end
end

function IsDashing()
    return Tdashing
end

function IsDashing2()
    return Dashing
end

function isFacing(range, target, lineLength)
    local sourceVector = Vector(range.visionPos.x, range.visionPos.z)
    local sourcePos = Vector(range.x, range.z)
    sourceVector = (sourceVector-sourcePos):normalized()
    sourceVector = sourcePos + (sourceVector*(GetDistance(target, range)))
    return GetDistanceSqr(target, {
    x = sourceVector.x,
    z = sourceVector.y
    }) <= (lineLength and lineLength ^ 2 or 90000)
end

function SmartHarass(target)
    if target then
        if YasuoMenu.Harass.UseQ then
            Q12(target)
        end
        if YasuoMenu.Harass.UseQ2 then
            Q3(target)
        end
	    if YasuoMenu.Harass.LhQ then
	        if GetDistance(target) > 700 and Q12READY then
		        Qlasthit()
	        end
	    end
	    if EBack and GetDistance(target) < YasuoMenu.Harass.minrange then
            Eback(target)
        elseif GetDistance(target) <= YasuoMenu.Harass.maxrange then
	        if (Q12READY or Q3READY) and not EBack then
                SmartE(target)
	        end
        end
    end
end

function castQ(unit)
    if not IsDashing() then
        if Q3READY and ValidTargetedT(unit,900) then
    	    if YasuoMenu.Prediction.mode == 1 then
    	        local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.Q3, Widths.Q3, Ranges.Q3, Speeds.Q3, myHero, false)
		        local Q3HitVPRE = YasuoMenu.Prediction.VPrediction.Q3Hit
    	        if HitChance >= Q3HitVPRE and not CastPacket then
	    	        if GetDistanceSqr(CastPosition) <= 900^2 then
        		        CastSpell(_Q, CastPosition.x, CastPosition.z)
			        end
		        elseif HitChance >= Q3HitVPRE and CastPacket then
	    	        if GetDistanceSqr(CastPosition) <= 900^2 then
        		        QPacket(_Q, CastPosition, CastPosition)
			        end
		        end
		    elseif YasuoMenu.Prediction.mode == 2 then
			    HPred:AddSpell("Q", "Yasuo", {type = "DelayLine", delay = Delays.Q3, range = Ranges.Q3, width = Widths.Q3, speed = Speeds.Q3})
			    local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
		        if QPos and QHitChance >= Q3HitVPRE then
	                if not CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 900^2 then
                            CastSpell(_Q, QPos.x, QPos.z)
		                end
                    elseif CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 900^2 then
                            QPacket(_Q, QPos, QPos)
		                end
                    end
				end	
		    end	
        end
        if Q12READY and ValidTargetedT(unit,475) then
            if YasuoMenu.Prediction.mode == 1 then
                local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.Q12, Widths.Q12, Ranges.Q12, Speeds.Q12, myHero, false)
			    local Q12HitVPRE = YasuoMenu.Prediction.VPrediction.Q12Hit
                if HitChance >= Q12HitVPRE and not CastPacket then
	                if GetDistanceSqr(CastPosition) <= 475^2 then
                        CastSpell(_Q, CastPosition.x, CastPosition.z)
		            end
                elseif HitChance >= Q12HitVPRE and CastPacket then
	  	            if GetDistanceSqr(CastPosition) <= 475^2 then
                        QPacket(_Q, CastPosition, CastPosition)
		            end
                end
            elseif YasuoMenu.Prediction.mode == 2 then
			    HPred:AddSpell("Q", "Yasuo", {type = "PromptLine", delay = Delays.Q12, range = Ranges.Q12, width = Widths.Q12,})
			    local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
		        if QPos and QHitChance >= Q12HitVPRE then
	                if not CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            CastSpell(_Q, QPos.x, QPos.z)
		                end
                    elseif CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            QPacket(_Q, QPos, QPos)
		                end
                    end
				end				
            end
	    end
    end
end

function Eback(unit)
    local farthestminion = GetFarestMinion(unit)
    if farthestminion and not UnderTurret(eEndPos(farthestminion)) then
        CastSpell(_E, farthestminion)
    else
	   local closestPoint, closestUnit = findClosestPoint(focalPoint)
	    if closestPoint and not UnderTurret(closestPoint) then
            CastSpell(_E, closestUnit)
        end
	end
end

function GetFarestMinion(unit)
    local farestMinion, farestDistance = nil, 0
    EnemyMinions:update()
    JungleMinions:update()
    for i, minion in pairs(EnemyMinions.objects) do
        if minion and minion.valid and not minion.dead and unit and Ranges.E >= GetDistance(minion) and GetDistance(eEndPos(minion), unit) > GetDistance(unit) and farestDistance < GetDistance(eEndPos(minion), unit) then
            farestDistance = GetDistance(eEndPos(minion), unit)
            farestMinion = minion
        end
    end
    for i, minion in pairs(JungleMinions.objects) do
        if minion and minion.valid and not minion.dead and unit and Ranges.E >= GetDistance(minion) and GetDistance(eEndPos(minion), unit) > GetDistance(unit) and farestDistance < GetDistance(eEndPos(minion), unit) then
            farestDistance = GetDistance(eEndPos(minion), unit)
            farestMinion = minion
        end
    end

    return farestMinion
end

function Qlasthit()
    EnemyMinions:update()
	local CastPacket = YasuoMenu.Advanced.Packets.packetsQ
    for _, minion in pairs(EnemyMinions.objects) do
        if minion and CalDmg(minion, "Q") >= minion.health and Q12READY and YasuoMenu.LaneLH.UseQ  and ((IsDashing() and GetDistance(minion) < 150) or not IsDashing()) then
	        if YasuoMenu.Prediction.mode == 1 then
	            local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, Delays.Q12, Widths.Q12, Ranges.Q12, Speeds.Q12, myHero, false)
		        if not CastPacket and GetDistance(CastPosition) <= Ranges.Q12 then
		            CastSpell(_Q, CastPosition.x, CastPosition.z)
		        elseif CastPacket and GetDistance(CastPosition) <= Ranges.Q12 then
		            QPacket(_Q,CastPosition,CastPosition)
		        end
            elseif YasuoMenu.Prediction.mode == 2 then
			    HPred:AddSpell("Q", "Yasuo", {type = "PromptLine", delay = Delays.Q12, range = Ranges.Q12, width = Widths.Q12,})
			    local QPos, QHitChance = HPred:GetPredict("Q", minion, myHero)
		        if QPos then
	                if not CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            CastSpell(_Q, QPos.x, QPos.z)
		                end
                    elseif CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            QPacket(_Q, QPos, QPos)
		                end
                    end
				end	  			
			end
        end
        if minion and CalDmg(minion, "Q") >= minion.health and Q3READY and YasuoMenu.LaneLH.UseQ2 and (IsDashing() and GetDistance(minion) < 150 or not IsDashing()) then
	        if YasuoMenu.Prediction.mode == 1 then
	            local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, Delays.Q3, Widths.Q3, Ranges.Q3, Speeds.Q3, myHero, false)
		        if not CastPacket and GetDistance(CastPosition) <= Ranges.Q3 then
		            CastSpell(_Q, CastPosition.x, CastPosition.z)
		        elseif CastPacket and GetDistance(CastPosition) <= Ranges.Q3 then
		            QPacket(_Q,CastPosition,CastPosition)
		        end
            elseif YasuoMenu.Prediction.mode == 2 then
			    HPred:AddSpell("Q", "Yasuo", {type = "DelayLine", delay = Delays.Q3, range = Ranges.Q3, width = Widths.Q3, speed = Speeds.Q3})
			    local QPos, QHitChance = HPred:GetPredict("Q", minion, myHero)
		        if QPos then
	                if not CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            CastSpell(_Q, QPos.x, QPos.z)
		                end
                    elseif CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            QPacket(_Q, QPos, QPos)
		                end
                    end
				end				
			end
        end
	end
end

function CalDmg(unit, spell)
    if not unit or not spell then return end
	if unit ~= nil then
    	local SNAMES = spell:upper()
    	local caldmg = math.round
    	if SNAMES == "Q" then
    		return caldmg(getDmg("Q", unit, myHero) + getDmg("AD", unit, myHero) or 0)
    	elseif SNAMES == "E" then
      		return caldmg(GetEdmg(unit) or 0)
   		elseif SNAMES == "R" then
      		return caldmg(getDmg("R", unit, myHero) or 0)
    	elseif SNAMES == "IGNITE" then
      		return caldmg(IREADY and getDmg("IGNITE", unit, myHero) or 0)
    	elseif SNAMES == "HXG" then
      		return caldmg(hxgReady and getDmg("HXG", unit, myHero) or 0)
    	elseif SNAMES == "RUINEDKING" then
      		return caldmg(botrkReady and getDmg("RUINEDKING", unit, myHero) or 0)
    	elseif SNAMES == "SHEEN" then
      		return caldmg(sheenReady and getDmg("SHEEN", unit, myHero) or 0)
    	elseif SNAMES == "TRINITY" then
      		return caldmg(trinityReady and getDmg("TRINITY", unit, myHero) or 0)
    	elseif SNAMES == "LIANDRYS" then
      		return caldmg(lyandrisReady and getDmg("LIANDRYS", unit, myHero) or 0)
    	end
	end
end

function FarmLasthit()
	Qlasthit()
	FarmE()
end

function FarmClear()
	LaneClearQ()
	FarmE()
end

function FarmE()
	EnemyMinions:update()
	for _, minion in pairs(EnemyMinions.objects) do
    	if minion and minion.health < GetEdmg(minion) then
      		if not YasuoMenu.Advanced.AdvE.underTower and UnderTurret(eEndPos(minion)) then
        		return
      		end
      		if (YasuoMenu.LaneCL.UseE and YasuoMenu.ClearKey) or (YasuoMenu.LaneLH.UseE and YasuoMenu.LasthitKey) then
        		CastSpell(_E,minion)
      		end
    	end
	end
end

function LaneClearQ()
    EnemyMinions:update()
	for _, minion in pairs(EnemyMinions.objects) do
	local CastPacket = YasuoMenu.Advanced.Packets.packetsQ
    	if YasuoMenu.LaneCL.UseQ and minion and not minion.dead and Q12READY and not IsDashing() then
	        if YasuoMenu.Prediction.mode == 1 then
	            local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, Delays.Q12, Widths.Q12, Ranges.Q12, Speeds.Q12, myHero, false)
		        if not CastPacket and GetDistance(CastPosition) <= Ranges.Q12 then
		            CastSpell(_Q, CastPosition.x, CastPosition.z)
		        elseif CastPacket and GetDistance(CastPosition) <= Ranges.Q12 then
		            QPacket(_Q,CastPosition,CastPosition)
		        end
            elseif YasuoMenu.Prediction.mode == 2 then
			    HPred:AddSpell("Q", "Yasuo", {type = "PromptLine", delay = Delays.Q12, range = Ranges.Q12, width = Widths.Q12})
			    local QPos, QHitChance = HPred:GetPredict("Q", minion, myHero)
		        if QPos then
	                if not CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            CastSpell(_Q, QPos.x, QPos.z)
		                end
                    elseif CastPacket and not IsDashing() then
	                    if GetDistanceSqr(QPos) <= 475^2 then
                            QPacket(_Q, QPos, QPos)
		                end
                    end
				end				
			end
    	elseif YasuoMenu.LaneCL.UseQ2 and minion and not minion.dead and Q3READY and  not IsDashing() and GetDistance(minion) < Ranges.Q3 then
		    if YasuoMenu.Prediction.mode == 1 or YasuoMenu.Prediction.mode == 2 then
      		    local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(minion, Delays.Q3, Widths.Q3, Ranges.Q3, Speeds.Q3, myHero)
      		    if not CastPacket and AOECastPosition then
        		    CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
      		    elseif CastPacket and AOECastPosition then
				    QPacket(_Q,AOECastPosition,AOECastPosition)
				end
    		end
		end
	end
end

function JungleClear()
	local JungleMob = GetJungleMob()
	if JungleMob ~= nil then
    	local Qjungle = YasuoMenu.Jungclear.UseQ
    	local Q2jungle = YasuoMenu.Jungclear.UseQ2
    	if Qjungle and not Q2jungle and Q12READY then
      		CastSpell(_Q, JungleMob.x, JungleMob.z)
    	end
    	if Q2jungle and not Qjungle and Q3READY then
      		CastSpell(_Q, JungleMob.x, JungleMob.z)
    	end
   		if Qjungle and Q2jungle then
      		CastSpell(_Q, JungleMob.x, JungleMob.z)
    	end
    	if YasuoMenu.Jungclear.UseE and EREADY then
      		CastSpell(_E, JungleMob)
    	end
    end
end

function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
    	if ValidTarget(Mob, 500) then
      		return Mob
   		end
  	end
  	for _, Mob in pairs(JungleMobs) do
    	if ValidTarget(Mob, 500) then
      		return Mob
    	end
  	end
end

function GetJungleMob2()
	for _, Mob in pairs(JungleFocusMobs) do
    	if ValidTarget(Mob, 500) then
      		return Mob
   		end
  	end
  	for _, Mob in pairs(JungleMobs) do
    	if ValidTarget(Mob, 500) then
      		return Mob
    	end
  	end
end

function OnCreateObj(obj)
    if not obj then return end
	if obj and (obj.name=="Yasuo_base_R_indicator_beam.troy" or obj.name=="Yasuo_Skin02_R_indicator_beam.troy") then
		unitknocked = unitknocked + 1
    end
  	if FocusJungleNames[obj.name] then
      	table.insert(JungleFocusMobs, obj)
  	elseif JungleMobNames[obj.name] then
      	table.insert(JungleMobs, obj)
  	end
end

function OnDeleteObj(obj)
    if not obj then return end
	if obj and (obj.name=="Yasuo_base_R_indicator_beam.troy" or obj.name=="Yasuo_Skin02_R_indicator_beam.troy") then
		unitknocked = unitknocked - 1
    end
  	for i, Mob in pairs(JungleMobs) do
      	if obj.name == Mob.name then
        	table.remove(JungleMobs, i)
      	end
  	end
  	for i, Mob in pairs(JungleFocusMobs) do
      	if obj.name == Mob.name then
        	table.remove(JungleFocusMobs, i)
      	end
  	end
end

function JungleNames()
  	local JungMap = false
  	if GetGame().map.shortName == "twistedTreeline" then
      	JungMap = true
  	else
	    if GetGame().map.index == 15 then
      	    JungMap = false
			NewRift = true
		else 
      	    JungMap = false
			NewRift = false
        end		    
    end
  	if JungMap then
      	FocusJungleNames = {
        	["TT_NWraith1.1.1"] = true,
        	["TT_NGolem2.1.1"] = true,
        	["TT_NWolf3.1.1"] = true,
        	["TT_NWraith4.1.1"] = true,
        	["TT_NGolem5.1.1"] = true,
        	["TT_NWolf6.1.1"] = true,
        	["TT_Spiderboss8.1.1"] = true
      	}
      	JungleMobNames = {
        	["TT_NWraith21.1.2"] = true,
        	["TT_NWraith21.1.3"] = true,
       	  	["TT_NGolem22.1.2"] = true,
       	  	["TT_NWolf23.1.2"] = true,
       	  	["TT_NWolf23.1.3"] = true,
       	  	["TT_NWraith24.1.2"] = true,
        	["TT_NWraith24.1.3"] = true,
        	["TT_NGolem25.1.1"] = true,
        	["TT_NWolf26.1.2"] = true,
        	["TT_NWolf26.1.3"] = true
      	}
  	else
	    if NewRift then
		JungleMobNames = {
        	["SRU_Baron12.1.1"] = true,
        	["SRU_Dragon6.1.1"] = true,
        	["SRU_Blue1.1.1"] = true,
        	["SRU_Blue7.1.1"] = true,
        	["SRU_BlueMini1.1.2"] = true,
        	["SRU_BlueMini21.1.3"] = true,
        	["SRU_BlueMini27.1.3"] = true,
        	["SRU_BlueMini7.1.2"] = true,
        	["SRU_Red4.1.1"] = true,
        	["SRU_Red10.1.1"] = true,
        	["SRU_RedMini4.1.2"] = true,
        	["SRU_RedMini4.1.3"] = true,
        	["SRU_RedMini10.1.2"] = true,
        	["SRU_RedMini10.1.3"] = true,
        	["SRU_Murkwolf2.1.1"] = true,
        	["SRU_Murkwolf8.1.1"] = true,
        	["SRU_MurkwolfMini2.1.2"] = true,
        	["SRU_MurkwolfMini2.1.3"] = true,
        	["SRU_MurkwolfMini8.1.2"] = true,
        	["SRU_MurkwolfMini8.1.3"] = true,
        	["SRU_Razorbeak3.1.1"] = true,
        	["SRU_Razorbeak9.1.1"] = true,
        	["SRU_RazorbeakMini3.1.2"] = true,
        	["SRU_RazorbeakMini3.1.3"] = true,
        	["SRU_RazorbeakMini3.1.4"] = true,
        	["SRU_RazorbeakMini9.1.2"] = true,
        	["SRU_RazorbeakMini9.1.3"] = true,
        	["SRU_RazorbeakMini9.1.4"] = true,
        	["SRU_Krug5.1.2"] = true,
        	["SRU_Krug11.1.2"] = true,
        	["SRU_KrugMini5.1.1"] = true,
        	["SRU_KrugMini11.1.1"] = true,
        	["SRU_Gromp14.1.1"] = true,
        	["SRU_Gromp13.1.1"] = true,
        	["Sru_Crab15.1.1"] = true,
        	["Sru_Crab16.1.1"] = true
		}
		FocusJungleNames = {
		    ["SRU_Baron12.1.1"] = true,
        	["SRU_Dragon6.1.1"] = true,
        	["SRU_Blue1.1.1"] = true,
        	["SRU_Blue7.1.1"] = true,
        	["SRU_Red4.1.1"] = true,
        	["SRU_Red10.1.1"] = true,
        	["SRU_Murkwolf2.1.1"] = true,
        	["SRU_Murkwolf8.1.1"] = true,
        	["SRU_Razorbeak3.1.1"] = true,
        	["SRU_Razorbeak9.1.1"] = true,
        	["SRU_Krug5.1.2"] = true,
        	["SRU_Krug11.1.2"] = true,
        	["SRU_Gromp14.1.1"] = true,
        	["SRU_Gromp13.1.1"] = true,
			 ["Sru_Crab15.1.1"] = true,
        	["Sru_Crab16.1.1"] = true
		}
		else
      	JungleMobNames = {
        	["Wolf8.1.2"] = true,
        	["Wolf8.1.3"] = true,
        	["YoungLizard7.1.2"] = true,
        	["YoungLizard7.1.3"] = true,
        	["LesserWraith9.1.3"] = true,
        	["LesserWraith9.1.2"] = true,
        	["LesserWraith9.1.4"] = true,
        	["YoungLizard10.1.2"] = true,
        	["YoungLizard10.1.3"] = true,
        	["SmallGolem11.1.1"] = true,
        	["Wolf2.1.2"] = true,
        	["Wolf2.1.3"] = true,
        	["YoungLizard1.1.2"] = true,
        	["YoungLizard1.1.3"] = true,
        	["LesserWraith3.1.3"] = true,
        	["LesserWraith3.1.2"] = true,
        	["LesserWraith3.1.4"] = true,
        	["YoungLizard4.1.2"] = true,
        	["YoungLizard4.1.3"] = true,
        	["SmallGolem5.1.1"] = true
      	}
      	FocusJungleNames = {
        	["Dragon6.1.1"] = true,
        	["Worm12.1.1"] = true,
        	["GiantWolf8.1.1"] = true,
        	["AncientGolem7.1.1"] = true,
        	["Wraith9.1.1"] = true,
        	["LizardElder10.1.1"] = true,
        	["Golem11.1.2"] = true,
        	["GiantWolf2.1.1"] = true,
        	["AncientGolem1.1.1"] = true,
        	["Wraith3.1.1"] = true,
        	["LizardElder4.1.1"] = true,
        	["Golem5.1.2"] = true,
        	["GreatWraith13.1.1"] = true,
        	["GreatWraith14.1.1"] = true
      	}
    	end
	end
  	for i = 0, objManager.maxObjects do
      	local object = objManager:getObject(i)
      	if object ~= nil then
        	if FocusJungleNames[object.name] then
          	  	table.insert(JungleFocusMobs, object)
        	elseif JungleMobNames[object.name] then
          	  	table.insert(JungleMobs, object)
        	end
      	end
  	end
end

function AutoR()
  	if YasuoMenu.Advanced.AdvR.AutoRhealth and (YasuoMenu.Advanced.AdvR.Health2 > myHero.health * 100 / myHero.maxHealth) then
      	return
  	end
  	if YasuoMenu.Advanced.AdvR.AutoRally then
	    local rangeR = YasuoMenu.Advanced.AdvR.xRange
		if YasuoMenu.Advanced.AdvR.xNumber > CountAllysInRange(rangeR, myHero) then
      	    return
  	    end
	end
	if not YasuoMenu.Advanced.AdvR.underTower2 and UnderTurret(AutoRUnderTurret()) then
		return
    end
    if YasuoMenu.Advanced.AdvR.AutoR then
        if YasuoMenu.Advanced.AdvR.myTarget then
            if YasuoMenu.Advanced.AdvR.xNumber == 1 and targetknocked == 1 and RREADY then
                DelayAction(function()
                    CastSpell(_R)
                end, 0.5 - GetLatency() / 1000)
            elseif YasuoMenu.Advanced.AdvR.xNumber > 1 and targetknocked >= YasuoMenu.Advanced.AdvR.xNumber and RREADY then
                CastSpell(_R)
            end
        elseif not YasuoMenu.Advanced.AdvR.myTarget and RREADY and unitknocked >= YasuoMenu.Advanced.AdvR.xNumber and unitknocked >= YasuoMenu.Advanced.AdvR.xEnemies then
            CastSpell(_R)
        end
    end
end

function CountEnemyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and not hero.dead and hero.visible and hero.team ~= myHero.team and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function CountAllysInRange(range, object)
  local allyInRange = 0
  local allies = GetAllyHeroes()
  if object ~= nil and range then
    for i, ally in pairs(allies) do
      if not ally.dead and  ValidTarget(ally) and range > GetDistance(ally, object) then
        allyInRange = allyInRange + 1
      end
    end
  end
  return allyInRange
end

function CountMinionInRange(range, object)
    AllMinions:update()
    local minionInRange = 0
    if object ~= nil and range then
        for index, minion in pairs(AllMinions.objects) do
            if minion and not minion.dead and range > GetDistance(minion, object) then
                minionInRange = minionInRange + 1
            end
        end
    end
    return minionInRange
end

--[[function AutoQ(target)
    if not YasuoMenu.Advanced.AdvQ.underTower and UnderTurret(target) or target == nil then
        return
    end
    if not YasuoMenu.ComboKey and not YasuoMenu.HarassKey and not YasuoMenu.HarassToggleKey and target and not target.dead and target.visible then
        if YasuoMenu.Advanced.AdvQ.LogicQ and (myHero.health > myHero.maxHealth * 0.2 and 1 >= countEnemies(target, 600) or target.health < CalDmg(target, "Q")) then
            if target and target.type == myHero.type then
                if YasuoMenu.Advanced.AdvQ.AutoQ then
                    Q12(target)
                end
                if YasuoMenu.Advanced.AdvQ.AutoQ2 then
                    Q3(target)
                end
            end
        elseif not YasuoMenu.Advanced.AdvQ.LogicQ and target and target.type == myHero.type then
            if YasuoMenu.Advanced.AdvQ.AutoQ then
                Q12(target)
            end
            if YasuoMenu.Advanced.AdvQ.AutoQ2 then
                Q3(target)
            end
        end
    end
end]]

function AutoQ(Target)
    local EnemyQ = CountEnemyAutoQ(475,myHero)
	local TargetQ = Target and GetDistance(Target) <= 475 or EnemyQ
    if not YasuoMenu.Advanced.AdvQ.underTower and UnderTurret(TargetQ) or TargetQ == nil then
        return
    end
    if not YasuoMenu.ComboKey and not YasuoMenu.HarassKey and not YasuoMenu.HarassToggleKey and TargetQ and not TargetQ.dead and TargetQ.visible then
        if YasuoMenu.Advanced.AdvQ.LogicQ and (myHero.health > myHero.maxHealth * 0.2 and 1 >= countEnemies(TargetQ, 600) or TargetQ.health < CalDmg(TargetQ, "Q")) then
            if TargetQ and TargetQ.type == myHero.type then
                if YasuoMenu.Advanced.AdvQ.AutoQ then
                    Q12(TargetQ)
                end
                if YasuoMenu.Advanced.AdvQ.AutoQ2 then
                    Q3(TargetQ)
                end
            end
        elseif not YasuoMenu.Advanced.AdvQ.LogicQ and TargetQ and TargetQ.type == myHero.type then
            if YasuoMenu.Advanced.AdvQ.AutoQ then
                Q12(TargetQ)
            end
            if YasuoMenu.Advanced.AdvQ.AutoQ2 then
                Q3(TargetQ)
            end
        end
    end
end

function CountEnemyAutoQ(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    enemyQ = nil
	DisQ = 600
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistanceSqr(object, enemy) <= range and DisQ > GetDistance(enemy, mousePos) then
		    DisQ = GetDistance(enemy, mousePos)
            enemyQ = enemy
        end
    end
    return enemyQ
end

function countEnemies(point, range)
    local ChampCount = 0
    for i, champ in ipairs(GetEnemyHeroes()) do
        if champ and not champ.dead and range >= GetDistance(champ, point) then
            ChampCount = ChampCount + 1
        end
    end
    return ChampCount
end

function Qwult()
    if Qult then
	    for i, enemy in ipairs(GetEnemyHeroes()) do 
		    if Knockups[enemy.networkID] ~= nil then
		        if GetDistance(enemy) < 200 and (Q12READY or Q3READY) then
                    CastSpell(_Q,enemy.x,enemy.z)
                end	
            end	
		end
    end			
end

function OnRecall(unit, channelTimeInMs)
    if not YasuoMenu.Advanced.AdvQ.interruptRecallQ then
        return
    end
    local gametimer = GetGameTimer()
    local Qdistance = GetDistance(unit) / Speeds.Q3
    if Q3READY and unit and GetDistance(unit) < Ranges.Q3 and unit.team == TEAM_ENEMY and gametimer + Qdistance <= gametimer + channelTimeInMs then
        CastSpell(_Q,unit.x,unit.z)
    end
end

function HarassT(target)
    if target then
        if YasuoMenu.Harass.UseQ then
            Q12(target)
        end
        if YasuoMenu.Harass.UseQ2 then
            Q3(target)
        end
        if YasuoMenu.Harass.UseE then
            if not YasuoMenu.Advanced.AdvE.underTower and UnderTurret(eEndPos(target)) then
                return
            else
                E(target)
            end
        end
        if YasuoMenu.Combo.UseItems then
            ItemsT(target)
        end
        if YasuoMenu.Harass.LhQ then
            if GetDistance(target) > 700 and Q12READY then
	            Qlasthit()
            end
        end
    end
end

function Autolevel()
    if YasuoMenu.Extras.StartLv == 1 then
        autoLevelSetSequence(YasuoLevel.QEW)
    elseif YasuoMenu.Extras.StartLv == 2 then
        autoLevelSetSequence(YasuoLevel.EQW)
    end
end

function AutoPotions()
    if tickPotions == nil or (GetTickCount() - tickPotions > 1000) then
        --PotionSlot = GetInventorySlotItem(2003)
        --if PotionSlot ~= nil then 
		if PotReady("regenerationpotion") then
            if myHero.health < (YasuoMenu.Extras.autoPotions/100*myHero.maxHealth) and not TargetHaveBuff("RegenerationPotion", myHero) and not InFountain() then
                --CastSpell(PotionSlot)
				CastPots("regenerationpotion")
            end
        end
        tickPotions = GetTickCount()
    end
end

function Killsteal()
    for i, enemy in pairs(GetEnemyHeroes()) do
        if ValidTargetedT(enemy) then
		    if ignite ~= nil and enemy.health <= CalDmg(enemy, "IGNITE") and YasuoMenu.KS.UseIgnite and GetDistance(enemy) < 600 then
                CastSpell(ignite, enemy)
            end
            if enemy.health <= CalDmg(enemy, "Q") and YasuoMenu.KS.UseQ and Q12READY and GetDistance(enemy) < Ranges.Q12 then
                Q12(enemy)
            end
            if enemy.health <= CalDmg(enemy, "Q") and YasuoMenu.KS.UseQ2 and Q3READY and GetDistance(enemy) < Ranges.Q3 then
                Q3(enemy)
            end
            if enemy.health <= CalDmg(enemy, "E") and YasuoMenu.KS.UseE and GetDistance(enemy) < Ranges.E then
                E(enemy)
            end
            if enemy.health <= CalDmg(enemy, "R") and YasuoMenu.KS.UseR and GetDistance(enemy) < Ranges.R then
                if Knockups[enemy.networkID] ~= nil then
                    R(enemy)
                end
            end
        end
    end
end

function GetMinionNearUnit(unit)
    local closestMinion, nearestDistance = nil, 0
    EnemyMinions:update()
    JungleMinions:update()
    for index, minion in pairs(EnemyMinions.objects) do
        if minion and not minion.dead and unit and Ranges.E >= GetDistance(minion) and GetDistance(eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
            nearestDistance = GetDistance(minion)
            closestMinion = minion
        end
    end
    for index, minion in pairs(JungleMinions.objects) do
        if minion and not minion.dead and Ranges.E >= GetDistance(minion) and GetDistance(eEndPos(minion), unit) < GetDistance(unit) and nearestDistance < GetDistance(minion) then
            nearestDistance = GetDistance(minion)
            closestMinion = minion
        end
    end
    for i, enemy in pairs(GetEnemyHeroes()) do
        if enemy and not enemy.dead and Ranges.E >= GetDistance(enemy) and GetDistance(eEndPos(enemy), unit) < GetDistance(unit) and nearestDistance < GetDistance(enemy) then
            nearestDistance = GetDistance(enemy)
            closestMinion = enemy
        end
    end
    return closestMinion
end

function Escape()
    EnemyMinions:update()
    if YasuoMenu.Escape.Mouse and not NearMouse and not stopMove then
        myHero:MoveTo(mousePos.x, mousePos.z)
    end
    local mPos = GetMinionNearUnit(mousePos)
    if mPos then
        E(mPos)
    end
    if YasuoMenu.Escape.StackQ and Q12READY and IsDashing2() then
        for _, minion in pairs(EnemyMinions.objects) do
            if minion ~= nil and GetDistance(minion) < 350 then
                CastSpell(_Q,minion.x,minion.z)
             end
        end
		for _, minion in pairs(JungleMinions.objects) do
            if minion ~= nil and GetDistance(minion) < 350 then
                CastSpell(_Q,minion.x,minion.z)
             end
        end
    end
end

function WallJumpT()
    JungleMinions:update()
    local JungleMob = GetJungleMob2()
	if YasuoMenu.EscapeKey then
        local to = Vector(myHero.x, myHero.y,myHero.z)
        local stopMove = false
        local Spots = JumpSpots[myHero.charName]
        if Spots and YasuoMenu.Walljump.Enabled then
            for i, spot in ipairs(Spots) do
                if GetDistanceSqr(spot.From,mousePos) < 300*300 then
                    local stopMove = true
                    if GetDistanceSqr(spot.From, to) > 250*250 then
				        myHero:MoveTo(mousePos.x, mousePos.z)
			        elseif GetDistanceSqr(spot.From, to) < 250*250 then
				       WJ:AddAction(MoveWall(spot.From))
				       myHero:MoveTo(spot.From.x, spot.From.z)
			        end
			        if GetDistanceSqr(spot.From, to) < 25*25 then
				        if myHero:CanUseSpell(_W) == READY and (JungleMob == nil) then
					        CastSpell(_W, spot.CastPos.x,spot.CastPos.z)
					    end
				        if JungleMob ~= nil and GetDistance(JungleMob) <= 475 and EREADY then
					        CastSpell(_E,JungleMob)
						    for _, minion in pairs(JungleMinions.objects) do
						        if minion and minion.valid and not minion.dead and GetDistance(minion) <= 475 then
							        CastSpell(_E,minion)
							    end
						    end
				        end
                    end
				end
            end
        end
    end
end

function TARGB(t)
	return ARGB(t[1], t[2], t[3], t[4])
end

function DrawCoolArrow(from, to, color)
	DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, color, 1)
end

--[[function OnNewPath(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance)
    if isDash and unit and unit.isMe then
	    --Espeed = dashSpeed
		--Eduration = 475/dashSpeed - GetLatency()/1000
		--Eduration2 = 475/dashSpeed + os.clock()
		--Tdashing = true
	end
end]]

function EtoMouse()
    EnemyMinions:update()
    local mPos = GetMinionNearUnit(mousePos)
    if mPos then
        E(mPos)
    end
end

function BuffReset()
	for i, obj in pairs(Knockups) do
		if os.clock() >= obj then
			Knockups[i] = nil
		end
	end
	for i,obj in pairs(TargetKnockedup) do
		if os.clock() >= obj then
			TargetKnockedup[i] = nil
			targetknocked = targetknocked - 1
		end
	end	    
end
--------- Wall Jump ---------------
------------------------------------------
class "YasuoWallJump"
function YasuoWallJump:__init()
	AddTickCallback(function() self:OnTick() end)
	self.queue = {}
	self.currentaction = nil
end

function YasuoWallJump:OnTick()
	if not self.currentaction and #self.queue > 0 then
		local action = self.queue[1]
		self.currentaction = action
		if self.currentaction.onstartcallback then
			if self.currentaction.onstartcallback() then
				action:start(self)
			end
		else
			action:start()
		end
		
		table.remove(self.queue, 1)
	elseif self.currentaction then
		if self.currentaction:checkfinished() then
			self.currentaction:OnFinish(self)
			self.currentaction = nil
		end
	end
end

function YasuoWallJump:AddAction(action, pos)
	table.insert(self.queue, pos or (#self.queue + 1), action)
end

function YasuoWallJump:GetLastAction()
	if self.currentaction and #self.queue == 0 then
		return self.currentaction
	elseif #self.queue > 0 then
		return self.queue[#self.queue]
	end
end

function YasuoWallJump:ClearQueue()
	self.queue = {}
end

function YasuoWallJump:StopCurrentAction()
	self.currentaction = nil
end

function YasuoWallJump:Draw()
	if self.currentaction then
		local from = Vector(myHero)
		local to = Vector(myHero)
		
		to = self.currentaction.to and self.currentaction.to or to

		self.currentaction:Draw(from, to)

		for i, action in ipairs(self.queue) do
			from = to
			if action.target and ValidTarget(action.target) then
				action.to = Vector(action.target)
			end
			to = action.to and action.to or to
			action:Draw(from, to)
		end
	end
end

class "CastToTargetE"
function CastToTargetE:__init(slot, target)
	self.to = target
	self.target = target
	self.slot = slot
	self.originalname = myHero:GetSpellData(self.slot).name
end

function CastToTargetE:start()
end

function CastToTargetE:checkfinished()
	if myHero:CanUseSpell(self.slot) == READY and not self.casted then
		CastSpell(self.slot, self.target)
		self.casted = true
	end

	if self.casted and (myHero:CanUseSpell(self.slot) ~= READY or myHero:GetSpellData(self.slot).name ~= self.originalname)then
		return true
	end
	return false
end

function CastToTargetE:OnFinish(parent)
end

function CastToTargetE:Draw(from, to)
	DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 0, 255), 1)
end
class "WaitForJungleMob"
function WaitForJungleMob:__init(distance, timeout)
	distance = distance or 2000
	timeout = timeout or 1
	self.name = name
	self.found = false
	self.startTime = math.huge
	self.timeout = timeout
	self.distancesqr = distance * distance
	self.JungleMinions = minionManager(MINION_JUNGLE, distance, myHero.visionPos, MINION_SORT_MAXHEALTH_DEC)
end

function WaitForJungleMob:start()
	self.startTime = os.clock()
end

function WaitForJungleMob:OnFinish(parent)
	if (#parent.queue > 0) and self.object then
		parent.queue[1].target = self.object
		parent.queue[1].to = self.object
	end
end

function WaitForJungleMob:checkfinished()
	self.JungleMinions:update()
	if (os.clock() - self.startTime) > self.timeout or self.JungleMinions.objects[1] then
		self.object = self.JungleMinions.objects[1]
		return true
	end
	return false
end

function WaitForJungleMob:Draw(from, to)
	DrawText3D(tostring("Jungle Mob"), from.x, from.y, from.z, 13, self.color or ARGB(255, 255, 255, 255))
end

class "MoveWall"
function MoveWall:__init(to)
	self.to = to
end

function MoveWall:start()
	--WayPointManager.AddCallback(function(n) self:OnNewWaypoints(n) end)
	--self.WaypointsReceived = false
	--myHero:MoveTo(self.to.x, self.to.z)
end

function MoveWall:checkfinished()
	if myHero.hasMovePath or GetDistanceSqr(myHero.visionPos, self.to) < 400 then
		local waypoints = self:GetWayPoints(myHero)
		if GetDistanceSqr(myHero.visionPos, waypoints[#waypoints]) <=  (myHero.ms * (GetLatency()/2000 + 0.1))^2  or #waypoints == 1 then
			return true
		end
	end
	--myHero:MoveTo(self.to.x, self.to.z)
	return false
end

--[[function MoveWall:OnNewWaypoints(networkID)
	if networkID == myHero.networkID then
		self.WaypointsReceived = true
	end
end]]

function MoveWall:OnFinish(parent)
end

function MoveWall:Draw(from, to)
	--if self.WaypointsReceived then
	local waypoints = self:GetWayPoints(myHero)
	if myHero.hasMovePath then
		for i = 1, #waypoints - 1 do
			from = Vector(waypoints[i].x, 0, waypoints[i].y)
			to = Vector(waypoints[i + 1].x, 0, waypoints[i + 1].y)

			DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 255, 0), 1)
		end
	else
		DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 255, 0), 1)
	end
end
function MoveWall:GetWayPoints(object)
	local result = {}
	if object.hasMovePath then
		result[1] = Vector(object.pos.x, object.pos.y, object.pos.z)
		for i = object.pathIndex, object.pathCount do
			local p = object:GetPath(i)
			result[#result+1] = Vector(p.x, p.y, p.z)
		end
	else
		result[1] = Vector(object.pos.x, object.pos.y, object.pos.z)
	end
	return result
end

function ResetAA()
    if _G.AutoCarry then _G.AutoCarry.Orbwalker:ResetAttackTimer() end
end

function ValidTargetedT(target,range)
    return ValidTarget(target,range) and target.valid and not target.dead 
end
--CREDIT TO EXTRAGOZ
local spellsFile = LIB_PATH.."missedspells.txt"
local spellslist = {}
local textlist = ""
local spellexists = false
local spelltype = "Unknown"
 
function writeConfigsspells()
        local file = io.open(spellsFile, "w")
        if file then
                textlist = "return {"
                for i=1,#spellslist do
                        textlist = textlist.."'"..spellslist[i].."', "
                end
                textlist = textlist.."}"
                if spellslist[1] ~=nil then
                        file:write(textlist)
                        file:close()
                end
        end
end
if FileExist(spellsFile) then spellslist = dofile(spellsFile) end
 
local Others = {"Recall","recall","OdinCaptureChannel","LanternWAlly","varusemissiledummy","khazixqevo","khazixwevo","khazixeevo","khazixrevo","braumedummyvoezreal","braumedummyvonami","braumedummyvocaitlyn","braumedummyvoriven","braumedummyvodraven","braumedummyvoashe","azirdummyspell", 'reksaiqattack', 'reksaiqattack2', 'reksaiqattack3', 'reksaitunneltime', 'kalistamysticshotmis', 'kalistaexpunge', 'kalistadummyspell', 'KalistaRAllyDash', 'kalistar','lanternwally'}
local Items = {"RegenerationPotion","FlaskOfCrystalWater","ItemCrystalFlask","ItemMiniRegenPotion","PotionOfBrilliance","PotionOfElusiveness","PotionOfGiantStrength","OracleElixirSight","OracleExtractSight","VisionWard","SightWard","sightward","ItemGhostWard","ItemMiniWard","ElixirOfRage","ElixirOfIllumination","wrigglelantern","DeathfireGrasp","HextechGunblade","shurelyascrest","IronStylus","ZhonyasHourglass","YoumusBlade","randuinsomen","RanduinsOmen","Mourning","OdinEntropicClaymore","BilgewaterCutlass","QuicksilverSash","HextechSweeper","ItemGlacialSpike","ItemMercurial","ItemWraithCollar","ItemSoTD","ItemMorellosBane","ItemPromote","ItemTiamatCleave","Muramana","ItemSeraphsEmbrace","ItemSwordOfFeastAndFamine","ItemFaithShaker","OdynsVeil","ItemHorn","ItemPoroSnack","ItemBlackfireTorch","HealthBomb","ItemDervishBlade","TrinketTotemLvl1","TrinketTotemLvl2","TrinketTotemLvl3","TrinketTotemLvl3B","TrinketSweeperLvl1","TrinketSweeperLvl2","TrinketSweeperLvl3","TrinketOrbLvl1","TrinketOrbLvl2","TrinketOrbLvl3","OdinTrinketRevive","RelicMinorSpotter","RelicSpotter","RelicGreaterLantern","RelicLantern","RelicSmallLantern","ItemFeralFlare","trinketorblvl2","trinketsweeperlvl2","trinkettotemlvl2","SpiritLantern","RelicGreaterSpotter",'TrinketTotemLvl1', 'TrinketSweeperLvl1', 'TrinketTotemLvl2', 'TrinketSweeperLvl2', 'trinkettotemlvl2', 'trinketsweeperlvl2', 'ItemFeralFlare','ItemKingPoroSnack', 'itemsmiteaoe'}
local MSpells = {"JayceStaticField","JayceToTheSkies","JayceThunderingBlow","Takedown","Pounce","Swipe","EliseSpiderQCast","EliseSpiderW","EliseSpiderEInitial","elisespidere","elisespideredescent","gnarbigq","gnarbigw","gnarbige","GnarBigQMissile"}
local PSpells = {"CaitlynHeadshotMissile","RumbleOverheatAttack","JarvanIVMartialCadenceAttack","ShenKiAttack","MasterYiDoubleStrike","sonaqattackupgrade","sonawattackupgrade","sonaeattackupgrade","NocturneUmbraBladesAttack","NautilusRavageStrikeAttack","ZiggsPassiveAttack","QuinnWEnhanced","LucianPassiveAttack","SkarnerPassiveAttack","KarthusDeathDefiedBuff","AzirTowerClick","azirtowerclick","azirtowerclickchannel"}

local QSpells = {"RekSaiQBurrowedMis","TrundleQ","LeonaShieldOfDaybreakAttack","XenZhaoThrust","NautilusAnchorDragMissile","RocketGrabMissile","VayneTumbleAttack","VayneTumbleUltAttack","NidaleeTakedownAttack","ShyvanaDoubleAttackHit","ShyvanaDoubleAttackHitDragon","frostarrow","FrostArrow","MonkeyKingQAttack","MaokaiTrunkLineMissile","FlashFrostSpell","xeratharcanopulsedamage","xeratharcanopulsedamageextended","xeratharcanopulsedarkiron","xeratharcanopulsediextended","SpiralBladeMissile","EzrealMysticShotMissile","EzrealMysticShotPulseMissile","jayceshockblast","BrandBlazeMissile","UdyrTigerAttack","TalonNoxianDiplomacyAttack","LuluQMissile","GarenSlash2","VolibearQAttack","dravenspinningattack","karmaheavenlywavec","ZiggsQSpell","UrgotHeatseekingHomeMissile","UrgotHeatseekingLineMissile","JavelinToss","RivenTriCleave","namiqmissile","NasusQAttack","BlindMonkQOne","ThreshQInternal","threshqinternal","QuinnQMissile","LissandraQMissile","EliseHumanQ","GarenQAttack","JinxQAttack","JinxQAttack2","yasuoq","xeratharcanopulse2","VelkozQMissile","KogMawQMis","BraumQMissile","KarthusLayWasteA1","KarthusLayWasteA2","KarthusLayWasteA3","karthuslaywastea3","karthuslaywastea2","karthuslaywastedeada1","MaokaiSapling2Boom","gnarqmissile","GnarBigQMissile","viktorqbuff"}
local WSpells = {"KogMawBioArcaneBarrageAttack","SivirWAttack","TwitchVenomCaskMissile","gravessmokegrenadeboom","mordekaisercreepingdeath","DrainChannel","jaycehypercharge","redcardpreattack","goldcardpreattack","bluecardpreattack","RenektonExecute","RenektonSuperExecute","EzrealEssenceFluxMissile","DariusNoxianTacticsONHAttack","UdyrTurtleAttack","talonrakemissileone","LuluWTwo","ObduracyAttack","KennenMegaProc","NautilusWideswingAttack","NautilusBackswingAttack","XerathLocusOfPower","yoricksummondecayed","Bushwhack","karmaspiritbondc","SejuaniBasicAttackW","AatroxWONHAttackLife","AatroxWONHAttackPower","JinxWMissile","GragasWAttack","braumwdummyspell","syndrawcast","SorakaWParticleMissile"}
local ESpells = {"KogMawVoidOozeMissile","ToxicShotAttack","LeonaZenithBladeMissile","PowerFistAttack","VayneCondemnMissile","ShyvanaFireballMissile","maokaisapling2boom","VarusEMissile","CaitlynEntrapmentMissile","jayceaccelerationgate","syndrae5","JudicatorRighteousFuryAttack","UdyrBearAttack","RumbleGrenadeMissile","Slash","hecarimrampattack","ziggse2","UrgotPlasmaGrenadeBoom","SkarnerFractureMissile","YorickSummonRavenous","BlindMonkEOne","EliseHumanE","PrimalSurge","Swipe","ViEAttack","LissandraEMissile","yasuodummyspell","XerathMageSpearMissile","RengarEFinal","RengarEFinalMAX","KarthusDefileSoundDummy2"}
local RSpells = {"Pantheon_GrandSkyfall_Fall","LuxMaliceCannonMis","infiniteduresschannel","JarvanIVCataclysmAttack","jarvanivcataclysmattack","VayneUltAttack","RumbleCarpetBombDummy","ShyvanaTransformLeap","jaycepassiverangedattack", "jaycepassivemeleeattack","jaycestancegth","MissileBarrageMissile","SprayandPrayAttack","jaxrelentlessattack","syndrarcasttime","InfernalGuardian","UdyrPhoenixAttack","FioraDanceStrike","xeratharcanebarragedi","NamiRMissile","HallucinateFull","QuinnRFinale","lissandrarenemy","SejuaniGlacialPrisonCast","yasuordummyspell","xerathlocuspulse","tempyasuormissile","PantheonRFall"}

local casttype2 = {"blindmonkqtwo","blindmonkwtwo","blindmonketwo","infernalguardianguide","KennenMegaProc","sonawattackupgrade","redcardpreattack","fizzjumptwo","fizzjumpbuffer","gragasbarrelrolltoggle","LeblancSlideM","luxlightstriketoggle","UrgotHeatseekingHomeMissile","xeratharcanopulseextended","xeratharcanopulsedamageextended","XenZhaoThrust3","ziggswtoggle","khazixwlong","khazixelong","renektondice","SejuaniNorthernWinds","shyvanafireballdragon2","shyvanaimmolatedragon","ShyvanaDoubleAttackHitDragon","talonshadowassaulttoggle","viktorchaosstormguide","zedw2","ZedR2","khazixqlong","AatroxWONHAttackLife","viktorqbuff"}
local casttype3 = {"AatroxQ","sonaeattackupgrade","bluecardpreattack","LeblancSoulShackleM","UdyrPhoenixStance","RenektonSuperExecute",'porothrowfollowupcast'}
local casttype4 = {"VolleyAttack","FrostShot","PowerFist","DariusNoxianTacticsONH","EliseR","JaxEmpowerTwo","JaxRelentlessAssault","JayceStanceHtG","jaycestancegth","jaycehypercharge","JudicatorRighteousFury","kennenlrcancel","KogMawBioArcaneBarrage","LissandraE","MordekaiserMaceOfSpades","mordekaisercotgguide","NasusQ","Takedown","NocturneParanoia","QuinnR","RengarQ","HallucinateFull","DeathsCaressFull","SivirW","ThreshQInternal","threshqinternal","PickACard","goldcardlock","redcardlock","bluecardlock","FullAutomatic","VayneTumble","MonkeyKingDoubleAttack","YorickSpectral","ViE","VorpalSpikes","FizzSeastonePassive","GarenSlash3","HecarimRamp","leblancslidereturn","leblancslidereturnm","Obduracy","UdyrTigerStance","UdyrTurtleStance","UdyrBearStance","UrgotHeatseekingMissile","XenZhaoComboTarget","dravenspinning","dravenrdoublecast","FioraDance","LeonaShieldOfDaybreak","MaokaiDrain3","NautilusPiercingGaze","RenektonPreExecute","RivenFengShuiEngine","rivenizunablade","RivenLightsaberMissile","ShyvanaDoubleAttack","shyvanadoubleattackdragon","SyndraW","TalonNoxianDiplomacy","TalonCutthroat","talonrakemissileone","TrundleTrollSmash","VolibearQ","AatroxW","aatroxw2","AatroxWONHAttackLife","JinxQ","GarenQ","yasuoq","XerathArcanopulseChargeUp","XerathLocusOfPower2","xerathlocuspulse","velkozqsplitactivate","NetherBlade","GragasQToggle","GragasW","SionW","sionpassivespeed","UdyrSpiritBearAttack",'udyrtigerattackult', 'udyrturtleattackult', 'udyrspiritbearattackult', 'udyrbearattackult', 'UdyrSpiritPhoenixAttack'}
local casttype5 = {"VarusQ","ZacE","ViQ","SionQ"}
local casttype6 = {"VelkozQMissile","KogMawQMis","RengarEFinal","RengarEFinalMAX","BraumQMissile","KarthusDefileSoundDummy2","gnarqmissile","GnarBigQMissile","SorakaWParticleMissile"}
--,"PoppyDevastatingBlow"--,"Deceive" -- ,"EliseRSpider"
function getSpellType(unit, spellName)
        spelltype = "Unknown"
        casttype = 1
        if unit ~= nil and unit.type == "AIHeroClient" then
                if spellName == nil or unit:GetSpellData(_Q).name == nil or unit:GetSpellData(_W).name == nil or unit:GetSpellData(_E).name == nil or unit:GetSpellData(_R).name == nil then
                        return "Error name nil", casttype
                end
                if spellName:find("SionBasicAttackPassive") or spellName:find("zyrapassive") then
                        spelltype = "P"
                elseif (spellName:find("BasicAttack") and spellName ~= "SejuaniBasicAttackW") or spellName:find("basicattack") or spellName:find("JayceRangedAttack") or spellName == "SonaQAttack" or spellName == "SonaWAttack" or spellName == "SonaEAttack" or spellName == "ObduracyAttack" or spellName == "GnarBigAttackTower" then
                        spelltype = "BAttack"
                elseif spellName:find("CritAttack") or spellName:find("critattack") then
                        spelltype = "CAttack"
                elseif unit:GetSpellData(_Q).name:find(spellName) then
                        spelltype = "Q"
                elseif unit:GetSpellData(_W).name:find(spellName) then
                        spelltype = "W"
                elseif unit:GetSpellData(_E).name:find(spellName) then
                        spelltype = "E"
                elseif unit:GetSpellData(_R).name:find(spellName) then
                        spelltype = "R"
                elseif spellName:find("Summoner") or spellName:find("summoner") or spellName == "teleportcancel" then
                        spelltype = "Summoner"
                else
                        if spelltype == "Unknown" then
                                for i=1,#Others do
                                        if spellName:find(Others[i]) then
                                                spelltype = "Other"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#Items do
                                        if spellName:find(Items[i]) then
                                                spelltype = "Item"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#PSpells do
                                        if spellName:find(PSpells[i]) then
                                                spelltype = "P"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#QSpells do
                                        if spellName:find(QSpells[i]) then
                                                spelltype = "Q"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#WSpells do
                                        if spellName:find(WSpells[i]) then
                                                spelltype = "W"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#ESpells do
                                        if spellName:find(ESpells[i]) then
                                                spelltype = "E"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#RSpells do
                                        if spellName:find(RSpells[i]) then
                                                spelltype = "R"
                                        end
                                end
                        end
                end
                for i=1,#MSpells do
                        if spellName == MSpells[i] then
                                spelltype = spelltype.."M"
                        end
                end
                local spellexists = spelltype ~= "Unknown"
                if #spellslist > 0 and not spellexists then
                        for i=1,#spellslist do
                                if spellName == spellslist[i] then
                                        spellexists = true
                                end
                        end
                end
                if not spellexists then
                        table.insert(spellslist, spellName)
                        --writeConfigsspells()
                       -- PrintChat("Skill Detector - Unknown spell: "..spellName)
                end
        end
        for i=1,#casttype2 do
                if spellName == casttype2[i] then casttype = 2 end
        end
        for i=1,#casttype3 do
                if spellName == casttype3[i] then casttype = 3 end
        end
        for i=1,#casttype4 do
                if spellName == casttype4[i] then casttype = 4 end
        end
        for i=1,#casttype5 do
                if spellName == casttype5[i] then casttype = 5 end
        end
        for i=1,#casttype6 do
                if spellName == casttype6[i] then casttype = 6 end
        end
 
        return spelltype, casttype
end
AddLoadCallback( function()

	ItemNames				= {
		[3303]				= "ArchAngelsDummySpell",
		[3007]				= "ArchAngelsDummySpell",
		[3144]				= "BilgewaterCutlass",
		[3188]				= "ItemBlackfireTorch",
		[3153]				= "ItemSwordOfFeastAndFamine",
		[3405]				= "TrinketSweeperLvl1",
		[3411]				= "TrinketOrbLvl1",
		[3166]				= "TrinketTotemLvl1",
		[3450]				= "OdinTrinketRevive",
		[2041]				= "ItemCrystalFlask",
		[2054]				= "ItemKingPoroSnack",
		[2138]				= "ElixirOfIron",
		[2137]				= "ElixirOfRuin",
		[2139]				= "ElixirOfSorcery",
		[2140]				= "ElixirOfWrath",
		[3184]				= "OdinEntropicClaymore",
		[2050]				= "ItemMiniWard",
		[3401]				= "HealthBomb",
		[3363]				= "TrinketOrbLvl3",
		[3092]				= "ItemGlacialSpikeCast",
		[3460]				= "AscWarp",
		[3361]				= "TrinketTotemLvl3",
		[3362]				= "TrinketTotemLvl4",
		[3159]				= "HextechSweeper",
		[2051]				= "ItemHorn",
		[2003]			    = "RegenerationPotion",
		[3146]				= "HextechGunblade",
		[3187]				= "HextechSweeper",
		[3190]				= "IronStylus",
		[2004]				= "FlaskOfCrystalWater",
		[3139]				= "ItemMercurial",
		[3222]				= "ItemMorellosBane",
		[3042]				= "Muramana",
		[3043]				= "Muramana",
		[3180]				= "OdynsVeil",
		[3056]				= "ItemFaithShaker",
		[2047]				= "OracleExtractSight",
		[3364]				= "TrinketSweeperLvl3",
		[2052]				= "ItemPoroSnack",
		[3140]				= "QuicksilverSash",
		[3143]				= "RanduinsOmen",
		[3074]				= "ItemTiamatCleave",
		[3800]				= "ItemRighteousGlory",
		[2045]				= "ItemGhostWard",
		[3342]				= "TrinketOrbLvl1",
		[3040]				= "ItemSeraphsEmbrace",
		[3048]				= "ItemSeraphsEmbrace",
		[2049]				= "ItemGhostWard",
		[3345]				= "OdinTrinketRevive",
		[2044]				= "SightWard",
		[3341]				= "TrinketSweeperLvl1",
		[3069]				= "shurelyascrest",
		[3599]				= "KalistaPSpellCast",
		[3185]				= "HextechSweeper",
		[3077]				= "ItemTiamatCleave",
		[2009]				= "ItemMiniRegenPotion",
		[2010]				= "ItemMiniRegenPotion",
		[3023]				= "ItemWraithCollar",
		[3290]				= "ItemWraithCollar",
		[2043]				= "VisionWard",
		[3340]				= "TrinketTotemLvl1",
		[3090]				= "ZhonyasHourglass",
		[3154]				= "wrigglelantern",
		[3142]				= "YoumusBlade",
		[3157]				= "ZhonyasHourglass",
		[3512]				= "ItemVoidGate",
		[3131]				= "ItemSoTD",
		[3137]				= "ItemDervishBlade",
		[3352]				= "RelicSpotter",
		[3350]				= "TrinketTotemLvl2",
	}
	
	_G.ITEM_1				= 06
	_G.ITEM_2				= 07
	_G.ITEM_3				= 08
	_G.ITEM_4				= 09
	_G.ITEM_5				= 10
	_G.ITEM_6				= 11
	_G.ITEM_7				= 12
	
	___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
	_G.GetInventorySlotItem	= GetSlotItem
	
	
end)

function GetSlotItem(id, unit)
	
	unit 		= unit or myHero

	if (not ItemNames[id]) then
		return ___GetInventorySlotItem(id, unit)
	end

	local name	= ItemNames[id]
	
	for slot = ITEM_1, ITEM_7 do
		local item = unit:GetSpellData(slot).name
		if ((#item > 0) and (item:lower() == name:lower())) then
			return slot
		end
	end

end
----------------------------------------
