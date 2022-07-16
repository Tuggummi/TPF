-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

local location = '^1{^2Revive^1}^7 ~ '

if Config.reviveCommand then 

    if Config.debugPrint then print(location .. 'Creating revive command...') end
    RegisterCommand('revive', function(source, args)
        local user = source
        
        if Config.allowEveryoneToRevive == false then
            if not isAllowed(user) then
                TriggerClientEvent("chatMessage", user, "TPF", {148,0,211} , "Du har inte tillstånd att använda detta kommando!")
                if Config.debugPrint then print(location .. 'User ' .. GetPlayerName(user) .. " tried to execute the revive command, but isn't allowed.") end
                return
            end
        end

        local target = args[1]

        userId = tostring(user)

        if target == nil then
            target = userId
        end

        if not tonumber(target, 10) then
            TriggerClientEvent("chatMessage", userId, "TPF", {148,0,211} , "Det du angav, ~y~" .. target .. "~w~, är ~r~inte~w~ ett ~g~nummer.")
            return
        end

        if (target == nil or target == 0 or GetPlayerName(target) == nil) then
            TriggerClientEvent("chatMessage", userId, "TPF", {148,0,211} , "Det du angav, ~y~"  .. target .. "~w~, är ~r~inte~w~ ett ~g~korrekt spelarID.")
            return
        end

        TriggerClientEvent("TPF_revivePlayer", target, userId)

        Wait(3000)
        if target == userId then
            TriggerClientEvent("chatMessage", user, "TPF", {148,0,211}, "Du revivade ^6 dig själv.")
            if Config.debugPrint then print(location .. '' .. GetPlayerName(user) .. ' revived themselves' ) end
        else
            TriggerClientEvent("chatMessage", user, "TPF", {148,0,211}, "Du revivade ^6" .. GetPlayerName(target) .. "^0, ID: ^6" .. target .. "")    
            TriggerClientEvent("chatMessage", target, "TPF", {148,0,211}, "Du blev revivad av ^6" .. GetPlayerName(user) .. "")
            if Config.debugPrint then print(location .. '' .. GetPlayerName(user) .. ' revived ' .. GetPlayerName(target) .. '' ) end
        end
    end)
    if Config.debugPrint then print(location .. 'Revive command created.') end
end