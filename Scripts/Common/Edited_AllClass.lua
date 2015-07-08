--[[
   return texted version of a timer(minutes and seconds)
   if you want the full time string, use os.date("%H:%M:%S",seconds+82800)
]]
function TimerText(seconds)
    seconds = seconds or GetInGameTimer()
    if type(seconds) ~= "number" or seconds > 100000 or seconds < 0 then return " ? " end
    return string.format("%i %02i", seconds / 60, seconds % 60)
end


local _gameHeroes, _gameAllyCount, _gameEnemyCount = {}, 0, 0
-- Class related function
local function _gameHeroes__init()
	if #_gameHeroes == 0 then
		_gameAllyCount, _gameEnemyCount = 0, 0
		for i = 1, heroManager.iCount do
			local hero = heroManager:getHero(i)
			if hero ~= nil and hero.valid then
				if hero.team == player.team then
					_gameAllyCount = _gameAllyCount + 1
					table.insert(_gameHeroes, { hero = hero, index = i, tIndex = _gameAllyCount, ignore = false, priority = 1, enemy = false })
				else
					_gameEnemyCount = _gameEnemyCount + 1
					table.insert(_gameHeroes, { hero = hero, index = i, tIndex = _gameEnemyCount, ignore = false, priority = 1, enemy = true })
				end
			end
		end
	end
end

local function _gameHeroes__extended(target, assertText)
	local assertText = assertText or ""
	if type(target) == "number" then
		return _gameHeroes[target]
	elseif target ~= nil and target.valid then
		assert(type(target.networkID) == "number", assertText .. ": wrong argument types (<charName> or <heroIndex> or <hero> expected)")
		for _, _gameHero in ipairs(_gameHeroes) do
			if _gameHero.hero.networkID == target.networkID then
				return _gameHero
			end
		end
	end
end

local function _gameHeroes__hero(target, assertText, enemyTeam)
	local assertText = assertText or ""
	enemyTeam = (enemyTeam ~= false)
	if type(target) == "string" then
		for _, _gameHero in ipairs(_gameHeroes) do
			if _gameHero.hero.charName == target and (_gameHero.hero.team ~= player.team) == enemyTeam then
				return _gameHero.hero
			end
		end
	elseif type(target) == "number" then
		return heroManager:getHero(target)
	elseif target == nil then
		return GetTarget()
	else
		assert(type(target.networkID) == "number", assertText .. ": wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)")
		return target
	end
end

local function _gameHeroes__index(target, assertText, enemyTeam)
	local assertText = assertText or ""
	local enemyTeam = (enemyTeam ~= false)
	if type(target) == "string" then
		for _, _gameHero in ipairs(_gameHeroes) do
			if _gameHero.hero.charName == target and (_gameHero.hero.team ~= player.team) == enemyTeam then
				return _gameHero.index
			end
		end
	elseif type(target) == "number" then
		return target
	else
		assert(type(target.networkID) == "number", assertText .. ": wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)")
		return _gameHeroes__index(target.charName, assertText, (target.team ~= player.team))
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TargetSelector Class
--[[
TargetSelector Class :
    Methods:
        ts = TargetSelector(mode, range, damageType (opt), targetSelected (opt), enemyTeam (opt))
    Goblal Functions :
        TS_Print(enemyTeam (opt))           -> print Priority (global)
        TS_SetFocus()           -> set priority to the selected champion (you need to use PRIORITY modes to use it) (global)
        TS_SetFocus(id)         -> set priority to the championID (you need to use PRIORITY modes to use it) (global)
        TS_SetFocus(charName, enemyTeam (opt))  -> set priority to the champion charName (you need to use PRIORITY modes to use it) (global)
        TS_SetFocus(hero)       -> set priority to the hero object (you need to use PRIORITY modes to use it) (global)
        TS_SetHeroPriority(priority, target, enemyTeam (opt))                   -> set the priority to target
        TS_SetPriority(target1, target2, target3, target4, target5)     -> set priority in order to enemy targets
        TS_SetPriorityA(target1, target2, target3, target4, target5)    -> set priority in order to ally targets
        TS_GetPriority(target, enemyTeam)       -> return the current priority, and the max allowed
    Functions :
        ts:update()                                             -- update the instance target
        ts:SetDamages(magicDmgBase, physicalDmgBase, trueDmg)
        ts:SetPrediction()                          -- prediction off
        ts:SetPrediction(delay)                     -- predict movement for champs (need Prediction__OnTick())
        ts:SetMinionCollision()                     -- minion colission off
        ts:SetMinionCollision(spellWidth)           -- avoid champ if minion between player
        ts:SetConditional()                         -- erase external function use
        ts:SetConditional(func)                     -- set external function that return true/false to allow filter -- function(hero, index (opt))
        ts:SetProjectileSpeed(pSpeed)               -- set projectile speed (need Prediction__OnTick())
    Members:
        ts.mode                     -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_MOST_AD, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
        ts.range                    -> number > 0
        ts.targetSelected       -> true/false
        ts.target                   -> return the target (object or nil)
        ts.index        -> index of target (if hero)
        ts.nextPosition -> nextPosition predicted
        ts.nextHealth       -> nextHealth predicted
    Usage :
        variable = TargetSelector(mode, range, damageType (opt), targetSelected (opt), enemyTeam (opt))
        targetSelected is set to true if not filled
        Damages are set as default to magic 100 if none is set
        enemyTeam is false if ally, nil or true if enemy
        when you want to update, call variable:update()
        Values you can change on instance :
        variable.mode -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
        variable.range -> number > 0
        variable.targetSelected -> true/false (if you clicked on a champ)
    ex :
        function OnLoad()
            ts = TargetSelector(TARGET_LESS_CAST, 600, DAMAGE_MAGIC, true)
        end
        function OnTick()
            if ts.target ~= nil then
                PrintChat(ts.target.charName)
                ts:SetDamages((player.ap * 10), 0, 0)
            end
        end
]]
-- Class related constants
TARGET_LOW_HP = 1
TARGET_MOST_AP = 2
TARGET_MOST_AD = 3
TARGET_LESS_CAST = 4
TARGET_NEAR_MOUSE = 5
TARGET_PRIORITY = 6
TARGET_LOW_HP_PRIORITY = 7
TARGET_LESS_CAST_PRIORITY = 8
TARGET_DEAD = 9
TARGET_CLOSEST = 10
DAMAGE_MAGIC = 1
DAMAGE_PHYSICAL = 2
-- Class related global
local _TS_Draw
local _TargetSelector__texted = { "LowHP", "MostAP", "MostAD", "LessCast", "NearMouse", "Priority", "LowHPPriority", "LessCastPriority", "Dead", "Closest" }
function TS_Print(enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    for _, target in ipairs(_gameHeroes) do
        if target.hero ~= nil and target.hero.valid and target.enemy == enemyTeam then
            PrintChat("[TS] " .. (enemyTeam and "Enemy " or "Ally ") .. target.tIndex .. " (" .. target.index .. ") : " .. target.hero.charName .. " Mode=" .. (target.ignore and "ignore" or "target") .. " Priority=" .. target.priority)
        end
    end
end

function TS_SetFocus(target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local selected = _gameHeroes__hero(target, "TS_SetFocus")
    if selected ~= nil and selected.valid and selected.type == "obj_AI_Hero" and (selected.team ~= player.team) == enemyTeam then
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.enemy == enemyTeam then
                if _gameHero.hero.networkID == selected.networkID then
                    _gameHero.priority = 1
                    PrintChat("[TS] Focusing " .. _gameHero.hero.charName)
                else
                    _gameHero.priority = (enemyTeam and _gameEnemyCount or _gameAllyCount)
                end
            end
        end
    end
end

function TS_SetHeroPriority(priority, target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local heroCount = (enemyTeam and _gameEnemyCount or _gameAllyCount)
    assert(type(priority) == "number" and priority >= 0 and priority <= heroCount, "TS_SetHeroPriority: wrong argument types (<number> 1 to " .. heroCount .. " expected)")
    local selected = _gameHeroes__index(target, "TS_SetHeroPriority: wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)", enemyTeam)
    if selected ~= nil then
        local oldPriority = _gameHeroes[selected].priority
        if oldPriority == nil or oldPriority == priority then return end
        for index, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.enemy == enemyTeam then
                if index == selected then
                    _gameHero.priority = priority
                    --PrintChat("[TS] "..(enemyTeam and "Enemy " or "Ally ").._gameHero.tIndex.." (".._gameHero.index..") : " .. _gameHero.hero.charName .. " Mode=" .. (_gameHero.ignore and "ignore" or "target") .." Priority=" .. _gameHero.priority)
                end
            end
        end
    end
end

function TS_SetPriority(target1, target2, target3, target4, target5)
    assert((target5 ~= nil and _gameEnemyCount == 5) or (target4 ~= nil and _gameEnemyCount < 5) or (target3 ~= nil and _gameEnemyCount == 3) or (target2 ~= nil and _gameEnemyCount == 2) or (target1 ~= nil and _gameEnemyCount == 1), "TS_SetPriority: wrong argument types (" .. _gameEnemyCount .. " <target> expected)")
    TS_SetHeroPriority(1, target1)
    TS_SetHeroPriority(2, target2)
    TS_SetHeroPriority(3, target3)
    TS_SetHeroPriority(4, target4)
    TS_SetHeroPriority(5, target5)
end

function TS_SetPriorityA(target1, target2, target3, target4, target5)
    assert((target5 ~= nil and _gameAllyCount == 5) or (target4 ~= nil and _gameAllyCount < 5) or (target3 ~= nil and _gameAllyCount == 3) or (target2 ~= nil and _gameAllyCount == 2) or (target1 ~= nil and _gameAllyCount == 1), "TS_SetPriorityA: wrong argument types (" .. _gameAllyCount .. " <target> expected)")
    TS_SetHeroPriority(1, target1, false)
    TS_SetHeroPriority(2, target2, false)
    TS_SetHeroPriority(3, target3, false)
    TS_SetHeroPriority(4, target4, false)
    TS_SetHeroPriority(5, target5, false)
end

function TS_GetPriority(target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local index = _gameHeroes__index(target, "TS_GetPriority", enemyTeam)
    return (index and _gameHeroes[index].priority or nil), (enemyTeam and _gameEnemyCount or _gameAllyCount)
end

function TS_Ignore(target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local selected = _gameHeroes__hero(target, "TS_Ignore")
    if selected ~= nil and selected.valid and selected.type == "obj_AI_Hero" and (selected.team ~= player.team) == enemyTeam then
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.hero.networkID == selected.networkID and _gameHero.enemy == enemyTeam then
                _gameHero.ignore = not _gameHero.ignore
                --PrintChat("[TS] "..(_gameHero.ignore and "Ignoring " or "Re-targetting ").._gameHero.hero.charName)
                break
            end
        end
    end
end

local function _TS_Draw_Init()
    if not _TS_Draw then
        UpdateWindow()
        _TS_Draw = { y1 = 0, height = 0, fontSize = WINDOW_H and math.round(WINDOW_H / 54) or 14, width = WINDOW_W and math.round(WINDOW_W / 4.8) or 213, border = 2, background = 1413167931, textColor = 4290427578, redColor = 1422721024, greenColor = 1409321728, blueColor = 2684354716 }
        _TS_Draw.cellSize, _TS_Draw.midSize, _TS_Draw.row1, _TS_Draw.row2, _TS_Draw.row3, _TS_Draw.row4 = _TS_Draw.fontSize + _TS_Draw.border, _TS_Draw.fontSize / 2, _TS_Draw.width * 0.6, _TS_Draw.width * 0.7, _TS_Draw.width * 0.8, _TS_Draw.width * 0.9
    end
end

local function TS__DrawMenu(x, y, enemyTeam)
    assert(type(x) == "number" and type(y) == "number", "TS__DrawMenu: wrong argument types (<number>, <number> expected)")
    _TS_Draw_Init()
    local enemyTeam = (enemyTeam ~= false)
    local y1 = y
    for _, _gameHero in ipairs(_gameHeroes) do
        if _gameHero.enemy == enemyTeam then
            DrawLine(x - _TS_Draw.border, y1 + _TS_Draw.midSize, x + _TS_Draw.row1 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, (_gameHero.ignore and _TS_Draw.redColor or _TS_Draw.background))
            DrawText(_gameHero.hero.charName, _TS_Draw.fontSize, x, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row1, y1 + _TS_Draw.midSize, x + _TS_Draw.row2 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.background)
            DrawText("   " .. (_gameHero.ignore and "-" or tostring(_gameHero.priority)), _TS_Draw.fontSize, x + _TS_Draw.row1, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row2, y1 + _TS_Draw.midSize, x + _TS_Draw.row3 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
            DrawText("   -", _TS_Draw.fontSize, x + _TS_Draw.row2, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row3, y1 + _TS_Draw.midSize, x + _TS_Draw.row4 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
            DrawText("   +", _TS_Draw.fontSize, x + _TS_Draw.row3, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row4, y1 + _TS_Draw.midSize, x + _TS_Draw.width, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.redColor)
            DrawText("   X", _TS_Draw.fontSize, x + _TS_Draw.row4, y1, _TS_Draw.textColor)
            y1 = y1 + _TS_Draw.cellSize
        end
    end
    return y1
end

local function TS_ClickMenu(x, y, enemyTeam)
    assert(type(x) == "number" and type(y) == "number", "TS__DrawMenu: wrong argument types (<number>, <number> expected)")
    _TS_Draw_Init()
    local enemyTeam = (enemyTeam ~= false)
    local y1 = y
    for index, _gameHero in ipairs(_gameHeroes) do
        if _gameHero.enemy == enemyTeam then
            if CursorIsUnder(x + _TS_Draw.row2, y1, _TS_Draw.fontSize, _TS_Draw.fontSize) then
                TS_SetHeroPriority(math.max(1, _gameHero.priority - 1), index)
            elseif CursorIsUnder(x + _TS_Draw.row3, y1, _TS_Draw.fontSize, _TS_Draw.fontSize) then
                TS_SetHeroPriority(math.min((enemyTeam and _gameEnemyCount or _gameAllyCount), _gameHero.priority + 1), index)
            elseif CursorIsUnder(x + _TS_Draw.row4, y1, _TS_Draw.fontSize, _TS_Draw.fontSize) then TS_Ignore(index)
            end
            y1 = y1 + _TS_Draw.cellSize
        end
    end
    return y1
end

local __TargetSelector__OnSendChat
local function TargetSelector__OnLoad()
    if not __TargetSelector__OnSendChat then
        function __TargetSelector__OnSendChat(msg)
            if not msg or msg:sub(1, 3) ~= ".ts" then return end
            BlockChat()
            local args = {}
            while string.find(msg, " ") do
                local index = string.find(msg, " ")
                table.insert(args, msg:sub(1, index - 1))
                msg = string.sub(msg, index + 1)
            end
            table.insert(args, msg)
            local cmd = args[1]:lower()
            if cmd == ".tsprint" then
                TS_Print()
            elseif cmd == ".tsprinta" then
                TS_Print(false)
            elseif cmd == ".tsfocus" then
                PrintChat(cmd .. " - " .. args[2])
                TS_SetFocus(args[2])
            elseif cmd == ".tsfocusa" then
                TS_SetFocus(args[2], false)
            elseif cmd == ".tspriorityhero" then
                TS_SetHeroPriority(args[2], args[3])
            elseif cmd == ".tspriorityheroa" then
                TS_SetHeroPriority(args[2], args[3], false)
            elseif cmd == ".tspriority" then
                TS_SetPriority(args[2], args[3], args[4], args[5], args[6])
            elseif cmd == ".tsprioritya" then
                TS_SetPriorityA(args[2], args[3], args[4], args[5], args[6])
            elseif cmd == ".tsignore" then
                TS_Ignore(args[2])
            elseif cmd == ".tsignorea" then
                TS_Ignore(args[2], false)
            end
        end

        AddChatCallback(__TargetSelector__OnSendChat)
    end
end

class'TargetSelector'
function TargetSelector:__init(mode, range, damageType, targetSelected, enemyTeam)
    -- Init Global
    assert(type(mode) == "number" and type(range) == "number", "TargetSelector: wrong argument types (<mode>, <number> expected)")
    _gameHeroes__init()
    TargetSelector__OnLoad()
    self.mode = mode
    self.range = range
    self._mDmgBase, self._pDmgBase, self._tDmg = 0, 0, 0
    self._dmgType = damageType or DAMAGE_MAGIC
    if self._dmgType == DAMAGE_MAGIC then self._mDmgBase = 100 else self._pDmgBase = player.totalDamage end
    self.targetSelected = (targetSelected ~= false)
    self.enemyTeam = (enemyTeam ~= false)
    self.target = nil
    self._conditional = nil
    self._castWidth = nil
    self._pDelay = nil
    self._BBoxMode = false
end

function TargetSelector:printMode()
    PrintChat("[TS] Target mode: " .. _TargetSelector__texted[self.mode])
end

function TargetSelector:SetDamages(magicDmgBase, physicalDmgBase, trueDmg)
    assert(magicDmgBase == nil or type(magicDmgBase) == "number", "SetDamages: wrong argument types (<number> or nil expected) for magicDmgBase")
    assert(physicalDmgBase == nil or type(physicalDmgBase) == "number", "SetDamages: wrong argument types (<number> or nil expected) for physicalDmgBase")
    assert(trueDmg == nil or type(trueDmg) == "number", "SetDamages: wrong argument types (<number> or nil expected) for trueDmg")
    self._dmgType = 0
    self._mDmgBase = magicDmgBase or 0
    self._pDmgBase = physicalDmgBase or 0
    self._tDmg = trueDmg or 0
end

function TargetSelector:SetMinionCollision(castWidth, minionType)
    assert(castWidth == nil or type(castWidth) == "number", "SetMinionCollision: wrong argument types (<number> or nil expected)")
    self._castWidth = (castWidth and castWidth > 0) and castWidth
    if self._castWidth then
        local minionType = minionType or MINION_ENEMY
        self._minionTable = minionManager(minionType, self.range + 300)
    else
        self._minionTable = nil
    end
end

function TargetSelector:SetPrediction(delay)
    assert(delay == nil or type(delay) == "number", "SetPrediction: wrong argument types (<number> or nil expected)")
    _Prediction__OnLoad()
    self._pDelay = ((delay ~= nil and delay > 0) and delay or nil)
end

function TargetSelector:SetProjectileSpeed(pSpeed)
    assert(delay == nil or type(delay) == "number", "SetProjectileSpeed: wrong argument types (<number> or nil expected)")
    _Prediction__OnLoad()
    self._pSpeed = ((pSpeed ~= nil and pSpeed > 0) and pSpeed or nil)
end

function TargetSelector:SetConditional(func)
    assert(func == nil or type(func) == "function", "SetConditional : wrong argument types (<function> or nil expected)")
    self._conditional = func
end

function TargetSelector:SetBBoxMode(bbMode)
    assert(type(bbMode) == "boolean", "SetBBoxMode : wrong argument types (<boolean> expected)")
    self._BBoxMode = bbMode
end

function TargetSelector:_targetSelectedByPlayer()
    if self.targetSelected then
        local currentTarget = GetTarget()
        local validTarget = false
        if self._BBoxMode then
            validTarget = ValidBBoxTarget(currentTarget, self.range, self.enemyTeam)
        else
            validTarget = ValidTarget(currentTarget, self.range, self.enemyTeam)
        end
        if validTarget and (currentTarget.type == "obj_AI_Hero" or currentTarget.type == "obj_AI_Minion") and (self._conditional == nil or self._conditional(currentTarget)) then
            if self.target == nil or not self.target.valid or self.target.networkID ~= currentTarget.networkID then
                self.target = currentTarget
                self.index = _gameHeroes__index(currentTarget, "_targetSelectedByPlayer")
            end
            local delay = 0
            if self._pDelay ~= nil and self._pDelay > 0 then
                delay = delay + self._pDelay
            end
            if self._pSpeed ~= nil and self._pSpeed > 0 then
                delay = delay + (GetDistance(currentTarget) / self._pSpeed)
            end
            if self.index and delay > 0 then
                self.nextPosition = _PredictionPosition(self.index, delay)
                self.nextHealth = _PredictionHealth(self.index, delay)
            else
                self.nextPosition = Vector(currentTarget)
                self.nextHealth = currentTarget.health
            end
            return true
        end
    end
    return false
end

function TargetSelector:update()
    -- Resets the target if player died
    if player.dead then
        self.target = nil
        return
    end
    -- Get current selected target (by player) if needed
    if self:_targetSelectedByPlayer() then return end
    local selected, index, value, nextPosition, nextHealth
    local range = (self.mode == TARGET_NEAR_MOUSE and 2000 or self.range)
    if self._minionTable then self._minionTable:update() end
    for i, _gameHero in ipairs(_gameHeroes) do
        local hero = _gameHero.hero
        local validTarget = false
        if self._BBoxMode then
            validTarget = ValidBBoxTarget(hero, range, self.enemyTeam)
        else
            validTarget = ValidTarget(hero, range, self.enemyTeam)
        end
        if validTarget and not _gameHero.ignore and (self._conditional == nil or self._conditional(hero, i)) then
            local minionCollision = false
            local delay = 0
            local distanceValid = true
            if self._pDelay ~= nil and self._pDelay > 0 then
                delay = delay + self._pDelay
            end
            if self._pSpeed ~= nil and self._pSpeed > 0 then
                delay = delay + (GetDistance(hero) / self._pSpeed)
            end
            if delay > 0 then
                nextPosition = _PredictionPosition(i, delay)
                nextHealth = _PredictionHealth(i, delay)
                distanceValid = GetDistance(nextPosition) <= range
            else
                nextPosition, nextHealth = Vector(hero), hero.health
            end
            if self._castWidth then minionCollision = GetMinionCollision(player, nextPosition, self._castWidth, self._minionTable.objects) end
            if distanceValid and minionCollision == false then
                if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST or self.mode == TARGET_LESS_CAST_PRIORITY then
                    -- Returns lowest effective HP target that is in range
                    -- Or lowest cast to kill target that is in range
                    if self._dmgType == DAMAGE_PHYSICAL then self._pDmgBase = player.totalDamage end
                    local mDmg = (self._mDmgBase > 0 and player:CalcMagicDamage(hero, self._mDmgBase) or 0)
                    local pDmg = (self._pDmgBase > 0 and player:CalcDamage(hero, self._pDmgBase) or 0)
                    local totalDmg = mDmg + pDmg + self._tDmg
                    -- priority mode
                    if self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST_PRIORITY then
                        totalDmg = totalDmg / _gameHero.priority
                    end
                    local heroValue
                    if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY then
                        heroValue = hero.health - totalDmg
                    else
                        heroValue = hero.health / totalDmg
                    end
                    if not selected or heroValue < value then selected, index, value = hero, i, heroValue end
                elseif self.mode == TARGET_DEAD then
                    if self._dmgType == DAMAGE_PHYSICAL then self._pDmgBase = player.totalDamage end
                    local mDmg = (self._mDmgBase > 0 and player:CalcMagicDamage(hero, self._mDmgBase) or 0)
                    local pDmg = (self._pDmgBase > 0 and player:CalcDamage(hero, self._pDmgBase) or 0)
                    local totalDmg = mDmg + pDmg + self._tDmg
                    if hero.health - totalDmg <= 0 then
                        selected, index, value = hero, i, 0
                    end
                elseif self.mode == TARGET_MOST_AP then
                    -- Returns target that has highest AP that is in range
                    if not selected or hero.ap > selected.ap then selected, index = hero, i end
                elseif self.mode == TARGET_MOST_AD then
                    -- Returns target that has highest AD that is in range
                    if not selected or hero.totalDamage > selected.totalDamage then selected, index = hero, i end
                elseif self.mode == TARGET_PRIORITY then
                    -- Returns target with highest priority # that is in range
                    if not selected or _gameHero.priority < value then selected, index, value = hero, i, _gameHero.priority end
                elseif self.mode == TARGET_CLOSEST then
                    -- Returns target that is the closest to your champion.
                    local distance = GetDistanceSqr(hero)
                    if not selected or distance < value then selected, index, value = hero, i, distance end
                elseif self.mode == TARGET_NEAR_MOUSE then
                    -- Returns target that is the closest to the mouse cursor.
                    local distance = GetDistanceSqr(mousePos, hero)
                    if not selected or distance < value then selected, index, value = hero, i, distance end
                end
            end
        end
    end
    self.index = index
    self.target = selected
    self.nextPosition = nextPosition
    self.nextHealth = nextHealth
end

function TargetSelector:OnSendChat(msg, prefix)
    assert(type(prefix) == "string" and prefix ~= "" and prefix:lower() ~= "ts", "TS OnSendChat: wrong argument types (<string> (not TS) expected for prefix)")
    if msg:sub(1, 1) ~= "." then return end
    local prefix = prefix:lower()
    local length = prefix:len() + 1
    if msg:sub(1, length) ~= "." .. prefix then return end
    BlockChat()
    local args = {}
    while string.find(msg, " ") do
        local index = string.find(msg, " ")
        table.insert(args, msg:sub(1, index - 1))
        msg = msg:sub(index + 1)
    end
    table.insert(args, msg)
    local cmd = args[1]:lower()
    if cmd == "." .. prefix .. "mode" then
        assert(args[2] ~= nil, "TS OnSendChat: wrong argument types (LowHP, MostAP, MostAD, LessCast, NearMouse, Priority, LowHPPriority, LessCastPriority expected)")
        local index = 0
        for i, mode in ipairs({ "LowHP", "MostAP", "MostAD", "LessCast", "NearMouse", "Priority", "LowHPPriority", "LessCastPriority" }) do
            if mode:lower() == args[2]:lower() then
                index = i
                break
            end
        end
        assert(index ~= 0, "TS OnSendChat: wrong argument types (LowHP, MostAP, MostAD, LessCast, NearMouse, Priority, LowHPPriority, LessCastPriority expected)")
        self.mode = index
        self:printMode()
    end
end

function TargetSelector:DrawMenu(x, y)
    assert(type(x) == "number" and type(y) == "number", "ts:DrawMenu: wrong argument types (<number>, <number> expected)")
    _TS_Draw_Init()
    DrawLine(x - _TS_Draw.border, y + _TS_Draw.midSize, x + _TS_Draw.row3 - _TS_Draw.border, y + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.background)
    DrawText((self.name or "ts") .. " Mode : " .. _TargetSelector__texted[self.mode], _TS_Draw.fontSize, x, y, _TS_Draw.textColor)
    DrawLine(x + _TS_Draw.row3, y + _TS_Draw.midSize, x + _TS_Draw.row4 - _TS_Draw.border, y + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
    DrawText("   <", _TS_Draw.fontSize, x + _TS_Draw.row3, y, _TS_Draw.textColor)
    DrawLine(x + _TS_Draw.row4, y + _TS_Draw.midSize, x + _TS_Draw.width, y + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
    DrawText("   >", _TS_Draw.fontSize, x + _TS_Draw.row4, y, _TS_Draw.textColor)
    return y + _TS_Draw.cellSize
end

function TargetSelector:ClickMenu(x, y)
    assert(type(x) == "number" and type(y) == "number", "ts:ClickMenu: wrong argument types (<number>, <number>, <string> expected)")
    _TS_Draw_Init()
    if CursorIsUnder(x + _TS_Draw.row3, y, _TS_Draw.fontSize, _TS_Draw.fontSize) then
        self.mode = (self.mode == 1 and #_TargetSelector__texted or self.mode - 1)
    elseif CursorIsUnder(x + _TS_Draw.row4, y, _TS_Draw.fontSize, _TS_Draw.fontSize) then
        self.mode = (self.mode == #_TargetSelector__texted and 1 or self.mode + 1)
    end
    return y + _TS_Draw.cellSize
end



--  scriptConfig
--[[
	myConfig = scriptConfig("My Script Config Header", "thisScript")
	myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONOFF, defaultValue)
	myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONKEYDOWN, defaultValue, key)
	myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONKEYTOGGLE, defaultValue, key)
	myConfig:addParam(pVar, pText, SCRIPT_PARAM_SLICE, defaultValue, minValue, maxValue, decimalPlace)
	myConfig:addParam(pVar, pText, SCRIPT_PARAM_LIST, defaultValue, listTable)
	myConfig:addParam(pVar, pText, SCRIPT_PARAM_COLOR, defaultValue)
	myConfig:permaShow(pvar)    -- show this var in perma menu
	myConfig:addTS(ts)          -- add a ts instance
	myConfig:addSubMenu("My Sub Menu Header", "subMenu")
	var are myConfig.var
	function OnLoad()
		myConfig = scriptConfig("My Script Config", "thisScript.cfg")
		myConfig:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		myConfig:addParam("harass", "Harass mode", SCRIPT_PARAM_ONKEYTOGGLE, false, 78)
		myConfig:addParam("harassMana", "Harass Min Mana", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 2)
		myConfig:addParam("drawCircle", "Draw Circle", SCRIPT_PARAM_ONOFF, false)
		myConfig:addParam("circleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,0,0,255}) --{A,R,G,B}
		myConfig:addParam("multiOptions", "Multiple options", SCRIPT_PARAM_LIST, 2, { "First Option", "Default Option", "Third Option", "Just Another Option", "One More Option Baby" })
		myConfig:permaShow("harass")
		myConfig:permaShow("combo")
		ts = TargetSelector(TARGET_LOW_HP,500,DAMAGE_MAGIC,false)
		ts.name = "Q" -- set a name if you want to recognize it, otherwize, will show "ts"
		myConfig:addTS(ts)

		myConfig:addSubMenu("My Sub Menu Header", "subMenu")
		myConfig.subMenu:addParam("testOnOff", "Testing param in sub-menu", SCRIPT_PARAM_ONOFF, defaultValue)
		myConfig.subMenu:addParam("multiOptions", "Multi-opts in sub-menu", SCRIPT_PARAM_LIST, 1, { "Default", "Its", "Disco", "Baby" })
		myConfig.subMenu:permaShow("testOnOff")
		myConfig.subMenu:permaShow("multiOptions")
	end
	function OnTick()
		if myConfig.combo == true then
			-- bla
		elseif myConfig.harass then
			-- bla
		end
	end
]]
SCRIPT_PARAM_ONOFF = 1
SCRIPT_PARAM_ONKEYDOWN = 2
SCRIPT_PARAM_ONKEYTOGGLE = 3
SCRIPT_PARAM_SLICE = 4
SCRIPT_PARAM_INFO = 5
SCRIPT_PARAM_COLOR = 6
SCRIPT_PARAM_LIST = 7
local _SC = { init = true, initDraw = true, menuKey = 16, useTS = false, menuIndex = -1, instances = {}, _changeKey = false, _changeKeyInstance = false, _sliceInstance = false, _listInstance = false }
class'scriptConfig'
local function __SC__remove(name)
	if not GetSave("scriptConfig")[name] then GetSave("scriptConfig")[name] = {} end
	table.clear(GetSave("scriptConfig")[name])
end

local function __SC__load(name)
	if not GetSave("scriptConfig")[name] then GetSave("scriptConfig")[name] = {} end
	return GetSave("scriptConfig")[name]
end

local function __SC__save(name, content)
	if not GetSave("scriptConfig")[name] then GetSave("scriptConfig")[name] = {} end
	table.clear(GetSave("scriptConfig")[name])
	table.merge(GetSave("scriptConfig")[name], content, true)
end

local function __SC__saveMaster()
	local config = {}
	local P, PS, I = 0, 0, 0
	for _, instance in pairs(_SC.instances) do
		I = I + 1
		P = P + #instance._param
		PS = PS + #instance._permaShow
	end
	_SC.master["I" .. _SC.masterIndex] = I
	_SC.master["P" .. _SC.masterIndex] = P
	_SC.master["PS" .. _SC.masterIndex] = PS
	if not _SC.master.useTS and _SC.useTS then _SC.master.useTS = true end
	for var, value in pairs(_SC.master) do
		config[var] = value
	end
	__SC__save("Master", config)
end

local function __SC__updateMaster()
	_SC.master = __SC__load("Master")
	_SC.masterY, _SC.masterYp = 1, 0
	_SC.masterY = (_SC.master.useTS and 1 or 0)
	for i = 1, _SC.masterIndex - 1 do
		_SC.masterY = _SC.masterY + _SC.master["I" .. i]
		_SC.masterYp = _SC.masterYp + _SC.master["PS" .. i]
	end
	local size, sizep = (_SC.master.useTS and 2 or 1), 0
	for i = 1, _SC.master.iCount do
		size = size + _SC.master["I" .. i]
		sizep = sizep + _SC.master["PS" .. i]
	end
	_SC.draw.height = size * _SC.draw.cellSize
	_SC.pDraw.height = sizep * _SC.pDraw.cellSize
	_SC.draw.x = _SC.master.x
	_SC.draw.y = _SC.master.y
	_SC.pDraw.x = _SC.master.px
	_SC.pDraw.y = _SC.master.py
	_SC._Idraw.x = _SC.draw.x + _SC.draw.width + _SC.draw.border * 2
end

local function __SC__saveMenu()
	__SC__save("Menu", { menuKey = _SC.menuKey, draw = { x = _SC.draw.x, y = _SC.draw.y }, pDraw = { x = _SC.pDraw.x, y = _SC.pDraw.y } })
	_SC.master.x = _SC.draw.x
	_SC.master.y = _SC.draw.y
	_SC.master.px = _SC.pDraw.x
	_SC.master.py = _SC.pDraw.y
	__SC__saveMaster()
end

local function __SC__init_draw()
	if _SC.initDraw then
		UpdateWindow()
		_SC.draw = { x = WINDOW_W and math.floor(WINDOW_W / 50) or 20, y = WINDOW_H and math.floor(WINDOW_H / 4) or 190, y1 = 0, height = 0, fontSize = WINDOW_H and math.round(WINDOW_H / 54) or 14, width = WINDOW_W and math.round(WINDOW_W / 4.8) or 213, border = 2, background = 1413167931, textColor = 4290427578, trueColor = 1422721024, falseColor = 1409321728, move = false }
		_SC.pDraw = { x = WINDOW_W and math.floor(WINDOW_W * 0.66) or 675, y = WINDOW_H and math.floor(WINDOW_H * 0.8) or 608, y1 = 0, height = 0, fontSize = WINDOW_H and math.round(WINDOW_H / 72) or 10, width = WINDOW_W and math.round(WINDOW_W / 6.4) or 160, border = 1, background = 1413167931, textColor = 4290427578, trueColor = 1422721024, falseColor = 1409321728, move = false }
		local menuConfig = __SC__load("Menu")
		table.merge(_SC, menuConfig, true)
		_SC.color = { lgrey = 1413167931, grey = 4290427578, red = 1422721024, green = 1409321728, ivory = 4294967280 }
		_SC.draw.cellSize, _SC.draw.midSize, _SC.draw.row4, _SC.draw.row3, _SC.draw.row2, _SC.draw.row1 = _SC.draw.fontSize + _SC.draw.border, _SC.draw.fontSize / 2, _SC.draw.width * 0.9, _SC.draw.width * 0.8, _SC.draw.width * 0.7, _SC.draw.width * 0.6
		_SC.pDraw.cellSize, _SC.pDraw.midSize, _SC.pDraw.row = _SC.pDraw.fontSize + _SC.pDraw.border, _SC.pDraw.fontSize / 2, _SC.pDraw.width * 0.7
		_SC._Idraw = { x = _SC.draw.x + _SC.draw.width + _SC.draw.border * 2, y = _SC.draw.y, height = 0 }
		if WINDOW_H < 500 or WINDOW_W < 500 then return true end
		_SC.initDraw = nil
	end
	return _SC.initDraw
end

local function __SC__init(name)
	if name == nil then
		return (_SC.init or __SC__init_draw())
	end
	if _SC.init then
		_SC.init = nil
		__SC__init_draw()
		local gameStart = GetGame()
		_SC.master = __SC__load("Master")
		--[[ SurfaceS: Look into it! When loading the master, it screws up the Menu, when you change at the same time the running scripts.
		   if _SC.master.osTime ~= nil and _SC.master.osTime == gameStart.osTime then
			  for i = 1, _SC.master.iCount do
				  if _SC.master["name" .. i] == name then _SC.masterIndex = i end
			  end
			  if _SC.masterIndex == nil then
				  _SC.masterIndex = _SC.master.iCount + 1
				  _SC.master["name" .. _SC.masterIndex] = name
				  _SC.master.iCount = _SC.masterIndex
				  __SC__saveMaster()
			 end
		else]]
		__SC__remove("Master")
		_SC.masterIndex = 1
		_SC.master.useTS = false
		_SC.master.x = _SC.draw.x
		_SC.master.y = _SC.draw.y
		_SC.master.px = _SC.pDraw.x
		_SC.master.py = _SC.pDraw.y
		_SC.master.osTime = gameStart.osTime
		_SC.master.name1 = name
		_SC.master.iCount = 1
		__SC__saveMaster()
		--end
	end
	__SC__updateMaster()
end

local function __SC__txtKey(key)
	return (key > 32 and key < 96 and " " .. string.char(key) .. " " or "(" .. tostring(key) .. ")")
end

local function __SC__DrawInstance(header, selected)
	DrawLine(_SC.draw.x + _SC.draw.width / 2, _SC.draw.y1, _SC.draw.x + _SC.draw.width / 2, _SC.draw.y1 + _SC.draw.cellSize, _SC.draw.width + _SC.draw.border * 2, (selected and _SC.color.red or _SC.color.lgrey))
	DrawText(header, _SC.draw.fontSize, _SC.draw.x, _SC.draw.y1, (selected and _SC.color.ivory or _SC.color.grey))
	_SC.draw.y1 = _SC.draw.y1 + _SC.draw.cellSize
end

local function __SC__ResetSubIndexes()
	for i, instance in ipairs(_SC.instances) do
		instance:ResetSubIndexes()
	end
end

local __SC__OnDraw, __SC__OnWndMsg
local function __SC__OnLoad()
	if not __SC__OnDraw then
		function __SC__OnDraw()
			if __SC__init() or Console__IsOpen or GetGame().isOver then return end
			if IsKeyDown(_SC.menuKey) or _SC._changeKey then
				if _SC.draw.move then
					local cursor = GetCursorPos()
					_SC.draw.x = cursor.x - _SC.draw.offset.x
					_SC.draw.y = cursor.y - _SC.draw.offset.y
					_SC._Idraw.x = _SC.draw.x + _SC.draw.width + _SC.draw.border * 2
				elseif _SC.pDraw.move then
					local cursor = GetCursorPos()
					_SC.pDraw.x = cursor.x - _SC.pDraw.offset.x
					_SC.pDraw.y = cursor.y - _SC.pDraw.offset.y
				end
				if _SC.masterIndex == 1 then
					DrawLine(_SC.draw.x + _SC.draw.width / 2, _SC.draw.y, _SC.draw.x + _SC.draw.width / 2, _SC.draw.y + _SC.draw.height, _SC.draw.width + _SC.draw.border * 2, 1414812756) -- grey
					_SC.draw.y1 = _SC.draw.y
					local menuText = _SC._changeKey and not _SC._changeKeyVar and "press key for Menu" or "Menu"
					DrawText(menuText, _SC.draw.fontSize, _SC.draw.x, _SC.draw.y1, _SC.color.ivory) -- ivory
					DrawText(__SC__txtKey(_SC.menuKey), _SC.draw.fontSize, _SC.draw.x + _SC.draw.width * 0.9, _SC.draw.y1, _SC.color.grey)
				end
				_SC.draw.y1 = _SC.draw.y + _SC.draw.cellSize
				if _SC.useTS then
					__SC__DrawInstance("Target Selector", (_SC.menuIndex == 0))
					if _SC.menuIndex == 0 then
						DrawLine(_SC._Idraw.x + _SC.draw.width / 2, _SC.draw.y, _SC._Idraw.x + _SC.draw.width / 2, _SC.draw.y + _SC._Idraw.height, _SC.draw.width + _SC.draw.border * 2, 1414812756) -- grey
						DrawText("Target Selector", _SC.draw.fontSize, _SC._Idraw.x, _SC.draw.y, _SC.color.ivory)
						_SC._Idraw.y = TS__DrawMenu(_SC._Idraw.x, _SC.draw.y + _SC.draw.cellSize)
						_SC._Idraw.height = _SC._Idraw.y - _SC.draw.y
					end
				end
				_SC.draw.y1 = _SC.draw.y + _SC.draw.cellSize + (_SC.draw.cellSize * _SC.masterY)
				for index, instance in ipairs(_SC.instances) do
					__SC__DrawInstance(instance.header, (_SC.menuIndex == index))
					if _SC.menuIndex == index then instance:OnDraw() end
				end
			end
			local y1 = _SC.pDraw.y + (_SC.pDraw.cellSize * _SC.masterYp)
			local function DrawPermaShows(instance)

				if #instance._permaShow > 0 then
					for _, varIndex in ipairs(instance._permaShow) do
						local pVar = instance._param[varIndex].var
						DrawLine(_SC.pDraw.x - _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.x + _SC.pDraw.row - _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.cellSize, _SC.color.lgrey)
						DrawText(instance._param[varIndex].text, _SC.pDraw.fontSize, _SC.pDraw.x, y1, _SC.color.grey)
						if instance._param[varIndex].pType == SCRIPT_PARAM_SLICE or instance._param[varIndex].pType == SCRIPT_PARAM_LIST or instance._param[varIndex].pType == SCRIPT_PARAM_INFO then
							DrawLine(_SC.pDraw.x + _SC.pDraw.row, y1 + _SC.pDraw.midSize, _SC.pDraw.x + _SC.pDraw.width + _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.cellSize, _SC.color.lgrey)
							if instance._param[varIndex].pType == SCRIPT_PARAM_LIST then
								local text = tostring(instance._param[varIndex].listTable[instance[pVar]])
								local maxWidth = (_SC.pDraw.width - _SC.pDraw.row) * 0.8
								local textWidth = GetTextArea(text, _SC.pDraw.fontSize).x
								if textWidth > maxWidth then
									text = text:sub(1, math.floor(text:len() * maxWidth / textWidth)) .. ".."
								end
								DrawText(text, _SC.pDraw.fontSize, _SC.pDraw.x + _SC.pDraw.row, y1, _SC.color.grey)
							else
								DrawText(tostring(instance[pVar]), _SC.pDraw.fontSize, _SC.pDraw.x + _SC.pDraw.row + _SC.pDraw.border, y1, _SC.color.grey)
							end
						else
							DrawLine(_SC.pDraw.x + _SC.pDraw.row, y1 + _SC.pDraw.midSize, _SC.pDraw.x + _SC.pDraw.width + _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.cellSize, (instance[pVar] and _SC.color.green or _SC.color.lgrey))
							DrawText((instance[pVar] and "      ON" or "      OFF"), _SC.pDraw.fontSize, _SC.pDraw.x + _SC.pDraw.row + _SC.pDraw.border, y1, _SC.color.grey)
						end
						y1 = y1 + _SC.pDraw.cellSize
					end
				end
				for _, subInstance in ipairs(instance._subInstances) do
					DrawPermaShows(subInstance)
				end
			end
			for _, instance in ipairs(_SC.instances) do
				DrawPermaShows(instance)
			end
		end

		AddDrawCallback(__SC__OnDraw)
	end
	if not __SC__OnWndMsg then
		function __SC__OnWndMsg(msg, key)
			if __SC__init() or Console__IsOpen then return end
			local msg, key = msg, key
			if key == _SC.menuKey and _SC.lastKeyState ~= msg then
				_SC.lastKeyState = msg
				__SC__updateMaster()
			end
			if _SC._changeKey then
				if msg == KEY_DOWN then
					if _SC._changeKeyMenu then return end
					_SC._changeKey = false
					if _SC._changeKeyVar == nil then
						_SC.menuKey = key
						if _SC.masterIndex == 1 then __SC__saveMenu() end
					else
						_SC._changeKeyInstance._param[_SC._changeKeyVar].key = key
						_SC._changeKeyInstance:save()
						--_SC.instances[_SC.menuIndex]._param[_SC._changeKeyVar].key = key
						--_SC.instances[_SC.menuIndex]:save()
					end
					return
				else
					if _SC._changeKeyMenu and key == _SC.menuKey then _SC._changeKeyMenu = false end
				end
			end
			if msg == WM_LBUTTONDOWN and IsKeyDown(_SC.menuKey) then
				if CursorIsUnder(_SC.draw.x, _SC.draw.y, _SC.draw.width, _SC.draw.height) then
					_SC.menuIndex = -1
					__SC__ResetSubIndexes()
					if CursorIsUnder(_SC.draw.x + _SC.draw.width - _SC.draw.fontSize * 1.5, _SC.draw.y, _SC.draw.fontSize, _SC.draw.cellSize) then
						_SC._changeKey, _SC._changeKeyVar, _SC._changeKeyMenu = true, nil, true
						return
					elseif CursorIsUnder(_SC.draw.x, _SC.draw.y, _SC.draw.width, _SC.draw.cellSize) then
						_SC.draw.offset = Vector(GetCursorPos()) - _SC.draw
						_SC.draw.move = true
						return
					else
						if _SC.useTS and CursorIsUnder(_SC.draw.x, _SC.draw.y + _SC.draw.cellSize, _SC.draw.width, _SC.draw.cellSize) then _SC.menuIndex = 0 __SC__ResetSubIndexes() end
						local y1 = _SC.draw.y + _SC.draw.cellSize + (_SC.draw.cellSize * _SC.masterY)
						for index, _ in ipairs(_SC.instances) do
							if CursorIsUnder(_SC.draw.x, y1, _SC.draw.width, _SC.draw.cellSize) then _SC.menuIndex = index __SC__ResetSubIndexes() end
							y1 = y1 + _SC.draw.cellSize
						end
					end
				elseif CursorIsUnder(_SC.pDraw.x, _SC.pDraw.y, _SC.pDraw.width, _SC.pDraw.height) then
					_SC.pDraw.offset = Vector(GetCursorPos()) - _SC.pDraw
					_SC.pDraw.move = true
				elseif _SC.menuIndex == 0 then
					TS_ClickMenu(_SC._Idraw.x, _SC.draw.y + _SC.draw.cellSize)
				elseif _SC.menuIndex > 0 then
					local function CheckOnWndMsg(instance)
						if CursorIsUnder(instance._x, _SC.draw.y, _SC.draw.width, instance._height) then
							instance:OnWndMsg()
						elseif instance._subMenuIndex > 0 then
							CheckOnWndMsg(instance._subInstances[instance._subMenuIndex])
						end
					end
					CheckOnWndMsg(_SC.instances[_SC.menuIndex])
				end
			elseif msg == WM_LBUTTONUP then
				if _SC.draw.move or _SC.pDraw.move then
					_SC.draw.move = false
					_SC.pDraw.move = false
					if _SC.masterIndex == 1 then __SC__saveMenu() end
					return
				elseif _SC._sliceInstance then
					_SC._sliceInstance:save()
					_SC._sliceInstance._slice = false
					_SC._sliceInstance = false

					return
				elseif _SC._listInstance then
					_SC._listInstance:save()
					_SC._listInstance._list = false
					_SC._listInstance = false
				end
			else
				local function CheckOnWndMsg(instance)

					for _, param in ipairs(instance._param) do
						if param.pType == SCRIPT_PARAM_ONKEYTOGGLE and key == param.key and msg == KEY_DOWN then
							instance[param.var] = not instance[param.var]
							--if param.fn then param.fn(instance,param.var) end --fter44:
							if param.fn then param.fn(instance[param.var]) end --fter44:
						elseif param.pType == SCRIPT_PARAM_ONKEYDOWN and key == param.key then
							instance[param.var] = (msg == KEY_DOWN)
						end
					end
					for _, subInstance in ipairs(instance._subInstances) do
						CheckOnWndMsg(subInstance)
					end
				end
				for _, instance in ipairs(_SC.instances) do
					CheckOnWndMsg(instance)
				end
			end
		end

		AddMsgCallback(__SC__OnWndMsg)
	end
end

function scriptConfig:__init(header, name, parent)
	assert((type(header) == "string") and (type(name) == "string"), "scriptConfig: expected <string>, <string>)")
	if not parent then
		__SC__init(name)
		__SC__OnLoad()
	else
		self._parent = parent
	end
	self.header = header
	self.name = name
	self._tsInstances = {}
	self._param = {}
	self._permaShow = {}
	self._subInstances = {}
	self._subMenuIndex = 0
	self._x = parent and (parent._x + _SC.draw.width + _SC.draw.border*2) or _SC._Idraw.x
	self._y = 0
	self._height = 0
	self._slice = false

	
	table.insert(parent and parent._subInstances or _SC.instances, self)
	
	if parent==nil then
		table.sort(_SC.instances, 
		function(x,y)
			return x.header < y.header
		end)
	end
	
	return self
	
end

function scriptConfig:addSubMenu(header, name)
	assert((type(header) == "string") and (type(name) == "string"), "scriptConfig: expected <string>, <string>)")

	local subName = self.name .. "_" .. name
	local sub = scriptConfig(header, subName, self)
	self[name] = sub
	
	return sub
end

--[[
		myConfig = scriptConfig("My Script Config Header", "thisScript")
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONKEYDOWN, defaultValue, key)
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONOFF, defaultValue)
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONKEYTOGGLE, defaultValue, key)
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_SLICE, defaultValue, minValue, maxValue, decimalPlace)
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_LIST, defaultValue, listTable)
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_COLOR, defaultValue)
		myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONOFF, defaultValue)
	]]--

function scriptConfig:addParam(pVar, pText, pType, defaultValue, a, b, c, fn)--fter44:
	assert(type(pVar) == "string" and type(pText) == "string" and type(pType) == "number", "addParam: wrong argument types (<string>, <string>, <pType> expected)")
	assert(string.find(pVar, "[^%a%d]") == nil, "addParam: pVar should contain only char and number")
	--assert(self[pVar] == nil, "addParam: pVar should be unique, already existing " .. pVar)
	local newParam = { var = pVar, text = pText, pType = pType, fn=fn}--local newParam = { var = pVar, text = pText, pType = pType,}
	if pType == SCRIPT_PARAM_ONOFF then
		assert(type(defaultValue) == "boolean", "addParam: wrong argument types (<boolean> expected)")
	elseif pType == SCRIPT_PARAM_COLOR then
		assert(type(defaultValue) == "table", "addParam: wrong argument types (<table> expected)")
		assert(#defaultValue == 4, "addParam: wrong argument ({a,r,g,b} expected)")
	elseif pType == SCRIPT_PARAM_ONKEYDOWN or pType == SCRIPT_PARAM_ONKEYTOGGLE then
		assert(type(defaultValue) == "boolean" and type(a) == "number", "addParam: wrong argument types (<boolean> <number> expected)")
		newParam.key = a
	elseif pType == SCRIPT_PARAM_SLICE then
		assert(type(defaultValue) == "number" and type(a) == "number" and type(b) == "number" and (type(c) == "number" or c == nil), "addParam: wrong argument types (pVar, pText, pType, defaultValue, valMin, valMax, decimal) expected")
		newParam.min = a
		newParam.max = b
		newParam.idc = c or 0
		newParam.cursor = 0
	elseif pType == SCRIPT_PARAM_LIST then
		assert(type(defaultValue) == "number" and type(a) == "table", "addParam: wrong argument types (pVar, pText, pType, defaultValue, listTable) expected")
		newParam.listTable = a
		newParam.min = 1
		newParam.max = #a
		newParam.cursor = 0
	end
	self[pVar] = defaultValue
	table.insert(self._param, newParam)
	__SC__saveMaster()
	self:load()
	
	return #self._param
end

function scriptConfig:addParam2(pVar, pText, pType, defaultValue, a, b) --add b-th param
	local newParam = { var = pVar, text = pText, pType = pType }

	newParam.key = a

	self[pVar] = defaultValue
	--table.insert(self._param, newParam) : what original addParam does
	self._param[b]= newParam
	__SC__saveMaster()
	self:load()
end

function scriptConfig:addTS(tsInstance)
	assert(type(tsInstance.mode) == "number", "addTS: expected TargetSelector)")
	_SC.useTS = true
	table.insert(self._tsInstances, tsInstance)
	__SC__saveMaster()
	self:load()
end

function scriptConfig:permaShow(pVar)
	assert(type(pVar) == "string" and self[pVar] ~= nil, "permaShow: existing pVar expected)")
	for index, param in ipairs(self._param) do
		if param.var == pVar then
			table.insert(self._permaShow, index)
		end
	end
	__SC__saveMaster()
end

function scriptConfig:_txtKey(key)
	return (key > 32 and key < 96 and " " .. string.char(key) .. " " or "(" .. tostring(key) .. ")")
end

function scriptConfig:OnDraw()
	self._x = self._parent and (self._parent._x + _SC.draw.width + _SC.draw.border*2) or _SC._Idraw.x
	if self._slice and _SC._sliceInstance then
		local pre_var = self[self._param[self._slice].var]
		local cursorX = math.min(math.max(0, GetCursorPos().x - self._x - _SC.draw.row3), _SC.draw.width - _SC.draw.row3)
		self[self._param[self._slice].var] = math.round(self._param[self._slice].min + cursorX / (_SC.draw.width - _SC.draw.row3) * (self._param[self._slice].max - self._param[self._slice].min), self._param[self._slice].idc)
		if pre_var~=self[self._param[self._slice].var] then --fter44:slice value changed
		--	print("slice value changed to "..self[self._param[self._slice].var])
			if self._param[self._slice].fn then self._param[self._slice].fn(self[self._param[self._slice].var]) end
		end
	end
	self._y = _SC.draw.y
	DrawLine(self._x + _SC.draw.width / 2, self._y, self._x + _SC.draw.width / 2, self._y + self._height, _SC.draw.width + _SC.draw.border * 2, 1414812756) -- grey
	local menuText = _SC._changeKey and _SC._changeKeyVar and _SC._changeKeyInstance and _SC._changeKeyInstance.name == self.name and "press key for " .. self._param[_SC._changeKeyVar].var or self.header
	DrawText(menuText, _SC.draw.fontSize, self._x, self._y, 4294967280) -- ivory
	self._y = self._y + _SC.draw.cellSize
	for index, _ in ipairs(self._subInstances) do
		self:_DrawSubInstance(index)
		if self._subMenuIndex == index then _:OnDraw() end
	end

	if #self._tsInstances > 0 then
		--_SC._Idraw.y = TS__DrawMenu(_SC._Idraw.x, _SC._Idraw.y)
		for _, tsInstance in ipairs(self._tsInstances) do
			self._y = tsInstance:DrawMenu(self._x, self._y)
		end
	end
	for index, _ in ipairs(self._param) do
		self:_DrawParam(index)
	end
	self._height = self._y - _SC.draw.y
	if self._list and _SC._listInstance and self._listY then
		local cursorY = math.min(GetCursorPos().y - self._listY, _SC.draw.cellSize * (self._param[self._list].max))
		if cursorY >= 0 then
			local pre_var = self[self._param[self._list].var]
			self[self._param[self._list].var] = math.round(self._param[self._list].min + cursorY / (_SC.draw.cellSize * (self._param[self._list].max)) * (self._param[self._list].max - self._param[self._list].min))
			if pre_var~=self[self._param[self._list].var] then --fter44:list var changed
				--print("var changed to "..self[self._param[self._list].var])
				if self._param[self._list].fn then self._param[self._list].fn(self[self._param[self._list].var]) end
			end
		end
		local maxWidth = 0
		for i, el in pairs(self._param[self._list].listTable) do
			maxWidth = math.max(maxWidth, GetTextArea(el, _SC.draw.fontSize).x)
		end
		-- BG:
		DrawRectangle(self._x + _SC.draw.row3, self._listY, maxWidth, self._param[self._list].max * _SC.draw.cellSize, ARGB(230,50,50,50))
		-- SELECTED:
		DrawRectangle(self._x + _SC.draw.row3, self._listY + (self[self._param[self._list].var]-1) * _SC.draw.cellSize, maxWidth, _SC.draw.cellSize, _SC.color.green)
		for i, el in pairs(self._param[self._list].listTable) do
			DrawText(el, _SC.draw.fontSize, self._x + _SC.draw.row3, self._listY + (i-1) * _SC.draw.cellSize, 4294967280)
		end
	end
end

function scriptConfig:_DrawSubInstance(index)
	local pVar = self._subInstances[index].name
	local selected = self._subMenuIndex == index
	DrawLine(self._x - _SC.draw.border, self._y + _SC.draw.midSize, self._x + _SC.draw.width + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, (selected and _SC.color.red or _SC.color.lgrey))
	DrawText(self._subInstances[index].header, _SC.draw.fontSize, self._x, self._y, (selected and _SC.color.ivory or _SC.color.grey))
	DrawText("        >>", _SC.draw.fontSize, self._x + _SC.draw.row3 + _SC.draw.border, self._y, (selected and _SC.color.ivory or _SC.color.grey))
	--_SC._Idraw.y = _SC._Idraw.y + _SC.draw.cellSize
	self._y = self._y + _SC.draw.cellSize
end

function scriptConfig:_DrawParam(varIndex)
	local pVar = self._param[varIndex].var
	DrawLine(self._x - _SC.draw.border, self._y + _SC.draw.midSize, self._x + _SC.draw.row3 - _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, _SC.color.lgrey)
	DrawText(self._param[varIndex].text, _SC.draw.fontSize, self._x, self._y, _SC.color.grey)
	if self._param[varIndex].pType == SCRIPT_PARAM_SLICE then
		DrawText(tostring(self[pVar]), _SC.draw.fontSize, self._x + _SC.draw.row2, self._y, _SC.color.grey)
		DrawLine(self._x + _SC.draw.row3, self._y + _SC.draw.midSize, self._x + _SC.draw.width + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, _SC.color.lgrey)
		-- cursor
		self._param[varIndex].cursor = (self[pVar] - self._param[varIndex].min) / (self._param[varIndex].max - self._param[varIndex].min) * (_SC.draw.width - _SC.draw.row3)
		DrawLine(self._x + _SC.draw.row3 + self._param[varIndex].cursor - _SC.draw.border, self._y + _SC.draw.midSize, self._x + _SC.draw.row3 + self._param[varIndex].cursor + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, 4292598640)
	elseif self._param[varIndex].pType == SCRIPT_PARAM_LIST then
		local text = tostring(self._param[varIndex].listTable[self[pVar]])
		local maxWidth = (_SC.draw.width - _SC.draw.row3) * 0.8
		local textWidth = GetTextArea(text, _SC.draw.fontSize).x
		if textWidth > maxWidth then
			text = text:sub(1, math.floor(text:len() * maxWidth / textWidth)) .. ".."
		end
		DrawText(text, _SC.draw.fontSize, self._x + _SC.draw.row3, self._y, _SC.color.grey)
		if self._list and _SC._listInstance then self._listY = self._y + _SC.draw.cellSize end
	elseif self._param[varIndex].pType == SCRIPT_PARAM_INFO then
		DrawText(tostring(self[pVar]), _SC.draw.fontSize, self._x + _SC.draw.row3 + _SC.draw.border, self._y, _SC.color.grey)
	elseif self._param[varIndex].pType == SCRIPT_PARAM_COLOR then
		DrawRectangle(self._x + _SC.draw.row3 + _SC.draw.border, self._y, 80, _SC.draw.cellSize, ARGB(self[pVar][1], self[pVar][2], self[pVar][3], self[pVar][4]))
	else
		if (self._param[varIndex].pType == SCRIPT_PARAM_ONKEYDOWN or self._param[varIndex].pType == SCRIPT_PARAM_ONKEYTOGGLE) then
			DrawText(self:_txtKey(self._param[varIndex].key), _SC.draw.fontSize, self._x + _SC.draw.row2, self._y, _SC.color.grey)
		end
		DrawLine(self._x + _SC.draw.row3, self._y + _SC.draw.midSize, self._x + _SC.draw.width + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, (self[pVar] and _SC.color.green or _SC.color.lgrey))
		DrawText((self[pVar] and "        ON" or "        OFF"), _SC.draw.fontSize, self._x + _SC.draw.row3 + _SC.draw.border, self._y, _SC.color.grey)
	end
	self._y = self._y + _SC.draw.cellSize
end

function scriptConfig:load()
	local function sensitiveMerge(base, t)
		for i, v in pairs(t) do
			if type(base[i]) == type(v) then
				if type(v) == "table" then sensitiveMerge(base[i], v)
				else base[i] = v
				end
			end
		end
	end

	local config = __SC__load(self.name)
	for var, value in pairs(config) do
		if type(value) == "table" then
			if self[var] then sensitiveMerge(self[var], value) end
		else self[var] = value
		end
	end
end

function scriptConfig:save()
	local content = {}
	content._param = content._param or {}
	for var, param in pairs(self._param) do
		if param.pType ~= SCRIPT_PARAM_INFO then
			content[param.var] = self[param.var]
			if param.pType == SCRIPT_PARAM_ONKEYDOWN or param.pType == SCRIPT_PARAM_ONKEYTOGGLE then
				content._param[var] = { key = param.key }
			end
		end
	end
	content._tsInstances = content._tsInstances or {}
	for i, ts in pairs(self._tsInstances) do
		content._tsInstances[i] = { mode = ts.mode }
	end
	-- for i,pShow in pairs(self._permaShow) do
	-- table.insert (content, "_permaShow."..i.."="..tostring(pShow))
	-- end
	__SC__save(self.name, content)
end

function scriptConfig:ResetSubIndexes()
	if self._subMenuIndex > 0 then
		self._subInstances[self._subMenuIndex]:ResetSubIndexes()
		self._subMenuIndex = 0
	end
end

function scriptConfig:OnWndMsg()
	local y1 = _SC.draw.y + _SC.draw.cellSize
	if CursorIsUnder(self._x, _SC.draw.y, _SC.draw.width + _SC.draw.border, _SC.draw.cellSize) then self:ResetSubIndexes() end
	for i, instance in ipairs(self._subInstances) do
		if CursorIsUnder(self._x, y1, _SC.draw.width + _SC.draw.border, _SC.draw.cellSize) then self._subMenuIndex = i return end
		y1 = y1 + _SC.draw.cellSize
	end
	if #self._tsInstances > 0 then
		for _, tsInstance in ipairs(self._tsInstances) do
			y1 = tsInstance:ClickMenu(self._x, y1)
		end
	end
	for i, param in ipairs(self._param) do
		if param.pType == SCRIPT_PARAM_ONKEYDOWN or param.pType == SCRIPT_PARAM_ONKEYTOGGLE then --change key
			if CursorIsUnder(self._x + _SC.draw.row2, y1, _SC.draw.fontSize, _SC.draw.fontSize) then
				_SC._changeKey, _SC._changeKeyVar, _SC._changeKeyMenu = true, i, true
				_SC._changeKeyInstance = self
				self:ResetSubIndexes()
				return
			end
		end
		if param.pType == SCRIPT_PARAM_ONOFF or param.pType == SCRIPT_PARAM_ONKEYTOGGLE then    --press on_off
			if CursorIsUnder(self._x + _SC.draw.row3, y1, _SC.draw.width - _SC.draw.row3, _SC.draw.fontSize) then
				self[param.var] = not self[param.var] if param.fn then param.fn(self[param.var]) end--call fn fter44:
				self:save()
				self:ResetSubIndexes()
				return
			end
		end
		if param.pType == SCRIPT_PARAM_COLOR then
			if CursorIsUnder(self._x + _SC.draw.row3, y1, _SC.draw.width - _SC.draw.row3, _SC.draw.fontSize) then
				__CP(nil, nil, self[param.var][1], self[param.var][2], self[param.var][3], self[param.var][4], self[param.var])
				self:save()
				self:ResetSubIndexes()
				return
			end
		end
		if param.pType == SCRIPT_PARAM_SLICE then
			if CursorIsUnder(self._x + _SC.draw.row3 - _SC.draw.border, y1, WINDOW_W, _SC.draw.fontSize) then
				self._slice = i
				_SC._sliceInstance = self
				self:ResetSubIndexes()

				return
			end
		end
		if param.pType == SCRIPT_PARAM_LIST then
			if CursorIsUnder(self._x + _SC.draw.row3 - _SC.draw.border, y1, WINDOW_W, _SC.draw.fontSize) then
				self._list = i
				_SC._listInstance = self
				self:ResetSubIndexes()

				return
			end
		end
		y1 = y1 + _SC.draw.cellSize
	end
end

function scriptConfig:removeParam(pVar)
    assert(type(pVar) == "string" and self[pVar] ~= nil, "removeParam: existing pVar expected)")
    for index, param in ipairs(self._param) do
        if param.var == pVar then
			self._param[index]=nil
        end
    end
	self[pVar]=nil
end
