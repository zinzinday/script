local version = "0.4"
--local VIP_USER = false

if myHero.charName ~= "Kalista" then return end
--[[

MLStudio's Kalista v0.1 beta

v0.1 -- First release
v0.2 -- More accurate E dmg calculation and VIP_USER check
v0.3 -- Added jungle steal with E
v0.4 -- New stack tracker method

--]]

local AUTOUPDATE = true
local UPDATE_SCRIPT_NAME = "MLStudio Kalista"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/MLStudio/BoL/master/MLS-Kalista.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>MLStudio Kalista:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
    local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
    if ServerData then
        --PrintChat(tostring(ServerData))
        local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
        ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
        if ServerVersion then
            ServerVersion = tonumber(ServerVersion)
            if tonumber(version) < ServerVersion then
                AutoupdaterMsg("New version available"..ServerVersion)
                AutoupdaterMsg("Updating, please don't press F9")
                DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
            else
                AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
            end
        end
    else
        AutoupdaterMsg("Error downloading version info")
    end
end

if myHero.charName ~= "Kalista" then return end

if VIP_USER then
	require 'VPrediction'
	PrintChat("MLS-Kalista using vPrediction!")
else
	PrintChat("MLS-Kalista using free prediction!")
end

local enemyHeroes = {}
local spellE = myHero:GetSpellData(_E)
local VP = nil
local TP = nil

UpdateWindow()
tSize = math.floor(WINDOW_H/35 + 0.5)
local x = math.floor(WINDOW_W * 0.2 + 0.5)
local y = math.floor(WINDOW_H * 0.015 + 0.5)
local debugMSG = ""
local ts = nil
local tsE = nil
local SpellRangedQ = {Range = 1150, Speed = 1200, Delay = 0.4, Width = 30}

local monsters = {
	{	-- baron
		name = "baron",
		spawn = 900,
		respawn = 420,
		advise = true,
		camps = {
			{
				pos = { x = 4960, y = 60, z = 10420 },
				name = "monsterCamp_12",
				creeps = { { { name = "SRU_Baron12.1.1" }, }, },
				team = TEAM_NEUTRAL,
			},
		},
	},
	{	-- dragon
		name = "dragon",
		spawn = 150,
		respawn = 360,
		advise = true,
		camps = {
			{
				pos = { x = 9846, y = 60, z = 4449 },
				name = "monsterCamp_6",
				creeps = { { { name = "SRU_Dragon6.1.1" }, }, },
				team = TEAM_NEUTRAL,
			},
		},
	},
	{	-- red
		name = "red",
		spawn = 115,
		respawn = 300,
		advise = true,
		camps = {
			{
				pos = { x = 7832, y = 60, z = 4173 },
				name = "monsterCamp_4",
				creeps = { { { name = "SRU_Red4.1.1" }, }, },
				team = TEAM_BLUE,
			},
			{
				pos = { x = 7031, y = 60, z = 10875 },
				name = "monsterCamp_10",
				creeps = { { { name = "SRU_Red10.1.1" }, }, },
				team = TEAM_RED,
			},
		},
	},
	{	-- blue
		name = "blue",
		spawn = 115,
		respawn = 300,
		advise = true,
		camps = {
			{
				pos = { x = 3873, y = 60, z = 8007 },
				name = "monsterCamp_1",
				creeps = { { { name = "SRU_Blue1.1.1" }, }, },
				team = TEAM_BLUE,
			},
			{
				pos = { x = 10935, y = 60, z = 7017 },
				name = "monsterCamp_7",
				creeps = { { { name = "SRU_Blue7.1.1" }, }, },
				team = TEAM_RED,
			},
		},
	},
}

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function Menu()
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, SpellRangedQ.Range, DAMAGE_PHYSICAL)
	ts.name = "Ranged Main"
	tsE = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_PHYSICAL)
	tsE.name = "E Target"
	Config = scriptConfig("Kalista", "Kalista")
	Config:addTS(ts)
	Config:addTS(tsE)
	Config:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Config:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte('C'))
    --Config:addParam("ks", "KS with E", SCRIPT_PARAM_ONOFF, true)
    Config:addSubMenu("Combo options", "ComboSub")
    Config:addSubMenu("Harass options", "HarassSub")
    Config:addSubMenu("KS options", "KSSub")
    Config:addSubMenu("Draw", "Draw")
    Config:addSubMenu("Extra", "Extra")
    Config.ComboSub:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.ComboSub:addParam("autoERange", "Auto E on max range", SCRIPT_PARAM_ONOFF, true)
    Config.ComboSub:addParam("autoE", "Auto E on stacks reached", SCRIPT_PARAM_ONOFF, false)
    Config.ComboSub:addParam("autoEStacks", "Number of stacks reached: ", SCRIPT_PARAM_SLICE, 10, 1, 15, 0)
    Config.HarassSub:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.HarassSub:addParam("autoERange", "Auto E on max range", SCRIPT_PARAM_ONOFF, true)
    Config.HarassSub:addParam("autoE", "Auto E on stacks reached", SCRIPT_PARAM_ONOFF, true)
    Config.HarassSub:addParam("autoEStacks", "Number of stacks reached: ", SCRIPT_PARAM_SLICE, 10, 1, 15, 0)
    Config.KSSub:addParam("ks", "Champion KS with E", SCRIPT_PARAM_ONOFF, true)
    Config.KSSub:addParam("jungle", "Secure jungle with E", SCRIPT_PARAM_ONOFF, true)
    Config.KSSub:addSubMenu("Jungle Creeps to Steal", "creepList")
    for i,monster in pairs(monsters) do
    	Config.KSSub.creepList:addParam(monster.name,firstToUpper(monster.name),SCRIPT_PARAM_ONOFF, true)
    end
    -- Config.KSSub.creepList:addParam("baron","Baron", SCRIPT_PARAM_ONOFF, true)
    -- Config.KSSub.creepList:addParam("dragon","Dragon", SCRIPT_PARAM_ONOFF, true)
    -- Config.KSSub.creepList:addParam("red","Red", SCRIPT_PARAM_ONOFF, true)
    -- Config.KSSub.creepList:addParam("blue","Blue", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
    Config.Draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    Config.Extra:addParam("debug", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
    Config.Extra:addParam("packetCast", "Packet Cast Spells", SCRIPT_PARAM_ONOFF, true)

end

function OnLoad()
	Menu() --initialize Config Menu
	if VIP_USER then
		--PrintChat("Using Vprediction")
		VP = VPrediction()
	end
	TP = TargetPrediction(1150, 1200, 0.46, 30, 100)


	for i = 1, heroManager.iCount do --enemy table for keeping track of stacks of rend
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
            table.insert(enemyHeroes, { object =hero, stack = 0, time = 0})
        end
    end

    for i = 1, objManager.maxObjects do --if jungle creep is in objectmanage, lets "process" it with addcampcreep function
		local object = objManager:getObject(i)
		if object ~= nil then
			addCampCreepAltar(object)
		end
	end

	-- for i,monster in pairs(monsters) do
	-- 	monster.advise = true
	-- end

	AddCreateObjCallback(addCampCreepAltar)  --make sure items that are created or destroyed are processed properly
	AddDeleteObjCallback(removeCreep)

end

function addCampCreepAltar(object)
	if object ~= nil and object.name ~= nil then
		for i,monster in pairs(monsters) do
			for j,camp in pairs(monster.camps) do
				if camp.name == object.name then
					--PrintChat(object.name) --setting monsterCamp
					camp.object = object
					return
				end
				if object.type == "obj_AI_Minion" then  --do this most of the time for SR I guess
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if object.name == creep.name or object.name:find(creep.name) then
								creep.object = object  --set the creep list object to actual object in game
								creep.stack = 0
								creep.time = 0
								return
							end
						end
					end
				end
			end
		end
	end
end

function removeCreep(object)
	if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
		for i,monster in pairs(monsters) do --name == baron level
			for j,camp in pairs(monster.camps) do -- monster_camp# level
				for k,creepPack in ipairs(camp.creeps) do --group of creeps
					for l,creep in ipairs(creepPack) do --individual creep
						if object.name == creep.name or object.name:find(creep.name) then
							creep.object = nil --set jungle list object to nil
							return
						end
					end
				end
			end
		end
	end
end

local lastTick = 0

function OnTick()
	ts:update()
	tsE:update()
	local Elvl = myHero:GetSpellData(_E).level

	if GetTickCount() > lastTick or 1 then
		debugMSG = debugMSG .. '\n'
		for i= 1, #monsters do
			local monster = monsters[i]
			monster.advise = Config.KSSub.creepList[monster.name]
			-- if monster.advise then
			-- 	PrintChat(monster.name .. " is true!")
			-- end
			-- if Config.Extra.debug then
			-- 	debugMSG = debugMSG .. monster.name .. ': ' .. tostring(monster.advise)
			-- end
		end
		-- debugMSG = debugMSG .. '\n'
		lastTick = GetTickCount() + 2000
	end


	debugMSG = "debug: "
	for i, target in pairs(enemyHeroes) do --clear timedout stacks
		if Config.Extra.debug then
			debugMSG = debugMSG .. target.object.charName .. ": " .. tostring(target.stack) ..'    ' .. tostring(GetGameTimer() - target.time) .. '\n'
		end

		if target.stack > 0 and (GetGameTimer() - target.time) > 4 then
			target.stack = 0
		end
	end

	if Config.KSSub.ks then
		for i, target in pairs(enemyHeroes) do
			if ValidTarget(target.object, 1000) and target.stack > 0 then
				-- local dmg = getDmg("E", target.object, myHero, 3) 
				-- dmg = dmg * (1.25 + (Elvl -1)* 0.05)^(target.stack-1)
				-- dmg = dmg * 0.90
				local dmg = eDmgCalc(target.object,target.stack)
				if Config.Extra.debug then
					debugMSG = debugMSG .. "First dmg: " .. tostring(getDmg("E", target.object, myHero, 1)) .. " Second dmg: " .. tostring(getDmg("E", target.object, myHero, 2)*target.stack) 
					.. " Third dmg: " .. tostring(getDmg("E", target.object, myHero, 3)) .. "\nE lvl: " .. tostring(Elvl)
				end
				if target.stack > 0 then
					if target.object.health <= dmg then 
						if Config.Extra.packetCast and VIP_USER then
							packetCast(_E)
						else
							CastSpell(_E)
						end
					end
				end
			end
		end 
	end

	if Config.KSSub.jungle then
		for i,monster in pairs(monsters) do --name = baron level
			for j,camp in pairs(monster.camps) do
				for k,creepPack in ipairs(camp.creeps) do
					for l,creep in ipairs(creepPack) do
						if creep.object ~= nil and creep.object.valid and creep.object.dead == false and creep.stack > 0 and monster.advise then
							local dmg = eDmgCalc(creep.object,creep.stack)
							if dmg >= creep.object.health then
								if Config.Extra.packetCast and VIP_USER then
									packetCast(_E)
								else
									CastSpell(_E)
								end
							end
						end
					end
				end
			end
		end
	end

	if Config.Combo then
		Combo()
	end
	if Config.Harass then
		Harass()
	end
end

function eDmgCalc(unit, stacks)
	local first = {
		dmg = {20, 30, 40, 50, 60},
		scaling = .60
	}
	local adds = {
		dmg = {5, 9, 14, 20, 27},
		scaling = {.15, .18, .21, .24, .27}
	}
	if unit and stacks > 0 then
		local mainDmg  = first.dmg[myHero:GetSpellData(_E).level] + (first.scaling * myHero.totalDamage)
		local extraDmg = (stacks > 1 and (adds.dmg[myHero:GetSpellData(_E).level] + (adds.scaling[myHero:GetSpellData(_E).level] * myHero.totalDamage)) * (stacks - 1)) or 0
		return myHero:CalcDamage(unit, (mainDmg + extraDmg))
	end
end

function Combo()
	local target = ts.target
	if target ~= nil and ValidTarget(target,1200) and myHero:CanUseSpell(_Q) == READY and Config.ComboSub.useQ then
		if not VIP_USER then
			local nextPos, minionCol, nextHealth = TP:GetPrediction(target)
			if nextPos ~= nil and not minionCol then
				CastSpell(_Q,nextPos.x, nextPos.z)
			end
		else
			local castPos, HitChance, Position = VP:GetLineCastPosition(target, 0.46, 30, 1150, 1200, myHero, true)
			if castPos ~= nil and GetDistance(castPos)<SpellRangedQ.Range and HitChance > 0 then
				--PrintChat("castPos x: " .. tostring(castPos.x) .. " castPos z: " .. tostring(castPos.z))
				if Config.Extra.packetCast and VIP_USER then
					packetCast(_Q, castPos.x, castPos.z)
				else
					CastSpell(_Q, castPos.x, castPos.z)
				end
			end
		end
	end

	for i, current in pairs(enemyHeroes) do
		local targets = tsE.target

		if targets ~= nil and targets == current.object then
			local Position, HitChance, myPosition, myHitChance = nil
			local Position, minionCol, nextHealth, myPosition, minionCol, nextHealth   = nil
			if Config.ComboSub.autoERange and myHero:CanUseSpell(_E) == READY and ValidTarget(current.object,1000) and current.stack > 1 then
				if VIP_USER then
					Position, HitChance = VP:GetPredictedPos(current.object, 0.5)
				--PrintChat("Position Predicted: " .. tostring(Position.x) .. ", " .. tostring(Position.z))
					myPosition, myHitChance = VP:GetPredictedPos(myHero,0.5)
				else
					Position, minionCol, nextHealth = TP:GetPrediction(target)
					myPosition, minionCol, nextHealth = TP:GetPrediction(myHero)
				end
				if Config.Extra.debug then
					debugMSG = debugMSG .. "\nPredicted Distance: " .. tostring(GetDistance(Position,myPosition)) .. "\n"
					--PrintChat("Predicted distance: " .. GetDistance(Position,myPosition))
				end
				if GetDistance(Position,myPosition) >= 1000 then
					if Config.Extra.debug then
						PrintChat("Leaving range!")
					end
					if Config.Extra.packetCast and VIP_USER then
						packetCast(_E)
					else
						CastSpell(_E)
					end
				end
			end	
		end
	end
			

	for i, current in pairs(enemyHeroes) do
		if target ~= nil and current.object.name == target.name then
			--PrintChat("Object matches target")
			if Config.ComboSub.autoE and myHero:CanUseSpell(_E) == READY and current.stack >= Config.ComboSub.autoEStacks then
				if Config.Extra.packetCast and VIP_USER then
					packetCast(_E)
				else
					CastSpell(_E)
				end
			end

			-- if Config.ComboSub.autoERange and myHero:CanUseSpell(_E) == READY and ValidTarget(current.object,1000) and current.stack > 1 then
			-- 	local Position, HitChance = VP:GetPredictedPos(current.object, 0.5)
			-- 	--PrintChat("Position Predicted: " .. tostring(Position.x) .. ", " .. tostring(Position.z))
			-- 	local myPosition, myHitChance = VP:GetPredictedPos(myHero,0.5)
			-- 	if Config.Extra.debug then
			-- 		debugMSG = debugMSG .. "\nPredicted Distance: " .. tostring(GetDistance(Position,myPosition)) .. "\n"
			-- 		--PrintChat("Predicted distance: " .. GetDistance(Position,myPosition))
			-- 	end
			-- 	if GetDistance(Position,myPosition) >= 1000 then
			-- 		if Config.Extra.debug then
			-- 			PrintChat("Leaving range!")
			-- 		end
			-- 		if Config.Extra.packetCast and VIP_USER then
			-- 			packetCast(_E)
			-- 		else
			-- 			CastSpell(_E)
			-- 		end
			-- 	end
			-- end
		end
	end
end

function Harass()
	local target = ts.target
	if target ~= nil and ValidTarget(target,1500) and myHero:CanUseSpell(_Q) == READY and Config.HarassSub.useQ then
		if not VIP_USER then
			local nextPos, minionCol, nextHealth = TP:GetPrediction(target)
			if nextPos ~= nil and not minionCol then
				CastSpell(_Q,nextPos.x, nextPos.z)
			end
		else
			local castPos, HitChance, Position = VP:GetLineCastPosition(target, 0.46, 30, 1150, 1200, myHero, true)
			if castPos ~= nil and GetDistance(castPos)<SpellRangedQ.Range and HitChance > 0 then
				--PrintChat("castPos x: " .. tostring(castPos.x) .. " castPos z: " .. tostring(castPos.z))
				if Config.Extra.packetCast and VIP_USER then
					packetCast(_Q, castPos.x, castPos.z)
				else
					CastSpell(_Q, castPos.x, castPos.z)
				end
			end
		end
	end

	for i, current in pairs(enemyHeroes) do
		local targets = tsE.target

		if targets ~= nil and targets == current.object then
			local Position, HitChance, myPosition, myHitChance = nil
			local Position, minionCol, nextHealth, myPosition, minionCol, nextHealth   = nil

			if Config.HarassSub.autoERange and myHero:CanUseSpell(_E) == READY and ValidTarget(current.object,1000) and current.stack > 1 then
				if VIP_USER then
					Position, HitChance = VP:GetPredictedPos(current.object, 0.5)
				--PrintChat("Position Predicted: " .. tostring(Position.x) .. ", " .. tostring(Position.z))
					myPosition, myHitChance = VP:GetPredictedPos(myHero,0.5)
				else
					Position, minionCol, nextHealth = TP:GetPrediction(target)
					myPosition, minionCol, nextHealth = TP:GetPrediction(myHero)
				end
				if Config.Extra.debug then
					debugMSG = debugMSG .. "\nPredicted Distance: " .. tostring(GetDistance(Position,myPosition)) .. "\n"
					--PrintChat("Predicted distance: " .. GetDistance(Position,myPosition))
				end
				if GetDistance(Position,myPosition) >= 1000 then
					if Config.Extra.debug then
						PrintChat("Leaving range!")
					end
					if Config.Extra.packetCast and VIP_USER then
						packetCast(_E)
					else
						CastSpell(_E)
					end
				end
			end
		end
	end


	for i, current in pairs(enemyHeroes) do

		if target ~= nil and current.object.name == target.name then
			--PrintChat("Object matches target")
			if Config.HarassSub.autoE and myHero:CanUseSpell(_E) == READY and current.stack >= Config.HarassSub.autoEStacks then
				if Config.Extra.packetCast and VIP_USER then
					packetCast(_E)
				else
					CastSpell(_E)
				end
			end

			-- if Config.HarassSub.autoERange and myHero:CanUseSpell(_E) == READY and ValidTarget(current.object,1000) and current.stack > 1 then
			-- 	local Position, HitChance = VP:GetPredictedPos(current.object, 0.5)
			-- 	--PrintChat("Position Predicted: " .. tostring(Position.x) .. ", " .. tostring(Position.z))
			-- 	local myPosition, myHitChance = VP:GetPredictedPos(myHero,0.5)
			-- 	if Config.Extra.debug then
			-- 		debugMSG = debugMSG .. "\nPredicted Distance: " .. tostring(GetDistance(Position,myPosition)) .. "\n"
			-- 		--PrintChat("Predicted distance: " .. GetDistance(Position,myPosition))
			-- 	end
			-- 	if GetDistance(Position,myPosition) >= 1000 then
			-- 		if Config.Extra.debug then
			-- 			PrintChat("Leaving range!")
			-- 		end
			-- 		if Config.Extra.packetCast and VIP_USER then
			-- 			packetCast(_E)
			-- 		else
			-- 			CastSpell(_E)
			-- 		end
			-- 	end
			-- end
		end
	end

end

function OnDraw()
	if Config.Extra.debug then
		DrawText(debugMSG,tSize,x,y,0xFFFF0000)
	end

	if Config.Draw.drawE and myHero:CanUseSpell(_E) == READY then
		DrawCircle(myHero.x, myHero.y, myHero.z, 1000, ARGB(200,17,17,17))
	end

	if Config.Draw.drawQ and myHero:CanUseSpell(_Q) == READY then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, 1150, 1, ARGB(100,0,255,0),100)
	end

end

function OnGainBuff(unit, buff)
	if buff.source == myHero and buff.name == 'kalistaexpungemarker' then
		for i, target in ipairs(enemyHeroes) do
			if target.object == unit then
				target.stack = 1
				target.time = GetGameTimer()
			end
		end
	end
end

function OnUpdateBuff(unit, buff)
	if buff.source == myHero and buff.name == 'kalistaexpungemarker' then
		for i, target in ipairs(enemyHeroes) do
			if target.object == unit then
				target.stack = target.stack + 1
				target.time = GetGameTimer()
			end
		end
	end
end

function OnLoseBuff(unit, buff)
	if buff.name == 'kalistaexpungemarker' then
		for i, target in ipairs(enemyHeroes) do
			if target.object == unit then
				target.stack = 0
			end
		end
	end
end

function OnCreateObj(obj)
	-- for i, target in pairs(enemyHeroes) do

 -- 		if GetDistance(target.object, obj) <80 then
 -- 			if obj.name == "Kalista_Base_E_Spear_tar6.troy" then
 -- 				if target.stack < 6 then
 -- 					target.stack = 6
 -- 				end
 -- 				target.time = GetGameTimer()

	-- 	 	elseif obj.name == "Kalista_Base_E_Spear_tar5.troy" then
	-- 	 		if target.stack < 6 then
 -- 					target.stack = 5
 -- 				end
	-- 	 		target.time = GetGameTimer()
	-- 	 	elseif obj.name == "Kalista_Base_E_Spear_tar4.troy" then
	-- 	 		if target.stack < 6 then
 -- 					target.stack = 4
 -- 				end
	-- 	 		target.time = GetGameTimer()
	-- 	 	elseif obj.name == "Kalista_Base_E_Spear_tar3.troy" then
	-- 	 		if target.stack < 6 then
 -- 					target.stack = 3
 -- 				end
	-- 	 		target.time = GetGameTimer()
	-- 	 	elseif obj.name == "Kalista_Base_E_Spear_tar2.troy" then
	-- 	 		if target.stack < 6 then
 -- 					target.stack = 2
 -- 				end
	-- 	 		target.time = GetGameTimer()
	-- 	 	elseif obj.name == "Kalista_Base_E_Spear_tar1.troy" then
	-- 	 		if target.stack < 6 then
 -- 					target.stack = 1
 -- 				end
	-- 	 		target.time = GetGameTimer()
	-- 	 	end
	-- 	end
	-- end

	for i,monster in pairs(monsters) do --name = baron level
		for j,camp in pairs(monster.camps) do
			for k,creepPack in ipairs(camp.creeps) do
				for l,creep in ipairs(creepPack) do
					if creep.object ~= nil and creep.object.valid and creep.object.dead == false and GetDistance(creep.object,obj) < 80 then
						if obj.name == "Kalista_Base_E_Spear_tar6.troy" then
			 				if creep.stack < 6 then
			 					creep.stack = 6
			 				end
			 				creep.time = GetGameTimer()

					 	elseif obj.name == "Kalista_Base_E_Spear_tar5.troy" then
					 		if creep.stack < 6 then
			 					creep.stack = 5
			 				end
					 		creep.time = GetGameTimer()
					 	elseif obj.name == "Kalista_Base_E_Spear_tar4.troy" then
					 		if creep.stack < 6 then
			 					creep.stack = 4
			 				end
					 		creep.time = GetGameTimer()
					 	elseif obj.name == "Kalista_Base_E_Spear_tar3.troy" then
					 		if creep.stack < 6 then
			 					creep.stack = 3
			 				end
					 		creep.time = GetGameTimer()
					 	elseif obj.name == "Kalista_Base_E_Spear_tar2.troy" then
					 		if creep.stack < 6 then
			 					creep.stack = 2
			 				end
					 		creep.time = GetGameTimer()
					 	elseif obj.name == "Kalista_Base_E_Spear_tar1.troy" then
					 		if creep.stack < 6 then
			 					creep.stack = 1
			 				end
					 		creep.time = GetGameTimer()
					 	end
					end
				end
			end
		end
	end
end

function OnProcessSpell(unit, spell) 
    if unit.isMe then 
        if spell.name == spellE.name then
        	--PrintChat(spell.name .. " was cast! Stacks cleared!")
        	for i, target in pairs(enemyHeroes) do
        		target.stack = 0
        	end
        end

        for i,monster in pairs(monsters) do --name = baron level
			for j,camp in pairs(monster.camps) do
				for k,creepPack in ipairs(camp.creeps) do
					for l,creep in ipairs(creepPack) do
						creep.stack = 0
					end
				end
			end
		end

        if spell.name:lower():find("attack") then
        	--PrintChat(spell.target.name)
        	--PrintChat(tostring(spell.windUpTime))
        	-- for i, target in pairs(enemyHeroes) do
        	-- 	if spell.target == target.object then
        	-- 		if target.stack > 5 then
        	-- 			DelayAction(function() target.stack = target.stack + 1 end,spell.windUpTime)
        	-- 		end
        	-- 	end
        	-- end

        	for i,monster in pairs(monsters) do --name = baron level
				for j,camp in pairs(monster.camps) do
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if spell.target == creep.object then
								if creep.stack > 5 then
									DelayAction(function() creep.stack = creep.stack + 1 end,spell.windUpTime)
								end
							end
						end
					end
				end
			end
        end
    end
end

function packetCast(id, param1, param2)
    if param1 ~= nil and param2 ~= nil then
    Packet("S_CAST", {spellId = id, toX = param1, toY = param2, fromX = param1, fromY = param2}):send()
    elseif param1 ~= nil then
    Packet("S_CAST", {spellId = id, toX = param1.x, toY = param1.z, fromX = param1.x, fromY = param1.z, targetNetworkId = param1.networkID}):send()
    else
    Packet("S_CAST", {spellId = id, toX = player.x, toY = player.z, fromX = player.x, fromY = player.z, targetNetworkId = player.networkID}):send()
    end
end

-- function DelayAddStack(i)
-- 	local target = enemyHeroes[i]
-- 	if target~= nil then
-- 		target.stack = target.stack + 1
-- 	end
-- end