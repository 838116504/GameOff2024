extends TextureButton

@export var level_id:int

func _pressed():
	event_bus.emit_signal(EventConst.SHOW_LEVEL_POPUP, level_id)
