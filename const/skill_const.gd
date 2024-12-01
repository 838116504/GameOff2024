extends RefCounted
class_name SkillConst

enum DamageType { NONE = -1, STRIKE = 0, THRUST = 1, SLASH = 2, RANDOM = 3 }

enum SkillId {
	SKILL, ATTACK_FRONT_SKILL, RANGED_ATTACK_FORNT_SKILL, TRAP_SKILL, ATTACK_BOTH_SKILL, DASH_PATH_ATTACK_SKILL
}

enum SkillEffectId {
	REPEL = 1, OVERTURN, CANNOT_MOVE, ROUND_ADD_ATTACK, BLOCK, FRONT_TRANSPOSITION, TURN, DASH
}

const SKILL_LIST = [
	preload("res://scene/common/skill/skill.gd"),
	preload("res://scene/common/skill/attack_front_skill.gd"),
	preload("res://scene/common/skill/ranged_attack_front_skill.gd"),
	preload("res://scene/common/skill/trap_skill.gd"),
	preload("res://scene/common/skill/attack_both_skill.gd"),
	preload("res://scene/common/skill/dash_path_attack_skill.gd"),
	preload("res://scene/common/skill/skill_50.gd"),
	preload("res://scene/common/skill/skill_51.gd"),
	preload("res://scene/common/skill/skill_52.gd"),
]

const SKILL_EFFECT_LIST = [
	null,
	preload("res://scene/common/skill_effect/repel.gd"),
	preload("res://scene/common/skill_effect/overturn.gd"),
	preload("res://scene/common/skill_effect/cannot_move.gd"),
	preload("res://scene/common/skill_effect/round_add_attack.gd"),
	preload("res://scene/common/skill_effect/block.gd"),
	preload("res://scene/common/skill_effect/front_transposition.gd"),
	preload("res://scene/common/skill_effect/turn.gd"),
	preload("res://scene/common/skill_effect/dash.gd"),
]

static func create_skill_by_id(p_id:int):
	var row = table_set.skill.get_row(p_id)
	if row == null:
		return null
	
	var ret = SKILL_LIST[row.script_id].new()
	ret.set_id(p_id)
	
	return ret

static func create_skill_effect_by_id(p_id:int):
	if p_id < 0 || p_id >= SKILL_EFFECT_LIST.size():
		return null
	
	return SKILL_EFFECT_LIST[p_id].new()
