extends Control
class_name MapView

var map:Map : set = set_map
var current_layer:int = 0 : set = set_current_layer
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
		map.item_changed.disconnect(_on_map_item_changed)
		clear()
	
	map = p_map
	if map:
		map.tile_changed.connect(_on_map_tile_changed)
		map.item_changed.connect(_on_map_item_changed)
		init_map()

func clear():
	tile_map.clear()
	item_node_list.clear()
	for node in item_root.get_children():
		item_root.remove_child(node)
		node.queue_free()

func init_map():
	if map == null:
		return
	
	var s = map.get_width() * map.get_height()
	item_node_list.resize(s)
	for y in map.get_height():
		for x in map.get_width():
			var pos = Vector2i(x, y)
			var tile = map.get_tile(current_layer, pos)
			_set_tile(pos, tile)
			var item = map.get_item(current_layer, pos)
			create_item_node(item, pos)

func create_item_node(p_item:MapItem, p_pos):
	var itemId = map._to_map_position_id(p_pos)
	if item_node_list[itemId] != null:
		var item = item_node_list[itemId].get_meta(&"item")
		item.node = null
		item_node_list[itemId].queue_free()
		item_node_list[itemId] = null
	
	if p_item == null:
		return
	
	var node:Node = p_item.create_node()
	p_item.map_view = self
	p_item.position = p_pos
	if node:
		item_node_list[itemId] = node
		node.set_meta(&"item", p_item)
		node.position = get_cell_center_position(Vector2(p_pos))
		item_root.add_child(node)


func _set_tile(p_pos:Vector2i, p_tile:Tile):
	var tileId = -1
	if p_tile:
		tileId = p_tile.tile_id
	
	tile_map.set_cell(0, p_pos, tileId, Vector2i.ZERO)

func move_item(p_from:Vector2i, p_to:Vector2i):
	assert(map)
	if map.is_tile_blocked(current_layer, p_to):
		return
	
	var fromId = map._to_map_position_id(p_from)
	var toId = map._to_map_position_id(p_to)
	var itemNode:Node2D = item_node_list[fromId]
	assert(itemNode)
	
	var item = itemNode.get_meta(&"item")
	if item_node_list[toId]:
		var toItem = item_node_list[toId].get_meta(&"item")
		
		toItem._map_item_entered(item)
		if toItem.is_blocked():
			return
		
		erase_item(p_to)
	
	itemNode.position = get_cell_center_position(Vector2(p_to))
	item.position = p_to
	item_node_list[fromId] = null
	item_node_list[toId] = itemNode
	
	map.move_item(current_layer, p_from, p_to)
	if item is PlayerUnit:
		var tile = map.get_tile(current_layer, p_to)
		if tile && tile.layer != 0:
			var targetLayer = item.layer + tile.layer
			map.set_item_layer(current_layer, p_to, targetLayer)
			item.layer = targetLayer

func swap_item(p_a:Vector2i, p_b:Vector2i):
	assert(map)
	var aId = map._to_map_position_id(p_a)
	var bId = map._to_map_position_id(p_b)
	var aItemNode:Node2D = item_node_list[aId]
	var bItemNode:Node2D = item_node_list[bId]
	assert(aItemNode && bItemNode)
	aItemNode.position = get_cell_center_position(Vector2(p_b))
	bItemNode.position = get_cell_center_position(Vector2(p_a))
	var aItem = aItemNode.get_meta(&"item")
	var bItem = bItemNode.get_meta(&"item")
	aItem.position = p_b
	bItem.position = p_a
	item_node_list[aId] = bItemNode
	item_node_list[bId] = aItemNode
	
	map.swap_item(current_layer, p_a, p_b)

func erase_item(p_pos:Vector2i):
	var id = map._to_map_position_id(p_pos)
	if item_node_list[id] == null:
		return
	
	#item_node_list[id].queue_free()
	#item_node_list[id] = null
	map.erase_item(current_layer, p_pos)

func _on_map_tile_changed(p_layer:int, p_pos:Vector2i, _id:int):
	if p_layer != current_layer:
		return
	
	var tile = map.get_tile(current_layer, p_pos)
	_set_tile(p_pos, tile)

func _on_map_item_changed(p_layer:int, p_pos:Vector2i):
	if p_layer != current_layer:
		return
	
	udpate_cell_item(p_pos)

func udpate_cell_item(p_cell:Vector2i):
	var item = map.get_item(current_layer, p_cell)
	create_item_node(item, p_cell)

func set_current_layer(p_value):
	if current_layer == p_value:
		return
	
	current_layer = p_value
	update_layer()

func update_layer():
	clear()
	
	init_map()
