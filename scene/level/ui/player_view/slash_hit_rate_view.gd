extends "property_view.gd"

var unit:Unit

func set_unit(p_value:Unit):
	if unit == p_value:
		return
	
	if unit:
		if unit.has_signal("slash_hit_rate_changed"):
			unit.slash_hit_rate_changed.disconnect(_on_unit_slash_hit_rate_changed)
	
	unit = p_value
	if unit:
		var hitRate = unit.get_slash_hit_rate()
		if hitRate == 1.0:
			hide()
		else:
			show()
			set_value_string("%d%%" % (100 - int(hitRate * 100)))
		
		if unit.has_signal("slash_hit_rate_changed"):
			unit.slash_hit_rate_changed.connect(_on_unit_slash_hit_rate_changed)

func _on_unit_slash_hit_rate_changed(p_rate:float):
	if p_rate == 1.0:
		hide()
	else:
		show()
		set_value_string("%d%%" % (100 - int(p_rate * 100)))
