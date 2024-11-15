extends SkillEffect


func get_id() -> int:
	return 2

func attack(_attacker:Unit, p_victim:Unit, _type:SkillConst.DamageType, _damage:int, _blockable:bool):
	p_victim.fight_direction = -p_victim.fight_direction
