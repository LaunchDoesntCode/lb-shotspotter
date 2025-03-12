Config = Config or {}

-- Sets the minimum time in milliseconds between gunshots alert notifications.
Config.AlertCooldown = 30000

-- Sets the weapons the ShotSpotter won't detect.
Config.Blacklist = {
    `WEAPON_STUNGUN`,
    `WEAPON_SNOWBALL`,
    `WEAPON_PETROLCAN`,
    `WEAPON_PISTOL_MK2`,
}
