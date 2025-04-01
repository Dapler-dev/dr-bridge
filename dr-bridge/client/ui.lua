Bridge = Bridge or {}

local usingOxTextUI = false

CreateThread(function()
    if Config.UseOxTextUI and GetResourceState("ox_lib") == "started" then
        usingOxTextUI = true
        if Config.Debug then
            print("[Bridge:UI] ox_lib zjištěn a použit pro TextUI.")
        end
    elseif Config.Debug then
        print("[Bridge:UI] ox_lib není aktivní nebo není povolen v Configu.")
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
