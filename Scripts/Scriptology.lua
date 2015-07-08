--[[

     ____           _       __         __                
    / __/____ ____ (_)___  / /_ ___   / /___  ___ _ __ __
   _\ \ / __// __// // _ \/ __// _ \ / // _ \/ _ `// // /
  /___/ \__//_/  /_// .__/\__/ \___//_/ \___/\_, / \_, / 
                   /_/                      /___/ /___/  

    By Scriptologe a.k.a Nebelwolfi

    Credits and thanks to: DefinitelyRiot

]]--

--[[
  SAhriVersion          = 1.2 -- r catch angle fix
  SAsheVersion          = 1.4 -- removed ult over whole map
  SAzirVersion          = 1   -- initial release
  SBlitzcrankVersion    = 1.1 -- fixed R ks
  SBrandVersion         = 1   -- initial release
  SCassiopeiaVersion    = 1.4 -- facingme fixed
  SDariusVersion        = 1.2 -- auto Q harrass added
  SEkkoVersion          = 1   -- initial release
  SKalistaVersion       = 1.3 -- fixed and improved shitload stuff
  SKatarinaVersion      = 1.1 -- fixed all toggles in not-combo-modes
  SKogmawVersion        = 1   -- initial release
  SLeeSinVersion        = 1.2 -- is now live
  SLuxVersion           = 1.4 -- fixes
  SMalzaharVersion      = 1   -- initial release
  SNidaleeVersion       = 1.9 -- fixed harrass bugsplat
  SOriannaVersion       = 1.3 -- better ult calculation
  SRengarVersion        = 1.7 -- reworked completely
  SRivenVersion         = 1.2 -- combo R fix, laneclear fix
  SRyzeVersion          = 1.2 -- anti combo break
  SRumbleVersion        = 1   -- initial release
  STalonVersion         = 1   -- initial release
  STeemoVersion         = 1.1 -- Q is now QQQ
  SVayneVersion         = 1   -- initial release
  SVolibearVersion      = 1.1 -- error spam fix
 ]]--

--Scriptstatus Tracker
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("TGJIHINHFFL") 
--Scriptstatus Tracker

_G.ScriptologyVersion    = 1.88
_G.ScriptologyAutoUpdate = true
_G.ScriptologyLoaded     = false
_G.ScriptologyDebug      = false

-- { Global functions

  function OnLoad()
    require("sScriptConfig")
    champList = { "Ahri", "Ashe", "Azir", "Blitzcrank", "Brand", "Cassiopeia", "Darius", "Ekko", "Kalista", "Katarina", 
                  "KogMaw", "LeeSin", "Lux", "Malzahar", "Nidalee", "Orianna", "Rengar", "Riven", "Ryze", "Rumble", 
                  "Talon", "Teemo", "Vayne", "Volibear", "Yasuo" }
    supported = {}
    for _,champ in pairs(champList) do
      supported[champ] = true
    end
    if supported[myHero.charName] then
      if ScriptologyAutoUpdate and Update() then
        return
      else
        Auth()
      end
    else
      ScriptologyMsg("Your Champion is not supported (yet)!")
    end
  end

  function Load()
    Menu()
    Vars()
    loadedClass = _G[myHero.charName]()
    AddTickCallback(function() Tick() end)
    AddDrawCallback(function() Draw() end)
    if objTrackList[myHero.charName] then
      AddCreateObjCallback(function(x) CreateObj(x) end)
      AddDeleteObjCallback(function(x) DeleteObj(x) end)
    end
    if trackList[myHero.charName] then
      AddApplyBuffCallback(function(x,y,z) ApplyBuff(x,y,z) end)
      AddUpdateBuffCallback(function(x,y,z) UpdateBuff(x,y,z) end)
      AddRemoveBuffCallback(function(x,y) RemoveBuff(x,y) end)
    end
    AddProcessSpellCallback(function(x,y) ProcessSpell(x,y) end)
    DelayAction(function() ScriptologyMsg("Loaded the latest version (v"..ScriptologyVersion..")") end, 3)
  end

  function Auth()
    if authAttempt then authAttempt = authAttempt + 1 else authAttempt = 1 end
    authList = { }
    auth     = {}
    for _,champ in pairs(authList) do
      auth[champ] = true
    end
    if not auth[myHero.charName] then
      Load()
      ScriptologyMsg("No auth needed")
      return true 
    end
    local authdata = GetWebResult("scriptology.tk", "/users/"..GetUser():lower().."."..myHero.charName:lower())
    if authdata and authAttempt < 9 then
      if type(tonumber(authdata)) == "number" and tonumber(authdata) == -1 then
        ScriptologyMsg("Authed! Hello "..GetUser())
        Load()
        return true
      elseif type(tonumber(authdata)) == "number" and tonumber(authdata) > 0 then
        ScriptologyMsg("Trial mode active! Hello "..GetUser())
        Load()
        return true
      else
        ScriptologyMsg("User: "..GetUser().." not found. Auth failed..")
        return false
      end
    elseif authAttempt < 9 then
      ScriptologyMsg("Auth failed, retrying. Attempt "..authAttempt.."/8")
      DelayAction(Auth, 2)
    else
      ScriptologyMsg("Auth failed. Please try again later..")
    end
  end

  function Update()
    local ScriptologyServerData = GetWebResult("raw.github.com", "/nebelwolfi/BoL/master/Scriptology.version")
    if ScriptologyServerData then
      ScriptologyServerVersion = type(tonumber(ScriptologyServerData)) == "number" and tonumber(ScriptologyServerData) or nil
      if ScriptologyServerVersion then
        if tonumber(ScriptologyVersion) < ScriptologyServerVersion then
          ScriptologyMsg("New version available v"..ScriptologyServerVersion)
          ScriptologyMsg("Updating, please don't press F9")
          DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Scriptology.lua".."?rand="..math.random(1,10000), SCRIPT_PATH.."Scriptology.lua", function () ScriptologyMsg("Successfully updated. ("..ScriptologyVersion.." => "..ScriptologyServerVersion.."), press F9 twice to load the updated version") end) DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/sScriptConfig.lua".."?rand="..math.random(1,10000), LIB_PATH.."sScriptConfig.lua", function () end) end, 3)
          return true
        end
      end
    else
      ScriptologyMsg("Error downloading version info")
    end
    if myHero.charName ~= "Darius" and myHero.charName ~= "Katarina" and myHero.charName ~= "Riven" and myHero.charName ~= "Teemo" and myHero.charName ~= "Volibear" and not _G.UPLloaded then
      if FileExist(LIB_PATH .. "/UPL.lua") then
        require("UPL")
        _G.UPL = UPL()
      else 
        ScriptologyMsg("Downloading UPL, please don't press F9")
        DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () ScriptologyMsg("Successfully downloaded UPL. Press F9 twice.") end) end, 3) 
        return true
      end
    end
    return false
  end

  function Menu()
    Config = sScriptConfig("Scriptology "..myHero.charName, "Scriptology") -- <- u mad?
    Config:addState("Combo")
    Config:addState("Harrass")
    if myHero.charName ~= "Blitzcrank" then Config:addState("Farm")
    Config:addSubStates("Farm", {"LaneClear", "LastHit"}) end
    if myHero.charName ~= "Riven" then Config:addState("Killsteal") end
    Config:addState("Draws")
    if myHero.charName ~= "Volibear" and myHero.charName ~= "Teemo" then 
      Config:addState("Misc")
      if myHero.charName == "Lux" then Config:addParam({state = "Misc", name = "Wa", code = SCRIPT_PARAM_ONOFF, value = true})
                                       Config:addParam({state = "Misc", name = "Ea", code = SCRIPT_PARAM_ONOFF, value = true}) end
      if myHero.charName == "Kalista" then Config:addParam({state = "Misc", name = "Ej", code = SCRIPT_PARAM_ONOFF, value = true})
                                           Config:addParam({state = "Misc", name = "AA_Gap", code = SCRIPT_PARAM_ONOFF, value = true})
                                           Config:addParam({state = "Misc", name = "R", code = SCRIPT_PARAM_ONOFF, value = true}) end 
      if myHero.charName == "Rumble" then Config:addParam({state = "Misc", name = "Wa", code = SCRIPT_PARAM_ONOFF, value = true})
                                          Config:addParam({state = "Misc", name = "Ra", code = SCRIPT_PARAM_ONOFF, value = true}) end 
      if myHero.charName == "Lux" then Config:addParam({state = "Misc", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"W"}, slider = {50}}) end 
      if myHero.charName == "Nidalee" then Config:addParam({state = "Misc", name = "Ea", code = SCRIPT_PARAM_ONOFF, value = true})
                                           Config:addParam({state = "Misc", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"E"}, slider = {50}}) end
      if myHero.charName == "Orianna" then Config:addParam({state = "Misc", name = "Ra", code = SCRIPT_PARAM_ONOFF, value = true}) end
      if myHero.charName == "Vayne" then Config:addParam({state = "Misc", name = "Ea", code = SCRIPT_PARAM_ONOFF, value = false})
                                         Config:addParam({state = "Misc", name = "offset", code = SCRIPT_PARAM_SLICE, text = {"E"}, slider = {90}}) end
      if myHero.charName == "Yasuo" then Config:addParam({state = "Misc", name = "Wa", code = SCRIPT_PARAM_ONOFF, value = true}) end
      if myHero.charName ~= "Darius" and myHero.charName ~= "Katarina" and myHero.charName ~= "Riven" then UPL:AddToMenu2(Config, "Misc") end 
    end
    Config:addParam({state = "Draws", name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
    if myHero.charName ~= "Orianna" then
      Config:addParam({state = "Draws", name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = "Draws", name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = "Draws", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Draws", name = "DMG", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Draws", name = "LFC", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Draws", name = "Opacity", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E","R"}, slider = {30,30,30,30}})
    SetupOrbwalk()
  end

  function Vars()
    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end
    if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then Smite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonersmite") then Smite = SUMMONER_2 end
    killTextTable = {}
    for k,enemy in pairs(GetEnemyHeroes()) do
      killTextTable[enemy.networkID] = { indicatorText = "", damageGettingText = ""}
    end
    stackTable = {}
    championData = {
        ["Ahri"] = {
          [_Q] = { range = 880, delay = 0.25, speed = 1600, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15+25*level+0.35*AP end},
          [_W] = { range = 600, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15+25*level+0.4*AP end},
          [_E] = { range = 950, delay = 0.25, speed = 1550, width = 60, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 25+35*level+0.5*AP end},
          [_R] = { range = 800, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 40*level+30+0.3*AP end}
        },
        ["Ashe"] = {
          [_Q] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(AP, level, Level, TotalDmg, source, target) return (0.05*level+1.1)*TotalDmg end},
          [_W] = { speed = 902, delay = 0.5, range = 1200, width = 100, collision = true, aoe = false, type = "cone", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 10*level+30+TotalDmg end},
          [_E] = { speed = 1500, delay = 0.25, range = 25000, width = 80, collision = false, aoe = false, type = "linear"},
          [_R] = { speed = 1600, delay = 0.5, range = 25000, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 175*level+75+AP end}
        },
        ["Azir"] = {
          [_Q] = { speed = 500, delay = 0.250, range = 800, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 45+20*level+0.05*AP end},
          [_W] = { speed = math.huge, delay = 0, range = 450, width = 350, collision = false, aoe = false, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return (Level < 11 and 45+5*Level or Level*10)+0.6*AP+(GetMaladySlot() and 15+0.15*AP or 0) end},
          [_E] = { range = 1300, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 40+40*level+0.4*AP end},
          [_R] = { speed = 1300, delay = 0.2, range = 500, width = 200, collision = false, aoe = true, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 75+75*level+0.5*AP end}
        },
        ["Blitzcrank"] = {
          [_Q] = { speed = 1800, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 55*level+25+AP end},
          [_W] = { range = 25000},
          [_E] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 2*TotalDmg end},
          [_R] = { speed = math.huge, delay = 0.25, range = 0, width = 500, collision = false, aoe = false, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 125*level+125+AP end}
        },
        ["Brand"] = {
          [_Q] = { speed = 1200, delay = 0.5, range = 1050, width = 80, collision = true, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 40*level+40+0.65*AP end},
          [_W] = { speed = 900, delay = 0.25, range = 1050, width = 275, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 45*level+30+0.6*AP end},
          [_E] = { range = 625, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 25*level+30+0.55*AP end},
          [_R] = { range = 750, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 100*level+50+0.5*AP end}
        },
        ["Cassiopeia"] = {
          [_Q] = { speed = math.huge, delay = 0.25, range = 850, width = 100, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 45+30*level+0.45*AP end},
          [_W] = { speed = 2500, delay = 0.5, range = 925, width = 90, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 5+5*level+0.1*AP end},
          [_E] = { range = 700, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+25*level+0.55*AP end},
          [_R] = { speed = math.huge, delay = 0.5, range = 825, width = 410, collision = false, aoe = true, type = "cone", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+10*level+0.5*AP end}
        },
        ["Darius"] = {
          [_Q] = { range = 0, width = 450, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 35*level+35+0.7*TotalDmg end},
          [_W] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(AP, level, Level, TotalDmg, source, target) return TotalDmg+0.2*level*TotalDmg end},
          [_E] = { range = 550},
          [_R] = { range = 450, dmgTRUE = function(AP, level, Level, TotalDmg, source, target) return math.floor(70+90*level+0.75*myHero.addDamage+0.2*GetStacks(target)*(70+90*level+0.75*myHero.addDamage)) end}
        },
        ["Ekko"] = {
          [_Q] = { speed = 1050, delay = 0.25, range = 825, width = 140, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15*level+45+0.2*AP end},
          [_W] = { speed = math.huge, delay = 2, range = 1050, width = 450, collision = false, aoe = true, type = "circular"},
          [_E] = { delay = 0.50, range = 350, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30*level+20+0.2*AP+TotalDmg end},
          [_R] = { speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 150*level+50+1.3*AP end}
        },
        ["Gnar"] = {
          [_Q] = { range = 0},
          [_W] = { range = 0},
          [_E] = { range = 0},
          [_R] = { range = 0}
        },
        ["Hecarim"] = {
          [_Q] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 25+35*level+0.6*TotalDmg end},
          [_W] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 8.75+11.25*level+0.2*AP end},
          [_E] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 5+35*level+0.5*TotalDmg end},
          [_R] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 50+100*level+AP end}
        },
        ["Jarvan"] = {
          [_Q] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 25+45*level+1.2*TotalDmg end},
          [_W] = { },
          [_E] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15+45*level+0.8*AP end},
          [_R] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 75+125*level+1.5*TotalDmg end}
        },
        ["Kalista"] = {
          [_Q] = { speed = 1750, delay = 0.25, range = 1275, width = 70, collision = true, aoe = false, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 0-50+60*level+TotalDmg end},
          [_W] = { delay = 1.5, range = 5500},
          [_E] = { delay = 0.50, range = 1000, dmgAD = function(AP, level, Level, TotalDmg, source, target) return GetStacks(target) > 0 and (10 + (10 * level) + (TotalDmg * 0.6)) + (GetStacks(target)-1) * (kalE(level) + (0.2 + 0.03 * (level-1))*TotalDmg) or 0 end},
          [_R] = { range = 4000}
        },
        ["Katarina"] = {
          [_Q] = { range = 675, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 35+25*level+0.45*AP end},
          [_W] = { range = 375, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 5+35*level+0.25*AP+0.6*TotalDmg end},
          [_E] = { range = 700, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 10+30*level+0.25*AP end},
          [_R] = { range = 550, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+10*level+0.2*AP+0.3*source.addDamage end}
          },
        ["KogMaw"] = {
          [_Q] = { range = 975, delay = 0.25, speed = 1600, width = 80, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+50*level+0.5*AP end},
          [_W] = { range = function() return myHero.range + myHero.boundingRadius*2 + 110+20*myHero:GetSpellData(_W).level end, dmgAP = function(AP, level, Level, TotalDmg, source, target) return target.maxHealth*0.01*(level+1)+0.01*AP+TotalDmg end},
          [_E] = { range = 1200, delay = 0.25, speed = 1300, width = 120, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 10+50*level+0.7*AP end},
          [_R] = { range = 1500, speed = math.huge, delay = 1.1,  width = 250, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 40+40*level+0.3*AP+0.5*TotalDmg end}
        },
        ["LeBlanc"] = {
          [_Q] = { range = 700, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+25*level+0.4*AP end},
          [_W] = { speed = 1300, delay = 0.250, range = 600, width = 250, collision = false, aoe = false, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 45+40*level+0.6*AP end},
          [_E] = { speed = 1300, delay = 0.250, range = 950, width = 55, collision = true, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15+25*level+0.5*AP end},
          [_R] = { range = 0}
        },
        ["LeeSin"] = {
          [_Q] = { range = 1100, width = 50, delay = 0.25, speed = 1800, collision = true, aoe = false, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 20+30*level+0.9*source.addDamage end},
          [_W] = { range = 600},
          [_E] = { range = 0, width = 450, delay = 0.25, speed = math.huge, collision = false, aoe = false, type = "circular", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 25+35*level+source.addDamage end},
          [_R] = { range = 2000, width = 150, delay = 0.25, speed = 2000, collision = false, aoe = false, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 200*level+2*source.addDamage end}
        },
        ["Lux"] = {
          [_Q] = { speed = 1025, delay = 0.25, range = 1300, width = 130, collision = true, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 10+50*level+0.7*AP end},
          [_W] = { speed = 1630, delay = 0.25, range = 1250, width = 210, collision = false, type = "linear"},
          [_E] = { speed = 1275, delay = 0.25, range = 1100, width = 250, collision = false, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15+45*level+0.6*AP end},
          [_R] = { speed = math.huge, delay = 1, range = 3340, width = 200, collision = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 200+100*level+0.75*AP end}
        },
        ["Malzahar"] = {
          [_Q] = { speed = math.huge, delay = 0.5, range = 900, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 25+55*level+0.8*AP end},
          [_W] = { speed = math.huge, delay = 0.5, range = 800, width = 250, collision = false, aoe = false, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return (0.04+0.01*level)*target.maxHealth+AP/100 end},
          [_E] = { speed = math.huge, delay = 0.5, range = 650, dmgAP = function(AP, level, Level, TotalDmg, source, target) return (20+60*level)/8+0.1*AP end},
          [_R] = { speed = math.huge, delay = 0.5, range = 700, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 20+30*level+0.26*AP end}
        },
        ["Nidalee"] = {
          [_Q] = { speed = 1337, delay = 0.125, range = 1525, width = 25, collision = true, aoe = false, type = "linear"},
          [_W] = { range = 0},
          [_E] = { range = 0},
          [_R] = { range = 0}
        },
        ["Olaf"] = {
          [_Q] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 25+45*level+TotalDmg end},
          [_W] = { },
          [_E] = { range = 0, dmgTRUE = function(AP, level, Level, TotalDmg, source, target) return 25+45*level+0.4*TotalDmg end},
          [_R] = { }
        },
        ["Orianna"] = {
          [_Q] = { speed = 1200, delay = 0.250, range = 825, width = 175, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+30*level+0.5*AP end},
          [_W] = { speed = math.huge, delay = 0.250, range = 0, width = 225, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 25+45*level+0.7*AP end},
          [_E] = { speed = 1800, delay = 0.250, range = 825, width = 80, collision = false, aoe = false, type = "targeted", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+30*level+0.3*AP end},
          [_R] = { speed = math.huge, delay = 0.250, range = 0, width = 410, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 75+75*level+0.7*AP end}
        },
        ["Quinn"] = {
          [_Q] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 30+40*level+0.65*source.addDamage+0.5*AP end},
          [_W] = { },
          [_E] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 10+30*level+0.2*source.addDamage end},
          [_R] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return (70+50*level+0.5*source.addDamage)*(1+((target.maxHealth-target.health)/target.maxHealth)) end}
        },
        ["Rengar"] = {
          [_Q] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 30*level+(0.95+0.05*level)*TotalDmg end},
          [_W] = { speed = math.huge, delay = 0.5, range = 490, width = 490, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 20+30*level+0.8*AP end},
          [_E] = { speed = 1375, delay = 0.25, range = 1000, width = 80, collision = true, aoe = false, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 50*level+0.7*TotalDmg end},
          [_R] = { range = 4000}
        },
        ["Riven"] = {
          [_Q] = { range = 310, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 0-10+20*level+(0.35+0.05*level)*TotalDmg end},
          [_W] = { range = 265, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 20+30*level+TotalDmg end},
          [_E] = { range = 390},
          [_R] = { range = 930, dmgAD = function(AP, level, Level, TotalDmg, source, target) return (40+40*level+0.6*source.addDamage)*(math.min(3,math.max(1,4*(target.maxHealth-target.health)/target.maxHealth))) end},
        },
        ["Rumble"] = {
          [_Q] = { speed = math.huge, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 5+20*level+0.33*AP end},
          [_W] = { range = myHero.boundingRadius},
          [_E] = { speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 20+25*level+0.4*AP end},
          [_R] = { speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 75+55*level+0.3*AP end}
        },
        ["Ryze"] = {
          [_Q] = { speed = 1875, delay = 0.25, range = 900, width = 55, collision = true, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 25+35*level+0.55*AP+(0.015+0.05*level)*source.maxMana end},
          [_W] = { range = 600, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 60+20*level+0.4*AP+0.025*myHero.maxMana end},
          [_E] = { range = 600, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 34+16*level+0.3*AP+0.02*myHero.maxMana end},
          [_R] = { range = 900}
        },
        ["Sejuani"] = {
          [_Q] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 35+45*level+0.4*AP end},
          [_W] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return end},
          [_E] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30+30*level*0.5*AP end},
          [_R] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+100*level*0.8*AP end}
        },
        ["Shyvana"] = {
          [_Q] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return (0.75+0.05*level)*TotalDmg end},
          [_W] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 5+15*level+0.2*TotalDmg end},
          [_E] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 20+40*level+0.6*TotalDmg end},
          [_R] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+125*level+0.7*AP end}
        },
        ["Talon"] = {
          [_Q] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(AP, level, Level, TotalDmg, source, target) return TotalDmg+30*level+0.3*(myHero.addDamage) end},
          [_W] = { speed = 900, delay = 0.5, range = 600, width = 200, collision = false, aoe = false, type = "cone", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 2*(5+25*level+0.6*(myHero.addDamage)) end},
          [_E] = { range = 700},
          [_R] = { speed = math.huge, delay = 0.25, range = 0, width = 650, collision = false, aoe = false, type = "circular", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 2*(70+50*level+0.75*(myHero.addDamage)) end}
        },
        ["Teemo"] = {
          [_Q] = { range = myHero.range+myHero.boundingRadius*3, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 35+45*Level+0.8*AP end},
          [_W] = { range = 25000},
          [_E] = { range = myHero.range+myHero.boundingRadius, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 9*level+0.3*AP end},
          [_R] = { range = myHero.range, width = 250}
        },
        ["Vayne"] = {
          [_Q] = { range = 450, dmgAD = function(AP, level, Level, TotalDmg, source, target) return (0.25+0.05*level)*TotalDmg+TotalDmg end},
          [_W] = { range = myHero.range+myHero.boundingRadius*2, dmgTRUE = function(AP, level, Level, TotalDmg, source, target) return 10+10*level+((0.03+0.01*level)*target.maxHealth) end},
          [_E] = { speed = 2000, delay = 0.25, range = 1000, width = 0, collision = false, aoe = false, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 5+35*level+0.5*TotalDmg end},
          [_R] = { range = 1000}
        },
        ["Viktor"] = {
          [_Q] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 20+20*level+0.2*AP end},
          [_W] = { },
          [_E] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 25+45*level+0.7*AP end},
          [_R] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+100*level+0.55*AP end}
        },
        ["Volibear"] = {
          [_Q] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 30*level+TotalDmg end},
          [_W] = { range = myHero.range*2+myHero.boundingRadius+25, dmgAD = function(AP, level, Level, TotalDmg, source, target) return ((1+(target.maxHealth-target.health)/target.maxHealth))*(45*level+35+0.15*(source.maxHealth-(440+86*Level))) end},
          [_E] = { range = myHero.range*2+myHero.boundingRadius*2+10, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 45*level+15+0.6*AP end},
          [_R] = { range = myHero.range+myHero.boundingRadius, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 40*level+35+0.3*AP end}
        },
        ["Yasuo"] = {
          [_Q] = { range = 500, speed = math.huge, delay = 0.125, width = 55, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 20*level+TotalDmg-10 end},
          [_W] = { range = 350},
          [_E] = { range = 475, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+20*level+AP end},
          [_R] = { range = 1200, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 100+100*level+1.5*TotalDmg end}
        },
        ["Yorick"] = {
          [_Q] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 30*level+1.2*TotalDmg+TotalDmg end},
          [_W] = { range = 0, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+20*level+AP end},
          [_E] = { range = 0, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 100+100*level+source.addDamage*1.5 end},
          [_R] = { }
        }
    }
    lastAttack = 0
    lastWindup = 0
    previousWindUp = 0
    previousAttackCooldown = 0
    ultOn = 0
    ultTarget = nil
    trackList = {
        ["Ahri"] = {
          "AhriSeduce"
        },
        ["Blitzcrank"] = {
          "rocketgrab2"
        },
        ["Brand"] = {
          "brandablaze"
        },
        ["Cassiopeia"] = {
          "blastpoison", "miasmapoison"
        },
        ["Darius"] = {
          "dariushemo"
        },
        ["Kalista"] = {
          "kalistaexpungemarker"
        },
        ["LeeSin"] = {
          "BlindMonkQOne"
        },
        ["Lux"] = {
          "luxilluminati"
        },
        ["Nidalee"] = {
          "nidaleepassivehunted"
        },
        ["Yasuo"] = {
          "YasuoDashWrapper"
        }
    }
    objTrackList = {
        ["Ashe"] = { "Ashe_Base_Q_Ready.troy" },
        ["Azir"] = { "AzirSoldier" },
        ["Ekko"] = { "Ekko", "Ekko_Base_Q_Aoe_Dilation.troy", "Ekko_Base_W_Detonate_Slow.troy", "Ekko_Base_W_Indicator.troy", "Ekko_Base_W_Cas.troy" },
        ["Orianna"] = { "TheDoomBall" }
    }
    objTimeTrackList = {
        ["Ashe"] = { 4 },
        ["Azir"] = { 9 },
        ["Ekko"] = { math.huge, 1.565, 1.70, 3, 1 },
        ["Orianna"] = { math.huge }
    }
    if objTrackList[myHero.charName] then
      objHolder = {}
      objTimeHolder = {}
      table.insert(objHolder, myHero)
      for k=1,objManager.maxObjects,1 do
        local object = objManager:getObject(k)
        for _,name in pairs(objTrackList[myHero.charName]) do
          if object and object.valid and object.name and object.team == myHero.team and object.name == name then
            --table.insert(objTimeHolder, GetInGameTimer() + objTimeTrackList[myHero.charName][_])
            objHolder[name] = object
            --objTimeHolder[name] = GetInGameTimer() + objTimeTrackList[myHero.charName][_]
            if ScriptologyDebug then print("Object "..object.name.." already created. Now tracking!") end
          end
        end
      end
    end
    data = championData[myHero.charName]
    for k,v in pairs(data) do
      if v.type then UPL:AddSpell(k, v) end
    end
    Target = nil
    Mobs = minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC)
    JMobs = minionManager(MINION_JUNGLE, 750, myHero, MINION_SORT_HEALTH_ASC)
    sReady = {[_Q] = false, [_W] = false, [_E] = false, [_R] = false}
  end

  function SetupOrbwalk()
    if myHero.charName == "Azir" or myHero.charName == "Malzahar" or myHero.charName == "Katarina" or myHero.charName == "Rengar" or myHero.charName == "Riven" or myHero.charName == "Talon" or myHero.charName == "Yasuo" then
      if myHero.charName ~= "Katarina" and myHero.charName ~= "Riven" and myHero.charName ~= "Yasuo" then ScriptologyMsg("Inbuilt OrbWalker activated! Do not use any other") end
      aaResetTable = { ["Rengar"] = {_Q}, ["Riven"] = {_W}, ["Talon"] = {_Q} }
      aaResetTable2 = { ["Riven"] = {_Q}, ["Talon"] = {_W}, ["Yasuo"] = {_Q} }
      aaResetTable3 = { ["Teemo"] = {_Q}, ["Yasuo"] = {_R} }
      loadedOrb = SWalk(myHero.charName ~= "Azir" and myHero.charName ~= "Malzahar", aaResetTable[myHero.charName], aaResetTable2[myHero.charName], aaResetTable3[myHero.charName])
      DelayAction(function() ScriptologyMsg("Inbuilt OrbWalker activated! Do not use any other") end, 5)
    else
      if _G.AutoCarry then
        if _G.Reborn_Initialised then
          ScriptologyMsg("Found SAC: Reborn")
        else
          ScriptologyMsg("Found SAC: Revamped")
        end
      elseif _G.Reborn_Loaded then
        DelayAction(function() SetupOrbwalk() end, 1)
      elseif _G.MMA_Loaded then
        ScriptologyMsg("Found MMA")
      elseif FileExist(LIB_PATH .. "Big Fat Orbwalker.lua") then
        require "Big Fat Orbwalker"
      elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
        require 'SxOrbWalk'
        SxOrb:LoadToMenu(scriptConfig("SxOrbWalk", "ScriptologySxOrbWalk"))
        ScriptologyMsg("Found SxOrb.")
      elseif FileExist(LIB_PATH .. "SOW.lua") then
        require 'SOW'
        require 'VPrediction'
        SOWVP = SOW(VP)
        SOWVP:LoadToMenu(scriptConfig("SOW", "ScriptologySOW"))
        ScriptologyMsg("Found SOW")
      else
        aaResetTable = { ["Rengar"] = {_Q}, ["Riven"] = {_W}, ["Talon"] = {_Q} }
        aaResetTable2 = { ["Kalista"] = {_Q}, ["Riven"] = {_Q}, ["Talon"] = {_W}, ["Yasuo"] = {_Q} }
        aaResetTable3 = { ["Teemo"] = {_Q}, ["Yasuo"] = {_R} }
        loadedOrb = SWalk(false, aaResetTable[myHero.charName], aaResetTable2[myHero.charName], aaResetTable3[myHero.charName])
        ScriptologyMsg("No valid Orbwalker found - loading SWalk")
      end
    end
  end

  function DisableOrbwalkerMovement()
    if _G.Reborn_Loaded then
      if _G.Reborn_Initialised then
        _G.AutoCarry.MyHero:MovementEnabled(false)
      end
    elseif _G.MMA_Loaded then
      _G.MMA_AvoidMovement(true)
    elseif FileExist(LIB_PATH .. "Big Fat Orbwalker.lua") then
      _G["BigFatOrb_DisableMove"] = true
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
      SxOrb:DisableMove()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
      SOWVP.Move = false
    end
  end

  function EnableOrbwalkerMovement()
    if _G.Reborn_Loaded then
      if _G.Reborn_Initialised then
        _G.AutoCarry.MyHero:MovementEnabled(true)
      end
    elseif _G.MMA_Loaded then
      _G.MMA_AvoidMovement(false)
    elseif FileExist(LIB_PATH .. "Big Fat Orbwalker.lua") then
      _G["BigFatOrb_DisableMove"] = false
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
      SxOrb:EnableMove()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
      SOWi.Move = true
    end
  end

  function DisableOrbwalkerAttacks()
    if _G.Reborn_Loaded then
      if _G.Reborn_Initialised then
        _G.AutoCarry.MyHero:AttacksEnabled(false)
      end
    elseif _G.MMA_Loaded then
      _G.MMA_StopAttacks(true)
    elseif FileExist(LIB_PATH .. "Big Fat Orbwalker.lua") then
      _G["BigFatOrb_DisableAttacks"] = true
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
      SxOrb:DisableAttacks()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
      SOWi.Attacks = false
    end
  end

  function EnableOrbwalkerAttacks()
    if _G.Reborn_Loaded then
      if _G.Reborn_Initialised then
        _G.AutoCarry.MyHero:AttacksEnabled(true)
      end
    elseif _G.MMA_Loaded then
      _G.MMA_StopAttacks(false)
    elseif FileExist(LIB_PATH .. "Big Fat Orbwalker.lua") then
      _G["BigFatOrb_DisableAttacks"] = false
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
      SxOrb:EnableAttacks()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
      SOWi.Attacks = true
    end
  end

  function Tick()
    if myHero.charName ~= "Blitzcrank" then Target = GetCustomTarget() end
    Mobs:update()
    JMobs:update()

    for _=0,3 do
      sReady[_] = myHero:CanUseSpell(_) == READY
    end

    if myHero.charName ~= "Riven" then loadedClass:Killsteal() end

    if myHero.charName ~= "Rengar" and (Target ~= nil or myHero.charName == "Blitzcrank") then 
      if Config:getParam("Harrass", "Harrass") and not Config:getParam("Combo", "Combo") then
        loadedClass:Harrass()
      end

      if Config:getParam("Combo", "Combo") then
        loadedClass:Combo()
      end
    end

    if myHero.charName ~= "Riven" then
      if Config:getParam("LastHit", "LastHit") or Config:getParam("LaneClear", "LaneClear") then
        loadedClass:LastHit()
      end
    end

    if Config:getParam("LaneClear", "LaneClear") then
      loadedClass:LaneClear()
    end

    if myHero.charName ~= "Nidalee" and myHero.charName ~= "Riven" then DmgCalc() end
  end

  function Draw()
    if myHero.charName == "Nidalee" or myHero.charName == "Riven" then return end
    if Config:getParam("Draws", "Q") and myHero:CanUseSpell(_Q) == READY then
      DrawLFC(myHero.x, myHero.y, myHero.z, myHero.charName == "Rengar" and myHero.range+myHero.boundingRadius*2 or data[0].range > 0 and data[0].range or data[0].width, ARGB(255*Config:getParam("Draws", "Opacity", "Q")/100, (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "Q")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "Q")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "Q")/100)))
    end
    if myHero.charName ~= "Orianna" then
      if Config:getParam("Draws", "W") and myHero:CanUseSpell(_W) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, type(data[1].range) == "function" and data[1].range() or data[1].range > 0 and data[1].range or data[1].width, ARGB(255*Config:getParam("Draws", "Opacity", "W")/100, (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "W")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "W")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "W")/100)))
      end
      if Config:getParam("Draws", "E") and myHero:CanUseSpell(_E) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, data[2].range > 0 and data[2].range or data[2].width, ARGB(255*Config:getParam("Draws", "Opacity", "E")/100, (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "E")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "E")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "E")/100)))
      end
      if Config:getParam("Draws", "R") and (myHero:CanUseSpell(_R) == READY or myHero.charName == "Katarina") then
        DrawLFC(myHero.x, myHero.y, myHero.z, type(data[3].range) == "function" and data[3].range() or data[3].range > 0 and data[3].range or data[3].width, ARGB(255*Config:getParam("Draws", "Opacity", "R")/100, (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "R")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "R")/100), (Config:getParam("Draws", "LFC") and 255 or 255*Config:getParam("Draws", "Opacity", "R")/100)))
      end
    end
    --print(#objHolder)
    if objTrackList[myHero.charName] then
      if #objHolder > 0 then
        for _,obj in pairs(objHolder) do
          if obj ~= myHero then
            if objTimeHolder[obj.networkID] and objTimeHolder[obj.networkID] < math.huge then
              if objTimeHolder[obj.networkID]>GetInGameTimer() then 
                local barPos = WorldToScreen(D3DXVECTOR3(obj.x, obj.y, obj.z))
                local posX = barPos.x - 35
                local posY = barPos.y - 50
                if myHero.charName ~= "Azir" or Config:getParam("Draws", "W") then DrawText((math.floor((objTimeHolder[obj.networkID]-GetInGameTimer())*100)/100).."s", 25, posX, posY, ARGB(255, 255, 0, 0)) end
              else
                objHolder[obj.networkID] = nil
                objTimeHolder[obj.networkID] = nil
              end
            end
            width = myHero.charName == "Ekko" and obj.name == "Ekko" and data[3].width or (((myHero.charName == "Ekko" and obj.name:find("Ekko_Base_W")) or myHero.charName == "Azir") and data[1].width or data[0].width)
            if myHero.charName == "Ekko" then
              if obj.name == "Ekko" and Config:getParam("Draws", "R") then 
                DrawLFT(obj.x, obj.y, obj.z, width, ARGB(155, 155, 150, 250)) 
                DrawLFC(obj.x, obj.y, obj.z, width, ARGB(255, 155, 150, 250))
              elseif obj.name:find("Ekko_Base_Q") and Config:getParam("Draws", "Q") then 
                DrawLine3D(myHero.x, myHero.y, myHero.z, obj.x, obj.y, obj.z, 1, ARGB(255, 155, 150, 250)) 
                DrawLFC(obj.x, obj.y, obj.z, width, ARGB(255, 155, 150, 250))
              elseif Config:getParam("Draws", "W") then
                DrawLFC(obj.x, obj.y, obj.z, width, ARGB(255, 155, 150, 250))
              end
            elseif myHero.charName == "Orianna" then
              DrawCircle(obj.x-8, obj.y, obj.z+87, data[0].width-50, 0x111111)
              for i=0,2 do
                LagFree(obj.x-8, obj.y, obj.z+87, data[0].width-50, 3, ARGB(255, 75, 0, 230), 3, (math.pi/4.5)*(i))
              end 
              LagFree(obj.x-8, obj.y, obj.z+87, data[0].width-50, 3, ARGB(255, 75, 0, 230), 9, 0)
            elseif myHero.charName ~= "Azir" or Config:getParam("Draws", "W") then
              DrawLFC(obj.x, obj.y, obj.z, width, ARGB(255, 155, 150, 250))
            end
          end
        end
      end
    end
    if Config:getParam("Draws", "DMG") then
      for i,k in pairs(GetEnemyHeroes()) do
        local enemy = k
        if ValidTarget(enemy) then
          local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
          local posX = barPos.x - 35
          local posY = barPos.y - 50
          -- Doing damage
          if myHero.charName == "Kalista" then
            DrawText(killTextTable[enemy.networkID].indicatorText, 20, posX, posY-5, ARGB(255,250,250,250))
          else
            DrawText(killTextTable[enemy.networkID].indicatorText, 18, posX, posY, ARGB(255, 50, 255, 50))
          end
         
          -- Taking damage
          DrawText(killTextTable[enemy.networkID].damageGettingText, 15, posX, posY + 15, ARGB(255, 255, 50, 50))
        end
      end
      if myHero.charName == "Kalista" and myHero:CanUseSpell(_E) then
        for minion,winion in pairs(Mobs.objects) do
          damageE = GetDmg(_E, myHero, winion)
          if winion ~= nil and GetStacks(winion) > 0 and GetDistance(winion) <= 1000 and not winion.dead and winion.team ~= myHero.team then
            if damageE > winion.health then
              DrawText3D("E Kill", winion.x-45, winion.y-45, winion.z+45, 20, TARGB({255,250,250,250}), 0)
            else
              DrawText3D(math.floor(damageE/winion.health*100).."%", winion.x-45, winion.y-45, winion.z+45, 20, TARGB({255,250,250,250}), 0)
            end
          end
        end
        if Config:getParam("Misc", "Ej") then
          for minion,winion in pairs(JMobs.objects) do
            damageE = GetDmg(_E, myHero, winion)
            if winion ~= nil and GetStacks(winion) > 0 and GetDistance(winion) <= 1000 and not winion.dead and winion.team ~= myHero.team then
              if damageE > winion.health then
                DrawText3D("E Kill", winion.x-45, winion.y-45, winion.z+45, 20, TARGB({255,250,250,250}), 0)
              else
                DrawText3D(math.floor(damageE/winion.health*100).."%", winion.x-45, winion.y-45, winion.z+45, 20, TARGB({255,250,250,250}), 0)
              end
            end
          end
        end
      end
    end 
  end

  function CreateObj(object)
    if object and object.valid and object.name then
      for _,name in pairs(objTrackList[myHero.charName]) do
        if object.name == name then
          if myHero.charName == "Ahri" and GetDistance(obj) < 500 then
            objHolder[object.networkID] = object
            objTimeHolder[object.networkID] = GetInGameTimer() + objTimeTrackList[myHero.charName][_]
          elseif myHero.charName ~= "Ahri" then
            objHolder[object.networkID] = object
            objTimeHolder[object.networkID] = GetInGameTimer() + objTimeTrackList[myHero.charName][_]
          end
          --table.insert(objHolder, object)
          --table.insert(objTimeHolder, GetInGameTimer() + objTimeTrackList[myHero.charName][_])
          if ScriptologyDebug then print("Object "..object.name.." created. Now tracking!") end
        end
      end
    end
  end
   
  function DeleteObj(object)
    if object and object.name then 
      for _,name in pairs(objTrackList[myHero.charName]) do
        if object.name == name and name ~= "TheDoomBall" then
          objHolder[object.networkID] = nil
          if ScriptologyDebug then print("Object "..object.name.." destroyed. No longer tracking! "..#objHolder) end
        end
      end
    end
  end

  function ApplyBuff(source, unit, buff)
    if source and source.isMe and buff and unit then
      for _,name in pairs(trackList[myHero.charName]) do
        if buff.name:find(name) then
          stackTable[unit.networkID] = 1
          if ScriptologyDebug then print(source.charName.." applied "..name.." on "..unit.charName) end
        end
      end
    end
  end

  function UpdateBuff(unit, buff, stacks)
    if buff and unit then
      for _,name in pairs(trackList[myHero.charName]) do
        if buff.name:find(name) and stackTable[unit.networkID] then
          stackTable[unit.networkID] = stacks
          if ScriptologyDebug then print("Updated "..name.." on "..unit.charName.." with "..stacks.." stacks") end
        end
      end
    end
  end

  function RemoveBuff(unit, buff)
    if buff and unit then
      for _,name in pairs(trackList[myHero.charName]) do
        if buff.name:find(name) then
          stackTable[unit.networkID] = nil
          if ScriptologyDebug then print("Removed "..name.." from "..unit.charName) end
        end
      end
    end
  end

  function GetStacks(unit)
    if not unit then return 0 end
    return stackTable[unit.networkID] or 0
  end

  function ProcessSpell(unit, spell)
    if unit and unit.isMe and spell then
      lastAttack = GetTickCount() - GetLatency()/2
      previousWindUp = spell.windUpTime*1000
      previousAttackCooldown = spell.animationTime*1000
      if string.find(string.lower(spell.name), "attack") then
        lastWindup = GetInGameTimer()+spell.windUpTime
      elseif spell.name == "EkkoR" then
        objHolder["Ekko"] = nil
      elseif spell.name == "OrianaIzunaCommand" then
        objHolder["TheDoomBall"] = nil
      elseif spell.name == "OrianaRedactCommand" then
        objHolder["TheDoomBall"] = spell.target
      elseif string.find(spell.name, "NetherGrasp") or spell.name:lower():find("katarinar") then
        ultOn = GetInGameTimer()+2.5
        ultTarget = Target
      end
    end
  end
   
  function timeToShoot()
    return (GetTickCount() + GetLatency()/2 > lastAttack + previousAttackCooldown) and ultOn < GetInGameTimer()
  end
   
  function heroCanMove()
    return (GetTickCount() + GetLatency()/2 > lastAttack + previousWindUp + 75) and ultOn < GetInGameTimer()
  end

  function GetCustomTarget()
    loadedClass.ts:update()
    if _G.MMA_Loaded and _G.MMA_Target() and _G.MMA_Target().type == myHero.type then return _G.MMA_Target() end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return loadedClass.ts.target
  end

  function GetFarmPosition(range, width)
    local BestPos 
    local BestHit = 0
    local objects = minionManager(MINION_ENEMY, range, myHero, MINION_SORT_HEALTH_ASC).objects
    for i, object in ipairs(objects) do
      local hit = CountObjectsNearPos(object.pos or object, range, width, objects)
      if hit > BestHit then
        BestHit = hit
        BestPos = Vector(object)
        if BestHit == #objects then
          break
        end
      end
    end
    return BestPos, BestHit
  end

  function GetJFarmPosition(range, width)
    local BestPos 
    local BestHit = 0
    local objects = minionManager(MINION_JUNGLE, range, myHero, MINION_SORT_HEALTH_ASC).objects
    for i, object in ipairs(objects) do
      local hit = CountObjectsNearPos(object.pos or object, range, width, objects)
      if hit > BestHit then
        BestHit = hit
        BestPos = Vector(object)
        if BestHit == #objects then
          break
        end
      end
    end
    return BestPos, BestHit
  end

  function GetLineFarmPosition(range, width, source)
    local BestPos 
    local BestHit = 0
    source = source or myHero
    local objects = minionManager(MINION_JUNGLE, range, source, MINION_SORT_HEALTH_ASC).objects
    for i, object in ipairs(objects) do
      local EndPos = Vector(source) + range * (Vector(object) - Vector(source)):normalized()
      local hit = CountObjectsOnLineSegment(source, EndPos, width, objects)
      if hit > BestHit then
        BestHit = hit
        BestPos = object
        if BestHit == #objects then
          break
        end
      end
    end
    return BestPos, BestHit
  end

  function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
      local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
      local w = width
      if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
        n = n + 1
      end
    end
    return n
  end

  function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in ipairs(objects) do
      if GetDistance(pos, object) <= radius then
        n = n + 1
      end
    end
    return n
  end

  function GetLichSlot()
    for slot = ITEM_1, ITEM_7, 1 do
      if myHero:GetSpellData(slot).name and (string.find(string.lower(myHero:GetSpellData(slot).name), "atmasimpalerdummyspell")) then
        return slot
      end
    end
    return nil
  end

  function IsInvinc(unit)
    if unit == nil then if self == nil then return else unit = self end end
    for i=1, unit.buffCount do
     local buff = unit:getBuff(i)
     if buff and buff.valid and buff.name then 
      if buff.name == "JudicatorIntervention" or buff.name == "UndyingRage" then return true end
     end
    end
    return false
  end

  function IsRecalling(unit)
    if unit == nil then if self == nil then return else unit = self end end
    for i=1, unit.buffCount do
     local buff = unit:getBuff(i)
     if buff and buff.valid and buff.name then 
      if string.find(buff.name, "recall") or string.find(buff.name, "Recall") or string.find(buff.name, "teleport") or string.find(buff.name, "Teleport") then return true end
     end
    end
    return false
  end

  function DrawLFC(x, y, z, radius, color)
      if Config:getParam("Draws", "LFC") then
          LagFree(x, y, z, radius, 1, color, 32, 0)
      else
          local radius = radius or 300
          DrawCircle(x, y, z, radius, color)
      end
  end

  function DrawLFT(x, y, z, radius, color)
    LagFree(x, y, z, radius, 1, color, 3, 0)
  end

  function LagFree(x, y, z, radius, width, color, quality, degree)
      local radius = radius or 300
      local screenMin = WorldToScreen(D3DXVECTOR3(x - radius, y, z + radius))
      if OnScreen({x = screenMin.x + 200, y = screenMin.y + 200}, {x = screenMin.x + 200, y = screenMin.y + 200}) then
          radius = radius*.92
          local quality = quality and 2 * math.pi / quality or 2 * math.pi / math.floor(radius / 10)
          local width = width and width or 1
          local a = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(degree), y, z - radius * math.sin(degree)))
          for theta = quality, 2 * math.pi + quality, quality do
              local b = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta+degree), y, z - radius * math.sin(theta+degree)))
              DrawLine(a.x, a.y, b.x, b.y, width, color)
              a = b
          end
      end
  end

  function ScriptologyMsg(msg) 
    print("<font color=\"#6699ff\"><b>[Scriptology Loader]: "..myHero.charName.." - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>") 
  end

  function TARGB(colorTable)
    return ARGB(colorTable[1], colorTable[2], colorTable[3], colorTable[4])
  end

  function DmgCalc()
    if not Config:getParam("Draws", "DMG") or myHero.charName == "Rengar" then return end
    if myHero.charName == "Ryze" then loadedClass:DmgCalc() return end
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy.visible then
        killTextTable[enemy.networkID].indicatorText = ""
        if myHero.charName == "Kalista" then
          local damageAA = GetDmg("AD", myHero, enemy)
          local damageE  = GetDmg(_E, myHero, enemy)
          if enemy.health < damageE then
              killTextTable[enemy.networkID].indicatorText = "E Kill"
              killTextTable[enemy.networkID].ready = myHero:CanUseSpell(_E)
          end
          if myHero:CanUseSpell(_E) == READY and enemy.health > damageE and damageE > 0 then
            killTextTable[enemy.networkID].indicatorText = math.floor(damageE/enemy.health*100).."% E"
          else
            killTextTable[enemy.networkID].indicatorText = ""
          end
        else
          local damageAA = GetDmg("AD", myHero, enemy)
          local damageQ  = GetDmg(_Q, myHero, enemy)
          local damageW  = myHero.charName == "KogMaw" and 0 or (myHero.charName == "Azir" and loadedClass:CountSoldiers(enemy) or 1) * GetDmg(_W, myHero, enemy)
          local damageE  = GetDmg(_E, myHero, enemy)
          local damageR  = GetDmg(_R, myHero, enemy)*(myHero.charName == "Katarina" and 10 or 1)
          local damageRC  = (myHero.charName == "Orianna" and loadedClass:CalcRComboDmg(enemy) or 0)
          local damageI  = Ignite and (GetDmg("IGNITE", myHero, enemy)) or 0
          local damageS  = Smite and (20 + 8 * myHero.level) or 0
          local c = 0
          damageQ = myHero:CanUseSpell(_Q) == READY and damageQ or 0
          damageW = (myHero:CanUseSpell(_W) == READY or myHero.charName == "Azir") and damageW or 0
          damageE = myHero:CanUseSpell(_E) == READY and damageE or 0
          damageR = (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) and damageR or 0
          if myHero:CanUseSpell(_Q) == READY and damageQ > 0 then
            c = c + 1
            killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."Q"
          end
          if myHero:CanUseSpell(_W) == READY and damageW > 0 then
            c = c + 1
            killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."W"
          end
          if myHero:CanUseSpell(_E) == READY and damageE > 0 then
            c = c + 1
            killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."E"
          end
          if myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0 and damageR > 0 and myHero.charName ~= "Orianna" then
            killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."R"
          end
          if myHero:CanUseSpell(_R) == READY and damageRC > 0 then
            killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."RQ"
          end
          if enemy.health < (GetDmg(_Q, myHero, enemy)+GetDmg(_W, myHero, enemy)+GetDmg(_E, myHero, enemy)+GetDmg(_R, myHero, enemy)+damageRC+((myHero.charName == "Talon" and c > 0) and damageAA or 0))*(myHero.charName == "Talon" and 1+0.03*myHero:GetSpellData(_E).level or 1) then
            killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.." Killable"
          end
          if myHero.charName == "Teemo" and enemy.health > damageQ+damageE+damageAA then
            local neededAA = math.ceil((enemy.health) / (damageAA+damageE))
            neededAA = neededAA < 1 and 1 or neededAA
            killTextTable[enemy.networkID].indicatorText = neededAA.." AA to Kill"
          elseif myHero.charName == "Ashe" or myHero.charName == "Vayne" then
            local neededAA = math.ceil((enemy.health-damageQ-damageW-damageE) / (damageAA))
            neededAA = neededAA < 1 and 1 or neededAA
            killTextTable[enemy.networkID].indicatorText = neededAA.." AA to Kill"
          elseif enemy.health > (damageQ+damageW+damageE+damageR+(myHero.charName == "Talon" and damageAA*c/2 or 0))*(myHero.charName == "Talon" and 1+0.03*myHero:GetSpellData(_E).level or 1) then
            local neededAA = math.ceil(100*((damageQ+damageW+damageE+damageR+(myHero.charName == "Talon" and damageAA*c/2 or 0))*(myHero.charName == "Talon" and 1+0.03*myHero:GetSpellData(_E).level or 1))/(enemy.health))
            killTextTable[enemy.networkID].indicatorText = neededAA.." % Combodmg"
          end
        end
        local enemyDamageAA = GetDmg("AD", enemy, myHero)
        local enemyNeededAA = not enemyDamageAA and 0 or math.ceil(myHero.health / enemyDamageAA)   
        if enemyNeededAA ~= 0 then         
          killTextTable[enemy.networkID].damageGettingText = enemy.charName .. " kills me with " .. enemyNeededAA .. " hits"
        end
      end
    end
  end

  function GetDmg(spell, source, target)
    if target == nil or source == nil then
      return
    end
    local ADDmg            = 0
    local APDmg            = 0
    local AP               = source.ap
    local Level            = source.level
    local TotalDmg         = source.totalDamage
    local crit = myHero.critChance
    local crdm = myHero.critDmg
    local ArmorPen         = math.floor(source.armorPen)
    local ArmorPenPercent  = math.floor(source.armorPenPercent*100)/100
    local MagicPen         = math.floor(source.magicPen)
    local MagicPenPercent  = math.floor(source.magicPenPercent*100)/100

    local Armor        = target.armor*ArmorPenPercent-ArmorPen
    local ArmorPercent = Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    local MagicArmor   = target.magicArmor*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and math.floor(MagicArmor*100/(100+MagicArmor))/100 or math.ceil(MagicArmor*100/(100-MagicArmor))/100

    if source ~= myHero then
      return TotalDmg*(1-ArmorPercent)
    end
    if spell == "IGNITE" then
      return 50+20*Level/2
    elseif spell == "Tiamat" then
      ADDmg = (GetHydraSlot() and myHero:CanUseSpell(GetHydraSlot()) == READY) and TotalDmg*0.8 or 0 
    elseif spell == "AD" then
      if myHero.charName == "Ashe" then
        ADDmg = TotalDmg*1.1+(1+crit)*(1+crdm)
      else 
        ADDmg = TotalDmg
      end
      if GetMaladySlot() then
        APDmg = 15 + 0.15*AP
      end
    elseif type(spell) == "number" then
      if data[spell].dmgAD then ADDmg = data[spell].dmgAD(AP, myHero:GetSpellData(spell).level, Level, TotalDmg, source, target) end
      if data[spell].dmgAP then APDmg = data[spell].dmgAP(AP, myHero:GetSpellData(spell).level, Level, TotalDmg, source, target) end
      if data[spell].dmgTRUE then return data[spell].dmgTRUE(AP, myHero:GetSpellData(spell).level, Level, TotalDmg, source, target) end
    end
    dmg = math.floor(ADDmg*(1-ArmorPercent))+math.floor(APDmg*(1-MagicArmorPercent))
    return math.floor(dmg)
  end

  function GetHydraSlot()
    for slot = ITEM_1, ITEM_7, 1 do
      if myHero:GetSpellData(slot).name and (string.find(string.lower(myHero:GetSpellData(slot).name), "tiamat")) then
        return slot
      end
    end
    return nil
  end

  function GetMaladySlot()
    for slot = ITEM_1, ITEM_7, 1 do
      if myHero:GetSpellData(slot).name and (string.find(string.lower(myHero:GetSpellData(slot).name), "malady")) then
        return slot
      end
    end
    return nil
  end

  function Cast(Spell, target, targeted, predict, hitchance, source) -- maybe the packetcast gets some functionality somewhen?
    if not target and not targeted then
      if VIP_USER then
          Packet("S_CAST", {spellId = Spell}):send()
      else
          CastSpell(Spell)
      end
    elseif target and targeted then
      if VIP_USER then
          Packet("S_CAST", {spellId = Spell, targetNetworkId = target.networkID}):send()
      else
          CastSpell(Spell, target)
      end
    elseif target and not targeted and not predict then
      xPos = target.x
      zPos = target.z
      if VIP_USER then
        Packet("S_CAST", {spellId = Spell, fromX = xPos, fromY = zPos, toX = xPos, toY = zPos}):send()
      else
        CastSpell(Spell, xPos, zPos)
      end
    elseif target and not targeted and predict then
      if not source then source = myHero end
      if not hitchance then hitchance = 2 end
      local CastPosition, HitChance, Position = UPL:Predict(Spell, source, target)
      if HitChance >= hitchance then
        xPos = CastPosition.x
        zPos = CastPosition.z
        if VIP_USER then
          Packet("S_CAST", {spellId = Spell, fromX = xPos, fromY = zPos, toX = xPos, toY = zPos}):send()
        else
          CastSpell(Spell, xPos, zPos)
        end
        CastSpell(Spell)
      end
    end
  end

  function EnemiesAround(Unit, range)
    local c=0
    if Unit == nil then return 0 end
    for i=1,heroManager.iCount do hero = heroManager:GetHero(i) if hero ~= nil and hero.team ~= myHero.team and hero.x and hero.y and hero.z and GetDistance(hero, Unit) < range then c=c+1 end end return c
  end

  function GetClosestAlly()
    local ally = nil
    for v,k in pairs(GetAllyHeroes()) do
      if not ally then ally = k end
      if GetDistanceSqr(k) < GetDistanceSqr(ally) then
        ally = k
      end
    end
    return ally
  end

  function GetClosestEnemy(pos)
    local enemy = nil
    pos = pos or myHero
    for v,k in pairs(GetEnemyHeroes()) do
      if not enemy then enemy = k end
      if GetDistanceSqr(k, pos) < GetDistanceSqr(enemy, pos) then
        enemy = k
      end
    end
    return enemy
  end

  function EnemiesAroundAndFacingMe(Unit, range)
    local c=0
    if Unit == nil then return 0 end
    for i=1,heroManager.iCount do hero = heroManager:GetHero(i) 
      if hero ~= nil and hero.team ~= myHero.team and hero.x and hero.y and hero.z and GetDistance(hero, Unit) < range then pos, b = PredictPos(hero) if pos and GetDistance(pos, myHero) < GetDistance(hero, myHero) then c=c+1 end end end return c
  end

  function PredictPos(target,delay)
    speed = target.ms
    dir = GetTargetDirection(target)
    if dir and target.isMoving then
      return Vector(target)+Vector(dir.x, dir.y, dir.z):normalized()*speed/8+Vector(dir.x, dir.y, dir.z):normalized()*target.ms*delay, GetDistance(target.minBBox, target.pos)
    elseif not target.isMoving then
      return Vector(target), GetDistance(target.minBBox, target.pos)
    end
  end

  function GetTargetDirection(target)
    local wp = GetWayPoints(target)
    if #wp == 1 then
      return Vector(target.x, target.y, target.z)
    elseif #wp >= 2 then
      return Vector(wp[2].x-target.x, wp[2].y-target.y, wp[2].z-target.z)
    end
  end

  function GetWayPoints(target)
    local result = {}
    if target.hasMovePath then
      table.insert(result, Vector(target))
      for i = target.pathIndex, target.pathCount do
        path = target:GetPath(i)
        table.insert(result, Vector(path))
      end
    else
      table.insert(result, Vector(target))
    end
    return result
  end

  function AlliesAround(Unit, range)
    local c=0
    for i=1,heroManager.iCount do hero = heroManager:GetHero(i) if hero.team == myHero.team and hero.x and hero.y and hero.z and GetDistance(hero, Unit) < range then c=c+1 end end return c
  end

  function GetLowestMinion(range)
    local minionTarget = nil
    for i, minion in pairs(minionManager(MINION_ENEMY, range, myHero, MINION_SORT_HEALTH_ASC).objects) do
      if minionTarget == nil then 
        minionTarget = minion
      elseif minionTarget.health >= minion.health and ValidTarget(minion, range) then
        minionTarget = minion
      end
    end
    return minionTarget
  end

  function GetClosestMinion(range)
    local minionTarget = nil
    for i, minion in pairs(minionManager(MINION_ENEMY, range, myHero, MINION_SORT_HEALTH_ASC).objects) do
      if minionTarget == nil then 
        minionTarget = minion
      elseif GetDistance(minionTarget) > GetDistance(minion) and ValidTarget(minion, range) then
        minionTarget = minion
      end
    end
    return minionTarget
  end


  function GetJMinion(range)
    local minionTarget = nil
    for i, minion in pairs(minionManager(MINION_JUNGLE, range, myHero, MINION_SORT_HEALTH_ASC).objects) do
      if minionTarget == nil then 
        minionTarget = minion
      elseif minionTarget.maxHealth < minion.maxHealth and ValidTarget(minion, range) then
        minionTarget = minion
      end
    end
    return minionTarget
  end
-- }

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--[[ SWalk - Inbuilt OrbWalker from here ]]--
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "SWalk"

  function SWalk:__init(m, a1, a2, a3)
    self.melee = m
    -- CastSpell(s, myHero:Attack(t)) and CastSpell(s)
      self.aaResetTable = a1
    -- CastSpell(s, x, z)
      self.aaResetTable2 = a2
    -- CastSpell(s, t)
      self.aaResetTable3 = a3
    self.State = {}
    self.orbTable = { lastAA = 0, windUp = 4, animation = 0.5 }
    self.myRange = myHero.range+myHero.boundingRadius*2
    self.Config = scriptConfig("SWalk", "SW"..myHero.charName)
    self.Config:addParam("cadj", "Cancel AA adjustment", SCRIPT_PARAM_SLICE, 0, -20, 20, 0)
    local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
    if self.aaResetTable then
      for _,k in pairs(self.aaResetTable) do
        self.Config:addParam(str[k], "AA Reset with "..str[k], SCRIPT_PARAM_ONOFF, true)
      end
    end
    if self.aaResetTable2 then
      for _,k in pairs(self.aaResetTable2) do
        self.Config:addParam(str[k], "AA Reset with "..str[k], SCRIPT_PARAM_ONOFF, true)
      end
    end
    if self.aaResetTable3 then
      for _,k in pairs(self.aaResetTable3) do
        self.Config:addParam(str[k], "AA Reset with "..str[k], SCRIPT_PARAM_ONOFF, true)
      end
    end
    self.Config:addParam("i", "Use items", SCRIPT_PARAM_ONOFF, true)
    if self.melee then 
      self.Config:addParam("wtt", "Walk to Target", SCRIPT_PARAM_ONOFF, true) 
    end
    AddTickCallback(function() self:OrbWalk() end)
    AddDrawCallback(function() self:Draw() end)
    AddProcessSpellCallback(function(x,y) self:ProcessSpell(x,y) end)
    if VIP_USER and self.melee then 
      self.Config:addParam("pc", "Use packet for animation cancel", SCRIPT_PARAM_ONOFF, true)
      AddRecvPacketCallback2(function(x) self:RecvPacket(x) end) 
    end
    return self
  end

  function SWalk:Draw()
    DrawCircle3D(myHero.x, myHero.y, myHero.z, myHero.range+myHero.boundingRadius, 1, ARGB(105,0,255,0), 32)
  end

  function SWalk:OrbWalk()
    myRange = myHero.range+myHero.boundingRadius*2
    if Config:getParam("LastHit", "LastHit") then
      self.Target = GetLowestMinion(data[0].range)
      if self.Target and self.Target.health > GetDmg("AD",myHero,self.Target) then
        self.Target = nil
      end
    end
    if Config:getParam("LaneClear", "LaneClear") then
      self.Target = GetLowestMinion(data[0].range)
      if not self.Target then
        self.Target = GetJMinion(data[0].range)
      end
    end
    if Config:getParam("Harrass", "Harrass") then
      self.Target = Target
    end
    if Config:getParam("Combo", "Combo") then
      self.Target = Target
    end
    if self.Forcetarget and ValidTarget(self.Forcetarget, 700) then
      self.Target = self.Forcetarget
    end
    if self:DoOrb() then
      loadedClass.Target = self.Target
      self:Orb(self.Target) 
    end
  end

  function SWalk:Orb(unit)
    if not ValidTarget(unit, myRange) then unit = Target end
    if os.clock() > self.orbTable.lastAA + self.orbTable.animation and ValidTarget(unit, myRange) then
      myHero:Attack(unit)
      if myHero.charName == "Kalista" then
        local movePos = myHero + (Vector(mousePos) - myHero):normalized() * 250 
        if self:DoOrb() and GetDistance(mousePos) > myHero.boundingRadius then
          myHero:MoveTo(movePos.x, movePos.z)
        end
      end
    elseif GetDistance(mousePos) > myHero.boundingRadius and (self.Config.pc and os.clock() > self.orbTable.lastAA or os.clock() > self.orbTable.lastAA + self.orbTable.windUp + self.Config.cadj/1000) then
      local movePos = myHero + (Vector(mousePos) - myHero):normalized() * 250
      if self:DoOrb() and unit and ValidTarget(unit, myRange) and unit.type == myHero.type and self.melee and self.Config.wtt then
        if GetDistance(unit) > myHero.boundingRadius+unit.boundingRadius then
          myHero:MoveTo(unit.x, unit.z)
        end
      elseif self:DoOrb() and GetDistance(mousePos) > myHero.boundingRadius then
        myHero:MoveTo(movePos.x, movePos.z)
      end
    end
  end

  function SWalk:DoOrb()
    if (myHero.charName == "Katarina" or myHero.charName == "Malzahar") and ultOn >= GetInGameTimer() and ultTarget and not ultTarget.dead then return false end
    for _,k in pairs({"Combo", "Harrass", "LastHit", "LaneClear"}) do
      if Config:getParam(k, k) then
        return self:SetStates(k)
      end
    end
    return false
  end

  function SWalk:SetStates(mode)
    self.State[_Q] = Config:getParam(mode, "Q")
    self.State[_W] = Config:getParam(mode, "W")
    self.State[_E] = Config:getParam(mode, "E")
    if myHero.charName == "Rengar" and myHero.mana == 5 then
      self.State[_Q] = false
      self.State[_W] = false
      self.State[_E] = false
      if Config:getParam("Misc", "Empower2") == 1 then
        self.State[_Q] = true
      elseif Config:getParam("Misc", "Empower2") == 2 then
        self.State[_W] = true
      elseif Config:getParam("Misc", "Empower2") == 3 then
        self.State[_E] = true
      end
    end
    self.IState = mode == "Combo" or mode == "Harrass"
    return true
  end

  function SWalk:ProcessSpell(unit, spell)
    if unit and unit.isMe and spell and not self.Config.pc then
      if spell.name:lower():find("attack") then
        self.orbTable.windUp = spell.windUpTime
        self.orbTable.animation = spell.animationTime
        self.orbTable.lastAA = os.clock()
        DelayAction(function() self:WindUp(self.Target) end, 1 / (myHero.attackSpeed * 1 / (spell.windUpTime * myHero.attackSpeed)) - GetLatency() / 2000)
      end
    end
  end

  function SWalk:RecvPacket(p)
    if self.Config.pc and p.header == 0xD1 then
      self.orbTable.lastAA = 0
      self:WindUp(self.Target)
    end
  end

  function SWalk:WindUp(unit)
    if ValidTarget(unit) then
      local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
      if self.aaResetTable then
        for _,k in pairs(self.aaResetTable) do
          if self.Config[str[k]] and sReady[k] and self.State[k] and (data[k].range > 0 and GetDistance(unit) < data[k].range or GetDistance(unit) < data[k].width) then
            self.orbTable.lastAA = 0
            CastSpell(k)
            return
          end
        end
      end
      if self.aaResetTable2 then
        for _,k in pairs(self.aaResetTable2) do
          if self.Config[str[k]] and sReady[k] and self.State[k] and (data[k].range > 0 and GetDistance(unit) < data[k].range or GetDistance(unit) < data[k].width) then
            self.orbTable.lastAA = 0
            CastSpell(k, unit.x, unit.z)
            return
          end
        end
      end
      if self.aaResetTable3 then
        for _,k in pairs(self.aaResetTable3) do
          if self.Config[str[k]] and sReady[k] and self.State[k] and (data[k].range > 0 and GetDistance(unit) < data[k].range or GetDistance(unit) < data[k].width) then
            self.orbTable.lastAA = 0
            CastSpell(k, unit)
            return
          end
        end
      end
      if self.IState and self.Config.i and self:CastItems(unit) then return end
    end
  end

  function SWalk:CastItems(unit)
    local i = {["ItemTiamatCleave"] = self.myRange, ["YoumusBlade"] = self.myRange}
    local u = {["ItemSwordOfFeastAndFamine"] = 600}
    for slot = ITEM_1, ITEM_6 do
      if i[myHero:GetSpellData(slot).name] and myHero:CanUseSpell(slot) == READY and GetDistance(unit) <= i[myHero:GetSpellData(slot).name] then
        CastSpell(slot) 
        return true
      end
      if u[myHero:GetSpellData(slot).name] and myHero:CanUseSpell(slot) == READY and GetDistance(unit) <= u[myHero:GetSpellData(slot).name] then
        CastSpell(slot, unit) 
        return true
      end
    end
    return false
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--[[ SWalk - Inbuilt OrbWalker till here ]]--
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--[[ Champion specific parts from here ]]--
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Ahri"

  function Ahri:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.Orb = nil
    self.ultOn = 0
    AddProcessSpellCallback(function(x,y) self:ProcessSpell(x,y) end)
    AddTickCallback(function() self:Tick() end)
    AddDrawCallback(function() self:Draw() end)
  end

  function Ahri:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Ahri:ProcessSpell(unit, spell)
    if unit and unit.isMe and not self.Orb then
      if spell.name == "AhriOrbofDeception" then
        self.Orb = {time = GetInGameTimer(), dir = Vector(spell.endPos)}
      end
      if spell.name == "AhriTumble" then
        if self.ultOn < GetInGameTimer()-10 then self.ultOn = GetInGameTimer() end
      end
    end
  end

  function Ahri:Tick()
    if Config:getParam("Misc", "Qc") then self:CatchQ() end
  end

  function Ahri:Draw()
    if self.Orb and self.Orb.time > GetInGameTimer()-2 then
      local draw = Vector(self.Orb.dir)+(Vector(self.Orb.dir)-myHero):normalized()*(data[0].range-GetDistance(self.Orb.dir))
      DrawLine3D(myHero.x, myHero.y, myHero.z, draw.x, draw.y, draw.z, data[0].width, ARGB(35, 255, 255, 255))
    else
      self.Orb = nil
    end
  end

  function Ahri:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      minion = GetLowestMinion(data[_Q].range)
      if minion and minion < GetDmg(_Q, myHero, minion) then 
        Cast(_Q, minion)
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      minion = GetClosestMinion(data[_W].range)
      if minion and minion.health < GetDmg(_W, myHero, minion) then 
        Cast(_W)
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      minion = GetLowestMinion(data[_E].range)
      if minion and minion.health < GetDmg(_E, myHero, minion) then 
        Cast(_E, minion)
      end
    end
  end

  function Ahri:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetLineFarmPosition(data[_Q].range, data[_Q].width)
      if BestPos and BestHit > 1 then 
        Cast(_Q, BestPos)
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      minion = GetClosestMinion(data[_W].range)
      if minion and minion.health < GetDmg(_W, myHero, minion) then 
        Cast(_W)
      end
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      minion = GetLowestMinion(data[_E].range)
      if minion and minion.health < GetDmg(_E, myHero, minion) then 
        Cast(_E, minion)
      end
    end
  end

  function Ahri:Combo()
    if not Target then return end
    if sReady[_E] and Config:getParam("Combo", "E") and GetDistance(Target) < data[2].range then
      Cast(_E, Target, false, true, 2)
    end
    if GetStacks(Target) > 0 then
      if sReady[_Q] and Config:getParam("Combo", "Q") and GetDistance(Target) < data[0].range then
        Cast(_Q, Target, false, true, 2)
      end
      if sReady[_W] and Config:getParam("Combo", "W") and GetDistance(Target) < data[1].range then
        Cast(_W)
      end
    else
      if sReady[_Q] and Config:getParam("Combo", "Q") and GetDistance(Target) < data[0].range then
        Cast(_Q, Target, false, true, 2)
      end
      if sReady[_W] and Config:getParam("Combo", "W") and GetDistance(Target) < data[1].range then
        Cast(_W)
      end
      self:CatchQ()
    end
    if Target.health < GetDmg(_Q,myHero,Target)+GetDmg(_W,myHero,Target)+GetDmg(_E,myHero,Target)+GetDmg(_R,myHero,Target) and GetDistance(Target) < data[3].range then
      local ultPos = Vector(Target.x, Target.y, Target.z) - ( Vector(Target.x, Target.y, Target.z) - Vector(myHero.x, myHero.y, myHero.z)):perpendicular():normalized() * 350
      Cast(_R, ultPos)
    elseif self.ultOn > GetInGameTimer()-10 and (not self.Orb or self.Orb.time < GetInGameTimer()-1.5) and GetDistance(Target) < data[3].range then
      local ultPos = Vector(Target.x, Target.y, Target.z) - ( Vector(Target.x, Target.y, Target.z) - Vector(myHero.x, myHero.y, myHero.z)):perpendicular():normalized() * 350
      Cast(_R, ultPos)
    end
  end

  function Ahri:CatchQ()
    if Target and self.Orb and self.Orb.dir and self.Orb.time > GetInGameTimer()-1.5 then
      --DisableOrbwalkerMovement()
      local x,y,z = UPL.VP:GetLineCastPosition(Target, data[0].delay, data[0].width, data[0].range, data[0].speed, Vector(Vector(self.Orb.dir)+(Vector(self.Orb.dir)-myHero):normalized()*(data[0].range-GetDistance(self.Orb.dir))), data[0].collision)
      local x = Vector(self.Orb.dir)+(x-Vector(self.Orb.dir)):normalized()*(data[0].range)
      if self.ultOn > GetInGameTimer()-10 then
        x = Vector(x)-(Vector(Target)-myHero):normalized()*data[3].range
        Cast(_R,x)
      else
        --myHero:MoveTo(x.x,x.z)
      end
      if x and GetDistance(x) < 50  then
        --EnableOrbwalkerMovement()   
      end 
    else
      --EnableOrbwalkerMovement() 
    end
  end

  function Ahri:Harrass()
    if not Target then return end
    if sReady[_E] and Config:getParam("Harrass", "E") and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana and GetDistance(Target) < data[2].range then
      Cast(_E, Target, false, true, 2)
    end
    if GetStacks(Target) > 0 then
      if sReady[_Q] and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and GetDistance(Target) < data[0].range then
        Cast(_Q, Target, false, true, 2)
      end
      if sReady[_W] and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana and GetDistance(Target) < data[1].range then
        Cast(_W)
      end
    else
      if sReady[_Q] and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and GetDistance(Target) < data[0].range then
        Cast(_Q, Target, false, true, 2)
      end
      if sReady[_W] and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana and GetDistance(Target) < data[1].range then
        Cast(_W)
      end
      self:CatchQ()
    end
  end

  function Ahri:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        local ultPos = Vector(enemy.x, enemy.y, enemy.z) - ( Vector(enemy.x, enemy.y, enemy.z) - Vector(myHero.x, myHero.y, myHero.z)):perpendicular():normalized() * 350
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy)*2 and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 2)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, ultPos)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy)+GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "R") and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[3].range) then
          Cast(_Q, enemy, false, true, 1.5)
          Cast(_R, enemy)
        elseif myHero:CanUseSpell(_W) == READY and myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy)+GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "R") and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[3].range) then
          Cast(_W)
          Cast(_R, ultPos)
        elseif myHero:CanUseSpell(_E) == READY and myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "R") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
          DelayAction(function() if GetStacks(enemy) > 0 then Cast(_R, ultPos) end end, data[2].delay+GetDistance(enemy)/data[2].speed)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_Q, enemy, false, true, 1.5)
          Cast(_W)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
          DelayAction(function() if GetStacks(enemy) > 0 then Cast(_Q, enemy, false, true, 1.5) end end, data[2].delay+GetDistance(enemy)/data[2].speed)
        elseif myHero:CanUseSpell(_W) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_W, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "W") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
          DelayAction(function() if GetStacks(enemy) > 0 then Cast(_W) end end, data[2].delay+GetDistance(enemy)/data[2].speed)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_W) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_W, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "W") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
          DelayAction(function() if GetStacks(enemy) > 0 then Cast(_Q, enemy, false, true, 1.5) Cast(_W) end end, data[2].delay+GetDistance(enemy)/data[2].speed)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_W) == READY and myHero:CanUseSpell(_E) == READY and myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_W, myHero, enemy)+GetDmg(_E, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "W") and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
          DelayAction(function() if GetStacks(enemy) > 0 then Cast(_Q, enemy, false, true, 1.5) Cast(_W) Cast(_R, ultPos) end end, data[2].delay+GetDistance(enemy)/data[2].speed)
        end
      end
    end
  end
  
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Ashe"

  function Ashe:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL)
    self:Menu()
    AddTickCallback(function() self:AimR() end)
  end

  function Ashe:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W"}, slider = {50,50}})
    end
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Misc", name = "AimR", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Ashe:AimR()
    if Config:getParam("Misc", "AimR") then
      for _,k in pairs(GetEnemyHeroes()) do
        if not k.dead and GetDistance(k,mousePos) < 750 then
          Cast(_R, k, false, true, 2)
        end
      end
    end
  end

  function Ashe:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for i, minion in pairs(minionManager(MINION_ENEMY, data[0].range, player, MINION_SORT_HEALTH_ASC).objects) do
        local QMinionDmg = GetDmg(_Q, myHero, minion)
        if QMinionDmg >= minion.health and ValidTarget(minion, data[0].range) then
          if self:QReady() then
            Cast(_Q) 
            myHero:Attack(minion)
          end
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      for i, minion in pairs(minionManager(MINION_ENEMY, data[1].range, player, MINION_SORT_HEALTH_ASC).objects) do
        local WMinionDmg = GetDmg(_W, myHero, minion)
        if WMinionDmg >= minion.health and ValidTarget(minion, data[1].range+data[1].width) then
          Cast(_W, minion)
        end
      end    
    end  
  end

  function Ashe:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      if self:QReady() then
        Cast(_Q)
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for i, minion in pairs(minionManager(MINION_ENEMY, data[1].range, player, MINION_SORT_HEALTH_ASC).objects) do
        if minionTarget == nil then 
          minionTarget = minion
        elseif minionTarget.health >= minion.health and ValidTarget(minion, data[1].range) then
          minionTarget = minion
        end
      end
      if minionTarget ~= nil then
        Cast(_W, minionTarget)
      end
    end 
  end

  function Ashe:Combo()
    if Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      if self:QReady() then
        Cast(_Q)
      end
    end
    if Config:getParam("Combo", "W") and ValidTarget(Target, data[1].range) then
      Cast(_W, Target, false, true, 1.5)
    end
    if Config:getParam("Combo", "R") and GetDistance(Target) < myHero.range*2+myHero.boundingRadius*4 and GetDmg(_R, myHero, Target)+GetDmg("AD", myHero, Target)+GetDmg(_W, myHero, Target) < Target.health then
      Cast(_R, Target, false, true, 1.5)
    end
  end

  function Ashe:Harrass()
    if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and myHero:CanUseSpell(_Q) == READY and ValidTarget(Target, data[0].range) then
      if self:QReady() then
        CastSpell(_Q, myHero:Attack(Target))
      end
    end
    if Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana and myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) then
      Cast(_W, Target, false, true, 1.5)
    end
  end

  function Ashe:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and self:QReady() and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          CastSpell(_Q, myHero:Attack(enemy))
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and GetDistance(enemy) < 2500 then
          Cast(_R, enemy, false, true, 1.5)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

  function Ashe:QReady()
    for i = 1, myHero.buffCount do
      local buff = myHero:getBuff(i)
      if buff and buff.valid and buff.name ~= nil and buff.name == "asheqcastready" and buff.endT > GetInGameTimer() then 
        return true 
      end
    end
    return false
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Azir"

  function Azir:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, data[0].range, DAMAGE_MAGICAL)
    self:Menu()
    self.soldierToDash = nil
    self.Target = nil
    AddProcessSpellCallback(function(unit, spell) self:ProcessSpell(unit, spell) end)
  end

  function Azir:ProcessSpell(unit, spell)
    if unit and unit.isMe and spell then
      if spell.name == "AzirQ" then
        for _,obj in pairs(objHolder) do
          if objTimeHolder[obj.networkID] and objTimeHolder[obj.networkID] < math.huge and objTimeHolder[obj.networkID]>GetInGameTimer() then 
            objTimeHolder[obj.networkID] = objTimeHolder[obj.networkID] + 1
          end
        end
      end
    end
  end

  function Azir:CountSoldiers(unit)
    soldiers = 0
    for _,obj in pairs(objHolder) do
      if objTimeHolder[obj.networkID] and objTimeHolder[obj.networkID] < math.huge and objTimeHolder[obj.networkID]>GetInGameTimer() and not (unit and GetDistance(obj, unit) > data[1].width) then 
        soldiers = soldiers + 1
      end
    end
    return soldiers
  end

  function Azir:GetSoldier(i)
    soldiers = 0
    for _,obj in pairs(objHolder) do
      if objTimeHolder[obj.networkID] and objTimeHolder[obj.networkID] < math.huge and objTimeHolder[obj.networkID]>GetInGameTimer() then 
        soldiers = soldiers + 1
        if i == soldiers then return obj end
      end
    end
  end

  function Azir:GetSoldiers()
    soldiers = {}
    for _,obj in pairs(objHolder) do
      if objTimeHolder[obj.networkID] and objTimeHolder[obj.networkID] < math.huge and objTimeHolder[obj.networkID]>GetInGameTimer() then 
        table.insert(soldiers, obj)
      end
    end
    return soldiers
  end

  function Azir:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W"}, slider = {50,50}})
    end
    Config:addParam({state = "Combo", name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Killsteal", name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Misc", name = "Flee", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Misc", name = "Insec", key = string.byte("G"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Azir:LastHit()
    if self.Target and self.Target.type ~= myHero.type and self:CountSoldiers() < 1 and sReady[_W] and ((Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      Cast(_W, self.Target)
    end
    if ((Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) and self.Target and self:CountSoldiers() > 0 and GetDmg(_Q, myHero, self.Target)*self:CountSoldiers() > self.Target.health then
      Cast(_Q, self.Target)
    end
  end

  function Azir:LaneClear()
    if self.Target and self.Target.type ~= myHero.type and self:CountSoldiers() < 1 and sReady[_W] and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      Cast(_W, self.Target)
    end
    if Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and self:CountSoldiers() > 0 then
      for _,k in pairs(self:GetSoldiers()) do
        pos, hit = GetLineFarmPosition(data[0].range,data[0].width,k)
        if pos and hit > 0 then
          Cast(_Q, pos)
        end
      end
    end
  end

  function Azir:Combo()
    if sReady[_W] and Config:getParam("Combo", "W") then
      Cast(_W, self.Target)
    end
    if Config:getParam("Combo", "Q") and self:CountSoldiers() > 0 then
      for _,k in pairs(self:GetSoldiers()) do
        Cast(_Q, self.Target, false, true, 1.5)
      end
    end
    if self.Target and Config:getParam("Combo", "E") and self.Target.health < GetDmg(_E,myHero,self.Target)+self:CountSoldiers()*GetDmg(_W,myHero,self.Target)+GetDmg(_Q,myHero,self.Target) then
      for _,k in pairs(self:GetSoldiers()) do
        local x, y, z = VectorPointProjectionOnLineSegment(myHero, k, self.Target)
        if x and y and z then
          Cast(_E,k,true)
        end
      end
    end
    if self.Target and Config:getParam("Combo", "R") and self.Target.health < GetDmg(_R,myHero,self.Target)+GetDmg(_E,myHero,self.Target)+self:CountSoldiers()*GetDmg(_W,myHero,self.Target)+GetDmg(_Q,myHero,self.Target) then
      Cast(_R,self.Target,false,true,2)
    end
  end

  function Azir:Harrass()
    if self:CountSoldiers() <= 1 and sReady[_W] and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      Cast(_W, self.Target)
    end
    if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and self:CountSoldiers() > 0 then
      for _,k in pairs(self:GetSoldiers()) do
        Cast(_Q, self.Target, false, true, 1.5)
      end
    end
  end

  function Azir:Flee()
    if self:CountSoldiers() > 0 then
      for _,k in pairs(self:GetSoldiers()) do
        if not self.soldierToDash then
          self.soldierToDash = k
        elseif self.soldierToDash and GetDistanceSqr(k,mousePos) < GetDistanceSqr(self.soldierToDash,mousePos) then
          self.soldierToDash = k
        end
      end
    end
    if not self.soldierToDash and sReady[_W] then
      Cast(_W, mousePos)
    end
    if self:CountSoldiers() > 0 and self.soldierToDash then
      local movePos = myHero + (Vector(mousePos) - myHero):normalized() * data[0].range
      if movePos then
        Cast(_Q, movePos)
        Cast(_E, self.soldierToDash, true)
        DelayAction(function() self.soldierToDash = nil end, myHero:GetSpellData(_E).currentCd)
      end
    end
  end

  function Azir:Insec()
    local enemy = GetClosestEnemy(mousePos)
    if not enemy then return end
    if GetDistance(enemy) > 750 then return end
    if self:CountSoldiers() > 0 then
      for _,k in pairs(self:GetSoldiers()) do
        if not self.soldierToDash then
          self.soldierToDash = k
        elseif self.soldierToDash and GetDistanceSqr(k,enemy) < GetDistanceSqr(self.soldierToDash,enemy) then
          self.soldierToDash = k
        end
      end
    end
    if not self.soldierToDash and sReady[_W] then
      Cast(_W, enemy)
    end
    if self:CountSoldiers() > 0 and self.soldierToDash then
      local movePos = myHero + (Vector(enemy) - myHero):normalized() * data[0].range + (Vector(enemy) - myHero):normalized():perpendicular() * data[1].width
      if movePos then
        Cast(_Q, movePos)
        Cast(_E, self.soldierToDash, true)
        DelayAction(function() Cast(_R, enemy, false, true, 1) end, 1)
        DelayAction(function() self.soldierToDash = nil end, 2)
      end
    end
  end

  function Azir:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if self:CountSoldiers(enemy)*GetDmg(_W,myHero,enemy) > enemy.health and Config:getParam("Killsteal", "W") and GetDistance(enemy) < data[1].range+data[1].width then 
          myHero:Attack(enemy)
        elseif (self:CountSoldiers(enemy)+1)*GetDmg(_W,myHero,enemy) > enemy.health and Config:getParam("Killsteal", "W") and GetDistance(enemy) < data[1].range+data[1].width then 
          Cast(_W, enemy)
          myHero:Attack(enemy)
        elseif GetDmg(_R,myHero,enemy) > enemy.health and Config:getParam("Killsteal", "R") and GetDistance(enemy) < data[3].range then
          Cast(_R, enemy, false, true, 1)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Blitzcrank"

  function Blitzcrank:__init()
    require "Collision"
    self.Col = Collision(data[0].range, data[0].speed, data[0].delay, data[0].width+30)
    self.Forcetarget = nil
    self:Menu()
    AddDrawCallback(function() self:Draw() end)
    AddMsgCallback(function(x,y) self:WndMsg(x,y) end)
  end

  function Blitzcrank:Menu()
    for _,s in pairs({"Combo", "Harrass", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Harrass", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","E"}, slider = {50,50}})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Blitzcrank:GetBestTarget(Range)
    local LessToKill = 100
    local LessToKilli = 0
    local target = nil
    for i=1, heroManager.iCount do
      local enemy = heroManager:GetHero(i)
      if ValidTarget(enemy, Range) then
        DamageToHero = GetDmg(_Q, myHero, enemy)
        ToKill = enemy.health / DamageToHero
        if ((ToKill < LessToKill) or (LessToKilli == 0)) then
          LessToKill = ToKill
          LessToKilli = i
          target = enemy
        end
      end
    end
    return target
  end

  function Blitzcrank:Combo()
    local target = self:GetBestTarget(data[0].range)
    if self.Forcetarget ~= nil and ValidTarget(self.Forcetarget, data[0].range*2) then
      target = self.Forcetarget  
    end

    if target and myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") then
      if GetDistance(target, myHero) <= myHero.range+myHero.boundingRadius+target.boundingRadius or (GetStacks(target) > 0 and GetDistance(target, myHero) < data[0].range) then
        CastSpell(_E, myHero:Attack(target))
      end
    end

    if target and myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") then
      local CastPosition,  HitChance, HeroPosition = UPL:Predict(_Q, myHero, target)
      if HitChance > 1.2 and GetDistance(CastPosition) <= data[0].range  then
        local Mcol = self.Col:GetMinionCollision(myHero, CastPosition)
        local Mcol2 = self.Col:GetMinionCollision(myHero, target)
        if not Mcol and not Mcol2 then
          CastSpell(_Q, CastPosition.x,  CastPosition.z)
        end
      end
    end
  end

  function Blitzcrank:Harrass()
    local target = self:GetBestTarget(data[0].range)
    if self.Forcetarget ~= nil and ValidTarget(self.Forcetarget, data[0].range*2) then
      target = self.Forcetarget  
    end

    if target and myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "E") and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      if GetDistance(target, myHero) <= myHero.range+myHero.boundingRadius+target.boundingRadius or (GetStacks(target) > 0 and GetDistance(target, myHero) < data[0].range) then
        CastSpell(_E, myHero:Attack(target))
      end
    end
    
    if target and myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      local CastPosition,  HitChance, HeroPosition = UPL:Predict(_Q, myHero, target)
      if HitChance > 1.5 and GetDistance(CastPosition) <= data[0].range  then
        local Mcol = self.Col:GetMinionCollision(myHero, CastPosition)
        local Mcol2 = self.Col:GetMinionCollision(myHero, target)
        if not Mcol and not Mcol2 then
          CastSpell(_Q, CastPosition.x,  CastPosition.z)
        end
      end
    end
  end

  function Blitzcrank:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 2)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          CastSpell(_E, myHero:Attack(enemy))
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range-enemy.boundingRadius) then
          Cast(_R)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

  function Blitzcrank:Draw()
    local target = self:GetBestTarget(data[0].range)
    if self.Forcetarget ~= nil and ValidTarget(self.Forcetarget, data[0].range*2) then
      target = self.Forcetarget  
    end
    
    if self.Forcetarget ~= nil then
      DrawLFC(self.Forcetarget.x, self.Forcetarget.y, self.Forcetarget.z, data[0].width, ARGB(255, 0, 255, 0))
    end
    
    if Config:getParam("Draws", "Q") and myHero:CanUseSpell(_Q) and target ~= nil then
      local CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, target)
      if CastPosition then
        DrawLFC(CastPosition.x, CastPosition.y, CastPosition.z, data[0].range, ARGB(255, 255, 0, 0))
        DrawLine3D(myHero.x, myHero.y, myHero.z, CastPosition.x, CastPosition.y, CastPosition.z, 1, ARGB(155,55,255,55))
        DrawLine3D(myHero.x, myHero.y, myHero.z, target.x,       target.y,       target.z,       1, ARGB(255,55,55,255))
      end
    end
  end

  function Blitzcrank:WndMsg(Msg, Key)
    if Msg == WM_LBUTTONDOWN then
      local minD = 0
      local starget = nil
      for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
          if GetDistance(enemy, mousePos) <= minD or starget == nil then
            minD = GetDistance(enemy, mousePos)
            starget = enemy
          end
        end
      end
      
      if starget and minD < 500 then
        if self.Forcetarget and starget.charName == self.Forcetarget.charName then
          self.Forcetarget = nil
          ScriptologyMsg("Target un-selected.")
        else
          self.Forcetarget = starget
          ScriptologyMsg("New target selected: "..starget.charName)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Brand"

  function Brand:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
  end

  function Brand:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Brand:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, false, true, 1.2)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_W, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[1].range) and GetDistance(winion) < data[1].range then
          Cast(_W, Target, false, true, 1.5)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_E, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          Cast(_E, winion, true)
        end
      end
    end
  end

  function Brand:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) <= 100*data[0].range then
          minionTarget = winion
        end
      end
      if minionTarget ~= nil then
        Cast(_Q, minionTarget, false, true, 1.2)
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetFarmPosition(data[_W].range, data[_W].width)
      if BestHit > 1 then 
        Cast(_W, BestPos)
      end
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          minionTarget = winion
        end
      end
      if minionTarget ~= nil and (stackTable[minionTarget.networkID] and stackTable[minionTarget.networkID] > 0) then
        Cast(_E, winion, true)
      end
    end
  end

  function Brand:Combo()
    if (myHero:CanUseSpell(_E) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Combo", "E") then
      if myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].range) then
        Cast(_E, Target, true)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
      if myHero:CanUseSpell(_W) == READY and Config:getParam("Combo", "W") and ValidTarget(Target, data[1].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_W, Target, false, true, 1.5)
        end
      end
    elseif (myHero:CanUseSpell(_W) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Combo", "W") then
      if myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) then
        Cast(_W, Target, false, true, 1.5)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
    else
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
        Cast(_Q, Target, false, true, 1.5)
      end
    end
    if Config:getParam("Combo", "R") and (GetDmg(_R, myHero, Target) >= Target.health or (EnemiesAround(Target, 500) > 1 and stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and ValidTarget(Target, data[3].range) then
      Cast(_R, Target, true)
    end
  end

  function Brand:Harrass()
    if (myHero:CanUseSpell(_E) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Harrass", "E") then
      if myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].range) and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
        Cast(_E, Target, true)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and ValidTarget(Target, data[0].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
      if myHero:CanUseSpell(_W) == READY and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana and ValidTarget(Target, data[1].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_W, Target, false, true, 1.5)
        end
      end
    elseif (myHero:CanUseSpell(_W) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Harrass", "W") then
      if myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
        Cast(_W, Target, false, true, 1.5)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, data[0].range) and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
    else
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, data[0].range) and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        Cast(_Q, Target, false, true, 2)
      end
    end
  end

  function Brand:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, true)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Cassiopeia"

  function Cassiopeia:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST, 900, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.lastE = 0
    AddTickCallback(function() self:LastHitSomethingPoisonedWithE() end)
    AddProcessSpellCallback(function(x,y) self:ProcessSpell(x,y) end)
  end

  function Cassiopeia:ProcessSpell(unit, spell)
    if unit and unit.isMe then
      if spell.name == "CassiopeiaTwinFang" then
        self.lastE = GetInGameTimer() + (100+Config:getParam("Misc", "Humanizer", "E"))/200
      end
    end
  end

  function Cassiopeia:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "LastHit", name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,65,30}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Misc", name = "Humanizer", code = SCRIPT_PARAM_SLICE, text = {"E"}, slider = {0}})
  end

  function Cassiopeia:LastHitSomethingPoisonedWithE()
    if self.lastE > GetInGameTimer() then return end
    if Config:getParam("LastHit", "E") and not Config:getParam("Combo", "Combo") and not Config:getParam("Harrass", "Harrass") then    
      for i, minion in pairs(minionManager(MINION_ENEMY, 825, myHero, MINION_SORT_HEALTH_ASC).objects) do    
        local EMinionDmg = GetDmg(_E, myHero, minion)  
        if EMinionDmg >= minion.health and GetStacks(minion) > 0 and ValidTarget(minion, data[2].range) then
          Cast(_E, minion, true)
        end      
      end   
      for i, minion in pairs(minionManager(MINION_JUNGLE, 825, myHero, MINION_SORT_HEALTH_ASC).objects) do    
        local EMinionDmg = GetDmg(_E, myHero, minion)  
        if EMinionDmg >= minion.health and GetStacks(minion) > 0 and ValidTarget(minion, data[2].range) then
          Cast(_E, minion, true)
        end      
      end    
    end  
  end

  function Cassiopeia:LastHit()
    if self.lastE > GetInGameTimer() then return end
    if Config:getParam("LastHit", "E") then    
      for i, minion in pairs(minionManager(MINION_ENEMY, 825, myHero, MINION_SORT_HEALTH_ASC).objects) do    
        local EMinionDmg = GetDmg(_E, myHero, minion)  
        if EMinionDmg >= minion.health and ValidTarget(minion, data[2].range) then
          Cast(_E, minion, true)
        end      
      end   
      for i, minion in pairs(minionManager(MINION_JUNGLE, 825, myHero, MINION_SORT_HEALTH_ASC).objects) do    
        local EMinionDmg = GetDmg(_E, myHero, minion)  
        if EMinionDmg >= minion.health and ValidTarget(minion, data[2].range) then
          Cast(_E, minion, true)
        end      
      end    
    end  
  end

  function Cassiopeia:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetFarmPosition(data[_Q].range, data[_Q].width)
      if BestHit > 1 then 
        Cast(_Q, BestPos)
      else
        local minionTarget = nil
        for minion,winion in pairs(Mobs.objects) do
          if minionTarget == nil then 
            minionTarget = winion
          elseif minionTarget.health < winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
            minionTarget = winion
          end
        end
        for minion,winion in pairs(JMobs.objects) do
          if minionTarget == nil then 
            minionTarget = winion
          elseif minionTarget.health < winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
            minionTarget = winion
          end
        end
        if minionTarget ~= nil then
          Cast(_Q, minionTarget)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetFarmPosition(data[_W].range, data[_W].width)
      if BestHit > 1 then 
        Cast(_W, BestPos)
      end
    end
    if self.lastE > GetInGameTimer() then return end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      for minion,winion in pairs(Mobs.objects) do
        if winion ~= nil and GetStacks(winion) > 0 then
          Cast(_E, winion, true)
        end
      end
      for minion,winion in pairs(JMobs.objects) do
        if winion ~= nil and GetStacks(winion) > 0 then
          Cast(_E, winion, true)
        end
      end
    end
  end

  function Cassiopeia:Combo()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, false, true, 1.5)
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("Combo", "W") and ValidTarget(Target, data[1].range) then
      Cast(_W, Target, false, true, 1.5)
    end
    if myHero:CanUseSpell(_E) == READY and self.lastE < GetInGameTimer() and Config:getParam("Combo", "E") and ValidTarget(Target, data[2].range) then
      if GetStacks(Target) > 0 then
        Cast(_E, Target, true)
      end
    end
    if Config:getParam("Combo", "R") and (GetDmg(_R, myHero, Target) + 2*GetDmg(_E, myHero, Target) >= Target.health or (EnemiesAroundAndFacingMe(Target, 500) > 1 and GetStacks(Target) > 0)) and ValidTarget(Target, data[3].range) then
      Cast(_R, Target, true)
    end
  end

  function Cassiopeia:Harrass()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, data[0].range) and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      Cast(_Q, Target, false, true, 1.5)
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("Harrass", "W") and ValidTarget(Target, data[1].range) and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      Cast(_W, Target, false, true, 1.5)
    end
    if myHero:CanUseSpell(_E) == READY and self.lastE < GetInGameTimer() and Config:getParam("Harrass", "E") and ValidTarget(Target, data[2].range) and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      if GetStacks(Target) > 0 then
        Cast(_E, Target, true)
      end
    end
  end

  function Cassiopeia:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif enemy.health < GetDmg(_E, myHero, enemy)*2 and GetStacks(enemy) > 0 and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
          DelayAction(Cast, 0.55, {_E, enemy, true})
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, false, true, 2)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Darius"

  function Darius:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
    AddTickCallback(function() self:Harrass2() end)
  end

  function Darius:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W"}, slider = {30,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Toggle", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYTOGGLE, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Misc", name = "offset", code = SCRIPT_PARAM_SLICE, text = {"Q","E"}, slider = {100,100}})
  end

  function Darius:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") < myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg1 = self:GetDmg("Q1", myHero, winion)
        local MinionDmg2 = self:GetDmg("Q", myHero, winion)
        if MinionDmg1 and MinionDmg1 >= winion.health+winion.shield and ValidTarget(winion, 450) then
          CastQ(winion)
        elseif MinionDmg2 and MinionDmg2 >= winion.health+winion.shield and ValidTarget(winion, 250) and GetDistance(winion) < 250 then
          Cast(_Q)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") < myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") < myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = self:GetDmg("W", myHero, winion)
        if MinionDmg and MinionDmg >= winion.health+winion.shield and ValidTarget(winion, myHero.range+myHero.boundingRadius) then
          CastSpell(_W, myHero:Attack(winion))
        end
      end
    end
  end

  function Darius:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana*100 then
      BestPos, BestHit = GetFarmPosition(0, data[0].width)
      if BestHit > 1 and GetDistance(BestPos) < 150 then 
        Cast(_Q)
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") < myHero.mana/myHero.maxMana*100 then
      local minionTarget = nil
      for i, minion in pairs(minionManager(MINION_ENEMY, 250, myHero, MINION_SORT_HEALTH_ASC).objects) do
        if minionTarget == nil then 
          minionTarget = minion
        elseif minionTarget.health+minionTarget.shield >= minion.health+minion.shield and ValidTarget(minion, 250) then
          minionTarget = minion
        end
      end
      if minionTarget ~= nil then
        CastSpell(_W, myHero:Attack(minionTarget))
      end
    end
  end

  function Darius:Combo()
    if lastWindup+0.25 > GetInGameTimer() then 
      if myHero:CanUseSpell(_W) == READY then
        CastSpell(_W, myHero:Attack(Target))
      end
    else
      if myHero:CanUseSpell(_Q) == READY and GetDistance(Target) >= 250 then
        self:CastQ(Target)
      elseif myHero:CanUseSpell(_Q) == READY and GetDistance(Target) < 250 then
        Cast(_Q)
      end
      if myHero:CanUseSpell(_E) == READY then
        self:CastE(Target)
      end
      if myHero:CanUseSpell(_R) == READY and not IsInvinc(Target) and GetDmg(_R, myHero, Target) > Target.health+Target.shield and Config:getParam("Combo", "R") then
        Cast(_R, enemy, true)
      end
    end
  end

  function Darius:Harrass()
    if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") < myHero.mana/myHero.maxMana and myHero:CanUseSpell(_Q) == READY then
      self:CastQ(Target)
    end
    if Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") < myHero.mana/myHero.maxMana and myHero:CanUseSpell(_W) == READY then
      self:CastW(Target)
    end
  end

  function Darius:Harrass2()
    if Config:getParam("Harrass", "Toggle") then
      if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") < myHero.mana/myHero.maxMana and myHero:CanUseSpell(_Q) == READY then
        self:CastQ(Target)
      end
      if Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") < myHero.mana/myHero.maxMana and myHero:CanUseSpell(_W) == READY then
        self:CastW(Target)
      end
    end
  end

  function Darius:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      local qDmg = ((GetDmg(_Q, myHero, enemy)*1.5) or 0) 
      local q1Dmg = ((GetDmg(_Q, myHero, enemy)) or 0)  
      local wDmg = ((GetDmg(_W, myHero, enemy)) or 0)   
      local rDmg = ((GetDmg(_R, myHero, enemy)) or 0)
      local iDmg = (50 + 20 * myHero.level) / 5
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if not IsInvinc(enemy) and myHero:GetSpellData(_R).level == 3 and myHero:CanUseSpell(_R) and enemy.health+enemy.shield < rDmg and Config:getParam("Killsteal", "R") and ValidTarget(enemy, 450) then
          Cast(_R, enemy, true)
        elseif myHero:CanUseSpell(_Q) and enemy.health+enemy.shield < qDmg and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, 450) then
          self:CastQ(enemy)
        elseif myHero:CanUseSpell(_Q) and enemy.health+enemy.shield < q1Dmg and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, 300) then
          Cast(_Q)
        elseif myHero:CanUseSpell(_W) and enemy.health+enemy.shield < wDmg and Config:getParam("Killsteal", "W") then
          if ValidTarget(enemy, myHero.range+myHero.boundingRadius) then
            CastSpell(_W, myHero:Attack(enemy))
          elseif ValidTarget(enemy, data[2].range*(Config:getParam("Misc", "offset", "E")/100)) then
            self:CastE(enemy)
            DelayAction(function() CastSpell(_W, myHero:Attack(enemy)) end, 0.38)
          end
        elseif not IsInvinc(enemy) and myHero:CanUseSpell(_R) and enemy.health+enemy.shield < rDmg and Config:getParam("Killsteal", "R") and ValidTarget(enemy, 450) then
      if ScriptologyDebug then print(rDmg)  end
          Cast(_R, enemy, true)
        elseif enemy.health+enemy.shield < iDmg and Config:getParam("Killsteal", "I") and ValidTarget(enemy, 600) and myHero:CanUseSpell(self.Ignite) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

  function Darius:CastQ(target) 
    if target == nil then return end
    local dist = target.ms < 350 and 0 or (Vector(myHero.x-target.x, myHero.y-target.y, myHero.z-target.z):len() < 0 and 25 or 0)
    if GetDistance(target) < data[0].width*(Config:getParam("Misc", "offset", "Q")/100)-dist and GetDistance(target) >= 250 then
      Cast(_Q)
    end
  end

  function Darius:CastE(target) 
    if target == nil then return end
    local dist = target.ms < 350 and 0 or (Vector(myHero.x-target.x, myHero.y-target.y, myHero.z-target.z):len() < 0 and 25 or 0)
    if GetDistance(target) < data[2].range*(Config:getParam("Misc", "offset", "E")/100)-dist then
      Cast(_E, target)
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Ekko"

  function Ekko:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
  end

  function Ekko:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Combo", name = "W", code = SCRIPT_PARAM_ONOFF, value = false})
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Ekko:GetTwin()
    local twin = nil
    for _,k in pairs(objHolder) do
      if k and k.name == "Ekko" and k.valid then
        twin = k
      end
    end
    return twin
  end

  function Ekko:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local QMinionDmg = GetDmg(_Q, myHero, winion)
        if QMinionDmg and QMinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, false, true, 1.2)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_E, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[2].range+myHero.range+myHero.boundingRadius) and GetDistance(winion) < data[2].range+myHero.range+myHero.boundingRadius then
          Cast(_E, winion)
        end
      end
    end
  end

  function Ekko:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana*100 then
      pos, hit = GetFarmPosition(data[_Q].range, data[_Q].width)
      if hit > 1 then
        Cast(_Q, pos)
      end
    end
  end

  function Ekko:Combo()
    if Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, false, true, 1.2)
    end
    if Config:getParam("Combo", "W") and ValidTarget(Target, data[1].range) then
      Cast(_W, Target, false, true, 1)
    end
    if GetLichSlot() then
      if myHero:GetSpellData(GetLichSlot()).currentCd == 0 and Config:getParam("Combo", "E") and ValidTarget(Target, data[2].range+(myHero.range+myHero.boundingRadius*2)*2) then
        Cast(_E, Target)
      elseif myHero:GetSpellData(GetLichSlot()).currentCd > 0 and Config:getParam("Combo", "E") and ValidTarget(Target, data[2].range+(myHero.range+myHero.boundingRadius*2)*2) and GetDistance(Target) > myHero.range+myHero.boundingRadius*2 then
        Cast(_E, Target)
      end
    else
      if Config:getParam("Combo", "E") and ValidTarget(Target, data[2].range+(myHero.range+myHero.boundingRadius)*2) then
        Cast(_E, Target)
      end
    end
  end

  function Ekko:Harrass()
    if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") < myHero.mana/myHero.maxMana*100 and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, false, true, 1.5)
    end
    if GetLichSlot() then
      if myHero:GetSpellData(GetLichSlot()).currentCd == 0 and Config:getParam("Harrass", "mana", "E") < myHero.mana/myHero.maxMana*100 and Config:getParam("Harrass", "E") and ValidTarget(Target, data[2].range+(myHero.range+myHero.boundingRadius*2)*2) then
        Cast(_E, Target)
      elseif myHero:GetSpellData(GetLichSlot()).currentCd > 0 and Config:getParam("Harrass", "mana", "E") < myHero.mana/myHero.maxMana*100 and Config:getParam("Harrass", "E") and ValidTarget(Target, data[2].range+(myHero.range+myHero.boundingRadius*2)*2) and GetDistance(Target) > myHero.range+myHero.boundingRadius*2 then
        Cast(_E, Target)
      end
    else
      if Config:getParam("Harrass", "E") and Config:getParam("Harrass", "mana", "E") < myHero.mana/myHero.maxMana*100 and ValidTarget(Target, data[2].range+(myHero.range+myHero.boundingRadius)*2) then
        Cast(_E, Target)
      end
    end
  end

  function Ekko:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range+(myHero.range+myHero.boundingRadius)*2) then
          Cast(_E, enemy)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, false, true, 1.5, self:GetTwin())
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Kalista"

  function Kalista:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.soulMate = nil
    self.saveAlly = false
    AddTickCallback(function() self:Tick() end)
    AddProcessSpellCallback(function(x,y) self:ProcessSpell(x,y) end)
  end

  function Kalista:ProcessSpell(unit, spell)
    if not unit or not spell or GetDistance(unit) > 1000 then return end
    if spell.name == "KalistaPSpellCast" then 
      self.soulMate = spell.target
      ScriptologyMsg("Soulmate found: "..spell.target.charName)
    end
    if Config:getParam("Misc", "R") and self.saveAlly and unit.team ~= self.soulMate.team and (self.soulMate == spell.target or GetDistance(spell.endPos,self.soulMate) < self.soulMate.boundingRadius*3) then
      Cast(_R)
      ScriptologyMsg("Saving soulmate from spell: "..spell.name)
      self.saveAlly = false
    end
  end

  function Kalista:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q"}, slider = {50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Misc", name = "WallJump", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Kalista:Tick()
    if Config:getParam("Misc", "WallJump") then
      CastSpell(_Q, mousePos.x, mousePos.z)
      myHero:MoveTo(mousePos.x, mousePos.z)
    end
    if myHero:CanUseSpell(_E) and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E")) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E")) or Config:getParam("Misc", "Ej")) then
      local killableCounter = 0
      local killableCounterJ = 0
      for minion,winion in pairs(Mobs.objects) do
        local EMinionDmg = GetDmg(_E, myHero, winion)  
        if winion ~= nil and EMinionDmg > winion.health and GetDistance(winion) < data[2].range then    
          killableCounter = killableCounter + 1
        end
      end
      for minion,winion in pairs(JMobs.objects) do
        local EMinionDmg = GetDmg(_E, myHero, winion)  
        if winion ~= nil and EMinionDmg > winion.health and GetDistance(winion) < data[2].range then
          if (string.find(winion.charName, "Crab") or string.find(winion.charName, "Rift") or string.find(winion.charName, "Baron") or string.find(winion.charName, "Dragon") or string.find(winion.charName, "Gromp") or ((string.find(winion.charName, "Krug") or string.find(winion.charName, "Murkwolf") or string.find(winion.charName, "Razorbeak") or string.find(winion.charName, "Red") or string.find(winion.charName, "Blue")))) then
            if not string.find(winion.charName, "Mini") then       
              killableCounterJ = killableCounterJ + 1
            end
          end
        end
      end
      if (Config:getParam("LaneClear", "LaneClear") and killableCounter >= 2) or (Config:getParam("LastHit", "LastHit") and killableCounter >= 2) or (Config:getParam("Misc", "Ej") and killableCounterJ >= 1) then
        Cast(_E)
      end
    end
    if self.soulMate and self.soulMate.health/self.soulMate.maxHealth < 0.15 then
      self.saveAlly = true
    else
      self.saveAlly = false
    end
    if Target and Config:getParam("Combo", "Combo") and Config:getParam("Misc", "AA_Gap") and GetDistance(GetClosestEnemy()) > myHero.range+myHero.boundingRadius+Target.boundingRadius then
      local winion = GetLowestMinion(myHero.range+myHero.boundingRadius*2)  
      if winion ~= nil then
        myHero:Attack(winion)
        myHero:MoveTo(mousePos.x, mousePos.z)
      end    
    end
  end

  function kalE(x)
    if x <= 1 then 
      return 10
    else 
      return kalE(x-1) + 2 + x
    end 
  end

  function Kalista:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, false, true, 1.2)
        end
      end
    end
  end

  function Kalista:LaneClear()
    -- soon
  end

  function Kalista:Combo()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) and myHero.mana >= 85+myHero:GetSpellData(_Q).level*5 then
      Cast(_Q, Target, false, true, 1.5)
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") and ValidTarget(Target, data[2].range) then
      if GetDmg(_E, myHero, Target) >= Target.health then
        Cast(_E)
      end
      local killableCounter = 0
      for minion,winion in pairs(Mobs.objects) do
        local EMinionDmg = GetDmg(_E, myHero, winion)      
        if winion ~= nil and EMinionDmg and EMinionDmg >= winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          killableCounter = killableCounter +1
        end   
      end   
      if killableCounter > 0 and GetStacks(Target) > 0 then
        Cast(_E)
      end
    end
  end

  function Kalista:Harrass()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and myHero.mana >= 85+myHero:GetSpellData(_Q).level*5 then
      Cast(_Q, Target, false, true, 1.2)
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "E") and ValidTarget(Target, data[2].range) then
      local harrassUnit = nil
      local killableCounter = 0
      for minion,winion in pairs(Mobs.objects) do
        local EMinionDmg = GetDmg(_E, myHero, winion)      
        if winion ~= nil and EMinionDmg and EMinionDmg >= winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          killableCounter = killableCounter +1
        end   
      end 
      for i, unit in pairs(GetEnemyHeroes()) do    
        local EChampDmg = GetDmg(_E, myHero, unit)      
        if unit ~= nil and EChampDmg and EChampDmg > 0 and ValidTarget(unit, data[2].range) and GetDistance(unit) < data[2].range then
          harrassUnit = unit
        end      
      end    
      if killableCounter >= 1 and harrassUnit ~= nil then
        Cast(_E)
      end
    end
  end

  function Kalista:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E)
        elseif myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Katarina"

  function Katarina:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST, 700, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.Target = nil
    self.Wards = {}
    self.casted, self.jumped = false, false
    self.oldPos = nil
    for i = 1, objManager.maxObjects do
      local object = objManager:GetObject(i)
      if object ~= nil and object.valid and string.find(string.lower(object.name), "ward") then
        table.insert(self.Wards, object)
      end
    end
    AddTickCallback(function() self:Tick() end)
    AddCreateObjCallback(function(obj) self:CreateObj(obj) end)
  end

  function Katarina:Tick()
    if Config:getParam("Misc", "Jump") then self:WardJump() end
  end

  function Katarina:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Misc", name = "Jump", key = string.byte("G"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Katarina:WardJump()
    if self.casted and self.jumped then self.casted, self.jumped = false, false
    elseif myHero:CanUseSpell(_E) == READY then
      local pos = self:getMousePos()
      if self:Jump(pos, 150, true) then return end
      slot = self:GetWardSlot()
      if not slot then return end
      CastSpell(slot, pos.x, pos.z)
    end
  end

  function Katarina:Jump(pos, range, useWard)
    for _,ally in pairs(GetAllyHeroes()) do
      if (GetDistance(ally, pos) <= range) then
        CastSpell(_E, ally)
        self.jumped = true
        return true
      end
    end
    for _,ally in pairs(GetEnemyHeroes()) do
      if (GetDistance(ally, pos) <= range) then
        CastSpell(_E, ally)
        self.jumped = true
        return true
      end
    end
    for minion,winion in pairs(minionManager(MINION_ALL, range, pos, MINION_SORT_HEALTH_ASC).objects) do
      if (GetDistance(winion, pos) <= range) then
        CastSpell(_E, winion)
        self.jumped = true
        return true
      end
    end
    table.sort(self.Wards, function(x,y) return GetDistance(x) < GetDistance(y) end)
    for i, ward in ipairs(self.Wards) do
      if (GetDistance(ward, pos) <= range) then
        CastSpell(_E, ward)
        self.jumped = true
        return true
      end
    end
  end

  function Katarina:CreateObj(obj)
    if obj ~= nil and obj.valid then
      if string.find(string.lower(obj.name), "ward") then
        table.insert(self.Wards, obj)
      end
    end
  end

  function Katarina:getMousePos(range)
    local MyPos = Vector(myHero.x, myHero.y, myHero.z)
    local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
    return MyPos - (MyPos - MousePos):normalized() * 700
  end

  function Katarina:GetWardSlot()
    for slot = ITEM_7, ITEM_1, -1 do
      if myHero:GetSpellData(slot).name and myHero:CanUseSpell(slot) == READY and (string.find(string.lower(myHero:GetSpellData(slot).name), "ward") or string.find(string.lower(myHero:GetSpellData(slot).name), "trinkettotem")) then
        return slot
      end
    end
    return nil
  end

  function Katarina:LastHit()
    if ultOn >= GetInGameTimer() and ultTarget and not ultTarget.dead or not self.Target then return end
    if Config:getParam("LastHit", "Q") and sReady[_Q] and GetDistance(self.Target) < data[0].range and self.Target.health < GetDmg(_Q, myHero, self.Target) then
      Cast(_Q, self.Target, true)
    end
    pos, b = PredictPos(self.Target,0.25)
    if pos and Config:getParam("LastHit", "W") and sReady[_W] and GetDistance(pos) < data[1].range+b/2 and self.Target.health < GetDmg(_W, myHero, self.Target) then
      Cast(_W)
    end
    if Config:getParam("LastHit", "E") and sReady[_E] and GetDistance(self.Target) < data[2].range and self.Target.health < GetDmg(_E, myHero, self.Target) then
      Cast(_E, self.Target, true)
    end
  end

  function Katarina:LaneClear()
    if ultOn >= GetInGameTimer() and ultTarget and not ultTarget.dead or not self.Target then return end
    if Config:getParam("LaneClear", "Q") and sReady[_Q] and GetDistance(self.Target) < data[0].range then
      Cast(_Q, self.Target, true)
    end
    pos, b = PredictPos(self.Target,0.25)
    if pos and Config:getParam("LaneClear", "W") and sReady[_W] and GetDistance(pos) < data[1].range+b/2 then
      Cast(_W)
    end
    if Config:getParam("LaneClear", "E") and sReady[_E] and GetDistance(self.Target) < data[2].range then
      Cast(_E, self.Target, true)
    end
  end

  function Katarina:Combo()
    if ultOn >= GetInGameTimer() and ultTarget and not ultTarget.dead or not self.Target then return end
    if Config:getParam("Combo", "Q") and sReady[_Q] and GetDistance(self.Target) < data[0].range then
      Cast(_Q, self.Target, true)
    end
    pos, b = PredictPos(self.Target,0.25)
    if pos and Config:getParam("Combo", "W") and sReady[_W] and GetDistance(pos) < data[1].range+b/2 then
      Cast(_W)
    end
    if Config:getParam("Combo", "E") and sReady[_E] and GetDistance(self.Target) < data[2].range then
      Cast(_E, self.Target, true)
    end
    if Config:getParam("Combo", "R") and sReady[_R] and GetDistance(self.Target) < 200 and self.Target.health < GetDmg(_R, myHero, self.Target)*10 then
      Cast(_R)
    end
  end

  function Katarina:Harrass()
    if ultOn >= GetInGameTimer() and ultTarget and not ultTarget.dead or not self.Target then return end
    if Config:getParam("Harrass", "Q") and sReady[_Q] and GetDistance(self.Target) < data[0].range then
      Cast(_Q, self.Target, true)
    end
    pos, b = PredictPos(self.Target,0.25)
    if pos and Config:getParam("Harrass", "W") and sReady[_W] and GetDistance(pos) < data[1].range+b/2 then
      Cast(_W)
    end
    if Config:getParam("Harrass", "E") and sReady[_E] and GetDistance(self.Target) < data[2].range then
      Cast(_E, self.Target, true)
    end
  end

  function Katarina:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead and GetDistance(enemy) < 700 then
        local dmg = 0
        for _,k in pairs({"Q","W","E"}) do
          if Config:getParam("Killsteal", k) and sReady[_-1] then
            dmg = dmg + GetDmg(_-1, myHero, enemy)
          end
        end
        if dmg+((sReady[_Q] and Config:getParam("Killsteal", "Q")) and myHero:CalcMagicDamage(enemy,15*myHero:GetSpellData(_Q).level+0.15*myHero.ap) or 0)+((myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0 and Config:getParam("Killsteal", "R")) and GetDmg(_R, myHero, enemy)*10 or 0) >= enemy.health then
          if Config:getParam("Killsteal", "Q") and sReady[_Q] then
            Cast(_Q, enemy, true)
            if Config:getParam("Killsteal", "E") and sReady[_E] then
              DelayAction(Cast, 0.25, {_E, enemy, true})
              if Config:getParam("Killsteal", "W") and sReady[_W] then
                DelayAction(function() Cast(_W) end, 0.5)
                if (Config:getParam("Killsteal", "R") and myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                  DelayAction(function() Cast(_R) end, 0.75)
                end
              end
            elseif Config:getParam("Killsteal", "W") and sReady[_W] then
              pos, b = PredictPos(enemy)
              if pos and GetDistance(pos) < data[1].range then
                DelayAction(function() Cast(_W) end, 0.25)
                if Config:getParam("Killsteal", "R") and (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                  DelayAction(function() Cast(_R) end, 0.5)
                end
              end
            end
          elseif Config:getParam("Killsteal", "E") and sReady[_E] then
            Cast(_E, enemy, true)
            if Config:getParam("Killsteal", "W") and sReady[_W] then
              DelayAction(function() Cast(_W) end, 0.25)
              if Config:getParam("Killsteal", "R") and (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                DelayAction(function() Cast(_R) end, 0.5)
              end
            end
          elseif Config:getParam("Killsteal", "W") and sReady[_W] then
            pos, b = PredictPos(enemy)
            if pos and GetDistance(pos) < data[1].range then
              Cast(_W)
              if Config:getParam("Killsteal", "R") and (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                DelayAction(function() Cast(_R) end, 0.25)
              end
            end
          elseif GetDistance(enemy) < 250 and Config:getParam("Killsteal", "R") and (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
            Cast(_R)
          end
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "KogMaw"
  
  function KogMaw:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGICAL, false, true)
    self:Menu()
    AddTickCallback(function() self:Tick() end)
  end

  function KogMaw:Tick()
    self.ts.range = 900+myHero:GetSpellData(_R).level*300
  end

  function KogMaw:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function KogMaw:LastHit()
    local minionTarget = GetLowestMinion(math.min(data[0].range, data[1].range()))
    if not minionTarget then return end
    if GetDmg(_Q, myHero, minionTarget) > minionTarget.health and myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      Cast(_Q, minionTarget, false, true, 2)
    elseif GetDmg(_W, myHero, minionTarget) > minionTarget.health and myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      Cast(_W, myHero:Attack(minionTarget))
    elseif GetDmg(_E, myHero, minionTarget) > minionTarget.health and myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      Cast(_E, minionTarget2, false, true, 2)
    end
  end

  function KogMaw:LaneClear()
    local minionTarget = GetLowestMinion(math.min(data[0].range, data[1].range()))
    if minionTarget then
      if Config:getParam("LaneClear", "Q") and myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        Cast(_Q, minionTarget, false, true, 2)
      end
      if Config:getParam("LaneClear", "W") and myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
        Cast(_W, myHero:Attack(minionTarget))
      end
    end
    minionTarget = GetLineFarmPosition(data[2].range, data[2].width)
    if minionTarget then
      if Config:getParam("LaneClear", "E") and myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
        Cast(_E, minionTarget, false, true, 2)
      end
    end
  end

  function KogMaw:Combo()
    if Config:getParam("Combo", "Q") and myHero:CanUseSpell(_Q) == READY then
      Cast(_Q, Target, false, true, 2)
    end
    if Config:getParam("Combo", "W") and myHero:CanUseSpell(_W) == READY then
      Cast(_W, myHero:Attack(Target))
    end
    if Config:getParam("Combo", "E") and myHero:CanUseSpell(_E) == READY then
      Cast(_E, Target, false, true, 2)
    end
    if Config:getParam("Combo", "R") and myHero:CanUseSpell(_R) == READY then
      Cast(_R, Target, false, true, 2)
    end
  end

  function KogMaw:Harrass()
    if Config:getParam("Harrass", "Q") and myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      Cast(_Q, Target, false, true, 2)
    end
    if Config:getParam("Harrass", "W") and myHero:CanUseSpell(_W) == READY and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      Cast(_W, myHero:Attack(Target))
    end
    if Config:getParam("Harrass", "E") and myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      Cast(_E, Target, false, true, 2)
    end
  end

  function KogMaw:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
          DelayAction(function() Cast(_E, enemy, false, true, 1.2) end, data[2].delay)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_R) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_E, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
          DelayAction(function() Cast(_Q, enemy, false, true, 1.2) DelayAction(function() Cast(_R, enemy, false, true, 1.2) end, data[0].delay) end, data[2].delay)
        elseif myHero:CanUseSpell(_R) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
          DelayAction(function() Cast(_R, enemy, false, true, 1.2) end, data[2].delay)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
          DelayAction(function() Cast(_R, enemy, false, true, 1.2) end, data[0].delay)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, false, true, 2)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "LeeSin"

  function LeeSin:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
    self.Forcetarget = nil
    self.insecTarget = nil
    self.Wards = {}
    self.casted, self.jumped = false, false
    self.oldPos = nil
    for i = 1, objManager.maxObjects do
      local object = objManager:GetObject(i)
      if object ~= nil and object.valid and string.find(string.lower(object.name), "ward") then
        table.insert(self.Wards, object)
      end
    end
    AddTickCallback(function() self:InsecTicker() end)
    AddProcessSpellCallback(function(unit, spell) self:ProcessSpell(unit, spell) end)
    AddCreateObjCallback(function(obj) self:CreateObj(obj) end)
    AddMsgCallback(function(x,y) self:Msg(x,y) end)
  end

  function LeeSin:Menu()
    for _,s in pairs({"Combo", "Harrass", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    --for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
    --  Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    --end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Misc", name = "Insec", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Misc", name = "Jump", key = string.byte("G"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function LeeSin:InsecTicker()
    if Config:getParam("Misc", "Insec") then
      self:Insec()
    end
    if Config:getParam("Misc", "Jump") then
      self:WardJump()
    end
  end

  function LeeSin:Insec()
    if myHero:GetSpellData(_R).currentCd ~= 0 then return end
    self.insecTarget = self.Forcetarget or Target
    if self.insecTarget == nil then if GetDistance(mousePos,myHero.pos) > myHero.boundingRadius then myHero:MoveTo(mousePos.x, mousePos.z) end return end
    local insecTowards = nil
    if #GetAllyHeroes() > 0 then
      for _,unit in pairs(GetAllyHeroes()) do
        if GetDistance(unit,insecTarget) < 2000 then
          insecTowards = unit
        end
      end
    end
    if insecTowards == nil or _G.LeftMousDown then
      insecTowards = mousePos
    else
      return
    end
    CastPosition = insecTowards
    if GetDistance(insecTowards, mousePos) > 50 then
      CastPosition, HitChance, Position = UPL:Predict(_R, myHero, insecTowards)
    end
    CastPosition1 = Vector(self.insecTarget)-300*(Vector(CastPosition)-Vector(self.insecTarget)):normalized()
    myHero:MoveTo(CastPosition1.x, CastPosition1.z)
    local x, y, z = VectorPointProjectionOnLineSegment(myHero, CastPosition, self.insecTarget)
    if GetDistance(myHero, CastPosition1) < 25 and z then
      if myHero:CanUseSpell(_Q) then 
        Cast(_Q, self.insecTarget)
        DelayAction(function() Cast(_R, self.insecTarget, true) DelayAction(function() Cast(_Q) end, 0.33) end, data[0].delay+GetDistance(self.insecTarget, myHero.pos)/data[0].speed)
      else
        Cast(_R, self.insecTarget, true)
      end
    end
    if GetDistance(CastPosition1) > 300 and GetDistance(CastPosition1) < 600 then
      if self:Jump(CastPosition1, 50, true) then return end
      slot = self:GetWardSlot()
      if not slot then return end
      CastSpell(slot, CastPosition1.x, CastPosition1.z)
    end
  end

  function LeeSin:Msg(Msg, Key)
    if Msg == WM_LBUTTONDOWN then 
      _G.LeftMousDown = true
    elseif Msg == WM_LBUTTONUP then
      _G.LeftMousDown = false
    end
    if Msg == WM_LBUTTONDOWN then
      local minD = 0
      local starget = nil
      for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
          if GetDistance(enemy, mousePos) <= minD or starget == nil then
            minD = GetDistance(enemy, mousePos)
            starget = enemy
          end
        end
      end
      if starget and minD < 500 then
        if self.Forcetarget and starget.charName == self.Forcetarget.charName then
          self.Forcetarget = nil
          ScriptologyMsg("Insec-target un-selected.")
        else
          self.Forcetarget = starget
          ScriptologyMsg("New insec-target selected: "..starget.charName.."")
        end
      end
    end
  end

  function LeeSin:ProcessSpell(unit, spell)  
    if unit == myHero then
      if string.find(string.lower(spell.name), "attack") then
        self.lastWindup = GetInGameTimer()+spell.windUpTime
      end
    end
  end

  function LeeSin:WardJump()
    if self.casted and self.jumped then self.casted, self.jumped = false, false
    elseif myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
      local pos = self:getMousePos()
      if self:Jump(pos, 150, true) then return end
      slot = self:GetWardSlot()
      if not slot then return end
      CastSpell(slot, pos.x, pos.z)
    end
  end

  function LeeSin:Jump(pos, range, useWard)
    for _,ally in pairs(GetAllyHeroes()) do
      if (GetDistance(ally, pos) <= range) then
        CastSpell(_W, ally)
        self.jumped = true
        return true
      end
    end
    for minion,winion in pairs(minionManager(MINION_ALLY, range, pos, MINION_SORT_HEALTH_ASC).objects) do
      if (GetDistance(winion, pos) <= range) then
        CastSpell(_W, winion)
        self.jumped = true
        return true
      end
    end
    table.sort(self.Wards, function(x,y) return GetDistance(x) < GetDistance(y) end)
    for i, ward in ipairs(self.Wards) do
      if (GetDistance(ward, pos) <= range) then
        CastSpell(_W, ward)
        self.jumped = true
        return true
      end
    end
  end

  function LeeSin:CreateObj(obj)
    if obj ~= nil and obj.valid then
      if string.find(string.lower(obj.name), "ward") then
        table.insert(self.Wards, obj)
      end
    end
  end

  function LeeSin:getMousePos(range)
    local MyPos = Vector(myHero.x, myHero.y, myHero.z)
    local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
    return MyPos - (MyPos - MousePos):normalized() * 600
  end

  function LeeSin:GetWardSlot()
    for slot = ITEM_7, ITEM_1, -1 do
      if myHero:GetSpellData(slot).name and myHero:CanUseSpell(slot) == READY and (string.find(string.lower(myHero:GetSpellData(slot).name), "ward") or string.find(string.lower(myHero:GetSpellData(slot).name), "trinkettotem")) then
        return slot
      end
    end
    return nil
  end

  function LeeSin:QDmg(unit)
    return GetDmg(_Q, myHero, unit)+GetDmg(_Q, myHero, unit)+myHero:CalcDamage(unit,(unit.maxHealth-unit.health)*0.08)
  end

  function LeeSin:LastHit()
    if ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q")) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q"))) and myHero:CanUseSpell(_Q) == READY then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg1 = GetDmg(_Q, myHero, winion)
        local MinionDmg2 = self:QDmg(winion)
        if MinionDmg1 and MinionDmg1 >= winion.health+winion.shield and ValidTarget(winion, 1100) then
          Cast(_Q, winion, false, true, 1.5)
        elseif MinionDmg2 and MinionDmg1 and MinionDmg1+MinionDmg2 >= winion.health+winion.shield and ValidTarget(winion, 1100) then
          Cast(_Q, winion, false, true, 1.5)
          DelayAction(Cast, 0.33, {_Q})
        elseif MinionDmg2 and MinionDmg2 >= winion.health+winion.shield and ValidTarget(winion, 250) and GetDistance(winion) < 250 then
          DelayAction(Cast, 0.33, {_Q})
        end
      end
    end
    if ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E")) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E"))) and myHero:CanUseSpell(_W) == READY then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_E, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health+winion.shield and ValidTarget(winion, 300) then
          Cast(_E)
        end
      end
    end
  end

  function LeeSin:LaneClear()
    if Config:getParam("LaneClear", "Q") and myHero:CanUseSpell(_Q) == READY then
      local minionTarget = nil
      for i, minion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = minion
        elseif minionTarget.health+minionTarget.shield >= minion.health+minion.shield and ValidTarget(minion, 1100) then
          minionTarget = minion
        end
      end
      if minionTarget ~= nil then
        Cast(_Q, minionTarget, false, true, 1.5)
      end
      for i, minion in pairs(JMobs.objects) do
        if minionTarget == nil then 
          minionTarget = minion
        elseif minionTarget.maxHealth < minion.maxHealth and GetDistance(minion) < 1100 then
          minionTarget = minion
        end
      end
      if minionTarget ~= nil then
        Cast(_Q, minionTarget, false, true, 1.5)
      end
    end
    if Config:getParam("LaneClear", "E") and myHero:CanUseSpell(_E) == READY then
      BestPos, BestHit = GetFarmPosition(data[2].range, data[2].width)
      if BestHit > 1 and GetDistance(BestPos) < 150 then 
        Cast(_E)
      end
      for i, minion in pairs(JMobs.objects) do
        if minionTarget == nil then 
          minionTarget = minion
        elseif minionTarget.maxHealth < minion.maxHealth and GetDistance(minion) < 350 then
          minionTarget = minion
        end
      end
      if minionTarget ~= nil then
        Cast(_E, minionTarget, false, true, 1.2)
      end
    end
  end

  function LeeSin:Combo()
    if myHero:CanUseSpell(_E) == READY and ValidTarget(Target, 400) and self:IsFirstCast(_E) then
      Cast(_E, Target, false, true, 1.2)
    end
    if Target.health < GetDmg(_Q, myHero, Target)+GetDmg(_R, myHero, Target)+(Target.maxHealth-(Target.health-GetDmg(_R, myHero, Target)*0.08)) then
      if myHero:CanUseSpell(_Q) == READY and self:IsFirstCast(_Q) then
        Cast(_Q, Target, false, true, 1.5)
      elseif myHero:CanUseSpell(_Q) == READY and GetStacks(Target) > 0 then
        Cast(_R, Target)
        DelayAction(Cast, 0.33, {_Q})
      end
    elseif myHero:CanUseSpell(_Q) == READY and self:IsFirstCast(_Q) then
      Cast(_Q, Target, false, true, 1.5)
    elseif Target ~= nil and GetStacks(Target) > 0 and GetDistance(Target) > myHero.range+myHero.boundingRadius*2 then
      Cast(_Q)
    end
  end

  function LeeSin:IsFirstCast(x)
    if string.find(myHero:GetSpellData(x).name, 'One') then
        return true
    else
        return false
    end
  end

  function LeeSin:Harrass()
    if myHero:CanUseSpell(_Q) == READY and self:IsFirstCast(_Q) then
      Cast(_Q, Target, false, true, 1.5)
    end
    if not self.oldPos and GetStacks(Target) and myHero:CanUseSpell(_W) == READY and self:IsFirstCast(_W) then
      self.oldPos = myHero
      Cast(_Q)
    end
    if self.oldPos and GetDistance(Target) < 250 and myHero:CanUseSpell(_W) == READY and self:IsFirstCast(_W) then
      for _,winion in pairs(minionManager(MINION_ALLY, 450, self.oldPos, MINION_SORT_HEALTH_ASC).objects) do
        if GetDistance(self.oldPos) < GetDistance(winion) and GetDistance(winion) < 600 then
          self.oldPos = winion
        end
      end
      DelayAction(function() self:Jump(self.oldPos, 400, false) self.oldPos = nil end, 0.33)
    end
    if myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].width) then
      Cast(_E, Target, false, true, 1.2)
    end
  end

  function LeeSin:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+self:QDmg(enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
          DelayAction(function() if not self:IsFirstCast(_Q) then Cast(_Q) end end, data[0].delay+GetDistance(enemy, myHero.pos)/data[0].speed)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].width) then
          Cast(_E, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, myHero.range+myHero.boundingRadius) then
          Cast(_R, enemy, true)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Lux"

  function Lux:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
    AddTickCallback(function() self:DetonateE() end)
    AddProcessSpellCallback(function(x,y) self:ShieldManager(x,y) end)
  end

  function Lux:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","E"}, slider = {50,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Lux:DetonateE()
    if myHero:GetSpellData(_E).name == "luxlightstriketoggle" and Config:getParam("Misc", "Ea") then
      Cast(_E)
    end
  end

  function Lux:ShieldManager(unit, spell)
    if not unit.isMe and unit.team ~= myHero.team and not IsRecalling(myHero) and Config:getParam("Misc", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      if spell.target and spell.target.isMe then
        if Config:getParam("Misc", "Wa") and myHero:CanUseSpell(_W) == READY and myHero.health/myHero.maxHealth < 0.85 then
          Cast(_W, myHero)
        end
      elseif GetDistance(spell.endPos) < GetDistance(myHero.pos, myHero.minBBox) then
        if Config:getParam("Misc", "Wa") and myHero:CanUseSpell(_W) == READY and myHero.health/myHero.maxHealth < 0.85 then
          Cast(_W, myHero)
        end
      end
    end
  end

  function Lux:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for i, minion in pairs(minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC).objects) do
        local QMinionDmg = GetDmg(_Q, myHero, minion)
        if QMinionDmg >= minion.health and ValidTarget(minion, data[0].range) then
          Cast(_Q, winion, false, true, 2)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      for i, minion in pairs(minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC).objects) do
        local EMinionDmg = GetDmg(_E, myHero, minion)
        if EMinionDmg >= minion.health and ValidTarget(minion, data[2].range) then
          Cast(_E, winion, true)
        end
      end
    end 
  end

  function Lux:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = GetLowestMinion(data[_Q].range)
      if minionTarget ~= nil then
        Cast(_Q, minionTarget)
      end
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetFarmPosition(data[_E].range, data[_E].width)
      if BestHit > 1 then 
        Cast(_E, BestPos)
      end
    end  
  end

  function Lux:Combo()
    if GetStacks(Target) > 0 and Config:getParam("Combo", "R") and myHero:CanUseSpell(_R) == READY and myHero:CalcMagicDamage(Target, 200+150*myHero:GetSpellData(_R).level+0.75*myHero.ap) >= Target.health then
      Cast(_R, Target, false, true, 2)
    end
    if timeToShoot() then
      if Config:getParam("Combo", "Q") and myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_E) ~= READY then
        Cast(_Q, Target, false, true, 2)
      end
      if Config:getParam("Combo", "E") and myHero:CanUseSpell(_E) == READY then
        Cast(_E, Target, false, true, 1.5)
      end
      if Config:getParam("Combo", "R") and myHero:CanUseSpell(_R) == READY and GetDmg(_R, myHero, Target) >= Target.health then
        Cast(_R, Target, false, true, 2)
      end
    end
  end

  function Lux:Harrass()
    if GetStacks(Target) == 0 then
      if Config:getParam("Harrass", "Q") and myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        Cast(_Q, Target, false, true, 2)
      end
      if Config:getParam("Harrass", "E") and myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
        Cast(_E, Target, false, true, 1.5)
      end
    end
  end

  function Lux:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
          DelayAction(function() Cast(_E, enemy, false, true, 1.2) end, data[2].delay)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_R) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_E, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
          DelayAction(function() Cast(_Q, enemy, false, true, 1.2) DelayAction(function() Cast(_R, enemy, false, true, 1.2) end, data[0].delay) end, data[2].delay)
        elseif myHero:CanUseSpell(_R) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.2)
          DelayAction(function() Cast(_R, enemy, false, true, 1.2) end, data[2].delay)
        elseif myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
          DelayAction(function() Cast(_R, enemy, false, true, 1.2) end, data[0].delay)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, false, true, 2)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Malzahar"

  function Malzahar:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGICAL, false, true)
    self:Menu()
    AddTickCallback(function() self:OrbWalk() end)
  end

  function Malzahar:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Harrass", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {30,30,30}})
    for _,s in pairs({"LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {65,50,30}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Malzahar:OrbWalk()
    if (Config:getParam("Harrass", "Harrass") or Config:getParam("Combo", "Combo") or Config:getParam("LastHit", "LastHit") or Config:getParam("LaneClear", "LaneClear")) and heroCanMove() and GetDistance(mousePos, myHero.pos) > myHero.boundingRadius then
      myHero:MoveTo(mousePos.x, mousePos.z)
    end
  end

  function Malzahar:LastHit()
    if timeToShoot() then
      if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
        for i, minion in pairs(minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC).objects) do
          local QMinionDmg = GetDmg(_Q, myHero, minion)
          if QMinionDmg >= minion.health and ValidTarget(minion, data[0].range) then
            Cast(_Q, minion, false, true, 1.2)
          end
        end
      end
      if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then    
        for i, minion in pairs(minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC).objects) do    
          local WMinionDmg = GetDmg(_W, myHero, minion)      
          if WMinionDmg >= minion.health and ValidTarget(minion, data[1].range) then
            Cast(_W, minion, false, true, 1.5)
          end      
        end    
      end  
      if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
        for i, minion in pairs(minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC).objects) do
          local EMinionDmg = GetDmg(_E, myHero, minion)
          if EMinionDmg >= minion.health and ValidTarget(minion, data[2].range) then
            Cast(_E, minion, true)
          end
        end
      end 
    end
    if timeToShoot() then
      minionTarget = GetLowestMinion(myHero.range+myHero.boundingRadius)
      if minionTarget ~= nil and minionTarget.health < GetDmg("AD", myHero, minionTarget) and GetDistance(minionTarget)<myHero.range+myHero.boundingRadius*2 then
        myHero:Attack(minionTarget)
      end
    end
  end

  function Malzahar:LaneClear()
    if timeToShoot() then
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        local minionTarget = GetLowestMinion(data[0].range)
        if minionTarget ~= nil then
          Cast(_Q, minionTarget, false, true, 1.2)
        end
      end
      if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
        BestPos, BestHit = GetFarmPosition(data[_W].range, data[_W].width)
        if BestHit > 1 then 
          Cast(_W, BestPos)
        end
      end  
      if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
        local minionTarget = GetLowestMinion(data[2].range)
        if minionTarget ~= nil then
          Cast(_E, minionTarget, true)
        end
      end 
    end 
    if timeToShoot() then
      minionTarget = GetLowestMinion(myHero.range+myHero.boundingRadius)
      if minionTarget ~= nil and GetDistance(minionTarget)<myHero.range+myHero.boundingRadius*2 then
        myHero:Attack(minionTarget)
      end
    end
  end

  function Malzahar:Combo()
    if timeToShoot() then
      if Config:getParam("Combo", "Q") and myHero:CanUseSpell(_Q) == READY then
        Cast(_Q, Target, false, true, 1.5)
      end
      if Config:getParam("Combo", "W") and myHero:CanUseSpell(_W) == READY then
        Cast(_W, Target, false, true, 1.5)
      end
      if Config:getParam("Combo", "E") and myHero:CanUseSpell(_E) == READY then
        Cast(_E, Target, true)
      end
      if Config:getParam("Combo", "R") and myHero:CanUseSpell(_R) == READY then
        Cast(_R, Target, true)
      end
    end
    if timeToShoot() and GetDistance(Target) < myHero.range+myHero.boundingRadius*2 then
      myHero:Attack(Target)
    end
  end

  function Malzahar:Harrass()
    if timeToShoot() then
      if Config:getParam("Combo", "Q") and myHero:CanUseSpell(_Q) == READY then
        Cast(_Q, Target, false, true, 1.5)
      end
      if Config:getParam("Combo", "W") and myHero:CanUseSpell(_W) == READY then
        Cast(_W, Target, false, true, 1.5)
      end
      if Config:getParam("Combo", "E") and myHero:CanUseSpell(_E) == READY then
        Cast(_W, Target, true)
      end
    end
    if timeToShoot() and GetDistance(Target) < myHero.range+myHero.boundingRadius*2 then
      myHero:Attack(Target)
    end
  end

  function Malzahar:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy)*2.5 and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, true)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Nidalee"

  function Nidalee:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.data = {
      Human  = {
          [_Q] = { speed = 1337, delay = 0.125, range = 1500, width = 25, collision = true, aoe = false, type = "linear"},
          [_W] = { range = 900},
          [_E] = { range = 600}
        },
      Cougar = {
          [_W] = { range = 350, width = 175},
          [_E] = { range = 350}}
    }
    self.ludenStacks = 0
    self.spearCooldownUntil = 0
    AddDrawCallback(function() self:Draw() end)
    AddTickCallback(function() self:Heal() end)
    AddTickCallback(function() self:DmgCalc() end)
    AddUpdateBuffCallback(function(unit, buff, stacks) self:UpdateBuff(unit, buff, stacks) end)
    AddProcessSpellCallback(function(unit, spell) self:ProcessSpell(unit, spell) end)
    AddTickCallback(function() self:Flee() end)
  end

  function Nidalee:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Harrass", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q"}, slider = {50}})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Combo", name = "Flee", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Nidalee:UpdateBuff(unit, buff, stacks)
    if unit and unit.isMe and buff and buff.name and buff.name == "itemmagicshankcharge" then self.ludenStacks = stacks end
  end

  function Nidalee:RemoveBuff(unit, buff)
    if unit and unit.isMe and buff and buff.name and buff.name == "itemmagicshankcharge" then self.ludenStacks = 0 end
  end

  function Nidalee:ProcessSpell(unit, spell)
    if unit and unit.isMe and spell and spell.name and spell.name == "JavelinToss" then self.spearCooldownUntil = GetInGameTimer()+6*(1+unit.cdr) end
  end

  function Nidalee:Heal()
    if not IsRecalling(myHero) and self:IsHuman() and Config:getParam("Misc", "Ea") and Config:getParam("Misc", "mana", "E") <= myHero.mana/myHero.maxMana*100 and myHero.maxHealth-myHero.health > 5+40*myHero:GetSpellData(_E).level+0.5*myHero.ap then
      Cast(_E, myHero, true)
    end
    if not IsRecalling(myHero) and self:IsHuman() and Config:getParam("Misc", "Ea") and Config:getParam("Misc", "mana", "E") <= myHero.mana/myHero.maxMana*100 then
      for _,k in pairs(GetAllyHeroes()) do
        if GetDistance(k) < self.data.Human[2].range and k.maxHealth-k.health < 5+40*myHero:GetSpellData(_E).level+0.5*myHero.ap and k.health/k.maxHealth <= 0.35 then
          Cast(_E, k, true)
        end
      end
    end
  end

  function Nidalee:Flee()
    if Config:getParam("Combo", "Flee") then
      if self:IsHuman() then
        Cast(_R)
      else
        Cast(_W, mousePos)
        myHero:MoveTo(mousePos.x, mousePos.z)
      end
    end
  end

  function Nidalee:IsHuman()
    return myHero:GetSpellData(_Q).name == "JavelinToss"
  end

  function Nidalee:GetAARange()
    return myHero.range+myHero.boundingRadius*2
  end

  function Nidalee:getMousePos()
    local MyPos = Vector(myHero.x, myHero.y, myHero.z)
    local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
    return MyPos - (MyPos - MousePos):normalized() * self.data.Cougar[1].range
  end

  function Nidalee:Draw()
    if self:IsHuman() then
      if Config:getParam("Draws", "Q") and myHero:CanUseSpell(_Q) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, self.data.Human[0].range, ARGB(255, 155, 155, 155))
      end
      if Config:getParam("Draws", "W") and myHero:CanUseSpell(_W) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, self.data.Human[1].range, ARGB(255, 155, 155, 155))
      end
      if Config:getParam("Draws", "E") and myHero:CanUseSpell(_E) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, self.data.Human[2].range, ARGB(255, 155, 155, 155))
      end
    else
      if Config:getParam("Draws", "Q") and myHero:CanUseSpell(_Q) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, self:GetAARange(), ARGB(255, 155, 155, 155))
      end
      if Config:getParam("Draws", "W") and myHero:CanUseSpell(_W) == READY then
        local drawPos = self:getMousePos()
        local barPos = WorldToScreen(D3DXVECTOR3(drawPos.x, drawPos.y, drawPos.z))
        DrawLFC(drawPos.x, drawPos.y, drawPos.z, self.data.Cougar[1].width, IsWall(D3DXVECTOR3(drawPos.x, drawPos.y, drawPos.z)) and ARGB(255,255,0,0) or ARGB(255, 155, 155, 155))
        DrawLFC(drawPos.x, drawPos.y, drawPos.z, self.data.Cougar[1].width/3, IsWall(D3DXVECTOR3(drawPos.x, drawPos.y, drawPos.z)) and ARGB(255,255,0,0) or ARGB(255, 155, 155, 155))
        DrawText("W Jump", 15, barPos.x, barPos.y, ARGB(255, 155, 155, 155))
      end
      if Config:getParam("Draws", "E") and myHero:CanUseSpell(_E) == READY then
        DrawLFC(myHero.x, myHero.y, myHero.z, self.data.Cougar[2].range, ARGB(255, 155, 155, 155))
      end
    end
    if Config:getParam("Draws", "DMG") then
      for i,k in pairs(GetEnemyHeroes()) do
        local enemy = k
        if ValidTarget(enemy) then
          local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
          local posX = barPos.x - 35
          local posY = barPos.y - 50
          DrawText(killTextTable[enemy.networkID].indicatorText, 18, posX, posY, ARGB(255, 150, 255, 150))
          DrawText(killTextTable[enemy.networkID].damageGettingText, 15, posX, posY + 15, ARGB(255, 255, 50, 50))
        end
      end
    end
  end

  function Nidalee:DmgCalc()
    if not Config:getParam("Draws", "DMG") then return end
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy.visible then
        killTextTable[enemy.networkID].indicatorText = ""
        local damageAA = self:GetDmg("AD", enemy)
        local damageQ  = self:GetDmg(_Q, enemy, true)+self:GetDmg("Ludens", enemy)
        local damageC  = self:GetRWEQComboDmg(enemy)
        local damageI  = Ignite and (GetDmg("IGNITE", myHero, enemy)) or 0
        local damageS  = Smite and (20 + 8 * myHero.level) or 0
        if myHero:CanUseSpell(_Q) == READY and damageQ > 0 then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."Q"
        end
        if myHero:CanUseSpell(_R) == READY and damageC > 0 then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."RWEQ"
        end
        if enemy.health < damageQ+damageC then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.." Killable"
        else
          local neededAA = math.floor(100 * (damageQ+damageC+damageI) / (enemy.health))
          killTextTable[enemy.networkID].indicatorText = neededAA.."% Combo dmg"
        end
        local enemyDamageAA = GetDmg("AD", enemy, myHero)
        local enemyNeededAA = not enemyDamageAA and 0 or math.ceil(myHero.health / enemyDamageAA)   
        if enemyNeededAA ~= 0 then         
          killTextTable[enemy.networkID].damageGettingText = enemy.charName .. " kills me with " .. enemyNeededAA .. " hits"
        end
      end
    end
  end

  function Nidalee:Combo()
    if myHero:CanUseSpell(_Q) == READY and self:IsHuman() and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, false, true, 1.5)
    end
    self:DoRWEQCombo(Target)
    if not self:IsHuman() and GetDistance(Target) > 425 then
      Cast(_R)
    end
    if not self:IsHuman() and self.spearCooldownUntil < GetInGameTimer() then
      Cast(_R)
    end
  end

  function Nidalee:DoRWEQCombo(unit)
    if not unit then return end
    if unit and myHero:CanUseSpell(_R) == READY and GetStacks(unit) > 0 and self:IsHuman() and GetDistance(unit)-self.data.Cougar[1].range*2 < 0 and Config:getParam("Combo", "R") then
      Cast(_R)
    end
    if unit and myHero:CanUseSpell(_W) == READY and GetStacks(unit) > 0 and not self:IsHuman() and GetDistance(unit)-self.data.Cougar[2].range > 0 and Config:getParam("Combo", "W") then
      Cast(_W, unit)
    end
    if unit and not self:IsHuman() and GetDistance(unit)-self.data.Cougar[2].range <= 0 then
      if unit and self:GetDmg(_Q,unit) >= unit.health and myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and not Config:getParam("Combo", "E") then
          CastSpell(_Q, myHero:Attack(unit))
      elseif unit and self:GetRWEQComboDmg(unit,-self:GetDmg(_W,unit)) >= unit.health then
        if unit and myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") then
          Cast(_E, unit)
        end
        if unit and myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_E) ~= READY and Config:getParam("Combo", "Q") and Config:getParam("Combo", "E") then
          CastSpell(_Q, myHero:Attack(unit))
        end
        if unit and myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and not Config:getParam("Combo", "E") then
          CastSpell(_Q, myHero:Attack(unit))
        end
      elseif unit then
        if unit and myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") then
          Cast(_E, unit)
        end
        if unit and myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") then
          CastSpell(_Q, myHero:Attack(unit))
        end
      end
      if unit and myHero:CanUseSpell(_W) == READY and Config:getParam("Combo", "W") then
        if unit and GetDistance(unit) >= self.data.Cougar[1].range-self.data.Cougar[1].width and GetDistance(unit) <= self.data.Cougar[1].range+self.data.Cougar[1].width then
          Cast(_W, unit)
        end
      end
    end
  end

  function Nidalee:GetRWEQComboDmg(target,damage)
    if not target then return end
    local unit = {pos = target.pos, armor = target.armor, magicArmor = target.magicArmor, maxHealth = target.maxHealth, health = target.health}
    local dmg = damage or 0
    if myHero:CanUseSpell(_W) == READY then
      dmg = dmg + self:GetDmg(_W,unit)
    end
    if myHero:CanUseSpell(_E) == READY then
      dmg = dmg + self:GetDmg(_E,unit)
    end
    if myHero:CanUseSpell(_Q) == READY then
      unit.health = unit.health-dmg
      dmg = dmg + self:GetDmg(_Q,unit)+self:GetDmg("Lichbane", unit)
    end
    return dmg
  end

  function Nidalee:Harrass()
    if self:IsHuman() then
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, self.data.Human[0].range) then
        Cast(_Q, Target, false, true, 2)
      end
    else
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, self:GetAARange()) then
        CastSpell(_Q, myHero:Attack(Target))
      end
      if myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "E") and ValidTarget(Target, self.data.Cougar[2].range) then
        Cast(_E, Target)
      end
    end
  end

  function Nidalee:LastHit()
    if not self:IsHuman() then
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("LastHit", "Q") and ValidTarget(Target, data[0].range) then
        local minionTarget = GetLowestMinion(self:GetAARange())
        if minionTarget and minionTarget.health < self:GetDmg(_Q, minionTarget) then
          Cast(_Q, myHero:Attack(minionTarget))
        end
      end
    end
  end

  function Nidalee:LaneClear()
    if not self:IsHuman() then
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") then
        local minionTarget = GetLowestMinion(self:GetAARange())
        if minionTarget and minionTarget.health < self:GetDmg(_Q, minionTarget) then
          Cast(_Q, myHero:Attack(minionTarget))
        end
        minionTarget = GetJMinion(self:GetAARange())
        if minionTarget then
          Cast(_Q, myHero:Attack(minionTarget))
        end
      end
      if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") then
        local pos, hit = GetFarmPosition(self.data.Cougar[1].range, self.data.Cougar[1].width)
        if pos and GetDistance(pos) >= self.data.Cougar[1].range-self.data.Cougar[1].width and GetDistance(pos) <= self.data.Cougar[1].range+self.data.Cougar[1].width and hit > 0 then
          Cast(_W, pos)
        end
        local pos, hit = GetJFarmPosition(self.data.Cougar[1].range, self.data.Cougar[1].width)
        if pos and GetDistance(pos) >= self.data.Cougar[1].range-self.data.Cougar[1].width and GetDistance(pos) <= self.data.Cougar[1].range+self.data.Cougar[1].width and hit > 0 then
          Cast(_W, pos)
        end
      end
      if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") then
        local pos, hit = GetFarmPosition(self.data.Cougar[2].range, self.data.Cougar[2].range/2)
        if pos and hit > 0 then
          Cast(_E, pos)
        end
        local pos, hit = GetJFarmPosition(self.data.Cougar[2].range, self.data.Cougar[2].range/2)
        if pos and hit > 0 then
          Cast(_E, pos)
        end
      end
    end
  end

  function Nidalee:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and self:IsHuman() and enemy.health < self:GetDmg(_Q, enemy, true)+self:GetDmg("Ludens", enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, self.data.Human[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
        if myHero:CanUseSpell(_Q) == READY and not self:IsHuman() and enemy.health < self:GetDmg(_Q, enemy, true) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, self.data.Human[0].range) then
          local pos, chance, ppos = UPL:Predict(_Q, myHero, enemy)
          if chance >= 2 then
            Cast(_R)
            DelayAction(function() Cast(_Q, enemy, false, true, 1.5) end, 0.125)
          end
        end
        if not self:IsHuman() and EnemiesAround(enemy, 500) < 3 then
          if myHero:CanUseSpell(_Q) == READY and enemy.health < self:GetDmg(_Q, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, self:GetAARange()) then
            Cast(_Q, myHero:Attack(enemy))
          end
          if myHero:CanUseSpell(_W) == READY and enemy.health < self:GetDmg(_W, enemy) and Config:getParam("Killsteal", "W") then
            if GetDistance(enemy) >= self.data.Cougar[1].range-self.data.Cougar[1].width and GetDistance(enemy) <= self.data.Cougar[1].range+self.data.Cougar[1].width then
              Cast(_W, enemy)
            end
          end
          if myHero:CanUseSpell(_E) == READY and enemy.health < self:GetDmg(_E, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, self.data.Cougar[2].range) then
            Cast(_E, enemy)
          end
        end
        if myHero:CanUseSpell(_Q) == READY and EnemiesAround(enemy, 500) < 3 and self:IsHuman() and enemy.health < self:GetRWEQComboDmg(enemy,self:GetDmg(_Q, enemy, true)+self:GetDmg("Ludens", enemy)) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "W") and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, self.data.Cougar[1].range/2) then
          Cast(_Q, enemy, false, true, 1.2)
          DelayAction(function() self:DoRWEQCombo(enemy) end, 0.05+self.data.Human[0].delay+GetDistance(enemy)/self.data.Human[0].speed)
        end
        if myHero:CanUseSpell(_Q) == READY and EnemiesAround(enemy, 500) < 3 and not self:IsHuman() and enemy.health < self:GetRWEQComboDmg(enemy,self:GetDmg(_Q, enemy, true)+self:GetDmg("Ludens", enemy)) and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "W") and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "R") and ValidTarget(enemy, self.data.Cougar[1].range/2) then
          Cast(_R)
        end
        if GetStacks(enemy) > 0 and EnemiesAround(enemy, 500) < 3 and GetDistance(enemy)-self.data.Cougar[1].range*2 < 0 then
          if enemy.health < self:GetRWEQComboDmg(enemy,0) then
            self:DoRWEQCombo(enemy)
          end
        end
      end
    end
  end

  function Nidalee:GetDmg(spell, target, human)
    if target == nil then
      return
    end
    local source           = myHero
    local ADDmg            = 0
    local APDmg            = 0
    local AP               = source.ap
    local Level            = source.level
    local TotalDmg         = source.totalDamage
    local ArmorPen         = math.floor(source.armorPen)
    local ArmorPenPercent  = math.floor(source.armorPenPercent*100)/100
    local MagicPen         = math.floor(source.magicPen)
    local MagicPenPercent  = math.floor(source.magicPenPercent*100)/100

    local Armor        = target.armor*ArmorPenPercent-ArmorPen
    local ArmorPercent = Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    local MagicArmor   = target.magicArmor*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and math.floor(MagicArmor*100/(100+MagicArmor))/100 or math.ceil(MagicArmor*100/(100-MagicArmor))/100

    local QLevel, WLevel, ELevel, RLevel = source:GetSpellData(_Q).level, source:GetSpellData(_W).level, source:GetSpellData(_E).level, source:GetSpellData(_R).level
    if source ~= myHero then
      return TotalDmg*(1-ArmorPercent)
    end
    if spell == "IGNITE" then
      return 50+20*Level/2
    elseif spell == "AD" then
      ADDmg = TotalDmg
    elseif spell == "Ludens" then
      APDmg = self.ludenStacks >= 90 and 100+0.1*AP or 0
    elseif spell == "Lichbane" then
      APDmg = (GetLichSlot() and source.damage*0.75+0.5*AP or 0)
    elseif human then
      if spell == _Q then
        APDmg = (25+25*QLevel+0.4*AP)*math.max(1,math.min(3,GetDistance(target.pos)/1250*3))--kanker
      elseif spell == _W then
      elseif spell == _E then
      end
    elseif not human then
      if spell == _Q then
        APDmg = ((({[1]=4,[2]=20,[3]=50,[4]=90})[RLevel])+0.36*AP+0.75*TotalDmg)*(1+GetStacks(target)*0.33)*2.5*(target.maxHealth-target.health)/target.maxHealth--kanker
      elseif spell == _W then
        APDmg = 50*RLevel+0.45*AP
      elseif spell == _E then
        APDmg = 10+60*RLevel+0.45*AP
      end
    end
    dmg = math.floor(ADDmg*(1-ArmorPercent))+math.floor(APDmg*(1-MagicArmorPercent))
    return math.floor(dmg)
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Orianna"

  function Orianna:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.Ball = nil
    AddTickCallback(function() self:TrackBall() end)
    AddTickCallback(function() self:UltLogic() end)
  end

  function Orianna:TrackBall()
    if objHolder["TheDoomBall"] and (GetDistance(objHolder["TheDoomBall"], myHero.pos) <= myHero.boundingRadius*2+7 or GetDistance(objHolder["TheDoomBall"]) > 1250) then
      objHolder["TheDoomBall"] = nil
    end
  end

  function Orianna:UltLogic()
    if Config:getParam("Misc", "Ra") then
      local enemies = 0
      if objHolder["TheDoomBall"] then
        enemies = EnemiesAround(objHolder["TheDoomBall"], data[3].width-myHero.boundingRadius)
      else
        enemies = EnemiesAround(myHero, data[3].width-myHero.boundingRadius)
      end
      if enemies >= 3 then
        CastSpell(_R)
      end
    end
  end

  function Orianna:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"Combo", "Harrass", "Killsteal"}) do
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W"}, slider = {30,50}})
    end
    Config:addParam({state = "Harrass", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {30,50,50}})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Orianna:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, false, true, 1.2)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmgQ = GetDmg(_Q, myHero, winion)
        local MinionDmgW = GetDmg(_W, myHero, winion)
        if MinionDmgQ and MinionDmgW >= winion.health and (objHolder["TheDoomBall"] and GetDistance(winion, objHolder["TheDoomBall"]) < data[1].width or GetDistance(winion) < data[1].width) then
          Cast(_W)
        end
        if myHero:CanUseSpell(_Q) == READY and MinionDmgQ and MinionDmgW and MinionDmgQ+MinionDmgW >= winion.health and (objHolder["TheDoomBall"] and GetDistance(winion, objHolder["TheDoomBall"]) < data[1].width or GetDistance(winion) < data[1].width) then
            Cast(_Q, winion, false, true, 1.2)
            DelayAction(Cast, 0.25, {_W})
        end
      end
    end
  end

  function Orianna:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana*100 then
      BestPos, BestHit = GetFarmPosition(data[_Q].range, data[_Q].width)
      if BestHit > 1 then 
        CastSpell(_Q, BestPos.x, BestPos.z)
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetFarmPosition(data[_Q].range, data[_W].width)
      if BestHit > 1 and objHolder["TheDoomBall"] and GetDistance(objHolder["TheDoomBall"], BestPos) < 50 then 
        Cast(_W)
      end
    end
  end

  function Orianna:Combo()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") then
      if objHolder["TheDoomBall"] then Cast(_Q, Target, false, true, 1.5, objHolder["TheDoomBall"]) else Cast(_Q, Target, false, true, 1.5, myHero) end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("Combo", "W") then
      self:CastW(Target)
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") and objHolder["TheDoomBall"] and GetDistance(objHolder["TheDoomBall"]) > 150 and VectorPointProjectionOnLineSegment(objHolder["TheDoomBall"], myHero, Target) and GetDistance(objHolder["TheDoomBall"])-objHolder["TheDoomBall"].boundingRadius >= GetDistance(Target) then
      Cast(_E, myHero, true)
    end
    if myHero:CanUseSpell(_R) == READY and Target.health < self:CalcRComboDmg(Target) and Config:getParam("Combo", "R") then
      self:CastR(Target)
    end
  end

  function Orianna:CalcRComboDmg(unit)
    dmg = 0
    if myHero:GetSpellData(_Q).currentCd < 1.5 then
      dmg = dmg + GetDmg(_Q, myHero, unit)
    end
    return (GetDmg(_R, myHero, unit)+GetDmg("AD", myHero, unit))+dmg
  end

  function Orianna:Harrass()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      if objHolder["TheDoomBall"] then Cast(_Q, Target, false, true, 1.5, objHolder["TheDoomBall"]) else Cast(_Q, Target, false, true, 1.5, myHero) end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      self:CastW(Target)
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "E") and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana and objHolder["TheDoomBall"] and GetDistance(objHolder["TheDoomBall"]) > 150 and VectorPointProjectionOnLineSegment(objHolder["TheDoomBall"], myHero, Target) and GetDistance(objHolder["TheDoomBall"])-objHolder["TheDoomBall"].boundingRadius >= GetDistance(Target) then
      Cast(_E, myHero, true)
    end
  end

  function Orianna:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        local Ball = objHolder["TheDoomBall"] or myHero
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, Target, false, true, 1.5, Ball)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") then
          self:CastW(enemy)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and objHolder["TheDoomBall"] and GetDistance(objHolder["TheDoomBall"]) > 150 and VectorPointProjectionOnLineSegment(objHolder["TheDoomBall"], myHero, enemy) and GetDistance(objHolder["TheDoomBall"])-objHolder["TheDoomBall"].boundingRadius > GetDistance(enemy) then
          Cast(_E, myHero)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") then
          self:CastR(enemy)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < self:CalcRComboDmg(enemy) and Config:getParam("Killsteal", "R") and Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "W") then
          self:CastR(enemy)
          DelayAction(Cast, data[3].delay, {_Q, Target, false, true, 1.5, Ball})
          DelayAction(function() self:CastW(enemy) end, data[3].delay+data[0].delay+GetDistance(Ball,enemy)/data[0].speed)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

  function Orianna:CastW(unit)
    if myHero:CanUseSpell(_W) ~= READY or unit == nil or myHero.dead then return end
    local Ball = objHolder["TheDoomBall"] or myHero
    if GetDistance(unit, Ball) < data[1].width-unit.boundingRadius then 
      Cast(_W)
    end  
  end

  function Orianna:CastR(unit)
    if myHero:CanUseSpell(_R) ~= READY or unit == nil or myHero.dead then return end
    local Ball = objHolder["TheDoomBall"] or myHero
    if GetDistance(unit, Ball) < data[3].width-unit.boundingRadius then  
      Cast(_R) 
    end  
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Rengar"

  function Rengar:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
    self.oneShotTimer = 0
    self.ultOn = false
    self.osTarget = nil
    self.isLeap = false
    self.alertTicker = 0
    self.keyStr = {[0] = "Q", [1] = "W", [2] = "E"}
    AddTickCallback(function() self:Tick() end)
    AddMsgCallback(function(x,y) self:Msg(x,y) end)
    AddAnimationCallback(function(x,y) self:Animation(x,y) end)
    AddProcessSpellCallback(function(unit,spell) self:ProcessSpell(unit,spell) end)
  end

  function Rengar:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Misc", name = "Empower", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Misc", name = "Empower2", code = SCRIPT_PARAM_LIST, value = 1, list = {"Q", "W", "E"}})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Rengar:Tick()
    if Config:getParam("Misc", "Empower") then
      local os = Config:getParam("Misc", "Empower2")
      Config:incParamBy1("Misc", "Empower2")
      if os ~= Config:getParam("Misc", "Empower2") then
        PrintAlertRed("Switched Empoweredmode! Now using: "..self.keyStr[Config:getParam("Misc", "Empower2")-1])
      end
    end
  end

  function Rengar:Msg(Msg, Key)
    if Msg == WM_LBUTTONDOWN then
      local minD = 0
      local starget = nil
      for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
          if GetDistance(enemy, mousePos) <= minD or starget == nil then
            minD = GetDistance(enemy, mousePos)
            starget = enemy
          end
        end
      end
      
      if starget and minD < 500 then
        if self.Forcetarget and starget.charName == self.Forcetarget.charName then
          self.Forcetarget = nil
        else
          self.Forcetarget = starget
          ScriptologyMsg("New target selected: "..starget.charName.."")
        end
      end
    end
  end

  function Rengar:Animation(unit, ani)
    if unit and unit.isMe and ani then
      if ani == "Spell5" and loadedOrb:DoOrb() then
        if Smite ~= nil and loadedOrb.IState then CastSpell(Smite, self.Target) end
        if Ignite ~= nil and loadedOrb.IState then CastSpell(Ignite, self.Target) end
        loadedOrb.orbTable.lastAA = 0
        if loadedOrb.State[_E] then DelayAction(function() if self.Target then CastSpell(_E, self.Target.x, self.Target.z) end end, 1 / (myHero.attackSpeed * loadedOrb.orbTable.windUp) - GetLatency() / 2000) end
        DelayAction(function() loadedOrb:WindUp(unit) end, 1 / (myHero.attackSpeed * loadedOrb.orbTable.windUp) - GetLatency() / 2000)
      end
    end
  end

  function Rengar:ProcessSpell(unit,spell)
    if unit and unit.isMe and spell and loadedOrb:DoOrb() then
      if spell.name:lower():find("rengare") and loadedOrb.State[_W] then
        Cast(_W, self.Target, false, true, 1)
      end
    end
  end

  function Rengar:CastItems(unit)
    local i = {["ItemTiamatCleave"] = self.orbTable.range, ["YoumusBlade"] = self.orbTable.range}
    local u = {["ItemSwordOfFeastAndFamine"] = 600}
    for slot = ITEM_1, ITEM_6 do
      if i[myHero:GetSpellData(slot).name] and myHero:CanUseSpell(slot) == READY and GetDistance(unit) <= i[myHero:GetSpellData(slot).name] then
        CastSpell(slot) 
      end
      if u[myHero:GetSpellData(slot).name] and myHero:CanUseSpell(slot) == READY and GetDistance(unit) <= u[myHero:GetSpellData(slot).name] then
        CastSpell(slot, unit)
      end
    end
  end

  function Rengar:LastHit()
    if myHero.mana == 5 and Config:getParam("LaneClear", "W") and (myHero.health / myHero.maxHealth) * 100 < 90 then
      Cast(_W)
    else
      if Config:getParam("LaneClear", "Q") then
        local minionTarget = GetLowestMinion(myHero.range+myHero.boundingRadius*2)
        if minionTarget ~= nil and minionTarget.health < GetDmg(_Q, myHero, minionTarget) then
          CastSpell(_Q, myHero:Attack(minionTarget))
        end
      end
      if Config:getParam("LaneClear", "W") then
        local minionTarget = GetLowestMinion(data[1].range)
        if minionTarget ~= nil and minionTarget.health < GetDmg(_W, myHero, minionTarget) then
          Cast(_W)
        end
      end
      if Config:getParam("LaneClear", "E") then
        local minionTarget = GetLowestMinion(data[2].range)
        if minionTarget ~= nil and minionTarget.health < GetDmg(_E, myHero, minionTarget) then
          Cast(_E, minionTarget, false, true, 1)
        end
      end
    end
  end

  function Rengar:LaneClear()
    if myHero.mana == 5 and Config:getParam("LaneClear", "W") and (myHero.health / myHero.maxHealth) * 100 < 90 then
      Cast(_W)
    else
      if Config:getParam("LaneClear", "Q") then
        local minionTarget = GetLowestMinion(myHero.range+myHero.boundingRadius*2)
        if minionTarget ~= nil then
          CastSpell(_Q, myHero:Attack(minionTarget))
        end
      end
      if Config:getParam("LaneClear", "W") then
        local pos, hit = GetFarmPosition(myHero.range+myHero.boundingRadius*2, data[1].width)
        if hit and hit > 1 and pos ~= nil and GetDistance(pos) < 150 then
          Cast(_W)
        end
      end
      if Config:getParam("LaneClear", "E") then
        local minionTarget = GetLowestMinion(data[2].range)
        if minionTarget ~= nil then
          Cast(_E, minionTarget, false, true, 1)
        end
      end
    end
    if myHero.mana == 5 and Config:getParam("LaneClear", "W") and (myHero.health / myHero.maxHealth) * 100 < 90 then
      Cast(_W)
    else
      if Config:getParam("LaneClear", "Q") then
        local minionTarget = GetJMinion(myHero.range+myHero.boundingRadius*2)
        if minionTarget ~= nil then
          CastSpell(_Q, myHero:Attack(minionTarget))
        end
      end
      if Config:getParam("LaneClear", "W") then
        local pos, hit = GetJFarmPosition(myHero.range+myHero.boundingRadius*2, data[1].width)
        if hit and hit > 1 and pos ~= nil and GetDistance(pos) < 150 then
          Cast(_W)
        end
      end
      if Config:getParam("LaneClear", "E") then
        local minionTarget = GetJMinion(data[2].range)
        if minionTarget ~= nil then
          Cast(_E, minionTarget, false, true, 1)
        end
      end
    end
  end

  function Rengar:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          CastSpell(_Q, myHero:Attack(enemy))
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, false, true, 1)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, false, true, 1.5)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- class "Riven"
  -- Encrypted by DeadDevil2 - dd2
  assert(load(Base64Decode("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"), nil, "bt", _ENV))()

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Ryze"

  function Ryze:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 600, DAMAGE_MAGICAL, false, true)
    self:Menu()
    self.passiveTracker = 0
    AddMsgCallback(function(x,y) self:Msg(x,y) end)
    AddDrawCallback(function() self:Draw() end)
    AddApplyBuffCallback(function(unit, buff) self:ApplyBuff(unit, buff) end)
    AddUpdateBuffCallback(function(unit, buff, stacks) self:UpdateBuff(unit, buff, stacks) end)
    AddRemoveBuffCallback(function(unit, buff) self:RemoveBuff(unit, buff) end)
  end

  function Ryze:Draw()
    if self.passiveTracker then
      local barPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
      local posX = barPos.x - 35
      local posY = barPos.y + 50
      DrawText(""..self.passiveTracker, 25, posX, posY, ARGB(255, 255, 0, 0)) 
    end
  end

  function Ryze:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "LaneClear", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {30,50,50}})
    end
    Config:addParam({state = "LaneClear", name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E","R"}, slider = {30,50,50,50}})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Ryze:Msg(Msg, Key)
    if Msg == WM_LBUTTONDOWN then
      local minD = 0
      local starget = nil
      for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
          if GetDistance(enemy, mousePos) <= minD or starget == nil then
            minD = GetDistance(enemy, mousePos)
            starget = enemy
          end
        end
      end
      
      if starget and minD < 500 then
        if self.Forcetarget and starget.charName == self.Forcetarget.charName then
          self.Forcetarget = nil
        else
          self.Forcetarget = starget
          ScriptologyMsg("New target selected: "..starget.charName.."")
        end
      end
    end
  end

  function Ryze:ApplyBuff(unit, buff) 
    if unit == nil or buff == nil then return end 
    if buff.name == "ryzepassivestack" then self.passiveTracker = 1 end 
    if buff.name == "ryzepassivecharged" then self.passiveTracker = 5 end 
  end 

  function Ryze:UpdateBuff(unit, buff, stacks) 
    if unit == nil or buff == nil then return end 
    if buff.name == "ryzepassivestack" then self.passiveTracker = stacks end 
    if buff.name == "ryzepassivecharged" then self.passiveTracker = 5 end 
  end 

  function Ryze:RemoveBuff(unit, buff) 
    if unit == nil or buff == nil then return end 
    if buff.name == "ryzepassivestack" then self.passiveTracker = 0 end 
    if buff.name == "ryzepassivecharged" then self.passiveTracker = 0 end 
  end

  function Ryze:LastHit()
    target = GetJMinion(900)
    if not target then
      target = GetLowestMinion(900)
    end
    if not target then return end
    if ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) and target.health < GetDmg(_E, myHero, target) then 
      Cast(_Q, target, false, true, 1)
    end
    if ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) and target.health < GetDmg(_W, myHero, target) then 
      Cast(_W, target, true)
    end
    if ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) and target.health < GetDmg(_E, myHero, target) then 
      Cast(_E, target, true)
    end
  end

  function Ryze:LaneClear()
    target = GetJMinion(900)
    if not target then
      target = GetLowestMinion(900)
    end
    if target and GetDistance(target) < 900 then 
      if Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana*100 then 
        local x1, x2, x3 = UPL:Predict(_Q, myHero, target) 
        if x2 and x2 >= 1 then CastSpell(_Q, x1.x, x1.z) end 
      end
      if self.passiveTracker >= 5 then 
        if myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_E).currentCd > 0 and (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd > 0 or true) and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana*100 then
          local x1, x2, x3 = UPL.VP:GetLineCastPosition(target, 0.25, 55, 900, 1875, myHero, false) 
          if x2 and x2 >= 2 then CastSpell(_Q, x1.x, x1.z) end 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_W).currentCd > 0 and (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd > 0 or true) and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") < myHero.mana/myHero.maxMana*100 then 
          CastSpell(_E, target) 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") < myHero.mana/myHero.maxMana*100 then
          CastSpell(_W, target) 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and Config:getParam("LaneClear", "R") and Config:getParam("LaneClear", "mana", "R") < myHero.mana/myHero.maxMana*100 then
          CastSpell(_R, target) 
        end 
      else 
        if Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") < myHero.mana/myHero.maxMana*100 then CastSpell(_W, target) end
        if Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") < myHero.mana/myHero.maxMana*100 then CastSpell(_E, target) end 
      end 
      if self.passiveTracker == 4 and Config:getParam("LaneClear", "R") and Config:getParam("LaneClear", "mana", "R") < myHero.mana/myHero.maxMana*100 then 
        CastSpell(_R) 
      end 
    end 
  end

  function Ryze:Combo()
    target = Target
    if Forcetarget ~= nil and ValidTarget(Forcetarget, 900) then 
      target = Forcetarget 
    end 
    if target and GetDistance(target) < 900 then 
      if Config:getParam("Combo", "Q") then 
        local x1, x2, x3 = UPL:Predict(_Q, myHero, target) 
        if x2 and x2 >= 1 then CastSpell(_Q, x1.x, x1.z) end 
      end
      if self.passiveTracker >= 5 then 
        if myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_E).currentCd > 0 and (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd > 0 or true) and Config:getParam("Combo", "Q") then
          local x1, x2, x3 = UPL.VP:GetLineCastPosition(target, 0.25, 55, 900, 1875, myHero, false) 
          if x2 and x2 >= 2 then CastSpell(_Q, x1.x, x1.z) end 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 and Config:getParam("Combo", "E") then 
          CastSpell(_E, target) 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd > 0 or true) and Config:getParam("Combo", "W") then
          CastSpell(_W, target) 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and Config:getParam("Combo", "R") then
          CastSpell(_R, target) 
        end 
      else 
        if Config:getParam("Combo", "W") then CastSpell(_W, target) end
        if Config:getParam("Combo", "E") then CastSpell(_E, target) end 
      end 
      if self.passiveTracker == 4 and Config:getParam("Combo", "R") then 
        CastSpell(_R) 
      end 
    end 
  end

  function Ryze:Harrass()
    target = Target
    if Forcetarget ~= nil and ValidTarget(Forcetarget, 900) then 
      target = Forcetarget 
    end 
    if target and GetDistance(target) < 900 then 
      if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then 
        local x1, x2, x3 = UPL:Predict(_Q, myHero, target) 
        if x2 and x2 >= 1 then CastSpell(_Q, x1.x, x1.z) end 
      end
      if self.passiveTracker >= 5 then 
        if myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_E).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
          local x1, x2, x3 = UPL.VP:GetLineCastPosition(target, 0.25, 55, 900, 1875, myHero, false) 
          if x2 and x2 >= 2 then CastSpell(_Q, x1.x, x1.z) end 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 and Config:getParam("Harrass", "E") and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then 
          CastSpell(_E, target) 
        elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
          CastSpell(_W, target) 
        end 
      else 
        if Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then CastSpell(_W, target) end
        if Config:getParam("Harrass", "E") and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then CastSpell(_E, target) end 
      end 
    end 
  end

  function Ryze:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 2)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, true)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif myHero:CanUseSpell(_E) == READY and myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_W, myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "W") and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_W, enemy, true)
          DelayAction(function() Cast(_E, enemy, true) end, 0.25)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

  function Ryze:DmgCalc()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy.visible then
        killTextTable[enemy.networkID].indicatorText = ""
        local damageAA = GetDmg("AD", myHero, enemy)
        local damageQ  = GetDmg(_Q, myHero, enemy)
        local damageW  = GetDmg(_W, myHero, enemy)
        local damageE  = GetDmg(_E, myHero, enemy)
        local damageR  = GetDmg(_R, myHero, enemy)
        local damageI  = Ignite and (GetDmg("IGNITE", myHero, enemy)) or 0
        local damageS  = Smite and (20 + 8 * myHero.level) or 0
        local ready    = 0
        for _,k in pairs({_Q,_W,_E,_R}) do 
          if myHero:CanUseSpell(k) == READY then 
            ready = ready + 1 
          end  
        end 
        local mult     = self.passiveTracker >= (6-ready) and 3 or 1
        if damageQ > 0 then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."Q"
        end
        if damageW > 0 then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."W"
        end
        if damageE > 0 then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.."E"
        end
        if self.passiveTracker >= 4 then
          killTextTable[enemy.networkID].indicatorText = "Combo"
        end
        if enemy.health < mult*(damageQ+damageW+damageE) then
          killTextTable[enemy.networkID].indicatorText = killTextTable[enemy.networkID].indicatorText.." Kill"
        end
        if enemy.health > mult*(damageQ+damageW+damageE) then
          local neededAA = math.ceil(100*(damageQ+damageW+damageE)/(enemy.health))
          killTextTable[enemy.networkID].indicatorText = neededAA.." % Combodmg"
        end
        local enemyDamageAA = GetDmg("AD", enemy, myHero)
        local enemyNeededAA = not enemyDamageAA and 0 or math.ceil(myHero.health / enemyDamageAA)   
        if enemyNeededAA ~= 0 then         
          killTextTable[enemy.networkID].damageGettingText = enemy.charName .. " kills me with " .. enemyNeededAA .. " hits"
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Rumble"

  function Rumble:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
    AddTickCallback(function() self:DoW() end)
    AddTickCallback(function() self:DoSomeUltLogic() end)
  end

  function Rumble:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Rumble:DoW()
    if Config:getParam("Misc", "Wa") and not IsRecalling(myHero) and myHero.mana < 40 then
      CastSpell(_W)
    end
  end

  function Rumble:DoSomeUltLogic()
    if Config:getParam("Misc", "Ra") then
      local enemies = EnemiesAround(Target, 250)
      if enemies >= 3 then
        Cast(_R, Target, false, true, 2)
      end
    end
    if Config:getParam("Misc", "Ra") then
      local enemies = EnemiesAround(Target, 250)
      local allies = AlliesAround(myHero, 500)
      if enemies >= 2 and allies >= 2 then
        Cast(_R, Target, false, true, 2)
      end
    end
  end

  function Rumble:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q")) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q"))) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E")) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E"))) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_E, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          Cast(_E, winion, false, true, 1.2)
        end
      end
    end
  end

  function Rumble:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") then
      BestPos, BestHit = GetFarmPosition(data[_Q].range, data[_Q].width)
      if BestHit > 1 then 
        Cast(_Q, BestPos)
      end
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") then
      local minionTarget = GetLowestMinion(data[2].range)
      if minionTarget ~= nil then
        Cast(_E, winion, false, true, 1.2)
      end
    end
  end

  function Rumble:Combo()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, false, true, 1.2)
    end
    if Config:getParam("Combo", "W") then Cast(_W) end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") and ValidTarget(Target, data[2].range) then
      Cast(_E, Target, false, true, 1.5)
    end
    if Config:getParam("Combo", "R") and (GetDmg(_R, myHero, Target) >= Target.health or (EnemiesAround(Target, 500) > 2)) and ValidTarget(Target, data[3].range) then
      Cast(_R, Target, true)
    end
  end

  function Rumble:Harrass()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, false, true, 1.2)
    end
    if Config:getParam("Harrass", "W") then Cast(_W) end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Harrass", "E") and ValidTarget(Target, data[2].range) then
      Cast(_E, Target, false, true, 1.5)
    end
  end

  function Rumble:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, true)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Talon"

  function Talon:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
  end

  function Talon:Menu()
    for _,s in pairs({"Combo", "Harrass", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    end 
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    if Ignite ~= nil then Config:addParam({state = "Combo", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W"}, slider = {30,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Talon:LastHit()
    if myHero:GetSpellData(_Q).currentCd == 0 and not self.Target and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          CastSpell(_Q, myHero:Attack(winion))
        end
      end
    end
    if myHero:GetSpellData(_Q).currentCd > 0 and not self.Target and myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_W, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[1].range) and GetDistance(winion) < data[1].range then
          Cast(_W, winion)
        end
      end
    end
  end

  function Talon:LaneClear()
    if Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      if self.Target and GetDistance(self.Target) < data[0].range then
        CastSpell(_Q, myHero:Attack(self.Target))
      end
    end
    if Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      pos, hit = GetFarmPosition(data[1].range, data[1].width)
      if pos and hit > 0 then
        Cast(_W, pos)
      end
    end
  end

  function Talon:Combo()
    if myHero:CanUseSpell(_E) == READY and Config:getParam("Combo", "E") and ValidTarget(self.Target, data[2].range) then
      Cast(_E, self.Target, true)
    end
    if myHero:CanUseSpell(_E) ~= READY and myHero:CanUseSpell(_R) == READY and Config:getParam("Combo", "R") and ValidTarget(self.Target, data[3].width) and self.Target.health < GetDmg(_Q, myHero, self.Target)+GetDmg(_W, myHero, self.Target)+GetDmg("AD", myHero, self.Target)+GetDmg(_R, myHero, self.Target) then
      Cast(_R, self.Target, true)
    end
  end

  function Talon:Harrass()
    if Config:getParam("Harrass", "E") and ValidTarget(Target, data[2].range) then
      if myHero:CanUseSpell(_E) == READY then
        Cast(_E, self.Target, true)  
      end
    elseif myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(self.Target, data[0].range) then
      CastSpell(_Q, myHero:Attack(self.Target))
    elseif myHero:CanUseSpell(_W) == READY and Config:getParam("Harrass", "W") and ValidTarget(self.Target, data[1].range) then
      Cast(_W, self.Target, false, true, 2)
    end
  end

  function Talon:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        local dmg = 0
        local c = 0
        for _,k in pairs({"Q","W","E"}) do
          if Config:getParam("Killsteal", k) and sReady[_-1] then
            dmg = dmg + GetDmg(_-1, myHero, enemy) * ((k == "W" or k == "R") and 0.5 or 1)
            c = c + 1
          end
        end
        dmg = dmg + (c > 0 and GetDmg("AD", myHero, enemy) or 0)
        dmg = dmg*((sReady[_E]) and 1+0.03*myHero:GetSpellData(_E).level or 1)+((sReady[_R] or myHero:GetSpellData(_R).name == "talonshadowassaulttoggle") and Config:getParam("Killsteal", "R") and GetDmg(_R, myHero, enemy)*2 or 0)
        if dmg >= enemy.health and EnemiesAround(enemy,750) < 3 then
          if Config:getParam("Killsteal", "Q") and myHero:GetSpellData(_Q).currentCd == 0 and GetDistance(enemy) < data[2].range then
            if GetDistance(enemy) < data[0].range then CastSpell(_Q, myHero:Attack(enemy)) end
            if Config:getParam("Killsteal", "E") and sReady[_E] then
              DelayAction(Cast, 0.25, {_E, enemy, true})
              if Config:getParam("Killsteal", "W") and sReady[_W] then
                DelayAction(function() Cast(_W, enemy, false, true, 1) end, 0.5)
                if (Config:getParam("Killsteal", "R") and myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                  DelayAction(function() Cast(_R) end, 0.75)
                end
              end
            elseif Config:getParam("Killsteal", "W") and sReady[_W] then
              DelayAction(function() Cast(_W, enemy, false, true, 1) end, 0.25)
              if Config:getParam("Killsteal", "R") and (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                DelayAction(function() Cast(_R) end, 0.5)
              end
            end
          elseif Config:getParam("Killsteal", "E") and sReady[_E] and GetDistance(enemy) < data[2].range then
            Cast(_E, enemy, true)
            if Config:getParam("Killsteal", "W") and sReady[_W] then
              DelayAction(function() Cast(_W, enemy, false, true, 1) end, 0.25)
              if Config:getParam("Killsteal", "R") and (myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).level > 0) then
                DelayAction(function() Cast(_R) end, 0.5)
              end
            end
          elseif Config:getParam("Killsteal", "W") and sReady[_W] and GetDistance(enemy) < data[1].range then
            Cast(_W, enemy, false, true, 1)
            if Config:getParam("Killsteal", "R") and (sReady[_R] or myHero:GetSpellData(_R).name == "talonshadowassaulttoggle") then
              DelayAction(function() Cast(_R) end, 0.25)
            end
          elseif GetDistance(enemy) < data[3].width and Config:getParam("Killsteal", "R") and (sReady[_R] or myHero:GetSpellData(_R).name == "talonshadowassaulttoggle") then
            Cast(_R)
          end
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Teemo"

  function Teemo:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
  end

  function Teemo:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    if Ignite ~= nil then Config:addParam({state = "Combo", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q"}, slider = {30}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Teemo:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, true)
        end
      end
    end
  end

  function Teemo:LaneClear()
    if Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, true)
        end
      end
    end
  end

  function Teemo:Combo()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, true)
    end
    if Config:getParam("Combo", "Ignite") and ValidTarget(enemy, 600) and (Target.health < (50+20*myHero.level+GetDmg(_Q,myHero,Target)+GetDmg("AD",myHero,Target)*5*myHero.attackSpeed) or killTextTable[Target.networkID].indicatorText:find("Killable")) then
      CastSpell(Ignite, Target)
    end
    if Config:getParam("Combo", "R") and ValidTarget(Target, data[3].width) then
      Cast(_R, Target)
    end
  end

  function Teemo:Harrass()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
      Cast(_Q, Target, true)
    end
    if Config:getParam("Combo", "R") and ValidTarget(Target, data[3].width) then
      Cast(_R, Target)
    end
  end

  function Teemo:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, true)
        elseif enemy.health < GetDmg("AD", myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, myHero.range+myHero.boundingRadius) then
          myHero:Attack(enemy)
        elseif myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy)+GetDmg("AD", myHero, enemy)+GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, myHero.range+myHero.boundingRadius) then
          myHero:Attack(enemy)
          DelayAction(Cast, 0.2, {_Q, enemy, true})
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Vayne"

  function Vayne:__init()
    self.ts = TargetSelector(TARGET_LOW_HP, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
    AddTickCallback(function() self:DoSomething() end)
  end

  function Vayne:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      --Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"E"}, slider = {50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Vayne:DoSomething()
    if not Config:getParam("Misc", "Ea") then return end
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy, 1000) and enemy ~= nil and not enemy.dead then
        self:MakeUnitHugTheWall(enemy)
      end
    end
  end

  function Vayne:MakeUnitHugTheWall(unit)
    if not unit or unit.dead or not unit.visible then return end
    local x, y, z = UPL:Predict(_E, myHero, unit)
    for _=10,(450-unit.boundingRadius)*Config:getParam("Misc", "offset", "E")/100,10 do
      local dir = x+(x-myHero):normalized()*_
      if IsWall(D3DXVECTOR3(dir.x,dir.y,dir.z)) then
        Cast(_E, unit, true)
        return
      end
    end
  end

  function Vayne:LastHit()
    target = GetJMinion(data[2].range)
    if not target then
      target = GetLowestMinion(data[2].range)
    end
    self:MakeUnitHugTheWall(Target)
  end

  function Vayne:LaneClear()
    target = GetJMinion(data[2].range)
    if not target then
      target = GetLowestMinion(data[2].range)
    end
    self:MakeUnitHugTheWall(Target)
  end

  function Vayne:Combo()
    self:MakeUnitHugTheWall(Target)
  end

  function Vayne:Harrass()
    self:MakeUnitHugTheWall(Target)
  end

  function Vayne:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, myHero:Attack(enemy))
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Volibear"

  function Volibear:__init()
    self.ts = TargetSelector(TARGET_LOW_HP, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
  end

  function Volibear:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    end
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Volibear:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_W, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[1].range) and GetDistance(winion) < data[1].range then
          Cast(_W, winion, true)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_E, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          Cast(_E)
        end
      end
    end
  end

  function Volibear:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          minionTarget = winion
        end
        if minionTarget ~= nil then
          Cast(_Q)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[1].range) and GetDistance(winion) < data[1].range then
          minionTarget = winion
        end
        if minionTarget ~= nil then
          Cast(_W, minionTarget, true)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          minionTarget = winion
        end
        if minionTarget ~= nil then
          Cast(_E)
        end
      end
    end
  end

  function Volibear:Combo()
    if Config:getParam("Combo", "Q") and myHero:CanUseSpell(_Q) == READY and ValidTarget(Target, data[0].range) then
      Cast(_Q)
    end
    if Config:getParam("Combo", "W") and myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) then
      if GetDmg(_W, Target, myHero) >= Target.health then
        Cast(_W, Target, true)
      end
    end
    if Config:getParam("Combo", "E") and myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].range) and GetDistance(pos) < data[2].range then
      Cast(_E)
    end
    if Config:getParam("Combo", "R") and myHero:CanUseSpell(_R) == READY and EnemiesAround(myHero, 500) > 1 and ValidTarget(Target, data[3].range) then
      Cast(_R, myHero:Attack(Target))
    end
  end

  function Volibear:Harrass()
    if Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and myHero:CanUseSpell(_Q) == READY and ValidTarget(Target, data[0].range) then
      Cast(_Q)
    end
    if Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana and myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) then
      Cast(_W, Target, true)
    end
    if Config:getParam("Harrass", "E") and GetDistance(pos) < data[2].range and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana and myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].range) then
      Cast(_E)
    end
  end

  function Volibear:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, true)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range-enemy.boundingRadius) then
          Cast(_E)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Yasuo"

  function Yasuo:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL, false, true)
    self:Menu()
    AddProcessSpellCallback(function(x,y) self:ProcessSpell(x,y) end)
    AddTickCallback(function() self:Tick() end)
  end

  function Yasuo:Tick()
    if Config:getParam("Misc", "Flee") then
      self:Move(mousePos)
    end
  end

  function Yasuo:Move(x)
    myHero:MoveTo(x.x,x.z)
    if sReady[_E] then
      local minion = nil
      for _,k in pairs(Mobs.objects) do
        if not minion and k and GetDistanceSqr(k) < data[2].range*data[2].range then minion = k end
        if minion and k and GetStacks(k) == 0 and GetDistanceSqr(k,myHero) > GetDistanceSqr(minion,myHero) and GetDistanceSqr(k,x) < GetDistanceSqr(minion,x) and GetDistanceSqr(k,x) > data[2].range*data[2].range/2 and GetDistanceSqr(k) < data[2].range*data[2].range then
          minion = k
        end
      end
      if minion then
        Cast(_E, minion, true)
      end
    end
  end

  function Yasuo:ProcessSpell(unit, spell)
    if (Config:getParam("Misc", "Wa") or (Config:getParam("Combo", "Combo") and Config:getParam("Combo", "W"))) and unit and unit.team ~= myHero.team and GetDistance(unit) < 1500 then
      if myHero == spell.target and spell.name:lower():find("attack") and unit.range > 475 then
        local wPos = myHero + (Vector(unit) - myHero):normalized() * data[1].range 
        Cast(_W, wPos)
      elseif spell.endPos and not spell.target then
        local makeUpPos = unit + (Vector(spell.endPos)-unit):normalized()*GetDistance(unit)
        if GetDistance(makeUpPos) < myHero.boundingRadius*3 or GetDistance(spell.endPos) < myHero.boundingRadius*3 then
          local wPos = myHero + (Vector(unit) - myHero):normalized() * data[1].range 
          Cast(_W, wPos)
        end
      end
    end
  end

  function Yasuo:Menu()
    for _,s in pairs({"Combo", "Harrass", "Killsteal", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Combo", name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true})
                          Config:addParam({state = "Combo", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Misc", name = "Flee", key = string.byte("T"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
  end

  function Yasuo:LastHit()
    local minion = GetLowestMinion(data[2].range)
    if minion and GetStacks(minion) == 0 and minion.health < GetDmg(_E, myHero, minion) and loadedOrb.State[_E] then
      Cast(_E, minion, true)
    end
    if minion and GetStacks(minion) == 0 and minion.health < GetDmg(_Q, myHero, minion)+GetDmg(_E, myHero, minion) and loadedOrb.State[_Q] and loadedOrb.State[_E] then
      Cast(_E, minion, true)
      DelayAction(function() Cast(_Q) end, 0.25)
    end
  end

  function Yasuo:LaneClear()
    -- mad?
  end

  function Yasuo:Combo()
    if not self.Target then return end
    if GetDistance(self.Target) > loadedOrb.myRange and Config:getParam("Combo", "E") then
      if GetDistance(self.Target) < data[2].range and GetStacks(self.Target) == 0 then
        Cast(_E, self.Target, true)
      else
        self:Move(self.Target)
      end
    end
    if self.Target.y > myHero.y+25 and Config:getParam("Combo", "R") then
      if sReady[_Q] and GetDistance(self.Target) < data[0].range then
        myHero:Attack(self.Target)
      else
        Cast(_R, self.Target, true)
      end
    end
  end

  function Yasuo:Harrass()
    if not self.Target then return end
    if GetDistance(self.Target) > loadedOrb.myRange and GetStacks(self.Target) == 0 and Config:getParam("Harrass", "E") then
      Cast(_E, self.Target, true)
    end
  end

  function Yasuo:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if enemy.y > myHero.y+25 and Config:getParam("Killsteal", "R") and GetDmg(_R,myHero,enemy) > enemy.health then
          Cast(_R, enemy, true)
        elseif Config:getParam("Killsteal", "Q") and GetDmg(_Q,myHero,enemy) > enemy.health then
          Cast(_Q, enemy, false, true, 1)
        elseif Config:getParam("Killsteal", "E") and GetDmg(_E,myHero,enemy) > enemy.health then
          Cast(_E, enemy, true)
        elseif Config:getParam("Killsteal", "Q") and Config:getParam("Killsteal", "E") and GetDmg(_Q,myHero,enemy)+GetDmg(_E,myHero,enemy) > enemy.health then
          Cast(_E, enemy, true)
          DelayAction(function() Cast(_Q) end, 0.25)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--[[
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

class "Sample"

  function Sample:__init()
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_MAGICAL, false, true)
    self:Menu()
  end

  function Sample:Menu()
    for _,s in pairs({"Combo", "Harrass", "LaneClear", "LastHit", "Killsteal"}) do
      Config:addParam({state = s, name = "Q", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "W", code = SCRIPT_PARAM_ONOFF, value = true})
      Config:addParam({state = s, name = "E", code = SCRIPT_PARAM_ONOFF, value = true})
    end
    Config:addParam({state = "Killsteal", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    Config:addParam({state = "Combo", name = "R", code = SCRIPT_PARAM_ONOFF, value = true})
    for _,s in pairs({"Harrass", "LaneClear", "LastHit"}) do
      Config:addParam({state = s, name = "mana", code = SCRIPT_PARAM_SLICE, text = {"Q","W","E"}, slider = {50,50,50}})
    end
    Config:addParam({state = "Combo", name = "Combo", key = 32, code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "Harrass", name = "Harrass", key = string.byte("C"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LaneClear", name = "LaneClear", key = string.byte("V"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    Config:addParam({state = "LastHit", name = "LastHit", key = string.byte("X"), code = SCRIPT_PARAM_ONKEYDOWN, value = false})
    if Ignite ~= nil then Config:addParam({state = "Killsteal", name = "Ignite", code = SCRIPT_PARAM_ONOFF, value = true}) end
  end

  function Sample:LastHit()
    if myHero:CanUseSpell(_Q) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "Q") and Config:getParam("LastHit", "mana", "Q") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_Q, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) < data[0].range then
          Cast(_Q, winion, false, true, 1.2)
        end
      end
    end
    if myHero:CanUseSpell(_W) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "W") and Config:getParam("LastHit", "mana", "W") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_W, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[1].range) and GetDistance(winion) < data[1].range then
          Cast(_W, Target, false, true, 1.5)
        end
      end
    end
    if myHero:CanUseSpell(_E) == READY and ((Config:getParam("LastHit", "LastHit") and Config:getParam("LastHit", "E") and Config:getParam("LastHit", "mana", "E") <= 100*myHero.mana/myHero.maxMana) or (Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana)) then
      for minion,winion in pairs(Mobs.objects) do
        local MinionDmg = GetDmg(_E, myHero, winion)
        if MinionDmg and MinionDmg >= winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          Cast(_E, winion, true)
        end
      end
    end
  end

  function Sample:LaneClear()
    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") < myHero.mana/myHero.maxMana*100 then
      BestPos, BestHit = GetQFarmPosition()
      if BestHit > 1 and GetDistance(BestPos) < 150 then 
        self:CastQ1()
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "LaneClear") and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") < myHero.mana/myHero.maxMana*100 then
      local minionTarget = nil
      for i, minion in pairs(minionManager(MINION_ENEMY, 250, myHero, MINION_SORT_HEALTH_ASC).objects) do
        if minionTarget == nil then 
          minionTarget = minion
        elseif minionTarget.health+minionTarget.shield >= minion.health+minion.shield and ValidTarget(minion, 250) then
          minionTarget = minion
        end
      end
      if minionTarget ~= nil then
        CastSpell(_W, myHero:Attack(minionTarget))
      end
    end

    if myHero:CanUseSpell(_Q) == READY and Config:getParam("LaneClear", "Q") and Config:getParam("LaneClear", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[0].range) and GetDistance(winion) <= 100*data[0].range then
          minionTarget = winion
        end
      end
      if minionTarget ~= nil then
        Cast(_Q, minionTarget, false, true, 1.2)
      end
    end
    if myHero:CanUseSpell(_W) == READY and Config:getParam("LaneClear", "W") and Config:getParam("LaneClear", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
      BestPos, BestHit = GetFarmPosition(data[_W].range, data[_W].width)
      if BestHit > 1 then 
        Cast(_W, BestPos)
      end
    end
    if myHero:CanUseSpell(_E) == READY and Config:getParam("LaneClear", "E") and Config:getParam("LaneClear", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
      local minionTarget = nil
      for minion,winion in pairs(Mobs.objects) do
        if minionTarget == nil then 
          minionTarget = winion
        elseif minionTarget.health < winion.health and ValidTarget(winion, data[2].range) and GetDistance(winion) < data[2].range then
          minionTarget = winion
        end
      end
      if minionTarget ~= nil and (stackTable[minionTarget.networkID] and stackTable[minionTarget.networkID] > 0) then
        Cast(_E, winion, true)
      end
    end
  end

  function Sample:Combo()
    if (myHero:CanUseSpell(_E) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Combo", "E") then
      if myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].range) then
        Cast(_E, Target, true)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
      if myHero:CanUseSpell(_W) == READY and Config:getParam("Combo", "W") and ValidTarget(Target, data[1].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_W, Target, false, true, 1.5)
        end
      end
    elseif (myHero:CanUseSpell(_W) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Combo", "W") then
      if myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) then
        Cast(_W, Target, false, true, 1.5)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
    else
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Combo", "Q") and ValidTarget(Target, data[0].range) then
        Cast(_Q, Target, false, true, 1.5)
      end
    end
    if Config:getParam("Combo", "R") and (GetDmg(_R, myHero, Target) >= Target.health or (EnemiesAround(Target, 500) > 1 and stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and ValidTarget(Target, data[3].range) then
      Cast(_R, Target, true)
    end
  end

  function Sample:Harrass()
    if (myHero:CanUseSpell(_E) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Harrass", "E") then
      if myHero:CanUseSpell(_E) == READY and ValidTarget(Target, data[2].range) and Config:getParam("Harrass", "mana", "E") <= 100*myHero.mana/myHero.maxMana then
        Cast(_E, Target, true)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana and ValidTarget(Target, data[0].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
      if myHero:CanUseSpell(_W) == READY and Config:getParam("Harrass", "W") and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana and ValidTarget(Target, data[1].range) then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_W, Target, false, true, 1.5)
        end
      end
    elseif (myHero:CanUseSpell(_W) == READY or (stackTable[Target.networkID] and stackTable[Target.networkID] > 0)) and Config:getParam("Harrass", "W") then
      if myHero:CanUseSpell(_W) == READY and ValidTarget(Target, data[1].range) and Config:getParam("Harrass", "mana", "W") <= 100*myHero.mana/myHero.maxMana then
        Cast(_W, Target, false, true, 1.5)
      end
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, data[0].range) and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        if stackTable[Target.networkID] and stackTable[Target.networkID] > 0 then
          Cast(_Q, Target, false, true, 1.2)
        end
      end
    else
      if myHero:CanUseSpell(_Q) == READY and Config:getParam("Harrass", "Q") and ValidTarget(Target, data[0].range) and Config:getParam("Harrass", "mana", "Q") <= 100*myHero.mana/myHero.maxMana then
        Cast(_Q, Target, false, true, 2)
      end
    end
  end

  function Sample:Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.dead then
        if myHero:CanUseSpell(_Q) == READY and enemy.health < GetDmg(_Q, myHero, enemy) and Config:getParam("Killsteal", "Q") and ValidTarget(enemy, data[0].range) then
          Cast(_Q, enemy, false, true, 1.2)
        elseif myHero:CanUseSpell(_W) == READY and enemy.health < GetDmg(_W, myHero, enemy) and Config:getParam("Killsteal", "W") and ValidTarget(enemy, data[1].range) then
          Cast(_W, enemy, false, true, 1.5)
        elseif myHero:CanUseSpell(_E) == READY and enemy.health < GetDmg(_E, myHero, enemy) and Config:getParam("Killsteal", "E") and ValidTarget(enemy, data[2].range) then
          Cast(_E, enemy, true)
        elseif myHero:CanUseSpell(_R) == READY and enemy.health < GetDmg(_R, myHero, enemy) and Config:getParam("Killsteal", "R") and ValidTarget(enemy, data[3].range) then
          Cast(_R, enemy, true)
        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and enemy.health < (50 + 20 * myHero.level) / 5 and Config:getParam("Killsteal", "Ignite") and ValidTarget(enemy, 600) then
          CastSpell(Ignite, enemy)
        end
      end
    end
  end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--[[ Champion specific parts till here ]]--
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
