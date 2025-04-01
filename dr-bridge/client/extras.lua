Bridge = Bridge or {}

---@param coords vector3
---@param text string
---@param scale number?
function Bridge.Show3DText(coords, text, scale)
    scale = scale or 0.35
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(camCoords - coords)
    local fov = (1 / distance) * 20 * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextOutline()
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(x, y)
    end
end

---@param coords vector3
---@param sprite number
---@param color number
---@param scale number
---@param label string
---@return number blip
function Bridge.AddBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale or 0.8)
    SetBlipColour(blip, color or 0)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

---@param coords vector3
---@param type number
---@param scale vector3
---@param color table {r,g,b,a}
function Bridge.DrawMarker(coords, type, scale, color)
    DrawMarker(
        type or 1,
        coords.x, coords.y, coords.z - 0.95,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale.x, scale.y, scale.z,
        color.r, color.g, color.b, color.a,
        false, true, 2, false, nil, nil, false
    )
end

---@param dict string
---@param anim string
---@param flag number?
function Bridge.PlayAnim(dict, anim, flag)
    Bridge.LoadAnimDict(dict)
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, flag or 1, 0, false, false, false)
end

---@param dict string
function Bridge.LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

---@param text string
function Bridge.ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

---@param text string
function Bridge.ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, true)
end
