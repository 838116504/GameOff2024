extends Control


var dialogue_row = null : set = set_dialogue_row
var dialogue_arg_list := []

@onready var avatar_tex_rect = get_avatar_tex_rect()
@onready var text_label = get_text_label()

func get_avatar_tex_rect():
	return $bg_patch/avatar_tex_rect

func get_text_label():
	return $bg_patch/text_label


func _gui_input(p_event:InputEvent):
	get_tree().root.set_input_as_handled()
	
	if p_event is InputEventMouseButton:
		if p_event.button_index == MOUSE_BUTTON_LEFT:
			if p_event.is_released():
				next()

func _notification(p_what: int) -> void:
	if p_what == NOTIFICATION_VISIBILITY_CHANGED:
		if is_visible_in_tree():
			grab_focus()
		else:
			release_focus()

func next():
	if text_label.is_playing():
		text_label.skip()
	else:
		if dialogue_row:
			if dialogue_row.skip_id == 0:
				set_dialogue_id(dialogue_row.id + 1)
			else:
				set_dialogue_id(dialogue_row.skip_id)
		else:
			dialogue_row = null

func set_dialogue_id(p_id:int):
	if p_id < 0:
		dialogue_row = null
		return
	
	dialogue_row = table_set.dialogue.get_row(p_id)

func set_dialogue_row(p_value):
	dialogue_row = p_value
	
	if dialogue_row:
		avatar_tex_rect.texture = load(DirConst.AVATAR_IMG.path_join(dialogue_row.avatar))
		text_label.play(tr(dialogue_row.text).format(dialogue_arg_list))
	else:
		event_bus.emit_signal(EventConst.HIDE_DIALOGUE)

func add_dialogue_arg(p_name:String, p_value):
	for i in dialogue_arg_list.size():
		if dialogue_arg_list[i][0] == p_name:
			dialogue_arg_list[i][1] = p_value
			return
	
	dialogue_arg_list.append([p_name, p_value])
