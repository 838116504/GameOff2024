extends RefCounted
class_name SkillConst

enum DamageType { STRIKE = 0, THRUST = 1, SLASH = 2, RANDOM = 4 }

enum SkillId {
	SKILL, ATTACK_FRONT_SKILL,
}

const SKILL_LIST = [
	preload("res://scene/common/skill/skill.gd"),
	preload("res://scene/common/skill/attack_front_skill.gd")
]
