extends Control

var player_unit:PlayerUnit : set = set_player_unit

func get_property_vbox():
	return $property_vbox

func get_layer_patch():
	return $layer_patch

func get_item_vbox():
	return $item_vbox

func set_player_unit(p_value):
	if player_unit == p_value:
		return
	
	player_unit = p_value
	if player_unit:
		for child in get_property_vbox().get_children():
			if child.has_method("set_player_unit"):
				child.set_player_unit(player_unit)
		
		get_layer_patch().set_player_unit(player_unit)
		
		for child in get_item_vbox().get_children():
			if child.has_method("set_player_unit"):
				child.set_player_unit(player_unit)
