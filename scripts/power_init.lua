local require = GLOBAL.require
local TUNING = GLOBAL.TUNING
local KnownModIndex = GLOBAL.KnownModIndex

AddReplicableComponent("power")

table.insert(Assets, Asset("ANIM", "anim/power.zip"))

local function IsModEnabled(modname)
	for k, v in ipairs(KnownModIndex:GetModsToLoad()) do
		if KnownModIndex:GetModInfo(v).name == modname  then
			return true
		end
	end
	return false
end

local function StatusDisplaysInit(class)

	if class.owner.prefab == "yakumoyukari" then
		local YokaiBadge = require "widgets/yokaibadge"

		class.power = class:AddChild(YokaiBadge(nil, class.owner))
		if IsModEnabled("Combined Status") then
			class.brain:SetPosition(0, 35, 0)
			class.stomach:SetPosition(-62, 35, 0)
			class.heart:SetPosition(62, 35, 0)
			class.power:SetScale(.9,.9,.9)
			class.power:SetPosition(-62, -50, 0)
		else
			class.power:SetPosition(-40, -50,0)
			class.brain:SetPosition(40, -50, 0)
			class.stomach:SetPosition(-40,17,0)
		end
			
		class.inst:ListenForEvent("powerdelta", function(inst, data) 
			class.power:SetPercent(data.newpercent, class.owner.replica.power:Max())
		end, class.owner)
	end

			
	
end

AddClassPostConstruct("widgets/statusdisplays", StatusDisplaysInit)
