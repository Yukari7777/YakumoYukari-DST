local Ingredients = {
	{"spidergland", "healingsalve", "bandage"},
	{"berries", "meatballs", "bonestew"},
	{"petals", "nightmarefuel", "livinglog"},
	{"goldnugget", "purplegem", "thulecite"}
}

local Ingredients_sw = {
	{"spidergland", "healingsalve", "bandage"},
	{"berries", "fishsticks", "surfnturf"},
	{"petals", "taffy", "livinglog"},
	{"goldnugget", "nightmarefuel", "obsidian"}
}

local function GetIngameName(prefab)
	return STRINGS.NAMES[string.upper(prefab)]
end

local function GetIndex(inst) -- enum..
	local utype = inst.components.spellcard.name
	if utype == "healthpanel" then return 1
	elseif utype == "hungerpanel" then return 2
	elseif utype == "sanitypanel" then return 3
	elseif utype == "powerpanel" then return 4
	end
end

local function GetStatLevel(inst, index)
	if index == 1 then return inst.components.inventoryitem.owner.components.upgrader.health_level
	elseif index == 2 then return inst.components.inventoryitem.owner.components.upgrader.hunger_level
	elseif index == 3 then return inst.components.inventoryitem.owner.components.upgrader.sanity_level
	elseif index == 4 then return inst.components.inventoryitem.owner.components.upgrader.power_level
	end
end

local function GetIngreCount(inst, index)
	local difficulty = GetModConfigData("difficulty", "YakumoYukari")
	local level = GetStatLevel(inst, index) + 1
	
	local a = math.ceil(level * 0.7) + math.min(1, math.floor(level/10)) * math.floor(1.155 ^ (level - 10) ) -- 25 / 267 - 18 / 159
	local b = math.min(1, math.floor(level/10)) * math.floor(1.1336 ^ (level - 10) + 0.2 * (level - 10) ) -- 9 / 64 - 5 / 28 
	if difficulty == "hard" then
		a = level + math.min(1, math.floor(level/10)) * math.floor(1.162 ^ (level - 10) ) -- 50 / 595
		b = math.min(1, math.floor(level/10)) * math.floor(1.1336 ^ (level - 10) + 0.3 * (level - 10) ) -- 18 / 150
	end
	local c = math.min(1, math.floor(level/20)) * (level - 20) -- 10 / 55
		
	local info = {a,b,c}
	
	return info
	
end

local function GetBackpack(inst)
	local backpack
	local Chara = inst.components.inventoryitem.owner
	
	if EQUIPSLOTS.BACK and Chara.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK) then -- check if backpack slot mod is enabled.
		backpack = Chara.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK)
	elseif Chara.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) 
	and Chara.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).components.container then
		backpack = Chara.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
	end
	
	if backpack and backpack.components.container then 
		return backpack.components.container 
	end
end

local function CountInventoryItem(inst, prefab)
	local owner = inst.components.inventoryitem.owner
	local inventory = owner.components.inventory
	local backpack = GetBackpack(inst)
	local count = 0
	
	for k,v in pairs(inventory.itemslots) do
		if v.prefab == prefab then
			if v.components.stackable then
				count = count + v.components.stackable.stacksize
			else 
				count = count + 1
			end
		end
	end
	
	if backpack then
		for k,v in pairs(backpack.slots) do
			if v.prefab == prefab then
				if v.components.stackable then
					count = count + v.components.stackable.stacksize
				else 
					count = count + 1
				end
			end
		end
	end
	
	return count
end

local function GetMaxLevel()
	local difficulty = GetModConfigData("difficulty", "YakumoYukari")

	local maxlevel = TUNING.YDEFAULT.UPGRADE_MAX
	if difficulty == "easy" then
		maxlevel = TUNING.YDEFAULT.UPGRADE_MAX - 5
	elseif difficulty == "hard" then
		maxlevel = math.huge 
	end

	return maxlevel
end

local function GetItemCount(inst, index)
	local items = Ingredients[index]
	local count = GetIngreCount(inst, index)
	local currentLevel = GetStatLevel(inst, index)
	local maxlevel = GetMaxLevel()
	
	local text = ""
	if currentLevel < maxlevel then
		for i = 1, 3, 1 do
			if count[i] > 0 then
				text = text.."\n"..GetIngameName(items[i]).." - "..CountInventoryItem(inst, items[i]).." / "..count[i]
			end
		end
	else
		text = "\n"..STRINGS.YUKARI_UPGRADE_FINISHED
	end

	return text
end

local function GetCondition(inst, index)

	local items = Ingredients[index]
	local count = GetIngreCount(inst, index)
	local currentLevel = GetStatLevel(inst, index)
	local maxlevel = GetMaxLevel()

	local condition = true
	if currentLevel < maxlevel then 
		for i = 1, 3, 1 do 
			condition = condition and ( CountInventoryItem(inst, items[i]) >= count[i] )
		end	
	else
		condition = false 
	end
	
	return condition
end

local function SetDesc(inst, index)
	local currentLevel = GetStatLevel(inst, index)
	local condition = GetCondition(inst, index)
	local Language = GetModConfigData("language", "YakumoYukari")
		
	local function IsHanded()
		local hands = inst.components.inventoryitem.owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil
		if hands and condition then
			return "\n"..STRINGS.YUKARI_SHOULD_BRING_SOMETHING
		else
			return ""
		end
	end
	
	local str = STRINGS.YUKARI_CURRENT_LEVEL.." - "..currentLevel..GetItemCount(inst, index)..IsHanded()
	
	inst.components.inspectable:SetDescription(str)
	
end

local function SetState(inst)
	local index = GetIndex(inst)
	local condition = GetCondition(inst, index)
	inst.components.spellcard:SetCondition( condition )
	SetDesc(inst, index)
end

local function DoUpgrade(inst)
	local backpack = GetBackpack(inst)
	local Chara = inst.components.inventoryitem.owner
	local index = GetIndex(inst)
	local items = Ingredients[index]
	local count = GetIngreCount(inst, index)
	local inventory = Chara.components.inventory
	
	for i = 1, 3, 1 do
		local function consume(name, left_count, backpack)
			
			for k,v in pairs(inventory.itemslots) do
				if v.prefab == name[i] then
					if v.components.stackable then
						if v.components.stackable.stacksize >= left_count then
							v.components.stackable:Get(left_count):Remove()
							left_count = 0
						else 
							v:Remove()
							left_count = left_count - v.components.stackable.stacksize
						end
					else 
						v:Remove()
						left_count = left_count - 1
					end
				end
			end
			
			if backpack then
				for k,v in pairs(backpack.slots) do
					if v.prefab == name[i] then
						if v.components.stackable then
							if v.components.stackable.stacksize >= left_count then
								v.components.stackable:Get(left_count):Remove()
								left_count = 0
							else 
								v:Remove()
								left_count = left_count - v.components.stackable.stacksize
							end
						else 
							v:Remove()
							left_count = left_count - 1
						end
					end
				end
			end
			if left_count >= 1 then consume(name, left_count, backpack) end
			
		end
		consume(items, count[i], backpack)
	end
	
	Chara.components.upgrader:DoUpgrade(Chara, index)
end

function MakePanel(iname)
	local fname = iname.."panel"
	local fup = string.upper(iname).."UP"
	
	local assets =
	{   
		Asset("ANIM", "anim/"..fname..".zip"),
		Asset("ATLAS", "images/inventoryimages/"..fname..".xml"),    
		Asset("IMAGE", "images/inventoryimages/"..fname..".tex"),
	}
	
	local function fn()  

		local inst = CreateEntity()    
		inst.entity:AddTransform()    
		inst.entity:AddAnimState()    
		inst.entity:AddNetwork()		
		
		MakeInventoryPhysics(inst)   
		
		inst.AnimState:SetBank(fname)    
		inst.AnimState:SetBuild(fname)    
		inst.AnimState:PlayAnimation("idle")   

		inst:AddTag("spellcard")

		if not TheWorld.ismastersim then
			return inst
		end

		inst.entity:SetPristine()


		inst:AddComponent("inspectable")			
		
		inst:AddComponent("inventoryitem") 
		inst.components.inventoryitem.imagename = fname    
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..fname..".xml" 	
		
		inst:AddComponent("spellcard")
		inst.components.spellcard.name = fname
		inst.components.spellcard:SetSpellFn( DoUpgrade )
		inst.components.spellcard:SetCondition( false )
		
		inst:DoPeriodicTask(1, SetState) -- temp
		
		return inst
	end
	
	return Prefab("common/inventory/"..fname, fn, assets)
end

return MakePanel("health"),
       MakePanel("hunger"),
       MakePanel("sanity"),
       MakePanel("power")