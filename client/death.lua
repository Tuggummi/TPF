-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

local location = '^1{^2Deathsystem^1}^7 ~ '

-- Variables
IsDown = false
IsDead = false
remaining = Config.BleedoutTimer
local ReviveTimer = Config.ReviveTime
local RespawnTime = Config.RespawnTime
local revive = false
local respawn = false

-- Bleedout timer
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if remaining > 0 and IsDown or IsDead == true then
            remaining = remaining -1
        end
    end
end)

-- When player reaches a specified health, they pass out.
Citizen.CreateThread(function()
    while true do
        local health = GetEntityHealth(PlayerPedId(-1))
        Citizen.Wait(0)
        if health > Config.DeadHealth and health < Config.DownHealth then
            IsDown = true
            IsDead = false
        end
    end
end)

-- When player looses more health, they die.
Citizen.CreateThread(function()
    while true do
        local health = GetEntityHealth(PlayerPedId(-4))
        Citizen.Wait(0)
        if health < Config.DeadHealth then
            IsDown = false
            IsDead = true
        end
    end
end)

-- if player is down an animatoin will play.
Citizen.CreateThread(function()
    while true do
		
    	local ped = PlayerPedId(-1)
        Citizen.Wait(0)
        if IsDown == true then

			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)        
        	downText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "random@dealgonewrong" )
			TaskPlayAnim(PlayerPedId(-1), "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)

		end
	end
end)

-- if the player is dead then this animation will play.
Citizen.CreateThread(function()
    while true do
		
    	local ped = PlayerPedId(-1)
        Citizen.Wait(0)
        if IsDead == true then

			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)
        	deadText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "dead" )
			TaskPlayAnim(PlayerPedId(-1), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
			
		end
	end
end)

-- If a player is passed out, they can revive
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		if IsDown == true then
			if IsControlPressed(0, 47) then
				reviving = true
				revive = true
				text("~p~" .. Config.ReviveText .. "~b~" .. ReviveTimer .. "")
			elseif IsControlReleased(0, 47) then
				reviving = false
				revive = false
				ReviveTimer = Config.ReviveTime
			end
		end
	end
end)

-- When a player is dead, they can respawn
Citizen.CreateThread(function(source)
    while true do
		Citizen.Wait(0)

		if IsDead == true then
			if IsControlPressed(0, 47) then
				respawn = true
				text("~p~" .. Config.RespawnText .. "~b~" .. RespawnTimer .. "")
			elseif IsControlReleased(0, 47) then
				respawn = false
				RespawnTimer = Config.RespawnTime
			end
		end
	end
end)

-- The timers:
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)

		if revive == true then
			if ReviveTimer > 0 then
				ReviveTimer = ReviveTimer -1
			elseif ReviveTimer == 0 then
				ReviveTimer = Config.ReviveTime
				RevivePlayer()
				revive = false
			end
		elseif respawn == true then
			if RespawnTimer > 0 then
				RespawnTimer = RespawnTimer -1
			elseif RespawnTimer == 0 then
				RespawnTimer = Config.RespawnTime
				RespawnPlayer()
				respawn = false
			end
		end
	end
end)

if Config.debugMode then
	-- Commands
	if Config.debugPrint then print(location .. 'Debug mode ^2active^0, creating commands ^4down, die, revive and respawn^0.') end
	RegisterCommand("down", function(source, args, rawCommand)
		IsDead = false
		IsDown = true
	end)

	RegisterCommand("die", function(source, args, rawCommand)
		IsDown = false
		IsDead = true
	end)

	RegisterCommand("revive", function(source, args, rawCommand)   
		if IsDown or IsDead == true then
			RevivePlayer()
		end     
	end)

	RegisterCommand("respawn", function(source, args, rawCommand)   
		if IsDown or IsDead == true then
			RespawnPlayer()
		end     
	end)
end
