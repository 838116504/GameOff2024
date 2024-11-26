extends "property_view.gd"

var player_unit:PlayerUnit

func set_player_unit(p_value:PlayerUnit):
	if player_unit == p_value:
		return
	
	if player_unit:
		player_unit.thrust_hit_rate_changed.disconnect(_on_player_unit_thrust_hit_rate_changed)
	
	player_unit = p_value
	if player_unit:
		var hitRate = player_unit.get_thrust_hit_rate()
		if hitRate == 1.0:
			hide()
		else:
			show()
			set_value_string("%d%%" % (100 - int(hitRate * 100)))
		player_unit.thrust_hit_rate_changed.connect(_on_player_unit_thrust_hit_rate_changed)

func _on_player_unit_thrust_hit_rate_changed(p_rate:float):
	if p_rate == 1.0:
		hide()
	else:
		show()
		set_value_string("%d%%" % (100 - int(p_rate * 100)))
