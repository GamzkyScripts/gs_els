fx_version 'cerulean'
games { 'gta5' }

author 'Eviate'
description 'Emergency Light System'
version '1.0.0'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/images/*',
    'html/sounds/*',
}

shared_scripts {
    'config/config.lua',
    'config/vehicles.lua',
}

client_scripts {
    'config/patterns.lua',
    'client/cl_*.lua',
}

server_scripts {
    'server/sv_*.lua',
}
