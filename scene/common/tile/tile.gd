extends Resource
class_name Tile

@export var name:String
@export var tile_id:int
@export var blocked:bool = true
@export var layer:int = 0

func get_tile_id() -> int:
	return tile_id

func get_tile_name() -> String:
	return name

func is_blocked() -> bool:
	return blocked
