extends Panel

var player_unit:PlayerUnit
var unit:Unit : set = set_unit


@onready var fight_btn = get_fight_btn()
@onready var damage_label = get_damage_label()
@onready var hp_not_enough_popup = get_hp_not_enough_popup()
@onready var simple_panel = get_simple_panel()
@onready var detail_panel = get_detail_panel()

func get_fight_btn():
	return $btns_hbox/fight_btn

func get_damage_label():
	return $btns_hbox/hand_combat_btn/damage_hbox/damage_label

func get_hp_not_enough_popup():
	return $hp_not_enough_popup

func get_simple_panel():
	return $simple_panel

func get_detail_panel():
	return $detail_panel


func _ready():
	event_bus.listen(EventConst.SHOW_ENEMY_PANEL, _on_ent_show_enemy_panel)

func set_player_unit(p_value):
	player_unit = p_value
	
	simple_panel.set_player_unit(player_unit)
	detail_panel.set_player_unit(player_unit)

func set_unit(p_value):
	unit = p_value
	if unit:
		var damage = player_unit.get_unit_hand_combat_damage(unit)
		if damage == INF:
			damage_label.text = "-∞"
		elif damage == 0:
			damage_label.text = "0"
		else:
			damage_label.text = str(-damage)

func open():
	event_bus.emit_signal(EventConst.ENABLE_BLUR)
	fight_btn.grab_focus()
	show()

func close():
	fight_btn.release_focus()
	hide()
	event_bus.emit_signal(EventConst.DISABLE_BLUR)

func _on_ent_show_enemy_panel(p_unit):
	unit = p_unit
	
	simple_panel.set_enemy_unit(unit)
	detail_panel.set_enemy_unit(unit)
	open()


func _on_exit_btn_pressed() -> void:
	close()

func _on_hand_combat_btn_pressed() -> void:
	if player_unit.is_hand_combat_hp_enough(unit):
		player_unit.hand_combat(unit)
		close()
	else:
		hp_not_enough_popup.popup()


func _on_fight_btn_pressed() -> void:
	close()
	event_bus.emit_signal(EventConst.FIGHT, unit)

func _on_hp_not_enough_popup_yes_btn_pressed() -> void:
	player_unit.hand_combat(unit)
	close()


func _on_switch_btn_pressed() -> void:
	simple_panel.visible = !simple_panel.visible
	detail_panel.visible = !simple_panel.visible
