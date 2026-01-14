jobs = {
     {
          metier = "ltdsud",
          metierLabel = "LTD Sud",

          shop = {
               enabled = true,

               pos = vector3(239.81860351562, -897.27490234375, 28.723195648193),

               items = {
                    {name = "Graine (Purple)", item = "weed_pot_purp", price = 140000},
                    {name = "Graine (Blue)", item = "weed_pot_blu", price = 55000},
                    {name = "Graine (Green)", item = "weed_pot_green", price = 25000},
                    {name = "Arrosoir", item = "watering_can", price = 20000},
                    {name = "Wrap", item = "wrap", price = 2000},
                    {name = "Wrap", item = "wrap", price = 2000},
                    {name = "Sandwich Thon", item = "thonsand", price = 50},
                    {name = "Sandwich Poulet", item = "poulsand", price = 50},
                    {name = "Sandwich Saumon", item = "saumsand", price = 50},
                    {name = "Eau", item = "eau", price = 30},
                    {name = "Chips", item = "chips", price = 30},
                    {name = "Cola", item = "coca", price = 30},
                    {name = "Barre de chocolat", item = "chocolat", price = 30},
                    {name = "Glace", item = "glace", price = 30},
                    {name = "Donut", item = "donut", price = 30},
                    {name = "Nouilles", item = "nouilles", price = 30},
                    {name = "Canne à pêche", item = "canne", price = 1000},
                    {name = "Appât", item = "appat", price = 100},
                    {name = "Téléphone", item = "classic_phone", price = 500},
                    {name = "Radio", item = "radio", price = 1000},
                    {name = "Voiture téléguidée", item = "rc", price = 8000},
                    {name = "Rollers", item = "roller", price = 1500},
                    {name = "Gants", item = "gants", price = 1500},
                    {name = "Chaise verte", item = "chaiseverte", price = 750},
                    {name = "Chaise bleue", item = "chaisebleue", price = 750},
                    {name = "Tenue de plongée", item = "plongee", price = 2000},
                    {name = "Jumelles", item = "jumelles", price = 1000},
                    {name = "Parachute", item = "parachute", price = 2000},
                    {name = "Feu d'artifice starburst", item = "starburst", price = 5000},
                    {name = "Feu d'artifice shotburst", item = "shotburst", price = 5000},
                    {name = "Feu d'artifice fountain", item = "fountain", price = 5000},
                    {name = "Feu d'artifice trailburst", item = "trailburst", price = 5000},
                    {name = "Coyote", item = "coyote", price = 2000},
                    {name = "Brouilleur", item = "brouilleur", price = 5000},
                    {name = "Drone", item = "drone", price = 10000},
                    {name = "Corde", item = "corde", price = 200},
                    {name = "BMX", item = "bmx", price = 1000},
                    {name = "Skateboard", item = "skateboard", price = 1500},
                    {name = "Puff", item = "puff", price = 500},
                    {name = "Bidon d'essence", item = "WEAPON_PETROLCAN", price = 1000},
                    {name = "Ciseau", item = "ciseaux", price = 500},
                    {name = "Ticket à gratter", item = "scratch_ticket", price = 25000},
                    {name = "Bombe peinture commune", item = "bombepeinture", price = 250000},
                    {name = "Bombe peinture rare", item = "bombepeinturerare", price = 700000},
                    {name = "Jacuzzi", item = "jacuzzi", price = 250000},
                    {name = "Paquet de clopes", item = "paquet_clopes", price = 15000},
                    {name = "Éponge", item = "sponge", price = 1000},
                    {name = "Trousse de make-up", item = "makeup_box", price = 25000},
                    {name = "Tablette", item = "tablet", price = 100000},
                    {name = "Bonbons", item = "bonbons", price = 50},
                    {name = "Gâteau", item = "gateau", price = 60},
                    {name = "Chocolat chaud", item = "chocolatchaud", price = 70},
                    {name = "Thé chaud", item = "the", price = 80},
               },
          },

          craft = {
               enabled = false,

               pos = vector3(24.741363525391, -1339.2445068359, 29.497024536133),

               items = {},
          },

          bar_on = false,
          bar = {
               coords = vector3(-1376.3955078125, -600.92999267578, 29.316672897339),
               items = {},
          },

          grill_on = false,
          grill = {
               coords = vector3(-1404.019, -599.5892, 29.41997),
               items = {},
          },

          coffre_on = true,
          coffre_coords = vector3(246.86413574219, -900.70373535156, 28.723210906982),

          vestiaire_on = true,
          vestiaire_coords = vector3(244.53416442871, -916.18328857422, 28.394170379639),

          bossmenu_on = true,
          bossmenu_coords = vector3(244.35751342773, -905.92736816406, 28.723210906982),

          blips_on = true,
          blips = {
               coords = vector3(239.74443054199, -903.59149169922, 29.622840881348),
               colorBase = "~o~",
               colorBlip = 27,
               blipSprite = 52,
          },

          colorBase = "~y~",

          garage_on = true,
          garage = {
               vehicles = {
                    "nspeedo",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(224.64538574219, -921.93096923828, 28.639821624756),
               garage_spawn = {
                    {pos = vector3(224.7954864502, -915.46197509766, 29.564479827881), heading = 341.38,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(226.80133056641, -911.39752197266, 28.658559417725),

          message = {
               openingMessage = "Le LTD Sud est ouvert !",
               closingMessage = "Le LTD Sud est fermé !",
               recruitMessage = "Le LTD Sud recrute, venez postuler sur place !",
               name = "LTD Sud",
               char = "CHAR_LTD",
          },
     },
     {
          metier = "ltdnord",
          metierLabel = "LTD Davis",

          shop = {
               enabled = true,

               pos = vector3(-47.116653442383, -1758.8721923828, 28.521005249023),

               items = {
                    {name = "Graine (Purple)", item = "weed_pot_purp", price = 140000},
                    {name = "Graine (Blue)", item = "weed_pot_blu", price = 55000},
                    {name = "Graine (Green)", item = "weed_pot_green", price = 25000},
                    {name = "Arrosoir", item = "watering_can", price = 20000},                    
                    {name = "Sandwich Thon", item = "thonsand", price = 50},
                    {name = "Sandwich Poulet", item = "poulsand", price = 50},
                    {name = "Sandwich Saumon", item = "saumsand", price = 50},
                    {name = "Eau", item = "eau", price = 30},
                    {name = "Chips", item = "chips", price = 30},
                    {name = "Cola", item = "coca", price = 30},
                    {name = "Barre de chocolat", item = "chocolat", price = 30},
                    {name = "Glace", item = "glace", price = 30},
                    {name = "Donut", item = "donut", price = 30},
                    {name = "Nouilles", item = "nouilles", price = 30},
                    {name = "Canne à pêche", item = "canne", price = 1000},
                    {name = "Appât", item = "appat", price = 100},
                    {name = "Téléphone", item = "classic_phone", price = 500},
                    {name = "Radio", item = "radio", price = 1000},
                    {name = "Voiture téléguidée", item = "rc", price = 8000},
                    {name = "Rollers", item = "roller", price = 1500},
                    {name = "Gants", item = "gants", price = 1500},
                    {name = "Chaise verte", item = "chaiseverte", price = 750},
                    {name = "Chaise bleue", item = "chaisebleue", price = 750},
                    {name = "Tenue de plongée", item = "plongee", price = 2000},
                    {name = "Jumelles", item = "jumelles", price = 1000},
                    {name = "Parachute", item = "parachute", price = 2000},
                    {name = "Feu d'artifice starburst", item = "starburst", price = 5000},
                    {name = "Feu d'artifice shotburst", item = "shotburst", price = 5000},
                    {name = "Feu d'artifice fountain", item = "fountain", price = 5000},
                    {name = "Feu d'artifice trailburst", item = "trailburst", price = 5000},
                    {name = "Spray", item = "spray", price = 5000},
                    {name = "Dissolvant", item = "spray_remover", price = 1000},
                    {name = "Coyote", item = "coyote", price = 2000},
                    {name = "Brouilleur", item = "brouilleur", price = 5000},
                    {name = "Drone", item = "drone", price = 10000},
                    {name = "Corde", item = "corde", price = 200},
                    {name = "BMX", item = "bmx", price = 1000},
                    {name = "Skateboard", item = "skateboard", price = 1500},
                    {name = "Puff", item = "puff", price = 500},
                    {name = "Bidon d'essence", item = "WEAPON_PETROLCAN", price = 1000},
                    {name = "Ciseau", item = "ciseaux", price = 500},
                    {name = "Ticket à gratter", item = "scratch_ticket", price = 25000},
                    {name = "Bombe peinture commune", item = "bombepeinture", price = 250000},
                    {name = "Bombe peinture rare", item = "bombepeinturerare", price = 700000},
                    {name = "Jacuzzi", item = "jacuzzi", price = 250000},
                    {name = "Paquet de clopes", item = "paquet_clopes", price = 15000},
                    {name = "Éponge", item = "sponge", price = 1000},
                    {name = "Trousse de make-up", item = "makeup_box", price = 25000},
                    {name = "Wrap au poulet", item = "wrap", price = 3000},
               },
          },

          craft = {
               enabled = false,

               pos = vector3(24.741363525391, -1339.2445068359, 29.497024536133),

               items = {},
          },

          bar_on = false,
          bar = {
               coords = vector3(-1376.3955078125, -600.92999267578, 29.316672897339),
               items = {},
          },

          grill_on = false,
          grill = {
               coords = vector3(-1404.019, -599.5892, 29.41997),
               items = {},
          },

          coffre_on = true,
          coffre_coords = vector3(-40.068950653076, -1751.8057861328, 28.521031951904),

          vestiaire_on = true,
          vestiaire_coords = vector3(-40.869876861572, -1747.7679443359, 28.419555282593),

          bossmenu_on = true,
          bossmenu_coords = vector3(-44.027618408203, -1749.1673583984, 28.521039581299),

          blips_on = true,
          blips = {
               coords = vector3(-44.027618408203, -1749.1673583984, 28.521039581299),
               colorBase = "~o~",
               colorBlip = 27,
               blipSprite = 52,
          },

          colorBase = "~y~",

          garage_on = true,
          garage = {
               vehicles = {
                    "nspeedo",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-46.146060943604, -1761.6727294922, 28.546662902832),
               garage_spawn = {
                    {pos = vector3(-63.962226867676, -1752.6258544922, 29.35205078125), heading = 49.06,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-57.158325195312, -1743.1477050781, 28.453221893311),

          message = {
               openingMessage = "Le LTD Davis est ouvert !",
               closingMessage = "Le LTD Davis est fermé !",
               recruitMessage = "Le LTD Davis recrute, venez postuler sur place !",
               name = "LTD Davis",
               char = "CHAR_LTD",
          },
     },
     {
          metier = "unicorn",
          metierLabel = "Vanille Unicorn",

          bar_on = true,
          bar = {
               coords = vector3(112.4285, -1282.081, 28.70883),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Limonade", item = "limonade"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(108.27220153809, -1282.4359130859, 28.718829727173),
               items = {
                    {name = "Crêpe Chocolat", item = "crepe"},
                    {name = "Lasagne", item = "lasagne"},
                    {name = "Quiche", item = "quiche"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(98.8951, -1286.813, 28.30894),

          vestiaire_on = true,
          vestiaire_coords = vector3(100.1794, -1302.3, 28.30894),

          bossmenu_on = true,
          bossmenu_coords = vector3(98.51255, -1297.716, 34.70487),

          blips_on = true,
          blips = {
               coords = vector3(98.51255, -1297.716, 34.70487),
               colorBase = "~p~",
               colorBlip = 8,
               blipSprite = 279,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(92.65247, -1287.806, 28.30894),
               garage_spawn = {
                    {pos = vector3(83.24092, -1281.563, 29.19092), heading = 280.84,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(83.24092, -1281.563, 28.30092),

          message = {
               openingMessage = "Le Vanille Unicorn est ouvert, laissez vous tenter !",
               closingMessage = "Le Vanille Unicorn est fermé !",
               recruitMessage = "Le Vanille Unicorn recrute, venez postuler sur place !",
               name = "Unicorn",
               char = "CHAR_MP_STRIPCLUB_PR",
          },
     },
     --{
     --     metier = "pizzeria",
     --     metierLabel = "Pizzeria",
--
     --     bar_on = true,
     --     bar = {
     --          coords = vector3(813.48, -749.3794, 25.85082),
     --          items = {
     --               {name = "Ice Tea", item = "icetea"},
     --               {name = "Coca", item = "coca"},
     --               {name = "Eau", item = "eau"},
     --          },
     --     },
--
     --     grill_on = true,
     --     grill = {
     --          coords = vector3(807.4544, -760.1852, 25.85085),
     --          items = {
     --               {name = "Pizza 4 fromages", item = "pizzamarguerita"},
     --               {name = "Pizza Pepperoni", item = "pizzapepperoni"},
     --               {name = "Pizza Vegetarienne", item = "pizzavegetarienne"},
     --               {name = "Pizza Mexicaine", item = "pizzamexicaine"},
     --               {name = "Pizza Orientale", item = "pizzaorientale"},
     --               {name = "Pates carbo", item = "patecarbo"},
     --               {name = "Tiramisu", item = "tiramisu"},
     --          },
     --     },
--
     --     coffre_on = true,
     --     coffre_coords = vector3(802.8146, -758.6219, 25.85087),
--
     --     vestiaire_on = true,
     --     vestiaire_coords = vector3(809.9489, -761.8751, 30.3559),
--
     --     bossmenu_on = true,
     --     bossmenu_coords = vector3(796.7482, -750.2021, 30.35589),
--
     --     blips_on = true,
     --     blips = {
     --          coords = vector3(796.7482, -750.2021, 31.26589),
     --          colorBase = "~y~",
     --          colorBlip = 2,
     --          blipSprite = 267,
     --     },
--
     --     colorBase = "~y~",
--
     --     garage_on = true,
     --     garage = {
     --          vehicles = {
     --               "gbvoyagerb",
     --               "pounder",
     --               "youga3",
     --               "taco",
     --          },
     --          xenon = true,
     --          fullCustom = true,
     --          color1 = 1,
     --          color2 = 1,
     --          garage_coords = vector3(792.19799804688, -732.89739990234, 26.719920730591),
     --          garage_spawn = {
     --               {pos = vector3(807.8054, -729.8575, 26.65771), heading = 133.71,},
     --          },
     --     },
--
     --     ranger_on = true,
     --     ranger_coords = vector3(807.8054, -729.8575, 26.65771),
--
     --     message = {
     --          openingMessage = "La Pizzeria est ouverte, venez manger !",
     --          closingMessage = "La Pizzeria est fermé !",
     --          recruitMessage = "Le Pizzeria recrute, venez postuler sur place !",
     --          name = "La Pizzeria",
     --          char = "CHAR_PIZZERIA",
     --     },
     --},
     --{
     --     metier = "kebab",
     --     metierLabel = "Turko Kebab",
--
     --     bar_on = true,
     --     bar = {
     --          coords = vector3(291.5071105957, -975.98156738281, 28.518560028076),
     --          items = {
     --               {name = "Ayran", item = "ayran"},
     --               {name = "Thé", item = "the"},
     --               {name = "Cola", item = "coca"},
     --          },
     --     },
--
     --     grill_on = true,
     --     grill = {
     --          coords = vector3(291.61889648438, -971.22888183594, 28.518560028076),
     --          items = {
     --               {name = "Sandwich Kebab", item = "sandkebab"},
     --               {name = "Assiette Kebab", item = "assiettekebab"},
     --               {name = "Adana Kebab", item = "adana"},
     --               {name = "Sandwich Falafel", item = "sandfalafel"},
     --               {name = "Pidé", item = "pide"},
     --          },
     --     },
--
     --     coffre_on = true,
     --     coffre_coords = vector3(345.80319213867, -977.90319824219, 28.477477645874),
--
     --     vestiaire_on = true,
     --     vestiaire_coords = vector3(298.73977661133, -977.0908203125, 28.518560028076),
--
     --     bossmenu_on = true,
     --     bossmenu_coords = vector3(312.12353515625, -1005.0336914062, 28.412717437744),
--
     --     blips_on = true,
     --     blips = {
     --          coords = vector3(294.15856933594, -978.20043945312, 28.518579101562),
     --          colorBase = "~o~",
     --          colorBlip = 50,
     --          blipSprite = 674,
     --     },
--
     --     colorBase = "~o~",
--
     --     garage_on = true,
     --     garage = {
     --          vehicles = {
     --               "gbvoyagerb",
     --               "nspeedo",
     --          },
     --          xenon = true,
     --          fullCustom = true,
     --          color1 = 1,
     --          color2 = 1,
     --          garage_coords = vector3(346.13864135742, -966.33880615234, 28.528918838501),
     --          garage_spawn = {
     --               {pos = vector3(347.8835144043, -960.38049316406, 29.431667327881), heading = 1.77,},
     --          },
     --     },
--
     --     ranger_on = true,
     --     ranger_coords = vector3(348.3115234375, -962.33856201172, 28.531667327881),
--
     --     message = {
     --          openingMessage = "Le Kebab est ouvert, venez manger !",
     --          closingMessage = "Le Kebab est fermé !",
     --          recruitMessage = "Le Kebab recrute, venez postuler sur place !",
     --          name = "Turko Kebab",
     --          char = "CHAR_KEBAB",
     --     },
     --},
     {
          metier = "burgershot",
          metierLabel = "Burger Shot",

          bar_on = true,
          bar = {
               coords = vector3(-808.61352539062, -441.46704101562, 41.207971191406),
               items = {
                    {name = "Ice Tea", item = "icetea"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Jus d'orange pétillant", item = "jus_orange_petillant"},
                    {name = "Mazout", item = "mazout"},
                    {name = "Milkshake", item = "milkshake"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-813.57568359375, -447.28067016602, 41.207971191406),
               items = {
                    {name = "Menu Burger", item = "menuburger"},
                    {name = "Menu Burger XL", item = "menuburgerxl"},
                    {name = "Menu Enfant", item = "menuenfant"},
                    {name = "Menu Végé", item = "menuvege"},
                    {name = "Frites", item = "frites"},
                    {name = "Fricadelle", item = "fricadelle"},
                    {name = "Tenders", item = "tenders"},
                    {name = "Salade", item = "salade"},
                    {name = "Sundae Chocolat", item = "sundae_chocolat"},
                    {name = "Sundae Caramel", item = "sundae_caramel"},
                    {name = "Sundae Fraise", item = "sundae_fraise"},
                    {name = "Granita", item = "granita"},
                    {name = "Salade de fruits", item = "saladefruits"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-804.11010742188, -447.67556762695, 41.207955932617),

          vestiaire_on = true,
          vestiaire_coords = vector3(-802.63415527344, -435.34222412109, 41.207971191406),

          bossmenu_on = true,
          bossmenu_coords = vector3(-797.88494873047, -443.51275634766, 41.207971191406),

          blips_on = true,
          blips = {
               coords = vector3(-797.88494873047, -443.51275634766, 41.207971191406),
               colorBase = "~y~",
               colorBlip = 1,
               blipSprite = 106,
          },

          colorBase = "~y~",

          garage_on = true,
          garage = {
               vehicles = {
                    "hvburger1",
                    "hvburger",
                    "stalion2",
                    "nspeedo",
                    "gbboxboyft",
                    "trager",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-833.78637695312, -417.45693969727, 35.868268585205),
               garage_spawn = {
                    {pos = vector3(-825.36175537109, -406.21643066406, 36.640296936035), heading = 295.52853393555,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-824.15277099609, -405.60583496094, 35.740869140625),

          message = {
               openingMessage = "Le Burger Shot est ouvert, venez manger !",
               closingMessage = "Le Burger Shot est fermé !",
               name = "Burger Shot",
               char = "CHAR_BURGERSHOT",
          },
     },
     {
          metier = "beachclub",
          metierLabel = "Beach Club",

          bar_on = true,
          bar = {
               coords = vector3(-2057.3811035156, -549.45062255859, 9.9573179245),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "tapas", item = "tapas"},
                    {name = "chips", item = "chips"},
               },
          },

          grill_on = false,
          grill = {
               coords = vector3(-2054.7763671875, -547.73016357422, 9.9573179245),
               items = {
                    {name = "tapas", item = "tapas"},
                    {name = "chips", item = "chips"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-2053.7583007812, -544.71185302734, 9.957315063477),

          vestiaire_on = true,
          vestiaire_coords = vector3(-2043.7298583984, -547.04040527344, 9.9573179245),

          bossmenu_on = true,
          bossmenu_coords = vector3(-2053.2663574219, -536.01672363281, 9.957315063477),

          blips_on = true,
          blips = {
               coords = vector3(-2038.4075927734, -531.52996826172, 9.945488548279),
               colorBase = "~p~",
               colorBlip = 48,
               blipSprite = 836,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
                    "tourbus",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-2029.1459960938, -496.55178833008, 10.770776367188),
               garage_spawn = {
                    {pos = vector3(-2023.7678222656, -487.56283569336, 11.699734687805), heading = 318.19,},
                    {pos = vector3(-2026.1680908203, -485.65277099609, 11.699123382568), heading = 314.41,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-2017.4086914062, -492.69958496094, 10.789960479736),

          message = {
               openingMessage = "Le Beach Club est ouvert, lâchez prise et venez vous amuser !",
               closingMessage = "Le Beach Club est fermé !",
               recruitMessage = "Le Beach Club recrute, venez postuler sur place !",
               name = "Beach Club",
               char = "CHAR_BEACHCLUB",
          },
     },
     {
          metier = "uwu",
          metierLabel = "Uwu Café",

          bar_on = true,
          bar = {
               coords = vector3(-586.28985595703, -1061.6038818359, 21.444192504883),
               items = {
                    {name = "Bubbletea", item = "bubbletea"},
                    {name = "Latte Fraise", item = "lattefraise"},
                    {name = "Latte Matcha", item = "lattematcha"},
                    {name = "Limonade Japonaise", item = "limonadejaponaise"},
                    {name = "Eau", item = "eau"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-590.25207519531, -1057.0179443359, 21.456174468994),
               items = {
                    {name = "Cake Japonais", item = "cakejaponais"},
                    {name = "Croffle", item = "croffle"},
                    {name = "Pancakes", item = "pancakes"},
                    {name = "Mochi", item = "mochi"},
                    {name = "Tangulu", item = "tangulu"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-585.68054199219, -1055.9235839844, 21.444192504883),

          vestiaire_on = true,
          vestiaire_coords = vector3(-586.57836914062, -1049.8748779297, 21.444175338745),

          bossmenu_on = true,
          bossmenu_coords = vector3(-577.29119873047, -1067.6942138672, 25.714051818848),

          blips_on = true,
          blips = {
               coords = vector3(-577.29119873047, -1067.6942138672, 26.614051818848),
               colorBase = "~p~",
               colorBlip = 34,
               blipSprite = 489,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
                    "tourbus",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-599.02282714844, -1055.560546875, 21.444198226929),
               garage_spawn = {
                    {pos = vector3(-597.45434570312, -1059.2464599609, 22.344202041626), heading = 91.20,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-620.72698974609, -1062.3624267578, 20.888326263428),

          message = {
               openingMessage = "Le Uwu Café est ouvert, il est temps de faire une pause gourmande !",
               closingMessage = "Le Uwu Café est fermé !",
               recruitMessage = "Le Uwu Café recrute, venez postuler sur place !",
               name = "Uwu Café",
               char = "CHAR_UWU",
          },
     },
     {
          metier = "thelostbar",
          metierLabel = "The Lost Bar",

          bar_on = true,
          bar = {
               coords = vector3(1950.5417480469, 4630.4731445312, 39.86305770874),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "tapas", item = "tapas"},
                    {name = "chips", item = "chips"},
               },
          },

          grill_on = false,
          grill = {
               coords = vector3(-2054.7763671875, -547.73016357422, 9.9573179245),
               items = {
                    {name = "tapas", item = "tapas"},
                    {name = "chips", item = "chips"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(1946.0776367188, 4629.4077148438, 39.863103485107),

          vestiaire_on = true,
          vestiaire_coords = vector3(1960.8924560547, 4641.99609375, 39.744065856934),

          bossmenu_on = true,
          bossmenu_coords = vector3(1965.4877929688, 4643.5102539062, 39.731832122803),

          blips_on = true,
          blips = {
               coords = vector3(1965.4877929688, 4643.5102539062, 39.731832122803),
               colorBase = "~p~",
               colorBlip = 48,
               blipSprite = 836,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
                    "tourbus",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(1970.9739990234, 4634.314453125, 39.880586242676),
               garage_spawn = {
                    {pos = vector3(1967.7308349609, 4627.505859375, 40.603080749512), heading = 111.26,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(1967.0574951172, 4631.4360351562, 39.693685150146),

          message = {
               openingMessage = "Le Beach Club est ouvert, lâchez prise et venez vous amuser !",
               closingMessage = "Le Beach Club est fermé !",
               recruitMessage = "Le Beach Club recrute, venez postuler sur place !",
               name = "Beach Club",
               char = "CHAR_BEACHCLUB",
          },
     },
     --{
     --     metier = "alamo",
     --     metierLabel = "Alamo",
--
     --     bar_on = true,
     --     bar = {
     --          coords = vector3(234.42665100098, 3994.7365722656, 49.25161895752),
     --          items = {
     --               {name = "Rhum", item = "rhum"},
     --               {name = "Vin", item = "vine"},
     --               {name = "Bière", item = "biere"},
     --               {name = "Vodka", item = "vodka"},
     --               {name = "Whisky", item = "whisky"},
     --               {name = "Gin", item = "gin"},
     --               {name = "Café", item = "cafe"},
     --               {name = "Coca", item = "coca"},
     --               {name = "Eau", item = "eau"},
     --               {name = "tapas", item = "tapas"},
     --               {name = "chips", item = "chips"},
     --          },
     --     },
--
     --     grill_on = true,
     --     grill = {
     --          coords = vector3(224.66213989258, 3998.8337402344, 54.864404296875),
     --          items = {
     --               {name = "tapas", item = "tapas"},
     --               {name = "chips", item = "chips"},
     --          },
     --     },
--
     --     coffre_on = true,
     --     coffre_coords = vector3(231.35269165039, 3998.2138671875, 49.251622772217),
--
     --     vestiaire_on = true,
     --     vestiaire_coords = vector3(210.43600463867, 3984.6022949219, 49.024209594727),
--
     --     bossmenu_on = true,
     --     bossmenu_coords = vector3(256.25149536133, 3998.6923828125, 49.024209594727),
--
     --     blips_on = true,
     --     blips = {
     --          coords = vector3(233.07148742676, 3996.0036621094, 54.330365753174),
     --          colorBase = "~o~",
     --          colorBlip = 48,
     --          blipSprite = 836,
     --     },
--
     --     colorBase = "~o~",
--
     --     garage_on = true,
     --     garage = {
     --          vehicles = {
     --               "pbus2",
     --               "vstretch",
     --               "patriot2",
     --               "stretch",
     --               "tourbus",
     --          },
     --          xenon = true,
     --          fullCustom = true,
     --          color1 = 1,
     --          color2 = 1,
     --          garage_coords = vector3(232.04856872559, 4041.9208984375, 49.026948547363),
     --          garage_spawn = {
     --               {pos = vector3(232.27610778809, 4048.8383789062, 49.812976837158), heading = 356.97256469727,},
     --          },
     --     },
--
     --     ranger_on = true,
     --     ranger_coords = vector3(-2017.4086914062, -492.69958496094, 10.789960479736),
--
     --     message = {
     --          openingMessage = "Le Alamo Club est ouvert, lâchez prise et venez vous amuser !",
     --          closingMessage = "Le Alamo Club est fermé !",
     --          recruitMessage = "Le Alamo Club recrute, venez postuler sur place !",
     --          name = "Alamo Club",
     --          char = "CHAR_ALAMO",
     --     },
     --},
}