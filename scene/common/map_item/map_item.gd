extends RefCounted
class_name MapItem

var position:Vector2i
var map_view
var blocked := false
var node:Node2D


func get_map_item_id() -> int:
	return 0

func create_node() -> Node2D:
	return null

func _map_item_entered(_item):
	pass
