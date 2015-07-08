-- ====================================================================================== --
-- =============================[zAwareness - Author: Zaiat]============================= -- if mPos.x >= 300 or mPos.y >= 150 then zAwarenessLogo:Draw(10, 10, 255) end
-- ====================================================================================== --
-- Features: http://forum.botoflegends.com/topic/60426-free-zawareness-yet-another-awareness-script/
-- Libraries: https://github.com/ElZaiat/zAwareness/tree/master/Scripts/Common
-- Sprites: https://github.com/ElZaiat/zAwareness/blob/master/Sprites/zAwareness.rar?raw=true
local version = 1.22
local aUpdate = true

-- ========================================================================== --
-- ==============================[ScriptStatus]============================== --
-- ========================================================================== --
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBEDDEDBBGE") 

-- ======================================================================== --
-- =============================[New Features]============================= --
-- ======================================================================== --
-- Added Sprites Settings sub-menu.
-- Changed version format. [v2.2 = v1.22]
-- Updated zSxUpdate library, re-download to activate auto-updater.

-- ======================================================================== --
-- ============================[To-Do Features]============================ --
-- ======================================================================== --
-- Improve gank-detection system.
-- Jungle camps timers
-- Dragon & Baron timers
-- Inhibitors respawn timers
-- Size & Opacity enemy HUD controllers

-- ====================================================================================== --
-- =================================[Required Libraries]================================= --
-- ====================================================================================== --
-- vPrediction: https://raw.githubusercontent.com/ElZaiat/zAwareness/master/Scripts/Common/VPrediction.lua
require "VPrediction"
-- zSxUpdate: https://raw.githubusercontent.com/ElZaiat/zAwareness/master/Scripts/Common/zSxUpdate.lua
require 'zSxUpdate' 

-- =================================================================== --
-- =============================[Credits]============================= --
-- =================================================================== --
-- redprince 	[Minimap MIA icons]		[ http://forum.botoflegends.com/user/148524-redprince/ ]
-- Ralphlol 	[vPrediction]			[ http://forum.botoflegends.com/user/89149-ralphlol/ ]
-- iCreative 	[isFacing function] 	[ http://forum.botoflegends.com/user/137788-icreative/ ]
-- Aroc 		[SxUpdate]				[ http://forum.botoflegends.com/user/79051-aroc/ ]

-- ========================================================================== --
-- =============================[External Links]============================= --
-- ========================================================================== --
-- Extra Awareness - Author: redprince [Standalone Minimap MIA Script] [ http://forum.botoflegends.com/topic/60531-freevip-extra-awareness/ ]
-- zTowers - Author: Zaiat [Standalone Towers Range Script] [ http://forum.botoflegends.com/topic/60249-ztowers-smart-towers-range-indicator/ ]

-- ============================================================================ --
-- =============================[Public Variables]============================= --
-- ============================================================================ --
local VP = nil
local ConfigMenu = nil
local zcConfigMenu = nil
local zAwarenessLogo = nil
local champs = {}
local aChamps = {}
local champsPics = {}
local champsIcons = {}
local champPos = {}
local champPath = {}
local champWasDead = {}
local miaTime = {}
local miaTimer = {}
local summPics = {}
local summPicsOS = {}
local screenConstX = 0.9224011713030747
local screenConstY = 0.3645833333333333
local posX = WINDOW_W * screenConstX
local posY = {WINDOW_H * screenConstY, WINDOW_H * screenConstY + 60, WINDOW_H * screenConstY + 120, WINDOW_H * screenConstY + 180, WINDOW_H * screenConstY + 240}
local posE = false
local tRange = 950
local towers = {}
local tHealth = {1000, 1200, 1300, 1500, 2000, 2300, 2500}
local enemyMinions = nil
local wardPics = {}
local swards = {}
local vwards = {}
local pathPics = {}
local tUnit = {}
local tSpell = {}

-- ==================================================================================== --
-- =============================[Load Script Requirements]============================= --
-- ==================================================================================== --
function autoUpdate()
	    local ToUpdate = {}
		ToUpdate.Version = version
		ToUpdate.UseHttps = true
		ToUpdate.Host = "raw.githubusercontent.com"
		ToUpdate.VersionPath = "/ElZaiat/zAwareness/master/zAwareness.Version"
		ToUpdate.ScriptPath =  "/ElZaiat/zAwareness/master/Scripts/zAwareness.lua"
		ToUpdate.SavePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
		ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color=\"#FF8000\"><b>[zAwareness] </b></font><font color=\"#FFFFFF\">Updated to "..NewVersion..". </b></font> <font color=\"#FF5555\"><b>(Press F9 twice to apply the new update)</b></font>") end
		ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color=\"#FF8000\"><b>[zAwareness] </b></font><font color=\"#FFFFFF\">No Updates Found</b></font>.") end
		ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color=\"#FF8000\"><b>[zAwareness] </b></font><font color=\"#FFFFFF\">New Version found ("..NewVersion.."). Please wait until its downloaded</b></font>") end
		ToUpdate.CallbackError = function(NewVersion) print("<font color=\"#FF0000\"><b>[zAwareness] </b></font><font color=\"#FFFFFF\">Error while Downloading. Please try again.</b></font>") end
		ScriptUpdate(ToUpdate.Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end

function OnLoad()
	if aUpdate then autoUpdate() else print("<font color=\"#FF8000\"><b>[zAwareness] </b></font><font color=\"#FFFFFF\">Automatic updates are locally disabled.</b></font>") end
	VP = VPrediction()
	enemyMinions = minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC)
	zAwarenessLogo = createSprite(SPRITE_PATH .. "\\zAwareness\\zAwareness.png")
	zAwarenessLogo:SetScale(0.5, 0.5)
   
	for i = 1, heroManager.iCount, 1 do
		local champ = heroManager:getHero(i)
		if champ ~= nil then
			summPicsOS[i] = {}
			if string.find(champ:GetSpellData(SUMMONER_1).name, "smite") ~= nil then
				summPicsOS[i][0] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\zsummonersmite.png")
			else
				summPicsOS[i][0] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\z" .. champ:GetSpellData(SUMMONER_1).name .. ".png")
			end
			if string.find(champ:GetSpellData(SUMMONER_2).name, "smite") ~= nil then
				summPicsOS[i][1] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\zsummonersmite.png")
			else
				summPicsOS[i][1] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\z" .. champ:GetSpellData(SUMMONER_2).name .. ".png")
			end
			summPicsOS[i][0]:SetScale(0.65, 0.65)
			summPicsOS[i][1]:SetScale(0.65, 0.65)
		end
		if champ ~= myHero and champ.team == myHero.team then
			table.insert(aChamps, champ)
		end
	end
   
	for i, target in pairs(GetEnemyHeroes()) do
		if target ~= nil then
			local exists = false
			for j, champ in pairs(champs) do
				if champ ~= nil then
					if champ == target then
						exists = true
						break
					end
				end
			end
			if exists == false then
				miaTime[i] = 0
				miaTimer[i] = 0
				table.insert(champs, target)
				table.insert(champsPics, createSprite(SPRITE_PATH .. "\\zAwareness\\champions\\" .. target.charName .. "_Square_0.png"))
				table.insert(champsIcons, createSprite(SPRITE_PATH .. "\\zAwareness\\champIcons\\" .. target.charName .. ".png"))
				table.insert(pathPics, createSprite(SPRITE_PATH .. "\\zAwareness\\champions\\" .. target.charName .. "_Square_0.png"))
				champsIcons[i]:SetScale(0.4, 0.4)
				pathPics[i]:SetScale(0.6, 0.6)
			   
				summPics[i] = {}
				if string.find(target:GetSpellData(SUMMONER_1).name, "smite") ~= nil then
					summPics[i][0] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\zsummonersmite.png")
				else
					summPics[i][0] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\z" .. target:GetSpellData(SUMMONER_1).name .. ".png")
				end
				if string.find(target:GetSpellData(SUMMONER_2).name, "smite") ~= nil then
					summPics[i][1] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\zsummonersmite.png")
				else
					summPics[i][1] = createSprite(SPRITE_PATH .. "\\zAwareness\\summoners\\z" .. target:GetSpellData(SUMMONER_2).name .. ".png")
				end
													   
				wardPics[0] = createSprite(SPRITE_PATH .. "\\zAwareness\\misc\\sward.png")
				wardPics[1] = createSprite(SPRITE_PATH .. "\\zAwareness\\misc\\vward.png")
				wardPics[0]:SetScale(0.7, 0.7)
				wardPics[1]:SetScale(0.8, 0.8)
				
				champPos[i] = {}
				champPath[i] = {}
				champWasDead[i] = true
			end
		end
	end
	
	createMenu()
	
	for i = 1, objManager.iCount, 1 do
		local tow = objManager:getObject(i)
		if tow ~= nil then
			for j, health in ipairs(tHealth) do
				if tow.type == "obj_AI_Turret" and not string.find(tow.name, "TurretShrine") then
					table.insert(towers, tow)
					break
				end
			end
		end
	end
	print("<font color=\"#FF8000\"><b>[zAwareness] </b></font><font color=\"#FFFFFF\">v" .. version .. " Started</font> <font color=\"#FF8000\"><b>[Author: Zaiat]</b></font>")
end

function createMenu()
	ConfigMenu = scriptConfig("zAwareness", "zAwareness")
	
	ConfigMenu:addSubMenu("Enemy HUD Settings", "enemyHUD")
		ConfigMenu.enemyHUD:addParam("Enable", "Enable HUD", SCRIPT_PARAM_ONOFF, true)
		ConfigMenu.enemyHUD:addParam("cdNotifier", "Cooldowns Team Notifier", SCRIPT_PARAM_ONOFF, true)
		ConfigMenu.enemyHUD:addParam("setPosition", "Edit Display Position", SCRIPT_PARAM_ONKEYDOWN, false,  string.byte("K"))
		ConfigMenu.enemyHUD:addParam("resetPosition", "Reset Display Position", SCRIPT_PARAM_ONKEYDOWN, false,  string.byte("L"))
		
	ConfigMenu:addSubMenu("Ganks Detection", "GanksDetection")
		ConfigMenu.GanksDetection:addParam("Enable", "Enable Ganks Detection", SCRIPT_PARAM_ONOFF, true)
		for i, champ in pairs(champs) do
			if i == 1 then 
				ConfigMenu.GanksDetection:addParam("A", "A) " .. champ.charName, SCRIPT_PARAM_ONOFF, true)
			else
				if i == 2 then 
					ConfigMenu.GanksDetection:addParam("B", "B) " .. champ.charName, SCRIPT_PARAM_ONOFF, true)
				else
					if i == 3 then 
						ConfigMenu.GanksDetection:addParam("C", "C) " .. champ.charName, SCRIPT_PARAM_ONOFF, true)
					else
						if i == 4 then 
							ConfigMenu.GanksDetection:addParam("D", "D) " .. champ.charName, SCRIPT_PARAM_ONOFF, true)
						else 
							ConfigMenu.GanksDetection:addParam("E", "E) " .. champ.charName, SCRIPT_PARAM_ONOFF, true)
						end 
					end
				end
			end
		end
		
	
	
	ConfigMenu:addParam("drawOSInfo", "Champions Gamescreen Tracker", SCRIPT_PARAM_ONOFF, true)
	ConfigMenu:addParam("drawPaths", "Enemy Waypoints", SCRIPT_PARAM_ONOFF, true)
	ConfigMenu:addParam("drawMIA", "MIA Information", SCRIPT_PARAM_ONOFF, true)
	ConfigMenu:addParam("drawWards", "Wards Tracker", SCRIPT_PARAM_ONOFF, true)
	ConfigMenu:addParam("drawLastHit", "Minions Last Hit Indicator", SCRIPT_PARAM_ONOFF, true)
	
	ConfigMenu:addSubMenu("Towers Settings", "drawTower")
		ConfigMenu.drawTower:addParam("range", "Towers Range Indicator", SCRIPT_PARAM_ONOFF, true)
		ConfigMenu.drawTower:addParam("target", "Towers Target Indicator", SCRIPT_PARAM_ONOFF, true)
		
	ConfigMenu:addSubMenu("Sprites Settings", "drawSprites")
		ConfigMenu.drawSprites:addParam("drawMiniMIA", "Draw minimap MIA positions", SCRIPT_PARAM_ONOFF, true)
		ConfigMenu.drawSprites:addParam("drawMiniWard", "Draw minimap wards positions", SCRIPT_PARAM_ONOFF, true)
		ConfigMenu.drawSprites:addParam("drawLogo", "Draw zAwareness logo", SCRIPT_PARAM_ONOFF, true)
		
-- ========================================================================== --
-- =============================[zEkkoHelper St]============================= --
-- ========================================================================== --
	zcConfigMenu = scriptConfig("zChampionHelper", "zChampionHelper")
	zcConfigMenu:addSubMenu("z" .. myHero.charName .. "Helper", "zcHelper")
	if myHero.charName == "Ekko" then
		zcConfigMenu:addParam("Enable", "Enable zEkkoHelper", SCRIPT_PARAM_ONOFF, true)
		zcConfigMenu.zcHelper:addParam("drawW", "[W Spell] Draw W spell radius & cd", SCRIPT_PARAM_ONOFF, true)
		zcConfigMenu.zcHelper:addSubMenu("[R Spell] R Spell Settings", "configR")
		zcConfigMenu.zcHelper.configR:addParam("drawR", "[R Spell] Draw R spell radius", SCRIPT_PARAM_ONOFF, true)
		zcConfigMenu.zcHelper.configR:addParam("drawRL", "[R Spell] Draw line to R spell location", SCRIPT_PARAM_ONOFF, true)
	end
	
end

-- ========================================================================== --
-- ==================================[Ekko]================================== --
-- ========================================================================== --
local oEkkoW = {"Ekko_Base_W_Indicator.troy", "Ekko_Base_W_Cas.troy", "Ekko_Base_W_Detonate_Slow.troy"}
local tEkkoW = nil
local oEkkoR = {"Ekko_Base_R_TrailEnd.troy"}


function DrawEkkoW(ekko)
	if ekko.name:find(oEkkoW[1]) or ekko.name:find(oEkkoW[2]) or ekko.name:find(oEkkoW[3]) then
		DrawCircle(ekko.x, ekko.y, ekko.z, 405, 0xFFFFFFFF)
		if tEkkoW == nil then tEkkoW = GetGameTimer() + 5 end
		if tEkkoW < GetGameTimer() then
			tEkkoW = nil
		else
			if tEkkoW - GetGameTimer() >= 2 then
				DrawText3D(tostring(round(tEkkoW - GetGameTimer(), 2)), ekko.x, ekko.y, ekko.z, 16, 0xFFFF0000, center)
				DrawText3D(tostring(round(tEkkoW - GetGameTimer(), 2)), myHero.x, myHero.y, myHero.z, 16, 0xFFFFFF00, center)
			else
				DrawText3D(tostring(round(tEkkoW - GetGameTimer(), 2)), ekko.x, ekko.y, ekko.z, 16, 0xFFFFFFFF, center)
				DrawText3D(tostring(round(tEkkoW - GetGameTimer(), 2)), myHero.x, myHero.y, myHero.z, 16, 0xFFFFFFFF, center)
			end
		end
	end
end

function DrawEkkoR(ekko)
	if ekko.name:find(oEkkoR[1]) then
		DrawCircle(ekko.x, ekko.y, ekko.z, 405, 0x55FFFF00)
	end
end

function DrawEkkoRL(ekko)
	if ekko.name:find(oEkkoR[1]) then
		DrawLine3D(myHero.x, myHero.y, myHero.z, ekko.x, ekko.y, ekko.z, 2, 0x55FFFF00)
	end
end
	
-- ========================================================================== --
-- =================================[Global]================================= --
-- ========================================================================== --
function zcHelper()
	if myHero.charName == "Ekko" then
		local Ekko = zcConfigMenu.zcHelper
		for i = 1, objManager.iCount, 1 do
			local ekko = objManager:getObject(i)
			if ekko ~= nil and ekko.name ~= nil and ekko.name:find("Ekko_Base") then
				if Ekko.drawW then DrawEkkoW(ekko) end
				if Ekko.configR.drawR then DrawEkkoR(ekko) end
				if Ekko.configR.drawRL then DrawEkkoRL(ekko) end
			end
		end
	end
end
-- ========================================================================== --
-- =============================[zEkkoHelper En]============================= --
-- ========================================================================== --

-- ========================================================================== --
-- =============================[Tick Functions]============================= --
-- ========================================================================== --
function OnTick()
	updateWindow()
	if ConfigMenu.enemyHUD.Enable then
		if ConfigMenu.enemyHUD.setPosition then 
			setHUD() 
		else 
			if ConfigMenu.enemyHUD.resetPosition then 
				posE = false 
			end 
		end
	end
	
	for i, champ in pairs(champs) do
		if champ ~= nil then
			if champ.dead then
				champPos[i] = {nil, nil, nil}
				champWasDead[i] = true
			else
				if champWasDead[i] then
					champWasDead[i] = false
					champPos[i] = {champ.x, champ.y, champ.z}
				else
					if champ.visible then
						champPos[i] = {champ.x, champ.y, champ.z}
					end
				end
			end
		end
	end
end

function updateWindow()
	UpdateWindow()
	if posE == false then
		posX = WINDOW_W * screenConstX
		posY = {WINDOW_H * screenConstY, WINDOW_H * screenConstY + 60, WINDOW_H * screenConstY + 120, WINDOW_H * screenConstY + 180, WINDOW_H * screenConstY + 240}
	end
end

-- ========================================================================== --
-- =============================[Draw Functions]============================= --
-- ========================================================================== --
function OnDraw()  
	if zcConfigMenu.Enable then zcHelper() end
	if ConfigMenu.drawOSInfo then drawOSInfo() end
	if ConfigMenu.drawLastHit then drawLastHit() end
	if ConfigMenu.drawTower.range then drawTowersRange() end
	if ConfigMenu.drawTower.target then drawTowersTarget() end

	for i, champ in pairs(champs) do
		if champ.visible then
			if ConfigMenu.GanksDetection.Enable and (not myHero.dead) and (not champ.dead) then
				GanksDetection(i, champ)
			end
			if ConfigMenu.enemyHUD.Enable then DrawVisible(champ, i) end
		else
			if ConfigMenu.drawMIA then updateMIA(i) end
			if ConfigMenu.enemyHUD.Enable then DrawInvisible(champ, i) end
		end
	end
   
	if ConfigMenu.drawWards then drawWards() end
	if ConfigMenu.drawPaths then drawPaths() end
	if ConfigMenu.enemyHUD.Enable and ConfigMenu.enemyHUD.cdNotifier then drawHoverBox() end
	
	local mPos = WorldToScreen(mousePos)
	if ConfigMenu.drawSprites.drawLogo and (mPos.x >= 300 or mPos.y >= 150) then zAwarenessLogo:Draw(10, 10, 255) end
end

function drawHoverBox()
	local mPos = WorldToScreen(mousePos), pos, cPos, dist
	for i = 1, #posY do
		pos = {posX-30, posY[i]-2}
		cPos = {pos[1] + 12, pos[2]+7}
		dist = math.ceil(math.sqrt(math.pow(mPos.x - cPos[1], 2) + math.pow(mPos.y - cPos[2], 2)))
		if dist <= 9 then
			DrawRectangle(pos[1], pos[2], 20, 20, 0xBB000055)
			break
		else
			pos = {posX-30, posY[i]+27}
			cPos = {pos[1] + 12, pos[2]+7}
			dist = math.ceil(math.sqrt(math.pow(mPos.x - cPos[1], 2) + math.pow(mPos.y - cPos[2], 2)))
			if dist <= 9 then
				DrawRectangle(pos[1], pos[2], 20, 20, 0xBB000055)
				break
			end
		end
	end
end


function OnWndMsg(msg,wParam)
	if msg == WM_LBUTTONUP then
		if ConfigMenu.enemyHUD.Enable and ConfigMenu.enemyHUD.cdNotifier then
			local mPos = WorldToScreen(mousePos), pos, cPos, dist, cd
			for i = 1, #posY do
				pos = {posX-30, posY[i]-2}
				cPos = {pos[1] + 12, pos[2]+7}
				dist = math.ceil(math.sqrt(math.pow(mPos.x - cPos[1], 2) + math.pow(mPos.y - cPos[2], 2)))
				if dist <= 9 then
					cd = math.ceil(champs[i]:GetSpellData(SUMMONER_1).currentCd)
					if cd > 0 then
						SendChat(champs[i].charName .. "'s " .. getSpellName(champs[i]:GetSpellData(SUMMONER_1)) .. " down for " .. math.ceil(cd) .. " seconds")
					else
						PrintChat(champs[i].charName .. "'s " .. getSpellName(champs[i]:GetSpellData(SUMMONER_1)) .. " is off cooldown.")
					end
					break
				else
					pos = {posX-30, posY[i]+27}
					cPos = {pos[1] + 12, pos[2]+7}
					dist = math.ceil(math.sqrt(math.pow(mPos.x - cPos[1], 2) + math.pow(mPos.y - cPos[2], 2)))
					if dist <= 9 then
						cd = math.ceil(champs[i]:GetSpellData(SUMMONER_2).currentCd)
						if cd > 0 then
							SendChat(champs[i].charName .. "'s " .. getSpellName(champs[i]:GetSpellData(SUMMONER_2)) .. " down for " .. math.ceil(cd) .. " seconds")
						else
							PrintChat(champs[i].charName .. "'s " .. getSpellName(champs[i]:GetSpellData(SUMMONER_2)) .. " is off cooldown.")
						end
						break
					end
				end
			end
		end
	end
end

function getSpellName(spell)
	local oName = spell.name
	if oName == "summmonerclairvoyance" then return "clairvoyance" end
	if oName == "summonerbarrier" then return "barrier" end
	if oName == "summonerboost" then return "cleanse" end
	if oName == "summonerdot" then return "ignite" end
	if oName == "summonerexhaust" then return "exhaust" end
	if oName == "summonerflash" then return "flash" end
	if oName == "summonerhaste" then return "ghost" end
	if oName == "summonerheal" then return "heal" end
	if oName == "summonermana" then return "clarity" end
	if oName == "summonerrevive" then return "revive" end
	if oName == "summonerteleport" then return "teleport" end
	return "smite"	
end

function setHUD()
	if posE == false then
		posE = true
	end
	
	local mPos = WorldToScreen(mousePos)
	posX = mPos.x-35
	for i = 1, #posY do
		posY[i] = mPos.y + ((i-1) * 60) - 140
	end
end

function GanksDetection(i, champ)
	local dist = myHero:GetDistance(champ)
	if dist > 350 and dist < 3500 then
		if champ.hasMovePath and champ.path.count > 1 then
			local path = champ.path:Path(2)
			champPath = path
			if myHero:GetDistance(path) < 2500 then
				if isFacing(myHero,champ) then
					GankWarn(i, champ)
				else 
					for x, aChamp in pairs(aChamps) do
						if myHero:GetDistance(aChamp) < 5000 and isFacing(aChamp, champ) then
							GankWarn(i, champ)
							break
						end
					end
				end
			end
		end
	end
end

function GankWarn(i, champ)
	local enabled = false
	
	if i == 1 then 
		enabled = ConfigMenu.GanksDetection.A
	else
		if i == 2 then 
			enabled = ConfigMenu.GanksDetection.B 
		else
			if i == 3 then 
				enabled = ConfigMenu.GanksDetection.C 
			else
				if i == 4 then 
					enabled = ConfigMenu.GanksDetection.D 
				else 
					enabled = ConfigMenu.GanksDetection.E
				end 
			end
		end
	end
	
	if enabled == true then
		DrawText(champ.charName .. " approaching" ,18, WINDOW_W/2, WINDOW_H/2 + (i*15), 0xFFAACC00)
	end
end

function isFacing(source, target)
	local pos = VP:GetPredictedPos(source, 0.1)
	v = Vector(source.pos) + (Vector(source.visionPos)-Vector(source.pos)):normalized()*10

	if GetDistanceSqr(source, target) > GetDistanceSqr(v,target) then
		if GetDistanceSqr(pos) > 0 then
			return true
		else
			return false
		end
	else
		if GetDistanceSqr(pos) > 0 then
			return false
		else 
			return true
		end
	end
end

function OnProcessSpell(unit, spell)
	if unit.type == "obj_AI_Turret" then
		if spell.target.type == myHero.type then
			for i, tow in ipairs(towers) do
				if tow == unit and spell.target.type == myHero.type then
					tUnit[i] = unit
					tSpell[i] = spell
				else
					tUnit[i] = nil
					tSpell[i] = nil
				end
			end
		end
	else
		if unit.type == myHero.type and unit.team ~= myHero.team then
			for i, champ in pairs(champs) do
				if unit == champ and (not champ.visible) and champ.health > 0 and (not champ.dead) then
					champPos[i] = {champ.x, champ.y, champ.z}
					break
				end
			end
		end
	end
end

function drawOSInfo()
	for i = 1, heroManager.iCount, 1 do
		local champ = heroManager:getHero(i)
		if champ ~= nil and champ ~= myHero and champ.visible and champ.dead == false and GetDistance(champ) < 3500 then
			local barPos = GetHPBarPos(champ)
			local cd = {}
			cd[0] = math.ceil(champ:GetSpellData(SPELL_1).currentCd)
			cd[1] = math.ceil(champ:GetSpellData(SPELL_2).currentCd)
			cd[2] = math.ceil(champ:GetSpellData(SPELL_3).currentCd)
			cd[3] = math.ceil(champ:GetSpellData(SPELL_4).currentCd)
			cd[4] = math.ceil(champ:GetSpellData(SUMMONER_1).currentCd)
			cd[5] = math.ceil(champ:GetSpellData(SUMMONER_2).currentCd)
		   
			local spellColor = {}
			spellColor[0] = 0xBBFFD700;
			spellColor[1] = 0xBBFFD700;
			spellColor[2] = 0xBBFFD700;
			spellColor[3] = 0xBBFFD700;
			spellColor[4] = 0xBBFFD700;
			spellColor[5] = 0xBBFFD700;
								   
			if cd[0] == nil or cd[0] == 0 then cd[0] = "Q" spellColor[0] = 0xBBFFFFFF end
			if cd[1] == nil or cd[1] == 0 then cd[1] = "W" spellColor[1] = 0xBBFFFFFF end
			if cd[2] == nil or cd[2] == 0 then cd[2] = "E" spellColor[2] = 0xBBFFFFFF end
			if cd[3] == nil or cd[3] == 0 then cd[3] = "R" spellColor[3] = 0xBBFFFFFF end
			if cd[4] == nil or cd[4] == 0 then cd[4] = "S1" spellColor[4] = 0xBBFFFFFF end
			if cd[5] == nil or cd[5] == 0 then cd[5] = "S2" spellColor[5] = 0xBBFFFFFF end
		   
			if champ:GetSpellData(SPELL_1).level == 0 then spellColor[0] = 0xBBFF0000 end
			if champ:GetSpellData(SPELL_2).level == 0 then spellColor[1] = 0xBBFF0000 end
			if champ:GetSpellData(SPELL_3).level == 0 then spellColor[2] = 0xBBFF0000 end
			if champ:GetSpellData(SPELL_4).level == 0 then spellColor[3] = 0xBBFF0000 end
		   
			DrawRectangle(barPos.x-6, barPos.y-40, 134, 15, 0xBB202020)
			DrawText("[" .. cd[0] .. "]" ,12, barPos.x-5+2, barPos.y-40, spellColor[0])
			DrawText("[" .. cd[1] .. "]", 12, barPos.x+15+2, barPos.y-40, spellColor[1])
			DrawText("[" .. cd[2] .. "]", 12, barPos.x+35+2, barPos.y-40, spellColor[2])
			DrawText("[" .. cd[3] .. "]", 12, barPos.x+54+2, barPos.y-40, spellColor[3])
		   
			summPicsOS[i][0]:Draw(barPos.x+77+2+5, barPos.y-40+1, 150)
			summPicsOS[i][1]:Draw(barPos.x+101+2+5, barPos.y-40+1, 150)
		   
			if cd[4] ~= "S1" then
				DrawRectangle(barPos.x+77+2+5, barPos.y-40+1, 13, 13, 0x99FF0000)
				DrawText("" .. cd[4], 12, barPos.x+77+2+4.5, barPos.y-40+1, 0xBBFFFF33)
			end
			if cd[5] ~= "S2" then
				DrawRectangle(barPos.x+101+2+5, barPos.y-40+1, 13, 13, 0x99FF0000)
				DrawText("" .. cd[5], 12, barPos.x+101+2+4.5, barPos.y-40+1, 0xBBFFFF33)       
			end
		end
	end
end

function GetHPBarPos(enemy)
	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}--GetEnemyBarData()
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local StartHpPos = 31

	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)

	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos = Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function drawPaths()
	for i, champ in pairs(champs) do
		if champ.visible and champ.health > 0 and (not champ.dead) and champ.hasMovePath and champ.path.count > 1 then
			local path = champ.path:Path(2)
			if path ~= nil then
				champPath[i] = {path.x, path.y, path.z}
				DrawLine3D(champ.x, champ.y, champ.z, path.x, path.y, path.z, 2, 0x55FF0000)
				local picPos= WorldToScreen(D3DXVECTOR3(path.x, path.y, path.z))
				pathPics[i]:Draw(picPos.x-10, picPos.y-10, 255)
				local ms = champ.ms
				local dist = champ:GetDistance(path)
				local time = round(dist/ms, 2)
				DrawText(time .. " sec", 12, picPos.x-10, picPos.y+7, 0xFFFFFFFF)
			end
		end
	end
end

function round(num, idp)
local mult = 10^(idp or 0)
return math.floor(num * mult + 0.5) / mult
end


function OnCreateObj(obj)
	if obj ~= nil then		
		if obj.team ~= myHero.team and (obj.name:find("Ward") or obj.name:find("ward")) and not (obj.name:find("Idle") or obj.name:find("idle")) then
			if obj.name:find("Sight")  or (obj.name:find("Vision") and obj.maxMana == 180 and obj.mana > 5) then
				local destroytime = math.ceil(GetGameTimer()) + obj.mana
				while swards[destroytime] ~= nil do destroytime = destroytime+1 end
				swards[destroytime] = obj
			else
				if obj.name:find("Vision") then
					local destroytime = math.ceil(GetGameTimer())
					while vwards[destroytime] ~= nil do destroytime = destroytime+1 end
					vwards[destroytime] = obj
				end
			end
		end
	end
end


function OnDeleteObj(obj)
	if obj ~= nil and obj.team ~= myHero.team and obj.name ~= nil and (obj.name:find("Ward") or obj.name:find("ward")) and not (obj.name:find("Idle") or obj.name:find("idle")) then
		if obj.name:find("Sight") then
			for time, ward in pairs(swards) do
				if obj.name:find("Sight") or (obj.name:find("Vision") and obj.maxMana == 180) then
					if obj == ward then
						swards[time] = nil
					end
				end
			end
		else
			if obj.name:find("Vision") then
				for time, ward in pairs(vwards) do
					if obj == ward then
						vwards[time] = nil
					end
				end
			end
		end    
	end
end

function drawWards()
   
	for time, ward in pairs(swards) do
		if ward ~= nil and ward.x ~= nil and ward.y ~= nil and ward.z ~= nil then
			local remainingTime = time - math.ceil(GetGameTimer())
			local textpos= WorldToScreen(D3DXVECTOR3(ward.x, ward.y, ward.z))      
			DrawText("Sight", 16, textpos.x-15, textpos.y-15, ARGB(255,0,255,0))
			DrawText("" .. TimerText(math.ceil(remainingTime)), 16, textpos.x-10, textpos.y, ARGB(255,0,255,0))
			DrawCircle(ward.x, ward.y, ward.z, 50, ARGB(255,0,255,0))
			if ConfigMenu.drawSprites.drawMiniWard  then wardPics[0]:Draw(GetMinimapX(ward.x)-3, GetMinimapY(ward.z), 255) end
		end
	end    
   
	for time, ward in pairs(vwards) do
		if ward ~= nil and ward.x ~= nil and ward.y ~= nil and ward.z ~= nil then
			local textpos= WorldToScreen(D3DXVECTOR3(ward.x, ward.y, ward.z))      
			DrawText("Vision", 16, textpos.x-15, textpos.y-5, ARGB(255,255,105,180))
			DrawCircle(ward.x, ward.y, ward.z, 50, ARGB(255,255,105,180))
			if ConfigMenu.drawSprites.drawMiniWard  then  wardPics[1]:Draw(GetMinimapX(ward.x)-3, GetMinimapY(ward.z), 255) end
		end
	end    
end


function drawLastHit()
	enemyMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if minion ~= nil and minion.health > 0 and (not minion.dead) and myHero:GetDistance(minion) < 1000 then
			dmg = myHero:CalcDamage(minion, myHero.addDamage + myHero.damage)
			if minion.health <= dmg then
				DrawCircle(minion.x, minion.y, minion.z, 38,   RGB(0, 100, 0))
				DrawCircle(minion.x, minion.y, minion.z, 38.5, RGB(0, 100, 0))
				DrawCircle(minion.x, minion.y, minion.z, 39,   RGB(0, 100, 0))
				DrawCircle(minion.x, minion.y, minion.z, 39.5, RGB(0, 100, 0))
				DrawCircle(minion.x, minion.y, minion.z, 40,   RGB(0, 100, 0))
			end
		end
	end
end

function drawTowersRange()
	for i, tow in ipairs(towers) do
		if tow.health >  0 and myHero:GetDistance(tow) <= tRange+1000 then
			DrawCircle(tow.x, tow.y, tow.z, tRange, RGB(80, 0, 0))
		end
	end
end

function drawTowersTarget()
	for i, tow in ipairs(towers) do
		if tow.health > 0 and tUnit[i] ~= nil and tSpell[i] ~= nil and tSpell[i].target ~= nil and tSpell[i].target.type == myHero.type and (not tSpell[i].target.dead) then
			local targ = tSpell[i].target
			if tow:GetDistance(targ) <= tRange then
				DrawCircle(targ.x, targ.y, targ.z, 80, ARGB(255,25,255,255))
				local textpos= WorldToScreen(D3DXVECTOR3(tow.x, tow.y, tow.z))   
				DrawText(targ.charName, 20, textpos.x-40, textpos.y-15, ARGB(255,255,255,255))
			end
		end
	end
end

function updateMIA(i)
	if miaTimer[i] == 0 then
		miaTimer[i] = math.ceil(GetGameTimer())
	end
	miaTime[i] = math.ceil(GetGameTimer() - miaTimer[i])
	if miaTime[i] < 1 then miaTime[i] = 0 end
   
	for i, champ in pairs(champs) do
		if not champ.visible and not champ.dead then
			if champPos[i][1] == nil then champPos[i][1] = champ.x end
			if champPos[i][2] == nil then champPos[i][2] = champ.y end
			if champPos[i][3] == nil then champPos[i][3] = champ.z end
			if ConfigMenu.drawSprites.drawMiniMIA then
				champsIcons[i]:SetScale(0.4, 0.4)
				champsIcons[i]:Draw(GetMinimapX(champPos[i][1])-10, GetMinimapY(champPos[i][3])-10, 255)
			end
			if champPath[i] ~= nil and champPath[i][1] ~= nil then
				DrawLine3D(champPos[i][1], champPos[i][2], champPos[i][3], champPath[i][1], champPath[i][2], champPath[i][3], 2, 0x7700AA00)
			end
			champsIcons[i]:SetScale(0.8, 0.8)
			local picPos= WorldToScreen(D3DXVECTOR3(champPos[i][1], champPos[i][2], champPos[i][3]))
			champsIcons[i]:Draw(picPos.x-20, picPos.y-20, 255)
		end
	end
end

function DrawVisible(champ, i)
	champPos[i] = {champ.x, champ.y, champ.z}
	
	if miaTimer[i] ~= 0 then miaTimer[i] = 0 end
   
	local cd = {}
	cd[0] = math.ceil(champ:GetSpellData(SPELL_1).currentCd)
	cd[1] = math.ceil(champ:GetSpellData(SPELL_2).currentCd)
	cd[2] = math.ceil(champ:GetSpellData(SPELL_3).currentCd)
	cd[3] = math.ceil(champ:GetSpellData(SPELL_4).currentCd)
	cd[4] = math.ceil(champ:GetSpellData(SUMMONER_1).currentCd)
	cd[5] = math.ceil(champ:GetSpellData(SUMMONER_2).currentCd)
   
	-- Summoner spells
	local summAlpha = {}
	summAlpha[0] = 255
	summAlpha[1] = 255
   
	DrawRectangle(posX-32, posY[i]-5, 25, 55, 0xFF000000)
   
	if cd[4] > 0 then summAlpha[0] = 100 end
	if cd[5] > 0 then summAlpha[1] = 100 end
   
	summPics[i][0]:Draw(posX-30, posY[i]-2, summAlpha[0])
	summPics[i][1]:Draw(posX-30, posY[i]+27, summAlpha[1])
   
	if cd[4] > 0 then
		if cd[4] > 99 then
			DrawText("" .. cd[4], 14, posX-28, posY[i]+2, 0xFFFFFFFF)
		else
			if cd[4] > 9 then
				DrawText("" .. cd[4], 14, posX-26, posY[i]+2, 0xFFFFFFFF)
			else
				DrawText("" .. cd[4], 14, posX-23, posY[i]+2, 0xFFFFFFFF)
			end
		end
	end
	if cd[5] > 0 then
		if cd[5] > 99 then
			DrawText("" .. cd[5], 14, posX-28, posY[i]+31, 0xFFFFFFFF)
		else
			if cd[5] > 9 then
				DrawText("" .. cd[5], 14, posX-26, posY[i]+31, 0xFFFFFFFF)
			else
				DrawText("" .. cd[5], 14, posX-23, posY[i]+31, 0xFFFFFFFF)
			end
		end
	end
   
	-- Champion box
	local spellColor = {}
	spellColor[0] = 0xFFFFD700;
	spellColor[1] = 0xFFFFD700;
	spellColor[2] = 0xFFFFD700;
	spellColor[3] = 0xFFFFD700;
   
	DrawRectangle(posX-5, posY[i]-5, 103, 55, 0xFF000000)  
   
	if cd[0] == nil or cd[0] == 0 then cd[0] = "Q" spellColor[0] = 0xFFFFFFFF end
	if cd[1] == nil or cd[1] == 0 then cd[1] = "W" spellColor[1] = 0xFFFFFFFF end
	if cd[2] == nil or cd[2] == 0 then cd[2] = "E" spellColor[2] = 0xFFFFFFFF end
	if cd[3] == nil or cd[3] == 0 then cd[3] = "R" spellColor[3] = 0xFFFFFFFF end
   
	if champ:GetSpellData(SPELL_1).level == 0 then spellColor[0] = 0xFFFF0000 end
	if champ:GetSpellData(SPELL_2).level == 0 then spellColor[1] = 0xFFFF0000 end
	if champ:GetSpellData(SPELL_3).level == 0 then spellColor[2] = 0xFFFF0000 end
	if champ:GetSpellData(SPELL_4).level == 0 then spellColor[3] = 0xFFFF0000 end
   
	champsPics[i]:Draw(posX, posY[i], 255)
	DrawText(math.ceil(champ.health) .. " / " .. math.ceil(champ.maxHealth), 14, posX+35, posY[i], 0xFF00FF00)
	DrawText(math.ceil(champ.mana) .. " / " .. math.ceil(champ.maxMana), 14, posX+35, posY[i]+15, 0xFF00AAFF)
	DrawText("[" .. cd[0] .. "]", 14, posX, posY[i]+31, spellColor[0])
	DrawText("[" .. cd[1] .. "]", 14, posX+23, posY[i]+31, spellColor[1])
	DrawText("[" .. cd[2] .. "]", 14, posX+50, posY[i]+31, spellColor[2])
	DrawText("[" .. cd[3] .. "]", 14, posX+73, posY[i]+31, spellColor[3])
   
	if champ.dead then DrawRectangle(posX, posY[i], 30, 30, 0x55FF0000) end
end

function DrawInvisible(champ, i)
	-- Cooldowns
	local cd = {}
	cd[0] = math.ceil(champ:GetSpellData(SPELL_1).currentCd)
	cd[1] = math.ceil(champ:GetSpellData(SPELL_2).currentCd)
	cd[2] = math.ceil(champ:GetSpellData(SPELL_3).currentCd)
	cd[3] = math.ceil(champ:GetSpellData(SPELL_4).currentCd)
	cd[4] = math.ceil(champ:GetSpellData(SUMMONER_1).currentCd)
	cd[5] = math.ceil(champ:GetSpellData(SUMMONER_2).currentCd)
   
	-- Summoner spells
	local summAlpha = {}
	summAlpha[0] = 90
	summAlpha[1] = 90
	DrawRectangle(posX-32, posY[i]-5, 25, 55, 0x55000000)
   
	if cd[4] > 0 then summAlpha[0] = 20 end
	if cd[5] > 0 then summAlpha[1] = 20 end
   
	summPics[i][0]:Draw(posX-30, posY[i]-2, summAlpha[0])
	summPics[i][1]:Draw(posX-30, posY[i]+27, summAlpha[1])
   
	if cd[4] > 0 then
		if cd[4] > 99 then
			DrawText("" .. cd[4], 14, posX-28, posY[i]+2, 0x55FFFFFF)
		else
			if cd[4] > 9 then
					DrawText("" .. cd[4], 14, posX-26, posY[i]+2, 0x55FFFFFF)
			else
					DrawText("" .. cd[4], 14, posX-23, posY[i]+2, 0x55FFFFFF)
			end
		end
	end
	
	if cd[5] > 0 then
		if cd[5] > 99 then
			DrawText("" .. cd[5], 14, posX-28, posY[i]+31, 0x55FFFFFF)
		else
			if cd[5] > 9 then
				DrawText("" .. cd[5], 14, posX-26, posY[i]+31, 0x55FFFFFF)
			else
				DrawText("" .. cd[5], 14, posX-23, posY[i]+31, 0x55FFFFFF)
			end
		end
	end
   
	-- Champion box
	local spellColor = {}
	spellColor[0] = 0x55FFD700;
	spellColor[1] = 0x55FFD700;
	spellColor[2] = 0x55FFD700;
	spellColor[3] = 0x55FFD700;
		   
	DrawRectangle(posX-5, posY[i]-5, 103, 55, 0x55000000)
   
	if cd[0] == nil or cd[0] == 0 then cd[0] = "Q" spellColor[0] = 0x55FFFFFF end
	if cd[1] == nil or cd[1] == 0 then cd[1] = "W" spellColor[1] = 0x55FFFFFF end
	if cd[2] == nil or cd[2] == 0 then cd[2] = "E" spellColor[2] = 0x55FFFFFF end
	if cd[3] == nil or cd[3] == 0 then cd[3] = "R" spellColor[3] = 0x55FFFFFF end
   
	if champ:GetSpellData(SPELL_1).level == 0 then spellColor[0] = 0x55FF0000 end
	if champ:GetSpellData(SPELL_2).level == 0 then spellColor[1] = 0x55FF0000 end
	if champ:GetSpellData(SPELL_3).level == 0 then spellColor[2] = 0x55FF0000 end
	if champ:GetSpellData(SPELL_4).level == 0 then spellColor[3] = 0x55FF0000 end

	champsPics[i]:Draw(posX, posY[i], 60)
	DrawText(math.ceil(champ.health) .. " / " .. math.ceil(champ.maxHealth), 14, posX+35, posY[i], 0x5500FF00)
	DrawText(math.ceil(champ.mana) .. " / " .. math.ceil(champ.maxMana), 14, posX+35, posY[i]+15, 0x5500AAFF)
	DrawText("[" .. cd[0] .. "]", 14, posX, posY[i]+31, spellColor[0])
	DrawText("[" .. cd[1] .. "]", 14, posX+23, posY[i]+31, spellColor[1])
	DrawText("[" .. cd[2] .. "]", 14, posX+50, posY[i]+31, spellColor[2])
	DrawText("[" .. cd[3] .. "]", 14, posX+73, posY[i]+31, spellColor[3])
		   
	if champ.dead then
		DrawRectangle(posX, posY[i], 30, 30, 0x22FF0000)
	else
		local posFix = 12
		if miaTime[i] > 99 then
			posFix = posFix - 6
		else
			if miaTime[i] > 9 then
							posFix = posFix - 4
				end
		end
		DrawText(tostring(miaTime[i]), 16, posX+posFix, posY[i]+8, 0xFFFFFFFF)
	end
end

