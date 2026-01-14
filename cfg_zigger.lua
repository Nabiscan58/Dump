cfg_activeSocietys = {
    ["societys"] = {
        {name = "LSPD 👮", jobName = "police", min = 1, pos = vector3(-1099.861328125, -836.6240234375, 19.325885772705), dst = nil},
        {name = "BCSO 👮‍♂️", jobName = "sheriff", min = 1, pos = vector3(2807.0537109375, 4749.017578125, 48.62735748291), dst = nil},
        {name = "EMS 🚑", jobName = "ems", min = 1, pos = vector3(-675.86791992188, 320.06790161133, 83.083168029785), dst = nil},
        {name = "LSFD 🚒", jobName = "lsfd", min = 1, pos = vector3(-1036.2503662109, -1401.4573974609, 5.0749530792236), dst = nil},
        {name = "LTD ⛽", jobName = "ltdsud", min = 1, pos = vector3(-711.548828125, -913.43743896484, 19.215599060059), dst = nil},
        {name = "DOJ ⚖️", jobName = "doj", min = 1, pos = vector3(-549.99829101562, -195.95510864258, 38.220699310303), dst = nil},
        {name = "Taxi Co. 🚕", jobName = "taxi", min = 1, pos = vector3(-1258.3092041016, -275.50930786133, 38.82612991333), dst = nil},
        {name = "Fourrière 🚚", jobName = "fourriere", min = 1, pos = vector3(1452.7043457031, 3574.9013671875, 34.863334655762), dst = nil},
        {name = "Bennys 🔧", jobName = "bennys", min = 1, pos = vector3(-329.69479370117, -1353.3620605469, 31.45539855957), dst = nil},
        {name = "Harmony Customs 🔧", jobName = "harmony", min = 1, pos = vector3(59.480590820312, 6521.8969726562, 31.91283416748), dst = nil},
        {name = "Dynasty 8 🏠", jobName = "immo", min = 1, pos = vector3(72.559837341309, -254.10906982422, 48.197086334229), dst = nil},
        {name = "AmmuNation 🔫", jobName = "ammu", min = 1, pos = vector3(816.44921875, -2150.3679199219, 29.619194030762), dst = nil},
        {name = "PDM 🚙", jobName = "pdm", min = 1, pos = vector3(-43.650707244873, -1091.8682861328, 27.274402618408), dst = nil},
        {name = "Bobcat Security 🛡️", jobName = "bobcat", min = 1, pos = vector3(754.72448730469, -1383.4371337891, 26.2123046875), dst = nil},
        {name = "Burgershot 🍔", jobName = "burgershot", min = 1, pos = vector3(-828.73803710938, -419.71801757812, 35.863259887695), dst = nil},
        {name = "Bahamas 🍸", jobName = "bahamas", min = 1, pos = vector3(-1390.0251464844, -601.85241699219, 30.214027404785), dst = nil},
        {name = "Unicorn 🦄", jobName = "unicorn", min = 1, pos = vector3(124.94038391113, -1290.9110107422, 28.444358825684), dst = nil},
        {name = "Tabac Co. 🚬", jobName = "tabac", min = 1, pos = vector3(-46.985694885254, 2894.6708984375, 60.099094390869), dst = nil},
        {name = "Vignes 🍇", jobName = "vigne", min = 1, pos = vector3(-1884.6486816406, 2060.3474121094, 140.98066711426), dst = nil},
        {name = "Weazle News 📰", jobName = "weazle", min = 1, pos = vector3(-586.65557861328, -923.72106933594, 24.091701507568), dst = nil},
    },
}

cfg_props = {}

cfg_props.zones = {
    {
        name      = "Zone #1",

        poly      = {
            vector2(-3760.31, -961.25),
            vector2(5217.93, -1102.96),
            vector2(5228.25, -3967.82),
            vector2(-3443.53, -4078.02),
        },
    },
    {
        name      = "Zone #2",

        poly      = {
            vector2(-3760.31, -961.25),
            vector2(-3894.11, 1738.54),
            vector2(5139.23, 1636.19),
            vector2(5217.93, -1102.96),
        },
    },
    {
        name      = "Zone #3",

        poly      = {
            vector2(-3894.11, 1738.54),
            vector2(5139.23, 1636.19),
            vector2(5438.27, 7641.69),
            vector2(-3961.3, 8045.61),
        },
    },
    {
        name      = "Zone #4 Cayo",

        poly      = {
            vector2(3151.62, -4108.64),
            vector2(5893.86, -4194.1),
            vector2(5817.23, -6134.91),
            vector2(3760.71, -6055.97),
        },
    },
}

cfg_callSociety = {}

cfg_callSociety.Enterprises = {
    {
        name = "police",
        label = "LSPD",
        coords = vector3(-1095.7506, -817.5710, 18.0313)
    },
    {
        name = "sheriff",
        label = "BCSO",
        coords = vector3(2827.3044433594, 4730.5600585938, 48.627391815186)
    },
    {
        name = "lsfd",
        label = "LSFD",
        coords = vector3(-1039.8220214844, -1400.64453125, 5.0749554634094)
    },
    {
        name = "marshall",
        label = "Marshall",
        coords = vector3(1061.6059570312, 2723.2133789062, 38.65710067749)
    },
    {
        name = "ems",
        label = "EMS",
        coords = vector3(-677.78204345703, 325.07122802734, 83.083106994629)
    },
    {
        name = "fourriere",
        label = "Fourrière",
        coords = vector3(1464.4812011719, 3581.1652832031, 35.677646636963)
    },
    {
        name = "taxi",
        label = "Taxi",
        coords = vector3(-1248.9931640625, -282.85256958008, 37.675521850586)
    },
    {
        name = "pdm",
        label = "PDM",
        coords = vector3(-783.38824462891, -232.93005371094, 37.03468704223)
    },
    {
        name = "paletoauto",
        label = "Paleto Automobiles",
        coords = vector3(-239.33079528809, 6223.8266601562, 31.944219589233)
    },
    {
        name = "harmony",
        label = "Harmony Customs",
        coords = vector3(72.459342956543, 6522.6586914062, 31.91283416748)
    },
    {
        name = "bennys",
        label = "Bennys Customs",
        coords = vector3(-327.3186340332, -1336.9201660156, 31.454818725586)
    },
    {
        name = "ammu",
        label = "Ammunation",
        coords = vector3(11.130383491516, -1110.8271484375, 29.797204971313)
    },
    {
        name = "ammu",
        label = "Ammunation",
        coords = vector3(819.37768554688, -2150.1394042969, 29.619184494019)
    },
    {
        name = "ltdsud",
        label = "LTD Sud",
        coords = vector3(-700.42053222656, -917.49371337891, 19.214139938354)
    },
    {
        name = "kebab",
        label = "Kebab",
        coords = vector3(294.97219848633, -972.96014404297, 29.418569564819)
    },
    {
        name = "burgershot",
        label = "Burgershot",
        coords = vector3(-828.73803710938, -419.71801757812, 35.863259887695)
    },
    {
        name = "immo",
        label = "Dynasty8",
        coords = vector3(66.871711730957, -261.34979248047, 48.19705581665)
    },
    {
        name = "bobcat",
        label = "Bobcat Security",
        coords = vector3(754.72448730469, -1383.4371337891, 26.2123046875)
    },
    {
        name = "bahamas",
        label = "Bahamas",
        coords = vector3(-1387.1839599609, -590.1240234375, 30.214027404785)
    },
    {
        name = "unicorn",
        label = "Unicorn",
        coords = vector3(136.00323486328, -1290.787109375, 29.219013214111)
    },
    {
        name = "gouv",
        label = "Gouvernement",
        coords = vector3(-436.421875, 1098.6009521484, 329.76638793945)
    },
    {
        name = "larrys",
        label = "Larry's",
        coords = vector3(1215.5212402344, 2738.8173828125, 38.10466003418)
    },
    {
        name = "doj",
        label = "DOJ",
        coords = vector3(-440.95919799805, 1095.3055419922, 329.76638793945)
    },
}

cfg_callSociety.Cooldown = 120

cfg_basejump = {}

cfg_basejump.PayAccount = "money"
cfg_basejump.UseOxTarget = true

cfg_basejump.JumpPoints = {
    {
        id = "mount_chiliad",
        label = "Saut Parachute - Mont Chiliad",
        price = 1500,
        enter = vec3(451.86, 5572.62, 781.18),
        enterHeading = 90.0,
        spawn = vec3(450.60, 5580.20, 1100.00),
        spawnHeading = 90.0,
        blip = { sprite = 94, scale = 0.85, color = 2 },
        npc = {
            model = "s_m_y_pilot_01",
            coords = vec3(451.86, 5572.62, 781.18),
            heading = 90.0,
            scenario = "WORLD_HUMAN_CLIPBOARD"
        }
    },
    {
        id = "maze_bank",
        label = "Saut Parachute - Maze Bank",
        price = 2500,
        enter = vec3(-75.20, -818.90, 326.17),
        enterHeading = 0.0,
        spawn = vec3(-75.20, -818.90, 900.00),
        spawnHeading = 0.0,
        blip = { sprite = 94, scale = 0.85, color = 27 },
        npc = {
            model = "s_m_y_airworker",
            coords = vec3(-75.20, -818.90, 326.17),
            heading = 0.0,
            scenario = "WORLD_HUMAN_STAND_IMPATIENT"
        }
    }
}