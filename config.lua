-- Edit this to your liking. --

Config = {

    -----------------------------
    -- G  E  N  E  R  A  L  L  --
    -----------------------------
    
    --If players should be able to get cops after em'. To disable the wanted level; set to true.
    disableWantedLevel = true,

    --No steam opened message, what message to send if the user don't have steam open.
    noSteam = "You need to open steam to connect to the server!",

    --[[
        Without this, you will automatically respawn on death, therefore you will not be dead a longer time.
        The spawning part of TPF will respawn you at the latest location, it could be in the air.

        My suggestion is to always have this enabled, but I'm giving you the opportunity to disable it, if it's what you desire.
    ]]
    disableAutospawn = true,

    -- All staffs who should be able to do various commands, althoug, only the revive command at the moment. 
    staffs = {
        "steam:11000010ab1010c", 
        "ip:12.345.67.890",
    },

    ----------------------------
    -- C  O  M  M  A  N  D  S --
    ----------------------------

    -- REVIVE --
    --Turn on and off.
    reviveCommand = true,

    --Who will be allowed to use this command, if set to false, specify who'm ever is allowed in "staffs".
    --Don't know why you'd set this to true, but, if you'd like...
    allowEveryoneToRevive = false,

    
    -- RCV --
    
    --Repairs the car
    rcvCommand = true,

    -- The fix command, both repair and clean, available for everyone?
    allowFixForEveryone = false,

    -- Who is allowed to use "/fix", specify if allowFixForEveryone = false.
    allowedToFix = {
        'steam:11000011a011b0c',
        'ip:12.345.67.890'
    },

    -----------------------------------
    -- P  E  D    &    S  P  A  W  N --
    -----------------------------------

    --Should the player spawn with the ped defined at Config.pedModel?
    usePedModel = false,
    
    --Which ped to spawn as, requires Config.usePedModel = true https://docs.fivem.net/docs/game-references/ped-models/
    pedModel = 'mp_m_freemode_01',

    --If you'd like to save the players position or not. The default location is still needed to be in the DB!
    savePlayerPos = true, 

    --At what interval the resource should save players location. Described in seconds.
    autoSaveTimer = 20,        --S

    --------------------
    -- D  E  B  U  G  --
    --------------------
    --Should the resource print debug messages, only use if the script isn't working or Tuggummi asks you to.
    debugPrint = false,
}