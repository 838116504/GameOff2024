extends Control

@onready var count_label = get_count_label()

func get_count_label():
	return $count_label

func set_player_unit(p_value:PlayerUnit):
	if p_value:
		count_label.text = str(p_value.yellow_key_count)
		visible = p_value.yellow_key_count > 0
		p_value.yellow_key_count_changed.connect(_on_player_unit_yellow_key_count_changed)

func _on_player_unit_yellow_key_count_changed(p_count):
	count_label.text = str(p_count)
	visible = p_count > 0
