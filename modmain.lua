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
	Asset( "ANIM" , "anim/ypower.zip"),
	
	Asset("SOUNDPACKAGE", "sound/soundpack.fev"),
	Asset("SOUND", "sound/spell.fsb"),
}
AddMinimapAtlas("images/map_icons/yakumoyukari.xml")
AddMinimapAtlas("images/map_icons/yukarihat.xml")
AddMinimapAtlas("images/map_icons/yukariumbre.xml")
AddMinimapAtlas("images/map_icons/minimap_tunnel.xml")
AddMinimapAtlas("images/map_icons/scheme.xml")

---------- GLOBAL & require list ----------
local STRINGS = GLOBAL.STRINGS
local ProfileStatsSet = GLOBAL.ProfileStatsSet
local SpawnPrefab = GLOBAL.SpawnPrefab
local ThePlayer = GLOBAL.ThePlayer
local GetString = GLOBAL.GetString
local TheInput = GLOBAL.TheInput
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local FindEntity = GLOBAL.FindEntity
local SpringCombatMod = GLOBAL.SpringCombatMod
local KnownModIndex = GLOBAL.KnownModIndex

GLOBAL.YAKUMOYUKARI_MODNAME = KnownModIndex:GetModActualName("Yakumo Yukari - Test") or KnownModIndex:GetModActualName("Yakumo Yukari")
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

GLOBAL.YUKARISTATINDEX = { "health", "hunger", "sanity", "power" }

modimport "scripts/tunings_yukari.lua"
TUNING.YUKARI_STATUS = TUNING["YUKARI_STATUS"..(GLOBAL.YUKARI_DIFFICULTY or "")]

modimport "scripts/power_init.lua"
modimport "scripts/strings_yukari.lua"
modimport "scripts/actions_yukari.lua" -- actions must be loaded before stategraph loads
modimport "scripts/stategraph_yukari.lua"
modimport "scripts/recipes_yukari.lua"
---------------- overrides -----------------
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
local function MosquitoRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function KillerRetarget(inst)
		return FindEntity(inst, SpringCombatMod(20),
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat", "_health" },
        { "insect", "INLIMBO", "realyoukai" },
        { "character", "animal", "monster" })
	end
	inst.components.combat:SetRetargetFunction(2, KillerRetarget)
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
local function SpiderFindTarget(inst, radius)
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
		return SpiderFindTarget(inst, inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST)
	end
	inst.components.combat:SetRetargetFunction(1, NormalRetarget)
end

local function WarriorRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	local function WarriorRetarget(inst)
		return SpiderFindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
	end
	inst.components.combat:SetRetargetFunction(2, WarriorRetarget)
end

local function SpiderqueenRetargetFn(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        local oldtarget = inst.components.combat.target
        local newtarget = FindEntity(inst, 10, 
            function(guy) 
                return inst.components.combat:CanTarget(guy) 
            end,
            { "character", "_combat", "realyoukai" },
            { "monster", "INLIMBO" }
        )

        if newtarget ~= nil and newtarget ~= oldtarget then
            inst.components.combat:SetTarget(newtarget)
        end
    end

	inst.components.combat:SetRetargetFunction(3, Retarget)
end
AddPrefabPostInit("bunnyman", BunnymanNormalRetargetFn)
AddPrefabPostInit("pigman", PigmanNormalRetargetFn)
AddPrefabPostInit("bat", BatRetargetFn)
AddPrefabPostInit("mosquito", MosquitoRetargetFn)
AddPrefabPostInit("bee", BeeRetargetFn)
AddPrefabPostInit("killerbee", KillerbeeRetargetFn)
AddPrefabPostInit("frog", FrogRetargetFn)
AddPrefabPostInit("spider", SpiderRetargetFn)
AddPrefabPostInit("spider_warrior", WarriorRetargetFn)
AddPrefabPostInit("spiderqueen", SpiderqueenRetargetFn)
AddSimPostInit(function()
	if not GLOBAL.TheWorld.ismastersim then
        return 
    end

	GLOBAL.assert(KnownModIndex:IsModEnabled(KnownModIndex:GetModActualName("Scheme")) or KnownModIndex:IsModEnabled(KnownModIndex:GetModActualName("Scheme - Test")), 
	"\n[Yakumo Yukari] No Scheme Network mod detected. Please enable Scheme mod as well. Terminating the server...\n"..
	"[야쿠모 유카리] 스키마 네트워크 모드가 감지되지 않았습니다. 해당 모드도 활성화 해주세요. 서버를 종료합니다...\n"..
	"[八云紫] 无法检测[计划 Network] Mod, 请先启用该Mod。正在终止服务器。。。\n")
end)
---------- print current upgrade & ability
local function SayInfo(inst)
	local HP = 0
	local HN = 0
	local SA = 0
	local PO = 0
	local str = ""
	local skilltable = {}
	local inspect = GetModConfigData("skill") or 1
	inst.infopage = inst.infopage >= (inst.components.upgrader.skilltextpage or TUNING.YUKARI.SKILLPAGE_BASE) and 0 or inst.infopage

	if inst.infopage == 0 then
		HP = inst.components.upgrader.health_level
		HN = inst.components.upgrader.hunger_level
		SA = inst.components.upgrader.sanity_level
		PO = inst.components.upgrader.power_level

		str = STRINGS.NAMES.HEALTHPANEL.." : "..HP.."\n"..STRINGS.NAMES.HUNGERPANEL.." : "..HN.."\n"..STRINGS.NAMES.SANITYPANEL.." : "..SA.."\n"..STRINGS.NAMES.POWERPANEL.." : "..PO.."\n"
	elseif inst.infopage == 1 then
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
			str = str..(skilltable[(inst.infopage-2) * 3 + k] or "").."\n"
		end

		if str == "\n\n\n" then
			str = STRINGS.YUKARI_NOSKILL.."\n"
		end
	end
	inst.infopage = inst.infopage + 1
	if inspect > 1 then inst.yukari_classified.inspect:set(str) end
	if inspect % 2 == 1 then inst.components.talker:Say(str) end
end
AddModRPCHandler("yakumoyukari", "sayinfo", SayInfo)
AddModCharacter("yakumoyukari", "FEMALE")