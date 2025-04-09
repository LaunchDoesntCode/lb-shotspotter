Config = {}

-- Scan interval (ms)
-- Important to adjust this interval to your liking; this is the interval in which it checks if the player is actively firing a weapon. 
-- Increasing this interval will result in decreased detection accuracy. If someone shoots once, the flag is active for only a few frames. 
-- This interval needs to be low enough to check virtually every frame; however, if you set it too low, you will run into performance issues.
-- 25ms interval will check if the player is actively shooting 40 times a second. 
Config.scanInterval = 25

Config.shotspotter_cooldown = 60000 -- Time (ms) before allowing another shot to trigger dispatch
Config.dispatch_delay = 0  -- 15 seconds before sending dispatch, set to 0 for no delay
Config.vehiclealerts = true -- Enables/disables "shots fired from vehicle" alerts. If disabled regular dispatches will still be sent.

Config.pedWitness = {
    enabled = false, -- Enables/disables witnesses.
    radius = 200, -- Radius of nearby ped witnesses
    callChance = 100, -- percent chance a ped calls
}

-- Jobs that will receive the dispatch alerts.
Config.dispatchJobs = {"police", "ambulance"}


-- Blacklisted jobs, players with these jobs will not trigger gunshot dispatches
Config.blacklistedJobs = {
    police = true,
    bcso   = true
}

-- Blacklisted weapons that DO NOT trigger ShotSpotter
Config.blacklistedweapons = {
    "WEAPON_UNARMED", "WEAPON_STUNGUN", "WEAPON_KNIFE", "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET",
    "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE",
    "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_SNOWBALL",
    "WEAPON_FLARE", "WEAPON_BALL"
}
