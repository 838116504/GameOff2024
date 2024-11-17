extends FightOperate
class_name MoveLeftOperate

func get_id():
	return 0

func execute():
	await owner.move_left()
	owner.next_operate = null

func show_operate():
	pass
