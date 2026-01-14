active_npc = {}

--action          = function()
--end,

npcList = {
    {
        hash            = "s_m_m_paramedic_01",
        pos             = vector3(-676.27496337891, 328.03237915039, 83.083168029785),
        heading         = 213.1,
        spawned         = false,
        entity          = nil,
        load_dst        = 20,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2,
        title           = "Médecin",
        scale           = 0.6,
    },
    {
        hash            = "s_m_m_paramedic_01",
        pos             = vector3(-622.19885253906, 312.11065673828, 83.930572509766),
        heading         = 179.1,
        spawned         = false,
        entity          = nil,
        load_dst        = 20,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2,
        title           = "Médecin",
        scale           = 0.6,
    },
    {
        hash            = "a_m_y_mexthug_01", -- Location de voiture
        pos             = vector3(421.42, -358.64, 47.15),
        heading         = 50.6,
        spawned         = false,
        entity          = nil,
        load_dst        = 30,
        msg             = true,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Location de véhicules",
        scale           = 0.6,
    },
    {
        hash            = "g_m_y_korean_02", -- Chasseur de primes
        pos             = vector3(-1471.71, -908.84, 10.13),
        heading         = 191.43,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "g_m_y_korean_02", -- GoFast
        pos             = vector3(1241.42, -438.6, 67.76),
        heading         = 73.7,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "",
        scale           = 0.6,
    },
    
    {
        hash            = "s_m_m_pilot_02", -- Garage bateaux Sandy South
        pos             = vector3(1725.5, 3290.97, 41.19),
        heading         = 202.92,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 85, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "ig_popov", -- Garage bateaux
        pos             = vector3(4427.28, -4486.03, 4.23),
        heading         = 217.05,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 85, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "a_m_m_prolhost_01", -- Location bateaux
        pos             = vector3(4930.4, -5145.94, 2.46),
        heading         = 246.12,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 85, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "u_m_m_rivalpap", -- Port Ouest Los Santos
        pos             = vector3(-718.38, -1326.9, 1.6),
        heading         = 50.76,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 85, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "a_m_m_salton_01", -- Location de bateaux Sandy Nord
        pos             = vector3(1340.12, 4225.17, 33.92),
        heading         = 78.34,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 85, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "a_f_y_business_01", -- Pole emploi
        pos             = vector3(-266.35, -961.75, 31.22),
        heading         = 211.29,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "",
        scale           = 0.6,
    },
    {
        hash            = "a_m_m_bevhills_02",
        pos             = vector3(-1019.9270629883, -2693.7517089844, 13.990200042725),
        heading         = 158.345703125,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Location de véhicules",
        scale           = 0.6,
    },
    {
        hash            = "a_m_m_bevhills_02",
        pos             = vector3(4491.3403320312, -4517.525390625, 4.1697406768799),
        heading         = 343.60375976562,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Mourad Calibré",
        scale           = 0.6,
    },
    {
        hash            = "a_m_m_bevhills_02",
        pos             = vector3(-3122.107421875, 7262.8735351562, 44.220020294189),
        heading         = 35.799751281738,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Mimid La Moula",
        scale           = 0.6,
    },
    {
        hash            = "a_m_m_og_boss_01",
        pos             = vector3(-421.83544921875, 185.64741516113, 80.707706604004),
        heading         = 249.43963623047,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Jean-Christophe",
        scale           = 0.6,
    },
    {
        hash            = "a_f_m_beach_01",
        pos             = vector3(-2088.0102539062, -596.03759765625, 1.8274948596954),
        heading         = 37.580486297607,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Kimberly te loue un bateau",
        scale           = 0.6,
    },
    {
        hash            = "s_f_y_cop_01",
        pos             = vector3(-1073.1530761719, -808.92169189453, 10.95156288147),
        heading         = 131.98,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Isabella",
        scale           = 0.6,
    },
    {
        hash            = "csb_customer",
        pos             = vector3(-544.95178222656, -610.85797119141, 35.643825531006),
        heading         = 179.04,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Service des cartes et permis",
        scale           = 0.6,
    },
     {
        hash            = "csb_cop",
        pos             = vector3(1739.8540039062, 3854.2165527344, 34.796704101562),
        heading         = 74.73,
        spawned         = false,
        entity          = nil,
        load_dst        = 70,
        msg             = false,

        blip_enable     = true,
        sprite          = 52,
        color           = 2, 
        title           = "Michel",
        scale           = 0.6,
    },
}

Citizen.CreateThread(function()
    while true do
        local ped       = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for _,v in pairs(npcList) do
            local dst = GetDistanceBetweenCoords(v.pos, pedCoords, true)

            if not v.spawned then
                if dst <= v.load_dst then
                    v.spawned = true

                    if v.npcType == nil then
                        LoadModel(v.hash)
                        v.entity = CreatePed(4, v.hash, v.pos.x, v.pos.y, v.pos.z - 1.0, v.heading, 0, 0)
                        if v.freeze == nil then
                            TaskSetBlockingOfNonTemporaryEvents(v.entity, true)
                            FreezeEntityPosition(v.entity, true)
                            if v.invincible == nil then
                                SetEntityInvincible(v.entity, true)
                            end
                        end

                        if v.anim then
                            if v.animType == 'TaskPlayAnim' then
                                RequestAnimDict(v.animData.dict)
                                while not HasAnimDictLoaded(v.animData.dict) do Citizen.Wait(1) end

                                Citizen.Wait(100)	
                                TaskPlayAnim(v.entity, v.animData.dict, v.animData.name, v.animData.blendIn, v.animData.blendOut, v.animData.duration, v.animData.flag, v.animData.playback, v.animData.lockX, v.animData.lockY, v.animData.lockZ)
                            elseif v.animType == 'TaskStartScenarioInPlace' then
                                TaskStartScenarioInPlace(v.entity, v.animData.name, 0, true)
                            end
                        end

                        if v.skin ~= nil then
                            TriggerEvent("skinchanger:applySkinToPed", v.entity, v.skin)
                        end
                        table.insert(active_npc, {pos = v.pos, isCrew = v.isCrew, crew = v.crew, action = v.action, ped = v.entity, hash = v.hash, msg = v.msg})
                        if v.addToTable then
                            table.insert(v.tableInfo, {ped = v.entity})
                        end
                    elseif v.npcType == 'car' then
                        Citizen.CreateThread(function()
                            if not HasModelLoaded(v.hash) and IsModelInCdimage(v.hash) then
                                RequestModel(v.hash)
                                while not HasModelLoaded(v.hash) do Citizen.Wait(1) end
                            end
                            v.entity = CreateVehicle(v.hash, v.pos, v.heading, false, false)
                            SetVehicleUndriveable()
                            SetVehicleDoorsLocked(v.entity, true)
                            FreezeEntityPosition(v.entity, true)
                            RequestCollisionAtCoord(v.pos.x, v.pos.y, v.pos.z)

                            table.insert(active_npc, {pos = v.pos, isCrew = v.isCrew, crew = v.crew, action = v.action, ped = v.entity, hash = v.hash, msg = v.msg})
                        end)
                    elseif v.npcType == 'prop' then
                        Citizen.CreateThread(function()
                            RequestModel(v.hash)
                            local iter_for_request = 1
                            while not HasModelLoaded(v.hash) and iter_for_request < 5 do
                                Citizen.Wait(500)
                                iter_for_request = iter_for_request + 1
                            end
                            if not HasModelLoaded(v.hash) then
                                SetModelAsNoLongerNeeded(v.hash)
                            else
                                local ped = PlayerPedId()
                                local created_object = CreateObjectNoOffset(v.hash, v.pos.x, v.pos.y, v.pos.y, 1, 0, 1)
                                SetEntityHeading(created_object, v.heading)
                                PlaceObjectOnGroundProperly(created_object)
                                FreezeEntityPosition(created_object,true)
                                SetModelAsNoLongerNeeded(v.hash)
                            end
                        end)
                    end
                end
            else
                if dst > v.load_dst then
                    if DoesEntityExist(v.entity) then
                        v.spawned = false
                        DeleteEntity(v.entity)
                        for k,v in pairs(active_npc) do
                            if v.pos == v.pos then
                                table.remove(active_npc, k)
                            end
                        end
                    end
                end
            end
        end
        Wait(2000)
    end
end)

LoadModel = function(model)
	local m = GetHashKey(model)

    RequestModel(m)
	while not HasModelLoaded(m) do
		Wait(1)
	end
end

---Stay Maps
local CloseToCayo = false
local CayoMinimapLoaded = false

Citizen.CreateThread(function()
    while true do
        local near_npc  = false
        local ped       = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        if CloseToCayo ~= CloseToCayo then
            CloseToCayo = CloseToCayo
            CayoMinimapLoaded = CloseToCayo
            SetToggleMinimapHeistIsland(CloseToCayo)
        end

        for k,v in pairs(npcList) do
            local dst = GetDistanceBetweenCoords(pedCoords, v.pos, true)
            local v_dst = v.dst or 2.5

            if dst <= v_dst then
                near_npc = true
                -- Draw the title above the NPC if it exists
                if v.title and DoesEntityExist(v.entity) then
                    local npcPos = GetEntityCoords(v.entity)
                    local x, y, z = table.unpack(npcPos + vector3(0, 0, 1.2))  -- Adjust z to position the text above the NPC's head
                    DrawText3D(x, y, z, v.title)
                end

                if v.action ~= nil then
                    if v.msg then
                        ESX.ShowHelpNotification("~p~Appuyez sur E pour parler avec la personne")
                    end
                    if IsControlJustReleased(1, 38) then
                        v.action()
                    end
                end
            end
        end

        if near_npc then
            Wait(1)
        else
            Wait(2500)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y+0.0145, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

CreateThread(function()
    while true do
        
        local wait = 500

        if IsPauseMenuActive() and not IsMinimapInInterior() then

            if CayoMinimapLoaded then
                CayoMinimapLoaded = false
                SetToggleMinimapHeistIsland(false)
            end

            SetRadarAsExteriorThisFrame()
            SetRadarAsInteriorThisFrame(GetHashKey("h4_fake_islandx"), 4700.0, -5145.0, 0, 0)
            wait = 0

        elseif not CayoMinimapLoaded and CloseToCayo then
            CayoMinimapLoaded = true
            SetToggleMinimapHeistIsland(true)
            
        end
        Wait(wait)
    end
end)