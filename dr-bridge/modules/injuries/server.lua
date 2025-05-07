if config.UseAdvancedInjuries then
    local playerInjuries = {}

    local function EnsurePlayerData(src)
        playerInjuries[src] = playerInjuries[src] or {}
    end

    local function SetInjury(src, injury)
        EnsurePlayerData(src)
        table.insert(playerInjuries[src], injury)
    end

    local function RemoveInjury(src, injuryType)
        EnsurePlayerData(src)
        playerInjuries[src] = injuryType and
            vim.tbl_filter(function(i) return i.type ~= injuryType end, playerInjuries[src]) or
            {}
    end

    local function GetInjuries(src, type)
        EnsurePlayerData(src)
        if type then
            return vim.tbl_filter(function(i) return i.type == type end, playerInjuries[src])
        end
        return playerInjuries[src]
    end

    Bridge.GetInjuries = GetInjuries
    Bridge.SetInjuries = SetInjury
    Bridge.RemoveInjuries = RemoveInjury

    RegisterNetEvent("dr-bridge:injuries:add", function(injury)
        injury.timestamp = os.time()
        Bridge.SetInjuries(source, injury)
    end)

    AddEventHandler("playerDropped", function()
        playerInjuries[source] = nil
    end)
end