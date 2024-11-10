extends RefCounted
## 鼠標左键按下确实矩形範圍一個點，釋放时另一個點，發射這矩形範圍的設定tile信號
## 鼠標右键按下确实矩形範圍一個點，釋放时另一個點，發射這矩形範圍的設定为默认tile信號
## 鼠標移动時指的格的tile设为当前的

signal tile_put(p_rect:Rect2i, p_tileId)
signal layer_changed

var map:Map
var pressed_cell = null
var right_pressed_cell = null
var put_tile_id:int = 0

var _temp_tile_list:Array

func enter():
	update_map()

func exit():
	reset_map()

func update_map():
	if map == null:
		return
	
	_temp_tile_list = map.tile_id_list[0].duplicate()

func reset_map():
	if map == null || _temp_tile_list.is_empty():
		return
	
	map.tile_id_list[0] = _temp_tile_list.duplicate()
	layer_changed.emit()

func get_rect(p_a:Vector2i, p_b:Vector2i):
	return Rect2i(p_a, Vector2i.ONE).merge(Rect2i(p_b, Vector2i.ONE))

func _mouse_moved(p_cell:Vector2i):
	reset_map()
	if Rect2i(Vector2i.ZERO, Vector2i(map.get_width(), map.get_height())).has_point(p_cell):
		map.set_tile(0, p_cell, put_tile_id)

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
	tile_put.emit(get_rect(pressed_cell, p_cell), put_tile_id)
	
	pressed_cell = null

func _mouse_dragged(p_cell:Vector2i):
	if pressed_cell == null:
		return
	
	reset_map()
	var rect = get_rect(pressed_cell, p_cell)
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			map.set_tile(0, Vector2i(x, y), put_tile_id)

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
	tile_put.emit(get_rect(right_pressed_cell, p_cell), 0)
	
	right_pressed_cell = null

func _mouse_right_dragged(p_cell:Vector2i):
	if right_pressed_cell == null:
		return
	
	reset_map()
	var rect = get_rect(right_pressed_cell, p_cell)
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			map.set_tile(0, Vector2i(x, y), 0)
