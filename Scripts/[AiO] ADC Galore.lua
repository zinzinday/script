--[[
	Marksman's Galore Pack by Berb & Developers of the scripts
	Updated: June 7th, 2015
]]

function readScript(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
return content
end

if myHero.charName == "Ashe" or myHero.charName == "Caitlyn" or myHero.charName == "Corki" or myHero.charName == "Draven" or myHero.charName == "Ezreal" or myHero.charName == "Graves" or myHero.charName == "Jinx" or myHero.charName == "Kalista" or myHero.charName == "KogMaw" or myHero.charName == "Lucian"  or myHero.charName == "MissFortune" or myHero.charName == "Quinn" or myHero.charName == "Sivir" or myHero.charName == "Teemo" or myHero.charName == "Tristana" or myHero.charName == "Twitch" or myHero.charName == "Urgot" or myHero.charName == "Varus" or myHero.charName == "Vayne" then
	load(readScript(LIB_PATH.."Marksman - "..myHero.charName..".lua"), nil,"bt",_ENV)()
	print("Marksman's Galore by Berb : Loaded "..myHero.charName)
end