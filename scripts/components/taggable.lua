local writeables = require"taggables"

local function gettext(inst, viewer)
    local text = inst.components.taggable:GetText()
    return text and string.format('"%s"', text) or GetDescription(viewer, inst, "UNWRITTEN")
end

local function onbuilt(inst, data)
    inst.components.taggable:BeginWriting(data.spawner)
end

--V2C: NOTE: do not add "writeable" tag to pristine state because it is more
--           likely for players to encounter signs that are already written.
local function ontextchange(self, text)
    if text ~= nil then
        self.inst:RemoveTag("writeable")
        self.inst.AnimState:Show("WRITING")
    else
        self.inst:AddTag("writeable")
        self.inst.AnimState:Hide("WRITING")
    end
end

local function onwriter(self, writer)
    self.inst.replica.taggable:SetWriter(writer)
end

local Taggable = Class(function(self, inst)
    self.inst = inst
    self.text = nil

    self.writer = nil
    self.screen = nil

    self.onclosepopups = function(doer)
        if doer == self.writer then
            self:EndWriting()
        end
    end

    self.generatorfn = nil

    self.inst:ListenForEvent("tag", onbuilt)
end,
nil,
{
    text = ontextchange,
    writer = onwriter,
})


function Taggable:OnSave()
    local data = {}

    data.text = self.text
	if IsXB1() then
		data.netid = self.netid
	end

    return data

end

function Taggable:OnLoad(data)
	if IsRail() then
    	self.text = TheSim:ApplyWordFilter(data.text)
	else
    	self.text = data.text
	end
	if IsXB1() then
		self.netid = data.netid
	end
end

function Taggable:GetText(viewer)
	if IsXB1() then
		if self.text and self.netid then
			return "\1"..self.text.."\1"..self.netid
		end
	end
    return self.text
end

function Taggable:SetText(text)
    self.text = text
end

function Taggable:BeginWriting(doer)
    if self.writer == nil then
        self.inst:StartUpdatingComponent(self)

        self.writer = doer
        self.inst:ListenForEvent("ms_closepopups", self.onclosepopups, doer)
        self.inst:ListenForEvent("onremove", self.onclosepopups, doer)

        if doer.HUD ~= nil then
            self.screen = writeables.makescreen(self.inst, doer)
        end
    end
end

function Taggable:IsWritten()
    return self.text ~= nil
end

function Taggable:IsBeingWritten()
    return self.writer ~= nil
end

function Taggable:Write(doer, text)
    --NOTE: text may be network data, so enforcing length is
    --      NOT redundant in order for rendering to be safe.
    if self.writer == doer and doer ~= nil and
        (text == nil or text:utf8len() <= MAX_WRITEABLE_LENGTH / 4) then
        if IsRail() then
			text = TheSim:ApplyWordFilter(text)
		end
        self:SetText(text)
        self:EndWriting()
    end
end

function Taggable:EndWriting()
    if self.writer ~= nil then
        self.inst:StopUpdatingComponent(self)

        if self.screen ~= nil then
            self.writer.HUD:CloseTaggableWidget()
            self.screen = nil
        end

        self.inst:RemoveEventCallback("ms_closepopups", self.onclosepopups, self.writer)
        self.inst:RemoveEventCallback("onremove", self.onclosepopups, self.writer)

		if IsXB1() then
			if self.writer:HasTag("player") and self.writer:GetDisplayName() then
				local ClientObjs = TheNet:GetClientTable()
				if ClientObjs ~= nil and #ClientObjs > 0 then
					for i, v in ipairs(ClientObjs) do
						if self.writer:GetDisplayName() == v.name then
							self.netid = v.netid
							break
						end
					end
				end
			end
		end

        self.writer = nil
    elseif self.screen ~= nil then
        --Should not have screen and no writer, but just in case...
        if self.screen.inst:IsValid() then
            self.screen:Kill()
        end
        self.screen = nil
    end
end

--------------------------------------------------------------------------
--Check for auto-closing conditions
--------------------------------------------------------------------------

function Taggable:OnUpdate(dt)
    if self.writer == nil then
        self.inst:StopUpdatingComponent(self)
    elseif (self.writer.components.rider ~= nil and
            self.writer.components.rider:IsRiding())
        or not (self.writer:IsNear(self.inst, 3) and
                CanEntitySeeTarget(self.writer, self.inst)) then
        self:EndWriting()
    end
end

--------------------------------------------------------------------------

function Taggable:OnRemoveFromEntity()
    self:EndWriting()
    self.inst:RemoveTag("writeable")
    self.inst:RemoveEventCallback("tag", onbuilt)
end

Taggable.OnRemoveEntity = Taggable.EndWriting

return Taggable
