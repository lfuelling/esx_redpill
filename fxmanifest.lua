fx_version 'cerulean'

game 'gta5'

description 'ESX Hacking Mission/Job'

version '0.0.9'

dependency 'bob74_ipl'
dependency 'es_extended'
dependency 'esx_phone'
dependency 'esx_drugfarms'
dependency 'esx_jobs'

ui_page('html/ui.html')

files {
    'html/ui.html',
    'html/ui.js',
    'html/ui.css',
    'html/img/linux.png',
    'html/img/terminal.png',
    'html/lib/jquery.terminal.min.js',
    'html/lib/jquery.terminal.min.css'
}

client_scripts {
    '@es_extended/locale.lua',
    'client/functions.lua',
    'locales/*.lua',
    'config.lua',
    'client/locations.lua',
    'client/commands.lua',
    'res.lua',
    'client/main.lua',
    'client/missions/*.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'res.lua',
    'server/main.lua'
}
