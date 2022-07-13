-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

-- The notification
function Notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

-- Text function
function text(text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.9)
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do        
        Citizen.Wait(1)
    end
end

-- Text when player is down.
function downText(source)
	if remaining > 1 then
        alert(Config.ReviveHelp .. " ~INPUT_DETONATE~ ")
        if reviving == false then
            text("~p~".. Config.TimeRemaining .."~b~" .. remaining .. '')
        else
            return
        end
	end
   	if remaining < 1 then 
		IsDown = false
		IsDead = true
   	end
end

-- Text when player dies.
function deadText(nothing)
	if IsDead == true then
        alert(Config.RespawnHelp .. " ~INPUT_DETONATE~ ")
	end
end

-- Reviving the player
function RevivePlayer()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    SetEnableHandcuffs(ped, false)
    remaining = Config.BleedoutTimer
    IsDead = false
    IsDown = false
    SetPlayerInvisibleLocally(ped, true)
    Wait(300)
    ClearPedTasks(ped)
    SetPlayerInvisibleLocally(ped, false)        
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, true, false)
    SetEntityHealth(ped, 200) 
end

-- Respawning the player
function RespawnPlayer()
    local ped = GetPlayerPed(-1)
    SetEnableHandcuffs(ped, false)
    IsDead = false
    IsDown = false
    DoScreenFadeOut(3000)
    Citizen.Wait(3000)
    SetEntityHealth(GetPlayerPed(-1), 200)      
    SetEntityCoords(GetPlayerPed(-1), 361.2991, -583.1498, 30.0) 
    DoScreenFadeIn(3000)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ResetPedVisibleDamage(GetPlayerPed(-1))
    remaining = Config.BleedoutTimer
end