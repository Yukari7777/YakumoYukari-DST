local ActionHandler = GLOBAL.ActionHandler
local FRAMES = GLOBAL.FRAMES
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local EventHandler = GLOBAL.EventHandler
local TimeEvent = GLOBAL.TimeEvent
local SpawnPrefab = GLOBAL.SpawnPrefab
local State = GLOBAL.State
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
local TheWorld = GLOBAL.TheWorld
-- local TUNING = GLOBAL.TUNING
local TIMEOUT = 2
local Language = GetModConfigData("language")


local UTELE = AddAction("UTELE", "Teleport", function(act)
	if act.invobject and act.invobject.components.makegate then
		return act.invobject.components.makegate:Teleport(act.pos, act.doer)
	end
end)

UTELE.priority = 10
UTELE.distance = 14
UTELE.rmb = true
UTELE.mount_valid = false

local utele = State({ -- server
    name = "utele",
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

local utelec = State({ -- client
	name = "uteles",
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

AddStategraphState("wilson", utele)
AddStategraphState("wilson_client", utelec)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UTELE, "utele"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.UTELE, "utelec"))



local SPAWNG = AddAction("SPAWNG", "Spawn Scheme Tunnel", function(act)
	if act.invobject and act.invobject.components.makegate then
        return act.invobject.components.makegate:RCreate(act.pos, act.doer)
    end
end)

SPAWNG.priority = 7
SPAWNG.distance = 6
SPAWNG.rmb = true
SPAWNG.mount_valid = false

local spawng = State({
    name = "spawng",
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

local spawngc = State({
	name = "spawngc",
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
	
AddStategraphState("wilson", spawng)
AddStategraphState("wilson_client", spawngc)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SPAWNG, "spawng"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SPAWNG, "spawngc"))



local function action_umbre(inst, doer, pos, actions, right)
	if right then
		if TheWorld and TheWorld.ismastersim then
			local equip = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
		else	
			local equip = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		end 

		if equip ~= nil then
			if equip.isunfolded and inst.components.makegate:CanSpell(doer, 75, pos) then
				table.insert(actions, ACTIONS.SPAWNG)
			elseif equip.isunfolded == false and inst.components.makegate:CanSpell(doer, 33, pos) then
				table.insert(actions, ACTIONS.UTELE)
			end
		end
	end
end

AddComponentAction("POINT", "makegate", action_umbre)

------------------------------------------------------------------------------------------------------------------------
local CASTTOHO = AddAction("CASTTOHO", "castspell", function(act)
	local item = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if item and item.components.spellcard then
		item.components.spellcard:CastSpell(act.target)
		return true
	end
end)

CASTTOHO.priority = -1
CASTTOHO.rmb = true
CASTTOHO.mount_valid = false

local casttoho = State({ -- todo : use "read" motion
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
        TimeEvent(13 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("soundpack/spell/spelldt")
        end),
        TimeEvent(53 * FRAMES, function(inst)
            inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
            inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
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


local function spell_inv(inst, doer, actions, right)
        if doer:HasTag("yakumoyukari") 
		and inst.components.spellcard ~= nil
		and inst.components.spellcard:CanCast(doer) then
            table.insert(actions, ACTIONS.CASTTOHO)
        end
end
AddComponentAction("INVENTORY", "spellcard", spell_inv)


local CASTTOHOH = AddAction("CASTTOHOH", "castspell", function(act) -- necro fantasia, ultupgrade
	local item = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if item and item.components.spellcard and item.components.spellcard:CanCast(act.doer, act.target, act.pos) then
		item.components.spellcard:CastSpell(act.target, act.pos)
		return true
	end
end)

CASTTOHOH.priority = -1
CASTTOHOH.rmb = true
CASTTOHOH.mount_valid = false

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
        TimeEvent(17 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("soundpack/spell/bigspell")
        end),
        TimeEvent(53 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("soundpack/spell/border")
            inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
            inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
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
		inst.components.health:SetInvincible(false)
    end,
})

local casttohohc = State({
	name = "casttohohc",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
		inst.components.health:SetInvincible(true)
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
		inst.components.health:SetInvincible(false)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,

	onexit = function(inst)
        inst.components.health:SetInvincible(false)
    end,
})

AddStategraphState("wilson", casttohoh)
AddStategraphState("wilson_client", casttohohc)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CASTTOHOH, "casttohoh"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CASTTOHOH, "casttohohc"))

ACTIONS.JUMPIN.fn = function(act)
	if act.doer ~= nil and
        act.doer.sg ~= nil and
        act.doer.sg.currentstate.name == "jumpin_pre" then
        if act.target ~= nil and act.target.components.teleporter ~= nil and act.target.components.teleporter:IsActive() then
            act.doer.sg:GoToState("jumpin", { teleporter = act.target })
            return true
		elseif act.target ~= nil and act.target.components.schemeteleport ~= nil and act.target.components.schemeteleport.islinked then
			act.doer.sg:GoToState("jumpin", { teleporter = act.target })
			act.doer:DoTaskInTime(0.8, function()
				act.target.components.schemeteleport:Activate(act.doer)
			end)
			return true
        end
        act.doer.sg:GoToState("idle")
    end

end

local function tunnelfn(inst, doer, actions, right)
	if inst:HasTag("teleporter") and inst.components.schemeteleport.islinked then
		table.insert(actions, ACTIONS.JUMPIN)
    end
end
AddComponentAction("SCENE", "schemeteleport", tunnelfn)

if Language == "chinese" then
UTELEPORT.str = "传 送"
SPAWNG.str = "生 成"
CASTTOHO.str = "施 法"
CASTTOHOH.str = "施 法"
end