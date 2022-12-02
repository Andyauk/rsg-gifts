Config = {}

-- settings
Config.OpenTime = 10000 -- in milliseconds
Config.Cooldown = 3600 -- amount in seconds (3600 = 1hr)

Config.Blip = {
    blipName = 'Xmas Tree', -- Config.Blip.blipName
    blipSprite = 'blip_special_series_1', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

--Setup as many trees as you want
Config.XmasTrees = {
    { lable = 'Valentine Tree', name = 'xmastree1', coords = vector3(-267.7709, 784.27679, 118.51305), showblip = true },
    -- add more as required
}

-- list of common items / add more as required (must be in your shared inventory items)
Config.CommonItems = {
    'bread', -- example
    'water', -- example
}

-- list of rare items / add more as required (must be in your shared inventory items)
Config.RareItems = {
    'bread', -- example
    'water', -- example
}
