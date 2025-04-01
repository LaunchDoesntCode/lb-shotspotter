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



RegisterNetEvent("lb-shotspot:gunshotdispatch", function(street1, street2, x, y, z, weaponClass, isInVehicle, vehiclePlate, vehicleType, vehicleColor, vehicleClass)
    local src = source
    local Player, jobName, gender

    if useESX then
   	Player = Framework.GetPlayerFromId(src)
    	if not Player then return end
    	jobName = Player.getJob().name
    	gender = (Player.get("sex") == "f") and "Female" or "Male"

    else -- QBCore & QBX
    	Player = Framework.Functions.GetPlayer(src)
    	if not Player then return end
    	jobName = Player.PlayerData.job.name
   	gender = (Player.PlayerData.gender == 0) and "Female" or "Male"
     end


    if Config.blacklistedJobs[jobName] then return end

    local locationLabel = street1
    if (street2 ~= nil and street2 ~= "") then
        locationLabel = locationLabel .. " / " .. street2
    end

    Citizen.CreateThread(function()
        Citizen.Wait(Config.dispatch_delay)

        local policeDispatch = {
            priority    = 'high',
            code        = '10-04',
            title = (Config.vehiclealerts and isInVehicle) and 'Shots fired from a vehicle' or 'Shots fired',
            description = ('Gunfire reported near %s'):format(locationLabel),
            location    = { label = locationLabel, coords = { x = x, y = y, z = z } },
            time        = 300,
            job         = Config.policejob,
            fields      = {
                { icon = 'fa-solid fa-gun', label = 'Weapon Class', value = weaponClass },
                { icon = 'fa-solid fa-venus-mars', label = 'Gender', value = gender }
            }
        }
	if Config.vehiclealerts and isInVehicle then
		--table.insert(policeDispatch.fields, { icon = 'fa-solid fa-car', label = 'License Plate', value = vehiclePlate })
		table.insert(policeDispatch.fields, { icon = 'fa-solid fa-car', label = 'Type', value = vehicleType })
		table.insert(policeDispatch.fields, { icon = 'fa-solid fa-car', label = 'Color', value = vehicleColor })
	end

	exports["lb-tablet"]:AddDispatch(policeDispatch)
	if Config.ambulancedispatch then
		policeDispatch.job = Config.ambulancejob
		exports["lb-tablet"]:AddDispatch(policeDispatch)
	end
    end)
end)
