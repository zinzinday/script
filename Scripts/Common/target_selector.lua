--[[
   Library: Target Selector Library v0.4c
    Author: By llama, modified by Keoshin/Taikumi
   Credits: This script was largely (99.9%) based on FPB's Target Selector Library by llama/H0nda/Weee.
            Credits to them for making an awesome library.  Their library was largely modified to
            work with Bot of Legends API's.
            delusionallogic - for helping me test ChatHandler()

      NOTE: This script does not support all functionalities yet. Only the basic LowHP targetting mode
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
              is loaded. You do not need to call this function.

     v0.4   - Added near mouse mode: will target the target that is closest to your mouse. Also will prioritize champions that are currently "selected" (clicked on).
                 To use, simply type .nearmouse
            - Made all state variables part of object.
            - Fixed bugs with .setpriority, .focus, .setpriorityarray not working properly with team counts less than 5.
			- Add priority for all modes to focus the champion that is CLICKED on.
			- ******* The champion that you click on will have priority ********
			
	 v0.4b  - Made .ignore a toggle. Type .ignore enemyName again to un-ignore them.
			- When changing priority via .setpriority/.setpriorityarray, it will not switch to Priority Mode if you are in .hpprimode
			- Added a toggle to disable target selector using the enemy selected by the player (clicked on).
			    Change object.targetSelected to false to disable. It is on by default.
	 
	 v0.4c  - Fixed bug with object.targetSelected ignoring all targets.
]]--


-- Library related constants
TARGET_LOW_HP     = 1
TARGET_MOST_AP    = 2
TARGET_PRIORITY   = 3
TARGET_NEAR_MOUSE = 4
DAMAGE_MAGIC      = 1
DAMAGE_PHYSICAL   = 2


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
TargetSelector = {}

function TargetSelector:new(mode, range, damageType)
    local object = { mode = mode, range = range, damageType = damageType or DAMAGE_MAGIC, target = nil, paused=false }
    setmetatable(object, { __index = TargetSelector })

    object.targetMode = ""
    if mode == TARGET_LOW_HP then
        object.targetMode = "LowHP"
    elseif mode == TARGET_MOST_AP then
        object.targetMode =- "MostAP"
    elseif mode == TARGET_PRIORITY then
        object.targetMode = "Priority"
    elseif mode == TARGET_NEAR_MOUSE then
        object.targetMode = "NearMouse"
    end

    -- Defines enemy targets for this instance
    object.enemyTargets = {}
	
	-- Should we focus on enemy that is selected by player? Default: TRUE
	object.targetSelected = true

    -- Defines each chat command and what they do
    object.CommandPrefix = "."
    object.ChatCommands = {
        { -- .printarray
            command = "printarray", requiresTarget = false, method =
            function()
                object:printarray()
            end
        },

        { -- .lowhp
            command = "lowhp", requiresTarget = false, method =
            function()
                object.targetMode = "LowHP"
                PrintChat("[TS] Focusing non-ignored enemy with the lowest effective HP")
            end
        },

        { -- .mostap
            command = "mostap", requiresTarget = false, method =
            function(i, cmd)
                object.targetMode = "MostAP"
                PrintChat("[TS] Focusing non-ignored enemy with the most AP")
            end
        },

        { -- .focus charName
            command = "focus", requiresTarget = true, method =
            function(i, cmd)
                object.targetMode = "Priority"

                -- Resets the priority list, then sets our target to highest priority (5)
                for j,target in ipairs(object.enemyTargets) do
                    target.priorityNum = #object.enemyTargets
                end
                object.enemyTargets[i].priorityNum = 1

                PrintChat("[TS] Focusing " .. object.enemyTargets[i].obj.charName)
            end
        },

        { -- .hpprimode
            command = "hpprimode", requiresTarget = false, method =
            function(i, cmd)
                object.targetMode = "LowHPPriority"
                PrintChat("[TS] Focusing enemy with the lowest HP based on modifier")
            end
        },

        { -- .primode
            command = "primode", requiresTarget = false, method =
            function(i, cmd)
                object.targetMode = "Priority"
                PrintChat("[TS] Focusing enemy with the highest priority")
            end
        },

        { -- .nearmouse
            command = "nearmouse", requiresTarget = false, method =
            function(i, cmd)
                object.targetMode = "NearMouse"
                PrintChat("[TS] Focusing enemy closest to mouse cursor")
            end
        },

        { -- setpriorityarray 1 2 3 4 5 -- [pass in the index of the champions at at each specified parameter, with 5 being the highest]
            command = "setpriorityarray", requiresTarget = false, method =
            function(i, cmd)
                cmd = cmd:gsub(object.CommandPrefix .. "setpriorityarray ", "") -- Remove the command prefix
                local args = object:split(cmd, " ")

                if #args ~= #object.enemyTargets then
                    PrintChat("[TS] Invalid arguments! You need " .. #object.enemyTargets .. " arguments, each signifying the champion index.")
                    PrintChat("[TS] Example: If you received #1 = Graves, #2 = Irelia, #3 = Janna, #4 = Warwick, #5 = Ryze from printarray()")
                    PrintChat("[TS] and you wanted to focus Graves, Ryze, Janna, Warwick, Irelia, in that order, then you would use:")
                    PrintChat("[TS] " .. object.CommandPrefix .. "setpriorityarray 1 5 3 4 2")
                    return
                end


                for priority = 1, #args do
                    local index = tonumber(args[priority])
                    if index >= 1 and index <= #object.enemyTargets then
                        if object.enemyTargets[index].obj then
                            PrintChat("[TS] " .. object.enemyTargets[index].obj.charName .. "'s  priority set to  " .. priority)
                            object.enemyTargets[index].priorityNum = priority
                        end
                    else
                        object.enemyTargets[index].priorityNum = 1
                    end
                end

                if object.targetMode ~= "Priority" or object.targetMode ~= "LowHPPriority" then
                    PrintChat("[TS] Focusing enemy with the highest priority")
					object.targetMode = "Priority"
                end
            end
        },

        { -- .setpriority
            command = "setpriority", requiresTarget = true, method =
            function(i, cmd)
                cmd = cmd:gsub(object.CommandPrefix .. "setpriority ", "") -- Remove the command prefix
                local args = object:split(cmd, " ")
                local n = tonumber(args[2])

                if n >= 1 and n <= #object.enemyTargets then
                    object.enemyTargets[i].priorityNum = n
                    PrintChat("[TS] "..object.enemyTargets[i].obj.charName.."'s  priority set to  "..n)
                    if object.targetMode ~= "Priority" or object.targetMode ~= "LowHPPriority" then
                        PrintChat("[TS] Focusing enemy with the highest priority")
                    	object.targetMode = "Priority"
                    end
                else
                    PrintChat("[TS] Invalid priority number! Value ranges from 1 (highest priority) to " .. #object.enemyTargets .. " (lowest priority)")
                end
            end
        },

        { -- .ignore champName
            command = "ignore", requiresTarget = true, method =
            function(i, cmd)
				if object.enemyTargets[i].ignore == true then
					object.enemyTargets[i].ignore = false
					PrintChat("[TS] Re-targetting " .. object.enemyTargets[i].obj.charName)
				else
					object.enemyTargets[i].ignore = true
					PrintChat("[TS] Ignoring " .. object.enemyTargets[i].obj.charName)
				end
            end
        },
    }



    PrintChat("[TS] Target Selector loaded - Target Mode: " .. object.targetMode)
    object:buildarray()

    return object
end


function TargetSelector:buildarray()
    local n = 1
    for i = 1, heroManager.iCount do
        local obj = heroManager:getHero(i)
        if obj ~= nil and obj.team ~= player.team then
            self.enemyTargets[n] = {
                ["ignore"]      = false,
                ["priorityNum"] = 1,
                ["obj"]         = obj,
            }
            n = n + 1
        end
    end
end


function TargetSelector:printarray()
    for i, target in ipairs(self.enemyTargets) do
        if target.obj ~= nil then
            PrintChat("[TS] Enemy " .. i .. ": " .. target.obj.charName .. "    Mode=" .. (target.ignore and "ignore" or "target") .."    Priority=" .. target.priorityNum)
        end
    end
    PrintChat("[TS] Target mode: " .. self.targetMode)
end


function TargetSelector:tick()
    -- Resets the target if player died
    if player.dead then
        self.target = nil
        return
    end

    if self.targetMode == "LowHP" then
        self:get_low_hp()
    elseif self.targetMode == "MostAP" then
        self:get_most_ap()
    elseif self.targetMode == "Priority" then
        self:get_highest_priority()
    elseif self.targetMode == "LowHPPriority" then
        self:get_low_hp_priority()
    elseif self.targetMode == "NearMouse" then
        self:get_near_mouse()
    end
end


function TargetSelector:get_chat_command(msg)
    if msg:sub(1,1) ~= self.CommandPrefix then return end
    BlockChat() -- Surpress the next chat message from being sent
    for i,currentCommand in ipairs(self.ChatCommands) do
        if msg:find(currentCommand.command) then
            if currentCommand.requiresTarget then
                for j,target in ipairs(self.enemyTargets) do
                    if msg:lower():find(target.obj.charName:lower()) then
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
	-- Get current selected target (by player)
    local currentTarget = GetTarget()
    if not self.targetSelected or not self:valid_target(currentTarget) or self:get_distance(player, currentTarget) > 2000 then
        currentTarget = nil
    end

    local selected = nil

    for i, target in ipairs(self.enemyTargets) do
        local current = target.obj
		
		-- Prioritize targest that are selected by player
		if currentTarget and current.networkID == currentTarget.networkID then
			selected = currentTarget
			break
		end
		
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
	-- Get current selected target (by player)
    local currentTarget = GetTarget()
    if not self.targetSelected or not self:valid_target(currentTarget) or self:get_distance(player, currentTarget) > 2000 then
        currentTarget = nil
    end

    local selected = nil

    for i, target in ipairs(self.enemyTargets) do
	
		-- Prioritize targest that are selected by player
		if currentTarget and target.obj.networkID == currentTarget.networkID then
			selected = currentTarget
			break
		end
	
        if self:valid_target(target.obj) and player:GetDistance(target.obj) <= self.range then
            if not selected then
                selected = target
            elseif target.obj.ap >= selected.obj.ap then
                selected = target
            end
        end
    end

    if not selected then
        self.target = nil
    else
        self.target = selected.obj
    end
end


-- Returns target with highest priority # that is in range
function TargetSelector:get_highest_priority()
	-- Get current selected target (by player)
    local currentTarget = GetTarget()
    if not self.targetSelected or not self:valid_target(currentTarget) or self:get_distance(player, currentTarget) > 2000 then
        currentTarget = nil
    end

    local selected = nil

    for i, target in ipairs(self.enemyTargets) do
	
		-- Prioritize targest that are selected by player
		if currentTarget and target.obj.networkID == currentTarget.networkID then
			selected = currentTarget
			break
		end

        if self:valid_target(target.obj) and player:GetDistance(target.obj) <= self.range then
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
        self.target = selected.obj
    end
end


-- Returns lowest effective HP target (with modifier) that is in range
function TargetSelector:get_low_hp_priority()
	-- Get current selected target (by player)
    local currentTarget = GetTarget()
    if not self.targetSelected or not self:valid_target(currentTarget) or self:get_distance(player, currentTarget) > 2000 then
        currentTarget = nil
    end
	
    local selected = nil

    for i, target in ipairs(self.enemyTargets) do
        local current = target.obj

		-- Prioritize targest that are selected by player
		if currentTarget and current.networkID == currentTarget.networkID then
			selected = currentTarget
			break
		end
		
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


-- Returns target that is the closest to the mouse cursor. Will prioritize champions that are selected
function TargetSelector:get_near_mouse()
	-- Get current selected target (by player)
    local currentTarget = GetTarget()
    if not self.targetSelected or not self:valid_target(currentTarget) or self:get_distance(player, currentTarget) > 2000 then
        currentTarget = nil
    end

    local selected = nil
    for i, target in ipairs(self.enemyTargets) do
        if self:valid_target(target.obj) and self:get_distance(player, target.obj) < 2000 then

            if currentTarget and target.obj.networkID == currentTarget.networkID then
                selected = target
                break
            end

            -- Compare the distance and select the one closest to cursor
            if not selected or self:get_distance(mousePos, target.obj) < self:get_distance(mousePos, selected.obj) then
                selected = target
            end
        end
    end

    if not selected then
        self.target = nil
    else
        self.target = selected.obj
    end
end


function TargetSelector:valid_target(obj)
    return obj ~= nil and obj.team ~= player.team and obj.visible and not obj.dead and obj.bTargetable and obj.bInvulnerable == 0
end


function TargetSelector:split(pString, pPattern)
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


-- Get Distance 2D
function TargetSelector:get_distance(o1, o2)
    local c = "z"
    if o1.z == nil or o2.z == nil then c = "y" end
    return math.sqrt(math.pow(o1.x - o2.x, 2) + math.pow(o1[c] - o2[c], 2))
end


--UPDATEURL=
--HASH=6C32A2E4E090BBD5D5C8AFA085F144D3
