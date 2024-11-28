extends Panel

signal unit_mouse_entered(p_unit)
signal unit_mouse_exited(p_unit)

var player_unit:PlayerUnit
var cell_unit_list := []

var hover_unit = null : set = set_hover_unit


func _gui_input(p_event:InputEvent):
	if p_event is InputEventMouseMotion:
		var find := false
		var maxY = get_child(0).position.y
		var minY = maxY - 140.0 * get_unit_scale()
		if p_event.position.y < maxY && p_event.position.y > minY:
			for i in cell_unit_list.size():
				if cell_unit_list[i] == null:
					continue
				
				var child = get_child(i)
				if child.position.x > p_event.position.x:
					break
				
				if child.position.x + child.size.x * child.scale.x > p_event.position.x:
					hover_unit = cell_unit_list[i]
					find = true
					break
		if !find:
			hover_unit = null

func set_player_unit(p_value):
	player_unit = p_value

func get_unit_scale() -> float:
	return 0.5 if cell_unit_list.size() > 5 else 1.0

func set_enemy_unit(p_unit:Unit):
	cell_unit_list.resize(p_unit.get_fight_map_cell_count())
	for unit in [p_unit] + p_unit.follow_unit_list:
		cell_unit_list[unit.fight_x] = unit
	
	var playerUnits = [player_unit] + player_unit.follow_unit_list
	var fightMap = FightMapConst.get_fight_map(p_unit.get_fight_map_id())
	var orderId = 0
	for unit in playerUnits:
		for i in range(orderId, fightMap.cell_order_list.size()):
			var x = fightMap.cell_order_list[i]
			if x >= cell_unit_list.size() || cell_unit_list[x] != null:
				continue
			
			cell_unit_list[x] = unit
			orderId = i + 1
			break
	
	var s:float = get_unit_scale()
	
	var cellDist = 140.0 * s + 20.0 
	for i in get_child_count():
		var child = get_child(i)
		if i >= cell_unit_list.size():
			child.hide()
			continue
		
		child.scale = Vector2.ONE * s
		child.position.x = (size.x - cellDist * cell_unit_list.size()) * 0.5 + cellDist * i
		if cell_unit_list[i] == null:
			child.texture = fightMap.cell_texture
			child.get_child(0).hide()
		else:
			child.texture = fightMap.faction_cell_texture_list[cell_unit_list[i].faction_id]
			var spine:SpineSprite = child.get_child(0)
			spine.scale.x = cell_unit_list[i].fight_direction
			var skel = spine.get_skeleton()
			skel.set_skin_by_name(cell_unit_list[i].get_fight_skin())
			skel.set_slots_to_setup_pose()
			spine.show()
		
		child.show()

func set_hover_unit(p_unit):
	if hover_unit == p_unit:
		return
	
	if hover_unit:
		unit_mouse_exited.emit(hover_unit)
	
	hover_unit = p_unit
	
	if hover_unit:
		unit_mouse_entered.emit(hover_unit)
