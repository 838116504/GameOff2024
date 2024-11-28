extends "property_view.gd"

var unit:Unit

func set_unit(p_value:Unit):
	if unit == p_value:
		return
	
	if unit:
		unit.spd_changed.disconnect(_on_unit_spd_changed)
	
	unit = p_value
	if unit:
		set_value(unit.get_spd())
		unit.spd_changed.connect(_on_unit_spd_changed)

func _on_unit_spd_changed(p_spd):
	set_value(p_spd)
