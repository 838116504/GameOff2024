extends Control

var game_save:GameSave : set = set_game_save
var level_row : set = set_level_row
var level_save:GameSave.LevelSave

@onready var target_tex_rect = get_target_tex_rect()
@onready var completed_label = get_completed_label()
@onready var record_panel = get_record_panel()
@onready var record_text_label = get_record_text_label()
@onready var save_panel = get_save_panel()
@onready var save_text_label = get_save_text_label()
@onready var new_panel = get_new_panel()
@onready var new_panel_text_label = get_new_panel_text_label()


func get_target_tex_rect():
	return $panel/target_bg_patch/vbox/target_tex_rect

func get_completed_label():
	return $panel/target_bg_patch/completed_label

func get_record_panel():
	return $panel/vbox/record_panel

func get_record_text_label():
	return $panel/vbox/record_panel/text_label

func get_save_panel():
	return $panel/vbox/save_panel

func get_save_text_label():
	return $panel/vbox/save_panel/text_label

func get_new_panel():
	return $panel/vbox/new_panel

func get_new_panel_text_label():
	return $panel/vbox/new_panel/text_label


func _ready():
	event_bus.listen(EventConst.SHOW_LEVEL_POPUP, _on_ent_show_level_popup)

func _gui_input(p_event:InputEvent):
	if p_event is InputEventMouseButton && p_event.button_index == MOUSE_BUTTON_LEFT:
		if p_event.is_released():
			close()

func set_game_save(p_value):
	game_save = p_value


func set_level_row(p_value):
	if level_row == p_value:
		return
	
	level_row = p_value
	if level_row:
		target_tex_rect.texture = MapItemConst.get_unit_icon(level_row.target_id)
		completed_label.visible = game_save.is_level_finised(level_row.id)
		var record = game_save.get_level_record(level_row.id)
		if record == null:
			record_panel.hide()
		else:
			record_text_label.text = tr("HS_RECORD_TEXT") % [ record.score, Time.get_datetime_string_from_unix_time(record.time) ]
			record_panel.show()
		
		if game_save.has_level_save(level_row.id):
			level_save = game_save.get_level_save(level_row.id)
			var saveTimeStr = Time.get_datetime_string_from_unix_time(game_save.get_level_save_save_time(level_row.id))
			var playTimeStr = ""
			var h = int(level_save.play_time / 3600.0)
			if h > 0:
				playTimeStr += str(h) + tr("TS_HOUR")
			var restPlayTime = level_save.play_time - h * 3600
			var m = int(restPlayTime / 60.0)
			if m > 0:
				playTimeStr += str(m) + tr("TS_MINUTE")
				restPlayTime -= m * 60
			playTimeStr += str(int(restPlayTime)) + tr("TS_SECOND")
			
			save_text_label.text = tr("HS_SAVE_TEXT") % [ saveTimeStr, playTimeStr ]
			save_panel.show()
			new_panel.hide()
		else:
			level_save = null
			new_panel.show()
			save_panel.hide()

func open():
	grab_focus()
	show()

func close():
	release_focus()
	hide()

func _on_ent_show_level_popup(p_lvlId:int):
	level_row = table_set.level.get_row(p_lvlId)
	assert(level_row)
	open()

func _on_hack_btn_pressed() -> void:
	var playerUnit = game_save.create_player_unit()
	var lvlScene = load(ScenePathConst.LEVEL_SCENE).instantiate()
	lvlScene.player_unit = playerUnit
	lvlScene.load_level(DirConst.LEVEL.path_join(level_row.level + "." + GameSave.LEVEL_EXTENSION))
	var lvlSave = GameSave.LevelSave.new()
	lvlSave.map = lvlScene.map
	lvlSave.game_save = game_save
	lvlSave.path = game_save.get_level_save_path(level_row.id)
	lvlScene.level_save = lvlSave
	scene_transition.change_scene(lvlScene, "fade_out", "fade_in")

func _on_continue_btn_pressed() -> void:
	var lvlScene = load(ScenePathConst.LEVEL_SCENE).instantiate()
	lvlScene.level_save = level_save
	lvlScene.map = lvlScene.level_save.map
	scene_transition.change_scene(lvlScene, "fade_out", "fade_in")
