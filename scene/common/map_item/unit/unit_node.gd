extends Node2D

var unit:Unit : set = set_unit

@onready var sprite = get_sprite()

func get_sprite() -> Sprite2D:
	return $sprite


func set_unit(p_unit:Unit):
	unit = p_unit
	
	if unit:
		get_sprite().texture = unit.get_icon()

func play_move_animation(p_dir:Vector2i):
	sprite.flip_h = false
	if p_dir.x > 0:
		sprite.texture = unit.get_right_image()
	elif p_dir.x < 0:
		sprite.texture = unit.get_right_image()
		sprite.flip_h = true
	elif p_dir.y < 0:
		sprite.texture = unit.get_up_image()
	else:
		sprite.texture = unit.get_down_image()
