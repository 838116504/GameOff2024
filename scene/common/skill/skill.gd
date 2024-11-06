extends Resource
class_name Skill

@export var id:int = 0
var extra_damage:int = 0
var extra_cd:int = 0
var extra_effect_list := []

func get_id() -> int:
	return id

func execute(_owner):
	pass

func get_skill_name():
	return

func get_description():
	return

func get_cd():
	return

func get_strike_damage():
	return

func get_thrust_damage():
	return

func get_slash_damage():
	return

func get_effect_list():
	return 
