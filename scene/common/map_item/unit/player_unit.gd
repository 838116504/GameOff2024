extends Unit
class_name PlayerUnit

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
	layer_changed.emit(layer)

func get_def():
	return (def + extra_def) * def_rate

func get_strike_hit_rate():
	return strike_hit_rate + extra_strike_hit_rate

func get_thrust_hit_rate():
	return thrust_hit_rate + extra_thrust_hit_rate

func get_slash_hit_rate():
	return slash_hit_rate + extra_slash_hit_rate

func get_spd():
	return spd + extra_spd

func set_passive_state(p_value):
	passive_state = p_value
	if passive_state:
		passive_state.owner = self

func set_passive_by_id(p_id):
	passive_state = PassiveState.new()
	passive_state.passive = PassiveConst.PASSIVE_LIST[p_id].new()

func set_cheat_by_id(p_id):
	cheat = CheatConst.CHEAT_LIST[p_id].new()

func get_map_item_id() -> int:
	return MapItemConst.MapItemId.PLAYER_UNIT


func get_data():
	var ret = { "hp":hp, "def":def, "strike_hit_rate":strike_hit_rate, "thrust_hit_rate":thrust_hit_rate, "slash_hit_rate":slash_hit_rate, 
			"spd":spd, "faction_id":faction_id, "data_count":data_count, 
			"yellow_key_count":yellow_key_count, "blue_key_count":blue_key_count, "red_key_count":red_key_count, 
			"bug_count":bug_count, "layer":layer, "position":position }
	
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
			skill_state_list[i].skill = SkillConst.SKILL_LIST[datas[i].script_id].new()
			datas[i].erase("script_id")
			skill_state_list[i].skill.set_data(datas[i])
		
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
