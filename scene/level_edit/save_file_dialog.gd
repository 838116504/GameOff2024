extends FileDialog

signal finished

var path:String = ""

func _ready():
	file_selected.connect(_file_selected)
	canceled.connect(_canceled)

func _file_selected(p_path):
	path = p_path
	finished.emit()

func _canceled():
	path = ""
	finished.emit()
