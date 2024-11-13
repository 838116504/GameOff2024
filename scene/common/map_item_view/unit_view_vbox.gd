extends VBoxContainer

const UnitPanelCntrScene = preload("res://scene/common/map_item_view/unit_panel_cntr.tscn")

var unit:Unit : set = set_unit
var player_unit:PlayerUnit : set = set_player_unit

func get_hand_combat_damage_patch():
	return $hand_combat_damage_patch

func get_hand_combat_damage_label():
	return $hand_combat_damage_patch/damage_label


func set_unit(p_value):
	unit = p_value
	update()

func update():
	if unit == null:
		return
	
	var units = [ unit ] + unit.follow_unit_list
	var n = get_child_count() - 1
	if units.size() < n:
		for _i in n - units.size():
			var child = get_child(1)
			remove_child(child)
			child.queue_free()
	elif units.size() > n:
		for _i in units.size() - n:
			var child = UnitPanelCntrScene.instantiate()
			add_child(child)
	
	for i in get_child_count() - 1:
		var child = get_child(i + 1)
		child.unit = units[i]
	
	if player_unit:
		var dam = player_unit.get_unit_hand_combat_damage(unit)
		var damageLabel = get_hand_combat_damage_label()
		if dam == INF:
			damageLabel.text = "∞"
		else:
			damageLabel.text = str(dam)

func set_player_unit(p_value:PlayerUnit):
	if player_unit == p_value:
		return
	
	player_unit = p_value
	get_hand_combat_damage_patch().visible = player_unit != null
