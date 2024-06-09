fx_version 'cerulean'
games {'gta5'}
lua54 "yes"

author "Niknock HD"
description "NKHD Insurance"
version "1.0.0"

client_scripts {
    'config.lua',
    'client.lua',
    '@es_extended/locale.lua',
    'locales/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua',
    '@es_extended/locale.lua',
    'locales/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua'
}