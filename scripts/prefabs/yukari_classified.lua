local function SetDirty(netvar, val)
    --Forces a netvar to be dirty regardless of value
    netvar:set_local(val)
    netvar:set(val)
end

local function YukariToggleGoggles(self, show)
	local owner = self.owner
	local shouldshow = true
	if owner ~= nil then
		shouldshow = owner.replica.inventory:EquipHasTag("goggles") and not owner.replica.inventory:EquipHasTag("yukarihat")
	end

	if show then
        if not self.shown and shouldshow then
            self:Show()
            self:AddChild(self.storm_overlays):MoveToBack()
        end
    elseif self.shown then
        self:Hide()
        self.storm_root:AddChild(self.storm_overlays)
    end
end

local function DoHUDTweak(inst)
	inst._parent.HUD.gogglesover.ToggleGoggles = YukariToggleGoggles
end

local function OnEntityReplicated(inst)
    inst._parent = inst.entity:GetParent()
    if inst._parent == nil then
        print("Unable to initialize classified data for player Yukari")
    else
		inst._parent:AttachYukariClassified(inst)
		DoHUDTweak(inst)
    end
end

local function PushMessage(inst)
	local modname = KnownModIndex:GetModActualName("Yakumo Yukari")
	local inspect = GetModConfigData("skill", modname) or 4
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
	local parent = classified._parent
	if parent.HUD == nil then return end -- if it's not a client, stop here.
	TheInput:AddKeyDownHandler(_G["KEY_V"], function() 
		if KeyCheckCommon(parent) then
			SendModRPCToServer(MOD_RPC["yakumoyukari"]["sayinfo"], parent) 
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
	inst._parent.fastpicker = level > 0
	inst._parent.fastcrafter = level > 1
	inst._parent.fastharvester = level > 2
	inst._parent.fastresetter = level > 3
end

local function RegisterNetListeners(inst)
	if TheWorld.ismastersim then
		inst._parent = inst.entity:GetParent()
	else
		-- Be aware that writting something in this block means,
		-- You do NOT want to run the thing in the server
		-- which EXCLUDES the host of server that doesn't have cave.
		-- In most cases that you want to make 'clienty' things,
		-- call the function out of this block, then use parent.HUD == nil rather writting things in here.
	end
	RegisterKeyEvent(inst)
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

	inst.inspellcommon = net_bool(inst.GUID, "oninspell", "oninspelldirty")
	inst.inspellcommon:set(false)

	inst.inspellcurse = net_bool(inst.GUID, "oninspellcurse", "oninspellcursedirty")
	inst.inspellcurse:set(false)

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