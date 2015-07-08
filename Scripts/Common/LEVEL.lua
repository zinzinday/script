local version = "0.2"
local TESTVERSION = false
local AUTOUPDATE = false
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/fter44/ilikeman/master/common/LEVEL.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."LEVEL.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>LEVEL:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/fter44/ilikeman/master/VersionFiles/LEVEL.version")
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

--LEVEL UP
class "LEVEL"
function LEVEL:__init()
	self.AtLevelUP = {}
	self.OnLevelUP = {}
	self.Level = 0
	self.lasttick=0
	AddTickCallback(function() self:OnTick() end)
end
function LEVEL:RegisterAtLevelUPCallback(level,fn)
	if self.AtLevelUP[level]==nil then
		self.AtLevelUP[level]={fn}
	else
		table.insert(self.AtLevelUP[level], fn)
	end
	
	return self
end
function LEVEL:RegisterOnLevelUPCallback(fn)
	table.insert(self.OnLevelUP, fn)
	return self
end
function LEVEL:OnTick()
	if os.clock()-self.lasttick<0.5 then return end
	
	if self.Level~=myHero.level then --LEVEL UP!
		self.Level=myHero.level
		if self.AtLevelUP[self.Level] then
			for _,fn in pairs(self.AtLevelUP[self.Level]) do
				fn()
			end
		end
		for _,fn in pairs(self.OnLevelUP) do
			fn(self.Level)
		end
	end
end
