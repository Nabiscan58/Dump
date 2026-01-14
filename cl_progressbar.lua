function drawBar(time, text, cb)
	SendNUIMessage({
		time = time,
		text = text,
	})
	if cb then
		Citizen.SetTimeout(time + 100, cb)
	end
end

RegisterNetEvent('api:stopUI')
AddEventHandler('api:stopUI', function()
	SendNUIMessage({
		type = "ui",
		display = false
	})
end)

RegisterNetEvent('core:drawBar')
AddEventHandler('core:drawBar', function(time, text, cb)
	drawBar(time, text, cb)
end)