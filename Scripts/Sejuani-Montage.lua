if myHero.charName ~= "Sejuani" then return end

local version = "0.08"
local Author = "Tungkh1711"
local UPDATE_NAME = "Sejuani-Montage"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/tungkh1711/bolscript/master/Sejuani-Montage.version" .. "?rand=" .. math.random(1, 10000)
local UPDATE_PATH2 = "/tungkh1711/bolscript/master/Sejuani-Montage.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH2
local SpellList = false
_G.UseUpdater = true

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
if SpellList then return end

---------------------------------------

local REQUIRED_LIBS = {
		["VPrediction"] = "https://raw.githubusercontent.com/SidaBoL/Chaos/master/VPrediction.lua",
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
local AARange = 150
local Ranges = {Q = 650,      W = AARange,     E = 1000,     R = 1100  }
local Widths = {Q = 75,       W = 350,         E = 0,        R = 150   }
local Delays = {Q = 0.25,     W = 0.5,         E = 0.25,     R = 0.25  }
local Speeds = {Q = 2000,     W = 1500,        E = 2000,     R = 1500  }
local RWidth = {150, 250, 350}
-- Spell Check
-- Selector
local TargetLock
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "Sejuani",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local EnemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)

local JungleMobs = {}
local JungleFocusMobs = {}

local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1300, DAMAGE_MAGIC)
ts.name = "Sejuani"
local Target = nil
local VPHitChance = 2
local isRecalling = false

---------------------
function OnLoad()
    Vars()
	JungleNames()
    Menu()
	OrbwalkMenu()
	PermaShow()
	PrintChat("<font color='#0000FF'> >>Sejuani-Montage Successfully Loaded! <<</font>")
end

function Vars()
    VP = VPrediction()
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

	SejuaniMenu = scriptConfig("Sejuani-Montage", "SejuaniMontage")
	
	SejuaniMenu:addSubMenu("Sejuani - Combo Settings", "combo")
		SejuaniMenu.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		SejuaniMenu.combo:addParam("GankerMode", "Combo Mode: On = Ganker, Off = FullCombo", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("G"))
		SejuaniMenu.combo:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.combo:addParam("useW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.combo:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.combo:addParam("useR", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
	SejuaniMenu:addSubMenu("Sejuani - Killsteal Settings", "ks")
		SejuaniMenu.ks:addParam("killsteal", "Enable KS", SCRIPT_PARAM_ONOFF, false)
		SejuaniMenu.ks:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.ks:addParam("Qks", "KS with Q", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.ks:addParam("Eks", "KS with E", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.ks:addParam("Rks", "KS with R", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.ks:addParam("gapclose", "Use Gapcloser Q", SCRIPT_PARAM_ONOFF, true)
	SejuaniMenu:addSubMenu("Sejuani - Farming Settings", "farm")
		SejuaniMenu.farm:addParam("farmKey", "Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		SejuaniMenu.farm:addParam("farmtoggle", "Farm Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Z"))
		SejuaniMenu.farm:addParam("farmQ", "Farm With Q", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.farm:addParam("farmW", "Farm With W", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.farm:addParam("farmE", "Farm With E", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.farm:addParam("manaSlider", "Min. mana percent to use skills", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	SejuaniMenu:addSubMenu("Sejuani - Jung/Clear Settings", "clear")
	    SejuaniMenu.clear:addParam("clearKey", "Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		SejuaniMenu.clear:addParam("clearQ", "Clear With Q", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.clear:addParam("clearW", "Clear With W", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.clear:addParam("clearE", "Clear With E", SCRIPT_PARAM_ONOFF, true)
	SejuaniMenu:addSubMenu("Sejuani - Skills Setings", "advanced")
	    SejuaniMenu.advanced:addSubMenu("Skill Q Setings", "skillQ")
		SejuaniMenu.advanced.skillQ:addParam("turret", "Use Q under turret", SCRIPT_PARAM_ONOFF, false)
	    SejuaniMenu.advanced:addSubMenu("Auto-E Setings", "skillE")
		SejuaniMenu.advanced.skillE:addParam("AutoE", "Enabled Auto E", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.advanced.skillE:addParam("HitE", "Auto-E if hit x enemies", SCRIPT_PARAM_SLICE, 2, 1, 5)
		SejuaniMenu.advanced:addSubMenu("Auto-R Setings", "skillR")
		SejuaniMenu.advanced.skillR:addParam("AutoR", "Enabled Auto R", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.advanced.skillR:addParam("turret", "Use R under turret", SCRIPT_PARAM_ONOFF, false)
		SejuaniMenu.advanced.skillR:addParam("xEnemies", "Auto-R if hit x enemies", SCRIPT_PARAM_SLICE, 2, 1, 5)
		SejuaniMenu.advanced.skillR:addParam("AutoRally", "Auto-R if allies near enemies ", SCRIPT_PARAM_ONOFF, true)
		SejuaniMenu.advanced.skillR:addParam("xNumber", "number of allies: ", SCRIPT_PARAM_SLICE, 1, 1, 5)
		SejuaniMenu.advanced.skillR:addParam("xRange", "Range of allies: ", SCRIPT_PARAM_SLICE, 600, 0, 1100, 1)
		SejuaniMenu.advanced.skillR:addParam("useQ", "Use Q for best cast R", SCRIPT_PARAM_ONOFF, true)
	SejuaniMenu:addSubMenu("Sejuani - Miscellaneous Setings", "misc")
		SejuaniMenu.misc:addParam("HitChance", "Chose hitChance for VPrediction", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
	SejuaniMenu:addSubMenu("Sejuani - Evade Setting", "evade")
		SejuaniMenu.evade:addSubMenu("Evade using Q Cast", "AutoEvadeCast")
        for i, enemy in ipairs(GetEnemyHeroes()) do
		    local SpellId = "Q"
   		    local EnemyName = enemy.charName
   		    SejuaniMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "W"
  		    SejuaniMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "E"
  		    SejuaniMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "R"
   		    SejuaniMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, true)
		end
		SejuaniMenu.evade:addParam("qCast", "Cast Q", SCRIPT_PARAM_ONOFF, true)
	SejuaniMenu:addSubMenu("Sejuani - Draw Setings", "draw")
        SejuaniMenu.draw:addParam("drawQRange", "Draw (Q) Range: ", SCRIPT_PARAM_ONOFF, false)
        SejuaniMenu.draw:addParam("drawERange", "Draw (E) Range: ", SCRIPT_PARAM_ONOFF, false)
        SejuaniMenu.draw:addParam("drawRRange", "Draw (R) Range: ", SCRIPT_PARAM_ONOFF, false)
        SejuaniMenu.draw:addParam("drawTarget", "Draw current target: ", SCRIPT_PARAM_ONOFF, false)
        SejuaniMenu.draw:addParam("LagFree", "Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
        SejuaniMenu.draw:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 75, 1, 2000, 0)
	SejuaniMenu:addSubMenu("Sejuani - PermaShow Setings", "PermaShow")	
        SejuaniMenu.PermaShow:addParam("AutoE", "Show AutoE", SCRIPT_PARAM_ONOFF, true)	
        SejuaniMenu.PermaShow:addParam("AutoR", "Show AutoR", SCRIPT_PARAM_ONOFF, true)
        SejuaniMenu.PermaShow:addParam("GankerMode", "Show Ganker Mode Active", SCRIPT_PARAM_ONOFF, true)	
        SejuaniMenu.PermaShow:addParam("KS", "Show KillSteal", SCRIPT_PARAM_ONOFF, true)			
	SejuaniMenu:addTS(ts)
	SejuaniMenu:addParam("Lock", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
end

function OrbwalkMenu()
	SejuaniMenu:addSubMenu("Sejuani - Orbwalk Setings", "Orbwalk")
	SejuaniMenu.Orbwalk:addParam("orbchoice", "Select Orbwalker (Requires Reload)", SCRIPT_PARAM_LIST, 2, { "SOW", "SxOrbWalk", "MMA", "SAC" })
	    if SejuaniMenu.Orbwalk.orbchoice == 1 then
		    require "SOW"
		    SOWi = SOW(VP)
		    SOWi:RegisterAfterAttackCallback(AutoAttackReset) 
		    SOWi:LoadToMenu(SejuaniMenu.Orbwalk)
		end
	    if SejuaniMenu.Orbwalk.orbchoice == 2 then
		    require "SxOrbWalk"
		    SxOrb:LoadToMenu(SejuaniMenu.Orbwalk)
	    end
end

function PermaShow()
	if SejuaniMenu.PermaShow.AutoE then
	    SejuaniMenu.advanced.skillE:permaShow("AutoE")
    end	
	if SejuaniMenu.PermaShow.AutoR then
	    SejuaniMenu.advanced.skillR:permaShow("AutoR")		
    end
	if SejuaniMenu.PermaShow.GankerMode then
	    SejuaniMenu.combo:permaShow("GankerMode")
	end
	if SejuaniMenu.PermaShow.KS then
	    SejuaniMenu.ks:permaShow("killsteal")
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
	
	ComboActive = SejuaniMenu.combo.comboKey
	EscapeActive = SejuaniMenu.combo.escapeKey
	KsActive = SejuaniMenu.ks.killsteal
	FarmActive = SejuaniMenu.farm.farmKey or SejuaniMenu.farm.farmtoggle
	ClearActive = SejuaniMenu.clear.clearKey
	VPHitChance = SejuaniMenu.misc.HitChance
	GankerCombo = SejuaniMenu.combo.GankerMode
	
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
	
	if QREADY then
		ts.range = 1500
	else
		ts.range = 900
	end
	
	EnemyMinions:update()
	JungleMinions:update()
	
	Widths.R = RWidth[myHero:GetSpellData(_R).level]
	
	if not SejuaniMenu.draw.LagFree then
    	_G.DrawCircle = _G.oldDrawCircle
	end
	if SejuaniMenu.draw.LagFree then
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
	if SejuaniMenu.advanced.skillE.AutoE then AutoE() end
	if SejuaniMenu.advanced.skillR.AutoR then AutoR() end
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
  if msg == WM_LBUTTONDOWN and SejuaniMenu.Lock then
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
		print("<font color=\"#FFFFFF\">Sejuani: New target <font color=\"#00FF00\"><b>SELECTED</b></font>: "..current.charName..".</font>")
      end
    end
  end
end

function Combo(target)
    if GankerCombo then
		if GetDistance(target) <= AARange then
			CastW(target)
		end
		if GetDistance(target) >= 350 and (not FrozenBuff(target) or not EREADY or WREADY) and SejuaniMenu.combo.useQ then
			CastQ(target)
		end
		if (not WActive or GetDistance(target) >= 350) and FrozenBuff(target) and SejuaniMenu.combo.useE then
			CastE(target)
		end
	    if CountAllysInRange(900, target) >= 1 then
			if (CountEnemyHeroInRange(Widths.R, target) > 1 or GetDistance(target) > Ranges.Q or (QCooldow > 2 and CountAllysInRange(600, target) >= 1 and GetDistance(target) > Ranges.W)) and SejuaniMenu.combo.useR then
			    CastR(target)
			end	
        end		    
	else
		    if GetDistance(target) <= AARange + 55 then
			    CastW(target)
			end
			if GetDistance(target) >= 350 and WREADY and SejuaniMenu.combo.useQ then
			    CastQ(target)
			end
			if (not WActive or GetDistance(target) >= 350) and FrozenBuff(target) and SejuaniMenu.combo.useE then
			    CastE(target)
			end
			if (CountEnemyHeroInRange(Widths.R, target) > 1 or GetDistance(target) > Ranges.Q) and SejuaniMenu.combo.useR then
			    CastR(target)
			end			        
	end
end

function CountEnemyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and not hero.dead and hero.visible and hero.team ~= myHero.team and GetDistanceSqr(object, hero) <= range then
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

function Killsteal()
    for i, enemy in pairs (GetEnemyHeroes()) do
	    if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible  then
		    if ignite ~= nil and enemy.health <= CalDmg(enemy, "IGNITE") and SejuaniMenu.ks.ignite and GetDistance(enemy) < 600 then
                CastSpell(ignite, enemy)
			end
		    if enemy.health <= CalDmg(enemy, "E") then
 		        if SejuaniMenu.ks.Eks then
			        CastE(enemy)
			    end
			end
            if enemy.health < CalDmg(enemy, "Q") then
 		        if SejuaniMenu.ks.Qks then
		    	    CastQ(enemy)
		    	end
			end
            if enemy.health < CalDmg(enemy, "R") and GetDistance(enemy) < Ranges.R then
 		        if SejuaniMenu.ks.Rks then
		    	    CastR(enemy)
		    	end
			end
            if SejuaniMenu.ks.gapclose and QREADY then
			    local DashPos = myHero + (Vector(enemy) - myHero):normalized() * Ranges.Q
                if enemy.health <= CalDmg(enemy, "E") and GetDistance(enemy) < Ranges.Q + Ranges.E and FrozenBuff(enemy) and SejuaniMenu.ks.Eks then
                    CastSpell(_Q, DashPos.x, DashPos.z)
                end
                if enemy.health < CalDmg(enemy, "R") and GetDistance(enemy) < Ranges.Q + Ranges.R and SejuaniMenu.ks.Rks then
                      CastSpell(_Q, DashPos.x, DashPos.z)
                end 
            end
        end
    end		
end

function CalDmg(unit, spell)
    if not unit or not spell then return end
	if unit ~= nil then
    	local SNAMES = spell:upper()
    	local caldmg = math.round
    	if SNAMES == "Q" then
    		return caldmg(QREADY and getDmg("Q", unit, myHero) or 0) 
    	elseif SNAMES == "W" then
      		return caldmg(WREADY and getDmg("W", unit, myHero) or 0)
   		elseif SNAMES == "E" then
      		return caldmg(EREADY and getDmg("E", unit, myHero) or 0)
		elseif SNAMES == "R" then
      		return caldmg(RREADY and getDmg("R", unit, myHero) or 0)
    	elseif SNAMES == "IGNITE" then
      		return caldmg(IREADY and getDmg("IGNITE", unit, myHero) or 0)
    	end
	end
end

function FrozenBuff(unit)
    if TargetHaveBuff("SejuaniFrost", unit) then
        return true
    else
        return false
	end
end

function CastQ(unit)
    if QREADY then
	    local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
		if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.Q then
		    for i, enemy in ipairs(GetEnemyHeroes()) do
			    if enemy ~= unit and ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy,unit) > Widths.Q then
			        local ColCastPos = VP:CheckCol(unit, enemy, CastPosition, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
				    local ColPredictPos = VP:CheckCol(unit, enemy, Position, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
				    local ColUnitPos = VP:CheckCol(unit, enemy, unit, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
				    if not ColCastPos and not ColPredictPos and not ColUnitPos then
					    if not IsWall(D3DXVECTOR3(CastPosition.x, CastPosition.y, CastPosition.z)) and (not UnderTurret(CastPosition) or SejuaniMenu.advanced.skillQ.turret) then
					        CastSpell(_Q, CastPosition.x, CastPosition.z)
						end
					end
				else
				    if not IsWall(D3DXVECTOR3(CastPosition.x, CastPosition.y, CastPosition.z)) and (not UnderTurret(CastPosition) or SejuaniMenu.advanced.skillQ.turret) then
				        CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end


function CastW(unit)
    if WREADY then
	    CastSpell(_W)
		--myHero:Attack(unit)
	end	    
end

function CastE(unit)
    if EREADY and FrozenBuff(unit) and GetDistance(unit) <= Ranges.E then
	    CastSpell(_E)
	end
end

function CastR(unit)
    if RREADY then
	    local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
		if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.R then
		    for i, enemy in ipairs(GetEnemyHeroes()) do
			    if enemy ~= unit and ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy,unit) > Widths.R then
			        local ColCastPos = VP:CheckCol(unit, enemy, CastPosition, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
				    local ColPredictPos = VP:CheckCol(unit, enemy, Position, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
				    local ColUnitPos = VP:CheckCol(unit, enemy, unit, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
				    if not ColCastPos and not ColPredictPos and not ColUnitPos then
					    if (not UnderTurret(CastPosition) or SejuaniMenu.advanced.skillR.turret) then
					        CastSpell(_R, CastPosition.x, CastPosition.z)
						end
					end
				else
				    if (not UnderTurret(CastPosition) or SejuaniMenu.advanced.skillR.turret) then
				        CastSpell(_R, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end

function Farm()
    if myHero.mana < myHero.maxMana * (SejuaniMenu.farm.manaSlider / 100) then return end
	if SejuaniMenu.farm.farmW then
		WLastHit()
	end
	if SejuaniMenu.farm.farmQ then
		QLastHit()
	end
	if SejuaniMenu.farm.farmE then
		ELastHit()
	end
end

function WLastHit()
	for _, minion in pairs(EnemyMinions.objects) do
		if ValidTarget(minion) then
			if GetDistance(minion, myHero) < Ranges.W then
			    local AAdmg = getDmg("AD", minion, myHero) or 0
				if minion.health <= AAdmg + CalDmg(minion, "W") and WREADY and myHero.canAttack then
		 			CastSpell(_W)
					--myHero.Attack(minion)
			 	end
			 end
		end
	end
end

function QLastHit()
	if QREADY and #EnemyMinions.objects > 2 then
		local QPos = GetBestQPositionFarm()
		if QPos and GetDistance(QPos) <= Ranges.Q then 
			CastSpell(_Q, QPos.x, QPos.z)
		end
	end
end

-- Credit Honda7 
function countminionshitQ(pos)
	local n = 0
	for i, minion in ipairs(EnemyMinions.objects) do
	    if GetDistance(minion, myHero) < Ranges.Q then 
		    if minion.health <= CalDmg(minion, "Q") then 
			    if GetDistance(minion, pos) < Widths.Q then 
				    n = n +1
			    end
		    end
	    end
	end
	return n
end

function countminionshitE()
	local n = 0
	for i, minion in ipairs(EnemyMinions.objects) do
	    if GetDistance(minion, myHero) < Ranges.E and FrozenBuff(minion) then
		    if minion.health <= CalDmg(minion, "E") then
			    n = n +1
			end
		end
	end
	return n
end

function GetBestQPositionFarm()
	local MaxQ = 3
	local MaxQPos 
	for i, minion in pairs(EnemyMinions.objects) do
		local hitQ = countminionshitQ(minion)
		if hitQ >= MaxQ or MaxQPos == nil then
			MaxQPos = minion
			MaxQ = hitQ
		end
	end

	if MaxQPos then
		local CastPosition, HitChance, Position = VP:GetLineAOECastPosition(MaxQPos, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
		return CastPosition
	else
		return nil
	end
end

function ELastHit()
	if EREADY and #EnemyMinions.objects > 2 then
		local hitE = countminionshitE()
		if hitE >= 2 then
		    CastSpell(_E)
		end
	end
end

function Clear()
	FarmClear()
	JungClear()
end

function FarmClear()
    for _, minion in pairs(EnemyMinions.objects) do
		if SejuaniMenu.clear.clearQ and QREADY then
		    local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(minion, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
		    if AOECastPosition then
		        CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
		    end
		end
	    if SejuaniMenu.clear.clearW then
	        if WREADY and #EnemyMinions.objects > 2 then
		        CastSpell(_W)
		    end
		end
		if SejuaniMenu.clear.clearE then
		    ELastHit()
		end
	end
end

function JungClear()
	local JungleMob = GetJungleMob()
	if JungleMob ~= nil then
    	if SejuaniMenu.clear.clearW and WREADY and GetDistance(JungleMob) < Ranges.W then
      		CastSpell(_W)
    	end
    	if SejuaniMenu.clear.clearQ and QREADY and GetDistance(JungleMob) < Ranges.Q then
      		CastSpell(_Q, JungleMob.x, JungleMob.z)
    	end
    	if SejuaniMenu.clear.clearE and EREADY and FrozenBuff(JungleMob) and not QREADY and not WREADY then
      		CastSpell(_E)
    	end
    end
end

function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
    	if ValidTarget(Mob, 500) then
      		return Mob
   		end
  	end
  	for _, Mob in pairs(JungleMobs) do
    	if ValidTarget(Mob, 500) then
      		return Mob
    	end
  	end
end

function OnCreateObj(obj)
    if not obj then return end
  	if FocusJungleNames[obj.name] then
      	table.insert(JungleFocusMobs, obj)
  	elseif JungleMobNames[obj.name] then
      	table.insert(JungleMobs, obj)
  	end
end

function OnDeleteObj(obj)
    if not obj then return end
  	for i, Mob in pairs(JungleMobs) do
      	if obj.name == Mob.name then
        	table.remove(JungleMobs, i)
      	end
  	end
  	for i, Mob in pairs(JungleFocusMobs) do
      	if obj.name == Mob.name then
        	table.remove(JungleFocusMobs, i)
      	end
  	end
end

function JungleNames()
  	local JungMap = false
  	if GetGame().map.shortName == "twistedTreeline" then
      	JungMap = true	    
    end
  	if JungMap then
      	FocusJungleNames = {
        	["TT_NWraith1.1.1"] = true,
        	["TT_NGolem2.1.1"] = true,
        	["TT_NWolf3.1.1"] = true,
        	["TT_NWraith4.1.1"] = true,
        	["TT_NGolem5.1.1"] = true,
        	["TT_NWolf6.1.1"] = true,
        	["TT_Spiderboss8.1.1"] = true
      	}
      	JungleMobNames = {
        	["TT_NWraith21.1.2"] = true,
        	["TT_NWraith21.1.3"] = true,
       	  	["TT_NGolem22.1.2"] = true,
       	  	["TT_NWolf23.1.2"] = true,
       	  	["TT_NWolf23.1.3"] = true,
       	  	["TT_NWraith24.1.2"] = true,
        	["TT_NWraith24.1.3"] = true,
        	["TT_NGolem25.1.1"] = true,
        	["TT_NWolf26.1.2"] = true,
        	["TT_NWolf26.1.3"] = true
      	}
  	else
		JungleMobNames = {
        	["SRU_Baron12.1.1"] = true,
        	["SRU_Dragon6.1.1"] = true,
        	["SRU_Blue1.1.1"] = true,
        	["SRU_Blue7.1.1"] = true,
        	["SRU_BlueMini1.1.2"] = true,
        	["SRU_BlueMini21.1.3"] = true,
        	["SRU_BlueMini27.1.3"] = true,
        	["SRU_BlueMini7.1.2"] = true,
        	["SRU_Red4.1.1"] = true,
        	["SRU_Red10.1.1"] = true,
        	["SRU_RedMini4.1.2"] = true,
        	["SRU_RedMini4.1.3"] = true,
        	["SRU_RedMini10.1.2"] = true,
        	["SRU_RedMini10.1.3"] = true,
        	["SRU_Murkwolf2.1.1"] = true,
        	["SRU_Murkwolf8.1.1"] = true,
        	["SRU_MurkwolfMini2.1.2"] = true,
        	["SRU_MurkwolfMini2.1.3"] = true,
        	["SRU_MurkwolfMini8.1.2"] = true,
        	["SRU_MurkwolfMini8.1.3"] = true,
        	["SRU_Razorbeak3.1.1"] = true,
        	["SRU_Razorbeak9.1.1"] = true,
        	["SRU_RazorbeakMini3.1.2"] = true,
        	["SRU_RazorbeakMini3.1.3"] = true,
        	["SRU_RazorbeakMini3.1.4"] = true,
        	["SRU_RazorbeakMini9.1.2"] = true,
        	["SRU_RazorbeakMini9.1.3"] = true,
        	["SRU_RazorbeakMini9.1.4"] = true,
        	["SRU_Krug5.1.2"] = true,
        	["SRU_Krug11.1.2"] = true,
        	["SRU_KrugMini5.1.1"] = true,
        	["SRU_KrugMini11.1.1"] = true,
        	["SRU_Gromp14.1.1"] = true,
        	["SRU_Gromp13.1.1"] = true,
        	["Sru_Crab15.1.1"] = true,
        	["Sru_Crab16.1.1"] = true
		}
		FocusJungleNames = {
		    ["SRU_Baron12.1.1"] = true,
        	["SRU_Dragon6.1.1"] = true,
        	["SRU_Blue1.1.1"] = true,
        	["SRU_Blue7.1.1"] = true,
        	["SRU_Red4.1.1"] = true,
        	["SRU_Red10.1.1"] = true,
        	["SRU_Murkwolf2.1.1"] = true,
        	["SRU_Murkwolf8.1.1"] = true,
        	["SRU_Razorbeak3.1.1"] = true,
        	["SRU_Razorbeak9.1.1"] = true,
        	["SRU_Krug5.1.2"] = true,
        	["SRU_Krug11.1.2"] = true,
        	["SRU_Gromp14.1.1"] = true,
        	["SRU_Gromp13.1.1"] = true,
			 ["Sru_Crab15.1.1"] = true,
        	["Sru_Crab16.1.1"] = true
		}
	end
  	for i = 0, objManager.maxObjects do
      	local object = objManager:getObject(i)
      	if object ~= nil then
        	if FocusJungleNames[object.name] then
          	  	table.insert(JungleFocusMobs, object)
        	elseif JungleMobNames[object.name] then
          	  	table.insert(JungleMobs, object)
        	end
      	end
  	end
end

function AutoE()
    if EREADY then
	    local hitE = countenemieshitE()
		if hitE >= SejuaniMenu.advanced.skillE.HitE then
		    CastSpell(_E)
		end
	end
end

function countenemieshitE()
	local n = 0
	for i, enemy in ipairs(GetEnemyHeroes()) do
	    if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy, myHero) <= Ranges.E and FrozenBuff(enemy) then
		    n = n +1
		end
	end
	return n
end

function AutoR()
    if RREADY then
	    for i, enemy in ipairs(GetEnemyHeroes()) do
		    if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible then
			    if SejuaniMenu.advanced.skillR.useQ and GetDistance(enemy) <= Ranges.Q + Ranges.R and QREADY and RREADY then
				    local EnemyInRange = CountEnemyHeroInRange(Widths.R + 55, enemy)
					if EnemyInRange >= SejuaniMenu.advanced.skillR.xEnemies then
		                local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(enemy, Delays.R + Delays.Q, Widths.R, Ranges.R + Ranges.Q, Speeds.R, myHero, false)
					    if AOECastPosition and MainTargetHitChance >= VPHitChance and nTargets >= SejuaniMenu.advanced.skillR.xEnemies and GetDistance(AOECastPosition) <= Ranges.Q + Ranges.R then
					        for j, enemyx in ipairs(GetEnemyHeroes()) do
							    if enemyx ~= enemy and ValidTarget(enemyx) and not enemyx.dead and enemyx.visible and GetDistance(enemyx,enemy) > Widths.R then
								    local ColCastPos = VP:CheckCol(enemy, enemyx, AOECastPosition, Delays.R + Delays.Q, Widths.R, Ranges.R + Ranges.Q, Speeds.R, myHero, false)
									local ColUnitPos = VP:CheckCol(enemy, enemyx, enemy, Delays.R + Delays.Q, Widths.R, Ranges.R + Ranges.Q, Speeds.R, myHero, false)
									if not ColCastPos and not ColUnitPos then
									    if CountAllysInRange(SejuaniMenu.advanced.skillR.xRange, enemy) >= SejuaniMenu.advanced.skillR.xNumber then
										    local DashPos = myHero + (Vector(enemy) - myHero):normalized() * Ranges.Q
											CastSpell(_Q, DashPos.x, DashPos.z)
											if not QREADY and GetDistance(AOECastPosition) <= Ranges.R then
											    CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
											end
										end
									end
								else
									if CountAllysInRange(SejuaniMenu.advanced.skillR.xRange, enemy) >= SejuaniMenu.advanced.skillR.xNumber then
										local DashPos = myHero + (Vector(enemy) - myHero):normalized() * Ranges.Q
										CastSpell(_Q, DashPos.x, DashPos.z)
										if not QREADY and GetDistance(AOECastPosition) <= Ranges.R then
											CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
										end
									end
								end
							end
						end
					end
				end
				if GetDistance(enemy) <= Ranges.R and RREADY then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(enemy, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)				
					if AOECastPosition and MainTargetHitChance >= VPHitChance and nTargets >= SejuaniMenu.advanced.skillR.xEnemies and GetDistance(AOECastPosition) <= Ranges.R then
					    for j, enemyx in ipairs(GetEnemyHeroes()) do
						    if enemyx ~= enemy and ValidTarget(enemyx) and not enemyx.dead and enemyx.visible and GetDistance(enemyx,enemy) > Widths.R then
							    local ColCastPos = VP:CheckCol(enemy, enemyx, AOECastPosition, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
								local ColUnitPos = VP:CheckCol(enemy, enemyx, enemy, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
								if not ColCastPos and not ColUnitPos then
								    if CountAllysInRange(SejuaniMenu.advanced.skillR.xRange, enemy) >= SejuaniMenu.advanced.skillR.xNumber then
									    CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
									end
								end
							else
								if CountAllysInRange(SejuaniMenu.advanced.skillR.xRange, enemy) >= SejuaniMenu.advanced.skillR.xNumber then
									CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
								end
							end
						end
					end
				end
            end
		end
	end
end

function OnProcessSpell(unit, spell)
    if unit and unit.isMe and spell.name == "SejuaniNorthernWinds" then
	    if WREADY then
		    CastSpell(_W)
		end
	end
    if unit.team ~= myHero.team and not myHero.dead and not (unit.type == "obj_AI_Minion" and unit.type == "obj_AI_Turret") then
		shottype,radius,maxdistance = 0,0,0
		if unit.type == "AIHeroClient" then
			spelltype, casttype = getSpellType(unit, spell.name)			
            if (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R") and SejuaniMenu.evade.AutoEvadeCast[unit.charName .. spelltype] then
				shottype = skillData[unit.charName][spelltype]["type"]
				radius = skillData[unit.charName][spelltype]["radius"]
				maxdistance = skillData[unit.charName][spelltype]["maxdistance"]
			end
		end
		if not myHero.dead and myHero.health > 0 then
			hitchampion = false
			local allyHitBox = myHero.boundingRadius
			if shottype == 1 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 2 then hitchampion = checkhitlinepoint(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 3 then hitchampion = checkhitaoe(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 4 then hitchampion = checkhitcone(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 5 then hitchampion = checkhitwall(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 6 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox) or checkhitlinepass(unit, Vector(unit)*2-spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 7 then hitchampion = checkhitcone(spell.endPos, unit, radius, maxdistance, myHero, allyHitBox)
			end
			if hitchampion and QREADY and SejuaniMenu.evade.AutoEvadeCast[unit.charName .. spelltype] then
				local evadePos = PointT(mousePos.x, mousePos.z)
				local myPos = PointT(myHero.x, myHero.z)
				local ourdistance = evadePos:distance(myPos)
				local dashPos = myPos - (myPos - evadePos):normalized() * Ranges.Q
		
				x = dashPos.x
				y = dashPos.y
						
				if QREADY and SejuaniMenu.evade.qCast then
					CastSpell(_Q, x, y)
				end
			end
		end		
    end	
end

function OnDraw()
    if myHero.dead then return end
	
    if QREADY and SejuaniMenu.draw.drawQRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.Q12, ARGB(255, 38, 38, 255))
    end
    if EREADY and SejuaniMenu.draw.drawERange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.E, ARGB(255, 255, 255, 255))
    end
    if RREADY and SejuaniMenu.draw.drawRRange then
        DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.R, ARGB(255, 255, 38, 38))
    end
    if Target ~= nil and SejuaniMenu.draw.drawTarget then
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
    	DrawCircleNextLvl(x, y, z, radius, 1, color, SejuaniMenu.draw.CL)
	end
end

-- Globals ---------------------------------------------------------------------

uniqueId2 = 0

-- Code ------------------------------------------------------------------------

class 'PointT' -- {
    function PointT:__init(x, y)
        uniqueId2 = uniqueId2 + 1
        self.uniqueId2 = uniqueId2

        self.x = x
        self.y = y

        self.points = {self}
    end

    function PointT:__type()
        return "PointT"
    end

    function PointT:__eq(spatialObject)
        return spatialObject:__type() == "PointT" and self.x == spatialObject.x and self.y == spatialObject.y
    end

    function PointT:__unm()
        return PointT(-self.x, -self.y)
    end

    function PointT:__add(p)
        return PointT(self.x + p.x, self.y + p.y)
    end

    function PointT:__sub(p)
        return PointT(self.x - p.x, self.y - p.y)
    end

    function PointT:__mul(p)
        if type(p) == "number" then
            return PointT(self.x * p, self.y * p)
        else
            return PointT(self.x * p.x, self.y * p.y)
        end
    end

    function PointT:tostring()
        return "PointT(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
    end

    function PointT:__div(p)
        if type(p) == "number" then
            return PointT(self.x / p, self.y / p)
        else
            return PointT(self.x / p.x, self.y / p.y)
        end
    end

    function PointT:between(point1, PointT)
        local normal = Line2(point1, PointT):normal()

        return Line2(point1, point1 + normal):side(self) ~= Line2(PointT, PointT + normal):side(self)
    end

    function PointT:len()
        return math.sqrt(self.x * self.x + self.y * self.y)
    end

    function PointT:normalize()
        len = self:len()

        self.x = self.x / len
        self.y = self.y / len

        return self
    end

    function PointT:clone()
        return PointT(self.x, self.y)
    end

    function PointT:normalized()
        local a = self:clone()
        a:normalize()
        return a
    end

    function PointT:getPoints()
        return self.points
    end

    function PointT:getLineSegments()
        return {}
    end

    function PointT:perpendicularFoot(line)
        local distanceFromLine = line:distance(self)
        local normalVector = line:normal():normalized()

        local footOfPerpendicular = self + normalVector * distanceFromLine
        if line:distance(footOfPerpendicular) > distanceFromLine then
            footOfPerpendicular = self - normalVector * distanceFromLine
        end

        return footOfPerpendicular
    end

    function PointT:contains(spatialObject)
        if spatialObject:__type() == "Line2" then
            return false
        elseif spatialObject:__type() == "Circle2" then
            return spatialObject.point == self and spatialObject.radius == 0
        else
        for i, point in ipairs(spatialObject:getPoints()) do
            if point ~= self then
                return false
            end
        end
    end

        return true
    end

    function PointT:polar()
        if math.close(self.x, 0) then
            if self.y > 0 then return 90
            elseif self.y < 0 then return 270
            else return 0
            end
        else
            local theta = math.deg(math.atan(self.y / self.x))
            if self.x < 0 then theta = theta + 180 end
            if theta < 0 then theta = theta + 360 end
            return theta
        end
    end

    function PointT:insideOf(spatialObject)
        return spatialObject.contains(self)
    end

    function PointT:distance(spatialObject)
        if spatialObject:__type() == "PointT" then
            return math.sqrt((self.x - spatialObject.x)^2 + (self.y - spatialObject.y)^2)
        elseif spatialObject:__type() == "Line2" then
            denominator = (spatialObject.points[2].x - spatialObject.points[1].x)
            if denominator == 0 then
                return math.abs(self.x - spatialObject.points[2].x)
            end

            m = (spatialObject.points[2].y - spatialObject.points[1].y) / denominator

            return math.abs((m * self.x - self.y + (spatialObject.points[1].y - m * spatialObject.points[1].x)) / math.sqrt(m * m + 1))
        elseif spatialObject:__type() == "Circle2" then
            return self:distance(spatialObject.point) - spatialObject.radius
        elseif spatialObject:__type() == "LineSegment2" then
            local t = ((self.x - spatialObject.points[1].x) * (spatialObject.points[2].x - spatialObject.points[1].x) + (self.y - spatialObject.points[1].y) * (spatialObject.points[2].y - spatialObject.points[1].y)) / ((spatialObject.points[2].x - spatialObject.points[1].x)^2 + (spatialObject.points[2].y - spatialObject.points[1].y)^2)

            if t <= 0.0 then
                return self:distance(spatialObject.points[1])
            elseif t >= 1.0 then
                return self:distance(spatialObject.points[2])
            else
                return self:distance(Line2(spatialObject.points[1], spatialObject.points[2]))
            end
        else
            local minDistance = nil

            for i, lineSegment in ipairs(spatialObject:getLineSegments()) do
                if minDistance == nil then
                    minDistance = self:distance(lineSegment)
                else
                    minDistance = math.min(minDistance, self:distance(lineSegment))
                end
            end

            return minDistance
        end
    end
-- }

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
