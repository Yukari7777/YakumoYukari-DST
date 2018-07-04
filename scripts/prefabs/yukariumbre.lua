local assets =
{   
	Asset("ANIM", "anim/yukariumbre.zip"),    
	Asset("ANIM", "anim/swap_yukariumbre.zip"),   
	Asset("ANIM", "anim/swap_yukariumbre2.zip"),
	Asset("ATLAS", "images/inventoryimages/yukariumbre.xml"),    
	Asset("IMAGE", "images/inventoryimages/yukariumbre.tex"),
}

local function onuse(staff, pos, caster)

    if caster.components.power then
		if staff.isunfolded then
			caster.components.power:DoDelta(-75, false)
		else
			caster.components.power:DoDelta(-33, false)
		end
    end

end

local function OnEquipYukari(inst, owner)        
	owner.AnimState:OverrideSymbol("swap_object", "swap_yukariumbre", "swap")
	owner.AnimState:Show("ARM_carry")        
	owner.AnimState:Hide("ARM_normal")
	
	inst.components.useableitem.inuse = false
end    

local function OnUnequipYukari(inst, owner)   
	owner.AnimState:Hide("ARM_carry")        
	owner.AnimState:Show("ARM_normal")
	owner.DynamicShadow:SetSize(1.3, 0.6)	
	
	inst.isunfolded = false
	inst.components.weapon:SetDamage(TUNING.YDEFAULT.YUKARI_UMBRE_DAMAGE)
	inst.components.waterproofer:SetEffectiveness(0)
end    

local function unfoldit(inst)
	local owner = inst.components.inventoryitem.owner
	
	if inst.isunfolded then
		owner:PushEvent("unequip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		owner:PushEvent("equip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		owner.AnimState:OverrideSymbol("swap_object", "swap_yukariumbre", "swap")
		owner.SoundEmitter:PlaySound("dontstarve/wilson/use_umbrella_down")
		owner.DynamicShadow:SetSize(1.3, 0.6)
		inst.components.weapon:SetDamage(TUNING.YDEFAULT.YUKARI_UMBRE_DAMAGE)
		inst.components.waterproofer:SetEffectiveness(0)
		
		inst.isunfolded = false
	else
		owner:PushEvent("unequip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		owner:PushEvent("equip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		owner.AnimState:OverrideSymbol("swap_object", "swap_yukariumbre2", "swap")
		owner.SoundEmitter:PlaySound("dontstarve/wilson/use_umbrella_up") 
		owner.DynamicShadow:SetSize(2.2, 1.4)
		inst.components.weapon:SetDamage(TUNING.YDEFAULT.YUKARI_UMBRE_DAMAGE_SMALL)
		inst.components.waterproofer:SetEffectiveness(1)
		
		inst.isunfolded = true
	end
	
	inst.components.useableitem.inuse = false
end


local function fn()  

	local inst = CreateEntity()   
	
	inst.entity:AddTransform()    
	inst.entity:AddAnimState()    
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
    inst.MiniMapEntity:SetIcon("yukariumbre.tex")	
	
	MakeInventoryPhysics(inst)     
	
	inst.AnimState:SetBank("yukariumbre")    
	inst.AnimState:SetBuild("yukariumbre")    
	inst.AnimState:PlayAnimation("idle")  

	inst:AddTag("nopunch")
	inst:AddTag("umbrella")
	
	inst.isunfolded = false

	if not TheWorld.ismastersim then
		return inst
    end

	inst.entity:SetPristine()
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("makegate")
	inst.components.makegate.onusefn = onuse
	
	inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()
	
	inst:AddComponent("reticule")
    inst.components.reticule.targetfn = function() 
        return inst.components.makegate:GetBlinkPoint()
    end
    inst.components.reticule.ease = true
	
	inst:AddComponent("inspectable")     
	
	inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.imagename = "yukariumbre"    
	inst.components.inventoryitem.atlasname = "images/inventoryimages/yukariumbre.xml"  
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.YDEFAULT.YUKARI_UMBRE_DAMAGE)
	
	inst:AddComponent("equippable")  
	inst.components.equippable:SetOnEquip( OnEquipYukari )    
	inst.components.equippable:SetOnUnequip( OnUnequipYukari )
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	
	inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(unfoldit)

	return inst
end
	
return Prefab("common/inventory/yukariumbre", fn, assets)