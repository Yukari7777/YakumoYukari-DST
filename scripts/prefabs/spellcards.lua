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
		inst.components.finiteuses:SetMaxUses(3)
		inst.components.finiteuses:SetUses(3)
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner

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
		inst.components.finiteuses:SetMaxUses(3)
		inst.components.finiteuses:SetUses(3)
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			if owner.components.sanity then
				local amount = owner.components.sanity:GetMaxSanity() * owner.components.sanity:GetPercent()
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
		inst.components.spellcard.costpower = 50
		inst.components.finiteuses:SetMaxUses(5)
		inst.components.finiteuses:SetUses(5)
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		inst.IsInvisible = nil
		inst.Duration = 0
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			if inst.IsInvisible == true then
				inst.Duration = inst.Duration + 10
				owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_INVINCIBILITY_DURATION"))
				if owner.components.power then
					owner.components.power:DoDelta(-50, false)
				end
				inst.components.finiteuses:Use(1)
			else
				owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_CLOAKING"))
				owner.AnimState:SetMultColour(0.3,0.3,0.3,.3)
				owner:AddTag("notarget")
				inst.Duration = 10
				if inst.IsInvisible == nil then -- to prevent DoPeriodicTask overlapping
					owner:DoPeriodicTask(1, function() -- So, this one is set only once.
						if inst.IsInvisible == true and inst.Duration > 0 then
							local x,y,z = owner.Transform:GetWorldPosition()
							local ents = TheSim:FindEntities(x, y, z, 100)
							for k,v in pairs(ents) do
								if v.components.combat and v.components.combat.target == owner then
									v.components.combat.target = nil
								end
							end
						end
						if inst.Duration > 0 then
							inst.Duration = inst.Duration - 1
						end
						if inst.Duration <= 0 and inst.IsInvisible == true then
							owner:RemoveTag("notarget")
							owner.AnimState:SetMultColour(1,1,1,1)
							inst.IsInvisible = false
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DECLOAKING"))
						end
					end)
				end
				inst.IsInvisible = true
				if owner.components.power then
					owner.components.power:DoDelta(-50, false)
				end
				inst.components.finiteuses:Use(1)
				return true
			end
		end)
	end
	
	local function necro(inst)
		inst:RemoveComponent("finiteuses")
		inst.components.spellcard.action = ACTIONS.CASTTOHOH
		inst.components.spellcard.costpower = 300
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 40)
			local Language = GetModConfigData("language", "YakumoYukari")
			SetSharedLootTable('nodrop', nil)
			
			for k,v in pairs(ents) do
				if v.components.health and not v:HasTag("yakumoga") then
					if v.components.lootdropper and not v:HasTag("epic") then
						v.components.lootdropper.loot = nil -- ISSUE : some prefabs still has loots.
						v.components.lootdropper.chanceloot = nil
						v.components.lootdropper.randomloot = nil
						v.components.lootdropper.numrandomloot = nil
					end
					v.components.health:DoDelta(-2147483647)
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
			-- TODO : Delete moleworm
			if owner.components.power then
				owner.components.power:DoDelta(-300, false)
			end

			local str = {}
				str[1] = "You were nothing but a piece of paper..."
				str[2] = "Go rest in the void.."
				str[3] = "You were just nothing.."
			if Language == "chinese" then
				str[1] = "你 只 不 过 是 一 张 纸..."
				str[2] = "在 虚 空 中 永 眠 吧.."
				str[3] = "你 什 么 都 不 是.."
			end
			owner.components.talker:Say(str[math.random(3)], 3, nil, nil, true)
			inst:Remove()
		end)
	end
	
	local function curse(inst)
		inst.components.spellcard.costpower = 50
		inst.components.finiteuses:SetMaxUses(3)
		inst.components.finiteuses:SetUses(3)
		inst.Duration = 0
		inst.Activated = nil
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			local old_dmg = owner.components.combat.damagemultiplier
			local old_speed = owner.components.upgrader.bonusspeed
			local isfast = 1
			if owner:HasTag("realyoukai") then
				isfast = 0
			end
			local function GetMultipulier()
				if owner.components.sanity then
					return 3 * (1 - math.ceil(10 * owner.components.sanity:GetPercent())/10)
				end
			end
			if inst.Activated == true then
				owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_CANNOTRESIST"))
			else
				inst.Duration = 20
				if inst.Activated == nil then
					owner:DoPeriodicTask(1, function()
						if inst.Duration > 0 then
							inst.Activated = true
							inst.Duration = inst.Duration - 1
							if owner:HasTag("inspell") then else
								owner:AddTag("inspell")
							end
							if inst.Duration == 0 then
								inst.Activated = false
								
								owner.components.combat.damagemultiplier = 1.2
								owner.components.locomotor.walkspeed = 4
								owner.components.locomotor.runspeed = 6
								owner.components.combat:SetAttackPeriod(TUNING.WILSON_ATTACK_PERIOD)
								
								owner.components.upgrader:DoUpgrade(owner)
								owner:RemoveTag("inspell")
								owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NOREINFORCE"))
							end
						end
						if inst.Activated then
							if owner.components.sanity then
								owner.components.sanity:DoDelta(- owner.components.sanity:GetMaxSanity() * 0.025)
							end
							owner.components.combat.damagemultiplier = math.max(GetMultipulier(), old_dmg)
							owner.components.locomotor.walkspeed = 6 + math.max(GetMultipulier(), old_speed)
							owner.components.locomotor.runspeed = 8 + math.max(GetMultipulier(), old_speed)
							owner.components.combat:SetAttackPeriod(TUNING.WILSON_ATTACK_PERIOD * math.min(1, 1 - GetMultipulier()/3, isfast))
						end
					end)
				end
				if owner.components.power then
					owner.components.power:DoDelta(-50, false)
				end
				inst.components.finiteuses:Use(1)
			end
			return true
		end)
	end
		
	local function balance(inst)
		inst.components.spellcard.costpower = 100
		inst.components.finiteuses:SetMaxUses(5)
		inst.components.finiteuses:SetUses(5)
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 50)
			for k,v in pairs(ents) do
				if v.components.pickable then
					v.components.pickable:FinishGrowing()
				end
				
				if v.components.hackable then
					v.components.hackable:FinishGrowing()
				end
				
				if v.components.crop then
					v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME*5)
				end
				
				if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
					v.components.growable:DoGrowth()
					v.components.growable:SetStage(3) -- tallest
				end
			end
		
			if owner.components.power then
				owner.components.power:DoDelta(-100, false)
			end
			inst.components.finiteuses:Use(1)
			return true
		end)
	end
	
	local function laplace(inst)
		inst.components.spellcard.costpower = 1
		table.insert(assets, Asset("IMAGE", "images/colour_cubes/purple_moon_cc.tex"))
		table.insert(assets, Asset("IMAGE", "images/colour_cubes/mole_vision_on_cc.tex"))
        table.insert(assets, Asset("IMAGE", "images/colour_cubes/mole_vision_off_cc.tex"))
		inst.components.finiteuses:SetMaxUses(1500)
		inst.components.finiteuses:SetUses(1500)
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		inst.Activated = nil
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "molehat" then
				owner.components.talker:Say(GetString(owner.prefab, "ACTIONFAIL_GENERIC"))
			else
				if inst.Activated == nil then
					owner:DoPeriodicTask(1, function()
						if inst.Activated then
							if GetClock() and TheWorld and TheWorld.components.colourcubemanager then
								GetClock():SetNightVision(true)
								TheWorld.components.colourcubemanager:SetOverrideColourCube("images/colour_cubes/purple_moon_cc.tex", .5)
							end
							if owner.components.power and owner.components.power.current >= 1 then
								owner.components.power:DoDelta(-1, false)
							else 
								owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_LOWPOWER"))
								if TheWorld and TheWorld.components.colourcubemanager then
									TheWorld.components.colourcubemanager:SetOverrideColourCube(nil, .5)
								end
								GetClock():SetNightVision(false)
								inst.Activated = false
							end
							if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "molehat" then
								owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_EYEHURT"))
								if owner.components.combat then
									owner.components.combat:GetAttacked(inst, 10)
								end
								inst.Activated = false
								 if GetClock() and TheWorld and TheWorld.components.colourcubemanager then
									if GetClock():IsDay() and not TheWorld:IsCave() then
										TheWorld.components.colourcubemanager:SetOverrideColourCube("images/colour_cubes/mole_vision_off_cc.tex", .25)
									else
										TheWorld.components.colourcubemanager:SetOverrideColourCube("images/colour_cubes/mole_vision_on_cc.tex", .25)
									end
								end
							end
							inst.components.finiteuses:Use(1)
						end
					end)
					inst.Activated = true
					owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NEWSIGHT"))
				else
					if inst.Activated then
						inst.Activated = false
						if TheWorld and TheWorld.components.colourcubemanager then
							TheWorld.components.colourcubemanager:SetOverrideColourCube(nil, .5)
						end
						GetClock():SetNightVision(false)
					else 
						inst.Activated = true
						owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NEWSIGHT"))
					end
				end
			end
			return true
		end)
		inst.components.finiteuses:SetOnFinished(function()
			local owner = inst.components.inventoryitem.owner
			if TheWorld and TheWorld.components.colourcubemanager then
				TheWorld.components.colourcubemanager:SetOverrideColourCube(nil, .5)
			end
			inst.Activated = false
			GetClock():SetNightVision(false)
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
			inst:Remove()
		end)
	end
	
	local function butter(inst)
		inst.components.spellcard.costpower = 80
		inst:RemoveComponent("finiteuses")
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
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
					num = 0
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
		inst.components.finiteuses:SetMaxUses(300)
		inst.components.finiteuses:SetUses(300)
		inst.Activated = nil
		inst.components.spellcard:SetSpellFn(function()
			local function barrier()
				if inst.fx then 
					return inst.fx
				else
					local fx = SpawnPrefab("barrierfieldfx")
					local fx_hitanim = function()
					fx.AnimState:PlayAnimation("hit")
					fx.AnimState:PushAnimation("idle_loop")
					end
					fx.entity:SetParent(owner.entity)
					fx.AnimState:SetScale(0.7,0.7,0.7)
					fx.AnimState:SetMultColour(0.5,0,0.5,0.3)
					fx.Transform:SetPosition(0, 0.2, 0)
					inst.fx = fx
					return fx
				end
			end
			local fx = barrier()
			local owner = inst.components.inventoryitem.owner
			if inst.Activated == nil then -- create barrier
				inst.Activated = true
				owner:DoPeriodicTask(1, function()
					if inst.Activated then
						if owner.components.power and owner.components.power.current >= 1 then
							owner.components.power:DoDelta(-1, false)
							owner:AddTag("IsDamage")
							local x,y,z = owner.Transform:GetWorldPosition()
							local ents = TheSim:FindEntities(x, y, z, 6)
							for k,v in pairs(ents) do
								if v.components.combat and v.components.combat.target ~= owner then
									v.components.combat.target = owner
								end
							end
							inst.components.finiteuses:Use(1)
						else 
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_LOWPOWER"))
							inst.Activated = false
							fx.kill_fx(fx)
							inst.fx = nil
						end
					else
						owner:RemoveTag("IsDamage")
					end
				end)
			else
				if inst.Activated then
					inst.Activated = false
					fx.kill_fx(fx)
					inst.fx = nil
				else
					inst.Activated = true -- enable barrier
				end
			end
			return true
		end)
		inst.components.finiteuses:SetOnFinished(function()
			local fx = inst.fx
			inst.Activated = false
			fx.kill_fx(fx)
			inst.fx = nil
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
			inst:Remove()
		end)
	end
	
	local function addictive(inst)
		inst.components.spellcard.costpower = 200
		inst:RemoveComponent("finiteuses")
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 60)
			for k,v in pairs(ents) do
				if v.components.pickable then
					v.components.pickable.withered = false
					v.components.pickable.inst:RemoveTag("withered")
					v.components.pickable.witherable = false
					v.components.pickable.inst:RemoveTag("witherable")
					v.components.pickable.shouldwither = true
					v.components.pickable:Regen()
				end
				
				if v.components.hackable then
					v.components.hackable.withered = false
					v.components.hackable.inst:RemoveTag("withered")
					v.components.hackable.witherable = false
					v.components.hackable.inst:RemoveTag("witherable")
					v.components.hackable.shouldwither = true
					v.components.hackable:Regen()
				end
				
				if v.components.grower then
					v.components.grower.cycles_left = 30
				end
				
				if v.components.burnable then
					v.components.burnable:Extinguish()
				end
			end
			if owner.components.power then
				owner.components.power:DoDelta(-200, false)
			end
			inst:Remove()
		end)
	end
	
	local function lament(inst) -- Urashima's Box
		inst:RemoveComponent("finiteuses")
		inst.components.spellcard.costpower = 20
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		inst.Activated = false
		local count = 0
		local LootTable_c = { -- {name, count, grade, OnSpawnfunction, MustThisWorld}
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
			{"purplegem", math.random(2), "rare", nil, "sw"}, -- gives additional chance
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
			{"spoiled_food", math.random(3), "bad", function() if owner.components.hunger then owner.components.hunger:DoDelta(-5, nil, true) end end},
			{"rottenegg", math.random(3), "bad", function() if owner.components.hunger then owner.components.hunger:DoDelta(-5, nil, true) end end},
			{"charcoal", math.random(3), "bad", function() if owner.components.sanity then owner.components.sanity:DoDelta(-4) end end},	
			{"crawlingnightmare", 1, "bad"},
			{"nightmarebeak", 1, "bad"},
			{"killerbee", math.random(4), "bad"},
			{"krampus", math.random(3), "bad"},
			{"deerclops", 1, "bad", function(prefab) prefab:DoTaskInTime(10, function() prefab:Remove(); prefab:PushEvent("ms_sendlightningstrike", TheInput:GetWorldPosition() ) end) end, "rog"},
			{"mosquito", math.random(3), "bad", nil, "rog"},
			{"tallbird", 1, "bad", nil, "rog"},
			{"mosquito_poison", math.random(3), "bad", nil, "sw"},
		}
		inst.components.spellcard:SetSpellFn(function()
				local owner = inst.components.inventoryitem.owner
				local function spawn()
				local owner = inst.components.inventoryitem.owner
				if owner.components.kramped.threshold == nil then -- just in case
					owner.components.kramped.threshold = 50
				end
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
				local threshold = owner.components.kramped.threshold
				local actions = owner.components.kramped.actions
				local naughtiness = actions / threshold
				local key, amount, grade, pt, list, loot
				if count > 1 then
					owner:DoTaskInTime(0.5, function()
						if naughtiness < 0.33 then
							if math.random() < 0.66 then -- 66%, common stuff
								list = LootTable_c
							elseif math.random() < 0.66 then -- 21%, good stuff
								list = LootTable_g
							elseif math.random() < 0.66 then -- 7%, rare stuff
								list = LootTable_r
							else							-- 6%, bad stuff
								list = LootTable_b
							end
						elseif naughtiness < 0.66 then
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
						loot = GetLoot(list)
						key = math.random(#loot)
						amount = loot[key][2]
						grade = loot[key][3]
						local color = {}
						if grade == "common" then
							color = {r=0,g=0,b=0,a=0.5}
						elseif grade == "good" then
							color = {r=0,g=1,b=0,a=1}
						elseif grade == "rare" then
							color = {r=1,g=0,b=1,a=1}
						elseif grade == "bad" then
							color = {r=0,g=0,b=0,a=1}
						end
						for i = 1, amount do
							local prefab = SpawnPrefab(loot[key][1]) -- spawn thing
							prefab:AddTag("spawned")
							if prefab.components.lootdropper then
								prefab.components.lootdropper.numrandomloot = 0 -- Delete item drop.
								prefab.components.lootdropper:SetLoot({})
								prefab.components.lootdropper:SetChanceLootTable('nodrop')
							end
							pt = GetPoint(Vector3(owner.Transform:GetWorldPosition()))
							if loot[key][4] then
								loot[key][4](prefab)
							end
							local fx = SpawnPrefab("small_puff")
							fx.AnimState:SetMultColour(color.r, color.g, color.b, color.a)
							fx.Transform:SetPosition(pt.x, pt.y, pt.z)
							if grade ~= "bad" then
								owner.SoundEmitter:PlaySound("soundpack/spell/item")
							else
								owner.SoundEmitter:PlaySound("dontstarve/HUD/sanity_down")
							end
							prefab.Transform:SetPosition(pt.x, pt.y, pt.z)
						end
						count = count - 1
						spawn()
					end)
				elseif count == 1 then
					owner:DoTaskInTime(1.2, function()
						local Speech = GetString(owner.prefab, "ANNOUNCE_TRAP_WENT_OFF") -- "Oops"
						if naughtiness < 0.8 then
							list = LootTable_b 
						else
							list = LootTable_h
							Speech = "Oh, no"
						end
						loot = GetLoot(list)
						key = math.random(#loot)
						amount = loot[key][2]
						grade = loot[key][3]
						for i = 1, amount do
							local prefab = SpawnPrefab(loot[key][1])
							prefab:AddTag("spawned")
							if prefab.components.lootdropper then
								prefab.components.lootdropper.numrandomloot = 0 -- Delete item drop.
								prefab.components.lootdropper:SetLoot({})
								prefab.components.lootdropper:SetChanceLootTable('nodrop')
							end
							pt = GetPoint(Vector3(owner.Transform:GetWorldPosition()))
							if loot[key][4] then
								loot[key][4](prefab)
							end
							local fx = SpawnPrefab("small_puff")
							fx.AnimState:SetMultColour(0,0,0,1)
							fx.Transform:SetPosition(pt.x, pt.y, pt.z)
							owner.SoundEmitter:PlaySound("dontstarve/HUD/sanity_down")
							prefab.Transform:SetPosition(pt.x, pt.y, pt.z)
						end
					 
						owner.components.kramped:OnNaughtyAction( math.min(threshold - (actions + 1), math.random(10, 30)) )
						-- So Naughty points can be gained until 'threshold - 1' so that prevent spawning Krampus.
						local x,y,z = owner.Transform:GetWorldPosition()
						local ents = TheSim:FindEntities(x, y, z, 14)
						for k,v in pairs(ents) do
							if v.components.combat and v:HasTag("spawned")then
								v.components.combat.target = owner
							end
						end
						owner:RemoveTag("notarget")
						count = count - 1
						owner.components.health:SetInvincible(false)
						owner.components.playercontroller:Enable(true)
						owner.components.talker:Say(Speech)
						inst.Activated = false
					end)
				end
			end

			if inst.Activated then
				return false--owner.components.talker:Say(GetString(owner.prefab, "ACTIONFAIL_GENERIC"))
			else
				inst.Activated = true
				
				local x,y,z = owner.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 100)
				owner.components.playercontroller:Enable(false)
				owner.components.health:SetInvincible(true)
				for k,v in pairs(ents) do
					if v.components.combat and v.components.combat.target == owner then
						v.components.combat.target = nil
					end
				end
				owner:AddTag("notarget")
				count = math.random(3, 7)
				if owner.components.power then
					owner.components.power:DoDelta(-20, false)
				end
				spawn()
				inst.components.stackable:Get():Remove()
			end
			return true
		end)
	end
	
	local function matter(inst) -- Universe of Matter and Antimatter
		inst.components.spellcard.costpower = 150
		inst.components.finiteuses:SetMaxUses(2)
		inst.components.finiteuses:SetUses(2)
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		inst.components.spellcard:SetSpellFn(function()
			local owner = inst.components.inventoryitem.owner
			local Inventory = owner.components.inventory
			
			local function repair(v)
				
				if v.components.fueled 
				and not v.components.fueled.fueltype == "MAGIC"	
				and not v.components.fueled.fueltype == "NIGHTMARE" then
					  v.components.fueled:DoDelta(1)
				end
				
				if v.components.finiteuses
				and not v:HasTag("icestaff")
				and not v:HasTag("firestaff")
				and not v:HasTag("spellcard")
				and not v:HasTag("shadow")
				and not v.prefab == "greenamulet"
				and not v.prefab == "yellowamulet"
				and not v.prefab == "orangeamulet"
				and not v.prefab == "amulet"
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
				repair(v)
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