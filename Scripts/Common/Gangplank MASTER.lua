--[[ GP script v0.1 kokosik1221]]--

if myHero.charName ~= "Gangplank" then return end

function Menu()
	Menuconf = AutoCarry.PluginMenu
	Menuconf:addSubMenu("Combo Settings", "comboConfig")
	Menuconf.comboConfig:addParam("USEE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
	Menuconf.comboConfig:addParam("USEQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
	Menuconf.comboConfig:addParam("HARRASQ", "Harras Enemy Q (Key: T)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("T"))
	Menuconf.comboConfig:permaShow("HARRASQ")
	
	Menuconf:addSubMenu("KS Settings" , "ksConfig")
	Menuconf.ksConfig:addParam("IGN", "KS Ignite (Key: U)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("U"))
	Menuconf.ksConfig:addParam("KSULT", "KS Ultimate (Key: I)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("I"))
	Menuconf.ksConfig:addParam("ULTHITS", "Ult hit times:", SCRIPT_PARAM_SLICE, 2, 1, 6, 0)
	Menuconf.ksConfig:addParam("KSQ", "KS Q (Key: O)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("O"))
	Menuconf.ksConfig:permaShow("IGN")
	Menuconf.ksConfig:permaShow("KSULT")
	Menuconf.ksConfig:permaShow("KSQ")
	
	Menuconf:addSubMenu("Spell & Farm" , "farmConfig")
	Menuconf.farmConfig:addParam("FARMQJUNGLE", "Farm With Q In Jungle (Key: G)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("G"))
	Menuconf.farmConfig:addParam("FARMQ", "Farm With Q (Key: J)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("J"))
	Menuconf.farmConfig:addParam("FARMAA", "Farm With AA (Key: K)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("K"))
	Menuconf.farmConfig:addParam("CC", "Anty CC (Key: H)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("H"))
	Menuconf.farmConfig:addParam("HEAL", "Auto W (Key: L)", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("L"))
	Menuconf.farmConfig:addParam("MINHPTOW", "Min % HP To Heal", SCRIPT_PARAM_SLICE, 60, 0, 100, 2)
	Menuconf.farmConfig:addParam("MINMPTOW", "Min % MP To Heal", SCRIPT_PARAM_SLICE, 70, 0, 100, 2)	
	Menuconf.farmConfig:permaShow("FARMQJUNGLE")
	Menuconf.farmConfig:permaShow("FARMQ")
	Menuconf.farmConfig:permaShow("FARMAA")
	Menuconf.farmConfig:permaShow("CC")
	Menuconf.farmConfig:permaShow("HEAL")
	
	Menuconf:addSubMenu("Drawing Settings", "drawConfig")
	Menuconf.drawConfig:addParam("DQR", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	Menuconf.drawConfig:addParam("DER", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnLoad()
	Menu()
	IgniteKey = nil;
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		IgniteKey = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		IgniteKey = SUMMONER_2
	else
		IgniteKey = nil
	end
	ultDmg = 0
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget(true)
	Qrdy = (myHero:CanUseSpell(_Q) == READY)
	Wrdy = (myHero:CanUseSpell(_W) == READY)
	Erdy = (myHero:CanUseSpell(_E) == READY)
	Rrdy = (myHero:CanUseSpell(_R) == READY)
	
	--KSULT--
	if Menuconf.ksConfig.KSULT then
		players = heroManager.iCount
		for i = 1, players, 1 do
            target = heroManager:getHero(i)
			ultDmg = getDmg("R", myHero, target) * Menuconf.ksConfig.ULTHITS + (myHero.ap * 0.2)
            if target ~= nil and target.team ~= player.team and target.visible and not target.dead then
                if Rrdy and ultDmg > target.health then
                    CastSpell(_R, target.x, target.z)
                end
            end
        end
	end
	--KSQ--
	if Menuconf.ksConfig.KSQ and Qrdy then
		if ValidTarget(Target) and Target.health < getDmg("Q", myHero, Target) then
			CastSpell(_Q, Target)
		end
	end
	--KSIGNITE--
	if Menuconf.ksConfig.KSIGNITE and Target ~= nil and IgniteKey ~= nil then
		if Target.health < getDmg("IGNITE", myHero, Target) then
			CastSpell(IgniteKey, Target)
		end
	end
	--COMBO--
	if AutoCarry.MainMenu.AutoCarry and Target ~= nil then
		if Qrdy and Menuconf.comboConfig.USEQ and ValidTarget(Target, 625) then
			CastSpell(_Q, Target.x, Target.z)
		end
		if Erdy and Menuconf.comboConfig.USEE then
			CastSpell(_E)
		end
	end
	--HEAL--
	if Menuconf.farmConfig.HEAL and not Recall then
		if ((myHero.mana/myHero.maxMana)*100) > Menuconf.farmConfig.MINMPTOW and  ((myHero.health/myHero.maxHealth)*100) < Menuconf.farmConfig.MINHPTOW then
			CastSpell(_W)
		end
	end
	--HARRASQ--
	if Menuconf.comboConfig.HARRASQ and ValidTarget(Target) and Qrdy then
        CastSpell(_Q, Target)
    end
	--FARMWITHQ--
	if Menuconf.farmConfig.FARMQ and Qrdy then
        for index, minion in pairs(minionManager(MINION_ENEMY, 625, player, MINION_SORT_HEALTH_ASC).objects) do
            local qDmg = getDmg("Q",minion,  GetMyHero()) + getDmg("AD",minion,  GetMyHero())
            local MinionHealth_ = minion.health
            if qDmg >= MinionHealth_ then
                    CastSpell(_Q, minion)
            end
        end
    end
	--FARMWITHQJUNGLE--
	if Menuconf.farmConfig.FARMQJUNGLE and Qrdy then
        for index, minion in pairs(minionManager(MINION_JUNGLE, 625, player, MINION_SORT_HEALTH_ASC).objects) do
            local qDmg = getDmg("Q",minion,  GetMyHero()) + getDmg("AD",minion,  GetMyHero())
            local MinionHealth_ = minion.health
            if qDmg >= MinionHealth_ then
                    CastSpell(_Q, minion)
            end
        end
    end
	--FARMWITHAA--
	if Menuconf.farmConfig.FARMAA then
        for index, minion in pairs(minionManager(MINION_ENEMY, myHero.range+75, player, MINION_SORT_HEALTH_ASC).objects) do
		local aDmg = getDmg("AD", minion, myHero)
			if minion.health <= aDmg  and GetDistance(minion) <= (myHero.range+75) then
				myHero:Attack(minion)
			end
		end
    end
	--ANTYCC--
	if Menuconf.farmConfig.CC and Wrdy then
		myPlayer = GetMyHero()
		if myPlayer.canMove == false then
			CastSpell(_W)
		end
		if myPlayer.isTaunted == true then
			CastSpell(_W)
		end
		if myPlayer.isFleeing == true then
			CastSpell(_W)
		end
	end
	--DRAWING--
	function PluginOnDraw()
		if Menuconf.drawConfig.DQR and Qrdy then			
			DrawCircle(myHero.x, myHero.y, myHero.z, 625, ARGB(255,0,0,255))
		end
		if Menuconf.drawConfig.DER and Erdy then			
			DrawCircle(myHero.x, myHero.y, myHero.z, 1300, ARGB(255,255,0,0))
		end
	end
	
	function OnCreateObj(object)
		if object.name:find("TeleportHome") then
			Recall = true
		end
	end
 
	function OnDeleteObj(object)
		if object.name:find("TeleportHome") or (Recall == nil and object.name == Recall.name) then
			Recall = false
		end
	end
	
end

--UPDATEURL=
--HASH=829C93896EB655B232B2A97C1ECFF98B
