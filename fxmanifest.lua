fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'MrNewb'
description 'A vehicle rental system for FiveM by MrNewb. Utilizing Lua metatables for practice and enhanced code organization.'
version '0.0.2'

shared_scripts {
	'core/init.lua',
	'configs/**/*.lua',
}

client_scripts {
	'modules/**/client.lua',
}

server_scripts {
	'modules/**/server.lua',
}

files {
	'locales/*.json'
}

dependencies {
	'/server:6116',
	'/onesync',
	'community_bridge'
}