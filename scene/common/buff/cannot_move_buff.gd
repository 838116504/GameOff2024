extends Buff
class_name CannotMoveBuff

var round:int = 1

func get_name() -> StringName:
	return &"cannot_move"

func enter(p_owner):
	super(p_owner)
	
	owner.cannot_move_count += 1

func exit():
	owner.cannot_move_count -= 1
	super()

func add(p_buff:Buff):
	round += p_buff.round

func round_start():
	round -= 1
	if round <= 0:
		owner.buff_manager.erase_buff(get_name())

func stage_start():
	pass
