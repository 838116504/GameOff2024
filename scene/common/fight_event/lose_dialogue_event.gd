extends FightEvent
class_name LoseDialogueEvent

var fight_scene:FightScene
var dialogue_id:int

func begin(p_fightScene:FightScene):
	fight_scene = p_fightScene
	assert(p_fightScene)
	fight_scene.before_lose_animation.connect(_on_fight_scene_before_lose_animation)

func end():
	fight_scene.before_lose_animation.disconnect(_on_fight_scene_before_lose_animation)

func _on_fight_scene_before_lose_animation():
	global_dialogue.show_dialogue(dialogue_id)
	fight_scene.remove_fight_event(self)
