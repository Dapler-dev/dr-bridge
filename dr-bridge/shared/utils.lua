Bridge = Bridge or {}

---@param message string
function Bridge.DebugPrint(message)
    if Config.Debug then
        print(("[Bridge:Debug] %s"):format(message))
    end
end

---@param table table
---@param value any
---@return boolean
function Bridge.TableHasValue(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

---@param table table
---@return table
function Bridge.DeepCopy(table)
    local copy = {}
    for k, v in pairs(table) do
        if type(v) == "table" then
            copy[k] = Bridge.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

---@param number number
---@param decimals number
---@return number
function Bridge.Round(number, decimals)
    decimals = decimals or 0
    return tonumber(string.format("%." .. decimals .. "f", number))
end

---@param value any
---@return boolean
function Bridge.IsTable(value)
    return type(value) == "table"
end

---@param source number
---@return boolean
function Bridge.IsPlayerInVehicle(source)
    local playerPed = GetPlayerPed(source)
    return IsPedInAnyVehicle(playerPed, false)
end

---@param condition function
function Bridge.WaitForCondition(condition)
    while not condition() do
        Wait(100)
    end
end
