-- Gunshot detection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(80)

        -- Use the Cfx native to get the player's Ped
        local ped = PlayerPedId()
        local myPos = GetEntityCoords(ped)
        local weapon = GetSelectedPedWeapon(ped)
        local isSilenced = IsPedCurrentWeaponSilenced(ped)

        -- Get in-game time
        local hours, minutes, seconds = GetClockHours(), GetClockMinutes(), GetClockSeconds()
        local gameTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)

        -- Detect gender (if your IsPedMale(...) function exists)
        local gender = IsPedMale(ped) and 'Male' or 'Female'

        -- Find nearest street name
        local streetHash = GetStreetNameAtCoord(myPos.x, myPos.y, myPos.z)
        local streetName = GetStreetNameFromHashKey(streetHash) or "Unknown Location"

        -- Check if the player is shooting and dispatch alerts
        if IsPedShooting(ped) and not isSilenced and not isBlacklisted(weapon) then
            local dispatchId = exports["lb-tablet"]:AddDispatch({
                priority = 'high',
                code = '10-04',
                title = 'Shots fired',
                description = 'Someone is shooting in the area',
                location = { label = streetName, coords = { x = myPos.x, y = myPos.y } },
                time = 500,
                job = 'police',
                fields = {
                    { icon = 'map-marker', label = 'Location', value = streetName },
                    { icon = "fa-solid fa-venus-mars", label = "Gender", value = gender },
                    { icon = 'clock', label = 'Time', value = gameTime }
                }
            })
            local dispatchId = exports["lb-tablet"]:AddDispatch({
                priority = 'low',
                code = '10-04',
                title = 'Shots fired',
                description = 'Someone is shooting in the area',
                location = { label = streetName, coords = { x = myPos.x, y = myPos.y } },
                time = 500,
                job = 'ambulance',
                fields = {
                    { icon = 'map-marker', label = 'Location', value = streetName },
                    { icon = "fa-solid fa-venus-mars", label = "Gender", value = gender },
                    { icon = 'clock', label = 'Time', value = gameTime }
                }
            })

            -- Alert cooldown
            Citizen.Wait(Config.AlertCooldown)
        end
    end
end)


-- Weapon blacklist function
function isBlacklisted(model)
    for _, blacklistedWeapon in pairs(Config.Blacklist) do
        if model == blacklistedWeapon then
            return true
        end
    end
    return false
end