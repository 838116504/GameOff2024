extends RefCounted
class_name Map

signal before_item_changed(p_layer:int, p_pos:Vector2i, p_id:int)
signal item_changed(p_layer:int, p_pos:Vector2i)
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

var player_unit:PlayerUnit : set = set_player_unit


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

func _to_cell_position(p_id:int) -> Vector2i:
	@warning_ignore("integer_division")
	var y:int = p_id / get_width()
	return Vector2i(p_id - y * get_width(), y)

func get_item(p_layer:int, p_pos:Vector2i) -> MapItem:
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
		ret.position = p_pos
		ret.set_data(itemData[1])
		#if ret is Unit && itemData[1].has("unit_id"):
			#print_debug(ret.position, " data = ", itemData[1])
		return ret
	
	return itemData

func get_tile(p_layer:int, p_pos:Vector2i) -> Tile:
	var ret:Resource = TileConst.get_tile(tile_id_list[p_layer][_to_map_position_id(p_pos)])
	if ret == null:
		ret = TileConst.get_tile(default_tile_id)
	
	return ret

func get_tile_id(p_layer:int, p_pos:Vector2i) -> int:
	return tile_id_list[p_layer][_to_map_position_id(p_pos)]

func set_item(p_layer:int, p_pos:Vector2i, p_id:int):
	before_item_changed.emit(p_layer, p_pos, p_id)
	item_list[p_layer][_to_map_position_id(p_pos)] = p_id
	item_changed.emit(p_layer, p_pos)

func set_item_data(p_layer:int, p_pos:Vector2i, p_id:int, p_data):
	before_item_changed.emit(p_layer, p_pos, p_id)
	if p_data:
		item_list[p_layer][_to_map_position_id(p_pos)] = [p_id, p_data]
	else:
		item_list[p_layer][_to_map_position_id(p_pos)] = p_id
	item_changed.emit(p_layer, p_pos)

func move_item(p_layer:int, p_from:Vector2i, p_to:Vector2i):
	var fromId = _to_map_position_id(p_from)
	item_list[p_layer][_to_map_position_id(p_to)] = item_list[p_layer][fromId]
	item_list[p_layer][fromId] = 0
	
	item_moved.emit(p_layer, p_from, p_to)

func erase_item(p_layer:int, p_pos:Vector2i):
	before_item_changed.emit(p_layer, p_pos, 0)
	item_list[p_layer][_to_map_position_id(p_pos)] = 0
	item_changed.emit(p_layer, p_pos)

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
	return tile != null && tile.is_blocked()

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

func set_player_unit(p_value):
	if player_unit == p_value:
		return
	
	player_unit = p_value
	if player_unit:
		before_item_changed.emit(player_unit.layer, player_unit.position, player_unit.layer, player_unit.get_map_item_id())
		var posId = _to_map_position_id(player_unit.position)
		var item = get_item(player_unit.layer, player_unit.position)
		if item != null:
			if scene_transition.is_playing():
				Engine.get_main_loop().paused = true
				await scene_transition.finished
				Engine.get_main_loop().paused = false
			item._map_item_entered(player_unit)
		item_list[player_unit.layer][posId] = player_unit
		item_changed.emit(player_unit.layer, player_unit.position)
