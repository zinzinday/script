--[[ 	iSAC Library by Apple

		iSAC is based upon Sida's Auto Carry and offers a base for champion scripts.
		Credits to Sida, SAC has been a great source of inspiration and some logic has been taken from SAC.

		Note: Class names are prefixed with 'i' to prevent multiple similar classes from interfering with eachother. (And because I love being me.)

		Special thanks to:
		HeX - For giving me a lot of ideas and being an awesome mate to talk to while working.
		Mom - For giving birth to me.
		My psychiatrist - For prescribing me pills.
		]]--

if VIP_USER then require "Collision" end
local _customValues = FileExist(LIB_PATH.."iSAC - Custom Values.lua") and assert(loadfile(LIB_PATH.."iSAC - Custom Values.lua"))()

--[[ 	iOrbWalker Class 
	
	Methods:
		local Orbwalker = iOrbWalker(AARange)

	Functions:
		OrbWalker:addAA([AAName])				-> Add autoattack spellname to iOrbWalker, uses most common logic if omitted or equals "attack"
		OrbWalker:addReset(resetName) 			-> Add spellname with AA-timer reset.
		OrbWalker:removeAA(AAName)				-> Removes an autoattack from the list or adds the autoattack to the list of ignored attacks.
		OrbWalker:GetStage()					-> Returns current stage of AA: STAGE_WINDUP, STAGE_ORBWALK, STAGE_NONE
		OrbWalker:GetDPS(unit, [target])		-> Returns basic DPS a unit will deal to the target, will calculate base DPS if target is omitted.

		OrbWalker:OrbWalk(movePos, target)		-> Orbwalks, attacks target if possible, otherwise moves to movePos.
		OrbWalker:Attack(target)				-> Attacks target if possible.
		OrbWalker:Move(movePos)				-> Moves to movePos if possible.
		OrbWalker:ManualOrbwalk(packet)		-> (VIP Only) Put in OnSendPacket, enables manual orbwalking with assistance.
		OrbWalker:ManualBlock(packet)			-> (VIP Only) Put in OnSendPacket, blocks movement that will cancel AA's prematurely.

	Members:
		OrbWalker.AARange		-> Autoattack range
		OrbWalker.ShotCast		-> Returns the tick when the windup of the last AA ends.
		OrbWalker.NextShot		-> Returns the tick when the next AA is ready.

	Example:
		local OrbWalker = iOrbWalker(myHero.range)
		local ts = TargetSelector(TARGET_LOW_HP, myHero.range)
		OrbWalker:addAA()

		function OnTick()
			ts:update()
			OrbWalker:OrbWalk(mousePos, ts.target)
		end

		function OnProcessSpell(unit, spell)
			OrbWalker:OnProcessSpell(unit, spell)
		end

	]]--

class 'iOrbWalker'

STAGE_WINDUP = 1
STAGE_ORBWALK = 2
STAGE_NONE = 3

local iOWInstances = {}

function iOrbWalker:__init(AARange, useDefaultValues, addDelay)
	self.AARange = AARange or (myHero.range + GetDistance(myHero.minBBox))
	self.addDelay = addDelay or 20
	self.ShotCast = 0
	self.NextShot = 0
	self.windUpTime = 0
	self.animationTime = 0
	if useDefaultValues then
		self:addAA()
		self:addReset()
	end
	iOWInstances[#iOWInstances+1] = self
	if not iOW_OnProcessSpell then
		function iOW_OnProcessSpell(unit, spell)
			for _, iOWInstance in ipairs(iOWInstances) do
				iOWInstance:OnProcessSpell(unit, spell)
			end
		end
		function iOW_OnAnimation(unit, animation)
			for _, iOWInstance in ipairs(iOWInstances) do
				iOWInstance:OnAnimation(unit, animation)
			end
		end
		AddProcessSpellCallback(iOW_OnProcessSpell)
		AddAnimationCallback(iOW_OnAnimation)
	end
end

function iOrbWalker:__type()
	return "iOrbWalker"
end

--[[ Main Functions ]]--

function iOrbWalker:Orbwalk(movePos, target)
	assert(movePos and movePos.x and movePos.z, "Error: iOrbWalker:Orbwalk(movePos, target), invalid movePos.")
	if self:GetStage() == STAGE_NONE and ValidTarget(target, self.AARange) then
		myHero:Attack(target)
	elseif self:GetStage() ~= STAGE_WINDUP then
		myHero:MoveTo(movePos.x, movePos.z)
	end
end

function iOrbWalker:Attack(target)
	assert(not target or ValidTarget(target), "Error: iOrbWalker:Attack(target), invalid target.")
	if self:GetStage() == STAGE_NONE and ValidTarget(target, self.AARange) then
		myHero:Attack(target)
		return true
	end
	return false
end

function iOrbWalker:Move(movePos)
	assert(movePos and movePos.x and movePos.z, "Error: iOrbWalker:Move(movePos), invalid movePos.")
	if self:GetStage() ~= STAGE_WINDUP then
		myHero:MoveTo(movePos.x, movePos.z)
		return true
	end
	return false
end

--[[ Manual Orbwalking (Placed in OnSendPacket) ]]--

function iOrbWalker:ManualOrbwalk(packet, rangeFromMouse)
	assert(rangeFromMouse == nil or type(rangeFromMouse) == "number", "Error: iOrbWalker:ManualOrbwalk(packet, rangeFromMouse) -> <packet><number> expected.")
	if packet.header == 0x71 then
		if self:GetStage() == STAGE_WINDUP then
			packet:Block()
		elseif self:GetStage() == STAGE_ORBWALK then
			local pPacket = Packet(packet)
			packet:Block()
			myHero:Move(pPacket.values.x, pPacket.values.z)
			return {x = pPacket.values.x, z = pPacket.values.z}
		else
			local pPacket = Packet(packet)
			packet:Block()
			for _, enemy in ipairs(GetEnemyHeroes()) do
				if GetDistance(pPacket.values, enemy) < (rangeFromMouse or 50) then
					myHero:Attack(enemy)
					return enemy
				end
			end
		end
	end
end

function iOrbWalker:ManualBlock(packet)
	if pack.header == 0x71 then
		if self:GetStage() == STAGE_WINDUP then
			packet:Block()
		end
	end
end

--[[ Information ]]--

function iOrbWalker:GetStage()
	if GetTickCount() > self.NextShot then return STAGE_NONE end
	if GetTickCount() > self.ShotCast then return STAGE_ORBWALK end
	return STAGE_WINDUP
end

function iOrbWalker:GetDPS(unit, target)
	local unit = unit or myHero
	if target then
		return unit.totalDamage and unit.attackSpeed and unit:CalcDamage(target, (1/(unit.attackSpeed * 0.625))*unit.totalDamage) or 0
	else
		return unit.totalDamage and unit.attackSpeed and (1/(unit.attackSpeed * 0.625))*unit.totalDamage or 0
	end
end

--[[ Configuration Functions ]]--

function iOrbWalker:addAA(AAName, isAnimation) -- Add AA spell
	assert(AAName == nil or type(AAName) == "string", "Error: iOrbWalker:addAA(AAName, isAnimation), <string> or nil expected.")
	if isAnimation then
		if AAName then
			if not self.AASpellsAnim then self.AASpellsAnim = {} end
			self.AASpellsAnim[#self.AASpellsAnim+1] = AAName
		end
	else
		if not self.AASpells then self.AASpells = {} end
		if not AAName then
			self.AASpells[#self.AASpells+1] = "attack"
			if _customValues and _customValues.AASpells then
				if type(_customValues.AASpells[myHero.charName]) == "string" then
					self.AASpells[#self.AASpells+1] = _customValues.AASpells[myHero.charName]
				elseif type(_customValues.AASpells[myHero.charName]) == "table" then
					for _, AAName in ipairs(_customValues.AASpells[myHero.charName]) do
						self.AASpells[#self.AASpells+1] = AAName
					end
				end
			end
		else
			self.AASpells[#self.AASpells+1] = AAName
		end
	end
end

function iOrbWalker:removeAA(AAName, isAnimation) -- Remove AA spell
	if isAnimation then
		if self.AASpellsAnim then
			for i, AAName2 in ipairs(self.AASpellsAnim) do
				if AAName2 == AAName then
					table.remove(self.AASpellsAnim, i)
					return
				end
			end
		end
	elseif self.AASpells then
		for i, AAName2 in ipairs(self.AASpells) do
			if AAName2 == AAName then
				table.remove(self.AASpells, i)
				return
			end
		end
	end
end

function iOrbWalker:ignoreAA(AAName, isAnimation)
	assert(type(resetName) == "string", "Error: iOrbWalker:ignoreAA(AAName), <string> expected.")
	if isAnimation then
		if not self.AASpellsIgnoreAnim then
			self.AASpellsIgnoreAnim = {AAName}
		else
			self.AASpellsIgnoreAnim[#self.AASpellsIgnoreAnim+1] = AAName
		end
	elseif not self.AASpellsIgnore then
		self.AASpellsIgnore = {AAName}
	else
		self.AASpellsIgnore[#self.AASpellsIgnore+1] = AAName
	end
end

function iOrbWalker:addReset(resetName, isAnimation) -- Add AA-timer resetting spell
	--assert(type(resetName) == "string", "Error: iOrbWalker:addReset(resetName), <string> expected.")
	if isAnimation then
		if resetName then
			if not self.ResetSpellsAnim then self.ResetSpellsAnim = {} end
			self.ResetSpellsAnim[#self.ResetSpellsAnim+1] = resetName
		end
	else
		if not self.ResetSpells then self.ResetSpells = {} end
		if not resetName then
			if _customValues and _customValues.ResetSpells then
				if type(_customValues.ResetSpells[myHero.charName]) == "string" then
					self.ResetSpells[#self.ResetSpells+1] = _customValues.ResetSpells[myHero.charName]
				elseif type(_customValues.ResetSpells[myHero.charName]) == "table" then
					for _, resetName in ipairs(_customValues.ResetSpells[myHero.charName]) do
						self.ResetSpells[#self.ResetSpells+1] = resetName
					end
				end
			end
		else
			self.ResetSpells[#self.ResetSpells+1] = resetName
		end
	end
end

function iOrbWalker:OnProcessSpell(unit, spell)
	if unit.isMe then
		if self.AASpellsIgnore then
			for _, AAName in ipairs(self.AASpellsIgnore) do
				if spell.name:find(AAName) then return end
			end
		end
		if self.ResetSpells then
			for _, resetName in ipairs(self.ResetSpells) do
				if spell.name:find(resetName) then
					self.ShotCast = GetTickCount()
					self.NextShot = GetTickCount()
					return
				end
			end
		end
		if self.AASpells and spell.windUpTime and spell.animationTime then
			for _, AAName in ipairs(self.AASpells) do
				if AAName == "attack" and spell.name:lower():find("attack") then -- Simple lowercase checking for "attack" for the lazy people who don't want to search for all the basic attack names (like me) 
					self.ShotCast = GetTickCount() + spell.windUpTime * 1000 - GetLatency() / 2 + self.addDelay
					self.NextShot = GetTickCount() + spell.animationTime * 1000
					self.windUpTime = spell.windUpTime
					self.animationTime = spell.animationTime
					return
				elseif spell.name:find(AAName) then
					self.ShotCast = GetTickCount() + spell.windUpTime * 1000 - GetLatency() / 2 + self.addDelay
					self.NextShot = GetTickCount() + spell.animationTime * 1000
					self.windUpTime = spell.windUpTime
					self.animationTime = spell.animationTime
					return
				end
			end
		end
	end
end

function iOrbWalker:OnAnimation(unit, animation)
	if unit.isMe then
		if self.AASpellsIgnoreAnim then
			for _, AAName in ipairs(self.AASpellsIgnoreAnim) do
				if animation:find(AAName) then return end
			end
		end
		if self.ResetSpellsAnim then
			for _, resetName in ipairs(self.ResetSpellsAnim) do
				if animation:find(resetName) then
					self.ShotCast = GetTickCount()
					self.NextShot = GetTickCount()
					return
				end
			end
		end
		if self.AASpellsAnim and self.windUpTime and self.animationTime then
			for _, AAName in ipairs(self.AASpellsAnim) do
				if animation:find(AAName) then
					self.ShotCast = GetTickCount() + self.windUpTime * 1000 - GetLatency() / 2 + self.addDelay
					self.NextShot = GetTickCount() + self.animationTime * 1000
					return
				end
			end
		end
	end
end

--[[ 	iCaster Class
	
	Methods:
		local Spell = iCaster(spell, range, spellType, [speed, delay, width, useCollisionLib])

		local Spell = iCaster(spell, range, SPELL_TARGETED)
		local Spell = iCaster(spell, range, SPELL_LINEAR, speed, delay, [width])
		local Spell = iCaster(spell, range, SPELL_CIRCLE, speed, delay, [width])
		local Spell = iCaster(spell, range, SPELL_CONE)
		local Spell = iCaster(spell, range, SPELL_LINEAR_COL, speed, delay, width, [useCollisionLib])
		local Spell = iCaster(spell, range, SPELL_SELF)

	Functions:
		Spell:Cast(target, [minHitChance])		-> Casts spell at target. minHitChance is for skillshots, will use 0 if omitted.
		Spell:CastMouse(spellPos, [nearestTarget])		-> Casts spell at spellPos. nearestTarget is for SPELL_TARGETED to target the nearest enemy champion to spellPos.
		Spell:AACast(iOrbWalker, target, [minHitChance])		-> Casts spell right after autoattack. Requires an iOrbWalker instance.
		Spell:AACastMouse(iOrbWalker, spellPos, [nearestTarget])		-> Casts spell right after autoattack at spellPos. Requires an iOrbWalker instance.
		Spell:Ready()		-> Returns true/false
		Spell:GetPrediction(target)		-> Returns the prediction for target
		Spell:GetCollision(spellPos)		-> Returns if the spell will collide.

	Members:
		Spell.spell
		Spell.range
		Spell.spellType
		Spell.speed
		Spell.delay
		Spell.width
		Spell.spellData 	-> Same information as myHero:GetSpellData(spell) at the time the instance was initiated.
		Spell.pred 			-> Prediction
		Spell.coll 			-> Collision lib

	Example:
		local QSpell = iCaster(_Q, nil, SPELL_SELF)
		local Orbwalker = iOrbWalker(myHero.range)

		function OnTick()
			QSpell:AACast(Orbwalker)
		end

	]]--

class 'iCaster'

SPELL_TARGETED = 1
SPELL_LINEAR = 2
SPELL_CIRCLE = 3
SPELL_CONE = 4
SPELL_LINEAR_COL = 5
SPELL_SELF = 6

function iCaster:__init(spell, range, spellType, speed, delay, width, useCollisionLib)
	--assert(spell and (range or spellType == SPELL_SELF), "Error: iCaster:__init(spell, range, spellType, [speed, delay, width, useCollisionLib]), invalid arguments.")
	self.spell = spell
	self.range = range or 0
	self.spellType = spellType or SPELL_SELF
	self.speed = speed or math.huge
	self.delay = delay or 0
	self.width = width
	self.spellData = myHero:GetSpellData(spell)
	if spellType == SPELL_LINEAR or spellType == SPELL_CIRCLE or spellType == SPELL_LINEAR_COL then
		--if type(range) == "number" and (not speed or type(speed) == "number") and (not delay type(delay) == "number" and (type(width) == "number" or not width) then
			--assert(type(range) == "number" and type(speed) == "number" and type(delay) == "number" and (type(width) == "number" or not width), "Error: iCaster:__init(spell, range, [spellType, speed, delay, width, useCollisionLib]), invalid arguments for skillshot-type.")
			self.pred = VIP_USER and TargetPredictionVIP(range, speed, delay, width) or TargetPrediction(range, speed/1000, delay*1000, width)
			if spellType == SPELL_LINEAR_COL then
				self.coll = VIP_USER and useCollisionLib ~= false and Collision(range, (speed or math.huge), delay, width) or nil
			end
		--end
	end
end

function iCaster:__type()
	return "iCaster"
end

function iCaster:Data()
	return myHero:GetSpellData(self.spell)
end

function iCaster:Cast(target, minHitChance)
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

function iCaster:CastMouse(spellPos, nearestTarget)
	assert(spellPos and spellPos.x and spellPos.z, "Error: iCaster:CastMouse(spellPos, nearestTarget), invalid spellPos.")
	assert(self.spellType ~= SPELL_TARGETED or (nearestTarget == nil or type(nearestTarget) == "boolean"), "Error: iCaster:CastMouse(spellPos, nearestTarget), <boolean> or nil expected for nearestTarget.")
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

function iCaster:AACast(iOW, target, minHitChance) -- Cast after AA
	if not iOW then return false end
	if iOW:GetStage() == STAGE_ORBWALK then
		return self:Cast(target, minHitChance)
	end
end

function iCaster:AACastMouse(iOW, spellPos, nearestTarget)
	if not iOW then return false end
	if iOW:GetStage() == STAGE_ORBWALK then
		return self:CastMouse(spellPos, nearestTarget)
	end
end

function iCaster:Ready()
	return myHero:CanUseSpell(self.spell) == READY
end

function iCaster:GetPrediction(target)
	if self.pred and ValidTarget(target) then return self.pred:GetPrediction(target) end
end

function iCaster:GetCollision(spellPos)
	if spellPos and spellPos.x and spellPos.z then
		if self.coll then
			return self.coll:GetMinionCollision(myHero, spellPos)
		else
			return iCollision(spellPos, self.width)
		end
	end
end

--[[ iSummoners Class - Credits to LoLZinga for the base

	Methods:
		local Summoners = iSummoners()

	Functions
		Summoners:Ready(spell)		-> Returns true/false
		Summoners:AutoAll()			-> Automatically uses all summoner spells.
		Summoners:AutoIgnite([dmgMultiplier])		-> Auto ignites killable enemies. dmgMultiplier is in percentages between 1 and 100, can be left omitted.
		Summoners:AutoBarrier([maxHPPerc, procRate])		-> Auto barriers on high damage. maxHPPerc and procRate are in percentages. Will only use barrier if your health is below maxHPPerc%. 
		Summoners:AutoRevive([condition])		-> Auto revives you. Condition can be left omitted or should be a function returning true or false.
		Summoners:AutoClarity([maxManaPerc, condition])		-> Auto uses clarity if your mana is below maxManaPerc%. Condition can be left omitted or should be a function returning a value.
		Summoners:AutoHeal([maxHPPerc, procRate, useForTeam])		-> Auto heals you and your team. Works the same as AutoBarrier logically.
		Summoners:Exhaust(target)		-> Exhausts the target.

	Members:
		Summoners.SUMMONER_1
		Summoners.SUMMONER_2
		Summoners.Clarity
		Summoners.Garrison
		Summoners.Ghost
		Summoners.Heal
		Summoners.Revive
		Summoners.Smite
		Summoners.Cleanse
		Summoners.Teleport
		Summoners.Barrier
		Summoners.Exhaust
		Summoners.Ignite
		Summoners.Clairvoyance
		Summoners.Flash

		Sub-Members:
			Summoners.<InsertSpellHere>.name
			Summoners.<InsertSpellHere>.shortName
			Summoners.<InsertSpellHere>.range
			Summoners.<InsertSpellHere>.slot

	Example:
		local Summoners = iSummoners()

		function OnTick()
			Summoners:AutoAll()
		end

	]]--

class 'iSummoners'
local _SummonerSpells = {
	SummonerMana = {name = "SummonerMana", shortName = "Clarity", range = 600},
	SummonerOdinGarrison = {name = "SummonerOdinGarrison", shortName = "Garrison", range = 1000},
	SummonerHaste = {name = "SummonerHaste", shortName = "Ghost", range = nil},
	SummonerHeal = {name = "SummonerHeal", shortName = "Heal", range = 300},
	SummonerRevive = {name = "SummonerRevive", shortName = "Revive", range = nil},
	SummonerSmite = {name = "SummonerSmite", shortName = "Smite", range = 625},
	SummonerBoost = {name = "SummonerBoost", shortName = "Cleanse", range = nil},
	SummonerTeleport = {name = "SummonerTeleport", shortName = "Teleport", range = nil},
	SummonerBarrier = {name = "SummonerBarrier", shortName = "Barrier", range = nil},
	SummonerExhaust = {name = "SummonerExhaust", shortName = "Exhaust", range = 550},
	SummonerDot = {name = "SummonerDot", shortName = "Ignite", range = 600},
	SummonerClairvoyance = {name = "SummonerClairvoyance", shortName = "Clairvoyance", range = nil},
	SummonerFlash = {name = "SummonerFlash", shortName = "Flash", range = 400}
}

function iSummoners:__init()
	self.SUMMONER_1 = _SummonerSpells[myHero:GetSpellData(SUMMONER_1).name]
	self.SUMMONER_1.slot = SUMMONER_1
	self.SUMMONER_2 = _SummonerSpells[myHero:GetSpellData(SUMMONER_2).name]
	self.SUMMONER_2.slot = SUMMONER_2
	self[self.SUMMONER_1.shortName] = self.SUMMONER_1
	self[self.SUMMONER_2.shortName] = self.SUMMONER_2
end

function iSummoners:__type()
	return "iSummoners"
end

function iSummoners:Ready(spell)
	if type(spell) == "number" then
		if spell == 1 or spell == 2 then
			return myHero:CanUseSpell(self["SUMMONER_"..spell].slot) == READY
		elseif spell == SUMMONER_1 or spell == SUMMONER_2 then
			return myHero:CanUseSpell(spell) == READY
		end
	elseif type(spell) == "string" then
		if self[spell] then
			return myHero:CanUseSpell(self[spell].slot) == READY
		end
	end
	return false
end

function iSummoners:AutoAll()
	self:AutoIgnite()
	self:AutoBarrier()
	self:AutoRevive()
	self:AutoClarity()
	self:AutoHeal()
end

function iSummoners:AutoIgnite(dmgMultiplier)
	assert(not dmgMultiplier or (type(dmgMultiplier) == "number" and dmgMultiplier <= 100 and dmgMultiplier > 0), "Error: iSummoners:AutoIgnite(dmgMultiplier, invalid dmgMultiplier.")
	if self.Ignite and not myHero.dead and myHero:CanUseSpell(self.Ignite.slot) == READY then
		local dmgMultiplier = dmgMultiplier and dmgMultiplier / 100 or 1
		for _, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, self.Ignite.range) and getDmg("IGNITE", enemy, myHero) * dmgMultiplier > enemy.health then
				CastSpell(self.Ignite.slot, enemy)
			end
		end
	end
end

function iSummoners:AutoBarrier(maxHPPerc, procRate)
	assert(not maxHPPerc or (type(maxHPPerc) == "number" and maxHPPerc <= 100 and maxHPPerc > 0), "Error: iSummoners:AutoBarrier(maxHPPerc, procRate), invalid maxHPPerc.")
	assert(not procRate or (type(procRate) == "number" and procRate <= 100 and procRate > 0), "Error: iSummoners:AutoBarrier(maxHPPerc, procRate), invalid procRate.")
	if self.Barrier then
		local maxHPPerc = maxHPPerc and maxHPPerc / 100 or 0.3
		local procRate = procRate and procRate / 100 or 0.3
		if not self.Barrier.nextCheck then self.Barrier.nextCheck = 0 end
		if not self.Barrier.healthBefore then
			self.Barrier.healthBefore = {}
		elseif GetTickCount() >= self.Barrier.nextCheck then
			if myHero:CanUseSpell(self.Barrier.slot) == READY and #self.Barrier.healthBefore > 1 then
				local HPRatio = myHero.health / myHero.maxHealth
				local procHP = self.Barrier.healthBefore[1] * procRate 
				if myHero.health < procHP and maxHPPerc < HPRatio then
					CastSpell(self.Barrier.slot)
				end
			end
			self.Barrier.nextCheck = GetTickCount() + 100
			self.Barrier.healthBefore[#self.Barrier.healthBefore+1] = myHero.health
			if #self.Barrier.healthBefore > 10 then
				table.remove(self.Barrier.healthBefore, 1)
			end
		end
	end
end

function iSummoners:AutoRevive(condition)
	assert(not condition or type(condition) == "function", "Error: iSummoners:AutoRevive(condition), invalid condition.")
	if self.Revive and myHero.dead and myHero:CanUseSpell(self.Revive.slot) == READY and (not condition or condition()) then
		CastSpell(self.Revive.slot)
	end
end

function iSummoners:AutoClarity(maxManaPerc, condition)
	assert(not maxManaPerc or (type(maxManaPerc) == "number" and maxManaPerc <= 100 and maxManaPerc > 0), "Error: iSummoners:AutoClarity(maxManaPerc), invalid maxManaPerc.")
	if self.Clarity then
		local maxManaPerc = maxManaPerc and maxManaPerc / 100 or 0.3
		if myHero:CanUseSpell(self.Clarity.slot) == READY and myHero.mana / myHero.maxMana < maxManaPerc and (not condition or condition()) then
			CastSpell(self.Clarity.slot)
		end
	end
end

function iSummoners:AutoHeal(maxHPPerc, procRate, useForTeam)
	assert(not maxHPPerc or (type(maxHPPerc) == "number" and maxHPPerc <= 100 and maxHPPerc > 0), "Error: iSummoners:AutoHeal(maxHPPerc, procRate, useForTeam), invalid maxHPPerc.")
	assert(not procRate or (type(procRate) == "number" and procRate <= 100 and procRate > 0), "Error: iSummoners:AutoHeal(maxHPPerc, procRate, useForTeam), invalid procRate.")
	assert(useForTeam == nil or type(useForTeam) == "boolean", "Error: iSummoners:AutoHeal(maxHPPerc, procRate, useForTeam), invalid useForTeam")
	if self.Heal then
		local maxHPPerc = maxHPPerc and maxHPPerc / 100 or 0.3
		local procRate = procRate and procRate / 100 or 0.3
		local useForTeam = useForTeam ~= false
		if not self.Heal.nextCheck then self.Heal.nextCheck = 0 end
		if not self.Heal.healthBefore then
			self.Heal.healthBefore = {}
			for _, ally in ipairs(GetAllyHeroes()) do
				self.Heal.healthBefore[ally.charName] = {}
			end
			self.Heal.healthBefore[myHero.charName] = {}
		elseif GetTickCount() >= self.Heal.nextCheck then
			if myHero:CanUseSpell(self.Heal.slot) == READY and #self.Heal.healthBefore[myHero.charName] > 1then
				local HPRatio = myHero.health / myHero.maxHealth
				local procHP = self.Heal.healthBefore[myHero.charName][1] * procRate 
				if myHero.health < procHP and maxHPPerc < HPRatio then
					CastSpell(self.Heal.slot)
				end
				if useForTeam then
					for _, ally in ipairs(GetAllyHeroes()) do
						if GetDistance(ally) < self.Heal.range and not ally.dead then
							local HPRatio = ally.health / ally.maxHealth
							local procHP = self.Heal.healthBefore[ally.charName][1] * procRate 
							if ally.health < procHP and maxHPPerc < HPRatio then
								CastSpell(self.Heal.slot)
							end
						end
					end
				end
			end
			self.Heal.nextCheck = GetTickCount() + 100
			self.Heal.healthBefore[myHero.charName][#self.Heal.healthBefore[myHero.charName]+1] = myHero.health
			if #self.Heal.healthBefore[myHero.charName] > 10 then
				table.remove(self.Heal.healthBefore[myHero.charName], 1)
			end
			for _, ally in ipairs(GetAllyHeroes()) do
				self.Heal.healthBefore[ally.charName][#self.Heal.healthBefore[ally.charName]+1] = ally.health
				if #self.Heal.healthBefore[ally.charName] > 10 then
					table.remove(self.Heal.healthBefore[ally.charName], 1)
				end
			end
		end
	end
end

function iSummoners:Exhaust(target) -- No AutoExhaust until I find a reliable logic. (No, AutoExhaust anyone below 50% HP is NOT reliable...)
	if self.Exhaust and ValidTarget(target, self.Exhaust.range) and myHero:CanUseSpell(self.Exhaust.slot) then
		CastSpell(self.Exhaust.slot, target)
	end
end

--[[ iTems Class

	Methods:
		local Items = iTems()

	Functions:
		Items:add(name, ID, [range, extraOptions]) 	-> Adds an item to the instance. Name and ID required, range and extraOptions optional.
		Items:update() 								-> Update the instance. Item ready statusses and slots.
		Items:Have(itemID, [unit])					-> Check if the unit has the item. Returns true/false.
		Items:Slot(itemID, [unit])					-> Check if the unit has the item. Returns true/false.
		Items:Dmg(itemID, target, [source])			-> Returns the damage the item will deal on the target. Source optional, uses myHero if omitted.
		Items:InRange(itemID, target, [source])		-> Check if the target is within range. Returns true/false.
		
		Items:Use(itemID, [nil, nil, condition])	-> Use the item(s). Condition is optional, should be a function returning a boolean if used.
		Items:Use(itemID, target, [nil, condition])	-> itemID can be "all" if you wish to use all items.
		Items:Use(itemID, pos.x, pos.z,[condition])	->

	Members:
		Items.items		-- Returns the table with all added items.
	
	Example Usage:
		local items = iTems()
		
		function OnLoad()
			items:add("DFG", 3128, 600, {onlyOnKill = true})
		end

		function OnTick()
			if ValidTarget(GetTarget()) then
				items:Use("DFG", GetTarget(), nil, (function(item, target) return (target.health / target.maxHealth > 0.5) end))
			end
		end

	]]--

class 'iTems'

local itemsAliasForDmgCalc = { -- Item Aliases for spellDmg lib, including their corresponding itemID's.
	["DFG"] = 3128,
	["HXG"] = 3146,
	["BWC"] = 3144,
	["HYDRA"] = 3074,
	["SHEEN"] = 3057,
	["KITAES"] = 3186,
	["TIAMAT"] = 3077,
	["NTOOTH"] = 3115,
	["SUNFIRE"] = 3068,
	["WITSEND"] = 3091,
	["TRINITY"] = 3078,
	["STATIKK"] = 3087,
	["ICEBORN"] = 3025,
	["MURAMANA"] = 3042,
	["LICHBANE"] = 3100,
	["LIANDRYS"] = 3151,
	["BLACKFIRE"] = 3188,
	["HURRICANE"] = 3085,
	["RUINEDKING"] = 3153,
	["LIGHTBRINGER"] = 3185,
	["SPIRITLIZARD"] = 3209,
	--["ENTROPY"] = 3184,
}

function iTems:__init()
	self.items = {}
end

function iTems:__type()
	return "iTems"
end


function iTems:add(name, ID, range, extraOptions)
	assert(type(name) == "string" and type(ID) == "number" and (not range or range == math.huge or type(range) == "number") and (extraOptions == nil or type(extraOptions) == "table"))
	self.items[name] = {ID = ID, range = range or math.huge, slot = nil, ready = false}
	if extraOptions then
		for key, value in pairs(extraOptions) do
			self.items[name][key] = value
		end
	end
end

function iTems:update()
	for _, item in pairs(self.items) do
		item.slot = GetInventorySlotItem(item.ID)
		item.ready = (item.slot and myHero:CanUseSpell(item.slot) == READY or false)
	end
end

function iTems:Ready(itemID)
	if type(itemID) == "string" then return (self.items[itemID] and self.items[itemID].ready) end
	if type(itemID) == "number" then
		for _, item in pairs(self.items) do
			if itemID == item.ID then
				return item.ready
			end
		end
	end		
end

function iTems:Have(itemID, unit)
	return GetInventorySlotItem(type(itemID) == "string" and self.items[itemID].ID or type(itemID) == "number" and itemID, unit) ~= nil
end

function iTems:Slot(itemID, unit)
	return GetInventorySlotItem(type(itemID) == "string" and self.items[itemID].ID or type(itemID) == "number" and itemID, unit)
end

function iTems:Dmg(itemID, target, source)
	if type(itemID) == "string" then
		if itemsAliasForDmgCalc[itemID] ~= nil then return getDmg(itemID, target, source or myHero) end
		if self.items[itemID] then
			for itemName, aliasID in pairs(itemsAliasForDmgCalc) do
				if self.items[itemID].ID == aliasID then return getDmg(itemName, target, source or myHero) end
			end
		end
	elseif type(itemID) == "number" then
		for itemName, aliasID in pairs(itemsAliasForDmgCalc) do
			if itemID == aliasID then return getDmg(itemName, target, source or myHero) end
		end
	end
	return 0
end

function iTems:InRange(itemID, enemy, source)
	if type(itemID) == "string" then return (self.items[itemID] and (not self.items[itemID].range or self.items[itemID].range > GetDistance(enemy, source or myHero))) end
	if type(itemID) == "number" then
		for _, item in pairs(self.items) do
			if itemID == item.ID then
				return (not item.range or item.range > GetDistance(enemy, source or myHero))
			end
		end
	end		
end

function iTems:Use(itemID, arg1, arg2, condition) -- Condition could be a function, such as (function(item) return item.slot ~= ITEM_6 end) or perhaps (function(item, target) return (target.health / target.maxHealth > 0.5) end)
	for itemName, item in pairs(self.items) do
		if type(itemID) == "string" and (itemID == "all" or itemID == itemName) or type(itemID) == "number" and itemID == item.ID then
			if item.ready and (condition == nil or condition(item, arg1, arg2)) then
				if arg2 then
					CastSpell(item.slot, arg1, arg2)
				elseif arg1 then
					if self:InRange(itemName, arg1) then
						CastSpell(item.slot, arg1)
					end
				else
					CastSpell(item.slot)
				end
			end
		end
	end
end

--[[ 	iMinionsOLD Class
	
	Methods:
		local Minions = iMinionsOLD(range, [includeAD])		-> Include AA damage if true or omitted. Set to false if you wish to use an instance for spells and not include AA damage.

	Functions:
		Minions:update()		-> Update the iMinions instance.
		Minions:setADDmg(damage)		-> Set additional on-hit AD damage
		Minions:setAPDmg(damage)		-> Set additional on-hit AP damage
		Minions:setTrueDmg(damage)		-> Set additional on-hit True damage
		Minions:marker(radius, colour, [thickness])		-> Draws circles around the killable minions. Place in OnDraw.
		Minions:LastHit(range, [condition])			-> Last hits the killable minions. (Very basic) Use condition for more advanced configurability. condition must be a function or left omitted.
		Minions:LastHitMove(movePos, range, [condition])		-> Same as Minions:LastHit, will move to movePos if no target.

	Example:
		local Minions = iMinionsOLD(1000)

		function OnDraw()
			Minions:update()
			Minions:marker(50, 0xFF80FF00, 10)
		end

]]--

class 'iMinionsOLD'

function iMinionsOLD:__init(range, includeAD) -- includeAD adds myHero.totalDamage for AA's. Set to false if you wish to use iMinions for spells.
	enemyMinions_update(range)
	self.includeAD = includeAD ~= false
	self.ADDmg, self.APDmg, self.TrueDmg = 0, 0, 0
	self.killable = {}
end

function iMinionsOLD:setADDmg(damage) -- For additional on-hit AD damage
	self.ADDmg = damage or 0
end

function iMinionsOLD:setAPDmg(damage) -- For additional on-hit AP damage
	self.APDmg = damage or 0
end

function iMinionsOLD:setTrueDmg(damage) -- For additional on-hit True damage
	self.TrueDmg = damage or 0
end

function iMinionsOLD:update()
	enemyMinions_update()
	self.killable = {}
	for _, minion in ipairs(_enemyMinions.objects) do
		if ValidTarget(minion) then
			local damage = ((self.includeAD or self.ADDmg ~= 0) and (myHero:CalcDamage(minion, (self.includeAD and myHero.totalDamage or 0) + self.ADDmg)) or 0) + (self.APDmg ~= 0 and myHero:CalcMagicDamage(minion, self.APDmg) or 0) + self.TrueDmg
			if damage > minion.health then
				self.killable[#self.killable+1] = minion
			end
		end
	end
	return self.killable
end

function iMinionsOLD:marker(radius, colour, thickness)
	if self.killable then
		for _, minion in ipairs(self.killable) do
			if thickness and thickness > 1 then
				for i = 1, thickness do
					DrawCircle(minion.x, minion.y, minion.z, radius+i, colour)
				end
			else
				DrawCircle(minion.x, minion.y, minion.z, radius, colour)
			end
		end
	end
end

function iMinionsOLD:LastHit(range, condition) -- Very basic, too tired to expand now.
	if self.killable then
		for _, minion in ipairs(self.killable) do
			if GetDistance(minion) < range and (not condition or condition(minion)) then
				myHero:Attack(minion)
				return minion
			end
		end
	end
	return nil
end

function iMinionsOLD:LastHitMove(movePos, range, condition)
	assert(movePos and movePos.x and movePos.z, "Error: iMinions:LastHitMove(movePos, range, condition), invalid movePos.")
	if self.killable then
		for _, minion in ipairs(self.killable) do
			if GetDistance(minion) < range and (not condition or condition(minion)) then
				myHero:Attack(minion)
				return minion
			end
		end
	end
	myHero:MoveTo(movePos.x, movePos.z)
end

--[[ Other General Functions ]]--

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

--[[ iMinions Class - Rewritten - Credits to Sida, logic is taken from Sida's Auto Carry ]]--

class 'iMinions'

local _minionAttacks, _incomingDamage = {obj_AI_Turret = {aaDelay = 150, projSpeed = 1.14}}, {}
_minionAttacks[(myHero.team == TEAM_BLUE and "Blue" or "Red").."_Minion_Basic"] = {aaDelay = 400, projSpeed = math.huge}
_minionAttacks[(myHero.team == TEAM_BLUE and "Blue" or "Red").."_Minion_Caster"] = {aaDelay = 484, projSpeed = 0.68}
_minionAttacks[(myHero.team == TEAM_BLUE and "Blue" or "Red").."_Minion_Wizard"] = {aaDelay = 484, projSpeed = 0.68}
_minionAttacks[(myHero.team == TEAM_BLUE and "Blue" or "Red").."_Minion_MechCannon"] = {aaDelay = 365, projSpeed = 1.18}

function iMinions:__init(range, iOW, projSpeed)
	local range = range or 1000
	enemyMinions_update(range)
	self.range = range
	self.projSpeed = projSpeed or (_customValues and _customValues.projSpeeds and _customValues.projSpeeds[myHero.charName]) or math.huge
	self.ADDmg, self.APDmg, self.TrueDmg = 0, 0, 0
	self.iOW = iOW or iOrbWalker(myHero.range)
	iMinions_AddProcSpell()
end

function iMinions:__type()
	return "iMinions"
end

function iMinions:AddSpell(iSpell)
	assert(iSpell:__type() == "iCaster", "Error: iMinions:AddSpell(iSpell), <iCaster> expected.")

end

function iMinions:SetBonusDmg(PhysDamage, MagicDamage, TrueDamage)
	self.ADDmg = PhysDamage or self.ADDmg
	self.APDmg = MagicDamage or self.APDmg
	self.TrueDmg = TrueDamage or self.TrueDmg
end

function iMinions:SimpleLastHit(range)
	enemyMinions_update()
	for _, minion in ipairs(_enemyMinions.objects) do
		if ValidTarget(minion, range) then
			local AADamage = getDmg("AD", minion, myHero) + (self.ADDmg > 0 and myHero:CalcDamage(minion, self.ADDmg) or 0)+ (self.APDmg > 0 and myHero:CalcMagicDamage(minion, self.APDmg) or 0) + self.TrueDmg
			if AADamage > minion.health then
				myHero:Attack(minion)
				return minion
			end
		end
	end
end

function iMinions:Marker(range, radius, colour, thickness)
	enemyMinions_update()
	for _, minion in ipairs(_enemyMinions.objects) do
		if ValidTarget(minion, range) then
			local AADamage = getDmg("AD", minion, myHero) + (self.ADDmg > 0 and myHero:CalcDamage(minion, self.ADDmg) or 0)+ (self.APDmg > 0 and myHero:CalcMagicDamage(minion, self.APDmg) or 0) + self.TrueDmg
			if AADamage > minion.health then
				if thickness and thickness > 1 then
					for i = 1, thickness do
						DrawCircle(minion.x, minion.y, minion.z, radius+i, colour)
					end
				else
					DrawCircle(minion.x, minion.y, minion.z, radius, colour)
				end
			end
		end
	end
end

function iMinions:LastHit(range, movePos, iOW)
	assert(range == nil or type(range) == "number", "Error: iMinions:LastHit(range, movePos), <number> or nil expected for range.")
	assert(movePos == nil or (movePos.x and movePos.z), "Error: iMinions:LastHit(range, movePos), invalid movePos.")
	--assert(Orbwalker and Orbwalker:__type() == "iOrbWalker", "Error: iMinions:LastHit(Orbwalker, range, movePos), invalid Orbwalker.")
	enemyMinions_update()
	if not ValidTarget(self.target) then self.target = self:GetNewCreep(1, range) end
	if movePos then iOW:Orbwalk(movePos, self.target) else iOW:Attack(self.target) end
end

function iMinions:GetNewCreep(index, range)
	if not index then return end
	local minion = _enemyMinions.objects[index]
	if ValidTarget(minion, range) then
		local predictedDamage = self:GetPredictedDamage(minion)
		local AADamage = getDmg("AD", minion, myHero) + myHero:CalcDamage(minion, self.ADDmg) + myHero:CalcMagicDamage(minion, self.APDmg) + self.TrueDmg
		if minion.health > predictedDamage and AADamage + predictedDamage > minion.health then
			return minion
		end
	end
	if index < #_enemyMinions.objects then
		return self:GetNewCreep(index + 1, range)
	end
	return nil
end

function iMinions:GetPredictedDamage(minion)
	local predictedDamage = 0
	for i, attack in ipairs(_incomingDamage) do
		if not attack.target or not attack.source or attack.target.dead or attack.source.dead or GetDistanceSqr(attack.source, attack.origin) > 9 then
			table.remove(_incomingDamage, i)
		elseif minion.networkID == attack.target.networkID then
			local myTimeToHit = (self.projSpeed < math.huge and GetDistance(minion) / self.projSpeed or 0) + GetLatency() / 2 + (self.iOW and self.iOW.windUpTime or 500 / (myHero.attackSpeed * 0.625))
			local minionTimeToHit = attack.delay + GetDistance(attack.source, minion) / attack.speed
			if attack.started + minionTimeToHit < GetTickCount() then
				table.remove(_incomingDamage, i)
			elseif GetTickCount() + myTimeToHit > attack.started + minionTimeToHit then
				predictedDamage = predictedDamage + attack.damage
			end
		end
	end
	return predictedDamage
end

function iMinions_AddProcSpell()
	if not iMinions_OnProcessSpell then
		function iMinions_OnProcessSpell(unit, spell)
			enemyMinions_update()
			if unit and (unit.type == "obj_AI_Minion" or unit.type == "obj_AI_Turret") and unit.team == myHero.team then
				for _, minion in ipairs(_enemyMinions.objects) do
					if ValidTarget(minion) and GetDistanceSqr(minion, spell.endPos) < 9 then
						if _minionAttacks[unit.charName] or unit.type == "obj_AI_turret" then
							_incomingDamage[#_incomingDamage+1] = iMinions_getNewAttackDetails(unit, minion)
						end
					end
				end
			end
		end
		AddProcessSpellCallback(iMinions_OnProcessSpell)
	end
end

function iMinions_getNewAttackDetails(source, target)
	return  {
		source = source,
		target = target,
		damage = source:CalcDamage(target),
		started = GetTickCount(),
		origin = {x = source.x, z = source.z},
		delay = source.type == "obj_AI_Turret" and minionAttacks.obj_AI_Turret.aaDelay or minionAttacks[source.charName].aaDelay,
		speed = source.type == "obj_AI_Turret" and minionAttacks.obj_AI_Turret.projSpeed or minionAttacks[source.charName].projSpeed,
		--sourceType = source.type,
	}
end

--[[ To do:
	
	- Add spell support to iMinions

]]--