local events = {
	'HCheat:TempDisableDetection',
 	'BsCuff:Cuff696999',
	'police:cuffGranted',
	'lester:vendita',
 	'mellotrainer:adminTempBan',
 	'esx_truckerjob:pay',
 	'AdminMenu:giveCash',
	'AdminMenu:giveBank',
 	'AdminMenu:giveDirtyMoney',
 	'esx-qalle-jail:jailPlayer',
 	'kickAllPlayer',
 	'esx_gopostaljob:pay',
 	'esx_banksecurity:pay',
	'esx_slotmachine:sv:2',
 	'lscustoms:payGarage',
 	'vrp_slotmachine:server:2',
	'dmv:success',
 	'esx_drugs:startHarvestCoke',
 	'esx_drugs:startHarvestMeth',
 	'esx_drugs:startHarvestWeed',
 	'esx_drugs:startHarvestOpium',
 	'ReviveAll',
 	'es_admin:all',
 	'adminmenu:allowall',
 	'es_admin:teleportUser',
 	'es_admin:quick',
 	'esx_vehicleshop:setVehicleOwned',
 	'esx_jobs:caution',
 	'KorioZ-PersonalMenu:Weapon_addAmmoToPedS',
 	'KorioZ-PersonalMenu:Admin_BringS',
 	'KorioZ-PersonalMenu:Admin_giveCash',
 	'KorioZ-PersonalMenu:Admin_giveBank',
 	'KorioZ-PersonalMenu:Admin_giveDirtyMoney',
 	'KorioZ-PersonalMenu:Boss_promouvoirplayer',
 	'KorioZ-PersonalMenu:Boss_destituerplayer',
 	'KorioZ-PersonalMenu:Boss_recruterplayer',
 	'KorioZ-PersonalMenu:Boss_virerplayer',
	'redst0nia:checking',
	'bank:deposit"',
	'Banca:deposit',
	'esx_vehicleshop:setVehicleOwned',
	'esx_carthief:pay',
	'esx_pizza:pay',
	'esx_ranger:pay',
	'esx_garbagejob:pay',
	'esx_truckerjob:pay',
	'AdminMenu:giveBank',
	'AdminMenu:giveCash',
	'esx_gopostaljob:pay',
	'esx_banksecurity:pay',
	'esx:giveInventoryItem',
	'NB:recruterplayer',
	'esx_billing:sendBill',
	'esx_jailer:sendToJail',
	'esx_jail:sendToJail',
	'esx-qalle-jail:jailPlayer',
	'LegacyFuel:PayFuel',
	'esx_dmvschool:pay',
	'CheckHandcuff',
	'cuffServer',
	'cuffGranted',
	'police:cuffGranted',
	'esx_handcuffs:cuffing',
	'esx_policejob:handcuff',
	'bank:withdraw',
	'dmv:success',
	'esx_skin:responseSaveSkin',
	'esx_dmvschool:addLicense',
	'esx_society:openBossMenu',
	'esx_jobs:caution',
	'esx_tankerjob:pay',
	'esx_vehicletrunk:giveDirty',
	'AdminMenu:giveDirtyMoney',
	'esx_moneywash:deposit',
	'mission:completed',
	'truckerJob:success',
	'DiscordBot:playerDied',
	'esx_ambulancejob:revive',
	'hentailover:xdlol',
	'antilynx8:anticheat',
	'antilynxr6:detection',
	'esx:getSharedObject',
	'esx_society:getOnlinePlayers',
	'antilynx8r4a:anticheat',
	'antilynxr4:detect',
	'js:jailuser',
	'ynx8:anticheat',
	'lynx8:anticheat',
	'adminmenu:allowall',
	'adminmenu:setsalary',
	'ljail:jailplayer',
	'h:xd',
	'adminmenu:setsalary',
	'bank:transfer',
	'paycheck:bonus',
	'paycheck:salary',
	'HCheat:TempDisableDetection',
	'esx-qalle-hunting:reward',
	'esx-qalle-hunting:sell',
	'esx_mecanojob:onNPCJobCompleted',
	'BsCuff:Cuff696999',
	'veh_SR:CheckMoneyForVeh',
	'esx_carthief:alertcops',
	'esx_society:putVehicleInGarage',
	'RS_MISSION:GetPay',
	'RS_MISSION:GetPayBlack',
	'lester:vendita',
	'barbershop:pay',
}

local Animals = {
    [GetHashKey("a_c_rat")] = true,
}

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent("AC:Sync")
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do Wait(100) end
	while true do
		Citizen.Wait(3000)
		local count = 0
		local peds = ESX.Game.GetPeds(ignoreList)
		for i=1, #peds, 1 do
			local model = GetEntityModel(peds[i])
			if model == -1920001264 then
				count = count + 1
				SetEntityAsNoLongerNeeded(peds[i])
				DeleteEntity(peds[i])
			end
		end
	end
end)

for i=1, #events, 1 do
	AddEventHandler(events[i], function()
		TriggerServerEvent('AC:UltraSync', events[i])
	end)
end

-- Log

WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = '',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
	[tostring(GetHashKey('WEAPON_MK18B'))] = 'MK18B',
	[tostring(GetHashKey('WEAPON_HK416B'))] = 'HK416',
	[tostring(GetHashKey('WEAPON_G19'))] = 'Glock 19',
	[tostring(GetHashKey('WEAPON_MP5'))] = 'MP5',
	[tostring(GetHashKey('WEAPON_MP7CMG'))] = 'MP7',
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Fusil Double Action',
	[tostring(GetHashKey('WEAPON_TACTICALRIFLE'))] = 'Fusil Tactique',
	[tostring(GetHashKey('WEAPON_DILDOCMG'))] = 'Dildo',
	[tostring(GetHashKey('WEAPON_KATANA'))] = 'Katana',
	[tostring(GetHashKey('WEAPON_GUITARCMG'))] = 'Guitare',
	[tostring(GetHashKey('WEAPON_FIREAXECMG'))] = 'Hache',
	[tostring(GetHashKey('WEAPON_BREAD'))] = 'Baguette',
	[tostring(GetHashKey('WEAPON_CHAINSAW'))] = 'Tronçonneuse halloween',
	[tostring(GetHashKey('WEAPON_SLICE'))] = 'Fourche halloween',
	[tostring(GetHashKey('WEAPON_DEMHAMMER'))] = 'Marteau halloween',
	[tostring(GetHashKey('WEAPON_KARAMBIT'))] = 'Karambit',
	[tostring(GetHashKey('WEAPON_CANDYKNIFE'))] = 'Couteau Noel',
	[tostring(GetHashKey('WEAPON_CARROTSWORD'))] = 'Épée Paques',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLELS'))] = 'AK Rustique',
	[tostring(GetHashKey('WEAPON_PATRIOTKNIFE'))] = 'Couteau Patriote',
	[tostring(GetHashKey('WEAPON_FRYINPAN'))] = 'Pôele',
	[tostring(GetHashKey('WEAPON_AXE'))] = 'Hache',
	[tostring(GetHashKey('WEAPON_BARBEDBAT'))] = 'Bat cloutée',
	[tostring(GetHashKey('WEAPON_BATON'))] = 'Bâton',
	[tostring(GetHashKey('WEAPON_BLACKKATANA'))] = 'Katana noir',
	[tostring(GetHashKey('WEAPON_BLUEZK'))] = 'ZK bleu',
	[tostring(GetHashKey('WEAPON_BROWNMACHETE'))] = 'Machette marron',
	[tostring(GetHashKey('WEAPON_BUTCHER'))] = 'Couteau de boucher',
	[tostring(GetHashKey('WEAPON_CHAIR'))] = 'Chaise',
	[tostring(GetHashKey('WEAPON_CRUTCH'))] = 'Béquille',
	[tostring(GetHashKey('WEAPON_DILDO'))] = 'Dildo',
	[tostring(GetHashKey('WEAPON_EGUITAR'))] = 'Guitare électrique',
	[tostring(GetHashKey('WEAPON_GUITAR'))] = 'Guitare',
	[tostring(GetHashKey('WEAPON_HUNTERKNIFE'))] = 'Couteau de chasse',
	[tostring(GetHashKey('WEAPON_ICECLIMBER'))] = 'Piolet',
	[tostring(GetHashKey('WEAPON_KITCHENKNIFE'))] = 'Couteau de cuisine',
	[tostring(GetHashKey('WEAPON_KUKRI'))] = 'Kukri',
	[tostring(GetHashKey('WEAPON_LONGMACHETE'))] = 'Longue machette',
	[tostring(GetHashKey('WEAPON_MACE'))] = 'Masse',
	[tostring(GetHashKey('WEAPON_PICKAXE'))] = 'Pioche',
	[tostring(GetHashKey('WEAPON_PINKZK'))] = 'ZK rose',
	[tostring(GetHashKey('WEAPON_PITCHFORK'))] = 'Fourche',
	[tostring(GetHashKey('WEAPON_REDZK'))] = 'ZK rouge',
	[tostring(GetHashKey('WEAPON_SCIFISWORD'))] = 'Épée sci-fi',
	[tostring(GetHashKey('WEAPON_SCIMITAR'))] = 'Cimeterre',
	[tostring(GetHashKey('WEAPON_SCREWDRIVER'))] = 'Tournevis',
	[tostring(GetHashKey('WEAPON_SCYTHE'))] = 'Faux',
	[tostring(GetHashKey('WEAPON_SHOVEL'))] = 'Pelle',
	[tostring(GetHashKey('WEAPON_SLEDGEHAMMER'))] = 'Marteau de démolition',
	[tostring(GetHashKey('WEAPON_SPIKEDKNUCKLES'))] = 'Poings américains cloutés',
	[tostring(GetHashKey('WEAPON_SPIKEYBAT'))] = 'Bat à pointes',
	[tostring(GetHashKey('WEAPON_STOPSIGN'))] = 'Panneau stop',
	[tostring(GetHashKey('WEAPON_TACAXE'))] = 'Hache tactique',
	[tostring(GetHashKey('WEAPON_TACCLEAVER'))] = 'Couperet tactique',
	[tostring(GetHashKey('WEAPON_TACTICALHATCHET'))] = 'Hachette tactique',
	[tostring(GetHashKey('WEAPON_THORSHAMMER'))] = 'Marteau de Thor',
	[tostring(GetHashKey('WEAPON_TWOHBATTLEAXE'))] = 'Hache de bataille à deux mains',
	[tostring(GetHashKey('WEAPON_WCLAWS'))] = 'Griffes de combat',
	[tostring(GetHashKey('WEAPON_ZK'))] = 'ZK',
	[tostring(GetHashKey('WEAPON_MACHINE_PISTOL_RED_CHR'))] = 'Pistolet mitrailleur rouge chromium',
	[tostring(GetHashKey('WEAPON_BULLPUP_SMG'))] = 'Bullpup SMG',
	[tostring(GetHashKey('WEAPON_MP9'))] = 'MP Prime',
	[tostring(GetHashKey('WEAPON_EXTENDEDSMG'))] = 'SMG Halloween',
	[tostring(GetHashKey('WEAPON_GOLDSMG'))] = 'SMG Gold',
	[tostring(GetHashKey('WEAPON_M415'))] = 'Matador',
	[tostring(GetHashKey('WEAPON_AK_SHORTSTOCK_CHR'))] = 'AK Compacte Chromium',
	[tostring(GetHashKey('WEAPON_PF940'))] = 'Pistolet PF',
	[tostring(GetHashKey('WEAPON_MP7_CHROMIUM'))] = 'SMG Chromium',
	[tostring(GetHashKey('WEAPON_VECTOR'))] = 'Thor',
	[tostring(GetHashKey('WEAPON_SB4S'))] = 'SB4S',
	[tostring(GetHashKey('WEAPON_HKUSP'))] = 'HKUSP',
	[tostring(GetHashKey('WEAPON_WOLFKNIFE'))] = 'Couteau Loup',
	[tostring(GetHashKey('WEAPON_UMP_CHR'))] = 'UMP CHR',
	[tostring(GetHashKey('WEAPON_SCAR-L'))] = 'KAR-L',
	[tostring(GetHashKey('WEAPON_DEAGLE'))] = 'Deagle',
	[tostring(GetHashKey('WEAPON_PNONENTE'))] = 'P90',
	[tostring(GetHashKey('WEAPON_CZ_SCORPION_EVO_CHR'))] = 'Scorpion Evo',
	[tostring(GetHashKey('WEAPON_SS2_2'))] = 'SS2',
	[tostring(GetHashKey('WEAPON_VERESK'))] = 'Veresk',
	[tostring(GetHashKey('WEAPON_MLTM4R_CHR'))] = 'MLTM4R',
	[tostring(GetHashKey('WEAPON_FAMAS'))] = 'Famas',
	[tostring(GetHashKey('WEAPON_SPS_21_SG_CHR'))] = 'SPS 21',
	[tostring(GetHashKey('WEAPON_MICRO_9_CHR'))] = 'Micro 9',
	[tostring(GetHashKey('WEAPON_VX_SCORPION_CHR'))] = 'Scorpion VX',
	[tostring(GetHashKey('WEAPON_NVRIFLE_CHR'))] = 'NV Assault',
	[tostring(GetHashKey('WEAPON_REDL'))] = 'RED-L',
	[tostring(GetHashKey('WEAPON_TR_88_CHR'))] = 'T88',
	[tostring(GetHashKey('WEAPON_M270D_CHR'))] = '270D',
	[tostring(GetHashKey('WEAPON_M4BEAST'))] = 'M4 Beast',
	[tostring(GetHashKey('WEAPON_TAR21'))] = 'TAR',
	[tostring(GetHashKey('WEAPON_BAS_P_RED'))] = 'BasP',
	[tostring(GetHashKey('WEAPON_KS1'))] = 'KS1',
	[tostring(GetHashKey('WEAPON_A15RC'))] = 'A15RC',
	[tostring(GetHashKey('WEAPON_SMG9'))] = 'SMG9',
	[tostring(GetHashKey('WEAPON_L85_CHR'))] = 'L85',
	[tostring(GetHashKey('WEAPON_14'))] = 'Pistolet national',
	[tostring(GetHashKey('WEAPON_BUTERFLY'))] = 'Couteau national',
	[tostring(GetHashKey('WEAPON_DIRTYSYRINGE'))] = 'Seringue sale',
	[tostring(GetHashKey('WEAPON_PEELER'))] = 'Éplucheur',
	[tostring(GetHashKey('WEAPON_RULER'))] = 'Règle',
	[tostring(GetHashKey('WEAPON_BIGSPOON'))] = 'Grosse cuillère',
	[tostring(GetHashKey('WEAPON_JABSAW'))] = 'Scie à guichet',
	[tostring(GetHashKey('WEAPON_TELESCOPE'))] = 'Télescope',
	[tostring(GetHashKey('WEAPON_MEATSKEWER'))] = 'Brochette de viande',
	[tostring(GetHashKey('WEAPON_SWORDFISH'))] = 'Espadon',
	[tostring(GetHashKey('WEAPON_LOBSTER'))] = 'Homard',
	[tostring(GetHashKey('WEAPON_PLIERS'))] = 'Pince',
	[tostring(GetHashKey('WEAPON_HANDDRILL'))] = 'Perceuse manuelle',
	[tostring(GetHashKey('WEAPON_TWISTEDSPEAR'))] = 'Lance tordue',
	[tostring(GetHashKey('WEAPON_SNAKEKNIFE'))] = 'Couteau serpent',
	[tostring(GetHashKey('WEAPON_CRUTCHKNIFE'))] = 'Couteau béquille',
	[tostring(GetHashKey('WEAPON_SHARPARROW'))] = 'Flèche aiguisée',
	[tostring(GetHashKey('WEAPON_95SIGN'))] = 'Panneau 95',
	[tostring(GetHashKey('WEAPON_ASSASINGUN'))] = 'Pistolet assassin',
	[tostring(GetHashKey('WEAPON_BAGUETTE'))] = 'Baguette',
	[tostring(GetHashKey('WEAPON_BANANA'))] = 'Banane',
	[tostring(GetHashKey('WEAPON_BIKE'))] = 'Vélo',
	[tostring(GetHashKey('WEAPON_BONE'))] = 'Os',
	[tostring(GetHashKey('WEAPON_BONESWORD'))] = 'Épée en os',
	[tostring(GetHashKey('WEAPON_BUTTPLUG'))] = 'Plug anal',
	[tostring(GetHashKey('WEAPON_CACTUS'))] = 'Cactus',
	[tostring(GetHashKey('WEAPON_CAMSHAFT'))] = 'Arbre à cames',
	[tostring(GetHashKey('WEAPON_CARJACK'))] = 'Cric',
	[tostring(GetHashKey('WEAPON_CONE'))] = 'Cône',
	[tostring(GetHashKey('WEAPON_CROSSSPANNER'))] = 'Clé en croix',
	[tostring(GetHashKey('WEAPON_CUCUMBER'))] = 'Concombre',
	[tostring(GetHashKey('WEAPON_DISABLEDSIGN'))] = 'Panneau handicapé',
	[tostring(GetHashKey('WEAPON_ELDERSWAND'))] = 'Baguette des anciens',
	[tostring(GetHashKey('WEAPON_MFIREEXTINGUISHER'))] = 'Extincteur modifié',
	[tostring(GetHashKey('WEAPON_FISHINGROD'))] = 'Canne à pêche',
	[tostring(GetHashKey('WEAPON_GASCYLINDER'))] = 'Bouteille de gaz',
	[tostring(GetHashKey('WEAPON_HOCKEYFSTICK'))] = 'Crosse de hockey',
	[tostring(GetHashKey('WEAPON_HORN'))] = 'Klaxon',
	[tostring(GetHashKey('WEAPON_JDBOTTLE'))] = 'Bouteille de JD',
	[tostring(GetHashKey('WEAPON_KEYBOARD'))] = 'Clavier',
	[tostring(GetHashKey('WEAPON_KITCHENFORK'))] = 'Fourchette de cuisine',
	[tostring(GetHashKey('WEAPON_LACROSSESTICK'))] = 'Crosse de lacrosse',
	[tostring(GetHashKey('WEAPON_LADDER'))] = 'Échelle',
	[tostring(GetHashKey('WEAPON_MAILBOX'))] = 'Boîte aux lettres',
	[tostring(GetHashKey('WEAPON_MIC'))] = 'Micro',
	[tostring(GetHashKey('WEAPON_NOPARKINGSIGN'))] = 'Panneau stationnement interdit',
	[tostring(GetHashKey('WEAPON_PEN'))] = 'Stylo',
	[tostring(GetHashKey('WEAPON_PENCIL'))] = 'Crayon',
	[tostring(GetHashKey('WEAPON_PROSLEG'))] = 'Jambe prothétique',
	[tostring(GetHashKey('WEAPON_ROLLINGPIN'))] = 'Rouleau à pâtisserie',
	[tostring(GetHashKey('WEAPON_RONABOTTLE'))] = 'Bouteille Rona',
	[tostring(GetHashKey('WEAPON_ROUTE66SIGN'))] = 'Panneau Route 66',
	[tostring(GetHashKey('WEAPON_SCOOTER'))] = 'Trottinette',
	[tostring(GetHashKey('WEAPON_SHOCKABSORBER'))] = 'Amortisseur',
	[tostring(GetHashKey('WEAPON_SKULLBAT'))] = 'Batte crâne',
	[tostring(GetHashKey('WEAPON_SPARTANSWORD'))] = 'Épée spartiate',
	[tostring(GetHashKey('WEAPON_SPATULA'))] = 'Spatule',
	[tostring(GetHashKey('WEAPON_STEPLADDER'))] = 'Escabeau',
	[tostring(GetHashKey('WEAPON_STREETLIGHT'))] = 'Lampadaire',
	[tostring(GetHashKey('WEAPON_TOASTER'))] = 'Grille-pain',
	[tostring(GetHashKey('WEAPON_VACUUM'))] = 'Aspirateur',
	[tostring(GetHashKey('WEAPON_WRONGWAYSIGN'))] = 'Panneau sens interdit',
	[tostring(GetHashKey('WEAPON_YARI'))] = 'Yari',
	[tostring(GetHashKey('WEAPON_BLACKBELT'))] = 'Ceinture noire',
	[tostring(GetHashKey('WEAPON_BENTFORK'))] = 'Fourchette tordue',
	[tostring(GetHashKey('WEAPON_BLACKBACKPACK'))] = 'Sac à dos noir',
	[tostring(GetHashKey('WEAPON_BRCHICKEN'))] = 'Poulet brûlé',
	[tostring(GetHashKey('WEAPON_DOORBARS'))] = 'Barres de porte',
	[tostring(GetHashKey('WEAPON_EARBUDBLADE'))] = 'Lame écouteur',
	[tostring(GetHashKey('WEAPON_HONEYDIPPER'))] = 'Cuillère à miel',
	[tostring(GetHashKey('WEAPON_KETTLE'))] = 'Bouilloire',
	[tostring(GetHashKey('WEAPON_LEATHERBRIEFCASE'))] = 'Mallette en cuir',
	[tostring(GetHashKey('WEAPON_MAKESHIFTKNIFE'))] = 'Couteau de fortune',
	[tostring(GetHashKey('WEAPON_MEASURINGCUP'))] = 'Verre doseur',
	[tostring(GetHashKey('WEAPON_MODDEDNIGHTSTICK'))] = 'Matraque modifiée',
	[tostring(GetHashKey('WEAPON_TRAYRACK'))] = 'Grille de service',
	[tostring(GetHashKey('WEAPON_POKER'))] = 'Tisonnier',
	[tostring(GetHashKey('WEAPON_PRISONKEY'))] = 'Clé de prison',
	[tostring(GetHashKey('WEAPON_VIOBACKPACK'))] = 'Sac violet',
	[tostring(GetHashKey('WEAPON_REDBACKPACK'))] = 'Sac rouge',
	[tostring(GetHashKey('WEAPON_TEAPOT'))] = 'Théière',
	[tostring(GetHashKey('WEAPON_PRISTOI'))] = 'Toilette de prison',
	[tostring(GetHashKey('WEAPON_SHIV'))] = 'Lame de prison',
	[tostring(GetHashKey('WEAPON_FETE21'))] = 'Couteau belge',
	[tostring(GetHashKey('WEAPON_GK47'))] = 'AK Gold',
	[tostring(GetHashKey('WEAPON_COMBAT_SG_CHR'))] = 'Combat SG',
	[tostring(GetHashKey('WEAPON_R90_CHR'))] = 'R90',
	[tostring(GetHashKey('WEAPON_G3_2'))] = 'G3V2',
	[tostring(GetHashKey('WEAPON_AUG'))] = 'AUG',
	[tostring(GetHashKey('WEAPON_M16A1_CHR'))] = 'M16A1',
	[tostring(GetHashKey('WEAPON_HX_15_CHR'))] = 'HX15',
	[tostring(GetHashKey('WEAPON_KITTBOWYAXE'))] = 'Hache arc-en-ciel',
	[tostring(GetHashKey('WEAPON_UNICORNHORN'))] = 'Corne de licorne',
	[tostring(GetHashKey('WEAPON_BRUNETTEDOLL'))] = 'Poupée brune',
	[tostring(GetHashKey('WEAPON_BLONDEDOLL'))] = 'Poupée blonde',
	[tostring(GetHashKey('WEAPON_ANIMEDOLL'))] = 'Poupée manga',
	[tostring(GetHashKey('WEAPON_WEDDINGRING'))] = 'Alliance',
	[tostring(GetHashKey('WEAPON_FEGUITAR'))] = 'Guitare électrique',
	[tostring(GetHashKey('WEAPON_FGUITAR'))] = 'Guitare',
	[tostring(GetHashKey('WEAPON_BABYCHAIRFOOD'))] = 'Chaise bébé repas',
	[tostring(GetHashKey('WEAPON_TWEEZERS'))] = 'Pince à épiler',
	[tostring(GetHashKey('WEAPON_PINKSWITCHBLADE'))] = 'Cran d’arrêt rose',
	[tostring(GetHashKey('WEAPON_KITTYAXE'))] = 'Hache chaton',
	[tostring(GetHashKey('WEAPON_BABYSEAT'))] = 'Siège bébé',
	[tostring(GetHashKey('WEAPON_TWIRLPOP'))] = 'Sucette spirale',
	[tostring(GetHashKey('WEAPON_ROUNDLOLLY'))] = 'Sucette ronde',
	[tostring(GetHashKey('WEAPON_HSLOLLY'))] = 'Sucette étoile',
	[tostring(GetHashKey('WEAPON_BUTTERLOLLY'))] = 'Sucette beurre',
	[tostring(GetHashKey('WEAPON_STEAMIRON'))] = 'Fer à repasser',
	[tostring(GetHashKey('WEAPON_HAIRBRUSH'))] = 'Brosse à cheveux',
	[tostring(GetHashKey('WEAPON_PINKLOLLY'))] = 'Sucette rose',
	[tostring(GetHashKey('WEAPON_LOLLYBAT'))] = 'Batte sucette',
	[tostring(GetHashKey('WEAPON_CANDYKNIFE'))] = 'Couteau bonbon',
	[tostring(GetHashKey('WEAPON_ROSEKNIFE'))] = 'Couteau rose',
	[tostring(GetHashKey('WEAPON_LIPSTICK'))] = 'Rouge à lèvres',
	[tostring(GetHashKey('WEAPON_BLPURSE'))] = 'Sac à main noir',
	[tostring(GetHashKey('WEAPON_PINKPOOLNOODLE'))] = 'Frite piscine rose',
	[tostring(GetHashKey('WEAPON_WHITEPILLOW'))] = 'Oreiller blanc',
	[tostring(GetHashKey('WEAPON_PINKPILLOW'))] = 'Oreiller rose',
	[tostring(GetHashKey('WEAPON_FTEDDYPINK'))] = 'Nounours rose',
	[tostring(GetHashKey('WEAPON_FTEDDY'))] = 'Nounours',
	[tostring(GetHashKey('WEAPON_VIBRATOR'))] = 'Vibromasseur',
	[tostring(GetHashKey('WEAPON_FDUALSWORD'))] = 'Doubles épées',
	[tostring(GetHashKey('WEAPON_CRYSTALROD'))] = 'Bâton cristal',
	[tostring(GetHashKey('WEAPON_FZVTWO'))] = 'Couteau zombie V2',
	[tostring(GetHashKey('WEAPON_FSLIPPERS'))] = 'Chaussons',
	[tostring(GetHashKey('WEAPON_BLOSSOMKNIFE'))] = 'Couteau fleur',
	[tostring(GetHashKey('WEAPON_BLOSSOMKATANA'))] = 'Katana fleur',
	[tostring(GetHashKey('WEAPON_FHATCHET'))] = 'Hachette',
	[tostring(GetHashKey('WEAPON_FKNUCKLE'))] = 'Poing américain',
	[tostring(GetHashKey('WEAPON_CHRIBAG'))] = 'Sac de Noël',
	[tostring(GetHashKey('WEAPON_FBLACKHEEL'))] = 'Talon noir',
	[tostring(GetHashKey('WEAPON_FPINKHEEL'))] = 'Talon rose',
	[tostring(GetHashKey('WEAPON_FREDHEEL'))] = 'Talon rouge',
	[tostring(GetHashKey('WEAPON_FBAT'))] = 'Batte',
	[tostring(GetHashKey('WEAPON_FSPIKEBAT'))] = 'Batte cloutée',
	[tostring(GetHashKey('WEAPON_FPICKAXE'))] = 'Pioche',
	[tostring(GetHashKey('WEAPON_FCOMB'))] = 'Peigne',
	[tostring(GetHashKey('WEAPON_PINKKEYBOARD'))] = 'Clavier rose',
	[tostring(GetHashKey('WEAPON_SPIKEDCHOKER'))] = 'Collier à pics',
	[tostring(GetHashKey('WEAPON_PINKCHOKER'))] = 'Collier rose',
	[tostring(GetHashKey('WEAPON_PINKPEPPERSPRAY'))] = 'Lacrymo rose',
	[tostring(GetHashKey('WEAPON_BLOWDRYER'))] = 'Sèche-cheveux',
	[tostring(GetHashKey('WEAPON_BOBSFISHINGNET'))] = 'Filet de pêche',
	[tostring(GetHashKey('WEAPON_DRAGONDOLL'))] = 'Poupée dragon',
	[tostring(GetHashKey('WEAPON_WEAPON_FCLOSEDUMBRELLA'))] = 'Parapluie fermé',
	[tostring(GetHashKey('WEAPON_FLAMINGO'))] = 'Flamant rose',
	[tostring(GetHashKey('WEAPON_FSCEPTER'))] = 'Sceptre',
	[tostring(GetHashKey('WEAPON_FUMBRELLA'))] = 'Parapluie',
	[tostring(GetHashKey('WEAPON_GOLDDIGGER'))] = 'Pioche dorée',
	[tostring(GetHashKey('WEAPON_HAIRPIN'))] = 'Épingle à cheveux',
	[tostring(GetHashKey('WEAPON_HEARTBAG'))] = 'Sac cœur',
	[tostring(GetHashKey('WEAPON_KERBSDOLL'))] = 'Poupée Kerbs',
	[tostring(GetHashKey('WEAPON_KETTLEBALL'))] = 'Kettlebell',
	[tostring(GetHashKey('WEAPON_MARSHSTICK'))] = 'Bâton guimauve',
	[tostring(GetHashKey('WEAPON_MERMAID'))] = 'Poupée sirène',
	[tostring(GetHashKey('WEAPON_MOUSEDOLL'))] = 'Poupée souris',
	[tostring(GetHashKey('WEAPON_OCTOPUSDOLL'))] = 'Poupée pieuvre',
	[tostring(GetHashKey('WEAPON_PINKBOLTCUTTERS'))] = 'Coupe-boulons rose',
	[tostring(GetHashKey('WEAPON_PINKFAXE'))] = 'Hache rose',
	[tostring(GetHashKey('WEAPON_PINKFPICKAXE'))] = 'Pioche rose',
	[tostring(GetHashKey('WEAPON_PINKHAMMER'))] = 'Marteau rose',
	[tostring(GetHashKey('WEAPON_PINKHANDFAN'))] = 'Éventail rose',
	[tostring(GetHashKey('WEAPON_PINKKNIGHTSTICK'))] = 'Matraque rose',
	[tostring(GetHashKey('WEAPON_PINKSCREWDRIVER'))] = 'Tournevis rose',
	[tostring(GetHashKey('WEAPON_PSLEDGE'))] = 'Masse rose',
	[tostring(GetHashKey('WEAPON_TIARA'))] = 'Diadème',
	[tostring(GetHashKey('WEAPON_LUUBAG'))] = 'Sac Luu',
	[tostring(GetHashKey('WEAPON_PINKCUTTER'))] = 'Cutter rose',
	[tostring(GetHashKey('WEAPON_PINKCYBERSWORD'))] = 'Épée cyber rose',
	[tostring(GetHashKey('WEAPON_RADABAG'))] = 'Sac Rada',
	[tostring(GetHashKey('WEAPON_SB_SD_CHR'))] = 'SB-SD',
	[tostring(GetHashKey('WEAPON_VX_47_CHR'))] = 'VX-47',
	[tostring(GetHashKey('WEAPON_R90_CHR'))] = 'R90',
	[tostring(GetHashKey('WEAPON_BONECLUB'))] = 'Massue en os',
	[tostring(GetHashKey('WEAPON_BUCKET'))] = 'Seau',
	[tostring(GetHashKey('WEAPON_COFFIN'))] = 'Cercueil',
	[tostring(GetHashKey('WEAPON_DEATHNOTE'))] = 'Death Note',
	[tostring(GetHashKey('WEAPON_HELLFIRESWORD'))] = 'Épée infernale',
	[tostring(GetHashKey('WEAPON_INFERNO'))] = 'Inferno',
	[tostring(GetHashKey('WEAPON_PUMPKIN'))] = 'Citrouille',
	[tostring(GetHashKey('WEAPON_PUMPKINBAT'))] = 'Batte citrouille',
	[tostring(GetHashKey('WEAPON_ARM'))] = 'Bras de squelette',
	[tostring(GetHashKey('WEAPON_LEG'))] = 'Jambe de squelette',
	[tostring(GetHashKey('WEAPON_STAKE'))] = 'Pieu',
	[tostring(GetHashKey('WEAPON_TRIPLEBLADEDSCYTHE'))] = 'Faux triple lame',
	[tostring(GetHashKey('WEAPON_VOODOO'))] = 'Poupée vaudou',
	[tostring(GetHashKey('WEAPON_WITCHBROOM'))] = 'Balai de sorcière',
	[tostring(GetHashKey('WEAPON_SOULSCYTHE'))] = 'Faux des âmes',
	[tostring(GetHashKey('WEAPON_GRAVESTONE'))] = 'Pierre tombale',
	[tostring(GetHashKey('WEAPON_KITTBOWYAXE'))] = 'Hache démoniaque',
	[tostring(GetHashKey('WEAPON_COMBAT_MP7'))] = 'MP7 de Combat',
	[tostring(GetHashKey('WEAPON_G36'))] = 'G36',
	[tostring(GetHashKey('WEAPON_COMBAT_PISTOL_CHROMIUM'))] = 'Pistolet Chrome',
	[tostring(GetHashKey('WEAPON_SHOTGUN_CHROMIUM'))] = 'Shotgun Chrome',
	[tostring(GetHashKey('WEAPON_G3_2'))] = 'G3V2',
	[tostring(GetHashKey('WEAPON_GALILARV2'))] = 'GAL',
	[tostring(GetHashKey('WEAPON_SR_3M_CHR'))] = 'SR-3M',
	[tostring(GetHashKey('WEAPON_GROZA'))] = 'Groza',
	[tostring(GetHashKey('WEAPON_NUTCRACKER'))] = 'Casse Noisette',
	[tostring(GetHashKey('WEAPON_SNOWSHOVEL'))] = 'Pêle de Noel',
	[tostring(GetHashKey('WEAPON_CANECANDY'))] = 'Sucre rouge',
	[tostring(GetHashKey('WEAPON_CANECANDYGREEN'))] = 'Sucre Vert',
	[tostring(GetHashKey('WEAPON_CANDYCUT'))] = 'Couteau de Noel',
	[tostring(GetHashKey('WEAPON_CHRISTMASBAT'))] = 'Batte de Noel',
	[tostring(GetHashKey('WEAPON_CHRISTMASMACHETE'))] = 'Machette de Noel',
	[tostring(GetHashKey('WEAPON_CHRISTMASPILLOW'))] = 'Oreiller de Noel',
	[tostring(GetHashKey('WEAPON_CHRISTMASPLUSH'))] = 'Plush de Noel',
	[tostring(GetHashKey('WEAPON_CHRISTMASTREE'))] = 'Sapin de Noel',
	[tostring(GetHashKey('WEAPON_HOCKEYSTICK'))] = 'Baton de hockey',
	[tostring(GetHashKey('WEAPON_ICEAXE'))] = 'Hache Hiver',
	[tostring(GetHashKey('WEAPON_ICEBAT'))] = 'Batte Hiver',
	[tostring(GetHashKey('WEAPON_ICEBAT2'))] = 'Batte Hiver',
	[tostring(GetHashKey('WEAPON_ICEBIGAXE'))] = 'Hache Hiver',
	[tostring(GetHashKey('WEAPON_ICECUT'))] = 'Couteau Hiver',
	[tostring(GetHashKey('WEAPON_ICEKATANA'))] = 'Katana Hiver',
	[tostring(GetHashKey('WEAPON_ICELANTERN'))] = 'Lanterne Hiver',
	[tostring(GetHashKey('WEAPON_ICEPICK'))] = 'Pic de Glace',
	[tostring(GetHashKey('WEAPON_ICESKI'))] = 'Ski',
	[tostring(GetHashKey('WEAPON_UZI_ARCBYTE'))] = 'UZI Arcbyte',
	[tostring(GetHashKey('WEAPON_RRC3_ACHROMIC'))] = 'Achromic',
}

weaponsMelee = {
    "weapon_dagger",
    "weapon_bat",
    "weapon_bottle",
    "weapon_crowbar",
    "weapon_unarmed",
    "weapon_flashlight",
    "weapon_golfclub",
    "weapon_hammer",
    "weapon_hatchet",
    "weapon_knuckle",
    "weapon_knife",
    "weapon_machete",
    "weapon_switchblade",
    "weapon_nightstick",
    "weapon_wrench",
    "weapon_battleaxe",
    "weapon_poolcue",
    "weapon_stone_hatchet",
    "weapon_katana",
    "weapon_machette_ballas",
    "weapon_machette_vagos",
    "weapon_machette_families",
    "WEAPON_PEPPERSPRAY",
    "WEAPON_ANTIDOTE",
	"WEAPON_BATAQ",
	"WEAPON_CHAINSAW",
	"WEAPON_SLICE",
	"WEAPON_DEMHAMMER",
	"WEAPON_KARAMBIT",
	"WEAPON_CANDYCANE",
	"WEAPON_CANDYKNIFE",
	"WEAPON_CARROTSWORD",
	"WEAPON_PATRIOTKNIFE",
	"WEAPON_FRYINPAN",
    "WEAPON_AXE",
    "WEAPON_BARBEDBAT",
    "WEAPON_BATON",
    "WEAPON_BLACKKATANA",
    "WEAPON_BLUEZK",
    "WEAPON_BROWNMACHETE",
    "WEAPON_BUTCHER",
    "WEAPON_CHAIR",
    "WEAPON_CRUTCH",
    "WEAPON_DILDO",
    "WEAPON_EGUITAR",
    "WEAPON_GUITAR",
    "WEAPON_HUNTERKNIFE",
    "WEAPON_ICECLIMBER",
    "WEAPON_KITCHENKNIFE",
    "WEAPON_KUKRI",
    "WEAPON_LONGMACHETE",
    "WEAPON_MACE",
    "WEAPON_PICKAXE",
    "WEAPON_PINKZK",
    "WEAPON_PITCHFORK",
    "WEAPON_REDZK",
    "WEAPON_SCIFISWORD",
    "WEAPON_SCIMITAR",
    "WEAPON_SCREWDRIVER",
    "WEAPON_SCYTHE",
    "WEAPON_SHOVEL",
    "WEAPON_SLEDGEHAMMER",
    "WEAPON_SPIKEDKNUCKLES",
    "WEAPON_SPIKEYBAT",
    "WEAPON_STOPSIGN",
    "WEAPON_TACAXE",
    "WEAPON_TACCLEAVER",
    "WEAPON_TACTICALHATCHET",
    "WEAPON_THORSHAMMER",
    "WEAPON_TWOHBATTLEAXE",
    "WEAPON_WCLAWS",
    "WEAPON_ZK",
	"WEAPON_DIRTYSYRINGE",
	"WEAPON_PEELER",
	"WEAPON_RULER",
	"WEAPON_BIGSPOON",
	"WEAPON_JABSAW",
	"WEAPON_TELESCOPE",
	"WEAPON_MEATSKEWER",
	"WEAPON_SWORDFISH",
	"WEAPON_LOBSTER",
	"WEAPON_PLIERS",
	"WEAPON_HANDDRILL",
	"WEAPON_TWISTEDSPEAR",
	"WEAPON_SNAKEKNIFE",
	"WEAPON_CRUTCHKNIFE",
	"WEAPON_SHARPARROW",
	"WEAPON_95SIGN",
	"WEAPON_ASSASINGUN",
	"WEAPON_BAGUETTE",
	"WEAPON_BANANA",
	"WEAPON_BIKE",
	"WEAPON_BONE",
	"WEAPON_BONESWORD",
	"WEAPON_BUTTPLUG",
	"WEAPON_CACTUS",
	"WEAPON_CAMSHAFT",
	"WEAPON_CARJACK",
	"WEAPON_CONE",
	"WEAPON_CROSSSPANNER",
	"WEAPON_CUCUMBER",
	"WEAPON_DISABLEDSIGN",
	"WEAPON_ELDERSWAND",
	"WEAPON_MFIREEXTINGUISHER",
	"WEAPON_FISHINGROD",
	"WEAPON_GASCYLINDER",
	"WEAPON_HOCKEYFSTICK",
	"WEAPON_HORN",
	"WEAPON_JDBOTTLE",
	"WEAPON_KEYBOARD",
	"WEAPON_KITCHENFORK",
	"WEAPON_LACROSSESTICK",
	"WEAPON_LADDER",
	"WEAPON_MAILBOX",
	"WEAPON_MIC",
	"WEAPON_NOPARKINGSIGN",
	"WEAPON_PEN",
	"WEAPON_PENCIL",
	"WEAPON_PROSLEG",
	"WEAPON_ROLLINGPIN",
	"WEAPON_RONABOTTLE",
	"WEAPON_ROUTE66SIGN",
	"WEAPON_SCOOTER",
	"WEAPON_SHOCKABSORBER",
	"WEAPON_SKULLBAT",
	"WEAPON_SPARTANSWORD",
	"WEAPON_SPATULA",
	"WEAPON_STEPLADDER",
	"WEAPON_STREETLIGHT",
	"WEAPON_TOASTER",
	"WEAPON_VACUUM",
	"WEAPON_WRONGWAYSIGN",
	"WEAPON_YARI",
	"WEAPON_BLACKBELT",
	"WEAPON_BENTFORK",
	"WEAPON_BLACKBACKPACK",
	"WEAPON_BRCHICKEN",
	"WEAPON_DOORBARS",
	"WEAPON_EARBUDBLADE",
	"WEAPON_HONEYDIPPER",
	"WEAPON_KETTLE",
	"WEAPON_LEATHERBRIEFCASE",
	"WEAPON_MAKESHIFTKNIFE",
	"WEAPON_MEASURINGCUP",
	"WEAPON_MODDEDNIGHTSTICK",
	"WEAPON_TRAYRACK",
	"WEAPON_POKER",
	"WEAPON_PRISONKEY",
	"WEAPON_VIOBACKPACK",
	"WEAPON_REDBACKPACK",
	"WEAPON_TEAPOT",
	"WEAPON_PRISTOI",
	"WEAPON_SHIV",
	"WEAPON_KITTBOWYAXE",
	"WEAPON_UNICORNHORN",
	"WEAPON_BRUNETTEDOLL",
	"WEAPON_BLONDEDOLL",
	"WEAPON_ANIMEDOLL",
	"WEAPON_WEDDINGRING",
	"WEAPON_FEGUITAR",
	"WEAPON_FGUITAR",
	"WEAPON_BABYCHAIRFOOD",
	"WEAPON_TWEEZERS",
	"WEAPON_PINKSWITCHBLADE",
	"WEAPON_KITTYAXE",
	"WEAPON_BABYSEAT",
	"WEAPON_TWIRLPOP",
	"WEAPON_ROUNDLOLLY",
	"WEAPON_HSLOLLY",
	"WEAPON_BUTTERLOLLY",
	"WEAPON_STEAMIRON",
	"WEAPON_HAIRBRUSH",
	"WEAPON_PINKLOLLY",
	"WEAPON_LOLLYBAT",
	"WEAPON_CANDYKNIFE",
	"WEAPON_ROSEKNIFE",
	"WEAPON_LIPSTICK",
	"WEAPON_BLPURSE",
	"WEAPON_PINKPOOLNOODLE",
	"WEAPON_WHITEPILLOW",
	"WEAPON_PINKPILLOW",
	"WEAPON_FTEDDYPINK",
	"WEAPON_FTEDDY",
	"WEAPON_VIBRATOR",
	"WEAPON_FDUALSWORD",
	"WEAPON_CRYSTALROD",
	"WEAPON_FZVTWO",
	"WEAPON_FSLIPPERS",
	"WEAPON_BLOSSOMKNIFE",
	"WEAPON_BLOSSOMKATANA",
	"WEAPON_FHATCHET",
	"WEAPON_FKNUCKLE",
	"WEAPON_CHRIBAG",
	"WEAPON_FBLACKHEEL",
	"WEAPON_FPINKHEEL",
	"WEAPON_FREDHEEL",
	"WEAPON_FBAT",
	"WEAPON_FSPIKEBAT",
	"WEAPON_FPICKAXE",
	"WEAPON_FCOMB",
	"WEAPON_PINKKEYBOARD",
	"WEAPON_SPIKEDCHOKER",
	"WEAPON_PINKCHOKER",
	"WEAPON_PINKPEPPERSPRAY",
	"WEAPON_BLOWDRYER",
	"WEAPON_BOBSFISHINGNET",
	"WEAPON_DRAGONDOLL",
	"WEAPON_WEAPON_FCLOSEDUMBRELLA",
	"WEAPON_FLAMINGO",
	"WEAPON_FSCEPTER",
	"WEAPON_FUMBRELLA",
	"WEAPON_GOLDDIGGER",
	"WEAPON_HAIRPIN",
	"WEAPON_HEARTBAG",
	"WEAPON_KERBSDOLL",
	"WEAPON_KETTLEBALL",
	"WEAPON_MARSHSTICK",
	"WEAPON_MERMAID",
	"WEAPON_MOUSEDOLL",
	"WEAPON_OCTOPUSDOLL",
	"WEAPON_PINKBOLTCUTTERS",
	"WEAPON_PINKFAXE",
	"WEAPON_PINKFPICKAXE",
	"WEAPON_PINKHAMMER",
	"WEAPON_PINKHANDFAN",
	"WEAPON_PINKKNIGHTSTICK",
	"WEAPON_PINKSCREWDRIVER",
	"WEAPON_PSLEDGE",
	"WEAPON_TIARA",
	"WEAPON_LUUBAG",
	"WEAPON_PINKCUTTER",
	"WEAPON_PINKCYBERSWORD",
	"WEAPON_RADABAG",
	"WEAPON_BONECLUB",
	"WEAPON_BUCKET",
	"WEAPON_COFFIN",
	"WEAPON_DEATHNOTE",
	"WEAPON_HELLFIRESWORD",
	"WEAPON_INFERNO",
	"WEAPON_PUMPKIN",
	"WEAPON_PUMPKINBAT",
	"WEAPON_ARM",
	"WEAPON_LEG",
	"WEAPON_STAKE",
	"WEAPON_TRIPLEBLADEDSCYTHE",
	"WEAPON_VOODOO",
	"WEAPON_WITCHBROOM",
	"WEAPON_SOULSCYTHE",
	"WEAPON_GRAVESTONE",
	"WEAPON_KITTBOWYAXE",
	"WEAPON_NUTCRACKER",
	"WEAPON_SNOWSHOVEL",
	"WEAPON_CANECANDY",
	"WEAPON_CANECANDYGREEN",
	"WEAPON_CANDYCUT",
	"WEAPON_CHRISTMASBAT",
	"WEAPON_CHRISTMASMACHETE",
	"WEAPON_CHRISTMASPILLOW",
	"WEAPON_CHRISTMASPLUSH",
	"WEAPON_CHRISTMASTREE",
	"WEAPON_HOCKEYSTICK",
    "WEAPON_ICEAXE",
    "WEAPON_ICEBAT",
    "WEAPON_ICEBAT2",
    "WEAPON_ICEBIGAXE",
    "WEAPON_ICECUT",
    "WEAPON_ICEKATANA",
    "WEAPON_ICELANTERN",
    "WEAPON_ICEPICK",
    "WEAPON_ICESKI"
}

AddEventHandler("esx:onPlayerDeath", function (data)
	local DeathReason, Killer, DeathCauseHash, Weapon
	DeathCauseHash = data.deathCause
	local PedKiller = data.killedByPlayer
	PedKiller2 = GetPedSourceOfDeath(PlayerPedId())

	Weapon = WeaponNames[tostring(DeathCauseHash)]
	if PedKiller and IsEntityAPed(PedKiller2) and IsPedAPlayer(PedKiller2) then
		Killer = NetworkGetPlayerIndexFromPed(PedKiller2)
	elseif PedKiller and IsEntityAVehicle(PedKiller2) and IsEntityAPed(GetPedInVehicleSeat(PedKiller2, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller2, -1)) then
		Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller2, -1))
	end
	
	if (Killer == PlayerId()) then
		DeathReason = 'A commis un suicide'
	elseif (Killer == nil) then
		DeathReason = 'A commis un suicide ou écraser par un pnj'
	else

		local list = ESX.GetWeaponListConti()
		for key, value in pairs(list) do
			if GetHashKey(value.nameItem) == DeathCauseHash then
				DeathReason = "mort par une arme"
			end
		end
		if IsMelee(DeathCauseHash) then
			DeathReason = 'assassiné'
		elseif IsTorch(DeathCauseHash) then
			DeathReason = 'brûlé'
		elseif IsKnife(DeathCauseHash) then
			DeathReason = 'poignardé'
		elseif IsPistol(DeathCauseHash) then
			DeathReason = 'abattu par pistolet'
		elseif IsSub(DeathCauseHash) then
			DeathReason = 'mitraillé'
		elseif IsRifle(DeathCauseHash) then
			DeathReason = 'abattu par fusil'
		elseif IsLight(DeathCauseHash) then
			DeathReason = 'mitraillé par une mitrailleuse'
		elseif IsShotgun(DeathCauseHash) then
			DeathReason = 'pulvérisé'
		elseif IsSniper(DeathCauseHash) then
			DeathReason = 'tiré par un sniper'
		elseif IsHeavy(DeathCauseHash) then
			DeathReason = 'anéanti'
		elseif IsMinigun(DeathCauseHash) then
			DeathReason = 'haché'
		elseif IsBomb(DeathCauseHash) then
			DeathReason = 'bombardé'
		elseif IsVeh(DeathCauseHash) then
		DeathReason = 'écrasé par un véhicule'
		elseif IsVK(DeathCauseHash) then
			DeathReason = 'aplati'
		else
			DeathReason = 'tué par une arme ou quelque choses de similaire'
		end
		
	end
	local playerPed = PlayerPedId()
	local causeOfDeath = GetPedCauseOfDeath(playerPed)
	local killer = GetPedSourceOfDeath(playerPed)
	if IsEntityAVehicle(killer) then
		local vehicleModel = GetEntityModel(killer)
		local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
		local plate = GetVehicleNumberPlateText(killer)
		local maxPassengers = GetVehicleMaxNumberOfPassengers(killer)
		
		for seat = -1, maxPassengers - 1 do
			local passenger = GetPedInVehicleSeat(killer, seat)
			if passenger ~= 0 then -- Check if the seat is not empty
				local pedType = GetPedType(passenger)
				if pedType ~= 28 then -- 28 is for animals
					local passengerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger))
					if seat == -1 then 
						DeathReason = "Conducteur du véhicule ("..plate..") " .. seat .. ": Player ID " .. passengerServerId.." Name :"..GetPlayerName(GetPlayerFromServerId(passengerServerId))
						Killer = GetPlayerFromServerId(passengerServerId)
					end
				end
			end
		end
	end
	local faim, soif = exports["foodsystem"]:whatisthisgoingon()
	
	if faim and soif and( tonumber(faim) <= 0 or tonumber(soif) <= 0 )then
		DeathReason = "mort de soif ou de faim (faim = "..faim.." soif = "..soif..")"
	end
	if (Killer == PlayerId()) or Killer == nil then
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -1975.2670898438, -2033.1165771484, 1771.8686523438, true) >= 110 then
			TriggerServerEvent('catcher:addKill', DeathReason, Weapon, GetPlayerServerId(PlayerId()))
		end
	else
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -1975.2670898438, -2033.1165771484, 1771.8686523438, true) >= 110 then
			TriggerServerEvent('catcher:addKill', DeathReason, Weapon, GetPlayerServerId(Killer))
		end
	end
	Killer = nil
	DeathReason = nil
	DeathCauseHash = nil
	Weapon = nil
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

-- Antiped crashing

Citizen.CreateThread(function()
    while true do
        for a,q in pairs(GetActivePlayers()) do
            if Animals[GetEntityModel(GetPlayerPed(q))] then
				-- find way
            end
        end
        Citizen.Wait(500)
    end
end)

-- Disable headshots

Citizen.CreateThread(function ()
    while true do
		SetPedSuffersCriticalHits(PlayerPedId(), false)
        Citizen.Wait(30000)
    end
end)

-- Disable aim assist

--Citizen.CreateThread(function()
--    while true do
--        local isArmed = false
--
--        local melee = false
--        for k,v in pairs(weaponsMelee) do
--            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(v) then
--                melee = true
--            end
--        end
--
--        if not melee and IsPedArmed(PlayerPedId(), 7) then
--            isArmed = true
--            SetPlayerLockon(PlayerId(), false)
--        else
--            SetPlayerLockon(PlayerId(), true)
--        end
--
--        if isArmed then
--            Citizen.Wait(0)
--        else
--            Citizen.Wait(1000)
--        end
--    end
--end)

local whitelistedRL = {
    [GetHashKey("WEAPON_SNSPISTOL")]     = true,
    [GetHashKey("WEAPON_PISTOL")]        = true,
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOL50")]       = true,
    [GetHashKey("WEAPON_REVOLVER")]      = true,
    [GetHashKey("WEAPON_APPISTOL")]      = true,
    [GetHashKey("WEAPON_STUNGUN")]       = true,
    [GetHashKey("WEAPON_COMBATPISTOL")]  = true,
    [GetHashKey("WEAPON_HEAVYPISTOL")]   = true,
    [GetHashKey("WEAPON_G19")]         = true,
    [GetHashKey("WEAPON_DOUBLEACTION")]  = true,
    [GetHashKey("WEAPON_GADGETPISTOL")]  = true,
    [GetHashKey("WEAPON_CERAMICPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOL50")]      = true,
    [GetHashKey("WEAPON_PISTOL_MK2")]    = true,
	[GetHashKey("WEAPON_MINISMG")]    = true,
	[GetHashKey("WEAPON_MACHINEPISTOL")]    = true,
	[GetHashKey("WEAPON_MICROSMG")]    = true,
	[GetHashKey("WEAPON_MACHINE_PISTOL_RED_CHR")]    = true,
	[GetHashKey("WEAPON_EXTENDEDSMG")]    = true,
	[GetHashKey("WEAPON_MP9")]    = true,
	[GetHashKey("WEAPON_AK_SHORTSTOCK_CHR")]    = true,
	[GetHashKey("WEAPON_PISTOLXM3")]    = true,
	[GetHashKey("WEAPON_TECPISTOL")]    = true,
	[GetHashKey("WEAPON_FLAREGUN")]    = true,
	[GetHashKey("WEAPON_357")]    = true,
	[GetHashKey("WEAPON_PISTOLXMAS")]    = true,
	[GetHashKey("WEAPON_PF940")]    = true,
	[GetHashKey("WEAPON_MP7_CHROMIUM")]    = true,
	[GetHashKey("WEAPON_VECTOR")]    = true,
	[GetHashKey("WEAPON_SB4S")]    = true,
	[GetHashKey("WEAPON_HKUSP")]    = true,
	[GetHashKey("WEAPON_WOLFKNIFE")]    = true,
	[GetHashKey("WEAPON_VX_SCORPION_CHR")]    = true,
	[GetHashKey("WEAPON_MICRO_9_CHR")]    = true,
	[GetHashKey("WEAPON_MINISMG_PINKSPIKE")]    = true,
}

Citizen.CreateThread(function()
    while true do
        local isArmed = false
		local playerCoords = GetEntityCoords(PlayerPedId())
        local distanceToCenter = #(playerCoords - vector3(5367.2231445312, -1106.7100830078, 355.20947265625))

        if IsPedArmed(PlayerPedId(), 6) and distanceToCenter > 120.0 then
            isArmed = true

			DisableControlAction(1, 140, true) -- Disable weapon whipping
            DisableControlAction(1, 141, true) -- Disable weapon whipping
            DisableControlAction(1, 142, true) -- Disable weapon whipping

            if IsControlPressed(0, 25) then
                local hash = GetSelectedPedWeapon(PlayerPedId())
                if not whitelistedRL[hash] then
                    if GetSelectedPedWeapon(PlayerPedId()) == hash then
                        DisableControlAction(0, 22)
                    end
                end
            end
        end

        if isArmed then
            Citizen.Wait(10)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
		SetPedConfigFlag(PlayerPedId(), 149, true) -- Disable helmet anti-damages
		SetPedConfigFlag(PlayerPedId(), 438, true)
		SetWeaponDrops()
        Citizen.Wait(1000)
    end
end)

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

-- Anti roll car

Citizen.CreateThread(function()
	while true do
		local isRoll = false
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		local roll = GetEntityRoll(vehicle)

		if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
			isRoll = true
			DisableControlAction(2,59,true)
			DisableControlAction(2,60,true)
		end

		if isRoll == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetEntityProofs(PlayerPedId(), false, true, true, true, false, false, false, true)
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        Citizen.Wait(0)
    end
end)

AddEventHandler("onClientResourceStart", function(resName)
    if resName == GetCurrentResourceName() then
        TriggerServerEvent("miawget:hbReady")
    end
end)

RegisterNetEvent("miawget:hbPing", function(token)
    TriggerServerEvent("miawget:hbBack", token)
end)

-----------------------------

--local cfg_cataloguePDM = {}
--
--cfg_cataloguePDM.vehicles = {
--    {
--        cat_name = "Véhicules Imports",
--        value = "imports",
--        vehicles = {
--
--            {name = "Schlagen SP", hash = "gbschlagensp", price = 9800000},
--            {name = "Eon", hash = "gbeon", price = 3800000},
--            {name = "Solace", hash = "gbsolace", price = 8700000},
--            {name = "Schlagen R", hash = "gbschlagenr", price = 8900000},
--            {name = "Starlight", hash = "gbstarlight", price = 3650000},
--            {name = "Neon CT", hash = "gbneonct", price = 6600000},
--            {name = "Asteropers", hash = "asteropers", price = 7000000},
--            {name = "Beretta", hash = "beretta", price = 3400000},
--            {name = "Callista", hash = "callista", price = 4500000},
--            {name = "Contender C", hash = "contenderc", price = 6900000},
--            {name = "Elegy X", hash = "elegyx", price = 6700000},
--            {name = "Eva", hash = "eva", price = 750000},
--            {name = "Everon B", hash = "everonb", price = 5400000},
--            {name = "Gauntlet C", hash = "gauntletc", price = 6300000},
--            {name = "Gresley Hellfire", hash = "gresleyh", price = 6345000},
--            {name = "Howitzer", hash = "howitzer", price = 2500000},
--            {name = "Elegyrh7", hash = "elegyrh7", price = 8500000},
--            {name = "Nexus", hash = "nexus", price = 9500000},
--            {name = "Osirisr", hash = "osirisr", price = 14200000},
--            {name = "Tempesta2", hash = "tempesta2", price = 13000000},
--            {name = "Comet6scw", hash = "comet6scw", price = 7600000},
--            {name = "Oraclelwb", hash = "oraclelwb", price = 6300000},
--            {name = "Deimos", hash = "deimos", price = 7800000},
--            {name = "Odyssey", hash = "odyssey", price = 6500000},
--            {name = "Jd_oraclev12", hash = "jd_oraclev12", price = 2700000},
--            {name = "Infernus4", hash = "infernus4", price = 6750000},
--            {name = "Ariant", hash = "ariant", price = 1800000},
--            {name = "Bansheepo", hash = "bansheepo", price = 6000000},
--            {name = "Kawaii", hash = "kawaii", price = 5900000},
--            {name = "Schafter3rs", hash = "schafter3rs", price = 7650000},
--            {name = "Torrence", hash = "torrence", price = 9000000},
--            {name = "Expression", hash = "expression", price = 10400000},
--            {name = "Cwagon", hash = "cwagon", price = 3800000},
--            {name = "Zentorno2", hash = "zentorno2", price = 16750000},
--            {name = "Pentrogpr2", hash = "pentrogpr2", price = 3600000},
--            {name = "Oracxsle", hash = "oracxsle", price = 8300000},
--            {name = "Apollo", hash = "apollo", price = 7450000},
--        },        
--    },
--    {
--        cat_name = "Véhicules 2024",
--        value = "new",
--        vehicles = {
--            {name = "Astron", hash = "astron", price = 1580000},
--            {name = "Baller ST", hash = "baller7", price = 890000},
--            {name = "Buffalo STX", hash = "buffalo4", price = 2150000},
--            {name = "Calico GTF", hash = "calico", price = 1995000},
--            {name = "Champion", hash = "champion", price = 3750000},
--            {name = "Cinquemila", hash = "cinquemila", price = 1740000},
--            {name = "Comet S2", hash = "comet6", price = 1878000},
--            {name = "Comet S2 Cabrio", hash = "comet7", price = 1797000},
--            {name = "Dominator ASP", hash = "dominator7", price = 1775000},
--            {name = "Dominator GTT", hash = "dominator8", price = 1220000},
--            {name = "Beater Dukes", hash = "dukes3", price = 378000},
--            {name = "Futo GTX", hash = "futo2", price = 1590000},
--            {name = "Growler", hash = "growler", price = 1627000},                        
--            {name = "Ignus", hash = "ignus", price = 2765000},
--            {name = "I-Wagen", hash = "iwagen", price = 1720000},
--            {name = "JB 700", hash = "jb700", price = 475000},
--            {name = "Mesa 3", hash = "mesa3", price = 870000},
--            {name = "Previon", hash = "previon", price = 1490000},
--            {name = "Remus", hash = "remus", price = 1370000},
--            {name = "Ruiner ZZ-8", hash = "ruiner4", price = 1320000},
--            {name = "Sadler", hash = "sadler", price = 650000}, 
--            {name = "Sultan RS Classic", hash = "sultan3", price = 1789000},    
--            {name = "Surfer Custom", hash = "surfer3", price = 590000},
--            {name = "Vamos", hash = "vamos", price = 596000 },
--            {name = "Warrener HKR", hash = "warrener2", price = 1260000},
--            {name = "Weevil Custom", hash = "weevil2", price = 980000},                        
--            {name = "Youga Custom", hash = "youga4", price = 980000},                                     
--            {name = "Zeno", hash = "zeno", price = 2820000},
--            {name = "Zentorno", hash = "zentorno", price = 725000},
--            {name = "ZR350", hash = "zr350", price = 1615000},
--            {name = "Kuruma", hash = "kuruma", price = 575000},
--        },
--    },
--    {
--        cat_name = "Compactes",
--        value = "compacts",
--        vehicles = {
--            {name = "Asbo", hash = "asbo", price = 408000},
--            {name = "Blista", hash = "blista", price = 580000},
--            {name = "Brioso R/A", hash = "brioso", price = 155000},
--            {name = "Brioso 300", hash = "brioso2", price = 610000},
--            {name = "Brioso 300 Widebody", hash = "brioso3", price = 585000},
--            {name = "Club", hash = "club", price = 1280000 },
--            {name = "Dilettante", hash = "dilettante", price = 60000},
--            {name = "Blista Kanjo", hash = "kanjo", price = 580000},
--            {name = "Issi", hash = "issi2", price = 60000},
--            {name = "Issi Classic", hash = "issi3", price = 360000},
--            {name = "Panto", hash = "panto", price = 85000},
--            {name = "Prairie", hash = "prairie", price = 75000},
--            {name = "Rhapsody", hash = "rhapsody", price = 140000},
--            {name = "Weevil", hash = "weevil", price = 870000},                        
--            {name = "Weevil Custom", hash = "weevil2", price = 980000},                        
--        },
--    },
--    {
--        cat_name = "Coupés",
--        value = "coupes",
--        vehicles = {
--            {name = "Cognoscenti Cabrio", hash = "cogcabrio", price = 275000},
--            {name = "Exemplar", hash = "exemplar", price = 275000 },
--            {name = "F620", hash = "f620", price = 275000},                        
--            {name = "Felon", hash = "felon", price = 275000},
--            {name = "Felon GT", hash = "felon2", price = 275000},
--            {name = "Jackal", hash = "jackal", price = 275000},
--            {name = "Oracle XS", hash = "oracle", price = 275000},
--            {name = "Oracle", hash = "oracle2", price = 275000},
--            {name = "Previon", hash = "previon", price = 275000},
--            {name = "Postlude", hash = "postlude", price = 275000},
--            {name = "Sentinel XS", hash = "sentinel", price = 275000},
--            {name = "Sentinel", hash = "sentinel2", price = 275000},
--            {name = "Tahoma Coupe", hash = "tahoma", price = 275000},
--            {name = "Kanjo SJ", hash = "kanjosj", price = 275000},
--            {name = "Virtue", hash = "virtue", price = 950000},
--            {name = "Windsor", hash = "windsor", price = 845000},
--            {name = "Windsor Drop", hash = "windsor2", price = 1250000},
--            {name = "Zion", hash = "zion", price = 275000},
--            {name = "Zion Cabrio", hash = "zion2", price = 275000},                       
--        },
--    },
--    {
--        cat_name = "SUVs",
--        value = "suvs",
--        vehicles = {
--            {name = "Astron", hash = "astron", price = 150000},
--            {name = "Baller", hash = "baller", price = 150000},
--            {name = "Baller", hash = "baller2", price = 225000},
--            {name = "Baller LE", hash = "baller3", price = 300000}, 
--            {name = "Baller LE LWB", hash = "baller4", price = 550000},
--            {name = "Baller ST", hash = "baller7", price = 550000},
--            {name = "BeeJay XL", hash = "bjxl", price = 150000},
--            {name = "Cavalcade", hash = "cavalcade", price = 150000},
--            {name = "Cavalcade", hash = "cavalcade2", price = 175000},
--            {name = "Contender", hash = "contender", price = 350000},
--            {name = "Dubsta", hash = "dubsta", price = 225000},
--            {name = "Dubsta", hash = "dubsta2", price = 325000},
--            {name = "Granger", hash = "granger", price = 450000},
--            {name = "Granger 3600LX", hash = "granger2", price = 650000},
--            {name = "FQ 2", hash = "fq2", price = 250000},
--            {name = "Gresley", hash = "gresley", price = 225000},
--            {name = "Habanero", hash = "habanero", price = 225000},
--            {name = "Huntley S", hash = "huntley", price = 250000},
--            {name = "Issi Rally", hash = "issi8", price = 75000},
--            {name = "I-Wagen", hash = "iwagen", price = 75000},
--            {name = "Landstalker", hash = "landstalker", price = 225000},
--            {name = "Landstalker XL", hash = "landstalker2", price = 350000},
--            {name = "Mesa", hash = "mesa", price = 450000},
--            {name = "Novak", hash = "novak", price = 350000},
--            {name = "Patriot", hash = "patriot", price = 450000},
--            {name = "Patriot Stretchaucun", hash = "patriot2", price = 1200000},
--            {name = "Radius", hash = "radi", price = 225000},
--            {name = "Rebla GTS", hash = "rebla", price = 1225000},
--            {name = "Rocoto", hash = "rocoto", price = 650000}, 
--            {name = "Sadler", hash = "sadler", price = 650000}, 
--            {name = "Seminole", hash = "seminole", price = 375000},
--            {name = "Seminole Frontier", hash = "seminole2", price = 450000},
--            {name = "Serrano", hash = "serrano", price = 225000}, 
--            {name = "Toros", hash = "toros", price = 750000},
--            {name = "XLS", hash = "xls", price = 350000},
--            {name = "Squaddie", hash = "squaddie", price = 650000},                   
--        },
--    },
--    {
--        cat_name = "Berlines",
--        value = "sedans",
--        vehicles = {
--            {name = "Asea", hash = "asea", price = 150000},
--            {name = "Asterope", hash = "asterope", price = 160000},
--            {name = "Cognoscenti 55", hash = "cog55", price = 220000},                        
--            {name = "Cognoscenti", hash = "cognoscenti", price = 225000},
--            {name = "Emperor", hash = "emperor", price = 150000},
--            {name = "Emperor", hash = "emperor2", price = 145000},
--            {name = "Fugitive", hash = "fugitive", price = 160000},
--            {name = "Glendale", hash = "glendale", price = 145000},
--            {name = "Glendale Custom", hash = "glendale2", price = 160000},
--            {name = "Ingot", hash = "ingot", price = 145000},
--            {name = "Intruder", hash = "intruder", price = 160000},
--            {name = "Premier", hash = "premier", price = 150000},
--            {name = "Primo", hash = "primo", price = 175000},
--            {name = "Primo Custom", hash = "primo2", price = 250000},
--            {name = "Regina", hash = "regina", price = 150000},
--            {name = "Romero Hearse", hash = "romero", price = 350000},
--            {name = "Stafford", hash = "stafford", price = 275000},
--            {name = "Stanier", hash = "stanier", price = 150000},
--            {name = "Stratum", hash = "stratum", price = 175000},
--            {name = "Stretch", hash = "stretch", price = 650000},
--            {name = "Super Diamond", hash = "superd", price = 350000},
--            {name = "Surge", hash = "surge", price = 175000},
--            {name = "Tailgater", hash = "tailgater", price = 180000},
--            {name = "Tailgater S", hash = "tailgater2", price = 380000},
--            {name = "Warrener", hash = "warrener", price = 225000},
--            {name = "Warrener HKR", hash = "warrener2", price = 225000},
--            {name = "Washington", hash = "washington", price = 250000},                        
--        },
--    },
--    {
--        cat_name = "Sportives",
--        value = "sports",
--        vehicles = {
--            {name = "Alpha", hash = "alpha", price = 425000},
--            {name = "Banshee", hash = "banshee", price = 625000},
--            {name = "Bestia GTS", hash = "bestiagts", price = 750000},                        
--            {name = "Blista Compact", hash = "blista2", price = 375000},
--            {name = "Go Go Monkey Blista", hash = "blista3", price = 425000},
--            {name = "Buffalo", hash = "buffalo", price = 425000},
--            {name = "Buffalo S", hash = "buffalo2", price = 550000},
--            {name = "Sprunk Buffalo", hash = "buffalo3", price = 625000},
--            {name = "Calico GTF", hash = "calico", price = 625000},
--            {name = "Carbonizzare", hash = "carbonizzare", price = 625000},
--            {name = "Comet", hash = "comet2", price = 625000},
--            {name = "Comet Retro Custom", hash = "comet3", price = 675000},
--            {name = "Comet Safari", hash = "comet4", price = 675000},
--            {name = "Comet SR", hash = "comet5", price = 625000},
--            {name = "Comet S2", hash = "comet6", price = 625000},
--            {name = "Comet S2 Cabrio", hash = "comet7", price = 625000},
--            {name = "Coquette", hash = "coquette", price = 625000},
--            {name = "Coquette D10", hash = "coquette4", price = 675000},
--            {name = "Corsita", hash = "corsita", price = 550000},
--            {name = "8F Drafter", hash = "drafter", price = 625000},
--            {name = "Deveste Eight", hash = "deveste", price = 825000},
--            {name = "Elegy Retro Custom", hash = "elegy", price = 725000},
--            {name = "Elegy RH8", hash = "elegy2", price = 775000},
--            {name = "Euros", hash = "euros", price = 775000},
--            {name = "Hotring Everon", hash = "everon2", price = 350000},
--            {name = "Feltzer", hash = "feltzer2", price = 625000},
--            {name = "Flash GT", hash = "flashgt", price = 425000},
--            {name = "Furore GT", hash = "furoregt", price = 625000},
--            {name = "Fusilade", hash = "fusilade", price = 425000},
--            {name = "Futo", hash = "futo", price = 425000},
--            {name = "Futo GTX", hash = "futo2", price = 425000},
--            {name = "GB200", hash = "gb200", price = 625000},                        
--            {name = "Growler", hash = "growler", price = 625000},                        
--            {name = "Hotring Sabre", hash = "hotring", price = 1050000},
--            {name = "Komoda", hash = "komoda", price = 725000},
--            {name = "Imorgon", hash = "imorgon", price = 750000},                        
--            {name = "Issi Sport", hash = "issi7", price = 475000},
--            {name = "Itali GTO", hash = "italigto", price = 865000},
--            {name = "Jugular", hash = "jugular", price = 850000},
--            {name = "Jester", hash = "jester", price = 675000},
--            {name = "Jester (Racecar)", hash = "jester2", price = 875000},
--            {name = "Jester Classic", hash = "jester3", price = 675000},
--            {name = "Jester RR", hash = "jester4", price = 675000},
--            {name = "Khamelion", hash = "khamelion", price = 575000},
--            {name = "Kuruma", hash = "kuruma", price = 575000},
--            {name = "Locust", hash = "locust", price = 575000},
--            {name = "Lynx", hash = "lynx", price = 595000},
--            {name = "Massacro", hash = "massacro", price = 625000},
--            {name = "Massacro (Racecar)", hash = "massacro2", price = 750000},
--            {name = "Neo", hash = "neo", price = 775000},
--            {name = "Neon", hash = "neon", price = 825000},
--            {name = "9F", hash = "ninef", price = 750000},
--            {name = "9F Cabrio", hash = "ninef2", price = 800000},
--            {name = "Omnis", hash = "omnis", price = 775000},
--            {name = "Omnis e-GT", hash = "omnisegt", price = 355000},
--            {name = "Panthere", hash = "panthere", price = 175000},
--            {name = "Paragon R", hash = "paragon", price = 775000},
--            {name = "Pariah", hash = "pariah", price = 850000},
--            {name = "Penumbra", hash = "penumbra", price = 625000},    
--            {name = "Penumbra FF", hash = "penumbra2", price = 750000},
--            {name = "Raiden", hash = "raiden", price = 725000},
--            {name = "Rapid GT", hash = "rapidgt", price = 675000},
--            {name = "Rapid GT", hash = "rapidgt2", price = 700000},
--            {name = "Raptor", hash = "raptor", price = 425000},
--            {name = "Remus", hash = "remus", price = 425000},
--            {name = "Revolter", hash = "revolter", price = 475000},
--            {name = "RT3000", hash = "rt3000", price = 475000},
--            {name = "Ruston", hash = "ruston", price = 450000},
--            {name = "Schafter", hash = "schafter2", price = 425000},
--            {name = "Schafter V12", hash = "schafter3", price = 575000},
--            {name = "Schafter LWB", hash = "schafter4", price = 750000},    
--            {name = "Schlagen GT", hash = "schlagen", price = 775000},
--            {name = "Schwartzer", hash = "schwarzer", price = 675000},
--            {name = "Sentinel Classic", hash = "sentinel3", price = 625000},
--            {name = "Sentinel Classic Widebody", hash = "sentinel4", price = 225000},
--            {name = "Seven-70", hash = "seven70", price = 775000},
--            {name = "Specter", hash = "specter", price = 675000},
--            {name = "Specter Custom", hash = "specter2", price = 750000},
--            {name = "SM722", hash = "sm722", price = 785000},
--            {name = "10F", hash = "tenf", price = 520000},
--            {name = "10F Widebody", hash = "tenf2", price = 540000},
--            {name = "300R", hash = "r300", price = 250000},
--            {name = "Streiter", hash = "streiter", price = 475000},
--            {name = "Sugoi", hash = "sugoi", price = 625000},
--            {name = "Sultan", hash = "sultan", price = 650000},
--            {name = "Sultan Classic", hash = "sultan2", price = 750000},    
--            {name = "Sultan RS Classic", hash = "sultan3", price = 750000},    
--            {name = "Surano", hash = "surano", price = 750000},
--            {name = "Drift Tampa", hash = "tampa2", price = 1100000},
--            {name = "Tropos Rallye", hash = "tropos", price = 725000}, 
--            {name = "Verlierer", hash = "verlierer2", price = 575000},
--            {name = "V-STR", hash = "vstr", price = 675000},
--            {name = "Itali RSX", hash = "italirsx", price = 775000},
--        },
--    },
--    {
--        cat_name = "Super-Sportives",
--        value = "super",
--        vehicles = {
--            {name = "Adder", hash = "adder", price = 1000000},
--            {name = "Autarch", hash = "autarch", price = 1955000},
--            {name = "Banshee 900R", hash = "banshee2", price = 565000},                        
--            {name = "Bullet", hash = "bullet", price = 155000},
--            {name = "Champion", hash = "champion", price = 2812500},
--            {name = "Cheetah", hash = "cheetah", price = 650000},
--            {name = "Cyclone", hash = "cyclone", price = 1890000},
--            {name = "Entity XXR", hash = "entity2", price = 2305000},
--            {name = "Entity XF", hash = "entityxf", price = 795000},
--            {name = "Emerus", hash = "emerus", price = 2750000},
--            {name = "Entity MT", hash = "entity3", price = 2355000},
--            {name = "FMJ", hash = "fmj", price = 1750000},
--            {name = "Furia", hash = "furia", price = 2055000},
--            {name = "GP1", hash = "gp1", price = 1260000},
--            {name = "Ignus", hash = "ignus", price = 2765000},
--            {name = "Infernus", hash = "infernus", price = 440000},
--            {name = "Itali GTB", hash = "italigtb", price = 1189000},
--            {name = "Itali GTB Custom", hash = "italigtb2", price = 495000},
--            {name = "Krieger", hash = "krieger", price = 2875000},
--            {name = "RE-7B", hash = "le7b", price = 2475000},
--            {name = "Nero", hash = "nero", price = 1440000},
--            {name = "Nero Custom", hash = "nero2", price = 605000},
--            {name = "Osiris", hash = "osiris", price = 1950000},
--            {name = "Penetrator", hash = "penetrator", price = 880000},
--            {name = "811", hash = "pfister811", price = 1135000},
--            {name = "X80 Proto", hash = "prototipo", price = 2700000},
--            {name = "Reaper", hash = "reaper", price = 1595000}, 
--            {name = "S80RR", hash = "s80", price = 2575000},
--            {name = "SC1", hash = "sc1", price = 1603000},
--            {name = "ETR1", hash = "sheava", price = 1995000},
--            {name = "LM87", hash = "lm87", price = 2915000},
--            {name = "Sultan RS", hash = "sultanrs", price = 795000},
--            {name = "T20", hash = "t20", price = 2200000},
--            {name = "Taipan", hash = "taipan", price = 1980000},
--            {name = "Tempesta", hash = "tempesta", price = 1329000},
--            {name = "Tezeract", hash = "tezeract", price = 2825000},
--            {name = "Thrax", hash = "thrax", price = 2325000},
--            {name = "Tigon", hash = "tigon", price = 2310000},
--            {name = "Turismo R", hash = "turismor", price = 500000},
--            {name = "Tyrant", hash = "tyrant", price = 2515000},
--            {name = "Tyrus", hash = "tyrus", price = 2550000},
--            {name = "Vacca", hash = "vacca", price = 240000},
--            {name = "Vagner", hash = "vagner", price = 1535000},
--            {name = "Visione", hash = "visione", price = 2250000},
--            {name = "Voltic", hash = "voltic", price = 150000},
--            {name = "XA-21", hash = "xa21", price = 2375000},
--            {name = "Zeno", hash = "zeno", price = 2820000},
--            {name = "Zentorno", hash = "zentorno", price = 725000},
--            {name = "Zorrusso", hash = "zorrusso", price = 1925000},                                     
--        },
--    },
--    {
--        cat_name = "Vélos",
--        value = "cycles",
--        vehicles = {
--            {name = "BMX", hash = "bmx", price = 25000},
--            {name = "Cruiser", hash = "cruiser", price = 25000},
--            {name = "Fixter", hash = "fixter", price = 25000},                        
--            {name = "Scorcher", hash = "scorcher", price = 25000},
--            {name = "Whippet Race Bike", hash = "tribike", price = 25000},
--            {name = "Endurex Race Bike", hash = "tribike2", price = 25000},
--            {name = "Tri-Cycles Race Bike", hash = "tribike3", price = 25000},                       
--        },
--    },
--    {
--        cat_name = "Motos",
--        value = "motorcycles",
--        vehicles = {
--            {name = "Akuma", hash = "akuma", price = 450000},
--            {name = "Avarus", hash = "avarus", price = 600000},
--            {name = "Bagger", hash = "bagger", price = 225000},
--            {name = "Bati 801", hash = "bati", price = 600000},
--            {name = "Bati 801RR", hash = "bati2", price = 750000},
--            {name = "BF400", hash = "bf400", price = 900000},
--            {name = "Carbon RS", hash = "carbonrs", price = 300000},
--            {name = "Chimera", hash = "chimera", price = 675000},
--            {name = "Cliffhanger", hash = "cliffhanger", price = 225000},
--            {name = "Daemon", hash = "daemon", price = 900000},
--            {name = "Daemon", hash = "daemon2", price = 1050000},
--            {name = "Defiler", hash = "defiler", price = 375000},
--            {name = "Diabolus", hash = "diablous", price = 300000},
--            {name = "Diabolus Custom", hash = "diablous2", price = 450000},
--            {name = "Double-T", hash = "double", price = 210000},
--            {name = "Enduro", hash = "enduro", price = 375000},
--            {name = "Esskey", hash = "esskey", price = 240000},
--            {name = "Faggio Sport", hash = "faggio", price = 75000},
--            {name = "Faggio", hash = "faggio2", price = 90000},
--            {name = "Faggio Mod", hash = "faggio3", price = 135000},
--            {name = "FCR 1000", hash = "fcr", price = 300000},
--            {name = "FCR 1000 Custom", hash = "fcr2", price = 315000},
--            {name = "Gargoyle", hash = "gargoyle", price = 630000},
--            {name = "Hakuchou", hash = "hakuchou", price = 525000},
--            {name = "Hakuchou Drag", hash = "hakuchou2", price = 690000},
--            {name = "Hexer", hash = "hexer", price = 495000},
--            {name = "Innovation", hash = "innovation", price = 720000},
--            {name = "Lectro", hash = "lectro", price = 450000},
--            {name = "Manchez", hash = "manchez", price = 480000},
--            {name = "Manchez Scout", hash = "manchez2", price = 570000},
--            {name = "Manchez Scout C", hash = "manchez3", price = 105000},
--            {name = "Nemesis", hash = "nemesis", price = 450000},
--            {name = "Nightblade", hash = "nightblade", price = 1275000},
--            {name = "PCJ 600", hash = "pcj", price = 210000},
--            {name = "Powersurge", hash = "powersurge", price = 150000},
--            {name = "Rat Bike", hash = "ratbike", price = 210000},
--            {name = "Reever", hash = "reever", price = 210000},
--            {name = "Ruffian", hash = "ruffian", price = 330000},
--            {name = "Rampant Rocket", hash = "rrocket", price = 1485000},
--            {name = "Sanchez (livery)", hash = "sanchez", price = 450000},
--            {name = "Sanchez", hash = "sanchez2", price = 585000},
--            {name = "Sanctus", hash = "sanctus", price = 2340000},
--            {name = "Shinobi", hash = "shinobi", price = 2340000},
--            {name = "Sovereign", hash = "sovereign", price = 900000},
--            {name = "Stryder", hash = "stryder", price = 900000},
--            {name = "Thrust", hash = "thrust", price = 420000},
--            {name = "Vader", hash = "vader", price = 150000},
--            {name = "Vindicator", hash = "vindicator", price = 285000},
--            {name = "Vortex", hash = "vortex", price = 300000},
--            {name = "Wolfsbane", hash = "wolfsbane", price = 345000},
--            {name = "Zombie Bobber", hash = "zombiea", price = 675000},
--            {name = "Zombie Chopper", hash = "zombieb", price = 810000},
--        },
--    },
--    {
--        cat_name = "Muscle Car",
--        value = "muscle",
--        vehicles = {
--            {name = "Blade", hash = "blade", price = 375000},
--            {name = "Broadway", hash = "broadway", price = 945000},
--            {name = "Buccaneer", hash = "buccaneer", price = 375000},
--            {name = "Buccaneer Custom", hash = "buccaneer2", price = 435000},                        
--            {name = "Chino", hash = "chino", price = 375000},
--            {name = "Chino Custom", hash = "chino2", price = 435000},
--            {name = "Clique", hash = "clique", price = 375000},
--            {name = "Coquette BlackFin", hash = "coquette3", price = 375000},
--            {name = "Deviant", hash = "deviant", price = 435000},
--            {name = "Dominator", hash = "dominator", price = 465000},
--            {name = "Pisswasser Dominator", hash = "dominator2", price = 675000},
--            {name = "Dominator GTX", hash = "dominator3", price = 975000},
--            {name = "Dominator ASP", hash = "dominator7", price = 975000},
--            {name = "Dominator GTT", hash = "dominator8", price = 975000},
--            {name = "Dukes", hash = "dukes", price = 435000},
--            {name = "Beater Dukes", hash = "dukes3", price = 435000},
--            {name = "Eudora", hash = "eudora", price = 150000},
--            {name = "Faction", hash = "faction", price = 375000},
--            {name = "Faction Custom", hash = "faction2", price = 465000},
--            {name = "Faction Custom Donk", hash = "faction3", price = 675000},
--            {name = "Ellie", hash = "ellie", price = 405000},
--            {name = "Gauntlet", hash = "gauntlet", price = 405000},
--            {name = "Redwood Gauntlet", hash = "gauntlet2", price = 465000},
--            {name = "Gauntlet Classic", hash = "gauntlet3", price = 555000},
--            {name = "Gauntlet Hellfire", hash = "gauntlet4", price = 675000},
--            {name = "Gauntlet Classic Custom", hash = "gauntlet5", price = 825000},
--            {name = "Greenwood", hash = "greenwood", price = 270000},
--            {name = "Hermes", hash = "hermes", price = 525000},
--            {name = "Hotknife", hash = "hotknife", price = 405000},
--            {name = "Hustler", hash = "hustler", price = 405000},
--            {name = "Impaler", hash = "impaler", price = 405000},
--            {name = "Impaler SZ", hash = "impaler5", price = 405000},
--            {name = "Lurcher", hash = "lurcher", price = 405000},
--            {name = "Moonbeam", hash = "moonbeam", price = 405000},
--            {name = "Moonbeam Custom", hash = "moonbeam2", price = 705000},
--            {name = "Nightshade", hash = "nightshade", price = 675000},
--            {name = "Peyote Gasser", hash = "peyote2", price = 705000},
--            {name = "Phoenix", hash = "phoenix", price = 405000},
--            {name = "Picador", hash = "picador", price = 405000}, 
--            {name = "Rat-Loader", hash = "ratloader", price = 405000},
--            {name = "Rat-Truck", hash = "ratloader2", price = 705000},
--            {name = "Ruiner", hash = "ruiner", price = 705000},
--            {name = "Ruiner ZZ-8", hash = "ruiner4", price = 705000},
--            {name = "Sabre Turbo", hash = "sabregt", price = 705000},
--            {name = "Sabre Turbo Custom", hash = "sabregt2", price = 765000},
--            {name = "Slamvan", hash = "slamvan", price = 405000},
--            {name = "Lost Slamvan", hash = "slamvan2", price = 525000}, 
--            {name = "Slamvan Custom", hash = "slamvan3", price = 705000},
--            {name = "Stallion", hash = "stalion", price = 465000},
--            {name = "Burger Shot Stallion", hash = "stalion2", price = 705000},
--            {name = "Tampa", hash = "tampa", price = 405000},
--            {name = "Tulip", hash = "tulip", price = 405000},
--            {name = "Tulip M-100", hash = "tulip2", price = 270000},
--            {name = "Vamos", hash = "vamos", price = 270000},
--            {name = "Vigero", hash = "vigero", price = 405000},
--            {name = "Vigero ZX", hash = "vigero2", price = 750000},
--            {name = "Virgo", hash = "virgo", price = 405000},
--            {name = "Virgo Classic Custom", hash = "virgo2", price = 525000},
--            {name = "Virgo Classic", hash = "virgo3", price = 705000}, 
--            {name = "Voodoo Custom", hash = "voodoo", price = 525000},
--            {name = "Voodoo", hash = "voodoo2", price = 405000},
--            {name = "Yosemite", hash = "yosemite", price = 465000},
--            {name = "Drift Yosemite", hash = "yosemite2", price = 705000},
--            {name = "Yosemite Rancher", hash = "yosemite3", price = 405000},
--        },
--    },
--    {
--        cat_name = "Off-Road",
--        value = "off-road",
--        vehicles = {
--            {name = "Injection", hash = "bfinjection", price = 450000},
--            {name = "Boor", hash = "boor", price = 168000},
--            {name = "Bifta", hash = "bifta", price = 450000},
--            {name = "Blazer", hash = "blazer", price = 225000},                        
--            {name = "Hot Rod Blazer", hash = "blazer3", price = 375000},
--            {name = "Street Blazer", hash = "blazer4", price = 450000},
--            {name = "Bodhi", hash = "bodhi2", price = 375000},
--            {name = "Brawler", hash = "brawler", price = 2160000},
--            {name = "Caracara 4x4", hash = "caracara2", price = 2250000},
--            {name = "Duneloader", hash = "dloader", price = 450000},
--            {name = "Dubsta 6x6", hash = "dubsta3", price = 2280000},
--            {name = "Dune Buggy", hash = "dune", price = 525000},
--            {name = "Draugur", hash = "draugur", price = 1560000},
--            {name = "everon", hash = "everon", price = 1650000},
--            {name = "Guardian", hash = "guardian", price = 3750000},
--            {name = "Hellion", hash = "hellion", price = 1050000},
--            {name = "Kalahari", hash = "kalahari", price = 375000},
--            {name = "Kamacho", hash = "kamacho", price = 6750000},
--            {name = "Outlaw", hash = "outlaw", price = 1050000},
--            {name = "Rancher XL", hash = "rancherxl", price = 450000},
--            {name = "Rusty Rebel", hash = "rebel", price = 525000},
--            {name = "Rebel", hash = "rebel2", price = 585000},
--            {name = "Riata", hash = "riata", price = 1050000},
--            {name = "Sandking XL", hash = "sandking", price = 1050000},
--            {name = "Sandking SWB", hash = "sandking2", price = 1650000},
--            {name = "Trophy Truck", hash = "trophytruck", price = 1950000}, 
--            {name = "Desert Raid", hash = "trophytruck2", price = 2250000},
--            {name = "Vagrant", hash = "vagrant", price = 750000},
--            {name = "Verus", hash = "verus", price = 450000},
--            {name = "Winky", hash = "winky", price = 675000},                           
--        },
--    },
--    {
--        cat_name = "Classiques",
--        value = "classic",
--        vehicles = {
--            {name = "Roosevelt", hash = "btype", price = 375000},
--            {name = "Fränken Stange", hash = "btype2", price = 425000},                        
--            {name = "Roosevelt Valor", hash = "btype3", price = 400000},
--            {name = "Casco", hash = "casco", price = 350000},
--            {name = "Cheetah Classic", hash = "cheetah2", price = 450000},
--            {name = "Coquette Classic", hash = "coquette2", price = 450000},
--            {name = "Dynasty", hash = "dynasty", price = 305000},
--            {name = "Fagaloa", hash = "fagaloa", price = 225000},
--            {name = "Stirling GT", hash = "feltzer3", price = 425000},
--            {name = "GT500", hash = "gt500", price = 405000},
--            {name = "Infernus Classic", hash = "infernus2", price = 525000},
--            {name = "JB 700", hash = "jb700", price = 475000},
--            {name = "JB 700W", hash = "jb7002", price = 475000},
--            {name = "Mamba", hash = "mamba", price = 425000},
--            {name = "Manana", hash = "manana", price = 375000},
--            {name = "Manana Custom", hash = "manana2", price = 375000},
--            {name = "Michelli GT", hash = "michelli", price = 345000},
--            {name = "Monroe", hash = "monroe", price = 450000},
--            {name = "Nebula Turbo", hash = "nebula", price = 525000},
--            {name = "Peyote", hash = "peyote", price = 375000},
--            {name = "Peyote Custom", hash = "peyote3", price = 425000},
--            {name = "Pigalle", hash = "pigalle", price = 325000},
--            {name = "Rapid GT Classic", hash = "rapidgt3", price = 450000},   
--            {name = "Retinue", hash = "retinue", price = 350000},
--            {name = "Retinue Mk II", hash = "retinue2", price = 400000},
--            {name = "Savestra", hash = "savestra", price = 375000},                        
--            {name = "Stinger", hash = "stinger", price = 425000},
--            {name = "Stinger GT", hash = "stingergt", price = 450000},
--            {name = "Swinger", hash = "swinger", price = 525000},
--            {name = "Torero", hash = "torero", price = 475000},
--            {name = "tornado", hash = "tornado", price = 375000},
--            {name = "Tornado décapotable", hash = "tornado2", price = 400000},
--            {name = "Tornado rouillé", hash = "tornado3", price = 350000},
--            {name = "Tornado rouillé décapotable", hash = "tornado4", price = 325000},
--            {name = "Tornado Custom", hash = "tornado5", price = 350000},
--            {name = "Tornado Rat Rod", hash = "tornado6", price = 450000},
--            {name = "Turismo Classic", hash = "turismo2", price = 625000},
--            {name = "Viseris", hash = "viseris", price = 575000},
--            {name = "190z", hash = "z190", price = 425000},
--            {name = "Z-Type", hash = "ztype", price = 995000},
--            {name = "Zion Classic", hash = "zion3", price = 525000},
--            {name = "Cheburek", hash = "cheburek", price = 345000},                                          
--        },
--    },
--    {
--        cat_name = "Vans",
--        value = "vans",
--        vehicles = {
--            {name = "Benson", hash = "benson", price = 1200000},
--            {name = "Mule", hash = "mule", price = 650000},
--            {name = "Bison", hash = "bison", price = 600000},
--            {name = "Bison", hash = "bison2", price = 600000},
--            {name = "Bison", hash = "bison3", price = 600000},                        
--            {name = "Bobcat XL", hash = "bobcatxl", price = 600000},
--            {name = "Burrito", hash = "burrito3", price = 800000},
--            {name = "Camper", hash = "camper", price = 600000},
--            {name = "Gang Burrito Lost", hash = "gburrito", price = 900000},
--            {name = "Gang Burrito", hash = "gburrito2", price = 900000},
--            {name = "Journey", hash = "journey", price = 600000},
--            {name = "Journey II", hash = "journey2", price = 600000},
--            {name = "Minivan", hash = "minivan", price = 600000},
--            {name = "Minivan Custom", hash = "minivan2", price = 600000},
--            {name = "Paradise", hash = "paradise", price = 600000},
--            {name = "Pony", hash = "pony", price = 600000},
--            {name = "Pony weed", hash = "pony2", price = 600000},
--            {name = "Rumpo Weazle News", hash = "rumpo", price = 600000},
--            {name = "Rumpo", hash = "rumpo2", price = 900000},
--            {name = "Rumpo Custom", hash = "rumpo3", price = 900000},
--            {name = "Speedo", hash = "speedo", price = 600000},
--            {name = "Surfer", hash = "surfer", price = 600000},
--            {name = "Surfer rouillé", hash = "surfer2", price = 600000},
--            {name = "Surfer Custom", hash = "surfer3", price = 600000},
--            {name = "Youga", hash = "youga", price = 600000},
--            {name = "Youga Classic", hash = "youga2", price = 750000},
--            {name = "Youga Classic 4x4", hash = "youga3", price = 900000},                                     
--            {name = "Youga Custom", hash = "youga4", price = 800000},                                     
--        },
--    },
--}
--
--local Zones = {
--    { coords = vector3(-106.31903839111, -712.62432861328, 34.169952392578), radius = 750.0, accelMult = 0.9, maxSpeed = 55.0 },
--}
--
--local function IsInAnyZone(pos)
--    for _, z in ipairs(Zones) do
--        if #(pos - z.coords) <= z.radius then
--            return z
--        end
--    end
--    return nil
--end
--
--local _wlCache, _wlReady = {}, false
--
--local function BuildWLAuto()
--    _wlCache = {}
--    _wlReady = true
--
--    if not cfg_cataloguePDM or not cfg_cataloguePDM.vehicles then return end
--
--    for _, cat in ipairs(cfg_cataloguePDM.vehicles) do
--        if cat.vehicles then
--            for _, v in ipairs(cat.vehicles) do
--                if v.hash and v.hash ~= "" then
--                    _wlCache[GetHashKey(v.hash)] = true
--                end
--            end
--        end
--    end
--end
--
--local function IsVehWhitelistedByConcess(veh)
--    if veh == 0 or not DoesEntityExist(veh) then return false end
--    if not _wlReady then return false end
--    return _wlCache[GetEntityModel(veh)] == true
--end
--
--CreateThread(function()
--    while not cfg_cataloguePDM or not cfg_cataloguePDM.vehicles do
--        Wait(200)
--    end
--    BuildWLAuto()
--end)
--
--CreateThread(function()
--    while true do
--        Wait(200)
--
--        local ped = PlayerPedId()
--        if not IsPedInAnyVehicle(ped, false) then
--            goto continue
--        end
--
--        local veh = GetVehiclePedIsIn(ped, false)
--        if GetPedInVehicleSeat(veh, -1) ~= ped then
--            goto continue
--        end
--
--        if IsVehWhitelistedByConcess(veh) then
--            SetVehicleEnginePowerMultiplier(veh, 0.0)
--            SetVehicleEngineTorqueMultiplier(veh, 1.0)
--            SetEntityMaxSpeed(veh, 1000.0)
--            goto continue
--        end
--
--        local pos = GetEntityCoords(veh)
--        local zone = IsInAnyZone(pos)
--
--        if zone then
--            SetVehicleEnginePowerMultiplier(veh, (zone.accelMult - 1.0) * 100.0)
--            SetVehicleEngineTorqueMultiplier(veh, zone.accelMult)
--
--            if zone.maxSpeed then
--                SetEntityMaxSpeed(veh, zone.maxSpeed)
--            end
--        else
--            SetVehicleEnginePowerMultiplier(veh, 0.0)
--            SetVehicleEngineTorqueMultiplier(veh, 1.0)
--            SetEntityMaxSpeed(veh, 1000.0)
--        end
--
--        ::continue::
--    end
--end)