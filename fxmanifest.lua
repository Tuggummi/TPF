fx_version 'cerulean'
game 'gta5'

auhtor 'Tuggummi'
description 'TPF - A powerful framework created by Tuggummi.'
version '1.0.0'

client_script 'client/position.lua'

server_scripts {
    'server/position.lua',
    'server/identifier.lua',
    '@mysql-async/lib/MySQL.lua'
}