extends Control

signal yes_btn_pressed

func popup():
	show()


func _on_yes_btn_pressed() -> void:
	hide()
	yes_btn_pressed.emit()

func _on_no_btn_pressed() -> void:
	hide()
