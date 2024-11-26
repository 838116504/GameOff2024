extends Control

@export var icon:Texture2D : set = set_icon

@onready var value_label = get_value_label()

func get_icon_tex_rect():
	return $icon_tex_rect

func get_value_label() -> Label:
	return $patch/value_label


func set_icon(p_value:Texture2D):
	icon = p_value
	
	get_icon_tex_rect().texture = icon

func set_value(p_value):
	value_label.text = str(p_value)

func set_value_string(p_str:String):
	value_label.text = p_str
