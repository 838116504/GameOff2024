extends NinePatchRect

@export var icon:Texture2D
@export var value:float : set = set_value

@onready var value_label = get_value_label()

func get_icon_tex_rect():
	return $icon_tex_rect

func get_value_label():
	return $value_label

func _ready():
	get_icon_tex_rect().texture = icon
	update_value()

func set_value(p_value):
	value = p_value
	
	update_value()

func update_value():
	if value_label == null:
		return
	
	value_label.text = "%d%%" % int(value * 100)
