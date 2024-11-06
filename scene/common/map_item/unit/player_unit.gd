extends Unit
class_name PlayerUnit

class DataStack:
	var id:int
	var count:int = 1
	
	func _init(p_id, p_count:int):
		id = p_id
		count = p_count

signal data_count_changed(p_count:int)
signal yellow_key_count_changed(p_count:int)
signal blue_key_count_changed(p_count:int)
signal red_key_count_changed(p_count:int)


var strike_def:int
var thrust_def:int
var slash_def:int
var data_stack_list := []
var data_count:int = 0 : set = set_data_count
var yellow_key_count:int = 0 : set = set_yellow_key_count
var blue_key_count:int = 0 : set = set_blue_key_count
var red_key_count:int = 0 : set = set_red_key_count


func add_data(p_id:int, p_count:int = 1):
	data_count += p_count
	for i in data_stack_list:
		if i.id == p_id:
			i.count += p_count
			return
	
	data_stack_list.append(DataStack.new(p_id, p_count))

func sub_data(p_id, p_count:int = 1):
	for i in data_stack_list.size():
		if data_stack_list[i].id == p_id:
			data_stack_list[i].count -= p_count
			if data_stack_list[i].count == 0:
				data_stack_list.remove_at(i)
			
			data_count -= p_count
			return

func set_data_count(p_value):
	if data_count == p_value:
		return
	
	data_count = p_value
	data_count_changed.emit(data_count)

func set_yellow_key_count(p_value):
	if yellow_key_count == p_value:
		return
	
	yellow_key_count = p_value
	yellow_key_count_changed.emit(yellow_key_count)

func set_blue_key_count(p_value):
	if blue_key_count == p_value:
		return
	
	blue_key_count = p_value
	blue_key_count_changed.emit(blue_key_count)

func set_red_key_count(p_value):
	if red_key_count == p_value:
		return
	
	red_key_count = p_value
	red_key_count_changed.emit(red_key_count)
