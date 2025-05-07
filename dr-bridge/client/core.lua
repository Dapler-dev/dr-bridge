Bridge = Bridge or {}

function Bridge.GetPlayerData()
    if Bridge.Framework == "qb" then
        local player = QBCore.Functions.GetPlayerData()

        return {
            identifier = player.steam or player.citizenid,
            source = GetPlayerServerId(PlayerId()),
            name = {
                firstname = player.firstname,
                lastname = player.lastname,
            },
            job = {
                name = player.job.name,
                label = player.job.label,
                payment = player.job.payment or 0,
                onduty = player.job.onduty or true,
                isboss = player.job.isboss or false,
                grade = {
                    name = player.job.grade.name,
                    level = player.job.grade.level,
                },
            },
            gang = player.gang and {
                name = player.gang.name,
                label = player.gang.label,
                isboss = player.gang.isboss or false,
                grade = {
                    name = player.gang.grade.name,
                    level = player.gang.grade.level,
                },
            } or nil,
            money = {
                cash = player.money.cash or 0,
                bank = player.money.bank or 0,
            },
            metadata = player.metadata or {},
            items = player.items or {},
            injuries = {},
        }

    elseif Bridge.Framework == "esx" then
        while ESX == nil do Wait(50) end
        while not ESX.GetPlayerData().job or not ESX.GetPlayerData().inventory do Wait(50) end
        local player = ESX.GetPlayerData()
        return {
            identifier = player.identifier,
            source = GetPlayerServerId(PlayerId()),
            name = {
                firstname = player.firstName,
                lastname = player.lastName,
            },
            job = {
                name = player.job.name,
                label = player.job.label,
                payment = player.job.grade_salary or 0,
                onduty = true,
                isboss = player.job.grade_name == 'boss',
                grade = {
                    name = player.job.grade_name,
                    level = player.job.grade,
                },
            },
            gang = nil,
            money = {
                cash = player.money or 0,
                bank = (player.accounts and player.accounts[1] and player.accounts[1].money) or 0,
            },
            metadata = {},
            items = player.inventory or {},
            injuries = {},
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
        if type == 'info' then
            type = 'primary'
        end
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
    if Bridge.Framework == 'qb' then
        QBCore.Functions.TriggerCallback(name, cb, ...)
    elseif Bridge.Framework == 'esx' then
        ESX.TriggerServerCallback(name, cb, ...)
    else
        print(('^1[dr-bridge] Unknown framework, cannot trigger callback "%s"^0'):format(name))
    end
end

Citizen.CreateThread(function()
    while not Bridge.Framework do Wait(50) end

    if Bridge.Framework == 'qb' then
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            local Player = Bridge.GetPlayerData()
            TriggerServerEvent('dr-bridge:playerLoaded', Player.source, Player)
        end)

    elseif Bridge.Framework == 'esx' then
        RegisterNetEvent('esx:playerLoaded', function()
            local Player = Bridge.GetPlayerData()
            TriggerServerEvent('dr-bridge:playerLoaded', Player.source, Player)
        end)
    end
end)
