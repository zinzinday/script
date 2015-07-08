--[[

             _               _               _   
     /\     (_)             | |             | |  
    /  \     _   _ __ ___   | |__     ___   | |_ 
   / /\ \   | | | '_ ` _ \  | '_ \   / _ \  | __|
  / ____ \  | | | | | | | | | |_) | | (_) | | |_ 
 /_/    \_\ |_| |_| |_| |_| |_.__/   \___/   \__|
                                          
             
    By Nebelwolfi                                    
]]--

if not VIP_USER then return end -- VIP only since we use packets

--[[ Skillshot list start ]]--
_G.Champs = {
    ["Aatrox"] = {
        [_Q] = { speed = 450, delay = 0.25, range = 650, width = 150, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 1200, delay = 0.25, range = 1000, width = 150, collision = false, aoe = false, type = "linear"}
    },
        ["Ahri"] = {
        [_Q] = { speed = 1200, delay = 0.25, range = 880, width = 100, collision = false, aoe = false, type = "linear"},
        [_E] = { speed = 1100, delay = 0.25, range = 975, width = 60, collision = true, aoe = false, type = "linear"}
    },
        ["Amumu"] = {
        [_Q] = { speed = 2000, delay = 0.250, range = 1100, width = 80, collision = true, aoe = false, type = "linear"}
    },
        ["Anivia"] = {
        [_Q] = { speed = 850, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = math.huge, delay = 0.100, range = 615, width = 350, collision = false, aoe = true, type = "circular"}
    },
        ["Annie"] = {
        [_W] = { speed = math.huge, delay = 0.25, range = 625, width = 0, collision = false, aoe = true, type = "cone"},
        [_R] = { speed = math.huge, delay = 0.1, range = 600, width = 300, collision = false, aoe = true, type = "circular"}
    },
        ["Ashe"] = {
        [_W] = { speed = 2000, delay = 0.120, range = 1200, width = 85, collision = true, aoe = false, type = "cone"},
        [_R] = { speed = 1600, delay = 0.25, range = 25000, width = 120, collision = false, aoe = false, type = "linear"}
    },
        ["Blitzcrank"] = {
        [_Q] = { speed = 1800, delay = 0.250, range = 900, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["Brand"] = {
        [_Q] = { speed = 1200, delay = 0.5, range = 1050, width = 80, collision = false, aoe = false, type = "linear"},
        [_W] = { speed = 900, delay = 0.25, range = 1050, width = 275, collision = false, aoe = false, type = "linear"}
    },
        ["Braum"] = {
        [_Q] = { speed = 1600, delay = 225, range = 1000, width = 100, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = 1250, delay = 500, range = 1250, width = 0, collision = false, aoe = false, type = "linear"}
    },    
        ["Caitlyn"] = {
        [_Q] = { speed = 2200, delay = 0.625, range = 1300, width = 0, collision = false, aoe = false, type = "linear"},
        [_E] = { speed = 2000, delay = 0.400, range = 1000, width = 80, collision = false, aoe = false, type = "linear"}
    },
        ["Cassiopeia"] = {
        [_Q] = { speed = math.huge, delay = 0.535, range = 850, width = 130, collision = false, aoe = false, type = "circular"},
        [_W] = { speed = math.huge, delay = 0.350, range = 850, width = 212, collision = false, aoe = false, type = "circular"},
        [_R] = { speed = math.huge, delay = 0.535, range = 850, width = 350, collision = false, aoe = false, type = "cone"}
    },
        ["Chogath"] = {
        [_Q] = { speed = math.huge, delay = 0.625, range = 950, width = 300, collision = false, aoe = true, type = "circular"},
        [_W] = { speed = math.huge, delay = 0.5, range = 650, width = 275, collision = false, aoe = false, type = "linear"},
    },
        ["Corki"] = {
        [_Q] = { speed = 700, delay = 0.4, range = 825, width = 250, collision = false, aoe = false, type = "circular"},
        [_R] = { speed = 2000, delay = 0.200, range = 1225, width = 60, collision = false, aoe = false, type = "linear"},
    },
        ["Darius"] = {
        [_E] = { speed = 1500, delay = 0.550, range = 530, width = 0, collision = false, aoe = true, type = "cone"}
    },
        ["Diana"] = {
        [_Q] = { speed = 2000, delay = 0.250, range = 830, width = 0, collision = false, aoe = false, type = "linear"}
    },
        ["DrMundo"] = {
        [_Q] = { speed = 2000, delay = 0.250, range = 1050, width = 75, collision = true, aoe = false, type = "linear"}
    },
        ["Draven"] = {
        [_E] = { speed = 1400, delay = 0.250, range = 1100, width = 130, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = 2000, delay = 0.5, range = 25000, width = 160, collision = false, aoe = false, type = "linear"}
    },
        ["Elise"] = {
        [_E] = { speed = 1450, delay = 0.250, range = 975, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["Ekko"] = {
        [_Q] = { speed = 1050, delay = 0.250, range = 825, width = 70, collision = false, aoe = false, type = "linear"}
    },
        ["Ezreal"] = {
        [_Q] = { speed = 1975, delay = 0.25, range = 1200, width = 80, collision = true, aoe = false, type = "linear"},
        [_W] = { speed = 1600, delay = 0.25, range = 900, width = 100, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = 2000, delay = 1, range = 20000, width = 160, collision = false, aoe = false, type = "linear"}
    },
        ["Fizz"] = {
        [_R] = { speed = 1350, delay = 0.250, range = 1150, width = 100, collision = false, aoe = false, type = "linear"}
    },
        ["Galio"] = {
        [_Q] = { speed = 1300, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 1200, delay = 0.25, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
    },
        ["Gragas"] = {
        [_Q] = { speed = 1000, delay = 0.250, range = 1000, width = 300, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = math.huge, delay = 0.250, range = 600, width = 50, collision = true, aoe = true, type = "circular"},
        [_R] = { speed = 1000, delay = 0.250, range = 1050, width = 400, collision = false, aoe = true, type = "circular"}
    },
        ["Graves"] = {
        [_Q] = { speed = 1950, delay = 0.265, range = 750, width = 85, collision = false, aoe = false, type = "cone"},
        [_W] = { speed = 1650, delay = 0.300, range = 700, width = 250, collision = false, aoe = true, type = "circular"},
        [_R] = { speed = 2100, delay = 0.219, range = 1000, width = 100, collision = false, aoe = false, type = "linear"}
    },
        ["Heimerdinger"] = {
        [_W] = { speed = 900, delay = 0.500, range = 1325, width = 100, collision = true, aoe = false, type = "linear"},
        [_E] = { speed = 2500, delay = 0.250, range = 970, width = 180, collision = false, aoe = true, type = "circular"}
    },
        ["Irelia"] = {
        [_R] = { speed = 1700, delay = 0.250, range = 1200, width = 10, collision = false, aoe = false, type = "linear"}
    },
        ["JarvanIV"] = {
        [_Q] = { speed = 1400, delay = 0.2, range = 770, width = 0, collision = false, aoe = false, type = "linear"},
        [_E] = { speed = 200, delay = 0.2, range = 850, width = 0, collision = false, aoe = false, type = "linear"}
    },
        ["Jinx"] = {
        [_W] = { speed = 3000, delay = 0.600, range = 1400, width = 60, collision = true, aoe = false, type = "linear"},
        [_E] = { speed = 887, delay = 0.500, range = 830, width = 0, collision = false, aoe = true, type = "circular"},
        [_R] = { speed = 1700, delay = 0.600, range = 20000, width = 120, collision = false, aoe = true, type = "circular"}
    },
        ["Jayce"] = {
        [_Q] = { speed = 2350, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["Kalista"] = {
        [_Q] = { speed = 1750, delay = 0.25, range = 1450, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["Karma"] = {
        [_Q] = { speed = 1700, delay = 0.250, range = 950, width = 90, collision = true, aoe = false, type = "linear"}
    },
        ["Karthus"] = {
        [_Q] = { speed = 1700, delay = 0.25, range = 875, width = 140, collision = false, aoe = true, type = "circular"}
    },
        ["Kennen"] = {
        [_Q] = { speed = 1700, delay = 0.180, range = 1050, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["Khazix"] = {
        [_W] = { speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["KogMaw"] = {
        [_Q] = { speed = 1550, delay = 0.3667, range = 975, width = 60, collision = true, aoe = false, type = "linear"},
        [_E] = { speed = 1200, delay = 0.5, range = 1200, width = 120, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = math.huge, delay = 1.1, range = 2200, width = 65, collision = false, aoe = true, type = "circular"}
    },
        ["Leblanc"] = {
        [_E] = { speed = 1600, delay = 0.250, range = 960, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["LeeSin"] = {
        [_Q] = { speed = 1800, delay = 0.250, range = 1100, width = 100, collision = true, aoe = false, type = "linear"}
    },
        ["Leona"] = {
        [_E] = { speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular"}
    },
        ["Lissandra"] = {
        [_Q] = { speed = 1800, delay = 0.250, range = 725, width = 20, collision = true, aoe = false, type = "linear"}
    },
        ["Lucian"] = {
        [_W] = { speed = 800, delay = 0.300, range = 1000, width = 80, collision = true, aoe = false, type = "linear"}
    },
        ["Lulu"] = {
        [_Q] = { speed = 1400, delay = 0.250, range = 925, width = 80, collision = false, aoe = false, type = "linear"}
    },
        ["Lux"] = {
        [_Q] = { speed = 1350, delay = 0.25, range = 1175, width = 65, collision = true, type = "linear" },
        [_E] = { speed = 1275, delay = 0.25, range = 1100, width = 250, collision = false, type = "circular" },
        [_R] = { speed = math.huge, delay = 0.675, range = 3340, width = 190, collision = false, type = "linear" }
    },
        ["Malphite"] = {
        [_R] = { speed = 550, delay = 0.0, range = 1000, width = 300, collision = false, aoe = true, type = "circular"}
    },
        ["Malzahar"] = {
        [_Q] = { speed = 1600, delay = 0.600, range = 900, width = 200, collision = false, aoe = false, type = "linear"},
        [_W] = { speed = math.huge, delay = 0.25, range = 800, width = 240, collision = false, aoe = true, type = "circular"}
    },
        ["Mordekaiser"] = {
        [_E] = { speed = math.huge, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "cone"},
    },
        ["Morgana"] = {
        [_Q] = { speed = 1200, delay = 0.250, range = 1300, width = 80, collision = true, aoe = false, type = "linear"}
    },
        ["Nami"] = {
        [_Q] = { speed = math.huge, delay = 0.8, range = 850, width = 0, collision = false, aoe = true, type = "circular"}
    },
        ["Nautilus"] = {
        [_Q] = { speed = 2000, delay = 0.250, range = 1080, width = 80, collision = true, aoe = false, type = "linear"}
    },
        ["Nidalee"] = {
        [_Q] = { speed = 1300, delay = 0.125, range = 1500, width = 60, collision = true, aoe = false, type = "linear"},
    },
        ["Nocturne"] = {
        [_Q] = { speed = 1400, delay = 0.250, range = 1125, width = 60, collision = false, aoe = false, type = "linear"}
    },
        ["Olaf"] = {
        [_Q] = { speed = 1600, delay = 0.25, range = 1000, width = 90, collision = false, aoe = false, type = "linear"}
    },
        ["Quinn"] = {
        [_Q] = { speed = 1550, delay = 0.25, range = 1050, width = 80, collision = true, aoe = false, type = "linear"}
    },
        ["Rengar"] = {
        [_E] = { speed = 1500, delay = 0.50, range = 1000, width = 80, collision = false, aoe = false, type = "linear"}
    },
        ["Riven"] = {
        [_R] = { speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone"}
    },
        ["Rumble"] = {
        [_E] = { speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear"}
    },
        ["Ryze"] = {
        [_Q] = { speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear"}
    },
        ["Sejuani"] = {
        [_R] = { speed = 1600, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear"}
    },
        ["Shyvana"] = {
        [_E] = { speed = 1500, delay = 0.250, range = 925, width = 60, collision = false, aoe = false, type = "linear"}
    },
        ["Sivir"] = {
        [_Q] = { speed = 1330, delay = 0.250, range = 1075, width = 0, collision = false, aoe = false, type = "linear"}
    },
        ["Skarner"] = {
        [_E] = { speed = 1200, delay = 0.600, range = 350, width = 60, collision = false, aoe = false, type = "linear"}
    },
        ["Sona"] = {
        [_R] = { speed = 2400, delay = 0.5, range = 1050, width = 160, collision = false, aoe = false, type = "linear"}
    },
        ["Swain"] = {
        [_W] = { speed = math.huge, delay = 0.850, range = 900, width = 125, collision = false, aoe = true, type = "circular"}
    },
        ["Syndra"] = {
        [_Q] = { speed = math.huge, delay = 0.600, range = 790, width = 125, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 2500, delay = 0.250, range = 700, width = 45, collision = false, aoe = true, type = "cone"}
    },
        ["Thresh"] = {
        [_Q] = { speed = 1900, delay = 0.500, range = 1050, width = 70, collision = true, aoe = false, type = "linear"}
    },
        ["Twitch"] = {
        [_W] = {speed = 1750, delay = 0.250, range = 950, width = 275, collision = false, aoe = true, type = "circular"}
    },
        ["TwistedFate"] = {
        [_Q] = { speed = 1500, delay = 0.250, range = 1200, width = 80, collision = false, aoe = false, type = "cone"}
    },
        ["Urgot"] = {
        [_Q] = { speed = 1600, delay = 0.2, range = 1400, width = 80, collision = true, aoe = false, type = "linear"},
        [_E] = { speed = 1750, delay = 0.3, range = 920, width = 200, collision = false, aoe = true, type = "circular"}
    },
        ["Varus"] = {
        [_Q] = { speed = 1500, delay = 0.5, range = 1475, width = 100, collision = false, aoe = false, type = "linear"},
        [_E] = { speed = 1750, delay = 0.25, range = 925, width = 235, collision = false, aoe = true, type = "circular"},
        [_R] = { speed = 1200, delay = 0.5, range = 800, width = 100, collision = false, aoe = false, type = "linear"}
    },
        ["Veigar"] = {
        [_Q] = { speed = 1200, delay = 0.25, range = 875, width = 75, collision = true, aoe = false, type = "linear"},
        [_W] = { speed = 900, delay = 1.25, range = 900, width = 110, collision = false, aoe = true, type = "circular"}
    },
        ["Vi"] = {
        [_Q] = { speed = 1500, delay = 0.25, range = 715, width = 55, collision = false, aoe = false, type = "linear"},
    },
        ["Viktor"] = {
        [_W] = { speed = 750, delay = 0.6, range = 700, width = 125, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 1200, delay = 0.25, range = 1200, width = 0, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = 1000, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "circular"},
    },
        ["Velkoz"] = {
        [_Q] = { speed = 1300, delay = 0.066, range = 1050, width = 50, collision = true, aoe = false, type = "linear"},
        [_W] = { speed = 1700, delay = 0.064, range = 1050, width = 80, collision = false, aoe = false, type = "linear"},
        [_E] = { speed = 1500, delay = 0.333, range = 850, width = 225, collision = false, aoe = true, type = "circular"},
        [_R] = { speed = math.huge, delay = 0.333, range = 1550, width = 50, collision = false, aoe = false, type = "linear"}
    },    
        ["Xerath"] = {
        [_Q] = { speed = math.huge, delay = 1.75, range = 750, width = 100, collision = false, aoe = false, type = "linear"},
        [_W] = { speed = math.huge, delay = 0.25, range = 1100, width = 100, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 1600, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear"},
        [_R] = { speed = math.huge, delay = 0.75, range = 3200, width = 245, collision = false, aoe = true, type = "circular"}
    },
        ["Yasuo"] = {
        [_Q] =  { speed = math.huge, delay = 250, range = 475, width = 40, collision = false, aoe = false, type = "linear"},
    },
        ["Zac"] = {
        [_Q] = { speed = 2500, delay = 0.110, range = 500, width = 110, collision = false, aoe = false, type = "linear"},
    },
        ["Zed"] = {
        [_Q] = { speed = 1700, delay = 0.25, range = 925, width = 50, collision = false, aoe = false, type = "linear"},
    },
        ["Ziggs"] = {
        [_Q] = { speed = 1750, delay = 0.25, range = 1400, width = 155, collision = true, aoe = false, type = "linear"},
        [_W] = { speed = 1800, delay = 0.25, range = 970, width = 275, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 1750, delay = 0.12, range = 900, width = 350, collision = false, aoe = true, type = "circular"},
        [_R] = { speed = 1750, delay = 0.14, range = 5300, width = 525, collision = false, aoe = true, type = "circular"},
    },
        ["Zilean"] = {
        [_Q] = { speed = math.huge, delay = 0.5, range = 900, width = 150, collision = false, aoe = true, type = "circular"},
    },
        ["Zyra"] = {
        [_Q] = { speed = math.huge, delay = 0.7, range = 800, width = 85, collision = false, aoe = true, type = "circular"},
        [_E] = { speed = 1150, delay = 0.25, range = 1100, width = 70, collision = false, aoe = false, type = "linear"},
        [_R] = { speed = math.huge, delay = 1, range = 1100, width = 500, collision=false, aoe = true, type = "circular" }
    }
}
--[[ Skillshot list end ]]--

if not _G.Champs[myHero.charName] then _G.Champs = nil collectgarbage() return end -- not supported :(

AimbotVersion = 1.52

--Scriptstatus Tracker
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILKJJKPQMO") 
--Scriptstatus Tracker

function OnLoad()
  Aim = nil
  if Update() then
    return
  else
    Aim = Aimbot()
    DelayAction(function() AutoupdaterMsg("Loaded the latest version (v"..AimbotVersion..")") end, 5)
  end
end

function Update()
  local AUTO_UPDATE = true
  local UPDATE_HOST = "raw.github.com"
  local UPDATE_PATH = "/nebelwolfi/BoL/master/Aimbot.lua".."?rand="..math.random(1,10000)
  local UPDATE_FILE_PATH = SCRIPT_PATH.."Aimbot.lua"
  local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
  if AUTO_UPDATE then
    local AimbotServerData = GetWebResult(UPDATE_HOST, "/nebelwolfi/BoL/master/Aimbot.version")
    if AimbotServerData then
      AimbotServerVersion = type(tonumber(ServerData)) == "number" and tonumber(AimbotServerData) or nil
      if AimbotServerVersion then
        if tonumber(AimbotVersion) < AimbotServerVersion then
          AutoupdaterMsg("New version available v"..AimbotServerVersion)
          AutoupdaterMsg("Updating, please don't press F9")
          DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..AimbotVersion.." => "..AimbotServerVersion.."), press F9 twice to load the updated version") end) end, 3)
          return true
        end
      end
    else
      AutoupdaterMsg("Error downloading version info")
    end
  end
  if FileExist(LIB_PATH .. "/UPL.lua") then
    require("UPL")
    _G.UPL = UPL()
  else 
    AutoupdaterMsg("Downloading UPL, please don't press F9")
    DelayAction(function() DownloadFile("https://"..UPDATE_HOST.."/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () AutoupdaterMsg("Successfully downloaded UPL. Press F9 twice.") end) end, 3) 
    return true
  end
  return false
end

function AutoupdaterMsg(msg) 
    print("<font color=\"#6699ff\"><b>[Aimbot]:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") 
end

class "Aimbot"

function Aimbot:__init()
  self:Vars()
  self:Menu()
  AddTickCallback(function() self:Tick() end)
  AddDrawCallback(function() self:Draw() end)
  AddMsgCallback(function(x,y) self:Msg(x,y) end)
  HookPackets()
  AddSendPacketCallback(function(p) self:SendPacket(p) end)
  AddRecvPacketCallback2(function(p) self:RecvPacket(p) end)
end
function Aimbot:Vars()
    self.data = _G.Champs[myHero.charName]
    self.QReady, self.WReady, self.EReady, self.RReady = nil, nil, nil, nil
    self.Target = nil
    self.QSel, self.WSel, self.ESel, self.RSel = nil, nil, nil, nil
    self.str = { [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R" }
    --local key = { [_Q] = "Y", [_W] = "X", [_E] = "C", [_R] = "V" } soon
    self.toCast = {[_Q] = false, [_W] = false, [_E] = false, [_R] = false}
    self.toAim = {[_Q] = false, [_W] = false, [_E] = false, [_R] = false}
    self.debugMode = false
    self.opcs = {{0x50, 0xAD, 0xED, 0x8D, 0xCD}, {0x9B, 0x6B, 0x6A, 0x69, 0x68}, {0x09, 0xC8, 0xF7, 0xF2, 0x33}, {0x10B, 0x68, 0xEE, 0xB1, 0xCE}, {0x87, 0xEC, 0x6C, 0x74, 0x98}, {0x00E9, 0x02, 0xD8, 0xB3, 0xE7}}
    self.opcpos = {31, 10, 27, 27, 23, 27}
    self.secondCast = false
    self.lastopc = nil
    self.LastPacket = 0
end

function Aimbot:Menu()

  self.Config = scriptConfig("[Aimbot] "..myHero.charName, "Aimbot2"..myHero.charName)
  
  self.Config:addSubMenu("Settings", "misc")
  self.Config.misc:addParam("pc", "Use Packets To Cast Spells", SCRIPT_PARAM_ONOFF, false)
  self.Config.misc:addParam("ser",  "Which LoL version?", SCRIPT_PARAM_LIST, 1, {"5.12", "5.11", "5.10", "5.9", "5.8", "5.7"})
  UPL:AddToMenu(self.Config.misc)
 
  self.Config:addSubMenu("Supported skill settings", "skConfig")
  self.Config.skConfig:addParam("nfo", "0 = Off, 1 = Predict/Rather Mouse, ", SCRIPT_PARAM_INFO,"")
  self.Config.skConfig:addParam("nfn", "2 = Rather Predict/Mouse, 3 = Predict Only", SCRIPT_PARAM_INFO,"")
  for k,v in pairs(self.data) do
    self.Config.skConfig:addParam(self.str[k], ""..self.str[k], SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
    self.toAim[k] = true
    UPL:AddSpell(k, v)
  end

  self.Config:addParam("isstream", "Streaming Mode (needs reload)", SCRIPT_PARAM_ONOFF, false)
  
  self.Config:addParam("tog", "Aimbot on/off", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
  self.Config:addParam("off", "Aimbot disabled", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))

  if not self.Config.isstream then
    self.Config:permaShow("tog")
    self.Config:permaShow("off")
  end
  
  if self.toAim[0] then self.QSel = TargetSelector(TARGET_NEAR_MOUSE, self.data[0].range, DAMAGE_MAGIC, true) end
  if self.toAim[1] then self.WSel = TargetSelector(TARGET_NEAR_MOUSE, self.data[1].range, DAMAGE_MAGIC, true) end
  if self.toAim[2] then self.ESel = TargetSelector(TARGET_NEAR_MOUSE, self.data[2].range, DAMAGE_MAGIC, true) end
  if self.toAim[3] then self.RSel = TargetSelector(TARGET_NEAR_MOUSE, self.data[3].range, DAMAGE_MAGIC, true) end
end

function Aimbot:Tick()
  -- [[ Last hitter part ]] --
  --if Config.lh and not myHero.dead and not recall then 
  --end
  -- [[ Real aimbot part ]] --
  if self.Config.tog and not self.Config.off and not myHero.dead and self:IsFirstCast() and (self.toCast[0] or self.toCast[1] or self.toCast[2] or self.toCast[3] or self.secondCast) then -- 
      for i, spell in pairs(self.data) do
          self.Target = self:GetCustomTarget(i)
          if self.Target == nil or self.Target.dead then return end
          if ((self.secondCast or self.toCast[i]) and self.Config.skConfig[self.str[i]] > 0) and myHero:CanUseSpell(i) then
              if self:IsJayceQ(i) then 
                if myHero:CanUseSpell(_E) then 
                    self.data[_Q] = { speed = 2350, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear"}
                    UPL:AddSpell(_Q, self.data[_Q])
                    self:CCastSpell(_E, myHero)
                else 
                    self.data[_Q] = { speed = 1300, delay = 0.15, range = 1150, width = 70, collision = true, aoe = false, type = "linear"}
                    UPL:AddSpell(_Q, self.data[_Q])
                end 
              end
              local CastPosition, HitChance, Position = UPL:Predict(i, myHero, self.Target)
              if debugMode then PrintChat("1 - Attempt to aim!") end
              if HitChance and HitChance >= 3 then
                  if debugMode then PrintChat("2 - Aimed skill! Precision: "..HitChance) end
                  self:CCastSpell(i, CastPosition)
              elseif HitChance and HitChance >= 2 then
                  if debugMode then PrintChat("2 - Aimed skill! Precision: "..HitChance) end
                  self:CCastSpell(i, CastPosition)
              elseif HitChance and HitChance >= 1.5 and self.Config.skConfig[self.str[i]] >= 1 then
                  if debugMode then PrintChat("2 - Aimed skill! Precision: "..HitChance) end
                  self:CCastSpell(i, CastPosition)
              elseif HitChance and HitChance >= 1 and self.Config.skConfig[self.str[i]] >= 2 then
                  if debugMode then PrintChat("2 - Aimed skill! Precision: "..HitChance) end
                  self:CCastSpell(i, CastPosition)
              else
                  local enemies = self:EnemiesAround(self.Target, 250) -- Maybe needs some adjustment
                  if enemies > 0 then
                    if debugMode then PrintChat("2 - Checking other enemies around target...") end
                    self.Target = self:GetNextCustomTarget(i, self.Target)
                   if ValidTarget(self.Target) then
                    local CastPosition, HitChance, Position = UPL:Predict(i, myHero, self.Target)
                    if HitChance and HitChance >= 2 then
                      if not myHero:CanUseSpell(i) then return end
                      if debugMode then PrintChat("3 - Aimed skill! Precision: "..HitChance) end
                      self:CCastSpell(i, CastPosition)
                    elseif HitChance and HitChance >= 1.5 and self.Config.skConfig[self.str[i]] >= 1 then
                      if not myHero:CanUseSpell(i) then return end
                      if debugMode then PrintChat("3 - Aimed skill! Precision: "..HitChance) end
                      self:CCastSpell(i, CastPosition)
                    elseif HitChance and HitChance >= 1 and self.Config.skConfig[self.str[i]] >= 2 then
                      if not myHero:CanUseSpell(i) then return end
                      if debugMode then PrintChat("3 - Aimed skill! Precision: "..HitChance) end
                      self:CCastSpell(i, CastPosition)
                    end
                   end
                   if myHero:CanUseSpell(i) then
                    if self.Config.skConfig[self.str[i]] <= 2 then if debugMode then PrintChat("3 - No better target found - to mouse") end self:CCastSpell(i, mousePos) end
                   end
                  else
                    if self.Config.skConfig[self.str[i]] <= 2 then if debugMode then PrintChat("2 - To mouse") end self:CCastSpell(i, mousePos) end
                  end
              end self.toCast[i] = false
          end
      end 
  end
end   

function Aimbot:EnemiesAround(Unit, range)
  local c=0
  for i=1,heroManager.iCount do hero = heroManager:GetHero(i) if hero.team ~= myHero.team and hero.x and hero.y and hero.z and GetDistance(hero, Unit) < range then c=c+1 end end return c
end

function Aimbot:Msg(msg, key)
   if msg == KEY_DOWN and self.Config.skConfig["Q"] and self:IsChargeable(0) and myHero:CanUseSpell(_Q) == READY then
    DelayAction(function() if not self.secondCast and myHero:CanUseSpell(_Q) == READY then self.toCast[0] = true self.secondCast = true end end, 1.5)
   end
   if msg == KEY_UP and key == GetKey("Q") and self.toAim[0] and not self.secondCast then
     self.toCast[0] = false
     self.secondCast = false
   elseif msg == KEY_UP and key == GetKey("W") and self.toAim[1] and not self.secondCast then 
     self.toCast[1] = false
     self.secondCast = false
   elseif msg == KEY_UP and key == GetKey("E") and self.toAim[2] and not self.secondCast then 
     self.toCast[2] = false
     self.secondCast = false
   elseif msg == KEY_UP and key == GetKey("R") and self.toAim[3] and not self.secondCast then
     self.toCast[3] = false
     self.secondCast = false
   end
end

function Aimbot:IsVeigarLuxQ(i)
  if myHero.charName == 'Lux' then
    if i == 0 then
      return true
    else
      return false
    end
  elseif myHero.charName == 'Veigar' then
    if i == 0 then
      return true
    else
      return false
    end 
  else
    return false
  end
end

function Aimbot:IsChargeable(i)
  if myHero.charName == 'Varus' then
    if i == 0 then
      return true
    else
      return false
    end
  elseif myHero.charName == 'Vi' then
    if i == 0 then
      return true
    else
      return false
    end 
  elseif myHero.charName == 'Xerath' then
    if i == 0 then
      return true
    else
      return false
    end 
  else
    return false
  end
end

function Aimbot:IsFirstCast()
    if myHero.charName == 'LeeSin' then
        if myHero:GetSpellData(_Q).name == 'BlindMonkQOne' then
            return true
        else
            return false
        end
    elseif myHero.charName == 'Thresh' then
        if myHero:GetSpellData(_Q).name == 'ThreshQ' then
            return true
        else
            return false
        end 
    elseif myHero.charName == 'Jayce' then
        if myHero:GetSpellData(_Q).name == 'jayceshockblast' then
            return true
        else
            return false
        end 
    elseif myHero.charName == 'Nidalee' then
        if myHero:GetSpellData(_Q).name == 'JavelinToss' then
            return true
        else
            return false
        end 
    elseif myHero.charName == 'Lux' then
        if myHero:GetSpellData(_E).name == 'LuxLightStrikeKugel' then
            return true
        else
            return false
        end 
    else 
        return true
    end
end

function Aimbot:IsJayceQ(i)
  if myHero.charName == 'Jayce' then
    if i == 0 then
      return true
    else
      return false
    end
  else
    return false
  end
end

function Aimbot:Draw()
    if not self.debugMode or myHero.dead then
        return
    end
    DrawHitBox(myHero, 2, ARGB(255,255,255,255))
    DrawCircle3D(myHero.x, myHero.y, myHero.z, GetDistance(myHero.minBBox, myHero.pos), 1, ARGB(255,255,255,255), 32)
    if myHero.hasMovePath and myHero.pathCount >= 2 then
      local IndexPath = myHero:GetPath(myHero.pathIndex)
      if IndexPath then
        DrawLine3D(myHero.x, myHero.y, myHero.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 255, 255, 255))
      end
      for i=myHero.pathIndex, myHero.pathCount-1 do
        local Path = myHero:GetPath(i)
        local Path2 = myHero:GetPath(i+1)
        DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 255))
      end
    end
    for i, enemy in ipairs(GetEnemyHeroes()) do
      DrawCircle3D(enemy.x, enemy.y, enemy.z, GetDistance(myHero.minBBox, myHero.pos), 1, ARGB(255,255,255,255), 32)
      DrawHitBox(enemy, 2, ARGB(255,255,255,255))
      if enemy == nil then
        return
      end
      if enemy.hasMovePath and enemy.pathCount >= 2 then
        local IndexPath = enemy:GetPath(enemy.pathIndex)
        if IndexPath then
          DrawLine3D(enemy.x, enemy.y, enemy.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 255, 255, 255))
        end
        for i=enemy.pathIndex, enemy.pathCount-1 do
          local Path = enemy:GetPath(i)
          local Path2 = enemy:GetPath(i+1)
          DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 255))
        end
      end
    end
end

function Aimbot:SendPacket(p)
  if self.Config.tog and not self.Config.off and not myHero.dead and self:IsFirstCast() then
    local head = p.header
    if head == self.opcs[self.Config.misc.ser][1] then -- old: 0x00E9
        p.pos=self.opcpos[self.Config.misc.ser]
        local opc = p:Decode1()
		if debugMode then print("Opcode "..('0x%02X'):format(opc)) end
        for i=0,3 do
            if opc == self.opcs[self.Config.misc.ser][i+2] and not self.toCast[i] and self.toAim[i] and self.Config.skConfig[self.str[i]] > 0 and not self:IsChargeable(i) then -- old: 0x02
              self.Target = self:GetCustomTarget(i)
              if self.Target ~= nil then
                p:Block()
                p.skip(p, 1)
    			self.toCast[i] = true
              end
            end
        end
    end
  end
end

function Aimbot:RecvPacket(p)
  if self.Config.tog and not self.Config.off and not myHero.dead then
    local head = p.header
    if head == 0x22 and self:IsChargeable(_Q) then
      self.toCast[_Q] = true
      self.secondCast = true
    end
  end
end

function Aimbot:GetCustomTarget(i)
    if self.toAim[0] then self.QSel:update() end
    if self.toAim[1] then self.WSel:update() end
    if self.toAim[2] then self.ESel:update() end
    if self.toAim[3] then self.RSel:update() end
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    if i == 0 then
      return self.QSel.target
    elseif i == 1 then
      return self.WSel.target
    elseif i == 2 then
      return self.ESel.target
    elseif i == 3 then
      return self.RSel.target
    else
      return nil
    end
end

function Aimbot:GetNextCustomTarget(i, tar)
	local targ = nil
	for _, unit in pairs(GetEnemyHeroes()) do
		if targ and targ.valid and unit and unit.valid and unit ~= tar then
			if GetDistance(unit, mousePos) < GetDistance(targ, mousePos) then
				targ = unit
			end
		else
			targ = unit
		end
	end
	return targ
end

--[[ Packet Cast Helper ]]--
function Aimbot:CCastSpell(Spell, Pos)
  if self:IsChargeable(Spell) and self.secondCast then
    self.secondCast = false
    CastSpell2(Spell, D3DXVECTOR3(Pos.x, Pos.y, Pos.z))
  else
    if VIP_USER and self.Config.misc.pc then
        Packet("S_CAST", {spellId = Spell, fromX = Pos.x, fromY = Pos.z, toX = Pos.x, toY = Pos.z}):send()
    else
        CastSpell(Spell, Pos.x, Pos.z)
    end
  end
end