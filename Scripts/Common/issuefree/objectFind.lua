require "issuefree/timCommon"
require "issuefree/spellUtils"

local num = 10
local objects = {}
local spells = {}

local range = 250

local ignoredObjects = {"DrawFX", "Mfx_", "mm_ba", "cm_ba"}

local testShot
local testShotDelays = {}
local testShotSpeeds = {}

function debugTick()
   if testShot then
      if time() - testShot.castTime > 2 then
         testShot.object = nil
      else
         if testShot.object and testShot.object.valid then
            if GetDistance(testShot.object) > 200 then
               Circle(testShot.object)
               table.insert(testShot.points, Point(testShot.object))
               table.insert(testShot.times, time())

               -- else
               -- end
            end
         else
            local total = 0
            if #testShot.points > 1 then
               for i=2,#testShot.points do
                  local d = GetDistance(testShot.points[i], testShot.points[1])
                  local t = testShot.times[i] - testShot.times[1]
                  local speed = d/t
                  -- pp(speed)
                  total = total + speed
               end
               speed = total/(#testShot.points-1)
               table.insert(testShotSpeeds, speed)
               pp("Speed: "..trunc(speed))
               pp("\n -> "..trunc(sum(testShotDelays)/#testShotDelays).." "..trunc(sum(testShotSpeeds)/#testShotSpeeds).." <-")
               testShot = nil
            end
         end
      end
   end

   if not ModuleConfig.debug then
      return
   end
   Circle(GetMousePos(), range, cyanB) 

   PrintState(-6, "Name     CD     Cost     Range")
   PrintState(-5, GetSpellInfo("Q").name.."  "..math.ceil(GetCD("Q")).."  "..GetSpellCost("Q").."  "..GetSpellRange("Q"))
   PrintState(-4, GetSpellInfo("W").name.."  "..math.ceil(GetCD("W")).."  "..GetSpellCost("W").."  "..GetSpellRange("W"))
   PrintState(-3, GetSpellInfo("E").name.."  "..math.ceil(GetCD("E")).."  "..GetSpellCost("E").."  "..GetSpellRange("E"))
   PrintState(-2, GetSpellInfo("R").name.."  "..math.ceil(GetCD("R")).."  "..GetSpellCost("R").."  "..GetSpellRange("R"))

   objects = {}
   for i = 1, objManager.iCount, 1 do
      local object = objManager:GetObject(i)
      if object and object.x and object.charName and
         GetDistance(object, GetMousePos()) < range 
      then
         if not ListContains(object.name, ignoredObjects) then
            if object.type == "AIHeroClient" or object.type == "obj_AI_Minion" then
               table.insert(objects, object.name.."      \""..object.charName.."\"")
               table.insert(objects, "        ("..object.type..")")
            else
               table.insert(objects, object.name)
               table.insert(objects, "        ("..object.type..")")
            end
         end
      end
   end
      
   if #spells > num then   
      for i = 1, #spells - num do
         table.remove(spells, 1)
      end
   end
   
   PrintState(1, "Objects:")
   for i, object in ipairs(objects) do
      PrintState(i+1, objects[i])
   end

   PrintState(21, "Spells")
   for i, spell in ipairs(spells) do
      PrintState(21+i, spells[i])
   end

end

local function onSpell(unit, spell)
   if testShot and IsMe(unit) then
      pp("SpellName:  "..spell.name)
      pp("BoL Windup: "..spell.windUpTime)
   end

   if not ModuleConfig.debug then
      return
   end
   if find(unit.charName, "Minion") then
      return
   end   
   if GetDistance(unit) < range or GetDistance(unit, GetMousePos()) < range then
      if spell.target and spell.target.name then
         table.insert(spells, unit.name.." : "..spell.name.." -> "..spell.target.name)
         pp(unit.name.." : "..spell.name.." -> "..spell.target.name)
      else
         if spell.endPos then
--            if GetDistance(unit, spell.endPos) > GetDistance(unit, EADC) then
--               if math.abs(AngleBetween(unit, EADC) - AngleBetween(unit, spell.endPos)) < 10 then
--                  table.insert(spells, unit.name.." : "..spell.name.." ~> "..EADC.name)                  
--               else
--                  pp(math.abs(AngleBetween(unit, EADC) - AngleBetween(unit, spell.endPos)))
--               end
--            else
--               pp(GetDistance(unit, spell.endPos).." "..GetDistance(unit, EADC))
--            end
         end
         table.insert(spells, unit.name.." : "..spell.name)
         pp(unit.name.." : "..spell.name)
      end
   end
end

function objectFindCreateObject(object)
   if testShot and not testShot.object then
      if GetDistance(object) < 1000 and
         object.name ~= "LineMissile" and
         object.name ~= "missile" and
         not find(object.name, "DrawFX") and
         not find(object.name, "FountainHeal") and
         not find(object.name, "LevelProp") and
         not find(object.name, "Minion") and
         not find(object.name, "Audio") and
         not find(object.name, "Mfx") and
         not find(object.name, "ElixirSight") and
         ( not testShot.name or find(object.name, testShot.name) )
      then
         local exclude = false
         if testShot.excludes then
            for _,cn in ipairs(testShot.excludes) do
               if find(object.name, cn) then
                  exclude = true
                  break
               end
            end
         end
         if not exclude then
            pp("Particle: "..object.name)
            local delay = trunc(time() - testShot.castTime)
            delay = delay
            table.insert(testShotDelays, delay)
            pp("Delay: "..delay)
            testShot.object = object
         end
      end
   end

   if not ModuleConfig.debug then
      return
   end
   if GetDistance(object, GetMousePos()) < range then
      if not ListContains(object.name, ignoredObjects) then
         if object.type == "AIHeroClient" or object.type == "obj_AI_Minion" then
            pp(object.name.."      \""..object.charName.."\"")
            pp("        ("..object.type..")")
         else
            pp(object.name)
            pp("        ("..object.type..")")
         end
      end
   end
end

function TestSkillShot(thing, name, excludes)
   local spell = GetSpell(thing)

   if CanUse(spell) then
      CastXYZ(spell, mousePos)
      testShot = {}
      testShot.spell = spell
      testShot.name = name
      testShot.excludes = excludes
      testShot.castTime = time()
      testShot.points = {}
      testShot.times = {}
      StartChannel(1)
   end
end

AddOnSpell(onSpell)
AddOnCreate(objectFindCreateObject)

AddOnTick(debugTick)
