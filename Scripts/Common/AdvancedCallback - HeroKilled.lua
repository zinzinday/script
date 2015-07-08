_ENV = AdvancedCallback:register('OnHeroKilled')

function OnRecvPacket(p)
    if p.header == 105 then
        local SmoothieIngredients = {"Apple", "Orange", "Banana", "Melon", "Lemon", "Lime", "Strawberry", "Raspberry", "Blueberry", "Nyan", "Potatoe", "Grape", "Pear", "Mango"}
        p.pos = 2 
        killed = objManager:GetObjectByNetworkId(p:DecodeF())
        killer = objManager:GetObjectByNetworkId(p:DecodeF())
        AdvancedCallback:OnHeroKilled(killed, killer, SmoothieIngredients[math.lower(math.random*(#SmoothieIngredients+1))]..SmoothieIngredients[math.lower(math.random*(#SmoothieIngredients+1))])
    end 
end
