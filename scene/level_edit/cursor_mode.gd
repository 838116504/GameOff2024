extends RefCounted
## 鼠标移到物品上显示物品屬性
## 左鍵物品鎖定，右鍵解鎖

var map:Map
var locked_item:MapItem = null


func enter():
	pass

func exit():
	locked_item = null
	event_bus.emit_signal(EventConst.HIDE_MAP_ITEM_DETAIL)

func update_map():
	pass

func _mouse_released(p_cell:Vector2i):
	var item = _get_item(p_cell)
	if item == null:
		return
	
	locked_item = item
	event_bus.emit_signal(EventConst.SHOW_MAP_ITEM_DETAIL, locked_item)

func _mouse_right_released(p_cell:Vector2i):
	if locked_item:
		locked_item = null
	
	var item = _get_item(p_cell)
	if item == null:
		event_bus.emit_signal(EventConst.HIDE_MAP_ITEM_DETAIL)

func _mouse_moved(p_cell:Vector2i):
	var item = _get_item(p_cell)
	if item:
		event_bus.emit_signal(EventConst.SHOW_MAP_ITEM_DETAIL, item)
	elif locked_item:
		event_bus.emit_signal(EventConst.SHOW_MAP_ITEM_DETAIL, locked_item)
	else:
		event_bus.emit_signal(EventConst.HIDE_MAP_ITEM_DETAIL)

func _get_item(p_cell:Vector2i):
	var ret = null
	if Rect2i(Vector2i.ZERO, Vector2i(map.get_width(), map.get_height())).has_point(p_cell):
		ret = map.get_item(0, p_cell)
	
	return ret
