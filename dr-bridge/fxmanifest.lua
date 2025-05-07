fx_version 'cerulean'
game 'gta5'

author 'Daple[R]'
description 'Universal Framework Bridge for QBCore, ESX'
version '1.2.1'

shared_scripts {
    'config.lua',
    'shared/utils.lua',
    'modules/**/shared.lua',
}

client_scripts {
    'client/*.lua',
    'exports/*.lua',
    'modules/**/client.lua',
}

server_scripts {
    'server/*.lua',
    'exports/*.lua',
    'modules/**/server.lua',
}

exports {
    'GetBridge',
}

server_exports {
    'GetBridge'
}