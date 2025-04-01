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

    Bridge.DebugPrint("Server", "Framework initialized.")
end)

CreateThread(function()
    Wait(1000)

    local resourceName = GetCurrentResourceName()
    local version = GetResourceMetadata(resourceName, 'version', 0)

    PerformHttpRequest('https://api.github.com/repos/Dapler-dev/dr-bridge/commits?per_page=1', function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            local latestSha = data[1] and data[1].sha

            if latestSha then
                print('^3['..resourceName..']^7 Current Version: ^2' .. version .. '^7')
                print('^3['..resourceName..']^7 Latest Commit: ^6' .. latestSha:sub(1, 7) .. '^7')
                print('^3['..resourceName..']^7 Check for updates at ^4https://github.com/Dapler-dev/dr-bridge^7')
            else
                print('^1['..resourceName..'] Could not verify latest version.^7')
            end
        else
            print('^1['..resourceName..'] Failed to check for updates (GitHub API error).^7')
        end
    end, 'GET', '', { ['User-Agent'] = 'dr-bridge' })
end)

