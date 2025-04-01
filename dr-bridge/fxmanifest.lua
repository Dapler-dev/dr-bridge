fx_version 'cerulean'
game 'gta5'

author 'Daple[R]'
description 'Universal Framework Bridge for QBCore, ESX, and ox_lib'
version '1.0.0'

shared_scripts {
    'config.lua',
    'shared/utils.lua',
}

client_scripts {
    'client/init.lua',
    'client/core.lua',
    'client/ui.lua',
    'client/interaction.lua',
    'client/extras.lua',
    'exports/client.lua',
}

server_scripts {
    'server/init.lua',
    'server/core.lua',
    'server/extras.lua',
    'exports/server.lua',
}

exports {
    -- core
    'GetPlayerData',
    'GetJob',
    'GetMoney',
    'HasItem',
    'Notify',
    'IsDead',
    'GetCoords',
    'IsInVehicle',
    'GetPed',

    -- extras
    'Show3DText',
    'AddBlip',
    'DrawMarker',
    'PlayAnim',
    'ShowHelpNotification',
    'ShowNotification',

    -- interaction
    'AddTargetEntity',
    'AddTargetModel',
    'AddTargetZone',
    'RemoveTargetEntity',
    'RemoveTargetModel',
    'RemoveTargetZone',
    'UpdateTargetOptions',

    -- ui
    'ShowTextUI',
    'HideTextUI',

    -- shared utils
    'DebugPrint',
    'TableHasValue',
    'DeepCopy',
    'Round',
    'IsTable',
    'WaitForCondition',
}

server_exports {
    -- core
    'GetPlayer',
    'GetJob',
    'SetJob',
    'GetMoney',
    'AddMoney',
    'RemoveMoney',
    'AddItem',
    'RemoveItem',
    'HasItem',

    -- extras
    'GetIdentifiers',
    'GetPlayerName',
    'SendDiscordLog',
    'GetOnlineCount',
    'SendChatMessage',
    'LogToConsole',

    -- shared utils
    'DebugPrint',
    'TableHasValue',
    'DeepCopy',
    'Round',
    'IsTable',
    'WaitForCondition',
}
