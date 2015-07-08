--[[
    2D Geometry 1.3 by Husky
    ========================================================================

    Enables you to perform geometric calculations. Since it is focused on a
    2-dimensional euclidean space it is often faster and easier to use than an
    implementation for a 3-dimensional space. It can be used to evaluate the
    position of geometric objects to each other.

    The following classes and methods exist:

    -- Classes ----------------------------------------------------------------

    Point2(x, y)
    Line2(point1, point2)
    Circle2(point1, point2, radius)
    LineSegment2(point1, point2)
    Polygon2(point1, point2, point3, ...)

    -- Common Operations ------------------------------------------------------

    object1:getPoints()
    object1:getLineSegments()
    object1:distance(object2)
    object1:contains(object2)
    object1:insideOf(object2)
    object1:intersectionPoints(object2)

    -- Point2 specific operations ----------------------------------------------

    a point is a vector in the 2d euclidean space and can be used for the usual
    vector calculations like:

    point3 = point1 + point2

    additionally the following methods are supported:

    point:perpendicularFoot(line)
    point:polar()
    point:normalize()
    point:normalized()
    point:clone()

    -- Polygon2 specific operations --------------------------------------------

    polygon:triangulate()

    Changelog
    ~~~~~~~~~

    1.0     - initial release with the most important shapes and operations

    1.1     - replaced triangles and quadrilaterals with the more generic shape polygon 
            - added a unique ID to every single shape to make them identifiable

    1.2     - added option to draw line based shapes
            - fixed a few bugs

    1.3     - added a few missing functions
]]

-- Globals ---------------------------------------------------------------------

uniqueId2 = 0

-- Code ------------------------------------------------------------------------

class 'Point2' -- {
    function Point2:__init(x, y)
        uniqueId2 = uniqueId2 + 1
        self.uniqueId2 = uniqueId2

        self.x = x
        self.y = y

        self.points = {self}
    end

    function Point2:__type()
        return "Point2"
    end

    function Point2:__eq(spatialObject)
        return spatialObject:__type() == "Point2" and self.x == spatialObject.x and self.y == spatialObject.y
    end

    function Point2:__unm()
        return Point2(-self.x, -self.y)
    end

    function Point2:__add(p)
        return Point2(self.x + p.x, self.y + p.y)
    end

    function Point2:__sub(p)
        return Point2(self.x - p.x, self.y - p.y)
    end

    function Point2:__mul(p)
        if type(p) == "number" then
            return Point2(self.x * p, self.y * p)
        else
            return Point2(self.x * p.x, self.y * p.y)
        end
    end

    function Point2:tostring()
        return "Point2(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
    end

    function Point2:__div(p)
        if type(p) == "number" then
            return Point2(self.x / p, self.y / p)
        else
            return Point2(self.x / p.x, self.y / p.y)
        end
    end

    function Point2:between(point1, point2)
        local normal = Line2(point1, point2):normal()

        return Line2(point1, point1 + normal):side(self) ~= Line2(point2, point2 + normal):side(self)
    end

    function Point2:len()
        return math.sqrt(self.x * self.x + self.y * self.y)
    end

    function Point2:normalize()
        len = self:len()

        self.x = self.x / len
        self.y = self.y / len

        return self
    end

    function Point2:clone()
        return Point2(self.x, self.y)
    end

    function Point2:normalized()
        local a = self:clone()
        a:normalize()
        return a
    end

    function Point2:getPoints()
        return self.points
    end

    function Point2:getLineSegments()
        return {}
    end

    function Point2:perpendicularFoot(line)
        local distanceFromLine = line:distance(self)
        local normalVector = line:normal():normalized()

        local footOfPerpendicular = self + normalVector * distanceFromLine
        if line:distance(footOfPerpendicular) > distanceFromLine then
            footOfPerpendicular = self - normalVector * distanceFromLine
        end

        return footOfPerpendicular
    end

    function Point2:contains(spatialObject)
        if spatialObject:__type() == "Line2" then
            return false
        elseif spatialObject:__type() == "Circle2" then
            return spatialObject.point == self and spatialObject.radius == 0
        else
        for i, point in ipairs(spatialObject:getPoints()) do
            if point ~= self then
                return false
            end
        end
    end

        return true
    end

    function Point2:polar()
        if math.close(self.x, 0) then
            if self.y > 0 then return 90
            elseif self.y < 0 then return 270
            else return 0
            end
        else
            local theta = math.deg(math.atan(self.y / self.x))
            if self.x < 0 then theta = theta + 180 end
            if theta < 0 then theta = theta + 360 end
            return theta
        end
    end

    function Point2:insideOf(spatialObject)
        return spatialObject.contains(self)
    end

    function Point2:distance(spatialObject)
        if spatialObject:__type() == "Point2" then
            return math.sqrt((self.x - spatialObject.x)^2 + (self.y - spatialObject.y)^2)
        elseif spatialObject:__type() == "Line2" then
            denominator = (spatialObject.points[2].x - spatialObject.points[1].x)
            if denominator == 0 then
                return math.abs(self.x - spatialObject.points[2].x)
            end

            m = (spatialObject.points[2].y - spatialObject.points[1].y) / denominator

            return math.abs((m * self.x - self.y + (spatialObject.points[1].y - m * spatialObject.points[1].x)) / math.sqrt(m * m + 1))
        elseif spatialObject:__type() == "Circle2" then
            return self:distance(spatialObject.point) - spatialObject.radius
        elseif spatialObject:__type() == "LineSegment2" then
            local t = ((self.x - spatialObject.points[1].x) * (spatialObject.points[2].x - spatialObject.points[1].x) + (self.y - spatialObject.points[1].y) * (spatialObject.points[2].y - spatialObject.points[1].y)) / ((spatialObject.points[2].x - spatialObject.points[1].x)^2 + (spatialObject.points[2].y - spatialObject.points[1].y)^2)

            if t <= 0.0 then
                return self:distance(spatialObject.points[1])
            elseif t >= 1.0 then
                return self:distance(spatialObject.points[2])
            else
                return self:distance(Line2(spatialObject.points[1], spatialObject.points[2]))
            end
        else
            local minDistance = nil

            for i, lineSegment in ipairs(spatialObject:getLineSegments()) do
                if minDistance == nil then
                    minDistance = self:distance(lineSegment)
                else
                    minDistance = math.min(minDistance, self:distance(lineSegment))
                end
            end

            return minDistance
        end
    end
-- }

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

class 'Line2' -- {
    function Line2:__init(point1, point2)
        uniqueId2 = uniqueId2 + 1
        self.uniqueId2 = uniqueId2

        self.points = {point1, point2}
    end

    function Line2:__type()
        return "Line2"
    end

    function Line2:__eq(spatialObject)
        return spatialObject:__type() == "Line2" and self:distance(spatialObject) == 0
    end

    function Line2:getPoints()
        return self.points
    end

    function Line2:getLineSegments()
        return {}
    end

    function Line2:direction()
        return self.points[2] - self.points[1]
    end

    function Line2:normal()
        return Point2(- self.points[2].y + self.points[1].y, self.points[2].x - self.points[1].x)
    end

    function Line2:perpendicularFoot(point)
        return point:perpendicularFoot(self)
    end

    function Line2:side(spatialObject)
        leftPoints = 0
        rightPoints = 0
        onPoints = 0
        for i, point in ipairs(spatialObject:getPoints()) do
            local result = ((self.points[2].x - self.points[1].x) * (point.y - self.points[1].y) - (self.points[2].y - self.points[1].y) * (point.x - self.points[1].x))

            if result < 0 then
                leftPoints = leftPoints + 1
            elseif result > 0 then
                rightPoints = rightPoints + 1
            else
                onPoints = onPoints + 1
            end
        end

        if leftPoints ~= 0 and rightPoints == 0 and onPoints == 0 then
            return -1
        elseif leftPoints == 0 and rightPoints ~= 0 and onPoints == 0 then
            return 1
        else
            return 0
        end
    end

    function Line2:contains(spatialObject)
        if spatialObject:__type() == "Point2" then
            return spatialObject:distance(self) == 0
        elseif spatialObject:__type() == "Line2" then
            return self.points[1]:distance(spatialObject) == 0 and self.points[2]:distance(spatialObject) == 0
        elseif spatialObject:__type() == "Circle2" then
            return spatialObject.point:distance(self) == 0 and spatialObject.radius == 0
        elseif spatialObject:__type() == "LineSegment2" then
            return spatialObject.points[1]:distance(self) == 0 and spatialObject.points[2]:distance(self) == 0
        else
        for i, point in ipairs(spatialObject:getPoints()) do
            if point:distance(self) ~= 0 then
                return false
            end
            end

            return true
        end

        return false
    end

    function Line2:insideOf(spatialObject)
        return spatialObject:contains(self)
    end

    function Line2:distance(spatialObject)
        if spatialObject == nil then return 0 end
        if spatialObject:__type() == "Circle2" then
            return spatialObject.point:distance(self) - spatialObject.radius
        elseif spatialObject:__type() == "Line2" then
            distance1 = self.points[1]:distance(spatialObject)
            distance2 = self.points[2]:distance(spatialObject)
            if distance1 ~= distance2 then
                return 0
            else
                return distance1
            end
        else
            local minDistance = nil
            for i, point in ipairs(spatialObject:getPoints()) do
                distance = point:distance(self)
                if minDistance == nil or distance <= minDistance then
                    minDistance = distance
                end
            end

            return minDistance
        end
    end
-- }

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

class 'Circle2' -- {
    function Circle2:__init(point, radius)
        uniqueId2 = uniqueId2 + 1
        self.uniqueId2 = uniqueId2

        self.point = point
        self.radius = radius

        self.points = {self.point}
    end

    function Circle2:__type()
        return "Circle2"
    end

    function Circle2:__eq(spatialObject)
        return spatialObject:__type() == "Circle2" and (self.point == spatialObject.point and self.radius == spatialObject.radius)
    end

    function Circle2:getPoints()
        return self.points
    end

    function Circle2:getLineSegments()
        return {}
    end

    function Circle2:contains(spatialObject)
        if spatialObject:__type() == "Line2" then
            return false
        elseif spatialObject:__type() == "Circle2" then
            return self.radius >= spatialObject.radius + self.point:distance(spatialObject.point)
        else
            for i, point in ipairs(spatialObject:getPoints()) do
                if self.point:distance(point) >= self.radius then
                    return false
                end
            end

            return true
        end
    end

    function Circle2:insideOf(spatialObject)
        return spatialObject:contains(self)
    end

    function Circle2:distance(spatialObject)
        return self.point:distance(spatialObject) - self.radius
    end

    function Circle2:intersectionPoints(spatialObject)
        local result = {}

        dx = self.point.x - spatialObject.point.x
        dy = self.point.y - spatialObject.point.y
        dist = math.sqrt(dx * dx + dy * dy)

        if dist > self.radius + spatialObject.radius then
            return result
        elseif dist < math.abs(self.radius - spatialObject.radius) then
            return result
        elseif (dist == 0) and (self.radius == spatialObject.radius) then
            return result
        else
            a = (self.radius * self.radius - spatialObject.radius * spatialObject.radius + dist * dist) / (2 * dist)
            h = math.sqrt(self.radius * self.radius - a * a)

            cx2 = self.point.x + a * (spatialObject.point.x - self.point.x) / dist
            cy2 = self.point.y + a * (spatialObject.point.y - self.point.y) / dist

            intersectionx1 = cx2 + h * (spatialObject.point.y - self.point.y) / dist
            intersectiony1 = cy2 - h * (spatialObject.point.x - self.point.x) / dist
            intersectionx2 = cx2 - h * (spatialObject.point.y - self.point.y) / dist
            intersectiony2 = cy2 + h * (spatialObject.point.x - self.point.x) / dist

            table.insert(result, Point2(intersectionx1, intersectiony1))

            if intersectionx1 ~= intersectionx2 or intersectiony1 ~= intersectiony2 then
                table.insert(result, Point2(intersectionx2, intersectiony2))
            end
        end

        return result
    end

    function Circle2:tostring()
        return "Circle2(Point2(" .. self.point.x .. ", " .. self.point.y .. "), " .. self.radius .. ")"
    end
-- }

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

class 'LineSegment2' -- {
    function LineSegment2:__init(point1, point2)
        uniqueId2 = uniqueId2 + 1
        self.uniqueId2 = uniqueId2

        self.points = {point1, point2}
    end

    function LineSegment2:__type()
        return "LineSegment2"
    end

    function LineSegment2:__eq(spatialObject)
        return spatialObject:__type() == "LineSegment2" and ((self.points[1] == spatialObject.points[1] and self.points[2] == spatialObject.points[2]) or (self.points[2] == spatialObject.points[1] and self.points[1] == spatialObject.points[2]))
    end

    function LineSegment2:getPoints()
        return self.points
    end

    function LineSegment2:getLineSegments()
        return {self}
    end

    function LineSegment2:direction()
        return self.points[2] - self.points[1]
    end

    function LineSegment2:len()
        return (self.points[1] - self.points[2]):len()
    end

    function LineSegment2:contains(spatialObject)
        if spatialObject:__type() == "Point2" then
            return spatialObject:distance(self) == 0
        elseif spatialObject:__type() == "Line2" then
            return false
        elseif spatialObject:__type() == "Circle2" then
            return spatialObject.point:distance(self) == 0 and spatialObject.radius == 0
        elseif spatialObject:__type() == "LineSegment2" then
            return spatialObject.points[1]:distance(self) == 0 and spatialObject.points[2]:distance(self) == 0
        else
        for i, point in ipairs(spatialObject:getPoints()) do
            if point:distance(self) ~= 0 then
                return false
            end
            end

            return true
        end

        return false
    end

    function LineSegment2:insideOf(spatialObject)
        return spatialObject:contains(self)
    end

    function LineSegment2:distance(spatialObject)
        if spatialObject:__type() == "Circle2" then
            return spatialObject.point:distance(self) - spatialObject.radius
        elseif spatialObject:__type() == "Line2" then
            return math.min(self.points[1]:distance(spatialObject), self.points[2]:distance(spatialObject))
        else
            local minDistance = nil
            for i, point in ipairs(spatialObject:getPoints()) do
                distance = point:distance(self)
                if minDistance == nil or distance <= minDistance then
                    minDistance = distance
                end
            end

            return minDistance
        end
    end

    function LineSegment2:intersects(spatialObject)
        return #self:intersectionPoints(spatialObject) >= 1
    end

    function LineSegment2:intersectionPoints(spatialObject)
        if spatialObject:__type()  == "LineSegment2" then
            d = (spatialObject.points[2].y - spatialObject.points[1].y) * (self.points[2].x - self.points[1].x) - (spatialObject.points[2].x - spatialObject.points[1].x) * (self.points[2].y - self.points[1].y)

            if d ~= 0 then
                ua = ((spatialObject.points[2].x - spatialObject.points[1].x) * (self.points[1].y - spatialObject.points[1].y) - (spatialObject.points[2].y - spatialObject.points[1].y) * (self.points[1].x - spatialObject.points[1].x)) / d
                ub = ((self.points[2].x - self.points[1].x) * (self.points[1].y - spatialObject.points[1].y) - (self.points[2].y - self.points[1].y) * (self.points[1].x - spatialObject.points[1].x)) / d

                if ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1 then
                    return {Point2 (self.points[1].x + (ua * (self.points[2].x - self.points[1].x)), self.points[1].y + (ua * (self.points[2].y - self.points[1].y)))}
                end
            end
        end

        return {}
    end

    function LineSegment2:draw(color, width)
        drawLine(self, color or 0XFF00FF00, width or 4)
    end
-- }

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

class 'Polygon2' -- {
    function Polygon2:__init(...)
        uniqueId2 = uniqueId2 + 1
        self.uniqueId2 = uniqueId2

        self.points = {...}
    end

    function Polygon2:__type()
        return "Polygon2"
    end

    function Polygon2:__eq(spatialObject)
        return spatialObject:__type() == "Polygon2" -- TODO
    end

    function Polygon2:getPoints()
        return self.points
    end

    function Polygon2:addPoint(point)
        table.insert(self.points, point)
        self.lineSegments = nil
        self.triangles = nil
    end

    function Polygon2:getLineSegments()
        if self.lineSegments == nil then
            self.lineSegments = {}
            for i = 1, #self.points, 1 do
                table.insert(self.lineSegments, LineSegment2(self.points[i], self.points[(i % #self.points) + 1]))
            end
        end

        return self.lineSegments
    end

    function Polygon2:contains(spatialObject)
        if spatialObject:__type() == "Line2" then
            return false
        elseif #self.points == 3 then
            for i, point in ipairs(spatialObject:getPoints()) do
                corner1DotCorner2 = ((point.y - self.points[1].y) * (self.points[2].x - self.points[1].x)) - ((point.x - self.points[1].x) * (self.points[2].y - self.points[1].y))
                corner2DotCorner3 = ((point.y - self.points[2].y) * (self.points[3].x - self.points[2].x)) - ((point.x - self.points[2].x) * (self.points[3].y - self.points[2].y))
                corner3DotCorner1 = ((point.y - self.points[3].y) * (self.points[1].x - self.points[3].x)) - ((point.x - self.points[3].x) * (self.points[1].y - self.points[3].y))

                if not (corner1DotCorner2 * corner2DotCorner3 >= 0 and corner2DotCorner3 * corner3DotCorner1 >= 0) then
                    return false
                end
            end

            if spatialObject:__type() == "Circle2" then
                for i, lineSegment in ipairs(self:getLineSegments()) do
                    if spatialObject.point:distance(lineSegment) <= 0 then
                        return false
                    end
                end
            end

            return true
        else
            for i, point in ipairs(spatialObject:getPoints()) do
                inTriangles = false
                for j, triangle in ipairs(self:triangulate()) do
                    if triangle:contains(point) then
                        inTriangles = true
                        break
                    end
                end
                if not inTriangles then
                    return false
                end
            end

            return true
        end
    end

    function Polygon2:insideOf(spatialObject)
        return spatialObject.contains(self)
    end

    function Polygon2:direction()
        if self.directionValue == nil then
            local rightMostPoint = nil
            local rightMostPointIndex = nil
            for i, point in ipairs(self.points) do
                if rightMostPoint == nil or point.x >= rightMostPoint.x then
                    rightMostPoint = point
                    rightMostPointIndex = i
                end
            end

            rightMostPointPredecessor = self.points[(rightMostPointIndex - 1 - 1) % #self.points + 1]
            rightMostPointSuccessor   = self.points[(rightMostPointIndex + 1 - 1) % #self.points + 1]

            z = (rightMostPoint.x - rightMostPointPredecessor.x) * (rightMostPointSuccessor.y - rightMostPoint.y) - (rightMostPoint.y - rightMostPointPredecessor.y) * (rightMostPointSuccessor.x - rightMostPoint.x)
            if z > 0 then
                self.directionValue = 1
            elseif z < 0 then
                self.directionValue = -1
            else
                self.directionValue = 0
            end
        end

        return self.directionValue
    end

    function Polygon2:triangulate()
        if self.triangles == nil then
            self.triangles = {}

            if #self.points > 3 then
                tempPoints = {}
                for i, point in ipairs(self.points) do
                    table.insert(tempPoints, point)
                end
        
                triangleFound = true
                while #tempPoints > 3 and triangleFound do
                    triangleFound = false
                    for i, point in ipairs(tempPoints) do
                        point1Index = (i - 1 - 1) % #tempPoints + 1
                        point2Index = (i + 1 - 1) % #tempPoints + 1

                        point1 = tempPoints[point1Index]
                        point2 = tempPoints[point2Index]

                        if ((((point1.x - point.x) * (point2.y - point.y) - (point1.y - point.y) * (point2.x - point.x))) * self:direction()) < 0 then
                            triangleCandidate = Polygon2(point1, point, point2)

                            anotherPointInTriangleFound = false
                            for q = 1, #tempPoints, 1 do
                                if q ~= i and q ~= point1Index and q ~= point2Index and triangleCandidate:contains(tempPoints[q]) then
                                    anotherPointInTriangleFound = true
                                    break
                                end
                            end

                            if not anotherPointInTriangleFound then
                                table.insert(self.triangles, triangleCandidate)
                                table.remove(tempPoints, i)
                                i = i - 1

                                triangleFound = true
                            end
                        end
                    end
                end

                if #tempPoints == 3 then
                    table.insert(self.triangles, Polygon2(tempPoints[1], tempPoints[2], tempPoints[3]))
                end
            elseif #self.points == 3 then
                table.insert(self.triangles, self)
            end
        end

        return self.triangles
    end

    function Polygon2:intersects(spatialObject)
        for i, lineSegment1 in ipairs(self:getLineSegments()) do
            for j, lineSegment2 in ipairs(spatialObject:getLineSegments()) do
                if lineSegment1:intersects(lineSegment2) then
                    return true
                end
            end
        end

        return false
    end

    function Polygon2:distance(spatialObject)
        local minDistance = nil
        for i, lineSegment in ipairs(self:getLineSegment()) do
            distance = point:distance(self)
            if minDistance == nil or distance <= minDistance then
                minDistance = distance
            end
        end

        return minDistance
    end

    function Polygon2:tostring()
        local result = "Polygon2("

        for i, point in ipairs(self.points) do
            if i == 1 then
                result = result .. point:tostring()
            else
                result = result .. ", " .. point:tostring()
            end
        end

        return result .. ")"
    end

    function Polygon2:draw(color, width)
        for i, lineSegment in ipairs(self:getLineSegments()) do
            lineSegment:draw(color, width)
        end
    end
-- }

--UPDATEURL=
--HASH=D2B91CB3DD8DD8D77245E8208C402F15
