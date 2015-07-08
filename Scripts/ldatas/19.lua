_ENV = AdvancedCallback:register('OnDash', 'OnDashFoW')

function OnRecvPacket(p)
    if p.header == 99 then 
        p.pos = 11
        waypointCount = p:Decode1()/2
        networkID = p:DecodeF()
        speed = p:DecodeF()
        p.pos = 24 
        x = p:DecodeF()
        z = p:DecodeF()
        p.pos = 33
        local targetTo = objManager:GetObjectByNetworkId(p:DecodeF())

        local target = objManager:GetObjectByNetworkId(networkID)
        if target and target.valid then 
            p.pos = 49
            wayPoints = Packet.decodeWayPoints(p,waypointCount)

            startPos = Vector(x, target.y, z)
            endPos = Vector(wayPoints[#wayPoints].x, target.y, wayPoints[#wayPoints].y)
            distance = GetDistance(endPos, startPos)
            time = distance / speed
            if AdvancedCallback:OnDash(target, {startPos = startPos, endPos = endPos, distance = distance, speed = speed, target = targetTo, duration = time, startT = GetGameTimer(), endT=GetGameTimer()+time})  == false then 
                p:Block()
            end 
        end 
    elseif p.header == 186 then
        p.pos = 30
        mode = p:Decode1()
        if mode == 1 then 
            p.pos = 35
            waypointCount = p:Decode1()/2
            networkID = p:DecodeF()
            speed = p:DecodeF()
            p.pos = p.pos + 4
            x = p:DecodeF()
            z = p:DecodeF()
            p.pos = p.pos + 1
            local targetTo = objManager:GetObjectByNetworkId(p:DecodeF())
            local target = objManager:GetObjectByNetworkId(networkID)
            if target and target.valid then 
                p.pos = 73
                wayPoints = Packet.decodeWayPoints(p,waypointCount)

                startPos = Vector(x, target.y, z)
                endPos = Vector(wayPoints[#wayPoints].x, target.y, wayPoints[#wayPoints].y)
                distance = GetDistance(endPos, startPos)
                time = distance / speed
                if AdvancedCallback:OnDashFoW(target, {startPos = startPos, endPos = endPos, distance = distance, speed = speed, target = targetTo, duration = time, startT = GetGameTimer(), endT=GetGameTimer()+time})  == false then 
                    p:Block()
                end 
            end 
        end
    end 
end