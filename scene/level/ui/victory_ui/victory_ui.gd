extends Control

signal exit_btn_pressed

var player_unit:PlayerUnit

func get_layer_label():
	return $layer_hbox/layer_label

func get_enemy_label():
	return $enemy_hbox/enemy_label

func get_rest_enemy_label():
	return $rest_enemy_hbox/rest_enemy_label

func get_hp_label():
	return $hp_hbox/hp_label

func get_score_label():
	return $score_hbox/score_label

func get_anim_player():
	return $anim_player


func _ready():
	event_bus.listen(EventConst.GAME_VICTORY, _on_ent_game_victory)

func _gui_input(_event:InputEvent):
	get_tree().root.set_input_as_handled()

func _on_ent_game_victory(p_restUnitCount, p_score):
	open()
	
	get_layer_label().text = str(player_unit.reached_layer)
	get_enemy_label().text = str(player_unit.kill_count)
	get_rest_enemy_label().text = str(p_restUnitCount)
	get_hp_label().text = str(player_unit.hp)
	get_score_label().text = str(p_score)
	var animPlayer = get_anim_player()
	animPlayer.play(&"victory")

func open():
	grab_focus()
	show()

func close():
	release_focus()
	hide()

func set_player_unit(p_value):
	player_unit = p_value


func _on_exit_btn_pressed() -> void:
	exit_btn_pressed.emit()
