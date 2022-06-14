-- Saves the players identifiers at the database

-- Should there be debug prints within the console when events are triggered. (Not recommended if not for debug use)
debugPrint = false

--Player Connecting
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    if debugPrint then print('Skapar variabler') end
    --Creating variables
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local steamid
    local license
    local discord
    local fivem
    local ip
    if debugPrint then print('Variabler skapade') end

    for k, v in ipairs(identifiers) do
        if string.match(v, 'steam') then
            steamid = v
        elseif string.match(v, 'license:') then
            license = v
        elseif string.match(v, 'discord') then
            discord = v
        elseif string.match(v, 'fivem') then
            fivem = v
        elseif string.match(v, 'ip') then
            ip = v
        end
    end
    if debugPrint then print('Variabler satta som spelarens') end
    -- Checks if steam is open, to get a correct answer to steamid
    if not steamid then 
        deferrals.done('Du behöver steam öppet för att ansluta till servern!')
        if debugPrint then print('Steam var ej öppet, varnar') end
    else
        deferrals.done()
        if debugPrint then print('Steam var öppet, hämtar steamid') end

        MySQL.Async.fetchScalar('SELECT 1 FROM users_identifiers WHERE steamid = @steamid', {
            ["@steamid"] = steamid
        }, function(result)
            if not result then
                if debugPrint then print('Steamid finns ej i databasen, inför...') end
                
                MySQL.Async.execute('INSERT INTO users_identifiers (steamname, steamid, license, discord, fivem, ip) VALUES (@steamname, @steamid, @license, @discord, @fivem, @ip)',
                {["@steamname"] = GetPlayerName(source), ["@steamid"] = steamid, ["@license"] = license, ["@discord"] = discord, ["@fivem"] = fivem, ["@ip"] = ip})
                if debugPrint then print('Införning utav identifierare slutförd, spelare ansluter.') end
            else
                if debugPrint then print('Steamid fanns i databasen, uppdatterar...') end

                MySQL.Async.execute('UPDATE users_identifiers SET steamname = @steamname, license = @license, discord = @discord, fivem = @fivem, ip = @ip WHERE steamid = @steamid', 
                {["@steamname"] = GetPlayerName(source), ["@license"] = license, ["@discord"] = discord, ["@fivem"] = fivem, ["@ip"] = ip, ["@steamid"] = steamid})
                if debugPrint then print('Uppdaterning slutförd, spelare ansluter.') end
            end
        end)
    end
end)