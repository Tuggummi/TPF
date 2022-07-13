-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

local location = '^1{^2Identifiers^1}^7 ~ '

--Player Connecting
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    if Config.debugPrint then print(location .. 'Creating variables') end
    --Creating variables
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local steamid
    local license
    local discord
    local fivem
    local ip
    if Config.debugPrint then print(location .. 'Variables created') end

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
    if Config.debugPrint then print(location .. 'Variables defined as players') end
    -- Checks if steam is open, to get a correct answer to steamid
    if not steamid then 
        deferrals.done(Config.noSteam)
        if Config.debugPrint then print(location .. 'Steam is not open, warning') end
    else
        deferrals.done()
        if Config.debugPrint then print(location .. 'Steam was open, fetching steamid') end

        MySQL.Async.fetchScalar('SELECT 1 FROM users_identifiers WHERE steamid = @steamid', {
            ["@steamid"] = steamid
        }, function(result)
            if not result then
                if Config.debugPrint then print(location .. 'No information with users steamid exists in DB, inserting...') end
                
                MySQL.Async.execute('INSERT INTO users_identifiers (steamname, steamid, license, discord, fivem, ip) VALUES (@steamname, @steamid, @license, @discord, @fivem, @ip)',
                {["@steamname"] = GetPlayerName(source), ["@steamid"] = steamid, ["@license"] = license, ["@discord"] = discord, ["@fivem"] = fivem, ["@ip"] = ip})
                if Config.debugPrint then print(location .. 'Inserting done, player is connecting.') end
            else
                if Config.debugPrint then print(location .. 'Information with users steamid exists, updating...') end

                MySQL.Async.execute('UPDATE users_identifiers SET steamname = @steamname, license = @license, discord = @discord, fivem = @fivem, ip = @ip WHERE steamid = @steamid', 
                {["@steamname"] = GetPlayerName(source), ["@license"] = license, ["@discord"] = discord, ["@fivem"] = fivem, ["@ip"] = ip, ["@steamid"] = steamid})
                if Config.debugPrint then print(location .. 'Update done, player is connecting.') end
            end
        end)
    end
end)