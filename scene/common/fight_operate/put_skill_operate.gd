extends FightOperate
class_name PutSkillOperate

var skill_state:SkillState
var position:int

func get_id():
	return 4

func execute():
	owner.put_skill(skill_state, position)
	await owner.fight_scene.get_tree().create_timer(0.4).timeout
	owner.next_operate = null

func show_operate():
	pass
