_P = {

    -- WEAPON --

    -- Möjlighet att ta fram alla vapen via /weapon
    allWeaponsAllowed = true, -- Standard: true | true/false

    -- Vilka som är tillåtna att ta fram alla vapen
    -- steamid, license, discord, fivem, xbl, ip
    allowedAllWeapons = {
        'steam:11000014d964d3b',
        'steam:11000014d964d3a',
    },

    -- REVIVE --

    -- Tillåt alla spelare att använda kommandot /revive.
    allowEveryoneRevive = false, -- Standard: false | true/false

    -- Vilka spelare som är tillåtna att reviva, om allowEveryoneRevive är false.
    allowedToRevive = {
        'steam:11000014d964d3b',
        'steam:10101010101',
        'xbl:10101010101',
        'discord:010101010101010',
    },

    -- Handle Vehicle --

    -- Tillåt alla spelare att använda alla funktioner | /v, /dv, /fix
    allowEveryoneHandle = false, -- Standard: false, true/false

    -- Tillåt alla spelare att använda /v och /dv
    allowEveryoneManage = false, -- Standard: false, true/false

    -- Tillåt alla spelare att använda /fix
    allowEveryoneFix = false, -- Standard: false, true/false

    -- Vilka spelare som har tillåtelse att använda alla funktioner
    -- (Om allowEveryoneHandle = false)
    allowedToHandle = {
        'steam:1010101010b',
        'xbl:10101010011001',
        'discord:10010101010101010',
    },

    -- Vilka spelare som har tillåtelse att använda /v och /dv
    -- (Om allowEveryoneManage = false)
    allowedToManage = {
        'steam:1010101010b',
        'xbl:10101010011001',
        'discord:10010101010101010',
    },

    -- Vilka spelare som har tillåtelse att använda alla funktioner
    -- (Om allowEveryoneFix = false)
    allowedToFix = {
        'steam:1010101010b',
        'xbl:10101010011001',
        'discord:10010101010101010',
    },
}
