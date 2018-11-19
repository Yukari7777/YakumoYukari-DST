local Upgrader = Class(function(self, inst)
    self.inst = inst

	self.health_level = 0
	self.hunger_level = 0
	self.sanity_level = 0
	self.power_level = 0
	self.hatlevel = 1

	self.healthbonus = 0
	self.hungerbonus = 0
	self.sanitybonus = 0
	self.powerbonus = 0
	self.powergenbonus = 0
	self.bonusspeed = 0
	self.hatbonusspeed = 0
	
	self.resisttemp = 1
	self.powerupvalue = 0
	self.regenamount = 0
	self.regencool = 1
	self.curecool = 1
	self.dodgechance = 0.2
	self.hatdodgechance = 0
	self.ResistDark = 0

	self.emergency = nil
	
	self.hatequipped = false
	self.fireimmuned = false
	self.nohealthpenalty = false
	self.IsDamage = false
	self.IsVampire = false
	self.IsAOE = false
	self.IsEfficient = false
	self.IsFight = false
	self.InvincibleLearned = false
	self.CanbeInvincibled = false
	self.WaterProofer = false
	self.FireResist = false
	self.GodTeleport = false
	
	self.ability = {}
	self.skillsort = 4
	self.skilllevel = 6
	for i = 1, self.skillsort, 1 do
		self.ability[i] = {}
		for j = 1, self.skilllevel, 1 do
			self.ability[i][j] = false
		end
	end -- This is a table that stores skills.
	
	self.hatskill = {}
	for i = 1, 5, 1 do
		self.hatskill[i] = false
	end
	
end)

function Upgrader:AbilityManager(inst)

	local ability = self.ability
	local hatskill = self.hatskill
	local level = {self.health_level, self.hunger_level, self.sanity_level, self.power_level}
	local point = {5, 10, 17, 25}

	for i = 1, 4, 1 do
		for j = 1, 4, 1 do
			if not ability[i][j] and level[i] >= point[j] then
				ability[i][j] = true
			end
		end
	end

	for i = 1, self.hatlevel, 1 do
		hatskill[i] = true
	end
	
	self:SkillManager(inst)
	self:HatSkillManager(inst)
end

function Upgrader:SkillManager(inst)

	local skill = self.ability
	
	if skill[1][1] then
		self.healthbonus = 10
		-- TUNING.HEALING_TINY = 2
	    -- TUNING.HEALING_SMALL = 5
	    -- TUNING.HEALING_MEDSMALL = 12
	    -- TUNING.HEALING_MED = 30
	    -- TUNING.HEALING_MEDLARGE = 35
	    -- TUNING.HEALING_LARGE = 50
	    -- TUNING.HEALING_HUGE = 75
	    -- TUNING.HEALING_SUPERHUGE = 300
	end
	
	if skill[1][2] then
		self.healthbonus = 30
		self.regenamount = 1
		self.regencool = 60
	end
	
	if skill[1][3] then
		self.healthbonus = 50
		self.regenamount = 2
		self.regencool = 60
		self.curecool = 180
	end
	
	if skill[1][4] then
		self.nohealthpenalty = true
		self.healthbonus = 95
		self.regenamount = 2
		self.regencool = 30
		self.curecool = 120
	end
	
	if skill[1][5] then	
		self.InvincibleLearned = true
		self.regenamount = 4
		self.regencool = 30
		self.curecool = 80
	end
	
	if skill[1][6] then
		self.IsVampire = true  
	end
	
	if skill[2][1] then
		self.hungerbonus = 25
		self.powerupvalue = 1
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_TINY
		inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_TINY
	end
	
	if skill[2][2] then
		self.hungerbonus = 50
		self.powerupvalue = 2
		inst.components.eater.strongstomach = true
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
		inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_SMALL
	end
	
	if skill[2][3] then
		self.hungerbonus = 75
		self.powerupvalue = 3
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
		inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED
	end
	
	if skill[2][4] then
		self.hungerbonus = 100
		self.powerupvalue = 4
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_LARGE
		inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE
	end
	
	if skill[2][5] then
		self.IsDamage = true
		self.powerupvalue = 5
	end	
	
	if skill[2][6] then
		self.IsAOE = true
	end
	
	if skill[3][1] then	
		inst.components.sanity.neg_aura_mult = 0.9
	end
	
	if skill[3][2] then
		self.ResistDark = 0.3
		self.sanitybonus = 25
		inst.components.sanity.neg_aura_mult = 0.8
	end
	
	if skill[3][3] then
		self.sanitybonus = 50
		self.ResistDark = 0.4	
		inst.components.sanity.neg_aura_mult = 0.7
	end
	
	if skill[3][4] then
		self.ResistDark = 0.5
		self.sanitybonus = 75	
		inst.components.sanity.neg_aura_mult = 0.6
	end
	
	if skill[3][5] then
		self.NightVision = true
	end	
	
	if skill[3][6] then
		self.IsFight = true
		inst.components.sanity.neg_aura_mult = 0.5
	end	
	
	if skill[4][1] then
		inst.components.moisture.baseDryingRate = 0.7
		self.powergenbonus = 0.1
	end
	
	if skill[4][2] then
		inst:RemoveTag("youkai")
		self.powerbonus = 25
		self.powergenbonus = 0.2
		self.bonusspeed = 1
		-- TUNING.NIGHTSWORD_USES = 140
		-- TUNING.ARMOR_SANITY = 1000
	    -- TUNING.ICESTAFF_USES = 25
	    -- TUNING.FIRESTAFF_USES = 25
	    -- TUNING.TELESTAFF_USES = 6
		-- TUNING.REDAMULET_USES = 25
		-- TUNING.YELLOWSTAFF_USES = 25
		-- TUNING.ORANGESTAFF_USES = 25
		-- TUNING.GREENAMULET_USES = 6
		-- TUNING.GREENSTAFF_USES = 6
		-- TUNING.PANFLUTE_USES = 12
		-- TUNING.HORN_USES = 12
	end
	
	if skill[4][3] then
		inst:AddTag("fastbuilder")
		inst:AddTag("realyoukai")
		self.powerbonus = 50
		self.bonusspeed = 2
		self.powergenbonus = 0.3
	end
	
	if skill[4][4] then
		inst.components.locomotor:SetTriggersCreep(false)
		inst:AddTag("spiderwhisperer")
		self.powerbonus = 75
		self.bonusspeed = 3
		self.powergenbonus = 0.5
	end
	
	if skill[4][5] then
		inst.components.combat:SetAttackPeriod(0)
        inst.components.combat:SetRange(3.2)
	end
	
	if skill[4][6] then
		self.IsEfficient = true
		self.bonusspeed = 4
	end
	
end

function Upgrader:SetFireDamageScale(inst)
	local fireimmunedbody = inst.valid
		  and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		  and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == ("armordragonfly" or "armorobsidian")
	if self.inst.components.health then
		self.inst.components.health.fire_damage_scale = (fireimmunedbody or self.FireResist) and 0 or 1
	end
end

function Upgrader:HatSkillManager(inst)

	local YukariHat = self.hatEquipped

	if YukariHat then
		local skill = self.hatskill
		
		if skill[2] then
			self.hatdodgechance = 0.1
		end
		
		if skill[3] then
			--YukariHat.components.waterproofer:SetEffectiveness(1)
			self.WaterProofer = true
			self.hatdodgechance = 0.2
		end
		
		if skill[4] then
			self.FireResist = true
			self.hatbonusspeed = 1
			self.hatdodgechance = 0.3
		end
		
		if skill[5] then
			self.dtmult = 2.5
			self.hatdodgechance = 0.4
			self.GodTeleport = true
		end
		
	else
		self.WaterProofer = false
		self.FireResist = false
		self.GodTeleport = false
		self.hatdodgechance = 0
	end
	self:SetFireDamageScale(inst)
end

function Upgrader:DoUpgrade(inst, stat)
	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()
	local power_percent = inst.components.power:GetPercent()
	local ignoresanity = inst.components.sanity.ignore
    inst.components.sanity.ignore = false

	local modname = KnownModIndex:GetModActualName("Yakumo Yukari")
	local difficulty = GetModConfigData("difficulty", modname)
	local STATUS = TUNING.STATUS_DEFAULT
	if difficulty == "easy" then
		STATUS = TUNING.STATUS_EASY
	elseif difficulty == "hard" then
		STATUS = TUNING.STATUS_HARD
	end
	
	if stat ~= nil then
		if stat == 1 then
			self.health_level = self.health_level + 1
			--inst.HUD.controls.status.heart:PulseGreen()
			--inst.HUD.controls.status.heart:ScaleTo(1.3,1,.7)
			inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_UPGRADE_HEALTH"))
		elseif stat == 2 then
			self.hunger_level = self.hunger_level + 1
			--inst.HUD.controls.status.stomach:PulseGreen()
			--inst.HUD.controls.status.stomach:ScaleTo(1.3,1,.7)
			inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_UPGRADE_HUNGER"))
		elseif stat == 3 then
			self.sanity_level = self.sanity_level + 1
			--inst.HUD.controls.status.brain:PulseGreen()
			--inst.HUD.controls.status.brain:ScaleTo(1.3,1,.7)
			inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_UPGRADE_SANITY"))
		elseif stat == 4 then
			self.power_level = self.power_level + 1
			--inst.HUD.controls.status.power:PulseGreen()
			--inst.HUD.controls.status.power:ScaleTo(1.3,1,.7)
			inst.components.talker:Say(GetString(inst.prefab, "DESCRIBE_UPGRADE_POWER"))	
		end	
	end

	inst.components.health.maxhealth = STATUS.DEFAULT_HP + self.health_level * STATUS.HP_RATE + self.healthbonus + math.max(0, (self.health_level - 30) * 7.5)
	inst.components.hunger.hungerrate = math.max( 0, (STATUS.DEFAULT_HR - self.hunger_level * STATUS.HR_RATE - math.max(0, (self.hunger_level - 30) * 0.025 )) ) * TUNING.WILSON_HUNGER_RATE 
	inst.components.hunger.max = STATUS.DEFAULT_HU + self.hungerbonus
	inst.components.sanity.max = STATUS.DEFAULT_SN + self.sanity_level * STATUS.SN_RATE + self.sanitybonus + math.max(0, (self.sanity_level - 30) * 5)
	inst.components.power.max = STATUS.DEFAULT_PW + self.power_level * STATUS.PO_RATE + self.powerbonus + math.max(0, (self.power_level - 30) * 5)
	inst.components.power.regenrate = STATUS.DEFAULT_PR + self.power_level * STATUS.PR_RATE + self.powergenbonus
	inst.components.locomotor.walkspeed = 4 + self.bonusspeed + self.hatbonusspeed
	inst.components.locomotor.runspeed = 6 + self.bonusspeed + self.hatbonusspeed
	
	
	self:AbilityManager(inst)
	inst.components.health:SetPercent(health_percent)
	inst.components.hunger:SetPercent(hunger_percent)
	inst.components.sanity:SetPercent(sanity_percent)
	inst.components.power:SetPercent(power_percent)
	inst.components.sanity.ignore = ignoresanity
end

return Upgrader