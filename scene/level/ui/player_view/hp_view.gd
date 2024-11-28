extends "property_view.gd"

var unit:Unit

func set_unit(p_value:Unit):
	if unit == p_value:
		return
	
	if unit:
		unit.hp_changed.disconnect(_on_unit_hp_changed)
	
	unit = p_value
	if unit:
		set_value(unit.get_hp())
		unit.hp_changed.connect(_on_unit_hp_changed)

func _on_unit_hp_changed(p_hp):
	set_value(p_hp)
