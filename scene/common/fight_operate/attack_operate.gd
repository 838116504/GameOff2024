extends FightOperate
class_name AttackOperate

var stage_count:int

func execute():
	pass

func show_operate():
	pass

func get_stage_count() -> int:
	return stage_count

func is_action_first() -> bool:
	return !owner.skill_state_list.is_empty() && owner.skill_state_list[0].skill.is_action_first()