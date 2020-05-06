Config                            = {}
Config.ProximityAlarms = {
  TestLocation = {
    coords = vector3(337.53, -1349.06, 32.51),
    alertDistance = 200,
    whitelistedJob = 'test'
  }
}
Config.AlertTime                  = 5000   -- seconds multiplied by 1000
Config.NotificationType           = 2      -- 1 for esx_phone output, 2 for a simple notification