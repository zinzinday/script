--[[
   Library: Target Selector Library v0.3b
    Author: By llama, modified by Keoshin/Taikumi
   Credits: This script was largely (99.9%) based on FPB's Target Selector Library by llama/H0nda/Weee.
			Credits to them for making an awesome library.	Their library was largely modified to
			work with Bot of Legends API's.
            delusionallogic - for helping me test ChatHandler()

	  NOTE:	This script does not support all functionalities yet. Only the basic LowHP targetting mode
			is supported. Others (such as MostAP, Priority Mode) will be added soon.

 Changelog:
       v0.1 - Initial release
       v0.2 - Changed printarray to print out the champion name, instead of player name
            - Added support for MostAP, Highest Priority mode selector.
            - Added in-game chat command parsing:
                .lowhp (Switches target selector to lowest effective hp mode)
                .mostap (Switches target selector to most ap mode)
                .primode (Switches target selector to highest priority mode)
                .ignore charName (ignores charName and will not target it)
                .focus charName (sets the charName as highest priority, reset all others to 0)
                .setpriority charName priority# (Priority # ranges from 1: highest to 5: lowest)
                .setpriorityarray 2 3 1 5 4 = (Champion #2 gets highest priority, #3 get's 2nd highest, so on)

            - NOTE: For in-game commands support, you must have a chatHandler in your script that passes the message to
                    TargetSelector:get_chat_command(msg)

      v0.3a - Changed priority numbering system. 1 is now the highest priority, while 5 is lowest.
            - Added Low HP Priority Mode:
                .hpprimode (Switches target selector to Low HP priority mode based on priority # modifier)
                    A champion with priority #5 will essentially have 5 * maxHP, compared with a champion with priority #1 
                    which will have 1 * maxHP.
                    
      v0.3b - Fixed bug with .setpriorityarray not properly setting priority.
            - Credits to llama, original author of the script.
            - ts:buildarray() is now deprecated. The script will automatically build the enemy array once the target selector
              is loaded. You dno not need to call this function.
]]--


do

-- Library related constants
TARGET_LOW_HP   = 1
TARGET_MOST_AP  = 2
TARGET_PRIORITY = 3
DAMAGE_MAGIC    = 1
DAMAGE_PHYSICAL = 2


--[[
    Todo: ignore targets with the buffs:
        -Vlads pool
        -Zhonyas
        -enemy being in Guardian Angel, lying on ground
        -Kogmaw passive
        -Karthus passive
        -Alistar ult
        -Kayle ult
        -Tryn ult
]]--


-- Global constants
local player = GetMyHero()

-- Variables
TargetSelector = {}
local EnemyTargets = {
    {enemyObj = nil, ignore = false, priorityNum = 1},
    {enemyObj = nil, ignore = false, priorityNum = 1},
    {enemyObj = nil, ignore = false, priorityNum = 1},
    {enemyObj = nil, ignore = false, priorityNum = 1},
    {enemyObj = nil, ignore = false, priorityNum = 1}
}

local targetMode = ""


local function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
        table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end


function TargetSelector:new(mode, range, damageType)
    local object = { mode = mode, range = range, damageType = damageType or DAMAGE_MAGIC, target = nil, paused=false }
    setmetatable(object, { __index = TargetSelector })

    if mode == TARGET_LOW_HP then
        targetMode = "LowHP"
    elseif mode == TARGET_MOST_AP then
        targetMode =- "MostAP"
    elseif mode == TARGET_PRIORITY then
        targetMode = "Priority"
    end

    PrintChat("[TS] Target Selector loaded - Target Mode:" .. targetMode)
    object:buildarray()

    return object
end


function TargetSelector:buildarray()
    local n = 1
    for i = 1, heroManager.iCount do
        local obj = heroManager:getHero(i)
        if obj ~= nil and obj.team ~= player.team then
            EnemyTargets[n].enemyObj = obj
			n = n + 1
        end
    end
end


function TargetSelector:printarray()
    for i, target in ipairs(EnemyTargets) do
        if target.enemyObj ~= nil then
            PrintChat("[TS] Enemy " .. i .. ": " .. target.enemyObj.charName .. "    Mode=" .. (target.ignore and "ignore" or "target") .."    Priority=" .. target.priorityNum)
        end
    end
    PrintChat("[TS] Target mode: " .. targetMode)
end


function TargetSelector:tick()
    -- Resets the target if player died
    if player.dead then
        self.target = nil
        return
    end

    if targetMode == "LowHP" then
        self:get_low_hp()
    elseif targetMode == "MostAP" then
        self:get_most_ap()
    elseif targetMode == "Priority" then
        self:get_highest_priority()
    elseif targetMode == "LowHPPriority" then
        self:get_low_hp_priority()
    end
end


-- Defines each chat command and what they do
CommandPrefix = "."
ChatCommands = {
    { -- .printarray
        command = "printarray", requiresTarget = false, method =
        function()
            TargetSelector:printarray()
        end
    },

    { -- .lowhp
        command = "lowhp", requiresTarget = false, method =
        function()
            targetMode = "LowHP"
            PrintChat("[TS] Focusing non-ignored enemy with the lowest effective HP")
        end
    },

    { -- .mostap
        command = "mostap", requiresTarget = false, method =
        function(i, cmd)
            targetMode = "MostAP"
            PrintChat("[TS] Focusing non-ignored enemy with the most AP")
        end
    },

    { -- .focus charName
        command = "focus", requiresTarget = true, method =
        function(i, cmd)
            targetMode = "Priority"

            -- Resets the priority list, then sets our target to highest priority (5)
            for j,target in ipairs(EnemyTargets) do
                target.priorityNum = 0
            end
            EnemyTargets[i].priorityNum = 5

            PrintChat("[TS] Focusing " .. EnemyTargets[i].enemyObj.charName)
        end
    },

    { -- .hpprimode
        command = "hpprimode", requiresTarget = false, method =
        function(i, cmd)
            targetMode = "LowHPPriority"
            PrintChat("[TS] Focusing enemy with the lowest HP based on modifier")
        end
    },
    
    { -- .primode
        command = "primode", requiresTarget = false, method =
        function(i, cmd)
            targetMode = "Priority"
            PrintChat("[TS] Focusing enemy with the highest priority")
        end
    },
        
    { -- setpriorityarray 1 2 3 4 5 -- [pass in the index of the champions at at each specified parameter, with 5 being the highest]
        command = "setpriorityarray", requiresTarget = false, method =
        function(i, cmd)
            cmd = cmd:gsub(CommandPrefix .. "setpriorityarray ", "") -- Remove the command prefix
            local args = split(cmd, " ")

            if #args ~= #EnemyTargets then
                PrintChat("[TS] Invalid arguments! You need 5 arguments, each signifying the champion index.")
                PrintChat("[TS] Example: If you received #1 = Graves, #2 = Irelia, #3 = Janna, #4 = Warwick, #5 = Ryze from printarray()")
                PrintChat("[TS] and you wanted to focus Graves, Ryze, Janna, Warwick, Irelia, in that order, then you would use:")
                PrintChat("[TS] " .. CommandPrefix .. "setpriorityarray 1 5 3 4 2")
                return
            end


            for priority = 1, #args do
                local index = tonumber(args[priority])
                if index >= 1 and index <= #EnemyTargets then
                    if EnemyTargets[index].enemyObj then
                        PrintChat("[TS] " .. EnemyTargets[index].enemyObj.charName .. "'s  priority set to  " .. priority)
                        EnemyTargets[index].priorityNum = priority
                    end
                else
                    EnemyTargets[index].priorityNum = 1
                end
            end
            
            if targetMode ~= "Priority" then
                PrintChat("[TS] Focusing enemy with the highest priority")
            end
            targetMode = "Priority"
        end
    },
    
    { -- .setpriority
        command = "setpriority", requiresTarget = true, method =
        function(i, cmd)
            -- Finds the priority #
            local n = tonumber(cmd:sub(cmd:find("%d")))

            if n >= 1 and n <= 5 then
                EnemyTargets[i].priorityNum = n
                PrintChat("[TS] "..EnemyTargets[i].enemyObj.charName.."'s  priority set to  "..n)
                if targetMode ~= "Priority" then
                    PrintChat("[TS] Focusing enemy with the highest priority")
                end
                targetMode = "Priority"
            else
                PrintChat("[TS] Invalid priority number! Value ranges from 0 (lowest priority) to 5 (highest priority)")
            end
        end
    },
    
        { -- .ignore champName
                command = "ignore", requiresTarget = true, method =
                function(i, cmd)
                        EnemyTargets[i].ignore = not EnemyTargets[i].ignore
if EnemyTargets[i].ignore then
PrintChat("[TS] Ignoring " .. EnemyTargets[i].enemyObj.charName)
else
PrintChat("[TS] No longer ignoring " .. EnemyTargets[i].enemyObj.charName)
end
                end
        },
}


function TargetSelector:get_chat_command(msg)
    if msg:sub(1,1) ~= CommandPrefix then return end
    BlockChat() -- Surpress the next chat message from being sent
    for i,currentCommand in ipairs(ChatCommands) do
        if msg:find(currentCommand.command) then
            if currentCommand.requiresTarget then
                for j,target in ipairs(EnemyTargets) do
                    if msg:lower():find(target.enemyObj.charName:lower()) then
                        currentCommand.method(j, msg) -- Executes the method with the index of target
                    end
                end
            else
                currentCommand.method(i, msg) -- Executes the method
            end
            break
        end
    end
end


-- Returns lowest effective HP target that is in range
function TargetSelector:get_low_hp()
	local selected = nil

	for i, target in ipairs(EnemyTargets) do
        local current = target.enemyObj
		if self:valid_target(current) and player:GetDistance(current) <= self.range and not target.ignore then

			if not selected then
				selected = current
			else
				-- Handles damage type: DAMAGE_MAGIC and DAMAGE_PHYSICAL
				if self.damageType == DAMAGE_MAGIC then
					if selected.health * (100 / player:CalcMagicDamage(selected, 100)) > current.health * (100 / player:CalcMagicDamage(current, 100)) then
						selected = current
					end
				elseif self.damageType == DAMAGE_PHYSICAL then
					local player_totalDamage = player.damage + player.addDamage
					if selected.health * (player_totalDamage / player:CalcDamage(selected)) > current.health * (player_totalDamage / player:CalcDamage(current)) then
						selected = current
					end
				end
			end
		end
	end

    self.target = selected
end


 -- Returns target that has highest AP that is in range
function TargetSelector:get_most_ap()
    local selected = nil

    for i, target in ipairs(EnemyTargets) do
        if self:valid_target(target.enemyObj) and player:GetDistance(target.enemyObj) <= self.range then
            if not selected then
                selected = target
            elseif target.enemyObj.ap >= selected.enemyObj.ap then
                selected = target
            end
        end
    end

    if not selected then
        self.target = nil
    else
        self.target = selected.enemyObj
    end
end


-- Returns target with highest priority # that is in range
function TargetSelector:get_highest_priority()
	local selected = nil

	for i, target in ipairs(EnemyTargets) do
        if self:valid_target(target.enemyObj) and player:GetDistance(target.enemyObj) <= self.range then
			if not selected then
				selected = target
			elseif target.priorityNum <= selected.priorityNum then
                selected = target
			end
		end
	end
    
    if not selected then
        self.target = nil
    else
        self.target = selected.enemyObj
    end
end


-- Returns lowest effective HP target (with modifier) that is in range
function TargetSelector:get_low_hp_priority()
	local selected = nil

	for i, target in ipairs(EnemyTargets) do
        local current = target.enemyObj
		if self:valid_target(current) and player:GetDistance(current) <= self.range and not target.ignore then

			if not selected then
				selected = current
			else
				-- Handles damage type: DAMAGE_MAGIC and DAMAGE_PHYSICAL
				if self.damageType == DAMAGE_MAGIC then
					if selected.health * selected.priorityNum * (100 / player:CalcMagicDamage(selected, 100)) > current.health * current.priorityNum * (100 / player:CalcMagicDamage(current, 100)) then
						selected = current
					end
				elseif self.damageType == DAMAGE_PHYSICAL then
					local player_totalDamage = player.damage + player.addDamage
					if selected.health * selected.priorityNum * (player_totalDamage / player:CalcDamage(selected)) > current.health * current.priorityNum * (player_totalDamage / player:CalcDamage(current)) then
						selected = current
					end
				end
			end
		end
	end

    self.target = selected
end


-- Check if the target object is currently in a state where we should ignore.
function TargetSelector:check_target_state(targetObj)
    return false
end


function TargetSelector:valid_target(obj)
    return obj ~= nil and obj.team ~= player.team and obj.visible and not obj.dead and obj.bTargetable ~= 11048448 and obj.bInvulnerable ~= 1
end


end

--UPDATEURL=
--HASH=5756A8692BD429167E7603CE377E871E
