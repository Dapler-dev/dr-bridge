if config.UseAdvancedInjuries then
    Bridge.DebugPrint("Injuries-Module", "Injuries module enabled")
    local lastHealth = GetEntityHealth(PlayerPedId())
    local victim, attacker, fatal, weaponHash, isMelee

    local function ShouldCauseInternalBleeding(boneLabel, weaponHash, damage)
        local criticalBones = {
            ["spine_mid"] = true,
            ["spine_upper"] = true,
            ["spine_lower"] = true,
            ["spine_root"] = true
        }
    
        local heavyWeapons = {
            [GetHashKey("WEAPON_SNIPERRIFLE")] = true,
            [GetHashKey("WEAPON_HEAVYSNIPER")] = true,
            [GetHashKey("WEAPON_RPG")] = true,
            [GetHashKey("WEAPON_GRENADE")] = true,
            [GetHashKey("WEAPON_COMBATMG")] = true,
            [GetHashKey("WEAPON_MINIGUN")] = true
        }
    
        if damage > 30 and criticalBones[boneLabel] then return true end
        if heavyWeapons[weaponHash] and criticalBones[boneLabel] then return true end
    
        return false
    end
    
    
    local function DetectInjuryTypes(weaponHash, isMelee, damageAmount, boneLabel)
        if not weaponHash then return { "unknown" } end
    
        local result = {}
    
        -- Zranění pro melee zbraně
        if isMelee then
            local meleeWeapons = {
                [GetHashKey("WEAPON_BAT")] = { "bruise" },
                [GetHashKey("WEAPON_CROWBAR")] = { "broken_bone" },
                [GetHashKey("WEAPON_KNIFE")] = { "external_bleeding" },
                [GetHashKey("WEAPON_HAMMER")] = { "broken_bone" },
                [GetHashKey("WEAPON_NIGHTSTICK")] = { "bruise" }
            }
            return meleeWeapons[weaponHash] or { "bruise" }
        end
    
        -- Zranění pro všechny ostatní zbraně
        local weaponInjuryMap = {
            -- GUNSHOT_WOUND (všechny palné zbraně)
            ["WEAPON_PISTOL"] = { "gunshot_wound" },
            ["WEAPON_PISTOL_MK2"] = { "gunshot_wound" },
            ["WEAPON_COMBATPISTOL"] = { "gunshot_wound" },
            ["WEAPON_APPISTOL"] = { "gunshot_wound" },
            ["WEAPON_STUNGUN"] = { "electric_shock" },
            ["WEAPON_PISTOL50"] = { "gunshot_wound" },
            ["WEAPON_SNSPISTOL"] = { "gunshot_wound" },
            ["WEAPON_SNSPISTOL_MK2"] = { "gunshot_wound" },
            ["WEAPON_HEAVYPISTOL"] = { "gunshot_wound" },
            ["WEAPON_VINTAGEPISTOL"] = { "gunshot_wound" },
            ["WEAPON_FLAREGUN"] = { "burn" },
            ["WEAPON_MARKSMANPISTOL"] = { "gunshot_wound" },
            ["WEAPON_REVOLVER"] = { "gunshot_wound" },
            ["WEAPON_REVOLVER_MK2"] = { "gunshot_wound" },
            ["WEAPON_DOUBLEACTION"] = { "gunshot_wound" },
            ["WEAPON_RAYPISTOL"] = { "gunshot_wound" },
            ["WEAPON_CERAMICPISTOL"] = { "gunshot_wound" },
            ["WEAPON_NAVYREVOLVER"] = { "gunshot_wound" },
            ["WEAPON_MICROSMG"] = { "gunshot_wound" },
            ["WEAPON_SMG"] = { "gunshot_wound" },
            ["WEAPON_SMG_MK2"] = { "gunshot_wound" },
            ["WEAPON_ASSAULTSMG"] = { "gunshot_wound" },
            ["WEAPON_COMBATPDW"] = { "gunshot_wound" },
            ["WEAPON_MACHINEPISTOL"] = { "gunshot_wound" },
            ["WEAPON_MINISMG"] = { "gunshot_wound" },
            ["WEAPON_RAYCARBINE"] = { "gunshot_wound" },
            ["WEAPON_MG"] = { "gunshot_wound" },
            ["WEAPON_COMBATMG"] = { "gunshot_wound" },
            ["WEAPON_COMBATMG_MK2"] = { "gunshot_wound" },
            ["WEAPON_GUSENBERG"] = { "gunshot_wound" },
            ["WEAPON_ASSAULTRIFLE"] = { "gunshot_wound" },
            ["WEAPON_ASSAULTRIFLE_MK2"] = { "gunshot_wound" },
            ["WEAPON_CARBINERIFLE"] = { "gunshot_wound" },
            ["WEAPON_CARBINERIFLE_MK2"] = { "gunshot_wound" },
            ["WEAPON_ADVANCEDRIFLE"] = { "gunshot_wound" },
            ["WEAPON_SPECIALCARBINE"] = { "gunshot_wound" },
            ["WEAPON_SPECIALCARBINE_MK2"] = { "gunshot_wound" },
            ["WEAPON_BULLPUPRIFLE"] = { "gunshot_wound" },
            ["WEAPON_BULLPUPRIFLE_MK2"] = { "gunshot_wound" },
            ["WEAPON_COMPACTRIFLE"] = { "gunshot_wound" },
            ["WEAPON_MILITARYRIFLE"] = { "gunshot_wound" },
            ["WEAPON_HEAVYRIFLE"] = { "gunshot_wound" },
            ["WEAPON_TACTICALRIFLE"] = { "gunshot_wound" },
            ["WEAPON_MUSKET"] = { "gunshot_wound" },
            ["WEAPON_MARKSMANRIFLE"] = { "gunshot_wound" },
            ["WEAPON_MARKSMANRIFLE_MK2"] = { "gunshot_wound" },
            ["WEAPON_SNIPERRIFLE"] = { "gunshot_wound" },
            ["WEAPON_HEAVYSNIPER"] = { "gunshot_wound" },
            ["WEAPON_HEAVYSNIPER_MK2"] = { "gunshot_wound" },
            ["WEAPON_PRECISIONRIFLE"] = { "gunshot_wound" },
            ["WEAPON_RAILGUN"] = { "gunshot_wound" },
            ["WEAPON_RAILGUNXM3"] = { "gunshot_wound" },
            ["WEAPON_MINIGUN"] = { "gunshot_wound" },
            ["WEAPON_FIREWORK"] = { "burn" },
            ["WEAPON_HOMINGLAUNCHER"] = { "explosion" },
            ["WEAPON_COMPACTLAUNCHER"] = { "explosion" },
            ["WEAPON_RPG"] = { "explosion", "burn", "internal_bleeding" },
            ["WEAPON_GRENADELAUNCHER"] = { "explosion" },
            ["WEAPON_GRENADELAUNCHER_SMOKE"] = { "smoke_inhalation" },
            ["WEAPON_STICKYBOMB"] = { "explosion" },
            ["WEAPON_GRENADE"] = { "explosion" },
            ["WEAPON_BZGAS"] = { "smoke_inhalation" },
            ["WEAPON_SMOKEGRENADE"] = { "smoke_inhalation" },
            ["WEAPON_MOLOTOV"] = { "burn", "external_bleeding" },
            ["WEAPON_PIPEBOMB"] = { "explosion" },
            ["WEAPON_PROXMINE"] = { "explosion" },
            ["WEAPON_SNOWBALL"] = { "bruise" },
            ["WEAPON_BALL"] = { "bruise" },
            ["WEAPON_FLARE"] = { "burn" },
            ["WEAPON_PETROLCAN"] = { "burn" },
            ["WEAPON_HAZARDCAN"] = { "chemical" },
            ["WEAPON_FIREEXTINGUISHER"] = { "chemical" },
            ["WEAPON_EMPLAUNCHER"] = { "electric_shock" },
            ["WEAPON_TECPISTOL"] = { "gunshot_wound" },
            ["WEAPON_BRIEFCASE"] = { "bruise" },
            ["WEAPON_BRIEFCASE_02"] = { "bruise" },
            ["WEAPON_BARBED_WIRE"] = { "cut" },
            ["WEAPON_DROWNING"] = { "drowning" },
            ["WEAPON_DROWNING_IN_VEHICLE"] = { "drowning" },
            ["WEAPON_BLEEDING"] = { "external_bleeding" },
            ["WEAPON_ANIMAL"] = { "bite", "external_bleeding" },
            ["WEAPON_COUGAR"] = { "bite", "external_bleeding" },
            ["WEAPON_FALL"] = { "fall", "broken_bone" },
            ["WEAPON_RUN_OVER_BY_CAR"] = { "broken_bone"},
            ["WEAPON_RAMMED_BY_CAR"] = { "broken_bone" },
            ["WEAPON_UNARMED"] = { "bruise" },
            -- SHOTGUNS with bonus effect
            ["WEAPON_PUMPSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_PUMPSHOTGUN_MK2"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_SAWNOFFSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_BULLPUPSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_ASSAULTSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_MUSKET"] = { "gunshot_wound" },
            ["WEAPON_HEAVYSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_DBSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_AUTOSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_COMBATSHOTGUN"] = { "gunshot_wound", "broken_bone" },
            ["WEAPON_RAYMINIGUN"] = { "gunshot_wound" }
        }
    
        local weaponName = GetWeapontypeGroup(weaponHash) or weaponHash
        local hashString = type(weaponName) == "number" and string.format("%u", weaponName) or weaponName
    
        for name, types in pairs(weaponInjuryMap) do
            if GetHashKey(name) == weaponHash then
                result = types
                break
            end
        end
    
        -- Bonusové zranění podle zásahu do určité části těla
        if bone == 52301 or bone == 57597 then -- levá/pravá noha
            table.insert(result, "broken_bone")
        end
    
        if damageAmount and damageAmount > 30 then
            if ShouldCauseInternalBleeding(boneLabel, weaponHash, damageAmount) then
                table.insert(result, "internal_bleeding")
            end
        end
    
        return result
    end    

    local function GetBoneLabel(bone)
        local boneMap = {
            [0] = "body_root",
            [1356] = "right_eyebrow",
            [2108] = "left_toe",
            [2992] = "right_elbow",
            [4089] = "left_index_finger_1",
            [4090] = "left_index_finger_2",
            [4137] = "left_ring_finger_1",
            [4138] = "left_ring_finger_2",
            [4153] = "left_pinky_finger_1",
            [4154] = "left_pinky_finger_2",
            [4169] = "left_middle_finger_1",
            [4170] = "left_middle_finger_2",
            [4185] = "left_ring_finger_1",
            [4186] = "left_ring_finger_2",
            [5232] = "left_arm_roll",
            [6286] = "right_hand_ik",
            [6442] = "right_thigh_roll",
            [10706] = "right_shoulder",
            [11174] = "right_mouth_corner",
            [11816] = "pelvis",
            [12844] = "head_ik",
            [14201] = "left_foot",
            [16335] = "right_knee_helper",
            [17188] = "lower_lip_root",
            [17719] = "right_upper_lip",
            [18905] = "left_hand",
            [19336] = "right_cheekbone",
            [20178] = "upper_lip_root",
            [20279] = "left_upper_lip",
            [20623] = "lower_lip",
            [20781] = "right_toe",
            [21550] = "left_cheekbone",
            [22711] = "left_elbow_helper",
            [23553] = "spine_lower",
            [23639] = "left_thigh_roll",
            [24806] = "right_foot_phys",
            [24816] = "spine_mid",
            [24817] = "spine_upper",
            [24818] = "spine_top",
            [25260] = "left_eye",
            [26610] = "left_thumb_1",
            [26611] = "left_index_1",
            [26612] = "left_middle_1",
            [26613] = "left_ring_1",
            [26614] = "left_pinky_1",
            [27474] = "right_eye",
            [28252] = "right_forearm",
            [28422] = "right_hand_phys",
            [29868] = "left_mouth_corner",
            [31086] = "head",
            [35502] = "right_foot_ik",
            [35731] = "neck_helper",
            [36029] = "left_hand_ik",
            [36864] = "right_calf",
            [37119] = "right_arm_roll",
            [37193] = "forehead_center",
            [39317] = "neck",
            [40269] = "right_upper_arm",
            [43536] = "right_upper_eyelid",
            [43810] = "right_forearm_roll",
            [45509] = "left_upper_arm",
            [45750] = "left_upper_eyelid",
            [46078] = "left_knee_helper",
            [46240] = "jaw",
            [47419] = "left_lower_lip",
            [47495] = "tongue",
            [49979] = "right_lower_lip",
            [51826] = "right_thigh",
            [52301] = "right_foot",
            [56604] = "root_ik",
            [57005] = "right_hand",
            [57597] = "spine_root",
            [57717] = "left_foot_phys",
            [58271] = "left_thigh",
            [58331] = "left_eyebrow",
            [58866] = "right_thumb_1",
            [58867] = "right_index_1",
            [58868] = "right_middle_1",
            [58869] = "right_ring_1",
            [58870] = "right_pinky_1",
            [60309] = "left_hand_phys",
            [61007] = "left_forearm_roll",
            [61163] = "left_forearm",
            [61839] = "upper_lip_center",
            [63931] = "left_calf",
            [64016] = "right_index_2",
            [64017] = "right_index_3",
            [64064] = "right_ring_2",
            [64065] = "right_ring_3",
            [64080] = "right_pinky_2",
            [64081] = "right_pinky_3",
            [64096] = "right_middle_2",
            [64097] = "right_middle_3",
            [64112] = "right_ring_2",
            [64113] = "right_ring_3",
            [64729] = "left_shoulder",
            [65068] = "facial_root",
            [65245] = "left_foot_ik"
        }
    
        return boneMap[bone] or "unknown"
    end  

    AddEventHandler('gameEventTriggered', function(event, args)
        if event == "CEventNetworkEntityDamage" then
            victim = args[1]       -- Entity, která byla poškozena
            attacker = args[2]     -- Entity, která způsobila poškození
            fatal = args[6] == 1   -- Zda bylo poškození smrtelné
            weaponHash = args[7]   -- Hash zbraně nebo příčiny poškození
            isMelee = args[12] == 1 -- Zda se jednalo o melee útok
        end
    end)


    CreateThread(function()
        while true do
            Wait(500)

            local ped = PlayerPedId()
            local health = GetEntityHealth(ped)

            if health < lastHealth then
                local boneHit, bone = GetPedLastDamageBone(ped)
                local boneLabel = GetBoneLabel(bone)

                if victim == PlayerPedId() then
                    local injury = {
                        type = DetectInjuryTypes(weaponHash, isMelee, lastHealth-health, boneLabel),
                        bone = boneLabel,
                        severity = (lastHealth - health > 25) and "severe" or "minor",
                        weapon = weaponHash,
                        isMelee = isMelee
                    }

                    TriggerServerEvent("dr-bridge:injuries:add", injury)
                end
            end

            lastHealth = health
        end
    end)
end