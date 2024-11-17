extends FightOperate
class_name AttackOperate

var stage_count:int

func get_id():
	return 5

func execute():
	await owner.attack()
	
	if owner.put_skill_state_list.is_empty():
		owner.next_operate = null

func show_operate():
	pass

func get_stage_count() -> int:
	return stage_count

func is_action_first() -> bool:
	return !owner.skill_state_list.is_empty() && owner.skill_state_list[0].skill.is_action_first()
