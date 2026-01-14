local RckstrEditorOpened = false

Citizen.CreateThread(function()
	RMenu.Add('menu', 'rckstreditor', RageUI.CreateMenu("PRIME", "Rockstar Editor", 1, 100))
	RMenu:Get('menu', 'rckstreditor'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'rckstreditor').EnableMouse = false
    RMenu:Get('menu', 'rckstreditor').Closed = function()
		RckstrEditorOpened = false
    end
end)

function openRockstarEditorMenu()
    if RckstrEditorOpened then
        RckstrEditorOpened = false
        return
    else
        RckstrEditorOpened = true
        RageUI.Visible(RMenu:Get('menu', 'rckstreditor'), true)

        Citizen.CreateThread(function()
            while RckstrEditorOpened do
                RageUI.IsVisible(RMenu:Get('menu', 'rckstreditor'), true, true, true, function()
					RageUI.ButtonWithStyle(Config.buttonRecord, nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
                            TriggerEvent("rockstar_editor:record")
                            TriggerServerEvent('rockstar_editor:log', GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())), "record")
                            RageUI.CloseAll()
                            RckstrEditorOpened = false
						end
					end)
					RageUI.ButtonWithStyle(Config.buttonSaveClip, nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
                            TriggerEvent("rockstar_editor:saveclip")
                            TriggerServerEvent('rockstar_editor:log', GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())), "saveclip")
                            RageUI.CloseAll()
                            RckstrEditorOpened = false
						end
					end)
                    RageUI.ButtonWithStyle(Config.buttonDelClip, nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
                            TriggerEvent("rockstar_editor:delclip")
                            TriggerServerEvent('rockstar_editor:log', GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())), "delclip")
                            RageUI.CloseAll()
                            RckstrEditorOpened = false
						end
					end)
                    RageUI.ButtonWithStyle(Config.buttonEditor, nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
                            TriggerEvent("rockstar_editor:editor")
                            TriggerServerEvent('rockstar_editor:log', GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())), "editor")
                            RageUI.CloseAll()
                            RckstrEditorOpened = false
						end
					end)
                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

RegisterNetEvent("rockstar_editor:record")
AddEventHandler("rockstar_editor:record", function()
    StartRecording(1)
    notify(Config.record)
end)

RegisterNetEvent("rockstar_editor:saveclip")
AddEventHandler("rockstar_editor:saveclip", function()
    StartRecording(0)
    StopRecordingAndSaveClip()
    notify(Config.saveclip)
end)

RegisterNetEvent("rockstar_editor:delclip")
AddEventHandler("rockstar_editor:delclip", function()
    StopRecordingAndDiscardClip()
    notify(Config.delclip)
end)

RegisterNetEvent("rockstar_editor:editor")
AddEventHandler("rockstar_editor:editor", function()
    notify(Config.editor)
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

RegisterCommand("rockstar", function()
	openRockstarEditorMenu()
end, false)
RegisterKeyMapping('rockstar', 'Rockstar Editor', 'keyboard', '')