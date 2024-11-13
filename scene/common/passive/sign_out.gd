extends Passive

func get_id() -> int:
	return 1

func move_left(p_state:PassiveState) -> void:
	if p_state.is_cding():
		return
	
	var buff = SignOutBuff.new()
	p_state.owner.buff_manager.add_buff(buff)
	p_state.cd = 0

func move_right(p_state:PassiveState) -> void:
	if p_state.is_cding():
		return
	
	var buff = SignOutBuff.new()
	p_state.owner.buff_manager.add_buff(buff)
	p_state.cd = 0
