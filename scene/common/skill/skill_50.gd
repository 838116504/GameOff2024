extends Skill
## 對雌小鬼造成X点隨机傷害。如果她的血量少于1500則這傷害雙倍


func get_script_id() -> int:
	return 6

func execute(p_owner:Unit, p_state):
	await super(p_owner, p_state)
	
	var targets = []
	var damTypes = []
	var endSignal = null
	var attackId:int = 0
	for i in p_owner.fight_scene.faction_unit_list.size():
		if i == p_owner.faction_id:
			continue
		
		for unit in p_owner.fight_scene.faction_unit_list[i]:
			if unit == null || unit is PlayerUnit:
				continue
			
			if unit.get_unit_id() == 50:
				var damType = get_final_damage_type()
				match damType:
					SkillConst.DamageType.STRIKE:
						endSignal = p_owner.fight_node.play_strike_animation(unit.fight_x, attackId)
					SkillConst.DamageType.THRUST:
						endSignal = p_owner.fight_node.play_ammo_animation(unit.fight_x, attackId)
					SkillConst.DamageType.SLASH:
						endSignal = p_owner.fight_node.play_slash_animation(unit.fight_x, attackId)
				attackId += 1
				targets.append(unit)
				damTypes.append(damType)
	
	if endSignal:
		await endSignal
	
	for i in targets.size():
		attack(targets[i], p_owner, damTypes[i])

func attack(p_target, p_attacker, p_finalDamType):
	var dam = get_damage()
	var blockable = is_blockable()
	if p_target.hp < 1500:
		dam *= 2
	
	p_target.hit(p_attacker, p_finalDamType, dam, blockable)
	for effect in get_effect_list():
		effect.attack(p_attacker, p_target, p_finalDamType, dam, blockable)

func get_max_attack_target() -> int:
	return 0
