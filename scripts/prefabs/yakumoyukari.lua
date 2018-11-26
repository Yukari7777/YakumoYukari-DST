local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset( "ANIM", "anim/player_basic.zip" ),
	Asset( "ANIM", "anim/player_idles_shiver.zip" ),
	Asset( "ANIM", "anim/player_actions.zip" ),
	Asset( "ANIM", "anim/player_actions_axe.zip" ),
	Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
	Asset( "ANIM", "anim/player_actions_shovel.zip" ),
	Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
	Asset( "ANIM", "anim/player_actions_eat.zip" ),
	Asset( "ANIM", "anim/player_actions_item.zip" ),
	Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
	Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
	Asset( "ANIM", "anim/player_actions_fishing.zip" ),
	Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
	Asset( "ANIM", "anim/player_bush_hat.zip" ),
	Asset( "ANIM", "anim/player_attacks.zip" ),
	Asset( "ANIM", "anim/player_idles.zip" ),
	Asset( "ANIM", "anim/player_rebirth.zip" ),
	Asset( "ANIM", "anim/player_jump.zip" ),
	Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
	Asset( "ANIM", "anim/player_teleport.zip" ),
	Asset( "ANIM", "anim/wilson_fx.zip" ),
	Asset( "ANIM", "anim/player_one_man_band.zip" ),
	Asset( "ANIM", "anim/shadow_hands.zip" ),
	Asset( "ANIM", "anim/beard.zip" ),
	Asset( "SOUND", "sound/sfx.fsb" ),
	Asset( "SOUND", "sound/wilson.fsb" ),

	Asset( "ATLAS", "images/avatars/avatar_yakumoyukari.xml"),
	Asset( "ATLAS", "images/avatars/avatar_ghost_yakumoyukari.xml"),
}

local prefabs = { -- deps; should be a list of prefabs that it wants to have loaded in order to be able to create prefab.
	"scheme",
	"yukariumbre",
	"yukarihat",
}

-- Custom starting items
local function GetStartInv()
	local difficulty = GetModConfigData("difficulty", "YakumoYukari")
	if difficulty == "easy" then
		return {"meat",
				"meat",
				"meat",
				"meat",
				"meat",
				"scheme",
				"yukariumbre",
				"yukarihat"}
	else return {"scheme",
				"yukariumbre",
				"yukarihat"}
	end
end

local start_inv = GetStartInv()

local function onsave(inst, data)
	data.regen_cool = inst.regen_cool
	data.poison_cool = inst.poison_cool
	data.invin_cool = inst.invin_cool
	data.grazecnt = inst.grazecnt
	data.naughtiness = inst.naughtiness
	data.health_level = inst.components.upgrader.health_level
	data.hunger_level = inst.components.upgrader.hunger_level
	data.sanity_level = inst.components.upgrader.sanity_level
	data.power_level = inst.components.upgrader.power_level
	data.skilltree = inst.components.upgrader.ability
	data.hatlevel = inst.components.upgrader.hatlevel
end

local function onpreload(inst, data)
	if data then
		if inst.components.power then
			inst.regen_cool = data.regen_cool or 0 
			inst.poison_cool = data.poison_cool or 0 
			inst.invin_cool = data.invin_cool or 0 
			inst.grazecnt = data.grazecnt or 0
			inst.components.upgrader.health_level = data.health_level or 0 
			inst.components.upgrader.hunger_level = data.hunger_level or 0
			inst.components.upgrader.sanity_level = data.sanity_level or 0 
			inst.components.upgrader.power_level = data.power_level or 0	
			inst.components.upgrader.hatlevel = data.hatlevel or 1
			inst.components.upgrader.ability = data.skilltree
			inst.components.upgrader:ApplyStatus()

			--re-set these from the save data, because of load-order clipping issues
			if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			if data.power and data.power.current then inst.components.power.current = data.power.current end
			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)
			inst.components.sanity:DoDelta(0)
			inst.components.power:DoDelta(0)
		end
	end
end

local function OnhitEvent(inst, data)
	-- Life Leech
	local CanAOE = math.random() < 0.4
	
	if inst.components.upgrader.IsVampire then
		local target = data.target
		local RegenAmount = inst.components.upgrader.IsAOE and 2 or 1
		if target and target.components.health and not target:HasTag("chester") or
		(target.components.follower and target.components.follower.leader == inst) then
			inst.components.health:DoDelta(RegenAmount, nil, nil, true)
			if CanAOE then
				inst.components.health:DoDelta(5, nil, nil, true)
			end
		end
	end
	
	-- AOE Hit
	if inst.components.upgrader.IsAOE and CanAOE then
		inst.components.combat:DoAreaAttack(data.target, 2, data.weapon, nil, data.stimuli, {"INLIMBO"})
	end
	
end

local function TelePortDelay(inst)
	inst:DoTaskInTime(0.5, function()
		inst.istelevalid = true 
	end)
end

local function DoPowerRestore(inst, amount)
	local delta = amount * inst.components.upgrader.PowerGainMultiplier
	inst.components.power:DoDelta(delta, false)
	--inst.HUD.controls.status.power:PulseGreen() 
	--inst.HUD.controls.status.power:ScaleTo(1.3,1,.7)
end
	
function DoHungerUp(inst, data)
	if inst:HasTag("inspell") then 
		return
	end

	if inst.components.hunger then
		inst.components.combat.damagemultiplier = TUNING.YDEFAULT.DAMAGE_MULTIPLIER + math.max(inst.components.hunger:GetPercent() - (1 - inst.components.upgrader.powerupvalue * 0.2), 0)
	end
end

local function HealthRegen(inst)
	if inst.components.health then
		local delta = inst.components.upgrader.regenamount
		inst.components.health:DoDelta(delta)
	end
end

local function InvincibleRegen(inst)
	if inst.components.health and inst.components.upgrader.emergency then
		local delta = inst.components.upgrader.emergency
		inst.components.health:DoDelta(delta, nil, nil, true) -- DoDelta(amount, overtime, cause, ignore_invincible)
	end
end

function GoInvincible(inst)
	if  inst.components.health 
	and inst.components.health.currenthealth <= 50 
	and inst.components.upgrader.InvincibleLearned
	and inst.components.upgrader.CanbeInvincibled then
		inst.components.upgrader.CanbeInvincibled = false
		inst.components.upgrader.emergency = 4
		inst.IsInvincible = true
		inst.components.health:SetInvincible(true)
		inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_INVINCIBILITY_ACTIVATE"))
		inst:DoTaskInTime(10, function() -- Execute after 10 seconds.
			inst.IsInvincible = false
			inst.invin_cool = 1440
			inst.components.upgrader.emergency = 0
			inst.components.health:SetInvincible(false)
			inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_INVINCIBILITY_DONE"))
		end)
	end
end

local function Cooldown(inst)
	if inst.components.upgrader.ability[1][2] then
		if inst.regen_cool > 0 then
			inst.regen_cool = inst.regen_cool - 1
		elseif inst.regen_cool == 0 
		and inst.components.health 
		and inst.components.health:IsHurt() 
		and inst.components.hunger:GetPercent() > 0.5 then
			HealthRegen(inst)
			inst.regen_cool = inst.components.upgrader.regencool
		end
	end

	if inst.invin_cool > 0 then
		inst.invin_cool = inst.invin_cool - 1
	elseif inst.invin_cool == 0 then
		inst.components.upgrader.CanbeInvincibled = true
	end

	if inst.naughtiness > 0 then
		inst.naughtiness = inst.naughtiness - 1
	end
end

local function PeriodicFunction(inst)
	local Light = inst.light ~= nil or inst.entity:AddLight()
	inst.components.sanity.night_drain_mult = 1 - inst.components.upgrader.ResistDark - (inst.components.upgrader.hatequipped and 0.2 or 0)
	
	if inst.components.upgrader.NightVision then
		if TheWorld.state.phase == "night" or TheWorld:HasTag("cave") then
			if inst.components.sanity and inst.components.sanity:GetPercent() >= 0.8 and inst.components.sanity:GetPercent() < 0.98 then
				inst.Light:SetRadius(1);inst.Light:SetFalloff(.9);inst.Light:SetIntensity(0.3);inst.Light:SetColour(128/255,0,217/255);inst.Light:Enable(true)
			elseif inst.components.sanity and inst.components.sanity:GetPercent() >= 0.98 then
				inst.Light:SetRadius(3);inst.Light:SetFalloff(.5);inst.Light:SetIntensity(0.3);inst.Light:SetColour(128/255,0,217/255);inst.Light:Enable(true)
			else
				Light:SetRadius(0);Light:SetFalloff(0);Light:SetIntensity(0);Light:SetColour(0,0,0);Light:Enable(false)
			end
		else
			Light:SetRadius(0);Light:SetFalloff(0);Light:SetIntensity(0);Light:SetColour(0,0,0);Light:Enable(false)
		end
	end
	
	if inst.components.health and inst.IsInvincible then
		InvincibleRegen(inst)
	end

	if inst.components.health and inst.nohealthpenalty then
		inst.components.heath:SetPenalty(0)
	end

	Cooldown(inst)
end

local function Graze(inst)
	if inst.components.upgrader.Ability_45 and not inst.IsGrazing then
		inst.IsGrazing = true
		inst:DoTaskInTime(0.75, function(inst)
			inst.IsGrazing = false
		end)
	end
	local pt = Vector3(inst.Transform:GetWorldPosition())
	for i = 1, math.random(3,10) do
		local fx = SpawnPrefab("graze_fx")
		fx.Transform:SetPosition(pt.x + math.random() / 2, pt.y + 0.7 + math.random() / 2 , pt.z + math.random() / 2 )
	end
	inst.grazecnt = inst.grazecnt + 1
	DoPowerRestore(inst, math.random(0, 2))
end

local function DebugFunction(inst)
	inst:DoPeriodicTask(1, function()
		if inst.components.power and inst.infpower then
			inst.components.power.max = 300
			inst.components.power.current = 300
		end
		inst.components.hunger.current = 150
		--inst.components.hunger:Pause(true)
		--inst.components.health:SetInvincible(true)
	end)
end	

local powertable = {
	-- Rule : meat value per 10, reduced by 25% when cooked or dried.
	P300 = {"minotaurhorn", "deerclops_eyeball", "tigereye"},
	P100 = {"humanmeat"},
	P80 = {"humanmeat_cooked", "humanmeat_dried"},
	P40 = {"surfnturf"},
	P30 = {"bonestew", "dragoonheart", "trunk_winter"},
	P25 = {"baconeggs"},
	P20 = {"honeyham", "tallbirdegg", "trunk_summer", "turkeydinner", "monsterlasagna"},
	P15 = {"tallbirdegg_cooked", "trunk_cooked", "honeynuggets", "hotchili"},
	P10 = {"meat", "plantmeat", "shark_fin", "fish_raw", "fish_med", "perogies", "guacamole", "monstermeat"},
	P8 = {"meat_dried", "plantmeat_cooked", "fish_med_cooked"},
	P5 = {"smallmeat", "eel", "kabobs", "tropical_fish", "batwing", "froglegs", "bird_egg", "fish_raw_small", "meatballs", "frogglebunwich", "unagi", "drumstick" , "doydoyegg"},
	P4 = {"monstermeat_dried", "cookedsmallmeat","froglegs_cooked","batwing_cooked", "fish_raw_small_cooked", "cookedmonstermeat", "smallmeat_dried", "eel_cooked", "doydoyegg_cooked", "drumstick_cooked", "bird_egg_cooked"}
}

local function oneat(inst, food)
	local key

	for k, v in pairs(powertable) do
		for k2, v2 in pairs(v) do 
			if food.prefab == v2 then
				key = k
				local delta = tonumber(string.sub(key, 2))
				DoPowerRestore(inst, delta)
				break
			end
		end
	end
end

local function MakeSaneOnMeatEat(inst)
	inst.components.eater.eatmeat = inst.components.eater.Eat
	function inst.components.eater:Eat(food)
		if self:CanEat(food) then
			if food.components.edible.foodtype == FOODTYPE.MEAT and food.components.edible.sanityvalue < 0 then
				food.components.edible.sanityvalue = 0
			end
			if food.prefab == "humanmeat" or food.prefab == "humanmeat_cooked" or food.prefab == "humanmeat_dried" then
				food.components.edible.sanityvalue = TUNING.SANITY_LARGE
				food.components.edible.healthvalue = TUNING.HEALING_MED
				inst.components.talker:Say(GetString(inst.prefab, "ONEATHUMAN"))
			end
		end
		return inst.components.eater:eatmeat(food)
	end
end

local function MakeToolEfficient(item)
	item.components.tool.NewEffectiveness = item.components.tool.GetEffectiveness
	function item.components.tool.GetEffectiveness(self, action)
		local owner = item.components.inventoryitem ~= nil and item.components.inventoryitem.owner
		if owner ~= nil and owner.components.upgrader ~= nil and owner.components.upgrader.IsEfficient and action ~= ACTIONS.HAMMER then
			return self.actions[action] * 1.5 or 0
		end
		return item.components.tool.NewEffectiveness(self, action)
	end
end

local function OnEquipHat(inst, data)
	inst.components.upgrader.hatequipped = data.isequipped
	inst.components.upgrader:UpdateHatAbilityStatus(data.inst)
end

local function OnEquip(inst, data) 
	if data.eslot == EQUIPSLOTS.HANDS and data.item ~= nil and data.item.components.tool ~= nil then
		MakeToolEfficient(data.item)
	end

	inst.components.upgrader.fireimmuned = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == ("armordragonfly" or "armorobsidian")	
	-- I don't like how Klei sets the fire_damage_scale.
	inst.components.upgrader:ApplyStatus()
end


local function MakeGrazeable(inst)
	inst.components.inventory.NewTakeDamage = inst.components.inventory.ApplyDamage
	function inst.components.inventory:ApplyDamage(damage, attacker, weapon, ...)
		local totaldodge = inst.components.upgrader.dodgechance + inst.components.upgrader.hatdodgechance
		if inst.IsGrazing or math.random() < totaldodge then
			inst:PushEvent("graze")
			return 0
		end
		return inst.components.inventory:NewTakeDamage(damage, attacker, weapon, ...)
	end
end

local function common_postinit(inst) -- things before SetPristine()
	inst.MiniMapEntity:SetIcon( "yakumoyukari.tex" )

	inst.IsInvincible = false
	inst.IsGrazing = false
	inst.naughtiness = 0
	inst.regen_cool = 0
	inst.poison_cool = 0
	inst.invin_cool = 0
	inst.grazecnt = 0
	inst.info = 0

	inst.maxpower = net_ushortint(inst.GUID, "maxpower")
	inst.currentpower = net_ushortint(inst.GUID, "currentpower")

	inst:AddTag("youkai")
	inst:AddTag("yakumoga")
	inst:AddTag("yakumoyukari")

	inst:AddComponent("keyhandler")
	inst.components.keyhandler:AddActionListener("yakumoyukari", 98, "SayInfo")
end

local master_postinit = function(inst) -- after SetPristine()
	inst:AddComponent("upgrader")
	inst:AddComponent("power")
	
	inst.soundsname = "willow"
	inst.starting_inventory = start_inv -- starting_inventory passed as a parameter is deprecated
	
	inst.components.sanity:SetMax(75)
	inst.components.health:SetMaxHealth(80)
	inst.components.hunger:SetMax(150)
	inst.components.hunger.hungerrate = 1.5 * TUNING.WILSON_HUNGER_RATE
	inst.components.combat.damagemultiplier = TUNING.YDEFAULT.DAMAGE_MULTIPLIER
	inst.components.combat.areahitdamagepercent = TUNING.YDEFAULT.AREA_DAMAGE_PERCENT
	inst.components.builder.science_bonus = 1
	inst.components.eater:SetOnEatFn(oneat)
	MakeSaneOnMeatEat(inst)
	MakeGrazeable(inst)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = function(inst)
		inst.valid = true
		inst.components.upgrader:ApplyStatus()
		inst:PushEvent("yukariloaded")
	end
	inst.powertable = powertable
	
	inst:DoPeriodicTask(1, PeriodicFunction)
	inst:ListenForEvent("hungerdelta", DoHungerUp )
	inst:ListenForEvent("healthdelta", GoInvincible )
	inst:ListenForEvent("onattackother", OnhitEvent )
	inst:ListenForEvent("teleported", TelePortDelay, inst )
	inst:ListenForEvent("hatequipped", OnEquipHat )
	inst:ListenForEvent("equip", OnEquip )
	inst:ListenForEvent("unequip", OnEquip )
	inst:ListenForEvent("graze", Graze )
	inst:ListenForEvent("debugmode", DebugFunction, inst)
end

return MakePlayerCharacter("yakumoyukari", prefabs, assets, common_postinit, master_postinit)