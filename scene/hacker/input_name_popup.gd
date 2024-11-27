extends ColorRect

signal ok_btn_pressed(p_lastName:String, p_firstName:String)

func get_last_name_edit():
	return $last_name_hbox/last_name_edit

func get_first_name_edit():
	return $first_name_hbox/first_name_edit

func get_accept_dialog() -> AcceptDialog:
	return $accept_dialog


func _on_ok_btn_pressed() -> void:
	var lastName = get_last_name_edit().text
	if lastName.is_empty():
		var acceptDialog = get_accept_dialog()
		acceptDialog.dialog_text = tr("HS_LAST_NAME_EMPTY")
		acceptDialog.popup_centered()
		return
	
	var firstName = get_first_name_edit().text
	if firstName.is_empty():
		var acceptDialog = get_accept_dialog()
		acceptDialog.dialog_text = tr("HS_FIRST_NAME_EMPTY")
		acceptDialog.popup_centered()
		return
	
	ok_btn_pressed.emit(lastName, firstName)
