-- Ändra ej.
location = '^1{^2TPF^1}^7 ~ '

_C = {

    -- Här kan ni ändra --

    -- Om spelaren sitter i ett fordon medan de aktiverar /v, ska fordonet de sitter i bli raderat, eller ska den inte göra någonting.
    -- true: Fordonet raderas, den nya spawnar.
    -- false: Spelaren får ett meddelande om vad som gäller, och inget fordon spawnar.
    removeVehicleOnSpawn = true, -- Standard: true | true/false

    -- Tiden mellan varje sparning för Pedmodell, Position och Vapen i sekunder
    autoSaveTimer = 20, -- Standard: 20

    -- Tillgängliga vapen, alla vapen som finns i spelet.
    -- Lägg till spawnnamn ("weapon_name") ifall du vill lägga till fler.
    -- Se till att ha kommatecken!
    -- Orginal: https://wiki.rage.mp/index.php?title=Weapons
    gameWeapons = {

        -- MELEE
        "weapon_dagger",
        "weapon_bat",
        "weapon_bottle",
        "weapon_crowbar",
        "weapon_flashlight",
        "weapon_golfclub",
        "weapon_hammer",
        "weapon_hatchet",
        "weapon_knuckle",
        "weapon_knife",
        "weapon_machete",
        "weapon_switchblade",
        "weapon_nightstick",
        "weapon_wrench",
        "weapon_battleaxe",
        "weapon_poolcue",
        "weapon_stone_hatchet",

        -- HANDGUNS
        "weapon_pistol",
        "weapon_pistol_mk2",
        "weapon_combatpistol",
        "weapon_appistol",
        "weapon_stungun",
        "weapon_pistol50",
        "weapon_snspistol",
        "weapon_snspistol_mk2",
        "weapon_heavypistol",
        "weapon_vintagepistol",
        "weapon_flaregun",
        "weapon_marksmanpistol",
        "weapon_revolver",
        "weapon_revolver_mk2",
        "weapon_doubleaction",
        "weapon_raypistol",
        "weapon_ceramicpistol",
        "weapon_navyrevolver",

        -- SMGs

        "weapon_microsmg",
        "weapon_smg",
        "weapon_smg_mk2",
        "weapon_assaultsmg",
        "weapon_combatpdw",
        "weapon_machinepistol",
        "weapon_minismg",
        "weapon_raycarbine",

        -- SHOTGUNS

        "weapon_pumpshotgun",
        "weapon_pumpshotgun_mk2",
        "weapon_sawnoffshotgun",
        "weapon_assaultshotgun",
        "weapon_bullpupshotgun",
        "weapon_musket",
        "weapon_heavyshotgun",
        "weapon_dbshotgun",
        "weapon_autoshotgun",

        -- ASSAULT RIFLES
        "weapon_assaultrifle",
        "weapon_assaultrifle_mk2",
        "weapon_carbinerifle",
        "weapon_carbinerifle_mk2",
        "weapon_advancedrifle",
        "weapon_specialcarbine",
        "weapon_specialcarbine_mk2",
        "weapon_bullpuprifle",
        "weapon_bullpuprifle_mk2",
        "weapon_compactrifle",

        -- MACHINE GUNS
        "weapon_mg",
        "weapon_combatmg",
        "weapon_combatmg_mk2",
        "weapon_gusenberg",

        -- SNIPER RIFLES
        "weapon_sniperrifle",
        "weapon_heavysniper",
        "weapon_heavysniper_mk2",
        "weapon_marksmanrifle",
        "weapon_marksmanrifle_mk2",

        -- HEAVY WEAPONS
        "weapon_rpg",
        "weapon_grenadelauncher",
        "weapon_grenadelauncher_smoke",
        "weapon_minigun",
        "weapon_firework",
        "weapon_railgun",
        "weapon_hominglauncher",
        "weapon_compactlauncher",
        "weapon_rayminigun",

        -- THROWABLES
        "weapon_grenade",
        "weapon_bzgas",
        "weapon_smokegrenade",
        "weapon_flare",
        "weapon_molotov",
        "weapon_stickybomb",
        "weapon_proxmine",
        "weapon_snowball",
        "weapon_pipebomb",
        "weapon_ball",

        -- MISC
        "weapon_petrolcan",
        "weapon_fireextinguisher",
        "weapon_parachute",
        "weapon_hazardcan",

    },
}
