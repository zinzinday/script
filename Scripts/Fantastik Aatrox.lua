if myHero.charName ~= "Aatrox" then return end
--[[


 /$$$$$$$$                   /$$                           /$$     /$$ /$$              /$$$$$$              /$$                                  
| $$_____/                  | $$                          | $$    |__/| $$             /$$__  $$            | $$                                  
| $$    /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$   /$$| $$   /$$      | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$  /$$   /$$
| $$$$$|____  $$| $$__  $$|_  $$_/   |____  $$ /$$_____/|_  $$_/  | $$| $$  /$$/      | $$$$$$$$ |____  $$|_  $$_/   /$$__  $$ /$$__  $$|  $$ /$$/
| $$__/ /$$$$$$$| $$  \ $$  | $$      /$$$$$$$|  $$$$$$   | $$    | $$| $$$$$$/       | $$__  $$  /$$$$$$$  | $$    | $$  \__/| $$  \ $$ \  $$$$/ 
| $$   /$$__  $$| $$  | $$  | $$ /$$ /$$__  $$ \____  $$  | $$ /$$| $$| $$_  $$       | $$  | $$ /$$__  $$  | $$ /$$| $$      | $$  | $$  >$$  $$ 
| $$  |  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$ \  $$      | $$  | $$|  $$$$$$$  |  $$$$/| $$      |  $$$$$$/ /$$/\  $$
|__/   \_______/|__/  |__/   \___/   \_______/|_______/    \___/  |__/|__/  \__/      |__/  |__/ \_______/   \___/  |__/       \______/ |__/  \__/




]]--

require "SxOrbWalk"
require "VPrediction"

local sversion = "0.1"
local sauthor = "Fantastik"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/BoLFantastik/BoL/master/Fantastik Aatrox.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color = \"#FFFFFF\">[Fantastik Aatrox] </font><font color=\"#FF0000\">"..msg.."</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/BoLFantastik/BoL/master/version/Fantastik Aatrox.version")
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

local Q = {range = 650, delay = 0.5, speed = 1800, width = 140,IsReady = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {range = 125, IsReady = function() return myHero:CanUseSpell(_W) == READY end}
local E = {range = 1000, delay = 0.25, speed = 1000, width = 80,IsReady = function() return myHero:CanUseSpell(_E) == READY end}
local R = {range = 300, delay = 0.25, speed = math.huge, width = 100,IsReady = function() return myHero:CanUseSpell(_R) == READY end}
local ignite = nil
local iDmg = 0
local target = nil
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 750, DAMAGE_PHISICAL, true)

local isSX = false
local isSAC = false

local ToInterrupt = {}
local InterruptList = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "FiddleSticks", spellName = "DrainChannel"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Lucian", spellName = "LucianR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},                            
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Shen", spellName = "ShenStandUnited"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Varus", spellName = "VarusQ"},
    { charName = "Warwick", spellName = "InfiniteDuress"},
    { charName = "Velkoz", spellName = "VelkozR"}
}

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
	return ts.target
end

function OnLoad()
	print("<font color = \"#FF0000\">Fantastik Aatrox</font> <font color = \"#fff8e7\">by Fantastik v"..sversion.." loaded.</font>")
	
	ALoadLib()
	IgniteCheck()
end

function OnTick()
	ts:update()
  	target = GetCustomTarget()
	if isSX then
		SxOrb:ForceTarget(target)
	end
	Checks()
	SmartW()
	
	if ValidTarget(target) then
		if AMenu.Extra.KS then KS(target) end
		if AMenu.Extra.Ignite then AutoIgnite(target) end
	end
	
   if AMenu.combokey then
		Combo()
   end
   if AMenu.harasskey then
		Harass()
   end
   if AMenu.farmkey then
		Laneclear()
		Jungleclear()
   end
end

function OnDraw()
	if AMenu.Drawing.LFC then
		if EREADY and not myHero.dead then
			if AMenu.Drawing.DrawE then
				DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
			end
		end
		if QREADY and not myHero.dead then
			if AMenu.Drawing.DrawQ then
				DrawCircle2(myHero.x, myHero.y, myHero.z, Q.range, 0xFF008000)
			end
		end
	else
		if EREADY and not myHero.dead then
			if AMenu.Drawing.DrawE then
				DrawCircle(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
			end
		end
		if QREADY and not myHero.dead then
			if AMenu.Drawing.DrawQ then
				DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, 0xFF008000)
			end
		end
	end
end

function ALoadLib()
	Minions = minionManager(MINION_ENEMY, E.range, myHero, MINION_SORT_MAXHEALTH_DEC)
	JMinions = minionManager(MINION_JUNGLE, E.range, myHero, MINION_SORT_MAXHEALTH_DEC)
	VP = VPrediction(true)
	AMenu()
	
	for i = 1, heroManager.iCount, 1 do
        local enemy = heroManager:getHero(i)
        if enemy.team ~= myHero.team then
            for _, champ in pairs(InterruptList) do
                if enemy.charName == champ.charName then
                    table.insert(ToInterrupt, champ.spellName)
                end
            end
        end
    end
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
			ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
			ignite = SUMMONER_2
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

function Checks()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
  	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end

function AMenu()
	AMenu = scriptConfig("Fantastik Aatrox", "Aatrox")
	AMenu:addParam("combokey", "Combo key(Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	AMenu:addParam("harasskey", "Harass key(C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	AMenu:addParam("farmkey", "Farm key(V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	AMenu:addParam("Version", "Version", SCRIPT_PARAM_INFO, sversion)
	AMenu:addParam("Author", "Author", SCRIPT_PARAM_INFO, sauthor)
	
	AMenu:addTS(ts)
	
	AMenu:addSubMenu("Combo", "Combo")
	AMenu.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	AMenu.Combo:addParam("comboE", "Use E", SCRIPT_PARAM_ONOFF, true)
	AMenu.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
	AMenu.Combo:addParam("minEnemiesR", "Min. no. of enemies for R ", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
	
	AMenu:addSubMenu("Harass", "Harass")
	AMenu.Harass:addParam("harassQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	AMenu.Harass:addParam("harassE", "Use E", SCRIPT_PARAM_ONOFF, true)

	AMenu:addSubMenu("Farm", "Farm")
	AMenu.Farm:addParam("farmQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	AMenu.Farm:addParam("farmE", "Use E", SCRIPT_PARAM_ONOFF, true)
	
	AMenu:addSubMenu("Drawing", "Drawing")
	AMenu.Drawing:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	AMenu.Drawing:addParam("DrawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	AMenu.Drawing:addParam("LFC", "Use Lag-Free circles", SCRIPT_PARAM_ONOFF, true)
	
	AMenu:addSubMenu("Extra", "Extra")
	AMenu.Extra:addParam("KS", "Auto Killsteal", SCRIPT_PARAM_ONOFF, true)
	AMenu.Extra:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	AMenu.Extra:addParam("Int", "Auto Interrupt with Q", SCRIPT_PARAM_ONOFF, true)
	AMenu.Extra:addParam("useW", "Use W switch", SCRIPT_PARAM_ONOFF, true)
	AMenu.Extra:addParam("minHealthW", "Min. % health for W", SCRIPT_PARAM_SLICE, 60, 1, 100, 0)
	
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Fantastik Aatrox] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		AMenu:addParam("SACON","[Aatrox] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Fantastik Aatrox] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		AMenu:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(AMenu.SxOrb)
		isSX = true
	end
	
	AMenu:permaShow("combokey")
	AMenu:permaShow("harasskey")
	AMenu:permaShow("farmkey")
end

function KS(Target)
	if QREADY and getDmg("Q", Target, myHero) > Target.health then
		local CastPos = VP:GetCircularAOECastPosition(Target, Q.delay, Q.width, Q.range, Q.speed, myHero)
		if GetDistance(Target) <= Q.range and QREADY then
			CastSpell(_Q, CastPos.x, CastPos.z)
		end
	end
	if EREADY and getDmg("E", Target, myHero) > Target.health then
		local CastPos = VP:GetLineCastPosition(Target, E.delay, E.width, E.range, E.speed, myHero)
		if GetDistance(Target) <= E.range and EREADY then
			CastSpell(_E, CastPos.x, CastPos.z)
		end
	end
end

function Combo()
	if ValidTarget(target) then
		if QREADY and AMenu.Combo.comboQ then
			local CastPosition, HitChance, CastPos = VP:GetCircularAOECastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero)
			if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and QREADY then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if EREADY and AMenu.Combo.comboE then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero)
			if HitChance >= 2 and GetDistance(CastPosition) <= E.range and EREADY then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
		if RREADY and AMenu.Combo.comboR then
			CastR()
		end
	end
end

function Harass()
	if ValidTarget(target) then
		if QREADY and AMenu.Harass.harassQ then
			local CastPosition, HitChance, CastPos = VP:GetCircularAOECastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero)
			if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and QREADY then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if EREADY and AMenu.Harass.harassE then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero)
			if HitChance >= 2 and GetDistance(CastPosition) <= E.range and EREADY then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function Laneclear()
	Minions:update()
	
	for i, Minion in pairs(Minions.objects) do
		if AMenu.Farm.farmQ and QREADY then
			CastSpell(_Q, Minion.x, Minion.z)
		end
		
		if AMenu.Farm.farmE and EREADY then
			CastSpell(_E, Minion.x, Minion.z)
		end
	end
end

function Jungleclear()
	JMinions:update()
	
	for i, Minion in pairs(JMinions.objects) do
		if AMenu.Farm.farmQ and QREADY then
			CastSpell(_Q, Minion.x, Minion.z)
		end
		
		if AMenu.Farm.farmE and EREADY then
			CastSpell(_E, Minion.x, Minion.z)
		end
	end
end

function CastR()
	if AMenu.Combo.minEnemiesR <= CountEnemyHeroInRange(500) then
		CastSpell(_R)
	end
end

function OnProcessSpell(unit, spell)
    if AMenu.Interrupt and QREADY and #ToInterrupt > 0 then
        for _, ability in pairs(ToInterrupt) do
            if spell.name == ability and unit.team ~= myHero.team then
                if GetDistance(unit) <= Q.range then
                    local CastPosition, HitChance, CastPos = VP:GetCircularAOECastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero, false)
                    if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and QREADY then
                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                    end
                end
            end
         end
    end 
end

function HealthWManager()
	if myHero.health >= myHero.maxHealth * (AMenu.Extra.minHealthW / 100) then
	return true
	else
	return false
	end	 
end

function SmartW()
    if AMenu.Extra.useW then
        if not HealthWManager() and isWOn() then
            CastSpell(_W)    
        end
        if HealthWManager() and not isWOn() then
            CastSpell(_W)    
        end
    end
end
 
function isWOn()
	if myHero:GetSpellData(_W).name == "aatroxw2" then
		return true
    else
		return false
    end
end

-- Barasia, vadash, viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 80)
	end
end
