fx_version 'cerulean'
game 'gta5'

author 'Launch'
description 'LB-Tablet dispatch for gun shots'
version '1.2.0'

client_script "src/client.lua"
shared_script "shared/**/*"
server_scripts {
    'src/server.lua'
}

dependencies {
  "lb-tablet",
}