Config = {}

-- Scan interval (ms) -- Increasing this number makes the gunshot detection less accurate but decreases server load
Config.scanInterval = 25

-- Time (ms) before allowing another shot to trigger dispatch
Config.shotspotter_cooldown = 60000
Config.dispatch_delay = 15000  -- 15 seconds before sending dispatch, set to 0 for no delay
Config.ambulancedispatch = true -- whether or not to send ambulance got shot dispatches

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
