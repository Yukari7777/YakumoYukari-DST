local Recipe = GLOBAL.Recipe
local RECIPETABS = GLOBAL.CUSTOM_RECIPETABS
local TECH = GLOBAL.TECH

RECIPETABS.TOUHOU = {str = "TOUHOU", sort = 787, icon = "touhoutab.tex", icon_atlas = "images/inventoryimages/touhoutab.xml", owner_tag = "yakumoyukari"}

if Difficulty == "easy" then
	local healthpanelrecipe = AddRecipe( "healthpanel", {Ingredient("healingsalve", 1), Ingredient("log", 2)}, RECIPETABS.TOUHOU, {SCIENCE = 1} )
	healthpanelrecipe.atlas = "images/inventoryimages/healthpanel.xml"
	local hungerpanelrecipe = AddRecipe( "hungerpanel", {Ingredient("meatballs", 3)}, RECIPETABS.TOUHOU, {SCIENCE = 2} )
	hungerpanelrecipe.atlas = "images/inventoryimages/hungerpanel.xml"
	local sanitypanelrecipe = AddRecipe( "sanitypanel", {Ingredient("petals", 3), Ingredient("nightmarefuel", 1)}, RECIPETABS.TOUHOU, {MAGIC = 1} )
	sanitypanelrecipe.atlas = "images/inventoryimages/sanitypanel.xml"
	local powerpanelrecipe = AddRecipe( "powerpanel", {Ingredient("purplegem", 1), Ingredient("livinglog", 2)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
	powerpanelrecipe.atlas = "images/inventoryimages/powerpanel.xml"
else
	local healthpanelrecipe = AddRecipe( "healthpanel", {Ingredient("healingsalve", 2), Ingredient("log", 3)}, RECIPETABS.TOUHOU, {SCIENCE = 1} )
	healthpanelrecipe.atlas = "images/inventoryimages/healthpanel.xml"
	local hungerpanelrecipe = AddRecipe( "hungerpanel", {Ingredient("bonestew", 1), Ingredient("meatballs", 2)}, RECIPETABS.TOUHOU, {SCIENCE = 2} )
	hungerpanelrecipe.atlas = "images/inventoryimages/hungerpanel.xml"
	local sanitypanelrecipe = AddRecipe( "sanitypanel", {Ingredient("petals", 4), Ingredient("nightmarefuel", 2)}, RECIPETABS.TOUHOU, {MAGIC = 1} )
	sanitypanelrecipe.atlas = "images/inventoryimages/sanitypanel.xml"
	local powerpanelrecipe = AddRecipe( "powerpanel", {Ingredient("purplegem", 2), Ingredient("livinglog", 3)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
	powerpanelrecipe.atlas = "images/inventoryimages/powerpanel.xml"
end
	
local spellcardbaitrecipe = AddRecipe( "spellcard_bait", {Ingredient("honey", 4), Ingredient("armorgrass", 1)}, RECIPETABS.TOUHOU, {SCIENCE = 1} )
spellcardbaitrecipe.atlas = "images/inventoryimages/spellcard_bait.xml"
--local spelllamentrecipe = AddRecipe( "spellcard_lament", {Ingredient("boards", 3), Ingredient("nightmarefuel", 1)}, RECIPETABS.TOUHOU, {SCIENCE = 1} )
--spelllamentrecipe.atlas = "images/inventoryimages/spellcard_lament.xml"
local spellbutterrecipe = AddRecipe( "spellcard_butter", {Ingredient("butter", 1)}, RECIPETABS.TOUHOU, {SCIENCE = 1})
spellbutterrecipe.atlas = "images/inventoryimages/spellcard_butter.xml"
local spellawayrecipe = AddRecipe( "spellcard_away", {Ingredient("cutreeds", 10), Ingredient("goose_feather", 3)}, RECIPETABS.TOUHOU, {MAGIC = 1} )
spellawayrecipe.atlas = "images/inventoryimages/spellcard_away.xml"
local spellbalancerecipe = AddRecipe( "spellcard_balance", {Ingredient("seeds", 5), Ingredient("poop", 3)}, RECIPETABS.TOUHOU, {MAGIC = 1} )
spellbalancerecipe.atlas = "images/inventoryimages/spellcard_balance.xml"
local spelladdictiverecipe = AddRecipe( "spellcard_addictive", {Ingredient("poop", 10), Ingredient("ice", 10), Ingredient("nitre", 5), Ingredient("seeds", 5)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
spelladdictiverecipe.atlas = "images/inventoryimages/spellcard_addictive.xml"
local spellmatterrecipe = AddRecipe( "spellcard_matter", {Ingredient("rocks", 20), Ingredient("flint", 20), Ingredient("goldnugget", 5), Ingredient("nitre", 3)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
spellmatterrecipe.atlas = "images/inventoryimages/spellcard_matter.xml"
local spellmeshrecipe = AddRecipe( "spellcard_mesh", {Ingredient("nightmarefuel", 5), Ingredient("nitre", 5)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
spellmeshrecipe.atlas = "images/inventoryimages/spellcard_mesh.xml"
local spellcurserecipe = AddRecipe( "spellcard_curse", {Ingredient("nightmarefuel", 5), Ingredient("livinglog", 2)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
spellcurserecipe.atlas = "images/inventoryimages/spellcard_curse.xml"
local spelllaplacerecipe = AddRecipe( "spellcard_laplace", {Ingredient("nightmarefuel", 5), Ingredient("purplegem", 2)}, RECIPETABS.TOUHOU, {MAGIC = 2} )
spelllaplacerecipe.atlas = "images/inventoryimages/spellcard_laplace.xml"
local healthultrecipe = AddRecipe( "healthult", {Ingredient("dragon_scales", 1), Ingredient("trunk_winter", 1), Ingredient("ice", 30)}, RECIPETABS.TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true)
healthultrecipe.atlas = "images/inventoryimages/healthult.xml"
local hungerultrecipe = AddRecipe( "hungerult", {Ingredient("bearger_fur", 1), Ingredient("armormarble", 1), Ingredient("bonestew", 5)}, RECIPETABS.TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true)
hungerultrecipe.atlas = "images/inventoryimages/hungerult.xml"
local sanityultrecipe = AddRecipe( "sanityult", {Ingredient("deerclops_eyeball", 1), Ingredient("orangegem", 3), Ingredient("yellowgem", 3), Ingredient("greengem", 3)}, RECIPETABS.TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true)
sanityultrecipe.atlas = "images/inventoryimages/sanityult.xml"
local powerultrecipe = AddRecipe( "powerult", {Ingredient("minotaurhorn", 1), Ingredient("goose_feather", 5), Ingredient("transistor", 10), Ingredient("gears", 10)}, RECIPETABS.TOUHOU, TECH.ANCIENT_FOUR, nil, nil, true)
powerultrecipe.atlas = "images/inventoryimages/powerult.xml"
local spellnecrorecipe = AddRecipe( "spellcard_necro", {Ingredient("thulecite", 10), Ingredient("purplegem", 10), Ingredient("greengem", 2)}, RECIPETABS.TOUHOU, TECH.ANCIENT_FOUR)
spellnecrorecipe.atlas = "images/inventoryimages/spellcard_necro.xml"