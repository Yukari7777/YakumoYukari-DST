require("stategraphs/commonstates")

local actionhandlers=
{
	
}

local events=
{

}

local states=
{
	State{
		name = "idle",
		tags = {"idle"},
		onenter = function(inst)
			inst.AnimState:PushAnimation("closed", true)
		end,
	},
	
	State{
		name = "open",
		tags = {"idle", "open"},
		onenter = function(inst)
			inst.AnimState:PlayAnimation("open", true)
		end,
	},

	State{
		name = "opening",
		tags = {"busy", "opening"},
		onenter = function(inst)
			inst.AnimState:PlayAnimation("opening")
			inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/open")
		end,

		events=
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("open")
			end),
		},
	},
		
	State{
		name = "closing",
		tags = {"busy"},
		onenter = function(inst)
			inst.AnimState:PlayAnimation("closing")
			inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/close")
		end,

		events=
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
}

return StateGraph("tunnel", states, events, "idle", actionhandlers)