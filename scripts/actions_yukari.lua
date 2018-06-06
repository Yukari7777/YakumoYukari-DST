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
local Language = GetModConfigData("language")

-- Action Settings for Yukari --

local UTELEPORT = AddAction("UTELEPORT", "Teleport", function(act)
	if act.invobject and act.invobject.components.makegate then
		return act.invobject.components.makegate:Teleport(act.pos, act.doer)
	end
end)

-- local UTELEPORT = Action({priority = 10, distance = 14, mount_valid = false})
--UTELEPORT.id = "SPAWNG"
--UTELEPORT.str = "Spawn"
--UTELEPORT.fn = function(act)
--    if act.invobject and act.invobject.components.makegate then
--		return act.invobject.components.makegate:Teleport(act.pos, act.doer)
--	end
--end
--AddAction(UTELEPORT)

local utele = State({ -- for host
    name = "utele",
    tags = {"doing", "busy", "canrotate"},

    onenter = function(inst)
		-- if inst.components.rider:IsRiding() then
		-- end
		inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_pre") -- Todo : do without bring something
        inst.AnimState:PushAnimation("atk", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
    end,

    timeline = 
    {
        TimeEvent(8*FRAMES, function(inst) inst:PerformBufferedAction() end),
    },

    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
})

AddStategraphState("wilson", utele)
AddStategraphState("wilson_client", utele)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UTELEPORT, "utele"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.UTELEPORT, "utele"))

local function action_teleport(inst, doer, pos, actions, right)
	if right then
		local equip = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) -- Todo : do without bring something

		if equip and inst.components.makegate:CanMakeToPoint(pos) then
			if equip.isunfolded then
				table.insert(actions, ACTIONS.SPAWNG)
			else
				table.insert(actions, ACTIONS.UTELEPORT)
			end
		end
	end
end

AddComponentAction("POINT", "makegate", action_teleport)




local SPAWNG = Action({1, false, true})
SPAWNG.id = "SPAWNG"
SPAWNG.str = "Spawn"
SPAWNG.fn = function(act)
    if act.invobject and act.invobject.components.makegate then
        return act.invobject.components.makegate:RCreate(act.pos, act.doer)
    end
end

AddStategraphPostInit("wilson", function(Stategraph)
	
	local state = State {
        name = "spawnrgate",
        tags = {"doing", "busy", "canrotate"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,

        timeline = 
        {
            TimeEvent(8*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle") 
            end ),
        },
    }
	
	Stategraph.states["spawnrgate"] = state

end)

------------------------------------------------------------------------------------------------------------------------
local CASTTOHO = Action({-1, false, true})
CASTTOHO.id = "CASTTOHO"
CASTTOHO.str = "castspell"
CASTTOHO.fn = function(act)
	local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if staff and staff.components.spellcard and staff.components.spellcard:CanCast(act.doer, act.target, act.pos) then
		staff.components.spellcard:CastSpell(act.target, act.pos)
		return true
	end
end

AddStategraphPostInit("wilson", function(Stategraph)

	local state = State {
        name = "casttoho",
        tags = {"doing", "busy", "canrotate"},

        onenter = function(inst)
            inst.components.playercontroller:Enable(false)
            inst.AnimState:PlayAnimation("staff") 
            inst.components.locomotor:Stop()
            inst.stafffx = SpawnPrefab("staffcastfx")  
			--Spawn an effect on the player's location
			local pos = inst:GetPosition()
            inst.stafffx.Transform:SetPosition(pos.x, pos.y, pos.z)
            inst.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.stafffx.AnimState:SetMultColour(95/255, 0, 1, 1)
        end,
		
		onexit = function(inst)
            inst.components.playercontroller:Enable(true)
			if inst.stafffx then
                inst.stafffx:Remove()
            end
        end,

        timeline = 
        {
            TimeEvent(13*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("soundpack/spell/spelldt") -- Add Custom Sound
            end),
			TimeEvent(0*FRAMES, function(inst)
                inst.stafflight = SpawnPrefab("staff_castinglight")
                local pos = inst:GetPosition()
                local colour = {95/255,0,1}
                inst.stafflight.Transform:SetPosition(pos.x, pos.y, pos.z)
                inst.stafflight.setupfn(inst.stafflight, colour, 1.9, .33)                

            end),
			TimeEvent(53*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle") 
            end ),
        },
    }
	
	Stategraph.states["casttoho"] = state

end)

local CASTTOHOL = Action({-1, false, true}) -- Light motion
CASTTOHOL.id = "CASTTOHOL"
CASTTOHOL.str = "castspell"
CASTTOHOL.fn = function(act)
	local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if staff and staff.components.spellcard and staff.components.spellcard:CanCast(act.doer, act.target, act.pos) then
		staff.components.spellcard:CastSpell(act.target, act.pos)
		return true
	end
end

AddStategraphPostInit("wilson", function(Stategraph)

	local state = State {
        name = "casttohol",
        tags = {"doing", "busy", "canrotate"},

        onenter = function(inst)
            inst.components.playercontroller:Enable(false)
            inst.AnimState:PlayAnimation("staff") 
            inst.components.locomotor:Stop()
            inst.stafffx = SpawnPrefab("staffcastfx")  
			--Spawn an effect on the player's location
			local pos = inst:GetPosition()
            inst.stafffx.Transform:SetPosition(pos.x, pos.y, pos.z)
            inst.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.stafffx.AnimState:SetMultColour(95/255, 0, 1, 1)
        end,
		
		onexit = function(inst)
            inst.components.playercontroller:Enable(true)
			if inst.stafffx then
                inst.stafffx:Remove()
            end
        end,

        timeline = 
        {
            TimeEvent(13*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_gemstaff") -- Add Custom Sound
            end),
			TimeEvent(0*FRAMES, function(inst)
                inst.stafflight = SpawnPrefab("staff_castinglight")
                local pos = inst:GetPosition()
                local colour = {95/255,0,1}
                inst.stafflight.Transform:SetPosition(pos.x, pos.y, pos.z)
                inst.stafflight.setupfn(inst.stafflight, colour, 1.9, .33)                

            end),
			TimeEvent(53*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle") 
            end ),
        },
    }
	
	Stategraph.states["casttohol"] = state

end)


local CASTTOHOH = Action({-1, false, true}) -- Heavy motion
CASTTOHOH.id = "CASTTOHOH"
CASTTOHOH.str = "castspell"
CASTTOHOH.fn = function(act)
	local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if staff and staff.components.spellcard and staff.components.spellcard:CanCast(act.doer, act.target, act.pos) then
		staff.components.spellcard:CastSpell(act.target, act.pos)
		return true
	end
end


AddStategraphPostInit("wilson", function(Stategraph)

	local state = State {
        name = "casttohoh",
        tags = {"doing", "busy", "canrotate"},

        onenter = function(inst)
            inst.components.playercontroller:Enable(false)
			inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("staff") 
            inst.components.locomotor:Stop()
            inst.stafffx = SpawnPrefab("staffcastfx")  
			--Spawn an effect on the player's location
			local pos = inst:GetPosition()
            inst.stafffx.Transform:SetPosition(pos.x, pos.y, pos.z)
            inst.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.stafffx.AnimState:SetMultColour(95/255, 0, 1, 1)
        end,
		
		onexit = function(inst)
            inst.components.playercontroller:Enable(true)
			inst.components.health:SetInvincible(false)
			if inst.stafffx then
                inst.stafffx:Remove()
            end
        end,

        timeline = 
        {
            TimeEvent(17*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("soundpack/spell/bigspell") -- Add Custom Sound
            end),
			TimeEvent(0*FRAMES, function(inst)
                inst.stafflight = SpawnPrefab("staff_castinglight")
                local pos = inst:GetPosition()
                local colour = {95/255,0,1}
                inst.stafflight.Transform:SetPosition(pos.x, pos.y, pos.z)
                inst.stafflight.setupfn(inst.stafflight, colour, 1.9, .33)                

            end),
			TimeEvent(53*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("soundpack/spell/border")
				inst:PerformBufferedAction() 
			end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle") 
            end ),
        },
    }
	
	Stategraph.states["casttohoh"] = state

end)

local LAMENT = Action({-1, false, true}) -- Heavy motion
LAMENT.id = "LAMENT"
LAMENT.str = "waiting"
LAMENT.fn = function(act)
	local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

	if staff and staff.components.spellcard and staff.components.spellcard:CanCast(act.doer, act.target, act.pos) then
		staff.components.spellcard:CastSpell(act.target, act.pos)
		return true
	end
end

AddStategraphPostInit("wilson", function(Stategraph)

	local state = State {
        name = "lament",
        tags = {"doing", "busy", "canrotate"},

        onenter = function(inst)
            inst.components.playercontroller:Enable(false)
			inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("staff") 
            inst.components.locomotor:Stop()
            inst.stafffx = SpawnPrefab("staffcastfx")  
			--Spawn an effect on the player's location
			local pos = inst:GetPosition()
            inst.stafffx.Transform:SetPosition(pos.x, pos.y, pos.z)
            inst.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.stafffx.AnimState:SetMultColour(95/255, 0, 1, 1)
        end,
		
		onexit = function(inst)
            inst.components.playercontroller:Enable(true)
			inst.components.health:SetInvincible(false)
			if inst.stafffx then
                inst.stafffx:Remove()
            end
        end,

        timeline = 
        {
            TimeEvent(17*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("soundpack/spell/bigspell") -- Add Custom Sound
            end),
			TimeEvent(0*FRAMES, function(inst)
                inst.stafflight = SpawnPrefab("staff_castinglight")
                local pos = inst:GetPosition()
                local colour = {95/255,0,1}
                inst.stafflight.Transform:SetPosition(pos.x, pos.y, pos.z)
                inst.stafflight.setupfn(inst.stafflight, colour, 1.9, .33)                

            end),
			TimeEvent(53*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("soundpack/spell/border")
				inst:PerformBufferedAction() 
			end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle") 
            end ),
        },
    }
	
	Stategraph.states["lament"] = state

end)

if Language == "chinese" then
UTELEPORT.str = "传 送"
SPAWNG.str = "生 成"
CASTTOHO.str = "施 法"
CASTTOHOL.str = "施 法"
CASTTOHOH.str = "施 法"
LAMENT.str = "等 待"
end