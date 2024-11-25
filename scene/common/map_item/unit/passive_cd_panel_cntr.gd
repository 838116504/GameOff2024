extends PanelContainer

var passive_state:PassiveState : set = set_passive_state


func get_cd_hbox():
	return $cd_hbox

func set_passive_state(p_value):
	passive_state = p_value
	
	if passive_state == null:
		hide()
		return
	
	tooltip_text = passive_state.passive.get_passive_name() + "\n" + passive_state.passive.get_description()
	var cdHbox = get_cd_hbox()
	cdHbox.set_max_value(passive_state.passive.get_cd())
	cdHbox.set_value(passive_state.cd)
	passive_state.cd_changed.connect(_on_passive_state_cd_changed)
	show()

func _on_passive_state_cd_changed(p_cd):
	var cdHbox = get_cd_hbox()
	cdHbox.set_value(p_cd)
