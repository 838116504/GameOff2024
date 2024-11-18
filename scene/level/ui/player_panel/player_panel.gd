extends Panel


func _gui_input(_event: InputEvent) -> void:
	get_tree().root.set_input_as_handled()

func open():
	event_bus.emit_signal(EventConst.ENABLE_BLUR)
	grab_focus()
	show()

func close():
	release_focus()
	hide()
	event_bus.emit_signal(EventConst.DISABLE_BLUR)
