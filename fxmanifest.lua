
fx_version 'adamant'
game 'gta5'

files {
	'data/loadouts.meta',
	'whitelist_licenses.json',
    'blocked_isp.json'
}

client_scripts {
	'client/main.lua',
	'client/dmg.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/_main.lua',
	'server/names.lua',
	'server/weapons.lua',
	'server/props.lua',
	"server/log.lua"
}