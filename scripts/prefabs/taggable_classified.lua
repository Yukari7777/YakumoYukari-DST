--------------------------------------------------------------------------
--Client interface
--------------------------------------------------------------------------

local function OnRemoveEntity(inst)
    if inst._parent ~= nil then
        inst._parent.taggable_classified = nil
    end
end

local function OnEntityReplicated(inst)
	print("OnEntityReplicated")
    inst._parent = inst.entity:GetParent()
    if inst._parent == nil then
        print("Unable to initialize classified data for taggable")
    elseif inst._parent.replica.taggable ~= nil then
        inst._parent.replica.taggable:AttachClassified(inst)
    else
        inst._parent.taggable_classified = inst
        inst.OnRemoveEntity = OnRemoveEntity
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()
	print("classified spawned")

    if TheWorld.ismastersim then
        inst.entity:AddTransform() --So we can follow parent's sleep state
    end
    inst.entity:AddNetwork()
    inst.entity:Hide()
    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		print("In classified, not TheWorld.ismastersim")
        --Client interface
        inst.OnEntityReplicated = OnEntityReplicated

        return inst
    end
	print("In classified, TheWorld.ismastersim")
    inst.persists = false

    return inst
end

return Prefab("taggable_classified", fn)