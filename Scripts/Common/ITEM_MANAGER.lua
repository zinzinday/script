local version = "0.31"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/fter44/ilikeman/master/common/ITEM_MANAGER.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."ITEM_MANAGER.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>ITEM_MANAGER:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/fter44/ilikeman/master/VersionFiles/ITEM_MANAGER.version".."?rand="..math.random(1,10000))
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


function scriptConfig:removeParam(pVar)
    assert(type(pVar) == "string" and self[pVar] ~= nil, "removeParam: existing pVar expected)")
    for index, param in ipairs(self._param) do
        if param.var == pVar then
			self._param[index]=nil
        end
    end
	self[pVar]=nil
end







local print_colors={
	["CYAN"]="#67FECC",
	["PURPLE"]="#9A68FD",
	["RED"]="#9B0911",
	["PINK"]="#FD68A6",
	["BLACK"]="#000018",
	["BLUE"]="#0000FF",
	["WHITE"]="#FFFFFF",
	["YELLOW"]="#FFFF00",
}
function Color_Print_I(title,color,msg)
	print('<font color="'..print_colors[color]..'"><b>'..title..':</b></font><font color=\"#FFFFFF\">'..msg..".</font>")
end
function Color_Print_II(msg,color)
	print('<font color="'..print_colors[color]..'"><b>'..msg..':</b></font>')
end
--MANAGE BUY_ITEM,REMOVE_ITEM
class "ITEM_MANAGER"--{
local ITEM_MANAGER_OFFENSIVE_AD_TARGET = {
	--[1042]={name='Dagger'}, --test purpose
	--[2003]={name='Health Potion'},--test purpose
	[3153]={rangeSqr = 500*500, name="BRK[AD]"},--AD 몰왕검	
	[3144]={rangeSqr = 450*450, name="BWC[AD]"},--AD 빌지워터	
	--[3146]={rangeSqr = 700*700, name="HXG[AD]"},--AP AD
	--[3184]={rangeSqr = 350*350, name="ENT[AD]"},--AD NOT SR
}
local ITEM_MANAGER_OFFENSIVE_AP_TARGET = {
	--[1042]={name='Dagger'}, --test purpose
	--[2003]={name='Health Potion'},--test purpose
	[3128]={rangeSqr = 750*750, name="DFG[AP]" },
	[3146]={rangeSqr = 700*700, name="HXG[AP]" },--AP AD
	--[3180]={rangeSqr = 525*525, name="ODYNVEIL[AP]"}, NOT SR
	--[3188]={rangeSqr = 750*750, name="BLACKFIRE[AP]"}, NOT SR
}
local ITEM_MANAGER_OFFENSIVE_AD_NONTARGET = {	
	[3131]={rangeSqr = 200*200,name="DVN[AD]"},	--AD CRITICAL 신성의검	
	[3074]={rangeSqr = 350*350,name="HYDRA[AD]" },		--AD
	[3077]={rangeSqr = 350*350,name="TIAMAT[AD]" },		--AD	
	[3142]={rangeSqr = 350*350,name="YGB[AD]" },		--AD요우무
}
local ITEM_MANAGER_OFFENSIVE_AP_NONTARGET = {
}
function ITEM_MANAGER:__init(menu,STS,disable)
	self.OFFENSIVE_AD_TARGET={} --[id]=slot
	self.OFFENSIVE_AD_NONTARGET={}  self.TIAMAT=3077	self.OFFENSIVE_AP_TARGET={}		self.HYDRA=3074
	self.OFFENSIVE_AP_NONTARGET={}
	self.STS=STS
	self.lasttick=0
	
	
	
	
	if not disable then
		AddTickCallback(function() self:OnTick_CAST() end)
	end
	if false and VIP_USER then		
		local PKT_S2C_BuyItemAns=0x6E
		AddRecvPacketCallback(function(p)
			if p.header == PKT_S2C_BuyItemAns then
				p.pos=1
				local networkId=p:DecodeF()
				local id=p:Decode2()
				p.pos=p.pos+2
				local slot = p:Decode1()+4				
				--print("Bought id : "..id.." slot : "..slot)
				if networkId~=myHero.networkID then 
					return 
				end
				self:ADD_OFFENSIVE_AD_TARGET(id,slot)
				self:ADD_OFFENSIVE_AD_NONTARGET(id,slot)
				self:ADD_OFFENSIVE_AP_TARGET(id,slot)
			elseif p.header == Packet.headers.PKT_RemoveItemAns then
				local packet = Packet(p)				
				local slot=packet:get("slotId")
				--print("Removed slot : "..slot)
				if packet:get("networkId")~=myHero.networkID then 
					return 
				end
				self:REMOVE_OFFENSIVE_AD_TARGET(slot)
				self:REMOVE_OFFENSIVE_AD_NONTARGET(slot)
				self:REMOVE_OFFENSIVE_AP_TARGET(slot)
			elseif p.header == Packet.headers.PKT_SwapItemAns then
				local packet = Packet(p)
				local S_from,S_to = packet:get("sourceSlotId"),packet:get("targetSlotId")
				--print("SWAP from : "..S_from.." to "..S_to)
				if packet:get("networkId")~=myHero.networkID then 
					return 
				end
				DelayAction( function()
					self:UPDATE_SLOTS() 
				end)
			end
		end)
	else
		AddTickCallback(function() self:OnTick_CHECK() end)	
	end
	if menu then
		self:LoadToMenu(menu,STS,disable)
	end
	
	self:OnTick_CHECK()
end
function ITEM_MANAGER:LoadToMenu(menu,STS,disable)
	assert(STS~=nil,"SET [#2:STS] VALUE")
	self.STS=STS
	if self.menu then   --menu already registered
		return 
	end
	self.menu=menu
	menu:addSubMenu("OFFENSIVES","OFFENSIVES")
	menu:addSubMenu("DEFENSIVES","DEVENSIVES")


	self.forceAO_N=1
	menu:addParam("forceAO","FORCE ALL Offs",SCRIPT_PARAM_ONKEYTOGGLE, false, 48,_,_,function()
		if self.menu.forceAO then
			self.forceAO=true
			if self.menu.AutoDisable then
				DelayAction(function()
					local forceAO_N=self.forceAO_N
					if self.menu.forceAO and self.forceAO_N==forceAO_N then
						self.menu.forceAO=false
						self.forceAO=false
						Color_Print_I("ITEM_MANAGER","PINK","Force ALL Offs Disabled Automatically")	
					end
				end,menu.disableforceAO) self.forceAO_N=self.forceAO_N+1
			end
		else
			self.forceAO=false
		end
	end) menu:permaShow("forceAO") 
	menu:addParam("disableforceAO","Auto Disable ^ after", SCRIPT_PARAM_SLICE, 60, 0, 120)
	menu:addParam("AutoDisable","^Enable AutoDisable",SCRIPT_PARAM_ONOFF,true)
	menu:addParam("reload","Reload Items",SCRIPT_PARAM_ONOFF,false,_,_,_,function()
		if self.menu.reload then
			self.menu.reload=false
			for _,slot in pairs({ ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6}) do				
				self:REMOVE_OFFENSIVE_AD_TARGET(slot)
				self:REMOVE_OFFENSIVE_AD_NONTARGET(slot)
				self:REMOVE_OFFENSIVE_AP_TARGET(slot)
			end
			self.lasttick=0
			self:OnTick_CHECK()
		end
	end)
	if not disable then
		menu:addParam("castOffAD","CAST OFFENSIVE AD",SCRIPT_PARAM_ONKEYDOWN,false,32)
		menu:addParam("castOffAP","CAST OFFENSIVE AP",SCRIPT_PARAM_ONKEYDOWN,false,32)
	end
	
	
	self.menu=menu
	
	return self
end
--ADD ITEMS
function ITEM_MANAGER:UPDATE_SLOTS()
	for id,slot in pairs(self.OFFENSIVE_AD_TARGET) do
		local new_slot=GetInventorySlotItem(id)
		if self.OFFENSIVE_AD_TARGET[id]~= new_slot then
			local info = ITEM_MANAGER_OFFENSIVE_AD_TARGET[id]
			self.OFFENSIVE_AD_TARGET[id]=new_slot
			Color_Print_I("ITEM_MANAGER","PINK",info.name.." slot changed")
		end
	end
	for id,slot in pairs(self.OFFENSIVE_AD_NONTARGET) do		
		local new_slot=GetInventorySlotItem(id)
		if self.OFFENSIVE_AD_NONTARGET[id]~= new_slot then
			local info = ITEM_MANAGER_OFFENSIVE_AD_NONTARGET[id]
			self.OFFENSIVE_AD_NONTARGET[id]=new_slot
			Color_Print_I("ITEM_MANAGER","PINK",info.name.." slot changed")
		end
	end
	for id,slot in pairs(self.OFFENSIVE_AP_TARGET) do		
		local new_slot=GetInventorySlotItem(id)
		if self.OFFENSIVE_AP_TARGET[id]~= new_slot then
			local info = ITEM_MANAGER_OFFENSIVE_AP_TARGET[id]
			self.OFFENSIVE_AP_TARGET[id]=new_slot
			Color_Print_I("ITEM_MANAGER","PINK",info.name.." slot changed")
		end
	end
end
function ITEM_MANAGER:ADD_OFFENSIVE_AD_TARGET(id,slot)
	if not ITEM_MANAGER_OFFENSIVE_AD_TARGET[id] then return end
	local info = ITEM_MANAGER_OFFENSIVE_AD_TARGET[id]
	self.OFFENSIVE_AD_TARGET[id] = slot or GetInventorySlotItem(id)
	self.menu.OFFENSIVES:addParam(tostring(id),info.name,SCRIPT_PARAM_ONOFF,true)			
	Color_Print_I("ITEM_MANAGER","PINK",info.name.." added state:"..tostring(self.menu.OFFENSIVES[tostring(id)]))		
end
function ITEM_MANAGER:ADD_OFFENSIVE_AD_NONTARGET(id,slot)
	if not ITEM_MANAGER_OFFENSIVE_AD_NONTARGET[id] then return end
	local info = ITEM_MANAGER_OFFENSIVE_AD_NONTARGET[id]
	self.OFFENSIVE_AD_NONTARGET[id] = slot or GetInventorySlotItem(id)				
	self.menu.OFFENSIVES:addParam(tostring(id),info.name,SCRIPT_PARAM_ONOFF,true)					
	Color_Print_I("ITEM_MANAGER","PINK",info.name.." added state:"..tostring(self.menu.OFFENSIVES[tostring(id)]))	
end
function ITEM_MANAGER:ADD_OFFENSIVE_AP_TARGET(id,slot)
	if not ITEM_MANAGER_OFFENSIVE_AP_TARGET[id] then return end
	local info = ITEM_MANAGER_OFFENSIVE_AP_TARGET[id]
	self.OFFENSIVE_AP_TARGET[id] = slot or GetInventorySlotItem(id)		
	self.menu.OFFENSIVES:addParam(tostring(id),info.name,SCRIPT_PARAM_ONOFF,true)					
	Color_Print_I("ITEM_MANAGER","PINK",info.name.." added state:"..tostring(self.menu.OFFENSIVES[tostring(id)]))	
end
--REMOVE ITEMS
function ITEM_MANAGER:REMOVE_OFFENSIVE_AD_TARGET(slot)
	local id = player:getInventorySlot(slot)
	local info = ITEM_MANAGER_OFFENSIVE_AD_TARGET[id]
	if not info then return end
	if self.menu.OFFENSIVES[tostring(id)] then
		self.menu.OFFENSIVES:removeParam(tostring(id))
		self.OFFENSIVE_AD_TARGET[id] = nil				
		Color_Print_I("ITEM_MANAGER","PINK",info.name.." removed")
	end
end
function ITEM_MANAGER:REMOVE_OFFENSIVE_AD_NONTARGET(slot)
	local id = player:getInventorySlot(slot)
	local info = ITEM_MANAGER_OFFENSIVE_AD_NONTARGET[id]
	if not info then return end
	if self.menu.OFFENSIVES[tostring(id)] then
		self.menu.OFFENSIVES:removeParam(tostring(id))
		self.OFFENSIVE_AD_NONTARGET[id] = nil				
		Color_Print_I("ITEM_MANAGER","PINK",info.name.." removed")	
	end
end
function ITEM_MANAGER:REMOVE_OFFENSIVE_AP_TARGET(slot)
	local id = player:getInventorySlot(slot)
	local info = ITEM_MANAGER_OFFENSIVE_AP_TARGET[id]
	if not info then return end
	if self.menu.OFFENSIVES[tostring(id)] then
		self.menu.OFFENSIVES:removeParam(tostring(id))
		self.OFFENSIVE_AP_TARGET[id] = nil				
		Color_Print_I("ITEM_MANAGER","PINK",info.name.." removed")	
	end
end
function ITEM_MANAGER:OnTick_CHECK() --CHECK BUY,REMOVE ITEMS  && Disable Auto Disable "force all offensiveS"  && slot change
	assert(self.menu~=nil, "Register ITEM_MANAGER:menu by :LoadMenu(menu)")
	if os.clock()-self.lasttick<1 then return end
	
	
	--CHECK ITEMS
	--[[
	 ▒█████   █████▒█████▓█████ ███▄    █  ██████ ██▓██▒   █▓█████  ██████ 
	▒██▒  ██▓██   ▓██   ▒▓█   ▀ ██ ▀█   █▒██    ▒▓██▓██░   █▓█   ▀▒██    ▒ 
	▒██░  ██▒████ ▒████ ░▒███  ▓██  ▀█ ██░ ▓██▄  ▒██▒▓██  █▒▒███  ░ ▓██▄   
	▒██   ██░▓█▒  ░▓█▒  ░▒▓█  ▄▓██▒  ▐▌██▒ ▒   ██░██░ ▒██ █░▒▓█  ▄  ▒   ██▒
	░ ████▓▒░▒█░  ░▒█░   ░▒████▒██░   ▓██▒██████▒░██░  ▒▀█░ ░▒████▒██████▒▒
	░ ▒░▒░▒░ ▒ ░   ▒ ░   ░░ ▒░ ░ ▒░   ▒ ▒▒ ▒▓▒ ▒ ░▓    ░ ▐░ ░░ ▒░ ▒ ▒▓▒ ▒ ░
	  ░ ▒ ▒░ ░     ░      ░ ░  ░ ░░   ░ ▒░ ░▒  ░ ░▒ ░  ░ ░░  ░ ░  ░ ░▒  ░ ░
	░ ░ ░ ▒  ░ ░   ░ ░      ░     ░   ░ ░░  ░  ░  ▒ ░    ░░    ░  ░  ░  ░  
		░ ░                 ░  ░        ░      ░  ░       ░    ░  ░     ░  
														 ░                 
	--]]
	--AD TARGET
	for id,info in pairs(ITEM_MANAGER_OFFENSIVE_AD_TARGET) do
		if self.OFFENSIVE_AD_TARGET[id]==nil then --not yet have
			if GetInventoryHaveItem(id) then  -- now have item
				self:ADD_OFFENSIVE_AD_TARGET(id)
			end
		else -- have before
			if not GetInventoryHaveItem(id) then  -- now dont have item
				local slot = self.OFFENSIVE_AD_TARGET[id]
				self:REMOVE_OFFENSIVE_AD_TARGET(slot)
			end
		end
	end
	-- AD NonTarget_Items
	for id,info in pairs(ITEM_MANAGER_OFFENSIVE_AD_NONTARGET) do
		if self.OFFENSIVE_AD_NONTARGET[id]==nil then --not yet have
			if GetInventoryHaveItem(id) then -- now have item
				self:ADD_OFFENSIVE_AD_NONTARGET(id)
			end 
		else -- have before
			if not GetInventoryHaveItem(id) then -- now dont have item
				local slot = self.OFFENSIVE_AD_NONTARGET[id]
				self:REMOVE_OFFENSIVE_AD_NONTARGET(slot)
			end 
		end
	end
	
	--AP TARGET
	for id,info in pairs(ITEM_MANAGER_OFFENSIVE_AP_TARGET) do
		if self.OFFENSIVE_AP_TARGET[id]==nil then --not yet have
			if GetInventoryHaveItem(id) then-- now have item
				self:ADD_OFFENSIVE_AP_TARGET(id)
			end 
		else -- have before
			if not GetInventoryHaveItem(id) then -- now dont have item
				local slot = self.OFFENSIVE_AP_TARGET[id]
				self:REMOVE_OFFENSIVE_AP_TARGET(slot)
			end 
		end
	end
	--for _,i in pairs(ITEM_MANAGER_OFFENSIVE_AP_NONTARGET) do -- AD NonTarget_Items
	--end
	--for _,i in pairs(ITEM_MANAGER_OFFENSIVE_AP_NONTARGET) do -- DEFFENSIVE_ITEMS
	--end
	
	
	
	--UPDATE CHANGED SLOTS
	self:UPDATE_SLOTS()
end
function ITEM_MANAGER:OnTick_CAST()
	--TARGET
	local target=self.STS:GetTarget(750)
	if not ValidTarget(target) then return end	
	--CAST
	if self.menu.castOffAD then
		self:CAST_OFFENSIVE_AD(target)
	end
	if self.menu.castOffAP then
		self:CAST_OFFENSIVE_AP(target)
	end
end
function ITEM_MANAGER:CAST_OFFENSIVE_AD(target,force)
	for id,slot in pairs(self.OFFENSIVE_AD_TARGET) do
		if (self.menu.OFFENSIVES[tostring(id)] or self.menu.forceAO or force) and (player:CanUseSpell(slot) == READY) and GetDistanceSqr(target) <=ITEM_MANAGER_OFFENSIVE_AD_TARGET[id].rangeSqr then
			CastSpell(slot,target)
		end
	end
	for id,slot in pairs(self.OFFENSIVE_AD_NONTARGET) do
		if (self.menu.OFFENSIVES[tostring(id)] or self.menu.forceAO or force) and (player:CanUseSpell(slot) == READY) and GetDistanceSqr(target) <= ITEM_MANAGER_OFFENSIVE_AD_NONTARGET[id].rangeSqr then
			CastSpell(slot)
		end
	end
end
function ITEM_MANAGER:CAST_OFFENSIVE_AP(target,force)
	for id,slot in pairs(self.OFFENSIVE_AP_TARGET) do
		if (self.menu.OFFENSIVES[tostring(id)] or self.menu.forceAO or force) and (player:CanUseSpell(slot) == READY) and GetDistanceSqr(target) <= ITEM_MANAGER_OFFENSIVE_AP_TARGET[id].rangeSqr then
			CastSpell(slot,target)
		end
	end
end



