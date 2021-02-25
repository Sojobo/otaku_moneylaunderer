Config = {}

Config.baseRate = 55 -- The minimum launder rate (50% means for every $2 dirty, you get $1 clean)
Config.bonusPerCop = 4 -- Increase the launder rate by this percentage for each online cop
Config.maxRate = 0.8 -- This is the maximum laundering rate, default 0.8 means the maximum is 80%
Config.minStack = 600 -- The minimum amount of clean money laundered in one transaction
Config.maxStack = 600 -- The maximum amount of clean money laundered in one transaction

Config.launderSpeed = 2500 -- How quickly money is laundered in ms (2500 is 2.5s)

Config.callPoliceChance = 10 -- The higher this number, the less likely a CAD is sent to the police
Config.policeCooldown = 60000 -- How often can the CAD trigger for police in ms (default 60000 - 60s)

Config.launderLocations = {
    {pos = vector3(264.74969482422, -308.96340942383, 49.645687103271 - 0.95)},
    {pos = vector3(141.30043029785, -243.28141784668, 51.516918182373 - 0.95)},
    {pos = vector3(-446.84097290039, -442.94692993164, 33.163032531738 - 0.95)},
    {pos = vector3(-682.09155273438, -172.26908874512, 37.821308135986 - 0.95)},
    {pos = vector3(-1319.82421875, -591.99108886719, 28.755462646484 - 0.95)},
    {pos = vector3(-1360.6837158203, -924.50451660156, 9.705810546875 - 0.95)},
    {pos = vector3(-1213.4447021484, -1064.2596435547, 8.3869218826294 - 0.95)},
    {pos = vector3(-1170.7248535156, -1160.8668212891, 5.6416053771973 - 0.95)},
    {pos = vector3(-1272.8575439453, -1368.6483154297, 4.3024840354919 - 0.95)},
    {pos = vector3(-1103.3171386719, -1496.6444091797, 4.8032469749451 - 0.95)},
    {pos = vector3(-702.43469238281, -1141.255859375, 10.612627029419 - 0.95)},
    {pos = vector3(-109.22281646729, -1458.2440185547, 33.461277008057 - 0.95)},
    {pos = vector3(179.3822479248, -1640.3228759766, 29.291748046875 - 0.95)},
    {pos = vector3(550.11846923828, -1614.2145996094, 28.377500534058 - 0.95)},
    {pos = vector3(887.33410644531, -2176.7473144531, 30.519371032715 - 0.95)},
    {pos = vector3(372.11627197266, -2420.8310546875, 6.0416603088379 - 0.95)},
    {pos = vector3(-115.54424285889, -2517.2739257812, 6.0957117080688 - 0.95)}
}
