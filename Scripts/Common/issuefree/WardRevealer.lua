require "issuefree/timCommon"

local showTimerRadius = 100
local showVisionRangeKey = 18
local showSameTeam = false

local types = {
   { label="Trinket Ward", color=yellowB, mm="W",
     duration=60, 
     sightRange=1350, triggerRange=70,
     name="SightWard", 
     charName="YellowTrinket", 
     spellName="RelicSmallLantern" 
   },
   { label="Trinket Ward", color=yellowB, mm="W",
     duration=120, sightRange=1350, triggerRange=70, 
     name="SightWard", 
     charName="YellowTrinketUpgrade", 
     spellName="RelicLantern" 
   },
   { label="Sight Ward", color=greenB, mm="W",
     duration=180, sightRange=1350, triggerRange=70,
     name="SightWard", 
     charName="SightWard", 
     spellName="SightWard" 
   }, 
   { label="Sight Ward", color=greenB, mm="W",
     duration=180, sightRange=1350, triggerRange=70, 
     name="SightWard", 
     charName="SightWard", 
     spellName="wrigglelantern" 
   },
   { label="Vision Ward", color=violetB, mm="W",
     duration=0, sightRange=1350, triggerRange=70, 
     name="VisionWard", 
     charName="VisionWard", 
     spellName="VisionWard" 
   },

   { label="Jack in the Box", color=redB, mm="J",
     duration=60, sightRange=690, triggerRange=300,
     name="Jack In The Box", 
     charName="ShacoBox", 
     spellName="JackInTheBox" 
   },
   { label="Shroom", color=redB, mm="T",
     duration=600, sightRange=405, triggerRange=115, 
     name="Noxious Trap", 
     charName="TeemoMushroom", 
     spellName="BantamTrap" 
   },
   { label="Yordle Trap", color=redB, mm="C",
     duration = 240, sightRange=150, triggerRange=150,
     name="Cupcake Trap", 
     charName="CaitlynTrap", 
     spellName="CaitlynYordleTrap" 
   }, 
   { label="Bushwhack", color=yellowB, mm="T",
     duration = 240, sightRange=0, triggerRange=150,
     name="Noxious Trap", 
     charName="Nidalee_Spear", 
     spellName="Bushwhack" 
   }
}

local wardSpots = {
        -- ward spots
        { x = 2850,    y = 45.84,  z = 7575},     -- BLUE GOLEM
        { x = 7422,    y = 46.53,  z = 3282},     -- BLUE LIZARD
        { x = 10148,   y = 44.41,  z = 2839},     -- BLUE TRI BUSH
        { x = 6269,    y = 42.51,  z = 4445},     -- BLUE PASS BUSH
        { x = 7406,    y = 43.31,  z = 4995},     -- BLUE RIVER ENTRANCE
        { x = 4325,    y = 44.38,  z = 7041.54},  -- BLUE ROUND BUSH
        { x = 4728,    y = -51.29, z = 8336},     -- BLUE RIVER ROUND BUSH
        { x = 6598,    y = 46.15,  z = 2799},     -- BLUE SPLIT PUSH BUSH
 
        { x = 11183,   y = 45.75,  z = 6899},     -- PURPLE GOLEM
        { x = 6661,    y = 44.46,  z = 11197},    -- PURPLE LIZARD
        { x = 3883,    y = 39.87,  z = 11577},    -- PURPLE TRI BUSH
        { x = 7775,    y = 43.14,  z = 10046.49}, -- PURPLE PASS BUSH
        { x = 6625.47, y = 47.66,  z = 9463},     -- PURPLE RIVER ENTRANCE
        { x = 9658,    y = 45.79,  z = 7556},     -- PURPLE ROUND BUSH
        { x = 9300,    y = -73.46, z = 6128},     -- PURPLE RIVER ROUND BUSH
        { x = 7490,    y = 41,     z = 11681},    -- PURPLE SPLIT PUSH BUSH
 
        { x = 3527.43, y = -74.95, z = 9534.51},  -- NASHOR
        { x = 10473,   y = -73,    z = 5059},     -- DRAGON
}

local timerColor = 0xFFFFFFFF

local wards = {}
local showVisionRange = false

function Tick()
   if IsKeyDown(showVisionRangeKey) then 
      showVisionRange = true
   else 
      showVisionRange = false 
   end
   
   cleanUpWards()
   drawWards()
end

function drawWards()
   for i,ward in ipairs(wards) do 
      local timer = string.format(math.ceil((ward.tick+ward.duration-time())))
      Circle(ward, ward.triggerRange, ward.color)
      TextMinimap(ward.mm, ward, ward.color, 14)
      if showVisionRange then             
         Circle(ward, ward.sightRange, ward.color)
      end
      if GetDistance(ward, GetMousePos()) < showTimerRadius then
         if ward.source == "onload" then
            TextObject(ward.label..": max "..timer, ward, timerColor)
         else
            TextObject(ward.label..": "..timer, ward, timerColor)
         end
      end
   end

   if GetMap() == 1 then
      for _,spot in ipairs(wardSpots) do
         Circle(Point(spot), 25, yellow, 2)
      end 
   end
end

function cleanUpWards()
   for i,ward in rpairs(wards) do
      if ward.source ~= "spell" then
         if not ward.object or not ward.object.x then
            table.remove(wards,i)
            break
         end
      end
      if ward.duration > 0 and time()-ward.tick >= ward.duration then
         table.remove(wards,i)
      end
   end
end

function addWard(ward, type)
   ward = merge(ward, type)

   --check for dups
   for i,w in rpairs(wards) do
      if GetDistance(w, ward) < 100 and
         math.abs(w.tick - ward.tick) < 1 and
         w.label == ward.label
      then
         if ward.source == "spell" then  -- don't add spells if the obj exists
            return
         else
            table.remove(wards, i)
            break
         end
      end
   end
   table.insert(wards, ward)
   -- pp("Adding ward")
   -- pp(ward)
end

local function onCreate(object)
   if not showSameTeam and object.team == me.team then
      return
   end

   -- for _,ward in ipairs(wards) do
   --    if GetDistance(ward, object) < 100 then
   --       pp(object)
   --    end
   -- end

   for _,type in ipairs(types) do
      if object.name == type.name and
         object.charName == type.charName
      then
         local ward = {object=object, tick=time(), source="oncreate"}
         ward = merge(ward, Point(object))
         if LOADING then
            ward.source = "onload"
         end
         addWard(ward, type)
         break
      end
   end

   if find(object.name, "caitlyn_Base_yordleTrap_trigger") then
      SortByDistance(wards, object)
      for i,ward in ipairs(wards) do
         if ward.name == "CaitlynYordleTrap" and GetDistance(object, ward) < 100 then
            table.remove(wards, i)
            -- pp("remove cait trap")
            break
         end
      end
   end
   if find(object.name, "JackintheboxPoof") then
      SortByDistance(wards, object)
      for i,ward in ipairs(wards) do
         if ward.name == "Jack In The Box" and GetDistance(object, ward) < 100 then
            table.remove(wards, i)
            -- pp("remove shaco box")
            break
         end
      end
   end
   if find(object.name, "Nidalee_Base_W_Tar") then
      SortByDistance(wards, object)
      for i,ward in ipairs(wards) do
         if ward.name == "Noxious Trap" and GetDistance(object, ward) < 100 then
            table.remove(wards, i)
            -- pp("remove nid trap")
            break
         end
      end
   end   
   if find(object.name, "Teemo_Base_R_tar") then
      SortByDistance(wards, object)
      for i,ward in ipairs(wards) do
         if ward.name == "Noxious Trap" and GetDistance(object, ward) < 100 then
            table.remove(wards, i)
            -- pp("remove shroom")
            break
         end
      end
   end
end

local function onSpell(unit, spell)
   if IsHero(unit) and (showSameTeam or IsEnemy(unit)) then
      for _,type in ipairs(types) do
         if type.spellName == spell.name then
            local ward = {tick=time(), source="spell"}
            ward = merge(ward, Point(spell.endPos))
            addWard(ward, type)
            break
         end
      end
   end
end


AddOnCreate(onCreate)
AddOnSpell(onSpell)

AddOnTick(Tick)