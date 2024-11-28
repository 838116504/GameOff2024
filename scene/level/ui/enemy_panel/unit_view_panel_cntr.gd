extends PanelContainer

@onready var vbox = get_vbox()

func get_vbox():
	return $vbox


func _ready():
	set_process(visible)

func _notification(p_what):
	if p_what == NOTIFICATION_VISIBILITY_CHANGED:
		set_process(visible)

func _process(_delta):
	var mousePos = get_global_mouse_position()
	global_position.x = clampf(mousePos.x, 0.0, 1920 - size.x)
	global_position.y = clampf(mousePos.y, 0.0, 1080 - size.y)

func set_unit(p_value):
	for child in vbox.get_children():
		if child.has_method("set_unit"):
			child.set_unit(p_value)
