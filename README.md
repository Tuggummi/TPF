### TPF - Tuggummis Powerful Framework

First things first, welcome to my framework.
For now, there isn't much to start at, though this framework already is necessary for a FiveM Server.
In the future this framework will evolve into something much bigger, but only if it is appreciated. I will be using this on my server, so any error that I encounter I will try to solve as fast as possible and upload it as well.

If you would happen to experience random crashes or any error overall, please contact me via discord.
I will look into it as fast as humanly possible and solve it.
_BUT BEFORE you message me_ try to solve it on your own, download the latest version from the GitHub, and it might work.
Perhaps you changed anything or it was a problem on my end. If it doesn't work when you've downloaded the latest version, message me. Again, on discord: _Tuggummi#7842_

In versions.md you can read about some of the versions that exists. Although not all versions will be available.

## Features

¤ Saving location and players identifiers in HeidiSQL. Uses the location on playerSpawn.

¤ Disables the wanted level, configurable.

¤ Revive command, heals or revives the player if your dead or alive.

¤ Handle vehicle, repair, clean, spawn and delete vehicles.

#### How to install

1. Download the resource from GitHub and put it in the Resource root folder.
2. Make sure you have MySQL-async installed and the connection-string setup as well as a database, if you don't; Google will probably help.
3. Start the resource in your server.cfg (ensure TPF)
4. Open HeidiSQL and Load the SQL file, press F9 while selected to your database, and with the SQL File opened. It should create users_information and users_identifiers.
5. Make sure to edit the config to what you see fit. To change the default spawning location, use the last part of TPF.sql and change it to what you'd like. That is if you already executed the other part
6. Fire it up by restarting your server.

# DEPENDENCIES

¤ You need to download mysql-async for this script to work. Please do so with this link:
https://github.com/brouznouf/fivem-mysql-async

¤ A HeidiSQL database.

# VERSIONS

## 1.1.0

¤ Fixed up the config for easier configuration and added configuration for all new features. I also added a translations.lua, where you can enter and change all the messages that are sent to players all across the resource.

¤ The deathsystem deleted, it did not work properly so I decided to remove it and i added a revive command instead. When you die, staffs can revive you. The revive command works, even if you aren't dead.

¤ Handle vehicle added, spawn, delete, repair and clean your vehicle!
~/v - Spawns a vehicle with the specified name.
~/dv - Deletes the vehicle you in, or closest to.
~/repair - Repair the vehicle you are in, or closest to.
~/clean - Cleans the vehicle you are in, or closest to.
~/fix - Repair and fix the vehicle you are in, or closest to.

¤ No wanted level added, disables the wanted level. Configurable in the config.

## 1.0.3

¤ Added disableWantedLevel which, as it sounds, will disable the wanted level of any player. This can easily be turned on by going into the conifg file and changing the value to true.

_Sidenote:_ Right now I'm working on making the script save player position when you leave the server instead of every 10 seconds. Instead saving like every 10 minutes, or less, of course that will be changeable.

### Comming soon

¤ I plan on making a way to save the last ped, if you changed it and don't want it to change back every time.

¤ There will be coming a update to the config where you can edit what identifiers you want to save. Though not straight away.
