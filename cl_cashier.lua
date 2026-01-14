local remainTime = {
    d = 0,
    m = 0,
    s = 0,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

KeyboardInputNative = function(entryTitle, textEntry, inputText, maxLength)
	playerIsOnKeyBoard = true
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', tostring(inputText or ''), '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	playerIsOnKeyBoard = false

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(100)
		return result
	else
		Citizen.Wait(100)
		return nil
	end
end

openCashier = function()
	PlaySoundFrontend(-1, "DLC_VW_RULES", "dlc_vw_table_games_frontend_sounds", true)

	local coords = GetEntityCoords(PlayerPedId())

	RMenu.Add('casino', 'main', RageUI.CreateMenu("", "SERVICES DE CAISSE", 1, 100, "shopui_title_casino", "shopui_title_casino"))
    RMenu:Get('casino', "main").Closed = function()
        CASINO["cashierMenuOpenned"] = false
        
        RMenu:Delete('casino', 'main')
    end

    if CASINO["cashierMenuOpenned"] then
        CASINO["cashierMenuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        CASINO["cashierMenuOpenned"] = true
        RageUI.Visible(RMenu:Get('casino', 'main'), true)
    end

    RMenu:Get('casino', "main"):SetPageCounter("")

    Citizen.CreateThread(function()
        while CASINO["cashierMenuOpenned"] do

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                CASINO["cashierMenuOpenned"] = false
            end

            Citizen.Wait(1000)
        end
    end)

    local currentJetons = GroupDigits(CASINO["myJetons"])

    Citizen.CreateThread(function()
        while CASINO["cashierMenuOpenned"] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('casino', 'main'), true, false, true, function()

                --RageUI.ProgressSeparator(currentJetons.." jetons", {
                --    ProgressStart = 0,
                --    ProgressMax = 100,
                --})

                RageUI.Button("Acquérir des jetons", "Sélectionnez le nombre de jetons que vous voulez acquérir.", {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInputNative("BUY", "Combien en voulez-vous ?", "", 15)
                        amount = tonumber(amount)

                        if amount == nil then return end
                        if amount < 1 then return end

                        TriggerServerEvent("casino:buyJetons", amount)
                    end
                end)

                RageUI.Button("Échanger des jetons", "Sélectionnez le nombre de jetons que vous voulez échanger.", {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInputNative("BUY", "Combien en voulez-vous ?", "", 15)
                        amount = tonumber(amount)

                        if amount == nil then return end
                        if amount < 1 then return end

                        TriggerServerEvent("casino:excJetons", amount)
                    end
                end)

                --RageUI.Button("Échanger les anciens jetons", "Recevez la nouvelle monnaie qui fait office de jetons casino", {}, true, function(Hovered, Active, Selected)
                --    if Selected then
                --        TriggerServerEvent("casino:tradeOlds")
                --    end
                --end)
            end)
        end
    end)
end

Citizen.CreateThread(function()
    local basePos = vector3(1115.99, 220.03, -49.44)
    while true do
        local interval = 1000

        if #(GetEntityCoords(PlayerPedId()) - basePos) <= 2.0 then
            if not CASINO["cashierMenuOpenned"] then
                openCashier()
            end
        else
            CASINO["cashierMenuOpenned"] = false
        end

        Citizen.Wait(interval)
    end
end)

RegisterNetEvent("casino:updateDailyCashier")
AddEventHandler("casino:updateDailyCashier", function(ddd)
    remainTime = ddd
end)