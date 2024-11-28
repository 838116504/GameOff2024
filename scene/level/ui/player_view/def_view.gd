extends "property_view.gd"

var unit:Unit

func set_unit(p_value:Unit):
	if unit == p_value:
		return
	
	if unit:
		unit.def_changed.disconnect(_on_unit_def_changed)
	
	unit = p_value
	if unit:
		set_value(unit.get_def())
		unit.def_changed.connect(_on_unit_def_changed)

func _on_unit_def_changed(p_def):
	set_value(p_def)
