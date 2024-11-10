extends MapItem


func get_map_item_id() -> int:
	return MapItemConst.MapItemId.BLUE_KEY

func create_node() -> Node2D:
	node = preload("blue_key_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		p_item.blue_key_count += 1
