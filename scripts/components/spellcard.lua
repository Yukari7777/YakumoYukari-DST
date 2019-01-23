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
	self.donespeech = nil

	self.saydonespeech = false
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

function Spellcard:SetDoneSpeech(key)
	self.donespeech = GetString(self.inst.prefab, key)
	self.saydonespeech = true
end

function Spellcard:SetOnRemoveTask(fn)
	self.onremovetask = fn
end

function Spellcard:ClearTask(doer)
	if self.saydonespeech then
		doer.components.talker:Say(self.donespeech or GetString(doer.prefab, "DESCRIBE_DONEEFFCT"))
	end
	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end
	if self.onremovetask ~= nil then
		self.onremovetask(self.inst, doer)
	end
end

function Spellcard:CastSpell(doer, target)
	local doer = doer.components.inventoryitem ~= nil and doer.components.inventoryitem:GetGrandOwner() or doer
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
			if not inst.components.inventoryitem:IsHeld() or islow and doer.components.talker ~= nil then
				doer.components.talker:Say(GetString(doer.prefab, islow and "DESCRIBE_LOWPOWER" or "DESCRIBE_DONEEFFCT"))
				return self:ClearTask(doer)
			end
			self.taskfn(inst, doer)
		end)
	end

	if self.onfinish ~= nil then
		self:ClearTask(doer)
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