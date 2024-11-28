extends Panel

var player_unit:PlayerUnit

@onready var left_unit_spine_list = [ 
		get_left_unit_spine(), get_left_unit2_spine(), get_left_unit3_spine(), get_left_unit4_spine(), get_left_unit5_spine() ]
@onready var right_unit_spine_list = [ 
		get_right_unit_spine(), get_right_unit2_spine(), get_right_unit3_spine(), get_right_unit4_spine(), get_right_unit5_spine() ]


func get_left_unit_spine() -> SpineSprite:
	return $left_unit_spine

func get_left_unit2_spine() -> SpineSprite:
	return $left_unit2_spine

func get_left_unit3_spine() -> SpineSprite:
	return $left_unit3_spine

func get_left_unit4_spine() -> SpineSprite:
	return $left_unit4_spine

func get_left_unit5_spine() -> SpineSprite:
	return $left_unit5_spine

func get_right_unit_spine() -> SpineSprite:
	return $right_unit_spine

func get_right_unit2_spine() -> SpineSprite:
	return $right_unit2_spine

func get_right_unit3_spine() -> SpineSprite:
	return $right_unit3_spine

func get_right_unit4_spine() -> SpineSprite:
	return $right_unit4_spine

func get_right_unit5_spine() -> SpineSprite:
	return $right_unit5_spine


func set_player_unit(p_value):
	player_unit = p_value

func set_enemy_unit(p_unit:Unit):
	var playerUnits = [player_unit] + player_unit.follow_unit_list
	for i in left_unit_spine_list.size():
		if i >= playerUnits.size():
			left_unit_spine_list[i].hide()
			continue
		
		var skel = left_unit_spine_list[i].get_skeleton()
		skel.set_skin_by_name(playerUnits[i].get_fight_skin())
		skel.set_slots_to_setup_pose()
		left_unit_spine_list[i].show()
	
	var enemyUnits = [p_unit] + p_unit.follow_unit_list
	for i in right_unit_spine_list.size():
		if i >= playerUnits.size():
			right_unit_spine_list[i].hide()
			continue
		
		var skel = right_unit_spine_list[i].get_skeleton()
		skel.set_skin_by_name(enemyUnits[i].get_fight_skin())
		skel.set_slots_to_setup_pose()
		right_unit_spine_list[i].show()
