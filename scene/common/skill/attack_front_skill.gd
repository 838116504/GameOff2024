extends Skill
## 攻擊面前distance格內距離最近的一人

@export var distance:int = 1


func get_script_id() -> int:
	return 1

func execute(p_owner:Unit, _state):
	if distance <= 0:
		return
	
	for i in range(1, distance + 1):
		var targetX = p_owner.fight_x + p_owner.fight_direction * i
		if !p_owner.fight_scene.has_cell(targetX):
			break
		
		var unit = p_owner.fight_scene.get_unit(targetX)
		if unit != null:
			attack(unit, p_owner)
			break
