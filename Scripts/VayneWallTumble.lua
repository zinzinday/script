if myHero.charName ~= "Vayne" or not VIP_USER then return end

local class,myHero,_Q,GetDistanceSqr,mousePos,Point,DrawCircle,ARGB,HookPackets,CastSpell,AddSendPacketCallback,AddDrawCallback,AddCastSpellCallback,AddTickCallback = class,myHero,_Q,GetDistanceSqr,mousePos,Point,DrawCircle,ARGB,HookPackets,CastSpell,AddSendPacketCallback,AddDrawCallback,AddCastSpellCallback,AddTickCallback

class "VayneWallTumble"
function VayneWallTumble:__init()
    print("<font color=\"#FF794C\"><b>VanyeWallTumble: </b></font> <font color=\"#FFDFBF\">Loaded for Patch 5.7</b></font>")
    self.CastPacketHeader = 0x00E9
    self.doTumble = false
    self.blockNext = false
    self.pointDrake = Point(12060, 4806)
    self.pointMidLane = Point(6962, 8952)
    self.color = {red = ARGB(0xFF,0xFF,0,0), green = ARGB(0xFF,0,0xFF,0)}
    AddSendPacketCallback(function(p) self:SendPacket(p) end)
    AddDrawCallback(function() self:Draw() end)
    AddCastSpellCallback(function(iSpell) self:CastSpell(iSpell) end)
    AddTickCallback(function() self:Tick() end)
end

function VayneWallTumble:CastSpell(iSpell)
    if iSpell == _Q and not self.doTumble then
        if  GetDistanceSqr(mousePos, self.pointDrake) < 80^2 then
            myHero:MoveTo(12060, 4806)
            self.doTumble = 1
            self.blockNext = true
        end

        if GetDistanceSqr(mousePos, self.pointMidLane) < 80^2 then
            myHero:MoveTo(6962, 8952)
            self.doTumble = 2
            self.blockNext = true
        end
    elseif self.doTumble then
        self.doTumble = false
    end
end

function VayneWallTumble:SendPacket(p)
    if p.header == self.CastPacketHeader and self.blockNext then
        self.blockNext = false
        p:Block()
    end
end

function VayneWallTumble:Draw()
    if GetDistanceSqr(mousePos, self.pointDrake) > 80^2 then
        DrawCircle(12060, 51, 4806,80, self.color.red)
    else
        DrawCircle(12060, 51, 4806,80, self.color.green)
    end

    if GetDistanceSqr(mousePos, self.pointMidLane) > 80^2 then
        DrawCircle(6962, 51, 8952,80, self.color.red)
    else
        DrawCircle(6962, 51, 8952,80, self.color.green)
    end
end

function VayneWallTumble:Tick()
    if self.doTumble == 1 then
        if myHero.x == 12060 and myHero.z == 4806 then
            CastSpell(_Q,11745.198242188,4625.4379882813)
        else
            myHero:MoveTo(12060, 4806)
        end
    elseif self.doTumble == 2 then
        if myHero.x == 6962 and myHero.z == 8952 then
            CastSpell(_Q,6667.3271484375,8794.64453125)
        else
            myHero:MoveTo(6962, 8952)
        end
    end
end

function OnLoad()
    if HookPackets then HookPackets() end
    VayneWallTumble()
end