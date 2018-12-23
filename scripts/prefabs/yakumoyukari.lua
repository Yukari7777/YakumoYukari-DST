local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("SOUND", "sound/willow.fsb"),

	Asset("IMAGE", "images/colour_cubes/beaver_vision_cc.tex"),

	Asset("ANIM", "anim/ghost_yakumoyukari_build.zip"),
}

local prefabs = { -- deps; should be a list of prefabs that it wants to have loaded in order to be able to create prefab.
	"yukari_classified",
	"yakumoyukari_none",
}

local function YukariOnSetOwner(inst)
	if TheWorld.ismastersim then
        inst.yukari_classified.Network:SetClassifiedTarget(inst)
    end
end

local function AttachClassified(inst, classified)
	inst.yukari_classified = classified
    inst.ondetachyukariclassified = function() inst:DetachYukariClassified() end
    inst:ListenForEvent("onremove", inst.ondetachyukariclassified, classified)
end

local function DetachClassified(inst)
	inst.yukari_classified = nil
    inst.ondetachyukariclassified = nil
end

local function OverrideOnRemoveEntity(inst)
	inst.OnRemoveYukari = inst.OnRemoveEntity
	function inst.OnRemoveEntity(inst)
		if inst.jointask ~= nil then
			inst.jointask:Cancel()
		end

		if inst.yukari_classified ~= nil then
			if TheWorld.ismastersim then
				inst.yukari_classified:Remove()
				inst.yukari_classified = nil
			else
				inst:RemoveEventCallback("onremove", inst.ondetachyukariclassified, inst.yukari_classified)
				inst:DetachYukariClassified()
			end
		end
		return inst:OnRemoveYukari()
	end
end

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

	if inst.components.upgrader.IsAOE and CanAOE then
		inst.components.combat:DoAreaAttack(data.target, 3, data.weapon, nil, data.stimuli, {"INLIMBO"})
	end
	
end

local function DoPowerRestore(inst, amount)
	local delta = amount * inst.components.upgrader.PowerGainMultiplier
	inst.components.power:DoDelta(delta)
	--inst.HUD.controls.status.power:PulseGreen() 
	--inst.HUD.controls.status.power:ScaleTo(1.3,1,.7)
end
	
function OnHealthDelta(inst)
	if  inst.components.health.currenthealth <= 30 
	and inst.components.upgrader.InvincibleLearned
	and inst.components.upgrader.CanbeInvincibled then
		inst.components.upgrader.CanbeInvincibled = false
		inst.invin_cool = 1440
		inst.IsInvincible = true
		inst.components.health:SetInvincible(true)
		inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_INVINCIBILITY_ACTIVATE"))
		inst:DoTaskInTime(10, function()
			inst.IsInvincible = false
			inst.components.health:SetInvincible(false)
			inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_INVINCIBILITY_DONE"))
		end)
	end
end

function OnHungerDelta(inst, data)
	if inst.yukari_classified ~= nil and inst.yukari_classified.inspell:value() then
		return
	end

	if inst.components.hunger then
		inst.components.combat.damagemultiplier = TUNING.YDEFAULT.DAMAGE_MULTIPLIER + math.max(data.newpercent - (1 - inst.components.upgrader.powerupvalue * 0.2), 0)
	end
end

local function OnSanityDelta(inst, data)
	if inst.components.upgrader.NightVision and (TheWorld.state.phase == "night" or TheWorld:HasTag("cave")) then
		local sanitypercent = data.newpercent
		local powerpercent = inst.components.power ~= nil and inst.components.power:GetPercent() or 0

		if sanitypercent > 0.91 then
			inst.Light:SetRadius(1 + powerpercent * 3);inst.Light:SetFalloff(.9 - powerpercent * 0.25);inst.Light:SetIntensity(0.3);inst.Light:SetColour((127 + powerpercent * 128)/255,0,(127 + powerpercent * 128)/255);inst.Light:Enable(true)
		elseif sanitypercent > 0.9 then -- decrease its radius really fast
			local gappercent = (sanitypercent - 0.9) * 100
			inst.Light:SetRadius((1 + powerpercent * 3) * gappercent);inst.Light:SetFalloff((.9 - powerpercent * 0.25) * gappercent);inst.Light:SetIntensity(0.3);inst.Light:SetColour((127 + powerpercent * 128) * gappercent/255,0,(127 + powerpercent * 128)/255 * gappercent);inst.Light:Enable(true)
		else
			inst.Light:SetRadius(0);inst.Light:SetFalloff(0);inst.Light:SetIntensity(0);inst.Light:SetColour(0,0,0);inst.Light:Enable(false)
		end
	end
end

local function HealthRegen(inst)
	if inst.components.health ~= nil then
		inst.components.health:DoDelta(inst.components.upgrader.regenamount)
	end
end

local function InvincibleRegen(inst)
	if inst.components.health ~= nil and inst.IsInvincible then
		inst.components.health:DoDelta(inst.components.upgrader.emergency, nil, nil, true)
	end
end

local function Cooldown(inst)
	if inst.components.upgrader.ability[1][2] then
		if inst.regen_cool > 0 then
			inst.regen_cool = inst.regen_cool - 1
		elseif inst.regen_cool == 0 
		and inst.components.health ~= nil 
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
	inst.components.sanity.night_drain_mult = 1 - inst.components.upgrader.ResistDark - (inst.components.upgrader.hatequipped and 0.2 or 0)
	
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
		inst.components.hunger.current = 250
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
	P10 = {"meat", "plantmeat", "shark_fin", "fish", "fish_med", "perogies", "guacamole", "monstermeat"},
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
				inst:PushEvent("makefriend")
				inst:DoTaskInTime(math.random() * 0.5, function()
					inst.components.talker:Say(GetString(inst.prefab, "ONEATHUMAN"))
				end)
			end
		end
		return inst.components.eater:eatmeat(food)
	end
end

local function MakeToolEfficient(item)
	item.components.tool.NewEffectiveness = item.components.tool.GetEffectiveness
	function item.components.tool:GetEffectiveness(action)
		local owner = item.components.inventoryitem ~= nil and item.components.inventoryitem.owner
		if owner ~= nil and owner.components.upgrader ~= nil and owner.components.upgrader.IsEfficient and action ~= ACTIONS.HAMMER then
			return self.actions[action] * 1.5 or 0
		end
		return self.actions[action] or 0
	end
end

local function OnEquipHat(inst, data)
	inst.components.upgrader.hatequipped = data.isequipped
end

local ShouldApplyStatus = {
	"armordragonfly", "armorobsidian", "yukarihat"
}

local function OnEquip(inst, data) 
	if inst.components.upgrader ~= nil and inst.components.upgrader.IsEfficient and data.eslot == EQUIPSLOTS.HANDS and data.item ~= nil and data.item.components.tool ~= nil then
		MakeToolEfficient(data.item)
	end
	
	local ShouldApply = false
	for k, v in pairs(ShouldApplyStatus) do
		if data.item.prefab == v then
			ShouldApply = true
			break
		end
	end

	if ShouldApply then
		-- I don't like how Klei sets the fire_damage_scale.
		inst.components.upgrader.fireimmuned = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "armordragonfly"

		if data.item.prefab == "yukarihat" then
			inst.components.upgrader:UpdateHatAbilityStatus(data.item)
		end
		inst.components.upgrader:ApplyStatus()
	end
	
end


local function MakeGrazeable(inst)
	inst.components.inventory.NewTakeDamage = inst.components.inventory.ApplyDamage
	function inst.components.inventory:ApplyDamage(damage, attacker, weapon, ...)
		local totaldodge = (inst.components.upgrader.dodgechance + inst.components.upgrader.hatdodgechance) * (inst.sg:HasStateTag("idle") and 1 or 2) -- double when is moving
		if inst.IsGrazing or math.random() < totaldodge then
			inst:PushEvent("graze")
			return 0
		end
		return inst.components.inventory:NewTakeDamage(damage, attacker, weapon, ...)
	end
end

local function MakeDapperOnEquipItem(inst)
	inst.components.sanity.PreRecalc = inst.components.sanity.Recalc
	function inst.components.sanity.Recalc(self, dt)
		local NumBeforeCalc = 0
		for k, v in pairs(self.inst.components.inventory.equipslots) do
			if v.components.equippable ~= nil then
				local itemdap = v.components.equippable:GetDapperness(self.inst)
				NumBeforeCalc = itemdap < 0 and NumBeforeCalc + itemdap * self.inst.components.upgrader.absorbsanity or NumBeforeCalc
			end
		end
		self.dapperness = NumBeforeCalc ~= 0 and -NumBeforeCalc or 0
		return inst.components.sanity:PreRecalc(dt)
	end
end

local function common_postinit(inst) -- things before SetPristine()
	inst.entity:AddLight()
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
	inst:AddTag("yakumoyukari")

	inst:ListenForEvent("setowner", YukariOnSetOwner)

	OverrideOnRemoveEntity(inst)
	inst.AttachYukariClassified = AttachClassified
	inst.DetachYukariClassified = DetachClassified
end

local master_postinit = function(inst) -- after SetPristine()
	inst.yukari_classified = SpawnPrefab("yukari_classified")
    inst:AddChild(inst.yukari_classified)

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
	MakeDapperOnEquipItem(inst)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = function(inst)
		inst.components.upgrader:ApplyStatus()
	end
	inst.powertable = powertable
	inst.applyupgradelist = ShouldApplyStatus
	
	inst:DoPeriodicTask(1, PeriodicFunction)
	inst:ListenForEvent("healthdelta", OnHealthDelta )
	inst:ListenForEvent("hungerdelta", OnHungerDelta )
	inst:ListenForEvent("sanitydelta", OnSanityDelta )
	inst:ListenForEvent("onattackother", OnhitEvent )
	inst:ListenForEvent("hatequipped", OnEquipHat )
	inst:ListenForEvent("equip", OnEquip )
	inst:ListenForEvent("unequip", OnEquip )
	inst:ListenForEvent("graze", Graze )
	inst:ListenForEvent("debugmode", DebugFunction, inst)

end

return MakePlayerCharacter("yakumoyukari", prefabs, assets, common_postinit, master_postinit)