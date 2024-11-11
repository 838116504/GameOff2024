extends MapItem
class_name Unit

enum DamageType { STRIKE = 0, THRUST = 1, SLASH = 2 }

signal died
signal hp_changed(p_hp)
signal fight_x_changed(p_x)
signal fight_direction_changed(p_dir)


var id:int = 0 : set = set_id
var faction_id:int = 1
var hp:int : set = set_hp
var next_operate
var fight_x:int : set = set_fight_x
var fight_direction:int = 1 : set = set_fight_direction
var fight_scene = null
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


var followed_unit = null
var follow_unit_list := []
var row : set = set_row



func get_id() -> int:
	return id

func get_map_item_name() -> String:
	return tr("UNIT_%d" % id)

func set_id(p_value):
	if id == p_value:
		return
	
	id = p_value
	row = table_set.unit.get_row(id)

func set_hp(p_value):
	if hp == p_value:
		return
	
	hp = p_value
	hp_changed.emit(hp)

func set_fight_x(p_value):
	if fight_x == p_value:
		return
	
	fight_x = p_value
	fight_x_changed.emit(fight_x)

func set_fight_direction(p_value):
	if fight_direction == p_value:
		return
	
	fight_direction = p_value
	fight_direction_changed.emit(fight_direction)

func set_row(p_value):
	if row == p_value:
		return
	
	row = p_value
	if row:
		hp = row.hp
		fight_x = row.fight_x
		if row.fight_dir == 1:
			fight_direction = 1
		else:
			fight_direction = -1
		
		skill_state_list.clear()
		for skillId in row.skill_id_list:
			var skill = Skill.create_by_id(skillId)
			var state = SkillState.new()
			state.skill = skill
			skill_state_list.append(state)
		
		if followed_unit == null:
			for i in row.follow_unit_id_list.size():
				var unit = Unit.create_by_id(row.follow_unit_id_list[i], self)
				unit.fight_x = row.follow_unit_fight_x_list[i]
				if row.follow_unit_fight_dir_list[i] == 1:
					unit.fight_direction = 1
				else:
					unit.fight_direction = -1
				follow_unit_list.append(unit)

func get_faction_id():
	if followed_unit != null:
		return followed_unit.faction_id
	
	return faction_id

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

func get_init_hp() -> int:
	if row:
		return row.hp
	
	return 1

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

func get_icon() -> Texture2D:
	if row:
		return load(DirConst.UNIT_IMG.path_join(row.image))
	
	return null

func get_fight_image() -> Texture2D:
	if row:
		return load(DirConst.UNIT_IMG.path_join(row.right_image))
	
	return null

func get_fight_map_id() -> int:
	if row:
		return row.fight_map_id
	
	return 0

func get_fight_map_cell_count() -> int:
	if row:
		return row.fight_map_cell
	
	return 4

func reset():
	pass

func create_node():
	var ret = preload("unit_node.tscn").instantiate()
	ret.unit = self
	return ret

func create_fight_node():
	return

func get_data():
	var ret = {}
	ret.id = id
	
	return ret

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])


static func create_by_id(p_id:int, p_followed_unit = null):
	var ret = Unit.new()
	ret.followed_unit = p_followed_unit
	ret.id = p_id
	return ret
