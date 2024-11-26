extends PanelContainer

func get_name_label():
	return $vbox/name_label

func get_desc_label():
	return $vbox/desc_label

func set_player_unit(p_value:PlayerUnit):
	if p_value.passive_state:
		var nameLabel = get_name_label()
		var descLabel = get_desc_label()
		nameLabel.text = p_value.passive_state.passive.get_passive_name()
		descLabel.text = p_value.passive_state.passive.get_description()
	else:
		hide()
