extends Node2D

var unit:Unit : set = set_unit

func get_sprite():
	return $sprite


func set_unit(p_unit:Unit):
	unit = p_unit
	
	if unit:
		get_sprite().texture = unit.get_icon()
