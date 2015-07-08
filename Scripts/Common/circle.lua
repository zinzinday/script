Circle = {
        -- ===========================
        -- Creates a new circle of the specified center and radius.
        -- ===========================
        New = function(self)    
                local c = {}
                setmetatable(c, {__index = self})
                return c
        end,
        
        -- ===========================
        -- Determines if the point is contained within the circle.
        -- ===========================
        Contains = function(self, point)
                return point:Distance(self.center) < self.radius 
                                or math.abs(point:Distance(self.center) - self.radius) < 1e-9
        end,
        
        -- ===========================
        -- Get the string representation of the circle.
        -- ===========================
        ToString = function(self)
                return "{center: " .. self.center:ToString() .. ", radius: " .. tostring(self.radius) .. "}"
        end,
}

--UPDATEURL=
--HASH=DFF53B1696382A1AD91741494BD49C38
