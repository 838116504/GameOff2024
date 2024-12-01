extends MapItem



func get_map_item_id() -> int:
	return MapItemConst.MapItemId.SIREN

func set_map_view(p_value):
	map_view = p_value
	if node:
		node.set_map_view(map_view)

func create_node() -> Node2D:
	node = preload("siren_node.tscn").instantiate()
	node.item = self
	return node

func _map_item_entered(_item):
	pass

func is_blocked() -> bool:
	return true
