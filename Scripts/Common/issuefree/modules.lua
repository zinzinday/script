require "issuefree/spellRanges"
ModuleConfig:addParam("ranges", "Draw Spell Ranges", SCRIPT_PARAM_ONOFF, true)
ModuleConfig:permaShow("ranges")

require "issuefree/smite"
ModuleConfig:addParam("smite", "Auto Smite", SCRIPT_PARAM_ONOFF, true)
ModuleConfig:permaShow("smite")

require "issuefree/WardRevealer"
ModuleConfig:addParam("wardRevealer", "Ward Revealer", SCRIPT_PARAM_ONOFF, true)
ModuleConfig:permaShow("wardRevealer")

-- require "issuefree/cleanse"
-- ModuleConfig:addParam("cleanse", "Auto Cleanse", SCRIPT_PARAM_ONOFF, true)
-- ModuleConfig:permaShow("cleanse")

require "issuefree/ignite"
if spells["ignite"] then
   ModuleConfig:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
   ModuleConfig:permaShow("ignite")
end

-- require "issuefree/antiSkillShot"
-- ModuleConfig:addParam("ass", "AntiSkillShot", SCRIPT_PARAM_ONOFF, false)
-- ModuleConfig:permaShow("ass")

require "issuefree/objectFind"
ModuleConfig:addParam("debug", "Debug Objects", SCRIPT_PARAM_ONOFF, false)
ModuleConfig:permaShow("debug")

-- require "issuefree/testTargets"
-- ModuleConfig:addParam("testtargets", "Test Targets", SCRIPT_PARAM_ONOFF, false)
-- ModuleConfig:permaShow("testtargets")

require "issuefree/autoLane"
ModuleConfig:addParam("autolane", "Auto Lane", SCRIPT_PARAM_ONOFF, false)
ModuleConfig:permaShow("autolane")

ModuleConfig:addParam("aaDebug", "Debug AA", SCRIPT_PARAM_ONOFF, false)
ModuleConfig:permaShow("aaDebug")

require "issuefree/JungleTimer"

require "issuefree/support"




-- local modules = {}
-- function loadModule(module)
-- 	pp("Loading: "..module)
-- 	local chunk,msg = loadfile(module)      -- loads/compiles the lua chunk
-- 	if (chunk ~= nil) then
-- 		chunk()
-- 	end
-- end

-- --loadModule("clones.lua")

-- loadModule("spellRanges.lua")
-- loadModule("smite.lua")
-- loadModule("WardRevealer.lua")
-- loadModule("cleanse.lua")
-- loadModule("ignite.lua")
-- loadModule("antiSkillShot.lua")
-- loadModule("objectFind.lua")
-- loadModule("testTargets.lua")


