extends Skill
## 雌小鬼附加50%易傷7回合


func get_script_id() -> int:
	return 7

func execute(p_owner:Unit, p_state):
	await super(p_owner, p_state)
	
	for i in p_owner.fight_scene.faction_unit_list.size():
		if i == p_owner.faction_id:
			continue
		
		for unit in p_owner.fight_scene.faction_unit_list[i]:
			if unit == null || unit is PlayerUnit:
				continue
			
			if unit.get_unit_id() == 50:
				unit.buff_manager.add_buff(VulnerableBuff.new())

func get_max_attack_target() -> int:
	return 0
