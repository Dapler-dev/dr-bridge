Bridge = Bridge or {}

local targetSystem = nil

CreateThread(function()
    if GetResourceState("qb-target") == "started" then
        targetSystem = "qb"
        Bridge.DebugPrint("Target", "Detected qb-target")
    elseif GetResourceState("ox_target") == "started" then
        targetSystem = "ox"
        Bridge.DebugPrint("Target", "Detected ox_target")
    elseif config.Debug then
        Bridge.DebugPrint("Target", "No supported target system detected")
    end
end)

function Bridge.AddTargetEntity(entity, options, distance)
    if targetSystem == "qb" then
        exports['qb-target']:AddTargetEntity(entity, {
            options = options,
            distance = distance or 2.5
        })
    elseif targetSystem == "ox" then
        exports['ox_target']:addLocalEntity(entity, options)
    elseif config.Debug then
        Bridge.DebugPrint("Target", "AddTargetEntity: no target active")
    end
end

function Bridge.AddTargetModel(models, options, distance)
    if targetSystem == "qb" then
        exports['qb-target']:AddTargetModel(models, {
            options = { options },
            distance = distance or 2.5
        })
    elseif targetSystem == "ox" then
        exports['ox_target']:addModel(models, {
            {
                label = options.label,
                icon = options.icon,
                distance = distance or 2.5,
                onSelect = function(data)
                    if options.action then
                        options.action(data.entity)
                    end
                end
            }
        })
    elseif config.Debug then
        Bridge.DebugPrint("Target", "AddTargetModel: no target active")
    end
end


function Bridge.AddTargetZone(name, coords, size, options, distance)
    if targetSystem == "qb" then
        exports['qb-target']:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            heading = 0,
            debugPoly = config.Debug,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 1.0
        }, {
            options = options,
            distance = distance or 2.5
        })
    elseif targetSystem == "ox" then
        exports['ox_target']:addBoxZone({
            name = name,
            coords = coords,
            size = size,
            rotation = 0,
            debug = config.Debug,
            options = options
        })
    elseif config.Debug then
        Bridge.DebugPrint("Target", "AddTargetZone: no target active")
    end
end

function Bridge.RemoveTargetEntity(entity)
    if targetSystem == "qb" then
        exports['qb-target']:RemoveTargetEntity(entity)
    elseif targetSystem == "ox" then
        exports['ox_target']:removeLocalEntity(entity)
    elseif config.Debug then
        Bridge.DebugPrint("Target", "RemoveTargetEntity: no target active")
    end
end

function Bridge.RemoveTargetModel(models)
    if targetSystem == "qb" then
        exports['qb-target']:RemoveTargetModel(models)
    elseif targetSystem == "ox" then
        exports['ox_target']:removeModel(models)
    elseif config.Debug then
        Bridge.DebugPrint("Target", "RemoveTargetModel: no target active")
    end
end

function Bridge.RemoveTargetZone(name)
    if targetSystem == "qb" then
        exports['qb-target']:RemoveZone(name)
    elseif targetSystem == "ox" then
        exports['ox_target']:removeZone(name)
    elseif config.Debug then
        Bridge.DebugPrint("Target", "RemoveTargetZone: no target active")
    end
end

---@param type string 'entity' | 'model' | 'zone'
---@param id any -- entity ID, model hash nebo zone name
---@param newOptions table
function Bridge.UpdateTargetOptions(type, id, newOptions)
    if targetSystem ~= "ox" then
        if config.Debug then
            Bridge.DebugPrint("Target", "UpdateTargetOptions: only available in ox_target")
        end
        return
    end

    if type == "entity" then
        exports['ox_target']:updateLocalEntity(id, newOptions)
    elseif type == "model" then
        exports['ox_target']:updateModel(id, newOptions)
    elseif type == "zone" then
        exports['ox_target']:updateZone(id, newOptions)
    end
end
