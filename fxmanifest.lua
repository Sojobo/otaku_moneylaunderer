fx_version "bodacious"
game "gta5"

author "Sojobo#0001"
description "Otaku Money Launderer"
version "1.0.0"

client_scripts {
    "config.lua",
    "client.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}
