extends SkillEffect

func get_id() -> int:
	return 8

func execute(p_owner:Unit, _skillState):
	var x = p_owner.fight_scene.get_first_unit_cell(p_owner.fight_x, p_owner.fight_direction)
	if x >= 0:
		x -= p_owner.fight_direction
		if x == p_owner.fight_x:
			return
	else:
		x = p_owner.fight_scene.get_final_empty_cell(p_owner.fight_x, p_owner.fight_direction)
		if x < 0:
			return
	
	p_owner.fight_scene.move_unit(p_owner, x)
