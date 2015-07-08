require "issuefree/timCommon"


function assTick()
   if not ModuleConfig.ass then
      return
   end

   for _,enemy in ipairs(ENEMIES) do
      if IsValid(enemy) then
         local spells = GetSpellShots(enemy.name)
         if spells then
            for _,spell in pairs(spells) do
               if spell.perm and spell.key and GetSpellInfo(spell.key).level > .5 then

                  if spell.ss and spell.isline then
                     if GetDistance(enemy) < GetSpellRange(spell) and GetSpellInfo(spell.key).currentCd < 1 then
                        if spell.block then
                           local unblocked = GetUnblocked(spell, enemy, MYMINIONS, ALLIES)
                           for _,test in ipairs(unblocked) do
                              if IsMe(test) then
                                 LineBetween(enemy, me, spell.radius)
                                 break
                              end
                           end
                        else
                           LineBetween(enemy, me, spell.radius)
                        end
                     end
                  end

                  if not spell.ss and GetSpellInfo(spell.key).currentCd < 1 then
                     Circle(enemy, GetSpellRange(spell), red, 2)
                  end

               end
            end
         end
      end
   end
end

AddOnTick(assTick)