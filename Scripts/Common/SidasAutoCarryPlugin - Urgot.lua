--             _  __  ____   ___  _____  ____    ____  _   _  ____    __  __  ___  __   _  _ 
--            (  )(  )(  _ \ / __)(  _  )(_  _)  (_  _)( )_( )( ___)  (  )(  )/ __)(  ) ( \/ )
--             )(__)(  )   /( (_-. )(_)(   )(      )(   ) _ (  )__)    )(__)(( (_-. )(__ \  / 
--            (______)(_)\_) \___/(_____) (__)    (__) (_) (_)(____)  (______)\___/(____)(__)
--            
--            MADE BY NERDMAROMBA
--            v2.0 - New coded script, new functions and more accurate!
-- 
 
if myHero.charName ~= "Urgot" then return end
 
require "Prodiction"
require "FastCollision"
 
local qRange = 1000
local qRangePoisoned = 1200
local wRange = 500
local eRange = 900
local rRange = 400 + (player:GetSpellData(_R).level*150)
 
local QAble, WAble, EAble, RAble = false, false, false, false
 
local Prodict = ProdictManager.GetInstance()
local ProdictQ, ProdictQCol
local ProdictE
 
function PluginOnLoad()
        AutoCarry.SkillsCrosshair.range = 1000
        Menu()
		towersUpdate()
        ProdictQ = Prodict:AddProdictionObject(_Q, qRange, 1600, 0.175, 60)
		ProdictQCol = FastCol(ProdictQ)
       
        ProdictE = Prodict:AddProdictionObject(_E, eRange, 1750, 0.250, 0)
                       
        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
    igniteslot = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
    igniteslot = SUMMONER_2
 end
end
 
function PluginOnTick()
        Checks()
        FlameOn()
        if Target then
                if Target and (AutoCarry.MainMenu.AutoCarry) then
                        Poison()
						SlowBar()
						if not isPoisoned(Target) then Shot() end
                        Transfer()
                end
                if Target and (AutoCarry.MainMenu.MixedMode) then
						Poison2()
						SlowBar2()
                        if not isPoisoned(Target) then Shot2() end
                end
        end
		if Target and QAble and isPoisoned(Target) and AutoCarry.PluginMenu.useQpoisoned then
                if GetDistance(Target) < qRangePoisoned then
                        CastSpell(_Q, Target.x, Target.z)
                end
        end
		if AutoCarry.PluginMenu.rTower then towerTeleport() end
		if AutoCarry.PluginMenu.muramana then MuramanaToggle() end
        --Lane Clear
		if QAble and AutoCarry.PluginMenu.qFarm and AutoCarry.MainMenu.LaneClear and AutoCarry.PluginMenu.Clear then
                if Minion and not Minion.type == "obj_Turret" and not Minion.dead and GetDistance(Minion) <= qRange and Minion.health < getDmg("Q", Minion, myHero) then
                        CastSpell(_Q, Minion.x, Minion.z)
                else
                        for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
                                if minion and not minion.dead and GetDistance(minion) <= qRange and minion.health < getDmg("Q", minion, myHero) then
                                        CastSpell(_Q, minion.x, minion.z)
                                end
                        end
                end
        end
end
 
function PluginOnDraw()
        if not myHero.dead then
            if QAble and AutoCarry.PluginMenu.drawQ then
                DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0xFFFFFF)
            end
            if EAble and AutoCarry.PluginMenu.drawE then
                DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0x00FF00)
            end
			if RAble and AutoCarry.PluginMenu.drawR then
                DrawCircle(myHero.x, myHero.y, myHero.z, rRange, 0x00FF00)
            end
        end
end
 
function Menu()
		towers = {}
        local HKR = string.byte("A")
        AutoCarry.PluginMenu:addParam("sep1", "-- Misc Options --", SCRIPT_PARAM_INFO, "")
        AutoCarry.PluginMenu:addParam("KSIgnite", "KS - Ignite", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("rEnemies", "Position Reverser - Min Enemies",SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
		AutoCarry.PluginMenu:addParam("rTTEnemies", "Tower Teleport - Min Enemies",SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
		AutoCarry.PluginMenu:addParam("TTrange", "Tower Teleport - Max Tower Range",SCRIPT_PARAM_SLICE, 600, 1, 750, 0)
		AutoCarry.PluginMenu:addParam("rTower", "Position Reverser - Turret Transfer", SCRIPT_PARAM_ONOFF, true)
		AutoCarry.PluginMenu:addParam("muramana", "Muramana - Toggle", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("sep2", "-- Autocarry Options --", SCRIPT_PARAM_INFO, "")
        AutoCarry.PluginMenu:addParam("sep3", "[Cast]", SCRIPT_PARAM_INFO, "")
        AutoCarry.PluginMenu:addParam("useQ", "Use - Acid Hunter", SCRIPT_PARAM_ONOFF, true)
		AutoCarry.PluginMenu:addParam("useQpoisoned", "AutoUse - Acid Hunter w/ Poison", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("useW", "Use - Slow w/ W", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("useE", "Use - Poison", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("useR", "Use - Position Transfer", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("sep4", "-- Mixed Mode Options --", SCRIPT_PARAM_INFO, "")
        AutoCarry.PluginMenu:addParam("useQ2", "Use - Acid Hunter", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("useW2", "Use - Slow w/ W", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("useE2", "Use - Poison", SCRIPT_PARAM_ONOFF, true)
        AutoCarry.PluginMenu:addParam("sep5", "-- Lane Clear Options --", SCRIPT_PARAM_INFO, "")
        AutoCarry.PluginMenu:addParam("qFarm", "Use - Acid Hunter", SCRIPT_PARAM_ONOFF, false)
        AutoCarry.PluginMenu:addParam("Clear", "Use skills to LaneClear", SCRIPT_PARAM_ONOFF, false)
        AutoCarry.PluginMenu:addParam("sep6", "-- Drawing Options --", SCRIPT_PARAM_INFO, "")
        AutoCarry.PluginMenu:addParam("drawQ", "Draw - Acid Hunter", SCRIPT_PARAM_ONOFF, false)
        AutoCarry.PluginMenu:addParam("drawE", "Draw - Noxian Corrosive Charge", SCRIPT_PARAM_ONOFF, false)
        AutoCarry.PluginMenu:addParam("drawR", "Draw - Hyper-Kinetic Position Reverser", SCRIPT_PARAM_ONOFF, false)
end
 
function Checks()
  QAble = (myHero:CanUseSpell(_Q) == READY)
  WAble = (myHero:CanUseSpell(_W) == READY)
  EAble = (myHero:CanUseSpell(_E) == READY)
  RAble = (myHero:CanUseSpell(_R) == READY)
  Target = AutoCarry.GetAttackTarget()
  Minion = AutoCarry.GetMinionTarget()
end
 
function Shot()
		if QAble and AutoCarry.PluginMenu.useQ and GetDistance(Target) <= qRange then ProdictQ:GetPredictionCallBack(Target, CastQ) end
end       
 
function SlowBar()
  if WAble and AutoCarry.PluginMenu.useW and GetDistance(Target) <= wRange then CastSpell(_W) end
end

function Transfer()
  if RAble and AutoCarry.PluginMenu.useR and GetDistance(Target) <= rRange then CastR(Target) end
end
 
function Poison()
        if EAble and AutoCarry.PluginMenu.useE and GetDistance(Target) <= eRange then
        ProdictE:GetPredictionCallBack(Target, CastE) end
end    
  
 
function Shot2()
        if QAble and AutoCarry.PluginMenu.useQ2 and GetDistance(Target) <= qRange then ProdictQ:GetPredictionCallBack(Target, CastQ2) end
end    
 
function SlowBar2()
  if WAble and AutoCarry.PluginMenu.useW2 and GetDistance(Target) <= wRange then CastSpell(_W) end
end
 
function Poison2()
        if EAble and AutoCarry.PluginMenu.useE2 and GetDistance(Target) <= eRange then
        ProdictQ:GetPredictionCallBack(Target, CastE) end
end    
 
local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end
 
function CastQ(unit, pos, spell)
	local willCollide = ProdictQCol:GetMinionCollision(pos, myHero)
    if not willCollide then
    if GetDistance(pos) - getHitBoxRadius(unit)/2 < qRange then
         CastSpell(_Q, pos.x, pos.z) end
    end
end

function CastQ2(unit, pos, spell)
	local willCollide = ProdictQCol:GetMinionCollision(pos, myHero)
    if not willCollide then
    if GetDistance(pos) - getHitBoxRadius(unit)/2 < qRange then
         CastSpell(_Q, pos.x, pos.z) end
    end
end
       
function CastE(unit, pos, spell)
        if GetDistance(pos) - getHitBoxRadius(unit)/2 < eRange then
          CastSpell(_E, pos.x, pos.z)
        end
end
 

function CastR(target)
        if GetDistance(target) <= rRange then
                if CountEnemies(Target, 600) >= AutoCarry.PluginMenu.rEnemies then CastSpell(_R, target) end
        end
end
 
function FlameOn( )
    for _, igtarget in pairs(GetEnemyHeroes()) do
                if ValidTarget(igtarget, 600) and KSIgnite and igtarget.health <= 50 + (20 * player.level) then
                CastSpell(igniteslot, igtarget)
        end
    end
end
  
function CountEnemies(point, range)
        local ChampCount = 0
        for j = 1, heroManager.iCount, 1 do
                local enemyhero = heroManager:getHero(j)
                if myHero.team ~= enemyhero.team and ValidTarget(enemyhero, rRange) then
                        if GetDistance(enemyhero, point) <= range then
                                ChampCount = ChampCount + 1
                        end
                end
        end            
        return ChampCount
end

--function CountMinions(point, range)
--        local ChampCount = 0
--        for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
--                Minion = AutoCarry.GetMinionTarget()
--                if minion then
--                        if GetDistance(AutoCarry.EnemyMinions().objects, point) <= range then
--                                ChampCount = ChampCount + 1
--                        end
--              end
--        end      
--        return ChampCount
--		PrintChat(ChampCount)
--end
     
--CountMinions(Target, 600)	 
	 
function towerTeleport()
        for i, target in ipairs(GetEnemyHeroes()) do
                if target and GetDistance(target) <= rRange and inTurretRange(myHero) then
                       if CountEnemies(Target, 600) >= AutoCarry.PluginMenu.rTTEnemies then CastSpell(_R, target) end
                end
        end
end 
 
function isPoisoned(target)
        for i = 1, target.buffCount, 1 do
                local tBuff = target:getBuff(i)
                if BuffIsValid(tBuff) then
                        if tBuff.name:lower():find("debuf") then
                                return true
                        end
                end
        end
end

function towersUpdate()
        for i = 1, objManager.iCount, 1 do
                local obj = objManager:getObject(i)
                if obj and obj.type == "obj_Turret" and obj.health > 0 then
                        if not string.find(obj.name, "TurretShrine") and obj.team == player.team then
                                table.insert(towers, obj)
                        end
                end
        end
end
 
function inTurretRange(unit)
        local check = false
        for i, tower in ipairs(towers) do
                if tower.health > 0 then
                        if math.sqrt((tower.x - unit.x) ^ 2 + (tower.z - unit.z) ^ 2) < AutoCarry.PluginMenu.TTrange then
                                check = true
                        end
                else
                        table.remove(towers, i)
                end
        end
        return check
end

function MuramanaToggle()
        if Target and Target.type == myHero.type and GetDistance(Target) <= qRangePoisoned and not MuramanaIsActive() and (AutoCarry.MainMenu.AutoCarry or AutoCarry.MainMenu.MixedMode) then
                MuramanaOn()
        elseif not Target and MuramanaIsActive() then
                MuramanaOff()
        end
end