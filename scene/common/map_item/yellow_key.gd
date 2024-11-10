extends MapItem


func get_map_item_id() -> int:
	return MapItemConst.MapItemId.YELLOW_KEY

func create_node() -> Node2D:
	node = preload("yellow_key_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		p_item.yellow_key_count += 1
