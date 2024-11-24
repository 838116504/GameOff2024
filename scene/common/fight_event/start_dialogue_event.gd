extends FightEvent
class_name StartDialgoueEvent

var dialogue_id:int

func begin(p_fightScene:FightScene):
	global_dialogue.show_dialogue(dialogue_id)
	
	p_fightScene.remove_fight_event(self)
