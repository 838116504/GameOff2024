extends RefCounted
class_name Buff

var owner:Unit

func get_name() -> StringName:
	return &""

func enter(p_owner):
	owner = p_owner

func exit():
	owner = null

func update(_delta):
	pass

func add(_buff:Buff):
	pass

func get_data():
	return

func set_data(_data):
	pass
