extends RefCounted
class_name GameSave

const SAVE_EXTENSION = "save"

class LevelRecord:
	var score:int
	var time:float
	
	func set_data(p_value):
		if !p_value is Array:
			return
		
		score = p_value[0]
		time = p_value[1]
	
	func get_data():
		return [ score, time ]

class LevelData:
	var finished:int = 0
	var record:LevelRecord
	
	func add_record(p_score:int):
		if record && record.score >= p_score:
			return
		
		record = LevelRecord.new()
		record.score = p_score
		record.time = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	
	func set_data(p_value):
		if !p_value is Array:
			return
		
		finished = p_value[0]
		if p_value[1] != null:
			record = LevelRecord.new()
			record.set_data(p_value[1])
		else:
			record = null
	
	func get_data():
		var ret = [ finished ]
		if record:
			ret.append(record.get_data())
		else:
			ret.append(null)
		
		return ret

var id:int
var player_name:String = "player"
var play_time:float = 0
var save_unix_time:int = 0
var level_data_list := []


func finish_level(p_id:int):
	if p_id >= level_data_list.size():
		for _i in p_id + 1 - level_data_list.size():
			level_data_list.append(LevelData.new())
	
	level_data_list[p_id].finished = 1

func add_level_record(p_id:int, p_score:int):
	if p_id >= level_data_list.size():
		for _i in p_id + 1 - level_data_list.size():
			level_data_list.append(LevelData.new())
	
	level_data_list[p_id].add_record(p_score)

func get_play_time_text() -> String:
	var hours = int(play_time / 3600.0)
	var restSec = play_time - hours * 3600
	var mins = int(restSec / 60.0)
	restSec -= mins * 60
	var ret = ""
	if hours > 0:
		ret += str(hours) + tr("TS_HOUR")
	if mins > 0:
		ret += str(mins) + tr("TS_MINUTE")
	
	ret += str(restSec) + tr("TS_SECOND")
	
	return ret

func get_save_time_text() -> String:
	return Time.get_datetime_string_from_unix_time(save_unix_time)

func set_data(p_data):
	if !p_data is Dictionary:
		return
	
	var levelDatas = p_data.level_data_list
	p_data.erase("level_data_list")
	level_data_list.clear()
	for i in levelDatas.size():
		var data = LevelData.new()
		data.set_data(levelDatas[i])
		level_data_list.append(data)
	
	var keys = p_data.keys()
	var values = p_data.values()
	for i in keys.size():
		set(keys[i], values[i])

func get_data():
	var ret = { "player_name":player_name, "play_time":play_time, "save_unix_time":save_unix_time }
	
	var levelDatas = []
	levelDatas.resize(level_data_list.size())
	for i in level_data_list.size():
		levelDatas[i].append(level_data_list[i].get_data())
	
	ret.level_data_list = levelDatas
	
	return ret


static func get_save_dir() -> String:
	var ret:String = OS.get_executable_path().get_base_dir()
	ret = ret.path_join(DirConst.GAME_SAVE)
	if !DirAccess.dir_exists_absolute(ret):
		DirAccess.make_dir_absolute(ret)
	
	return ret
 
static func get_save_path(p_id:int) -> String:
	var filename = "main." + SAVE_EXTENSION
	var dir = get_save_dir().path_join(str(p_id) + "/")
	return dir.path_join(filename)

static func load_save(p_id:int) -> GameSave:
	var path = get_save_path(p_id)
	if !FileAccess.file_exists(path):
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var ret = GameSave.new()
	ret.set_data(file.get_var())
	ret.id = p_id
	return ret
