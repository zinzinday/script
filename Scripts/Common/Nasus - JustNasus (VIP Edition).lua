--[[ JustNasus by Galaxix 

Thanks Kain, Skeem and Trees.

Changelog :
   1.0    - Initial Release
   1.1    - Fixed errors and bugs
   1.2    - Added Auto Ultimate function
   1.3    - Fixed combo and added Jungle Clear
   1.4 - 1.5    - Fixed last hit with (Q) [Perfect last hit ]

]]--

if myHero.charName ~= "Nasus" or not VIP_USER then return end

local QStack = 0
local bHasBuff = false

function PluginOnTick()
        Checks()
        SmartKS()
        UseConsumables()
    if AutoCarry.PluginMenu.ks then SmartKS() end
    if AutoCarry.MainMenu.LaneClear then JungleClear() end
    if QREADY and AutoCarry.PluginMenu.qFarm and AutoCarry.MainMenu.LastHit and not AutoCarry.MainMenu.AutoCarry then qFarm() end
	if AutoCarry.MainMenu.AutoCarry then Combo() end
	if AutoCarry.MainMenu.MixedMode and AutoCarry.PluginMenu.qHarass and QREADY and GetDistance(Target) <= qRange then CastSpell(_Q, Target) end
end


function PluginOnLoad()
        
        loadMain() -- Loads Global Variables
        menuMain() -- Loads AllClass Menu
        AdvancedCallback:bind('OnGainBuff', function(unit, buff) OnGainBuff(unit, buff) end)
        AdvancedCallback:bind('OnLoseBuff', function(unit, buff) OnLoseBuff(unit, buff) end)
        PrintChat("<font color='#FF0033'> >> JustNasus [VIP] v1.5 by Galaxix Loaded ! <<</font>")
end

function OnGainBuff(unit,buff)
        if unit.isMe then
                if buff.name == "NasusQ" then
                        HasBuff = true
                end
        end
end
function OnLoseBuff(unit,buff)
        if unit.isMe then
                if buff.name == "NasusQ" then
                        HasBuff = false
                end
        end
end
function PluginOnRecvPacket(p)
        if p.header == 0xFE and p.size == 0xC then
                p.pos = 1
                pNetworkID = p:DecodeF()
                unk01 = p:Decode2()
                unk02 = p:Decode1()
                stack = p:Decode4()
 
                if pNetworkID == myHero.networkID then
                        QStack = stack
                end
        end
end

function QDamage(target)
        local ADDmg = getDmg("AD", target, myHero)
        local extra = (SheenSlot and ADDmg or 0) + (TrinitySlot and ADDmg*1.5 or 0) + (LichBaneSlot and getDmg("LICHBANE",target,myHero) or 0) + (IceBornSlot and ADDmg*1.25 or 0)
        return getDmg("Q", target, myHero) + myHero:CalcDamage(target,QStack) + extra
end
 
--Q Farm
function qFarm()
if QREADY or bHasBuff then
                        AutoCarry.CanAttack = false
                        for _, minion in pairs(AutoCarry.EnemyMinions().objects)do
                                if minion and not minion.dead and minion.health < QDamage(minion) then
                                        CastSpell(_Q, minion.x, minion.z)
                                        myHero:Attack(minion)
                                        AutoCarry.shotFired = true
                                end
                        end
                        AutoCarry.CanAttack = true
                end
        end
-- Auto ult
function AutoUlt()
    if RREADY and not myHero.dead then
 local MinimumEnemies = AutoCarry.PluginMenu.MinimumEnemies
 local EnemiesRange = AutoCarry.PluginMenu.MinimumRange
 local MyHealth = myHero.health
 local MinimumHealth = (myHero.maxHealth * (AutoCarry.PluginMenu.MinimumHealth / 100))
     if (CountEnemyHeroInRange(EnemiesRange) >= MinimumEnemies) and (MyHealth <= MinimumHealth) and RREADY then
            CastSpell(_R)
        end
        if (CountEnemyHeroInRange(EnemiesRange) >= 1) and not myHero.canMove and (MyHealthPercent <= MinimumHealth) and RREADY then
            CastSpell(_R)
        end        
    end
end

--end auto ult

--Jungle clear
function JungleClear()
        if IsSACReborn then
                JungleMob = AutoCarry.Jungle:GetAttackableMonster()
        else
                JungleMob = AutoCarry.GetMinionTarget()
        end
        if JungleMob ~= nil and not IsMyManaLow() then
                if EREADY and AutoCarry.PluginMenu.JungleE and GetDistance(JungleMob) <= eRange then CastSpell(_E, JungleMob) end
                if QREADY and AutoCarry.PluginMenu.JungleQ and GetDistance(JungleMob) <= qRange then CastSpell(_Q, JungleMob) end
                               
        end
end


--end jungle clear

--Combo
function Combo()
        if Target then
                if DFGREADY then CastSpell(dfgSlot, Target) end
                if HXGREADY then CastSpell(hxgSlot, Target) end
                if BWCREADY then CastSpell(bwcSlot, Target) end
                if BRKREADY then CastSpell(brkSlot, Target) end
                                        
                if WREADY and AutoCarry.PluginMenu.useW and GetDistance(Target) <= wRange then CastSpell(_W, Target) end
                if EREADY and AutoCarry.PluginMenu.useE and GetDistance(Target) <= eRange then CastSpell(_E, Target.x, Target.z) end
                if QREADY and AutoCarry.PluginMenu.useQ and GetDistance(Target) <= qRange then CastSpell(_Q, Target) end
                if RREADY and AutoCarry.PluginMenu.useR and GetDistance(Target) <= rRange then CastSpell(_R) end
        end
end

--end Combo Function


--Smart KS Function
function SmartKS()
         for i=1, heroManager.iCount do
         local enemy = heroManager:GetHero(i)
                if ValidTarget(enemy) then
                        dfgDmg, hxgDmg, bwcDmg, iDmg  = 0, 0, 0, 0
                        qDmg = getDmg("Q",enemy,myHero)
                        eDmg = getDmg("E",enemy,myHero)
                        wDmg = getDmg("W",enemy,myHero)
                        rDmg = getDmg("R",enemy,myHero)
                        if DFGREADY then dfgDmg = (dfgSlot and getDmg("DFG",enemy,myHero) or 0)        end
            if HXGREADY then hxgDmg = (hxgSlot and getDmg("HXG",enemy,myHero) or 0) end
            if BWCREADY then bwcDmg = (bwcSlot and getDmg("BWC",enemy,myHero) or 0) end
            if IREADY then iDmg = (ignite and getDmg("IGNITE",enemy,myHero) or 0) end
            onspellDmg = (liandrysSlot and getDmg("LIANDRYS",enemy,myHero) or 0)+(blackfireSlot and getDmg("BLACKFIRE",enemy,myHero) or 0)
            itemsDmg = dfgDmg + hxgDmg + bwcDmg + iDmg + onspellDmg
                        if AutoCarry.PluginMenu.ks then
                                if enemy.health <= (qDmg) and GetDistance(enemy) <= qRange and QREADY then
                                        if QREADY then CastSpell(_Q, enemy) end
                                                                                
                                
                               elseif enemy.health <= (qDmg + itemsDmg) and GetDistance(enemy) <= qRange and QREADY then
                                        if DFGREADY then CastSpell(dfgSlot, enemy) end
                                        if HXGREADY then CastSpell(hxgSlot, enemy) end
                                        if BWCREADY then CastSpell(bwcSlot, enemy) end
                                        if BRKREADY then CastSpell(brkSlot, enemy) end
                                        if QREADY then CastSpell(_Q, enemy) end
                                
                                elseif enemy.health <= (eDmg + itemsDmg) and GetDistance(enemy) <= eRange and EREADY then
                                        if DFGREADY then CastSpell(dfgSlot, enemy) end
                                        if HXGREADY then CastSpell(hxgSlot, enemy) end
                                        if BWCREADY then CastSpell(bwcSlot, enemy) end
                                        if BRKREADY then CastSpell(brkSlot, enemy) end
                                        if EREADY then CastSpell(_E, enemy.x, enemy.z) end
                                
                                elseif enemy.health <= (qDmg + eDmg + itemsDmg) and GetDistance(enemy) <= eRange
                                        and EREADY and QREADY then
                                                if DFGREADY then CastSpell(dfgSlot, enemy) end
                                                if HXGREADY then CastSpell(hxgSlot, enemy) end
                                                if BWCREADY then CastSpell(bwcSlot, enemy) end
                                                if BRKREADY then CastSpell(brkSlot, enemy) end
                                                if EREADY and GetDistance(enemy) <= eRange then CastSpell(_E, enemy.x, enemy.z) end
                                                if QREADY then CastSpell(_Q, enemy) end
                                                                                 
                                                                                       
                                end
                        end
                        KillText[i] = 1 
                        if enemy.health <= (qDmg + wDmg + itemsDmg) and QREADY and WREADY then
                                KillText[i] = 2
                        end
                        if enemy.health <= (qDmg + wDmg + eDmg + itemsDmg) and QREADY and WREADY and EREADY then
                                KillText[i] = 3
                        end
                        if enemy.health <= iDmg and GetDistance(enemy) <= 600 then
                                if IREADY then CastSpell(ignite, enemy) end
                        end
                end
        end
end

--Use Cons.
function UseConsumables()
        if not InFountain() and Target ~= nil then
                if AutoCarry.PluginMenu.aHP and myHero.health < (myHero.maxHealth * (AutoCarry.PluginMenu.HPHealth / 100))
                        and not (usingHPot or usingFlask) and (hpReady or fskReady)        then
                                CastSpell((hpSlot or fskSlot)) 
                end
                if AutoCarry.PluginMenu.aMP and myHero.mana < (myHero.maxMana * (AutoCarry.PluginMenu.MinMana / 100))
                        and not (usingMPot or usingFlask) and (mpReady or fskReady) then
                                CastSpell((mpSlot or fskSlot))
                end
        end
end                

--[Low Mana Function by Kain]--
function IsMyManaLow()
    if myHero.mana < (myHero.maxMana * ( AutoCarry.PluginMenu.MinMana / 100)) then
        return true
    else
        return false
    end
end
--[Health Pots Function]--
function NeedHP()
        if myHero.health < (myHero.maxHealth * ( AutoCarry.PluginMenu.HPHealth / 100)) then
                return true
        else
                return false
        end
end
--DRAW
function PluginOnDraw()
        --> Ranges
        if not myHero.dead then
                if WREADY and AutoCarry.PluginMenu.drawW then 
                        DrawCircle(myHero.x, myHero.y, myHero.z, wRange, 0x00FFFF)
                end
                if EREADY and AutoCarry.PluginMenu.drawE then 
                        DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0x00FFFF)
                end
        end
end

function loadMain()
                if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end
                if IsSACReborn then AutoCarry.Skills:DisableAll() end
                Menu = AutoCarry.PluginMenu
                if IsSACReborn then
                AutoCarry.Crosshair:SetSkillCrosshairRange(750)
                else
                AutoCarry.SkillsCrosshair.range = 800
                end
                hpReady, mpReady, fskReady = false, false, false
                HK1, HK2, HK3 = string.byte("Z"), string.byte("G"), string.byte("T")
                qRange, wRange, eRange, rRange = 125, 700, 650, 300
                QBonus = 0
                lastSiphoning = 0
                TextList = {"Harass him!!", "Rape Him!!", "FULL COMBO KILL!"}
                KillText = {}
                waittxt = {} -- prevents UI lags, all credits to Dekaron
                for i=1, heroManager.iCount do waittxt[i] = i*3 end -- All credits to Dekaron
                
                
end

function menuMain()
                AutoCarry.PluginMenu:addParam("sep", "-- Farm Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("qFarm", "Q - Farm ", SCRIPT_PARAM_ONKEYTOGGLE, false, HK1)
                AutoCarry.PluginMenu:addParam("sep1", "-- Combo Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("useW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("useR", "Use (R) in Combo", SCRIPT_PARAM_ONOFF, false)
                AutoCarry.PluginMenu:addParam("AutoUltimate", "Auto (R)", SCRIPT_PARAM_ONKEYTOGGLE, true, HK2)
                AutoCarry.PluginMenu:addParam("MinimumHealth", "Minimum Health % for R", SCRIPT_PARAM_SLICE, 45, 1, 100, 0)
                AutoCarry.PluginMenu:addParam("MinimumEnemies", "Minimum Enemies for R", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
                AutoCarry.PluginMenu:addParam("MinimumRange", "Minimum Range for R", SCRIPT_PARAM_SLICE, 650, 200, 1000, -1)
                AutoCarry.PluginMenu:addParam("sep2", "-- Mixed Mode Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("qHarass", "Use (Q)to Harass", SCRIPT_PARAM_ONOFF, true, HK3)
                AutoCarry.PluginMenu:addParam("sep3", "-- KS Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("ks", "Use Smart Combo KS", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("sep5", "-- Draw Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("qDraw", "Draw (W)", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("qDraw", "Draw (E)", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("DrawTarget", "Draw Target", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("cDraw", "Draw Enemy Text", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("sep6", "-- Misc Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("MinMana", "Minimum Mana for Q Farm %", SCRIPT_PARAM_SLICE, 40, 0, 100, 2)  
                AutoCarry.PluginMenu:addParam("aHP", "Auto Health Pots", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("rHealth", "Auto R - Min Health(%)", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
                AutoCarry.PluginMenu:addParam("aMP", "Auto Auto Mana Pots", SCRIPT_PARAM_ONOFF, true) 
                AutoCarry.PluginMenu:addParam("HPHealth", "Min % for Health Pots", SCRIPT_PARAM_SLICE, 50, 0, 100, 2)
                AutoCarry.PluginMenu:addParam("sep7", "-- Jungle Clear Options --", SCRIPT_PARAM_INFO, "")
                AutoCarry.PluginMenu:addParam("JungleQ", "Jungle with (Q)", SCRIPT_PARAM_ONOFF, true)
                AutoCarry.PluginMenu:addParam("JungleE", "Jungle With (E)", SCRIPT_PARAM_ONOFF, true)
                
                end
 
 --[Certain Checks]--
function Checks()
        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
        elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2 end
        if IsSACReborn then Target = AutoCarry.Crosshair:GetTarget() else Target = AutoCarry.GetAttackTarget() end
        dfgSlot, hxgSlot, bwcSlot = GetInventorySlotItem(3128), GetInventorySlotItem(3146), GetInventorySlotItem(3144)
        brkSlot = GetInventorySlotItem(3092),GetInventorySlotItem(3143),GetInventorySlotItem(3153)
        znaSlot, wgtSlot = GetInventorySlotItem(3157),GetInventorySlotItem(3090)
        hpSlot, mpSlot, fskSlot = GetInventorySlotItem(2003),GetInventorySlotItem(2004),GetInventorySlotItem(2041)
        QREADY = (myHero:CanUseSpell(_Q) == READY)
        WREADY = (myHero:CanUseSpell(_W) == READY)
        EREADY = (myHero:CanUseSpell(_E) == READY)
        RREADY = (myHero:CanUseSpell(_R) == READY)
        DFGREADY = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
        HXGREADY = (hxgSlot ~= nil and myHero:CanUseSpell(hxgSlot) == READY)
        BWCREADY = (bwcSlot ~= nil and myHero:CanUseSpell(bwcSlot) == READY)
        BRKREADY = (brkSlot ~= nil and myHero:CanUseSpell(brkSlot) == READY)
        ZNAREADY = (znaSlot ~= nil and myHero:CanUseSpell(znaSlot) == READY)
        WGTREADY = (wgtSlot ~= nil and myHero:CanUseSpell(wgtSlot) == READY)
        IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
        HPREADY = (hpSlot ~= nil and myHero:CanUseSpell(hpSlot) == READY)
        MPREADY =(mpSlot ~= nil and myHero:CanUseSpell(mpSlot) == READY)
        FSKREADY = (fskSlot ~= nil and myHero:CanUseSpell(fskSlot) == READY)
end
                 


--UPDATEURL=
--HASH=60392DA2ABE04E07137CA7F6D69EA841
