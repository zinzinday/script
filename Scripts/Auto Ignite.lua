
local ignite = nil

function OnLoad()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then 
		ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
    	ignite = SUMMONER_2
    end 

    Menu()

    print("<font color=\"#6699ff\"><b>Auto Ignite:</b></font> <font color=\"#FFFFFF\"> (1.00) loaded.</font>")
end


function OnTick()
	if ignite ~= nil and Menu.useIgnite then
		UseIgnite()
	end 
end

function UseIgnite()
	if (myHero:CanUseSpell(ignite) == READY) then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if Menu[enemy.charName] then
				if ValidTarget(enemy, 600) then
					local dmg = (50 + (20 * myHero.level)) 

					if enemy.health < dmg then
						CastSpell(ignite, enemy)
					end 

				end
			end 

		end 

	end 

end 



function Menu()
	Menu = scriptConfig("Auto Ignite", "autoIgnite")

	Menu:addParam("useIgnite", "Active", SCRIPT_PARAM_ONOFF, false)
 	for i, enemy in ipairs(GetEnemyHeroes()) do
		Menu:addParam(enemy.charName, "Use Ignite on " .. enemy.charName, SCRIPT_PARAM_ONOFF, false)
 	end 
 end