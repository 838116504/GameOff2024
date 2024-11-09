extends Resource
class_name Tile

@export var name:String
@export var tile_id:int
@export var blocked:bool = true

func get_tile_id():
	return tile_id

func get_tile_name() -> String:
	return name

func is_blocked() -> bool:
	return blocked
