extends ColorRect

@export var show_time:float = 0.7
@export var fade_out_time:float = 1
@export var up_speed:float = 16

var _rest_show_time:float

func _ready():
	_rest_show_time = show_time

func _process(p_delta):
	position.y -= up_speed * p_delta
	if _rest_show_time > 0:
		_rest_show_time -= p_delta
		return
	
	modulate.a -= p_delta / fade_out_time
	if modulate.a <= 0:
		queue_free()
