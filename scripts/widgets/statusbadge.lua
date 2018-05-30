local idir = "images/stat_screens/"
local Widget = require "widgets/widget"

local StatusBadge = Class(Widget, function(self, imagexml, imagetex, name)
	Widget._ctor(self, "StatusBadge")
	self:SetScale(1,1,1)

	self.text = self:AddChild(Text(BODYTEXTFONT, 33))
    self.text:SetPosition(5, 0, 0)
	self.text:SetString(name)
	self.text:SetClickable(false)
	self.text:MoveToFront() 
	
	self.icon = self:AddChild(Image(imagexml..".xml", imagetex..".tex"))
	self.icon:SetScale(1,1,1)

	self.bg = self:AddChild(Image(idir.."bar.xml", "bar.tex"))
	self.bg:SetClickable(false)
	self.bg:MoveToBack()
	
	self.bar = self:AddChild(Image(idir.."whitebar.xml", "whitebar.tex"))
	self.bar:SetClickable(false)
	
	self.bgtext = self:AddChild(Text(BODYTEXTFONT, 33))
	self.bgtext:SetHAlign(ANCHOR_MIDDLE)
	self.bgtext:SetClickable(false)
	self.bgtext:MoveToFront() 
end)

function StatusBadge:OnUpdate(dt)
	self.bgtext:SetString(tostring())
end

function StatusBadge:OnGainFocus()
	StatusBadge._base:OnGainFocus(self)
	self.text:Show()
end

function StatusBadge:OnLoseFocus()
	StatusBadge._base:OnLoseFocus(self)
	self.text:Hide()
end

return StatusBadge

--[[
HHSP 패널 각각 만들기
뒷배경 2개 만들기, 활성화 비활성화용 텍스트 
]]