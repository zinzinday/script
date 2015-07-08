class 'Plugin'
if myHero.charName ~= "Evelynn" then return end

---------------------------------- START UPDATE ---------------------------------------------------------------
local versionGOE = 1.361 -- current version
local SCRIPT_NAME_GOE = "aEvelynn"
---------------------------------------------------------------------------------------------------------------
local needUpdate_GOE = false
local needRun_GOE = true
local URL_GOE = "http://noobkillerpl.cuccfree.org/aEvelynn.lua" --"http://dlr5668.cuccfree.org/"..SCRIPT_NAME_GOE..".lua"
local PATH_GOE = BOL_PATH.."Scripts/SidasAutoCarryPlugins\\"..SCRIPT_NAME_GOE..".lua"
function CheckVersionGOE(data)
	local onlineVerGOE = tonumber(data)
	if type(onlineVerGOE) ~= "number" then return end
	if onlineVerGOE and onlineVerGOE > versionGOE then
		print("<font color='#00BFFF'>AUTOUPDATER: There is a new version of "..SCRIPT_NAME_GOE.." ( "..onlineVerGOE.." ). Don't F9 till done...</font>") 
		needUpdate_GOE = true  
	end
end
function UpdateScriptGOE()
	if needRun_GOE then
		needRun_GOE = false
		if _G.UseUpdater == nil or _G.UseUpdater == true then GetAsyncWebResult("noobkillerpl.cuccfree.org", "aEvelynnVer.lua", CheckVersionGOE) end
	end

	if needUpdate_GOE then
		needUpdate_GOE = false
		DownloadFile(URL_GOE, PATH_GOE, function()
                if FileExist(PATH_GOE) then
                    print("<font color='#00BFFF'>AUTOUPDATER: Script updated! Reload scripts to use new version!</font>")
                end
            end)
	end
end
AddTickCallback(UpdateScriptGOE)
---------------------------------- END UPDATE -----------------------------------------------------------------

local Target
local UltByScript = false
local Enemies = AutoCarry.Helper.EnemyTable
local iSlot = nil
local waittxt = {}
local firstload = true

function Plugin:__init()
	AutoCarry.Crosshair:SetSkillCrosshairRange(800)
	--Menu = scriptConfig("Sida's Auto Carry Plugin: aEvelynn Config", "aevelynn")
	for _, Item in pairs(AutoCarry.Items.ItemList) do
		if Item.ID == 3128 then
			Item.Enabled = false
		end
	end
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		iSlot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		iSlot = SUMMONER_2
	else 
		iSlot = nil
	end
end

function Plugin:OnTick()
	if firstload then
		local ordertxt = 1
		for i=1, heroManager.iCount do
			waittxt[i] = ordertxt
			ordertxt = ordertxt+1
		end
		firstload = false
	else
		Target = AutoCarry.Crosshair:GetTarget()
		if Menu.spamQE then
			if Target ~= nil and AutoCarry.Keys.AutoCarry then
				local CanQ = (myHero:CanUseSpell(_Q) == READY and GetDistance(Target, myHero) < 500)
				local CanE = (myHero:CanUseSpell(_E) == READY and GetDistance(Target, myHero) < 225)
				if CanQ then CastSpell(_Q) end
				if CanE then castE(Target) end
			end
		end
		if Menu.spamQ then
			if AutoCarry.Keys.LaneClear and myHero.mana/myHero.maxMana*100 >= Menu.autoMinMana then
				local CanQ = (myHero:CanUseSpell(_Q) == READY)
				if CanQ then CastSpell(_Q) end
			end
		end
		if Menu.spamE then
			if AutoCarry.Keys.LaneClear and myHero.mana/myHero.maxMana*100 >= Menu.autoMinMana then
				local JunngleTarget = AutoCarry.Jungle:GetAttackableMonster()
				if JunngleTarget ~= nil then
					local CanE = (myHero:CanUseSpell(_E) == READY and GetDistance(JunngleTarget, myHero) < 225)
					if CanE then castE(JunngleTarget) end
				end
			end
		end
		if Menu.burstTarget then
			if Target ~= nil then
				local CanQ = (myHero:CanUseSpell(_Q) == READY and GetDistance(Target, myHero) < 500)
				local CanE = (myHero:CanUseSpell(_E) == READY and GetDistance(Target, myHero) < 325)
				local CanR = (myHero:CanUseSpell(_R) == READY and GetDistance(Target, myHero) < 800)
				AutoCarry.Items:UseAll(Target)
				CastItem(3128, Target)
				if CanR then
					if VIP_USER then
						if Menu.autoUltaiming then 
							CastSpell(_R, Target.x, Target.z)
						else
							local spellPos = GetAoESpellPosition(250, Target)
							CastSpell(_R, spellPos.x, spellPos.z)
						end
					else
						local spellPos = GetAoESpellPosition(250, Target)
						CastSpell(_R, spellPos.x, spellPos.z)
						--PrintChat("NonVIPCast")
					end
				end -- Packets will target it better anyway :p
				if CanE then castE(Target) end
				if CanQ then CastSpell(_Q) end
				if useAA then if not AutoCarry.Keys.AutoCarry then myHero:Attack(Target) end end
			end
		end
		if Menu.useIGNITE and iSlot ~= nil and Target ~= nil then
			local CanIgnite = (iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY)
			if CanIgnite then
				if Target.health < getDmg("IGNITE", Target, myHero) then
					CastSpell(iSlot, Target)
				end
			end
		end
	end
end

function Plugin:OnDraw()
	if myHero ~= nil and not myHero.dead and Menu.drawQrange then DrawCircle(myHero.x, myHero.y, myHero.z, 500, 0xFF80FF00) end
	if myHero ~= nil and not myHero.dead and Menu.drawErange then DrawCircle(myHero.x, myHero.y, myHero.z, 225, 0xFF80FF00) end
	if myHero ~= nil and not myHero.dead and Menu.drawRrange and myHero:CanUseSpell(_R) == READY then DrawCircle(myHero.x, myHero.y, myHero.z, 800, 0xFF80FF00) end
	if Menu.drawRmec then -- Test MEC IT Draws where ultimate will be casted :) You can uncomment it, and it will work.
		local ClosestEnemy = nil
		local Position1 = { x=mousePos.x, y=mousePos.y, z=mousePos.z }
		for i, Enemy in pairs(Enemies) do
			if Enemy ~= nil and not Enemy.dead and Enemy.visible then
				if ClosestEnemy ~= nil then
					if GetDistance(Enemy, Position1) < GetDistance(ClosestEnemy, Position1) then
						ClosestEnemy = Enemy
					end
				else
					ClosestEnemy = Enemy
				end
			end
		end
		local UltTargetted = ClosestEnemy
		if UltTargetted ~= nil and GetDistance(UltTargetted, CastPosition) < 300 then
			UltTarget = UltTargetted
		else
			UltTarget = AutoCarry.Crosshair:GetTarget()
		end
		if UltTarget ~= nil then
			local ValidEnemies = 0
			for i, Enemy in pairs(Enemies) do
				if Enemy ~= nil and not Enemy.dead and Enemy.visible and GetDistance(Enemy, myHero) < 1050 then ValidEnemies = ValidEnemies + 1 end
			end
			if ValidEnemies > 1 then 
				local spellPos = GetAoESpellPosition(250, UltTarget)
				DrawCircle(spellPos.x, spellPos.y, spellPos.z, 250, 0xFF80FF00)
			else
				DrawCircle(UltTarget.x, UltTarget.y, UltTarget.z, 250, 0xFF80FF00)
			end
		end
	end
	if myHero ~= nil and not myHero.dead and Menu.drawText then
		for n, Enemy in pairs(Enemies) do
			local DrawTarget = Enemy
			if Enemy ~= nil and Enemy.valid and Enemy.visible and not Enemy.dead and Enemy.team ~= myHero.team then
				local TotalDMG = 0
				local CanDFG = GetInventoryItemIsCastable(3128)
				local CanQ = (myHero:CanUseSpell(_Q) == READY)
				local CanE = (myHero:CanUseSpell(_E) == READY)
				local CanR = (myHero:CanUseSpell(_R) == READY)
				local CanIgnite = (iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY)
				if CanR then TotalDMG = TotalDMG + getDmg("R", Enemy, myHero) end
				if CanE then TotalDMG = TotalDMG + getDmg("E", Enemy, myHero) end
				if CanQ then TotalDMG = TotalDMG + getDmg("Q", Enemy, myHero) end
				if CanDFG then
					TotalDMG = TotalDMG * 1.2
					TotalDMG = TotalDMG + getDmg("DFG", Enemy, myHero)
				end
				TotalDMG = TotalDMG + getDmg("AD", Enemy, myHero)
				if CanIgnite then TotalDMG = TotalDMG + getDmg("IGNITE", Enemy, myHero) end
				if getDmg("Q", Enemy, myHero)+getDmg("E", Enemy, myHero) > DrawTarget.health then
					if waittxt[n] == 1 then 
						PrintFloatText(DrawTarget, 0, "MURDER HIM")
						waittxt[n] = 10
					elseif waittxt[n] == nil then
						waittxt[n] = 10
					else
						waittxt[n] = waittxt[n]-1
					end
				elseif TotalDMG > DrawTarget.health then
					if waittxt[n] == 1 then 
						PrintFloatText(DrawTarget, 0, "Killable")
						waittxt[n] = 10
					elseif waittxt[n] == nil then
						waittxt[n] = 10
					else
						waittxt[n] = waittxt[n]-1
					end
				else
					if waittxt[n] == 1 then 
						PrintFloatText(DrawTarget, 0, "HP: "..round(DrawTarget.health-TotalDMG))
						waittxt[n] = 10
					elseif waittxt[n] == nil then
						waittxt[n] = 10
					else
						waittxt[n] = waittxt[n]-1
					end
				end
			end
		end
	end
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function castE(target)
	if target.valid then
		if VIP_USER and Menu.useExploit then
			Packet('S_CAST', {fromX = mousePos.x, fromY = mousePos.z, targetNetworkId = target.networkID, spellId = SPELL_3}):send()
		else
			CastSpell(_E, target)
		end
	end
end

function Plugin:OnSendPacket(p)
	local packet = Packet(p)
	if packet:get('name') == 'S_CAST' then
		local SpellID = packet:get('spellId')
		if SpellID == SPELL_4 then
			local CastPosition = { x = packet:get('toX'), y = packet:get('toY'), z = packet:get('toY') }
			if Menu.blockR then
				local ValidTargets = 0
				for i, Enemy in pairs(Enemies) do
					if Enemy ~= nil and not Enemy.dead and Enemy.visible and GetDistance(Enemy, CastPosition) < 250 then ValidTargets = ValidTargets + 1 end
				end
				if ValidTargets == 0 then p:Block() end
			end
			if Menu.autoUltaiming then
				if UltByScript == true then
					UltByScript = false
				elseif UltByScript == false then
					p:Block()
					UltByScript = true
					local ClosestEnemy = nil
					local Position1 = { x=CastPosition.x, y=CastPosition.y, z=CastPosition.z }
					for i, Enemy in pairs(Enemies) do
						if Enemy ~= nil and not Enemy.dead and Enemy.visible then
							if ClosestEnemy ~= nil then
								if GetDistance(Enemy, Position1) < GetDistance(ClosestEnemy, Position1) then
									ClosestEnemy = Enemy
								end
							else
								ClosestEnemy = Enemy
							end
						end
					end
					local UltTargetted = ClosestEnemy
					if UltTargetted ~= nil and GetDistance(UltTargetted, CastPosition) < 300 then
						UltTarget = UltTargetted
					else
						UltTarget = AutoCarry.Crosshair:GetTarget()
					end
					if UltTarget ~= nil then
						local ValidEnemies = 0
						for i, Enemy in pairs(Enemies) do
							if Enemy ~= nil and not Enemy.dead and Enemy.visible and GetDistance(Enemy, myHero) < 1050 then ValidEnemies = ValidEnemies + 1 end
						end
						if ValidEnemies > 1 then 
							local spellPos = GetAoESpellPosition(250, UltTarget)
							CastSpell(_R, spellPos.x, spellPos.z)
						else
							CastSpell(_R, UltTarget.x, UltTarget.z)
						end
					end
				end
			end
		end
	end
end

Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "aEvelynn v"..versionGOE)
Menu:addParam("Information1", "  aEvelynn v"..versionGOE.." by Anonymous", SCRIPT_PARAM_INFO, "")
Menu:addParam("Information2", "== Helper-Settings: ==", SCRIPT_PARAM_INFO, "")
Menu:addParam("burstTarget", "Burst Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
Menu:addParam("useAA","Autoattack in Burst Combo", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("useIGNITE","Use Ignite on killable enemies", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("spamQE","Use QE in AutoCarry mode", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("spamQ","Use Q in LaneClear mode", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("spamE","Use E in LaneClear mode", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("autoMinMana","Minimum % mana (LaneClear)", SCRIPT_PARAM_SLICE, 35, 0, 100, 0)
--Menu:addParam("spamQblueonly","Only with bluebuff", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("Information4", "VIP only functions:", SCRIPT_PARAM_INFO, "")
Menu:addParam("useExploit","Use spell casting exploits", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("blockR","Block wrong ult", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("autoUltaiming","Automaticly aim with ult", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("Information3", "== Drawer-Settings: ==", SCRIPT_PARAM_INFO, "")
Menu:addParam("drawQrange","Draw Q range", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("drawErange","Draw E range", SCRIPT_PARAM_ONOFF, false) -- useless imo, too much circles.
Menu:addParam("drawRrange","Draw R range", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("drawRmec","Draw R prediction", SCRIPT_PARAM_ONOFF, false) -- This is only to let you see how it casts ultimate, imo should be disable during game.
Menu:addParam("drawText","Draw text on enemies", SCRIPT_PARAM_ONOFF, true) -- Killable, Murder him, etc.

--[[ 
	AoE_Skillshot_Position 2.0 by monogato
	
	GetAoESpellPosition(radius, main_target, [delay]) returns best position in order to catch as many enemies as possible with your AoE skillshot, making sure you get the main target.
	Note: You can optionally add delay in ms for prediction (VIP if avaliable, normal else).
]]

function GetCenter(points)
	local sum_x = 0
	local sum_z = 0
	
	for i = 1, #points do
		sum_x = sum_x + points[i].x
		sum_z = sum_z + points[i].z
	end
	
	local center = {x = sum_x / #points, y = 0, z = sum_z / #points}
	
	return center
end

function ContainsThemAll(circle, points)
	local radius_sqr = circle.radius*circle.radius
	local contains_them_all = true
	local i = 1
	
	while contains_them_all and i <= #points do
		contains_them_all = GetDistanceSqr(points[i], circle.center) <= radius_sqr
		i = i + 1
	end
	
	return contains_them_all
end

-- The first element (which is gonna be main_target) is untouchable.
function FarthestFromPositionIndex(points, position)
	local index = 2
	local actual_dist_sqr
	local max_dist_sqr = GetDistanceSqr(points[index], position)
	
	for i = 3, #points do
		actual_dist_sqr = GetDistanceSqr(points[i], position)
		if actual_dist_sqr > max_dist_sqr then
			index = i
			max_dist_sqr = actual_dist_sqr
		end
	end
	
	return index
end

function RemoveWorst(targets, position)
	local worst_target = FarthestFromPositionIndex(targets, position)
	
	table.remove(targets, worst_target)
	
	return targets
end

function GetInitialTargets(radius, main_target)
	local targets = {main_target}
	local diameter_sqr = 4 * radius * radius
	
	for i=1, heroManager.iCount do
		target = heroManager:GetHero(i)
		if target.networkID ~= main_target.networkID and ValidTarget(target) and GetDistanceSqr(main_target, target) < diameter_sqr then table.insert(targets, target) end
	end
	
	return targets
end

function GetPredictedInitialTargets(radius, main_target, delay)
	if VIP_USER and not vip_target_predictor then vip_target_predictor = TargetPredictionVIP(nil, nil, delay/1000) end
	local predicted_main_target = VIP_USER and vip_target_predictor:GetPrediction(main_target) or GetPredictionPos(main_target, delay)
	local predicted_targets = {predicted_main_target}
	local diameter_sqr = 4 * radius * radius
	
	for i=1, heroManager.iCount do
		target = heroManager:GetHero(i)
		if ValidTarget(target) then
			predicted_target = VIP_USER and vip_target_predictor:GetPrediction(target) or GetPredictionPos(target, delay)
			if target.networkID ~= main_target.networkID and GetDistanceSqr(predicted_main_target, predicted_target) < diameter_sqr then table.insert(predicted_targets, predicted_target) end
		end
	end
	
	return predicted_targets
end

-- I donÃ?Â´t need range since main_target is gonna be close enough. You can add it if you do.
function GetAoESpellPosition(radius, main_target, delay)
	local targets = delay and GetPredictedInitialTargets(radius, main_target, delay) or GetInitialTargets(radius, main_target)
	local position = GetCenter(targets)
	local best_pos_found = true
	local circle = Circle(position, radius)
	circle.center = position
	
	if #targets > 2 then best_pos_found = ContainsThemAll(circle, targets) end
	
	while not best_pos_found do
		targets = RemoveWorst(targets, position)
		position = GetCenter(targets)
		circle.center = position
		best_pos_found = ContainsThemAll(circle, targets)
	end
	
	return position
end