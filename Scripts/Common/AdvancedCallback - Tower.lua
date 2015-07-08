--[[
    AdvancedCallback - Tower 1.0 by Husky
    ========================================================================

    This is a plugin for the AdvancedCallback library.

    It adds callbacks named OnTowerFocus and OnTowerIdle, that get triggered
    when a tower unit focuses a unit / stops to focus a unit.


    Registered Callbacks
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- gets triggered when a tower focuses a unit (returning false will prevent
    -- the event from being processed by the client)
    OnTowerFocus(tower, unit)

    -- gets triggered when a tower stops to focus a unit (returning false will
    -- prevent the event from being processed by the client)
    OnTowerIdle(tower)


    Changelog
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1.0     - initial release with the most important features
]]

_ENV = AdvancedCallback:register('OnTowerFocus', 'OnTowerIdle')

function OnRecvPacket(p)
    if p.header == Packet.headers.PKT_S2C_TowerAggro then
        local decodedPacket = Packet(p)

        local callbackResult

        if decodedPacket:get('targetNetworkId') ~= 0 then
            callbackResult = AdvancedCallback:OnTowerFocus(objManager:GetObjectByNetworkId(decodedPacket:get('sourceNetworkId')), objManager:GetObjectByNetworkId(decodedPacket:get('targetNetworkId')))
        else
            callbackResult = AdvancedCallback:OnTowerIdle(objManager:GetObjectByNetworkId(decodedPacket:get('sourceNetworkId')))
        end

        if callbackResult == false then p:Block() end
    end
end
