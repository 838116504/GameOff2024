extends BackBufferCopy

func _ready():
	event_bus.listen(EventConst.FIGHT_SCENE_ENABLE_BLUR, _on_ent_fight_scene_enable_blur)
	event_bus.listen(EventConst.FIGHT_SCENE_DISABLE_BLUR, _on_ent_fight_scene_disable_blur)

func _on_ent_fight_scene_enable_blur():
	show()

func _on_ent_fight_scene_disable_blur():
	hide()
