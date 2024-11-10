extends MapItem
class_name Unit

enum DamageType { STRIKE = 0, THRUST = 1, SLASH = 2 }

signal died
signal hp_changed


var id:int = 0 : set = set_id
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
var extra_spd:int
var strike_def_rate:float = 1.0
var thrust_def_rate:float = 1.0
var slash_def_rate:float = 1.0
var direction := Vector2.DOWN
var buff_manager := BuffManager.new()
var skill_state_list := []
var row



func get_id() -> int:
	return id

func set_id(p_value):
	if id == p_value:
		return
	
	id = p_value
	row = table_set.get_row(id)
	if row:
		hp = row.hp

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.UNIT

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
	if row:
		return (row.strike_def + extra_strike_def) * strike_def_rate
	
	return extra_strike_def * strike_def_rate

func get_thrust_def():
	if row:
		return (row.thrust_def + extra_thrust_def) * thrust_def_rate
	
	return extra_thrust_def * thrust_def_rate

func get_slash_def():
	if row:
		return (row.slash_def + extra_slash_def) * slash_def_rate
	
	return extra_slash_def * slash_def_rate

func get_spd():
	if row:
		return row.spd + extra_spd
	
	return extra_spd

func reset():
	pass

func create_fight_node():
	return
