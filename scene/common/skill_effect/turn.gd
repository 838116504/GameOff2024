extends SkillEffect

func get_id() -> int:
	return 7

func execute(p_owner:Unit, _skillState):
	p_owner.fight_direction = -p_owner.fight_direction
	await p_owner.fight_scene.get_tree().create_timer(0.4).timeout
