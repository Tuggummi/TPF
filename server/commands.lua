-- Ger angivna vapnet till spelaren
-- /weapon vapenNamn (ammo) [https://wiki.rage.mp/index.php?title=Weapons] weapon_ är ej nödvändigt!

RegisterCommand("weapon", function(source, args)
    local player = source
    local weapon = args[1]
    local ammo = args[2]

    if weapon == nil then
        TriggerClientEvent("chatMessage", -1, "[TPF]", { 148, 0, 211 }, "Inget vapennamn angavs")
        return
    elseif weapon == "all" then
        if _P.allWeaponsAllowed == true then
            local allowedPlayers = _P.allowedAllWeapons
            if isPlayerAllowed(source, allowedPlayers) == true then
                TriggerClientEvent("TPF:client_giveWeaponToPed", source, player, weapon)
            else
                TriggerClientEvent("chatMessage", -1, "[TPF]", { 148, 0, 211 }, "Du får inte ta fram alla vapen!")
                return
            end
            return
        else
            TriggerClientEvent("chatMessage", -1, "[TPF]", { 148, 0, 211 }, "Du får inte ta fram alla vapen!")
            return
        end
        return
    end

    if ammo == nil then
        ammo = "999"
    end
    if ammo < "1" or ammo > "999" then
        TriggerClientEvent("chatMessage", -1, "[TPF]", { 148, 0, 211 },
            "Ammunitionen kan ej vara mindre än 1 eller mer än 999.")
        return
    end

    local weapon = string.lower(weapon)

    if string.find(weapon, "weapon_") == nil then
        weapon = "weapon_" .. weapon
    end

    if type(ammo) == "string" then
        ammo = tonumber(ammo)
    end

    TriggerClientEvent("TPF:client_giveWeaponToPed", source, player, weapon, ammo)
end)

RegisterCommand('revive', function(source, args)
    if _P.allowEveryoneRevive == false then
        local allowedToRevive = _P.allowedToRevive
        if isPlayerAllowed(source, allowedToRevive) ~= true then
            TriggerClientEvent('chatMessage', source, "TPF", { 148, 0, 211 },
                "Du har inte tillstånd att använda detta kommando.")
            return
        end
    end

    if source == 0 and not args[1] then
        print(
            "This command was not executed correctly: It was executed by another script or the console, and no target was passed through.")
        return
    end

    local target = args[1]

    local userId = tostring(source)

    if target == nil then
        target = userId
    end

    if not tonumber(target, 10) then
        TriggerClientEvent('chatMessage', source, "TPF", { 148, 0, 211 },
            "Det du angav ~y~" .. target .. "~w~, är ~r~inte~w~ ett ~y~giltigt nummer.")
        return
    end

    if target == nil or target == 0 or GetPlayerName(target) == nil then
        TriggerClientEvent("chatMessage", source, "TPF", { 148, 0, 211 },
            "Det du angav, ~y~" .. target .. "~w~, är ~r~inte~w~ ett ~g~gilltigt ID.")
        return
    end

    TriggerClientEvent('TPF:client_reviveCommand', target)

    --local coords = GetEntityCoords(GetPlayerPed(target))
    --local x, y, z = string.match(coords, "^vector3%((.-), (.-), (.-)%)$")

    --coords = string.format("%.6f, %.6f, %.6f", tonumber(x), tonumber(y), tonumber(z))


    Wait(3000)
    if target == userId then
        TriggerClientEvent("chatMessage", source, "TPF", { 148, 0, 211 }, "Du revivade ^6 dig själv.")


        local title = GetPlayerName(source) .. ' revivade **sig själv**.'
        local message = GetPlayerName(source) .. ' revivade sig själv.'

        TriggerEvent('TPF:server_discordLog', title, message, "playerRevived", source)
    elseif source == 0 then
        TriggerClientEvent("chatMessage", target, "TPF", { 148, 0, 211 }, "Du blev revivad av ^6konsollen.")

        local title = 'Konsollen revivade **' .. GetPlayerName(target) .. '**.'
        local message = 'Konsollen revivade ' .. GetPlayerName(target)

        TriggerEvent('TPF:server_discordLog', title, message, "playerRevived", target)
    else
        TriggerClientEvent("chatMessage", source, "TPF", { 148, 0, 211 },
            "Du revivade ^6" .. GetPlayerName(target) .. "^0, ID: ^6" .. target .. "")
        TriggerClientEvent("chatMessage", target, "TPF", { 148, 0, 211 },
            "Du blev revivad av ^6" .. GetPlayerName(source) .. "")

        local title = GetPlayerName(source) .. ' revivade **' .. GetPlayerName(target) .. '**.'
        local message = GetPlayerName(source) ..
            ' revivade ' .. GetPlayerName(target)

        TriggerEvent('TPF:server_discordLog', title, message, "playerRevived", source, target)
    end
end)

RegisterCommand('v', function(source, args)
    if _P.allowEveryoneHandle ~= true then
        if isPlayerAllowed(source, _P.allowedToHandle) ~= true then
            if _P.allowEveryoneManage ~= true then
                if isPlayerAllowed(source, _P.allowedToManage) ~= true then
                    TriggerClientEvent('chatMessage', source, "TPF", { 148, 0, 211 },
                        "Du har inte tillstånd att använda detta kommando.")
                    return
                end
            end
        end
    end

    local vehicleName = args[1]

    if vehicleName == nil then
        TriggerClientEvent('chatMessage', source, "TPF", { 148, 0, 211 },
            "Du måste ange spawnnamn till det fordon du vill ta fram.")
        return
    end

    TriggerClientEvent('TPF:client_spawnVehicle', source, vehicleName)
end)

RegisterCommand('dv', function(source)
    if _P.allowEveryoneHandle ~= true then
        if isPlayerAllowed(source, _P.allowedToHandle) ~= true then
            if _P.allowEveryoneManage ~= true then
                if isPlayerAllowed(source, _P.allowedToManage) ~= true then
                    TriggerClientEvent('chatMessage', source, "TPF", { 148, 0, 211 },
                        "Du har inte tillstånd att använda detta kommando.")
                    return
                end
            end
        end
    end

    TriggerClientEvent('TPF:client_deleteVehicle', source)
end)

RegisterCommand('fix', function(source)
    if _P.allowEveryoneHandle ~= true then
        if isPlayerAllowed(source, _P.allowedToHandle) ~= true then
            if _P.allowEveryoneFix ~= true then
                if isPlayerAllowed(source, _P.allowedToFix) ~= true then
                    TriggerClientEvent('chatMessage', source, "TPF", { 148, 0, 211 },
                        "Du har inte tillstånd att använda detta kommando.")
                    return
                end
            end
        end
    end

    TriggerClientEvent('TPF:client_fixVehicle', source)
end)
