fx_version 'cerulean'
game 'gta5'

name "mugshot"

ui_page 'html/index.html'

lua54 'yes'

shared_script '@ox_lib/init.lua'

files {
  "html/js/*",
  "html/js/models/*",
  "html/img/*",
  "html/index.html",
}
client_script {
  "client/cl_mugshot.lua",
}

server_scripts {
  "server/*.lua",
  "server/*.js",
}
