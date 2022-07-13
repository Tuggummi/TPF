-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

local location = '^1{^2Position^1}^7 ~ '

local saverRunning = false

function requestSave()
    posX, posY, posZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local viewAngle = GetEntityHeading(GetPlayerPed(-1))

    TriggerServerEvent('TPF_savepos', posX, posY, posZ, viewAngle)
    if Config.savePlayerPos then
        if Config.debugPrint then print(location .. 'Player position saved.') else return end
    else
        return
    end
end

function AutoSave()
    Citizen.CreateThread(function()
        saverRunning = true
        while true do 
            Citizen.Wait(Config.autoSaveTimer * 1000)
            requestSave()
        end
    end)
end

RegisterNetEvent('TPF_spawnlastpos')
AddEventHandler('TPF_spawnlastpos', function(posX, posZ, posY)
    -- Spawn player as ped
    if Config.usePedModel then
        if Config.debugPrint then print(location .. 'Creating model for player spawning') end
        local model = GetHashKey(Config.pedModel)
        if Config.debugPrint then 
            print(location .. 'Ped Model: ' .. Config.pedModel)
            print(location .. 'Model: ' .. model)
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
        if Config.debugPrint then print(location .. 'Model has loaded') end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)
        if Config.debugPrint then print(location .. 'Model is released to player') end
    end

    if Config.debugPrint then print(location .. 'Player position loaded') end
    SetEntityCoords(GetPlayerPed(-1), posX, posZ, posY, 1, 0, 0, 1)

    if saverRunning then
        return
    else
        AutoSave()
    end
end)

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('TPF_SpawnPlayer')
end)
