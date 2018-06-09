PrefabFiles = {
	"tunnel",
	"yakumoyukari",
	"yukariumbre",
	"yukarihat",
	"upgradepanel",
	"ultpanel",
	"ultpanelsw",
	"spellcards",
	"barrierfieldfx",
	"scheme",
	"effect_fx"
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

}

----- GLOBAL & require list -----
local require = GLOBAL.require
local assert = GLOBAL.assert
require "class"

local STRINGS = GLOBAL.STRINGS
local ProfileStatsSet = GLOBAL.ProfileStatsSet
local TheCamera = GLOBAL.TheCamera
local IsDLCEnabled = GLOBAL.IsDLCEnabled
local SpawnPrefab = GLOBAL.SpawnPrefab
local ThePlayer = GLOBAL.ThePlayer
local GetString = GLOBAL.GetString
local TheInput = GLOBAL.TheInput
local IsPaused = GLOBAL.IsPaused
local Inspect = GetModConfigData("inspect")
local Language = GetModConfigData("language")
local FindEntity = GLOBAL.FindEntity
local SpringCombatMod = GLOBAL.SpringCombatMod
local IsYukari = ThePlayer and ThePlayer.prefab == "yakumoyukari"

----- Basic settings for Yukari -----
STRINGS.CHARACTER_TITLES.yakumoyukari = "Youkai of Boundaries"
STRINGS.CHARACTER_NAMES.yakumoyukari = "Yakumo Yukari"
STRINGS.CHARACTER_DESCRIPTIONS.yakumoyukari = "has own ability 'youkai power'.\nbecomes dreadful when she get 'power' from her world."
STRINGS.CHARACTER_QUOTES.yakumoyukari = "\"I will control this world, too.\""
STRINGS.CHARACTERS.YAKUMOYUKARI = require "speech_yakumoyukari"
if Language == "chinese" then
	STRINGS.CHARACTER_TITLES.yakumoyukari = "境界的妖怪"
	STRINGS.CHARACTER_DESCRIPTIONS.yakumoyukari = "拥 有 自 己 的 能 力 '妖 力'.\n 当 她 从 自 己 的 世 界 中 获 得 ' 力 量 ' 之 后 将 变 得 极 其 可 怕."
	STRINGS.CHARACTER_QUOTES.yakumoyukari = "\"我 将 会 掌 控 这 个 世 界！.\""
	STRINGS.CHARACTERS.YAKUMOYUKARI = require "speech_yakumoyukari_ch"
end
AddModCharacter("yakumoyukari", "FEMALE")
AddMinimapAtlas("images/map_icons/yakumoyukari.xml")
AddMinimapAtlas("images/map_icons/yukarihat.xml")
AddMinimapAtlas("images/map_icons/yukariumbre.xml")
AddMinimapAtlas("images/map_icons/minimap_tunnel.xml")
AddMinimapAtlas("images/map_icons/scheme.xml")

------ Function ------

function AddSchemeManager(inst)
	inst:AddComponent("scheme_manager")
end

-------------------------------- Scheme gate

-- GLOBAL.jumpintimeline = {}

-- GLOBAL.ACTIONS.JUMPIN.fn = function(act)
    -- if act.target.components.teleporter then
	    -- act.target.components.teleporter:Activate(act.doer)
	    -- return true
	-- elseif act.target.components.schemeteleport then 
		-- act.target.components.schemeteleport:Activate(act.doer)
		-- return true
	-- end
-- end

-- function SimPostInit(player)
	-- local state = player.sg.sg.states["jumpin"]
	-- GLOBAL.jumpintimeline = state.timeline
-- end

-- GLOBAL.DisableWormholeJumpNoise = function()
	-- local player = GLOBAL.ThePlayer
	-- local state = player.sg.sg.states["jumpin"]
	-- state.timeline = nil
-- end

-- GLOBAL.EnableWormholeJumpNoise = function()
	-- local player = GLOBAL.ThePlayer
	-- local state = player.sg.sg.states["jumpin"]
	-- state.timeline = GLOBAL.jumpintimeline
-- end

-- AddSimPostInit(SimPostInit)

---------------------------------------------

function GodTelePort()
	if ThePlayer and IsYukari then
		if ThePlayer.components.upgrader.GodTelepoirt and ThePlayer.istelevalid then
			local Chara = ThePlayer
			if Chara.components.power and Chara.components.power.current >= 20 then
				local function isvalid(x,y,z)
					local ground = GLOBAL.TheWorld
					if ground then
						local tile = ground.Map:GetTileAtPoint(x,y,z)
						return tile ~= 1--[[return value of GROUND.IMPASSIBLE]] and tile < 128--return value of GROUND.UNDERGROUND
					end
					return false
				end
				local x,y,z = TheInput:GetWorldPosition():Get()
				if isvalid(x,y,z) then Chara.Transform:SetPosition(x,y,z) else return false end
				Chara.SoundEmitter:PlaySound("soundpack/spell/teleport")
				Chara:Hide()
				Chara:DoTaskInTime(0.2, function() Chara:Show() end)
				Chara.components.power:DoDelta(-20, false)
			else
				Chara.components.talker:Say(GetString(Chara.prefab, "DESCRIBE_LOWPOWER"))
			end
			Chara.istelevalid = false
			Chara:PushEvent("teleported")
		end
	end
end

TheInput:AddKeyDownHandler(116, GodTelePort)

---------------- OVERRIDE -----------------

local function InventoryDamage(self)
	local function NewTakeDamage(self, damage, attacker, weapon, ...)
		-- GRAZE MECHANISM
		local Chara = ThePlayer
		if self.inst.prefab == "yakumoyukari" then
			local totaldodge = Chara.dodgechance + Chara.components.upgrader.hatdodgechance
			if math.random() < totaldodge then
				local pt = GLOBAL.Vector3(Chara.Transform:GetWorldPosition())
				for i = 1, math.random(3,5), 1 do
					local fx = SpawnPrefab("graze_fx")
					fx.Transform:SetPosition(pt.x + math.random() / 2, pt.y + 0.7 + math.random() / 2 , pt.z + math.random() / 2 )
				end
				Chara:PushEvent("grazed")
				
				return 0
			end
		end
		--check resistance
		for k,v in pairs(self.equipslots) do
			if v.components.resistance and v.components.resistance:HasResistance(attacker, weapon) then
				return 0
			end
		end
		--check specialised armor
		for k,v in pairs(self.equipslots) do
			if v.components.armor and v.components.armor.tags then
				damage = v.components.armor:TakeDamage(damage, attacker, weapon)
				if damage <= 0 then
					return 0
				end
			end
		end
		--check general armor
		for k,v in pairs(self.equipslots) do
			if v.components.armor then
				damage = v.components.armor:TakeDamage(damage, attacker, weapon)
				if damage <= 0 then
					return 0
				end
			end
		end
		-- custom damage reduction
		if self.inst.prefab == "yakumoyukari" then
			if Chara.components.upgrader:IsHatValid(Chara) then
				local hatabsorb = 0
				for i = 2, 5, 1 do
					if Chara.components.upgrader.hatskill[i] then
						hatabsorb = hatabsorb + 0.2
					end
				end
				damage = damage * (1 - hatabsorb)
			end
			
			if Chara.components.upgrader.IsDamage then
				damage = damage * 0.7
			end
			
			if Chara:HasTag("IsDamage") then
				damage = damage * 0.5
			end
		end
		
		return damage
	end
	self.ApplyDamage = NewTakeDamage
end
-- Bunnyman Retarget Function
local function BunnymanNormalRetargetFn(inst)
	local function is_meat(item)
		return item.components.edible and item.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT
	end
	
	local function NormalRetargetFn(inst)
		return FindEntity(inst, TUNING.PIG_TARGET_DIST,
			function(guy)
				return inst.components.combat:CanTarget(guy)
					and (guy:HasTag("monster") or guy:HasTag("youkai"))
					or (guy.components.inventory ~= nil and
						guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
						guy.components.inventory:FindItem(is_meat) ~= nil)
			end,
			{ "_combat", "_health" }, -- see entityreplica.lua
			{ "realyoukai" }, -- not even be targetted with meat
			{ "monster", "player" })
	end
	inst.components.combat:SetRetargetFunction(1, NormalRetargetFn)
end
-- Pigman Retarget Function
local function PigmanNormalRetargetFn(inst)
	local function NormalRetargetFn(inst)
		return FindEntity(inst, TUNING.PIG_TARGET_DIST,

			function(guy)
				return (guy.LightWatcher == nil or guy.LightWatcher:IsInLight())
					and inst.components.combat:CanTarget(guy)
			end,
			{ "monster", "_combat" }, -- see entityreplica.lua
			inst.components.follower.leader ~= nil and
			{ "playerghost", "INLIMBO", "abigail" } or
			{ "playerghost", "INLIMBO", "realyoukai" })
	end
	inst.components.combat:SetRetargetFunction(1, NormalRetargetFn)
end
-- Bat Retarget Function
local function BatRetargetFn(inst)

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
-- Spring Bee Retarget Function
local function BeeRetargetFn(inst)
	local function SpringBeeRetarget(inst)
		return GLOBAL.TheWorld.state.isspring and
        FindEntity(inst, 4,
            function(guy)
                return inst.components.combat:CanTarget(guy)
            end,
            { "_combat", "_health" },
            { "insect", "INLIMBO" },
            { "character", "animal", "monster" })
        or nil
	end
	inst.components.combat:SetRetargetFunction(2, SpringBeeRetarget)
end
local function KillerbeeRetargetFn(inst)
	local function KillerRetarget(inst)
		return FindEntity(inst, SpringCombatMod(8),
			function(guy)
				return inst.components.combat:CanTarget(guy)
			end,
			{ "_combat", "_health" },
			{ "insect", "INLIMBO", "realyoukai" },
			{ "character", "animal", "monster" })
	end
	inst.components.combat:SetRetargetFunction(2, SpringBeeRetarget)
end
-- frog Retarget Function
local function FrogRetargetFn(inst)
	local function retargetfn(inst)
		if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy) 
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil
            end
        end,
        {"_combat","_health"},
		{"realyoukai"}
        )
    end
	end
	inst.components.combat:SetRetargetFunction(3, retargetfn)
end

local function SetInspectable(inst)
	if Inspect then
		inst:AddComponent("inspectable") 
		if inst:HasTag("NOCLICK") then
			inst:RemoveTag("NOCLICK")
		end
	end
end

local function ToolEfficientFn(self)

	local function ToolEfficient(self, action, effectiveness, ...)
		assert(GLOBAL.TOOLACTIONS[action.id], "invalid tool action")
		if ThePlayer and IsYukari then
			if ThePlayer.components.upgrader and ThePlayer.components.upgrader.IsEfficient then
				if action == GLOBAL.ACTIONS.HAMMER then else
					effectiveness = effectiveness + 0.5
				end
			end
		end
		self.actions[action] = effectiveness or 1
		self.inst:AddTag(action.id.."_tool")
	end
	
	self.SetAction = ToolEfficient
end


---------- print current upgrade & ability
function DebugUpgrade()
	if ThePlayer and ThePlayer.components.upgrader then
		local HP = ThePlayer.health_level
		local HN = ThePlayer.hunger_level
		local SA = ThePlayer.sanity_level
		local PO = ThePlayer.power_level
		
		local str = "Health Upgrade - "..HP.."\nHunger Upgrade - "..HN.."\nSanity Upgrade - "..SA.."\nPower Upgrade - "..PO
		if Language == "chinese" then
			str = "生 命 升 级 - "..HP.."\n饥 饿 升 级 - "..HN.."\n心 智 升 级 - "..SA.."\n妖 力 升 级 - "..PO
		end
		ThePlayer.components.talker:Say(str)
	end
end

function DebugAbility()
	local HP = 0
	local HN = 0
	local SA = 0
	local PO = 0
	
	for i = 1, 4, 1 do
		for j = 1, 6, 1 do
			if ThePlayer and ThePlayer.components.upgrader and ThePlayer.components.upgrader.ability[i][j] then
				if i == 1 then
					HP = HP + 1
				elseif i == 2 then
					HN = HN + 1
				elseif i == 3 then
					SA = SA + 1
				elseif i == 4 then
					PO = PO + 1
				end
			end
		end
	end
	local str = "Health Ability - lev."..HP.."\nHunger Ability - lev."..HN.."\nSanity Ability - lev."..SA.."\nPower Ability - lev."..PO
	if Language == "chinese" then
		str = "生 命 能 力 - lev."..HP.."\n饥 饿 能 力 - lev."..HN.."\n心 智 能 力 - lev."..SA.."\n妖 力 能 力 - lev."..PO
	end
	ThePlayer.components.talker:Say(str)
end

function DebugCooltime()
	
	local Invincible = ""
	
	if ThePlayer and ThePlayer.components.upgrader.InvincibleLearned then
		if ThePlayer.invin_cool then
			if Language == "chinese" then
				if ThePlayer.invin_cool >= 1440 then
					Invincible = "無 敵  -  ? 行"
				elseif ThePlayer.invin_cool > 0 then
					Invincible = "無 敵  -  "..ThePlayer.invin_cool.." 秒 "
				elseif ThePlayer.invin_cool == 0 then
					Invincible = "無 敵  -  準 備"
				end
			else
				if ThePlayer.invin_cool >= 1440 then
					Invincible = "Invincibility - On"
				elseif ThePlayer.invin_cool > 0 then
					Invincible = "Invincibility - "..ThePlayer.invin_cool.."s"
				elseif ThePlayer.invin_cool == 0 then
					Invincible = "Invincibility - Ready"
				end
			end
		end
	end
	
	local str = Invincible
	if str == "" then 
		ThePlayer.components.talker:Say(GetString(ThePlayer.prefab, "DESCRIBE_NOSKILL"))
	else
		ThePlayer.components.talker:Say(str)
	end
end

function DoDebug_1()
	if ThePlayer and ThePlayer:HasTag("yakumoyukari") then 
		if not IsPaused() 
		and not TheInput:IsKeyDown(GLOBAL.KEY_CTRL) 
		and TheInput:IsKeyDown(GLOBAL.KEY_SHIFT) then 
			DebugUpgrade() 
		end
	end
end

function DoDebug_2()
	if ThePlayer and ThePlayer:HasTag("yakumoyukari") then 
		if not IsPaused() 
		and not TheInput:IsKeyDown(GLOBAL.KEY_CTRL) 
		and TheInput:IsKeyDown(GLOBAL.KEY_SHIFT) then 
			DebugAbility() 
		end
	end
end

function DoDebug_3()
	if ThePlayer and ThePlayer:HasTag("yakumoyukari") then 
		if not IsPaused() 
		and not TheInput:IsKeyDown(GLOBAL.KEY_CTRL) 
		and TheInput:IsKeyDown(GLOBAL.KEY_SHIFT) then 
			DebugCooltime() 
		end
	end
end

TheInput:AddKeyDownHandler(98, DoDebug_1)
TheInput:AddKeyDownHandler(118, DoDebug_2)
TheInput:AddKeyDownHandler(110, DoDebug_3)

-------------------------------
modimport "scripts/power_init.lua" -- load "scripts/power_init.lua"
modimport "scripts/actions_yukari.lua"
modimport "scripts/recipes_yukari.lua"
modimport "scripts/strings_yukari.lua"
modimport "scripts/tunings_yukari.lua"
--AddComponentPostInit("inventory", InventoryDamage)
--AddComponentPostInit("tool", ToolEfficientFn)
--AddPrefabPostInit("forest", AddSchemeManager) -- Override function AddSchemeManager to prefab "forest"
--AddPrefabPostInit("cave", AddSchemeManager)
--AddPrefabPostInit("world", AddSchemeManager)
--AddPrefabPostInit("bunnyman", BunnymanNormalRetargetFn)
--AddPrefabPostInit("pigman", PigmanNormalRetargetFn)
--AddPrefabPostInit("bat", BatRetargetFn)
--AddPrefabPostInit("bee", BeeRetargetFn)
--AddPrefabPostInit("killerbee", KillerbeeRetargetFn)
--AddPrefabPostInit("frog", FrogRetargetFn)
--AddPrefabPostInit("shadowwatcher", SetInspectable)
--AddPrefabPostInit("shadowskittish", SetInspectable)
--AddPrefabPostInit("shadowskittish_water", SetInspectable)
--AddPrefabPostInit("creepyeyes", SetInspectable)
--AddPrefabPostInit("crawlinghorror", SetInspectable)
--AddPrefabPostInit("terrorbeak", SetInspectable)
--AddPrefabPostInit("swimminghorror", SetInspectable)
--AddPrefabPostInit("crawlingnightmare", SetInspectable)
--AddPrefabPostInit("nightmarebeak", SetInspectable)