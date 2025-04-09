local Framework = nil
local useESX = false
local useQbox = false

CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        Framework = exports['es_extended']:getSharedObject()
        useESX = true
        print("[ShotSpotter] Using ESX Framework")
    elseif GetResourceState('qbx_core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
        useQbox = true
        print("[ShotSpotter] Using Qbox Framework")
    elseif GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
        print("[ShotSpotter] Using QBCore Framework")
    else
        print("[ShotSpotter] No supported framework found!")
    end
end)

RegisterNetEvent("lb-shotspot:dispatch", function(data)
    local src = source
    local Player, jobName, gender

    if useESX then
        Player = Framework.GetPlayerFromId(src)
        if not Player then return end
        jobName = Player.getJob().name
        gender = (Player.get("sex") == "f") and "Female" or "Male"
    else
        Player = Framework.Functions.GetPlayer(src)
        if not Player then return end
        jobName = Player.PlayerData.job.name
        gender = (Player.PlayerData.gender == 0) and "Female" or "Male"
    end

    if Config.blacklistedJobs[jobName] then return end

    local loc = data.street1
    if data.street2 and data.street2 ~= "" then
        loc = loc .. " / " .. data.street2
    end

    local dispatch = {
        location = { label = loc, coords = data.coords },
        time     = 300,
        fields   = {
            { icon = 'fa-solid fa-venus-mars', label = 'Gender', value = gender }
        },
        job      = nil
    }

    -- Customize based on type
    if data.type == "gunshot" then
        dispatch.priority = "high"
        dispatch.code = "10-04"
        dispatch.title = (Config.vehiclealerts and data.isInVehicle) and "Shots fired from a vehicle" or "Shots fired"
        dispatch.description = ("Gunfire reported near %s"):format(loc)
        table.insert(dispatch.fields, { icon = 'fa-solid fa-gun', label = 'Weapon Class', value = data.weaponClass })
        if Config.vehiclealerts and data.isInVehicle then
            table.insert(dispatch.fields, { icon = 'fa-solid fa-car', label = 'Type', value = data.vehType })
            table.insert(dispatch.fields, { icon = 'fa-solid fa-car', label = 'Color', value = data.vehColor })
        end

    elseif data.type == "fight" then
        dispatch.priority = "medium"
        dispatch.code = "10-10"
        dispatch.title = "Fighting Reported"
        dispatch.description = ("Physical altercation reported near %s"):format(loc)
        table.insert(dispatch.fields, { icon = 'fa-solid fa-fist-raised', label = 'Type', value = "Fist Fight" })
    end

    -- Send to all configured jobs
    for _, job in ipairs(Config.dispatchJobs) do
        local copy = table.deepcopy(dispatch)
        copy.job = job
        exports["lb-tablet"]:AddDispatch(copy)
    end
end)

-- utility
function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
