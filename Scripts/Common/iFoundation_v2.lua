require "Collision"

-- class "Misc" -- {

	NONE = 0
	ALLY = 1
	ENEMY = 2
	NEUTRAL = 4
	ALL = 7
	
	local AutoP = nil 

	function ArrayContains(haystack, needle) 
		for _, d in pairs(haystack) do
			if d == needle then
				return true 
			end 
		end 
		return false
	end 

	function round(num)
	    under = math.floor(num)
	    upper = math.floor(num) + 1
	    underV = -(under - num)
	    upperV = upper - num
	    if (upperV > underV) then
	        return under
	    else
	        return upper
	    end
	end	

	local _enemyMinions, _enemyMinionsUpdateDelay, _lastMinionsUpdate = nil, 0, 0
	function enemyMinions_update(range)
		if not _enemyMinions then
			_enemyMinions = minionManager(MINION_ENEMY, (range or 2000), myHero, MINION_SORT_HEALTH_ASC)
		elseif range and range > _enemyMinions.range then
			_enemyMinions.range = range
		end
		if _lastMinionsUpdate + _enemyMinionsUpdateDelay < GetTickCount() then
			_enemyMinions:update()
			_lastMinionsUpdate = GetTickCount()
		end
	end

	function enemyMinions_setDelay(delay)
		_enemyMinionsUpdateDelay = delay or 0
	end

	function getEnemyMinions()
		enemyMinions_update()
		return _enemyMinions.objects
	end

	local jungleCamps = {
		["TT_Spiderboss7.1.1"] = true,
		["Worm12.1.1"] = true,
		["Dragon6.1.1"] = true,
		["AncientGolem1.1.1"] = true,
		["AncientGolem7.1.1"] =  true,
		["LizardElder4.1.1"] =  true,
		["LizardElder10.1.1"] = true,
		["GiantWolf2.1.3"] = true,
		["GiantWolf8.1.3"] = true,
		["Wraith3.1.3"] = true,
		["Wraith9.1.3"] = true,
		["Golem5.1.2"] = true,
		["Golem11.1.2"] = true,
	}
	local _jungleMinions = nil
	function getJungleMinions()
		if not _jungleMinions then
			_jungleMinions = {}
			for i = 1, objManager.maxObjects do
				local object = objManager:getObject(i)
				if object and object.type == "obj_AI_Minion" and object.name and jungleCamps[object.name] then
					_jungleMinions[#_jungleMinions+1] = object
				end
			end
			function jungleMinions_OnCreateObj(object)
				if object and object.type == "obj_AI_Minion" and object.name and jungleCamps[object.name] then
					_jungleMinions[#_jungleMinions+1] = object
				end
			end
			function jungleMinions_OnDeleteObj(object)
				if object and object.type == "obj_AI_Minion" and object.name and jungleCamps[object.name] then
					for i, minion in ipairs(_jungleMinions) do
						if minion.name == object.name then
							table.remove(_jungleMinions, i)
						end
					end
				end
			end
			AddCreateObjCallback(jungleMinions_OnCreateObj)
			AddDeleteObjCallback(jungleMinions_OnDeleteObj)
		end
		return _jungleMinions
	end

	function iCollision(endPos, width) -- Derp collision, altered a bit for own readability.
		enemyMinions_update()
		if not endPos or not width then return end
		for _, minion in pairs(_enemyMinions.objects) do
			if ValidTarget(minion) and myHero.x ~= minion.x then
				local myX = myHero.x
				local myZ = myHero.z
				local tarX = endPos.x
				local tarZ = endPos.z
				local deltaX = myX - tarX
				local deltaZ = myZ - tarZ
				local m = deltaZ/deltaX
				local c = myX - m*myX
				local minionX = minion.x
				local minionZ = minion.z
				local distanc = (math.abs(minionZ - m*minionX - c))/(math.sqrt(m*m+1))
				if distanc < width and ((tarX - myX)*(tarX - myX) + (tarZ - myZ)*(tarZ - myZ)) > ((tarX - minionX)*(tarX - minionX) + (tarZ - minionZ)*(tarZ - minionZ)) then
					return true
				end
			end
	   end
	   return false
	end

	local SpellString = {
		["Q"] = _Q, 
		["W"] = _W,
		["E"] = _E, 
		["R"] = _R 
	}

	function SpellToString(spell) 
		for i, s in pairs(SpellString) do 
			if s == spell then
				return i
			end 
		end 
	end 
-- }

class 'Caster' -- {

	SPELL_TARGETED = 1
	SPELL_LINEAR = 2
	SPELL_CIRCLE = 3
	SPELL_CONE = 4
	SPELL_LINEAR_COL = 5
	SPELL_SELF = 6

	function Caster:__init(spell, range, spellType, speed, delay, width, useCollisionLib)
		--assert(spell and (range or spellType == SPELL_SELF), "Error: Caster:__init(spell, range, spellType, [speed, delay, width, useCollisionLib]), invalid arguments.")
		self.spell = spell
		self.range = range or 0
		self.spellType = spellType or SPELL_SELF
		self.speed = speed or math.huge
		self.delay = delay or 0
		self.width = width or 100
		self.spellData = myHero:GetSpellData(spell)
		if range ~= math.huge and range > 0 then
			Drawing.AddSkill(self.spell, self.range)
		end 
		if spellType == SPELL_LINEAR or spellType == SPELL_CIRCLE or spellType == SPELL_LINEAR_COL then
			--if type(range) == "number" and (not speed or type(speed) == "number") and (not delay type(delay) == "number" and (type(width) == "number" or not width) then
				--assert(type(range) == "number" and type(speed) == "number" and type(delay) == "number" and (type(width) == "number" or not width), "Error: Caster:__init(spell, range, [spellType, speed, delay, width, useCollisionLib]), invalid arguments for skillshot-type.")
				self.pred = VIP_USER and TargetPredictionVIP(range, speed, delay, width) or TargetPrediction(range, speed/1000, delay*1000, width)
				if spellType == SPELL_LINEAR_COL then
					self.coll = VIP_USER and useCollisionLib ~= false and Collision(range, (speed or math.huge), delay, width) or nil
				end
			--end
		end

		if AutoP == nil then
			AutoP = AutoPotion()
		end 
	end

	function Caster:__type()
		return "Caster"
	end

	function Caster:Cast(target, minHitChance)
		if myHero:CanUseSpell(self.spell) ~= READY then return false end
		if self.spellType == SPELL_SELF then
			CastSpell(self.spell)
			return true
		elseif self.spellType == SPELL_TARGETED then
			if ValidTarget(target, self.range) then
				CastSpell(self.spell, target)
				return true
			end
		elseif self.spellType == SPELL_TARGETED_FRIENDLY then
			if target ~= nil and not target.dead and GetDistance(target) < self.range and target.team == myHero.team then
				CastSpell(self.spell, target)
				return true
			end
		elseif self.spellType == SPELL_CONE then
			if ValidTarget(target, self.range) then
				CastSpell(self.spell, target.x, target.z)
				return true
			end
		elseif self.spellType == SPELL_LINEAR or self.spellType == SPELL_CIRCLE then
			if self.pred and ValidTarget(target) then
				local spellPos,_ = self.pred:GetPrediction(target)
				if spellPos and (not VIP_USER or not minHitChance or self.pred:GetHitChance(target) > minHitChance) then
					CastSpell(self.spell, spellPos.x, spellPos.z)
					return true
				end
			elseif target.team == myHero.team then
				CastSpell(self.spell, target.x, target.z)
			end 
		elseif self.spellType == SPELL_LINEAR_COL then
			if self.pred and ValidTarget(target) then
				local spellPos,_ = self.pred:GetPrediction(target)
				if spellPos and (not VIP_USER or not minHitChance or self.pred:GetHitChance(target) > minHitChance) then
					if self.coll then
						local willCollide,_ = self.coll:GetMinionCollision(myHero, spellPos)
						if not willCollide then
							CastSpell(self.spell, spellPos.x, spellPos.z)
							return true
						end
					elseif not iCollision(spellPos, self.width) then
						CastSpell(self.spell, spellPos.x, spellPos.z)
						return true
					end
				end
			end
		end
		return false
	end

	function Caster:CastMouse(spellPos, nearestTarget)
		--assert(spellPos and spellPos.x and spellPos.z, "Error: iCaster:CastMouse(spellPos, nearestTarget), invalid spellPos.")
		--assert(self.spellType ~= SPELL_TARGETED or (nearestTarget == nil or type(nearestTarget) == "boolean"), "Error: iCaster:CastMouse(spellPos, nearestTarget), <boolean> or nil expected for nearestTarget.")
		if myHero:CanUseSpell(self.spell) ~= READY then return false end
		if self.spellType == SPELL_SELF then
			CastSpell(self.spell)
			return true
		elseif self.spellType == SPELL_TARGETED then
			if nearestTarget ~= false then
				local targetEnemy
				for _, enemy in ipairs(GetEnemyHeroes()) do
					if ValidTarget(targetEnemy, self.range) and (targetEnemy == nil or GetDistanceFromMouse(enemy) < GetDistanceFromMouse(targetEnemy)) then
						targetEnemy = enemy
					end
				end
				if targetEnemy then
					CastSpell(self.spell, targetEnemy)
					return true
				end
			end
		elseif self.spellType == SPELL_LINEAR_COL or self.spellType == SPELL_LINEAR or self.spellType == SPELL_CIRCLE or self.spellType == SPELL_CONE then
			CastSpell(self.spell, spellPos.x, spellPos.z)
			return true
		end
	end

	function Caster:Ready()
		return myHero:CanUseSpell(self.spell) == READY
	end

	function Caster:GetPrediction(target)
		if self.pred and ValidTarget(target) then return self.pred:GetPrediction(target) end
	end

	function Caster:GetCollision(spellPos)
		if spellPos and spellPos.x and spellPos.z then
			if self.coll then
				return self.coll:GetMinionCollision(myHero, spellPos)
			else
				return iCollision(spellPos, self.width)
			end
		end
	end
-- }

class "Priority" -- {

	local priorityTable = {
		AP = {
			"Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
			"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
			"Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi",
		},
		Support = {
			"Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Sona", "Soraka", "Thresh", "Zilean",
		},
		Tank = {
			"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
			"Warwick", "Yorick", "Zac", "Nunu", "Taric", "Alistar",
		},
		AD_Carry = {
			"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
			"Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed",
		},
		Bruiser = {
			"Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nautilus", "Nocturne", "Olaf", "Poppy",
			"Renekton", "Rengar", "Riven", "Shyvana", "Trundle", "Tryndamere", "Udyr", "Vi", "MonkeyKing", "XinZhao", "Aatrox"
		},
	}

	local SupportTable = {
		AD_Carry = {
			"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
			"Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed",
		},
		Bruiser = {
			"Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nautilus", "Nocturne", "Olaf", "Poppy",
			"Renekton", "Rengar", "Riven", "Shyvana", "Trundle", "Tryndamere", "Udyr", "Vi", "MonkeyKing", "XinZhao", "Aatrox"
		},
		Tank = {
			"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
			"Warwick", "Yorick", "Zac", "Nunu", "Taric", "Alistar",
		},
		AP = {
			"Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
			"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
			"Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi",
		},
		Support = {
			"Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Sona", "Soraka", "Thresh", "Zilean",
		},	
	}

	Priority.instance = ""

	function Priority.Instance(bool) 
		if Priority.instance == "" then Priority.instance = Priority(bool) end return Priority.instance
 	end 

	function Priority:__init(support)
		if support then
			priorityTable = SupportTable 
		end 
		if #GetEnemyHeroes() > 1 then
			TargetSelector(TARGET_LESS_CAST_PRIORITY, 0)
			self:arrangePrioritys(#GetEnemyHeroes())
		end
	end

	function Priority:SetPriority(table, hero, priority)
		for i=1, #table, 1 do
			if hero.charName:find(table[i]) ~= nil then
				TS_SetHeroPriority(priority, hero.charName)
			end
		end
	end

	function Priority:arrangePrioritys(enemies)
		local priorityOrder = {
			[2] = {1,1,2,2,2},
			[3] = {1,1,2,3,3},
			[4] = {1,2,3,4,4},
			[5] = {1,2,3,4,5},
		}
		for i, enemy in ipairs(GetEnemyHeroes()) do
			self:SetPriority(priorityTable.AD_Carry, enemy, priorityOrder[enemies][1])
			self:SetPriority(priorityTable.AP,       enemy, priorityOrder[enemies][2])
			self:SetPriority(priorityTable.Support,  enemy, priorityOrder[enemies][3])
			self:SetPriority(priorityTable.Bruiser,  enemy, priorityOrder[enemies][4])
			self:SetPriority(priorityTable.Tank,     enemy, priorityOrder[enemies][5])
		end
	end
-- }

--[[KLOKJE]]

class 'ColorARGB' -- {

    function ColorARGB:__init(red, green, blue, alpha)
        self.R = red or 255
        self.G = green or 255
        self.B = blue or 255
        self.A = alpha or 255
    end

    function ColorARGB.FromArgb(red, green, blue, alpha)
        return Color(red,green,blue, alpha)
    end

    function ColorARGB:ToARGB()
        return ARGB(self.A, self.R, self.G, self.B)
    end

    ColorARGB.Red = ColorARGB(255, 0, 0, 255)
    ColorARGB.Yellow = ColorARGB(255, 255, 0, 255)
    ColorARGB.Green = ColorARGB(0, 255, 0, 255)
    ColorARGB.Aqua = ColorARGB(0, 255, 255, 255)
    ColorARGB.Blue = ColorARGB(0, 0, 255, 255)
    ColorARGB.Fuchsia = ColorARGB(255, 0, 255, 255)
    ColorARGB.Black = ColorARGB(0, 0, 0, 255)
    ColorARGB.White = ColorARGB(255, 255, 255, 255)
-- }

--Notification class
class 'Message' -- {

    Message.instance = ""

    function Message:__init()
        self.notifys = {} 

        AddDrawCallback(function(obj) self:OnDraw() end)
    end

    function Message.Instance()
        if Message.instance == "" then Message.instance = Message() end return Message.instance 
    end

    function Message.AddMessage(text, color, target)
        return Message.Instance():PAddMessage(text, color, target)
    end

    function Message:PAddMessage(text, color, target)
        local x = 0
        local y = 200 
        local tempName = "Screen" 
        local tempcolor = color or ColorARGB.Red

        if target then  
            tempName = target.networkID
        end

        self.notifys[tempName] = { text = text, color = tempcolor, duration = GetGameTimer() + 2, object = target}
    end

    function Message:OnDraw()
        for i, notify in pairs(self.notifys) do
            if notify.duration < GetGameTimer() then notify = nil 
            else
                notify.color.A = math.floor((255/2)*(notify.duration - GetGameTimer()))

                if i == "Screen" then  
                    local x = 0
                    local y = 200
                    local gameSettings = GetGameSettings()
                    if gameSettings and gameSettings.General then 
                        if gameSettings.General.Width then x = gameSettings.General.Width/2 end 
                        if gameSettings.General.Height then y = gameSettings.General.Height/4 - 100 end
                    end  
                    --PrintChat(tostring(notify.color))
                    local p = GetTextArea(notify.text, 40).x 
                    self:DrawTextWithBorder(notify.text, 40, x - p/2, y, notify.color:ToARGB(), ARGB(notify.color.A, 0, 0, 0))
                else    
                    local pos = WorldToScreen(D3DXVECTOR3(notify.object.x, notify.object.y, notify.object.z))
                    local x = pos.x
                    local y = pos.y - 25
                    local p = GetTextArea(notify.text, 40).x 

                     self:DrawTextWithBorder(notify.text, 30, x- p/2, y, notify.color:ToARGB(), ARGB(notify.color.A, 0, 0, 0))
                end
            end
        end
    end 

    function Message:DrawTextWithBorder(textToDraw, textSize, x, y, textColor, backgroundColor)
        DrawText(textToDraw, textSize, x + 1, y, backgroundColor)
        DrawText(textToDraw, textSize, x - 1, y, backgroundColor)
        DrawText(textToDraw, textSize, x, y - 1, backgroundColor)
        DrawText(textToDraw, textSize, x, y + 1, backgroundColor)
        DrawText(textToDraw, textSize, x , y, textColor)
    end
-- }

class 'AutoPotion' -- {

	local PotionTable = {
		fortitude = {
			tick = 0,
			slot = nil,
			itemID = 2037,
			compareValue = function() return (myHero.health / myHero.maxHealth) end,
			buff = "PotionOfGiantStrengt",
		},
		flask = {
			tick = 0,
			slot = nil,
			itemID	= 2041,		-- item ID of Crystaline Flask (2041)
			compareValue = function() return math.min(myHero.mana / myHero.maxMana,myHero.health / myHero.maxHealth) end,
			buff = "ItemCrystalFlask",
		},
		biscuit = {	
			tick = 0,
			slot = nil, 
			itemID	= 2009,		-- item ID of Total Biscuit of Rejuvenation (2009)
			compareValue = function() return math.min(myHero.mana / myHero.maxMana,myHero.health / myHero.maxHealth) end,
			buff = "ItemMiniRegenPotion",
		},
		hp = {
			tick = 0,
			slot = nil, 
			itemID	= 2003,		-- item ID of health potion (2003)
			compareValue = function() return (myHero.health / myHero.maxHealth) end,
			buff = "RegenerationPotion",
		},
		mp = {
			tick = 0,
			slot = nil,
			itemID	= 2004,		-- item ID of mana potion (2004)
			compareValue = function() return (myHero.mana / myHero.maxMana) end,
			buff = "FlaskOfCrystalWater",
		}
	}

	function AutoPotion:__init()
		self.Menu = scriptConfig("iFoundation: Auto Potions", "ipotions")
		self.Menu:addParam("usePotions", "Use Auto-Potions", SCRIPT_PARAM_ONOFF, true)
		self.Menu:addParam("percentage", "Usage percentage",SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
		AddTickCallback(function(obj) self:OnTick() end)
	end 

	function AutoPotion:OnTick() 
		if not self.Menu.usePotions or myHero.dead or ((GetGame().map.index ~= 7 and GetGame().map.index ~= 12) and InFountain()) then return end 
		for name,potion in pairs(PotionTable) do 
			if potion.tick == 0 or (GetTickCount() - potion.tick > 1000) then 
				potion.slot = GetInventorySlotItem(potion.itemID) 
				if potion.slot ~= nil and self:CheckBuffs() then
					if potion.compareValue() < (self.Menu.percentage / 100) then
						Message.AddMessage("AutoPotion: Used Potion", ColorARGB.Green)
						CastSpell(potion.slot)
						potion.tick = GetTickCount()
					end 
				end 
			end 
		end 
	end 

	function AutoPotion:CheckBuffs() 
		for name, potion in pairs(PotionTable) do 
			if TargetHaveBuff(potion.buff) then
				return false
			end 
		end 
		return true 
	end 
-- }

class "Drawing" -- {

	Drawing.instance = ""

	function Drawing.Instance()
		if Drawing.instance == "" then Drawing.instance = Drawing() end return Drawing.instance
	end 

	function Drawing:__init()
		self.queue = {}
		self.Menu = scriptConfig("iFoundation: Drawing", "idrawing")
		self.Menu:addParam("drawPlayers", "Draw Players", SCRIPT_PARAM_ONOFF, true)
		self.Menu:addParam("drawLines", "Draw Lines to Players", SCRIPT_PARAM_ONOFF, true)
		self.Menu:addParam("playerDistance", "Max distance to draw players",SCRIPT_PARAM_SLICE, 1600, 0, 3000, 0)
		AddDrawCallback(function(obj) self:OnDraw() end)
	end 

	function Drawing.AddSkill(spell, range)
		return Drawing.Instance():_AddSkill(spell, range)
	end  

	function Drawing:_AddSkill(sspell, rrange)
		local tempSpell = SpellToString(sspell)
		if self.queue["Skill" .. tempSpell] ~= nil then return end 
		self.Menu:addParam("draw" .. tempSpell, "Draw " .. tempSpell .. " range", SCRIPT_PARAM_ONOFF, true)
		self.queue["Skill" .. tempSpell] = {spell = sspell, range = rrange, spellString = tempSpell, aTimer = 0}
	end 

	function Drawing:OnDraw()
		for name,d in pairs(self.queue) do 
			if string.find(name, "Skill") and self.Menu["draw" .. d.spellString] then
				local tempColor = ColorARGB.Red 
				if myHero:CanUseSpell(d.spell) == READY then 
					tempColor = ColorARGB.Green 
				end
				DrawCircle(myHero.x, myHero.y, myHero.z, d.range, tempColor:ToARGB())
			end 
		end 

		if self.Menu.drawPlayers then 
			for i = 1, heroManager.iCount, 1 do 
				local target = heroManager:getHero(i)
				if ValidTarget(target) and target.dead ~= true and target ~= myHero and target.team == TEAM_ENEMY and GetDistance(target) <= self.Menu.playerDistance then 
					self:DrawTarget(target)
				end 
			end 
		end 
	end 

	function Drawing:DrawTarget(Target) 
		if myHero.dead or not myHero.valid then return false end 
		local totalDamage = DamageCalculation.CalculateBurstDamage(Target)
		local realDamage = DamageCalculation.CalculateRealDamage(Target) 
		local tempColor = ColorARGB.Red 
		local tempText = "Not Ready"
		if Target.health <= realDamage then
			tempColor = ColorARGB.Green
			tempText = "KILL HIM"
		elseif Target.health > realDamage and Target.health <= totalDamage then 
			tempColor = ColorARGB.Yellow 
			tempText = "Wait for cooldowns"
		end  
		for w = 0, 15 do 
			DrawCircle(Target.x, Target.y, Target.z, 40 + w * 1.5, tempColor:ToARGB())
		end 
		PrintFloatText(Target, 0, tempText .. " DMG: " .. round(realDamage))
		if GetDistance(Target) <= self.Menu.playerDistance and self.Menu.drawLines then 
			DrawArrows(myHero, Target, 30, 0x099B2299, 50)
		end 
	end 
-- }

class "DamageCalculation" -- {
	local items = { -- Item Aliases for spellDmg lib, including their corresponding itemID's.
		{ name = "DFG", id = 3128},
		{ name = "HXG", id = 3146},
		{ name = "BWC", id = 3144},
		{ name = "HYDRA", id = 3074},
		{ name = "SHEEN", id = 3057},
		{ name = "KITAES", id = 3186},
		{ name = "TIAMAT", id = 3077},
		{ name = "NTOOTH", id = 3115},
		{ name = "SUNFIRE", id = 3068},
		{ name = "WITSEND", id = 3091},
		{ name = "TRINITY", id = 3078},
		{ name = "STATIKK", id = 3087},
		{ name = "ICEBORN", id = 3025},
		{ name = "MURAMANA", id = 3042},
		{ name = "LICHBANE", id = 3100},
		{ name = "LIANDRYS", id = 3151},
		{ name = "BLACKFIRE", id = 3188},
		{ name = "HURRICANE", id = 3085},
		{ name = "RUINEDKING", id= 3153},
		{ name = "LIGHTBRINGER", id = 3185},
		{ name = "SPIRITLIZARD", id = 3209},
		--["ENTROPY"] = 3184,
	}

	DamageCalculation.instance = ""

	function DamageCalculation.Instance()
		if DamageCalculation.instance == "" then DamageCalculation.instance = DamageCalculation() end return DamageCalculation.instance
	end  

	function DamageCalculation:__init()
		self.addItems = true
		self.spells = {}
		self.spellTable = {"Q", "W", "E", "R"}
		for _, spellName in pairs(self.spellTable) do
			self.spells[spellName] = {name = spellName, spell = SpellString[spellName]}
		end 
	end

	function DamageCalculation.GetDamage(spell, Target)
		return DamageCalculation.Instance():_GetDamage(spell, Target) 
	end 

	function DamageCalculation:_GetDamage(spell, Target, player)
		self.player = player or myHero 
		return getDmg(spell, Target, self.player)
	end 

	function DamageCalculation.CalculateItemDamage(Target)
		return DamageCalculation.Instance():_CalculateItemDamage(Target) 
	end 

	function DamageCalculation:_CalculateItemDamage(Target, player)
		self.player = player or myHero 
		self.itemTotalDamage = 0
		for _, item in pairs(items) do 
			-- On hit items
			self.itemTotalDamage = self.itemTotalDamage + (GetInventoryHaveItem(item.id, self.player) and getDmg(item.name, Target, self.player) or 0)
		end
	end

	function DamageCalculation.CalculateRealDamage(Target) 
		return DamageCalculation.CalculateRealDamage(Target, myHero)
	end 

	function DamageCalculation.CalculateRealDamage(Target, player) 
		return DamageCalculation.Instance():_CalculateRealDamage(Target, player) 
	end 

	function DamageCalculation:_CalculateRealDamage(Target, player)
	 	self.player = player or myHero 
		local total = 0
		for _, spell in pairs(self.spells) do 
			if self.player:CanUseSpell(spell.spell) == READY and self.player:GetSpellData(spell.spell).mana <= self.player.mana then
				total = total + self:_GetDamage(spell.name, Target, self.player)
			end 
		end
		if self.addItems then
			self:_CalculateItemDamage(Target, self.player) 
			total = total + self.itemTotalDamage 
		end
		total = total + self:_GetDamage("AD", Target, self.player)
		return total 
	end

	function DamageCalculation.CalculateBurstDamage(Target)
		return DamageCalculation.Instance():_CalculateBurstDamage(Target) 
	end 

	function DamageCalculation:_CalculateBurstDamage(Target)
		local localSpells = self.spells
		local total = 0 
		for _, spell in pairs(localSpells) do
			if myHero:CanUseSpell(spell.spell) == READY then
				total = total + self:_GetDamage(spell.name, Target)
			end
		end 
		if self.addItems then
			self:_CalculateItemDamage(Target) 
			total = total + self.itemTotalDamage 
		end
		total = total + self:_GetDamage("AD", Target)
		return total 
	end 

-- }

class "Monitor" -- {
	
	Monitor.instance = ""

	function Monitor.Instance() 
		if Monitor.instance == "" then Monitor.instance = Monitor() end return Monitor.instance 
	end 

	function Monitor:__init() 
		self.Menu = scriptConfig("iFoundation: Monitoring", "imonitor")
		self.Menu:addParam("drawAlly", "Draw ally notifications", SCRIPT_PARAM_ONOFF, false)
		self.Menu:addParam("allyPercentage", "Low ally health",SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		self.FriendlyTable = {}

		self.monitorTable = {}
		AddTickCallback(function(obj) self:OnTick() end)

		self.teleporting = false
		AddCreateObjCallback(function(object) self:OnCreateObj(object) end)
		AddDeleteObjCallback(function(object) self:OnDeleteObj(object) end)
	end 

	function Monitor.IsTeleporting() 
		return Monitor.Instance():_IsTeleporting() 
	end 

	function Monitor:_IsTeleporting() 
		return self.teleporting 
	end 

	function Monitor:OnCreateObj(object)
		if object and (object.name == "TeleportHomeImproved.troy" or object.name == "TeleportHome.troy") then
			self.teleporting = true
		end 
	end 

	function Monitor:OnDeleteObj(object) 
		if object and (object.name == "TeleportHomeImproved.troy" or object.name == "TeleportHome.troy") then
			self.teleporting = false
		end 
	end 

	function Monitor:OnTick() 
		if self.Menu.drawAlly and self:_GetLowAlly() ~= nil then 
			Message.AddMessage("Monitor: Player dropped below threshold health", ColorARGB.Red) 
		end 
	end 

	function Monitor.GetLowAlly()
		return Monitor.Instance():_GetLowAlly()
	end 

	function Monitor:_GetLowAlly()	
		for i, target in pairs(_Heroes.GetObjects(ALLY, math.huge)) do 
			if target.health / target.maxHealth <= (self.Menu.allyPercentage / 100) then 
				return target 
			end 
		end 
	end 

	function Monitor.GetAllyWithMostEnemies(range) 
		return Monitor.Instance():_GetAllyWithMostEnemies(range) 
	end 

	function Monitor:_GetAllyWithMostEnemies(range)
		local best = nil
		local enemies = math.huge
		for i, target in pairs(_Heroes.GetObjects(ALLY, range)) do
			if target and not target.dead then
				if best == nil then
					best = target 
					enemies = self:_CountEnemies(target, range)
				elseif self:_CountEnemies(target, range) > enemies then
					best = target
					enemies = self:_CountEnemies(target, range)
				end 
			end 
		end 
		return best 
	end 

	function Monitor.CountEnemies(point, range)
		return Monitor.Instance():_CountEnemies(point, range) 
	end 

	function Monitor:_CountEnemies(point, range) 
		local count = 0
		for i, target in pairs(_Heroes.GetObjects(ENEMY, range)) do 
			if target and not target.dead and ValidTarget(target, range) then
				count = count + 1
			end 
		end 
		return count 
	end 

	function Monitor:AddManaMonitor() 
		local tempNumber = #self.monitorTable + 1
		self.Menu:addParam("manaMonitor" .. tempNumber, "Max percentage of mana usage",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
		self.monitorTable["mana" .. tempNumber] = {tick = GetTickCount(), last = myHero.mana}
	end 

-- }

class '_Heroes' -- {
    
    _Heroes.tables = {
        [ALLY] = {},
        [ENEMY] = {},
        [NEUTRAL] = {}
    }

    _Heroes.instance = ""

    function _Heroes:__init()
        self.modeCount = 3

        for i = 1, heroManager.iCount do
            local hero = heroManager:GetHero(i)
            self:AddObject(hero)
        end
    end

    function _Heroes.Instance()
        if _Heroes.instance == "" then _Heroes.instance = _Heroes() end return _Heroes.instance 
    end

    function _Heroes.GetObjects(mode, range, pFrom)
        return _Heroes.Instance():GetObjectsFromTable(mode, range, pFrom)
    end

    function _Heroes.GetAllObjects(mode)
        return _Heroes.Instance():GetAllObjectsFromTable(mode)
    end

    function _Heroes:AddObject(obj)
        DelayAction(function(obj)
                if obj.team == myHero.team then table.insert(_Heroes.tables[ALLY], obj) return end
                if obj.team == TEAM_ENEMY then table.insert(_Heroes.tables[ENEMY], obj) return end
                if obj.team == TEAM_NEUTRAL then table.insert(_Heroes.tables[NEUTRAL], obj) return end
            end, 0, {obj})
    end 

    function _Heroes.GetObjectByNetworkId(networkID)
         return _Heroes.Instance():PrivateGetObjectByNetworkId(networkID)
    end

    function _Heroes:PrivateGetObjectByNetworkId(networkID)
        for i, tableType in pairs(self.tables) do
            for k,v in pairs(tableType) do 
                if v.networkID == networkID then return v end 
            end 
        end
        return nil
    end 

    function _Heroes:GetAllObjectsFromTable(mode)
        if mode > self.modeCount then mode = self.modeCount end 

        tempTable = {}

        for i, tableType in pairs(self.tables) do
            if bit32.band(mode, i) == i then 
                for k,v in pairs(tableType) do 
                    if v ~= nil then 
                        table.insert(tempTable, v)
                    end
                end 
            end 
        end 
        return tempTable
    end 

    function _Heroes:GetObjectsFromTable(mode, range, pFrom)
        if mode > self.modeCount then mode = self.modeCount end 
        if range == nil or range < 0 then range = math.huge end
        if pFrom == nil then pFrom = myHero end
        tempTable = {}

        for i, tableType in pairs(self.tables) do
            if bit32.band(mode, i) == i then 
                for k,v in pairs(tableType) do 
                    if v ~= nil and v.valid and not v.dead and (v.team == myHero.team or v.bInvulnerable == 0) and v ~= myHero then 
                        if v.visible and v.bTargetable and GetDistance(v, pFrom) <= range then table.insert(tempTable, v) end
                    end
                end 
            end 
        end 
        return tempTable
    end
-- }

class '_Buff' -- {
    function _Buff:__init(buffId, stack, starttime, time)
        self.buffId = buffId 
        self.count = stack or 0
        self.starttime = starttime - (GetLatency()/(1000*2))
        self.endtime = self.starttime + time  
        self.time = time
    end

    function _Buff:SetStacks(stack)
        self.count = stack
    end 

    function _Buff:GetStacks()
        return self.count
    end 

    function _Buff:SetTime(time)
        self.starttime = GetGameTimer()
        self.endtime = self.starttime + time
        self.time = time
    end 
-- }

class '_Buffs' -- {
    buffs = {}
    _Buffs.instance = ""

    function _Buffs:__init()
        local heroes = _Heroes.GetAllObjects(ALL) 

        for j, hero in pairs(heroes) do
            for i=0, hero.buffCount, 1 do
                local buff = hero:getBuff(i)
                if buff.valid then 
                    if type(buffs[hero.networkID]) ~= "table" then buffs[hero.networkID] = {} end 
                    buffs[hero.networkID][i] = _Buff(nil , 1, buff.startT, buff.endT-buff.startT)
                end
            end 
        end 
        AddRecvPacketCallback(function(obj) self:OnRecvPacket(obj) end)
    end

    function _Buffs.Instance()
        if _Buffs.instance == "" then _Buffs.instance = _Buffs() end return _Buffs.instance 
    end

    function _Buffs.HaveBuff(id, target)
        return _Buffs.Instance():PHaveBuff(id, target)
    end

    function _Buffs:GetBuffs(target)
        if type(buffs[target.networkID]) ~= "table" then buffs[target.networkID] = {} end 
        return buffs[target.networkID]
    end 

    function _Buffs:PHaveBuff(id, target)
        if type(buffs[target.networkID]) ~= "table" then buffs[target.networkID] = {} end 
        for j, buff in pairs(buffs[target.networkID]) do
            if buff.buffId == id then 
                return buff 
            end 
        end
        return nil
    end

    function _Buffs.TargetHaveBuff(name, target) 
    	return _Buffs.Instance():_TargetHaveBuff(name, target) 
    end 

    function _Buffs:_TargetHaveBuff(name, target)
        if type(buffs[target.networkID]) ~= "table" then buffs[target.networkID] = {} return false end 
        for i = 1, target.buffCount do
            local tBuff = target:getBuff(i)
            if tBuff.valid and tBuff.name == name then 
                if buffs[target.networkID][i] ~= nil then return buffs[target.networkID][i] else return nil end
            end  
        end
        return nil
    end 

    function _Buffs:OnRecvPacket(p)
        if p.header == 183 then 
            p.pos = 1 
            local networkID = p:DecodeF()
            local buffslot = p:Decode1()
            
            p.pos = p.pos+1
            local stackcount = p:Decode1()
            p.pos = p.pos+1 
            local buffID = p:Decode4()
            p.pos = p.pos+8
            local time = p:DecodeF()
            local FromBuff = p:DecodeF()
            if FromBuff ~= myHero.networkID then return end

            if type(buffs[networkID]) ~= "table" then buffs[networkID] = {} end 
            buffs[networkID][buffslot+1] = _Buff(buffID, stackcount, GetGameTimer() ,time)

            if (buffID == 226643749 or buffID == 39961747) and FromBuff == myHero.networkID then 
                qTarget = objManager:GetObjectByNetworkId(networkID)
            elseif buffID == 226627365 and FromBuff == myHero.networkID then 
                local enemy =  objManager:GetObjectByNetworkId(networkID)
                if enemy ~= nil and enemy.team ~= myHero.team  and enemy.type == "obj_AI_Hero" then 
                    eStack[networkID] = enemy
                end
            end 
        elseif p.header == 28 then 
            p.pos = 1
            local networkID = p:DecodeF()
            local buffslot = p:Decode1()
            if type(buffs[networkID]) ~= "table" then buffs[networkID] = {} end 
            local buff = buffs[networkID][buffslot+1]
            local stack = p:Decode1()
            local time = p:DecodeF()
            if buff == nil then 
                buffs[networkID][buffslot+1] = _Buff(nil, stack, GetGameTimer() ,time)
            else 
                buff:SetStacks(stack)
                buff:SetTime(time)
            end
        elseif p.header == 123 then 
            p.pos = 1
            local networkID = p:DecodeF()
            local buffslot = p:Decode1()
            local buffID = p:Decode4()
            if type(buffs[networkID]) ~= "table" then return false end 
            buffs[networkID][buffslot+1] = nil

            if (buffID == 226643749 or buffID == 39961747) then 
                local enemy =  objManager:GetObjectByNetworkId(networkID)
                if enemy ~= nil and enemy.team ~= myHero.team then
                    qTarget = nil
                end
            elseif buffID == 226627365 then 
                local enemy =  objManager:GetObjectByNetworkId(networkID)
                if enemy ~= nil and enemy.team ~= myHero.team and enemy.type == "obj_AI_Hero" then 
                    eStack[networkID] = nil 
                end
            end 
        end
    end
-- }

class 'Combat' -- {

	function Combat.GetTrueRange()

	    return myHero.range + GetDistance(myHero.minBBox)

	end
 
 	function Combat.KillSteal(Spell, range) 
		if not Spell:Ready() then return end 
		for i, enemy in pairs(_Heroes.GetObjects(ENEMY, range)) do 
			if enemy and ValidTarget(enemy) and not enemy.dead then 
				if enemy.health <= getDmg(SpellToString(Spell.spell), enemy, myHero) then
					Spell:Cast(enemy) 
				end 
			end 
		end 
	end 

	function Combat.LastHit(Spell, range) 
		if not Spell:Ready() then return end 
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion, range) and getDmg(SpellToString(Spell.spell), minion, myHero) >= minion.health then 
				Spell:Cast(minion)
				myHero:Attack(minion)
			end 
		end 
	end 

	function Combat.CastLowest(Spell, percentage) 
		if not Spell:Ready() then return end 
		for _, player in pairs(_Heroes.GetObjects(ALLY, Spell.range)) do 
			if player and not player.dead and GetDistance(player) < Spell.range and player.health <= player.maxHealth * (percentage / 100) then
				Spell:Cast(player)
			end 
		end 
	end 

-- }

class 'AutoShield' -- {

	AvoidList = {
	-- AOE
		["UFSlash"] = 300,
		["GragasExplosiveCask"] = 400,
		["CurseoftheSadMummy"] = 550,
		["LeonaSolarFlare"] = 400,
		["InfernalGuardian"] = 250,
		["DianaVortex"] = 300,
		["RivenMartyr"] = 200,
		["OrianaDetonateCommand"] = 400,
		["DariusAxeGrabCone"] = 200,
		["LeonaZenithBladeMissile"] = 200,
		["ReapTheWhirlwind"] = 600,
		["ShenShadowDash"] = 350,
		["GalioIdolOfDurand"] = 600,
		["XenZhaoParry"] = 200,
		["EvelynnR"] = 400,
		["Pulverize"] = 250,
		["VladimirHemoplague"] = 200,
	-- Target
		["Headbutt"] = 0,
		["Dazzle"] = 0,
		["CrypticGaze"] = 0,
		["Pantheon_LeapBash"] = 0,
		["RenektonPreExecute"] = 0,
		["IreliaEquilibriumStrike"] = 0,
		["MaokaiUnstableGrowth"] = 0,
		["BusterShot"] = 0,
		["BlindMonkRKick"] = 0,
		["VayneCondemn"] = 0,
		["SkarnerImpale"] = 0,
		["ViR"] = 0,
		["Terrify"] = 0,
		["IceBlast"] = 0,
		["NullLance"] = 0,
		["PuncturingTaunt"] = 0,
		["BlindingDart"] = 0,
		["VeigarPrimordialBurst"] = 0,
		["DeathfireGrasp"] = 0,
		["GarenJustice"] = 0,
		["DariusExecute"] = 0,
		["ZedUlt"] = 0,
		["PickaCard_yellow_mis.troy"] = 0,
		["RunePrison"] = 0,
		["PoppyHeroicCharge"] = 0,
		["AlZaharNetherGrasp"] = 0,
		["InfiniteDuress"] = 0,
		["UrgotSwap2"] = 0,
		["TalonCutthroat"] = 0,
		["LeonaShieldOfDaybreakAttack"] = 0,
	}

	local PlayerSkills = {
		"Q", "W", "E", "R", "P", "QM", "WM", "EM"
	}

	local OnHitItems = {
		["KITAES"] = 3186,
		["MALADY"] = 3114,
		["WITSEND"] = 3091,
		["SHEEN"] = 3057,
		["TRINITY"] = 3078,
		["LICHBANE"] = 3100,
		["ICEBORN"] = 3025,
		["STATIKK"] = 3087,
		["RUINEDKING"] = 3153,
		["SPIRITLIZARD"] = 3209
	}

	local SkillOnHitItems = {
		["LIANDRYS"] = 3151,
		["BLACKFIRE"] = 3188,
		["SPIRITLIZARD"] = 3209
	}
	
	AutoShield.instance = ""

	AutoShield.selfOverride = false

	function AutoShield.Instance(range, ShieldSpell) 
		if AutoShield.instance == "" then AutoShield.instance = AutoShield(range, ShieldSpell) end return AutoShield.instance
	end 

	function AutoShield:__init(range, ShieldSpell)
		self.range = range 
		self.ShieldSpell = ShieldSpell
		self.Menu = scriptConfig("iFoundation: AutoShield", "iautoshield")
		self.Menu:addParam("selfShield", "Use auto-shield for myself", SCRIPT_PARAM_ONOFF, false)
		self.Menu:addParam("selfPercentage", "Health percentage for self",SCRIPT_PARAM_SLICE, 5, 0, 100, 0)
		if self.ShieldSpell.spellType ~= SPELL_SELF and not AutoCarry.selfOverride then 
			self.Menu:addParam("allyShield", "Use auto-shield for allies", SCRIPT_PARAM_ONOFF, false)
			self.Menu:addParam("allyPercentage", "Health percentage for allies",SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		end 
		AddProcessSpellCallback(function(obj, spell) self:OnProcessSpell(obj, spell) end)	
	end

	function AutoShield:OnProcessSpell(object, spell) 
		if (object == nil or spell == nil) or not self.ShieldSpell:Ready() then return end 
		if object.team ~= myHero.team then
			self.spellType, self.castType = getSpellType(object, spell.name)
			if self.Menu.selfShield then
				if self:SpellWillHit(object, spell, myHero) then
					local damagePercent = self:GetSpellDamage(object, spell, myHero) * 100 / myHero.health
					if self.Menu.selfPercentage == 0 or damagePercent > self.Menu.selfPercentage then
						Message.AddMessage("AutoShield: Shielded you from " .. round(damagePercent) .. "% of damage", ColorARGB.Green)
						self.ShieldSpell:Cast(myHero)
					end 
				end 
			end 
			if (self.ShieldSpell.spellType ~= SPELL_SELF or AutoCarry.selfOverride) and self.Menu.allyShield then
				for i, player in pairs(_Heroes.GetObjects(ALLY, self.range)) do 
					if not player.dead and self:SpellWillHit(object, spell, player) then 
						local damagePercent = self:GetSpellDamage(object, spell, player) * 100 / player.health
						if damagePercent > self.Menu.allyPercentage then 
							self.ShieldSpell:Cast(player)
							Message.AddMessage("AutoShield: Shielded " .. player.charName .. " from " .. round(damagePercent) .. "% of damage", ColorARGB.Green)
						end 
					end 
				end 
			end 
		end 
		
	end 

	function AutoShield:GetSpellDamage(object, spell, target) 
		if object == nil or spell == nil or target == nil then return 0 end 
		local attackDamage = object:CalcDamage(target, object.totalDamage)
		if object.type ~= "obj_AI_Hero" then
			if spell.name:find("BasicAttack") then
				return attackDamage 
			elseif spell.name:find("CritAttack") then 
				return attackDamage * 2 
			end 
		else
			local itemDamage = 0
			for name, id in pairs(OnHitItems) do 
				if GetInventoryHaveItem(id, object) then
					itemDamage = itemDamage + getDmg(name, target, object)
				end 
			end 
			if self.spellType == "BAttack" then
				return (attackDamage + itemDamage) * 1.07
			elseif self.spellType == "CAttack" then 
				local ie = 0
				if GetInventoryHaveItem(3031,object) then ie = .5 end 
				return (attackDamage * (2.1 + ie) + itemDamage) * 1.07
			elseif PlayerSkills[self.spellType] ~= nil then
				local skillDamage, skillType = 0, 0
				local skillItemDamage = 0
				for name, id in pairs(SkillOnHitItems) do 
					if GetInventoryHaveItem(id, object) then 
						skillItemDamage = skillItemDamage + getDmg(name, target, object)
					end 
				end 

				skillDamage, skillType = getDmg(self.spellType, target, object, self.castType, spell.level)

				if skillType ~= 2 then
					return (skillDamage + skillItemDamage) * 1.07
				end 
				return (skillDamage + attackDamage + itemDamage + skillItemDamage) * 1.07
			end 						
		end
		return attackDamage 
	end 

	function AutoShield:SpellWillHit(object, spell, target) 
		--[[if self.spellType == "BAttack" or self.spellType == "CAttack" then
			return true 
		end--]]
		if object == nil then return false end 
		local hitchampion = false
		if self.spellType == "Q" or self.spellType == "W" or self.spellType == "E" or self.spellType =="R" then
			local shottype = skillData[object.charName][self.spellType]["type"]
			local radius = skillData[object.charName][self.spellType]["radius"]
			local maxdistance = skillData[object.charName][self.spellType]["maxdistance"]
			local P2 = spell.endPos 
			if shottype == 0 then hitchampion = checkhitaoe(object, P2, 80, target, 0)
			elseif shottype == 1 then hitchampion = checkhitlinepass(object, P2, radius, maxdistance, target, 50)
			elseif shottype == 2 then hitchampion = checkhitlinepoint(object, P2, radius, maxdistance, target, 50)
			elseif shottype == 3 then hitchampion = checkhitaoe(object, P2, radius, maxdistance, target, 50)
			elseif shottype == 4 then hitchampion = checkhitcone(object, P2, radius, maxdistance, target, 50)
			elseif shottype == 5 then hitchampion = checkhitwall(object, P2, radius, maxdistance, target, 50)
			elseif shottype == 6 then hitchampion = checkhitlinepass(object, P2, radius, maxdistance, target, 50) or checkhitlinepass(object, Vector(object)*2-P2, radius, maxdistance, target, 50)
			elseif shottype == 7 then hitchampion = checkhitcone(P2, object, radius, maxdistance, target, 50)
			end
		end  
		return hitchampion
	end 

-- }

class 'AutoBuff' -- {
	
	AutoBuff.instance = ""

	function AutoBuff.Instance(BuffSpell) 
		if AutoBuff.instance == "" then AutoBuff.instance = AutoBuff(BuffSpell) end return AutoBuff.instance
	end 

	function AutoBuff:__init(BuffSpell) 
		self.BuffSpell = BuffSpell
		AddProcessSpellCallback(function(obj, spell) self:OnProcessSpell(obj, spell) end)
	end

	function AutoBuff:OnProcessSpell(object, spellProc) 
		if object == nil or spellProc == nil or not self.BuffSpell:Ready() then return end 
		if object and spellProc and object.team == myHero.team and spellProc.name:find("Attack") and not myHero.dead and not (object.name:find("Minion_") or object.name:find("Odin")) and GetDistance(object) <= self.BuffSpell.range then

			if not self.BuffSpell.spellType == SPELL_SELF then
				for i, player in pairs(_Heroes.GetObjects(ENEMY, math.huge)) do 
					if not player.dead and GetDistance(player, spellProc.endPos) < 80 then
						Message.AddMessage("AutoBuff: Buffed player", ColorARGB.Green)
						self.BuffSpell:Cast(object) 
					end  
				end 
			else
				if not myHero.dead and GetDistance(myHero, spellProc.endPos) < 80 then
					self.BuffSpell:Cast(myHero)
				end 
			end 
		end 
	end 


-- }

class 'ComboLibrary' -- {
	
	function ComboLibrary:__init()
		self.casters = {}
		self.Menu = scriptConfig("iFoundation: Combo", "icombo")
	end 

	function ComboLibrary:AddCasters(table) 
		for _, v in pairs(table) do 
			self:AddCaster(v)
		end 
	end 

	function ComboLibrary:AddCaster(caster)
		local tempSpell = SpellToString(caster.spell)
		self.Menu:addParam("use" .. tempSpell, "Use " .. tempSpell .. " in combo", SCRIPT_PARAM_ONOFF, true)
		table.insert(self.casters, {spellVar = caster.spell, casterInstance = caster, damage = 0, customCastCondition = nil, mana = 0, customCast = nil})
	end 

	function ComboLibrary:AddCustomCast(spellVar, funct)
		for k, v in pairs(self.casters) do 
			if v.spellVar == spellVar then
				self.casters[k].customCastCondition = funct
				break 
			end 
		end 
	end 

	function ComboLibrary:AddCast(spellVar, funct) 
		for k, v in pairs(self.casters) do 
			if v.spellVar == spellVar then
				self.casters[k].customCast = funct
				break 
			end 
		end 
	end 

	function ComboLibrary:CheckMana(currentCombo) 
		local totalCost = 0
		for v, caster in pairs(currentCombo) do 
			totalCost = totalCost + myHero:GetSpellData(caster.spellVar).mana 
		end 
		return totalCost <= myHero.mana 
	end 

	function ComboLibrary:UpdateDamages(target) 
		for k, caster in pairs(self.casters) do 
			self.casters[k].damage = getDmg(SpellToString(caster.spellVar), target, myHero)
			self.casters[k].mana = myHero:GetSpellData(caster.spellVar).mana 
		end 
	end

	function ComboLibrary:Sort() 
		table.sort(self.casters, function(a,b) 
			if a.damage == b.damage then 
				return a.mana < b.mana 
			end 
			return a.damage > b.damage
		 end)
	end 

	function ComboLibrary:GetCombo(target, asCaster) 
		local damage = 0
		local currentCombo = {}
		self:UpdateDamages(target)
		self:Sort()
		damage = damage + getDmg("AD", target, myHero)
		for k, v in pairs(self.casters) do 
			if damage >= target.health then
				break 
			end 
			if v.casterInstance:Ready() then
				damage = damage + v.damage 
				table.insert(currentCombo, v)
			end 
		end 
		if self:CheckMana(currentCombo) and asCaster then
			return self:ToCasters(currentCombo)
		end
		return currentCombo
	end 

	function ComboLibrary:ToCasters(combo) 
		local localCasters = {}
		for k, v in pairs(combo) do 
			table.insert(localCasters, v.casterInstance)
		end 
		return localCasters
	end 

	function ComboLibrary:CastCombo(target) 
		if target == nil or target.dead then return false end 
		local combo = self:GetCombo(target, false) 
		for k, caster in pairs(combo) do 
			if not target or target.dead then return true end 
			if self.Menu["use" .. SpellToString(caster.spellVar)] then
				if caster.casterInstance:Ready() and (caster.customCastCondition == nil or caster.customCastCondition(target)) then
					if caster.customCast ~= nil then
						caster.customCast(target) 
					else 
						caster.casterInstance:Cast(target)
					end 
				end 
			end 
		end 
	end 

	function ComboLibrary.KillableCast(Target, spellName) 
		return ((DamageCalculation.CalculateRealDamage(Target) > Target.health) or (getDmg(spellName, Target, myHero) > Target.health))
	end 

-- }

class 'BuffManager' -- {
	
	BuffManager.instance = ""

	function BuffManager.Instance() 
		if BuffManager.instance == "" then BuffManager.instance = BuffManager() end return BuffManager.instance 
	end 

	function BuffManager:__init()
		self.enemies = {}
		AdvancedCallback:bind('OnGainBuff', function(unit, buff) self:OnGainBuff(unit, buff) end)
		AdvancedCallback:bind('OnLoseBuff', function(unit, buff) self:OnLoseBuff(unit, buff) end)
		AdvancedCallback:bind('OnChangeStack', function(unit, buff) self:OnChangeStack(unit, buff) end)
		for i=0, heroManager.iCount, 1 do
	        local player = heroManager:GetHero(i)
	        if player and player.team ~= myHero.team then
	        	self.enemies[player.name] = {}
	        end 
		end
	end 

	function BuffManager.TargetHaveBuff(target, buffName, stacks)
		return BuffManager.Instance():_TargetHaveBuff(target, buffName, stacks) 
	end 

	function BuffManager:_TargetHaveBuff(target, buffName, stacks)
		self.stacks = stacks or 0
		if self.enemies[target.name] ~= nil then
			for _, buff in pairs(self.enemies[target.name]) do 
				if buff.name == buffName and buff.stack >= self.stacks then
					return true
				end  
			end 
		end 
	end 

	function BuffManager:OnGainBuff(unit, buff) 
		if unit == nil or buff == nil then return end 
		if unit.team ~= myHero.team then 
			if self.enemies[unit.name] ~= nil then
				table.insert(self.enemies[unit.name], buff)
			end 
		end 
	end 

	function BuffManager:OnLoseBuff(unit, buff) 
		if unit == nil or buff == nil then return end 
		if unit.team ~= myHero.team then 
			if self.enemies[unit.name] ~= nil then 
				for i=0, #self.enemies[unit.name], 1 do 
					if self.enemies[unit.name][i] == buff then
						table.remove(self.enemies[unit.name], i)
						break 
					end 
				end 
			end 
		end 
	end 

	function BuffManager:OnChangeStack(unit, buff) 
		if unit == nil or buff == nil then return end 
		if unit.team ~= myHero.team then 
			if self.enemies[unit.name] ~= nil then 
				for i=0, #self.enemies[unit.name], 1 do 
					if self.enemies[unit.name][i] == buff then
						table.remove(self.enemies[unit.name], i)
						break 
					end 
				end 
				table.insert(self.enemies[unit.name], buff)
			end 
		end 
	end 

-- }