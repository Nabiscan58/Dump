local seatIndex = 0

function ChangeSeat(vehicle, newSeat)
    local player = GetPlayerPed(-1)
    TaskWarpPedIntoVehicle(player, vehicle, newSeat - 1)
    seatIndex = newSeat
end

function ChangeSeatInVehicle(newSeat)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)

    if newSeat >= 1 and newSeat <= maxSeats then
        ChangeSeat(vehicle, newSeat)
    else
        print("Numéro de siège invalide.")
    end
end

function KeyRegister(Controls, ControlName, Description, Action)
	RegisterKeyMapping(string.format('%s', ControlName), Description, "keyboard", Controls)
	RegisterCommand(string.format('%s', ControlName), function(source, args)
		if (Action ~= nil) then
			Action();
		end
	end, false)
end

KeyRegister("1", "switchSeat1", "Place 1", function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsControlPressed(0, 21) then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
end)

KeyRegister("2", "switchSeat2'", "Place 2", function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsControlPressed(0, 21) then
        ChangeSeatInVehicle(1)
    end
end)

KeyRegister("3", "switchSeat3", "Place 3", function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsControlPressed(0, 21) then
        ChangeSeatInVehicle(2)
    end
end)

KeyRegister("4", "switchSeat4", "Place 4", function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsControlPressed(0, 21) then
        ChangeSeatInVehicle(3)
    end
end)

KeyRegister("5", "switchSeat5", "Place 5", function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsControlPressed(0, 21) then
        ChangeSeatInVehicle(4)
    end
end)

KeyRegister("6", "switchSeat6", "Place 6", function()
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and IsControlPressed(0, 21) then
        ChangeSeatInVehicle(5)
    end
end)