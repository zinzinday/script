require "issuefree/timCommon"

local loadTime = time()

function AutoLane()
   if not ModuleConfig.autolane or time() - loadTime < 5 then
      return
   end

   -- Circle(Projection(HOME, me, GetDistance(HOME, me)+500))
   local enemyTurret = SortByDistance(TURRETS, me)[1]

   if not enemyTurret or not enemyTurret.x then
      return
   end

   local myTurret = SortByDistance(MYTURRETS, enemyTurret)[1]

   if not myTurret then
      return
   end

   local pointMinion = Point(SortByDistance(MYMINIONS, enemyTurret)[1])
   if not pointMinion:valid() then
      return
   end
   Circle(pointMinion)
   local p = Projection(HOME, pointMinion, GetDistance(HOME, pointMinion)-200)

   if IsAttacking() then
      loc = nil
   end

   if p and not UnderTower(p) and GetDistance(p) > 250 and CanMove() then
      Circle(p)
      me:MoveTo(p.x, p.z)
   -- Circle(pointMinion)
   -- elseif CanMove() and not loc then
   --    local dist = 150
   --    local angle = math.random(0, math.pi/2)
   --    loc = ProjectionA(me, angle, dist)
   --    Circle(loc)
   --    -- local loc = Point(me) + Point(math.random(-150, 150), 0, math.random(-150, 150))
   --    MoveToXYZ(loc:unpack())
   end


   KillMinion("AA")
end

AddOnTick(AutoLane)