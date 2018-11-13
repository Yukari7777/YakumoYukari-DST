local assets =
{
	Asset("ANIM", "anim/tunnel.zip" ),
	Asset("ANIM", "anim/ui_board_5x1.zip"),
}

local function onsave(inst, data)
	data.index = inst.components.scheme.index
	data.pointer = inst.components.scheme.pointer
	data.owner = inst.components.scheme.owner
end

local function onload(inst, data)
	if data ~= nil then
		inst.components.scheme.index = data.index
		inst.components.scheme.pointer = data.pointer
		inst.components.scheme.owner = data.owner
		inst.components.scheme:InitGate()
	end
end

local function onremoved(inst, doer)
	if inst.components.scheme ~= nil then
		inst.components.scheme:Disconnect(inst.components.scheme.index)
	end
end

local function GetDesc(inst, viewer)
	local name = inst.components.taggable:GetText() or "#"..inst.components.scheme.index
	local pointer = inst.components.scheme.pointer
	local destination = "\nIt is not connected."

	if pointer ~= nil then
		local destname = _G.TUNNELNETWORK[pointer].inst.components.taggable:GetText() or "#"..pointer
		destination = destname ~= nil and "\nconnected to\n"..destname
	end

	if name == "#1" and pointer == nil and _G.TUNNELFIRSTINDEX == nil then
		return GetDescription(viewer, inst)
	end

	return string.format( name..destination )
end

local function onaccept(inst, giver, item)
	if inst.components.scheme.pointer == nil then return false end -- It will just disappeared.
    inst.components.inventory:DropItem(item)
    inst.components.scheme:Activate(item)
end

local function fn()
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
    inst:AddTag("_writeable")--Sneak these into pristine state for optimization
	inst.islinked = net_bool(inst.GUID, "islinked")
	
	if not TheWorld.ismastersim then
		return inst
    end

	inst.entity:SetPristine()
	inst:RemoveTag("_writeable")

	inst:SetStateGraph("SGtunnel")
    inst:AddComponent("inspectable")
	inst.components.inspectable.getspecialdescription = GetDesc

	inst:AddComponent("scheme")

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(5,5)
	inst.components.playerprox.onnear = function()
		if inst.components.scheme:IsConnected() and not (inst.sg.currentstate.name == ("open" or "opening")) then
			inst.sg:GoToState("opening")
		end
	end
	inst.components.playerprox.onfar = function()
		if inst.sg.currentstate.name == ("open" or "opening") then
			inst.sg:GoToState("closing")
		end
	end

	inst:AddComponent("taggable")

	inst:AddComponent("inventory")

	inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false

	inst.OnRemoveEntity = onremoved
	inst.OnSave = onsave
	inst.OnLoad = onload

    return inst
end

return Prefab( "common/objects/tunnel", fn, assets)