extends Skill
## 移動到最前的空地，攻擊路徑上的的人


func get_script_id() -> int:
	return 5

func execute(p_owner:Unit, p_state):
	super(p_owner, p_state)
	
	var moveX = p_owner.fight_scene.get_final_empty_cell(p_owner.fight_x, p_owner.fight_direction)
	if moveX < 0:
		return
	
	var targets = []
	var damTypes = []
	var attackId:int = 0
	for attackX in range(p_owner.fight_x + p_owner.fight_direction, moveX, p_owner.fight_direction):
		var unit = p_owner.fight_scene.get_unit(attackX)
		if unit == null:
			return
		
		var damType = get_final_damage_type()
		match damType:
			SkillConst.DamageType.STRIKE:
				p_owner.fight_node.play_strike_animation(attackX, attackId)
			SkillConst.DamageType.THRUST:
				p_owner.fight_node.play_ammo_animation(attackX, attackId)
			SkillConst.DamageType.SLASH:
				p_owner.fight_node.play_slash_animation(attackX, attackId)
		attackId += 1
		targets.append(unit)
		damTypes.append(damType)
	
	var moveTween = p_owner.fight_node.create_tween()
	var finalX = p_owner.fight_scene.get_cell_center_x(moveX)
	moveTween.tween_property(p_owner.fight_node, "position:x", finalX, 0.2)
	await moveTween.finished
	p_owner.fight_scene.move_unit(p_owner, moveX)
	
	for i in targets.size():
		attack(targets[i], p_owner, damTypes[i])

func get_max_attack_target() -> int:
	return 9
