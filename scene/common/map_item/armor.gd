extends MapItem

var def:int = 1

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.ARMOR

func create_node() -> Node2D:
	node = preload("armor_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		p_item.def += def


func set_data(p_data):
	if p_data is int:
		def = p_data

func get_data():
	return def
