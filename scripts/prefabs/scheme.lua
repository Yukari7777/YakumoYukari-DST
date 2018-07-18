local assets=
{   
	Asset("ANIM", "anim/spell.zip"),    
	Asset("ATLAS", "images/inventoryimages/scheme.xml"),    
}

local Ingredients = {
	{{"rocks", 40}, {"log", 40}},
	{{"silk", 30}, {"pigskin", 20}, {"tentaclespots", 10}, {"strawhat", 1}},
	{{"monstermeat", 50}, {"nightmarefuel", 30}, {"livinglog", 20}, {"dragon_scales", 1}},
	{{"thulecite", 20}, {"spellcard_away", 10}, {"spellcard_matter", 5}, {"spellcard_laplace", 2}, {"spellcard_necro", 1}}
}

local Ingredients_sw = {
	{{"rocks", 20}, {"log", 20}, {"bamboo", 10}, {"vine", 10}},
	{{"silk", 25}, {"pigskin", 15}, {"limestone", 10}, {"strawhat", 1}},
	{{"monstermeat", 30}, {"fish", 30}, {"antivenom", 10}, {"shark_gills", 1}},
	{{"obsidian", 25}, {"spellcard_away", 10}, {"spellcard_matter", 5}, {"spellcard_laplace", 2}, {"spellcard_necro", 1}}
}

local modname = KnownModIndex:GetModActualName("Yakumo Yukari")

local function GetIngameName(prefab)
	return STRINGS.NAMES[string.upper(prefab)]
end

local function GetTable(owner)
	--local difficulty = GetModConfigData("difficulty", modname)
	local hatlevel = owner.components.upgrader.hatlevel
	local list = {}
	
	if hatlevel < 5 then
		list = Ingredients[hatlevel]
	end
	
	return list
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

local function GetStr(owner)
	local list = GetTable(owner)
	local text = ""

	if owner.components.upgrader.hatlevel < 5 then
		for i = 1, #list, 1 do
			text = text.."\n"..GetIngameName(list[i][1]).." - "..CountInventoryItem(owner, list[i][1]).." / "..list[i][2]
		end
	else
		text = "\n"..STRINGS.YUKARI_UPGRADE_FINISHED
	end
	
	return text
end

local function GetCanpell(owner)
	local list = GetTable(owner)
	local condition = true

	if owner.components.upgrader.hatlevel < 5 then 
		for i = 1, #list, 1 do 
			condition = condition and ( CountInventoryItem(owner, list[i][1]) >= list[i][2] )
		end
	else
		condition = false
	end
	
	return condition
end

local function DoUpgrade(inst, owner)
	local inventory = owner.components.inventory
	local list = GetTable(owner)

	if not GetCanpell(owner) then
		inst.components.spellcard:SetCondition(false)
		inst.canspell:set(false)
		owner.components.talker:Say(STRINGS.YUKARI_MORE_INGREDIENT)
		return false
	end
	
	local function remove(item, left_count)
		if left_count > 0 then
			if item.components.stackable then
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

	for i = 1, #list, 1 do -- I won't use RemoveItem function in inventory components because it doesn't get items in custom backpack slot. 
		local left_count = list[i][2]

		while left_count > 0 do
			for k,v in pairs(inventory.itemslots) do
				if v.prefab == list[i][1] then
					left_count = remove(v, left_count)
				end
			end
			
			for k,v in pairs(inventory.equipslots) do
				if type(v) == "table" and v.components.container then
					for k, v2 in pairs(v.components.container.slots) do
						if v2.prefab == list[i][1] then
							left_count = remove(v2, left_count)
						end
					end
				end
			end
		end
	end

	
end

local function OnFinish(inst, owner)
	owner.components.upgrader.hatlevel = owner.components.upgrader.hatlevel + 1
	owner.components.upgrader:DoUpgrade(owner)
	owner.components.talker:Say(GetString(owner.prefab, "DESCRIBE_HATUPGRADE"))
end

local function GetDesc(inst, viewer)
	if viewer.prefab == "yakumoyukari" then
		return string.format( STRINGS.YUKARI_CURRENT_LEVEL.." - "..viewer.components.upgrader.hatlevel..GetStr(viewer) )
	end
end

local function SetState(inst, data)
	local condition = GetCanpell(data.owner)
	inst.components.spellcard:SetCondition(condition)
	inst.canspell:set(condition)
end

local function fn()  

	local inst = CreateEntity() 
	
	inst.entity:AddTransform()    
	inst.entity:AddAnimState()    
	inst.entity:AddNetwork()	
	inst.entity:AddSoundEmitter() 
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("scheme.tex") 

	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("spell")    
	inst.AnimState:SetBuild("spell")    
	inst.AnimState:PlayAnimation("idle")    

	inst:AddTag("scheme")
	inst:AddTag("recieveitemupdate")

	inst.canspell = net_bool(inst.GUID, "canspell")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
    end

	inst:AddComponent("inspectable")    
	inst.components.inspectable.getspecialdescription = GetDesc
	
	inst:AddComponent("inventoryitem")   
	inst.components.inventoryitem.atlasname = "images/inventoryimages/scheme.xml" 
	
	inst:AddComponent("spellcard")
	inst.components.spellcard.name = "scheme"
	inst.components.spellcard:SetSpellFn( DoUpgrade )
	inst.components.spellcard:SetOnFinish( OnFinish )
	inst.components.spellcard:SetCondition( false )
	
	inst:ListenForEvent("onitemupdate", SetState)
	
	return inst
end
	
return Prefab("common/inventory/scheme", fn, assets)