extends Label

@export var start_scale:float = 0.05
@export var scale_speed:float = 0.2
@export var fade_in_stay_time:float = 1.0
@export var fade_in_speed:float = 0.4
@export var min_time:float = 1.5
@export var max_time:float = 4.0
@export var line_count:int = 8 : set = set_line_count

var _rest_time:float = 0
var _stay_time:float = 0

@onready var tex_rect = get_tex_rect()

func get_tex_rect() -> TextureRect:
	return $tex_rect

func _ready():
	visible = _rest_time > 0
	set_process(visible)
	
	tex_rect.custom_minimum_size.y = get_combined_minimum_size().y


func _process(p_delta):
	_rest_time -= p_delta
	if _rest_time <= 0:
		set_process(false)
		hide()
		queue_free()
		return
	
	if _stay_time > fade_in_stay_time:
		tex_rect.modulate.a -= fade_in_speed * p_delta
		tex_rect.material.set_shader_parameter("color", Color(0.16, 0.95, 0.21, tex_rect.modulate.a))
	else:
		_stay_time += p_delta
	
	text = ""
	for _i in line_count:
		text += str(randi_range(0, 9)) + "\n"
	
	scale.x += scale_speed * p_delta
	scale.y = scale.x

func enable():
	scale.x = start_scale
	scale.y = scale.y
	_rest_time = randf_range(min_time, max_time)
	_stay_time = 0.0
	set_process(true)
	show()

func set_line_count(p_value):
	line_count = p_value
	text = ""
	for _i in line_count:
		text += str(randi_range(0, 9)) + "\n"
