--[[
    Prediction calculation example v0.1
    Written by h0nda
]]
-- linear prediction with constant time
player = GetMyHero()


LinearPredictionConstT = {}

function LinearPredictionConstT:new(range, time)
    local object = { range = range, time = time, memory={}, prediction={}}
    setmetatable(object, { __index = LinearPredictionConstT }) 
    return object
end

function LinearPredictionConstT:check_if_target(obj)
   return obj ~= nil and  obj.team ~= player.team and obj.dead == false and obj.visible == true
end

function LinearPredictionConstT:tick()

   local count = heroManager.iCount
   local position, v,ft,dt
    for i = 1, count, 1 do
        local object = heroManager:getHero(i) 
        if self:check_if_target(object)  and (player:GetDistance(object)<=self.range or self.range ==0 )then
            if self.memory[object.name] then
              ft = self.time
              dt = GetTickCount()-self.memory[object.name].t
               position =  Vector:New({x=object.x,z=object.z})
               old_position = self.memory[object.name].p
               dp = position-old_position
               self.prediction[object.name]=position+((dp)/dt)*ft
            end
            self.memory[object.name]={p=Vector:New(object.x,object.z),t=GetTickCount()}
        else
            self.prediction[object.name]=nil
        end
    end
end

function LinearPredictionConstT:getPredictionFor(champ_name)
    return self.prediction[champ_name]
end

--UPDATEURL=
--HASH=CE64C0E6E1C4BB1AB7575E610E5311CB
