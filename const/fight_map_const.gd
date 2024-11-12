extends RefCounted
class_name FightMapConst


const FIGHT_MAP_FILE_LIST = [
	
]

static func get_fight_map(p_id:int) -> FightMap:
	assert(p_id >= 0 && p_id < FIGHT_MAP_FILE_LIST.size())
	return load(DirConst.FIGHT_MAP.path_join(FIGHT_MAP_FILE_LIST[p_id]))
