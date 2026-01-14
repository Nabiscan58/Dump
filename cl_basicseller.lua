ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local EssentialShop = {
    pedModel = "mp_m_waremech_01",
    pos = vector3(180.82086181641, -880.802734375, 29.875102996826),
    heading = 246.42,
    blip = {
        sprite = 280,             -- icône petit magasin (change si tu veux autre chose)
        colour = 5,              -- jaune / or
        scale = 0.7,             -- demandé
        label = "Vendeur essentiels",
    },
    items = {
        {label = "Bouteille d'eau", item = "eau", price = 30},
        {label = "Sandwich", item = "poulsand", price = 70},
        {label = "Téléphone", item = "classic_phone", price = 2500},
        {label = "Radio", item = "radio", price = 7500},
        {label = "Tablette illégale", item = "tablet", price = 150000},
    }
}

local shopPed = nil
local menuOpen = false
local shopBlip = nil

-- création du blip une seule fois
local function CreateEssentialBlip()
    if shopBlip ~= nil then return end

    shopBlip = AddBlipForCoord(EssentialShop.pos.x, EssentialShop.pos.y, EssentialShop.pos.z)
    SetBlipSprite(shopBlip, EssentialShop.blip.sprite or 52)
    SetBlipDisplay(shopBlip, 4)
    SetBlipScale(shopBlip, EssentialShop.blip.scale or 0.7)
    SetBlipColour(shopBlip, EssentialShop.blip.colour or 5)
    SetBlipAsShortRange(shopBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(EssentialShop.blip.label or "Vendeur essentiels")
    EndTextCommandSetBlipName(shopBlip)
end

Citizen.CreateThread(function()
    CreateEssentialBlip()
end)

-- RageUI setup
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
    end

    RMenu.Add('essentials', 'main', RageUI.CreateMenu("Essentiels", "Vendeur"))
    RMenu:Get('essentials', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('essentials', 'main').EnableMouse = false
    RMenu:Get('essentials', 'main').Closed = function()
        menuOpen = false
    end
end)

local function LoadModel(model)
    local hash = GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(1)
        end
    end
    return hash
end

local function SpawnEssentialPed()
    local hash = LoadModel(EssentialShop.pedModel)
    shopPed = CreatePed(
        4,
        hash,
        EssentialShop.pos.x,
        EssentialShop.pos.y,
        EssentialShop.pos.z - 1.0,
        EssentialShop.heading,
        false,
        false
    )

    SetEntityInvincible(shopPed, true)
    FreezeEntityPosition(shopPed, true)
    SetBlockingOfNonTemporaryEvents(shopPed, true)
    TaskStartScenarioInPlace(shopPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, true)
    SetModelAsNoLongerNeeded(hash)
end

local function DeleteEssentialPed()
    if DoesEntityExist(shopPed) then
        DeleteEntity(shopPed)
        shopPed = nil
    end
end

local function DrawFloatingText(x, y, z, textInput)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2.5
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.45 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString(textInput)
        DrawText(_x, _y)
    end
end

local function OpenEssentialMenu()
    local coords = GetEntityCoords(PlayerPedId())
    if menuOpen then return end

    menuOpen = true
    RageUI.Visible(RMenu:Get('essentials', 'main'), true)

    CreateThread(function()
        while menuOpen do

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                menuOpen = false
            end

            RageUI.IsVisible(RMenu:Get('essentials', 'main'), true, true, true, function()

                RageUI.Separator("~y~Articles disponibles")

                for _,v in ipairs(EssentialShop.items) do
                    RageUI.ButtonWithStyle(
                        v.label,
                        nil,
                        {RightLabel = v.price.." $"},
                        true,
                        function(Hovered, Active, Selected)
                            if Selected then
                                local input = lib.inputDialog('Quantité', {
                                    {type = 'number', label = 'Quantité', min = 1, default = 1}
                                })

                                if input and input[1] then
                                    local qty = tonumber(input[1])

                                    if qty and qty > 0 then
                                        TriggerServerEvent("essentialshop:buyItem", v.item, qty)
                                    else
                                        ESX.ShowNotification("~r~Quantité invalide")
                                    end
                                end
                            end
                        end
                    )
                end

            end, function() end)

            Citizen.Wait(1)
        end
    end)
end

-- boucle proximity ped
Citizen.CreateThread(function()
    while true do
        local wait = 1000

        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        local dist = #(pCoords - EssentialShop.pos)

        if dist <= 50.0 then
            wait = 0

            if not DoesEntityExist(shopPed) then
                SpawnEssentialPed()
            end

            if dist <= 2.5 then
                DrawMarker(
                    25,
                    EssentialShop.pos.x,
                    EssentialShop.pos.y,
                    EssentialShop.pos.z - 0.95,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    1.0, 1.0, 1.0,
                    255, 220, 0, 140,
                    false, false, 2, false, nil, nil, false
                )

                DrawFloatingText(
                    EssentialShop.pos.x,
                    EssentialShop.pos.y,
                    EssentialShop.pos.z + 1.0,
                    "~y~[E]~s~ Parler au vendeur"
                )

                if IsControlJustReleased(1, 38) then
                    OpenEssentialMenu()
                end
            end

        else
            if DoesEntityExist(shopPed) then
                DeleteEssentialPed()
            end
        end

        Citizen.Wait(wait)
    end
end)

-- clean ped si la ressource stop
AddEventHandler("onClientResourceStop", function(resName)
    if resName ~= GetCurrentResourceName() then return end
    DeleteEssentialPed()
    if shopBlip and DoesBlipExist(shopBlip) then
        RemoveBlip(shopBlip)
    end
end)