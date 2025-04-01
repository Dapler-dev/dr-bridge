Bridge = Bridge or {}

local targetSystem = nil

CreateThread(function()
    if GetResourceState("qb-target") == "started" then
        targetSystem = "qb"
        if Config.Debug then
            print("[Bridge:Target] Detekován qb-target")
        end
    elseif GetResourceState("ox_target") == "started" then
        targetSystem = "ox"
        if Config.Debug then
            print("[Bridge:Target] Detekován ox_target")
        end
    elseif Config.Debug then
        print("[Bridge:Target] Nebyl detekován žádný podporovaný target systém")
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
    elseif Config.Debug then
        print("[Bridge:Target] AddTargetEntity: žádný target aktivní")
    end
end

function Bridge.AddTargetModel(models, options, distance)
    if targetSystem == "qb" then
        exports['qb-target']:AddTargetModel(models, {
            options = options,
            distance = distance or 2.5
        })
    elseif targetSystem == "ox" then
        exports['ox_target']:addModel(models, options)
    elseif Config.Debug then
        print("[Bridge:Target] AddTargetModel: žádný target aktivní")
    end
end

function Bridge.AddTargetZone(name, coords, size, options, distance)
    if targetSystem == "qb" then
        exports['qb-target']:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            heading = 0,
            debugPoly = Config.Debug,
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
            debug = Config.Debug,
            options = options
        })
    elseif Config.Debug then
        print("[Bridge:Target] AddTargetZone: žádný target aktivní")
    end
end

function Bridge.RemoveTargetEntity(entity)
    if targetSystem == "qb" then
        exports['qb-target']:RemoveTargetEntity(entity)
    elseif targetSystem == "ox" then
        exports['ox_target']:removeLocalEntity(entity)
    elseif Config.Debug then
        print("[Bridge:Target] RemoveTargetEntity: žádný target aktivní")
    end
end

function Bridge.RemoveTargetModel(models)
    if targetSystem == "qb" then
        exports['qb-target']:RemoveTargetModel(models)
    elseif targetSystem == "ox" then
        exports['ox_target']:removeModel(models)
    elseif Config.Debug then
        print("[Bridge:Target] RemoveTargetModel: žádný target aktivní")
    end
end

function Bridge.RemoveTargetZone(name)
    if targetSystem == "qb" then
        exports['qb-target']:RemoveZone(name)
    elseif targetSystem == "ox" then
        exports['ox_target']:removeZone(name)
    elseif Config.Debug then
        print("[Bridge:Target] RemoveTargetZone: žádný target aktivní")
    end
end

---@param type string 'entity' | 'model' | 'zone'
---@param id any -- entity ID, model hash nebo zone name
---@param newOptions table
function Bridge.UpdateTargetOptions(type, id, newOptions)
    if targetSystem ~= "ox" then
        if Config.Debug then
            print("[Bridge:Target] UpdateTargetOptions: dostupné pouze v ox_target")
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
