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

ver = "1.0"

if myHero.charName ~= "Leona" then return end

--[[=======================================================
   Localization
=========================================================]]

local me 			= _G.myHero -- LocalPlayer
local CastSpell 	= _G.CastSpell -- Cast func
local ValidTarget 	= _G.ValidTarget -- Valid target check
local damage 		= _G.getDmg -- damage calc

-- base table of all things that are holy
local myth = {
	name = "Leona - UPL", -- script name
	ver = ver, -- script version
	foes = GetEnemyHeroes(), -- enemy champs
	ts = TargetSelector(TARGET_LOW_HP, 1000, DAMAGE_PHYSICAL, false, true), --target selector
	creep = minionManager(MINION_ENEMY, 200, me, MINION_SORT_HEALTH_ASC), --creep selection
	skill = {
		q = {range = 155},
		w = {},
		e = {range = 875}, --Self
		r = {range = 1200}, -- player skill table
	}
}

require "SxOrbWalk"

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
	UPL:AddSpell(_E, { speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear"})
	UPL:AddSpell(_R, { speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular"})
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
		return "sxorb"
	end
end

local function loadOrbwalk() -- load orbwalk if one isnt loaded
	if getOrbwalk() == "waiting" then
		DelayAction(loadOrbwalk, 1)
	elseif getOrbwalk() == "sac" then
		myth:printChat("SA:C Intergration loaded.")
	elseif getOrbwalk() == "mma" then
		myth:printChat("MMA Intergration loaded.")
	elseif getOrbwalk() == "sxorb" then
		myth:printChat("SxOrbWalk Intergration loaded.")
		require("SxOrbWalk")
		SxMenu = scriptConfig("SxOrbWalk", "SxOrbb")
		SxOrb:LoadToMenu(SxMenu)
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
		CastSpell(_Q, targ)
	end
	if spell == "w" then
		if not settings.combo.w or not wready then return end
		CastSpell(_W)
	end
	if spell == "e" then
		if not settings.combo.e or not eready or not ValidTarget(targ, myth.skill.e.range) then return end
		local CastPosition, HitChance, HeroPosition = UPL:Predict(_e, myHero, targ)
		if HitChance >= 2.5 then
			CastSpell(_E, CastPosition.x, CastPosition.z)
		end		
	end
	if spell == "r" then
		if not settings.combo.r or not rready or not ValidTarget(targ, myth.skill.r.range) then return end
		local CastPosition, HitChance, HeroPosition = UPL:Predict(_R, myHero, targ)
		if HitChance >= 2.5 then
			CastSpell(_R, CastPosition.x, CastPosition.z)
		end
	end
end

function autoR()
	if settings.misc.autoR then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if enemy and ValidTarget(enemy, myth.skill.r.range) and AreaEnemyCount(enemy, 1200) >= settings.misc.autoUlt and enemy.visible then
				myth:cast("r", enemy)
			end
		end
	end
end

local function bang(unit) -- combo (bang bang skudda)
	if ValidTarget(target()) then
		myth:cast("w", unit)
		myth:cast("e", unit)
		myth:cast("q", unit)
		myth:cast("r", unit)
	end
end

local function harass(unit) -- harass dat nigga
	if settings.harass.autoq then
		myth:cast("q", unit)
	end
	if settings.harass.key then
		if settings.harass.q then
			myth:cast("q", unit)
		end
	end
end

local function steal() -- killsteal
	for k, v in pairs(myth.foes) do
		if settings.ks.e and ValidTarget(v, myth.skill.e.range) and damage("E", v, me) > v.health then
			myth:cast("e", unit)
		end
		if settings.ks.q and ValidTarget(v, myth.skill.q.range) and damage("Q", v, me) > v.health then
			myth:cast("q", unit)
		end
		if settings.ks.r and ValidTarget(v, myth.skill.r.range) and damage("R", v, me) > v.health then
			myth:cast("r", unit)
		end		
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
	settings.harass:addParam("autoq", "Auto Q in range", SCRIPT_PARAM_ONOFF, false)
	settings.harass:addParam("q", "Harass with Q", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Kill Steal", "ks")
	settings.ks:addParam("q", "Kill steal with Q", SCRIPT_PARAM_ONOFF, false)
	settings.ks:addParam("e", "Kill steal with E", SCRIPT_PARAM_ONOFF, false)
	settings.ks:addParam("r", "Kill steal with R", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Misc.", "misc")
	settings.misc:addParam("autoR", "Auto R", SCRIPT_PARAM_ONOFF, false)
	settings.misc:addParam("autoUlt", "Enemy # before Auto R", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
	
	UPL:AddToMenu(settings)
	
	settings:addSubMenu("Drawing", "draw")

	if myth.skill.q.range ~= nil then
		settings.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, false)
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

	harass(target()) -- harass
	
	steal() -- kill stealer
end

function OnDraw()
	if myth.skill.q.range ~= nil and settings.draw.q and qready then
		DrawCircle(me.x, me.y, me.z, myth.skill.q.range, ARGB(125,0,150,255))
	end
	if myth.skill.e.range ~= nil and settings.draw.e and eready then
		DrawCircle(me.x, me.y, me.z, myth.skill.e.range, ARGB(125,0,150,255))
	end	
	if myth.skill.r.range ~= nil and settings.draw.r and rready then
		DrawCircle(me.x, me.y, me.z, myth.skill.r.range, ARGB(125,0,150,255))
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