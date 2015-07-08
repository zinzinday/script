class 'foundSmite'
class 'Manager'
class 'basicSmite'
class 'Chogath'
class 'Nunu'
class 'Volibear'
class 'RekSaiOlaf'

--------------------------------------------------------------
--------------------------------------------------------------
----------------- LOADER
--------------------------------------------------------------
--------------------------------------------------------------

function OnLoad()
	foundSmite()
	if not myHero:GetSpellData(SUMMONER_1).name:find("smite") and not myHero:GetSpellData(SUMMONER_2).name:find("smite") then return end
	Manager()
	if myHero.charName == "Chogath" then
		Chogath()
		print("Supported Champion Found")
	elseif myHero.charName == "Nunu" then
		Nunu()
		print("Supported Champion Found")
	elseif myHero.charName == "Volibear" then
		Volibear()
		print("Supported Champion Found")
	elseif myHero.charName == "RekSai" or myHero.charName == "Olaf" then
		RekSaiOlaf()
		print("Supported Champion Found")
	else
		basicSmite()
	end
end

--------------------------------------------------------------
--------------------------------------------------------------
----------------- FOUND SMITE
--------------------------------------------------------------
--------------------------------------------------------------

function foundSmite:__init()
	_G.Smite = { Range = 550, slot = nil, Dmg = math.max(20*myHero.level+370,30*myHero.level+330,40*myHero.level+240,50*myHero.level+100), Ready = function() return myHero:CanUseSpell(Smite.slot) == 0 end}
	if myHero:GetSpellData(SUMMONER_1).name:find("smite") then
        Smite.slot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then
       Smite.slot = SUMMONER_2
    else
		print("No smite Found")
	end	
end

--------------------------------------------------------------
--------------------------------------------------------------
-----------------  MANAGER
--------------------------------------------------------------
--------------------------------------------------------------

function Manager:__init()
	self.smiteList = {"SRU_Murkwolf8.1.1","SRU_Murkwolf2.1.1","SRU_Razorbeak3.1.1","SRU_Razorbeak9.1.1","SRU_Gromp14.1.1","SRU_Gromp13.1.1","SRU_Krug5.1.2","SRU_Krug11.1.2","SRU_Red4.1.1","SRU_Red10.1.1","SRU_Blue1.1.1","SRU_Blue7.1.1","SRU_Dragon6.1.1","SRU_Baron12.1.1" }
	self.MyMinionTable = { }
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead and self:ValidMinion(object)then
			self.MyMinionTable[#self.MyMinionTable + 1] = object
		end
	end
	self:myMenu()
	AddCreateObjCallback(function(minion) self:OnCreateObj(minion) end)
	AddDeleteObjCallback(function(minion) self:OnDeleteObj(minion) end)
	AddTickCallback(function() self:OnTick() end)
end

function Manager:ValidMinion(m)
	return (m and m ~= nil and m.type and not m.dead and m.name ~= "hiu" and m.name and m.type:lower():find("min") and not m.name:lower():find("camp") and m.team ~= myHero.team and m.charName and not m.name:find("OdinNeutralGuardian") and not m.name:find("OdinCenterRelic"))
end

function Manager:OnCreateObj(minion)
	if self:ValidMinion(minion) then 
    	self.MyMinionTable[#self.MyMinionTable + 1] = minion 
	end
end

function Manager:OnDeleteObj(minion)
  	if self.MyMinionTable ~= nil then
      for i, msg in pairs(self.MyMinionTable)  do 
          if msg.networkID == minion.networkID then
            table.remove(self.MyMinionTable, i)
          end
      end
    end
end

function Manager:myMenu()
	_G.myMenu = scriptConfig("[AutoSmite] "..myHero.charName, "AMBER")
		_G.myMenu:addSubMenu("[AutoSmite] "..myHero.charName.." - settings", "settings")
		_G.myMenu.settings:addParam("Smite", "Use AutoSmite", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("T"))
		if myHero.charName == "Chogath" or myHero.charName == "Nunu" or myHero.charName == "Volibear" or myHero.charName == "RekSai" or myHero.charName == "Olaf" then
			_G.myMenu.settings:addParam("Spell", "Use Spell", SCRIPT_PARAM_ONOFF, true)
		end
		_G.myMenu.settings:addParam("info", "----------------------------------------", SCRIPT_PARAM_INFO, "")
		_G.myMenu.settings:addParam("golem","Use On Golem ", SCRIPT_PARAM_ONOFF, false)
		_G.myMenu.settings:addParam("wolve","Use On Wolve ", SCRIPT_PARAM_ONOFF, false)
		_G.myMenu.settings:addParam("ghost","Use On Ghost ", SCRIPT_PARAM_ONOFF, false)
		_G.myMenu.settings:addParam("gromp","Use On Gromp ", SCRIPT_PARAM_ONOFF, false)
		_G.myMenu.settings:addParam("info", "----------------------------------------", SCRIPT_PARAM_INFO, "")
		_G.myMenu.settings:addParam("redBuff","Use On Red Buff ", SCRIPT_PARAM_ONOFF, true)
		_G.myMenu.settings:addParam("blueBuff", "Use On Blue Buff ", SCRIPT_PARAM_ONOFF, true)
		_G.myMenu.settings:addParam("info", "----------------------------------------", SCRIPT_PARAM_INFO, "")
		_G.myMenu.settings:addParam("drake", "Use On Drake ", SCRIPT_PARAM_ONOFF, true)
		_G.myMenu.settings:addParam("nashor" , "Use On Nashor " , SCRIPT_PARAM_ONOFF, true)
		_G.myMenu.settings:permaShow("Smite")
	_G.myMenu:addSubMenu("[AutoSmite] "..myHero.charName.." - Draw", "Draw")
		_G.myMenu.Draw:addParam("drawSmite" , "Draw Smite Range " , SCRIPT_PARAM_ONOFF, true)
		if myHero.charName == "Chogath" or myHero.charName == "Nunu" or myHero.charName == "Volibear" or myHero.charName == "RekSai" or myHero.charName == "Olaf" then
			_G.myMenu.Draw:addParam("drawSpell" , "Draw Spell Range " , SCRIPT_PARAM_ONOFF, true)
		end
		_G.myMenu.Draw:addParam("drawSmitable" , "Draw Dammage " , SCRIPT_PARAM_ONOFF, true)

end

function Manager:OnTick()
	_G.theMinion = self:isSmitable()
end

function Manager:isSmitable()
	for i, minion in pairs(self.MyMinionTable) do
		self.isMinion = self.MyMinionTable[i]
		if GetDistance(self.isMinion) <= Smite.Range then
			if table.contains(self.smiteList, self.isMinion.name) then 
				_G.drawMinion = self.isMinion
				if not _G.myMenu.settings.golem and self.isMinion.name:find("Krug") then return end
				if not _G.myMenu.settings.wolve and self.isMinion.name:find("Murkwolf") then return end
				if not _G.myMenu.settings.ghost and self.isMinion.name:find("Razorbeak") then return end
				if not _G.myMenu.settings.gromp and self.isMinion.name:find("Gromp") then return end
				if not _G.myMenu.settings.redBuff and self.isMinion.name:find("Red") then return end
				if not _G.myMenu.settings.blueBuff and self.isMinion.name:find("Blue") then return end
				if not _G.myMenu.settings.drake and self.isMinion.name:find("Dragon") then return end
				if not _G.myMenu.settings.nashor and self.isMinion.name:find("Baron") then return end
				return self.isMinion
			end
		end
	end
end


--------------------------------------------------------------
--------------------------------------------------------------
----------------- BASIC SMITE
--------------------------------------------------------------
--------------------------------------------------------------

function basicSmite:__init()
	AddTickCallback(function() self:OnTick() end)
	AddDrawCallback(function() self:OnDraw() end)
end

function basicSmite:OnTick()
	if _G.theMinion ~= nil and _G.myMenu.settings.Smite then self:useSmite() end
end

function basicSmite:useSmite()
	if _G.theMinion.health <= Smite.Dmg then
		CastSpell(Smite.slot, _G.theMinion)
	end
end

function basicSmite:OnDraw()
	if not myHero.dead and Smite.Ready() then
		if _G.myMenu.Draw.drawSmite then
			DrawCircle(myHero.x, myHero.y, myHero.z, 550, RGB(100, 44, 255))
		end
		if _G.myMenu.Draw.drawSmitable then
			if _G.drawMinion and GetDistance(_G.drawMinion) <= 550 then
				self.drawDamage = _G.drawMinion.health - Smite.Dmg
				if _G.drawMinion.health > Smite.Dmg then
					DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
				else
					DrawText3D("Smitable",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
				end
			end
		end
	end
end

--------------------------------------------------------------
--------------------------------------------------------------
-----------------CHO'GAT
--------------------------------------------------------------
--------------------------------------------------------------

function Chogath:__init()
	AddTickCallback(function() self:OnTick() end)
	AddDrawCallback(function() self:OnDraw() end)
	self.myDmg = 1000 + (0.7*myHero.ap)
end

function Chogath:OnTick()
	if _G.theMinion ~= nil then self:useSmite() end
end

function Chogath:useSmite()
	if _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_R) == READY) and Smite.Ready() and _G.myMenu.settings.Spell and _G.myMenu.settings.Smite then
		if _G.theMinion.health < Smite.Dmg + self.myDmg then
			CastSpell(_R, _G.theMinion)
			CastSpell(Smite.slot, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_R) == READY) and _G.myMenu.settings.Spell then
		if _G.theMinion.health < self.myDmg then
			CastSpell(_R, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 550 and Smite.Ready() and _G.myMenu.settings.Smite then
		if _G.drawMinion.health < Smite.Dmg then
			CastSpell(Smite.slot, _G.theMinion)
		end
	end
end

function Chogath:OnDraw()
	if not myHero.dead then
		if _G.myMenu.Draw.drawSmite and Smite.Ready() then
			DrawCircle(myHero.x, myHero.y, myHero.z, 550, RGB(100, 44, 255))
		end
		if _G.myMenu.Draw.drawSpell and (myHero:CanUseSpell(_R) == READY) then
			DrawCircle(myHero.x, myHero.y, myHero.z, 350, RGB(100, 44, 255))
		end
		if _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_R) == READY) and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg - self.myDmg
			if _G.drawMinion.health > Smite.Dmg + self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("R + Smite",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_R) == READY) and not Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - self.myDmg
			if _G.drawMinion.health > self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("R",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 550 and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg
			if _G.drawMinion.health > Smite.Dmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("Smitable",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		end
	end
end

--------------------------------------------------------------
--------------------------------------------------------------
----------------- Nunu
--------------------------------------------------------------
--------------------------------------------------------------

function Nunu:__init()
	AddTickCallback(function() self:OnTick() end)
	AddDrawCallback(function() self:OnDraw() end)
	self.myDmg = self:qDamage()
end

function Nunu:OnTick()
	if _G.theMinion ~= nil then self:useSmite() end
end

function Nunu:useSmite()
	if _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_Q) == READY) and Smite.Ready() and _G.myMenu.settings.Spell and _G.myMenu.settings.Smite then
		if _G.theMinion.health < Smite.Dmg + self.myDmg then
			CastSpell(_Q, _G.theMinion)
			CastSpell(Smite.slot, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_Q) == READY) and _G.myMenu.settings.Spell then
		if _G.theMinion.health < self.myDmg then
			CastSpell(_Q, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 550 and Smite.Ready() and _G.myMenu.settings.Smite then
		if _G.drawMinion.health < Smite.Dmg then
			CastSpell(Smite.slot, _G.theMinion)
		end
	end
end

function Nunu:qDamage()
	self.qLevel = myHero:GetSpellData(_Q).level
	self.damage = nil

	if self.qLevel == 1 then
		self.damage = 400
	elseif self.qLevel == 2 then
		self.damage = 550
	elseif self.qLevel == 3 then
		self.damage = 700
	elseif self.qLevel == 4 then
		self.damage = 850
	elseif self.qLevel == 5 then
		self.damage = 1000
	end

	return self.damage
end

function Nunu:OnDraw()
	if not myHero.dead then
		if _G.myMenu.Draw.drawSmite and Smite.Ready() then
			DrawCircle(myHero.x, myHero.y, myHero.z, 550, RGB(100, 44, 255))
		end
		if _G.myMenu.Draw.drawSpell and (myHero:CanUseSpell(_Q) == READY) then
			DrawCircle(myHero.x, myHero.y, myHero.z, 350, RGB(100, 44, 255))
		end
		if _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_Q) == READY) and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg - self.myDmg
			if _G.drawMinion.health > Smite.Dmg + self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("Q + Smite",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_Q) == READY) and not Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - self.myDmg
			if _G.drawMinion.health > self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("Q",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 550 and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg
			if _G.drawMinion.health > Smite.Dmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("Smitable",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		end
	end
end


--------------------------------------------------------------
--------------------------------------------------------------
----------------- Volibear
--------------------------------------------------------------
--------------------------------------------------------------

function Volibear:__init()
	AddTickCallback(function() self:OnTick() end)
	AddDrawCallback(function() self:OnDraw() end)
end

function Volibear:OnTick()
	if _G.theMinion ~= nil then 
		self.myDmg = getDmg("W", _G.theMinion, myHero) 
		self:useSmite() 
	end
end

function Volibear:useSmite()
	if _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_W) == READY) and Smite.Ready() and _G.myMenu.settings.Spell and _G.myMenu.settings.Smite then
		if _G.theMinion.health < Smite.Dmg + self.myDmg then
			CastSpell(_W, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_W) == READY) and _G.myMenu.settings.Spell then
		if _G.theMinion.health < self.myDmg then
			CastSpell(_W, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 550 and Smite.Ready() and _G.myMenu.settings.Smite then
		if _G.drawMinion.health < Smite.Dmg then
			CastSpell(Smite.slot, _G.theMinion)
		end
	end
end

function Volibear:OnDraw()
	if not myHero.dead then
		if _G.myMenu.Draw.drawSmite and Smite.Ready() then
			DrawCircle(myHero.x, myHero.y, myHero.z, 550, RGB(100, 44, 255))
		end
		if _G.myMenu.Draw.drawSpell and (myHero:CanUseSpell(_W) == READY) then
			DrawCircle(myHero.x, myHero.y, myHero.z, 350, RGB(100, 44, 255))
		end
		if _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_W) == READY) and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg - self.myDmg
			if _G.drawMinion.health > Smite.Dmg + self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("W + Smite",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_W) == READY) and not Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - self.myDmg
			if _G.drawMinion.health > self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("W",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 550 and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg
			if _G.drawMinion.health > Smite.Dmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("Smitable",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		end
	end
end

--------------------------------------------------------------
--------------------------------------------------------------
----------------- RekSai & Olaf
--------------------------------------------------------------
--------------------------------------------------------------


function RekSaiOlaf:__init()
	AddTickCallback(function() self:OnTick() end)
	AddDrawCallback(function() self:OnDraw() end)
end

function RekSaiOlaf:OnTick()
	if _G.theMinion ~= nil then 
		self.myDmg = getDmg("E", _G.theMinion, myHero) 
		self:useSmite() 
	end
end

function RekSaiOlaf:useSmite()
	if _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_E) == READY) and Smite.Ready() and _G.myMenu.settings.Spell and _G.myMenu.settings.Smite then
		if _G.theMinion.health < Smite.Dmg + self.myDmg then
			CastSpell(_E, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 350 and (myHero:CanUseSpell(_E) == READY) and _G.myMenu.settings.Spell then
		if _G.theMinion.health < self.myDmg then
			CastSpell(_E, _G.theMinion)
		end
	elseif _G.theMinion and GetDistance(_G.theMinion) <= 550 and Smite.Ready() and _G.myMenu.settings.Smite then
		if _G.drawMinion.health < Smite.Dmg then
			CastSpell(Smite.slot, _G.theMinion)
		end
	end
end

function RekSaiOlaf:OnDraw()
	if not myHero.dead then
		if _G.myMenu.Draw.drawSmite and Smite.Ready() then
			DrawCircle(myHero.x, myHero.y, myHero.z, 550, RGB(100, 44, 255))
		end
		if _G.myMenu.Draw.drawSpell and (myHero:CanUseSpell(_E) == READY) then
			DrawCircle(myHero.x, myHero.y, myHero.z, 350, RGB(100, 44, 255))
		end
		if _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_E) == READY) and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg - self.myDmg
			if _G.drawMinion.health > Smite.Dmg + self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("E + Smite",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 350 and (myHero:CanUseSpell(_E) == READY) and not Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - self.myDmg
			if _G.drawMinion.health > self.myDmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("E",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		elseif _G.drawMinion and GetDistance(_G.drawMinion) <= 550 and Smite.Ready() then
			self.drawDamage = _G.drawMinion.health - Smite.Dmg
			if _G.drawMinion.health > Smite.Dmg then
				DrawText3D(tostring(math.ceil(self.drawDamage)),_G.drawMinion.x, _G.drawMinion.y+450, _G.drawMinion.z, 24, 0xFFFF0000)
			else
				DrawText3D("Smitable",_G.drawMinion.x,_G.drawMinion.y+450, _G.drawMinion.z, 24, 0xff00ff00)
			end
		end
	end
end


