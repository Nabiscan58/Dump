local Player = PlayerPedId()
local ped = PlayerPedId()
local holstered = true
local blocked = false
local currWeapon = nil
local isPolice = false

local weapons_list = {
	'WEAPON_KNIFE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_STICKYBOMB',
	'WEAPON_MOLOTOV',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_STUNGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_GLOCK',
	'WEAPON_CANDYCANE',
	'WEAPON_GADGETPISTOL',
	'WEAPON_SCAR17FM',
	'WEAPON_TACTICALRIFLE',
	'WEAPON_HEAVYRIFLE',
	'WEAPON_MK18B',
    'WEAPON_HK416A',
    'WEAPON_MP5',
    'WEAPON_MP7',
    'WEAPON_G19',
    'WEAPON_BEANBAG',
    'WEAPON_UMP45CMG',
    'WEAPON_DILDOCMG',
    'WEAPON_BREAD',
    'WEAPON_GUITARCMG',
    'WEAPON_KATANA',
    'WEAPON_FIREAXECMG',
    'WEAPON_SLICE',
    'WEAPON_DEMHAMMER',
    'WEAPON_KARAMBIT',
    'WEAPON_CANDYKNIFE',
    'WEAPON_CARROTSWORD',
    'WEAPON_ASSAULTRIFLELS',
    'WEAPON_PATRIOTKNIFE',
    'WEAPON_FRYINPAN',
    'WEAPON_AXE',
    'WEAPON_BARBEDBAT',
    'WEAPON_BATON',
    'WEAPON_BLACKKATANA',
    'WEAPON_BLUEZK',
    'WEAPON_BROWNMACHETE',
    'WEAPON_BUTCHER',
    'WEAPON_CHAIR',
    'WEAPON_CRUTCH',
    'WEAPON_DILDO',
    'WEAPON_EGUITAR',
    'WEAPON_GUITAR',
    'WEAPON_HUNTERKNIFE',
    'WEAPON_ICECLIMBER',
    'WEAPON_KITCHENKNIFE',
    'WEAPON_KUKRI',
    'WEAPON_LONGMACHETE',
    'WEAPON_MACE',
    'WEAPON_PICKAXE',
    'WEAPON_PINKZK',
    'WEAPON_PITCHFORK',
    'WEAPON_REDZK',
    'WEAPON_SCIFISWORD',
    'WEAPON_SCIMITAR',
    'WEAPON_SCREWDRIVER',
    'WEAPON_SCYTHE',
    'WEAPON_SHOVEL',
    'WEAPON_SLEDGEHAMMER',
    'WEAPON_SPIKEDKNUCKLES',
    'WEAPON_SPIKEYBAT',
    'WEAPON_STOPSIGN',
    'WEAPON_TACAXE',
    'WEAPON_TACCLEAVER',
    'WEAPON_TACTICALHATCHET',
    'WEAPON_THORSHAMMER',
    'WEAPON_TWOHBATTLEAXE',
    'WEAPON_WCLAWS',
    'WEAPON_ZK',
    'WEAPON_BULLPUP_SMG',
    'WEAPON_MACHINE_PISTOL_RED_CHR',
    'WEAPON_MP9',
    'WEAPON_EXTENDEDSMG',
    'WEAPON_GOLDSMG',
    'WEAPON_M415',
    'WEAPON_AK_SHORTSTOCK_CHR',
    'WEAPON_PF940',
    'WEAPON_MP7_CHROMIUM',
    'WEAPON_VECTOR',
    'WEAPON_SB4S',
    'WEAPON_HKUSP',
    'WEAPON_UMP_CHR',
    'WEAPON_SCAR-L',
    'WEAPON_DEAGLE',
    'WEAPON_PNONENTE',
    'WEAPON_CZ_SCORPION_EVO_CHR',
    'WEAPON_SS2_2',
    'WEAPON_VERESK',
    'WEAPON_MLTM4R_CHR',
    'WEAPON_FAMAS',
    'WEAPON_PKISS',
    'WEAPON_BATCANDY',
    'WEAPON_KNIFEVALEN',
    'WEAPON_SPS_21_SG_CHR',
    'WEAPON_MICRO_9_CHR',
    'WEAPON_VX_SCORPION_CHR',
    'WEAPON_NVRIFLE_CHR',
    'WEAPON_REDL',
    'WEAPON_TR_88_CHR',
    'WEAPON_M270D_CHR',
    'WEAPON_M4BEAST',
    'WEAPON_TAR21',
    'WEAPON_BAS_P_RED',
    'WEAPON_KS1',
    'WEAPON_A15RC',
    'WEAPON_SMG9',
    'WEAPON_L85_CHR',
    'WEAPON_14',
    'WEAPON_BUTERFLY',
    'WEAPON_DIRTYSYRINGE',
    'WEAPON_PEELER',
    'WEAPON_RULER',
    'WEAPON_BIGSPOON',
    'WEAPON_JABSAW',
    'WEAPON_TELESCOPE',
    'WEAPON_MEATSKEWER',
    'WEAPON_SWORDFISH',
    'WEAPON_LOBSTER',
    'WEAPON_PLIERS',
    'WEAPON_HANDDRILL',
    'WEAPON_TWISTEDSPEAR',
    'WEAPON_SNAKEKNIFE',
    'WEAPON_CRUTCHKNIFE',
    'WEAPON_SHARPARROW',
    'WEAPON_95SIGN',
    'WEAPON_ASSASINGUN',
    'WEAPON_BAGUETTE',
    'WEAPON_BANANA',
    'WEAPON_BIKE',
    'WEAPON_BONE',
    'WEAPON_BONESWORD',
    'WEAPON_BUTTPLUG',
    'WEAPON_CACTUS',
    'WEAPON_CAMSHAFT',
    'WEAPON_CARJACK',
    'WEAPON_CONE',
    'WEAPON_CROSSSPANNER',
    'WEAPON_CUCUMBER',
    'WEAPON_DISABLEDSIGN',
    'WEAPON_ELDERSWAND',
    'WEAPON_MFIREEXTINGUISHER',
    'WEAPON_FISHINGROD',
    'WEAPON_GASCYLINDER',
    'WEAPON_HOCKEYFSTICK',
    'WEAPON_HORN',
    'WEAPON_JDBOTTLE',
    'WEAPON_KEYBOARD',
    'WEAPON_KITCHENFORK',
    'WEAPON_LACROSSESTICK',
    'WEAPON_LADDER',
    'WEAPON_MAILBOX',
    'WEAPON_MIC',
    'WEAPON_NOPARKINGSIGN',
    'WEAPON_PEN',
    'WEAPON_PENCIL',
    'WEAPON_PROSLEG',
    'WEAPON_ROLLINGPIN',
    'WEAPON_RONABOTTLE',
    'WEAPON_ROUTE66SIGN',
    'WEAPON_SCOOTER',
    'WEAPON_SHOCKABSORBER',
    'WEAPON_SKULLBAT',
    'WEAPON_SPARTANSWORD',
    'WEAPON_SPATULA',
    'WEAPON_STEPLADDER',
    'WEAPON_STREETLIGHT',
    'WEAPON_TOASTER',
    'WEAPON_VACUUM',
    'WEAPON_WRONGWAYSIGN',
    'WEAPON_YARI',
    'WEAPON_BLACKBELT',
    'WEAPON_BENTFORK',
    'WEAPON_BLACKBACKPACK',
    'WEAPON_BRCHICKEN',
    'WEAPON_DOORBARS',
    'WEAPON_EARBUDBLADE',
    'WEAPON_HONEYDIPPER',
    'WEAPON_KETTLE',
    'WEAPON_LEATHERBRIEFCASE',
    'WEAPON_MAKESHIFTKNIFE',
    'WEAPON_MEASURINGCUP',
    'WEAPON_MODDEDNIGHTSTICK',
    'WEAPON_TRAYRACK',
    'WEAPON_POKER',
    'WEAPON_PRISONKEY',
    'WEAPON_VIOBACKPACK',
    'WEAPON_REDBACKPACK',
    'WEAPON_TEAPOT',
    'WEAPON_PRISTOI',
    'WEAPON_SHIV',
    'WEAPON_FETE21',
    'WEAPON_GK47',
    'WEAPON_COMBAT_SG_CHR',
    'WEAPON_R90_CHR',
    'WEAPON_G3_2',
    'WEAPON_AUG',
    'WEAPON_MINISMG_PINKSPIKE',
    'WEAPON_M16A1_CHR',
    'WEAPON_HX_15_CHR',
    'WEAPON_KITTBOWYAXE',
    'WEAPON_UNICORNHORN',
    'WEAPON_BRUNETTEDOLL',
    'WEAPON_BLONDEDOLL',
    'WEAPON_ANIMEDOLL',
    'WEAPON_WEDDINGRING',
    'WEAPON_FEGUITAR',
    'WEAPON_FGUITAR',
    'WEAPON_BABYCHAIRFOOD',
    'WEAPON_TWEEZERS',
    'WEAPON_PINKSWITCHBLADE',
    'WEAPON_KITTYAXE',
    'WEAPON_BABYSEAT',
    'WEAPON_TWIRLPOP',
    'WEAPON_ROUNDLOLLY',
    'WEAPON_HSLOLLY',
    'WEAPON_BUTTERLOLLY',
    'WEAPON_STEAMIRON',
    'WEAPON_HAIRBRUSH',
    'WEAPON_PINKLOLLY',
    'WEAPON_LOLLYBAT',
    'WEAPON_CANDYKNIFE',
    'WEAPON_ROSEKNIFE',
    'WEAPON_LIPSTICK',
    'WEAPON_BLPURSE',
    'WEAPON_PINKPOOLNOODLE',
    'WEAPON_WHITEPILLOW',
    'WEAPON_PINKPILLOW',
    'WEAPON_FTEDDYPINK',
    'WEAPON_FTEDDY',
    'WEAPON_VIBRATOR',
    'WEAPON_FDUALSWORD',
    'WEAPON_CRYSTALROD',
    'WEAPON_FZVTWO',
    'WEAPON_FSLIPPERS',
    'WEAPON_BLOSSOMKNIFE',
    'WEAPON_BLOSSOMKATANA',
    'WEAPON_FHATCHET',
    'WEAPON_FKNUCKLE',
    'WEAPON_CHRIBAG',
    'WEAPON_FBLACKHEEL',
    'WEAPON_FPINKHEEL',
    'WEAPON_FREDHEEL',
    'WEAPON_FBAT',
    'WEAPON_FSPIKEBAT',
    'WEAPON_FPICKAXE',
    'WEAPON_FCOMB',
    'WEAPON_PINKKEYBOARD',
    'WEAPON_SPIKEDCHOKER',
    'WEAPON_PINKCHOKER',
    'WEAPON_PINKPEPPERSPRAY',
    'WEAPON_BLOWDRYER',
    'WEAPON_BOBSFISHINGNET',
    'WEAPON_DRAGONDOLL',
    'WEAPON_WEAPON_FCLOSEDUMBRELLA',
    'WEAPON_FLAMINGO',
    'WEAPON_FSCEPTER',
    'WEAPON_FUMBRELLA',
    'WEAPON_GOLDDIGGER',
    'WEAPON_HAIRPIN',
    'WEAPON_HEARTBAG',
    'WEAPON_KERBSDOLL',
    'WEAPON_KETTLEBALL',
    'WEAPON_MARSHSTICK',
    'WEAPON_MERMAID',
    'WEAPON_MOUSEDOLL',
    'WEAPON_OCTOPUSDOLL',
    'WEAPON_PINKBOLTCUTTERS',
    'WEAPON_PINKFAXE',
    'WEAPON_PINKFPICKAXE',
    'WEAPON_PINKHAMMER',
    'WEAPON_PINKHANDFAN',
    'WEAPON_PINKKNIGHTSTICK',
    'WEAPON_PINKSCREWDRIVER',
    'WEAPON_PSLEDGE',
    'WEAPON_TIARA',
    'WEAPON_LUUBAG',
    'WEAPON_PINKCUTTER',
    'WEAPON_PINKCYBERSWORD',
    'WEAPON_RADABAG',
    'WEAPON_BONECLUB',
    'WEAPON_BUCKET',
    'WEAPON_COFFIN',
    'WEAPON_DEATHNOTE',
    'WEAPON_HELLFIRESWORD',
    'WEAPON_INFERNO',
    'WEAPON_PUMPKIN',
    'WEAPON_PUMPKINBAT',
    'WEAPON_ARM',
    'WEAPON_LEG',
    'WEAPON_STAKE',
    'WEAPON_TRIPLEBLADEDSCYTHE',
    'WEAPON_VOODOO',
    'WEAPON_WITCHBROOM',
    'WEAPON_SOULSCYTHE',
    'WEAPON_GRAVESTONE',
    'WEAPON_KITTBOWYAXE',
    'WEAPON_COMBAT_MP7',
    'WEAPON_G36',
    'WEAPON_COMBAT_PISTOL_CHROMIUM',
    'WEAPON_SHOTGUN_CHROMIUM',
    'WEAPON_G3_2',
    'WEAPON_GALILARV2',
    'WEAPON_SR_3M_CHR',
    'WEAPON_GROZA',
    'WEAPON_NUTCRACKER',
    'WEAPON_SNOWSHOVEL',
    'WEAPON_CANECANDY',
    'WEAPON_CANECANDYGREEN',
    'WEAPON_CANDYCUT',
    'WEAPON_CHRISTMASBAT',
    'WEAPON_CHRISTMASMACHETE',
    'WEAPON_CHRISTMASPILLOW',
    'WEAPON_CHRISTMASPLUSH',
    'WEAPON_CHRISTMASTREE',
    'WEAPON_HOCKEYSTICK',
    'WEAPON_ICEAXE',
    'WEAPON_ICEBAT',
    'WEAPON_ICEBAT2',
    'WEAPON_ICEBIGAXE',
    'WEAPON_ICECUT',
    'WEAPON_ICEKATANA',
    'WEAPON_ICELANTERN',
    'WEAPON_ICEPICK',
    'WEAPON_ICESKI',
    'WEAPON_UZI_ARCBYTE',
    'WEAPON_RRC3_ACHROMIC',
}

WeaponsBackWeaponList = {
    ['WEAPON_DAGGER'] = {propName = 'w_me_dagger'},
    ['WEAPON_BAT'] = {propName = 'w_me_bat'},
    ['WEAPON_BOTTLE'] = {propName = 'w_me_bottle'},
    ['WEAPON_CROWBAR'] = {propName = 'w_me_crowbar'},
    ['WEAPON_FLASHLIGHT'] = {propName = 'w_me_flashlight'},
    ['WEAPON_GOLFCLUB'] = {propName = 'w_me_gclub'},
    ['WEAPON_HAMMER'] = {propName = 'w_me_hammer'},
    ['WEAPON_HATCHET'] = {propName = 'w_me_hatchet'},
    ['WEAPON_KNUCKLE'] = {propName = 'w_me_knuckle'},
    ['WEAPON_KNIFE'] = {propName = 'w_me_knife_01'},
    ['WEAPON_MACHETE'] = {propName = 'w_me_machette_lr'},
    ['WEAPON_SWITCHBLADE'] = {propName = 'w_me_switchblade'},
    ['WEAPON_NIGHTSTICK'] = {propName = 'w_me_nightstick'},
    ['WEAPON_WRENCH'] = {propName = 'w_me_wrench'},
    ['WEAPON_BATTLEAXE'] = {propName = 'w_me_battleaxe'},
    ['WEAPON_POOLCUE'] = {propName = 'w_me_poolcue'},
    ['WEAPON_STONE_HATCHET'] = {propName = 'w_me_stonehatchet'},
    ['WEAPON_CANDYCANE'] = {propName = 'w_me_candy_cane'},
    ['WEAPON_PISTOL'] = {propName = 'w_pi_pistol'},
    ['WEAPON_PISTOL_MK2'] = {propName = 'w_pi_pistolmk2'},
    ['WEAPON_COMBATPISTOL'] = {propName = 'w_pi_combatpistol'},
    ['WEAPON_APPISTOL'] = {propName = 'w_pi_appistol'},
    ['WEAPON_STUNGUN'] = {propName = 'w_pi_stungun'},
    ['WEAPON_PISTOL50'] = {propName = 'w_pi_pistol50'},
    ['WEAPON_SNSPISTOL'] = {propName = 'w_pi_sns_pistol'},
    ['WEAPON_SNSPISTOL_MK2'] = {propName = 'w_pi_sns_pistolmk2'},
    ['WEAPON_HEAVYPISTOL'] = {propName = 'w_pi_heavypistol'},
    ['WEAPON_VINTAGEPISTOL'] = {propName = 'w_pi_vintage_pistol'},
    ['WEAPON_FLAREGUN'] = {propName = 'w_pi_flaregun'},
    ['WEAPON_MARKSMANPISTOL'] = {propName = 'w_pi_marksmanpistol'},
    ['WEAPON_REVOLVER'] = {propName = 'w_pi_revolver'},
    ['WEAPON_REVOLVER_MK2'] = {propName = 'w_pi_revolvermk2'},
    ['WEAPON_DOUBLEACTION'] = {propName = 'w_pi_doubleaction'},
    ['WEAPON_RAYPISTOL'] = {propName = 'w_pi_raygun'},
    ['WEAPON_CERAMICPISTOL'] = {propName = 'w_pi_ceramic_pistol'},
    ['WEAPON_NAVYREVOLVER'] = {propName = 'w_pi_navyrevolver'},
    ['WEAPON_GADGETPISTOL'] = {propName = 'w_pi_gadget_pistol'},
    ['WEAPON_STUNGUN_MP'] = {propName = 'w_pi_stungun_mp'},
    ['WEAPON_PISTOLXM3'] = {propName = 'w_pi_pistolxm3'},
    ['WEAPON_MICROSMG'] = {propName = 'w_sb_microsmg'},
    ['WEAPON_SMG'] = {propName = 'w_sb_smg'},
    ['WEAPON_SMG_MK2'] = {propName = 'w_sb_smgmk2'},
    ['WEAPON_ASSAULTSMG'] = {propName = 'w_sb_assaultsmg'},
    ['WEAPON_COMBATPDW'] = {propName = 'w_sb_pdw'},
    ['WEAPON_MACHINEPISTOL'] = {propName = 'w_sb_machinepistol'},
    ['WEAPON_MINISMG'] = {propName = 'w_sb_minismg'},
    ['WEAPON_TECPISTOL'] = {propName = 'w_sb_tec9'},
    ['WEAPON_PUMPSHOTGUN'] = {propName = 'w_sg_pumpshotgun'},
    ['WEAPON_PUMPSHOTGUN_MK2'] = {propName = 'w_sg_pumpshotgunmk2'},
    ['WEAPON_SAWNOFFSHOTGUN'] = {propName = 'w_sg_sawnoff'},
    ['WEAPON_ASSAULTSHOTGUN'] = {propName = 'w_sg_assaultshotgun'},
    ['WEAPON_BULLPUPSHOTGUN'] = {propName = 'w_sg_bullpupshotgun'},
    ['WEAPON_MUSKET'] = {propName = 'w_ar_musket'},
    ['WEAPON_HEAVYSHOTGUN'] = {propName = 'w_sg_heavyshotgun'},
    ['WEAPON_DBSHOTGUN'] = {propName = 'w_sg_doublebarrel'},
    ['WEAPON_AUTOSHOTGUN'] = {propName = 'w_sg_autoshotgun'},
    ['WEAPON_COMBATSHOTGUN'] = {propName = 'w_sg_pumpshotgunh4'},
    ['WEAPON_ASSAULTRIFLE'] = {propName = 'w_ar_assaultrifle'},
    ['WEAPON_ASSAULTRIFLE_MK2'] = {propName = 'w_ar_assaultriflemk2'},
    ['WEAPON_CARBINERIFLE'] = {propName = 'w_ar_carbinerifle'},
    ['WEAPON_CARBINERIFLE_MK2'] = {propName = 'w_ar_carbineriflemk2'},
    ['WEAPON_ADVANCEDRIFLE'] = {propName = 'w_ar_advancedrifle'},
    ['WEAPON_SPECIALCARBINE'] = {propName = 'w_ar_specialcarbine'},
    ['WEAPON_SPECIALCARBINE_MK2'] = {propName = 'w_ar_specialcarbinemk2'},
    ['WEAPON_BULLPUPRIFLE'] = {propName = 'w_ar_bullpuprifle'},
    ['WEAPON_BULLPUPRIFLE_MK2'] = {propName = 'w_ar_bullpupriflemk2'},
    ['WEAPON_COMPACTRIFLE'] = {propName = 'w_ar_compactrifle'},
    ['WEAPON_MILITARYRIFLE'] = {propName = 'w_ar_militaryrifle'},
    ['WEAPON_HEAVYRIFLE'] = {propName = 'w_ar_heavyrifle'},
    ['WEAPON_TACTICALRIFLE'] = {propName = 'w_ar_carbinerifleh4'},
    ['WEAPON_GUSENBERG'] = {propName = 'w_sb_gusenberg'},
    ['WEAPON_A15RC'] = {propName = 'w_ar_a15rc'},
    ['WEAPON_HK416B'] = {propName = 'w_ar_HK416B'},
    ['WEAPON_G19'] = {propName = 'W_PI_G19'},
    ['WEAPON_MK18B'] = {propName = 'w_ar_mk18b'},
    ['WEAPON_MP5'] = {propName = 'w_sb_mp5'},
    ['WEAPON_LESSLETHAL'] = {propName = 'w_sg_lesslethal'},
    ['WEAPON_BREAD'] = {propName = 'w_me_bread'},
    ['WEAPON_DILDOCMG'] = {propName = 'w_me_dildo'},
    ['WEAPON_FIREAXECMG'] = {propName = 'w_me_fireaxe'},
    ['WEAPON_GUITARCMG'] = {propName = 'w_me_guitar'},
    ['WEAPON_MP7CMG'] = {propName = 'w_sb_mp7'},
    ['WEAPON_SHOVELCMG'] = {propName = 'w_me_shovel'},
    ['WEAPON_UMP45CMG'] = {propName = 'w_sb_ump45'},
    ['WEAPON_CHAINSAW'] = {propName = 'w_mg_chainsaw'},
    ['WEAPON_KARAMBIT'] = {propName = 'w_me_karambit'},
    ['WEAPON_ASSAULTRIFLELS'] = {propName = 'w_ar_assaultriflels'},
    ['WEAPON_CANDYKNIFE'] = {propName = 'w_me_candyknife_01'},
    ['WEAPON_KATANA'] = {propName = 'w_me_kattana_lr'},
    ['WEAPON_AXE'] = {propName = 'w_me_axe'},
    ['WEAPON_BARBEDBAT'] = {propName = 'w_me_barbedbat'},
    ['WEAPON_BATON'] = {propName = 'w_me_baton'},
    ['WEAPON_BLACKKATANA'] = {propName = 'w_me_blackkatana_lr'},
    ['WEAPON_BLUEZK'] = {propName = 'w_me_bluezombieknife_01'},
    ['WEAPON_BROWNMACHETE'] = {propName = 'w_me_brownhandlemachete_lr'},
    ['WEAPON_BUTCHER'] = {propName = 'w_me_butcher_lr'},
    ['WEAPON_CHAIR'] = {propName = 'w_me_chair'},
    ['WEAPON_CRUTCH'] = {propName = 'w_me_crutch'},
    ['WEAPON_DILDO'] = {propName = 'w_me_dildo'},
    ['WEAPON_EGUITAR'] = {propName = 'w_me_eguitar'},
    ['WEAPON_GUITAR'] = {propName = 'w_me_guitar'},
    ['WEAPON_HUNTERKNIFE'] = {propName = 'w_me_hunterknife_01'},
    ['WEAPON_ICECLIMBER'] = {propName = 'w_me_iceclimber_lr'},
    ['WEAPON_KITCHENKNIFE'] = {propName = 'w_me_kitchenknife_01'},
    ['WEAPON_KUKRI'] = {propName = 'w_me_kukri_lr'},
    ['WEAPON_LONGMACHETE'] = {propName = 'w_me_longmachete_lr'},
    ['WEAPON_MACE'] = {propName = 'w_me_mace'},
    ['WEAPON_PICKAXE'] = {propName = 'w_me_pickaxe'},
    ['WEAPON_PINKZK'] = {propName = 'w_me_pinkzombieknife_01'},
    ['WEAPON_PITCHFORK'] = {propName = 'w_me_pitchfork_01'},
    ['WEAPON_REDZK'] = {propName = 'w_me_redzombieknife_01'},
    ['WEAPON_SCIFISWORD'] = {propName = 'w_me_scifisword_01'},
    ['WEAPON_SCIMITAR'] = {propName = 'w_me_scimitar_01'},
    ['WEAPON_SCREWDRIVER'] = {propName = 'w_me_screwdriver_01'},
    ['WEAPON_SCYTHE'] = {propName = 'w_me_scythe'},
    ['WEAPON_SHOVEL'] = {propName = 'w_me_sovel'},
    ['WEAPON_SLEDGEHAMMER'] = {propName = 'w_me_sledgehammer'},
    ['WEAPON_SPIKEDKNUCKLES'] = {propName = 'w_me_knuckleduster'},
    ['WEAPON_SPIKEYBAT'] = {propName = 'w_me_spikeybat'},
    ['WEAPON_STOPSIGN'] = {propName = 'w_me_stopsign'},
    ['WEAPON_TACAXE'] = {propName = 'w_me_tacaxe'},
    ['WEAPON_TACCLEAVER'] = {propName = 'w_me_taccleaver'},
    ['WEAPON_TACTICALHATCHET'] = {propName = 'w_me_tacticalhatchet'},
    ['WEAPON_THORSHAMMER'] = {propName = 'w_me_thorshammer'},
    ['WEAPON_TWOHBATTLEAXE'] = {propName = 'w_me_twohbattleaxe'},
    ['WEAPON_WCLAWS'] = {propName = 'w_me_wolverineclaws'},
    ['WEAPON_ZK'] = {propName = 'w_me_zombieknife_01'},
    ['WEAPON_MACHINE_PISTOL_RED_CHR'] = {propName = 'w_machine_pistol_red_chromium'},
    ['WEAPON_BULLPUP_SMG'] = {propName = 'w_sb_bullpup_smg'},
    ['WEAPON_FRYINPAN'] = {propName = 'w_me_fryinpan'},
    ['WEAPON_MP9'] = {propName = 'w_sb_mp9'},
    ['WEAPON_EXTENDEDSMG'] = {propName = 'w_sb_extendedsmg'},
    ['WEAPON_GOLDSMG'] = {propName = 'w_sb_extendedsmg'},
    ['WEAPON_AK_SHORTSTOCK_CHR'] = {propName = 'w_ar_ak_shortstock_chromium'},
    ['WEAPON_M415'] = {propName = 'w_ar_m415'},
    ['WEAPON_PF940'] = {propName = 'w_pi_pf940'},
    ['WEAPON_MP7_CHROMIUM'] = {propName = 'w_sb_mp7_chromium'},
    ['WEAPON_VECTOR'] = {propName = 'w_sb_vector'},
    ['WEAPON_SB4S'] = {propName = 'w_sb_sb4s'},
    ['WEAPON_HKUSP'] = {propName = 'w_pi_hkusp'},
    ['WEAPON_UMP_CHR'] = {propName = 'w_sb_ump_chr'},
    ['WEAPON_SCAR-L'] = {propName = 'w_ar_scar-l'},
    ['WEAPON_DEAGLE'] = {propName = 'w_pi_pistol50'},
    ['WEAPON_PNONENTE'] = {propName = 'w_sb_assaultsmg'},
    ['WEAPON_CZ_SCORPION_EVO_CHR'] = {propName = 'w_ar_cz_sc_evo_chr'},
    ['WEAPON_SS2_2'] = {propName = 'w_ar_ss2_2'},
    ['WEAPON_VERESK'] = {propName = 'w_sb_veresk'},
    ['WEAPON_MLTM4R_CHR'] = {propName = 'w_ar_lmtm4r_chr'},
    ['WEAPON_FAMAS'] = {propName = 'w_ar_famas'},
    ['WEAPON_SPS_21_SG_CHR'] = {propName = 'did_sps_21_sg_chr'},
    ['WEAPON_MICRO_9_CHR'] = {propName = 'did_micro_9_chr'},
    ['WEAPON_VX_SCORPION_CHR'] = {propName = 'did_vx_scorpion_chr'},
    ['WEAPON_NVRIFLE_CHR'] = {propName = 'did_w_nvrifle_chr'},
    ['WEAPON_REDL'] = {propName = 'w_leogunsakred_assaultrifle'},
    ['WEAPON_TR_88_CHR'] = {propName = 'did_tr_88_chr'},
    ['WEAPON_M270D_CHR'] = {propName = 'did_m270d_chr'},
    ['WEAPON_M4BEAST'] = {propName = 'w_ar_m4beast'},
    ['WEAPON_TAR21'] = {propName = 'w_ar_tar21'},
    ['WEAPON_BAS_P_RED'] = {propName = 'w_sb_bas_p'},
    ['WEAPON_KS1'] = {propName = 'w_ar_ks1'},
    ['WEAPON_SMG9'] = {propName = 'w_sb_smg9'},
    ['WEAPON_L85_CHR'] = {propName = 'w_ar_l85_chr'},
    ['WEAPON_BUTERFLY'] = {propName = 'w_me_buterfly_01'},
    ['WEAPON_DIRTYSYRINGE'] = {propName = 'w_me_dirtysyringe_01'},
    ['WEAPON_PEELER'] = {propName = 'w_me_peeler_01'},
    ['WEAPON_RULER'] = {propName = 'w_me_ruler'},
    ['WEAPON_BIGSPOON'] = {propName = 'w_me_bigspoon'},
    ['WEAPON_JABSAW'] = {propName = 'w_me_jabsaw_01'},
    ['WEAPON_TELESCOPE'] = {propName = 'w_me_telescope'},
    ['WEAPON_MEATSKEWER'] = {propName = 'w_me_meatskewer'},
    ['WEAPON_SWORDFISH'] = {propName = 'w_me_swordfish_01'},
    ['WEAPON_LOBSTER'] = {propName = 'w_me_lobster'},
    ['WEAPON_PLIERS'] = {propName = 'w_me_pliers'},
    ['WEAPON_HANDDRILL'] = {propName = 'w_me_handdrill_01'},
    ['WEAPON_TWISTEDSPEAR'] = {propName = 'w_me_twistedspear_01'},
    ['WEAPON_SNAKEKNIFE'] = {propName = 'w_me_snakeknife_01'},
    ['WEAPON_CRUTCHKNIFE'] = {propName = 'w_me_crutchknife_01'},
    ['WEAPON_SHARPARROW'] = {propName = 'w_me_sharparrow_01'},
    ['WEAPON_95SIGN'] = {propName = 'w_me_95sign'},
    ['WEAPON_ASSASINGUN'] = {propName = 'w_pi_assasingun'},
    ['WEAPON_BAGUETTE'] = {propName = 'w_me_baguette'},
    ['WEAPON_BANANA'] = {propName = 'w_me_banana'},
    ['WEAPON_BIKE'] = {propName = 'w_me_bike'},
    ['WEAPON_BONE'] = {propName = 'w_me_bone'},
    ['WEAPON_BONESWORD'] = {propName = 'w_me_bonesword'},
    ['WEAPON_BUTTPLUG'] = {propName = 'w_me_buttplug'},
    ['WEAPON_CACTUS'] = {propName = 'w_me_cactus'},
    ['WEAPON_CAMSHAFT'] = {propName = 'w_me_camshaft'},
    ['WEAPON_CARJACK'] = {propName = 'w_me_carjack'},
    ['WEAPON_CONE'] = {propName = 'w_me_cone'},
    ['WEAPON_CROSSSPANNER'] = {propName = 'w_me_crossspanner'},
    ['WEAPON_CUCUMBER'] = {propName = 'w_me_cucumber'},
    ['WEAPON_DISABLEDSIGN'] = {propName = 'w_me_disabledsign'},
    ['WEAPON_ELDERSWAND'] = {propName = 'w_me_elderswand_01'},
    ['WEAPON_MFIREEXTINGUISHER'] = {propName = 'w_me_mfireextinguisher'},
    ['WEAPON_FISHINGROD'] = {propName = 'w_me_fishingrod'},
    ['WEAPON_GASCYLINDER'] = {propName = 'w_me_gascylinder'},
    ['WEAPON_HOCKEYFSTICK'] = {propName = 'w_me_hockeyfieldstick'},
    ['WEAPON_HORN'] = {propName = 'w_me_horn'},
    ['WEAPON_JDBOTTLE'] = {propName = 'w_me_jdbottle'},
    ['WEAPON_KEYBOARD'] = {propName = 'w_me_keyboard'},
    ['WEAPON_KITCHENFORK'] = {propName = 'w_me_kitchenfork'},
    ['WEAPON_LACROSSESTICK'] = {propName = 'w_me_lacrossestick'},
    ['WEAPON_LADDER'] = {propName = 'w_me_ladder'},
    ['WEAPON_MAILBOX'] = {propName = 'w_me_mailbox'},
    ['WEAPON_MIC'] = {propName = 'w_me_mic'},
    ['WEAPON_NOPARKINGSIGN'] = {propName = 'w_me_noparkingsign'},
    ['WEAPON_PEN'] = {propName = 'w_me_pen_01'},
    ['WEAPON_PENCIL'] = {propName = 'w_me_pencil_01'},
    ['WEAPON_PROSLEG'] = {propName = 'w_me_prosleg'},
    ['WEAPON_ROLLINGPIN'] = {propName = 'w_me_rollingpin'},
    ['WEAPON_RONABOTTLE'] = {propName = 'w_me_ronabottle'},
    ['WEAPON_ROUTE66SIGN'] = {propName = 'w_me_route66sign'},
    ['WEAPON_SCOOTER'] = {propName = 'w_me_scooter'},
    ['WEAPON_SHOCKABSORBER'] = {propName = 'w_me_shockabsorber'},
    ['WEAPON_SKULLBAT'] = {propName = 'w_me_skullbat'},
    ['WEAPON_SPARTANSWORD'] = {propName = 'w_me_spartansword_01'},
    ['WEAPON_SPATULA'] = {propName = 'w_me_spatula'},
    ['WEAPON_STEPLADDER'] = {propName = 'w_me_stepladder'},
    ['WEAPON_STREETLIGHT'] = {propName = 'w_me_streetlight'},
    ['WEAPON_TOASTER'] = {propName = 'w_me_toaster'},
    ['WEAPON_VACUUM'] = {propName = 'w_me_vacuum'},
    ['WEAPON_WRONGWAYSIGN'] = {propName = 'w_me_wrongwaysign'},
    ['WEAPON_YARI'] = {propName = 'w_me_yari_lr'},
    ['WEAPON_BLACKBELT'] = {propName = 'w_me_blackbelt'},
    ['WEAPON_BENTFORK'] = {propName = 'w_me_bentfork_01'},
    ['WEAPON_BLACKBACKPACK'] = {propName = 'w_me_blackbackpack'},
    ['WEAPON_BRCHICKEN'] = {propName = 'w_me_brchicken'},
    ['WEAPON_DOORBARS'] = {propName = 'w_me_doorbars'},
    ['WEAPON_EARBUDBLADE'] = {propName = 'w_me_earbudblade_lr'},
    ['WEAPON_HONEYDIPPER'] = {propName = 'w_me_honeydipper'},
    ['WEAPON_KETTLE'] = {propName = 'w_me_kettle'},
    ['WEAPON_LEATHERBRIEFCASE'] = {propName = 'w_me_leatherbriefcase'},
    ['WEAPON_MAKESHIFTKNIFE'] = {propName = 'w_me_makeshiftknife_01'},
    ['WEAPON_MEASURINGCUP'] = {propName = 'w_me_measuringcup'},
    ['WEAPON_MODDEDNIGHTSTICK'] = {propName = 'w_me_moddednightstick'},
    ['WEAPON_TRAYRACK'] = {propName = 'w_me_trayrack'},
    ['WEAPON_POKER'] = {propName = 'w_me_poker_01'},
    ['WEAPON_PRISONKEY'] = {propName = 'w_me_prisonkey_01'},
    ['WEAPON_VIOBACKPACK'] = {propName = 'w_me_viobackpack'},
    ['WEAPON_REDBACKPACK'] = {propName = 'w_me_redbackpack'},
    ['WEAPON_TEAPOT'] = {propName = 'w_me_teapot'},
    ['WEAPON_PRISTOI'] = {propName = 'w_me_prisontoilete'},
    ['WEAPON_SHIV'] = {propName = 'w_me_shiv_01'},
    ['WEAPON_FETE21'] = {propName = 'w_me_knifecustom_01'},
    ['WEAPON_GK47'] = {propName = 'w_ar_gk47'},
    ['WEAPON_COMBAT_SG_CHR'] = {propName = 'did_combat_sg_chr'},
    ['WEAPON_R90_CHR'] = {propName = 'w_ar_r90_chr'},
    ['WEAPON_G3_2'] = {propName = 'w_ar_g3_2'},
    ['WEAPON_AUG'] = {propName = 'w_ar_aug'},
    ['WEAPON_MINISMG_PINKSPIKE'] = {propName = 'did_minismg_pinkspike'},
    ['WEAPON_M16A1_CHR'] = {propName = 'did_m16a1_chr'},
    ['WEAPON_HX_15_CHR'] = {propName = 'did_hx_15_chr'},
    ['WEAPON_KITTBOWYAXE'] = {propName = 'w_me_kittybowaxe'},
    ['WEAPON_UNICORNHORN'] = {propName = 'w_me_unicornhorn_01'},
    ['WEAPON_BRUNETTEDOLL'] = {propName = 'w_me_brunettedoll'},
    ['WEAPON_BLONDEDOLL'] = {propName = 'w_me_blondedoll'},
    ['WEAPON_ANIMEDOLL'] = {propName = 'w_me_animedoll'},
    ['WEAPON_WEDDINGRING'] = {propName = 'w_me_weddingring'},
    ['WEAPON_FEGUITAR'] = {propName = 'w_me_feguitar'},
    ['WEAPON_FGUITAR'] = {propName = 'w_me_fguitar'},
    ['WEAPON_BABYCHAIRFOOD'] = {propName = 'w_me_eatchairbaby'},
    ['WEAPON_TWEEZERS'] = {propName = 'w_me_tweezers_01'},
    ['WEAPON_PINKSWITCHBLADE'] = {propName = 'w_me_pinkswitchblade'},
    ['WEAPON_KITTYAXE'] = {propName = 'w_me_kittyaxe'},
    ['WEAPON_BABYSEAT'] = {propName = 'w_me_babyseat'},
    ['WEAPON_TWIRLPOP'] = {propName = 'w_me_twirlpop_01'},
    ['WEAPON_ROUNDLOLLY'] = {propName = 'w_me_roundlolly_01'},
    ['WEAPON_HSLOLLY'] = {propName = 'w_me_halfstarlolly_01'},
    ['WEAPON_BUTTERLOLLY'] = {propName = 'w_me_butterlolly_01'},
    ['WEAPON_STEAMIRON'] = {propName = 'w_me_steamiron'},
    ['WEAPON_HAIRBRUSH'] = {propName = 'w_me_hairbrush'},
    ['WEAPON_PINKLOLLY'] = {propName = 'w_me_pinklolly'},
    ['WEAPON_LOLLYBAT'] = {propName = 'w_me_lollybat'},
    ['WEAPON_CANDYKNIFE'] = {propName = 'w_me_candyknife_01'},
    ['WEAPON_ROSEKNIFE'] = {propName = 'w_me_roseknife_01'},
    ['WEAPON_LIPSTICK'] = {propName = 'w_me_lipstick_01'},
    ['WEAPON_BLPURSE'] = {propName = 'w_me_blackpurse'},
    ['WEAPON_PINKPOOLNOODLE'] = {propName = 'w_me_poolnoodlepink'},
    ['WEAPON_WHITEPILLOW'] = {propName = 'w_me_whitepillow'},
    ['WEAPON_PINKPILLOW'] = {propName = 'w_me_pinkpillow'},
    ['WEAPON_FTEDDYPINK'] = {propName = 'w_me_fteddypink'},
    ['WEAPON_FTEDDY'] = {propName = 'w_me_fteddy'},
    ['WEAPON_VIBRATOR'] = {propName = 'w_me_vibrator'},
    ['WEAPON_FDUALSWORD'] = {propName = 'w_me_fdualsword_01'},
    ['WEAPON_CRYSTALROD'] = {propName = 'w_me_crystalrod'},
    ['WEAPON_FZVTWO'] = {propName = 'w_me_fzombieknifevtwo_01'},
    ['WEAPON_FSLIPPERS'] = {propName = 'w_me_fslip'},
    ['WEAPON_BLOSSOMKNIFE'] = {propName = 'w_me_fknife_01'},
    ['WEAPON_BLOSSOMKATANA'] = {propName = 'w_me_fkattana_lr'},
    ['WEAPON_FHATCHET'] = {propName = 'w_me_fhatchet'},
    ['WEAPON_FKNUCKLE'] = {propName = 'w_me_fknuckle'},
    ['WEAPON_CHRIBAG'] = {propName = 'w_me_chribag'},
    ['WEAPON_FBLACKHEEL'] = {propName = 'w_me_fblackheel'},
    ['WEAPON_FPINKHEEL'] = {propName = 'w_me_fpinkheel'},
    ['WEAPON_FREDHEEL'] = {propName = 'w_me_fredheel'},
    ['WEAPON_FBAT'] = {propName = 'w_me_fbat'},
    ['WEAPON_FSPIKEBAT'] = {propName = 'w_me_fspikebat'},
    ['WEAPON_FPICKAXE'] = {propName = 'w_me_fpickaxe'},
    ['WEAPON_FCOMB'] = {propName = 'w_me_fcomb_01'},
    ['WEAPON_PINKKEYBOARD'] = {propName = 'w_me_pinkkeyboard'},
    ['WEAPON_SPIKEDCHOKER'] = {propName = 'w_me_spikedchoker'},
    ['WEAPON_PINKCHOKER'] = {propName = 'w_me_pinkchoker'},
    ['WEAPON_PINKPEPPERSPRAY'] = {propName = 'w_pi_pinkpepperspray'},
    ['WEAPON_BLOWDRYER'] = {propName = 'w_me_blowdryer'},
    ['WEAPON_BOBSFISHINGNET'] = {propName = 'w_me_bobsfishingnet'},
    ['WEAPON_DRAGONDOLL'] = {propName = 'w_me_dragondoll'},
    ['WEAPON_WEAPON_FCLOSEDUMBRELLA'] = {propName = 'w_me_fclosedumbrella_01'},
    ['WEAPON_FLAMINGO'] = {propName = 'w_me_flamingo'},
    ['WEAPON_FSCEPTER'] = {propName = 'w_me_fscepter_01'},
    ['WEAPON_FUMBRELLA'] = {propName = 'w_me_fumbrella'},
    ['WEAPON_GOLDDIGGER'] = {propName = 'w_me_golddigger'},
    ['WEAPON_HAIRPIN'] = {propName = 'w_me_hairpin_01'},
    ['WEAPON_HEARTBAG'] = {propName = 'w_me_heartbag'},
    ['WEAPON_KERBSDOLL'] = {propName = 'w_me_kerbsdoll'},
    ['WEAPON_KETTLEBALL'] = {propName = 'w_me_kettleball'},
    ['WEAPON_MARSHSTICK'] = {propName = 'w_me_marshstick_01'},
    ['WEAPON_MERMAID'] = {propName = 'w_me_mermaiddoll'},
    ['WEAPON_MOUSEDOLL'] = {propName = 'w_me_mousedoll'},
    ['WEAPON_OCTOPUSDOLL'] = {propName = 'w_me_octopusdoll'},
    ['WEAPON_PINKBOLTCUTTERS'] = {propName = 'w_me_pinkboltcutters'},
    ['WEAPON_PINKFAXE'] = {propName = 'w_me_pinkfaxe'},
    ['WEAPON_PINKFPICKAXE'] = {propName = 'w_me_pinkfpickaxe'},
    ['WEAPON_PINKHAMMER'] = {propName = 'w_me_pinkhammer'},
    ['WEAPON_PINKHANDFAN'] = {propName = 'w_me_pinkhandfan'},
    ['WEAPON_PINKKNIGHTSTICK'] = {propName = 'w_me_pinknightstick'},
    ['WEAPON_PINKSCREWDRIVER'] = {propName = 'w_me_pinkscrewdriver_01'},
    ['WEAPON_PSLEDGE'] = {propName = 'w_me_pinksledgehammer'},
    ['WEAPON_TIARA'] = {propName = 'w_me_tiara'},
    ['WEAPON_LUUBAG'] = {propName = 'w_me_luubag'},
    ['WEAPON_PINKCUTTER'] = {propName = 'w_me_pinkcutter_01'},
    ['WEAPON_PINKCYBERSWORD'] = {propName = 'w_me_pinkcybersword_01'},
    ['WEAPON_RADABAG'] = {propName = 'w_me_radabag'},
    ['WEAPON_R90_CHR'] = {propName = 'w_ar_r90_chr'},
    ['WEAPON_VX_47_CHR'] = {propName = 'did_vx_47_chr'},
    ['WEAPON_SB_SD_CHR'] = {propName = 'did_sbsd_chr'},
    ['WEAPON_BONECLUB'] = {propName = 'w_me_boneclub'},
    ['WEAPON_BUCKET'] = {propName = 'w_me_bucket'},
    ['WEAPON_COFFIN'] = {propName = 'w_me_coffin'},
    ['WEAPON_DEATHNOTE'] = {propName = 'w_me_deathnote'},
    ['WEAPON_HELLFIRESWORD'] = {propName = 'w_me_hellfiresword'},
    ['WEAPON_INFERNO'] = {propName = 'w_me_inferno'},
    ['WEAPON_PUMPKIN'] = {propName = 'w_me_pumpkin'},
    ['WEAPON_PUMPKIN2'] = {propName = 'w_me_pumpkin2'},
    ['WEAPON_PUMPKINBAT'] = {propName = 'w_me_pumpkinbat'},
    ['WEAPON_ARM'] = {propName = 'w_me_arm'},
    ['WEAPON_LEG'] = {propName = 'w_me_leg'},
    ['WEAPON_STAKE'] = {propName = 'w_me_stake_01'},
    ['WEAPON_TRIPLEBLADEDSCYTHE'] = {propName = 'w_me_triplescythe'},
    ['WEAPON_VOODOO'] = {propName = 'w_me_voodoodoll'},
    ['WEAPON_WITCHBROOM'] = {propName = 'w_me_witchbroom'},
    ['WEAPON_SOULSCYTHE'] = {propName = 'w_me_soulscythe'},
    ['WEAPON_GRAVESTONE'] = {propName = 'w_me_gravestone'},
    ['WEAPON_COMBAT_MP7'] = {propName = 'did_combat_mp7'},
    ['WEAPON_G36'] = {propName = 'w_ar_g36'},
    ['WEAPON_COMBAT_PISTOL_CHROMIUM'] = {propName = 'w_pi_combat_pistol_chromium'},
    ['WEAPON_SHOTGUN_CHROMIUM'] = {propName = 'w_sg_shotgun_chromium'},
    ['WEAPON_G3_2'] = {propName = 'w_ar_g3_2'},
    ['WEAPON_GALILARV2'] = {propName = 'w_ar_galilarv2'},
	['WEAPON_SR_3M_CHR'] = {propName = 'did_sr_3m_chr'},
	['WEAPON_GROZA'] = {propName = 'w_ar_groza'},
	['WEAPON_NUTCRACKER'] = {propName = 'nutcracker'},
	['WEAPON_SNOWSHOVEL'] = {propName = 'snowshovel'},
	['WEAPON_CANECANDY'] = {propName = 'canecandy'},
	['WEAPON_CANECANDYGREEN'] = {propName = 'canecandygreen'},
	['WEAPON_CANDYCUT'] = {propName = 'candycut'},
	['WEAPON_CHRISTMASBAT'] = {propName = 'christmasbat'},
	['WEAPON_CHRISTMASMACHETE'] = {propName = 'christmasmachete'},
	['WEAPON_CHRISTMASPILLOW'] = {propName = 'christmaspillow'},
	['WEAPON_CHRISTMASPLUSH'] = {propName = 'christmasplush'},
	['WEAPON_CHRISTMASTREE'] = {propName = 'christmastree'},
    ['WEAPON_HOCKEYSTICK'] = {propName = 'icehockeystick'},
    ['WEAPON_ICEAXE'] = {propName = 'iceaxe'},
    ['WEAPON_ICEBAT'] = {propName = 'icebat'},
    ['WEAPON_ICEBAT2'] = {propName = 'icebat2'},
    ['WEAPON_ICEBIGAXE'] = {propName = 'icebigaxe'},
    ['WEAPON_ICECUT'] = {propName = 'icecut'},
    ['WEAPON_ICEKATANA'] = {propName = 'icekatana'},
    ['WEAPON_ICELANTERN'] = {propName = 'icelantern'},
    ['WEAPON_ICEPICK'] = {propName = 'icepick'},
    ['WEAPON_ICESKI'] = {propName = 'iceski'},
    ['WEAPON_UZI_ARCBYTE'] = {propName = 'did_uzi_arcbyte'},
    ['WEAPON_RRC3_ACHROMIC'] = {propName = 'did_rrc3_achromic'},
}

for k,v in pairs(WeaponsBackWeaponList) do
    table.insert(weapons_list, k)
end

function CheckWeapon()
	for i = 1, #weapons_list do
		if GetHashKey(weapons_list[i]) == GetSelectedPedWeapon(PlayerPedId()) then
			return true
		end
	end
	return false
end

CreateThread(function()
	local lastUpdate = 0
    while true do
        local inAnim = false

		Player = PlayerPedId()
		ped = PlayerPedId()

		if GetGameTimer() > lastUpdate then
			lastUpdate = GetGameTimer() + 15 * 1000
			playerHolsterAnim = GetResourceKvpString("HolsterAnim")
		end

        if currWeapon ~= GetSelectedPedWeapon(PlayerPedId()) then
            currWeapon = GetSelectedPedWeapon(PlayerPedId())

            holstered = true
            blocked = false
        end

		if playerHolsterAnim == nil then playerHolsterAnim = "SideHolsterAnimation" end

        if playerHolsterAnim == "SideHolsterAnimation" then
            inAnim = true
            loadAnimDict("rcmjosh4")
            loadAnimDict("reaction@intimidation@cop@unarmed")
            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            blocked   = true
                            CreateThread(function ()
                                while blocked do
                                    DisableControlAction(0, 45)
                                    DisableControlAction(0, 140)
                                    DisableControlAction(0, 24)
                                    DisableControlAction(0, 25)
                                    Wait(1)
                                end
                            end)
                            SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
                            TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                          
                            Citizen.Wait(100)
                            SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
                            TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                            Citizen.Wait(800)
                            ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(50)
                    else
                        if not holstered then
                            blocked = true
                            CreateThread(function ()
                                while blocked do
                                    DisableControlAction(0, 45)
                                    DisableControlAction(0, 140)
                                    DisableControlAction(0, 24)
                                    DisableControlAction(0, 25)
                                    Wait(1)
                                end
                            end)
                                TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                                    Citizen.Wait(500)
                                TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                                    Citizen.Wait(120)
                                ClearPedTasks(ped)
                                blocked = false
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                    Citizen.Wait(50)
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif playerHolsterAnim == "BackHolsterAnimation" then
            inAnim = true
            loadAnimDict("reaction@intimidation@1h")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                    Citizen.Wait(600)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(40)
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(2000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                    Citizen.Wait(50)
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        end

        if inAnim then
            Wait(500)
        else
            Wait(3000)
        end
    end
end)

local holsterConfig = {
    -- Exemple : FrontHolsterAnimation
    ["FrontHolsterAnimation"] = {
        -- On a besoin d’un seul dict et d’une seule anim pour le draw et le holster
        animDicts = { "combat@combat_reactions@pistol_1h_gang" },
        drawAnim  = "0",    -- Animation pour sortir l'arme
        holsterAnim = "0",  -- Animation pour ranger l'arme
        drawTime  = 600,    -- Temps d'attente (ms) quand on sort l'arme
        holsterTime = 1000, -- Temps d'attente (ms) quand on range l'arme
    },

    -- Exemple : AgressiveFrontHolsterAnimation
    ["AgressiveFrontHolsterAnimation"] = {
        -- Ici on doit charger deux dicts différents, un pour la sortie, l’autre pour le holster
        animDicts = {
            "combat@combat_reactions@pistol_1h_hillbilly",
            "combat@combat_reactions@pistol_1h_gang"
        },
        drawAnim     = { dict = "combat@combat_reactions@pistol_1h_hillbilly", name = "0", time = 600 },
        holsterAnim  = { dict = "combat@combat_reactions@pistol_1h_gang",       name = "0", time = 1000 },
    },

    -- Exemple : SideLegHolsterAnimation
    ["SideLegHolsterAnimation"] = {
        animDicts  = { "reaction@male_stand@big_variations@d" },
        drawAnim   = { dict = "reaction@male_stand@big_variations@d", name = "react_big_variations_m", time = 500 },
        holsterAnim= { dict = "reaction@male_stand@big_variations@d", name = "react_big_variations_m", time = 500 },
    }
}

local function loadAnimDicts(dicts)
    if type(dicts) == "string" then
        dicts = { dicts }
    end

    for _,dict in ipairs(dicts) do
        if not HasAnimDictLoaded(dict) then
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(0)
            end
        end
    end
end

local function CheckWeapon(ped)
    -- On suppose que vous avez déjà le code. Exemple bidon :
    local weaponHash = GetSelectedPedWeapon(ped)
    -- Retourne true si c’est une arme “réelle” (à adapter selon vos besoins)
    return weaponHash ~= GetHashKey("WEAPON_UNARMED")
end

CreateThread(function()
    local holstered = true
    local blocked   = false

    while true do
        local ped = PlayerPedId()
        local inAnim = false

        local config = holsterConfig[playerHolsterAnim]

        if config then
            inAnim = true
            loadAnimDicts(config.animDicts)

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter(ped) == 0 
                and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0)
                and not IsPedInParachuteFreeFall(ped) then
                    
                    local hasWeapon = CheckWeapon(ped)

                    if hasWeapon then
                        if holstered then
                            blocked = true
                            local pos = GetEntityCoords(ped, true)
                            local rot = GetEntityHeading(ped)

                            local dictDraw  = config.drawDict  or (type(config.drawAnim) == "table" and config.drawAnim.dict)  or config.animDicts[1]
                            local nameDraw  = config.drawAnim  or (type(config.drawAnim) == "table" and config.drawAnim.name)  or "0"
                            local timeDraw  = (type(config.drawAnim) == "table" and config.drawAnim.time) or config.drawTime or 600

                            TaskPlayAnimAdvanced(ped, dictDraw, nameDraw, pos, 0.0, 0.0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                            Citizen.Wait(timeDraw)

                            ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(40)

                    else
                        if not holstered then
                            local pos = GetEntityCoords(ped, true)
                            local rot = GetEntityHeading(ped)

                            local dictHolster = config.holsterDict or (type(config.holsterAnim) == "table" and config.holsterAnim.dict) or config.animDicts[1]
                            local nameHolster = config.holsterAnim or (type(config.holsterAnim) == "table" and config.holsterAnim.name) or "0"
                            local timeHolster = (type(config.holsterAnim) == "table" and config.holsterAnim.time) or config.holsterTime or 600

                            TaskPlayAnimAdvanced(ped, dictHolster, nameHolster, pos, 0.0, 0.0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                            Citizen.Wait(timeHolster)

                            ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end

                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end

            else
                holstered = true
            end

        end

        if inAnim then
            Citizen.Wait(250)
        else
            Citizen.Wait(1000)
        end
    end
end)

local bypass = false
CreateThread(function()
    while true do
        local inPlace = false
        if not bypass then 
            if IsPedInAnyVehicle(PlayerPedId(), true) then -- Vérifie si le joueur est dans un véhicule
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) -- Obtient le véhicule dans lequel le joueur est
                if GetPedInVehicleSeat(vehicle, 0) == PlayerPedId() then -- Vérifie si le joueur est conducteur
                    inPlace = true
                    if GetIsTaskActive(PlayerPedId(), 165) then -- Vérifie si le joueur essaie de changer de siège
                        SetPedIntoVehicle(PlayerPedId(), vehicle, 0) -- Remet le joueur sur le siège conducteur
                    end
                end
            end
        end
        if not inPlace then 
            Wait(500)
        else
            Wait(1)
        end
    end
end)

RegisterCommand("shuffle", function (source, args)
    if args[1] ~= nil then 
        bypass = true
        Wait(20)
        if IsPedInAnyVehicle(PlayerPedId(), true) then -- Vérifie si le joueur est dans un véhicule
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) -- Obtient le véhicule dans lequel le joueur est
            args[1] = math.floor(tonumber(args[1] - 2))
            SetPedIntoVehicle(PlayerPedId(), vehicle,  args[1]) -- Remet le joueur sur le siège conducteur
        end
    
        bypass = false
    end
end, false)
