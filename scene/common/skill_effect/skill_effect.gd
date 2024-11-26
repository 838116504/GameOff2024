extends RefCounted
class_name SkillEffect

func get_id() -> int:
	return 0

func get_effect_name() -> String:
	return tr("EFFECT_" + str(get_id()))

func get_description() -> String:
	return tr("EFFECT_DESC_" + str(get_id()))

func attack(_attacker:Unit, _victim:Unit, _type:SkillConst.DamageType, _damage:int, _blockable:bool):
	pass

func round_start(_skillState):
	pass

func execute(_owner, _skillState):
	pass
