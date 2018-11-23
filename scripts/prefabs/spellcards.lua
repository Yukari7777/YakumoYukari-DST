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
		inst.components.spellcard.costpower = 50
		inst.costpower:set(50)
		inst.components.finiteuses:SetMaxUses(5)
		inst.components.finiteuses:SetUses(5)
		inst.IsInvisible = nil
		inst.Duration = 0
		inst.components.spellcard:SetSpellFn(function(inst, owner)
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
		inst:AddTag("heavyaction")
		inst.components.spellcard.costpower = 300
		inst.costpower:set(300)
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			local x,y,z = owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 40)
			local Language = GetModConfigData("language", "Yakumo Yukari")
			for k,v in pairs(ents) do

				if v.components.health and not v:HasTag("player") then
					local maxhealth = v.components.health.maxhealth
					v.components.health:DoDelta(-maxhealth * 0.33 - 500)
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
				owner.components.talker:Say(str, 3)
			end
			inst:Remove()
		end)
	end
	
	local function curse(inst)
		inst.components.spellcard.costpower = 50
		inst.costpower:set(50)
		inst.components.finiteuses:SetMaxUses(3)
		inst.components.finiteuses:SetUses(3)
		inst.Duration = 0
		inst.Activated = nil
		inst.components.spellcard:SetSpellFn(function(inst, owner)
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
								
								owner.components.upgrader:ApplyStatus()
								owner:RemoveTag("inspell")
								owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NOREINFORCE"))
							end
						end
						if inst.Activated then
							if owner.components.sanity then
								owner.components.sanity:DoDelta(- owner.components.sanity:GetMaxWithPenalty() * 0.025)
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
			
			for i = 1, rotcnt, 1 do
				owner.components.inventory:GiveItem(SpawnPrefab("wetgoop"))
			end

			if owner.components.power then
				owner.components.power:DoDelta(-150, false)
			end
			inst.components.finiteuses:Use(1)
			return true
		end)
	end
	
	local function laplace(inst)
		inst.components.spellcard.costpower = 5
		table.insert(assets, Asset("IMAGE", "images/colour_cubes/purple_moon_cc.tex"))
		table.insert(assets, Asset("IMAGE", "images/colour_cubes/mole_vision_on_cc.tex"))
        table.insert(assets, Asset("IMAGE", "images/colour_cubes/mole_vision_off_cc.tex"))
		inst.components.finiteuses:SetMaxUses(1500)
		inst.components.finiteuses:SetUses(1500)
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		local function deletetask(inst)
			inst.sighttask:Cancel()
			inst.sighttask = nil
		end

		inst.components.spellcard:SetSpellFn(function(inst, owner)-- todo : make own cccube
			local NIGHTVISION_COLOURCUBES = {
				day = "images/colour_cubes/beaver_vision_cc.tex",
				dusk = "images/colour_cubes/beaver_vision_cc.tex",
				night = "images/colour_cubes/beaver_vision_cc.tex",
				full_moon = "images/colour_cubes/beaver_vision_cc.tex",
			}
			local HasNightVision = owner.components.playervision and owner.components.playervision:HasNightVision()
			local HasGoggleVision = owner.components.playervision and owner.components.playervision:HasGoggleVision()

			if inst.sighttask then
				deletetask(inst)
				owner.components.playervision:SetCustomCCTable(nil)
				owner.components.playervision:ForceNightVision(false)
			end

			if inst.sighttask == nil and HasNightVision then return false else
				owner.components.power:DoDelta(4, false)
				owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_NEWSIGHT"))
				inst.sighttask = owner.DoPeriodicTask(owner, 1, function()
					if inst.components.inventoryitem:IsHeld() then 
						if owner.components.power.current >= 1 then
							owner.components.playervision:ForceNightVision(true)
							owner.components.playervision:SetCustomCCTable(NIGHTVISION_COLOURCUBES)
							inst.components.finiteuses:Use(1)
							owner.components.power:DoDelta(-1, false)
						else 
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_LOWPOWER"))
							owner.components.playervision:ForceNightVision(false)
							owner.components.playervision:SetCustomCCTable(nil)
							deletetask(inst)
						end
						if HasGoggleVision then -- Player wears goggle in task
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_EYEHURT"))
							if owner.components.combat then
								owner.components.combat:GetAttacked(inst, 10)
							end
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
							deletetask(inst)
						end
					else
						owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
						owner.components.playervision:ForceNightVision(false)
						owner.components.playervision:SetCustomCCTable(nil)
						deletetask(inst)
					end 
				end)
			end
			return true
		end)

		inst.components.finiteuses:SetOnFinished(function()
			local owner = inst.components.inventoryitem.owner
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
			owner.components.playervision:ForceNightVision(false)
			owner.components.playervision:SetCustomCCTable(nil)
			deletetask(inst)
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
		inst.costpower:set(1)
		inst.components.finiteuses:SetMaxUses(300)
		inst.components.finiteuses:SetUses(300)
		local function barrier(inst)
			if inst.fx then 
				return inst.fx
			else
				local fx = SpawnPrefab("barrierfieldfx")
				local fx_hitanim = function()
				fx.AnimState:PlayAnimation("hit")
				fx.AnimState:PushAnimation("idle_loop")
				end
				fx.entity:SetParent(inst.components.inventoryitem.owner.entity)
				fx.AnimState:SetScale(0.7,0.7,0.7)
				fx.AnimState:SetMultColour(0.5,0,0.5,0.3)
				fx.Transform:SetPosition(0, 0.2, 0)
				inst.fx = fx
				return fx
			end
		end
		inst.components.spellcard:SetSpellFn(function(inst, owner)
			if inst.barriertask then
				if owner.components.upgrader.ability[4][3] then
					owner:AddTag("realyoukai")
				end
				owner:RemoveTag("IsDamage")
				inst.fx.kill_fx(inst.fx)
				inst.fx = nil
				inst.barriertask:Cancel()
				inst.barriertask = nil
			else
				inst.fx = barrier(inst)
				inst.barriertask = owner.DoPeriodicTask(owner, 1, function()
					if inst.components.inventoryitem:IsHeld() and owner.components.power.current >= 1 then
						owner.components.power:DoDelta(-1, false)
						if not owner:HasTag("isDamage") then
							owner:AddTag("IsDamage")
						end
						if owner.components.upgrader.ability[4][3] and owner:HasTag("realyoukai") then
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
					else 
						if owner.components.power.current < 1 then
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_LOWPOWER"))
						else
							owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
						end
						owner:RemoveTag("IsDamage")
						if owner.components.upgrader.ability[4][3] then
							owner:AddTag("realyoukai")
						end
						inst.fx.kill_fx(inst.fx)
						inst.fx = nil
						inst.barriertask:Cancel()
						inst.barriertask = nil
					end
				end)
			end
			return true
		end)
		inst.components.finiteuses:SetOnFinished(function()
			local owner = inst.components.inventoryitem.owner
			owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_DONEEFFCT"))
			owner:RemoveTag("IsDamage")
			if owner.components.upgrader.ability[4][3] then
				owner:AddTag("realyoukai")
			end
			inst.fx.kill_fx(inst.fx)
			inst.fx = nil
			inst.barriertask:Cancel()
			inst.barriertask = nil
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
					--v:RemoveTag("witherable")
				end

				if v.components.pickable then
					--v.components.pickable.max_cycles = 100
					v.components.pickable.cycles_left = nil
					if v.rain then
						v.rain = 0
					end
					v.components.pickable:Regen()
				end
				
				if v.components.hackable then
					v.components.hackable.withered = false
					v.components.hackable.inst:RemoveTag("withered")
					v.components.hackable.witherable = false
					v.components.hackable.inst:RemoveTag("witherable")
					v.components.hackable:Regen()
				end

				if v.components.crop then
					v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME*5)
				end
				
				if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
					v.components.growable:DoGrowth()
					v.components.growable:SetStage(3) -- tallest
				end
				
				if v.components.grower then
					v.components.grower.cycles_left = 30
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
		inst.components.spellcard.costpower = 20
		inst.costpower:set(20)
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
			{"deerclops", 1, "bad", function(prefab) prefab:DoTaskInTime(10, function() prefab:PushEvent("ms_sendlightningstrike", prefab.Transform:GetWorldPosition()); prefab:Remove()  end) end, "rog"},
			{"mosquito", math.random(3), "bad", nil, "rog"},
			{"tallbird", 1, "bad", nil, "rog"},
			{"mosquito_poison", math.random(3), "bad", nil, "sw"},
		}
		inst.components.spellcard:SetSpellFn(function(inst, owner)
				local function spawn()
				
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