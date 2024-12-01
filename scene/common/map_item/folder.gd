extends MapItem
class_name Folder

var skill_id:int = 50

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.FOLDER

func create_node() -> Node2D:
	node = preload("folder_node.tscn").instantiate()
	return node

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		var skill = Skill.create_by_id(skill_id)
		p_item.add_skill(skill)

func is_blocked() -> bool:
	return false


func set_data(p_data):
	if p_data is int:
		skill_id = p_data

func get_data():
	return skill_id
