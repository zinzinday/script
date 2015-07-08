--[[
    AdvancedCallback - Aggro 1.1 by Husky
    ========================================================================

    This is a plugin for the AdvancedCallback library.

    It adds callbacks named OnGainAggro and OnLoseAggro, that get triggered
    when another unit focuses you / stops to focus you with spells or
    attacks.

    Hint: Aggro is a jargon word in LoL, probably originally derived from the
    English words "aggravation" or "aggression", and used since at least the
    1960s in British slang. In games, such as LoL, aggro denotes the
    aggressive interests of an enemy unit.


    Registered Callbacks
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- gets triggered when an enemy units focuses you with spells or attacks
    -- (returning false will prevent the event from being processed by the client)
    OnGainAggro(unit)

    -- gets triggered when an enemy units stops to focus you with spells or
    -- attacks (returning false will prevent the event from being processed
    -- by the client)
    OnLoseAggro(unit)


    Changelog
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1.0     - initial release with the most important features

    1.1     - added support for blocking client side event by return false
]]

_ENV = AdvancedCallback:register('OnGainAggro', 'OnLoseAggro')

function OnRecvPacket(p)
    if p.header == Packet.headers.PKT_S2C_Aggro then
        local decodedPacket = Packet(p)

        local callbackResult

        if decodedPacket:get('targetNetworkId') ~= 0 then
            callbackResult = AdvancedCallback:OnGainAggro(objManager:GetObjectByNetworkId(decodedPacket:get('sourceNetworkId')))
        else
            callbackResult = AdvancedCallback:OnLoseAggro(objManager:GetObjectByNetworkId(decodedPacket:get('sourceNetworkId')))
        end

        if callbackResult == false then p:Block() end
    end
end