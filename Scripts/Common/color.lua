-----------------------------------------------------------------------------
--  COLOR LIBRARY v1.0.2
--  Converts RGB colors to hex values and finds colors on a given gradient
--    scale.
--
--  Changelog:
--    v1.0
--      Initial Release
--    v1.0.1
--      Uses ARGB instead of RGB
--    v1.0.2
--      DrawCircle expects hex to be a number so we work around the fact that
--        it's hard to turn our hex codes into a number.
--
-----------------------------------------------------------------------------
--  Usage                 How to use
-----------------------------------------------------------------------------
--  x = Color(a,r,g,b)
--    Table 'x' with keys a, r, g and b. Color should only be passed numbers
--      between 0 and 255. It can also be passed the hex value of a color.
--  Example:
--    slateblue = Color(255,106,90,205)
--    midnightblue = Color("0xFF191970")
--    lightgrey = Color("ffd3d3d3")
--    return lightgrey.r
--    >> 211
--    return midnightblue.g
--    >> 25
-----------------------------------------------------------------------------
--  x.hex
--    The hex value of table 'x'. Is dynamic.
--  Example:
--    slateblue = Color(255,106,90,205)
--    return slateblue.hex
--    >> 0xFF6A5ACD
--    return slateblue.r
--    >> 106
--    slateblue.b = 210
--    return slateblue.hex
--    >> 0xFF6A5AD2
-----------------------------------------------------------------------------
--  x = Color.Transition(y, z, step)
--  x = y:Transition(z, step)
--    Table 'x' with keys a, r, g, and b is 'step' between color 'y' and color
--      'z'. Step should be a number between 0 and 1.
--  Example:
--    slateblue = Color(255,106,90,205)
--    lightgrey = Color("ffd3d3d3")
--    firstnewcolor = Color.Transition(slateblue, lightgrey, 0.3)
--    secondnewcolor = slateblue:Transition(lightgrey,0.5)
--    return firstnewcolor.hex
--    >> 0xFF897ECE
--    return secondnewcolor.hex
--    >> 0xFF9E96D0
--    return firstnewcolor.b
--    >> 206
--    firstnewcolor.b = 255
--    return firstnewcolor.hex
--    >> 0xFF897EFF
-----------------------------------------------------------------------------

Color = {}

do

local function RGBToHex(color)
  ---------------------------------------------------------------------------
  --  Expects a table with r, g, and b keys
  ---------------------------------------------------------------------------
  if type(color) == "table" then
    local hex = string.format("0x%.2X%.2X%.2X%.2X", color.a, color.r, color.g, color.b)
    return assert(loadstring("return "..hex))()
  end
end

local function HexToRGB(color)
  ---------------------------------------------------------------------------
  --  Expects a 6 digit hex value with or without the 0x prefix
  ---------------------------------------------------------------------------
  color = string.gsub(color, "0x", "")
  newcolor = {
    a = tonumber((string.sub(color,1,2)),16),
    r = tonumber((string.sub(color,3,4)),16),
    g = tonumber((string.sub(color,5,6)),16),
    b = tonumber((string.sub(color,7,8)),16)
  }
  return newcolor
end

local function Transition(from, to, step)
  local newcolor = {a=0,r=0,g=0,b=0}
  if step > 1 then
    step = 1
  elseif step < 0 then
    step = 0
  end
  for i,v in pairs(newcolor) do
    newcolor[i] = math.floor(from[i] + ((to[i] - from[i]) * step))
  end
  return Color.New(newcolor)
end

local function __index(t,key)
  if key == "hex" then
    return Color.RGBToHex(t)
  else
    return Color[key]
  end
end

local function New(a,r,g,b)
  local newcolor
  if type(a) == "string" then
    newcolor = Color.HexToRGB(a)
  elseif type(a) == "table" then
    newcolor = a
  else
    newcolor = { a = a or 0, r = r or 0, g = g or 0, b = b or 0 }
  end
  setmetatable(newcolor, Color)
  return newcolor
end

Color.RGBToHex = RGBToHex
Color.HexToRGB = HexToRGB
Color.Transition = Transition
Color.__index = __index
Color.New = New

end -- do block

setmetatable(Color, {__call = function(_, ...) return Color.New(...) end})

--UPDATEURL=
--HASH=A1162998EDE1EB02136CF3920501D303
