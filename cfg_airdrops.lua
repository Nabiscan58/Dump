ConfigAirdrop = {}
math.randomseed(GetGameTimer())

ConfigAirdrop.DropDownTime = 2 * 60 * 1000 -- 2 hours if you want change minute use this "minute * 60 * 1000"
ConfigAirdrop.DropWaitTime = 60 -- If drop come to ground how many seconds wait for open

ConfigAirdrop.PlayersCheck = false -- If you want check players count
ConfigAirdrop.HowPlayers = 30 -- How many players need for drop

ConfigAirdrop.CaseProp = "ex_prop_adv_case_sm" -- Case prop
ConfigAirdrop.ParachuteProp = "p_cargo_chute_s" -- Parachute prop
ConfigAirdrop.Coords = { 
    {x = -2230.9372558594, y = 2418.3537597656, z = 11.176334381104},
    {x = 3899.4807128906, y = -4715.5209960938, z = 5.5947694778442},
    {x = -307.73977661133, y = 3791.4096679688, z =  66.658248901367},
    {x = 2952.1948242188, y = 2788.6513671875, z =  41.490547180176},
    {x = 1876.3460693359, y = 287.04742431641, z =  164.30520629883},
    {x = 2826.71484375, y = -640.30584716797, z =  1.910525560379},
}

ConfigAirdrop.DropComingMessage = { -- If you want change message change this
    {"Dans 10 minutes,"},
    {"un airdrop est en train d'arriver"}
}

ConfigAirdrop.DropCome = { -- If you want change message change this
    ["title"] = "AirDrop",
    ["msg"] = "Un AirDrop est arrivé !",
    ["showSeconds"] = 5
}

--The ratios of the items entered here should be equal to totalrarity.
ConfigAirdrop.GiveDropItemsCount = 1 -- How many items give to player
ConfigAirdrop.Items = { -- Items
    ["item"] = {
        ["WEAPON_ASSAULTRIFLE"] = 0.80,
        ["WEAPON_PISTOL"] = 0.50,
        ["WEAPON_COMPACTRIFLE"] = 0.30,
        ["WEAPON_ADVANCEDRIFLE"] = 0.20,
        ["WEAPON_MINISMG"] = 0.05,
        ["WEAPON_MICROSMG"] = 0.05,
        ["WEAPON_COMBATPDW"] = 0.05,
    },
}

ConfigAirdrop.TotalRarity = 2 -- Total rarity of items