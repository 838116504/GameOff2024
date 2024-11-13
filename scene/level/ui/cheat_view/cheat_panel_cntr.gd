extends PanelContainer

signal used(p_cheat)

var cheat:Cheat : set = set_cheat

@onready var use_btn = get_use_btn()

func get_name_label():
	return $hbox/name_label

func get_use_btn():
	return $hbox/use_btn


func _ready():
	use_btn.pressed.connect(_on_use_btn_pressed)

func set_cheat(p_value):
	cheat = p_value
	
	if cheat:
		get_name_label().text = cheat.get_cheat_name()
		tooltip_text = cheat.get_description()

func disable():
	use_btn.disabled = true

func enable():
	use_btn.disabled = false

func _on_use_btn_pressed():
	used.emit(cheat)
