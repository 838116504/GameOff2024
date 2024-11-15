extends Skill
## 移動到最前的空地，攻擊路徑上的的人


func get_script_id() -> int:
	return 5

func execute(p_owner:Unit, p_state):
	super(p_owner, p_state)
	
	var moveX = p_owner.fight_scene.get_final_empty_cell(p_owner.fight_x, p_owner.fight_direction)
	if moveX < 0:
		return
	
	for attackX in range(p_owner.fight_x + p_owner.fight_direction, moveX, p_owner.fight_direction):
		var unit = p_owner.fight_scene.get_unit(attackX)
		if unit == null:
			return
		
		attack(unit, p_owner)
	
	p_owner.fight_scene.move_unit(p_owner, moveX)

func get_max_attack_target() -> int:
	return 9
