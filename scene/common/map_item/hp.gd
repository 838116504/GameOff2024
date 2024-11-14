extends MapItem

var hp:int = 400

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.HP

func create_node() -> Node2D:
	node = preload("hp_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		p_item.hp += hp


func set_data(p_data):
	if p_data is int:
		hp = p_data

func get_data():
	return hp
