extends Button

signal count_changed(p_count)
signal count_added
signal count_subbed

var data_stack : set = set_data_stack
var count:int = 0 : set = set_count


func get_icon_tex_rect():
	return $icon_tex_rect

func get_count_label():
	return $count_label


func _gui_input(p_event):
	if p_event is InputEventMouseButton:
		if p_event.button_index == MOUSE_BUTTON_RIGHT:
			if p_event.is_released():
				if count <= 0:
					return
				
				sub_count()

func _pressed():
	if count >= data_stack.count:
		return
	
	add_count()

func set_data_stack(p_value):
	data_stack = p_value
	
	if data_stack:
		get_icon_tex_rect().texture = MapItemConst.get_unit_icon(data_stack.id)
		
		update_count()

func add_count():
	count += 1
	count_added.emit()

func sub_count():
	count -= 1
	count_subbed.emit()

func set_count(p_value):
	if count == p_value:
		return
	
	count = p_value
	
	update_count()
	count_changed.emit(count)

func update_count():
	get_count_label().text = "%d/%d" % [ count, data_stack.count ]
