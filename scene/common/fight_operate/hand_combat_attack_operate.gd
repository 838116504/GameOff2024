extends FightOperate
class_name HandCombatAttackOperate

var enemy_list := []
var stage_count:int

func execute():
	var skillState = owner.put_skill_state_list.pop_front()
	if skillState:
		var skipCount:int = 0
		for i in skillState.skill.get_max_attack_target():
			var curI = i + skipCount
			if curI >= enemy_list.size():
				break
			
			if enemy_list[curI].is_dead():
				skipCount += 1
				curI += 1
				for j in range(curI, enemy_list.size()):
					if !enemy_list[j].is_dead():
						skipCount += 1
						curI += 1
					else:
						break
				
				if curI >= enemy_list.size():
					break
			
			skillState.skill.attack(enemy_list[curI], owner)
			skillState.cd = 0
		
		skillState.put = false
	
	if owner.put_skill_state_list.is_empty():
		owner.next_operate = null


func get_stage_count() -> int:
	return stage_count

func is_action_first() -> bool:
	return !owner.skill_state_list.is_empty() && owner.skill_state_list[0].skill.is_action_first()
