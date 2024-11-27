extends Node

var save : set = set_save

func _ready():
	set_physics_process(save != null)

func _physics_process(p_delta:float):
	save.add_play_time(p_delta)

func set_save(p_value):
	save = p_value
	
	set_physics_process(save != null)
