extends Control


func get_bg_patch():
	return $bg_patch

func get_icon_tex_rect():
	return $bg_patch/icon_tec_rect


func _ready():
	var bg_patch = get_bg_patch()
	var tween = create_tween()
	tween.tween_property(bg_patch, ^"size", Vector2.ONE * 1.2, 1.0)
	tween.tween_property(bg_patch, ^"size", Vector2.ONE, 1.0)

func set_icon(p_tex:Texture2D):
	get_icon_tex_rect().texture = p_tex
