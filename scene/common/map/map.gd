extends RefCounted
class_name Map

signal before_item_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal item_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal item_data_changed(p_layer:int, p_pos:Vector2i, p_id:int, p_data)
signal item_moved(p_layer:int, p_from:Vector2i, p_to:Vector2i)
signal item_swapped(p_layer:int, p_a:Vector2i, p_b:Vector2i)

signal before_tile_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal tile_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal layer_changed(p_layer:int)


@export var default_tile_id:int = 1

## 物品id / [ 物品id, data ] / MapItem
var item_list := []
var tile_id_list:Array = []
var entrance_layer:int = 0
var entrance_position:Vector2i

var player_unit:PlayerUnit


func _init():
	add_layer(1)

func _set(p_prop:StringName, p_value) -> bool:
	if p_prop == &"player_unit_data":
		player_unit = PlayerUnit.new()
		player_unit.set_data(p_value)
		return true
	
	return false

func get_layer() -> int:
	return tile_id_list.size()

func get_width() -> int:
	return 15

func get_height() -> int:
	return 15

func _to_map_position_id(p_pos:Vector2i):
	return p_pos.y * get_width() + p_pos.x

func get_item(p_layer:int, p_pos:Vector2i):
	var posId = _to_map_position_id(p_pos)
	var itemData = item_list[p_layer][posId]
	if itemData == null:
		return null
	
	if itemData is MapItem:
		return itemData
	
	if itemData is int:
		if itemData < 1 || itemData >= MapItemConst.MAP_ITEM_LIST.size():
			return null
		
		var ret = MapItemConst.MAP_ITEM_LIST[itemData].new()
		ret.position = p_pos
		return ret
	
	if itemData is Array:
		var ret = MapItemConst.MAP_ITEM_LIST[itemData[0]].new()
		ret.set_data(itemData[1])
		ret.position = p_pos
		return ret
	
	return itemData

func get_tile(p_layer:int, p_pos:Vector2i):
	var ret = TileConst.TILE_LIST[tile_id_list[p_layer][_to_map_position_id(p_pos)]]
	if ret == null:
		ret = TileConst.TILE_LIST[default_tile_id]
	
	return ret

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

func erase_item(p_layer:int, p_pos:Vector2i):
	item_list[p_layer][_to_map_position_id(p_pos)] = 0
	item_changed.emit(p_layer, p_pos, 0)

func set_item_layer(p_layer:int, p_pos:Vector2i, p_target_layer:int):
	var id = _to_map_position_id(p_pos)
	item_list[p_target_layer][id] = item_list[p_layer][id]
	item_list[p_layer][id] = 0

func swap_item(p_layer:int, p_a:Vector2i, p_b:Vector2i):
	var aId = _to_map_position_id(p_a)
	var bId = _to_map_position_id(p_b)
	var temp = item_list[p_layer][aId]
	item_list[p_layer][aId] = item_list[p_layer][bId]
	item_list[p_layer][bId] = temp
	
	item_swapped.emit(p_layer, p_a, p_b)

func set_tile(p_layer:int, p_pos:Vector2i, p_id:int):
	before_tile_changed.emit(p_layer, p_pos, p_id)
	tile_id_list[p_layer][_to_map_position_id(p_pos)] = p_id
	tile_changed.emit(p_layer, p_pos, p_id)

func is_tile_blocked(p_layer:int, p_pos:Vector2i) -> bool:
	var tile = get_tile(p_layer, p_pos)
	return tile == null || !tile.is_blocked()

func add_layer(p_value:int):
	if p_value == 0:
		return
	
	var curLayer = get_layer()
	var nextLayer = max(curLayer + p_value, 0)
	tile_id_list.resize(nextLayer)
	item_list.resize(nextLayer)
	var s = get_width() * get_height()
	if nextLayer > curLayer:
		for i in range(curLayer, nextLayer):
			tile_id_list[i] = []
			tile_id_list[i].resize(s)
			tile_id_list[i].fill(0)
			item_list[i] = []
			item_list[i].resize(s)
	
	layer_changed.emit(nextLayer)

func get_data():
	var ret = { "item_list":item_list, "tile_id_list": tile_id_list, "entrance_layer":entrance_layer, "entrance_position":entrance_position}
	if player_unit:
		var items = item_list.duplicate()
		items[player_unit.layer][_to_map_position_id(player_unit.position)] = null
		ret.item_list = items
		ret.player_unit_data = player_unit.get_data()
	
	return ret

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])
	
	if player_unit:
		item_list[player_unit.layer][_to_map_position_id(player_unit.position)] = player_unit
