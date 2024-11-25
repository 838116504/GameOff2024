extends TextureButton


func _pressed():
	event_bus.emit_signal(EventConst.SHOW_DATA_PANEL)
