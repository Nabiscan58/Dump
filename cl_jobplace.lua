-- ESX = nil
-- local jobplace = false

-- Citizen.CreateThread(function()
--     while ESX == nil do
--         TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
--         Citizen.Wait(0)
-- 	end
	
--     RMenu.Add('menu', 'jobs', RageUI.CreateMenu("PRIME", "Pôle Emploi", 1, 100))
--     RMenu:Get('menu', 'jobs'):SetRectangleBanner(255, 220, 0, 140)
--     RMenu:Get('menu', 'jobs').EnableMouse = false
--     RMenu:Get('menu', 'jobs').Closed = function()
-- 		jobplace = false
--     end
-- end)

-- function openJobPlaceMenu()
--     if jobplace then
--         jobplace = false
--         return
--     else
--         jobplace = true
--         RageUI.Visible(RMenu:Get('menu', 'jobs'), true)

--         Citizen.CreateThread(function()
--             while jobplace do
--                 RageUI.IsVisible(RMenu:Get('menu', 'jobs'), true, true, true, function()     
--                     for k,v in pairs(Config.jobs) do
--                         RageUI.ButtonWithStyle(v.joblabel, nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
--                             if (Selected) then
--                                 ESX.ShowAdvancedNotification("Pôle Emploi", "Ashley", v.message, "CHAR_ASHLEY", 9)
--                                 SetNewWaypoint(v.coords)
--                             end
--                         end)
--                     end
--                     RageUI.ButtonWithStyle("Métallurgiste", nil, { RightLabel = "BIENTÔT DISPONIBLE" },true, function(Hovered, Active, Selected)
--                     end)
--                 end, function()
--                 end)
--                 Wait(0)
--             end
--         end, function()
--         end, 1)
--     end
-- end

-- local JobPlaces = {
-- 	{x = -265.87 , y = -962.6, z = 30.22, }
-- }

-- Citizen.CreateThread(function()
--     while true do
--         local nearThing = false

-- 		for k in pairs(JobPlaces) do
-- 			local plyCoords = GetEntityCoords(PlayerPedId(), false)
-- 			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, JobPlaces[k].x, JobPlaces[k].y, JobPlaces[k].z)

--             if dist <= 2.0 then
--                 nearThing = true
--                 ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour chercher un emploi.")
--                 DrawMarker(6, JobPlaces[k].x, JobPlaces[k].y, JobPlaces[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
-- 				if IsControlJustPressed(1,51) then
--                     if jobplace == false then
-- 					    openJobPlaceMenu()
--                     end
-- 				end
-- 			end
--         end
        
--         if nearThing then
--             Citizen.Wait(0)
--         else
--             Citizen.Wait(500)
--         end
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	local poleblip = AddBlipForCoord(-265.93, -962.6, 31.22)
-- 	SetBlipSprite(poleblip, 590)
-- 	SetBlipScale(poleblip, 0.7)
-- 	SetBlipColour(poleblip, 8)
-- 	SetBlipAsShortRange(poleblip, true)
-- 	BeginTextCommandSetBlipName('STRING')
-- 	AddTextComponentSubstringPlayerName('Pôle Emploi')
-- 	EndTextCommandSetBlipName(poleblip)
-- end)