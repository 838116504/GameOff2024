extends FightOperate
class_name PutSkillOperate

var skill_state:SkillState

func execute():
	owner.put_skill(skill_state)
	var curPutSkills = []
	for i in owner.put_skill_state_list:
		curPutSkills.append(i.skill.get_skill_name())
	print(owner, " put skill ", skill_state.skill.get_skill_name(), " skills = ", curPutSkills)
	owner.next_operate = null

func show_operate():
	pass
