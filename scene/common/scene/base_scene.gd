extends Control
class_name BaseScene

@export var bgm:AudioStream

func _ready():
	bgm_manager.base_bgm = bgm
