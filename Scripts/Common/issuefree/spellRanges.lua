require "issuefree/timCommon"

function rangeTick()
   if not ModuleConfig.ranges then
      return
   end
   if me.dead then
      return
   end

   for name,info in pairs(spells) do
      if info.range and info.color and 
         ( not info.key or 
           ( #info.key == 1 and GetSpellLevel(info.key) > 0 ) or
           info.summoners )
      then
         local range = GetSpellRange(info)
         if info.rangeType and info.rangeType == "e2e" then
            range = range + GetWidth(me)/2
         end
         local time 
         if info.key then
            time = GetSpellInfo(info).currentCd + 1
            -- me["SpellTime"..info.key] - 2
         end

         if name == "AA" then
            if CanAttack() then
               Circle(me, range, info.color, 4)
            elseif IsAttacking() then

            elseif os.clock() - getNextAttackTime() < 0 then
               time = os.clock() - getNextAttackTime() - 1
               Circle(me, range/(-time*-time), info.color)
               Circle(me, range, redS)
            end
         else
            if time and time > 1 then
               Circle(me, range/(-time*-time), info.color)
            else
               Circle(me, range, info.color, 2)
            end
         end
      end   
   end
   
   local ranges = {}
   for name, item in pairs(ITEMS) do
      if GetInventorySlot(item.id) and item.range and item.color then
         local range = item.range
         while ranges[range] do
            range = range+1
         end
         Circle(me, range, item.color)
         ranges[range] = true
      end
   end 
   
end

AddOnDraw(rangeTick)
