Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
end)

Citizen.CreateThread(function()
    while true do
		  Citizen.Wait(1000)
		  if IsPedOnFoot(PlayerPedId()) then 
		  	SetRadarZoom(1100)
		  elseif IsPedInAnyVehicle(PlayerPedId(), true) then
		  	SetRadarZoom(1100)
		  end
    end
end)