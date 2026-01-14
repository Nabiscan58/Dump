GANG_GARAGE_SELLER = {}
GANG_GARAGE_SELLER.Npcs = {}
GANG_GARAGE_SELLER.IsOpen = false

function GANG_GARAGE_SELLER.OpenMenu()
    if GANG_GARAGE_SELLER.IsOpen then
        GANG_GARAGE_SELLER.Close()
        return
    end

    -- Obtenir les données nécessaires
    local capacityInfo = Utils.TriggerServerCallback('gangs:garage:getCapacityInfo', GANG_PLAYER.GangId)

    if not capacityInfo then
        Notify("error", "Vous devez être dans un gang pour accéder à ce menu")
        return
    end

    GANG_GARAGE_SELLER.IsOpen = true

    -- Créer les menus
    RMenu.Add('seller', 'main', RageUI.CreateMenu("Véhicules du Gang", "Acheter des véhicules du gang"))
    RMenu.Add('seller', 'confirm', RageUI.CreateSubMenu(RMenu:Get('seller', 'main'), "Confirmer l'Achat", "Confirmer l'achat du véhicule"))

    -- Définir le style
    for _, menuName in pairs({ 'main', 'confirm' }) do
        RMenu:Get('seller', menuName):SetRectangleBanner(255, 220, 0, 140)
    end

    RageUI.Visible(RMenu:Get('seller', 'main'), true)
    
    local selectedVehicle = nil
    local gangType = GANG_PLAYER.Data.groupType or "Gang"
    local availableVehicles = GarageConfig[gangType] and GarageConfig[gangType].vehicles or {}

    Citizen.CreateThread(function()
        while GANG_GARAGE_SELLER.IsOpen do
            RageUI.IsVisible(RMenu:Get('seller', 'main'), true, true, true, function()
                -- Afficher les informations de capacité
                RageUI.Separator(string.format("Capacité du Garage du Gang : %d/%d", capacityInfo.current, capacityInfo.maximum))
                RageUI.Separator("Type de Gang: " .. (GarageConfig[gangType] and GarageConfig[gangType].label or gangType))

                if capacityInfo.current >= capacityInfo.maximum then
                    
                    RageUI.Separator("~r~Le garage a atteint sa capacité maximale")
                    RageUI.Separator("Améliorez le gang pour augmenter la capacité")
                    
                elseif #availableVehicles > 0 then
                    RageUI.Separator(" ~y~Véhicules Disponibles~s~ ")

                    for _, vehicleConfig in pairs(availableVehicles) do
                        RageUI.ButtonWithStyle(
                            vehicleConfig.label, 
                            "Modèle : " .. vehicleConfig.model .. "\nPrix : $" .. vehicleConfig.price,
                            { RightLabel = "~y~$" .. vehicleConfig.price .. "~s~ »" },
                            true,
                            function(_, Active, Selected)
                                if Selected then
                                    selectedVehicle = vehicleConfig
                                end

                                if Active then
                                    -- Texte d'aperçu
                                    SetTextFont(4)
                                    SetTextScale(0.5, 0.5)
                                    SetTextColour(255, 255, 255, 255)
                                    SetTextCentre(true)
                                    SetTextEntry("STRING")
                                    AddTextComponentString(vehicleConfig.label .. "\nPrix : $" .. vehicleConfig.price)
                                    DrawText(0.5, 0.85)
                                end
                            end,
                            RMenu:Get('seller', 'confirm')
                        )
                    end
                else
                    
                    RageUI.Separator("~r~Aucun véhicule disponible à l'achat")
                    RageUI.Separator("pour ce type de gang")
                    
                end
            end)

            -- Menu de Confirmation
            RageUI.IsVisible(RMenu:Get('seller', 'confirm'), true, true, true, function()
                if selectedVehicle then
                    RageUI.Separator(" Confirmer l'Achat~s~ ")
                    
                    RageUI.ButtonWithStyle(selectedVehicle.label, "Modèle : " .. selectedVehicle.model, { RightLabel = "»" }, true, function() end)

                    RageUI.ButtonWithStyle("Prix", "Prix d'achat", { RightLabel = "~y~$" .. selectedVehicle.price }, true, function() end )

                    

                    RageUI.ButtonWithStyle(
                        "~y~Confirmer l'Achat",
                        "Acheter ce véhicule pour votre gang",
                        { RightLabel = "~y~ACHETER~s~ »" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local success, message = Utils.TriggerServerCallback('gangs:garage:buyVehicle', GANG_PLAYER.GangId, selectedVehicle.model)
                                if success then
                                    Notify("success", selectedVehicle.label .. " acheté avec succès !")
                                    capacityInfo = Utils.TriggerServerCallback('gangs:garage:getCapacityInfo', GANG_PLAYER.GangId)
                                    GANG_GARAGE_SELLER.Close()
                                else
                                    Notify("error", message or "Échec de l'achat du véhicule")
                                end
                            end
                        end
                    )

                    RageUI.ButtonWithStyle(
                        "~r~Annuler",
                        "Annuler l'achat",
                        { RightLabel = "»" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                RageUI.GoBack()
                            end
                        end
                    )
                end
            end)

            Wait(0)
        end
    end)
end

function GANG_GARAGE_SELLER.Close()
    GANG_GARAGE_SELLER.IsOpen = false
    RageUI.CloseAll()
end


Citizen.CreateThread(function()
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local closestDistance = math.huge
        local closestPosition = nil

        for _, position in ipairs(Config.VehicleSellerPositions) do
            local distance = #(pCoords - position.xyz)
            if distance <= 70 then
                -- SPAWN NPC for this position if not already spawned
                if not GANG_GARAGE_SELLER.Npcs[position] then
                    RequestModel(Config.VehicleSellerModel)
                    while not HasModelLoaded(Config.VehicleSellerModel) do
                        Wait(1)
                    end

                    local npc = CreatePed(4, Config.VehicleSellerModel, position.x, position.y, position.z - 1.0, position.w, false, true)
                    SetEntityAsMissionEntity(npc, true, true)
                    SetBlockingOfNonTemporaryEvents(npc, true)
                    SetEntityInvincible(npc, true)
                    SetEntityHeading(npc, position.w)
                    FreezeEntityPosition(npc, true)
                    GANG_GARAGE_SELLER.Npcs[position] = npc
                end

                if distance < closestDistance then
                    closestDistance = distance
                    closestPosition = position
                end
            else
                -- Delete NPC if it exists and is too far
                if GANG_GARAGE_SELLER.Npcs[position] then
                    DeletePed(GANG_GARAGE_SELLER.Npcs[position])
                    GANG_GARAGE_SELLER.Npcs[position] = nil
                end
            end
        end

        -- Handle interaction with closest NPC
        if closestPosition and closestDistance <= 1.5 then
            Utils.ShowDisplayHelp('Press ~INPUT_CONTEXT~ to gang vehicle seller', false, false, 0, -1)
            if IsControlJustPressed(0, 38) then
                -- Open vehicle seller menu
                print("Open vehicle seller menu")
                GANG_GARAGE_SELLER.OpenMenu()
            end
            Wait(1)
        else
            Wait(1500)
        end
    end
end)