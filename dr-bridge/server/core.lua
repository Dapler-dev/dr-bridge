Bridge = Bridge or {}

Bridge._pendingCallbacks = {}
Bridge._pendingCommands = {}
Bridge._pendingUsableItems = {}

function Bridge.GetPlayer(source)
    while not Bridge.Framework do Wait(0) end

    local player = nil
    local framework = Bridge.Framework
    local playerData = {}

    if framework == "qb" then
        player = QBCore.Functions.GetPlayer(source)

        if not player then return nil end

        playerData = {
            identifier = player.PlayerData.steam or player.PlayerData.citizenid,
            source = source,
            name = {
                firstname = player.PlayerData.firstname,
                lastname = player.PlayerData.lastname,
            },
            job = {
                name = player.PlayerData.job.name,
                label = player.PlayerData.job.label,
                payment = player.PlayerData.job.payment,
                onduty = player.PlayerData.job.onduty,
                isboss = player.PlayerData.job.isboss,
                grade = {
                    name = player.PlayerData.job.grade.name,
                    level = player.PlayerData.job.grade.level
                },
            },
            gang = {
                name = player.PlayerData.gang.name,
                label = player.PlayerData.gang.label,
                isboss = player.PlayerData.gang.isboss,
                grade = {
                    name = player.PlayerData.gang.grade.name,
                    level = player.PlayerData.gang.grade.level
                },
            },
            money = {
                cash = player.PlayerData.money.cash,
                bank = player.PlayerData.money.bank,
            },
            metadata = player.PlayerData.metadata,
            items = player.PlayerData.items,
        }

    elseif framework == "esx" then
        player = ESX.GetPlayerFromId(source)

        if not player then return nil end

        playerData = {
            identifier = player.identifier,
            source = source,
            name = {
                firstname = player.get('firstName'),
                lastname = player.get('lastName'),
            },
            job = {
                name = player.job.name,
                label = player.job.label,
                payment = player.job.grade_salary,
                onduty = true,
                isboss = player.job.grade_name == 'boss',
                grade = {
                    name = player.job.grade_name,
                    level = player.job.grade
                },
            },
            gang = nil,
            money = {
                cash = player.getMoney(),
                bank = player.getAccount('bank').money,
            },
            metadata = {},
            items = player.getInventory(),
        }
        
    end

    return playerData
end



function Bridge.GetJob(source)
    local player = Bridge.GetPlayer(source)
    if not player then return nil end

    if Bridge.Framework == "qb" then
        return player.PlayerData.job
    elseif Bridge.Framework == "esx" then
        return player.getJob()
    end
end

function Bridge.SetJob(source, job, grade)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    grade = grade or 0

    if Bridge.Framework == "qb" then
        player.Functions.SetJob(job, grade)
    elseif Bridge.Framework == "esx" then
        player.setJob(job, grade)
    end
end

function Bridge.SetJobDuty(source, duty)
    local player = Bridge.GetPlayer(source)
    if not player then return end

    duty = duty or false

    if Bridge.Framework == "qb" then
        player.Functions.SetDuty(duty)
    elseif Bridge.Framework == "esx" then
        player.setJobDuty(duty)
    end
end

function Bridge.AddMoney(source, amount, account)
    account = account or "cash"
    local player = Bridge.GetPlayer(source)
    if not player then return end

    if Bridge.Framework == "qb" then
        player.Functions.AddMoney(account, amount)
    elseif Bridge.Framework == "esx" then
        player.addAccountMoney(account, amount)
    end
end

function Bridge.RemoveMoney(source, amount, account)
    account = account or "cash"
    local player = Bridge.GetPlayer(source)
    if not player then return end

    if Bridge.Framework == "qb" then
        player.Functions.RemoveMoney(account, amount)
    elseif Bridge.Framework == "esx" then
        player.removeAccountMoney(account, amount)
    end
end

function Bridge.GetMoney(source, account)
    account = account or "cash"
    local player = Bridge.GetPlayer(source)
    if not player then return 0 end

    if Bridge.Framework == "qb" then
        return player.Functions.GetMoney(account)
    elseif Bridge.Framework == "esx" then
        return player.getAccount(account).money
    end

    return 0
end

function Bridge.AddItem(source, item, count, slot, metadata)
    local player = Bridge.GetPlayer(source)
    if not player then return false end

    if Bridge.Framework == "qb" then
        return player.Functions.AddItem(item, count, slot, metadata)
    elseif Bridge.Framework == "esx" then
        return player.addInventoryItem(item, count)
    end
end

function Bridge.RemoveItem(source, item, count, slot)
    local player = Bridge.GetPlayer(source)
    if not player then return false end

    if Bridge.Framework == "qb" then
        return player.Functions.RemoveItem(item, count, slot)
    elseif Bridge.Framework == "esx" then
        return player.removeInventoryItem(item, count)
    end
end

function Bridge.HasItem(source, item, count)
    local player = Bridge.GetPlayer(source)
    if not player then return false end
    count = count or 1

    if Bridge.Framework == "qb" then
        local items = player.Functions.GetItemsByName(item)
        local total = 0
        for _, i in pairs(items or {}) do
            total = total + (i.amount or 0)
        end
        return total >= count

    elseif Bridge.Framework == "esx" then
        local inventoryItem = player.getInventoryItem(item)
        return inventoryItem and inventoryItem.count >= count
    end

    return false
end

function Bridge.SetMetadata(source, key, value)
    if Bridge.Framework == "qb" then
        player = QBCore.Functions.GetPlayer(source)
        player.Functions.SetMetaData(key, value)
    elseif Bridge.Framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        player.setMeta(key, value)
    end
end

function Bridge.GetMetadata(source, key)
    if Bridge.Framework == "qb" then
        local player = QBCore.Functions.GetPlayer(source)
        return player.PlayerData.metadata[key]
    elseif Bridge.Framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        return player.getMeta(key)
    end
end

function Bridge.RegisterCallback(name, handler)
    if not Bridge.Framework then
        table.insert(Bridge._pendingCallbacks, { name = name, handler = handler })
        return
    end

    if Bridge.Framework == 'qb' then
        QBCore.Functions.CreateCallback(name, handler)
    elseif Bridge.Framework== 'esx' then
        ESX.RegisterServerCallback(name, handler)
    end
end

function Bridge.RegisterCommand(name, help, args, cb, permission)
    if not Bridge.Framework then
        table.insert(Bridge._pendingCommands, {
            name = name,
            help = help,
            args = args,
            cb = cb,
            permission = permission
        })
        return
    end

    if Bridge.Framework == 'qb' then
        if type(name) == "string" then
            QBCore.Commands.Add(name, help or '', args or {}, true, function(source, rawArgs)
                cb(source, rawArgs)
            end, permission)
        elseif type(name) == "table" then
            for _, comName in ipairs(name) do
                QBCore.Commands.Add(comName, help or '', args or {}, true, function(source, rawArgs)
                    cb(source, rawArgs)
                end, permission)
            end
        end
    elseif Bridge.Framework == 'esx' then
        ESX.RegisterCommand(name, permission or 'user', function(xPlayer, rawArgs, showError)
            local source = xPlayer.source
            cb(source, rawArgs)
        end, true, { help = help or '', arguments = args or {} })
    end
end

function Bridge.RegisterUsableItem(itemName, callback)
    if not Bridge.Framework then
        table.insert(Bridge._pendingUsableItems, {
            itemName = itemName,
            callback = callback
        })
        return
    end

    if Bridge.Framework == 'qb' then
        QBCore.Functions.CreateUseableItem(itemName, callback)
    elseif Bridge.Framework == 'esx' then
        ESX.RegisterUsableItem(itemName, callback)
    else
        print(('^1[dr-bridge] Unknown framework, cannot register usable item "%s"^0'):format(itemName))
    end
end

if Bridge.Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded', function(playerId, xPlayer)
        local Player = Bridge.GetPlayer(playerId)
        TriggerEvent('dr-bridge:playerLoaded', playerId, Player)
    end)
end