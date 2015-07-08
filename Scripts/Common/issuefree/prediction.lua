require "issuefree/basicUtils"
require "issuefree/telemetry"
require "issuefree/spellDefs"

function PredictEnemy(unit, spell)
   -- if IsEnemy(unit) then
   if IsHero(unit) then
      local def = GetSpellDef(unit.charName, spell.name)
      if def and def.type then
         local predName = unit.charName..".pred"
         local pred = PersistTemp(predName, def.duration or .5)
         pred.enemy = unit
         local point
         if def.type == "dash" then
            if def.ends == "max" then
               point = Projection(unit, spell.endPos, def.range)
            elseif def.ends == "reverse" then
               point = Projection(unit, spell.endPos, -def.range)
            elseif def.ends == "point" then
               if GetDistance(unit, spell.endPos) > def.range then
                  point = Projection(unit, spell.endPos, def.range)
               else
                  point = Point(spell.endPos)
               end
            elseif def.ends == "target" then
               if def.overShoot then
                  point = OverShoot(unit, spell.target, def.overShoot)
               else
                  point = Point(spell.target)
               end
            end
         elseif def.type == "stall" then
            point = Point(unit)
         end
         if not point then
            pp(def)
            pp(spell)
         end
         pred.x = point.x
         pred.y = point.y
         pred.z = point.z
      end
   end
end

function checkSpells()
	for _,hero in ipairs(concat(ALLIES, ENEMIES)) do
		local defs = PREDICTION_DEFS[hero.charName]
		if defs and defs.keys then
			for _,key in ipairs(defs.keys) do
				local sn = hero["SpellName"..key]
				if not defs[sn] then
					pp(hero.charName.."."..key)
					pp(sn)
					defs[sn] = {}
				end
			end
		end
	end
end

function Tick()
	-- checkSpells()
end

AddOnTick(Tick)