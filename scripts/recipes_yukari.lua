local TECH = GLOBAL.TECH
local difficulty = GetModConfigData("difficulty")

local TOUHOU = AddRecipeTab("TOUHOU", 777, "images/inventoryimages/touhoutab.xml", "touhoutab.tex", "yakumoyukari")

local HealthIngredient = { Ingredient("healingsalve", 2), Ingredient("log", 3) }
local HungerIngredient = { Ingredient("bonestew", 1), Ingredient("meatballs", 2) }
local SanityIngredient = { Ingredient("petals", 4), Ingredient("nightmarefuel", 2) }
local PowerIngredient = { Ingredient("purplegem", 2), Ingredient("livinglog", 3) }
if difficulty == "easy" then
	HealthIngredient = { Ingredient("healingsalve", 1), Ingredient("log", 2) }
	HungerIngredient = { Ingredient("meatballs", 3) }
	SanityIngredient = { Ingredient("petals", 3), Ingredient("nightmarefuel", 1) }
	PowerIngredient = { Ingredient("purplegem", 1), Ingredient("livinglog", 2) }
end

AddRecipe("healthpanel", HealthIngredient, TOUHOU, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/healthpanel.xml", "healthpanel.tex" )
AddRecipe("hungerpanel", HungerIngredient, TOUHOU, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/hungerpanel.xml", "hungerpanel.tex")
AddRecipe("sanitypanel", SanityIngredient, TOUHOU, TECH.MAGIC_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/sanitypanel.xml", "sanitypanel.tex")
AddRecipe("powerpanel", PowerIngredient, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/powerpanel.xml", "powerpanel.tex")
AddRecipe("spellcard_lament", {Ingredient("boards", 3), Ingredient("nightmarefuel", 1)}, TOUHOU, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_lament.xml", "spellcard_lament.tex")
AddRecipe("spellcard_butter", {Ingredient("butter", 1), Ingredient("honey", 2)}, TOUHOU, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_butter.xml", "spellcard_butter.tex")
AddRecipe("spellcard_bait", {Ingredient("honey", 4), Ingredient("armorgrass", 1)}, TOUHOU, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_bait.xml", "spellcard_bait.tex")
AddRecipe("spellcard_away", {Ingredient("cutreeds", 10), Ingredient("goose_feather", 3)}, TOUHOU, TECH.MAGIC_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_away.xml", "spellcard_away.tex")
AddRecipe("spellcard_balance", { Ingredient("ice", 20), Ingredient("nitre", 10), Ingredient("poop", 5)}, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_balance.xml", "spellcard_balance.tex")
AddRecipe("spellcard_addictive", {Ingredient("poop", 20), Ingredient("seeds", 20), Ingredient("redgem", 10), Ingredient("bluegem", 15)}, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_addictive.xml", "spellcard_addictive.tex")
AddRecipe("spellcard_matter", {Ingredient("rocks", 20), Ingredient("flint", 20), Ingredient("goldnugget", 20), Ingredient("nitre", 3)}, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_matter.xml", "spellcard_matter.tex")
AddRecipe("spellcard_mesh", {Ingredient("nightmarefuel", 5), Ingredient("nitre", 5)}, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_mesh.xml", "spellcard_mesh.tex")
AddRecipe("spellcard_curse", {Ingredient("nightmarefuel", 5), Ingredient("livinglog", 2)}, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_curse.xml", "spellcard_curse.tex")
AddRecipe("spellcard_laplace", {Ingredient("nightmarefuel", 5), Ingredient("purplegem", 2)}, TOUHOU, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_laplace.xml", "spellcard_laplace.tex")
AddRecipe("spellcard_necro", {Ingredient("thulecite", 40), Ingredient("purplegem", 20), Ingredient("greengem", 4)}, TOUHOU, TECH.ANCIENT_FOUR, nil, nil, nil, nil, nil, "images/inventoryimages/spellcard_necro.xml", "spellcard_necro.tex")
AddRecipe("healthult", {Ingredient("dragon_scales", 2), Ingredient("trunk_winter", 2), Ingredient("ice", 60)}, TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true, nil, nil, "images/inventoryimages/healthult.xml", "healthult.tex")
AddRecipe("hungerult", {Ingredient("bearger_fur", 2), Ingredient("armormarble", 2), Ingredient("bonestew", 10)}, TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true, nil, nil, "images/inventoryimages/hungerult.xml", "hungerult.tex")
AddRecipe("sanityult", {Ingredient("deerclops_eyeball", 2), Ingredient("orangegem", 10), Ingredient("yellowgem", 10), Ingredient("greengem", 10)}, TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true, nil, nil, "images/inventoryimages/sanityult.xml", "sanityult.tex")
AddRecipe("powerult", {Ingredient("minotaurhorn", 2), Ingredient("goose_feather", 20), Ingredient("transistor", 10), Ingredient("gears", 10)}, TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true, nil, nil, "images/inventoryimages/powerult.xml", "powerult.tex")