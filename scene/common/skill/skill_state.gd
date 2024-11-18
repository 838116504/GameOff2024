extends RefCounted
class_name SkillState

signal cd_changed(p_cd:int)
signal extra_attack_changed(p_exAtk)
signal put_changed(p_put)

var cd:int : set = set_cd
var skill:Skill : set = set_skill
var charge_count:int = 0
var extra_attack:int = 0 : set = set_extra_attack
var put := false : set = set_put

func is_cding() -> bool:
	return cd < skill.get_cd()

func execute(p_owner):
	await skill.execute(p_owner, self)
	cd = 0

func round_start():
	if !is_cding():
		return
	
	cd += 1
	if put:
		var effects = skill.get_effect_list()
		for effect in effects:
			effect.round_start(self)


func set_skill(p_skill):
	skill = p_skill
	
	if skill:
		cd = skill.get_cd()

func set_cd(p_value):
	if cd == p_value:
		return
	
	cd = p_value
	cd_changed.emit(cd)

func reset():
	cd = skill.get_cd()
	charge_count = 0
	extra_attack = 0

func set_extra_attack(p_value):
	if extra_attack == p_value:
		return
	
	extra_attack = p_value
	extra_attack_changed.emit(extra_attack)

func set_put(p_value):
	if put == p_value:
		return
	
	put = p_value
	if !put:
		extra_attack = 0
	
	put_changed.emit(put)
