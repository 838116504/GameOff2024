extends Buff
class_name SignOutBuff

func get_name() -> StringName:
	return &"sign_out"

func enter(p_owner):
	super(p_owner)
	
	owner.invincible_count += 1

func exit():
	owner.invincible_count -= 1
	super()

func add(_buff:Buff):
	pass

func round_start():
	owner.buff_manager.erase_buff(get_name())

func stage_start():
	owner.buff_manager.erase_buff(get_name())
