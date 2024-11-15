extends SkillEffect


func get_id() -> int:
	return 4

func round_start(p_skillState:SkillState):
	p_skillState.extra_attack += 1
