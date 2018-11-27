function MakeUltimateSW(name, index)

	local fname = name.."ultsw"
	
	local assets =
	{   
		Asset("ANIM", "anim/spell.zip"),   
		Asset("ATLAS", "images/inventoryimages/"..fname..".xml"),    
		Asset("IMAGE", "images/inventoryimages/"..fname..".tex"),
	}

	local function DoUpgrade(inst)
		local caster = inst.components.inventoryitem.owner
		local spellcard = inst.components.spellcard
		local index = spellcard.index
		local name = spellcard.name
		local level = spellcard:GetLevel(caster, index)
		local difficulty = GetModConfigData("difficulty", "YakumoYukari")
		local language = GetModConfigData("language", "YakumoYukari")
		local ultreq = 25
		if difficulty == "easy" then ultreq = 20
		elseif difficulty == "hard" then ultreq = 30 end
		
		local str = {}
			str[1] = "I changed my destiny myself..."
			str[2] = "Everythings are DESTROYABLE."
			str[3] = "This, is the power who my friend had..."
			str[4] = "Yes... this is my power I had."
		if language == "ch" then
			str[1] = "我 改 变 了 我 自 己 的 命 运..."
			str[2] = "万 物 皆 可 毁 灭."
			str[3] = "这.. 是 我 伙 伴 的 力 量..."
			str[4] = "是 的... 这 是 我 的 力 量."
		end
		
		if level >= ultreq then
			if not caster.components.upgrader.ability[index][6] then
				caster.components.talker:Say(str[index])
				caster.components.upgrader.ability[index][6] = true
				caster.components.upgrader:ApplyStatus()
				inst:Remove()
			else
				if caster.components.talker then
					caster.components.talker:Say(GetString(caster.prefab, "DESCRIBE_ABILITY_ALREADY"))
				end
			end
		else
			if caster.components.talker then
				if difficulty == "chinese" then
					caster.components.talker:Say("我 必 须 要 把 "..name.." 升 级 到 "..ultreq.."之 上")
				else
					caster.components.talker:Say("I must reach "..name.." level to "..ultreq)
				end
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
		
		inst.AnimState:SetBank("spell")    
		inst.AnimState:SetBuild("spell")    
		inst.AnimState:PlayAnimation("idle")   

		inst:AddTag("ultpanel")
		
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

return MakeUltimateSW("health", 1),
       MakeUltimateSW("hunger", 2),
       MakeUltimateSW("sanity", 3),
       MakeUltimateSW("power", 4)