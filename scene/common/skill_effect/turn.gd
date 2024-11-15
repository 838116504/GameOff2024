extends SkillEffect

func get_id() -> int:
	return 7

func execute(p_owner:Unit, _skillState):
	p_owner.fight_direction = -p_owner.fight_direction
