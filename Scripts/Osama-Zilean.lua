if myHero.charName ~= "Zilean" then return end

local version = "0.6"
local Author = "Tungkh1711"
local UPDATE_NAME = "Osama-Zilean"
local UPDATE_HOST = "raw.github.com"
local UPDATE_HOST2 = "raw.githubusercontent.com"
local UPDATE_PATH = "/tungkh1711/bolscript/master/Osama-Zilean.version" .. "?rand=" .. math.random(1, 10000)
local UPDATE_PATH2 = "/tungkh1711/bolscript/master/Osama-Zilean.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH2
local SpellList = false
_G.UseUpdater = true --CHANGE THIS TO FALSE IF YOU DON'T WANT AUTOUPDATES

function AutoupdaterMsg(msg) print("<b><font color=\"#6699FF\">"..UPDATE_NAME..":</font></b> <font color=\"#FFFFFF\">"..msg..".</font>") end
	if _G.UseUpdater then
  		local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
  		if ServerData then
    		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
    		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
    		if ServerVersion then
      			ServerVersion = tonumber(ServerVersion)
      			if tonumber(version) < ServerVersion then
        			AutoupdaterMsg("New version available"..ServerVersion)
        			AutoupdaterMsg("Updating, please don't press F9")
        			DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) 
        			SpellList = true		
      			else
        			AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
      			end
    		end
		else
    	AutoupdaterMsg("Error downloading version info")
		SpellList = true
 	end
end
--if SpellList then return end

---------------------------------------

local REQUIRED_LIBS = {
		["VPrediction"] = "https://raw.githubusercontent.com/SidaBoL/Chaos/master/VPrediction.lua",
	    ["HPrediction"] = "https://raw.githubusercontent.com/BolHTTF/BoL/master/HTTF/Common/HPrediction.lua",
    }
 
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
 
function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		PrintChat("<font color=\"#6699FF\">Required libraries downloaded successfully, please reload (Double F9)</font>")
	end
end
 
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		PrintChat("<font color=\"#6699FF\">Downloading libs ......</font>")
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end
-------------------------------------------

--Spell data
local Ranges = {Q = 900,        W = 0,           E = 550,      R = 900   }
local Widths = {Q = 230,        W = 0,           E = 0,        R = 0     }
local Delays = {Q = 0.25,       W = 0.25,        E = 0.25,    R = 0.25  }
local Speeds = {Q = 2000,       W = math.huge,   E = 2000,     R = 2000  }

-- Spell Check
-- Selector
local TargetLock
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Zilean", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "Zilean",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local EnemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)

local JungleMobs = {}
local JungleFocusMobs = {}

local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1300, DAMAGE_MAGIC)
ts.name = "Zilean"
local Target = nil
local VPHitChance = 2
local isRecalling = false
local ulttarget,ULastDistance,ULastDmgPercent = nil,nil,nil
---------------------
function OnLoad()
    Vars()
    Menu()
	OrbwalkMenu()
	PermaShow()
	PrintChat("<font color='#0000FF'> >>Osama-Zilean Successfully Loaded! <<</font>")
end

function Vars()
    VP = VPrediction()
	HPred = HPrediction()
	HPred:AddSpell("Q", 'Zilean', {type = "DelayCircle", delay = 0.25, range = 900, radius = 150, speed = 1800})
	DelayAction(arrangePrioritys,3)
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    	ignite = SUMMONER_2
	end
	_G.oldDrawCircle = rawget(_G, "DrawCircle")
	_G.DrawCircle = DrawCircle2
end

function Menu()

	ZileanMenu = scriptConfig("Osama-Zilean", "OsamaZilean")
	
	ZileanMenu:addSubMenu("Zilean - Combo Settings", "combo")
		ZileanMenu.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		ZileanMenu.combo:addParam("SupportMode", "Combo Mode: On = Support, Off = ApCombo", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
		ZileanMenu.combo:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
		ZileanMenu.combo:addParam("useQAOE", "Use Q AOE if not WREADY", SCRIPT_PARAM_ONOFF, true)
		ZileanMenu.combo:addParam("useW", "Use Q+W+Q in combo", SCRIPT_PARAM_ONOFF, true)
		ZileanMenu.combo:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
		ZileanMenu.combo:addParam("escapeKey", "Escape Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
	ZileanMenu:addSubMenu("Zilean - Killsteal Settings", "ks")
		ZileanMenu.ks:addParam("killsteal", "Enable KS", SCRIPT_PARAM_ONOFF, false)
		ZileanMenu.ks:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		ZileanMenu.ks:addParam("Qks", "KS with Q", SCRIPT_PARAM_ONOFF, true)
	ZileanMenu:addSubMenu("Zilean - Skills Setings", "advanced")
		ZileanMenu.advanced:addSubMenu("Auto-R Setings", "skillR")
		for i=1, heroManager.iCount do
			local Hero = heroManager:GetHero(i)
			if Hero.team == myHero.team then ZileanMenu.advanced.skillR:addParam(Hero.charName, "Auto R  "..Hero.charName, SCRIPT_PARAM_ONOFF, false) end
		end
		ZileanMenu.advanced.skillR:addParam("Renemies", "Auto ult if x enemies in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
		ZileanMenu.advanced.skillR:addParam("Rhealth", "if ally health < %", SCRIPT_PARAM_SLICE, 20, 0, 100, -1)
		ZileanMenu.advanced.skillR:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		ZileanMenu.advanced.skillR:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		ZileanMenu.advanced.skillR:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		ZileanMenu.advanced.skillR:addParam("skillshots", "Skillshots", SCRIPT_PARAM_ONOFF, true)
		ZileanMenu.advanced.skillR:addParam("AutoR", "Enabled Auto R", SCRIPT_PARAM_ONOFF, true)
	ZileanMenu:addSubMenu("Zilean - Miscellaneous Setings", "misc")
	    ZileanMenu.misc:addParam("PredicMode", "Current Prediction:", SCRIPT_PARAM_LIST, 2, {"HPrediction","VPrediction"})
		ZileanMenu.misc:addParam("HitChance", "Chose hitChance for Prediction", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	ZileanMenu:addSubMenu("Zilean - Draw Setings", "draw")
        ZileanMenu.draw:addParam("drawQRange", "Draw (Q) Range: ", SCRIPT_PARAM_ONOFF, false)
        ZileanMenu.draw:addParam("drawERange", "Draw (E) Range: ", SCRIPT_PARAM_ONOFF, false)
        ZileanMenu.draw:addParam("drawRRange", "Draw (R) Range: ", SCRIPT_PARAM_ONOFF, false)
        ZileanMenu.draw:addParam("drawTarget", "Draw current target: ", SCRIPT_PARAM_ONOFF, false)
        ZileanMenu.draw:addParam("LagFree", "Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
        ZileanMenu.draw:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 75, 1, 2000, 0)
	ZileanMenu:addSubMenu("Zilean - PermaShow Setings", "PermaShow")	
        ZileanMenu.PermaShow:addParam("AutoR", "Show AutoR", SCRIPT_PARAM_ONOFF, false)
        ZileanMenu.PermaShow:addParam("SupportMode", "Show Combo Mode Active", SCRIPT_PARAM_ONOFF, false)	
        ZileanMenu.PermaShow:addParam("KS", "Show KillSteal", SCRIPT_PARAM_ONOFF, false)			
	ZileanMenu:addTS(ts)
	ZileanMenu:addParam("Lock", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
end

function OrbwalkMenu()
	ZileanMenu:addSubMenu("Zilean - Orbwalk Setings", "Orbwalk")
	ZileanMenu.Orbwalk:addParam("orbchoice", "Select Orbwalker (Requires Reload)", SCRIPT_PARAM_LIST, 2, { "SOW", "SxOrbWalk", "MMA", "SAC" })
	    if ZileanMenu.Orbwalk.orbchoice == 1 then
		    require "SOW"
		    SOWi = SOW(VP)
		    SOWi:RegisterAfterAttackCallback(AutoAttackReset) 
		    SOWi:LoadToMenu(ZileanMenu.Orbwalk)
		end
	    if ZileanMenu.Orbwalk.orbchoice == 2 then
		    require "SxOrbWalk"
		    SxOrb:LoadToMenu(ZileanMenu.Orbwalk)
	    end
end

function PermaShow()
	if ZileanMenu.PermaShow.AutoW then
	    ZileanMenu.advanced.skillW:permaShow("AutoE")
    end	
	if ZileanMenu.PermaShow.AutoR then
	    ZileanMenu.advanced.skillR:permaShow("AutoR")		
    end
	if ZileanMenu.PermaShow.SupportMode then
	    ZileanMenu.combo:permaShow("SupportMode")
	end
	if ZileanMenu.PermaShow.KS then
	    ZileanMenu.ks:permaShow("killsteal")
	end	
end

function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end

function arrangePrioritys()
     local priorityOrder = {
                [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,2,3},
        [4] = {1,1,2,3,4},
        [5] = {1,2,3,4,5},
    }
    local enemies = #GetEnemyHeroes()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.p1, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.p2, enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.p3,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.p4,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.p5,  enemy, priorityOrder[enemies][5])
    end
end

function OnTick()
    Check()
	Action()	
end

function Check()
	ComboActive = ZileanMenu.combo.comboKey
	EscapeActive = ZileanMenu.combo.escapeKey
	KsActive = ZileanMenu.ks.killsteal
	--FarmActive = ZileanMenu.farm.farmKey or ZileanMenu.farm.farmtoggle
	--ClearActive = ZileanMenu.clear.clearKey
	VPHitChance = ZileanMenu.misc.HitChance
	SupportMode = ZileanMenu.combo.SupportMode
	
	QTotalCooldow = myHero:GetSpellData(_Q).cd * (1 + myHero.cdr)
	WTotalCooldow = myHero:GetSpellData(_W).cd * (1 + myHero.cdr)
	ETotalCooldow = myHero:GetSpellData(_E).cd * (1 + myHero.cdr)
	
	QCooldow = myHero:GetSpellData(_Q).currentCd
	WCooldow = myHero:GetSpellData(_W).currentCd
	ECooldow = myHero:GetSpellData(_E).currentCd
	RCooldow = myHero:GetSpellData(_R).currentCd
	
	QREADY     = (myHero:CanUseSpell(_Q) == READY)
	WREADY    = (myHero:CanUseSpell(_W) == READY)
	EREADY     = (myHero:CanUseSpell(_E) == READY)
	RREADY     = (myHero:CanUseSpell(_R) == READY)
	IREADY    = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	
	if QREADY and WREADY then
		ts.range = 900
	else
		ts.range = 1100
	end
	
	EnemyMinions:update()
	JungleMinions:update()
	
	if not ZileanMenu.draw.LagFree then
    	_G.DrawCircle = _G.oldDrawCircle
	end
	if ZileanMenu.draw.LagFree then
    	_G.DrawCircle = DrawCircle2
	end
	
end

function Action()
    Target = GetCustomTarget()
	if Target ~= nil and ValidTarget(Target) and not Target.dead and Target.visible then
	    if ComboActive then Combo(Target) end
	    if HarassActive then Harass(Target) end
	end
	if KsActive then Killsteal() end
	if FarmActive then Farm() end
	if ClearActive then Clear() end
	if EscapeActive then Escape() end
	--if ZileanMenu.advanced.skillW.AutoW then AutoW() end
	if ZileanMenu.advanced.skillR.AutoR then AutoR() end
end

function GetCustomTarget()
	if TargetLock ~= nil and ValidTarget(TargetLock, ts.range) then
        return TargetLock
    end
	ts:update()
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then 
		return _G.AutoCarry.Attack_Crosshair.target 
	end
	if ValidTarget(ts.target) and ts.target.type == myHero.type then
		return ts.target
	else
		return nil
	end
end

function OnWndMsg(msg, key)
  if msg == WM_LBUTTONDOWN and ZileanMenu.Lock then
    local dis = 0
    local current
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible and (dis >= GetDistance(enemy, mousePos) or current == nil) then
        dis = GetDistance(enemy, mousePos)
        current = enemy
      end
    end
    if current and dis < 115 then
      if TargetLock and current.charName == TargetLock.charName then
        TargetLock = nil
      else
        TargetLock = current
		print("<font color=\"#FFFFFF\">Zilean: New target <font color=\"#00FF00\"><b>SELECTED</b></font>: "..current.charName..".</font>")
      end
    end
  end
end

function Combo(Target)
    if SupportMode then
        if GetDistance(Target) < 900 and ZileanMenu.combo.useW then
		    QWQ(Target)
		elseif GetDistance(Target) < 900 and ZileanMenu.combo.useQ then
		    CastQ(Target)
		end
		if QREADY and WCooldow > QCooldow and ZileanMenu.combo.useQAOE then
		    AOEQ()
		end
		if CountAllysInRange(600, Target) > 1 then
		    CastSpell(_E, Target)
		end
	else 
        if GetDistance(Target) < 900 and ZileanMenu.combo.useW then
		    QWQ(Target)
		elseif GetDistance(Target) < 900 and ZileanMenu.combo.useQ then
		    CastQ(Target)
		end
	    if QREADY and WCooldow > 2 and ZileanMenu.combo.useQAOE then 
		    AOEQ() 
        end 
		if QCooldow > 3 and WREADY and ZileanMenu.combo.useW then
		    CastSpell(_W)
		end
		if GetDistance(Target) > 900 and GetDistance(Target) < 1100 and ZileanMenu.combo.useE then
		    CastSpell(_E, myHero)
		elseif GetDistance(Target) < Ranges.Q and ZileanMenu.combo.useE then
		    CastSpell(_E, Target)
		end
		for i, enemy in pairs (GetEnemyHeroes()) do
		    if enemy ~= Target and GetDistance(enemy) < 400 then
			    CastSpell(_E, enemy)
		    end
		end
    end
end

function QWQ(unit)
    if myHero.mana >= myHero:GetSpellData(_Q).mana * 2 + myHero:GetSpellData(_W).mana then
        if QREADY then
		    CastQ(unit)
		end
		if not QREADY and WREADY then
		    CastSpell(_W)
		end
		for i, enemy in pairs (GetEnemyHeroes()) do
		    if not enemy.dead and  ValidTarget(enemy,Ranges.Q) and TargetHaveBuff("zileanqenemybomb", enemy) then
			    CastQ(unit)
			end
		end
	end
end

function AOEQ()
	for i, enemy in pairs (GetEnemyHeroes()) do
		if not enemy.dead and  ValidTarget(enemy,Ranges.Q) then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(enemy, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
			if AOECastPosition and MainTargetHitChance >= VPHitChance and nTargets > 1 and GetDistance(AOECastPosition) < Ranges.Q then
			    CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
			end
		end
	end
end

function CastQ(unit)
    if QREADY then 
	    if ZileanMenu.misc.PredicMode == 1 then
		    QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
			if QPos and QHitChance >= VPHitChance and GetDistance(QPos) < Ranges.Q then
			    CastSpell(_Q, QPos.x, QPos.z)
			end
		else
	        local CastPosition, HitChance, Position = VP:GetCircularCastPosition(unit, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
			if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) < Ranges.Q then
			    CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function Escape()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if EREADY then
	    CastSpell(_E, myHero)
	end
	if WREADY and ECooldow > 2 then
	    CastSpell(_W)
	end
end

function CountEnemyHeroInRange(range, object)
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and hero.team ~= myHero.team and GetDistance(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function CountAllysInRange(range, object)
  local allyInRange = 0
  local allies = GetAllyHeroes()
  if object ~= nil and range then
    for i, ally in pairs(allies) do
      if not ally.dead and  ValidTarget(ally) and range > GetDistance(ally, object) then
        allyInRange = allyInRange + 1
      end
    end
  end
  return allyInRange
end

function OnProcessSpell(unit, spell)
    if unit and myHero.team == unit.team and GetDistance(unit) <= Ranges.E then
	    closestad = GetAllyAD()
		if closestad == nil then return end
		if closestad == unit and spell.name:find("Attack") then
		    if ComboActive and SupportMode and EREADY and spell.target.type == "AIHeroClient" and not isFacing(unit, spell.target, GetTrueRange(unit)) then
			    if GetDistance(spell.target) <= Ranges.E and ZileanMenu.combo.useE then
				    CastSpell(_E, spell.target)
				else
			        CastSpell(_E,unit)
				end
			end
		end
	end
	if unit and myHero.team ~= unit.team and unit.type == "AIHeroClient" then
	    closestad = GetAllyAD()
		if closestad == nil then return end
		if spell.name:find("Attack") and spell.target == closestad then
		    if ComboActive and SupportMode and EREADY and GetDistance(spell.target) <= Ranges.E and not isFacing(unit, spell.target, GetTrueRange(unit)) and CountEnemyHeroInRange(500, spell.target) > 1 then
			    CastSpell(_E, spell.target)
			end
		end
	end
	if unit.isMe and spell.name == "ZileanQ" and WREADY and ZileanMenu.combo.useW and myHero.mana >= myHero:GetSpellData(_Q).mana + myHero:GetSpellData(_W).mana then
	    CastSpell(_W)
	end
    if unit.team ~= myHero.team and not myHero.dead and not (unit.type == "obj_AI_Minion" and unit.type == "obj_AI_Turret") then
	    local HitFirst = false
		shottype,radius,maxdistance = 0,0,0
		if unit.type == "AIHeroClient" then
			spelltype, casttype = getSpellType(unit, spell.name)			
            if (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R") and SejuaniMenu.evade.AutoEvadeCast[unit.charName .. spelltype] then
				HitFirst = skillShield[unit.charName][spelltype]["HitFirst"]
				Shield = skillShield[unit.charName][spelltype]["Shield"]
				shottype = skillData[unit.charName][spelltype]["type"]
				radius = skillData[unit.charName][spelltype]["radius"]
				maxdistance = skillData[unit.charName][spelltype]["maxdistance"]
			end
		end
		 for i=1, heroManager.iCount do
			local allytarget = heroManager:GetHero(i)
			if allytarget.team == myHero.team and not allytarget.dead and allytarget.health > 0 then
			    hitchampion = false
			    local allyHitBox = allytarget.boundingRadius
			    if shottype == 1 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			    elseif shottype == 2 then hitchampion = checkhitlinepoint(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			    elseif shottype == 3 then hitchampion = checkhitaoe(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			    elseif shottype == 4 then hitchampion = checkhitcone(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			    elseif shottype == 5 then hitchampion = checkhitwall(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			    elseif shottype == 6 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox) or checkhitlinepass(unit, Vector(unit)*2-spell.endPos, radius, maxdistance, myHero, allyHitBox)
			    elseif shottype == 7 then hitchampion = checkhitcone(spell.endPos, unit, radius, maxdistance, myHero, allyHitBox)
			    end
			    if hitchampion and RREADY and ZileanMenu.advanced.skillR[allytarget.charName] then
				    local ultflag, dmgpercent = shieldCheck(unit,spell,allytarget)
				    if ultflag then
				        if HitFirst and (ULastDistance == nil or GetDistance(allytarget,unit) <= ULastDistance) then
					    	ulttarget,ULastDistance = allytarget,GetDistance(allytarget,unit)
					    elseif not HitFirst and (ULastDmgPercent == nil or dmgpercent >= ULastDmgPercent) then
						    ulttarget,ULastDmgPercent = allytarget,dmgpercent
					    end
				    end
			    end
			end
		end		
    end	
end

function shieldCheck(object,spell,target)
	local shieldflag = false
	if (not ZileanMenu.advanced.skillR.skillshots and shottype ~= 0) then return false, 0 end
	local adamage = object:CalcDamage(target,object.totalDamage)
	local InfinityEdge,onhitdmg,onhittdmg,onhitspelldmg,onhitspelltdmg,muramanadmg,skilldamage,skillTypeDmg = 0,0,0,0,0,0,0,0

	if object.type ~= "AIHeroClient" then
		if spell.name:find("BasicAttack") then skilldamage = adamage
		elseif spell.name:find("CritAttack") then skilldamage = adamage*2 end
	else
		if GetInventoryHaveItem(3186,object) then onhitdmg = getDmg("KITAES",target,object) end
		if GetInventoryHaveItem(3114,object) then onhitdmg = onhitdmg+getDmg("MALADY",target,object) end
		if GetInventoryHaveItem(3091,object) then onhitdmg = onhitdmg+getDmg("WITSEND",target,object) end
		if GetInventoryHaveItem(3057,object) then onhitdmg = onhitdmg+getDmg("SHEEN",target,object) end
		if GetInventoryHaveItem(3078,object) then onhitdmg = onhitdmg+getDmg("TRINITY",target,object) end
		if GetInventoryHaveItem(3100,object) then onhitdmg = onhitdmg+getDmg("LICHBANE",target,object) end
		if GetInventoryHaveItem(3025,object) then onhitdmg = onhitdmg+getDmg("ICEBORN",target,object) end
		if GetInventoryHaveItem(3087,object) then onhitdmg = onhitdmg+getDmg("STATIKK",target,object) end
		if GetInventoryHaveItem(3153,object) then onhitdmg = onhitdmg+getDmg("RUINEDKING",target,object) end
		if GetInventoryHaveItem(3209,object) then onhittdmg = getDmg("SPIRITLIZARD",target,object) end
		if GetInventoryHaveItem(3184,object) then onhittdmg = onhittdmg+80 end
		if GetInventoryHaveItem(3042,object) then muramanadmg = getDmg("MURAMANA",target,object) end
		if spelltype == "BAttack" then
			skilldamage = (adamage+onhitdmg+muramanadmg)*1.07+onhittdmg
		elseif spelltype == "CAttack" then
			if GetInventoryHaveItem(3031,object) then InfinityEdge = .5 end
			skilldamage = (adamage*(2.1+InfinityEdge)+onhitdmg+muramanadmg)*1.07+onhittdmg --fix Lethality
		elseif spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" or spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM" then
			if GetInventoryHaveItem(3151,object) then onhitspelldmg = getDmg("LIANDRYS",target,object) end
			if GetInventoryHaveItem(3188,object) then onhitspelldmg = getDmg("BLACKFIRE",target,object) end
			if GetInventoryHaveItem(3209,object) then onhitspelltdmg = getDmg("SPIRITLIZARD",target,object) end
			muramanadmg = skillShield[object.charName][spelltype]["Muramana"] and muramanadmg or 0
			if casttype == 1 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object,1,spell.level)
			elseif casttype == 2 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object,2,spell.level)
			elseif casttype == 3 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object,3,spell.level)
			end
			if skillTypeDmg == 2 then
				skilldamage = (skilldamage+adamage+onhitspelldmg+onhitdmg+muramanadmg)*1.07+onhittdmg+onhitspelltdmg
			else
				if skilldamage > 0 then skilldamage = (skilldamage+onhitspelldmg+muramanadmg)*1.07+onhitspelltdmg end
			end
		elseif spell.name:find("summonerdot") then
			skilldamage = getDmg("IGNITE",target,object)
		end
	end
	local dmgpercent = skilldamage*100/target.health
	local dmgneeded = dmgpercent >= ZileanMenu.advanced.skillR.mindmgpercent
	local hpneeded = ZileanMenu.advanced.skillR.maxhppercent >= (target.health-skilldamage)*100/target.maxHealth
	
	if dmgneeded and hpneeded then
		shieldflag = true
	end
	return shieldflag, dmgpercent
end

function GetTrueRange(unit)
    --return unit.range + GetDistance(unit.minBBox) + 300
	return 900
end

function isFacing(source, target, lineLength)
    local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
    local sourcePos = Vector(source.x, source.z)
    sourceVector = (sourceVector-sourcePos):normalized()
    sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
    return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
end

function GetAllyAD()
	local attackdamage = 0
	local closestAD = nil
	for i, ally in pairs(GetAllyHeroes()) do
		if not ally.dead and ally.totalDamage >= attackdamage and GetDistance(ally) < 900 then 
			attackdamage = ally.totalDamage
			closestAD = ally
		end
	end
	return closestAd
end

function AutoW()
    if myHero.mana < myHero.maxMana * (ZileanMenu.advanced.skillW.manaSlider / 100) then return end
	if WREADY and RCooldow > 3 and not isRecalling then
	    CastSpell(_W)
	end
end

function OnCreateObj(obj)
	if GetDistance(myHero, obj) < 50 and obj.name:lower():find("teleporthome") then
		isRecalling = true
	end
end

function OnDeleteObj(obj)
	if GetDistance(myHero, obj) < 50 and obj.name:lower():find("teleporthome") then
		DelayAction(function() isRecalling = false end, 0.5)
	end
end

function AutoR()
    for i = 1, heroManager.iCount do
        local myAlly = heroManager:GetHero(i)
        if myAlly.team == myHero.team and not myAlly.dead and myAlly.health > 0 then
            if ZileanMenu.advanced.skillR[myAlly.charName] and RREADY then
                if CountEnemyHeroInRange(700, myAlly) >= ZileanMenu.advanced.skillR.Renemies and myAlly.health < myAlly.maxHealth * (ZileanMenu.advanced.skillR.Rhealth / 100) then
                    CastR(myAlly)
                elseif 0 < CountEnemyHeroInRange(500, myAlly) and myAlly.health < myAlly.maxHealth * (ZileanMenu.advanced.skillR.Rhealth / 100) - 100 then
                    CastR(myAlly)
                end
				if ulttarget ~= nil and ulttarget == myAlly then
				    CastR(myAlly)
			    end
            end
        end
	end
end

function CastR(unit)
    if RREADY and GetDistance(unit) <= Ranges.R then
	    CastSpell(_R,unit)
	end
end

function Killsteal()
    for i, enemy in pairs (GetEnemyHeroes()) do
	    if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible  then
		    if ignite ~= nil and enemy.health <= CalDmg(enemy, "IGNITE") and ZileanMenu.ks.ignite and GetDistance(enemy) < 600 then
                CastSpell(ignite, enemy)
			end
		    if enemy.health <= CalDmg(enemy, "Q") then
 		        if ZileanMenu.ks.Qks then
			        CastQ(enemy)
			    end
			end
			if enemy.health <= CalDmg(enemy, "Q")*2 then
 		        if ZileanMenu.ks.Qks and WREADY then
			        QWQ(enemy)
			    end
            end
        end
    end		
end

function OnDraw()
    if myHero.dead then return end
	
    if QREADY and ZileanMenu.draw.drawQRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.Q12, ARGB(255, 38, 38, 255))
    end
    if EREADY and ZileanMenu.draw.drawERange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.E, ARGB(255, 255, 255, 255))
    end
    if RREADY and ZileanMenu.draw.drawRRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.R, ARGB(255, 255, 38, 38))
    end
    if Target ~= nil and ZileanMenu.draw.drawTarget then
        DrawCircle(Target.x, Target.y, Target.z, GetDistance(Target.minBBox, Target.maxBBox) / 2, ARGB(100,76,255,76))
    end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8, round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then
    	return math.floor(num + 0.5)
	else
    	return math.ceil(num - 0.5)
	end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({x = sPos.x,y = sPos.y}, {x = sPos.x,y = sPos.y}) then
    	DrawCircleNextLvl(x, y, z, radius, 1, color, ZileanMenu.draw.CL)
	end
end
