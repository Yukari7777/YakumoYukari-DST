local assets =
{   
	Asset("ANIM", "anim/yukarihat.zip"),    
	Asset("ANIM", "anim/yukarihat_swap.zip"),    
	Asset("ATLAS", "images/inventoryimages/yukarihat.xml"),    
}

local function Ability(inst, owner)

	if owner.components.upgrader:IsHatValid() then
		if owner.components.upgrader.hatlevel >= 3 then
			inst.components.waterproofer:SetEffectiveness(1)
		end
		
		if owner.components.upgrader.hatlevel >= 4 then
			inst.components.equippable.poisonblocker = true
			inst.components.equippable.poisongasblocker = true
			if not owner.fireimmuned and owner.components.health then
				owner.components.health.fire_damage_scale = 0
			end
		end
	else
		inst.components.waterproofer:SetEffectiveness(0)
		inst.components.equippable.poisonblocker = false
		inst.components.equippable.poisongasblocker = false
		if not owner.fireimmuned == false and owner.components.health then
			owner.components.health.fire_damage_scale = 1
		end
	end
	
end

local function fn()  
	
	local function onequiphat(inst, owner)
        owner.AnimState:OverrideSymbol("swap_hat", "yukarihat_swap", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR") 
		Ability(inst, owner) 
		owner:PushEvent("hatequip")
    end

    local function onunequiphat(inst, owner)
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR") 
		Ability(inst, owner) 
		owner:PushEvent("hatunequip")
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
	inst:AddTag("irreplaceable")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
    end
	
	
	inst:AddComponent("inspectable")        
	
	inst:AddComponent("inventoryitem")   
	inst.components.inventoryitem.atlasname = "images/inventoryimages/yukarihat.xml"  
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("equippable")    
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip( onequiphat )
    inst.components.equippable:SetOnUnequip( onunequiphat )
	inst.components.equippable.poisonblocker = false	
	inst.components.equippable.poisongasblocker = false
	
	return inst
end
	
return Prefab("common/inventory/yukarihat", fn, assets)