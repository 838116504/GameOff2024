extends FightEvent
class_name PlayerHPDialogueEvent

var fight_scene:FightScene
var dialogue_id:int
var player_hp:int

func begin(p_fightScene:FightScene):
	fight_scene = p_fightScene
	assert(p_fightScene.player_unit)
	if p_fightScene.player_unit.hp <= player_hp:
		global_dialogue.show_dialogue(dialogue_id)
		fight_scene.remove_fight_event(self)
	else:
		p_fightScene.player_unit.hp_changed.connect(_on_player_hp_changed)

func end():
	if fight_scene.player_unit:
		fight_scene.player_unit.hp_changed.disconnect(_on_player_hp_changed)

func _on_player_hp_changed(p_hp):
	if p_hp <= player_hp:
		global_dialogue.show_dialogue(dialogue_id)
		fight_scene.remove_fight_event(self)
