_ENV = AdvancedCallback:register("OnDash")
function OnRecvPacket(p)
  do
    if p.header == 100 then
      p.pos = 11
      waypointCount = p:Decode1() / 2
      networkID = p:DecodeF()
      speed = p:DecodeF()
      p.pos = 24
      x = p:DecodeF()
      z = p:DecodeF()
      p.pos = 33
      if objManager:GetObjectByNetworkId(networkID) and objManager:GetObjectByNetworkId(networkID).valid then
        p.pos = 49
        wayPoints = Packet.decodeWayPoints(p, waypointCount)
        startPos = Vector(x, objManager:GetObjectByNetworkId(networkID).y, z)
        endPos = Vector(wayPoints[#wayPoints].x, objManager:GetObjectByNetworkId(networkID).y, wayPoints[#wayPoints].y)
        distance = GetDistance(endPos, startPos)
        time = distance / speed
        if AdvancedCallback:OnDash(objManager:GetObjectByNetworkId(networkID), {
          startPos = startPos,
          endPos = endPos,
          distance = distance,
          speed = speed,
          target = objManager:GetObjectByNetworkId(p:DecodeF()),
          duration = time,
          startT = GetGameTimer(),
          endT = GetGameTimer() + time
        }) == false then
          p:Block()
        end
      end
    end
  end
end
