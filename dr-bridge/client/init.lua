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
        print("[Bridge:Client] Detekovaný framework: " .. (Bridge.Framework or "neznámý"))
    end

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

    if Config.Debug then
        print("[Bridge:Client] Framework inicializován.")
    end
end)
