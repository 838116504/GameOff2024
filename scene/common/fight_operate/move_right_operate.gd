extends FightOperate
class_name MoveRightOperate

func get_id():
	return 1

func execute():
	await owner.move_right()
	owner.next_operate = null

func show_operate():
	pass
