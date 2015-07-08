_G.SEvadeAutoUpdate = true
_G.SEvadeVersion    = 0.02
_G.SEvadeLastUpdate = "Beta :: Day 2 - only drawings"

function OnLoad()
	SEvade() end
end

function Msg(msg, title)
  title = title or myHero.charName 
  print("<font color=\"#6699ff\"><b>[SEvade]: "..title.." - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>") 
end

class 'SEvade' -- {

	function SEvade:__init()
		if _G.SEvadeLoaded then
			if SEvadeAutoUpdate then self:Update() end
			Msg(SEvadeLastUpdate, "Last Update")
			self:Load()
		end
	end

	function SEvade:Update()
	  local SEvadeServerData = GetWebResult("raw.github.com", "/nebelwolfi/BoL/master/SEvade.version")
	  if SEvadeServerData then
	    SEvadeServerVersion = type(tonumber(SEvadeServerData)) == "number" and tonumber(SEvadeServerData) or nil
	    if SEvadeServerVersion then
	      if tonumber(SEvadeVersion) < SEvadeServerVersion then
	        Msg("New version available v"..SEvadeServerVersion)
	        Msg("Updating, please don't press F9")
	        DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/SEvade.lua".."?rand="..math.random(1,10000), SCRIPT_PATH.."SEvade.lua", function () Msg("Successfully updated. ("..SEvadeVersion.." => "..SEvadeServerVersion.."), press F9 twice to load the updated version") end) end, 1.5)
	        return true
	      end
	    end
	  else
	    Msg("Error downloading version info")
	  end
	  if _G.UPLloaded then
	    self.SP = UPL.SP
	  else
	    if FileExist(LIB_PATH .. "/SPrediction.lua") then
	      require("SPrediction")
	      self.SP = SPrediction()
	    else 
	      Msg("Downloading SPrediction, please don't press F9")
	      DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/SP.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () require("SPrediction") Msg("Downloaded SPrediction") self.SP = SPrediction() end) 
	    end
	  end
	  Msg("Loaded the latest version (v"..SEvadeVersion..")")
	  return false
	end

	function SEvade:Load()
		self.cdTable = {}
		self.thrownSpell = {}
		self.Config = scriptConfig("SEvade","SEvade")
		AddProcessSpellCallback(function(unit, spell) self:ProcessSpell(unit, spell) end)
		AddTickCallback(function() self:Tick() end)
		AddDrawCallback(function() self:Draw() end)
	end

	function SEvade:ProcessSpell(unit, spell)
		if spell.target then return end
		self:AssumeThrownskill(unit,Vector(spell.endPos-unit.pos):normalized(),spell.windUpTime)
	end

	function SEvade:Tick()
		for _,k in pairs(GetEnemyHeroes()) do
			self.cdTable[k.networkID] = {[_Q] = k:GetSpellData(_Q).currentCd, [_W] = k:GetSpellData(_W).currentCd, [_E] = k:GetSpellData(_E).currentCd, [_R] = k:GetSpellData(_R).currentCd}
		end
		for _,k in pairs(GetAllyHeroes()) do
			self.cdTable[k.networkID] = {[_Q] = k:GetSpellData(_Q).currentCd, [_W] = k:GetSpellData(_W).currentCd, [_E] = k:GetSpellData(_E).currentCd, [_R] = k:GetSpellData(_R).currentCd}
		end
		self.cdTable[myHero.networkID] = {[_Q] = myHero:GetSpellData(_Q).currentCd, [_W] = myHero:GetSpellData(_W).currentCd, [_E] = myHero:GetSpellData(_E).currentCd, [_R] = myHero:GetSpellData(_R).currentCd}
	end

	function SEvade:Draw()
		for _=1,#self.thrownSpell do
			local speed, delay, range, width, collision, type = SP:GetData(self.thrownSpell[_].spell,self.thrownSpell[_].unit)
			local endPos = self.thrownSpell[_].startPos+self.thrownSpell[_].dir:normalized()*(range+width)
			if self.thrownSpell[_].time+range/speed+delay > GetInGameTimer() then
				DrawLine3D(self.thrownSpell[_].startPos.x, self.thrownSpell[_].startPos.y, self.thrownSpell[_].startPos.z, endPos.x, endPos.y, endPos.z, width, ARGB(55, 255, 255, 255))
			else
				table.remove(self.thrownSpell, _)
			end
		end
	end

	function SEvade:AssumeThrownskill(source,direction,delay) -- I'm a lazy bastard...
		local tempCdTable = self.cdTable[source.networkID]
		DelayAction(function()
			for i=0,3 do
				if tempCdTable[i] == 0 and source:GetSpellData(i).currentCd > 0 then
					self.thrownSpell[#self.thrownSpell+1] = {spell = i, time = GetInGameTimer(), unit = source, startPos = Vector(source), dir = direction}
				end
			end
		end, delay+0.05)
	end
-- }
