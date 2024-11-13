extends FightOperate
class_name PutSkillOperate

var skill_state:SkillState

func execute():
	owner.put_skill(skill_state)

func show_operate():
	pass
