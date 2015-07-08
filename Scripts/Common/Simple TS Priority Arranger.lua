--[[
        Simple TS Priority Arranger
        Credits: Manciuszz & eXtragoZ
 
        Changelog:
            > Updated priorityTable with new champion Aatrox, made Alistar, Nunu,Taric "Tank" priority.
            > Now works in games with below 5 players.
            > Target Selector mode switched from TARGET_LOW_HP_PRIORITY to TARGET_LESS_CAST_PRIORITY, because it is more reliable.
            > Reduced 20 lines of code.
 
 ]] --
 
local priorityTable = {
 
    AP = {
        "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
        "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
        "Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi",
    },
    Support = {
        "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Sona", "Soraka", "Thresh", "Zilean",
    },
 
    Tank = {
        "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
        "Warwick", "Yorick", "Zac", "Nunu", "Taric", "Alistar",
    },
 
    AD_Carry = {
        "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
        "Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed", "Jinx"
 
    },
 
    Bruiser = {
        "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nautilus", "Nocturne", "Olaf", "Poppy",
        "Renekton", "Rengar", "Riven", "Shyvana", "Trundle", "Tryndamere", "Udyr", "Vi", "MonkeyKing", "XinZhao", "Aatrox"
    },
 
}
 
function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end
 
function arrangePrioritys(enemies)
    local priorityOrder = {
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,3,3},
        [4] = {1,2,3,4,4},
        [5] = {1,2,3,4,5},
    }
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.AD_Carry, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.AP,       enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.Support,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.Bruiser,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.Tank,     enemy, priorityOrder[enemies][5])
    end
end
 
function OnLoad()
    if #GetEnemyHeroes() <= 1 then
        PrintChat("No enemies, can't arrange priority's!")
    else
        TargetSelector(TARGET_LESS_CAST_PRIORITY, 0) -- Create a dummy target selector
        arrangePrioritys(#GetEnemyHeroes())
        PrintChat(" >> Arranged priority's!")
    end
end

--UPDATEURL=
--HASH=F5408A19601A6600A2AEAA0A7D9556BF
