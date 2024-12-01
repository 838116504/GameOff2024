extends Buff
class_name BreakDefBuff

var turn:int = 7

func get_name() -> StringName:
	return &"vulnerable"

func enter(p_owner):
	super(p_owner)
	
	owner.def_rate -= 1.0

func exit():
	owner.def_rate += 1.0
	super()

func add(p_buff:Buff):
	turn += p_buff.turn

func round_start():
	turn -= 1
	if turn <= 0:
		owner.buff_manager.erase_buff(get_name())

func stage_start():
	pass
