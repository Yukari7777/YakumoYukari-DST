local Badge = require "widgets/badge"
local Text = require "widgets/text"

local function GetModName(modname) -- modinfo's modname and internal modname is different.
	for _, knownmodname in ipairs(KnownModIndex:GetModsToLoad()) do
		if KnownModIndex:GetModInfo(knownmodname).name == modname  then
			return knownmodname
		end
	end
end

local function GetModOptionValue(knownmodname, known_option_name)
	local modinfo = KnownModIndex:GetModInfo(knownmodname)
	for _,option in pairs(modinfo.configuration_options) do
		if option.name == known_option_name then
			return option.saved
		end
	end
end

local yokaibadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "health", owner)
	self.anim:GetAnimState():SetBuild("ypower")
	self.owner = owner

    self:SetPosition(0,-105,0)

	self.combinedmod = GetModName("Combined Status")

	if self.combinedmod ~= nil then
		self.showmaxonnumbers = GetModOptionValue(self.combinedmod, "SHOWMAXONNUMBERS")

		self.bg = self:AddChild(Image("images/status_bgs.xml", "status_bgs.tex"))
		self.bg:SetScale(.4,.43,0)
		self.bg:SetPosition(-.5, -40, 0)
		
		self.num:SetFont(NUMBERFONT)
		self.num:SetSize(28)
		self.num:SetPosition(3.5, -40.5, 0)
		self.num:SetScale(1,.78,1)

		self.num:MoveToFront()
		self.num:Show()

		self.maxnum = self:AddChild(Text(NUMBERFONT, self.showmaxonnumbers and 25 or 33))
		self.maxnum:SetPosition(6, 0, 0)
		self.maxnum:MoveToFront()
		self.maxnum:Hide()
	end

	self:StartUpdating()
end)

function yokaibadge:OnGainFocus()
	Badge._base:OnGainFocus(self)
	if self.combinedmod ~= nil then
		self.maxnum:Show()
	else
		self.num:Show()
	end
end
	
function yokaibadge:OnLoseFocus()
	Badge._base:OnLoseFocus(self)
	if self.combinedmod ~= nil then
		self.maxnum:Hide()
		self.num:Show()
	else
		self.num:Hide()
	end
end

function yokaibadge:OnUpdate(dt)
	if self.owner ~= nil and self.owner.replica.power ~= nil then
		self.num:SetString(tostring(math.floor(self.owner.replica.power:GetCurrent())))
		if self.combinedmod ~= nil then
			local maxtxt = self.showmaxonnumbers and "Max:\n" or ""

			self.maxnum:SetString(maxtxt..tostring(math.floor( self.owner.replica.power:Max() )))
		end
		self:SetPercent(self.owner.replica.power:GetPercent(), self.owner.replica.power:Max())
	end
end

return yokaibadge