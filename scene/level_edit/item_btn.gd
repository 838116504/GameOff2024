extends TextureButton

signal right_pressed

var item : set = set_item

func get_center():
	return $center


func _gui_input(p_event:InputEvent):
	if p_event is InputEventMouseButton && p_event.button_index == MOUSE_BUTTON_RIGHT:
		if p_event.is_released():
			right_pressed.emit()

func set_item(p_item:MapItem):
	assert(p_item != null)
	item = p_item
	var node = item.create_node()
	get_center().add_child(node)
