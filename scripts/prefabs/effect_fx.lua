local assets_graze =
{
	Asset("ANIM", "anim/graze_fx.zip"),
}

local function fn_graze(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddPhysics()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

	inst.Physics:SetMass(0)
    inst.Physics:SetCapsule(0, 0)

	inst.AnimState:SetBank("graze_fx")
    inst.AnimState:SetBuild("graze_fx")
	inst.AnimState:PlayAnimation("idle")

	inst.persists = false -- handled in a special way

	inst:AddTag("NOCLICK")
	inst:AddTag("FX")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("locomotor") -- issue : it won't move
	inst.components.locomotor.runspeed = math.random(50) / 10
	inst.components.locomotor:RunInDirection(math.random() * 360)
	inst.components.locomotor:RunForward() 

	inst.SoundEmitter:PlaySound("soundpack/spell/graze")
	inst:DoTaskInTime(0.6, inst.Remove)
	
	return inst
end

return  Prefab( "fx/graze_fx", fn_graze, assets_graze)