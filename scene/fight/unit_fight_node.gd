extends Node2D

const LoseHpColorRectScene = preload("res://scene/common/map_item/unit/lose_hp_color_rect.tscn")
const ORDER_TEXTURE_LIST := [ 
	preload("res://asset/img/ui/icon/order_1.png"),
	preload("res://asset/img/ui/icon/order_2.png"),
	preload("res://asset/img/ui/icon/order_3.png"),
	preload("res://asset/img/ui/icon/order_4.png"),
	preload("res://asset/img/ui/icon/order_5.png"),
	preload("res://asset/img/ui/icon/order_6.png"),
	preload("res://asset/img/ui/icon/order_7.png"),
	preload("res://asset/img/ui/icon/order_8.png"),
	preload("res://asset/img/ui/icon/order_9.png") ]


var unit:Unit = null : set = set_unit
var current:bool = false : set = set_current

var current_operate_node = null
# 是否鼠標在下方的技能上懸浮
var skill_hover := false : set = set_skill_hover
# 是否在拖拽下方的技能栏
var skill_dragging := false : set = set_skill_dragging

@onready var spine = get_spine()
@onready var ammo_bone = get_ammo_bone()
@onready var order_sprite = get_order_sprite()
@onready var hp_progress_bar = get_hp_progress_bar()
@onready var hp_label = get_hp_label()
@onready var current_sprite = get_current_sprite()
@onready var skill_slot_panel_cntr = get_skill_slot_panel_cntr()

@onready var op_sprite_list = [ get_move_left_op_sprite(), get_move_right_op_sprite(), get_standby_op_sprite(), 
		get_turn_op_sprite(), get_put_op_sprite(), get_attack_op_sprite() ]

func get_spine() -> SpineSprite:
	return $spine

func get_ammo_bone() -> SpineBoneNode:
	return $spine/ammo_bone

func get_order_sprite():
	return $order_sprite

func get_hp_progress_bar() -> TextureProgressBar:
	return $hp_progress_bar

func get_hp_label():
	return $hp_progress_bar/hp_label

func get_current_sprite():
	return $current_sprite

func get_skill_slot_panel_cntr():
	return $skill_slot_panel_cntr

func get_move_left_op_sprite():
	return $move_left_op_sprite

func get_move_right_op_sprite():
	return $move_right_op_sprite

func get_standby_op_sprite():
	return $standby_op_sprite

func get_turn_op_sprite():
	return $turn_op_sprite

func get_put_op_sprite():
	return $put_op_sprite

func get_attack_op_sprite():
	return $attack_op_sprite


func _ready():
	update()

func set_unit(p_unit):
	unit = p_unit
	
	if unit:
		unit.fight_direction_changed.connect(_on_unit_fight_direction_changed)
		unit.fight_x_changed.connect(_on_unit_fight_x_changed)
		unit.hp_changed.connect(_on_unit_hp_changed)
		unit.died.connect(_on_unit_died)
		unit.be_hit.connect(_on_unit_be_hit)
		unit.put_skill_state_list_changed.connect(_on_unit_put_skill_state_list_changed)
		unit.next_operate_changed.connect(_on_unit_next_operate_changed)
		
		if is_node_ready():
			update()

func update():
	if unit == null:
		hide()
		return
	
	hp_progress_bar.max_value = unit.hp
	hp_progress_bar.value = unit.hp
	var skel := spine.get_skeleton()
	skel.set_skin_by_name(unit.get_fight_skin())
	skel.set_slots_to_setup_pose()
	update_direction()
	update_position()
	update_op()
	show()

func update_direction():
	spine.scale.x = abs(spine.scale.x) * unit.fight_direction

func update_position():
	position.x = unit.fight_scene.get_cell_center_x(unit.fight_x)

func update_hp():
	hp_progress_bar.value = unit.hp
	hp_label.text = str(unit.hp)

func show_order(p_order:int):
	order_sprite.texture = ORDER_TEXTURE_LIST[p_order]
	order_sprite.show()

func hide_order():
	order_sprite.hide()

func _on_unit_fight_direction_changed(_dir):
	update_direction()

func _on_unit_fight_x_changed(_x):
	update_position()

func _on_unit_hp_changed(_hp):
	update_hp()

func update_op():
	if current_operate_node:
		current_operate_node.hide()
		current_operate_node = null
	
	if unit.next_operate == null:
		return
	
	current_operate_node = op_sprite_list[unit.next_operate.get_id()]
	current_operate_node.show()

func _on_unit_died():
	unit.fight_node = null
	queue_free()

func _on_unit_be_hit(p_dam):
	var loseHpColorRect = LoseHpColorRectScene.instantiate()
	loseHpColorRect.position.x = hp_progress_bar.size.x * unit.hp / hp_progress_bar.max_value
	loseHpColorRect.size.x = hp_progress_bar.size.x * p_dam / hp_progress_bar.max_value
	hp_progress_bar.add_child(loseHpColorRect)
	hp_progress_bar.move_child(loseHpColorRect, 0)

func _on_unit_put_skill_state_list_changed(p_states):
	skill_slot_panel_cntr.skill_state_list = p_states

func _on_unit_next_operate_changed(_op):
	update_op()

func set_current(p_value):
	current = p_value
	
	current_sprite.visible = current
	skill_slot_panel_cntr.enabled = current
	if !current:
		skill_hover = false
		skill_dragging = false
	
	update_add_skill_slot()

func set_skill_hover(p_value):
	if skill_hover == p_value:
		return
	
	skill_hover = p_value
	update_add_skill_slot()

func set_skill_dragging(p_value):
	if skill_dragging == p_value:
		return
	
	skill_dragging = p_value
	update_add_skill_slot()

func update_add_skill_slot():
	if current && (skill_hover || skill_dragging):
		skill_slot_panel_cntr.show_add_skill_slot()
	else:
		skill_slot_panel_cntr.hide_add_skill_slot()

func play_animation(p_anim:StringName, p_loop := false):
	var animState = spine.get_animation_state()
	if animState == null:
		return
	
	animState.set_animation(p_anim, p_loop)

func _on_skill_slot_panel_cntr_skill_added(p_pos: Variant, p_skillState: SkillState) -> void:
	if p_skillState in unit.put_skill_state_list:
		return
	
	if p_skillState.skill.is_free_put():
		unit.put_skill(p_skillState, p_pos)
	else:
		unit.put_skill_operate(p_skillState, p_pos)


func _on_skill_slot_panel_cntr_skill_moved(p_pos: Variant, p_skillState: SkillState) -> void:
	var find = unit.put_skill_state_list.find(p_skillState)
	if find < 0:
		return
	
	unit.swap_put_skill(p_pos, find)


func _on_skill_slot_panel_cntr_skill_removed(p_skillState: SkillState) -> void:
	unit.erase_put_skill(p_skillState)
