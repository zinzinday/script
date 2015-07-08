require "issuefree/timCommon"

-- jungle safe points (can hit camp and they can't hit back)
-- coordinates = {
--    Point(8883, 0, 1921),
--    Point(7444.8, 0, 2980.2),
--    Point(6859.1,0,11497.2),
--    Point(7232.5,0,4671.7),
--    Point(7010.9,0,10021.6),
--    Point(4142.5,0,5695.9),
--    Point(9850.3,0,8781.2),
--    Point(3402.3,0,8429.1),
--    Point(11128.2,0,6225.5),
--    Point(7213.7,0,2103.2),  
--    Point(6905.4,0,12402.2),
--    Point(10270.6,0,4974.5)
-- }

local camps = {
	bWolf = {id=2, timeout=100, num=3},
	rWolf = {id=8, timeout=100, num=3},
	bWraiths = {id=3, timeout=100, num=4},
	rWraiths = {id=9, timeout=100, num=4},
	bWight = {id=13, timeout=100, num=1},
	rWight = {id=14, timeout=100, num=1},
	bBlue = {id=1, timeout=300, num=3},
	rBlue = {id=7, timeout=300, num=3},
	bRed = {id=4, timeout=300, num=3},
	rRed = {id=10, timeout=300, num=3},
	bGolems = {id=5, timeout=100, num=2},
	rGolems = {id=11, timeout=100, num=2},
	dragon = {id=6, timeout=360, num=1},
	baron = {id=12, timeout=420, num=1}
}

if GetGame().map.shortName == "howlingAbyss" then
	camps = {
	-- Howling abyss 
		bInner = {id=4, timeout=40, num=1},
		rInner = {id=3, timeout=40, num=1},
		bOuter = {id=2, timeout=40, num=1},
		rOuter = {id=1, timeout=40, num=1},
	}
end

for _,camp in pairs(camps) do	
	camp.name = "monsterCamp_"..camp.id
	camp.creepNames = {}
	camp.creeps = {}
	for i = 1, camp.num, 1 do
		table.insert(camp.creepNames, camp.id..".1."..i)
	end
end

if GetSpellLevel("Q") > 0 or
	GetSpellLevel("W") > 0 or
	GetSpellLevel("E") > 0
then
	local timers = LoadConfig("jungle")
	if timers then
		for key,nextSpawn in pairs(timers) do
			if camps[key] then
				if 0+nextSpawn > time() then
					camps[key].nextSpawn = 0+nextSpawn
					-- pp("Timer "..key.." "..nextSpawn-time())
				end
			end
		end
	end
end


function saveTimers()
	local timers = {}
	for key,camp in pairs(camps) do
		timers[key] = camp.nextSpawn
	end
	SaveConfig("jungle", timers)
end

function JungleTimer()
	for _,camp in pairs(camps) do
		if camp.object then

			for i,creep in rpairs(camp.creeps) do
				if not creep.valid or not creep.name or not ListContains(creep.name, camp.creepNames) then
					table.remove(camp.creeps, i)
				end
			end

			-- local creeps = GetInRange(me, 1000, camp.creeps)
			-- for i,creep in ipairs(creeps) do
			-- 	PrintState(i, creep.charName.." "..creep.dead)
			-- 	if find(creep.charName, "3.1.3") then
			-- 		Circle(creep)
			-- 	end
			-- end

			if camp.nextSpawn and camp.nextSpawn > time() then
				local tts = math.floor((camp.nextSpawn - time())+.5)
				local perc = tts/camp.timeout
				if perc > .5 then
					color = 0xCCCCCCCC
				elseif perc > .25 then
					color = 0xFFCCCCCC
				elseif perc > .1 then					
					color = 0xFFEEEE33
				else
					color = 0xFF33CC33
				end
				local label = tostring(tts%60)
				if tts > 59 then
					if tts%60 < 10 then
						label = "0"..label
					end
					label = math.floor(tts/60)..":"..label
				end
				minimap = GetMinimap(camp.object)

				Text(label, minimap.x, minimap.y, color, 14)
			end

			if not camp.nextSpawn and #camp.creeps > 0 then
				local campLive = false
				for _,creep in ipairs(camp.creeps) do
					if not creep.dead then
						campLive = true
						break
					end
				end
				if not campLive then
					camp.nextSpawn = math.ceil(time()) + camp.timeout
					saveTimers()
				end
			end
		end
	end

end

function onCreate(object)
	for campName,camp in pairs(camps) do
		if object.name == camp.name then
			-- pp("Adding camp "..campName.." "..object.name)
			camp.object = object
		end
		for _,creepName in ipairs(camp.creepNames) do
			if find(object.name, creepName) and camp.object and GetDistance(camp.object, object) < 1000 then
				-- pp("Adding "..object.name.." to "..campName)
				table.insert(camp.creeps, object)
				camp.nextSpawn = nil
				saveTimers()
			end
		end

		if find(object.name, "Odin_HealthPackHeal") then
			if GetDistance(camp.object, object) < 500 then
				camp.nextSpawn = math.ceil(time()) + camp.timeout
				saveTimers()
			end
		end
	end
end

AddOnCreate(onCreate)

AddOnTick(JungleTimer)