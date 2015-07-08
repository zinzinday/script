	
		local version = '3.023'
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--chaos version-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		class 'VPrediction' --{
		function VPrediction:__init()
			self.version = tonumber(version)
			self.showdevmode = false
			self.projectilespeeds = {['Velkoz']= 2000,['TeemoMushroom'] = math.huge,['TestCubeRender'] = math.huge ,['Xerath'] = 2000.0000 ,['Kassadin'] = math.huge ,['Rengar'] = math.huge ,['Thresh'] = 1000.0000 ,['Ziggs'] = 1500.0000 ,['ZyraPassive'] = 1500.0000 ,['ZyraThornPlant'] = 1500.0000 ,['KogMaw'] = 1800.0000 ,['HeimerTBlue'] = 1599.3999 ,['EliseSpider'] = 500.0000 ,['Skarner'] = 500.0000 ,['ChaosNexus'] = 500.0000 ,['Katarina'] = 467.0000 ,['Riven'] = 347.79999 ,['SightWard'] = 347.79999 ,['HeimerTYellow'] = 1599.3999 ,['Ashe'] = 2000.0000 ,['VisionWard'] = 2000.0000 ,['TT_NGolem2'] = math.huge ,['ThreshLantern'] = math.huge ,['TT_Spiderboss'] = math.huge ,['OrderNexus'] = math.huge ,['Soraka'] = 1000.0000 ,['Jinx'] = 2750.0000 ,['TestCubeRenderwCollision'] = 2750.0000 ,['Red_Minion_Wizard'] = 650.0000 ,['JarvanIV'] = 20.0000 ,['Blue_Minion_Wizard'] = 650.0000 ,['TT_ChaosTurret2'] = 1200.0000 ,['TT_ChaosTurret3'] = 1200.0000 ,['TT_ChaosTurret1'] = 1200.0000 ,['ChaosTurretGiant'] = 1200.0000 ,['Dragon'] = 1200.0000 ,['LuluSnowman'] = 1200.0000 ,['Worm'] = 1200.0000 ,['ChaosTurretWorm'] = 1200.0000 ,['TT_ChaosInhibitor'] = 1200.0000 ,['ChaosTurretNormal'] = 1200.0000 ,['AncientGolem'] = 500.0000 ,['ZyraGraspingPlant'] = 500.0000 ,['HA_AP_OrderTurret3'] = 1200.0000 ,['HA_AP_OrderTurret2'] = 1200.0000 ,['Tryndamere'] = 347.79999 ,['OrderTurretNormal2'] = 1200.0000 ,['Singed'] = 700.0000 ,['OrderInhibitor'] = 700.0000 ,['Diana'] = 347.79999 ,['HA_FB_HealthRelic'] = 347.79999 ,['TT_OrderInhibitor'] = 347.79999 ,['GreatWraith'] = 750.0000 ,['Yasuo'] = 347.79999 ,['OrderTurretDragon'] = 1200.0000 ,['OrderTurretNormal'] = 1200.0000 ,['LizardElder'] = 500.0000 ,['HA_AP_ChaosTurret'] = 1200.0000 ,['Ahri'] = 1750.0000 ,['Lulu'] = 1450.0000 ,['ChaosInhibitor'] = 1450.0000 ,['HA_AP_ChaosTurret3'] = 1200.0000 ,['HA_AP_ChaosTurret2'] = 1200.0000 ,['ChaosTurretWorm2'] = 1200.0000 ,['TT_OrderTurret1'] = 1200.0000 ,['TT_OrderTurret2'] = 1200.0000 ,['TT_OrderTurret3'] = 1200.0000 ,['LuluFaerie'] = 1200.0000 ,['HA_AP_OrderTurret'] = 1200.0000 ,['OrderTurretAngel'] = 1200.0000 ,['YellowTrinketUpgrade'] = 1200.0000 ,['MasterYi'] = math.huge ,['Lissandra'] = 2000.0000 ,['ARAMOrderTurretNexus'] = 1200.0000 ,['Draven'] = 1700.0000 ,['FiddleSticks'] = 1750.0000 ,['SmallGolem'] = math.huge ,['ARAMOrderTurretFront'] = 1200.0000 ,['ChaosTurretTutorial'] = 1200.0000 ,['NasusUlt'] = 1200.0000 ,['Maokai'] = math.huge ,['Wraith'] = 750.0000 ,['Wolf'] = math.huge ,['Sivir'] = 1750.0000 ,['Corki'] = 2000.0000 ,['Janna'] = 1200.0000 ,['Nasus'] = math.huge ,['Golem'] = math.huge ,['ARAMChaosTurretFront'] = 1200.0000 ,['ARAMOrderTurretInhib'] = 1200.0000 ,['LeeSin'] = math.huge ,['HA_AP_ChaosTurretTutorial'] = 1200.0000 ,['GiantWolf'] = math.huge ,['HA_AP_OrderTurretTutorial'] = 1200.0000 ,['YoungLizard'] = 750.0000 ,['Jax'] = 400.0000 ,['LesserWraith'] = math.huge ,['Blitzcrank'] = math.huge ,['ARAMChaosTurretInhib'] = 1200.0000 ,['Shen'] = 400.0000 ,['Nocturne'] = math.huge ,['Sona'] = 1500.0000 ,['ARAMChaosTurretNexus'] = 1200.0000 ,['YellowTrinket'] = 1200.0000 ,['OrderTurretTutorial'] = 1200.0000 ,['Caitlyn'] = 2500.0000 ,['Trundle'] = 347.79999 ,['Malphite'] = 1000.0000 ,['Mordekaiser'] = math.huge ,['ZyraSeed'] = math.huge ,['Vi'] = 1000.0000 ,['Tutorial_Red_Minion_Wizard'] = 650.0000 ,['Renekton'] = math.huge ,['Anivia'] = 1400.0000 ,['Fizz'] = math.huge ,['Heimerdinger'] = 1500.0000 ,['Evelynn'] = 467.0000 ,['Rumble'] = 347.79999 ,['Leblanc'] = 1700.0000 ,['Darius'] = math.huge ,['OlafAxe'] = math.huge ,['Viktor'] = 2300.0000 ,['XinZhao'] = 20.0000 ,['Orianna'] = 1450.0000 ,['Vladimir'] = 1400.0000 ,['Nidalee'] = 1750.0000 ,['Tutorial_Red_Minion_Basic'] = math.huge ,['ZedShadow'] = 467.0000 ,['Syndra'] = 1800.0000 ,['Zac'] = 1000.0000 ,['Olaf'] = 347.79999 ,['Veigar'] = 1100.0000 ,['Twitch'] = 2500.0000 ,['Alistar'] = math.huge ,['Akali'] = 467.0000 ,['Urgot'] = 1300.0000 ,['Leona'] = 347.79999 ,['Talon'] = math.huge ,['Karma'] = 1500.0000 ,['Jayce'] = 347.79999 ,['Galio'] = 1000.0000 ,['Shaco'] = math.huge ,['Taric'] = math.huge ,['TwistedFate'] = 1500.0000 ,['Varus'] = 2000.0000 ,['Garen'] = 347.79999 ,['Swain'] = 1600.0000 ,['Vayne'] = 2000.0000 ,['Fiora'] = 467.0000 ,['Quinn'] = 2000.0000 ,['Kayle'] = math.huge ,['Blue_Minion_Basic'] = math.huge ,['Brand'] = 2000.0000 ,['Teemo'] = 1300.0000 ,['Amumu'] = 500.0000 ,['Annie'] = 1200.0000 ,['Odin_Blue_Minion_caster'] = 1200.0000 ,['Elise'] = 1600.0000 ,['Nami'] = 1500.0000 ,['Poppy'] = 500.0000 ,['AniviaEgg'] = 500.0000 ,['Tristana'] = 2250.0000 ,['Graves'] = 3000.0000 ,['Morgana'] = 1600.0000 ,['Gragas'] = math.huge ,['MissFortune'] = 2000.0000 ,['Warwick'] = math.huge ,['Cassiopeia'] = 1200.0000 ,['Tutorial_Blue_Minion_Wizard'] = 650.0000 ,['DrMundo'] = math.huge ,['Volibear'] = 467.0000 ,['Irelia'] = 467.0000 ,['Odin_Red_Minion_Caster'] = 650.0000 ,['Lucian'] = 2800.0000 ,['Yorick'] = math.huge ,['RammusPB'] = math.huge ,['Red_Minion_Basic'] = math.huge ,['Udyr'] = 467.0000 ,['MonkeyKing'] = 20.0000 ,['Tutorial_Blue_Minion_Basic'] = math.huge ,['Kennen'] = 1600.0000 ,['Nunu'] = 500.0000 ,['Ryze'] = 2400.0000 ,['Zed'] = 467.0000 ,['Nautilus'] = 1000.0000 ,['Gangplank'] = 1000.0000 ,['Lux'] = 1600.0000 ,['Sejuani'] = 500.0000 ,['Ezreal'] = 2000.0000 ,['OdinNeutralGuardian'] = 1800.0000 ,['Khazix'] = 500.0000 ,['Sion'] = math.huge ,['Aatrox'] = 347.79999 ,['Hecarim'] = 500.0000 ,['Pantheon'] = 20.0000 ,['Shyvana'] = 467.0000 ,['Zyra'] = 1700.0000 ,['Karthus'] = 1200.0000 ,['Rammus'] = math.huge ,['Zilean'] = 1200.0000 ,['Chogath'] = 500.0000 ,['Malzahar'] = 2000.0000 ,['YorickRavenousGhoul'] = 347.79999 ,['YorickSpectralGhoul'] = 347.79999 ,['JinxMine'] = 347.79999 ,['YorickDecayedGhoul'] = 347.79999 ,['XerathArcaneBarrageLauncher'] = 347.79999 ,['Odin_SOG_Order_Crystal'] = 347.79999 ,['TestCube'] = 347.79999 ,['ShyvanaDragon'] = math.huge ,['FizzBait'] = math.huge ,['Blue_Minion_MechMelee'] = math.huge ,['OdinQuestBuff'] = math.huge ,['TT_Buffplat_L'] = math.huge ,['TT_Buffplat_R'] = math.huge ,['KogMawDead'] = math.huge ,['TempMovableChar'] = math.huge ,['Lizard'] = 500.0000 ,['GolemOdin'] = math.huge ,['OdinOpeningBarrier'] = math.huge ,['TT_ChaosTurret4'] = 500.0000 ,['TT_Flytrap_A'] = 500.0000 ,['TT_NWolf'] = math.huge ,['OdinShieldRelic'] = math.huge ,['LuluSquill'] = math.huge ,['redDragon'] = math.huge ,['MonkeyKingClone'] = math.huge ,['Odin_skeleton'] = math.huge ,['OdinChaosTurretShrine'] = 500.0000 ,['Cassiopeia_Death'] = 500.0000 ,['OdinCenterRelic'] = 500.0000 ,['OdinRedSuperminion'] = math.huge ,['JarvanIVWall'] = math.huge ,['ARAMOrderNexus'] = math.huge ,['Red_Minion_MechCannon'] = 1200.0000 ,['OdinBlueSuperminion'] = math.huge ,['SyndraOrbs'] = math.huge ,['LuluKitty'] = math.huge ,['SwainNoBird'] = math.huge ,['LuluLadybug'] = math.huge ,['CaitlynTrap'] = math.huge ,['TT_Shroom_A'] = math.huge ,['ARAMChaosTurretShrine'] = 500.0000 ,['Odin_Windmill_Propellers'] = 500.0000 ,['TT_NWolf2'] = math.huge ,['OdinMinionGraveyardPortal'] = math.huge ,['SwainBeam'] = math.huge ,['Summoner_Rider_Order'] = math.huge ,['TT_Relic'] = math.huge ,['odin_lifts_crystal'] = math.huge ,['OdinOrderTurretShrine'] = 500.0000 ,['SpellBook1'] = 500.0000 ,['Blue_Minion_MechCannon'] = 1200.0000 ,['TT_ChaosInhibitor_D'] = 1200.0000 ,['Odin_SoG_Chaos'] = 1200.0000 ,['TrundleWall'] = 1200.0000 ,['HA_AP_HealthRelic'] = 1200.0000 ,['OrderTurretShrine'] = 500.0000 ,['OriannaBall'] = 500.0000 ,['ChaosTurretShrine'] = 500.0000 ,['LuluCupcake'] = 500.0000 ,['HA_AP_ChaosTurretShrine'] = 500.0000 ,['TT_NWraith2'] = 750.0000 ,['TT_Tree_A'] = 750.0000 ,['SummonerBeacon'] = 750.0000 ,['Odin_Drill'] = 750.0000 ,['TT_NGolem'] = math.huge ,['AramSpeedShrine'] = math.huge ,['OriannaNoBall'] = math.huge ,['Odin_Minecart'] = math.huge ,['Summoner_Rider_Chaos'] = math.huge ,['OdinSpeedShrine'] = math.huge ,['TT_SpeedShrine'] = math.huge ,['odin_lifts_buckets'] = math.huge ,['OdinRockSaw'] = math.huge ,['OdinMinionSpawnPortal'] = math.huge ,['SyndraSphere'] = math.huge ,['Red_Minion_MechMelee'] = math.huge ,['SwainRaven'] = math.huge ,['crystal_platform'] = math.huge ,['MaokaiSproutling'] = math.huge ,['Urf'] = math.huge ,['TestCubeRender10Vision'] = math.huge ,['MalzaharVoidling'] = 500.0000 ,['GhostWard'] = 500.0000 ,['MonkeyKingFlying'] = 500.0000 ,['LuluPig'] = 500.0000 ,['AniviaIceBlock'] = 500.0000 ,['TT_OrderInhibitor_D'] = 500.0000 ,['Odin_SoG_Order'] = 500.0000 ,['RammusDBC'] = 500.0000 ,['FizzShark'] = 500.0000 ,['LuluDragon'] = 500.0000 ,['OdinTestCubeRender'] = 500.0000 ,['TT_Tree1'] = 500.0000 ,['ARAMOrderTurretShrine'] = 500.0000 ,['Odin_Windmill_Gears'] = 500.0000 ,['ARAMChaosNexus'] = 500.0000 ,['TT_NWraith'] = 750.0000 ,['TT_OrderTurret4'] = 500.0000 ,['Odin_SOG_Chaos_Crystal'] = 500.0000 ,['OdinQuestIndicator'] = 500.0000 ,['JarvanIVStandard'] = 500.0000 ,['TT_DummyPusher'] = 500.0000 ,['OdinClaw'] = 500.0000 ,['EliseSpiderling'] = 2000.0000 ,['QuinnValor'] = math.huge ,['UdyrTigerUlt'] = math.huge ,['UdyrTurtleUlt'] = math.huge ,['UdyrUlt'] = math.huge ,['UdyrPhoenixUlt'] = math.huge ,['ShacoBox'] = 1500.0000 ,['HA_AP_Poro'] = 1500.0000 ,['AnnieTibbers'] = math.huge ,['UdyrPhoenix'] = math.huge ,['UdyrTurtle'] = math.huge ,['UdyrTiger'] = math.huge ,['HA_AP_OrderShrineTurret'] = 500.0000 ,['HA_AP_Chains_Long'] = 500.0000 ,['HA_AP_BridgeLaneStatue'] = 500.0000 ,['HA_AP_ChaosTurretRubble'] = 500.0000 ,['HA_AP_PoroSpawner'] = 500.0000 ,['HA_AP_Cutaway'] = 500.0000 ,['HA_AP_Chains'] = 500.0000 ,['ChaosInhibitor_D'] = 500.0000 ,['ZacRebirthBloblet'] = 500.0000 ,['OrderInhibitor_D'] = 500.0000 ,['Nidalee_Spear'] = 500.0000 ,['Nidalee_Cougar'] = 500.0000 ,['TT_Buffplat_Chain'] = 500.0000 ,['WriggleLantern'] = 500.0000 ,['TwistedLizardElder'] = 500.0000 ,['RabidWolf'] = math.huge ,['HeimerTGreen'] = 1599.3999 ,['HeimerTRed'] = 1599.3999 ,['ViktorFF'] = 1599.3999 ,['TwistedGolem'] = math.huge ,['TwistedSmallWolf'] = math.huge ,['TwistedGiantWolf'] = math.huge ,['TwistedTinyWraith'] = 750.0000 ,['TwistedBlueWraith'] = 750.0000 ,['TwistedYoungLizard'] = 750.0000 ,['Red_Minion_Melee'] = math.huge ,['Blue_Minion_Melee'] = math.huge ,['Blue_Minion_Healer'] = 1000.0000 ,['Ghast'] = 750.0000 ,['blueDragon'] = 800.0000 ,['Red_Minion_MechRange'] = 3000.0000,}
			self.ActiveAttacks = {}
			self.MinionsAttacks = {}
			
			if not _G.VPredictionMenu then
				_G.VPredictionMenu = scriptConfig('VPrediction+', 'VPrediction3')
					-- Collision menu
					_G.VPredictionMenu:addSubMenu('Collision', 'Collision')
						_G.VPredictionMenu.Collision:addParam('Buffer', 'Collision buffer', SCRIPT_PARAM_SLICE, 20, 0, 100)
						_G.VPredictionMenu.Collision:addParam('Minions', 'Normal minions', SCRIPT_PARAM_ONOFF, true)
						_G.VPredictionMenu.Collision:addParam('Mobs', 'Jungle minions', SCRIPT_PARAM_ONOFF, true)
						_G.VPredictionMenu.Collision:addParam('Others', 'Others', SCRIPT_PARAM_ONOFF, true)

						_G.VPredictionMenu.Collision:addParam('UnitPos', 'Check collision at the unit pos', SCRIPT_PARAM_ONOFF, true)
						_G.VPredictionMenu.Collision:addParam('CastPos', 'Check collision at the cast pos', SCRIPT_PARAM_ONOFF, true)
						_G.VPredictionMenu.Collision:addParam('PredictPos', 'Check collision at the predicted pos', SCRIPT_PARAM_ONOFF, false)
					
					if self.showdevmode then
						_G.VPredictionMenu:addSubMenu('Developers', 'Developers')
							_G.VPredictionMenu.Developers:addParam('Debug', 'Enable debug', SCRIPT_PARAM_ONOFF, false)
							_G.VPredictionMenu.Developers:addParam('SC', 'Show collision', SCRIPT_PARAM_ONOFF, false)
					end
					
					_G.VPredictionMenu:addParam('Version', 'Version', SCRIPT_PARAM_INFO, tostring(self.version))
			end

			self.WaypointsTime = 2
			
			self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
			self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_HEALTH_ASC)
			self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)

			self.TargetsWaypoints = {}
			self.TargetsImmobile = {}
			self.TargetsDashing = {}
			self.TargetsSlowed = {}
			self.DontShoot = {}
			self.DontShoot2 = {}
			self.DontShootUntilNewWaypoints = {}
			self.AutoAttacking = {}
			self.CastingSpells = {}
			
			AddNewPathCallback(function(unit, startPos, endPos, isDash ,dashSpeed,dashGravity, dashDistance) self:OnNewPath(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance) end)
			AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
			AddTickCallback(function() self:OnTick() end)
			AddDrawCallback(function() self:OnDraw() end)
			AddProcessSpellCallback(function(unit, spell) self:CollisionProcessSpell(unit, spell) end)
			AddApplyBuffCallback(function(p1, p2, p3) self:OnApplyBuff(p1, p2, p3) end)
			self.BlackList = 
			{
				{name = 'aatroxq', duration = 0.75}, -- 4 Dashes, OnDash fails
			}
			
			-- Spells that will cause OnDash to fire, dont shoot and wait to OnDash
			self.dashAboutToHappend =
			{
				{name = 'ahritumble', duration = 0.25},--ahri's r
				{name = 'akalishadowdance', duration = 0.25},--akali r
				{name = 'headbutt', duration = 0.25},--alistar w
				{name = 'caitlynentrapment', duration = 0.25},--caitlyn e
				{name = 'carpetbomb', duration = 0.25},--corki w
				{name = 'dianateleport', duration = 0.25},--diana r
				{name = 'fizzpiercingstrike', duration = 0.25},--fizz q
				{name = 'fizzjump', duration = 0.25},--fizz e
				{name = 'gragasbodyslam', duration = 0.25},--gragas e
				{name = 'gravesmove', duration = 0.25},--graves e
				{name = 'ireliagatotsu', duration = 0.25},--irelia q
				{name = 'jarvanivdragonstrike', duration = 0.25},--jarvan q
				{name = 'jaxleapstrike', duration = 0.25},--jax q
				{name = 'khazixe', duration = 0.25},--khazix e and e evolved
				{name = 'leblancslide', duration = 0.25},--leblanc w
				{name = 'leblancslidem', duration = 0.25},--leblanc w (r)
				{name = 'blindmonkqtwo', duration = 0.25},--lee sin q 
				{name = 'blindmonkwone', duration = 0.25},--lee sin w
				{name = 'luciane', duration = 0.25},--lucian e
				{name = 'maokaiunstablegrowth', duration = 0.25},--maokai w
				{name = 'nocturneparanoia2', duration = 0.25},--nocturne r
				{name = 'pantheon_leapbash', duration = 0.25},--pantheon e?
				{name = 'renektonsliceanddice', duration = 0.25},--renekton e
				{name = 'riventricleave', duration = 0.25},--riven q
				{name = 'rivenfeint', duration = 0.25},--riven e
				{name = 'sejuaniarcticassault', duration = 0.25},--sejuani q
				{name = 'shenshadowdash', duration = 0.25},--shen e
				{name = 'shyvanatransformcast', duration = 0.25},--shyvana r
				{name = 'rocketjump', duration = 0.25},--tristana w
				{name = 'slashcast', duration = 0.25},--tryndamere e
				{name = 'vaynetumble', duration = 0.25},--vayne q
				{name = 'viq', duration = 0.25},--vi q
				{name = 'monkeykingnimbus', duration = 0.25},--wukong q
				{name = 'xenzhaosweep', duration = 0.25},--xin xhao q
				{name = 'yasuodashwrapper', duration = 0.25},--yasuo e

			}
			self.spells = {
				{name = 'katarinar', duration = 1}, --Katarinas R
				{name = 'drain', duration = 1}, --Fiddle W
				{name = 'crowstorm', duration = 1}, --Fiddle R
				{name = 'consume', duration = 0.5}, --Nunu Q
				{name = 'absolutezero', duration = 1}, --Nunu R
				{name = 'rocketgrab', duration = 0.5}, --Blitzcrank Q
				{name = 'staticfield', duration = 0.5}, --Blitzcrank R
				{name = 'cassiopeiapetrifyinggaze', duration = 0.5}, --Cassio's R
				{name = 'ezrealtrueshotbarrage', duration = 1}, --Ezreal's R
				{name = 'galioidolofdurand', duration = 1}, --Ezreal's R
				--{name = 'gragasdrunkenrage', duration = 1}, --Gragas W, Rito changed it so that it allows full movement while casting
				{name = 'luxmalicecannon', duration = 1}, --Lux R
				{name = 'reapthewhirlwind', duration = 1}, --Jannas R
				{name = 'jinxw', duration = 0.6}, --jinxW
				{name = 'jinxr', duration = 0.6}, --jinxR
				{name = 'missfortunebullettime', duration = 1}, --MissFortuneR
				{name = 'shenstandunited', duration = 1}, --ShenR
				{name = 'threshe', duration = 0.4}, --ThreshE
				{name = 'threshrpenta', duration = 0.75}, --ThreshR
				{name = 'infiniteduress', duration = 1}, --Warwick R
				{name = 'meditate', duration = 1} --yi W
			}

			self.blinks = {
				{name = 'ezrealarcaneshift', range = 475, delay = 0.25, delay2=0.8},--Ezreals E
				{name = 'deceive', range = 400, delay = 0.25, delay2=0.8}, --Shacos Q
				{name = 'riftwalk', range = 700, delay = 0.25, delay2=0.8},--KassadinR
				{name = 'gate', range = 5500, delay = 1.5, delay2=1.5},--Twisted fate R
				{name = 'katarinae', range = math.huge, delay = 0.25, delay2=0.8},--Katarinas E
				{name = 'elisespideredescent', range = math.huge, delay = 0.25, delay2=0.8},--Elise E
				{name = 'elisespidere', range = math.huge, delay = 0.25, delay2=0.8},--Elise insta E
			}

			return self
		end

		function VPrediction:GetTime()
			return os.clock()
		end

		function VPrediction:GetVersion()
			return self.version
		end

		function VPrediction:OnProcessSpell(unit, spell)
			if unit and unit.type == myHero.type then
				self.CastingSpells[unit.networkID] = self:GetTime() + 0.25
				
				if string.match(spell.name:lower(), "attack") then
					self.AutoAttacking[unit.networkID] = self:GetTime() + spell.windUpTime
				end
				
				for i, s in ipairs(self.spells) do
					if spell.name:lower() == s.name then
						self.TargetsImmobile[unit.networkID] = self:GetTime() + s.duration
						return
					end
				end

				for i, s in ipairs(self.blinks) do
					local LandingPos = GetDistanceSqr(unit, Vector(spell.endPos)) < s.range * s.range and Vector(spell.endPos) or Vector(unit) + s.range * (Vector(spell.endPos) - Vector(unit)):normalized()
					if spell.name:lower() == s.name and not IsWall(D3DXVECTOR3(spell.endPos.x, spell.endPos.y, spell.endPos.z)) then
						self.TargetsDashing[unit.networkID] = {isblink = true, duration = s.delay, endT = self:GetTime() + s.delay, endT2 = self:GetTime() + s.delay2, startPos = Vector(unit), endPos = LandingPos}
						return 
					end
				end

				for i, s in ipairs(self.BlackList) do
					if spell.name:lower() == s.name then
						self.DontShoot[unit.networkID] = self:GetTime() + s.duration
						return
					end
				end

				for i, s in ipairs(self.dashAboutToHappend) do
					if spell.name:lower() == s.name then
						self.DontShoot2[unit.networkID] = self:GetTime() + s.duration
						return
					end
				end
			end
		end

		function VPrediction:OnNewPath(unit, startPos, endPos, isDash, dashSpeed ,dashGravity, dashDistance)
			--Dash
			if isDash then 
				local dash = {}
				if unit.type == myHero.type then
					dash.startPos = startPos
					dash.endPos = endPos
					dash.speed = dashSpeed
					dash.startT = self:GetTime() - GetLatency()/2000
					dash.endT = dash.startT + (GetDistance(startPos, endPos) / dashSpeed)
					self.TargetsDashing[unit.networkID] = dash
					self.DontShootUntilNewWaypoints[unit.networkID] = true
				end
				return
			end
			
			--Normal movement
			local NetworkID = unit.networkID
			if unit and unit.valid and unit.networkID and unit.type == myHero.type then
				self.DontShootUntilNewWaypoints[NetworkID] = false
				if self.TargetsWaypoints[NetworkID] == nil then
					self.TargetsWaypoints[NetworkID] = {}
				end
				local WaypointsToAdd = self:GetCurrentWayPoints(unit)
				if WaypointsToAdd and #WaypointsToAdd >= 1 then
					table.insert(self.TargetsWaypoints[NetworkID], {unitpos = Vector(unit) , waypoint = WaypointsToAdd[#WaypointsToAdd], time = self:GetTime(), n = #WaypointsToAdd})
				end
				return
			end
			
			--We need to track the minions/turrets auto attacks for health prediction
			if unit and unit.valid and unit.type ~= myHero.type then
				local i = 1
				while i <= #self.ActiveAttacks do
					if (self.ActiveAttacks[i].Attacker and self.ActiveAttacks[i].Attacker.valid and self.ActiveAttacks[i].Attacker.networkID == NetworkID and (self.ActiveAttacks[i].starttime + self.ActiveAttacks[i].windUpTime - GetLatency()/2000) > self:GetTime()) then
						local wpts = self:GetWaypoints(unit.networkID)
						if #wpts > 1 then
							table.remove(self.ActiveAttacks, i)
						else
							i = i + 1
						end
					else
						i = i + 1
					end
				end
			end
		end

		function VPrediction:IsImmobile(unit, delay, radius, speed, from, spelltype)
			if self.TargetsImmobile[unit.networkID] then
				local ExtraDelay = speed == math.huge and  0 or (GetDistance(from, unit) / speed)
				if (self.TargetsImmobile[unit.networkID] > (self:GetTime() + delay + ExtraDelay) and spelltype == 'circular') then
					return true, Vector(unit), Vector(unit) + (radius/3) * (Vector(from) - Vector(unit)):normalized()
				elseif (self.TargetsImmobile[unit.networkID] + (radius / unit.ms)) > (self:GetTime() + delay + ExtraDelay) then
					return true, Vector(unit), Vector(unit)
				end
			end
			return false, Vector(unit), Vector(unit)
		end

		function VPrediction:isSlowed(unit, delay, speed, from)
			if self.TargetsSlowed[unit.networkID] then
				if self.TargetsSlowed[unit.networkID] > (self:GetTime() + delay + GetDistance(unit, from) / speed) then
					return true
				end
			end
			return false
		end

		function VPrediction:IsDashing(unit, delay, radius, speed, from)
			local TargetDashing = false
			local CanHit = false
			local Position

			if self.TargetsDashing[unit.networkID] then
				local dash = self.TargetsDashing[unit.networkID]
				if dash.endT >= self:GetTime() then
					TargetDashing = true
					if dash.isblink then
						if (dash.endT - self:GetTime()) <= (delay + GetDistance(from, dash.endPos)/speed) then
							Position = Vector(dash.endPos.x, 0, dash.endPos.z)
							CanHit = (unit.ms * (delay + GetDistance(from, dash.endPos)/speed - (dash.endT2 - self:GetTime()))) < radius
						end

						if ((dash.endT - self:GetTime()) >= (delay + GetDistance(from, dash.startPos)/speed)) and not CanHit then
							Position = Vector(dash.startPos.x, 0, dash.startPos.z)
							CanHit = true
						end
						
					else
						local t1, p1, t2, p2, dist = VectorMovementCollision(dash.startPos, dash.endPos, dash.speed, from, speed, (self:GetTime() - dash.startT) + delay)
						t1, t2 = (t1 and 0 <= t1 and t1 <= (dash.endT - self:GetTime() - delay)) and t1 or nil, (t2 and 0 <= t2 and t2 <=  (dash.endT - self:GetTime() - delay)) and t2 or nil 
						local t = t1 and t2 and math.min(t1,t2) or t1 or t2
						if t then
							Position = t==t1 and Vector(p1.x, 0, p1.y) or Vector(p2.x, 0, p2.y)
							CanHit = true
						else
							Position = Vector(dash.endPos.x, 0, dash.endPos.z)
							CanHit = (unit.ms * (delay + GetDistance(from, Position)/speed - (dash.endT - self:GetTime()))) < radius
						end
					end
				end
			end
			return TargetDashing, CanHit, Position
		end

		function VPrediction:GetWaypoints(NetworkID, from, to)
			local Result = {}
			to = to and to or self:GetTime()
			if self.TargetsWaypoints[NetworkID] then
				for i, waypoint in ipairs(self.TargetsWaypoints[NetworkID]) do
					if from <= waypoint.time  and to >= waypoint.time then
						table.insert(Result, waypoint)
					end
				end
			end
			return Result, #Result
		end

		function VPrediction:CountWaypoints(NetworkID, from, to)
			local R, N = self:GetWaypoints(NetworkID, from, to)
			return N
		end

		function VPrediction:GetWaypointsLength(Waypoints)
			local result = 0
			for i = 1, #Waypoints -1 do
				result = result + GetDistance(Waypoints[i], Waypoints[i + 1])
			end
			return result
		end

		function VPrediction:CutWaypoints(Waypoints, distance)
			local result = {}
			local remaining = distance
			if distance > 0 then
				for i = 1, #Waypoints -1 do
					local A, B = Waypoints[i], Waypoints[i + 1]
					local dist = GetDistance(A, B)
					if dist >= remaining then
						result[1] = Vector(A) + remaining * (Vector(B) - Vector(A)):normalized()

						for j = i + 1, #Waypoints do
							result[j - i + 1] = Waypoints[j]
						end
						remaining = 0
						break
					else
						remaining = remaining - dist
					end
				end
			else
				local A, B = Waypoints[1], Waypoints[2]
				result = Waypoints
				result[1] = Vector(A) - distance * (Vector(B) - Vector(A)):normalized()
			end

			return result
		end

		function VPrediction:GetCurrentWayPoints(object)
			local result = {}
			
				if object.hasMovePath then
					table.insert(result, Vector(object))
					for i = object.pathIndex, object.pathCount do
						
						path = object:GetPath(i)
						table.insert(result, Vector(path))
					end
				else
					table.insert(result, Vector(object))
				end
				return result
		end

		-- Calculate the hero position based on the last waypoints
		function VPrediction:CalculateTargetPosition(unit, delay, radius, speed, from, spelltype)
			local Waypoints = {}
			local Position, CastPosition, Shoot = Vector(unit), Vector(unit), false
			local t

			Waypoints = self:GetCurrentWayPoints(unit)
			local Waypointslength = self:GetWaypointsLength(Waypoints)
			
			if #Waypoints == 1 then
				Position, CastPosition = Vector(Waypoints[1]), Vector(Waypoints[1])
				return Position, CastPosition, true
			elseif Waypointslength >= delay * unit.ms + radius then
				local tA = 0
				Waypoints = self:CutWaypoints(Waypoints, delay * unit.ms - radius)
				
				local A, B = 0, 0
				if speed ~= math.huge then
					for i = 1, #Waypoints - 1 do
						A, B = Waypoints[i], Waypoints[i+1]
						if i == #Waypoints - 1 then
							B = Vector(B) + radius * Vector(B - A):normalized()
						end
						local t1, p1, t2, p2, D = VectorMovementCollision(A, B, unit.ms, Vector(from), speed)
						local tB = tA + D / unit.ms
						t1, t2 = (t1 and tA <= t1 and t1 <= (tB - tA)) and t1 or nil, (t2 and tA <= t2 and t2 <= (tB - tA)) and t2 or nil
						t = t1 and t2 and math.min(t1, t2) or t1 or t2
						if t then
							CastPosition = t==t1 and Vector(p1.x, myHero.y, p1.y) or Vector(p2.x, myHero.y, p2.y)
							break
						end
						tA = tB
					end
				else
					t = 0
					CastPosition = Vector(Waypoints[1])
					Shoot = true
				end

				if t then
					Shoot = true
					if (self:GetWaypointsLength(Waypoints) - t * unit.ms - radius) >= 0 then
						Waypoints = self:CutWaypoints(Waypoints, radius + t * unit.ms)
						Position = Vector(Waypoints[1])
					else
						Position = CastPosition
					end
					
					if spelltype == 'line' and unit.type == myHero.type and (Position.x ~= CastPosition.x or Position.z ~= CastPosition.z) and A ~= 0 then
						local angle = Vector(0, 0):angleBetween(Vector(from.x, from.z) - Vector(Position.x, Position.z), Vector(A.x, A.z) - Vector(B.x, B.z))
						if angle >= 40 and angle <= 135 then
							local angle2 = math.asin((radius - 5) / GetDistance(Position, from))
							local direction2 = (Vector(Position) - Vector(from))
							local candi1 = from + direction2:rotated(0, angle2 ,0)
							local candi2 = from + direction2:rotated(0, -angle2 ,0)
							CastPosition = GetDistanceSqr(candi1, CastPosition) < GetDistanceSqr(candi2, CastPosition) and candi1 or candi2;
						end
					end
				elseif unit.type ~= myHero.type then
					CastPosition = Vector(Waypoints[#Waypoints])
					Position = CastPosition
				end
			elseif unit.type ~= myHero.type then
				CastPosition = Vector(Waypoints[#Waypoints])
				Position = CastPosition
			end

			-- If the target is slowed its better to just cast the skillshot centered
			if t and self:isSlowed(unit, 0, math.huge, from) and not self:isSlowed(unit, t, math.huge, from) and Position then
				CastPosition = Position
			end

			return CastPosition, Position, Shoot
		end

		function VPrediction:MaxAngle(unit, currentwaypoint, from)
			local WPtable, n = self:GetWaypoints(unit.networkID, from)
			local Max = 0
			local CV = (Vector(currentwaypoint.x, 0, currentwaypoint.y) - Vector(unit))
				for i, waypoint in ipairs(WPtable) do
						local angle = Vector(0, 0, 0):angleBetween(CV, Vector(waypoint.waypoint.x, 0, waypoint.waypoint.y) - Vector(waypoint.unitpos.x, 0, waypoint.unitpos.y))
						if angle > Max then
							Max = angle
						end
				end
			return Max
		end

		function VPrediction:WayPointAnalysis(unit, delay, radius, range, speed, from, spelltype, dmg)
			local Position, CastPosition, HitChance
			local SavedWayPoints = self.TargetsWaypoints[unit.networkID] and self.TargetsWaypoints[unit.networkID] or {}
			local CurrentWayPoints = self:GetCurrentWayPoints(unit)
			
			HitChance = 2
			
			CastPosition, Position, Shoot = self:CalculateTargetPosition(unit, delay, radius, speed, from, spelltype, dmg)

			-- Detect if the enemy is clicking on a very spreaded way trying to "juke":
			-- TODO: finetune the parameters if needed.
			if #SavedWayPoints > 6 then
				local mean = Vector(0, 0, 0)
				for i, waypoint in ipairs(SavedWayPoints) do
					mean = mean + Vector(waypoint.waypoint)
				end
				mean = mean / #SavedWayPoints
				
				--In the future this variance could be weighted according to the time passed since the order was issued
				local variance = 0
				for i, waypoint in ipairs(SavedWayPoints) do
					variance = variance + GetDistanceSqr(Vector(waypoint.waypoint), mean)
				end
				variance = variance / #SavedWayPoints
				
				-- As Mr. DienoFail pointed out on PPrediction we could increase the speed instead of decreasing the hit chance but since the path can be on a completely different direction probably that wouldn't be effective at all.
				if variance > 600 * 600 then
					HitChance = 1
				end
			end
			
			-- Avoid casting spells on random directions 
			local N = 3
			local t1 = 1
			if self:CountWaypoints(unit.networkID, self:GetTime() - 0.75) >= N then
				local angle = self:MaxAngle(unit, CurrentWayPoints[#CurrentWayPoints], self:GetTime() - t1)
				if angle > 110 then
					HitChance = 1
				elseif angle < 30 and self:CountWaypoints(unit.networkID, self:GetTime() - 0.1) >= 1 then
					HitChance = 2
				end
			end
			
			if self.CastingSpells[unit.networkID] ~= nil and self.CastingSpells[unit.networkID] > self:GetTime() then
				HitChance = 2
			end
			
			if self.AutoAttacking[unit.networkID] ~= nil and self.AutoAttacking[unit.networkID] > self:GetTime() then
				HitChance = 2
			end
			
			-- This sometimes it's not completely true but 80% of the times it is.
			if self:isSlowed(unit, delay, speed, from) then
				HitChance = 3
			end
			
			if Position and CastPosition and ((radius / unit.ms >= delay + GetDistance(from, CastPosition)/speed) or (radius / unit.ms >= delay + GetDistance(from, Position)/speed)) then
				HitChance = 3
			end

			if not Position or not CastPosition then
				HitChance = 0
				CastPosition = Vector(unit)
				Position = CastPosition
			end

			-- If the target is too close it usually will stop, autoattack, etc. decreasing the delay we compensate that effect
			if GetDistanceSqr(myHero, unit) < 250 * 250 and unit ~= myHero then
				HitChance = HitChance ~= 0 and 2 or 0
				Position, CastPosition = self:CalculateTargetPosition(unit, delay*0.5, radius, speed, from, spelltype,  dmg)
				Position = CastPosition
			end

			if self.DontShootUntilNewWaypoints[unit.networkID] then
				HitChance = 0
				CastPosition = Vector(unit)
				Position = CastPosition
			end

			if not Shoot then
				HitChance = 1
			end
			
			return CastPosition, HitChance, Position
		end

		function VPrediction:GetBestCastPosition(unit, delay, radius, range, speed, from, collision, spelltype, dmg)
			assert(radius, 'VPrediction+: Radius can\'t be nil')
			range = range and range - 15 or math.huge
			radius = radius == 0 and 1 or (radius + self:GetHitBox(unit)) - 4
			speed = (speed and speed ~= 0) and speed or math.huge
			from = from and from or Vector(myHero)
			if from.networkID and from.networkID == myHero.networkID then
				from = Vector(myHero)
			end
			local IsFromMyHero = GetDistanceSqr(from, myHero) < 50*50 and true or false

			assert(unit, 'VPrediction+: Target can\'t be nil')
			assert(range > 0, 'VPrediction+: range must be >0')
			assert(speed > 0, 'VPrediction+: speed must be >0')
			
			delay = delay + (0.05 + GetLatency() / 2000)

			local Position, CastPosition, HitChance = Vector(unit), Vector(unit), 0
			local TargetDashing, CanHitDashing, DashPosition = self:IsDashing(unit, delay, radius, speed, from)
			local TargetImmobile, ImmobilePos, ImmobileCastPosition = self:IsImmobile(unit, delay, radius, speed, from, spelltype)

			if unit.type ~= myHero.type then
				Position, CastPosition = self:CalculateTargetPosition(unit, delay, radius, speed, from, spelltype)
				HitChance = 2
			else
				if self.DontShoot[unit.networkID] and self.DontShoot[unit.networkID] > self:GetTime() then
					Position, CastPosition = Vector(unit),  Vector(unit)
					HitChance = 0
				elseif TargetDashing then
					if CanHitDashing then
						HitChance = 5
					else
						HitChance = 0
					end 
					Position, CastPosition = DashPosition, DashPosition
				elseif self.DontShoot2[unit.networkID] and self.DontShoot2[unit.networkID] > self:GetTime() then
					Position, CastPosition = Vector(unit.x, unit.y, unit.z),  Vector(unit.x, unit.y, unit.z)
					HitChance = 7
				elseif TargetImmobile then
					Position, CastPosition = ImmobilePos, ImmobileCastPosition
					HitChance = 4
				else
					CastPosition, HitChance, Position = self:WayPointAnalysis(unit, delay, radius, range, speed, from, spelltype)
				end
			end

			-- Out of range
			if IsFromMyHero and self.avoidRangeCheck == nil then
				if (spelltype == 'line' and GetDistanceSqr(from, Position) >= range * range) then
					HitChance = 0
				end
				if (spelltype == 'circular' and (GetDistanceSqr(from, Position) >= (range + radius)^2)) then
					HitChance = 0
				end

				if HitChance ~= 0 and spelltype == 'circular' and (GetDistanceSqr(from, CastPosition) > range * range) then
					if GetDistanceSqr(from, Position) <= (range + radius / 1.4) ^ 2 then
						if GetDistanceSqr(from, Position) <= range * range then
							CastPosition = Position
						else
							CastPosition = Vector(from) + range * (Vector(Position) - Vector(from)):normalized()
						end
					end
				elseif (GetDistanceSqr(from, CastPosition) > range * range) then
					HitChance = 0
				end
			end

			radius = radius - self:GetHitBox(unit) + 4

			if collision and HitChance > 0 then
				self.EnemyMinions.range = range + 500 * (delay + range/speed)
				self.JungleMinions.range = self.EnemyMinions.range
				self.OtherMinions.range = self.EnemyMinions.range
				self.EnemyMinions:update()
				self.JungleMinions:update()
				self.OtherMinions:update()

				if _G.VPredictionMenu.Collision.CastPos and self:CheckMinionCollision(unit, CastPosition, delay, radius, range, speed, from, false, false, dmg) then
					HitChance = -1
				elseif _G.VPredictionMenu.Collision.PredictPos and self:CheckMinionCollision(unit, Position, delay, radius, range, speed, from, false, false, dmg) then
					HitChance = -1
				end
				if _G.VPredictionMenu.Collision.UnitPos and self:CheckMinionCollision(unit, unit, delay, radius, range, speed, from, false, false, dmg) then
					HitChance = -1
				end
			end
			
			return CastPosition, HitChance, Position
		end

		--------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------
		--Collision
		--------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------

		function VPrediction:GetPredictedHealth(unit, time, delay)
			local IncDamage = 0
			local i = 1
			local MaxDamage = 0
			local count = 0
			delay = delay and delay or 0.07
			while i <= #self.ActiveAttacks do
				if self.ActiveAttacks[i].Attacker and not self.ActiveAttacks[i].Attacker.dead and self.ActiveAttacks[i].Target and self.ActiveAttacks[i].Target.networkID == unit.networkID then
					local hittime = self.ActiveAttacks[i].starttime + self.ActiveAttacks[i].windUpTime + (GetDistance(self.ActiveAttacks[i].pos, unit)) / self.ActiveAttacks[i].projectilespeed + delay
					if self:GetTime() < hittime - delay and hittime < self:GetTime() + time  then
						IncDamage = IncDamage + self.ActiveAttacks[i].damage
						count = count + 1
						if self.ActiveAttacks[i].damage > MaxDamage then
							MaxDamage = self.ActiveAttacks[i].damage
						end
					end
				end
				i = i + 1
			end

			return unit.health - IncDamage, MaxDamage, count
		end

		function VPrediction:GetPredictedHealth2(unit, t)
			local damage = 0
			local i = 1

			while i <= #self.ActiveAttacks do
				local n = 0
				if (self:GetTime() - 0.1) <= self.ActiveAttacks[i].starttime + self.ActiveAttacks[i].animationTime and self.ActiveAttacks[i].Target and self.ActiveAttacks[i].Target.valid and self.ActiveAttacks[i].Target.networkID == unit.networkID and self.ActiveAttacks[i].Attacker and self.ActiveAttacks[i].Attacker.valid and not self.ActiveAttacks[i].Attacker.dead then
					local FromT = self.ActiveAttacks[i].starttime
					local ToT = t + self:GetTime()

					while FromT < ToT do
						if FromT >= self:GetTime() and (FromT + (self.ActiveAttacks[i].windUpTime + GetDistance(unit, self.ActiveAttacks[i].pos) / self.ActiveAttacks[i].projectilespeed)) < ToT then
							n = n + 1
						end
						FromT = FromT + self.ActiveAttacks[i].animationTime
					end
				end
				damage = damage + n * self.ActiveAttacks[i].damage
				i = i + 1
			end

			return unit.health - damage
		end

		function VPrediction:CollisionProcessSpell(unit, spell)
			if unit and unit.valid and spell.target and unit.type ~= myHero.type and spell.target.type == 'obj_AI_Minion' and unit.team == myHero.team and spell and spell.name and (spell.name:lower():find('attack') or (spell.name == 'frostarrow')) and spell.windUpTime and spell.target then
				if GetDistanceSqr(unit) < 4000000 then

					local time = self:GetTime() + spell.windUpTime + GetDistance(spell.target, unit) / self:GetProjectileSpeed(unit) - GetLatency()/2000
					local i = 1
					while i <= #self.ActiveAttacks do
						if (self.ActiveAttacks[i].Attacker and self.ActiveAttacks[i].Attacker.valid and self.ActiveAttacks[i].Attacker.networkID == unit.networkID) or ((self.ActiveAttacks[i].hittime + 3) < self:GetTime()) then
							table.remove(self.ActiveAttacks, i)
						else
							i = i + 1
						end
					end

					table.insert(self.ActiveAttacks, {Attacker = unit, pos = Vector(unit), Target = spell.target, animationTime = spell.animationTime, damage = self:CalcDamageOfAttack(unit, spell.target, spell, 0), hittime=time, starttime = self:GetTime() - GetLatency()/2000, windUpTime = spell.windUpTime, projectilespeed = self:GetProjectileSpeed(unit)})
				end
			end
		end

		function VPrediction:CheckCol(unit, minion, Position, delay, radius, range, speed, from, draw, dmg)
			if unit.networkID == minion.networkID then 
				return false
			end
			-- Check first if the minion is going to be dead when skillshots reaches his position
			if minion.type ~= myHero.type and self:GetPredictedHealth(minion,  delay  + GetDistance(from, minion) / speed - GetLatency()/1000) < (dmg and dmg or 0) then
				return false
			end

			local waypoints = self:GetCurrentWayPoints(minion)
			local MPos, CastPosition = minion.pathCount == 1 and Vector(minion) or self:CalculateTargetPosition(minion, delay, radius, speed, from, 'line')
			if GetDistanceSqr(from, MPos) <= (range)^2 and GetDistanceSqr(from, minion) <= (range + 100)^2 then
				local buffer = (minion.pathCount > 1) and _G.VPredictionMenu.Collision.Buffer or 8

				if minion.type == myHero.type then
					buffer = buffer + self:GetHitBox(minion)
				end

				if draw then
					DrawCircle3D(minion.x, myHero.y, minion.z, self:GetHitBox(minion) + buffer, 1, ARGB(255, 255, 255, 255))
					DrawCircle3D(MPos.x, myHero.y, MPos.z, self:GetHitBox(minion) + buffer, 1, ARGB(255, 255, 255, 255))
					self:DLine(MPos, minion, Color)
				end
				
				if minion.pathCount > 1 then
					local proj1, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(from, Position, Vector(MPos))
					if isOnSegment and (GetDistanceSqr(MPos, proj1) <= (self:GetHitBox(minion) + radius + buffer) ^ 2) then
						return true
					end
				end
				
				local proj2, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(from, Position, Vector(minion))
				if isOnSegment and (GetDistanceSqr(minion, proj2) <= (self:GetHitBox(minion) + radius + buffer) ^ 2) then
					return true
				end
			end
			return false
		end

		function VPrediction:CheckMinionCollision(unit, Position, delay, radius, range, speed, from, draw, updatemanagers, dmg)
			Position = Vector(Position)
			from = from and Vector(from) or myHero
			--local draw = true
			if updatemanagers then
				self.EnemyMinions.range = range + 500 * (delay + range / speed)
				self.JungleMinions.range = self.EnemyMinions.range
				self.OtherMinions.range = self.EnemyMinions.range
				self.EnemyMinions:update()
				self.JungleMinions:update()
				self.OtherMinions:update()
			end

			local result = false
			if _G.VPredictionMenu.Collision.Minions then
				for i, minion in ipairs(self.EnemyMinions.objects) do
					if self:CheckCol(unit, minion, Position, delay, radius, range, speed, from, draw, dmg) then
						if not draw then
							return true
						else
							result = true
						end
					end
				end
			end
			
			if _G.VPredictionMenu.Collision.Mobs then
				for i, minion in ipairs(self.JungleMinions.objects) do
					if self:CheckCol(unit, minion, Position, delay, radius, range, speed, from, draw, dmg) then
						if not draw then
							return true
						else
							result = true
						end
					end
				end
			end

			if _G.VPredictionMenu.Collision.Others then
				for i, minion in ipairs(self.OtherMinions.objects) do
					if minion.team ~= myHero.team and self:CheckCol(unit, minion, Position, delay, radius, range, speed, from, draw, dmg) then
						if not draw then
							return true
						else
							result = true
						end
					end
				end
			end

			if self.ChampionCollision then
				for i, enemy in ipairs(GetEnemyHeroes()) do
					if self:CheckCol(unit, enemy, Position, delay, radius, range, speed, from, draw, dmg) then
						if not draw then
							return true
						else
							result = true
						end
					end
				end
			end

			if draw then
				local Direction = Vector(Position - from):perpendicular():normalized()
				local Color = result and ARGB(255, 255, 0, 0) or ARGB(255, 0, 255, 0)
				local P1r = Vector(from) + radius * Vector(Direction)
				local P1l = Vector(from) - radius * Vector(Direction)
				local P2r = Vector(from) + radius * Direction - Vector(Direction):perpendicular() * GetDistance(from, Position)
				local P2l = Vector(from) - radius * Direction - Vector(Direction):perpendicular() * GetDistance(from, Position)

				self:DLine(P1r, P1l, Color)
				self:DLine(P1r, P2r, Color)
				self:DLine(P1l, P2l, Color)
				self:DLine(P2r, P2l, Color)
				if not result and IsKeyDown(string.byte('T')) then
					CastSpell(_Q, Position.x, Position.z)
				end
			end

			return result
		end

		function VPrediction:GetCircularCastPosition(unit, delay, radius, range, speed, from, collision)
			return self:GetBestCastPosition(unit, delay, radius, range, speed, from, collision, 'circular')
		end
															
		function VPrediction:GetLineCastPosition(unit, delay, radius, range, speed, from, collision, dmg)
			return self:GetBestCastPosition(unit, delay, radius, range, speed, from, collision, 'line', dmg)
		end

		function VPrediction:GetPredictedPos(unit, delay, speed, from, collision)
			return self:GetBestCastPosition(unit, delay, 1, math.huge, speed, from, collision, 'circular')
		end

		--TODO: Recode this stuff and make it more readable :D
		function VPrediction:GetCircularAOECastPosition(unit, delay, radius, range, speed, from, collision)
			local CastPosition, HitChance, Position = self:GetBestCastPosition(unit, delay, radius, range, speed, from, collision, 'circular')
			local points = {}
			local mainCastPosition, mainHitChance, mainPosition = CastPosition, HitChance, Position

			table.insert(points, Position)

			for i, target in ipairs(GetEnemyHeroes()) do
				if target.networkID ~= unit.networkID and ValidTarget(target, range * 1.5) then
					CastPosition, HitChance, Position = self:GetBestCastPosition(target, delay, radius, range, speed, from, collision, 'circular')
					if GetDistanceSqr(from, Position) < (range + radius) ^ 2 and (Hitchance ~= -1 or not collision) then
						table.insert(points, Position)
					end
				end
			end

			while #points > 1 do
				local Mec = MEC(points)
				local Circle = Mec:Compute()
				
				if Circle.radius <= radius + self:GetHitBox(unit) - 8 then
					return Circle.center, mainHitChance, #points
				end

				local maxdist = -1
				local maxdistindex = 0

				for i=2, #points do
					local d = GetDistanceSqr(points[i], points[1])
					if d > maxdist or maxdist == -1 then
						maxdistindex = i
						maxdist = d
					end
				end

				table.remove(points, maxdistindex)
			end

			return mainCastPosition, mainHitChance, #points, mainPosition
		end

		function VPrediction:GetLineAOECastPosition(unit, delay, radius, range, speed, from)
			local CastPosition, HitChance, Position = self:GetBestCastPosition(unit, delay, radius, range, speed, from, false, 'line')
			local points = {}
			local Positions = {}
			local mainCastPosition, mainHitChance = CastPosition, HitChance

			table.insert(Positions, {unit = unit, HitChance = HitChance, Position = Position, CastPosition = CastPosition})
			table.insert(points, Position)

			range = range and range - 4 or 20000
			radius = radius == 0 and 1 or (radius + self:GetHitBox(unit)) - 4
			from = from and Vector(from) or Vector(myHero)

			local function CircleCircleIntersection(C1, C2, R1, R2)
				local D = GetDistance(C1, C2)
				local A = (R1 * R1 - R2 * R2 + D * D ) / (2 * D)
				local H = math.sqrt(R1 * R1 - A * A);
				local Direction = (Vector(C2) - Vector(C1)):normalized()
				local PA = Vector(C1) + A * Direction

				local S1 = PA + H * Direction:perpendicular()
				local S2 = PA - H * Direction:perpendicular()

				return S1, S2
			end

			local function GetPosiblePoints(from, pos, width, range)
				local middlepoint = (from + pos)/2
				local P1, P2 = CircleCircleIntersection(from, middlepoint, width, GetDistance(middlepoint, from))

				local V1 = (P1 - from)
				local V2 = (P2 - from)

				return from + range * (pos - V1 - from):normalized(), from + range * (pos - V2 - from):normalized()
			end

			local function CountHits(P1, P2, width, points)
				local hits = 0
				local hitt = {}
				width = width + 2
				for i, point in ipairs(points) do
					local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(P1, P2, point)
					if isOnSegment and GetDistanceSqr(pointSegment, point) <= width * width then
						hits = hits + 1
						table.insert(hitt, point)
					elseif i == 1 then
						return -1
					end
				end
				return hits, hitt
			end

			for i, target in ipairs(GetEnemyHeroes()) do
				if target.networkID ~= unit.networkID and ValidTarget(target, range * 1.5) then
					CastPosition, HitChance, Position = self:GetBestCastPosition(target, delay, radius, range, speed, from, false, 'line')
					if GetDistanceSqr(from, Position) < (range + radius)^2 then
						table.insert(points, Position)
						table.insert(Positions, {unit = target, HitChance = HitChance, Position = Position, CastPosition = CastPosition})
					end
				end
			end

			local MaxHit = 1
			local MaxHitPos

			if #points > 1 then
				for i, candidate in ipairs(points) do
					local C1, C2 = GetPosiblePoints(from, points[i], radius - 20, range)
					local hits, MPoints1 = CountHits(from, C1, radius, points)
					local hits2, MPoints2 = CountHits(from, C2, radius, points)
					if hits >= MaxHit then
						MaxHitPos = C1
						MaxHit = hits
						MaxHitPoints = MPoints1
					end
					if hits2 >= MaxHit then
						MaxHitPos = C2
						MaxHit = hits2
						MaxHitPoints = MPoints2
					end
				end
			end

			if MaxHit > 1 then
				--center the line
				local maxdist = -1
				local p1
				local p2
				for i, hitp in ipairs(MaxHitPoints) do
					for o, hitp2 in ipairs(MaxHitPoints) do
						local StartP, EndP = Vector(from), (Vector(hitp) + Vector(hitp2)) / 2
						local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartP, EndP, hitp)
						local pointSegment2, pointLine2, isOnSegment2 = VectorPointProjectionOnLineSegment(StartP, EndP, hitp2)

						local dist = GetDistanceSqr(hitp, pointLine) + GetDistanceSqr(hitp2, pointLine2)
						if dist >= maxdist then
							maxdist = dist
							p1 = hitp
							p2 = hitp2
						end
					end
				end

				if self.ReturnHitTable then
					for i = #Positions, 1, -1 do
						local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(from), (p1 + p2) / 2, Positions[i].Position)
						if (not isOnSegment) or (GetDistanceSqr(pointLine, Positions[i].Position) > (radius + 5)^2) then
							table.remove(Positions, i)
						end
					end
				end

				return (p1 + p2) / 2, mainHitChance, MaxHit, Positions
			else
				return mainCastPosition, mainHitChance, 1, Positions
			end
		end

		function VPrediction:GetConeAOECastPosition(unit, delay, angle, range, speed, from)
			range = range and range - 4 or 20000
			radius = 1
			from = from and Vector(from) or Vector(myHero)
			angle = (angle < math.pi * 2) and angle or (angle * math.pi / 180)

			local CastPosition, HitChance, Position = self:GetBestCastPosition(unit, delay, radius, range, speed, from, false, 'line')
			local points = {}
			local mainCastPosition, mainHitChance = CastPosition, HitChance

			table.insert(points, Vector(Position) - Vector(from))

			local function CountVectorsBetween(V1, V2, points)
				local result = 0    
				local hitpoints = {} 
				for i, test in ipairs(points) do
					local NVector = Vector(V1):crossP(test)
					local NVector2 = Vector(test):crossP(V2)
					if NVector.y >= 0 and NVector2.y >= 0 then
						result = result + 1
						table.insert(hitpoints, test)
					elseif i == 1 then
						return -1 --doesnt hit the main target
					end
				end
				return result, hitpoints
			end

			local function CheckHit(position, angle, points)
				local direction = Vector(position):normalized()
				local v1 = Vector(position):rotated(0, -angle / 2, 0)
				local v2 = Vector(position):rotated(0, angle / 2, 0)
				return CountVectorsBetween(v1, v2, points)
			end

			for i, target in ipairs(GetEnemyHeroes()) do
				if target.networkID ~= unit.networkID and ValidTarget(target, range * 1.5) then
					CastPosition, HitChance, Position = self:GetBestCastPosition(target, delay, radius, range, speed, from, false, 'line')
					if GetDistanceSqr(from, Position) < range * range then
						table.insert(points, Vector(Position) - Vector(from))
					end
				end
			end

			local MaxHitPos
			local MaxHit = 1
			local MaxHitPoints = {}

			if #points > 1 then
				for i, point in ipairs(points) do
					local pos1 = Vector(point):rotated(0, angle / 2, 0)
					local pos2 = Vector(point):rotated(0, - angle / 2, 0)

					local hits, points1 = CheckHit(pos1, angle, points)
					local hits2, points2 = CheckHit(pos2, angle, points)

					if hits >= MaxHit then
						MaxHitPos = C1
						MaxHit = hits
						MaxHitPoints = points1
					end
					if hits2 >= MaxHit then
						MaxHitPos = C2
						MaxHit = hits2
						MaxHitPoints = points2
					end
				end
			end

			if MaxHit > 1 then
				--Center the cone
				local maxangle = -1
				local p1
				local p2
				for i, hitp in ipairs(MaxHitPoints) do
					for o, hitp2 in ipairs(MaxHitPoints) do
						local cangle = Vector():angleBetween(hitp2, hitp) 
						if cangle > maxangle then
							maxangle = cangle
							p1 = hitp
							p2 = hitp2
						end
					end
				end


				return Vector(from) + range * (((p1 + p2) / 2)):normalized(), mainHitChance, MaxHit
			else
				return mainCastPosition, mainHitChance, 1
			end
		end

		function VPrediction:OnTick()
			if self.lastick == nil or self:GetTime() - self.lastick > 0.2 then
				self.lastick = self:GetTime()
				for NID, TargetWaypoints in pairs(self.TargetsWaypoints) do
					local i = 1 
					while i <= #self.TargetsWaypoints[NID] do
						if self.TargetsWaypoints[NID][i]['time'] + self.WaypointsTime < self:GetTime() then
							table.remove(self.TargetsWaypoints[NID], i)
						else
							i = i + 1
						end
					end
				end
			end
		end

		--Credits to Ralphlol for this function!
		function VPrediction:OnApplyBuff(source, unit, buff)
			if not unit or not buff or unit.type ~= myHero.type then return end
			
			if (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24) then
				self.TargetsImmobile[unit.networkID] = self:GetTime() + (buff.endTime - buff.startTime)
				return
			end
			
			if (buff.type == 10 or buff.type == 22 or buff.type == 21 or buff.type == 8) then
				self.TargetsSlowed[unit.networkID] = self:GetTime() + (buff.endTime - buff.startTime)
				return
			end

			if buff.type == 30 then
				self.DontShoot[unit.networkID] = self:GetTime() + 1
				return
			end
		end

		-- Drawing functions for debug: 
		function VPrediction:DrawSavedWaypoints(object, time, color, drawPoints)
			colour = color and color or ARGB(255, 0, 255, 0)
			for i = object.pathIndex, object.pathCount do    
				if object:GetPath(i) and object:GetPath(i-1) then
					local pStart = i == object.pathIndex and object.pos or object:GetPath(i-1)
					self:DLine(pStart, object:GetPath(i), colour)
				end
			end
			if drawPoints then
				local Waypoints = self:GetCurrentWayPoints(object)
				for i, waypoint in ipairs(Waypoints) do
					DrawCircle3D(waypoint.x, myHero.y, waypoint.z, 10, 2, ARGB(255, 0,0, 255), 200)
				end
			end
		end

		function VPrediction:DrawHitBox(object)
			DrawCircle3D(object.x, object.y, object.z, self:GetHitBox(object), 1, ARGB(255, 255, 255, 255))
			if object then
				DrawCircle3D(object.x, object.y, object.z, self:GetHitBox(object), 1, ARGB(255, 0, 255, 0))
			end
		end

		function VPrediction:DLine(From, To, Color)
			DrawLine3D(From.x, From.y, From.z, To.x, To.y, To.z, 2, Color)
		end

		function VPrediction:OnDraw()
			if self.showdevmode and _G.VPredictionMenu.Developers.Debug then
				LastGetTarget = LastGetTarget or myHero
				local target = GetTarget() or LastGetTarget
				LastGetTarget = target
				for i, enemy in ipairs(GetEnemyHeroes()) do
					self:DrawHitBox(enemy)
				end
				if _G.VPredictionMenu.Developers.SC then
					self.EnemyMinions:update()
					self.JungleMinions:update()
					self.OtherMinions:update()
					self:CheckMinionCollision(Vector(myHero) + 1050 * (Vector(mousePos) - Vector(myHero)):normalized(), 0.25, 70, 1050, 1800, myHero, true)
				end
				if target then
					self:DrawHitBox(target) 
					local CastPosition,  HitChance,  Position = self:GetCircularCastPosition(target, 0.6, 70, 900, math.huge)
					if HitChance >= -1 then
						DrawText3D(tostring(HitChance), CastPosition.x, myHero.y, CastPosition.z, 40, ARGB(255, 255, 255, 255), true)
						DrawCircle3D(Position.x, myHero.y, Position.z, 70 + self:GetHitBox(target), 1, ARGB(255, 0, 255, 0))
						DrawCircle3D(CastPosition.x, myHero.y, CastPosition.z, 70 + self:GetHitBox(target), 1, ARGB(255, 255, 0, 0))
					end
					local waypoint = self:GetCurrentWayPoints(target)
					for i  = 1, #waypoint-1 do
						self:DLine(Vector(waypoint[i].x, myHero.y, waypoint[i].y), Vector(waypoint[i+1].x, myHero.y, waypoint[i+1].y), ARGB(255,255,255,255))
					end
				end
			end
		end

		function VPrediction:GetHitBox(object)
			if self.nohitboxmode and object.type and object.type == myHero.type then
				return 0
			end
			return object.boundingRadius or 65
		end

		function VPrediction:GetProjectileSpeed(unit)
			return self.projectilespeeds[unit.charName] and self.projectilespeeds[unit.charName] or math.huge
		end

		function VPrediction:CalcDamageOfAttack(source, target, spell, additionalDamage)
			-- read initial armor and damage values
			local armorPenPercent = source.armorPenPercent
			local armorPen = source.armorPen
			local totalDamage = source.totalDamage + (additionalDamage or 0)
			local damageMultiplier = spell.name:find('CritAttack') and 2 or 1

			-- minions give wrong values for armorPen and armorPenPercent
			if source.type == 'obj_AI_Minion' then
				armorPenPercent = 1
			elseif source.type == 'obj_AI_Turret' then
				armorPenPercent = 0.7
			end

			-- turrets ignore armor penetration and critical attacks
			if target.type == 'obj_AI_Turret' then
				armorPenPercent = 1
				armorPen = 0
				damageMultiplier = 1
			end

			-- calculate initial damage multiplier for negative and positive armor

			local targetArmor = (target.armor * armorPenPercent) - armorPen
			if targetArmor < 0 then -- minions can't go below 0 armor.
				--damageMultiplier = (2 - 100 / (100 - targetArmor)) * damageMultiplier
				damageMultiplier = 1 * damageMultiplier
			else
				damageMultiplier = 100 / (100 + targetArmor) * damageMultiplier
			end

			-- use ability power or ad based damage on turrets
			if source.type == myHero.type and target.type == 'obj_AI_Turret' then
				totalDamage = math.max(source.totalDamage, source.damage + 0.4 * source.ap)
			end

			-- minions deal less damage to enemy heros
			if source.type == 'obj_AI_Minion' and target.type == myHero.type and source.team ~= TEAM_NEUTRAL then
				damageMultiplier = 0.60 * damageMultiplier
			end

			-- heros deal less damage to turrets
			if source.type == myHero.type and target.type == 'obj_AI_Turret' then
				damageMultiplier = 0.95 * damageMultiplier
			end

			-- minions deal less damage to turrets
			if source.type == 'obj_AI_Minion' and target.type == 'obj_AI_Turret' then
				damageMultiplier = 0.475 * damageMultiplier
			end

			-- siege minions and superminions take less damage from turrets
			if source.type == 'obj_AI_Turret' and (target.charName == 'Red_Minion_MechCannon' or target.charName == 'Blue_Minion_MechCannon') then
				damageMultiplier = 0.8 * damageMultiplier
			end

			-- caster minions and basic minions take more damage from turrets
			if source.type == 'obj_AI_Turret' and (target.charName == 'Red_Minion_Wizard' or target.charName == 'Blue_Minion_Wizard' or target.charName == 'Red_Minion_Basic' or target.charName == 'Blue_Minion_Basic') then
				damageMultiplier = (1 / 0.875) * damageMultiplier
			end

			-- turrets deal more damage to all units by default
			if source.type == 'obj_AI_Turret' then
				damageMultiplier = 1.05 * damageMultiplier
			end

			-- calculate damage dealt
			return damageMultiplier * totalDamage
		end


	