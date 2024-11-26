extends "property_view.gd"

var player_unit:PlayerUnit

func set_player_unit(p_value:PlayerUnit):
	if player_unit == p_value:
		return
	
	if player_unit:
		player_unit.hp_changed.disconnect(_on_player_unit_hp_changed)
	
	player_unit = p_value
	if player_unit:
		set_value(player_unit.get_hp())
		player_unit.hp_changed.connect(_on_player_unit_hp_changed)

func _on_player_unit_hp_changed(p_hp):
	set_value(p_hp)
