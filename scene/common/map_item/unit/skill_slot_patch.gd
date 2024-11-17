extends NinePatchRect

signal pressed
signal skill_added(p_skillState)
signal skill_moved(p_skillState)


var skill_state:SkillState : set = set_skill_state
var enabled := false : set = set_enabled

var _dragging := false

@onready var skill_state_view = get_skill_state_view()

func get_skill_state_view() -> Control:
	return $skill_state_view


func _ready():
	skill_state_view.hide_on_put = false
	skill_state_view.set_drag_forwarding(_view_get_drag_data, _view_can_drop_data, _view_drop_data)
	skill_state_view.pressed.connect(_on_view_pressed)
	update()

func _notification(p_what: int) -> void:
	if p_what == NOTIFICATION_DRAG_END:
		if _dragging:
			_dragging = false
			skill_state_view.show()

func set_skill_state(p_state):
	skill_state = p_state
	
	update()

func update():
	if skill_state == null || !is_node_ready():
		return
	
	skill_state_view.skill_state = skill_state

func set_enabled(p_value):
	if enabled == p_value:
		return
	
	enabled = p_value
	
	if enabled:
		get_skill_state_view().mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		get_skill_state_view().mouse_filter = Control.MOUSE_FILTER_IGNORE

func _view_get_drag_data(_pos:Vector2):
	_dragging = true
	skill_state_view.hide()
	set_drag_preview(skill_state_view.create_preview())
	
	return { "type":"skill_slot", "control":self }

func _view_can_drop_data(_pos, p_data):
	return p_data.type == "skill_state_view" || p_data.type == "skill_slot"

func _view_drop_data(_pos, p_data):
	match p_data.type:
		"skill_state_view":
			skill_added.emit(p_data.control.skill_state)
		"skill_slot":
			skill_moved.emit(p_data.control.skill_state)

func _on_view_pressed():
	if _dragging:
		return
	
	pressed.emit()
