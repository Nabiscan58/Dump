--local open = false
--local listCandidats = {
--    {name = 'Juarez'},
--    {name = 'Lazar'},
--}
local posWeaponAmmu = {
    vector3(17.8202, -1107.1548, 28.7920),
    vector3(816.5783, -2156.8247, 28.6192),
    vector3(-664.4377, -933.2735, 20.8245),
    vector3(844.0087, -1035.7582, 27.1901),
    vector3(254.8532, -50.9350, 68.9412),
    vector3(-1119.6670, 2700.6597, 17.5543),
    vector3(1691.8702, 3761.0049, 33.7010),
    vector3(-333.0856, 6084.0356, 30.4502),
    vector3(-3174.2188, 1087.7072, 19.8340),
    vector3(2569.4795, 292.2587, 107.7296)
}

--Citizen.CreateThread(function()
--    RMenu.Add('menu', 'vote', RageUI.CreateMenu("PRIME", "Gouvernement", 1, 100))
--    RMenu:Get('menu', 'vote'):SetRectangleBanner(255, 220, 0, 140)
--    RMenu:Get('menu', 'vote').EnableMouse = false
--    RMenu:Get('menu', 'vote').Closed = function()
--        open = false
--    end
--end)

--local function menuVote()
--    local coords = GetEntityCoords(PlayerPedId())
--
--    if open then
--        open = false
--        return
--    end
--    open = true
--    RageUI.Visible(RMenu:Get('menu', 'vote'), true)
--    Citizen.CreateThread(function()
--        while open do
--            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
--                RageUI.CloseAll()
--                open = false
--            end
--
--            RageUI.IsVisible(RMenu:Get('menu', 'vote'), true, true, true, function()
--                RageUI.Separator("Votez pour le candidat de votre choix")
--                for _, v in pairs(listCandidats) do
--                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = nil}, true, function(_, _, Selected)
--                        if Selected then
--                            TriggerServerEvent("cJob_gouv.vote", v.name)
--                        end
--                    end)
--                end
--            end, function()
--            end)
--
--            if not RageUI.Visible(RMenu:Get('menu', 'vote')) then
--                open = false
--                break
--            end
--            Wait(0)
--        end
--    end)
--end

---@param data table
local function markerSystem(data)
    if data.currentDistance < 3.0 then
        if data.type == "vote" then
            --DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            --ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour voter")
            --if IsControlJustPressed(1, 38) then
                --menuVote()
            --end
        elseif data.type == "gestion" then
            if playerJob == "gouv" then
                DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour acceder au menu de gestion")
                if IsControlJustPressed(0, 38) then
                    menuGestion()
                end
            end
        elseif data.type == "weaponAmmu" then
            if playerJob == "ammu" then
                DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour ouvrir le menu de l'armurerie")
                if IsControlJustPressed(0, 38) then
                    menuWeapon()
                end
            end
        end
    end
end

local function initGestionSystem()
--    lib.points.new({
--        coords = vector3(-556.84289550781, -188.09774780273, 37.321088409424),
--        distance = 10,
--        nearby = function(self)
--            markerSystem({
--                coords = self.coords,
--                currentDistance = self.currentDistance,
--                type = "vote"
--            })
--        end
--    })
    lib.points.new({
        coords = vector3(-526.1610, -190.8299, 46.6593),
        distance = 10,
        nearby = function(self)
            markerSystem({
                coords = self.coords,
                currentDistance = self.currentDistance,
                type = "gestion"
            })
        end
    })
    for i = 1, #posWeaponAmmu do
        lib.points.new({
            coords = posWeaponAmmu[i],
            distance = 10,
            nearby = function(self)
                markerSystem({
                    coords = self.coords,
                    currentDistance = self.currentDistance,
                    type = "weaponAmmu"
                })
            end
        })
    end
end

Citizen.CreateThread(function()
    initGestionSystem()
end)