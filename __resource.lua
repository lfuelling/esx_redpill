resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Hacking Mission/Job'

version '0.0.1'

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