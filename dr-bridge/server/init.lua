Bridge = Bridge or {}
Bridge.Framework = nil

local function detectFramework()
    if Config.Framework then
        return Config.Framework
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

    if Config.Debug then
        print("[Bridge:Server] Detekovaný framework: " .. (Bridge.Framework or "neznámý"))
    end

    if Bridge.Framework == "esx" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Bridge.Framework == "qb" then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    if Config.Debug then
        print("[Bridge:Server] Framework inicializován.")
    end
end)
