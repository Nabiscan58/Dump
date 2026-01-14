ESX = nil

local DrugsOpen = false
local selling = false
local actualpoint = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	RMenu.Add('menu', 'sell', RageUI.CreateMenu("PRIME", "Acheteur de drogues de laboratoire", 1, 100))
    RMenu:Get('menu', 'sell'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'sell').EnableMouse = false
    RMenu:Get('menu', 'sell').Closed = function()
		DrugsOpen = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
end)

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z+1)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
end

KeyboardInputDrugs = function(one, two, max)
    local i = nil

    exports.dialog:openDialog(one, function(value)
        i = value
    end)
    while i == nil do Wait(1) end
    i = tostring(i)
    
    return i
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function isMenuOpenned()
	return DrugsOpen
end