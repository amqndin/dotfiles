require("clink.ps1")
require("config.starship")
require("config.aliases")
require("config.zoxide")


load(io.popen('starship init cmd'):read("*a"))()
