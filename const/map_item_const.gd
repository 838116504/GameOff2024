extends RefCounted
class_name MapItemConst

enum MapItemId {
	YELLOW_DOOR = 1, BLUE_DOOR, RED_DOOR, YELLOW_KEY, BLUE_KEY, RED_KEY, BUG, DIALOGUE_TRIGGER, HP, ARMOR, SIREN, FOLDER, DATABASE, 
	UNIT, PLAYER_UNIT,
}

const MAP_ITEM_LIST = [
	null,
	preload("res://scene/common/map_item/yellow_door.gd"),
	preload("res://scene/common/map_item/blue_door.gd"),
	preload("res://scene/common/map_item/red_door.gd"),
	preload("res://scene/common/map_item/yellow_key.gd"),
	preload("res://scene/common/map_item/blue_key.gd"),
	preload("res://scene/common/map_item/red_key.gd"),
	preload("res://scene/common/map_item/bug.gd"),
	preload("res://scene/common/map_item/dialogue_trigger.gd"),
	preload("res://scene/common/map_item/hp.gd"),
	preload("res://scene/common/map_item/armor.gd"),
	preload("res://scene/common/map_item/siren.gd"),
	preload("res://scene/common/map_item/folder.gd"),
	preload("res://scene/common/map_item/database.gd"),
	preload("res://scene/common/map_item/unit/unit.gd"),
	preload("res://scene/common/map_item/unit/player_unit.gd"),
]

const MAP_ITEM_ICON_FILE_LIST = [
	"",
	"yellow_door.png",
	"blue_door.png",
	"red_door.png",
	"yellow_key.png",
	"bule_key.png",
	"red_key.png",
	"bug.png",
	"dialogue.png",
	"hp.png",
	"armor.png",
	"siren.png",
	"folder.png",
	"database.png",
]

static func get_map_item_icon(p_id:int) -> Texture2D:
	assert(p_id >= 0 && p_id < MAP_ITEM_ICON_FILE_LIST.size())
	return load(DirConst.MAP_ITEM_IMG.path_join(MAP_ITEM_ICON_FILE_LIST[p_id]))

static func get_unit_icon(p_id:int) -> Texture2D:
	assert(p_id > 0)
	var row = table_set.unit.get_row(p_id)
	if row:
		return load(DirConst.UNIT_IMG.path_join(row.image))
	
	return null

static func get_unit_name(p_id:int) -> String:
	assert(p_id > 0)
	var row = table_set.unit.get_row(p_id)
	if row:
		return TranslationServer.translate(row.name)
	
	return ""
