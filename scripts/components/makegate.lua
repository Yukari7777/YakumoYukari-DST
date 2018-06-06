local MakeGate = Class(function(self, inst)
    self.inst = inst
	self.onusefn = nil
    self.distance_controller = 13 
end)

function MakeGate:GetBlinkPoint()
	--For use with controller.
	local owner = self.inst.components.inventoryitem.owner
	if not owner then return end
	local pt = nil
	local rotation = owner.Transform:GetRotation()*DEGREES
	local pos = owner:GetPosition()

	for r = self.distance_controller, 1, -1 do
        local numtries = 2*PI*r
		pt = FindWalkableOffset(pos, rotation, r, numtries)
		if pt then
			return pt + pos
		end
	end
end

function MakeGate:CanMakeToPoint(pt)
	return TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) and not TheWorld.Map:IsGroundTargetBlocked(pt)
end

function MakeGate:SpawnEffect(inst)
	local pt = inst:GetPosition()
	local fx = SpawnPrefab("small_puff")
	fx.Transform:SetPosition(pt.x, pt.y, pt.z)
end

function MakeGate:Teleport(pt, caster)

	--if self:CanMakeToPoint(pt) == false then
	--	return false
	--end
	if caster.components.power and caster.components.power.current > 15 then
		if self.onusefn == nil then
			return false
		end
	else
		return false
	end
	self:SpawnEffect(caster)
	caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
	caster:Hide()
	caster:DoTaskInTime(0.3, function() 
		self:SpawnEffect(caster)
		caster.Transform:SetPosition(pt.x, pt.y, pt.z)
		caster:Show()
	end)
	
	self.onusefn(self.inst, pt, caster)
	
	return true
end

function MakeGate:RCreate(pt, caster)

	if self:CanMakeToPoint(pt) == false then
		return false
	end
	if caster.components.power and caster.components.power.current >= 50 then
		if self.onusefn == nil then
			return false
		end
	else
		return false
	end

	caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
	if caster.components.health then
		caster.components.health:SetInvincible(true)
	end
	caster:DoTaskInTime(0.5, function() 
		if caster.components.health then
			caster.components.health:SetInvincible(false)
		end
		local scheme = SpawnPrefab("tunnel")
		scheme.Transform:SetPosition(pt.x, pt.y, pt.z)
		TheWorld.components.scheme_manager:InitGate(scheme)
	end)
	
	self.onusefn(self.inst, pt, caster)
	
	return true
end

return MakeGate