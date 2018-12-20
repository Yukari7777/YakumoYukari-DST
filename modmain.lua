PrefabFiles = {
	"yukari_classified",
	"yakumoyukari",
	"yakumoyukari_none",
	"yukariumbre",
	"yukarihat",
	"upgradepanel",
	"ultpanel",
	"ultpanelsw",
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
    Asset( "IMAGE", "bigportraits/yakumoyukari.tex" ),
    Asset( "ATLAS", "bigportraits/yakumoyukari.xml" ),
	
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

	Asset( "ANIM" , "anim/ui_board_5x1.zip"),
}

----- GLOBAL & require list -----
local require = GLOBAL.require
local assert = GLOBAL.assert
require "class"
GLOBAL.TUNNELNETWORK = {}
GLOBAL.TUNNELFIRSTINDEX = nil
GLOBAL.TUNNELLASTINDEX = nil
GLOBAL.NUMTUNNEL = 0

local STRINGS = GLOBAL.STRINGS
local ProfileStatsSet = GLOBAL.ProfileStatsSet
local SpawnPrefab = GLOBAL.SpawnPrefab
local ThePlayer = GLOBAL.ThePlayer
local GetString = GLOBAL.GetString
local TheInput = GLOBAL.TheInput
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local FindEntity = GLOBAL.FindEntity
local SpringCombatMod = GLOBAL.SpringCombatMod
local Language = GetModConfigData("language")

----- Basic settings for Yukari -----
STRINGS.CHARACTER_TITLES.yakumoyukari = "Youkai of Boundaries"
STRINGS.CHARACTER_NAMES.yakumoyukari = "Yakumo Yukari"
STRINGS.CHARACTER_DESCRIPTIONS.yakumoyukari = "has own ability 'youkai power'.\nbecomes dreadful when she obtains the power from the world."
STRINGS.CHARACTER_QUOTES.yakumoyukari = "\"I have taken the first napkin.\""
STRINGS.CHARACTERS.YAKUMOYUKARI = require "speech_yakumoyukari"
if Language == "ch" then
	STRINGS.CHARACTER_TITLES.yakumoyukari = "境界的妖怪"
	STRINGS.CHARACTER_DESCRIPTIONS.yakumoyukari = "拥 有 自 己 的 能 力 '妖 力'.\n 当 她 从 自 己 的 世 界 中 获 得 ' 力 量 ' 之 后 将 变 得 极 其 可 怕."
	STRINGS.CHARACTER_QUOTES.yakumoyukari = "\"我 将 会 掌 控 这 个 世 界！.\""
	STRINGS.CHARACTERS.YAKUMOYUKARI = require "speech_yakumoyukari_ch"
end
AddMinimapAtlas("images/map_icons/yakumoyukari.xml")
AddMinimapAtlas("images/map_icons/yukarihat.xml")
AddMinimapAtlas("images/map_icons/yukariumbre.xml")
AddMinimapAtlas("images/map_icons/minimap_tunnel.xml")
AddMinimapAtlas("images/map_icons/scheme.xml")

---------------- OVERRIDE -----------------

-- Bunnyman Retarget Function
local function BunnymanNormalRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function is_meat(item)
		return item.components.edible and item.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT
	end
	
	local function NormalRetargetFn(inst)
		return FindEntity(inst, TUNING.PIG_TARGET_DIST,
			function(guy)
				return inst.components.combat:CanTarget(guy)
					and (guy:HasTag("monster") or guy:HasTag("youkai")
					or (guy.components.inventory ~= nil and
						guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
						guy.components.inventory:FindItem(is_meat) ~= nil))
			end,
			{ "_combat", "_health" }, -- see entityreplica.lua
			{ "realyoukai" }, -- not even be targetted with meat
			{ "monster", "player" })
	end
	inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
end
-- Pigman Retarget Function
local function PigmanNormalRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function NormalRetargetFn(inst)
		return FindEntity(inst, TUNING.PIG_TARGET_DIST,
			function(guy)
				return (guy.LightWatcher == nil or guy.LightWatcher:IsInLight())
					and inst.components.combat:CanTarget(guy) and (guy:HasTag("monster") or guy:HasTag("youkai"))
			end,
			{ "_combat" }, -- see entityreplica.lua
			inst.components.follower.leader ~= nil and
			{ "playerghost", "INLIMBO", "abigail" } or
			{ "playerghost", "INLIMBO", "realyoukai" })
	end
	inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
end
-- Bat Retarget Function
local function BatRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function MakeTeam(inst, attacker, ...) 
		local leader = SpawnPrefab("teamleader")
		leader.components.teamleader:SetUp(attacker, inst)
		leader.components.teamleader:BroadcastDistress(inst)
	end
	
	local function Retarget(inst)
		local ta = inst.components.teamattacker
		local newtarget = FindEntity(inst, TUNING.BAT_TARGET_DIST, function(guy)
				return inst.components.combat:CanTarget(guy)
			end,
			nil,
			{"bat", "realyoukai"},
			{"character", "monster"}
		)

		if newtarget and not ta.inteam and not ta:SearchForTeam() then
			MakeTeam(inst, newtarget)
		end

		if ta.inteam and not ta.teamleader:CanAttack() then
			return newtarget
		end
	end
	
	inst.components.combat:SetRetargetFunction(3, Retarget)
end
-- Bee Retarget Function
local function KillerbeeRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function KillerRetarget(inst)
		return FindEntity(inst, SpringCombatMod(8),
			function(guy)
				return inst.components.combat:CanTarget(guy)
			end,
			{ "_combat", "_health" },
			{ "insect", "INLIMBO", "realyoukai" },
			{ "character", "animal", "monster" })
	end
	inst.components.combat:SetRetargetFunction(2, KillerRetarget)
end
local function BeeRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function SpringBeeRetarget(inst)
		return GLOBAL.TheWorld.state.isspring and
		FindEntity(inst, 4,
			function(guy)
				return inst.components.combat:CanTarget(guy)
			end,
			{ "_combat", "_health" },
			{ "insect", "INLIMBO", "realyoukai" },
			{ "character", "animal", "monster" })
		or nil
	end
	inst.components.combat:SetRetargetFunction(2, SpringBeeRetarget)
end
-- frog Retarget Function
local function FrogRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function retargetfn(inst)
		if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
		return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy) 
			if not guy.components.health:IsDead() then
				return guy.components.inventory ~= nil
			end
		end,
		{"_combat","_health"},
		{"realyoukai"})
	end
	end
	if inst.components.combat ~= nil then
		inst.components.combat:SetRetargetFunction(3, retargetfn)
	end
end
-- spiders retargetfn
local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
        end,
        { "_combat", "character" },
        { "monster", "INLIMBO", "spiderwhisperer" }
    )
end

local function SpiderRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function NormalRetarget(inst)
		return FindTarget(inst, inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST)
	end
	inst.components.combat:SetRetargetFunction(1, NormalRetarget)
end

local function WarriorRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function WarriorRetarget(inst)
		return FindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
	end
	inst.components.combat:SetRetargetFunction(2, WarriorRetarget)
end

---------- print current upgrade & ability
function SayInfo(inst)
	local HP = 0
	local HN = 0
	local SA = 0
	local PO = 0
	local str = ""
	local skilltable = {}
	local inspect = GetModConfigData("skill") or GetModConfigData("skill", "workshop-1432504104") or 1
	inst.info = inst.info >= (inst.components.upgrader.skilltextpage or 3) and 0 or inst.info

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

-------------------------------
AddPrefabPostInit("bunnyman", BunnymanNormalRetargetFn)
AddPrefabPostInit("pigman", PigmanNormalRetargetFn)
AddPrefabPostInit("bat", BatRetargetFn)
AddPrefabPostInit("bee", BeeRetargetFn)
AddPrefabPostInit("killerbee", KillerbeeRetargetFn)
AddPrefabPostInit("frog", FrogRetargetFn)
AddPrefabPostInit("spider", SpiderRetargetFn)
AddPrefabPostInit("spider_warrior", WarriorRetargetFn)
modimport "scripts/power_init.lua"
modimport "scripts/tunings_yukari.lua"
modimport "scripts/strings_yukari.lua"
modimport "scripts/actions_yukari.lua" -- actions must be loaded before stategraph loads
modimport "scripts/stategraph_yukari.lua"
modimport "scripts/recipes_yukari.lua"
AddModCharacter("yakumoyukari", "FEMALE")