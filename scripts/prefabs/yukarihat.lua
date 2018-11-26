local assets =
{   
	Asset("ANIM", "anim/yukarihat.zip"),    
	Asset("ANIM", "anim/yukarihat_swap.zip"),    
	Asset("ATLAS", "images/inventoryimages/yukarihat.xml"),    
}

local function InitializeStatus(inst)
	inst.components.waterproofer:SetEffectiveness(0)
	inst.components.armor.absorb_percent = 0
end

local function SetAbsorbPercent(inst, percent)
	print("onset absorbpercent", inst, percent)
	inst.components.armor.absorb_percent = percent
end

local function fn()  
	
	local function onequiphat(inst, owner)
        owner.AnimState:OverrideSymbol("swap_hat", "yukarihat_swap", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR") 
		owner:PushEvent("hatequipped", {isequipped = true, inst = inst})
    end

    local function onunequiphat(inst, owner)
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR") 
		owner:PushEvent("hatequipped", {isequipped = false, inst = inst})
		InitializeStatus(inst)
    end

	local inst = CreateEntity()    
	
	inst.entity:AddTransform()    
	inst.entity:AddAnimState()    
	inst.entity:AddSoundEmitter()  
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()	
	
	inst.MiniMapEntity:SetIcon("yukarihat.tex")
	
	MakeInventoryPhysics(inst)
		
	inst.AnimState:SetBank("yukarihat")
	inst.AnimState:SetBuild("yukarihat")
	inst.AnimState:PlayAnimation("idle")    

	inst:AddTag("hat")
	inst:AddTag("yakumoyukari")
	
	if not TheWorld.ismastersim then
		return inst
    end

	inst.entity:SetPristine()
	
	
	inst:AddComponent("inspectable")        
	
	inst:AddComponent("inventoryitem")   
	inst.components.inventoryitem.atlasname = "images/inventoryimages/yukarihat.xml"  
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("armor")
	inst.components.armor:InitIndestructible(0)

	inst:AddComponent("equippable")    
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip( onequiphat )
    inst.components.equippable:SetOnUnequip( onunequiphat )
	
	inst.SetAbsorbPercent = SetAbsorbPercent
	
	return inst
end
	
return Prefab("common/inventory/yukarihat", fn, assets)