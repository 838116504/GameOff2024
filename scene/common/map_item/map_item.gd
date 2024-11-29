extends Resource
class_name MapItem

var position:Vector2i
var map_view : set = set_map_view
var node:Node2D



func _mouse_entered():
	event_bus.emit_signal(EventConst.SHOW_MAP_ITEM_DETAIL, self)

func _mouse_exited():
	event_bus.emit_signal(EventConst.HIDE_MAP_ITEM_DETAIL)


func is_blocked() -> bool:
	return false

func get_map_item_id() -> int:
	return 0

func get_icon() -> Texture2D:
	var id = get_map_item_id()
	if id < MapItemConst.MAP_ITEM_ICON_FILE_LIST.size():
		return MapItemConst.get_map_item_icon(id)
	
	return null

func get_map_item_name() -> String:
	return tr("MAP_ITEM_%d" % get_map_item_id())

func get_description() -> String:
	return tr("MAP_ITEM_DESC_%d" % get_map_item_id())

func create_node() -> Node2D:
	return null

func set_map_view(p_value):
	map_view = p_value

func _map_item_entered(_item):
	pass

func set_data(_data):
	pass

func get_data():
	return null
