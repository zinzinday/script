if myHero.charName ~= "Syndra" then return end
--[[

 /$$$$$$$$                   /$$                           /$$     /$$ /$$              /$$$$$$                            /$$                   
| $$_____/                  | $$                          | $$    |__/| $$             /$$__  $$                          | $$                   
| $$    /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$   /$$| $$   /$$      | $$  \__/ /$$   /$$ /$$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$ 
| $$$$$|____  $$| $$__  $$|_  $$_/   |____  $$ /$$_____/|_  $$_/  | $$| $$  /$$/      |  $$$$$$ | $$  | $$| $$__  $$ /$$__  $$ /$$__  $$|____  $$
| $$__/ /$$$$$$$| $$  \ $$  | $$      /$$$$$$$|  $$$$$$   | $$    | $$| $$$$$$/        \____  $$| $$  | $$| $$  \ $$| $$  | $$| $$  \__/ /$$$$$$$
| $$   /$$__  $$| $$  | $$  | $$ /$$ /$$__  $$ \____  $$  | $$ /$$| $$| $$_  $$        /$$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$      /$$__  $$
| $$  |  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$ \  $$      |  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$| $$     |  $$$$$$$
|__/   \_______/|__/  |__/   \___/   \_______/|_______/    \___/  |__/|__/  \__/       \______/  \____  $$|__/  |__/ \_______/|__/      \_______/
                                                                                                 /$$  | $$                                       
                                                                                                |  $$$$$$/                                       
                                                                                                 \______/                                        

Thanks to: Sania and anyone who helped him - For making this script and letting me continue it after his retirement.
		   Fantastik AKA me - For not letting this awesome script to die.
		   
If you've got more ideas, or want to report bugs and glitches, post on the topic.

Changelog:
* v 0.7
 Fixed the script to what it was!

* v 0.6
 Free User support!
 Tracker
 Minor stuff

* v 0.5
 Fixed W for new patch
 Perfected W more

* v 0.4
 A bit faster Combo
 Fixed W prediction
 Fixed W on Combo - Wish so this time

* v 0.3
 Improved Farm function
 Added Zhonya's support
 Offensive item support

* v 0.2
 Fixed W on Combo - NOPE

* v 0.1
 Fixed Farm function for the new map.

]]--

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILJKJNJOHH") 

local version = 0.7
local AUTOUPDATE = true
local SCRIPT_NAME = "Fantastik Syndra"
local ForceUseSimpleTS = false

local Recieved = 0
local RecvCounter = 0

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local SOURCELIB_URL = "https://raw.githubusercontent.com/Dienofail/BoL/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"

if FileExist(SOURCELIB_PATH) then
	require("SourceLib")
else
	DOWNLOADING_SOURCELIB = true
	DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end

if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end

if AUTOUPDATE then
	 SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/BoLFantastik/BoL/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/BoLFantastik/BoL/master/version/"..SCRIPT_NAME..".version"):CheckUpdate()
end

local RequireI = Require("SourceLib")
if VIP_USER then RequireI:Add("Prodiction", "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/7f8427d943e993667acd4a51a39cf9aa2b71f222/Test/Prodiction/Prodiction.lua") end
RequireI:Add("vPrediction", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireI:Add("SxOrbWalk", "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua")
RequireI:Check()

if RequireI.downloadNeeded == true then return end
local Q = {range = 790, rangeSqr = math.pow(790, 2), width = 125, delay = 0.6, speed = math.huge, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {range = 925, rangeSqr = math.pow(925, 2), width = 190, delay = 0.8, speed = math.huge, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_W) == READY end, status = 0}
local E = {range = 700, rangeSqr = math.pow(700, 2), width = 45 * 0.5, delay = 0.25, speed = 2500, LastCastTime = 0, IsReady = function() return myHero:CanUseSpell(_E) == READY end}
local R = {range = 725, rangeSqr = math.pow(725, 2), delay = 0.25, IsReady = function() return myHero:CanUseSpell(_R) == READY end}
local QE = {range = 1280, rangeSqr = math.pow(1280, 2), width = 60, delay = 0, speed = 1600}

local pets = {"annietibbers", "shacobox", "malzaharvoidling", "heimertyellow", "heimertblue", "yorickdecayedghoul"}

local Balls = {}
local BallDuration = 6.9

local QECombo = 0

local DontUseRTime = 0
local UseRTime = 0

_SpellIGNITE  = GetSummonerSlot("summonerdot")
local MainCombo = {_W, _E, _R, _R, _R, _SpellIGNITE}

local Spots = 
{
			["BlueBlue"] = { ["x"] = 3982, ["y"] = 51.13, ["z"] = 7416 },
			["PurpleBlue"] = { ["x"] = 10852, ["y"] = 52.1, ["z"] = 7554 },
}

function OnLoad()
	
	VP = VPrediction()
	DLib = DamageLib()
	DManager = DrawManager()

	DLib:RegisterDamageSource(_SpellIGNITE, _TRUE, 0, 0, _TRUE, _AP, 0, function() return _SpellIGNITE and (player:CanUseSpell(_SpellIGNITE) == READY) end, function() return (50 + 20 * player.level) end)
	DLib:RegisterDamageSource(_AQ, _MAGIC, 30, 40, _MAGIC, _AP, 0.60, function() return true end)--Without the 15% increase at rank 5
	DLib:RegisterDamageSource(_Q, _MAGIC, 30, 40, _MAGIC, _AP, 0.60, function() return (player:CanUseSpell(_Q) == READY) end)--Without the 15% increase at rank 5
	DLib:RegisterDamageSource(_LV5Q, _MAGIC, 264.5, 0, _MAGIC, _AP, 0.69, function() return (player:CanUseSpell(_Q) == READY) end)--With the 15% increase at rank 5
	DLib:RegisterDamageSource(_W, _MAGIC, 40, 40, _MAGIC, _AP, 0.70, function() return (player:CanUseSpell(_W) == READY) end)
	DLib:RegisterDamageSource(_E, _MAGIC, 25, 45, _MAGIC, _AP, 0.4, function() return (player:CanUseSpell(_E) == READY) end)
	DLib:RegisterDamageSource(_R, _MAGIC, 45, 45, _MAGIC, _AP, 0.2, function() return (player:CanUseSpell(_R) == READY) end)--1 sphere

	PrintChat("<font color=\"#00FF00\">Fantastik Syndra - Continuation of PentaKill Syndra by Fantastik loaded!</font>")
	PrintChat("<font color=\"#00FF00\">Thanks to Sania for his awesome script!</font>")
	
	Menu = scriptConfig("Fantastik Syndra", "Fantastik Syndra")

	Menu:addSubMenu("Orbwalking", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)

	Menu:addSubMenu("Choose Target Selector", "SelectTS")
		Menu.SelectTS:addParam("TS", "Select TS (Require reload)", SCRIPT_PARAM_LIST, 1, {"Use SimpleTS"})

	if (Menu.SelectTS.TS == 1) or ForceUseSimpleTS then
		STS = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
		Menu:addSubMenu("Set Target Selector Priority", "STS")
		STS:AddToMenu(Menu.STS)
	else
		Selector.Instance() 
	end


         
         Menu:addSubMenu("Choose HitChance", "HitChance")
         Menu.HitChance:addParam("HitChance", "HitChance", SCRIPT_PARAM_LIST, 1, { "LOW", "NORMAL"})

         Menu:addSubMenu("Choose Prediction Type", "PredictionType")
         Menu.PredictionType:addParam("PredictionType", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "Vprediction", "Prodiction"})

	Menu:addSubMenu("Combo", "Combo")
		Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseEQ", "Use QE", SCRIPT_PARAM_ONOFF, false)
		Menu.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("AntiOverKill", "Don't use R if enemy is killable with Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("Enabled", "Use Combo!", SCRIPT_PARAM_ONKEYDOWN, false, 32)

	Menu:addSubMenu("Harass", "Harass")
		Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, false)
		Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
		Menu.Harass:addParam("UseEQ", "Use QE", SCRIPT_PARAM_ONOFF, false)
		Menu.Harass:addParam("AAHarass", "Auto harass when enemy do AA", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("ManaCheck", "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
		Menu.Harass:addParam("Enabled", "Harass!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Menu.Harass:addParam("Enabled2", "Harass (toggle)!", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))

	Menu:addSubMenu("Farm", "Farm")
		Menu.Farm:addParam("UseQ",  "Use Q", SCRIPT_PARAM_LIST, 3, { "No", "Freeze", "LaneClear", "Both" })
		Menu.Farm:addParam("UseW",  "Use W", SCRIPT_PARAM_LIST, 3, { "No", "Freeze", "LaneClear", "Both" })
		Menu.Farm:addParam("UseE",  "Use E", SCRIPT_PARAM_LIST, 1, { "No", "Freeze", "LaneClear", "Both" })
		Menu.Farm:addParam("ManaCheck2", "Don't farm if mana < % (freeze)", SCRIPT_PARAM_SLICE, 0, 0, 100)
		Menu.Farm:addParam("ManaCheck", "Don't farm if mana < % (laneclear)", SCRIPT_PARAM_SLICE, 0, 0, 100)
		Menu.Farm:addParam("Freeze", "Farm freezing", SCRIPT_PARAM_ONKEYDOWN, false,   string.byte("C"))
		Menu.Farm:addParam("LaneClear", "Farm LaneClear", SCRIPT_PARAM_ONKEYDOWN, false,   string.byte("V"))

	Menu:addSubMenu("JungleFarm", "JungleFarm")
		Menu.JungleFarm:addParam("UseQ",  "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.JungleFarm:addParam("UseW",  "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.JungleFarm:addParam("UseE",  "Use E", SCRIPT_PARAM_ONOFF, false)
		Menu.JungleFarm:addParam("Enabled", "Farm!", SCRIPT_PARAM_ONKEYDOWN, false,   string.byte("V"))

	Menu:addSubMenu("QE combo settings", "EQ")
		Menu.EQ:addParam("Range", "Place Q at range:", SCRIPT_PARAM_SLICE, E.range, 0, E.range)

	Menu:addSubMenu("Ultimate", "R")
		Menu.R:addSubMenu("Don't use R on", "Targets")
		for i, enemy in ipairs(GetEnemyHeroes()) do
			Menu.R.Targets:addParam(enemy.hash,  enemy.charName, SCRIPT_PARAM_ONOFF, false)
		end
		Menu.R:addParam("CastR", "Force ultimate cast", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))
		Menu.R:addParam("DontUseR", "Don't use R in the next 10 seconds", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))

	Menu:addSubMenu("Misc", "Misc")
		Menu.Misc:addParam("WPet",  "Auto grab pets using W", SCRIPT_PARAM_ONOFF, true)

		Menu.Misc:addSubMenu("Auto-Interrupt", "Interrupt")
			Interrupter(Menu.Misc.Interrupt, OnInterruptSpell)

		Menu.Misc:addSubMenu("Anti-Gapclosers", "AG")
			AntiGapcloser(Menu.Misc.AG, OnGapclose)

		Menu.Misc:addParam("MEQ", "Manual Q+E Combo", SCRIPT_PARAM_ONKEYDOWN, false,   string.byte("T"))
		
		Menu.Misc:addSubMenu("Zhonya's settings", "Zhonya")
			Menu.Misc.Zhonya:addParam("enabled", "Use Auto Zhonya's", SCRIPT_PARAM_ONOFF, true)
			Menu.Misc.Zhonya:addParam("zhonyapls", "Min. % health for Zhonya's", SCRIPT_PARAM_SLICE, 15, 1, 50, 0)
			
		Menu.Misc:addSubMenu("Jungle Stealer", "JungleSteal")
			Menu.Misc.JungleSteal:addParam("enabled", "Use Jungle Stealer", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("N"))
			Menu.Misc.JungleSteal:addParam("JSdraw", "Draw Jungle Steal circles", SCRIPT_PARAM_ONOFF, true)

	Menu:addSubMenu("Drawings", "Drawings")
		DManager:CreateCircle(myHero, Q.range, 1, {255, 255, 255, 255}):AddToMenu(Menu.Drawings, SpellToString(_Q).." Range", true, true, true)
		DManager:CreateCircle(myHero, W.range, 1, {255, 255, 255, 255}):AddToMenu(Menu.Drawings, SpellToString(_W).." Range", true, true, true)
		DManager:CreateCircle(myHero, E.range, 1, {255, 255, 255, 255}):AddToMenu(Menu.Drawings, SpellToString(_E).." Range", true, true, true)
		DManager:CreateCircle(myHero, R.range, 1, {255, 255, 255, 255}):AddToMenu(Menu.Drawings, SpellToString(_R).." Range", true, true, true)
		DManager:CreateCircle(myHero, QE.range, 1, {255, 255, 255, 255}):AddToMenu(Menu.Drawings, "Q+E Range", true, true, true)
		
	Menu:addSubMenu("Debug", "debug")
		Menu.debug:addSubMenu("Q", "Qdebug")
			Menu.debug.Qdebug:addParam("QCastPrint", "Q Cast Print", SCRIPT_PARAM_ONOFF, false)
			
		Menu.debug:addSubMenu("W", "Wdebug")
			Menu.debug.Wdebug:addParam("WCastPrint", "W Cast Print", SCRIPT_PARAM_ONOFF, false)
			
		Menu.debug:addSubMenu("E", "Edebug")
			Menu.debug.Edebug:addParam("ECastPrint", "E Cast Print", SCRIPT_PARAM_ONOFF, false)
			
		Menu.debug:addSubMenu("R", "Rdebug")
			Menu.debug.Rdebug:addParam("RCastPrint", "R Cast Print", SCRIPT_PARAM_ONOFF, false)
			
		
	--[[Predicted damage on healthbars]]
	DLib:AddToMenu(Menu.Drawings, MainCombo)

	EnemyMinions = minionManager(MINION_ENEMY, W.range, myHero, MINION_SORT_MAXHEALTH_DEC)
	JungleMinions = minionManager(MINION_JUNGLE, QE.range, myHero, MINION_SORT_MAXHEALTH_DEC)
	PosiblePets = minionManager(MINION_OTHER, W.range, myHero, MINION_SORT_MAXHEALTH_DEC)
end

--Change the combo table depending on the situation.
function GetCombo(target)
	if target ~= nil then
		local result = {}
		for i, spell in ipairs(MainCombo) do
			--if (spell == ItemManager:GetItem("DFG"):GetId()) and GetDistanceSqr(target.visionPos, myHero) < math.pow(650, 2) then 
			--	table.insert(result, spell)
			if (spell == _SpellIGNITE) and GetDistanceSqr(target.visionPos, myHero) < math.pow(600, 2) then
				table.insert(result, spell)
			else
				table.insert(result, spell)
			end
		end
		if myHero:GetSpellData(_Q).level == 5 then
			table.insert(result, _LV5Q)
		else
			table.insert(result, _Q)
		end
		for i = 1, #GetValidBalls() do
			table.insert(result, _R)
		end
		return result		
	else
		local result = {}
		for i, spell in ipairs(MainCombo) do
			table.insert(result, spell)
		end
		if myHero:GetSpellData(_Q).level == 5 then
			table.insert(result, _LV5Q)
		else
			table.insert(result, _Q)
		end
		for i = 1, #GetValidBalls() do
			table.insert(result, _R)
		end
		return result
	end
end


function GetUltCombo()
	local result = {}
	for i = 1, #GetValidBalls() do
		table.insert(result, _R)
	end
	return result
end

-- Track the balls


function OnProcessSpell(unit, spell)
	if unit.isMe then
		if spell.name == "SyndraQ" then
			Q.LastCastTime = os.clock()
			OnCastQ(spell)
		elseif spell.name == "SyndraE" then	
			E.LastCastTime = os.clock()
		elseif spell.name == "SyndraW" then
			W.LastCastTime = os.clock()
            Recieved = 0
			RecvCounter = 0
		elseif spell.name == "syndrawcast" then
			Recieved = 1
		elseif spell.name == "syndrae5" then
			E.LastCastTime = os.clock()
		end
	end
	if (Menu.Harass.AAHarass) and (unit.team ~= myHero.team) and (GetDistance(myHero, unit) <= Q.range) then
		if unit.type == myHero.type and unit ~= nil then
			if spell.name:lower():find("attack") then
				Harass(unit)
			end
		end
	end
end

--Track the balls :p
function GetValidBalls(ForE)
	if (ForE == nil) or (ForE == false) then
		local result = {}
		for i, ball in ipairs(Balls) do
			if (ball.added or ball.startT <= os.clock()) and Balls[i].endT >= os.clock() and ball.object.valid then
				if not WObject or ball.object.networkID ~= WObject.networkID then
					table.insert(result, ball)
				end
			end
		end
		return result
	else
		local result = {}
		for i, ball in ipairs(Balls) do
			if (ball.added or ball.startT <= os.clock() + (E.delay + GetDistance(myHero, ball.object) / E.speed)) and Balls[i].endT >= os.clock() + (E.delay + GetDistance(myHero, ball.object) / E.speed) and ball.object.valid then
				if not WObject or ball.object.networkID ~= WObject.networkID then
					table.insert(result, ball)
				end
			end
		end
		return result
	end
end

function AddBall(obj)
	for i = #Balls, 1, -1 do
		if not Balls[i].added and GetDistanceSqr(Balls[i].object, obj) < 50*50 then
			Balls[i].added = true
			Balls[i].object = obj
			do return end
		end
	end

	--R balls
	local BallInfo = {
							 added = true, 
							 object = obj,
							 startT = os.clock(),
							 endT = os.clock() + BallDuration - GetLatency()/2000
					}
	table.insert(Balls, BallInfo)						
end

function OnCreateObj(obj)
	if obj and obj.valid then
		if GetDistanceSqr(obj) < Q.rangeSqr * 2 then
			if obj.name:find("Seed") then
				DelayAction(AddBall, 0, {obj})
			end
		end
	end
end

function OnDeleteObj(obj)
	if obj.name:find("Syndra_") and (obj.name:find("_Q_idle.troy") or obj.name:find("_Q_Lv5_idle.troy")) then
		for i = #Balls, 1, -1 do
			if Balls[i].object and Balls[i].object.valid and GetDistanceSqr(Balls[i].object, obj) < 50 * 50 then
				table.remove(Balls, i)
				break
			end
		end
	end
end

--Remove the non-active balls to save memory
function BTOnTick()
	for i = #Balls, 1, -1 do
		if Balls[i].endT <= os.clock() then
			table.remove(Balls, i)
		end
	end
end

function BTOnDraw()--For testings
	local activeballs = GetValidBalls()
	for i, ball in ipairs(activeballs) do
		DrawCircle(ball.object.x, myHero.y, ball.object.z, 100, ARGB(255,255,255,255))
	end
end

function IsPet(name) 
	return table.contains(pets, name:lower())
end

function IsPetDangerous(name)
	return (name:lower() == "annietibbers") or (name:lower() == "heimertblue")
end

function AutoGrabPets()
	if W.IsReady() and W.status == 0 then
		local pet = GetPet(true)
		if pet then
			CastSpell(_W, pet.x, pet.z)
			if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked up pet with W") end
		end
	end
end

function GetPet(dangerous)
	PosiblePets:update()
	--Priorize Enemy Pet's
	for i, object in ipairs(PosiblePets.objects) do
		if object and object.valid and object.team ~= myHero.team and IsPet(object.charName) and (not dangerous or IsPetDangerous(object.charName)) then
			return object
		end
	end
end

function GetWValidBall(OnlyBalls)
	local all = GetValidBalls()
	local inrange = {}

	local Pet = GetPet(true)
	if Pet then
		return {object = Pet}
	end

	--Get the balls in W range
	for i, ball in ipairs(all) do
		if GetDistanceSqr(ball.object, myHero) <= W.rangeSqr then
			table.insert(inrange, ball)
		end
	end

	local minEnd = math.huge
	local minBall

	--Get the ball that will expire earlier
	for i, ball in ipairs(inrange) do
		if ball.endT < minEnd then
			minBall = ball
			minEnd = ball.endT
		end
	end

	if minBall then
		return minBall
	end
	if OnlyBalls then 
		return 
	end

	Pet = GetPet()
	if Pet then
		return {object = Pet}
	end

	EnemyMinions:update()
	JungleMinions:update()
	PosiblePets:update()
	local t = MergeTables(MergeTables(EnemyMinions.objects, JungleMinions.objects), PosiblePets.objects)
	SelectUnits(t, function(t) return ValidTarget(t) and GetDistanceSqr(myHero, t) < W.rangeSqr end)
	if t[1] then
		return {object = t[1]}
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function OnInterruptSpell(unit, spell)
	if GetDistanceSqr(unit.visionPos, myHero) < E.rangeSqr and E.IsReady() then
		
		if Q.IsReady() then
			StartEQCombo(unit)
		else
			CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
			if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E to Interrupt") end
		end

	elseif GetDistanceSqr(unit.visionPos,  myHero) < QE.rangeSqr and Q.IsReady() and E.IsReady() then
		StartEQCombo(unit)
	end 
end

function OnGapclose(unit, data)
	if GetDistanceSqr(unit.visionPos, myHero) < E.rangeSqr and E.IsReady() then
		
		if Q.IsReady() then
			Qdistance = 300
			StartEQCombo(unit)
		else
			CastSpell(_E, unit.visionPos.x, unit.visionPos.z)
			if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on Gapcloser") end
		end

	elseif GetDistanceSqr(unit.visionPos,  myHero) < QE.rangeSqr and Q.IsReady() and E.IsReady() then
		StartEQCombo(unit)
	end 
end

--[[function OnRecvPacket(p)
	if p.header == 0x00D7 and W.IsReady() then
		RecvCounter = RecvCounter + 1
		p.pos = 13
		local NetworkID = p:DecodeF()
		if RecvCounter == 1 then
			local Active = p:Decode1()

			if NetworkID then
--				print("NetworkID")
				if not WObject then
--					print("Not WObject")
					for i, ball in ipairs(Balls) do
--						print("find balls")
						if ball.networkID == NetworkID then
							print("ball networkID == NetworkID")
							Balls[i].endT = os.clock() + BallDuration - GetLatency()/2000
						end
					end
				end
--				print("objManager:GetObjectByNetworkId")
--				WObject = objManager:GetObjectByNetworkId(NetworkID)
				Recieved = 1
			else
				WObject = nil
				Recieved = 0
			end
		end
		WObject = objManager:GetObjectByNetworkId(NetworkID)
	end
end]]

function OnCastQ(spell)
	local BallInfo = {
						added = false, 
						object = {valid = true, x = spell.endPos.x, y = myHero.y, z = spell.endPos.z},
						startT = os.clock() + Q.delay - GetLatency()/2000,
						endT = os.clock() + BallDuration + Q.delay - GetLatency()/2000
					 }
	if (os.clock() - QECombo < 1.5) or (Menu.Combo.Enabled and (Menu.Combo.UseE or Menu.Combo.UseEQ)) or (Menu.Harass.Enabled and (Menu.Harass.UseE or Menu.Harass.UseEQ)) then
		local Delay = Q.delay - (E.delay + GetDistance(myHero, BallInfo.object) / E.speed)
		DelayAction(function(t) CastQE2(t) end, Delay, {BallInfo})
	else
		Qdistance = nil
		EQTarget = nil
		EQCombo = 0
	end
	table.insert(Balls, BallInfo)
end

function CastQE2(BallInfo)
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			if GetDistanceSqr(BallInfo.object, myHero) < E.rangeSqr then

				local enemyPos, info, hitchance

				if Menu.PredictionType.PredictionType == 1 then
					enemyPos, hitchance = VP:GetLineCastPosition(enemy, (E.delay + (GetDistance(myHero, BallInfo.object) / E.speed) - (GetDistance(myHero, BallInfo.object) / QE.speed)), QE.width, QE.range, QE.speed)
				else
					enemyPos, info = Prodiction.GetPrediction(enemy, QE.range, QE.speed, (E.delay + (GetDistance(myHero, BallInfo.object) / E.speed) - (GetDistance(myHero, BallInfo.object) / QE.speed)), QE.width)
					hitchance = info.hitchance
				end

				if hitchance >= Menu.HitChance.HitChance and enemyPos and enemyPos.z then		
					local EP = Vector(BallInfo.object) +  (100+(-0.6 * GetDistance(BallInfo.object, myHero) + 966)) * (Vector(BallInfo.object) - Vector(myHero)):normalized()
					local SP = Vector(BallInfo.object) - 100 * (Vector(BallInfo.object) - Vector(myHero)):normalized()
					local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(SP, EP, enemyPos)
					if isOnSegment and GetDistanceSqr(pointLine, enemyPos) <= (QE.width + VP:GetHitBox(enemy))^2 then
						if (E.delay + GetDistance(myHero, BallInfo.object) / E.speed) >= (BallInfo.startT - os.clock()) then
							CastSpell(_E, BallInfo.object.x, BallInfo.object.z)
							if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on ball") end
						else
							DelayAction(function(t) CastQE3(t) end, BallInfo.startT - os.clock() - (E.delay + GetDistance(myHero, BallInfo.object) / E.speed), {BallInfo})	
						end				
					end
				end
			end
		end
	end
end


function CastQE3(BallInfo)
	if (E.delay + GetDistance(myHero, BallInfo.object) / E.speed) >= (BallInfo.startT - os.clock()) then
		if GetDistanceSqr(BallInfo.object, myHero) < E.rangeSqr then
			CastSpell(_E, BallInfo.object.x, BallInfo.object.z)
			if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on ball") end
		end
	else
		DelayAction(function(t) CastQE3(t) end, BallInfo.startT - os.clock() - (E.delay + GetDistance(myHero, BallInfo.object) / E.speed), {BallInfo})	
	end				
end


function StartEQCombo(unit)
	QECombo = os.clock()
	Cast2Q(unit)
end

function Cast2Q(target)
	if not Q.IsReady() then return end
	if GetDistanceSqr(target) > Q.rangeSqr then

		local QEtargetPos, info, hitchance
		if Menu.PredictionType.PredictionType == 1 then
			QEtargetPos, hitchance = VP:GetLineCastPosition(target, 0.6 - (Menu.EQ.Range / QE.speed), QE.width, QE.range, QE.speed)
		else
			QEtargetPos, info = Prodiction.GetPrediction(target, QE.range, QE.speed, 0.6 - (Menu.EQ.Range / QE.speed), QE.width)
			hitchance = info.hitchance
		end

		
		if hitchance >= Menu.HitChance.HitChance and QEtargetPos and QEtargetPos.z then 
			local pos = Vector(myHero) + Menu.EQ.Range * (Vector(QEtargetPos) - Vector(myHero)):normalized()
			CastSpell(_Q, pos.x, pos.z)
			if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on target") end
		end
	else
		if Qdistance then

			local QEtargetPos, info, hitchance
			if Menu.PredictionType.PredictionType == 1 then
				QEtargetPos, hitchance = VP:GetLineCastPosition(target, 0.6 - (Qdistance / QE.speed), QE.width, QE.range, QE.speed)
			else
				QEtargetPos, info = Prodiction.GetPrediction(target, QE.range, QE.speed, 0.6 - (Qdistance / QE.speed), QE.width)
				hitchance = info.hitchance
			end

			if hitchance >= Menu.HitChance.HitChance and QEtargetPos and QEtargetPos.z then 
				local pos = Vector(myHero) + Qdistance * (Vector(QEtargetPos) - Vector(myHero)):normalized()
				CastSpell(_Q, pos.x, pos.z)
				if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on target") end
			end
		else

			local QEtargetPos, info, hitchance
			if Menu.PredictionType.PredictionType == 1 then
				QEtargetPos, hitchance = VP:GetCircularCastPosition(target, Q.delay, Q.width, Q.range, math.huge)
			else
				QEtargetPos, info = Prodiction.GetPrediction(target, Q.delay)
				hitchance = info.hitchance
			end


			if hitchance >= Menu.HitChance.HitChance and QEtargetPos and QEtargetPos.z then
				if GetDistanceSqr(QEtargetPos) > Q.rangeSqr then

					local pos, info, hitchance
					if Menu.PredictionType.PredictionType == 1 then
						pos, hitchance = VP:GetLineCastPosition(target, 0.6 - (Menu.EQ.Range / QE.speed), QE.width, QE.range, QE.speed)
					else
						pos, info = Prodiction.GetPrediction(target, QE.range, QE.speed, 0.6 - (Menu.EQ.Range / QE.speed), QE.width)
						hitchance = info.hitchance
					end
					if hitchance >= Menu.HitChance.HitChance and pos and pos.z then
						local posB = Vector(myHero) + Menu.EQ.Range * (Vector(QEtargetPos) - Vector(myHero)):normalized()
						CastSpell(_Q, posB.x, posB.z)
						if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on target") end
					end
				else
					local pos = Vector(myHero) + (GetDistance(QEtargetPos) - 50) * (Vector(QEtargetPos) - Vector(myHero)):normalized()
					CastSpell(_Q, pos.x, pos.z)
					if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on target") end
				end
			end
		end
	end
end

function UseSpells(UseQ, UseW, UseE, UseEQ, UseR, forcedtarget)

	local Qtarget
	local QEtarget
	local Rtarget
	if forcedtarget ~= nil then
		Qtarget = forcedtarget
		QEtarget = forcedtarget
		Rtarget = forcedtarget
	elseif STS == nil then
		Qtarget = Selector.GetTarget(SelectorMenu.Get().mode, 'AP', {distance = W.range})
		QEtarget = Selector.GetTarget(SelectorMenu.Get().mode, 'AP', {distance = QE.range})
		Rtarget = Selector.GetTarget(SelectorMenu.Get().mode, 'AP', {distance = R.range})
	else
		Qtarget = STS:GetTarget(W.range)
		QEtarget = STS:GetTarget(QE.range)
		Rtarget = STS:GetTarget(R.range)
	end 

	local DFGUsed = false

	if (os.clock() - DontUseRTime < 10) then
		UseR = false
	end

	if UseW and W.IsReady() and Qtarget and W.status == 1 and (os.clock() - Q.LastCastTime > 0.25) and (os.clock() - E.LastCastTime > (QE.range / QE.speed) +  (0.6 - (Menu.EQ.Range / QE.speed))) then
		local pos, info, hitchance
		if Menu.PredictionType.PredictionType == 1 then
			pos, hitchance = VP:GetCircularCastPosition(Qtarget, W.delay, W.width, W.range, W.speed)
		else
			pos, info = Prodiction.GetPrediction(Qtarget, W.range, W.speed, W.delay, W.width)
			hitchance = info.hitchance
		end
				
		if hitchance >= Menu.HitChance.HitChance and pos and pos.z then
			--[[DelayAction(function()]] CastSpell(_W, pos.x, pos.z)-- end, 0.3)
			if Menu.debug.Wdebug.WCastPrint then PrintChat("Casted W on target") end
		end
	end

	if UseEQ then
		if (Qtarget or QEtarget) and E.IsReady() and Q.IsReady() then
			if Qtarget then
				StartEQCombo(Qtarget)
			else
				StartEQCombo(QEtarget)
			end		
		end
	end

	if UseQ and Q.IsReady() then
		if Qtarget and os.clock() - W.LastCastTime > 0.25 and os.clock() - E.LastCastTime > 0.25 then

			local pos, info, hitchance
			if Menu.PredictionType.PredictionType == 1 then
				pos, hitchance = VP:GetCircularCastPosition(Qtarget, Q.delay, Q.width, Q.range, Q.speed)
			else
				pos, info = Prodiction.GetPrediction(Qtarget, Q.range, Q.speed, Q.delay, Q.width)
				hitchance = info.hitchance
			end

			if hitchance >= Menu.HitChance.HitChance and pos and pos.z then
				CastSpell(_Q, pos.x, pos.z)
				if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on target") end
			end
		end
	end

	if UseE and E.IsReady() then
		if Qtarget and DLib:IsKillable(Qtarget, {_E}) and GetDistanceSqr(Qtarget, myHero) < E.rangeSqr then
			CastSpell(_E, Qtarget.x, Qtarget.z)
			if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on target") end
		end
		--Check to stun people with E
		local validballs = GetValidBalls(true)
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				for i, ball in ipairs(validballs) do
					if GetDistanceSqr(ball.object, myHero) < E.rangeSqr then

						local enemyPos, info, hitchance
						if Menu.PredictionType.PredictionType == 1 then
							enemyPos, hitchance = VP:GetLineCastPosition(enemy, (E.delay + (GetDistance(myHero, ball.object) / E.speed) - (GetDistance(myHero, ball.object) / QE.speed)), QE.width, QE.range, QE.speed)
						else
							enemyPos, info = Prodiction.GetPrediction(enemy, QE.range, QE.speed, (E.delay + (GetDistance(myHero, ball.object) / E.speed) - (GetDistance(myHero, ball.object) / QE.speed)), QE.width)
							hitchance = info.hitchance
						end


						if hitchance >= Menu.HitChance.HitChance and enemyPos and enemyPos.z then				
							local EP = Vector(ball.object) +  (100+(-0.6 * GetDistance(ball.object, myHero) + 966)) * (Vector(ball.object) - Vector(myHero)):normalized()
							local SP = Vector(ball.object) - 100 * (Vector(ball.object) - Vector(myHero)):normalized()
							local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(SP, EP, enemyPos)
							if isOnSegment and GetDistanceSqr(pointLine, enemyPos) <= (QE.width + VP:GetHitBox(enemy))^2 then
								CastSpell(_E, ball.object.x, ball.object.z)
								if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on ball") end
							end
						end
					end
				end
			end
		end
	end
	
	if UseW and W.IsReady() then
		if Qtarget and W.status == 0 and (os.clock() - E.LastCastTime > 0.7) and (os.clock() - Q.LastCastTime > 0.7) then
			local validball = GetWValidBall()
			if validball then
				DelayAction(function() CastSpell(_W, validball.object.x, validball.object.z) end, 0.2)
				W.status = 1
				if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked up ball with W") end
			end
		end
	end

	if UseR and not Q.IsReady() and not W.IsReady() then
		if ((Qtarget and not Menu.R.Targets[Qtarget.hash]) or (Rtarget and not Menu.R.Targets[Rtarget.hash])) then
			if Qtarget and ((GetDistanceSqr(Qtarget.visionPos, myHero) < R.rangeSqr and DLib:IsKillable(Qtarget, GetCombo(Qtarget)) and (not Menu.Combo.AntiOverKill or not DLib:IsKillable(Qtarget, {_AQ})) and not DLib:IsKillable(Qtarget, {_Q, _W})) or (os.clock() - UseRTime < 10)) then
				ItemManager:CastOffensiveItems(Qtarget)
				if _SpellIGNITE and GetDistanceSqr(Qtarget.visionPos, myHero) < 600 * 600 then
					CastSpell(_SpellIGNITE, Qtarget)
				end
				CastSpell(_R, Qtarget)
				if Menu.debug.Rdebug.RCastPrint then PrintChat("Casted R on target") end
			elseif Rtarget and ((GetDistanceSqr(Rtarget.visionPos, myHero) < R.rangeSqr and DLib:IsKillable(Rtarget, GetCombo(Rtarget)) and (not Menu.Combo.AntiOverKill or not DLib:IsKillable(Rtarget, {_AQ})) and not DLib:IsKillable(Rtarget, {_Q, _W})) or (os.clock() - UseRTime < 10)) then
				ItemManager:CastOffensiveItems(Rtarget)
				if _SpellIGNITE and GetDistanceSqr(Rtarget.visionPos, myHero) < 600 * 600 then
					CastSpell(_SpellIGNITE, Rtarget)
				end
				CastSpell(_R, Rtarget)
				if Menu.debug.Rdebug.RCastPrint then PrintChat("Casted R on target") end
			end
		end
	end

	if UseR and not Q:IsReady() and R:IsReady() and not DFGUsed then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) and (not Menu.R.Targets[enemy.hash] or (os.clock() - UseRTime < 10)) and GetDistanceSqr(enemy.visionPos, myHero) < R.rangeSqr then
				if DLib:IsKillable(enemy, GetUltCombo())  or (os.clock() - UseRTime < 10) then
					if not DLib:IsKillable(enemy, {_Q, _E, _W})  or (os.clock() - UseRTime < 10) then
						CastSpell(_R, enemy)
					end
				end
			end
		end
	end
end



function UpdateSpellData()
	if E.width ~= 2 * E.width and myHero:GetSpellData(_E).level == 5 then
		E.width = 2 * E.width
	end

	if R.range ~= (800) and myHero:GetSpellData(_R).level  == 3 then
		R.range = 800
		R.rangeSqr = math.pow(800, 2)
	end

--	W.status = WObject and 1 or 0
end

function Combo()
	SxOrb:DisableAttacks()
	if not Q.IsReady() and not W.IsReady() and not E.IsReady() then
		SxOrb:EnableAttacks()
	end
	UseSpells(Menu.Combo.UseQ, Menu.Combo.UseW, Menu.Combo.UseE, Menu.Combo.UseEQ, Menu.Combo.UseR)
end

function Harass(target)
	if Menu.Harass.ManaCheck > (myHero.mana / myHero.maxMana) * 100 then return end
	UseSpells(Menu.Harass.UseQ, Menu.Harass.UseW, Menu.Harass.UseE, Menu.Harass.UseEQ, false, target)
end

function OnTick()
	DLib.combo = GetCombo()
	DrawJungleStealingIndicator = false
	BTOnTick()
	SxOrb:EnableAttacks()
	UpdateSpellData()--update the spells data
	DrawEQIndicators = false
	Zhonyas()
	
	if Recieved == 1 and W.IsReady() then
		W.status = 1
	end
	if not W.IsReady() then W.status = 0 Recieved = 0 end
	
	if Menu.Combo.Enabled then
		Combo()
	elseif Menu.Harass.Enabled or Menu.Harass.Enabled2 then
		Harass()
	end

	if Menu.Farm.LaneClear or Menu.Farm.Freeze then
		Farm()
	end

	if Menu.JungleFarm.Enabled then
		JungleFarm()
	end

	if Menu.Misc.WPet then
		AutoGrabPets()
	end

	if Menu.R.DontUseR then
		DontUseRTime = os.clock()
		UseRTime = 0
	end

	if Menu.R.CastR then
		UseRTime = os.clock()
		DontUseRTime = 0
	end
	
	if Menu.Misc.JungleSteal.enabled then
		JungleSteal()
	end

	if Menu.Misc.MEQ and Q.IsReady() and E.IsReady() then
		DrawEQIndicators = true
		local PosibleTargets = GetEnemyHeroes()
		local ClosestTargetMouse 
		local closestdist = 200 * 200
		for i, target in ipairs(PosibleTargets) do
			local dist = GetDistanceSqr(mousePos, target)
			if ValidTarget(target) and dist < closestdist then
				ClosestTargetMouse = target
				closestdist = dist
			end
		end
		if ClosestTargetMouse and GetDistanceSqr(ClosestTargetMouse, myHero) < QE.rangeSqr then
			StartEQCombo(ClosestTargetMouse)
		end
	end
end

function GetDistanceToClosestHero(p)
	local result = math.huge
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			result = math.min(result, GetDistanceSqr(p, enemy))
		end
	end
	return result
end

myHero.barData = {PercentageOffset = {x = 0, y = 0}}

function OnDraw()
	if DrawEQIndicators then
		DrawCircle3D(mousePos.x, mousePos.y, mousePos.z, 200, 3, GetDistanceToClosestHero(mousePos) < 200 * 200 and ARGB(200, 255, 0, 0) or ARGB(200, 0, 255, 0), 20)--sorry for colorblind people D:
	end

	if GetTarget() and GetTarget().type == 'obj_AI_Minion' and GetTarget().team == TEAM_NEUTRAL then
		DrawCircle3D(GetTarget().x, GetTarget().y, GetTarget().z, 100, 2, Menu.JungleFarm.Enabled and ARGB(175, 255, 0, 0) or ARGB(175, 0, 255, 0), 25) --sorry for colorblind people D:
	end

	if DrawJungleStealingIndicator then
		local pos = GetEnemyHPBarPos(myHero) + Vector(20, -4)
		pos.x = math.floor(pos.x)
		pos.y = math.floor(pos.y)

		DrawText(tostring("JungleStealing"), 16, pos.x+1, pos.y+1, ARGB(255, 0, 0, 0))
		DrawText(tostring("JungleStealing"), 16, pos.x, pos.y, ARGB(255, 255, 255, 255))
	end

	if Menu.Harass.Enabled2 then
		local pos = GetEnemyHPBarPos(myHero) + Vector(0, -4)
		pos.x = math.floor(pos.x)
		pos.y = math.floor(pos.y)

		DrawText(tostring("AH"), 16, pos.x+1, pos.y+1, ARGB(255, 0, 0, 0))
		DrawText(tostring("AH"), 16, pos.x, pos.y, ARGB(255, 255, 255, 255))
	end
	
	if Menu.Misc.JungleSteal.JSdraw then
		DrawCircle2(Spots.BlueBlue.x, Spots.BlueBlue.y, Spots.BlueBlue.z, 200, ARGB(255, 0, 255, 0))
		DrawCircle2(Spots.PurpleBlue.x, Spots.PurpleBlue.y, Spots.PurpleBlue.z, 200, ARGB(255, 0, 255, 0))
	end
	
--	DrawText("W Status: " ..W.status, 18, 100, 100, 0xFFFFFF00)
--	if not WObject then DrawText("Wobject Nope.", 18, 100, 120, 0xFFFFFF00) end
end


function Farm()
	if (Menu.Farm.ManaCheck > (myHero.mana / myHero.maxMana) * 100 and Menu.Farm.LaneClear) or (Menu.Farm.ManaCheck2 > (myHero.mana / myHero.maxMana) * 100 and Menu.Farm.Freeze) then return end
	EnemyMinions:update()
	local UseQ = Menu.Farm.LaneClear and (Menu.Farm.UseQ >= 3) or (Menu.Farm.UseQ == 2 or Menu.Farm.UseQ == 4)
	local UseW = Menu.Farm.LaneClear and (Menu.Farm.UseW >= 3) or (Menu.Farm.UseW == 2 or Menu.Farm.UseW == 4)
	local UseE = Menu.Farm.LaneClear and (Menu.Farm.UseE >= 3) or (Menu.Farm.UseE == 2 or Menu.Farm.UseE == 4)
	
	local CasterMinions = SelectUnits(EnemyMinions.objects, function(t) return (t.charName:lower():find("range") or t.charName:lower():find("siege")) and ValidTarget(t) and GetDistanceSqr(t) < W.rangeSqr end)
	local MeleeMinions = SelectUnits(EnemyMinions.objects, function(t) return (t.charName:lower():find("melee") or t.charName:lower():find("super")) and ValidTarget(t) and GetDistanceSqr(t) < W.rangeSqr end)
	
	if UseW then
		if W.status == 0 then
			if #MeleeMinions > 1 then
				CastSpell(_W, MeleeMinions[1].x, MeleeMinions[1].z)
				if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked melee minion with W") end
			elseif #CasterMinions > 1 then
				CastSpell(_W, CasterMinions[1].x, CasterMinions[1].z)
				if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked caster minion with W") end
			end
		else
			local BestPos1, BestHit1 = GetBestCircularFarmPosition(W.range, W.width, CasterMinions)
			local BestPos2, BestHit2 = GetBestCircularFarmPosition(W.range, W.width, MeleeMinions)

			if BestHit1 > 2 or (BestPos1 and #CasterMinions <= 2) then
				CastSpell(_W, BestPos1.x, BestPos1.z)
				if Menu.debug.Wdebug.WCastPrint then PrintChat("Thrown minion on Caster Minions with W") end
			elseif BestHit2 > 2 or (BestPos2 and #MeleeMinions <= 2) then
				CastSpell(_W, BestPos2.x, BestPos2.z)
				if Menu.debug.Wdebug.WCastPrint then PrintChat("Thrown minion on Melee Minions with W") end
			end

		end
	end

	if UseQ then
		CasterMinions = GetPredictedPositionsTable(VP, CasterMinions, Q.delay, Q.width, Q.range + Q.width, math.huge, myHero, false)
		MeleeMinions = GetPredictedPositionsTable(VP, MeleeMinions, Q.delay, Q.width, Q.range + Q.width, math.huge, myHero, false)

		local BestPos1, BestHit1 = GetBestCircularFarmPosition(Q.range + Q.width, Q.width, CasterMinions)
		local BestPos2, BestHit2 = GetBestCircularFarmPosition(Q.range + Q.width, Q.width, MeleeMinions)

		if BestPos1 and BestHit1 >= 1 then
			CastSpell(_Q, BestPos1.x, BestPos1.z)
			if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on Caster Minions") end
		elseif BestPos2 and BestHit2 >= 1 then
			CastSpell(_Q, BestPos2.x, BestPos2.z)
			if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on Melee Minions") end
		end
	end

	if UseE and (not Q.IsReady() or not UseQ) then
		local AllMinions = SelectUnits(EnemyMinions.objects, function(t) return ValidTarget(t) and GetDistanceSqr(t) < E.rangeSqr end)
		local BestPos, BestHit = GetBestCircularFarmPosition(E.range, E.width, AllMinions)
		if BestHit > 4 then
			CastSpell(_E, BestPos.x, BestPos.z)
			if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on Minions") end
		else
			local validballs = GetValidBalls()
			local maxcount = 0
			local maxpos

			for i, ball in ipairs(validballs) do
				if GetDistanceSqr(ball.object, myHero) < Q.rangeSqr then
					local Count = 0
					for i, minion in ipairs(AllMinions) do
						local EP = Vector(ball.object) +  (100+(-0.6 * GetDistance(ball.object, myHero) + 966)) * (Vector(ball.object) - Vector(myHero)):normalized()
						local SP = Vector(myHero)
						local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(SP, EP, minion)
						if isOnSegment and GetDistanceSqr(pointLine, enemyPos) < QE.width * QE.width then
							Count = Count + 1
						end
					end
					if Count > maxcount then
						maxcount = Count
						maxpos = Vector(ball.object)
					end
				end
			end
			if maxcount > 2 then
				CastSpell(_E, maxpos.x, maxpos.z)
				if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on Minions") end
			end
		end
	end
end

function JungleFarm()
	JungleMinions:update()
	local UseQ = Menu.JungleFarm.UseQ
	local UseW = Menu.JungleFarm.UseW
	local UseE = Menu.JungleFarm.UseE
	local WUsed = false
	local CloseMinions = SelectUnits(JungleMinions.objects, function(t) return GetDistanceSqr(t) <= W.rangeSqr and ValidTarget(t) end)
	local AllMinions = SelectUnits(JungleMinions.objects, function(t) return ValidTarget(t) end)

	local CloseMinion = CloseMinions[1]
	local FarMinion = AllMinions[1]

	

	if ValidTarget(CloseMinion) then
		local selectedTarget = GetTarget()

		if selectedTarget and selectedTarget.type == CloseMinion.type then
			DrawJungleStealingIndicator = true
			SxOrb:DisableAttacks()
			if ValidTarget(selectedTarget) and DLib:IsKillable(selectedTarget, {_Q, _W}) and GetDistanceSqr(myHero, selectedTarget) <= W.rangeSqr and W.IsReady() then
				if W.status == 0 then
					CastSpell(_W, selectedTarget.x, selectedTarget.z)
					if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked Jungle Monster with W") end
				end
			end
		else
			if UseW then
				if W.status == 0 then
					local validball = GetWValidBall(true)
					if validball and validball.added then
						CastSpell(_W, validball.object.x, validball.object.z)
						if Menu.debug.Wdebug.WCastPrint then PrintChat("Picked ball with W") end
						WUsed = true
					end
				else
					CastSpell(_W, CloseMinion)
					if Menu.debug.Wdebug.WCastPrint then PrintChat("Thrown Jungle Monster with W") end
					WUsed = true
				end
			end

			if UseQ then
				CastSpell(_Q, CloseMinion)
				if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on Jungle Monster") end
			end

			if UseE and os.clock() - Q.LastCastTime > 1 then
				CastSpell(_E, CloseMinion)
				if Menu.debug.Edebug.ECastPrint then PrintChat("Casted E on Jungle Monster") end
			end
		end
	elseif ValidTarget(FarMinion) and GetDistanceSqr(FarMinion) <= (Q.range + 588)^2 and GetDistanceSqr(FarMinion) > Q.rangeSqr and DLib:IsKillable(FarMinion, {_E}) then
		if Q.IsReady() and E.IsReady() then
			local QPos = Vector(myHero) + Q.range * (Vector(FarMinion) - Vector(myHero)):normalized()
			CastSpell(_Q, QPos.x, QPos.z)
			if Menu.debug.Qdebug.QCastPrint then PrintChat("Casted Q on far Jungle Monster") end
			QECombo = os.clock()
		end
	end

	if W.status == 1 and not WUsed then
--		if (not WObject.name or not WObject.name:find("Seed")) and WObject.type == 'obj_AI_Minion' then
		CastSpell(_W, CloseMinion)
		if Menu.debug.Wdebug.WCastPrint then PrintChat("Thrown Jungle Monster on myself") end
	end
end

function Zhonyas()
	if Menu.Misc.Zhonya.enabled then
		if GetInventoryHaveItem(3157) and GetInventoryItemIsCastable(3157) then
			if myHero.health <=  myHero.maxHealth * (Menu.Misc.Zhonya.zhonyapls / 100) then
				CastItem(3157)
			end 
		end 
	end 
end

function JungleSteal()

	local Blue = SelectUnits(JungleMinions.objects, function(t) return t.charName:lower():find("blue") and ValidTarget(t) end)

	if GetDistance(Spots.PurpleBlue) <= 25 and Menu.Misc.JungleSteal.enabled then
		if W.status == 0 and W.IsReady() and Q.IsReady() then
			if ValidTarget(Blue) then
				CastSpell(_W, Blue.x, Blue.z)
				if W.status == 1 then
					CastSpell(_W, myHero.x, myHero.z)
					CastSpell(_Q, Blue.x, Blue.z)
				end
			end
		end
	elseif GetDistance(Spots.PurpleBlue) > 25 and GetDistance(Spots.PurpleBlue, mousePos) < 225 then
		myHero:MoveTo(Spots.PurpleBlue.x, Spots.PurpleBlue.z)
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
