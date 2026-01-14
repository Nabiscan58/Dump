---TODO: MEttre un check de temps si ca n'existe pas stop la boucle 


function ESX.Streaming.RequestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	local resquest = 0
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) and resquest <= 5 do
			Citizen.Wait(500)
			resquest = resquest + 1
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestStreamedTextureDict(textureDict, cb)
	local resquest = 0

	if not HasStreamedTextureDictLoaded(textureDict) then
		RequestStreamedTextureDict(textureDict)

		while not HasStreamedTextureDictLoaded(textureDict) and resquest <= 5 do
			Citizen.Wait(500)
			resquest = resquest + 1
		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestNamedPtfxAsset(assetName, cb)
	local resquest = 0

	if not HasNamedPtfxAssetLoaded(assetName) then
		RequestNamedPtfxAsset(assetName)

		while not HasNamedPtfxAssetLoaded(assetName) and resquest <= 5 do
			Citizen.Wait(500)
			resquest = resquest + 1

		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestAnimSet(animSet, cb)
	local resquest = 0

	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)

		while not HasAnimSetLoaded(animSet)  and resquest <= 5 do
			Citizen.Wait(500)
			resquest = resquest + 1

		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestAnimDict(animDict, cb)
	local resquest = 0

	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) and resquest <= 5 do
			Citizen.Wait(500)
			resquest = resquest + 1

		end
	end

	if cb ~= nil then
		cb()
	end
end

function ESX.Streaming.RequestWeaponAsset(weaponHash, cb)
	local resquest = 0

	if not HasWeaponAssetLoaded(weaponHash) then
		RequestWeaponAsset(weaponHash)

		while not HasWeaponAssetLoaded(weaponHash) and resquest <= 5 do
			Citizen.Wait(500)
			resquest = resquest + 1
		end
	end

	if cb ~= nil then
		cb()
	end
end
