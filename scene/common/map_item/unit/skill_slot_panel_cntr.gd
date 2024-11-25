extends PanelContainer

const SkillSlotPatchScene = preload("res://scene/common/map_item/unit/skill_slot_patch.tscn")

signal skill_removed(p_skillState:SkillState)
signal skill_added(p_pos, p_skillState:SkillState)
signal skill_moved(p_pos, p_skillState:SkillState)

var enabled := false : set = set_enabled
var skill_state_list := [] : set = set_skill_state_list

@onready var vbox = get_vbox()
@onready var add_skill_slot_patch = get_add_skill_slot_patch()

func get_vbox():
	return $vbox

func get_add_skill_slot_patch():
	return $vbox/add_skill_slot_patch


func _ready():
	update_enabled()

func set_enabled(p_value):
	if enabled == p_value:
		return
	
	enabled = p_value
	update_enabled()

func update_enabled():
	if !is_node_ready():
		return
	
	if !skill_state_list.is_empty():
		for i in range(1, vbox.get_child_count()):
			var child = vbox.get_child(i)
			child.enabled = enabled
	
	if !enabled:
		add_skill_slot_patch.hide()

func set_skill_state_list(p_value):
	skill_state_list = p_value
	update()

func update():
	if !is_node_ready():
		return
	
	for _i in vbox.get_child_count() - 1:
		var child = vbox.get_child(1)
		child.queue_free()
		vbox.remove_child(child)
	
	visible = !skill_state_list.is_empty() || add_skill_slot_patch.visible
	
	for i in range(skill_state_list.size() - 1, -1, -1):
		var skillSlot = create_skill_slot_patch(skill_state_list[i])
		vbox.add_child(skillSlot)

func create_skill_slot_patch(p_skillState:SkillState):
	var ret = SkillSlotPatchScene.instantiate()
	ret.pressed.connect(_on_skill_slot_patch_pressed.bind(ret))
	ret.skill_added.connect(_on_skill_slot_patch_skill_added.bind(ret))
	ret.skill_moved.connect(_on_skill_slot_patch_skill_moved.bind(ret))
	ret.skill_state = p_skillState
	ret.enabled = enabled
	
	return ret

func _on_skill_slot_patch_pressed(p_patch):
	skill_removed.emit(p_patch.skill_state)

func _on_skill_slot_patch_skill_added(p_skillState, p_patch):
	if !p_skillState in skill_state_list:
		return
	
	skill_added.emit(vbox.get_child_count() - 1 - p_patch.get_index(), p_skillState)

func _on_skill_slot_patch_skill_moved(p_skillState, p_patch):
	if !p_skillState in skill_state_list:
		return
	
	skill_moved.emit(vbox.get_child_count() - 1 - p_patch.get_index(), p_skillState)

func show_add_skill_slot():
	add_skill_slot_patch.show()
	visible = true

func hide_add_skill_slot():
	add_skill_slot_patch.hide()
	visible = !skill_state_list.is_empty() || add_skill_slot_patch.visible
