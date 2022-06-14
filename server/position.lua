-- Should there be debug prints within the console when events are triggered. (Not recommended if not for debug use)
debugPrint = false

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
        if debugPrint then print('Inget svar på steamid från denna spelare.') end
        if debugPrint then print('Fungerar ej: ' .. steamid) end
    else
        if debugPrint then print('Fungerar: ', steamid) end
        MySQL.Async.fetchScalar('SELECT 1 FROM users_information WHERE steamid = @steamid', {
            ["@steamid"] = steamid
        }, function(result)
            if not result then
                if debugPrint then print('Ingen information finns för spelarens hex, inför...') end
                MySQL.Async.execute('INSERT INTO users_information (steamname, steamid) VALUES (@steamname, @steamid)', 
                {["@steamname"] = GetPlayerName(source), ["@steamid"] = steamid})
                if debugPrint then print('Införning avklarad, steamnamn och steamid.') end
            else
                if debugPrint then print('Information hittades, uppdatterar...') end
                MySQL.Async.execute('UPDATE users_information SET steamname = @steamname WHERE steamid = @steamid', 
                {["@steamname"] = GetPlayerName(source), ["@steamid"] = steamid})
                if debugPrint then print('Uppdatering avklarad.') end
            end
        end)
    end
end)

RegisterServerEvent('tk:Framework_savepos')
AddEventHandler('tk:Framework_savepos', function(posX, posY, posZ, viewAngle)

    local source = source

    local lastPosition = '{' .. posX .. ', ' .. posY .. ', ' .. posZ .. ', ' .. viewAngle .. '}'
    local success = MySQL.Sync.execute('UPDATE users_information SET `lastpos` = @lastpos WHERE steamid = @username', {['@lastpos'] = lastPosition, ['@username'] = GetPlayerIdentifier(source, 0)})

    if debugPrint then print('Sparar position för ' .. GetPlayerName(source)) end

    if success == 1 then
        if debugPrint then print('Sparning lyckades') else return end
    else
        if debugPrint then print('Sparning lyckades') else return end
    end

end)

RegisterServerEvent('tk:Framework_SpawnPlayer')
AddEventHandler('tk:Framework_SpawnPlayer', function()

    local source = source

    local result = MySQL.Sync.fetchScalar('SELECT lastpos FROM users_information WHERE steamid = @steamid', {['@steamid'] = GetPlayerIdentifier(source, 0)})
    
    if result ~= nil then 

        local decoded = json.decode(result)

        TriggerClientEvent('tk:Framework_spawnlastpos', source, decoded[1], decoded[2], decoded[3])

    else
        if debugPrint then print('Spelarposition kunde ej laddas!') else return end
    end


end)