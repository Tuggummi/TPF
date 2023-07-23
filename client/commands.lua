-- Clientdelen av kommandon som tillföljer TPF --

-- Ger angivna ped modellen till spelaren
-- /ped pedmodell [https://docs.fivem.net/docs/game-references/ped-models/]
RegisterCommand("ped", function(source, args)
    local playerPed = GetPlayerPed(-1)

    if IsEntityDead(playerPed) then
        TriggerEvent("chatMessage", "[TPF]", { 255, 1, 1 }, "Du måste vara vid liv för att använda detta kommando!")
        return
    end

    local playerModel = GetEntityModel(playerPed)
    local newPlayerModel = args[1]

    if newPlayerModel == nil then
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Ingen pedmodell angavs")
        return
    end

    if not IsModelValid(newPlayerModel) then
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Modellen du angav existerar ej")
        return
    end

    local newPlayerModelHash = GetHashKey(newPlayerModel)
    if playerModel == newPlayerModelHash then
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Du har redan den ped modellen.")
        return
    end

    local gameWeapons = _C.gameWeapons
    local playerWeapons = {}

    for k, weaponHash in pairs(gameWeapons) do
        if HasPedGotWeapon(playerPed, weaponHash) then
            print(weaponHash)
            table.insert(playerWeapons, weaponHash)
        end
    end

    local oldModelName = GetEntityArchetypeName(playerPed)
    local newModelName = newPlayerModel

    TriggerServerEvent("TPF:server_setPlayerModel", playerModel, newPlayerModel, oldModelName, newModelName,
        playerWeapons)
end)

-- Tar bort angivna namnet från spelaren som aktiverar, alternativt alla om inget är angett!
-- /removeweapon (vapenNamn) [https://wiki.rage.mp/index.php?title=Weapons] weapon_ är ej nödvändigt!
RegisterCommand("removeweapon", function(source, args)
    local playerPed = GetPlayerPed(-1)

    if IsEntityDead(playerPed) then
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Du måste vara vid liv för att använda detta kommando!")
        return
    end

    local weapon = args[1]
    local title
    local message

    if weapon == nil then
        RemoveAllPedWeapons(playerPed)
        title = GetPlayerName(source) .. " tog bort vapen."
        message = "**" .. GetPlayerName(source) .. "** tog bort alla sina vapen."
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Tar bort alla dina vapen!")
        TriggerServerEvent("TPF:server_discordLog", title, message, "removeWeapon")
    else
        weapon = string.lower(weapon)

        if string.find(weapon, "weapon_") == nil then
            weapon = "weapon_" .. weapon
        end

        local weaponHash = GetHashKey(weapon)
        if not IsWeaponValid(weaponHash) then
            TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Vapennamnet du angav är inte korrekt!")
            return
        end

        RemoveWeaponFromPed(playerPed, weaponHash)
        TriggerEvent("chatMessage", "[TPF]", { 148, 0, 211 }, "Du plockade bort vapnet " .. weapon)

        title = GetPlayerName(source) .. " tog bort ett vapen."
        message = "**" .. GetPlayerName(source) .. "** *tog bort* *" .. weapon .. "*"
        TriggerServerEvent("TPF:server_discordLog", title, message, "removeWeapon")
    end
end)

RegisterCommand('spawnmenu', function(source)
    if IsPlayerDead(source) then
        TriggerEvent('chatMessage', "[TPF]", { 148, 0, 211 }, "Du kan inte använda detta kommando när du är död.")
        return
    end

    if GetPlayerWantedLevel(playerId) ~= 0 then
        TriggerEvent('chatMessage', "[TPF]", { 148, 0, 211 }, "Du kan inte använda detta kommando när du är efterlyst.")
        return
    end

    local src = GetPlayerServerId(PlayerId())
    TriggerServerEvent('TPF:server:spawnmenu_open', src)
end)

-- Economy

RegisterCommand('atm', function()
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)

    local closestATM = findClosestATM(playerCoords)
    if closestATM then
        SetNewWaypoint(closestATM.x, closestATM.y)
        TriggerEvent('chatMessage', "TPF", { 148, 0, 211 }, "Satt färdbeskrivning till närmaste bankomat.")
    else
        TriggerEvent('chatMessage', "TPF", { 148, 0, 211 }, "Hittade ingen banokmat nära dig...")
    end
end)
