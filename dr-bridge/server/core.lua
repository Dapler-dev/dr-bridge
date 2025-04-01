Bridge = Bridge or {}

function Bridge.GetPlayer(source)
    if Bridge.Framework == "qb" then
        return QBCore.Functions.GetPlayer(source)
    elseif Bridge.Framework == "esx" then
        return ESX.GetPlayerFromId(source)
    end
    return nil
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