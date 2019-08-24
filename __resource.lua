resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Hacking Mission/Job'

version '0.0.3'

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
    'html/lib/jquery-3.4.1.min.js',
    'html/lib/jquery.terminal.min.js',
    'html/lib/jquery.terminal.min.css'
}

client_scripts {
    'client/functions.lua',
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'client/locations.lua',
    'client/commands.lua',
    'res.lua',
    'client/main.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'res.lua',
    'server/main.lua'
}