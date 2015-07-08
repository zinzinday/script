
require "iSAC"
require "Utils"
require "MapPosition"


function _GetDistance(a,b)
b = b or myHero
local x = 0
local status,err = xpcall( function() x = GetDistance(a,b) end,function(err) print(debug.traceback()) end)

return x

end

do
ProgramName = "AutoBot"
version = 0.81

	-- Lane
	TOP = 1
	BOTTOM = 2
	MID = 3
	JUN = 5
	BASE = 7
	ALL = TOP+BOTTOM+MID+JUN


	-- Hero States
	INIT = -1337
	SETUP = 1
	HARRASSING = 3
	AGGRO = 4
	FARM = 5
	LASTHIT = 7
	OBJECTIVE = 10
	SAFE = 9
	RUN = 11
	MOVING = 12
	RECALLING = 13
	DEAD = 17


	-- Lane Status
	UNDER_ALLY_TOWER = 1
	UNDER_ENEMY_TOWER = 2
	LANE_PUSHED = 3
	LANE_PUSHING = 4
	NEUTRAL = 5

end
class "Autobot"

function Autobot:__init(lane)
	self.lanes = {}
	self.lanes[TOP] = {}
	self.lanes[MID] = {}
	self.lanes[BOTTOM] = {}
	self.lanes[ALL] = 0
	self.aaTarget = nil
	self.followTarget = nil
	self.status = INIT
	self.teamMate = nil
	self.laneStatus = INIT
	if(lane and lane >= TOP and lane <= MID) then
		self.lane = lane
	else
		self.lane = BOTTOM
	end
end

function Autobot:__type()
	return "iOrbWalker"
end



function getTrueRange(unit)
	unit = unit or myHero
	return unit.range + _GetDistance(unit.minBBox)
end

-- SPELL ORDER
spells = {_W,_E,_W,_Q,_W,_R,_W,_Q,_W,_E,_R,_E,_Q,_Q,_Q,_R,_E,_E}

local AARange = getTrueRange()
local minionInfo = {}

local ts = TargetSelector(TARGET_LOW_HP_PRIORITY, AARange, DAMAGE_PHYSICAL, true)
local iOW = iOrbWalker(AARange)
local iSum = iSummoners()
local isMelee = AARange < 400

--[[ Global Functions ]]--





-- Data
local enemies = {}
local allies = {}
local incomingDamage = {}
local enemyMinions = nil
local allyMinions = nil
local allyLanes = {}
local enemyLanes = {}
local allySpawn = nil
local enemySpawn = nil

local toggleKey = string.byte("X")


local ChampInfo = {}
local closestEnemy = nil


local lastHitTarget = nil
local projSpeed  = nil

function PrintOnChat(msg)
	PrintChat(ProgramName.." > "..msg)
end

active = false

function fillTeams()

	allies = GetAllyHeroes()
	enemies = GetEnemyHeroes()
		-- for i = 1, heroManager.iCount, 1 do
		-- 	local candidate = heroManager:getHero(i)
		-- 	if candidate ~= nil or candidate.valid == true then
		-- 		if candidate.team == myHero.team then table.insert(allies,candidate)
		-- 		elseif candidate.team == TEAM_ENEMY then table.insert(enemies,candidate) end
		-- 	end
		-- end

	end





-- LAST HITTING -- Credit SAC

function LastHitOnLoad()

	enemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	allyMinions = minionManager(MINION_ALLY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, getTrueRange(), DAMAGE_PHYSICAL, false)

	minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Basic"] =      { aaDelay = 400, projSpeed = 0    }
	minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Caster"] =     { aaDelay = 484, projSpeed = 0.68 }
	minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Wizard"] =     { aaDelay = 484, projSpeed = 0.68 }
	minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_MechCannon"] = { aaDelay = 365, projSpeed = 1.18 }
	minionInfo.obj_AI_Turret =                                         { aaDelay = 150, projSpeed = 1.14 }
	PrintOnChat("LastHit Handler initialized.")  
end

function LastHitOnTick()

	enemyMinions:update()
	allyMinions:update()
	for l,m in pairs(incomingDamage) do

	end

end

function LastHitOnProcessSpell(object, spell)
	if isAllyMinionInRange(object) then
		for i,minion in pairs(enemyMinions.objects) do
			if ValidTarget(minion) and minion ~= nil and _GetDistance(minion, spell.endPos) < 3 then
			if object ~= nil and (minionInfo[object.charName] or object.type == "obj_AI_turret") then
				incomingDamage[object.networkID] = getNewAttackDetails(object, minion)
			end

		end
	end
end
end

function LastHitOnDraw()
	if  aaTarget and ValidTarget(aaTarget) and not isMelee then
		DrawCircle(aaTarget.x, aaTarget.y, aaTarget.z, 100, 0x19A712)
	end
	if followTarget ~= nil and followTarget.health > 1 then
		DrawCircle(followTarget.x, followTarget.y, followTarget.z, 100, 0xEE4220)
	end
end

function getTimeToHit(enemy, speed)
	return (( _GetDistance(enemy) / speed ) + GetLatency()/2)
end

function isAllyMinionInRange(minion)
	if minion ~= nil and minion.team == myHero.team
		and (minion.type == "obj_AI_Minion" or minion.type == "obj_AI_Turret")
		and _GetDistance(minion) <= 2000 then return true
		else return false end
	end

	function getMinionDelay(minion)
		return ( minion.type == "obj_AI_Turret" and minionInfo.obj_AI_Turret.aaDelay or minionInfo[minion.charName].aaDelay )
	end

	function getMinionProjSpeed(minion)
		return ( minion.type == "obj_AI_Turret" and minionInfo.obj_AI_Turret.projSpeed or minionInfo[minion.charName].projSpeed )
	end

	function minionSpellStillViable(attack)
		if attack == nil then return false end
		local sourceMinion = getAllyMinion(attack.sourceName)
		local targetMinion = getEnemyMinion(attack.targetName)
		if sourceMinion == nil or targetMinion == nil then return false end
		if sourceMinion.dead or targetMinion.dead or _GetDistance(sourceMinion, attack.origin) > 3 then return false else return true end
	end

	function getAllyMinion(name)
		for i, minion in pairs(allyMinions.objects) do
			if minion ~= nil and minion.valid and minion.name == name then
				return minion
			end
		end
		return nil
	end

	function getEnemyMinion(name)
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and ValidTarget(minion) and minion.name == name then
				return minion
			end
		end
		return nil
	end

	function isSameMinion(minion1, minion2)
		if minion1.networkID == minion2.networkID then return true
			else return false end
		end

		function getMinionTimeToHit(minion, attack)
			local sourceMinion = getAllyMinion(attack.sourceName)
			return ( attack.speed == 0 and ( attack.delay ) or ( attack.delay + _GetDistance(sourceMinion, minion) / attack.speed ) )
		end

		function getNewAttackDetails(source, target)
			return  {
				sourceName = source.name,
				targetName = target.name,
				damage = source:CalcDamage(target),
				started = GetTickCount(),
				origin = { x = source.x, z = source.z },
				delay = getMinionDelay(source),
				speed = getMinionProjSpeed(source),
				sourceType = source.type}
			end

			function getPredictedDamage(counter, minion, attack)
				if not minionSpellStillViable(attack) then
					incomingDamage[counter] = nil
				elseif isSameMinion(minion, getEnemyMinion(attack.targetName)) then
					local myTimeToHit = getTimeToHit(minion, projSpeed)
					minionTimeToHit = getMinionTimeToHit(minion, attack)
					if GetTickCount() >= (attack.started + minionTimeToHit) then
						incomingDamage[counter] = nil
					elseif GetTickCount() + myTimeToHit > attack.started + minionTimeToHit then
						return attack.damage
					end
				end
				return 0
			end

			function getKillableCreep(iteration)
				if isMelee then return meleeLastHit() end
				local minion = enemyMinions.objects[iteration]
				if minion ~= nil then
					local distanceToMinion = _GetDistance(minion)
					local predictedDamage = 0
					if distanceToMinion < getTrueRange() then
						for l, attack in pairs(incomingDamage) do
							predictedDamage = predictedDamage + getPredictedDamage(l, minion, attack)
						end
						local myDamage = myHero:CalcDamage(minion, myHero.totalDamage) + getBonusLastHitDamage(minion) + LastHitPassiveDamage()
			--myDamage = (MasteryMenu.Executioner and myDamage * 1.05 or myDamage)
			myDamage = myDamage - 10
			--if minion.health - predictedDamage <= 0 then
					--return getKillableCreep(iteration + 1)
					if minion.health + 1.2 - predictedDamage < myDamage then
						return minion
			--elseif minion.health + 1.2 - predictedDamage < myDamage + (0.5 * predictedDamage) then
			--		return nil
		end
	end
end
return nil
end

function getBonusLastHitDamage(minion)
	if PluginBonusLastHitDamage then 
		return PluginBonusLastHitDamage(minion)
	elseif BonusLastHitDamage then
		return BonusLastHitDamage(minion)
	else
		return 0
	end
end

function meleeLastHit()
	for _, minion in pairs(enemyMinions.objects) do
		local aDmg = getDmg("AD", minion, myHero)
		if _GetDistance(minion) <= (myHero.range + 75) then
			if minion.health < aDmg then
				return minion
			end            
		end
	end
end

function LastHitPassiveDamage(minion)
	local bonus = 0
	if GetInventoryHaveItem(3153) then
		if ValidTarget(minion) then
			bonus = minion.health / 20
			if bonus >= 60 then
				bonus = 60
			end
		end
	end
		--bonus = bonus + (MasteryMenu.Butcher * 2)
		--bonus = (MasteryMenu.Spellblade and bonus + (myHero.ap * 0.05) or 0)
		return bonus
	end

	function getHighestMinion()
		if GetTarget() ~= nil then
			local currentTarget = GetTarget()
			local validTarget = false
			validTarget = ValidTarget(currentTarget, getTrueRange(), TEAM_ENEMY)
			if validTarget and (currentTarget.type == "obj_BarracksDampener" or currentTarget.type == "obj_HQ" or currentTarget.type == "obj_AI_Turret") then
				return currentTarget
			end
		end

		local highestHp = {obj = nil, hp = 0}
		enemyMinions:update()
		for _, tMinion in pairs(enemyMinions.objects) do
			if _GetDistance(tMinion) <= getTrueRange() and tMinion.health > highestHp.hp then
				highestHp = {obj = tMinion, hp = tMinion.health}
			end
		end
		return highestHp.obj
	end

	function getPredictedDamageOnMinion(minion)
		local predictedDamage = 0
		if minion ~= nil then
			local distanceToMinion = _GetDistance(minion)
			if distanceToMinion < getTrueRange() then
				for l, attack in pairs(incomingDamage) do
					predictedDamage = predictedDamage + getPredictedDamage(l, minion, attack)
				end
			end
		end
		return predictedDamage
	end

--return towers table
function GetTowers(team)
	local towers = {}

	for i=1, objManager.maxObjects, 1 do
		local tower = objManager:getObject(i)
		if tower ~= nil and tower.valid and tower.type == "obj_AI_Turret" and tower.visible and tower.team == team then
			table.insert(towers,tower)
		end
	end
	if #towers > 0 then
		return towers
	else
		return false
	end
end

function Autobot:changeStatus(stat)
	if(stat == self.status) then return end
	self.status = stat
	if INIT == stat then
		PrintOnChat(" INIT")
	elseif SETUP == stat then
		PrintOnChat(" SETUP")
	elseif HARRASSING == stat then
		PrintOnChat(" HARRASSING")
	elseif AGGRO == stat then
		PrintOnChat(" AGGRO")
	elseif FARM == stat then
		PrintOnChat(" FARM")
	elseif RUN == stat then
		PrintOnChat(" RUN")
	elseif MOVING == stat then
		PrintOnChat(" MOVING")
	elseif RECALLING == stat then
		PrintOnChat(" RECALLING")
	elseif DEAD == stat then
		PrintOnChat(" DEAD")
	elseif LASTHIT == stat then
		PrintOnChat(" LASTHIT")
	elseif SAFE == stat then
		PrintOnChat(" SAFE")
	elseif OBJECTIVE == stat then
		PrintOnChat(" OBJECTIVE")
	end
end


function TowersByLanes(team)
	local towers = {}
	towers[MID] = {}
	towers[BOTTOM] = {}
	towers[TOP] = {}
	towers[BASE] = {}
	for _,tower in pairs(GetTowers(team)) do
		table.insert(towers[GetLane(tower)],tower)
	end

	local spawn = nil
	if team == myHero.team then spawn = allySpawn elseif team == TEAM_ENEMY then spawn = enemySpawn end
	table.sort(towers[TOP],function(a,b) return _GetDistance(a,spawn) > _GetDistance(b,spawn) end)
	table.sort(towers[MID],function(a,b) return _GetDistance(a,spawn) > _GetDistance(b,spawn) end)
	table.sort(towers[BOTTOM],function(a,b) return _GetDistance(a,spawn) > _GetDistance(b,spawn) end)
	table.sort(towers[BASE],function(a,b) return _GetDistance(a,spawn) > _GetDistance(b,spawn) end)
	return towers
end
--here get close tower
function GetCloseTower(hero, team,safe)
	local towers = GetTowers(team)
	safe = safe or team == myHero.team or true
	if towers and #towers > 0 then
		local candidate = towers[1]
		for i=2, #towers, 1 do

			if (towers[i].health/towers[i].maxHealth > 0.1) and  hero:GetDistance(candidate) > hero:GetDistance(towers[i]) then
				if(safe and ClosestChamp(TEAM_ENEMY,600,towers[i]) == nil) or not safe then
					candidate = towers[i]
				end
			end
		end
		if (candidate.health/candidate.maxHealth > 0.1) and ((safe and ClosestChamp(TEAM_ENEMY,600,candidate) == nil) or not safe)  then
			return candidate
		end
	end

		return nil
end

function ClosestChamp(team, range, unit)
	local champ = {}
	if team == myHero.team then
		champ = allies
	else
		champ = enemies
	end

	unit = unit or myHero

	if #champ > 0 then
		local candidate = champ[1]
		candDist = _GetDistance(unit,candidate)
		for i=3, #champ, 1 do
			local dist = _GetDistance(unit,champ[i])
			if ((dist < range) and (candDist > dist) and not champ[i].dead and unit.networkID ~= champ[i].networkID) then
				candidate = champ[i]
				candDist = dist
			end
		end
		if(candDist < range and not candidate.dead and unit.networkID ~= candidate.networkID) then
			return candidate
		else
			return nil
		end
	else
		return nil
	end
end


function CloseChamp(team, range,unit)
	local champ = {}
	local close = {}
	unit = unit or myHero
	if team == myHero.team then
		champ = allies
	else
		champ = enemies
	end

	if #champ > 0 then

		for i,hero in  pairs(champ) do
			if _GetDistance(hero) <= range and not hero.dead then
				table.insert(close,hero)
			end
		end

	end	
	
	return close 
	
end


--here get minion to follow
function GetFollowedMinion()
	local tower = GetCloseTower(myHero,myHero.team,false)
	allyMinions:update()
	if #allyMinions.objects > 0 then
		local candidate = allyMinions.objects[1]
		for i=2, #allyMinions.objects, 1 do
			if (GetDistance(candidate,allySpawn) < _GetDistance(allyMinions.objects[i],allySpawn)) then candidate = allyMinions.objects[i] end
		end
		return candidate
	else
		return nil
	end
end

function CoordPos(unit,customrange)
	local idPos = {}
	idPos.x = unit.x + math.random((-customrange)/3,(customrange)/3)
	idPos.z = unit.z + math.random((-customrange)/3,(customrange)/3)
	return idPos			
end

--Dummy ATM (only hp)
-- Return true for WIN
-- Return false else
function predictTeamFight()
	local cEnemies,cAllies = CloseChamp(TEAM_ENEMY,1000),CloseChamp(myHero.team,1000)
	local cEnemiesHP,cAlliesHP = 0,0

	for _,e in pairs(cEnemies) do
		cEnemiesHP = cEnemiesHP	+ e.health
	end

	for _,a in pairs(cAllies) do
		cAlliesHP = cAlliesHP	+ a.health
	end

	return   (cAlliesHP * 1.2) - cEnemiesHP

end

function GetLane(unit)
	if(MapPosition:onTopLane(unit)) then
		return TOP
	elseif(MapPosition:onMidLane(unit)) then
		return MID
	elseif(MapPosition:onBotLane(unit)) then
		return BOTTOM
	elseif(MapPosition:inBase(unit)) then
		return BASE
	else
		return JUN
	end
end

function HasSmite(hero)
	if hero:GetSpellData(SUMMONER_1).name == "SummonerSmite" then return true
	elseif hero:GetSpellData(SUMMONER_2).name == "SummonerSmite" then return true
		else return false end
end


function PassiveFollow(unit,SetupFollowDistance)
	follow = {}
	follow.x = ((allySpawn.x - unit.x)/(GetDistance(unit,allySpawn)) * ((SetupFollowDistance - 300) / 2 + 300) + unit.x + math.random(-((SetupFollowDistance-300)/3),((SetupFollowDistance-300)/3)))
	follow.z = ((allySpawn.z - unit.z)/(GetDistance(unit,allySpawn)) * ((SetupFollowDistance - 300) / 2 + 300) + unit.z + math.random(-((SetupFollowDistance-300)/3),((SetupFollowDistance-300)/3)))
	return follow	

end

function Autobot:SetTeamMate(unit)
	if(unit ~= nil and unit ~= self.teamMate and not unit.isMe) then
		self.teamMate = unit
		PrintOnChat("Following "..unit.name)
	end
end

function Autobot:fillAllyLanes()

	for k,c in pairs(allyLanes) do
		if(c.lane == nil and not MapPosition:inBase(c.object.pos) and not c.object.isMe) then --SETUP
			if(HasSmite(c.object)) then
				c.lane = JUN
				allyLanes[k] = {object = c.object , lane = c.lane}
				self.lanes[ALL] = self.lanes[ALL] + 1
				PrintOnChat(self.lanes[ALL]..". Jungler is "..k)
			else
				local tmp = GetLane(c.object) 
				if(c.lane == JUN or tmp == nil) then break end
				c.lane = tmp
				allyLanes[k] = {object = c.object , lane = c.lane}
				table.insert(self.lanes[ tmp ],c.object)
				self.lanes[ALL] = self.lanes[ALL] + 1
				PrintOnChat(self.lanes[ALL]..". "..k.." is in lane "..c.lane)
			end
		end
	end
	return (self.lanes[ALL] == ((heroManager.iCount/2)-1))

end
-- BEGIN

function Autobot:OnWndMsg(msg, key)
	if key == toggleKey and msg == KEY_UP then
		if active then
			PrintOnChat("Position OFF")
			active = false
		else
			PrintOnChat("Position ON")
			active = true
		end
	end
	
end


function Autobot:OnTick()
	aaTarget = self.aaTarget
	followTarget = self.followTarget
	LastHitOnTick()
	iSum:AutoAll()

	AARange = myHero.range + _GetDistance(myHero.minBBox)
	ts.range = AARange
	ts:update()
	iOW.AARange = AARange
	local idPos = {}


	if(self:fillAllyLanes() and self.laneStatus == INIT) then
		PrintOnChat("Teammates scanned")
		self.laneStatus = NEUTRAL
		for k,c in pairs(allyLanes) do
			if(c.lane == self.lane and not c.object.isMe) then
				if(#self.lanes[self.lane] < 2 and self.teamMate == nil) then  -- FOund my TEAMMATE !!
					self:SetTeamMate(c.object)
				else -- Oupss Premade in my self.lane ?
					if(#self.lanes[TOP] > 2 and #self.lanes[MID] == 1) then -- Go top
						self.lane = TOP
						self:SetTeamMate(self.lanes[TOP][1])
					PrintOnChat("Following "..self.teamMate)
					elseif(#self.lanes[MID] == 0 and #self.lanes[TOP] == 2) then -- MID so lonely :'(
						self.lane = MID
						self:SetTeamMate(self.lanes[MID][1])
					else -- f*ck it, go TOP
						self.lane = TOP
						self:SetTeamMate(self.lanes[TOP][1])
					end
				end
			end
		end
	else
		for k,c in pairs(allyLanes) do
			if(c.lane == nil and not c.object.isMe) then
				PrintOnChat(k.." missing")
			end
		end
	end



	if(self.status == SETUP) then
		local all = TowersByLanes(myHero.team)
		local tower = all[self.lane][1]
		if tower == nil then
			self:changeStatus(HARRASSING)
			return
		end

		idPos.x = tower.x
		idPos.z = tower.z
		iOW:Move(idPos)
		if(GetDistance(myHero,idPos) < 600) then
			self:changeStatus(HARRASSING)
		end
		return
	elseif(self.status == RECALLING) then
		if(GetDistance(allySpawn) > 300) then
			CastSpell(11)
		return
		else
			self:changeStatus(SETUP)
		end

	end
	self.aaTarget = nil
	self.followTarget = nil

	local minion = GetFollowedMinion()
	local nextTarget = enemyMinions.objects[1]
	closestEnemy = ClosestChamp(TEAM_ENEMY,500)
	lastHitTarget = getKillableCreep(1)
	self.aaTarget = getHighestMinion()
	local tower = GetCloseTower(myHero,myHero.team,false)
	local eTower = GetCloseTower(myHero,TEAM_ENEMY,false)
	local ally = ClosestChamp(myHero.team,1000)

	local closeAllies = CloseChamp(myHero.team,1100)
	local closeEnemies = CloseChamp(TEAM_ENEMY,1100)
	
	if(eTower ~= nil and _GetDistance(eTower) < getTrueRange(eTower)) then
		self.laneStatus = UNDER_ENEMY_TOWER
	elseif(tower ~= nil and _GetDistance(tower) < getTrueRange(tower)) then
		self.laneStatus = UNDER_ALLY_TOWER
	end

	if(self.teamMate == nil and ally ~= nil) then
		self:SetTeamMate(ally)
	end
	local closeEnemies = CloseChamp(TEAM_ENEMY,1000)
	if(myHero.dead) then return nil end --Dead

	if(self.status < HARRASSING) then -- Skip that

	elseif((myHero.health / myHero.maxHealth < 0.13 and #closeEnemies > 2 * #closeAllies and enemyMinions.iCount > 0)  -- Low HP and Risky position
		--or predictTeamFight() < 0 -- Overall low close ally HP
		) then  
		self:changeStatus(RUN)
		self.followTarget = tower
	elseif(myHero.health / myHero.maxHealth < 0.13 or (myHero.health < 100 and myHero.maxHealth > 1000)) then -- Low HP
		self:changeStatus(RECALLING)
	elseif(lastHitTarget ~= nil and ValidTarget(lastHitTarget)) then-- Last hit possible
		self:changeStatus(LASTHIT)
	elseif(#enemyMinions.objects > 2 and #allyMinions.objects == 0 ) -- Too many enemy minions
		or (#enemyMinions.objects > #allyMinions.objects
			and (closestEnemy ~= nil and myHero.health < closestEnemy.health)) then-- Lane pushed and agressive enemy
		self:changeStatus(SAFE)
	elseif(self.laneStatus == UNDER_ENEMY_TOWER) then
		self:changeStatus(OBJECTIVE)
	elseif(predictTeamFight() >  0)  then -- GO AGGRO
		self:changeStatus(AGGRO)
	elseif(#enemyMinions.objects < #allyMinions.objects and ts.target ~= nil) then -- Pushing self.lane
		self:changeStatus(HARRASSING)
	elseif (#allyMinions.objects - #enemyMinions.objects > 2 and lastHitTarget == nil) then -- Lane pushed
		self:changeStatus(FARM)
	elseif(#allyMinions.objects == 0 and #enemyMinions.objects == 0 and GetLane(myHero) ~= self.lane) then -- Not in self.lane
		self:changeStatus(MOVING)
	else -- unknown situation 
		self:changeStatus(RUN)

	end

	if(self.status < RUN and self.status > SETUP) then
		-- TARGET

		if(self.status == AGGRO) then
			if(self.teamMate ~= nil and not self.teamMate.dead and _GetDistance(self.teamMate) < 1500) then
				self.followTarget = self.teamMate
			elseif(ts.target ~= nil and ValidTarget(ts.target)) then
				self.followTarget = ts.target
			elseif(ally ~= nil and not ally.dead) then
				self.followTarget = ally
			else
				self.followTarget = getHighestMinion()
			end
			if(ts.target ~= nil and ValidTarget(ts.target)) then
				self.aaTarget = ts.target
			end
		elseif(self.status == FARM) then
			if(self.teamMate ~= nil and not self.teamMate.dead and _GetDistance(self.teamMate) < 1500 ) then
				self.followTarget = self.teamMate
			elseif(lastHitTarget ~= nil and ValidTarget(lastHitTarget)) then
				self.followTarget = lastHitTarget
			elseif(nextTarget ~= nil and ValidTarget(nextTarget)) then
				self.followTarget = nextTarget
			elseif(ally ~= nil and not ally.dead) then
				self.followTarget = ally
			else
				self.followTarget = getHighestMinion()
			end

			local highestHp = getHighestMinion()
			if(highestHp ~= nil and ValidTarget(highestHp)) then
				self.aaTarget = highestHp
			end
		elseif(self.status == SAFE) then
			if(self.teamMate ~= nil and not self.teamMate.dead and _GetDistance(self.teamMate) < 1500 ) then
				self.followTarget = self.teamMate
			elseif(#allyMinions.objects == 0 and closestEnemy == nil) then
				local allyTowers = TowersByLanes(myHero.team)
				if(#allyTowers[self.lane] > 0) then
					self.followTarget = allyTowers[self.lane][1]
				elseif(#allyLanes[BASE] > 0) then
					self.followTarget = allyTowers[BASE][1]
				else
					self.followTarget = allySpawn
				end
			elseif(closestEnemy ~= nil) then
				self:changeStatus(RUN)
			end

		elseif(self.status == LASTHIT) then
			local highestHp = getHighestMinion()
			if(self.teamMate ~= nil and not self.teamMate.dead and _GetDistance(self.teamMate) < 1500 ) then
				self.followTarget = self.teamMate
			elseif(lastHitTarget ~= nil and ValidTarget(lastHitTarget)) then
				self.followTarget = lastHitTarget
			elseif(highestHp ~= nil and ValidTarget(highestHp)) then
				self.followTarget = highestHp
			end
			if(lastHitTarget ~= nil and ValidTarget(lastHitTarget)) then
				self.aaTarget = lastHitTarget
			end
		elseif(self.status == OBJECTIVE) then
			if(self.teamMate ~= nil and not self.teamMate.dead and _GetDistance(self.teamMate) < 1500 ) then
				self.followTarget = self.teamMate
			elseif(lastHitTarget ~= nil and ValidTarget(lastHitTarget)) then
				self.followTarget = lastHitTarget
			elseif(nextTarget ~= nil and ValidTarget(nextTarget)) then
				self.followTarget = nextTarget
			elseif(ally ~= nil) then
				self.followTarget = ally
			else
				self.followTarget = getHighestMinion()
			end

			self.aaTarget = eTower

		end

		if self.aaTarget ~= nil and ValidTarget(self.aaTarget)  and self.followTarget ~= nil then
			if(GetDistance(self.followTarget) > getTrueRange()) then
				idPos = PassiveFollow(self.followTarget,400)
				iOW:Move(idPos)
			else
				iOW:Orbwalk(self.followTarget,self.aaTarget)
			end
		elseif(self.followTarget ~= nil) then
			if(GetDistance(self.followTarget) > 500) then
				idPos = PassiveFollow(self.followTarget,400)
				iOW:Move(idPos)
			end
		end
	end
	if(self.status == MOVING) then
		local friend = ClosestChamp(myHero.team,20000) 
		if(self.teamMate ~= nil and not self.teamMate.dead and GetLane(self.teamMate) ~= BASE) then
			self.followTarget = self.teamMate
		else
			local tow = TowersByLanes(myHero.team)
			local tu  = nil
			if(#tow[self.lane] > 0) then
				tu = tow[self.lane][1]
			elseif(#tow[BASE] > 0) then
				tu = tow[BASE][1]
			else
				tu = allySpawn
			end
			
			self.followTarget = tu
	    end
	    iOW:Move(PassiveFollow(self.followTarget,500))

	elseif(self.status == RUN) then
			safeTower = GetCloseTower(myHero,myHero.team,true)
			self.followTarget = safeTower
			iOW:Move(safeTower)
	elseif(self.status == RECALLING) then
		CastSpell(RECALL)
		-- iOW:Move(allySpawn.pos)
	end

	if(active) then
		CastSpell(RECALLING)
		PrintOnChat("pos.x : "..myHero.pos.x.." | pox.z ; "..myHero.pos.z)
		active = false
	end
end
	function Autobot:OnLoad()
		LastHitOnLoad()
		fillTeams()
		local currentLane = GetLane(myHero)
		if( currentLane~= self.lane and currentLane ~= JUN and currentLane ~= nil and currentLane ~= BASE) then
			self.lane = currentLane
		end
		for i = 1, heroManager.iCount, 1 do
			local candidate = heroManager:getHero(i)
			if candidate ~= nil or candidate.valid == true then
				candidate.lane = nil 
				if candidate.team == myHero.team then
					allyLanes[candidate.name] = {object = candidate, lane = nil}
				elseif candidate.team == TEAM_ENEMY then enemyLanes[candidate.name] =  {object = candidate, lane = nil}end
				end
			end


			AutoBotConfig = scriptConfig("AutoBot", "autobot")
			if not isMelee then
				ChampInfo = getChampTable()[myHero.charName]
				projSpeed = ChampInfo.projSpeed
			end
		-- numerate spawn
		for i=1, objManager.maxObjects, 1 do
			local candidate = objManager:getObject(i)
			if candidate ~= nil and candidate.valid and candidate.type == "obj_SpawnPoint" then 
				if candidate.x < 3000 then 
					if player.team == TEAM_BLUE then allySpawn = candidate else enemySpawn = candidate end
				else 
					if player.team == TEAM_BLUE then enemySpawn = candidate else allySpawn = candidate end
				end
			end
		end
		self:changeStatus(SETUP)
		iOW:addAA("attack")
		PrintChat(ProgramName.."  v"..tostring(version).." initialized.")
		mapPosition = MapPosition()

		PrintOnChat("MapPosition loaded")

	end

	function Autobot:OnProcessSpell(unit,spell)
		LastHitOnProcessSpell(unit,spell)
		if(self.teamMate ~= nil and unit.networkID == self.teamMate.networkID ) then
			self:changeStatus(AGGRO)
		end
		iOW:OnProcessSpell(unit, spell)
	end

	function Autobot:OnDraw()
		LastHitOnDraw()
	end