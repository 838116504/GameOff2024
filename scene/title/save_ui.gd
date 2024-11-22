extends Control

signal load_btn_pressed
signal new_btn_pressed


var id:int : set = set_id
var game_save:GameSave = null : set = set_game_save


func get_player_name_label():
	return $not_empty_ui/player_name_label

func get_play_time_label():
	return $not_empty_ui/play_time_label

func get_save_time_label():
	return $not_empty_ui/save_time_label

func get_not_empty_ui():
	return $not_empty_ui

func get_empty_ui():
	return $empty_ui

func get_id_label():
	return $id_panel/id_label


func delete_save():
	if game_save == null:
		return
	
	var dir = GameSave.get_save_path(id).get_base_dir()
	DirAccess.remove_absolute(dir)
	game_save = null

func set_game_save(p_value):
	if game_save == p_value:
		return
	
	game_save = p_value

func update_game_save():
	var notEmptyUI = get_not_empty_ui()
	var emptyUI = get_empty_ui()
	if game_save == null:
		notEmptyUI.hide()
		emptyUI.show()
		return
	
	notEmptyUI.show()
	emptyUI.hide()
	
	var playerNameLabel = get_player_name_label()
	var playTimeLabel = get_play_time_label()
	var saveTimeLabel = get_save_time_label()
	
	playerNameLabel.text = game_save.player_name
	playTimeLabel.text = tr("TS_SAVE_PLAY_TIME") + game_save.get_play_time_text()
	saveTimeLabel.text = tr("TS_SAVE_SAVE_TIME") + game_save.get_save_time_text()

func set_id(p_value):
	id = p_value
	
	update_id()

func update_id():
	get_id_label().text = str(id)
	
	game_save = GameSave.load_save(id)


func _on_delete_btn_pressed() -> void:
	delete_save()

func _on_load_btn_pressed() -> void:
	load_btn_pressed.emit()

func _on_new_btn_pressed() -> void:
	new_btn_pressed.emit()
