-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

-- The notification
function TPFNotify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

-- Heal player function, if the player's alive.
function healPlayer(ped)
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
end

-- Revive lpayer function, if the player's dead.
function revivePlayer(ped)
    local playerPos = GetEntityCoords(ped, true)

	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end


staffs = Config.staffs
function isAllowed(player)
    local allowed = false
    for i,id in ipairs(staffs) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

function GetVehicleCloseby(entFrom, coordFrom, coordTo)
    local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    if (IsEntityAVehicle(vehicle)) then 
        return vehicle
    end
end