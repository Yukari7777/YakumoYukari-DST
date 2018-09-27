name = "Yakumo Yukari"
description = "Yakumo Yukari comes from unknown world to manipulate Don't Starve Together world!"
author = "Yakumo Yukari"
version = "0.7.1"
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
	
	{
		name = "inspect",
		label = "Inspect Shadow Creatures",
		options = 
		{
			{ description = "true", data = true },
			{ description = "false", data = false },
		},
		default = true,
	}

}