extends HBoxContainer

@export var fill_color:Color
@export var empty_color:Color

var value:int : set = set_value


func set_max_value(p_value):
	if p_value == 0:
		hide()
		return
	
	var n  = get_child_count()
	if n < p_value:
		var clone = get_child(0)
		for _i in p_value - n:
			var child = clone.duplicate()
			child.modulate = empty_color
			add_child(child)
	else:
		for _i in n - p_value:
			var child = get_child(get_child_count() - 1)
			remove_child(child)
			child.queue_free()
	
	show()

func set_value(p_value):
	value = p_value
	
	for i in get_child_count():
		var child = get_child(i)
		if i < value:
			child.modulate = fill_color
		else:
			child.modulate = empty_color
