Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(1385978229374062664)
		SetDiscordRichPresenceAsset('logo_name')
        SetDiscordRichPresenceAssetText('PRIME RP')
        SetDiscordRichPresenceAssetSmallText('GTA RP')
		SetDiscordRichPresenceAction(0, "🎮 Viens jouer 🎮", "fivem://connect/cfx.re/join/xvzobe")
        SetDiscordRichPresenceAction(1, "💛 discord.gg/primefa 💛", "https://discord.gg/primefa")
		Citizen.Wait(5000)
	end
end)

local num = math.random(50, 256)

RegisterNetEvent("Infinity:GetPlayer")
AddEventHandler("Infinity:GetPlayer", function(_num)
	num = _num
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30*1000)
		SetRichPresence(num .." connectés")
	end
end)