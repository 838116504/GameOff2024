extends BaseScene
class_name FightScene

var cell_count:int = 0 : set = set_cell_count
var fight_map:FightMap : set = set_fight_map
var cell_unit_list := [  ]
var cell_items_list := [ ]
# format = [ [ faction 0 unitA, ... ], [ faction 1 unitB, ...] ]
var faction_unit_list := []
var cell_width:int = 160

func get_bg_tex_rect():
	return $bg_tex_rect

func get_cell_root() -> Control:
	return $cell_root

func get_unit_root() -> Control:
	return $cell_root/unit_root


func round_start():
	pass

func show_stage():
	pass

func execute_stage():
	pass

func has_cell(p_x:int) -> bool:
	return p_x > 0 && p_x < cell_count

func get_unit(p_x:int) -> Unit:
	if !has_cell(p_x):
		return null
	
	return cell_unit_list[p_x]

func _add_unit(p_unit:Unit, p_x:int):
	cell_unit_list[p_x] = p_unit
	p_unit.fight_x = p_x
	p_unit.fight_scene = self
	p_unit.died.connect(_on_unit_died.bind(p_unit))
	var fightNode = p_unit.create_fight_node()
	fightNode.position.x = get_cell_center_x(p_x)
	
	var unitRoot = get_unit_root()
	unitRoot.add_child(fightNode)
	
	if faction_unit_list.size() <= p_unit.faction_id:
		for i in range(faction_unit_list.size(), p_unit.faction_id + 1):
			faction_unit_list.append([])
	
	faction_unit_list[p_unit.faction_id].append(p_unit)
	set_cell_faction(p_x, p_unit.faction_id)
	for item in cell_items_list[p_x]:
		item._unit_entered(p_unit)

func _on_unit_died(p_unit:Unit):
	if cell_unit_list[p_unit.fight_x] == p_unit:
		cell_unit_list[p_unit.fight_x] = null
	
	faction_unit_list[p_unit.faction_id].erase(p_unit)
	if faction_unit_list[p_unit.faction_id].is_empty():
		check_gameover()

func check_gameover():
	pass

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

func get_cell_center_x(p_x:int) -> float:
	return 0.5 * (size.x - cell_width * cell_count + cell_width) + p_x * cell_width

func set_cell_faction(p_x:int, p_factionId:int):
	if !has_cell(p_x):
		return
	
	assert(fight_map)
	var cellRoot = get_cell_root()
	var cellTexRect = cellRoot.get_child(p_x)
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
	for child in cellRoot.get_children():
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
		if cellRoot.get_child_count() < cell_count:
			update_cell_count()
		else:
			for child in cellRoot.get_children():
				child.texture = fight_map.cell_texture
		
		get_bg_tex_rect().texture = fight_map.bg_texture

func move_unit(p_unit:Unit, p_x:int):
	cell_unit_list[p_unit.fight_x] = null
	cell_unit_list[p_x] = p_unit
	p_unit.fight_node.position.x = get_cell_center_x(p_x)
	
	for item in cell_items_list[p_x]:
		item._unit_entered(p_unit)


func swap_unit(p_a:Unit, p_b:Unit):
	var aX = p_a.fight_x
	var bX = p_b.fight_x
	cell_unit_list[aX] = p_b
	cell_unit_list[bX] = p_a
	p_a.fight_node.position.x = get_cell_center_x(bX)
	p_b.fight_node.position.x = get_cell_center_x(aX)
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
