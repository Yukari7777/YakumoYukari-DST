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

return CreatePrefabSkin("yakumoyukari_none",
{
	base_prefab = "yakumoyukari",
	type = "base",
	assets = assets,
	skins = skins,
	skin_tags = {"yakumoyukari", "CHARACTER", "BASE"},
	rarity = "Common",
	build_name = "yakumoyukari",
	skip_item_gen = true,
	skip_giftable_gen = true,
})