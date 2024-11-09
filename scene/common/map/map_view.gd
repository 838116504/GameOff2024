extends Control
class_name MapView

var map:Map
var current_layer:int = 0
var item_node_list := []
var tile_map:TileMap
var item_root:Node2D


func _init():
	tile_map = TileMap.new()
	tile_map.set_layer_navigation_enabled(0, false)
	tile_map.tile_set = TileConst.TILE_SET
	add_child(tile_map)
	item_root = Node2D.new()
	item_root.y_sort_enabled = true
	add_child(item_root)

func get_cell_size() -> Vector2:
	return tile_map.tile_set.tile_size

func get_cell_center_position(p_pos:Vector2):
	return Vector2(get_cell_size()) * (p_pos + Vector2(0.5, 0.5))

func set_map(p_map):
	if map == p_map:
		return
	
	if map:
		map.tile_changed.disconnect(_on_map_tile_changed)
		tile_map.clear()
		item_node_list.clear()
		for node in item_root.get_children():
			item_root.remove_child(node)
			node.queue_free()
	
	map = p_map
	if map:
		map.tile_changed.connect(_on_map_tile_changed)
		init_map()

func init_map():
	if map == null:
		return
	
	var s = map.get_width() * map.get_height()
	item_node_list.resize(s)
	for y in map.get_height():
		for x in map.get_width():
			var pos = Vector2i(x, y)
			var tile = map.get_tile(pos)
			_set_tile(pos, tile)
			var item = map.get_item(pos)
			if item:
				var itemId = map._to_map_position_id(pos)
				var node = item.create_node()
				if node:
					item_node_list[itemId] = node
					node.position = get_cell_center_position(Vector2(pos))
					item_root.add_child(node)


func _set_tile(p_pos:Vector2i, p_tile:Tile):
	var tileId = -1
	if p_tile:
		tileId = p_tile.tile_id
	
	tile_map.set_cell(0, p_pos, tileId, Vector2i.ZERO)

func move_item(p_from:Vector2i, p_to:Vector2i):
	assert(map)
	var fromId = map._to_map_position_id(p_from)
	var toId = map._to_map_position_id(p_to)
	var itemNode:Node2D = item_node_list[fromId]
	assert(itemNode && item_node_list[toId] == null)
	itemNode.position = get_cell_center_position(Vector2(p_to))
	item_node_list[fromId] = null
	item_node_list[toId] = itemNode
	
	map.move_item(current_layer, p_from, p_to)

func swap_item(p_a:Vector2i, p_b:Vector2i):
	assert(map)
	var aId = map._to_map_position_id(p_a)
	var bId = map._to_map_position_id(p_b)
	var aItemNode:Node2D = item_node_list[aId]
	var bItemNode:Node2D = item_node_list[bId]
	assert(aItemNode && bItemNode)
	aItemNode.position = get_cell_center_position(Vector2(p_b))
	bItemNode.position = get_cell_center_position(Vector2(p_a))
	item_node_list[aId] = bItemNode
	item_node_list[bId] = aItemNode
	
	map.swap_item(current_layer, p_a, p_b)


func _on_map_tile_changed(p_layer:int, p_pos:Vector2i, _id:int):
	if p_layer != current_layer:
		return
	
	var tile = map.get_tile(p_pos)
	_set_tile(p_pos, tile)
