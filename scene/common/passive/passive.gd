extends Resource
class_name Passive

var extra_cd:int = 0

func get_id() -> int:
	return 0

func get_passive_name() -> String:
	return tr("PASSIVE_%d" % get_id())

func get_description() -> String:
	return tr("PASSIVE_DESC_%d" % get_id())

func get_cd():
	return 5 + extra_cd

func round_start(p_state) -> void:
	if p_state.is_cding():
		p_state.cd += 1
		return

func move_left(_state) -> void:
	return

func move_right(_state) -> void:
	return
