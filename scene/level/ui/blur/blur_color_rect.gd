extends ColorRect

func _gui_input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseButton && p_event.button_index == MOUSE_BUTTON_LEFT:
		if p_event.is_released():
			event_bus.emit_signal(EventConst.BLUR_PRESSED)
