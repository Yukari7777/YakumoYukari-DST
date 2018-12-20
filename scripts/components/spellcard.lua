local Spellcard = Class(function(self, inst)
	self.inst = inst
	self.othercondition = nil
	self.spell = nil
	self.onfinish = nil
	
	self.duration = nil
	self.costpower = nil
	self.index = nil
	self.name = nil
	self.level = nil
	self.maxlevel = nil
	self.task = nil
	self.taskfn = nil
	self.taskinterval = nil
	self.onremovetask = nil
	
	self.isdangeritem = false
	self.tick = 0
	
	self.action = ACTIONS.CASTTOHO
end)

function Spellcard:SetSpellFn(fn)
	self.spell = fn
end

function Spellcard:SetCondition(fn)
	self.othercondition = fn
end

function Spellcard:SetOnFinish(fn)
	self.onfinish = fn
end

function Spellcard:SetTaskFn(fn, interval)
	self.taskfn = fn
	self.taskinterval = interval
end

function Spellcard:SetOnRemoveTask(fn)
	self.onremovetask = fn
end

function Spellcard:ClearTask(doer)
	self.task:Cancel()
	self.task = nil
	if self.onremovetask ~= nil then
		self.onremovetask(self.inst, doer)
	end
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
	local inst = self.inst

	if self.task ~= nil then
		return self:ClearTask(doer)
	end

	if self.spell ~= nil then
		self.spell(inst, doer, target)
	end

	if self.taskfn ~= nil then
		self.task = doer.DoPeriodicTask(doer, self.taskinterval or 1, function()
			local islow = doer.components.power.current < self.costpower
			if not inst.components.inventoryitem:IsHeld() or islow then
				doer.components.talker:Say(GetString(doer.prefab, islow and "DESCRIBE_LOWPOWER" or "DESCRIBE_DONEEFFCT"))
				return self:ClearTask(doer)
			end
			self.taskfn(inst, doer)
		end)
	end

	if self.onfinish ~= nil then
		self.onfinish(inst, doer)
	end
end

function Spellcard:CanCast(doer)
	if self.costpower ~= nil then
		if doer.components.power:GetCurrent() < self.costpower then
			return doer.components.talker:Say(GetString(doer.prefab, "DESCRIBE_LOWPOWER"))
		end
	end

	if self.othercondition ~= nil then
		return self.othercondition
	end
	
	return self.spell ~= nil

end

return Spellcard