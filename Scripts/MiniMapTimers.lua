local version = "0.33"

--[[
    Mini Map Timers v0.3

    updated by MLStudio for patch 4.20 and the new summoner's rift

]]--    



local AUTOUPDATE = true
local UPDATE_SCRIPT_NAME = "MiniMapTimers"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/MLStudio/BoL/master/MiniMapTimers.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>MiniMapTimers:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
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


--[[updated by MLStudio for patch 4.20 and the new summoner's rift]]

do
	--[[      GLOBAL      ]]
	monsters = {
		summonerRift = {
			{	-- baron
				name = "baron",
				spawn = 900,
				respawn = 420,
				advise = true,
				sendChat = true,
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
				sendChat = true,
				camps = {
					{
						pos = { x = 9846, y = 60, z = 4449 },
						name = "monsterCamp_6",
						creeps = { { { name = "SRU_Dragon6.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- blue
				name = "blue",
				spawn = 115,
				respawn = 300,
				advise = true,
				sendChat = true,
				camps = {
					{
						pos = { x = 3873, y = 60, z = 8007 },
						name = "monsterCamp_1",
						creeps = { { { name = "SRU_Blue1.1.1" }, { name = "SRU_BlueMini1.1.2" }, { name = "SRU_BlueMini21.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						pos = { x = 10935, y = 60, z = 7017 },
						name = "monsterCamp_7",
						creeps = { { { name = "SRU_Blue7.1.1" }, { name = "SRU_BlueMini7.1.2" }, { name = "SRU_BlueMini27.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- red
				name = "red",
				spawn = 115,
				respawn = 300,
				advise = true,
				sendChat = true,
				camps = {
					{
						pos = { x = 7832, y = 60, z = 4173 },
						name = "monsterCamp_4",
						creeps = { { { name = "SRU_Red4.1.1" }, { name = "SRU_RedMini4.1.2" }, { name = "SRU_RedMini4.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						pos = { x = 7031, y = 60, z = 10875 },
						name = "monsterCamp_10",
						creeps = { { { name = "SRU_Red10.1.1" }, { name = "SRU_RedMini10.1.2" }, { name = "SRU_RedMini10.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- wolves
				name = "murkwolves", --old wolves
				spawn = 115,
				respawn = 100,
				advise = false,
				camps = {
					{
						name = "monsterCamp_2",
						creeps = { { { name = "SRU_Murkwolf2.1.1" }, { name = "SRU_MurkwolfMini2.1.2" }, { name = "SRU_MurkwolfMini2.1.3" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_8",
						creeps = { { { name = "SRU_Murkwolf8.1.1" }, { name = "SRU_MurkwolfMini8.1.2" }, { name = "SRU_MurkwolfMini8.1.3" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- wraiths
				name = "razorbeaks", --old wraithes
				spawn = 115,
				respawn = 100,
				advise = false,
				camps = {
					{
						--pos = { x = 6923, y = 60, z = 5469 },
						name = "monsterCamp_3",
						creeps = { { { name = "SRU_Razorbeak3.1.1" }, { name = "SRU_RazorbeakMini3.1.2" }, { name = "SRU_RazorbeakMini3.1.3" }, { name = "SRU_RazorbeakMini3.1.4" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_9",
						creeps = { { { name = "SRU_Razorbeak9.1.1" }, { name = "SRU_RazorbeakMini9.1.2" }, { name = "SRU_RazorbeakMini9.1.3" }, { name = "SRU_RazorbeakMini9.1.4" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- GreatWraiths
				name = "Gromp", --Used to be great wraiths
				spawn = 115,
				respawn = 100,
				advise = false,
				camps = {
					{
						name = "monsterCamp_13",
						creeps = { { { name = "SRU_Gromp13.1.1" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_14",
						creeps = { { { name = "SRU_Gromp14.1.1" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- Golems
				name = "Krugs",
				spawn = 115,
				respawn = 100,
				advise = false,
				camps = {
					{
						name = "monsterCamp_5",
						creeps = { { { name = "SRU_Krug5.1.2" }, { name = "SRU_KrugMini5.1.1" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_11",
						creeps = { { { name = "SRU_Krug11.1.2" }, { name = "SRU_KrugMini11.1.1" }, }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- ScuttleBug
				name = "ScuttleBug",
				spawn = 150,
				respawn = 180,
				advise = false,
				camps = {
					{
						name = "monsterCamp_15",
						creeps = { { { name = "Sru_Crab15.1.1" }, }, },
						team = TEAM_BLUE,
					},
					{
						name = "monsterCamp_16",
						creeps = { { { name = "Sru_Crab16.1.1" }, }, },
						team = TEAM_RED,
					},
				},
			},
		},

		twistedTreeline = {
			{	-- Wraith
				name = "Wraith",
				spawn = 100,
				respawn = 50,
				advise = false,
				camps = {
					{
						--pos = { x = 4414, y = 60, z = 5774 },
						name = "monsterCamp_1",
						creeps = {
							{ { name = "TT_NWraith1.1.1" }, { name = "TT_NWraith21.1.2" }, { name = "TT_NWraith21.1.3" }, },
						},
						team = TEAM_BLUE,
					},
					{
						--pos = { x = 11008, y = 60, z = 5775 },
						name = "monsterCamp_4",
						creeps = {
							{ { name = "TT_NWraith4.1.1" }, { name = "TT_NWraith24.1.2" }, { name = "TT_NWraith24.1.3" }, },
						},
						team = TEAM_RED,
					},
				},
			},
			{	-- Golems
				name = "Golems",
				respawn = 50,
				spawn = 100,
				advise = false,
				camps = {
					{
						--pos = { x = 5088, y = 60, z = 8065 },
						name = "monsterCamp_2",
						creeps = {
							{ { name = "TT_NGolem2.1.1" }, { name = "TT_NGolem22.1.2" } },
						},
						team = TEAM_BLUE,
					},
					{
						--pos = { x = 10341, y = 60, z = 8084 },
						name = "monsterCamp_5",
						creeps = {
							{ { name = "TT_NGolem5.1.1" }, { name = "TT_NGolem25.1.2" } },
						},
						team = TEAM_RED,
					},
				},
			},
			{	-- Wolves
				name = "Wolves",
				respawn = 50,
				spawn = 100,
				advise = false,
				camps = {
					{
						--pos = { x = 6148, y = 60, z = 5993 },
						name = "monsterCamp_3",
						creeps = { { { name = "TT_NWolf3.1.1" }, { name = "TT_NWolf23.1.2" }, { name = "TT_NWolf23.1.3" } }, },
						team = TEAM_BLUE,
					},
					{
						--pos = { x = 9239, y = 60, z = 6022 },
						name = "monsterCamp_6",
						creeps = { { { name = "TT_NWolf6.1.1" }, { name = "TT_NWolf26.1.2" }, { name = "TT_NWolf26.1.3" } }, },
						team = TEAM_RED,
					},
				},
			},
			{	-- Heal
				name = "Heal",
				spawn = 115,
				respawn = 90,
				advise = true,
				camps = {
					{
						pos = { x = 7711, y = 60, z = 6722 },
						name = "monsterCamp_7",
						creeps = { { { name = "TT_Relic7.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
			{	-- Vilemaw
				name = "Vilemaw",
				spawn = 600,
				respawn = 300,
				advise = true,
				camps = {
					{
						pos = { x = 7711, y = 60, z = 10080 },
						name = "monsterCamp_8",
						creeps = { { { name = "TT_Spiderboss8.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
		},
		crystalScar = {},
		provingGrounds = {
			{	-- Heal
				name = "Heal",
				spawn = 190,
				respawn = 40,
				advise = false,
				camps = {
					{
						pos = { x = 8922, y = 60, z = 7868 },
						name = "monsterCamp_1",
						creeps = { { { name = "OdinShieldRelic1.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 7473, y = 60, z = 6617 },
						name = "monsterCamp_2",
						creeps = { { { name = "OdinShieldRelic2.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 5929, y = 60, z = 5190 },
						name = "monsterCamp_3",
						creeps = { { { name = "OdinShieldRelic3.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 4751, y = 60, z = 3901 },
						name = "monsterCamp_4",
						creeps = { { { name = "OdinShieldRelic4.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
		},
		howlingAbyss = {
			{	-- Heal
				name = "Heal",
				spawn = 190,
				respawn = 40,
				advise = false,
				camps = {
					{
						pos = { x = 8922, y = 60, z = 7868 },
						name = "monsterCamp_1",
						creeps = { { { name = "HA_AP_HealthRelic1.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 7473, y = 60, z = 6617 },
						name = "monsterCamp_2",
						creeps = { { { name = "HA_AP_HealthRelic2.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 5929, y = 60, z = 5190 },
						name = "monsterCamp_3",
						creeps = { { { name = "HA_AP_HealthRelic3.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
					{
						pos = { x = 4751, y = 60, z = 3901 },
						name = "monsterCamp_4",
						creeps = { { { name = "HA_AP_HealthRelic4.1.1" }, }, },
						team = TEAM_NEUTRAL,
					},
				},
			},
		},
	}

	altars = {
		summonerRift = {},
		twistedTreeline = {
			{
				name = "Left Altar",
				spawn = 180,
				respawn = 85,
				advise = true,
				objectName = "TT_Buffplat_L",
				locked = false,
				lockNames = {"TT_Lock_Blue_L.troy", "TT_Lock_Purple_L.troy", "TT_Lock_Neutral_L.troy", },
				unlockNames = {"TT_Unlock_Blue_L.troy", "TT_Unlock_purple_L.troy", "TT_Unlock_Neutral_L.troy", },
			},
			{
				name = "Right Altar",
				spawn = 180,
				respawn = 85,
				advise = true,
				objectName = "TT_Buffplat_R",
				locked = false,
				lockNames = {"TT_Lock_Blue_R.troy", "TT_Lock_Purple_R.troy", "TT_Lock_Neutral_R.troy", },
				unlockNames = {"TT_Unlock_Blue_R.troy", "TT_Unlock_purple_R.troy", "TT_Unlock_Neutral_R.troy", },
			},
		},
		crystalScar = {},
		provingGrounds = {},
		howlingAbyss = {},
	}

	relics = {
		summonerRift = {},
		twistedTreeline = {},
		crystalScar = {
			{
				pos = { x = 5500, y = 60, z = 6500 },
				name = "Relic",
				team = TEAM_BLUE,
				spawn = 180,
				respawn = 180,
				advise = true,
				locked = false,
				precenceObject = (player.team == TEAM_BLUE and "Odin_Prism_Green.troy" or "Odin_Prism_Red.troy"),
			},
			{
				pos = { x = 7550, y = 60, z = 6500 },
				name = "Relic",
				team = TEAM_RED,
				spawn = 180,
				respawn = 180,
				advise = true,
				locked = false,
				precenceObject = (player.team == TEAM_RED and "Odin_Prism_Green.troy" or "Odin_Prism_Red.troy"),
			},
		},
		provingGrounds = {},
		howlingAbyss = {},
	}

	heals = {
		summonerRift = {},
		twistedTreeline = {},
		provingGrounds = {},
		crystalScar = {
			{
				name = "Heal",
				objectName = "OdinShieldRelic",
				respawn = 30,
				objects = {},
			},
		},
		howlingAbyss = {},
	}

	inhibitors = {}

	function addCampCreepAltar(object)
		if object ~= nil and object.name ~= nil then
			if object.name == "sruap_order_inhibitor_idle.troy" or object.name == "sruap_chaos_inhibitor_idle.troy" then --if inhibitor is alive, then add to list of inhibitors
				table.insert(inhibitors, { object = object, destroyed = false, lefttime = 0, x = object.x, y = object.y, z = object.z, minimap = GetMinimap(object), textTick = 0 })
				return
			elseif object.name == "SRU_Order_Inhibitor_explosion.troy" or object.name == "SRU_Chaos_Inhibitor_explosion.troy" or object.name:lower():find("explosion") then  --if inhibitor destroyed, then mark as destroyed
				--PrintChat(object.name)
				for i,inhibitor in pairs(inhibitors) do
					if GetDistance(inhibitor, object) < 200 then
						--local tick = GetTickCount()
						local tick = GetInGameTimer()*1000
						inhibitor.dtime = tick
						inhibitor.rtime = tick + 300000
						inhibitor.ltime = 300000
						inhibitor.destroyed = true
					end
				end
				return
			end
			for i,monster in pairs(monsters[mapName]) do  -- monster_camp init
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
									camp.manual = false
									return
								end
							end
						end
					end
				end
			end
			for i,altar in pairs(altars[mapName]) do  --Altars for Twisted Treeline (who cares)
				if altar.objectName == object.name then
					altar.object = object
					altar.textTick = 0
					altar.minimap = GetMinimap(object)
				end
				if altar.locked then
					for j,lockName in pairs(altar.unlockNames) do
						if lockName == object.name then
							altar.locked = false
							return
						end
					end
				else
					for j,lockName in pairs(altar.lockNames) do
						if lockName == object.name then
							altar.drawColor = 0
							altar.drawText = ""
							altar.locked = true
							altar.advised = false
							altar.advisedBefore = false
							return
						end
					end
				end
			end
			for i,relic in pairs(relics[mapName]) do
				if relic.precenceObject == object.name then
					relic.object = object
					relic.textTick = 0
					relic.locked = false
					return
				end
			end
			for i,heal in pairs(heals[mapName]) do
				if heal.objectName == object.name then
					for j,healObject in pairs(heal.objects) do
						if (GetDistance(healObject, object) < 50) then
							healObject.object = object
							healObject.found = true
							healObject.locked = false
							return
						end
					end
					local k = #heal.objects + 1
					heals[mapName][i].objects[k] = {found = true, locked = false, object = object, x = object.x, y = object.y, z = object.z, minimap = GetMinimap(object), textTick = 0,}
					return
				end
			end
		end
	end

	function removeCreep(object)
		if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
			for i,monster in pairs(monsters[mapName]) do --name == baron level
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

local debugText = ""
UpdateWindow()
tSize = math.floor(WINDOW_H/35 + 0.5)
local x = math.floor(WINDOW_W * 0.2 + 0.5)
local y = math.floor(WINDOW_H * 0.015 + 0.5)
local campInit = true
local msgTick = 0

local dumpFile = LIB_PATH.."miniMapDump.csv"
local dump = {}
local record = false

function round2(num, idp)
	local mult = 10^(idp or 0)
  	local answer = math.floor(num * mult + 0.5) / mult
  	return tostring(answer)
end

function saveToFile()
	local file = io.open(dumpFile, "w")
	file:write("Camp Name,Camp Status, Camp Manual, Camp Object, Camp Respawn Time,Camp isSeen\n")
	for i,monster in pairs(monsters[mapName]) do --name = baron level
		for j,camp in pairs(monster.camps) do
			local campObject = false
			for k,creepPack in ipairs(camp.creeps) do
				for l,creep in ipairs(creepPack) do
					if creep.object then
						campObject = true
					end
				end
			end

			file:write(monster.name .. ', '.. tostring(camp.status) ..', ' .. tostring(camp.manual) .. ', '.. tostring(campObject) .. ', ' .. tostring(camp.respawnTime) .. ', ' .. tostring(monster.isSeen) .. '\n')
		end
	end
	file:close()
end

	function OnLoad()
		mapName = GetGame().map.shortName
		if monsters[mapName] == nil then
			mapName = nil
			monsters = nil
			addCampCreepAltar = nil
			removeCreep = nil
			addAltarObject = nil
			return
		else
			startTick = GetGame().tick
			-- CONFIG
			local scriptName = "Timers " .. tostring(version)
			MMTConfig = scriptConfig(scriptName, "minimapTimers")
			MMTConfig:addParam("pingOnRespawn", "Ping on respawn", SCRIPT_PARAM_ONOFF, false) -- ping location on respawn
			MMTConfig:addParam("pingOnRespawnBefore", "Ping before respawn", SCRIPT_PARAM_ONOFF, false) -- ping location before respawn
			MMTConfig:addParam("textOnRespawn", "Chat on respawn", SCRIPT_PARAM_ONOFF, true) -- print chat text on respawn
			MMTConfig:addParam("textOnRespawnBefore", "Chat before respawn", SCRIPT_PARAM_ONOFF, true) -- print chat text before respawn
			MMTConfig:addParam("adviceTheirMonsters", "Give Chat Warning for Enemy Creeps", SCRIPT_PARAM_ONOFF, true) -- advice enemy monster, or just our monsters
			MMTConfig:addParam("adviceBefore", "Chat Warning Time Interval", SCRIPT_PARAM_SLICE, 20, 1, 40, 0) -- time in second to advice before monster respawn
			MMTConfig:addParam("textOnMap", "Text on map", SCRIPT_PARAM_ONOFF, true) -- time in second on map
			MMTConfig:addParam("secondsMode","Give shift+click time in second", SCRIPT_PARAM_ONOFF, false)
			for i,monster in pairs(monsters[mapName]) do
				monster.isSeen = false
				for j,camp in pairs(monster.camps) do  --initialize starting values
					camp.enemyTeam = (camp.team == TEAM_ENEMY)
					camp.textTick = 0
					camp.status = 0
					camp.drawText = ""
					camp.drawColor = 0xFF00FF00
				end
			end
			for i = 1, objManager.maxObjects do --if jungle creep is in objectmanage, lets "process" it with addcampcreep function
				local object = objManager:getObject(i)
				if object ~= nil then
					addCampCreepAltar(object)
				end
			end
			AddCreateObjCallback(addCampCreepAltar)  --make sure items that are created or destroyed are processed properly
			AddDeleteObjCallback(removeCreep)
		end
	end
	function OnTick()
		-- if campInit == false then
		-- 	local negativeFound = false
		-- 	for i,monster in pairs(monsters[mapName]) do --name = baron level
		-- 		for j,camp in pairs(monster.camps) do
		-- 			if camp == nil then
		-- 				negativeFound = true
		-- 			end
		-- 		end
		-- 	end
		-- 	if negativeFound == false then
		-- 		campInit = true
		-- 		PrintChat("fully initialized!!")
		-- 	end
		-- end
		if GetGame().isOver then return end
		-- local GameTime = (GetTickCount()-startTick) / 1000
		local GameTime = GetInGameTimer()
		local monsterCount = 0
		for i,monster in pairs(monsters[mapName]) do --name = baron level
			for j,camp in pairs(monster.camps) do --monster_camp# level
				-- if campInit == false then
				-- 	for j = 1, objManager.maxObjects do
				-- 		local object = objManager:getObject(j)
				-- 		if object ~= nil then
				-- 			addCampCreepAltar(object)
				-- 		end
				-- 	end
				-- end

				local campStatus = 0

				if camp.manual then
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if creep.object ~= nil and creep.object.valid and creep.object.dead == false and creep.object.visible then
								camp.manual = false
								if l == 1 then --first creep in creep pack
									campStatus = 1 --creep is alive, set status 1
								elseif campStatus ~= 1 then
									campStatus = 2  --creep is alive, secondary creep set status as 2
								end
							end
						end
					end
				else
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if creep.object ~= nil and creep.object.valid and creep.object.dead == false then
								if l == 1 then --first creep in creep pack
									campStatus = 1 --creep is alive, set status 1
								elseif campStatus ~= 1 then
									campStatus = 2  --creep is alive, secondary creep set status as 2
								end
							end
						end
					end
				end
				-- if not camp.manual then
				-- 	for k,creepPack in ipairs(camp.creeps) do
				-- 		for l,creep in ipairs(creepPack) do
				-- 			if creep.object ~= nil and creep.object.valid and creep.object.dead == false then
				-- 				if l == 1 then --first creep in creep pack
				-- 					campStatus = 1 --creep is alive, set status 1
				-- 				elseif campStatus ~= 1 then
				-- 					campStatus = 2  --creep is alive, secondary creep set status as 2
				-- 				end
				-- 			end
				-- 		end
				-- 	end
				-- else
				-- 	for k,creepPack in ipairs(camp.creeps) do
				-- 		for l,creep in ipairs(creepPack) do
				-- 			if creep.object ~= nil and creep.object.valid and creep.object.dead == false and creep.visible then
				-- 				if l == 1 then --first creep in creep pack
				-- 					campStatus = 1 --creep is alive, set status 1
				-- 				elseif campStatus ~= 1 then
				-- 					campStatus = 2  --creep is alive, secondary creep set status as 2
				-- 				end
				-- 			end
				-- 		end
				-- 	end
				-- end

				--[[Camp status so far:
				1 means main creep alive
				2 means only secondary creep alive

				]]
				--[[  Not used until camp.showOnMinimap work
				if (camp.object and camp.object.showOnMinimap == 1) then
				-- camp is here
				if campStatus == 0 then campStatus = 3 end
				elseif camp.status == 3 then 						-- empty not seen when killed
				campStatus = 5
				elseif campStatus == 0 and (camp.status == 1 or camp.status == 2) then
				campStatus = 4
				camp.deathTick = tick
				end
				]]
				-- temp fix until camp.showOnMinimap work
				-- not so good
				if camp.object ~= nil and camp.object.valid then
					camp.minimap = GetMinimap(camp.object)
					if campStatus == 0 then --if there are no live creeps in camp
						if (camp.status == 1 or camp.status == 2) then --we previously thought it was alive
							campStatus = 4 --we set it's status to 4 now
							camp.advisedBefore = false
							camp.advised = false
							camp.respawnTime = math.floor(GameTime) + monster.respawn --we set its fresh respawn time
							if monster.name == "dragon" or monster.name == "baron" then --if it is dragon or baron
								if MMTConfig.secondsMode == false then
									camp.respawnText = TimerText(camp.respawnTime) ..--format respawntime as timer
									(monster.name == "baron" and " baron" or " dragon")
								else
									camp.respawnText = round2(camp.respawnTime-GameTime,-1) .. ' seconds' .. 
									(monster.name == "baron" and " baron" or " dragon")
								end

							elseif monster.name == "blue" or monster.name == "red" then
								if MMTConfig.secondsMode == false then
									camp.respawnText = TimerText(camp.respawnTime)..
									(camp.enemyTeam and " t" or " o")..(monster.name == "red" and "r" or "b")
								else
									camp.respawnText = round2(camp.respawnTime-GameTime,-1).. ' seconds' ..
									(camp.enemyTeam and " t" or " o")..(monster.name == "red" and "r" or "b")
								end
							elseif monster.name == "ScuttleBug" then
								if MMTConfig.secondsMode == false then
									camp.respawnText = TimerText(camp.respawnTime)..
									(camp.team == TEAM_BLUE and " dragon " or " baron ") .. monster.name
								else
									camp.respawnText = round2(camp.respawnTime-GameTime,-1).. ' seconds' ..
									(camp.team == TEAM_BLUE and " dragon " or " baron ") .. monster.name
								end
							else
								if MMTConfig.secondsMode == false then
									camp.respawnText = (camp.enemyTeam and "Their " or "Our ")..
									monster.name.." respawn at "..TimerText(camp.respawnTime)
								else
									camp.respawnText = round2(camp.respawnTime-GameTime,-1) .. ' seconds '..
									(camp.enemyTeam and "their " or "our ") .. monster.name
								end
							end
						elseif (camp.status == 4) then --this condition means we already knew camp was dead and will set temp variable to 4
							campStatus = 4
						else
							campStatus = 3
						end
					end
				elseif camp.pos ~= nil then  --if we don't have object, but we have coordinates instead
					camp.minimap = GetMinimap(camp.pos) --get minimap position for drawing
					if (GameTime < monster.spawn) then --camp has not yet spawned
						campStatus = 4
						camp.advisedBefore = true
						camp.advised = true
						camp.respawnTime = monster.spawn
						camp.respawnText = (camp.enemyTeam and "Their " or "Our ")..monster.name.." spawn at "..TimerText(camp.respawnTime)
					end
				end
				if camp.status ~= campStatus or campStatus == 4 then
					if campStatus ~= 0 then
						if monster.isSeen == false then monster.isSeen = true end
						camp.status = campStatus
					end
					if camp.status == 1 then				-- ready
						camp.drawText = "ready"
						camp.drawColor = 0xFF00FF00
					elseif camp.status == 2 then			-- ready, master creeps dead
						camp.drawText = "stolen"
						camp.drawColor = 0xFFFF0000
					elseif camp.status == 3 then			-- ready, not creeps shown
						camp.drawText = "   ?"
						camp.drawColor = 0xFF00FF00
					elseif camp.status == 4 then			-- empty from creeps kill
						local secondLeft = math.ceil(math.max(0, camp.respawnTime - GameTime)) --how many seconds left until respawn
						if monster.advise == true and (MMTConfig.adviceTheirMonsters == true or camp.enemyTeam == false) then
							if secondLeft == 0 and camp.advised == false then
								camp.advised = true --just spawned so printchat alert
								if MMTConfig.textOnRespawn then PrintChat("<font color=\"#FFFFFF\">"..(camp.enemyTeam and "Their " or "Our ")..monster.name.." has respawned" .. ".</font>") end
								if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
							elseif secondLeft <= MMTConfig.adviceBefore and camp.advisedBefore == false then
								camp.advisedBefore = true --20 seconds before so printchat alert
								if MMTConfig.textOnRespawnBefore then PrintChat("<font color=\"#FFFFFF\">" .. (camp.enemyTeam and "Their " or "Our ") .. monster.name .. " respawns in ".. tostring(secondLeft) .. ".</font>") end
								if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
							end
						end
						-- temp fix until camp.showOnMinimap work
						if secondLeft == 0 then
							camp.status = 0
						end
						camp.drawText = " "..TimerText(secondLeft)
						camp.drawColor = 0xFFFFFF00
					elseif camp.status == 5 then			-- camp found empty (not using yet)
						camp.drawText = "   -"
						camp.drawColor = 0xFFFF0000
					end
				end
				-- shift click
				if IsKeyDown(16) and camp.status == 4 then
					camp.drawText = " "..(camp.respawnTime ~= nil and TimerText(camp.respawnTime) or "")
					camp.textUnder = (CursorIsUnder(camp.minimap.x - 9, camp.minimap.y - 5, 20, 8))
					camp.textUnder = camp.textUnder or GetDistance(camp.object, mousePos) < 200

					if monster.name == "dragon" or monster.name == "baron" then --if it is dragon or baron
						if MMTConfig.secondsMode == false or camp.respawnTime - GameTime > 60 then
							camp.respawnText = TimerText(camp.respawnTime) ..--format respawntime as timer
							(monster.name == "baron" and " baron" or " dragon")
						else
							camp.respawnText = round2(camp.respawnTime-GameTime,-1) .. ' seconds' .. 
							(monster.name == "baron" and " baron" or " dragon")
						end

					elseif monster.name == "blue" or monster.name == "red" then
						if MMTConfig.secondsMode == false then
							camp.respawnText = TimerText(camp.respawnTime)..
							(camp.enemyTeam and " t" or " o")..(monster.name == "red" and "r" or "b")
						else
							camp.respawnText = round2(camp.respawnTime-GameTime,-1).. ' seconds' ..
							(camp.enemyTeam and " t" or " o")..(monster.name == "red" and "r" or "b")
						end
					elseif monster.name == "ScuttleBug" then
						if MMTConfig.secondsMode == false then
							camp.respawnText = TimerText(camp.respawnTime)..
							(camp.team == TEAM_BLUE and " dragon " or " baron ") .. monster.name
						else
							camp.respawnText = round2(camp.respawnTime-GameTime,-1).. ' seconds' ..
							(camp.team == TEAM_BLUE and " dragon " or " baron ") .. monster.name
						end
					else
						if MMTConfig.secondsMode == false then
							camp.respawnText = (camp.enemyTeam and "Their " or "Our ")..
							monster.name.." respawn at "..TimerText(camp.respawnTime)
						else
							camp.respawnText = round2(camp.respawnTime-GameTime,-1) .. ' seconds '..
							(camp.enemyTeam and "their " or "our ") .. monster.name
						end
					end
				else
					camp.textUnder = false
				end

				--if IsKeyDown(16) and camp.status ~= 4 then
				if IsKeyDown(16) and (camp.respawnTime == nil or GameTime > camp.respawnTime) then
					camp.startTimer = (CursorIsUnder(camp.minimap.x - 9, camp.minimap.y - 5, 20, 8))
					camp.startTimer = camp.startTimer or GetDistance(camp.object, mousePos) < 200
				else
					camp.startTimer = false
				end

				if MMTConfig.textOnMap and camp.status == 4 and camp.object and camp.object.valid and camp.textTick < GetTickCount() and camp.floatText ~= camp.drawText then
					camp.floatText = camp.drawText

					--PrintChat(camp.floatText)
					camp.textTick = GetTickCount() + 1000 --update every second drawing directly on map
					--PrintFloatText(camp.object,6,camp.floatText)

				end
			end
		end

		-- altars
		for i,altar in pairs(altars[mapName]) do
			if altar.object and altar.object.valid then
				if altar.locked then
					if GameTime < altar.spawn then
						altar.secondLeft = math.ceil(math.max(0, altar.spawn - GameTime))
					else
						local tmpTime = ((altar.object.mana > 39600) and (altar.object.mana - 39900) / 20100 or (39600 - altar.object.mana) / 20100)
						altar.secondLeft = math.ceil(math.max(0, tmpTime * altar.respawn))
					end
					altar.unlockTime = math.ceil(GameTime + altar.secondLeft)
					altar.unlockText = altar.name.." unlock at "..TimerText(altar.unlockTime)
					altar.drawColor = 0xFFFFFF00
					if altar.advise == true then
						if altar.secondLeft == 0 and altar.advised == false then
							altar.advised = true
							if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..altar.name.."</font><font color='#FFAA00'> is unlocked</font>") end
							if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,altar.object.x,altar.object.y,altar.object.z,2) end
						elseif altar.secondLeft <= MMTConfig.adviceBefore and altar.advisedBefore == false then
							altar.advisedBefore = true
							if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..altar.name.."</font><font color='#FFAA00'> will unlock in </font><font color='#00FFCC'>"..altar.secondLeft.." sec</font>") end
							if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,altar.object.x,altar.object.y,altar.object.z,2) end
						end
					end
					-- shift click
					if IsKeyDown(16) then
						altar.drawText = " "..(altar.unlockTime ~= nil and TimerText(altar.unlockTime) or "")
						altar.textUnder = (CursorIsUnder(altar.minimap.x - 9, altar.minimap.y - 5, 20, 8))
					else
						altar.drawText = " "..(altar.secondLeft ~= nil and TimerText(altar.secondLeft) or "")
						altar.textUnder = false
					end
					if MMTConfig.textOnMap and altar.object and altar.object.valid and altar.textTick < GetTickCount() and altar.floatText ~= altar.drawText then
						altar.floatText = altar.drawText
						altar.textTick = GetTickCount() + 1000
						--PrintFloatText(altar.object,6,altar.floatText)
					end
				end
			end
		end

		-- relics
		for i,relic in pairs(relics[mapName]) do
			if (not relic.locked and (not relic.object or not relic.object.valid or relic.dead)) then
				if GameTime < relic.spawn then
					relic.unlockTime = relic.spawn - GameTime
				else
					relic.unlockTime = math.ceil(GameTime + relic.respawn)
				end
				relic.advised = false
				relic.advisedBefore = false
				relic.drawText = ""
				relic.unlockText = relic.name.." respawn at "..TimerText(relic.unlockTime)
				relic.drawColor = 4288610048
				--FF9EFF00
				relic.minimap = GetMinimap(relic.pos)
				relic.locked = true
			end
			if relic.locked then
				relic.secondLeft = math.ceil(math.max(0, relic.unlockTime - GameTime))
				if relic.advise == true then
					if relic.secondLeft == 0 and relic.advised == false then
						relic.advised = true
						if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..relic.name.."</font><font color='#FFAA00'> has respawned</font>") end
						if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,relic.pos.x,relic.pos.y,relic.pos.z,2) end
					elseif relic.secondLeft <= MMTConfig.adviceBefore and relic.advisedBefore == false then
						relic.advisedBefore = true
						if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..relic.name.."</font><font color='#FFAA00'> respawns in </font><font color='#00FFCC'>"..relic.secondLeft.." sec</font>") end
						if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,relic.pos.x,relic.pos.y,relic.pos.z,2) end
					end
				end
				-- shift click
				if IsKeyDown(16) then
					relic.drawText = " "..(relic.unlockTime ~= nil and TimerText(relic.unlockTime) or "")
					relic.textUnder = (CursorIsUnder(relic.minimap.x - 9, relic.minimap.y - 5, 20, 8))
				else
					relic.drawText = " "..(relic.secondLeft ~= nil and TimerText(relic.secondLeft) or "")
					relic.textUnder = false
				end
			end
		end

		for i,heal in pairs(heals[mapName]) do
			for j,healObject in pairs(heal.objects) do
				if (not healObject.locked and healObject.found and (not healObject.object or not healObject.object.valid or healObject.object.dead)) then
					healObject.drawColor = 0xFF00FF04
					healObject.unlockTime = math.ceil(GameTime + heal.respawn)
					healObject.drawText = ""
					healObject.found = false
					healObject.locked = true
				end
				if healObject.locked then
					-- shift click
					local secondLeft = math.ceil(math.max(0, healObject.unlockTime - GameTime))
					if IsKeyDown(16) then
						healObject.drawText = " "..(healObject.unlockTime ~= nil and TimerText(healObject.unlockTime) or "")
						healObject.textUnder = (CursorIsUnder(healObject.minimap.x - 9, healObject.minimap.y - 5, 20, 8))
					else
						healObject.drawText = " "..(secondLeft ~= nil and TimerText(secondLeft) or "")
						healObject.textUnder = false
					end
					if secondLeft == 0 then healObject.locked = false end
				end
			end
		end
		-- inhib
		for i,inhibitor in pairs(inhibitors) do
			if inhibitor.destroyed then
				-- local tick = GetTickCount()
				local tick = GetInGameTimer() * 1000
				if inhibitor.rtime < tick then
					inhibitor.destroyed = false --inhibitor has respawned
				else
					inhibitor.ltime = (inhibitor.rtime - tick) / 1000;
					inhibitor.drawText = TimerText(inhibitor.ltime)
					--inhibitor.drawText = (IsKeyDown(16) and TimerText(inhibitor.rtime) or TimerText(inhibitor.rtime))
					if MMTConfig.textOnMap and inhibitor.textTick < tick then
						inhibitor.textTick = tick + 1000
						--PrintFloatText(inhibitor.object,6,inhibitor.drawText)
					end
					if MMTConfig.textOnMap then
						--PrintFloatText(inhibitor.object,6,inhibitor.drawText)
					end
				end
			end
		end
	end

	function OnDraw()
		if GetGame().isOver then return end
		--debugText = tostring(GetInGameTimer())
		--debugText = debugText .. '\n' .. TimerText(GetInGameTimer())
		DrawText(debugText,tSize,x,y,0xFFFF0000)

		for i,monster in pairs(monsters[mapName]) do
			if monster.isSeen == true then
				for j,camp in pairs(monster.camps) do
					if camp.status == 2 then
						DrawText("X",16,camp.minimap.x - 4, camp.minimap.y - 5, camp.drawColor)
					elseif camp.status == 4 then
						DrawText(camp.drawText,16,camp.minimap.x - 9, camp.minimap.y - 5, camp.drawColor)
						if MMTConfig.textOnMap and camp.object and camp.object.valid then
							-- PrintFloatText(camp.object,6,camp.floatText)
							DrawText3D(camp.floatText,camp.object.x,camp.object.y,camp.object.z+50,40,ARGB(255,255,0,0),true)
						elseif camp.object == nil and camp.pos~= nil then
							--PrintChat("Camp.object is nil!")
							DrawText3D(camp.floatText,camp.pos.x,camp.pos.y,camp.pos.z,40,ARGB(255,255,0,0),true)
						end
					end
				end
			end
		end
		for i,altar in pairs(altars[mapName]) do
			if altar.locked then
				DrawText(altar.drawText,16,altar.minimap.x - 9, altar.minimap.y - 5, altar.drawColor)
			end
		end
		for i,relic in pairs(relics[mapName]) do
			if relic.locked then
				DrawText(relic.drawText,16,relic.minimap.x - 9, relic.minimap.y - 5, relic.drawColor)
			end
		end
		for i,heal in pairs(heals[mapName]) do
			for j,healObject in pairs(heal.objects) do
				if healObject.locked then
					DrawText(healObject.drawText,16,healObject.minimap.x - 9, healObject.minimap.y - 5, healObject.drawColor)
				end
			end
		end
		for i,inhibitor in pairs(inhibitors) do
			if inhibitor.destroyed == true then
				DrawText(inhibitor.drawText,16,inhibitor.minimap.x - 9, inhibitor.minimap.y - 5, 0xFFFFFF00)
				if MMTConfig.textOnMap then
					DrawText3D(inhibitor.drawText,inhibitor.object.x,inhibitor.object.y,inhibitor.object.z-100,40,ARGB(255,255,0,0),true)
				end
			end
		end
	end

	function OnWndMsg(msg,key)
		-- if msg == KEY_DOWN then
		-- 	if key == 35 then
		-- 		local current = monsters.summonerRift[6].camps[1].object
		-- 		PrintChat("X: " .. tostring(current.x) .. ' ' .. current.name)
		-- 	end
		-- end
		local GameTime = GetInGameTimer()

		if msg == KEY_DOWN and key == 35 then
			PrintChat("Saving")
			saveToFile()
		end

		if msg == WM_LBUTTONDOWN and IsKeyDown(16) then
			for i,monster in pairs(monsters[mapName]) do
				if monster.isSeen == true then
					if monster.iconUnder then
						monster.advise = not monster.advise
						break
					else
						for j,camp in pairs(monster.camps) do
							if camp.textUnder and monster.sendChat then
								if camp.respawnText ~= nil then SendChat(""..camp.respawnText) end
								break
							end
						end
					end
				end

				for j,camp in pairs(monster.camps) do
					if camp.startTimer then
						monster.isSeen = true
						camp.status = 4
						camp.advisedBefore = false
						camp.advised = false
						camp.manual = true
						camp.respawnTime = math.floor(GetInGameTimer()) + monster.respawn --we set its fresh respawn time
						if monster.name == "dragon" or monster.name == "baron" then --if it is dragon or baron
							if MMTConfig.secondsMode == false then
								camp.respawnText = TimerText(camp.respawnTime)..--format respawntime as timer
								(monster.name == "baron" and " baron" or " dragon")
							else
								camp.respawnText = round2(camp.respawnTime-GameTime,-1) .. ' seconds' .. 
								(monster.name == "baron" and " baron" or " dragon")
							end

						elseif monster.name == "blue" or monster.name == "red" then
							if MMTConfig.secondsMode == false then
								camp.respawnText = TimerText(camp.respawnTime)..
								(camp.enemyTeam and " t" or " o")..(monster.name == "red" and "r" or "b")
							else
								camp.respawnText = round2(camp.respawnTime-GameTime,-1).. ' seconds' ..
								(camp.enemyTeam and " t" or " o")..(monster.name == "red" and "r" or "b")
							end
						elseif monster.name == "ScuttleBug" then
							if MMTConfig.secondsMode == false then
								camp.respawnText = TimerText(camp.respawnTime)..
								(camp.team == TEAM_BLUE and " dragon " or " baron ") .. monster.name
							else
								camp.respawnText = round2(camp.respawnTime-GameTime,-1).. ' seconds' ..
								(camp.team == TEAM_BLUE and " dragon " or " baron ") .. monster.name
							end
						else
							if MMTConfig.secondsMode == false then
								camp.respawnText = (camp.enemyTeam and "Their " or "Our ")..
								monster.name.." respawn at "..TimerText(camp.respawnTime)
							else
								camp.respawnText = round2(camp.respawnTime-GameTime,-1) .. ' seconds '..
								(camp.enemyTeam and "their " or "our ") .. monster.name
							end
						end
					end
				end
			end

			for i,altar in pairs(altars[mapName]) do
				if altar.locked and altar.textUnder then
					if altar.unlockText ~= nil then SendChat(""..altar.unlockText) end
					break
				end
			end
		end
	end
end