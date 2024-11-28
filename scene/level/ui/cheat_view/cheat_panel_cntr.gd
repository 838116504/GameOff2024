extends PanelContainer

signal used(p_cheat)

@export var fold_texture:Texture2D
@export var unfold_texture:Texture2D

var cheat:Cheat : set = set_cheat

@onready var desc_label = get_desc_label()
@onready var use_btn = get_use_btn()
@onready var fold_tex_rect = get_fold_tex_rect()

func get_name_label():
	return $vbox/hbox/name_label

func get_desc_label():
	return $vbox/desc_label

func get_use_btn():
	return $vbox/hbox/use_btn

func get_fold_tex_rect():
	return $vbox/hbox/fold_tex_rect


func _ready():
	use_btn.pressed.connect(_on_use_btn_pressed)

func _gui_input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseButton && p_event.button_index == MOUSE_BUTTON_LEFT:
		if p_event.is_released():
			if desc_label.visible:
				fold()
			else:
				unfold()

func fold():
	fold_tex_rect.texture = fold_texture
	desc_label.hide()

func unfold():
	fold_tex_rect.texture = unfold_texture
	desc_label.show()

func set_cheat(p_value):
	cheat = p_value
	
	if cheat:
		get_name_label().text = cheat.get_cheat_name()
		tooltip_text = cheat.get_description()
		get_desc_label().text = tooltip_text

func disable():
	use_btn.disabled = true

func enable():
	use_btn.disabled = false

func _on_use_btn_pressed():
	used.emit(cheat)
