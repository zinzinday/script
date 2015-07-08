require "issuefree/telemetry"

-- circle colors
yellowB  = 0xFFFFFF00
yellow = 0x75FFFF00
greenB   = 0xFF00FF00
green  = 0x7500FF00
redB     = 0xFFFF0000
red    = 0x75FF0000
blueB    = 0xFF0000FF
blue   = 0x750000FF
cyanB    = 0xFF00FFFF
cyan   = 0x7500FFFF
violetB  = 0xFFFF00FF
violet = 0x75FF00FF
violetD = 0x25FF00FF

-- text colors
yellowT = 0xFFFFFF00
greenT  = 0xFF00FF00
redT    = 0xFFFF0000
blueT   = 0xFF00FFFF

local function isSafe(object)
	if not object or
		not object.x or not object.z --or
		--( type(object) == "userdata" and ( not object.valid or ( object.x ~= mousePos.x and object.z ~= mousePos.z )))
	then
		return false
	end
	return true
end

function LineObject(source, length, angle, width, color)
	width = width or 1
	color = color or cyan

	p1 = WorldToScreen(D3DXVECTOR3(source.x, source.y, source.z))
	local proj = ProjectionA(source, angle, length)
	p2 = WorldToScreen(D3DXVECTOR3(proj.x, proj.y, proj.z))

	table.insert(DRAWS, {DrawLine, {p1.x, p1.y, p2.x, p2.y, width, color}})
end

function LineBetween(object1, object2, width, color)	
	if not isSafe(object1) or not isSafe(object2) then 
		pp("bad object in linebetween")
		return 
	end

	width = width or 1
	color = color or cyan

   local p1 = WorldToScreen(D3DXVECTOR3(object1.x, object1.y, object1.z))
   local p2 = WorldToScreen(D3DXVECTOR3(object2.x, object2.y, object2.z))

   table.insert(DRAWS, {DrawLine, {p1.x, p1.y, p2.x, p2.y, width, color}})
end

DRAWS = {}
function Text(text, x, z, color, size)
	size = size or 14
	table.insert(DRAWS, {DrawText, {tostring(text), size, x, z, color}})
end

function TextObject(text, object, color, size)
	if not isSafe(object) then
		pp("Bad object in TextObject")
		return
	end
	size = size or 14
	table.insert(DRAWS, {DrawText3D, {tostring(text), object.x, object.y, object.z, size, color, true}})
end

function TextMinimap(label, object, color, size)
	color = color or cyan
	size = size or 14
	local minimap = GetMinimap(object)
	Text(label, minimap.x, minimap.y, color, size)
end

function Circle(target, radius, color, thickness)	
	if not isSafe(target) then
		if not target then
			return
		end
		pp(debug.traceback())
		pp("Bad object in circle")
		return
	end

	thickness = thickness or 1
	color = color or yellow
	radius = radius or GetWidth(target)

	if radius > 2000 then
		return
	end

	table.insert(DRAWS, {DrawCircle3D, {target.x, target.y, target.z, radius, thickness, color, 50}})
end

function DoDraws()
	while #DRAWS > 0 do
		-- a = DRAWS[1][2]
		-- DRAWS[1][1](a[1], a[2], a[3], a[4], a[5])
		DRAWS[1][1](table.unpack(DRAWS[1][2]))
		table.remove(DRAWS, 1)
	end
end

-- from sxorbwalk
function DrawRectangleAL(x, y, w, h, color)
   local Points = {}
   Points[1] = D3DXVECTOR2(math.floor(x), math.floor(y))
   Points[2] = D3DXVECTOR2(math.floor(x + w), math.floor(y))
   table.insert(DRAWS, {DrawLines2, {Points, math.floor(h), color}})
end