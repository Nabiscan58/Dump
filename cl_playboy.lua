Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(2000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for _,int in pairs(cfg.ipl) do
        	local distance = #(coords - int.coords)
        	if distance < 400 then
            	if int.enable and not int.loaded then
					RequestIpl(int.ymap)
					local interior = GetInteriorAtCoordsWithType(int.coords, int.name)
					while not IsInteriorReady(interior) do
						Wait(0)
					end

                    if int.color then
                        SetInteriorEntitySetColor(interior, 'ipl_list3', int.colorSet)
                    end

					for current_ipls, ipl in pairs(int.ipls) do
						if int.ipls[current_ipls] then
							ActivateInteriorEntitySet(interior, current_ipls)
						else
							DeactivateInteriorEntitySet(interior, current_ipls)
						end
					end

					if not int.loaded then
						int.loaded = true
						RefreshInterior(interior)
					end
            	end
        	else
				int.loaded = false
				RemoveIpl(int.ymap)
        	end
        Wait(0)
    	end
	end
end)