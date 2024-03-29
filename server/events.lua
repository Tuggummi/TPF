-- Version Checking
local currentVersion = 'v2.1.0'
PerformHttpRequest('https://api.github.com/repos/Tuggummi/TPF/releases/latest', function(statusCode, response, headers)
    if statusCode == 200 then
        local releaseData = json.decode(response)
        local latestVersion = releaseData.tag_name
        local location = ""

        if currentVersion ~= latestVersion then
            local errorMessage = string.format(
                "\n\27[31m=================================================\n" ..
                "\27[35mDin skript version är gammal!\27[0m\n" ..
                "Lokala versionen: \27[31m%s\27[0m\n" ..
                "Senaste versionen: \27[32m%s\27[0m\n" ..
                "\27[34mVänligen hämta den senaste versionen från GitHub.\n" ..
                "\27[35mhttps://github.com/Tuggummi/TPF/releases/latest\n" ..
                "\27[31m=================================================",
                currentVersion,
                latestVersion
            )


            local redColorCode = "\27[31m"
            local resetColorCode = "\27[0m"

            Citizen.CreateThread(function()
                -- Delay the printing of the error message
                Citizen.Wait(2000) -- Adjust the delay as needed

                -- Set the console text color to red
                print(redColorCode .. errorMessage .. resetColorCode)
            end)
        else
            local successMessage = "Din skriptversion har den senaste utgåvan: " .. latestVersion

            local greenColorCode = "\27[32m"
            local resetColorCode = "\27[0m"

            Citizen.CreateThread(function()
                -- Delay the printing of the success message
                Citizen.Wait(2000) -- Adjust the delay as needed

                -- Set the console text color to green
                print(greenColorCode .. successMessage .. resetColorCode)
            end)
        end
    end
end)

-- Hämtar identifierare och sätter in dem i databasen vid anslutning. Inför även informationen för spawning!
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamid
    local license
    local license2
    local discord
    local fivem
    local xbl
    local ip
    deferrals.defer()
    Wait(10)

    for k, v in ipairs(identifiers) do
        if string.match(v, "steam") then
            steamid = v                         -- Adding players' steamid to "steamid"
        elseif string.match(v, "license:") then -- Using ":" to make sure we get the right license. There's two!
            license = v                         -- Adding players' license to "license"
        elseif string.match(v, "license2:") then
            license2 = v                        -- Adding players' license2 to "license2"
        elseif string.match(v, "discord") then
            discord = v                         -- Adding players' discord to "discord"
        elseif string.match(v, "fivem") then
            fivem = v                           -- Adding players' fivem to "fivem"
        elseif string.match(v, "xbl:") then
            xbl = v                             -- Adding players' xbl to "xbl"
        elseif string.match(v, "ip") then
            ip = v                              -- Adding players' ip to "ip"
        end
    end
    deferrals.update("Hämtar dina identifierare...")
    Wait(10)

    if not steamid then
        deferrals.done('\nInget steamid hittades, kontrollera att steam är öppnat!')
        print(location .. "Anslutning nekad.")
        return
    end
    deferrals.update("Identifierare hittades, forstätter...")
    Wait(10)

    MySQL.Async.fetchScalar("SELECT 1 FROM identifiers WHERE steamid = @steamid", {
        ["@steamid"] = steamid
    }, function(result)
        if not result then
            deferrals.update("Ny spelare, inför identifierare...")
            Wait(5)

            MySQL.Async.execute(
                "INSERT INTO identifiers (steamname, steamid, license, license2, discord, fivem, xbl, ip) VALUES (@steamname, @steamid, @license, @license2, @discord, @fivem, @xbl, @ip)",
                {
                    ["@steamname"] = GetPlayerName(src),
                    ["@steamid"] = steamid,
                    ["@license"] = license,
                    ["@license2"] = license2,
                    ["@discord"] = discord,
                    ["@fivem"] = fivem,
                    ["@xbl"] = xbl,
                    ["@ip"] = ip
                })
            deferrals.update("Införning slutförd, ansluter dig till servern...")
            Wait(10)
            deferrals.done()
            local playerIdentifiers = {
                steamid, license, license2, discord, fivem, xbl, ip
            }
            TriggerEvent("TPF:server_playerConnectLog", src, playerIdentifiers, "PlayerConnect")
        else
            deferrals.update("Spelare hittades, uppdaterar...")
            Wait(5)

            MySQL.Async.execute(
                "UPDATE identifiers SET steamname = @steamname, license = @license, license2 = @license2, discord = @discord, fivem = @fivem, xbl = @xbl, ip = @ip WHERE steamid = @steamid",
                {
                    ["@steamname"] = GetPlayerName(src),
                    ["@license"] = license,
                    ["@license2"] = license2,
                    ["@discord"] = discord,
                    ["@fivem"] = fivem,
                    ["@xbl"] = xbl,
                    ["@ip"] = ip,
                    ["@steamid"] = steamid
                })
            deferrals.update("Uppdatering avslutad, ansluter dig till servern...")
            Wait(10)
            deferrals.done()
            local playerIdentifiers = {
                steamid = steamid,
                license = license,
                license2 = license2,
                discord = discord,
                fivem = fivem,
                xbl = xbl,
                ip = ip
            }
            TriggerEvent("TPF:server_playerConnectLog", src, playerIdentifiers, "playerConnect")
        end
    end)

    MySQL.Async.fetchScalar("SELECT 1 FROM users WHERE steamid = @steamid", {
        ["@steamid"] = steamid
    }, function(result)
        if not result then
            deferrals.update("Ny spelare, inför information...")
            Wait(5)

            MySQL.Async.execute("INSERT INTO users (steamname, steamid) VALUES (@steamname, @steamid)", {
                ["@steamname"] = GetPlayerName(src), ["@steamid"] = steamid
            })

            deferrals.update("Införning slutförd, ansluter dig till servern...")
            Wait(10)
            deferrals.done()
        else
            deferrals.update("Spelare hittades, uppdaterar...")
            Wait(5)

            MySQL.Async.execute("UPDATE users SET steamname = @steamname WHERE steamid = @steamid", {
                ["@steamname"] = GetPlayerName(src), ["@steamid"] = steamid
            })
            deferrals.update("Uppdatering avslutad, ansluter dig till servern...")
            Wait(10)
            deferrals.done()
        end
    end)
end)




-- Discord log för när spelare lämnar!
AddEventHandler("playerDropped", function(reason)
    local steamid = GetPlayerIdentifiers(source)[1]
    local rawSteamid = GetPlayerIdentifiers(source)[1]
    local license = GetPlayerIdentifiers(source)[2]
    --local live = GetPlayerIdentifiers(source)[4]
    local discord = GetPlayerIdentifiers(source)[5]
    local fivem = GetPlayerIdentifiers(source)[6]

    if steamid == nil then
        steamid = "Inget hittades"
    end
    if license == nil then
        license = "Inget hittades"
    end
    if discord == nil then
        discord = "Inget hittades"
    end
    if fivem == nil then
        fivem = "Inget hittades"
    end

    steamid = string.gsub(steamid, "steam:", "`SteamID: ")
    license = string.gsub(license, "license:", "`License: ")
    discord = string.gsub(discord, "discord:", "`Discord: ")
    fivem = string.gsub(fivem, "fivem:", "`FiveM: ")

    if reason == "Exiting" then
        reason = "Lämnade självmant"
    end

    local steamname = GetPlayerName(source)
    local title = steamname
    local message = "*lämnade servern*.\n__**Anledning:**__ *" ..
        reason ..
        "*\n\n`Steamnamn: " ..
        steamname .. "`\n" .. steamid .. "`\n" .. license .. "`\n" .. discord .. "`\n" .. fivem .. "`"

    TriggerEvent("TPF:server_discordLog", title, message, "leaving")
    TriggerEvent('TPF:server:spawnmenu_leaving', rawSteamid)
end)

RegisterServerEvent('TPF:server:spawnmenu_leaving', function(identifier)
    local success = MySQL.Sync.execute('UPDATE users SET active = false WHERE steamid = @steamid AND active = true', {
        ['@steamid'] = identifier
    })
    if success == 1 then
        return
    else
        return
    end
end)




-- Skickar discordmeddelande när spelare ansluter till servern, assisterad av föregående event!
RegisterServerEvent("TPF:server_playerConnectLog", function(src, playerIdentifiers, trigger)
    local steamid = playerIdentifiers.steamid
    local license = playerIdentifiers.license
    local license2 = playerIdentifiers.license2
    local discord = playerIdentifiers.discord
    local fivem = playerIdentifiers.fivem
    local xbl = playerIdentifiers.xbl
    local ip = playerIdentifiers.ip

    if steamid == nil then
        steamid = "Inget hittades"
    end
    if license == nil then
        license = "Inget hittades"
    end
    if license2 == nil then
        license2 = "Inget hittades"
    end
    if discord == nil then
        discord = "Inget hittades"
    end
    if fivem == nil then
        fivem = "Inget hittades"
    end
    if xbl == nil then
        xbl = "Inget hittades"
    end
    if ip == nil then
        ip = "Inget hittades"
    end

    steamid = string.gsub(steamid, "steam:", "")
    license = string.gsub(license, "license:", "")
    license2 = string.gsub(license2, "license2:", "")
    discord = string.gsub(discord, "discord:", "")
    fivem = string.gsub(fivem, "fivem:", "")
    xbl = string.gsub(xbl, "xbl:", "")
    ip = string.gsub(ip, "ip:", "")

    local steamname = GetPlayerName(src)
    local title = steamname
    local message = "*anslöt till servern*\n\n`Steamnamn: " ..
        steamname ..
        "`\n`SteamID: " ..
        steamid ..
        "`\n`License: " ..
        license ..
        "`\n`License2: " ..
        license2 .. "`\n`Discord: " .. discord .. "`\n`FiveM: " .. fivem .. "`\n`Xbox Live: " .. xbl .. "`"

    TriggerEvent("TPF:server_discordLog", title, message, trigger)
end)

-- Sätter spelarens pedmodell till den agivna.
RegisterServerEvent("TPF:server_setPlayerModel",
    function(playerModel, newPlayerModel, oldModelName, newModelName, playerWeapons)
        local src = source
        local oldModel = playerModel
        local newModel = newPlayerModel
        local oldModelName = oldModelName
        local newModelName = newModelName


        local steamname = GetPlayerName(src)
        local steamid = GetPlayerIdentifier(src, 0)

        if src == nil then
            print(location .. "[^1ERR^7] source not found. (TPF/server/events.lua:8)")
            return
        end

        if oldModel == nil then
            TriggerClientEvent("chatMessage", src, "[TPF] ~r~[ERR]~s~", { 148, 0, 211 },
                "Något gick snett, om problemet fortsätter kontakta Tuggummi.")
            print(location .. "[^1ERR^7] old model not found. (TPF/server/events.lua:14)")
            return
        end

        if newModel == nil then
            TriggerClientEvent("chatMessage", src, "[TPF] ~r~[ERR]~s~", { 148, 0, 211 },
                "Något gick snett, om problemet fortsätter kontakta Tuggummi.")
            print(location .. "[^1ERR^7] new model not found. (TPF/server/events.lua:20)")
            return
        end

        SetPlayerModel(source, newModel)

        local title = GetPlayerName(source) .. " ändrar Ped Modell"
        local message = "**" ..
            GetPlayerName(source) ..
            "** byter sin ped modell \n**från:** *" ..
            oldModelName ..
            "*\n**till:** *" ..
            newModelName ..
            "*\n\n`ServerID: " .. source .. "`\n`Steamnamn: " .. steamname .. "`\n`SteamID: " .. steamid .. "`"

        TriggerEvent("TPF:server_discordLog", title, message, "ped")

        TriggerClientEvent('TPF:client_setPlayerModel', source, playerWeapons)

        TriggerClientEvent("chatMessage", src, "[TPF]", { 148, 0, 211 }, "Du böt din ped till " .. newModelName)
    end)

-- Event för att discord logga en händelse.
RegisterServerEvent("TPF:server_discordLog", function(title, message, trigger, player, target)
    local webhook
    local color = 16711680
    local footer = os.date("%d.%m.%Y %X")

    if trigger == "ped" then
        webhook = _W.pedWebhook
    end

    if trigger == "weapon" then
        webhook = _W.weaponWebhook

        steamname = GetPlayerName(source)
        steamid = GetPlayerIdentifier(source, 0)
        message = message ..
            "*\n\n`ServerID: " .. source .. "`\n`Steamnamn: " .. steamname .. "`\n`SteamID: " .. steamid .. "`"
    end

    if trigger == "removeWeapon" then
        webhook = _W.removeWeaponWebhook
        steamname = GetPlayerName(source)
        steamid = GetPlayerIdentifier(source, 0)
        message = message ..
            "\n\n`ServerID: " .. source .. "`\n`Steamnamn: " .. steamname .. "`\n`SteamID: " .. steamid .. "`"
    end

    if trigger == "playerConnect" then
        webhook = _W.playerConnectWebhook
    end

    if trigger == "leaving" then
        webhook = _W.playerDisconnectWebhook
    end

    if trigger == "playerRevived" then
        webhook = _W.reviveWebhook
        steamname = GetPlayerName(player)
        steamid = GetPlayerIdentifier(player, 0)
        message = message ..
            "\n\n`ServerID: " .. player .. "`\n`Steamnamn: " .. steamname .. "`\n`SteamID: " .. steamid .. "`"
        if target then
            message = message ..
                "\n\n`Spelare: " ..
                GetPlayerName(target) .. "`\n`ID: " .. target .. "`\n`SteamID: " .. GetPlayerIdentifier(target, 0) .. "`"
        end
    end

    if trigger == "transaction" then
        webhook = _W.transactionsWebhook
    end

    local embed = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer
            }
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST',
        json.encode({ username = "TPF Logs", embeds = embed }), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('TPF:server:spawnmenu_open', function(source)
    local identifier = GetPlayerIdentifier(source, 0)

    local result = MySQL.Sync.fetchAll(
        "SELECT firstname, lastname, age, gender, job, lastpos, active, cindex FROM users WHERE steamid = @steamid ORDER BY cindex ASC",
        {
            ['@steamid'] = identifier
        })

    local init = true

    if result ~= nil and #result > 0 then
        local characters = {}
        for i = 1, #result do
            local active = false
            if result[i].active == "1" then
                init = false
                active = true
            end
            local new = false
            if result[i].lastpos == nil or string.len(result[i].lastpos) <= 0 then
                new = true
            end

            local character = {
                firstname = result[i].firstname,
                lastname  = result[i].lastname,
                age       = result[i].age,
                gender    = result[i].gender,
                job       = result[i].job,
                active    = active,
                new       = new,
                cindex    = result[i].cindex,
            }
            table.insert(characters, character)
        end

        TriggerClientEvent('TPF:client:spawnmenu_open', source, characters, init)
    else
        characters = {}
        TriggerClientEvent('TPF:client:spawnmenu_open', source, characters, init)
    end
end)

RegisterServerEvent('TPF:server_spawnCharacter', function(cindex, location)
    local identifier = GetPlayerIdentifier(source, 0)
    local src = source

    local spawningLocations = {
        plaza    = { x = 232.52, y = -878.22, z = 30.49, heading = 340.0 },       -- Plaza in Los Santos
        prison   = { x = 1849.45, y = 2586.04, z = 45.67, heading = 270.86 },     -- Prison in Sandy Shores
        military = { x = -2345.26, y = 3267.34, z = 32.81, heading = 240.0 },     -- Military Base
        default  = { x = -267.7795, y = -958.5611, z = 31.2232, heading = 207.5 } -- Default Positionen.
    }



    local result = MySQL.Sync.fetchAll(
        "SELECT lastpos, model, weapons FROM users WHERE steamid = @steamid AND cindex = @cindex", {
            ['@steamid'] = identifier,
            ['@cindex']  = cindex
        });

    if result ~= nil then
        local coords
        if result[1].lastpos ~= nil and string.len(result[1].lastpos) > 0 then
            local decodedPos = json.decode(result[1].lastpos)

            local x = decodedPos[1]
            local y = decodedPos[2]
            local z = decodedPos[3]
            local heading = decodedPos[4]
            if heading == nil then
                heading = 0
            end
            coords = {
                x = x,
                y = y,
                z = z,
                heading = heading,
            }
        end

        local model = result[1].model
        local weapons = result[1].weapons
        weapons = splitString(weapons, ',')

        if location == "plaza" then
            coords = {
                x = spawningLocations.plaza.x,
                y = spawningLocations.plaza.y,
                z = spawningLocations.plaza.z,
                heading = spawningLocations.plaza.heading
            }
        elseif location == "prison" then
            coords = {
                x = spawningLocations.prison.x,
                y = spawningLocations.prison.y,
                z = spawningLocations.prison.z,
                heading = spawningLocations.prison.heading
            }
        elseif location == "military" then
            coords = {
                x = spawningLocations.military.x,
                y = spawningLocations.military.y,
                z = spawningLocations.military.z,
                heading = spawningLocations.military.heading
            }
        elseif location == "default" then
            coords = {
                x = spawningLocations.default.x,
                y = spawningLocations.default.y,
                z = spawningLocations.default.z,
                heading = spawningLocations.default.heading
            }
        end


        MySQL.Async.execute('UPDATE users SET active = false WHERE steamid = @steamid AND active = true', {
            ["@steamid"] = identifier
        });
        Citizen.Wait(500)
        MySQL.Async.execute('UPDATE users SET active = true WHERE steamid = @steamid AND cindex = @cindex', {
            ['@steamid'] = identifier,
            ['@cindex'] = cindex,
        })
        Citizen.Wait(500)

        TriggerClientEvent('TPF:client:spawnmenu_spawn', src, coords.x, coords.y, coords.z, coords.heading, model,
            weapons)
    else
        print('Något gick snett, karaktären kunde inte laddas: ' .. identifier .. ' CID: ' .. cindex)
    end
end)

RegisterServerEvent('TPF:server:spawnmenu_save', function(x, y, z, heading, model, playerWeapons)
    local identifier = GetPlayerIdentifier(source, 0)

    local lastPos = '{' .. x .. ',' .. y .. ',' .. z .. ', ' .. heading .. '}'
    local weapons = table.concat(playerWeapons, ",")

    local result = MySQL.Sync.fetchAll("SELECT cindex FROM users WHERE steamid = @steamid AND active = true", {
        ['@steamid'] = identifier
    })

    if result ~= nil then
        local cindex = result[1].cindex
        local success = MySQL.Sync.execute(
            "UPDATE users SET lastpos = @lastpos, model = @model, weapons = @weapons WHERE steamid = @steamid AND cindex = @cindex",
            {
                ['@lastpos'] = lastPos,
                ['@model']   = model,
                ['@weapons'] = weapons,
                ['@steamid'] = identifier,
                ['@cindex']  = cindex,
            })
        if success == 1 then
            return
        else
            print('Något gick snett: Sparning misslyckades, okänt fel. (Kunde inte uppdatera databasen)')
            return
        end
    else
        print("Något gick snett: Sparning misslyckades, cindex hittades ej.")
        return
    end
end)

-- REegistrera server event,inför i databasen.
RegisterServerEvent('TPF:server:spawnmenu_create', function(charData)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    local result = MySQL.Sync.fetchScalar("SELECT 1 FROM users WHERE steamid = @steamid AND cindex = @cindex", {
        ['@steamid'] = identifier,
        ['@cindex'] = charData.cindex,
    })

    if result ~= nil then
        TriggerClientEvent('chatMessage', src, "[TPF]", { 148, 0, 211 },
            "Du har redan en karaktär på karaktärsid't " .. charData.cindex)
        print(identifier ..
            " försökte skapa en karaktär på karaktärsid't " .. charData.cindex .. " men har redan en karaktär där.")
        return
    end

    local firstname, lastname, age, dob, gender, cindex = charData.firstname, charData.lastname, charData.age,
        charData.dob, charData
        .gender, charData.cindex
    local model
    if gender == "male" then
        model = "a_m_m_hasjew_01"
    else
        model = "a_f_y_femaleagent"
    end
    local steamname = GetPlayerName(src)
    local success = MySQL.Sync.execute(
        "INSERT INTO users (steamname, steamid, firstname, lastname, age, dob, gender, model, cindex) VALUES (@steamname, @steamid, @firstname, @lastname, @age, @dob, @gender, @model, @cindex)",
        {
            ['@steamname'] = steamname,
            ['@steamid'] = identifier,
            ['@firstname'] = firstname,
            ['@lastname'] = lastname,
            ['@age'] = age,
            ['@dob'] = dob,
            ['@gender'] = gender,
            ['@model'] = model,
            ['@cindex'] = cindex,
        })

    if success == 1 then
        TriggerClientEvent("TPF:client:spawnmenu_close", src)
        Citizen.Wait(500)
        TriggerEvent("TPF:server:spawnmenu_open", src)
    else
        TriggerClientEvent("chatMessage", src, "[TPF]", { 148, 0, 211 },
            "Något gick snett: Det gick inte att införa nya karaktären i databasen. Kontakta support.")
        print("Ett problem uppstod: Det gick inte att införa " ..
            steamname ..
            "s karaktär i databasen. \nSteamID: " ..
            steamid ..
            "\nFörnamn: " ..
            firstname ..
            "\nEfternamn: " .. lastname .. "\nÅlder: " ..
            age .. "\nFödelsedag: " .. dob .. "\nKön: " .. gender .. "\nCindex: " .. cindex)
        return
    end
end)

RegisterServerEvent('TPF:server:spawnmenu_delete', function(cindex)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    local success = MySQL.Sync.execute('DELETE FROM users WHERE steamid = @steamid AND cindex = @cindex', {
        ['@steamid'] = identifier,
        ['@cindex'] = cindex
    })

    if success == 1 then
        MySQL.Async.execute('DELETE FROM accounts WHERE steamid = @steamid AND cindex = @cindex', {
            ['@steamid'] = identifier,
            ['@cindex'] = cindex,
        }, function(rowsAffected)
            MySQL.Async.execute('DELETE FROM transactions WHERE steamid = @steamid AND cindex = @cindex', {
                ['@steamid'] = identifier,
                ['@cindex'] = cindex,
            }, function()
                TriggerClientEvent("TPF:client:spawnmenu_close", src)
                Citizen.Wait(500)
                TriggerEvent("TPF:server:spawnmenu_open", src)
            end)
        end)
    else
        print("Något gick fel: Försökte att radera " ..
            identifier ..
            "s " .. cindex .. " karaktär men misslyckades. Antingen finns den inte, eller så är det något annat fel.")
        print(success)
        TriggerClientEvent("chatMessage", src, "[TPF]", { 148, 0, 211 },
            "Något gick snett: Det gick inte att radera karaktären. Kontakta support.")
        return
    end
end)


-- Economy

RegisterServerEvent('TPF:server:economy_openATM', function(src)
    local playerId = tonumber(src)
    local identifier = GetPlayerIdentifier(playerId, 0)

    MySQL.Async.fetchAll('SELECT gender, cindex FROM users WHERE steamid = @steamid AND active = 1', {
        ['@steamid'] = identifier,
    }, function(result)
        if result and result[1] then
            local cindex = result[1].cindex
            local gender = result[1].gender

            MySQL.Async.fetchAll(
                'SELECT `transaction-id`, firstname, lastname, balance, job FROM accounts WHERE steamid = @steamid AND cindex = @cindex',
                {
                    ['@steamid'] = identifier,
                    ['@cindex'] = cindex
                }, function(res)
                    if res[1] then
                        local transactionId = res[1]['transaction-id']
                        local firstname     = res[1].firstname
                        local lastname      = res[1].lastname
                        local balance       = res[1].balance
                        local job           = res[1].job

                        local accountData   = {
                            id           = transactionId,
                            firstname    = firstname,
                            lastname     = lastname,
                            balance      = balance,
                            job          = job,
                            transactions = {},
                            cindex       = cindex,
                        }

                        MySQL.Async.fetchAll(
                            'SELECT `transaction-id`, amount, type, reciver, date FROM transactions WHERE steamid = @steamid AND cindex = @cindex ORDER BY id DESC',
                            {
                                ['@steamid'] = identifier,
                                ['@cindex'] = cindex,
                            },
                            function(res2, err)
                                if err then
                                    print('Error fetching transactions: ' .. err)
                                    return
                                end

                                if res2 then
                                    -- Loopa igenom alla transactions, skapa en array med alla transaktioner och lägg till dem i accountData.
                                    for i = 1, #res2 do
                                        local transaction = {
                                            id      = res2[i]['transaction-id'],
                                            money   = res2[i].amount,
                                            type    = res2[i].type,
                                            reciver = res2[i].reciver,
                                            date    = res2[i].date,
                                        }
                                        table.insert(accountData.transactions, transaction)
                                    end
                                end
                                TriggerClientEvent('TPF:client:economy_openATM', src, accountData, gender)
                            end
                        )
                    else
                        TriggerEvent('TPF:server:economy_openAccount', src, identifier)
                        TriggerClientEvent('chatMessage', src, "TPF", { 148, 0, 211 },
                            "Hittade inget konto. Skapar ett nytt...")
                        return
                    end
                end
            )
        else
            TriggerClientEvent('chatMessage', src, "TPF", { 148, 0, 211 },
                "Det gick inte att hämta ditt bankkonto. Kontakta Support.")
            print('Misslyckades att hämta ett bankkonto för ' ..
                identifier .. ". Kunde inte hämta 'cindex' från users.")
            print(result)
            return
        end
    end)
end)

RegisterServerEvent('TPF:server:economy_openAccount', function(src, identifier)
    MySQL.Async.fetchAll("SELECT firstname, lastname, job, cindex FROM users WHERE steamid = @steamid AND active = true",
        {
            ["@steamid"] = identifier
        }, function(result)
            if result[1] then
                local firstname     = result[1].firstname
                local lastname      = result[1].lastname
                local job           = result[1].job
                local cindex        = result[1].cindex
                local transactionId = generateRandomId()

                MySQL.Async.fetchScalar('SELECT id FROM accounts WHERE steamid = @steamid AND cindex = @cindex', {
                    ['@steamid'] = identifier,
                    ['@cindex']  = cindex,
                }, function(res)
                    if res then
                        TriggerClientEvent('chatMessage', src, "TPF", { 148, 0, 211 },
                            "Det gick inte att öppna ett bankkonto. Kontakta Support.")
                        print('Misslyckades att öppna ett bankkonto för ' ..
                            identifier .. ". Användaren har redan ett bankkonto med cindex " .. cindex)
                        print(res)
                        return
                    else
                        local startingBalance = _C.startingBalance
                        MySQL.Async.execute(
                            'INSERT INTO accounts (`transaction-id`, steamid, firstname, lastname, balance, job, cindex) VALUES (@transactionId, @steamid, @firstname, @lastname, @balance, @job, @cindex)',
                            {
                                ['@transactionId'] = transactionId,
                                ['@steamid']       = identifier,
                                ['@firstname']     = firstname,
                                ['@lastname']      = lastname,
                                ['@balance']       = startingBalance,
                                ['@job']           = job,
                                ['@cindex']        = cindex,
                            }, function(rowsAffected)
                                if rowsAffected > 0 then
                                    local sender = "Svea Bank"
                                    local subject = "Välkommen till oss"
                                    local message = "Som välkomstbonus har du fått ~g~" .. startingBalance .. "kr."
                                    TriggerClientEvent('TPF:client:economy_notifyUser', src, message, sender, subject,
                                        "CHAR_SVEA_BANK", 9, true, 40)
                                    print(identifier .. ' öppnade ett bankkonto.')
                                    return
                                else
                                    TriggerClientEvent('chatMessage', src, "TPF", { 148, 0, 211 },
                                        "Det gick inte att öppna ett bankkonto. Kontakta Support.")
                                    print('Misslyckades att öppna ett bankkonto för ' ..
                                        identifier .. ". Kunde inte införa i database.")
                                    return
                                end
                            end
                        )
                    end
                end)
            else
                TriggerClientEvent('chatMessage', src, "TPF", { 148, 0, 211 },
                    "Det gick inte att öppna ett bankkonto. Kontakta Support.")
                print('Misslyckades att öppna ett bankkonto för ' ..
                    identifier .. ". Kunde inte hämta 'cindex' från users.")
                print(result)
                return
            end
        end)
end)


RegisterServerEvent('TPF:server:economy_sendTransaction', function(transaction)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)

    MySQL.Async.fetchScalar('SELECT cindex FROM users WHERE steamid = @steamid AND active = 1', {
        ["@steamid"] = identifier,
    }, function(cindex)
        if cindex then
            MySQL.Async.fetchAll(
                'SELECT `transaction-id`, balance, firstname, lastname FROM accounts WHERE steamid = @steamid AND cindex = @cindex',
                {
                    ['@steamid'] = identifier,
                    ['@cindex'] = cindex
                }, function(result)
                    if result then
                        local reciverId = transaction.transactionId
                        if reciverId == result[1]['transaction-id'] then
                            TriggerClientEvent('TPF:client:economy:callback_nui', source, true,
                                "~r~Du kan inte skicka pengar till ~b~dig själv.")
                            return
                        end
                        MySQL.Async.fetchAll(
                            'SELECT steamid, firstname, lastname, cindex FROM accounts WHERE `transaction-id` = @reciverId',
                            {
                                ['@reciverId'] = reciverId
                            }, function(reciver)
                                if reciver[1] then
                                    if not (reciver[1].firstname == transaction.firstname) then
                                        TriggerClientEvent('TPF:client:economy:callback_nui', source, true,
                                            "~r~Konto nummrets namn matchade inte namnet du angav. ~b~Kontrollera namnet och ~g~Försök igen.")
                                        return
                                    end

                                    if not (reciver[1].lastname == transaction.lastname) then
                                        TriggerClientEvent('TPF:client:economy:callback_nui', source, true,
                                            "~r~Konto nummrets efternamn matchade inte efternamnet du angav. ~b~Kontrollera efternamnet")
                                        return
                                    end

                                    local transactionAmount = transaction.amount
                                    if tonumber(transactionAmount) > result[1].balance then
                                        TriggerClientEvent('TPF:client:economy:callback_nui', source, true,
                                            "~r~Du har inte tillräckligt mycket ~g~pengar ~r~i ditt ~b~saldo!")
                                        return
                                    end

                                    MySQL.Async.execute(
                                        "UPDATE accounts SET balance = balance - @amount WHERE steamid = @steamid AND cindex = @cindex",
                                        {
                                            ['@amount'] = transactionAmount,
                                            ['@steamid'] = identifier,
                                            ['@cindex'] = cindex
                                        }, function(rowsAffected)
                                            if rowsAffected == 1 then
                                                MySQL.Async.execute(
                                                    "UPDATE accounts SET balance = balance + @amount WHERE `transaction-id` = @reciverId",
                                                    {
                                                        ['@amount'] = transactionAmount,
                                                        ['@reciverId'] = reciverId,
                                                    }, function(rowsAffected2)
                                                        if rowsAffected2 == 1 then
                                                            local transactionId = generateRandomId()
                                                            local amount = 'SEK' .. transactionAmount
                                                            local type = "Överförning"
                                                            local transactionReciver = "Till " ..
                                                                reciver[1].firstname .. ' ' .. reciver[1].lastname
                                                            local note = transaction.note
                                                            local date = os.date('%d/%m-%Y')

                                                            -- Adding the transaction for the user who made the transaction
                                                            MySQL.Async.execute(
                                                                'INSERT INTO transactions (`transaction-id`, steamid, amount, type, reciver, note, date, cindex) VALUES (@transactionId, @steamid, @amount, @type, @reciver, @note, @date, @cindex)',
                                                                {
                                                                    ['@transactionId'] = transactionId,
                                                                    ['@steamid'] = identifier,
                                                                    ['@amount'] = amount,
                                                                    ['@type'] = type,
                                                                    ['@reciver'] = transactionReciver,
                                                                    ['@note'] = note,
                                                                    ['@date'] = date,
                                                                    ['@cindex'] = cindex
                                                                }, function(rowsAffected3)
                                                                    if rowsAffected3 == 1 then
                                                                        local reciverSteam = reciver[1].steamid
                                                                        local transactionSender = "Av " ..
                                                                            result[1].firstname ..
                                                                            " " .. result[1].lastname
                                                                        local reciverCindex = reciver[1].cindex
                                                                        MySQL.Async.execute(
                                                                            "INSERT INTO transactions (`transaction-id`, steamid, amount, type, reciver, note, date, cindex) VALUES (@transactionId, @steamid, @amount, @type, @reciver, @note, @date, @cindex)",
                                                                            {
                                                                                ['@transactionId'] = transactionId,
                                                                                ['@steamid'] = reciverSteam,
                                                                                ['@amount'] = amount,
                                                                                ['@type'] = type,
                                                                                ['@reciver'] = transactionSender,
                                                                                ['@note'] = note,
                                                                                ['@date'] = date,
                                                                                ['@cindex'] = reciverCindex
                                                                            }, function(success)
                                                                                if success == 1 then
                                                                                    local reciverFirstname = reciver
                                                                                        [1].firstname
                                                                                    local reciverLastname = reciver
                                                                                        [1].lastname
                                                                                    local message = "~g~Skickade ~b~" ..
                                                                                        amount ..
                                                                                        " ~g~till " ..
                                                                                        reciverFirstname ..
                                                                                        " " .. reciverLastname .. "."
                                                                                    TriggerClientEvent(
                                                                                        'TPF:client:economy:callback_nui',
                                                                                        source, false, message)


                                                                                    local title =
                                                                                    "En transaktion genomfördes."

                                                                                    local discordMessage =
                                                                                        '*' .. result[1].firstname ..
                                                                                        ' ' ..
                                                                                        result[1].lastname ..
                                                                                        '* överförde **' ..
                                                                                        amount ..
                                                                                        '** till *' ..
                                                                                        reciverFirstname ..
                                                                                        ' ' ..
                                                                                        reciverLastname ..
                                                                                        '*.\n' ..
                                                                                        result[1].firstname ..
                                                                                        '\n`' ..
                                                                                        identifier ..
                                                                                        '`\n`cindex: ' ..
                                                                                        cindex ..
                                                                                        '`\n`ID: ' ..
                                                                                        result[1]['transaction-id'] ..
                                                                                        '`\n\n' ..
                                                                                        reciverFirstname ..
                                                                                        '\n`' ..
                                                                                        reciverSteam ..
                                                                                        '`\n`cindex: ' ..
                                                                                        reciverCindex ..
                                                                                        '`\n`ID: ' ..
                                                                                        reciverId ..
                                                                                        '`\n\n## Transaktions ID: ' ..
                                                                                        transactionId

                                                                                    TriggerEvent(
                                                                                        'TPF:server:economy_discordLog',
                                                                                        title, discordMessage,
                                                                                        "transaction")
                                                                                end
                                                                            end)
                                                                    end
                                                                end)
                                                        else
                                                            TriggerClientEvent(
                                                                'TPF:client:economy:callback_nui', source,
                                                                true,
                                                                "~r~Misslyckades att lägga till pengar i mottagarens konto! ~b~Kontakta Support.")
                                                            print('Transaktion Misslyckades för ' ..
                                                                identifier ..
                                                                ' Kunde inte lägga till ' .. transactionAmount)
                                                            return
                                                        end
                                                    end)
                                            else
                                                TriggerClientEvent('TPF:client:economy:callback_nui', source,
                                                    true,
                                                    "~r~Misslyckades att ta bort pengar från ditt konto! ~b~Kontakta Support.")
                                                print('Transaktion Misslyckades för ' ..
                                                    identifier .. ' Kunde inte ta bort ' .. transactionAmount)
                                                return
                                            end
                                        end)
                                else
                                    TriggerClientEvent('TPF:client:economy:callback_nui', source, true,
                                        "~r~Kontots namn matchade inget aktivt konto. ~b~Kontrollera Transaktions ID't och ~g~Försök igen.")
                                    return
                                end
                            end)
                    else
                        local error = "~r~Vi hittade inget saldo för ditt konto! ~b~Kontakta Support."
                        TriggerClientEvent('TPF:client:economy:callback_nui', source, true, error)
                        print('Transaktionen misslyckades, kunde inte hämta ett bankkonto för ' ..
                            identifier .. ". Kunde inte hämta 'balance' från accounts.")
                    end
                end)
        else
            local error = "~r~Vi hittade inget 'cindex' för din karaktär! ~b~Kontakta Support."
            TriggerClientEvent('TPF:client:economy:callback_nui', source, true, error)
            print('Transaktionen misslyckades, kunde inte hämta ett bankkonto för ' ..
                identifier .. ". Kunde inte hämta 'cindex' från users.")
        end
    end)
end)


RegisterServerEvent('TPF:server:economy_displayBalance', function(source)
    source = source
    local identifier = GetPlayerIdentifier(source, 0)

    MySQL.Async.fetchScalar('SELECT cindex FROM users WHERE steamid = @steamid and active = 1', {
        ['@steamid'] = identifier
    }, function(cindex)
        if cindex then
            MySQL.Async.fetchAll('SELECT balance, cash FROM accounts WHERE steamid = @steamid AND cindex = @cindex', {
                ['@steamid'] = identifier,
                ['@cindex'] = cindex,
            }, function(result)
                if #result > 0 then
                    local bank = result[1].balance
                    local cash = result[1].cash
                    TriggerClientEvent('TPF:client:economy_displayBalance', source, bank, cash)
                end
            end)
        end
    end)
end)

RegisterServerEvent('TPF:server:economy_distributeSalary', function(src)
    local identifier = GetPlayerIdentifier(src, 0)
    MySQL.Async.fetchScalar('SELECT cindex FROM users WHERE steamid = @steamid AND active = 1', {
        ['@steamid'] = identifier
    }, function(cindex)
        if cindex then
            MySQL.Async.fetchAll('SELECT steamid, balance, cash, job, job_level FROM accounts WHERE cindex = @cindex', {
                ['@cindex'] = cindex
            }, function(account)
                if account and account[1] then
                    local steamid  = account[1].steamid
                    local job      = account[1].job
                    local jobLevel = account[1].job_level
                    local balance  = account[1].balance
                    local cash     = account[1].cash

                    MySQL.Async.fetchAll(
                        'SELECT title, salary FROM job WHERE job_name = @job AND job_level = @jobLevel', {
                            ['@job'] = job,
                            ['@jobLevel'] = jobLevel
                        }, function(jobInfo)
                            if jobInfo and jobInfo[1] then
                                local title = jobInfo[1].title
                                local salary = jobInfo[1].salary
                                local lastPaycheck = os.date("%d/%m-%Y %X")

                                MySQL.Async.execute(
                                    'UPDATE accounts SET balance = balance + @salary, last_paycheck = @lastPaycheck WHERE steamid = @steamid AND cindex = @cindex',
                                    {
                                        ['@salary']       = salary,
                                        ['@lastPaycheck'] = lastPaycheck,
                                        ['@steamid']      = steamid,
                                        ['@cindex']       = cindex,
                                    }, function(rowsAffected)
                                        if rowsAffected > 0 then
                                            if job == "developer" then
                                                local newBalance = balance + salary
                                                TriggerClientEvent('TPF:client:economy_notifySalary', src, salary,
                                                    newBalance, cash)
                                                return
                                            end

                                            local transactionId = generateRandomId()
                                            local amount = "SEK" .. salary
                                            local type = "Lön"
                                            local reciver = "Från " .. title
                                            local date = os.date('%d/%m-%Y') -- 7/21-2023
                                            local query =
                                            "INSERT INTO transactions (`transaction-id`, steamid, amount, type, reciver, date, cindex) VALUES (@transactionId, @steamid, @amount, @type, @reciver, @date, @cindex)"
                                            MySQL.Async.execute(query,
                                                {
                                                    ['@transactionId'] = transactionId,
                                                    ['@steamid']       = steamid,
                                                    ['@amount']        = amount,
                                                    ['@type']          = type,
                                                    ['@reciver']       = reciver,
                                                    ['@date']          = date,
                                                    ['@cindex']        = cindex
                                                }, function(success)
                                                    if success > 0 then
                                                        local newBalance = balance + salary
                                                        TriggerClientEvent('TPF:client:economy_notifySalary', src, salary,
                                                            newBalance, cash)
                                                        return
                                                    else
                                                        print('Kunde inte betala ut lön till ' .. steamid)
                                                        return
                                                    end
                                                end)
                                        end
                                    end)
                            end
                        end)
                end
            end)
        end
    end)
end)

RegisterServerEvent('TPF:server:economy_withdraw', function(src, amount)
    local identifier = GetPlayerIdentifier(src, 0)

    MySQL.Async.fetchScalar('SELECT cindex FROM users WHERE steamid = @steamid AND active = 1', {
        ['@steamid'] = identifier,
    }, function(cindex)
        if cindex then
            MySQL.Async.fetchScalar('SELECT balance FROM accounts WHERE steamid = @steamid and cindex = @cindex', {
                ['@steamid'] = identifier,
                ['@cindex']  = cindex,
            }, function(availableBalance)
                if availableBalance then
                    if amount > availableBalance then
                        --err handeling
                        TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                            "~r~Din begäran är för stor för ditt ~b~tillgängliga saldo.")
                        return
                    end

                    MySQL.Async.execute(
                        'UPDATE accounts SET balance = balance - @amount, cash = cash + @amount WHERE steamid = @steamid AND cindex = @cindex',
                        {
                            ['@amount']  = amount,
                            ['@steamid'] = identifier,
                            ['@cindex']  = cindex,
                        }, function(rowsAffected)
                            if rowsAffected > 0 then
                                --success
                                local transactionId = generateRandomId()
                                local type          = "Uttag"
                                local reciver       = "Kontanter"
                                local date          = os.date('%d/%m-%Y')
                                amount              = 'SEK' .. tostring(amount)

                                MySQL.Async.execute(
                                    "INSERT INTO transactions (`transaction-id`, steamid, amount, type, reciver, date, cindex) VALUES (@transactionId, @steamid, @amount, @type, @reciver, @date, @cindex)",
                                    {
                                        ['@transactionId'] = transactionId,
                                        ['@steamid']       = identifier,
                                        ['@amount']        = amount,
                                        ['@type']          = type,
                                        ['@reciver']       = reciver,
                                        ['@date']          = date,
                                        ['@cindex']        = cindex
                                    }, function(success)
                                        if success == 1 then
                                            local message = "~g~Tog ut ~b~" .. amount .. " ~g~kontanter."
                                            TriggerClientEvent('TPF:client:economy:callback_nui', src, false, message)
                                        else
                                            TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                                                "~r~Kunde inte lägga till en transaktion till uttaget. ~b~Kontakta Support.")
                                            print('Kunde inte lägga till transaktion för uttag på ' ..
                                                amount .. " " .. identifier .. " cindex: " .. cindex)
                                            return
                                        end
                                    end)
                            else
                                TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                                    "~r~Kunde inte uppdatera ditt saldo eller kontanter. ~b~Kontakta Support.")
                                print('Kunde inte uppdatera ' ..
                                    identifier .. " banksaldo och kontanter. Cindex: " .. cindex .. " Belopp: " .. amount)
                                return
                            end
                        end)
                else
                    TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                        "~r~Hittade inte ett kopplat konto till dig. ~b~Kontakta Support.")
                    print('Kunde inte hitta ett konto kopplat till ' .. identifier .. ' karaktären nr ' .. cindex)
                    return
                end
            end)
        else
            TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                "~r~Kunde inte hitta cindex för din karaktär. ~b~Kontakta Support.")
            print('Kunde inte hitta cindex för aktiva karaktären hos ' .. identifier)
            return
        end
    end)
end)
RegisterServerEvent('TPF:server:economy_deposit', function(src, amount)
    local identifier = GetPlayerIdentifier(src, 0)

    MySQL.Async.fetchScalar('SELECT cindex FROM users WHERE steamid = @steamid AND active = 1', {
        ['@steamid'] = identifier,
    }, function(cindex)
        if cindex then
            MySQL.Async.fetchScalar('SELECT cash FROM accounts WHERE steamid = @steamid and cindex = @cindex', {
                ['@steamid'] = identifier,
                ['@cindex']  = cindex,
            }, function(availableCash)
                if availableCash then
                    if amount > availableCash then
                        --err handeling
                        TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                            "~r~Din begäran är för stor för dina ~b~kontanter.")
                        return
                    end

                    MySQL.Async.execute(
                        'UPDATE accounts SET balance = balance + @amount, cash = cash - @amount WHERE steamid = @steamid AND cindex = @cindex',
                        {
                            ['@amount']  = amount,
                            ['@steamid'] = identifier,
                            ['@cindex']  = cindex,
                        }, function(rowsAffected)
                            if rowsAffected > 0 then
                                --success
                                local transactionId = generateRandomId()
                                local type          = "Insättning"
                                local reciver       = "Kontanter"
                                local date          = os.date('%d/%m-%Y')
                                amount              = 'SEK' .. tostring(amount)

                                MySQL.Async.execute(
                                    "INSERT INTO transactions (`transaction-id`, steamid, amount, type, reciver, date, cindex) VALUES (@transactionId, @steamid, @amount, @type, @reciver, @date, @cindex)",
                                    {
                                        ['@transactionId'] = transactionId,
                                        ['@steamid']       = identifier,
                                        ['@amount']        = amount,
                                        ['@type']          = type,
                                        ['@reciver']       = reciver,
                                        ['@date']          = date,
                                        ['@cindex']        = cindex
                                    }, function(success)
                                        if success == 1 then
                                            local message = "~g~Satt in ~b~" .. amount .. " ~g~kontanter."
                                            TriggerClientEvent('TPF:client:economy:callback_nui', src, false, message)
                                        else
                                            TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                                                "~r~Kunde inte lägga till en transaktion till insättningen. ~b~Kontakta Support.")
                                            print('Kunde inte lägga till transaktion för insättningen på ' ..
                                                amount .. " " .. identifier .. " cindex: " .. cindex)
                                            return
                                        end
                                    end)
                            else
                                TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                                    "~r~Kunde inte uppdatera ditt saldo eller kontanter. ~b~Kontakta Support.")
                                print('Kunde inte uppdatera ' ..
                                    identifier .. " banksaldo och kontanter. Cindex: " .. cindex .. " Belopp: " .. amount)
                                return
                            end
                        end)
                else
                    TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                        "~r~Hittade inte ett kopplat konto till dig. ~b~Kontakta Support.")
                    print('Kunde inte hitta ett konto kopplat till ' .. identifier .. ' karaktären nr ' .. cindex)
                    return
                end
            end)
        else
            TriggerClientEvent('TPF:client:economy:callback_nui', src, true,
                "~r~Kunde inte hitta cindex för din karaktär. ~b~Kontakta Support.")
            print('Kunde inte hitta cindex för aktiva karaktären hos ' .. identifier)
            return
        end
    end)
end)
