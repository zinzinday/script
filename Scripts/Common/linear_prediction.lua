do
    local player = GetMyHero()
    LinearPrediction = {}

    function LinearPrediction:new(range, proj_speed)
        local object = { range = range, proj_speed = proj_speed, memory = {}, prediction = {} }
        setmetatable(object, { __index = LinearPrediction })
        return object
    end

    function LinearPrediction:check_if_target(obj)
        return obj ~= nil and obj.team ~= player.team and obj.dead == false and obj.visible == true
    end

    function LinearPrediction:tick()
        local count = heroManager.iCount
        local position, v, ft, dt

        for i = 1, count, 1 do
            local object = heroManager:getHero(i)
            if self:check_if_target(object) and (player:GetDistance(object) <= self.range or self.range == 0) then
                if self.memory[object.name] then
                    ft = player:GetDistance(object) / self.proj_speed
                    dt = GetTickCount() - self.memory[object.name].t
                    position = Vector:New(object.x, object.z)
                    local old_position = self.memory[object.name].p
                    local dp = position - old_position
                    self.prediction[object.name] = position + ((dp) / dt) * ft
                end
                self.memory[object.name] = { p = Vector:New(object.x, object.z), t = GetTickCount() }
            else
                self.prediction[object.name] = nil
            end
        end
    end

    function LinearPrediction:getPredictionFor(champ_name)
        return self.prediction[champ_name]
    end
end

--UPDATEURL=
--HASH=9B26AB73BC3C78A6FF54A5453D76B3FB
