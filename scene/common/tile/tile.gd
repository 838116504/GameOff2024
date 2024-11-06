extends Resource
class_name Tile

@export var name:String
@export var texture:Texture2D
@export var blocked:bool = true

func create_tile():
	var tile = Sprite2D.new()
	tile.texture = texture
	return tile

func get_tile_name() -> String:
	return name

func is_blocked() -> bool:
	return blocked
