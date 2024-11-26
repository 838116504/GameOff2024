extends "property_view.gd"

var player_unit:PlayerUnit

func set_player_unit(p_value:PlayerUnit):
	if player_unit == p_value:
		return
	
	if player_unit:
		player_unit.spd_changed.disconnect(_on_player_unit_spd_changed)
	
	player_unit = p_value
	if player_unit:
		set_value(player_unit.get_spd())
		player_unit.spd_changed.connect(_on_player_unit_spd_changed)

func _on_player_unit_spd_changed(p_spd):
	set_value(p_spd)
