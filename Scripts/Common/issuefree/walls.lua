require "issuefree/telemetry"

local EDITMODE = false

RES = 50

MAPNAME = nil
SUMMONERSRIFT = "SummonersRift"
HOWLINGABYSS = "HowlingAbyss"

if GetGame().map.shortName == "summonerRift" then
   MAPNAME = SUMMONERSRIFT
elseif GetMap() == 2 then
   MAPNAME = CRYSTALSCAR
elseif GetMap() == 3 then
   MAPNAME = TWISTEDTREELINE
elseif GetMap() == 6 then
   MAPNAME = HOWLINGABYSS
end

local POINTS = {}


local function pointToIndex(p)
   return math.ceil(p.x/RES+.5), math.ceil(p.z/RES+.5)
end

local function getPoint(p)
   local ix,iy = pointToIndex(p)
   if POINTS[ix] then
      return POINTS[ix][iy]
   end
   return nil
end

local function isPoint(p)
   if p and (p.x > 0 or p.y > 0 or p.z > 0) then
      return true
   end
   return false
end

local function getNearPoints(p)
   local ix,iy = pointToIndex(p)
   local near = {}
   local np = Point(POINTS[ix][iy])
   for i=ix-1,ix+1,1 do
      for j=iy-1,iy+1,1 do
         if POINTS[i] and POINTS[i][j] and isPoint(POINTS[i][j]) then
            table.insert(near, POINTS[i][j])
         end
      end
   end
   return near
end

local function isEdge(p)
   return #getNearPoints(p) < 9
end

local function removePoint(ix, iy)
   local p = POINTS[ix][iy]
   if p.x ~= 0 or p.y ~= 0 or p.z ~= 0 then
      local col = POINTS[ix]
      col[iy] = Point(0,0,0)
      return true
   end

   return false
end

local function cascadeDelete(point)
   local ix,iy = pointToIndex(point)
   removePoint(ix,iy)
   for _,np in ipairs(getNearPoints(point)) do
      if isPoint(np) then
         cascadeDelete(np)
      end
   end
end

local function deleteClose(point)
   local ix,iy = pointToIndex(point)
   removePoint(ix,iy)
   for _,np in ipairs(getNearPoints(point)) do
      removePoint(pointToIndex(np))
   end
end

local function createClose(point)
   local ix,iy = pointToIndex(point)
   POINTS[ix][iy] = point
   for i=ix-2,ix+2,1 do
      for j=iy-2,iy+2,1 do
         POINTS[i][j] = Point((i-1)*RES,0,(j-1)*RES)
      end
   end
end


local function drawPoints()
   for _,nrp in ipairs(noReachPoints) do
      if isPoint(getPoint(nrp)) then 
         Circle(nrp, 12, blue)
      end
   end

   for _,col in ipairs(POINTS) do
      for _,p in ipairs(col) do

         if isPoint(p) and (isEdge(p) or GetDistance(p) < 500 or GetDistance(mousePos, p) < 200) then
            if p.y ~= 0 then
               if isEdge(p) then
                  Circle(p, 8, red)
               else
                  -- Circle(p, 5, green)
               end
            else
               local dp = Point(p)
               dp.y = me.y
               if isEdge(dp) then
                  Circle(dp, 8, red)
               else
                  -- Circle(dp, 5)
               end
            end
         end
      end
   end 
end

local function savePoints()
   if MAPNAME then
      pp("Saving Points")

      for i,col in ipairs(POINTS) do
         for j,p in ipairs(col) do
            if isEdge(p) and #getNearPoints(p) <= 2 then
               POINTS[i][j] = Point(0,0,0)
            end
         end
      end

      local file = io.open("issuefree/"..MAPNAME..".wall", "w")

      for _,row in ipairs(POINTS) do
         for _,p in ipairs(row) do
            if p and isPoint(p) then
               file:write(p.x..","..p.y..","..p.z.."\n")
            end
         end
      end
      file:close()
   else
      pp("Unknown map")
   end
end

local function loadPoints()
   if MAPNAME then
      local f = io.open("issuefree/"..MAPNAME..".wall", "r")
      if not f then
         POINTS = {}
         for x=1,14500/RES,1 do
            POINTS[x] = {}
            for z=1,14500/RES,1 do
               table.insert(POINTS[x], Point(x*RES,0,z*RES))
            end
         end
         pp("Creating map: "..MAPNAME)
         savePoints()
         return true
      else
         f.close()
         POINTS = {}
         for x=1,14500/RES,1 do      
            POINTS[x] = {}
            for z=1,14500/RES,1 do
               table.insert(POINTS[x], Point(0,0,0))
            end
         end
         for line in io.lines("issuefree/"..MAPNAME..".wall") do
            for x,y,z in string.gmatch(line, "(%d+),([-]*%d+),(%d+)") do
               local p = Point(x,y,z)
               local ix,iy = pointToIndex(p)
               if POINTS[ix] and POINTS[ix][iy] then
                  POINTS[ix][iy] = p
               end
            end
         end
         pp("Loaded "..MAPNAME)
         return true
      end
   else
      return false
   end
end

-- POINTS = {}
-- for x=1,13000/RES,1 do      
--    POINTS[x] = {}
--    for z=1,13000/RES,1 do
--       table.insert(POINTS[x], Point(x*RES,0,z*RES))
--    end
-- end

-- SavePoints()

local function checkPoints()
   for _,p in ipairs(getNearPoints(me)) do
      if isPoint(p) then
         local ix,iy = pointToIndex(p)
         -- if ix < 10 or iy > 245 or ix > 255 or iy < 9 then
         --    removePoint(ix, iy)
         -- end
         -- if GetDistance(p, mousePos) < 50 and p.y == 0 then
         --    p.y = mousePos.y
         --    needSave = true
         -- end
         if GetDistance(p) < 30 then
            removePoint(ix,iy)
         end
         if GetDistance(p) < 100 and p.y == 0 then
            POINTS[ix][iy].y = math.floor(me.y)
         end
         if #getNearPoints(p) <= 2 then
            removePoint(ix,iy)
         end
      end
   end
end

noReachPoints = {}
targetPoint = nil
distToTargetPoint = nil

function chasePoints()
   if targetPoint then
      if GetDistance(targetPoint) < distToTargetPoint then
         distToTargetPoint = GetDistance(targetPoint)
         me.MoveTo(targetPoint.x, targetPoint.z)
         return
      else
         table.insert(noReachPoints, targetPoint)
         if #noReachPoints > 100 then
            table.remove(noReachPoints,1)
         end
         targetPoint = nil
      end
   end
   local ix,iy = pointToIndex(me)
   local np = Point(POINTS[ix][iy])
   local near = {}
   for i=ix-7,ix+7,1 do
      for j=iy-7,iy+7,1 do
         if POINTS[i] and POINTS[i][j] and isPoint(POINTS[i][j]) then
            local cp = POINTS[i][j]
               for _,nrp in ipairs(noReachPoints) do
                  if cp:near(nrp) then
                     cp = nil
                     break
                  end
               end
               if cp and isEdge(cp) and GetDistance(cp) > 2*RES then
                  table.insert(near, cp)
               end
         end
      end
   end
   if #near > 0 then
      targetPoint = SortByDistance(near)[1]
      me.MoveTo(targetPoint.x, targetPoint.z)
      distToTargetPoint = GetDistance(targetPoint)
   end
end

LOAD = true

local chase = false
local function Tick()
   if #ALLIES > 1 then
      EDITMODE = false
   end
   if LOAD then
      if MAPNAME then
         pp("Identified "..MAPNAME)
      end

      if loadPoints() then
         LOAD = false
      end
   end

   if EDITMODE and #POINTS > 0 then
      if KeyDown(string.byte("X")) then
         cascadeDelete(Point(mousePos))
      end

      if KeyDown(string.byte("C")) then
         deleteClose(Point(mousePos))
      end

      if KeyDown(string.byte("V")) then
         createClose(Point(mousePos))
      end

      if KeyDown(string.byte("S")) then
         savePoints()
      end

      if KeyDown(string.byte("J")) then
         chase = not chase
      end

      if chase then
         PrintState(0, "CHASING")
         chasePoints()
      end
      checkPoints() 
      drawPoints()
   end

end

local function onCreate(object)
end

AddOnCreate(onCreate)
AddOnTick(Tick)

function IsWall(p)
   local ix, iy = pointToIndex(p)
   if not POINTS[ix] or not POINTS[ix][iy] then
      return false
   end
   return isPoint(POINTS[ix][iy])
end

function WillCollide(s, t)
   local dist = GetDistance(s,t)
   local cp = s
   cp = Projection(cp,t,RES/4)
   while GetDistance(s, cp) < dist do
      if IsWall(cp) then --or #getNearPoints(cp) >= 1 then
         return cp
      end
      cp = Projection(cp,t,RES/4)
   end
   return nil
end

function GetNearestWall(target, dist)
   local wallPoint
   local wallDist
   local points = GetCircleLocs(target, dist)
   for _,point in ipairs(points) do
      local cp = WillCollide(target, point)
      if cp and ( not wallPoint or GetDistance(cp) < wallDist ) then
         wallPoint = cp
         wallDist = GetDistance(cp)
      end
   end
   if wallPoint then
      return wallPoint
   end
end
