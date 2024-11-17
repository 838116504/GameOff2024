extends Control

const RewardItemScene = preload("res://scene/fight/ui/win_ui/reward_item.tscn")

signal confirmed

@onready var hbox = get_hbox()

func get_hbox() -> HBoxContainer:
	return $bg_color_rect/hbox


func _notification(p_what:int) -> void:
	if p_what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			grab_focus()
		else:
			release_focus()

func _gui_input(_event):
	get_tree().root.set_input_as_handled()

func clear():
	for child in hbox.get_children():
		child.queue_free()
		hbox.remove_child(child)

func add_reward_unit_list(p_units):
	for i in p_units.size():
		var item = RewardItemScene.instantiate()
		item.set_icon(p_units[i].get_icon())
		hbox.add_child(item)


func _on_confirm_btn_pressed() -> void:
	confirmed.emit()
