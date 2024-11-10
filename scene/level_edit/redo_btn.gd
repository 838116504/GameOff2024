extends Button

var undo_redo:UndoRedo : set = set_undo_redo


func _pressed():
	if !undo_redo:
		return
	
	undo_redo.redo()

func set_undo_redo(p_value):
	undo_redo = p_value
	
	if undo_redo:
		undo_redo.version_changed.connect(_on_undo_redo_version_changed)
		disabled = !undo_redo.has_redo()

func _on_undo_redo_version_changed():
	disabled = !undo_redo.has_redo()
