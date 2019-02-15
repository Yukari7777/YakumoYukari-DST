local require = GLOBAL.require
local KnownModIndex = GLOBAL.KnownModIndex

AddReplicableComponent("power")

local function IsModEnabled(modname)
	for k, v in ipairs(KnownModIndex:GetModsToLoad()) do
		if KnownModIndex:GetModInfo(v).name == modname  then
			return true
		end
	end
	return false
end

local function StatusDisplaysInit(self)
	if self.owner:HasTag("yakumoyukari") then
		local YokaiBadge = require "widgets/yokaibadge"

		self.power = self:AddChild(YokaiBadge(self.owner))
		if IsModEnabled("Combined Status") then
			self.brain:SetPosition(0, 35, 0)
			self.stomach:SetPosition(-62, 35, 0)
			self.heart:SetPosition(62, 35, 0)
			self.power:SetScale(.9,.9,.9)
			self.power:SetPosition(-62, -50, 0)
		else
			self.power:SetPosition(-40, -50,0)
			self.brain:SetPosition(40, -50, 0)
			self.stomach:SetPosition(-40,17,0)
		end
		
		self.inst:ListenForEvent("powerdelta", function(inst, data) self.power:SetPercent(data.newpercent, self.owner.replica.power:Max()) end, self.owner)
	end

	local _SetGhostMode = self.SetGhostMode
	function self:SetGhostMode(ghostmode)
		if not self.isghostmode == not ghostmode then --force boolean
			return
		end

		_SetGhostMode(self, ghostmode)
		if ghostmode then
			self.power:Hide()
		else
			self.power:Show()
		end
	end
end

AddClassPostConstruct("widgets/statusdisplays", StatusDisplaysInit)
