local QRCore = exports['qr-core']:GetCoreObject()

-- give present to player
RegisterNetEvent('rsg-gifts:server:givepresent', function(item, amount)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items['present'], "add")
end)

-- open present
QRCore.Functions.CreateUseableItem('present', function(source, item)
    local src = source
    TriggerClientEvent('rsg-gifts:client:openpresent', src, item.name)
end)

-- open present
RegisterNetEvent('rsg-gifts:server:presentreward', function(present)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    local chance = math.random(1,100)
    -- common reward (95% chance)
    if chance <= 95 then -- reward : 1 x common
        local common = Config.CommonItems[math.random(1, #Config.CommonItems)]
        -- add gift
        Player.Functions.AddItem(common, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items[common], "add")
        -- remove present
        Player.Functions.RemoveItem(present, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items[present], "remove")
    -- rare reward (5% chance)
    elseif chance > 95 then -- reward : 1 x rare
        local rare = Config.RareItems[math.random(1, #Config.RareItems)]
        -- add gift
        Player.Functions.AddItem(rare, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items[rare], "add")
        -- remove present
        Player.Functions.RemoveItem(present, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items[present], "remove")
    else
        print("something went wrong check for exploit!")
    end 
end)
