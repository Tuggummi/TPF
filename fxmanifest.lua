fx_version 'cerulean'
game 'gta5'

author 'Tuggummi'
description 'Framework med nödvändiga scripts för en FiveM Server.'
version '1.0.0'

shared_scripts {
    'config/config.lua',
    'config/permissions.lua',
    'config/webhooks.lua',
}

client_scripts {
    'client/commands.lua',
    'client/events.lua',
    'client/functions.lua',
}

server_scripts {
    'server/commands.lua',
    'server/events.lua',
    'server/functions.lua',
    '@mysql-async/lib/MySQL.lua',
}

ui_page 'html/spawnmenu.html'

files {
    'html/spawnmenu.html',
    'html/style.css',
    'html/script.js',
    'html/images/*',
}
