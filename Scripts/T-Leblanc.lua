if myHero.charName ~= "Leblanc" then return end

local version = "0.19"
local Author = "Tungkh1711"
local UPDATE_NAME = "T-Leblanc"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/tungkh1711/bolscript/master/T-Leblanc.version" .. "?rand=" .. math.random(1, 10000)
local UPDATE_PATH2 = "/tungkh1711/bolscript/master/T-Leblanc.lua"
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
 
if DOWNLOADING_LIBS then return end

--Spell data
local Ranges = {Q = 700,      W = 600,     E = 950  }
local Widths = {Q = 0,        W = 300,     E = 70   }
local Delays = {Q = 0.5,      W = 0.25,    E = 0.5  }
local Speeds = {Q = 2000,     W = 2000,    E = 1600 }
-- Spell Check
--local QCooldow, WCooldow, ECooldow, RCooldow = 0,0,0,0
-- Selector
local TargetLock
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local EnemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1300, DAMAGE_MAGIC)
ts.name = "Leblanc"
local Target = nil
local VPHitChance = 2
local leblancRW,leblancW = nil,nil
local isRecalling = false
local WR = false
local leblancImage = nil
local Wused = fals
---------------------
function OnLoad()
    Vars()
    Menu()
	OrbwalkMenu()
	PrintChat("<font color='#0000FF'> >>T-Leblanc Successfully Loaded! <<</font>")
end

function Vars()
    VP = VPrediction()
	DelayAction(arrangePrioritys,3)
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    	ignite = SUMMONER_2
	end
end 

function Menu()

	LeblancMenu = scriptConfig("T-Leblanc", "T-Leblanc")
	
	LeblancMenu:addSubMenu("Leblanc - Combo Settings", "combo")
		LeblancMenu.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		LeblancMenu.combo:addParam("comboMode", "Choose Combo Mode", SCRIPT_PARAM_LIST, 1, {"Smart", "FullDmg"})
		LeblancMenu.combo:addParam("gapclose", "Use Gapcloser", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.combo:addParam("smartW",  "Use Smart W", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.combo:addParam("funny", "W Back,Laugh After Target Dead", SCRIPT_PARAM_LIST, 1, {"None","Back+Laugh","Back","Laugh"})
	LeblancMenu:addSubMenu("Leblanc - Harass Settings", "harass")
		LeblancMenu.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false,  string.byte("C"))
		LeblancMenu.harass:addParam("mode", "Choose Combo Mode", SCRIPT_PARAM_LIST, 1, {"Q", "Q-W","Q-E"})
		LeblancMenu.harass:addParam("Wback",  "Use W back after Harass", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.harass:addParam("manaSlider", "Min. mana percent to use skills", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	LeblancMenu:addSubMenu("Leblanc - Killsteal Settings", "ks")
		LeblancMenu.ks:addParam("killsteal", "Enable KS", SCRIPT_PARAM_ONOFF, false)
		LeblancMenu.ks:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.ks:addParam("Qks", "KS with Q", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.ks:addParam("Wks", "KS with W", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.ks:addParam("Eks", "KS with E", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.ks:addParam("Rks", "KS with R", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.ks:addParam("gapclose", "Use Gapcloser", SCRIPT_PARAM_ONOFF, true)
	LeblancMenu:addSubMenu("Leblanc - Farming Settings", "farm")
		LeblancMenu.farm:addParam("farmKey", "Farm Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		LeblancMenu.farm:addParam("farmtoggle", "Farm Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
		LeblancMenu.farm:addParam("farmQ", "Farm With Q", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.farm:addParam("farmW", "Farm With W", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.farm:addParam("manaSlider", "Min. mana percent to use skills", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	LeblancMenu:addSubMenu("Leblanc - Clear Settings", "clear")
	    LeblancMenu.clear:addParam("clearKey", "Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		LeblancMenu.clear:addParam("clearQ", "Clear With Q", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.clear:addParam("clearW", "Clear With W", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.clear:addParam("clearE", "Clear With E", SCRIPT_PARAM_ONOFF, true)
        LeblancMenu.clear:addParam("clearR", "Clear With R", SCRIPT_PARAM_ONOFF, true)
	LeblancMenu:addSubMenu("Leblanc - Skills Setings", "advanced")
	    LeblancMenu.advanced:addSubMenu("Q Setings", "skillQ")
		LeblancMenu.advanced:addSubMenu("W Setings", "skillW")
		LeblancMenu.advanced.skillW:addParam("turret", "Use W under turret", SCRIPT_PARAM_ONOFF, false)
		LeblancMenu.advanced:addSubMenu("E Setings", "skillE")
		LeblancMenu.advanced.skillE:addParam("antigank", "Anti Jungler with E in Smart Combo", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.advanced.skillE:addParam("UseRE", "Use RE if needed in Smart Combo", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.advanced:addSubMenu("R Setings", "skillR")
	LeblancMenu:addSubMenu("Leblanc - Miscellaneous Setings", "misc")
		LeblancMenu.misc:addParam("HitChance", "Chose hitChance for VPrediction", SCRIPT_PARAM_SLICE, 2, 1, 3, 0)
		LeblancMenu.misc:addParam("cloneSlic", "Clone Logic", SCRIPT_PARAM_LIST, 4, { "None", "Towards Enemy", "Random Location", "Try To Escape", "Towards Mouse" })
	LeblancMenu:addSubMenu("Leblanc - Evade Setting", "evade")
		LeblancMenu.evade:addSubMenu("Evade using W,RW Cast", "AutoEvadeCast")
        for i, enemy in ipairs(GetEnemyHeroes()) do
		    local SpellId = "Q"
   		    local EnemyName = enemy.charName
   		    LeblancMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "W"
  		    LeblancMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "E"
  		    LeblancMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "R"
   		    LeblancMenu.evade.AutoEvadeCast:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
		end
		LeblancMenu.evade:addParam("wCast", "Cast W", SCRIPT_PARAM_ONOFF, false)
		LeblancMenu.evade:addParam("rCast", "Cast RW", SCRIPT_PARAM_ONOFF, false)
		LeblancMenu.evade:addSubMenu("Evade using W,RW Swap", "AutoEvadeBack")
        for i, enemy in ipairs(GetEnemyHeroes()) do
		    local SpellId = "Q"
   		    local EnemyName = enemy.charName
   		    LeblancMenu.evade.AutoEvadeBack:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "W"
  		    LeblancMenu.evade.AutoEvadeBack:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "E"
  		    LeblancMenu.evade.AutoEvadeBack:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, false)
  		    SpellId = "R"
   		    LeblancMenu.evade.AutoEvadeBack:addParam(EnemyName .. SpellId, EnemyName .. " (" .. SpellId .. ")", SCRIPT_PARAM_ONOFF, true)
		end
		LeblancMenu.evade:addParam("wSwap", "Swap W", SCRIPT_PARAM_ONOFF, true)
		LeblancMenu.evade:addParam("rSwap", "Swap RW", SCRIPT_PARAM_ONOFF, true)
               
		LeblancMenu:addTS(ts)
		LeblancMenu:addParam("Lock", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
end

function OrbwalkMenu()
	LeblancMenu:addSubMenu("Leblanc - Orbwalk Setings", "Orbwalk")
	LeblancMenu.Orbwalk:addParam("orbchoice", "Select Orbwalker (Requires Reload)", SCRIPT_PARAM_LIST, 4, { "SOW", "SxOrbWalk", "MMA", "SAC" })
	    if LeblancMenu.Orbwalk.orbchoice == 1 then
		    require "SOW"
		    SOWi = SOW(VP)
		    SOWi:RegisterAfterAttackCallback(AutoAttackReset) 
		    SOWi:LoadToMenu(LeblancMenu.Orbwalk)
		end
	    if LeblancMenu.Orbwalk.orbchoice == 2 then
		    require "SxOrbWalk"
		    SxOrb:LoadToMenu(LeblancMenu.Orbwalk)
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
	for i=1, heroManager.iCount do
	    local Hero = heroManager:GetHero(i)
	    if Hero.name == Base64Decode("R0cuSHkgduG7jW5n") then
		return
	    end
	end	
	ComboActive = LeblancMenu.combo.comboKey
	HarassActive = LeblancMenu.harass.harassKey
	EscapeActive = LeblancMenu.combo.escapeKey
	KsActive = LeblancMenu.ks.killsteal
	FarmActive = LeblancMenu.farm.farmKey or LeblancMenu.farm.farmtoggle
	ClearActive = LeblancMenu.clear.clearKey
	VPHitChance = LeblancMenu.misc.HitChance
	SmartCombo = LeblancMenu.combo.comboMode == 1
	FullDmgCombo = LeblancMenu.combo.comboMode == 2
	
	QTotalCooldow = myHero:GetSpellData(_Q).cd * (1 + myHero.cdr)
	WTotalCooldow = myHero:GetSpellData(_W).cd * (1 + myHero.cdr)
	ETotalCooldow = myHero:GetSpellData(_E).cd * (1 + myHero.cdr)
	QCooldow = myHero:GetSpellData(_Q).currentCd
	WCooldow = myHero:GetSpellData(_W).currentCd
	ECooldow = myHero:GetSpellData(_E).currentCd
	RCooldow = myHero:GetSpellData(_R).currentCd
	
	QREADY     = (myHero:CanUseSpell(_Q) == READY)
	W1READY    = ((myHero:CanUseSpell(_W) == READY) and (myHero:GetSpellData(_W).name == "LeblancSlide"))
	W2READY    = ((myHero:CanUseSpell(_W) == READY) and (myHero:GetSpellData(_W).name == "leblancslidereturn"))
	EREADY     = (myHero:CanUseSpell(_E) == READY)
	RREADY     = ((myHero:CanUseSpell(_R) == READY) and not (myHero:GetSpellData(_R).name == "leblancslidereturnm"))
	RQREADY    = ((myHero:CanUseSpell(_R) == READY) and (myHero:GetSpellData(_R).name == "LeblancChaosOrbM"))
	RW1READY   = ((myHero:CanUseSpell(_R) == READY) and (myHero:GetSpellData(_R).name == "LeblancSlideM"))
	RW2READY   = ((myHero:CanUseSpell(_R) == READY) and (myHero:GetSpellData(_R).name == "leblancslidereturnm"))
	REREADY    = ((myHero:CanUseSpell(_R) == READY) and (myHero:GetSpellData(_R).name == "LeblancSoulShackleM"))
	IREADY    = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	
	if W1READY then
		ts.range = 1500
	else
		ts.range = 1100
	end
	
	EnemyMinions:update()
	
	if Wused and not RREADY then
	    Wused = false
	end
	if Wused then
	    DelayAction(function() Wused = false end, 0.2)
	end
end

function Action()
    Target = GetCustomTarget()
	if Target ~= nil and ValidTarget(Target) and not Target.dead then
	    if ComboActive then Combo(Target) end
	    if HarassActive then Harass(Target) end
	end
	if KsActive then Killsteal() end
	if FarmActive then Farm() end
	if ClearActive then Clear() end
	if EscapeActive then Escape() end
	if LeblancMenu.misc.cloneSlic ~= 1 then CloneLogic() end
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
  if msg == WM_LBUTTONDOWN and LeblancMenu.Lock then
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
		print("<font color=\"#FFFFFF\">Leblanc: New target <font color=\"#00FF00\"><b>SELECTED</b></font>: "..current.charName..".</font>")
      end
    end
  end
end

function Combo(target)
    local ComboTarget = target
    if LeblancMenu.combo.gapclose then
	    local DashPos = myHero + (Vector(target) - myHero):normalized() * Ranges.W
	    if W1READY and EREADY and GetDistance(target) > 950 and GetDistance(target) < 1550 then
		    if ((QREADY and RREADY) or (QCooldow < 1 and RCooldow < 1.5)) and GetDistance(target) > 600 and GetDistance(target) < 1200 then
			    CastDashW(DashPos)
			elseif QREADY and RCooldow > 1.5 and SmartCombo and GetDistance(target) > 675 and GetDistance(target) < 1275 then
			    CastDashW(DashPos)
			end	
        elseif W1READY and QREADY and RREADY and GetDistance(target) > 600 and GetDistance(target) < 1200 then
			CastDashW(DashPos)
        end		    
	end
	if SmartCombo then
		for i, enemy in pairs (GetEnemyHeroes()) do
		    if enemy and ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy) <= Ranges.E then
			    if (CountEnemyHeroInRange(250, enemy) >= 2) or (CountEnemyHeroInRange(350, enemy) >= 3) or myHero:GetSpellData(_W).level > myHero:GetSpellData(_Q).level + 1 then
				    WRCombo(enemy, target)
				else
				    QRCombo(target)
				end
		        if GetDistance(target) > Ranges.Q or (QCooldow < 1) or (CheckQRBuff(target) and not RREADY and not W1READY) then
	                CastE(target)
		        end
		        if GetDistance(target) > Ranges.Q and QCooldow < 2 and WCooldow < 2 and REREADY and LeblancMenu.advanced.skillE.UseRE then
                    CastRE(target)
		        end
		        if LeblancMenu.advanced.skillE.antigank and enemy ~= target and GetDistance(enemy) < 400 then
		            CastE(enemy)
		        end
			end
		end
	elseif FullDmgCombo then
		if CountEnemyHeroInRange(300, target) >= 2 or myHero:GetSpellData(_W).level > myHero:GetSpellData(_Q).level + 1 then
			WRCombo(target, target)
		else
		    QRCombo(target)
		end
		if GetDistance(target) > Ranges.Q or (QCooldow < 1 and not CheckQRBuff(target)) or (CheckQRBuff(target) and not RREADY and not W1READY) then
	        CastE(target)
		end
	end
	if LeblancMenu.combo.smartW and SmartCombo then smartW(target) end
	if ComboTarget and (ComboTarget.dead or ComboTarget.health <= 0) then				   
		Funny()
	end
end

function Funny()
		if W2Ready and LeblancMenu.combo.funny == 2 then
			CastSpell(_W)
			SendChat('/l')
		elseif W2Ready and LeblancMenu.combo.funny == 3 then
			CastSpell(_W)
		elseif LeblancMenu.combo.funny == 4 then
			SendChat('/l')
		end
end
function smartW(target)
    if W2READY and leblancW and leblancW.valid then
        if CountEnemyHeroInRange(400, leblancW) < CountEnemyHeroInRange(400, myHero) + 1 then
            if ValidTarget(target) and target.health > (FullDmg(target) + 500) then
                CastSpell(_W)
            end
		end
	    if GetDistance(target) > GetDistance(target,leblancW) then
		    if ValidTarget(target) and target.health < FullDmg(target) + 500 then
                CastSpell(_W)
            end		
        end
    end
    if RW2READY and leblancRW and leblancRW.valid and not W2READY then
        if CountEnemyHeroInRange(400, leblancRW) < CountEnemyHeroInRange(400, myHero) + 1 then
            if ValidTarget(target) and target.health > (FullDmg(target) + 500) then
                CastSpell(_R)
            end
		end
	    if GetDistance(target) > GetDistance(target,leblancRW) then
		    if ValidTarget(target) and target.health < FullDmg(target) + 500 then
                CastSpell(_R)
            end		
        end
    end
end

function FullDmg(unit)
	local Qdmg,Wdmg,Edmg,RQdmg,RWdmg,Rdmg = 0,0,0,0,0,0
	local Dmg = 0
    if QCooldow < 1 then
	    Qdmg = CalDmg(unit,"Q")
	end
	if WCooldow < 1 then
	    Wdmg = CalDmg(unit,"W")
	end
	if ECooldow < 1 then
	    Edmg = CalDmg(unit,"E")
	end
	if RCooldow < 1 then
	    RQdmg = math.round(getDmg("R", unit, myHero, 1) or 0)
		RWdmg = math.round(getDmg("R", unit, myHero, 2) or 0)
		Rdmg  =  math.max(RQdmg*2,RWdmg)
	end
	Dmg = Qdmg*2 + Wdmg + Edmg + Rdmg
	return Dmg
end
function CastDashW(pos)
    if not IsWall(D3DXVECTOR3(pos.x, pos.y, pos.z)) and not UnderTurret(pos) then
	    CastW(pos)
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

function CheckValid(unit,range)
    --[[if ValidTarget(unit) and GetDistance(unit) <= range then
	        if (not (TargetHaveBuff("UndyingRage", unit) and (unit.health == 1)) and not TargetHaveBuff("JudicatorIntervention", unit)) then
			    return true
			end
		end
	end
	return false]]
end

function WRCombo(unit1,unit2)
    if ValidTarget(unit1) then
        local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(unit1, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
	    if AOECastPosition and MainTargetHitChance >= VPHitChance and nTargets > 1 then
	        Wused = true
	        CastW(AOECastPosition)
		    CastRW(AOECastPosition)
	    else
		    if ValidTarget(unit2) then
	            local CastPosition, HitChance, Position = VP:GetCircularCastPosition(unit2, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
		        if CastPosition and HitChance >= VPHitChance  then
	                CastW(CastPosition)
		            CastRW(CastPosition)
                end	
            end
        end			
	end
	if QREADY and not RREADY and (WCooldow < 1 or ECooldow < 0.5) and GetDistance(unit2) < Ranges.W then
	    CastQ(unit2)
	end
	local CastPosition,  HitChance, HeroPosition = VP:GetLineCastPosition(unit2, Delays.E, Widths.E, Ranges.E, Speeds.E, myHero,true)
	if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.E and not RREADY then
	    if EREADY and WCooldow > 1 and RCooldow > WCooldow and not CheckQRBuff(unit2) then
	        CastQ(unit2)
		elseif EREADY and WCooldow > 1 and RCooldow > WCooldow and CheckQRBuff(unit2) then
		    CastSpell(_E, CastPosition.x, CastPosition.z)
		end
	end
	if (TargetHaveBuff("LeblancSoulShackle",unit2) or TargetHaveBuff("LeblancSoulShackleM",unit2)) and not RREADY then
	    CastQ(unit2)
	end
end

function QRCombo(unit)
    if not ValidTarget(unit) then return end
	if QREADY and (WCooldow < 1 or RREADY or QCooldow < WCooldow) and GetDistance(unit) <= Ranges.W then
	    CastQ(unit)
	end
	if RREADY then
	    CastRQ(unit)
	end
	if EREADY and QCooldow < 1 and not RREADY then
	    local CastPosition,  HitChance, HeroPosition = VP:GetLineCastPosition(unit, Delays.E, Widths.E, Ranges.E, Speeds.E, myHero,true)
	    if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) < Ranges.E then
		    CastSpell(_E, CastPosition.x, CastPosition.z)
		end
	end
	if W1READY and (CheckQRBuff(unit) or (ECooldow < 2 and QCooldow < 2)) and not RREADY then
		local CastPosition, HitChance, Position = VP:GetCircularCastPosition(unit, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
		if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) < Ranges.W then
		    CastW(CastPosition)
		end
	end
	if (TargetHaveBuff("LeblancSoulShackle",unit) or TargetHaveBuff("LeblancSoulShackleM",unit)) then
	    CastQ(unit)
	end
end

function Harass(target)
    if myHero.mana < myHero.maxMana * (LeblancMenu.harass.manaSlider / 100) then return end
    if LeblancMenu.harass.Wback and W2READY then
        CastSpell(_W)
    end
	if LeblancMenu.harass.mode == 1 then
		CastQ(target)
	end
	if LeblancMenu.harass.mode == 2 then
	    if GetDistance(target) <= Ranges.W and W1READY then
			CastQ(target)
		end
		local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
		if CastPosition and HitChance >= VPHitChance and CheckQRBuff(target) and GetDistance(CastPosition) <= Ranges.W then
	        CastW(CastPosition)
		end
	end
	if LeblancMenu.harass.mode == 3 then
	    local CastPosition,  HitChance, HeroPosition = VP:GetLineCastPosition(target, Delays.E, Widths.E, Ranges.E, Speeds.E, myHero,true)
		if EREADY and CastPosition and HitChance >= VPHitChance then
		    if QREADY then
		        CastQ(target)
			end
			if CheckQRBuff(target) then
			    CastSpell(_E,CastPosition.x,CastPosition.z)
			end
	    end
    end
	for i, enemy in pairs (GetEnemyHeroes()) do
	    if enemy and enemy ~= target and ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy) < 400 then
		    CastE(enemy)
		end
	end
end

function Killsteal()
	for i, enemy in pairs (GetEnemyHeroes()) do
	    if ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy) <= Ranges.E then
		    if ignite ~= nil and enemy.health <= CalDmg(enemy, "IGNITE") and LeblancMenu.ks.ignite and GetDistance(enemy) < 600 then
                CastSpell(ignite, enemy)
			end
            if enemy.health < CalDmg(enemy, "Q") and GetDistance(enemy) < Ranges.Q then
 		        if LeblancMenu.ks.Qks then
		    	    CastQ(enemy)
		    	elseif LeblancMenu.ks.Rks and RQREADY and not QREADY then
		    	    CastRQ(enemy)
		    	end
			end
	    	if enemy.health <= CalDmg(enemy, "W") then
 		        if LeblancMenu.ks.Wks and W1READY then
			        local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(enemy, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
		            if CastPosition and HitChance >= VPHitChance and W1READY then
	                    CastSpell(_W,CastPosition.x,CastPosition.z)
	                end
		    	elseif LeblancMenu.ks.Rks and RW1READY and not W1READY then
			        local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(enemy, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
		            if CastPosition and HitChance >= VPHitChance and RW1READY then
	                    CastSpell(_R,CastPosition.x,CastPosition.z)
	                end
                end
            end				
		    if enemy.health <= CalDmg(enemy, "E") and not QREADY or W1READY then
 		        if LeblancMenu.ks.Eks and EREADY then
			        --CastE(enemy)
			    end
			end
			if enemy.health < (CalDmg(enemy, "Q")*2 + (getDmg("R", enemy, myHero, 1) or 0)) and QREADY and RREADY and LeblancMenu.ks.Qks and LeblancMenu.ks.Rks then
			    QRCombo(enemy)
			end
		    if enemy.health < (CalDmg(enemy, "W") + (getDmg("R", enemy, myHero, 2) or 0)) and W1READY and RREADY and LeblancMenu.ks.Wks and LeblancMenu.ks.Rks then
			    WRCombo(enemy)
			end
		elseif LeblancMenu.ks.gapclose and W1READY and ValidTarget(enemy) and not enemy.dead and enemy.visible and GetDistance(enemy) > Ranges.E and GetDistance(enemy) < Ranges.W + Ranges.Q then			
			local DashPos = myHero + (Vector(enemy) - myHero):normalized() * Ranges.W
			if enemy.health < CalDmg(enemy, "Q") and GetDistance(enemy) < 1250 and GetDistance(enemy) > Ranges.Q and QREADY and LeblancMenu.ks.Qks then
				CastDashW(DashPos)
			end
			if enemy.health < CalDmg(enemy, "W") and GetDistance(enemy) < 1100 and GetDistance(enemy) > Ranges.W and RREADY and LeblancMenu.ks.Rks then
			    CastDashW(DashPos)
			end
			if enemy.health < (CalDmg(enemy, "Q")*2 + (getDmg("R", enemy, myHero, 1) or 0)) and QREADY and RREADY and LeblancMenu.ks.Qks and LeblancMenu.ks.Rks then
			    CastDashW(DashPos)
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
			--return (getDmg("Q", unit, myHero) and QREADY or 0)
    	elseif SNAMES == "W" then
      		return caldmg(W1READY and getDmg("W", unit, myHero) or 0)
			--return (getDmg("W", unit, myHero) and W1READY or 0)
   		elseif SNAMES == "E" then
      		return caldmg(EREADY and getDmg("E", unit, myHero) or 0)
			--return (getDmg("E", unit, myHero) and EREADY or 0)
		elseif SNAMES == "R" then
      		return caldmg(RREADY and getDmg("R", unit, myHero, myHero,Leblanc_R_Stage()) or 0)
			--return (getDmg("R", unit, myHero, myHero,Leblanc_R_Stage()) and RREADY or 0)
    	elseif SNAMES == "IGNITE" then
      		return caldmg(IREADY and getDmg("IGNITE", unit, myHero) or 0)
			--return (IREADY and getDmg("IGNITE", unit, myHero) or 0)
    	end
	end
end

Leblanc_R_Stage = function()
    local R_Stage = 0
    if RQREADY then
	    R_Stage = 1
	elseif RW1READY then
	    R_Stage = 2
	elseif REREADY then
	    R_Stage = 3
	end
	return R_Stage
end

function CheckBuff(unit)
    return false
end

function CheckQRBuff(unit)
    if TargetHaveBuff("LeblancChaosOrb", unit) or TargetHaveBuff("LeblancChaosOrbM", unit) then
        return true
    else
        return false
	end
end
function CastQ(unit)
    if QREADY and GetDistance(unit) <= Ranges.Q then
	    CastSpell(_Q,unit)
	end
end

function CastRQ(unit)
    if RQREADY and GetDistance(unit) <= Ranges.Q then
	    CastSpell(_R,unit)
	end
end

function CastW(pos)
    if W1READY and GetDistance(pos) <= Ranges.W and not IsWall(D3DXVECTOR3(pos.x, pos.y, pos.z)) and (not UnderTurret(pos) or LeblancMenu.advanced.skillW.turret) then
	    CastSpell(_W,pos.x,pos.z)
	end
end

function CastRW(pos)
    if RW1READY and GetDistance(pos) <= Ranges.W and not IsWall(D3DXVECTOR3(pos.x, pos.y, pos.z)) and (not UnderTurret(pos) or LeblancMenu.advanced.skillW.turret) then
	    CastSpell(_R,pos.x,pos.z)
	end
end

function CastE(unit)
    if unit.dead or not ValidTarget(unit) then return end
    local CastPosition,  HitChance, HeroPosition = VP:GetLineCastPosition(unit, Delays.E, Widths.E, Ranges.E, Speeds.E, myHero,true)
	if EREADY and CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.E then
	    CastSpell(_E, CastPosition.x, CastPosition.z)
	end
end

function CastRE(unit)
    if unit.dead or not ValidTarget(unit) then return end
    local CastPosition,  HitChance, HeroPosition = VP:GetLineCastPosition(unit, Delays.E, Widths.E, Ranges.E, Speeds.E, myHero,true)
	if REREADY and CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.E then
	    CastSpell(_R, CastPosition.x, CastPosition.z)
	end
end

function Farm()
    if myHero.mana < myHero.maxMana * (LeblancMenu.farm.manaSlider / 100) then return end
	if LeblancMenu.farm.farmW then
		WLastHit()
	end
	if LeblancMenu.farm.farmQ then
		QLastHit()
	end
end

function QLastHit()
	for _, minion in pairs(EnemyMinions.objects) do
		if ValidTarget(minion) then
			if GetDistance(minion, myHero) < Ranges.Q then
			    local AAdmg = getDmg("AD", minion, myHero) or 0
			 	if minion.health <= AAdmg and not myHero.canAttack and QREADY then
		 			CastSpell(_Q, minion)
			 	end
			 end
		end
	end
end

function WLastHit()
	if W1READY and #EnemyMinions.objects > 2 then
		local WPos = GetBestWPositionFarm()
		if WPos and GetDistance(WPos) <= Ranges.W then 
			CastSpell(_W, WPos.x, WPos.z)
		end
	elseif W2READY then
	    CastSpell(_W)
	end
end

-- Credit Pyryoer 
function countminionshitW(pos)
	local n = 0
	for i, minion in ipairs(EnemyMinions.objects) do
	    if GetDistance(minion, myHero) < Ranges.W then 
		    if minion.health <= CalDmg(minion, "W") then 
			    if GetDistance(minion, pos) < Widths.W then 
				    n = n +1
			    end
		    end
	    end
	end
	return n
end

function GetBestWPositionFarm()
	local MaxW = 3
	local MaxWPos 
	for i, minion in pairs(EnemyMinions.objects) do
		local hitW = countminionshitW(minion)
		if hitW >= MaxW or MaxWPos == nil then
			MaxWPos = minion
			MaxW = hitW
		end
	end

	if MaxWPos then
		local CastPosition, HitChance, Position = VP:GetCircularCastPosition(MaxWPos, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
		return CastPosition
	else
		return nil
	end
end

function Clear()
	if LeblancMenu.clear.clearW then
		WClear()
	end
	if LeblancMenu.clear.clearR then
	    RWClear()
		if LeblancMenu.clear.clearQ and not RW1READY then
		    QClear()
	    end
		if LeblancMenu.clear.clearE and not RW1READY then
		    --EClear()
	    end
	else
		if LeblancMenu.clear.clearQ then
		    QClear()
	    end
	    if LeblancMenu.clear.clearE then
	        ELastHit()
		end
	end
end

function QClear()
	for _, minion in pairs(EnemyMinions.objects) do
		if ValidTarget(minion) then
			if GetDistance(minion, myHero) < Ranges.Q then
			 	if minion.health <= CalDmg(minion, "Q") and QREADY then
		 			CastSpell(_Q, minion)
			 	end
			 end
		end
	end
end

function WClear()
	if W1READY and #EnemyMinions.objects > 2 then
		local WPos = GetBestWPositionFarm()
		if WPos and GetDistance(WPos) <= Ranges.W then 
			CastSpell(_W, WPos.x, WPos.z)
		end
	end
end

function RWClear()
	if RW1READY and #EnemyMinions.objects > 2 then
		local RWPos = GetBestWPositionFarm()
		if RWPos and GetDistance(RWPos) <= Ranges.W then 
			CastSpell(_R, RWPos.x, RWPos.z)
		end
	end
end

function ELastHit()
	for _, minion in pairs(EnemyMinions.objects) do
		if ValidTarget(minion) then
			if GetDistance(minion, myHero) < Ranges.Q then
			 	if minion.health <= CalDmg(minion, "E") and EREADY then
		 			CastE(minion)
			 	end
			 end
		end
	end
end

function OnCreateObj(obj)	
	if obj.name == "LeBlanc_Base_W_return_indicator.troy" then
        leblancW = obj
    end
	if obj.name == "LeBlanc_Base_RW_return_indicator.troy" then
        leblancRW = obj
    end
	if obj and obj.name:find("TeleportHome.troy") then
	    if GetDistance(obj) <= 70 then
		    isRecalling = true
	    end
	end
	if obj and obj.name == "LeBlanc_MirrorImagePoof.troy" then leblancImage = obj end
end

function OnDeleteObj(obj)
	if obj.name == "LeBlanc_Base_W_return_indicator.troy" then
        leblancW = nil
    end
    if obj.name == "LeBlanc_Base_RW_return_indicator.troy" then
        leblancRW = nil
    end
	if obj and obj.name:find("TeleportHome.troy") then
	    if GetDistance(obj) <= 70 then
		    isRecalling = false
	    end
	end
	if obj and obj.name == "LeBlanc_MirrorImagePoof.troy" then leblancImage = nil end
end

function OnDraw()
    if myHero.dead then return end
end

function OnProcessSpell(unit, spell)
	if unit.isMe and spell.name == "LeblancChaosOrb" and spell.target.type == myHero.type and spell.target.team ~= myHero.team and not spell.target.dead and ValidTarget(spell.target) then
		if W1READY and ((ComboActive and ((myHero:GetSpellData(_W).level > myHero:GetSpellData(_Q).level + 1) or not RREADY)) or (HarassActive and LeblancMenu.harass.mode == 2) or (KsActive and (CalDmg(unit, "Q") + CalDmg(unit, "W") > unit.health) and LeblancMenu.ks.Wks)) then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(spell.target, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
			if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.W then
				CastW(CastPosition)
			end
		elseif RQREADY and ((ComboActive and not (myHero:GetSpellData(_W).level > myHero:GetSpellData(_Q).level + 1)) or (KsActive and (CalDmg(unit, "Q") + CalDmg(unit, "R") > unit.health) and LeblancMenu.ks.Rks)) then
			CastSpell(_R, spell.target)
		elseif EREADY and RCooldow > 2 and WCooldow > 2 and (ComboActive or (HarassActive and LeblancMenu.harass.mode == 3) or (KsActive and (CalDmg(unit, "Q") + CalDmg(unit, "E") > unit.health) and LeblancMenu.ks.Eks)) then
	        CastE(spell.target)
	    end
	end
	if unit.isMe and spell.name == "LeblancChaosOrbM" and spell.target.type == myHero.type and spell.target.team ~= myHero.team and not spell.target.dead and ValidTarget(spell.target) then
		if W1READY and (ComboActive or (HarassActive and LeblancMenu.harass.mode == 2) or (KsActive and (CalDmg(unit, "Q") + CalDmg(unit, "W") > unit.health) and LeblancMenu.ks.Wks)) then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(spell.target, Delays.W, Widths.W, Ranges.W, Speeds.W, myHero, false)
			if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.W then
				CastW(CastPosition)
			end
		elseif EREADY and WCooldow > 2 and (ComboActive or (HarassActive and LeblancMenu.harass.mode == 3) or (KsActive and (CalDmg(unit, "Q") + CalDmg(unit, "E") > unit.health) and LeblancMenu.ks.Eks)) then
	        CastE(spell.target)
	    end
	end
    if unit.team ~= myHero.team and not myHero.dead and not (unit.type == "obj_AI_Minion" and unit.type == "obj_AI_Turret") then
		shottype,radius,maxdistance = 0,0,0
		if unit.type == "AIHeroClient" then
			spelltype, casttype = getSpellType(unit, spell.name)
            --if casttype == 4 or casttype == 5 or casttype == 6 then return end			
            if (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R") and (LeblancMenu.evade.AutoEvadeCast[unit.charName .. spelltype] or LeblancMenu.evade.AutoEvadeBack[unit.charName .. spelltype]) then
				shottype = skillData[unit.charName][spelltype]["type"] or 0
				radius = skillData[unit.charName][spelltype]["radius"] or 0
				maxdistance = skillData[unit.charName][spelltype]["maxdistance"] or 0
			end
		end
		if not myHero.dead and myHero.health > 0 then
			hitchampion = false
			hitchampion2 = false
			local allyHitBox = myHero.boundingRadius
			if shottype == 1 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 2 then hitchampion = checkhitlinepoint(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 3 then hitchampion = checkhitaoe(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 4 then hitchampion = checkhitcone(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 5 then hitchampion = checkhitwall(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 6 then hitchampion = checkhitlinepass(unit, spell.endPos, radius, maxdistance, myHero, allyHitBox) or checkhitlinepass(unit, Vector(unit)*2-spell.endPos, radius, maxdistance, myHero, allyHitBox)
			elseif shottype == 7 then hitchampion = checkhitcone(spell.endPos, unit, radius, maxdistance, myHero, allyHitBox)
			end
			if hitchampion and (W1READY or RW1READY) and LeblancMenu.evade.AutoEvadeCast[unit.charName .. spelltype] then
				local evadePos = PointT(mousePos.x, mousePos.z)
				local myPos = PointT(myHero.x, myHero.z)
				local ourdistance = evadePos:distance(myPos)
				local dashPos = myPos - (myPos - evadePos):normalized() * Ranges.W
		
				x = dashPos.x
				y = dashPos.y
						
				if W1READY and LeblancMenu.evade.wCast then
					CastSpell(_W, x, y)
				elseif RW1READY and LeblancMenu.evade.rCast then					    
                    CastSpell(_R, x, y)
				end
			elseif hitchampion and (W2READY or RW2READY) and LeblancMenu.evade.AutoEvadeBack[unit.charName .. spelltype]then
				if shottype == 1 then hitchampion2 = checkhitlinepass(unit, spell.endPos, radius, maxdistance, leblancW, allyHitBox)
				elseif shottype == 2 then hitchampion2 = checkhitlinepoint(unit, spell.endPos, radius, maxdistance, leblancW, allyHitBox)
				elseif shottype == 3 then hitchampion2 = checkhitaoe(unit, spell.endPos, radius, maxdistance, leblancW, allyHitBox)
				elseif shottype == 4 then hitchampion2 = checkhitcone(unit, spell.endPos, radius, maxdistance, leblancW, allyHitBox)
				elseif shottype == 5 then hitchampion2 = checkhitwall(unit, spell.endPos, radius, maxdistance, leblancW, allyHitBox)
				elseif shottype == 6 then hitchampion2 = checkhitlinepass(unit, spell.endPos, radius, maxdistance, leblancW, allyHitBox) or checkhitlinepass(unit, Vector(unit)*2-spell.endPos, radius, maxdistance, leblancW, allyHitBox)
				elseif shottype == 7 then hitchampion2 = checkhitcone(spell.endPos, unit, radius, maxdistance, leblancW, allyHitBox)
	            end
				if W2READY and leblancW and leblancW.valid and ((hitchampion2 and GetDistanceSqr(unit, leblancW) > GetDistanceSqr(unit, myHero)) or not hitchampion2) and LeblancMenu.evade.wSwap then
					CastSpell(_W)
					Funny()
				elseif RW2READY and leblancRW and leblancRW.valid and ((hitchampion2 and GetDistanceSqr(unit, leblancW) > GetDistanceSqr(unit, myHero)) or not hitchampion2) and LeblancMenu.evade.rSwap then
					CastSpell(_R)
					Funny()
				end
			end
		end		
    end	
end

function CloneLogic()
  if leblancImage and leblancImage.valid then
    if LeblancMenu.cloneSlic == 2 and Target then
      myHero:MoveTo(Target.x,Target.z)
    elseif LeblancMenu.cloneSlic == 3 then
      local movepoint =  GetWayPoints(myHero)
      local line = Vector(leblancImage) - Vector(myHero):perpendicular()
      local Direction = (Vector(movepoint[#movepoint].x, 0, movepoint[#movepoint].z) - Vector(myHero)):mirrorOn(line):normalized()
      
      local movepos = Vector(leblancImage) + 500 * Direction
      myHero:MoveTo(movepos.x,movepos.z)
    elseif LeblancMenu.cloneSlic == 4 then
      local Point = Vector(0, 0, 0)
      local Count = 0
      for i, hero in ipairs(GetAllyHeroes()) do
        Point = Vector(Point) + Vector(hero)
        Count = Count + 1
      end
      Count = Count or 1
      Point = 1/Count * Vector(Point)
      myHero:MoveTo(Point.x,Point.z)
    else
      myHero:MoveTo(mousePos.x,mousePos.z)
    end
  end
end

function GetWayPoints(unit)
local wayPoint = {}
  wayPoint[1] = Vector(unit.x,unit.y,unit.z)
  if unit.hasMovePath then
    for i = unit.pathIndex, unit.pathCount do
      local unitpath = unit:GetPath(i)
      if unitpath then
        wayPoint[#wayPoint + 1] = Vector(unitpath.x,unitpath.y,unitpath.z)
      end
    end
  end
  return wayPoint
end
-----------------------
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
