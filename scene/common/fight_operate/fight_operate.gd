extends RefCounted
class_name FightOperate

var owner:Unit

func get_id():
	return -1

func execute():
	owner.next_operate = null

func show_operate():
	pass

func get_stage_count() -> int:
	return 1

func is_action_first() -> bool:
	return false
