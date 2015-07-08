--[[

Tim's modified version of...
    Spell Shot Library 1.2 by Chad Chen
    			This script is modified from lopht's skillshots.
    -------------------------------------------------------
            Usage:
            			require "spell_shot"

            			function OnProcessSpell(unit,spell)
            				local spellShot = SpellShotTarget(unit, spell, target)
            				if spellShot then
            					-- spell will hit the target
            				end
            			end
--]]


-- 1. detect the spell
-- 2. who's it going to hit
-- 3. if it's me find a good safepoint
-- TODO there seem to be errors here. I get safepoints that don't make sense. Hard to debug.
-- 4. move to the safepoint
-- TODO Improve the "juking" ie I know where I'm going (CURSOR) so move enough out of my way then continue going there

-- TODO I'd like to get the speeds/objects on the skill shots to improve the "is it going to hit a teammate" logic for shields

require "issuefree/telemetry"
-- require "issuefree/walls"
require "issuefree/basicUtils"
require "issuefree/spellDefs"

function GetSpellShots(name)
	return SPELL_DEFS[name]
end

function GetSpellShot(unit, spell)
	local shot = copy(GetSpellDef(unit.charName, spell.name))
	if shot then
		shot.startPoint = Point(unit)
		shot.endPoint = spell.endPos
		shot.timeOut = os.clock()+shot.time

		SetEndPoints(shot)

		return shot
	else
		return nil
	end
end

function SetEndPoints(shot)
	if shot.range and shot.ss then
		if shot.point or not shot.isline then
			if GetDistance(shot.startPoint, shot.endPoint) > shot.range then
				shot.endPoint = Projection(shot.startPoint, shot.endPoint, shot.range)
			end
			if shot.name == "ZiggsQ" then
				local bounceDist = GetDistance(shot.startPoint, shot.endPoint)*1.5
				shot.endPoint = Projection(shot.startPoint, shot.endPoint, bounceDist)
			end
			shot.maxDist = GetDistance(shot.startPoint, shot.endPoint) + shot.radius
		else
			shot.endPoint = Projection(shot.startPoint, shot.endPoint, shot.range)
			shot.maxDist = shot.range + shot.radius
		end
	end
end

local function isSafe(safePoint, shot)
	if not safePoint then
		return false
	end

	if shot.range and shot.isline and not shot.point then
		local dist = GetDistance(shot.startPoint, safePoint)

		if dist < shot.maxDist then
			local impactPoint = Projection(shot.startPoint, shot.endPoint, dist)
			local impactDistance = GetDistance(impactPoint, safePoint)
			if impactDistance <= shot.safeDist then -- hit
				return false
			end
		end
	else
		if GetDistance(safePoint, shot.endPoint) < shot.safeDist then
			return false
		end
	end
	return true
end

function SpellShotTarget(unit, spell, target)
	if unit and spell and unit.team ~= target.team then
		local shot = GetSpellShot(unit, spell)
		return ShotTarget(shot, target)
	end
	return nil
end

function ShotTarget(shot, target)
	if shot and shot.ss then
		
		shot.safeDist = shot.radius + GetWidth(target)

		if not IsMe(target) and not isSafe(target, shot) then
			shot.target = target
			return shot
		end

		-- calculate a safe point if I'm the target
		if IsMe(target) and not isSafe(me, shot) then
			shot.target = me
			local impactPoint = shot.endPoint
			if shot.isline and not shot.point then
				-- if the spell were cast directly at me it would hit me here
				impactPoint = Projection(shot.startPoint, shot.endPoint, GetDistance(shot.startPoint))
			end
			
			-- is where I'll be clear?
			local safePoint = ProjectionA(me, GetMyDirection(), me.ms*.75)
			if isSafe(safePoint, shot) then
				-- pp("Current movement will take me safe")
				if isSafe(CURSOR, shot) then
					safePoint = Point(CURSOR)
					-- pp("  cursor safe")
				end
			end

			if not isSafe(safePoint, shot) then					
				-- pp("Current move not safe")
				safePoint = Projection(impactPoint, target, shot.safeDist)
				-- pp("moving orthog")
				-- pp("start "..Point(shot.startPoint))
				-- pp("end   "..Point(shot.endPoint))
				-- pp("orthag "..safePoint)
			end

			if IsWall(safePoint:vector()) then -- if safe is into a wall go the other direction
				pp("Safepoint is in a wall")
				safePoint = nil
				local locs = SortByDistance(GetCircleLocs(impactPoint, shot.safeDist))
				for _,loc in ipairs(locs) do
					if not IsWall(loc) and isSafe(loc, shot) then
						safePoint = loc
						pp("nearest nonwall safepoint "..safePoint)
						break
					end
				end
			end

			-- -- if I'm moving and the safepoint is out of my way don't bother
			-- if safePoint then
			-- 	if GetDistance(me, GetMyLastPosition()) > 0 then
			-- 		local ra = RadsToDegs(RelativeAngle(me, safePoint, ProjectionA(me, GetMyDirection(), 50)))
			-- 		pp("safepoint is "..ra.." degrees off path")
			-- 		if RadsToDegs(RelativeAngle(me, safePoint, ProjectionA(me, GetMyDirection(), 50))) > 45 then
			-- 			safePoint = nil
			-- 		end
			-- 	end
			-- end

			if safePoint then					
				shot.safePoint = Projection(me, safePoint, GetDistance(safePoint)+50)
				-- pp("Final safepoint "..shot.safePoint)
			else
				pp("No safe point dodging "..shot.name)
			end

			return shot
		end
	end
	return nil
end