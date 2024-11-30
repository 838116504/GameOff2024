extends Control

const CheatPanelCntrScene = preload("res://scene/level/ui/cheat_view/cheat_panel_cntr.tscn")

var player_unit:PlayerUnit

@onready var bug_count_label = get_bug_count_label()
@onready var cheat_vbox = get_cheat_vbox()

func get_bug_count_label():
	return $title_hbox/bug_count_label

func get_cheat_vbox():
	return $scroll_cntr/cheat_vbox


func disable_cheat_btn():
	for i in cheat_vbox.get_children():
		i.disable()

func enable_cheat_btn():
	for i in cheat_vbox.get_children():
		i.enable()


func set_player_unit(p_value):
	player_unit = p_value
	
	if player_unit:
		player_unit.bug_count_changed.connect(_on_player_unit_bug_count_changed)
		
		var cheats = [player_unit.cheat]
		for i in player_unit.follow_unit_list:
			if i.cheat:
				cheats.append(i.cheat)
		
		for i in cheats:
			var cheatPanel = CheatPanelCntrScene.instantiate()
			cheatPanel.cheat = i
			cheatPanel.used.connect(_on_cheat_panel_used)
			cheat_vbox.add_child(cheatPanel)
		
		update_bug_count()

func update_bug_count():
	bug_count_label.text = str(player_unit.bug_count)
	if player_unit.bug_count <= 0:
		disable_cheat_btn()
	else:
		enable_cheat_btn()

func _on_player_unit_bug_count_changed(_count):
	update_bug_count()

func _on_cheat_panel_used(p_cheat):
	p_cheat.execute(player_unit)
