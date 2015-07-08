--[[
	running on
    __  ___        __   __     _  __      ______                                                     __      ___      ____ 
   /  |/  /__  __ / /_ / /_   (_)/ /__   / ____/_____ ____ _ ____ ___   ___  _      __ ____   _____ / /__   |__ \    / __ \
  / /|_/ // / / // __// __ \ / // //_/  / /_   / ___// __ `// __ `__ \ / _ \| | /| / // __ \ / ___// //_/   __/ /   / / / /
 / /  / // /_/ // /_ / / / // // ,<    / __/  / /   / /_/ // / / / / //  __/| |/ |/ // /_/ // /   / ,<     / __/ _ / /_/ / 
/_/  /_/ \__, / \__//_/ /_//_//_/|_|  /_/    /_/    \__,_//_/ /_/ /_/ \___/ |__/|__/ \____//_/   /_/|_|   /____/(_)\____/  
        /____/                                                                                                             

	We've come a long way :) 

	Mythik Framework is usable by anyone, if you wish to use it, please do not change the credits or remove the header.
--]]

ver = "1.2"

if myHero.charName ~= "Thresh" then return end

--[[=======================================================
   Localization
=========================================================]]

local me 			= _G.myHero -- LocalPlayer
local CastSpell 	= _G.CastSpell -- Cast func
local ValidTarget 	= _G.ValidTarget -- Valid target check
local damage 		= _G.getDmg -- damage calc

-- base table of all things that are holy
local myth = {
	name = "Thresh - UPL", -- script name
	ver = ver, -- script version
	foes = GetEnemyHeroes(), -- enemy champs
	ts = TargetSelector(TARGET_LOW_HP, 1000, DAMAGE_PHYSICAL, false, true), --target selector
	creep = minionManager(MINION_ENEMY, 200, me, MINION_SORT_HEALTH_ASC), --creep selection
	skill = {
		q = {range = 1075, del=0.500, speed=1900, w=70},
		w = {range = 950},
		e = {range = 515, del=0.3, speed=math.huge, w=160},
		r = {range = 420, del = 0.3, speed = math.huge, w = 420}, -- player skill table 
	}
}

--[[=======================================================
   Updater
=========================================================]]

function myth:printChat(msg) -- chat message with prefix
	print("<font color='#D40000'>["..myth.name.."]</font><font color='#FFFFFF'> "..msg.."</font>") 
end

--[[=======================================================
   Module/Lib Loading
=========================================================]]

--[[ Libraries start ]]--
if not _G.UPLloaded then
  if FileExist(LIB_PATH .. "/UPL.lua") then
    require("UPL")
    _G.UPL = UPL()
  else 
    print("Downloading UPL, please don't press F9")
    DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () TopKekMsg("Successfully downloaded UPL. Press F9 twice.") end) end, 3)
    return
  end
end
--[[ Libraries end ]]--

local function loadPred() -- load pred intergration
	UPL:AddSpell(_Q, {speed = 1900, delay = 0.500, range = 1050, width = 70, collision = true, aoe = false, type = "linear"})
	UPL:AddSpell(_W, {speed = math.huge, delay = 0.5, range = 950, width = 315, collision = false, aoe = false, type = "circular"})
	UPL:AddSpell(_E, {speed = math.huge, delay = 0.3, range = 515, width = 160, collision = false, aoe = true, type = "rectangular"})
end

--[[=======================================================
   Orbwalker Intergration
=========================================================]]

local function getOrbwalk() -- return running orbwalk
	if _G.Reborn_Loaded and not _G.Reborn_Initialised then
		DelayAction(getOrbwalk, 1)
		return "waiting"
	elseif _G.Reborn_Initialised then
		return "sac"
	elseif _G.MMA_Loaded then
		return "mma"
	else
		return "none"
	end
end

local function loadOrbwalk() -- load orbwalk if one isnt loaded
	if getOrbwalk() == "waiting" then
		DelayAction(loadOrbwalk, 1)
	elseif getOrbwalk() == "sac" then
		myth:printChat("SA:C Intergration loaded.")
	elseif getOrbwalk() == "mma" then
		myth:printChat("MMA Intergration loaded.")
	else 
		myth:printChat("No orbwalker found, loading SxOrbWalk...")
		require("SxOrbWalk")
	end
end

local function target() -- target selection
	myth.ts:update()
	if getOrbwalk() == "sac" and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end		
	if getOrbwalk() == "mma" and ValidTarget(_G.MMA_Target) then return _G.MMA_Target end
	return myth.ts.target
end

--[[=======================================================
   Cast Functions
=========================================================]]

function myth:cast(spell, targ) -- dynamic cast func
	if spell == "q" then
		if not settings.combo.q or not qready or not ValidTarget(targ, myth.skill.q.range) then return end
		local CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, targ)
		if HitChance >= 2 then
			CastSpell(_Q, CastPosition.x, CastPosition.z)
		end
	end
	if spell == "w" then
		if not settings.combo.w or not wready then return end
		CastSpell(_W)
	end	
	if spell == "wcombo" then
		if not settings.combo.w or not wready then return end
		local CastPosition, HitChance, HeroPosition = UPL:Predict(_W, myHero, targ)
		if WREADY and myHero:GetSpellData(_Q).name == "threshqleap" then
			if findClosestAlly() and GetDistance(findClosestAlly()) < myth.skill.w.range then
				CastSpell(_W, findClosestAlly().x, findClosestAlly().z)
			end
		end
	end
	if spell == "eback" then
		if not settings.combo.e or not eready or not ValidTarget(targ, myth.skill.e.range) then return end
		CastPosition, HitChance, HeroPosition = UPL:Predict(_E, myHero, targ)
		xPos = myHero.x + (myHero.x - targ.x)
		zPos = myHero.z + (myHero.z - targ.z)
		CastSpell(_E, xPos, zPos)
	end
	if spell == "eforward" then
		if not settings.combo.e or not eready or not ValidTarget(targ, myth.skill.e.range) then return end
		CastPosition, HitChance, HeroPosition = UPL:Predict(_E, myHero, targ)
		CastSpell(_E, CastPosition.x, CastPosition.z)
	end	
	if spell == "r" then
		if not settings.combo.r or not rready or not ValidTarget(targ, myth.skill.r.range) then return end
		CastSpell(_R)
	end
end

function autoR()
	if settings.misc.autoR then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if enemy and ValidTarget(enemy, myth.skill.r.range) and AreaEnemyCount(enemy, 450) >= settings.misc.autoUlt and enemy.visible then
				CastSpell(_R)
			end
		end
	end
end

function autoW()
	if settings.misc.autoR then
		if WREADY and CountEnemyHeroInRange(950) >= settings.misc.autoLantern then
			for k, ally in pairs(GetAllyHeroes()) do
				if GetDistance(ally) < myth.skill.w.range then
					CastSpell(_W, GetLowestAlly().x, GetLowestAlly().z)
				end
			end
		end
	end
end

local function bang(unit) -- combo (bang bang skudda)
	if ValidTarget(target()) then
		myth:cast("q", unit)
		if findClosestAlly() then
			myth:cast("wcombo", unit)
		else
			myth:cast("w", unit)
		end
		QLeap()
		myth:cast("eback", unit)
		myth:cast("r", unit)
	end
end

local function harass(unit) -- harass dat nigga
	if settings.harass.autoe then
		myth:cast("eforward", unit)
	end
	if settings.harass.key then
		if settings.harass.q then
			myth:cast("q", unit)
		end
		if settings.harass.e then
			myth:cast("eforward", unit)
		end
	end
end

local function steal() -- killsteal
	for k, v in pairs(myth.foes) do
		if settings.ks.e and ValidTarget(v, myth.skill.e.range) and damage("E", v, me) > v.health then
			myth:cast("eback", unit)
		end
		if settings.ks.q and ValidTarget(v, myth.skill.q.range) and damage("Q", v, me) > v.health then
			myth:cast("q", unit)
		end
	end
end

function QLeap()
	if myHero:GetSpellData(_Q).name == "threshqleap" then
		CastSpell(_Q)
	end
end

--[[=======================================================
   Menu
=========================================================]]

local function menu()
	settings = scriptConfig("["..myth.name.."]", "mythik")

	TargetSelector.name = "Target Select"

	settings:addSubMenu("Full Combo", "combo")
	settings.combo:addParam("key", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	settings.combo:addParam("q", "Auto Q", SCRIPT_PARAM_ONOFF, false)
	settings.combo:addParam("w", "Auto W", SCRIPT_PARAM_ONOFF, false)
	settings.combo:addParam("e", "Auto E", SCRIPT_PARAM_ONOFF, false)
	settings.combo:addParam("r", "Auto R", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Harass", "harass")
	settings.harass:addParam("key", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
	settings.harass:addParam("autoe", "Auto E in range", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
	settings.harass:addParam("q", "Harass with Q", SCRIPT_PARAM_ONOFF, false)
	settings.harass:addParam("e", "Harass with E", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Kill Steal", "ks")
	settings.ks:addParam("q", "Kill steal with Q", SCRIPT_PARAM_ONOFF, false)
	settings.ks:addParam("e", "Kill steal with E", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Misc.", "misc")
	settings.misc:addParam("autoW", "Auto W", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("K"))
	settings.misc:addParam("autoLantern", "Enemy # before Auto W to ally", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
	settings.misc:addParam("autoR", "Auto R", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
	settings.misc:addParam("autoUlt", "Enemy # before Auto R", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
	
	settings:addSubMenu("Drawing", "draw")

	if myth.skill.q.range ~= nil then
		settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, false)
	end
	if myth.skill.w.range ~= nil then
		settings.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, false)
	end
	if myth.skill.e.range ~= nil then
		settings.draw:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, false)
	end
	if myth.skill.r.range ~= nil then
		settings.draw:addParam("r", "Draw R", SCRIPT_PARAM_ONOFF, false)
	end

	settings:addTS(myth.ts)
end

--[[=======================================================
   Main Hooks
=========================================================]]

function OnLoad()
	myth:printChat("has loaded!<font color='#2BFF00'> ["..myth.ver.."]")

	loadOrbwalk()

	DelayAction(loadPred, 3) -- load prediction

	menu() -- load menu
end

function OnTick()
	qready, wready, eready, rready = me:CanUseSpell(_Q) == READY, me:CanUseSpell(_W) == READY, me:CanUseSpell(_E) == READY, me:CanUseSpell(_R) == READY

	myth.ts:update() --update target selection
	myth.creep:update() --update creep selection

	if settings.combo.key then -- combo
		bang(target())
	end
	
	autoR()
	autoW()

	harass(target()) -- harass

	steal() -- kill stealer
end

function OnDraw()
	if myth.skill.q.range ~= nil and settings.draw.q and qready then
		DrawCircle(me.x, me.y, me.z, myth.skill.q.range, ARGB(125,0,150,255))
	end
	if myth.skill.w.range ~= nil and settings.draw.w and wready then
		DrawCircle(me.x, me.y, me.z, myth.skill.w.range, ARGB(125,0,150,255))
	end
	if myth.skill.e.range ~= nil and settings.draw.e and eready then
		DrawCircle(me.x, me.y, me.z, myth.skill.e.range, ARGB(125,0,150,255))
	end
	if myth.skill.r.range ~= nil and settings.draw.r and rready then
		DrawCircle(me.x, me.y, me.z, 450, ARGB(125,0,150,255))
	end
end

--[[=======================================================
   Lag-Free Circles
=========================================================]]

local function round(num) 
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

local function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
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

function DrawCircle(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 200) 
    end
end

--[[=======================================================
   Extra needed functions
=========================================================]]

function AreaEnemyCount(Spot)
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(Spot, enemy) < 450 then
				count = count + 1
			end
		end              
	return count
end

function findClosestAlly()
	local closestAlly = nil
	local currentAlly = nil
	for i=1, heroManager.iCount do
		currentAlly = heroManager:GetHero(i)
		if currentAlly.team == myHero.team and not currentAlly.dead and currentAlly.charName ~= myHero.charName then
			if closestAlly == nil then
				closestAlly = currentAlly
			elseif GetDistance(currentAlly) < GetDistance(closestAlly) then
				closestAlly = currentAlly
			end
		end
	end
	return closestAlly
end

function CountEnemyHeroInRange(range)
	local enemyInRange = 0
		for i = 1, heroManager.iCount, 1 do
		local enemyheros = heroManager:getHero(i)
			if enemyheros.valid and enemyheros.visible and enemyheros.dead == false and enemyheros.team ~= myHero.team and GetDistance(enemyheros) <= range then
				enemyInRange = enemyInRange + 1
			end
		end
	return enemyInRange
end

function GetLowestAlly(range) --[[Tested function.. I love it! Always returns the lowest % ally in range.]]
	assert(range, "GetLowestAlly: Range returned nil. Cannot check valid ally in nil range")
	LowestAlly = nil
	for a = 1, heroManager.iCount do
		Ally = heroManager:GetHero(a)
		if Ally.team == myHero.team and not Ally.dead and GetDistance(myHero,Ally) <= range then
			if LowestAlly == nil then
				LowestAlly = Ally
			elseif not LowestAlly.dead and (Ally.health/Ally.maxHealth) < (LowestAlly.health/LowestAlly.maxHealth) then
				LowestAlly = Ally
			end
		end
	end
	return LowestAlly
end