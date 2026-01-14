ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false

-- === Toggle Chat (L) ===
local CHAT_KVP = "chat:hidden"
local chatHiddenForced = false
local __lastToggleAt = 0      -- anti double-trigger

-- /togglechat : bascule (ou /togglechat on /togglechat off)
RegisterCommand('togglechat', function(_, args)
    -- anti double-trigger <250ms
    local now = GetGameTimer()
    if (now - __lastToggleAt) < 250 then return end
    __lastToggleAt = now

    local arg = (args[1] or ""):lower()
    if arg == "on" then
        chatHiddenForced = false
    elseif arg == "off" then
        chatHiddenForced = true
    else
        chatHiddenForced = not chatHiddenForced
    end

    -- persister + sync NUI
    SendNUIMessage({ type = 'CHAT_SET_HIDDEN', payload = { hidden = chatHiddenForced } })

    ESX.ShowNotification(chatHiddenForced
        and "Chat masqué. Appuyez sur ~b~L~s~ pour réafficher."
        or "Chat affiché.")
end, false)

-- Keymapping sur L (évite les collisions: fais gaffe qu’aucune autre ressource ne mappe la même commande)
RegisterKeyMapping('togglechat', 'Afficher/Cacher le chat', 'keyboard', 'L')

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:client:ClearChat')

RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

AddEventHandler('chatMessage', function(author, color, text)
	if chatHiddenForced then
		return
	end
	local args = { text }
	if author ~= "" then
		table.insert(args, 1, author)
	end
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			color = color,
			args = args
		}
	})
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			templateId = 'print',
			args = { msg }
		}
	})
end)

AddEventHandler('chat:addMessage', function(message)
	-- if exports.zCore:IsAnyMenuOpenned() then
	-- 	while exports.zCore:IsAnyMenuOpenned() do
	-- 		Citizen.Wait(1000)
	-- 	end
	-- end
	if chatHiddenForced then
		return
	end

	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = message
	})
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = 'ON_SUGGESTION_ADD',
			suggestion = suggestion
		})
	end
end)

AddEventHandler('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

RegisterNetEvent('chat:resetSuggestions')
AddEventHandler('chat:resetSuggestions', function()
	SendNUIMessage({
		type = 'ON_COMMANDS_RESET'
	})
end)

AddEventHandler('chat:addTemplate', function(id, html)
	SendNUIMessage({
		type = 'ON_TEMPLATE_ADD',
		template = {
			id = id,
			html = html
		}
	})
end)

AddEventHandler('chat:client:ClearChat', function(name)
	SendNUIMessage({
		type = 'ON_CLEAR'
	})
end)

RegisterNUICallback('chatResult', function(data, cb)
	PlaySoundFrontend(-1, 'WEAPON_ATTACHMENT_UNEQUIP', 'HUD_AMMO_SHOP_SOUNDSET', 1)

	chatInputActive = false
	SetNuiFocus(false)

	if not data.canceled then
		local id = PlayerId()

		local r, g, b = 0, 0x99, 255

		if data.message:sub(1, 1) == '/' then
			ExecuteCommand(data.message:sub(2))
		else
			TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), {r, g, b}, data.message)
		end
	end

	cb('ok')
end)

local function refreshCommands()
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()

		local suggestions = {}

		for _, command in ipairs(registeredCommands) do
			if IsAceAllowed(('command.%s'):format(command.name)) then
				table.insert(suggestions, {
					name = '/' .. command.name,
					help = ''
				})
			end
		end

		TriggerEvent('chat:addSuggestions', suggestions)
	end
end

local function refreshThemes()
	local themes = {}

	for resIdx = 0, GetNumResources() - 1 do
		local resource = GetResourceByFindIndex(resIdx)

		if GetResourceState(resource) == 'started' then
			local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

			if numThemes > 0 then
				local themeName = GetResourceMetadata(resource, 'chat_theme')
				local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

				if themeName and themeData then
					themeData.baseUrl = 'nui://' .. resource .. '/'
					themes[themeName] = themeData
				end
			end
		end
	end

	SendNUIMessage({
		type = 'ON_UPDATE_THEMES',
		themes = themes
	})
end

AddEventHandler('onClientResourceStart', function(resName)
	Wait(500)

	refreshCommands()
	refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
	Wait(500)

	refreshCommands()
	refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
	TriggerServerEvent('chat:init');

	refreshCommands()
	refreshThemes()

	chatLoaded = true

	cb('ok')
end)

Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)

	RegisterKeyMapping("chat", "Ouvrir le chat", 'keyboard', "t")
    RegisterCommand("chat", function()
		if chatHiddenForced then
			ESX.ShowNotification("Le chat est ~r~désactivé~s~. Utilisez ~b~/togglechat~s~ pour l'activer.")
			return
		end
		if exports["lb-phone"]:IsOpen() then return end
		if exports.adminmenu:RageUIAnyMenuIsOpen() then return end
		if exports.rg_core:RageUIAnyMenuIsOpen() then return end
		if IsPauseMenuActive() then return end
        PlaySoundFrontend(-1, 'ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
		SendNUIMessage({
			type = 'ON_OPEN'
		})
		SetNuiFocus(true)
    end, false)

	-- while true do
	-- 	Wait(0)

	-- 	if not chatInputActive then
	-- 		if IsControlPressed(0, 245) then
	-- 			-- if exports.phone:GetStatePhone() then return end
	-- 			if not exports.zCore:IsAnyMenuOpenned() then
	-- 				chatInputActive = true
	-- 				chatInputActivating = true

	-- 				PlaySoundFrontend(-1, 'ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
	-- 				SendNUIMessage({
	-- 					type = 'ON_OPEN'
	-- 				})
	-- 			end
	-- 		end
	-- 	end

	-- 	if chatInputActivating then
	-- 		if not IsControlPressed(0, 245) then
	-- 			-- if exports.phone:GetStatePhone() then return end

	-- 			SetNuiFocus(true)

	-- 			chatInputActivating = false
	-- 		end
	-- 	end

		-- if chatLoaded then
		-- 	local shouldBeHidden = false

		-- 	if IsScreenFadedOut() or IsPauseMenuActive() then
		-- 		shouldBeHidden = true
		-- 	end

		-- 	if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
		-- 		chatHidden = shouldBeHidden

		-- 		-- PlaySoundFrontend(-1, 'ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
		-- 		SendNUIMessage({
		-- 			type = 'ON_SCREEN_STATE_CHANGE',
		-- 			shouldHide = shouldBeHidden
		-- 		})
		-- 	end
		-- end
	-- end
end)

function IsChatOpenned()
	return chatInputActive
end

RegisterNUICallback("focusOn", function(_, cb)
    SetNuiFocus(true, true)
    cb("ok")
end)

RegisterNUICallback("focusOff", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)