local ActionHandler = GLOBAL.ActionHandler
local EventHandler = GLOBAL.EventHandler
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local TimeEvent = GLOBAL.TimeEvent
local SpawnPrefab = GLOBAL.SpawnPrefab
local State = GLOBAL.State
local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local TIMEOUT = 2

-- OVERRIDE

local function SetFastPickerServer(inst, action)
	return action.target ~= nil
        and action.target.components.pickable ~= nil
        and (   (action.target.components.pickable.jostlepick and "dojostleaction") or
                (action.target.components.pickable.quickpick and "doshortaction") or
				(inst.yukari_classified ~= nil and inst.yukari_classified.fastaction:value() > 0 and "doshortaction") or
                (inst:HasTag("fastpicker") and "doshortaction") or
                (inst:HasTag("quagmire_fasthands") and "domediumaction") or
                "dolongaction"  )
        or nil
end
local function SetFastPickerClient(inst, action)
	return (action.target:HasTag("jostlepick") and "dojostleaction")
        or (action.target:HasTag("quickpick") and "doshortaction")
		or (inst.yukari_classified ~= nil and inst.yukari_classified.fastaction:value() > 0 and "doshortaction")
        or (inst:HasTag("fastpicker") and "doshortaction")
        or (inst:HasTag("quagmire_fasthands") and "domediumaction")
        or "dolongaction"
end
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PICK, SetFastPickerServer))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PICK, SetFastPickerClient))

local function SetFastBuilder(inst, action)
	local rec = GLOBAL.GetValidRecipe(action.recipe)
    return (rec ~= nil and rec.tab.shop and "give")
        or (inst.yukari_classified ~= nil and inst.yukari_classified.fastaction:value() > 1 and "domediumaction")
        or (inst.fastcrafter and "domediumaction")
        or "dolongaction"
end
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BUILD, SetFastBuilder))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BUILD, SetFastBuilder))

local function SetFastResetter(inst, action)
	return (inst.yukari_classified ~= nil and inst.yukari_classified.fastaction:value() > 2) and "doshortaction" or "dolongaction"
end
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RESETMINE, SetFastResetter))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RESETMINE, SetFastResetter))

local function SetFastHarvester(inst, action) 
	return inst:HasTag("quagmire_fasthands") or (inst.yukari_classified ~= nil and inst.yukari_classified.fastaction:value() > 3) and "doshortaction" or "dolongaction"
end
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.HARVEST, SetFastHarvester))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.HARVEST, SetFastHarvester))

-----------------------------------------------------------------------------------------

local ytele = State({
    name = "ytele",
    tags = {"doing", "busy", "canrotate"},

    onenter = function(inst)
		-- if inst.components.rider:IsRiding() then
		-- end
		inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_pre")
        inst.AnimState:PushAnimation("atk", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
    end,

    timeline = 
    {
        TimeEvent(15*FRAMES, function(inst) inst:PerformBufferedAction() end),
    },

    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
})

local utelec = State({
	name = "utelec",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_pre")
        inst.AnimState:PushAnimation("atk_lag", false)

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})

AddStategraphState("wilson", ytele)
AddStategraphState("wilson_client", utelec)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.YTELE, "ytele"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.YTELE, "utelec"))

-------------------------------------------------------------------------------------------

local casttoho = State({
    name = "casttoho",
    tags = {"doing", "busy", "canrotate"},

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
       inst.AnimState:PlayAnimation("staff_pre")
       inst.AnimState:PushAnimation("staff", false)
	   inst.components.locomotor:Stop()

		--Spawn an effect on the player's location
        local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local colour = staff ~= nil and staff.fxcolour or {95/255,0,1}

        inst.sg.statemem.spellfx = SpawnPrefab("staffcastfx")
        inst.sg.statemem.spellfx.entity:SetParent(inst.entity)
        inst.sg.statemem.spellfx.Transform:SetRotation(inst.Transform:GetRotation())
        inst.sg.statemem.spellfx:SetUp(colour)

        inst.sg.statemem.spelllight = SpawnPrefab("staff_castinglight")
        inst.sg.statemem.spelllight.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.sg.statemem.spelllight:SetUp(colour, 1.9, .33)

		inst.sg.statemem.castsound = staff ~= nil and staff.castsound or "soundpack/spell/spelldt"
    end,
		
	timeline = 
	{
        TimeEvent(13 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("soundpack/spell/spelldt")
        end),
        TimeEvent(53 * FRAMES, function(inst)
            inst.sg.statemem.spellfx = nil --Can't be cancelled anymore
            inst.sg.statemem.spelllight = nil --Can't be cancelled anymore
            --V2C: NOTE! if we're teleporting ourself, we may be forced to exit state here!
            inst:PerformBufferedAction()
        end),
    },

	events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

	onexit = function(inst)
		if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
            inst.sg.statemem.stafffx:Remove()
        end
        if inst.sg.statemem.stafflight ~= nil and inst.sg.statemem.stafflight:IsValid() then
            inst.sg.statemem.stafflight:Remove()
        end
    end,
})

local casttohoc = State({
   name = "casttohoc",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("staff_pre")
        inst.AnimState:PushAnimation("staff_lag", false)

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})

AddStategraphState("wilson", casttoho)
AddStategraphState("wilson_client", casttohoc)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CASTTOHO, "casttoho"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CASTTOHO, "casttohoc"))

-----------------------------------------------------------------------------------------------

local casttohoh = State({ -- server
    name = "casttohoh",
    tags = {"doing", "busy"},

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
		inst.components.health:SetInvincible(true)
        inst.AnimState:PlayAnimation("staff_pre")
        inst.AnimState:PushAnimation("staff", false)
        inst.components.locomotor:Stop()

		--Spawn an effect on the player's location
        local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local colour = staff ~= nil and staff.fxcolour or {95/255,0,1}

        inst.sg.statemem.stafffx = SpawnPrefab("staffcastfx")
        inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
        inst.sg.statemem.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
        inst.sg.statemem.stafffx:SetUp(colour)

        inst.sg.statemem.stafflight = SpawnPrefab("staff_castinglight")
        inst.sg.statemem.stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.sg.statemem.stafflight:SetUp(colour, 1.9, .33)

		inst.sg.statemem.castsound = staff ~= nil and staff.castsound or "soundpack/spell/spelldt"
    end,
		
	timeline = 
	{
        TimeEvent(10 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("soundpack/spell/bigspell")
        end),
        TimeEvent(67 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("soundpack/spell/border")
            inst.sg.statemem.stafffx = nil 
            inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
            inst:PerformBufferedAction()
        end),
    },

	events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

	onexit = function(inst)
		if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
            inst.sg.statemem.stafffx:Remove()
        end
        if inst.sg.statemem.stafflight ~= nil and inst.sg.statemem.stafflight:IsValid() then
            inst.sg.statemem.stafflight:Remove()
        end
		inst.components.health:SetInvincible(false)
    end,
})

local casttohohc = State({
	name = "casttohohc",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("staff_pre")
        inst.AnimState:PushAnimation("staff_lag", false)

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})

AddStategraphState("wilson", casttohoh)
AddStategraphState("wilson_client", casttohohc)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CASTTOHOH, "casttohoh"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CASTTOHOH, "casttohohc"))