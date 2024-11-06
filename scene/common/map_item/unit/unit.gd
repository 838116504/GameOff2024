extends MapItem
class_name Unit

enum DamageType { STRIKE = 0, THRUST = 1, SLASH = 2 }

signal died
signal hp_changed

var faction_id:int = 1
var hp:int
var next_operate
var fight_x:int
var fight_direction:int = 1
var fight_scene = null
var fight_map_id:int
var extra_strike_def:int
var extra_thrust_def:int
var extra_slash_def:int
var strike_def_rate:float
var thrust_def_rate:float
var slash_def_rate:float
var direction := Vector2.DOWN
var buff_manager := BuffManager.new()
var skill_state_list := []



func _mouse_entered():
	pass

func _mouse_exited():
	pass

func _pressed():
	pass

func attack():
	pass

func move_left():
	pass

func move_right():
	pass

func move_up():
	pass

func move_down():
	pass

func standby():
	pass

func turn():
	pass

func put_skill(_skillState):
	pass

func execute_operate():
	pass

func attack_operate():
	pass

func move_left_operate():
	pass

func move_right_operate():
	pass


func standby_operate():
	pass

func turn_operate():
	pass

func put_skill_operate(p_skillState:SkillState):
	pass

func hit(p_attacker, p_type:DamageType, p_damage:int):
	pass

func round_start():
	for i in skill_state_list:
		i.round_start()
	

func show_operate():
	pass

func get_strike_def():
	return

func get_thrust_def():
	return

func get_slash_def():
	return

func reset():
	pass

func create_fight_node():
	return

func get_edit_property_list() -> Array:
	return [ {"name":"fight_x", "type":TYPE_INT, "hint":PROPERTY_HINT_RANGE, "hint_string":"0,9" }, 
			{"name":"fight_direction", "type":TYPE_INT, "hint":PROPERTY_HINT_ENUM, "hint_string":"VALUE_LEFT,VALUE_RIGHT" },
	 ]
