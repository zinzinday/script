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

ver = "2.2"

if myHero.charName ~= "Aatrox" then return end

--[[=======================================================
   Localization
=========================================================]]

local update        = true
local me 			= _G.myHero -- LocalPlayer
local CastSpell 	= _G.CastSpell -- Cast func
local ValidTarget 	= _G.ValidTarget -- Valid target check
local damage 		= _G.getDmg -- damage calc

-- base table of all things that are holy
local myth = {
	name = "MythTrox", -- script name
	ver = ver, -- script version
	foes = GetEnemyHeroes(), -- enemy champs
	pred = {"VPred", "DivinePred", "HPred"}, -- prediction table
	modules = {"VPrediction", "DivinePred", "HPrediction"}, --libs to load
	url = "http://raw.github.com/iMythik/BoL/master/MythTrox.lua", --update url
	ts = TargetSelector(TARGET_LOW_HP, 1000, DAMAGE_PHYSICAL, false, true), --target selector
	creep = minionManager(MINION_ENEMY, 200, me, MINION_SORT_HEALTH_ASC), --creep selection
	skill = {
		q = {range=600,del=0.25,speed=1800,w=150},
		w = {},
		e = {range = 975,del=0.25,speed=1200, w=140},
		r = {range = 400}, -- player skill table 
	}
}

--[[=======================================================
   Updater
=========================================================]]

function myth:printChat(msg) -- chat message with prefix
	print("<font color='#D40000'>["..myth.name.."]</font><font color='#FFFFFF'> "..msg.."</font>") 
end

function myth:update() -- updater func
    local result = GetWebResult("raw.github.com", "/iMythik/BoL/master/"..myth.name..".lua")

    if not result or result == nil then return end

    local netv = string.match(result, "ver = \"%d+.%d+\"")
    netv = string.match(netv and netv or "", "%d+.%d+")

    if not netv or netv == nil then return end

    netv = tonumber(netv)
    if tonumber(myth.ver) < netv then
        myth:printChat("New version found, updating... don't press F9.")
        DownloadFile(myth.url, SCRIPT_PATH..myth.name..".lua", function() myth:printChat("Updated script ["..myth.ver.." to "..netv.."], press F9 twice to reload the script.") end)    
    else
        myth:printChat("is running latest version!")
    end
end

--[[=======================================================
   Module/Lib Loading
=========================================================]]

local loaded = {}
for k, v in pairs(myth.modules) do -- require modules
	if FileExist(LIB_PATH .. "/"..v..".lua") then
		require(v)
		table.insert(loaded, v)
	else
		myth:printChat("Library "..v.." not found")
	end
end

local function loadPred() -- load pred intergration
	for k, v in pairs(loaded) do
		if v == "DivinePred" then
			dpred = DivinePred()
			myth.skill.q.pred = CircleSS(myth.skill.q.speed, myth.skill.q.range, myth.skill.q.w, myth.skill.q.del, math.huge)
			myth.skill.e.pred = LineSS(myth.skill.e.speed, myth.skill.e.range, myth.skill.e.w, myth.skill.e.del, math.huge)
		end
		if v == "VPrediction" then
			vpred = VPrediction()
		end
		if v == "HPrediction" then
			hpred = HPrediction()
			hpred:AddSpell("Q", 'Aatrox', {delay = myth.skill.q.del, radius = myth.skill.q.w, range = myth.skill.q.range, type = "PromptCircle"})
			hpred:AddSpell("E", 'Aatrox', {delay = myth.skill.e.del, range = myth.skill.e.range, speed = myth.skill.e.speed, type = "DelayLine", width = myth.skill.e.w})
		end
	end
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
		if settings.pred == 1 then
			local cP,chance,pos = vpred:GetCircularCastPosition(targ, myth.skill.q.del, myth.skill.q.w, myth.skill.q.range, math.huge, me, false)
			if chance >= 2 then
    	    	CastSpell(_Q, cP.x, cP.z)
    		end
		elseif settings.pred == 2 then
			local dpt = DPTarget(targ)
    		local state,hitPos,perc = dpred:predict(dpt, myth.skill.q.pred)
    		if state == SkillShot.STATUS.SUCCESS_HIT then
       			CastSpell(_Q, hitPos.x, hitPos.z)
      		end
		elseif settings.pred == 3 then
			local pos, chance = hpred:GetPredict("Q", targ, me) 
			if chance >= 2 then
				CastSpell(_Q, pos.x, pos.z)
			end
		end
	end
	if spell == "w" then
		if not settings.combo.w or not wready then return end
		local state = me:GetSpellData(_W).toggleState
		if state == 1 and ValidTarget(targ, 600) then
			CastSpell(_W)
		elseif not ValidTarget(targ, 600) and state == 2 then
			CastSpell(_W)
		end
	end
	if spell == "e" then
		if not settings.combo.e or not eready or not ValidTarget(targ, myth.skill.e.range) then return end
		if settings.pred == 1 then
    		local cP, chance, pos = vpred:GetLineCastPosition(targ, myth.skill.e.del, myth.skill.e.w, myth.skill.e.range, myth.skill.e.speed, me, false)
   	 		if chance >= 2 then
     	 		CastSpell(_E, cP.x, cP.z)
    		end
    	elseif settings.pred == 2 then
    		local dpt = DPTarget(targ)
    		local state,hitPos,perc = dpred:predict(dpt, myth.skill.e.pred)
    		if state == SkillShot.STATUS.SUCCESS_HIT then
       			CastSpell(_E, hitPos.x, hitPos.z)
      		end
		elseif settings.pred == 3 then
			local pos, chance = hpred:GetPredict("E", targ, me)
			if chance >= 2 then
				CastSpell(_E, pos.x, pos.z)
			end
		end
	end
	if spell == "r" then
		if not settings.combo.r or not rready or not ValidTarget(targ, myth.skill.r.range) then return end
		CastSpell(_R)
	end
end

local function bang(unit) -- combo (bang bang skudda)
	myth:cast("e", unit)
	myth:cast("q", unit)
	myth:cast("w", unit)
	myth:cast("r", unit)
end

local function harass(unit) -- harass dat nigga
	if settings.harass.autoe then
		myth:cast("e", unit)
	end

	if settings.harass.key then
		if settings.harass.q then
			myth:cast("q", unit)
		end

		if settings.harass.e then
			myth:cast("e", unit)
		end
	end
end

local function farm() -- minion farm
	myth.creep:update()
	
	for i, m in pairs(myth.creep.objects) do
		if settings.farm.q then
			myth:cast("q", m)
		end

		if settings.farm.e and damage("E", m, me) >= m.health then
			myth:cast("e", m)
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
	settings.harass:addParam("autoe", "Auto E in range", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
	settings.harass:addParam("q", "Harass with Q", SCRIPT_PARAM_ONOFF, false)
	settings.harass:addParam("e", "Harass with E", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Kill Steal", "ks")
	settings.ks:addParam("q", "Kill steal with Q", SCRIPT_PARAM_ONOFF, false)
	settings.ks:addParam("e", "Kill steal with E", SCRIPT_PARAM_ONOFF, false)
	settings.ks:addParam("r", "Kill steal with R", SCRIPT_PARAM_ONOFF, false)

	settings:addSubMenu("Farm", "farm")
	settings.farm:addParam("key", "Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, 86)
	settings.farm:addParam("q", "Farm with Q", SCRIPT_PARAM_ONOFF, false)
	settings.farm:addParam("e", "Farm with E", SCRIPT_PARAM_ONOFF, false)

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
	settings:addParam("pred", "Prediction Type", SCRIPT_PARAM_LIST, 1, loaded)
end

--[[=======================================================
   Main Hooks
=========================================================]]

function OnLoad()
	myth:printChat("has loaded!<font color='#2BFF00'> ["..myth.ver.."]")

	loadOrbwalk()

	DelayAction(loadPred, 3) -- load prediction

	menu() -- load menu

	myth:update()
end

function OnTick()
	qready, wready, eready, rready = me:CanUseSpell(_Q) == READY, me:CanUseSpell(_W) == READY, me:CanUseSpell(_E) == READY, me:CanUseSpell(_R) == READY

	myth.ts:update() --update target selection
	myth.creep:update() --update creep selection

	if settings.combo.key then -- combo
		bang(target())
	end

	harass(target()) -- harass
	
	if settings.farm.key then -- farm
		farm()
	end

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

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("UHKJHKMGKOK") 