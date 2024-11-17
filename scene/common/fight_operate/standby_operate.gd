extends FightOperate
class_name StandbyOperate

func get_id():
	return 2

func execute():
	await owner.fight_scene.get_tree().create_timer(0.4).timeout
	owner.next_operate = null

func show_operate():
	pass
