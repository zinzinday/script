--------------------------------------------------------------------------------
--
--    Packet 1.0.15 by Husky
--    ========================================================================
--
--    This library enables you to decode and encode packets without knowing
--    anything about packets at all.
--
--    The following examples show how to use the library:
--
--    -- Send Packets (encode) -------------------------------------------------
--
--    Packet('S_PING', {x = mousePos.x, y = mousePos.y}):send()
--
--    -- Receive Packets (decode) ----------------------------------------------
--
--    local packet = Packet(packetRecevivedFromCallback)
--
--    PrintChat(packet:get('name'))
--    PrintChat(packet:get('targetNetworkId'))
--
--    Changelog
--    ~~~~~~~~~
--
--    1.0     - initial release with some of the packets
--
--    1.0.1   - added spellId translation for S_CAST packets
--            - added S_MOVE packets
--
--    1.0.2   - added a spellId mapping to decode changed cast packets
--
--    1.0.3   - added a method to receive packets
--
--    1.0.6   - added a lot of packets
--
--    1.0.7   - added PKT_S2C_Aggro
--
--    1.0.8   - added PKT_S2C_TowerAggro and PKT_S2C_LevelUpSpell
--
--    1.0.9   - added PKT_S2C_HideUnit, PKT_S2C_GainVision and PKT_S2C_LoseVision
--
--    1.0.10  - fixed a problem with the update packet, replaced GetMap()
--
--    1.0.11  - added encoding function for PKT_S2C_Neutral_Camp_Empty
--
--    1.0.12  - removed R_UPDATE (will be added as a separate plugin)
--            - added VIP checks to only load when nessecary
--
--    1.0.13  - added the ability to encode R_WAYPOINTS
--            - added monitoring of sequence numbers accessible through
--              Packet.lastSequenceNumber
--            - added caching of encoding results to improve performance
--
--   1.0.14   - fixed changed headers
--
--   1.0.15   - added additional headers
--
--------------------------------------------------------------------------------

if VIP_USER then
    class 'Packet' -- {
        Packet.lastPIndex = false

        Packet.decodedValues = false

        Packet.lastSequenceNumber = 0

        -- packet headers ------------------------------------------------------

        Packet.headers = {
            -- SEND PACKETS
            PKT_World_SendCamera_Server = 0x2D,
            S_PING                      = 0x56,
            S_CAST                      = 0x99,
            S_MOVE                      = 0x71,
            PKT_NPC_UpgradeSpellReq     = 0x38,
            PKT_BuyItemReq              = 0x81,
            PKT_RemoveItemReq           = 0x09,
            PKT_SwapItemReq             = 0x20,

            -- RECEIVE PACKETS
            PKT_S2C_Aggro               = 0xBF,
            PKT_S2C_TowerAggro          = 0x69,
            PKT_S2C_LevelUpSpell        = 0x15,
            PKT_S2C_HideUnit            = 0x50,
            PKT_S2C_GainVision          = 0xAD,
            PKT_S2C_LoseVision          = 0x34,
            PKT_RemoveItemAns           = 0x0B,
            PKT_SwapItemAns             = 0x3D,

            PKT_World_SendCamera_Server_Acknologment = 0x2B,
            PKT_WHTAEVER = 0x87,
            PKT_S2C_Neutral_Camp_Empty = 0xC2, -- unsure if fixed - but not really used anyway
            PKT_S2C_CreateNeutral      = 0x62,
            PKT_S2C_IncreaseExperience = 0x10,
            PKT_S2C_ScoreUpdate        = 0xA2,
            R_PING                     = 0x3F,
            R_DESTROY_INVISIBLE_OBJECT = 0x07, -- unsure if fixed - but not really used anyway
            R_APPLY_VISION_BUFF        = 0x23, -- unsure if fixed - but not really used anyway
            R_REMOVE_VISION_BUFF       = 0x32, -- unsure if fixed - but not really used anyway
            R_WAYPOINTS                = 0x60,
            R_WAYPOINT                 = 0xB9
        }

        -- packet definitions ------------------------------------------------------

        Packet.definition = {
            -- SEND PACKETS
            PKT_World_SendCamera_Server_Acknologment = {
                decode = function(p)
                    p.pos = 5

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        sequenceNumber = p:Decode1()
                    }
                end
            },

            PKT_World_SendCamera_Server = {
                decode = function(p)
                    p.pos = 5

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        x = p:DecodeF(),
                        y = p:DecodeF(),
                        z = p:DecodeF(),
                        a1 = p:Decode4(),
                        a2 = p:Decode4(),
                        a3 = p:Decode4(),
                        a4 = p:Decode4(),
                        a5 = p:Decode1()
                    }
                end
            },
            S_PING = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        x = mousePos.x,
                        y = mousePos.z,
                        targetNetworkId = 0,
                        type = PING_NORMAL
                    }
                end,

                decode = function(p)
                    p.pos = 5

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        x = p:DecodeF(),
                        y = p:DecodeF(),
                        targetNetworkId = p:DecodeF(),
                        type = p:Decode1()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.S_PING)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:Encode4(0)
                    p:EncodeF(packet.values.x)
                    p:EncodeF(packet.values.y)
                    p:EncodeF(packet.values.targetNetworkId)
                    p:Encode1(packet.values.type)

                    return p
                end
            },
            S_CAST = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        sourceNetworkId = myHero.networkID,
                        spellId = 0,
                        fromX = mousePos.x,
                        fromY = mousePos.z,
                        toX = mousePos.x,
                        toY = mousePos.z,
                        targetNetworkId = 0
                    }
                end,

                encode = function(packet)
                    if packet.values.spellId == SUMMONER_1 then
                        packet.values.spellId = 64
                    elseif packet.values.spellId == SUMMONER_2 then
                        packet.values.spellId = 65
                    end

                    p = CLoLPacket(Packet.headers.S_CAST)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:EncodeF(packet.values.sourceNetworkId)
                    p:Encode1(packet.values.spellId)
                    p:EncodeF(packet.values.fromX)
                    p:EncodeF(packet.values.fromY)
                    p:EncodeF(packet.values.toX)
                    p:EncodeF(packet.values.toY)
                    p:EncodeF(packet.values.targetNetworkId)

                    return p
                end,

                decode = function(p)
                    local spellIdMapping = {
                        ['128'] = SPELL_1,
                        ['129'] = SPELL_2,
                        ['130'] = SPELL_3,
                        ['131'] = SPELL_4,
                        ['132'] = ITEM_1,
                        ['133'] = ITEM_2,
                        ['134'] = ITEM_3,
                        ['135'] = ITEM_4,
                        ['136'] = ITEM_5,
                        ['137'] = ITEM_6,
                        ['64']  = SUMMONER_1,
                        ['65']  = SUMMONER_2,
                        ['192'] = SUMMONER_1,
                        ['193'] = SUMMONER_2,
                        ['10']  = RECALL
                    }

                    p.pos = 1

                    local result = {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        sourceNetworkId = p:DecodeF(),
                        spellId = p:Decode1(),
                        fromX = p:DecodeF(),
                        fromY = p:DecodeF(),
                        toX = p:DecodeF(),
                        toY = p:DecodeF(),
                        targetNetworkId = p:DecodeF()
                    }

                    result.spellId = spellIdMapping[tostring(result.spellId)] or result.spellId

                    return result
                end
            },
            S_MOVE = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        sourceNetworkId = myHero.networkID,
                        type = 2,
                        x = mousePos.x,
                        y = mousePos.z,
                        targetNetworkId = 0,
                        unitNetworkId = myHero.networkID,
                        wayPoints = {}
                    }
                end,

                encode = function(packet)
                    if #packet.values.wayPoints >= 1 then
                        local lastPoint = packet.values.wayPoints[#packet.values.wayPoints]
                        lastPoint.x = packet.values.x
                        lastPoint.y = packet.values.y
                    end

                    p = CLoLPacket(Packet.headers.S_MOVE)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:EncodeF(packet.values.sourceNetworkId)
                    p:Encode1(packet.values.type)
                    p:EncodeF(packet.values.x)
                    p:EncodeF(packet.values.y)
                    p:EncodeF(packet.values.targetNetworkId)
                    p:Encode1(#packet.values.wayPoints * 2)
                    p:EncodeF(packet.values.unitNetworkId)
                    p:Encode1(0)

                    for i, wayPoint in pairs(packet.values.wayPoints) do
                        local gridX = math.floor((wayPoint.x - GetGame().map.grid.width) / 2)
                        local gridY = math.floor((wayPoint.y - GetGame().map.grid.height) / 2)

                        p:Encode2(gridX)
                        p:Encode2(gridY)
                    end

                    return p
                end,

                decode = function(p)
                    p.pos = 1

                    local packetResult = {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        sourceNetworkId = p:DecodeF(),
                        type = p:Decode1(),
                        x = p:DecodeF(),
                        y = p:DecodeF(),
                        targetNetworkId = p:DecodeF(),
                        waypointCount = p:Decode1() / 2,
                        unitNetworkId = p:DecodeF()
                    }

                    local modifierBits = {0, 0}
                    for i = 1, math.ceil((packetResult.waypointCount - 1) / 4) do
                        local bitMask = p:Decode1()
                        for j = 1, 8 do
                            table.insert(modifierBits, bit32.band(bitMask, 1))
                            bitMask = bit32.rshift(bitMask, 1)
                        end
                    end

                    packetResult.wayPoints = {}
                    for i = 1, packetResult.waypointCount do
                        table.insert(packetResult.wayPoints, Packet.getNextWayPoint(p, modifierBits))
                    end

                    return packetResult
                end
            },
            PKT_NPC_UpgradeSpellReq = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        networkId = myHero.networkID,
                        spellId = 1
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        networkId = p:DecodeF(),
                        spellId = p:Decode2()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_NPC_UpgradeSpellReq)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:EncodeF(packet.values.networkId)
                    p:Encode2(packet.values.spellId)

                    return p
                end
            },
            PKT_BuyItemReq = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        networkId = myHero.networkID,
                        itemId = 0
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        networkId = p:DecodeF(),
                        itemId = p:Decode4()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_BuyItemReq)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:EncodeF(packet.values.networkId)
                    p:Encode4(packet.values.itemId)

                    return p
                end
            },

            PKT_RemoveItemReq = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        networkId = myHero.networkID,
                        slotId = 128
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    local slotMapping = {
                        [128] = ITEM_1,
                        [129] = ITEM_2,
                        [130] = ITEM_3,
                        [131] = ITEM_4,
                        [132] = ITEM_5,
                        [133] = ITEM_6,
                        [134] = ITEM_7
                    }

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        networkId = p:DecodeF(),
                        slotId = slotMapping[p:Decode1()] or ITEM_1
                    }
                end,

                encode = function(packet)
                    local slotMapping = {
                        [ITEM_1] = 128,
                        [ITEM_2] = 129,
                        [ITEM_3] = 130,
                        [ITEM_4] = 131,
                        [ITEM_5] = 132,
                        [ITEM_6] = 133,
                        [ITEM_7] = 134
                    }

                    p = CLoLPacket(Packet.headers.PKT_RemoveItemReq)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:EncodeF(packet.values.networkId)
                    p:Encode1(slotMapping[packet.values.slotId] or 128)

                    return p
                end
            },

            PKT_SwapItemReq = {
                init = function()
                    return {
                        dwArg1 = 1,
                        dwArg2 = 0,
                        networkId = myHero.networkID,
                        sourceSlotId = 128,
                        targetSlotId = 129
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        networkId = p:DecodeF(),
                        sourceSlotId = p:Decode1() + 4,
                        targetSlotId = p:Decode1() + 4
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_SwapItemReq)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:EncodeF(packet.values.networkId)
                    p:Encode1(packet.values.sourceSlotId - 4)
                    p:Encode1(packet.values.targetSlotId - 4)

                    return p
                end
            },

            -- RECEIVE PACKETS
            PKT_S2C_Aggro = {
                init = function()
                    return {
                        sourceNetworkId = 0,
                        targetNetworkId = 0
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        sourceNetworkId = p:DecodeF(),
                        targetNetworkId = p:DecodeF()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_Aggro)

                    p:EncodeF(packet.values.sourceNetworkId)
                    p:EncodeF(packet.values.targetNetworkId)

                    return p
                end
            },

            PKT_S2C_TowerAggro = {
                init = function()
                    return {
                        sourceNetworkId = 0,
                        targetNetworkId = 0
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        sourceNetworkId = p:DecodeF(),
                        targetNetworkId = p:DecodeF()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_TowerAggro)

                    p:EncodeF(packet.values.sourceNetworkId)
                    p:EncodeF(packet.values.targetNetworkId)

                    return p
                end
            },

            PKT_S2C_LevelUpSpell = {
                init = function()
                    return {
                        networkId = myHero.networkID,
                        spellId = SPELL_1,
                        level = 1,
                        remainingLevelPoints = 0
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        networkId = p:DecodeF(),
                        spellId = p:Decode1(),
                        level = p:Decode1(),
                        remainingLevelPoints = p:Decode1()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_LevelUpSpell)

                    p:EncodeF(packet.values.networkId)
                    p:Encode1(packet.values.spellId)
                    p:Encode1(packet.values.level)
                    p:Encode1(packet.values.remainingLevelPoints)

                    return p
                end
            },

            PKT_S2C_HideUnit = {
                init = function()
                    return {
                        networkId = myHero.networkID
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        networkId = p:DecodeF()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_HideUnit)

                    p:EncodeF(packet.values.networkId)

                    return p
                end
            },

            PKT_S2C_GainVision = {
                init = function()
                    return {
                        networkId = myHero.networkID,
                        maxHealth = nil,
                        currentHealth = nil
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    local result = {}

                    result.networkId = p:DecodeF()
                    p:Decode2()
                    result.maxHealth = p:DecodeF()
                    result.currentHealth = p:DecodeF()

                    return result
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_GainVision)

                    p:EncodeF(packet.values.networkId)
                    p:Encode2(0)
                    p:EncodeF(packet.values.maxHealth or objManager:GetObjectByNetworkId(packet.values.networkId).maxHealth)
                    p:EncodeF(packet.values.currentHealth or objManager:GetObjectByNetworkId(packet.values.networkId).health)

                    return p
                end
            },

            PKT_S2C_LoseVision = {
                init = function()
                    return {
                        networkId = myHero.networkID
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        networkId = p:DecodeF()
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_LoseVision)

                    p:EncodeF(packet.values.networkId)

                    return p
                end
            },

            PKT_RemoveItemAns = {
                init = function()
                    return {
                        networkId = myHero.networkID,
                        slotId = 128
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    local slotMapping = {
                        [128] = ITEM_1,
                        [129] = ITEM_2,
                        [130] = ITEM_3,
                        [131] = ITEM_4,
                        [132] = ITEM_5,
                        [133] = ITEM_6,
                        [134] = ITEM_7
                    }

                    return {
                        networkId = p:DecodeF(),
                        slotId = slotMapping[p:Decode2()] or ITEM_1
                    }
                end,

                encode = function(packet)
                    local slotMapping = {
                        [ITEM_1] = 128,
                        [ITEM_2] = 129,
                        [ITEM_3] = 130,
                        [ITEM_4] = 131,
                        [ITEM_5] = 132,
                        [ITEM_6] = 133,
                        [ITEM_7] = 134
                    }

                    p = CLoLPacket(Packet.headers.PKT_RemoveItemAns)

                    p:EncodeF(packet.values.networkId)
                    p:Encode2(slotMapping[packet.values.slotId] or 128)

                    return p
                end
            },

            PKT_SwapItemAns = {
                init = function()
                    return {
                        networkId = myHero.networkID,
                        sourceSlotId = 128,
                        targetSlotId = 129
                    }
                end,

                decode = function(p)
                    p.pos = 1

                    return {
                        networkId = p:DecodeF(),
                        sourceSlotId = p:Decode1() + 4,
                        targetSlotId = p:Decode1() + 4
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_SwapItemAns)

                    p:EncodeF(packet.values.networkId)
                    p:Encode1(packet.values.sourceSlotId - 4)
                    p:Encode1(packet.values.targetSlotId - 4)

                    return p
                end
            },

            PKT_WHTAEVER = {
                decode = function(p)
                    p.pos = 5

                    return {
                    }
                end
            },
            PKT_S2C_IncreaseExperience = {
                decode = function(p)
                    p.pos = 5

                    return {
                        networkId = p:DecodeF(),
                        amount = p:DecodeF()
                    }
                end
            },
            PKT_S2C_Neutral_Camp_Empty = {
                init = function()
                    return {
                        networkId = myHero.networkID,
                        campId = 1,
                        emptyType = 1
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.PKT_S2C_Neutral_Camp_Empty)
                    p:Encode4(0)
                    p:EncodeF(packet.values.networkId)
                    p:Encode4(packet.values.campId)
                    p:Encode1(packet.values.emptyType)

                    return p
                end,

                decode = function(p)
                    p.pos = 5

                    return {
                        networkId = p:DecodeF(),
                        campId = p:Decode4(),
                        emptyType = p:Decode1()
                    }
                end
            },
            PKT_S2C_CreateNeutral = {
                decode = function(p)
                    p.pos = 1

                    local packetResult = {
                        networkId1 = p:DecodeF(),
                        networkId2 = p:DecodeF(),
                        a1 = p:Decode1(),
                        x = p:DecodeF(),
                        y = p:DecodeF(),
                        z = p:DecodeF(),
                        x1 = p:DecodeF(),
                        y1 = p:DecodeF(),
                        z1 = p:DecodeF(),
                        x2 = p:DecodeF(),
                        y2 = p:DecodeF(),
                        z2 = p:DecodeF()
                    }

                    return packetResult
                end
            },
            PKT_S2C_ScoreUpdate = {
                decode = function(p)
                    p.pos = 1

                    local packetResult = {
                        networkId = p:DecodeF()
                    }
                    local updateType = p:Decode1()

                    if updateType == 3 then
                        packetResult.updateType = 'DEATH'
                        packetResult.killerNetworkId = p:DecodeF()
                    elseif updateType == 5 then
                        packetResult.updateType = 'KILL'
                        packetResult.victimNetworkId = p:DecodeF()
                    else
                        packetResult.updateType = 'ASSIST'
                        packetResult.victimNetworkId = p:DecodeF()
                    end

                    return packetResult
                end
            },
            R_PING = {
                init = function()
                    return {
                        dwArg1 = 0,
                        dwArg2 = 0,
                        x = mousePos.x,
                        y = mousePos.z,
                        targetNetworkId = 0,
                        sourceNetworkId = myHero.networkID,
                        type = PING_NORMAL,
                        playSound = true
                    }
                end,

                decode = function(p)
                    p.pos = 5

                    local packetResult = {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        x = p:DecodeF(),
                        y = p:DecodeF(),
                        targetNetworkId = p:DecodeF(),
                        sourceNetworkId = p:DecodeF(),
                        type = p:Decode1()
                    }

                    packetResult.playSound = (packetResult.type == 176 or packetResult.type == 181)
                    packetResult.type = (packetResult.type == 176 and PING_NORMAL or (packetResult.type == 181 and PING_FALLBACK or packetResult.type))

                    return packetResult
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.R_PING)
                    p.dwArg1 = packet.values.dwArg1
                    p.dwArg2 = packet.values.dwArg2
                    p:Encode4(0)
                    p:EncodeF(packet.values.x)
                    p:EncodeF(packet.values.y)
                    p:EncodeF(packet.values.targetNetworkId)
                    p:EncodeF(packet.values.sourceNetworkId)
                    p:Encode1(packet.values.playSound and (packet.values.type == PING_NORMAL and 176 or (packet.values.type == PING_FALLBACK and 181 or packet.values.type)) or packet.values.type)

                    return p
                end
            },
            R_DESTROY_INVISIBLE_OBJECT = {
                decode = function(p)
                    p.pos = 1

                    return {
                        targetNetworkId = p:DecodeF(),
                        sourceNetworkId = p:DecodeF()
                    }
                end
            },
            R_REMOVE_VISION_BUFF = {
                decode = function(p)
                    p.pos = 5

                    return {
                        networkId = p:DecodeF()
                    }
                end
            },
            R_APPLY_VISION_BUFF = {
                decode = function(p)
                    p.pos = 5

                    packetResult = {}

                    packetResult.team = (p:Decode4() == 1) and TEAM_RED or TEAM_BLUE

                    p.pos = p.pos + 4

                    packetResult.visionRange = p:DecodeF()
                    packetResult.targetNetworkId = p:DecodeF()
                    packetResult.x = p:DecodeF()
                    packetResult.y = p:DecodeF()
                    packetResult.z = p:DecodeF()
                    packetResult.duration = p:DecodeF()
                    packetResult.buffNetworkId = p:DecodeF()
                    packetResult.canSeeInvisibleUnits = bit32.band(p:Decode4(), 1) == 1

                    return packetResult
                end
            },
            R_WAYPOINTS = {
                init = function()
                    return {
                        sequenceNumber = Packet.lastSequenceNumber,
                        wayPoints = {
                            [myHero.networkID] = {Point(myHero.x, myHero.z)}
                        }
                    }
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.R_WAYPOINTS)

                    local unitCount = 0
                    for networkId, wayPoints in pairs(packet.values.wayPoints) do
                        unitCount = unitCount + 1
                    end

                    p:Encode4(0)
                    p:Encode4(packet.values.sequenceNumber)
                    p:Encode2(unitCount)

                    for networkId, wayPoints in pairs(packet.values.wayPoints) do
                        p:Encode1(#wayPoints * 2)
                        p:EncodeF(networkId)
                        for i = 1, math.ceil((#wayPoints - 1) / 4) do
                            p:Encode1(0)
                        end

                        for i, point in ipairs(wayPoints) do
                            p:Encode2((point.x - GetGame().map.grid.width) / 2)
                            p:Encode2((point.y - GetGame().map.grid.height) / 2)
                        end
                    end

                    return p
                end,

                decode = function(p)
                    p.pos = 5

                    local packetResult = {
                        dwArg1 = p.dwArg1,
                        dwArg2 = p.dwArg2,
                        sequenceNumber = p:Decode4(),
                        wayPoints = {}
                    }

                    local unitCount = p:Decode2()

                    for h = 1, unitCount do
                        local waypointCount = p:Decode1() / 2
                        local networkId = p:DecodeF()
                        packetResult.wayPoints[networkId] = Packet.decodeWayPoints(p, waypointCount)
                    end

                    return packetResult
                end
            },
            R_WAYPOINT = {
                init = function()
                    return {
                        additionalInfo = {0, 0, 0, 0, 0, 0},
                        sequenceNumber = 0,
                        networkId = myHero.networkID,
                        wayPoints = {}
                    }
                end,

                decode = function(p)
                    p.pos = 1
                    local packetResult = {
                        networkId = p:DecodeF(),
                        additionalInfo = {},
                        wayPoints = {}
                    }
                    local cLen, cNetworkId = 0, packetResult.networkId
                    repeat
                        cLen = p:Decode2()
                        for i=1, 6+cLen do
                            --may contain even more networkIds, but more often than not, its all filled with zeros
                            table.insert(packetResult.additionalInfo, p:Decode1())
                        end
                        local nwId = p:DecodeF()
                        cNetworkId = nwId~=0 and nwId or cNetworkId
                    until cLen==0
                    for i = 1, 13 do
                        --often     02 ?? ?? C? 45 ?? ?? ?? C3 ?? ?? ?? 45
                        --sometimes 00 00 00 80 8F 00 00 00 00 00 00 00 00
                        table.insert(packetResult.additionalInfo, p:Decode1())
                    end
                    packetResult.sequenceNumber = p:Decode4()
                    table.insert(packetResult.additionalInfo, p:Decode1())
                    packetResult.waypointCount = p:Decode1()/2
                    if packetResult.networkId == p:DecodeF() then --Just to check if all went right
                        packetResult.wayPoints = Packet.decodeWayPoints(p,packetResult.waypointCount)
                    end
                    return packetResult
                end,

                encode = function(packet)
                    p = CLoLPacket(Packet.headers.R_WAYPOINT)

                    p:EncodeF(packet.values.networkId)
                    p:Encode2(#packet.values.additionalInfo - 6)

                    for k, v in ipairs(packet.values.additionalInfo) do
                        p:Encode1(v)
                    end

                    p:Encode1(3)
                    p:Encode4(packet.values.sequenceNumber)
                    p:EncodeF(packet.values.wayPoints[1].x)
                    p:EncodeF(packet.values.wayPoints[1].y)
                    p:EncodeF(packet.values.wayPoints[2].x)
                    p:EncodeF(packet.values.wayPoints[2].y)

                    return p
                end
            }
        }

        -- public functions --------------------------------------------------------

        function Packet:__init(packet, options)
            if type(packet) == 'string' then
                self.values = Packet.definition[packet] and Packet.definition[packet].init() or {}
                self.values.header = Packet.headers[packet]
                self.values.name = packet

                for k,v in pairs(options or {}) do
                    self.values[k] = v
                end
            else
                self.packet = packet

                if packet.pIndex == Packet.lastPIndex then
                    self.values = Packet.decodedValues
                else
                    self.values = Packet.definition[Packet.getName(packet.header)] and Packet.definition[Packet.getName(packet.header)].decode(packet) or {dwArg1 = packet.dwArg1, dwArg2 = packet.dwArg2}
                    self.values.header = packet.header
                    self.values.name = Packet.getName(packet.header)
                    local remaining = self:getRemaining()
                    if remaining ~= "" then
                        self.values.remaining = remaining
                    end

                    Packet.decodedValues = self.values
                    Packet.lastPIndex = packet.pIndex
                end
            end
        end

        function Packet:get(key)
            if key then
                return self.values[key]
            else
                return self.values
            end
        end

        function Packet:set(key, value)
            self.values[key] = value

            return self
        end

        function Packet:block()
            self.blocked = true

            if self.packet then
                self.packet:Block()
            end

            return self
        end

        function Packet:tostring()
            return Packet.tableToString(self.values)
        end

        function Packet:send()
            if not self.blocked then
                SendPacket(Packet.definition[self.values.name].encode(self))
            end

            return self
        end

        function Packet:receive()
            if not self.blocked then
                local p = Packet.definition[self.values.name].encode(self)

                p:Hide()

                RecvPacket(p)
            end

            return self
        end

        function Packet:containsFloat(floatValue)
            local tempPacket = CLoLPacket(0)
            tempPacket.pos = 1
            tempPacket:EncodeF(floatValue)

            return string.find(self:getRawHexString(), Packet(tempPacket):getRawHexString())
        end

        function Packet:containsByte(byteValue)
            local tempPacket = CLoLPacket(0)
            tempPacket.pos = 1
            tempPacket:Encode1(byteValue)

            return string.find(self:getRawHexString(), Packet(tempPacket):getRawHexString())
        end

        function Packet:getRawHexString(startPos, endPos)
            local oldPos = self.packet.pos

            self.packet.pos = startPos or 1
            local rawHexString = self:getRemaining(endPos and (endPos - (startPos or 1)) or nil)
            self.packet.pos = oldPos

            return rawHexString
        end

        function Packet:getRemaining(endPos)
            local result = ''

            if self.packet then
                if self.packet.pos == 0 then
                    self.packet.pos = 1
                end

                local remaining = endPos or self.packet:getRemaining()
                for i=1, remaining do
                    result = result .. string.format('%02X ', self.packet:Decode1())
                end
            end

            return result;
        end

        function Packet.getName(header)
            if #Packet.names == 0 then
                for k,v in pairs(Packet.headers) do
                    Packet.names[tostring(v)] = k
                end
            end

            return Packet.names[tostring(header)] or 'UNKNOWN'
        end

        -- internal helper functions -----------------------------------------------

        Packet.names = {}

        function Packet.tableToString(tableObject, indentLevel)
            local result = 'table: {'

            for k,v in pairs(tableObject) do
                if k ~= 'encode' and k ~= 'decode' then
                    if result == 'table: {' then
                        result = result .. '\n'
                    else
                        result = result .. ',\n'
                    end

                    for i=1, indentLevel or 1 do
                        result = result .. '  '
                    end

                    if type(v) == 'table' then
                        result = result .. k .. ' = ' .. Packet.tableToString(v, (indentLevel or 1) + 1)
                    elseif type(v) == 'userdata' and v.tostring then
                        result = result .. k .. ' = ' .. v:tostring()
                    elseif type(v) ~= 'userdata' then
                        result = result .. k .. ' = ' .. tostring(v)
                    end
                end
            end

            result = result .. '\n'

            for i=1, (indentLevel or 1) - 1 do
                result = result .. '  '
            end

            result = result .. '}'

            return result
        end

        function Packet.decodeWayPoints(packet,waypointCount)
            local wayPoints = {}
            if math.ceil(waypointCount) ~= math.floor(waypointCount) then
                waypointCount = math.floor(waypointCount)
                packet:Decode1()
            end
            local modifierBits = {0, 0}
            for i = 1, math.ceil((waypointCount - 1) / 4) do
                local bitMask = packet:Decode1()

                for j = 1, 8 do
                    table.insert(modifierBits, bit32.band(bitMask, 1))
                    bitMask = bit32.rshift(bitMask, 1)
                end
            end
            for i = 1, waypointCount do
                table.insert(wayPoints, Packet.getNextWayPoint(packet, modifierBits))
            end
            return wayPoints
        end

        function Packet.getNextWayPoint(packet, modifierBits)
            coord = Point(Packet.getNextGridCoord(packet, modifierBits, coord and coord.x or 0), Packet.getNextGridCoord(packet, modifierBits, coord and coord.y or 0) )

            return Point(2 * coord.x + GetGame().map.grid.width, 2 * coord.y + GetGame().map.grid.height)
        end

        function Packet.getNextGridCoord(packet, modifierBits, relativeCoord)
            if table.remove(modifierBits, 1) == 1 then
                return relativeCoord + Packet.unsignedToSigned(packet:Decode1(), 1)
            else
                return Packet.unsignedToSigned(packet:Decode2(), 2)
            end
        end

        function Packet.unsignedToSigned(value, byteCount)
            local byteCount = 2 ^ ( 8 * byteCount)

            return value >= byteCount / 2 and value - byteCount or value
        end
    -- }

    function DecodeString(packet)
        local result = ""

        for i = 1, packet.size - packet.pos, 1 do
            local charNum = packet:Decode1()

            if charNum == 0 then
                return result
            end

            result = result .. string.char(charNum)
        end

        return result
    end

    AddRecvPacketCallback(function(p)
        local decodedPacket = Packet(p)

        if p.header == Packet.headers.R_WAYPOINTS then
            Packet.lastSequenceNumber = decodedPacket:get('sequenceNumber')
        end
    end)
end