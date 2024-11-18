extends TextureButton

var player_unit:PlayerUnit

func _pressed():
	event_bus.emit_signal(EventConst.SHOW_PLAYER_PANEL, player_unit)
