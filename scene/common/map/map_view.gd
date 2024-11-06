extends Control
class_name MapView

var map:Map
var current_layer:int = 0
var tile_node_list := []
var item_node_list := []
var tile_root:Node2D
var item_root:Node2D


func _init():
	tile_root = Node2D.new()
	add_child(tile_root)
	item_root = Node2D.new()
	add_child(item_root)


func move_item(p_from:Vector2i, p_to:Vector2i):
	assert(map)
	var fromId = map._to_map_position_id(p_from)
	var toId = map._to_map_position_id(p_to)
	var itemNode:Node2D = item_node_list[fromId]
	assert(itemNode && item_node_list[toId] == null)
	itemNode.position = get_grid_position(Vector2(p_to))
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
	aItemNode.position = get_grid_position(Vector2(p_b))
	bItemNode.position = get_grid_position(Vector2(p_a))
	item_node_list[aId] = bItemNode
	item_node_list[bId] = aItemNode
	
	map.swap_item(current_layer, p_a, p_b)

func get_grid_position(p_pos:Vector2):
	return Vector2(get_grid_size()) * (p_pos + Vector2(0.5, 0.5))

func get_grid_size() -> Vector2i:
	return Vector2i(70, 70)
