extends BaseScene

const InputNamePopupScene = preload("input_name_popup.tscn")

var first := false
var save_id:int : set = set_save_id
var game_save:GameSave

@onready var popup_layer = get_popup_layer()

func get_popup_layer():
	return $popup_layer

func _ready():
	if game_save == null:
		var gameSave = GameSave.new()
		gameSave.id = save_id
		game_save = gameSave
	
	for child in popup_layer.get_children():
		if child.has_method("set_game_save"):
			child.set_game_save(game_save)
	

func set_save_id(p_value):
	save_id = p_value
	game_save = GameSave.load_save(save_id)
	
