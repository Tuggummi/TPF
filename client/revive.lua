-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

AddEventHandler('onClientMapStart', function()
	Citizen.Trace("Disabling autospawn...")
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("Autospawn disabled!")
end)

RegisterNetEvent("TPF_revivePlayer")
AddEventHandler("TPF_revivePlayer", function(target, userId)
    DoScreenFadeOut(1000)
    --Small delay for the players' view
    Wait(1000)
    local ped = GetPlayerPed(-1)
    if (not IsEntityDead(ped)) then
        healPlayer(ped)
    else
        revivePlayer(ped)
    end
    
    Wait(1200)
    DoScreenFadeIn(1000)
end)
