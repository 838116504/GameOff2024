extends RefCounted
class_name MapItem

var position:Vector2i
var map_view
var node:Node2D


func is_blocked() -> bool:
	return false

func get_map_item_id() -> int:
	return 0

func create_node() -> Node2D:
	return null

func _map_item_entered(_item):
	pass

func set_data(_data):
	pass

func get_data():
	return null
