extends RefCounted
## 鼠標左键按下确实矩形範圍一個點，釋放时另一個點，發射這矩形範圍的設定物品信號
## 鼠標右键按下确实矩形範圍一個點，釋放时另一個點，發射這矩形範圍的設定空物品信號
## 鼠標移动時设定map的物品

signal item_put(p_rect:Rect2i, p_item)
signal layer_changed

var map:Map
var pressed_cell = null
var right_pressed_cell = null
var put_item:MapItem = null

var _temp_item_list:Array

func enter():
	update_map()

func exit():
	reset_map()

func update_map():
	if map == null:
		return
	
	_temp_item_list = map.item_list[0].duplicate()

func reset_map():
	if map == null || _temp_item_list.is_empty():
		return
	
	map.item_list[0] = _temp_item_list.duplicate()
	layer_changed.emit()

func get_rect(p_a:Vector2i, p_b:Vector2i):
	return Rect2i(p_a, Vector2i.ONE).merge(Rect2i(p_b, Vector2i.ONE))

func _mouse_moved(p_cell:Vector2i):
	reset_map()
	if Rect2i(Vector2i.ZERO, Vector2i(map.get_width(), map.get_height())).has_point(p_cell):
		map.set_item_data(0, p_cell, put_item.get_map_item_id(), put_item.get_data())

func _mouse_pressed(p_cell:Vector2i):
	if right_pressed_cell != null:
		return
	
	pressed_cell = Vector2i.ZERO
	pressed_cell.x = clampi(p_cell.x, 0, map.get_width() - 1)
	pressed_cell.y = clampi(p_cell.y, 0, map.get_height() - 1)

func _mouse_released(p_cell:Vector2i):
	if right_pressed_cell:
		right_pressed_cell = null
		reset_map()
		return
	
	if pressed_cell == null:
		return
	
	reset_map()
	if put_item:
		item_put.emit(get_rect(pressed_cell, p_cell), put_item)
	
	pressed_cell = null

func _mouse_dragged(p_cell:Vector2i):
	if pressed_cell == null:
		return
	
	reset_map()
	var rect = get_rect(pressed_cell, p_cell)
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			map.set_item_data(0, Vector2i(x, y), put_item.get_map_item_id(), put_item.get_data())

func _mouse_right_pressed(p_cell:Vector2i):
	if pressed_cell != null:
		return
	
	right_pressed_cell = Vector2i.ZERO
	right_pressed_cell.x = clampi(p_cell.x, 0, map.get_width() - 1)
	right_pressed_cell.y = clampi(p_cell.y, 0, map.get_height() - 1)

func _mouse_right_released(p_cell:Vector2i):
	if pressed_cell:
		pressed_cell = null
		reset_map()
		return
	
	if right_pressed_cell == null:
		return
	
	reset_map()
	item_put.emit(get_rect(right_pressed_cell, p_cell), null)
	
	right_pressed_cell = null

func _mouse_right_dragged(p_cell:Vector2i):
	if right_pressed_cell == null:
		return
	
	reset_map()
	var rect = get_rect(right_pressed_cell, p_cell)
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			map.set_item(0, Vector2i(x, y), 0)

func _get_item(p_cell:Vector2i):
	var ret = null
	if Rect2i(Vector2i.ZERO, Vector2i(map.get_width(), map.get_height())).has_point(p_cell):
		ret = map.get_item(0, p_cell)
	
	return ret
