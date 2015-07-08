if myHero.charName ~= "Viktor" then return end

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("PCFDIGEKKDK") 

--require "SxOrbWalk"
require "DivinePred"
require "VPrediction"

_G.AUTOUPDATE = true

local sourceLibFound = true
if FileExist(LIB_PATH .. "SourceLib.lua") then
    require "SourceLib"
else
    sourceLibFound = false
    DownloadFile("https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua", LIB_PATH .. "SourceLib.lua", function() print("<font color=\"#6699ff\"><b>" .. scriptName .. ":</b></font> <font color=\"#FFFFFF\">SourceLib downloaded! Please reload!</font>") end)
end
if not sourceLibFound then return end


local version = "1.3"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/lovehoppang/DPkarthus/master/victorious_Viktor.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>victorious_Viktor:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/lovehoppang/DPkarthus/master/victorious_Viktor.version".."?rand="..math.random(1,10000))
if ServerData then
	ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
	if ServerVersion then
		if tonumber(version) < ServerVersion then
			AutoupdaterMsg("New version available "..ServerVersion)
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

local TsQ = TargetSelector(8, 740, DAMAGE_MAGIC, 1, true)
local TsW = TargetSelector(8, 700, DAMAGE_MAGIC, 1, true)
local TsE = TargetSelector(8, 1200, DAMAGE_MAGIC, 1, true)
local TsR = TargetSelector(8, 700, DAMAGE_MAGIC, 1, true)

local viktorE = LineSS(750,760,75,125,math.huge)
local dp = DivinePred()
local dpCD = 30
local lastTimeStamp = os.clock()*100
local lastStormStamp = os.clock()*100
local KillStealStamp = os.clock()*100

local tp = TargetPredictionVIP(1200, 1000, 0.1, 75)

local vp = VPrediction()
local DLib = nil

local runCD = 0

local orb = true

-------Orbwalk info-------
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
local myTrueRange = myHero.range + GetDistance(myHero.minBBox)
local myTarget = nil
local tsa = TargetSelector(8, 624.9, DAMAGE_MAGIC, 1, true)
-------/Orbwalk info-------

local erange = 540
local damage = nil
local cfg = nil

local vts = nil

local Interrupt = {}
local InterruptList = {
{charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
{charName = "FiddleSticks", spellName = "Crowstorm"},
{charName = "FiddleSticks", spellName = "Drain"},
{charName = "Galio", spellName = "GalioIdolOfDurand"},
{charName = "Karthus", spellName = "FallenOne"},
{charName = "Katarina", spellName = "KatarinaR"},
{charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
{charName = "MissFortune", spellName = "MissFortuneBulletTime"},
{charName = "Nunu", spellName = "AbsoluteZero"},
{charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
{charName = "Shen", spellName = "ShenStandUnited"},
{charName = "Urgot", spellName = "UrgotSwap2"},
{charName = "Varus", spellName = "VarusQ"},
{charName = "Warwick", spellName = "InfiniteDuress"}
}

function OnLoad()
--	SxO = SxOrbWalk()

cfg = scriptConfig("victorious_Viktor","Viktor")
cfg:addSubMenu("Viktor: Target Selector","TS")
cfg:addSubMenu("Combo Setting","Combo")
cfg:addSubMenu("Harass Setting","Harass")
cfg:addSubMenu("KillSteal","KillSteal")
cfg.KillSteal:addParam("useQ", "Q ON", SCRIPT_PARAM_ONOFF, false)
cfg.KillSteal:addParam("useE", "E ON", SCRIPT_PARAM_ONOFF, false)
cfg:addSubMenu("R Setting","RSetting")
cfg:addSubMenu("W Skill Interrupt Setting", "Winterrupt")
cfg:addSubMenu("R Skill Interrupt Setting", "Rinterrupt")
cfg:addSubMenu("Draw Setting","Draw")
cfg:addSubMenu("Prediction Setting","ChoosePrediction")
--	cfg:addSubMenu("SxOrbwalk Setting","sxo")
vts = TargetSelector(8, 1500, DAMAGE_MAGIC, 1, true)
vts.name = "Viktor"
cfg.TS:addTS(vts)
cfg.Combo:addParam("Combo", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
cfg.Combo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
cfg.Combo:addParam("wMana","Min. Mana To Use W", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
cfg.Combo:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
cfg.Combo:addParam("eMana","Min. Mana To Use E", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
cfg.Combo:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
cfg.Combo:addParam("orbkey", "orbwalk", SCRIPT_PARAM_ONOFF, true)
cfg.Harass:addParam("Harass", "Harass key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte('Z'))
cfg.Harass:addParam("toggleHarass", "Harass toggle on/off", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
cfg.Harass:addParam("eMana","Min. Mana To Harass", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
cfg.Harass:addParam("orbkey", "orbwalk", SCRIPT_PARAM_ONOFF, true)
cfg.RSetting:addParam("RHealth", "Enemy Health % before R", SCRIPT_PARAM_SLICE, 40, 0, 100, -1)
cfg.RSetting:addParam("RCount", "Enemy Count(Within combo range)", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
cfg.Draw:addParam("enabled", "Draw enabled", SCRIPT_PARAM_ONOFF, true)
cfg.Draw:addParam("lfc", "Use Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
cfg.Draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
cfg.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
cfg.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, false)
cfg.Draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
cfg.Draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, false)
cfg.Combo:permaShow("Combo")
cfg.Harass:permaShow("Harass")
cfg.Harass:permaShow("toggleHarass")
cfg.Winterrupt:addParam("On","W interrupt On", SCRIPT_PARAM_ONOFF, true)
cfg.Rinterrupt:addParam("On","R interrupt On", SCRIPT_PARAM_ONOFF, false)
cfg.ChoosePrediction:addParam("ChoosePrediction","Choose Prediction Lib.", SCRIPT_PARAM_LIST, 2, {"VPrediction", "Divine_Prediction"})
DLib = DamageLib()
--DamageLib:RegisterDamageSource(spellId, damagetype, basedamage, perlevel, scalingtype, scalingstat, percentscaling, condition, extra)
DLib:RegisterDamageSource(_Q, _MAGIC, 40, 20, _MAGIC, _AP, 0.20, function() return (myHero:CanUseSpell(_Q) == READY) end)
DLib:RegisterDamageSource(_E, _MAGIC, 70, 45, _MAGIC, _AP, 0.70, function() return (myHero:CanUseSpell(_E) == READY) end)
DLib:RegisterDamageSource(_R, _MAGIC, 150, 100, _MAGIC, _AP, 0.55, function() return (myHero:CanUseSpell(_R) == READY) end)
DLib:AddToMenu(cfg.Draw,{_Q,_E,_R,})
for _,enemy in pairs(GetEnemyHeroes()) do
for _, potential in pairs(InterruptList) do
	if enemy.charName == potential.charName then
		table.insert(Interrupt, potential.spellName)
		cfg.Winterrupt:addParam("interrupt" .. potential.spellName, "Interrupt " ..potential.spellName, SCRIPT_PARAM_ONOFF, true)
		cfg.Rinterrupt:addParam("interrupt" .. potential.spellName, "Interrupt " ..potential.spellName, SCRIPT_PARAM_ONOFF, true)
	end
end
end

--	SxO:LoadToMenu(cfg.sxo)
myTrueRange = 624.9
tsa.range = 624.9
end

function OnTick()
if cfg == nil then return
end



if (cfg.Combo.orbkey and cfg.Combo.Combo) or (cfg.Harass.orbkey and cfg.Harass.Harass) then
	_OrbWalk()
end

TargetUpdate()

if dpCD < os.clock()*100 - KillStealStamp then
	KillSteal(TsQ.target,TsE.target)
	KillStealStamp = os.clock() * 100
end

if cfg.ChoosePrediction.ChoosePrediction == 2 and cfg.Combo.Combo and dpCD < os.clock() * 100 - lastTimeStamp then
	Combo()
	lastTimeStamp = os.clock() * 100
	elseif cfg.ChoosePrediction.ChoosePrediction == 1 and cfg.Combo.Combo and dpCD < os.clock() * 100 - lastTimeStamp then
		VpCombo()
		lastTimeStamp = os.clock() * 100
end

if cfg.Combo.Combo ~= true then
runCD = 0
end


	if (cfg.Harass.Harass or cfg.Harass.toggleHarass) and dpCD < os.clock() * 100 - lastTimeStamp and HarassManager() then
		Harass()
		lastTimeStamp = os.clock() * 100
	end
	if TsR.target ~= nil and dpCD < os.clock() * 100 - lastStormStamp and myHero:CanUseSpell(_R) == READY then
		StormControl(TsR.target)
		lastStormStamp = os.clock() * 100
	end

end

function Combo()
	if cfg.Combo.useR and (myHero:GetSpellData(_R).name == "ViktorChaosStorm" and TsR.target ~= nil and myHero:CanUseSpell(_R) == READY) then
		if TsR.target.health < (TsR.target.maxHealth * (cfg.RSetting.RHealth / 100)) or (CountEnemyHeroInRange(700) >= cfg.RSetting.RCount) or (myHero.health < myHero.maxHealth * 0.2) then
			CastR(TsR.target)
		end
	end

	if cfg.Combo.useE and TsQ.target ~= nil and myHero:CanUseSpell(_E) == READY and eManaManager() then
		CastE(TsQ.target)
		runCD = runCD + 1
		elseif cfg.Combo.useE and TsE.target ~= nil and myHero:CanUseSpell(_E) == READY and eManaManager() then
			CastE(TsE.target)
			runCD = runCD + 1
		end
		if runCD >= 4 and TsE.target ~= nil and myHero:CanUseSpell(_E) == READY and eManaManager() then
			RunFromMeCastE(TsE.target)
		end

		if TsQ.target ~= nil and myHero:CanUseSpell(_Q) == READY then
			CastQ(TsQ.target)
		end

		if cfg.Combo.useW and TsW.target ~= nil and myHero:CanUseSpell(_W) == READY and wManaManager() then
			CastW(TsW.target)
		end

	end

	function Harass()
		if cfg.ChoosePrediction.ChoosePrediction == 2 and TsE.target ~= nil and myHero:CanUseSpell(_E) == READY then
			if cfg.Harass.toggleHarass or cfg.Harass.Harass then
				CastE(TsE.target)
			end
		end

		if cfg.ChoosePrediction.ChoosePrediction == 1 and TsE.target ~= nil and myHero:CanUseSpell(_E) == READY then
			if cfg.Harass.toggleHarass or cfg.Harass.Harass then
				VpCastE(TsE.target)
			end
		end

	end


	function CastQ(target)
		if GetDistance(myHero,target) <= 740 then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = target.networkID}):send()
		end
	end

	function CastW(target)
		local dptarget = DPTarget(target)
		local state,hitPos,perc = dp:predict(dptarget,CircleSS(math.huge,700,250,200,math.huge))

		if GetDistance(myHero,target) <= 700 and state==SkillShot.STATUS.SUCCESS_HIT then
			Packet("S_CAST", {spellId = _W, toX = hitPos.x, toY = hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
		end
	end

	function CastE(target)
		local dist = GetDistance(myHero,target)

		if dist<=erange then
			Packet("S_CAST", {spellId = _E, toX = target.x, toY = target.z, fromX = target.x, fromY = target.z}):send()
			return

			elseif dist>erange and dist<1200 then
				local dptarget = DPTarget(target)
				local castPosX = (erange*target.x+(dist - erange)*myHero.x)/dist
				local castPosZ = (erange*target.z+(dist - erange)*myHero.z)/dist
				local state,hitPos,perc = dp:predict(dptarget,viktorE,2,Vector(math.floor(castPosX),0,math.floor(castPosZ)))
				if state == SkillShot.STATUS.SUCCESS_HIT then
					if GetDistance(myHero,hitPos) > erange then					
						local dist2 = GetDistance(myHero,hitPos)
						local hitPosX = (erange*hitPos.x+(dist2 - erange)*myHero.x)/dist2
						local hitPosZ = (erange*hitPos.z+(dist2 - erange)*myHero.z)/dist2
						Packet("S_CAST", {spellId = _E, toX = math.floor(hitPosX), toY = math.floor(hitPosZ), fromX = math.floor(hitPosX), fromY = math.floor(hitPosZ)}):send()
					else
						Packet("S_CAST", {spellId = _E, toX = math.floor(hitPos.x), toY = math.floor(hitPos.z), fromX = math.floor(hitPos.x), fromY = math.floor(hitPos.z)}):send()
					end
				end
			end
		end

		function CastR(target)
			Packet("S_CAST", {spellId = _R, toX = target.x, toY = target.z, fromX = target.x, fromY = target.z}):send()
		end

		function StormControl(target)
			if myHero:GetSpellData(_R).name == "viktorchaosstormguide" then
				Packet("S_CAST", {spellId = _R, toX = target.x, toY = target.z, fromX = target.x, fromY = target.z}):send()
			end
		end

		function OnDraw()
			__draw()
		end


		function OnProcessSpell(object, spell)
			if object == myHero then
				if spell.name:lower():find("attack") or spell.name:lower():find("viktorqbuff") then
					lastAttack = GetTickCount() - GetLatency()/2
					lastWindUpTime = spell.windUpTime*1000
					lastAttackCD = spell.animationTime*1000
				end
				if spell.name:lower():find("viktordeathray") then
				runCD = 0
				end
			end


			if #Interrupt > 0 then
				for _, ability in pairs(Interrupt) do
					if ability == spell.name and object.team ~= myHero.team then
						if cfg.Winterrupt["interrupt"..ability] and cfg.Winterrupt.On and myHero:CanUseSpell(_W) == READY then
							if GetDistance(object) <= 700 then Packet("S_CAST", {spellId = _W, toX = object.x, toY = object.z, fromX = object.x, fromY = object.z}):send()
						end
					elseif
						cfg.Rinterrupt["interrupt"..ability] and cfg.Rinterrupt.On and myHero:CanUseSpell(_R) == READY then
						if GetDistance(object) <= 700 then Packet("S_CAST", {spellId = _R, toX = object.x, toY = object.z, fromX = object.x, fromY = object.z}):send()
					end
				end
			end
		end
	end

end

function _OrbWalk()
	tsa:update()
	if tsa.target ~=nil then	
		if timeToShoot() then
			myHero:Attack(tsa.target)
			elseif heroCanMove() then
				moveToCursor()
			end
		elseif heroCanMove() then
			moveToCursor()
		end
	end
	function heroCanMove()
		return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20 and orb)
	end
	function timeToShoot()
		if cfg.Combo.Combo and cfg.Combo.useE and myHero.mana > myHero:GetSpellData(_E).mana then return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD) and (myHero:CanUseSpell(_E) ~= READY)
		end
		return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
	end
	function moveToCursor()
		if GetDistance(mousePos) > 1 then
			local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
			myHero:MoveTo(moveToPos.x, moveToPos.z)
		end
	end



function __draw()

DrawCircles()

if cfg.Draw.drawPredictedHealth then
for i, enemy in ipairs(GetEnemyHeroes()) do
if ValidTarget(enemy) then
DrawIndicator(enemy)
end
end
end
end

	function DrawCircles()

		if cfg and cfg.Draw and cfg.Draw.enabled then

			if cfg.Draw.lfc then

				if cfg.Draw.drawAA then DrawCircleLFC(myHero.x, myHero.y, myHero.z, myTrueRange, ARGB(255,255,255,255)) end 

				if cfg.Draw.drawQ then DrawCircleLFC(myHero.x, myHero.y, myHero.z, 740, ARGB(255,255,255,255)) end 

				if cfg.Draw.drawW then DrawCircleLFC(myHero.x, myHero.y, myHero.z, 700, ARGB(255,255,255,255)) end 

				if cfg.Draw.drawE then DrawCircleLFC(myHero.x, myHero.y, myHero.z, 1200, ARGB(255,255,255,255)) end 

				if cfg.Draw.drawR then DrawCircleLFC(myHero.x, myHero.y, myHero.z, 700, ARGB(255,255,255,255)) end 


    else -- NORMAL CIRCLES

    	if cfg.Draw.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, myTrueRange, ARGB(255,255,255,255)) end 

    	if cfg.Draw.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, 740, ARGB(255,255,255,255)) end 

    	if cfg.Draw.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, 700, ARGB(255,255,255,255)) end 

    	if cfg.Draw.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, 1200, ARGB(255,255,255,255)) end 

    	if cfg.Draw.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, 700, ARGB(255,255,255,255)) end 

    end

end

end


function DrawCircleLFC(x, y, z, radius, color)
local vPos1 = Vector(x, y, z)
local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
	DrawCircleNextLvl(x, y, z, radius, 1, color, 75) 
end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
radius = radius or 300
quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
quality = 2 * math.pi / quality
radius = radius*.92
local points = {}
for theta = 0, 2 * math.pi + quality, quality do
	local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
	points[#points + 1] = D3DXVECTOR2(c.x, c.y)
end
DrawLines2(points, width or 1, color or 4294967295)
end

function eManaManager()
if myHero.mana < (myHero.maxMana * ( cfg.Combo.eMana / 100)) then
	return false
else
	return true
end
end

function wManaManager()
if myHero.mana < (myHero.maxMana * ( cfg.Combo.wMana / 100)) then
	return false
else
	return true
end
end

function HarassManager()
if myHero.mana < (myHero.maxMana * ( cfg.Harass.eMana / 100)) then
	return false
else
	return true
end
end

function KillSteal(qTarget,eTarget)
if cfg.KillSteal.useE and eTarget ~= nil and getDmg("E", eTarget, myHero) > eTarget.health and myHero:CanUseSpell(_E) == READY then CastE(eTarget) end
if cfg.KillSteal.useQ and qTarget ~= nil and getDmg("Q", qTarget, myHero) > qTarget.health and myHero:CanUseSpell(_Q) == READY then CastQ(qTarget) end
end

function TargetUpdate()
TsQ.mode = vts.mode
TsW.mode = vts.mode
TsE.mode = vts.mode
TsR.mode = vts.mode

TsQ:update()
TsW:update()
TsE:update()
TsR:update()
end

function RunFromMeCastE(target)
local _target = tp:GetPrediction(target)
local dist = GetDistance(myHero,_target)
local castPosX = (erange*_target.x+(dist - erange)*myHero.x)/dist
local castPosZ = (erange*_target.z+(dist - erange)*myHero.z)/dist
	Packet("S_CAST", {spellId = _E, toX = math.floor(castPosX), toY = math.floor(castPosZ), fromX = math.floor(castPosX), fromY = math.floor(castPosZ)}):send()
end

function VpCastE(target)
local dist = GetDistance(myHero,target)

if dist<=erange then
	Packet("S_CAST", {spellId = _E, toX = target.x, toY = target.z, fromX = target.x, fromY = target.z}):send()

	elseif dist>erange and dist<1200 then
		local castPosX = (erange*target.x+(dist - erange)*myHero.x)/dist
		local castPosZ = (erange*target.z+(dist - erange)*myHero.z)/dist
		local hitPos,hitChance,Position = vp:GetLineCastPosition(target, 0.6, 75, 760, 750, Vector(math.floor(castPosX),0,math.floor(castPosZ)), false)
		if hitChance >= 2 then
				
			if GetDistance(myHero,hitPos) > erange then					
				local dist2 = GetDistance(myHero,hitPos)
				local hitPosX = (erange*hitPos.x+(dist2 - erange)*myHero.x)/dist2
				local hitPosZ = (erange*hitPos.z+(dist2 - erange)*myHero.z)/dist2
				Packet("S_CAST", {spellId = _E, toX = math.floor(hitPosX), toY = math.floor(hitPosZ), fromX = math.floor(hitPosX), fromY = math.floor(hitPosZ)}):send()
			else
				Packet("S_CAST", {spellId = _E, toX = math.floor(hitPos.x), toY = math.floor(hitPos.z), fromX = math.floor(hitPos.x), fromY = math.floor(hitPos.z)}):send()
			end
		end
	end
end

function VpCastW(target)
local hitPos, HitChance, Position = vp:GetCircularCastPosition(target, 0.6, 125, 700)
     if HitChance >= 2 then
     Packet("S_CAST", {spellId = _W, toX = hitPos.x, toY = hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
     end
end

function VpCombo()
	if cfg.Combo.useR and (myHero:GetSpellData(_R).name == "ViktorChaosStorm" and TsR.target ~= nil and myHero:CanUseSpell(_R) == READY) then
		if TsR.target.health < (TsR.target.maxHealth * (cfg.RSetting.RHealth / 100)) or (CountEnemyHeroInRange(700) >= cfg.RSetting.RCount) or (myHero.health < myHero.maxHealth * 0.2) then
			CastR(TsR.target)
		end
	end

	if cfg.Combo.useE and TsQ.target ~= nil and myHero:CanUseSpell(_E) == READY and eManaManager() then
		VpCastE(TsQ.target)
		runCD = runCD + 1
		elseif cfg.Combo.useE and TsE.target ~= nil and myHero:CanUseSpell(_E) == READY and eManaManager() then
			VpCastE(TsE.target)
			runCD = runCD + 1
		end
		if runCD >= 6 and TsE.target ~= nil and myHero:CanUseSpell(_E) == READY and eManaManager() then
			RunFromMeCastE(TsE.target)
			runCD = 0
		end

		if TsQ.target ~= nil and myHero:CanUseSpell(_Q) == READY then
			CastQ(TsQ.target)
		end

		if cfg.Combo.useW and TsW.target ~= nil and myHero:CanUseSpell(_W) == READY and wManaManager() then
			VpCastW(TsW.target)
		end

	end