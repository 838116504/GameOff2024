extends Node

var player_unit:PlayerUnit

func _unhandled_input(p_event:InputEvent) -> void:
	if player_unit == null:
		return
	
	player_unit.input(p_event)
