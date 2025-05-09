Bridge = Bridge or {}

---@param title string
---@param message string
function Bridge.DebugPrint(title, message)
    if config.Debug then
        print(("^2[Bridge:%s]^7 %s"):format(title, message))
    end
end

---@param resource string
---@param title string
---@param message string
function Bridge.GlobalDebugPrint(resource, title, message)
    if config.Debug then
        print(("^2[%s:%s]^7 %s"):format(resource, title, message))
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
