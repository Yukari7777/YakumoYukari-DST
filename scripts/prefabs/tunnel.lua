local assets =
{
	Asset("ANIM", "anim/tunnel.zip" ),
}

local function onpreload(inst, data)
	if data then
		inst:Remove() -- we need to delete dummy gates first.

		if data.ax and data.ay and data.az then
			local scheme_a = SpawnPrefab("tunnel")
			scheme_a.Transform:SetPosition(data.ax, data.ay, data.az)
			TheWorld.components.scheme_manager:InitGate(scheme_a)
		end
		
		if data.bx and data.by and data.bz then
			local scheme_b = SpawnPrefab("tunnel")
			scheme_b.Transform:SetPosition(data.bx, data.by, data.bz)
			TheWorld.components.scheme_manager:InitGate(scheme_b)
		end
		
		TheWorld.components.scheme_manager.isb = data.isb
	end
end

local function onsave(inst, data)

	if TheWorld.components.scheme_manager.gate_a then
		local x, y, z = TheWorld.components.scheme_manager.gate_a.Transform:GetWorldPosition()
		data.ax, data.ay, data.az = x, y, z
	end
	if TheWorld.components.scheme_manager.gate_b then
		local x, y, z = TheWorld.components.scheme_manager.gate_b.Transform:GetWorldPosition()
		data.bx, data.by, data.bz = x, y, z
	end
	
	data.isb = TheWorld.components.scheme_manager.isb
end

local function fn(Sim)

	local inst = CreateEntity()    
	
	inst.entity:AddTransform()    
	inst.entity:AddAnimState()    
	inst.entity:AddSoundEmitter()  
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()	
    
    inst.MiniMapEntity:SetIcon("minimap_tunnel.tex")
   
    inst.AnimState:SetBank("tunnel")
    inst.AnimState:SetBuild("tunnel")
	inst.AnimState:SetLayer( LAYER_BACKGROUND )
	inst.AnimState:SetSortOrder( 3 )
	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("tunnel") 
	inst:AddTag("teleporter")
	
	if not TheWorld.ismastersim then
		return inst
    end

	inst.entity:SetPristine()


	inst:SetStateGraph("SGtunnel")
    inst:AddComponent("inspectable")

	inst:AddComponent("schemeteleport")
	inst:AddComponent("scheme_manager")

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(5,5)
	inst.components.playerprox.onnear = function()
		if inst.components.schemeteleport.target then
			--_G.DisableWormholeJumpNoise()
			inst.sg:GoToState("opening")
		end
	end
	
	inst.components.playerprox.onfar = function()
		if inst.sg.currentstate.name == "open" then
			--_G.EnableWormholeJumpNoise()
			inst.sg:GoToState("closing")
		end
	end
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload

    return inst
end

return Prefab( "common/objects/tunnel", fn, assets)