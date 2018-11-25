name = "Yakumo Yukari"
author = "Yakumo Yukari"
version = "0.9.6"
description = "Yakumo Yukari comes from unknown world to manipulate Don't Starve Together world!\n\nVersion : "..version.."\nPress [B] to show status."
forumthread = ""
api_version = 6
api_version_dst = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
	"character",
}

configuration_options = {
	{
		name = "difficulty",
		label = "Play Style",
		options =
		{
			{ description = "PVP", data = "easy" },
			{ description = "Standard", data = "default" },
			{ description = "Farmer", data = "hard" },
		},
		default = "default",
	},

}