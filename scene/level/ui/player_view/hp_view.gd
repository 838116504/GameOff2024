extends Control

@onready var value_label = get_value_label()

func get_value_label() -> Label:
	return $patch/value_label


func set_player_unit(p_value:PlayerUnit):
	if p_value:
		value_label.text = str(p_value.hp)
		p_value.hp_changed.connect(_on_player_unit_hp_changed)

func _on_player_unit_hp_changed(p_hp):
	value_label.text = str(p_hp)
