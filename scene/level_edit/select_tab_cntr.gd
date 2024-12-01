extends TabContainer

const ItemBtnScene = preload("res://scene/level_edit/item_btn.tscn")
const TileBtnScene = preload("res://scene/level_edit/tile_btn.tscn")

signal item_put(p_rect:Rect2i, p_item)
signal tile_put(p_rect:Rect2i, p_tileId:int)
signal layer_changed
signal target_unit_set_id_changed(p_id:int)

@export var map_input_path:NodePath

var map:Map : set = set_map
var mode : set = set_mode
var mode_list = [ preload("cursor_mode.gd").new(), preload("item_mode.gd").new(), preload("tile_mode.gd").new() ]

var _left_button_pressed := false
var _right_button_pressed := false

@onready var select_box_patch = get_select_box_patch()
@onready var cursor_btn = get_cursor_btn()
@onready var target_label = get_target_label()

func get_select_box_patch() -> NinePatchRect:
	return $item_scroll_cntr/item_hflow_cntr/cursor_btn/select_box_patch

func get_item_hflow_cntr():
	return $item_scroll_cntr/item_hflow_cntr

func get_tile_hflow_cntr():
	return $tile_scroll_cntr/tile_hflow_cntr

func get_map_input() -> Control:
	return get_node_or_null(map_input_path)

func get_cursor_btn():
	return $item_scroll_cntr/item_hflow_cntr/cursor_btn

func get_target_label():
	return $item_scroll_cntr/item_hflow_cntr/cursor_btn/target_label


func _ready():
	set_tab_title(0, tr("LES_ITEM_TAB"))
	set_tab_title(1, tr("LES_TILE_TAB"))
	
	init_item()
	init_tile()
	
	var mapInput = get_map_input()
	assert(mapInput)
	mapInput.gui_input.connect(_map_input_gui_input)
	
	for i in mode_list:
		i.map = map
	
	if map:
		mode = mode_list[0]
	
	mode_list[1].item_put.connect(_on_item_mode_item_put)
	mode_list[1].layer_changed.connect(_on_mode_layer_changed)
	mode_list[2].tile_put.connect(_on_tile_mode_tile_put)
	mode_list[2].layer_changed.connect(_on_mode_layer_changed)

func set_map(p_value):
	map = p_value
	for i in mode_list:
		i.map = map
	
	if map:
		mode = mode_list[0]

func _map_input_gui_input(p_event):
	if p_event is InputEventMouseButton:
		match p_event.button_index:
			MOUSE_BUTTON_LEFT:
				if p_event.is_pressed():
					if p_event.is_echo():
						return
					
					_left_button_pressed = true
					if mode && mode.has_method("_mouse_pressed"):
						mode._mouse_pressed(_position_to_cell(p_event.position))
				else:
					_left_button_pressed = false
					if mode && mode.has_method("_mouse_released"):
						mode._mouse_released(_position_to_cell(p_event.position))
			MOUSE_BUTTON_RIGHT:
				if p_event.is_pressed():
					if p_event.is_echo():
						return
					
					_right_button_pressed = true
					if mode && mode.has_method("_mouse_right_pressed"):
						mode._mouse_right_pressed(_position_to_cell(p_event.position))
				else:
					_right_button_pressed = false
					if mode && mode.has_method("_mouse_right_released"):
						mode._mouse_right_released(_position_to_cell(p_event.position))
	elif p_event is InputEventMouseMotion:
		if !_left_button_pressed && !_right_button_pressed:
			if mode && mode.has_method("_mouse_moved"):
				mode._mouse_moved(_position_to_cell(p_event.position))
			return
		
		if _left_button_pressed:
			if mode && mode.has_method("_mouse_dragged"):
				mode._mouse_dragged(_position_to_cell(p_event.position))
		
		if _right_button_pressed:
			if mode && mode.has_method("_mouse_right_dragged"):
				mode._mouse_right_dragged(_position_to_cell(p_event.position))


# map view local position to cell position
func _position_to_cell(p_pos:Vector2):
	return Vector2i(int(p_pos.x / 70.0), int(p_pos.y / 70.0))

func init_item():
	var itemHflowCntr = get_item_hflow_cntr()
	var cursorBtn = itemHflowCntr.get_child(0)
	cursorBtn.pressed.connect(_on_cursor_btn_pressed)
	for i in range(1, MapItemConst.MapItemId.UNIT):
		var itemBtn = ItemBtnScene.instantiate()
		itemBtn.item = MapItemConst.MAP_ITEM_LIST[i].new()
		itemBtn.pressed.connect(_on_item_btn_pressed.bind(itemBtn))
		itemHflowCntr.add_child(itemBtn)
	
	for row in table_set.unit_set.get_row_list():
		var itemBtn = ItemBtnScene.instantiate()
		itemBtn.item = Unit.create_by_unit_set_id(row.id)
		itemBtn.pressed.connect(_on_item_btn_pressed.bind(itemBtn))
		itemBtn.right_pressed.connect(_on_item_btn_right_pressed.bind(itemBtn))
		itemHflowCntr.add_child(itemBtn)
	
	update_target_unit_set()

func update_target_unit_set():
	if map == null:
		return
	
	target_label.hide()
	var itemHflowCntr = get_item_hflow_cntr()
	for i in range(MapItemConst.MapItemId.UNIT, itemHflowCntr.get_child_count()):
		var child = itemHflowCntr.get_child(i)
		if child.item.get_unit_set_id() == map.target_unit_set_id:
			target_label.reparent(child, false)
			target_label.show()
			break

func init_tile():
	var tileHflowCntr = get_tile_hflow_cntr()
	for i in range(1, TileConst.TILE_PATH_LIST.size()):
		var tileBtn = TileBtnScene.instantiate()
		tileBtn.tile_id = i
		tileBtn.pressed.connect(_on_tile_btn_pressed.bind(tileBtn))
		tileHflowCntr.add_child(tileBtn)

func _on_cursor_btn_pressed():
	to_cursor_mode()

func to_cursor_mode():
	if select_box_patch.get_parent() == cursor_btn:
		return
	
	select_box_patch.reparent(cursor_btn, false)
	mode = mode_list[0]

func _on_item_btn_pressed(p_btn):
	if select_box_patch.get_parent() == p_btn:
		return
	
	select_box_patch.reparent(p_btn, false)
	mode_list[1].put_item = p_btn.item
	mode = mode_list[1]

func _on_item_btn_right_pressed(p_btn):
	var id = p_btn.item.get_unit_set_id()
	if id == map.target_unit_set_id:
		return
	
	target_unit_set_id_changed.emit(id)

func _on_tile_btn_pressed(p_btn):
	if select_box_patch.get_parent() == p_btn:
		return
	
	select_box_patch.reparent(p_btn, false)
	mode_list[2].put_tile_id = p_btn.tile_id
	mode = mode_list[2]

func update_map():
	if mode:
		mode.update_map()
	
	update_target_unit_set()

func set_mode(p_value):
	if mode == p_value:
		return
	
	if mode:
		mode.exit()
	
	mode = p_value
	
	if mode:
		mode.enter()

func _on_item_mode_item_put(p_rect:Rect2i, p_item):
	item_put.emit(p_rect, p_item)

func _on_mode_layer_changed():
	layer_changed.emit()

func _on_tile_mode_tile_put(p_rect:Rect2i, p_tileId):
	tile_put.emit(p_rect, p_tileId)
