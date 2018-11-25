local assets =
{
	Asset("ANIM", "anim/smoke_puff_small.zip"),
}

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("small_puff")
    inst.AnimState:SetBuild("smoke_puff_small")
	inst.AnimState:PlayAnimation("puff")

	inst.persists = false -- handled in a special way

	inst:AddTag("FX")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
	
	return inst
end

return Prefab("fx/puff_fx", fn, assets)