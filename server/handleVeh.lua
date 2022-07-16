-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

-- Setting the variables.
local location = '^1{^2RCV^1}^7 ~ '

local rcvCommand = Config.rcvCommand
local everyoneAllowedToFix = Config.allowFixForEveryone
local allowedToFix = Config.allowedToFix


-- Creating the commands

if rcvCommand then
    RegisterCommand("repair", function(source)
        TriggerClientEvent("TPF_repairVehicle", source)
    end)

    RegisterCommand("clean", function(source)
        TriggerClientEvent("TPF_cleanVehicle", source)
    end)

    RegisterCommand("fix", function(source)
        if everyoneAllowedToFix then
            TriggerClientEvent("TPF_repairVehicle", source)
            Wait(500)
            TriggerClientEvent("TPF_cleanVehicle", source)
        else
            if not isAllowedFix(source) then
                TriggerClientEvent("chatMessage", source, "TPF", {148,0,211} , _T.notAllowed)
                return
            end
            TriggerClientEvent("TPF_repairVehicle", source)
            Wait(500)
            TriggerClientEvent("TPF_cleanVehicle", source)
        end
    end)
end

function isAllowedFix(player)
    local allowed = false
    for i,id in ipairs(allowedToFix) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end