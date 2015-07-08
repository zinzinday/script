require "issuefree/basicUtils"

-- object arrays
MINIONS = {}
MYMINIONS = {}

CREEPS = {} -- all creeps
MINORCREEPS = {} -- minor creeps (little wolves, lizards)
BIGCREEPS = {} -- Big wolf and big wraith and big golem
MAJORCREEPS = {}

DRAGON = {}
BARON = {}

TURRETS = {}
MYTURRETS = {}

INHIBS = {}
MYINHIBS = {}
NEXUS = {}
MYNEXUS = {}

WARDS = {}

ALLIES = {}
ENEMIES = {}

PETS = {}  -- heimer turrets, yorrick ghouls etc. Nothing exists in here yet
MYPETS = {}
-- simple attempt to grab high priority targets
ADC = nil
APC = nil

EADC = nil
EAPC = nil

CURSOR = nil
function ClearCursor()
   CURSOR = nil
end

WK_AA_TARGET = nil

-- persisted particles
P = {}
pOn = {}
PData = {}

-- name field
MinorCreepNames = {
   "SRU_MurkwolfMini", 
   "SRU_RedMini", 
   "SRU_BlueMini", 
   "SRU_BlueMini2", 
   "SRU_RazorbeakMini",
   "SRU_KrugMini",
   "Sru_Crab"
}
BigCreepNames = {
   "SRU_Murkwolf", 
   "SRU_Krug",
   "SRU_Razorbeak",
   "SRU_Gromp"
}
MajorCreepNames = {
   "SRU_Blue", 
   "SRU_Red",
   "SRU_Dragon",
   "SRU_Baron"
}

CreepNames = concat(MinorCreepNames, BigCreepNames, MajorCreepNames)

-- stuns roots fears taunts?
ccNames = {
   "Ahri_Charm_buf", 
   "Amumu_SadRobot_Ultwrap", 
   "Amumu_Ultwrap", 
   "CurseBandages",
   "DarkBinding_tar", 
   "Morgana_Skin06_Q_Tar.troy",
   "caitlyn_Base_yordleTrap_impact_debuf",
   "Global_Fear", 
   "Global_Taunt", 
   -- "leBlanc_shackle", 
   "LOC_Stun",
   "LOC_Suppress",
   -- "LOC_Taunt",
   "LuxLightBinding_tar.troy",
   "maokai_elementalAdvance_root_01", 
   "monkey_king_ult_unit_tar_02",
   "xenZiou_ChainAttack_03",
   "RengarEMax",
   "RunePrison",
   "Stun_glb", 
   "summoner_banish", 
   "tempkarma_spiritbindroot",
   "VarusRHitFlash",
   "Vi_R_land",
   "Zyra_E_sequence_root",

   -- self inflicted ccs
   "pantheon_heartseeker_cas2",
   "Katarina_deathLotus_cas",
   "drain.troy",
   "ReapTheWhirlwind_green_cas",
   "missFortune_ult_cas",
   "AbsoluteZero2",
   "InfiniteDuress_tar",
   "Xerath_Base_R_buf"
}


-- find an object and persist it
function Persist(label, object, name, team)
   if team and object.team ~= team then
      return
   end
   if object and (not name or find(object.name, name)) then
      P[label] = object
      PData[label] = {}
      PData[label].name = object.name
      return true
   end
end

function PersistTemp(label, ttl)
   if P[label] then
      if PData[label].timeout then
         PData[label].timeout = time() + ttl
      end
   else
      P[label] = {valid=true}
      PData[label] = {}
      PData[label].timeout = time() + ttl
   end
   return P[label]
end

function IsTemp(label)
   assert(type(label) == "string")
   if PData[label] and PData[label].timeout then
      return true
   end
   return false
end

function enemyHasName(name)
   for _,enemy in ipairs(ENEMIES) do
      if enemy.name == name then
         return true
      end
   end
end

function PersistToTrack(object, name, champName, spellName)
   if Persist(spellName, object, name) then

      -- if the champ that can cast the spell isn't on the other team bail
      if not enemyHasName(champName) then
         return
      end

      -- check if it's an ally casting the spell
      -- if the object comes into creation very close to a character on my team with the right name...
      for _,ally in ipairs(ALLIES) do
         if ally.charName == champName then
            if GetDistance(ally, object) < 200 then
               return
            end
         end
      end
      PData[spellName].startPoint = Point(object)
      PData[spellName].type = "trackedSpell"
      PData[spellName].champName = champName
      PData[spellName].spellName = spellName      
   end
end

function PersistPet(object, charName, name)
   if find(object.charName, charName) or find(object.name, name) then
      if object.team == me.team then
         -- pp("Persist my pet "..object.name)
         return PersistAll("MYPET", object)
      else
         -- pp("Persist enemy pet "..object.name)
         return PersistAll("PET", object)
      end
   end   
end

function PersistAll(label, object, name)
   if object and (not name or find(object.name, name)) then      
      Persist(label..object.name..object.x, object)
      PData[label..object.name..object.x].name = label
      PData[label..object.name..object.x].time = time()
      return true
   end
end

function GetPersisted(name)
   local persisted = {}
   for pKey,data in pairs(PData) do
      if data.name == name then
         table.insert(persisted, P[pKey])
      end
   end
   return persisted
end

-- find an object only near me and persist it
function PersistBuff(label, object, name, dist, exact)
   if not dist then
      dist = 150
   end
   if object and find(object.name, name, exact) then
      if GetDistance(object) < dist then
         P[label] = object
         PData[label] = {}
         PData[label].name = object.name
         -- pp("Persisting "..object.name.." as "..label)
         return true
      elseif GetDistance(object) < 500 then
         -- pp("Found "..label.." at distance "..math.floor(GetDistance(object)))
      end
   end
   return false
end

function PersistOnTargets(label, object, name, ...)
   if object and find(object.name, name) then
      local target = SortByDistance(GetInRange(object, 150, concat(...)), object)[1]
      if target then
         if not pOn[label] then
            pOn[label] = {}
         end
         Persist(label..target.name, object)
         PData[label..target.name].unit = target
         PData[label..target.name].time = time()
         table.insert(pOn[label], label..target.name)
         -- pp("Persisting "..name.." on "..target.charName.." as "..label..target.name)
         return target
      end
   end
   return false
end

-- check if a given target has the named buff
function HasBuff(buffName, target)
   target = target or me
   if not pOn[buffName] then return false end
   for _,pKey in ipairs(pOn[buffName]) do
      local pd = PData[pKey]
      if pd and SameUnit(pd.unit, target) then
         return true
      end
   end
   return false
end

function GetWithBuff(buffName, ...)
   return FilterList(concat(...),
      function(item)
         return HasBuff(buffName, item)
      end
   )
end

function GetTrackedSpells()
   local ts = {}
   for pName,obj in pairs(P) do
      if PData[pName].type == "trackedSpell" then
         table.insert(ts, pName)
      end
   end
   return ts
end

function CleanPersistedObjects()
   for name,obj in pairs(P) do
      if not obj or 
         not obj.valid or
         not obj.name == PData[name].name
      then
         -- pp("Clean "..name)
         P[name] = nil
         PData[name] = nil
      end
   end
   for name, data in pairs(PData) do

      if data.timeout and data.timeout < time() then
         P[name] = nil
         PData[name] = nil
      end

      if not P[name] then
         PData[name] = nil
      end
   end
   for name,pList in pairs(pOn) do
      for i,pKey in rpairs(pList) do
         if not P[pKey] then
            table.remove(pList, i)
         end
      end
   end
end

function Clean(list, field, value)
   for i, obj in rpairs(list) do
      if field and value then
         if type(value) == number then
            if obj[field] ~= value then
               table.remove(list, i)
            end
         elseif not find(obj[field], value) then
            table.remove(list,i)
         end
      elseif not obj or not obj.x or not obj.z then
         table.remove(list,i)
      end
   end
end

local function updateMinions()
   for i,minion in rpairs(MINIONS) do
      if not minion or
         not minion.valid or
         not find(minion.charName, "Minion") 
      then
         table.remove(MINIONS,i)
      end
   end
   for i,minion in rpairs(MYMINIONS) do
      if not minion or
         not minion.valid or
         not find(minion.charName, "Minion") 
      then
         table.remove(MYMINIONS,i)
      end
   end
end

local function updateTrackedSpells()
   for pName,obj in pairs(P) do
      if PData[pName].type == "trackedSpell" then
         if PData[pName].lastPos then
            PData[pName].direction = AngleBetween(PData[pName].lastPos, Point(P[pName]))
            -- DrawLine(P[pName].x,P[pName].y,P[pName].z, 1000, 0, PData[pName].direction, 100)
         end
         PData[pName].lastPos = Point(P[pName])
      end
   end
end

local function cleanCreeps(list, names)
   for i,unit in rpairs(list) do
      if not unit or not unit.valid
         -- unit.dead or
         -- unit.x == nil or 
         -- unit.y == nil or
         -- not ListContains(unit.name, names)
      then
         table.remove(list,i)
      end
   end
end

local function updateCreeps()
   cleanCreeps(CREEPS, CreepNames)
   cleanCreeps(MINORCREEPS, MinorCreepNames)
   cleanCreeps(BIGCREEPS, BigCreepNames)
   cleanCreeps(MAJORCREEPS, MajorCreepNames)
end

local function updateHeroes()
   ALLIES = ValidTargets(GetAllyHeroes())
   table.insert(ALLIES, me)
   ENEMIES = ValidTargets(GetEnemyHeroes())
   ADC = nil
   APC = nil
   EADC = nil
   EAPC = nil

   ADC = getADC(ALLIES)
   APC = getAPC(ALLIES)

   EADC = getADC(ENEMIES)
   EAPC = getAPC(ENEMIES)

   if ADC then
      Text("ADC:"..ADC.charName, 10, 880, 0xFF00FF00)
   end
   if APC then
      Text("APC:"..APC.charName, 10, 895, 0xFF00FF00)
   end
   if EADC then
      Text("ADC:"..EADC.charName, 150, 880, 0xFFFF0000)
   end
   if EAPC then
      Text("APC:"..EAPC.charName, 150, 895, 0xFFFF0000)
   end
end

function IsMinorCreep(creep)
   if ListContains(creep.charName, MinorCreepNames, true) then
      return true
   end
end
function IsBigCreep(creep)
   if ListContains(creep.charName, BigCreepNames, true) then
      return true
   end
end
function IsMajorCreep(creep)
   if ListContains(creep.charName, MajorCreepNames, true) then
      return true
   end
end   
function IsCreep(creep)
   return creep.team == 300
end   


function createForPersist(object)
   local gotObj = false

   if IsMinorCreep(object) then
      table.insert(MINORCREEPS, object)
      table.insert(CREEPS, object)
      gotObj = true
   end
   if IsBigCreep(object) then
      table.insert(BIGCREEPS, object)
      table.insert(CREEPS, object)
      gotObj = true
   end
   if IsMajorCreep(object) then
      table.insert(MAJORCREEPS, object)
      table.insert(CREEPS, object)
      gotObj = true
      if object.name == "Dragon" then
         Persist("DRAGON", object)
      end
      if object.name == "Worm" then
         Persist("BARON", object)
      end
   end

   if gotObj then
      return
   end

   if object.team ~= me.team then
      if PersistAll("TURRET", object, "Turret_T") then
         return 
      end
   else
      if PersistAll("MYTURRET", object, "Turret_T") then
         return 
      end
   end

   if find(object.type, "Barracks") then
      if object.team == me.team then
         table.insert(MYINHIBS, object)
         return 
      else
         table.insert(INHIBS, object)
         return 
      end
   end
   
   if PersistAll("destroyed", object, "DestroyedBuilding") then
      gotObj = true
   end
   if PersistAll("destroyed", object, "Dest_") then
      gotObj = true
   end

   if gotObj then
      return
   end

   if find(object.name, nexusKey) then
      if find(object.name, "order") then
         if me.team == 100 then
            table.insert(MYNEXUS, object)
            return 
         else
            table.insert(NEXUS, object)
            return 
         end
      else
         if me.team == 100 then
            table.insert(NEXUS, object)
            return 
         else
            table.insert(MYNEXUS, object)
            return 
         end
      end
   end

   if gotObj then
      return
   end

   if PersistOnTargets("recall", object, "TeleportHome", ENEMIES, ALLIES) then
      return 
   end

   if find(object.name, "Ward") then
      table.insert(WARDS, object)
      return 
   end

   if PersistToTrack(object, "Ashe_Base_R_mis", "Ashe", "EnchantedCrystalArrow") or
      PersistToTrack(object, "HowlingGale_mis", "Janna", "HowlingGale") or
      PersistToTrack(object, "Ezreal_TrueShot_mis", "Ezreal", "EzrealTrueshotBarrage") 
   then
      return 
   end

   if ListContains(object.name, ccNames) then
      local target = PersistOnTargets("cc", object, object.name, ENEMIES, ALLIES)
      if target then
         pp("CC on "..target.charName.." "..object.name)
         return 
      end
   end

   --sheen / trinity
   if PersistBuff("enrage", object, "enrage_buf", 100) or
   --lich bane
      PersistBuff("lichbane", object, "purplehands_buf", 100) or
   --iceborn gauntlet
      PersistBuff("iceborn", object, "bluehands_buf", 100) or
      PersistOnTargets("hemoplague", object, "Vladimir_Base_R_debuff.troy", ENEMIES) or
      PersistBuff("blind", object, "Global_miss.troy") or
      PersistBuff("silence", object, "LOC_Silence.troy") or
      PersistBuff("muramana", object, "ItemMuramanaToggle") or
      PersistBuff("manaPotion", object, "Global_Item_Mana") or
      PersistBuff("healthPotion", object, "Global_Item_Health")
   then
      return 
   end

   for _,spell in pairs(spells) do
      if spell.modAA and spell.object then
         if PersistBuff(spell.modAA, object, spell.object, 200) then
            return 
         end
      end
   end


   if PersistOnTargets("invulnerable", object, "eyeforaneye", ENEMIES) or -- kayle intervention
      PersistOnTargets("invulnerable", object, "nickoftime", ENEMIES) or -- zilean chronoshift
      PersistOnTargets("invulnerable", object, "UndyingRage_buf", ENEMIES) or -- trynd ult
      PersistOnTargets("invulnerable", object, "VladSanguinePool_buf", ENEMIES) -- vlad sanguine pool
   then
      return 
   end

   if PersistOnTargets("invulnerable", object, "zhonya_ring_self_skin.troy", ENEMIES, ALLIES) then -- zhonya's hourglass
      pp("zhonyas activated")
   end
   if find(object.name, "zhonya") then
      pp(object.name)
   end

   if find(object.name, "Karthus_Base_P_Avatar") then
      for _,target in ipairs(ENEMIES) do
         if find(target.charName, "Karthus") then
            Persist("invulnerable"..target.name, object)
            PData["invulnerable"..target.name].unit = target
            PData["invulnerable"..target.name].time = time()
            if not pOn["invulnerable"] then
               pOn["invulnerable"] = {}
            end
            table.insert(pOn["invulnerable"], "invulnerable"..target.name)
            return 
         end
      end
   end

   -- if I am the target of diplomatic immunity don't bother recording diplomatic immunity
   PersistBuff("diplomaticImmunityTarget", object, "DiplomaticImmunity_tar")
   if not P.diplomaticImmunityTarget then
      PersistOnTargets("invulnerable", object, "DiplomaticImmunity_buf", ENEMIES) -- poppy diplomatic immunity
   end

   if PersistOnTargets("bansheesVeil", object, "bansheesveil_buf", ENEMIES) then
      return
   end

   if PersistOnTargets("spellImmune", object, "Sivir_Base_E_shield", ENEMIES) or
      PersistOnTargets("spellImmune", object, "nocturne_shroudofDarkness_shield", ENEMIES)
   then
      return
   end


   -- PETS
   -- zyra
   if PersistPet(object, nil, "ZyraThornPlant") or
      PersistPet(object, nil, "ZyraGraspingPlant") or
      
      -- malzahar
      PersistPet(object, "Voidling") or
      
      -- yorick
      PersistPet(object, "Inky") or
      PersistPet(object, "Blinky") or
      PersistPet(object, "Clyde") or

      -- heimerdinger
      PersistPet(object, "H-28G Evolution Turret") or

      -- leblanc
      PersistPet(object, "LeblancImage")
   then
      return
   end
   
   if object.type == "obj_AI_Minion" then
      for _,hero in ipairs(concat(ENEMIES, ALLIES, me)) do
         if object.charName == hero.charName then
            PersistPet(object, object.charName)
            return
         end
      end
   end

   -- morde (-- hard to test)

   -- shaco
   if PersistPet(object, "Jack In The Box") then
      return
   end
   if object.type == "obj_AI_Minion" and P.shacoClone then
      if PersistPet(object, P.shacoClone.charName) then
         return
      end
   end

end

function persistTick()
   Clean(WARDS, "name", "Ward")
   CleanPersistedObjects()


   -- updateMinions()
   MINIONS = ValidTargets(minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC).objects)
   MYMINIONS = ValidTargets(minionManager(MINION_ALLY, 2000, me).objects)
   updateCreeps()
   updateHeroes()
   updateTrackedSpells()


   TURRETS = FilterList(ValidTargets(GetPersisted("TURRET")), 
      function(item) 
         return item.health > 0 and
                item.type == "obj_AI_Turret"
      end
   )
   MYTURRETS = FilterList(ValidTargets(GetPersisted("MYTURRET")), 
      function(item) 
         return item.health > 0 and
                item.type == "obj_AI_Turret"
      end
   )

   INHIBS = FilterList(INHIBS, function(item) return item.health > 0 end)
   MYINHIBS = FilterList(MYINHIBS, function(item) return item.health > 0 end)

   PETS = GetPersisted("PET")
   MYPETS = GetPersisted("MYPET")
end

function getADC(list)
   local value = 0
   local adc
   for i,test in ipairs(list) do
      local tValue = test.addDamage + (test.armorPen + test.armorPenPercent)*5 + test.attackSpeed*10    
      if tValue > value then
         value = tValue
         adc = test
      end
   end
   return adc
end

function getAPC(list)
   local value = 0
   local apc
   for i,test in ipairs(list) do
      local tValue = test.ap + (test.magicPen + test.magicPenPercent)*5    
      if tValue > value then
         value = tValue
         apc = test
      end
   end
   return apc
end

AddOnTick(persistTick)