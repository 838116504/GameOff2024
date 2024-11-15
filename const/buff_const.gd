extends RefCounted
class_name BuffConst

const BUFF_LIST = [
	preload("res://scene/common/buff/sign_out_buff.gd"),
	preload("res://scene/common/buff/cannot_move_buff.gd"),
	preload("res://scene/common/buff/block_buff.gd"),
]

const BUFF_NAME_LIST = [
	&"sign_out",
	&"cannot_move",
	&"block",
]

static func create_buff_by_name(p_name:StringName):
	var find = BUFF_NAME_LIST.find(p_name)
	if find < 0:
		return null
	
	return BUFF_LIST[find].new()
