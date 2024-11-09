extends RefCounted
class_name Map

signal before_item_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal item_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal item_data_changed(p_layer:int, p_pos:Vector2i, p_id:int, p_data)
signal item_moved(p_layer:int, p_from:Vector2i, p_to:Vector2i)
signal item_swapped(p_layer:int, p_a:Vector2i, p_b:Vector2i)

signal before_tile_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal tile_changed(p_layer:int, p_pos:Vector2i, p_id:int)


var item_list := []
var tile_list := []
var entrance_layer:int = 0
var entrance_position:Vector2i


func get_layer() -> int:
	return tile_list.size()

func get_width() -> int:
	return 15

func get_height() -> int:
	return 15

func _to_map_position_id(p_pos:Vector2i):
	return p_pos.y * get_width() + p_pos.x

func get_item(p_pos:Vector2i):
	return item_list[_to_map_position_id(p_pos)]

func get_tile(p_pos:Vector2i):
	return tile_list[_to_map_position_id(p_pos)]

func set_item(p_layer:int, p_pos:Vector2i, p_id:int):
	before_item_changed.emit(p_layer, p_pos, p_id)
	item_list[p_layer][_to_map_position_id(p_pos)] = p_id
	item_changed.emit(p_layer, p_pos, p_id)

func set_item_data(p_layer:int, p_pos:Vector2i, p_id:int, p_data):
	item_list[p_layer][_to_map_position_id(p_pos)] = [p_id, p_data]
	item_data_changed.emit(p_layer, p_pos, p_id, p_data)

func move_item(p_layer:int, p_from:Vector2i, p_to:Vector2i):
	var fromId = _to_map_position_id(p_from)
	item_list[p_layer][_to_map_position_id(p_to)] = item_list[p_layer][fromId]
	item_list[p_layer][fromId] = 0
	
	item_moved.emit(p_layer, p_from, p_to)

func swap_item(p_layer:int, p_a:Vector2i, p_b:Vector2i):
	var aId = _to_map_position_id(p_a)
	var bId = _to_map_position_id(p_b)
	var temp = item_list[p_layer][aId]
	item_list[p_layer][aId] = item_list[p_layer][bId]
	item_list[p_layer][bId] = temp
	
	item_swapped.emit(p_layer, p_a, p_b)

func set_tile(p_layer:int, p_pos:Vector2i, p_id:int):
	before_tile_changed.emit(p_layer, p_pos, p_id)
	tile_list[p_layer][_to_map_position_id(p_pos)] = p_id
	tile_changed.emit(p_layer, p_pos, p_id)

func is_tile_blocked(p_layer:int, p_pos:Vector2i) -> bool:
	var id = _to_map_position_id(p_pos)
	return tile_list[p_layer][id] == null || !tile_list[p_layer][id].is_blocked()

func get_data():
	return { "item_list":item_list, "tile_list": tile_list, "entrance_layer":entrance_layer, "entrance_position":entrance_position}

func set_data(p_data):
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])
