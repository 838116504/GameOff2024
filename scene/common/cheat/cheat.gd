extends RefCounted
class_name Cheat

func get_id():
	return 0

func execute(_owner):
	pass

func get_cheat_name() -> String:
	return tr("CHEAT_%d" % get_id())

func get_description() -> String:
	return tr("CHEAT_DESC_%d" % get_id())
