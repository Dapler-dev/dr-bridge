-- exports/server.lua

-- core
exports("GetPlayer", function(source)
    return Bridge.GetPlayer(source)
end)

exports("GetJob", function(source)
    return Bridge.GetJob(source)
end)

exports("SetJob", function(source, job, grade)
    return Bridge.SetJob(source, job, grade)
end)

exports("GetMoney", function(source, account)
    return Bridge.GetMoney(source, account)
end)

exports("AddMoney", function(source, amount, account)
    return Bridge.AddMoney(source, amount, account)
end)

exports("RemoveMoney", function(source, amount, account)
    return Bridge.RemoveMoney(source, amount, account)
end)

exports("AddItem", function(source, item, count, slot, metadata)
    return Bridge.AddItem(source, item, count, slot, metadata)
end)

exports("RemoveItem", function(source, item, count, slot)
    return Bridge.RemoveItem(source, item, count, slot)
end)

exports("HasItem", function(source, item, count)
    return Bridge.HasItem(source, item, count)
end)

-- extras
exports("GetIdentifiers", function(source)
    return Bridge.GetIdentifiers(source)
end)

exports("GetPlayerName", function(source)
    return Bridge.GetPlayerName(source)
end)

exports("SendDiscordLog", function(webhook, title, message, color)
    Bridge.SendDiscordLog(webhook, title, message, color)
end)

exports("GetOnlineCount", function()
    return Bridge.GetOnlineCount()
end)

exports("SendChatMessage", function(source, message, prefix)
    Bridge.SendChatMessage(source, message, prefix)
end)

exports("LogToConsole", function(title, message)
    Bridge.LogToConsole(title, message)
end)

-- shared utils
exports("DebugPrint", function(message)
    Bridge.DebugPrint(message)
end)

exports("TableHasValue", function(tbl, value)
    return Bridge.TableHasValue(tbl, value)
end)

exports("DeepCopy", function(tbl)
    return Bridge.DeepCopy(tbl)
end)

exports("Round", function(number, decimals)
    return Bridge.Round(number, decimals)
end)

exports("IsTable", function(value)
    return Bridge.IsTable(value)
end)

exports("WaitForCondition", function(condition)
    Bridge.WaitForCondition(condition)
end)
