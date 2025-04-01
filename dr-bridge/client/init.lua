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

    Bridge.DebugPrint("Client", "Detected framework: " .. Bridge.Framework or "unknown")


    if Bridge.Framework == "esx" then
        while not ESX do
            ESX = exports["es_extended"]:getSharedObject()
            Wait(100)
        end
    elseif Bridge.Framework == "qb" then
        while not QBCore do
            QBCore = exports['qb-core']:GetCoreObject()
            Wait(100)
        end
    end

    if config.Debug then
        Bridge.DebugPrint("Client", "Framework initialized.")
    end
end)
