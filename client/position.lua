-- Choose the ped model player should spawn as in the begning.
pedModel = 'csb_mp_agent14'
-- Should the player spawn with the defined ped or not? Set to false if it shouldn't be used. 
--(Note, if no other scripts are active that changes the ped, you will spawn with a random ped.)
usePedModel = false
-- Should the player be notified while saving location (Not recommended if not for debug use)
notifyPlayer = false
-- Should there be debug prints within the console when events are triggered. (Not recommended if not for debug use)
debugPrint = false

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

local saverRunning = false


local AutoSaveTimer = 10000 -- ms

function requestSave()

    posX, posY, posZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local viewAngle = GetEntityHeading(GetPlayerPed(-1))

    TriggerServerEvent('tk:Framework_savepos', posX, posY, posZ, viewAngle)
    if notifyPlayer then Notify('Spelarposition sparad') end
    if debugPrint then print('spelarposition sparad') end

end

function AutoSave()

    Citizen.CreateThread(function()

        saverRunning = true

        while true do 
            Citizen.Wait(AutoSaveTimer)
            requestSave()
        end
    
    end)

end

RegisterNetEvent('tk:Framework_notify')
AddEventHandler('tk:Framework_notify', function(message)
    Notify(message)
end)

RegisterNetEvent('tk:Framework_spawnlastpos')
AddEventHandler('tk:Framework_spawnlastpos', function(posX, posZ, posY)
    -- Spawn player as ped
    if usePedModel then
        if debugPrint then print('Creating model for player spawning') end
        local model = GetHashKey(pedModel)
        if debugPrint then 
            print('Ped Model: ' .. pedModel)
            print('Model: ' .. model)
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
        if debugPrint then print('Model has loaded') end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)
        if debugPrint then print('Model is released to player') end
    end

    if debugPrint then print('Spelarposition laddad') end
    SetEntityCoords(GetPlayerPed(-1), posX, posZ, posY, 1, 0, 0, 1)

    if saverRunning then
        return
    else
        AutoSave()
    end
end)

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()

    TriggerServerEvent('tk:Framework_SpawnPlayer')

end)