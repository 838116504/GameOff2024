extends NinePatchRect

@onready var layer_label = get_layer_label()

func get_layer_label():
	return $layer_label

func set_player_unit(p_value:PlayerUnit):
	if p_value:
		layer_label.text  = str(p_value.layer) + "F"
		p_value.layer_changed.connect(_on_player_unit_layer_changed)

func _on_player_unit_layer_changed(p_layer):
	layer_label.text  = str(p_layer) + "F"
