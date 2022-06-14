__TPF - Tuggummi Powerful Framework__

First things first, welcome! Welcome to my standalone-based framework.
For now, there isn't much to start at, though this framework already is necessary for a FiveM Server. 
In the future this framework will evolve into something much bigger, but only if it is appreciated. I will be using this on my server, obviously, so any error that I encounter I will try to solve as fast as possible and upload it as well.

If you would happen to experience random crashes or any error overall, please contact me via discord. Tuggummi#7842
I will look into it as fast as humanly possible and solve it.
_BUT BEFORE you message me_ try to solve it on your own, download the latest version from the GitHub, and it might work.
Perhaps you changed anything or it was a problem on my end. If it doesn't work when you've downloaded the latest version, message me. Again, on discord: _Tuggummi#7842_

__How to install__
¤ Download the resource from GitHub and put it in the Resource root folder.
¤ Make sure you have MySQL-async installed and the connection-string setup as well as a database, if you don't; Google will probably help.
¤ Start the resource in your server.cfg (ensure TPF).
¤ Open HeidiSQL and Load the SQL file, press F9 while selected to your database, and with the SQL File opened. It should create users_information and users_identifiers.
¤ Make sure to edit the config to what you see fit.
¤ Fire it up by restarting your server or starting it by hand.


__1.0.0__
_The first release._
¤ Making it possible to save your players' identifiers, such as Steamid, Discord, and even IP. Use this carefully, my recommendation is to NOT share any of the players' information with anyone.
    
¤ It also gives you the chance to set the first spawn location and save the location they were last at.

¤ Lastly, there is a ped spawning function, it makes everyone spawn with the same character as you configure. This is default turned to false, if you'd like to use it, turn usePedModel = true and pedModel = to the one you want. 
https://docs.fivem.net/docs/game-references/ped-models/

__Comming soon__
The thing I prioritize is making it so that the script saves exactly when the player exit. This will be arriving very soon.
I also plan on making a way to save the last ped, if you changed it and don't want it to change back every time.
