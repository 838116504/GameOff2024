extends Panel

var unit:Unit = null : set = set_unit


@onready var avatar_tex_rect = get_avatar_tex_rect()
@onready var hp_view_patch = get_hp_view_patch()
@onready var def_view_patch = get_def_view_patch()
@onready var spd_view_patch = get_spd_view_patch()
@onready var strike_view_patch = get_strike_view_patch()
@onready var thrust_view_patch = get_thrust_view_patch()
@onready var slash_view_patch = get_slash_view_patch()


func get_avatar_tex_rect():
	return $avatar_tex_rect

func get_hp_view_patch():
	return $hp_view_patch

func get_def_view_patch():
	return $def_view_patch

func get_spd_view_patch():
	return $spd_view_patch

func get_strike_view_patch():
	return $strike_view_patch

func get_thrust_view_patch():
	return $thrust_view_patch

func get_slash_view_patch():
	return $slash_view_patch


func set_unit(p_value):
	if unit == p_value:
		return
	
	unit = p_value
	update_unit()

func update_unit():
	if unit == null:
		hide()
		return
	
	avatar_tex_rect.texture = unit.get_icon()
	hp_view_patch.value = unit.hp
	def_view_patch.value = unit.get_def()
	spd_view_patch.value = unit.get_spd()
	strike_view_patch.value = unit.get_strike_hit_rate()
	thrust_view_patch.value = unit.get_thrust_hit_rate()
	slash_view_patch.value = unit.get_slash_hit_rate()
	show()
