Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

local dataSociety <const> = {
    ["ammu"] = {
       {type = "boss", coords = vec3(4.8917, -1108.9070, 28.7972)},
       {type = "stashe", coords = vec3(9.0299, -1100.1572, 28.7972)},
    },
    ["bobcat"] = {
        {type = "boss", coords = vec3(750.23541259766, -1397.3953857422, 26.217357254028)},
        {type = "stashe", coords = vec3(758.55389404297, -1365.5972900391, 26.212440109253)},
        {type = "cloakroom", coords = vec3(735.21917724609, -1363.1452636719, 26.215615844727)},
        {type = "armory", coords = vec3(749.56671142578, -1365.5577392578, 26.212440109253)},
    },
    ["doj"] = {
        {type = "boss", coords = vec3(-571.55169677734, -619.74932861328, 34.70046005249)},
        {type = "stashe", coords = vec3(-581.64587402344, -615.87329101562, 34.703084564209)},
        {type = "cloakroom", coords = vec3(-564.26135253906, -618.71215820312, 34.703084564209)},
    },
    ["elysian"] = {
        {type = "boss", coords = vec3(-126.8674, -2519.2407, 10.1799)},
        {type = "stashe", coords = vec3(-116.5530, -2500.8499, 5.1136)},
        {type = "cloakroom", coords = vec3(-125.5039, -2525.1865, 10.1855)},
    },
    ["fourriere"] = {
        {type = "boss", coords = vec3(463.09188842773, -1146.4752197266, 28.711644744873)},
        {type = "stashe", coords = vec3(438.06036376953, -1167.1925048828, 28.518937683105)},
    },
    ["gouv"] = {
        {type = "boss", coords = vec3(-541.70837402344, -596.25128173828, 34.703099822998)},
        {type = "stashe", coords = vec3(-581.29577636719, -618.69921875, 34.703084564209)},
        {type = "cloakroom", coords = vec3(-574.41851806641, -618.71917724609, 34.703084564209)},
        {type = "armory", coords = vec3(-571.15466308594, -603.44793701172, 34.703084564209)},
    },
    ["lsfd"] = {
        {type = "boss", coords = vec3(-1055.8124, -1435.0380, 3.9685)},
        {type = "stashe", coords = vec3(-1045.0286, -1387.9406, 3.9774)},
        {type = "cloakroom", coords = vec3(-1030.6998, -1392.7249, 3.9702)},
        {type = "armory", coords = vec3(-1036.3578, -1391.3951, 3.9731)},
    },
    ["bennys"] = {
        {type = "boss", coords = vec3(697.12115478516, 161.6234588623, 88.891976928711)},
        {type = "stashe", coords = vec3(684.50109863281, 169.90267944336, 79.871530151367)},
    },
    ["harmony"] = {
        {type = "boss", coords = vec3(71.7281, 6519.9502, 30.9129)},
        {type = "stashe", coords = vec3(68.4143, 6489.0962, 30.9129)},
    },
    ["beachnsky"] = {
        {type = "boss", coords = vec3(-788.7959, -1346.4738, 4.1783)},
        {type = "stashe", coords = vec3(-791.16, -1344.83, 8.13)},
    },
    ["paletoauto"] = {
        {type = "boss", coords = vec3(-233.1838, 6228.5010, 30.9987)},
    },
    ["pdm"] = {
        {type = "boss", coords = vec3(-39.90, -1084.29, 26.37)},
        {type = "stashe", coords = vec3(-24.53, -1102.01, 26.37)},
    },
    ["marshall"] = {
        {type = "boss", coords = vec3(-811.82440185547, -713.35754394531, 27.159951782227)},
        {type = "stashe", coords = vec3(-815.87084960938, -714.11407470703, 22.059976196289)},
        {type = "armory", coords = vec3(-815.98950195312, -720.70935058594, 22.076278305054)},
    },
    ["police"] = {
        {type = "boss", coords = vec3(-1112.0500488281, -829.96014404297, 33.380010223389)},
        {type = "stashe", coords = vec3(-1040.3793945312, -809.56903076172, 10.051591491699)},
        {type = "cloakroom", coords = vec3(-1053.8682861328, -820.67834472656, 10.051591491699)},
        {type = "armory", coords = vec3(-1035.1707763672, -814.03472900391, 10.051598167419)},
    },
    ["sheriff"] = {
        {type = "boss", coords = vec3(1737.0535888672, 3897.1633300781, 38.880639648438)},
        {type = "stashe", coords = vec3(1702.4555664062, 3874.9953613281, 30.551950073242)},
        {type = "cloakroom", coords = vec3(1729.3994140625, 3892.0900878906, 30.551948165894)},
        {type = "armory", coords = vec3(1729.4123535156, 3879.7316894531, 30.551950073242)},
    },
    ["immo"] = {
        {type = "boss", coords = vec3(80.5171, -267.5632, 47.1906)},
        {type = "stashe", coords = vec3(72.0944, -257.0890, 47.1921)},
        {type = "cloakroom", coords = vec3(83.8016, -252.8466, 47.1971)},
    },
    ["ems"] = {
        {type = "boss", coords = vec3(-658.9844, 310.9456, 91.7404)},
        {type = "boss", coords = vec3(-547.8005, 7395.0415, 11.8307)},
        {type = "boss", coords = vec3(1958.1883544922, 3763.89453125, 31.64955291748)},
        {type = "stashe", coords = vec3(-667.5494, 342.1907, 82.0787)},
        {type = "stashe", coords = vec3(1981.9849853516, 3779.2775878906, 31.649549102783)},
        {type = "stashe", coords = vec3(-534.2687, 7375.3071, 11.8352)},
        {type = "cloakroom", coords = vec3(-663.6996, 322.4762, 91.7402)},
        {type = "cloakroom", coords = vec3(-538.9511, 7371.5405, 11.8312)},
        {type = "cloakroom", coords = vec3(1973.1320800781, 3779.3540039062, 31.64955291748)},
        {type = "pharmacy", coords = vec3(-674.3400, 338.6570, 82.0773)},
        {type = "pharmacy", coords = vec3(-561.4655, 7395.2563, 7.5147)},
        {type = "pharmacy", coords = vec3(1969.2906494141, 3758.2973632812, 35.063165283203)},
    },
    ["studio"] = {
        {type = "boss", coords = vec3(486.9510, -83.5077, 57.1859)},
        {type = "stashe", coords = vec3(499.5339, -55.2017, 57.1600)},
    },
    ["taxi"] = {
        {type = "boss", coords = vec3(-1242.1691, -277.8346, 42.8883)},
        {type = "stashe", coords = vec3(-1264.8301, -292.0756, 37.6788)},
        {type = "cloakroom", coords = vec3(-1256.2010, -287.9692, 42.7009)},
    },
    ["weazle"] = {
        {type = "boss", coords = vec3(-583.35, -928.46, 27.16)},
        {type = "stashe", coords = vec3(-578.2000, -924.0300, 22.8621)},
    },
    ["streettuners"] = {
        {type = "boss", coords = vec3(-655.65881347656, -2369.1953125, 13.054523086548)},
        {type = "stashe", coords = vec3(-650.70074462891, -2373.9501953125, 13.054508781433)},
    }
}
local currentMarkers = {}

---@param data table
local function markerSociety(data)
    DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
    if data.currentDistance < 3.0 then
        if data.type == "boss" then
            ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au ~y~menu patron")
            if IsControlJustPressed(1, 38) then
                TriggerEvent('esx_society:openBosstozMenu', data.playerJob, function(data, menu) end)
            end
        elseif data.type == "stashe" then
            ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au ~y~coffre")
            if IsControlJustPressed(1, 38) then
                if ESX.GotPerm("coffre") then
                    TriggerEvent("coffres:openCoffre", data.playerJob)
                else
                    ESX.ShowNotification("Vous n'avez pas accès.")
                end
            end
        elseif data.type == "cloakroom" then
            ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au ~y~vestiaire")
            if IsControlJustPressed(1, 38) then
                TriggerEvent("clotheshop:openVestiaire")
            end
        elseif data.type == "armory" then
            ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour acceder à l'armurerie")
            if IsControlJustPressed(1, 38) then
                openMenuArmory(data.playerJob)
            end
        elseif data.type == "pharmacy" then
            ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour acceder à la pharmacie")
            if IsControlJustPressed(1, 38) then
                openMenuPharmacy()
            end
        end
    end
end

---@param playerJob string
local function initMarkerSociety(playerJob)
    if dataSociety[playerJob] then
        for _, v in ipairs(dataSociety[playerJob]) do
            if currentMarkers[v.coords] then
                currentMarkers[v.coords]:remove()
                currentMarkers[v.coords] = nil
            end

            local point = lib.points.new({
                coords = v.coords,
                distance = 10,
                nearby = function(self)
                    markerSociety({
                        coords = self.coords,
                        currentDistance = self.currentDistance,
                        playerJob = playerJob,
                        type = v.type
                    })
                end
            })

            currentMarkers[v.coords] = point
        end
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    playerJob = xPlayer.job.name
    initMarkerSociety(playerJob)
    initGarageSociety(playerJob)
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    ESX.PlayerData.job = job
    inService = false
    playerJob = job.name
    initMarkerSociety(playerJob)
    initGarageSociety(playerJob)
end)

exports("inService", function()
    return inService
end)