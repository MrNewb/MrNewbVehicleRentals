fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'MrNewbVehicleRentals'
author 'MrNewb'
description 'Vehicle rental locations with paperwork returns built on Newb_Bridge'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    '@Newb_Bridge/import.lua',
    'configs/config.lua',
    'resource/shared/utils.lua',
}

client_scripts {
    'resource/client/rental_menu.lua',
    'resource/client/rental_desks.lua',
}

server_scripts {
    'resource/server/rental_transactions.lua',
}

files {
    'locales/*.json',
}

dependencies {
    '/server:6116',
    '/onesync',
    'ox_lib',
    'Newb_Bridge',
}

escrow_ignore {
    'configs/*.lua',
    'locales/*.json',
    'resource/**/*.lua',
}