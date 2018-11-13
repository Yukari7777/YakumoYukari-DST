local scheme = Class(function(self, inst)
    self.inst = inst
	self.index = nil
	self.owner = nil
	self.pointer = nil
end)

function scheme:OnActivate(other, doer) 
	other.sg:GoToState("open")
	other:DoTaskInTime(1.5, function()
		if other.components.scheme.pointer == nil then
			other.sg:GoToState("closing")
		end
	end)
end

function scheme:Activate(doer)
	if not self:IsConnected() then
		return
	end

	if doer:HasTag("player") then
		doer.SoundEmitter:KillSound("wormhole_travel")
	end

	self:OnActivate(self:GetTarget(self.pointer), doer)
	self:Teleport(doer)

	if doer.components.leader then
		for follower,v in pairs(doer.components.leader.followers) do
			self:Teleport(follower)
		end
	end

	local eyebone = nil

	--special case for the chester_eyebone: look for inventory items with followers
	if doer.components.inventory then
		for k,item in pairs(doer.components.inventory.itemslots) do
			if item.components.leader then
				if item:HasTag("chester_eyebone") then
					eyebone = item
				end
				for follower,v in pairs(item.components.leader.followers) do
					self:Teleport(follower)
				end
			end
		end
		-- special special case, look inside equipped containers
		for k,equipped in pairs(doer.components.inventory.equipslots) do
			if equipped and equipped.components.container then
				local container = equipped.components.container
				for j,item in pairs(container.slots) do
					if item.components.leader then
						if item:HasTag("chester_eyebone") then
							eyebone = item
						end
						for follower,v in pairs(item.components.leader.followers) do
							self:Teleport(follower)
						end
					end
				end
			end
		end
		-- special special special case: if we have an eyebone, then we have a container follower not actually in the inventory. Look for inventory items with followers there.
		if eyebone and eyebone.components.leader then
			for follower,v in pairs(eyebone.components.leader.followers) do
				if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) and follower.components.container then
					for j,item in pairs(follower.components.container.slots) do
						if item.components.leader then
							for follower,v in pairs(item.components.leader.followers) do
								if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) then
									self:Teleport(follower)
								end
							end
						end
					end
				end
			end
		end
	end
end

function scheme:Teleport(obj)
	if self.pointer ~= nil then
		local target = self:GetTarget(self.pointer)
		local offset = 2.0
		local angle = math.random() * 360
		local target_x, target_y, target_z = target.Transform:GetWorldPosition()
		target_x = target_x + math.sin(angle)*offset
		target_z = target_z + math.cos(angle)*offset
		if obj.Physics then
			obj.Physics:Teleport( target_x, target_y, target_z )
		elseif obj.Transform then
			obj.Transform:SetPosition( target_x, target_y, target_z )
		end
		if obj.components.talker ~= nil then
            obj.components.talker:ShutUp()
        end
	end
end

function scheme:GetTarget(pointer)
	return _G.TUNNELNETWORK[pointer].inst
end

function scheme:IsConnected()
	return self.pointer ~= nil and self:GetTarget(self.pointer) ~= nil
end

function scheme:FindIndex()
	local index = 1
	while _G.TUNNELNETWORK[index] ~= nil do
		index = index + 1
	end
	return index
end

function scheme:Next(index) 
	-- for some reason in ordering index into TUNNELNETWORK, next function was not a good answer.
	-- because next returns a key inserted AFTER the table key inserted previously. 
	-- which is NOT in ascending order. (table[3]'s next could be table[2]) 
	if index ~= nil and index >= _G.TUNNELLASTINDEX then return _G.TUNNELFIRSTINDEX end

	local key = index ~= nil and index + 1 or 1
	while _G.TUNNELNETWORK[key] == nil do
		key = key + 1
		if key > 10000 then return end
	end

	return key
end

function scheme:keyfind(index, asc)
	local key = asc and index + 1 or index - 1
	while _G.TUNNELNETWORK[key] == nil do
		key = asc and key + 1 or key - 1
		if key > 10000 or key < 0 then return end
	end
	return key
end

function scheme:GetIndex()
	return self.index
end

function scheme:Target(pointer)
	self.pointer = pointer
	self.inst.islinked:set(true)
end

function scheme:AddToNetwork()
	local index = self.index ~= nil and self.index or self:FindIndex()

	_G.TUNNELNETWORK[index] = {
		inst = self.inst,
		owner = self.inst.owner,
	}
	_G.TUNNELFIRSTINDEX = (_G.TUNNELFIRSTINDEX == nil or _G.TUNNELFIRSTINDEX > index) and index or _G.TUNNELFIRSTINDEX
	_G.TUNNELLASTINDEX = (_G.TUNNELLASTINDEX == nil or _G.TUNNELLASTINDEX < index) and index or _G.TUNNELLASTINDEX
	_G.NUMTUNNEL = _G.NUMTUNNEL + 1
	self.index = index
end

function scheme:Disconnect(index)
	for k, v in pairs(_G.TUNNELNETWORK) do
		if v.inst.components.scheme and v.inst.components.scheme.pointer == index then
			v.inst.components.scheme.pointer = nil
			v.inst.islinked:set(false)
			if v.inst.sg.currentstate.name == ("open" or "opening") then
				v.inst.sg:GoToState("closing")
			end
		end
	end
	self.index = nil
	self.pointer = nil
	self.inst.islinked:set(false)
	self.inst.sg:GoToState("closing")
	_G.TUNNELFIRSTINDEX = _G.TUNNELFIRSTINDEX == index and self:keyfind(index, true) or _G.TUNNELFIRSTINDEX
	_G.TUNNELLASTINDEX = _G.TUNNELLASTINDEX == index and self:keyfind(index, false) or _G.TUNNELLASTINDEX
	_G.TUNNELNETWORK[index] = nil
	_G.NUMTUNNEL = _G.NUMTUNNEL - 1
end

function scheme:Connect()
	if _G.NUMTUNNEL == 1 then return end

	local pointer = self:Next(self.pointer)
	if pointer == self.index then pointer = self:Next(pointer) end

	self:Target(pointer)
end

function scheme:InitGate()
	self:AddToNetwork()
	if self.pointer ~= nil then
		self:Target(self.pointer)
	end
end

return scheme