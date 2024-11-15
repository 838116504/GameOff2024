extends SkillEffect


func get_id() -> int:
	return 5

func execute(p_owner:Unit, _skillState):
	p_owner.buff_manager.add_buff(BlockBuff.new())
