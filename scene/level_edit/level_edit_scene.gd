extends Control

enum FileBtnId { NEW, OPEN, SAVE, SAVE_AS }

var map:Map : set = set_map
var current_map:Map = Map.new()
var current_layer:int = 0
var undo_redo := UndoRedo.new()
var version:int = 0 : set = set_version
var file_path:String = "" : set = set_file_path


@onready var current_layer_edit = get_current_layer_edit()
@onready var entrance_layer_edit = get_entrance_layer_edit()
@onready var entrance_x_edit = get_entrance_x_edit()
@onready var entrance_y_edit = get_entrance_y_edit()
@onready var select_tab_cntr = get_select_tab_cntr()
@onready var map_view = get_map_view()
@onready var undo_btn = get_undo_btn()
@onready var redo_btn = get_redo_btn()
@onready var file_btn = get_file_btn()


func get_current_layer_edit():
	return $left_ui/hbox/current_layer_edit

func get_entrance_layer_edit():
	return $left_ui/hbox/entrance_layer_edit

func get_entrance_x_edit():
	return $left_ui/hbox/entrance_x_edit

func get_entrance_y_edit():
	return $left_ui/hbox/entrance_y_edit

func get_select_tab_cntr():
	return $left_ui/select_tab_cntr

func get_map_view():
	return $map_view

func get_undo_btn() -> Button:
	return $top_bar_panel/hbox/undo_btn

func get_redo_btn() -> Button:
	return $top_bar_panel/hbox/redo_btn

func get_file_btn() -> MenuButton:
	return $top_bar_panel/hbox/file_btn

func get_save_confirm_dialog() -> ConfirmationDialog:
	return $save_comfirm_dialog

func get_save_file_dialog() -> FileDialog:
	return $save_file_dialog

func get_open_file_dialog() -> FileDialog:
	return $open_file_dialog


func _ready():
	undo_btn.undo_redo = undo_redo
	redo_btn.undo_redo = undo_redo
	map_view.map = current_map
	select_tab_cntr.map = current_map
	
	if map == null:
		map = Map.new()
	else:
		update_map()
	
	update_file_btn_font_color()
	update_file_btn_text()
	init_save_confirm_dialoge()
	
	undo_redo.version_changed.connect(_on_undo_redo_version_changed)
	
	file_btn.get_popup().id_pressed.connect(_on_file_btn_id_pressed)
	
	get_save_file_dialog().current_path = "res://asset/level/"
	get_open_file_dialog().current_path = "res://asset/level/"

func _on_undo_redo_version_changed():
	update_file_btn_font_color()

func is_need_save():
	return version < undo_redo.get_version()

func update_file_btn_font_color():
	var color:Color
	if is_need_save():
		color = Color.RED
	else:
		color = Color.GREEN
	
	file_btn.add_theme_color_override(&"font_color", color)
	file_btn.add_theme_color_override(&"font_pressed_color", color)
	file_btn.add_theme_color_override(&"font_hover_color", color)
	file_btn.add_theme_color_override(&"font_hover_pressed_color", color)

func update_file_btn_text():
	if file_path.is_empty():
		file_btn.text = tr("LES_UNNAMED")
		file_btn.tooltip_text = ""
		return
	
	file_btn.text = file_path.get_file().get_basename()
	file_btn.tooltip_text = file_path

func set_map(p_value):
	if map == p_value:
		return
	
	if map:
		map.layer_changed.disconnect(_on_map_layer_changed)
	
	map = p_value
	if map:
		map.layer_changed.connect(_on_map_layer_changed)
		update_map()

func update_map():
	if !is_node_ready() || map == null:
		return
	
	if current_layer_edit.value_changed.is_connected(_on_current_layer_edit_value_changed):
		current_layer_edit.value_changed.disconnect(_on_current_layer_edit_value_changed)
	if entrance_layer_edit.value_changed.is_connected(_on_entrance_layer_edit_value_changed):
		entrance_layer_edit.value_changed.disconnect(_on_entrance_layer_edit_value_changed)
	if entrance_x_edit.value_changed.is_connected(_on_entrance_x_edit_value_changed):
		entrance_x_edit.value_changed.disconnect(_on_entrance_x_edit_value_changed)
	if entrance_y_edit.value_changed.is_connected(_on_entrance_y_edit_value_changed):
		entrance_y_edit.value_changed.disconnect(_on_entrance_y_edit_value_changed)
	current_layer = 0
	current_layer_edit.value = 0
	entrance_layer_edit.max_value = map.get_layer() - 1
	entrance_layer_edit.value = map.entrance_layer
	entrance_x_edit.value = map.entrance_position.x
	entrance_y_edit.value = map.entrance_position.y
	
	current_map.tile_id_list[0] = map.tile_id_list[0].duplicate()
	current_map.item_list[0] = map.item_list[0].duplicate()
	map_view.update_layer()
	select_tab_cntr.update_map()
	current_layer_edit.value_changed.connect(_on_current_layer_edit_value_changed)
	entrance_layer_edit.value_changed.connect(_on_entrance_layer_edit_value_changed)
	entrance_x_edit.value_changed.connect(_on_entrance_x_edit_value_changed)
	entrance_y_edit.value_changed.connect(_on_entrance_y_edit_value_changed)

func set_current_layer(p_layer):
	current_layer = p_layer
	current_map.tile_id_list[0] = map.tile_id_list[p_layer].duplicate()
	current_map.item_list[0] = map.item_list[p_layer].duplicate()
	map_view.update_layer()
	select_tab_cntr.update_map()

func _on_map_layer_changed(p_layer):
	entrance_layer_edit.max_value = p_layer - 1

func _on_current_layer_edit_value_changed(p_value):
	undo_redo.create_action("set current layer")
	if p_value >= map.get_layer():
		var addLayer = p_value - map.get_layer() + 1
		undo_redo.add_do_method(map.add_layer.bind(addLayer))
		undo_redo.add_undo_method(map.add_layer.bind(-addLayer))
	
	undo_redo.add_do_method(set_current_layer.bind(p_value))
	undo_redo.add_undo_method(set_current_layer.bind(current_layer))
	undo_redo.commit_action()

func set_entrance_layer(p_value):
	map.entrance_layer = p_value

func _on_entrance_layer_edit_value_changed(p_value):
	undo_redo.create_action("set entrance layer")
	undo_redo.add_do_method(set_entrance_layer.bind(p_value))
	undo_redo.add_undo_method(set_entrance_layer.bind(map.entrance_layer))
	undo_redo.commit_action()

func set_entrance_x(p_value):
	map.entrance_position.x = p_value

func _on_entrance_x_edit_value_changed(p_value):
	undo_redo.create_action("set entrance x")
	undo_redo.add_do_method(set_entrance_x.bind(p_value))
	undo_redo.add_undo_method(set_entrance_x.bind(map.entrance_position.x))
	undo_redo.commit_action()

func set_entrance_y(p_value):
	map.entrance_position.y = p_value

func _on_entrance_y_edit_value_changed(p_value):
	undo_redo.create_action("set entrance y")
	undo_redo.add_do_method(set_entrance_y.bind(p_value))
	undo_redo.add_undo_method(set_entrance_y.bind(map.entrance_position.y))
	undo_redo.commit_action()

func set_item_with_rect(p_rect:Rect2i, p_item):
	if p_item == null:
		for x in p_rect.size.x:
			for y in p_rect.size.y:
				var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
				map.item_list[current_layer][mapId] = null
	else:
		for x in p_rect.size.x:
			for y in p_rect.size.y:
				var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
				var data = p_item.get_data()
				if data == null:
					map.item_list[current_layer][mapId] = p_item.get_map_item_id()
				else:
					map.item_list[current_layer][mapId] = [ p_item.get_map_item_id(), data ]
	
	current_map.item_list[0] = map.item_list[current_layer].duplicate()
	map_view.update_layer()
	select_tab_cntr.update_map()

func set_rect_items(p_rect:Rect2i, p_items:Array):
	for y in p_rect.size.y:
		for x in p_rect.size.x:
			var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
			var id = x + y * p_rect.size.x
			map.item_list[current_layer][mapId] = p_items[id]
	
	current_map.item_list[0] = map.item_list[current_layer].duplicate()
	map_view.update_layer()
	select_tab_cntr.update_map()

func _on_select_tab_cntr_item_put(p_rect: Rect2i, p_item: Variant) -> void:
	var items := []
	items.resize(p_rect.size.x * p_rect.size.y)
	for y in p_rect.size.y:
		for x in p_rect.size.x:
			var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
			var id = x + y * p_rect.size.x
			items[id] = map.item_list[current_layer][mapId]
	
	undo_redo.create_action("set item with rect")
	undo_redo.add_do_method(set_item_with_rect.bind(p_rect, p_item))
	undo_redo.add_undo_method(set_rect_items.bind(p_rect, items))
	undo_redo.commit_action()


func _on_select_tab_cntr_layer_changed() -> void:
	map_view.update_layer()


func set_tile_with_rect(p_rect:Rect2i, p_tileId):
	for x in p_rect.size.x:
		for y in p_rect.size.y:
			var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
			map.tile_id_list[current_layer][mapId] = p_tileId
	
	current_map.tile_id_list[0] = map.tile_id_list[current_layer].duplicate()
	map_view.update_layer()
	select_tab_cntr.update_map()

func set_rect_tiles(p_rect:Rect2i, p_tiles:Array):
	for y in p_rect.size.y:
		for x in p_rect.size.x:
			var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
			var id = x + y * p_rect.size.x
			map.tile_id_list[current_layer][mapId] = p_tiles[id]
	
	current_map.tile_id_list[0] = map.tile_id_list[current_layer].duplicate()
	map_view.update_layer()
	select_tab_cntr.update_map()

func _on_select_tab_cntr_tile_put(p_rect: Rect2i, p_tileId: int) -> void:
	var tiles := []
	tiles.resize(p_rect.size.x * p_rect.size.y)
	for y in p_rect.size.y:
		for x in p_rect.size.x:
			var mapId = map._to_map_position_id(Vector2i(x, y) + p_rect.position)
			var id = x + y * p_rect.size.x
			tiles[id] = map.tile_id_list[current_layer][mapId]
	
	undo_redo.create_action("set tile with rect")
	undo_redo.add_do_method(set_tile_with_rect.bind(p_rect, p_tileId))
	undo_redo.add_undo_method(set_rect_tiles.bind(p_rect, tiles))
	undo_redo.commit_action()

func save():
	if file_path.is_empty():
		var saveFileDialog = get_save_file_dialog()
		saveFileDialog.popup_centered()
		await saveFileDialog.finished
		file_path = saveFileDialog.path
		
		if file_path.is_empty():
			return false
	
	var data = map.get_data()
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	assert(file)
	file.store_var(data)
	file.close()
	
	version = undo_redo.get_version()
	update_file_btn_text()
	return true

func save_as(p_path):
	file_path = p_path
	return await save()

func open(p_path):
	var file = FileAccess.open(p_path, FileAccess.READ)
	if file == null:
		return
	
	file_path = p_path
	var data = file.get_var()
	var loadMap = Map.new()
	loadMap.set_data(data)
	map = loadMap
	
	version = undo_redo.get_version()
	update_file_btn_text()

func init_save_confirm_dialoge():
	var dialog = get_save_confirm_dialog()
	dialog.dialog_text = tr("LES_SAVE_CONFIRM_TEXT")
	var okBtn = dialog.get_ok_button()
	okBtn.text = tr("LES_SAVE")
	var cancelBtn = dialog.get_cancel_button()
	cancelBtn.text = tr("LES_CANCEL")
	var noSaveBtn = dialog.add_button(tr("LES_NO_SAVE"), false, "no_save")
	dialog.confirmed.connect(_on_save_confirm_dialog_confirmed.bind(dialog))
	dialog.canceled.connect(_on_save_confirm_dialog_canceled.bind(dialog))
	noSaveBtn.pressed.connect(_on_save_confirm_dialog_no_save.bind(dialog))

func _on_save_confirm_dialog_confirmed(p_dialog:Node):
	if !p_dialog.has_meta(&"confirmed_callback"):
		return
	
	var callback = p_dialog.get_meta(&"confirmed_callback")
	callback.call()

func _on_save_confirm_dialog_canceled(p_dialog:Node):
	if !p_dialog.has_meta(&"canceled_callback"):
		return
	
	var callback = p_dialog.get_meta(&"canceled_callback")
	callback.call()

func _on_save_confirm_dialog_no_save(p_dialog:Node):
	p_dialog.hide()
	if !p_dialog.has_meta(&"no_save_callback"):
		return
	
	var callback = p_dialog.get_meta(&"no_save_callback")
	callback.call()


func popup_save_confirm_dialog(p_confirmCallback, p_noSaveCallback, p_cancelCallback = null):
	var saveConfirmDialog = get_save_confirm_dialog()
	saveConfirmDialog.set_meta(&"confirmed_callback", p_confirmCallback)
	saveConfirmDialog.set_meta(&"no_save_callback", p_noSaveCallback)
	saveConfirmDialog.set_meta(&"canceled_callback", p_cancelCallback)
	saveConfirmDialog.popup_centered()

func new_level():
	if is_need_save():
		popup_save_confirm_dialog(_on_new_level_save_confirmed, _new_level)
		return
	
	_new_level()

func _new_level():
	map = Map.new()
	file_path = ""
	
	undo_redo.clear_history(false)
	version = undo_redo.get_version()

func _on_new_level_save_confirmed():
	if await save():
		_new_level()

func set_version(p_value):
	if version == p_value:
		return
	
	version = p_value
	update_file_btn_font_color()

func set_file_path(p_value):
	if file_path == p_value:
		return
	
	file_path = p_value
	update_file_btn_text()

func _input(p_event):
	if InputMap.event_is_action(p_event, &"ui_undo", true):
		undo_redo.undo()
		get_tree().root.set_input_as_handled()
	elif InputMap.event_is_action(p_event, &"ui_redo", true):
		undo_redo.redo()
		get_tree().root.set_input_as_handled()
	elif InputMap.event_is_action(p_event, &"les_save", true):
		save()
		get_tree().root.set_input_as_handled()
	elif InputMap.event_is_action(p_event, &"les_cursor", true):
		select_tab_cntr.to_cursor_mode()
		get_tree().root.set_input_as_handled()


func _on_open_file_dialog_file_selected(p_path: String) -> void:
	open(p_path)

func _on_file_btn_id_pressed(p_id:int):
	match p_id:
		FileBtnId.NEW:
			new_level()
		FileBtnId.OPEN:
			var openFileDialog = get_open_file_dialog()
			openFileDialog.popup_centered()
		FileBtnId.SAVE:
			save()
		FileBtnId.SAVE_AS:
			var saveFileDialog = get_save_file_dialog()
			saveFileDialog.popup_centered()
			await saveFileDialog.finished
			if saveFileDialog.path.is_empty():
				return
			
			save_as(saveFileDialog.path)
