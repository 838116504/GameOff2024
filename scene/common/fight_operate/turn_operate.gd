extends FightOperate
class_name TurnOperate

func get_id():
	return 3

func execute():
	await owner.fight_scene.get_tree().create_timer(0.4).timeout
	owner.turn()
	owner.next_operate = null

func show_operate():
	pass
