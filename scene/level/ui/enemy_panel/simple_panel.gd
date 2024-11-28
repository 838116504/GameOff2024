extends Panel

signal unit_mouse_entered(p_unit)
signal unit_mouse_exited(p_unit)

var player_unit:PlayerUnit
var player_unit_list := []
var enemy_unit_list := []

var hover_unit : set = set_hover_unit


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


func _gui_input(p_event:InputEvent):
	if p_event is InputEventMouseMotion:
		var find := false
		if p_event.position.x < 450:
			for i in player_unit_list.size():
				if abs(left_unit_spine_list[i].position.x - p_event.position.x) < 31:
					if p_event.position.y < left_unit_spine_list[i].position.y && p_event.position.y > left_unit_spine_list[i].position.y - 140:
						find = true
						hover_unit = player_unit_list[i]
						break
		else:
			for i in enemy_unit_list.size():
				if abs(right_unit_spine_list[i].position.x - p_event.position.x) < 31:
					if p_event.position.y < right_unit_spine_list[i].position.y && p_event.position.y > right_unit_spine_list[i].position.y - 140:
						find = true
						hover_unit = enemy_unit_list[i]
						break
		
		if !find:
			hover_unit = null

func set_player_unit(p_value):
	player_unit = p_value
	if player_unit:
		player_unit_list = [player_unit] + player_unit.follow_unit_list

func set_enemy_unit(p_unit:Unit):
	for i in left_unit_spine_list.size():
		if i >= player_unit_list.size():
			left_unit_spine_list[i].hide()
			continue
		
		var skel = left_unit_spine_list[i].get_skeleton()
		skel.set_skin_by_name(player_unit_list[i].get_fight_skin())
		skel.set_slots_to_setup_pose()
		left_unit_spine_list[i].show()
	
	enemy_unit_list = [p_unit] + p_unit.follow_unit_list
	for i in right_unit_spine_list.size():
		if i >= enemy_unit_list.size():
			right_unit_spine_list[i].hide()
			continue
		
		var skel = right_unit_spine_list[i].get_skeleton()
		skel.set_skin_by_name(enemy_unit_list[i].get_fight_skin())
		skel.set_slots_to_setup_pose()
		right_unit_spine_list[i].show()

func set_hover_unit(p_unit):
	if hover_unit == p_unit:
		return
	
	if hover_unit:
		unit_mouse_exited.emit(hover_unit)
	
	hover_unit = p_unit
	
	if hover_unit:
		unit_mouse_entered.emit(hover_unit)
