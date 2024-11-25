extends FightEvent
class_name ShowHelpPopupEvent

func begin(p_fightScene:FightScene):
	if global_dialogue.is_dialoguing():
		await global_dialogue.ended
	
	event_bus.emit_signal(EventConst.SHOW_HELP_POPUP)
	p_fightScene.remove_fight_event(self)
