local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-gifts/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-- give present to player
RegisterNetEvent('rsg-gifts:server:givepresent', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['present'], "add")
end)

-- open present
RSGCore.Functions.CreateUseableItem('present', function(source, item)
    local src = source
    TriggerClientEvent('rsg-gifts:client:openpresent', src, item.name)
end)

-- open present
RegisterNetEvent('rsg-gifts:server:presentreward', function(present)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local chance = math.random(1,100)
    -- common reward (95% chance)
    if chance <= 95 then -- reward : 1 x common
        local common = Config.CommonItems[math.random(1, #Config.CommonItems)]
        -- add gift
        Player.Functions.AddItem(common, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[common], "add")
        -- remove present
        Player.Functions.RemoveItem(present, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[present], "remove")
    -- rare reward (5% chance)
    elseif chance > 95 then -- reward : 1 x rare
        local rare = Config.RareItems[math.random(1, #Config.RareItems)]
        -- add gift
        Player.Functions.AddItem(rare, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[rare], "add")
        -- remove present
        Player.Functions.RemoveItem(present, 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[present], "remove")
    else
        print("something went wrong check for exploit!")
    end 
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
