name = "Yakumo Yukari"
author = "Yakumo Yukari"
version = "0.11.9"
description = "Yakumo Yukari comes from unknown world to manipulate Don't Starve Together world!\n\nVersion : "..version.."\nPress [V] to show status.\nYOU MUST ENABLE SCHEME OR YOU'LL GET CRASHED."
forumthread = ""
api_version = 6
api_version_dst = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true 
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- This mod contains major prefab tweaks(AddPrefabPostInit). 
-- Have enough low priority so the mod can be loaded after any other mods to be loaded.
priority = -5

folder_name = folder_name or ""
if not folder_name:find("workshop-") then
    name = name.." - Test"
end

server_filter_tags = {
	"character",
	"yakumoyukari",
	"touhou",
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
		hover = "Set Language",
		options = {
			{ description = "Auto", data = "AUTO" },
			--{ description = "ÇÑ±¹¾î", data = "kr" },
			{ description = "English", data = "en" },
			{ description = "ñéÙþ", data = "ch" },
			--{ description = "¬â¬å¬ã¬ã¬Ü¬Ú¬Û", data = "ru" },
		},
		default = "AUTO",
	},

	{
		name = "diff",
		label = "Difficulty",
		hover = "Set difficulty.",
		options =
		{
			{ description = "Easy", data = "EASY" },
			{ description = "Normal", data = "" },
			{ description = "Hard", data = "HARD" },
		},
		default = "",
	},

	{
		name = "skill",
		label = "Print status info in",
		hover = "Set where to show the status info should display in.",
		options = inspectflag,
		default = 1,
	},


}