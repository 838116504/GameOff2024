extends SkillEffect

func get_id() -> int:
	return 6

func execute(p_owner:Unit, _skillState):
	var targetX = p_owner.fight_x + p_owner.fight_direction
	var unit = p_owner.fight_scene.get_unit(targetX)
	if unit == null:
		return
	
	p_owner.fight_scene.swap_unit(p_owner, unit)
	var moveTween = p_owner.fight_node.create_tween()
	var finalOwnerX = p_owner.fight_scene.get_cell_center_x(targetX)
	var finalUnitX = p_owner.fight_scene.get_cell_center_x(p_owner.fight_x)
	moveTween.tween_property(p_owner.fight_node, "position:x", finalOwnerX, 0.2)
	moveTween.tween_property(unit.fight_node, "position:x", finalUnitX, 0.2)
	await moveTween.finished
	
	unit.fight_x = p_owner.fight_x
	p_owner.fight_x = targetX
