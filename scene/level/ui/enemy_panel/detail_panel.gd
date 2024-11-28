extends Panel

var player_unit:PlayerUnit




func set_player_unit(p_value):
	player_unit = p_value

func set_enemy_unit(p_unit:Unit):
	var cellUnits = []
	cellUnits.resize(p_unit.get_fight_map_cell_count())
	for unit in [p_unit] + p_unit.follow_unit_list:
		cellUnits[unit.fight_x] = unit
	
	var playerUnits = [player_unit] + player_unit.follow_unit_list
	var fightMap = FightMapConst.get_fight_map(p_unit.get_fight_map_id())
	var orderId = 0
	for unit in playerUnits:
		for i in range(orderId, fightMap.cell_order_list.size()):
			var x = fightMap.cell_order_list[i]
			if x >= cellUnits.size() || cellUnits[x] != null:
				continue
			
			cellUnits[x] = unit
			orderId = i + 1
			break
	
	var s:float = 1.0
	if cellUnits.size() > 5:
		s = 0.5
	
	var cellDist = 140.0 * s + 20.0 
	for i in get_child_count():
		var child = get_child(i)
		if i >= cellUnits.size():
			child.hide()
			continue
		
		child.scale = Vector2.ONE * s
		child.position.x = (size.x - cellDist * cellUnits.size()) * 0.5 + cellDist * i
		if cellUnits[i] == null:
			child.texture = fightMap.cell_texture
			child.get_child(0).hide()
		else:
			child.texture = fightMap.faction_cell_texture_list[cellUnits[i].faction_id]
			var spine:SpineSprite = child.get_child(0)
			var skel = spine.get_skeleton()
			skel.set_skin_by_name(cellUnits[i].get_fight_skin())
			skel.set_slots_to_setup_pose()
			spine.show()
		
		child.show()
