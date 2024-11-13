extends MapItem
class_name Unit

signal died
signal hp_changed(p_hp)
signal fight_x_changed(p_x)
signal fight_direction_changed(p_dir)


var unit_id:int = 0 : set = set_unit_id
var faction_id:int = 1
var hp:int : set = set_hp
var next_operate:FightOperate = null
var fight_x:int : set = set_fight_x
var fight_direction:int = 1 : set = set_fight_direction
var fight_scene:FightScene = null
var fight_node:Node = null
var extra_def:int
var extra_spd:int
var def_rate:float
var extra_strike_hit_rate:float
var extra_thrust_hit_rate:float
var extra_slash_hit_rate:float
var strike_def_rate:float = 1.0
var thrust_def_rate:float = 1.0
var slash_def_rate:float = 1.0
var direction := Vector2.DOWN
var buff_manager := BuffManager.new()
var skill_state_list := []
var skill_slot_max_count:int = 3
var put_skill_state_list := []
var dead := false
var invincible_count:int = 0

var followed_unit = null
var follow_unit_list := []
var row : set = set_row



func get_unit_id() -> int:
	return unit_id

func get_map_item_name() -> String:
	return tr("UNIT_%d" % unit_id)

func set_unit_id(p_value):
	if unit_id == p_value:
		return
	
	unit_id = p_value
	row = table_set.unit.get_row(unit_id)

func set_hp(p_value):
	if hp == p_value:
		return
	
	hp = p_value
	hp_changed.emit(hp)
	if hp <= 0:
		die()

func die():
	if dead:
		return
	
	dead = true
	died.emit()

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

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		event_bus.emit_signal(EventConst.SHOW_UNIT_UI, self)

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

func put_skill(p_skillState):
	put_skill_state_list.append(p_skillState)

func execute_operate():
	assert(next_operate)
	
	buff_manager.stage_start()
	next_operate.execute()

func attack_operate():
	var op = AttackOperate.new()
	op.owner = self
	op.stage_count = put_skill_state_list.size()
	next_operate = op

func hand_combat_attack_operate(p_enemys:Array):
	var op = HandCombatAttackOperate.new()
	op.owner = self
	op.enemy_list = p_enemys
	op.stage_count = put_skill_state_list.size()
	next_operate = op

func move_left_operate():
	var op = MoveLeftOperate.new()
	op.owner = self
	next_operate = op.new()

func move_right_operate():
	var op = MoveRightOperate.new()
	op.owner = self
	next_operate = op.new()

func standby_operate():
	var op = StandbyOperate.new()
	op.owner = self
	next_operate = op.new()

func turn_operate():
	var op = TurnOperate.new()
	op.owner = self
	next_operate = op.new()

func put_skill_operate(p_skillState:SkillState):
	var op = PutSkillOperate.new()
	op.owner = self
	op.skill_state = p_skillState
	next_operate = op

func hit(p_attacker, p_type:SkillConst.DamageType, p_damage:int):
	if is_invincible():
		return
	
	var dam = p_damage - get_def()
	if dam <= 0:
		return
	
	var finalDam = dam * get_hit_rate(p_type)
	hp -= finalDam

func get_hit_rate(p_type:SkillConst.DamageType) -> float:
	if p_type == SkillConst.DamageType.RANDOM:
		p_type = randi_range(SkillConst.DamageType.STRIKE, SkillConst.DamageType.SLASH)
	
	match p_type:
		SkillConst.DamageType.STRIKE:
			return get_strike_hit_rate()
		SkillConst.DamageType.THRUST:
			return get_thrust_hit_rate()
		SkillConst.DamageType.SLASH:
			return get_slash_hit_rate()
	
	return 1.0

func round_start():
	buff_manager.round_start()
	
	for i in skill_state_list:
		i.round_start()
	

func show_operate():
	assert(next_operate)
	
	next_operate.show_operate()

func get_init_hp() -> int:
	if row:
		return row.hp
	
	return 1

func get_def() -> int:
	if row:
		return (row.def + extra_def) * def_rate
	
	return extra_def * def_rate

func get_strike_hit_rate() -> float:
	if row:
		return row.strike_hit_rate + extra_strike_hit_rate
	
	return extra_strike_hit_rate

func get_thrust_hit_rate() -> float:
	if row:
		return row.thrust_hit_rate + extra_thrust_hit_rate
	
	return extra_thrust_hit_rate

func get_slash_hit_rate() -> float:
	if row:
		return row.slash_hit_rate + extra_slash_hit_rate
	
	return extra_slash_hit_rate

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
	for skillState in skill_state_list:
		skillState.reset()

func create_node():
	var ret = preload("unit_node.tscn").instantiate()
	ret.unit = self
	node = ret
	return ret

func create_fight_node():
	return

func is_blocked() -> bool:
	return true

func is_invincible() -> bool:
	return invincible_count > 0

func get_data():
	var ret = {}
	ret.unit_id = unit_id
	
	return ret

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])

func has_skill_slot() -> bool:
	return skill_slot_max_count > skill_state_list.size()

func has_ready_skill() -> bool:
	for i in skill_state_list:
		if !i.is_cding():
			return true
	
	return false

func duplicate():
	var ret = Unit.new()
	ret.set_data(get_data())
	return ret

func is_dead() -> bool:
	return dead

static func create_by_id(p_id:int, p_followed_unit = null):
	var ret = Unit.new()
	ret.followed_unit = p_followed_unit
	ret.unit_id = p_id
	return ret
