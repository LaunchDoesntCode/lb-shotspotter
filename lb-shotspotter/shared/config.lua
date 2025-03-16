Config = {}

-- Scan interval (ms)
Config.scanInterval = 25

-- Time (ms) before allowing another shot to trigger dispatch
Config.shotspotter_cooldown = 60000
Config.dispatch_delay = 2500  -- 15 seconds before sending dispatch
Config.ambulancedispatch = true -- whether or not to send ambulance got shot dispatches

-- Blacklisted weapons that DO NOT trigger ShotSpotter
Config.blacklistedweapons = {
    "WEAPON_UNARMED", "WEAPON_STUNGUN", "WEAPON_KNIFE", "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET",
    "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE",
    "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_SNOWBALL",
    "WEAPON_FLARE", "WEAPON_BALL"
}
