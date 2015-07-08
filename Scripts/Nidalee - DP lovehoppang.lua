if myHero.charName ~= "Nidalee" then return end

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("OBECJGFFHDE") 

local version = "1.2"

local existDP = false
local existHP = false
local orbwalk = nil

local selectorMode = TargetSelector(8, 1500, DAMAGE_MAGIC, 1, true)
local jungleManager = nil

_G.AUTOUPDATE = true

if FileExist(LIB_PATH .. "DivinePred.lua") then
existDP = true
    require "DivinePred"
else existDP = false
end

if FileExist(LIB_PATH .. "Hprediction.lua") then
existHP = true
    require "Hprediction"
else existHP = false
end

if not (existHP or existDP) then
print("-----------------------------------------------")
print("Please Download DivinePrediction or HPrediction")
print("-----------------------------------------------")
return
end

----------Auto Update----------
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/lovehoppang/DPkarthus/master/nidalee.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Nidalee:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/lovehoppang/DPkarthus/master/nidalee.version".."?rand="..math.random(1,10000))
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
----------Auto Update----------

local cfg = nil
local nidalee = nil
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnLoad()
	nidalee = Nidalee(existHP,existDP)
	SetOrbwalk()
	SetMenu()
	jungleManager = minionManager(MINION_JUNGLE, nidalee.spells.humanQ.range, myHero, MINION_SORT_MAXHEALTH_DEC)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function SetOrbwalk()

if _G.Reborn_Loaded then
print("<font color=\"#5D5D5D\"><b>Nidalee:</b></font> <font color=\"#FFFFFF\">SAC:Reborn LOADED</font>")
orbwalk = "Reborn"
else
orbwalk = "SxOrbwalk"
if FileExist(LIB_PATH .. orbwalk..".lua") then
require "SxOrbwalk"
else
print("-----------------------------------------------")
print("Please Download SxOrbwalk or SAC:Reborn")
print("-----------------------------------------------")
end
end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnTick()
nidalee:UpdateTs(selectorMode.mode)
nidalee:UpdateState()

if (cfg.harass.harass or cfg.toggleHarass) and nidalee.isHuman and nidalee.humanTsQ.target ~= nil and myHero:CanUseSpell(_Q) == READY then
Harass()
end

if cfg.flee.flee then
Flee()
end

if cfg.combo.combo then
Combo()
end

HealManager()

Killsteal()

StealJungle()

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnDraw()
if not cfg.draw.lagFree and nidalee.isHuman then
	if cfg.draw.drawQH then
		DrawCircle(myHero.x,myHero.y,myHero.z,nidalee.spells.humanQ.range,RGB(cfg.draw.qColor[2], cfg.draw.qColor[3], cfg.draw.qColor[4]))
	end
	if cfg.draw.drawWH then
		DrawCircle(myHero.x,myHero.y,myHero.z,nidalee.spells.humanW.range,RGB(cfg.draw.wColor[2], cfg.draw.qColor[3], cfg.draw.qColor[4]))
	end
	if cfg.draw.drawEH then
		DrawCircle(myHero.x,myHero.y,myHero.z,nidalee.spells.humanE.range,RGB(cfg.draw.eColor[2], cfg.draw.qColor[3], cfg.draw.qColor[4]))
	end
elseif cfg.draw.lagFree then
	if cfg.draw.drawQH then
		DrawLagFree(myHero.x,myHero.y,myHero.z,nidalee.spells.humanQ.range,ARGB(255,255,255,255))
	end
	if cfg.draw.drawWH then
		DrawLagFree(myHero.x,myHero.y,myHero.z,nidalee.spells.humanW.range,ARGB(255,255,255,255))
	end
	if cfg.draw.drawEH then
		DrawLagFree(myHero.x,myHero.y,myHero.z,nidalee.spells.humanE.range,ARGB(255,255,255,255))
	end	
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function DrawLagFree(x, y, z, radius, color)
local vPos1 = Vector(x, y, z)
local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
	DrawCircleNextLvl(x, y, z, radius, 1, color, 75) 
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
radius = radius or 300
local quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
local quality = 2 * math.pi / quality
radius = radius*.92
local points = {}
for theta = 0, 2 * math.pi + quality, quality do
	local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
	points[#points + 1] = D3DXVECTOR2(c.x, c.y)
end
DrawLines2(points, width or 1, color or 4294967295)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function HealManager()
if myHero.dead or not nidalee.isHuman then return end

if cfg.autoHeal.healSelf and myHero.health <= (myHero.maxHealth*(cfg.autoHeal.healSelfPercent/100)) and myHero:CanUseSpell(_E) then
nidalee:CastEH(cfg.misc.packet,myHero)
end
if cfg.autoHeal.healAllies and myHero:CanUseSpell(_E) then
	for i = 1, heroManager.iCount do
	local hero = heroManager:GetHero(i)
	if hero.team == myHero.team then
		if cfg.autoHeal.allies[hero.charName] and GetDistance(hero) < nidalee.spells.humanE.range then
			if hero.health <= (hero.maxHealth*(cfg.autoHeal.healAllyPercent/100)) and myHero:CanUseSpell(_E) then
			nidalee:CastEH(cfg.misc.packet,hero)
		end
		end
	end
	end
end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function SetMenu()
cfg = scriptConfig("Nidalee","Nidalee")
cfg:addSubMenu("Nidalee: TargetSelector","TS")
cfg:addSubMenu("Combo Options","combo")
cfg:addSubMenu("Harass Options","harass")
cfg:addSubMenu("Killsteal Options","killSteal")
cfg:addSubMenu("Auto Heal Options","autoHeal")
cfg:addSubMenu("Flee Options","flee")
cfg:addSubMenu("Misc Options","misc")
cfg:addSubMenu("Jungle Steal Options","jungleSteal")
cfg:addSubMenu("Drawing Options","draw")
cfg:addSubMenu("Prediction Options","choosePrediction")
cfg.combo:addSubMenu("Human Spells","human")
cfg.combo:addSubMenu("Cougar Spells","cougar")
cfg.combo:addParam("combo","Combo key",SCRIPT_PARAM_ONKEYDOWN, false, 32)
cfg.combo.human:addParam("useQ","Use Javelin Toss(Q)",SCRIPT_PARAM_ONOFF, true)
cfg.combo.human:addParam("useW","Use Bushwhack (W)",SCRIPT_PARAM_ONOFF, true)
cfg.combo.human:addParam("useR","Auto Transform to Cougar",SCRIPT_PARAM_ONOFF, true)
cfg.combo.cougar:addParam("useQ","Use Takedown (Q)",SCRIPT_PARAM_ONOFF, true)
cfg.combo.cougar:addParam("useW","Use Pounce (W)",SCRIPT_PARAM_ONOFF, true)
cfg.combo.cougar:addParam("pounceHunted","Cast pounce hunted target",SCRIPT_PARAM_ONOFF, true)
cfg.combo.cougar:addParam("useE","Use Swipe (E)",SCRIPT_PARAM_ONOFF, true)
cfg.combo.cougar:addParam("useR","Auto Transform to Human",SCRIPT_PARAM_ONOFF, true)
cfg.harass:addParam("harass","Harass key",SCRIPT_PARAM_ONKEYDOWN, false, string.byte('Z'))
cfg.harass:addParam("toggleHarass", "Harass toggle on/off", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
cfg.harass:addParam("harassMana","Min. Mana To Harass", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
cfg.flee:addParam("flee","Flee key",SCRIPT_PARAM_ONKEYDOWN, false, string.byte('V'))
cfg.misc:addParam("packet","Use Packet",SCRIPT_PARAM_ONOFF, true)
cfg.autoHeal:addParam("healSelf","Heal Self",SCRIPT_PARAM_ONOFF, true)
cfg.autoHeal:addParam("healSelfPercent","Heal if health < %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
cfg.autoHeal:addParam("healAllies","Heal Allies", SCRIPT_PARAM_ONOFF, false)
cfg.autoHeal:addSubMenu("Allies List","allies")
cfg.autoHeal:addParam("healAllyPercent","Heal if ally health < %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
cfg.draw:addParam("drawQH","Draw Javelin Toss(Q)",SCRIPT_PARAM_ONOFF, true)
cfg.draw:addParam("qColor", "Q Color", SCRIPT_PARAM_COLOR, {255, 100, 44, 255})
cfg.draw:addParam("drawWH","Draw Bushwhack(W)",SCRIPT_PARAM_ONOFF, false)
cfg.draw:addParam("wColor", "W Color", SCRIPT_PARAM_COLOR, {255, 100, 44, 255})
cfg.draw:addParam("drawEH","Draw PrimalSurge(E)",SCRIPT_PARAM_ONOFF, false)
cfg.draw:addParam("eColor", "E Color", SCRIPT_PARAM_COLOR, {255, 100, 44, 255})
cfg.draw:addParam("lagFree","Use Lag Free Circles",SCRIPT_PARAM_ONOFF, false)
cfg.choosePrediction:addParam("choosePrediction","Choose Prediction Lib.", SCRIPT_PARAM_LIST, 2, {"HPrediction", "Divine Prediction"})
cfg.choosePrediction:addSubMenu("Hprediction Settings","hpred")
cfg.choosePrediction.hpred:addParam("hpredHitChanceCombo","Combo HitChance", SCRIPT_PARAM_SLICE, 1.2, 1, 3, 2)
cfg.choosePrediction.hpred:addParam("hpredHitChanceHarass","Harass HitChance", SCRIPT_PARAM_SLICE, 1.2, 1, 3, 2)
cfg.killSteal:addParam("ignite","Use Ignite", SCRIPT_PARAM_ONOFF, true)
selectorMode.name = "Nidalee"
cfg.TS:addTS(selectorMode)
cfg.jungleSteal:addParam("onKey","Jungle Steal key",SCRIPT_PARAM_ONKEYDOWN, false, string.byte('G'))
cfg.jungleSteal:addParam("toggle","Jungle Steal toggle",SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte('J'))
cfg.jungleSteal:addParam("useQ","Use Q",SCRIPT_PARAM_ONOFF, true)
cfg.jungleSteal:addParam("useS","Use Smite",SCRIPT_PARAM_ONOFF, true)
cfg:addParam("arg","----------",5,"")
cfg:addParam("Author","Author: lovehoppang",5,"")
cfg:addParam("Version","Version: "..version,5,"")

for i = 1, heroManager.iCount do
local hero = heroManager:GetHero(i)
if hero.team == myHero.team and hero.charName ~= myHero.charName then
	cfg.autoHeal.allies:addParam(hero.charName,hero.charName,SCRIPT_PARAM_ONOFF, true)
end
end

if orbwalk == "SxOrbwalk" then
cfg:addSubMenu("Orbwalking Options","orbWalking")
SxOrb:LoadToMenu(cfg.orbWalking)
end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function StealJungle()
local stealOn = cfg.jungleSteal.onKey or cfg.jungleSteal.toggle
local useQ = cfg.jungleSteal.useQ
local smiteOn = cfg.jungleSteal.useS

if stealOn and smiteOn and nidalee.smite ~= nil then

if myHero:CanUseSpell(nidalee.smite) == READY then
jungleManager.range = 550
jungleManager:update()

if jungleManager.objects[1] ~= nil and nidalee.smite ~= nil then

local obj = jungleManager.objects[1]
	if obj.name == "SRU_Murkwolf8.1.1" or obj.name == "SRU_Murkwolf2.1.1" then
		if nidalee:GetSmiteDmg() > obj.health and GetDistance(obj) < 550 then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Razorbeak3.1.1" or obj.name == "SRU_Razorbeak9.1.1" then
		if nidalee:GetSmiteDmg() > obj.health and GetDistance(obj) < 550 then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Gromp14.1.1" or obj.name == "SRU_Gromp13.1.1" then
		if nidalee:GetSmiteDmg() > obj.health and GetDistance(obj) < 550 then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Krug5.1.2" or obj.name == "SRU_Krug11.1.2" then
		if nidalee:GetSmiteDmg() > obj.health and GetDistance(obj) < 550 then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Red4.1.1" or obj.name == "SRU_Red10.1.1" then
		if nidalee:GetSmiteDmg() > obj.health and GetDistance(obj) < 550 then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Blue1.1.1" or obj.name == "SRU_Blue7.1.1" then
		if nidalee:GetSmiteDmg() > obj.health and GetDistance(obj) < 550 then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Dragon6.1.1" and GetDistance(obj) < 550 then
		if nidalee:GetSmiteDmg() > obj.health then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	elseif obj.name == "SRU_Baron12.1.1" and GetDistance(obj) < 550 then
		if nidalee:GetSmiteDmg() > obj.health then nidalee:CastSmite(cfg.misc.packet,obj)
		end
	end

end

end

end

if stealOn and useQ then

if myHero:CanUseSpell(_Q) == READY then
jungleManager.range = nidalee.spells.humanQ.range
jungleManager:update()

if jungleManager.objects[1] ~= nil then
local obj = jungleManager.objects[1]
	if obj.name == "SRU_Murkwolf8.1.1" or obj.name == "SRU_Murkwolf2.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Razorbeak3.1.1" or obj.name == "SRU_Razorbeak9.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Gromp14.1.1" or obj.name == "SRU_Gromp13.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Krug5.1.2" or obj.name == "SRU_Krug11.1.2" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Red4.1.1" or obj.name == "SRU_Red10.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Blue1.1.1" or obj.name == "SRU_Blue7.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Dragon6.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	elseif obj.name == "SRU_Baron12.1.1" then
		if nidalee:GetActualSpearDamage(obj) > obj.health and GetDistance(obj) < nidalee.spells.humanQ.range then nidalee:CastQH(cfg.misc.packet,obj,0,cfg.choosePrediction.choosePrediction)
		end
	end
end

end

end


end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Killsteal()
if cfg.killSteal.ignite and nidalee.ignite ~= nil then

if myHero:CanUseSpell(nidalee.ignite) == READY then
	for i, enemy in pairs(GetEnemyHeroes()) do
		if getDmg("IGNITE",enemy,myHero) > enemy.health and GetDistance(enemy) < 600 then
			nidalee:CastIgnite(cfg.misc.packet,enemy)
		end
	end
end
end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Combo()
local target = nidalee:GetPounceTarget()

if not nidalee.isHuman then
	if cfg.combo.cougar.useW and cfg.combo.cougar.pounceHunted and target ~= nil and GetDistance(target) <= 730 and myHero:CanUseSpell(_W) == READY and nidalee:CanHitW(target) and not target.dead then
		nidalee:CastWC(cfg.misc.packet,target)
	elseif cfg.combo.cougar.useW and nidalee.cougarTsW.target ~= nil and myHero:CanUseSpell(_W) == READY and nidalee:CanHitW(nidalee.cougarTsW.target) and not nidalee.cougarTsW.target.dead then
		nidalee:CastWC(cfg.misc.packet,nidalee.cougarTsW.target)
	end
	if cfg.combo.cougar.useE and nidalee.cougarTsE.target ~= nil and myHero:CanUseSpell(_E) == READY then
		nidalee:CastEC(cfg.misc.packet,nidalee.cougarTsE.target)
	end
	if cfg.combo.cougar.useQ and CountEnemyHeroInRange(nidalee.spells.cougarQ.range+GetDistance(myHero.minBBox)) >= 1 and myHero:CanUseSpell(_Q) == READY then
		nidalee:CastQC(cfg.misc.packet)
	end
	if nidalee.spells.humanQ.cooldown <= GetGameTimer() and nidalee.spells.humanQ.level >= 1 and (nidalee.cougarTsW.target == nil and target == nil) and myHero.mana >= nidalee.spells.humanQ.mana then
		nidalee:ChangeForm()
	end
elseif nidalee.isHuman then
	if cfg.combo.human.useQ and nidalee.humanTsQ.target ~= nil and myHero:CanUseSpell(_Q) == READY then
		nidalee:CastQH(cfg.misc.packet,nidalee.humanTsQ.target,cfg.choosePrediction.hpred.hpredHitChanceCombo,cfg.choosePrediction.choosePrediction)
	end
	if cfg.combo.human.useW and nidalee.humanTsW.target ~= nil and myHero:CanUseSpell(_W) == READY then
		nidalee:CastWH(cfg.misc.packet,nidalee.humanTsW.target,cfg.choosePrediction.hpred.hpredHitChanceCombo,cfg.choosePrediction.choosePrediction)
	end
	if (myHero:CanUseSpell(_Q) == COOLDOWN or myHero:CanUseSpell(_Q) == NOMANA or myHero:CanUseSpell(_Q) == NOTLEARNED) and cfg.combo.human.useR and (nidalee.cougarTsW.target ~= nil or target ~= nil) then
		nidalee:ChangeForm()
	end
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Harass()
	nidalee:CastQH(cfg.packet,nidalee.humanTsQ.target,cfg.choosePrediction.hpred.hpredHitChanceHarass,cfg.choosePrediction.choosePrediction)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Flee()
	if nidalee.isHuman then
		nidalee:ChangeForm(cfg.misc.packet)
	elseif myHero:CanUseSpell(_W) == READY then nidalee:Flee(cfg.misc.packet)
	else nidalee:MoveToCursor()
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnProcessSpell(obj, spell)
	if obj ~= myHero then return end
	
	if nidalee.isHuman then
		if spell.name == "JavelinToss" then
			nidalee.spells.humanQ.cooldown = myHero:GetSpellData(_Q).cd + GetGameTimer()
		elseif spell.name == "Bushwhack" then
			nidalee.spells.humanW.cooldown = myHero:GetSpellData(_W).cd + GetGameTimer()
		elseif spell.name == "PrimalSurge" then
			nidalee.spells.humanE.cooldown = myHero:GetSpellData(_E).cd + GetGameTimer()
		end
	elseif not nidalee.isHuman then
		if spell.name == "Pounce" then
			nidalee.spells.cougarW.cooldown = myHero:GetSpellData(_W).cd + GetGameTimer()
		elseif spell.name == "Swipe" then
			nidalee.spells.cougarE.cooldown = myHero:GetSpellData(_E).cd + GetGameTimer()
		end
	end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnRemoveBuff(obj, buff)
if not obj.isMe then return end
if buff.name == "Takedown" then
nidalee.spells.cougarQ.cooldown = myHero:GetSpellData(_Q).cd + GetGameTimer()
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--class region--
class "Nidalee"
function Nidalee:__init(existHp,existDp)

self.spells = {
	humanQ = {range = 1500, width = 40, speed = 1300, delay = 0.125, cooldown = 0, level = 0, mana = 0},
	humanW = {range = 900, radius = 62, speed = 1450, delay = 0.5, cooldown = 0, level = 0, mana = 0},
	humanE = {range = 600, radius = 0, speed = math.huge, delay = 0, cooldown = 0, level = 0, mana = 0},
	cougarQ = {range = 50, radius = 0, speed = 500, delay = 0, cooldown = 0, level = 0},
	cougarW = {range = 375, radius = 75, speed = 1500, delay = 0.5, cooldown = 0, level = 0},
	cougarE = {range = 300, radius = 0, speed = math.huge, delay = 0, cooldown = 0, level = 0}
}

self.isHuman = true
self:SetTargetSelector()
if existHp then
self.HPred = HPrediction()
end
if existDp then
self.dp = DivinePred()
end
self:SetSpellData(existHp,existDp)

end

----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:UpdateTs(mode)

if myHero.dead then
return
end

self.humanTsQ.mode = mode
self.humanTsW.mode = mode
self.cougarTsW.mode = mode
self.cougarTsE.mode = mode

self.humanTsQ:update()
self.humanTsW:update()
self.cougarTsW:update()
self.cougarTsE:update()

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:UpdateState()
self.spells.humanQ.level = myHero:GetSpellData(_Q).level
self.spells.humanW.level = myHero:GetSpellData(_W).level
self.spells.humanE.level = myHero:GetSpellData(_E).level
self.spells.cougarQ.level = myHero:GetSpellData(_Q).level
self.spells.cougarW.level = myHero:GetSpellData(_W).level
self.spells.cougarE.level = myHero:GetSpellData(_E).level

if myHero:GetSpellData(_Q).name == "JavelinToss" then
	self.spells.humanQ.mana = myHero:GetSpellData(_Q).mana
end
if myHero:GetSpellData(_W).name == "Bushwhack" then
	self.spells.humanW.mana = myHero:GetSpellData(_W).mana
end
if myHero:GetSpellData(_E).name == "PrimalSurge" then
	self.spells.humanE.mana = myHero:GetSpellData(_E).mana
end

self.isHuman = myHero:GetSpellData(_Q).name == "JavelinToss"
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastQH(packet,target,hitChance,prediction)
if prediction == 1 then
	local hitPos, _hitChance = self.HPred:GetPredict("Q",target,myHero)
	if _hitChance >= hitChance then

	if packet then
		Packet("S_CAST",{spellId = _Q, toX=hitPos.x, toY=hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
	else
    	CastSpell(_Q,hitPos.x,hitPos.z)
	end

	end
elseif prediction == 2 then
	if self.divineLastTime + self.divineCd > GetGameTimer() then return end
	target = DPTarget(target)
	local state,hitPos,perc = self.dp:predict(target,self.divineQSkill)
	if state == SkillShot.STATUS.SUCCESS_HIT then

	if packet then
		Packet("S_CAST",{spellId = _Q, toX=hitPos.x, toY=hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
	else
    	CastSpell(_Q,hitPos.x,hitPos.z)
	end

	end
	self.divineLastTime = GetGameTimer()
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastWH(packet,target,hitChance,prediction)
if prediction == 1 then
	local hitPos, _hitChance = self.HPred:GetPredict("W",target,myHero)
	if _hitChance >= hitChance then

	if packet then
		Packet("S_CAST",{spellId = _W, toX=hitPos.x, toY=hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
	else
    	CastSpell(_W,hitPos.x,hitPos.z)
	end

	end
elseif prediction == 2 then
	
	target = DPTarget(target)
	local state,hitPos,perc = self.dp:predict(target,CircleSS(math.huge,self.spells.humanW.range,self.spells.humanW.radius*2,250,math.huge))
	if state == SkillShot.STATUS.SUCCESS_HIT then

	if packet then
		Packet("S_CAST",{spellId = _W, toX=hitPos.x, toY=hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
	else
    	CastSpell(_Q,hitPos.x,hitPos.z)
	end

	end
	
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastEH(packet,target)
if packet then 
	Packet("S_CAST",{spellId = _E, targetNetworkId = target.networkID}):send()
else
	CastSpell(_E,target)	
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastQC(packet)
if packet then 
	Packet("S_CAST",{spellId = _Q}):send()
else
	CastSpell(_Q)
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastWC(packet,target)

if packet then 
	Packet("S_CAST",{spellId = _W, toX=target.x, toY=target.z, fromX = target.x, fromY = target.z}):send()
else
	CastSpell(_W,target.x,target.z)
end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastEC(packet,target,hitchance)
if packet then 
	Packet("S_CAST",{spellId = _E, toX=target.x, toY=target.z, fromX = target.x, fromY = target.z}):send()
else
	CastSpell(_E, target.x, target.z)	
end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:SetSpellData(existHp,existDp)
if existDp then
-----Divine Prediction-----
self.divineQSkill = SkillShot.PRESETS['JavelinToss']
self.divineLastTime = GetGameTimer()
self.divineCd = 0.4
-----Divine Prediction-----
end
if existHp then
-----Human Q-----
Spell_Q.collisionM['Nidalee'] = true
Spell_Q.collisionH['Nidalee'] = true
Spell_Q.delay['Nidalee'] = self.spells.humanQ.delay
Spell_Q.range['Nidalee'] = self.spells.humanQ.range
Spell_Q.speed['Nidalee'] = self.spells.humanQ.speed
Spell_Q.type['Nidalee'] = "DelayLine"
Spell_Q.width['Nidalee'] = self.spells.humanQ.width
-----Human Q-----
-----Human W-----
Spell_W.collisionM['Nidalee'] = false
Spell_W.collisionH['Nidalee'] = false
Spell_W.delay['Nidalee'] = self.spells.humanW.delay
Spell_W.range['Nidalee'] = self.spells.humanW.range
Spell_W.type['Nidalee'] = "PromptCircle"
Spell_W.radius['Nidalee'] = self.spells.humanW.radius
-----Human W-----
end
-----Smite and Ignite-----
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
    self.ignite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    self.ignite = SUMMONER_2
  end
  
  if myHero:GetSpellData(SUMMONER_1).name:find("smite") then
    self.smite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then
    self.smite = SUMMONER_2
  end
-----Smite and Ignite-----
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:SetTargetSelector()
self.humanTsQ = TargetSelector(TARGET_LESS_CAST, self.spells.humanQ.range, DAMAGE_MAGIC, false)
self.humanTsW = TargetSelector(TARGET_LESS_CAST, self.spells.humanW.range+self.spells.humanW.radius, DAMAGE_MAGIC, false)

self.cougarTsW = TargetSelector(TARGET_LESS_CAST, self.spells.cougarW.range+self.spells.cougarW.radius, DAMAGE_MAGIC, false)
self.cougarTsE = TargetSelector(TARGET_LESS_CAST, self.spells.cougarE.range+self.spells.cougarE.radius, DAMAGE_MAGIC, false)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:ChangeForm(packet)
if packet then
	Packet("S_CAST",{spellId = _R}):send()
else
    CastSpell(_R)
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:Flee(packet)
if packet then
	Packet("S_CAST",{spellId = _W, toX=mousePos.x, toY=mousePos.z, fromX = mousePos.x, fromY = mousePos.z}):send()
else
    CastSpell(_W, mousePos.x, mousePos.z)
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:MoveToCursor()
	if GetDistance(mousePos) > 1 then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
		myHero:MoveTo(moveToPos.x, moveToPos.z)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:GetPounceTarget()
for i, enemy in pairs(GetEnemyHeroes()) do
if TargetHaveBuff("nidaleepassivehunted",enemy) then return enemy end
end
return nil
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:GetActualSpearDamage(target)
local damage = getDmg("Q", target,myHero)
local increasedDamageFactor = 1

if GetDistance(target) < 525 then return damage
elseif GetDistance(target) > 1300 then return damage * 2.5
else
local dis = GetDistance(target) - 525
return damage+(damage*0.19*dis)
end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:GetCougarDamage(target)
local totalDamage = 0

local cougarQ=0
local cougarW=0
local cougarE=0

local baseDamageQ=0
local baseDamageW=0
local baseDamageE=0

if self.spells.cougarQ.cooldown <= GetGameTimer() then
	if self.spells.cougarQ.level == 1 then baseDamageQ = 4
	elseif self.spells.cougarQ.level == 2 then baseDamageQ = 20
	elseif self.spells.cougarQ.level == 3 then baseDamageQ = 50
	elseif self.spells.cougarQ.level >= 4 then baseDamageQ = 90
	end
	cougarQ = baseDamageQ + myHero.damage*0.75 + myHero.ap * 0.36
end
if self.spells.cougarW.cooldown <= GetGameTimer() then
	if self.spells.cougarW.level <= 4 then baseDamageW = self.spells.cougarW.level*50
	else baseDamageW = 4*50
	end
	cougarW = baseDamageW + myHero.ap * 0.3
end
if self.spells.cougarE.cooldown <= GetGameTimer() then
	if self.spells.cougarE.level <= 4 then baseDamageE = self.spells.cougarE.level*60 + 10
	else baseDamageE = 4*60 + 10
	end
	cougarE = baseDamageE + myHero.ap * 0.45
end
if cougarQ > 0 then
cougarQ = myHero:CalcMagicDamage(target,cougarQ)
end
if cougarW > 0 then
cougarW = myHero:CalcMagicDamage(target,cougarW)
end
if cougarE > 0 then
cougarE = myHero:CalcMagicDamage(target,cougarE)
end
totalDamage = cougarQ+cougarW+cougarE

return totalDamage
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CanHitW(target)
if GetDistance(target) >= nidalee.spells.cougarW.range-nidalee.spells.cougarW.radius-GetDistance(myHero.minBBox) then return true end
return false
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastSmite(packet,target)
if packet then
	Packet("S_CAST",{spellId = self.smite, targetNetworkId = target.networkID}):send()
else
    CastSpell(self.smite,target)
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:CastIgnite(packet,target)
if packet then
	Packet("S_CAST",{spellId = self.ignite, targetNetworkId = target.networkID}):send()
else
    CastSpell(self.ignite,target)
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Nidalee:GetSmiteDmg()
return math.max(20*myHero.level+370,30*myHero.level+330,40*myHero.level+240,50*myHero.level+100)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------