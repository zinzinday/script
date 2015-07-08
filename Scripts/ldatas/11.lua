--[[
    AdvancedCallback - Vision 1.0 by Husky
    ========================================================================

    This is a plugin for the AdvancedCallback library.

    It adds callbacks named OnLoseVision, OnGainVision, OnHideUnit and
    OnShowUnit, that get triggered when units are getting visible/invisible.


    Registered Callbacks
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- gets triggered when you loose vision of a unit, which by default results
    -- in the removal of health bars (returning false will prevent the event
    -- from being processed by the client)
    OnLoseVision(unit)

    -- gets triggered when you gain vision of a unit, which by default results
    -- in the addition of health bars (returning false will prevent the event
    -- from being processed by the client)
    OnGainVision(tower)

    -- gets triggered when a unit is about to get removed from the map by
    -- entering fow or stealth (returning false will prevent the event from
    -- being processed by the client)
    OnHideUnit(unit)

    -- gets triggered when a unit is about to get visible in the game by
    -- leaving fow or stealth (returning false will prevent the event from
    -- being processed by the client)
    OnShowUnit(unit)


    Changelog
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1.0     - initial release with the most important features
]]

_ENV = AdvancedCallback:register('OnLoseVision', 'OnGainVision', 'OnHideUnit', 'OnShowUnit')

function OnRecvPacket(p)
    if p.header == Packet.headers.PKT_S2C_LoseVision then
        local unit = objManager:GetObjectByNetworkId(Packet(p):get('networkId'))

        if unit and unit.valid then
            if AdvancedCallback:OnLoseVision(unit) == false then
                p:Block()
            end
        end
    elseif p.header == Packet.headers.PKT_S2C_GainVision then
        local unit = objManager:GetObjectByNetworkId(Packet(p):get('networkId'))

        if unit and unit.valid then
            if AdvancedCallback:OnGainVision(unit) == false then
                p:Block()
            end
        end
    elseif p.header == Packet.headers.PKT_S2C_HideUnit then
        local unit = objManager:GetObjectByNetworkId(Packet(p):get('networkId'))

        if unit then
            if AdvancedCallback:OnHideUnit(unit) == false then
                p:Block()
            end
        end
    elseif p.header == Packet.headers.R_WAYPOINT then
        local unit = objManager:GetObjectByNetworkId(Packet(p):get('networkId'))

        if unit and unit.valid then
            if AdvancedCallback:OnShowUnit(unit) == false then
                p:Block()
            end
        end
    end
end