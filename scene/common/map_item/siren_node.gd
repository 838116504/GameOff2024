extends Sprite2D

var item:MapItem
var map_view:MapView

func get_laser_head_tex_rect():
	return $laser_head_tex_rect

func get_left_laser() -> Control:
	return $left_laser

func get_right_laser() -> Control:
	return $right_laser

func get_up_laser() -> Control:
	return $up_laser

func get_down_laser() -> Control:
	return $down_laser


func _ready():
	update()

func set_map_view(p_value):
	if map_view:
		map_view.map.item_changed.disconnect(_on_map_item_changed)
		map_view.map.item_moved.disconnect(_on_map_item_moved)
	
	map_view = p_value
	
	if map_view:
		map_view.map.item_changed.connect(_on_map_item_changed)
		map_view.map.item_moved.connect(_on_map_item_moved)
		update()

# 检查移除门
func _on_map_item_changed(p_layer:int, p_pos:Vector2i):
	if map_view.current_layer != p_layer:
		return
	
	if map_view.map.get_item(p_layer, p_pos) != null:
		return
	
	if item.position.x == p_pos.x:
		if p_pos.y < item.position.y:
			update_up_laser()
		else:
			update_down_laser()
	elif item.position.y == p_pos.y:
		if p_pos.x < item.position.x:
			update_left_laser()
		else:
			update_right_laser()

func _on_map_item_moved(p_layer:int, _from:Vector2i, p_to:Vector2i):
	if map_view.current_layer != p_layer:
		return
	
	if item.position.x != p_to.x && item.position.y != p_to.y:
		return
	
	var it = map_view.map.get_item(p_layer, p_to)
	if it == null:
		return
	
	if it.get_map_item_id() != MapItemConst.MapItemId.PLAYER_UNIT:
		return
	
	if item.position.x == p_to.x:
		if p_to.y < item.position.y:
			update_up_laser()
		else:
			update_down_laser()
	elif item.position.y == p_to.y:
		if p_to.x < item.position.x:
			update_left_laser()
		else:
			update_right_laser()

func update_up_laser():
	var l = item.position.y
	for i in range(item.position.y - 1, -1, -1):
		var pos = Vector2i(item.position.x, i)
		if map_view.map.is_tile_blocked(map_view.current_layer, pos):
			l = item.position.y - i
			break
		
		var it = map_view.map.get_item(map_view.current_layer, pos)
		if it == null:
			continue
		
		match it.get_map_item_id():
			MapItemConst.MapItemId.YELLOW_DOOR, MapItemConst.MapItemId.BLUE_DOOR, \
					MapItemConst.MapItemId.RED_DOOR, MapItemConst.MapItemId.SIREN:
				l = item.position.y - i
				break
			MapItemConst.MapItemId.PLAYER_UNIT:
				trigger()
				return
	
	if l <= 0:
		hide_up_laser()
	else:
		show_up_laser(l)

func update_down_laser():
	var l = 14 - item.position.y
	for i in range(item.position.y + 1, 15):
		var pos = Vector2i(item.position.x, i)
		if map_view.map.is_tile_blocked(map_view.current_layer, pos):
			l = i - item.position.y
			break
		
		var it = map_view.map.get_item(map_view.current_layer, pos)
		if it == null:
			continue
		
		match it.get_map_item_id():
			MapItemConst.MapItemId.YELLOW_DOOR, MapItemConst.MapItemId.BLUE_DOOR, \
					MapItemConst.MapItemId.RED_DOOR, MapItemConst.MapItemId.SIREN:
				l = i - item.position.y
				break
			MapItemConst.MapItemId.PLAYER_UNIT:
				trigger()
				return
	
	if l <= 0:
		hide_down_laser()
	else:
		show_down_laser(l)

func update_left_laser():
	var l = item.position.x
	for i in range(item.position.x - 1, -1, -1):
		var pos = Vector2i(i, item.position.y)
		if map_view.map.is_tile_blocked(map_view.current_layer, pos):
			l = item.position.x - i
			break
		
		var it = map_view.map.get_item(map_view.current_layer, pos)
		if it == null:
			continue
		
		match it.get_map_item_id():
			MapItemConst.MapItemId.YELLOW_DOOR, MapItemConst.MapItemId.BLUE_DOOR, \
					MapItemConst.MapItemId.RED_DOOR, MapItemConst.MapItemId.SIREN:
				l = item.position.x - i
				break
			MapItemConst.MapItemId.PLAYER_UNIT:
				trigger()
				return
	
	if l <= 0:
		hide_left_laser()
	else:
		show_left_laser(l)

func update_right_laser():
	var l = 14 - item.position.x
	for i in range(item.position.x + 1, 15):
		var pos = Vector2i(i, item.position.y)
		if map_view.map.is_tile_blocked(map_view.current_layer, pos):
			l = i - item.position.x
			break
		
		var it = map_view.map.get_item(map_view.current_layer, pos)
		if it == null:
			continue
		
		match it.get_map_item_id():
			MapItemConst.MapItemId.YELLOW_DOOR, MapItemConst.MapItemId.BLUE_DOOR, \
					MapItemConst.MapItemId.RED_DOOR, MapItemConst.MapItemId.SIREN:
				l = i - item.position.x
				break
			MapItemConst.MapItemId.PLAYER_UNIT:
				trigger()
				return
	
	if l <= 0:
		hide_right_laser()
	else:
		show_right_laser(l)

func trigger():
	pass

func update():
	if map_view == null || !is_node_ready():
		return
	
	get_laser_head_tex_rect().hide()
	update_up_laser()
	update_down_laser()
	update_left_laser()
	update_right_laser()

func hide_left_laser():
	get_left_laser().hide()

func show_left_laser(p_len):
	var leftLaser = get_left_laser()
	leftLaser.custom_minimum_size.x = p_len * map_view.get_cell_size().x
	leftLaser.show()
	get_laser_head_tex_rect().show()

func hide_right_laser():
	get_right_laser().hide()

func show_right_laser(p_len):
	var rightLaser = get_right_laser()
	rightLaser.custom_minimum_size.x = p_len * map_view.get_cell_size().x
	rightLaser.show()
	get_laser_head_tex_rect().show()

func hide_up_laser():
	get_up_laser().hide()

func show_up_laser(p_len):
	var upLaser = get_up_laser()
	upLaser.custom_minimum_size.x = p_len * map_view.get_cell_size().x
	upLaser.show()
	get_laser_head_tex_rect().show()

func hide_down_laser():
	get_down_laser().hide()

func show_down_laser(p_len):
	var downLaser = get_down_laser()
	downLaser.custom_minimum_size.x = p_len * map_view.get_cell_size().x
	downLaser.show()
	get_laser_head_tex_rect().show()
