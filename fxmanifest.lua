-- DO NOT EDIT ANYTHING HERE; YOU ARE PROHIBITED AND YOU CAN RUIN THE RESOURCE! --

fx_version 'cerulean'
game 'gta5'

auhtor 'Tuggummi'
description 'TPF - A framework for FiveM, read the README file for more info.'
version '1.1.0'

shared_scripts {
    'config.lua',
    'functions.lua',
    'translations.lua'
} 


client_script {
    'client/position.lua',
    'client/notwanted.lua',
    'client/revive.lua',
    'client/handleVeh.lua'
}

server_scripts {
    'server/position.lua',
    'server/identifiers.lua',
    'server/revive.lua',
    'server/handleVeh.lua',
    '@mysql-async/lib/MySQL.lua'
}