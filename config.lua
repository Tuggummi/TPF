--Edit this config to your liking. --

Config = {
    --Should the player spawn with the ped defined at Config.pedModel?
    usePedModel = false,
    
    --Which ped to spawn as, requires Config.usePedModel = true https://docs.fivem.net/docs/game-references/ped-models/
    pedModel = 'csb_mp_agent14', --mp_m_freemode_01

    --If you'd like to save the players position or not. The default location is still needed to be in the DB!
    savePlayerPos = true, 

    --At what interval the resource should save players location. Described in MS.
    autoSaveTimer = 10000,        --MS

    --Should the resource print debug messages, only use if the script isn't working or Tuggummi asks you to.
    debugPrint = false,

    --Creating commands for debug purposes. 
    debugMode = false,

    --No steam open message, what message to send if the user don't have steam open.
    noSteam = "You need to open steam to connect to the server!",

    --Where the player should spawn after death.

    --How long before player bleeds out and dies.
    BleedoutTimer = 60,
    --How low health until player goes down.
    DownHealth = 70,
    --How low health for player to die.
    DeadHealth = 5,
    --Time to hold E to revive
    ReviveTime = 5,
    --Time to hold R to respawn
    RespawnTime = 5,

    --Notifications messages
    RespawnText = "You will respawn in ",
    ReviveText = "You will be revived in ",
    TimeRemaining = "You will die in ",
    RespawnHelp = "To respawn, hold ",
    ReviveHelp = "To revive, hold ",
}