name = "Yakumo Yukari"
author = "Yakumo Yukari"
version = "0.12.04"
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
if folder_name:find("YakumoYukari%-DST") then
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

local Keys = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "PERIOD", "SLASH", "SEMICOLON", "TILDE", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "INSERT", "DELETE", "HOME", "END", "PAGEUP", "PAGEDOWN", "MINUS", "EQUALS", "BACKSPACE", "CAPSLOCK", "SCROLLOCK", "BACKSLASH"}

local KeyOptions = {}
for i = 1, #Keys do KeyOptions[i] = { description = ""..Keys[i].."", data = "KEY_"..Keys[i] } end

configuration_options = {
	{
		name = "language",
		label = "Language",
		hover = "Set Language",
		options = {
			{ description = "Auto", data = "AUTO" },
			--{ description = "�ѱ���", data = "kr" },
			{ description = "English", data = "en" },
			{ description = "����", data = "ch" },
			--{ description = "�����ܬڬ�", data = "ru" },
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

	{
		name = "skillkey",
		label = "Print status key by",
		hover = "Set which key to press to show the status info.",
		options = KeyOptions,
		default = "KEY_V",
	},
}