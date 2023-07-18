-- Funktion för att kolla om spelaren har rätt permissions eller ej.
function isPlayerAllowed(player, allowedPlayers)
    local allowed = false
    local isAllowed = allowedPlayers
    for i,id in ipairs(isAllowed) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local resultStr = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(resultStr, str)
    end
    return resultStr
end