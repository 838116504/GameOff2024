extends PanelContainer

signal item_data_changed(p_item)

@export var editable := false
var map_item:MapItem : set = set_map_item

@onready var dialogue_vbox = get_dialogue_vbox()
@onready var dialogue_edit = get_dialogue_edit()
@onready var dialogue_preview_label = get_dialogue_preview_label()
@onready var folder_hbox = get_folder_hbox()
@onready var skill_opt_btn = get_skill_opt_btn()

func get_icon_tex_rect():
	return $vbox/hbox/icon_tex_rect

func get_name_label():
	return $vbox/hbox/name_label

func get_desc_label():
	return $vbox/desc_label

func get_dialogue_vbox():
	return $vbox/dialogue_vbox

func get_dialogue_edit() -> SpinBox:
	return $vbox/dialogue_vbox/hbox/dialogue_edit

func get_dialogue_preview_label():
	return $vbox/dialogue_vbox/preview_label

func get_folder_hbox():
	return $vbox/folder_hbox

func get_skill_opt_btn() -> OptionButton:
	return $vbox/folder_hbox/skill_opt_btn


func _ready():
	skill_opt_btn.clear()
	for row in table_set.skill.get_row_list():
		skill_opt_btn.add_item(tr(row.name), row.id)

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
	
	if map_item is DialogueTrigger && editable:
		dialogue_edit.max_value = table_set.dialogue.get_row_list()[-1].id
		dialogue_edit.value = map_item.dialogue_id
		dialogue_vbox.show()
		udpate_dialogue_preview()
	else:
		dialogue_vbox.hide()
	
	if map_item is Folder && editable:
		skill_opt_btn.select(skill_opt_btn.get_item_index(map_item.skill_id))
		folder_hbox.show()
	else:
		folder_hbox.hide()


func _on_dialogue_edit_value_changed(p_value) -> void:
	if !map_item is DialogueTrigger:
		return
	
	map_item.dialogue_id = int(p_value)
	udpate_dialogue_preview()
	item_data_changed.emit(map_item)

func udpate_dialogue_preview():
	if dialogue_edit.value == 0:
		dialogue_preview_label.text = ""
		return
	
	var row = table_set.dialogue.get_row(int(dialogue_edit.value))
	if row:
		dialogue_preview_label.text = tr(row.text)
	else:
		dialogue_preview_label.text = ""


func _on_skill_opt_btn_item_selected(p_index:int) -> void:
	if !map_item is Folder:
		return
	
	map_item.skill_id = skill_opt_btn.get_item_id(p_index)
	item_data_changed.emit(map_item)
