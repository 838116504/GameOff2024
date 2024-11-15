extends Skill
## 攻擊面前最近的count個人

@export var count:int = 1



func get_script_id() -> int:
	return 2

func execute(p_owner:Unit, p_state):
	super(p_owner, p_state)
	
	if count <= 0:
		return
	
	var targetX = p_owner.fight_x + p_owner.fight_direction
	var restCount = count
	while p_owner.fight_scene.has_cell(targetX):
		var unit = p_owner.fight_scene.get_unit(targetX)
		if unit != null:
			attack(unit, p_owner)
			restCount -= 1
			if restCount <= 0:
				break
		
		targetX += p_owner.fight_direction

func get_max_attack_target() -> int:
	return count

func set_skill_arg(p_arg):
	if p_arg.size() > 0:
		count = p_arg[0]
