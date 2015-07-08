Vector = {

    -- ===========================

    -- Sets the metatable of the "point" table to

    -- the Vector table. Kind of like dynamic inheritance.

    -- ===========================

    New = function(self, ...)

        local arg = table.pack(...)

        local point = {}

        if type(arg[1]) == "table" then point = arg[1]

        elseif arg[1] and arg[2] then

            point.x = arg[1]

            if arg[3] then

                point.y = arg[2]

                point.z = arg[3]

            else point.z = arg[2]

            end

        else return

        end

        setmetatable(point, {

            __index = self,

            __add = self.Add,

            __sub = self.Sub,

            __eq = self.Equals,

            __unm = self.Negative,

            __mul = self.Mult,

            __div = self.Div,

            __lt = self.Lt,

            __le = self.Le,

            __concat = self.concat,

            __tostring = self.ToString

        })

        return point

    end,



    -- ===========================

    -- Overload the "+" operator

    -- ===========================

    Add = function(self, other)

        return Vector:New({ x = self.x + other.x, y = self.y and self.y + other.y, z = self.z + other.z })

    end,



    -- ===========================

    -- Overload the "-" operator

    -- ===========================

    Sub = function(self, other)

        return Vector:New({ x = self.x - other.x, y = self.y and self.y - other.y, z = self.z - other.z })

    end,



    -- ===========================

    -- Check if the other point is the same as self.

    -- ===========================

    Equals = function(self, other)

        return self.x == other.x and self.y == other.y and self.z == other.z

    end,

    Negative = function(self)

        return Vector:New({ x = -1 * self.x, y = self.y and -1 * self.y, z = -1 * self.z })

    end,

    Mult = function(a, b)

        if type(a) == "number" then

            print("a")

            return Vector:New({ x = b.x * a, y = b.y and b.y * a, z = b.z * a })

        elseif type(b) == "number" then

            print("b")

            return Vector:New({ x = a.x * b, y = a.y and a.y * b, z = a.z * b })

        else return a:DotP(b)

        end

    end,

    Div = function(a, b)

        if type(a) == "number" then

            return Vector:New({ x = a / b.x, y = b.y and a / b.y, z = a / b.z })

        elseif type(b) == "number" then

            return Vector:New({ x = a.x / b, y = a.y and a.y / b, z = a.z / b })

        end

    end,

    Lt = function(a, b)

        return a:Length() < b:Length()

    end,

    Le = function(a, b)

        return a:Length() <= b:Length()

    end,

    concat = function(self, other)

        return tostring(self) .. tostring(other)

    end,

    ToString = function(self)

        if self.y then

            return "(" .. self.x .. "|" .. self.y .. "|" .. self.z")"

        else

            return "(" .. self.x .. "|" .. self.z .. ")"

        end

    end,

    -- ===========================

    -- Computes the angle formed by p1 - self - p2

    -- ===========================



    AngleBetween = function(self, other)

        local theta = math.acos(math.abs(self * other) / (self:Length() * other:Length())) * 180 / math.pi

        if theta < 0.0 then

            theta = theta + 360.0

        end

        if theta > 180.0 then

            theta = 360.0 - theta

        end

        return theta

    end,

    DistanceToPoint = function(self, other)

        return self:Distance(self * (other.x * self.x + (self.y and (other.y * self.y) or 0) + other.z * self.z) / (self.x * self.x + (self.y and (self.y * self.y) or 0) + self.z * self.z))

    end,



    -- ===========================

    -- Get the center between self and the other point.

    -- ===========================

    Center = function(self, otherVector)

        return Vector:New({ x = self.x + (otherVector.x - self.x) / 2, y = self.y and self.y + (otherVector.y - self.y) / 2, z = self.z + (otherVector.z - self.z) / 2 })

    end,



    -- ===========================

    -- Get the distance between myself and the other point.

    -- ===========================

    Distance = function(self, otherVector)

        local dx = (self.x - otherVector.x)

        local dy = (self.y and otherVector.y) and (self.y - otherVector.y) or 0

        local dz = (self.z - otherVector.z)

        return math.sqrt(dx * dx + dy * dy + dz * dz)

    end,

    -- ===========================

    -- Get the CrossProduct

    -- ===========================

    CrossP = function(self, other)

        if self.y then

            return Vector:New({

                x = other.z * self.y - other.y * self.z,

                y = other.x * self.z - other.z * self.x,

                z = other.y * self.x - other.x * self.y

            })

        end

    end,

    DotP = function(self, other)

        return self.x * other.x + (self.y and (self.y * other.y) or 0) + self.z * other.z

    end,

    Length = function(self)

        return math.sqrt(self.x * self.x + (self.y and (self.y * self.y) or 0) + self.z * self.z)

    end,

    Normalize = function(self)

        return self / self:Length()

    end,

    Clone = function(self)

        return Vector:New({ x = self.x, y = self.y, z = self.z })

    end,

}

local mem = {}

function get2DFrom3D(x, y, z)

    if cameraPos.y == 0 then DrawText("Error: cameraPos.y == 0", 12, 100, 100, 0xFFFFFFFF) return -WINDOW_W, -WINDOW_H, false end

    local obj = Vector:New({ x = x - cameraPos.x, y = y - cameraPos.y, z = z - cameraPos.z })

    if mem.camHeigth ~= cameraPos.y then

        mem.camHeigth = cameraPos.y

        local beta, gamma = 9 * math.pi / 180, 50 * math.pi / 180

        local P3_5 = Vector:New({ x = 0, y = obj.y, z = math.tan(beta) * math.abs(obj.y) })

        local P1_5 = Vector:New({ x = 0, y = obj.y, z = math.tan(beta + gamma) * math.abs(obj.y) }); P1_5 = P1_5 * P3_5:Length() / P1_5:Length()

        mem.absHeight = math.sqrt((P1_5.z - P3_5.z) ^ 2 + (P1_5.y - P3_5.y) ^ 2)

        mem.absWidth = mem.absHeight * WINDOW_W / WINDOW_H

        mem.P3 = P3_5 - Vector:New({ x = mem.absWidth / 2, y = 0, z = 0 })

        mem.P2 = P1_5 + Vector:New({ x = mem.absWidth / 2, y = 0, z = 0 })

        mem.n = (mem.P2 - P3_5):CrossP(mem.P3 - P3_5)

    end

    obj = obj * (mem.n.x * mem.P2.x + mem.n.y * mem.P2.y + mem.n.z * mem.P2.z) / (mem.n.x * obj.x + mem.n.y * obj.y + mem.n.z * obj.z)

    local curHeight = math.sqrt((mem.P2.z - obj.z) ^ 2 + (mem.P2.y - obj.y) ^ 2) * ((mem.P2.z - obj.z) / math.abs(mem.P2.z - obj.z))

    local curWidth = obj.x - mem.P3.x

    local x2d = WINDOW_W * curWidth / mem.absWidth

    local y2d = WINDOW_H * curHeight / mem.absHeight

    local onScreen = x2d <= WINDOW_W and x2d >= -WINDOW_W / 3 and y2d >= -50 and y2d <= WINDOW_H + 50

    return x2d, y2d, onScreen

end

--UPDATEURL=
--HASH=9A908AF07D780AACB7C33AD6CA15C92B
