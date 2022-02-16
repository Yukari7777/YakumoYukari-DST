function MakeUltimate(id)
	local index = id % 4 + 1
	local statname = _G.YUKARISTATINDEX[index]
	local fname = statname..(id > 4 and "ultsw" or "ult")
	
	local assets =
	{   
		Asset("ANIM", "anim/spell_none.zip"),   
		Asset("ATLAS", "images/inventoryimages/"..fname..".xml"),    
		Asset("IMAGE", "images/inventoryimages/"..fname..".tex"),
	}

	local function DoUpgrade(inst, caster)
		local spellcard = inst.components.spellcard
		local index = spellcard.index
		local name = spellcard.name
		local level = caster.components.dreadful[_G.YUKARISTATINDEX[index].."_level"]

		local issw = name:find("sw") ~= nil
		local abilityindex = issw and 6 or 5

		local ultreq = TUNING.YUKARI_STATUS.MAX_UPGRADE
		
		if level >= ultreq then
			if not caster.components.dreadful.ability[index][abilityindex] then
				caster.components.talker:Say(STRINGS.CHARACTERS.YAKUMOYUKARI["ONULTIMATE"..(issw and "SW" or "")][index])
				caster.components.dreadful.ability[index][abilityindex] = true
				caster.components.dreadful:ApplyStatus()
				inst:Remove()
			else
				if caster.components.talker ~= nil then
					caster.components.talker:Say(GetString(caster.prefab, "DESCRIBE_ABILITY_ALREADY"))
				end
			end
		else
			if caster.components.talker ~= nil then
				caster.components.talker:Say(string.format(STRINGS.CHARACTERS.YAKUMOYUKARI.DESCRIBE_LOWLEVEL, _G.YUKARISTATINDEX[index], ultreq))
			end
		end
	end
		
	local function fn()  
		
		local inst = CreateEntity()    
	
		inst.entity:AddTransform()    
		inst.entity:AddAnimState()    
		inst.entity:AddSoundEmitter()  
		inst.entity:AddNetwork()	
		
		MakeInventoryPhysics(inst)   
		
		inst.AnimState:SetBank("spell_none")    
		inst.AnimState:SetBuild("spell_none")    
		inst.AnimState:PlayAnimation("idle")   

		inst:AddTag("ultpanel")
		inst:AddTag("heavyaction")
		
		if not TheWorld.ismastersim then
			return inst
		end

		inst.entity:SetPristine()

		inst:AddComponent("inspectable")        
		
		inst:AddComponent("inventoryitem") 
		inst.components.inventoryitem.imagename = fname    
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..fname..".xml"    

		inst:AddComponent("spellcard")
		inst.components.spellcard.index = index
		inst.components.spellcard.name = fname
		inst.components.spellcard:SetSpellFn( DoUpgrade )
		
		return inst
	end
	
	return Prefab("common/inventory/"..fname, fn, assets)
end

local spells = {}
for i = 1, 8 do
    table.insert(spells, MakeUltimate(i))
end

return unpack(spells)