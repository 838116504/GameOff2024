extends Node

const SECTION = "-"

var config := ConfigFile.new()
var save_path := ""

func get_save_path() -> String:
	if save_path == "":
		save_path = _get_save_path()
	
	return save_path

func _get_save_path() -> String:
	if OS.get_name() == "Windows":
		return OS.get_executable_path().get_base_dir() + "/config.cfg"
	
	return "user://config.cfg"

func _enter_tree():
	load_settings()

#func _input(p_event):
	#if InputMap.event_is_action(p_event, &"fullscreen"):
		#if !p_event.is_pressed():
			#if get_value("fullscreen", false):
				#set_value("fullscreen", false)
			#else:
				#set_value("fullscreen", true)
			#update_window()

func _notification(p_what):
	if p_what == NOTIFICATION_WM_WINDOW_FOCUS_OUT || p_what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()

func save_settings():
	_windows_save()
	var path = get_save_path()
# warning-ignore:return_value_discarded
	config.save(path)

func load_settings():
	var path = get_save_path()
	if FileAccess.file_exists(path):
# warning-ignore:return_value_discarded
		config.load(path)
		_windos_load()

func _windos_load():
	if OS.get_name() != "Windows":
		return
	
	update_window()
	
	if has_key("window_mode"):
		get_tree().root.mode = get_value("window_mode", get_tree().root.mode)

func update_window():
	var usableRect = DisplayServer.screen_get_usable_rect()
	if get_value("fullscreen", false):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif get_value("fake_fullscreen", false):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_tree().root.position = Vector2i.ZERO
		get_tree().root.size = DisplayServer.screen_get_size()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if has_key("window_position"):
			var pos = get_value("window_position", get_tree().root.position)
			get_tree().root.position = Vector2(max(usableRect.position.x, pos.x), max(usableRect.position.y, pos.y))
		else:
			get_tree().root.position = usableRect.position
		var maxSize = usableRect.size - get_tree().root.position
		var size
		if has_key("window_size"):
			size = get_value("window_size", get_tree().root.size)
		else:
			size = maxSize
		
		get_tree().root.size = Vector2(min(size.x, maxSize.x), min(size.y, maxSize.y))


func _windows_save():
	if OS.get_name() != "Windows":
		return
	
	if get_value("fullscreen", false):
		return
	
	set_value("window_mode", get_tree().root.mode)
	if get_tree().root.mode != Window.MODE_WINDOWED:
		var mode = get_tree().root.mode
		get_tree().root.mode = Window.MODE_WINDOWED
		set_value("window_position", get_tree().root.position)
		set_value("window_size", get_tree().root.size)
		get_tree().root.mode = mode
	else:
		set_value("window_position", get_tree().root.position)
		set_value("window_size", get_tree().root.size)

func set_value(p_key, p_value):
	config.set_value(SECTION, p_key, p_value)

func get_value(p_key, p_default = null):
	return config.get_value(SECTION, p_key, p_default)

func has_key(p_key):
	return config.has_section_key(SECTION, p_key)
