--[[
NotLib
by Ivan[RUSSIA]

GPL v2 license
--]]
-- NILL CALLBACK
local NCB = function() end
-- TABLE
setproxytable = function(t,cb) return setmetatable({},{__len = function(p) return #t end,__index = function(p,k) return t[k] end,__newindex = function(p,k,v) if t[k] ~= v then t[k] = v cb(k) end end}) end
-- MATH
VEC = function(x,z) return D3DXVECTOR3(x,0,z) end
math.dist2d = function(x1,y1,x2,y2) return math.sqrt((x2-x1)^2+(y2-y1)^2) end
math.pos2d = function(pos,rad,range) return VEC(pos.x + math.sin(rad)*range,pos.z+math.cos(rad)*range) end
math.center2d = function() return D3DXVECTOR3(cameraPos.x,-161.1643,cameraPos.z+(cameraPos.y+161.1643)*math.sin(0.6545)) end
math.rad2d = function(pos1,pos2)
	if pos2.z > pos1.z then
		if pos1.x < pos2.x then return math.acos(math.dist2d(pos1.x,pos1.z,pos1.x,pos2.z)/(pos1:GetDistance(pos2)))
		else return 6.283185307-math.acos(math.dist2d(pos1.x,pos1.z,pos1.x,pos2.z)/(pos1:GetDistance(pos2))) end
	else 
		if pos1.x < pos2.x then return 1.570796327+math.acos(math.dist2d(pos1.x,pos2.z,pos2.x,pos2.z)/(pos1:GetDistance(pos2)))
		else return 4.712388980-math.acos(math.dist2d(pos1.x,pos2.z,pos2.x,pos2.z)/(pos1:GetDistance(pos2))) end
	end
end
math.normal2d = function(pos1,pos2)
	local rad = math.rad2d(pos1,pos2)
	return VEC(math.sin(rad),math.cos(rad))
end
math.proj2d = function(dotPos,linePos1,linePos2)
	dotPos = VEC(dotPos.x,dotPos.z)
	local dotRad = math.rad2d(linePos1,dotPos)
	local lineRad = math.rad2d(linePos1,linePos2)
	return math.pos2d(linePos1,lineRad,math.cos(lineRad - dotRad)*dotPos:GetDistance(linePos1))
end
-- INIT
NotLib = setmetatable({},{__index=function(lib,part)
	if part == "timer" then
		AddTickCallback(function()
			local clock = GetTickCount()/1000
			for hkey,h in pairs(lib[part]) do if h.lastcall + h.cooldown <= clock then
				h.lastcall = h.lastcall+h.cooldown
				h.callback()
				if lib[part][hkey] == nil then break end 
			end end
		end)
		lib[part] = setmetatable({},{__call=function(timer,hkey,cooldown) 
			timer[hkey].cooldown = (cooldown or timer[hkey].cooldown) 
			return timer[hkey]
		end,__index=function(timer,hkey) 
			local h = {hkey=hkey,lastcall=math.huge,cooldown=0,callback=NCB}
			h.stop = function() h.lastcall = math.huge end
			h.pause = function(timeline) h.lastcall = h.lastcall + timeline end
			h.start = function(callback) h.lastcall = GetTickCount()/1000 if callback == true then h.callback() end end
			h.disable = function() timer[hkey] = nil end
			timer[hkey] = h
			return timer[hkey]
		end})
		return lib[part]
	end
	if part == "bind" then
		AddMsgCallback(function(msg,wParam)
			if msg == 0x200 then wParam,msg = 0x0,KEY_DOWN elseif msg == 0x202 then wParam,msg = 0x1,KEY_UP 
			elseif msg == 0x205 then wParam,msg = 0x2,KEY_UP elseif msg == 0x208 then wParam,msg = 0x4,KEY_UP end
			for hkey,h in pairs(lib[part]) do 
				if wParam == 0 then
					h.mouse()
					if lib[part][hkey] == nil then break end
				elseif h.key == wParam then
					h.callback(msg ~= KEY_UP) 
					if lib[part][hkey] == nil then break end
				end 
			end
		end)
		lib[part] = setmetatable({},{__call=function(bind,hkey,key) 
			bind[hkey].key = (key or bind[hkey].key) 
			return bind[hkey] 
		end,__index=function(bind,hkey) 
			local h = {hkey=hkey,key=math.huge,callback=NCB,mouse=NCB}
			h.disable = function() bind[hkey] = nil end
			bind[hkey] = h
			return bind[hkey] 
		end})
		return lib[part]
	end
	if part == "gui" then
		AddDrawCallback(function()
			for hkey,h in pairs(lib[part]) do if h.visible == true then
				h.callback()
				if lib[part][hkey] == nil then break end
			end end
		end)
		lib[part] = setmetatable({},{__call=function(gui,hkey) return gui[hkey] end,__index=function(gui,hkey)
			local h = {x=0,y=0,visible=true,bind=lib.bind(#lib.bind+1,0x1),children={}}
			h.parent = function() for key,parent in pairs(gui) do for i=1,#parent do if parent[i] == h then return parent end end end end
			h.inside = function(pos) return pos.x >= h.x and pos.x <= h.x+h.w and pos.y >= h.y and pos.y <= h.y+h.h end
			h.reset = function() 
				h.changed,h.refresh,h.proc,h.callback,h.bind.callback,h.bind.mouse = NCB,NCB,NCB,NCB,NCB,NCB
				h.w,h.h,h.tSize,h.lSize,h.font,h.back = 0,0,WINDOW_H/40,WINDOW_H/225,0xAAFFFF00,0xBB964B00 
			end
			h.transform = function(to)
				h.reset()
				if to == "text" then
					h.text = ""
					h.refresh = function() h.w,h.h = GetTextArea(h.text,h.tSize).x,h.tSize end
					h.callback = function() DrawText(h.text,h.tSize,h.x,h.y,h.font) end
				end
				if to == "button" then
					h.down,h.text = false,"text"
					h.refresh = function() h.w,h.h = GetTextArea(h.text,h.tSize).x+h.tSize,h.tSize end
					h.callback = function()
						if h.down == false then 
							DrawLine(h.x,h.y+h.tSize/2,h.x+h.w,h.y+h.tSize/2,h.h,h.back)
							DrawText(h.text,h.tSize,h.x+h.tSize/2,h.y,h.font)
						else
							DrawLine(h.x,h.y+h.tSize/2,h.x+h.w,h.y+h.tSize/2,h.h,h.font)
							DrawText(h.text,h.tSize,h.x+h.tSize/2,h.y,h.back)
						end
					end
					h.bind.callback = function(down) 
						if h.visible == true and h.inside(GetCursorPos()) == true then
							if down == false and h.down == true then h.proc() end
							h.down = down
						else h.down = false end
					end
				end
				if to == "tick" then
					h.value,h.text = false,""
					h.refresh = function() h.w,h.h = h.tSize+h.lSize*2+GetTextArea(h.text,h.tSize).x,h.tSize end
					h.callback = function() 
						if h.value == true then DrawLine(h.x+h.tSize/2,h.y+h.lSize*1.5,h.x+h.tSize/2,h.y+h.tSize-h.lSize*1.5,h.tSize-h.lSize*3,h.font) end
						DrawLine(h.x,h.y,h.x+h.tSize,h.y,h.lSize,h.back) -- top
						DrawLine(h.x,h.y+h.tSize,h.x+h.tSize,h.y+h.tSize,h.lSize,h.back) -- bot
						DrawLine(h.x,h.y,h.x,h.y+h.tSize,h.lSize,h.back) -- left
						DrawLine(h.x+h.tSize,h.y,h.x+h.tSize,h.y+h.tSize,h.lSize,h.back) -- right
						DrawText(h.text,h.tSize,h.x+h.tSize+h.lSize*2,h.y,h.font) -- text
					end
					h.bind.callback=function(down) if down and h.visible == true and h.inside(GetCursorPos()) == true then h.value = not h.value end end
				end
				if to == "bar" then
					h.value,h.min,h.max = 0,0,1
					h.refresh = function() h.w,h.h = h.tSize*5.5+math.max(GetTextArea(tostring(h.min),h.tSize).x,GetTextArea(tostring(h.max),h.tSize).x),h.tSize end
					h.callback = function()
						DrawLine(h.x,h.y+h.tSize/2,h.x+h.tSize*5,h.y+h.tSize/2,h.tSize,h.back)
						local valueX = h.x+(h.tSize*5)/(h.max-h.min)*(h.value-h.min)
						DrawLine(h.x,h.y+h.tSize/2,valueX,h.y+h.tSize/2,h.tSize,h.font)
						DrawText(tostring(h.value),h.tSize,h.x+h.tSize*5.25,h.y,h.font)
					end
				end
				if to == "slider" then
					h.down,h.value,h.min,h.max = false,0,0,1
					h.refresh = function() h.w,h.h = h.tSize*5.5+h.lSize+math.max(GetTextArea(tostring(h.min),h.tSize).x,GetTextArea(tostring(h.max),h.tSize).x),h.tSize end
					h.callback = function()
						DrawLine(h.x,h.y+h.tSize/2,h.x+h.tSize*5,h.y+h.tSize/2,h.lSize,h.back)
						local valueX = h.x+(h.tSize*5)/(h.max-h.min)*(h.value-h.min)
						DrawLine(valueX,h.y,valueX,h.y+h.tSize,h.lSize*2,h.font)
						DrawText(tostring(h.value),h.tSize,h.x+h.tSize*5.25+h.lSize,h.y,h.font)
					end
					h.bind.callback = function(down) 
						h.down = (down == true and h.visible == true and h.inside(GetCursorPos()) == true and h.inside(GetCursorPos()) == true)
						if h.down == true then h.bind.mouse() end				
					end
					h.bind.mouse = function() if h.down == true then 
						local result = math.floor(h.min+(GetCursorPos().x-h.x)*(h.max-h.min)/(h.tSize*5)+0.5)
						h.value = math.min(h.max,math.max(h.min,result))
					end end
				end
				if to == "line" then
					h.refresh = function()
						local x,y = 0,0
						for i=1,#h do if h[i].visible == true then
							h[i].x,h[i].y = h.x+x,h.y
							x,y = x+h[i].w+h.lSize*2,math.max(y,h[i].h)
						end end
						h.w,h.h = math.max(0,x-h.lSize*2),y
					end
				end
				if to == "list" then
					h.refresh = function()
						local x,y = 0,0
						for i=1,#h do if h[i].visible == true then
							h[i].y,h[i].x = h.y+y,h.x
							y,x = y+h[i].h+h.lSize*2,math.max(x,h[i].w)
						end end
						h.h,h.w = math.max(0,y-h.lSize*2),x
					end
				end
				if to == "anchor" then
					h.refresh = function()
						local x,y = 0,h.lSize*4
						for i=1,#h do if h[i].visible == true then
							h[i].y,h[i].x = h.y+y,h.x
							y,x = y+h[i].h+h.lSize*2,math.max(x,h[i].w)
						end end
						h.h,h.w = math.max(h.lSize*2,y-h.lSize*2),x
					end
					h.callback = function() DrawLine(h.x,h.y+h.lSize,h.x+h.w,h.y+h.lSize,h.lSize*2,h.font) end
					h.bind.callback = function(down) 
						if down == true and h.visible == true and GetCursorPos().x >= h.x and GetCursorPos().x <= h.x+h.w 
						and GetCursorPos().y >= h.y and GetCursorPos().y <= h.y+h.lSize*2 then h.point = {x=GetCursorPos().x-h.x,y=GetCursorPos().y-h.y}
						else h.point = nil end
					end
					h.bind.mouse = function() if h.point ~= nil then
						h.x = math.min(WINDOW_W-h.w,math.max(0,GetCursorPos().x-h.point.x))
						h.y = math.min(WINDOW_H-h.h,math.max(0,GetCursorPos().y-h.point.y))
					end end
				end
				if to == "world" then
					h.pos = {x=0,z=0}
					h.callback = function()
						local pos = WorldToScreen(VEC(h.pos.x,h.pos.z))
						h.x,h.y = pos.x,pos.y
					end
					h.refresh = function()
						local x,y = 0,0
						for i=1,#h do if h[i].visible == true then
							h[i].y,h[i].x = h.y+y,h.x
							y,x = y+h[i].h+h.lSize*2,math.max(x,h[i].w)
						end end
						h.h,h.w = math.max(0,y-h.lSize*2),x
					end
				end
				if to == "question" then
					gui[hkey.."qtext"].transform("text")
					gui[hkey.."qbutton1"].transform("button")
					gui[hkey.."qbutton1"].text,gui[hkey.."qbutton1"].proc = "yes",function() h.disable() h.proc(true) end
					gui[hkey.."qbutton2"].transform("button")
					gui[hkey.."qbutton2"].text,gui[hkey.."qbutton2"].proc = "no",function() h.disable() h.proc(false) end 
					gui[hkey.."qline"].transform("line")
					gui[hkey.."qline"][1],gui[hkey.."qline"][2] = gui[hkey.."qbutton1"],gui[hkey.."qbutton2"]
					h.transform("anchor")
					h[1],h[2],h.changed = gui[hkey.."qtext"],gui[hkey.."qline"],function(k) if k == "text" then gui[hkey.."qtext"].text = (h.text or "") end end
				end
				if to == "test" then
					h.transform("question").text = "test?"
					h.proc = function(value) if value == true then
						gui[hkey.."testtick"].transform("tick").text = "NotLib.gui test"
						gui[hkey.."testtick"].proc = function(value) gui[hkey.."testline"].visible = value end
						gui[hkey.."testbar"].transform("bar")
						gui[hkey.."testbar"].value,gui[hkey.."testbar"].min,gui[hkey.."testbar"].max = 15,10,20
						gui[hkey.."testslider"].transform("slider").proc = function(value) gui[hkey.."testbar"].value = value end
						gui[hkey.."testslider"].value,gui[hkey.."testslider"].min,gui[hkey.."testslider"].max = 15,10,20
						gui[hkey.."testbutton"].transform("button").proc = function() gui[hkey.."testslider"].value = 15 end
						gui[hkey.."testbutton"].text = "reset"
						gui[hkey.."testline"].transform("line").visible = false
						gui[hkey.."testline"][1],gui[hkey.."testline"][2],gui[hkey.."testline"][3] = gui[hkey.."testbar"],gui[hkey.."testslider"],gui[hkey.."testbutton"]
						gui[hkey.."test"].transform("world").pos = myHero
						gui[hkey.."test"][1],gui[hkey.."test"][2] = gui[hkey.."testtick"],gui[hkey.."testline"]
						h.refresh()
					end end
				end
				return h
			end
			h.disable = function() 
				h.bind.disable()
				for i=1,#h do h[i].disable() end
				gui[hkey] = nil
			end
			h.reset()
			h = setproxytable(h,function(k) 
				if (k == "w" or k == "h") and h.parent() ~= nil then h.parent().refresh()
				elseif k == "value" then h.proc(h.value)
				else
					if k == "visible" then for i=1,#h do h[i].visible = h.visible end
					elseif type(k) == "number" and h[k] ~= nil and h.visible == false then h[k].visible = false end
					h.refresh()
				end
				h.changed(k)
			end)
			gui[hkey] = h
			return gui[hkey]
		end})
		return lib[part]
	end
	if part == "spell" then
		local spell = {}
		for i=SUMMONER_1,SUMMONER_2,(SUMMONER_2-SUMMONER_1) do
			local name = GetSpellData(i).name
			if name == "summonersmite" then spell.smite = i elseif name == "summonerhaste" then spell.ghost = i
			elseif name == "summonerrevive" then spell.revive = i elseif name == "summonerheal" then spell.heal = i
			elseif name == "summonerteleport" then spell.teleport = i elseif name == "summonerflash" then spell.flash = i
			elseif name == "summonerdot" then spell.ignite = i elseif name == "summonerbarrier" then spell.barrier = i
			elseif name == "summonerexhaust" then spell.exhaust = i elseif name == "summonerboost" then spell.cleanse = i
			elseif name == "summonermana" then spell.clarity = i end
		end
		spell.smiteDamage = function(unit)
			unit = unit or myHero
			local damage = 370 + unit.level*20
			if unit.level > 4 then damage = damage+(unit.level-4)*10 end
			if unit.level > 9 then damage = damage+(unit.level-9)*10 end
			if unit.level > 14 then damage = damage+(unit.level-14)*10 end
			return damage
		end
		spell.level = function(list)
			local lev,req = {},{}
			for i=_Q,_R,(_W-_Q) do req[i],lev[i] = 0,GetSpellData(i).level end
			if myHero.charName == "Elise" or myHero.charName == "Karma" or myHero.charName == "Jayce" then lev[_R] = lev[_R]-1 end
			for i=1,#list do
				req[list[i]] = req[list[i]]+1
				if req[list[i]] > lev[list[i]] then LevelSpell(list[i]) return end
			end
		end
		spell.item = function(...)
			local unit,item,usable = myHero,{...},false
			if type(item[1]) == "userdata" then 
				unit = item[1]
				table.remove(item,1)
			end
			if type(item[#item]) == "boolean" then 
				usable = item[#item]
				table.remove(item,#item)
			end
			for i1=1,#item do for i2=ITEM_1,ITEM_7 do 
				if item[i1] == unit:getInventorySlot(i2) and (usable ~= true or unit:CanUseSpell(i2) == READY) then return i2 end
			end end
		end
		spell.buff = function(unit,...)
			local list = {...}
			if type(unit) ~= "userdata" then 
				list[#list+1] = unit 
				unit = myHero
			end
			for i=0,unit.buffCount do
				local buff = unit:getBuff(i)
				if buff.valid then for h=1,#list,1 do if buff.name == list[h] then return true end end end
			end
			return false
		end
		spell.ward = function(wards)
			local slot = spell.item(myHero,3340,3361,2049,2045,3154,2044,true)
			if wards == nil then return slot
			elseif slot ~= nil then
				local pos = lib.object.filter(wards,{first=true,range=600})
				if pos ~= nil and #lib.object("ward",{range=1600,dead=false,unit=pos,visible=true,team=myHero.team}) == 0 then 
					CastSpell(slot,pos.x+math.random(-0.5,0.5),pos.z+math.random(-0.5,0.5)) 
					return true
				end
			end
			return false
		end
		local _buy = {}
		spell.buy = function(id)
			if GetTickCount()/1000-(_buy[id] or 0) > GetLatency()/200 then
				_buy[id] = GetTickCount()/1000
				BuyItem(id)
			end
		end
		spell.itemList = function(list)
			list = list or {}
			list.refresh = function()
				local i=1
				while i <= #list do
					local bought = spell.item(list[i][1])
					for x=3,#list[i],1 do bought = bought or spell.item(list[i][x]) end
					if bought then table.remove(list,i) else i = i + 1 end
				end
			end
			list.buy = function()
				list.refresh()
				if list[1] ~= nil and myHero.gold >= list[1][2] then spell.buy(list[1][1]) end
			end
			list.gold = function()
				list.refresh()
				if #list == 0 then return 0
				else
					local price = 0
					for i=1,#list do price = price + list[i][2] end
					return price
				end
			end
			list.add = function(newList)
				for i=1,#newList do list[#list+1] = newList[i] end
			end
			return list
		end
		spell.move = function(x,z) if type(x) == "number" then myHero:MoveTo(x+math.random(-10,10),z+math.random(-10,10)) else myHero:MoveTo(x.x+math.random(-10,10),x.z+math.random(-10,10)) end end
		spell.range = function(target) return myHero:GetDistance(myHero.minBBox)+target:GetDistance(target.minBBox)+50 end
		spell.follow = function(target) if myHero:GetDistance(target) > target:GetDistance(target.minBBox)+50 then spell.move(target.x,target.z) end end
		spell.OnGainBuff = function(callback) if AddRecvPacketCallback ~= nil then
			AddRecvPacketCallback(function(p) if p.header == 183 then
				p.pos = 1
				local unit = objManager:GetObjectByNetworkId(p:DecodeF())
				if unit ~= nil then 
					local buff = {}
					p.pos = 5
					buff.slot = p:Decode1()+1
					p.pos = 6
					buff.type = p:Decode1()
					p.pos = 7
					buff.visible = (p:Decode1() == 1)
					p.pos = 8
					buff.stack = p:Decode1()
					p.pos = 25
					buff.source = objManager:GetObjectByNetworkId(p:DecodeF())
					local timer = lib.timer[#lib.timer+1]
					timer.callback = function()
						timer.disable()
						buff.name = myHero:getBuff(buff.slot).name
						buff.startT = myHero:getBuff(buff.slot).startT or -math.huge
						buff.endT = myHero:getBuff(buff.slot).endT or math.huge
						buff.duration = buff.endT - buff.startT
						callback(unit,buff)
					end
					timer.start()
				end
			end end)
		end end
		lib[part] = spell
		return lib[part]
	end
	if part == "object" then
		lib[part] = setmetatable({},{__call=function(object,key,param) if param ~= nil then return object.filter(object[key],param) else return object[key] end end,__index=function(object,key)
			if key == "class" then
				object[key] = function(unit)
					local type = unit.type
					if type ==  "obj_Turret" or type == "obj_Levelsizer" or type == "obj_NavPoint" or type ==  "LevelPropSpawnerPoint" 
					or type ==  "LevelPropGameObject" or type == "GrassObject" or type ==  "obj_Lake" or type ==  "obj_LampBulb" or type ==  "DrawFX" then return "useless"
					elseif type ==  "obj_GeneralParticleEmitter" or type == "obj_AI_Marker" or type == "FollowerObject" then return "visual"
					elseif type ==  "obj_AI_Minion" then
						local name = unit.name:lower()
						if name:find("minion") then return "minion"
						elseif name:find("ward") then return "ward"
						elseif (name:find("wolf") or name:find("wraith") or name:find("golem") or name:find("lizard") or name:find("dragon") or name:find("worm") or name:find("spider")) and unit.name:find("%d+%.%d+") then return "creep"
						elseif name:find("buffplat") or name == "odinneutralguardian" then return "point"
						elseif name:find("shrine") or name:find("relic") then return "event"
						elseif unit.bTargetableToTeam == false or unit.bTargetable == false then return "trap" 
						else return "pet" end
					elseif type ==  "obj_AI_Turret" then return "tower"
					elseif type == "AIHeroClient" then return "player"
					elseif type ==  "obj_Shop" then return "shop"
					elseif type ==  "obj_HQ" then return "nexus"
					elseif type ==  "obj_BarracksDampener" then return "inhibitor"
					elseif type ==  "obj_SpawnPoint" then return "spawn"
					elseif type ==  "obj_Barracks" then return "minionSpawn"
					elseif type ==  "NeutralMinionCamp" then return "creepSpawn"
					elseif type ==  "obj_InfoPoint" then return "event"
					elseif type == "SpellMissileClient" or type == "SpellCircleMissileClient" or type == "SpellLineMissileClient" or type == "SpellChainMissileClient" then return "spell" end
					return "error"
				end
				return object[key]
			end
			if key == "map" then
				object[key] = object["allySpawn"]:GetDistance(object["enemySpawn"])
				if object[key] < 12810 then object[key] = "dom" elseif object[key] < 13270 then object[key] = "tt" 
				elseif object[key] < 15185 then object[key] = "pg" elseif object[key] < 19680 then object[key] = "classic" else object[key] = "unknown" end
				return object[key]
			end
			if key == "isTop" then
				local top = {classic={VEC(2000,12500),VEC(1000,1700),VEC(1000,11500),VEC(12500,13250),VEC(3400,13250)},tt={VEC(2121,9000),VEC(13285,9000)}}
				object[key] = function(pos)
					return (object.map == "classic" and (pos:GetDistance(top.classic[1]) <= 1100 or pos:GetDistance(math.proj2d(pos,top.classic[2],top.classic[3])) <= 850 
					or pos:GetDistance(math.proj2d(pos,top.classic[4],top.classic[5])) <= 850)) or (object.map == "tt" and pos:GetDistance(math.proj2d(pos,top.tt[1],top.tt[2])) <= 1300)
				end
				return object[key]
			end
			if key == "isMid" then
				local mid = {classic={VEC(1360,1630),VEC(12570,12810)},tt=VEC(7700,6700),dom=VEC(6900,6460)}
				object[key] = function(pos)
					return (object.map == "classic" and pos:GetDistance(math.proj2d(pos,mid.classic[1],mid.classic[2])) <= 850) or (object.map == "tt" and pos:GetDistance(mid.tt) <= 1100)
					or (object.map == "dom" and pos:GetDistance(mid.dom) <= 1100) or object.map == "pg"
				end
				return object[key]
			end
			if key == "isBot" then
				local bot = {classic={VEC(12100,2175),VEC(1330,1150),VEC(12000,1150),VEC(13100,12850),VEC(13100,3000)},tt={VEC(2121,5600),VEC(13285,5600)}}
				object[key] = function(pos)
					return (object.map == "classic" and (pos:GetDistance(bot.classic[1]) <= 1100 or pos:GetDistance(math.proj2d(pos,bot.classic[2],bot.classic[3])) <= 850 
					or pos:GetDistance(math.proj2d(v,bot.classic[4],bot.classic[5])) <= 850)) or (object.map == "tt" and pos:GetDistance(math.proj2d(pos,bot.tt[1],bot.tt[2])) <= 950)
				end
				return object[key]
			end
			if key == "filter" then
				object[key] = function(units,param)
					param.unit = param.unit or myHero
					local result = {}
					for k,unit in pairs(units) do
						if  (param.visible == nil or unit.visible == param.visible) and (param.targetable == nil or unit.bTargetable == param.targetable) 
						and (param.team == nil or unit.team == param.team) and (param.dead == nil or unit.dead == param.dead)  
						and (param.range == nil or (param.unit.name and param.unit:GetDistance(unit) <= param.range) or unit:GetDistance(param.unit) <= param.range)
						and (param.name == nil or unit.name:lower():find(param.name:lower())) and (param.bot == nil or object.isBot(unit) == param.bot) 
						and (param.mid == nil or object.isMid(unit) == param.mid) and (param.top == nil or object.isTop(unit) == param.top) then result[#result+1] = unit end
					end
					if param.closest == true then
						local closest = result[1]
						for i=1,#result do if result[i]:GetDistance(param.unit) < result[i]:GetDistance(closest) then closest = result[i] end end
						return closest
					elseif param.farthest == true then
						local farthest = result[1]
						for i=1,#result do if result[i]:GetDistance(param.unit) > result[i]:GetDistance(closest) then closest = result[i] end end
						return farthest
					elseif param.first == true then return result[1]
					elseif param.last == true then return result[#result]
					else return result end
				end
				return object[key]
			end
			if key == "allySpawn" then
				object[key] = object("spawn",{team=myHero.team,first=true})
				return object[key]
			end
			if key == "enemySpawn" then
				object[key] = object("spawn",{team=TEAM_ENEMY,first=true})
				return object[key]
			end
			if key:find("%W") then
				local result = {}
				for key in key:gmatch("%w+") do for hash,unit in pairs(object[key]) do result[#result+1] = unit end end
				return result
			end
			if key == "farmCreepSpawn" then
				object[key] = function(cowsep,teleport)
					lib.upgrade()
					local result,resultScore = nil,-math.huge
					for k,creepSpawn in pairs(object.creepSpawn) do if creepSpawn.data.side == myHero.team then
						local creepScore = creepSpawn.data.score(teleport)
						if object.map == "classic" then
							if myHero.level < 3 and k == "owight" then creepScore = 0
							elseif myHero.level < 3 and k == "ogolem" and object.creepSpawn["owraith"].data.alive(teleport) == true then creepScore = 0
							elseif cowsep == true and creepSpawn.data.started() == false then
								if k == "ored" and myHero.level >= 3 and object.creepSpawn["ogolem"].data.alive(teleport) == true then creepScore = 0
								elseif k == "owraith" and myHero.level >= 3 and object.creepSpawn["ogolem"].data.alive(teleport) == true then creepScore = 0
								elseif k == "owolf" and lib.object.creepSpawn["owight"].data.alive(teleport) == true then creepScore = 0
								elseif k == "ogolem" and lib.object.creepSpawn["owraith"].data.alive(teleport) == false then creepScore = creepScore*0.8
								elseif k == "owight" and lib.object.creepSpawn["owolf"].data.alive(teleport) == false then creepScore = creepScore*0.8 end
							end
						end
						if creepScore > resultScore then result,resultScore = creepSpawn,creepScore end
					end end
					return result
				end
				return object[key]
			end
			do -- object collection
				object[key] = {}
				for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit ~= nil and unit.valid == true and object.class(unit) == key then object[key][unit.hash] = unit end end
				AddCreateObjCallback(function(unit) if object.class(unit) == key then object[key][unit.hash] = unit end end)
				AddDeleteObjCallback(function(unit) object[key][unit.hash] = nil end)
				return object[key]
			end
		end})
		return lib[part]
	end
	if part == "upgrade" then
		local upgrade = function(unit)
			if unit.data == nil or unit.data ~= "table" then unit.data = {} end 
			unit.data.class,unit.data.tick=lib.object.class(unit),GetTickCount()/1000
			unit.data = setmetatable(unit.data,{__index=function(data,key)
				if key == "miss" then
					local timer = timer[#timer+1]
					timer.cooldown = 1
					timer.callback = function() if unit.valid == false then timer.disable() elseif unit.visible == true then data[key] = 0 else data[key] = data[key]+1 end end
					timer.start()
					data[key] = 0
					return data[key]
				end
				if key == "spell" then
					local spellHistory = {}
					AddProcessSpellCallback(function(obj,spell) if unit.valid == true and unit.hash == obj.hash then
						local result = {name=spell.name,tick=GetTickCount()/1000,windUpTime=spell.windUpTime,animationTime=spell.animationTime}
						if spell.target ~= nil then result.target = spell.target end
						if spell.pos ~= nil then result.pos = VEC(spell.pos.x,spell.pos.z) end
						if spell.startPos ~= nil then result.pos = VEC(spell.startPos.x,spell.startPos.z) end
						if spell.endPos ~= nil then result.pos = VEC(spell.endPos.x,spell.endPos.z) end
						result.windUp = function() return result.tick+result.windUpTime >= GetTickCount()/1000 end
						result.animation = function() return result.tick+result.animationTime >= GetTickCount()/1000 end
						result.reset = function() spellHistory[result.name] = nil end
						spellHistory[result.name] = result
					end end)
					data[key] = function(name)
						for key,history in pairs(spellHistory) do if key:lower():find(name:lower()) then return history end end
						return {tick=0,windUpTime=0,animationTime=0,windUp = function() return false end,animation = function() return false end,reset = NCB}
					end
					return data[key]
				end
			end})
			if unit.data.class == "creep" then
				unit.data.number = tonumber(unit.name:sub(unit.name:find("%d+"),unit.name:find("%.")-1))
				unit.data.parent = function() for k,creepSpawn in pairs(lib.object.creepSpawn) do if creepSpawn.data.number == unit.data.number then return creepSpawn end end end
			end
			if unit.data.class == "creepSpawn" then
				unit.data.number = tonumber(unit.name:sub(unit.name:find("%d+")))
				unit.data.children = function()
					local result = {}
					for k,creep in pairs(lib.object.creep) do if unit.data.number == creep.data.number then result[#result+1] = creep end end
					return result
				end
				unit.data.name,unit.data.maxCreeps,unit.data.type,unit.data.spawn,unit.data.respawn = "default",math.huge,"creep",120,50
				if lib.object.map == "classic" then
					if unit.data.number == 6 then unit.data.name,unit.data.maxCreeps,unit.data.type,unit.data.spawn,unit.data.respawn = "dragon",1,"objective",150,360
					elseif unit.data.number == 12 then unit.data.name,unit.data.maxCreeps,unit.data.type,unit.data.spawn,unit.data.respawn = "nashor",1,"objective",750,420
					elseif unit.data.number == 1 or unit.data.number == 7 then unit.data.name,unit.data.maxCreeps,unit.data.type,unit.data.spawn,unit.data.respawn = "blue",3,"buff",115,300
					elseif unit.data.number == 4 or unit.data.number == 10  then unit.data.name,unit.data.maxCreeps,unit.data.type,unit.data.spawn,unit.data.respawn = "red",3,"buff",115,300
					elseif unit.data.number == 13 or unit.data.number == 14 then unit.data.name,unit.data.maxCreeps = "wight",1
					elseif unit.data.number == 2 or unit.data.number == 8 then unit.data.name,unit.data.maxCreeps = "wolf",3
					elseif unit.data.number == 3 or unit.data.number == 9  then unit.data.name,unit.data.maxCreeps = "wraith",4
					elseif unit.data.number == 5 or unit.data.number == 11 then unit.data.name,unit.data.maxCreeps = "golem",2 end
				end
				unit.data.side = unit:GetDistance(lib.object.allySpawn) - unit:GetDistance(lib.object.enemySpawn)
				if unit.data.side > 1000 then unit.data.side = TEAM_ENEMY elseif unit.data.side < -1000 then unit.data.side = myHero.team else unit.data.side = TEAM_NEUTRAL end
				unit.data.target = function(cleave)
					local target,red = nil,lib.spell.buff("blessingofthelizardelder")
					for k,creep in pairs(unit.data.children()) do if creep.visible == true and creep.dead == false then 
						if target == nil then target = creep
						elseif red == true and unit.data.name ~= "red" and unit.data.name ~= "blue" and (lib.spell.buff(target,"blessingofthelizardelderslow") == true or lib.spell.buff(creep,"blessingofthelizardelderslow") == true) then
							if lib.spell.buff(target,"blessingofthelizardelderslow") == true and lib.spell.buff(creep,"blessingofthelizardelderslow") == false then target = creep end
						elseif (cleave == true or unit.data.name == "red" or unit.data.name == "blue") and creep.maxHealth > target.maxHealth then target = creep 
						elseif cleave ~= true and unit.data.name ~= "red" and unit.data.name ~= "blue" and creep.maxHealth < target.maxHealth then target = creep
						elseif creep.maxHealth == target.maxHealth and creep.networkID > target.networkID then target = creep end
					end end
					return target
				end
				unit.data.health = function(target,range)
					range = range or math.huge
					local health = 0
					for k,creep in pairs(unit.data.children()) do
						if creep.visible == true and creep.dead == false and (target == nil or range == nil or target:GetDistance(creep) <= range) then health = health+creep.health end
					end
					return health
				end
				unit.data.started = function()
					for k,creep in pairs(unit.data.children()) do
						if creep.visible == true and creep.dead == false and creep.health < creep.maxHealth then return true end
					end
					return false
				end
				unit.data.composition = function(target,range) return #lib.object.filter(unit.data.children(),{range=range,visible=true,targetable=true,dead=false,unit=target}) end
				unit.data.gold = function()
					if lib.object.map == "classic" then
						if unit.data.name == "wight" then return 65+myHero.level*0.94
						elseif unit.data.name == "blue" or unit.data.name == "red" then return 74+(GetInGameTimer()-unit.data.spawn)*0.332/60
						elseif unit.data.name == "wolf" then return 57+myHero.level*0.8
						elseif unit.data.name == "wraith" then return 48.5+myHero.level*0.67
						elseif unit.data.name == "golem" then return 70+myHero.level*0.99 
						elseif unit.data.name == "dragon" then return 205+math.min(90,myHero.level*10)
						elseif unit.data.name == "nashor" then return 300 end
					end
					return 0
				end
				unit.data.respawnTime = function() if unit.data.dead ~= true then return 0 else return unit.data.timer+unit.data.respawn+1-GetInGameTimer() end end
				unit.data.alive = function(teleport) if teleport == true then return unit.data.respawnTime() < 5 else return unit.data.respawnTime() < (2+myHero:GetDistance(unit)/myHero.ms) end end
				unit.data.score = function(teleport) if teleport == true then return unit.data.gold()/math.max(unit.data.respawnTime()*1.4,5) else return unit.data.gold()/math.max(unit.data.respawnTime()*1.4,2+myHero:GetDistance(unit)/myHero.ms) end end
				if AddRecvPacketCallback ~= nil then AddRecvPacketCallback(function(packet)
					if packet.header == 195 then -- creepSpawn despawn
						packet.pos = 9
						if unit.data.number == packet:Decode1() then unit.data.dead,unit.data.timer = true,GetInGameTimer() end
					elseif packet.header == 233 then -- creepSpawn respawn
						packet.pos = 21
						if unit.data.number == packet:Decode1() then unit.data.dead,unit.data.timer = false,GetInGameTimer() end
					elseif unit.data.dead == nil and packet.header == 174 then -- creep vision
						packet.pos = 1
						local id = packet:DecodeF()
						for k,creep in pairs(unit.data.children()) do if creep.networkID == id then unit.data.dead,unit.data.timer = false,GetInGameTimer() end end
					end
				end) end
			end
		end
		lib[part] = function()
			lib[part] = function() end
			-- init
			for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit ~= nil and unit.valid == true then upgrade(unit) end end
			AddCreateObjCallback(upgrade)
			do -- additional creepSpawn routine
			local timer = lib.timer[#lib.timer+1]
			timer.callback = function()
				local checker = true
				for k,creepSpawn in pairs(lib.object.creepSpawn) do if creepSpawn.data.dead == nil and GetInGameTimer() > creepSpawn.data.spawn+1 then
				checker = false
				if myHero:GetDistance(creepSpawn) <= 285 and creepSpawn.data.target() == nil then creepSpawn.data.dead,creepSpawn.data.timer = true,GetInGameTimer() end
				end end
				if checker == true then timer.disable() end
			end
			timer.start(true)
			local rename = {}
			for k,creepSpawn in pairs(lib.object.creepSpawn) do 
				if creepSpawn.data.name == "nashor" or creepSpawn.data.name == "dragon" then rename[creepSpawn.data.name] = creepSpawn
				elseif creepSpawn.data.side == myHero.team then rename["o"..creepSpawn.data.name] = creepSpawn
				else rename["e"..creepSpawn.data.name] = creepSpawn end
			end
			lib.object.creepSpawn = rename
			end
		end
		return lib[part]
	end
	if part == "smite" then
		lib[part] = function() if lib.spell.smite ~= nil and myHero:CanUseSpell(lib.spell.smite) == READY then
			local damage = lib.spell.smiteDamage()
			for k,creep in pairs(lib.object("creep",{dead=false,targetable=true,visible=true,range=850})) do
				local name = creep.data.parent().data.name
				if (name == "red" or name == "blue" or name == "dragon" or name == "nashor") 
				and creep.maxHealth > damage*2 and creep.health <= damage then CastSpell(lib.spell.smite,creep) end
			end
		end end
		return lib[part]
	end
	if part == "potion" then
		local last,cacheHP,cacheMP = -math.huge,myHero.health,myHero.mana
		lib[part] = function() if GetTickCount()/1000-last > 0.2 then
			if myHero.health < cacheHP and myHero.health/myHero.maxHealth < 0.45 and lib.spell.buff("ItemCrystalFlask","RegenerationPotion","ItemMiniRegenPotion") == false then
				local item = lib.spell.item(2041,2003,2010,2009,true)
				if item ~= nil then CastSpell(item) last = GetTickCount()/1000 end
			end
			if myHero.parType == 0 and myHero.mana < cacheMP and myHero.mana/myHero.maxMana < 0.33 and lib.spell.buff("ItemCrystalFlask","FlaskOfCrystalWater") == false then
				local item =  lib.spell.item(2041,2004,true)
				if item ~= nil then CastSpell(item) last = GetTickCount()/1000 end
			end
			cacheHP,cacheMP = myHero.health,myHero.mana
		end end
		return lib[part]
	end
end})

--UPDATEURL=
--HASH=BB08388116106856DFE83F28C8D0748A
