-- Goal : Return target

--[[
TargetSelector Class :
Methods:
ts = TargetSelector(mode, range, targetSelectedMode (opt), magicDmgBase (opt), physicalDmgBase (opt), trueDmg (opt))

Functions :
TargetSelector:printPriority() -> global print Priority
TargetSelector:setFocusOnSelected() -> global set priority to the selected champion (you need to use PRIORITY modes to use it)
TargetSelector:updateTarget() -> update the instance target

Members:
ts.mode -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
ts.range -> number > 0
ts.targetSelectedMode -> true/false
ts.magicDmgBase -> positive integer
ts.physicalDmgBase -> positive integer
ts.trueDmg -> positive integer
ts.conditional(object) -> function that return true/false to allow external filter
ts.target -> return the target (hero object)

Usage :
variable = TargetSelector(mode, range, targetSelectedMode (opt), magicDmgBase (opt), physicalDmgBase (opt), trueDmg (opt))
targetSelectedMode is set to true if not filled
Damages are set to 0 if not filled
Damages are set as default to magic 100 if none is set

when you want to update, call variable:updateTarget()

Values you can change on instance :
variable.mode -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
variable.range -> number > 0
variable.targetSelectedMode -> true/false
variable.magicDmgBase -> positive integer
variable.physicalDmgBase -> positive integer
variable.trueDmg -> positive integer
variable.conditional(object) -> function that return true/false to allow external filter


ex :
function OnLoad()
	ts = TargetSelector(TARGET_LESS_CAST, 600, true, 200)
end

function OnTick()
	ts:updateTarget()
	if ts.target ~= nil then
		PrintChat(ts.target.charName)
		ts.magicDmgBase = (player.ap * 10)
	end
end

]]

--SHOULD BE ON ANOTHER PLACE (COMMON)
player = GetMyHero()
function GetDistance( p1, p2 )
	if p2 == nil then p2 = player end
    if p1.z == nil or p2.z == nil then return math.sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
	else return math.sqrt((p1.x-p2.x)^2+(p1.z-p2.z)^2) end
end
function ValidTarget(object)
    return object ~= nil and object.team ~= player.team and object.visible and not object.dead and object.bTargetable and object.bInvulnerable == 0
end
--

-- Class related constants
TARGET_LOW_HP = 1
TARGET_MOST_AP = 2
TARGET_PRIORITY = 3
TARGET_NEAR_MOUSE = 4
TARGET_LOW_HP_PRIORITY = 5
TARGET_LESS_CAST = 6
TARGET_LESS_CAST_PRIORITY = 7

class 'TargetSelector'
-- GLOBALS (priority are set for all instances)
TargetSelector.enemyTargets = {}
TargetSelector.texted = {"LowHP", "MostAP", "Priority", "NearMouse", "LowHPPriority", "LessCast", "LessCastPriority"}
function TargetSelector:printPriority()
	for i, target in ipairs(TargetSelector.enemyTargets) do
        if target.hero ~= nil then
            PrintChat("[TS] Enemy " .. i .. ": " .. target.hero.charName .. " Mode=" .. (target.ignore and "ignore" or "target") .." Priority=" .. target.priority)
        end
    end
end
function TargetSelector:setFocusOnSelected()
	local hero = GetTarget()
	if hero ~= nil and hero.type == "obj_AI_Hero" and hero.team ~= player.team then
		for index,target in ipairs(TargetSelector.enemyTargets) do
			target.priority = (target.hero.networkID == hero.networkID and 1 or #TargetSelector.enemyTargets)
		end
	end
end

-- INSTANCE
--TargetSelector(mode, range, targetSelectedMode, magicDmgBase, physicalDmgBase, trueDmg)
function TargetSelector:__init(mode, range, targetSelected, magicDmgBase, physicalDmgBase, trueDmg)
	-- Init Global
	if # TargetSelector.enemyTargets == 0 then
		for i = 1, heroManager.iCount do
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.team ~= player.team then
				table.insert(TargetSelector.enemyTargets, {ignore = false,priority = 1,hero = hero,})
			end
		end
	end
	self.mode = mode
	self.range = range
	self.targetSelected = (targetSelected == false and false or true)
	self.magicDmgBase = magicDmgBase or 0
	self.physicalDmgBase = physicalDmgBase or 0
	self.trueDmg = trueDmg or 0
	self.target = nil
	self.targetMode = TargetSelector.texted[mode]
	function self.conditional(thisTarget) return true end
	-- set default to magic 100 if none is set
	if self.magicDmgBase == 0 and self.physicalDmgBase == 0 and self.trueDmg == 0 then self.magicDmgBase = 100 end
end

function TargetSelector:printMode()
    --PrintChat("[TS] Target mode: " ..TargetSelector.texted[self.mode])
end

function TargetSelector:targetSelectedByPlayer()
	if self.targetSelected then
		local currentTarget = GetTarget()
		if ValidTarget(currentTarget) and GetDistance(currentTarget) < 2000 and self.conditional(currentTarget) then
			self.target = currentTarget
			return true
		end
	end
	return false
end

function TargetSelector:updateTarget()
    -- Resets the target if player died
    if player.dead then
        self.target = nil
		return
	end
	-- Get current selected target (by player) if needed
    if self:targetSelectedByPlayer() then return end
	local selected, value
	local range = (self.mode == TARGET_NEAR_MOUSE and 2000 or self.range)
    for i, target in ipairs(TargetSelector.enemyTargets) do
        local hero = target.hero
        if ValidTarget(hero) and GetDistance(hero) <= range and not target.ignore and self.conditional(hero) then
			if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST or self.mode == TARGET_LESS_CAST_PRIORITY then
			-- Returns lowest effective HP target that is in range
			-- Or lowest cast to kill target that is in range
				local magicDmg = (self.magicDmgBase > 0 and player:CalcMagicDamage(hero, self.magicDmgBase) or 0)
				local physicalDmg = (self.physicalDmgBase > 0 and player:CalcDamage(hero, self.physicalDmgBase) or 0)
				local totalDmg = magicDmg + physicalDmg + self.trueDmg
				-- priority mode
				if self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST_PRIORITY then
					totalDmg = totalDmg / target.priority
				end
				local heroValue
				if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY then
					heroValue = hero.health - totalDmg
				else
					heroValue = hero.health / totalDmg
				end
				if not selected or heroValue < value then
					selected = hero
					value = heroValue
				end
			elseif self.mode == TARGET_MOST_AP then
			-- Returns target that has highest AP that is in range
				if not selected or hero.ap > selected.ap then selected = hero end
			elseif self.mode == TARGET_PRIORITY then
			-- Returns target with highest priority # that is in range
				if not selected or target.priority < value then
					selected = hero
					value = target.priority
				end
			elseif self.mode == TARGET_NEAR_MOUSE then
			-- Returns target that is the closest to the mouse cursor.
				local distance = GetDistance(mousePos, hero)
				if not selected or distance < value then
					selected = hero
					value = distance
				end
			end
        end
    end
    self.target = selected
end


--UPDATEURL=
--HASH=B3994FAE12E771FDC779F5EFDB3DD213
