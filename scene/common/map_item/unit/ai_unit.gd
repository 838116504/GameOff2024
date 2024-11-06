extends Unit
class_name AIUnit

var fight_bt
var alarm_bt

func _map_item_entered(p_item):
	if p_item is PlayerUnit:
		pass
