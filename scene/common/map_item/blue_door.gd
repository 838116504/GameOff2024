extends MapItem

func is_blocked():
	return true

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.BLUE_DOOR

func create_node() -> Node2D:
	node = preload("blue_door_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		if p_item.blue_key_count > 0:
			p_item.blue_key_count -= 1
			p_item.map_view.erase_item(position)
