-- DO NOT EDIT ANYTHING HERE; YOU ARE NOT PERMITTED AND YOU CAN RUIN THE RESOURCE! --

fx_version 'cerulean'
game 'gta5'

auhtor 'Tuggummi'
description 'TPF - A powerful framework created by Tuggummi.'
version '1.0.0'

shared_script 'config.lua'
client_script 'client/position.lua'
server_scripts {
    'server/position.lua',
    'server/identifiers.lua',
    '@mysql-async/lib/MySQL.lua'
}