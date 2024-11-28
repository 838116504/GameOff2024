extends Control

const RewardItemScene = preload("res://scene/fight/ui/win_ui/reward_item.tscn")

signal closed

func get_panel() -> Panel:
	return $panel

func get_reward_hbox() -> HBoxContainer:
	return $panel/reward_hbox


func set_reward_unit_list(p_units:Array):
	var rewardHbox = get_reward_hbox()
	if rewardHbox.get_child_count() < p_units.size():
		var n = p_units.size() - rewardHbox.get_child_count()
		for i in n:
			var item = RewardItemScene.instantiate()
			item.custom_minimum_size = Vector2(84, 94)
			rewardHbox.add_child(item)
	
	for i in rewardHbox.get_child_count():
		var child = rewardHbox.get_child(i)
		if i >= p_units.size():
			child.hide()
			continue
		
		child.set_icon(p_units[i].get_icon())
		child.show()
	
	get_panel().custom_minimum_size.x = max(96.0 * p_units.size() + 48, 200)

func open():
	show()
	grab_focus()
	var tween = create_tween()
	var panel = get_panel()
	panel.scale = Vector2.ZERO
	panel.pivot_offset.x = panel.custom_minimum_size.x * 0.5
	tween.tween_property(panel, "scale", Vector2.ONE, 0.2)

func close():
	
	release_focus()
	hide()


func _on_close_btn_pressed() -> void:
	close()
	closed.emit()
