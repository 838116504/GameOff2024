extends MapItem



func get_map_item_id() -> int:
	return MapItemConst.MapItemId.DATABASE

func create_node() -> Node2D:
	node = preload("database_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		pass

func is_blocked() -> bool:
	return true
