extends Panel

const DataViewScene = preload("data_view.tscn")

var player_unit:PlayerUnit
var anim_playing := false

@onready var data_hflow_cntr = get_data_hflow_cntr()

func get_data_hflow_cntr():
	return $data_scroll_cntr/data_hflow_cntr


func _ready():
	event_bus.listen(EventConst.SHOW_DATA_PANEL, _on_ent_show_data_panel)

func _gui_input(_event: InputEvent) -> void:
	get_tree().root.set_input_as_handled()

func set_player_unit(p_value):
	player_unit = p_value


func _on_ent_show_data_panel():
	open()

func update():
	if player_unit == null:
		return
	
	if data_hflow_cntr.get_child_count() < player_unit.data_stack_list.size():
		var n = player_unit.data_stack_list.size() - data_hflow_cntr.get_child_count()
		for _i in n:
			var child = DataViewScene.instantiate()
			data_hflow_cntr.add_child(child)
	
	for i in data_hflow_cntr.get_child_count():
		var child = data_hflow_cntr.get_child(i)
		if i >= player_unit.data_stack_list.size():
			child.hide()
			continue
		
		child.set_data_stack(player_unit.data_stack_list[i])
		child.show()

func open():
	if anim_playing || visible:
		return
	
	update()
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
