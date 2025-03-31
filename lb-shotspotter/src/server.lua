local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("lb-shotspot:gunshotdispatch", function(street1, street2, x, y, z, weaponClass, isInVehicle, vehiclePlate, vehicleType, vehicleColor, vehicleClass)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local gender = (Player.PlayerData.gender == 0) and "Male" or "Female"
    local jobName = Player.PlayerData.job.name

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
            title       = isInVehicle and 'Shots fired from a vehicle' or 'Shots fired',
            description = ('Gunfire reported near %s'):format(locationLabel),
            location    = { label = locationLabel, coords = { x = x, y = y, z = z } },
            time        = 300,
            job         = 'police',
            fields      = {
                { icon = 'fa-solid fa-gun', label = 'Weapon Class', value = weaponClass },
                { icon = 'fa-solid fa-venus-mars', label = 'Gender', value = gender }
            }
        }

        if isInVehicle then
            --table.insert(policeDispatch.fields, { icon = 'fa-solid fa-car', label = 'License Plate', value = vehiclePlate })
            table.insert(policeDispatch.fields, { icon = 'fa-solid fa-car', label = 'Type', value = vehicleType })
            table.insert(policeDispatch.fields, { icon = 'fa-solid fa-car', label = 'Color', value = vehicleColor })
        end

        exports["lb-tablet"]:AddDispatch(policeDispatch)
		if Config.ambulancedispatch
			policeDispatch.job = 'ambulance'
			exports["lb-tablet"]:AddDispatch(policeDispatch)
		end
    end)
end)
