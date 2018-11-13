local SignGenerator = require"signgenerator"
local PlayerHud = require"screens/playerhud"
local TaggableWidget = require"widgets/taggablewidget"

local writeables = {}

function PlayerHud:ShowTaggableWidget(writeable, config)
    if writeable == nil then
        return
    else
        self.taggablescreen = TaggableWidget(self.owner, writeable, config)
        self:OpenScreenUnderPause(self.taggablescreen)
        if TheFrontEnd:GetActiveScreen() == self.taggablescreen then
            -- Have to set editing AFTER pushscreen finishes.
            self.taggablescreen.edit_text:SetEditing(true)
        end
        return self.taggablescreen
    end
end

function PlayerHud:CloseTaggableWidget()
    if self.taggablescreen then
        self.taggablescreen:Close()
        self.taggablescreen = nil
    end
end

writeables.makescreen = function(inst, doer)
    local data = {
		prompt = STRINGS.SIGNS.MENU.PROMPT,
		animbank = "ui_board_5x1",
		animbuild = "ui_board_5x1",
		menuoffset = Vector3(6, 20, 0),

		cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
		middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
				widget:OverrideText( SignGenerator(inst, doer) )
			end, control = CONTROL_MENU_MISC_2 },
		acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },

		--defaulttext = SignGenerator,
	}

    if doer and doer.HUD then
        return doer.HUD:ShowTaggableWidget(inst, data)
    end
end

return writeables
