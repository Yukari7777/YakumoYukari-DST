local UIAnim = require "widgets/uianim"
local Badge = require "widgets/badge"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local PlayerBadge = require "widgets/playerbadge"
--local GetModConfigData(, )
--
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

local yokaibadge = Class(Widget, function(self, anim, owner)
	Widget._ctor(self, "yokaibadge")

	self.owner = owner
	
	self.percent = 0
	self:SetScale(1, 1, 1)
    self:SetPosition(0,-105,0)

	self.combinedmod = GetModName("Combined Status")

	self.pulse = self:AddChild(UIAnim())
    self.pulse:GetAnimState():SetBank("pulse")
    self.pulse:GetAnimState():SetBuild("hunger_health_pulse")

    self.anim = self:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("health")
	self.anim:GetAnimState():SetBuild("sprint")
	self.anim:GetAnimState():PlayAnimation("anim")
	self.anim:SetClickable(true)
	
	self.underNumber = self:AddChild(Widget("undernumber"))

    self.num = self:AddChild(Text(BODYTEXTFONT, 33))
    self.num:SetHAlign(ANCHOR_MIDDLE)
    self.num:SetPosition(5, 0, 0)
	self.num:SetClickable(false)
    self.num:Hide()
	
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

function yokaibadge:PulseGreen()
    self.pulse:GetAnimState():SetMultColour(0.5,0.25,0.87,0.25)
	self.pulse:GetAnimState():PlayAnimation("pulse")
end

function yokaibadge:SetPercent(val, max)	
    val = val or self.percent
	
	self.current = self.owner.components.power and self.owner.components.power.current or self.owner.replica.power:GetCurrent()
	self.maxpower = max or self.owner.components.power.max or self.owner.replica.power:Max()
    self.anim:GetAnimState():SetPercent("anim", 1 - self.current/self.maxpower)
            
    self.percent = val
end

function yokaibadge:OnGainFocus()
	if self.combinedmod ~= nil then
		self.maxnum:Show()
	else
		yokaibadge._base:OnGainFocus(self)
		self.num:Show()
	end
end

function yokaibadge:OnLoseFocus()
	if self.combinedmod ~= nil then
		self.maxnum:Hide()
		self.num:Show()
	else
		yokaibadge._base:OnLoseFocus(self)
		self.num:Hide()
	end
end


function yokaibadge:OnUpdate(dt)
	if self.owner and self.owner.replica.power ~= nil then
		self.num:SetString(tostring(math.floor( self.owner.replica.power:GetCurrent() )))
		if self.combinedmod ~= nil then
			local maxtxt = self.showmaxonnumbers and "Max:\n" or ""

			self.maxnum:SetString(maxtxt..tostring(math.floor( self.owner.replica.power:Max() )))
		end
		self:SetPercent(self.owner.replica.power:GetCurrent(), self.owner.replica.power:Max())
	end
	
	if self.owner:HasTag("playerghost") then
		self:SetScale(0, 0, 0)
	else
		self:SetScale(1, 1, 1)
	end

end

return yokaibadge