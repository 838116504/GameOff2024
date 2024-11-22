extends Label

@export var text_speed:float = 4

var _text_speed:float

@onready var next_icon_tex_rect = get_next_icon_tex_rect()
@onready var next_icon_anim_player = get_next_icon_anim_player()

func get_next_icon_tex_rect():
	return $next_icon_tex_rect

func get_next_icon_anim_player():
	return $next_icon_anim_player

func _ready():
	set_process(false)

func _process(p_delta):
	visible_ratio += _text_speed * p_delta
	
	if visible_ratio >= 1.0:
		_show_text()
		return

func play(p_text:String):
	text = p_text
	
	if p_text.is_empty():
		_show_text()
	else:
		_text_speed = text_speed / float(p_text.length())
		visible_ratio = 0.0
		set_process(true)
		next_icon_tex_rect.hide()
		next_icon_anim_player.stop()

func _show_text():
	visible_ratio = 1.0
	set_process(false)
	next_icon_tex_rect.show()
	next_icon_anim_player.play("idle")

func skip():
	if !is_playing():
		return
	
	_show_text()

func is_playing() -> bool:
	return is_processing()
