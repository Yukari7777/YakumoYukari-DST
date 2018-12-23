local function SetDirty(netvar, val)
    --Forces a netvar to be dirty regardless of value
    netvar:set_local(val)
    netvar:set(val)
end

local function OnEntityReplicated(inst)
    inst._parent = inst.entity:GetParent()
    if inst._parent == nil then
        print("Unable to initialize classified data for player Yukari")
    else
		inst._parent:AttachYukariClassified(inst)
    end
end

local function PushMessage(inst)
	local modname = KnownModIndex:GetModActualName("Yakumo Yukari")
	local inspect = GetModConfigData("skill", modname) or GetModConfigData("skill", "workshop-1432504104") or 4
	local ClientString = inst.inspect:value()

	if inst._parent.HUD ~= nil then
		if inspect % 4 >= 2 then print(ClientString) end
		if inspect % 8 >= 4 then 
			for v in string.gmatch(ClientString, ".-%c") do
				inst._parent.HUD.controls.networkchatqueue:PushMessage("", v, {0.8, 0.8, 0.8, 1})
			end
		end
	end
end

local function KeyCheckCommon(inst)
	return inst == ThePlayer and TheFrontEnd:GetActiveScreen() ~= nil and TheFrontEnd:GetActiveScreen().name == "HUD"
end

local function RegisterKeyEvent(classified)
	TheInput:AddKeyDownHandler(_G["KEY_V"], function() 
		if KeyCheckCommon(classified._parent) then
			SendModRPCToServer(MOD_RPC["yakumoyukari"]["sayinfo"], classified._parent) 
		end
	end) 
end

local NIGHTVISION_COLOURCUBES = {
	day = "images/colour_cubes/beaver_vision_cc.tex",
	dusk = "images/colour_cubes/beaver_vision_cc.tex",
	night = "images/colour_cubes/beaver_vision_cc.tex",
	full_moon = "images/colour_cubes/beaver_vision_cc.tex",
}

local function SetNightVision(inst)
	local var = inst.nightvision:value()
	inst._parent.components.playervision:ForceNightVision(var)
	inst._parent.components.playervision:SetCustomCCTable(var and NIGHTVISION_COLOURCUBES or nil)
end

local function SetFastActionLevel(inst)
	local level = inst.fastaction:value()
	print(level, type(level), level > 0, level > 1)
	inst._parent.fastpicker = level > 0
	inst._parent.fastcrafter = level > 1
	inst._parent.fastharvester = level > 2
	inst._parent.fastresetter = level > 2
end

local function RegisterNetListeners(inst)
	if TheWorld.ismastersim then
		inst._parent = inst.entity:GetParent()
	else
		RegisterKeyEvent(inst)
	end
	inst:ListenForEvent("onskillinspectdirty", PushMessage)
	inst:ListenForEvent("setnightvisiondirty", SetNightVision)
	inst:ListenForEvent("setfastactiondirty", SetFastActionLevel)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform() --So we can follow parent's sleep state
    inst.entity:AddNetwork()
    inst.entity:Hide()
    inst:AddTag("CLASSIFIED")

	inst.inspect = net_string(inst.GUID, "onskillinspect", "onskillinspectdirty")

	inst.inspell = net_bool(inst.GUID, "oninspell", "oninspelldirty")
	inst.inspell:set(false)

	inst.inspellbait = net_bool(inst.GUID, "oninspellbait", "oninspellbaitdirty")
	inst.inspellbait:set(false)
	
	inst.nightvision = net_bool(inst.GUID, "isnightvistion", "setnightvisiondirty")
	inst.nightvision:set(false)

	inst.fastaction = net_tinybyte(inst.GUID, "setfastaction", "setfastactiondirty")
	

	--Delay net listeners until after initial values are deserialized
    inst:DoTaskInTime(0, RegisterNetListeners)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        --Client interface
        inst.OnEntityReplicated = OnEntityReplicated
        return inst
    end

	inst.persists = false

    return inst
end


return Prefab("yukari_classified", fn)