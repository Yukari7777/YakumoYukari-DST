local idir = "images/stat_screens/"
local Widget = require "widgets/widget"

local StatusBar = Class(Widget, function(self)
	Widget._ctor(self, "StatusBadge")
	self.owner = owner
	self:SetScale(1,1,1)

	self.bg = self:AddChild(Image(idir.."bar.xml", "bar.tex"))
	self.bg:SetClickable(false)
	self.bg:MoveToBack()
	
	self.bar = self:AddChild(Image(idir.."whitebar.xml", "whitebar.tex"))
	self.bar:SetClickable(false)
	
	self.text = self:AddChild(Text(BODYTEXTFONT, 33))
	self.text:SetHAlign(ANCHOR_MIDDLE)
	self.text:SetClickable(false)
	self.text:MoveToFront() 
end)

function StatusBar:OnUpdate(dt)
	self.text:SetString(tostring())
end

return StatusBar
