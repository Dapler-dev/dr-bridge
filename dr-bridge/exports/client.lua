-- core
exports("GetPlayerData", function()
    return Bridge.GetPlayerData()
end)

exports("GetJob", function()
    return Bridge.GetJob()
end)

exports("GetMoney", function(account)
    return Bridge.GetMoney(account)
end)

exports("HasItem", function(item, count)
    return Bridge.HasItem(item, count)
end)

exports("Notify", function(text, type)
    Bridge.Notify(text, type)
end)

exports("IsDead", function()
    return Bridge.IsDead()
end)

exports("GetCoords", function()
    return Bridge.GetCoords()
end)

exports("IsInVehicle", function()
    return Bridge.IsInVehicle()
end)

exports("GetPed", function()
    return Bridge.GetPed()
end)

exports('TriggerCallback', Bridge.TriggerCallback)

-- extras
exports("Show3DText", function(coords, text, scale)
    Bridge.Show3DText(coords, text, scale)
end)

exports("AddBlip", function(coords, sprite, color, scale, label)
    return Bridge.AddBlip(coords, sprite, color, scale, label)
end)

exports("DrawMarker", function(coords, type, scale, color)
    Bridge.DrawMarker(coords, type, scale, color)
end)

exports("PlayAnim", function(dict, anim, flag)
    Bridge.PlayAnim(dict, anim, flag)
end)

exports("ShowHelpNotification", function(text)
    Bridge.ShowHelpNotification(text)
end)

exports("ShowNotification", function(text)
    Bridge.ShowNotification(text)
end)

-- interaction
exports("AddTargetEntity", function(entity, options, distance)
    Bridge.AddTargetEntity(entity, options, distance)
end)

exports("AddTargetModel", function(models, options, distance)
    Bridge.AddTargetModel(models, options, distance)
end)

exports("AddTargetZone", function(name, coords, size, options, distance)
    Bridge.AddTargetZone(name, coords, size, options, distance)
end)

exports("RemoveTargetEntity", function(entity)
    Bridge.RemoveTargetEntity(entity)
end)

exports("RemoveTargetModel", function(models)
    Bridge.RemoveTargetModel(models)
end)

exports("RemoveTargetZone", function(name)
    Bridge.RemoveTargetZone(name)
end)

exports("UpdateTargetOptions", function(type, id, newOptions)
    Bridge.UpdateTargetOptions(type, id, newOptions)
end)

-- ui
exports("ShowTextUI", function(text, position)
    Bridge.ShowTextUI(text, position)
end)

exports("HideTextUI", function()
    Bridge.HideTextUI()
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
