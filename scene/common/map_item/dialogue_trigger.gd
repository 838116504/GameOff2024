extends MapItem
class_name DialogueTrigger

var dialogue_id:int


func get_map_item_id() -> int:
	return MapItemConst.MapItemId.DIALOGUE_TRIGGER

func create_node() -> Node2D:
	node = preload("dialogue_trigger_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		pass
