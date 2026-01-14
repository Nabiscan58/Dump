ConfigSit = {}

-- Debugmodes
ConfigSit.Debugmode = false -- General debugging, shows what seats/beds you can sit/lay on and the direction you will be facing, also enables debugging commands.
ConfigSit.DebugPoly = false -- This is not advised unless you have set your PolyZone script set to only render polys nearby

-- Weather or not to use GTA's default notifiaction system, it will otherwise use mythic notify (can be changed)
ConfigSit.UseNativeNotifiactions = true

-- Teleport to the last position before getting seated when we found no way to get to the seat
ConfigSit.TeleportToLastPosWhenNoRoute = false

-- Always teleport in/out of the seat
ConfigSit.AlwaysTeleportToSeat = false
ConfigSit.AlwaysTeleportOutOfSeat = false

-- Tthe interaction and detection distance, used for max distance the 3rd eye can see and how far the /sit command will look for entites.
ConfigSit.MaxInteractionDist = 1.8
ConfigSit.MaxDetectionDist = 3.0

-- The maximum amount of tilt a object can have before it is rendered unsuitable to sit on
ConfigSit.MaxTilt = 20.0

-- Default keys/buttons
ConfigSit.DefaultKey = 'X'
ConfigSit.DefaultPadAnalogButton = 'RRIGHT_INDEX'

-- Whether or not to add chat suggestion.
ConfigSit.AddChatSuggestions = false

-- Whether or not trigger an reduce stress event/export when sitting/laying down. You wil have to add a event/export yourself for this to work.
ConfigSit.ReduceStress = false

-- The targeting solution (3rd eye) to use.
-- false       = don't use any targeting solution. 
-- 'qb-target' = qb-target by BerkieBb and its many other contributors. (https://github.com/BerkieBb/qb-target)
-- 'qtarget'   = qTarget by Linden (thelindat), Noms (OfficialNoms) and its many other contributors. (https://github.com/overextended/qtarget)
ConfigSit.Target = false

-- Use the coords of where the 3rd eye intersects with the object to find the closest seat. If set to false the coords of the player ped will be used instead.
ConfigSit.UseTargetingCoords = true

-- These are the icons/labels if we use a targeting solution.
ConfigSit.Targeting = {
    SitIcon = "fas fa-chair",
    LayIcon = "fas fa-bed",
    SitLabel = "S'assoir",
    LayLabel = "Se coucher",
}

-- The localization for the notifications, chat suggestions and keymapping.
ConfigSit.Lang = {
    -- Notifications
    Occupied = "~r~Cette place est déja occupée !",
    OccupiedLay = "~r~Vous ne pouvez pas vous coucher ici !",
	NoAvailable = "~r~Aucune chaise autour !",
	NoFound = "~r~Aucune place autour !",
    NoBedFound = "~r~Aucun lit autour !",
    TooTilted = "~r~Cette place est trop inclinée !",
    CannotReachSeat = "~r~Vous ne pouvez pas atteindre cette chaise !",
    CannotReachBed = "~r~Vous ne pouvez pas atteindre ce lit !",

    -- Chat Help
    ChatHelpTextSit = "S'assoir sur le siège le plus proche",
    ChatHelpTextLay = "Se coucher sur le siège le plus proche",

    -- KeyMapping
	KeyMappingKeyboard = "Se lever d'une chaise/lit",
	KeyMappingController = "Se lever d'une chaise/lit - Touche",

    GetUp = "Appuyez sur %s pour vous lever", -- When in sitting/laying, %s is automatically replaced with the key they need to press.
}

-- The diffrent sitting settings, don't touch unless you know what you are doing.
ConfigSit.SitTypes = {
    ['default'] = { -- Default settings, if non has been spesified
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        skipGoStraightTask = false,
        teleportIn = false,
        teleportOut = false,
        timeout = 8
    },
    ['chair'] = { 
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        timeout = 8
    },
    ['chair2'] = { 
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", "PROP_HUMAN_SEAT_ARMCHAIR" },
        timeout = 8
    },
    ['chair3'] = { 
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", "PROP_HUMAN_SEAT_ARMCHAIR", "PROP_HUMAN_SEAT_DECKCHAIR" },
        timeout = 8
    },
    ['barstool'] = { 
        scenarios = { "PROP_HUMAN_SEAT_BAR" },
        teleportIn = true,
        timeout = 8
    },
    ['stool'] = { 
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        teleportIn = true,
        timeout = 8
    },
    ['deck'] = { 
        scenarios = { "PROP_HUMAN_SEAT_DECKCHAIR" },
        timeout = 8
    },
    ['sunlounger'] = { 
        scenarios = { "PROP_HUMAN_SEAT_SUNLOUNGER" },
        skipGoStraightTask = true,
        timeout = 12
    },
    ['tattoo'] = {
        animation = { dict = "misstattoo_parlour@shop_ig_4", name = "customer_loop", offset = vector4(0.0, 0.0, -0.75, 0.0) },
        timeout = 8
    },
    ['strip_watch'] = {
        scenarios = { "PROP_HUMAN_SEAT_STRIP_WATCH" },
        timeout = 8
    },
    ['diner_booth'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        teleportIn = true,
        teleportOut = true,
        timeout = 8,
    },
    ['wall'] = {
        scenarios = { "WORLD_HUMAN_SEAT_WALL" },
        timeout = 8
    },
    ['steps'] = {
        scenarios = { "WORLD_HUMAN_SEAT_STEPS" },
        timeout = 8
    },
    ['ledge'] = {
        scenarios = { "WORLD_HUMAN_SEAT_LEDGE" },
        timeout = 8
    },
}

-- The diffrent laying settings, don't touch unless you know what you are doing.
ConfigSit.LayTypes = {
    ['default'] = { -- Default settings, if non has been spesified
        animation = { dict = "misslamar1dead_body", name = "dead_idle" },
        exitAnim = true
    },
    ['bed'] = { 
        animation = { dict = "misslamar1dead_body", name = "dead_idle" }
    },
    ['lay'] = { 
        animation = { dict = "savecouch@", name = "t_sleep_loop_couch", offset = vector4(-0.1, 0.1, -0.5, 270.0) }
    },
    ['layside'] = { 
        animation = { dict = "savecouch@", name = "t_sleep_loop_couch", offset = vector4(-0.1, 0.1, -0.5, 270.0) }
    },
    ['busstop'] = { 
        animation = { dict = "savecouch@", name = "t_sleep_loop_couch", offset = vector4(0.0, 0.0, -0.5, 270.0) }
    },
    ['medical'] = { 
        animation = { dict = "anim@gangops@morgue@table@", name = "body_search" }
    },
    ['tattoo'] = { 
        animation = { dict = "amb@world_human_sunbathe@male@front@base", name = "base", offset = vector4(0.0, 0.0, 0.0, 180.0) },
        exitAnim = false
    }
}
