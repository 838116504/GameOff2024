extends Control

signal confirmed

func _notification(p_what:int) -> void:
	if p_what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			grab_focus()
		else:
			release_focus()

func _gui_input(_event):
	get_tree().root.set_input_as_handled()

func _on_confirm_btn_pressed() -> void:
	confirmed.emit()
