-- DO NOT EDIT ANYTHING HERE; YOU ARE NOT PERMITTED AND YOU CAN RUIN THE RESOURCE! --

local location = '^1{^2Position^1}^7 ~ '

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local steamid

    for k, v in ipairs(identifiers) do
        if string.match(v, 'steam') then
            steamid = v
        end
    end

    if not steamid then
        if Config.debugPrint then print(location .. 'There is no steamid from player.') end
        if Config.debugPrint then print(location .. 'No steamid: ' .. steamid) end
    else
        if Config.debugPrint then print(location .. 'Got steamid: ', steamid) end
        MySQL.Async.fetchScalar('SELECT 1 FROM users_information WHERE steamid = @steamid', {
            ["@steamid"] = steamid
        }, function(result)
            if not result then
                if Config.debugPrint then print(location .. 'No information from the users steamid exists in the DB, inserting...') end
                MySQL.Async.execute('INSERT INTO users_information (steamname, steamid) VALUES (@steamname, @steamid)', 
                {["@steamname"] = GetPlayerName(source), ["@steamid"] = steamid})
                if Config.debugPrint then print(location .. 'Inserted steamname and steamid, player is connecting') end
            else
                if Config.debugPrint then print(location .. 'Information found, updating...') end
                MySQL.Async.execute('UPDATE users_information SET steamname = @steamname WHERE steamid = @steamid', 
                {["@steamname"] = GetPlayerName(source), ["@steamid"] = steamid})
                if Config.debugPrint then print(location .. 'Update done.') end
            end
        end)
    end
end)

RegisterServerEvent('TPF_savepos')
AddEventHandler('TPF_savepos', function(posX, posY, posZ, viewAngle)

    local source = source

    local lastPosition = '{' .. posX .. ', ' .. posY .. ', ' .. posZ .. ', ' .. viewAngle .. '}'
    local success = MySQL.Sync.execute('UPDATE users_information SET `lastpos` = @lastpos WHERE steamid = @username', {['@lastpos'] = lastPosition, ['@username'] = GetPlayerIdentifier(source, 0)})

    if Config.debugPrint then print(location .. 'Saving position for ' .. GetPlayerName(source)) end

    if success == 1 then
        if Config.debugPrint then print(location .. 'Saving success') else return end
    else
        if Config.debugPrint then print(location .. 'Saving error') else return end
    end

end)

RegisterServerEvent('TPF_SpawnPlayer')
AddEventHandler('TPF_SpawnPlayer', function()
    local source = source

    local result = MySQL.Sync.fetchScalar('SELECT lastpos FROM users_information WHERE steamid = @steamid', {['@steamid'] = GetPlayerIdentifier(source, 0)})
    
    if result ~= nil then 
        local decoded = json.decode(result)
        TriggerClientEvent('TPF_spawnlastpos', source, decoded[1], decoded[2], decoded[3])
    else
        if Config.debugPrint then print(location .. 'Player position could not be loaded!') else return end
    end
end)