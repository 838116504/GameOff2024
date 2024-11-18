extends BaseScene
class_name FightScene

signal winned
signal losed


var cell_width:int = 160
var cell_count:int = 0 : set = set_cell_count
var fight_map:FightMap : set = set_fight_map
var cell_unit_list := []
var cell_items_list := []
var order_unit_list := []
# format = [ [ faction 0 unitA, ... ], [ faction 1 unitB, ...] ]
var faction_unit_list := []
var round_count:int = 0 : set = set_round_count

var player_unit:PlayerUnit
var enemy_unit:Unit

var current_unit:Unit = null : set = set_current_unit
var ended := false


@onready var unit_panel = get_unit_panel()
@onready var skill_panel_cntr = get_skill_panel_cntr()
@onready var round_label = get_round_label()
@onready var anim_player = get_anim_player()


func get_bg_tex_rect():
	return $bg_tex_rect

func get_cell_root() -> Control:
	return $cell_root

func get_unit_root() -> Control:
	return $cell_root/unit_root

func get_unit_panel():
	return $unit_panel

func get_skill_panel_cntr():
	return $skill_panel_cntr

func get_round_label():
	return $round_label

func get_anim_player() -> AnimationPlayer:
	return $anim_player

func get_win_ui():
	return $win_ui

func get_lose_ui():
	return $lose_ui


func _ready():
	super()
	
	if visible && player_unit == null:
		var playerUnit = PlayerUnit.new()
		playerUnit.set_unit_id(1)
		set_fight(playerUnit, Unit.create_by_id(1))

func _gui_input(p_event:InputEvent) -> void:
	get_tree().root.set_input_as_handled()
	
	if p_event is InputEventMouseMotion:
		if p_event.position.y > fight_map.cell_y || p_event.position.y < fight_map.cell_y - 130:
			unit_panel.unit = null
		else:
			var x = p_event.position.x - 0.5 * (size.x - cell_width * cell_count)
			if x < 0 || x > cell_width * cell_count:
				unit_panel.unit = null
				return
			 
			var cellId = int(x / cell_width)
			var unit = get_unit(cellId)
			if unit == null || abs(x - cellId * cell_width + 0.5 * cell_width) > 65:
				unit_panel.unit = null
				return
			
			unit_panel.unit = unit
	elif InputMap.event_is_action(p_event, &"left", true):
		if p_event.is_released():
			if current_unit == null:
				return
			
			current_unit.move_left_operate()
	elif InputMap.event_is_action(p_event, &"right", true):
		if p_event.is_released():
			if current_unit == null:
				return
			
			current_unit.move_right_operate()
	elif InputMap.event_is_action(p_event, &"up", true):
		if p_event.is_released():
			if current_unit == null:
				return
			
			current_unit.turn_operate()
	elif InputMap.event_is_action(p_event, &"down", true):
		if p_event.is_released():
			if current_unit == null:
				return
			
			current_unit.standby_operate()
	elif InputMap.event_is_action(p_event, &"attack", true):
		if p_event.is_released():
			if current_unit == null:
				return
			
			current_unit.attack_operate()

func round_start():
	order_unit_list.clear()
	
	for i in cell_unit_list:
		if i == null:
			continue
		
		i.round_start()
		
		var find = false
		for j in order_unit_list.size():
			if order_unit_list[j].get_spd() < i.get_spd():
				order_unit_list.insert(j, i)
				find = true
				break
		
		if !find:
			order_unit_list.append(i)
	
	for i in order_unit_list.size():
		order_unit_list[i].fight_node.show_order(i)
	
	for i in order_unit_list.size():
		if order_unit_list[i].next_operate != null:
			continue
		
		current_unit = order_unit_list[i]
		await current_unit.next_operate_changed
	
	current_unit = null
	execute_stage()

func show_stage():
	pass

func execute_stage():
	var actionCount:int = 1
	var firstUnits = []
	var orderUnits = []
	for i in order_unit_list.size():
		actionCount = max(actionCount, order_unit_list[i].next_operate.get_stage_count())
		if order_unit_list[i].next_operate.is_action_first():
			firstUnits.append(order_unit_list[i])
		else:
			orderUnits.append(order_unit_list[i])
	
	for i in actionCount:
		for unit in firstUnits + orderUnits:
			await unit.next_operate.execute()
			if ended:
				return
		
		if i + 1 < actionCount:
			firstUnits.clear()
			orderUnits.clear()
			for j in order_unit_list.size():
				if order_unit_list[j].next_operate == null:
					continue
				
				if order_unit_list[j].next_operate.is_action_first():
					firstUnits.append(order_unit_list[j])
				else:
					orderUnits.append(order_unit_list[j])
	
	round_count += 1
	round_start()

func has_cell(p_x:int) -> bool:
	return p_x >= 0 && p_x < cell_count

func get_unit(p_x:int) -> Unit:
	if !has_cell(p_x):
		return null
	
	return cell_unit_list[p_x]

func _add_unit(p_unit:Unit, p_x:int):
	assert(p_unit != null)
	
	cell_unit_list[p_x] = p_unit
	p_unit.fight_x = p_x
	p_unit.fight_scene = self
	p_unit.died.connect(_on_unit_died.bind(p_unit))
	var fightNode = p_unit.create_fight_node()
	
	var unitRoot = get_unit_root()
	unitRoot.add_child(fightNode)
	
	if faction_unit_list.size() <= p_unit.faction_id:
		for i in range(faction_unit_list.size(), p_unit.faction_id + 1):
			faction_unit_list.append([])
	
	faction_unit_list[p_unit.faction_id].append(p_unit)
	set_cell_faction(p_unit.fight_x, p_unit.faction_id)
	for item in cell_items_list[p_x]:
		item._unit_entered(p_unit)

func _on_unit_died(p_unit:Unit):
	if cell_unit_list[p_unit.fight_x] == p_unit:
		cell_unit_list[p_unit.fight_x] = null
	
	faction_unit_list[p_unit.faction_id].erase(p_unit)
	if faction_unit_list[p_unit.faction_id].is_empty():
		if p_unit.faction_id == player_unit.faction_id:
			lose()
		else:
			win()

func win():
	anim_player.play(&"win")
	await anim_player.animation_finished
	
	var winUI = get_win_ui()
	var units = [enemy_unit] + enemy_unit.follow_unit_list
	winUI.add_reward_unit_list(units)

func lose():
	anim_player.play(&"lose")

func _find_empty_cell() -> int:
	for i in fight_map.cell_order_list:
		var x = fight_map.cell_order_list[i]
		if x >= cell_count:
			continue
		
		if cell_unit_list[x] == null:
			return x
	
	return -1

func add_unit(p_unit:Unit):
	if cell_unit_list[p_unit.fight_x] == null:
		_add_unit(p_unit, p_unit.fight_x)
		return true
	
	var emptyCell = _find_empty_cell()
	if emptyCell < 0:
		return false
	
	_add_unit(p_unit, emptyCell)
	return true

func add_unit_with_map_order(p_unit:Unit):
	var emptyCell = _find_empty_cell()
	if emptyCell < 0:
		return false
	
	_add_unit(p_unit, emptyCell)
	return true

func clear():
	round_count = 0
	current_unit = null
	
	for i in cell_unit_list.size():
		if cell_unit_list[i] == null:
			continue
		
		cell_unit_list[i].fight_node = null
		cell_unit_list[i] = null
	
	faction_unit_list.clear()
	var unitRoot = get_unit_root()
	for i in unitRoot.get_children():
		i.queue_free()
		unitRoot.remove_child(i)
	
	ended = false
	var winUI = get_win_ui()
	winUI.hide()
	winUI.clear()
	get_lose_ui().hide()

func get_cell_center_x(p_x:int) -> float:
	return 0.5 * (size.x - cell_width * cell_count + cell_width) + p_x * cell_width

func set_cell_faction(p_x:int, p_factionId:int = -1):
	if !has_cell(p_x):
		return
	
	assert(fight_map)
	var cellRoot = get_cell_root()
	var cellTexRect = cellRoot.get_child(p_x + 1)
	if p_factionId < 0:
		cellTexRect.texture =  fight_map.cell_texture
	else:
		cellTexRect.texture = fight_map.faction_cell_texture_list[p_factionId]

func update_cell_count():
	cell_unit_list.resize(cell_count)
	cell_items_list.resize(cell_count)
	for i in cell_items_list.size():
		cell_items_list[i] = []
	
	var cellRoot = get_cell_root()
	for _i in range(1, cellRoot.get_child_count()):
		var child = cellRoot.get_child(1)
		cellRoot.remove_child(child)
		child.queue_free()
	
	for i in cell_count:
		var centerX = get_cell_center_x(i)
		var cellTexRect = TextureRect.new()
		cellRoot.add_child(cellTexRect)
		cellTexRect.grow_horizontal = Control.GROW_DIRECTION_BOTH
		cellTexRect.offset_left = centerX
		cellTexRect.offset_right = centerX
		cellTexRect.offset_bottom = 0
		if fight_map:
			cellTexRect.texture = fight_map.cell_texture

func set_cell_count(p_value):
	if cell_count == p_value:
		return
	
	cell_count = p_value
	update_cell_count()

func set_fight_map(p_value):
	fight_map = p_value
	
	if fight_map:
		var cellRoot = get_cell_root()
		cellRoot.offset_top = fight_map.cell_y
		if cellRoot.get_child_count() + 1 < cell_count:
			update_cell_count()
		else:
			for i in range(1, cellRoot.get_child_count()):
				var child = cellRoot.get_child(i)
				child.texture = fight_map.cell_texture
		
		get_bg_tex_rect().texture = fight_map.bg_texture

func set_fight(p_player:PlayerUnit, p_enemy:Unit):
	assert(p_player && p_enemy)
	clear()
	enemy_unit = p_enemy
	player_unit = p_player
	
	cell_count = enemy_unit.get_fight_map_cell_count()
	set_fight_map(FightMapConst.get_fight_map(enemy_unit.get_fight_map_id()))
	add_unit(enemy_unit)
	for unit in enemy_unit.follow_unit_list:
		add_unit(unit)
	
	player_unit.fight_x = fight_map.cell_order_list[0]
	add_unit(player_unit)
	for i in player_unit.follow_unit_list.size():
		player_unit.follow_unit_list[i].fight_x = fight_map.cell_order_list[i + 1]
		add_unit(player_unit.follow_unit_list[i])
	
	show()
	grab_focus()
	
	round_start()

func move_unit(p_unit:Unit, p_x:int):
	if !has_cell(p_x):
		return false
	
	cell_unit_list[p_unit.fight_x] = null
	set_cell_faction(p_unit.fight_x)
	cell_unit_list[p_x] = p_unit
	set_cell_faction(p_x, p_unit.faction_id)
	
	#p_unit.fight_node.position.x = get_cell_center_x(p_x)
	
	for item in cell_items_list[p_x]:
		item._unit_entered(p_unit)
	
	return true


func swap_unit(p_a:Unit, p_b:Unit):
	var aX = p_a.fight_x
	var bX = p_b.fight_x
	cell_unit_list[aX] = p_b
	set_cell_faction(aX, p_b.faction_id)
	cell_unit_list[bX] = p_a
	set_cell_faction(bX, p_a.faction_id)
	#p_a.fight_node.position.x = get_cell_center_x(bX)
	#p_b.fight_node.position.x = get_cell_center_x(aX)
	for item in cell_items_list[aX]:
		item._unit_entered(p_b)
	for item in cell_items_list[bX]:
		item._unit_entered(p_a)

func add_cell_item(p_item:FightCellItem, p_x:int):
	if !has_cell(p_x):
		return
	
	p_item.fight_scene = self
	p_item.fight_x = p_x
	cell_items_list[p_x].append(p_item)
	if cell_unit_list[p_x]:
		p_item._unit_entered(cell_unit_list[p_x])

func erase_cell_item(p_item:FightCellItem):
	cell_items_list[p_item.fight_x].erase(p_item)

func get_first_unit_cell(p_x:int, p_dir:int) -> int:
	var curX = p_x + p_dir
	while has_cell(curX):
		if get_unit(curX):
			return curX
		
		curX = p_x + p_dir
	
	return -1

func get_final_empty_cell(p_x:int, p_dir:int) -> int:
	var ret = -1
	var curX = p_x + p_dir
	while has_cell(curX):
		if get_unit(curX) == null:
			ret = curX
		
		curX = p_x + p_dir
	
	return ret

func set_current_unit(p_value):
	if current_unit == p_value:
		return
	
	if current_unit:
		current_unit.fight_node.current = false
	
	current_unit = p_value
	skill_panel_cntr.unit = current_unit
	if current_unit:
		current_unit.fight_node.current = true

func set_round_count(p_value):
	round_count = p_value
	round_label.text = tr("FS_ROUND_COUNT") + " : " + str(round_count)

func _on_skill_panel_cntr_skill_state_view_mouse_entered(_view) -> void:
	if current_unit:
		current_unit.fight_node.skill_hover = true

func _on_skill_panel_cntr_skill_state_view_mouse_exited(_view) -> void:
	if current_unit:
		current_unit.fight_node.skill_hover = false


func _on_skill_panel_cntr_dragging_view_changed(p_view) -> void:
	if current_unit:
		current_unit.fight_node.skill_dragging = p_view != null


func _on_win_ui_confirmed() -> void:
	release_focus()
	hide()
	winned.emit()


func _on_lose_ui_confirmed() -> void:
	release_focus()
	hide()
	losed.emit()
