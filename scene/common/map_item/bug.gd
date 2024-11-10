extends MapItem

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.BUG

func create_node() -> Node2D:
	node = preload("bug_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		p_item.bug_count += 1
