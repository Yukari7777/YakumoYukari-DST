local spellcard = Class(function(self, inst)
	self.inst = inst
	self.spell = nil
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

function spellcard:SetSpellFn(fn)
	self.spell = fn
end

function spellcard:SetOnFinish(fn)
	self.onfinish = fn
end

function spellcard:SetCondition(fn)
	self.othercondition = fn
end

function spellcard:SetAction(act)
	self.action = act
end

function spellcard:GetLevel(inst, index)
	if index == 1 then
		return inst.health_level
	elseif index == 2 then
		return inst.hunger_level
	elseif index == 3 then
		return inst.sanity_level
	elseif index == 4 then
		return inst.power_level
	end
end

function spellcard:CastSpell(target)
	if self.spell then
		self.spell(self.inst, target)
		
		if self.onfinish then
			self.onfinish(self.inst, target)
		end
	end
end

function spellcard:CanCast(doer)

	if doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then -- todo : use "read" motion in order to delete this.
		doer.components.talker:Say(STRINGS.YUKARI_SHOULD_BRING_SOMETHING)
		return false
	end
	
	if self.costpower then
		if --doer.components.power == nil or
		doer.components.power:GetCurrent() < self.costpower then
			doer.components.talker:Say(STRINGS.YUKARI_NEED_POWER)
			return false
		end
	end
	
	if self.othercondition ~= nil then
		return self.othercondition
	end
	
	return self.spell ~= nil

end

return spellcard