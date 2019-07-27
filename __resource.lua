resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Hacking Mission/Job'

version '0.0.1'

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
    'html/lib/jquery-3.4.1.min.js'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'client/main.lua',
    'client/locations.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'server/main.lua'
}