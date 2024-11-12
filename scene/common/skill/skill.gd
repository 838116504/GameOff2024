extends Resource
class_name Skill

const DAMAGE_TEXT_LIST = [ "SKILL_DAMAGE_0", "SKILL_DAMAGE_1", "SKILL_DAMAGE_2", "SKILL_DAMAGE_3" ]

@export var id:int = 0 : set = set_id
var extra_damage:int = 0
var damage_rate:float = 1.0
var extra_cd:int = 0
var extra_effect_list := []
var row

func get_id() -> int:
	return id

func get_script_id() -> int:
	return 0

func set_id(p_value):
	if id == p_value:
		return
	
	id = p_value
	row = table_set.skill.get_row(get_id())

func execute(_owner, _state):
	pass

func get_skill_name() -> String:
	return tr(row.name)

func get_description() -> String:
	var damType = get_damage_type()
	if damType >= 0:
		return tr(row.description).format([["damage", DAMAGE_TEXT_LIST[damType] % get_damage(damType) ]])
	
	return tr(row.description)

func get_icon() -> Texture2D:
	return load(DirConst.SKILL_IMG.path_join(row.icon))

func get_cd():
	return max(row.cd + extra_cd, 0)

func get_strike_damage() -> float:
	if row.strike_damage == 0:
		return 0
	
	return (row.strike_damage + extra_damage) * damage_rate

func get_thrust_damage() -> float:
	if row.thrust_damage == 0:
		return 0
	
	return (row.thrust_damage + extra_damage) * damage_rate

func get_slash_damage() -> float:
	if row.slash_damage == 0:
		return 0
	
	return (row.slash_damage + extra_damage) * damage_rate

func get_random_damage() -> float:
	return (row.strike_damage + row.thrust_damage + row.slash_damage + extra_damage) * damage_rate

func get_strike_damage_rate() -> float:
	return row.strike_damage_rate

func get_thrust_damage_rate() -> float:
	return row.thrust_damage_rate

func get_slash_damage_rate() -> float:
	return row.slash_damage_rate

func get_damage_type():
	if row.random_damage_type != 0:
		return SkillConst.DamageType.RANDOM
	

func get_damage(p_type:SkillConst.DamageType) -> float:
	match p_type:
		SkillConst.DamageType.STRIKE:
			return get_strike_damage()
		SkillConst.DamageType.THRUST:
			return get_thrust_damage()
		SkillConst.DamageType.SLASH:
			return get_slash_damage()
		SkillConst.DamageType.RANDOM:
			return get_random_damage()
	
	return 0

func get_effect_list() -> Array:
	return [ row.effect_id ] + extra_effect_list

func get_charge_count() -> int:
	return row.charge_count

func round_start(_state):
	pass

func is_action_first() -> bool:
	return row.action_first != 0

func get_data():
	return { "script_id":get_script_id(), "id":id, "extra_damage":extra_damage, "damage_rate":damage_rate, "extra_cd":extra_cd }

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])

static func create_by_id(p_id:int):
	var ret = Skill.new()
	ret.id = p_id
	return ret
