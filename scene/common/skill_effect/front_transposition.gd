extends SkillEffect

func get_id() -> int:
	return 6

func execute(p_owner:Unit, _skillState):
	var targetX = p_owner.fight_x + p_owner.fight_direction
	var unit = p_owner.fight_scene.get_unit(targetX)
	if unit == null:
		return
	
	p_owner.fight_scene.swap_unit(p_owner, unit)
