extends RefCounted
class_name PassiveState

signal cd_changed(p_cd:int)

var cd:int : set = set_cd
var passive:Passive : set = set_passive
var owner:PlayerUnit

func is_cding() -> bool:
	return cd < passive.get_cd()

func round_start():
	passive.round_start(self)

func move_left():
	passive.move_left(self)

func move_right():
	passive.move_right(self)


func set_passive(p_value):
	passive = p_value
	
	if passive:
		cd = passive.get_cd()

func set_cd(p_value):
	if cd == p_value:
		return
	
	cd = p_value
	cd_changed.emit(cd)
