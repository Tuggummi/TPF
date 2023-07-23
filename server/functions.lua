-- Funktion för att kolla om spelaren har rätt permissions eller ej.
function isPlayerAllowed(player, allowedPlayers)
    local allowed = false
    local isAllowed = allowedPlayers
    for i, id in ipairs(isAllowed) do
        for x, pid in ipairs(GetPlayerIdentifiers(player)) do
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

-- Economy

local lastTimestamp = 0

function generateRandomId()
    local timestamp = os.clock()
    if timestamp == lastTimestamp then
        -- If the timestamp is the same as the last one, increment it slightly to ensure uniqueness
        timestamp = timestamp + 0.0001
    end
    lastTimestamp = timestamp

    math.randomseed(timestamp)
    local randomId = ""
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    for i = 1, 5 do -- Generate a 5-character random ID
        local randomIndex = math.random(1, #characters)
        randomId = randomId .. string.sub(characters, randomIndex, randomIndex)
    end

    return randomId
end
