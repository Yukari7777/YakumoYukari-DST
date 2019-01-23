local assets =
{   
	Asset("ANIM", "anim/yukarihat.zip"),    
	Asset("ANIM", "anim/yukarihat_swap.zip"),    
	Asset("ATLAS", "images/inventoryimages/yukarihat.xml"),    
}

local prefabs = {
	"mindcontroller",
}

local function NegateStranger(inst, owner)
	if not owner:HasTag("yakumoyukari") then
		if owner:HasTag("player") then
			owner.components.sanity:SetInducedInsanity(inst, true)
			owner.components.debuffable:AddDebuff("mindcontroller", "mindcontroller")
			owner.components.debuffable:GetDebuff("mindcontroller")._level:set(100)
			owner.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/mindcontrol_LP", "yukarihatmc")
			owner:DoTaskInTime(4, function()
				owner.SoundEmitter:KillSound("yukarihatmc")
				owner.components.sanity:SetInducedInsanity(inst, false)
				owner.components.inventory:DropItem(inst, true, true)
			end)
		end
	end
end

local function SetAbsorbPercent(inst, percent)
	inst.components.armor.absorb_percent = percent
	inst.components.armor.condition = percent * 100
	inst:PushEvent("percentusedchange", { percent = percent })
end

local function SetSpeedMult(inst, mult)
	inst.components.equippable.walkspeedmult = mult
end

local function SetWaterProofness(inst, val)
	inst.components.waterproofer:SetEffectiveness(val and 1 or 0)
	if val then inst:AddTag("waterproofer") else inst:RemoveTag("waterproofer") end
end

local function Initialize(inst)
	inst:RemoveTag("shadowdominance")
	inst:SetWaterProofness(false)
	inst:SetGoggle(false)
	inst:SetAbsorbPercent(.01)
	inst:SetSpeedMult(1)
end

local function SetGoggle(inst, val)
	if val then
		inst:AddTag("goggles")
	else
		inst:RemoveTag("goggles")
	end
end

local function GetPercentTweak(self)
	if self.condition == 1 then -- see SerializePercentUsed in inventoryitem_replica.lua
		return 0 
	end
	return self.condition / self.maxcondition
end

local function fn()  
	local function onequiphat(inst, owner)
        owner.AnimState:OverrideSymbol("swap_hat", "yukarihat_swap", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR") 
		owner:PushEvent("hatequipped", {isequipped = true, inst = inst})
		NegateStranger(inst, owner)
    end

    local function onunequiphat(inst, owner)
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR") 
		owner:PushEvent("hatequipped", {isequipped = false, inst = inst})
		Initialize(inst)
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
	inst:AddTag("yukarihat")

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
	inst.components.armor.GetPercent = GetPercentTweak
	inst.components.armor:InitIndestructible(0)
	inst.components.armor.condition = 1

	inst:AddComponent("equippable")    
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip( onequiphat )
    inst.components.equippable:SetOnUnequip( onunequiphat )
	
	inst.Initialize = Initialize
	inst.SetWaterProofness = SetWaterProofness
	inst.SetAbsorbPercent = SetAbsorbPercent
	inst.SetSpeedMult = SetSpeedMult
	inst.SetGoggle = SetGoggle
	
	return inst
end
	
return Prefab("common/inventory/yukarihat", fn, assets, prefabs)