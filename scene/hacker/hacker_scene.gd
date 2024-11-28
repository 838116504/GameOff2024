extends BaseScene

const InputNamePopupScene = preload("input_name_popup.tscn")

var first := false
var save_id:int : set = set_save_id
var game_save:GameSave

@onready var popup_layer = get_popup_layer()

func get_popup_layer():
	return $popup_layer

func get_play_timer():
	return $play_timer

func _ready():
	if game_save == null:
		var gameSave = GameSave.new()
		gameSave.id = save_id
		game_save = gameSave
		var inputNamePopup = InputNamePopupScene.instantiate()
		popup_layer.add_child(inputNamePopup)
		inputNamePopup.ok_btn_pressed.connect(_on_input_name_popup_ok_btn_pressed.bind(inputNamePopup))
		event_bus.emit_signal(EventConst.SHOW_DIALOGUE, 6)
	
	for child in popup_layer.get_children():
		if child.has_method("set_game_save"):
			child.set_game_save(game_save)
	
	get_play_timer().save = game_save

func set_save_id(p_value):
	save_id = p_value
	game_save = GameSave.load_save(save_id)
	

func _on_input_name_popup_ok_btn_pressed(p_firstName, p_inputNamePopup):
	game_save.player_first_name = p_firstName
	
	p_inputNamePopup.queue_free()
	event_bus.emit_signal(EventConst.SHOW_DIALOGUE, 8)
