local isPlacingObject = false

function SpawnObj(modelName)
    if isPlacingObject then
        ESX.ShowNotification("~r~Vous placez déjà un objet.")
        return
    end

    isPlacingObject = true

    if PropsOpen then
        PropsOpen = false
        RageUI.CloseAll()
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local objectCoords = coords + forward * 2.0
    local Ent = nil

    ShowHelpNotification("Utilisez le gizmo pour placer l'objet puis validez avec ~g~Entrée")

    SpawnObject(modelName, objectCoords, function(obj)
        Ent = obj
    end)

    while Ent == nil or not DoesEntityExist(Ent) do
        Citizen.Wait(0)
    end

    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    SetEntityAlpha(Ent, 170, false)

    local data = exports.object_gizmo:useGizmo(Ent)

    ResetEntityAlpha(Ent)
    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)

    local netId = NetworkGetNetworkIdFromEntity(Ent)
    table.insert(object, netId)

    Citizen.Wait(200)
    isPlacingObject = false
end

function RemoveObj(id, k)
    Citizen.CreateThread(function()
        SetNetworkIdCanMigrate(id, true)
        local entity = NetworkGetEntityFromNetworkId(id)
        NetworkRequestControlOfEntity(entity)
        local test = 0
        while test > 100 and not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Wait(1)
            test = test + 1
        end
        SetEntityAsNoLongerNeeded(entity)

        local test = 0
        while test < 100 and DoesEntityExist(entity) do 
            SetEntityAsNoLongerNeeded(entity)
            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
            DeleteEntity(entity)
            DeleteObject(entity)
            if not DoesEntityExist(entity) then 
                table.remove(object, k)
            end
            SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
            Wait(1)
            test = test + 1
        end
    end)
end

function GoodName(hash)
    if hash == GetHashKey("prop_roadcone02a") then
        return "Cone"
    elseif hash == GetHashKey("prop_barrier_work05") then
        return "Barrière"
    else
        return hash
    end

end

function SpawnObject(model, coords, cb)
    local modelHash = model
    if type(model) == 'string' then
        modelHash = GetHashKey(model)
    end

    CreateThread(function()
        RequestModels(modelHash)
        local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, true, false, true)
        if cb then
            cb(obj)
        end
    end)
end

function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

ShowHelpNotification = function(msg)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, -1)
end