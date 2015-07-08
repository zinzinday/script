-- globals for convenience
me = myHero

function GetVarArg(...)
    if arg==nil then    
        local n = select('#', ...)
        local t = {}
        local v
        for i=1,n do
            v = select(i, ...)
            --print('\nv = '..tostring(v))
            table.insert(t,v)
        end
        return t
    else
        return arg
    end
end

function Class()
    local cls = {}
    cls.__index = cls
    return setmetatable(cls, {__call = function (c, ...)
        local instance = setmetatable({}, cls)
        if cls.__init then
            cls.__init(instance, ...)
        end
        return instance
    end})
end

local function table_print(tt, indent, done)
   done = done or {}
   indent = indent or 0
   if type(tt) == "table" then
      local sb = {}
      for key, value in pairs (tt) do
         table.insert(sb, string.rep (" ", indent)) -- indent it
         if type(value) == "table" and not done [value] then
            done [value] = true
            table.insert(sb, tostring(key).." = {\n");
            table.insert(sb, table_print (value, indent + 2, done))
            table.insert(sb, string.rep (" ", indent)) -- indent it
            table.insert(sb, "}\n");
         elseif "number" == type(key) then
            table.insert(sb, string.format("\"%s\"\n", tostring(value)))
         else
            table.insert(sb, string.format("%s = \"%s\"\n", tostring (key), tostring(value)))
         end
      end
      return table.concat(sb)
   else
      return tt .. "\n"
   end
end

function time()
   return os.clock()
end

function pp(str)
   if not str then
      pp("nil")
   elseif type(str) == "table" then
      if str.__tostring then
         log(tostring(str).."\n")
      else
         pp(table_print(str, 2))
      end
   elseif type(str) == "userdata" then
      if str.type == "AIHeroClient" or str.type == "obj_AI_Minion" then
         pp(str.charName)
      else
         pp(str.name)
      end
      if str.name then
         pp("  ("..math.floor(str.x+.5)..","..math.floor(str.z+.5)..")")
      end
   else
      log(tostring(str).."\n")
   end
end

function trunc(num, places)
   if not places then places = 2 end
   local factor = 10^places
   return math.floor(num*factor)/factor
end

function merge(table1, table2)
   local resTable = {}
   for k,v in pairs(table1) do
      resTable[k] = v
   end
   for k,v in pairs(table2) do
      resTable[k] = v
   end
   return resTable
end

function reverse(t)
   local reversedTable = {}
   local itemCount = #t
   for k, v in ipairs(t) do
       reversedTable[itemCount + 1 - k] = v
   end
   return reversedTable
end

function sum(t)
   local total = 0
   for _,v in ipairs(t) do
      total = total + v
   end
   return total
end

function max(t)
   local max
   for _,v in ipairs(t) do
      if not max or v > max then
         max = v
      end
   end
   return max
end

function concat(...)
   local resTable = {}
   for _,tablex in ipairs(GetVarArg(...)) do
      if type(tablex) == "table" then
         for _,v in ipairs(tablex) do
            table.insert(resTable, v)
         end
      else
         table.insert(resTable, tablex)
      end      
   end
   return resTable
end

function uniques(t)
   local result = {}
   for i,item in ipairs(t) do
      local unique = true
      for _,res in ipairs(result) do
         if item == res then
            unique = false
            break
         end
      end
      if unique then
         table.insert(result, item)
      end
   end
   return result
end

function removeItems(list, items)
   local resTable = {}
   for _,t in ipairs(list) do
      local addItem = true
      for _,item in ipairs(items) do
         if t == item then
            addItem = false
            break
         end
      end
      if addItem then
         table.insert(resTable, t)
      end
   end
   return resTable
end


function SelectFromList(list, scoreFunction, args)
   local bestItem
   local bestScore = 0
   for _,item in ipairs(list) do
      local score = scoreFunction(item, args)
      if score > bestScore then
         bestItem = item
         bestScore = score
      end
   end
   if bestItem then 
      return bestItem, bestScore 
   end
   return nil, 0
end

function rpairs(t)
   return prev, t, #t+1
end

function prev(t, i)
   if i == 1 then
      return nil
   end
   return i-1, t[i-1]
end

local line = 0
function PrintState(state, str)
   Text(tostring(str),100,100+state*15,0xFFCCEECC);
end

function ClearState(state)
   printStates[state+1] = ""
end

function find(source, target, exact)
   if not source or not target then
      return false
   end
   if string.len(target) == 0 then
      return false
   end
   if exact then
      return source == target
   end
   return string.find(string.lower(source), string.lower(target))
end

function startsWith(source, target)
   local s, e = find(source, target)
   if s then
      return s == 1
   end
   return false
end

function copy(orig)
   if not orig then return nil end
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in pairs(orig) do
         copy[orig_key] = orig_value
      end
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
end

function mult(list, sv)
   local res = {}
   for _,l in ipairs(list) do
      table.insert(res, l*sv)
   end
   return res
end

OBJECT_CALLBACKS = {}
SPELL_CALLBACKS = {}
TICK_CALLBACKS = {}
DRAW_CALLBACKS = {}

function AddOnDraw(callback)   
   table.insert(DRAW_CALLBACKS, callback)
end

function AddOnTick(callback)
   table.insert(TICK_CALLBACKS, {debug.getinfo(callback).source, callback})
end

function AddOnCreate(callback)
   table.insert(OBJECT_CALLBACKS, callback)
   -- RegisterLibraryOnCreateObj(callback)
end

function AddOnSpell(callback)
   table.insert(SPELL_CALLBACKS, callback)
   -- RegisterLibraryOnProcessSpell(callback)
end

function FilterList(list, f)
   local res = {}
   for _,item in ipairs(list) do
      if f(item) then
         table.insert(res, item)
      end
   end
   return res
end

function ListContains(item, list, exact)
   if type(item) ~= "string" then
      exact = true
   end

   for _,test in pairs(list) do
      if exact then
         if item == test then return true end
      else
         if find(item, test) then return true end
      end
   end
   return false
end

function GetIntersection(list1, list2)
   local intersection = {}
   for _,v1 in ipairs(list1) do
      for _,v2 in ipairs(list2) do
         if v1 == v2 then
            table.insert(intersection, v1)
         end
      end
   end
   return intersection
end

-- remove the items from list2 from list1
function RemoveFromList(list1, list2)
   return FilterList(list1, function(item) return not ListContains(item, list2) end)
end

function SameUnit(o1, o2)
   if not o1 or not o2 or
      not type(o1) == "userdata" or not type(o2) == "userdata"
   then 
      return false 
   end
   return o1.name == o2.name and
          o1.charName == o2.charName and
          o1.x == o2.x and
          o1.z == o2.z
end

function IsMe(unit)
   return SameUnit(me, unit)
end

function CalculateDamage(target, dam)
   if dam.m and dam.m > 0 then
      local res = target.magicArmor
      if res > 0 then
         res = math.max(math.ceil(res*me.magicPenPercent - me.magicPen), 0)
      end
      dam.m = math.floor(dam.m*(100/(100+res)))
   end
   if dam.p and dam.p > 0 then
      local res = target.armor
      if res > 0 then
         math.max(math.ceil(res*me.armorPenPercent - me.armorPen), 0)
      end
      dam.p = math.floor(dam.p*(100/(100+res)))
   end

   return dam:toNum()
end

Damage = Class()
function Damage:__init(p, m, t)
   self.isDamage = true
   if type(p) == "table" and p.isDamage then 
      self.p = p.p
      self.m = p.m
      self.t = p.t
      return self
   end
   if m and type(m) == "string" then
      if type(p) ~= "number" then
         p = p:toNum()
      end
      if m == "P" then
         self.type = "P"
         self.p = p or 0
         self.m = 0
         self.t = 0
         return self
      elseif m == "T" then
         self.type = "T"
         self.p = 0
         self.m = 0
         self.t = p or 0
         return self
      elseif m == "M" then
         self.type = "M"
         self.p = 0
         self.m = p or 0
         self.t = 0
         return self
      elseif m == "H" then
         self.type = "H"
         self.p = 0
         self.m = 0
         self.t = p or 0
         return self
      end
   end

   self.p = p or 0
   self.m = m or 0
   self.t = t or 0
end
function Damage:__add(d)
   if not d then
      return self
   end

   if type(self) == "number" then
      return d+self
   end

   if type(d) == "number" then
      if d == 0 then
         return self
      end
      if self.type == "P" or ( self.p ~= 0 and self.m == 0 and self.t == 0 ) then
         self.p = self.p + d
         return self
      elseif self.type == "M" or ( self.p == 0 and self.m ~= 0 and self.t == 0 ) then
         self.m = self.m + d
         return self
      elseif self.type == "T" or ( self.p == 0 and self.m == 0 and self.t ~= 0 ) then
         self.t = self.t + d
         return self
      elseif self:toNum() == 0 then
         return d
      else
         pp(self)
         pp(d)
         pp(debug.traceback())
         return self
      end
   end
   return Damage(self.p+d.p, self.m+d.m, self.t+d.t)
end

function Damage:__sub(d)
   if not d then
      return self
   end

   if type(self) == "number" then
      return self-d:toNum()
   end

   if type(d) == "number" then
      return self + -d
   end
   return Damage(self.p-d.p, self.m-d.m, self.t-d.t)
end

function Damage:__mul(d)
   if type(self) == "number" then
      return d*self
   end

   return Damage(self.p*d, self.m*d, self.t*d)
end

function Damage:__div(d)
   assert(type(d) == "number")
   return Damage(self.p/d, self.m/d, self.t/d)
end

function Damage:__le(d)
   if type(d) == "table" then
      d = d:toNum()
   end
   return self:toNum() <= d
end

function Damage:__lt(d)
   return self:toNum() < d:toNum()
end

function Damage:__tostring()
   return tostring(self:toNum())
   -- return "{"..self.p..","..self.m..","..self.t.."}"
end

function Damage:toNum()
   return math.floor(self.p+self.m+self.t)
end

function Damage:__concat(a)
    return tostring(self) .. tostring(a) 
end

function LoadConfig(name)
   local status, config = pcall( 
      function()
         local config = {}
         for line in io.lines(BOL_PATH..name..".cfg") do
            for k,v in string.gmatch(line, "(%w+)=(%w+)") do
               config[k] = v
            end
         end
         return config
      end 
   )
   if status then 
      return config 
   else
      return {}
   end
end

function SaveConfig(name, config)
   local file = io.open(BOL_PATH..name..".cfg", "w")
   for k,v in pairs(config) do
      if type(v) == "table" then
         file:write(k.." = {\n  "..table_print(v, 2))
      else
         file:write(k.."="..v.."\n")
      end
   end
   file:close()
end

LOG_FILE = nil
DEBUG_LOG_FILE = nil
function log(text)
   if not LOG_FILE then
         LOG_FILE = io.open(BOL_PATH.."BOL.log", "w")
   end
   LOG_FILE:write(text)
   LOG_FILE:flush()
end

DO_LOG = false
function dlog(text)
   if not DO_LOG then return end

   if not DEBUG_LOG_FILE then
      DEBUG_LOG_FILE = io.open(BOL_PATH.."boldebug.log", "a")
   end
   DEBUG_LOG_FILE:write(text.."\n")
   DEBUG_LOG_FILE:flush()
end

function onSplat(foo)
   pp(foo)
   pp(debug.traceback())
end

AddBugsplatCallback(onSplat)