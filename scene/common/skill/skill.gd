extends Resource
class_name Skill

@export var id:int = 0 : set = set_id
var extra_damage:int = 0
var extra_cd:int = 0
var extra_effect_list := []
var row

func get_id() -> int:
	return id

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
	return tr(row.description)

func get_icon() -> Texture2D:
	return load(DirConst.SKILL_IMG.path_join(row.icon))

func get_cd():
	return max(row.cd + extra_cd, 0)

func get_strike_damage() -> float:
	return row.strike_damage

func get_thrust_damage() -> float:
	return row.thrust_damage

func get_slash_damage() -> float:
	return row.slash_damage

func get_strike_damage_rate() -> float:
	return row.strike_damage_rate

func get_thrust_damage_rate() -> float:
	return row.thrust_damage_rate

func get_slash_damage_rate() -> float:
	return row.slash_damage_rate

func get_effect_list() -> Array:
	return [ row.effect_id ] + extra_effect_list

func get_charge_count() -> int:
	return row.charge_count

func round_start(_state):
	pass

func is_action_first() -> bool:
	return row.action_first != 0

static func create_by_id(p_id:int):
	var ret = Skill.new()
	ret.id = p_id
	return ret
