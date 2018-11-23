local GrazeBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function GrazeBrain:SpreadOut()
    self.inst.components.locomotor:RunInDirection(math.random() * 360)
    self.inst.components.locomotor:RunForward(math.random() * 360)

end

function GrazeBrain:OnStart()
    local root = PriorityNode(
    {
        self:SpreadOut()
    }, .5)

    self.bt = BT(self.inst, root)
end

return GrazeBrain
