extends Skill
## 攻擊面前distance格內距離最近的count個人

@export var distance:int = 1
@export var count:int = 1

func get_script_id() -> int:
	return 1

func execute(p_owner:Unit, p_state):
	super(p_owner, p_state)
	
	if distance <= 0 || count <= 0:
		return
	
	var restCount = count
	for i in range(1, distance + 1):
		var targetX = p_owner.fight_x + p_owner.fight_direction * i
		if !p_owner.fight_scene.has_cell(targetX):
			break
		
		var unit = p_owner.fight_scene.get_unit(targetX)
		if unit != null:
			attack(unit, p_owner)
			restCount -= 1
			if restCount <= 0:
				break

func get_max_attack_target() -> int:
	return count

func set_skill_arg(p_arg):
	if p_arg.size() > 0:
		distance = p_arg[0]
		if p_arg.size() > 1:
			count = p_arg[1]
