local assets =
{
	Asset( "ANIM", "anim/yakumoyukari.zip" ),
	Asset( "ANIM", "anim/ghost_yakumoyukari_build.zip"),
}

local skins =
{
	normal_skin = "yakumoyukari",
	ghost_skin = "ghost_yakumoyukari_build",
}

local base_prefab = "yakumoyukari"

local tags = {"yakumoyukari", "CHARACTER"}

return CreatePrefabSkin("yakumoyukari_none",
{
	base_prefab = base_prefab,
	skins = skins,
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})