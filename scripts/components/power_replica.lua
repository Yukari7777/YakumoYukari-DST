local Power = Class(function(self, inst)
    self.inst = inst

	print("power replica", inst.yukari_classified, inst.player_classified)

	if TheWorld.ismastersim then
        self.classified = inst.yukari_classified
    elseif self.classified == nil and inst.yukari_classified ~= nil then
        self:AttachClassified(inst.yukari_classified)
    end
end)

--------------------------------------------------------------------------

function Power:OnRemoveFromEntity()
    if self.classified ~= nil then
        if TheWorld.ismastersim then
            self.classified = nil
        else
            self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
            self:DetachClassified()
        end
    end
end

Power.OnRemoveEntity = Power.OnRemoveFromEntity

function Power:AttachClassified(classified)
	print("power attach classified", classified)
    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function Power:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
end

--------------------------------------------------------------------------

function Power:SetMaxPower(max)
	self.classified.maxpower:set(max)
end

function Power:SetCurrent(current)
	self.classified.currentpower:set(current)
end

function Power:Max()
    if self.inst.components.power ~= nil then
        return self.inst.components.power.max
    elseif self.classified ~= nil then
        return self.classified.maxpower:value()
    else
        return 75
    end
end

function Power:GetCurrent()
    if self.inst.components.power ~= nil then
        return self.inst.components.power.current
    elseif self.classified ~= nil then
        return self.classified.currentpower:value()
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
    return self.classified ~= nil and self.classified.maxpower ~= nil and  self.classified.currentpower ~= nil and self.classified.currentpower:value() / self.classified.maxpower:value() or 1
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