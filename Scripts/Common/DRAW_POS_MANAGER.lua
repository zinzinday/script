local version = "0.20"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/fter44/ilikeman/master/common/DRAW_POS_MANAGER.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."DRAW_POS_MANAGER.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>DRAW_POS_MANAGER:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/fter44/ilikeman/master/VersionFiles/DRAW_POS_MANAGER.version".."?rand="..math.random(1,10000))
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

--[[
█████████████████╗  ██████████╗    ██████╗     ██████╗     ██████╗ ██████╗███████╗
╚══██╔══██╔════╚██╗██╔╚══██╔══╝    ╚════██╗    ██╔══██╗    ██╔══████╔═══████╔════╝
   ██║  █████╗  ╚███╔╝   ██║        █████╔╝    ██║  ██║    ██████╔██║   █████████╗
   ██║  ██╔══╝  ██╔██╗   ██║       ██╔═══╝     ██║  ██║    ██╔═══╝██║   ██╚════██║
   ██║  █████████╔╝ ██╗  ██║       ███████╗    ██████╔╝    ██║    ╚██████╔███████║
   ╚═╝  ╚══════╚═╝  ╚═╝  ╚═╝       ╚══════╝    ╚═════╝     ╚═╝     ╚═════╝╚══════╝
   XD
--]]
class "TEXTPOS_A"--{
function TEXTPOS_A:__init(menu,text,size,x,y,timer)
	assert(menu~=nil,"TEXTPOS_A: menu shouldn't be nil value")
	self.menu=menu
	menu:addParam("on","enable draw",SCRIPT_PARAM_ONOFF,true) 
	menu:addParam("set","Set Text Position",SCRIPT_PARAM_ONOFF,false) 
	menu:addParam("x","x",SCRIPT_PARAM_SLICE,x or 50,0,WINDOW_W)
	menu:addParam("y","y",SCRIPT_PARAM_SLICE,y or 50,0,WINDOW_H)
	menu:addParam("size","size",SCRIPT_PARAM_SLICE, size or 12, 0, 60)
	menu:addParam("color","color", SCRIPT_PARAM_COLOR,{255,0,0,255})
	menu.set=false
	
	self.text=text
	if timer then
		AddTickCallback(function() self:Ontick() end)
	end
	AddMsgCallback(function(msg,key) self:OnWndMsg(msg,key) end)
	AddDrawCallback(function() self:OnDraw() end)
end
function TEXTPOS_A:COUNTDOWN_START(time)
	self.time=true
	self.endT=os.clock()+time
	self.text=tostring( time )
	self.lasttick=os.clock()
end
function TEXTPOS_A:COUNTDOWN_END(time)
	self.time=false self.text=nil
end
function TEXTPOS_A:SET_TEXT(str,size,TARGB,x,y)
	if str then
		self.text=tostring(str)
	end
	if size then
	self.menu.size=size
	end
	if TARGB then
		self.menu.color = TARGB
	end
	if x and y then
		self.menu.x,self.menu.y=x,y
	end
end
function TEXTPOS_A:SET_SIZE(size)
	self.menu.size=size
end
function TEXTPOS_A:SET_COLOR(TARGB)
	if type(TARGB)=="table" then
		self.menu.color = TARGB
	end
end
function TEXTPOS_A:Ontick()
	if self.time and os.clock() - self.lasttick >= 0.1 then
		local remains=self.endT-os.clock()
		self.text=string.format('%.1f',remains)
		self.lasttick=os.clock()
		if remains==0 then self.time=false end
	end
end
function TEXTPOS_A:OnWndMsg(msg,key)
	if self.menu.set then
		if msg==WM_LBUTTONDOWN and IsKeyDown(16) then
			self.menu.x,self.menu.y=GetCursorPos().x, GetCursorPos().y			
			self.menu.set=false
			self.menu:save()
		end
	end
end
function TEXTPOS_A:OnDraw()
	if self.menu.set then
		DrawTextA("SET MOUSE TO DESIRED POSITION AND PRESS LBUTTON and SHIFT",25,WINDOW_W/2,WINDOW_H/2,_,"center","center")
	end
	if self.menu.on and self.text then
		DrawTextA(self.text, self.menu.size, self.menu.x, self.menu.y,ARGB(self.menu.color[1],self.menu.color[2],self.menu.color[3],self.menu.color[4]))
	end
end--}
--[[
█████████████████╗  ██████████╗    ██████╗     ██████╗     ██████╗ ██████╗███████╗
╚══██╔══██╔════╚██╗██╔╚══██╔══╝    ╚════██╗    ██╔══██╗    ██╔══████╔═══████╔════╝
   ██║  █████╗  ╚███╔╝   ██║        █████╔╝    ██║  ██║    ██████╔██║   █████████╗
   ██║  ██╔══╝  ██╔██╗   ██║        ╚═══██╗    ██║  ██║    ██╔═══╝██║   ██╚════██║
   ██║  █████████╔╝ ██╗  ██║       ██████╔╝    ██████╔╝    ██║    ╚██████╔███████║
   ╚═╝  ╚══════╚═╝  ╚═╝  ╚═╝       ╚═════╝     ╚═════╝     ╚═╝     ╚═════╝╚══════╝
                                                                                  
--]]
class "TEXTPOS_3D"--{
function TEXTPOS_3D:__init(menu,text,size,x,y,z,timer)
	self.menu=menu
	menu:addParam("on","enable draw",SCRIPT_PARAM_ONOFF,true) 
	menu:addParam("set","Set Text Position",SCRIPT_PARAM_ONOFF,false)	
	menu:addParam("x","x",SCRIPT_PARAM_SLICE,x or 0,0,10000)
	menu:addParam("y","y",SCRIPT_PARAM_SLICE,y or 0,0,10000)
	menu:addParam("z","z",SCRIPT_PARAM_SLICE,z or 0,0,10000)
	menu:addParam("size","size",SCRIPT_PARAM_SLICE, size or 12, 0, 60)
	menu:addParam("color","color", SCRIPT_PARAM_COLOR,{255,0,0,255})
	menu.set=false
	self.text=text
	if timer then
		self.timer=true
		AddTickCallback(function() self:Ontick() end)
	end
	AddMsgCallback(function(msg,key) self:OnWndMsg(msg,key) end)
	AddDrawCallback(function() self:OnDraw() end)
end
function TEXTPOS_3D:COUNTDOWN_START(time)
	self.time=true
	self.endT=os.clock()+time
	self.text=tostring( time )
	self.lasttick=os.clock()
end
function TEXTPOS_3D:COUNTDOWN_END(time)
	self.time=false self.text=nil
end
function TEXTPOS_3D:SET_TEXT(str)
	if str then
		self.text=tostring( str )
	end
end
function TEXTPOS_3D:Ontick()
	if self.time and os.clock() - self.lasttick >= 0.1 then
		local remains=self.endT-os.clock()
		self.text=string.format('%.1f',remains)
		self.lasttick=os.clock()
		if remains==0 then self.time=false end
	end
end
function TEXTPOS_3D:OnWndMsg(msg,key)
	if self.menu.set then
		if msg==WM_LBUTTONDOWN and IsKeyDown(16) then
			self.menu.x,self.menu.z = mousePos.x, mousePos.z
			self.menu.set=false
			self.menu:save()
		end
	end
end
function TEXTPOS_3D:OnDraw()
	if self.menu.set then
		DrawTextA("SET MOUSE TO DESIRED POSITION AND PRESS LBUTTON and SHIFT",25,WINDOW_W/2,WINDOW_H/2,_,"center","center")
	end
	if self.menu.on and self.text then
		DrawText3D(self.text,self.menu.x, self.menu.y, self.menu.z, self.menu.size,ARGB(self.menu.color[1],self.menu.color[2],self.menu.color[3],self.menu.color[4]),true)
	end
end
--}
--[[
█████████████████╗  ██████████╗     ██████╗     ██████╗          ██╗    ██████╗ ██████╗███████╗
╚══██╔══██╔════╚██╗██╔╚══██╔══╝    ██╔═══██╗    ██╔══██╗         ██║    ██╔══████╔═══████╔════╝
   ██║  █████╗  ╚███╔╝   ██║       ██║   ██║    ██████╔╝         ██║    ██████╔██║   █████████╗
   ██║  ██╔══╝  ██╔██╗   ██║       ██║   ██║    ██╔══██╗    ██   ██║    ██╔═══╝██║   ██╚════██║
   ██║  █████████╔╝ ██╗  ██║       ╚██████╔╝    ██████╔╝    ╚█████╔╝    ██║    ╚██████╔███████║
   ╚═╝  ╚══════╚═╝  ╚═╝  ╚═╝        ╚═════╝     ╚═════╝      ╚════╝     ╚═╝     ╚═════╝╚══════╝
                                                                                               
--]]
class "TEXTPOS_OBJS"--{
function TEXTPOS_OBJS:__init(menu,size,x,y)
	self.menu=menu
	menu:addParam("on","enable draw",SCRIPT_PARAM_ONOFF,true) 
	menu:addParam("x","x",SCRIPT_PARAM_SLICE, x or 0, -1000,1000)
	menu:addParam("y","y",SCRIPT_PARAM_SLICE, y or 0, -1000,1000)
	menu:addParam("size","size",SCRIPT_PARAM_SLICE, size or 12, 0, 60)
	menu:addParam("color","color", SCRIPT_PARAM_COLOR,{255,0,0,255})
	
	self.texts={}
	self.objs={}
	AddDrawCallback(function() self:OnDraw() end)
end
function TEXTPOS_OBJS:SET_TEXT(obj,txt)
	self.objs[obj.networkID]=obj
	self.texts[obj.networkID]=txt
end
function TEXTPOS_OBJS:OnDraw()
	if self.menu.on then
		for networkID,text in pairs(self.texts) do
			local obj=self.objs[networkID] -- local obj = objManager:getobjbyNetworkID(networkID) which is faster?
			if text and obj and obj.valid and not obj.dead and obj.visible then
				DrawText3D(text,obj.x+self.menu.x, obj.y, obj.z+self.menu.y, self.menu.size,ARGB(self.menu.color[1],self.menu.color[2],self.menu.color[3],self.menu.color[4]),true)
			end
		end
	end
end
--}
--[[
████████╗███████╗██╗  ██╗████████╗    ██╗  ██╗██████╗ ██████╗  █████╗ ██████╗     ██████╗  ██████╗ ███████╗
╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝    ██║  ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔═══██╗██╔════╝
   ██║   █████╗   ╚███╔╝    ██║       ███████║██████╔╝██████╔╝███████║██████╔╝    ██████╔╝██║   ██║███████╗
   ██║   ██╔══╝   ██╔██╗    ██║       ██╔══██║██╔═══╝ ██╔══██╗██╔══██║██╔══██╗    ██╔═══╝ ██║   ██║╚════██║
   ██║   ███████╗██╔╝ ██╗   ██║       ██║  ██║██║     ██████╔╝██║  ██║██║  ██║    ██║     ╚██████╔╝███████║
   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝╚═╝     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝      ╚═════╝ ╚══════╝
                                                                                                           
--]]
class "TEXTPOS_HPBAR"--{
function TEXTPOS_HPBAR:__init(menu,size,x,y)
	self.menu=menu
	menu:addParam("on","enable draw",SCRIPT_PARAM_ONOFF,true) 
	menu:addParam("x","x",SCRIPT_PARAM_SLICE, x or 0, -200,200)
	menu:addParam("y","y",SCRIPT_PARAM_SLICE, y or 0, -200,200)
	menu:addParam("size","size",SCRIPT_PARAM_SLICE, size or 12, 0, 60)
	menu:addParam("color","color", SCRIPT_PARAM_COLOR,{255,0,0,255})
	
	self.texts={}
	self.objs={}
	AddDrawCallback(function() self:OnDraw() end)
end
function TEXTPOS_HPBAR:SET_TEXT(obj,txt)
	local networkID=obj.networkID
	if self.objs[networkID]==nil then
		self.objs[networkID]=obj
	end
	if txt then
		self.texts[networkID]=tostring(txt)
	end
end
function TEXTPOS_HPBAR:OnDraw()
	if self.menu.on then
		for networkID,text in pairs(self.texts) do
			local obj=self.objs[networkID] -- local obj = objManager:getobjbyNetworkID(networkID) which is faster?
			if text and obj and obj.valid and not obj.dead and obj.visible then
				local pos=GetHPBarPos(obj)
				if not pos then 
					return 
				end
				DrawTextA(text,self.menu.size,pos.x+self.menu.x,pos.y+self.menu.y,ARGB(self.menu.color[1],self.menu.color[2],self.menu.color[3],self.menu.color[4]),"center","center")
			end
		end
	end
end--}
--[[Returns the healthbar position]]
for _,hero in pairs(GetEnemyHeroes()) do
	hero.barData = {PercentageOffset = {x = 0, y = 0} }--GetEnemyBarData()
end
for _,hero in pairs(GetAllyHeroes()) do
	hero.barData = {PercentageOffset = {x = 0, y = 0} }--GetEnemyBarData()
end
function GetHPBarPos(enemy)
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local CorrectionX = 31
	
	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
						
	local StartPos = Point(barPos.x , barPos.y)
	local EndPos =  Point(barPos.x + 108 , barPos.y)
	return StartPos,EndPos
end
