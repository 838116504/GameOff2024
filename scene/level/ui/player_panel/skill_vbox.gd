extends VBoxContainer

const SkillPanelCntrScene = preload("skill_panel_cntr.tscn")

var unit:Unit

func set_unit(p_value):
	if unit == p_value:
		return
	
	unit = p_value
	update()

func update():
	if unit == null:
		return
	
	if unit.skill_state_list.size() > get_child_count():
		var n = unit.skill_state_list.size() - get_child_count()
		for _i in n:
			var skillPanelCntr = SkillPanelCntrScene.instantiate()
			add_child(skillPanelCntr)
	
	for i in get_child_count():
		var child = get_child(i)
		if i >= unit.skill_state_list.size():
			child.hide()
			continue
		
		child.show()
		child.skill = unit.skill_state_list[i].skill
