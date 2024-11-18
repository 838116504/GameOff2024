extends BaseScene


func _on_level_edit_btn_pressed() -> void:
	var levelEditScene = load(ScenePathConst.LEVEL_EDIT_SCENE).instantiate()
	scene_transition.change_scene(levelEditScene, "fade_out", "fade_in")
