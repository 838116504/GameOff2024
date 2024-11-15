extends SkillEffect


func get_id() -> int:
	return 3

func attack(_attacker:Unit, p_victim:Unit, _type:SkillConst.DamageType, _damage:int, _blockable:bool):
	var buff = CannotMoveBuff.new()
	p_victim.buff_manager.add_buff(buff)
