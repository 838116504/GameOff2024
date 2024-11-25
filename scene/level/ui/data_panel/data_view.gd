extends Panel


func get_tex_rect():
	return $tex_rect

func get_name_label():
	return $name_label


func set_data_stack(p_stack):
	var texRect = get_tex_rect()
	var nameLabel = get_name_label()
	texRect.texture = MapItemConst.get_unit_icon(p_stack.id)
	nameLabel.text = "%s x%d" % [MapItemConst.get_unit_name(p_stack.id), p_stack.count ]
