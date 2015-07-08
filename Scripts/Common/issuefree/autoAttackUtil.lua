require "issuefree/basicUtils"
require "issuefree/telemetry"
require "issuefree/spellUtils"

-- The most important thing is to register attack spells. Nothing works if the attack spell isn't
-- picked up. 90% of the time the attack spell is just the default of "attack" something.
-- There may be additional ones especially if the character has attack mod skills.

-- The next most important thing on here is the windup time.
-- This is measured by setting it very low (.1)
-- turning on the debugger (which stops attack after the timeout)
-- and swinging at something. If it stops the attack the windup is too low.
-- Try several attacks. It should never cancel. 
-- Round up a bit as losing .05s is nothing but clipping the attack is bad.

-- The third thing is the min move time. If you send a move command too soon it doesn't work.
-- Get some attack speed (like 1.5 total) and orbwalk. If it misses some move commands, up the minMoveTime.

-- attack range can also need some tweaking. 

-- Particles used to be important but it is all timing based now. May as well throw them in...

      -- Ashe         = { speed = 2000, 
      --                  windupScale = .5, -- how much attack speed affects windup. 0.5 would reduce windup by half as much as normal
      --                  extraRange = 0,
      --                  extraWindup = 0, -- % to slow down windup. .1 means windups take 10% longer than reported
      --                  minMoveTime = 0,
      --                  particles = {"Ashe_Base_BA_mis", "Ashe_Base_Q_mis"},
      --                  attacks = {"attack", "frostarrow"},
      --                  resets={GetSpellInfo("Q").name} },

function GetAARange(target)
   target = target or me
   return target.range + spells["AA"].extraRange
end

function IsMelee(target)
   return GetAARange(target) < 400
end

local minionAAData = {
   basic={
      delay=.400,
   },
   caster={
      delay=.484, speed=650
   },
   mech={
      delay=.365, speed=1200
   },
   turret={
      delay=.150, speed=1200
   },
}

-- local function getAAData()
--    local champData = { 
--       Ahri         = { speed = 1600,
--                        particles = {"Ahri_BasicAttack_mis"} },

--       JarvanIV     = { 
--                        attacks={"JarvanIVBasicAttack"} },

--       Jayce        = { speed = 2200,
--                        particles = {"Jayce_Range_Basic_mis", "Jayce_Range_Basic_Crit"} },


--       Orianna      = { speed = 1400,
--                        particles = {"OrianaBasicAttack_mis", "OrianaBasicAttack_tar"} },

--       Quinn        = { speed = 1850,  --Quinn's critical attack has the same particle name as his basic attack.
--                        particles = {"Quinn_basicattack_mis", "QuinnValor_BasicAttack_01", "QuinnValor_BasicAttack_02", "QuinnValor_BasicAttack_03", "Quinn_W_mis"} },

--       Syndra       = { speed = 1200,
--                        particles = {"Syndra_attack_hit", "Syndra_attack_mis"} },

--       Viktor       = { speed = 2250,
--                        particles = {"ViktorBasicAttack"} },

--       Ziggs        = { speed = 1500,
--                        particles = {"ZiggsBasicAttack_mis", "ZiggsPassive_mis"} },

--    }

--    return champData[me.name] or {}
-- end

function loadAAData()
   spells["AA"].baseAttackSpeed = .625
   spells["AA"].extraRange = 0
   spells["AA"].extraWindup = 0
   spells["AA"].windupScale = .5 -- for safety
   spells["AA"].windupVal = 3
   -- BoL may not have the bug which necessitates the minMoveTime
   spells["AA"].minMoveTime = 0
   spells["AA"].attacks = {"attack"}
   spells["AA"].resets = {}
   spells["AA"].duration = 1/spells["AA"].baseAttackSpeed
   spells["AA"].particles = {}

   -- TODO check for other attack reset items
   spells["AA"].itemResets = {"ItemTiamatCleave"}
end

function InitAAData(data)
   data = data or {}
   spells["AA"] = merge(spells["AA"], data)
end

function getAttackSpeed()
   return me.attackSpeed * spells["AA"].baseAttackSpeed
end

function getBaseAttackSpeed()
   return spells["AA"].baseAttackSpeed
end

function getBonusAttackSpeed()
   return getAttackSpeed() - getBaseAttackSpeed()
end

function getAADuration()
   return 1 / (myHero.attackSpeed * spells["AA"].baseAttackSpeed)
end

function getWindup()
   local effAs = 1+((me.attackSpeed - 1)*spells["AA"].windupScale)
   return (1 / (effAs * spells["AA"].windupVal))*(1+spells["AA"].extraWindup)
end

function OrbWalk()
   CURSOR = Point(mousePos())
   local targets = SortByDistance(GetInRange(me, "AA", MINIONS, CREEPS, ENEMIES))
   if targets[1] and CanAttack() then
      if AA(targets[1]) then
         return true
      end
   elseif CanMove() then
      MoveToCursor()
   end
end

-- InitAAData()
local lastAttack = 0 -- last time I cast an attack
shotFired = true -- have I seen the projectile

-- debug stuff
local attackState = 0
local attackStates = {"canAttack", "isAttacking", "justAttacked", "canAct", "canMove"}
local lastAAState = 0

local lastAADelta = 0

local ignoredObjects = {"Minion", "DrawFX", "issuefree", "Cursor_MoveTo", "Mfx", "yikes", "glow", "XerathIdle", "missile"}
local aaObjects = {}
local aaObjectTime = {}

local testDurs = {}
local testWUs = {}

function AfterAttack()
   -- needMove = true
   -- pp("UNBLOCK")
   if ModuleConfig.aaDebug then
      me:HoldPosition()
   end
end


local aaObj = nil
local aaPos1 = nil
local aaT1 = nil
local aaPosE = nil
local aaTE = nil

local speeds = {}

function aaTick()
   if aaObj and aaObj.valid then
      aaPosE = Point(aaObj)
      aaTE = time()
      PrintState(-5, "OBJ")
      local dist = GetDistance(aaPos1, aaPosE)
      local delta = aaTE - aaT1
      pp(dist / delta)
      table.insert(speeds, dist/delta)
   elseif aaTE then
      local dist = GetDistance(aaPos1, aaPosE)
      local delta = aaTE - aaT1

      table.remove(speeds, 1)
      local avgSpeed = sum(speeds)/#speeds
      pp(dist / delta)

      pp("final "..avgSpeed)
      pp(speeds[1])
      aaObj = nil
      aaPos1 = nil
      aaT1 = nil
      aaPosE = nil
      aaTE = nil
      PrintState(-5, "NOOBJ")
   end

   -- we asked for an attack but it's been longer than the windup and we haven't gotten a shot so we must have clipped or something
   if not shotFired and time() - lastAttack > getWindup() then
      woundUp = true
   end

   if CanAttack() or
      ( IsEnemy(lastAATarget) and time() > lastAttack + getWindup()*2 )
   then
      lastAATarget = nil
   end

   if lastAATarget and find(lastAATarget.name, "Minion") and
      not IsValid(lastAATarget) and 
      time() < lastAttack + (getWindup()/2)
   then
      PrintAction("RESET kia")
      lastAATarget = nil
      ResetAttack()
   end

   if CanAttack() then
      canSendAttacked = true
   end
   if JustAttacked() and canSendAttacked then
      AfterAttack()
      canSendAttacked = false
   end

   if ModuleConfig.aaDebug then
      PrintState(1, "APS:"..trunc(1/getAADuration(),2).."  WU:"..trunc(getWindup(),2) )

      if CanAttack() then
         setAttackState(0)
         PrintState(0, "!")
      end
      if IsAttacking() then
         setAttackState(1)
         PrintState(0, "  -")
      end
      if JustAttacked() then
         setAttackState(2)
         PrintState(0, "    :")
      end
      if CanAct() then
         setAttackState(3)
         PrintState(0, "       )")
      end
      if CanMove() then
         setAttackState(4)
         PrintState(0, "         >")
      end

      PrintState(10, "AA Objects")
      for i,ocn in ipairs(aaObjects) do
         PrintState(10+i, ocn.." "..aaObjectTime[i])
      end
   end

end

function SetAttacking()
   lastAttack = time()
end

function ResetAttack(spell)
   needMove = false
   if ModuleConfig.aaDebug then
      if spell and spell.name then
         PrintAction("Reset", spell.name)
      end
   end
   lastAttack = time() - getAADuration() + getWindup()
end

function CanAttack()
   if P.blind then
      return false
   end
   return time() > (getNextAttackTime() - GetPing()/2) -- or time() < (lastAttack + getWindup()/4)
end

function IsAttacking()
   return time() < lastAttack + getWindup() -- - GetPing()/4
end

function JustAttacked()
   return not IsAttacking() and 
          not CanAttack()
end

function CanAct()
   return not IsAttacking() or
          CanAttack()
end

-- in testing (with teemo) if I moved between attacks I couldn't attack faster than ~.66
-- since "acting" is more important than attacking we can slow down our AA rate
-- to act but not to move.
function CanMove()
   if not spells["AA"].minMoveTime then
      return CanAct()
   end
   -- the goal with this is to not interrupt attack
   -- What I think is happening is I get in range, throw the attack, the target moves out of aa range
   -- the windup time passes, CanMove enables, I chase.
   -- So if I tried to attack an enemy don't try to move until the AA timer resets rather than the windup is over
   if IsEnemy(lastAATarget) and not IsInAARange(lastAATarget) and not shotFired then
      -- pp("don't abort have target "..lastAATarget.name)      
      return false
   end
   if time() - lastAttack > spells["AA"].minMoveTime then
      return CanAct()
   end
   return false
end   

function getNextAttackTime()
   return lastAttack + getAADuration()
end

function setAttackState(state)
   if attackState == 0 and state == 0 then
      -- pp(debug.traceback())
      lastAAState = time()
      return
   end
   if attackState == 0 and state >= 3 then      
      return
   end

   if (state == 0 and attackState > 0) or -- moving to the next attack state
      state > attackState 
   then
      attackState = state

      local delta = time() - lastAAState

      if state == 0 then
         lastAAState = time()
      end

      pp(state.." "..trunc(delta).." "..attackStates[attackState+1])

   end
end

function onObjAA(object)
   if ListContains(object.name, spells["AA"].particles, false) 
      and GetDistance(object) < GetWidth(me)+250
   then
      shotFired = true 

      if time() - lastAttack > 2 then
         -- pp("Got a weird object "..object.name)
      end

      if ModuleConfig.aaDebug then
         local delta = time() - lastAAState         
         pp("AAP: "..trunc(delta).." "..object.name)
         aaObj = object
         aaPos1 = Point(object)
         aaT1 = time()
      end

   end
   if ModuleConfig.aaDebug then
      if object and object.x and object.name and
         GetDistance(object, me) < GetWidth(me)+250 
      then
         if not ListContains(object.name, ignoredObjects) and
            not ListContains(object.name, aaObjects) and
            not ListContains(object.name, spells["AA"].particles, false)
         then         
            if time() - lastAttack < .75 then
               table.insert(aaObjects, object.name)
               table.insert(aaObjectTime, time() - lastAttack)
               pp(object.name)
            end
         end
      end
   end

end

function IAttack(unit, spell)
   if not IsMe(unit) then
      return false
   end

   local spellName = spells["AA"].attacks
   if type(spellName) == "table" then
      if ListContains(spell.name, spellName) then
         return true
      end
   else
      if find(spell.name, spellName) then                       
         return true
      end
   end

   return false
end

function isResetSpell(spell)
   local resetSpells = merge(spells["AA"].resets, spells["AA"].itemResets)
   if ListContains(spell.name, resetSpells, true) then
      if ModuleConfig.aaDebug then
         pp("Reset "..spell.name)
      end
      return true
   end
   return false
end

lastAATarget = nil

function onSpellAA(unit, spell)
   if unit.team == me.team and IsMinion(unit) and GetDistance(unit) < 1000 then
      if spell.target and IsMinion(spell.target) then
         local delay, speed
         if IsBasicMinion(unit) then
            delay = minionAAData.basic.delay
         elseif IsCasterMinion(unit) then
            delay = minionAAData.caster.delay
            speed = minionAAData.caster.speed
         elseif IsBigMinion(unit) then
            delay = minionAAData.mech.delay
            speed = minionAAData.mech.speed  
         end

         if delay then
            AddIncomingDamage(spell.target, unit.totalDamage, GetImpactTime(unit, spell.target, delay, speed))
         end
      end
   end

   if not unit or not IsMe(unit) then
      return false
   end
   
   if isResetSpell(spell) then
      ResetAttack(spell)
   end

   if IAttack(unit, spell) then
      if not spells["AA"].baseAttackSpeed then
         spells["AA"].baseAttackSpeed = 1 / (spell.animationTime * myHero.attackSpeed)
      end
      if not spells["AA"].windupVal then
         spells["AA"].windupVal = 1 / (spell.windUpTime * myHero.attackSpeed)
      end

      if IsValid(spell.target) then
         lastAATarget = spell.target
      end

      -- if I attack a minion and I won't kill it try to find an enemy to hit instead.
      -- if I can't hit an enemy try to hit a minion I could kill instead
      if spell.target and IsMinion(spell.target) then
         if not WillKill("AA", spell.target) then
            local target = GetWeakestEnemy("AA")
            if target then
               if AA(target) then
                  PrintAction("Override AA", target)
               end
            else
               KillMinion("AA")
            end
         else
            AddWillKill(minion, "AA")
         end
      end


      if ModuleConfig.aaDebug then
         local delta = time() - lastAAState
         local tn = "?"
         if spell.target then
            tn = spell.target.charName
         end
         pp("AAS: "..trunc(delta).." "..spell.name.." -> "..tn)

         setAttackState(0)
         lastAADelta = time() - lastAttack
      end

      if BLOCK_FOR_AA and Alone() then
         -- pp("BLOCK")
         -- BlockOrders()
      end

      lastAttack = time()
      shotFired = false
   end
end

AddOnCreate(onObjAA)
AddOnSpell(onSpellAA)

AddOnTick(aaTick, "aaTick")