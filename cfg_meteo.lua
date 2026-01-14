cfg_meteo = {}

cfg_meteo.CheckInsideZoneInterval = 15000

cfg_meteo.ClothingTemperatureEffect = false

cfg_meteo.TemperatureEffectInterval = 60000

cfg_meteo.PerClothFeeling = 5

cfg_meteo.ConvertFahrenheitToCelsius = true

cfg_meteo.DegreeForWarmthBalance = 0  -- Greater than 0 indicates sweating, less than 0 indicates chilling.

cfg_meteo.MinimumColdStartLevel = -20 

cfg_meteo.MinimumPerspirationStartLevel = 2

cfg_meteo.CriticalColdLevel = -50 

cfg_meteo.CriticalPerspirationLevel = 50

cfg_meteo.GiveDamage = false

cfg_meteo.Damage = 0

cfg_meteo.WarmthEffect = false

cfg_meteo.WarmthNotifications = false

cfg_meteo.WarmthEffectInterval = 15000

cfg_meteo.ChangeTimeFadeEffectOnEnter = false  -- will only work for entrances to the zones. It won't work for exits
 
cfg_meteo.ColdWeatherConditions = {
    "THUNDER"
}

cfg_meteo.RealTimeAlways = false 

cfg_meteo.PerspirationWeatherConditions = {
    "EXTRASUNNY","CLEAR" 
}

cfg_meteo.ClothingFeelings = {
    Cold = { -- List of clothes you should not wear in cold weather
    --    [11] = {
    --        7
    --    }
    },
    Perspiration = {--A list of clothes you should not wear in hot weather
        [11] = {
            7
        }
    }
}

cfg_meteo.ZoneList = {
    -- {
    --     name = "snow",
    --     coords = {
    --         vector2(2727.6, 91.7),
    --         vector2(798.7, 33.2),
    --         vector2(937.7, 6640.8),
    --         vector2(3418.6, 6136.8),
    --     },
    --     opts = {
    --         name="snow",
    --         minZ= 0.0,
    --         maxZ= 500.0,
    --         debugGrid=false,
    --         gridDivisions=25
    --     },
    --     time = {
    --         forceTime = true,
    --         hour = 22,
    --         minute = 22
    --     },
    --     weather = "XMAS"
    -- },
	--{
    --    name = "town",
    --    coords = {
	--	    vector2(-164.64788818359, 7524.8403320313),
    --        vector2(921.96185302734, 6508.5952148438),
	--		vector2(928.18237304688, 6465.5419921875),
    --        vector2(-169.30432128906, 6468.0703125),
    --    },
    --    opts = {
    --        name="town",
    --        minZ= 0.0,
    --        maxZ= 500.0,
    --        debugGrid=false,
    --        gridDivisions=25
    --    },
    --    time = {
    --        forceTime = true,
    --        hour = 12,
    --        minute = 12
    --    },
    --    weather = "THUNDER"
    --},
	-- 
    --{
    --   name = "half-map",
    --   coords = {
    --       vector2(68.472, 7616.768),
    --       vector2(104.669, 1621.341),
    --       vector2(-3248.069, 1514.634),
    --       vector2(-2548.263, 7575.610),
    --   },
    --   opts = {
    --       name="half-map",
    --       minZ= 0.0,
    --       maxZ= 500.0,
    --       debugGrid=false,
    --       gridDivisions=25
    --   },
    --   time = {
    --       forceTime = true,
    --       hour = 12,
    --       minute = 12
    --   },
    --   weather = "BLIZZARD"
    --},

    --{
    --    name = "xmas",
    --    coords = {
    --        vector2(-1631.9451904297, -867.21942138672),
    --        vector2(-1620.9650878906, -876.59680175781),
    --        vector2(-1632.4249267578, -890.62127685547),
    --        vector2(-1646.1198730469, -879.01684570313),
    --    },
    --    opts = {
    --        name="xmas",
    --        minZ= 0.0,
    --        maxZ= 1500.0,
    --        debugGrid=false,
    --        gridDivisions=25
    --    },
    --    time = {
    --        forceTime = true,
    --        hour = 12,
    --        minute = 12
    --    },
    --    weather = "XMAS"
    --}
}

cfg_meteo.Translation = {
    ["sweating"] = "Vous avez chaud",
    ["cold"] = "Vous avez froid",
    ["hypothermia"] = "Vous êtes en hypothermie",
    ["faint"] = "Vous avez extrêmement chaud",
}