extends SkillEffect


func get_id() -> int:
	return 1

func attack(p_attacker:Unit, p_victim:Unit, p_type:SkillConst.DamageType, p_damage:int, p_blockable:bool):
	var dir = -1 if p_attacker.fight_x > p_victim.fight_x else 1
	if !p_victim.fight_scene.has_cell(p_victim.fight_x + dir):
		return
	
	var emptyCell = p_victim.fight_x
	while p_victim.fight_scene.has_cell(emptyCell + dir) && p_victim.fight_scene.get_unit(emptyCell + dir) == null:
		emptyCell += dir
	
	var unit = p_victim.fight_scene.get_unit(emptyCell + dir)
	if unit:
		unit.hit(p_attacker, p_type, p_damage, p_blockable)
	
	if emptyCell == p_victim.fight_x:
		return
	
	p_victim.fight_scene.move_unit(p_victim, emptyCell)
