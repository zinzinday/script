if myHero.charName ~= "Sivir" then return end
--[[
	
/$$$$$$$$                   /$$                           /$$     /$$ /$$              /$$$$$$  /$$            /$$          
| $$_____/                  | $$                          | $$    |__/| $$             /$$__  $$|__/           |__/          
| $$    /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$   /$$| $$   /$$      | $$  \__/ /$$ /$$    /$$ /$$  /$$$$$$ 
| $$$$$|____  $$| $$__  $$|_  $$_/   |____  $$ /$$_____/|_  $$_/  | $$| $$  /$$/      |  $$$$$$ | $$|  $$  /$$/| $$ /$$__  $$
| $$__/ /$$$$$$$| $$  \ $$  | $$      /$$$$$$$|  $$$$$$   | $$    | $$| $$$$$$/        \____  $$| $$ \  $$/$$/ | $$| $$  \__/
| $$   /$$__  $$| $$  | $$  | $$ /$$ /$$__  $$ \____  $$  | $$ /$$| $$| $$_  $$        /$$  \ $$| $$  \  $$$/  | $$| $$      
| $$  |  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$ \  $$      |  $$$$$$/| $$   \  $/   | $$| $$      
|__/   \_______/|__/  |__/   \___/   \_______/|_______/    \___/  |__/|__/  \__/       \______/ |__/    \_/    |__/|__/      



Credits: Fantastik - Scripting the most parts, original creator 
         CrazyDud - Ideas, helping me to create
         QQQ - Also helping, fixing problems and teaching me stuff
		 Honda7 - Common Honda7 stuff
		 Anyone else that I might have forgotten

How to install: Go to Custom Scripts tab and press New Script. Paste the script inside there and click Save Script.
!ATTENTION!: Name it exactly "Fantastik Sivir".

Features:

   Key   |                  What it does
------------------------------------------------------------------------------------
Spacebar | Combo key - Uses Q, W and R. Spell usage can be disabled.
------------------------------------------------------------------------------------
    C    | Poke key - Uses Q to poke the enemy. Can be disabled.
------------------------------------------------------------------------------------
    X    | Last Hit - Last hits the minions with AA.
------------------------------------------------------------------------------------
    C	 | Mixed Mode - Both last hit and poke.
------------------------------------------------------------------------------------
    V    | Lane Clear - Lane clear with AA, Q and W.
------------------------------------------------------------------------------------

Other features:

*	Free users & VIP users support!
*	Slice for minimum amount of enemies for R!
*	Slice for Q range!
*	Slice for mana manager for combo!
*	Smart lane clear using Q!
*	Slice for mana manager for farm!
*	Evadeee integration for E!
*	Auto Ignite in combo and if killable(KS)!
*	Auto Q kill if killable!
*	In-Game skin changer(Sadly VIP only)!
*	Auto level spells!
*	Text Drawing for targets
*	More to come soon!


Changelog:
* v 2.5
 Fixed AA cancel
 Perfected Auto-E usage.

* v 2.25
 Added SxOrb instead of SOW
 Removed level spell for now
 
* v 2.2
 Removed Skin Hack
 Added tracker

* v 2
 Added Auto-E shield

* v 1.1
 Removed BoL Tracker
 Added HitChance for Q Poke
 Added choose Q target

* v 1
 Added Packet casting for VIP users
 Improved hitchance, it shall be working better

* v 0.97
 Fixed Auto Ignite for 4.15
 Now can name the script file however you like

* v 0.96
 Added Mana slider for Poke
 Changed Poke key to C

* v 0.95
 Added SAC and MMA support!
 Fixed Q not casting through minions!

* v 0.94
 Added In-Game announcer!

* v 0.93
 Added BoL Tracker, will check script runs.

* v 0.9
 Added text drawing for targets

* v 0.82 
 Fixed a mistype error.

* v 0.81
 Remade Auto Level Spell function to a better one.

* v 0.8
 Added Manual HitChance settings
 Added use W on Lane Clear
 Fixed a little mistype on Poke

* v 0.65
 Fixed the range of Q which would change instead of only Combo
 Minor improvements

* v 0.6
 Added In-Game skin changer, thanks to shalzuth
 Added Auto spell leveler

* v 0.5
 Added Q for farm, will check for best pos to Q
 Added Q farm mana manager

* v 0.4
 Added AA reset with W

* v 0.3
 Combo Q fix for free users.
 Added reqiured Libs download.

* v 0.2:
 Added Auto Update
 Minor fixes
 Improvements

* v 0.1:
 Release
]]

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("WJMKLIOPPQL") 

--[[		Auto Update		]]
require "SxOrbwalk"
require "VPrediction"

local sversion = "2.5"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BoLFantastik/BoL/master/Fantastik Sivir.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Fantastik Sivir:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/BoLFantastik/BoL/master/version/Fantastik Sivir.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(sversion) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..sversion.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

--[[		Code		]]
local sauthor = "Fantastik"
local QREADY, WREADY, EREADY, RREADY = false
local Qrange, Qwidth, Qspeed, Qdelay = 1075, 85, 1350, 0.250
local Rrange = 1000
local ignite = nil
local iDmg = 0
local target = nil
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, Qrange, DAMAGE_PHYSICAL, true)
local Announcer = ""
local isSX = false
local isSAC = false
local Spells = {_Q,_W,_E,_R}
local Spells2 = {"Q","W","E","R"}

--[[	Drawings	]]
TextList = {"Poke", "1 AA kill!", "2 AA kill!", "3 AA kill!", "Q kill!", "Q + 1 AA kill!", "Q + 2 AA kill!", "Q + 3 AA kill!", "Q + 4 AA kill!"}
KillText = {}
colorText = ARGB(255,255,204,0)

----------------------------------------------

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
	return ts.target
end

function OnLoad()
	PrintChat("<font color=\"#00FF00\">Fantastik Sivir version ["..sversion.."] by Fantastik loaded.</font>")
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Fantastik Sivir] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Sivir] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		isSX = true
	end
	if _G.Evadeee_Loaded then
	PrintChat("<font color=\"##58D3F7\"><b>Evadeee</b> found! You can use Evadeee integration!")
	_G.Evadeee_Enabled = true
	end
  	IgniteCheck()
	SLoadLib()
	Announcer()
end


function OnTick()
  	target = GetCustomTarget()
	if isSX then
		SxOrb:ForceTarget(target)
	end
  	Checks()
	
	if ValidTarget(target) then
		if SivMenu.Extra.KS then KS(target) end
		if SivMenu.Extra.Ignite then AutoIgnite(target) end
	end
	
   if SivMenu.combokey then
		Combo()
   end
   if SivMenu.pokekey then
		Poke()
   end
   if SivMenu.farmkey then
		FarmQ()
		FarmW()
   end
   if SivMenu.Extra.Evade then
       EvadeeeHelper()
   end
end

function Checks()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
  	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	
	Qrangec = SivMenu.Combo.Qrangemin
	
	if SivMenu.Extra.autolev.enabled then
--		AutoLevel()
	end
	calcDmg()
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
			ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
			ignite = SUMMONER_2
	end
end

function OnDraw()
   
   if SivMenu.Drawing.DrawQ then
	 if QREADY then
	 DrawCircle(myHero.x, myHero.y, myHero.z, Qrangec, 0xF7FE2E)
	 end
   end
   
	if SivMenu.Drawing.DrawT then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if ValidTarget(target) and target ~= nil then
				local barPos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 10
				
				DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
			end
		end
	end
end

function SLoadLib()
	EnemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
	VP = VPrediction(true)
	SMenu()
	CurSkin = 0
end

function SMenu()

	SivMenu = scriptConfig("Fantastik Sivir", "Sivir")
	SivMenu:addParam("combokey", "Combo key(Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	SivMenu:addParam("pokekey", "Poke key(C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	SivMenu:addParam("farmkey", "Farm key(V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	SivMenu:addParam("Version", "Version", SCRIPT_PARAM_INFO, sversion)
	SivMenu:addParam("Author", "Author", SCRIPT_PARAM_INFO, sauthor)
	
	SivMenu:addTS(ts)
	
	SivMenu:addSubMenu("Combo", "Combo")
	SivMenu.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Combo:addSubMenu("Use Q on:", "targets")
	for _, enemy in ipairs(GetEnemyHeroes()) do
        SivMenu.Combo.targets:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, true)
    end
	SivMenu.Combo:addParam("Qrangemin", "Min. range for Q ", SCRIPT_PARAM_SLICE, 950, 600, 1075, 0)
	SivMenu.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Combo:addParam("minEnemiesR", "Min. no. of enemies for R ", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
	SivMenu.Combo:addParam("manapls", "Min. % mana for spells ", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	
	SivMenu:addSubMenu("Poke", "Poke")
	SivMenu.Poke:addParam("pokeQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Poke:addParam("manapls", "Min. % mana for spells ", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)

	SivMenu:addSubMenu("Farm", "Farm")
	SivMenu.Farm:addParam("farmQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Farm:addParam("farmW", "Use W", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Farm:addParam("manafarm", "Min. % mana to farm", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	
	SivMenu:addSubMenu("Drawing", "Drawing")
	SivMenu.Drawing:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Drawing:addParam("DrawT", "Draw Text", SCRIPT_PARAM_ONOFF, true)
	if isSX then
		SivMenu:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(SivMenu.SxOrb)
	end
	
	SivMenu:addSubMenu("Extra", "Extra")
	SivMenu.Extra:addParam("KS", "Auto Killsteal", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Extra:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	SivMenu.Extra:addParam("Hitchance", "Hitchance Combo", SCRIPT_PARAM_LIST, 2, {"LOW", "MEDIUM"})
	SivMenu.Extra:addParam("HitchanceP", "Hitchance Poke", SCRIPT_PARAM_LIST, 2, {"LOW", "MEDIUM"})
	SivMenu.Extra:addSubMenu("Auto level spells", "autolev")
	SivMenu.Extra.autolev:addParam("enabled", "Enable auto level spells", SCRIPT_PARAM_ONOFF, false)
	SivMenu.Extra.autolev:addParam("lvlseq", "Select your auto level sequence: ", SCRIPT_PARAM_LIST, 1, {"R>Q>W>E", "R>W>Q>E", "R>E>Q>W"})
	SivMenu.Extra:addSubMenu("Skin Hack - VIP ONLY/Not Working", "skinhax")
	SivMenu.Extra.skinhax:addParam("enabled", "Enable Skin Hack", SCRIPT_PARAM_ONOFF, false)
	SivMenu.Extra.skinhax:addParam("skinid", "Choose skin: ", SCRIPT_PARAM_LIST, 1, {"No Skin", "Warrior Princess", "Spectacular", "Huntress", "Bandit", "PAX", "Snowstorm"})
	if _G.Evadeee_Loaded then
		SivMenu.Extra:addParam("Evade", "Use Evadeee Integration", SCRIPT_PARAM_ONOFF, true)
	end
	SivMenu.Extra:addSubMenu("Auto E settings", "ESet")
	SivMenu.Extra.ESet:addParam("enabled", "Use Auto E", SCRIPT_PARAM_ONOFF, true)
	
	SivMenu:permaShow("combokey")
	SivMenu:permaShow("pokekey")
	SivMenu:permaShow("farmkey")
end

function KS(Target)
	if QREADY and getDmg("Q", Target, myHero) > Target.health then
		local CastPos = VP:GetLineCastPosition(Target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
		if GetDistance(Target) <= Qrange and QREADY then
			CastSpell(_Q, CastPos.x, CastPos.z)
		end
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

function EvadeeeHelper()
	if _G.Evadeee_impossibleToEvade then
		CastSpell(_E)
	end
end

function Combo()
	if ValidTarget(target) and ManaManager() then
		if QREADY and SivMenu.Combo.comboQ and SivMenu.Combo.targets[target.charName] then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Qdelay, Qwidth, Qrangec, Qspeed, myHero, false)
			if HitChance >= SivMenu.Extra.Hitchance and GetDistance(CastPosition) <= Qrangec and QREADY then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if RREADY and SivMenu.Combo.comboR and GetDistance(target) <= 600 then
			CastR()
		end
	end
end

function Poke()
  if ValidTarget(target) and ManaManagerPoke() then
		if SivMenu.Poke.pokeQ and QREADY and SivMenu.Combo.targets[target.charName] then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
			if HitChance >= SivMenu.Extra.HitchanceP and GetDistance(CastPosition) <= Qrange and QREADY then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function GetBestQPositionFarm()
  local MaxQPos
  local MaxQ = 0
  for i, minion in pairs(EnemyMinions.objects) do
    local hitQ = CountMinionsHit(minion)
    if hitQ > MaxQ or MaxQPos == nil then
      MaxQPos = minion
      MaxQ = hitQ
    end
  end

  if MaxQPos then
    return MaxQPos
  else
    return nil
  end
end

function CastQFarm(to)
	CastSpell(_Q, to.x, to.z)
end

function FarmQ()
	if ManaManagerFarm() then
	EnemyMinions:update()
	if SivMenu.Farm.farmQ then
		if QREADY and #EnemyMinions.objects > 3 then
			for i, minion in pairs(EnemyMinions.objects) do
		    if GetDistance(minion) < Qrange then
				local QPos = GetBestQPositionFarm()
				if QPos then
					CastQFarm(QPos)
				end
			end
		end
	end
	end
end
end

function FarmW()
	if ManaManagerFarm() then
	EnemyMinions:update()
	if SivMenu.Farm.farmW then
		if WREADY and #EnemyMinions.objects > 3 then
			for i, minion in pairs(EnemyMinions.objects) do
			if GetDistance(minion) < 500 then
				CastSpell(_W)
			end
		end
	end
	end
end
end

function OnProcessSpell(unit, spell)
	if unit == myHero and spell.name:lower():find("attack") then
		if SivMenu.combokey and WREADY and SivMenu.Combo.comboW and GetDistance(target) <= 600 then
			DelayAction(function() CastSpell(_W) end, spell.windUpTime + GetLatency() / 2000)
		end
	end
	
	if SivMenu.Extra.ESet.enabled and EREADY then
	        local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and _R or _Q
			local isUnit = {
				['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
				['Aatrox']      = {true, spell = _E,                  range = 1000,  projSpeed = 1000, },
				['Ahri']        = {true, spell = _E,                  range = 950,   projSpeed = 1500, },
				['Amumu']       = {true, spell = _Q,                  range = 1100,  projSpeed = 2000, },
				['Amumu']       = {true, spell = _R,                  range = 550,   projSpeed = math.huge, },
				['Anivia']      = {true, spell = _Q,                  range = 1075,  projSpeed = 850, },
				['Annie']       = {true, spell = _Q,                  range = 625,   projSpeed = math.huge, },
				['Annie']       = {true, spell = _W,                  range = 625,   projSpeed = math.huge, },
				['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, }, 
				['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, }, 
				['Ashe']        = {true, spell = _R,                  range = 20000, projSpeed = 1600, },
				['Azir']        = {true, spell = _R,                  range = 500,   projSpeed = 1600, },
				['Blitzcrank']  = {true, spell = _Q,                  range = 925,   projSpeed = 1800, },
				['Brand']       = {true, spell = _R,                  range = 750,   projSpeed = 780, },
				['Braum']       = {true, spell = _R,                  range = 1250,  projSpeed = 1600, },
				['Caitlyn']     = {true, spell = _R,                  range = 3000,  projSpeed = math.huge, },
				['Cassiopeia']  = {true, spell = _R,                  range = 825,   projSpeed = math.huge, },
				['Chogath']     = {true, spell = _Q,                  range = 950,   projSpeed = math.huge, },
				['Corki']       = {true, spell = _Q,                  range = 825,   projSpeed = 1125, },
				['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, }, 
				['Darius']      = {true, spell = _E,                  range = 540,   projSpeed = 1500, },
				['Darius']      = {true, spell = _R,                  range = 480,   projSpeed = math.huge, },
				['Ezrael']      = {true, spell = _R,                  range = 20000, projSpeed = 2000, },
				['Fiora']       = {true, spell = _R,                  range = 400,   projSpeed = math.huge, },
				['Fizz']        = {true, spell = _R,                  range = 1200,  projSpeed = 1200, },
				['Gangplank']   = {true, spell = _Q,                  range = 620,   projSpeed = math.huge, },
				['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
				['Gragas']      = {true, spell = _R,                  range = 800,   projSpeed = 1300, },
				['Graves']      = {true, spell = _R,                  range = 1100,  projSpeed = 2100, },
				['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
				--['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, }, 
				['Irelia']      = {true, spell = _E,                  range = 425,   projSpeed = math.huge, },
				['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, }, 
				['Jax']         = {true, spell = _E,                  range = 250,   projSpeed = math.huge, }, 
				['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, }, 
				['Jinx']        = {true, spell = _R,                  range = 20000, projSpeed = 1700, },
				['Kayle']       = {true, spell = _Q,                  range = 600,   projSpeed = math.huge, },
				['Kennen']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1700, },
				['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
				['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
				['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
				['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
				['Leona']       = {true, spell = _R,                  range = 1100,  projSpeed = math.huge, },
				['Lulu']        = {true, spell = _Q,                  range = 950,   projSpeed = 1600, },
				['Lux']         = {true, spell = _Q,                  range = 1300,  projSpeed = 1200, },
				['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500 + unit.ms},
				['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, }, 
				['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, }, 
				['Morgana']     = {true, spell = _Q,                  range = 1175,  projSpeed = 1200, },
				['Nocturne']    = {true, spell = _R,                  range = 2000,  projSpeed = 500, },
				['Orianna']     = {true, spell = _Q,                  range = 825,   projSpeed = 1200, },
				['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, }, 
				['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, }, 
				['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
				['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
				['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
				['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
				['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
				['Twistedfate'] = {true, spell = _W,                  range = 525,   projSpeed = math.huge, },
				['Vayne']       = {true, spell = _E,                  range = 550,   projSpeed = math.huge, },
				['Veigar']      = {true, spell = _R,                  range = 700,   projSpeed = math.huge, },
				['Vi']          = {true, spell = _R,                  range = 600,   projSpeed = 1200, },
				['Xerath']      = {true, spell = _E,                  range = 1000,  projSpeed = 1200, },
				['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, }, 
				['Zyra']        = {true, spell = _E,                  range = 1175,  projSpeed = 1400, },
			}
			if unit.type == myHero.type and unit.team ~= myHero.team and isUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then
				if spell.name == (type(isUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isUnit[unit.charName].spell).name or isUnit[unit.charName].spell) then
					if spell.target ~= nil and spell.target.isMe or isUnit[unit.charName].spell == 'blindmonkqtwo' then
						if EREADY then
							E.target = unit
							CastSpell(_E)
						end
					else
						spellExpired = false
						informationTable = {
							spellSource = unit,
							spellCastedTick = GetTickCount(),
							spellStartPos = Point(spell.startPos.x, spell.startPos.z),
							spellEndPos = Point(spell.endPos.x, spell.endPos.z),
							spellRange = isUnit[unit.charName].range,
							spellSpeed = isUnit[unit.charName].projSpeed
						}
					end
				end
			end
		
    end
	
end

function ManaManagerFarm()
	if myHero.mana >= myHero.maxMana * (SivMenu.Farm.manafarm / 100) then
	return true
	else
	return false
	end	 
end

function ManaManager()
	if myHero.mana >= myHero.maxMana * (SivMenu.Combo.manapls / 100) then
	return true
	else
	return false
	end	 
end

function ManaManagerPoke()
	if myHero.mana >= myHero.maxMana * (SivMenu.Poke.manapls / 100) then
	return true
	else
	return false
	end	 
end

function CastR()
	if SivMenu.Combo.minEnemiesR <= CountEnemyHeroInRange(600) then
		CastSpell(_R)
	end
end

function CountMinionsHit(QPos)
  local LineEnd = Vector(myHero) + Qrange * (Vector(QPos) - Vector(myHero)):normalized()
  local n = 0
  for i, minion in pairs(EnemyMinions.objects) do
    local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(myHero), LineEnd, minion)
    if isOnSegment and GetDistance(minion, pointSegment) <= 85*1.25 then
      n = n + 1
    end
  end
  return n
end

function AutoLevel()
		if SivMenu.Extra.autolev.lvlseq == 1 then seq = {1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3}
		elseif SivMenu.Extra.autolev.lvlseq == 2 then seq = {2, 1, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3}
		elseif SivMenu.Extra.autolev.lvlseq == 3 then seq = {3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2,}
		end
		autoLevelSetSequence(seq)
end

function SkinHack()
	if SivMenu.Extra.skinhax.enabled and CurSkin ~= SivMenu.Extra.skinhax.skinid then
		local SkinIdSwap = { [1] = 7, [2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5, [7] = 6 }
		CurSkin = SivMenu.Extra.skinhax.skinid
		SkinChanger(myHero.charName, SkinIdSwap[CurSkin])
	end
end

function SkinChanger(champ, skinId) -- Credits to shalzuth
    p = CLoLPacket(0x97)
    p:EncodeF(myHero.networkID)
    p.pos = 1
    t1 = p:Decode1()
    t2 = p:Decode1()
    t3 = p:Decode1()
    t4 = p:Decode1()
    p:Encode1(t1)
    p:Encode1(t2)
    p:Encode1(t3)
    p:Encode1(bit32.band(t4,0xB))
    p:Encode1(1)
    p:Encode4(skinId)
    for i = 1, #champ do
        p:Encode1(string.byte(champ:sub(i,i)))
    end
    for i = #champ + 1, 64 do
        p:Encode1(0)
    end
    p:Hide()
    RecvPacket(p)
end

function calcDmg()
	for i=1, heroManager.iCount do
		local target = heroManager:GetHero(i)
		if ValidTarget(target) and target ~= nil then
			qDmg = ((QREADY and getDmg("Q", target, myHero)) or 0)
			aDmg = ((getDmg("AD", target, myHero)) or 0)
			aDmg2 = (aDmg * 2)
			aDmg3 = (aDmg * 3)
			aDmg4 = (aDmg * 4)
			
			if target.health > (qDmg + aDmg4) then
				KillText[i] = 1
			elseif target.health <= aDmg then
				KillText[i] = 2
			elseif target.health <= aDmg2 then
				KillText[i] = 3
			elseif target.health <= aDmg3 then
				KillText[i] = 4	
			elseif target.health <= qDmg then
				KillText[i] = 5
			elseif target.health <= (qDmg + aDmg) then
				KillText[i] = 6
			elseif target.health <= (qDmg + aDmg2) then
				KillText[i] = 7
			elseif target.health <= (qDmg + aDmg3) then
				KillText[i] = 8
			elseif target.health <= (qDmg + aDmg4) then
				KillText[i] = 9	
			end
		end
	end	
end

--[[	Announcer	]]
function AnnouncerMsg(msg) print("<font color=\"#6699ff\"><b>Fantastik Sivir Announce:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>") end
function Announcer()
	local Announce
	local AnnouncerData = GetWebResult(UPDATE_HOST, "/BoLFantastik/BoL/master/Announcer/Fantastik Sivir")
	if AnnouncerData then
		Announcer = AnnouncerData or nil
		if Announcer then
			AnnouncerMsg(""..Announcer.."")
		end
	end
end
