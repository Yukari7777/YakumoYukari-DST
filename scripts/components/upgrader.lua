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
	self.bonusspeed = 0
	self.hatbonusspeed = 0
	
	self.powerupvalue = 0
	self.regenamount = 0
	self.regencool = 0
	self.curecool = 0
	self.hatdodgechance = 0
	self.ResistDark = 0
	self.hatabsorption = 0

	self.PowerGainMultiplier = 1
	self.dodgechance = 0.2
	self.skilltextpage = 3

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
	self.SpikeEater = false
	self.RotEater = false
	self.Ability_45 = false
	
	self.ability = {}
	self.skill = {}
	self.skillsort = 4
	self.skilllevel = 6
	for i = 1, self.skillsort, 1 do
		self.ability[i] = {}
		for j = 1, self.skilllevel, 1 do
			self.ability[i][j] = false
		end
	end
	
	self.hatskill = {}
	for i = 1, 5, 1 do
		self.hatskill[i] = false
	end
	
end)

function Upgrader:SetFireDamageScale()
	local shouldimmune = self.fireimmuned or (self.hatequipped and self.FireResist)
	if self.inst.components.health then
		self.inst.components.health.fire_damage_scale = shouldimmune and 0 or 1
	end
end

function Upgrader:AbilityManager()
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
	
	self:UpdateAbilityStatus()
end

function Upgrader:UpdateAbilityStatus()
	local ability = self.ability
	
	if ability[1][1] then
		self.healthbonus = 10
	end
	
	if ability[1][2] then
		self.healthbonus = 30
		self.regenamount = 1
		self.regencool = 60
	end
	
	if ability[1][3] then
		self.healthbonus = 50
		self.regenamount = 2
		self.regencool = 45
		self.curecool = 180
	end
	
	if ability[1][4] then
		self.nohealthpenalty = true
		self.healthbonus = 95
		self.regenamount = 2
		self.regencool = 30
		self.curecool = 120
	end
	
	if ability[1][5] then	
		self.InvincibleLearned = true
		self.regenamount = 4
		self.regencool = 15
		self.curecool = 60
	end
	
	if ability[1][6] then
		self.IsVampire = true  
	end
	
	if ability[2][1] then
		self.hungerbonus = 25
		self.powerupvalue = 1
		self.inst.components.temperature.inherentinsulation = TUNING.INSULATION_TINY
		self.inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_TINY
	end
	
	if ability[2][2] then
		self.hungerbonus = 50
		self.powerupvalue = 2
		self.inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
		self.inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_SMALL
	end
	
	if ability[2][3] then
		self.hungerbonus = 75
		self.powerupvalue = 3
		self.SpikeEater = true
		self.inst.components.eater.strongstomach = true
		self.inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
		self.inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED
	end
	
	if ability[2][4] then
		self.hungerbonus = 100
		self.powerupvalue = 4
		self.RotEater = true
		self.inst.components.eater.ignoresspoilage = true
		self.inst.components.temperature.inherentinsulation = TUNING.INSULATION_LARGE
		self.inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE
	end
	
	if ability[2][5] then
		self.IsDamage = true
		self.powerupvalue = 5
	end	
	
	if ability[2][6] then
		self.IsAOE = true
	end
	
	if ability[3][1] then	
		self.inst.components.sanity.neg_aura_mult = 0.9
	end
	
	if ability[3][2] then
		self.ResistDark = 0.2
		self.sanitybonus = 25
		self.inst.components.sanity.neg_aura_mult = 0.8
	end
	
	if ability[3][3] then
		self.sanitybonus = 50
		self.ResistDark = 0.3
		self.inst.components.sanity.neg_aura_mult = 0.7
	end
	
	if ability[3][4] then
		self.ResistDark = 0.5
		self.sanitybonus = 75	
		self.inst.components.sanity.neg_aura_mult = 0.6
	end
	
	if ability[3][5] then
		self.ResistDark = 0.8
		self.NightVision = true
	end	
	
	if ability[3][6] then
		self.dodgechance = 0.4
		self.inst.components.sanity.neg_aura_mult = 0.5
	end	
	
	if ability[4][1] then
		self.inst.components.moisture.baseDryingRate = 0.7
		self.PowerGainMultiplier = 1.5
	end
	
	if ability[4][2] then
		self.inst:RemoveTag("youkai")
		self.inst:AddTag("fastpicker")
		self.powerbonus = 25
		self.bonusspeed = 1
		self.PowerGainMultiplier = 2
	end
	
	if ability[4][3] then
		self.inst:AddTag("fastbuilder")
		self.inst:AddTag("realyoukai")
		self.powerbonus = 50
		self.bonusspeed = 2
		self.PowerGainMultiplier = 2.5
	end
	
	if ability[4][4] then
		self.inst.components.locomotor:SetTriggersCreep(false)
		self.inst:AddTag("spiderwhisperer")
		self.powerbonus = 75
		self.PowerGainMultiplier = 3
	end
	
	if ability[4][5] then
		self.Ability_45 = true
		self.inst.components.combat:SetAttackPeriod(0)
        self.inst.components.combat:SetRange(3.2)
	end
	
	if ability[4][6] then
		self.bonusspeed = 3
		self.IsEfficient = true
	end
end

function Upgrader:UpdateHatAbilityStatus(hat)	
	if self.hatequipped then
		local skill = self.hatskill
		
		if skill[2] then
			self.hatdodgechance = 0.1
			self.hatabsorption = 0.6
		end
		
		if skill[3] then
			hat.components.waterproofer:SetEffectiveness(1)
			self.WaterProofer = true
			self.hatdodgechance = 0.2
			self.hatabsorption = 0.8
		end
		
		if skill[4] then
			self.FireResist = true
			self.hatbonusspeed = 1
			self.hatdodgechance = 0.3
			self.hatabsorption = 0.9
		end
		
		if skill[5] then
			self.hatdodgechance = 0.4
			self.hatabsorption = 0.95
			self.GodTeleport = true
		end
		
		hat:SetAbsorbPercent(self.hatabsorption)
	else
		self.WaterProofer = false
		self.FireResist = false
		self.GodTeleport = false
		self.hatdodgechance = 0
	end
	
	self:SetFireDamageScale()
end

function Upgrader:UpdateSkillStatus()
	local skill = self.skill

	if self.powerupvalue ~= 0 then
		skill.dmgmult = "Damage multiplier : "..string.format("%.2f", self.inst.components.combat.damagemultiplier).." (max : "..TUNING.YDEFAULT.DAMAGE_MULTIPLIER + 0.2 * self.powerupvalue..")"
	end

	if self.ResistDark ~= 0 then
		skill.insulation = "Reduces sanity decrement from darkness by "..(self.ResistDark * 100).."%" 
	end	

	local winter, summer = self.inst.components.temperature:GetInsulation()
	if winter ~= 0 and summer ~= 0 then
		skill.insulation =  "Total insulation : "..summer.."(summer), "..winter.."(winter)"
	end

	if self.bonusspeed ~= 0 and self.hatbonusspeed ~= 0 then
		skill.speed = "Bonus Speed : "..self.bonusspeed + (self.hatequipped and self.hatbonusspeed)
	end	

	if self.PowerGainMultiplier ~= 1 then
		skill.powermult = "Gain more power by "..((self.PowerGainMultiplier - 1) * 100).."%"
	end

	if self.IsVampire then
		skill.lifeleech = "Heals "..(self.IsAOE and 2 or 1).." every hit"
	end

	local friendlylevel = 0 + (self.inst:HasTag("youkai") and 0 or 1) + (self.inst:HasTag("realyoukai") and 1 or 0) + (self.inst:HasTag("spiderwhisperer") and 1 or 0)
	if friendlylevel ~= 0 then
		skill.friendlylevel = "Friendly Level : "..friendlylevel
	end

	if self.inst.components.sanity.neg_aura_mult ~= 1 then
		skill.insanityresist = "Insanity Aura resist : "..((1 - self.inst.components.sanity.neg_aura_mult) * 100).."%"
	end

	if self.regenamount ~= 0 and self.regencool ~= 0 then
		skill.healthregen = "Heals "..self.regenamount.." every "..self.regencool.." seconds"
	end

	if self.curecool ~= 0 then
		skill.cure = "Cure poison every "..self.curecool.." seconds"
	end

	if self.InvincibleLearned and skill.invincibility == nil then
		local invincibility
		if self.IsInvincible then
			invincibility = STRINGS.INVINCIBILITY.." : "..STRINGS.ACTIVATED
		elseif self.inst.invin_cool > 0 then
			invincibility = STRINGS.INVINCIBILITY.." : "..self.inst.invin_cool..STRINGS.SECONDS
		else
			invincibility = STRINGS.INVINCIBILITY.." : "..STRINGS.READY
		end

		skill.invincibility = invincibility
	end

	if self.inst.components.moisture.baseDryingRate ~= 0 and skill.dry == nil then
		skill.dry = "Additional drying speed by "..self.inst.components.moisture.baseDryingRate
	end

	if self.nohealthpenalty and skill.nohealthpenalty == nil then
		skill.nohealthpenalty = "No health penalty after reviving"
	end

	if self.inst:HasTag("fastpicker") and skill.picker == nil then
		skill.picker = "Picks faster"
	end

	if self.inst:HasTag("fastbuilder") and skill.crafter == nil then
		skill.crafter = "Crafts faster"
	end

	if self.IsAOE and skill.AOE == nil then
		skill.AOE = "40% chance to do area-of-effect with the damage amount of 60% in range 5"
	end

	if self.NightVision and skill.nightvision == nil then
		skill.nightvision = "Enables nightvision when sanity is over 80%"
	end

	if self.IsFight and skill.isfight == nil then
		skill.isfight = "Absorbs damage by 30%"
	end

	if self.Ability_45 and skill.longattack == nil then
		skill.longattack = "Inscreased attack range"
	end

	if self.Ability_45 and skill.realgraze == nil then
		skill.realgraze = "Grazing grants invincibility for a short time"
	end

	if self.IsEfficient and skill.efficient == nil then
		skill.efficient = "Uses tool more durably"
	end

	if self.SpikeEater and skill.spikeeater == nil then
		skill.spikeeater = "Can eat monster meat."
	end

	if self.RotEater and skill.roteater == nil then
		self.roteater = "Not a picky eater."
	end
end

function Upgrader:ApplyStatus()
	local hunger_percent = self.inst.components.hunger:GetPercent()
	local health_percent = self.inst.components.health:GetPercent()
	local sanity_percent = self.inst.components.sanity:GetPercent()
	local power_percent = self.inst.components.power:GetPercent()
	local ignoresanity = self.inst.components.sanity.ignore
    self.inst.components.sanity.ignore = false

	local modname = KnownModIndex:GetModActualName("Yakumo Yukari")
	local difficulty = GetModConfigData("difficulty", modname)
	local STATUS = TUNING.STATUS_DEFAULT
	if difficulty == "easy" then
		STATUS = TUNING.STATUS_EASY
	elseif difficulty == "hard" then
		STATUS = TUNING.STATUS_HARD
	end

	self:AbilityManager()
	self.inst.components.health.maxhealth = STATUS.DEFAULT_HP + self.health_level * STATUS.HP_RATE + self.healthbonus + math.max(0, (self.health_level - 30) * 7.5)
	self.inst.components.hunger.hungerrate = math.max( 0, (STATUS.DEFAULT_HR - self.hunger_level * STATUS.HR_RATE - math.max(0, (self.hunger_level - 30) * 0.025 )) ) * TUNING.WILSON_HUNGER_RATE 
	self.inst.components.hunger.max = STATUS.DEFAULT_HU + self.hungerbonus
	self.inst.components.sanity.max = STATUS.DEFAULT_SN + self.sanity_level * STATUS.SN_RATE + self.sanitybonus + math.max(0, (self.sanity_level - 30) * 5)
	self.inst.components.power.max = STATUS.DEFAULT_PW + self.power_level * STATUS.PO_RATE + self.powerbonus + math.max(0, (self.power_level - 30) * 5)
	self.inst.components.locomotor.walkspeed = 4 + self.bonusspeed + self.hatbonusspeed
	self.inst.components.locomotor.runspeed = 6 + self.bonusspeed + self.hatbonusspeed
	
	self.inst.components.health:SetPercent(health_percent)
	self.inst.components.hunger:SetPercent(hunger_percent)
	self.inst.components.sanity:SetPercent(sanity_percent)
	self.inst.components.power:SetPercent(power_percent)
	self.inst.components.sanity.ignore = ignoresanity
end

return Upgrader