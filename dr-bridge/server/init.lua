Bridge = Bridge or {}
Bridge.Framework = nil

local function detectFramework()
    if config.Framework then
        return config.Framework
    end

    if GetResourceState("qb-core") == "started" then
        return "qb"
    elseif GetResourceState("es_extended") == "started" then
        return "esx"
    end

    return nil
end

CreateThread(function()
    Bridge.Framework = detectFramework()

    Bridge.DebugPrint("Server", "Detected framework: " .. (Bridge.Framework or "unknown"))
    
    if Bridge.Framework == "esx" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Bridge.Framework == "qb" then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    for _, cb in pairs(Bridge._pendingCallbacks) do
        Bridge.RegisterCallback(cb.name, cb.handler)
    end
    Bridge._pendingCallbacks = nil

    for _, cmd in pairs(Bridge._pendingCommands or {}) do
        Bridge.RegisterCommand(cmd.name, cmd.help, cmd.args, cmd.cb, cmd.permission)
    end
    Bridge._pendingCommands = nil

    Bridge.DebugPrint("Server", "Framework initialized.")
end)

CreateThread(function()
    Wait(1000)

    local resourceName = GetCurrentResourceName()
    local localVersion = GetResourceMetadata(resourceName, 'version', 0)

    print('^3──────────────────────────────────────────────^7')
    print('^3['..resourceName..']^7 Checking for updates...')

    PerformHttpRequest('https://raw.githubusercontent.com/Dapler-dev/dr-bridge/main/dr-bridge/fxmanifest.lua', function(statusCode, response, headers)
        if statusCode == 200 and response then
            local versions = {}
            for match in response:gmatch("version%s*['\"](.-)['\"]") do
                table.insert(versions, match)
            end

            local latestVersion = versions[2] or "unknown"

            print('^3['..resourceName..']^7 Current Version: ^2' .. localVersion .. '^7')
            print('^3['..resourceName..']^7 Latest Version: ^6' .. latestVersion .. '^7')

            if latestVersion ~= "unknown" and localVersion ~= latestVersion then
                print('^1['..resourceName..']^7 An update is available! Download the latest version at:')
                print('^4https://github.com/Dapler-dev/dr-bridge^7')
            else
                print('^2['..resourceName..']^7 You are running the latest version.^7')
            end
        else
            print('^1['..resourceName..']^7 Failed to check for updates (GitHub fetch error).^7')
        end

        print('^3──────────────────────────────────────────────^7')
    end, 'GET', '', { ['User-Agent'] = 'dr-bridge' })
end)



