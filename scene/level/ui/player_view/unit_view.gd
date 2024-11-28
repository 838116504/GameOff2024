extends Control

var player_unit:PlayerUnit

func get_icon_tex_rect():
	return $icon_tex_rect

func get_name_label():
	return $icon_tex_rect/name_label

func get_player_panel_btn():
	return $icon_tex_rect/name_label/player_panel_btn

func get_property_vbox():
	return $property_vbox

func set_player_unit(p_value):
	player_unit = p_value
	
	if player_unit:
		get_icon_tex_rect().texture = player_unit.get_icon()
		get_name_label().text = player_unit.get_map_item_name()
		get_player_panel_btn().player_unit = player_unit
	
	for child in get_property_vbox().get_children():
		if child.has_method("set_unit"):
			child.set_unit(player_unit)
