extends VBoxContainer

const UnitPanelCntrScene = preload("res://scene/common/map_item_view/unit_panel_cntr.tscn")

var unit:Unit : set = set_unit

func set_unit(p_value):
	unit = p_value
	update()

func update():
	if unit == null:
		return
	
	var units = [ unit ] + unit.follow_unit_list
	var n = get_child_count()
	if units.size() < n:
		for _i in n - units.size():
			var child = get_child(0)
			remove_child(child)
			child.queue_free()
	elif units.size() > n:
		for _i in units.size() - n:
			var child = UnitPanelCntrScene.instantiate()
			add_child(child)
	
	for i in get_child_count():
		var child = get_child(i)
		child.unit = units[i]
