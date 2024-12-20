extends Node2D

const CountLabelScene = preload("res://scene/common/map_item/unit/count_label.tscn")

var unit:Unit : set = set_unit

@onready var sprite = get_sprite()

func get_sprite() -> Sprite2D:
	return $sprite


func set_unit(p_unit:Unit):
	unit = p_unit
	
	if unit:
		get_sprite().texture = unit.get_icon()
		if unit.get_map_item_id() == MapItemConst.MapItemId.UNIT:
			if !unit.follow_unit_list.is_empty():
				var countLabel = CountLabelScene.instantiate()
				countLabel.text = str(unit.follow_unit_list.size() + 1)
				add_child(countLabel)
				countLabel.offset_left = 35 - 4
				countLabel.offset_top = -35
				countLabel.offset_right = countLabel.offset_left
				countLabel.offset_bottom = countLabel.offset_top


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
