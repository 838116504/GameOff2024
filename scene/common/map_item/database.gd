extends MapItem
class_name Database

var use_time:int = 0
var base_cost:int = 1
var increase_cost:int = 1


func get_map_item_id() -> int:
	return MapItemConst.MapItemId.DATABASE

func create_node() -> Node2D:
	node = preload("database_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		event_bus.emit_signal(EventConst.SHOW_DATABASE_PANEL, self)

func is_blocked() -> bool:
	return true

func get_cost():
	return base_cost + increase_cost * use_time


func set_data(p_data):
	if p_data is Array:
		use_time = p_data[0]
		base_cost = p_data[1]
		increase_cost = p_data[2]

func get_data():
	return [ use_time, base_cost, increase_cost ]
