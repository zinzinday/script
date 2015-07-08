--target_prediction by grey (0.4c) Modified by Mariopart for BoL
TargetPrediction = {}
player = GetMyHero()
function TargetPrediction:new()
    local index = { memory = {}, minions = {}, time = os.clock() }
    setmetatable(index, { __index = TargetPrediction })
    return index
end

function TargetPrediction:tick()
    local time = os.clock()
    if not self.executeTime or time - self.executeTime > 0.35 then
        self.executeTime = time
        for i = 0, heroManager.iCount, 1 do
            local target = heroManager:GetHero(i)
            if target and target.team ~= player.team then --clear dead targets
                if target.dead then
                    self.memory[target.name] = nil
                elseif target.visible then
                    if self.memory[target.name] then
                        local deltaTime = time - self.memory[target.name].time
                        self.memory[target.name].movement = {
                            x = (target.x - self.memory[target.name].position.x) / deltaTime,
                            z = (target.z - self.memory[target.name].position.z) / deltaTime
                        }
                        self.memory[target.name].healthDifference = (target.health - self.memory[target.name].health) / deltaTime
                        self.memory[target.name].health = target.health
                        self.memory[target.name].position = { x = target.x, z = target.z }
                        self.memory[target.name].time = time
                    else
                        self.memory[target.name] = { position = { x = target.x, z = target.z }, time = time, health = target.health, i = i }
                    end
                end
            end
        end
    end
end


function TargetPrediction:GetPrediction(target_name, range, proj_speed, delay, width, smoothness)
    local function getDistance(x1, z1, x2, z2)
        return math.sqrt((x1 - x2) * (x1 - x2) + (z1 - z2) * (z1 - z2))
    end

    local player = GetMyHero()
    local time = os.clock()
    if self.memory[target_name] and self.memory[target_name].movement then
        local proj_speed = proj_speed and proj_speed * 1000
        local delay = delay and delay / 1000
        local target = heroManager:GetHero(self.memory[target_name].i)
        if player:GetDistance(target) < range + 300 then
            if time - (self.memory[target_name].calculateTime or 0) > 0 then
                self.memory[target_name].calculateTime = time
                local playerPos = { x = player.x, z = player.z }
                local latency = GetLatency() / 1000
                self.memory[target_name].minions = false
                local PositionPrediction
                if target.visible then
                    PositionPrediction =
                    {
                        x = target.x + self.memory[target_name].movement.x * ((delay or 0) + (latency or 0)),
                        z = target.z + self.memory[target_name].movement.z * ((delay or 0) + (latency or 0))
                    }
                elseif os.clock() - self.memory[target_name].time < 3 then
                    PositionPrediction =
                    {
                        x = self.memory[target_name].position.x + self.memory[target_name].movement.x * ((delay or 0) + (latency or 0) + time - self.memory[target.name].time),
                        z = self.memory[target_name].position.z + self.memory[target_name].movement.z * ((delay or 0) + (latency or 0) + time - self.memory[target.name].time)
                    }
                else self.memory[target_name] = nil return
                end
                local t
                if proj_speed and proj_speed > 0 then
                    local a, b, c = PositionPrediction, self.memory[target_name].movement, playerPos
                    local d, e, f, g, h, i, j, k, l = (-a.x + c.x), (-a.z + c.z), b.x * b.x, b.z * b.z, proj_speed * proj_speed, a.x * a.x, a.z * a.z, c.x * c.x, c.z * c.z
                    t = (-(math.sqrt(-f * (l - 2 * c.z * a.z + j) + 2 * b.x * b.z * d * e - g * (k - 2 * c.x * a.x + i) + (k - 2 * c.x * a.x + l - 2 * c.z * a.z + i + j) * h) - b.x * d - b.z * e)) / (f + g - h)
                    PositionPrediction =
                    {
                        x = a.x + b.x * t or 0,
                        z = a.z + b.z * t or 0
                    }
                end
                if smoothness and smoothness < 100 and self.memory[target_name].PositionPrediction then
                    self.memory[target_name].PositionPrediction =
                    {
                        x = PositionPrediction.x * ((100 - smoothness) / 100) + self.memory[target_name].PositionPrediction.x * (smoothness / 100),
                        z = PositionPrediction.z * ((100 - smoothness) / 100) + self.memory[target_name].PositionPrediction.z * (smoothness / 100)
                    }
                else
                    self.memory[target_name].PositionPrediction = PositionPrediction
                end
                local distance = getDistance(playerPos.x, playerPos.z, PositionPrediction.x, PositionPrediction.z)
                if not range or distance < range then
                    self.memory[target_name].healthPrediction = target.health + self.memory[target_name].healthDifference * ((t or 0) + (delay or 0) + (latency or 0))
                    if width then
                        for i = 0, objManager.maxObjects, 1 do
                            local minion = objManager:getObject(i)
                            if minion and minion.ms == 325 and minion.team ~= player.team and not minion.dead and minion.visible and string.find(minion.name, "Minion_") then
                                local distanceToMinion = player:GetDistance(minion)
                                if distanceToMinion < distance and distanceToMinion > 0 then
                                    local flying = {
                                        x = PositionPrediction.x - player.x,
                                        z = PositionPrediction.z - player.z
                                    }
                                    t = ((-(player.x * flying.x - flying.x * minion.x + (player.z - minion.z) * flying.z)) / (flying.x ^ 2 + flying.z ^ 2))
                                    if t and getDistance(player.x + (flying.x * t), player.z + (flying.z * t), minion.x, minion.z) <= width / 2 then self.memory[target_name].minions = true break end
                                end
                            end
                        end
                    end
                else return
                end
            end
            return self.memory[target_name].PositionPrediction, self.memory[target_name].minions, self.memory[target_name].healthPrediction
        end
    end
end

--UPDATEURL=
--HASH=45A4D9E37F67B524985035C691B4E177
