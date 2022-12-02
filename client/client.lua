local QRCore = exports['qr-core']:GetCoreObject()
local spawned = false
local busy = false
local cooldownSecondsRemaining = 0

---------------------------------------------------------------------------------

-- prompt and blip
Citizen.CreateThread(function()
    for xmas,v in pairs(Config.XmasTrees) do
        exports['qr-core']:createPrompt(v.name, v.coords, QRCore.Shared.Keybinds['J'], 'Check ' ..v.lable, {
            type = 'client',
            event = 'rsg-gifts:client:checkundertree',
            args = { v.name },
        })
        if v.showblip == true then
            local XmasTreeBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(XmasTreeBlip, GetHashKey(Config.Blip.blipSprite), true)
            SetBlipScale(XmasTreeBlip, Config.Blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, XmasTreeBlip, Config.Blip.blipName)
        end
    end
end)

-- spawn trees
Citizen.CreateThread(function()
    while true do
    Wait(0)
        local hash = GetHashKey('mp006_p_xmastree01x')
        while not HasModelLoaded(hash) do
            Wait(10)
            RequestModel(hash)
        end
        if spawned == false then
            for xmas,v in pairs(Config.XmasTrees) do
                RequestModel(hash)
                xmastree = CreateObject(hash, v.coords -1, true, false, false) 
                SetEntityAsMissionEntity(xmastree, true)
                PlaceObjectOnGroundProperly(xmastree, true)
                FreezeEntityPosition(xmastree, true)
                spawned = true
            end
        end
    end
end)

-- trigger check under tree
RegisterNetEvent('rsg-gifts:client:checkundertree')
AddEventHandler('rsg-gifts:client:checkundertree', function(treename)
    local ped = PlayerPedId()
    if busy == false and cooldownSecondsRemaining == 0 then
        busy = true
        CrouchAnim()
        Wait(6000)
        ClearPedTasks(ped)
        TriggerServerEvent('rsg-gifts:server:givepresent', 'present', 1)
        cooldownTimer()
        busy = false
    else
        QRCore.Functions.Notify('santa\'s not been yet!', 'error')
    end
end)

---------------------------------------------------------------------------------

-- open present
RegisterNetEvent('rsg-gifts:client:openpresent')
AddEventHandler('rsg-gifts:client:openpresent', function(item)
    local hasItem = QRCore.Functions.HasItem(item, 1)
    if hasItem then
        QRCore.Functions.Progressbar('openpresent', 'Opening Present', Config.OpenTime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('rsg-gifts:server:presentreward', item)
        end)
    else
        QRCore.Functions.Notify('you don\'t that item', 'error')
    end
end)

---------------------------------------------------------------------------------

-- ped crouch
function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

-- cooldown timer
function cooldownTimer()
    cooldownSecondsRemaining = Config.Cooldown
    Citizen.CreateThread(function()
        while cooldownSecondsRemaining > 0 do
            Wait(1000)
            cooldownSecondsRemaining = cooldownSecondsRemaining - 1
            --print(cooldownSecondsRemaining)
        end
    end)
end
