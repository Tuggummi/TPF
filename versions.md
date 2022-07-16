## 1.1.0

¤ Fixed up the config for easier configuration and added configuration for all new features. I also added a translations.lua, where you can enter and change all the messages that are sent to players all across the resource.

¤ The deathsystem deleted, it did not work properly so I decided to remove it and i added a revive command instead. When you die, staffs can revive you. The revive command works, even if you aren't dead.

¤ Handle vehicle added, spawn, delete, repair and clean your vehicle!
~/v - Spawns a vehicle with the specified name.
~/dv - Deletes the vehicle you in, or closest to.
~/repair - Repair the vehicle you are in, or closest to.
~/clean - Cleans the vehicle you are in, or closest to.
~/fix - Repair and fix the vehicle you are in, or closest to.

## 1.0.3

¤ Added disableWantedLevel which, as it sounds, will disable the wanted level of any player. This can easily be turned on by going into the conifg file and changing the value to true.

## 1.0.21

¤ Update the configuration "autoSaveTimer" to work with seconds instead of milliseconds. This makes the configuration part easier.

¤ Added a version.md file for all versions to be located, so this README isn't filled with version information.

## 1.0.2

¤ A deathsystem originally created by Andyyy (https://discord.gg/aDU36TEheK)
This makes sure that the position script doesn't override when a player dies, before when you died you immediately respawned last loc, but now you either respawn at the hospital (if you're dead) or revive, if you're passed out.

The passout function doesn't really work, and the help text and the "remaining time 'til death" disappear from time to time. I don't really know why though. If you have a solve, please contact me.

¤ Configs for the deathsystem added.

## 1.0.1

¤ I added a configuration part where you can choose if the players' position should be saved or not. The default location is still required to be in the database for the resource to work.

¤ Added a simple way to edit the default spawning location. Use the last part of TPF.sql to edit the existing default location, ofcourse replace it with your own coordiantes. Make sure to use commas and put it inbetween '{}'.

## 1.0.0

_The first release_

¤ Making it possible to save your players' identifiers, such as Steamid, Discord, and even IP. Use this carefully, my recommendation is to NOT share any of the players' information with anyone.

¤ It also gives you the chance to set the first spawn location and save the location they were last at.

¤ Lastly, there is a ped spawning function, it makes everyone spawn with the same ped as you configure. This is default turned to false, if you'd like to use it, turn usePedModel = true and pedModel = to the one you want.
https://docs.fivem.net/docs/game-references/ped-models/
