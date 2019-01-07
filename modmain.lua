PrefabFiles = {
	"yukari_classified",
	"yakumoyukari",
	"yakumoyukari_none",
	"yukariumbre",
	"yukarihat",
	"upgradepanel",
	"ultpanel",
	"spellcards",
	"barrierfield_fx",
	"graze_fx",
	"puff_fx",
	"scheme",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/yakumoyukari.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/yakumoyukari.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/yakumoyukari.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/yakumoyukari.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/yakumoyukari_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/yakumoyukari_silho.xml" ),
	Asset( "IMAGE", "images/avatars/avatar_ghost_yakumoyukari.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_yakumoyukari.xml" ),
	Asset( "IMAGE", "images/avatars/avatar_yakumoyukari.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_yakumoyukari.xml" ),

    Asset( "IMAGE", "bigportraits/yakumoyukari.tex" ),
    Asset( "ATLAS", "bigportraits/yakumoyukari.xml" ),
	Asset( "IMAGE", "bigportraits/yakumoyukari_none.tex" ),
    Asset( "ATLAS", "bigportraits/yakumoyukari_none.xml" ),
	
	Asset( "IMAGE", "images/map_icons/yakumoyukari.tex" ),
	Asset( "ATLAS", "images/map_icons/yakumoyukari.xml"  ),
	Asset( "IMAGE", "images/map_icons/minimap_tunnel.tex"),
	Asset( "ATLAS", "images/map_icons/minimap_tunnel.xml"),
	Asset( "IMAGE", "images/map_icons/yukarihat.tex"  ),
	Asset( "ATLAS", "images/map_icons/yukarihat.xml" ),
	Asset( "IMAGE", "images/map_icons/yukariumbre.tex" ),
	Asset( "ATLAS", "images/map_icons/yukariumbre.xml" ),
	Asset( "IMAGE", "images/map_icons/scheme.tex" ),
	Asset( "ATLAS", "images/map_icons/scheme.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/touhoutab.tex" ),
	Asset( "ATLAS", "images/inventoryimages/touhoutab.xml" ),
	Asset( "ANIM" , "anim/power.zip"),
	
	Asset("SOUNDPACKAGE", "sound/soundpack.fev"),
	Asset("SOUND", "sound/spell.fsb"),
}
AddMinimapAtlas("images/map_icons/yakumoyukari.xml")
AddMinimapAtlas("images/map_icons/yukarihat.xml")
AddMinimapAtlas("images/map_icons/yukariumbre.xml")
AddMinimapAtlas("images/map_icons/minimap_tunnel.xml")
AddMinimapAtlas("images/map_icons/scheme.xml")

---------- GLOBAL & require list ----------
local require = GLOBAL.require
local assert = GLOBAL.assert
require "class"
GLOBAL.YUKARISTATINDEX = {"health", "hunger", "sanity", "power"}

local STRINGS = GLOBAL.STRINGS
local FindEntity = GLOBAL.FindEntity
local KnownModIndex = GLOBAL.KnownModIndex

if GLOBAL.UpvalueHacker ~= nil then
	GLOBAL.UpvalueHacker = require("tools/upvaluehacker")
end

GLOBAL.YUKARI_MODNAME = KnownModIndex:GetModActualName("Yakumo Yukari") -- This is also a little trick. ModActualName will be overrided to my test version's if it exists.
GLOBAL.YUKARI_DIFFICULTY = GetModConfigData("diff")

local Language = GetModConfigData("language")
GLOBAL.YUKARI_LANGUAGE = "en"
if Language == "AUTO" then
	for _, moddir in ipairs(KnownModIndex:GetModsToLoad()) do
		local modname = KnownModIndex:GetModInfo(moddir).name
--		if modname == "한글 모드 서버 버전" or modname == "한글 모드 클라이언트 버전" then 
--			GLOBAL.YUKARI_LANGUAGE = "kr"
		if modname == "Chinese Language Pack" or modname == "Chinese Plus" then
			GLOBAL.YUKARI_LANGUAGE = "ch"
--		elseif modname == "Russian Language Pack" or modname == "Russification Pack for DST" or modname == "Russian For Mods (Client)" then
--			GLOBAL.YUKARI_LANGUAGE = "ru"
		end 
	end 
else
	GLOBAL.YUKARI_LANGUAGE = Language
end

modimport "scripts/tunings_yukari.lua"
TUNING.YUKARI_STATUS = TUNING["YUKARI_STATUS"..(GLOBAL.YUKARI_DIFFICULTY or "")]
local STATUS = TUNING.YUKARI_STATUS

modimport "scripts/power_init.lua"
modimport "scripts/strings_yukari.lua"
modimport "scripts/actions_yukari.lua" -- actions must be loaded before stategraph loads
modimport "scripts/stategraph_yukari.lua"
modimport "scripts/recipes_yukari.lua"
---------------------- tunings -------------------------
local SpringCombatMod = GLOBAL.SpringCombatMod

local function FindYoukai(inst, oldfn)
	local TargetRadius = 8

	if inst:HasTag("pig") then
		TargetRadius = TUNING.PIG_TARGET_DIST
	elseif inst:HasTag("bat") then
		TargetRadius = TUNING.BAT_TARGET_DIST
	elseif inst:HasTag("mosquito") then
		TargetRadius = SpringCombatMod(20)
	elseif inst:HasTag("bee") then	
		if inst:HasTag("worker") then
			TargetRadius = 4
		elseif inst:HasTag("killer") then
			TargetRadius = SpringCombatMod(8)
		end
	elseif inst:HasTag("frog") then
		TargetRadius = TUNING.FROG_TARGET_DIST
	elseif inst:HasTag("spider") then
		if inst.prefab == "spider_warrior" then
			TargetRadius = SpringCombatMod(TUNING.SPIDER_WARRIOR_TARGET_DIST)
		else
			TargetRadius = SpringCombatMod(inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST)
		end
	elseif inst:HasTag("spiderqueen") then
		TargetRadius = 10
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TargetRadius * STATUS.FIND_YOUKAI_MULT, { "_combat" })

	for k, v in ipairs(ents) do
		if v ~= inst and v.entity:IsVisible() then 
			if v:HasTag("youkai") then
				return v
			elseif v:HasTag("realyoukai") then
				table.remove(ents, k)  -- no matter what. If Yukari is the real dreadful, do not target.
			end
		end
	end

	return FindEntity(inst, TargetRadius * STATUS.FIND_YOUKAI_MULT, function(guy)
		if guy:HasTag("realyoukai") then
			print("guyhastag realyoukai")
			return "RY"
		end
	end, { "yakumoyukari", "_combat", "_health" })
end

local function ResetRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end

	print("UpvalueHacker", inst.prefab, GLOBAL.UpvalueHacker.GetUpvalue(inst.components.combat.targetfn))

	local targetfnold = inst.components.combat.targetfn
	inst.components.combat.targetfn = function(inst)
--		local findyoukai = FindYoukai(inst)
--		print("findyoukai", findyoukai)
--		if findyoukai == "RY" or findyoukai == nil then
--			return 
--		else 
			return targetfnold(inst)
		--end
	end
end

local RetargetList = { "bunnyman", "pigman", "bat", "mosquito", "bee", "killerbee", "frog", "spider", "spider_warrior", "spierqueen" } 
for k, v in ipairs(RetargetList) do
	print("RetargetList", k, v)
	AddPrefabPostInit(v, ResetRetargetFn)
end

---------- print current upgrade & ability ---------------
local function SayInfo(inst)
	local HP = 0
	local HN = 0
	local SA = 0
	local PO = 0
	local str = ""
	local skilltable = {}
	local inspect = GetModConfigData("skill") or 1
	inst.info = inst.info >= (inst.components.upgrader.skilltextpage or TUNING.YUKARI.SKILLPAGE) and 0 or inst.info

	if inst.info == 0 then
		HP = inst.components.upgrader.health_level
		HN = inst.components.upgrader.hunger_level
		SA = inst.components.upgrader.sanity_level
		PO = inst.components.upgrader.power_level

		str = STRINGS.NAMES.HEALTHPANEL.." : "..HP.."\n"..STRINGS.NAMES.HUNGERPANEL.." : "..HN.."\n"..STRINGS.NAMES.SANITYPANEL.." : "..SA.."\n"..STRINGS.NAMES.POWERPANEL.." : "..PO.."\n"
	elseif inst.info == 1 then
		for i = 1, inst.components.upgrader.skillsort, 1 do
			for j = 1, inst.components.upgrader.skilllevel, 1 do
				if inst.components.upgrader.ability[i][j] then
					if i == 1 then HP = HP + 1
					elseif i == 2 then HN = HN + 1
					elseif i == 3 then SA = SA + 1
					elseif i == 4 then PO = PO + 1
					end
				end
			end
		end

		str = STRINGS.HEALTH.." "..STRINGS.ABILITY.." : lev."..HP.."\n"..STRINGS.HUNGER.." "..STRINGS.ABILITY.." : lev."..HN.."\n"..STRINGS.SANITY.." "..STRINGS.ABILITY.." : lev."..SA.."\n"..STRINGS.POWER.." "..STRINGS.ABILITY.." : lev."..PO.."\n"
	else
		local skillindex = 0
		inst.components.upgrader:UpdateSkillStatus()

		for k, v in pairs(inst.components.upgrader.skill) do
			skillindex = skillindex + 1
			skilltable[skillindex] = v
		end
		inst.components.upgrader.skilltextpage = (skillindex ~= 0 and 2 + math.ceil(skillindex / 3) or 3)

		for k = 1, 3 do
			str = str..(skilltable[(inst.info-2) * 3 + k] or "").."\n"
		end

		if str == "\n\n\n" then
			str = STRINGS.YUKARI_NOSKILL.."\n"
		end
	end
	inst.info = inst.info + 1
	if inspect > 1 then inst.yukari_classified.inspect:set(str) end
	if inspect % 2 == 1 then inst.components.talker:Say(str) end
end
AddModRPCHandler("yakumoyukari", "sayinfo", SayInfo)

AddModCharacter("yakumoyukari", "FEMALE")