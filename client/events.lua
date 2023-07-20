-- Spawning och sparning utav spelare.
saverRunning = false

-- Avaktiverar autospawning efter död för att scriptet ska fungera optimalt.
AddEventHandler('onClientMapStart', function()
    Citizen.Trace(location .. "Avaktiverar autospawn...")
    exports.spawnmanager:spawnPlayer() -- Försäkrar att spelaren spawnar vid anslutning.
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

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped)
            SetVehicleEngineHealth(veh, 1000)
            SetVehicleEngineOn(veh, true, true)
            SetVehicleDirtLevel(veh, 0)
            SetVehicleFixed(veh)

            TPFNotify("Ditt fordon har blivit ~g~reparerat ~w~och ~b~tvättat.")
        else
            local inFront = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
            local veh = GetVehicleCloseby(ped, pos, inFront)

            if DoesEntityExist(veh) then
                Wait(1500)
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
    TriggerServerEvent('TPF:server:spawnmenu_open', src, true)
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

    SetEntityCoords(GetPlayerPed(-1), x, y, tz, true, false, false, true)
    SetEntityCoords(GetPlayerPed(-1), x, y, (z + 2), true, false, false, true)
    SetEntityHeading(PlayerPedId(), heading)
    Citizen.Wait(1000 + transitionIn)
    SwitchInPlayer(PlayerPedId())
    Citizen.Wait(500)
    SetEntityCoords(GetPlayerPed(-1), x, y, z, true, false, false, true)


    if saverRunning then
        return
    else
        autoSave()
    end
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
