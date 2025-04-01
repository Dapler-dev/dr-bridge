Bridge = Bridge or {}

local usingOxTextUI = false

CreateThread(function()
    if config.UseOxTextUI and GetResourceState("ox_lib") == "started" then
        usingOxTextUI = true
        Bridge.DebugPrint("UI", "ox_lib detected and used for TextUI.")
    else
        Bridge.DebugPrint("UI", "ox_lib is not active or not enabled in the config.")
    end
end)

---@param text string
---@param position string? 
--'left', 'right', 'center', 'top-center', 'bottom-center'
function Bridge.ShowTextUI(text, position)
    position = position or "left"

    if usingOxTextUI then
        lib.showTextUI(text, { position = position })
    elseif Bridge.Framework == "qb" then
        exports['qb-core']:DrawText(text, position)
    else
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayHelp(0, false, true, -1)
    end
end

function Bridge.HideTextUI()
    if usingOxTextUI then
        lib.hideTextUI()
    elseif Bridge.Framework == "qb" then
        exports['qb-core']:HideText()
    end
end
