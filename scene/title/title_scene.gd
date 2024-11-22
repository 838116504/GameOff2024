extends BaseScene


func get_start_popup():
	return $start_popup


func _on_level_edit_btn_pressed() -> void:
	var levelEditScene = load(ScenePathConst.LEVEL_EDIT_SCENE).instantiate()
	scene_transition.change_scene(levelEditScene, "fade_out", "fade_in")


func _on_start_btn_pressed() -> void:
	get_start_popup().open()
