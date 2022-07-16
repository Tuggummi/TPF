-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

local location = '^1{^2Not Wanted^1}^7 ~ '

if Config.disableWantedLevel then
    if Config.debugPrint then print(location .. "Disabling wanted level...") end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetPlayerWantedLevel(PlayerId()) ~= 0 then
                SetPlayerWantedLevel(PlayerId(), 0, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
            end
        end
    end)
    if Config.debugPrint then print(location .. "Wanted level disabled.") end
end