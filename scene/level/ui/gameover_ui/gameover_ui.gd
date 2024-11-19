extends Control

var player_unit:PlayerUnit

func get_layer_label():
	return $layer_hbox/layer_label

func get_enemy_label():
	return $enemy_hbox/enemy_label

func get_score_label():
	return $score_hbox/score_label

func get_anim_player():
	return $anim_player


func _ready():
	event_bus.listen(EventConst.GAMEOVER, _on_ent_gameover)

func _gui_input(_event:InputEvent):
	get_tree().root.set_input_as_handled()

func _on_ent_gameover():
	open()
	
	get_layer_label().text = str(player_unit.reached_layer)
	get_enemy_label().text = str(player_unit.kill_count)
	get_score_label().text = str(player_unit.reached_layer * 100 + player_unit.kill_count)
	var animPlayer = get_anim_player()
	animPlayer.play(&"gameover")

func open():
	grab_focus()
	show()

func close():
	release_focus()
	hide()

func set_player_unit(p_value):
	player_unit = p_value
