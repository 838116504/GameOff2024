extends Resource
class_name Skill

const DAMAGE_TEXT_LIST = [ "SKILL_DAMAGE_0", "SKILL_DAMAGE_1", "SKILL_DAMAGE_2", "SKILL_DAMAGE_3" ]

@export var id:int = 0 : set = set_id
var extra_damage:int = 0
var damage_rate:float = 1.0
var extra_cd:int = 0
var extra_charge_count:int = 0
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
	if row:
		set_skill_arg(row.arg_list)

func set_skill_arg(_arg):
	pass

func execute(p_owner:Unit, p_state):
	for i in get_effect_list():
		i.execute(p_owner, p_state)

func get_skill_name() -> String:
	return tr(row.name)

func get_description() -> String:
	var damType = get_damage_type()
	var ret = ""
	var words = []
	if damType >= 0:
		ret = tr(row.description).format([["damage", tr(DAMAGE_TEXT_LIST[damType]) % get_damage() ]])
		if !is_blockable():
			words.append(tr("SKILL_UNABLE_BLOCK"))
	else:
		ret = tr(row.description)
	
	var effects = get_effect_list()
	for i in effects.size():
		words.append(effects[i].get_effect_name())
	
	if is_action_first():
		words.append(tr("SKILL_ACTION_FIRST"))
	if is_free_put():
		words.append(tr("SKILL_FREE_PUT"))
	if get_charge_count() > 0:
		words.append(tr("SKILL_CHARGE") % get_charge_count())
	
	if !words.is_empty():
		ret += "\n" + " ".join(PackedStringArray(words))
	
	return ret

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

func get_strike_damage_strengthen_rate() -> float:
	return row.strike_damage_rate

func get_thrust_damage_strengthen_rate() -> float:
	return row.thrust_damage_rate

func get_slash_damage_strengthen_rate() -> float:
	return row.slash_damage_rate

func get_damage_type():
	if row.random_damage_type != 0:
		return SkillConst.DamageType.RANDOM
	
	if row.strike_damage > 0:
		return SkillConst.DamageType.STRIKE
	
	if row.thrust_damage > 0:
		return SkillConst.DamageType.THRUST
	
	if row.slash_damage > 0:
		return SkillConst.DamageType.SLASH
	
	return SkillConst.DamageType.NONE

func get_final_damage_type():
	var ret = get_damage_type()
	if ret == SkillConst.DamageType.RANDOM:
		@warning_ignore("int_as_enum_without_cast")
		ret = randi_range(SkillConst.DamageType.STRIKE, SkillConst.DamageType.SLASH)
	return ret

func get_damage() -> float:
	var type = get_damage_type()
	match type:
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
	var ret = []
	var effectIds = [ ]
	if row.effect_id > 0:
		effectIds.append(row.effect_id)
	effectIds += extra_effect_list
	for i in effectIds:
		ret.append(SkillConst.create_skill_effect_by_id(i))
	
	return ret

func get_charge_count() -> int:
	return row.charge_count + extra_charge_count

func round_start(_state):
	pass

func is_action_first() -> bool:
	return row.action_first != 0

func is_blockable():
	return row.unable_block == 0

func is_free_put() -> bool:
	return row.free_put != 0

func get_max_attack_target() -> int:
	return 1

func attack(p_target, p_attacker, p_finalDamType):
	var dam = get_damage()
	var blockable = is_blockable()
	p_target.hit(p_attacker, p_finalDamType, dam, blockable)
	for effect in get_effect_list():
		effect.attack(p_attacker, p_target, p_finalDamType, dam, blockable)

func get_data():
	return { "id":id, "extra_damage":extra_damage, "damage_rate":damage_rate, 
			"extra_cd":extra_cd, "extra_charge_count":extra_charge_count }

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])

static func create_by_id(p_id:int):
	return SkillConst.create_skill_by_id(p_id)
