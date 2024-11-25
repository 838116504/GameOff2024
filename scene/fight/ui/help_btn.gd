extends Button

func _pressed():
	event_bus.emit_signal(EventConst.SHOW_HELP_POPUP)
