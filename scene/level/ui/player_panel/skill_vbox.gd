extends VBoxContainer

const SkillPanelCntrScene = preload("skill_panel_cntr.tscn")

var player_unit:PlayerUnit

func set_player_unit(p_value):
	player_unit = p_value

func update():
	if player_unit == null:
		return
	
	if player_unit.skill_state_list.size() > get_child_count():
		var n = player_unit.skill_state_list.size() - get_child_count()
		for _i in n:
			var skillPanelCntr = SkillPanelCntrScene.instantiate()
			add_child(skillPanelCntr)
	
	for i in get_child_count():
		var child = get_child(i)
		if i >= player_unit.skill_state_list.size():
			child.hide()
			continue
		
		child.show()
		child.skill = player_unit.skill_state_list[i].skill
