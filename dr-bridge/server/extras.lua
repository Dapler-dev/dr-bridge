Bridge = Bridge or {}

---@param source number
---@return table
function Bridge.GetIdentifiers(source)
    local identifiers = {
        steam = nil,
        license = nil,
        discord = nil,
        ip = nil
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "steam:") then
            identifiers.steam = id
        elseif string.find(id, "license:") then
            identifiers.license = id
        elseif string.find(id, "discord:") then
            identifiers.discord = id
        elseif string.find(id, "ip:") then
            identifiers.ip = id
        end
    end

    return identifiers
end

---@param source number
---@return string
function Bridge.GetPlayerName(source)
    return GetPlayerName(source) or "Unknown"
end

---@param webhook string
---@param title string
---@param message string
---@param color number?
function Bridge.SendDiscordLog(webhook, title, message, color)
    if not webhook or webhook == "" then return end

    local payload = json.encode({
        embeds = {{
            title = title,
            description = message,
            color = color or 16777215,
            footer = {
                text = os.date("%d.%m.%Y %H:%M:%S")
            }
        }}
    })

    PerformHttpRequest(webhook, function(err, text, headers)
        if Config.Debug then
            print("[Bridge:DiscordLog] Status: " .. tostring(err))
        end
    end, 'POST', payload, {
        ['Content-Type'] = 'application/json'
    })
end

function Bridge.GetOnlineCount()
    return #GetPlayers()
end

---@param source number
---@param message string
---@param prefix string?
function Bridge.SendChatMessage(source, message, prefix)
    TriggerClientEvent('chat:addMessage', source, {
        args = { prefix or "^3[Bridge]", message }
    })
end

---@param title string
---@param message string
function Bridge.LogToConsole(title, message)
    print(("^2[Bridge:%s]^7 %s"):format(title, message))
end
