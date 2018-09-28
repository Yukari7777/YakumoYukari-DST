local Spellcard = Class(function(self, inst)
	self.inst = inst
	self.onfinish = nil
	self.othercondition = nil
	
	self.duration = nil
	self.costpower = nil
	self.index = nil
	self.name = nil
	self.level = nil
	self.maxlevel = nil
	
	self.isusableitem = true
	self.isdangeritem = false
	self.tick = 0
	
	self.action = ACTIONS.CASTTOHO
end)

function Spellcard:SetSpellFn(fn)
	self.spell = fn
end

function Spellcard:SetOnFinish(fn)
	self.onfinish = fn
end

function Spellcard:SetCondition(fn)
	self.othercondition = fn
end

function Spellcard:GetLevel(inst, index)
	if index == 1 then
		return inst.components.upgrader.health_level
	elseif index == 2 then
		return inst.components.upgrader.hunger_level
	elseif index == 3 then
		return inst.components.upgrader.sanity_level
	elseif index == 4 then
		return inst.components.upgrader.power_level
	end
end

function Spellcard:CastSpell(doer, target)
	if self.spell then
		self.spell(self.inst, doer, target)
		
		if self.onfinish then
			self.onfinish(self.inst, doer)
		end
	end
end

function Spellcard:AddDesc(script)
	if self.inst.components.inspectable ~= nil then 
		local desc = self.inst.components.inspectable:GetDescription(self.inst.components.inventoryitem.owner)
		if not string.find(desc, script) then
			self.inst.components.inspectable:SetDescription( desc.."\n"..script )
		end
	end
end

function Spellcard:CanCast(doer)
	
	if doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then
		self:AddDesc(STRINGS.YUKARI_SHOULD_BRING_SOMETHING)
		return false
	end
	
	if self.costpower then
		if doer.components.power:GetCurrent() < self.costpower then
			self:AddDesc(STRINGS.YUKARI_NEED_POWER)
			return false
		end
	end

	if self.othercondition ~= nil then
		return self.othercondition
	end
	
	return self.spell ~= nil

end

return Spellcard