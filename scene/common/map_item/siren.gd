extends MapItem



func get_map_item_id() -> int:
	return MapItemConst.MapItemId.SIREN

func create_node() -> Node2D:
	node = preload("siren_node.tscn").instantiate()
	return node

func _map_item_entered(_item):
	pass

func is_blocked() -> bool:
	return true
