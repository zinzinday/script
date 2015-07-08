--[[

DrawDamageLib
by Draesia

-- NOTE --

If you use this libary or any of my code in your script, please give me credits, thankyou.

-- Functions --

drawDamage() -- Call this every drawTick
setOrder(key, value) -- Use this to change the order in which the values will draw, right to left, higher value will favour right.
addDrawDamage(key, [isMagic]) -- Use this to add keys to draw, by default, all keys are added, isMagic is optional
removeDrawDamage(key) --Use this to remove keys to draw, by default, all keys are added.

-- Keys --

P
Q
W
E
R
AD
IGNITE
DFG
HXG
BWC
SHEEN
TRINITY
LICHBANE

--]]

local flipped = true
local ignite = nil     
local width, offsetX, offsetY, characterSpacing = 104, 74, 31, 6
local magicTable = {}
local damageTable = {["DFG"] = 0, ["P"] = 0, ["Q"] = 0, ["W"] = 0, ["E"] = 0, ["R"] = 0, ["AD"] = 0, ["IGNITE"] = 0, ["HXG"] = 0, ["BWC"] = 0, ["SHEEN"] = 0, ["TRINITY"] = 0, ["LICHBANE"] = 0} 
local order = {["DFG"] = 0, ["P"] = 0, ["Q"] = 0, ["W"] = 0, ["E"] = 0, ["R"] = 0, ["AD"] = 0, ["IGNITE"] = 0, ["HXG"] = 0, ["BWC"] = 0, ["SHEEN"] = 0, ["TRINITY"] = 0, ["LICHBANE"] = 0}

UpdateWindow()

local function getDamage(damageSource, enemy)
  if not enemy then return 0 end
  if damageSource == "P" then return getDmg("P", enemy, myHero)
  elseif damageSource == "Q" and myHero:CanUseSpell(_Q) == READY then return getDmg("Q", enemy, myHero)
  elseif damageSource == "W" and myHero:CanUseSpell(_W) == READY then return getDmg("W", enemy, myHero)
  elseif damageSource == "E" and myHero:CanUseSpell(_E) == READY then return getDmg("E", enemy, myHero)
  elseif damageSource == "R" and myHero:CanUseSpell(_R) == READY then return getDmg("R", enemy, myHero)
  elseif damageSource == "AD" and enemy.canAttack then return getDmg("AD", enemy, myHero)
  elseif damageSource == "SHEEN" and enemy.canAttack and GetInventorySlotItem(3057) then return getDmg("SHEEN", enemy, myHero) 
  elseif damageSource == "TRINITY" and enemy.canAttack and GetInventorySlotItem(3078) then return getDmg("TRINITY", enemy, myHero) 
  elseif damageSource == "LICHBANE" and enemy.canAttack and GetInventorySlotItem(3100) then return getDmg("LICHBANE", enemy, myHero) 
  elseif damageSource == "IGNITE" and ignite and myHero:CanUseSpell(ignite) == READY then return getDmg("IGNITE", enemy, myHero)
  elseif damageSource == "DFG" and GetInventorySlotItem(3128) and myHero:CanUseSpell(GetInventorySlotItem(3128)) == READY then return getDmg("DFG", enemy, myHero) 
  elseif damageSource == "HXG" and GetInventorySlotItem(3146) and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY then return getDmg("HXG", enemy, myHero)  
  elseif damageSource == "BWC" and GetInventorySlotItem(3144) and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY then return getDmg("BWC", enemy, myHero)  
  end
  return 0
end

local function spairs(t, order)
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end
  if order then
    table.sort(keys, function(a,b) return order(t, a, b) end)
  else
    table.sort(keys)
  end
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

local function doDraw()
  for i, enemy in pairs(GetEnemyHeroes()) do
    if(enemy ~= myHero) then offsetX = 49 else offsetX = 73 end
    if enemy.visible and not enemy.dead then
      local dfg = (damageTable["DFG"] ~= -1 and GetInventorySlotItem(3128) and myHero:CanUseSpell(GetInventorySlotItem(3128)) == READY)
      for damageSource, shouldDisplay in pairs(damageTable) do 
        if shouldDisplay ~= -1 then
          damageTable[damageSource] = 0
          local damage = getDamage(damageSource, enemy)
          if magicTable.damageSource and dfg then damage = damage * 1.2 end
          damageTable[damageSource] = damage
        end
      end
      local dx = ((enemy.maxHealth - enemy.health)/enemy.maxHealth) * width
      local pos = 0
      local counter = 0
      for damageSource, value in spairs(damageTable, (function(t,a,b) if order[a] ~= order[b] then return order[a] > order[b] else return t[b] < t[a] end end)) do 
        if value > 0 then
          local dw = (value/enemy.maxHealth) * width
          local pos1 = GetUnitHPBarPos(enemy)
          local x = pos1.x-dx-pos+offsetX
          local ny = GetUnitHPBarOffset(enemy).y * 50 - 5
          local y = pos1.y+ny+(flipped and 18 or 0)
          if x > 0 and x < WINDOW_W+width and y > 0 and y < WINDOW_H then
            if pos + dw > (enemy.health/enemy.maxHealth) * width then
              dw = (enemy.health/enemy.maxHealth) * width - pos
              if pos == 0 then
                DrawLine(x, y, x, y-10, 1, 0xFF00FF00)
                DrawLine(x-dw, y, x-dw, y-10, 1, 0xFF00FF00)
              else
                DrawLine(x-dw, y, x-dw, y-10, 1, 0xFF00FF00)
              end
              if dw > (characterSpacing*damageSource:len()) then DrawText(damageSource, 8, x-(dw*0.5)-2, y-15+(flipped and 18 or 0), 0xFF00FF00) end
              break
            end
            if dw > (characterSpacing*damageSource:len()) then DrawText(damageSource, 8, x-(dw*0.5)-2, y-15+(flipped and 15 or 0), 0xFF00FF00) end
            if pos == 0 then
              DrawLine(x, y, x, y-10, 1, 0xFF00FF00)
              DrawLine(x-dw, y, x-dw, y-10, 1, 0xFF00FF00)
            else
              DrawLine(x-dw, y, x-dw, y-10, 1, 0xFF00FF00)
            end
            counter = counter + 1
            pos = pos + dw
          end
        end
      end
    end
  end
end

function drawDamage()
  doDraw()
end

function setOrder(key, value)
  if damageTable[key] then
    damageTable[key] = value
  end
end

function addDrawDamage(damageSource, isMagic)
  if damageSource ~= "IGNITE" then
    if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2 
    else return
    end
  end
  if isMagic and damageSource ~= "DFG" then magicTable.insert(damageSource) end
  damageTable[damageSource] = 0
end

function removeDrawDamage(damageSource)
  damageTable[damageSource] = -1
  magicTable[damageSource] = nil
end

function setFlipped(flip)
  flipped = flip
end