cfg_robberys = {

    ["list"] = {
        ["Braquage Pacific"] = {
            startPos = vector3(241.25361633301, 229.05906677246, 106.28219604492), -- point de démarrage du braquage
            dstInteract = 5.0, -- distance pour interagir

            id = 1, 

            copsNeeded = 8,
            itemNeeded = "bankpacific",
            itemLabelNeeded = "Clé banque Pacifique",
            copsJobs = { "police", "sheriff" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la banque pacifique",
            cooldown = 3600000, 

            steps = {
                {
                    name = "Porte principale",
                    pos = vector3(255.6921081543, 229.44250488281, 106.282196044924),
                    heading = 247.56,
                    minigame = "multipleLockpick",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous vers la deuxième porte et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -2121568016,
                            objYaw = 70.04,
                            objNewHeading = 160.04,
                            objCoords = vector3(256.6068, 229.6896, 106.3702)
                        }
                    },
                },
                {
                    name = "Porte secondaire",
                    pos = vector3(271.13949584961, 221.3169708252, 97.117256164551),
                    heading = 77.56,
                    minigame = "typing",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la porte ! Ouvrez les autres portes et accédez aux coffres !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = 409280169,
                            objYaw = -20.0,
                            objNewHeading = 70.04,
                            objCoords = vector3(272.6422, 219.8987, 97.31798)
                        }
                    },
                },
                {
                    name = "Porte de droite",
                    pos = vector3(247.14356994629, 233.13418579102, 97.117095947266),
                    heading = 335.56,
                    minigame = "typing",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la porte ! Ouvrez les autres portes et accédez aux coffres !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = 409280169,
                            objYaw = -20.0,
                            objNewHeading = 70.04,
                            objCoords = vector3(250.5642, 233.3994, 97.31798)
                        }
                    }
                },
                {
                    name = "Porte de gauche",
                    pos = vector3(241.99108886719, 219.12652587891, 97.117095947266),
                    heading = 158.56,
                    minigame = "typing",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la porte ! Ouvrez les autres portes et accédez aux coffres !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = 409280169,
                            objYaw = -20.0,
                            objNewHeading = 70.04,
                            objCoords = vector3(244.558, 216.8973, 97.31798)
                        }
                    }
                },
                {
                    name = "Grande porte",
                    pos = vector3(236.89865112305, 231.52412414551, 97.11714172363),
                    heading = 69.56,
                    minigame = "multipleLockpick",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la porte ! Ouvrez les autres portes et accédez aux coffres !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })  
                    end,
                    doors = {
                        {
                            objName = 961976194,
                            objYaw = 70.0,
                            objNewHeading = 340.04,
                            objCoords = vector3(234.9857, 228.0696, 97.72185)
                        }
                    }
                },
                {
                    name = "Coffre A (reward)",
                    pos = vector3(231.2904510498, 233.68218994141, 97.117156982422),
                    heading = 339.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },

                {
                    name = "Coffre B (reward)",
                    pos = vector3(228.87202453613, 234.69548034668, 97.117156982422),
                    heading = 352.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },

                {
                    name = "Coffre C (reward)",
                    pos = vector3(225.59759521484, 227.18005371094, 97.117164611816),
                    heading = 160.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "500,000$", type = "money", count = 500000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },

                {
                    name = "Coffre D (reward)",
                    pos = vector3(228.64184570312, 225.9693145752, 97.117156982422),
                    heading = 160.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "500,000$", type = "money", count = 500000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
        
                {
                    name = "Coffre E (reward)",
                    pos = vector3(240.87539672852, 213.72352600098, 97.117149353027),
                    heading = 65.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "500,000$", type = "money", count = 500000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },

                {
                    name = "Coffre F (reward)",
                    pos = vector3(244.13056945801, 212.78527832031, 97.117149353027),
                    heading = 247.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "500,000$", type = "money", count = 500000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },

                {
                    name = "Coffre G (reward)",
                    pos = vector3(253.05662536621, 236.88580322266, 97.117164611816),
                    heading = 250.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,500,000$", type = "money", count = 1500000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },

                {
                    name = "Coffre H (reward)",
                    pos = vector3(249.70379638672, 237.98724365234, 97.117164611816),
                    heading = 69.56,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,500,000$", type = "money", count = 1500000},
                        },
                        vip = {
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
            },

            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "4,000,000$", type = "money", count = 4000000},
                },
                vip = {
                    {label = "500,000$", type = "money", count = 500000},
                },
            },
        },
        ["Braquage Fleeca Legion Square"] = {
            startPos = vector3(151.69345092773, -1042.2058105469, 29.367811203003), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 2, 

            copsNeeded = 4,
            itemNeeded = "bankfleeca",
            itemLabelNeeded = "Pince pour Fleeca",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la Fleeca Legion Square",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Porte Blindée",
                    pos = vector3(148.39094543457, -1048.3614501953, 29.50089263916),
                    heading = 73.2938,
                    minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous vers l'intérieur et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -219621528,
                            objYaw = 159.84,
                            objNewHeading = 87.84,
                            objCoords = vector3(146.91809082031, -1050.37890625, 29.669849395752)
                        }
                    },
                },        
                {
                    name = "Chariot 1",
                    pos = vector3(143.13890075684, -1047.8328857422, 29.508220672607),
                    heading = 307.3327,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Chariot 2",
                    pos = vector3(141.42282104492, -1047.7596435547, 29.508220672607),
                    heading = 138.0671,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,500,000$", type = "money", count = 1500000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Coffre personnels",
                    pos = vector3(145.74127197266, -1048.0074462891, 29.508220672607),
                    heading = 331.6575,
                    minigame = "multipleLockpick",
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu des coffres personnels!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 1000000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage Fleeca Rockford Hills"] = {
            startPos = vector3(-1210.4757080078, -330.12442016602, 37.780738830566), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 3, 

            copsNeeded = 4,
            itemNeeded = "bankfleeca",
            itemLabelNeeded = "Pince pour Fleeca",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la Fleeca de Rockford Hills",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Porte Blindée",
                    pos = vector3(-1208.0747070312, -336.91970825195, 37.913848876953), 
                    heading = 123.1725,
                    minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous vers l'intérieur et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -219621528,
                            objYaw = 206.86,
                            objNewHeading = 116.86,
                            objCoords = vector3(-1207.6163330078, -339.47152709961, 38.082809448242)
                        }
                    },
                },        
                {
                    name = "Chariot 1", 
                    pos = vector3(-1213.1733398438, -341.482421875, 37.921161651611),
                    heading = 162.1869,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Chariot 2", 
                    pos = vector3(-1211.8521728516, -340.3942565918, 37.921165466309),
                    heading = 7.1246,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Coffre personnels",
                    pos = vector3(-1210.1170654297, -338.70004272461, 37.921165466309),
                    heading = 17.4445,
                    minigame = "multipleLockpick",
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu des coffres personnels!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 1000000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage Fleeca Alta"] = {
            startPos = vector3(316.09707641602, -280.61126708984, 54.164520263672), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 4, 

            copsNeeded = 4,
            itemNeeded = "bankfleeca",
            itemLabelNeeded = "Pince pour Fleeca",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la Fleeca Alto",
            cooldown = 1800000,  

            steps = {
                {
                    name = "Porte Blindée",
                    pos = vector3(312.73126220703, -286.74880981445, 54.297580718994), 
                    heading = 70.4192,
                    minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous vers l'intérieur et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -219621528,
                            objYaw = 159.86,
                            objNewHeading = 69.86,
                            objCoords = vector3(311.25155639648, -288.74560546875, 54.466564178467)
                        }
                    },
                },        
                {
                    name = "Chariot 1", 
                    pos = vector3(307.63214111328, -286.29067993164, 54.304916381836),
                    heading = 309.3490,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Chariot 2", 
                    pos = vector3(305.73217773438, -286.10729980469, 54.304920196533),
                    heading = 127.5335,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Coffre personnels",
                    pos = vector3(310.20846557617, -286.43371582031, 54.304920196533),
                    heading = 341.9333,
                    minigame = "multipleLockpick",
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu des coffres personnels!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 1000000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage Fleeca Burton"] = {
            startPos = vector3(-348.96304321289, -51.568588256836, 49.036312103271), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 5, 

            copsNeeded = 4,
            itemNeeded = "bankfleeca",
            itemLabelNeeded = "Pince pour Fleeca",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la Fleeca de Burton",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Porte Blindée",
                    pos = vector3(-352.43771362305, -57.535411834717, 49.169368743896), 
                    heading = 72.5826,
                    --minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous vers l'intérieur et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -219621528,
                            objYaw = 160.85,
                            objNewHeading = 70.85,
                            objCoords = vector3(-353.73843383789, -59.606254577637, 49.338352203369)
                        }
                    },
                },        
                {
                    name = "Chariot 1", 
                    pos = vector3(-357.55926513672, -57.239818572998, 49.176712036133),
                    heading = 303.8355,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Chariot 2", 
                    pos = vector3(-359.22479248047, -57.105964660645, 49.176712036133),
                    heading = 129.8980,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Coffre personnels",
                    pos = vector3(-354.85754394531, -57.298294067383, 49.176712036133),
                    minigame = "multipleLockpick",
                    heading = 338.8474,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu des coffres personnels!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 1000000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage Fleeca Banham Canyon"] = {
            startPos = vector3(-2961.9689941406, 485.16845703125, 15.697715759277), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 6, 

            copsNeeded = 4,
            itemNeeded = "bankfleeca",
            itemLabelNeeded = "Pince pour Fleeca",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la Fleeca de Banham Canyon",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Porte Blindée",
                    pos = vector3(-2954.8317871094, 483.82962036133, 15.830812454224), 
                    heading = 171.2762,
                    minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous vers l'intérieur et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -219621528,
                            objYaw = 177.41,
                            objNewHeading = 70.85,
                            objCoords = vector3(-2952.4812011719, 483.11196899414, 15.999762535095)
                        }
                    },
                },        
                {
                    name = "Chariot 1", 
                    pos = vector3(-2953.7419433594, 478.83801269531, 15.838138580322),
                    heading = 57.4486,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Chariot 2", 
                    pos = vector3(-2953.2907714844, 477.04891967773, 15.838138580322),
                    heading = 222.1709,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "175,000$", type = "money", count = 175000},
                            {label = "Lingot d'or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                    },
                },
                {
                    name = "Coffre personnels",
                    pos = vector3(-2954.3405761719, 481.4130859375, 15.838138580322),
                    minigame = "multipleLockpick",
                    heading = 84.3384,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu des coffres personnels!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "Bijoux",   type = "item",  itemName = "jewels", count = 15},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 1000000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage Banque de Roxwood"] = {
            startPos = vector3(-474.42984008789, 7440.6220703125, 8.3069801330566),  -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir
            id = 7, 

            copsNeeded = 6,
            itemNeeded = "bankroxwood",
            itemLabelNeeded = "Clef du générateur de Roxwood",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de banque de Roxwood",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Porte sécurisé Roxwood",
                    pos = vector3(-473.25875854492, 7437.7885742188, 8.306981086731),
                    heading = 182.4178,
                    minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez franchit la première étape ! Dirigez-vous dans le bureau du directeur pour voler les clefs de la banque.",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = 757185140,
                            objYaw = 0.0,
                            objNewHeading = 90.0,
                            objCoords = vector3(-474.65664672852, 7436.8715820312, 8.4564371109009)
                        }
                    },
                },        
                {
                    name = "Tirroir du directeur",
                    pos = vector3(-481.63040161133, 7457.6083984375, 8.3083200454712),
                    heading = 307.3327,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez récupéré la clef! Dirigez-vous vers le coffre fort !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Clef de la banque",   type = "item",  itemName = "keyroxwood", count = 1},
                        },
                        vip = {
                            {label = "40,000$", type = "money", count = 40000},
                            {label = "Clef de la banque",   type = "item",  itemName = "keyroxwood", count = 1},
                        },
                    },
                },
                {
                    name = "Porte sécurisé Roxwood",
                    pos = vector3(-474.90713500977, 7436.0185546875, 8.3069705963135),
                    heading = 63.1783,
                    minigame = "timedLockpick",
                    itemRequired = "keyroxwood",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez ouvert la porte menant au coffre-fort, hacker la porte pour obtenir le butin !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = 757185140,
                            objYaw = 89.99,
                            objNewHeading = 358.01,
                            objCoords = vector3(-475.75814819336, 7435.41796875, 8.4569864273071)
                        }
                    },
                },   
                {
                    name = "Hack de la porte blindée",
                    pos = vector3(-486.42819213867, 7428.28125, 5.2728176116943),
                    heading = 178.6779,
                    minigame = "memoryGame",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez ouvert la porte menant au coffre-fort, hackez la porte pour obtenir le butin !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = 2134657899,
                            objYaw = 90.10,
                            objNewHeading = 00.10,
                            objCoords = vector3(-487.55792236328, 7427.5405273438, 5.3705520629883)
                        }
                    },
                },   
                {
                    name = "Coffre personnel #1",
                    pos = vector3(-489.75860595703, 7431.8876953125, 5.2728118896484),
                    heading = 358.3139,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier coffre personnel!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "10 Bijoux",   type = "item",  itemName = "jewels", count = 10},
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "10 Bijoux",   type = "item",  itemName = "jewels", count = 10},
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
                {
                    name = "Coffre personnel #2",
                    pos = vector3(-490.56838989258, 7430.216796875, 5.2728214263916),
                    heading = 92.5839,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième coffre personnel!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "4 Lingots en or",   type = "item",  itemName = "lingotdor", count = 4},
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "4 Lingots en or",   type = "item",  itemName = "lingotdor", count = 4},
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
                {
                    name = "Coffre personnel #3",
                    pos = vector3(-490.59252929688, 7427.1513671875, 5.2728114128113),
                    minigame = "multipleLockpick",
                    heading = 94.7671,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du troisième coffre personnel!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "50 Bijoux",   type = "item",  itemName = "jewels", count = 50},
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "50 Bijoux",   type = "item",  itemName = "jewels", count = 50},
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
                {
                    name = "Coffre personnel #4",
                    pos = vector3(-490.60760498047, 7424.017578125, 5.2728161811829),
                    minigame = "multipleLockpick",
                    heading = 92.7752,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du quatrième coffre personnel!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
                {
                    name = "Coffre personnel #5",
                    pos = vector3(-489.19586181641, 7423.1572265625, 5.2728161811829),
                    minigame = "multipleLockpick",
                    heading = 177.0524,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du cinquième coffre personnel! Braquage de banque terminé !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "6 Lingot en or",   type = "item",  itemName = "lingotdor", count = 6},
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "6 Lingot en or",   type = "item",  itemName = "lingotdor", count = 6},
                            {label = "50,000$", type = "money", count = 50000},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 500000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage de la Banque de Paleto Bay"] = {
            startPos = vector3(-108.72262573242, 6464.6684570312, 31.639513015747), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 8, 

            copsNeeded = 6,
            itemNeeded = "bankpaleto",
            itemLabelNeeded = "Clef du générateur de Paleto Bay",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la Banque de Paleto Bay",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Porte du coffre-fort",
                    pos = vector3(-102.28736877441, 6463.1884765625, 31.634140014648), 
                    heading = 228.3443,
                    minigame = "fingerprint",
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Vous avez hacker la porte de la banque ! Dirigez-vous vers l'intérieur et continuez votre braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    doors = {
                        {
                            objName = -2050208642,
                            objYaw = 225.2469,
                            objNewHeading = 45.2469,
                            objCoords = vector3(-100.24186706543, 6464.5493164062, 31.884603500366)
                        }
                    },
                },        
                {
                    name = "Chariot 1", 
                    pos = vector3(-98.46883392334, 6461.9340820312, 31.634122848511),
                    minigame = "typing",
                    heading = 216.5266,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "100,000$", type = "money", count = 100000},
                        },
                    },
                },
                {
                    name = "Chariot 2", 
                    pos = vector3(-98.417739868164, 6460.1801757812, 31.634136199951),
                    minigame = "typing",
                    heading = 32.1557,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième chariot!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsGettinCash = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                        },
                        vip = {
                            {label = "100,000$", type = "money", count = 100000},
                        },
                    },
                },
                {
                    name = "Coffre personnel #1",
                    pos = vector3(-96.531852722168, 6460.466796875, 31.634141921997),
                    minigame = "multipleLockpick",
                    heading = 218.7328,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du premier coffre personnel!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Code du directeur",   type = "item",  itemName = "codepaleto", count = 1},
                            {label = "30 Bijoux",   type = "item",  itemName = "jewels", count = 30},
                        },
                        vip = {
                            {label = "30 Bijoux",   type = "item",  itemName = "jewels", count = 30},
                        },
                    },
                },
                {
                    name = "Coffre personnel #2",
                    pos = vector3(-100.67153167725, 6461.251953125, 31.634147644043),
                    minigame = "multipleLockpick",
                    heading = 127.6764,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le contenu du deuxième coffre personnel! Dirigez-vous maintenant vers le bureau du directeur !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsDrilling = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                        },
                        vip = {
                            {label = "Une montre de poche antique",   type = "item",  itemName = "montredepoche", count = 1},
                        },
                    },
                },
                {
                    name = "Coffre du directeur",
                    pos = vector3(-105.76978302002, 6480.3364257812, 31.634141921997),
                    minigame = "multipleLockpick",
                    heading = 330.2835,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez terminé le braquage de la banque de Paleto Bay!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    OpenSafe = true,
                    reward = {
                        basic = {
                            {label = "1,000,000$", type = "money", count = 1000000},
                            {label = "Une émeraude",   type = "item",  itemName = "emeraude", count = 1},
                        },
                        vip = {
                            {label = "Une émeraude",   type = "item",  itemName = "emeraude", count = 1},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent de la banque", type = "money", count = 500000},
                },
                vip = {
                    {label = "Argent de la banque", type = "money", count = 50000},
                },
            },
        },
        ["Braquage de musée"] = {
            startPos = vector3(231.21713256836, -182.01968383789, 55.647678375244), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 10,

            copsNeeded = 8,
            itemNeeded = "keymuseum",
            itemLabelNeeded = "Clef du générateur du musée d'art'",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant du musée d'art'",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Tableau 1", 
                    pos = vector3(217.00692749023, -186.01489257812, 54.59),
                    minigame = "multipleLockpick",
                    heading = 62.7224,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (Le Fou Du Bus)",   type = "item",  itemName = "tableau1", count = 1},
                        },
                        vip = {
                            {label = "Tableau (Le Fou Du Bus)",   type = "item",  itemName = "tableau1", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 2", 
                    pos = vector3(203.72705078125, -181.66052246094, 54.59),
                    heading = 132.5275,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (RIP BOZO)",   type = "item",  itemName = "tableau2", count = 1},
                        },
                        vip = {
                            {label = "Tableau (RIP BOZO)",   type = "item",  itemName = "tableau2", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 3", 
                    pos = vector3(203.11982727051, -182.86911010742, 54.59),
                    minigame = "multipleLockpick",
                    heading = 356.6018,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (BOGUETTE)",   type = "item",  itemName = "tableau3", count = 1},
                        },
                        vip = {
                            {label = "Tableau (BOGUETTE)",   type = "item",  itemName = "tableau3", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 4", 
                    pos = vector3(212.8539276123, -185.21731567383, 54.59),
                    heading = 171.8181,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (Moi Je Suis Coach)",   type = "item",  itemName = "tableau4", count = 1},
                        },
                        vip = {
                            {label = "Tableau (Moi Je Suis Coach)",   type = "item",  itemName = "tableau4", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 5", 
                    pos = vector3(207.01121520996, -184.29898071289, 54.59),
                    minigame = "multipleLockpick",
                    heading = 346.2166,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (Jurassic Park78)",   type = "item",  itemName = "tableau5", count = 1},
                        },
                        vip = {
                            {label = "Tableau (Jurassic Park78)",   type = "item",  itemName = "tableau5", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 6", 
                    pos = vector3(215.36981201172, -187.3441619873, 54.59),
                    heading = 344.6568,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (La Vérité)",   type = "item",  itemName = "tableau6", count = 1},
                        },
                        vip = {
                            {label = "Tableau (La Vérité)",   type = "item",  itemName = "tableau6", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 7", 
                    pos = vector3(217.50845336914, -177.70101928711, 54.59),
                    minigame = "multipleLockpick",
                    heading = 346.1864,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (Homme De Cro-Magnonn)",   type = "item",  itemName = "tableau7", count = 1},
                        },
                        vip = {
                            {label = "Tableau (Homme De Cro-Magnonn)",   type = "item",  itemName = "tableau7", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 8", 
                    pos = vector3(226.48469543457, -186.78514099121, 54.59),
                    heading = 247.0339,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (INAFFF)",   type = "item",  itemName = "tableau8", count = 1},
                        },
                        vip = {
                            {label = "Tableau (INAFFF)",   type = "item",  itemName = "tableau8", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 9", 
                    pos = vector3(227.63446044922, -183.42935180664, 54.59),
                    minigame = "multipleLockpick",
                    heading = 251.5654,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (Propriétaire)",   type = "item",  itemName = "tableau9", count = 1},
                        },
                        vip = {
                            {label = "Tableau (Propriétaire)",   type = "item",  itemName = "tableau9", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 10", 
                    pos = vector3(220.1219329834, -190.65327453613, 54.59),
                    heading = 160.3204,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Passez au suivant!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (LOPOTICHA)",   type = "item",  itemName = "tableau10", count = 1},
                        },
                        vip = {
                            {label = "Tableau (LOPOTICHA)",   type = "item",  itemName = "tableau10", count = 1},
                        },
                    },
                },
                {
                    name = "Tableau 11", 
                    pos = vector3(202.61515808105, -179.98718261719, 54.59),
                    minigame = "multipleLockpick",
                    heading = 102.0375,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré le Tableau! Fin du Braquage!",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    TraficCables = true,
                    reward = {
                        basic = {
                            {label = "Tableau (ALÈVE ALÈVE)",   type = "item",  itemName = "tableau11", count = 1},
                        },
                        vip = {
                            {label = "Tableau (ALÈVE ALÈVE)",   type = "item",  itemName = "tableau11", count = 1},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent du musée", type = "money", count = math.random(1500000,2000000)},
                },
                vip = {
                    {label = "Argent du musée", type = "money", count = 250000},
                },
            },
        },
        ["Braquage de bijouterie"] = {
            startPos = vector3(-598.46301269531, -245.37469482422, 35.469258880615), -- point de démarrage du braquage
            dstInteract = 1.5, -- distance pour interagir

            id = 11,

            copsNeeded = 8,
            itemNeeded = "",
            itemLabelNeeded = "Clef du générateur de la bijouterie",
            copsJobs = { "police", "sheriff", "marshall" },
            playersNeeded = 0, 
            helpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour désactiver le courant de la bijouterie",
            cooldown = 1800000, 

            steps = {
                {
                    name = "Boîte de bijoux 1", 
                    pos = vector3(-625.48950195312, -232.49635314941, 38.169563293457),
                    heading = 32.25,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 2", 
                    pos = vector3(-622.80242919922, -231.1346282959, 38.169563293457),
                    heading = 33.96,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 3", 
                    pos = vector3(-620.54382324219, -229.6861114502, 38.169567108154),
                    heading = 34.51,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 4", 
                    pos = vector3(-617.93774414062, -228.15690612793, 38.16951751709),
                    heading = 30.41,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 5", 
                    pos = vector3(-616.75787353516, -233.48452758789, 38.170185089111),
                    minigame = "multipleLockpick",
                    heading = 122.2166,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 6", 
                    pos = vector3(-615.87432861328, -235.22067260742, 38.170188903809),
                    heading = 126.16,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 7", 
                    pos = vector3(-617.69122314453, -242.15226745605, 38.170192718506),
                    heading = 31.65,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 8", 
                    pos = vector3(-619.59094238281, -243.34240722656, 38.170196533203),
                    heading = 34.28,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 9", 
                    pos = vector3(-624.61737060547, -244.52671813965, 38.169570922852),
                    heading = 121.94,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 10", 
                    pos = vector3(-625.97680664062, -242.18968200684, 38.16957092285),
                    heading = 124.59,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 11", 
                    pos = vector3(-627.38421630859, -239.69667053223, 38.169551849365),
                    heading = 116.43,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 12", 
                    pos = vector3(-623.48620605469, -240.86433410645, 38.170196533203),
                    heading = 302.05,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 13", 
                    pos = vector3(-608.10046386719, -239.8950958252, 38.169555664062),
                    heading = 166.05,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 14", 
                    pos = vector3(-610.09216308594, -241.63070678711, 38.169555664062),
                    heading = 346.66,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 15", 
                    pos = vector3(-608.51745605469, -244.46893310547, 38.169555664062),
                    heading = 166.02,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 16", 
                    pos = vector3(-611.32055664062, -243.64717102051, 38.169555664062),
                    heading = 166.02,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 17", 
                    pos = vector3(-609.60906982422, -237.10209655762, 38.169555664062),
                    heading = 348.02,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 18", 
                    pos = vector3(-606.78564453125, -237.79583740234, 38.169555664062),
                    heading = 351.48,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Passez au suivant !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
                {
                    name = "Boîte de bijoux 19", 
                    pos = vector3(-606.14971923828, -241.43363952637, 38.169555664062),
                    heading = 256.39,
                    reward = true,
                    notification = function()
                        lib.notify({
                            title = 'Braquage en cours',
                            description = "Bravo ! Vous avez récupéré les bijoux ! Fin du Braquage !",
                            type = 'success',
                            position = 'top',
                            duration = 10000,
                        })
                    end,
                    IsCrackingGlass = true,
                    reward = {
                        basic = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 5},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 5},
                        },
                        vip = {
                            {label = "Diamant",   type = "item",  itemName = "diamant", count = 1},
                            {label = "Or",   type = "item",  itemName = "lingotdor", count = 1},
                        },
                    },
                },
            },
            -- récompenses globales (si tu en as besoin à la fin)
            reward = {
                basic = {
                    {label = "Argent du musée", type = "money", count = math.random(700000, 1000000)},
                },
                vip = {
                    {label = "Argent du musée", type = "money", count = 500000},
                },
            },
        },
    },
}

cfg_robberys.resetLocks = function(robId)
    for k, v in pairs(cfg_robberys["list"]) do
        if v.id == robId then
            if #v.steps > 0 then
                for i, step in pairs(v.steps) do
                    step.locked = true
                    step.done = false
                end
            end
        end
    end
end

cfg_robberys.resetLocksDoors = function(robId)
    for k, v in pairs(cfg_robberys["list"]) do
        if v.id == robId then
            if #v.steps > 0 then
                for i, step in pairs(v.steps) do
                    step.locked = true
                    step.done = false
                    if step.doors then
                        for _, doorData in pairs(step.doors) do
                            local doorEntity = GetClosestObjectOfType(
                                doorData.objCoords.x,
                                doorData.objCoords.y,
                                doorData.objCoords.z,
                                1.0,
                                doorData.objName,
                                false, false, false
                            )
                            if doorEntity then
                                SetEntityHeading(doorEntity, doorData.objYaw)
                            end
                        end
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    local count = 0
    for k,v in pairs(cfg_robberys["list"]) do
        count = count + 1

        if not v.playersNeeded then
            v.playersNeeded = 0
        end

        if not v.copsNeeded then
            v.copsNeeded = 0
        end

        if #v.steps > 0 then
            for i,l in pairs(v.steps) do
                l.locked = true   -- On le lock par défaut
                l.done   = false  -- Marqueur : pas encore effectué
                l.isReward = (l.reward ~= nil) -- True si c'est un coffre/reward
            end
        end
    end
end)

function IsDrilling()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local prop_name = 'hei_prop_heist_drill'
    local boneIndex = GetPedBoneIndex(playerPed, 57005)

    TriggerEvent("sound:play", "drill", 0.5)

    RequestAnimDict('anim@heists@fleeca_bank@drilling')
    RequestModel(GetHashKey(prop_name))

    while not HasAnimDictLoaded('anim@heists@fleeca_bank@drilling') or not HasModelLoaded(GetHashKey(prop_name)) do
        Citizen.Wait(100)
    end

    PlaySoundFrontend(-1, "Drill", "Bank_Heist_Sounds", 0)

    local prop = CreateObject(GetHashKey(prop_name), coords.x, coords.y, coords.z, true, true, true)
    AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.0, -0.05, 100.0, 280.0, 180.0, true, true, false, true, 1, true)

    TaskPlayAnim(playerPed, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Nettoyage après l'animation
    StopAnimTask(playerPed, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 1.0)
    DeleteObject(prop)
    RemoveAnimDict('anim@heists@fleeca_bank@drilling')
    SetModelAsNoLongerNeeded(GetHashKey(prop_name))
end

function IsGettinCash()
    local playerPed = PlayerPedId()
    local animDict = 'anim@heists@ornate_bank@grab_cash_heels'
    local animName = 'grab'

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(50)
    end

    if HasAnimDictLoaded(animDict) then
        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    end
end

function IsCrackingGlass()
    local playerPed = PlayerPedId()
    local animDict = 'missheist_jewel'
    local animName = 'smash_case'

    PlaySoundFrontend(-1, "Glass_Smash", "", 0)

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(50)
    end

    if HasAnimDictLoaded(animDict) then
        TaskPlayAnim(playerPed, animDict, animName, 3.0, 1.0, -1, 2, 0, false, false, false)
    end
end

function TraficCables()
    local playerPed = PlayerPedId()
    local animDict = 'amb@prop_human_movie_bulb@base'
    local animName = 'base'

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(50)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

    Citizen.Wait(5000)

    ClearPedTasks(playerPed)
end

function OpenSafe()
    local playerPed = GetPlayerPed(-1)

    RequestAnimDict('mini@safe_cracking')

    while not HasAnimDictLoaded('mini@safe_cracking') do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, 'mini@safe_cracking', 'idle_base', 8.0, -8.0, -1, 32, 0, false, false, false)

    Citizen.Wait(15000)

    ClearPedTasks(playerPed)
end

function CablesDown()
    local playerPed = PlayerPedId()
    local animDict = 'mini@repair'
    local animName = 'fixing_a_ped'

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(50)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

    Citizen.Wait(20000)

    ClearPedTasks(playerPed)
end

RegisterCommand("paps_cmd0", function()
    CablesDown()
end)

RegisterCommand("paps_cmd1", function()
    IsCrackingGlass()
end)

RegisterCommand("paps_cmd2", function()
    TraficCables()
end)

RegisterCommand("paps_cmd3", function()
    IsGettinCash()
end)

RegisterCommand("paps_cmd4", function()
    IsDrilling()
end)

RegisterCommand("paps_cmd5", function()
    OpenSafe()
end)