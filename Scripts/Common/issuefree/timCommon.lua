ModuleConfig = scriptConfig("Module Config", "modules")
require "issuefree/basicUtils"
require "issuefree/spell_shot"
require "issuefree/telemetry"
require "issuefree/drawing"
require "issuefree/items"
require "issuefree/autoAttackUtil"
require "issuefree/persist"
-- require "issuefree/prediction"
require "issuefree/spellUtils"
require "issuefree/toggles"

require "VPrediction"
-- require "issuefree/walls"

-- require "issuefree/champWealth"

loadtime = 999999999999
function OnLoad()
	require("issuefree/champs/"..string.lower(me.charName))
   VP = VPrediction()
   loadtime = time()

   -- if me:GetSpellData(_Q).mana < 5 then
   --    pp("Check mana cost for Q  "..me:GetSpellData(_Q).mana)
   -- end
   -- if me:GetSpellData(_W).mana < 5 then
   --    pp("Check mana cost for W  "..me:GetSpellData(_W).mana)
   -- end
   -- if me:GetSpellData(_E).mana < 5 then
   --    pp("Check mana cost for E  "..me:GetSpellData(_E).mana)
   -- end
   -- if me:GetSpellData(_R).mana < 5 then
   --    pp("Check mana cost for R  "..me:GetSpellData(_R).mana)
   -- end
end

function OnUnload()
	LOG_FILE:close()
end

CREEP_ACTIVE = false

healSpell = {range=700+GetWidth(me), color=green, summoners=true}

if GetSpellInfo("D").name == "SummonerHeal" then
   spells["summonerHeal"] = healSpell
   spells["summonerHeal"].key = "D"
elseif GetSpellInfo("F").name == "SummonerHeal" then
   spells["summonerHeal"] = healSpell
   spells["summonerHeal"].key = "F"
end

spells["AA"] = {
   range=function() return me.range end,
   rangeType="e2e",
   extraRange=0,
   base={0}, 
   ad=1,
   type="P", 
   color=red,
   name="attack"   
}
loadAAData()

MASTERIES = {}
BLOCK_FOR_AA = true
CHAMP_STYLE = nil
function SetChampStyle(style)
   CHAMP_STYLE = style
   if style == "caster" then
      MASTERIES = {"executioner", "havoc", "des"} -- "havoc", "des", -- might not be applied to minions?
      BLOCK_FOR_AA = false
   elseif style == "marksman" then
      MASTERIES = {"executioner", "havoc"} -- "havoc", 
   elseif style == "bruiser" then
   elseif style == "support" then
      BLOCK_FOR_AA = false
   end
end

function HasMastery(mastery)
   return ListContains("havoc", MASTERIES)
end


local lastActions = {}
local lastActionsTimes = {}
local lastAction = nil
local lastActionTime = time()
function PrintAction(str, target, timeout)
   for i,t in rpairs(lastActionsTimes) do
      if time() > t then
         table.remove(lastActions, i)
         table.remove(lastActionsTimes, i)
      end
   end
   if str == nil then 
      lastAction = nil
      return
   end
   if str ~= lastAction and not ListContains(str, lastActions) then
      local ttl = trunc(time() - lastActionTime, 2)
      local out = " # "..str
      if target then
         if type(target) == "string" or
            type(target) == "number"
         then
            out = out.." : "..target
         else
            out = out.." -> "..target.charName
         end
      end
      local spaces = ""
      for i=1, 50-string.len(out), 1 do
         spaces = spaces.." "
      end
      pp(out..spaces.."+"..ttl)
      lastActionTime = time()
      if not timeout then
         lastAction = str
      else      
         table.insert(lastActions, str)
         table.insert(lastActionsTimes, time()+timeout)
      end
   end
end

LOADING = true

ACTIVE_SKILL_SHOTS = {}
function addSkillShot(spellShot)
   table.insert(ACTIVE_SKILL_SHOTS, spellShot)
end

local function OnKey(msg, key)
   if msg == WM_LBUTTONUP then
      MarkTarget()
   end
end

KEY_CALLBACKS = {}
function AddOnKey(callback)
   table.insert(KEY_CALLBACKS, callback)
end
AddOnKey(OnKey)

-- globals for convenience
hotKey = 18
playerTeam = ""


CHAR_SPELLS = {}

HOME = nil

repeat
   if string.format(me.team) == "100" then
      playerTeam = "Blue"
      HOME = {x=27, z=265}
   elseif string.format(me.team) == "200" then  
      playerTeam = "Red"
      HOME = {x=13923, z=14169}
   end
until playerTeam ~= nil and playerTeam ~= "0"

local wall = {}

-- for line in io.lines("walls4.txt") do
--    for x, z in string.gmatch(line, "(%d+)%.*%d*, (%d+)%.*%d*") do
--       table.insert(wall, Point(x, 0, z))
--    end
-- end

local function drawCommon()
   -- DrawHeroWealth()

   if me.dead then
      return
   end

   for i=1,#wall-1,1 do
      if GetDistance(wall[i], wall[i+1]) < 250 then
         LineBetween(wall[i], wall[i+1])
      end
   end

   for _,turret in ipairs(TURRETS) do
      Circle(turret, 900, red)
   end

   for _,minion in ipairs(MINIONS) do
      if IsValid(minion) and GetDistance(minion) < 2000 then
         local damage = GetAADamage(minion)

         local MinionBarPos = GetUnitHPBarPos(minion)
         local DrawDistance = math.floor(63 / (minion.maxHealth / damage))
--~         for i=1,math.ceil(minion.health / damage) do
            DrawRectangleAL(MinionBarPos.x - 32 + DrawDistance * 1, MinionBarPos.y, 1, 4, 4278190080)
--~         end

         local hits = math.ceil(minion.health/damage)
         if hits == 1 then
            TextObject(hits.." hp", minion, blueT)
            Circle(minion, 75, red, 5)
         elseif hits <= 3 then
            TextObject(hits.." hp", minion, greenT)
         end

         for _,spell in pairs(spells) do
            if spell.lh and CanUse(spell) and GetDistance(minion) < GetSpellRange(spell)*1.5 then
               if WillKill(spell, minion) then
                  if spell.key == "Q" then
                     Circle(minion, 55, spell.color, 2)
                  elseif spell.key =="W" then
                     Circle(minion, 60, spell.color, 2)
                  elseif spell.key =="E" then
                     Circle(minion, 65, spell.color, 2)
                  elseif spell.key =="R" then
                     Circle(minion, 70, spell.color, 2)
                  end
               end
            end
         end
      end
   end

   if P.markedTarget then
      Circle(P.markedTarget, nil, red, 7)
   end


   -- if tfas then
   --    for key,spell in pairs(tfas) do
   --       local activeSpell = GetSpell(key)

   --       if activeSpell and activeSpell.showFireahead then
   --          for name,trackedPoints in pairs(spell) do
   --             local target
   --             for _,enemy in ipairs(ENEMIES) do
   --                if enemy.charName == name then
   --                   target = enemy
   --                   break
   --                end
   --             end

   --             if not target then break end
   --             local point, chance = GetSpellFireahead(key, target)

   --             if GetDistance(point) < GetSpellRange(activeSpell)+100 then

   --                if chance >= 3 then
   --                   Circle(point, 50, green, 3)
   --                elseif chance >= 2 then
   --                   Circle(point, 50, green, 2)                  
   --                elseif chance >= 1 then
   --                   Circle(point, 50, green, 1)
   --                end
   --                LineBetween(target, point)
   --             end
   --          end
   --       end
   --    end
   -- end

   for i,shot in rpairs(ACTIVE_SKILL_SHOTS) do
      if shot.timeOut < time() then
         table.remove(ACTIVE_SKILL_SHOTS, i)
      else
         if shot.safePoint then
            Circle(shot.safePoint)
         end
         if shot.isline then
            LineBetween(shot.startPoint, Projection(shot.startPoint, shot.endPoint, GetDistance(shot.startPoint, shot.endPoint)+shot.radius), shot.radius)
         end
         if not shot.isline or shot.point then
            Circle(shot.endPoint, shot.radius, blue, 4)
         end
      end
   end
end


local ignoredObjectNames = {
   "DrawFX",
   -- "missile",
   "empty.troy",
   "SRU_Chaos_CM_BA",
   "SRU_Chaos_MM_BA",
   "SRU_Order_CM_BA",
   "SRU_Order_MM_BA",
   "Minion_T",
}
function doCreateObj(object)
   if not (object and object.x and object.z) then
      return
   end

   if ListContains(object.name, ignoredObjectNames) or
      object.name == "missile"
   then
      return
   end

   createForPersist(object)

   for spell, info in pairs(DISRUPTS) do
      persistForDisrupt(info.char, info.obj, spell, object)
   end

   -- if IsHero(object) and not CHAR_SPELLS[object.name] then
   --    CHAR_SPELLS[object.name] = LoadConfig("charSpells/"..object.name)
   --    if not CHAR_SPELLS[object.name] then
   --       CHAR_SPELLS[object.name] = {}
   --    end
   -- end

   for _,name in ipairs(channeledSpells) do
      if spells[name] and spells[name].channel then
         if spells[name].object then
            if spells[name].objectTimeout then
               if object and 
                  find(object.name, spells[name].object) and
                  GetDistance(object) < 200
               then
                  PersistTemp(name, spells[name].objectTimeout)
                  -- PrintAction("found a channel temp object "..object.name.." for "..name)
               end
            else               
               if PersistBuff(name, object, spells[name].object, 200) then
                  PrintAction("found a channel object "..object.name.." for "..name)
               end
            end
         else
            if not spells[name].channelTime then
               pp("cast a channeled spell "..name.." without a persisting object or channel time")
            end
         end
      end
   end

   for i, callback in ipairs(OBJECT_CALLBACKS) do
      callback(object)
   end
end 

function persistForDisrupt(char, oName, label, object)
   if find(object.name, oName) then
      for _,enemy in ipairs(ENEMIES) do
         if enemy.name == char and GetDistance(enemy, object) < 150 then
            Persist(char, enemy, enemy.charName)
            break
         end
      end
      if P[char] and GetDistance(P[char], object) < 150 then
         Persist(label, object, oName)
      end
   end
end

function Disrupt(targetSpell, thing)
   local spell = GetSpell(thing)
   if not CanUse(spell) then 
      return false
   end
   if P[targetSpell] then
      local target = P[DISRUPTS[targetSpell].char]
      if IsInRange(spell, target) then
         if spell.delay then
            if spell.noblock then
               CastXYZ(spell, target)
            else
               if IsUnblocked(target, spell, me, MINIONS, ENEMIES) then
                  CastXYZ(spell, target)
               else
                  return false
               end
            end
         else
            Cast(spell, target)
         end         
         PrintAction(thing.." to disrupt "..targetSpell, target)
         P[targetSpell] = nil
         return true
      end
   end
   return false
end

STALLERS = {
   'staticfield',
}

GAPCLOSERS = {
   'UrchinStrike', 
   'MonkeyKingNimbus', 
   'ViR', 
}

DASHES = {
   slashCast=660,   
   FizzJump=400,
}

function DumpCloseObjects(object)
   if GetDistance(object) < 50 then
      pp(object.name.." "..object.charName)
   end
end
function DumpSpells(unit, spell)
   if unit.name == me.name then
      pp(unit.name.." "..spell.name)
   end
end

function IsMinion(unit)
   if not IsValid(unit) then return false end
   return find(unit.name, "Minion")
end

function IsBasicMinion(minion)
   return find(minion.charName, "MinionMelee")
end
function IsCasterMinion(minion)
   return find(minion.charName, "MinionRanged")
end
function IsBigMinion(minion)
   return find(minion.charName, "MinionSiege")
end
function IsSuperMinion(minion)
   return find(minion.charName, "MinionSuper")
end

function IsHero(unit)
   return unit and unit.type == "AIHeroClient"
end

function IsEnemy(unit)
   return IsHero(unit) and unit.team ~= me.team
end

function IsAlly(unit)
   return IsHero(unit) and unit.team == me.team
end

function IsValid(target)
   if not target or not target.x then
      return false
   end
   if target.dead or 
      target.health == 0 or
      not target.valid or
      not target.visible or      
      target.name == "" or target.charName == "" or
      HasBuff("invulnerable", target)
   then
      return false
   end
   return true
end

function ValidTargets(list)
   if not list then return {} end
   return FilterList(list, 
      function(item)
         return IsValid(item)
      end
   )
end

local function updateObjects()
   local mark = GetMarkedTarget()
   if mark then
      if mark.dead or not mark.visible or GetDistance(mark) > 1750 then
         P.markedTarget = nil
      end
   end

   cleanWillKills()
end

WILL_KILLS = {}
WILL_KILLS_TIMEOUTS = {}
WILL_KILLS_BY_SPELL = {}

function AddWillKill(items, spellName)
   assert(spellName)

   if type(items) ~= "table"  then
      AddWillKill({items}, spellName)
      return
   end

   spellName = spellName or "nil"

   local timeout = time()+.75
   for _,item in ipairs(items) do
      table.insert(WILL_KILLS, item)
      table.insert(WILL_KILLS_TIMEOUTS, timeout)
      table.insert(WILL_KILLS_BY_SPELL, spellName)
   end
end

function RemoveWillKills(list, spellName)
   assert(spellName)
   for i,sn in rpairs(WILL_KILLS_BY_SPELL) do
      if sn == spellName then
         table.remove(WILL_KILLS, i)
         table.remove(WILL_KILLS_TIMEOUTS, i)
         table.remove(WILL_KILLS_BY_SPELL, i)
      end
   end

   return FilterList(list, function(item) return not ListContains(item, WILL_KILLS) end)
end

function cleanWillKills()
   for i,_ in rpairs(WILL_KILLS_TIMEOUTS) do
      if time() > WILL_KILLS_TIMEOUTS[i] then
         table.remove(WILL_KILLS, i)
         table.remove(WILL_KILLS_TIMEOUTS, i)
         table.remove(WILL_KILLS_BY_SPELL, i)
      end
   end
end

function GetNearestCreep()
   return SortByDistance(CREEPS)[1]
end
function GetGolem()
   for _,creep in ipairs(SortByDistance(CREEPS)) do
      if find(creep.name, "AncientGolem") then
         return creep
      end
   end
end
function GetLizard()
   for _,creep in ipairs(SortByDistance(CREEPS)) do
      if find(creep.name, "LizardElder") then
         return creep
      end
   end
end
function GetWraith()
   for _,creep in ipairs(SortByDistance(CREEPS)) do
      if creep.name == "Wraith" then
         return creep
      end
   end
end

function cloneTarget(target)
   local t = {}
   t.x = target.x
   t.y = target.y
   t.z = target.z
   t.health = target.health
   t.maxHealth = target.maxHealth
   t.armor = target.armor
   t.valid = true
   t.visible = true
   t.name = target.name
   t.charName = target.charName
   return t
end

THROTTLES = {}
function throttle(id, millis)
   -- first time, set a timer and return false
   if THROTTLES[id] == nil then
      THROTTLES[id] = GetClock() + millis
      return false
   -- Enough time has passed, reset the clock and return false
   elseif GetClock() > THROTTLES[id] then
      THROTTLES[id] = GetClock() + millis
      return false
   end
   return true
end

function CastBest(thing)
   local spell = GetSpell(thing)
   if not spell or not CanUse(spell) then
      return false
   end
   local target = GetMarkedTarget() or GetWeakestEnemy(thing)
   if target then
      Cast(thing, target)
      PrintAction(thing, target)
      return true
   end
   return false
end

-- "mark" the enemy closest to a mouse click (i.e. click to mark)
function MarkTarget(target)
   if target and IsEnemy(target) then
      Persist("markedTarget", target)
      return target
   end
   if #GetInRange(GetMousePos(), 500, ENEMIES) == 0 then
      P.markedTarget = nil
      return
   end
   local targets = SortByDistance(GetInRange(mousePos, 200, ENEMIES), GetMousePos())
   if targets[1] then
      Persist("markedTarget", targets[1])
      return targets[1]
   end
end
function GetMarkedTarget()
   return P.markedTarget
end


function MoveToTarget(t)
   if CanMove() then
      local pos = VP:GetPredictedPos(t, .5, t.ms, me, false)
      if GetDistance(pos) > 150 then
         me:MoveTo(pos.x,pos.z)
      end
      PrintAction("MTT", t, 1)
      return true
   end
   return false
end

function MoveToCursor()
   if not CanMove() then
      return
   end
   -- local moveSqr = math.sqrt((mousePos.x - myHero.x)^2+(mousePos.z - myHero.z)^2)
   -- if moveSqr < 1000 then
   --    local moveX = myHero.x + 300*((mousePos.x - myHero.x)/moveSqr)
   --    local moveZ = myHero.z + 300*((mousePos.z - myHero.z)/moveSqr)
   --    -- pp(GetDistance(me, {x=moveX, y=me.y, z=moveZ}))
   --    me:MoveTo(moveX,moveZ)
   -- else
   if GetDistance(mousePos) < 10 then
      me:HoldPosition()
   else
		me:MoveTo(mousePos.x, mousePos.z)
   end
end


-- weak, far, near, strong
-- if force is false, try to play nice with auto attacking lasthits
-- if force is true, kill it now.
function KillMinion(thing, method, force, targetOnly)
   local spell = GetSpell(thing)
   if not CanUse(spell) then return false end

   if spell.name and spell.name == "attack" then
      force = true
   end

   method = method or "weak"

   local minions 
   if IsBlockedSkillShot(thing) then
      minions = RemoveWillKills(GetKills(thing, GetIntersection(MINIONS, GetUnblocked(thing, me, MINIONS, ENEMIES, PETS))), thing)
   else
      minions = RemoveWillKills(GetKills(thing, GetInRange(me, thing, MINIONS)), thing)
   end      

   local ignoreMana = false
   local thresh = .1

   if type(method) == "string" then
      method = {method}
   end

   local targetBy = "weak"

   if ListContains("far", method) then
      SortByDistance(minions, me, true)
      targetBy = "far"
   elseif ListContains("near", method) then
      SortByDistance(minions)
      targetBy = "near"
   elseif ListContains("strong", method) then
      SortByHealth(minions, spell, true)
      targetBy = "strong"
   else
      SortByHealth(minions, spell)
      targetBy = "weak"
   end

   if ListContains("burn", method) or
      ListContains("ignoreMana", method)
   then
      ignoreMana = true
   elseif ListContains("lowMana", method) then
      thresh = .2
   end

   local targets = {}

   local spellName = GetSpellName(thing)
   -- first pass to prioritize big minions (yeah I'll get dup minions but who cares)
   for _,minion in ipairs(minions) do
      if IsBigMinion(minion) then
         table.insert(targets, minion)
      end
   end

   for _,minion in ipairs(minions) do
      table.insert(targets, minion)
   end

   local target = nil
   for _,minion in ipairs(targets) do
      if force then
         target = minion
         break
      else
         rangeThresh = GetAARange()
         if IsMelee(me) then
            rangeThresh = GetAARange() + 25
         end
         if JustAttacked() or
            not IsInE2ERange(rangeThresh, minion) or
            GetAADamage(minion)*1.5 < minion.health
         then
            target = minion
            break
         end
      end
   end

   if IsValid(target) then

      if not ignoreMana then
         local score = 1
         if IsBigMinion(target) then
            score = 1.5
         end
         if score < GetThreshMP(thing, thresh) then
            return nil
         end
      end

      if targetOnly then
         return target
      end

      AddWillKill(target, thing)

      if spell.name and spell.name == "attack" then
         if AA(target) then
            PrintAction("Kill "..targetBy.." minion")
            return target
         end
      else
         if IsSkillShot(thing) then
            -- CastFireahead(thing, target)
            CastXYZ(thing, target)
         else
            Cast(spell, target)
         end
         -- pp("setting lkms to "..spellName)
         PrintAction(spellName.." "..targetBy.." minion")
         return target
      end
   end

   return false
end

-- weak, far, near, strong
function HitMinion(thing, method)
   if not CanUse(thing) then return false end

   local spell = GetSpell(thing)

   if not extraRange then extraRange = 0 end
   if not method then method = "weak" end

   local minions = GetInRange(me, thing, MINIONS)
   if method == "weak" then
      SortByHealth(minions, spell)
   elseif method == "far" then
      SortByDistance(minions)
      minions = reverse(minions)
   elseif method == "near" then
      SortByDistance(minions)
   elseif method == "strong" then
      SortByHealth(minions, spell)
      minions = reverse(minions)
   end

   for _,minion in ipairs(minions) do
      if spell.name and spell.name == "attack" then
         if AA(minion) then
            PrintAction("AA "..method.." minion")
            return true
         end
      else
         Cast(spell, minion)
         PrintAction(thing.." "..method.." minion")
         return true
      end
   end
   return false
end

local isx = nil
local isy = nil
function HitObjectives()
   local targets = GetInE2ERange(me, GetAARange()+25, TURRETS, INHIBS)
   table.sort(targets, function(a,b) return a.maxHealth > b.maxHealth end)

   if targets[1] and CanAttack() then
      if AA(targets[1]) then
         PrintAction("Hit objective", target)
         return true
      end
   end

   -- for _,inhib in ipairs(concat(INHIBS, NEXUS)) do
   --    if IsInRange(GetAARange()+100, inhib) then
   --       if CanAttack() then
   --          if not isx then
   --             isx = GetCursorX()
   --             isy = GetCursorY()
   --          end
   --          ClickSpellXYZ('m', inhib.x, inhib.y, inhib.z, 0)
   --          MouseRightClick()
   --          PrintAction("Attack inhib")
   --          return true
   --       else
   --          if isx then
   --             send.mouse_move(isx, isy) 
   --             isx = nil
   --             isy = nil
   --          end
   --       end
   --    end
   -- end

   return false
end

function scoreHits(spell, hits, hitScore, killScore)
   if #hits == 0 then
      return 0, {}
   end
   local score = #hits*hitScore
   local kills = {}

   if killScore ~= 0 then     
      for i,hit in ipairs(hits) do         
         if WillKill(spell, hit) then
            if IsBigMinion(hit) then
               score = score + (killScore / 2)
            end
            score = score + killScore
            table.insert(kills, hit)
         end
      end
   end
   return score, kills
end

-- Used to calculate whether or not a spell should be cast based on % of mana vs cost of spell
-- it will return a threshold to compare against score (generally used as 1 pt per normal minion as basis)
-- mPercHit of .1 corresponds to it's worth 10% of my mana to get a point (kill a minion or whatever)
-- .5 would be it's worth 50% of my mana to get a point.
-- thresholds are adjusted for circumstances such as being alone, being full mana or charging tear.
-- the return is the number of pionts necessary so the higher return means harder to meet.

function GetThreshMP(thing, mPercHit, min)
   mPercHit = mPercHit or .1
   min = min or 1
   local thresh = GetSpellCostPerc(thing)/mPercHit
   if CanChargeTear() then
      thresh = thresh * .75
   end
   if VeryAlone() then
      thresh = thresh * .75
   end
   if GetMPerc(me) == 1 then
      thresh = thresh * .5
   end
   return math.max(min, thresh)
end

function HitInShape(thing, GetBestF, targets, thresh, hs, ks, action)
   local spell = GetSpell(thing)
   if not spell or not CanUse(spell) then return false end

   thresh = thresh or GetThreshMP(thing, .1, 1.5)
   action = action or "hits"

   local hits, kills, score = GetBestF(me, thing, hs, ks, RemoveWillKills(targets, thing))
   if score >= thresh then
      AddWillKill(kills, thing)
      local point = GetCastPoint(hits, thing)
      if spell.overShoot then
         point = Projection(me, point, GetDistance(point)+spell.overShoot)
      end
      CastXYZ(thing, point)
      PrintAction(thing.." for "..action, score)
      return true
   end
   return false
end

local khs, kks = .05, .95
local hhs, hks = 1, .5

function KillMinionsInShape(thing, thresh, shapeFunc)
   if HitInShape(thing, shapeFunc, MINIONS, thresh, khs, kks, "kills") then
      return true
   end
end

function HitMinionsInShape(thing, thresh, shapeFunc)
   if HitInShape(thing, shapeFunc, MINIONS, thresh, hhs, hks, "hits") then
      return true
   end
end

function KillMinionsInArea(thing, thresh)   
   if HitInShape(thing, GetBestArea, MINIONS, thresh, khs, kks, "kills") then
      return true
   end
end

function HitMinionsInArea(thing, thresh)
   if HitInShape(thing, GetBestArea, MINIONS, thresh, hhs, hks, "hits") then
      return true
   end
end

function KillMinionsInCone(thing, thresh)
   if HitInShape(thing, GetBestCone, MINIONS, thresh, khs, kks, "kills") then
      return true
   end
end

function HitMinionsInCone(thing, thresh)
   if HitInShape(thing, GetBestCone, MINIONS, thresh, hhs, hks, "hits") then
      return true
   end
end

function KillMinionsInLine(thing, thresh)
   if HitInShape(thing, GetBestLine, MINIONS, thresh, khs, kks, "kills") then
      return true
   end
end


function HitMinionsInLine(thing, thresh)
   if HitInShape(thing, GetBestLine, MINIONS, thresh, hhs, hks, "kills") then
      return true
   end
end

function KillMinionsInPB(thing, thresh)
   if HitInShape(thing, GetBestPB, MINIONS, thresh, khs, kks, "kills") then
      return true
   end
end

function HitMinionsInPB(thing, thresh)
   if HitInShape(thing, GetBestPB, MINIONS, thresh, hhs, hks, "hits") then
      return true
   end
end



-- returns hits, kills (if scored), score
function GetBestArea(source, thing, hitScore, killScore, ...)
   local spell = GetSpell(thing)
   if not spell.radius then
      pp("No radius set for.."..thing)
      return {}
   end

   local targets = GetInRange(source, GetSpellRange(spell)+spell.radius, concat(...))

   local bestS = 0
   local bestT = {}
   local bestK = {}
   for _,target in ipairs(targets) do
      -- get everything that could be hit and still hit the target (a double blast radius)
      local hits = GetInRange(target, spell.radius*2, targets)

      local center
      -- trim outliers until everyone fits
      while true do
         center = GetCastPoint(hits, spell, source)
         SortByDistance(hits, center)         
         if GetDistance(center, hits[#hits]) > spell.radius then
            table.remove(hits, #hits)
         else
            break
         end
      end

      local score, kills = scoreHits(spell, hits, hitScore, killScore)
      if not bestT or score > bestS then
         bestS = score
         bestT = hits
         bestK = kills
      end
   end
   return bestT, bestK, bestS
end

function GetBestCone(source, thing, hitScore, killScore, ...)
   local spell = GetSpell(thing)
   if not spell.cone then
      pp("No cone set for.. "..thing)
      return {}
   end

   local targets = GetInRange(source, thing, concat(...))
   if not spell.noblock then
      targets = GetIntersection(targets, GetUnblocked(thing, source, MINIONS, ENEMIES, PETS))
   end

   -- results variables
   local bestS = 0
   local bestT = {}
   local bestK = {}

   for _,target in ipairs(targets) do
      local hits = FilterList(targets, function(item) return RadsToDegs(RelativeAngleRight(me, target, item)) < spell.cone end)
      local score, kills = scoreHits(spell, hits, hitScore, killScore)

      if score > bestS then
         bestS = score
         bestT = hits
         bestK = kills
      end
   end
         
   return bestT, bestK, bestS
end

function GetBestLine(source, thing, hitScore, killScore, ...)
   local spell = GetSpell(thing)
   local width = spell.width or spell.radius
   if not width then
      spell.width = 80
      pp("No width set for "..thing)
   end

   local targets = GetInRange(source, spell, concat(...))

   local bestS = 0
   local bestT = {}
   local bestK = {}
   for _,target in ipairs(targets) do
      local hits = GetInLineR(source, spell, target, targets)
      local score, kills = scoreHits(spell, hits, hitScore, killScore)
      if not bestT or score > bestS then
         bestS = score
         bestT = hits
         bestK = kills
      end
   end

   return bestT, bestK, bestS
end

-- this is pretty obvious but I need it for the interface
function GetBestPB(source, thing, hitScore, killScore, ...)
   local hits = GetInRange(source, thing, concat(...))
   local score, kills = scoreHits(thing, hits, hitScore, killScore)
   return hits, kills, score
end

function SkillShot(thing, purpose, targets, minChance)
   local target = GetSkillShot(thing, purpose, targets, minChance)
   if target then
      CastFireahead(thing, target)
      PrintAction(thing, target)
      return target
   end
   return false
end

-- minChance isn't a very scientific metric
function GetSkillShot(thing, purpose, targets, minChance)
   local spell = GetSpell(thing)
   if not CanUse(spell) then return nil end

   targets = targets or ENEMIES   

   targets = GetInRange(me, GetSpellRange(spell)+500, targets)

   targets = GetGoodFireaheads(spell, minChance, targets)

   local target
   -- find the best target in the remaining unblocked
   if purpose == "peel" then
      target = GetPeel({ADC, APC, me}, targets)
   else
      target = GetWeakest(spell, targets)
   end
   
   return target
end

function GetOtherAllies()
   return FilterList(ALLIES, function(ally) return not IsMe(ally) end)
end

function HotKey()
   return IsKeyDown(hotKey)
end

function IsRecalling(hero)
   return HasBuff("recall", hero)
end

function UseAutoItems()
   UseItem("Guardian's Horn")

   UseItem("Zhonya's Hourglass")
   UseItem("Wooglet's Witchcap")
   UseItem("Seraph's Embrace")

   UseItem("Mikael's Crucible")
   UseItem("Locket of the Iron Solari")
   
   UseItem("Crystaline Flask")
   
   UseItem("Tiamat")
   UseItem("Ravenous Hydra")
   
   UseItem("Bilgewater Cutlass")
   UseItem("Hextech Gunblade")
   UseItem("Blade of the Ruined King")
   UseItem("Frost Queen's Claim")
   
   UseItem("Randuin's Omen")

   UseItem("Youmuu's Ghostblade")
   UseItem("Entropy")

end

function GetNearestIndex(target, list)
   local nearDist = 10000
   local nearInd = nil
   for i,near in ipairs(list) do
      local tDist = GetDistance(target, near)
      if tDist < nearDist then
         nearInd = i
         nearDist = tDist
      end
   end
   return nearInd  
end

function GetKills(thing, list)
   list = RemoveWillKills(list, thing)
   local result = FilterList(list, 
      function(item) 
         if not item.health then return false end
         return WillKill(thing, item)
      end
   )
   return result
end

function CanChargeTear()
   local slot = GetInventorySlot(ITEMS["Tear of the Goddess"].id) or
                GetInventorySlot(ITEMS["Archangel's Staff"].id) or
                GetInventorySlot(ITEMS["Manamune"].id)
   if not slot then
      return false
   end
   return IsCooledDown(slot)
end

function GetWardingSlot()
   local wardSlots = {
      3340, 3350, 3361, 3362, -- trinkets
      3154, -- wriggles
      2049, 2045, -- sightstones
      2044 -- sight ward
   }
   local wardSlot
   for _,id in ipairs(wardSlots) do
      local wardSlot = GetInventorySlot(id)
      if wardSlot and IsCooledDown(wardSlot) then
         return wardSlot
      end
   end
end

function CheckTrinket()
   if GetDistance(HOME) > 1000 then
      return
   end

   local trinketItem = me:getItem(ITEM_7)
   if not trinketItem then
      Circle(me, 500, yellowB, 10)
   end

   -- local ss = GetItem("Sightstone")
   -- if not ss then
   --    ss = GetItem("Ruby Sightstone")
   -- end
   if GetItem("Sightstone") or GetItem("Ruby Sightstone") then
      if GetItem("Warding Totem") or
         GetItem("Greater Stealth Totem") or
         GetItem("Greater Vision Totem")
      then
         Circle(me, 500, yellow, 10)
      end
   end
end

local wardCastTime = time() 
function WardJump(thing, pos)
   local spell = GetSpell(thing)
   if not CanUse(spell) then
      return false
   end

   if not pos then
      pos = GetMousePos()
   end

   local ward = SortByDistance(GetAllInRange(pos, 200, ALLIES, MYMINIONS, WARDS), pos)[1]

   -- there isn't so cast one and return, we'll jump on the next pass -- on second delay between casting wards to prevent doubles
   if not ward then
      if time() - wardCastTime > 3 then
         local wardSlot = GetWardingSlot()
         if wardSlot then
            CastXYZ(wardSlot, pos)
            PrintAction("Throw ward")
            wardCastTime = time()
         end
         return true
      end
   elseif GetDistance(ward) < GetSpellRange(spell) then
      -- Cast can't target wards as they're not visible
      Cast(spell, ward)
      StartChannel(.25)
      PrintAction("Jump to ward")
      return true
   end
   return false
end

function GetAADamage(target)   
   local damage = GetSpellDamage("AA", target, true)
   
   for name,spell in pairs(spells) do
      if spell.modAA and P[spell.modAA] then
         modSpell = copy(spell)
         modSpell.modAA = nil
         modSpell.offModAA = true
         damage = damage + GetSpellDamage(modSpell)
      end
   end

   -- items
   damage = damage + GetOnHitDamage(target, true)

   if target then
      damage = CalculateDamage(target, damage)
   else
      damage = damage:toNum()
   end
   return math.floor(damage+.5)
end

-- assumes target not moving
function GetImpactTime(source, target, delay, speed)
   local dist = GetDistance(source, target) - GetWidth(source) / 2 - GetWidth(target) / 2
   local travelTime = 0
   if speed then
      travelTime = dist/speed
   end
   return time() + delay + travelTime
end

INCOMING_DAMAGE = {}
function AddIncomingDamage(target, damage, impactTime)
   damage = CalculateDamage(target, Damage(damage, "P"))

   -- pp("Adding "..damage.." incd at "..(impactTime-time()))
   table.insert(INCOMING_DAMAGE, {target=target, damage=damage, time=impactTime})
end

function CleanIncomingDamage()
   for i, incd in rpairs(INCOMING_DAMAGE) do
      if incd.time < time() then
         table.remove(INCOMING_DAMAGE, i)  
      end
   end
end

-- list of spells with the target being the last arg
function WillKill(...)
   CleanIncomingDamage()

   local arg = GetVarArg(...)
   local target = arg[#arg]
   local damage = 0
   local usedMana = 0   
   for i=1,#arg-1,1 do      
      local thing = arg[i]
      local spell = GetSpell(thing)
      if not IsImmune(thing, target) then
         if spell.name and spell.name == "attack" then
            damage = damage + GetAADamage(target)
            local speed = spells["AA"].speed
            if not speed and not IsMelee(me) then
               speed = 1500
               pp("No speed set "..thing)
            end
            -- removing windup from this calc. 
            -- I can get it close enough to orbwalk but not reliably close enough for timing lasthits against minion attacks
            -- and it's better to shoot late than early.
            local impactTime = GetImpactTime(me, target, getWindup()*0, speed)
            local incdDam = 0
            for _,incd in ipairs(INCOMING_DAMAGE) do
               if incd.time < impactTime then
                  if SameUnit(target, incd.target) then
                     incdDam = incdDam + incd.damage
                  end
               end
            end
            damage = damage + incdDam
         else         
            if CanUse(thing) and usedMana + GetSpellCost(thing) <= me.mana then
               damage = damage + GetSpellDamage(thing, target)
               usedMana = usedMana + GetSpellCost(thing)
            end
         end
      end      
      if damage > target.health + 3 then
         return true
      end
   end
   return false
end

--[[
This should look at the allies in [save] in order 
and return an enemy in [stop] that is trying to kill that ally in [save]
--]]
function GetPeel(save, stop)
   for _,ally in ipairs(save) do
      SortByDistance(stop, ally)
      -- check if the target is moving "directly" toward this ally
      -- check if the target is close enough to the ally to be a threat
      for _,enemy in ipairs(stop) do
         if GetDistance(enemy, ally) < 500 then
            local aa = ApproachAngle(enemy, ally)
            if aa < 30 then
               return enemy
            end
         end
      end
   end
end

function GetHPerc(target)
   if not target then target = me end
   return target.health/target.maxHealth
end
function GetMPerc(target)
   if not target then target = me end
   if target.maxMana == 0 then
      return 1
   end
   return target.mana/target.maxMana
end

function AutoPet(pet)
   if pet then
      -- find the closest target to pet
      local target = SortByDistance(GetInRange(pet, 1000, ENEMIES))[1]
      if target then
         PetAttack(target)
      end
   end
end
local lastPetAttack = 0
function PetAttack(target, key)
   if not key then key = "R" end
   if time() - lastPetAttack > 1.5 then
      CastSpellTarget(key, target)
      lastPetAttack = time()
      PrintAction("Pet Attack", target.charName)
   end
end
function CheckPetTarget(pet, unit, spell, key)
   if pet and not pet.timeout then
      local petTarget = SortByDistance(GetInRange(pet, 1000, ENEMIES), pet)[1]
      if not petTarget then
         if IsMe(unit) and
            spell.target and
            spell.target.team ~= me.team 
         then
            PetAttack(spell.target, key)
         end
      end
   end
end


function GetWeakestEnemy(thing, extraRange, stretch)
   if not extraRange then
      extraRange = 0
   end
   if not stretch then
      stretch = 0
   end

   local targets = FilterList(ENEMIES, 
      function(target)
         return IsInRange(thing, me, target, extraRange)
      end )
   if #targets == 0 then
      targets = FilterList(ENEMIES, 
         function(target)
            return IsInRange(thing, me, target, extraRange+stretch)
         end )
   end
   return GetWeakest(thing, targets)

   -- return GetWeakest(thing, GetInRange(me, GetSpellRange(spell)+extraRange, ENEMIES)) or
   --        GetWeakest(thing, GetInRange(me, GetSpellRange(spell)+extraRange+stretch, ENEMIES))
end


function GetWeakest(thing, list)
   list = list or ENEMIES

   local type = "M"
   
   local spell = GetSpell(thing)
   if spell then
      if spell.type then
         type = spell.type
      end
   end
   
   local weakest
   local wScore
   

   for _,target in ipairs(list) do      
      if target then
         if IsImmune(spell, target) then
            -- pp("Don't cast "..thing.." on "..target.name.." due to invuln")
         else
            local tScore = target.health / CalculateDamage(target, Damage(100, type))
            if weakest == nil or tScore < wScore then
               weakest = target
               wScore = tScore
            end
         end
      end
   end
   
   return weakest
end

function IsImmune(thing, target)
   local spell = GetSpell(thing)
   if target.team == me.team then
      return false
   end
   if spell and spell.name == "AA" then
      return HasBuff("invulnerable", target)
   else
      return HasBuff("invulnerable", target) or HasBuff("spellImmune", target)
   end
   return false
end

DOLATERS = {}
function DoIn(f, timeout, key)
   if key then
      DOLATERS[key] = {time()+timeout, f}
   else
      table.insert(DOLATERS, {time()+timeout, f})
   end
end

function StartChannel(timeout, label)   
   timeout = timeout or .5
   label = label or "channel"

   AddChannelObject(label)
   PersistTemp(label, timeout)   
end

function IsChannelling(name)
   if name then
      if P[name] then
         return name
      end
      return false
   end
   for _,name in ipairs(channeledObjects) do
      if P[name] then
         return name
      end
   end
   for _,name in ipairs(channeledSpells) do
      if P[name] then
         return name
      end
   end

   return false
end

function PauseToggle(key, timeout)
   Toggle(key, false)
   DoIn( function() Toggle(key, true) end,
         timeout,
         "pause"..key )
end

function checkDodge(shot)
   if shot.safePoint then
      if shot.block and not shot.range then
         pp("Blocking SS without defined range")
         pp(shot)
      end
      if not shot.block or ( shot.block and IsUnblocked(me, shot, shot.target, MINIONS, ENEMIES) ) then
         if not IsChannelling() or (shot.cc and shot.cc >= 3) then
            PrintAction("Dodge "..shot.name)
            -- BlockingMove(shot.safePoint)
         end
      end
   end
end

function processShot(shot)
   if not shot then return end

   if shot.show then
      addSkillShot(shot)
   end


   if not me.dead then
      shot = ShotTarget(shot, me)
      if shot then
         if not shot.show then
            addSkillShot(shot)
         end

         if Engaged() and shot.safePoint then
            PrintAction("Don't dodge - engaged -",shot.name, 1)
            return false
         end
         if IsChannelling() and shot.safePoint then
            PrintAction("Don't dodge - channelling -",shot.name, 1)
            return false
         end

         checkDodge(shot)
      end
   end

end

function GetPing()
   return GetLatency()/1000
end

function OnProcessSpell(unit, spell)
   dlog("start ops")
   if ModuleConfig.ass and IsEnemy(unit) then
      local shot = GetSpellShot(unit, spell)
      if shot and not shot.dodgeByObject then
         processShot(shot)
      end
   end

   if ICast("Recall", unit, spell) then
      StartChannel(1)
   end

   -- PredictEnemy(unit, spell)

   for _,name in ipairs(channeledSpells) do
      if ICast(name, unit, spell) then
         if spells[name].channelTime then
            PrintAction("Cast "..name.." and started channel for "..spells[name].channelTime)
            PersistTemp(name, spells[name].channelTime)
         else
            PrintAction("Cast "..name.." and started channel")
            PersistTemp(name, 1)
         end
         break
      end
   end

   for _,sp in pairs(spells) do
      if ICast(sp, unit, spell) then
         sp.lastCast = time() -- I don't know why I care so much here -- + .1 -- lag

         if sp.useCharges then
            if sp.charges == sp.maxCharges then
               sp.lastRecharge = time()
            end

            sp.charges = math.max(0, sp.charges - 1)
         end

      end
   end

   -- shortcut for "creep" cast a spell
   if unit.team == 300 then
      CREEP_ACTIVE = true
      DoIn(function() CREEP_ACTIVE = false end, 2, "creepactive")
   end

   if spell.name == "HallucinateFull" then
      PersistTemp("shacoClone", 3)
      P.shacoClone.charName = unit.charName
   end

   if IsMe(unit) and spell.target and IsCreep(spell.target) then
      DoIn(function() CREEP_ACTIVE = false end, 2, "creepactive")      
   end

   for i, callback in ipairs(SPELL_CALLBACKS) do
      callback(unit, spell)
   end

   dlog("end ops")
end

DODGING = false

local blockTimeout = .5
local lastMove = 0 
function BlockingMove(move_dest)
   -- pp("block and move")
   if time() - lastMove > 1 then
      
      -- me:MoveTo(move_dest.x, move_dest.z)
      -- BlockOrders()
      DODGING = true
      DoIn( function()
               -- UnblockOrders()
               DODGING = false
            end,
            blockTimeout )  
      lastMove = time()
   end

end

-- Common stuff that should happen every time

lastObjectName = {}
lastObjectIndex = 1

desiredFrameRate = 50
-- maxTimeToCycle = .5
desiredFrameTime = 1/desiredFrameRate
objectsPerCycle = 10000

local startTime = time()

local tt = time()
frames = {.1}
function OnTick()
   table.insert(frames, time()-tt)
   tt = time()
   while #frames > 10 do
      table.remove(frames, 1)
   end

   local frameTime = sum(frames)/#frames
   local fps = 1/frameTime

   if fps > desiredFrameRate then
      objectsPerCycle = math.min(objectsPerCycle+50, 10000)
   else
      objectsPerCycle = math.max(objectsPerCycle-50, 500)
   end

   local cycleTime = (objManager.iCount / objectsPerCycle)*frameTime

   Text(""..trunc(fps,1), 1800, 60, 0xFFCCEECC);
   Text(""..trunc(objectsPerCycle,1), 1800, 75, 0xFFCCEECC);
   Text(""..trunc(cycleTime,1), 1800, 90, 0xFFCCEECC);

   if time() - startTime > .5 then
      for i = lastObjectIndex, math.min(lastObjectIndex+objectsPerCycle, objManager.iCount), 1 do
         local object = objManager:GetObject(i)
         if object and object.valid and object.name then
            if lastObjectName[i] == object.name then
               -- existing object
            else
               lastObjectName[i] = object.name
               doCreateObj(object)
            end
         else
            lastObjectName[i] = nil
         end
      end
      lastObjectIndex = lastObjectIndex + objectsPerCycle
      if lastObjectIndex >= objManager.iCount then
         lastObjectIndex = 1
      end
   end

   for _,spell in pairs(spells) do
      if spell.key == "Q" or
         spell.key == "W" or
         spell.key == "E" or
         spell.key == "R"
      then
         spell.spellLevel = GetSpellLevel(spell.key)
      end
   end

   checkToggles()
   updateObjects()
   drawCommon()
   
   if ModuleConfig.ass then
      if blockAndMove then 
         blockAndMove() 
      end
   end

   for key,doLater in pairs(DOLATERS) do
      if doLater[1] < time() then
         doLater[2]()
         DOLATERS[key] = nil
      end
   end

   for _,spell in pairs(spells) do

      if spell.useCharges and GetSpellLevel(spell.key) > 0 then
         if not spell.lastRecharge then
            spell.lastRecharge = time()
         end

         if spell.charges < spell.maxCharges then
            local ttRecharge = GetLVal(spell, "rechargeTime") * (1+me.cdr)
            if ttRecharge > 0 then -- no recharge time means time doesn't generate charges
               if time() - spell.lastRecharge > ttRecharge then
                  spell.lastRecharge = time()
                  spell.charges = spell.charges + 1
               end
            end
         else
            spell.lastRecharge = time()
         end
      end
   end

   TrackMyPosition()
   TrackHeroPositions()

   if GetDistance(me, CURSOR) < 50 and CURSOR then
      ClearCursor()
      -- StopMove()
   end

   if Point(CURSOR):valid() then
      Circle(CURSOR, 33, blue)
      LineBetween(me, CURSOR)
   end

   for spell, info in pairs(DISRUPTS) do
      if P[spell] then
         Circle(P[info.char], 100, green, 10)
      end
   end

   if ModuleConfig.ass then

      for _,pName in ipairs(GetTrackedSpells()) do
         if P[pName] and PData[pName].direction then
            local pd = PData[pName]
            local shot = GetSpellDef(pd.champName, pd.spellName)

            if shot then
               shot.timeOut = os.clock()+shot.time
               shot.startPoint = pd.lastPos
               shot.endPoint = ProjectionA(pd.lastPos, pd.direction, shot.range)
               SetEndPoints(shot)

               processShot(shot)
            end
         end
      end

   end

   CheckTrinket()

   for _,callback in ipairs(TICK_CALLBACKS) do
      -- dlog(callback[1])
   	callback[2]()
   end
   dlog("end ontick")
end

DISRUPTS = {
   DeathLotus={char="Katarina", obj="Katarina_deathLotus_cas", spell=nil, timeout=nil},
   -- StandUnited={char="Shen", obj=""},
   Meditate={char="MasterYi", obj="MasterYi_Base_W_Buf"},
   -- Idol={char="Galio", obj=""},
   Monsoon={char="Janna", obj="ReapTheWhirlwind_green_cas"},
   BulletTime={char="MissFortune", obj="missFortune_ult_cas"},
   AbsoluteZero={char="Nunu", obj="AbsoluteZero2"},
   Duress={char="Warwick", obj="InfiniteDuress_tar"},
   -- Grasp={char="Malzahar", obj=""},
   -- Drain={char="FiddleSticks", obj="drain.troy"},
}

function CheckDisrupt(spell)
   for disrupt,_ in pairs(DISRUPTS) do
      if Disrupt(disrupt, spell) then
         return true
      end
   end
   return false
end

champInit = false
wasChannelling = false
function StartTickActions()
   if not champInit then
      for name, spell in pairs(spells) do
         if spell.channel then
            AddChannelSpell(name)
         end
         if spell.useCharges and not spell.charges then
            spell.charges = 0
         end
      end

      champInit = true
   end

   if IsRecalling(me) or me.dead then
      CURSOR = nil
      PrintAction("Recalling or dead")
      return true
   end

   if IsChannelling() then
      wasChannelling = true
      return true
   end

   if wasChannelling then
      -- PrintAction("end channel")
      wasChannelling = false
   end

   UseAutoItems()

   if HotKey() then
      if GetDistance(mousePos) < 3000 then
         -- CURSOR = Point(mousePos)
      end
   else
      CURSOR = nil
   end

   return false
end

channeledSpells = {}
channeledObjects = {}
function AddChannelSpell(name)
   table.insert(channeledSpells, name)
end
function AddChannelObject(name)
   if not ListContains(name, channeledObjects) then
      table.insert(channeledObjects, name)
   end
end


needMove = false

function AutoMove()
   if CanMove() then
      if HotKey() then
         if GetDistance(mousePos) < 3000 then
            MoveToCursor()
         end
      end
      if needMove and CURSOR then      
         me:MoveTo(Point(CURSOR).x, Point(CURSOR).z)
         -- PrintAction("move")
         needMove = false
      end
   end
end

local autoJungleFunction = nil
function SetAutoJungle(ajf)
   autoJungleFunction = ajf
end

function JungleAoE(thing)
   local spell = GetSpell(thing)
   if CanUse(spell) then
      local creep = GetBiggestCreep(GetInRange(me, spell, CREEPS))
      if creep then
         local score = ScoreCreeps(GetInRange(creep, spell.radius, CREEPS))
         if score >= GetThreshMP(spell, .1, 2) then
            CastFireahead(spell, creep)
            PrintAction(thing.." (jungle)")
            return true
         end
      end
   end
end

function AutoJungle()   
   if HotKey() and CREEP_ACTIVE then
      if autoJungleFunction then
         return autoJungleFunction()
      end
      local creep = GetBiggestCreep(GetInRange(me, "AA", CREEPS))
      if AA(creep) then
         PrintAction("AA "..creep.charName)
         return true
      end

   end
end   

function EndTickActions(noLastHit)
   if IsOn("lasthit") and Alone() and not noLastHit then
      if KillMinion("AA") then
         return true
      end

      if KillMinion("Tiamat") then
         return true
      end
      if KillMinion("Ravenous Hydra") then
         return true
      end
   end

   if HotKey() and HitObjectives() then
      return true
   end

   if AutoJungle() then
      return true
   end

   if HotKey() and IsOn("clear") and Alone() then

      if HitMinion("AA", "strong") then
         return true
      end

      if CanUse("Tiamat") or CanUse("Ravenous Hydra") then
         local minions = GetInRange(me, item, MINIONS)
         if #minions >= 2 then
            Cast("Tiamat", me)
            Cast("Ravenous Hydra", me)
            PrintAction("Crescent for clear")
            return true
         end
      end

   end

   if IsOn("move") and HotKey() then
      if IsMelee() then
         if MeleeMove() then
            return true
         end
      end

      AutoMove()
   end

   PrintAction()
   return false
end

function IsLoLActive()
   return tostring(winapi.get_foreground_window()) == "League of Legends (TM) Client"
end

function AA(target, force)
   if IsValid(target) then
      if CanAttack() or force then
         SetAttacking()
         me:Attack(target)
         -- needMove = true
         return true
      end
   end
   return false
end

function AutoAA(target, thing, force) -- thing is for modaa like Jax AutoAA(target, "empower")
   local mod = ""
   if target and IsInE2ERange(GetAARange()+150, target) then
      if thing and CanUse(thing) and not P[thing] and
         ( ( JustAttacked() or not IsInAARange(target) ) or
           force )
      then
         Cast(thing, me)
         mod = " ("..thing..")"
      end

      if IsInAARange(target) then
         if AA(target) then
            if IsMelee() then
               ClearCursor()
            end
            PrintAction("AA"..mod, target)
            return true
         end
      end
   else
      target = GetWeakestEnemy("AA")
      if target and AA(target) then
         PrintAction("AA driveby "..mod, target)
         return true
      end
   end
   return false
end

function ModAAFarm(thing)
   if CanUse(thing) and not P[thing] and GetThreshMP(thing) <= 1 then
      local minions = SortByHealth(RemoveWillKills(GetInRange(me, "AA", MINIONS), thing), thing)
      for i,minion in ipairs(minions) do
         if WillKill(thing, minion) and 
            ( JustAttacked() or ( IsOn("clear") and not WillKill("AA", minion) ) )
         then
            AddWillKill(minion, thing)
            Cast(thing, me)
            AA(minion, true)
            PrintAction(thing.." lasthit", minion)
            return true
         end
      end
   end   
   return false
end

function ModAAJungle(thing)
   if CanUse(thing) and not P[thing] then
      local creep = SortByHealth(GetInRange(me, GetSpellRange("AA")+50, CREEPS), thing, true)[1]
      if creep and not WillKill("AA", creep) and JustAttacked() then
         Cast(thing, me)
         PrintAction(thing.." jungle", creep)
         return true
      end
   end
   return false
end

function MeleeMove()
   local lockRange = 400
   if CanMove() then   
      local target = GetMarkedTarget() or GetMeleeTarget()
      if target then
         Circle(target, lockRange, yellowB, 4)

         -- if not IsInAARange(target) then
            if GetDistance(target, mousePos) < lockRange then
               Circle(target, 150, redB, 3)
               if MoveToTarget(target) then
                  return true
               end
            end
         -- end

      else        
         -- MoveToCursor() 
         -- return false
      end
   end
   return false
end

-- get the weakest nearby target so we don't get stuck on a tank.
-- don't jump too far as you end up chasing.
-- look out further to find a target if there isn't one at hand.
function GetMeleeTarget()
   return GetWeakestEnemy("AA", GetAARange()*.75, GetAARange()*1)
end

function DrawKnockback(object2, thing)
   local dist
   if type(thing) == "number" then
      dist = thing
   else
      local spell = GetSpell(thing)
      dist = spell.knockback
   end
   local a = object2.x - me.x
   local b = object2.z - me.z 
   
   local angle = math.atan(a/b)
   
   if b < 0 then
      angle = angle+math.pi
   end
   
   LineObject(object2, dist, 0, angle, 0)
end

function UseItems(target)
   for item,_ in pairs(ITEMS) do
      UseItem(item, target)
   end
end

function GetItem(itemName)
   local item = ITEMS[itemName]
   if not item then return nil end

   local slot = GetInventorySlot(item.id)
   if not slot then return nil end
   slot = tostring(slot)

   return item, slot
end

local flaskCharges = 3
function UseItem(itemName, target, force)
   local item = ITEMS[itemName]
   local slot = GetInventorySlot(item.id)
   if not slot or slot == 0 then return end   
   slot = tostring(slot)

   if not IsCooledDown(slot) then return end

   if itemName == "Entropy" or
      itemName == "Youmuu's Ghostblade" 
   then
      if ( IsMelee() and GetMeleeTarget() ) or
         #GetInAARange(me, ENEMIES) > 0
      then
         CastSpellTarget(slot, me)
         PrintAction(itemName, nil, .5)
         return true
      end

   elseif itemName == "Randuin's Omen" then
      if #GetInRange(me, item.range, ENEMIES) > 0 then
         CastSpellTarget(slot, me)
         PrintAction(itemName, nil, .5)
         return true
      end

   elseif itemName == "Bilgewater Cutlass" or
      itemName == "Hextech Gunblade" or
      itemName == "Blade of the Ruined King"
   then
      if not target or not IsInRange(item, target) then
         target = GetWeakestEnemy(item)
      end
      if target then
         CastSpellTarget(slot, target)
         PrintAction(itemName, target, 1)
         return true
      end

   elseif itemName == "Deathfire Grasp" then
      if target and IsInRange(item, target) then
         CastSpellTarget(slot, target)
         PrintAction(itemName, target, .5)
         return true
      end

   elseif itemName == "Tiamat" or
          itemName == "Ravenous Hydra"
   then
      if not CanAttack() and #GetInRange(me, item, ENEMIES) >= 1 then
         CastSpellTarget(slot, me)
         PrintAction(itemName, nil, 1)
         return true
      end

   elseif itemName == "Frost Queen's Claim" then
      local target = SelectFromList(GetInRange(me, item, ENEMIES), function(enemy) return #GetInRange(enemy, item.radius, ENEMIES) end)
      if target then
         CastXYZ(slot, target)
         PrintAction(itemName, target, 1)
         return true
      end

   elseif itemName == "Shard of True Ice" then
      -- shard
      -- look at all nearby heros in range and target the one with the most nearby enemies
      local shardRadius = 300

      local nearCount = 0
      target = nil
      for i,hero in ipairs(ALLIES) do
         if GetDistance(me, hero) < 750 then
            local near = #GetInRange(hero, shardRadius, ENEMIES)
            if near > nearCount then
               target = hero
               nearCount = near
            end
         end
      end
      if target then
         CastSpellTarget(slot, target)
         PrintAction(itemName, target)
         return true
      end

   elseif itemName == "Guardian's Horn" then
      if #GetInRange(me, 600, ENEMIES) > 0 then
         CastSpellTarget(slot, me)
      end

   elseif itemName == "Locket of the Iron Solari" then
      -- how about 2 nearby allies and 2 nearby enemies
      local locketRange = ITEMS[itemName].range
      if #GetInRange(me, locketRange, ALLIES) >= 2 and
         #GetInRange(me, locketRange, ENEMIES) >= 2 
      then
         CastSpellTarget(slot, me)
      end

   elseif itemName == "Zhonya's Hourglass" or 
          itemName == "Wooglet's Witchcap" or
          itemName == "Seraph's Embrace"
   then
      -- use it if I'm at x% and there's an enemy nearby
      -- may expand this to trigger when a spell is cast on me that will kill me
      if not Alone() and GetHPerc(me) < .25 then
         CastSpellTarget(slot, me)
         return true
      end

   elseif itemName == "Muramana" then
      if GetMPerc(me) < .75 and Alone() then
         target = false
      end
      if target == nil or target then
         if not P.muramana then
            CastSpellTarget(slot, me)
            PrintAction("Muramana ON", nil, 1)
            return true
         end
      else -- target == false
         if P.muramana then
            CastSpellTarget(slot, me)
            PrintAction("Muramana OFF", nil, 1)
            return true
         end
      end


   elseif itemName == "Mikael's Crucible" then
      -- It can heal or it can cleans
      -- heal is better the lower they are so how about scan in range heros and heal the lowest under 25%
      -- the cleanse is trickier. should I save it for higher priority targets or just use it on the first who needs it?\
      -- I took (or tried to) take out the slows so it will only work on harder cc.
      -- how about try to free adc then apc then check for heals on all in range.

      local crucibleRange = ITEMS["Mikael's Crucible"].range

      local target = ADC
      if target and target.name ~= me.name and 
         GetDistance(target, me) < crucibleRange and
         HasBuff("cc", target)
      then 
         CastSpellTarget(slot, target)
         pp("uncc adc,", target, 1) 
      else
         target = APC
         if target and target.name ~= me.name and 
            GetDistance(target, me) < crucibleRange and
            HasBuff("cc", target)
         then 
            CastSpellTarget(slot, target)
            pp("uncc apc,", target, 1)
         end
      end

      for _,hero in ipairs(GetInRange(me, crucibleRange, ALLIES)) do
         if GetHPerc(hero) < .25 then
            CastSpellTarget(slot, hero)
            pp("heal "..hero.name.." "..hero.health/hero.maxHealth, nil, 1)
         end
      end

   elseif itemName == "Crystaline Flask" then
      if GetDistance(HOME) < 800 then
         flaskCharges = 3
      end
      if flaskCharges > 0 then
         if GetHPerc(me) < .75 and not P.healthPotion then
            CastSpellTarget(slot, me)
            flaskCharges = flaskCharges - 1
            PrintAction("Flask for health")
            PersistTemp("healthPotion", 1)
            return true
         elseif GetMPerc(me) < .5 and not P.manaPotion then
            CastSpellTarget(slot, me)
            flaskCharges = flaskCharges - 1
            PrintAction("Flask for mana")
            PersistTemp("manaPotion", 1)
            return true
         elseif me.maxHealth - me.health > (120+30) and 
                me.maxMana - me.mana < (60+30) and
                not P.manaPotion and not P.healthPotion
         then
            CastSpellTarget(slot, me)
            flaskCharges = flaskCharges - 1
            PrintAction("Flask for regen")
            PersistTemp("healthPotion", 1)
            PersistTemp("manaPotion", 1)
            return true
         end
      end
      
   -- else
   --    -- CastSpellTarget(slot, me)
   end

end

function CastAtCC(thing, hardCCOnly, targetOnly)
   -- TODO Use this to target dash endpoints
   --    when vayne rolls you know where she's going to land. SS there.

   if DODGING then
      return 
   end

   local spell = GetSpell(thing)

   if not CanUse(spell) then return end

   local range = GetSpellRange(spell)
   if spell.radius then 
      range = range + spell.radius
   end

   local target = GetWeakest(spell, GetWithBuff("cc", GetInRange(me, range, ENEMIES)))

   local stillMoving = false
   local prediction = false
   if not target then
      if hardCCOnly then
         return 
      end

      for _,enemy in ipairs(SortByHealth(ENEMIES, thing)) do
         local pred, chance = GetSpellFireahead(thing, enemy)
         if chance >= 4 then
            if IsInRange(range, pred) then
               target = pred
               prediction = true
               break
            end
         end
      end

      if not target then
         local targets = GetInRange(me, thing, ENEMIES)
         for _,t in ipairs(targets) do
            if t.ms < 200 then
               target = t
               stillMoving = true
               break
            end
         end
      end
   end

   if target and IsInRange(range, target) then
      if not targetOnly then
         if spell.noblock then
            if stillMoving then
               CastFireahead(spell, target)
            else
               CastXYZ(spell, GetCastPoint({target}, spell))
            end
         else
            if IsUnblocked(target, spell, me, MINIONS, ENEMIES) then
               if stillMoving then
                  CastFireahead(spell, target)
               else
                  CastXYZ(spell, GetCastPoint({target}, spell))
               end
            else
               return 
            end
         end

         if stillMoving then
            PrintAction(thing.." on very slow ("..trunc(target.ms)..")", target)
         elseif prediction then
            PrintAction(thing.." on predicted", target.enemy)
         else
            PrintAction(thing.." on immobile", target)
         end
      end
      return target, not stillMoving
   end
   return 
end

function GetBiggestCreep(creeps)
   return SortByMaxHealth(creeps, nil, true)[1]
end

function ScoreCreeps(creeps)
   if type(creeps) ~= "table" then
      creeps = {creeps}
   end
   local points = 0
   for _,creep in ipairs(creeps) do
      if IsMinorCreep(creep) then
         points = points + 1
      elseif IsBigCreep(creep) then
         points = points + 2
      elseif IsMajorCreep(creep) then
         points = points + 4
      end
   end
   return points
end

function OnWndMsg(msg, key)
   for _,callback in ipairs(KEY_CALLBACKS) do
      callback(msg, key)
   end
end

Combo = Class()
function Combo:__init(name, timeout, onEnd)
   self.state = nil   
   self.states = {}
   self.vars = {}
   self.target = nil

   self.name = name
   self.timeout = timeout
   self.onEnd = onEnd
end


function Combo:__tostring()
   return self.name..":"..self.state
end

function Combo:__concat(a)
    return tostring(self) .. tostring(a) 
end

function Combo:reset()
   self.state = nil
   self.vars = {}
   if self.onEnd then
      self.onEnd()
   end
end

function Combo:set(var, value)
   self.vars[var] = value
end
function Combo:get(var)
   return self.vars[var]
end

function Combo:start()
   self.endTime = time() + self.timeout
   self.state = self.startState
end

function Combo:run()
   if self.state then
      if time() > self.endTime then
         PrintAction(self.name.." timeout")
         self:reset()
         return false
      end

      PrintState(0, tostring(self))
      self.states[self.state](self)
      return true
   end
end

function Combo:addState(state, action)
   if not self.startState then
      self.startState = state
   end
   self.states[state] = action
end


function GetInventorySlot(item, hero)
	hero = hero or me
   if hero:getInventorySlot(ITEM_1) == item then
      return 1
   elseif hero:getInventorySlot(ITEM_2) == item then
      return 2
   elseif hero:getInventorySlot(ITEM_3) == item then
      return 3
   elseif hero:getInventorySlot(ITEM_4) == item then
      return 4
   elseif hero:getInventorySlot(ITEM_5) == item then
      return 5
   elseif hero:getInventorySlot(ITEM_6) == item then
      return 6
   elseif hero:getInventorySlot(ITEM_7) == item then
      return 7
   end
   return nil
end

function OnDraw()
   dlog("start od")
   -- DrawHitBox(me)

   for _,callback in ipairs(DRAW_CALLBACKS) do
   	callback()
   end	

   DoDraws()
   dlog("end od")
end

function WillCollide(s, t)
   local dist = GetDistance(s,t)
   local cp = Point(s)
   cp = Projection(cp,t,10)
   while GetDistance(s, cp) < dist do
      if IsWall(cp:vector()) then --or #getNearPoints(cp) >= 1 then
         return cp
      end
      cp = Projection(cp,t,10)
   end
   return nil
end

function WillCollideBush(s, t)
   local dist = GetDistance(s,t)
   local cp = Point(s)
   cp = Projection(cp,t,10)
   while GetDistance(s, cp) < dist do
      if IsWallOfGrass(cp:vector()) then --or #getNearPoints(cp) >= 1 then
         return cp
      end
      cp = Projection(cp,t,10)
   end
   return nil
end

function GetNearestWall(target, dist)
   local wallPoint
   local wallDist
   local points = GetCircleLocs(target, dist)
   for _,point in ipairs(points) do
      local cp = WillCollide(target, point)
      if cp and ( not wallPoint or GetDistance(cp) < wallDist ) then
         wallPoint = cp
         wallDist = GetDistance(cp)
      end
   end
   if wallPoint then
      return wallPoint
   end
end

function GetNearestBush(target, dist)
   local bushPoint
   local bushDist
   local points = GetCircleLocs(target, dist)
   for _,point in ipairs(points) do
      local cp = WillCollideBush(target, point)
      if cp and ( not bushPoint or GetDistance(cp) < bushDist ) then
         bushPoint = cp
         bushDist = GetDistance(cp)
      end
   end
   if bushPoint then
      return bushPoint
   end
end