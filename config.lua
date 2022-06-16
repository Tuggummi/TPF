-- Edit this config to your liking. --

Config = {
    -- Should the player spawn with the ped defined at Config.pedModel?
    usePedModel = false,
    
    -- Which ped to spawn as, requires Config.usePedModel = true https://docs.fivem.net/docs/game-references/ped-models/
    pedModel = 'mp_m_freemode_01',

    -- If you'd like to save the players position or not. The default location is still needed to be in the DB!
    savePlayerPos = true, 

    -- At what interval the resource should save players location. Described in MS.
    autoSaveTimer = 15000,        -- MS

    -- Should the resource print debug messages, only use if the script isn't working or Tuggummi asks you to.
    debugPrint = false,

    -- No steam open message, what message to send if the user don't have steam open.
    noSteam = "You need to open steam to connect to the server!"
}