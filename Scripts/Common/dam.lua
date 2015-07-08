-----------------------------------------------------------------------------
--  ADVANCED DAMAGE LIBRARY v1.0.2 mod 2
--  mod by weee
--  Calculates the damage the player will do against a given target.
--  Written by heist
--  Modified by Keoshin to work with BoL scripting API
--
--  Changelog:
--    v1.0
--      Initial Release
--    v1.0.1
--      Update champion numbers for patch (Ryze)
--    v1.0.2
--      Fix Ryze mana scaling
--
--  Todo List:
--    Add support for more champions
--    Check for debuffs on the target (like Leona's passive)
--    Track Nasus' Q damage
--    Add Sheen, Tri-Force and Lich Bane support
--    Maybe add attack tracking for Orianna and Warwick (since their damage
--      ramps up on the same target)
--
-----------------------------------------------------------------------------
--  Usage                 How to use
-----------------------------------------------------------------------------
--  DamageLibrary:Damage()
--    Needs to be called before DamageLibrary:CalcDamage() but doesn't need
--      to be called for each target. If you're going to loop through a table
--      of targets call this once before doing so.
--    It accepts a table as an argument with some preferences as key-value
--      pairs. The table is optional and if it isn't provided or a key is
--      missing it falls back on a default value.
--    key               description                           default
--    use_aa            [Boolean] Calc for auto-attacks?      true
--    use_ability       [Boolean] Calc for abilities?         true
--    use_onhit         [Boolean] Check for onhit items?      true
--    use_masteries     [Boolean] Calc for masteries?         false
--    butcherpoints     [Number] How many points in Butcher?  0
--    havocpoints       [Number] How many points in Havoc?    0
--    use_executioner   [Boolean] Calc for Executioner?       false
--    is_minion         [Boolean] Is the target a minion?     true
--  Example:
--    prefs = {
--      use_ability = false,
--      use_masteries = true,
--      butcherpoints = 2,
--      havocpoints = 3,
--      use_executioner = true
--    }
--    DamageLibrary:Damage(prefs)
-----------------------------------------------------------------------------
--  DamageLibrary:CalcDamage(target)
--    Needs to be called for each target and returns a table with our damage
--      in it.
--  Example:
--    dmg = DamageLibrary:CalcDamage(target)
--    PrintChat("Gonna do "..dmg.damage.." damage to "..target.name)
--    if dmg.abilitydamage > 0 then
--      PrintChat("Ability will do "..dmg.abilitydamage.." damage to "..target.name)
--    end
-----------------------------------------------------------------------------

DamageLibrary = {}

local Champ = {}
local player = GetMyHero()

-----------------------------------------------------------------------------
--  Default       All default values and functions.
-----------------------------------------------------------------------------

local Default = {}

Default.use_calcdamage = false
Default.use_ability = false
Default.use_calcability = false
Default.use_abilityonhit = false

function Default:AddDamage(argtable)
  ---------------------------------------------------------------------------
  --  Saves our damage variables to a table to be evaluated against targets.
  --  param self          [Table] The table the function is called from.
  --  param argtable      [Table] Table of arguments.
  --    .reset            [Boolean] Do we reset the table? [Default = false]
  --    .pdmg             [Number] Physical damage to add. [Default = 0]
  --    .mdmg             [Number] Magical damage to add. [Default = 0]
  --    .tdmg             [Number] True damage to add. [Default = 0]
  --    .is_ability       [Boolean] Is this an ability? [Default = false]
  ---------------------------------------------------------------------------
  local x, savedvalues
  if argtable.is_ability then
    x = "asv"
  else
    x = "sv"
  end
  argtable.pdmg = argtable.pdmg or 0
  argtable.mdmg = argtable.mdmg or 0
  argtable.tdmg = argtable.tdmg or 0
  if argtable.reset or type(self[x]) ~= "table" then
    savedvalues = {
      pdmg = argtable.pdmg,
      mdmg = argtable.mdmg,
      tdmg = argtable.tdmg
    }
  else
    savedvalues = {
      pdmg = self[x].pdmg + argtable.pdmg,
      mdmg = self[x].mdmg + argtable.mdmg,
      tdmg = self[x].tdmg + argtable.tdmg
    }
  end
  self[x] = savedvalues
end

function Default:Damage()
  self:AddDamage({reset = true, pdmg = player.totalDamage})
end

function Default.BuffCheck(buffname)
  ---------------------------------------------------------------------------
  --  Checks for a buff on player.
  --  params buffname     [String] Name of the buff to check for.
  --  return              [Boolean] Did we find that buff?
  ---------------------------------------------------------------------------
  local count = player.buffCount

  return false
end

Champ.Default = Default

-----------------------------------------------------------------------------
--  Ahri      [Ability] E + Q + W (2 hits) + R (2 hits) depends on which spell is currently ready
-----------------------------------------------------------------------------

local Ahri = {}

Ahri.use_ability = true
Ahri.base =         { [0] = 15,     [1] = 10,   [2] = 30,     [3] = 60 }
Ahri.basescale =    { [0] = 25,     [1] = 30,   [2] = 30,     [3] = 40 }
Ahri.apratio =      { [0] = 0.33,   [1] = 0.38, [2] = 0.35,   [3] = 0.3 }

function Ahri:AbilityDamage()
  if GetSpellData(_Q).level > 0 or GetSpellData(_W).level > 0 or GetSpellData(_R).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = 0
    dmg.tdmg = 0
    if GetSpellData(_Q).level > 0 and player:GetSpellState(_Q) ~= STATE_COOLDOWN then
        dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_Q).level * self.basescale[0] + self.base[0] + player.ap * self.apratio[0])
        dmg.tdmg = dmg.tdmg + math.floor(GetSpellData(_Q).level * self.basescale[0] + self.base[0] + player.ap * self.apratio[0])
    end
    if GetSpellData(_W).level > 0 and player:GetSpellState(_W) ~= STATE_COOLDOWN then dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_W).level * self.basescale[1] + self.base[1] + player.ap * self.apratio[1]) * 1.5 end
    if GetSpellData(_E).level > 0 and player:GetSpellState(_E) ~= STATE_COOLDOWN then dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_E).level * self.basescale[2] + self.base[2] + player.ap * self.apratio[2]) end
    if GetSpellData(_R).level > 0 and player:GetSpellState(_R) ~= STATE_COOLDOWN then dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_R).level * self.basescale[3] + self.base[3] + player.ap * self.apratio[3]) * 2 end
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Ahri = Ahri

-----------------------------------------------------------------------------
--  Akali         [AA] Discipline of Force (passive)
-----------------------------------------------------------------------------

local Akali = {}

Akali.requiredap = 20
Akali.initialbonuspercent = 8
Akali.apformorebonuspercent = 6

function Akali:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if player.ap >= self.requiredap then
    dmg.mdmg = math.floor(player.totalDamage * (math.floor((player.ap - self.requiredap) / self.apformorebonuspercent) + self.initialbonuspercent) / 100)
  end
  self:AddDamage(dmg)
end

Champ.Akali = Akali

-----------------------------------------------------------------------------
--  Annie         [Ability] Disintegrate (Q)
-----------------------------------------------------------------------------

local Annie = {}

Annie.use_ability = true  
Annie.base = 45
Annie.basescale = 40
Annie.apratio = 0.7

function Annie:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.basescale + self.base + player.ap * self.apratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Annie = Annie

-----------------------------------------------------------------------------
--  Caitlyn       [AA] Headshot (passive)
-----------------------------------------------------------------------------

local Caitlyn = {}

Caitlyn.passivebonus = 1.5
Caitlyn.buffname = "caitlynheadshot"

function Caitlyn:Damage()
  local dmg = { reset = true }
  dmg.pdmg = player.totalDamage * (self.BuffCheck(self.buffname) and self.passivebonus or 1)
  self:AddDamage(dmg)
end

Champ.Caitlyn = Caitlyn

-----------------------------------------------------------------------------
--  Chogath       [AA] Vorpal Spikes (E active)
-----------------------------------------------------------------------------

local Chogath = {}

Chogath.base = 5
Chogath.basescale = 15
Chogath.apratio = 0.3
Chogath.buffname = "vorpalspikes"

function Chogath:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = math.floor(GetSpellData(_E).level * self.basescale + self.base + player.ap * self.apratio)
  end
  self:AddDamage(dmg)
end

Champ.Chogath = Chogath

-----------------------------------------------------------------------------
--  Corki         [AA] Hextech Shrapnel Shells (passive)
-----------------------------------------------------------------------------

local Corki = {}

Corki.passivebonus = 0.10

function Corki:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  dmg.tdmg = player.totalDamage * self.passivebonus
  self:AddDamage(dmg)
end

Champ.Corki = Corki

-----------------------------------------------------------------------------
--  Fizz          [AA] Seastone Trident (W active)
-----------------------------------------------------------------------------

local Fizz = {}

Fizz.base = 5
Fizz.basescale = 5
Fizz.apratio = 0.35
Fizz.buffname = "fizzseastonepassive"

function Fizz:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = GetSpellData(_W).level * self.basescale + self.base + player.ap * self.apratio
  end
  self:AddDamage(dmg)
end

Champ.Fizz = Fizz

-----------------------------------------------------------------------------
--  Gangplank     [Ability] Parrrley (Q)
-----------------------------------------------------------------------------

local Gangplank = {}

Gangplank.use_ability = true
Gangplank.use_abilityonhit = true
Gangplank.base = -5
Gangplank.basescale = 25

function Gangplank:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true}
    dmg.pdmg = math.floor(GetSpellData(_Q).level * self.basescale + self.base + player.totalDamage)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Gangplank = Gangplank

-----------------------------------------------------------------------------
--  Irelia        [AA] Hiten Style (W active)
--                [Ability] Bladesurge (Q) & Hiten Style (W active)
-----------------------------------------------------------------------------

local Irelia = {}

Irelia.base = 0
Irelia.basescale = 15
Irelia.buffname = "ireliahitenstylecharged"
Irelia.use_ability = true
Irelia.use_abilityonhit = true
Irelia.abilitybase = -10
Irelia.abilitybasescale = 30

function Irelia:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  self.hasbuff = self.BuffCheck(self.buffname)
  if self.hasbuff then
    dmg.tdmg = GetSpellData(_W).level * self.basescale + self.base
  end
  self:AddDamage(dmg)
end

function Irelia:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.pdmg = math.floor(GetSpellData(_Q).level * self.abilitybasescale + self.abilitybase + player.totalDamage)
    if self.hasbuff then
      dmg.tdmg = GetSpellData(_W).level * self.basescale + self.base
    end
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Irelia = Irelia

-----------------------------------------------------------------------------
--  Karthus       [Ability] Lay Waste (Q)
-----------------------------------------------------------------------------

local Karthus = {}

Karthus.use_ability = true
Karthus.base = 20
Karthus.basescale = 20
Karthus.apratio = 0.3
Karthus.singletargetmultiplier = 2

function Karthus:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor((GetSpellData(_Q).level * self.basescale + self.base + player.ap * self.apratio) * self.singletargetmultiplier)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Karthus = Karthus

-----------------------------------------------------------------------------
--  Kassadin      [AA] Nether Blade (W active)
--                [Ability] Null Sphere (Q)
-----------------------------------------------------------------------------

local Kassadin = {}

Kassadin.base = 15
Kassadin.basescale = 15
Kassadin.apratio = 0.15
Kassadin.buffname = "netherbladebuff"
Kassadin.use_ability = true
Kassadin.abilitybase = 30
Kassadin.abilitybasescale = 50
Kassadin.abilityapratio = 0.7

function Kassadin:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = math.floor(GetSpellData(_W).level * self.basescale + self.base + player.ap * self.apratio)
  end
  self:AddDamage(dmg)
end

function Kassadin:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.abilitybasescale + self.abilitybase + player.ap * self.abilityapratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Kassadin = Kassadin

-----------------------------------------------------------------------------
--  Katarina      [AA] Killer Instincts (W passive)
--                [Ability] Bouncing Blade (Q) & Killer Instincts (W passive)
-----------------------------------------------------------------------------

local Katarina = {}

Katarina.base = 4
Katarina.basescale = 4
Katarina.use_ability = true
Katarina.abilitybase = 25
Katarina.abilitybasescale = 35
Katarina.abilitybonusadratio = 0.8
Katarina.abilityapratio = 0.35
Katarina.killerinstincts = 0

function Katarina:Damage()
  local dmg = { reset = true }
  if GetSpellData(_W).level > 0 then
    self.killerinstincts = math.floor(GetSpellData(_W).level * self.basescale + self.base)
    dmg.pdmg = player.totalDamage + self.killerinstincts
  else
    dmg.pdmg = player.totalDamage
  end
  self:AddDamage(dmg)
end

function Katarina:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.abilitybasescale + self.abilitybase + player.addDamage * self.abilitybonusadratio + player.ap * self.abilityapratio + self.killerinstincts)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Katarina = Katarina

-----------------------------------------------------------------------------
--  Kennen        [AA] Electrical Surge (W passive)
-----------------------------------------------------------------------------

local Kennen = {}

Kennen.adratiobase = 0.3
Kennen.adratiobasescale = 0.1
Kennen.buffname = "kennendoublestrikelive"

function Kennen:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = math.floor(player.totalDamage * (self.adratiobase + GetSpellData(_W).level * self.adratiobasescale))
  end
  self:AddDamage(dmg)
end

Champ.Kennen = Kennen

-----------------------------------------------------------------------------
--  KogMaw        [AA] Bio-Arcane Barrage (W active)
-----------------------------------------------------------------------------

local KogMaw = {}

KogMaw.base = 1
KogMaw.basescale = 1
KogMaw.apratio = 0.01
KogMaw.minioncap = 100
KogMaw.kognormalrange = 500

function KogMaw:Damage()
  if player.range > self.kognormalrange then
    self.use_calcdamage = true
  else
    self.use_calcdamage = false
  end
  self:AddDamage({reset = true, pdmg = player.totalDamage})
end

function KogMaw:CalcDamage(target, is_minion)
  ---------------------------------------------------------------------------
  --  Calculates Kog'Maw's Bio-Arcane Barrage damage.
  --  params self         [Table] The table it's called from.
  --  params target       [Table] The target we're calculating the damage
  --                        against.
  --  params is_minion    [Boolean] Is the target a minion?
  --  return              [Number] The damage.
  ---------------------------------------------------------------------------
  local dmg = 0
  dmg = math.min(player:CalcMagicDamage(target, math.floor(target.maxHealth * (GetSpellData(_W).level * self.basescale + self.base + player.ap * self.apratio) / 100)), is_minion and self.minioncap or 10000)
  return dmg
end

Champ.KogMaw = KogMaw

-----------------------------------------------------------------------------
--  Morgana        [Ability] Q + W (2/5 ticks) + R (2 ticks) depends on which spell is currently ready
-----------------------------------------------------------------------------

local Morgana = {}

Morgana.use_ability = true
Morgana.base = { [0] = 25, [1] = 10, [3] = 100 }
Morgana.basescale = { [0] = 55, [1] = 15, [3] = 75 }
Morgana.apratio = { [0] = 0.9, [1] = 0.2, [3] = 0.7 }

function Morgana:AbilityDamage()
  if GetSpellData(_Q).level > 0 or GetSpellData(_W).level > 0 or GetSpellData(_R).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = 0
    if GetSpellData(_Q).level > 0 and player:GetSpellState(_Q) ~= STATE_COOLDOWN then dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_Q).level * self.basescale[0] + self.base[0] + player.ap * self.apratio[0]) end
    if GetSpellData(_W).level > 0 and player:GetSpellState(_W) ~= STATE_COOLDOWN then dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_W).level * self.basescale[1] + self.base[1] + player.ap * self.apratio[1]) * 2 end
    if GetSpellData(_R).level > 0 and player:GetSpellState(_R) ~= STATE_COOLDOWN then dmg.mdmg = dmg.mdmg + math.floor(GetSpellData(_R).level * self.basescale[3] + self.base[3] + player.ap * self.apratio[3]) * 2 end
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Morgana = Morgana

-----------------------------------------------------------------------------
--  MissFortune   [AA] Impure Shots (W passive)
-----------------------------------------------------------------------------

local MissFortune = {}

MissFortune.base = 4
MissFortune.basescale = 2
MissFortune.apratio = 0.05

function MissFortune:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if GetSpellData(_W).level > 0 then
    dmg.mdmg = math.floor(GetSpellData(_W).level * self.basescale + self.base + player.ap * self.apratio)
  end
  self:AddDamage(dmg)
end

Champ.MissFortune = MissFortune

-----------------------------------------------------------------------------
--  Orianna       [AA] Clockwork Windup (passive)
-----------------------------------------------------------------------------

local Orianna = {}

Orianna.base = 0
Orianna.basescale = 5
Orianna.apratio = 0.3

function Orianna:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  dmg.mdmg = math.floor(math.floor((player.level + 2) / 3) * self.basescale + self.base + player.ap * self.apratio)
  self:AddDamage(dmg)
end

Champ.Orianna = Orianna

-----------------------------------------------------------------------------
--  Riven         [AA] Runic Blade (passive)
-----------------------------------------------------------------------------

local Riven = {}

Riven.base = 3
Riven.basescale = 2
Riven.adratio = 0.5
Riven.buffname = "rivenpassiveaaboost"

function Riven:Damage()
  local dmg = { reset = true }
  if self.BuffCheck(self.buffname) then
    dmg.pdmg = math.floor(math.floor((player.level + 2) / 3) * self.basescale + self.base + player.addDamage * self.adratio + player.totalDamage)
  else
    dmg.pdmg = player.totalDamage
  end
  self:AddDamage(dmg)
end

Champ.Riven = Riven

-----------------------------------------------------------------------------
--  Rumble        [AA] Overheat (passive)
-----------------------------------------------------------------------------

local Rumble = {}

Rumble.base = 20
Rumble.basescale = 5
Rumble.apratio = 0.3
Rumble.buffname = "rumbleoverheat"

function Rumble:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = math.floor(self.base + player.level * self.basescale + player.ap * self.apratio)
  end
  self:AddDamage(dmg)
end

Champ.Rumble = Rumble

-----------------------------------------------------------------------------
--  Ryze          [Ability] Overload (Q)
-----------------------------------------------------------------------------

local Ryze = {}

Ryze.use_ability = true
Ryze.base = 35
Ryze.basescale = 25
Ryze.apratio = 0.4
Ryze.manaratio = 0.065

function Ryze:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.basescale + self.base + player.ap * self.apratio + player.maxMana * self.manaratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Ryze = Ryze

-----------------------------------------------------------------------------
--  Shen          [AA] Ki Strike (passive)
--                [Ability] Vorpal Blade (Q)
-----------------------------------------------------------------------------

local Shen = {}

Shen.base = 4
Shen.basescale = 6
Shen.bonushealthratio = 0.1
Shen.shenbasehp = 428
Shen.shenhpscale = 85
Shen.buffname = "shenwayoftheninjaaura"
Shen.use_ability = true
Shen.abilitybase = 20
Shen.abilitybasescale = 40
Shen.abilityapratio = 0.6

function Shen:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = math.floor(player.level * self.basescale + self.base + ((player.maxHealth - self.shenbasehp - self.shenhpscale * player.level) * self.bonushealthratio))
  end
  self:AddDamage(dmg)
end

function Shen:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.abilitybasescale + self.abilitybase + player.ap * self.abilityapratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Shen = Shen

-----------------------------------------------------------------------------
--  Sion          [Ability] Death's Caress (W)
-----------------------------------------------------------------------------

local Sion = {}

Sion.use_ability = true
Sion.base = 50
Sion.basescale = 50
Sion.apratio = 0.9

function Sion:AbilityDamage()
  if GetSpellData(_W).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_W).level * self.basescale + self.base + player.ap * self.apratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Sion = Sion

-----------------------------------------------------------------------------
-- Soraka [Ability] Starcall (Q)
-----------------------------------------------------------------------------

local Soraka = {}

Soraka.use_ability = true
Soraka.base = 60
Soraka.basescale = 25
Soraka.apratio = 0.4

function Soraka:AbilityDamage()
if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.basescale + self.base + player.ap * self.apratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Soraka = Soraka

-----------------------------------------------------------------------------
--  Teemo         [AA] Toxic Shot (E passive)
-----------------------------------------------------------------------------

local Teemo = {}

Teemo.base = 0
Teemo.basescale = 9
Teemo.apratio = 0.4

function Teemo:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if GetSpellData(_E).level > 0 then
    dmg.mdmg = math.floor(GetSpellData(_E).level * self.basescale + self.base + player.ap * self.apratio)
  end
  self:AddDamage(dmg)
end

Champ.Teemo = Teemo

-----------------------------------------------------------------------------
--  Veigar        [Ability] Baleful Strike (Q)
-----------------------------------------------------------------------------

local Veigar = {}

Veigar.use_ability = true
Veigar.base = 35
Veigar.basescale = 45
Veigar.apratio = 0.6

function Veigar:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.basescale + self.base + player.ap * self.apratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Veigar = Veigar

-----------------------------------------------------------------------------
--  Vladimir      [Ability] Transfusion (Q)
-----------------------------------------------------------------------------

local Vladimir = {}

Vladimir.use_ability = true
Vladimir.base = 55
Vladimir.basescale = 35
Vladimir.apratio = 0.6

function Vladimir:AbilityDamage()
  if GetSpellData(_Q).level > 0 then
    local dmg = { reset = true, is_ability = true }
    dmg.mdmg = math.floor(GetSpellData(_Q).level * self.basescale + self.base + player.ap * self.apratio)
    self:AddDamage(dmg)
  else
    return false
  end
end

Champ.Vladimir = Vladimir

-----------------------------------------------------------------------------
--  Warwick       [AA] Eternal Thirst (passive)
-----------------------------------------------------------------------------

local Warwick = {}

Warwick.base = 2.5
Warwick.basescale = 0.5

function Warwick:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  dmg.mdmg = math.floor(player.level * self.basescale + self.base + (player.level > 9 and (player.level - 9) * self.basescale or 0))
end

Champ.Warwick = Warwick

-----------------------------------------------------------------------------
--  Ziggs         [AA] Shortfuse (passive)
-----------------------------------------------------------------------------

local Ziggs = {}

Ziggs.base = 13
Ziggs.basescale = 7
Ziggs.apratio = 0.35
Ziggs.buffname = "ziggsshortfuse"

function Ziggs:Damage()
  local dmg = { reset = true, pdmg = player.totalDamage }
  if self.BuffCheck(self.buffname) then
    dmg.mdmg = math.floor(self.base + player.level * self.basescale + player.ap * self.apratio)
  end
  self:AddDamage(dmg)
end

Champ.Ziggs = Ziggs

-----------------------------------------------------------------------------
--  OnHit        On-Hit values and functions
-----------------------------------------------------------------------------

local OnHit = {}

OnHit.ItemSlot = {
  ITEM_1,
  ITEM_2,
  ITEM_3,
  ITEM_4,
  ITEM_5,
  ITEM_6
}

OnHit.WitsEnd = { id = 3091, damage = 42 }

OnHit.Malady = { id = 3114, damage = 20 }

OnHit.Bloodrazor = {
  is_owned = false,
  id = 3126,
  damagepercent = 0.04,
  minioncap = 120
}

function OnHit.Bloodrazor:CalcDamage(target, is_minion)
  ---------------------------------------------------------------------------
  --  Calculates Madred's Bloodrazor damage.
  --  params self         [Table] The table it's called from.
  --  params target       [Table] The target we're calculating the damage
  --                        against.
  --  params is_minion    [Boolean] Is the target a minion?
  --  return              [Number] The damage.
  ---------------------------------------------------------------------------
  local dmg = 0
  dmg = math.min(player:CalcMagicDamage(target, math.floor(target.maxHealth * self.damagepercent)), is_minion and self.minioncap or 10000)
  return dmg
end

function OnHit:Damage(parent)
  ---------------------------------------------------------------------------
  --  Checks for On-Hit items on the player, namely, Madred's Bloodrazor,
  --    Malady and Wit's End.
  --  params self         [Table] The table it's called from.
  --  params parent       [Table] The parent table with the AddDamage()
  --                        function.
  ---------------------------------------------------------------------------
  local itemWE, itemM, itemMB = 0, 0, false
  for i = 1, 6 do
    id = player:getInventorySlot(self.ItemSlot[i])
    if id == self.WitsEnd.id then
      itemWE = self.WitsEnd.damage
    elseif id == self.Malady.id then
      itemM = self.Malady.damage
    elseif id == self.Bloodrazor.id then
      itemMB = true
    end
  end
  if (itemWE + itemM) > 0 then
    if parent.use_ability and parent.use_abilityonhit then
      parent:AddDamage({mdmg = itemWE + itemM, is_ability = true})
    end
    parent:AddDamage({mdmg = itemWE + itemM})
  end
  self.Bloodrazor.is_owned = itemMB
end

-----------------------------------------------------------------------------
-- Masteries      Mastery values and functions
-----------------------------------------------------------------------------

local Masteries = {}

Masteries.Butcher = { points = 0, damage = 2 }

Masteries.Havoc = { points = 0, damage = 0.005 }

Masteries.Executioner = { is_used = false, damage = 0.06, hpthreshold = 0.4 }

function Masteries.Butcher:Damage(parent)
  ---------------------------------------------------------------------------
  --  Calculates damage for Butcher.
  --  params self         [Table] The table it's called from.
  --  params parent       [Table] The parent table with the AddDamage()
  --                        function.
  ---------------------------------------------------------------------------
  if self.points > 0 then
    if parent.use_ability and parent.use_abilityonhit then
      parent:AddDamage({tdmg = self.points * self.damage, is_ability = true})
    end
    parent:AddDamage({tdmg = self.points * self.damage})
  end
end

function Masteries:CalcDamage(target, dmg)
  ---------------------------------------------------------------------------
  --  Calculates damage for Executioner and Havoc.
  --  params self         [Table] The table it's called from.
  --  params target       [Table] The target we're calculating the damage
  --                        against.
  --  params dmg          [Number] The damage we are going to do before the
  --                        masteries.
  --  return              [Number] The damage we are going to do after the
  --                        masteries.
  ---------------------------------------------------------------------------
  dmg = dmg * (self.Havoc.points * self.Havoc.damage + (self.Executioner.is_used and (target.maxHealth * self.Executioner.hpthreshold > target.health) and self.Executioner.damage or 0) + 1)
  return dmg
end

-----------------------------------------------------------------------------
--  Magic         Where the magic happens
-----------------------------------------------------------------------------

local function Damage(self, prefs)
  ---------------------------------------------------------------------------
  --  Calls the other functions in the Library in order to save the damage
  --    values to be calculated later against targets. Should only be called
  --    once per timer tick.
  --  params self         [Table] The table it's called from.
  --  params prefs        [Table] An optional table full of preferences.
  --    .use_aa           [Boolean] Calc for auto-attacks? [Default = true]
  --    .use_ability      [Boolean] Calc for abilities? [Default = true]
  --    .use_onhit        [Boolean] Check for onhit items? [Default = true]
  --    .use_masteries    [Boolean] Calc for masteries? [Default = false]
  --    .butcherpoints    [Number] How many points in Butcher? [Default = 0]
  --    .havocpoints      [Number] How many points in Havoc? [Default = 0]
  --    .use_executioner  [Boolean] Calc for Executioner? [Default = false]
  --    .is_minion        [Boolean] Is the target a minion? [Default = true]
  ---------------------------------------------------------------------------
  prefs = prefs or {}
  local options = {
    use_aa = true,
    use_ability = true,
    use_onhit = true,
    use_masteries = false,
    butcherpoints = 0,
    havocpoints = 0,
    use_executioner = false,
    is_minion = true
  }
  for k,v in pairs(prefs) do options[k] = v end
  if options.use_aa then
    self.Champ:Damage()
  end
  if options.use_ability and ((self.Champ.use_ability and self.Champ:AbilityDamage() == false) or self.Champ.use_ability == false) then
    options.use_ability = false
  end
  if options.use_onhit then
      self.OnHit:Damage(self.Champ)
  end
  if options.use_masteries then
    self.Masteries.Butcher.points = options.butcherpoints
    self.Masteries.Havoc.points = options.havocpoints
    self.Masteries.Executioner.is_used = options.use_executioner
    if self.Masteries.Butcher.points > 0 then
      self.Masteries.Butcher:Damage(self.Champ)
    end
    if self.Masteries.Havoc.points == 0 and self.Masteries.Executioner.is_used == false then
      options.use_masteries = false
    end
  end
  self.prefs = options
end

local function CalcDamage(self, target)
  ---------------------------------------------------------------------------
  --  Calls other functions and values to determine damage against a target.
  --  params self         [Table] The table it's called from.
  --  params target       [Table] The target we're calculating the damage
  --                        against.
  --  return              [Table] A table
  --    .damage           [Number] Auto-attack damage vs that target
  --    .abilitydamage    [Number] Ability damage vs that target
  ---------------------------------------------------------------------------
  local dmg, brdmg = { damage = 0, abilitydamage = 0 }, 0
  if self.prefs.use_aa then
    local pdmg, mdmg, tdmg, cdmg = 0, 0, self.Champ.sv.tdmg, 0
    if self.prefs.use_onhit and self.OnHit.Bloodrazor.is_owned then
      brdmg = self.OnHit.Bloodrazor:CalcDamage(target, self.prefs.is_minion)
    end
    if self.Champ.use_calcdamage then
      cdmg = self.Champ:CalcDamage(target, self.prefs.is_minion)
    end
    if self.Champ.sv.pdmg > 0 then
      pdmg = player:CalcDamage(target, self.Champ.sv.pdmg)
    end
    if self.Champ.sv.mdmg > 0 then
      mdmg = player:CalcMagicDamage(target, self.Champ.sv.mdmg)
    end
    dmg.damage = tdmg + cdmg + pdmg + mdmg + brdmg
    if self.prefs.use_masteries then
      dmg.damage = self.Masteries:CalcDamage(target, dmg.damage)
    end
  end
  if self.prefs.use_ability then
    local pdmg, mdmg, tdmg, cdmg = 0, 0, self.Champ.asv.tdmg, 0
    if self.Champ.use_abilityonhit == false then
      brdmg = 0
    end
    if self.Champ.use_calcability then
      cdmg = self.Champ:CalcAbilityDamage(target, self.prefs.is_minion)
    end
    if self.Champ.asv.pdmg > 0 then
      pdmg = player:CalcDamage(target, self.Champ.asv.pdmg)
    end
    if self.Champ.asv.mdmg > 0 then
      mdmg = player:CalcMagicDamage(target, self.Champ.asv.mdmg)
    end
    dmg.abilitydamage = tdmg + cdmg + pdmg + mdmg + brdmg
    if self.prefs.use_masteries then
      dmg.abilitydamage = self.Masteries:CalcDamage(target, dmg.abilitydamage)
    end
  end
  return dmg
end

-----------------------------------------------------------------------------
--  Build         Where we build the library
-----------------------------------------------------------------------------

local function Merge(t1, t2)
  ---------------------------------------------------------------------------
  --  Merges two tables.
  --  params t1           [Table] The first table.
  --  params t2           [Table] The second table which has preference with
  --                        conflicts. We check if it's actually a table.
  --  return              [Table] The merged table or just the first table if
  --                        t2 wasn't a table.
  ---------------------------------------------------------------------------
  if type(t2) ~= "table" then return t1 end
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      Merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

DamageLibrary.Champ = Merge(Champ.Default, Champ[player.charName])
DamageLibrary.OnHit = OnHit
DamageLibrary.Masteries = Masteries
DamageLibrary.Damage = Damage
DamageLibrary.CalcDamage = CalcDamage



--UPDATEURL=
--HASH=D211BECFB306B4CE13DB77DC1F737C15
