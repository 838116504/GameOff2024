extends HFlowContainer

const SkillPatchScene = preload("res://scene/common/map_item_view/skill_patch.tscn")


func set_skill_list(p_skills:Array):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for skill in p_skills:
		var skillPatch = SkillPatchScene.instantiate()
		skillPatch.skill = skill
		add_child(skillPatch)
