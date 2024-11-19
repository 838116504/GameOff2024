extends PanelContainer

var map_item:MapItem : set = set_map_item

func get_icon_tex_rect():
	return $vbox/hbox/icon_tex_rect

func get_name_label():
	return $vbox/hbox/name_label

func get_desc_label():
	return $vbox/desc_label

func get_dialogue_hbox():
	return $vbox/dialogue_hbox

func get_dialogue_edit() -> SpinBox:
	return $vbox/dialogue_hbox/dialogue_edit


func set_map_item(p_item):
	map_item = p_item
	update()

func update():
	if map_item == null:
		return
	
	var iconTexRect = get_icon_tex_rect()
	iconTexRect.texture = map_item.get_icon()
	var nameLabel = get_name_label()
	nameLabel.text = map_item.get_map_item_name()
	var descLabel = get_desc_label()
	descLabel.text = map_item.get_description()
	
	var dialogueHbox = get_dialogue_hbox()
	if map_item is DialogueTrigger:
		var dialogueEdit = get_dialogue_edit()
		dialogueEdit.value = map_item.dialogue_id
		dialogueHbox.show()
	else:
		dialogueHbox.hide()


func _on_dialogue_edit_changed() -> void:
	if !map_item is DialogueTrigger:
		return
	
	map_item.dialogue_id = get_dialogue_edit().value
