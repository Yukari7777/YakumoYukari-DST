local modname = KnownModIndex:GetModActualName("Yakumo Yukari")
local berries = GetModConfigData("berries", modname) == "juicy" and "berries_juicy" or "berries"

local Ingredients = {
	{"honey", "healingsalve", "bandage"},
	{berries, "meatballs", "bonestew"},
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

local function GetStatLevel(owner, index)
	if index == 1 then return owner.components.upgrader.health_level
	elseif index == 2 then return owner.components.upgrader.hunger_level
	elseif index == 3 then return owner.components.upgrader.sanity_level
	elseif index == 4 then return owner.components.upgrader.power_level
	end
end

local function GetIngreCount(owner, index)
	local difficulty = GetModConfigData("difficulty", modname)
	local level = GetStatLevel(owner, index) + 1
	
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

local function GetMaxLevel()
	local difficulty = GetModConfigData("difficulty", modname)

	local maxlevel = TUNING.YDEFAULT.UPGRADE_MAX
	if difficulty == "easy" then
		maxlevel = TUNING.YDEFAULT.UPGRADE_MAX - 5
	elseif difficulty == "hard" then
		maxlevel = math.huge 
	end

	return maxlevel
end

local function CountInventoryItem(owner, item)
	local inventory = owner.components.inventory
	local count = 0

	local function countitem(item, count)
		if item.components.stackable ~= nil then
			count = count + item.components.stackable.stacksize
		else 
			count = count + 1
		end
		return count
	end
	
	for k,v in pairs(inventory.itemslots) do
		if v.prefab == item then
			count = countitem(v, count)
		end
	end
	
	for k,v in pairs(inventory.equipslots) do
		if type(v) == "table" and v.components.container then
			for k, v2 in pairs(v.components.container.slots) do
				if v2.prefab == item then
					count = countitem(v2, count)
				end
			end
		end
	end
	
	return count
end

local function GetStr(owner, index)
	local items = Ingredients[index]
	local count = GetIngreCount(owner, index)
	local currentLevel = GetStatLevel(owner, index)
	local maxlevel = GetMaxLevel()
	
	local text = ""
	if currentLevel < maxlevel then
		for i = 1, 3, 1 do
			if count[i] > 0 then
				text = text.."\n"..GetIngameName(items[i]).." - "..CountInventoryItem(owner, items[i]).." / "..count[i]
			end
		end
	else
		text = "\n"..STRINGS.YUKARI_UPGRADE_FINISHED
	end

	return text
end

local function GetCanpell(inst, owner)
	local index = GetIndex(inst)
	local items = Ingredients[index]
	local count = GetIngreCount(owner, index)
	local currentLevel = GetStatLevel(owner, index)
	local maxlevel = GetMaxLevel()

	local condition = true
	if currentLevel < maxlevel then 
		for i = 1, 3, 1 do 
			condition = condition and ( CountInventoryItem(owner, items[i]) >= count[i] )
		end	
	else
		condition = false 
	end
	
	return condition
end

local function SetState(inst, data)
	local condition = GetCanpell(inst, data.owner)
	inst.components.spellcard:SetCondition(condition)
	inst.canspell:set(condition)
end

local function GetDesc(inst, viewer)
	if viewer.prefab == "yakumoyukari" then
		local index = GetIndex(inst)
		local currentLevel = GetStatLevel(viewer, index)

		return string.format( STRINGS.YUKARI_CURRENT_LEVEL.." - "..currentLevel..GetStr(viewer, index) )
	end
end

local function DoUpgrade(inst, owner)
	local index = GetIndex(inst)
	local items = Ingredients[index]
	local count = GetIngreCount(owner, index)
	local inventory = owner.components.inventory
	
	local function remove(item, left_count)
		if left_count > 0 then
			if item.components.stackable ~= nil then
				if item.components.stackable.stacksize >= left_count then
					item.components.stackable:Get(left_count):Remove()
					return 0
				else 
					left_count = left_count - item.components.stackable.stacksize
					item:Remove()
				end
			else 
				left_count = left_count - 1
				item:Remove()
			end
		end
		return left_count
	end

	for i = 1, 3, 1 do -- I won't use RemoveItem function in inventory components because it doesn't get items in custom backpack slot. 
		local left_count = count[i]

		while left_count > 0 do
			for k,v in pairs(inventory.itemslots) do
				if v.prefab == items[i] then
					left_count = remove(v, left_count)
				end
			end

			for k,v in pairs(inventory.equipslots) do
				if type(v) == "table" and v.components.container then
					for k, v2 in pairs(v.components.container.slots) do
						if v2.prefab == items[i] then
							left_count = remove(v2, left_count)
						end
					end
				end
			end
		end
	end

	owner.components.upgrader:DoUpgrade(owner, index)
end

local function OnFinish(inst)
	local owner = inst.components.inventoryitem.owner
	local condition = GetCanpell(inst, owner)
	inst.components.spellcard:SetCondition(condition)
	inst.canspell:set(condition)
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
		inst:AddTag("recieveitemupdate")

		inst.canspell = net_bool(inst.GUID, "canspell")

		if not TheWorld.ismastersim then
			return inst
		end

		inst.entity:SetPristine()


		inst:AddComponent("inspectable")			
		inst.components.inspectable.getspecialdescription = GetDesc

		inst:AddComponent("inventoryitem") 
		inst.components.inventoryitem.imagename = fname    
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..fname..".xml" 	
		
		inst:AddComponent("spellcard")
		inst.components.spellcard.name = fname
		inst.components.spellcard:SetSpellFn( DoUpgrade )
		inst.components.spellcard:SetOnFinish( OnFinish )
		inst.components.spellcard:SetCondition( false )
		
		inst:ListenForEvent("onitemupdate", SetState)
		
		return inst
	end
	
	return Prefab("common/inventory/"..fname, fn, assets)
end

return MakePanel("health"),
       MakePanel("hunger"),
       MakePanel("sanity"),
       MakePanel("power")