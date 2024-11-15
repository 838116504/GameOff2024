extends Skill
## 面前1格放置阱陷



func get_script_id() -> int:
	return 3

func execute(p_owner:Unit, _state):
	assert(p_owner.fight_scene)
	var targetX = p_owner.fight_x + p_owner.fight_direction
	if !p_owner.fight_scene.has_cell(targetX):
		return
	
	var trap = FightCellItemConst.FIGHT_CELL_ITEM_LIST[FightCellItemConst.FightCellItemId.TRAP].new()
	trap.damage_type = get_damage_type()
	trap.damage = get_damage(trap.damage_type)
	p_owner.fight_scene.add_cell_item(trap, targetX)
