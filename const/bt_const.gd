extends RefCounted
class_name BTConst

const UNIT_BT_FILE_LIST = [
	"melee.tres",
	"range.tres",
]

static func get_unit_bt(p_id):
	if p_id < 0 || p_id >= UNIT_BT_FILE_LIST.size():
		return null
	
	return load(DirConst.UNIT_BT.path_join(UNIT_BT_FILE_LIST[p_id]))
