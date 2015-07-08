local version = "0.1"

--[[
    Perfect Ward v0.1, originally by Husky
    ========================================================================

    v0.1 -- First release for new SR

]]--    



local AUTOUPDATE = true
local UPDATE_SCRIPT_NAME = "PerfectWard"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/MLStudio/BoL/master/PerfectWard.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Perfect Ward:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
    local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
    if ServerData then
        --PrintChat(tostring(ServerData))
        local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
        ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
        if ServerVersion then
            ServerVersion = tonumber(ServerVersion)
            if tonumber(version) < ServerVersion then
                AutoupdaterMsg("New version available"..ServerVersion)
                AutoupdaterMsg("Updating, please don't press F9")
                DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
            else
                AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
            end
        end
    else
        AutoupdaterMsg("Error downloading version info")
    end
end

--[[
    Perfect Ward v0.1, originally by Husky
    ========================================================================

    v0.1 -- First release for new SR

]]--    

function get2DFrom3D(x, y, z)
    local pos = WorldToScreen(D3DXVECTOR3(x, y, z))
    return pos.x, pos.y, OnScreen(pos.x, pos.y)
end


local HK_1 = HK_1 and string.byte(HK_1) or 49 -- hotkey for first itemslot (default "1")
local HK_2 = HK_2 and string.byte(HK_2) or 50 -- hotkey for first itemslot (default "2")
local HK_3 = HK_3 and string.byte(HK_3) or 51 -- hotkey for first itemslot (default "3")
local HK_4 = HK_4 and string.byte(HK_4) or 52 -- hotkey for first itemslot (default "4")
local HK_5 = HK_5 and string.byte(HK_5) or 53 -- hotkey for first itemslot (default "5")
local HK_6 = HK_6 and string.byte(HK_6) or 54 -- hotkey for first itemslot (default "6")
local HK_7 = HK_7 and string.byte(HK_7) or 55 -- hotkey for first itemslot (default "7")

local wardSpots = {
    -- Perfect Wards
    { x = 3261.93,    y = 60,  z = 7773.65},     -- BLUE GOLEM
    { x = 7831.46,    y = 60,  z = 3501.13},     -- BLUE LIZARD
    { x = 10586.62,   y = 60,  z = 3067.93},     -- BLUE TRI BUSH
    { x = 6483.73,    y = 60,  z = 4606.57},     -- BLUE PASS BUSH
    { x = 7610.46,    y = 60,  z = 5000},     -- BLUE RIVER ENTRANCE
    { x = 4717.09, y = 50.83, z = 7142.35},  -- BLUE ROUND BUSH
    { x = 4882.86, y = 27.83, z = 8393.77},     -- BLUE RIVER ROUND BUSH
    { x = 6951.01, y = 52.26, z = 3040.55},     -- BLUE SPLIT PUSH BUSH
    {x = 5583.74, y = 51.43, z = 3573.83},     --BlUE RIVER CENTER CLOSE

    { x = 11600.35, y = 51.73, z = 7090.37},     -- PURPLE GOLEM
    {x = 11573.9, y = 51.71, z = 6457.76},      --PURPLE GOLEM 2
    {x = 12629.72, y = 48.62, z = 4908.16},     --PURPLE TRIBRUSH 2
    { x = 7018.75, y = 54.76, z = 11362.12},    -- PURPLE LIZARD
    { x = 4232.69, y = 47.56, z = 11869.25},    -- PURPLE TRI BUSH
    { x = 8198.22, y = 49.38, z = 10267.89}, -- PURPLE PASS BUSH
    { x = 7202.43, y = 53.18, z = 9881.83},     -- PURPLE RIVER ENTRANCE
    { x = 10074.63, y = 51.74, z = 7761.62},     -- PURPLE ROUND BUSH
    { x = 9795.85, y = -12.21, z = 6355.15},     -- PURPLE RIVER ROUND BUSH
    { x = 7836.85, y = 56.48, z = 11906.34},    -- PURPLE SPLIT PUSH BUSH

    { x = 10546.35,   y = -60,    z = 5019.06},      -- DRAGON
    { x = 9344.95,  y = -64.07,  z = 5703.43}, -- DRAGON BUSH
    { x = 4334.98,   y = -60.42,    z = 9714.54},      -- BARON
    { x = 5363.31,  y = -62.70,  z = 9157.05}, -- BARON BUSH

    --{ x = 12731.25,  y = 50.32,  z = 9132.66}, -- PURPLE BOT T2
    --{ x = 8036.52,  y = 45.19,  z = 12882.94}, -- PURPLE TOP T2
    { x = 9757.9, y = 50.73, z = 8768.25}, -- PURPLE MID T1

    { x = 4749.79,  y = 53.59,  z = 5890.76}, -- BLUE MID T1
    { x = 5983.58,  y = 52.99,  z = 1547.98}, -- BLUE BOT T2
    { x = 1213.70,  y = 58.77,  z = 5324.73}, -- BLUE TOP T2

    { x = 6523.58,  y = 60,  z = 6743.31}, -- BLUE MIDLANE
    { x = 8223.67,  y = 60,  z = 8110.15}, -- PURPLE MIDLANE
    { x = 9736.8, y = 51.98, z = 6916.26}, -- PURPLE MID PATH
    {x = 2222.31, y = 53.2, z = 9964.1},   -- BLUE TRI TOP

}

local safeWardSpots = {
    {    -- DRAGON -> TRI BUSH
        magneticSpot =  {x = 10072,    y = -71.24, z = 3908},
        clickPosition = {x = 10297.93, y = 49.03, z = 3358.59},
        wardPosition =  {x = 10273.9, y = 49.03, z = 3257.76},
        movePosition  = {x = 10072,    y = -71.24, z = 3908}
    },
    {    -- NASHOR -> TRI BUSH
        magneticSpot =  {x = 4724, y = -71.24, z = 10856},
        clickPosition = {x = 4627.26, y = -71.24, z = 11311.69},
        wardPosition =  {x = 4473.9, y = 51.4, z = 11457.76},
        movePosition  = {x = 4724, y = -71.24, z = 10856}
    },
    {    -- BLUE TOP -> SOLO BUSH
        magneticSpot  = {x = 2824, y = 54.33, z = 10356},
        clickPosition = {x = 3078.62, y = 54.33, z = 10868.39},
        wardPosition  = {x = 3078.62, y = -67.95, z = 10868.39},
        movePosition  = {x = 2824, y = 54.33, z = 10356}
    },
    { -- BLUE MID -> ROUND BUSH
        magneticSpot  = {x = 5474, y = 51.67, z = 7906},
        clickPosition = {x = 5132.65, y = 51.67, z = 8373.2},
        wardPosition  = {x = 5123.9, y = -21.23, z = 8457.76},
        movePosition  = {x = 5474, y = 51.67, z = 7906}
    },
    { -- BLUE MID -> RIVER LANE BUSH
        magneticSpot  = {x = 5874, y = 51.65, z = 7656},
        clickPosition = {x = 6202.24, y = 51.65, z = 8132.12},
        wardPosition  = {x = 6202.24, y = -67.39, z = 8132.12},
        movePosition  = {x = 5874, y = 51.65, z = 7656}
    },
    { -- BLUE LIZARD -> DRAGON PASS BUSH
        magneticSpot  = {x = 8022, y = 53.72, z = 4258},
        clickPosition = {x = 8400.68, y = 53.72, z = 4657.41},
        wardPosition  = {x = 8523.9, y = 51.24, z = 4707.76},
        movePosition  = {x = 8022, y = 53.72, z = 4258}
    },
    { -- PURPLE MID -> ROUND BUSH
        magneticSpot  = {x = 9372, y = 52.63, z = 7008},
        clickPosition = {x = 9703.5, y = 52.63, z = 6589.9},
        wardPosition  = {x = 9823.9, y = 23.47, z = 6507.76},
        movePosition  = {x = 9372, y = 52.63, z = 7008}
    },
    { -- PURPLE MID -> RIVER ROUND BUSH // Inconsistent Placement
        magneticSpot  = {x = 9072, y = 53.04, z = 7158},
        clickPosition = {x = 8705.95, y = 53.04, z = 6819.1},
        wardPosition  = {x = 8718.88, y = 95.75, z = 6764.86},
        movePosition  = {x = 9072, y = 53.04, z = 7158}
    },
    -- { -- PURPLE MID -> RIVER LANE BUSH
    --     magneticSpot  = {x = 8530.27, y = 46.98, z = 6637.38},
    --     clickPosition = {x = 8539.27, y = 46.98, z = 6637.38},
    --     wardPosition  = {x = 8396.10, y = 46.98, z = 6464.81},
    --     movePosition  = {x = 8779.17, y = 46.98, z = 6804.70}
    -- },
    { -- PURPLE BOTTOM -> SOLO BUSH
        magneticSpot  = {x = 12422, y = 51.73, z = 4508},
        clickPosition = {x = 12353.94, y = 51.73, z = 4031.58},
        wardPosition  = {x = 12023.9, y = -66.25, z = 3757.76},
        movePosition  = {x = 12422, y = 51.73, z = 4508}
    },
    { -- PURPLE LIZARD -> NASHOR PASS BUSH
        magneticSpot  = {x = 6824, y = 56, z = 10656},
        clickPosition = {x = 6370.69, y = 56, z = 10359.92},
        wardPosition  = {x = 6273.9, y = 53.67, z = 10307.76},
        movePosition  = {x = 6824, y = 56, z = 10656}
    },

    { -- BLUE GOLEM -> BLUE LIZARD
        magneticSpot  = {x = 8272,    y = 51.13, z = 2908},
        clickPosition = {x = 8163.7056, y = 51.13, z = 3436.0476},
        wardPosition  = {x = 8163.71, y = 51.6628, z = 3436.05},
        movePosition  = {x = 8272,    y = 51.13, z = 2908}
    },

    { -- RED GOLEM -> RED LIZARD
        magneticSpot  = {x = 6574, y = 56.48, z = 12006},
        clickPosition = {x = 6678.08, y = 56.48, z = 11477.83},
        wardPosition  = {x = 6678.08, y = 53.85, z = 11477.83},
        movePosition  = {x = 6574, y = 56.48, z = 12006}
    },

    { -- BLUE TOP SIDE BRUSH
        magneticSpot  = {x = 1774, y = 52.84, z = 10756},
        clickPosition = {x = 2302.36, y = 52.84, z = 10874.22},
        wardPosition  = {x = 2773.9, y = -71.24, z = 11307.76},
        movePosition  = {x = 1774, y = 52.84, z = 10756}
    },

    { -- MID LANE DEATH BRUSH
        magneticSpot  = {x = 5874, y = -70.12, z = 8306},
        clickPosition = {x = 5332.9, y = -70.12, z = 8275.21},
        wardPosition  = {x = 5123.9, y = -21.23, z = 8457.76},
        movePosition  = {x = 5874, y = -70.12, z = 8306}
    },

    { -- MID LANE DEATH BRUSH RIGHT SIDE
        magneticSpot  = {x = 9022, y = -71.24, z = 6558},
        clickPosition = {x = 9540.43, y = -71.24, z = 6657.68},
        wardPosition  = {x = 9773.9, y = 9.56, z = 6457.76},
        movePosition  = {x = 9022, y = -71.24, z = 6558}
    },

    { -- BLUE INNER TURRET JUNGLE
        magneticSpot  = {x = 6874, y = 50.52, z = 1708},
        clickPosition = {x = 6849.11, y = 50.52, z = 2252.01},
        wardPosition  = {x = 6723.9, y = 52.17, z = 2507.76},
        movePosition  = {x = 6874, y = 50.52, z = 1708}
    },

    { -- PURPLE INNER TURRET JUNGLE
        magneticSpot  = {x = 8122, y = 52.84, z = 13206},
        clickPosition = {x = 8128.53, y = 52.84, z = 12658.41},
        wardPosition  = {x = 8323.9, y = 56.48, z = 12457.76},
        movePosition  = {x = 8122, y = 52.84, z = 13206}
    }
}

local wardItems = {
    { id = 2043, spellName = "VisionWard",     		range = 1450, duration = 180000},
    { id = 2044, spellName = "SightWard",      		range = 1450, duration = 180000},
    { id = 3340, spellName = "RelicSmallLantern",   range = 1450, duration = 180000}, --added
    { id = 3350, spellName = "YellowTrinketUpgrade", range = 1450, duration = 180000}, --added
    { id = 3154, spellName = "WriggleLantern", 		range = 1450, duration = 180000},
    { id = 3160, spellName = "FeralFlare",	   		range = 1450, duration = 180000}, --added
    { id = 2045, spellName = "ItemGhostWard",  		range = 1450, duration = 180000},
    { id = 2049, spellName = "ItemGhostWard",  		range = 1450, duration = 180000},
    { id = 2050, spellName = "ItemMiniWard",   		range = 1450, duration = 60000}
}

-- Globals ---------------------------------------------------------------------

local drawWardSpots      = false
local wardSlot           = nil
local putSafeWard        = nil
local wardCorrected      = false
local packetApiAvailable = false

-- Code ------------------------------------------------------------------------

function OnLoad()
    PrintChat(" >> Perfect Ward v0.1")
end

function OnTick()
    if putSafeWard ~= nil then
        if GetDistance(safeWardSpots[putSafeWard].clickPosition, myHero) <= 600 then
            CastSpell(wardSlot, safeWardSpots[putSafeWard].clickPosition.x, safeWardSpots[putSafeWard].clickPosition.z)
            putSafeWard = nil
        end
    end
end

function OnWndMsg(msg,key)
    if msg == KEY_DOWN then
        wardSlot = nil
        if key == HK_1 then
            wardSlot = ITEM_1
        elseif key == HK_2 then
            wardSlot = ITEM_2
        elseif key == HK_3 then
            wardSlot = ITEM_3
        elseif key == HK_4 then
            wardSlot = ITEM_7
        elseif key == HK_5 then
            wardSlot = ITEM_4
        elseif key == HK_6 then
            wardSlot = ITEM_5
        elseif key == HK_7 then
            wardSlot = ITEM_6
        end

        if wardSlot ~= nil then
            if wardSlot == ITEM_7 then
                drawWardSpots = true
                return
            else
                local item = myHero:getInventorySlot(wardSlot)
                for i,wardItem in pairs(wardItems) do
                    if item == wardItem.id and myHero:CanUseSpell(wardSlot) == READY then
                        drawWardSpots = true
                        return
                    end
                end
            end
        end
    elseif msg == WM_LBUTTONUP and drawWardSpots then
        drawWardSpots = false
    elseif msg == WM_LBUTTONDOWN and drawWardSpots and not packetApiAvailable then
        drawWardSpots = false
        for i,wardSpot in pairs(wardSpots) do
            if GetDistance(wardSpot, mousePos) <= 250 and not wardCorrected then
                CastSpell(wardSlot, wardSpot.x, wardSpot.z)
                return
            end
        end

        for i,wardSpot in pairs(safeWardSpots) do
            if GetDistance(wardSpot.magneticSpot, mousePos) <= 100 and not wardCorrected then
                CastSpell(wardSlot, wardSpot.clickPosition.x, wardSpot.clickPosition.z)
                myHero:MoveTo(wardSpot.movePosition.x, wardSpot.movePosition.z)
                putSafeWard = i
                return
            end
        end
    elseif msg == WM_RBUTTONDOWN and drawWardSpots then
        drawWardSpots = false
    elseif msg == WM_RBUTTONDOWN then
        putSafeWard = nil
    end
end


function OnSendPacket(p)
    packetApiAvailable = true

    local packet = Packet(p)
    if packet:get('name') == 'S_CAST' then
        if wardSlot == packet:get('spellId') or (wardSlot == ITEM_7 and packet:get('spellId') == 12) then
            drawWardSpots = false
            for i,wardSpot in pairs(wardSpots) do
                if GetDistance(wardSpot, {x = packet:get('fromX'), y = myHero.y, z = packet:get('fromY')}) <= 250 and not wardCorrected then
                    packet:block()
                    wardCorrected = true
                    Packet('S_CAST', {spellId = packet:get('spellId'), fromX = wardSpot.x, fromY = wardSpot.z, toX = wardSpot.x, toY = wardSpot.z}):send()
                    wardCorrected = false
                    return
                end
            end

            for i,wardSpot in pairs(safeWardSpots) do
                if GetDistance(wardSpot.magneticSpot, {x = packet:get('fromX'), y = myHero.y, z = packet:get('fromY')}) <= 150 and not wardCorrected then
                    packet:block()
                    myHero:MoveTo(wardSpot.movePosition.x, wardSpot.movePosition.z)
                    putSafeWard = i
                    return
                end
            end
        end
    end
end

function OnDraw()
    if drawWardSpots then
        for i, wardSpot in pairs(wardSpots) do
            local wardColor = (GetDistance(wardSpot, mousePos) <= 250) and 0x00FF00 or 0xFFFFFF

            local x, y, onScreen = get2DFrom3D(wardSpot.x, wardSpot.y, wardSpot.z)
            if onScreen then
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 31, wardColor)
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 32, wardColor)
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 250, wardColor)
            end
        end

        for i,wardSpot in pairs(safeWardSpots) do
            local wardColor  = (GetDistance(wardSpot.magneticSpot, mousePos) <= 100) and 0x00FF00 or 0xFFFFFF
            local arrowColor = (GetDistance(wardSpot.magneticSpot, mousePos) <= 100) and ARGB(255,0,255,0) or ARGB(255,255,255,255)

            local x, y, onScreen = get2DFrom3D(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z)
            if onScreen then
                DrawCircle(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z, 31, wardColor)
                DrawCircle(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z, 32, wardColor)

                DrawCircle(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z, 99, wardColor)
                DrawCircle(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z, 100, wardColor)

                local magneticWardSpotVector = Vector(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z)
                local wardPositionVector = Vector(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z)
                local directionVector = (wardPositionVector-magneticWardSpotVector):normalized()
                local line1Start = magneticWardSpotVector + directionVector:perpendicular() * 98
                local line1End = wardPositionVector + directionVector:perpendicular() * 31
                local line2Start = magneticWardSpotVector + directionVector:perpendicular2() * 98
                local line2End = wardPositionVector + directionVector:perpendicular2() * 31

                DrawLine3D(line1Start.x,line1Start.y,line1Start.z, line1End.x,line1End.y,line1End.z,1,arrowColor)
                DrawLine3D(line2Start.x,line2Start.y,line2Start.z, line2End.x,line2End.y,line2End.z,1,arrowColor)

                
            end
        end
    end

    local target = GetTarget()
    for i,wardItem in pairs(wardItems) do
        if target ~= nil and target.name == wardItem.spellName then
            DrawCircle(target.x, target.y, target.z, 68, 0x00FF00)
            DrawCircle(target.x, target.y, target.z, 69, 0x00FF00)
            DrawCircle(target.x, target.y, target.z, 70, 0x00FF00)
            if GetDistanceFromMouse(target) <= 70 then
                local cursor = GetCursorPos()

                DrawText("X = " .. string.format("%.2f", target.x),16, cursor.x, cursor.y + 50, 0xFF00FF00)
                DrawText("Y = " .. string.format("%.2f", target.y),16, cursor.x, cursor.y + 65, 0xFF00FF00)
                DrawText("Z = " .. string.format("%.2f", target.z),16, cursor.x, cursor.y + 80, 0xFF00FF00)
            end
        end
    end
end