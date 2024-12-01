extends Skill
## 攻擊面前front_distance格和背後back_distance格內距離最近的count個人

@export var front_distance:int = 1
@export var back_distance:int = 1
@export var count:int = 2

func get_script_id() -> int:
	return 4

func execute(p_owner:Unit, p_state):
	super(p_owner, p_state)
	
	if (front_distance <= 0 && back_distance <= 0) || count <= 0:
		return
	
	var restCount = count
	var targets = []
	var damTypes = []
	var attackId:int = 0
	var endSignal = null
	for i in range(1, front_distance + 1):
		var targetX = p_owner.fight_x + p_owner.fight_direction * i
		if !p_owner.fight_scene.has_cell(targetX):
			break
		
		var unit = p_owner.fight_scene.get_unit(targetX)
		if unit != null:
			var damType = get_final_damage_type()
			match damType:
				SkillConst.DamageType.STRIKE:
					endSignal = p_owner.fight_node.play_strike_animation(targetX, attackId)
				SkillConst.DamageType.THRUST:
					endSignal = p_owner.fight_node.play_ammo_animation(targetX, attackId)
				SkillConst.DamageType.SLASH:
					endSignal = p_owner.fight_node.play_slash_animation(targetX, attackId)
			attackId += 1
			targets.append(unit)
			damTypes.append(damType)
			restCount -= 1
			if restCount <= 0:
				break
	
	if restCount <= 0:
		return
	
	for i in range(1, back_distance + 1):
		var targetX = p_owner.fight_x - p_owner.fight_direction * i
		if !p_owner.fight_scene.has_cell(targetX):
			break
		
		var unit = p_owner.fight_scene.get_unit(targetX)
		if unit != null:
			var damType = get_final_damage_type()
			match damType:
				SkillConst.DamageType.STRIKE:
					endSignal = p_owner.fight_node.play_strike_animation(targetX, attackId)
				SkillConst.DamageType.THRUST:
					endSignal = p_owner.fight_node.play_ammo_animation(targetX, attackId)
				SkillConst.DamageType.SLASH:
					endSignal = p_owner.fight_node.play_slash_animation(targetX, attackId)
			attackId += 1
			targets.append(unit)
			damTypes.append(damType)
			restCount -= 1
			if restCount <= 0:
				break
	
	if endSignal:
		await endSignal
	
	for i in targets.size():
		attack(targets[i], p_owner, damTypes[i])

func get_max_attack_target() -> int:
	return count

func set_skill_arg(p_arg):
	if p_arg.size() > 0:
		front_distance = p_arg[0]
		if p_arg.size() > 1:
			back_distance = p_arg[1]
		if p_arg.size() > 2:
			count = p_arg[2]
