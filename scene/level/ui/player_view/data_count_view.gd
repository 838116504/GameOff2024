extends Control

var player_unit:PlayerUnit

@onready var count_label = get_count_label()

func get_count_label():
	return $count_label

func set_player_unit(p_value:PlayerUnit):
	player_unit = p_value
	
	if player_unit:
		count_label.text = str(player_unit.data_count)
		visible = player_unit.data_count > 0
		player_unit.data_count_changed.connect(_on_player_unit_data_count_changed)

func _on_player_unit_data_count_changed(p_count):
	count_label.text = str(p_count)
	visible = p_count > 0
