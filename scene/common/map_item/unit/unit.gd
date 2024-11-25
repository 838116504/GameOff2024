extends MapItem
class_name Unit

const UnitFightNodeScene = preload("res://scene/common/map_item/unit/unit_fight_node.tscn")

signal died
signal be_hit(p_damage)
signal hp_changed(p_hp)
signal fight_x_changed(p_x)
signal fight_direction_changed(p_dir)
signal put_skill_state_list_changed(p_states)
signal next_operate_changed(p_op)


var unit_id:int = 0 : set = set_unit_id
var faction_id:int = 1
var hp:int : set = set_hp
var next_operate:FightOperate = null : set = set_next_operate
var fight_x:int : set = set_fight_x
var fight_direction:int = 1 : set = set_fight_direction
var fight_scene:FightScene = null
var fight_node:Node = null
var extra_def:int
var extra_spd:int
var def_rate:float = 1.0
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
var cannot_move_count:int = 0
var block_count:int = 0

var followed_unit = null
var follow_unit_list := []
var row : set = set_row
var fight_bt:BehaviorTree

func _init():
	buff_manager.owner = self

func get_unit_id() -> int:
	return unit_id

func get_map_item_name() -> String:
	return tr(row.name)

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
		
		fight_bt = BTConst.get_unit_bt(row.bt_id)

func get_faction_id():
	if followed_unit != null:
		return followed_unit.faction_id
	
	return faction_id

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.UNIT

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		event_bus.emit_signal(EventConst.SHOW_ENEMY_PANEL, self)

func can_attack() -> bool:
	return !put_skill_state_list.is_empty()

func attack():
	if !can_attack():
		return
	
	var skillState:SkillState = pop_skill()
	await skillState.execute(self)
	skillState.put = false

func move_left():
	if !can_move():
		return
	
	var targetX = fight_x - 1
	if !fight_scene.has_cell(targetX) || fight_scene.get_unit(targetX) != null:
		return
	
	fight_scene.move_unit(self, targetX)
	fight_node.play_animation(&"move")
	var tween = fight_node.create_tween()
	var moveTo = fight_scene.get_cell_center_x(targetX)
	tween.tween_property(fight_node, ^"position:x", moveTo, 0.4)
	await tween.finished
	
	fight_x = targetX

func move_right():
	if !can_move():
		return
	
	var targetX = fight_x + 1
	if !fight_scene.has_cell(targetX) || fight_scene.get_unit(targetX) != null:
		return
	
	fight_scene.move_unit(self, targetX)
	fight_node.play_animation(&"move")
	var tween = fight_node.create_tween()
	var moveTo = fight_scene.get_cell_center_x(targetX)
	tween.tween_property(fight_node, ^"position:x", moveTo, 0.4)
	await tween.finished
	
	fight_x = targetX


func standby():
	pass

func turn():
	fight_direction = -fight_direction

func put_skill(p_skillState:SkillState, p_pos = -1):
	if p_pos < 0:
		put_skill_state_list.append(p_skillState)
	else:
		put_skill_state_list.insert(p_pos, p_skillState)
	
	p_skillState.put = true
	put_skill_state_list_changed.emit(put_skill_state_list)

func swap_put_skill(p_posA:int, p_posB:int):
	var temp = put_skill_state_list[p_posA]
	put_skill_state_list[p_posA] = put_skill_state_list[p_posB]
	put_skill_state_list[p_posB] = temp
	put_skill_state_list_changed.emit(put_skill_state_list)

func erase_put_skill(p_skillState:SkillState):
	var find = put_skill_state_list.find(p_skillState)
	if find < 0:
		return
	
	put_skill_state_list.remove_at(find)
	put_skill_state_list_changed.emit(put_skill_state_list)

func pop_skill():
	if put_skill_state_list.is_empty():
		return null
	
	var ret = put_skill_state_list.pop_front()
	put_skill_state_list_changed.emit(put_skill_state_list)
	return ret

func execute_operate():
	assert(next_operate)
	
	buff_manager.stage_start()
	next_operate.execute()

func attack_operate():
	if !can_attack():
		return
	
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
	next_operate = op

func move_right_operate():
	var op = MoveRightOperate.new()
	op.owner = self
	next_operate = op

func move_front_operate():
	if fight_direction < 0:
		return move_left_operate()
	else:
		return move_right_operate()

func move_back_operate():
	if fight_direction < 0:
		return move_right_operate()
	else:
		return move_left_operate()

func standby_operate():
	var op = StandbyOperate.new()
	op.owner = self
	next_operate = op

func turn_operate():
	var op = TurnOperate.new()
	op.owner = self
	next_operate = op

func put_skill_operate(p_skillState:SkillState, p_pos = -1):
	var op = PutSkillOperate.new()
	op.owner = self
	op.skill_state = p_skillState
	op.position = p_pos
	next_operate = op

func hit(_attacker, p_type:SkillConst.DamageType, p_damage:int, p_blockable:bool = true):
	if is_blocking() && p_blockable:
		buff_manager.erase_buff(&"block")
		return
	
	if is_invincible():
		return
	
	var dam = p_damage - get_def()
	
	if dam <= 0:
		return
	
	var finalDam = int(dam * get_hit_rate(p_type))
	if finalDam != 0:
		@warning_ignore("narrowing_conversion")
		hp -= finalDam
		be_hit.emit(finalDam)

func get_hit_rate(p_type:SkillConst.DamageType) -> float:
	if p_type == SkillConst.DamageType.RANDOM:
		@warning_ignore("int_as_enum_without_cast")
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
	
	if fight_bt && fight_node:
		fight_node.run_bt(fight_bt)

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
	
	@warning_ignore("narrowing_conversion")
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

func get_fight_skin() -> String:
	if row:
		return row.skin
	
	return ""

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
	var ret = preload("unit_fight_node.tscn").instantiate()
	ret.unit = self
	fight_node = ret
	return ret

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
	return skill_slot_max_count > put_skill_state_list.size()

func has_skill(p_id:int) -> bool:
	for i in skill_state_list.size():
		if skill_state_list[i].skill.get_id() == p_id:
			return true
	
	return false

func has_ready_skill() -> bool:
	for i in skill_state_list:
		if !i.is_cding() && !i in put_skill_state_list:
			return true
	
	return false

func can_put_skill() -> bool:
	return has_skill_slot() && has_ready_skill()

func put_ready_skill_operate():
	for i in skill_state_list:
		if !i.is_cding() && !i in put_skill_state_list:
			put_skill_operate(i)
			return

@warning_ignore("native_method_override")
func duplicate(_subRes = false):
	var ret = Unit.new()
	ret.set_data(get_data())
	return ret

func is_dead() -> bool:
	return dead

func can_move() -> bool:
	return cannot_move_count <= 0

func is_blocking() -> bool:
	return block_count > 0

func set_next_operate(p_value):
	if next_operate == p_value:
		return
	
	next_operate = p_value
	next_operate_changed.emit(next_operate)

func is_face_enemy() -> bool:
	if !fight_scene:
		return false
	
	var targetX = fight_x + fight_direction
	while fight_scene.has_cell(targetX):
		var unit = fight_scene.get_unit(targetX)
		if unit && unit.faction_id != faction_id:
			return true
		
		targetX = targetX + fight_direction
	
	return false

func is_close_to_face_enemy() -> bool:
	if !fight_scene:
		return false
	
	var targetX = fight_x + fight_direction
	var unit = fight_scene.get_unit(targetX)
	return unit != null && unit.faction_id != faction_id

static func create_by_id(p_id:int, p_followed_unit = null):
	var ret = Unit.new()
	ret.followed_unit = p_followed_unit
	ret.unit_id = p_id
	return ret
