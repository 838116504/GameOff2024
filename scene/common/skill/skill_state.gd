extends RefCounted
class_name SkillState

signal cd_changed(p_cd:int)

var cd:int : set = set_cd
var skill:Skill : set = set_skill
var charge_count:int = 0
var extra_attack:int = 0

func is_cding() -> bool:
	return cd < skill.get_cd()

func execute(p_owner):
	skill.execute(p_owner, self)
	cd = 0

func round_start():
	if !is_cding():
		return
	
	cd += 1


func set_skill(p_skill):
	skill = p_skill
	
	if skill:
		cd = skill.get_cd()

func set_cd(p_value):
	if cd == p_value:
		return
	
	cd = p_value
	cd_changed.emit(cd)
