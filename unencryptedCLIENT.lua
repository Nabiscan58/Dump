


--You have to trigger this event to open the ui for a specific tub
--You can trigger this event with every script that you want
RegisterNetEvent(scriptIdentifier..":OpenUiForTube")
AddEventHandler(scriptIdentifier..":OpenUiForTube", function(object)
	--you Have to pass the entity as argument, otherwise it will not work !!!!!
	isNetworked = NetworkGetEntityIsNetworked(object)
	if isNetworked then
		TriggerEvent("Pata_Tub:OpenUI",object,true)
	else
		TriggerEvent("Pata_Tub:OpenUI",GetEntityCoords(object),false)
	end	
end)

RegisterNetEvent(scriptIdentifier..":CreateTube")
AddEventHandler(scriptIdentifier..":CreateTube", function()
	tempmodel = GetHashKey("pata_garden24")
	RequestModel(tempmodel)
	timeout = 0
	while not HasModelLoaded(tempmodel) and timeout < 100 do
		RequestModel(tempmodel)
		Citizen.Wait(0)
		timeout = timeout + 1
	end

	if timeout > 99 then print("timeout") end

	object = CreateObject(tempmodel,GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,4.0,1.0),true,false,true)
	SetEntityHeading(object,GetEntityHeading(object)+45.0)
	PlaceObjectOnGroundProperly(object)
	FreezeEntityPosition(object,true)
end)

RegisterNetEvent(scriptIdentifier..":DeleteTube")
AddEventHandler(scriptIdentifier..":DeleteTube", function(object)
	while not NetworkHasControlOfEntity(object) do
		Citizen.Wait(2)
		NetworkRequestControlOfEntity(object)
	end

	TriggerServerEvent('hottub:deleteJacuzzi')
	
	DeleteEntity(object)
end)

RegisterCommand('CreateTube', function(source)
	TriggerEvent(scriptIdentifier..":CreateTube")
end)