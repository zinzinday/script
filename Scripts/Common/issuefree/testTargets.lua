require "issuefree/timCommon"

local offsets
local targets

function updateTargets()
	targets = {}
	for _,offset in ipairs(offsets) do
		table.insert(targets, {x=mousePos.x+offset.x, y=offset.y, z=mousePos.z+offset.z, width=offset.width})
	end
end

function TestTick()
   if not ModuleConfig.testtargets then
      return
   end

   -- Testoffsets1()
   RandomSpread(12, 1000)

   updateTargets()
	
   for _,t in ipairs(targets) do
      Circle(t, nil, yellow)
   end
end


function TestTargets()
	return targets
end

function TargetSet1()
	if not offsets then
	   table.insert(offsets, {x=100, y=me.y, z=100, width=50})
	   table.insert(offsets, {x=200, y=me.y, z=100, width=50})
	   table.insert(offsets, {x=100, y=me.y, z=55, width=50})
	   table.insert(offsets, {x=70, y=me.y, z=250, width=50})
	   table.insert(offsets, {x=25, y=me.y, z=125, width=50})
   end
end

function RandomSpread(number, range)
	if not offsets then
		offsets = {}
		math.randomseed(time())
		for i=1,number do
			local a = math.random() * 2*math.pi
			local d = math.random(range)
			table.insert(offsets, {x=math.sin(a)*d, y=me.y, z=math.cos(a)*d, width=50})
		end
	end
end

local function onKey(msg, key)
   if msg == KEY_UP then
      if key == 107 then
         offsets = nil
      end
   end
end


AddOnKey(onKey)

AddOnTick(TestTick)