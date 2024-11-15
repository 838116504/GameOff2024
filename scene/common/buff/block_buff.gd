extends Buff
class_name BlockBuff


func get_name() -> StringName:
	return &"block"

func enter(p_owner):
	super(p_owner)
	
	owner.block_count += 1

func exit():
	owner.block_count -= 1
	super()

func add(_buff:Buff):
	pass

func round_start():
	owner.buff_manager.erase_buff(get_name())

func stage_start():
	owner.buff_manager.erase_buff(get_name())
