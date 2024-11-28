extends ColorRect

signal ok_btn_pressed(p_firstName:String)

func get_user_name_edit():
	return $user_name_hbox/user_name_edit

func get_accept_dialog() -> AcceptDialog:
	return $accept_dialog


func _on_ok_btn_pressed() -> void:
	var userName = get_user_name_edit().text
	if userName.is_empty():
		var acceptDialog = get_accept_dialog()
		acceptDialog.dialog_text = tr("HS_USER_NAME_EMPTY")
		acceptDialog.popup_centered()
		return
	
	ok_btn_pressed.emit(userName)
