name = "Yakumo Yukari"
author = "Yakumo Yukari"
version = "0.10.10"
description = "Yakumo Yukari comes from unknown world to manipulate Don't Starve Together world!\n\nVersion : "..version.."\nPress [V] to show status."
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

local inspectflag = {}
for i = 1, 7 do inspectflag[i] = { description = "", data = i } end
inspectflag[1].description = "character"
inspectflag[2].description = "console"
inspectflag[3].description = "console, character"
inspectflag[4].description = "chat"
inspectflag[5].description = "chat, character"
inspectflag[6].description = "chat, console"
inspectflag[7].description = "everywhere"

configuration_options = {
	{
		name = "language",
		label = "Language",
		hover = "Set language",
		options = {
			{ description = "english", data = "en" },
			{ description = "chinese", data = "ch" },
		},
		default = "en",
	},

	{
		name = "difficulty",
		label = "Play Style",
		hover = "Set difficulty.",
		options =
		{
			{ description = "PVP", data = "easy" },
			{ description = "Standard", data = "default" },
			{ description = "Farmer", data = "hard" },
		},
		default = "default",
	},

	{
		name = "skill",
		label = "Print status info in",
		hover = "Set where to show the status info should display in.",
		options = inspectflag,
		default = 1,
	},


}