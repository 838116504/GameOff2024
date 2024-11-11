extends RefCounted
class_name MapItemConst

enum MapItemId {
	YELLOW_DOOR = 1, BLUE_DOOR, RED_DOOR, YELLOW_KEY, BLUE_KEY, RED_KEY, BUG, DIALOGUE_TRIGGER, UNIT
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
	preload("res://scene/common/map_item/unit/unit.gd"),
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
]
