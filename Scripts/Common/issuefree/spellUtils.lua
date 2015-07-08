require "issuefree/basicUtils"
require "issuefree/items"
require "issuefree/persist"
require "issuefree/telemetry"
-- require "issuefree/walls"

--[[
spells["alias"] = {
   name="spellCastName",      -- this is used for ICast. If the spell reports casting as GetSpellInfo("X").name then this can be left blank.
                                 if you need to detect the spell under a different name put that name here

   key="Q",                   -- the key that casts the spell. If no key is supplied then the spell will always read "ready"
   range=1175,                -- range of the spell
   rangeType="e2e",				-- if the spell is ranged edge to edge like auto attacks
   color=violet,              -- color of the range circle

      Most fields are passed through GetLVal which will handle a few ways of specifying a value:
         a number - is just a number
         a list - this is a value per spell level so {5,10,15} will be 5 if the spell is level 1, 10 if the spell is level 2 etc.
         a function - this function will be executed at evaluation time and must return a number. the variable "target" will be passed into the function if it is needed

   base={60,110,160,210,260}, -- base spell damage
   <stat>=.7,                 -- scaling. Scaling is a scalar i.e. damage bonus is stat*scaling
      ap,                  -- ap
      ad,                  -- ad
      adBonus,             -- bonus ad
      adBase,              -- base ad
      mana,                -- current mana
      maxMana,             -- maximum mana
      health,              -- current health
      maxHealth,           -- maximum health
      armor,               -- character armor
      lvl,                 -- character level (not spell level)
      targetMaxHealth,     -- target's maximum health
      targetMaxHealthAP,   -- extra damage scaling against target max health based on AP.
      targetHealth,        -- target's current health
      targetHealthAP,      -- extra damage scaling against target current health based on AP.
      targetMissingHealth, -- scales against maxHealth - health

   bonus,                     -- a non scaling value added to the damage. often a function for handling non standard damage modifiers
   damOnTarget,               -- a function that gets passed in the target and returns a number
                                    usually this is for modifying the spell damage based on some property of the target
                                    like akali's mark or katarina's dagger
   scale,                     -- scale the WHOLE spell damage by this. For things like "spell does 60% damage vs minions" or "spell does double damage if the target is full health"
   type,                      -- "P" for physical, "M" for magical, "T" for true, "H" for heal. Defaults to "M"

   -- auto attack modifier spells
   modAA=<alias>,             -- trigger for this spell being an autoattack modifier. Should be set to the "alias" of the spell
   object="object.name",  -- required for modAA to work. This should be a substring that matches the object.name of the buff this spell applies   
   -- reset=true,                -- casting this resets auto attack timer

   onHit=true,                -- set to true if this spell triggers on hit affects e.g. gangplank Q

   knockback=400,             -- if the spell has knockback this is how far it knocks them back

   -- skill shots
   delay=.2,                   -- delay between casting and the missile firing, must be set for skillshots
   speed=1200,                  -- speed of the missile, must be set for skillshots, 0 means it doesn't travel
   width=80,                  -- width of the missile for linear skill shots
   radius=150,                -- radius of the affect, usually for nonlinear skill shots
      -- usually you only use width or radius not both
   noblock=true,              -- set if the skillshot passes through objects
   overShoot=150,             -- if you want the point of impact to be past the target then set this.
   

   -- channelling
   channel=true,              -- if the spell is channelled (e.g. fiddle's drain). If set up it will detect the channel and the bot won't break the channel
   object="object.name",  -- this is the object to detect while channelling. As long as this object exists the bot won't interrupt
   objectTimeout=.5,          -- if the channelling object is transient you can specify a timeout here.
                                 katarina's ult needs this as the channelling object comes and goes

   manualCooldown=10,         -- if LB cooldown is bugged this will manually manage the cooldown

   extraCooldown=.5,          -- waits a little longer after cooldown to report a spell ready

   -- spells that use charges
   useCharges=true,           -- this spell requires charges to cast
   maxCharges=7,              -- max charges
   rechargeTime={12,10,8},    -- time to generate a charge, 0 means never
   charges=4,                 -- starting charges, defaults to 0

   cost={10,20,30,40,50}      -- cost of the spell (usually in mana) this is ignored for now as LB handles it. Optional.
} 

]]



-- require 'yprediction'
-- local YP = YPrediction()

-- common spell defs
spells = {}

local iSpells = {
   Q = _Q,
   W = _W,
   E = _E,
   R = _R,
   D = SUMMONER_1,
   F = SUMMONER_2,
}
iSpells["1"] = ITEM_1
iSpells["2"] = ITEM_2
iSpells["3"] = ITEM_3
iSpells["4"] = ITEM_4
iSpells["5"] = ITEM_5
iSpells["6"] = ITEM_6
iSpells["7"] = ITEM_7


function getISpell(key)
   return iSpells[tostring(key)]
end

function GetSpellLevel(key, hero)
   hero = hero or me
   local spellInfo = GetSpellInfo(key)
   if spellInfo then
      return spellInfo.level
   else
      return 0
   end
end

function IsCooledDown(thing, hero)
	hero = hero or me

	local spell = GetSpell(thing)

	local key = spell.key
	if not key then return false end	

	if spell.manualCooldown and spell.lastCast then
		local cd = GetLVal(spell, "manualCooldown") * (1+me.cdr)
		if time() - spell.lastCast >= cd then
			return true
		else
			return false
		end
	end


   return hero:GetSpellData(getISpell(tostring(key))).currentCd == 0
end


function GetCD(thing, hero)
   hero = hero or me
   local spell = GetSpell(thing)

	if spell.manualCooldown then
      if not spell.lastCast then
         return 0
      end
		local cd = GetLVal(spell, "manualCooldown") * (1+me.cdr)
		return math.max(0, cd - (time() - spell.lastCast))
	end

   local cd
   if spell.id then -- item
      cd = GetSpellInfo(tostring(GetInventorySlot(spell.id))).currentCd
   else
      cd = GetSpellInfo(spell.key).currentCd
   end
   if cd > 0 then
      return cd
   end
   return 0
end

function CastSpellTarget(slot, target)
   CastSpell(getISpell(slot), target)
end

function Cast(thing, target, force)
   local spell = GetSpell(thing)
   spell = spell or thing

   if not force and not CanUse(spell) then
      -- pp("can't use "..spell.key)
      -- pp(debug.traceback())
      return false
   end

   if not target then 
      pp("no target for "..spell.key)
      return false
   end

   if IsSkillShot(spell) and not IsMe(target) then
   	CastFireahead(spell, target)
   else
   	if spell.id then
   		local slot = GetInventorySlot(spell.id)
   		CastSpell(getISpell(slot), target)
   	else
   		CastSpell(getISpell(spell.key), target)
   	end
   end
   return true
end

function CastXYZ(thing, x,y,z)
   local spell = GetSpell(thing)
   if not spell then return end
   local p
   if type(x) == "number" then
      p = Point(x,y,z)
   else
      p = Point(x)
   end
   CastSpell(getISpell(spell.key), p.x, p.z)
end

-- local sx, sy
-- function CastClick(thing, x,y,z)
--    local spell = GetSpell(thing)
--    if not spell then return end
   
--    local p = Point(x,y,z)

--    if IsLoLActive() and IsChatOpen() == 0 then
--       if sx == nil then
--          sx = GetCursorX()
--          sy = GetCursorY()
--       end
--       ClickSpellXYZ(spell.key, p.x, p.y, p.z, 0)
--       DoIn(
--          function() 
--             if sx then 
--                send.mouse_move(sx, sy) 
--                sx = nil
--                sy = nil
--             end
--          end, 
--          .1 
--       )
--    end
-- end

function CastBuff(spell, switch)
   if CanUse(spell) then
      if P[spell] and switch == false then
         Cast(spell, me)
         P[spell] = nil
         PrintAction(spell.." OFF")
         return
      end
      if not P[spell] and switch ~= false then
         Cast(spell, me)
         PersistTemp(spell, .5)
         PrintAction(spell.." ON")
         return
      end
   end
end

function CastFireahead(thing, target)
   if not target then return false end

   local spell = GetSpell(thing)
   if not spell.speed then spell.speed = 2000 end
   if not spell.delay then spell.delay = .25 end

   local point = GetSpellFireahead(spell, target)
   if spell.overShoot then
      point = OverShoot(me, point, spell.overShoot)
   end   
   if GetDistance(point) < GetSpellRange(spell) then
      if IsWall(D3DXVECTOR3(point.x, point.y, point.z))  then
	   	local name = thing
	   	if type(name) ~= "string" then
	   		name = GetSpellInfo(spell.key).name
	   	end
         pp("Casting "..name.." into wall.")
      end
      CastXYZ(spell, point)
      return true
   end

   return false
end

function GetReachPoint(thing, target)
	local range = GetSpellRange(thing)
	if GetDistance(target) > range then
		return Projection(me, target, range)
	else
		return Point(target)
	end
end


function CanUse(thing)
   if type(thing) == "table" then -- spell or item
      -- if thing.name == "attack" then
      --    return CanAttack()
      -- end
      if thing.id then -- item
         return IsCooledDown(GetInventorySlot(thing.id))
      elseif thing.key then -- spell
      	if not ListContains(thing.key, {"Q","W","E","R","D","F"}) then
      		return false
      	end
         -- looks like there's a rounding error or something in the getspellcost.
         if thing.key == "D" or thing.key == "F" or ( GetSpellLevel(thing.key) > 0 and me.mana >= GetSpellCost(thing) ) then
         	if not GetLVal(thing, "canCast") then
         		return false
         	end
         	if P.silence then
         		return false
         	end
            if thing.useCharges and thing.charges == 0 then
               return false
            end

            return me:CanUseSpell(getISpell(thing.key)) == 0
            -- return IsCooledDown(thing)
         else
            return false
         end
      else  -- spells without keys are always ready
         return true
      end
   elseif type(thing) == "number" then -- item id
      return IsCooledDown(GetInventorySlot(thing))
   else -- string
      if thing == "AA" then
         return CanAttack()
      end
      if spells[thing] then -- passed in the name of a spell
         if spells[thing].key then
            return CanUse(spells[thing])
         else
            return true -- a defined spell without a key prob auto attack
         end
      elseif ITEMS[thing] then  -- passed in the name of an item
         return IsCooledDown(GetInventorySlot(ITEMS[thing].id))
      else -- other string must be a slot
         if thing == "D" or thing == "F" then
            return IsCooledDown(thing)
         end
         if #thing > 1 then -- spell keys are single charactes so I don't know what you passed in
            return false
         end
         return CanUse(GetSpell(thing))
         -- return GetSpellLevel(thing) > 0 and IsCooledDown(thing) -- should be a spell key "Q"
      end
   end
   pp("Failed to get spell for "..thing)
end

function GetSpellCost(thing)
   local spell = GetSpell(thing)
   if spell.cost then
      return GetLVal(spell, "cost")
   end
   if spell.key then
      return math.floor(GetSpellInfo(spell).mana)
   end
   return 0 -- if it doesn't have a cost assigned or have a key then it's probably an item or AA
end

function GetSpellCostPerc(thing)
	return GetSpellCost(thing) / (me.mana+(me.mpRegen*25))
end

function GetSpellRange(thing)
   return GetLVal(GetSpell(thing), "range") + GetLVal(GetSpell(thing), "extraRange")
end

function GetSpellName(thing)
	local spell = GetSpell(thing)

	if spell.name then return spell.name end

	for name, s in pairs(spells) do
		if spell == s then
			return name
		end
	end

end

-- spell.name
-- spell.level
-- spell.mana
-- spell.cd
-- spell.currentCd
-- spell.range
-- spell.channelDuration
-- spell.startPos -- only for spellProc
-- spell.endPos -- only for spellProc

function GetSpellInfo(thing, hero)
   local spell = GetSpell(thing)
   local key = spell.key
   key = key or thing

   hero = hero or me
   local iSpell = getISpell(spell.key)
   if iSpell then
      return hero:GetSpellData(iSpell)
   else
      pp(debug.trackback())
      pp(thing)
      return nil
   end
end

function GetSpell(thing)
   local spell
   if type(thing) == "table" then
      spell = thing
   else
      if type(thing) == "string" and #thing == 1 then
         for _,spell in pairs(spells) do
            if spell.key == thing then
            	return spell
            end
         end
      else
         spell = spells[thing]
      end
      if not spell then
         for _,spell in pairs(spells) do
            if thing == spell.key then
               return spell
            end
         end
      end
		if not spell then
			spell = ITEMS[thing]
		end
      -- couldn't find a defined spell.
      -- make a fake spell with the thing as the key as this is almost certainly
      -- an item or a summoner spell
      if not spell then 
         spell = {key=thing}         
      end
   end
   return spell
end

function GetLVal(spell, field, target)
	if not spell[field] then return 0 end

   if type(spell[field]) == "number" then
      return spell[field]
   end

   if type(spell[field]) == "function" then   	
   	return spell[field](target)
   end

   if spell[field].isDamage then
      return spell[field]
   end

   local lvl = 1
   if spell.key then
      lvl = GetSpellLevel(spell.key)
      if lvl == 0 then
         lvl = 1
      end
   end

   local val = spell[field][lvl]

   if val == nil then val = 0 end
   
   return val
end

function GetSpellDamage(thing, target, ignoreResists)
   local spell = GetSpell(thing)
   if not spell or not spell.base then
      return 0
   end

   local lvl 
   if spell.key and not (spell.key == "D" or spell.key == "F") then
      lvl = GetSpellLevel(spell.key)
      if lvl == 0 then
         return 0
      end
   else 
      lvl = 1
   end

   local damage = 0

   if spell.modAA and P[spell.modAA] then -- if the mod is on then the damage should already be in the AA
		return GetAADamage()
   end

   damage = damage + Damage(GetLVal(spell, "base", target), spell.type or "M")
   damage = damage + GetLVal(spell, "ap", target)*me.ap
   damage = damage + GetLVal(spell, "ad", target)*me.totalDamage
   damage = damage + GetLVal(spell, "adBonus", target)*me.addDamage
   damage = damage + GetLVal(spell, "adBase", target)*me.damage
   damage = damage + GetLVal(spell, "mana", target)*me.mana
   damage = damage + GetLVal(spell, "maxMana", target)*me.maxMana
   damage = damage + GetLVal(spell, "health", target)*me.health
   damage = damage + GetLVal(spell, "maxHealth", target)*me.maxHealth
   damage = damage + GetLVal(spell, "armor", target)*me.armor
   damage = damage + GetLVal(spell, "lvl", target)*me.level
   damage = damage + GetLVal(spell, "bonus", target)
   if target then
      local targetMaxHealth = GetLVal(spell, "targetMaxHealth", target)
      targetMaxHealth = targetMaxHealth + GetLVal(spell, "targetMaxHealthAP", target)*me.ap
      damage = damage + targetMaxHealth*target.maxHealth
   end
   if target then
      local targetHealth = GetLVal(spell, "targetHealth", target)
      targetHealth = targetHealth + GetLVal(spell, "targetHealthAP", target)*me.ap
      damage = damage + targetHealth*target.health
   end
   if target then
      damage = damage + GetLVal(spell, "targetMissingHealth", target)*(target.maxHealth - target.health)
   end

   if spell.damOnTarget and target then
      damage = damage + spell.damOnTarget(target)
   end

   if spell.scale then
   	local scale = GetLVal(spell, "scale", target)
   	if scale then
   		damage = damage * scale
   	end
   end

   if type(damage) ~= "number" and damage.type ~= "H" then
      local mult = 1
      if HasMastery("havoc") then
         mult = mult + .03
      end
      if HasMastery("des") then
         mult = mult + .015
      end
      -- if target and HasMastery("executioner") then
      --    if target and GetHPerc(target) < .5 then
      --       mult = mult + .05
      --    end
      -- end
      damage = damage*mult
   end

   -- this is technically not right. This should only count for SINGLE TARGETS
   -- it would be good to fix but I don't think it will cause a problem as aoe
   -- attacks don't generally rely on super accurate damage calculations as people who use
   -- a lot of AoE don't get muramana ;)
   if P.muramana then
      damage = damage + Damage(me.mana*.06, "P")
   end

   -- damage for modAA shouldn't be used without combingin with AA damage.
   -- add spellblade if it's not on to account for it's activation.
   -- if it's on AA will account for it so don't add it.
   if spell.modAA and not P[spell.modAA] then
   	-- if the mod is off then add the aa damage here
   	damage = damage + GetAADamage() + GetSpellbladeDamage(false) - GetSpellbladeDamage(true)
   end

   if spell.offModAA then
   	damage = damage + GetSpellbladeDamage(false) - GetSpellbladeDamage(true)
   end

   if spell.onHit then
      damage = damage + GetOnHitDamage(target, false)
   end

   if target then
      if HasBuff("dfg", target) then
         damage.m = damage.m*1.2
      end
      if HasBuff("hemoplague", target) then
         damage.m = damage.m*1.12
      end
      if not ignoreResists then
      	damage = CalculateDamage(target, damage)
      end
   end


   if type(damage) ~= "number" and damage.type == "H" then
      damage = damage:toNum()
   end

   return damage
end

-- if you specify a target you get % health damage
-- if needSpellbladeActive is true check for sheen ready (for activated on hit abilities)
-- if needSpellbladeActive is nil or false it only adds sheen if it's already on
function GetOnHitDamage(target, needSpellbladeActive) -- gives your onhit damage broken down by magic,phys
   local damage = Damage()

   if GetInventorySlot(ITEMS["Nashor's Tooth"].id) then
      damage = damage + GetSpellDamage(ITEMS["Nashor's Tooth"])
   end
   if GetInventorySlot(ITEMS["Wit's End"].id) then
      damage = damage + GetSpellDamage(ITEMS["Wit's End"])
   end

   damage = damage + GetSpellbladeDamage(needSpellbladeActive)

	if GetInventorySlot(ITEMS["Feral Flare"].id) then
      damage = damage + GetSpellDamage(ITEMS["Feral Flare"])
   end

   if target then
	   if GetInventorySlot(ITEMS["Blade of the Ruined King"].id) then
         damage = damage + Damage(target.health*.08, "P")
	   end

	   if GetInventorySlot(ITEMS["Kitae's Bloodrazor"].id) then
         damage = damage + Damage(target.maxHealth*.025, "M")
	   end

   	if GetInventorySlot(ITEMS["Feral Flare"].id) then
         if IsCreep(target) or IsMinion(target) then
         	damage = damage + GetSpellDamage(ITEMS["Feral Flare"])*2
         end
      end

	   if IsCreep(target) then
	   	if GetInventorySlot(ITEMS["Madred's Razors"].id) then
	         damage = damage + GetSpellDamage(ITEMS["Madred's Razors"])
	      end
	   	if GetInventorySlot(ITEMS["Wriggle's Lantern"].id) then
	         damage = damage + GetSpellDamage(ITEMS["Wriggle's Lantern"])
	      end
		end
   end


   return damage
end

-- treating all as phys as it's so much easier
function GetSpellbladeDamage(needActive)
   return getSBDam(ITEMS["Lich Bane"], P.lichbane, needActive) +
          getSBDam(ITEMS["Trinity Force"], P.enrage, needActive) +
          getSBDam(ITEMS["Iceborn Gauntlet"], P.iceborn, needActive) +
          getSBDam(ITEMS["Sheen"], P.enrage, needActive)
end

function getSBDam(item, buff, needActive)
   local slot = GetInventorySlot(item.id)
   if slot then
      if buff or (not needActive and CanUse(item)) then
         return GetSpellDamage(item)
      end
   end
   return Damage()
end

function GetKnockback(thing, source, target)
   local spell = GetSpell(thing)
   local a = target.x - source.x
   local b = target.z - source.z 
   
   local angle = math.atan(a/b)
   
   if b < 0 then
      angle = angle+math.pi
   end

   return ProjectionA(target, angle, GetLVal(spell, "knockback"))
end

local trackTime = .75
tfas = {}
function TrackSpellFireahead(thing, target)
   local spell = GetSpell(thing)   
   local key = spell.key
   local tcn = target.charName

   if not tfas[key] then
      tfas[key] = {}
   end
   if not IsValid(target) or not tfas[key][tcn] then
      tfas[key][tcn] = {}
   end
   local p = VP:GetPredictedPos(target, spell.delay, spell.speed)
   p = Point(p) - Point(target)
   p.y = 0
   table.insert(tfas[key][tcn], p)

   local trackTicks = trackTime/TICK_DELAY
   if #tfas[key][tcn] > trackTicks then
      table.remove(tfas[key][tcn], 1)
   end
end

function GetSpellFireahead(thing, target, source)
   local spell = GetSpell(thing)

   source = source or me

   local point, chance
	if IsPointAoE(spell) then
      point, chance = VP:GetCircularCastPosition(target, spell.delay, spell.radius, GetSpellRange(spell), spell.speed, source, IsBlockedSkillShot(thing))
   elseif IsConeAoE(spell) then
      point, chance = VP:GetConeAOECastPosition(target, spell.delay, spell.cone, GetSpellRange(spell), spell.speed, source)
	else --   if IsLinearSkillShot(spell) then
      point, chance = VP:GetLineCastPosition(target, spell.delay, spell.width/2, GetSpellRange(spell), spell.speed, source, IsBlockedSkillShot(thing))
   end
   return point, chance
end

function GetFireaheads(thing, targets)
   local fas = {}
   for _,target in ipairs(targets) do
      local fa = GetSpellFireahead(thing, target)
      fa.unit = target
      table.insert(fas, fa)
   end
   return fas
end

function IsGoodFireahead(thing, target, minChance)
	-- PrintAction("SS", target.name)
   local spell = GetSpell(thing)
   if not IsValid(target) and not IsImmune(thing, target) then return false end   
    -- check for "goodness". I'm testing good is when the tfas are all the same (or similar)
    -- this should imply that the target is moving steadily.

   local point, chance = GetSpellFireahead(spell, target)

   point.name = target.name -- hack for IsBlocked I think
   local range = GetSpellRange(spell) + (spell.radius or 0)

   if GetDistance(point) > range then
   	-- PrintAction("SS oor")
      return false
   end

   -- - -1: Collision detected.
   -- - 0: No waypoints found for the target, returning target current position
   -- - 1: Low hitchance to hit the target
   -- - 2: High hitchance to hit the target
   -- - 3: Target too slowed or/and too close , (~100% hit chance)
   -- - 4: Target inmmobile, (~100% hit chace)
   -- - 5: Target dashing or blinking. (~100% hit chance)

   if not minChance then
      if GetMPerc() > .66 then
         minChance = 1
      else
         minChance = 2
      end
   end

   if chance < minChance then
   	-- PrintAction("Low chance SS")
   	return false
   end

   local blockers = concat(MINIONS, ENEMIES, PETS)
   blockers = RemoveFromList(blockers, {target})
   if not spell.noblock and IsBlocked(point, thing, me, blockers) then
   	-- PrintAction("SS blocked")
 		return false
   end

   if spell.overShoot then
      point = OverShoot(me, point, spell.overShoot)
   end

   -- TODO do something better!
   if IsWall(Point(point):vector()) then -- don't shoot into walls
   	-- PrintAction("Don't shoot into walls")
      return false
   end

   -- if the target is at the edge of range and they're the closest enemy then do something different
   if GetDistance(point) > range*.8 then
   	if GetDistance(SortByDistance(ENEMIES)[1]) <= GetDistance(target) then
   		-- pp("SS target alone at edge of range")
   		return false
   	end
   end

	return true
end

function GetGoodFireaheads(thing, minChance, ...)
   return FilterList(
      concat(...), 
      function(item)
         return IsGoodFireahead(thing, item, minChance)
      end
   )
end

function ICast(thing, unit, spell)
   if not IsMe(unit) then return false end
   local mySpell = GetSpell(thing)
   if type(mySpell) ~= "table" or
   	( mySpell.key and ( #mySpell.key > 1 and mySpell.key ~= "--") )
   then -- hack for if getspell fails
      return find(spell.name, thing)      
   else
      if mySpell.name then
         return find(spell.name, mySpell.name)
      elseif mySpell.key then
         local spellInfo = GetSpellInfo(thing)
         if spellInfo then
            return spell.name == spellInfo.name
         end
      end
   end
end

function IsSkillShot(thing)
	local spell = GetSpell(thing)
	if not spell then return false end

	return spell.speed and spell.delay 
end

function IsLinearSkillShot(thing)
	local spell = GetSpell(thing)
	if not spell then return false end

	return spell.delay and spell.speed and spell.speed > 0
end

function IsBlockedSkillShot(thing)
	local spell = GetSpell(thing)
	if not spell then return false end

	return IsLinearSkillShot(thing) and not spell.noblock
end

function IsPointAoE(thing)
	local spell = GetSpell(thing)
	if not spell then return false end

	return spell.radius and spell.noblock
end

function IsLineAoE(thing)
	local spell = GetSpell(thing)
	if not spell then return false end

	return spell.width and spell.noblock
end

function IsConeAoE(thing)
	local spell = GetSpell(thing)
	if not spell then return false end

	return spell.cone
end

function DrawCone(source, angle, arc, dist)
   local a1 = angle - arc/2
   local a2 = angle + arc/2
   local p1 = ProjectionA(source, a1, dist)
   local p2 = ProjectionA(source, a2, dist)
   LineBetween(source, p1)
   LineBetween(source, p2)
end

function DrawSpellCone(thing)
	local spell = GetSpell(thing)

	local a = AngleBetween(me, mousePos)
   local a1 = a - DegsToRads(spell.cone)/2
   local a2 = a + DegsToRads(spell.cone)/2
   local p1 = ProjectionA(me, a1, GetSpellRange(thing))
   local p2 = ProjectionA(me, a2, GetSpellRange(thing))
   LineBetween(me, p1)
   LineBetween(me, p2)
end

function DrawReticle(thing)
	local spell = GetSpell(thing)
	if spell.cone then
		DrawSpellCone(spell)
	elseif spell.delay or spell.radius then
		if spell.speed and spell.speed > 0 then
			LineBetween(me, mousePos, spell.width)
		end
		Circle(mousePos, spell.radius)
	end
end
