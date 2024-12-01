extends Control

signal pressed

var hide_on_put := true
var skill_state:SkillState : set = set_skill_state

@onready var cd_hbox = get_cd_hbox()
@onready var patch = get_patch()
@onready var damage_tex_rect_list := [ get_strike_tex_rect(), get_thrust_tex_rect(), get_slash_tex_rect(), get_random_tex_rect() ]
@onready var damage_label_list := [ get_strike_label(), get_thrust_label(), get_slash_label(), get_random_label() ]

func get_icon_tex_rect():
	return $patch/icon_tex_rect

func get_strike_tex_rect():
	return $patch/damage_hbox/strike_tex_rect

func get_strike_label():
	return $patch/damage_hbox/strike_label

func get_thrust_tex_rect():
	return $patch/damage_hbox/thrust_tex_rect

func get_thrust_label():
	return $patch/damage_hbox/thrust_label

func get_slash_tex_rect():
	return $patch/damage_hbox/slash_tex_rect

func get_slash_label():
	return $patch/damage_hbox/slash_label

func get_random_tex_rect():
	return $patch/damage_hbox/random_tex_rect

func get_random_label():
	return $patch/damage_hbox/random_label

func get_cd_hbox():
	return $patch/cd_panel_cntr/cd_hbox

func get_patch() -> NinePatchRect:
	return $patch


func _ready():
	update_damage()

#func _notification(p_what):
	#if p_what == NOTIFICATION_MOUSE_ENTER:
		#_hover()
	#elif p_what == NOTIFICATION_MOUSE_EXIT || p_what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		#_dehover()

func _gui_input(p_event:InputEvent):
	if p_event is InputEventMouseButton:
		if p_event.button_index == MOUSE_BUTTON_LEFT:
			if p_event.is_released():
				pressed.emit()

#func _hover():
	#patch.position.y = -24
#
#func _dehover():
	#patch.position.y = 0

func set_skill_state(p_value):
	if skill_state == p_value:
		return
	
	if skill_state:
		skill_state.extra_attack_changed.disconnect(_on_skill_state_extra_attack_changed)
		skill_state.cd_changed.disconnect(_on_skill_state_cd_changed)
		skill_state.put_changed.disconnect(_on_skill_state_put_changed)
	
	skill_state = p_value
	
	if skill_state:
		skill_state.extra_attack_changed.connect(_on_skill_state_extra_attack_changed)
		skill_state.cd_changed.connect(_on_skill_state_cd_changed)
		skill_state.put_changed.connect(_on_skill_state_put_changed)
	
	update()

func update():
	if skill_state == null:
		return
	
	var iconTexRect = get_icon_tex_rect()
	iconTexRect.texture = skill_state.skill.get_icon()
	
	update_damage()
	
	var cdHbox = get_cd_hbox()
	cdHbox.set_max_value(skill_state.skill.get_cd())
	cdHbox.set_value(skill_state.cd)
	
	tooltip_text = "%s\n%s" % [ skill_state.skill.get_skill_name(), skill_state.skill.get_description() ]
	if skill_state.is_cding():
		mouse_filter = MOUSE_FILTER_IGNORE
	else:
		mouse_filter = MOUSE_FILTER_STOP
	
	if hide_on_put:
		visible = !skill_state.put

func _on_skill_state_extra_attack_changed(_exAtk):
	update_damage()

func _on_skill_state_cd_changed(p_cd):
	cd_hbox.set_value(p_cd)
	
	if skill_state.is_cding():
		mouse_filter = MOUSE_FILTER_IGNORE
	else:
		mouse_filter = MOUSE_FILTER_STOP

func _on_skill_state_put_changed(p_put):
	visible = !p_put

func update_damage():
	if !is_node_ready() || skill_state == null:
		return
	
	var damType = skill_state.skill.get_damage_type()
	if damType >= 0:
		var dam = skill_state.skill.get_damage() + skill_state.extra_attack
		for i in damage_tex_rect_list.size():
			if i == damType:
				damage_tex_rect_list[i].show()
				damage_label_list[i].text = str(dam)
				damage_label_list[i].show()
			else:
				damage_tex_rect_list[i].hide()
				damage_label_list[i].hide()
	else:
		for i in damage_tex_rect_list.size():
			damage_tex_rect_list[i].hide()
			damage_label_list[i].hide()

func create_preview():
	var ret = Control.new()
	ret.size = Vector2.ZERO
	var child = get_child(0).duplicate()
	child.position = -child.size * 0.5
	ret.add_child(child)
	return ret 
