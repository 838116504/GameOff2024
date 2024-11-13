extends PanelContainer

var unit:Unit : set = set_unit

func get_icon_tex_rect():
	return $hbox/icon_tex_rect

func get_name_label():
	return $hbox/vbox/name_label

func get_hp_value_label():
	return $hbox/vbox/hp_view/patch/value_label

func get_def_value_label():
	return $hbox/vbox/def_view/patch/value_label

func get_strike_def_value_label():
	return $hbox/vbox/strike_def_view/patch/value_label

func get_thrust_def_value_label():
	return $hbox/vbox/thrust_def_view/patch/value_label

func get_slash_def_value_label():
	return $hbox/vbox/slash_def_view/patch/value_label

func get_spd_value_label():
	return $hbox/vbox/spd_view/patch/value_label

func get_skill_vflow_cntr():
	return $hbox/vbox/skill_panel_cntr/vbox/skill_vflow_cntr


func set_unit(p_unit):
	unit = p_unit
	update()

func update():
	if unit == null:
		return
	
	get_icon_tex_rect().texture = unit.get_icon()
	get_name_label().text = unit.get_map_item_name()
	get_hp_value_label().text = str(unit.hp)
	get_def_value_label().text = str(unit.get_def())
	get_strike_def_value_label().text = "%0.1f%%" % (100.0 * unit.get_strike_hit_rate())
	get_thrust_def_value_label().text = "%0.1f%%" % (100.0 * unit.get_thrust_hit_rate())
	get_slash_def_value_label().text = "%0.1f%%" % (100.0 * unit.get_slash_hit_rate())
	get_spd_value_label().text = str(unit.get_spd())
	
	var skills = []
	skills.resize(unit.skill_state_list.size())
	for i in unit.skill_state_list.size():
		skills[i] = unit.skill_state_list[i].skill
	
	get_skill_vflow_cntr().set_skill_list(skills)
