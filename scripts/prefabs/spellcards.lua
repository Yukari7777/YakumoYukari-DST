function MakeCard(name)

	local fname = "spellcard_"..name
	
	local assets =
	{   
		Asset("ANIM", "anim/spell.zip"),   
		Asset("ATLAS", "images/inventoryimages/"..fname..".xml"),    
		Asset("IMAGE", "images/inventoryimages/"..fname..".tex"),
	}

	local function onfinished(inst)
		inst:Remove()
	end
		
	local function test(inst)
		inst.components.spellcard.costpower = 5
		inst.costpower:set(5)
		inst.components.finiteuses:SetMaxUses(3)
		inst.components.finiteuses:SetUses(3)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			if owner.components.health then
				owner.components.health:DoDelta(20)
			end
			if owner.components.power then
				owner.components.power:DoDelta(-5, false)
			end
			inst.components.finiteuses:Use(1)

			return true
		end)
	end
	
	local function mesh(inst)
		inst.components.spellcard.costpower = 60
		inst.costpower:set(60)
		inst.components.finiteuses:SetMaxUses(3)
		inst.components.finiteuses:SetUses(3)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			if owner.components.sanity then
				local amount = owner.components.sanity:GetMaxWithPenalty() * owner.components.sanity:GetPercent()
				owner.components.sanity:SetPercent(1)
				owner.components.sanity:DoDelta(-amount)
			end
			if owner.components.power then
				owner.components.power:DoDelta(-60, false)
			end
			inst.components.finiteuses:Use(1)
			return true
		end)
	end
	
	local function away(inst)
		inst.components.spellcard.costpower = 1
		inst.costpower:set(1)
		inst.components.finiteuses:SetMaxUses(200)
		inst.components.finiteuses:SetUses(200)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_CLOAKING"))
			owner.AnimState:SetMultColour(0.3,0.3,0.3,.3)
			owner:AddTag("notarget")
		end)
		inst.components.spellcard:SetTaskFn(function(inst, owner)
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 100)
			for k,v in pairs(ents) do
				if v.components.combat and v.components.combat.target == owner then
					v.components.combat.target = nil
				end
			end
			owner.components.power:DoDelta(-1, false)
			inst.components.finiteuses:Use(1)
		end)
		inst.components.spellcard:SetOnRemoveTask(function(inst, owner)
			owner:RemoveTag("notarget")
			owner.AnimState:SetMultColour(1,1,1,1)
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DECLOAKING"))
		end)
		inst.components.finiteuses:SetOnFinished(function()
			owner:RemoveTag("notarget")
			owner.AnimState:SetMultColour(1,1,1,1)
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DECLOAKING"))
			inst:Remove()
		end)
	end
	
	local function necro(inst)
		inst:RemoveComponent("finiteuses")
		inst:AddTag("heavyaction")
		inst.components.spellcard.costpower = 300
		inst.costpower:set(300)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 40)
			for k,v in pairs(ents) do
				if v.components.health and not v:HasTag("player") then
					local maxhealth = v.components.health.maxhealth
					v.components.health:DoDelta(math.min(-maxhealth * 0.33, -500))
				end
				
				if v.components.pickable then
					v.components.pickable:MakeBarren()
				end
				
				if v.components.crop then
					v.components.crop:MakeWithered()
				end
				
				if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
					v.components.growable:SetStage(4)
				end
				
				if v:HasTag("birchnut")
					or v:HasTag("mole")	
					or v.prefab == "carrot_planted" then
					v:Remove()
				end
				
				if v:HasTag("flower") then
					local Evil = SpawnPrefab("flower_evil")
					Evil.Transform:SetPosition(v:GetPosition():Get())
					v:Remove()
				end
			end

			if owner.components.power then
				owner.components.power:DoDelta(-300, false)
			end

			local str = GetString(owner.prefab, "NECRO")

			if owner.components.talker then
				owner.components.talker:Say(str)
			end
			inst:Remove()
		end)
	end
	
	local function curse(inst)
		inst.components.spellcard.costpower = 1
		inst.costpower:set(1)
		inst.components.finiteuses:SetMaxUses(100)
		inst.components.finiteuses:SetUses(100)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			inst.olddmg = owner.components.combat.damagemultiplier
		end)
		inst.components.spellcard:SetTaskFn(function(inst, owner)
			local delta = math.max(3 * (1 - owner.components.sanity:GetPercent()), inst.olddmg)
			owner.components.sanity:DoDelta(- owner.components.sanity:GetMaxWithPenalty() * 0.025)
			owner.components.combat.damagemultiplier = delta * 1.25
			owner.components.locomotor.walkspeed = 6 + delta
			owner.components.locomotor.runspeed = 8 + delta
			owner.components.combat:SetAttackPeriod(0)
			owner.components.power:DoDelta(-1, false)
			inst.components.finiteuses:Use(1)
		end)
		inst.components.spellcard:SetOnRemoveTask(function(inst, owner)
			owner.components.upgrader:ApplyStatus()
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NOREINFORCE"))
		end)
		inst.components.finiteuses:SetOnFinished(function()
			local owner = inst.components.inventoryitem.owner
			owner.components.upgrader:ApplyStatus()
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NOREINFORCE"))
		end)
	end
		
	local function balance(inst)
		inst.components.spellcard.costpower = 150
		inst.costpower:set(150)
		inst.components.finiteuses:SetMaxUses(2)
		inst.components.finiteuses:SetUses(2)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			local Inventory = owner.components.inventory
			local rotcnt = 0

			local function refresh(v)
				if v.components.perishable then
					local max = v.components.perishable.perishtime 
					v.components.perishable:SetPerishTime(max)
				end

				if v.prefab == "spoiled_food" or v.prefab == "rottenegg" then
					if v.components.stackable then
						rotcnt = rotcnt + v.components.stackable:StackSize()
						v:Remove()
					end
				end
			end
			
			for i = 1, rotcnt, 1 do
				owner.components.inventory:GiveItem(SpawnPrefab("wetgoop"))
			end
			
			for k,v in pairs(Inventory.itemslots) do
				refresh(v)
			end

			for k,v in pairs(Inventory.equipslots) do
				if type(v) == "table" and v.components.container then
					for k, v2 in pairs(v.components.container.slots) do
						refresh(v2)
					end
				else
					refresh(v)
				end
			end
			
			if owner.components.power then
				owner.components.power:DoDelta(-150, false)
			end
			inst.components.finiteuses:Use(1)
			return true
		end)
	end
	
	local function laplace(inst)
		inst.components.spellcard.costpower = 0.5
		inst.costpower:set(1)
		inst.components.finiteuses:SetMaxUses(1500)
		inst.components.finiteuses:SetUses(1500)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			if owner.components.playervision == nil then return false end
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NEWSIGHT"))
			owner.nightvision:set(true)
			return true
		end)
		inst.components.spellcard:SetTaskFn(function(inst, owner)
			local HasGoggleVision = owner.components.playervision.gogglevision
			inst.components.finiteuses:Use(1)
			owner.components.power:DoDelta(-0.5, false)
			if HasGoggleVision then -- Player wears goggle in task
				owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_EYEHURT"))
				owner.components.combat:GetAttacked(inst, 1)
				owner.nightvision:set(false)
				return inst.components.spellcard:ClearTask(owner)
			end
		end)
		inst.components.spellcard:SetOnRemoveTask(function(inst, owner)
			owner.nightvision:set(false)
		end)
		inst.components.finiteuses:SetOnFinished(function()
			local owner = inst.components.inventoryitem.owner
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
			owner.nightvision:set(false)
			inst:Remove()
		end)
	end
	
	local function butter(inst)
		inst.components.spellcard.costpower = 80
		inst.costpower:set(80)
		inst:RemoveComponent("finiteuses")
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			if not (TheWorld.components.butterflyspawner and TheWorld.components.birdspawner) then
				owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NOSPAWN"))
			else
				if owner.components.power then
					owner.components.power:DoDelta(-80, false)
				end
				local num = 5 + math.random(5)
				
				local x, y, z = owner.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z, 12, nil, nil, {'magicbutter'})
				if #ents > 10 then
					owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_TOOMANYBUTTER"))
					return
				end
				
				if num > 0 then
					owner:StartThread(function()
						for k = 1, num do
							local pt = TheWorld.components.birdspawner:GetSpawnPoint(Vector3(owner.Transform:GetWorldPosition() ))
							local butter = SpawnPrefab("butterfly")
							butter.Transform:SetPosition(pt.x, pt.y, pt.z)
							butter:AddTag("magicbutter")
						end
					end)
				end
				inst:Remove()
			end
		end)
	end
	
	local function bait(inst) -- name : Bewitching Bait
		inst.components.spellcard.costpower = 1
		inst.costpower:set(1)
		inst.components.finiteuses:SetMaxUses(300)
		inst.components.finiteuses:SetUses(300)
		local function barrier(inst, owner)
			local fx = SpawnPrefab("barrierfield_fx")
			local fx_hitanim = function()
				fx.AnimState:PlayAnimation("hit")
				fx.AnimState:PushAnimation("idle_loop")
			end
			fx.entity:SetParent(owner.entity)
			fx.AnimState:SetScale(0.7,0.7,0.7)
			fx.AnimState:SetMultColour(0.5,0,0.5,0.3)
			fx.Transform:SetPosition(0, 0.2, 0)
			return fx
		end
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			owner:AddTag("spellbait")
			owner.components.upgrader:ApplyStatus()
			owner.components.talker:Say(GetString(owner.prefab, "TAUNT"))
			inst.fx = barrier(inst, owner)
		end)
		inst.components.spellcard:SetTaskFn(function(inst, owner)
			owner.components.power:DoDelta(-1, false)
			if owner:HasTag("realyoukai") then
				owner:RemoveTag("realyoukai")
			end
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 12)
			for k,v in pairs(ents) do
				if v.components.combat and v.components.combat.canattack and v.components.combat.target ~= owner and not v:HasTag("player") then
					v.components.combat:SetTarget(owner)
				end
			end
			inst.components.finiteuses:Use(1)
		end)
		inst.components.spellcard:SetOnRemoveTask(function(inst, owner)
			owner:RemoveTag("spellbait")
			owner.components.upgrader:ApplyStatus()
			inst.fx:kill_fx()
			inst.fx = nil
		end)
		inst.components.finiteuses:SetOnFinished(function()
			local owner = inst.components.inventoryitem.owner
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
			owner:RemoveTag("spellbait")
			owner.components.upgrader:ApplyStatus()
			inst.fx:kill_fx()
			inst.fx = nil
			inst:Remove()
		end)
	end
	
	local function addictive(inst)
		inst.components.spellcard.costpower = 300
		inst.costpower:set(300)
		inst:RemoveComponent("finiteuses")
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 60)
			for k,v in pairs(ents) do
				if v.components.timer then 
					v.components.timer:SetTimeLeft("grow", 0) 
				end

				if v.components.witherable then
					v.components.witherable.withered = false
					v:RemoveTag("withered")
					v:RemoveTag("witherable")
				end

				if v.components.diseaseable then
					v.components.diseaseable:OnRemoveFromEntity()
					v:RemoveComponent("diseaseable")
				end

				if v.components.pickable then
					v.components.pickable.cycles_left = nil
					v.components.pickable.transplanted = false
					if v.rain then
						v.rain = 0
					end
					v.components.pickable:Regen()
				end
				
				if v.components.hackable then
					v:RemoveTag("withered")
					v:RemoveTag("witherable")
					v.components.hackable.withered = false
					v.components.hackable.witherable = false
					v.components.hackable:Regen()
				end

				if v.components.crop then
					v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME * 5)
				end
				
				if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
					v.components.growable:DoGrowth()
					v.components.growable:SetStage(3)
				end
				
				if v.components.grower then
					v.components.grower.cycles_left = 6
				end
				
				if v.components.burnable then
					v.components.burnable:Extinguish()
				end
			end
			if owner.components.power then
				owner.components.power:DoDelta(-300, false)
			end
			inst:Remove()
		end)
	end
	
	local function lament(inst) -- Urashima's Box
		inst:RemoveComponent("finiteuses")
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		inst.components.spellcard.costpower = 20
		inst.costpower:set(20)
		inst.Activated = false
		local LeftSpawnCount = 0
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			local function GetLoot(list)
				local loot = {}
				for i=1, #list, 1 do
					if list[i][5] == nil then
						table.insert(loot, list[i])
					else
						if list[i][5] == "rog" then
							table.insert(loot, list[i])
						end
					end
				end
				return loot
			end

			local function GetPoint(pt)
				local theta = math.random() * 2 * PI
				local radius = 6 + math.random() * 6
				
				local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
					local ground = GetWorld()
					local spawn_point = pt + offset
					if not (ground.Map and ground.Map:GetTileAtPoint(spawn_point.x, spawn_point.y, spawn_point.z) == GROUND.IMPASSABLE) then
						return true
					end
					return false
				end)
				
				if result_offset then
					return pt+result_offset
				end
			end

			local function SleepNearbyPlayer(prefab, owner)
				prefab:DoTaskInTime(1, function(prefab, owner)
					local x, y, z = prefab.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, TUNING.MANDRAKE_SLEEP_RANGE, nil, nil, { "player" })
					for i, v in ipairs(ents) do
						v:PushEvent("yawn", { grogginess = 4, knockoutduration = TUNING.MANDRAKE_SLEEP_TIME + math.random() })
					end
				end)
				prefab:DoTaskInTime(2.5, function(prefab)
					prefab:Remove()
				end)
			end

			local LootTable_c = { -- {name, LeftSpawnCount, grade, OnSpawnfunction, WorldTag}
				{"cutgrass", math.random(4), "common"},
				{"twigs", math.random(4), "common"},
				{"log", math.random(3), "common"},
				{"rocks", math.random(3), "common"},
				{"flint", math.random(3), "common"},
				{"silk", math.random(3), "common"},
				{"sand", math.random(3), "common", nil, "sw"},
				{"palmleaf", math.random(2), "common", nil, "sw"},
				{"seashell", math.random(2), "common", nil, "sw"},
				{"fabric", math.random(2), "common", nil, "sw"},
				{"vine", math.random(2), "common", nil, "sw"},
				{"bamboo", math.random(2), "common", nil, "sw"},
			}
			local LootTable_g = {
				{"footballhat", 1, "good", function(prefab) if prefab.components.armor then prefab.components.armor:SetCondition(math.random(prefab.components.armor.maxcondition * 0.66, prefab.components.armor.maxcondition)) end end},
				{"armorwood", 1 , "good", function(prefab) if prefab.components.armor then prefab.components.armor:SetCondition(math.random(prefab.components.armor.maxcondition * 0.66, prefab.components.armor.maxcondition)) end end},
				{"boneshard", math.random(2), "good"},
				{"nitre", math.random(2), "good"},
				{"goldnugget", math.random(3), "good"},
				{"papyrus", math.random(3), "good"},
				{"spidergland", math.random(3), "good"},
				{"livinglog", math.random(2), "good"},
				{"nightmarefuel", math.random(3), "good"},
				{"petals", math.random(2), "good", nil, "rog"},
				{"antivenom", math.random(2), "good", nil, "sw"},
				{"ice", math.random(3, 6), "good", nil, "sw"},
				{"limestone", math.random(2), "good", nil, "sw"},
				{"dubloon", math.random(4, 8), "good", nil, "sw"},
			}
			local LootTable_r = {
				{"gears", math.random(2), "rare"},
				{"redgem", math.random(4), "rare"},
				{"bluegem", math.random(4), "rare"},
				{"purplegem", math.random(4), "rare"},
				{"yellowgem", math.random(2), "rare", nil, "rog"},
				{"orangegem", math.random(2), "rare", nil, "rog"},
				{"greengem", math.random(2), "rare", nil, "rog"},
				{"thulecite", math.random(3), "rare", nil, "rog"},
				{"obsidian", math.random(3), "rare", nil, "sw"},
				{"purplegem", math.random(2), "rare", nil, "sw"},
			}
			local LootTable_b = {
				{"ash", math.random(2), "bad", function() if owner.components.health then owner.components.health:DoDelta(-2, nil, nil, true) end end},
				{"spoiled_food", math.random(2), "bad", function() if owner.components.hunger then owner.components.hunger:DoDelta(-3, nil, true) end end},
				{"rottenegg", math.random(2), "bad", function() if owner.components.hunger then owner.components.hunger:DoDelta(-3, nil, true) end end},
				{"charcoal", math.random(2), "bad", function() if owner.components.sanity then owner.components.sanity:DoDelta(-2) end end},
				{"killerbee", math.random(2), "bad"},
				{"mosquito", 1, "bad", nil, "rog"},
				{"frog", 1, "bad", nil, "rog"},
				{"monkey", 1, "bad", nil, "rog"},
				{"spider_hider", 1, "bad", nil, "rog"},
				{"spider_spitter", 1, "bad", nil, "rog"},
				{"mosquito_poison", 1, "bad", nil, "sw"},
				{"primeape", 1, "bad", nil, "sw"},
				{"spider", math.random(2), "bad", nil, "sw"},
			}
			local LootTable_h = {
				{"ash", math.random(3), "bad", function() if owner.components.health then owner.components.health:DoDelta(-3, nil, nil, true) end end},
				{"spoiled_food", math.random(3), "suck", function() if owner.components.hunger then owner.components.hunger:DoDelta(-50, nil, true) end end},
				{"rottenegg", math.random(3), "suck", function() if owner.components.hunger then owner.components.hunger:DoDelta(-50, nil, true) end end},
				{"charcoal", math.random(3), "suck", function() if owner.components.sanity then owner.components.sanity:DoDelta(-50) end end},	
				{"crawlingnightmare", math.random(2), "suck", function() if owner.components.sanity then owner.components.sanity:DoDelta(-300) end end},
				{"nightmarebeak", 1, "suck",  function() if owner.components.sanity then owner.components.sanity:DoDelta(-300) end end},
				{"killerbee", 6, "suck"},
				{"krampus", math.random(3), "suck"},
				{"panflute", math.random(3), "suck", SleepNearbyPlayer},
				{"deerclops", 1, "suck", function(prefab) prefab:DoTaskInTime(10, function() TheWorld:PushEvent("ms_sendlightningstrike", prefab.Transform:GetWorldPosition()); prefab:Remove()  end) end, "rog"},
				{"mosquito", 4, "suck", nil, "rog"},
				{"mosquito_poison", math.random(3), "suck", nil, "sw"},
			}

			local function GetColor(grade)
				if grade == "common" then
					return {r=0.5,g=0.5,b=0.5,a=1}
				elseif grade == "good" then
					return {r=0,g=1,b=0,a=1}
				elseif grade == "rare" then
					return {r=1,g=0,b=1,a=1}
				elseif grade == "bad" then
					return {r=0.3,g=0.3,b=0.3,a=1}
				elseif grade == "suck" then
					return {r=0,g=0,b=0,a=1}
				end
			end

			local function DoSpawn()
				local naughtiness = owner.naughtiness or 0
				local key, amount, grade, pt, list, loot, speech, color
				local SpawnDelay = LeftSpawnCount > 1 and 0.7 or 1.2
				owner:DoTaskInTime(SpawnDelay, function()
					if LeftSpawnCount > 1 then 
						if naughtiness < 150 then
							if math.random() < 0.66 then -- 66%, common stuff
								list = LootTable_c
							elseif math.random() < 0.66 then -- 21%, good stuff
								list = LootTable_g
							elseif math.random() < 0.66 then -- 7%, rare stuff
								list = LootTable_r
							else							-- 6%, bad stuff
								list = LootTable_b
							end
						elseif naughtiness < 300 then
							if math.random() < 0.33 then -- 33%, common stuff
								list = LootTable_c
							elseif math.random() < 0.1 then -- 6%, good stuff
								list = LootTable_g
							else							-- 60%, bad stuff
								list = LootTable_b
							end
						else
							list = LootTable_b -- 100%, bad stuff
						end
					else
						speech = GetString(owner.prefab, "LAMENT_B")
						if naughtiness < 200 then
							list = LootTable_b 
						else
							Speech = GetString(owner.prefab, "LAMENT_H")
							list = LootTable_h
						end
					end
					loot = GetLoot(list)
					key = math.random(#loot)
					amount = loot[key][2]
					grade = loot[key][3]
					color = GetColor(grade)
					for i = 1, amount do
						owner:DoTaskInTime(LeftSpawnCount > 1 and 0.2 / i or 0, function()
							local prefab = SpawnPrefab(loot[key][1]) -- spawn thing
							local pt = GetPoint(Vector3(owner.Transform:GetWorldPosition()))
							prefab.Transform:SetPosition(pt.x, pt.y, pt.z)
							prefab:AddTag("spawned")
							if prefab.components.lootdropper then
								prefab.components.lootdropper.numrandomloot = 0 -- Delete item drop.
								prefab.components.lootdropper:SetLoot({})
								prefab.components.lootdropper:SetChanceLootTable('nodrop')
							end
							if loot[key][4] then
								loot[key][4](prefab, owner)
							end
							local fx = SpawnPrefab("puff_fx")
							fx.AnimState:SetMultColour(color.r, color.g, color.b, color.a)
							fx.Transform:SetPosition(pt.x, pt.y, pt.z)
							if grade == "bad" or grade == "suck" then
								owner.SoundEmitter:PlaySound("dontstarve/HUD/sanity_down")
							else
								owner.SoundEmitter:PlaySound("soundpack/spell/item")
							end
						end)
					end
					if LeftSpawnCount > 1 then 
						LeftSpawnCount = LeftSpawnCount - 1
						DoSpawn()
					else
						local x,y,z = owner.Transform:GetWorldPosition()
						local ents = TheSim:FindEntities(x, y, z, 30)
						owner.components.health:SetInvincible(false)
						owner:RemoveTag("notarget")
						for k,v in pairs(ents) do
							if v.components.combat and v:HasTag("spawned") then
								v.components.combat:SetTarget(owner)
							end
						end
						if owner.components.playercontroller ~= nil then
							owner.components.playercontroller:Enable(true)
						end
						owner.naughtiness = owner.naughtiness + 30 + math.random(50)
						owner:DoTaskInTime(0.8, function(owner) owner.components.talker:Say(speech) end)
						LeftSpawnCount = 0
						inst.Activated = false
						owner:RemoveTag("inspell")
					end
				end)
			end

			if inst.Activated or owner:HasTag("inspell")then
				return false --owner.components.talker:Say(GetString(owner.prefab, "ACTIONFAIL_GENERIC"))
			else
				inst.Activated = true
				owner:AddTag("inspell")
				local x,y,z = owner.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 100)
				if owner.components.playercontroller ~= nil then
					owner.components.playercontroller:Enable(false)
				end
				owner.components.health:SetInvincible(true)
				for k,v in pairs(ents) do
					if v.components.combat and v.components.combat.target == owner then
						v.components.combat.target = nil
					end
				end
				owner:AddTag("notarget")
				LeftSpawnCount = math.random(3, 7)
				if owner.components.power then
					owner.components.power:DoDelta(-20, false)
				end
				DoSpawn()
				inst.components.stackable:Get():Remove()
			end
			return true
		end)
	end
	
	local function matter(inst) -- Universe of Matter and Antimatter
		inst.components.spellcard.costpower = 150
		inst.costpower:set(150)
		inst.components.finiteuses:SetMaxUses(2)
		inst.components.finiteuses:SetUses(2)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			local Inventory = owner.components.inventory
			local function repair(v)

				if v.components.fueled 
				and v.components.fueled.fueltype ~= "MAGIC"	
				and v.components.fueled.fueltype ~= "NIGHTMARE" then
					  v.components.fueled:DoDelta(3600)
				end
				
				if v.components.finiteuses
				and not v:HasTag("icestaff")
				and not v:HasTag("firestaff")
				and not v:HasTag("spellcard")
				and not v:HasTag("shadow")
				and v.prefab ~= "greenamulet"
				and v.prefab ~= "yellowamulet"
				and v.prefab ~= "orangeamulet"
				and v.prefab ~= "amulet"
				and not v.components.spellcaster
				and not v.components.blinkstaff then
					local maxuse = v.components.finiteuses.total
					v.components.finiteuses:SetUses(maxuse)
				end
				
				if v.components.armor and not v:HasTag("sanity") then
					local maxcon = v.components.armor.maxcondition
					v.components.armor:SetCondition(maxcon)
				end
			end
			
			for k,v in pairs(Inventory.itemslots) do
				repair(v)
			end

			for k,v in pairs(Inventory.equipslots) do
				if type(v) == "table" and v.components.container then
					for k, v2 in pairs(v.components.container.slots) do
						repair(v2)
					end
				else
					repair(v)
				end
			end

			if owner.components.power then
				owner.components.power:DoDelta(-150, false)
			end
			inst.components.finiteuses:Use(1)
			return true
		end)
	end
	
	local function commonfn()  
		
		local inst = CreateEntity()    
		inst.entity:AddTransform()    
		inst.entity:AddAnimState()   
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)   
		
		inst.AnimState:SetBank("spell")    
		inst.AnimState:SetBuild("spell")    
		inst.AnimState:PlayAnimation("idle")    
		
		inst:AddTag("spellcard")
		
		inst.costpower = net_ushortint(inst.GUID, "costpower")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end


		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetOnFinished( onfinished )

		inst:AddComponent("inspectable")        
		
		inst:AddComponent("inventoryitem") 
		inst.components.inventoryitem.imagename = fname    
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..fname..".xml"   
		
		inst:AddComponent("spellcard")
		inst.components.spellcard.name = name
		inst.components.spellcard.isdangeritem = false -- is it dangerous to use on server

		if name == "test" then
			test(inst)
		elseif name == "mesh" then
			mesh(inst)
		elseif name == "away" then
			away(inst)
		elseif name == "necro" then
			necro(inst)
		elseif name == "curse" then
			curse(inst)
		elseif name == "balance" then
			balance(inst)
		elseif name == "laplace" then
			laplace(inst)
		elseif name == "butter" then
			butter(inst)
		elseif name == "bait" then
			bait(inst)
		elseif name == "addictive" then
			addictive(inst)
		elseif name == "lament" then
			lament(inst)
		elseif name == "matter" then
			matter(inst)
		end
		
		return inst
	end
	
	return Prefab("common/inventory/"..fname, commonfn, assets)
end

return MakeCard("test"),
	   MakeCard("mesh"),
	   MakeCard("away"),
	   MakeCard("necro"),
	   MakeCard("curse"),
	   MakeCard("balance"),
	   MakeCard("laplace"),
	   MakeCard("butter"),
	   MakeCard("bait"),
	   MakeCard("addictive"),
	   MakeCard("lament"),
	   MakeCard("matter")