fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'MrNewbVehicleRentals'
author 'MrNewb'
description 'Vehicle rental locations with paperwork returns built on Newb_Bridge'
version '1.0.3'

shared_scripts {
    '@ox_lib/init.lua',
    '@Newb_Bridge/import.lua',
    'resource/open/shared/config.lua',
    'resource/modules/core/shared/utils.lua',
}

client_scripts {
    'resource/modules/rentals/client/rental_menu.lua',
    'resource/modules/rentals/client/rental_desks.lua',
}

server_scripts {
    'resource/modules/rentals/server/rental_transactions.lua',
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
    '**/*',
}