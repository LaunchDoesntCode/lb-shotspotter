local lastShotTime = 0

local vehicleColors = {
    [0] = "Black", [1] = "Graphite", [2] = "Black Steel", [3] = "Dark Silver", [4] = "Silver",
    [5] = "Blue Silver", [6] = "Rolled Steel", [7] = "Shadow Silver", [8] = "Stone Silver",
    [9] = "Midnight Silver", [10] = "Cast Iron Silver", [11] = "Anthracite Grey", [12] = "Matte Black",
    [13] = "Matte Grey", [14] = "Matte Light Grey", [15] = "Red", [16] = "Torino Red",
    [17] = "Formula Red", [18] = "Lava Red", [19] = "Blaze Red", [20] = "Grace Red",
    [21] = "Garnet Red", [22] = "Sunset Red", [23] = "Cabernet Red", [24] = "Wine Red",
    [25] = "Candy Red", [26] = "Hot Pink", [27] = "Pfister Pink", [28] = "Salmon Pink",
    [29] = "Sunrise Orange", [30] = "Orange", [31] = "Bright Orange", [32] = "Gold",
    [33] = "Bronze", [34] = "Yellow", [35] = "Race Yellow", [36] = "Dew Yellow",
    [37] = "Dark Green", [38] = "Racing Green", [39] = "Sea Green", [40] = "Olive Green",
    [41] = "Bright Green", [42] = "Gasoline Green", [43] = "Lime Green", [44] = "Midnight Blue",
    [45] = "Galaxy Blue", [46] = "Dark Blue", [47] = "Saxon Blue", [48] = "Blue",
    [49] = "Mariner Blue", [50] = "Harbor Blue", [51] = "Diamond Blue", [52] = "Surf Blue",
    [53] = "Nautical Blue", [54] = "Ultra Blue", [55] = "Schafter Purple", [56] = "Spinnaker Purple",
    [57] = "Midnight Purple", [58] = "Bright Purple", [59] = "Cream", [60] = "Ice White",
    [61] = "Frost White"
}

local vehicleClassNames = {
    [0] = "Compact", [1] = "Sedan", [2] = "SUV", [3] = "Coupe",
    [4] = "Muscle", [5] = "Sports Classics", [6] = "Sports", [7] = "Super",
    [8] = "Motorcycle", [9] = "Off-road", [10] = "Industrial", [11] = "Utility",
    [12] = "Van", [13] = "Bicycle", [14] = "Boat", [15] = "Helicopter",
    [16] = "Plane", [17] = "Service", [18] = "Emergency", [19] = "Military",
    [20] = "Commercial", [21] = "Train"
}

local function getWeaponClass(weaponHash)
    local group = GetWeapontypeGroup(weaponHash)
    if group == 416676503 then return "Pistol"
    elseif group == 860033945 then return "SMG"
    elseif group == 970310034 then return "Rifle"
    elseif group == 1159398588 then return "MG"
    elseif group == 3082541095 then return "Shotgun"
    elseif group == 2725924767 then return "Sniper"
    elseif group == 1548507267 then return "Heavy"
    else return "Unknown" end
end

-- Define a list of reference colors. You can add or remove entries as desired.
local colorSwatches = {
    { name = "Black",      r =   0, g =   0, b =   0 },
    { name = "White",      r = 255, g = 255, b = 255 },
    { name = "Gray",       r = 128, g = 128, b = 128 },
    { name = "Silver",     r = 192, g = 192, b = 192 },
    { name = "Red",        r = 255, g =   0, b =   0 },
    { name = "Maroon",     r = 128, g =   0, b =   0 },
    { name = "Pink",       r = 255, g = 192, b = 203 },
    { name = "Hot Pink",   r = 255, g = 105, b = 180 },
    { name = "Purple",     r = 128, g =   0, b = 128 },
    { name = "Dark Blue",  r =   0, g =   0, b = 139 },
    { name = "Blue",       r =   0, g =   0, b = 255 },
    { name = "Light Blue", r = 173, g = 216, b = 230 },
    { name = "Green",      r =   0, g = 128, b =   0 },
    { name = "Lime",       r =   0, g = 255, b =   0 },
    { name = "Yellow",     r = 255, g = 255, b =   0 },
    { name = "Orange",     r = 255, g = 165, b =   0 },
    { name = "Brown",      r = 139, g =  69, b =  19 },
}

-- Measures standard Euclidean distance in RGB space
local function colorDistance(r1, g1, b1, r2, g2, b2)
    return math.sqrt((r2 - r1)^2 + (g2 - g1)^2 + (b2 - b1)^2)
end

-- Picks whichever reference color is closest
function approximateColorName(r, g, b)
    local bestMatch, smallestDist = "Unknown", 999999
    for _, swatch in ipairs(colorSwatches) do
        local dist = colorDistance(r, g, b, swatch.r, swatch.g, swatch.b)
        if dist < smallestDist then
            smallestDist = dist
            bestMatch = swatch.name
        end
    end
    return bestMatch
end



local function getVehicleColor(vehicle)
    if GetIsVehiclePrimaryColourCustom(vehicle) then
        local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
        return approximateColorName(r, g, b)
    else
        local c1, _ = GetVehicleColours(vehicle)
        return vehicleColors[c1] or "Unknown"
    end
end

local function getVehicleInfo(vehicle)
    if not vehicle or vehicle == 0 then
        return "Unknown", "Unknown", "Unknown", "Unknown"
    end
    local plate = GetVehicleNumberPlateText(vehicle) or "UNKNOWN"
    local classId = GetVehicleClass(vehicle)
    local carType = vehicleClassNames[classId] or "Unknown"
    local color = getVehicleColor(vehicle)
    return plate, carType, color, carType
end

local function findNearbyPeds(coords, radius)
    local handle, ped = FindFirstPed()
    local success
    local peds = {}
    repeat
        local pedCoords = GetEntityCoords(ped)
        if #(pedCoords - coords) <= radius and not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped, true) then
            peds[#peds+1] = ped
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return peds
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.scanInterval)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and IsPedShooting(ped) then
            local now = GetGameTimer()
            if (now - lastShotTime) > Config.shotspotter_cooldown then
                lastShotTime = now
                local currentWepHash = GetSelectedPedWeapon(ped)
                local blacklistedweapon = false
                for _, weaponName in ipairs(Config.blacklistedweapons) do
                    if currentWepHash == GetHashKey(weaponName) then
                        blacklistedweapon = true
                        break
                    end
                end
                if not blacklistedweapon then
                    local isSilenced = IsPedCurrentWeaponSilenced(ped)
                    if not isSilenced then
                        local coords = GetEntityCoords(ped)
                        if Config.pedWitness.enabled then
                            local nearPeds = findNearbyPeds(coords, Config.pedWitness.radius)
                            if #nearPeds == 0 then
                                goto continue
                            end
                            local roll = math.random(1, 100)
                            if roll > Config.pedWitness.callChance then
                                goto continue
                            end
                        end
                        local x, y, z = coords.x, coords.y, coords.z
                        local hash1, hash2 = GetStreetNameAtCoord(x, y, z)
                        local street1 = GetStreetNameFromHashKey(hash1)
                        local street2 = GetStreetNameFromHashKey(hash2)
                        local weaponClass = getWeaponClass(currentWepHash)
                        local veh = GetVehiclePedIsIn(ped, false)
                        local isInVehicle = (veh and veh ~= 0)
                        local plate, vehType, vehColor, vehClass = "Unknown", "Unknown", "Unknown", "Unknown"
                        if isInVehicle then
                            plate, vehType, vehColor, vehClass = getVehicleInfo(veh)
                        end
                        TriggerServerEvent(
                            "lb-shotspot:gunshotdispatch",
                            street1, street2, x, y, z, weaponClass, isInVehicle,
                            plate, vehType, vehColor, vehClass
                        )
                    end
                end
            end
        end
        ::continue::
    end
end)
