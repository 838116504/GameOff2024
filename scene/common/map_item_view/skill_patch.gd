extends NinePatchRect

var skill:Skill : set = set_skill


func get_icon_tex_rect():
	return $icon_tex_rect

func get_strike_tex_rect():
	return $damage_hbox/strike_tex_rect

func get_strike_label():
	return $damage_hbox/strike_label

func get_thrust_tex_rect():
	return $damage_hbox/thrust_tex_rect

func get_thrust_label():
	return $damage_hbox/thrust_label

func get_slash_tex_rect():
	return $damage_hbox/slash_tex_rect

func get_slash_label():
	return $damage_hbox/slash_label

func get_random_tex_rect():
	return $damage_hbox/random_tex_rect

func get_random_label():
	return $damage_hbox/random_label

func get_cd_hbox():
	return $cd_panel_cntr/cd_hbox


func set_skill(p_value):
	skill = p_value
	update()

func update():
	if skill == null:
		return
	
	var iconTexRect = get_icon_tex_rect()
	iconTexRect.texture = skill.get_icon()
	
	var damType = skill.get_damage_type()
	if damType >= 0:
		var dam = skill.get_damage(damType)
		var damTexRects = [ get_strike_tex_rect(), get_thrust_tex_rect(), get_slash_tex_rect(), get_random_tex_rect() ]
		var damLabels = [ get_strike_label(), get_thrust_label(), get_slash_label(), get_random_label() ]
		damTexRects[damType].show()
		damLabels[damType].text = str(dam)
		damLabels[damType].show()
	
	var cdHbox = get_cd_hbox()
	cdHbox.set_max_value(skill.get_cd())
	cdHbox.set_value(skill.get_cd())
	
	mouse_filter = MOUSE_FILTER_STOP
	tooltip_text = "%s\n%s" % [ skill.get_skill_name(), skill.get_description() ]
