local function onmax(self, max)
    self.inst.replica.power:SetMaxPower(max)
end

local function oncurrent(self, current)
    self.inst.replica.power:SetCurrent(current)
end

local function onratescale(self, ratescale)
    self.inst.replica.power:SetRateScale(ratescale)
end

local Power = Class(function(self, inst)
    self.inst = inst
    self.max = 75
    self.current = 50

    self.regenrate = 1/10
	
    self.period = 1
	
	self.task = self.inst:DoPeriodicTask(self.period, function() self:DoDec(self.period) end)
	self.inst:ListenForEvent("respawn", function(inst) self:OnRespawn() end)
	
end, nil, {
	max = onmax,
    current = oncurrent,
    --ratescale = onratescale,
})

function Power:OnRespawn()
	self.current = 75
end

function Power:OnSave()
	return {power = self.current}
end

function Power:OnLoad(data)
    if data.power then
        self.current = data.power
        self:DoDelta(0)
    end
end

function Power:LongUpdate(dt)
	self:DoDec(dt, true)
end

function Power:GetDebugString()
    return string.format("%2.2f / %2.2f", self.current, self.max)
end

function Power:SetMax(amount)
    self.max = amount
    self.current = amount
end

function Power:DoDelta(delta, overtime)
	
    local old = self.current
	self.current = self.current + delta
    if self.current < 0 then 
        self.current = 0
    elseif self.current > self.max then
        self.current = self.max
    end
	
    self.inst:PushEvent("powerdelta", {oldpercent = old/self.max, newpercent = self.current/self.max, overtime = overtime})
    
end

function Power:GetPercent()
    return self.current / self.max
end

function Power:GetCurrent()
	return self.current
end

function Power:SetPercent(p)
    local old = self.current
    self.current = p*self.max
    self.inst:PushEvent("powerdelta", {oldpercent = old/self.max, newpercent = p})
end

function Power:DoDec(dt, ignore_damage)
	if  self.inst.components.upgrader.hatequipped then	
		self.inst.components.power:DoDelta(self.regenrate * dt)
	end
end

return Power
