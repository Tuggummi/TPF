function requestSave()
    local playerPed = GetPlayerPed(-1)
    local playerModel = GetEntityArchetypeName(playerPed)

    posX, posY, posZ = table.unpack(GetEntityCoords(playerPed, true))
    local heading = GetEntityHeading(PlayerPedId())

    local gameWeapons = _C.gameWeapons
    local playerWeapons = {}

    for k, weaponsHash in pairs(gameWeapons) do
        if HasPedGotWeapon(playerPed, weaponsHash) then
            table.insert(playerWeapons, weaponsHash)
        end
    end

    TriggerServerEvent('TPF:server:spawnmenu_save', posX, posY, posZ, heading, playerModel, playerWeapons)
end

function autoSave()
    Citizen.CreateThread(function()
        saverRunning = true
        while true do
            Citizen.Wait(_C.autoSaveTimer * 1000)
            requestSave()
        end
    end)
end

function respawnPlayer(ped, pos)
    local playerId = PlayerId()
    local ped = GetPlayerPed(-1)

    alert("~y~Tryck på ~b~R ~y~för att ~g~respawna")

    if GetPlayerWantedLevel(playerId) ~= 0 then
        SetPlayerWantedLevel(playerId, 0, false)
        SetPlayerWantedLevelNow(playerId, false)
    end

    Citizen.CreateThread(function()
        local isRPressed = false
        while true do
            if IsEntityDead(ped) then
                if IsControlJustPressed(0, 45) and isRPressed == false then
                    isRPressed = true
                    local timer = 5
                    while timer > 0 do
                        alert("~r~Du respawnar om ~g~5 ~r~sekunder")
                        Citizen.Wait(1000)
                        timer = timer - 1
                    end

                    local spawnLocations = {
                        vector3(307.93, -584.68, 43.28),   -- Pillbox Hill Medical Center
                        vector3(-498.02, -336.76, 34.50),  -- Mount Zonah Medical Center
                        vector3(293.37, -586.95, 43.24),   -- Central Los Santos Medical Center
                        vector3(362.71, -592.94, 28.69),   -- Elgin Avenue Medical Center
                        vector3(-1392.61, -605.86, 29.32), -- Del Perro Beach Medical Center
                        vector3(1152.90, -1516.90, 35.37), -- St. Fiacre Hospital
                        vector3(-245.42, 6328.27, 32.43),  -- Paleto Bay Medical Center
                        vector3(1839.68, 3672.93, 34.28)   -- Sandy Shores Medical Center
                    }

                    local spawnPos = getClosestCoords(spawnLocations)

                    DoScreenFadeOut(800)
                    Citizen.Wait(400)
                    NetworkResurrectLocalPlayer(spawnPos, true, true, false)
                    SetPlayerInvincible(ped, false)
                    ClearPedBloodDamage(ped)
                    Citizen.Wait(100)
                    DoScreenFadeIn(600)

                    local countdown = 300
                    while countdown > 0 do
                        notify("~g~Du fick sjukvård och känner dig bättre")
                        Citizen.Wait(1)
                        countdown = countdown - 1
                    end
                end
            end
            Citizen.Wait(1)
        end
    end)
end

function getClosestCoords(_coords)
    local closestCoord = nil
    local closestDistance = 100000
    local playerPed = PlayerPedId()
    local coord = GetEntityCoords(playerPed)

    for _, v in pairs(_coords) do
        local distance = #(v - coord)
        if distance <= closestDistance then
            closestDistance = distance
            closestCoord = v
        end
    end

    return closestCoord
end

function revivePlayer()
    local pid = PlayerId()
    local ped = GetPlayerPed(-1)

    if GetPlayerWantedLevel(pid) ~= 0 then
        SetPlayerWantedLevel(pid, 0, false)
        SetPlayerWantedLevelNow(pid, false)
    end

    local spawnPos = GetEntityCoords(PlayerPedId())
    NetworkResurrectLocalPlayer(spawnPos, true, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
end

function healPlayer()
    local ped = GetPlayerPed(-1)

    SetEntityHealth(ped, 200)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
end

function notify(msg)
    BeginTextCommandPrint("STRING")
    AddTextComponentString(msg)
    EndTextCommandPrint(0, false, true, -1)
end

function TPFNotify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

function alert(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, true)
end

function GetVehicleCloseby(entFrom, coordFrom, coordTo)
    local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0,
        10, entFrom, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    if IsEntityAVehicle(vehicle) then
        return vehicle
    end
end

function DeleteTheVehicle(veh, timeoutMax)
    local timeout = 0

    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)

    if DoesEntityExist(veh) then
        TPFNotify("~r~Misslyckades att radera fordonet, försöker igen...")

        while DoesEntityExist(veh) and timeout < timeoutMax do
            DeleteVehicle(veh)

            if not DoesEntityExist(veh) then
                TPFNotify('~g~Fordonet har raderats!')
            end

            timeout = timeout + 1
            Citizen.Wait(500)

            if DoesEntityExist(vehicle) and timeout == timeoutMax - 1 then
                TPFNotify('~r~Misslyckades att radera fordonet. Antal försök: ' .. timeoutMax .. "")
            end
        end
    else
        TPFNotify('~g~Fordonet har raderats!')
    end
end

-- Economy

function DisplayText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function getPedGender()
    local gender = "male"

    local playerPed = GetPlayerPed(-1)
    local playerModel = GetEntityArchetypeName(playerPed)

    if string.find(playerModel, "_f_") then
        gender = "female"
    end

    return gender
end

function playAnimation(dict, name, duration)
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)

    if currentWeapon ~= -1569615261 then
        local unarmed = GetHashKey('WEAPON_UNARMED')
        SetCurrentPedWeapon(playerPed, unarmed, true)
    end

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, dict, name, 8.0, 8.0, duration, 0, 0, false, false, false)
end

function sendSveaNotification(message, sender, subject, textureDict, iconType, saveToBrief, color)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    ThefeedSetNextPostBackgroundColor(color)
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
    EndTextCommandThefeedPostTicker(false, saveToBrief)
end

function ConvertToVector3(coords)
    return vector3(coords.x, coords.y, coords.z)
end

function findClosestATM(playerCoord)
    local closestCoord = nil
    local closestDistance = 999999.0

    for _, atmCoords in ipairs(atmLocations) do
        local coords = ConvertToVector3(atmCoords)
        local distance = #(playerCoord - coords)
        if distance < closestDistance then
            closestCoord = coords
            closestDistance = distance
        end
    end

    return closestCoord
end
