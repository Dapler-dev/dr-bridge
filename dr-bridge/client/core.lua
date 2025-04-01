Bridge = Bridge or {}

function Bridge.GetPlayerData()
    if Bridge.Framework == "qb" then
        local player = QBCore.Functions.GetPlayerData()
        return {
            citizenid = player.citizenid,
            job = player.job,
            money = player.money,
            metadata = player.metadata,
            items = player.items
        }

    elseif Bridge.Framework == "esx" then
        local player = ESX.GetPlayerData()
        return {
            identifier = player.identifier,
            job = player.job,
            money = {
                cash = player.money,
                bank = player.accounts and player.accounts[1] and player.accounts[1].money or 0
            },
            metadata = player,
            items = player.inventory
        }
    end

    return {}
end

function Bridge.GetJob()
    local data = Bridge.GetPlayerData()
    return data.job
end

function Bridge.GetMoney(account)
    account = account or "cash"
    local data = Bridge.GetPlayerData()
    return (data.money and data.money[account]) or 0
end

function Bridge.Notify(text, type)
    type = type or "info"

    if Bridge.Framework == "qb" then
        QBCore.Functions.Notify(text, type)

    elseif Bridge.Framework == "esx" then
        ESX.ShowNotification(text)
    end
end

function Bridge.HasItem(item, count)
    count = count or 1
    local data = Bridge.GetPlayerData()
    local items = data.items or {}

    for _, i in pairs(items) do
        if i.name == item and (i.amount or i.count or 0) >= count then
            return true
        end
    end

    return false
end

function Bridge.IsDead()
    return IsEntityDead(PlayerPedId())
end

function Bridge.GetCoords()
    return GetEntityCoords(PlayerPedId())
end

function Bridge.IsInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function Bridge.GetPed()
    return PlayerPedId()
end

function Bridge.TriggerCallback(name, cb, ...)
    CreateThread(function()
        while not Bridge.Framework do Wait(50) end

        if Bridge.Framework == 'qb' then
            QBCore.Functions.TriggerCallback(name, cb, ...)
        elseif Bridge.Framework == 'esx' then
            ESX.TriggerServerCallback(name, cb, ...)
        else
            print(('^1[dr-bridge] Unknown framework, cannot trigger callback "%s"^0'):format(name))
        end
    end)
end