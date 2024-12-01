extends BackBufferCopy

func _ready():
	event_bus.listen(EventConst.ENABLE_BLUR, _on_ent_enable_blur)
	event_bus.listen(EventConst.DISABLE_BLUR, _on_ent_disable_blur)

func _on_ent_enable_blur():
	show()

func _on_ent_disable_blur():
	hide()
