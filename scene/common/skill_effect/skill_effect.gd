extends RefCounted
class_name SkillEffect

func get_id() -> int:
	return 0

func attack(_attacker:Unit, _victim:Unit, _type:SkillConst.DamageType, _damage:int, _blockable:bool):
	pass

func round_start(_skillState):
	pass

func execute(_owner, _skillState):
	pass
