extends RefCounted
class_name MapItem

var position:Vector2i
var map_view
var node:Node2D


func is_blocked() -> bool:
	return false

func get_map_item_id() -> int:
	return 0

func get_icon() -> Texture2D:
	var id = get_map_item_id()
	if id < MapItemConst.MAP_ITEM_ICON_FILE_LIST.size():
		return load("res://asset/img/map_item/".path_join(MapItemConst.MAP_ITEM_ICON_FILE_LIST[id]))
	
	return null

func get_map_item_name() -> String:
	return tr("MAP_ITEM_%d" % get_map_item_id())

func get_description() -> String:
	return tr("MAP_ITEM_DESC_%d" % get_map_item_id())

func create_node() -> Node2D:
	return null

func _map_item_entered(_item):
	pass

func set_data(_data):
	pass

func get_data():
	return null
