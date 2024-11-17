extends RefCounted
class_name BuffManager

signal buff_added(p_buff:Buff)
signal buff_removed(p_buff:Buff)

var owner:Unit
var buff_list := []



func update(p_delta):
	for buff in buff_list:
		buff.update(p_delta)

func add_buff(p_buff:Buff) -> void:
	if p_buff == null:
		return
	
	var buff = get_buff(p_buff.get_name())
	if buff:
		buff.add(p_buff)
	else:
		buff_list.append(p_buff)
		p_buff.enter(owner)
		buff_added.emit(p_buff)

func get_buff(p_buff:StringName) -> Buff:
	for i in buff_list:
		if i.get_name() == p_buff:
			return i
	
	return null

func erase_buff(p_buff:StringName) -> bool:
	for i in buff_list.size():
		if buff_list[i].get_name() == p_buff:
			var buff = buff_list[i]
			buff_list.remove_at(i)
			buff.exit()
			buff_removed.emit(buff)
			return true
	
	return false

func has_buff(p_buff:StringName) -> bool:
	return get_buff(p_buff) != null

func round_start():
	for buff in buff_list:
		buff.round_start()

func stage_start():
	for buff in buff_list:
		buff.stage_start()

func get_data():
	var data = []
	data.resize(buff_list.size())
	for i in buff_list.size():
		data[i] = [ BuffConst.BUFF_NAME_LIST.find(buff_list[i].get_name()), buff_list[i].get_data() ]
	
	return data

func set_data(p_data):
	buff_list.clear()
	for i in p_data.size():
		var buff = BuffConst.BUFF_LIST[p_data[i][0]].new()
		buff.set_data(p_data[i][1])
		buff_list.append(buff)
		buff.enter(owner)
