extends Unit
class_name PlayerUnit

enum State { IDLE, MOVE, FIGHT }

class DataStack:
	var id:int
	var count:int = 1
	
	func _init(p_id, p_count:int):
		id = p_id
		count = p_count
	
	func get_data():
		return [id, count]
	
	func set_data(p_data):
		id = p_data[0]
		count = p_data[1]

signal data_count_changed(p_count:int)
signal yellow_key_count_changed(p_count:int)
signal blue_key_count_changed(p_count:int)
signal red_key_count_changed(p_count:int)
signal bug_count_changed(p_count:int)
signal layer_changed(p_layer:int)


var def:int
var strike_hit_rate:float = 1.0
var thrust_hit_rate:float = 1.0
var slash_hit_rate:float = 1.0
var spd:int
var data_stack_list := []
var data_count:int = 0 : set = set_data_count
var yellow_key_count:int = 0 : set = set_yellow_key_count
var blue_key_count:int = 0 : set = set_blue_key_count
var red_key_count:int = 0 : set = set_red_key_count
var bug_count:int = 0 : set = set_bug_count
var layer:int = 0 : set = set_layer
var cheat:Cheat
var passive_state:PassiveState : set = set_passive_state
var unit_hand_combat_damage_dict := {}
var state := State.IDLE
var item_name:String = "player"

var reached_layer:int = 0
var kill_count:int = 0

func add_data(p_id:int, p_count:int = 1):
	data_count += p_count
	for i in data_stack_list:
		if i.id == p_id:
			i.count += p_count
			return
	
	data_stack_list.append(DataStack.new(p_id, p_count))

func sub_data(p_id, p_count:int = 1):
	for i in data_stack_list.size():
		if data_stack_list[i].id == p_id:
			data_stack_list[i].count -= p_count
			if data_stack_list[i].count == 0:
				data_stack_list.remove_at(i)
			
			data_count -= p_count
			return

func set_data_count(p_value):
	if data_count == p_value:
		return
	
	data_count = p_value
	data_count_changed.emit(data_count)

func set_yellow_key_count(p_value):
	if yellow_key_count == p_value:
		return
	
	yellow_key_count = p_value
	yellow_key_count_changed.emit(yellow_key_count)

func set_blue_key_count(p_value):
	if blue_key_count == p_value:
		return
	
	blue_key_count = p_value
	blue_key_count_changed.emit(blue_key_count)

func set_red_key_count(p_value):
	if red_key_count == p_value:
		return
	
	red_key_count = p_value
	red_key_count_changed.emit(red_key_count)

func set_bug_count(p_value):
	if bug_count == p_value:
		return
	
	bug_count = p_value
	bug_count_changed.emit(bug_count)

func set_layer(p_layer):
	if layer == p_layer:
		return
	
	layer = p_layer
	reached_layer = max(layer, reached_layer)
	layer_changed.emit(layer)

func get_def() -> int:
	@warning_ignore("narrowing_conversion")
	return (def + extra_def) * def_rate

func get_strike_hit_rate():
	return strike_hit_rate + extra_strike_hit_rate

func get_thrust_hit_rate():
	return thrust_hit_rate + extra_thrust_hit_rate

func get_slash_hit_rate():
	return slash_hit_rate + extra_slash_hit_rate

func get_spd() -> int:
	return spd + extra_spd

func set_passive_state(p_value):
	passive_state = p_value
	if passive_state:
		passive_state.owner = self

func set_passive_by_id(p_id:int):
	passive_state = PassiveState.new()
	passive_state.passive = PassiveConst.PASSIVE_LIST[p_id].new()

func set_cheat_by_id(p_id:int):
	cheat = CheatConst.CHEAT_LIST[p_id].new()

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.PLAYER_UNIT

func get_map_item_name() -> String:
	return item_name

func reset():
	super()
	passive_state.reset()

func duplicate(_subRes = false):
	var ret = PlayerUnit.new()
	ret.set_data(get_data())
	return ret

func is_hand_combat_hp_enough(p_unit:Unit) -> bool:
	var uid = p_unit.get_unit_id()
	if !unit_hand_combat_damage_dict.has(uid):
		get_unit_hand_combat_damage(p_unit)
	
	var dams = unit_hand_combat_damage_dict[uid]
	var myUnits = [self] + follow_unit_list
	for i in myUnits.size():
		if myUnits[i].hp > dams[i]:
			return true
	
	return false

func hand_combat(p_unit:Unit):
	var uid = p_unit.get_unit_id()
	if !unit_hand_combat_damage_dict.has(uid):
		get_unit_hand_combat_damage(p_unit)
	
	var dams = unit_hand_combat_damage_dict[uid]
	var myUnits = [self] + follow_unit_list
	for i in myUnits.size():
		myUnits[i].hp -= dams[i]
	
	kill_count += 1
	map_view.erase_item(p_unit.position)

func get_unit_hand_combat_damage(p_unit:Unit):
	assert(p_unit != null)
	
	var uid = p_unit.get_unit_id()
	if unit_hand_combat_damage_dict.has(uid):
		var dam = 0
		for i in unit_hand_combat_damage_dict[uid]:
			if i == INF:
				return INF
			
			dam += i
		
		return dam
	
	var myUnits = [self] + follow_unit_list
	var enemyUnits = [p_unit] + p_unit.follow_unit_list
	
	var enemyHighestDef = 0
	for i in enemyUnits:
		enemyHighestDef = max(enemyHighestDef, i.get_def())
	var myHighestAtk = 0
	for i in myUnits:
		for s in i.skill_state_list:
			myHighestAtk = max(myHighestAtk, s.skill.get_damage(s.skill.get_damage_type()))
	
	if myHighestAtk <= enemyHighestDef:
		var dams = []
		for _i in myUnits:
			dams.append(INF)
		
		unit_hand_combat_damage_dict[uid] = dams
		
		return INF
	
	var startHps = []
	startHps.resize(myUnits.size())
	for i in myUnits.size():
		startHps[i] = myUnits[i].hp
		myUnits[i] = myUnits[i].duplicate()
	
	var tempMyUnits = myUnits.duplicate()
	for i in enemyUnits.size():
		enemyUnits[i] = enemyUnits[i].duplicate()
	
	var firstUnits:Array = []
	var orderUnits:Array = []
	var actionCount:int = 1
	while !myUnits.is_empty() && !enemyUnits.is_empty():
		actionCount = 1
		# unit's next operate
		for unit in myUnits + enemyUnits:
			unit.round_start()
			if unit.has_skill_slot() && unit.has_ready_skill():
				for skillState in unit.skill_state_list:
					if skillState.is_cding() || skillState in unit.put_skill_state_list || \
							skillState.skill.get_max_attack_target() <= 0:
						continue
					
					if skillState.skill.is_free_put():
						unit.put_skill(skillState)
						if !unit.has_skill_slot():
							break
					else:
						unit.put_skill_operate(skillState)
						break
					
			if unit.next_operate:
				continue
			
			if !unit.put_skill_state_list.is_empty():
				if unit in myUnits:
					unit.hand_combat_attack_operate(enemyUnits)
				else:
					unit.hand_combat_attack_operate(myUnits)
				actionCount = max(actionCount, unit.next_operate.get_stage_count())
		
		for i in actionCount:
			firstUnits.clear()
			orderUnits.clear()
			
			for unit in myUnits + enemyUnits:
				if unit.next_operate == null || i >= unit.next_operate.get_stage_count():
					continue
				
				var inserted := false
				var unitSpd = unit.get_spd()
				if unit.next_operate.is_action_first():
					for j in firstUnits.size():
						if firstUnits[j].get_spd() < unitSpd:
							inserted = true
							firstUnits.insert(j, unit)
							break
					if !inserted:
						firstUnits.append(unit)
				else:
					for j in orderUnits.size():
						if orderUnits[j].get_spd() < unitSpd:
							inserted = true
							orderUnits.insert(j, unit)
							break
					if !inserted:
						orderUnits.append(unit)
			
			for unit in firstUnits + orderUnits:
				unit.execute_operate()
		
		for i in range(myUnits.size() - 1, -1, -1):
			if myUnits[i].is_dead():
				myUnits.remove_at(i)
		
		for i in range(enemyUnits.size() - 1, -1, -1):
			if enemyUnits[i].is_dead():
				enemyUnits.remove_at(i)
	
	var loseHps = []
	loseHps.resize(tempMyUnits.size())
	var ret:int = 0
	for i in tempMyUnits.size():
		var diff = startHps[i] - max(tempMyUnits[i].hp, 0)
		loseHps[i] = diff
		ret += diff
	
	unit_hand_combat_damage_dict[uid] = loseHps
	
	return ret

func move_left():
	await super()
	
	if passive_state:
		passive_state.move_left()

func move_right():
	await super()
	
	if passive_state:
		passive_state.move_right()

func map_move(p_dir):
	if map_view == null:
		return
	
	state = State.MOVE
	if node:
		node.play_move_animation(p_dir)
	
	map_view.move_item(position, position + p_dir)
	await Engine.get_main_loop().create_timer(0.1, false).timeout
	state = State.IDLE

func set_unit_id(p_value):
	faction_id = 0
	unit_id = p_value
	row = table_set.player_unit.get_row(unit_id)

func set_row(p_value):
	if row == p_value:
		return
	
	row = p_value
	if row:
		hp = row.hp
		def = row.def
		strike_hit_rate = row.strike_hit_rate
		thrust_hit_rate = row.thrust_hit_rate
		slash_hit_rate = row.slash_hit_rate
		spd = row.spd
		
		skill_state_list.clear()
		for skillId in row.skill_id_list:
			var skill = Skill.create_by_id(skillId)
			var skillState = SkillState.new()
			skillState.skill = skill
			skill_state_list.append(skillState)
		
		cheat = CheatConst.CHEAT_LIST[row.cheat_id].new()
		passive_state = PassiveState.new()
		passive_state.passive = PassiveConst.PASSIVE_LIST[row.passive_id].new()

func input(p_event:InputEvent):
	match state:
		State.IDLE:
			if InputMap.event_is_action(p_event, &"left"):
				if p_event.is_pressed():
					map_move(Vector2i.LEFT)
			elif InputMap.event_is_action(p_event, &"right"):
				if p_event.is_pressed():
					map_move(Vector2i.RIGHT)
			elif InputMap.event_is_action(p_event, &"up"):
				if p_event.is_pressed():
					map_move(Vector2i.UP)
			elif InputMap.event_is_action(p_event, &"down"):
				if p_event.is_pressed():
					map_move(Vector2i.DOWN)
		State.FIGHT:
			pass

func get_icon() -> Texture2D:
	if row:
		return load(DirConst.PLAYER_IMG.path_join(row.image))
	
	return null

func get_fight_skin() -> String:
	if row:
		return row.skin
	
	return ""

func get_up_image() -> Texture2D:
	if row:
		return load(DirConst.PLAYER_IMG.path_join(row.back_image))
	
	return null

func get_down_image() -> Texture2D:
	return get_icon()

func get_right_image() -> Texture2D:
	if row:
		return load(DirConst.PLAYER_IMG.path_join(row.right_image))
	
	return null

func get_data():
	var ret = { "unit_id":unit_id, "hp":hp, "def":def, "strike_hit_rate":strike_hit_rate, "thrust_hit_rate":thrust_hit_rate, "slash_hit_rate":slash_hit_rate, 
			"spd":spd, "faction_id":faction_id, "data_count":data_count, 
			"yellow_key_count":yellow_key_count, "blue_key_count":blue_key_count, "red_key_count":red_key_count, 
			"bug_count":bug_count, "layer":layer, "position":position, "reached_layer":reached_layer, "kill_count":kill_count }
	
	var dataStackDatas = []
	dataStackDatas.resize(data_stack_list.size())
	for i in data_stack_list.size():
		dataStackDatas[i] = data_stack_list[i].get_data()
	
	ret.data_stack_data_list = dataStackDatas
	
	var skillDatas = []
	skillDatas.resize(skill_state_list.size())
	for i in skill_state_list.size():
		skillDatas[i] = skill_state_list[i].skill.get_data()
	
	ret.skill_data_list = skillDatas
	
	var followUnitDatas = []
	followUnitDatas.resize(follow_unit_list.size())
	for i in follow_unit_list.size():
		followUnitDatas[i] = follow_unit_list[i].get_data()
	
	ret.follow_unit_data_list = followUnitDatas
	
	return ret

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	if p_data.has("unit_id"):
		set_unit_id(p_data.unit_id)
		p_data.erase("unit_id")
	
	if p_data.has("data_stack_data_list"):
		var datas = p_data.data_stack_data_list
		data_stack_list.resize(datas.size())
		for i in data_stack_list.size():
			data_stack_list[i] = DataStack.new(0, 0)
			data_stack_list[i].set_data(datas[i])
		
		p_data.erase("data_stack_data_list")
	
	if p_data.has("skill_data_list"):
		var datas = p_data.skill_data_list
		skill_state_list.resize(datas.size())
		for i in skill_state_list.size():
			skill_state_list[i] = SkillState.new()
			var skill = SkillConst.SKILL_LIST[datas[i].script_id].new()
			datas[i].erase("script_id")
			skill.set_data(datas[i])
			skill_state_list[i].skill = skill
		
		p_data.erase("skill_data_list")
	
	if p_data.has("follow_unit_data_list"):
		var datas = p_data.follow_unit_data_list
		follow_unit_list.resize(datas.size())
		for i in follow_unit_list.size():
			follow_unit_list[i] = PlayerUnit.new()
			follow_unit_list[i].set_data(datas[i])
			follow_unit_list[i].followed_unit = self
		
		p_data.erase("follow_unit_data_list")
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])

func _mouse_entered():
	pass

func _mouse_exited():
	pass
