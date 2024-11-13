extends BaseScene

const TEST_LVL_PATH = "res://asset/level/noob.lvl"

var map:Map : set = set_map
var player_unit:PlayerUnit : set = set_player_unit


@onready var left_ui = get_left_ui()
@onready var right_ui = get_right_ui()
@onready var map_view = get_map_view()


func get_left_ui():
	return $left_ui

func get_right_ui():
	return $right_ui

func get_map_view() -> MapView:
	return $map_view

func get_input():
	return $input

func _ready():
	if map == null:
		load_level(TEST_LVL_PATH)
	
	if player_unit == null:
		if map.player_unit:
			player_unit = map.player_unit
		else:
			player_unit = PlayerUnit.new()
			player_unit.set_unit_id(1)
			player_unit.layer = map.entrance_layer
			player_unit.position = map.entrance_position
			map.player_unit = player_unit
	
	player_unit.map_view = map_view
	map_view.current_layer = player_unit.layer
	
	for child in left_ui.get_children() + right_ui.get_children():
		if child.has_method("set_player_unit"):
			child.set_player_unit(player_unit)
	
	get_input().player_unit = player_unit

func load_level(p_path):
	var file = FileAccess.open(p_path, FileAccess.READ)
	assert(file)
	
	var mapData = file.get_var()
	var loadMap = Map.new()
	loadMap.set_data(mapData)
	map = loadMap

func set_map(p_map):
	if map == p_map:
		return
	
	map = p_map
	get_map_view().map = map

func set_player_unit(p_value):
	if player_unit == p_value:
		return
	
	if player_unit:
		player_unit.layer_changed.disconnect(_on_player_unit_layer_changed)
	
	player_unit = p_value
	if player_unit:
		player_unit.layer_changed.connect(_on_player_unit_layer_changed)

func _on_player_unit_layer_changed(p_layer):
	map_view.current_layer = p_layer