require "issuefree/timCommon"

local ignite = {
   range=600, 
   color=red, 
   base={50}, 
   lvl=20, 
   type="T"
}
local snowball = {
   range=2500,
   color=blue,
   base=20,
   level=10,
   type="T",
   delay=.1, -- tss
   speed=1100, -- tss
   width=50, -- reticle
}

if GetSpellInfo("D").name == "summonerdot" then
   ignite.key = "D"
   spells["ignite"] = ignite
-- print("Ignite in "..ignite.key)
elseif GetSpellInfo("F").name == "summonerdot" then
   ignite.key = "F"
   spells["ignite"] = ignite
-- print("Ignite in "..ignite.key)
end

if GetSpellInfo("D").name == "summonersnowball" then
   snowball.key = "D"
   spells["snowball"] = snowball
-- print("Ignite in "..ignite.key)
elseif GetSpellInfo("F").name == "summonersnowball" then
   snowball.key = "F"
   spells["snowball"] = snowball
-- print("Ignite in "..ignite.key)
end

function igniteTick()
   local inRange = GetInRange(me, "ignite", ENEMIES)
   for _,enemy in ipairs(inRange) do      
      if CanUse("ignite") and WillKill("ignite", enemy) then
         Cast("ignite", enemy)
         PrintAction("Ignite for kill", enemy, 1)
         return true
      end      
   end

   if CanUse("snowball") then
      local targets = SortByDistance(GetGoodFireaheads("snowball", 2))
      if targets[1] then
         CastFireahead("snowball", targets[1])
         PrintAction("Snowball", targets[1])
         return true
      end
   end

end

local function onSpell(unit, spell)
   if spells["ignite"] and CanUse("ignite") then
      if spell.name == "SwainMetamorphism" or     
         spell.name == "Sadism" or
         spell.name == "meditate"         
      then
         if unit.team ~= me.team and GetDistance(unit) < spells["ignite"].range then           
            CastSpellTarget(spells["ignite"].key, unit)
         end
      end
   end
end

if spells["ignite"] then
   AddOnTick(igniteTick)
   AddOnSpell(onSpell)
end
