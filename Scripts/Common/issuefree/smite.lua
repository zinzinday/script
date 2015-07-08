require "issuefree/timCommon"

local smite = {range=750, base=0}
local smiteDam = {390,410,430,450,480,510,540,570,600,640,680,720,760,800,850,900,950,1000}
local smiteTargets = {}

local smiteSpells = {"summonersmite", "itemsmiteaoe", "s5_summonersmitequick"}

if ListContains(GetSpellInfo("D").name, smiteSpells) then
   smite.key = "D"
   spells["smite"] = smite
elseif ListContains(GetSpellInfo("F").name, smiteSpells) then
   smite.key = "F"
   spells["smite"] = smite
end

function smiteTick()
   spells["smite"].base = smiteDam[me.level]
   if not ModuleConfig.smite then
      return
   end
   for i,target in rpairs(smiteTargets) do
      if not target or not target.valid then
         table.remove(smiteTargets,i)
      end
   end

   if CanUse("smite") then
      for _,target in ipairs(smiteTargets) do
         if GetDistance(target) < smite.range+50 and WillKill("smite", target) then
            CastSpellTarget(smite.key, target)
            PrintAction("SMITE", target, 1)
            break 
         end
      end
   end
end

function onCreateSmite(obj)
   if not obj.charName then return end
   if IsBigMinion(obj) then
      table.insert(smiteTargets, obj)
   elseif IsBigCreep(obj) then
      table.insert(smiteTargets, obj)
   elseif IsMajorCreep(obj) then
      table.insert(smiteTargets, obj)
   end
end 

if spells["smite"] then
   AddOnTick(smiteTick)
   AddOnCreate(onCreateSmite)
end
