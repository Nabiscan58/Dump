local ESX = exports["es_extended"]:getSharedObject()

local PetConfig = {
    lewall_alien = { model = `lewall_alien`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien2 = { model = `lewall_alien2`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien3 = { model = `lewall_alien3`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien4 = { model = `lewall_alien4`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien5 = { model = `lewall_alien5`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_bulldog = { model = `lewall_bulldog`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_cowboy = { model = `lewall_cowboy`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_crab = { model = `lewall_crab`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_cthulhu = { model = `lewall_cthulhu`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dino = { model = `lewall_dino`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dog = { model = `lewall_dog`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dog2 = { model = `lewall_dog2`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_doggy = { model = `lewall_doggy`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dragon = { model = `lewall_dragon`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dragon2 = { model = `lewall_dragon2`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dragon3 = { model = `lewall_dragon3`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_parrot = { model = `lewall_parrot`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_rabbit = { model = `lewall_rabbit`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_saw = { model = `lewall_saw`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_shiba = { model = `lewall_shiba`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_snake = { model = `lewall_snake`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_spider = { model = `lewall_spider`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_tiger = { model = `lewall_tiger`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_witch = { model = `lewall_witch`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) }
}

local currentPet = nil
local currentItem = nil
local currentOffset = nil
local currentRotation = nil
local isEditing = false

local function ShowHelpNotification(msg)
    if ESX and ESX.ShowHelpNotification then
        ESX.ShowHelpNotification(msg)
    else
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandDisplayHelp(0, false, false, -1)
    end
end

local function DeleteCurrentPet()
    if currentPet and DoesEntityExist(currentPet) then
        DetachEntity(currentPet, true, true)
        DeleteEntity(currentPet)
    end
    currentPet = nil
    currentItem = nil
    currentOffset = nil
    currentRotation = nil
    isEditing = false
end

local function AttachPet()
    if not currentPet or not DoesEntityExist(currentPet) then
        return
    end
    local ped = PlayerPedId()
    local bone = GetPedBoneIndex(ped, 24818)
    AttachEntityToEntity(
        currentPet,
        ped,
        bone,
        currentOffset.x,
        currentOffset.y,
        currentOffset.z,
        currentRotation.x,
        currentRotation.y,
        currentRotation.z,
        true,
        true,
        false,
        true,
        2,
        true
    )
end

local function StartEditLoop()
    if isEditing then
        return
    end
    isEditing = true

    local step = 0.003       -- avant / arrière
    local stepZ = 0.005      -- hauteur, un peu plus gros pour bien voir

    CreateThread(function()
        while isEditing and currentPet and DoesEntityExist(currentPet) do
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)

            ShowHelpNotification("~INPUT_CELLPHONE_UP~/~INPUT_CELLPHONE_DOWN~ monter/descendre\n~INPUT_CELLPHONE_LEFT~/~INPUT_CELLPHONE_RIGHT~ avancer/reculer\n~INPUT_CONTEXT~ valider\n~INPUT_CELLPHONE_CANCEL~ ranger le pet")

            -- HAUTEUR (Z)
            if IsControlPressed(0, 172) then
                currentOffset = vector3(currentOffset.x, currentOffset.y, currentOffset.z + stepZ)
                AttachPet()
            end

            if IsControlPressed(0, 173) then
                currentOffset = vector3(currentOffset.x, currentOffset.y, currentOffset.z - stepZ)
                AttachPet()
            end

            -- AVANT / ARRIÈRE (Y)
            if IsControlPressed(0, 174) then
                currentOffset = vector3(currentOffset.x, currentOffset.y + step, currentOffset.z)
                AttachPet()
            end

            if IsControlPressed(0, 175) then
                currentOffset = vector3(currentOffset.x, currentOffset.y - step, currentOffset.z)
                AttachPet()
            end

            if IsControlJustPressed(0, 38) then
                isEditing = false
            end

            if IsControlJustPressed(0, 177) then
                DeleteCurrentPet()
            end

            if IsPedDeadOrDying(PlayerPedId(), true) then
                DeleteCurrentPet()
            end

            Wait(0)
        end
    end)
end

local function SpawnPetForItem(itemName)
    local cfg = PetConfig[itemName]
    if not cfg then
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local model = cfg.model

    if not IsModelValid(model) then
        return
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, true, false)

    if not DoesEntityExist(obj) then
        local startTime = GetGameTimer()
        local timeout = 5000

        while not DoesEntityExist(obj) and (GetGameTimer() - startTime) < timeout do
            Wait(0)
        end

        if not DoesEntityExist(obj) then
            print("[Pets] Impossible de créer l'entité du pet (timeout)")
            return
        end
    end

    SetEntityCollision(obj, false, false)
    SetEntityCompletelyDisableCollision(obj, true, true)
    SetEntityInvincible(obj, true)
    SetEntityAsMissionEntity(obj, true, true)

    currentPet = obj
    currentItem = itemName
    currentOffset = cfg.offset
    currentRotation = cfg.rotation

    AttachPet()
    StartEditLoop()
end

RegisterNetEvent("lewall_pets:useItem", function(itemName)
    if currentPet and DoesEntityExist(currentPet) then
        if currentItem == itemName then
            DeleteCurrentPet()
            ESX.ShowNotification("Tu ranges le pet")
        else
            DeleteCurrentPet()
            SpawnPetForItem(itemName)
            ESX.ShowNotification("Tu changes de pet")
        end
    else
        if not PetConfig[itemName] then
            return
        end
        SpawnPetForItem(itemName)
        ESX.ShowNotification("Utilise les touches pour ajuster ton pet")
    end
end)

AddEventHandler("onClientResourceStop", function(res)
    if res == GetCurrentResourceName() then
        DeleteCurrentPet()
    end
end)