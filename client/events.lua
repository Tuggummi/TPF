-- Spawning och sparning utav spelare.
saverRunning = false

-- Avaktiverar autospawning efter död för att scriptet ska fungera optimalt.
AddEventHandler('onClientMapStart', function()
    Citizen.Trace(location .. "Avaktiverar autospawn...")
    --exports.spawnmanager:spawnPlayer() -- Försäkrar att spelaren spawnar vid anslutning.
    Citizen.Wait(2500)
    exports.spawnmanager:setAutoSpawn(false)
    Citizen.Trace(location .. "Autospawn avaktiverat.")
end)

-- Ger vapnet angivet med det angivna ammunitionen till lokala spelaren.
RegisterNetEvent("TPF:client_giveWeaponToPed")
AddEventHandler("TPF:client_giveWeaponToPed", function(player, weapon, ammo)
    local player = player
    local playerPed = GetPlayerPed(-1)

    local weapon = weapon

    local ammo = ammo
    if ammo == nil then
        ammo = 999
    end

    if IsEntityDead(playerPed) then
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Du behöver vara vid liv för att ta fram vapen!")
        return
    end

    local steamname = GetPlayerName(GetPlayerServerId(player))
    local title = steamname .. " tog fram vapen."
    local message

    if weapon == nil then
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Inget vapen angavs.")
        print("Err, weapon nil")
        return
    elseif weapon == "all" then
        local allWeapons = _C.gameWeapons
        for i = 1, #allWeapons do
            local weaponHash = GetHashKey(allWeapons[i])
            GiveWeaponToPed(playerPed, weaponHash, 999, false, false)
        end
        message = "**" .. steamname .. "** *tog fram*:\n*__alla vapen__*\n**Ammo:** *" .. ammo
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Du tog fram alla vapen!")
    else
        local weaponHash = GetHashKey(weapon)
        if not IsWeaponValid(weaponHash) then
            TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Vapennamnet du angav är inte korrekt!")
            return
        end

        GiveWeaponToPed(playerPed, weaponHash, ammo)
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Du tog fram vapnet " .. weapon)
        message = "**" .. steamname .. "** *tog fram ett vapen.*\n\n**Vapen:** *" .. weapon .. "*\n **Ammo:** *" .. ammo
    end

    TriggerServerEvent("TPF:server_discordLog", title, message, "weapon", player)
end)

Citizen.CreateThread(function()
    while true do
        local pedId = PlayerPedId()
        if IsEntityDead(pedId) then
            respawnPlayer()
        end
        Citizen.Wait(500)
    end
end)

RegisterNetEvent('TPF:client_reviveCommand')
AddEventHandler('TPF:client_reviveCommand', function(target)
    DoScreenFadeOut(400) -- Small delay for the user who is revived

    local ped = GetPlayerPed(target)
    if not IsEntityDead(ped) then
        healPlayer()
        DoScreenFadeIn(400)
        return
    else
        revivePlayer()
        DoScreenFadeIn(400)
        return
    end
end)

RegisterNetEvent('TPF:client_spawnVehicle')
AddEventHandler('TPF:client_spawnVehicle', function(vehicleName)
    local source = source
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TPFNotify("~r~Fordonet vars namn du anget existerar inte! " .. vehicleName .. "")
        return
    end

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if _C.removeVehicleOnSpawn then
            local veh = GetVehiclePedIsIn(PlayerPedId())
            SetEntityAsMissionEntity(veh, true, true)
            DeleteVehicle(veh)
        else
            TPFNotify('~r~Du måste ta bort fordonet du sitter i för att ta fram ett nytt.')
            return
        end
    end
    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Wait(500)
    end

    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicle)
end)

local distance = 5.0
local retries = 5

RegisterNetEvent('TPF:client_deleteVehicle')
AddEventHandler('TPF:client_deleteVehicle', function()
    local ped = GetPlayerPed(-1)

    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
        local pos = GetEntityCoords(ped)

        if IsPedSittingInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped, false)

            if GetPedInVehicleSeat(vehicle, -1) == ped then
                DeleteTheVehicle(vehicle, retries)
            else
                TPFNotify('~r~Du måste sitta i förarsätet för att radera fordonet.')
            end
        else
            local inFront = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
            local vehicle = GetVehicleCloseby(ped, pos, inFront)

            if DoesEntityExist(vehicle) then
                DeleteTheVehicle(vehicle, retries)
            else
                TPFNotify('~r~Du måste vara nära eller sitta i ditt fordon för att radera den!')
            end
        end
    end
end)

RegisterNetEvent('TPF:client_fixVehicle')
AddEventHandler('TPF:client_fixVehicle', function()
    local ped = GetPlayerPed(-1)

    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        local pos = GetEntityCoords(ped)
        local animName = "fixing_a_player"
        local animDict = "mini@repair"

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped)
            playAnimation(animDict, animName, 1000)
            Wait(1500)
            SetVehicleEngineHealth(veh, 1000)
            SetVehicleEngineOn(veh, true, true)
            SetVehicleDirtLevel(veh, 0)
            SetVehicleFixed(veh)

            TPFNotify("Ditt fordon har blivit ~g~reparerat ~w~och ~b~tvättat.")
        else
            local inFront = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
            local veh = GetVehicleCloseby(ped, pos, inFront)

            if DoesEntityExist(veh) then
                for door = 0, 5 do
                    SetVehicleDoorOpen(veh, door, false, false)
                end

                playAnimation(animDict, animName, 4000)
                Wait(5000)

                for door = 0, 5 do
                    SetVehicleDoorShut(veh, door, false)
                end

                Wait(1000)
                SetVehicleEngineHealth(veh, 1000)
                SetVehicleEngineOn(veh, true, true)
                SetVehicleDirtLevel(veh, 0)
                SetVehicleFixed(veh)

                TPFNotify("Ditt fordon har blivit ~g~reparerat ~w~och ~b~tvättat.")
            else
                TPFNotify('~r~Du måste vara nära eller sitta i ett fordon för att reparera och tvätta den.')
            end
        end
    end
end)

local transitionOut = 3 * 1000
local transitionIn = 1.5 * 1000

local saverRunning = false

AddEventHandler('playerSpawned', function()
    local src = GetPlayerServerId(PlayerId())
    TriggerServerEvent('TPF:server:spawnmenu_open', src)
end)

RegisterNUICallback('closeSpawnmenu', function(data, cb)
    cb({})
    SendNUIMessage({ type = 'closespawn' })
    SetNuiFocus(false, false)
    Citizen.Wait(transitionIn)
    SwitchInPlayer(PlayerPedId())
end)

RegisterNetEvent('TPF:client:spawnmenu_open')
AddEventHandler('TPF:client:spawnmenu_open', function(characters, init)
    SwitchOutPlayer(PlayerPedId(), 0, 1)
    Citizen.Wait(transitionOut)
    SendNUIMessage({ type = 'openspawn', data = characters, init = init })
    SetNuiFocus(true, true)
end)
RegisterNetEvent('TPF:client:spawnmenu_close')
AddEventHandler('TPF:client:spawnmenu_close', function()
    SendNUIMessage({ type = 'closespawn' })
    SetNuiFocus(false, false)
    --Citizen.Wait(transitionIn)
    --SwitchInPlayer(PlayerPedId())
    --SwitchInPlayer not necessary since this event is only triggered when we're still supposed to stay in the air.
end)


RegisterNUICallback('spawnChar', function(data, cb)
    cb({ accepted = true })

    SendNUIMessage({ type = 'closespawn' })
    SetNuiFocus(false, false)

    local cindex = data.cid
    local location = data.location

    TriggerServerEvent('TPF:server_spawnCharacter', cindex, location)
end)

RegisterNUICallback('deleteChar', function(data, cb)
    cb({ accepted = true })

    local cindex = data.cid
    TriggerServerEvent('TPF:server:spawnmenu_delete', cindex)
end)

RegisterNUICallback('createChar', function(data, cb)
    cb({ accepted = true })

    local charData = data.data
    TriggerServerEvent('TPF:server:spawnmenu_create', charData)
    SendNUIMessage({ type = 'closespawn' })
    SetNuiFocus(false, false)
end)

RegisterNetEvent('TPF:client:spawnmenu_spawn')
AddEventHandler('TPF:client:spawnmenu_spawn', function(x, y, z, heading, ped, weapons)
    if IsModelInCdimage(ped) and IsModelValid(ped) then
        RequestModel(ped)
        while not HasModelLoaded(ped) do
            Citizen.Wait(1)
        end
        SetPlayerModel(PlayerId(), ped)
        SetModelAsNoLongerNeeded(ped)
    end



    for _, weaponName in ipairs(weapons) do
        local weaponHash = GetHashKey(weaponName)
        GiveWeaponToPed(PlayerPedId(), weaponHash, 999, false, false)
    end

    local tz = x + 10 -- Temporary Z for not falling under ground.

    SetEntityCoords(GetPlayerPed(-1), x, y, tz, true, false, false, false)
    SetEntityCoords(GetPlayerPed(-1), x, y, (z + 2), true, false, false, false)
    SetEntityHeading(PlayerPedId(), heading)
    Citizen.Wait(1000 + transitionIn)
    SwitchInPlayer(PlayerPedId())
    Citizen.Wait(500)
    SetEntityCoords(GetPlayerPed(-1), x, y, z, true, false, false, false)


    if saverRunning then
        return
    else
        autoSave()
    end
end)

RegisterNetEvent('TPF:client_setPlayerModel')
AddEventHandler('TPF:client_setPlayerModel', function(weapons)
    Citizen.Wait(1000)
    for _, weapon in ipairs(weapons) do
        local weaponHash = GetHashKey(weapon)
        GiveWeaponToPed(PlayerPedId(), weaponHash, 999, false, false)
    end
end)

-- Economy

atmLocations = {
    { x = 89.45,    y = 2.45,      z = 70.31 },
    { x = 1166.02,  y = -456.34,   z = 66.79 },
    { x = -386.733, y = 6045.953,  z = 31.501 },
    { x = -284.037, y = 6224.385,  z = 31.187 },
    { x = -1315.73, y = -834.98,   z = 16.96 },
    { x = -660.703, y = -854.676,  z = 24.49 },
    { x = -1305.41, y = -706.17,   z = 25.33 },
    { x = -717.614, y = -915.88,   z = 19.22 },
    { x = -526.566, y = -1222.89,  z = 18.45 },
    { x = -256.831, y = -716.365,  z = 33.436 },
    { x = -203.548, y = -861.588,  z = 30.205 },
    { x = 112.4102, y = -776.1626, z = 31.4271 },
    { x = 112.9290, y = -818.7100, z = 31.3860 },
    { x = 119.9000, y = -883.9000, z = 31.1240 },
    { x = -107.25,  y = -11.32,    z = 70.52 },
    { x = -821.73,  y = -1081.79,  z = 11.13 },
    { x = -56.26,   y = -1752.52,  z = 29.42 },
    { x = -717.0,   y = -915.0,    z = 19.22 },
    { x = -526.58,  y = -1222.97,  z = 18.45 },
    { x = -1314.98, y = -835.58,   z = 16.96 },
    { x = -660.71,  y = -854.96,   z = 24.49 },
    { x = -386.733, y = 6045.953,  z = 31.501 },
    { x = -284.037, y = 6224.385,  z = 31.187 },
    { x = 155.4300, y = 6642.4110, z = 31.7840 },
    { x = 174.6720, y = 6637.2180, z = 31.7840 },
    { x = 1703.138, y = 6426.783,  z = 32.730 },
    { x = 1735.114, y = 6411.035,  z = 35.164 },
    { x = 1702.842, y = 4933.593,  z = 42.051 },
    { x = 1968.14,  y = 3743.56,   z = 32.34 },
    { x = 1821.917, y = 3683.483,  z = 34.244 },
    { x = 1172.145, y = 2702.882,  z = 38.027 },
    { x = 540.0420, y = 2671.0070, z = 42.1770 },
    { x = 2564.399, y = 2585.100,  z = 38.016 },
    { x = 2558.76,  y = 349.601,   z = 108.050 },
    { x = 2558.052, y = 389.4817,  z = 108.660 },
    { x = 1077.692, y = -775.796,  z = 58.218 },
    { x = 1139.018, y = -469.886,  z = 66.789 },
    { x = 1168.975, y = -457.241,  z = 66.641 },
    { x = 1153.884, y = -326.540,  z = 69.245 },
    { x = 381.2827, y = 323.2518,  z = 103.270 },
    { x = 236.4638, y = 217.4718,  z = 106.840 },
    { x = 265.0043, y = 212.1717,  z = 106.780 },
    { x = 285.2029, y = 143.5690,  z = 104.970 },
    { x = 157.7698, y = 233.5450,  z = 106.450 },
    { x = -164.568, y = 233.5066,  z = 94.919 },
    { x = -1827.04, y = 785.5159,  z = 138.020 },
    { x = -1409.39, y = -99.2603,  z = 52.473 },
    { x = -1205.35, y = -325.579,  z = 37.870 },
    { x = -1215.64, y = -332.231,  z = 37.881 },
    { x = -2072.41, y = -316.959,  z = 13.345 },
    { x = -2975.72, y = 379.7737,  z = 14.992 },
    { x = -2962.60, y = 482.1914,  z = 15.762 },
    { x = -2955.70, y = 488.7218,  z = 15.486 },
    { x = -3044.22, y = 595.2429,  z = 7.595 },
    { x = -3144.13, y = 1127.415,  z = 20.868 },
    { x = -3241.10, y = 996.6881,  z = 12.500 },
    { x = -3241.11, y = 1009.152,  z = 12.877 },
    { x = -1305.40, y = -706.240,  z = 25.352 },
    { x = -538.225, y = -854.423,  z = 29.234 },
    { x = -711.156, y = -818.958,  z = 23.768 },
    { x = -717.614, y = -915.88,   z = 19.22 },
    { x = -526.566, y = -1222.89,  z = 18.45 },
    { x = -256.831, y = -716.365,  z = 33.436 },
    { x = -203.548, y = -861.588,  z = 30.205 },
    { x = 112.4102, y = -776.1626, z = 31.4271 },
    { x = 112.9290, y = -818.7100, z = 31.3860 },
    { x = 119.9000, y = -883.9000, z = 31.1240 },
    { x = -107.25,  y = -11.32,    z = 70.52 },
    { x = -821.73,  y = -1081.79,  z = 11.13 },
    { x = -56.26,   y = -1752.52,  z = 29.42 },
    { x = -717.0,   y = -915.0,    z = 19.22 },
    { x = -526.58,  y = -1222.97,  z = 18.45 },
    { x = -1314.98, y = -835.58,   z = 16.96 },
    { x = -660.71,  y = -854.96,   z = 24.49 },
    { x = -386.733, y = 6045.953,  z = 31.501 },
    { x = -284.037, y = 6224.385,  z = 31.187 },
    { x = 155.4300, y = 6642.4110, z = 31.7840 },
    { x = 174.6720, y = 6637.2180, z = 31.7840 },
    { x = 1703.138, y = 6426.783,  z = 32.730 },
    { x = 1735.114, y = 6411.035,  z = 35.164 },
    { x = 1702.842, y = 4933.593,  z = 42.051 },
    { x = 1968.14,  y = 3743.56,   z = 32.34 },
    { x = 1821.917, y = 3683.483,  z = 34.244 },
    { x = 1172.145, y = 2702.882,  z = 38.027 },
    { x = 540.0420, y = 2671.0070, z = 42.1770 },
    { x = 2564.399, y = 2585.100,  z = 38.016 },
    { x = 2558.76,  y = 349.601,   z = 108.050 },
    { x = 2558.052, y = 389.4817,  z = 108.660 },
    { x = 1077.692, y = -775.796,  z = 58.218 },
    { x = 1139.018, y = -469.886,  z = 66.789 },
    { x = 1168.975, y = -457.241,  z = 66.641 },
    { x = 1153.884, y = -326.540,  z = 69.245 },
    { x = 381.2827, y = 323.2518,  z = 103.270 },
    { x = 236.4638, y = 217.4718,  z = 106.840 },
    { x = 265.0043, y = 212.1717,  z = 106.780 },
    { x = 285.2029, y = 143.5690,  z = 104.970 },
    { x = 157.7698, y = 233.5450,  z = 106.450 },
    { x = -164.568, y = 233.5066,  z = 94.919 },
    { x = -1827.04, y = 785.5159,  z = 138.020 },
    { x = -1409.39, y = -99.2603,  z = 52.473 },
    { x = -1205.35, y = -325.579,  z = 37.870 },
    { x = -1215.64, y = -332.231,  z = 37.881 },
    { x = -2072.41, y = -316.959,  z = 13.345 },
    { x = -2975.72, y = 379.7737,  z = 14.992 },
    { x = -2962.60, y = 482.1914,  z = 15.762 },
    { x = -2955.70, y = 488.7218,  z = 15.486 },
    { x = -3044.22, y = 595.2429,  z = 7.595 },
    { x = -3144.13, y = 1127.415,  z = 20.868 },
    { x = -3241.10, y = 996.6881,  z = 12.500 },
    { x = -3241.11, y = 1009.152,  z = 12.877 },
    { x = -1305.40, y = -706.240,  z = 25.352 },
    { x = -538.225, y = -854.423,  z = 29.234 },
    { x = -711.156, y = -818.958,  z = 23.768 },
    { x = -717.614, y = -915.88,   z = 19.22 },
    { x = -526.566, y = -1222.89,  z = 18.45 },
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local closestDist = -1
        local closestATM = nil

        for _, atmCoords in pairs(atmLocations) do
            local dist = #(playerCoords - vector3(atmCoords.x, atmCoords.y, atmCoords.z))
            if closestDist == -1 or dist < closestDist then
                closestDist = dist
                closestATM = atmCoords
            end
        end

        if closestATM and closestDist <= 2.0 then
            DisplayText("Tryck ~INPUT_CONTEXT~ för att komma åt ditt bankkonto.")
            if IsControlJustPressed(0, 38) then
                -- E key is pressed
                local src = GetPlayerServerId(PlayerId())
                TriggerServerEvent('TPF:server:economy_openATM', src)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        TriggerServerEvent('TPF:server:economy_displayBalance', GetPlayerServerId(PlayerId()))
        Citizen.Wait(5 * 1000)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(600 * 1000)
        TriggerServerEvent('TPF:server:economy_distributeSalary', GetPlayerServerId(PlayerId()))
        Citizen.Wait(10)
    end
end)

RegisterNetEvent('TPF:client:economy_openATM')
AddEventHandler('TPF:client:economy_openATM', function(accountData)
    local gender = getPedGender()
    local animName = "enter"
    local dict = "amb@prop_human_atm@" .. gender .. "@" .. animName
    playAnimation(dict, animName, 5000)
    Citizen.Wait(1000)
    SendNUIMessage({
        type = "openATM",
        account = accountData
    })
    SetNuiFocus(true, true)
    animName = "idle_a"
    dict = "amb@prop_human_atm@" .. gender .. "@" .. animName
    playAnimation(dict, animName, -1)
end)

RegisterNetEvent("TPF:client:economy:callback_nui")
AddEventHandler("TPF:client:economy:callback_nui", function(failed, message)
    SendNUIMessage({ type = "closeATM" })
    SetNuiFocus(false, false)

    local gender = getPedGender()
    local animName = "exit"
    local dict = "amb@prop_human_atm@" .. gender .. "@" .. animName
    playAnimation(dict, animName, -1)

    TPFNotify(message)
end)

function TPFNotify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

RegisterNetEvent('TPF:client:economy_displayBalance')
AddEventHandler('TPF:client:economy_displayBalance', function(bankBalance, cashBalance)
    SendNUIMessage({ type = "updateMoney", bank = bankBalance, cash = cashBalance })
end)

RegisterNetEvent('TPF:client:economy_notifySalary')
AddEventHandler('TPF:client:economy_notifySalary', function(amount, bankBalance, cashBalance)
    SendNUIMessage({ type = "updateMoney", bank = bankBalance, cash = cashBalance })
    local message = "Du fick din lön på ~g~" .. amount .. "kr."
    sendSveaNotification(message, "Svea Bank", "Du fick lön", "CHAR_SVEA_BANK", 9, true, 40)
end)

RegisterNetEvent('TPF:client:economy_notifyUser')
AddEventHandler('TPF:client:economy_notifyUser',
    function(message, sender, subject, textureDict, iconType, saveToBrief, color)
        sendSveaNotification(message, sender, subject, textureDict, iconType, saveToBrief, color)
    end)

RegisterNUICallback('closeATM', function(data, cb)
    cb({})
    SendNUIMessage({ type = "closeATM" })
    SetNuiFocus(false, false)
    local gender = getPedGender()
    local animName = "exit"
    local dict = "amb@prop_human_atm@" .. gender .. "@" .. animName
    playAnimation(dict, animName, -1)
end)

RegisterNUICallback('sendTransaction', function(data, cb)
    local transaction = data.transaction
    cb({})

    TriggerServerEvent('TPF:server:economy_sendTransaction', transaction)
end)

RegisterNUICallback('withdrawMoney', function(data, cb)
    local amount = data.amount
    local id = GetPlayerServerId(PlayerId())
    cb({})

    TriggerServerEvent("TPF:server:economy_withdraw", id, amount)
end)

RegisterNUICallback('depositMoney', function(data, cb)
    local amount = data.amount
    local id = GetPlayerServerId(PlayerId())
    cb({})

    TriggerServerEvent("TPF:server:economy_deposit", id, amount)
end)




-- Chat Suggestions
-- spawnmenu
TriggerEvent('chat:addSuggestion', '/spawnmenu', 'Gå in på spawnmenyn och hantera dina karaktärer')

-- removeweapon
TriggerEvent('chat:addSuggestion', '/removeweapon', 'Ta bort vapen', {
    { name = "vapen", help = "Vapennamnet, tomt = alla" }
})

-- ped
TriggerEvent('chat:addSuggestion', '/ped', 'Välj din pedmodell', {
    { name = "modell", help = "Ped modellens namn, t.ex. mp_m_freemode_01" }
})

-- fix
TriggerEvent('chat:addSuggestion', '/fix', 'Laga och tvätta ditt fordon')

-- dv
TriggerEvent('chat:addSuggestion', '/dv', 'Ta bort fordonet du är i, eller är närmast till')

-- v
TriggerEvent('chat:addSuggestion', '/v', 'Ta fram ett fordon', {
    { name = "fordon", help = "Namnet vars fordon du vill ta fram" }
})

-- revive
TriggerEvent('chat:addSuggestion', '/revive', 'Återuppliva eller läk en spelare', {
    { name = "id", help = "Spelarens ID, tomt = dig själv" }
})

-- weapon
TriggerEvent('chat:addSuggestion', '/weapon', 'Ta fram ett vapen', {
    { name = "vapen", help = "Vapen namnet" },
    { name = "ammo",  help = "Ammunitionen" }
})

-- atm
TriggerEvent('chat:addSuggestion', '/atm', 'Få färdbeskrivning till närmaste ATM')
