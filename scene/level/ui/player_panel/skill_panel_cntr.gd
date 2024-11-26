extends PanelContainer

@export var skill:Skill : set = set_skill

func get_skill_patch():
	return $hbox/skill_patch

func get_name_label():
	return $hbox/vbox/name_label

func get_desc_label():
	return $hbox/vbox/desc_label


func set_skill(p_value):
	assert(p_value)
	
	skill = p_value
	var skillPatch = get_skill_patch()
	var nameLabel = get_name_label()
	var descLabel = get_desc_label()
	skillPatch.skill = skill
	nameLabel.text = skill.get_skill_name()
	descLabel.text = skill.get_description()
