extends PanelContainer

const SkillStateViewScene = preload("res://scene/fight/ui/skill_panel/skill_state_view.tscn")

signal skill_state_view_mouse_entered(p_view)
signal skill_state_view_mouse_exited(p_view)
signal dragging_view_changed(p_view)


var unit:Unit = null : set = set_unit

var _dragging_view = null : set = set_dragging_view

@onready var grid_cntr = get_grid_cntr()


func get_grid_cntr() -> GridContainer:
	return $grid_cntr


func _notification(p_what):
	match p_what:
		NOTIFICATION_DRAG_END:
			if _dragging_view == null:
				return
			
			if !_dragging_view.put:
				_dragging_view.show()
			
			_dragging_view = null

func set_unit(p_value):
	unit = p_value
	update_unit()

func enable():
	for child in grid_cntr.get_children():
		child.mouse_filter = MOUSE_FILTER_STOP

func disable():
	for child in grid_cntr.get_children():
		child.mouse_filter = MOUSE_FILTER_IGNORE

func create_skill_state_view():
	var ret = SkillStateViewScene.instantiate()
	ret.pressed.connect(_on_skill_state_view_pressed.bind(ret))
	ret.mouse_entered.connect(_on_skill_state_view_mouse_entered.bind(ret))
	ret.mouse_exited.connect(_on_skill_state_view_mouse_exited.bind(ret))
	ret.set_drag_forwarding(_view_get_drag_data, Callable(), Callable())
	return ret

func _view_get_drag_data(_pos:Vector2, p_view):
	_dragging_view = p_view
	p_view.hide()
	set_drag_preview(p_view.create_preview())
	
	return { "type":"skill_state_view", "control":p_view }

func update_unit():
	if unit == null:
		hide()
		return
	
	if unit.has_skill_slot():
		enable()
	else:
		disable()
	
	if grid_cntr.get_child_count() > unit.skill_state_list.size():
		var n = grid_cntr.get_child_count() - unit.skill_state_list.size()
		for _i in n:
			var child = grid_cntr.get_child(0)
			child.queue_free()
			grid_cntr.remove_child(child)
	elif grid_cntr.get_child_count() < unit.skill_state_list.size():
		var n = unit.skill_state_list.size() - grid_cntr.get_child_count()
		for _i in n:
			var child = create_skill_state_view()
			grid_cntr.add_child(child)
	
	update_skill_state()
	
	show()

func update_skill_state():
	if unit == null:
		return
	
	var readySkills = []
	var cdSkills = []
	
	for i in unit.skill_state_list.size():
		if unit.skill_state_list[i].is_cding():
			cdSkills.append(unit.skill_state_list[i])
		else:
			readySkills.append(unit.skill_state_list[i])
	
	var skill = readySkills + cdSkills
	for i in skill.size():
		var child = grid_cntr.get_child(i)
		child.skill_state = skill[i]

func set_dragging_view(p_view):
	if _dragging_view == p_view:
		return
	
	_dragging_view = p_view
	dragging_view_changed.emit(_dragging_view)

func _on_skill_state_view_pressed(p_view):
	if p_view.skill_state.skill.is_free_put():
		unit.put_skill(p_view.skill_state)
	else:
		unit.put_skill_operate(p_view.skill_state)

func _on_skill_state_view_mouse_entered(p_view):
	p_view.patch.position.y = -8
	skill_state_view_mouse_entered.emit(p_view)

func _on_skill_state_view_mouse_exited(p_view):
	p_view.patch.position.y = 0
	skill_state_view_mouse_exited.emit(p_view)
