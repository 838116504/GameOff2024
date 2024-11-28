extends Panel

var anim_playing := false
@onready var skill_vbox = get_skill_vbox()

func get_name_label():
	return $name_label

func get_vbox():
	return $scroll_cntr/vbox

func get_skill_vbox():
	return $scroll_cntr/vbox/skill_vbox


func _ready():
	event_bus.listen(EventConst.SHOW_PLAYER_PANEL, _on_ent_show_player_panel)

func _gui_input(_event: InputEvent) -> void:
	get_tree().root.set_input_as_handled()


func _on_ent_show_player_panel(p_playerUnit):
	set_player_unit(p_playerUnit)
	open()

func set_player_unit(p_value:PlayerUnit):
	var nameLabel = get_name_label()
	nameLabel.text = p_value.get_map_item_name()
	var vbox = get_vbox()
	for child in vbox.get_children():
		if child.has_method("set_unit"):
			child.set_unit(p_value)
		elif child.has_method("set_player_unit"):
			child.set_player_unit(p_value)

func open():
	if anim_playing || visible:
		return
	
	skill_vbox.update()
	event_bus.emit_signal(EventConst.ENABLE_BLUR)
	grab_focus()
	show()
	anim_playing = true
	var tween = create_tween()
	scale = Vector2.ZERO
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.2)
	await tween.finished
	anim_playing = false
	event_bus.listen(EventConst.BLUR_PRESSED, _on_ent_blur_pressed)

func close():
	if anim_playing || !visible:
		return
	
	event_bus.unlisten(EventConst.BLUR_PRESSED, _on_ent_blur_pressed)
	anim_playing = true
	var tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ZERO, 0.15)
	await tween.finished
	anim_playing = false
	release_focus()
	hide()
	event_bus.emit_signal(EventConst.DISABLE_BLUR)

func _on_ent_blur_pressed():
	close()
