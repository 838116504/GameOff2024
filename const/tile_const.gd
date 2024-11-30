extends RefCounted
class_name TileConst

const TILE_SET = preload("res://scene/common/tile/tile_set.tres")
enum TileId {
	FLOOR = 1, VOID, WALL, CRASHED_WALL, UPSTAIRS, DOWNSTAIRS, CLOSED_UPSTAIRS, CLOSED_DOWNSTAIRS
}

const TILE_LIST = [
	null,
	preload("res://scene/common/tile/floor.tres"),
	preload("res://scene/common/tile/void.tres"),
	preload("res://scene/common/tile/wall.tres"),
	preload("res://scene/common/tile/crashed_wall.tres"),
	preload("res://scene/common/tile/upstairs.tres"),
	preload("res://scene/common/tile/downstairs.tres"),
	preload("res://scene/common/tile/close_upstairs.tres"),
	preload("res://scene/common/tile/close_downstairs.tres"),
]
