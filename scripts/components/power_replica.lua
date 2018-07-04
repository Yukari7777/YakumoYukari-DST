local Power = Class(function(self, inst)
    self.inst = inst
end)

function Power:SetMaxPower(max)
	self.inst.maxpower:set(max)
end

function Power:SetCurrent(current)
	self.inst.currentpower:set(current)
end

function Power:Max()
    if self.inst.components.power ~= nil then
        return self.inst.components.power.max
    elseif self.inst.maxpower ~= nil then
        return self.inst.maxpower:value()
    else
        return 75
    end
end

function Power:GetCurrent()
    if self.inst.components.power ~= nil then
        return self.inst.components.power.current
    elseif self.inst.currentpower ~= nil then
        return self.inst.currentpower:value()
    else
        return 50
    end
end

function Power:GetPercent()
    if self.inst.components.power ~= nil then
        return self.inst.components.power:GetPercent()
    end
    return self:GetPercentNetworked()
end

function Power:GetPercentNetworked()
    --Use networked value whether we are server or client
    return self.inst.maxpower ~= nil and  self.inst.currentpower ~= nil and self.inst.currentpower:value() / self.inst.maxpower:value() or 1
end

function Power:SetRateScale(ratescale)
    if self.classified ~= nil then
        self.classified.powerratescale:set(ratescale)
    end
end

function Power:GetRateScale()
    if self.inst.components.power ~= nil then
        return self.inst.components.power:GetRateScale()
    elseif self.classified ~= nil then
        return self.classified.powerratescale:value()
    else
        return RATE_SCALE.NEUTRAL
    end
end

return Power